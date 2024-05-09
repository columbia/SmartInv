1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4 	address public owner;
5 	function Ownable() {owner = msg.sender;}
6 	modifier onlyOwner() {
7 		if (msg.sender != owner) throw;
8 		_;
9 	}
10 
11 }
12 
13 contract XcLottery is Ownable{
14     
15     mapping (string => uint256) randomSeedMap;
16     
17     event DrawLottery(string period, uint256 randomSeed);
18     
19     function getRandomSeed(string period) constant returns (uint256 randomSeed) {
20         return randomSeedMap[period];
21     }
22     
23     function drawLottery(string period) onlyOwner {
24         if(randomSeedMap[period] != 0) throw;
25         var lastblockhashused = block.blockhash(block.number - 1);
26         uint256 randomSeed = uint256(sha3(block.difficulty, block.coinbase, now, lastblockhashused, period));
27         randomSeedMap[period] = randomSeed;
28         DrawLottery(period,randomSeed);
29     }
30     
31     // Do not allow direct deposits.
32     function () external {
33         throw;
34     }
35 }