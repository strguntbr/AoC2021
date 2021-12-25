:- include('24.common.prolog').

result(Program, MaxSerial) :- calulateMinMaxSerial(Program, _, MaxSerial).
