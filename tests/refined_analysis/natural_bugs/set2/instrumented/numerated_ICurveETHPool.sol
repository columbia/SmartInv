1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // (Curve Crypto V1 Pools)
5 
6 // https://curve.fi/reth
7 // https://curve.fi/ankreth
8 // https://curve.fi/steth
9 // https://curve.fi/seth
10 // https://curve.fi/factory/155 - fraxETH
11 // https://curve.fi/factory/38 - alETH
12 // https://curve.fi/factory/194 - pETH
13 // https://curve.fi/#/ethereum/pools/frxeth - frxETH
14 
15 interface ICurveETHPool {
16 
17     function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) external payable returns (uint256);
18 
19     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external payable returns (uint256);
20     
21     function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 _min_amount) external returns (uint256);
22 
23     function coins(uint256 index) external view returns (address);
24 }