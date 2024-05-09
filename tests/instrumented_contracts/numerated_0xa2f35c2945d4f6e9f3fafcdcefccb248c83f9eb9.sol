1 pragma solidity ^0.4.18;
2 // US value-weighted stock index w/o dividends
3 // 0.056710, given prior day value of 0.056300, implies a 0.73% net return
4 // pulled using closing prices around 4:15 PM EST 
5 
6 contract useqIndexOracle{
7     
8     address private owner;
9 
10     function useqIndexOracle() 
11         payable 
12     {
13         owner = msg.sender;
14     }
15     
16     function updateUSeqIndex() 
17         payable 
18         onlyOwner 
19     {
20         owner.transfer(this.balance-msg.value);
21     }
22     
23     modifier 
24         onlyOwner 
25     {
26         require(msg.sender == owner);
27         _;
28     }
29 
30 }