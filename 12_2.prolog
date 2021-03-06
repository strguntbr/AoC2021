:- include('lib/solve.prolog'). day(12). testResult('test1', 36). testResult('test2', 103). testResult('test3', 3509).

member([H|T], H, T).
member([H|T], M, [H|MT]) :- member(T, M, MT).
pickCave(CAVES, CAVE, ALREADY_PICKED, SMALL_REVISIT_ALLOWED, ANOTHER_SMALL_REVISIT_ALLOWED, REMAINING_CAVES) :-
  member(CAVES, CAVE, OTHER_CAVES),
  (
    (bigCave(CAVE) ; not(member(CAVE, ALREADY_PICKED))) -> REMAINING_CAVES = CAVES, ANOTHER_SMALL_REVISIT_ALLOWED = SMALL_REVISIT_ALLOWED
    ; SMALL_REVISIT_ALLOWED -> REMAINING_CAVES = OTHER_CAVES, ANOTHER_SMALL_REVISIT_ALLOWED = false
  ).
areConnected(START, END) :- START \= "end", END \= "start", (connection(START, END) ; connection(END, START)).
bigCave(CAVE) :- string_code(1, CAVE, LETTER), LETTER >= 65, LETTER =< 90.

path(START, START, _, _, _, []).
path(START, END, CAVES, ALREADY_PICKED, SMALL_REVISIT_ALLOWED, [NEXT|PATH]) :- 
  pickCave(CAVES, NEXT, ALREADY_PICKED, SMALL_REVISIT_ALLOWED, ANOTHER_SMALL_REVISIT_ALLOWED, REMAINING_CAVES),
  areConnected(START, NEXT),
  path(NEXT, END, REMAINING_CAVES, [NEXT|ALREADY_PICKED], ANOTHER_SMALL_REVISIT_ALLOWED, PATH).
  

findPath(CAVES, PATH) :- path("start", "end", CAVES, [], true, PATH).

result(_, PATH_COUNT) :- 
  findall(CAVE, cave(CAVE), ALL_CAVES),
  pickCave(ALL_CAVES, "start", [], false, _, CAVES),
  aggregate_all(count, findPath(CAVES, _), PATH_COUNT).

/* required for loadData */
data_line([START, END], LINE) :-
  split_string(LINE, '-', '', [START, END]), assert(connection(START, END)),
  retractall(cave(START)), retractall(cave(END)), assert(cave(START)), assert(cave(END)).

resetData :- retractall(connection(_, _)).