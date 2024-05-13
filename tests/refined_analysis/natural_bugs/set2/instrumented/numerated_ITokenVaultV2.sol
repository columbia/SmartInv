1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "./ITokenVault.sol";
6 
7 interface ITokenVaultV2 is ITokenVault {
8 
9     /// Emitted when an FNFT is created
10     event CreateFNFT(uint indexed fnftId, address indexed from);
11 
12     /// Emitted when an FNFT is redeemed
13     event RedeemFNFT(uint indexed fnftId, address indexed from);
14 
15     /// Emitted when an FNFT is created to denote what tokens have been deposited
16     event DepositERC20(address indexed token, address indexed user, uint indexed fnftId, uint tokenAmount, address smartWallet);
17 
18     /// Emitted when an FNFT is withdraw  to denote what tokens have been withdrawn
19     event WithdrawERC20(address indexed token, address indexed user, uint indexed fnftId, uint tokenAmount, address smartWallet);
20 
21     function getFNFTAddress(uint fnftId) external view returns (address smartWallet);
22 
23     function recordAdditionalDeposit(address user, uint fnftId, uint tokenAmount) external;
24 
25 }
26 
