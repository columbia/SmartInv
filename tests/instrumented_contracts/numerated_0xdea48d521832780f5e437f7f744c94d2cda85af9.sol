1 pragma solidity ^0.4.8;
2 
3 contract testingToken {
4 	mapping (address => uint256) public balanceOf;
5 	address public owner;
6 	function testingToken() {
7 		owner = msg.sender;
8 		balanceOf[msg.sender] = 1000;
9 	}
10 	function send(address _to, uint256 _value) {
11 		if (balanceOf[msg.sender]<_value) throw;
12 		if (balanceOf[_to]+_value<balanceOf[_to]) throw;
13 		if (_value<0) throw;
14 		balanceOf[msg.sender] -= _value;
15 		balanceOf[_to] += _value;
16 	}
17 }