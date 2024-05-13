1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 
7 import "./Fund.sol";
8 import "./Lending.sol";
9 import "./RoleAware.sol";
10 import "./MarginRouter.sol";
11 import "./PriceAware.sol";
12 
13 // Goal: all external functions only accessible to margintrader role
14 // except for view functions of course
15 
16 struct CrossMarginAccount {
17     uint256 lastDepositBlock;
18     address[] borrowTokens;
19     // borrowed token address => amount
20     mapping(address => uint256) borrowed;
21     // borrowed token => yield quotient
22     mapping(address => uint256) borrowedYieldQuotientsFP;
23     address[] holdingTokens;
24     // token held in portfolio => amount
25     mapping(address => uint256) holdings;
26     // boolean value of whether an account holds a token
27     mapping(address => bool) holdsToken;
28 }
29 
30 abstract contract CrossMarginAccounts is RoleAware, PriceAware {
31     /// @dev gets used in calculating how much accounts can borrow
32     uint256 public leveragePercent;
33 
34     /// @dev percentage of assets held per assets borrowed at which to liquidate
35     uint256 public liquidationThresholdPercent;
36 
37     /// @dev record of all cross margin accounts
38     mapping(address => CrossMarginAccount) internal marginAccounts;
39     /// @dev total token caps
40     mapping(address => uint256) public tokenCaps;
41     /// @dev tracks total of short positions per token
42     mapping(address => uint256) public totalShort;
43     /// @dev tracks total of long positions per token
44     mapping(address => uint256) public totalLong;
45     uint256 public coolingOffPeriod;
46 
47     /// @dev last time this account deposited
48     /// relevant for withdrawal window
49     function getLastDepositBlock(address trader)
50         external
51         view
52         returns (uint256)
53     {
54         return marginAccounts[trader].lastDepositBlock;
55     }
56 
57     /// @dev add an asset to be held by account
58     function addHolding(
59         CrossMarginAccount storage account,
60         address token,
61         uint256 depositAmount
62     ) internal {
63         if (!hasHoldingToken(account, token)) {
64             account.holdingTokens.push(token);
65         }
66 
67         account.holdings[token] += depositAmount;
68     }
69 
70     /// @dev adjust account to reflect borrowing of token amount
71     function borrow(
72         CrossMarginAccount storage account,
73         address borrowToken,
74         uint256 borrowAmount
75     ) internal {
76         if (!hasBorrowedToken(account, borrowToken)) {
77             account.borrowTokens.push(borrowToken);
78         } else {
79             account.borrowed[borrowToken] = Lending(lending())
80                 .applyBorrowInterest(
81                 account.borrowed[borrowToken],
82                 borrowToken,
83                 account.borrowedYieldQuotientsFP[borrowToken]
84             );
85         }
86         account.borrowedYieldQuotientsFP[borrowToken] = Lending(lending())
87             .viewBorrowingYieldFP(borrowToken);
88 
89         account.borrowed[borrowToken] += borrowAmount;
90         addHolding(account, borrowToken, borrowAmount);
91 
92         require(positiveBalance(account), "Can't borrow: insufficient balance");
93     }
94 
95     /// @dev checks whether account is in the black, deposit + earnings relative to borrowed
96     function positiveBalance(CrossMarginAccount storage account)
97         internal
98         returns (bool)
99     {
100         uint256 loan = loanInPeg(account, false);
101         uint256 holdings = holdingsInPeg(account, false);
102         // The following condition should hold:
103         // holdings / loan >= leveragePercent / (leveragePercent - 100)
104         // =>
105         return holdings * (leveragePercent - 100) >= loan * leveragePercent;
106     }
107 
108     /// @dev internal function adjusting holding and borrow balances when debt extinguished
109     function extinguishDebt(
110         CrossMarginAccount storage account,
111         address debtToken,
112         uint256 extinguishAmount
113     ) internal {
114         // will throw if insufficient funds
115         account.borrowed[debtToken] = Lending(lending()).applyBorrowInterest(
116             account.borrowed[debtToken],
117             debtToken,
118             account.borrowedYieldQuotientsFP[debtToken]
119         );
120 
121         account.borrowed[debtToken] =
122             account.borrowed[debtToken] -
123             extinguishAmount;
124         account.holdings[debtToken] =
125             account.holdings[debtToken] -
126             extinguishAmount;
127 
128         if (account.borrowed[debtToken] > 0) {
129             account.borrowedYieldQuotientsFP[debtToken] = Lending(lending())
130                 .viewBorrowingYieldFP(debtToken);
131         } else {
132             delete account.borrowedYieldQuotientsFP[debtToken];
133 
134             bool decrement = false;
135             uint256 len = account.borrowTokens.length;
136             for (uint256 i; len > i; i++) {
137                 address currToken = account.borrowTokens[i];
138                 if (currToken == debtToken) {
139                     decrement = true;
140                 } else if (decrement) {
141                     account.borrowTokens[i - 1] = currToken;
142                 }
143             }
144             account.borrowTokens.pop();
145         }
146     }
147 
148     /// @dev checks whether an account holds a token
149     function hasHoldingToken(CrossMarginAccount storage account, address token)
150         internal
151         view
152         returns (bool)
153     {
154         return account.holdsToken[token];
155     }
156 
157     /// @dev checks whether an account has borrowed a token
158     function hasBorrowedToken(CrossMarginAccount storage account, address token)
159         internal
160         view
161         returns (bool)
162     {
163         return account.borrowedYieldQuotientsFP[token] > 0;
164     }
165 
166     /// @dev calculate total loan in reference currency, including compound interest
167     function loanInPeg(CrossMarginAccount storage account, bool forceCurBlock)
168         internal
169         returns (uint256)
170     {
171         return
172             sumTokensInPegWithYield(
173                 account.borrowTokens,
174                 account.borrowed,
175                 account.borrowedYieldQuotientsFP,
176                 forceCurBlock
177             );
178     }
179 
180     /// @dev total of assets of account, expressed in reference currency
181     function holdingsInPeg(
182         CrossMarginAccount storage account,
183         bool forceCurBlock
184     ) internal returns (uint256) {
185         return
186             sumTokensInPeg(
187                 account.holdingTokens,
188                 account.holdings,
189                 forceCurBlock
190             );
191     }
192 
193     /// @dev check whether an account can/should be liquidated
194     function belowMaintenanceThreshold(CrossMarginAccount storage account)
195         internal
196         returns (bool)
197     {
198         uint256 loan = loanInPeg(account, true);
199         uint256 holdings = holdingsInPeg(account, true);
200         // The following should hold:
201         // holdings / loan >= 1.1
202         // => holdings >= loan * 1.1
203         return 100 * holdings >= liquidationThresholdPercent * loan;
204     }
205 
206     /// @dev go through list of tokens and their amounts, summing up
207     function sumTokensInPeg(
208         address[] storage tokens,
209         mapping(address => uint256) storage amounts,
210         bool forceCurBlock
211     ) internal returns (uint256 totalPeg) {
212         uint256 len = tokens.length;
213         for (uint256 tokenId; tokenId < len; tokenId++) {
214             address token = tokens[tokenId];
215             totalPeg += PriceAware.getCurrentPriceInPeg(
216                 token,
217                 amounts[token],
218                 forceCurBlock
219             );
220         }
221     }
222 
223     /// @dev go through list of tokens and their amounts, summing up
224     function viewTokensInPeg(
225         address[] storage tokens,
226         mapping(address => uint256) storage amounts
227     ) internal view returns (uint256 totalPeg) {
228         uint256 len = tokens.length;
229         for (uint256 tokenId; tokenId < len; tokenId++) {
230             address token = tokens[tokenId];
231             totalPeg += PriceAware.viewCurrentPriceInPeg(token, amounts[token]);
232         }
233     }
234 
235     /// @dev go through list of tokens and ammounts, summing up with interest
236     function sumTokensInPegWithYield(
237         address[] storage tokens,
238         mapping(address => uint256) storage amounts,
239         mapping(address => uint256) storage yieldQuotientsFP,
240         bool forceCurBlock
241     ) internal returns (uint256 totalPeg) {
242         uint256 len = tokens.length;
243         for (uint256 tokenId; tokenId < len; tokenId++) {
244             address token = tokens[tokenId];
245             totalPeg += yieldTokenInPeg(
246                 token,
247                 amounts[token],
248                 yieldQuotientsFP,
249                 forceCurBlock
250             );
251         }
252     }
253 
254     /// @dev go through list of tokens and ammounts, summing up with interest
255     function viewTokensInPegWithYield(
256         address[] storage tokens,
257         mapping(address => uint256) storage amounts,
258         mapping(address => uint256) storage yieldQuotientsFP
259     ) internal view returns (uint256 totalPeg) {
260         uint256 len = tokens.length;
261         for (uint256 tokenId; tokenId < len; tokenId++) {
262             address token = tokens[tokenId];
263             totalPeg += viewYieldTokenInPeg(
264                 token,
265                 amounts[token],
266                 yieldQuotientsFP
267             );
268         }
269     }
270 
271     /// @dev calculate yield for token amount and convert to reference currency
272     function yieldTokenInPeg(
273         address token,
274         uint256 amount,
275         mapping(address => uint256) storage yieldQuotientsFP,
276         bool forceCurBlock
277     ) internal returns (uint256) {
278         uint256 yieldFP = Lending(lending()).viewBorrowingYieldFP(token);
279         // 1 * FP / FP = 1
280         uint256 amountInToken = (amount * yieldFP) / yieldQuotientsFP[token];
281         return
282             PriceAware.getCurrentPriceInPeg(
283                 token,
284                 amountInToken,
285                 forceCurBlock
286             );
287     }
288 
289     /// @dev calculate yield for token amount and convert to reference currency
290     function viewYieldTokenInPeg(
291         address token,
292         uint256 amount,
293         mapping(address => uint256) storage yieldQuotientsFP
294     ) internal view returns (uint256) {
295         uint256 yieldFP = Lending(lending()).viewBorrowingYieldFP(token);
296         // 1 * FP / FP = 1
297         uint256 amountInToken = (amount * yieldFP) / yieldQuotientsFP[token];
298         return PriceAware.viewCurrentPriceInPeg(token, amountInToken);
299     }
300 
301     /// @dev move tokens from one holding to another
302     function adjustAmounts(
303         CrossMarginAccount storage account,
304         address fromToken,
305         address toToken,
306         uint256 soldAmount,
307         uint256 boughtAmount
308     ) internal {
309         account.holdings[fromToken] = account.holdings[fromToken] - soldAmount;
310         addHolding(account, toToken, boughtAmount);
311     }
312 
313     /// sets borrow and holding to zero
314     function deleteAccount(CrossMarginAccount storage account) internal {
315         uint256 len = account.borrowTokens.length;
316         for (uint256 borrowIdx; len > borrowIdx; borrowIdx++) {
317             address borrowToken = account.borrowTokens[borrowIdx];
318             totalShort[borrowToken] -= account.borrowed[borrowToken];
319             account.borrowed[borrowToken] = 0;
320             account.borrowedYieldQuotientsFP[borrowToken] = 0;
321         }
322         len = account.holdingTokens.length;
323         for (uint256 holdingIdx; len > holdingIdx; holdingIdx++) {
324             address holdingToken = account.holdingTokens[holdingIdx];
325             totalLong[holdingToken] -= account.holdings[holdingToken];
326             account.holdings[holdingToken] = 0;
327             account.holdsToken[holdingToken] = false;
328         }
329         delete account.borrowTokens;
330         delete account.holdingTokens;
331     }
332 
333     /// @dev minimum
334     function min(uint256 a, uint256 b) internal pure returns (uint256) {
335         if (a > b) {
336             return b;
337         } else {
338             return a;
339         }
340     }
341 }
