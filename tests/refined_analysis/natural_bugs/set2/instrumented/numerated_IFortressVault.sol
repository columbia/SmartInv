1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IFortressVault {
5 
6     function depositUnderlying(address _underlyingAsset, address _receiver, uint256 _underlyingAmount, uint256 _minAmount) external payable returns (uint256 _shares);
7     
8     function redeemUnderlying(address _underlyingAsset, address _receiver, address _owner, uint256 _shares, uint256 _minAmount) external returns (uint256 _underlyingAmount);
9 }