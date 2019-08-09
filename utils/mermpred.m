function varargout=mermpred(instrument, tst, trn, deg, pt, xver)

%function varargout=mermpred(instrument, trainSize, testSize, degree, xver)


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

% get the latitudes, longitudes and datetimes
lats=str2num(char(float_data(:,4)));
longs=str2num(char(float_data(:,5)));


%add wrap around for longitude values
longs(longs < 0) = longs(longs < 0) + 360;
n = length(lats);

t=strcat(char(float_data(:,2)), '|', char(float_data(:,3)));

times=datenum(datetime(t,'InputFormat','dd-MMM-yyyy|HH:mm:ss'));


iters = n-trn-tst;

t = NaN(iters, tst);
err = NaN(iters, tst);
err_fit = NaN(iters, deg + 1);

if tst == 0
    last_date = times(n);
    times = times - last_date;
    fitLongs = generateL2(times(n-trn+1:n), longs(n-trn+1:n), deg);
    fitLats = generateL2(times(n-trn+1:n), lats(n-trn+1:n), deg);
else
    for i=trn:n-tst
        times = times - times(i);
        fitLongs = generateL2(times(i-trn+1:i), ...
            longs(i-trn+1:i), deg);
        fitLats = generateL2(times(i-trn+1:i), ...
            lats(i-trn+1:i), deg);

        if tst > 0
            % test lat, longs and times
            test_lats = lats(i+1:i+tst);
            test_longs = longs(i+1:i+tst);
            test_times = times(i+1:i+tst);
     
            lat_pred = evalpol(fitLats, test_times);
            lon_pred = evalpol(fitLongs, test_times);

            % errors as the distance between predicted and actual locations
            errors = transpose(haversine(test_lats, test_longs, ...
                lat_pred, lon_pred)) * 0.001;
            
            t(i-trn+1,:) = transpose(test_times);
            err(i-trn+1,:) = errors;
            
            % fit for error variation with time
            err_fit(i-trn+1,:) = generateL2(test_times,...
                transpose(errors), 2);
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
    if pt < 1
        error = [mean(t); mean(err)];
    else
        error = [t((iters-pt),:); err((iters-pt),:)];
    end
    varns = {error, mean(err_fit), std(err_fit)};
      
end
varargout = varns(1:nargout);

