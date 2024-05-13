1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/tricrypto2 - ETH is wETH
5 
6 interface ICurve3Pool {
7   
8     function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external payable;
9     
10     function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external payable;
11     
12     function remove_liquidity_one_coin(uint256 token_amount, uint256 i, uint256 min_amount) external payable;
13 
14     function coins(uint256 index) external view returns (address);
15 }