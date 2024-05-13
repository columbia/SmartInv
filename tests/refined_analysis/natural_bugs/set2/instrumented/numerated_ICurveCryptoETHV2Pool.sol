1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://curve.fi/cvxeth
5 // https://curve.fi/crveth
6 // https://curve.fi/spelleth
7 // https://curve.fi/factory-crypto/3 - FXS/ETH
8 // https://curve.fi/factory-crypto/8 - YFI/ETH
9 // https://curve.fi/factory-crypto/85 - BTRFLY/ETH
10 // https://curve.fi/factory-crypto/39 - KP3R/ETH
11 // https://curve.fi/factory-crypto/43 - JPEG/ETH
12 // https://curve.fi/factory-crypto/55 - TOKE/ETH
13 // https://curve.fi/factory-crypto/21 - OHM/ETH
14 
15 interface ICurveCryptoETHV2Pool {
16 
17     function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount, bool use_eth) external payable returns (uint256);
18 
19     function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy, bool use_eth) external payable returns (uint256);
20 
21     function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 _min_amount, bool use_eth) external returns (uint256);
22 
23     function coins(uint256 index) external view returns (address);
24 }