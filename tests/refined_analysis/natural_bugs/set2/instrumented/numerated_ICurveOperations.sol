1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ICurveOperations {
5 
6     function addLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) payable external returns (uint256);
7 
8     function removeLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) external returns (uint256);
9     
10     function getPoolFromLpToken(address _lpToken) external view returns (address);
11 }