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
12 import {DecimalMath} from "../lib/DecimalMath.sol";
13 import {DODOMath} from "../lib/DODOMath.sol";
14 import {Types} from "../lib/Types.sol";
15 import {Storage} from "./Storage.sol";
16 
17 
18 /**
19  * @title Pricing
20  * @author DODO Breeder
21  *
22  * @notice DODO Pricing model
23  */
24 contract Pricing is Storage {
25     using SafeMath for uint256;
26 
27     // ============ R = 1 cases ============
28 
29     function _ROneSellBaseToken(uint256 amount, uint256 targetQuoteTokenAmount)
30         internal
31         view
32         returns (uint256 receiveQuoteToken)
33     {
34         uint256 i = getOraclePrice();
35         uint256 Q2 = DODOMath._SolveQuadraticFunctionForTrade(
36             targetQuoteTokenAmount,
37             targetQuoteTokenAmount,
38             DecimalMath.mul(i, amount),
39             false,
40             _K_
41         );
42         // in theory Q2 <= targetQuoteTokenAmount
43         // however when amount is close to 0, precision problems may cause Q2 > targetQuoteTokenAmount
44         return targetQuoteTokenAmount.sub(Q2);
45     }
46 
47     function _ROneBuyBaseToken(uint256 amount, uint256 targetBaseTokenAmount)
48         internal
49         view
50         returns (uint256 payQuoteToken)
51     {
52         require(amount < targetBaseTokenAmount, "DODO_BASE_BALANCE_NOT_ENOUGH");
53         uint256 B2 = targetBaseTokenAmount.sub(amount);
54         payQuoteToken = _RAboveIntegrate(targetBaseTokenAmount, targetBaseTokenAmount, B2);
55         return payQuoteToken;
56     }
57 
58     // ============ R < 1 cases ============
59 
60     function _RBelowSellBaseToken(
61         uint256 amount,
62         uint256 quoteBalance,
63         uint256 targetQuoteAmount
64     ) internal view returns (uint256 receieQuoteToken) {
65         uint256 i = getOraclePrice();
66         uint256 Q2 = DODOMath._SolveQuadraticFunctionForTrade(
67             targetQuoteAmount,
68             quoteBalance,
69             DecimalMath.mul(i, amount),
70             false,
71             _K_
72         );
73         return quoteBalance.sub(Q2);
74     }
75 
76     function _RBelowBuyBaseToken(
77         uint256 amount,
78         uint256 quoteBalance,
79         uint256 targetQuoteAmount
80     ) internal view returns (uint256 payQuoteToken) {
81         // Here we don't require amount less than some value
82         // Because it is limited at upper function
83         // See Trader.queryBuyBaseToken
84         uint256 i = getOraclePrice();
85         uint256 Q2 = DODOMath._SolveQuadraticFunctionForTrade(
86             targetQuoteAmount,
87             quoteBalance,
88             DecimalMath.mulCeil(i, amount),
89             true,
90             _K_
91         );
92         return Q2.sub(quoteBalance);
93     }
94 
95     function _RBelowBackToOne() internal view returns (uint256 payQuoteToken) {
96         // important: carefully design the system to make sure spareBase always greater than or equal to 0
97         uint256 spareBase = _BASE_BALANCE_.sub(_TARGET_BASE_TOKEN_AMOUNT_);
98         uint256 price = getOraclePrice();
99         uint256 fairAmount = DecimalMath.mul(spareBase, price);
100         uint256 newTargetQuote = DODOMath._SolveQuadraticFunctionForTarget(
101             _QUOTE_BALANCE_,
102             _K_,
103             fairAmount
104         );
105         return newTargetQuote.sub(_QUOTE_BALANCE_);
106     }
107 
108     // ============ R > 1 cases ============
109 
110     function _RAboveBuyBaseToken(
111         uint256 amount,
112         uint256 baseBalance,
113         uint256 targetBaseAmount
114     ) internal view returns (uint256 payQuoteToken) {
115         require(amount < baseBalance, "DODO_BASE_BALANCE_NOT_ENOUGH");
116         uint256 B2 = baseBalance.sub(amount);
117         return _RAboveIntegrate(targetBaseAmount, baseBalance, B2);
118     }
119 
120     function _RAboveSellBaseToken(
121         uint256 amount,
122         uint256 baseBalance,
123         uint256 targetBaseAmount
124     ) internal view returns (uint256 receiveQuoteToken) {
125         // here we don't require B1 <= targetBaseAmount
126         // Because it is limited at upper function
127         // See Trader.querySellBaseToken
128         uint256 B1 = baseBalance.add(amount);
129         return _RAboveIntegrate(targetBaseAmount, B1, baseBalance);
130     }
131 
132     function _RAboveBackToOne() internal view returns (uint256 payBaseToken) {
133         // important: carefully design the system to make sure spareBase always greater than or equal to 0
134         uint256 spareQuote = _QUOTE_BALANCE_.sub(_TARGET_QUOTE_TOKEN_AMOUNT_);
135         uint256 price = getOraclePrice();
136         uint256 fairAmount = DecimalMath.divFloor(spareQuote, price);
137         uint256 newTargetBase = DODOMath._SolveQuadraticFunctionForTarget(
138             _BASE_BALANCE_,
139             _K_,
140             fairAmount
141         );
142         return newTargetBase.sub(_BASE_BALANCE_);
143     }
144 
145     // ============ Helper functions ============
146 
147     function getExpectedTarget() public view returns (uint256 baseTarget, uint256 quoteTarget) {
148         uint256 Q = _QUOTE_BALANCE_;
149         uint256 B = _BASE_BALANCE_;
150         if (_R_STATUS_ == Types.RStatus.ONE) {
151             return (_TARGET_BASE_TOKEN_AMOUNT_, _TARGET_QUOTE_TOKEN_AMOUNT_);
152         } else if (_R_STATUS_ == Types.RStatus.BELOW_ONE) {
153             uint256 payQuoteToken = _RBelowBackToOne();
154             return (_TARGET_BASE_TOKEN_AMOUNT_, Q.add(payQuoteToken));
155         } else if (_R_STATUS_ == Types.RStatus.ABOVE_ONE) {
156             uint256 payBaseToken = _RAboveBackToOne();
157             return (B.add(payBaseToken), _TARGET_QUOTE_TOKEN_AMOUNT_);
158         }
159     }
160 
161     function getMidPrice() public view returns (uint256 midPrice) {
162         (uint256 baseTarget, uint256 quoteTarget) = getExpectedTarget();
163         if (_R_STATUS_ == Types.RStatus.BELOW_ONE) {
164             uint256 R = DecimalMath.divFloor(
165                 quoteTarget.mul(quoteTarget).div(_QUOTE_BALANCE_),
166                 _QUOTE_BALANCE_
167             );
168             R = DecimalMath.ONE.sub(_K_).add(DecimalMath.mul(_K_, R));
169             return DecimalMath.divFloor(getOraclePrice(), R);
170         } else {
171             uint256 R = DecimalMath.divFloor(
172                 baseTarget.mul(baseTarget).div(_BASE_BALANCE_),
173                 _BASE_BALANCE_
174             );
175             R = DecimalMath.ONE.sub(_K_).add(DecimalMath.mul(_K_, R));
176             return DecimalMath.mul(getOraclePrice(), R);
177         }
178     }
179 
180     function _RAboveIntegrate(
181         uint256 B0,
182         uint256 B1,
183         uint256 B2
184     ) internal view returns (uint256) {
185         uint256 i = getOraclePrice();
186         return DODOMath._GeneralIntegrate(B0, B1, B2, i, _K_);
187     }
188 
189     // function _RBelowIntegrate(
190     //     uint256 Q0,
191     //     uint256 Q1,
192     //     uint256 Q2
193     // ) internal view returns (uint256) {
194     //     uint256 i = getOraclePrice();
195     //     i = DecimalMath.divFloor(DecimalMath.ONE, i); // 1/i
196     //     return DODOMath._GeneralIntegrate(Q0, Q1, Q2, i, _K_);
197     // }
198 }
