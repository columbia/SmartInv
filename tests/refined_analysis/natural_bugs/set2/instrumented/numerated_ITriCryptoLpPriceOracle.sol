1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ITriCryptoLpPriceOracle {
5 
6     function lp_price() external view returns (uint256);
7 }