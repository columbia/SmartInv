1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/fraxusdc
5 // https://curve.fi/eursusd
6 // https://curve.fi/link
7 // https://curve.fi/eurs
8 // https://curve.fi/eursusd
9 // https://curve.fi/link
10 // CRV/cvxCRV - https://curve.fi/factory/22
11 // FXS/sdFXS - https://curve.fi/#/ethereum/pools/factory-v2-100
12 
13 interface ICurvePlainPool {
14   
15   function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);
16 
17   function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external returns (uint256);
18 
19   function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns (uint256);
20 
21   function coins(uint256 index) external view returns (address);
22 }