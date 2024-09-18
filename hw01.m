% Author: Your Name / your_email
% Date: 2024-09-01
% Assignment Name: hw01

classdef hw01
    methods (Static)

        function p1()
            % This function only contains comments. Fill the following table. Do not write any code here.
            % :return: no returns

            % Write your result and explanation for each command here.
            % 
            % commands         |  results      | explanations
            % -----------------|---------------|-----------------------------------
            % eps              | 2.220446049250313e-16      | Floating-point relative accuracy                                              
            % realmax          | 1.797693134862316e+308     | Largest positive floating-point number
            % realmin          | 2.225073858507201e-308     | Smallest normalized floating-point number
            % 1 + eps - 1      | 2.220446049250313e-16      | Floating-point relative accuracy is repespeted
            % 1 + eps/2 - 1    | 0                          | eps/2 is less then eps, therefore it is rounded to zero 
            % realmin/1e10     | 2.225074042610638e-318     | de-normalized value (gradually loosing sig-figs when underflow occurs)
            % realmin/1e16     | 0                          | underflow, rounding to zero (too small of a value, not enough sig figs)
            % realmax*10       | inf                        | overflow
        end

        function s_n = p2(n, choice)
            % This function computes the Archimedes' method for pi.
            % :param n: the number of sides of the polygon
            % :param choice: 1 or 2, the formula to use
            % :return: s_n, the approximation of pi using Archimedes' method.

            % Tabulate the error of |s_n - pi| for n = 0, 1, 2, ..., 15 and choice = 1 and 2.
            % for both choices of formulas.
            % n     |   choice 1   |  choice 2 
            % ------|--------------|-------------
            %     0 | 3.225090E-01 | 3.225090E-01
            %     1 | 7.379766E-02 | 7.379766E-02
            %     2 | 1.806729E-02 | 1.806729E-02
            %     3 | 4.493562E-03 | 4.493562E-03
            %     4 | 1.121946E-03 | 1.121946E-03
            %     5 | 2.803964E-04 | 2.803964E-04
            %     6 | 7.009347E-05 | 7.009347E-05
            %     7 | 1.752301E-05 | 1.752301E-05
            %     8 | 4.380734E-06 | 4.380732E-06
            %     9 | 1.095227E-06 | 1.095182E-06
            %    10 | 2.742838E-07 | 2.737953E-07
            %    11 | 7.203280E-08 | 6.844882E-08
            %    12 | 1.815175E-08 | 1.711221E-08
            %    13 | 3.468891E-08 | 4.278053E-09
            %    14 | 1.815175E-08 | 1.069515E-09
            %    15 | 7.177078E-07 | 2.673808E-10

            % Explanation of the results (why there is a difference between the two choices):
            %
            % The second formula does not involve subtraction, therefore
            % is more accurate when adding small contributions.
            %
            %
            %
            %
            
            % Write your code here
            p_n = 1/sqrt(3);
            if choice == 1
                % Use the 1st formula
                for i = 1:n
                    p_n = (sqrt(1 + p_n^2) - 1) / p_n;
                end                
            else
                % Use the 2nd formula
                for i = 1:n
                    p_n = p_n / (1 + sqrt(1 + p_n^2));
                end 
            end
            s_n = 2^n * 6 * p_n;
        end

        function s = p3(a)
            % This function computes the Kahan summation algorithm.
            % :param a: a vector of numbers
            % :return: summation of the vector a using Kahan summation algorithm
            
            err = 0;
            s = a(1);
            for j = 2:length(a)
                s_prev = s;
                y = a(j) - err;
                s = s_prev + y;
                err = (s - s_prev) - y;                
            end
        end

        function p4(test_range)
            disp("Error under single precision.")
            opt = {"Naive", "Kahan"};
            tmp = fprintf("%4s | %12s | %12s | %12s\n", "n", opt{:}, "Best Method");
            for i = 1:tmp
                fprintf("-");
            end
            fprintf("\n");
            res_count = zeros(1,length(opt));
            for i = test_range
                a = i{1};
                % This function test the performance of Kahan summation algorithm against native sum.
                % :param a: a vector of numbers in double precision.
                % :return: no returns
    
                % Test this function with a = rand(n, 1) with various size n multiple times. 
                % Summarize your findings below.
                %
                % Findings:
                % 
                % Matlab's sum uses naive implementation and suffers from
                % roundoff/occumulation error, while Kahan compensated
                % summation does not. 
                %
                % Correction: I actually made a mistake and used initial
                % inputs as all single. When switching back to double for
                % baseline, the Naive sum of matlab endded up being better 
                % at very few instances (idk why) or matching Kahan. Although,
                % Kahan sum is still performing far more better (overall)
                %
                
                single_a = single(a); % Convert a to single precision
                s = hw01.p3(a); % Kahan sum of a under double precision (regarded as truth).
    
                single_Kahan_s = hw01.p3(single_a); % Kahan sum of single_a under single precision.
                single_naive_s = sum(single_a); % Naive sum of single_a under single precision.
       
                % disp(['Error of naive sum under single precision: ', num2str(single_naive_s-s)]);
                % disp(['Error of Kahan sum under single precision: ', num2str(single_Kahan_s-s)]);
                
                res = {abs(single_naive_s-s), abs(single_Kahan_s-s)};
                val = [res{:}] == min([res{:}]);
                res_str = "";
                tmp_multires = false;
                for ii = 1:length(res_count)
                    if val(ii)
                        res_count(ii) = res_count(ii) + 1;
                        if tmp_multires
                            res_str = sprintf("%s+%s", res_str, opt{ii});
                        else
                            res_str = sprintf("%s", opt{ii});
                        end
                        tmp_multires = true;
                    end
                end
                fprintf("%4i | %12E | %12E | %12s \n",length(a), res{:}, res_str);
            end
            for i = 1:tmp
                fprintf("-");
            end
            fprintf("\n");
            [~, ind] = sort(res_count,'descend');
            fprintf("Ranking: ");
            for i = 1:length(opt)
                fprintf("%s: %i ",opt{ind(i)}, res_count(ind(i)))
            end
            fprintf("\n")
            [~, ind] = max(res_count);
            fprintf("Best Method Overall: %s\n", opt{ind});
            for i = 1:tmp
                fprintf("-");
            end
            fprintf("\n");
        end

        function p5_test(test_range)
            disp("Error under single precision.")
            opt = {"Naive", "Kahan", "Method II"};
            tmp = fprintf("%4s | %12s | %12s | %12s | %30s\n", "n", opt{:}, "Best Method");
            for i = 1:tmp
                fprintf("-");
            end
            fprintf("\n");
            res_count = zeros(1,length(opt));
            
            for i = test_range
                a = i{1};
                single_a = single(a); % Convert a to single precision
                s = hw01.p3(a); % Kahan sum of a under double precision (regarded as truth).
                
                single_naive_s = sum(single_a); % Naive sum of single_a under single precision.
                single_Kahan_s = hw01.p3(single_a); % Kahan sum of single_a under single precision.
                single_method_2_s = hw01.p5(single_a); % Naive sum of single_a under single precision.
            
                % fprintf("%4i | %12E | %12E | %12E\n",length(a), abs(single_naive_s-s), abs(single_Kahan_s-s), abs(single_method_2_s-s));


                res = {abs(single_naive_s-s), abs(single_Kahan_s-s), abs(single_method_2_s-s)};
                val = [res{:}] == min([res{:}]);
                res_str = "";
                tmp_multires = false;
                for ii = 1:length(res_count)
                    if val(ii)
                        res_count(ii) = res_count(ii) + 1;
                        if tmp_multires
                            res_str = sprintf("%s+%s", res_str, opt{ii});
                        else
                            res_str = sprintf("%s", opt{ii});
                        end
                        tmp_multires = true;
                    end
                end
                fprintf("%4i | %12E | %12E | %12s | %30s\n",length(a), res{:}, res_str);
            end

            for i = 1:tmp
                fprintf("-");
            end
            fprintf("\n");
            [~, ind] = sort(res_count,'descend');
            fprintf("Ranking: ");
            for i = 1:length(opt)
                fprintf("%s: %i        ",opt{ind(i)}, res_count(ind(i)))
            end
            fprintf("\n")
            [~, ind] = max(res_count);            
            fprintf("Best Method Overall: %s\n", opt{ind});
            for i = 1:tmp
                fprintf("-");
            end
            fprintf("\n");
        end

        function s = p5(a)
            % For 6630. 
            % This function computes summation of a vector using pairwise summation.
            % :param a: a vector of numbers
            % :return: the summation of the vector a using pairwise summation algorithm.

            % ! You may need to create a helper function if your code uses recursion.

            % Rewrite the p4 test function to test this summation method.
            % Summarize your findings below.
            %
            % Findings: 
            %
            % Kahan's methods is still better. In fact this method
            % is even worse than naive sum (not sure why).
            % The implementation is still somewhat cryptic to me
            % so it might be wrong, thus leading to this result.
            % I was expecting this method to be in between naive 
            % sum and Kahan's sum.
            % 
            % Correction:
            % The second implementation corrected this.
            % Now, the Method II is at worst the same as the 
            % naive sum, but often better. Kahan's sum is still 
            % outperforming it though. You can run the hw_test
            % script to see that Method II scores about half-way
            % between Naive and Kahan's sum.
            % There are some instances where Kahan's and Naive sum
            % are both better, so I guess there is no clear cut that 100%
            % guranties one of the methods to be always better than others


            % this is wrong!
            % n = length(a);             
            % if n > 2
            %     s = (a(1) + a(2)) + hw01.p5(a(3:n));
            % elseif n == 1
            %     s = a(1);
            % else % is 2
            %     s = (a(1) + a(2));
            % end
            
            % this is better
            i = 1;
            k = length(a);
            if k == 1
                s = a(1);
            else
                s = sum(hw01.p5(a(i:floor((i+k)/2))) + hw01.p5(a(floor((i+k)/2) + 1:k)));
            end
        end
    end
end