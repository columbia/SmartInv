1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 
7 import "../../../../libraries/AccountEncoding.sol";
8 
9 import "./BaseHandler.sol";
10 import "../../../../interfaces/ICTokenRegistry.sol";
11 import "../../../../interfaces/vendor/CToken.sol";
12 import "../../../../interfaces/vendor/ExponentialNoError.sol";
13 import "../../../../interfaces/vendor/Comptroller.sol";
14 import "../../../../libraries/Errors.sol";
15 import "../../../../libraries/ScaledMath.sol";
16 
17 contract CompoundHandler is BaseHandler, ExponentialNoError {
18     using ScaledMath for uint256;
19     using SafeERC20 for IERC20;
20     using AccountEncoding for bytes32;
21 
22     struct AccountLiquidityLocalVars {
23         uint256 sumCollateral;
24         uint256 sumBorrow;
25         uint256 cTokenBalance;
26         uint256 borrowBalance;
27         uint256 exchangeRateMantissa;
28         uint256 oraclePriceMantissa;
29         Exp collateralFactor;
30         Exp exchangeRate;
31         Exp oraclePrice;
32         Exp tokensToDenom;
33     }
34 
35     Comptroller public immutable comptroller;
36     ICTokenRegistry public immutable cTokenRegistry;
37 
38     constructor(address comptrollerAddress, address _cTokenRegistry) {
39         comptroller = Comptroller(comptrollerAddress);
40         cTokenRegistry = ICTokenRegistry(_cTokenRegistry);
41     }
42 
43     /**
44      * @notice Executes the top-up of a position.
45      * @param account Account holding the position.
46      * @param underlying Underlying for tup-up.
47      * @param amount Amount to top-up by.
48      * @return `true` if successful.
49      */
50     function topUp(
51         bytes32 account,
52         address underlying,
53         uint256 amount,
54         bytes memory extra
55     ) external override returns (bool) {
56         bool repayDebt = abi.decode(extra, (bool));
57         CToken ctoken = cTokenRegistry.fetchCToken(underlying);
58         uint256 initialTokens = ctoken.balanceOf(address(this));
59 
60         address addr = account.addr();
61 
62         if (repayDebt) {
63             amount -= _repayAnyDebt(addr, underlying, amount, ctoken);
64             if (amount == 0) return true;
65         }
66 
67         uint256 err;
68         if (underlying == address(0)) {
69             err = ctoken.mint{value: amount}(amount);
70         } else {
71             IERC20(underlying).safeApprove(address(ctoken), amount);
72             err = ctoken.mint(amount);
73         }
74         require(err == 0, Error.FAILED_MINT);
75 
76         uint256 newTokens = ctoken.balanceOf(address(this));
77         uint256 mintedTokens = newTokens - initialTokens;
78 
79         bool success = ctoken.transfer(addr, mintedTokens);
80         require(success, Error.FAILED_TRANSFER);
81         return true;
82     }
83 
84     /**
85      * @notice Returns the collaterization ratio of the user.
86      *         A result of 1.5 (x1e18) means that the user has a 150% collaterization ratio.
87      * @param account account for which to check the factor.
88      * @return User factor.
89      */
90     function getUserFactor(bytes32 account, bytes memory) external view override returns (uint256) {
91         (uint256 sumCollateral, uint256 sumBorrow) = _getAccountBorrowsAndSupply(account.addr());
92         if (sumBorrow == 0) {
93             return type(uint256).max;
94         }
95         return sumCollateral.scaledDiv(sumBorrow);
96     }
97 
98     /**
99      * @notice Repays any existing debt for the given underlying.
100      * @param account Account for which to repay the debt.
101      * @param underlying The underlying token to repay the debt for.
102      * @param maximum The maximum amount of debt to repay.
103      * @return The amount of debt that was repayed in the underlying.
104      */
105     function _repayAnyDebt(
106         address account,
107         address underlying,
108         uint256 maximum,
109         CToken ctoken
110     ) internal returns (uint256) {
111         uint256 debt = ctoken.borrowBalanceCurrent(account);
112         if (debt == 0) return 0;
113         if (debt > maximum) debt = maximum;
114 
115         uint256 err;
116         if (underlying == address(0)) {
117             CEther cether = CEther(address(ctoken));
118             err = cether.repayBorrowBehalf{value: debt}(account);
119         } else {
120             IERC20(underlying).safeApprove(address(ctoken), debt);
121             err = ctoken.repayBorrowBehalf(account, debt);
122         }
123         require(err == 0, Error.FAILED_REPAY_BORROW);
124 
125         return debt;
126     }
127 
128     function _getAccountBorrowsAndSupply(address account) internal view returns (uint256, uint256) {
129         AccountLiquidityLocalVars memory vars; // Holds all our calculation results
130         uint256 oErr;
131 
132         PriceOracle oracle = comptroller.oracle();
133         // For each asset the account is in
134         CToken[] memory assets = comptroller.getAssetsIn(account);
135         for (uint256 i = 0; i < assets.length; i++) {
136             CToken asset = assets[i];
137 
138             // Read the balances and exchange rate from the cToken
139             (oErr, vars.cTokenBalance, vars.borrowBalance, vars.exchangeRateMantissa) = asset
140                 .getAccountSnapshot(account);
141             require(oErr == 0, Error.FAILED_METHOD_CALL);
142             (, uint256 collateralFactorMantissa, ) = comptroller.markets(address(asset));
143             vars.collateralFactor = Exp({mantissa: collateralFactorMantissa});
144             vars.exchangeRate = Exp({mantissa: vars.exchangeRateMantissa});
145 
146             // Get the normalized price of the asset
147             vars.oraclePriceMantissa = oracle.getUnderlyingPrice(asset);
148             require(vars.oraclePriceMantissa != 0, Error.FAILED_METHOD_CALL);
149             vars.oraclePrice = Exp({mantissa: vars.oraclePriceMantissa});
150 
151             // Pre-compute a conversion factor from tokens -> ether (normalized price value)
152             vars.tokensToDenom = mul_(
153                 mul_(vars.collateralFactor, vars.exchangeRate),
154                 vars.oraclePrice
155             );
156 
157             // sumCollateral += tokensToDenom * cTokenBalance
158             vars.sumCollateral = mul_ScalarTruncateAddUInt(
159                 vars.tokensToDenom,
160                 vars.cTokenBalance,
161                 vars.sumCollateral
162             );
163 
164             // sumBorrow += oraclePrice * borrowBalance
165             vars.sumBorrow = mul_ScalarTruncateAddUInt(
166                 vars.oraclePrice,
167                 vars.borrowBalance,
168                 vars.sumBorrow
169             );
170         }
171 
172         return (vars.sumCollateral, vars.sumBorrow);
173     }
174 }
