1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./BaseIRM.sol";
6 
7 
8 contract BaseIRMLinearKink is BaseIRM {
9     uint public immutable baseRate;
10     uint public immutable slope1;
11     uint public immutable slope2;
12     uint public immutable kink;
13 
14     constructor(uint moduleId_, bytes32 moduleGitCommit_, uint baseRate_, uint slope1_, uint slope2_, uint kink_) BaseIRM(moduleId_, moduleGitCommit_) {
15         baseRate = baseRate_;
16         slope1 = slope1_;
17         slope2 = slope2_;
18         kink = kink_;
19     }
20 
21     function computeInterestRateImpl(address, uint32 utilisation) internal override view returns (int96) {
22         uint ir = baseRate;
23 
24         if (utilisation <= kink) {
25             ir += utilisation * slope1;
26         } else {
27             ir += kink * slope1;
28             ir += slope2 * (utilisation - kink);
29         }
30 
31         return int96(int(ir));
32     }
33 }
