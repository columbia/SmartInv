1 // File: contracts/interfaces/ILiquidationManager.sol
2 pragma solidity 0.6.12;
3 
4 /**
5  * @title BiFi's liquidation manager interface
6  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
7  */
8 interface ILiquidationManager  {
9 	function setCircuitBreaker(bool _emergency) external returns (bool);
10 	function partialLiquidation(address payable delinquentBorrower, uint256 targetHandler, uint256 liquidateAmount, uint256 receiveHandler) external returns (uint256);
11 	function checkLiquidation(address payable userAddr) external view returns (bool);
12 }
13 
14 // File: contracts/interfaces/IManagerSlotSetter.sol
15 pragma solidity 0.6.12;
16 
17 /**
18  * @title BiFi's Manager Context Setter interface
19  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
20  */
21 interface IManagerSlotSetter  {
22   function ownershipTransfer(address payable _owner) external returns (bool);
23   function setOperator(address payable adminAddr, bool flag) external returns (bool);
24   function setOracleProxy(address oracleProxyAddr) external returns (bool);
25   function setRewardErc20(address erc20Addr) external returns (bool);
26   function setBreakerTable(address _target, bool _status) external returns (bool);
27   function setCircuitBreaker(bool _emergency) external returns (bool);
28   function handlerRegister(uint256 handlerID, address tokenHandlerAddr, uint256 flashFeeRate, uint256 discountBase) external returns (bool);
29   function setLiquidationManager(address liquidationManagerAddr) external returns (bool);
30   function setHandlerSupport(uint256 handlerID, bool support) external returns (bool);
31   function setPositionStorageAddr(address _positionStorageAddr) external returns (bool);
32   function setNFTAddr(address _nftAddr) external returns (bool);
33   function setDiscountBase(uint256 handlerID, uint256 feeBase) external returns (bool);
34   function setFlashloanAddr(address _flashloanAddr) external returns (bool);
35   function sethandlerManagerAddr(address _handlerManagerAddr) external returns (bool);
36   function setSlotSetterAddr(address _slotSetterAddr) external returns (bool);
37   function setFlashloanFee(uint256 handlerID, uint256 flashFeeRate) external returns (bool);
38 }
39 
40 // File: contracts/interfaces/IHandlerManager.sol
41 pragma solidity 0.6.12;
42 
43 /**
44  * @title BiFi's Manager Interest interface
45  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
46  */
47 interface IHandlerManager  {
48   function applyInterestHandlers(address payable userAddr, uint256 callerID, bool allFlag) external returns (uint256, uint256, uint256, uint256, uint256, uint256);
49   function interestUpdateReward() external returns (bool);
50   function updateRewardParams(address payable userAddr) external returns (bool);
51   function rewardClaimAll(address payable userAddr) external returns (uint256);
52   function claimHandlerReward(uint256 handlerID, address payable userAddr) external returns (uint256);
53   function ownerRewardTransfer(uint256 _amount) external returns (bool);
54 }
55 
56 // File: contracts/interfaces/IManagerFlashloan.sol
57 pragma solidity 0.6.12;
58 
59 interface IManagerFlashloan {
60   function withdrawFlashloanFee(uint256 handlerID) external returns (bool);
61 
62   function flashloan(
63     uint256 handlerID,
64     address receiverAddress,
65     uint256 amount,
66     bytes calldata params
67   ) external returns (bool);
68 
69   function getFee(uint256 handlerID, uint256 amount) external view returns (uint256);
70 
71   function getFeeTotal(uint256 handlerID) external view returns (uint256);
72 
73   function getFeeFromArguments(uint256 handlerID, uint256 amount, uint256 bifiAmo) external view returns (uint256);
74 }
75 
76 // File: contracts/SafeMath.sol
77 pragma solidity ^0.6.12;
78 
79 // from: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
80 // Subject to the MIT license.
81 
82 /**
83  * @title BiFi's safe-math Contract
84  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
85  */
86 library SafeMath {
87   uint256 internal constant unifiedPoint = 10 ** 18;
88 	/******************** Safe Math********************/
89 	function add(uint256 a, uint256 b) internal pure returns (uint256)
90 	{
91 		uint256 c = a + b;
92 		require(c >= a, "a");
93 		return c;
94 	}
95 
96 	function sub(uint256 a, uint256 b) internal pure returns (uint256)
97 	{
98 		return _sub(a, b, "s");
99 	}
100 
101 	function mul(uint256 a, uint256 b) internal pure returns (uint256)
102 	{
103 		return _mul(a, b);
104 	}
105 
106 	function div(uint256 a, uint256 b) internal pure returns (uint256)
107 	{
108 		return _div(a, b, "d");
109 	}
110 
111 	function _sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256)
112 	{
113 		require(b <= a, errorMessage);
114 		return a - b;
115 	}
116 
117 	function _mul(uint256 a, uint256 b) internal pure returns (uint256)
118 	{
119 		if (a == 0)
120 		{
121 			return 0;
122 		}
123 
124 		uint256 c = a* b;
125 		require((c / a) == b, "m");
126 		return c;
127 	}
128 
129 	function _div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256)
130 	{
131 		require(b > 0, errorMessage);
132 		return a / b;
133 	}
134 
135 	function unifiedDiv(uint256 a, uint256 b) internal pure returns (uint256)
136 	{
137 		return _div(_mul(a, unifiedPoint), b, "d");
138 	}
139 
140 	function unifiedMul(uint256 a, uint256 b) internal pure returns (uint256)
141 	{
142 		return _div(_mul(a, b), unifiedPoint, "m");
143 	}
144 }
145 
146 // File: contracts/interfaces/IManagerDataStorage.sol
147 pragma solidity 0.6.12;
148 
149 /**
150  * @title BiFi's manager data storage interface
151  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
152  */
153 interface IManagerDataStorage  {
154 	function getGlobalRewardPerBlock() external view returns (uint256);
155 	function setGlobalRewardPerBlock(uint256 _globalRewardPerBlock) external returns (bool);
156 
157 	function getGlobalRewardDecrement() external view returns (uint256);
158 	function setGlobalRewardDecrement(uint256 _globalRewardDecrement) external returns (bool);
159 
160 	function getGlobalRewardTotalAmount() external view returns (uint256);
161 	function setGlobalRewardTotalAmount(uint256 _globalRewardTotalAmount) external returns (bool);
162 
163 	function getAlphaRate() external view returns (uint256);
164 	function setAlphaRate(uint256 _alphaRate) external returns (bool);
165 
166 	function getAlphaLastUpdated() external view returns (uint256);
167 	function setAlphaLastUpdated(uint256 _alphaLastUpdated) external returns (bool);
168 
169 	function getRewardParamUpdateRewardPerBlock() external view returns (uint256);
170 	function setRewardParamUpdateRewardPerBlock(uint256 _rewardParamUpdateRewardPerBlock) external returns (bool);
171 
172 	function getRewardParamUpdated() external view returns (uint256);
173 	function setRewardParamUpdated(uint256 _rewardParamUpdated) external returns (bool);
174 
175 	function getInterestUpdateRewardPerblock() external view returns (uint256);
176 	function setInterestUpdateRewardPerblock(uint256 _interestUpdateRewardPerblock) external returns (bool);
177 
178 	function getInterestRewardUpdated() external view returns (uint256);
179 	function setInterestRewardUpdated(uint256 _interestRewardLastUpdated) external returns (bool);
180 
181 	function setTokenHandler(uint256 handlerID, address handlerAddr) external returns (bool);
182 
183 	function getTokenHandlerInfo(uint256 handlerID) external view returns (bool, address);
184 
185 	function getTokenHandlerID(uint256 index) external view returns (uint256);
186 
187 	function getTokenHandlerAddr(uint256 handlerID) external view returns (address);
188 	function setTokenHandlerAddr(uint256 handlerID, address handlerAddr) external returns (bool);
189 
190 	function getTokenHandlerExist(uint256 handlerID) external view returns (bool);
191 	function setTokenHandlerExist(uint256 handlerID, bool exist) external returns (bool);
192 
193 	function getTokenHandlerSupport(uint256 handlerID) external view returns (bool);
194 	function setTokenHandlerSupport(uint256 handlerID, bool support) external returns (bool);
195 
196 	function setLiquidationManagerAddr(address _liquidationManagerAddr) external returns (bool);
197 	function getLiquidationManagerAddr() external view returns (address);
198 
199 	function setManagerAddr(address _managerAddr) external returns (bool);
200 }
201 
202 // File: contracts/interfaces/IOracleProxy.sol
203 pragma solidity 0.6.12;
204 
205 /**
206  * @title BiFi's oracle proxy interface
207  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
208  */
209 interface IOracleProxy  {
210 	function getTokenPrice(uint256 tokenID) external view returns (uint256);
211 
212 	function getOracleFeed(uint256 tokenID) external view returns (address, uint256);
213 	function setOracleFeed(uint256 tokenID, address feedAddr, uint256 decimals, bool needPriceConvert, uint256 priceConvertID) external returns (bool);
214 }
215 
216 // File: contracts/interfaces/IERC20.sol
217 // from: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
218 pragma solidity 0.6.12;
219 interface IERC20 {
220     function totalSupply() external view returns (uint256);
221     function balanceOf(address account) external view returns (uint256);
222     function transfer(address recipient, uint256 amount) external ;
223     function allowance(address owner, address spender) external view returns (uint256);
224     function approve(address spender, uint256 amount) external returns (bool);
225     function transferFrom(address sender, address recipient, uint256 amount) external ;
226 
227     event Transfer(address indexed from, address indexed to, uint256 value);
228     event Approval(address indexed owner, address indexed spender, uint256 value);
229 }
230 
231 // File: contracts/interfaces/IObserver.sol
232 pragma solidity 0.6.12;
233 
234 /**
235  * @title BiFi's Observer interface
236  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
237  */
238 interface IObserver {
239     function getAlphaBaseAsset() external view returns (uint256[] memory);
240     function setChainGlobalRewardPerblock(uint256 _idx, uint256 globalRewardPerBlocks) external returns (bool);
241     function updateChainMarketInfo(uint256 _idx, uint256 chainDeposit, uint256 chainBorrow) external returns (bool);
242 }
243 
244 // File: contracts/interfaces/IProxy.sol
245 pragma solidity 0.6.12;
246 
247 /**
248  * @title BiFi's proxy interface
249  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
250  */
251 interface IProxy  {
252 	function handlerProxy(bytes memory data) external returns (bool, bytes memory);
253 	function handlerViewProxy(bytes memory data) external view returns (bool, bytes memory);
254 	function siProxy(bytes memory data) external returns (bool, bytes memory);
255 	function siViewProxy(bytes memory data) external view returns (bool, bytes memory);
256 }
257 
258 // File: contracts/interfaces/IMarketHandler.sol
259 pragma solidity 0.6.12;
260 
261 /**
262  * @title BiFi's market handler interface
263  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
264  */
265 interface IMarketHandler  {
266 	function setCircuitBreaker(bool _emergency) external returns (bool);
267 	function setCircuitBreakWithOwner(bool _emergency) external returns (bool);
268 
269 	function getTokenName() external view returns (string memory);
270 
271 	function ownershipTransfer(address payable newOwner) external returns (bool);
272 
273 	function deposit(uint256 unifiedTokenAmount, bool allFlag) external payable returns (bool);
274 	function withdraw(uint256 unifiedTokenAmount, bool allFlag) external returns (bool);
275 	function borrow(uint256 unifiedTokenAmount, bool allFlag) external returns (bool);
276 	function repay(uint256 unifiedTokenAmount, bool allFlag) external payable returns (bool);
277 
278 	function executeFlashloan(
279 		address receiverAddress,
280 		uint256 amount
281   ) external returns (bool);
282 
283 	function depositFlashloanFee(
284 		uint256 amount
285 	) external returns (bool);
286 
287   function convertUnifiedToUnderlying(uint256 unifiedTokenAmount) external view returns (uint256);
288 	function partialLiquidationUser(address payable delinquentBorrower, uint256 liquidateAmount, address payable liquidator, uint256 rewardHandlerID) external returns (uint256, uint256, uint256);
289 	function partialLiquidationUserReward(address payable delinquentBorrower, uint256 liquidationAmountWithReward, address payable liquidator) external returns (uint256);
290 
291 	function getTokenHandlerLimit() external view returns (uint256, uint256);
292   function getTokenHandlerBorrowLimit() external view returns (uint256);
293 	function getTokenHandlerMarginCallLimit() external view returns (uint256);
294 	function setTokenHandlerBorrowLimit(uint256 borrowLimit) external returns (bool);
295 	function setTokenHandlerMarginCallLimit(uint256 marginCallLimit) external returns (bool);
296 
297   function getTokenLiquidityAmountWithInterest(address payable userAddr) external view returns (uint256);
298 
299 	function getUserAmountWithInterest(address payable userAddr) external view returns (uint256, uint256);
300 	function getUserAmount(address payable userAddr) external view returns (uint256, uint256);
301 
302 	function getUserMaxBorrowAmount(address payable userAddr) external view returns (uint256);
303 	function getUserMaxWithdrawAmount(address payable userAddr) external view returns (uint256);
304 	function getUserMaxRepayAmount(address payable userAddr) external view returns (uint256);
305 
306 	function checkFirstAction() external returns (bool);
307 	function applyInterest(address payable userAddr) external returns (uint256, uint256);
308 
309 	function reserveDeposit(uint256 unifiedTokenAmount) external payable returns (bool);
310 	function reserveWithdraw(uint256 unifiedTokenAmount) external returns (bool);
311 
312 	function withdrawFlashloanFee(uint256 unifiedTokenAmount) external returns (bool);
313 
314 	function getDepositTotalAmount() external view returns (uint256);
315 	function getBorrowTotalAmount() external view returns (uint256);
316 
317 	function getSIRandBIR() external view returns (uint256, uint256);
318 
319   function getERC20Addr() external view returns (address);
320 }
321 
322 // File: contracts/interfaces/IServiceIncentive.sol
323 pragma solidity 0.6.12;
324 
325 /**
326  * @title BiFi's si interface
327  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
328  */
329 interface IServiceIncentive  {
330 	function setCircuitBreakWithOwner(bool emergency) external returns (bool);
331 	function setCircuitBreaker(bool emergency) external returns (bool);
332 
333 	function updateRewardPerBlockLogic(uint256 _rewardPerBlock) external returns (bool);
334 	function updateRewardLane(address payable userAddr) external returns (bool);
335 
336 	function getBetaRateBaseTotalAmount() external view returns (uint256);
337 	function getBetaRateBaseUserAmount(address payable userAddr) external view returns (uint256);
338 
339 	function getMarketRewardInfo() external view returns (uint256, uint256, uint256);
340 
341 	function getUserRewardInfo(address payable userAddr) external view returns (uint256, uint256, uint256);
342 
343 	function claimRewardAmountUser(address payable userAddr) external returns (uint256);
344 }
345 
346 // File: contracts/Errors.sol
347 pragma solidity 0.6.12;
348 
349 contract Modifier {
350     string internal constant ONLY_OWNER = "O";
351     string internal constant ONLY_MANAGER = "M";
352     string internal constant CIRCUIT_BREAKER = "emergency";
353 }
354 
355 contract ManagerModifier is Modifier {
356     string internal constant ONLY_HANDLER = "H";
357     string internal constant ONLY_LIQUIDATION_MANAGER = "LM";
358     string internal constant ONLY_BREAKER = "B";
359 }
360 
361 contract HandlerDataStorageModifier is Modifier {
362     string internal constant ONLY_BIFI_CONTRACT = "BF";
363 }
364 
365 contract SIDataStorageModifier is Modifier {
366     string internal constant ONLY_SI_HANDLER = "SI";
367 }
368 
369 contract HandlerErrors is Modifier {
370     string internal constant USE_VAULE = "use value";
371     string internal constant USE_ARG = "use arg";
372     string internal constant EXCEED_LIMIT = "exceed limit";
373     string internal constant NO_LIQUIDATION = "no liquidation";
374     string internal constant NO_LIQUIDATION_REWARD = "no enough reward";
375     string internal constant NO_EFFECTIVE_BALANCE = "not enough balance";
376     string internal constant TRANSFER = "err transfer";
377 }
378 
379 contract SIErrors is Modifier { }
380 
381 contract InterestErrors is Modifier { }
382 
383 contract LiquidationManagerErrors is Modifier {
384     string internal constant NO_DELINQUENT = "not delinquent";
385 }
386 
387 contract ManagerErrors is ManagerModifier {
388     string internal constant REWARD_TRANSFER = "RT";
389     string internal constant UNSUPPORTED_TOKEN = "UT";
390 }
391 
392 contract OracleProxyErrors is Modifier {
393     string internal constant ZERO_PRICE = "price zero";
394 }
395 
396 contract RequestProxyErrors is Modifier { }
397 
398 contract ManagerDataStorageErrors is ManagerModifier {
399     string internal constant NULL_ADDRESS = "err addr null";
400 }
401 
402 // File: contracts/marketManager/ManagerSlot.sol
403 pragma solidity 0.6.12;
404 
405 /**
406  * @title BiFi's Slot contract
407  * @notice Manager Slot Definitions & Allocations
408  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
409  */
410 contract ManagerSlot is ManagerErrors {
411 	using SafeMath for uint256;
412 
413 	address public owner;
414 	mapping(address => bool) operators;
415 	mapping(address => Breaker) internal breakerTable;
416 
417 	bool public emergency = false;
418 
419 	IManagerDataStorage internal dataStorageInstance;
420 	IOracleProxy internal oracleProxy;
421 
422 	/* feat: manager reward token instance*/
423 	IERC20 internal rewardErc20Instance;
424 
425 	IObserver public Observer;
426 
427 	address public slotSetterAddr;
428 	address public handlerManagerAddr;
429 	address public flashloanAddr;
430 
431   // BiFi-X
432   address public positionStorageAddr;
433   address public nftAddr;
434 
435 	uint256 public tokenHandlerLength;
436 
437   struct FeeRateParams {
438     uint256 unifiedPoint;
439     uint256 minimum;
440     uint256 slope;
441     uint256 discountRate;
442   }
443 
444   struct HandlerFlashloan {
445       uint256 flashFeeRate;
446       uint256 discountBase;
447       uint256 feeTotal;
448   }
449 
450   mapping(uint256 => HandlerFlashloan) public handlerFlashloan;
451 
452 	struct UserAssetsInfo {
453 		uint256 depositAssetSum;
454 		uint256 borrowAssetSum;
455 		uint256 marginCallLimitSum;
456 		uint256 depositAssetBorrowLimitSum;
457 		uint256 depositAsset;
458 		uint256 borrowAsset;
459 		uint256 price;
460 		uint256 callerPrice;
461 		uint256 depositAmount;
462 		uint256 borrowAmount;
463 		uint256 borrowLimit;
464 		uint256 marginCallLimit;
465 		uint256 callerBorrowLimit;
466 		uint256 userBorrowableAsset;
467 		uint256 withdrawableAsset;
468 	}
469 
470 	struct Breaker {
471 		bool auth;
472 		bool tried;
473 	}
474 
475 	struct ContractInfo {
476 		bool support;
477 		address addr;
478     address tokenAddr;
479 
480     uint256 expectedBalance;
481     uint256 afterBalance;
482 
483 		IProxy tokenHandler;
484 		bytes data;
485 
486 		IMarketHandler handlerFunction;
487 		IServiceIncentive siFunction;
488 
489 		IOracleProxy oracleProxy;
490 		IManagerDataStorage managerDataStorage;
491 	}
492 
493 	modifier onlyOwner {
494 		require(msg.sender == owner, ONLY_OWNER);
495 		_;
496 	}
497 
498 	modifier onlyHandler(uint256 handlerID) {
499 		_isHandler(handlerID);
500 		_;
501 	}
502 
503 	modifier onlyOperators {
504 		address payable sender = msg.sender;
505 		require(operators[sender] || sender == owner);
506 		_;
507 	}
508 
509 	function _isHandler(uint256 handlerID) internal view {
510 		address msgSender = msg.sender;
511 		require((msgSender == dataStorageInstance.getTokenHandlerAddr(handlerID)) || (msgSender == owner), ONLY_HANDLER);
512 	}
513 
514 	modifier onlyLiquidationManager {
515 		_isLiquidationManager();
516 		_;
517 	}
518 
519 	function _isLiquidationManager() internal view {
520 		address msgSender = msg.sender;
521 		require((msgSender == dataStorageInstance.getLiquidationManagerAddr()) || (msgSender == owner), ONLY_LIQUIDATION_MANAGER);
522 	}
523 
524 	modifier circuitBreaker {
525 		_isCircuitBreak();
526 		_;
527 	}
528 
529 	function _isCircuitBreak() internal view {
530 		require((!emergency) || (msg.sender == owner), CIRCUIT_BREAKER);
531 	}
532 
533 	modifier onlyBreaker {
534 		_isBreaker();
535 		_;
536 	}
537 
538 	function _isBreaker() internal view {
539 		require(breakerTable[msg.sender].auth, ONLY_BREAKER);
540 	}
541 }
542 
543 // File: contracts/marketManager/TokenManager.sol
544 // SPDX-License-Identifier: BSD-3-Clause
545 pragma solidity 0.6.12;
546 
547 /**
548  * @title BiFi's marketManager contract
549  * @notice Implement business logic and manage handlers
550  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
551  */
552 contract TokenManager is ManagerSlot {
553 
554 	/**
555 	* @dev Constructor for marketManager
556 	* @param managerDataStorageAddr The address of the manager storage contract
557 	* @param oracleProxyAddr The address of oracle proxy contract (e.g., price feeds)
558 	* @param breaker The address of default circuit breaker
559 	* @param erc20Addr The address of reward token (ERC-20)
560 	*/
561 	constructor (address managerDataStorageAddr, address oracleProxyAddr, address _slotSetterAddr, address _handlerManagerAddr, address _flashloanAddr, address breaker, address erc20Addr) public
562 	{
563 		owner = msg.sender;
564 		dataStorageInstance = IManagerDataStorage(managerDataStorageAddr);
565 		oracleProxy = IOracleProxy(oracleProxyAddr);
566 		rewardErc20Instance = IERC20(erc20Addr);
567 
568 		slotSetterAddr = _slotSetterAddr;
569 		handlerManagerAddr = _handlerManagerAddr;
570 		flashloanAddr = _flashloanAddr;
571 
572 		breakerTable[owner].auth = true;
573 		breakerTable[breaker].auth = true;
574 	}
575 
576 	/**
577 	* @dev Transfer ownership
578 	* @param _owner the address of the new owner
579 	* @return result the setter call in contextSetter contract
580 	*/
581 	function ownershipTransfer(address payable _owner) onlyOwner public returns (bool result) {
582     bytes memory callData = abi.encodeWithSelector(
583 				IManagerSlotSetter
584 				.ownershipTransfer.selector,
585 				_owner
586 			);
587 
588     (result, ) = slotSetterAddr.delegatecall(callData);
589     assert(result);
590 	}
591 
592 	function setOperator(address payable adminAddr, bool flag) onlyOwner external returns (bool result) {
593 		bytes memory callData = abi.encodeWithSelector(
594 				IManagerSlotSetter
595 				.setOperator.selector,
596 				adminAddr, flag
597 			);
598 
599 		(result, ) = slotSetterAddr.delegatecall(callData);
600     assert(result);
601 	}
602 
603 	/**
604 	* @dev Set the address of OracleProxy contract
605 	* @param oracleProxyAddr The address of OracleProxy contract
606 	* @return result the setter call in contextSetter contract
607 	*/
608 	function setOracleProxy(address oracleProxyAddr) onlyOwner external returns (bool result) {
609     bytes memory callData = abi.encodeWithSelector(
610 				IManagerSlotSetter
611 				.setOracleProxy.selector,
612 				oracleProxyAddr
613 			);
614 
615 		(result, ) = slotSetterAddr.delegatecall(callData);
616     assert(result);
617 	}
618 
619 	/**
620 	* @dev Set the address of BiFi reward token contract
621 	* @param erc20Addr The address of BiFi reward token contract
622 	* @return result the setter call in contextSetter contract
623 	*/
624 	function setRewardErc20(address erc20Addr) onlyOwner public returns (bool result) {
625     bytes memory callData = abi.encodeWithSelector(
626 				IManagerSlotSetter
627 				.setRewardErc20.selector,
628 				erc20Addr
629 			);
630 
631 		(result, ) = slotSetterAddr.delegatecall(callData);
632     assert(result);
633 	}
634 
635 	/**
636 	* @dev Authorize admin user for circuitBreaker
637 	* @param _target The address of the circuitBreaker admin user.
638 	* @param _status The boolean status of circuitBreaker (on/off)
639 	* @return result the setter call in contextSetter contract
640 	*/
641 	function setBreakerTable(address _target, bool _status) onlyOwner external returns (bool result) {
642     bytes memory callData = abi.encodeWithSelector(
643 				IManagerSlotSetter
644 				.setBreakerTable.selector,
645 				_target, _status
646 			);
647 
648 		(result, ) = slotSetterAddr.delegatecall(callData);
649     assert(result);
650 	}
651 
652 	/**
653 	* @dev Set circuitBreak to freeze/unfreeze all handlers
654 	* @param _emergency The boolean status of circuitBreaker (on/off)
655 	* @return result the setter call in contextSetter contract
656 	*/
657 	function setCircuitBreaker(bool _emergency) onlyBreaker external returns (bool result) {
658 		bytes memory callData = abi.encodeWithSelector(
659 				IManagerSlotSetter
660 				.setCircuitBreaker.selector,
661 				_emergency
662 			);
663 
664 		(result, ) = slotSetterAddr.delegatecall(callData);
665     assert(result);
666 	}
667 
668 	function setSlotSetterAddr(address _slotSetterAddr) onlyOwner external returns (bool result) {
669 			bytes memory callData = abi.encodeWithSelector(
670 					IManagerSlotSetter.setSlotSetterAddr.selector,
671 					_slotSetterAddr
672 				);
673 
674 			(result, ) = slotSetterAddr.delegatecall(callData);
675 		assert(result);
676 	}
677 
678 	function sethandlerManagerAddr(address _handlerManagerAddr) onlyOwner external returns (bool result) {
679 			bytes memory callData = abi.encodeWithSelector(
680 					IManagerSlotSetter.sethandlerManagerAddr.selector,
681 					_handlerManagerAddr
682 				);
683 
684 			(result, ) = slotSetterAddr.delegatecall(callData);
685 		assert(result);
686 	}
687 
688 	function setFlashloanAddr(address _flashloanAddr) onlyOwner external returns (bool result) {
689 			bytes memory callData = abi.encodeWithSelector(
690 					IManagerSlotSetter.setFlashloanAddr.selector,
691 					_flashloanAddr
692 				);
693 
694 			(result, ) = slotSetterAddr.delegatecall(callData);
695 		assert(result);
696 	}
697 
698 	function setPositionStorageAddr(address _positionStorageAddr) onlyOwner external returns (bool result) {
699 			bytes memory callData = abi.encodeWithSelector(
700 					IManagerSlotSetter.setPositionStorageAddr.selector,
701 					_positionStorageAddr
702 				);
703 
704 			(result, ) = slotSetterAddr.delegatecall(callData);
705 		assert(result);
706 	}
707 
708 	function setNFTAddr(address _nftAddr) onlyOwner external returns (bool result) {
709 			bytes memory callData = abi.encodeWithSelector(
710 					IManagerSlotSetter.setNFTAddr.selector,
711 					_nftAddr
712 				);
713 
714 			(result, ) = slotSetterAddr.delegatecall(callData);
715 		assert(result);
716 	}
717 
718 	function setFlashloanFee(uint256 handlerID, uint256 flashFeeRate) onlyOwner external returns (bool result) {
719 			bytes memory callData = abi.encodeWithSelector(
720 					IManagerSlotSetter
721 					.setFlashloanFee.selector,
722 					handlerID,
723 			    	flashFeeRate
724 				);
725 
726 			(result, ) = slotSetterAddr.delegatecall(callData);
727 		assert(result);
728 	}
729 
730 	function setDiscountBase(uint256 handlerID, uint256 feeBase) onlyOwner external returns (bool result) {
731 			bytes memory callData = abi.encodeWithSelector(
732 					IManagerSlotSetter
733 					.setDiscountBase.selector,
734 					handlerID,
735 			    feeBase
736 				);
737 
738 			(result, ) = slotSetterAddr.delegatecall(callData);
739 		assert(result);
740 	}
741 
742 	/**
743 	* @dev Get the circuitBreak status
744 	* @return The circuitBreak status
745 	*/
746 	function getCircuitBreaker() external view returns (bool)
747 	{
748 		return emergency;
749 	}
750 
751 	/**
752 	* @dev Get information for a handler
753 	* @param handlerID Handler ID
754 	* @return (success or failure, handler address, handler name)
755 	*/
756 	function getTokenHandlerInfo(uint256 handlerID) external view returns (bool, address, string memory)
757 	{
758 		bool support;
759 		address tokenHandlerAddr;
760 		string memory tokenName;
761 		if (dataStorageInstance.getTokenHandlerSupport(handlerID))
762 		{
763 			tokenHandlerAddr = dataStorageInstance.getTokenHandlerAddr(handlerID);
764 			IProxy TokenHandler = IProxy(tokenHandlerAddr);
765 			bytes memory data;
766 			(, data) = TokenHandler.handlerViewProxy(
767 				abi.encodeWithSelector(
768 					IMarketHandler
769 					.getTokenName.selector
770 				)
771 			);
772 			tokenName = abi.decode(data, (string));
773 			support = true;
774 		}
775 
776 		return (support, tokenHandlerAddr, tokenName);
777 	}
778 
779 	/**
780 	* @dev Register a handler
781 	* @param handlerID Handler ID and address
782 	* @param tokenHandlerAddr The handler address
783 	* @return result the setter call in contextSetter contract
784 	*/
785 	function handlerRegister(uint256 handlerID, address tokenHandlerAddr, uint256 flashFeeRate, uint256 discountBase) onlyOwner external returns (bool result) {
786 		bytes memory callData = abi.encodeWithSelector(
787 					IManagerSlotSetter
788 					.handlerRegister.selector,
789 					handlerID, tokenHandlerAddr, flashFeeRate, discountBase
790 				);
791 
792 			(result, ) = slotSetterAddr.delegatecall(callData);
793 		assert(result);
794 	}
795 	/**
796 	* @dev Set a liquidation manager contract
797 	* @param liquidationManagerAddr The address of liquidiation manager
798 	* @return result the setter call in contextSetter contract
799 	*/
800 	function setLiquidationManager(address liquidationManagerAddr) onlyOwner external returns (bool result) {
801     bytes memory callData = abi.encodeWithSelector(
802 				IManagerSlotSetter
803 				.setLiquidationManager.selector,
804 				liquidationManagerAddr
805 			);
806 
807 		(result, ) = slotSetterAddr.delegatecall(callData);
808     assert(result);
809 	}
810 
811 	/**
812 	* @dev Update the (SI) rewards for a user
813 	* @param userAddr The address of the user
814 	* @param callerID The handler ID
815 	* @return true (TODO: validate results)
816 	*/
817 	function rewardUpdateOfInAction(address payable userAddr, uint256 callerID) external returns (bool)
818 	{
819 		ContractInfo memory handlerInfo;
820 		(handlerInfo.support, handlerInfo.addr) = dataStorageInstance.getTokenHandlerInfo(callerID);
821 		if (handlerInfo.support)
822 		{
823 			IProxy TokenHandler;
824 			TokenHandler = IProxy(handlerInfo.addr);
825 			TokenHandler.siProxy(
826 				abi.encodeWithSelector(
827 					IServiceIncentive
828 					.updateRewardLane.selector,
829 					userAddr
830 				)
831 			);
832 		}
833 
834 		return true;
835 	}
836 
837 	/**
838 	* @dev Update interest of a user for a handler (internal)
839 	* @param userAddr The user address
840 	* @param callerID The handler ID
841 	* @param allFlag Flag for the full calculation mode (calculting for all handlers)
842 	* @return (uint256, uint256, uint256, uint256, uint256, uint256)
843 	*/
844 	function applyInterestHandlers(address payable userAddr, uint256 callerID, bool allFlag) external returns (uint256, uint256, uint256, uint256, uint256, uint256) {
845     bytes memory callData = abi.encodeWithSelector(
846 				IHandlerManager
847 				.applyInterestHandlers.selector,
848 				userAddr, callerID, allFlag
849 			);
850 
851 		(bool result, bytes memory returnData) = handlerManagerAddr.delegatecall(callData);
852     assert(result);
853 
854     return abi.decode(returnData, (uint256, uint256, uint256, uint256, uint256, uint256));
855   }
856 
857 	/**
858 	* @dev Reward the user (msg.sender) with the reward token after calculating interest.
859 	* @return result the interestUpdateReward call in ManagerInterest contract
860 	*/
861 	function interestUpdateReward() external returns (bool result) {
862 		bytes memory callData = abi.encodeWithSelector(
863 				IHandlerManager
864 				.interestUpdateReward.selector
865 			);
866 
867 		(result, ) = handlerManagerAddr.delegatecall(callData);
868     	assert(result);
869 	}
870 
871 	/**
872 	* @dev (Update operation) update the rewards parameters.
873 	* @param userAddr The address of operator
874 	* @return result the updateRewardParams call in ManagerInterest contract
875 	*/
876 	function updateRewardParams(address payable userAddr) onlyOperators external returns (bool result) {
877 		bytes memory callData = abi.encodeWithSelector(
878 				IHandlerManager
879 				.updateRewardParams.selector,
880         userAddr
881 			);
882 
883 		(result, ) = handlerManagerAddr.delegatecall(callData);
884     assert(result);
885 	}
886 
887 	/**
888 	* @dev Claim all rewards for the user
889 	* @param userAddr The user address
890 	* @return true (TODO: validate results)
891 	*/
892 	function rewardClaimAll(address payable userAddr) external returns (uint256)
893 	{
894     bytes memory callData = abi.encodeWithSelector(
895 				IHandlerManager
896 				.rewardClaimAll.selector,
897         userAddr
898 			);
899 
900 		(bool result, bytes memory returnData) = handlerManagerAddr.delegatecall(callData);
901     assert(result);
902 
903     return abi.decode(returnData, (uint256));
904 	}
905 
906 	/**
907 	* @dev Claim handler rewards for the user
908 	* @param handlerID The ID of claim reward handler
909 	* @param userAddr The user address
910 	* @return true (TODO: validate results)
911 	*/
912 	function claimHandlerReward(uint256 handlerID, address payable userAddr) external returns (uint256) {
913 		bytes memory callData = abi.encodeWithSelector(
914 				IHandlerManager
915 				.claimHandlerReward.selector,
916         handlerID, userAddr
917 			);
918 
919 		(bool result, bytes memory returnData) = handlerManagerAddr.delegatecall(callData);
920     assert(result);
921 
922     return abi.decode(returnData, (uint256));
923 	}
924 
925 	/**
926 	* @dev Transfer reward tokens to owner (for administration)
927 	* @param _amount The amount of the reward token
928 	* @return result (TODO: validate results)
929 	*/
930 	function ownerRewardTransfer(uint256 _amount) onlyOwner external returns (bool result)
931 	{
932 		bytes memory callData = abi.encodeWithSelector(
933 				IHandlerManager
934 				.ownerRewardTransfer.selector,
935         _amount
936 			);
937 
938 		(result, ) = handlerManagerAddr.delegatecall(callData);
939     assert(result);
940 	}
941 
942 
943 	/**
944 	* @dev Get the token price of the handler
945 	* @param handlerID The handler ID
946 	* @return The token price of the handler
947 	*/
948 	function getTokenHandlerPrice(uint256 handlerID) external view returns (uint256)
949 	{
950 		return _getTokenHandlerPrice(handlerID);
951 	}
952 
953 	/**
954 	* @dev Get the margin call limit of the handler (external)
955 	* @param handlerID The handler ID
956 	* @return The margin call limit
957 	*/
958 	function getTokenHandlerMarginCallLimit(uint256 handlerID) external view returns (uint256)
959 	{
960 		return _getTokenHandlerMarginCallLimit(handlerID);
961 	}
962 
963 	/**
964 	* @dev Get the margin call limit of the handler (internal)
965 	* @param handlerID The handler ID
966 	* @return The margin call limit
967 	*/
968 	function _getTokenHandlerMarginCallLimit(uint256 handlerID) internal view returns (uint256)
969 	{
970 		IProxy TokenHandler = IProxy(dataStorageInstance.getTokenHandlerAddr(handlerID));
971 		bytes memory data;
972 		(, data) = TokenHandler.handlerViewProxy(
973 			abi.encodeWithSelector(
974 				IMarketHandler
975 				.getTokenHandlerMarginCallLimit.selector
976 			)
977 		);
978 		return abi.decode(data, (uint256));
979 	}
980 
981 	/**
982 	* @dev Get the borrow limit of the handler (external)
983 	* @param handlerID The handler ID
984 	* @return The borrow limit
985 	*/
986 	function getTokenHandlerBorrowLimit(uint256 handlerID) external view returns (uint256)
987 	{
988 		return _getTokenHandlerBorrowLimit(handlerID);
989 	}
990 
991 	/**
992 	* @dev Get the borrow limit of the handler (internal)
993 	* @param handlerID The handler ID
994 	* @return The borrow limit
995 	*/
996 	function _getTokenHandlerBorrowLimit(uint256 handlerID) internal view returns (uint256)
997 	{
998 		IProxy TokenHandler = IProxy(dataStorageInstance.getTokenHandlerAddr(handlerID));
999 
1000 		bytes memory data;
1001 		(, data) = TokenHandler.handlerViewProxy(
1002 			abi.encodeWithSelector(
1003 				IMarketHandler
1004 				.getTokenHandlerBorrowLimit.selector
1005 			)
1006 		);
1007 		return abi.decode(data, (uint256));
1008 	}
1009 
1010 	/**
1011 	* @dev Get the handler status of whether the handler is supported or not.
1012 	* @param handlerID The handler ID
1013 	* @return Whether the handler is supported or not
1014 	*/
1015 	function getTokenHandlerSupport(uint256 handlerID) external view returns (bool)
1016 	{
1017 		return dataStorageInstance.getTokenHandlerSupport(handlerID);
1018 	}
1019 
1020 	/**
1021 	* @dev Set the length of the handler list
1022 	* @param _tokenHandlerLength The length of the handler list
1023 	* @return true (TODO: validate results)
1024 	*/
1025 	function setTokenHandlersLength(uint256 _tokenHandlerLength) onlyOwner external returns (bool)
1026 	{
1027 		tokenHandlerLength = _tokenHandlerLength;
1028 		return true;
1029 	}
1030 
1031 	/**
1032 	* @dev Get the length of the handler list
1033 	* @return the length of the handler list
1034 	*/
1035 	function getTokenHandlersLength() external view returns (uint256)
1036 	{
1037 		return tokenHandlerLength;
1038 	}
1039 
1040 	/**
1041 	* @dev Get the handler ID at the index in the handler list
1042 	* @param index The index of the handler list (array)
1043 	* @return The handler ID
1044 	*/
1045 	function getTokenHandlerID(uint256 index) external view returns (uint256)
1046 	{
1047 		return dataStorageInstance.getTokenHandlerID(index);
1048 	}
1049 
1050 	/**
1051 	* @dev Get the amount of token that the user can borrow more
1052 	* @param userAddr The address of user
1053 	* @param handlerID The handler ID
1054 	* @return The amount of token that user can borrow more
1055 	*/
1056 	function getUserExtraLiquidityAmount(address payable userAddr, uint256 handlerID) external view returns (uint256)
1057 	{
1058 		return _getUserExtraLiquidityAmount(userAddr, handlerID);
1059 	}
1060 
1061 	/**
1062 	* @dev Get the deposit and borrow amount of the user with interest added
1063 	* @param userAddr The address of user
1064 	* @param handlerID The handler ID
1065 	* @return The deposit and borrow amount of the user with interest
1066 	*/
1067 	/* about user market Information function*/
1068 	function getUserIntraHandlerAssetWithInterest(address payable userAddr, uint256 handlerID) external view returns (uint256, uint256)
1069 	{
1070 		return _getUserIntraHandlerAssetWithInterest(userAddr, handlerID);
1071 	}
1072 
1073 	/**
1074 	* @dev Get the depositTotalCredit and borrowTotalCredit
1075 	* @param userAddr The address of the user
1076 	* @return depositTotalCredit The amount that users can borrow (i.e. deposit * borrowLimit)
1077 	* @return borrowTotalCredit The sum of borrow amount for all handlers
1078 	*/
1079 	function getUserTotalIntraCreditAsset(address payable userAddr) external view returns (uint256, uint256)
1080 	{
1081 		return _getUserTotalIntraCreditAsset(userAddr);
1082 	}
1083 
1084 	/**
1085 	* @dev Get the borrow and margin call limits of the user for all handlers
1086 	* @param userAddr The address of the user
1087 	* @return userTotalBorrowLimitAsset the sum of borrow limit for all handlers
1088 	* @return userTotalMarginCallLimitAsset the sume of margin call limit for handlers
1089 	*/
1090 	function getUserLimitIntraAsset(address payable userAddr) external view returns (uint256, uint256)
1091 	{
1092 		uint256 userTotalBorrowLimitAsset;
1093 		uint256 userTotalMarginCallLimitAsset;
1094 
1095 		for (uint256 handlerID; handlerID < tokenHandlerLength; handlerID++)
1096 		{
1097 			if (dataStorageInstance.getTokenHandlerSupport(handlerID))
1098 			{
1099 				uint256 depositHandlerAsset;
1100 				uint256 borrowHandlerAsset;
1101 				(depositHandlerAsset, borrowHandlerAsset) = _getUserIntraHandlerAssetWithInterest(userAddr, handlerID);
1102 				uint256 borrowLimit = _getTokenHandlerBorrowLimit(handlerID);
1103 				uint256 marginCallLimit = _getTokenHandlerMarginCallLimit(handlerID);
1104 				uint256 userBorrowLimitAsset = depositHandlerAsset.unifiedMul(borrowLimit);
1105 				uint256 userMarginCallLimitAsset = depositHandlerAsset.unifiedMul(marginCallLimit);
1106 				userTotalBorrowLimitAsset = userTotalBorrowLimitAsset.add(userBorrowLimitAsset);
1107 				userTotalMarginCallLimitAsset = userTotalMarginCallLimitAsset.add(userMarginCallLimitAsset);
1108 			}
1109 			else
1110 			{
1111 				continue;
1112 			}
1113 
1114 		}
1115 
1116 		return (userTotalBorrowLimitAsset, userTotalMarginCallLimitAsset);
1117 	}
1118 
1119 
1120 	/**
1121 	* @dev Get the maximum allowed amount to borrow of the user from the given handler
1122 	* @param userAddr The address of the user
1123 	* @param callerID The target handler to borrow
1124 	* @return extraCollateralAmount The maximum allowed amount to borrow from
1125 	  the handler.
1126 	*/
1127 	function getUserCollateralizableAmount(address payable userAddr, uint256 callerID) external view returns (uint256)
1128 	{
1129 		uint256 userTotalBorrowAsset;
1130 		uint256 depositAssetBorrowLimitSum;
1131 		uint256 depositHandlerAsset;
1132 		uint256 borrowHandlerAsset;
1133 		for (uint256 handlerID; handlerID < tokenHandlerLength; handlerID++)
1134 		{
1135 			if (dataStorageInstance.getTokenHandlerSupport(handlerID))
1136 			{
1137 
1138 				(depositHandlerAsset, borrowHandlerAsset) = _getUserIntraHandlerAssetWithInterest(userAddr, handlerID);
1139 				userTotalBorrowAsset = userTotalBorrowAsset.add(borrowHandlerAsset);
1140 				depositAssetBorrowLimitSum = depositAssetBorrowLimitSum
1141 												.add(
1142 													depositHandlerAsset
1143 													.unifiedMul( _getTokenHandlerBorrowLimit(handlerID) )
1144 												);
1145 			}
1146 		}
1147 
1148 		if (depositAssetBorrowLimitSum > userTotalBorrowAsset)
1149 		{
1150 			return depositAssetBorrowLimitSum
1151 					.sub(userTotalBorrowAsset)
1152 					.unifiedDiv( _getTokenHandlerBorrowLimit(callerID) )
1153 					.unifiedDiv( _getTokenHandlerPrice(callerID) );
1154 		}
1155 		return 0;
1156 	}
1157 
1158 	/**
1159 	* @dev Partial liquidation for a user
1160 	* @param delinquentBorrower The address of the liquidation target
1161 	* @param liquidateAmount The amount to liquidate
1162 	* @param liquidator The address of the liquidator (liquidation operator)
1163 	* @param liquidateHandlerID The hander ID of the liquidating asset
1164 	* @param rewardHandlerID The handler ID of the reward token for the liquidator
1165 	* @return (uint256, uint256, uint256)
1166 	*/
1167 	function partialLiquidationUser(address payable delinquentBorrower, uint256 liquidateAmount, address payable liquidator, uint256 liquidateHandlerID, uint256 rewardHandlerID) onlyLiquidationManager external returns (uint256, uint256, uint256)
1168 	{
1169 		address tokenHandlerAddr = dataStorageInstance.getTokenHandlerAddr(liquidateHandlerID);
1170 		IProxy TokenHandler = IProxy(tokenHandlerAddr);
1171 		bytes memory data;
1172 
1173 		data = abi.encodeWithSelector(
1174 			IMarketHandler
1175 			.partialLiquidationUser.selector,
1176 
1177 			delinquentBorrower,
1178 			liquidateAmount,
1179 			liquidator,
1180 			rewardHandlerID
1181 		);
1182 		(, data) = TokenHandler.handlerProxy(data);
1183 
1184 		return abi.decode(data, (uint256, uint256, uint256));
1185 	}
1186 
1187 	/**
1188 	* @dev Get the maximum liquidation reward by checking sufficient reward
1189 	  amount for the liquidator.
1190 	* @param delinquentBorrower The address of the liquidation target
1191 	* @param liquidateHandlerID The hander ID of the liquidating asset
1192 	* @param liquidateAmount The amount to liquidate
1193 	* @param rewardHandlerID The handler ID of the reward token for the liquidator
1194 	* @param rewardRatio delinquentBorrowAsset / delinquentDepositAsset
1195 	* @return The maximum reward token amount for the liquidator
1196 	*/
1197 	function getMaxLiquidationReward(address payable delinquentBorrower, uint256 liquidateHandlerID, uint256 liquidateAmount, uint256 rewardHandlerID, uint256 rewardRatio) external view returns (uint256)
1198 	{
1199 		uint256 liquidatePrice = _getTokenHandlerPrice(liquidateHandlerID);
1200 		uint256 rewardPrice = _getTokenHandlerPrice(rewardHandlerID);
1201 		uint256 delinquentBorrowerRewardDeposit;
1202 		(delinquentBorrowerRewardDeposit, ) = _getHandlerAmount(delinquentBorrower, rewardHandlerID);
1203 		uint256 rewardAsset = delinquentBorrowerRewardDeposit.unifiedMul(rewardPrice).unifiedMul(rewardRatio);
1204 		if (liquidateAmount.unifiedMul(liquidatePrice) > rewardAsset)
1205 		{
1206 			return rewardAsset.unifiedDiv(liquidatePrice);
1207 		}
1208 		else
1209 		{
1210 			return liquidateAmount;
1211 		}
1212 
1213 	}
1214 
1215 	/**
1216 	* @dev Reward the liquidator
1217 	* @param delinquentBorrower The address of the liquidation target
1218 	* @param rewardAmount The amount of reward token
1219 	* @param liquidator The address of the liquidator (liquidation operator)
1220 	* @param handlerID The handler ID of the reward token for the liquidator
1221 	* @return The amount of reward token
1222 	*/
1223 	function partialLiquidationUserReward(address payable delinquentBorrower, uint256 rewardAmount, address payable liquidator, uint256 handlerID) onlyLiquidationManager external returns (uint256)
1224 	{
1225 		address tokenHandlerAddr = dataStorageInstance.getTokenHandlerAddr(handlerID);
1226 		IProxy TokenHandler = IProxy(tokenHandlerAddr);
1227 		bytes memory data;
1228 		data = abi.encodeWithSelector(
1229 			IMarketHandler
1230 			.partialLiquidationUserReward.selector,
1231 
1232 			delinquentBorrower,
1233 			rewardAmount,
1234 			liquidator
1235 		);
1236 		(, data) = TokenHandler.handlerProxy(data);
1237 
1238 		return abi.decode(data, (uint256));
1239 	}
1240 
1241 	/**
1242     * @dev Execute flashloan contract with delegatecall
1243     * @param handlerID The ID of the token handler to borrow.
1244     * @param receiverAddress The address of receive callback contract
1245     * @param amount The amount of borrow through flashloan
1246     * @param params The encode metadata of user
1247     * @return Whether or not succeed
1248     */
1249  	function flashloan(
1250       uint256 handlerID,
1251       address receiverAddress,
1252       uint256 amount,
1253       bytes calldata params
1254     ) external returns (bool) {
1255       bytes memory callData = abi.encodeWithSelector(
1256 				IManagerFlashloan
1257 				.flashloan.selector,
1258 				handlerID, receiverAddress, amount, params
1259 			);
1260 
1261       (bool result, bytes memory returnData) = flashloanAddr.delegatecall(callData);
1262       assert(result);
1263 
1264       return abi.decode(returnData, (bool));
1265     }
1266 
1267 	/**
1268 	* @dev Call flashloan logic contract with delegatecall
1269     * @param handlerID The ID of handler with accumulated flashloan fee
1270     * @return The amount of fee accumlated to handler
1271     */
1272  	function getFeeTotal(uint256 handlerID) external returns (uint256)
1273 	{
1274 		bytes memory callData = abi.encodeWithSelector(
1275 				IManagerFlashloan
1276 				.getFeeTotal.selector,
1277 				handlerID
1278 			);
1279 
1280 		(bool result, bytes memory returnData) = flashloanAddr.delegatecall(callData);
1281 		assert(result);
1282 
1283 		return abi.decode(returnData, (uint256));
1284     }
1285 
1286 	/**
1287     * @dev Withdraw accumulated flashloan fee with delegatecall
1288     * @param handlerID The ID of handler with accumulated flashloan fee
1289     * @return Whether or not succeed
1290     */
1291 	function withdrawFlashloanFee(
1292       uint256 handlerID
1293     ) external onlyOwner returns (bool) {
1294     	bytes memory callData = abi.encodeWithSelector(
1295 				IManagerFlashloan
1296 				.withdrawFlashloanFee.selector,
1297 				handlerID
1298 			);
1299 
1300 		(bool result, bytes memory returnData) = flashloanAddr.delegatecall(callData);
1301 		assert(result);
1302 
1303 		return abi.decode(returnData, (bool));
1304     }
1305 
1306   /**
1307     * @dev Get flashloan fee for flashloan amount before make product(BiFi-X)
1308     * @param handlerID The ID of handler with accumulated flashloan fee
1309     * @param amount The amount of flashloan amount
1310     * @param bifiAmount The amount of Bifi amount
1311     * @return The amount of fee for flashloan amount
1312     */
1313   function getFeeFromArguments(
1314       uint256 handlerID,
1315       uint256 amount,
1316       uint256 bifiAmount
1317     ) external returns (uint256) {
1318       bytes memory callData = abi.encodeWithSelector(
1319 				IManagerFlashloan
1320 				.getFeeFromArguments.selector,
1321 				handlerID, amount, bifiAmount
1322 			);
1323 
1324       (bool result, bytes memory returnData) = flashloanAddr.delegatecall(callData);
1325       assert(result);
1326 
1327       return abi.decode(returnData, (uint256));
1328     }
1329 
1330 	/**
1331 	* @dev Get the deposit and borrow amount of the user for the handler (internal)
1332 	* @param userAddr The address of user
1333 	* @param handlerID The handler ID
1334 	* @return The deposit and borrow amount
1335 	*/
1336 	function _getHandlerAmount(address payable userAddr, uint256 handlerID) internal view returns (uint256, uint256)
1337 	{
1338 		IProxy TokenHandler = IProxy(dataStorageInstance.getTokenHandlerAddr(handlerID));
1339 		bytes memory data;
1340 		(, data) = TokenHandler.handlerViewProxy(
1341 			abi.encodeWithSelector(
1342 				IMarketHandler
1343 				.getUserAmount.selector,
1344 				userAddr
1345 			)
1346 		);
1347 		return abi.decode(data, (uint256, uint256));
1348 	}
1349 
1350   	/**
1351 	* @dev Get the deposit and borrow amount with interest of the user for the handler (internal)
1352 	* @param userAddr The address of user
1353 	* @param handlerID The handler ID
1354 	* @return The deposit and borrow amount with interest
1355 	*/
1356 	function _getHandlerAmountWithAmount(address payable userAddr, uint256 handlerID) internal view returns (uint256, uint256)
1357 	{
1358 		IProxy TokenHandler = IProxy(dataStorageInstance.getTokenHandlerAddr(handlerID));
1359 		bytes memory data;
1360 		(, data) = TokenHandler.handlerViewProxy(
1361 			abi.encodeWithSelector(
1362 				IMarketHandler
1363 				.getUserAmountWithInterest.selector,
1364 				userAddr
1365 			)
1366 		);
1367 		return abi.decode(data, (uint256, uint256));
1368 	}
1369 
1370 	/**
1371 	* @dev Set the support stauts for the handler
1372 	* @param handlerID the handler ID
1373 	* @param support the support status (boolean)
1374 	* @return result the setter call in contextSetter contract
1375 	*/
1376 	function setHandlerSupport(uint256 handlerID, bool support) onlyOwner public returns (bool result) {
1377 		bytes memory callData = abi.encodeWithSelector(
1378 				IManagerSlotSetter
1379 				.setHandlerSupport.selector,
1380 				handlerID, support
1381 			);
1382 
1383 		(result, ) = slotSetterAddr.delegatecall(callData);
1384     assert(result);
1385 	}
1386 
1387 	/**
1388 	* @dev Get owner's address of the manager contract
1389 	* @return The address of owner
1390 	*/
1391 	function getOwner() public view returns (address)
1392 	{
1393 		return owner;
1394 	}
1395 
1396 	/**
1397 	* @dev Get the deposit and borrow amount of the user with interest added
1398 	* @param userAddr The address of user
1399 	* @param handlerID The handler ID
1400 	* @return The deposit and borrow amount of the user with interest
1401 	*/
1402 	function _getUserIntraHandlerAssetWithInterest(address payable userAddr, uint256 handlerID) internal view returns (uint256, uint256)
1403 	{
1404 		uint256 price = _getTokenHandlerPrice(handlerID);
1405 		IProxy TokenHandler = IProxy(dataStorageInstance.getTokenHandlerAddr(handlerID));
1406 		uint256 depositAmount;
1407 		uint256 borrowAmount;
1408 
1409 		bytes memory data;
1410 		(, data) = TokenHandler.handlerViewProxy(
1411 			abi.encodeWithSelector(
1412 				IMarketHandler.getUserAmountWithInterest.selector,
1413 				userAddr
1414 			)
1415 		);
1416 		(depositAmount, borrowAmount) = abi.decode(data, (uint256, uint256));
1417 
1418 		uint256 depositAsset = depositAmount.unifiedMul(price);
1419 		uint256 borrowAsset = borrowAmount.unifiedMul(price);
1420 		return (depositAsset, borrowAsset);
1421 	}
1422 
1423 	/**
1424 	* @dev Get the depositTotalCredit and borrowTotalCredit
1425 	* @param userAddr The address of the user
1426 	* @return depositTotalCredit The amount that users can borrow (i.e. deposit * borrowLimit)
1427 	* @return borrowTotalCredit The sum of borrow amount for all handlers
1428 	*/
1429 	function _getUserTotalIntraCreditAsset(address payable userAddr) internal view returns (uint256, uint256)
1430 	{
1431 		uint256 depositTotalCredit;
1432 		uint256 borrowTotalCredit;
1433 		for (uint256 handlerID; handlerID < tokenHandlerLength; handlerID++)
1434 		{
1435 			if (dataStorageInstance.getTokenHandlerSupport(handlerID))
1436 			{
1437 				uint256 depositHandlerAsset;
1438 				uint256 borrowHandlerAsset;
1439 				(depositHandlerAsset, borrowHandlerAsset) = _getUserIntraHandlerAssetWithInterest(userAddr, handlerID);
1440 				uint256 borrowLimit = _getTokenHandlerBorrowLimit(handlerID);
1441 				uint256 depositHandlerCredit = depositHandlerAsset.unifiedMul(borrowLimit);
1442 				depositTotalCredit = depositTotalCredit.add(depositHandlerCredit);
1443 				borrowTotalCredit = borrowTotalCredit.add(borrowHandlerAsset);
1444 			}
1445 			else
1446 			{
1447 				continue;
1448 			}
1449 
1450 		}
1451 
1452 		return (depositTotalCredit, borrowTotalCredit);
1453 	}
1454 
1455 	/**
1456 	* @dev Get the amount of token that the user can borrow more
1457 	* @param userAddr The address of user
1458 	* @param handlerID The handler ID
1459 	* @return The amount of token that user can borrow more
1460 	*/
1461   	function _getUserExtraLiquidityAmount(address payable userAddr, uint256 handlerID) internal view returns (uint256) {
1462 		uint256 depositCredit;
1463 		uint256 borrowCredit;
1464 		(depositCredit, borrowCredit) = _getUserTotalIntraCreditAsset(userAddr);
1465 		if (depositCredit == 0)
1466 		{
1467 			return 0;
1468 		}
1469 
1470 		if (depositCredit > borrowCredit)
1471 		{
1472 			return depositCredit.sub(borrowCredit).unifiedDiv(_getTokenHandlerPrice(handlerID));
1473 		}
1474 		else
1475 		{
1476 			return 0;
1477 		}
1478 	}
1479 
1480 	function getFeePercent(uint256 handlerID) external view returns (uint256)
1481 	{
1482 	return handlerFlashloan[handlerID].flashFeeRate;
1483 	}
1484 
1485 	/**
1486 	* @dev Get the token price for the handler
1487 	* @param handlerID The handler id
1488 	* @return The token price of the handler
1489 	*/
1490 	function _getTokenHandlerPrice(uint256 handlerID) internal view returns (uint256)
1491 	{
1492 		return (oracleProxy.getTokenPrice(handlerID));
1493 	}
1494 
1495 	/**
1496 	* @dev Get the address of reward token
1497 	* @return The address of reward token
1498 	*/
1499 	function getRewardErc20() public view returns (address)
1500 	{
1501 		return address(rewardErc20Instance);
1502 	}
1503 
1504 	/**
1505 	* @dev Get the reward parameters
1506 	* @return (uint256,uint256,uint256) rewardPerBlock, rewardDecrement, rewardTotalAmount
1507 	*/
1508 	function getGlobalRewardInfo() external view returns (uint256, uint256, uint256)
1509 	{
1510 		IManagerDataStorage _dataStorage = dataStorageInstance;
1511 		return (_dataStorage.getGlobalRewardPerBlock(), _dataStorage.getGlobalRewardDecrement(), _dataStorage.getGlobalRewardTotalAmount());
1512 	}
1513 
1514 	function setObserverAddr(address observerAddr) onlyOwner external returns (bool) {
1515 		Observer = IObserver( observerAddr );
1516 	}
1517 
1518 	/**
1519 	* @dev fallback function where handler can receive native coin
1520 	*/
1521 	fallback () external payable
1522 	{
1523 
1524 	}
1525 }