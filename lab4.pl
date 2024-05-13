% find all sublist in a list
sum([], 0).
sum([H|T], S) :- sum(T, S1), S is S1 + H.

allIsAndJs(N, R) :-
    findall([I, J], (between(1, N, I), between(I, N, J)), R).

allSubLists(L, R) :-
    findall(S, (append([_,S,_], L), S \= []), R).

allSums(L, R) :-
    findall(S, (member(Sub, L), sum(Sub, S)), R).

result(L, RSorted) :-
    length(L, N),
    allIsAndJs(N, IsAndJs),
    allSubLists(L, SubLists),
    allSums(SubLists, Sums),
    length(SubLists, N1),
    findall([Sum, I, J, Sub], (between(1, N1, E), nth1(E, Sums, Sum), nth1(E, IsAndJs, [I, J]), nth1(E, SubLists, Sub)), R),
    length(R, N2),
    write(N2), nl,
    sortLists(R, RSorted),
    length(RSorted, N3),
    write(N3), nl.

compareFirst( Order, A, B ) :-
    compare( Order, A, B).

sortLists( L, R ) :-
    predsort( compareFirst, L, R ).

printHeader :-
    write('Sum'), write('\t'), write('I'), write('\t'), write('J'), write('\t'), write('Sublist'), nl.

printNRows([], _).
printNRows(_, 0).
printNRows([[A, B, C, D]|T], N) :-
    N1 is N - 1,
    write(A), write('\t'), write(B), write('\t'), write(C), write('\t'), write(D), nl,
    printNRows(T, N1).

testCase4(4, [-1, 2, -3]).


testCase1(15, [-1, 2, -3, 4, -5, 6, -7, 8, -9, 10, -11, 12, -13,
    14, -15, 16, -17, 18, -19, 20, -21, 22, -23, 24, -25, 26,
    -27, 28, -29, 30, -31, 32, -33, 34, -35, 36, -37, 38, -39,
    40, -41, 42, -43, 44, -45, 46, -47, 48, -49, 50, -51, 52,
    -53, 54, -55, 56, -57, 58, -59, 60, -61, 62, -63, 64, -65,
    66, -67, 68, -69, 70, -71, 72, -73, 74, -75, 76, -77, 78,
    -79, 80, -81, 82, -83, 84, -85, 86, -87, 88, -89, 90, -91,
    92, -93, 94, -95, 96, -97, 98, -99]).
testCase2(6, [24, -11, -34, 42, -24, 7, -19, 21]).
testCase3(8, [3, 2, -4, 3, 2, -5, -2, 2, 3, -3, 2, -5, 6, -2, 2, 3]).

test1 :-
    testCase1(K, TestList),
    result(TestList, ResultSorted),
    printHeader,
    printNRows(ResultSorted, K), !.

test2 :-
    testCase2(K, TestList),
    result(TestList, ResultSorted),
    printHeader,
    printNRows(ResultSorted, K), !.

test3 :-
    testCase3(K, TestList),
    result(TestList, ResultSorted),
    printHeader,
    printNRows(ResultSorted, K), !.
test4 :-
    testCase4(K, TestList),
    result(TestList, ResultSorted),
    printHeader,
    printNRows(ResultSorted, K).

testResult1 :- testCase1(_, TestList), result(TestList, R), write(R), nl.
testResult2 :- testCase2(_, TestList), result(TestList, R), write(R), nl.
testResult3 :- testCase3(_, TestList), result(TestList, R), write(R), nl.

testArry1 :- testCase1(_, TestList), append([_, S, _], TestList), write(S), nl.
testArry2 :- testCase2(_, TestList), append([_, S, _], TestList), write(S), nl.
