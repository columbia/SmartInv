1 pragma solidity ^0.4.17;
2 
3 contract Random {
4 	uint256 lastTimeBlockNumber;
5 	event Generate(
6 		address indexed _fromIndex,
7 		address _from,
8 		uint256 maxValue,
9 		uint256 result
10 	);	
11 
12 	function random(uint256 maxValue) public returns (uint256 randomNumber) {
13 		require(maxValue > 0);
14 		require(lastTimeBlockNumber != block.number);
15 		lastTimeBlockNumber = block.number;
16 		uint256 result = uint256(keccak256(block.blockhash(block.number - 1), block.coinbase, block.difficulty));
17 		result = result % maxValue + 1;
18 		Generate(msg.sender,msg.sender, maxValue, result);
19 		return result;
20 	}
21 }