1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IGlpRewardHandler {
5 
6     function handleRewards(
7         bool _shouldClaimGmx,
8         bool _shouldStakeGmx,
9         bool _shouldClaimEsGmx,
10         bool _shouldStakeEsGmx,
11         bool _shouldStakeMultiplierPoints,
12         bool _shouldClaimWeth,
13         bool _shouldConvertWethToEth
14     ) external;
15 }