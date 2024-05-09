1 pragma solidity ^0.4.13;
2 contract Bulletin {
3     
4     string public message = "";
5     address public owner;
6     
7     function Bulletin(){
8         owner = msg.sender;
9     }
10     
11     function setMessage(string _message){
12         require(msg.sender == owner);
13         message = _message;
14     }
15 }