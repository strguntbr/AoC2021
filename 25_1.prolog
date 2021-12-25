:- include('lib/solve.prolog'). day(25). testResult(58).

result(Map, Count) :- move(Map, Count).

move(Map, Count) :-
  moveLines(Map, IntermediateMap, M1),
  moveRows(IntermediateMap, NextMap, M2),
  (
    M1+M2 > 0 -> move(NextMap, NextCount), Count is NextCount + 1
    ; Count = 1
  ).

moveLines(Map, MovedMap, Movements) :-
  maplist(moveLine, Map, MovedMap, M), sum_list(M, Movements).
moveLine([H|Line], MovedLine, Movements) :- last(Line, Last), append([H|Line], [H], ExtendedLine), doMoveLine([Last|ExtendedLine], [_|MovedLine], Movements).
doMoveLine(['>', '.'], ['.'], 0) :- !.
doMoveLine([X, _], [X], 0) :- !.
doMoveLine(['>','.'|ER], ['.','>'|ERn], M) :- !, doMoveLine(['.'|ER], [_|ERn], MN), M is MN + 1.
doMoveLine([E1,E2|ER], [E1|ERn], M) :- !, doMoveLine([E2|ER], ERn, M).
  
moveRows(Map, MovedMap, Movements) :-
  headRow(Map, H, T) -> moveRow(H, MovedH, M1), moveRows(T, MovedT, M2), headRow(MovedMap, MovedH, MovedT), Movements = M1+M2
  ; MovedMap = Map, Movements = 0.
moveRow([H|Row], MovedRow, Movements) :- last(Row, Last), append([H|Row], [H], ExtendedRow), doMoveRow([Last|ExtendedRow], [_|MovedRow], Movements).
doMoveRow(['v', '.'], ['.'], 0) :- !.
doMoveRow([X, _], [X], 0) :- !.
doMoveRow(['v','.'|ER], ['.','v'|ERn], M) :- !, doMoveRow(['.'|ER], [_|ERn], MN), M is MN + 1.
doMoveRow([E1,E2|ER], [E1|ERn], M) :- !, doMoveRow([E2|ER], ERn, M).

headRow([], [], []) :- !.
headRow([[HH|HT]|T], [HH|TH], [HT|TT]) :- !,
  headRow(T, TH, TT).

/* required for loadData */
data_line(Row, Line) :- string_chars(Line, Row).
