1 pragma solidity ^0.4.18;
2 contract DogeEthBountySplit2 {
3 
4     // Just hardcode externally owned accounts, don’t use contract addresses.
5     address public oscarGuindzbergAddress = 0xFc7E364035f52ecA68D71dcfb63D1E3769413d69;
6     address public coinfabrikAddress = 0x8ffC991Fc4C4fC53329Ad296C1aFe41470cFFbb3;
7 
8     function() payable public {
9     }    
10    
11     function withdraw() public {
12         uint balance = address(this).balance;
13         uint half = balance / 2;
14         oscarGuindzbergAddress.transfer(half);
15         coinfabrikAddress.transfer(half);
16     }
17 }