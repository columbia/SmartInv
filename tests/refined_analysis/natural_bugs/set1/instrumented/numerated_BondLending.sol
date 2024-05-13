1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 import "./BaseLending.sol";
4 
5 struct Bond {
6     address holder;
7     address issuer;
8     uint256 originalPrice;
9     uint256 returnAmount;
10     uint256 maturityTimestamp;
11     uint256 runtime;
12     uint256 yieldFP;
13 }
14 
15 /** 
16 @title Lending for fixed runtime, fixed interest
17 Lenders can pick their own bond maturity date
18 @dev In order to manage interest rates for the different
19 maturities and create a yield curve we bucket
20 bond runtimes into weighted baskets and adjust
21 rates individually per bucket, based on supply and demand.
22 */
23 abstract contract BondLending is BaseLending {
24     uint256 public minRuntime = 30 days;
25     uint256 public maxRuntime = 365 days;
26     uint256 public diffMaxMinRuntime;
27     /** 
28     @dev this is the numerator under runtimeWeights.
29     any excess left over is the weight of hourly bonds
30     */
31     uint256 public constant WEIGHT_TOTAL_10k = 10_000;
32     uint256 public borrowingMarkupFP;
33 
34     struct BondBucketMetadata {
35         uint256 runtimeWeight;
36         uint256 buyingSpeed;
37         uint256 lastBought;
38         uint256 withdrawingSpeed;
39         uint256 lastWithdrawn;
40         uint256 yieldLastUpdated;
41         uint256 totalLending;
42         uint256 runtimeYieldFP;
43     }
44 
45     mapping(uint256 => Bond) public bonds;
46 
47     mapping(address => BondBucketMetadata[]) public bondBucketMetadata;
48 
49     uint256 public nextBondIndex = 1;
50 
51     event LiquidityWarning(
52         address indexed issuer,
53         address indexed holder,
54         uint256 value
55     );
56 
57     function _makeBond(
58         address holder,
59         address issuer,
60         uint256 runtime,
61         uint256 amount,
62         uint256 minReturn
63     ) internal returns (uint256 bondIndex) {
64         uint256 bucketIndex = getBucketIndex(issuer, runtime);
65         BondBucketMetadata storage bondMeta =
66             bondBucketMetadata[issuer][bucketIndex];
67 
68         uint256 yieldFP = calcBondYieldFP(issuer, amount, runtime, bondMeta);
69 
70         uint256 bondReturn = (yieldFP * amount) / FP32;
71         if (bondReturn >= minReturn) {
72             uint256 interpolatedAmount = (amount + bondReturn) / 2;
73             lendingMeta[issuer].totalLending += interpolatedAmount;
74 
75             bondMeta.totalLending += interpolatedAmount;
76 
77             bondIndex = nextBondIndex;
78             nextBondIndex++;
79 
80             bonds[bondIndex] = Bond({
81                 holder: holder,
82                 issuer: issuer,
83                 originalPrice: amount,
84                 returnAmount: bondReturn,
85                 maturityTimestamp: block.timestamp + runtime,
86                 runtime: runtime,
87                 yieldFP: yieldFP
88             });
89 
90             (bondMeta.buyingSpeed, bondMeta.lastBought) = updateSpeed(
91                 bondMeta.buyingSpeed,
92                 bondMeta.lastBought,
93                 amount,
94                 runtime
95             );
96         }
97     }
98 
99     function _withdrawBond(uint256 bondId, Bond storage bond)
100         internal
101         returns (uint256 withdrawAmount)
102     {
103         address issuer = bond.issuer;
104         uint256 bucketIndex = getBucketIndex(issuer, bond.runtime);
105         BondBucketMetadata storage bondMeta =
106             bondBucketMetadata[issuer][bucketIndex];
107 
108         uint256 returnAmount = bond.returnAmount;
109         address holder = bond.holder;
110 
111         uint256 interpolatedAmount = (bond.originalPrice + returnAmount) / 2;
112 
113         LendingMetadata storage meta = lendingMeta[issuer];
114         meta.totalLending -= interpolatedAmount;
115         bondMeta.totalLending -= interpolatedAmount;
116 
117         (bondMeta.withdrawingSpeed, bondMeta.lastWithdrawn) = updateSpeed(
118             bondMeta.withdrawingSpeed,
119             bondMeta.lastWithdrawn,
120             bond.originalPrice,
121             bond.runtime
122         );
123 
124         delete bonds[bondId];
125         if (
126             meta.totalBorrowed > meta.totalLending ||
127             issuanceBalance(issuer) < returnAmount
128         ) {
129             // apparently there is a liquidity issue
130             emit LiquidityWarning(issuer, holder, returnAmount);
131             _makeFallbackBond(issuer, holder, returnAmount);
132         } else {
133             withdrawAmount = returnAmount;
134         }
135     }
136 
137     function calcBondYieldFP(
138         address issuer,
139         uint256 addedAmount,
140         uint256 runtime,
141         BondBucketMetadata storage bucketMeta
142     ) internal view returns (uint256 yieldFP) {
143         uint256 totalLendingInBucket = addedAmount + bucketMeta.totalLending;
144 
145         yieldFP = bucketMeta.runtimeYieldFP;
146         uint256 lastUpdated = bucketMeta.yieldLastUpdated;
147 
148         LendingMetadata storage meta = lendingMeta[issuer];
149         uint256 bucketTarget =
150             (lendingTarget(meta) * bucketMeta.runtimeWeight) / WEIGHT_TOTAL_10k;
151 
152         uint256 buying = bucketMeta.buyingSpeed;
153         uint256 withdrawing = bucketMeta.withdrawingSpeed;
154 
155         YieldAccumulator storage borrowAccumulator =
156             borrowYieldAccumulators[issuer];
157 
158         uint256 yieldGeneratedFP =
159             (borrowAccumulator.hourlyYieldFP * meta.totalBorrowed) /
160                 (1 + meta.totalLending);
161         uint256 _maxHourlyYieldFP = min(maxHourlyYieldFP, yieldGeneratedFP);
162 
163         uint256 bucketMaxYield = _maxHourlyYieldFP * (runtime / (1 hours));
164 
165         yieldFP = updatedYieldFP(
166             yieldFP,
167             lastUpdated,
168             totalLendingInBucket,
169             bucketTarget,
170             buying,
171             withdrawing,
172             bucketMaxYield
173         );
174     }
175 
176     /// Get view of returns on bond
177     function viewBondReturn(
178         address issuer,
179         uint256 runtime,
180         uint256 amount
181     ) external view returns (uint256) {
182         uint256 bucketIndex = getBucketIndex(issuer, runtime);
183         uint256 yieldFP =
184             calcBondYieldFP(
185                 issuer,
186                 amount + bondBucketMetadata[issuer][bucketIndex].totalLending,
187                 runtime,
188                 bondBucketMetadata[issuer][bucketIndex]
189             );
190         return (yieldFP * amount) / FP32;
191     }
192 
193     function getBucketIndex(address issuer, uint256 runtime)
194         internal
195         view
196         returns (uint256 bucketIndex)
197     {
198         uint256 bucketSize =
199             diffMaxMinRuntime / bondBucketMetadata[issuer].length;
200         bucketIndex = (runtime - minRuntime) / bucketSize;
201     }
202 
203     /// Set runtime yields in floating point
204     function setRuntimeYieldsFP(address issuer, uint256[] memory yieldsFP)
205         external
206         onlyOwner
207     {
208         BondBucketMetadata[] storage bondMetas = bondBucketMetadata[issuer];
209         for (uint256 i; bondMetas.length > i; i++) {
210             bondMetas[i].runtimeYieldFP = yieldsFP[i];
211         }
212     }
213 
214     /// Set miniumum runtime
215     function setMinRuntime(uint256 runtime) external onlyOwner {
216         require(runtime > 1 hours, "Min runtime needs to be at least 1 hour");
217         require(
218             maxRuntime > runtime,
219             "Min runtime must be smaller than max runtime"
220         );
221         minRuntime = runtime;
222     }
223 
224     /// Set maximum runtime
225     function setMaxRuntime(uint256 runtime) external onlyOwner {
226         require(
227             runtime > minRuntime,
228             "Max runtime must be greater than min runtime"
229         );
230         maxRuntime = runtime;
231     }
232 }
