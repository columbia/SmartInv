1 
2 // File: solidity/contracts/utility/interfaces/IOwned.sol
3 
4 // SPDX-License-Identifier: SEE LICENSE IN LICENSE
5 pragma solidity 0.6.12;
6 
7 /*
8     Owned contract interface
9 */
10 interface IOwned {
11     // this function isn't since the compiler emits automatically generated getter functions as external
12     function owner() external view returns (address);
13 
14     function transferOwnership(address _newOwner) external;
15     function acceptOwnership() external;
16 }
17 
18 // File: solidity/contracts/utility/Owned.sol
19 
20 
21 pragma solidity 0.6.12;
22 
23 
24 /**
25   * @dev Provides support and utilities for contract ownership
26 */
27 contract Owned is IOwned {
28     address public override owner;
29     address public newOwner;
30 
31     /**
32       * @dev triggered when the owner is updated
33       *
34       * @param _prevOwner previous owner
35       * @param _newOwner  new owner
36     */
37     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
38 
39     /**
40       * @dev initializes a new Owned instance
41     */
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     // allows execution by the owner only
47     modifier ownerOnly {
48         _ownerOnly();
49         _;
50     }
51 
52     // error message binary size optimization
53     function _ownerOnly() internal view {
54         require(msg.sender == owner, "ERR_ACCESS_DENIED");
55     }
56 
57     /**
58       * @dev allows transferring the contract ownership
59       * the new owner still needs to accept the transfer
60       * can only be called by the contract owner
61       *
62       * @param _newOwner    new contract owner
63     */
64     function transferOwnership(address _newOwner) public override ownerOnly {
65         require(_newOwner != owner, "ERR_SAME_OWNER");
66         newOwner = _newOwner;
67     }
68 
69     /**
70       * @dev used by a new owner to accept an ownership transfer
71     */
72     function acceptOwnership() override public {
73         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
74         emit OwnerUpdate(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 // File: solidity/contracts/utility/Utils.sol
81 
82 
83 pragma solidity 0.6.12;
84 
85 /**
86   * @dev Utilities & Common Modifiers
87 */
88 contract Utils {
89     // verifies that a value is greater than zero
90     modifier greaterThanZero(uint256 _value) {
91         _greaterThanZero(_value);
92         _;
93     }
94 
95     // error message binary size optimization
96     function _greaterThanZero(uint256 _value) internal pure {
97         require(_value > 0, "ERR_ZERO_VALUE");
98     }
99 
100     // validates an address - currently only checks that it isn't null
101     modifier validAddress(address _address) {
102         _validAddress(_address);
103         _;
104     }
105 
106     // error message binary size optimization
107     function _validAddress(address _address) internal pure {
108         require(_address != address(0), "ERR_INVALID_ADDRESS");
109     }
110 
111     // verifies that the address is different than this contract address
112     modifier notThis(address _address) {
113         _notThis(_address);
114         _;
115     }
116 
117     // error message binary size optimization
118     function _notThis(address _address) internal view {
119         require(_address != address(this), "ERR_ADDRESS_IS_SELF");
120     }
121 }
122 
123 // File: solidity/contracts/utility/interfaces/IContractRegistry.sol
124 
125 
126 pragma solidity 0.6.12;
127 
128 /*
129     Contract Registry interface
130 */
131 interface IContractRegistry {
132     function addressOf(bytes32 _contractName) external view returns (address);
133 }
134 
135 // File: solidity/contracts/utility/ContractRegistryClient.sol
136 
137 
138 pragma solidity 0.6.12;
139 
140 
141 
142 
143 /**
144   * @dev Base contract for ContractRegistry clients
145 */
146 contract ContractRegistryClient is Owned, Utils {
147     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
148     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
149     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
150     bytes32 internal constant CONVERTER_FACTORY = "ConverterFactory";
151     bytes32 internal constant CONVERSION_PATH_FINDER = "ConversionPathFinder";
152     bytes32 internal constant CONVERTER_UPGRADER = "BancorConverterUpgrader";
153     bytes32 internal constant CONVERTER_REGISTRY = "BancorConverterRegistry";
154     bytes32 internal constant CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
155     bytes32 internal constant BNT_TOKEN = "BNTToken";
156     bytes32 internal constant BANCOR_X = "BancorX";
157     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
158     bytes32 internal constant CHAINLINK_ORACLE_WHITELIST = "ChainlinkOracleWhitelist";
159 
160     IContractRegistry public registry;      // address of the current contract-registry
161     IContractRegistry public prevRegistry;  // address of the previous contract-registry
162     bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry
163 
164     /**
165       * @dev verifies that the caller is mapped to the given contract name
166       *
167       * @param _contractName    contract name
168     */
169     modifier only(bytes32 _contractName) {
170         _only(_contractName);
171         _;
172     }
173 
174     // error message binary size optimization
175     function _only(bytes32 _contractName) internal view {
176         require(msg.sender == addressOf(_contractName), "ERR_ACCESS_DENIED");
177     }
178 
179     /**
180       * @dev initializes a new ContractRegistryClient instance
181       *
182       * @param  _registry   address of a contract-registry contract
183     */
184     constructor(IContractRegistry _registry) internal validAddress(address(_registry)) {
185         registry = IContractRegistry(_registry);
186         prevRegistry = IContractRegistry(_registry);
187     }
188 
189     /**
190       * @dev updates to the new contract-registry
191      */
192     function updateRegistry() public {
193         // verify that this function is permitted
194         require(msg.sender == owner || !onlyOwnerCanUpdateRegistry, "ERR_ACCESS_DENIED");
195 
196         // get the new contract-registry
197         IContractRegistry newRegistry = IContractRegistry(addressOf(CONTRACT_REGISTRY));
198 
199         // verify that the new contract-registry is different and not zero
200         require(newRegistry != registry && address(newRegistry) != address(0), "ERR_INVALID_REGISTRY");
201 
202         // verify that the new contract-registry is pointing to a non-zero contract-registry
203         require(newRegistry.addressOf(CONTRACT_REGISTRY) != address(0), "ERR_INVALID_REGISTRY");
204 
205         // save a backup of the current contract-registry before replacing it
206         prevRegistry = registry;
207 
208         // replace the current contract-registry with the new contract-registry
209         registry = newRegistry;
210     }
211 
212     /**
213       * @dev restores the previous contract-registry
214     */
215     function restoreRegistry() public ownerOnly {
216         // restore the previous contract-registry
217         registry = prevRegistry;
218     }
219 
220     /**
221       * @dev restricts the permission to update the contract-registry
222       *
223       * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
224     */
225     function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) public ownerOnly {
226         // change the permission to update the contract-registry
227         onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
228     }
229 
230     /**
231       * @dev returns the address associated with the given contract name
232       *
233       * @param _contractName    contract name
234       *
235       * @return contract address
236     */
237     function addressOf(bytes32 _contractName) internal view returns (address) {
238         return registry.addressOf(_contractName);
239     }
240 }
241 
242 // File: solidity/contracts/utility/ReentrancyGuard.sol
243 
244 
245 pragma solidity 0.6.12;
246 
247 /**
248   * @dev ReentrancyGuard
249   *
250   * The contract provides protection against re-entrancy - calling a function (directly or
251   * indirectly) from within itself.
252 */
253 contract ReentrancyGuard {
254     uint256 private constant UNLOCKED = 1;
255     uint256 private constant LOCKED = 2;
256 
257     // LOCKED while protected code is being executed, UNLOCKED otherwise
258     uint256 private state = UNLOCKED;
259 
260     /**
261       * @dev ensures instantiation only by sub-contracts
262     */
263     constructor() internal {}
264 
265     // protects a function against reentrancy attacks
266     modifier protected() {
267         _protected();
268         state = LOCKED;
269         _;
270         state = UNLOCKED;
271     }
272 
273     // error message binary size optimization
274     function _protected() internal view {
275         require(state == UNLOCKED, "ERR_REENTRANCY");
276     }
277 }
278 
279 // File: solidity/contracts/utility/SafeMath.sol
280 
281 
282 pragma solidity 0.6.12;
283 
284 /**
285   * @dev Library for basic math operations with overflow/underflow protection
286 */
287 library SafeMath {
288     /**
289       * @dev returns the sum of _x and _y, reverts if the calculation overflows
290       *
291       * @param _x   value 1
292       * @param _y   value 2
293       *
294       * @return sum
295     */
296     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
297         uint256 z = _x + _y;
298         require(z >= _x, "ERR_OVERFLOW");
299         return z;
300     }
301 
302     /**
303       * @dev returns the difference of _x minus _y, reverts if the calculation underflows
304       *
305       * @param _x   minuend
306       * @param _y   subtrahend
307       *
308       * @return difference
309     */
310     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
311         require(_x >= _y, "ERR_UNDERFLOW");
312         return _x - _y;
313     }
314 
315     /**
316       * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
317       *
318       * @param _x   factor 1
319       * @param _y   factor 2
320       *
321       * @return product
322     */
323     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
324         // gas optimization
325         if (_x == 0)
326             return 0;
327 
328         uint256 z = _x * _y;
329         require(z / _x == _y, "ERR_OVERFLOW");
330         return z;
331     }
332 
333     /**
334       * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
335       *
336       * @param _x   dividend
337       * @param _y   divisor
338       *
339       * @return quotient
340     */
341     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
342         require(_y > 0, "ERR_DIVIDE_BY_ZERO");
343         uint256 c = _x / _y;
344         return c;
345     }
346 }
347 
348 // File: solidity/contracts/utility/Math.sol
349 
350 
351 pragma solidity 0.6.12;
352 
353 
354 /**
355   * @dev Library for complex math operations
356 */
357 library Math {
358     using SafeMath for uint256;
359 
360     /**
361       * @dev returns the largest integer smaller than or equal to the square root of a positive integer
362       *
363       * @param _num a positive integer
364       *
365       * @return the largest integer smaller than or equal to the square root of the positive integer
366     */
367     function floorSqrt(uint256 _num) internal pure returns (uint256) {
368         uint256 x = _num / 2 + 1;
369         uint256 y = (x + _num / x) / 2;
370         while (x > y) {
371             x = y;
372             y = (x + _num / x) / 2;
373         }
374         return x;
375     }
376 
377     /**
378       * @dev computes a reduced-scalar ratio
379       *
380       * @param _n   ratio numerator
381       * @param _d   ratio denominator
382       * @param _max maximum desired scalar
383       *
384       * @return ratio's numerator and denominator
385     */
386     function reducedRatio(uint256 _n, uint256 _d, uint256 _max) internal pure returns (uint256, uint256) {
387         if (_n > _max || _d > _max)
388             return normalizedRatio(_n, _d, _max);
389         return (_n, _d);
390     }
391 
392     /**
393       * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)".
394     */
395     function normalizedRatio(uint256 _a, uint256 _b, uint256 _scale) internal pure returns (uint256, uint256) {
396         if (_a == _b)
397             return (_scale / 2, _scale / 2);
398         if (_a < _b)
399             return accurateRatio(_a, _b, _scale);
400         (uint256 y, uint256 x) = accurateRatio(_b, _a, _scale);
401         return (x, y);
402     }
403 
404     /**
405       * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)", assuming that "a < b".
406     */
407     function accurateRatio(uint256 _a, uint256 _b, uint256 _scale) internal pure returns (uint256, uint256) {
408         uint256 maxVal = uint256(-1) / _scale;
409         if (_a > maxVal) {
410             uint256 c = _a / (maxVal + 1) + 1;
411             _a /= c;
412             _b /= c;
413         }
414         uint256 x = roundDiv(_a * _scale, _a.add(_b));
415         uint256 y = _scale - x;
416         return (x, y);
417     }
418 
419     /**
420       * @dev computes the nearest integer to a given quotient without overflowing or underflowing.
421     */
422     function roundDiv(uint256 _n, uint256 _d) internal pure returns (uint256) {
423         return _n / _d + _n % _d / (_d - _d / 2);
424     }
425 
426     /**
427       * @dev returns the average number of decimal digits in a given list of positive integers
428       *
429       * @param _values  list of positive integers
430       *
431       * @return the average number of decimal digits in the given list of positive integers
432     */
433     function geometricMean(uint256[] memory _values) internal pure returns (uint256) {
434         uint256 numOfDigits = 0;
435         uint256 length = _values.length;
436         for (uint256 i = 0; i < length; i++)
437             numOfDigits += decimalLength(_values[i]);
438         return uint256(10) ** (roundDivUnsafe(numOfDigits, length) - 1);
439     }
440 
441     /**
442       * @dev returns the number of decimal digits in a given positive integer
443       *
444       * @param _x   positive integer
445       *
446       * @return the number of decimal digits in the given positive integer
447     */
448     function decimalLength(uint256 _x) internal pure returns (uint256) {
449         uint256 y = 0;
450         for (uint256 x = _x; x > 0; x /= 10)
451             y++;
452         return y;
453     }
454 
455     /**
456       * @dev returns the nearest integer to a given quotient
457       * the computation is overflow-safe assuming that the input is sufficiently small
458       *
459       * @param _n   quotient numerator
460       * @param _d   quotient denominator
461       *
462       * @return the nearest integer to the given quotient
463     */
464     function roundDivUnsafe(uint256 _n, uint256 _d) internal pure returns (uint256) {
465         return (_n + _d / 2) / _d;
466     }
467 }
468 
469 // File: solidity/contracts/token/interfaces/IERC20Token.sol
470 
471 
472 pragma solidity 0.6.12;
473 
474 /*
475     ERC20 Standard Token interface
476 */
477 interface IERC20Token {
478     function name() external view returns (string memory);
479     function symbol() external view returns (string memory);
480     function decimals() external view returns (uint8);
481     function totalSupply() external view returns (uint256);
482     function balanceOf(address _owner) external view returns (uint256);
483     function allowance(address _owner, address _spender) external view returns (uint256);
484 
485     function transfer(address _to, uint256 _value) external returns (bool);
486     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
487     function approve(address _spender, uint256 _value) external returns (bool);
488 }
489 
490 // File: solidity/contracts/utility/TokenHandler.sol
491 
492 
493 pragma solidity 0.6.12;
494 
495 
496 contract TokenHandler {
497     bytes4 private constant APPROVE_FUNC_SELECTOR = bytes4(keccak256("approve(address,uint256)"));
498     bytes4 private constant TRANSFER_FUNC_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
499     bytes4 private constant TRANSFER_FROM_FUNC_SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));
500 
501     /**
502       * @dev executes the ERC20 token's `approve` function and reverts upon failure
503       * the main purpose of this function is to prevent a non standard ERC20 token
504       * from failing silently
505       *
506       * @param _token   ERC20 token address
507       * @param _spender approved address
508       * @param _value   allowance amount
509     */
510     function safeApprove(IERC20Token _token, address _spender, uint256 _value) internal {
511         (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(APPROVE_FUNC_SELECTOR, _spender, _value));
512         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_APPROVE_FAILED');
513     }
514 
515     /**
516       * @dev executes the ERC20 token's `transfer` function and reverts upon failure
517       * the main purpose of this function is to prevent a non standard ERC20 token
518       * from failing silently
519       *
520       * @param _token   ERC20 token address
521       * @param _to      target address
522       * @param _value   transfer amount
523     */
524     function safeTransfer(IERC20Token _token, address _to, uint256 _value) internal {
525        (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(TRANSFER_FUNC_SELECTOR, _to, _value));
526         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_TRANSFER_FAILED');
527     }
528 
529     /**
530       * @dev executes the ERC20 token's `transferFrom` function and reverts upon failure
531       * the main purpose of this function is to prevent a non standard ERC20 token
532       * from failing silently
533       *
534       * @param _token   ERC20 token address
535       * @param _from    source address
536       * @param _to      target address
537       * @param _value   transfer amount
538     */
539     function safeTransferFrom(IERC20Token _token, address _from, address _to, uint256 _value) internal {
540        (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value));
541         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_TRANSFER_FROM_FAILED');
542     }
543 }
544 
545 // File: solidity/contracts/utility/Types.sol
546 
547 
548 pragma solidity 0.6.12;
549 
550 /**
551   * @dev Provides types that can be used by various contracts
552 */
553 
554 struct Fraction {
555     uint256 n;  // numerator
556     uint256 d;  // denominator
557 }
558 
559 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
560 
561 
562 pragma solidity 0.6.12;
563 
564 
565 /*
566     Converter Anchor interface
567 */
568 interface IConverterAnchor is IOwned {
569 }
570 
571 // File: solidity/contracts/token/interfaces/IDSToken.sol
572 
573 
574 pragma solidity 0.6.12;
575 
576 
577 
578 
579 /*
580     DSToken interface
581 */
582 interface IDSToken is IConverterAnchor, IERC20Token {
583     function issue(address _to, uint256 _amount) external;
584     function destroy(address _from, uint256 _amount) external;
585 }
586 
587 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionStore.sol
588 
589 
590 pragma solidity 0.6.12;
591 
592 
593 
594 
595 
596 /*
597     Liquidity Protection Store interface
598 */
599 interface ILiquidityProtectionStore is IOwned {
600     function addPoolToWhitelist(IConverterAnchor _anchor) external;
601     function removePoolFromWhitelist(IConverterAnchor _anchor) external;
602     function isPoolWhitelisted(IConverterAnchor _anchor) external view returns (bool);
603 
604     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) external;
605 
606     function protectedLiquidity(uint256 _id)
607         external
608         view
609         returns (address, IDSToken, IERC20Token, uint256, uint256, uint256, uint256, uint256);
610 
611     function addProtectedLiquidity(
612         address _provider,
613         IDSToken _poolToken,
614         IERC20Token _reserveToken,
615         uint256 _poolAmount,
616         uint256 _reserveAmount,
617         uint256 _reserveRateN,
618         uint256 _reserveRateD,
619         uint256 _timestamp
620     ) external returns (uint256);
621 
622     function updateProtectedLiquidityAmounts(uint256 _id, uint256 _poolNewAmount, uint256 _reserveNewAmount) external;
623     function removeProtectedLiquidity(uint256 _id) external;
624     
625     function lockedBalance(address _provider, uint256 _index) external view returns (uint256, uint256);
626     function lockedBalanceRange(address _provider, uint256 _startIndex, uint256 _endIndex) external view returns (uint256[] memory, uint256[] memory);
627 
628     function addLockedBalance(address _provider, uint256 _reserveAmount, uint256 _expirationTime) external returns (uint256);
629     function removeLockedBalance(address _provider, uint256 _index) external;
630 
631     function systemBalance(IERC20Token _poolToken) external view returns (uint256);
632     function incSystemBalance(IERC20Token _poolToken, uint256 _poolAmount) external;
633     function decSystemBalance(IERC20Token _poolToken, uint256 _poolAmount ) external;
634 }
635 
636 // File: solidity/contracts/utility/interfaces/IWhitelist.sol
637 
638 
639 pragma solidity 0.6.12;
640 
641 /*
642     Whitelist interface
643 */
644 interface IWhitelist {
645     function isWhitelisted(address _address) external view returns (bool);
646 }
647 
648 // File: solidity/contracts/converter/interfaces/IConverter.sol
649 
650 
651 pragma solidity 0.6.12;
652 
653 
654 
655 
656 
657 /*
658     Converter interface
659 */
660 interface IConverter is IOwned {
661     function converterType() external pure returns (uint16);
662     function anchor() external view returns (IConverterAnchor);
663     function isActive() external view returns (bool);
664 
665     function targetAmountAndFee(IERC20Token _sourceToken, IERC20Token _targetToken, uint256 _amount) external view returns (uint256, uint256);
666     function convert(IERC20Token _sourceToken,
667                      IERC20Token _targetToken,
668                      uint256 _amount,
669                      address _trader,
670                      address payable _beneficiary) external payable returns (uint256);
671 
672     function conversionWhitelist() external view returns (IWhitelist);
673     function conversionFee() external view returns (uint32);
674     function maxConversionFee() external view returns (uint32);
675     function reserveBalance(IERC20Token _reserveToken) external view returns (uint256);
676     receive() external payable;
677 
678     function transferAnchorOwnership(address _newOwner) external;
679     function acceptAnchorOwnership() external;
680     function setConversionFee(uint32 _conversionFee) external;
681     function setConversionWhitelist(IWhitelist _whitelist) external;
682     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) external;
683     function withdrawETH(address payable _to) external;
684     function addReserve(IERC20Token _token, uint32 _ratio) external;
685 
686     // deprecated, backward compatibility
687     function token() external view returns (IConverterAnchor);
688     function transferTokenOwnership(address _newOwner) external;
689     function acceptTokenOwnership() external;
690     function connectors(IERC20Token _address) external view returns (uint256, uint32, bool, bool, bool);
691     function getConnectorBalance(IERC20Token _connectorToken) external view returns (uint256);
692     function connectorTokens(uint256 _index) external view returns (IERC20Token);
693     function connectorTokenCount() external view returns (uint16);
694 }
695 
696 // File: solidity/contracts/converter/interfaces/IConverterRegistry.sol
697 
698 
699 pragma solidity 0.6.12;
700 
701 
702 
703 interface IConverterRegistry {
704     function getAnchorCount() external view returns (uint256);
705     function getAnchors() external view returns (address[] memory);
706     function getAnchor(uint256 _index) external view returns (IConverterAnchor);
707     function isAnchor(address _value) external view returns (bool);
708 
709     function getLiquidityPoolCount() external view returns (uint256);
710     function getLiquidityPools() external view returns (address[] memory);
711     function getLiquidityPool(uint256 _index) external view returns (IConverterAnchor);
712     function isLiquidityPool(address _value) external view returns (bool);
713 
714     function getConvertibleTokenCount() external view returns (uint256);
715     function getConvertibleTokens() external view returns (address[] memory);
716     function getConvertibleToken(uint256 _index) external view returns (IERC20Token);
717     function isConvertibleToken(address _value) external view returns (bool);
718 
719     function getConvertibleTokenAnchorCount(IERC20Token _convertibleToken) external view returns (uint256);
720     function getConvertibleTokenAnchors(IERC20Token _convertibleToken) external view returns (address[] memory);
721     function getConvertibleTokenAnchor(IERC20Token _convertibleToken, uint256 _index) external view returns (IConverterAnchor);
722     function isConvertibleTokenAnchor(IERC20Token _convertibleToken, address _value) external view returns (bool);
723 }
724 
725 // File: solidity/contracts/liquidity-protection/LiquidityProtection.sol
726 
727 
728 pragma solidity 0.6.12;
729 
730 
731 
732 
733 
734 
735 
736 
737 
738 
739 
740 
741 
742 
743 interface ILiquidityPoolV1Converter is IConverter {
744     function addLiquidity(IERC20Token[] memory _reserveTokens, uint256[] memory _reserveAmounts, uint256 _minReturn) external payable;
745     function removeLiquidity(uint256 _amount, IERC20Token[] memory _reserveTokens, uint256[] memory _reserveMinReturnAmounts) external;
746     function recentAverageRate(IERC20Token _reserveToken) external view returns (uint256, uint256);
747 }
748 
749 /**
750   * @dev Liquidity Protection
751 */
752 contract LiquidityProtection is TokenHandler, ContractRegistryClient, ReentrancyGuard {
753     using SafeMath for uint256;
754     using Math for *;
755 
756     struct ProtectedLiquidity {
757         address provider;           // liquidity provider
758         IDSToken poolToken;         // pool token address
759         IERC20Token reserveToken;   // reserve token address
760         uint256 poolAmount;         // pool token amount
761         uint256 reserveAmount;      // reserve token amount
762         uint256 reserveRateN;       // rate of 1 protected reserve token in units of the other reserve token (numerator)
763         uint256 reserveRateD;       // rate of 1 protected reserve token in units of the other reserve token (denominator)
764         uint256 timestamp;          // timestamp
765     }
766 
767     IERC20Token internal constant ETH_RESERVE_ADDRESS = IERC20Token(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
768     uint32 internal constant PPM_RESOLUTION = 1000000;
769     uint256 internal constant MAX_UINT128 = 0xffffffffffffffffffffffffffffffff;
770 
771     // the address of the whitelist administrator
772     address public whitelistAdmin;
773 
774     ILiquidityProtectionStore public immutable store;
775     IDSToken public immutable networkToken;
776     IDSToken public immutable govToken;
777 
778     // system network token balance limits
779     uint256 public maxSystemNetworkTokenAmount = 500000e18;
780     uint32 public maxSystemNetworkTokenRatio = 500000; // PPM units
781 
782     // number of seconds until any protection is in effect
783     uint256 public minProtectionDelay = 30 days;
784 
785     // number of seconds until full protection is in effect
786     uint256 public maxProtectionDelay = 100 days;
787 
788     // minimum amount of network tokens the system can mint as compensation for base token losses, default = 0.01 network tokens
789     uint256 public minNetworkCompensation = 1e16;
790 
791     // number of seconds from liquidation to full network token release
792     uint256 public lockDuration = 24 hours;
793 
794     // maximum deviation of the average rate from the actual rate
795     uint32 public averageRateMaxDeviation = 20000; // PPM units
796 
797     // true if the contract is currently adding/removing liquidity from a converter, used for accepting ETH
798     bool private updatingLiquidity = false;
799 
800     /**
801       * @dev triggered when whitelist admin is updated
802       *
803       * @param _prevWhitelistAdmin  previous whitelist admin
804       * @param _newWhitelistAdmin   new whitelist admin
805     */
806     event WhitelistAdminUpdated(
807         address indexed _prevWhitelistAdmin,
808         address indexed _newWhitelistAdmin
809     );
810 
811     /**
812       * @dev triggered when the system network token balance limits are updated
813       *
814       * @param _prevMaxSystemNetworkTokenAmount  previous maximum absolute balance in a pool
815       * @param _newMaxSystemNetworkTokenAmount   new maximum absolute balance in a pool
816       * @param _prevMaxSystemNetworkTokenRatio   previos maximum balance out of the total balance in a pool
817       * @param _newMaxSystemNetworkTokenRatio    new maximum balance out of the total balance in a pool
818     */
819     event SystemNetworkTokenLimitsUpdated(
820         uint256 _prevMaxSystemNetworkTokenAmount,
821         uint256 _newMaxSystemNetworkTokenAmount,
822         uint256 _prevMaxSystemNetworkTokenRatio,
823         uint256 _newMaxSystemNetworkTokenRatio
824     );
825 
826     /**
827       * @dev triggered when the protection delays are updated
828       *
829       * @param _prevMinProtectionDelay  previous seconds until the protection starts
830       * @param _newMinProtectionDelay   new seconds until the protection starts
831       * @param _prevMaxProtectionDelay  previos seconds until full protection
832       * @param _newMaxProtectionDelay   new seconds until full protection
833     */
834     event ProtectionDelaysUpdated(
835         uint256 _prevMinProtectionDelay,
836         uint256 _newMinProtectionDelay,
837         uint256 _prevMaxProtectionDelay,
838         uint256 _newMaxProtectionDelay
839     );
840 
841     /**
842       * @dev triggered when the minimum network token compensation is updated
843       *
844       * @param _prevMinNetworkCompensation  previous minimum network token compensation
845       * @param _newMinNetworkCompensation   new minimum network token compensation
846     */
847     event MinNetworkCompensationUpdated(
848         uint256 _prevMinNetworkCompensation,
849         uint256 _newMinNetworkCompensation
850     );
851 
852     /**
853       * @dev triggered when the network token lock duration is updated
854       *
855       * @param _prevLockDuration  previous network token lock duration, in seconds
856       * @param _newLockDuration   new network token lock duration, in seconds
857     */
858     event LockDurationUpdated(
859         uint256 _prevLockDuration,
860         uint256 _newLockDuration
861     );
862 
863     /**
864       * @dev triggered when the maximum deviation of the average rate from the actual rate is updated
865       *
866       * @param _prevAverageRateMaxDeviation previous maximum deviation of the average rate from the actual rate
867       * @param _newAverageRateMaxDeviation  new maximum deviation of the average rate from the actual rate
868     */
869     event AverageRateMaxDeviationUpdated(
870         uint32 _prevAverageRateMaxDeviation,
871         uint32 _newAverageRateMaxDeviation
872     );
873 
874     /**
875       * @dev initializes a new LiquidityProtection contract
876       *
877       * @param _store           liquidity protection store
878       * @param _networkToken    network token 
879       * @param _govToken        governance token
880       * @param _registry        contract registry
881     */
882     constructor(
883         ILiquidityProtectionStore _store,
884         IDSToken _networkToken,
885         IDSToken _govToken,
886         IContractRegistry _registry)
887         ContractRegistryClient(_registry)
888         public
889         validAddress(address(_store))
890         validAddress(address(_networkToken))
891         validAddress(address(_govToken))
892         validAddress(address(_registry))
893         notThis(address(_store))
894         notThis(address(_networkToken))
895         notThis(address(_govToken))
896         notThis(address(_registry))
897     {
898         whitelistAdmin = msg.sender;
899         store = _store;
900         networkToken = _networkToken;
901         govToken = _govToken;
902     }
903 
904     // ensures that the contract is currently removing liquidity from a converter
905     modifier updatingLiquidityOnly() {
906         _updatingLiquidityOnly();
907         _;
908     }
909 
910     // error message binary size optimization
911     function _updatingLiquidityOnly() internal view {
912         require(updatingLiquidity, "ERR_NOT_UPDATING_LIQUIDITY");
913     }
914 
915     /**
916       * @dev accept ETH
917       * used when removing liquidity from ETH converters
918     */
919     receive() external payable updatingLiquidityOnly() {
920     }
921 
922     /**
923       * @dev transfers the ownership of the store
924       * can only be called by the contract owner
925       *
926       * @param _newOwner    the new owner of the store
927     */
928     function transferStoreOwnership(address _newOwner) external ownerOnly {
929         store.transferOwnership(_newOwner);
930     }
931 
932     /**
933       * @dev accepts the ownership of the store
934       * can only be called by the contract owner
935     */
936     function acceptStoreOwnership() external ownerOnly {
937         store.acceptOwnership();
938     }
939 
940     /**
941       * @dev transfers the ownership of the network token
942       * can only be called by the contract owner
943       *
944       * @param _newOwner    the new owner of the network token
945     */
946     function transferNetworkTokenOwnership(address _newOwner) external ownerOnly {
947         networkToken.transferOwnership(_newOwner);
948     }
949 
950     /**
951       * @dev accepts the ownership of the network token
952       * can only be called by the contract owner
953     */
954     function acceptNetworkTokenOwnership() external ownerOnly {
955         networkToken.acceptOwnership();
956     }
957 
958     /**
959       * @dev transfers the ownership of the governance token
960       * can only be called by the contract owner
961       *
962       * @param _newOwner    the new owner of the governance token
963     */
964     function transferGovTokenOwnership(address _newOwner) external ownerOnly {
965         govToken.transferOwnership(_newOwner);
966     }
967 
968     /**
969       * @dev accepts the ownership of the governance token
970       * can only be called by the contract owner
971     */
972     function acceptGovTokenOwnership() external ownerOnly {
973         govToken.acceptOwnership();
974     }
975 
976     /**
977       * @dev set the address of the whitelist admin
978       * can only be called by the contract owner
979       *
980       * @param _whitelistAdmin  the address of the new whitelist admin
981     */
982     function setWhitelistAdmin(address _whitelistAdmin)
983         external
984         ownerOnly
985         validAddress(_whitelistAdmin)
986     {
987         emit WhitelistAdminUpdated(whitelistAdmin, _whitelistAdmin);
988 
989         whitelistAdmin = _whitelistAdmin;
990     }
991 
992     /**
993       * @dev updates the system network token balance limits
994       * can only be called by the contract owner
995       *
996       * @param _maxSystemNetworkTokenAmount  maximum absolute balance in a pool
997       * @param _maxSystemNetworkTokenRatio   maximum balance out of the total balance in a pool (in PPM units)
998     */
999     function setSystemNetworkTokenLimits(uint256 _maxSystemNetworkTokenAmount, uint32 _maxSystemNetworkTokenRatio) external ownerOnly {
1000         require(_maxSystemNetworkTokenRatio <= PPM_RESOLUTION, "ERR_INVALID_MAX_RATIO");
1001 
1002         emit SystemNetworkTokenLimitsUpdated(maxSystemNetworkTokenAmount, _maxSystemNetworkTokenAmount, maxSystemNetworkTokenRatio,
1003             _maxSystemNetworkTokenRatio);
1004 
1005         maxSystemNetworkTokenAmount = _maxSystemNetworkTokenAmount;
1006         maxSystemNetworkTokenRatio = _maxSystemNetworkTokenRatio;
1007     }
1008 
1009     /**
1010       * @dev updates the protection delays
1011       * can only be called by the contract owner
1012       *
1013       * @param _minProtectionDelay  seconds until the protection starts
1014       * @param _maxProtectionDelay  seconds until full protection
1015     */
1016     function setProtectionDelays(uint256 _minProtectionDelay, uint256 _maxProtectionDelay) external ownerOnly {
1017         require(_minProtectionDelay < _maxProtectionDelay, "ERR_INVALID_PROTECTION_DELAY");
1018 
1019         emit ProtectionDelaysUpdated(minProtectionDelay, _minProtectionDelay, maxProtectionDelay, _maxProtectionDelay);
1020 
1021         minProtectionDelay = _minProtectionDelay;
1022         maxProtectionDelay = _maxProtectionDelay;
1023     }
1024 
1025     /**
1026       * @dev updates the minimum network token compensation
1027       * can only be called by the contract owner
1028       *
1029       * @param _minCompensation new minimum compensation
1030     */
1031     function setMinNetworkCompensation(uint256 _minCompensation) external ownerOnly {
1032         emit MinNetworkCompensationUpdated(minNetworkCompensation, _minCompensation);
1033 
1034         minNetworkCompensation = _minCompensation;
1035     }
1036 
1037     /**
1038       * @dev updates the network token lock duration
1039       * can only be called by the contract owner
1040       *
1041       * @param _lockDuration    network token lock duration, in seconds
1042     */
1043     function setLockDuration(uint256 _lockDuration) external ownerOnly {
1044         emit LockDurationUpdated(lockDuration, _lockDuration);
1045 
1046         lockDuration = _lockDuration;
1047     }
1048 
1049     /**
1050       * @dev sets the maximum deviation of the average rate from the actual rate
1051       * can only be called by the contract owner
1052       *
1053       * @param _averageRateMaxDeviation maximum deviation of the average rate from the actual rate
1054     */
1055     function setAverageRateMaxDeviation(uint32 _averageRateMaxDeviation) external ownerOnly {
1056         require(_averageRateMaxDeviation <= PPM_RESOLUTION, "ERR_INVALID_MAX_DEVIATION");
1057         emit AverageRateMaxDeviationUpdated(averageRateMaxDeviation, _averageRateMaxDeviation);
1058 
1059         averageRateMaxDeviation = _averageRateMaxDeviation;
1060     }
1061 
1062     /**
1063       * @dev adds a pool to the whitelist, or removes a pool from the whitelist
1064       * note that when a pool is whitelisted, it's not possible to remove liquidity anymore
1065       * removing a pool from the whitelist is an extreme measure in case of a base token compromise etc.
1066       * can only be called by the whitelist admin
1067       *
1068       * @param _poolAnchor  anchor of the pool
1069       * @param _add         true to add the pool to the whitelist, false to remove it from the whitelist
1070     */
1071     function whitelistPool(IConverterAnchor _poolAnchor, bool _add) external {
1072         require(msg.sender == whitelistAdmin || msg.sender == owner, "ERR_ACCESS_DENIED");
1073 
1074         // verify that the pool is supported
1075         require(isPoolSupported(_poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1076 
1077         // add or remove the pool to/from the whitelist
1078         if (_add)
1079             store.addPoolToWhitelist(_poolAnchor);
1080         else
1081             store.removePoolFromWhitelist(_poolAnchor);
1082     }
1083 
1084     /**
1085       * @dev checks if protection is supported for the given pool
1086       * only standard pools are supported (2 reserves, 50%/50% weights)
1087       * note that the pool should still be whitelisted
1088       *
1089       * @param _poolAnchor  anchor of the pool
1090       * @return true if the pool is supported, false otherwise
1091     */
1092     function isPoolSupported(IConverterAnchor _poolAnchor) public view returns (bool) {
1093         // verify that the pool exists in the registry
1094         IConverterRegistry converterRegistry = IConverterRegistry(addressOf(CONVERTER_REGISTRY));
1095         require(converterRegistry.isAnchor(address(_poolAnchor)), "ERR_INVALID_ANCHOR");
1096 
1097         // get the converter
1098         IConverter converter = IConverter(payable(_poolAnchor.owner()));
1099 
1100         // verify that the converter has 2 reserves
1101         if (converter.connectorTokenCount() != 2) {
1102             return false;
1103         }
1104 
1105         // verify that one of the reserves is the network token
1106         IERC20Token reserve0Token = converter.connectorTokens(0);
1107         IERC20Token reserve1Token = converter.connectorTokens(1);
1108         if (reserve0Token != networkToken && reserve1Token != networkToken) {
1109             return false;
1110         }
1111 
1112         // verify that the reserve weights are exactly 50%/50%
1113         if (converterReserveWeight(converter, reserve0Token) != PPM_RESOLUTION / 2 ||
1114             converterReserveWeight(converter, reserve1Token) != PPM_RESOLUTION / 2) {
1115             return false;
1116         }
1117 
1118         return true;
1119     }
1120 
1121     /**
1122       * @dev adds protection to existing pool tokens
1123       * also mints new governance tokens for the caller
1124       *
1125       * @param _poolAnchor  anchor of the pool
1126       * @param _amount      amount of pool tokens to protect
1127     */
1128     function protectLiquidity(IConverterAnchor _poolAnchor, uint256 _amount)
1129         external
1130         protected
1131         greaterThanZero(_amount)
1132     {
1133         // verify that the pool is supported
1134         require(isPoolSupported(_poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1135         require(store.isPoolWhitelisted(_poolAnchor), "ERR_POOL_NOT_WHITELISTED");
1136 
1137         // get the converter
1138         IConverter converter = IConverter(payable(_poolAnchor.owner()));
1139 
1140         // protect both reserves
1141         IDSToken poolToken = IDSToken(address(_poolAnchor));
1142         protectLiquidity(poolToken, converter, 0, _amount / 2);
1143         protectLiquidity(poolToken, converter, 1, _amount - _amount / 2);
1144 
1145         // transfer the pool tokens from the caller directly to the store
1146         safeTransferFrom(poolToken, msg.sender, address(store), _amount);
1147     }
1148 
1149     /**
1150       * @dev cancels the protection and returns the pool tokens to the caller
1151       * also burns governance tokens from the caller
1152       * must be called with the indices of both the base token and the network token protections
1153       *
1154       * @param _id1 id in the caller's list of protected liquidity
1155       * @param _id2 matching id in the caller's list of protected liquidity
1156     */
1157     function unprotectLiquidity(uint256 _id1, uint256 _id2) external protected {
1158         require(_id1 != _id2, "ERR_SAME_ID");
1159 
1160         ProtectedLiquidity memory liquidity1 = protectedLiquidity(_id1);
1161         ProtectedLiquidity memory liquidity2 = protectedLiquidity(_id2);
1162 
1163         // verify input & permissions
1164         require(liquidity1.provider == msg.sender && liquidity2.provider == msg.sender, "ERR_ACCESS_DENIED");
1165 
1166         // verify that the two protections were added together (using `protect`)
1167         require(
1168             liquidity1.poolToken == liquidity2.poolToken &&
1169             liquidity1.reserveToken != liquidity2.reserveToken &&
1170             (liquidity1.reserveToken == networkToken || liquidity2.reserveToken == networkToken) &&
1171             liquidity1.timestamp == liquidity2.timestamp &&
1172             liquidity1.poolAmount <= liquidity2.poolAmount.add(1) &&
1173             liquidity2.poolAmount <= liquidity1.poolAmount.add(1),
1174             "ERR_PROTECTIONS_MISMATCH");
1175 
1176         // burn the governance tokens from the caller
1177         govToken.destroy(msg.sender, liquidity1.reserveToken == networkToken ? liquidity1.reserveAmount : liquidity2.reserveAmount);
1178 
1179         // remove the protected liquidities from the store
1180         store.removeProtectedLiquidity(_id1);
1181         store.removeProtectedLiquidity(_id2);
1182 
1183         // transfer the pool tokens back to the caller
1184         store.withdrawTokens(liquidity1.poolToken, msg.sender, liquidity1.poolAmount.add(liquidity2.poolAmount));
1185     }
1186 
1187     /**
1188       * @dev adds protected liquidity to a pool
1189       * also mints new governance tokens for the caller if the caller adds network tokens
1190       *
1191       * @param _poolAnchor      anchor of the pool
1192       * @param _reserveToken    reserve token to add to the pool
1193       * @param _amount          amount of tokens to add to the pool
1194       * @return new protected liquidity id
1195     */
1196     function addLiquidity(IConverterAnchor _poolAnchor, IERC20Token _reserveToken, uint256 _amount)
1197         external
1198         payable
1199         protected
1200         greaterThanZero(_amount)
1201         returns (uint256)
1202     {
1203         // verify that the pool is supported & whitelisted
1204         require(isPoolSupported(_poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1205         require(store.isPoolWhitelisted(_poolAnchor), "ERR_POOL_NOT_WHITELISTED");
1206 
1207         if (_reserveToken == networkToken) {
1208             require(msg.value == 0, "ERR_ETH_AMOUNT_MISMATCH");    
1209             return addNetworkTokenLiquidity(_poolAnchor, _amount);
1210         }
1211 
1212         // verify that ETH was passed with the call if needed
1213         uint256 val = _reserveToken == ETH_RESERVE_ADDRESS ? _amount : 0;
1214         require(msg.value == val, "ERR_ETH_AMOUNT_MISMATCH");
1215         return addBaseTokenLiquidity(_poolAnchor, _reserveToken, _amount);
1216     }
1217 
1218     /**
1219       * @dev adds protected network token liquidity to a pool
1220       * also mints new governance tokens for the caller
1221       *
1222       * @param _poolAnchor  anchor of the pool
1223       * @param _amount      amount of tokens to add to the pool
1224       * @return new protected liquidity id
1225     */
1226     function addNetworkTokenLiquidity(IConverterAnchor _poolAnchor, uint256 _amount) internal returns (uint256) {
1227         IDSToken poolToken = IDSToken(address(_poolAnchor));
1228 
1229         // get the rate between the pool token and the reserve
1230         Fraction memory tokenRate = poolTokenRate(poolToken, networkToken);
1231 
1232         // calculate the amount of pool tokens based on the amount of reserve tokens
1233         uint256 poolTokenAmount = _amount.mul(tokenRate.d).div(tokenRate.n);
1234 
1235         // remove the pool tokens from the system's ownership (will revert if not enough tokens are available)
1236         store.decSystemBalance(poolToken, poolTokenAmount);
1237 
1238         // add protected liquidity for the caller
1239         uint256 id = addProtectedLiquidity(msg.sender, poolToken, networkToken, poolTokenAmount, _amount);
1240         
1241         // burns the network tokens from the caller
1242         networkToken.destroy(msg.sender, _amount);
1243 
1244         // mint governance tokens to the caller
1245         govToken.issue(msg.sender, _amount);
1246 
1247         return id;
1248     }
1249 
1250     /**
1251       * @dev adds protected base token liquidity to a pool
1252       *
1253       * @param _poolAnchor  anchor of the pool
1254       * @param _baseToken   the base reserve token of the pool
1255       * @param _amount      amount of tokens to add to the pool
1256       * @return new protected liquidity id
1257     */
1258     function addBaseTokenLiquidity(IConverterAnchor _poolAnchor, IERC20Token _baseToken, uint256 _amount) internal returns (uint256) {
1259         IDSToken poolToken = IDSToken(address(_poolAnchor));
1260 
1261         // get the reserve balances
1262         ILiquidityPoolV1Converter converter = ILiquidityPoolV1Converter(payable(_poolAnchor.owner()));
1263         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) = converterReserveBalances(converter, _baseToken, networkToken);
1264 
1265         // calculate and mint the required amount of network tokens for adding liquidity
1266         uint256 networkLiquidityAmount = _amount.mul(reserveBalanceNetwork).div(reserveBalanceBase);
1267 
1268         // verify network token limits
1269         // note that the amount is divided by 2 since it's not possible to liquidate one reserve only
1270         Fraction memory poolRate = poolTokenRate(poolToken, networkToken);
1271         uint256 newSystemBalance = store.systemBalance(poolToken);
1272         newSystemBalance = (newSystemBalance.mul(poolRate.n).div(poolRate.d) / 2).add(networkLiquidityAmount);
1273 
1274         require(newSystemBalance <= maxSystemNetworkTokenAmount, "ERR_MAX_AMOUNT_REACHED");
1275         require(newSystemBalance.mul(PPM_RESOLUTION) <= newSystemBalance.add(reserveBalanceNetwork).mul(maxSystemNetworkTokenRatio), "ERR_MAX_RATIO_REACHED");
1276 
1277         // issue new network tokens to the system
1278         networkToken.issue(address(this), networkLiquidityAmount);
1279 
1280         // transfer the base tokens from the caller and approve the converter
1281         ensureAllowance(networkToken, address(converter), networkLiquidityAmount);
1282         if (_baseToken != ETH_RESERVE_ADDRESS) {
1283             safeTransferFrom(_baseToken, msg.sender, address(this), _amount);
1284             ensureAllowance(_baseToken, address(converter), _amount);
1285         }
1286 
1287         // add liquidity
1288         addLiquidity(converter, _baseToken, networkToken, _amount, networkLiquidityAmount, msg.value);
1289 
1290         // transfer the new pool tokens to the store
1291         uint256 poolTokenAmount = poolToken.balanceOf(address(this));
1292         safeTransfer(poolToken, address(store), poolTokenAmount);
1293 
1294         // the system splits the pool tokens with the caller
1295         // increase the system's pool token balance and add protected liquidity for the caller
1296         store.incSystemBalance(poolToken, poolTokenAmount - poolTokenAmount / 2); // account for rounding errors
1297         return addProtectedLiquidity(msg.sender, poolToken, _baseToken, poolTokenAmount / 2, _amount);
1298     }
1299 
1300     /**
1301       * @dev transfers protected liquidity to a new provider
1302       *
1303       * @param _id          protected liquidity id
1304       * @param _newProvider new provider
1305       * @return new protected liquidity id
1306     */
1307     function transferLiquidity(uint256 _id, address _newProvider)
1308         external
1309         protected
1310         validAddress(_newProvider)
1311         notThis(_newProvider)
1312         returns (uint256)
1313     {
1314         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
1315 
1316         // verify input & permissions
1317         require(liquidity.provider == msg.sender, "ERR_ACCESS_DENIED");
1318         
1319         // remove the protected liquidity from the current provider
1320         store.removeProtectedLiquidity(_id);
1321 
1322         // add the protected liquidity to the new provider
1323         return store.addProtectedLiquidity(
1324             _newProvider,
1325             liquidity.poolToken,
1326             liquidity.reserveToken,
1327             liquidity.poolAmount,
1328             liquidity.reserveAmount,
1329             liquidity.reserveRateN,
1330             liquidity.reserveRateD,
1331             liquidity.timestamp);
1332     }
1333 
1334     /**
1335       * @dev returns the expected/actual amounts the provider will receive for removing liquidity
1336       * it's also possible to provide the remove liquidity time to get an estimation
1337       * for the return at that given point
1338       *
1339       * @param _id              protected liquidity id
1340       * @param _portion         portion of liquidity to remove, in PPM
1341       * @param _removeTimestamp time at which the liquidity is removed
1342       * @return expected return amount in the reserve token
1343       * @return actual return amount in the reserve token
1344       * @return compensation in the network token
1345     */
1346     function removeLiquidityReturn(
1347         uint256 _id,
1348         uint32 _portion,
1349         uint256 _removeTimestamp
1350     ) external view returns (uint256, uint256, uint256)
1351     {
1352         // verify input
1353         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PERCENT");
1354 
1355         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
1356 
1357         // verify input
1358         require(liquidity.provider != address(0), "ERR_INVALID_ID");
1359         require(_removeTimestamp >= liquidity.timestamp, "ERR_INVALID_TIMESTAMP");
1360 
1361         // calculate the portion of the liquidity to remove
1362         if (_portion != PPM_RESOLUTION) {
1363             liquidity.poolAmount = liquidity.poolAmount.mul(_portion).div(PPM_RESOLUTION);
1364             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion).div(PPM_RESOLUTION);
1365         }
1366 
1367         Fraction memory addRate = Fraction({ n: liquidity.reserveRateN, d: liquidity.reserveRateD });
1368         Fraction memory removeRate = reserveTokenRate(liquidity.poolToken, liquidity.reserveToken);
1369         uint256 targetAmount = removeLiquidityTargetAmount(
1370             liquidity.poolToken,
1371             liquidity.reserveToken,
1372             liquidity.poolAmount,
1373             liquidity.reserveAmount,
1374             addRate,
1375             removeRate,
1376             liquidity.timestamp,
1377             _removeTimestamp);
1378 
1379         // for network token, the return amount is identical to the target amount
1380         if (liquidity.reserveToken == networkToken) {
1381             return (targetAmount, targetAmount, 0);
1382         }
1383 
1384         // handle base token return
1385 
1386         // calculate the amount of pool tokens required for liquidation
1387         // note that the amount is doubled since it's not possible to liquidate one reserve only
1388         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1389         uint256 poolAmount = targetAmount.mul(poolRate.d).mul(2).div(poolRate.n);
1390 
1391         // limit the amount of pool tokens by the amount the system/caller holds
1392         uint256 availableBalance = store.systemBalance(liquidity.poolToken).add(liquidity.poolAmount);
1393         poolAmount = poolAmount > availableBalance ? availableBalance : poolAmount;
1394 
1395         // calculate the base token amount received by liquidating the pool tokens
1396         // note that the amount is divided by 2 since the pool amount represents both reserves
1397         uint256 baseAmount = poolAmount.mul(poolRate.n).div(poolRate.d).div(2);
1398         uint256 networkAmount = 0;
1399 
1400         // calculate the compensation if still needed
1401         if (baseAmount < targetAmount) {
1402             uint256 delta = targetAmount - baseAmount;
1403 
1404             // calculate the delta in network tokens
1405             delta = delta.mul(removeRate.n).div(removeRate.d);
1406 
1407             // the delta might be very small due to precision loss
1408             // in which case no compensation will take place (gas optimization)
1409             if (delta >= _minNetworkCompensation()) {
1410                 networkAmount = delta;
1411             }
1412         }
1413 
1414         return (targetAmount, baseAmount, networkAmount);
1415     }
1416 
1417     /**
1418       * @dev removes protected liquidity from a pool
1419       * also burns governance tokens from the caller if the caller removes network tokens
1420       *
1421       * @param _id      id in the caller's list of protected liquidity
1422       * @param _portion portion of liquidity to remove, in PPM
1423     */
1424     function removeLiquidity(uint256 _id, uint32 _portion) external protected {
1425         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PERCENT");
1426 
1427         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
1428         Fraction memory addRate = Fraction({ n: liquidity.reserveRateN, d: liquidity.reserveRateD });
1429 
1430         // verify input & permissions
1431         require(liquidity.provider == msg.sender, "ERR_ACCESS_DENIED");
1432 
1433         // verify that the pool is whitelisted
1434         require(store.isPoolWhitelisted(liquidity.poolToken), "ERR_POOL_NOT_WHITELISTED");
1435 
1436         if (_portion == PPM_RESOLUTION) {
1437             // remove the pool tokens from the provider
1438             store.removeProtectedLiquidity(_id);
1439         }
1440         else {
1441             // remove portion of the pool tokens from the provider
1442             uint256 fullPoolAmount = liquidity.poolAmount;
1443             uint256 fullReserveAmount = liquidity.reserveAmount;
1444             liquidity.poolAmount = liquidity.poolAmount.mul(_portion).div(PPM_RESOLUTION);
1445             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion).div(PPM_RESOLUTION);
1446 
1447             store.updateProtectedLiquidityAmounts(_id, fullPoolAmount - liquidity.poolAmount, fullReserveAmount - liquidity.reserveAmount);
1448         }
1449 
1450         // add the pool tokens to the system
1451         store.incSystemBalance(liquidity.poolToken, liquidity.poolAmount);
1452 
1453         // if removing network token liquidity, burn the governance tokens from the caller
1454         if (liquidity.reserveToken == networkToken) {
1455             govToken.destroy(msg.sender, liquidity.reserveAmount);
1456         }
1457 
1458         // get the current rate between the reserves (recent average)
1459         Fraction memory currentRate = reserveTokenRate(liquidity.poolToken, liquidity.reserveToken);
1460 
1461         // get the target token amount
1462         uint256 targetAmount = removeLiquidityTargetAmount(
1463             liquidity.poolToken,
1464             liquidity.reserveToken,
1465             liquidity.poolAmount,
1466             liquidity.reserveAmount,
1467             addRate,
1468             currentRate,
1469             liquidity.timestamp,
1470             time());
1471 
1472         // remove network token liquidity
1473         if (liquidity.reserveToken == networkToken) {
1474             // mint network tokens for the caller and lock them
1475             networkToken.issue(address(store), targetAmount);
1476             lockTokens(msg.sender, targetAmount);
1477             return;
1478         }
1479 
1480         // remove base token liquidity
1481 
1482         // calculate the amount of pool tokens required for liquidation
1483         // note that the amount is doubled since it's not possible to liquidate one reserve only
1484         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1485         uint256 poolAmount = targetAmount.mul(poolRate.d).mul(2).div(poolRate.n);
1486 
1487         // limit the amount of pool tokens by the amount the system holds
1488         uint256 systemBalance = store.systemBalance(liquidity.poolToken);
1489         poolAmount = poolAmount > systemBalance ? systemBalance : poolAmount;
1490 
1491         // withdraw the pool tokens from the store
1492         store.decSystemBalance(liquidity.poolToken, poolAmount);
1493         store.withdrawTokens(liquidity.poolToken, address(this), poolAmount);
1494 
1495         // remove liquidity
1496         removeLiquidity(liquidity.poolToken, poolAmount, liquidity.reserveToken, networkToken);
1497 
1498         // transfer the base tokens to the caller
1499         uint256 baseBalance;
1500         if (liquidity.reserveToken == ETH_RESERVE_ADDRESS) {
1501             baseBalance = address(this).balance;
1502             msg.sender.transfer(baseBalance);
1503         }
1504         else {
1505             baseBalance = liquidity.reserveToken.balanceOf(address(this));
1506             safeTransfer(liquidity.reserveToken, msg.sender, baseBalance);
1507         }
1508         
1509         // compensate the caller with network tokens if still needed
1510         if (baseBalance < targetAmount) {
1511             uint256 delta = targetAmount - baseBalance;
1512 
1513             // calculate the delta in network tokens
1514             delta = delta.mul(currentRate.n).div(currentRate.d);
1515 
1516             // the delta might be very small due to precision loss
1517             // in which case no compensation will take place (gas optimization)
1518             if (delta >= _minNetworkCompensation()) {
1519                 // check if there's enough network token balance, otherwise mint more
1520                 uint256 networkBalance = networkToken.balanceOf(address(this));
1521                 if (networkBalance < delta) {
1522                     networkToken.issue(address(this), delta - networkBalance);
1523                 }
1524 
1525                 // lock network tokens for the caller
1526                 safeTransfer(networkToken, address(store), delta);
1527                 lockTokens(msg.sender, delta);
1528             }
1529         }
1530 
1531         // if the contract still holds network token, burn them
1532         uint256 networkBalance = networkToken.balanceOf(address(this));
1533         if (networkBalance > 0) {
1534             networkToken.destroy(address(this), networkBalance);
1535         }
1536     }
1537 
1538     /**
1539       * @dev returns the amount the provider will receive for removing liquidity
1540       * it's also possible to provide the remove liquidity rate & time to get an estimation
1541       * for the return at that given point
1542       *
1543       * @param _poolToken       pool token
1544       * @param _reserveToken    reserve token
1545       * @param _poolAmount      pool token amount when the liquidity was added
1546       * @param _reserveAmount   reserve token amount that was added
1547       * @param _addRate         rate of 1 reserve token in the other reserve token units when the liquidity was added
1548       * @param _removeRate      rate of 1 reserve token in the other reserve token units when the liquidity is removed
1549       * @param _addTimestamp    time at which the liquidity was added
1550       * @param _removeTimestamp time at which the liquidity is removed
1551       * @return amount received for removing liquidity
1552     */
1553     function removeLiquidityTargetAmount(
1554         IDSToken _poolToken,
1555         IERC20Token _reserveToken,
1556         uint256 _poolAmount,
1557         uint256 _reserveAmount,
1558         Fraction memory _addRate,
1559         Fraction memory _removeRate,
1560         uint256 _addTimestamp,
1561         uint256 _removeTimestamp)
1562         internal view returns (uint256)
1563     {
1564         // get the adjusted amount of pool tokens based on the exposure and rate changes
1565         uint256 outputAmount = adjustedAmount(_poolToken, _reserveToken, _poolAmount, _addRate, _removeRate);
1566 
1567         // calculate the protection level
1568         Fraction memory level = protectionLevel(_addTimestamp, _removeTimestamp);
1569 
1570         // no protection, return the amount as is
1571         if (level.n == 0) {
1572             return outputAmount;
1573         }
1574 
1575         // protection is in effect, calculate loss / compensation
1576         Fraction memory loss = impLoss(_addRate, _removeRate);
1577         (uint256 compN, uint256 compD) = Math.reducedRatio(loss.n.mul(level.n), loss.d.mul(level.d), MAX_UINT128);
1578         return outputAmount.add(_reserveAmount.mul(compN).div(compD));
1579     }
1580 
1581     /**
1582       * @dev allows the caller to claim network token balance that is no longer locked
1583       * note that the function can revert if the range is too large
1584       *
1585       * @param _startIndex  start index in the caller's list of locked balances
1586       * @param _endIndex    end index in the caller's list of locked balances (exclusive)
1587     */
1588     function claimBalance(uint256 _startIndex, uint256 _endIndex) external protected {
1589         // get the locked balances from the store
1590         (uint256[] memory amounts, uint256[] memory expirationTimes) = store.lockedBalanceRange(
1591             msg.sender,
1592             _startIndex,
1593             _endIndex
1594         );
1595 
1596         uint256 totalAmount = 0;
1597         uint256 length = amounts.length;
1598         assert(length == expirationTimes.length);
1599 
1600         // reverse iteration since we're removing from the list
1601         for (uint256 i = length; i > 0; i--) {
1602             uint256 index = i - 1;
1603             if (expirationTimes[index] > time()) {
1604                 continue;
1605             }
1606 
1607             // remove the locked balance item
1608             store.removeLockedBalance(msg.sender, _startIndex + index);
1609             totalAmount = totalAmount.add(amounts[index]);
1610         }
1611 
1612         if (totalAmount > 0) {
1613             // transfer the tokens to the caller in a single call
1614             store.withdrawTokens(networkToken, msg.sender, totalAmount);
1615         }
1616     }
1617 
1618     /**
1619       * @dev returns the ROI for removing liquidity in the current state after providing liquidity with the given args
1620       * the function assumes full protection is in effect
1621       * return value is in PPM and can be larger than PPM_RESOLUTION for positive ROI, 1M = 0% ROI
1622       *
1623       * @param _poolToken       pool token
1624       * @param _reserveToken    reserve token
1625       * @param _reserveAmount   reserve token amount that was added
1626       * @param _poolRateN       rate of 1 pool token in reserve token units when the liquidity was added (numerator)
1627       * @param _poolRateD       rate of 1 pool token in reserve token units when the liquidity was added (denominator)
1628       * @param _reserveRateN    rate of 1 reserve token in the other reserve token units when the liquidity was added (numerator)
1629       * @param _reserveRateD    rate of 1 reserve token in the other reserve token units when the liquidity was added (denominator)
1630       * @return ROI in PPM
1631     */
1632     function poolROI(
1633         IDSToken _poolToken,
1634         IERC20Token _reserveToken,
1635         uint256 _reserveAmount,
1636         uint256 _poolRateN,
1637         uint256 _poolRateD,
1638         uint256 _reserveRateN,
1639         uint256 _reserveRateD
1640     ) external view returns (uint256)
1641     {
1642         // calculate the amount of pool tokens based on the amount of reserve tokens
1643         uint256 poolAmount = _reserveAmount.mul(_poolRateD).div(_poolRateN);
1644 
1645         // get the add/remove rates
1646         Fraction memory addRate = Fraction({ n: _reserveRateN, d: _reserveRateD });
1647         Fraction memory removeRate = reserveTokenRate(_poolToken, _reserveToken);
1648 
1649         // get the current return
1650         uint256 protectedReturn = removeLiquidityTargetAmount(
1651             _poolToken,
1652             _reserveToken,
1653             poolAmount,
1654             _reserveAmount,
1655             addRate,
1656             removeRate,
1657             time().sub(maxProtectionDelay),
1658             time()
1659         );
1660 
1661         // calculate the ROI as the ratio between the current fully protecteda return and the initial amount
1662         return protectedReturn.mul(PPM_RESOLUTION).div(_reserveAmount);
1663     }
1664 
1665     /**
1666       * @dev utility to protect existing liquidity
1667       * also mints new governance tokens for the caller when protecting the network token reserve
1668       *
1669       * @param _poolAnchor      pool anchor
1670       * @param _converter       pool converter
1671       * @param _reserveIndex    index of the reserve to protect
1672       * @param _poolAmount      amount of pool tokens to protect
1673     */
1674     function protectLiquidity(IDSToken _poolAnchor, IConverter _converter, uint256 _reserveIndex, uint256 _poolAmount) internal {
1675         // get the reserves token
1676         IERC20Token reserveToken = _converter.connectorTokens(_reserveIndex);
1677 
1678         // get the pool token rate
1679         IDSToken poolToken = IDSToken(address(_poolAnchor));
1680         Fraction memory reserveRate = poolTokenRate(poolToken, reserveToken);
1681 
1682         // calculate the reserve balance based on the amount provided and the current pool token rate
1683         uint256 reserveAmount = _poolAmount.mul(reserveRate.n).div(reserveRate.d);
1684 
1685         // protect the liquidity
1686         addProtectedLiquidity(msg.sender, poolToken, reserveToken, _poolAmount, reserveAmount);
1687 
1688         // for network token liquidity, mint governance tokens to the caller
1689         if (reserveToken == networkToken) {
1690             govToken.issue(msg.sender, reserveAmount);
1691         }
1692     }
1693 
1694     /**
1695       * @dev adds protected liquidity for the caller to the store
1696       *
1697       * @param _provider        protected liquidity provider
1698       * @param _poolToken       pool token
1699       * @param _reserveToken    reserve token
1700       * @param _poolAmount      amount of pool tokens to protect
1701       * @param _reserveAmount   amount of reserve tokens to protect
1702       * @return new protected liquidity id
1703     */
1704     function addProtectedLiquidity(
1705         address _provider,
1706         IDSToken _poolToken,
1707         IERC20Token _reserveToken,
1708         uint256 _poolAmount,
1709         uint256 _reserveAmount)
1710         internal
1711         returns (uint256)
1712     {
1713         Fraction memory rate = reserveTokenRate(_poolToken, _reserveToken);
1714         return store.addProtectedLiquidity(_provider, _poolToken, _reserveToken, _poolAmount, _reserveAmount, rate.n, rate.d, time());
1715     }
1716 
1717     /**
1718       * @dev locks network tokens for the provider and emits the tokens locked event
1719       *
1720       * @param _provider    tokens provider
1721       * @param _amount      amount of network tokens
1722     */
1723     function lockTokens(address _provider, uint256 _amount) internal {
1724         uint256 expirationTime = time().add(lockDuration);
1725         store.addLockedBalance(_provider, _amount, expirationTime);
1726     }
1727 
1728     /**
1729       * @dev returns the rate of 1 pool token in reserve token units
1730       *
1731       * @param _poolToken       pool token
1732       * @param _reserveToken    reserve token
1733     */
1734     function poolTokenRate(IDSToken _poolToken, IERC20Token _reserveToken) internal view returns (Fraction memory) {
1735         // get the pool token supply
1736         uint256 poolTokenSupply = _poolToken.totalSupply();
1737 
1738         // get the reserve balance
1739         IConverter converter = IConverter(payable(_poolToken.owner()));
1740         uint256 reserveBalance = converter.getConnectorBalance(_reserveToken);
1741 
1742         // for standard pools, 50% of the pool supply value equals the value of each reserve
1743         return Fraction({ n: reserveBalance.mul(2), d: poolTokenSupply });
1744     }
1745 
1746     /**
1747       * @dev returns the rate of 1 reserve token in the other reserve token units
1748       *
1749       * @param _poolToken       pool token
1750       * @param _reserveToken    reserve token
1751     */
1752     function reserveTokenRate(IDSToken _poolToken, IERC20Token _reserveToken) internal view returns (Fraction memory) {
1753         ILiquidityPoolV1Converter converter = ILiquidityPoolV1Converter(payable(_poolToken.owner()));
1754 
1755         IERC20Token otherReserve = converter.connectorTokens(0);
1756         if (otherReserve == _reserveToken) {
1757             otherReserve = converter.connectorTokens(1);
1758         }
1759 
1760         (uint256 currentRateN, uint256 currentRateD) = converterReserveBalances(converter, otherReserve, _reserveToken);
1761         (uint256 n, uint256 d) = converter.recentAverageRate(_reserveToken);
1762 
1763         uint256 min = currentRateN.mul(d).mul(PPM_RESOLUTION - averageRateMaxDeviation).mul(PPM_RESOLUTION - averageRateMaxDeviation);
1764         uint256 mid = currentRateD.mul(n).mul(PPM_RESOLUTION - averageRateMaxDeviation).mul(PPM_RESOLUTION);
1765         uint256 max = currentRateN.mul(d).mul(PPM_RESOLUTION).mul(PPM_RESOLUTION);
1766         require(min <= mid && mid <= max, "ERR_INVALID_RATE");
1767 
1768         return Fraction(n, d);
1769     }
1770 
1771     /**
1772       * @dev utility to add liquidity to a converter
1773       *
1774       * @param _converter       converter
1775       * @param _reserveToken1   reserve token 1
1776       * @param _reserveToken2   reserve token 2
1777       * @param _reserveAmount1  reserve amount 1
1778       * @param _reserveAmount2  reserve amount 2
1779       * @param _value           ETH amount to add
1780     */
1781     function addLiquidity(
1782         ILiquidityPoolV1Converter _converter,
1783         IERC20Token _reserveToken1,
1784         IERC20Token _reserveToken2,
1785         uint256 _reserveAmount1,
1786         uint256 _reserveAmount2,
1787         uint256 _value)
1788         internal
1789     {
1790         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
1791         uint256[] memory amounts = new uint256[](2);
1792         reserveTokens[0] = _reserveToken1;
1793         reserveTokens[1] = _reserveToken2;
1794         amounts[0] = _reserveAmount1;
1795         amounts[1] = _reserveAmount2;
1796 
1797         // ensure that the contract can receive ETH
1798         updatingLiquidity = true;
1799         _converter.addLiquidity{value: _value}(reserveTokens, amounts, 1);
1800         updatingLiquidity = false;
1801     }
1802 
1803     /**
1804       * @dev utility to remove liquidity from a converter
1805       *
1806       * @param _poolToken       pool token of the converter
1807       * @param _poolAmount      amount of pool tokens to remove
1808       * @param _reserveToken1   reserve token 1
1809       * @param _reserveToken2   reserve token 2
1810     */
1811     function removeLiquidity(
1812         IDSToken _poolToken,
1813         uint256 _poolAmount,
1814         IERC20Token _reserveToken1,
1815         IERC20Token _reserveToken2)
1816         internal
1817     {
1818         ILiquidityPoolV1Converter converter = ILiquidityPoolV1Converter(payable(_poolToken.owner()));
1819 
1820         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
1821         uint256[] memory minReturns = new uint256[](2);
1822         reserveTokens[0] = _reserveToken1;
1823         reserveTokens[1] = _reserveToken2;
1824         minReturns[0] = 1;
1825         minReturns[1] = 1;
1826 
1827         // ensure that the contract can receive ETH
1828         updatingLiquidity = true;
1829         converter.removeLiquidity(_poolAmount, reserveTokens, minReturns);
1830         updatingLiquidity = false;
1831     }
1832 
1833     /**
1834       * @dev returns a protected liquidity from the store
1835       *
1836       * @param _id  protected liquidity id
1837       * @return protected liquidity
1838     */
1839     function protectedLiquidity(uint256 _id) internal view returns (ProtectedLiquidity memory) {
1840         ProtectedLiquidity memory liquidity;
1841         (
1842             liquidity.provider,
1843             liquidity.poolToken,
1844             liquidity.reserveToken,
1845             liquidity.poolAmount,
1846             liquidity.reserveAmount,
1847             liquidity.reserveRateN,
1848             liquidity.reserveRateD,
1849             liquidity.timestamp
1850         ) = store.protectedLiquidity(_id);
1851 
1852         return liquidity;
1853     }
1854 
1855     /**
1856       * @dev returns the adjusted amount of pool tokens based on the exposure and rate changes
1857       *
1858       * @param _poolToken       pool token
1859       * @param _reserveToken    reserve token
1860       * @param _poolAmount      pool token amount when the liquidity was added
1861       * @param _addRate         rate of 1 reserve token in the other reserve token units when the liquidity was added
1862       * @param _removeRate      rate of 1 reserve token in the other reserve token units when the liquidity is removed
1863       * @return adjusted amount of pool tokens
1864     */
1865     function adjustedAmount(
1866         IDSToken _poolToken,
1867         IERC20Token _reserveToken,
1868         uint256 _poolAmount,
1869         Fraction memory _addRate,
1870         Fraction memory _removeRate)
1871         internal view returns (uint256)
1872     {
1873         Fraction memory poolRate = poolTokenRate(_poolToken, _reserveToken);
1874         Fraction memory poolFactor = poolTokensFactor(_addRate, _removeRate);
1875 
1876         (uint256 poolRateN, uint256 poolRateD) = Math.reducedRatio(_poolAmount.mul(poolRate.n), poolRate.d, MAX_UINT128);
1877         (uint256 poolFactorN, uint256 poolFactorD) = Math.reducedRatio(poolFactor.n, poolFactor.d, MAX_UINT128);
1878 
1879         return poolRateN.mul(poolFactorN).div(poolRateD.mul(poolFactorD));
1880     }
1881 
1882     /**
1883       * @dev returns the impermanent loss incurred due to the change in rates between the reserve tokens
1884       * the loss is returned in percentages (Fraction)
1885       *
1886       * @param _prevRate    previous rate between the reserves
1887       * @param _newRate     new rate between the reserves
1888     */
1889     function impLoss(Fraction memory _prevRate, Fraction memory _newRate) internal pure returns (Fraction memory) {
1890         uint256 ratioN = _newRate.n.mul(_prevRate.d);
1891         uint256 ratioD = _newRate.d.mul(_prevRate.n);
1892 
1893         // no need for SafeMath - can't overflow
1894         uint256 prod = ratioN * ratioD;
1895         uint256 root = prod / ratioN == ratioD ? Math.floorSqrt(prod) : Math.floorSqrt(ratioN) * Math.floorSqrt(ratioD);
1896         uint256 sum = ratioN.add(ratioD);
1897         return Fraction({ n: sum.sub(root.mul(2)), d: sum });
1898     }
1899 
1900     /**
1901       * @dev returns the factor that should be applied to the amount of pool tokens based
1902       * on exposure and change in rates between the reserve tokens
1903       * the factor is returned in percentages (Fraction)
1904       *
1905       * @param _prevRate    previous rate between the reserves
1906       * @param _newRate     new rate between the reserves
1907     */
1908     function poolTokensFactor(Fraction memory _prevRate, Fraction memory _newRate) internal pure returns (Fraction memory) {
1909         uint256 ratioN = _newRate.n.mul(_prevRate.d);
1910         uint256 ratioD = _newRate.d.mul(_prevRate.n);
1911         return Fraction({ n: ratioN.mul(2), d: ratioN.add(ratioD) });
1912     }
1913 
1914     /**
1915       * @dev returns the protection level based on the timestamp and protection delays
1916       * the protection level is returned as a Fraction
1917       *
1918       * @param _addTimestamp    time at which the liquidity was added
1919       * @param _removeTimestamp time at which the liquidity is removed
1920     */
1921     function protectionLevel(uint256 _addTimestamp, uint256 _removeTimestamp) internal view returns (Fraction memory) {
1922         uint256 timeElapsed = _removeTimestamp.sub(_addTimestamp);
1923         if (timeElapsed < minProtectionDelay) {
1924             return Fraction({ n: 0, d: 1 });
1925         }
1926 
1927         if (timeElapsed >= maxProtectionDelay) {
1928             return Fraction({ n: 1, d: 1 });
1929         }
1930 
1931         return Fraction({ n: timeElapsed, d: maxProtectionDelay });
1932     }
1933 
1934     /**
1935       * @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
1936       * note that we use the non standard erc-20 interface in which `approve` has no return value so that
1937       * this function will work for both standard and non standard tokens
1938       *
1939       * @param _token   token to check the allowance in
1940       * @param _spender approved address
1941       * @param _value   allowance amount
1942     */
1943     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
1944         uint256 allowance = _token.allowance(address(this), _spender);
1945         if (allowance < _value) {
1946             if (allowance > 0)
1947                 safeApprove(_token, _spender, 0);
1948             safeApprove(_token, _spender, _value);
1949         }
1950     }
1951 
1952     // utility to get the reserve balances
1953     function converterReserveBalances(IConverter _converter, IERC20Token _reserveToken1, IERC20Token _reserveToken2) private view returns (uint256, uint256) {
1954         return (_converter.getConnectorBalance(_reserveToken1), _converter.getConnectorBalance(_reserveToken2));
1955     }
1956 
1957     // utility to get the reserve weight (including from older converters that don't support the new converterReserveWeight function)
1958     function converterReserveWeight(IConverter _converter, IERC20Token _reserveToken) private view returns (uint32) {
1959         (, uint32 weight,,,) = _converter.connectors(_reserveToken);
1960         return weight;
1961     }
1962 
1963     bytes4 private constant CONVERTER_VERSION_FUNC_SELECTOR = bytes4(keccak256("version()"));
1964 
1965     // using a static call to identify converter version
1966     // the function had a different signature in older converters but in the worst case,
1967     // these converters won't be supported (revert) until they are upgraded
1968     function converterVersion(IConverter _converter) internal view returns (uint16) {
1969         bytes memory data = abi.encodeWithSelector(CONVERTER_VERSION_FUNC_SELECTOR);
1970         (bool success, bytes memory returnData) = address(_converter).staticcall{ gas: 4000 }(data);
1971 
1972         if (success && returnData.length == 32) {
1973             return abi.decode(returnData, (uint16));
1974         }
1975 
1976         return 0;
1977     }
1978 
1979     /**
1980       * @dev returns minimum network tokens compensation
1981       * utility to allow overrides for tests
1982     */
1983     function _minNetworkCompensation() internal view virtual returns (uint256) {
1984         return minNetworkCompensation;
1985     }
1986 
1987     /**
1988       * @dev returns the current time
1989       * utility to allow overrides for tests
1990     */
1991     function time() internal view virtual returns (uint256) {
1992         return block.timestamp;
1993     }
1994 }
