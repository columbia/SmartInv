1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ICurveMetaRegistry {
5     
6     function get_lp_token(address _pool) external view returns (address);
7 
8     function get_pool_from_lp_token(address _token) external view returns (address);
9 }