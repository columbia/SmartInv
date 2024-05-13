1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "./CrossMarginAccounts.sol";
5 
6 /** 
7 @title Handles liquidation of accounts below maintenance threshold
8 @notice Liquidation can be called by the authorized staker, 
9 as determined in the Admin contract.
10 If the authorized staker is delinquent, other participants can jump
11 in and attack, taking their fees and potentially even their stake,
12 depending how delinquent the responsible authorized staker is.
13 */
14 abstract contract CrossMarginLiquidation is CrossMarginAccounts {
15     event LiquidationShortfall(uint256 amount);
16     event AccountLiquidated(address account);
17 
18     struct Liquidation {
19         uint256 buy;
20         uint256 sell;
21         uint256 blockNum;
22     }
23 
24     /// record kept around until a stake attacker can claim their reward
25     struct AccountLiqRecord {
26         uint256 blockNum;
27         address loser;
28         uint256 amount;
29         address stakeAttacker;
30     }
31 
32     mapping(address => Liquidation) liquidationAmounts;
33     address[] internal sellTokens;
34     address[] internal buyTokens;
35     address[] internal tradersToLiquidate;
36 
37     mapping(address => uint256) public maintenanceFailures;
38     mapping(address => AccountLiqRecord) public stakeAttackRecords;
39     uint256 public avgLiquidationPerCall = 10;
40 
41     uint256 public liqStakeAttackWindow = 5;
42     uint256 public MAINTAINER_CUT_PERCENT = 5;
43 
44     uint256 public failureThreshold = 10;
45 
46     /// Set failure threshold
47     function setFailureThreshold(uint256 threshFactor) external onlyOwner {
48         failureThreshold = threshFactor;
49     }
50 
51     /// Set liquidity stake attack window
52     function setLiqStakeAttackWindow(uint256 window) external onlyOwner {
53         liqStakeAttackWindow = window;
54     }
55 
56     /// Set maintainer's percent cut
57     function setMaintainerCutPercent(uint256 cut) external onlyOwner {
58         MAINTAINER_CUT_PERCENT = cut;
59     }
60 
61     /// @dev calcLiquidationAmounts does a number of tasks in this contract
62     /// and some of them are not straightforward.
63     /// First of all it aggregates liquidation amounts,
64     /// as well as which traders are ripe for liquidation, in storage (not in memory)
65     /// owing to the fact that arrays can't be pushed to and hash maps don't
66     /// exist in memory.
67     /// Then it also returns any stake attack funds if the stake was unsuccessful
68     /// (i.e. current caller is authorized). Also see context below.
69     function calcLiquidationAmounts(
70         address[] memory liquidationCandidates,
71         bool isAuthorized
72     ) internal returns (uint256 attackReturns) {
73         sellTokens = new address[](0);
74         buyTokens = new address[](0);
75         tradersToLiquidate = new address[](0);
76 
77         for (
78             uint256 traderIndex = 0;
79             liquidationCandidates.length > traderIndex;
80             traderIndex++
81         ) {
82             address traderAddress = liquidationCandidates[traderIndex];
83             CrossMarginAccount storage account = marginAccounts[traderAddress];
84             if (belowMaintenanceThreshold(account)) {
85                 tradersToLiquidate.push(traderAddress);
86                 for (
87                     uint256 sellIdx = 0;
88                     account.holdingTokens.length > sellIdx;
89                     sellIdx++
90                 ) {
91                     address token = account.holdingTokens[sellIdx];
92                     Liquidation storage liquidation = liquidationAmounts[token];
93 
94                     if (liquidation.blockNum != block.number) {
95                         liquidation.sell = account.holdings[token];
96                         liquidation.buy = 0;
97                         liquidation.blockNum = block.number;
98                         sellTokens.push(token);
99                     } else {
100                         liquidation.sell += account.holdings[token];
101                     }
102                 }
103                 for (
104                     uint256 buyIdx = 0;
105                     account.borrowTokens.length > buyIdx;
106                     buyIdx++
107                 ) {
108                     address token = account.borrowTokens[buyIdx];
109                     Liquidation storage liquidation = liquidationAmounts[token];
110 
111                     uint256 loanAmount =
112                         Lending(lending()).applyBorrowInterest(
113                             account.borrowed[token],
114                             token,
115                             account.borrowedYieldQuotientsFP[token]
116                         );
117 
118                     Lending(lending()).payOff(token, loanAmount);
119 
120                     if (liquidation.blockNum != block.number) {
121                         liquidation.sell = 0;
122                         liquidation.buy = loanAmount;
123                         liquidation.blockNum = block.number;
124                         buyTokens.push(token);
125                     } else {
126                         liquidation.buy += loanAmount;
127                     }
128                 }
129             }
130 
131             AccountLiqRecord storage liqAttackRecord =
132                 stakeAttackRecords[traderAddress];
133             if (isAuthorized) {
134                 attackReturns += _disburseLiqAttack(liqAttackRecord);
135             }
136         }
137     }
138 
139     function _disburseLiqAttack(AccountLiqRecord storage liqAttackRecord)
140         internal
141         returns (uint256 returnAmount)
142     {
143         if (liqAttackRecord.amount > 0) {
144             // validate attack records, if any
145             uint256 blockDiff =
146                 min(
147                     block.number - liqAttackRecord.blockNum,
148                     liqStakeAttackWindow
149                 );
150 
151             uint256 attackerCut =
152                 (liqAttackRecord.amount * blockDiff) / liqStakeAttackWindow;
153 
154             Fund(fund()).withdraw(
155                 PriceAware.peg,
156                 liqAttackRecord.stakeAttacker,
157                 attackerCut
158             );
159 
160             Admin a = Admin(admin());
161             uint256 penalty =
162                 (a.maintenanceStakePerBlock() * attackerCut) /
163                     avgLiquidationPerCall;
164             a.penalizeMaintenanceStake(
165                 liqAttackRecord.loser,
166                 penalty,
167                 liqAttackRecord.stakeAttacker
168             );
169 
170             // return remainder, after cut was taken to authorized stakekr
171             returnAmount = liqAttackRecord.amount - attackerCut;
172         }
173     }
174 
175     /// Disburse liquidity stake attacks
176     function disburseLiqStakeAttacks(address[] memory liquidatedAccounts)
177         external
178     {
179         for (uint256 i = 0; liquidatedAccounts.length > i; i++) {
180             address liqAccount = liquidatedAccounts[i];
181             AccountLiqRecord storage liqAttackRecord =
182                 stakeAttackRecords[liqAccount];
183             if (
184                 block.number > liqAttackRecord.blockNum + liqStakeAttackWindow
185             ) {
186                 _disburseLiqAttack(liqAttackRecord);
187                 delete stakeAttackRecords[liqAccount];
188             }
189         }
190     }
191 
192     function liquidateFromPeg() internal returns (uint256 pegAmount) {
193         for (uint256 tokenIdx = 0; buyTokens.length > tokenIdx; tokenIdx++) {
194             address buyToken = buyTokens[tokenIdx];
195             Liquidation storage liq = liquidationAmounts[buyToken];
196             if (liq.buy > liq.sell) {
197                 pegAmount += PriceAware.liquidateFromPeg(
198                     buyToken,
199                     liq.buy - liq.sell
200                 );
201                 delete liquidationAmounts[buyToken];
202             }
203         }
204         delete buyTokens;
205     }
206 
207     function liquidateToPeg() internal returns (uint256 pegAmount) {
208         for (
209             uint256 tokenIndex = 0;
210             sellTokens.length > tokenIndex;
211             tokenIndex++
212         ) {
213             address token = sellTokens[tokenIndex];
214             Liquidation storage liq = liquidationAmounts[token];
215             if (liq.sell > liq.buy) {
216                 uint256 sellAmount = liq.sell - liq.buy;
217                 pegAmount += PriceAware.liquidateToPeg(token, sellAmount);
218                 delete liquidationAmounts[token];
219             }
220         }
221         delete sellTokens;
222     }
223 
224     function maintainerIsFailing() internal view returns (bool) {
225         (address currentMaintainer, ) =
226             Admin(admin()).viewCurrentMaintenanceStaker();
227         return
228             maintenanceFailures[currentMaintainer] >
229             failureThreshold * avgLiquidationPerCall;
230     }
231 
232     /// called by maintenance stakers to liquidate accounts below liquidation threshold
233     function liquidate(address[] memory liquidationCandidates)
234         external
235         noIntermediary
236         returns (uint256 maintainerCut)
237     {
238         bool isAuthorized = Admin(admin()).isAuthorizedStaker(msg.sender);
239         bool canTakeNow = isAuthorized || maintainerIsFailing();
240 
241         // calcLiquidationAmounts does a lot of the work here
242         // * aggregates both sell and buy side targets to be liquidated
243         // * returns attacker cuts to them
244         // * aggregates any returned fees from unauthorized (attacking) attempts
245         maintainerCut = calcLiquidationAmounts(
246             liquidationCandidates,
247             isAuthorized
248         );
249 
250         uint256 sale2pegAmount = liquidateToPeg();
251         uint256 peg2targetCost = liquidateFromPeg();
252 
253         // this may be a bit imprecise, since individual shortfalls may be obscured
254         // by overall returns and the maintainer cut is taken out of the net total,
255         // but it gives us the general picture
256         if (
257             (peg2targetCost * (100 + MAINTAINER_CUT_PERCENT)) / 100 >
258             sale2pegAmount
259         ) {
260             emit LiquidationShortfall(
261                 (peg2targetCost * (100 + MAINTAINER_CUT_PERCENT)) /
262                     100 -
263                     sale2pegAmount
264             );
265         }
266 
267         address loser = address(0);
268         if (!canTakeNow) {
269             // whoever is the current responsible maintenance staker
270             // and liable to lose their stake
271             loser = Admin(admin()).getUpdatedCurrentStaker();
272         }
273 
274         // iterate over traders and send back their money
275         // as well as giving attackers their due, in case caller isn't authorized
276         for (
277             uint256 traderIdx = 0;
278             tradersToLiquidate.length > traderIdx;
279             traderIdx++
280         ) {
281             address traderAddress = tradersToLiquidate[traderIdx];
282             CrossMarginAccount storage account = marginAccounts[traderAddress];
283 
284             uint256 holdingsValue = holdingsInPeg(account, true);
285             uint256 borrowValue = loanInPeg(account, true);
286             // 5% of value borrowed
287             uint256 maintainerCut4Account =
288                 (borrowValue * MAINTAINER_CUT_PERCENT) / 100;
289             maintainerCut += maintainerCut4Account;
290 
291             if (!canTakeNow) {
292                 // This could theoretically lead to a previous attackers
293                 // record being overwritten, but only if the trader restarts
294                 // their account and goes back into the red within the short time window
295                 // which would be a costly attack requiring collusion without upside
296                 AccountLiqRecord storage liqAttackRecord =
297                     stakeAttackRecords[traderAddress];
298                 liqAttackRecord.amount = maintainerCut4Account;
299                 liqAttackRecord.stakeAttacker = msg.sender;
300                 liqAttackRecord.blockNum = block.number;
301                 liqAttackRecord.loser = loser;
302             }
303 
304             // send back trader money
305             if (holdingsValue >= maintainerCut4Account + borrowValue) {
306                 // send remaining funds back to trader
307                 Fund(fund()).withdraw(
308                     PriceAware.peg,
309                     traderAddress,
310                     holdingsValue - borrowValue - maintainerCut4Account
311                 );
312             }
313 
314             emit AccountLiquidated(traderAddress);
315             deleteAccount(account);
316         }
317 
318         avgLiquidationPerCall =
319             (avgLiquidationPerCall * 99 + maintainerCut) /
320             100;
321 
322         if (canTakeNow) {
323             Fund(fund()).withdraw(PriceAware.peg, msg.sender, maintainerCut);
324         }
325 
326         address currentMaintainer = Admin(admin()).getUpdatedCurrentStaker();
327         if (isAuthorized) {
328             if (maintenanceFailures[currentMaintainer] > maintainerCut) {
329                 maintenanceFailures[currentMaintainer] -= maintainerCut;
330             } else {
331                 maintenanceFailures[currentMaintainer] = 0;
332             }
333         } else {
334             maintenanceFailures[currentMaintainer] += maintainerCut;
335         }
336     }
337 }
