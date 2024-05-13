1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6   ___                      _   _
7  | _ )_  _ _ _  _ _ _  _  | | | |
8  | _ \ || | ' \| ' \ || | |_| |_|
9  |___/\_,_|_||_|_||_\_, | (_) (_)
10                     |__/
11 
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 BunnyFinance
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 import "@openzeppelin/contracts/math/SafeMath.sol";
37 import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
38 
39 import {PoolConstant} from "../library/PoolConstant.sol";
40 import "../interfaces/IVaultCollateral.sol";
41 
42 import "./calculator/PriceCalculatorETH.sol";
43 
44 
45 contract DashboardETH is OwnableUpgradeable {
46     using SafeMath for uint;
47 
48     PriceCalculatorETH public constant priceCalculator = PriceCalculatorETH(0xB73106688fdfee99578731aDb18c9689462B415a);
49 
50     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
51 
52     /* ========== INITIALIZER ========== */
53 
54     function initialize() external initializer {
55         __Ownable_init();
56     }
57 
58     /* ========== TVL Calculation ========== */
59 
60     function tvlOfPool(address pool) public view returns (uint tvl) {
61         IVaultCollateral strategy = IVaultCollateral(pool);
62         (, tvl) = priceCalculator.valueOfAsset(strategy.stakingToken(), strategy.balance());
63     }
64 
65     /* ========== Pool Information ========== */
66 
67     function infoOfPool(address pool, address account) public view returns (PoolConstant.PoolInfo memory) {
68         IVaultCollateral strategy = IVaultCollateral(pool);
69         PoolConstant.PoolInfo memory poolInfo;
70 
71         uint collateral = strategy.collateralOf(account);
72         (, uint collateralInUSD) = priceCalculator.valueOfAsset(strategy.stakingToken(), collateral);
73 
74         poolInfo.pool = pool;
75         poolInfo.balance = collateralInUSD;
76         poolInfo.principal = collateral;
77         poolInfo.available = strategy.availableOf(account);
78         poolInfo.tvl = tvlOfPool(pool);
79         poolInfo.pBASE = strategy.realizedInETH(account);
80         poolInfo.depositedAt = strategy.depositedAt(account);
81         poolInfo.feeDuration = strategy.WITHDRAWAL_FEE_PERIOD();
82         poolInfo.feePercentage = strategy.WITHDRAWAL_FEE();
83         poolInfo.portfolio = portfolioOfPoolInUSD(pool, account);
84         return poolInfo;
85     }
86 
87     function poolsOf(address account, address[] memory pools) public view returns (PoolConstant.PoolInfo[] memory) {
88         PoolConstant.PoolInfo[] memory results = new PoolConstant.PoolInfo[](pools.length);
89         for (uint i = 0; i < pools.length; i++) {
90             results[i] = infoOfPool(pools[i], account);
91         }
92         return results;
93     }
94 
95     /* ========== Portfolio Calculation ========== */
96 
97     function portfolioOfPoolInUSD(address pool, address account) internal view returns (uint) {
98         IVaultCollateral strategy = IVaultCollateral(pool);
99         address stakingToken = strategy.stakingToken();
100 
101         (, uint collateralInUSD) = priceCalculator.valueOfAsset(stakingToken, strategy.collateralOf(account));
102         (, uint availableInUSD) = priceCalculator.valueOfAsset(stakingToken, strategy.availableOf(account));
103         (, uint profitInUSD) = priceCalculator.valueOfAsset(WETH, strategy.realizedInETH(account));
104         return collateralInUSD.add(availableInUSD).add(profitInUSD);
105     }
106 
107     function portfolioOf(address account, address[] memory pools) public view returns (uint deposits) {
108         deposits = 0;
109         for (uint i = 0; i < pools.length; i++) {
110             deposits = deposits.add(portfolioOfPoolInUSD(pools[i], account));
111         }
112     }
113 }
