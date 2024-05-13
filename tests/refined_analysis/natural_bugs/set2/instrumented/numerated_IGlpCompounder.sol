1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 interface IFortressRegistry {
5 
6     // Deposit
7 
8     function depositUnderlying(address _underlyingAsset, uint256 _underlyingAssets, address _receiver, uint256 _minAmount) external returns (uint256 _shares);
9 
10     function depositUnderlying(uint256 _underlyingAssets, address _receiver, uint256 _minAmount) external returns (uint256 _shares);
11 
12     function deposit(uint256 _assets, address _receiver) external returns (uint256 _shares);
13 
14     function mint(uint256 _shares, address _receiver) external returns (uint256 _assets);
15 
16     function previewDeposit(uint256 _assets) external view returns (uint256 _shares);
17 
18     function previewMint(uint256 _shares) external view returns (uint256 _assets);
19 
20     // Withdraw
21 
22     function redeemUnderlying(address _underlyingAsset, uint256 _shares, address _receiver, address _owner, uint256 _minAmount) external returns (uint256 _underlyingAssets);
23 
24     function redeemUnderlying(uint256 _shares, address _receiver, address _owner, uint256 _minAmount) external returns (uint256 _underlyingAssets);
25 
26     function redeem(uint256 _shares, address _receiver, address _owner) external returns (uint256 _assets);
27 
28     function withdraw(uint256 _assets, address _receiver, address _owner) external returns (uint256 _shares);
29 
30     function previewRedeem(uint256 _shares) external view returns (uint256 _assets);
31 
32     function previewWithdraw(uint256 _shares) external view returns (uint256 _assets);
33 
34     // Harvest
35 
36     function harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) external returns (uint256 _rewards);
37 
38     function harvest(address _receiver, uint256 _minBounty) external returns (uint256 _rewards);
39 }