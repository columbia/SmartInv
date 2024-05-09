1 pragma solidity ^0.4.0;
2 
3 contract messageBoard{
4    string public message;
5    function messageBoard(string initMessage) public{
6        message=initMessage;
7    }
8    function editMessage(string editMessage) public{
9        message=editMessage;
10    }
11    function viewMessage() public returns(string){
12        return message;
13    }
14     
15 }