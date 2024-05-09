1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 contract PayForMinting {
5     address payable private owner = payable(0x3A8e15F4c536EA4C86b37A780b99C2D230a285bb);
6     uint256 public constant costToCustomize = 40000000000000000;
7     uint256 public constant costToMint = 20000000000000000;
8 
9     event PaidForMinting(string indexed dragonWalletIndexed, string dragonWallet, uint8 paymentLevel);
10     event CollectedFunds(uint256 amount);
11 
12     /// @param dragonWallet The Dragon Wallet string that is receiving payment.
13     function payForMinting(string calldata dragonWallet) external payable {
14         require(msg.value == costToCustomize || msg.value == costToMint);
15 
16         emit PaidForMinting(dragonWallet, dragonWallet, msg.value == costToCustomize ? 2 : 1);
17     }
18 
19     function claimFunds() external {
20         uint256 balance = address(this).balance;
21         owner.transfer(balance);
22         emit CollectedFunds(balance);
23     }
24 }