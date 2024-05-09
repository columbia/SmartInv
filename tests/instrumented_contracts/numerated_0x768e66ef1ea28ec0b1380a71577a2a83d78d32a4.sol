1 pragma solidity ^0.4.18;
2 // US gross value-weighted daily stock return w/o dividends
3 // 0.10251 ETH balance implies a 1.0251 gross return, 2.51% net return
4 // pulled using closing prices around 4:15 PM EST 
5 contract useqgretOracle{
6     
7     address private owner;
8 
9     function useqgretOracle() 
10         payable 
11     {
12         owner = msg.sender;
13     }
14     
15     function updateUSeqgret() 
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