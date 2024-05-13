1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {SafeMath} from "../lib/SafeMath.sol";
12 
13 
14 interface IChainlink {
15     function latestAnswer() external view returns (uint256);
16 }
17 
18 
19 // for YFI-USDC(decimals=6) price convert
20 
21 contract ChainlinkYFIUSDCPriceOracleProxy {
22     using SafeMath for uint256;
23 
24     address public yfiEth = 0x7c5d4F8345e66f68099581Db340cd65B078C41f4;
25     address public EthUsd = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
26 
27     function getPrice() external view returns (uint256) {
28         uint256 yfiEthPrice = IChainlink(yfiEth).latestAnswer();
29         uint256 EthUsdPrice = IChainlink(EthUsd).latestAnswer();
30         return yfiEthPrice.mul(EthUsdPrice).div(10**20);
31     }
32 }
