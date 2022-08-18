% Row 1
wall([X,1]) :- X =\= 2.
% Row 2
wall([X,2]) :- X = 1; X = 4; X = 6.
% Row 3
wall([X,3]) :- X = 1; X = 2; X = 6.
% Row 4
wall([X,4]) :- X =\= 3,X =\= 5.
% Row 5
wall([X,5]) :- X = 1; X = 4; X = 6.
% Row 6
wall([X,6]) :- X =\= 2.
% Start / end
start([2,1]).
end([2,6]).
% Maze Size
mazeSize([6,6]).

badSpot([X,Y]) :- wall([X,Y]).
badSpot([X,Y]) :- X < 1; Y < 1.
badSpot([X,Y]) :- mazeSize([W, H]), (X > W; Y > H).

%up
move([CurrX, CurrY], [CurrX, NextY]) :- NextY is CurrY - 1.
%down
move([CurrX, CurrY], [NextX, NextY]) :- NextY is CurrY + 1, NextX = CurrX.
%left
move([CurrX, CurrY], [NextX, NextY]) :- NextY = CurrY, NextX is CurrX - 1.
%right
move([CurrX, CurrY], [NextX, NextY]) :- NextY = CurrY, NextX is CurrX + 1.

%check for walls
right([CurrX, CurrY]) :- Right is CurrX + 1, wall([Right, CurrY]).
left([CurrX, CurrY]) :- Left is CurrX - 1, wall([Left, CurrY]).
top([CurrX, CurrY]) :- Up is CurrY - 1, wall([CurrX, Up]).
bottom([CurrX, CurrY]) :- Down is CurrY + 1, wall([CurrX, Down]).

%check for down move
%if true downmove true
moveCheck([CurrX, CurrY], [NextX, NextY], [NNX, NNY]) :- (NextY is CurrY + 1, NextX = CurrX),
					     		 downMove,([NextX, NextY], [NNX, NNY]).
%check for up move
%if true upmove true
moveCheck([CurrX, CurrY], [NextX, NextY], [NNX, NNY]) :- (NextY is CurrY - 1, NextX = CurrX),
					     		 upMove([NextX, NextY], [NNX, NNY]).
%check for left move
%if true leftmove true
moveCheck([CurrX, CurrY], [NextX, NextY], [NNX, NNY]) :- NextX is CurrX - 1, NextY = CurrY,
							 leftMove([NextX, NextY], [NNX, NNY]).
%check for right move
%if true rightmove true
moveCheck([CurrX, CurrY], [NextX, NextY], [NNX, NNY]) :- NextX is CurrX + 1, NextY = CurrY,
					     		 rightMove([NextX, NextY], [NNX, NNY]).

downmove([NextX, NextY], [NNX, NNY]) :- \+right([NextX, NextY]) -> (NNX is NextX + 1, NNY = NextY); 
					     \+bottom([NextX, NextY]) -> (NNY is NextY + 1, NNX = NextX);
					     \+left([NextX, NextY]) -> (NNX is NextX - 1, NNY = NextY);
					     (NNY is NextY - 1, NNX = NextX).

upmove([NextX, NextY], [NNX, NNY]) :- \+left([NextX, NextY]) -> (NNX is NextX - 1, NNY = NextY);
					   \+top([NextX, NextY]) -> (NNY is NextY - 1, NNX = NextX);
					   \+right([NextX, NextY]) -> (NNX is NextX + 1, NNY = NextY); 
					   (NNY is NextY + 1, NNX = NextX).
leftmove([NextX, NextY], [NNX, NNY]) :- \+bottom([NextX, NextY]) -> NNY is NextY + 1, NNX = NextX;
					     \+left([NextX, NextY]) -> (NNX is NextX - 1, NNY = NextY);
					     \+top([NextX, NextY]) -> (NNY is NextY - 1, NNX = NextX);
					     (NNX is NextX + 1, NNY = NextY).

rightmove([NextX, NextY], [NNX, NNY]) :- \+top([NextX, NextY]) -> NNY is NextY - 1, NNX = NextX;
					      \+right([NextX, NextY]) -> (NNX is NextX + 1, NNY = NextY);
					      \+bottom([NextX, NextY]) -> NNY is NextY + 1, NNX = NextX;
					      (NNX is NextX - 1, NNY = NextY).

initial(CurrentLocation, NextLocation) :- move(CurrentLocation, NewLocation),
					    \+badSpot(NewLocation), 
					    NextLocation = NewLocation.

% A solution of the maze from our current location is [] if our current location is the end.
solve(CurrentLocation, _,_, Path) :- end(CurrentLocation), Path = [CurrentLocation].


solve(CurrentLocation, NewLocation, BeenThere, Path) :- moveCheck(CurrentLocation, NewLocation, NNLocation),
        \+badSpot(NewLocation),
        \+member(NewLocation, BeenThere),
	\+member(NNLocation, BeenThere),
        solve(NewLocation, NNLocation [[NewLocation|NNLocation]|BeenThere], RestOfPath),
        Path = [CurrentLocation | RestOfPath].
		
% Convenience rule
solve(Path) :- start(Start), initial(Start, NextLocation), solve(Start, NextLocation, [Start], Path).


drawCell(Column, Row, _) :- wall([Column, Row]), write("X"), !.
drawCell(Column, Row, _) :- start([Column, Row]), write("S"), !.
drawCell(Column, Row, _) :- end([Column, Row]), write("E"), !.
drawCell(Column, Row, Path) :- member([Column, Row], Path), write("P"), !.
drawCell(_, _, _) :- write("O").

drawRow(Row, Path) :- drawCell(1, Row, Path), tab(1), drawCell(2, Row, Path), tab(1), 
        drawCell(3, Row, Path), tab(1), drawCell(4, Row, Path), tab(1), 
        drawCell(5, Row, Path), tab(1), drawCell(6, Row, Path), nl.
                
draw :- drawRow(1, []), drawRow(2, []), drawRow(3, []), drawRow(4, []), drawRow(5, []), 
        drawRow(6, []).
draw(Path) :- drawRow(1, Path), drawRow(2, Path), drawRow(3, Path), drawRow(4, Path),
        drawRow(5, Path), drawRow(6, Path).