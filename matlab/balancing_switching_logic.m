% Transcribed from the graduation thesis PDF (Aswan University, 2024).
% Spacing and line breaks come from the PDF text, so minor edits may be needed to run it.

function [ s1 , s2 ] = fcn ( soc1 , soc2 , pulse )

      % Define a small tolerance
      tolerance = 1e-3;

      % Initialize outputs
      s1 = 0;
      s2 = 0;

      % Perform logic based on soc1 , soc2
      if soc2 < soc1 - tolerance
            s1 = pulse ;
            s2 = 0;

      elseif soc1 < soc2 - tolerance
            s1 = 0;
            s2 = pulse ;

      else % soc1 and soc2 are within the tolerance range
            s1 = 0;
            s2 = 0;

      end

      end
