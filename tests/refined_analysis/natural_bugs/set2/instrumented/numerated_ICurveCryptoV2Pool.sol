1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/factory-crypto/37 - USDC/STG
5 // https://curve.fi/factory-crypto/23 - USDC/FIDU
6 // https://curve.fi/factory-crypto/4 - wBTC/BADGER
7 // https://curve.fi/factory-crypto/18 - cvxFXS/FXS
8 // https://curve.fi/factory-crypto/62 - pxCVX/CVX
9 // https://curve.fi/factory-crypto/22 - SILO/FRAX
10 // https://curve.fi/factory-crypto/48 - FRAX/FPI
11 // https://curve.fi/factory-crypto/90 - FXS/FPIS
12 
13 interface ICurveCryptoV2Pool {
14 
15     function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) external payable returns (uint256);
16 
17     function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external payable returns (uint256);
18     
19     function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 _min_amount) external returns (uint256);
20 
21     function coins(uint256 index) external view returns (address);
22 }