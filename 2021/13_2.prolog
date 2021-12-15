day(13). testResult(16). groupData. solve :- ['lib/solve.prolog'], printResult.

result([InitialDots, Instructions], DotCount) :- fold(InitialDots, Instructions, FoldedDots), length(FoldedDots, DotCount), assertDots(FoldedDots).

fold(Dots, [], Dots).
fold(Dots, [Instruction1|OtherInstructions], FoldedDots) :- singleFold(Dots, Instruction1, NextDots), fold(NextDots, OtherInstructions, FoldedDots).

singleFold(Dots, Instruction, UniqueFoldedDots) :- maplist([X,Y]>>foldDot(X, Instruction, Y), Dots, FoldedDots), unique(FoldedDots, UniqueFoldedDots).

unique([], []). unique([H|T], Unique) :- unique(T, TUnique), (member(H, TUnique) -> Unique = TUnique ; Unique = [H|TUnique]).

foldDot(dot{x: XIn, y: YIn}, fold{axis: 'x', at: Line}, dot{x: XFold, y: YIn}) :- mirror(XIn, Line, XFold).
foldDot(dot{x: XIn, y: YIn}, fold{axis: 'y', at: Line}, dot{x: XIn, y: YFold}) :- mirror(YIn, Line, YFold).
mirror(Value, At, MirroredValue) :- (Value < At -> MirroredValue = Value ; MirroredValue is (2 * At - Value)).

/* required for loadData */
data_line(Dot, Line) :- dot_line(Dot, Line).
data_line(Instruction, Line) :- instruction_line(Instruction, Line).

dot_line(dot{x: X, y: Y}, Line) :- split_string(Line, ',', '', [XStr, YStr]), number_string(X, XStr), number_string(Y, YStr).
instruction_line(Instruction, Line) :- split_string(Line, '=', '', [Axis, FoldLineStr]), number_string(FoldLine, FoldLineStr), instruction(Axis, FoldLine, Instruction).
instruction("fold along x", FoldLine, fold{axis: 'x', at: FoldLine}).
instruction("fold along y", FoldLine, fold{axis: 'y', at: FoldLine}).

/* output */
print(Dots) :- cursorPosition(Pos), writeln(""), print_(Dots), Right is Pos - 1, moveCursor(1, 'up'), moveCursor(Right, 'right').
print_([]).
print_([Dot1|OtherDots]) :- printDot(Dot1, "X"), print_(OtherDots).
printDot(Dot, Char) :- moveCursor(Dot.x, 'right'), moveCursor(Dot.y, 'down'), write(Char), moveCursor(1, 'left'), moveCursor(Dot.x, 'left'), moveCursor(Dot.y, 'up').

assertDots(Dots) :- retractall(dots(_)), assert(dots(Dots)).
/*assertPicSize(Dots) :- picSize(Dots, X, Y), retractall(picSize(_, _)), assert(picSize(X, Y)).*/
picSize(X, Y) :- dots(Dots), picSize(Dots, X, Y).
picSize([], 0, 0).
picSize([Dot1|OtherDots], X, Y) :- picSize(OtherDots, XO, YO), X is max(Dot1.x, XO), Y is max(Dot1.y, YO).

finalize :- dots(Dots), print(Dots), picSize(X, Y), write("\r"), Down is Y + 1, moveCursor(Down, 'down'), Right is X + 1, moveCursor(Right, 'right').