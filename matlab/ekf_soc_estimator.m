% Transcribed from the graduation thesis PDF (Aswan University, 2024).
% Spacing and line breaks come from the PDF text, so minor edits may be needed to run it.

function [y , z1 ] = fcn ( vk , ik , table , dOCV , OCV )

     SigmaX0 = diag ([1 e2 1e -2 1e -3]) ; % uncertainty of initial
            state
     SigmaV = 3e -1; % Uncertainty of voltage sensor , output
        equation
     SigmaW = 4 e0 ; % Uncertainty of current sensor , state
        equation

     deltat = 1 ; % Time step

     function ekfData = initEKF ( v0 , SigmaX0 , SigmaV , SigmaW )
       % Initial state description
       ir0      = 0;                                   ekfData . irInd = 1;
       hk0      = 0;                                   ekfData . hkInd = 2;
       SOC0     = table ;                              ekfData . zkInd = 3;
       ekfData . xhat       = [ ir0 hk0 SOC0 ] '; % initial state
       % Covariance values
       ekfData . SigmaX = SigmaX0 ;
       ekfData . SigmaV = SigmaV ;
       ekfData . SigmaW = SigmaW ;
       ekfData . Qbump = 5;
       % previous value of current
       ekfData . priorI = 0;
       ekfData . signIk = 0;
       % store model data structure too
     end

     function [ zk , zkbnd , ekfData ] = iterEKF ( vk , ik , ekfData )
       % Load the cell model parameters
            Q = 5.4;
            G = 153.4413;
            M = 0.0092;
            M0 = 0.0019;
            RC = 0.7608;
            R = 6.8283 e -04;
            R0 = 0.0064815;
            eta = 1;
       if ik <0 , ik = ik * eta ; end ;
       % Get data stored in ekfData structure

       I = ekfData . priorI ;
       SigmaX = ekfData . SigmaX ;
       SigmaV = ekfData . SigmaV ;
       SigmaW = ekfData . SigmaW ;
       xhat = ekfData . xhat ;
       irInd = ekfData . irInd ;
       hkInd = ekfData . hkInd ;
       zkInd = ekfData . zkInd ;
       if abs ( ik ) >Q /100 , ekfData . signIk = sign ( ik ) ; end ;
       signIk = ekfData . signIk ;
       % EKF Step 0: Compute Ahat [k -1] , Bhat [k -1]
       nx = length ( xhat ) ; Ahat = zeros ( nx , nx ) ; Bhat = zeros ( nx
            ,1) ;
       Ahat ( zkInd , zkInd ) = 1; Bhat ( zkInd ) = - deltat /(3600* Q ) ;
       Ahat ( irInd , irInd ) = diag ( RC ) ; Bhat ( irInd ) = 1 - RC (:) ;
       Ah    = exp ( - abs ( I * G * deltat /(3600* Q ) ) ) ;   % hysteresis
            factor
       Ahat ( hkInd , hkInd ) = Ah ;
       B = [ Bhat , 0* Bhat ];
       Bhat ( hkInd ) = - abs ( G * deltat /(3600* Q ) ) Ah (1+ sign ( I ) * xhat (
            hkInd ) ) ;
       B ( hkInd ,2) = Ah -1;
       % Step 1 a : State estimate time update
       xhat = Ahat * xhat + B *[ I ; sign ( I ) ];
       % Step 1 b : Error covariance time update
       %                  sigmaminus ( k ) = Ahat (k -1) * sigmaplus (k -1) *
            Ahat (k -1) ' + ...
       %                                      Bhat (k -1) * sigmawtilde * Bhat (k
            -1) '
       SigmaX = Ahat * SigmaX * Ahat ' + Bhat * SigmaW * Bhat ';
       % Step 1 c : Output estimate

       yhat = OCV + M0 * signIk + ...
                  M * xhat ( hkInd ) - R * xhat ( irInd ) - R0 * ik ;

       % Step 2 a : Estimator gain matrix
       Chat = zeros (1 , nx ) ;
       Chat ( zkInd ) = dOCV ;
       Chat ( hkInd ) = M ;
       Chat ( irInd ) = -R ;
       Dhat = 1;
       SigmaY = Chat * SigmaX * Chat ' + Dhat * SigmaV * Dhat ';
       L = SigmaX * Chat '/ SigmaY ;

       % Step 2 b : State estimate measurement update
       r = vk - yhat ; % residual .           Use to check for sensor
            errors ...
       if r ^2 > 100* SigmaY , L (:) =0.0; end
       xhat = xhat + L * r ;
       xhat ( hkInd ) = min (1 , max ( -1 , xhat ( hkInd ) ) ) ; % Help
            maintain robustness
       xhat ( zkInd ) = min (1.05 , max ( -0.05 , xhat ( zkInd ) ) ) ;

       % Step 2 c : Error covariance measurement update
       SigmaX = SigmaX - L * SigmaY *L ';
             % Q - bump code
       if r ^2 > 4* SigmaY , % bad voltage estimate by 2 std .
            devs , bump Q
             fprintf ( ' Bumping SigmaX \ n ') ;
            SigmaX ( zkInd , zkInd ) = SigmaX ( zkInd , zkInd ) * ekfData .
               Qbump ;
       end
       [~ ,S , V ] = svd ( SigmaX ) ;

       HH = V * S *V ';
       SigmaX = ( SigmaX + SigmaX ' + HH + HH ') /4; % Help
            maintain robustness

       % Save data in ekfData structure for next time ...
       ekfData . priorI = ik ;
       ekfData . SigmaX = SigmaX ;
       ekfData . xhat = xhat ;
       zk = xhat ( zkInd ) ;
       zkbnd = 3* sqrt ( SigmaX ( zkInd , zkInd ) ) ;
     end

       ekfData =       initEKF ( vk , SigmaX0 , SigmaV , SigmaW ) ;
       % Update SOC ( and other model states )
       [ sochat , socbound , ekfData ] = iterEKF ( vk , ik , ekfData ) ;

     y = sochat ;
     z1 = xhat ( zkInd ) ;

     end
