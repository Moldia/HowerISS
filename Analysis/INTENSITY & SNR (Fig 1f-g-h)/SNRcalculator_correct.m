              % CML, 2020
close all
clear
%% user input
image_location = 'L:\4plex_assay\200313_r1c1\HalfCoronal/';
image_prefix = 'TestMipping';
% regions can denote parts of the brain for instance
region = {
    'ependymal'
    'hippo'
    'cortex'};
bases = {
    'b1'};
number_of_channels = 4;
num_bases = 1; %% change as necessary
num_scence = (1:2); % the number of slides
image_suffix = '.csv';
f_channel = { 
    'AF488'
    'AF750'
    'Cy5'
    'Cy3'
    };

%% fixing leica zero indexing
number_of_channels = number_of_channels-1;
%%
for ch = 0:number_of_channels
    for b = 1:length(bases)
       base = bases{b};
        Mean = [];
        Std = [];
        for s = 1:length(num_scence)
            scence = num_scence(s);
            for r = 1:length(region)
                region_img = region{r};
                
                csv_file = [image_location, 's', num2str(scence), '_',num2str(ch), image_suffix];
                
                tabledata = readtable(csv_file);
                arraydata = table2array(tabledata, 'grubbs');
                
                % finding the mean signal
                signalmean = mean(arraydata, 1);
                
                % calculating the mean background
                backgroundPos1 = (signalmean (:,1));
                backgroundPos2 = (signalmean (:,2));
                backgroundPos3 = (signalmean (:,20));
                backgroundPos4 = (signalmean (:, 21));
                backgroundmean = ((backgroundPos1+backgroundPos2+backgroundPos3+backgroundPos4)/4);
                
                % calculating the signal to noise ratio
                SNR = signalmean/backgroundmean;
                
                
                if s == 1 
                    SNR_12 = SNR;
                else
                    SNR_34 = SNR;
                end
            end
        end
    end
    subplot(2,2, ch+1);
    plot(SNR_12, 'MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red')
     sgt = sgtitle(['Signal to Noise Ratio (SNR) Cycle1'  ])
      sgt.FontSize = 30;
    hold on
    plot(SNR_34, 'MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red')
    title(strcat(' ', '   ', f_channel(ch+1)));
    legend direct cdna 
    xlabel ('Pixel number')
    ylabel ('Signal to noise ratio')
    ax = gca;
    ax.FontSize = 12;
    xlim([1 21])
    ylim([1 9])
end


