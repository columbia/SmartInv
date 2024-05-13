1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../../libraries/ScaledMath.sol";
5 import "../../interfaces/oracles/IOracleProvider.sol";
6 
7 library OracleProviderExtensions {
8     using ScaledMath for uint256;
9 
10     function getRelativePrice(
11         IOracleProvider priceOracle,
12         address fromToken,
13         address toToken
14     ) internal view returns (uint256) {
15         return priceOracle.getPriceUSD(fromToken).scaledDiv(priceOracle.getPriceUSD(toToken));
16     }
17 }
