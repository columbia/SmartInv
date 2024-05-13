1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
7 import {OracleLibrary} from "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";
8 import {LibWell} from "contracts/libraries/Well/LibWell.sol";
9 import {IBlockBasefee} from "../interfaces/IBlockBasefee.sol";
10 import "@openzeppelin/contracts/math/Math.sol";
11 import "../C.sol";
12 import "./Curve/LibCurve.sol";
13 
14 /**
15  * @title LibIncentive
16  * @author Publius, Chaikitty, Brean
17  * @notice Calculates the reward offered for calling Sunrise, adjusts for current gas & ETH prices,
18  * and scales the reward up when the Sunrise is called late.
19  */
20 library LibIncentive {
21     using SafeMath for uint256;
22 
23     /**
24      * @notice Emitted when Beanstalk pays `beans` to `account` as a reward for calling `sunrise()`.
25      * @param account The address to which the reward Beans were sent
26      * @param beans The amount of Beans paid as a reward
27      */
28     event Incentivization(address indexed account, uint256 beans);
29 
30     /// @dev The time range over which to consult the Uniswap V3 ETH:USDC pool oracle. Measured in seconds.
31     uint32 internal constant PERIOD = 1800; // 30 minutes
32 
33     /// @dev The Sunrise reward reaches its maximum after this many blocks elapse.
34     uint256 internal constant MAX_BLOCKS_LATE = 25;
35 
36     /// @dev Base BEAN reward to cover cost of operating a bot.
37     uint256 internal constant BASE_REWARD = 3e6; // 3 BEAN
38 
39     /// @dev Max BEAN reward for calling Sunrise.
40     uint256 internal constant MAX_REWARD = 100e6; // 100 BEAN
41 
42     /// @dev Wei buffer to account for the priority fee.
43     uint256 internal constant PRIORITY_FEE_BUFFER = 5e9; // 5e9 wei = 5 gwei
44 
45     /// @dev The maximum gas which Beanstalk will pay for a Sunrise transaction.
46     uint256 internal constant MAX_SUNRISE_GAS = 500_000; // 500k gas
47 
48     /// @dev Accounts for extra gas overhead for completing a Sunrise tranasaction.
49     // 21k gas (base cost for a transction) + ~29 gas for other overhead
50     uint256 internal constant SUNRISE_GAS_OVERHEAD = 50_000; // 50k gas
51 
52     /// @dev Use external contract for block.basefee as to avoid upgrading existing contracts to solidity v8
53     address private constant BASE_FEE_CONTRACT = 0x84292919cB64b590C0131550483707E43Ef223aC;
54 
55     /// @dev `sunriseReward` is precomputed in {fracExp} using this precision.
56     uint256 private constant FRAC_EXP_PRECISION = 1e18;
57 
58     //////////////////// CALCULATE REWARD ////////////////////
59 
60     /**
61      * @param initialGasLeft The amount of gas left at the start of the transaction
62      * @param blocksLate The number of blocks late that {sunrise()} was called.
63      * @param beanEthPrice The Bean:Eth price calculated by the Minting Well.
64      * @dev Calculates Sunrise incentive amount based on current gas prices and a computed
65      * BEAN:ETH price. This function is called at the end of {sunriseTo()} after all
66      * "step" functions have been executed.
67      */
68     function determineReward(uint256 initialGasLeft, uint256 blocksLate, uint256 beanEthPrice)
69         external
70         view
71         returns (uint256)
72     {
73 
74         // Cap the maximum number of blocks late. If the sunrise is later than
75         // this, Beanstalk will pay the same amount. Prevents unbounded return value.
76         if (blocksLate > MAX_BLOCKS_LATE) {
77             blocksLate = MAX_BLOCKS_LATE;
78         }
79 
80         // If the Bean Eth pool couldn't calculate a valid price, use the max reward value.
81         if (beanEthPrice <= 1) {
82             return fracExp(MAX_REWARD, blocksLate);
83         }
84 
85         // Sunrise gas overhead includes:
86         //  - 21K for base transaction cost
87         //  - 29K for calculations following the below line, like {fracExp}
88         // Max gas which Beanstalk will pay for = 500K.
89         uint256 gasUsed = Math.min(initialGasLeft.sub(gasleft()) + SUNRISE_GAS_OVERHEAD, MAX_SUNRISE_GAS);
90 
91         // Calculate the current cost in Wei of `gasUsed` gas.
92         // {block_basefee()} returns the base fee of the current block in Wei.
93         // Adds a buffer for priority fee.
94         uint256 gasCostWei = IBlockBasefee(BASE_FEE_CONTRACT).block_basefee().add(PRIORITY_FEE_BUFFER).mul(gasUsed); // (BASE_FEE
95             // + PRIORITY_FEE_BUFFER)
96             // * GAS_USED
97 
98         // Calculates the Sunrise reward to pay in BEAN.
99         uint256 sunriseReward = Math.min(
100             BASE_REWARD + gasCostWei.mul(beanEthPrice).div(1e18), // divide by 1e18 to convert wei to eth
101             MAX_REWARD
102         );
103 
104         // Scale the reward up as the number of blocks after expected sunrise increases.
105         // `sunriseReward * (1 + 1/100)^(blocks late * seconds per block)`
106         // NOTE: 1.01^(25 * 12) = 19.78, This is the maximum multiplier.
107         return fracExp(sunriseReward, blocksLate);
108     }
109 
110     //////////////////// MATH UTILITIES ////////////////////
111 
112     /**
113      * @dev fraxExp scales up the bean reward based on the blocks late.
114      * the formula is beans * (1.01)^(Blocks Late * 12 second block time).
115      * since block time is capped at 25 blocks,
116      * we only need to check cases 0 - 25
117      */
118     function fracExp(uint256 beans, uint256 blocksLate) internal pure returns (uint256 scaledSunriseReward) {
119         // check most likely case first
120         if (blocksLate == 0) {
121             return beans;
122         }
123 
124         // Binary Search
125         if (blocksLate < 13) {
126             if (blocksLate < 7) {
127                 if (blocksLate < 4) {
128                     if (blocksLate < 2) {
129                         // blocksLate == 0 is already checked, thus
130                         // blocksLate = 1, 1.01^(1*12)
131                         return _scaleReward(beans, 1_126_825_030_131_969_720);
132                     }
133                     if (blocksLate == 2) {
134                         // 1.01^(2*12)
135                         return _scaleReward(beans, 1_269_734_648_531_914_468);
136                     } else {
137                         // blocksLate == 3, 1.01^(3*12)
138                         return _scaleReward(beans, 1_430_768_783_591_580_504);
139                     }
140                 }
141                 if (blocksLate < 6) {
142                     if (blocksLate == 4) {
143                         return _scaleReward(beans, 1_612_226_077_682_464_366);
144                     } else {
145                         // blocksLate == 5
146                         return _scaleReward(beans, 1_816_696_698_564_090_264);
147                     }
148                 } else {
149                     // blocksLate == 6
150                     return _scaleReward(beans, 2_047_099_312_100_130_925);
151                 }
152             }
153             if (blocksLate < 10) {
154                 if (blocksLate < 9) {
155                     if (blocksLate == 7) {
156                         return _scaleReward(beans, 2_306_722_744_040_364_517);
157                     } else {
158                         // blocksLate == 8
159                         return _scaleReward(beans, 2_599_272_925_559_383_624);
160                     }
161                 } else {
162                     // blocksLate == 9
163                     return _scaleReward(beans, 2_928_925_792_664_665_541);
164                 }
165             }
166             if (blocksLate < 12) {
167                 if (blocksLate == 10) {
168                     return _scaleReward(beans, 3_300_386_894_573_665_047);
169                 } else {
170                     // blocksLate == 11
171                     return _scaleReward(beans, 3_718_958_561_925_128_091);
172                 }
173             } else {
174                 // blocksLate == 12
175                 return _scaleReward(beans, 4_190_615_593_600_829_241);
176             }
177         }
178         if (blocksLate < 19) {
179             if (blocksLate < 16) {
180                 if (blocksLate < 15) {
181                     if (blocksLate == 13) {
182                         return _scaleReward(beans, 4_722_090_542_530_756_587);
183                     } else {
184                         // blocksLate == 14
185                         return _scaleReward(beans, 5_320_969_817_873_109_037);
186                     }
187                 } else {
188                     // blocksLate == 15
189                     return _scaleReward(beans, 5_995_801_975_356_167_528);
190                 }
191             }
192             if (blocksLate < 18) {
193                 if (blocksLate == 16) {
194                     return _scaleReward(beans, 6_756_219_741_546_037_047);
195                 } else {
196                     // blocksLate == 17
197                     return _scaleReward(beans, 7_613_077_513_845_821_874);
198                 }
199             }
200             return _scaleReward(beans, 8_578_606_298_936_339_361); // blocksLate == 18
201         }
202         if (blocksLate < 22) {
203             if (blocksLate < 21) {
204                 if (blocksLate == 19) {
205                     return _scaleReward(beans, 9_666_588_301_289_245_846);
206                 } else {
207                     // blocksLate == 20
208                     return _scaleReward(beans, 10_892_553_653_873_600_447);
209                 }
210             }
211             return _scaleReward(beans, 12_274_002_099_240_216_703); // blocksLate == 21
212         }
213         if (blocksLate <= 23) {
214             if (blocksLate == 22) {
215                 return _scaleReward(beans, 13_830_652_785_316_216_792);
216             } else {
217                 // blocksLate == 23
218                 return _scaleReward(beans, 15_584_725_741_558_756_931);
219             }
220         }
221         if (blocksLate >= 25) {
222             // block rewards are capped at 25 (MAX_BLOCKS_LATE)
223             return _scaleReward(beans, 19_788_466_261_924_388_319);
224         } else {
225             // blocksLate == 24
226             return _scaleReward(beans, 17_561_259_053_330_430_428);
227         }
228     }
229 
230     function _scaleReward(uint256 beans, uint256 scaler) private pure returns (uint256) {
231         return beans.mul(scaler).div(FRAC_EXP_PRECISION);
232     }
233 }
