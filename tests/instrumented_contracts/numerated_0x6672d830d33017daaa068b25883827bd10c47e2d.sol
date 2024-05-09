1 pragma solidity ^0.4.18;
2 
3 contract Random {
4     uint256 _seed;
5 
6     function maxRandom() public returns (uint256 randomNumber) {
7         _seed = uint256(keccak256(
8                 _seed,
9                 block.blockhash(block.number - 1),
10                 block.coinbase,
11                 block.difficulty
12             ));
13         return _seed;
14     }
15 
16     // return a pseudo random number between lower and upper bounds
17     // given the number of previous blocks it should hash.
18     function random(uint256 upper) public returns (uint256 randomNumber) {
19         return maxRandom() % upper;
20     }
21 }
22 
23 contract CryptoCup is Random {
24 
25     uint32 public maxNum;
26     address public owner;
27 
28     event Winner(uint _winnerNum);
29 
30     modifier onlyOwner() {require(msg.sender == owner);
31         _;}
32 
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     function updateMaxNum(uint32 _num) external onlyOwner {
38         maxNum = _num;
39     }
40 
41     function randomJackpot() external onlyOwner {
42         uint winnerNum = random(maxNum);
43         emit Winner(winnerNum);
44     }
45 }