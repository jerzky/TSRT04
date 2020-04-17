clear;
close all;

load datatraffic

lineGraph(years,traffic)
barGraph(years,traffic)

function lineGraph(years,traffic)
    %calculate avg amount of traffic
    avgData = traffic ./ 9.7;
  
    %figure makes it possible to have to plot windows
    figure;
    %plot the 4 lines
    total = sum(avgData,2);
    plot(years, total, "-*")
    hold on
    plot(years,avgData(:,1),"r--*")
    plot(years,avgData(:,3),"b-*")
    plot(years,avgData(:,2),"k--*")
    hold off
   
    %labels and relevant info for the user 
    xlabel("Time")
    ylabel("Data in GB")
    
    legend("Total traffic", "Video", "Web and other", "File transfer")
    title("Visual networking index")
    
    %whole years only
    set(gca,'Xtick',years)
end

function barGraph(years,traffic)
%figure makes it possible to have to plot windows
    figure;
 
    %plot two kinds of bargraphs next to eachother
    b1 = subplot(1,2,1);
    bar(years, traffic, 'grouped')
  
    b2 = subplot(1,2,2);
    bar(years, traffic, 'stacked')
    
    bars = [b1 b2];
  
    %labels and relevant info for the user 
    xlabel(bars, "years")
    ylabel(bars, "Data in petabyte")
    
    %two legend needed because there are two graphs
    legend(b1,"Video", "File transfer", "Web and other")
    legend(b2,"Video", "File transfer", "Web and other")
    title(bars, "Visual networking index")
end