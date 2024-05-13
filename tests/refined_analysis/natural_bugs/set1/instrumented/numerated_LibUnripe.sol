1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
8 import {IBean} from "../interfaces/IBean.sol";
9 import {AppStorage, LibAppStorage} from "./LibAppStorage.sol";
10 import {C} from "../C.sol";
11 import {LibWell} from "./Well/LibWell.sol";
12 import {Call, IWell} from "contracts/interfaces/basin/IWell.sol";
13 import {IWellFunction} from "contracts/interfaces/basin/IWellFunction.sol";
14 import {LibLockedUnderlying} from "./LibLockedUnderlying.sol";
15 
16 /**
17  * @title LibUnripe
18  * @author Publius
19  * @notice Library for handling functionality related to Unripe Tokens and their Ripe Tokens.
20  */
21 library LibUnripe {
22     using SafeMath for uint256;
23 
24     event ChangeUnderlying(address indexed token, int256 underlying);
25     event SwitchUnderlyingToken(address indexed token, address indexed underlyingToken);
26 
27     uint256 constant DECIMALS = 1e6;
28 
29     /**
30      * @notice Returns the percentage that Unripe Beans have been recapitalized.
31      */
32     function percentBeansRecapped() internal view returns (uint256 percent) {
33         AppStorage storage s = LibAppStorage.diamondStorage();
34         return
35             s.u[C.UNRIPE_BEAN].balanceOfUnderlying.mul(DECIMALS).div(C.unripeBean().totalSupply());
36     }
37 
38     /**
39      * @notice Returns the percentage that Unripe LP have been recapitalized.
40      */
41     function percentLPRecapped() internal view returns (uint256 percent) {
42         AppStorage storage s = LibAppStorage.diamondStorage();
43         return C.unripeLPPerDollar().mul(s.recapitalized).div(C.unripeLP().totalSupply());
44     }
45 
46     /**
47      * @notice Increments the underlying balance of an Unripe Token.
48      * @param token The address of the unripe token.
49      * @param amount The amount of the of the unripe token to be added to the storage reserves
50      */
51     function incrementUnderlying(address token, uint256 amount) internal {
52         AppStorage storage s = LibAppStorage.diamondStorage();
53         s.u[token].balanceOfUnderlying = s.u[token].balanceOfUnderlying.add(amount);
54         emit ChangeUnderlying(token, int256(amount));
55     }
56 
57     /**
58      * @notice Decrements the underlying balance of an Unripe Token.
59      * @param token The address of the Unripe Token.
60      * @param amount The amount of the of the Unripe Token to be removed from storage reserves
61      */
62     function decrementUnderlying(address token, uint256 amount) internal {
63         AppStorage storage s = LibAppStorage.diamondStorage();
64         s.u[token].balanceOfUnderlying = s.u[token].balanceOfUnderlying.sub(amount);
65         emit ChangeUnderlying(token, -int256(amount));
66     }
67 
68     /**
69      * @notice Calculates the amount of Ripe Tokens that underly a given amount of Unripe Tokens.
70      * @param unripeToken The address of the Unripe Token
71      * @param unripe The amount of Unripe Tokens.
72      * @return underlying The amount of Ripe Tokens that underly the Unripe Tokens.
73      */
74     function unripeToUnderlying(
75         address unripeToken,
76         uint256 unripe,
77         uint256 supply
78     ) internal view returns (uint256 underlying) {
79         AppStorage storage s = LibAppStorage.diamondStorage();
80         underlying = s.u[unripeToken].balanceOfUnderlying.mul(unripe).div(supply);
81     }
82 
83     /**
84      * @notice Calculates the amount of Unripe Tokens that are underlaid by a given amount of Ripe Tokens.
85      * @param unripeToken The address of the Unripe Tokens.
86      * @param underlying The amount of Ripe Tokens.
87      * @return unripe The amount of the of the Unripe Tokens that are underlaid by the Ripe Tokens.
88      */
89     function underlyingToUnripe(
90         address unripeToken,
91         uint256 underlying
92     ) internal view returns (uint256 unripe) {
93         AppStorage storage s = LibAppStorage.diamondStorage();
94         unripe = IBean(unripeToken).totalSupply().mul(underlying).div(
95             s.u[unripeToken].balanceOfUnderlying
96         );
97     }
98 
99     /**
100      * @notice Adds Ripe Tokens to an Unripe Token. Also, increments the recapitalized
101      * amount proportionally if the Unripe Token is Unripe LP.
102      * @param token The address of the Unripe Token to add Ripe Tokens to.
103      * @param underlying The amount of the of the underlying token to be taken as input.
104      */
105     function addUnderlying(address token, uint256 underlying) internal {
106         AppStorage storage s = LibAppStorage.diamondStorage();
107         if (token == C.UNRIPE_LP) {
108             uint256 recapped = underlying.mul(s.recapitalized).div(
109                 s.u[C.UNRIPE_LP].balanceOfUnderlying
110             );
111             s.recapitalized = s.recapitalized.add(recapped);
112         }
113         incrementUnderlying(token, underlying);
114     }
115 
116     /**
117      * @notice Removes Ripe Tokens from an Unripe Token. Also, decrements the recapitalized
118      * amount proportionally if the Unripe Token is Unripe LP.
119      * @param token The address of the unripe token to be removed.
120      * @param underlying The amount of the of the underlying token to be removed.
121      */
122     function removeUnderlying(address token, uint256 underlying) internal {
123         AppStorage storage s = LibAppStorage.diamondStorage();
124         if (token == C.UNRIPE_LP) {
125             uint256 recapped = underlying.mul(s.recapitalized).div(
126                 s.u[C.UNRIPE_LP].balanceOfUnderlying
127             );
128             s.recapitalized = s.recapitalized.sub(recapped);
129         }
130         decrementUnderlying(token, underlying);
131     }
132 
133     /**
134      * @dev Switches the underlying token of an unripe token.
135      * Should only be called if `s.u[unripeToken].balanceOfUnderlying == 0`.
136      */
137     function switchUnderlyingToken(address unripeToken, address newUnderlyingToken) internal {
138         AppStorage storage s = LibAppStorage.diamondStorage();
139         s.u[unripeToken].underlyingToken = newUnderlyingToken;
140         emit SwitchUnderlyingToken(unripeToken, newUnderlyingToken);
141     }
142 
143     function _getPenalizedUnderlying(
144         address unripeToken,
145         uint256 amount,
146         uint256 supply
147     ) internal view returns (uint256 redeem) {
148         require(isUnripe(unripeToken), "not vesting");
149         uint256 sharesBeingRedeemed = getRecapPaidPercentAmount(amount);
150         redeem = _getUnderlying(unripeToken, sharesBeingRedeemed, supply);
151     }
152 
153     /**
154      * @notice Calculates the the amount of Ripe Tokens that would be paid out if
155      * all Unripe Tokens were Chopped at the current Chop Rate.
156      */
157     function _getTotalPenalizedUnderlying(
158         address unripeToken
159     ) internal view returns (uint256 redeem) {
160         require(isUnripe(unripeToken), "not vesting");
161         uint256 supply = IERC20(unripeToken).totalSupply();
162         redeem = _getUnderlying(unripeToken, getRecapPaidPercentAmount(supply), supply);
163     }
164 
165     /**
166      * @notice Returns the amount of beans that are locked in the unripe token.
167      * @dev Locked beans are the beans that are forfeited if the unripe token is chopped.
168      * @param reserves the reserves of the LP that underly the unripe token.
169      * @dev reserves are used as a parameter for gas effiency purposes (see LibEvaluate.calcLPToSupplyRatio}.
170      */
171     function getLockedBeans(
172         uint256[] memory reserves
173     ) internal view returns (uint256 lockedAmount) {
174         lockedAmount = LibLockedUnderlying
175             .getLockedUnderlying(C.UNRIPE_BEAN, getRecapPaidPercentAmount(1e6))
176             .add(getLockedBeansFromLP(reserves));
177     }
178 
179     /**
180      * @notice Returns the amount of beans that are locked in the unripeLP token.
181      * @param reserves the reserves of the LP that underly the unripe token.
182      */
183     function getLockedBeansFromLP(
184         uint256[] memory reserves
185     ) internal view returns (uint256 lockedBeanAmount) {
186         AppStorage storage s = LibAppStorage.diamondStorage();
187         
188         // if reserves return 0, then skip calculations.
189         if (reserves[0] == 0) return 0;
190         
191         uint256 lockedLpAmount = LibLockedUnderlying.getLockedUnderlying(
192             C.UNRIPE_LP,
193             getRecapPaidPercentAmount(1e6)
194         );
195         address underlying = s.u[C.UNRIPE_LP].underlyingToken;
196         uint256 beanIndex = LibWell.getBeanIndexFromWell(underlying);
197 
198         // lpTokenSupply is calculated rather than calling totalSupply(),
199         // because the Well's lpTokenSupply is not MEV resistant.
200         Call memory wellFunction = IWell(underlying).wellFunction();
201         uint lpTokenSupply = IWellFunction(wellFunction.target).calcLpTokenSupply(
202             reserves,
203             wellFunction.data
204         );
205         lockedBeanAmount = lockedLpAmount.mul(reserves[beanIndex]).div(lpTokenSupply);
206     }
207 
208     /**
209      * @notice Calculates the penalized amount based the amount of Sprouts that are Rinsable
210      * or Rinsed (Fertilized).
211      * @param amount The amount of the Unripe Tokens.
212      * @return penalizedAmount The penalized amount of the Ripe Tokens received from Chopping.
213      */
214     function getRecapPaidPercentAmount(
215         uint256 amount
216     ) internal view returns (uint256 penalizedAmount) {
217         AppStorage storage s = LibAppStorage.diamondStorage();
218         return s.fertilizedIndex.mul(amount).div(s.unfertilizedIndex);
219     }
220 
221     /**
222      * @notice Returns true if the token is unripe.
223      */
224     function isUnripe(address unripeToken) internal view returns (bool unripe) {
225         AppStorage storage s = LibAppStorage.diamondStorage();
226         unripe = s.u[unripeToken].underlyingToken != address(0);
227     }
228 
229     /**
230      * @notice Returns the underlying token amount of the unripe token.
231      */
232     function _getUnderlying(
233         address unripeToken,
234         uint256 amount,
235         uint256 supply
236     ) internal view returns (uint256 redeem) {
237         AppStorage storage s = LibAppStorage.diamondStorage();
238         redeem = s.u[unripeToken].balanceOfUnderlying.mul(amount).div(supply);
239     }
240 }
