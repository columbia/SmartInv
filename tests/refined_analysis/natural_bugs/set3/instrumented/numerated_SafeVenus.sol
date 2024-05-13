1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.2;
3 
4 /*
5   ___                      _   _
6  | _ )_  _ _ _  _ _ _  _  | | | |
7  | _ \ || | ' \| ' \ || | |_| |_|
8  |___/\_,_|_||_|_||_\_, | (_) (_)
9                     |__/
10 
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 BunnyFinance
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 */
34 
35 import "@openzeppelin/contracts/math/Math.sol";
36 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
37 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
38 import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
39 
40 import "./SafeDecimal.sol";
41 import "../interfaces/IPriceCalculator.sol";
42 import "../interfaces/IVenusDistribution.sol";
43 import "../interfaces/IVenusPriceOracle.sol";
44 import "../interfaces/IVToken.sol";
45 import "../interfaces/IVaultVenusBridge.sol";
46 
47 import "../vaults/venus/VaultVenus.sol";
48 
49 
50 contract SafeVenus is OwnableUpgradeable {
51     using SafeMath for uint;
52     using SafeDecimal for uint;
53 
54     IPriceCalculator private constant PRICE_CALCULATOR = IPriceCalculator(0xF5BF8A9249e3cc4cB684E3f23db9669323d4FB7d);
55     IVenusDistribution private constant VENUS_UNITROLLER = IVenusDistribution(0xfD36E2c2a6789Db23113685031d7F16329158384);
56 
57     address private constant XVS = 0xcF6BB5389c92Bdda8a3747Ddb454cB7a64626C63;
58     uint private constant BLOCK_PER_DAY = 28800;
59 
60     /* ========== INITIALIZER ========== */
61 
62     function initialize() external initializer {
63         __Ownable_init();
64     }
65 
66     function valueOfUnderlying(IVToken vToken, uint amount) internal view returns (uint) {
67         IVenusPriceOracle venusOracle = IVenusPriceOracle(VENUS_UNITROLLER.oracle());
68         return venusOracle.getUnderlyingPrice(vToken).mul(amount).div(1e18);
69     }
70 
71     /* ========== safeMintAmount ========== */
72 
73     function safeMintAmount(address payable vault) public view returns (uint mintable, uint mintableInUSD) {
74         VaultVenus vaultVenus = VaultVenus(vault);
75         mintable = vaultVenus.balanceAvailable().sub(vaultVenus.balanceReserved());
76         mintableInUSD = valueOfUnderlying(vaultVenus.vToken(), mintable);
77     }
78 
79     /* ========== safeBorrowAndRedeemAmount ========== */
80 
81     function safeBorrowAndRedeemAmount(address payable vault) public returns (uint borrowable, uint redeemable) {
82         VaultVenus vaultVenus = VaultVenus(vault);
83         uint collateralRatioLimit = vaultVenus.collateralRatioLimit();
84 
85         (, uint accountLiquidityInUSD,) = VENUS_UNITROLLER.getAccountLiquidity(address(vaultVenus.venusBridge()));
86         uint stakingTokenPriceInUSD = valueOfUnderlying(vaultVenus.vToken(), 1e18);
87         uint safeLiquidity = accountLiquidityInUSD.mul(1e18).div(stakingTokenPriceInUSD).mul(990).div(1000);
88 
89         (uint accountBorrow, uint accountSupply) = venusBorrowAndSupply(vault);
90         uint supplyFactor = collateralRatioLimit.mul(accountSupply).div(1e18);
91         uint borrowAmount = supplyFactor > accountBorrow ? supplyFactor.sub(accountBorrow).mul(1e18).div(uint(1e18).sub(collateralRatioLimit)) : 0;
92         uint redeemAmount = accountBorrow > supplyFactor ? accountBorrow.sub(supplyFactor).mul(1e18).div(uint(1e18).sub(collateralRatioLimit)) : uint(- 1);
93         return (Math.min(borrowAmount, safeLiquidity), Math.min(redeemAmount, safeLiquidity));
94     }
95 
96     function safeBorrowAmount(address payable vault) public returns (uint borrowable) {
97         VaultVenus vaultVenus = VaultVenus(vault);
98         IVToken vToken = vaultVenus.vToken();
99         uint collateralRatioLimit = vaultVenus.collateralRatioLimit();
100         uint stakingTokenPriceInUSD = valueOfUnderlying(vToken, 1e18);
101 
102         (, uint accountLiquidityInUSD,) = VENUS_UNITROLLER.getAccountLiquidity(address(vaultVenus.venusBridge()));
103         uint accountLiquidity = accountLiquidityInUSD.mul(1e18).div(stakingTokenPriceInUSD);
104         uint marketSupply = vToken.totalSupply().mul(vToken.exchangeRateCurrent()).div(1e18);
105         uint marketLiquidity = marketSupply > vToken.totalBorrowsCurrent() ? marketSupply.sub(vToken.totalBorrowsCurrent()) : 0;
106         uint safeLiquidity = Math.min(marketLiquidity, accountLiquidity).mul(990).div(1000);
107 
108         (uint accountBorrow, uint accountSupply) = venusBorrowAndSupply(vault);
109         uint supplyFactor = collateralRatioLimit.mul(accountSupply).div(1e18);
110         uint borrowAmount = supplyFactor > accountBorrow ? supplyFactor.sub(accountBorrow).mul(1e18).div(uint(1e18).sub(collateralRatioLimit)) : 0;
111         return Math.min(borrowAmount, safeLiquidity);
112     }
113 
114     function safeRedeemAmount(address payable vault) public returns (uint redeemable) {
115         VaultVenus vaultVenus = VaultVenus(vault);
116         IVToken vToken = vaultVenus.vToken();
117 
118         (, uint collateralFactorMantissa,) = VENUS_UNITROLLER.markets(address(vToken));
119         uint collateralRatioLimit = collateralFactorMantissa.mul(vaultVenus.collateralRatioFactor()).div(1000);
120         uint stakingTokenPriceInUSD = valueOfUnderlying(vToken, 1e18);
121 
122         (, uint accountLiquidityInUSD,) = VENUS_UNITROLLER.getAccountLiquidity(address(vaultVenus.venusBridge()));
123         uint accountLiquidity = accountLiquidityInUSD.mul(1e18).div(stakingTokenPriceInUSD);
124         uint marketSupply = vToken.totalSupply().mul(vToken.exchangeRateCurrent()).div(1e18);
125         uint marketLiquidity = marketSupply > vToken.totalBorrowsCurrent() ? marketSupply.sub(vToken.totalBorrowsCurrent()) : 0;
126         uint safeLiquidity = Math.min(marketLiquidity, accountLiquidity).mul(990).div(1000);
127 
128         (uint accountBorrow, uint accountSupply) = venusBorrowAndSupply(vault);
129         uint supplyFactor = collateralRatioLimit.mul(accountSupply).div(1e18);
130         uint redeemAmount = accountBorrow > supplyFactor ? accountBorrow.sub(supplyFactor).mul(1e18).div(uint(1e18).sub(collateralRatioLimit)) : uint(- 1);
131         return Math.min(redeemAmount, safeLiquidity);
132     }
133 
134     function venusBorrowAndSupply(address payable vault) public returns (uint borrow, uint supply) {
135         VaultVenus vaultVenus = VaultVenus(vault);
136         borrow = vaultVenus.vToken().borrowBalanceCurrent(address(vaultVenus.venusBridge()));
137         supply = IVaultVenusBridge(vaultVenus.venusBridge()).balanceOfUnderlying(vault);
138     }
139 
140     /* ========== safeCompoundDepth ========== */
141 
142     function safeCompoundDepth(address payable vault) public returns (uint) {
143         VaultVenus vaultVenus = VaultVenus(vault);
144         IVToken vToken = vaultVenus.vToken();
145         address stakingToken = vaultVenus.stakingToken();
146 
147         (uint apyBorrow, bool borrowWithDebt) = _venusAPYBorrow(vToken, stakingToken);
148         return borrowWithDebt && _venusAPYSupply(vToken, stakingToken) <= apyBorrow + 2e15 ? 0 : vaultVenus.collateralDepth();
149     }
150 
151     function _venusAPYBorrow(IVToken vToken, address stakingToken) private returns (uint apy, bool borrowWithDebt) {
152         (, uint xvsValueInUSD) = PRICE_CALCULATOR.valueOfAsset(XVS, VENUS_UNITROLLER.venusSpeeds(address(vToken)).mul(BLOCK_PER_DAY));
153         (, uint borrowValueInUSD) = PRICE_CALCULATOR.valueOfAsset(stakingToken, vToken.totalBorrowsCurrent());
154 
155         uint apyBorrow = vToken.borrowRatePerBlock().mul(BLOCK_PER_DAY).add(1e18).power(365).sub(1e18);
156         uint apyBorrowXVS = xvsValueInUSD.mul(1e18).div(borrowValueInUSD).add(1e18).power(365).sub(1e18);
157         apy = apyBorrow > apyBorrowXVS ? apyBorrow.sub(apyBorrowXVS) : apyBorrowXVS.sub(apyBorrow);
158         borrowWithDebt = apyBorrow > apyBorrowXVS;
159     }
160 
161     function _venusAPYSupply(IVToken vToken, address stakingToken) private returns (uint apy) {
162         (, uint xvsValueInUSD) = PRICE_CALCULATOR.valueOfAsset(XVS, VENUS_UNITROLLER.venusSpeeds(address(vToken)).mul(BLOCK_PER_DAY));
163         (, uint supplyValueInUSD) = PRICE_CALCULATOR.valueOfAsset(stakingToken, vToken.totalSupply().mul(vToken.exchangeRateCurrent()).div(1e18));
164 
165         uint apySupply = vToken.supplyRatePerBlock().mul(BLOCK_PER_DAY).add(1e18).power(365).sub(1e18);
166         uint apySupplyXVS = xvsValueInUSD.mul(1e18).div(supplyValueInUSD).add(1e18).power(365).sub(1e18);
167         apy = apySupply.add(apySupplyXVS);
168     }
169 }
