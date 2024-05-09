1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4   function transferFrom( address from, address to, uint value) returns (bool ok);
5 }
6 
7 /// @title Multiplexer
8 /// @author Chris Hitchcott
9 /// :repository https://github.com/DigixGlobal/multiplexer
10 
11 contract Multiplexer {
12 
13 	function sendEth(address[] _to, uint256[] _value) payable returns (bool _success) {
14 		// input validation
15 		assert(_to.length == _value.length);
16 		assert(_to.length <= 255);
17 		// count values for refunding sender
18 		uint256 beforeValue = msg.value;
19 		uint256 afterValue = 0;
20 		// loop through to addresses and send value
21 		for (uint8 i = 0; i < _to.length; i++) {
22 			afterValue = afterValue + _value[i];
23 			assert(_to[i].send(_value[i]));
24 		}
25 		// send back remaining value to sender
26 		uint256 remainingValue = beforeValue - afterValue;
27 		if (remainingValue > 0) {
28 			assert(msg.sender.send(remainingValue));
29 		}
30 		return true;
31 	}
32 
33 	function sendErc20(address _tokenAddress, address[] _to, uint256[] _value) returns (bool _success) {
34 		// input validation
35 		assert(_to.length == _value.length);
36 		assert(_to.length <= 255);
37 		// use the erc20 abi
38 		ERC20 token = ERC20(_tokenAddress);
39 		// loop through to addresses and send value
40 		for (uint8 i = 0; i < _to.length; i++) {
41 			assert(token.transferFrom(msg.sender, _to[i], _value[i]) == true);
42 		}
43 		return true;
44 	}
45 }