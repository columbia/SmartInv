1 pragma solidity ^0.5.0;
2 
3 contract Lottery {
4     address[] public losers;
5     address[] public winnners;
6     
7     function imaginaryTruelyRandomNumber() public view returns (uint256) {
8         return block.timestamp;
9     }
10     
11     function luckyDraw() payable public {
12         uint256 truelyRand = imaginaryTruelyRandomNumber();
13         if(truelyRand % 2 == 1) {
14             losers.push(msg.sender);
15         } else {
16             winnners.push(msg.sender);
17         }
18     }
19     
20     function winnderCount() public view returns (uint256) {
21         return winnners.length;   
22     }
23     
24     function loserCount() public view returns (uint256) {
25         return losers.length;   
26     }
27 }