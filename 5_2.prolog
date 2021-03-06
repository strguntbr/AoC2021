:- include('lib/solve.prolog'). day(5). testResult(12).

result(VENTS, SCORE) :- retractall(ventAt(_, _)), retractall(dangerAt(_, _)), processVents(VENTS),  aggregate_all(count, dangerAt(_, _), SCORE).

horizontal(line{start: pos{x: X, y: _}, end: pos{x: X, y: _}}).
vertical(line{start: pos{x: _, y: Y}, end: pos{x: _, y: Y}}).
diagonal(LINE, 1, 1) :- DX is LINE.end.x - LINE.start.x, DY is LINE.end.y - LINE.start.y, DX = DY, DX > 0.
diagonal(LINE, -1, -1) :- DX is LINE.end.x - LINE.start.x, DY is LINE.end.y - LINE.start.y, DX = DY, DX < 0.
diagonal(LINE, 1, -1) :- DX is LINE.end.x - LINE.start.x, DY is LINE.start.y - LINE.end.y, DX = DY, DX > 0.
diagonal(LINE, -1, 1) :- DX is LINE.end.x - LINE.start.x, DY is LINE.start.y - LINE.end.y, DX = DY, DX < 0.

assertDangerAt(X, Y) :- dangerAt(X, Y), !. assertDangerAt(X, Y) :- assert(dangerAt(X, Y)).
mark(X, Y) :- ventAt(X, Y), !, assertDangerAt(X, Y).
mark(X, Y) :- assert(ventAt(X, Y)).

markHorizontal(X, END_Y, END_Y) :- !, mark(X, END_Y).
markHorizontal(X, Y, END_Y) :- mark(X, Y), Yn is Y+1, markHorizontal(X, Yn, END_Y).

markVertical(Y, END_X, END_X) :- !, mark(END_X, Y).
markVertical(Y, X, END_X) :- mark(X, Y), Xn is X+1, markVertical(Y, Xn, END_X).

markDiagonal(END_X, Y, _, _, END_X, _) :- !, mark(END_X, Y).
markDiagonal(X, Y, DIR_X, DIR_Y, END_X, END_Y) :- mark(X, Y), Xn is X + DIR_X, Yn is Y + DIR_Y, markDiagonal(Xn, Yn, DIR_X, DIR_Y, END_X, END_Y).

processVent(L) :- horizontal(L), !, START_Y is min(L.start.y, L.end.y), END_Y is max(L.start.y, L.end.y), markHorizontal(L.start.x, START_Y, END_Y).
processVent(L) :- vertical(L), !, START_X is min(L.start.x, L.end.x), END_X is max(L.start.x, L.end.x), markVertical(L.start.y, START_X, END_X).
processVent(L) :- diagonal(L, DIR_X, DIR_Y), !, markDiagonal(L.start.x, L.start.y, DIR_X, DIR_Y, L.end.x, L.end.y).
processVent(L) :- write(L).

processVents([]).
processVents([H|T]) :- processVent(H), processVents(T).

/* required for loadData */
data_line(line{start: START_COORDS, end: END_COORDS}, LINE) :-
  split_string(LINE, ">", "- ", [START, END]),
  string_coords(START, START_COORDS),
  string_coords(END, END_COORDS).

string_coords(STRING, pos{x: X, y: Y}) :- split_string(STRING, ",", "", [X_STR,Y_STR]), number_string(X, X_STR), number_string(Y, Y_STR).
