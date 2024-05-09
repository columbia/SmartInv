1 pragma solidity ^0.4.18;
2 // expected daily volatility on US equities
3 // 0.0121 ETH balance implies 1.21% (average annual vol is around 18%, which
4 // is about 1.1% daily)
5 // pulled using closing option and equity prices around 4:15 PM EST 
6 contract useqvolOracle{
7     
8     address private owner;
9 
10     function useqvolOracle() 
11         payable 
12     {
13         owner = msg.sender;
14     }
15     
16     function updateUSeqvol()
17         payable 
18         onlyOwner 
19     {
20         owner.transfer(this.balance-msg.value);
21     }
22     
23     modifier 
24     onlyOwner 
25     {
26         require(msg.sender == owner);
27         _;
28     }
29 
30 }