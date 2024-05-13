1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "./RoleAware.sol";
6 import "./Fund.sol";
7 
8 struct Claim {
9     uint256 startingRewardRateFP;
10     uint256 amount;
11     uint256 intraDayGain;
12     uint256 intraDayLoss;
13 }
14 
15 /// @title Manage distribution of liquidity stake incentives
16 /// Some efforts have been made to reduce gas cost at claim time
17 /// and shift gas burden onto those who would want to withdraw
18 contract IncentiveDistribution is RoleAware, Ownable {
19     // fixed point number factor
20     uint256 internal constant FP32 = 2**32;
21     // the amount of contraction per thousand, per day
22     // of the overal daily incentive distribution
23     // https://en.wikipedia.org/wiki/Per_mil
24     uint256 public constant contractionPerMil = 999;
25     address public immutable MFI;
26 
27     constructor(
28         address _MFI,
29         uint256 startingDailyDistributionWithoutDecimals,
30         address _roles
31     ) RoleAware(_roles) Ownable() {
32         MFI = _MFI;
33         currentDailyDistribution =
34             startingDailyDistributionWithoutDecimals *
35             (1 ether);
36     }
37 
38     // how much is going to be distributed, contracts every day
39     uint256 public currentDailyDistribution;
40 
41     uint256 public trancheShareTotal;
42     uint256[] public allTranches;
43 
44     struct TrancheMeta {
45         // portion of daily distribution per each tranche
46         uint256 rewardShare;
47 
48         uint256 currentDayGains;
49         uint256 currentDayLosses;
50 
51         uint256 tomorrowOngoingTotals;
52         uint256 yesterdayOngoingTotals;
53 
54         // aggregate all the unclaimed intra-days
55         uint256 intraDayGains;
56         uint256 intraDayLosses;
57         uint256 intraDayRewardGains;
58         uint256 intraDayRewardLosses;
59 
60 
61         // how much each claim unit would get if they had staked from the dawn of time
62         // expressed as fixed point number
63         // claim amounts are expressed relative to this ongoing aggregate
64         uint256 aggregateDailyRewardRateFP;
65         uint256 yesterdayRewardRateFP;
66 
67         mapping(address => Claim) claims;
68     }
69 
70     mapping(uint256 => TrancheMeta) public trancheMetadata;
71 
72     // last updated day
73     uint256 public lastUpdatedDay;
74 
75     mapping(address => uint256) public accruedReward;
76 
77     /// Set share of tranche
78     function setTrancheShare(uint256 tranche, uint256 share)
79         external
80         onlyOwner
81     {
82         require(
83             trancheMetadata[tranche].rewardShare > 0,
84             "Tranche is not initialized, please initialize first"
85         );
86         _setTrancheShare(tranche, share);
87     }
88 
89     function _setTrancheShare(uint256 tranche, uint256 share) internal {
90         TrancheMeta storage tm = trancheMetadata[tranche];
91 
92         if (share > tm.rewardShare) {
93             trancheShareTotal += share - tm.rewardShare;
94         } else {
95             trancheShareTotal -= tm.rewardShare - share;
96         }
97         tm.rewardShare = share;
98     }
99 
100     /// Initialize tranche
101     function initTranche(uint256 tranche, uint256 share) external onlyOwner {
102         TrancheMeta storage tm = trancheMetadata[tranche];
103         require(tm.rewardShare == 0, "Tranche already initialized");
104         _setTrancheShare(tranche, share);
105 
106         // simply initialize to 1.0
107         tm.aggregateDailyRewardRateFP = FP32;
108         allTranches.push(tranche);
109     }
110 
111     /// Start / increase amount of claim
112     function addToClaimAmount(
113         uint256 tranche,
114         address recipient,
115         uint256 claimAmount
116     ) external {
117         require(
118             isIncentiveReporter(msg.sender),
119             "Contract not authorized to report incentives"
120         );
121         if (currentDailyDistribution > 0) {
122             TrancheMeta storage tm = trancheMetadata[tranche];
123             Claim storage claim = tm.claims[recipient];
124 
125             uint256 currentDay =
126                 claimAmount * (1 days - (block.timestamp % (1 days)));
127 
128             tm.currentDayGains += currentDay;
129             claim.intraDayGain += currentDay * currentDailyDistribution;
130 
131             tm.tomorrowOngoingTotals += claimAmount * 1 days;
132             updateAccruedReward(tm, recipient, claim);
133 
134             claim.amount += claimAmount * (1 days);
135         }
136     }
137 
138     /// Decrease amount of claim
139     function subtractFromClaimAmount(
140         uint256 tranche,
141         address recipient,
142         uint256 subtractAmount
143     ) external {
144         require(
145             isIncentiveReporter(msg.sender),
146             "Contract not authorized to report incentives"
147         );
148         uint256 currentDay = subtractAmount * (block.timestamp % (1 days));
149 
150         TrancheMeta storage tm = trancheMetadata[tranche];
151         Claim storage claim = tm.claims[recipient];
152 
153         tm.currentDayLosses += currentDay;
154         claim.intraDayLoss += currentDay * currentDailyDistribution;
155 
156         tm.tomorrowOngoingTotals -= subtractAmount * 1 days;
157 
158         updateAccruedReward(tm, recipient, claim);
159         claim.amount -= subtractAmount * (1 days);
160     }
161 
162     function updateAccruedReward(
163         TrancheMeta storage tm,
164         address recipient,
165         Claim storage claim
166                                  ) internal returns (uint256 rewardDelta){
167         if (claim.startingRewardRateFP > 0) {
168             rewardDelta = calcRewardAmount(tm, claim);
169             accruedReward[recipient] += rewardDelta;
170         }
171         // don't reward for current day (approximately)
172         claim.startingRewardRateFP =
173             tm.yesterdayRewardRateFP +
174             tm.aggregateDailyRewardRateFP;
175     }
176 
177     /// @dev additional reward accrued since last update
178     function calcRewardAmount(TrancheMeta storage tm, Claim storage claim)
179         internal
180         view
181         returns (uint256 rewardAmount)
182     {
183         uint256 ours = claim.startingRewardRateFP;
184         uint256 aggregate = tm.aggregateDailyRewardRateFP;
185         if (aggregate > ours) {
186             rewardAmount = (claim.amount * (aggregate - ours)) / FP32;
187         }
188     }
189 
190     function applyIntraDay(
191                            TrancheMeta storage tm,
192         Claim storage claim
193                            ) internal view returns (uint256 gainImpact, uint256 lossImpact) {
194         uint256 gain = claim.intraDayGain;
195         uint256 loss = claim.intraDayLoss;
196 
197         if (gain + loss > 0) {
198             gainImpact =
199                 (gain * tm.intraDayRewardGains) /
200                     (tm.intraDayGains + 1);
201             lossImpact =
202                 (loss * tm.intraDayRewardLosses) /
203                     (tm.intraDayLosses + 1);
204         }
205     }
206 
207     /// Get a view of reward amount
208     function viewRewardAmount(uint256 tranche, address claimant)
209         external
210         view
211         returns (uint256)
212     {
213         TrancheMeta storage tm = trancheMetadata[tranche];
214         Claim storage claim = tm.claims[claimant];
215 
216         uint256 rewardAmount =
217             accruedReward[claimant] + calcRewardAmount(tm, claim);
218         (uint256 gainImpact, uint256 lossImpact) = applyIntraDay(tm, claim);
219 
220         return rewardAmount + gainImpact - lossImpact;
221     }
222 
223     /// Withdraw current reward amount
224     function withdrawReward(uint256[] calldata tranches)
225         external
226         returns (uint256 withdrawAmount)
227     {
228         require(
229             isIncentiveReporter(msg.sender),
230             "Contract not authorized to report incentives"
231         );
232 
233         updateDayTotals();
234 
235         withdrawAmount = accruedReward[msg.sender];
236         for (uint256 i; tranches.length > i; i++) {
237             uint256 tranche = tranches[i];
238 
239             TrancheMeta storage tm = trancheMetadata[tranche];
240             Claim storage claim = tm.claims[msg.sender];
241 
242             withdrawAmount += updateAccruedReward(tm, msg.sender, claim);
243 
244             (uint256 gainImpact, uint256 lossImpact) = applyIntraDay(
245                                                                      tm,
246                 claim
247             );
248 
249             withdrawAmount = withdrawAmount + gainImpact - lossImpact;
250 
251             tm.intraDayGains -= claim.intraDayGain;
252             tm.intraDayLosses -= claim.intraDayLoss;
253             tm.intraDayRewardGains -= gainImpact;
254             tm.intraDayRewardLosses -= lossImpact;
255             
256             claim.intraDayGain = 0;
257         }
258 
259         accruedReward[msg.sender] = 0;
260 
261         Fund(fund()).withdraw(MFI, msg.sender, withdrawAmount);
262     }
263 
264     function updateDayTotals() internal {
265         uint256 nowDay = block.timestamp / (1 days);
266         uint256 dayDiff = nowDay - lastUpdatedDay;
267 
268         // shrink the daily distribution for every day that has passed
269         for (uint256 i = 0; i < dayDiff; i++) {
270             _updateTrancheTotals();
271 
272             currentDailyDistribution =
273                 (currentDailyDistribution * contractionPerMil) /
274                 1000;
275 
276             lastUpdatedDay += 1;
277         }
278     }
279 
280     function _updateTrancheTotals() internal {
281         for (uint256 i; allTranches.length > i; i++) {
282             uint256 tranche = allTranches[i];
283             TrancheMeta storage tm = trancheMetadata[tranche];
284 
285             uint256 todayTotal =
286                 tm.yesterdayOngoingTotals +
287                     tm.currentDayGains -
288                 tm.currentDayLosses;
289 
290             uint256 todayRewardRateFP =
291                 (FP32 * (currentDailyDistribution * tm.rewardShare)) /
292                     trancheShareTotal /
293                     todayTotal;
294 
295             tm.yesterdayRewardRateFP = todayRewardRateFP;
296 
297             tm.aggregateDailyRewardRateFP += todayRewardRateFP;
298 
299             tm.intraDayGains +=
300                 tm.currentDayGains *
301                 currentDailyDistribution;
302 
303             tm.intraDayLosses +=
304                 tm.currentDayLosses *
305                 currentDailyDistribution;
306 
307             tm.intraDayRewardGains +=
308                 (tm.currentDayGains * todayRewardRateFP) /
309                 FP32;
310 
311             tm.intraDayRewardLosses +=
312                 (tm.currentDayLosses * todayRewardRateFP) /
313                 FP32;
314 
315             tm.yesterdayOngoingTotals = tm.tomorrowOngoingTotals;
316             tm.currentDayGains = 0;
317             tm.currentDayLosses = 0;
318         }
319     }
320 }
