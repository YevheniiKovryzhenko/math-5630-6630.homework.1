hw01_worker = hw01();
%%
hw_assert(abs(hw01_worker.p2(0, 1) - 2 * sqrt(3)) < 1e-8);
hw_assert(abs(hw01_worker.p2(1, 1) - 12/sqrt(3)/(1 + sqrt(4/3)))<1e-8);

hw_assert(abs(hw01_worker.p2(0, 2) - 2 * sqrt(3))<1e-8);
hw_assert(abs(hw01_worker.p2(1, 2) - 12/sqrt(3)/(1 + sqrt(4/3)))<1e-8);

% print new table
fprintf("%s\n","% n     |   choice 1   |  choice 2 ")
fprintf("%s\n","% ------|--------------|-------------")            
for i = 0:15
    fprintf("%s %5i | %11E | %11E\n",'%', i, abs(hw01_worker.p2(i, 1) - pi), abs(hw01_worker.p2(i, 2) - pi))
end

%%
hw_assert(hw01_worker.p3([1, 2, 3]) == 6);
hw_assert(hw01_worker.p3([eps, -eps]) == 0);

test_range = cell(1,30);
for i = 1:30
    a = single(rand(randi(100), 1));
    test_range{i} = a;
    hw01_worker.p4(a);
end

%%
hw_assert(hw01_worker.p5_1([1, 2, 3]) == 6);
hw_assert(hw01_worker.p5_1([eps, -eps]) == 0);

for i = test_range
    a = i{1};
    hw01_worker.p5(a);
end

function hw_assert(X)
    if X; fprintf('\t PASS\n'); else; fprintf('\t FAIL\n'); end
end
