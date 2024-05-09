1 pragma solidity ^0.4.0;
2 
3 contract Eventer {
4   event Record(
5     address _from,
6     string _message
7   );
8 
9   function record(string message) {
10     Record(msg.sender, message);
11   }
12 }