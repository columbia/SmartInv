1 pragma solidity ^0.8.4;
2 
3 import "./StakingTokenWrapper.sol";
4 
5 /// @notice contract to bulk harvest multiple Staking Token Wrappers in a single transaction
6 /// stateless contract with no storage and can only call harvest on the STW's
7 contract STWBulkHarvest {
8     function bulkHarvest(StakingTokenWrapper[] calldata stw) external {
9         for (uint256 i = 0; i < stw.length; i++) {
10             stw[i].harvest();
11         }
12     }
13 }
