1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/factory/144 - tUSD/FRAXBP
5 // https://curve.fi/factory/147 - alUSD/FRAXBP
6 // https://curve.fi/factory/137 - LUSD/FRAXBP
7 
8 interface ICurveFraxMeta {
9 
10   function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);
11 
12   function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external returns (uint256);
13 
14   function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns (uint256);
15 
16   function coins(uint256 index) external view returns (address);
17 }