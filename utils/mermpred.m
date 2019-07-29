function varargout=mermpred(instrument, tst, trn, deg, pt, xver)
% function varargout=mermpred(instrument, tst, trn, deg, pt, xver)
%
% This produces predictions for the location of a mermaid instrument
% based on its previous locations. Can also test these predictions and
% returns the errors pertaining to these predictions
%
% -------------------------------
% Inputs:
% INSTRUMENT: Name of the instrument (eg P016)

% TST: Size of the test set. If this is zero then no testing of the
% predictions is done. Default is zero.
%
% TRN: Size of the training set. Must be greater than 1.
%
% DEG: Degree of the polynomial used for the linear model. Default value is
% 2.
%
% PT: specifying different integer values for this allows you to measure
% accuracy for just a specific row across all floats. Caution must be used
% when choosing values greater than 10 as there might not be enough data
% and errors might be thrown. When given a value less than or equal to zero,
% the accuracy is based off of the means of the errors for a number of
% rows of data. Values less than or equal to zero result in default
% behaviour
%
% -------------------------------
% Output depend on the value of TST. 
%
% Output if TST == 0:
% FITLONGS: The model for predicting variation of longitude with time.
% Units are degrees for longitude and days for time.
%
% FITLATS: the model for predicting variation of latitude with time. Units
% are degrees for latitude and days for time.
%
% LASTDATE: The most recent date for which the mermaid reported data
%
% Output otherwise (when testing has been done):
% ERROR: This returns the accuracies of prediction. Returns a two row
% matrix where the top row is the number of days out for
% which the prediction was tested and the bottom row is the the distance in
% km between the predicted location at this date and the actual location
% reported. Default behaviour is to return the mean times and mean errors
% across all the iterations. If PT is given a value greater than zero then
% it returns the times and errors for one specific iteration of the testing
% process
% 
% Example usage
% [lonFit, latFit] = mermpred('P016') returns the longitude and latitude
% fits useful for predicting the location for PO16, using a training set of
% 5 points
% err = mermpred('P016', 6, 5, 2); returns the errors a fit for P016, using
% training set of 6, test set of 5 points and a polynomial degree of 2
%
% Last modified by mwesigwa@princeton.edu


%default values
defval('instrument', 'P016');
defval('trn', 5);
defval('tst', 0);
defval('deg', 2);
defval('xver', 0);
defval('pt', 0);

% url for the instrument

% get the data for this instrument
float_data = parsemermaiddata(instrument);

% get the latitudes, longitudes
lats=str2num(char(float_data(:,4)));
longs=str2num(char(float_data(:,5)));


%add wrap around for longitude values
longs(longs < 0) = longs(longs < 0) + 360;
n = length(lats);

% get the datenums for the times
t=strcat(char(float_data(:,2)), '|', char(float_data(:,3)));
times=datenum(datetime(t,'InputFormat','dd-MMM-yyyy|HH:mm:ss'));

% number of points for which we are testing
iters = n-trn-tst;

% prediction times for which models are tested
t = NaN(iters, tst);

% error of of models tested at these times
err = NaN(iters, tst);


if tst == 0 % do not test in this case
    last_date = times(n);
    times = times - last_date;
    fitLongs = generateL2(times(n-trn+1:n), longs(n-trn+1:n), deg);
    fitLats = generateL2(times(n-trn+1:n), lats(n-trn+1:n), deg);
else % test in this case
    for i=trn:n-tst
        times = times - times(i);
        fitLongs = generateL2(times(i-trn+1:i), ...
            longs(i-trn+1:i), deg);
        fitLats = generateL2(times(i-trn+1:i), ...
            lats(i-trn+1:i), deg);

        if tst > 0
            test_lats = lats(i+1:i+tst);
            test_longs = longs(i+1:i+tst);
            test_times = times(i+1:i+tst);
            
            lat_pred = evalpol(fitLats, test_times);
            lon_pred = evalpol(fitLongs, test_times);

            t(i-trn+1,:) = transpose(test_times);
            err(i-trn+1,:) = transpose(haversine(test_lats, test_longs, ...
                lat_pred, lon_pred)) * 0.001;
        end
    end
end

if xver==1
    subplot(2,2,1);
    qqplot(longErrors)

    subplot(2,2,2);
    qqplot(latErrors)

    subplot(2,2,3)
    plot(abs(longErrors))

    subplot(2,2,4)
    plot(abs(latErrors))
end
   
if tst == 0
    varns={fitLongs, fitLats, last_date};
else
    if pt < 0
        error = [mean(t); mean(err)];
    else
        error = [t((iters-pt),:); err((iters-pt),:)];
    end
    varns = {error};
      
end
varargout = varns(1:nargout);

