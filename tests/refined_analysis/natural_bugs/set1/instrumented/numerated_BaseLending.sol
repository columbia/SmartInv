1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 import "./RoleAware.sol";
4 
5 /// @title Base lending behavior
6 abstract contract BaseLending is Ownable {
7     uint256 constant FP32 = 2**32;
8     uint256 constant ACCUMULATOR_INIT = 10**18;
9 
10     struct YieldAccumulator {
11         uint256 accumulatorFP;
12         uint256 lastUpdated;
13         uint256 hourlyYieldFP;
14     }
15 
16     struct LendingMetadata {
17         uint256 totalLending;
18         uint256 totalBorrowed;
19         uint256 lendingBuffer;
20         uint256 lendingCap;
21     }
22     mapping(address => LendingMetadata) public lendingMeta;
23 
24     /// @dev accumulate interest per issuer (like compound indices)
25     mapping(address => YieldAccumulator) public borrowYieldAccumulators;
26 
27     uint256 public maxHourlyYieldFP;
28     uint256 public yieldChangePerSecondFP;
29 
30     /// @dev simple formula for calculating interest relative to accumulator
31     function applyInterest(
32         uint256 balance,
33         uint256 accumulatorFP,
34         uint256 yieldQuotientFP
35     ) internal pure returns (uint256) {
36         // 1 * FP / FP = 1
37         return (balance * accumulatorFP) / yieldQuotientFP;
38     }
39 
40     /// update the yield for an asset based on recent supply and demand
41     function updatedYieldFP(
42         // previous yield
43         uint256 _yieldFP,
44         // timestamp
45         uint256 lastUpdated,
46         uint256 totalLendingInBucket,
47         uint256 bucketTarget,
48         uint256 buyingSpeed,
49         uint256 withdrawingSpeed,
50         uint256 bucketMaxYield
51     ) internal view returns (uint256 yieldFP) {
52         yieldFP = _yieldFP;
53         uint256 timeDiff = block.timestamp - lastUpdated;
54         uint256 yieldDiff = timeDiff * yieldChangePerSecondFP;
55 
56         if (
57             totalLendingInBucket >= bucketTarget ||
58             buyingSpeed >= withdrawingSpeed
59         ) {
60             yieldFP -= min(yieldFP, yieldDiff);
61         } else {
62             yieldFP += yieldDiff;
63             if (yieldFP > bucketMaxYield) {
64                 yieldFP = bucketMaxYield;
65             }
66         }
67     }
68 
69     function updateSpeed(
70         uint256 speed,
71         uint256 lastAction,
72         uint256 amount,
73         uint256 runtime
74     ) internal view returns (uint256 newSpeed, uint256 newLastAction) {
75         uint256 timeDiff = block.timestamp - lastAction;
76         uint256 updateAmount = (amount * runtime) / (timeDiff + 1);
77 
78         uint256 oldSpeedWeight = (runtime + 120 minutes) / 3;
79         uint256 updateWeight = timeDiff + 1;
80         // scale adjustment relative to runtime
81         newSpeed =
82             (speed * oldSpeedWeight + updateAmount * updateWeight) /
83             (oldSpeedWeight + updateWeight);
84         newLastAction = block.timestamp;
85     }
86 
87     /// @dev minimum
88     function min(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a > b) {
90             return b;
91         } else {
92             return a;
93         }
94     }
95 
96     function _makeFallbackBond(
97         address issuer,
98         address holder,
99         uint256 amount
100     ) internal virtual;
101 
102     function lendingTarget(LendingMetadata storage meta)
103         internal
104         view
105         returns (uint256)
106     {
107         return min(meta.lendingCap, meta.totalBorrowed + meta.lendingBuffer);
108     }
109 
110     /// View lending target
111     function viewLendingTarget(address issuer) external view returns (uint256) {
112         LendingMetadata storage meta = lendingMeta[issuer];
113         return lendingTarget(meta);
114     }
115 
116     /// Set maximum hourly yield in floating point
117     function setMaxHourlyYieldFP(uint256 maxYieldFP) external onlyOwner {
118         maxHourlyYieldFP = maxYieldFP;
119     }
120 
121     /// Set yield change per second in floating point
122     function setYieldChangePerSecondFP(uint256 changePerSecondFP)
123         external
124         onlyOwner
125     {
126         yieldChangePerSecondFP = changePerSecondFP;
127     }
128 
129     /// Available tokens to this issuance
130     function issuanceBalance(address issuance)
131         internal
132         view
133         virtual
134         returns (uint256);
135 }
