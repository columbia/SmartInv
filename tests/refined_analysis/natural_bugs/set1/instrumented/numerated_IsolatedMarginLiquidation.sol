1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "./IsolatedMarginAccounts.sol";
5 
6 /** 
7 @title Handles liquidation of accounts below maintenance threshold
8 @notice Liquidation can be called by the authorized staker, 
9 as determined in the Admin contract.
10 If the authorized staker is delinquent, other participants can jump
11 in and attack, taking their fees and potentially even their stake,
12 depending how delinquent the responsible authorized staker is.
13 */
14 abstract contract IsolatedMarginLiquidation is Ownable, IsolatedMarginAccounts {
15     event LiquidationShortfall(uint256 amount);
16     event AccountLiquidated(address account);
17 
18     /// record kept around until a stake attacker can claim their reward
19     struct AccountLiqRecord {
20         uint256 blockNum;
21         address loser;
22         uint256 amount;
23         address stakeAttacker;
24     }
25 
26     address[] internal tradersToLiquidate;
27 
28     mapping(address => uint256) public maintenanceFailures;
29     mapping(address => AccountLiqRecord) public stakeAttackRecords;
30     uint256 public avgLiquidationPerCall = 10;
31 
32     uint256 public liqStakeAttackWindow = 5;
33     uint256 public MAINTAINER_CUT_PERCENT = 5;
34 
35     uint256 public failureThreshold = 10;
36 
37     /// Set failure threshold
38     function setFailureThreshold(uint256 threshFactor) external onlyOwner {
39         failureThreshold = threshFactor;
40     }
41 
42     /// Set liquidity stake attack window
43     function setLiqStakeAttackWindow(uint256 window) external onlyOwner {
44         liqStakeAttackWindow = window;
45     }
46 
47     /// Set maintainer's percent cut
48     function setMaintainerCutPercent(uint256 cut) external onlyOwner {
49         MAINTAINER_CUT_PERCENT = cut;
50     }
51 
52     /// @dev calcLiquidationAmounts does a number of tasks in this contract
53     /// and some of them are not straightforward.
54     /// First of all it aggregates the total amount to sell
55     /// as well as which traders are ripe for liquidation, in storage (not in memory)
56     /// owing to the fact that arrays can't be pushed to and hash maps don't
57     /// exist in memory.
58     /// Then it also returns any stake attack funds if the stake was unsuccessful
59     /// (i.e. current caller is authorized). Also see context below.
60     function calcLiquidationAmounts(
61         address[] memory liquidationCandidates,
62         bool isAuthorized
63     )
64         internal
65         returns (
66             uint256 attackReturns,
67             uint256 sellAmount,
68             uint256 buyTarget
69         )
70     {
71         tradersToLiquidate = new address[](0);
72 
73         for (
74             uint256 traderIndex = 0;
75             liquidationCandidates.length > traderIndex;
76             traderIndex++
77         ) {
78             address traderAddress = liquidationCandidates[traderIndex];
79             IsolatedMarginAccount storage account =
80                 marginAccounts[traderAddress];
81 
82             if (belowMaintenanceThreshold(account)) {
83                 tradersToLiquidate.push(traderAddress);
84 
85                 sellAmount += account.holding;
86 
87                 updateLoan(account);
88                 buyTarget += account.borrowed;
89 
90                 // TODO pay off / extinguish that loan
91             }
92 
93             AccountLiqRecord storage liqAttackRecord =
94                 stakeAttackRecords[traderAddress];
95             if (isAuthorized) {
96                 attackReturns += _disburseLiqAttack(liqAttackRecord);
97             }
98         }
99     }
100 
101     function _disburseLiqAttack(AccountLiqRecord storage liqAttackRecord)
102         internal
103         returns (uint256 returnAmount)
104     {
105         if (liqAttackRecord.amount > 0) {
106             // validate attack records, if any
107             uint256 blockDiff =
108                 min(
109                     block.number - liqAttackRecord.blockNum,
110                     liqStakeAttackWindow
111                 );
112 
113             uint256 attackerCut =
114                 (liqAttackRecord.amount * blockDiff) / liqStakeAttackWindow;
115 
116             Fund(fund()).withdraw(
117                 borrowToken,
118                 liqAttackRecord.stakeAttacker,
119                 attackerCut
120             );
121 
122             Admin a = Admin(admin());
123             uint256 penalty =
124                 (a.maintenanceStakePerBlock() * attackerCut) /
125                     avgLiquidationPerCall;
126             a.penalizeMaintenanceStake(
127                 liqAttackRecord.loser,
128                 penalty,
129                 liqAttackRecord.stakeAttacker
130             );
131 
132             // return remainder, after cut was taken to authorized stakekr
133             returnAmount = liqAttackRecord.amount - attackerCut;
134         }
135     }
136 
137     /// Disburse liquidity stake attacks
138     function disburseLiqStakeAttacks(address[] memory liquidatedAccounts)
139         external
140     {
141         for (uint256 i = 0; liquidatedAccounts.length > i; i++) {
142             address liqAccount = liquidatedAccounts[i];
143             AccountLiqRecord storage liqAttackRecord =
144                 stakeAttackRecords[liqAccount];
145             if (
146                 block.number > liqAttackRecord.blockNum + liqStakeAttackWindow
147             ) {
148                 _disburseLiqAttack(liqAttackRecord);
149                 delete stakeAttackRecords[liqAccount];
150             }
151         }
152     }
153 
154     function maintainerIsFailing() internal view returns (bool) {
155         (address currentMaintainer, ) =
156             Admin(admin()).viewCurrentMaintenanceStaker();
157         return
158             maintenanceFailures[currentMaintainer] >
159             failureThreshold * avgLiquidationPerCall;
160     }
161 
162     function liquidateToBorrow(uint256 sellAmount) internal returns (uint256) {
163         uint256[] memory amounts =
164             MarginRouter(router()).authorizedSwapExactT4T(
165                 sellAmount,
166                 0,
167                 liquidationPairs,
168                 liquidationTokens
169             );
170 
171         uint256 outAmount = amounts[amounts.length - 1];
172 
173         return outAmount;
174     }
175 
176     /// called by maintenance stakers to liquidate accounts below liquidation threshold
177     function liquidate(address[] memory liquidationCandidates)
178         external
179         noIntermediary
180         returns (uint256 maintainerCut)
181     {
182         bool isAuthorized = Admin(admin()).isAuthorizedStaker(msg.sender);
183         bool canTakeNow = isAuthorized || maintainerIsFailing();
184 
185         // calcLiquidationAmounts does a lot of the work here
186         // * aggregates both sell and buy side targets to be liquidated
187         // * returns attacker cuts to them
188         // * aggregates any returned fees from unauthorized (attacking) attempts
189         uint256 sellAmount;
190         uint256 liquidationTarget;
191         (maintainerCut, sellAmount, liquidationTarget) = calcLiquidationAmounts(
192             liquidationCandidates,
193             isAuthorized
194         );
195 
196         uint256 liquidationReturns = liquidateToBorrow(sellAmount);
197 
198         // this may be a bit imprecise, since individual shortfalls may be obscured
199         // by overall returns and the maintainer cut is taken out of the net total,
200         // but it gives us the general picture
201         liquidationTarget *= (100 + MAINTAINER_CUT_PERCENT) / 100;
202         if (liquidationTarget > liquidationReturns) {
203             emit LiquidationShortfall(liquidationTarget - liquidationReturns);
204 
205             Lending(lending()).haircut(liquidationTarget - liquidationReturns);
206         }
207 
208         address loser = address(0);
209         if (!canTakeNow) {
210             // whoever is the current responsible maintenance staker
211             // and liable to lose their stake
212             loser = Admin(admin()).getUpdatedCurrentStaker();
213         }
214 
215         // iterate over traders and send back their money
216         // as well as giving attackers their due, in case caller isn't authorized
217         for (
218             uint256 traderIdx = 0;
219             tradersToLiquidate.length > traderIdx;
220             traderIdx++
221         ) {
222             address traderAddress = tradersToLiquidate[traderIdx];
223             IsolatedMarginAccount storage account =
224                 marginAccounts[traderAddress];
225 
226             // 5% of value borrowed
227             uint256 maintainerCut4Account =
228                 (account.borrowed * MAINTAINER_CUT_PERCENT) / 100;
229             maintainerCut += maintainerCut4Account;
230 
231             if (!canTakeNow) {
232                 // This could theoretically lead to a previous attackers
233                 // record being overwritten, but only if the trader restarts
234                 // their account and goes back into the red within the short time window
235                 // which would be a costly attack requiring collusion without upside
236                 AccountLiqRecord storage liqAttackRecord =
237                     stakeAttackRecords[traderAddress];
238                 liqAttackRecord.amount = maintainerCut4Account;
239                 liqAttackRecord.stakeAttacker = msg.sender;
240                 liqAttackRecord.blockNum = block.number;
241                 liqAttackRecord.loser = loser;
242             }
243 
244             uint256 holdingsValue =
245                 (account.holding * liquidationReturns) / sellAmount;
246 
247             // send back trader money
248             if (holdingsValue >= maintainerCut4Account + account.borrowed) {
249                 // send remaining funds back to trader
250                 Fund(fund()).withdraw(
251                     borrowToken,
252                     traderAddress,
253                     holdingsValue - account.borrowed - maintainerCut4Account
254                 );
255             }
256 
257             emit AccountLiquidated(traderAddress);
258             delete marginAccounts[traderAddress];
259         }
260 
261         avgLiquidationPerCall =
262             (avgLiquidationPerCall * 99 + maintainerCut) /
263             100;
264 
265         if (canTakeNow) {
266             Fund(fund()).withdraw(borrowToken, msg.sender, maintainerCut);
267         }
268 
269         address currentMaintainer = Admin(admin()).getUpdatedCurrentStaker();
270         if (isAuthorized) {
271             if (maintenanceFailures[currentMaintainer] > maintainerCut) {
272                 maintenanceFailures[currentMaintainer] -= maintainerCut;
273             } else {
274                 maintenanceFailures[currentMaintainer] = 0;
275             }
276         } else {
277             maintenanceFailures[currentMaintainer] += maintainerCut;
278         }
279     }
280 }
