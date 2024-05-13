1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "./Fund.sol";
5 import "./HourlyBondSubscriptionLending.sol";
6 import "./BondLending.sol";
7 import "./IncentivizedHolder.sol";
8 
9 // TODO activate bonds for lending
10 
11 // TODO disburse token if isolated bond issuer
12 // and if isolated issuer, allow for haircuts
13 
14 /// @title Manage lending for a variety of bond issuers
15 contract Lending is
16     RoleAware,
17     BaseLending,
18     HourlyBondSubscriptionLending,
19     BondLending,
20     IncentivizedHolder
21 {
22     /// @dev IDs for all bonds held by an address
23     mapping(address => uint256[]) public bondIds;
24 
25     /// mapping issuers to tokens
26     /// (in crossmargin, the issuers are tokens  themselves)
27     mapping(address => address) public issuerTokens;
28 
29     /// In case of shortfall, adjust debt
30     mapping(address => uint256) public haircuts;
31 
32     /// map of available issuers
33     mapping(address => bool) public activeIssuers;
34 
35     constructor(address _roles) RoleAware(_roles) Ownable() {
36         uint256 APR = 899;
37         maxHourlyYieldFP = (FP32 * APR) / 100 / (24 * 365);
38 
39         uint256 aprChangePerMil = 3;
40         yieldChangePerSecondFP = (FP32 * aprChangePerMil) / 1000;
41     }
42 
43     /// Make a issuer available for protocol
44     function activateIssuer(address issuer) external {
45         activateIssuer(issuer, issuer);
46     }
47 
48     /// Make issuer != token available for protocol (isol. margin)
49     function activateIssuer(address issuer, address token) public {
50         require(
51             isTokenActivator(msg.sender),
52             "Address not authorized to activate issuers"
53         );
54         activeIssuers[issuer] = true;
55         issuerTokens[issuer] = token;
56     }
57 
58     /// Remove a issuer from trading availability
59     function deactivateIssuer(address issuer) external {
60         require(
61             isTokenActivator(msg.sender),
62             "Address not authorized to activate issuers"
63         );
64         activeIssuers[issuer] = false;
65     }
66 
67     /// Set lending cap
68     function setLendingCap(address issuer, uint256 cap) external {
69         require(
70             isTokenActivator(msg.sender),
71             "not authorized to set lending cap"
72         );
73         lendingMeta[issuer].lendingCap = cap;
74     }
75 
76     /// Set lending buffer
77     function setLendingBuffer(address issuer, uint256 buffer) external {
78         require(
79             isTokenActivator(msg.sender),
80             "not autorized to set lending buffer"
81         );
82         lendingMeta[issuer].lendingBuffer = buffer;
83     }
84 
85     /// Set hourly yield APR for issuer
86     function setHourlyYieldAPR(address issuer, uint256 aprPercent) external {
87         require(
88             isTokenActivator(msg.sender),
89             "not authorized to set hourly yield"
90         );
91 
92         HourlyBondMetadata storage bondMeta = hourlyBondMetadata[issuer];
93 
94         if (bondMeta.yieldAccumulator.accumulatorFP == 0) {
95             bondMeta.yieldAccumulator = YieldAccumulator({
96                 accumulatorFP: FP32,
97                 lastUpdated: block.timestamp,
98                 hourlyYieldFP: (FP32 * (100 + aprPercent)) / 100 / (24 * 365)
99             });
100             bondMeta.buyingSpeed = 1;
101             bondMeta.withdrawingSpeed = 1;
102             bondMeta.lastBought = block.timestamp;
103             bondMeta.lastWithdrawn = block.timestamp;
104         } else {
105             YieldAccumulator storage yA =
106                 getUpdatedHourlyYield(issuer, bondMeta);
107             yA.hourlyYieldFP = (FP32 * (100 + aprPercent)) / 100 / (24 * 365);
108         }
109     }
110 
111     /// Set runtime weights in floating point
112     function setRuntimeWeights(address issuer, uint256[] memory weights)
113         external
114     {
115         require(
116             isTokenActivator(msg.sender),
117             "not autorized to set runtime weights"
118         );
119 
120         BondBucketMetadata[] storage bondMetas = bondBucketMetadata[issuer];
121 
122         if (bondMetas.length == 0) {
123             // we are initializing
124 
125             uint256 hourlyYieldFP = (110 * FP32) / 100 / (24 * 365);
126             uint256 bucketSize = diffMaxMinRuntime / weights.length;
127 
128             for (uint256 i; weights.length > i; i++) {
129                 uint256 runtime = minRuntime + bucketSize * i;
130                 bondMetas.push(
131                     BondBucketMetadata({
132                         runtimeYieldFP: (hourlyYieldFP * runtime) / (1 hours),
133                         lastBought: block.timestamp,
134                         lastWithdrawn: block.timestamp,
135                         yieldLastUpdated: block.timestamp,
136                         buyingSpeed: 1,
137                         withdrawingSpeed: 1,
138                         runtimeWeight: weights[i],
139                         totalLending: 0
140                     })
141                 );
142             }
143         } else {
144             require(
145                 weights.length == bondMetas.length,
146                 "Weights don't match buckets"
147             );
148             for (uint256 i; weights.length > i; i++) {
149                 bondMetas[i].runtimeWeight = weights[i];
150             }
151         }
152     }
153 
154     /// @dev how much interest has accrued to a borrowed balance over time
155     function applyBorrowInterest(
156         uint256 balance,
157         address issuer,
158         uint256 yieldQuotientFP
159     ) external returns (uint256 balanceWithInterest) {
160         require(isBorrower(msg.sender), "Not an approved borrower");
161 
162         YieldAccumulator storage yA = borrowYieldAccumulators[issuer];
163         balanceWithInterest = applyInterest(
164             balance,
165             yA.accumulatorFP,
166             yieldQuotientFP
167         );
168 
169         uint256 deltaAmount = balanceWithInterest - balance;
170         LendingMetadata storage meta = lendingMeta[issuer];
171         meta.totalBorrowed += deltaAmount;
172     }
173 
174     /// @dev view function to get current borrowing interest
175     function viewBorrowInterest(
176         uint256 balance,
177         address issuer,
178         uint256 yieldQuotientFP
179     ) external view returns (uint256) {
180         uint256 accumulatorFP =
181             viewCumulativeYieldFP(
182                 borrowYieldAccumulators[issuer],
183                 block.timestamp
184             );
185         return applyInterest(balance, accumulatorFP, yieldQuotientFP);
186     }
187 
188     /// @dev gets called by router to register if a trader borrows issuers
189     function registerBorrow(address issuer, uint256 amount) external {
190         require(isBorrower(msg.sender), "Not an approved borrower");
191         require(activeIssuers[issuer], "Not an approved issuer");
192 
193         LendingMetadata storage meta = lendingMeta[issuer];
194         meta.totalBorrowed += amount;
195         require(
196             meta.totalLending >= meta.totalBorrowed,
197             "Insufficient capital to lend, try again later!"
198         );
199     }
200 
201     /// @dev gets called by router if loan is extinguished
202     function payOff(address issuer, uint256 amount) external {
203         require(isBorrower(msg.sender), "Not an approved borrower");
204         lendingMeta[issuer].totalBorrowed -= amount;
205     }
206 
207     /// @dev get the borrow yield
208     function viewBorrowingYieldFP(address issuer)
209         external
210         view
211         returns (uint256)
212     {
213         return
214             viewCumulativeYieldFP(
215                 borrowYieldAccumulators[issuer],
216                 block.timestamp
217             );
218     }
219 
220     /// @dev In a liquidity crunch make a fallback bond until liquidity is good again
221     function _makeFallbackBond(
222         address issuer,
223         address holder,
224         uint256 amount
225     ) internal override {
226         _makeHourlyBond(issuer, holder, amount);
227     }
228 
229     /// @dev withdraw an hour bond
230     function withdrawHourlyBond(address issuer, uint256 amount) external {
231         HourlyBond storage bond = hourlyBondAccounts[issuer][msg.sender];
232         // apply all interest
233         updateHourlyBondAmount(issuer, bond);
234         super._withdrawHourlyBond(issuer, bond, amount);
235 
236         if (bond.amount == 0) {
237             delete hourlyBondAccounts[issuer][msg.sender];
238         }
239 
240         disburse(issuer, msg.sender, amount);
241 
242         withdrawClaim(msg.sender, issuer, amount);
243     }
244 
245     /// Shut down hourly bond account for `issuer`
246     function closeHourlyBondAccount(address issuer) external {
247         HourlyBond storage bond = hourlyBondAccounts[issuer][msg.sender];
248         // apply all interest
249         updateHourlyBondAmount(issuer, bond);
250 
251         uint256 amount = bond.amount;
252         super._withdrawHourlyBond(issuer, bond, amount);
253 
254         disburse(issuer, msg.sender, amount);
255 
256         delete hourlyBondAccounts[issuer][msg.sender];
257 
258         withdrawClaim(msg.sender, issuer, amount);
259     }
260 
261     /// @dev buy hourly bond subscription
262     function buyHourlyBondSubscription(address issuer, uint256 amount)
263         external
264     {
265         require(activeIssuers[issuer], "Not an approved issuer");
266 
267         LendingMetadata storage meta = lendingMeta[issuer];
268         if (lendingTarget(meta) >= meta.totalLending + amount) {
269             collectToken(issuer, msg.sender, amount);
270 
271             super._makeHourlyBond(issuer, msg.sender, amount);
272 
273             stakeClaim(msg.sender, issuer, amount);
274         }
275     }
276 
277     /// @dev buy fixed term bond that does not renew
278     function buyBond(
279         address issuer,
280         uint256 runtime,
281         uint256 amount,
282         uint256 minReturn
283     ) external returns (uint256 bondIndex) {
284         require(activeIssuers[issuer], "Not an approved issuer");
285 
286         LendingMetadata storage meta = lendingMeta[issuer];
287         if (
288             lendingTarget(meta) >= meta.totalLending + amount &&
289             maxRuntime >= runtime &&
290             runtime >= minRuntime
291         ) {
292             bondIndex = super._makeBond(
293                 msg.sender,
294                 issuer,
295                 runtime,
296                 amount,
297                 minReturn
298             );
299             if (bondIndex > 0) {
300                 Fund(fund()).depositFor(msg.sender, issuer, amount);
301                 bondIds[msg.sender].push(bondIndex);
302 
303                 collectToken(issuer, msg.sender, amount);
304                 stakeClaim(msg.sender, issuer, amount);
305             }
306         }
307     }
308 
309     /// @dev send back funds of bond after maturity
310     function withdrawBond(uint256 bondId) external {
311         Bond storage bond = bonds[bondId];
312         require(msg.sender == bond.holder, "Not holder of bond");
313         require(
314             block.timestamp > bond.maturityTimestamp,
315             "bond is still immature"
316         );
317         // in case of a shortfall, governance can step in to provide
318         // additonal compensation beyond the usual incentive which
319         // gets withdrawn here
320         withdrawClaim(msg.sender, bond.issuer, bond.originalPrice);
321 
322         uint256 withdrawAmount = super._withdrawBond(bondId, bond);
323         disburse(bond.issuer, msg.sender, withdrawAmount);
324     }
325 
326     function initBorrowYieldAccumulator(address issuer) external {
327         require(
328             isTokenActivator(msg.sender),
329             "not autorized to init yield accumulator"
330         );
331         require(
332             borrowYieldAccumulators[issuer].accumulatorFP == 0,
333             "trying to re-initialize yield accumulator"
334         );
335 
336         borrowYieldAccumulators[issuer].accumulatorFP = FP32;
337     }
338 
339     function setBorrowingFactorPercent(uint256 borrowingFactor)
340         external
341         onlyOwner
342     {
343         borrowingFactorPercent = borrowingFactor;
344     }
345 
346     function issuanceBalance(address issuer)
347         internal
348         view
349         override
350         returns (uint256)
351     {
352         address token = issuerTokens[issuer];
353         if (token == issuer) {
354             // cross margin
355             return IERC20(token).balanceOf(fund());
356         } else {
357             return lendingMeta[issuer].totalLending - haircuts[issuer];
358         }
359     }
360 
361     function disburse(
362         address issuer,
363         address recipient,
364         uint256 amount
365     ) internal {
366         uint256 haircutAmount = haircuts[issuer];
367         if (haircutAmount > 0 && amount > 0) {
368             uint256 totalLending = lendingMeta[issuer].totalLending;
369             uint256 adjustment =
370                 (amount * min(totalLending, haircutAmount)) / totalLending;
371             amount = amount - adjustment;
372             haircuts[issuer] -= adjustment;
373         }
374 
375         address token = issuerTokens[issuer];
376         Fund(fund()).withdraw(token, recipient, amount);
377     }
378 
379     function collectToken(
380         address issuer,
381         address source,
382         uint256 amount
383     ) internal {
384         Fund(fund()).depositFor(source, issuer, amount);
385     }
386 
387     function haircut(uint256 amount) external {
388         haircuts[msg.sender] += amount;
389     }
390 }
