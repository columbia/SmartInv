1 pragma solidity ^0.4.18;
2 
3 contract RateOracle {
4 
5   address public owner;
6   uint public rate;
7   uint256 public lastUpdateTime;
8 
9   function RateOracle() public {
10     owner = msg.sender;
11   }
12 
13   function setRate(uint _rateCents) public {
14     require(msg.sender == owner);
15     require(_rateCents > 100);
16     rate = _rateCents;
17     lastUpdateTime = now;
18   }
19 
20 }