1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 interface IFeeRewardForwarder {
6     function setConversionPath(address from, address to, address[] calldata _uniswapRoute) external;
7     function setTokenPool(address _pool) external;
8 
9     function poolNotifyFixedTarget(address _token, uint256 _amount) external;
10 
11 }
