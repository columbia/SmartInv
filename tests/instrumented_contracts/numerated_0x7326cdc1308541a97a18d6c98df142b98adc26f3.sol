1 pragma solidity ^0.4.18;
2 
3 contract TokenRate {
4     uint public USDValue;
5     uint public EURValue;
6     uint public GBPValue;
7     uint public BTCValue;
8     address public owner = msg.sender;
9 
10     modifier ownerOnly() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function setValues(uint USD, uint EUR, uint GBP, uint BTC) ownerOnly public {
16         USDValue = USD;
17         EURValue = EUR;
18         GBPValue = GBP;
19         BTCValue = BTC;
20     }
21 }