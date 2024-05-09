1 pragma solidity ^0.4.10;
2 
3 contract Token{
4 	function transfer(address to, uint value) returns (bool ok);
5 }
6 
7 contract Faucet {
8 
9 	address public tokenAddress;
10 	Token token;
11 
12 	function Faucet(address _tokenAddress) {
13 		tokenAddress = _tokenAddress;
14 		token = Token(tokenAddress);
15 	}
16   
17 	function getToken() {
18 		if(!token.transfer(msg.sender, 1)) throw;
19 	}
20 
21 	function () {
22 		getToken();
23 	}
24 
25 }