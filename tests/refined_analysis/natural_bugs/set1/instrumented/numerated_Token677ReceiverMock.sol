1 pragma solidity ^0.4.8;
2 
3 
4 contract Token677ReceiverMock {
5     address public tokenSender;
6     uint public sentValue;
7     bytes public tokenData;
8     bool public calledFallback = false;
9 
10     function onTokenTransfer(address _sender, uint _value, bytes _data)
11     public {
12       calledFallback = true;
13 
14       tokenSender = _sender;
15       sentValue = _value;
16       tokenData = _data;
17     }
18 
19 }
