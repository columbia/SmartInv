1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./BaseModule.sol";
6 
7 abstract contract BaseIRM is BaseModule {
8     constructor(uint moduleId_, bytes32 moduleGitCommit_) BaseModule(moduleId_, moduleGitCommit_) {}
9 
10     int96 internal constant MAX_ALLOWED_INTEREST_RATE = int96(int(uint(5 * 1e27) / SECONDS_PER_YEAR)); // 500% APR
11     int96 internal constant MIN_ALLOWED_INTEREST_RATE = 0;
12 
13     function computeInterestRateImpl(address, uint32) internal virtual returns (int96);
14 
15     function computeInterestRate(address underlying, uint32 utilisation) external returns (int96) {
16         int96 rate = computeInterestRateImpl(underlying, utilisation);
17 
18         if (rate > MAX_ALLOWED_INTEREST_RATE) rate = MAX_ALLOWED_INTEREST_RATE;
19         else if (rate < MIN_ALLOWED_INTEREST_RATE) rate = MIN_ALLOWED_INTEREST_RATE;
20 
21         return rate;
22     }
23 
24     function reset(address underlying, bytes calldata resetParams) external virtual {}
25 }
