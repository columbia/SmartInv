1 // File: contracts/interfaces/marketManagerInterface.sol
2 
3 pragma solidity 0.6.12;
4 
5 interface marketManagerInterface  {
6 	function setBreakerTable(address _target, bool _status) external returns (bool);
7 
8 	function getCircuitBreaker() external view returns (bool);
9 	function setCircuitBreaker(bool _emergency) external returns (bool);
10 
11 	function getTokenHandlerInfo(uint256 handlerID) external view returns (bool, address, string memory);
12 
13 	function handlerRegister(uint256 handlerID, address tokenHandlerAddr) external returns (bool);
14 
15 	function applyInterestHandlers(address payable userAddr, uint256 callerID, bool allFlag) external returns (uint256, uint256, uint256, uint256, uint256, uint256);
16 
17 	function getTokenHandlerPrice(uint256 handlerID) external view returns (uint256);
18 	function getTokenHandlerBorrowLimit(uint256 handlerID) external view returns (uint256);
19 	function getTokenHandlerSupport(uint256 handlerID) external view returns (bool);
20 
21 	function getTokenHandlersLength() external view returns (uint256);
22 	function setTokenHandlersLength(uint256 _tokenHandlerLength) external returns (bool);
23 
24 	function getTokenHandlerID(uint256 index) external view returns (uint256);
25 	function getTokenHandlerMarginCallLimit(uint256 handlerID) external view returns (uint256);
26 
27 	function getUserIntraHandlerAssetWithInterest(address payable userAddr, uint256 handlerID) external view returns (uint256, uint256);
28 
29 	function getUserTotalIntraCreditAsset(address payable userAddr) external view returns (uint256, uint256);
30 
31 	function getUserLimitIntraAsset(address payable userAddr) external view returns (uint256, uint256);
32 
33 	function getUserCollateralizableAmount(address payable userAddr, uint256 handlerID) external view returns (uint256);
34 
35 	function getUserExtraLiquidityAmount(address payable userAddr, uint256 handlerID) external view returns (uint256);
36 	function partialLiquidationUser(address payable delinquentBorrower, uint256 liquidateAmount, address payable liquidator, uint256 liquidateHandlerID, uint256 rewardHandlerID) external returns (uint256, uint256, uint256);
37 
38 	function getMaxLiquidationReward(address payable delinquentBorrower, uint256 liquidateHandlerID, uint256 liquidateAmount, uint256 rewardHandlerID, uint256 rewardRatio) external view returns (uint256);
39 	function partialLiquidationUserReward(address payable delinquentBorrower, uint256 rewardAmount, address payable liquidator, uint256 handlerID) external returns (uint256);
40 
41 	function setLiquidationManager(address liquidationManagerAddr) external returns (bool);
42 
43 	function rewardClaimAll(address payable userAddr) external returns (bool);
44 
45 	function updateRewardParams(address payable userAddr) external returns (bool);
46 	function interestUpdateReward() external returns (bool);
47 	function getGlobalRewardInfo() external view returns (uint256, uint256, uint256);
48 
49 	function setOracleProxy(address oracleProxyAddr) external returns (bool);
50 
51 	function rewardUpdateOfInAction(address payable userAddr, uint256 callerID) external returns (bool);
52 	function ownerRewardTransfer(uint256 _amount) external returns (bool);
53 }
54 
55 // File: contracts/interfaces/interestModelInterface.sol
56 
57 pragma solidity 0.6.12;
58 
59 interface interestModelInterface {
60 	function getInterestAmount(address handlerDataStorageAddr, address payable userAddr, bool isView) external view returns (bool, uint256, uint256, bool, uint256, uint256);
61 	function viewInterestAmount(address handlerDataStorageAddr, address payable userAddr) external view returns (bool, uint256, uint256, bool, uint256, uint256);
62 	function getSIRandBIR(address handlerDataStorageAddr, uint256 depositTotalAmount, uint256 borrowTotalAmount) external view returns (uint256, uint256);
63 }
64 
65 // File: contracts/interfaces/marketHandlerDataStorageInterface.sol
66 
67 pragma solidity 0.6.12;
68 
69 interface marketHandlerDataStorageInterface  {
70 	function setCircuitBreaker(bool _emergency) external returns (bool);
71 
72 	function setNewCustomer(address payable userAddr) external returns (bool);
73 
74 	function getUserAccessed(address payable userAddr) external view returns (bool);
75 	function setUserAccessed(address payable userAddr, bool _accessed) external returns (bool);
76 
77 	function getReservedAddr() external view returns (address payable);
78 	function setReservedAddr(address payable reservedAddress) external returns (bool);
79 
80 	function getReservedAmount() external view returns (int256);
81 	function addReservedAmount(uint256 amount) external returns (int256);
82 	function subReservedAmount(uint256 amount) external returns (int256);
83 	function updateSignedReservedAmount(int256 amount) external returns (int256);
84 
85 	function setTokenHandler(address _marketHandlerAddr, address _interestModelAddr) external returns (bool);
86 	function setCoinHandler(address _marketHandlerAddr, address _interestModelAddr) external returns (bool);
87 
88 	function getDepositTotalAmount() external view returns (uint256);
89 	function addDepositTotalAmount(uint256 amount) external returns (uint256);
90 	function subDepositTotalAmount(uint256 amount) external returns (uint256);
91 
92 	function getBorrowTotalAmount() external view returns (uint256);
93 	function addBorrowTotalAmount(uint256 amount) external returns (uint256);
94 	function subBorrowTotalAmount(uint256 amount) external returns (uint256);
95 
96 	function getUserIntraDepositAmount(address payable userAddr) external view returns (uint256);
97 	function addUserIntraDepositAmount(address payable userAddr, uint256 amount) external returns (uint256);
98 	function subUserIntraDepositAmount(address payable userAddr, uint256 amount) external returns (uint256);
99 
100 	function getUserIntraBorrowAmount(address payable userAddr) external view returns (uint256);
101 	function addUserIntraBorrowAmount(address payable userAddr, uint256 amount) external returns (uint256);
102 	function subUserIntraBorrowAmount(address payable userAddr, uint256 amount) external returns (uint256);
103 
104 	function addDepositAmount(address payable userAddr, uint256 amount) external returns (bool);
105 	function subDepositAmount(address payable userAddr, uint256 amount) external returns (bool);
106 
107 	function addBorrowAmount(address payable userAddr, uint256 amount) external returns (bool);
108 	function subBorrowAmount(address payable userAddr, uint256 amount) external returns (bool);
109 
110 	function getUserAmount(address payable userAddr) external view returns (uint256, uint256);
111 	function getHandlerAmount() external view returns (uint256, uint256);
112 
113 	function getAmount(address payable userAddr) external view returns (uint256, uint256, uint256, uint256);
114 	function setAmount(address payable userAddr, uint256 depositTotalAmount, uint256 borrowTotalAmount, uint256 depositAmount, uint256 borrowAmount) external returns (uint256);
115 
116 	function setBlocks(uint256 lastUpdatedBlock, uint256 inactiveActionDelta) external returns (bool);
117 
118 	function getLastUpdatedBlock() external view returns (uint256);
119 	function setLastUpdatedBlock(uint256 _lastUpdatedBlock) external returns (bool);
120 
121 	function getInactiveActionDelta() external view returns (uint256);
122 	function setInactiveActionDelta(uint256 inactiveActionDelta) external returns (bool);
123 
124 	function syncActionEXR() external returns (bool);
125 
126 	function getActionEXR() external view returns (uint256, uint256);
127 	function setActionEXR(uint256 actionDepositExRate, uint256 actionBorrowExRate) external returns (bool);
128 
129 	function getGlobalDepositEXR() external view returns (uint256);
130 	function getGlobalBorrowEXR() external view returns (uint256);
131 
132 	function setEXR(address payable userAddr, uint256 globalDepositEXR, uint256 globalBorrowEXR) external returns (bool);
133 
134 	function getUserEXR(address payable userAddr) external view returns (uint256, uint256);
135 	function setUserEXR(address payable userAddr, uint256 depositEXR, uint256 borrowEXR) external returns (bool);
136 
137 	function getGlobalEXR() external view returns (uint256, uint256);
138 
139 	function getMarketHandlerAddr() external view returns (address);
140 	function setMarketHandlerAddr(address marketHandlerAddr) external returns (bool);
141 
142 	function getInterestModelAddr() external view returns (address);
143 	function setInterestModelAddr(address interestModelAddr) external returns (bool);
144 
145 
146 	function getMinimumInterestRate() external view returns (uint256);
147 	function setMinimumInterestRate(uint256 _minimumInterestRate) external returns (bool);
148 
149 	function getLiquiditySensitivity() external view returns (uint256);
150 	function setLiquiditySensitivity(uint256 _liquiditySensitivity) external returns (bool);
151 
152 	function getLimit() external view returns (uint256, uint256);
153 
154 	function getBorrowLimit() external view returns (uint256);
155 	function setBorrowLimit(uint256 _borrowLimit) external returns (bool);
156 
157 	function getMarginCallLimit() external view returns (uint256);
158 	function setMarginCallLimit(uint256 _marginCallLimit) external returns (bool);
159 
160 	function getLimitOfAction() external view returns (uint256);
161 	function setLimitOfAction(uint256 limitOfAction) external returns (bool);
162 
163 	function getLiquidityLimit() external view returns (uint256);
164 	function setLiquidityLimit(uint256 liquidityLimit) external returns (bool);
165 }
166 
167 // File: contracts/interfaces/tokenInterface.sol
168 
169 pragma solidity 0.6.12;
170 
171 interface IERC20 {
172     function totalSupply() external view returns (uint256);
173     function balanceOf(address account) external view returns (uint256);
174     function transfer(address recipient, uint256 amount) external ;
175     function allowance(address owner, address spender) external view returns (uint256);
176     function approve(address spender, uint256 amount) external view returns (bool);
177     function transferFrom(address from, address to, uint256 value) external ;
178 }
179 
180 // File: contracts/interfaces/marketSIHandlerDataStorageInterface.sol
181 
182 pragma solidity 0.6.12;
183 
184 interface marketSIHandlerDataStorageInterface  {
185 	function setCircuitBreaker(bool _emergency) external returns (bool);
186 
187 	function updateRewardPerBlockStorage(uint256 _rewardPerBlock) external returns (bool);
188 
189 	function getRewardInfo(address userAddr) external view returns (uint256, uint256, uint256, uint256, uint256, uint256);
190 
191 	function getMarketRewardInfo() external view returns (uint256, uint256, uint256);
192 	function setMarketRewardInfo(uint256 _rewardLane, uint256 _rewardLaneUpdateAt, uint256 _rewardPerBlock) external returns (bool);
193 
194 	function getUserRewardInfo(address userAddr) external view returns (uint256, uint256, uint256);
195 	function setUserRewardInfo(address userAddr, uint256 _rewardLane, uint256 _rewardLaneUpdateAt, uint256 _rewardAmount) external returns (bool);
196 
197 	function getBetaRate() external view returns (uint256);
198 	function setBetaRate(uint256 _betaRate) external returns (bool);
199 }
200 
201 // File: contracts/Errors.sol
202 
203 pragma solidity 0.6.12;
204 
205 contract Modifier {
206     string internal constant ONLY_OWNER = "O";
207     string internal constant ONLY_MANAGER = "M";
208     string internal constant CIRCUIT_BREAKER = "emergency";
209 }
210 
211 contract ManagerModifier is Modifier {
212     string internal constant ONLY_HANDLER = "H";
213     string internal constant ONLY_LIQUIDATION_MANAGER = "LM";
214     string internal constant ONLY_BREAKER = "B";
215 }
216 
217 contract HandlerDataStorageModifier is Modifier {
218     string internal constant ONLY_BIFI_CONTRACT = "BF";
219 }
220 
221 contract SIDataStorageModifier is Modifier {
222     string internal constant ONLY_SI_HANDLER = "SI";
223 }
224 
225 contract HandlerErrors is Modifier {
226     string internal constant USE_VAULE = "use value";
227     string internal constant USE_ARG = "use arg";
228     string internal constant EXCEED_LIMIT = "exceed limit";
229     string internal constant NO_LIQUIDATION = "no liquidation";
230     string internal constant NO_LIQUIDATION_REWARD = "no enough reward";
231     string internal constant NO_EFFECTIVE_BALANCE = "not enough balance";
232     string internal constant TRANSFER = "err transfer";
233 }
234 
235 contract SIErrors is Modifier { }
236 
237 contract InterestErrors is Modifier { }
238 
239 contract LiquidationManagerErrors is Modifier {
240     string internal constant NO_DELINQUENT = "not delinquent";
241 }
242 
243 contract ManagerErrors is ManagerModifier {
244     string internal constant REWARD_TRANSFER = "RT";
245     string internal constant UNSUPPORTED_TOKEN = "UT";
246 }
247 
248 contract OracleProxyErrors is Modifier {
249     string internal constant ZERO_PRICE = "price zero";
250 }
251 
252 contract RequestProxyErrors is Modifier { }
253 
254 contract ManagerDataStorageErrors is ManagerModifier {
255     string internal constant NULL_ADDRESS = "err addr null";
256 }
257 
258 // File: contracts/reqTokenProxy.sol
259 
260 pragma solidity 0.6.12;
261 
262 /**
263  * @title Bifi user request proxy (ERC-20 token)
264  * @notice access logic contracts via delegate calls.
265  * @author Bifi
266  */
267 contract tokenProxy is RequestProxyErrors {
268 	address payable owner;
269 
270 	uint256 handlerID;
271 
272 	string tokenName;
273 
274 	uint256 constant unifiedPoint = 10 ** 18;
275 
276 	uint256 unifiedTokenDecimal = 10 ** 18;
277 
278 	uint256 underlyingTokenDecimal;
279 
280 	marketManagerInterface marketManager;
281 
282 	interestModelInterface interestModelInstance;
283 
284 	marketHandlerDataStorageInterface handlerDataStorage;
285 
286 	marketSIHandlerDataStorageInterface SIHandlerDataStorage;
287 
288 	IERC20 erc20Instance;
289 
290 	address public handler;
291 
292 	address public SI;
293 
294 	string DEPOSIT = "deposit(uint256,bool)";
295 
296 	string REDEEM = "withdraw(uint256,bool)";
297 
298 	string BORROW = "borrow(uint256,bool)";
299 
300 	string REPAY = "repay(uint256,bool)";
301 
302 	modifier onlyOwner {
303 		require(msg.sender == owner, ONLY_OWNER);
304 		_;
305 	}
306 
307 	modifier onlyMarketManager {
308 		address msgSender = msg.sender;
309 		require((msgSender == address(marketManager)) || (msgSender == owner), ONLY_MANAGER);
310 		_;
311 	}
312 
313 	/**
314 	* @dev Construct a new TokenProxy which uses tokenHandlerLogic
315 	*/
316 	constructor () public
317 	{
318 		owner = msg.sender;
319 	}
320 
321 	/**
322 	* @dev Replace the owner of the handler
323 	* @param _owner the address of the new owner
324 	* @return true (TODO: validate results)
325 	*/
326 	function ownershipTransfer(address _owner) onlyOwner external returns (bool)
327 	{
328 		owner = address(uint160(_owner));
329 		return true;
330 	}
331 
332 	/**
333 	* @dev Initialize the contract
334 	* @param _handlerID ID of handler
335 	* @param marketManagerAddr The address of market manager
336 	* @param interestModelAddr The address of handler interest model contract address
337 	* @param marketDataStorageAddr The address of handler data storage
338 	* @param erc20Addr The address of target ERC-20 token (underlying asset)
339 	* @param _tokenName The name of target ERC-20 token
340 	* @param siHandlerAddr The address of service incentive contract
341 	* @param SIHandlerDataStorageAddr The address of service incentive data storage
342 	*/
343 	function initialize(uint256 _handlerID, address handlerAddr, address marketManagerAddr, address interestModelAddr, address marketDataStorageAddr, address erc20Addr, string memory _tokenName, address siHandlerAddr, address SIHandlerDataStorageAddr) onlyOwner public returns (bool)
344 	{
345 		handlerID = _handlerID;
346 		handler = handlerAddr;
347 		marketManager = marketManagerInterface(marketManagerAddr);
348 		interestModelInstance = interestModelInterface(interestModelAddr);
349 		handlerDataStorage = marketHandlerDataStorageInterface(marketDataStorageAddr);
350 		erc20Instance = IERC20(erc20Addr);
351 		tokenName = _tokenName;
352 		SI = siHandlerAddr;
353 		SIHandlerDataStorage = marketSIHandlerDataStorageInterface(SIHandlerDataStorageAddr);
354 	}
355 
356 	/**
357 	* @dev Set ID of handler
358 	* @param _handlerID The id of handler
359 	* @return true (TODO: validate results)
360 	*/
361 	function setHandlerID(uint256 _handlerID) onlyOwner public returns (bool)
362 	{
363 		handlerID = _handlerID;
364 		return true;
365 	}
366 
367 	/**
368 	* @dev Set the address of handler
369 	* @param handlerAddr The address of handler
370 	* @return true (TODO: validate results)
371 	*/
372 	function setHandlerAddr(address handlerAddr) onlyOwner public returns (bool)
373 	{
374 		handler = handlerAddr;
375 		return true;
376 	}
377 
378 	/**
379 	* @dev Set the address of service incentive contract
380 	* @param siHandlerAddr The address of service incentive contract
381 	* @return true (TODO: validate results)
382 	*/
383 	function setSiHandlerAddr(address siHandlerAddr) onlyOwner public returns (bool)
384 	{
385 		SI = siHandlerAddr;
386 		return true;
387 	}
388 
389 	/**
390 	* @dev Get ID of handler
391 	* @return The connected handler ID
392 	*/
393 	function getHandlerID() public view returns (uint256)
394 	{
395 		return handlerID;
396 	}
397 
398 	/**
399 	* @dev Get the address of handler
400 	* @return The handler address
401 	*/
402 	function getHandlerAddr() public view returns (address)
403 	{
404 		return handler;
405 	}
406 
407 	/**
408 	* @dev Get address of service incentive contract
409 	* @return The service incentive contract address
410 	*/
411 	function getSiHandlerAddr() public view returns (address)
412 	{
413 		return SI;
414 	}
415 
416 	/**
417 	* @dev Move assets to sender for the migration event
418 	*/
419 	function migration(address target) onlyOwner public returns (bool)
420 	{
421 		uint256 balance = erc20Instance.balanceOf(address(this));
422 		erc20Instance.transfer(target, balance);
423 	}
424 
425 	/**
426 	* @dev Forward the deposit request for deposit to the handler logic contract.
427 	* @param unifiedTokenAmount The amount of coins to deposit
428 	* @param flag Flag for the full calcuation mode
429 	* @return whether the deposit has been made successfully or not.
430 	*/
431 	function deposit(uint256 unifiedTokenAmount, bool flag) public payable returns (bool)
432 	{
433 		bool result;
434 		bytes memory returnData;
435 		bytes memory data = abi.encodeWithSignature(DEPOSIT, unifiedTokenAmount, flag);
436 		(result, returnData) = handler.delegatecall(data);
437 		require(result, string(returnData));
438 		return result;
439 	}
440 
441 	/**
442 	* @dev Forward the withdraw request for withdraw to the handler logic contract.
443 	* @param unifiedTokenAmount The amount of coins to withdraw
444 	* @param flag Flag for the full calcuation mode
445 	* @return whether the withdraw has been made successfully or not.
446 	*/
447 	function withdraw(uint256 unifiedTokenAmount, bool flag) public returns (bool)
448 	{
449 		bool result;
450 		bytes memory returnData;
451 		bytes memory data = abi.encodeWithSignature(REDEEM, unifiedTokenAmount, flag);
452 		(result, returnData) = handler.delegatecall(data);
453 		require(result, string(returnData));
454 		return result;
455 	}
456 
457 	/**
458 	* @dev Forward the borrow request for borrow to the handler logic contract.
459 	* @param unifiedTokenAmount The amount of coins to borrow
460 	* @param flag Flag for the full calcuation mode
461 	* @return whether the borrow has been made successfully or not.
462 	*/
463 	function borrow(uint256 unifiedTokenAmount, bool flag) public returns (bool)
464 	{
465 		bool result;
466 		bytes memory returnData;
467 		bytes memory data = abi.encodeWithSignature(BORROW, unifiedTokenAmount, flag);
468 		(result, returnData) = handler.delegatecall(data);
469 		require(result, string(returnData));
470 		return result;
471 	}
472 
473 	/**
474 	* @dev Forward the repay request for repay to the handler logic contract.
475 	* @param unifiedTokenAmount The amount of coins to repay
476 	* @param flag Flag for the full calcuation mode
477 	* @return whether the repay has been made successfully or not.
478 	*/
479 	function repay(uint256 unifiedTokenAmount, bool flag) public payable returns (bool)
480 	{
481 		bool result;
482 		bytes memory returnData;
483 		bytes memory data = abi.encodeWithSignature(REPAY, unifiedTokenAmount, flag);
484 		(result, returnData) = handler.delegatecall(data);
485 		require(result, string(returnData));
486 		return result;
487 	}
488 
489 	/**
490 	* @dev Call other functions in handler logic contract.
491 	* @param data The encoded value of the function and argument
492 	* @return The result of the call
493 	*/
494 	function handlerProxy(bytes memory data) onlyMarketManager external returns (bool, bytes memory)
495 	{
496 		bool result;
497 		bytes memory returnData;
498 		(result, returnData) = handler.delegatecall(data);
499 		require(result, string(returnData));
500 		return (result, returnData);
501 	}
502 
503 	/**
504 	* @dev Call other view functions in handler logic contract.
505 	* (delegatecall does not work for view functions)
506 	* @param data The encoded value of the function and argument
507 	* @return The result of the call
508 	*/
509 	function handlerViewProxy(bytes memory data) external returns (bool, bytes memory)
510 	{
511 		bool result;
512 		bytes memory returnData;
513 		(result, returnData) = handler.delegatecall(data);
514 		require(result, string(returnData));
515 		return (result, returnData);
516 	}
517 
518 	/**
519 	* @dev Call other functions in service incentive logic contract.
520 	* @param data The encoded value of the function and argument
521 	* @return The result of the call
522 	*/
523 	function siProxy(bytes memory data) onlyMarketManager external returns (bool, bytes memory)
524 	{
525 		bool result;
526 		bytes memory returnData;
527 		(result, returnData) = SI.delegatecall(data);
528 		require(result, string(returnData));
529 		return (result, returnData);
530 	}
531 
532 	/**
533 	* @dev Call other view functions in service incentive logic contract.
534 	* (delegatecall does not work for view functions)
535 	* @param data The encoded value of the function and argument
536 	* @return The result of the call
537 	*/
538 	function siViewProxy(bytes memory data) external returns (bool, bytes memory)
539 	{
540 		bool result;
541 		bytes memory returnData;
542 		(result, returnData) = SI.delegatecall(data);
543 		require(result, string(returnData));
544 		return (result, returnData);
545 	}
546 }