1 pragma solidity ^0.4.18;
2 
3 contract Random {
4   uint256 _seed;
5 
6   function maxRandom() public returns (uint256 randomNumber) {
7     _seed = uint256(keccak256(
8         _seed,
9         block.blockhash(block.number - 1),
10         block.coinbase,
11         block.difficulty
12     ));
13     return _seed;
14   }
15 
16   // return a pseudo random number between lower and upper bounds
17   // given the number of previous blocks it should hash.
18   function random(uint256 upper) public returns (uint256 randomNumber) {
19     return maxRandom() % upper;
20   }
21 }
22 
23 contract Lottery is Random {
24 
25 	struct Stage {
26 		uint32 maxNum;
27 		bytes32 participantsHash;
28 		uint winnerNum;
29 	}
30 	mapping (uint32 => Stage) public stages;
31 	address public owner;
32 
33 	event Winner(uint32 _stageNum, uint _winnerNum);
34 
35 	modifier onlyOwner() { require(msg.sender == owner); _;}
36 
37 	constructor() public {
38         owner = msg.sender;
39     }
40 
41 	function randomJackpot(uint32 _stageNum, bytes32 _participantsHash, uint32 _maxNum) external onlyOwner {
42 		require(_maxNum > 0);
43 		uint winnerNum = random(_maxNum);
44 		stages[_stageNum] = Stage(_maxNum, _participantsHash, winnerNum);
45 		emit Winner(_stageNum, winnerNum);
46 	}
47 }