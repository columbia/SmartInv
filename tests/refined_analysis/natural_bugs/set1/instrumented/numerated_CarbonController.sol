1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 import { CountersUpgradeable } from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
4 import { ReentrancyGuardUpgradeable } from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
5 import { PausableUpgradeable } from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
6 import { IVersioned } from "../utility/interfaces/IVersioned.sol";
7 import { Pools, Pool } from "./Pools.sol";
8 import { Token } from "../token/Token.sol";
9 import { TokenLibrary } from "../token/TokenLibrary.sol";
10 import { Strategies, Strategy, TradeAction, Order, TradeTokens } from "./Strategies.sol";
11 import { Upgradeable } from "../utility/Upgradeable.sol";
12 import { IVoucher } from "../voucher/interfaces/IVoucher.sol";
13 import { ICarbonController } from "./interfaces/ICarbonController.sol";
14 import { Utils, AccessDenied } from "../utility/Utils.sol";
15 import { OnlyProxyDelegate } from "../utility/OnlyProxyDelegate.sol";
16 import { MAX_GAP } from "../utility/Constants.sol";
17 
18 /**
19  * @dev Carbon Contrller contract
20  */
21 contract CarbonController is
22     ICarbonController,
23     Pools,
24     Strategies,
25     Upgradeable,
26     ReentrancyGuardUpgradeable,
27     PausableUpgradeable,
28     OnlyProxyDelegate,
29     Utils
30 {
31     using CountersUpgradeable for CountersUpgradeable.Counter;
32     using TokenLibrary for Token;
33 
34     // the emergency manager role is required to pause/unpause
35     bytes32 private constant ROLE_EMERGENCY_STOPPER = keccak256("ROLE_EMERGENCY_STOPPER");
36 
37     uint16 private constant CONTROLLER_TYPE = 1;
38 
39     // the voucher contract
40     IVoucher private immutable _voucher;
41 
42     // upgrade forward-compatibility storage gap
43     uint256[MAX_GAP] private __gap;
44 
45     error IdenticalAddresses();
46     error UnnecessaryNativeTokenReceived();
47     error InsufficientNativeTokenReceived();
48     error DeadlineExpired();
49     error InvalidTradeActionAmount();
50     error NoIdsProvided();
51 
52     /**
53      * @dev a "virtual" constructor that is only used to set immutable state variables
54      */
55     constructor(IVoucher initVoucher, address proxy) OnlyProxyDelegate(proxy) {
56         _validAddress(address(initVoucher));
57 
58         _voucher = initVoucher;
59     }
60 
61     /**
62      * @dev fully initializes the contract and its parents
63      */
64     function initialize() external initializer {
65         __CarbonController_init();
66     }
67 
68     // solhint-disable func-name-mixedcase
69 
70     /**
71      * @dev initializes the contract and its parents
72      */
73     function __CarbonController_init() internal onlyInitializing {
74         __Upgradeable_init();
75         __ReentrancyGuard_init();
76         __Pausable_init();
77         __Strategies_init();
78         __Pools_init();
79 
80         __CarbonController_init_unchained();
81     }
82 
83     /**
84      * @dev performs contract-specific initialization
85      */
86     function __CarbonController_init_unchained() internal onlyInitializing {
87         // set up administrative roles
88         _setRoleAdmin(ROLE_EMERGENCY_STOPPER, ROLE_ADMIN);
89     }
90 
91     // solhint-enable func-name-mixedcase
92 
93     /**
94      * @inheritdoc Upgradeable
95      */
96     function version() public pure override(IVersioned, Upgradeable) returns (uint16) {
97         return 2;
98     }
99 
100     /**
101      * @inheritdoc ICarbonController
102      */
103     function controllerType() external view virtual returns (uint16) {
104         return CONTROLLER_TYPE;
105     }
106 
107     /**
108      * @inheritdoc ICarbonController
109      */
110     function tradingFeePPM() external view returns (uint32) {
111         return _currentTradingFeePPM();
112     }
113 
114     /**
115      * @dev sets the trading fee (in units of PPM)
116      *
117      * requirements:
118      *
119      * - the caller must be the admin of the contract
120      */
121     function setTradingFeePPM(uint32 newTradingFeePPM) external onlyAdmin validFee(newTradingFeePPM) {
122         _setTradingFeePPM(newTradingFeePPM);
123     }
124 
125     /**
126      * @inheritdoc ICarbonController
127      */
128     function createPool(
129         Token token0,
130         Token token1
131     ) external nonReentrant whenNotPaused onlyProxyDelegate returns (Pool memory) {
132         _validateInputTokens(token0, token1);
133         return _createPool(token0, token1);
134     }
135 
136     /**
137      * @inheritdoc ICarbonController
138      */
139     function pairs() external view returns (Token[2][] memory) {
140         return _pairs();
141     }
142 
143     /**
144      * @inheritdoc ICarbonController
145      */
146     function pool(Token token0, Token token1) external view returns (Pool memory) {
147         _validateInputTokens(token0, token1);
148         return _pool(token0, token1);
149     }
150 
151     // solhint-disable var-name-mixedcase
152 
153     /**
154      * @inheritdoc ICarbonController
155      */
156     function createStrategy(
157         Token token0,
158         Token token1,
159         Order[2] calldata orders
160     ) external payable nonReentrant whenNotPaused onlyProxyDelegate returns (uint256) {
161         _validateInputTokens(token0, token1);
162 
163         // don't allow unnecessary eth
164         if (!token0.isNative() && !token1.isNative() && msg.value > 0) {
165             revert UnnecessaryNativeTokenReceived();
166         }
167 
168         // revert if any of the orders is invalid
169         _validateOrders(orders);
170 
171         // create the pool if it does not exist
172         Pool memory __pool;
173         if (!_poolExists(token0, token1)) {
174             __pool = _createPool(token0, token1);
175         } else {
176             __pool = _pool(token0, token1);
177         }
178 
179         Token[2] memory tokens = [token0, token1];
180         return _createStrategy(_voucher, tokens, orders, __pool, msg.sender, msg.value);
181     }
182 
183     /**
184      * @inheritdoc ICarbonController
185      */
186     function updateStrategy(
187         uint256 strategyId,
188         Order[2] calldata currentOrders,
189         Order[2] calldata newOrders
190     ) external payable nonReentrant whenNotPaused onlyProxyDelegate {
191         Pool memory __pool = _poolById(_poolIdbyStrategyId(strategyId));
192 
193         // only the owner of the strategy is allowed to delete it
194         if (msg.sender != _voucher.ownerOf(strategyId)) {
195             revert AccessDenied();
196         }
197 
198         // don't allow unnecessary eth
199         if (!__pool.tokens[0].isNative() && !__pool.tokens[1].isNative() && msg.value > 0) {
200             revert UnnecessaryNativeTokenReceived();
201         }
202 
203         // revert if any of the orders is invalid
204         _validateOrders(newOrders);
205 
206         // perform update
207         _updateStrategy(strategyId, __pool, currentOrders, newOrders, msg.value, msg.sender);
208     }
209 
210     // solhint-enable var-name-mixedcase
211 
212     /**
213      * @inheritdoc ICarbonController
214      */
215     function deleteStrategy(uint256 strategyId) external nonReentrant whenNotPaused onlyProxyDelegate {
216         // find strategy, reverts if none
217         Pool memory __pool = _poolById(_poolIdbyStrategyId(strategyId));
218         Strategy memory __strategy = _strategy(strategyId, _voucher, __pool);
219 
220         // only the owner of the strategy is allowed to delete it
221         if (msg.sender != _voucher.ownerOf(strategyId)) {
222             revert AccessDenied();
223         }
224 
225         // delete strategy
226         _deleteStrategy(__strategy, _voucher, __pool);
227     }
228 
229     /**
230      * @inheritdoc ICarbonController
231      */
232     function strategy(uint256 id) external view returns (Strategy memory) {
233         Pool memory __pool = _poolById(_poolIdbyStrategyId(id));
234         return _strategy(id, _voucher, __pool);
235     }
236 
237     /**
238      * @inheritdoc ICarbonController
239      */
240     function strategiesByPool(
241         Token token0,
242         Token token1,
243         uint256 startIndex,
244         uint256 endIndex
245     ) external view returns (Strategy[] memory) {
246         _validateInputTokens(token0, token1);
247 
248         Pool memory __pool = _pool(token0, token1);
249         return _strategiesByPool(__pool, startIndex, endIndex, _voucher);
250     }
251 
252     /**
253      * @inheritdoc ICarbonController
254      */
255     function strategiesByPoolCount(Token token0, Token token1) external view returns (uint256) {
256         _validateInputTokens(token0, token1);
257 
258         Pool memory __pool = _pool(token0, token1);
259         return _strategiesByPoolCount(__pool);
260     }
261 
262     /**
263      * @inheritdoc ICarbonController
264      */
265     function tradeBySourceAmount(
266         Token sourceToken,
267         Token targetToken,
268         TradeAction[] calldata tradeActions,
269         uint256 deadline,
270         uint128 minReturn
271     ) external payable nonReentrant whenNotPaused onlyProxyDelegate returns (uint128) {
272         _validateTradeParams(sourceToken, targetToken, deadline, msg.value, minReturn, tradeActions);
273         Pool memory _pool = _pool(sourceToken, targetToken);
274         TradeParams memory params = TradeParams({
275             trader: msg.sender,
276             tokens: TradeTokens({ source: sourceToken, target: targetToken }),
277             byTargetAmount: false,
278             constraint: minReturn,
279             txValue: msg.value,
280             pool: _pool
281         });
282         SourceAndTargetAmounts memory amounts = _trade(tradeActions, params);
283         return amounts.targetAmount;
284     }
285 
286     /**
287      * @inheritdoc ICarbonController
288      */
289     function tradeByTargetAmount(
290         Token sourceToken,
291         Token targetToken,
292         TradeAction[] calldata tradeActions,
293         uint256 deadline,
294         uint128 maxInput
295     ) external payable nonReentrant whenNotPaused onlyProxyDelegate returns (uint128) {
296         _validateTradeParams(sourceToken, targetToken, deadline, msg.value, maxInput, tradeActions);
297 
298         if (sourceToken.isNative()) {
299             // tx's value should at least match the maxInput
300             if (msg.value < maxInput) {
301                 revert InsufficientNativeTokenReceived();
302             }
303         }
304 
305         Pool memory _pool = _pool(sourceToken, targetToken);
306         TradeParams memory params = TradeParams({
307             trader: msg.sender,
308             tokens: TradeTokens({ source: sourceToken, target: targetToken }),
309             byTargetAmount: true,
310             constraint: maxInput,
311             txValue: msg.value,
312             pool: _pool
313         });
314         SourceAndTargetAmounts memory amounts = _trade(tradeActions, params);
315         return amounts.sourceAmount;
316     }
317 
318     /**
319      * @inheritdoc ICarbonController
320      */
321     function tradeSourceAmount(
322         Token sourceToken,
323         Token targetToken,
324         TradeAction[] calldata tradeActions
325     ) external view returns (uint128) {
326         _validateInputTokens(sourceToken, targetToken);
327         Pool memory __pool = _pool(sourceToken, targetToken);
328         TradeTokens memory tokens = TradeTokens({ source: sourceToken, target: targetToken });
329         SourceAndTargetAmounts memory amounts = _tradeSourceAndTargetAmounts(tokens, tradeActions, __pool, true);
330         return amounts.sourceAmount;
331     }
332 
333     /**
334      * @inheritdoc ICarbonController
335      */
336     function tradeTargetAmount(
337         Token sourceToken,
338         Token targetToken,
339         TradeAction[] calldata tradeActions
340     ) external view returns (uint128) {
341         _validateInputTokens(sourceToken, targetToken);
342         Pool memory __pool = _pool(sourceToken, targetToken);
343         TradeTokens memory tokens = TradeTokens({ source: sourceToken, target: targetToken });
344         SourceAndTargetAmounts memory amounts = _tradeSourceAndTargetAmounts(tokens, tradeActions, __pool, false);
345         return amounts.targetAmount;
346     }
347 
348     /**
349      * @inheritdoc ICarbonController
350      */
351     function accumulatedFees(address token) external view returns (uint256) {
352         _validAddress(token);
353         return _getAccumulatedFees(token);
354     }
355 
356     /**
357      * @dev pauses the CarbonController
358      *
359      * requirements:
360      *
361      * - the caller must have the ROLE_EMERGENCY_STOPPER privilege
362      */
363     function pause() external onlyRoleMember(ROLE_EMERGENCY_STOPPER) {
364         _pause();
365     }
366 
367     /**
368      * @dev resumes the CarbonController
369      *
370      * requirements:
371      *
372      * - the caller must have the ROLE_EMERGENCY_STOPPER privilege
373      */
374     function unpause() external onlyRoleMember(ROLE_EMERGENCY_STOPPER) {
375         _unpause();
376     }
377 
378     /**
379      * @dev returns the emergency stopper role
380      */
381     function roleEmergencyStopper() external pure returns (bytes32) {
382         return ROLE_EMERGENCY_STOPPER;
383     }
384 
385     /**
386      * @dev validates both tokens are valid addresses and unique
387      */
388     function _validateInputTokens(Token token0, Token token1) private pure {
389         _validAddress(address(token0));
390         _validAddress(address(token1));
391 
392         if (token0 == token1) {
393             revert IdenticalAddresses();
394         }
395     }
396 
397     /**
398      * performs all necessary valdations on the trade parameters
399      */
400     function _validateTradeParams(
401         Token sourceToken,
402         Token targetToken,
403         uint256 deadline,
404         uint256 value,
405         uint128 constraint,
406         TradeAction[] calldata tradeActions
407     ) private view {
408         // revert if deadline has passed
409         if (deadline < block.timestamp) {
410             revert DeadlineExpired();
411         }
412 
413         // validate minReturn / maxInput
414         _greaterThanZero(constraint);
415 
416         // make sure source and target tokens are valid
417         _validateInputTokens(sourceToken, targetToken);
418 
419         // there shouldn't be any native token sent unless the source token is the native token
420         if (!sourceToken.isNative() && value > 0) {
421             revert UnnecessaryNativeTokenReceived();
422         }
423 
424         // validate tradeActions
425         for (uint256 i = 0; i < tradeActions.length; i++) {
426             // make sure all tradeActions are provided with a positive amount
427             if (tradeActions[i].amount == 0) {
428                 revert InvalidTradeActionAmount();
429             }
430         }
431     }
432 }
