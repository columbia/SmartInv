1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/sbtc
5 
6 interface ICurveSBTCPool {
7   
8     function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external payable returns (uint256);
9     
10     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external payable;
11     
12     function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external returns (uint256);
13 
14     function coins(int128 index) external view returns (address);
15 }