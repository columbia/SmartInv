1 pragma solidity ^0.4.18;
2 contract DogeEthBountySplit {
3 
4     // Just hardcode externally owned accounts, don’t use contract addresses.
5     address public oscarGuindzbergAddress = 0xFc7E364035f52ecA68D71dcfb63D1E3769413d69;
6     address public coinfabrikAddress = 0x8ffC991Fc4C4fC53329Ad296C1aFe41470cFFbb3;
7     address public truebitAddress = 0x1e6d05543EaD73fb1820FAdBa481aAd716845FBa;
8 
9     function() payable public {
10     }    
11    
12     function withdraw() public {
13         uint balance = this.balance;
14         uint oneThird = balance / 3;
15         oscarGuindzbergAddress.transfer(oneThird);
16         coinfabrikAddress.transfer(oneThird);
17         truebitAddress.transfer(oneThird);
18     }
19 }