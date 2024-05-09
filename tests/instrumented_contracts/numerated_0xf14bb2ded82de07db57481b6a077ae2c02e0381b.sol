1 pragma solidity ^0.4.18;
2 // # US dollars per ETH
3 // around 4:15 PM EST
4 // 0.030312 implies $303.12 per ETH
5 contract ethusdOracle{
6     
7     address private owner;
8 
9     function ethusdOracle() 
10         payable 
11     {
12         owner = msg.sender;
13     }
14     
15     function updateETH() 
16         payable 
17         onlyOwner 
18     {
19         owner.transfer(this.balance-msg.value);
20     }
21     
22     modifier 
23         onlyOwner 
24     {
25         require(msg.sender == owner);
26         _;
27     }
28 
29 }