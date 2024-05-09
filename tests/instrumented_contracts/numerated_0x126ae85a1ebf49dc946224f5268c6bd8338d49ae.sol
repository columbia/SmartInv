1 pragma solidity ^0.4.24;
2 
3 contract PiggyBank  {
4   string public name;
5   string public symbol = '%';
6   uint8 constant public decimals = 18;
7   uint256 constant internal denominator = 10 ** uint256(decimals);
8   uint256 internal targetAmount;
9 
10   address internal targetAddress;
11 
12   constructor(
13     string goalName,
14     uint256 goalAmount
15   ) public
16   {
17     name = goalName;
18     targetAmount = goalAmount;
19     targetAddress = msg.sender;
20   }
21 
22   function balanceOf() view public returns(uint256)
23   {
24     return 100 * address(this).balance / targetAmount;
25   }
26 
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 
29   function () public payable {
30     if (balanceOf() >= 100) {
31       selfdestruct(targetAddress);
32     }
33   }
34 
35   function debugDestruct() public {
36     selfdestruct(targetAddress);
37   }
38 
39 
40 }