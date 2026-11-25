% Transcribed from the graduation thesis PDF (Aswan University, 2024).
% Spacing and line breaks come from the PDF text, so minor edits may be needed to run it.

% (a) Constant Current

            % Given %
            Vg = 25;
            R = 10;
            Fs = 40 * 10^3;

            L = 400 * 10^ -6;
            C = 231.3* 10^ -6;
            Q = R * sqrt ( C / L ) ;
            W0 = 1/ sqrt ( L * C ) ;
               Fc = Fs /10 ;
            W = 2 * pi * Fc ;
               Pm = 60 ;

                % %%%%%%%%%%%%         INNER LOOP     %%%%%%%%%%%%%%%%%

            % Calculating Ki , Kp %
            syms Ki Kp ;

             [ solx , soly ] = vpasolve ( 20* log10 ( Vg / R ) + 20* log10
                 ( Ki ) + 20* log10 ( sqrt ( 1 + ( Kp * W / Ki ) ^2 ) ) + 20*
                 log10 ( sqrt ( 1 + ( W * R * C ) ^2 ) ) ...
                                              -20* log10 ( sqrt ((1 -( W / W0 ) ^2)
                                                 ^2 + ( W /( Q * W0 ) ) ^2) ) - 20 *
                                                    log10 ( W ) == 0 , ...
                                              -90 + atand ( Kp * W / Ki ) +
                                                 atand ( C * R * W ) - atand ( W /
                                                    ( Q * W0 * (1 - ( W / W0 ) ^2)
                                                 ))    == Pm ) ;

             Ki2 = eval ( solx ) ;
             Kp2 = eval ( soly ) ;

             % Compancated system ( Ts ) %

            s = tf ( 's ') ;

            PI = Kp2 + Ki2 / s ;
            Gc = PI ;
            Gid = ( Vg / R ) *( 1 + s * R * C ) / (1 + ( s /( Q * W0 ) ) + ( s
                / W0 ) ^2 ) ;
            Ts = Gc * Gid ;

            % loop gain ( open loop )        %

            % margin ( Ts )

            % Closed loop ( Gic ) %

            Gic = Ts /(1+ Ts ) ;
            step ( Ts /(1+ Ts ) )

     (b) Constant Voltage

            % Given %
            Vg = 25;
            R = 20;
            Fs = 40 * 10^3;
            L = 400 * 10^ -6;
            C = 231.3* 10^ -6;
            Q = R * sqrt ( C / L ) ;
            W0 = 1/ sqrt ( L * C ) ;
            Fc = 400;
            W = 2 * pi * Fc ;
               Pm = 60 ;
             Kci = 4.969370798305144 e +03;
             Kcp = 0.342233051069636;

            s = tf ( 's ') ;
            Gci = Kcp + Kci / s ;

            Gid = ( Vg / R ) *( 1 + s * R * C ) / (1 + ( s /( Q * W0 ) ) + ( s
               / W0 ) ^2 ) ;
            Ts = Gci * Gid ;
            Gic = Ts / (1 + Ts ) ;
            Z = R /(1 + ( R * C * s ) ) ;
            Tvu = Gic * Z ;

             margin ( Tvu )
            % h = gcr ;
            % h . AxesGrid . Xunits = 'Hz ';

            % bode ( Tvu_magnitude , Tvu_phase ) = ( Tvu , 2* pi * FC ) ;
            [ Tvu_magnitude , Tvu_phase ] = bode ( Tvu , 2* pi * Fc ) ;

            mag = -20* log10 ( Tvu_magnitude ) ;
            Phase = -(180 + Tvu_phase - 60) ;
            % Calculating Ki , Kp %
            syms Ki Kp ;

              [ solx , soly ] = vpasolve ( 20* log10 ( Ki ) + 20* log10 (
                  sqrt ( 1 + ( Kp * W / Ki ) ^2 ) ) - 20* log10 ( W ) == mag ,
                  ...
                                            -90 + atand ( Kp * W / Ki )   ==
                                                Phase )    ;

             Ki2 = eval ( solx ) ;
             Kp2 = eval ( soly ) ;

             Gcv = Kp2 + Ki2 / s ;

              Tv =       Gcv * Tvu ;

              Gvc = Tv /(1 + Tv ) ;

              step ( Tv /(1+ Tv ) ) ;
              margin ( Gvc )

      (c) PSIM C block (PI Digital control used in Figure2.16 and 2.22)

            #d e f i n e Kp 0 . 3 4 2 2 3 3 0 5 1 0 6 9 6 3 6
            #d e f i n e KI      4 . 9 6 9 3 7 0 7 9 8 3 0 5 1 4 4 e+03
            #d e f i n e T d e l t
            s t a t i c double e r r o r ;
            s t a t i c double e r r o r p r e v ;
            s t a t i c double i n t e g =0;
            s t a t i c double p i n t e g =0;
            s t a t i c double r e f = 1 ;
            e r r o r = ( x1 ) ;

            i n t e g=p i n t e g+T∗KI∗ e r r o r p r e v ;
            y1= (Kp∗ e r r o r ) + i n t e g ;

            errorprev = error ;
            p i n t e g=i n t e g ;

     (d) PSIM C block (PI Digital control 1 used in Figure 2.22)

            #d e f i n e Kp 0 . 3 4 2 2 3 3 0 5 1 0 6 9 6 3 6
            #d e f i n e KI      4 . 9 6 9 3 7 0 7 9 8 3 0 5 1 4 4 e+03
            #d e f i n e T d e l t
            s t a t i c double e r r o r ;
            s t a t i c double e r r o r p r e v ;
            s t a t i c double i n t e g =0;

            s t a t i c double p i n t e g =0;
            s t a t i c double r e f = 1 ;
            e r r o r = ( x1 ) ;

            i n t e g=p i n t e g+T∗KI∗ e r r o r p r e v ;
            y1= (Kp∗ e r r o r ) + i n t e g ;

            errorprev = error ;
            p i n t e g=i n t e g ;

      (e) PSIM C block (Charging battery used in Figure 2.24)

             // i n p u t v a r i a b l e s
                   double x_current ;
                   double x_voltage ;

                   // output v a r i a b l e s
                   double y_outer ;
                   double y_inner ;

                   // r e f e r e n c e v a r i a b l e s
                   double I _ r e f ;
                   double V_ref ;

                   // I n p u t s
                   double V_inductor = x3 ;
                   double V_battery = x2 ;
                   double SOC = x1 ;

                   double I _ i n d u c t o r = V_inductor / 0 . 0 0 1 ;

                          // V o l t a g e PI

                    #d e f i n e Kp_V 0 . 4 6 1 0 8 4 3 1 1 7 6 0 7 7 1
             #d e f i n e KI_V 9 . 5 7 6 2 9 3 1 5 6 1 4 9 1 3 8 e+02
             #d e f i n e T d e l t

              s t a t i c double errorprev_V = 0 ;
              s t a t i c double integ_V = 0 ;
              s t a t i c double pinteg_V = 0 ;

                     // Current PI
            #d e f i n e Kp_I 0 . 3 4 2 2 3 3 0 5 1 0 6 9 6 3 6
            #d e f i n e KI_I 4 . 9 6 9 3 7 0 7 9 8 3 0 5 1 4 4 e+03
            // #d e f i n e T d e l t

            s t a t i c double e r r o r p r e v _ I = 0 ;
            s t a t i c double i n t e g _ I = 0 ;
            s t a t i c double p i n t e g _ I = 0 ;

                   //////////////////////////////////////

            i f (SOC < 9 0 . 6 6 7 8 8 ) {                                // CC
                   I_ref = 5 . 4 ;                                        // R e f e r e n c e c u r r e n t
                   x_current = I _ r e f − I _ i n d u c t o r ;

            } e l s e i f (SOC >= 9 0 . 6 6 7 8 8 ) {                     // CV
                   V_ref = 4 . 5 ;                                        // R e f e r e n c e v o l t a g e
                   x_voltage = V_ref − V_battery ;

                     double error_V = x_voltage ;

                      integ_V = pinteg_V + T ∗ KI_V ∗ errorprev_V ;
                      y_outer = (Kp_V ∗ error_V ) + integ_V ;

                     errorprev_V = error_V ;
                     pinteg_V = integ_V ;

                   x_current = y_outer − I _ i n d u c t o r ;
            }

            double e r r o r _ I = x_current ;

            i n t e g _ I = p i n t e g _ I + T ∗ KI_I ∗ e r r o r p r e v _ I ;
            y_inner = (Kp_I ∗ e r r o r _ I ) + i n t e g _ I ;

            errorprev_I = error_I ;
            pinteg_I = integ_I ;

                  y1 = y_inner ;
