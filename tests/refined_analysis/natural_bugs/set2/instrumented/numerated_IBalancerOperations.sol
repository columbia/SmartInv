1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IBalancerOperations {
5 
6     function addLiquidity(address _poolAddress, address _asset, uint256 _amount) external returns (uint256);
7 
8     function removeLiquidity(address _poolAddress, address _asset, uint256 _bptAmountIn) external returns (uint256);
9 }