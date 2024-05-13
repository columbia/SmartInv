1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ICurvePool {
5 
6   function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external payable returns (uint256);
7 
8   function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external payable returns (uint256);
9   
10   function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external returns (uint256);
11   
12   function coins(uint256 index) external view returns (address);
13 }