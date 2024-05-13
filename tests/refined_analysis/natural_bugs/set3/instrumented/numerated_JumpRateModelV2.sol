1 pragma solidity ^0.5.16;
2 
3 import "./InterestRateModel.sol";
4 import "./SafeMath.sol";
5 
6 /**
7  * @title Compound's JumpRateModel Contract V2
8  * @author Compound (modified by Dharma Labs)
9  * @notice Version 2 modifies Version 1 by enabling updateable parameters.
10  */
11 contract JumpRateModelV2 is InterestRateModel {
12     using SafeMath for uint256;
13 
14     event NewInterestParams(
15         uint256 baseRatePerBlock,
16         uint256 multiplierPerBlock,
17         uint256 jumpMultiplierPerBlock,
18         uint256 kink,
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
53      * @notice The utilization point at which the jump multiplier is applied
54      */
55     uint256 public kink;
56 
57     /**
58      * @notice The utilization point at which the rate is fixed
59      */
60     uint256 public roof;
61 
62     /**
63      * @notice Construct an interest rate model
64      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
65      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
66      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
67      * @param kink_ The utilization point at which the jump multiplier is applied
68      * @param roof_ The utilization point at which the borrow rate is fixed
69      * @param owner_ The address of the owner, i.e. the Timelock contract (which has the ability to update parameters directly)
70      */
71     constructor(
72         uint256 baseRatePerYear,
73         uint256 multiplierPerYear,
74         uint256 jumpMultiplierPerYear,
75         uint256 kink_,
76         uint256 roof_,
77         address owner_
78     ) public {
79         owner = owner_;
80 
81         updateJumpRateModelInternal(baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink_, roof_);
82     }
83 
84     /**
85      * @notice Update the parameters of the interest rate model (only callable by owner, i.e. Timelock)
86      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
87      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
88      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
89      * @param kink_ The utilization point at which the jump multiplier is applied
90      * @param roof_ The utilization point at which the borrow rate is fixed
91      */
92     function updateJumpRateModel(
93         uint256 baseRatePerYear,
94         uint256 multiplierPerYear,
95         uint256 jumpMultiplierPerYear,
96         uint256 kink_,
97         uint256 roof_
98     ) external {
99         require(msg.sender == owner, "only the owner may call this function.");
100 
101         updateJumpRateModelInternal(baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink_, roof_);
102     }
103 
104     /**
105      * @notice Calculates the utilization rate of the market: `borrows / (cash + borrows - reserves)`
106      * @param cash The amount of cash in the market
107      * @param borrows The amount of borrows in the market
108      * @param reserves The amount of reserves in the market (currently unused)
109      * @return The utilization rate as a mantissa between [0, 1e18]
110      */
111     function utilizationRate(
112         uint256 cash,
113         uint256 borrows,
114         uint256 reserves
115     ) public view returns (uint256) {
116         // Utilization rate is 0 when there are no borrows
117         if (borrows == 0) {
118             return 0;
119         }
120 
121         uint256 util = borrows.mul(1e18).div(cash.add(borrows).sub(reserves));
122         // If the utilization is above the roof, cap it.
123         if (util > roof) {
124             util = roof;
125         }
126         return util;
127     }
128 
129     /**
130      * @notice Calculates the current borrow rate per block, with the error code expected by the market
131      * @param cash The amount of cash in the market
132      * @param borrows The amount of borrows in the market
133      * @param reserves The amount of reserves in the market
134      * @return The borrow rate percentage per block as a mantissa (scaled by 1e18)
135      */
136     function getBorrowRate(
137         uint256 cash,
138         uint256 borrows,
139         uint256 reserves
140     ) public view returns (uint256) {
141         uint256 util = utilizationRate(cash, borrows, reserves);
142 
143         if (util <= kink) {
144             return util.mul(multiplierPerBlock).div(1e18).add(baseRatePerBlock);
145         } else {
146             uint256 normalRate = kink.mul(multiplierPerBlock).div(1e18).add(baseRatePerBlock);
147             uint256 excessUtil = util.sub(kink);
148             return excessUtil.mul(jumpMultiplierPerBlock).div(1e18).add(normalRate);
149         }
150     }
151 
152     /**
153      * @notice Calculates the current supply rate per block
154      * @param cash The amount of cash in the market
155      * @param borrows The amount of borrows in the market
156      * @param reserves The amount of reserves in the market
157      * @param reserveFactorMantissa The current reserve factor for the market
158      * @return The supply rate percentage per block as a mantissa (scaled by 1e18)
159      */
160     function getSupplyRate(
161         uint256 cash,
162         uint256 borrows,
163         uint256 reserves,
164         uint256 reserveFactorMantissa
165     ) public view returns (uint256) {
166         uint256 oneMinusReserveFactor = uint256(1e18).sub(reserveFactorMantissa);
167         uint256 borrowRate = getBorrowRate(cash, borrows, reserves);
168         uint256 rateToPool = borrowRate.mul(oneMinusReserveFactor).div(1e18);
169         return utilizationRate(cash, borrows, reserves).mul(rateToPool).div(1e18);
170     }
171 
172     /**
173      * @notice Internal function to update the parameters of the interest rate model
174      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
175      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
176      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
177      * @param kink_ The utilization point at which the jump multiplier is applied
178      * @param roof_ The utilization point at which the borrow rate is fixed
179      */
180     function updateJumpRateModelInternal(
181         uint256 baseRatePerYear,
182         uint256 multiplierPerYear,
183         uint256 jumpMultiplierPerYear,
184         uint256 kink_,
185         uint256 roof_
186     ) internal {
187         require(roof_ >= minRoofValue, "invalid roof value");
188 
189         baseRatePerBlock = baseRatePerYear.div(blocksPerYear);
190         multiplierPerBlock = (multiplierPerYear.mul(1e18)).div(blocksPerYear.mul(kink_));
191         jumpMultiplierPerBlock = jumpMultiplierPerYear.div(blocksPerYear);
192         kink = kink_;
193         roof = roof_;
194 
195         emit NewInterestParams(baseRatePerBlock, multiplierPerBlock, jumpMultiplierPerBlock, kink, roof);
196     }
197 }
