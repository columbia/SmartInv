1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/susdv2
5 
6 interface ICurvesUSD4Pool {
7   
8     function add_liquidity(uint256[4] memory amounts, uint256 min_mint_amount) external;
9     
10     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
11     
12     function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_uamount) external;
13 
14     function coins(int128 arg0) external view returns (address);
15 }