1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Docs: https://docs.synthetix.io/
9 *
10 *
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 Synthetix
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 
34 // SPDX-License-Identifier: MIT
35 pragma solidity ^0.6.2;
36 
37 import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
38 
39 abstract contract RewardsDistributionRecipientUpgradeable is OwnableUpgradeable {
40     address public rewardsDistribution;
41 
42     modifier onlyRewardsDistribution() {
43         require(msg.sender == rewardsDistribution, "PausableUpgradeable: caller is not the rewardsDistribution");
44         _;
45     }
46 
47     function __RewardsDistributionRecipient_init() internal initializer {
48         __Ownable_init();
49     }
50 
51     function notifyRewardAmount(uint256 reward) virtual external;
52 
53     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
54         rewardsDistribution = _rewardsDistribution;
55     }
56 
57     uint256[50] private __gap;
58 }
