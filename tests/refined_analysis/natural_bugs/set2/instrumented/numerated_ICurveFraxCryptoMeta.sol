1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/factory-crypto/95 - CVX/crvFRAX
5 // https://curve.fi/factory-crypto/94 - cvxFXS/crvFRAX
6 // https://curve.fi/factory-crypto/96 - ALCX/crvFRAX
7 // https://curve.fi/factory-crypto/97 - cvxCRV/crvFRAX
8 
9 interface ICurveFraxCryptoMeta {
10 
11   function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);
12 
13   function remove_liquidity_one_coin(uint256 token_amount, uint256 i, uint256 min_amount) external returns (uint256);
14 
15   function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external returns (uint256);
16 
17   function coins(uint256 index) external view returns (address);
18 }