// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IFortressVault {

    function depositUnderlying(address _underlyingAsset, address _receiver, uint256 _underlyingAmount, uint256 _minAmount) external payable returns (uint256 _shares);
    
    function redeemUnderlying(address _underlyingAsset, address _receiver, address _owner, uint256 _shares, uint256 _minAmount) external returns (uint256 _underlyingAmount);
}