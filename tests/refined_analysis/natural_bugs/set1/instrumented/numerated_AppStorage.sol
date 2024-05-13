1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import "../interfaces/IDiamondCut.sol";
7 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import "@openzeppelin/contracts/utils/Counters.sol";
9 
10 /**
11  * @title Account
12  * @author Publius
13  * @notice Stores Farmer-level Beanstalk state.
14  * @dev {Account.State} is the primary struct that is referenced from {Storage.State}. 
15  * All other structs in {Account} are referenced in {Account.State}. Each unique
16  * Ethereum address is a Farmer.
17  */
18 contract Account {
19     /**
20      * @notice Stores a Farmer's Plots and Pod allowances.
21      * @param plots A Farmer's Plots. Maps from Plot index to Pod amount.
22      * @param podAllowances An allowance mapping for Pods similar to that of the ERC-20 standard. Maps from spender address to allowance amount.
23      */
24     struct Field {
25         mapping(uint256 => uint256) plots;
26         mapping(address => uint256) podAllowances;
27     }
28 
29     /**
30      * @notice Stores a Farmer's Deposits and Seeds per Deposit, and formerly stored Withdrawals.
31      * @param withdrawals DEPRECATED: Silo V1 Withdrawals are no longer referenced.
32      * @param deposits Unripe Bean/LP Deposits (previously Bean/LP Deposits).
33      * @param depositSeeds BDV of Unripe LP Deposits / 4 (previously # of Seeds in corresponding LP Deposit).
34      */
35     struct AssetSilo {
36         mapping(uint32 => uint256) withdrawals;
37         mapping(uint32 => uint256) deposits;
38         mapping(uint32 => uint256) depositSeeds;
39     }
40 
41     /**
42      * @notice Represents a Deposit of a given Token in the Silo at a given Season.
43      * @param amount The amount of Tokens in the Deposit.
44      * @param bdv The Bean-denominated value of the total amount of Tokens in the Deposit.
45      * @dev `amount` and `bdv` are packed as uint128 to save gas.
46      */
47     struct Deposit {
48         uint128 amount; // ───┐ 16
49         uint128 bdv; // ──────┘ 16 (32/32)
50     }
51 
52     /**
53      * @notice Stores a Farmer's Stalk and Seeds balances.
54      * @param stalk Balance of the Farmer's Stalk.
55      * @param seeds DEPRECATED – Balance of the Farmer's Seeds. Seeds are no longer referenced as of Silo V3.
56      */
57     struct Silo {
58         uint256 stalk;
59         uint256 seeds;
60     }
61     
62     /**
63      * @notice Stores a Farmer's germinating stalk.
64      * @param odd - stalk from assets deposited in odd seasons.
65      * @param even - stalk from assets deposited in even seasons.
66      */
67     struct FarmerGerminatingStalk {
68         uint128 odd;
69         uint128 even;
70     }
71     
72     /**
73      * @notice This struct stores the mow status for each Silo-able token, for each farmer. 
74      * This gets updated each time a farmer mows, or adds/removes deposits.
75      * @param lastStem The last cumulative grown stalk per bdv index at which the farmer mowed.
76      * @param bdv The bdv of all of a farmer's deposits of this token type.
77      * 
78      */
79     struct MowStatus {
80         int96 lastStem; // ───┐ 12
81         uint128 bdv; // ──────┘ 16 (28/32)
82     }
83 
84     /**
85      * @notice Stores a Farmer's Season of Plenty (SOP) balances.
86      * @param roots The number of Roots a Farmer had when it started Raining.
87      * @param plentyPerRoot The global Plenty Per Root index at the last time a Farmer updated their Silo.
88      * @param plenty The balance of a Farmer's plenty. Plenty can be claimed directly for 3CRV.
89      */
90     struct SeasonOfPlenty {
91         uint256 roots;
92         uint256 plentyPerRoot;
93         uint256 plenty;
94     }
95     
96     /**
97      * @notice Defines the state object for a Farmer.
98      * @param field A Farmer's Field storage.
99      * @param bean A Farmer's Unripe Bean Deposits only as a result of Replant (previously held the V1 Silo Deposits/Withdrawals for Beans).
100      * @param lp A Farmer's Unripe LP Deposits as a result of Replant of BEAN:ETH Uniswap v2 LP Tokens (previously held the V1 Silo Deposits/Withdrawals for BEAN:ETH Uniswap v2 LP Tokens).
101      * @param s A Farmer's Silo storage.
102      * @param deprecated_votedUntil DEPRECATED – Replant removed on-chain governance including the ability to vote on BIPs.
103      * @param lastUpdate The Season in which the Farmer last updated their Silo.
104      * @param lastSop The last Season that a SOP occured at the time the Farmer last updated their Silo.
105      * @param lastRain The last Season that it started Raining at the time the Farmer last updated their Silo.
106      * @param deprecated_deltaRoots DEPRECATED – BIP-39 introduced germination.
107      * @param deprecated_lastSIs DEPRECATED – In Silo V1.2, the Silo reward mechanism was updated to no longer need to store the number of the Supply Increases at the time the Farmer last updated their Silo.
108      * @param deprecated_proposedUntil DEPRECATED – Replant removed on-chain governance including the ability to propose BIPs.
109      * @param deprecated_sop DEPRECATED – Replant reset the Season of Plenty mechanism
110      * @param roots A Farmer's Root balance.
111      * @param deprecated_wrappedBeans DEPRECATED – Replant generalized Internal Balances. Wrapped Beans are now stored at the AppStorage level.
112      * @param legacyV2Deposits DEPRECATED - SiloV2 was retired in favor of Silo V3. A Farmer's Silo Deposits stored as a map from Token address to Season of Deposit to Deposit.
113      * @param withdrawals Withdraws were removed in zero withdraw upgrade - A Farmer's Withdrawals from the Silo stored as a map from Token address to Season the Withdrawal becomes Claimable to Withdrawn amount of Tokens.
114      * @param sop A Farmer's Season of Plenty storage.
115      * @param depositAllowances A mapping of `spender => Silo token address => amount`.
116      * @param tokenAllowances Internal balance token allowances.
117      * @param depositPermitNonces A Farmer's current deposit permit nonce
118      * @param tokenPermitNonces A Farmer's current token permit nonce
119      * @param legacyV3Deposits DEPRECATED: Silo V3 deposits. Deprecated in favor of SiloV3.1 mapping from depositId to Deposit.
120      * @param mowStatuses A mapping of Silo-able token address to MowStatus.
121      * @param isApprovedForAll A mapping of ERC1155 operator to approved status. ERC1155 compatability.
122      * @param farmerGerminating A Farmer's germinating stalk. Seperated into odd and even stalk.
123      * @param deposits SiloV3.1 deposits. A mapping from depositId to Deposit. SiloV3.1 introduces greater precision for deposits.
124      */
125     struct State {
126         Field field; // A Farmer's Field storage.
127 
128         /*
129          * @dev (Silo V1) A Farmer's Unripe Bean Deposits only as a result of Replant
130          *
131          * Previously held the V1 Silo Deposits/Withdrawals for Beans.
132 
133          * NOTE: While the Silo V1 format is now deprecated, this storage slot is used for gas
134          * efficiency to store Unripe BEAN deposits. See {LibUnripeSilo} for more.
135          */
136         AssetSilo bean; 
137 
138         /*
139          * @dev (Silo V1) Unripe LP Deposits as a result of Replant.
140          * 
141          * Previously held the V1 Silo Deposits/Withdrawals for BEAN:ETH Uniswap v2 LP Tokens.
142          * 
143          * BEAN:3CRV and BEAN:LUSD tokens prior to Replant were stored in the Silo V2
144          * format in the `s.a[account].legacyV2Deposits` mapping.
145          *
146          * NOTE: While the Silo V1 format is now deprecated, unmigrated Silo V1 deposits are still
147          * stored in this storage slot. See {LibUnripeSilo} for more.
148          * 
149          */
150         AssetSilo lp; 
151 
152         /*
153          * @dev Holds Silo specific state for each account.
154          */
155         Silo s;
156         
157         uint32 votedUntil; // DEPRECATED – Replant removed on-chain governance including the ability to vote on BIPs.
158         uint32 lastUpdate; // The Season in which the Farmer last updated their Silo.
159         uint32 lastSop; // The last Season that a SOP occured at the time the Farmer last updated their Silo.
160         uint32 lastRain; // The last Season that it started Raining at the time the Farmer last updated their Silo.
161         uint128 deprecated_deltaRoots; // DEPRECATED - BIP-39 introduced germination. 
162         SeasonOfPlenty deprecated; // DEPRECATED – Replant reset the Season of Plenty mechanism
163         uint256 roots; // A Farmer's Root balance.
164         uint256 deprecated_wrappedBeans; // DEPRECATED – Replant generalized Internal Balances. Wrapped Beans are now stored at the AppStorage level.
165         mapping(address => mapping(uint32 => Deposit)) legacyV2Deposits; // Legacy Silo V2 Deposits stored as a map from Token address to Season of Deposit to Deposit. NOTE: While the Silo V2 format is now deprecated, unmigrated Silo V2 deposits are still stored in this mapping.
166         mapping(address => mapping(uint32 => uint256)) withdrawals; // Zero withdraw eliminates a need for withdraw mapping, but is kept for legacy
167         SeasonOfPlenty sop; // A Farmer's Season Of Plenty storage.
168         mapping(address => mapping(address => uint256)) depositAllowances; // Spender => Silo Token
169         mapping(address => mapping(IERC20 => uint256)) tokenAllowances; // Token allowances
170         uint256 depositPermitNonces; // A Farmer's current deposit permit nonce
171         uint256 tokenPermitNonces; // A Farmer's current token permit nonce
172         mapping(uint256 => Deposit) legacyV3Deposits; // NOTE: Legacy SiloV3 Deposits stored as a map from uint256 to Deposit. This is an concat of the token address and the CGSPBDV for a ERC20 deposit.
173         mapping(address => MowStatus) mowStatuses; // Store a MowStatus for each Whitelisted Silo token
174         mapping(address => bool) isApprovedForAll; // ERC1155 isApprovedForAll mapping 
175         
176         // Germination
177         FarmerGerminatingStalk farmerGerminating; // A Farmer's germinating stalk.
178 
179         // Silo v3.1
180         mapping(uint256 => Deposit) deposits; // Silo v3.1 Deposits stored as a map from uint256 to Deposit. This is an concat of the token address and the stem for a ERC20 deposit.
181     }
182 }
183 
184 /**
185  * @title Storage
186  * @author Publius
187  * @notice Stores system-level Beanstalk state.
188  */
189 contract Storage {
190     /**
191      * @notice DEPRECATED: System-level contract addresses.
192      * @dev After Replant, Beanstalk stores Token addresses as constants to save gas.
193      */
194     struct Contracts {
195         address bean;
196         address pair;
197         address pegPair;
198         address weth;
199     }
200 
201     /**
202      * @notice System-level Field state variables.
203      * @param soil The number of Soil currently available. Adjusted during {Sun.stepSun}.
204      * @param beanSown The number of Bean sown within the current Season. Reset during {Weather.calcCaseId}.
205      * @param pods The pod index; the total number of Pods ever minted.
206      * @param harvested The harvested index; the total number of Pods that have ever been Harvested.
207      * @param harvestable The harvestable index; the total number of Pods that have ever been Harvestable. Included previously Harvested Beans.
208      */
209     struct Field {
210         uint128 soil; // ──────┐ 16
211         uint128 beanSown; // ──┘ 16 (32/32)
212         uint256 pods;
213         uint256 harvested;
214         uint256 harvestable;
215     }
216 
217     /**
218      * @notice DEPRECATED: Contained data about each BIP (Beanstalk Improvement Proposal).
219      * @dev Replant moved governance off-chain. This struct is left for future reference.
220      * 
221      */
222     struct Bip {
223         address proposer; // ───┐ 20
224         uint32 start; //        │ 4 (24)
225         uint32 period; //       │ 4 (28)
226         bool executed; // ──────┘ 1 (29/32)
227         int pauseOrUnpause; 
228         uint128 timestamp;
229         uint256 roots;
230         uint256 endTotalRoots;
231     }
232 
233     /**
234      * @notice DEPRECATED: Contained data for the DiamondCut associated with each BIP.
235      * @dev Replant moved governance off-chain. This struct is left for future reference.
236      * @dev {Storage.DiamondCut} stored DiamondCut-related data for each {Bip}.
237      */
238     struct DiamondCut {
239         IDiamondCut.FacetCut[] diamondCut;
240         address initAddress;
241         bytes initData;
242     }
243 
244     /**
245      * @notice DEPRECATED: Contained all governance-related data, including a list of BIPs, votes for each BIP, and the DiamondCut needed to execute each BIP.
246      * @dev Replant moved governance off-chain. This struct is left for future reference.
247      * @dev {Storage.Governance} stored all BIPs and Farmer voting information.
248      */
249     struct Governance {
250         uint32[] activeBips;
251         uint32 bipIndex;
252         mapping(uint32 => DiamondCut) diamondCuts;
253         mapping(uint32 => mapping(address => bool)) voted;
254         mapping(uint32 => Bip) bips;
255     }
256 
257     /**
258      * @notice System-level Silo state; contains deposit and withdrawal data for a particular whitelisted Token.
259      * @param deposited The total amount of this Token currently Deposited in the Silo.
260      * @param depositedBdv The total bdv of this Token currently Deposited in the Silo.
261      * @param withdrawn The total amount of this Token currently Withdrawn From the Silo.
262      * @dev {Storage.State} contains a mapping from Token address => AssetSilo.
263      * Currently, the bdv of deposits are asynchronous, and require an on-chain transaction to update.
264      * Thus, the total bdv of deposits cannot be calculated, and must be stored and updated upon a bdv change.
265      * 
266      * 
267      * Note that "Withdrawn" refers to the amount of Tokens that have been Withdrawn
268      * but not yet Claimed. This will be removed in a future BIP.
269      */
270     struct AssetSilo {
271         uint128 deposited;
272         uint128 depositedBdv;
273         uint256 withdrawn;
274     }
275 
276     /**
277      * @notice Whitelist Status a token that has been Whitelisted before.
278      * @param token the address of the token.
279      * @param a whether the address is whitelisted.
280      * @param isWhitelistedLp whether the address is a whitelisted LP token.
281      * @param isWhitelistedWell whether the address is a whitelisted Well token.
282      */
283 
284     struct WhitelistStatus {
285         address token;
286         bool isWhitelisted;
287         bool isWhitelistedLp;
288         bool isWhitelistedWell;
289     }
290 
291     /**
292      * @notice System-level Silo state variables.
293      * @param stalk The total amount of active Stalk (including Earned Stalk, excluding Grown Stalk).
294      * @param deprecated_seeds DEPRECATED: The total amount of active Seeds (excluding Earned Seeds).
295      * @dev seeds are no longer used internally. Balance is wiped to 0 from the mayflower update. see {mowAndMigrate}.
296      * @param roots The total amount of Roots.
297      */
298     struct Silo {
299         uint256 stalk;
300         uint256 deprecated_seeds; 
301         uint256 roots;
302     }
303 
304     /**
305      * @notice System-level Curve Metapool Oracle state variables.
306      * @param initialized True if the Oracle has been initialzed. It needs to be initialized on Deployment and re-initialized each Unpause.
307      * @param startSeason The Season the Oracle started minting. Used to ramp up delta b when oracle is first added.
308      * @param balances The cumulative reserve balances of the pool at the start of the Season (used for computing time weighted average delta b).
309      * @param timestamp DEPRECATED: The timestamp of the start of the current Season. `LibCurveMinting` now uses `s.season.timestamp` instead of storing its own for gas efficiency purposes.
310      * @dev Currently refers to the time weighted average deltaB calculated from the BEAN:3CRV pool.
311      */
312     struct CurveMetapoolOracle {
313         bool initialized; // ────┐ 1
314         uint32 startSeason; // ──┘ 4 (5/32)
315         uint256[2] balances;
316         uint256 timestamp;
317     }
318 
319     /**
320      * @notice System-level Rain balances. Rain occurs when P > 1 and the Pod Rate Excessively Low.
321      * @dev The `raining` storage variable is stored in the Season section for a gas efficient read operation.
322      * @param deprecated Previously held Rain start and Rain status variables. Now moved to Season struct for gas efficiency.
323      * @param pods The number of Pods when it last started Raining.
324      * @param roots The number of Roots when it last started Raining.
325      */
326     struct Rain {
327         uint256 deprecated;
328         uint256 pods;
329         uint256 roots;
330     }
331 
332     /**
333      * @notice System-level Season state variables.
334      * @param current The current Season in Beanstalk.
335      * @param lastSop The Season in which the most recent consecutive series of Seasons of Plenty started.
336      * @param withdrawSeasons The number of Seasons required to Withdraw a Deposit.
337      * @param lastSopSeason The Season in which the most recent consecutive series of Seasons of Plenty ended.
338      * @param rainStart Stores the most recent Season in which Rain started.
339      * @param raining True if it is Raining (P > 1, Pod Rate Excessively Low).
340      * @param fertilizing True if Beanstalk has Fertilizer left to be paid off.
341      * @param sunriseBlock The block of the start of the current Season.
342      * @param abovePeg Boolean indicating whether the previous Season was above or below peg.
343      * @param stemStartSeason // season in which the stem storage method was introduced.
344      * @param stemScaleSeason // season in which the stem v1.1 was introduced, where stems are not truncated anymore.
345      * @param beanEthStartMintingSeason // Season to start minting in Bean:Eth pool after migrating liquidity out of the pool to protect against Pump failure.
346      * This allows for greater precision of stems, and requires a soft migration (see {LibTokenSilo.removeDepositFromAccount})
347      * @param start The timestamp of the Beanstalk deployment rounded down to the nearest hour.
348      * @param period The length of each season in Beanstalk in seconds.
349      * @param timestamp The timestamp of the start of the current Season.
350      */
351     struct Season {
352         uint32 current; // ─────────────────┐ 4  
353         uint32 lastSop; //                  │ 4 (8)
354         uint8 withdrawSeasons; //           │ 1 (9)
355         uint32 lastSopSeason; //            │ 4 (13)
356         uint32 rainStart; //                │ 4 (17)
357         bool raining; //                    │ 1 (18)
358         bool fertilizing; //                │ 1 (19)
359         uint32 sunriseBlock; //             │ 4 (23)
360         bool abovePeg; //                   | 1 (24)
361         uint16 stemStartSeason; //          | 2 (26)
362         uint16 stemScaleSeason; //          | 2 (28/32)
363         uint32 beanEthStartMintingSeason; //┘ 4 (32/32) NOTE: Reset and delete after Bean:wStEth migration has been completed.
364         uint256 start;
365         uint256 period;
366         uint256 timestamp;
367     }
368 
369     /**
370      * @notice System-level Weather state variables.
371      * @param deprecated 2 slots that were previously used.
372      * @param lastDSoil Delta Soil; the number of Soil purchased last Season.
373      * @param lastSowTime The number of seconds it for Soil to sell out last Season.
374      * @param thisSowTime The number of seconds it for Soil to sell out this Season.
375      * @param t The Temperature; the maximum interest rate during the current Season for sowing Beans in Soil. Adjusted each Season.
376      */
377     struct Weather {
378         uint256[2] deprecated;
379         uint128 lastDSoil;  // ───┐ 16 (16)
380         uint32 lastSowTime; //    │ 4  (20)
381         uint32 thisSowTime; //    │ 4  (24)
382         uint32 t; // ─────────────┘ 4  (28/32)
383     }
384 
385     /**
386      * @notice Describes a Fundraiser.
387      * @param payee The address to be paid after the Fundraiser has been fully funded.
388      * @param token The token address that used to raise funds for the Fundraiser.
389      * @param total The total number of Tokens that need to be raised to complete the Fundraiser.
390      * @param remaining The remaining number of Tokens that need to to complete the Fundraiser.
391      * @param start The timestamp at which the Fundraiser started (Fundraisers cannot be started and funded in the same block).
392      */
393     struct Fundraiser {
394         address payee;
395         address token;
396         uint256 total;
397         uint256 remaining;
398         uint256 start;
399     }
400 
401     /**
402      * @notice Describes the settings for each Token that is Whitelisted in the Silo.
403      * @param selector The encoded BDV function selector for the token that pertains to 
404      * an external view Beanstalk function with the following signature:
405      * ```
406      * function tokenToBdv(uint256 amount) external view returns (uint256);
407      * ```
408      * It is called by `LibTokenSilo` through the use of `delegatecall`
409      * to calculate a token's BDV at the time of Deposit.
410      * @param stalkEarnedPerSeason represents how much Stalk one BDV of the underlying deposited token
411      * grows each season. In the past, this was represented by seeds. This is stored as 1e6, plus stalk is stored
412      * as 1e10, so 1 legacy seed would be 1e6 * 1e10.
413      * @param stalkIssuedPerBdv The Stalk Per BDV that the Silo grants in exchange for Depositing this Token.
414      * previously called stalk.
415      * @param milestoneSeason The last season in which the stalkEarnedPerSeason for this token was updated.
416      * @param milestoneStem The cumulative amount of grown stalk per BDV for this token at the last stalkEarnedPerSeason update.
417      * @param encodeType determine the encoding type of the selector.
418      * a encodeType of 0x00 means the selector takes an input amount.
419      * 0x01 means the selector takes an input amount and a token.
420      * @param gpSelector The encoded gaugePoint function selector for the token that pertains to 
421      * an external view Beanstalk function with the following signature:
422      * ```
423      * function gaugePoints(
424      *  uint256 currentGaugePoints,
425      *  uint256 optimalPercentDepositedBdv,
426      *  uint256 percentOfDepositedBdv
427      *  ) external view returns (uint256);
428      * ```
429      * @param lwSelector The encoded liquidityWeight function selector for the token that pertains to 
430      * an external view Beanstalk function with the following signature `function liquidityWeight()`
431      * @param optimalPercentDepositedBdv The target percentage of the total LP deposited BDV for this token. 6 decimal precision.
432      * @param gaugePoints the amount of Gauge points this LP token has in the LP Gauge. Only used for LP whitelisted assets.
433      * GaugePoints has 18 decimal point precision (1 Gauge point = 1e18).
434 
435      * @dev A Token is considered Whitelisted if there exists a non-zero {SiloSettings} selector.
436      */
437     struct SiloSettings {
438         bytes4 selector; // ────────────────────┐ 4
439         uint32 stalkEarnedPerSeason; //         │ 4  (8)
440         uint32 stalkIssuedPerBdv; //            │ 4  (12)
441         uint32 milestoneSeason; //              │ 4  (16)
442         int96 milestoneStem; //                 │ 12 (28)
443         bytes1 encodeType; //                   │ 1  (29)
444         int24 deltaStalkEarnedPerSeason; // ────┘ 3  (32)
445         bytes4 gpSelector; //    ────────────────┐ 4  
446         bytes4 lwSelector; //                    │ 4  (8)
447         uint128 gaugePoints; //                  │ 16 (24)
448         uint64 optimalPercentDepositedBdv; //  ──┘ 8  (32)
449     }
450 
451     /**
452      * @notice Describes the settings for each Unripe Token in Beanstalk.
453      * @param underlyingToken The address of the Token underlying the Unripe Token.
454      * @param balanceOfUnderlying The number of Tokens underlying the Unripe Tokens (redemption pool).
455      * @param merkleRoot The Merkle Root used to validate a claim of Unripe Tokens.
456      * @dev An Unripe Token is a vesting Token that is redeemable for a a pro rata share
457      * of the `balanceOfUnderlying`, subject to a penalty based on the percent of
458      * Unfertilized Beans paid back.
459      * 
460      * There were two Unripe Tokens added at Replant: 
461      *  - Unripe Bean, with its `underlyingToken` as BEAN;
462      *  - Unripe LP, with its `underlyingToken` as BEAN:3CRV LP.
463      * 
464      * Unripe Tokens are initially distributed through the use of a `merkleRoot`.
465      * 
466      * The existence of a non-zero {UnripeSettings} implies that a Token is an Unripe Token.
467      */
468     struct UnripeSettings {
469         address underlyingToken;
470         uint256 balanceOfUnderlying;
471         bytes32 merkleRoot;
472     }
473 
474     /**
475      * @notice System level variables used in the seed Gauge System.
476      * @param averageGrownStalkPerBdvPerSeason The average Grown Stalk Per BDV 
477      * that beanstalk issues each season.
478      * @param beanToMaxLpGpPerBdvRatio a scalar of the gauge points(GP) per bdv 
479      * issued to the largest LP share and Bean. 6 decimal precision.
480      * @dev a beanToMaxLpGpPerBdvRatio of 0 means LP should be incentivized the most,
481      * and that beans will have the minimum seeds ratio. see {LibGauge.getBeanToMaxLpGpPerBdvRatioScaled}
482      */
483     struct SeedGauge {
484         uint128 averageGrownStalkPerBdvPerSeason;
485         uint128 beanToMaxLpGpPerBdvRatio;
486     }
487 
488     /**
489      * @notice Stores the twaReserves for each well during the sunrise function.
490      */
491     struct TwaReserves {
492         uint128 reserve0;
493         uint128 reserve1;
494     }
495 
496     /**
497      * @notice Stores the total germination amounts for each whitelisted token.
498      */
499     struct Deposited {
500         uint128 amount;
501         uint128 bdv;
502     }
503 
504     /** 
505      * @notice Stores the system level germination data.
506      */
507     struct TotalGerminating {
508         mapping(address => Deposited) deposited;
509     }
510 
511     struct Sr {
512 	    uint128 stalk;
513 	    uint128 roots;
514     }
515 }
516 
517 /**
518  * @title AppStorage
519  * @author Publius
520  * @notice Defines the state object for Beanstalk.
521  * @param deprecated_index DEPRECATED: Was the index of the BEAN token in the BEAN:ETH Uniswap V2 pool.
522  * @param deprecated_cases DEPRECATED: The 24 Weather cases used in cases V1 (array has 32 items, but caseId = 3 (mod 4) are not cases)
523  * @param paused True if Beanstalk is Paused.
524  * @param pausedAt The timestamp at which Beanstalk was last paused.
525  * @param season Storage.Season
526  * @param c Storage.Contracts
527  * @param f Storage.Field
528  * @param g Storage.Governance
529  * @param co Storage.CurveMetapoolOracle
530  * @param r Storage.Rain
531  * @param s Storage.Silo
532  * @param reentrantStatus An intra-transaction state variable to protect against reentrance.
533  * @param w Storage.Weather
534  * @param earnedBeans The number of Beans distributed to the Silo that have not yet been Deposited as a result of the Earn function being called.
535  * @param deprecated DEPRECATED - 14 slots that used to store state variables which have been deprecated through various updates. Storage slots can be left alone or reused.
536  * @param a mapping (address => Account.State)
537  * @param deprecated_bip0Start DEPRECATED - bip0Start was used to aid in a migration that occured alongside BIP-0.
538  * @param deprecated_hotFix3Start DEPRECATED - hotFix3Start was used to aid in a migration that occured alongside HOTFIX-3.
539  * @param fundraisers A mapping from Fundraiser ID to Storage.Fundraiser.
540  * @param fundraiserIndex The number of Fundraisers that have occured.
541  * @param deprecated_isBudget DEPRECATED - Budget Facet was removed in BIP-14. 
542  * @param podListings A mapping from Plot Index to the hash of the Pod Listing.
543  * @param podOrders A mapping from the hash of a Pod Order to the amount of Pods that the Pod Order is still willing to buy.
544  * @param siloBalances A mapping from Token address to Silo Balance storage (amount deposited and withdrawn).
545  * @param ss A mapping from Token address to Silo Settings for each Whitelisted Token. If a non-zero storage exists, a Token is whitelisted.
546  * @param deprecated2 DEPRECATED - 2 slots that used to store state variables which have been deprecated through various updates. Storage slots can be left alone or reused.
547  * @param deprecated_newEarnedStalk the amount of earned stalk issued this season. Since 1 stalk = 1 bean, it represents the earned beans as well.
548  * @param sops A mapping from Season to Plenty Per Root (PPR) in that Season. Plenty Per Root is 0 if a Season of Plenty did not occur.
549  * @param internalTokenBalance A mapping from Farmer address to Token address to Internal Balance. It stores the amount of the Token that the Farmer has stored as an Internal Balance in Beanstalk.
550  * @param unripeClaimed True if a Farmer has Claimed an Unripe Token. A mapping from Farmer to Unripe Token to its Claim status.
551  * @param u Unripe Settings for a given Token address. The existence of a non-zero Unripe Settings implies that the token is an Unripe Token. The mapping is from Token address to Unripe Settings.
552  * @param fertilizer A mapping from Fertilizer Id to the supply of Fertilizer for each Id.
553  * @param nextFid A linked list of Fertilizer Ids ordered by Id number. Fertilizer Id is the Beans Per Fertilzer level at which the Fertilizer no longer receives Beans. Sort in order by which Fertilizer Id expires next.
554  * @param activeFertilizer The number of active Fertilizer.
555  * @param fertilizedIndex The total number of Fertilizer Beans.
556  * @param unfertilizedIndex The total number of Unfertilized Beans ever.
557  * @param fFirst The lowest active Fertilizer Id (start of linked list that is stored by nextFid). 
558  * @param fLast The highest active Fertilizer Id (end of linked list that is stored by nextFid). 
559  * @param bpf The cumulative Beans Per Fertilizer (bfp) minted over all Season.
560  * @param deprecated_vestingPeriodRoots deprecated - removed in BIP-39 in favor of germination.
561  * @param recapitalized The number of USDC that has been recapitalized in the Barn Raise.
562  * @param isFarm Stores whether the function is wrapped in the `farm` function (1 if not, 2 if it is).
563  * @param ownerCandidate Stores a candidate address to transfer ownership to. The owner must claim the ownership transfer.
564  * @param wellOracleSnapshots A mapping from Well Oracle address to the Well Oracle Snapshot.
565  * @param deprecated_beanEthPrice DEPRECATED - The price of bean:eth, originally used to calculate the incentive reward. Deprecated in favor of calculating using twaReserves.
566  * @param twaReserves A mapping from well to its twaReserves. Stores twaReserves during the sunrise function. Returns 1 otherwise for each asset. Currently supports 2 token wells.
567  * @param migratedBdvs Stores the total migrated BDV since the implementation of the migrated BDV counter. See {LibLegacyTokenSilo.incrementMigratedBdv} for more info.
568  * @param usdEthPrice  Stores the usdEthPrice during the sunrise() function. Returns 1 otherwise.
569  * @param seedGauge Stores the seedGauge.
570  * @param casesV2 Stores the 144 Weather and seedGauge cases.
571  * @param oddGerminating Stores germinating data during odd seasons.
572  * @param evenGerminating Stores germinating data during even seasons.
573  * @param whitelistedStatues Stores a list of Whitelist Statues for all tokens that have been Whitelisted and have not had their Whitelist Status manually removed.
574  * @param sopWell Stores the well that will be used upon a SOP. Unintialized until a SOP occurs, and is kept constant afterwards.
575  * @param barnRaiseWell Stores the well that the Barn Raise adds liquidity to.
576  */
577 struct AppStorage {
578     uint8 deprecated_index;
579     int8[32] deprecated_cases; 
580     bool paused; // ────────┐ 1 
581     uint128 pausedAt; // ───┘ 16 (17/32)
582     Storage.Season season;
583     Storage.Contracts c;
584     Storage.Field f;
585     Storage.Governance g;
586     Storage.CurveMetapoolOracle co;
587     Storage.Rain r;
588     Storage.Silo s;
589     uint256 reentrantStatus;
590     Storage.Weather w;
591 
592     uint256 earnedBeans;
593     uint256[14] deprecated;
594     mapping (address => Account.State) a;
595     uint32 deprecated_bip0Start; // ─────┐ 4
596     uint32 deprecated_hotFix3Start; // ──┘ 4 (8/32)
597     mapping (uint32 => Storage.Fundraiser) fundraisers;
598     uint32 fundraiserIndex; // 4 (4/32)
599     mapping (address => bool) deprecated_isBudget;
600     mapping(uint256 => bytes32) podListings;
601     mapping(bytes32 => uint256) podOrders;
602     mapping(address => Storage.AssetSilo) siloBalances;
603     mapping(address => Storage.SiloSettings) ss;
604     uint256[2] deprecated2;
605     uint128 deprecated_newEarnedStalk; // ──────┐ 16
606     uint128 deprecated_vestingPeriodRoots; // ──┘ 16 (32/32)
607     mapping (uint32 => uint256) sops;
608 
609     // Internal Balances
610     mapping(address => mapping(IERC20 => uint256)) internalTokenBalance;
611 
612     // Unripe
613     mapping(address => mapping(address => bool)) unripeClaimed;
614     mapping(address => Storage.UnripeSettings) u;
615 
616     // Fertilizer
617     mapping(uint128 => uint256) fertilizer;
618     mapping(uint128 => uint128) nextFid;
619     uint256 activeFertilizer;
620     uint256 fertilizedIndex;
621     uint256 unfertilizedIndex;
622     uint128 fFirst;
623     uint128 fLast;
624     uint128 bpf;
625     uint256 recapitalized;
626 
627     // Farm
628     uint256 isFarm;
629 
630     // Ownership
631     address ownerCandidate;
632 
633     // Well
634     mapping(address => bytes) wellOracleSnapshots;
635 
636     uint256 deprecated_beanEthPrice;
637 
638     // Silo V3 BDV Migration
639     mapping(address => uint256) migratedBdvs;
640 
641     // Well/Curve + USD Price Oracle
642     mapping(address => Storage.TwaReserves) twaReserves;
643     mapping(address => uint256) usdTokenPrice;
644 
645     // Seed Gauge
646     Storage.SeedGauge seedGauge;
647     bytes32[144] casesV2;
648 
649     // Germination
650     Storage.TotalGerminating oddGerminating;
651     Storage.TotalGerminating evenGerminating;
652 
653     // mapping from season => unclaimed germinating stalk and roots 
654     mapping(uint32 => Storage.Sr) unclaimedGerminating;
655 
656     Storage.WhitelistStatus[] whitelistStatuses;
657 
658     address sopWell;
659 }