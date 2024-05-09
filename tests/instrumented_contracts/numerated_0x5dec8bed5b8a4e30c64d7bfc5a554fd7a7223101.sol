1 pragma solidity ^0.4.24;
2 
3 contract PiggyBank  {
4   string public name;
5   string public symbol = '%';
6   uint8 constant public decimals = 18;
7   uint256 constant internal denominator = 10 ** uint256(decimals);
8   uint256 public targetAmount;
9 
10   bool public complete = false;
11 
12   address internal targetAddress;
13 
14   constructor(
15     string goalName,
16     uint256 goalAmount,
17     address target
18   ) public
19   {
20     name = goalName;
21     targetAmount = goalAmount;
22     targetAddress = target;
23   }
24 
25   function balanceOf(address target) view public returns(uint256)
26   {
27     if (target != targetAddress)
28       return 0;
29 
30     if (complete)
31       return denominator * 100;
32 
33     return denominator * 100 * address(this).balance / targetAmount;
34   }
35 
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 
38   function () public payable {
39     emit Transfer(address(this), targetAddress, denominator * msg.value / targetAmount * 100);
40     if (balanceOf(targetAddress) >= 100 * denominator) {
41       complete = true;
42       selfdestruct(targetAddress);
43     }
44   }
45 
46 }