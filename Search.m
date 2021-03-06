classdef Search
	% Search configurations
	% Duo Tao, 2/26/2018
	
	properties
		zoom, % the x-axis range of the plot, centerd at the single line. One-sided.
		filter, % log p-value thresold
		selected_weeks % the weeks selected, as array, in folder names. Empty to select all.
	end
	methods
		function obj = Search(zoom, filter, selected_weeks)
			obj.zoom = zoom;
			obj.filter = filter;
			if nargin == 2
				obj.selected_weeks = [];
			end
			if nargin == 3
				obj.selected_weeks = selected_weeks;
			end
		end

		function [fp, cp] = chopData(obj, data_path, freqs, coh, line)
			freqGap = freqs(2) - freqs(1);
			low = line.line - obj.zoom;
			high = line.line + obj.zoom;
			il = floor(low / freqGap) + 1;
			ih = ceil(high / freqGap) + 1;
			if il > length(coh) % no data is in the search range
				disp(strcat(data_path, ' out of range. Skipped.'));
				fp = false;
				cp = false;
				return;
			elseif ih > length(coh)
				disp(strcat(data_path, ' range chopped.'));
				ih = length(coh);
            elseif ismember(1, isnan(coh(il : ih)))
                if (sum(isnan(coh)) == length(coh))
                    disp(strcat(data_path, ' all nan.'));
                else
                    disp(strcat(data_path, '*** Attention, partial nan shows up'));
                end
                fp = false;
                cp = false;
            return;
			end
			fp = freqs(il : ih);
			cp = coh(il : ih);
		end

		function dump(obj)
			disp(strcat('Zoom: ', num2str(obj.zoom), '#', num2str(obj.filter)));
			if isempty(obj.selected_weeks)
				disp('All weeks selected.');
			else
				disp('Weeks selected:');
				for w = obj.selected_weeks
					disp(w);
				end
			end
		end
	end
end
