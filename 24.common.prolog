:- include('lib/solve.prolog'). day(24).

calulateMinMaxSerial(Program, MinSerial, MaxSerial) :- 
  group(Program, GroupedProgram),
  evaluate(GroupedProgram, Min, Max),
  digits_number(Min, MinSerial), digits_number(Max, MaxSerial).

group([], []).
group(Program, [H|T]) :-
  length(FirstGroup, 18),
  append(FirstGroup, OtherGroups, Program),
  metaInstruction(FirstGroup, H),
  group(OtherGroups, T).

metaInstruction([Input,ResetX,I3,I4,div{a:'z',b:26},I6,I7,I8,ResetY,I10,I11,I12,I13,ResetY,I15,I16,I17,I18], end{v:V}) :-
  Input=inp{t: 'w'}, ResetX=mul{a:'x', b: 0}, ResetY=mul{a:'y', b:0},
  I3=add{a:'x', b:'z'}, I4=mod{a:'x', b:26},
  I6=add{a:'x', b: V}, I7=eql{a:'x', b:'w'}, I8=eql{a:'x', b:0},
  I10=add{a:'y', b:25}, I11=mul{a:'y', b:'x'}, I12=add{a:'y', b:1}, I13=mul{a:'z', b:'y'},
  I15=add{a:'y', b:'w'}, I16=add{a:'y', b:_}, I17=mul{a:'y', b:'x'}, I18=add{a:'z', b:'y'}.
metaInstruction([Input,ResetX,I3,I4,div{a:'z',b:1},I6,I7,I8,ResetY,I10,I11,I12,I13,ResetY,I15,I16,I17,I18], start{v:V}) :-
  Input=inp{t: 'w'}, ResetX=mul{a:'x', b: 0}, ResetY=mul{a:'y', b:0},
  I3=add{a:'x', b:'z'}, I4=mod{a:'x', b:26},
  I6=add{a:'x', b: _}, I7=eql{a:'x', b:'w'}, I8=eql{a:'x', b:0},
  I10=add{a:'y', b:25}, I11=mul{a:'y', b:'x'}, I12=add{a:'y', b:1}, I13=mul{a:'z', b:'y'},
  I15=add{a:'y', b:'w'}, I16=add{a:'y', b:V}, I17=mul{a:'y', b:'x'}, I18=add{a:'z', b:'y'}.

evaluate(GroupedProgram, MinSerial, MaxSerial) :- evaluate(GroupedProgram, [], _, MinSerial, MaxSerial).
evaluate([], [], [], [], []).
evaluate([start{v:V}|T], StartStack, SumStack, [Min|MinSerial], [Max|MaxSerial]) :- 
  evaluate(T, [start{v:V}|StartStack], [Sum|SumStack], MinSerial, MaxSerial),
  ( Sum>=0 -> Min=1, Max is 9-Sum ; Min is 1-Sum, Max=9 ).
evaluate([end{v:E}|T], [start{v:S}|StartStack], [Sum|SumStack], [Min|NextMinSerial], [Max|NextMaxSerial]) :- 
  Sum is S+E, ( Sum>=0 -> Min is 1+Sum, Max is 9 ; Min=1, Max is 9+Sum ),
  evaluate(T, StartStack, SumStack, NextMinSerial, NextMaxSerial).

digits_number(DigitList, Number) :- digits_number(DigitList, _, Number).
digits_number([], 1, 0).
digits_number([H|T], Factor, Number) :- digits_number(T, FactorT, NumberT), Number is H*FactorT + NumberT, Factor is FactorT*10.

/* required for loadData */
data_line(inp{t:  Target}, Line) :- string_concat("inp ", Params, Line), string_chars(Params, [Target]).
data_line(add{a: A, b: B}, Line) :- string_concat("add ", Params, Line), split_string(Params, " ", "", SplitParams), maplist(string_param, SplitParams, [A, B]).
data_line(mul{a: A, b: B}, Line) :- string_concat("mul ", Params, Line), split_string(Params, " ", "", SplitParams), maplist(string_param, SplitParams, [A, B]).
data_line(div{a: A, b: B}, Line) :- string_concat("div ", Params, Line), split_string(Params, " ", "", SplitParams), maplist(string_param, SplitParams, [A, B]).
data_line(mod{a: A, b: B}, Line) :- string_concat("mod ", Params, Line), split_string(Params, " ", "", SplitParams), maplist(string_param, SplitParams, [A, B]).
data_line(eql{a: A, b: B}, Line) :- string_concat("eql ", Params, Line), split_string(Params, " ", "", SplitParams), maplist(string_param, SplitParams, [A, B]).

string_param("w", 'w').
string_param("x", 'x').
string_param("y", 'y').
string_param("z", 'z').
string_param(String, Number) :- number_string(Number, String).


