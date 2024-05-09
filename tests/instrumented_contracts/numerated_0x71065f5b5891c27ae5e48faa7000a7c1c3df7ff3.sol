1 pragma solidity ^0.5.0;
2 
3 contract Prize {
4 	event Commit(address sender, uint revealable);
5 
6 	bytes32 private flagHash;
7 
8 	mapping(address => bytes32) private commits;
9 	mapping(address => uint) private revealable;
10 
11 	constructor(bytes32 _flagHash) public payable {
12 		flagHash = _flagHash;
13 	}
14 
15 	function commit(bytes32 commitment) external {
16 		commits[msg.sender] = commitment;
17 		emit Commit(msg.sender, revealable[msg.sender] = block.number + 128);
18 	}
19 	function reveal(bytes32 flag) external {
20 		require(calcFlagHash(flag) == flagHash);
21 		require(calcCommitment(flag, msg.sender) == commits[msg.sender]);
22 		require(block.number >= revealable[msg.sender]);
23 		selfdestruct(msg.sender);
24 	}
25 
26 	function calcFlagHash(bytes32 flag) public pure returns(bytes32) {
27 		return keccak256(abi.encodePacked(flag));
28 	}
29 	function calcCommitment(bytes32 flag, address sender) public pure returns(bytes32) {
30 		return keccak256(abi.encodePacked(flag, sender));
31 	}
32 }