// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IFortressRegistry {

    // Deposit

    function depositUnderlying(address _underlyingAsset, uint256 _underlyingAssets, address _receiver, uint256 _minAmount) external returns (uint256 _shares);

    function depositUnderlying(uint256 _underlyingAssets, address _receiver, uint256 _minAmount) external returns (uint256 _shares);

    function deposit(uint256 _assets, address _receiver) external returns (uint256 _shares);

    function mint(uint256 _shares, address _receiver) external returns (uint256 _assets);

    function previewDeposit(uint256 _assets) external view returns (uint256 _shares);

    function previewMint(uint256 _shares) external view returns (uint256 _assets);

    // Withdraw

    function redeemUnderlying(address _underlyingAsset, uint256 _shares, address _receiver, address _owner, uint256 _minAmount) external returns (uint256 _underlyingAssets);

    function redeemUnderlying(uint256 _shares, address _receiver, address _owner, uint256 _minAmount) external returns (uint256 _underlyingAssets);

    function redeem(uint256 _shares, address _receiver, address _owner) external returns (uint256 _assets);

    function withdraw(uint256 _assets, address _receiver, address _owner) external returns (uint256 _shares);

    function previewRedeem(uint256 _shares) external view returns (uint256 _assets);

    function previewWithdraw(uint256 _shares) external view returns (uint256 _assets);

    // Harvest

    function harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) external returns (uint256 _rewards);

    function harvest(address _receiver, uint256 _minBounty) external returns (uint256 _rewards);
}