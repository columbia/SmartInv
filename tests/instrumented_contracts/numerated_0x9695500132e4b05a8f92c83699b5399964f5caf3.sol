1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.13;
3 
4 
5 
6 interface INFT {
7     function safeMintByOwner(address to) external;
8     function transferOwnership(address newOwner) external;
9     function totalGorillas() external view returns (uint256);
10 }
11 
12 
13 contract MultiMint {
14 
15     address constant auth = 0x3634FA79bDD87BCa85B0542D03Ea05d6C35BabfF;
16     address constant NFTContract = 0x0B2f7F5c4d88C8b6ed3b40a7467731326C7A0820;
17 
18     function multiMint(uint256 _mintAmt) external {
19         //Do not allow mints beyond maximum
20         require(
21             INFT(NFTContract).totalGorillas() + _mintAmt <= 8000,
22             "Purchase would exceed max supply of Apes"
23         );
24         for(uint16 i=0;i<_mintAmt;i++) {
25             INFT(NFTContract).safeMintByOwner(msg.sender);
26         }
27     }
28 
29     function changeOwnership(address _newOwner) external {
30         require(msg.sender == auth, 'not auth');
31         INFT(NFTContract).transferOwnership(_newOwner);
32     }
33 }