:- include('24.common.prolog').

result(Program, MinSerial) :- calulateMinMaxSerial(Program, MinSerial, _).