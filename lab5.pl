initialState(state(room1, [], [steel_key], [bronze_key], [package])).

move(state(room1, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    move(room1, room2),
    state(room2, Robot_inv, Room1_inv, Room2_inv, Room3_inv)) :-
    member(steel_key, Robot_inv).

move(state(room2, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    move(room2, room1),
    state(room1, Robot_inv, Room1_inv, Room2_inv, Room3_inv)) :-
    member(steel_key, Robot_inv).

move(state(room1, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    move(room1, room3),
    state(room3, Robot_inv, Room1_inv, Room2_inv, Room3_inv)) :-
    member(bronze_key, Robot_inv).

move(state(room3, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    move(room3, room1),
    state(room1, Robot_inv, Room1_inv, Room2_inv, Room3_inv)) :-
    member(bronze_key, Robot_inv).

move(state(room1, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    take(Item),
    state(room1, New_Robot_inv, New_Room1_inv, Room2_inv, Room3_inv)) :-
    member(Item, Room1_inv),
    length(Robot_inv, N),
    N < 2,
    append(Robot_inv, [Item], New_Robot_inv),
    delete(Room1_inv, Item, New_Room1_inv).

move(state(room2, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    take(Item),
    state(room2, New_Robot_inv, Room1_inv, New_Room2_inv, Room3_inv)) :-
    member(Item, Room2_inv),
    length(Robot_inv, N),
    N < 2,
    append(Robot_inv, [Item], New_Robot_inv),
    delete(Room2_inv, Item, New_Room2_inv).

move(state(room3, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    take(Item),
    state(room3, New_Robot_inv, Room1_inv, Room2_inv, New_Room3_inv)) :-
    member(Item, Room3_inv),
    length(Robot_inv, N),
    N < 2,
    append(Robot_inv, [Item], New_Robot_inv),
    delete(Room3_inv, Item, New_Room3_inv). 

move(state(room1, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    drop(Item),
    state(room1, New_Robot_inv, New_Room1_inv, Room2_inv, Room3_inv)) :-
    member(Item, Robot_inv),
    append(Room1_inv, [Item], New_Room1_inv),
    delete(Robot_inv, Item, New_Robot_inv).

move(state(room2, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    drop(Item),
    state(room2, New_Robot_inv, Room1_inv, New_Room2_inv, Room3_inv)) :-
    member(Item, Robot_inv),
    append(Room2_inv, [Item], New_Room2_inv),
    delete(Robot_inv, Item, New_Robot_inv).

move(state(room3, Robot_inv, Room1_inv, Room2_inv, Room3_inv),
    drop(Item),
    state(room3, New_Robot_inv, Room1_inv, Room2_inv, New_Room3_inv)) :-
    member(Item, Robot_inv),
    append(Room3_inv, [Item], New_Room3_inv),
    delete(Robot_inv, Item, New_Robot_inv).

goal(state(room2, _, _, Room2_inv, _)) :-
    member(package, Room2_inv).

solveR(State, N, Trace) :-
    solveR_helper(State, N, [State], Trace).

solveR_helper(State, _, _, []) :- goal(State).
solveR_helper(State, N, History, [Move|Trace]) :-
    N > 0,
    move(State, Move, NewState),
    not(member(NewState, History)),
    N1 is N - 1,
    solveR_helper(NewState, N1, [NewState|History], Trace).

run :-
    solveR(state(room1, [], [steel_key], [bronze_key], [package]), 12, Trace),
    write(Trace), nl.