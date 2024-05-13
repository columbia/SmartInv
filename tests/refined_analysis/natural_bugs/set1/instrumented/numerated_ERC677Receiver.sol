1 pragma solidity ^0.4.8;
2 
3 
4 contract ERC677Receiver {
5   function onTokenTransfer(address _sender, uint _value, bytes _data);
6 }
