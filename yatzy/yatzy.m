%Function: The main function of yatzy. Will simulate yatzy throw
%aswell as calculate a normalcurve and plot that.
%Paramaters: count : int, the number of throws to simulate
%            debug : boolean, will print debug messages
%Return value: Two values are returned [mean variance]
function [data_mean, data_variance] = yatzy(count, debug)  
    %Perform the MonteCarlo simulation
    data = monteCarlo(count, debug);
    %Plot the simulation
    histogram(data, 'BinWidth', 1)
    data_mean = mean(data, 'all');
    data_variance = var(data);
    fprintf('The max is: %d and the min: %d\n', max(data), min(data));
    hold on;
    %Calculate the analytic solution
    normalCurve = normal(max(data)) * count;
    %Plot the analytic solution
    plot(normalCurve, 'LineWidth', 2);
    legend({'Simulation (Monte Carlo)', 'Analytic solution'});
    xlabel('Number of throws to get yatzy');
    ylabel('Frequency');
    hold off;
end
%Function: This function will calculate the normal for getting a yatzy.
%Paramaters: count : int, the range of the curve
%Return value: A matrix of the data for the curve
function result = normal(count)
    A = [0  (1/6)   (1/36)  (1/216)     (1/1296);
         0  (5/6)   (10/36) (15/216)    (25/1296);
         0  0       (25/36) (80/216)    (250/1296);
         0  0       0       (129/216)   (900/1296);
         0  0       0       0           (120/1296)];
     e1 = [1 0 0 0 0];
     e5 = [0;0;0;0;1];    
     result = zeros(1, count);
     for k = 1:count
          result(k) = e1 * A^k * e5;
     end
end

%Function: This function will perfrom a Monte Carlo simulation, count is 
%the number of times it will perform the simulation
%Paramaters: count : int, how many throws to simulate 
%            debug : boolean, will print debug messages
%Return value: return a matrix of all the throws and how many throws it
%took to get a yatzy
function returnValue = monteCarlo(count, debug)  
    returnValue = zeros(1, count);    
    fprintf('Simulating %d yatzy rounds\n', count);  
    startTime = cputime;
    for i = 1:count
        returnValue(i) = fiveDies(debug); 
    end
    fprintf('\nDone!\n');
    fprintf('The time it took to run the simulation was: %.1f seconds\n\n', cputime - startTime);
end

%Function: Will throw the dies until it gets five of a kind.
%Paramaters: debug : boolean, will print debug messages
function throwCount = fiveDies(debug)
    current = [];
    %First throw, so we start at 0 throws and 5 dies.
    throwCount = 0;
    diesLeft = 5;
    while diesLeft > 0
        %This will append the "old" saved dies with the new throw.
        data = [simulateThrowDie(diesLeft, debug) current];
        if(debug)
            fmt = ['Currently have: ' repmat(' %1.0f ',1, numel(data)) '\n'];
            fprintf(fmt, data)
        end
        %Save the best dies to the next iteration
        current = findDie(data, debug);
        throwCount = throwCount + 1;
        %If we have 5 saved, i.e we have 5 of a kind then this will be zero
        %and the loop will exited after this
        diesLeft = 5 - length(current);  
    end
end

%Function: Simulates die throws, count is the number of dies thrown.
%Paramaters: count : will return a 1x6 matrix with random die throws
%            debug : boolean, will print debug messages
%Return value: a 1x6 matrix of dies
function returnValue = simulateThrowDie(count, debug)
    returnValue = randi([1 6], 1, count);   
    if(debug)
        fmt = ['Threw %d die(s) and got: ' repmat(' %1.0f ',1,numel(returnValue)) '\n'];
        fprintf(fmt, count, returnValue)
    end
end

%Function: This will sum up how many of each die there is, and returns an array of
%how how many of each 
%Paramaters: 1x6 integer matrix : A matrix of dies thrown
%Return value: Will return an 1x6 matrix of the occurence of dies
function count = countOutcome(values)
    count = zeros(1, 6);
    for i = 1:length(values)
        count(values(i)) = count(values(i)) + 1;    
    end
end

%Function: This function will check what die is the most common
%and returns what value was most common and how many there was.
%Paramaters: 1x6 integer matrix : A matrix of dies thrown
%Return value: Will return the die that was most common and how the count
%of that die
function returnValue = commonOutcome(values)
    outcomes = countOutcome(values);
    [count, value] = max(outcomes);
    returnValue = [count value];
end

%Function: This function will check what dies was most common then it will save those
%in an array and return only those.
%Paramaters: An array of size 1-6, with the dies. 
%            debug : boolean, will print debug messages
%Return value: An array with the most common dies alone.

function returnValue = findDie(values, debug)    
    outcome = commonOutcome(values);
    count = outcome(1);
    value = outcome(2);
    if(debug)
        fprintf('Saving: %d\n', value);
    end
    returnValue = zeros(1, count);
    for i = 1:count
        returnValue(i) = value;
    end
end
