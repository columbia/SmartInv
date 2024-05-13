1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
9 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
10 import {SafeCast} from "@openzeppelin/contracts/utils/SafeCast.sol";
11 import {AppStorage, LibAppStorage} from "./LibAppStorage.sol";
12 import {LibSafeMath128} from "./LibSafeMath128.sol";
13 import {C} from "../C.sol";
14 import {LibUnripe} from "./LibUnripe.sol";
15 import {IWell} from "contracts/interfaces/basin/IWell.sol";
16 import {LibBarnRaise} from "./LibBarnRaise.sol";
17 import {LibDiamond} from "contracts/libraries/LibDiamond.sol";
18 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
19 import {LibWell} from "contracts/libraries/Well/LibWell.sol";
20 import {LibUsdOracle} from "contracts/libraries/Oracle/LibUsdOracle.sol";
21 
22 /**
23  * @author Publius
24  * @title Fertilizer
25  **/
26 
27 library LibFertilizer {
28     using SafeMath for uint256;
29     using LibSafeMath128 for uint128;
30     using SafeCast for uint256;
31     using SafeERC20 for IERC20;
32     using LibWell for address;
33 
34     event SetFertilizer(uint128 id, uint128 bpf);
35 
36     // 6 - 3
37     uint128 private constant PADDING = 1e3;
38     uint128 private constant DECIMALS = 1e6;
39     uint128 private constant REPLANT_SEASON = 6074;
40     uint128 private constant RESTART_HUMIDITY = 2500;
41     uint128 private constant END_DECREASE_SEASON = REPLANT_SEASON + 461;
42 
43     function addFertilizer(
44         uint128 season,
45         uint256 tokenAmountIn,
46         uint256 fertilizerAmount,
47         uint256 minLP
48     ) internal returns (uint128 id) {
49         AppStorage storage s = LibAppStorage.diamondStorage();
50 
51         uint128 fertilizerAmount128 = fertilizerAmount.toUint128();
52 
53         // Calculate Beans Per Fertilizer and add to total owed
54         uint128 bpf = getBpf(season);
55         s.unfertilizedIndex = s.unfertilizedIndex.add(
56             fertilizerAmount.mul(bpf)
57         );
58         // Get id
59         id = s.bpf.add(bpf);
60         // Update Total and Season supply
61         s.fertilizer[id] = s.fertilizer[id].add(fertilizerAmount128);
62         s.activeFertilizer = s.activeFertilizer.add(fertilizerAmount);
63         // Add underlying to Unripe Beans and Unripe LP
64         addUnderlying(tokenAmountIn, fertilizerAmount.mul(DECIMALS), minLP);
65         // If not first time adding Fertilizer with this id, return
66         if (s.fertilizer[id] > fertilizerAmount128) return id;
67         // If first time, log end Beans Per Fertilizer and add to Season queue.
68         push(id);
69         emit SetFertilizer(id, bpf);
70     }
71 
72     function getBpf(uint128 id) internal pure returns (uint128 bpf) {
73         bpf = getHumidity(id).add(1000).mul(PADDING);
74     }
75 
76     function getHumidity(uint128 id) internal pure returns (uint128 humidity) {
77         if (id == 0) return 5000;
78         if (id >= END_DECREASE_SEASON) return 200;
79         uint128 humidityDecrease = id.sub(REPLANT_SEASON).mul(5);
80         humidity = RESTART_HUMIDITY.sub(humidityDecrease);
81     }
82 
83     /**
84      * @dev Any token contributions should already be transferred to the Barn Raise Well to allow for a gas efficient liquidity
85      * addition through the use of `sync`. See {FertilizerFacet.mintFertilizer} for an example.
86      */
87     function addUnderlying(uint256 tokenAmountIn, uint256 usdAmount, uint256 minAmountOut) internal {
88         AppStorage storage s = LibAppStorage.diamondStorage();
89         // Calculate how many new Deposited Beans will be minted
90         uint256 percentToFill = usdAmount.mul(C.precision()).div(
91             remainingRecapitalization()
92         );
93 
94         uint256 newDepositedBeans;
95         if (C.unripeBean().totalSupply() > s.u[C.UNRIPE_BEAN].balanceOfUnderlying) {
96             newDepositedBeans = (C.unripeBean().totalSupply()).sub(
97                 s.u[C.UNRIPE_BEAN].balanceOfUnderlying
98             );
99             newDepositedBeans = newDepositedBeans.mul(percentToFill).div(
100                 C.precision()
101             );
102         }
103 
104         // Calculate how many Beans to add as LP
105         uint256 newDepositedLPBeans = usdAmount.mul(C.exploitAddLPRatio()).div(
106             DECIMALS
107         );
108 
109         // Mint the Deposited Beans to Beanstalk.
110         C.bean().mint(
111             address(this),
112             newDepositedBeans
113         );
114 
115         // Mint the LP Beans and add liquidity to the well.
116         address barnRaiseWell = LibBarnRaise.getBarnRaiseWell();
117         address barnRaiseToken = LibBarnRaise.getBarnRaiseToken();
118 
119         C.bean().mint(
120             address(this),
121             newDepositedLPBeans
122         );
123 
124         IERC20(barnRaiseToken).transferFrom(
125             msg.sender,
126             address(this),
127             uint256(tokenAmountIn)
128         );
129 
130         IERC20(barnRaiseToken).approve(barnRaiseWell, uint256(tokenAmountIn));
131         C.bean().approve(barnRaiseWell, newDepositedLPBeans);
132 
133         uint256[] memory tokenAmountsIn = new uint256[](2);
134         IERC20[] memory tokens = IWell(barnRaiseWell).tokens();
135         (tokenAmountsIn[0], tokenAmountsIn[1]) = tokens[0] == C.bean() ?
136             (newDepositedLPBeans, tokenAmountIn) :
137             (tokenAmountIn, newDepositedLPBeans);
138 
139         uint256 newLP = IWell(barnRaiseWell).addLiquidity(
140             tokenAmountsIn,
141             minAmountOut,
142             address(this),
143             type(uint256).max
144         );
145 
146         // Increment underlying balances of Unripe Tokens
147         LibUnripe.incrementUnderlying(C.UNRIPE_BEAN, newDepositedBeans);
148         LibUnripe.incrementUnderlying(C.UNRIPE_LP, newLP);
149 
150         s.recapitalized = s.recapitalized.add(usdAmount);
151     }
152 
153     function push(uint128 id) internal {
154         AppStorage storage s = LibAppStorage.diamondStorage();
155         if (s.fFirst == 0) {
156             // Queue is empty
157             s.season.fertilizing = true;
158             s.fLast = id;
159             s.fFirst = id;
160         } else if (id <= s.fFirst) {
161             // Add to front of queue
162             setNext(id, s.fFirst);
163             s.fFirst = id;
164         } else if (id >= s.fLast) {
165             // Add to back of queue
166             setNext(s.fLast, id);
167             s.fLast = id;
168         } else {
169             // Add to middle of queue
170             uint128 prev = s.fFirst;
171             uint128 next = getNext(prev);
172             // Search for proper place in line
173             while (id > next) {
174                 prev = next;
175                 next = getNext(next);
176             }
177             setNext(prev, id);
178             setNext(id, next);
179         }
180     }
181 
182     function remainingRecapitalization()
183         internal
184         view
185         returns (uint256 remaining)
186     {
187         AppStorage storage s = LibAppStorage.diamondStorage();
188         uint256 totalDollars = C
189             .dollarPerUnripeLP()
190             .mul(C.unripeLP().totalSupply())
191             .div(DECIMALS);
192         totalDollars = totalDollars / 1e6 * 1e6; // round down to nearest USDC
193         if (s.recapitalized >= totalDollars) return 0;
194         return totalDollars.sub(s.recapitalized);
195     }
196 
197     function pop() internal returns (bool) {
198         AppStorage storage s = LibAppStorage.diamondStorage();
199         uint128 first = s.fFirst;
200         s.activeFertilizer = s.activeFertilizer.sub(getAmount(first));
201         uint128 next = getNext(first);
202         if (next == 0) {
203             // If all Unfertilized Beans have been fertilized, delete line.
204             require(s.activeFertilizer == 0, "Still active fertilizer");
205             s.fFirst = 0;
206             s.fLast = 0;
207             s.season.fertilizing = false;
208             return false;
209         }
210         s.fFirst = getNext(first);
211         return true;
212     }
213 
214     function getAmount(uint128 id) internal view returns (uint256) {
215         AppStorage storage s = LibAppStorage.diamondStorage();
216         return s.fertilizer[id];
217     }
218 
219     function getNext(uint128 id) internal view returns (uint128) {
220         AppStorage storage s = LibAppStorage.diamondStorage();
221         return s.nextFid[id];
222     }
223 
224     function setNext(uint128 id, uint128 next) internal {
225         AppStorage storage s = LibAppStorage.diamondStorage();
226         s.nextFid[id] = next;
227     }
228 
229     function beginBarnRaiseMigration(address well) internal {
230         AppStorage storage s = LibAppStorage.diamondStorage();
231         require(well.isWell(), "Fertilizer: Not a Whitelisted Well.");
232 
233         // The Barn Raise only supports 2 token Wells where 1 token is Bean and the
234         // other is supported by the Lib Usd Oracle.
235         IERC20[] memory tokens = IWell(well).tokens();
236         require(tokens.length == 2, "Fertilizer: Well must have 2 tokens.");
237         require(
238             tokens[0] == C.bean() || tokens[1] == C.bean(),
239             "Fertilizer: Well must have BEAN."
240         );
241         // Check that Lib Usd Oracle supports the non-Bean token in the Well.
242         LibUsdOracle.getTokenPrice(address(tokens[tokens[0] == C.bean() ? 1 : 0]));
243 
244         uint256 balanceOfUnderlying = s.u[C.UNRIPE_LP].balanceOfUnderlying;
245         IERC20(s.u[C.UNRIPE_LP].underlyingToken).safeTransfer(
246             LibDiamond.diamondStorage().contractOwner,
247             balanceOfUnderlying
248         );
249         LibUnripe.decrementUnderlying(C.UNRIPE_LP, balanceOfUnderlying);
250         LibUnripe.switchUnderlyingToken(C.UNRIPE_LP, well);
251     }
252 }
