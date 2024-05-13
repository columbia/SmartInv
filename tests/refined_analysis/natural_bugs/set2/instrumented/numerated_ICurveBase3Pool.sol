1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/3pool
5 // https://curve.fi/ib
6 
7 interface ICurveBase3Pool {
8   
9     function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external;
10     
11     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
12 
13     function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external;
14 
15     function coins(uint256 index) external view returns (address);
16 }