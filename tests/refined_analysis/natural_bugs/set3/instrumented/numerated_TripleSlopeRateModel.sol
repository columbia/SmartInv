1 pragma solidity ^0.5.16;
2 
3 import "./InterestRateModel.sol";
4 import "./SafeMath.sol";
5 
6 /**
7  * @title CREAM's TripleSlopeRateModel Contract
8  * @author C.R.E.A.M. Finance
9  */
10 contract TripleSlopeRateModel is InterestRateModel {
11     using SafeMath for uint256;
12 
13     event NewInterestParams(
14         uint256 baseRatePerBlock,
15         uint256 multiplierPerBlock,
16         uint256 jumpMultiplierPerBlock,
17         uint256 kink1,
18         uint256 kink2,
19         uint256 roof
20     );
21 
22     /**
23      * @notice The address of the owner, i.e. the Timelock contract, which can update parameters directly
24      */
25     address public owner;
26 
27     /**
28      * @notice The approximate number of blocks per year that is assumed by the interest rate model
29      */
30     uint256 public constant blocksPerYear = 2102400;
31 
32     /**
33      * @notice The minimum roof value used for calculating borrow rate.
34      */
35     uint256 internal constant minRoofValue = 1e18;
36 
37     /**
38      * @notice The multiplier of utilization rate that gives the slope of the interest rate
39      */
40     uint256 public multiplierPerBlock;
41 
42     /**
43      * @notice The base interest rate which is the y-intercept when utilization rate is 0
44      */
45     uint256 public baseRatePerBlock;
46 
47     /**
48      * @notice The multiplierPerBlock after hitting a specified utilization point
49      */
50     uint256 public jumpMultiplierPerBlock;
51 
52     /**
53      * @notice The utilization point at which the interest rate is fixed
54      */
55     uint256 public kink1;
56 
57     /**
58      * @notice The utilization point at which the jump multiplier is applied
59      */
60     uint256 public kink2;
61 
62     /**
63      * @notice The utilization point at which the rate is fixed
64      */
65     uint256 public roof;
66 
67     /**
68      * @notice Construct an interest rate model
69      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
70      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
71      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
72      * @param kink1_ The utilization point at which the interest rate is fixed
73      * @param kink2_ The utilization point at which the jump multiplier is applied
74      * @param roof_ The utilization point at which the borrow rate is fixed
75      * @param owner_ The address of the owner, i.e. the Timelock contract (which has the ability to update parameters directly)
76      */
77     constructor(
78         uint256 baseRatePerYear,
79         uint256 multiplierPerYear,
80         uint256 jumpMultiplierPerYear,
81         uint256 kink1_,
82         uint256 kink2_,
83         uint256 roof_,
84         address owner_
85     ) public {
86         owner = owner_;
87 
88         updateTripleRateModelInternal(baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink1_, kink2_, roof_);
89     }
90 
91     /**
92      * @notice Update the parameters of the interest rate model (only callable by owner, i.e. Timelock)
93      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
94      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
95      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
96      * @param kink1_ The utilization point at which the interest rate is fixed
97      * @param kink2_ The utilization point at which the jump multiplier is applied
98      * @param roof_ The utilization point at which the borrow rate is fixed
99      */
100     function updateTripleRateModel(
101         uint256 baseRatePerYear,
102         uint256 multiplierPerYear,
103         uint256 jumpMultiplierPerYear,
104         uint256 kink1_,
105         uint256 kink2_,
106         uint256 roof_
107     ) external {
108         require(msg.sender == owner, "only the owner may call this function.");
109 
110         updateTripleRateModelInternal(baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink1_, kink2_, roof_);
111     }
112 
113     /**
114      * @notice Calculates the utilization rate of the market: `borrows / (cash + borrows - reserves)`
115      * @param cash The amount of cash in the market
116      * @param borrows The amount of borrows in the market
117      * @param reserves The amount of reserves in the market (currently unused)
118      * @return The utilization rate as a mantissa between [0, 1e18]
119      */
120     function utilizationRate(
121         uint256 cash,
122         uint256 borrows,
123         uint256 reserves
124     ) public view returns (uint256) {
125         // Utilization rate is 0 when there are no borrows
126         if (borrows == 0) {
127             return 0;
128         }
129 
130         uint256 util = borrows.mul(1e18).div(cash.add(borrows).sub(reserves));
131         // If the utilization is above the roof, cap it.
132         if (util > roof) {
133             util = roof;
134         }
135         return util;
136     }
137 
138     /**
139      * @notice Calculates the current borrow rate per block, with the error code expected by the market
140      * @param cash The amount of cash in the market
141      * @param borrows The amount of borrows in the market
142      * @param reserves The amount of reserves in the market
143      * @return The borrow rate percentage per block as a mantissa (scaled by 1e18)
144      */
145     function getBorrowRate(
146         uint256 cash,
147         uint256 borrows,
148         uint256 reserves
149     ) public view returns (uint256) {
150         uint256 util = utilizationRate(cash, borrows, reserves);
151 
152         if (util <= kink1) {
153             return util.mul(multiplierPerBlock).div(1e18).add(baseRatePerBlock);
154         } else if (util <= kink2) {
155             return kink1.mul(multiplierPerBlock).div(1e18).add(baseRatePerBlock);
156         } else {
157             uint256 normalRate = kink1.mul(multiplierPerBlock).div(1e18).add(baseRatePerBlock);
158             uint256 excessUtil = util.sub(kink2);
159             return excessUtil.mul(jumpMultiplierPerBlock).div(1e18).add(normalRate);
160         }
161     }
162 
163     /**
164      * @notice Calculates the current supply rate per block
165      * @param cash The amount of cash in the market
166      * @param borrows The amount of borrows in the market
167      * @param reserves The amount of reserves in the market
168      * @param reserveFactorMantissa The current reserve factor for the market
169      * @return The supply rate percentage per block as a mantissa (scaled by 1e18)
170      */
171     function getSupplyRate(
172         uint256 cash,
173         uint256 borrows,
174         uint256 reserves,
175         uint256 reserveFactorMantissa
176     ) public view returns (uint256) {
177         uint256 oneMinusReserveFactor = uint256(1e18).sub(reserveFactorMantissa);
178         uint256 borrowRate = getBorrowRate(cash, borrows, reserves);
179         uint256 rateToPool = borrowRate.mul(oneMinusReserveFactor).div(1e18);
180         return utilizationRate(cash, borrows, reserves).mul(rateToPool).div(1e18);
181     }
182 
183     /**
184      * @notice Internal function to update the parameters of the interest rate model
185      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
186      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
187      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
188      * @param kink1_ The utilization point at which the interest rate is fixed
189      * @param kink2_ The utilization point at which the jump multiplier is applied
190      * @param roof_ The utilization point at which the borrow rate is fixed
191      */
192     function updateTripleRateModelInternal(
193         uint256 baseRatePerYear,
194         uint256 multiplierPerYear,
195         uint256 jumpMultiplierPerYear,
196         uint256 kink1_,
197         uint256 kink2_,
198         uint256 roof_
199     ) internal {
200         require(kink1_ <= kink2_, "kink1 must less than or equal to kink2");
201         require(roof_ >= minRoofValue, "invalid roof value");
202 
203         baseRatePerBlock = baseRatePerYear.div(blocksPerYear);
204         multiplierPerBlock = (multiplierPerYear.mul(1e18)).div(blocksPerYear.mul(kink1_));
205         jumpMultiplierPerBlock = jumpMultiplierPerYear.div(blocksPerYear);
206         kink1 = kink1_;
207         kink2 = kink2_;
208         roof = roof_;
209 
210         emit NewInterestParams(baseRatePerBlock, multiplierPerBlock, jumpMultiplierPerBlock, kink1, kink2, roof);
211     }
212 }
