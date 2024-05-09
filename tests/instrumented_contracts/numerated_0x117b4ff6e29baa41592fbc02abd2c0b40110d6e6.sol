1 pragma solidity ^0.5.0;
2 
3 contract Prize {
4     event Successful(address winner, uint withdrawableHeight);
5 
6     bytes32 private flagHash;
7 
8     mapping(address => bytes32) private commits;
9     mapping(address => uint) private heights;
10 
11     address payable private winner;
12     uint private withdrawableHeight;
13 
14     constructor(bytes32 _flagHash) public payable {
15         flagHash = _flagHash;
16         withdrawableHeight = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
17     }
18 
19     function commit(bytes32 commitment) external {
20         commits[msg.sender] = commitment;
21         heights[msg.sender] = block.number + 256;
22     }
23     function reveal(bytes32 flag) external {
24         require(calcFlagHash(flag) == flagHash);
25         require(calcCommitment(flag, msg.sender) == commits[msg.sender]);
26         require(heights[msg.sender] < withdrawableHeight);
27         emit Successful(
28             winner = msg.sender,
29             withdrawableHeight = heights[msg.sender]
30         );
31     }
32     function withdraw() external {
33         require(msg.sender == winner);
34         require(block.number >= withdrawableHeight);
35         selfdestruct(winner);
36     }
37 
38     function calcFlagHash(bytes32 flag) public pure returns(bytes32) {
39         return keccak256(abi.encodePacked(flag));
40     }
41     function calcCommitment(bytes32 flag, address sender) public pure returns(bytes32) {
42         return keccak256(abi.encodePacked(flag, sender));
43     }
44 }