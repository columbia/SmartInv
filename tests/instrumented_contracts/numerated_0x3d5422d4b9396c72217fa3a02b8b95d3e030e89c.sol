1 pragma solidity ^0.4.23;
2 
3 interface TrueUSD {
4     function sponsorGas() external;
5 }
6 
7 contract SponsorHelper {
8     TrueUSD public trueUSD = TrueUSD(0x0000000000085d4780B73119b644AE5ecd22b376);
9     
10     function sponsorGas() external {
11         trueUSD.sponsorGas();
12     }
13 }