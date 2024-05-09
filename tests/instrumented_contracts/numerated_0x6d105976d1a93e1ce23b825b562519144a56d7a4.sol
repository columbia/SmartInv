1 pragma solidity ^0.4.11;
2 
3 contract StringDump {
4     event Event(string value);
5 
6     function emitEvent(string value) public {
7 
8         Event(value);
9     }
10 }