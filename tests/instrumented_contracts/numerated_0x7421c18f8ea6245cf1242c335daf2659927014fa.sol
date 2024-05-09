1 pragma solidity ^0.4.10;
2 
3 contract PingContract {
4 	function ping() returns (uint) {
5 		return pingTimestamp();
6 	}
7 	
8 	function pingTimestamp() returns (uint) {
9 		return block.timestamp;
10 	}
11 	
12 	function pingBlock() returns (uint) {
13 		return block.number;
14 	}
15 }