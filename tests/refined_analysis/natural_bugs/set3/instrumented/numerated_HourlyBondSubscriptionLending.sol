1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "./BaseLending.sol";
5 
6 struct HourlyBond {
7     uint256 amount;
8     uint256 yieldQuotientFP;
9     uint256 moduloHour;
10 }
11 
12 /// @title Here we offer subscriptions to auto-renewing hourly bonds
13 /// Funds are locked in for an 50 minutes per hour, while interest rates float
14 abstract contract HourlyBondSubscriptionLending is BaseLending {
15     struct HourlyBondMetadata {
16         YieldAccumulator yieldAccumulator;
17         uint256 buyingSpeed;
18         uint256 withdrawingSpeed;
19         uint256 lastBought;
20         uint256 lastWithdrawn;
21     }
22 
23     mapping(address => HourlyBondMetadata) hourlyBondMetadata;
24 
25     uint256 public withdrawalWindow = 10 minutes;
26     // issuer => holder => bond record
27     mapping(address => mapping(address => HourlyBond))
28         public hourlyBondAccounts;
29 
30     uint256 public borrowingFactorPercent = 200;
31 
32     /// Set withdrawal window
33     function setWithdrawalWindow(uint256 window) external onlyOwner {
34         withdrawalWindow = window;
35     }
36 
37     function _makeHourlyBond(
38         address issuer,
39         address holder,
40         uint256 amount
41     ) internal {
42         HourlyBond storage bond = hourlyBondAccounts[issuer][holder];
43         updateHourlyBondAmount(issuer, bond);
44 
45         HourlyBondMetadata storage bondMeta = hourlyBondMetadata[issuer];
46         bond.yieldQuotientFP = bondMeta.yieldAccumulator.accumulatorFP;
47         bond.moduloHour = block.timestamp % (1 hours);
48         bond.amount += amount;
49         lendingMeta[issuer].totalLending += amount;
50 
51         (bondMeta.buyingSpeed, bondMeta.lastBought) = updateSpeed(
52             bondMeta.buyingSpeed,
53             bondMeta.lastBought,
54             amount,
55             1 hours
56         );
57     }
58 
59     function updateHourlyBondAmount(address issuer, HourlyBond storage bond)
60         internal
61     {
62         uint256 yieldQuotientFP = bond.yieldQuotientFP;
63         if (yieldQuotientFP > 0) {
64             YieldAccumulator storage yA =
65                 getUpdatedHourlyYield(issuer, hourlyBondMetadata[issuer]);
66 
67             uint256 oldAmount = bond.amount;
68             bond.amount = applyInterest(
69                 bond.amount,
70                 yA.accumulatorFP,
71                 yieldQuotientFP
72             );
73 
74             uint256 deltaAmount = bond.amount - oldAmount;
75             lendingMeta[issuer].totalLending += deltaAmount;
76         }
77     }
78 
79     // Retrieves bond balance for issuer and holder
80     function viewHourlyBondAmount(address issuer, address holder)
81         public
82         view
83         returns (uint256)
84     {
85         HourlyBond storage bond = hourlyBondAccounts[issuer][holder];
86         uint256 yieldQuotientFP = bond.yieldQuotientFP;
87 
88         uint256 cumulativeYield =
89             viewCumulativeYieldFP(
90                 hourlyBondMetadata[issuer].yieldAccumulator,
91                 block.timestamp
92             );
93 
94         if (yieldQuotientFP > 0) {
95             return
96                 bond.amount +
97                 applyInterest(bond.amount, cumulativeYield, yieldQuotientFP);
98         }
99         return bond.amount + 0;
100     }
101 
102     function _withdrawHourlyBond(
103         address issuer,
104         HourlyBond storage bond,
105         uint256 amount
106     ) internal {
107         // how far the current hour has advanced (relative to acccount hourly clock)
108         uint256 currentOffset = (block.timestamp - bond.moduloHour) % (1 hours);
109 
110         require(
111             withdrawalWindow >= currentOffset,
112             "Tried withdrawing outside subscription cancellation time window"
113         );
114 
115         bond.amount -= amount;
116         lendingMeta[issuer].totalLending -= amount;
117 
118         HourlyBondMetadata storage bondMeta = hourlyBondMetadata[issuer];
119         (bondMeta.withdrawingSpeed, bondMeta.lastWithdrawn) = updateSpeed(
120             bondMeta.withdrawingSpeed,
121             bondMeta.lastWithdrawn,
122             bond.amount,
123             1 hours
124         );
125     }
126 
127     function calcCumulativeYieldFP(
128         YieldAccumulator storage yieldAccumulator,
129         uint256 timeDelta
130     ) internal view returns (uint256 accumulatorFP) {
131         uint256 secondsDelta = timeDelta % (1 hours);
132         // linearly interpolate interest for seconds
133         // accumulator * hourly_yield == seconds_per_hour * accumulator * hourly_yield / seconds_per_hour
134         // FP * FP * 1 / (FP * 1) = FP
135         accumulatorFP =
136             (yieldAccumulator.accumulatorFP *
137                 yieldAccumulator.hourlyYieldFP *
138                 secondsDelta) /
139             (FP32 * 1 hours);
140 
141         uint256 hoursDelta = timeDelta / (1 hours);
142         if (hoursDelta > 0) {
143             // This loop should hardly ever 1 or more unless something bad happened
144             // In which case it costs gas but there isn't overflow
145             for (uint256 i = 0; hoursDelta > i; i++) {
146                 // FP32 * FP32 / FP32 = FP32
147                 accumulatorFP =
148                     (accumulatorFP * yieldAccumulator.hourlyYieldFP) /
149                     FP32;
150             }
151         }
152     }
153 
154     /// @dev updates yield accumulators for both borrowing and lending
155     function getUpdatedHourlyYield(
156         address issuer,
157         HourlyBondMetadata storage bondMeta
158     ) internal returns (YieldAccumulator storage accumulator) {
159         accumulator = bondMeta.yieldAccumulator;
160         uint256 timeDelta = (block.timestamp - accumulator.lastUpdated);
161 
162         accumulator.accumulatorFP = calcCumulativeYieldFP(
163             accumulator,
164             timeDelta
165         );
166 
167         LendingMetadata storage meta = lendingMeta[issuer];
168         YieldAccumulator storage borrowAccumulator =
169             borrowYieldAccumulators[issuer];
170 
171         uint256 yieldGeneratedFP =
172             (borrowAccumulator.hourlyYieldFP * meta.totalBorrowed) /
173                 (1 + meta.totalLending);
174         uint256 _maxHourlyYieldFP = min(maxHourlyYieldFP, yieldGeneratedFP);
175 
176         accumulator.hourlyYieldFP = updatedYieldFP(
177             accumulator.hourlyYieldFP,
178             accumulator.lastUpdated,
179             meta.totalLending,
180             lendingTarget(meta),
181             bondMeta.buyingSpeed,
182             bondMeta.withdrawingSpeed,
183             _maxHourlyYieldFP
184         );
185 
186         timeDelta = block.timestamp - borrowAccumulator.lastUpdated;
187         borrowAccumulator.accumulatorFP = calcCumulativeYieldFP(
188             borrowAccumulator,
189             timeDelta
190         );
191 
192         borrowAccumulator.hourlyYieldFP =
193             1 +
194             (borrowingFactorPercent * accumulator.hourlyYieldFP) /
195             100;
196 
197         accumulator.lastUpdated = block.timestamp;
198         borrowAccumulator.lastUpdated = block.timestamp;
199     }
200 
201     function viewCumulativeYieldFP(
202         YieldAccumulator storage yA,
203         uint256 timestamp
204     ) internal view returns (uint256) {
205         uint256 timeDelta = (timestamp - yA.lastUpdated);
206         return calcCumulativeYieldFP(yA, timeDelta);
207     }
208 }
