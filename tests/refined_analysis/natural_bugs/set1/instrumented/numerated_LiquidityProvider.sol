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
15 import {IDODOLpToken} from "../intf/IDODOLpToken.sol";
16 import {Storage} from "./Storage.sol";
17 import {Settlement} from "./Settlement.sol";
18 import {Pricing} from "./Pricing.sol";
19 
20 
21 /**
22  * @title LiquidityProvider
23  * @author DODO Breeder
24  *
25  * @notice Functions for liquidity provider operations
26  */
27 contract LiquidityProvider is Storage, Pricing, Settlement {
28     using SafeMath for uint256;
29 
30     // ============ Events ============
31 
32     event Deposit(
33         address indexed payer,
34         address indexed receiver,
35         bool isBaseToken,
36         uint256 amount,
37         uint256 lpTokenAmount
38     );
39 
40     event Withdraw(
41         address indexed payer,
42         address indexed receiver,
43         bool isBaseToken,
44         uint256 amount,
45         uint256 lpTokenAmount
46     );
47 
48     event ChargePenalty(address indexed payer, bool isBaseToken, uint256 amount);
49 
50     // ============ Modifiers ============
51 
52     modifier depositQuoteAllowed() {
53         require(_DEPOSIT_QUOTE_ALLOWED_, "DEPOSIT_QUOTE_NOT_ALLOWED");
54         _;
55     }
56 
57     modifier depositBaseAllowed() {
58         require(_DEPOSIT_BASE_ALLOWED_, "DEPOSIT_BASE_NOT_ALLOWED");
59         _;
60     }
61 
62     modifier dodoNotClosed() {
63         require(!_CLOSED_, "DODO_CLOSED");
64         _;
65     }
66 
67     // ============ Routine Functions ============
68 
69     function withdrawBase(uint256 amount) external returns (uint256) {
70         return withdrawBaseTo(msg.sender, amount);
71     }
72 
73     function depositBase(uint256 amount) external returns (uint256) {
74         return depositBaseTo(msg.sender, amount);
75     }
76 
77     function withdrawQuote(uint256 amount) external returns (uint256) {
78         return withdrawQuoteTo(msg.sender, amount);
79     }
80 
81     function depositQuote(uint256 amount) external returns (uint256) {
82         return depositQuoteTo(msg.sender, amount);
83     }
84 
85     function withdrawAllBase() external returns (uint256) {
86         return withdrawAllBaseTo(msg.sender);
87     }
88 
89     function withdrawAllQuote() external returns (uint256) {
90         return withdrawAllQuoteTo(msg.sender);
91     }
92 
93     // ============ Deposit Functions ============
94 
95     function depositQuoteTo(address to, uint256 amount)
96         public
97         preventReentrant
98         depositQuoteAllowed
99         returns (uint256)
100     {
101         (, uint256 quoteTarget) = getExpectedTarget();
102         uint256 totalQuoteCapital = getTotalQuoteCapital();
103         uint256 capital = amount;
104         if (totalQuoteCapital == 0) {
105             // give remaining quote token to lp as a gift
106             capital = amount.add(quoteTarget);
107         } else if (quoteTarget > 0) {
108             capital = amount.mul(totalQuoteCapital).div(quoteTarget);
109         }
110 
111         // settlement
112         _quoteTokenTransferIn(msg.sender, amount);
113         _mintQuoteCapital(to, capital);
114         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.add(amount);
115 
116         emit Deposit(msg.sender, to, false, amount, capital);
117         return capital;
118     }
119 
120     function depositBaseTo(address to, uint256 amount)
121         public
122         preventReentrant
123         depositBaseAllowed
124         returns (uint256)
125     {
126         (uint256 baseTarget, ) = getExpectedTarget();
127         uint256 totalBaseCapital = getTotalBaseCapital();
128         uint256 capital = amount;
129         if (totalBaseCapital == 0) {
130             // give remaining base token to lp as a gift
131             capital = amount.add(baseTarget);
132         } else if (baseTarget > 0) {
133             capital = amount.mul(totalBaseCapital).div(baseTarget);
134         }
135 
136         // settlement
137         _baseTokenTransferIn(msg.sender, amount);
138         _mintBaseCapital(to, capital);
139         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.add(amount);
140 
141         emit Deposit(msg.sender, to, true, amount, capital);
142         return capital;
143     }
144 
145     // ============ Withdraw Functions ============
146 
147     function withdrawQuoteTo(address to, uint256 amount)
148         public
149         preventReentrant
150         dodoNotClosed
151         returns (uint256)
152     {
153         // calculate capital
154         (, uint256 quoteTarget) = getExpectedTarget();
155         uint256 totalQuoteCapital = getTotalQuoteCapital();
156         require(totalQuoteCapital > 0, "NO_QUOTE_LP");
157 
158         uint256 requireQuoteCapital = amount.mul(totalQuoteCapital).divCeil(quoteTarget);
159         require(
160             requireQuoteCapital <= getQuoteCapitalBalanceOf(msg.sender),
161             "LP_QUOTE_CAPITAL_BALANCE_NOT_ENOUGH"
162         );
163 
164         // handle penalty, penalty may exceed amount
165         uint256 penalty = getWithdrawQuotePenalty(amount);
166         require(penalty < amount, "PENALTY_EXCEED");
167 
168         // settlement
169         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.sub(amount);
170         _burnQuoteCapital(msg.sender, requireQuoteCapital);
171         _quoteTokenTransferOut(to, amount.sub(penalty));
172         _donateQuoteToken(penalty);
173 
174         emit Withdraw(msg.sender, to, false, amount.sub(penalty), requireQuoteCapital);
175         emit ChargePenalty(msg.sender, false, penalty);
176 
177         return amount.sub(penalty);
178     }
179 
180     function withdrawBaseTo(address to, uint256 amount)
181         public
182         preventReentrant
183         dodoNotClosed
184         returns (uint256)
185     {
186         // calculate capital
187         (uint256 baseTarget, ) = getExpectedTarget();
188         uint256 totalBaseCapital = getTotalBaseCapital();
189         require(totalBaseCapital > 0, "NO_BASE_LP");
190 
191         uint256 requireBaseCapital = amount.mul(totalBaseCapital).divCeil(baseTarget);
192         require(
193             requireBaseCapital <= getBaseCapitalBalanceOf(msg.sender),
194             "LP_BASE_CAPITAL_BALANCE_NOT_ENOUGH"
195         );
196 
197         // handle penalty, penalty may exceed amount
198         uint256 penalty = getWithdrawBasePenalty(amount);
199         require(penalty <= amount, "PENALTY_EXCEED");
200 
201         // settlement
202         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.sub(amount);
203         _burnBaseCapital(msg.sender, requireBaseCapital);
204         _baseTokenTransferOut(to, amount.sub(penalty));
205         _donateBaseToken(penalty);
206 
207         emit Withdraw(msg.sender, to, true, amount.sub(penalty), requireBaseCapital);
208         emit ChargePenalty(msg.sender, true, penalty);
209 
210         return amount.sub(penalty);
211     }
212 
213     // ============ Withdraw all Functions ============
214 
215     function withdrawAllQuoteTo(address to)
216         public
217         preventReentrant
218         dodoNotClosed
219         returns (uint256)
220     {
221         uint256 withdrawAmount = getLpQuoteBalance(msg.sender);
222         uint256 capital = getQuoteCapitalBalanceOf(msg.sender);
223 
224         // handle penalty, penalty may exceed amount
225         uint256 penalty = getWithdrawQuotePenalty(withdrawAmount);
226         require(penalty <= withdrawAmount, "PENALTY_EXCEED");
227 
228         // settlement
229         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.sub(withdrawAmount);
230         _burnQuoteCapital(msg.sender, capital);
231         _quoteTokenTransferOut(to, withdrawAmount.sub(penalty));
232         _donateQuoteToken(penalty);
233 
234         emit Withdraw(msg.sender, to, false, withdrawAmount, capital);
235         emit ChargePenalty(msg.sender, false, penalty);
236 
237         return withdrawAmount.sub(penalty);
238     }
239 
240     function withdrawAllBaseTo(address to) public preventReentrant dodoNotClosed returns (uint256) {
241         uint256 withdrawAmount = getLpBaseBalance(msg.sender);
242         uint256 capital = getBaseCapitalBalanceOf(msg.sender);
243 
244         // handle penalty, penalty may exceed amount
245         uint256 penalty = getWithdrawBasePenalty(withdrawAmount);
246         require(penalty <= withdrawAmount, "PENALTY_EXCEED");
247 
248         // settlement
249         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.sub(withdrawAmount);
250         _burnBaseCapital(msg.sender, capital);
251         _baseTokenTransferOut(to, withdrawAmount.sub(penalty));
252         _donateBaseToken(penalty);
253 
254         emit Withdraw(msg.sender, to, true, withdrawAmount, capital);
255         emit ChargePenalty(msg.sender, true, penalty);
256 
257         return withdrawAmount.sub(penalty);
258     }
259 
260     // ============ Helper Functions ============
261 
262     function _mintBaseCapital(address user, uint256 amount) internal {
263         IDODOLpToken(_BASE_CAPITAL_TOKEN_).mint(user, amount);
264     }
265 
266     function _mintQuoteCapital(address user, uint256 amount) internal {
267         IDODOLpToken(_QUOTE_CAPITAL_TOKEN_).mint(user, amount);
268     }
269 
270     function _burnBaseCapital(address user, uint256 amount) internal {
271         IDODOLpToken(_BASE_CAPITAL_TOKEN_).burn(user, amount);
272     }
273 
274     function _burnQuoteCapital(address user, uint256 amount) internal {
275         IDODOLpToken(_QUOTE_CAPITAL_TOKEN_).burn(user, amount);
276     }
277 
278     // ============ Getter Functions ============
279 
280     function getLpBaseBalance(address lp) public view returns (uint256 lpBalance) {
281         uint256 totalBaseCapital = getTotalBaseCapital();
282         (uint256 baseTarget, ) = getExpectedTarget();
283         if (totalBaseCapital == 0) {
284             return 0;
285         }
286         lpBalance = getBaseCapitalBalanceOf(lp).mul(baseTarget).div(totalBaseCapital);
287         return lpBalance;
288     }
289 
290     function getLpQuoteBalance(address lp) public view returns (uint256 lpBalance) {
291         uint256 totalQuoteCapital = getTotalQuoteCapital();
292         (, uint256 quoteTarget) = getExpectedTarget();
293         if (totalQuoteCapital == 0) {
294             return 0;
295         }
296         lpBalance = getQuoteCapitalBalanceOf(lp).mul(quoteTarget).div(totalQuoteCapital);
297         return lpBalance;
298     }
299 
300     function getWithdrawQuotePenalty(uint256 amount) public view returns (uint256 penalty) {
301         require(amount <= _QUOTE_BALANCE_, "DODO_QUOTE_BALANCE_NOT_ENOUGH");
302         if (_R_STATUS_ == Types.RStatus.BELOW_ONE) {
303             uint256 spareBase = _BASE_BALANCE_.sub(_TARGET_BASE_TOKEN_AMOUNT_);
304             uint256 price = getOraclePrice();
305             uint256 fairAmount = DecimalMath.mul(spareBase, price);
306             uint256 targetQuote = DODOMath._SolveQuadraticFunctionForTarget(
307                 _QUOTE_BALANCE_,
308                 _K_,
309                 fairAmount
310             );
311             // if amount = _QUOTE_BALANCE_, div error
312             uint256 targetQuoteWithWithdraw = DODOMath._SolveQuadraticFunctionForTarget(
313                 _QUOTE_BALANCE_.sub(amount),
314                 _K_,
315                 fairAmount
316             );
317             return targetQuote.sub(targetQuoteWithWithdraw.add(amount));
318         } else {
319             return 0;
320         }
321     }
322 
323     function getWithdrawBasePenalty(uint256 amount) public view returns (uint256 penalty) {
324         require(amount <= _BASE_BALANCE_, "DODO_BASE_BALANCE_NOT_ENOUGH");
325         if (_R_STATUS_ == Types.RStatus.ABOVE_ONE) {
326             uint256 spareQuote = _QUOTE_BALANCE_.sub(_TARGET_QUOTE_TOKEN_AMOUNT_);
327             uint256 price = getOraclePrice();
328             uint256 fairAmount = DecimalMath.divFloor(spareQuote, price);
329             uint256 targetBase = DODOMath._SolveQuadraticFunctionForTarget(
330                 _BASE_BALANCE_,
331                 _K_,
332                 fairAmount
333             );
334             // if amount = _BASE_BALANCE_, div error
335             uint256 targetBaseWithWithdraw = DODOMath._SolveQuadraticFunctionForTarget(
336                 _BASE_BALANCE_.sub(amount),
337                 _K_,
338                 fairAmount
339             );
340             return targetBase.sub(targetBaseWithWithdraw.add(amount));
341         } else {
342             return 0;
343         }
344     }
345 }
