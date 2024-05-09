1 pragma solidity ^0.4.18;
2 // # US dollars per BTC
3 // around 4:15 PM EST
4 // 0.0732412 implies $7324.12 per BTC
5 contract btcusdOracle{
6     
7     address private owner;
8 
9     function btcusdOracle() 
10         payable 
11     {
12         owner = msg.sender;
13     }
14     
15     function ubdateBTC() 
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