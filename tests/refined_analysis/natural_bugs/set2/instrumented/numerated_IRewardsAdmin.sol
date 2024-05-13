1 pragma solidity ^0.8.0;
2 
3 import "./IRewardsDistributorAdmin.sol";
4 
5 interface IRewardsAdmin is IRewardsDistributorAdmin {
6     function admin() external view returns (address);
7 
8     function pendingAdmin() external view returns (address);
9 
10     function claimRewards(address) external;
11 }
