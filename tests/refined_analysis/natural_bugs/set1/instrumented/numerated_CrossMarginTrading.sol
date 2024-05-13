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
11 import "./CrossMarginLiquidation.sol";
12 
13 // Goal: all external functions only accessible to margintrader role
14 // except for view functions of course
15 
16 contract CrossMarginTrading is CrossMarginLiquidation, IMarginTrading {
17     constructor(address _peg, address _roles)
18         RoleAware(_roles)
19         PriceAware(_peg)
20     {
21         liquidationThresholdPercent = 110;
22         coolingOffPeriod = 20;
23         leveragePercent = 300;
24     }
25 
26     /// @dev admin function to set the token cap
27     function setTokenCap(address token, uint256 cap) external {
28         require(
29             isTokenActivator(msg.sender),
30             "Caller not authorized to set token cap"
31         );
32         tokenCaps[token] = cap;
33     }
34 
35     /// @dev setter for cooling off period for withdrawing funds after deposit
36     function setCoolingOffPeriod(uint256 blocks) external onlyOwner {
37         coolingOffPeriod = blocks;
38     }
39 
40     /// @dev admin function to set leverage
41     function setLeverage(uint256 _leveragePercent) external onlyOwner {
42         leveragePercent = _leveragePercent;
43     }
44 
45     /// @dev admin function to set liquidation threshold
46     function setLiquidationThresholdPercent(uint256 threshold)
47         external
48         onlyOwner
49     {
50         liquidationThresholdPercent = threshold;
51     }
52 
53     /// @dev gets called by router to affirm a deposit to an account
54     function registerDeposit(
55         address trader,
56         address token,
57         uint256 depositAmount
58     ) external override returns (uint256 extinguishableDebt) {
59         require(
60             isMarginTrader(msg.sender),
61             "Calling contract not authorized to deposit"
62         );
63 
64         CrossMarginAccount storage account = marginAccounts[trader];
65         account.lastDepositBlock = block.number;
66 
67         if (account.borrowed[token] > 0) {
68             extinguishableDebt = min(depositAmount, account.borrowed[token]);
69             extinguishDebt(account, token, extinguishableDebt);
70             totalShort[token] -= extinguishableDebt;
71         }
72 
73         // no overflow because depositAmount >= extinguishableDebt
74         uint256 addedHolding = depositAmount - extinguishableDebt;
75         _registerDeposit(account, token, addedHolding);
76     }
77 
78     function _registerDeposit(
79         CrossMarginAccount storage account,
80         address token,
81         uint256 addedHolding
82     ) internal {
83         addHolding(account, token, addedHolding);
84 
85         totalLong[token] += addedHolding;
86         require(
87             tokenCaps[token] >= totalLong[token],
88             "Exceeding global exposure cap to token -- try again later"
89         );
90     }
91 
92     /// @dev gets called by router to affirm borrowing event
93     function registerBorrow(
94         address trader,
95         address borrowToken,
96         uint256 borrowAmount
97     ) external override {
98         require(
99             isMarginTrader(msg.sender),
100             "Calling contract not authorized to deposit"
101         );
102         CrossMarginAccount storage account = marginAccounts[trader];
103         _registerBorrow(account, borrowToken, borrowAmount);
104     }
105 
106     function _registerBorrow(
107         CrossMarginAccount storage account,
108         address borrowToken,
109         uint256 borrowAmount
110     ) internal {
111         totalShort[borrowToken] += borrowAmount;
112         totalLong[borrowToken] += borrowAmount;
113         require(
114             tokenCaps[borrowToken] >= totalShort[borrowToken] &&
115                 tokenCaps[borrowToken] >= totalLong[borrowToken],
116             "Exceeding global exposure cap to token -- try again later"
117         );
118 
119         borrow(account, borrowToken, borrowAmount);
120     }
121 
122     /// @dev gets called by router to affirm withdrawal of tokens from account
123     function registerWithdrawal(
124         address trader,
125         address withdrawToken,
126         uint256 withdrawAmount
127     ) external override {
128         require(
129             isMarginTrader(msg.sender),
130             "Calling contract not authorized to deposit"
131         );
132         CrossMarginAccount storage account = marginAccounts[trader];
133         _registerWithdrawal(account, withdrawToken, withdrawAmount);
134     }
135 
136     function _registerWithdrawal(
137         CrossMarginAccount storage account,
138         address withdrawToken,
139         uint256 withdrawAmount
140     ) internal {
141         require(
142             block.number > account.lastDepositBlock + coolingOffPeriod,
143             "To prevent attacks you must wait until your cooling off period is over to withdraw"
144         );
145 
146         totalLong[withdrawToken] -= withdrawAmount;
147         // throws on underflow
148         account.holdings[withdrawToken] =
149             account.holdings[withdrawToken] -
150             withdrawAmount;
151         require(
152             positiveBalance(account),
153             "Account balance is too low to withdraw"
154         );
155     }
156 
157     /// @dev overcollateralized borrowing on a cross margin account, called by router
158     function registerOvercollateralizedBorrow(
159         address trader,
160         address depositToken,
161         uint256 depositAmount,
162         address borrowToken,
163         uint256 withdrawAmount
164     ) external override {
165         require(
166             isMarginTrader(msg.sender),
167             "Calling contract not authorized to deposit"
168         );
169 
170         CrossMarginAccount storage account = marginAccounts[trader];
171 
172         _registerDeposit(account, depositToken, depositAmount);
173         _registerBorrow(account, borrowToken, withdrawAmount);
174         _registerWithdrawal(account, borrowToken, withdrawAmount);
175 
176         account.lastDepositBlock = block.number;
177     }
178 
179     /// @dev gets called by router to register a trade and borrow and extinguish as necessary
180     function registerTradeAndBorrow(
181         address trader,
182         address tokenFrom,
183         address tokenTo,
184         uint256 inAmount,
185         uint256 outAmount
186     )
187         external
188         override
189         returns (uint256 extinguishableDebt, uint256 borrowAmount)
190     {
191         require(
192             isMarginTrader(msg.sender),
193             "Calling contract is not an authorized margin trader agent"
194         );
195 
196         CrossMarginAccount storage account = marginAccounts[trader];
197 
198         if (account.borrowed[tokenTo] > 0) {
199             extinguishableDebt = min(outAmount, account.borrowed[tokenTo]);
200             extinguishDebt(account, tokenTo, extinguishableDebt);
201             totalShort[tokenTo] -= extinguishableDebt;
202         }
203         totalLong[tokenFrom] -= inAmount;
204         totalLong[tokenTo] += outAmount - extinguishableDebt;
205         require(
206             tokenCaps[tokenTo] >= totalLong[tokenTo],
207             "Exceeding global exposure cap to token -- try again later"
208         );
209 
210         uint256 sellAmount = inAmount;
211         if (inAmount > account.holdings[tokenFrom]) {
212             sellAmount = account.holdings[tokenFrom];
213             /// won't overflow
214             borrowAmount = inAmount - sellAmount;
215 
216             totalShort[tokenFrom] += borrowAmount;
217             require(
218                 tokenCaps[tokenFrom] >= totalShort[tokenFrom],
219                 "Exceeding global exposure cap to token -- try again later"
220             );
221 
222             borrow(account, tokenFrom, borrowAmount);
223         }
224         adjustAmounts(account, tokenFrom, tokenTo, sellAmount, outAmount);
225     }
226 
227     /// @dev can get called by router to register the dissolution of an account
228     function registerLiquidation(address trader) external override {
229         require(
230             isMarginTrader(msg.sender),
231             "Calling contract is not an authorized margin trader agent"
232         );
233         CrossMarginAccount storage account = marginAccounts[trader];
234         require(
235             loanInPeg(account, false) == 0,
236             "Can't liquidate currently borrowing account"
237         );
238 
239         deleteAccount(account);
240     }
241 
242     /// @dev view function to display account held assets state
243     function getHoldingAmounts(address trader)
244         external
245         view
246         override
247         returns (
248             address[] memory holdingTokens,
249             uint256[] memory holdingAmounts
250         )
251     {
252         CrossMarginAccount storage account = marginAccounts[trader];
253         holdingTokens = account.holdingTokens;
254 
255         holdingAmounts = new uint256[](account.holdingTokens.length);
256         for (uint256 idx = 0; holdingTokens.length > idx; idx++) {
257             address tokenAddress = holdingTokens[idx];
258             holdingAmounts[idx] = account.holdings[tokenAddress];
259         }
260     }
261 
262     /// @dev view function to display account borrowing state
263     function getBorrowAmounts(address trader)
264         external
265         view
266         override
267         returns (address[] memory borrowTokens, uint256[] memory borrowAmounts)
268     {
269         CrossMarginAccount storage account = marginAccounts[trader];
270         borrowTokens = account.borrowTokens;
271 
272         borrowAmounts = new uint256[](account.borrowTokens.length);
273         for (uint256 idx = 0; borrowTokens.length > idx; idx++) {
274             address tokenAddress = borrowTokens[idx];
275             borrowAmounts[idx] = Lending(lending()).viewBorrowInterest(
276                 account.borrowed[tokenAddress],
277                 tokenAddress,
278                 account.borrowedYieldQuotientsFP[tokenAddress]
279             );
280         }
281     }
282 
283     /// @dev view function to get loan amount in peg
284     function viewLoanInPeg(address trader)
285         external
286         view
287         returns (uint256 amount)
288     {
289         CrossMarginAccount storage account = marginAccounts[trader];
290         return
291             viewTokensInPegWithYield(
292                 account.borrowTokens,
293                 account.borrowed,
294                 account.borrowedYieldQuotientsFP
295             );
296     }
297 
298     /// @dev total of assets of account, expressed in reference currency
299     function viewHoldingsInPeg(address trader) external view returns (uint256) {
300         CrossMarginAccount storage account = marginAccounts[trader];
301         return viewTokensInPeg(account.holdingTokens, account.holdings);
302     }
303 }
