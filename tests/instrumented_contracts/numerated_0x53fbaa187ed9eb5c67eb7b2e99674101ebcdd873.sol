1 /*
2  * Elementium, 2018/10
3  */
4 
5 pragma solidity ^0.4.24;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     require(c / a == b);
14     return c;
15   }
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     require(b > 0);
18     uint256 c = a / b;
19     return c;
20   }
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     require(b <= a);
23     uint256 c = a - b;
24     return c;
25   }
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     require(c >= a);
29     return c;
30   }
31 }
32 
33 interface IERC20 {
34   function balanceOf(address who) external view returns (uint256);
35   function transfer(address to, uint256 value) external returns (bool);
36 }
37 
38 /**
39  * @title ElementiumVesting
40  * @dev ElementiumVesting is a token manager contract that 
41  * constrols token extraction to beneficiaries.
42  */
43 contract ElementiumVesting {
44   using SafeMath for uint256;
45 
46   struct StagedLockingPlan {
47     address beneficiary;
48     uint256 managedAmount;
49     uint256 start;
50     uint256 stages;
51     uint256 durationPerStage;
52     uint256 releaseRatio;
53     uint256 currentyStage;
54     uint256 released;
55   }
56 
57   uint256 private _milestone1 = 1540425600;     // GMT 2018/10/25 00:00:00
58   uint256 private _milestone2 = 1571961600;     // GMT 2019/10/25 00:00:00
59   uint256 private _durationMonth = 2592000;     // seconds of a month (30 days)
60   uint256 private _durationYear = 31536000;     // seconds of a year (365 days)
61 
62   // Managed token
63   IERC20 private _token;
64 
65   // Locking plans
66   uint256 private _numPlans;
67   mapping (uint256 => StagedLockingPlan) private _plans;
68 
69   constructor(IERC20 token) public {
70     _token = token;
71 
72     // USAGE: Invoke [TOKEN].release(0) to release vested tokens of Plan-1 to the beneficiary.
73     _addLockingPlan(
74       address(0xcCDAb5791D3d11209f5bEEE58003Aa4EAb3E9b63),    // beneficiary
75       150000000000000000,   // amount managed
76       _milestone2,          // start from milestone 2
77       1,                    // single stage
78       _durationYear,        // a year of each stage
79       0);                   // average amount releasing
80 
81     // USAGE: Invoke [TOKEN].release(1) to release vested tokens of Plan-2 to the beneficiary.
82     _addLockingPlan(
83       address(0x8D4Db0c0cB4b937523eBcfd86A8038eb0475166A),    // beneficiary
84       250000000000000000,   // amount managed
85       _milestone1,          // start from milestone 1
86       4,                    // 4 stages
87       _durationMonth,       // a month of each stage
88       0);                   // average amount releasing
89 
90     // USAGE: Invoke [TOKEN].release(2) to release vested tokens of Plan-3 to the beneficiary.
91     _addLockingPlan(
92       address(0xCFc030Fb11d88772a58BFE30a296C6c215A912Bb),    // beneficiary
93       400000000000000000,   // amount managed
94       _milestone1,          // start from milestone 1
95       20,                   // 20 stages
96       _durationYear,        // a year of each stage
97       4);                   // ratio amount releasing, 25% for each time
98   }
99 
100   function _addLockingPlan (
101     address beneficiary,
102     uint256 managedAmount,
103     uint256 start,
104     uint256 stages,
105     uint256 durationPerStage,
106     uint256 releaseRatio
107   ) 
108     private 
109   {
110     require(beneficiary != address(0));
111     require(managedAmount > 0);
112     require(stages > 0);
113 
114     _plans[_numPlans] = StagedLockingPlan({
115       beneficiary: beneficiary,
116       managedAmount: managedAmount,
117       start: start,
118       stages: stages,
119       durationPerStage: durationPerStage,
120       releaseRatio: releaseRatio,
121       currentyStage: 0,
122       released: 0
123     });
124     _numPlans = _numPlans.add(1);
125   }
126 
127   function _releasableAmount(uint256 i, uint256 nextStage) private view returns (uint256) {
128     uint256 cliff = _plans[i].released;
129     if(nextStage < _plans[i].stages) {
130       // Average amount releasing
131       if(_plans[i].releaseRatio == 0) {
132         uint256 amountPerStage = _plans[i].managedAmount.div(_plans[i].stages);
133         cliff = nextStage.mul(amountPerStage);
134       }
135       // Ratio amount releasing
136       else {
137         cliff = 0;
138         // sum all historical stages
139         for(uint j = 0; j < nextStage; j++) {
140           uint256 remained = _plans[i].managedAmount.sub(cliff);
141           cliff = cliff.add(remained.div(_plans[i].releaseRatio));
142         }
143       }
144     }
145     // The last stage
146     else {
147       cliff = _plans[i].managedAmount;    // release all remained in the last stage
148     }
149     return cliff.sub(_plans[i].released);
150   }
151 
152   function release(uint256 iPlan) public {
153     require(iPlan >= 0 && iPlan < _numPlans);
154     require(_plans[iPlan].currentyStage < _plans[iPlan].stages);
155     uint256 duration = block.timestamp.sub(_plans[iPlan].start);
156     uint256 nextStage = duration.div(_plans[iPlan].durationPerStage);
157     nextStage = nextStage.add(1);   // point to the next stage
158     if(nextStage > _plans[iPlan].stages) {
159       nextStage = _plans[iPlan].stages;    // round to the last stage
160     }
161     uint256 unreleased = _releasableAmount(iPlan, nextStage);
162     require(unreleased > 0);
163     _plans[iPlan].currentyStage = nextStage;
164     _plans[iPlan].released = _plans[iPlan].released.add(unreleased);
165     _token.transfer(_plans[iPlan].beneficiary, unreleased);
166   }
167 
168   function token() public view returns (address) {
169     return address(_token);
170   }
171 
172   function balance() public view returns (uint256) {
173     return _token.balanceOf(address(this));
174   }
175 
176   function locked() public view 
177     returns (uint256 total, uint256 plan1, uint256 plan2, uint256 plan3) 
178   {
179     plan1 = _plans[0].managedAmount.sub(_plans[0].released);
180     plan2 = _plans[1].managedAmount.sub(_plans[1].released);
181     plan3 = _plans[2].managedAmount.sub(_plans[2].released);
182     total = plan1.add(plan2.add(plan3));
183   }
184 
185   function released() public view 
186     returns (uint256 total, uint256 plan1, uint256 plan2, uint256 plan3) 
187   {
188     plan1 = _plans[0].released;
189     plan2 = _plans[1].released;
190     plan3 = _plans[2].released;
191     total = plan1.add(plan2.add(plan3));
192   }
193 
194   function currentyStage() public view 
195     returns (uint256 plan1, uint256 plan2, uint256 plan3) 
196   {
197     plan1 = _plans[0].currentyStage;
198     plan2 = _plans[1].currentyStage;
199     plan3 = _plans[2].currentyStage;
200   }
201 }