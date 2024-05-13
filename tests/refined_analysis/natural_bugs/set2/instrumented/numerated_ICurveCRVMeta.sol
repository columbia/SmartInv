1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/frax
5 // https://curve.fi/tusd
6 // https://curve.fi/lusd
7 // https://curve.fi/gusd
8 // https://curve.fi/mim
9 // https://curve.fi/factory/113 - pUSD
10 // https://curve.fi/alusd
11 
12 interface ICurveCRVMeta {
13   
14   function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);
15 
16   function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external returns (uint256);
17 
18   function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns (uint256);
19 
20   // function remove_liquidity(uint256 _burn_amount, uint256[2] memory _min_amounts) external returns (uint256[2]);
21 
22   function coins(uint256 index) external view returns (address);
23 }