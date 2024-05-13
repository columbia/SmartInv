1 pragma solidity ^0.5.16;
2 
3 contract LiquidityMiningInterface {
4     function comptroller() external view returns (address);
5 
6     function updateSupplyIndex(address cToken, address[] calldata accounts) external;
7 
8     function updateBorrowIndex(address cToken, address[] calldata accounts) external;
9 }
