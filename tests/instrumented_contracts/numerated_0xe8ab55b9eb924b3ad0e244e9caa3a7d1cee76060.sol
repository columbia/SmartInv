1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function transferFrom(address from, address to, uint256 value) public returns (bool);
5 }
6 
7 contract Disperse {
8     function disperseToken(address _tokenAddress, address[] _to, uint256[] _value) external {
9 		require(_to.length == _value.length);
10 		require(_to.length <= 255);
11 		ERC20 token = ERC20(_tokenAddress);
12 		for (uint8 i = 0; i < _to.length; i++) {
13 			require(token.transferFrom(msg.sender, _to[i], _value[i]));
14 		}
15 	}
16 }