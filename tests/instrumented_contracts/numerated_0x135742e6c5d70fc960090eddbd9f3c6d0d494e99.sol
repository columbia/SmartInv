1 
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.6.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 // File: @bancor/token-governance/contracts/IClaimable.sol
83 
84 
85 pragma solidity 0.6.12;
86 
87 /// @title Claimable contract interface
88 interface IClaimable {
89     function owner() external view returns (address);
90 
91     function transferOwnership(address newOwner) external;
92 
93     function acceptOwnership() external;
94 }
95 
96 // File: @bancor/token-governance/contracts/IMintableToken.sol
97 
98 
99 pragma solidity 0.6.12;
100 
101 
102 
103 /// @title Mintable Token interface
104 interface IMintableToken is IERC20, IClaimable {
105     function issue(address to, uint256 amount) external;
106 
107     function destroy(address from, uint256 amount) external;
108 }
109 
110 // File: @bancor/token-governance/contracts/ITokenGovernance.sol
111 
112 
113 pragma solidity 0.6.12;
114 
115 
116 /// @title The interface for mintable/burnable token governance.
117 interface ITokenGovernance {
118     // The address of the mintable ERC20 token.
119     function token() external view returns (IMintableToken);
120 
121     /// @dev Mints new tokens.
122     ///
123     /// @param to Account to receive the new amount.
124     /// @param amount Amount to increase the supply by.
125     ///
126     function mint(address to, uint256 amount) external;
127 
128     /// @dev Burns tokens from the caller.
129     ///
130     /// @param amount Amount to decrease the supply by.
131     ///
132     function burn(uint256 amount) external;
133 }
134 
135 // File: solidity/contracts/utility/interfaces/IOwned.sol
136 
137 
138 pragma solidity 0.6.12;
139 
140 /*
141     Owned contract interface
142 */
143 interface IOwned {
144     // this function isn't since the compiler emits automatically generated getter functions as external
145     function owner() external view returns (address);
146 
147     function transferOwnership(address _newOwner) external;
148 
149     function acceptOwnership() external;
150 }
151 
152 // File: solidity/contracts/utility/Owned.sol
153 
154 
155 pragma solidity 0.6.12;
156 
157 
158 /**
159  * @dev This contract provides support and utilities for contract ownership.
160  */
161 contract Owned is IOwned {
162     address public override owner;
163     address public newOwner;
164 
165     /**
166      * @dev triggered when the owner is updated
167      *
168      * @param _prevOwner previous owner
169      * @param _newOwner  new owner
170      */
171     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
172 
173     /**
174      * @dev initializes a new Owned instance
175      */
176     constructor() public {
177         owner = msg.sender;
178     }
179 
180     // allows execution by the owner only
181     modifier ownerOnly {
182         _ownerOnly();
183         _;
184     }
185 
186     // error message binary size optimization
187     function _ownerOnly() internal view {
188         require(msg.sender == owner, "ERR_ACCESS_DENIED");
189     }
190 
191     /**
192      * @dev allows transferring the contract ownership
193      * the new owner still needs to accept the transfer
194      * can only be called by the contract owner
195      *
196      * @param _newOwner    new contract owner
197      */
198     function transferOwnership(address _newOwner) public override ownerOnly {
199         require(_newOwner != owner, "ERR_SAME_OWNER");
200         newOwner = _newOwner;
201     }
202 
203     /**
204      * @dev used by a new owner to accept an ownership transfer
205      */
206     function acceptOwnership() public override {
207         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
208         emit OwnerUpdate(owner, newOwner);
209         owner = newOwner;
210         newOwner = address(0);
211     }
212 }
213 
214 // File: solidity/contracts/utility/Utils.sol
215 
216 
217 pragma solidity 0.6.12;
218 
219 /**
220  * @dev Utilities & Common Modifiers
221  */
222 contract Utils {
223     // verifies that a value is greater than zero
224     modifier greaterThanZero(uint256 _value) {
225         _greaterThanZero(_value);
226         _;
227     }
228 
229     // error message binary size optimization
230     function _greaterThanZero(uint256 _value) internal pure {
231         require(_value > 0, "ERR_ZERO_VALUE");
232     }
233 
234     // validates an address - currently only checks that it isn't null
235     modifier validAddress(address _address) {
236         _validAddress(_address);
237         _;
238     }
239 
240     // error message binary size optimization
241     function _validAddress(address _address) internal pure {
242         require(_address != address(0), "ERR_INVALID_ADDRESS");
243     }
244 
245     // verifies that the address is different than this contract address
246     modifier notThis(address _address) {
247         _notThis(_address);
248         _;
249     }
250 
251     // error message binary size optimization
252     function _notThis(address _address) internal view {
253         require(_address != address(this), "ERR_ADDRESS_IS_SELF");
254     }
255 }
256 
257 // File: solidity/contracts/utility/interfaces/IContractRegistry.sol
258 
259 
260 pragma solidity 0.6.12;
261 
262 /*
263     Contract Registry interface
264 */
265 interface IContractRegistry {
266     function addressOf(bytes32 _contractName) external view returns (address);
267 }
268 
269 // File: solidity/contracts/utility/ContractRegistryClient.sol
270 
271 
272 pragma solidity 0.6.12;
273 
274 
275 
276 
277 /**
278  * @dev This is the base contract for ContractRegistry clients.
279  */
280 contract ContractRegistryClient is Owned, Utils {
281     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
282     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
283     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
284     bytes32 internal constant CONVERTER_FACTORY = "ConverterFactory";
285     bytes32 internal constant CONVERSION_PATH_FINDER = "ConversionPathFinder";
286     bytes32 internal constant CONVERTER_UPGRADER = "BancorConverterUpgrader";
287     bytes32 internal constant CONVERTER_REGISTRY = "BancorConverterRegistry";
288     bytes32 internal constant CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
289     bytes32 internal constant BNT_TOKEN = "BNTToken";
290     bytes32 internal constant BANCOR_X = "BancorX";
291     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
292     bytes32 internal constant CHAINLINK_ORACLE_WHITELIST = "ChainlinkOracleWhitelist";
293 
294     IContractRegistry public registry; // address of the current contract-registry
295     IContractRegistry public prevRegistry; // address of the previous contract-registry
296     bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry
297 
298     /**
299      * @dev verifies that the caller is mapped to the given contract name
300      *
301      * @param _contractName    contract name
302      */
303     modifier only(bytes32 _contractName) {
304         _only(_contractName);
305         _;
306     }
307 
308     // error message binary size optimization
309     function _only(bytes32 _contractName) internal view {
310         require(msg.sender == addressOf(_contractName), "ERR_ACCESS_DENIED");
311     }
312 
313     /**
314      * @dev initializes a new ContractRegistryClient instance
315      *
316      * @param  _registry   address of a contract-registry contract
317      */
318     constructor(IContractRegistry _registry) internal validAddress(address(_registry)) {
319         registry = IContractRegistry(_registry);
320         prevRegistry = IContractRegistry(_registry);
321     }
322 
323     /**
324      * @dev updates to the new contract-registry
325      */
326     function updateRegistry() public {
327         // verify that this function is permitted
328         require(msg.sender == owner || !onlyOwnerCanUpdateRegistry, "ERR_ACCESS_DENIED");
329 
330         // get the new contract-registry
331         IContractRegistry newRegistry = IContractRegistry(addressOf(CONTRACT_REGISTRY));
332 
333         // verify that the new contract-registry is different and not zero
334         require(newRegistry != registry && address(newRegistry) != address(0), "ERR_INVALID_REGISTRY");
335 
336         // verify that the new contract-registry is pointing to a non-zero contract-registry
337         require(newRegistry.addressOf(CONTRACT_REGISTRY) != address(0), "ERR_INVALID_REGISTRY");
338 
339         // save a backup of the current contract-registry before replacing it
340         prevRegistry = registry;
341 
342         // replace the current contract-registry with the new contract-registry
343         registry = newRegistry;
344     }
345 
346     /**
347      * @dev restores the previous contract-registry
348      */
349     function restoreRegistry() public ownerOnly {
350         // restore the previous contract-registry
351         registry = prevRegistry;
352     }
353 
354     /**
355      * @dev restricts the permission to update the contract-registry
356      *
357      * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
358      */
359     function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) public ownerOnly {
360         // change the permission to update the contract-registry
361         onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
362     }
363 
364     /**
365      * @dev returns the address associated with the given contract name
366      *
367      * @param _contractName    contract name
368      *
369      * @return contract address
370      */
371     function addressOf(bytes32 _contractName) internal view returns (address) {
372         return registry.addressOf(_contractName);
373     }
374 }
375 
376 // File: solidity/contracts/utility/ReentrancyGuard.sol
377 
378 
379 pragma solidity 0.6.12;
380 
381 /**
382  * @dev This contract provides protection against calling a function
383  * (directly or indirectly) from within itself.
384  */
385 contract ReentrancyGuard {
386     uint256 private constant UNLOCKED = 1;
387     uint256 private constant LOCKED = 2;
388 
389     // LOCKED while protected code is being executed, UNLOCKED otherwise
390     uint256 private state = UNLOCKED;
391 
392     /**
393      * @dev ensures instantiation only by sub-contracts
394      */
395     constructor() internal {}
396 
397     // protects a function against reentrancy attacks
398     modifier protected() {
399         _protected();
400         state = LOCKED;
401         _;
402         state = UNLOCKED;
403     }
404 
405     // error message binary size optimization
406     function _protected() internal view {
407         require(state == UNLOCKED, "ERR_REENTRANCY");
408     }
409 }
410 
411 // File: solidity/contracts/utility/SafeMath.sol
412 
413 
414 pragma solidity 0.6.12;
415 
416 /**
417  * @dev This library supports basic math operations with overflow/underflow protection.
418  */
419 library SafeMath {
420     /**
421      * @dev returns the sum of _x and _y, reverts if the calculation overflows
422      *
423      * @param _x   value 1
424      * @param _y   value 2
425      *
426      * @return sum
427      */
428     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
429         uint256 z = _x + _y;
430         require(z >= _x, "ERR_OVERFLOW");
431         return z;
432     }
433 
434     /**
435      * @dev returns the difference of _x minus _y, reverts if the calculation underflows
436      *
437      * @param _x   minuend
438      * @param _y   subtrahend
439      *
440      * @return difference
441      */
442     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
443         require(_x >= _y, "ERR_UNDERFLOW");
444         return _x - _y;
445     }
446 
447     /**
448      * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
449      *
450      * @param _x   factor 1
451      * @param _y   factor 2
452      *
453      * @return product
454      */
455     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
456         // gas optimization
457         if (_x == 0) return 0;
458 
459         uint256 z = _x * _y;
460         require(z / _x == _y, "ERR_OVERFLOW");
461         return z;
462     }
463 
464     /**
465      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
466      *
467      * @param _x   dividend
468      * @param _y   divisor
469      *
470      * @return quotient
471      */
472     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
473         require(_y > 0, "ERR_DIVIDE_BY_ZERO");
474         uint256 c = _x / _y;
475         return c;
476     }
477 }
478 
479 // File: solidity/contracts/utility/Math.sol
480 
481 
482 pragma solidity 0.6.12;
483 
484 
485 /**
486  * @dev This library provides a set of complex math operations.
487  */
488 library Math {
489     using SafeMath for uint256;
490 
491     /**
492      * @dev returns the largest integer smaller than or equal to the square root of a positive integer
493      *
494      * @param _num a positive integer
495      *
496      * @return the largest integer smaller than or equal to the square root of the positive integer
497      */
498     function floorSqrt(uint256 _num) internal pure returns (uint256) {
499         uint256 x = _num / 2 + 1;
500         uint256 y = (x + _num / x) / 2;
501         while (x > y) {
502             x = y;
503             y = (x + _num / x) / 2;
504         }
505         return x;
506     }
507 
508     /**
509      * @dev returns the smallest integer larger than or equal to the square root of a positive integer
510      *
511      * @param _num a positive integer
512      *
513      * @return the smallest integer larger than or equal to the square root of the positive integer
514      */
515     function ceilSqrt(uint256 _num) internal pure returns (uint256) {
516         uint256 x = _num / 2 + 1;
517         uint256 y = (x + _num / x) / 2;
518         while (x > y) {
519             x = y;
520             y = (x + _num / x) / 2;
521         }
522         return x * x == _num ? x : x + 1;
523     }
524 
525     /**
526      * @dev computes a reduced-scalar ratio
527      *
528      * @param _n   ratio numerator
529      * @param _d   ratio denominator
530      * @param _max maximum desired scalar
531      *
532      * @return ratio's numerator and denominator
533      */
534     function reducedRatio(
535         uint256 _n,
536         uint256 _d,
537         uint256 _max
538     ) internal pure returns (uint256, uint256) {
539         if (_n > _max || _d > _max) return normalizedRatio(_n, _d, _max);
540         return (_n, _d);
541     }
542 
543     /**
544      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)".
545      */
546     function normalizedRatio(
547         uint256 _a,
548         uint256 _b,
549         uint256 _scale
550     ) internal pure returns (uint256, uint256) {
551         if (_a == _b) return (_scale / 2, _scale / 2);
552         if (_a < _b) return accurateRatio(_a, _b, _scale);
553         (uint256 y, uint256 x) = accurateRatio(_b, _a, _scale);
554         return (x, y);
555     }
556 
557     /**
558      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)", assuming that "a < b".
559      */
560     function accurateRatio(
561         uint256 _a,
562         uint256 _b,
563         uint256 _scale
564     ) internal pure returns (uint256, uint256) {
565         uint256 maxVal = uint256(-1) / _scale;
566         if (_a > maxVal) {
567             uint256 c = _a / (maxVal + 1) + 1;
568             _a /= c;
569             _b /= c;
570         }
571         uint256 x = roundDiv(_a * _scale, _a.add(_b));
572         uint256 y = _scale - x;
573         return (x, y);
574     }
575 
576     /**
577      * @dev computes the nearest integer to a given quotient without overflowing or underflowing.
578      */
579     function roundDiv(uint256 _n, uint256 _d) internal pure returns (uint256) {
580         return _n / _d + (_n % _d) / (_d - _d / 2);
581     }
582 
583     /**
584      * @dev returns the average number of decimal digits in a given list of positive integers
585      *
586      * @param _values  list of positive integers
587      *
588      * @return the average number of decimal digits in the given list of positive integers
589      */
590     function geometricMean(uint256[] memory _values) internal pure returns (uint256) {
591         uint256 numOfDigits = 0;
592         uint256 length = _values.length;
593         for (uint256 i = 0; i < length; i++) numOfDigits += decimalLength(_values[i]);
594         return uint256(10)**(roundDivUnsafe(numOfDigits, length) - 1);
595     }
596 
597     /**
598      * @dev returns the number of decimal digits in a given positive integer
599      *
600      * @param _x   positive integer
601      *
602      * @return the number of decimal digits in the given positive integer
603      */
604     function decimalLength(uint256 _x) internal pure returns (uint256) {
605         uint256 y = 0;
606         for (uint256 x = _x; x > 0; x /= 10) y++;
607         return y;
608     }
609 
610     /**
611      * @dev returns the nearest integer to a given quotient
612      * the computation is overflow-safe assuming that the input is sufficiently small
613      *
614      * @param _n   quotient numerator
615      * @param _d   quotient denominator
616      *
617      * @return the nearest integer to the given quotient
618      */
619     function roundDivUnsafe(uint256 _n, uint256 _d) internal pure returns (uint256) {
620         return (_n + _d / 2) / _d;
621     }
622 }
623 
624 // File: solidity/contracts/token/interfaces/IERC20Token.sol
625 
626 
627 pragma solidity 0.6.12;
628 
629 /*
630     ERC20 Standard Token interface
631 */
632 interface IERC20Token {
633     function name() external view returns (string memory);
634 
635     function symbol() external view returns (string memory);
636 
637     function decimals() external view returns (uint8);
638 
639     function totalSupply() external view returns (uint256);
640 
641     function balanceOf(address _owner) external view returns (uint256);
642 
643     function allowance(address _owner, address _spender) external view returns (uint256);
644 
645     function transfer(address _to, uint256 _value) external returns (bool);
646 
647     function transferFrom(
648         address _from,
649         address _to,
650         uint256 _value
651     ) external returns (bool);
652 
653     function approve(address _spender, uint256 _value) external returns (bool);
654 }
655 
656 // File: solidity/contracts/utility/TokenHandler.sol
657 
658 
659 pragma solidity 0.6.12;
660 
661 
662 contract TokenHandler {
663     bytes4 private constant APPROVE_FUNC_SELECTOR = bytes4(keccak256("approve(address,uint256)"));
664     bytes4 private constant TRANSFER_FUNC_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
665     bytes4 private constant TRANSFER_FROM_FUNC_SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));
666 
667     /**
668      * @dev executes the ERC20 token's `approve` function and reverts upon failure
669      * the main purpose of this function is to prevent a non standard ERC20 token
670      * from failing silently
671      *
672      * @param _token   ERC20 token address
673      * @param _spender approved address
674      * @param _value   allowance amount
675      */
676     function safeApprove(
677         IERC20Token _token,
678         address _spender,
679         uint256 _value
680     ) internal {
681         (bool success, bytes memory data) = address(_token).call(
682             abi.encodeWithSelector(APPROVE_FUNC_SELECTOR, _spender, _value)
683         );
684         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_APPROVE_FAILED");
685     }
686 
687     /**
688      * @dev executes the ERC20 token's `transfer` function and reverts upon failure
689      * the main purpose of this function is to prevent a non standard ERC20 token
690      * from failing silently
691      *
692      * @param _token   ERC20 token address
693      * @param _to      target address
694      * @param _value   transfer amount
695      */
696     function safeTransfer(
697         IERC20Token _token,
698         address _to,
699         uint256 _value
700     ) internal {
701         (bool success, bytes memory data) = address(_token).call(
702             abi.encodeWithSelector(TRANSFER_FUNC_SELECTOR, _to, _value)
703         );
704         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_TRANSFER_FAILED");
705     }
706 
707     /**
708      * @dev executes the ERC20 token's `transferFrom` function and reverts upon failure
709      * the main purpose of this function is to prevent a non standard ERC20 token
710      * from failing silently
711      *
712      * @param _token   ERC20 token address
713      * @param _from    source address
714      * @param _to      target address
715      * @param _value   transfer amount
716      */
717     function safeTransferFrom(
718         IERC20Token _token,
719         address _from,
720         address _to,
721         uint256 _value
722     ) internal {
723         (bool success, bytes memory data) = address(_token).call(
724             abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value)
725         );
726         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_TRANSFER_FROM_FAILED");
727     }
728 }
729 
730 // File: solidity/contracts/utility/Types.sol
731 
732 
733 pragma solidity 0.6.12;
734 
735 /**
736  * @dev This contract provides types which can be used by various contracts.
737  */
738 
739 struct Fraction {
740     uint256 n; // numerator
741     uint256 d; // denominator
742 }
743 
744 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
745 
746 
747 pragma solidity 0.6.12;
748 
749 
750 /*
751     Converter Anchor interface
752 */
753 interface IConverterAnchor is IOwned {
754 
755 }
756 
757 // File: solidity/contracts/token/interfaces/IDSToken.sol
758 
759 
760 pragma solidity 0.6.12;
761 
762 
763 
764 
765 /*
766     DSToken interface
767 */
768 interface IDSToken is IConverterAnchor, IERC20Token {
769     function issue(address _to, uint256 _amount) external;
770 
771     function destroy(address _from, uint256 _amount) external;
772 }
773 
774 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionStore.sol
775 
776 
777 pragma solidity 0.6.12;
778 
779 
780 
781 
782 
783 /*
784     Liquidity Protection Store interface
785 */
786 interface ILiquidityProtectionStore is IOwned {
787     function addPoolToWhitelist(IConverterAnchor _anchor) external;
788 
789     function removePoolFromWhitelist(IConverterAnchor _anchor) external;
790 
791     function isPoolWhitelisted(IConverterAnchor _anchor) external view returns (bool);
792 
793     function withdrawTokens(
794         IERC20Token _token,
795         address _to,
796         uint256 _amount
797     ) external;
798 
799     function protectedLiquidity(uint256 _id)
800         external
801         view
802         returns (
803             address,
804             IDSToken,
805             IERC20Token,
806             uint256,
807             uint256,
808             uint256,
809             uint256,
810             uint256
811         );
812 
813     function addProtectedLiquidity(
814         address _provider,
815         IDSToken _poolToken,
816         IERC20Token _reserveToken,
817         uint256 _poolAmount,
818         uint256 _reserveAmount,
819         uint256 _reserveRateN,
820         uint256 _reserveRateD,
821         uint256 _timestamp
822     ) external returns (uint256);
823 
824     function updateProtectedLiquidityAmounts(
825         uint256 _id,
826         uint256 _poolNewAmount,
827         uint256 _reserveNewAmount
828     ) external;
829 
830     function removeProtectedLiquidity(uint256 _id) external;
831 
832     function lockedBalance(address _provider, uint256 _index) external view returns (uint256, uint256);
833 
834     function lockedBalanceRange(
835         address _provider,
836         uint256 _startIndex,
837         uint256 _endIndex
838     ) external view returns (uint256[] memory, uint256[] memory);
839 
840     function addLockedBalance(
841         address _provider,
842         uint256 _reserveAmount,
843         uint256 _expirationTime
844     ) external returns (uint256);
845 
846     function removeLockedBalance(address _provider, uint256 _index) external;
847 
848     function systemBalance(IERC20Token _poolToken) external view returns (uint256);
849 
850     function incSystemBalance(IERC20Token _poolToken, uint256 _poolAmount) external;
851 
852     function decSystemBalance(IERC20Token _poolToken, uint256 _poolAmount) external;
853 }
854 
855 // File: solidity/contracts/converter/interfaces/IConverter.sol
856 
857 
858 pragma solidity 0.6.12;
859 
860 
861 
862 
863 /*
864     Converter interface
865 */
866 interface IConverter is IOwned {
867     function converterType() external pure returns (uint16);
868 
869     function anchor() external view returns (IConverterAnchor);
870 
871     function isActive() external view returns (bool);
872 
873     function targetAmountAndFee(
874         IERC20Token _sourceToken,
875         IERC20Token _targetToken,
876         uint256 _amount
877     ) external view returns (uint256, uint256);
878 
879     function convert(
880         IERC20Token _sourceToken,
881         IERC20Token _targetToken,
882         uint256 _amount,
883         address _trader,
884         address payable _beneficiary
885     ) external payable returns (uint256);
886 
887     function conversionFee() external view returns (uint32);
888 
889     function maxConversionFee() external view returns (uint32);
890 
891     function reserveBalance(IERC20Token _reserveToken) external view returns (uint256);
892 
893     receive() external payable;
894 
895     function transferAnchorOwnership(address _newOwner) external;
896 
897     function acceptAnchorOwnership() external;
898 
899     function setConversionFee(uint32 _conversionFee) external;
900 
901     function withdrawTokens(
902         IERC20Token _token,
903         address _to,
904         uint256 _amount
905     ) external;
906 
907     function withdrawETH(address payable _to) external;
908 
909     function addReserve(IERC20Token _token, uint32 _ratio) external;
910 
911     // deprecated, backward compatibility
912     function token() external view returns (IConverterAnchor);
913 
914     function transferTokenOwnership(address _newOwner) external;
915 
916     function acceptTokenOwnership() external;
917 
918     function connectors(IERC20Token _address)
919         external
920         view
921         returns (
922             uint256,
923             uint32,
924             bool,
925             bool,
926             bool
927         );
928 
929     function getConnectorBalance(IERC20Token _connectorToken) external view returns (uint256);
930 
931     function connectorTokens(uint256 _index) external view returns (IERC20Token);
932 
933     function connectorTokenCount() external view returns (uint16);
934 }
935 
936 // File: solidity/contracts/converter/interfaces/IConverterRegistry.sol
937 
938 
939 pragma solidity 0.6.12;
940 
941 
942 
943 interface IConverterRegistry {
944     function getAnchorCount() external view returns (uint256);
945 
946     function getAnchors() external view returns (address[] memory);
947 
948     function getAnchor(uint256 _index) external view returns (IConverterAnchor);
949 
950     function isAnchor(address _value) external view returns (bool);
951 
952     function getLiquidityPoolCount() external view returns (uint256);
953 
954     function getLiquidityPools() external view returns (address[] memory);
955 
956     function getLiquidityPool(uint256 _index) external view returns (IConverterAnchor);
957 
958     function isLiquidityPool(address _value) external view returns (bool);
959 
960     function getConvertibleTokenCount() external view returns (uint256);
961 
962     function getConvertibleTokens() external view returns (address[] memory);
963 
964     function getConvertibleToken(uint256 _index) external view returns (IERC20Token);
965 
966     function isConvertibleToken(address _value) external view returns (bool);
967 
968     function getConvertibleTokenAnchorCount(IERC20Token _convertibleToken) external view returns (uint256);
969 
970     function getConvertibleTokenAnchors(IERC20Token _convertibleToken) external view returns (address[] memory);
971 
972     function getConvertibleTokenAnchor(IERC20Token _convertibleToken, uint256 _index)
973         external
974         view
975         returns (IConverterAnchor);
976 
977     function isConvertibleTokenAnchor(IERC20Token _convertibleToken, address _value) external view returns (bool);
978 }
979 
980 // File: solidity/contracts/liquidity-protection/LiquidityProtection.sol
981 
982 
983 pragma solidity 0.6.12;
984 
985 
986 
987 
988 
989 
990 
991 
992 
993 
994 
995 
996 
997 
998 
999 interface ILiquidityPoolV1Converter is IConverter {
1000     function addLiquidity(
1001         IERC20Token[] memory _reserveTokens,
1002         uint256[] memory _reserveAmounts,
1003         uint256 _minReturn
1004     ) external payable;
1005 
1006     function removeLiquidity(
1007         uint256 _amount,
1008         IERC20Token[] memory _reserveTokens,
1009         uint256[] memory _reserveMinReturnAmounts
1010     ) external;
1011 
1012     function recentAverageRate(IERC20Token _reserveToken) external view returns (uint256, uint256);
1013 }
1014 
1015 /**
1016  * @dev This contract implements the liquidity protection mechanism.
1017  */
1018 contract LiquidityProtection is TokenHandler, ContractRegistryClient, ReentrancyGuard {
1019     using SafeMath for uint256;
1020     using Math for *;
1021 
1022     struct ProtectedLiquidity {
1023         address provider; // liquidity provider
1024         IDSToken poolToken; // pool token address
1025         IERC20Token reserveToken; // reserve token address
1026         uint256 poolAmount; // pool token amount
1027         uint256 reserveAmount; // reserve token amount
1028         uint256 reserveRateN; // rate of 1 protected reserve token in units of the other reserve token (numerator)
1029         uint256 reserveRateD; // rate of 1 protected reserve token in units of the other reserve token (denominator)
1030         uint256 timestamp; // timestamp
1031     }
1032 
1033     // various rates between the two reserve tokens. the rate is of 1 unit of the protected reserve token in units of the other reserve token
1034     struct PackedRates {
1035         uint128 addSpotRateN; // spot rate of 1 A in units of B when liquidity was added (numerator)
1036         uint128 addSpotRateD; // spot rate of 1 A in units of B when liquidity was added (denominator)
1037         uint128 removeSpotRateN; // spot rate of 1 A in units of B when liquidity is removed (numerator)
1038         uint128 removeSpotRateD; // spot rate of 1 A in units of B when liquidity is removed (denominator)
1039         uint128 removeAverageRateN; // average rate of 1 A in units of B when liquidity is removed (numerator)
1040         uint128 removeAverageRateD; // average rate of 1 A in units of B when liquidity is removed (denominator)
1041     }
1042 
1043     struct PoolIndex {
1044         bool isValid;
1045         uint256 value;
1046     }
1047 
1048     IERC20Token internal constant ETH_RESERVE_ADDRESS = IERC20Token(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1049     uint32 internal constant PPM_RESOLUTION = 1000000;
1050     uint256 internal constant MAX_UINT128 = 2**128 - 1;
1051 
1052     // the address of the whitelist administrator
1053     address public whitelistAdmin;
1054 
1055     // list of pools with less minting restrictions
1056     // mapping of pool anchor address -> index in the list of pools for quick access
1057     IConverterAnchor[] private _highTierPools;
1058     mapping(IConverterAnchor => PoolIndex) private highTierPoolIndices;
1059 
1060     ILiquidityProtectionStore public immutable store;
1061     IERC20Token public immutable networkToken;
1062     ITokenGovernance public immutable networkTokenGovernance;
1063     IERC20Token public immutable govToken;
1064     ITokenGovernance public immutable govTokenGovernance;
1065 
1066     // system network token balance limits
1067     uint256 public maxSystemNetworkTokenAmount = 1000000e18;
1068     uint32 public maxSystemNetworkTokenRatio = 500000; // PPM units
1069 
1070     // number of seconds until any protection is in effect
1071     uint256 public minProtectionDelay = 30 days;
1072 
1073     // number of seconds until full protection is in effect
1074     uint256 public maxProtectionDelay = 100 days;
1075 
1076     // minimum amount of network tokens the system can mint as compensation for base token losses, default = 0.01 network tokens
1077     uint256 public minNetworkCompensation = 1e16;
1078 
1079     // number of seconds from liquidation to full network token release
1080     uint256 public lockDuration = 24 hours;
1081 
1082     // maximum deviation of the average rate from the spot rate
1083     uint32 public averageRateMaxDeviation = 5000; // PPM units
1084 
1085     // true if the contract is currently adding/removing liquidity from a converter, used for accepting ETH
1086     bool private updatingLiquidity = false;
1087 
1088     /**
1089      * @dev triggered when whitelist admin is updated
1090      *
1091      * @param _prevWhitelistAdmin  previous whitelist admin
1092      * @param _newWhitelistAdmin   new whitelist admin
1093      */
1094     event WhitelistAdminUpdated(address indexed _prevWhitelistAdmin, address indexed _newWhitelistAdmin);
1095 
1096     /**
1097      * @dev triggered when the system network token balance limits are updated
1098      *
1099      * @param _prevMaxSystemNetworkTokenAmount  previous maximum absolute balance in a pool
1100      * @param _newMaxSystemNetworkTokenAmount   new maximum absolute balance in a pool
1101      * @param _prevMaxSystemNetworkTokenRatio   previos maximum balance out of the total balance in a pool
1102      * @param _newMaxSystemNetworkTokenRatio    new maximum balance out of the total balance in a pool
1103      */
1104     event SystemNetworkTokenLimitsUpdated(
1105         uint256 _prevMaxSystemNetworkTokenAmount,
1106         uint256 _newMaxSystemNetworkTokenAmount,
1107         uint256 _prevMaxSystemNetworkTokenRatio,
1108         uint256 _newMaxSystemNetworkTokenRatio
1109     );
1110 
1111     /**
1112      * @dev triggered when the protection delays are updated
1113      *
1114      * @param _prevMinProtectionDelay  previous seconds until the protection starts
1115      * @param _newMinProtectionDelay   new seconds until the protection starts
1116      * @param _prevMaxProtectionDelay  previos seconds until full protection
1117      * @param _newMaxProtectionDelay   new seconds until full protection
1118      */
1119     event ProtectionDelaysUpdated(
1120         uint256 _prevMinProtectionDelay,
1121         uint256 _newMinProtectionDelay,
1122         uint256 _prevMaxProtectionDelay,
1123         uint256 _newMaxProtectionDelay
1124     );
1125 
1126     /**
1127      * @dev triggered when the minimum network token compensation is updated
1128      *
1129      * @param _prevMinNetworkCompensation  previous minimum network token compensation
1130      * @param _newMinNetworkCompensation   new minimum network token compensation
1131      */
1132     event MinNetworkCompensationUpdated(uint256 _prevMinNetworkCompensation, uint256 _newMinNetworkCompensation);
1133 
1134     /**
1135      * @dev triggered when the network token lock duration is updated
1136      *
1137      * @param _prevLockDuration  previous network token lock duration, in seconds
1138      * @param _newLockDuration   new network token lock duration, in seconds
1139      */
1140     event LockDurationUpdated(uint256 _prevLockDuration, uint256 _newLockDuration);
1141 
1142     /**
1143      * @dev triggered when the maximum deviation of the average rate from the spot rate is updated
1144      *
1145      * @param _prevAverageRateMaxDeviation previous maximum deviation of the average rate from the spot rate
1146      * @param _newAverageRateMaxDeviation  new maximum deviation of the average rate from the spot rate
1147      */
1148     event AverageRateMaxDeviationUpdated(uint32 _prevAverageRateMaxDeviation, uint32 _newAverageRateMaxDeviation);
1149 
1150     /**
1151      * @dev initializes a new LiquidityProtection contract
1152      *
1153      * @param _store                    liquidity protection store
1154      * @param _networkTokenGovernance   network token governance
1155      * @param _govTokenGovernance       governance token governance
1156      * @param _registry                 contract registry
1157      */
1158     constructor(
1159         ILiquidityProtectionStore _store,
1160         ITokenGovernance _networkTokenGovernance,
1161         ITokenGovernance _govTokenGovernance,
1162         IContractRegistry _registry
1163     )
1164         public
1165         ContractRegistryClient(_registry)
1166         validAddress(address(_store))
1167         validAddress(address(_networkTokenGovernance))
1168         validAddress(address(_govTokenGovernance))
1169         validAddress(address(_registry))
1170         notThis(address(_store))
1171         notThis(address(_networkTokenGovernance))
1172         notThis(address(_govTokenGovernance))
1173         notThis(address(_registry))
1174     {
1175         whitelistAdmin = msg.sender;
1176         store = _store;
1177 
1178         networkTokenGovernance = _networkTokenGovernance;
1179         networkToken = IERC20Token(address(_networkTokenGovernance.token()));
1180         govTokenGovernance = _govTokenGovernance;
1181         govToken = IERC20Token(address(_govTokenGovernance.token()));
1182     }
1183 
1184     // ensures that the contract is currently removing liquidity from a converter
1185     modifier updatingLiquidityOnly() {
1186         _updatingLiquidityOnly();
1187         _;
1188     }
1189 
1190     // error message binary size optimization
1191     function _updatingLiquidityOnly() internal view {
1192         require(updatingLiquidity, "ERR_NOT_UPDATING_LIQUIDITY");
1193     }
1194 
1195     // ensures that the portion is valid
1196     modifier validPortion(uint32 _portion) {
1197         _validPortion(_portion);
1198         _;
1199     }
1200 
1201     // error message binary size optimization
1202     function _validPortion(uint32 _portion) internal pure {
1203         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PORTION");
1204     }
1205 
1206     // ensures that the pool is supported
1207     modifier poolSupported(IConverterAnchor _poolAnchor) {
1208         _poolSupported(_poolAnchor);
1209         _;
1210     }
1211 
1212     // error message binary size optimization
1213     function _poolSupported(IConverterAnchor _poolAnchor) internal view {
1214         require(isPoolSupported(_poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1215     }
1216 
1217     // ensures that the pool is whitelisted
1218     modifier poolWhitelisted(IConverterAnchor _poolAnchor) {
1219         _poolWhitelisted(_poolAnchor);
1220         _;
1221     }
1222 
1223     // error message binary size optimization
1224     function _poolWhitelisted(IConverterAnchor _poolAnchor) internal view {
1225         require(store.isPoolWhitelisted(_poolAnchor), "ERR_POOL_NOT_WHITELISTED");
1226     }
1227 
1228     /**
1229      * @dev accept ETH
1230      * used when removing liquidity from ETH converters
1231      */
1232     receive() external payable updatingLiquidityOnly() {}
1233 
1234     /**
1235      * @dev transfers the ownership of the store
1236      * can only be called by the contract owner
1237      *
1238      * @param _newOwner    the new owner of the store
1239      */
1240     function transferStoreOwnership(address _newOwner) external {
1241         transferOwnership(store, _newOwner);
1242     }
1243 
1244     /**
1245      * @dev accepts the ownership of the store
1246      * can only be called by the contract owner
1247      */
1248     function acceptStoreOwnership() external {
1249         acceptOwnership(store);
1250     }
1251 
1252     /**
1253      * @dev set the address of the whitelist admin
1254      * can only be called by the contract owner
1255      *
1256      * @param _whitelistAdmin  the address of the new whitelist admin
1257      */
1258     function setWhitelistAdmin(address _whitelistAdmin) external ownerOnly validAddress(_whitelistAdmin) {
1259         emit WhitelistAdminUpdated(whitelistAdmin, _whitelistAdmin);
1260 
1261         whitelistAdmin = _whitelistAdmin;
1262     }
1263 
1264     /**
1265      * @dev updates the system network token balance limits
1266      * can only be called by the contract owner
1267      *
1268      * @param _maxSystemNetworkTokenAmount  maximum absolute balance in a pool
1269      * @param _maxSystemNetworkTokenRatio   maximum balance out of the total balance in a pool (in PPM units)
1270      */
1271     function setSystemNetworkTokenLimits(uint256 _maxSystemNetworkTokenAmount, uint32 _maxSystemNetworkTokenRatio)
1272         external
1273         ownerOnly
1274         validPortion(_maxSystemNetworkTokenRatio)
1275     {
1276         emit SystemNetworkTokenLimitsUpdated(
1277             maxSystemNetworkTokenAmount,
1278             _maxSystemNetworkTokenAmount,
1279             maxSystemNetworkTokenRatio,
1280             _maxSystemNetworkTokenRatio
1281         );
1282 
1283         maxSystemNetworkTokenAmount = _maxSystemNetworkTokenAmount;
1284         maxSystemNetworkTokenRatio = _maxSystemNetworkTokenRatio;
1285     }
1286 
1287     /**
1288      * @dev updates the protection delays
1289      * can only be called by the contract owner
1290      *
1291      * @param _minProtectionDelay  seconds until the protection starts
1292      * @param _maxProtectionDelay  seconds until full protection
1293      */
1294     function setProtectionDelays(uint256 _minProtectionDelay, uint256 _maxProtectionDelay) external ownerOnly {
1295         require(_minProtectionDelay < _maxProtectionDelay, "ERR_INVALID_PROTECTION_DELAY");
1296 
1297         emit ProtectionDelaysUpdated(minProtectionDelay, _minProtectionDelay, maxProtectionDelay, _maxProtectionDelay);
1298 
1299         minProtectionDelay = _minProtectionDelay;
1300         maxProtectionDelay = _maxProtectionDelay;
1301     }
1302 
1303     /**
1304      * @dev updates the minimum network token compensation
1305      * can only be called by the contract owner
1306      *
1307      * @param _minCompensation new minimum compensation
1308      */
1309     function setMinNetworkCompensation(uint256 _minCompensation) external ownerOnly {
1310         emit MinNetworkCompensationUpdated(minNetworkCompensation, _minCompensation);
1311 
1312         minNetworkCompensation = _minCompensation;
1313     }
1314 
1315     /**
1316      * @dev updates the network token lock duration
1317      * can only be called by the contract owner
1318      *
1319      * @param _lockDuration    network token lock duration, in seconds
1320      */
1321     function setLockDuration(uint256 _lockDuration) external ownerOnly {
1322         emit LockDurationUpdated(lockDuration, _lockDuration);
1323 
1324         lockDuration = _lockDuration;
1325     }
1326 
1327     /**
1328      * @dev sets the maximum deviation of the average rate from the spot rate
1329      * can only be called by the contract owner
1330      *
1331      * @param _averageRateMaxDeviation maximum deviation of the average rate from the spot rate
1332      */
1333     function setAverageRateMaxDeviation(uint32 _averageRateMaxDeviation)
1334         external
1335         ownerOnly
1336         validPortion(_averageRateMaxDeviation)
1337     {
1338         emit AverageRateMaxDeviationUpdated(averageRateMaxDeviation, _averageRateMaxDeviation);
1339 
1340         averageRateMaxDeviation = _averageRateMaxDeviation;
1341     }
1342 
1343     /**
1344      * @dev adds a pool to the whitelist, or removes a pool from the whitelist
1345      * note that when a pool is whitelisted, it's not possible to remove liquidity anymore
1346      * removing a pool from the whitelist is an extreme measure in case of a base token compromise etc.
1347      * can only be called by the whitelist admin
1348      *
1349      * @param _poolAnchor  anchor of the pool
1350      * @param _add         true to add the pool to the whitelist, false to remove it from the whitelist
1351      */
1352     function whitelistPool(IConverterAnchor _poolAnchor, bool _add) external poolSupported(_poolAnchor) {
1353         require(msg.sender == whitelistAdmin || msg.sender == owner, "ERR_ACCESS_DENIED");
1354 
1355         // add or remove the pool to/from the whitelist
1356         if (_add) store.addPoolToWhitelist(_poolAnchor);
1357         else store.removePoolFromWhitelist(_poolAnchor);
1358     }
1359 
1360     /**
1361      * @dev adds a high tier pool
1362      * can only be called by the contract owner
1363      *
1364      * @param _poolAnchor pool anchor
1365      */
1366     function addHighTierPool(IConverterAnchor _poolAnchor)
1367         external
1368         ownerOnly
1369         validAddress(address(_poolAnchor))
1370         notThis(address(_poolAnchor))
1371     {
1372         // validate input
1373         PoolIndex storage poolIndex = highTierPoolIndices[_poolAnchor];
1374         require(!poolIndex.isValid, "ERR_POOL_ALREADY_EXISTS");
1375 
1376         poolIndex.value = _highTierPools.length;
1377         _highTierPools.push(_poolAnchor);
1378         poolIndex.isValid = true;
1379     }
1380 
1381     /**
1382      * @dev removes a high tier pool
1383      * can only be called by the contract owner
1384      *
1385      * @param _poolAnchor pool anchor
1386      */
1387     function removeHighTierPool(IConverterAnchor _poolAnchor)
1388         external
1389         ownerOnly
1390         validAddress(address(_poolAnchor))
1391         notThis(address(_poolAnchor))
1392     {
1393         // validate input
1394         PoolIndex storage poolIndex = highTierPoolIndices[_poolAnchor];
1395         require(poolIndex.isValid, "ERR_POOL_DOES_NOT_EXIST");
1396 
1397         uint256 index = poolIndex.value;
1398         uint256 length = _highTierPools.length;
1399         assert(length > 0);
1400 
1401         uint256 lastIndex = length - 1;
1402         if (index < lastIndex) {
1403             IConverterAnchor lastAnchor = _highTierPools[lastIndex];
1404             highTierPoolIndices[lastAnchor].value = index;
1405             _highTierPools[index] = lastAnchor;
1406         }
1407 
1408         _highTierPools.pop();
1409         delete highTierPoolIndices[_poolAnchor];
1410     }
1411 
1412     /**
1413      * @dev returns the list of high tier pools
1414      *
1415      * @return list of high tier pools
1416      */
1417     function highTierPools() external view returns (IConverterAnchor[] memory) {
1418         return _highTierPools;
1419     }
1420 
1421     /**
1422      * @dev checks whether a given pool is a high tier one
1423      *
1424      * @param _poolAnchor pool anchor
1425      * @return true if the given pool is a high tier one, false otherwise
1426      */
1427     function isHighTierPool(IConverterAnchor _poolAnchor) public view returns (bool) {
1428         return highTierPoolIndices[_poolAnchor].isValid;
1429     }
1430 
1431     /**
1432      * @dev checks if protection is supported for the given pool
1433      * only standard pools are supported (2 reserves, 50%/50% weights)
1434      * note that the pool should still be whitelisted
1435      *
1436      * @param _poolAnchor  anchor of the pool
1437      * @return true if the pool is supported, false otherwise
1438      */
1439     function isPoolSupported(IConverterAnchor _poolAnchor) public view returns (bool) {
1440         // save a local copy of `networkToken`
1441         IERC20Token networkTokenLocal = networkToken;
1442 
1443         // verify that the pool exists in the registry
1444         IConverterRegistry converterRegistry = IConverterRegistry(addressOf(CONVERTER_REGISTRY));
1445         require(converterRegistry.isAnchor(address(_poolAnchor)), "ERR_INVALID_ANCHOR");
1446 
1447         // get the converter
1448         IConverter converter = IConverter(payable(_poolAnchor.owner()));
1449 
1450         // verify that the converter has 2 reserves
1451         if (converter.connectorTokenCount() != 2) {
1452             return false;
1453         }
1454 
1455         // verify that one of the reserves is the network token
1456         IERC20Token reserve0Token = converter.connectorTokens(0);
1457         IERC20Token reserve1Token = converter.connectorTokens(1);
1458         if (reserve0Token != networkTokenLocal && reserve1Token != networkTokenLocal) {
1459             return false;
1460         }
1461 
1462         // verify that the reserve weights are exactly 50%/50%
1463         if (
1464             converterReserveWeight(converter, reserve0Token) != PPM_RESOLUTION / 2 ||
1465             converterReserveWeight(converter, reserve1Token) != PPM_RESOLUTION / 2
1466         ) {
1467             return false;
1468         }
1469 
1470         return true;
1471     }
1472 
1473     /**
1474      * @dev adds protection to existing pool tokens
1475      * also mints new governance tokens for the caller
1476      *
1477      * @param _poolAnchor  anchor of the pool
1478      * @param _amount      amount of pool tokens to protect
1479      */
1480     function protectLiquidity(IConverterAnchor _poolAnchor, uint256 _amount)
1481         external
1482         protected
1483         poolSupported(_poolAnchor)
1484         poolWhitelisted(_poolAnchor)
1485         greaterThanZero(_amount)
1486     {
1487         // get the converter
1488         IConverter converter = IConverter(payable(_poolAnchor.owner()));
1489 
1490         // save a local copy of `networkToken`
1491         IERC20Token networkTokenLocal = networkToken;
1492 
1493         // protect both reserves
1494         IDSToken poolToken = IDSToken(address(_poolAnchor));
1495         protectLiquidity(poolToken, converter, networkTokenLocal, 0, _amount / 2);
1496         protectLiquidity(poolToken, converter, networkTokenLocal, 1, _amount - _amount / 2);
1497 
1498         // transfer the pool tokens from the caller directly to the store
1499         safeTransferFrom(poolToken, msg.sender, address(store), _amount);
1500     }
1501 
1502     /**
1503      * @dev cancels the protection and returns the pool tokens to the caller
1504      * also burns governance tokens from the caller
1505      * must be called with the indices of both the base token and the network token protections
1506      *
1507      * @param _id1 id in the caller's list of protected liquidity
1508      * @param _id2 matching id in the caller's list of protected liquidity
1509      */
1510     function unprotectLiquidity(uint256 _id1, uint256 _id2) external protected {
1511         require(_id1 != _id2, "ERR_SAME_ID");
1512 
1513         ProtectedLiquidity memory liquidity1 = protectedLiquidity(_id1, msg.sender);
1514         ProtectedLiquidity memory liquidity2 = protectedLiquidity(_id2, msg.sender);
1515 
1516         // save a local copy of `networkToken`
1517         IERC20Token networkTokenLocal = networkToken;
1518 
1519         // verify that the two protections were added together (using `protect`)
1520         require(
1521             liquidity1.poolToken == liquidity2.poolToken &&
1522                 liquidity1.reserveToken != liquidity2.reserveToken &&
1523                 (liquidity1.reserveToken == networkTokenLocal || liquidity2.reserveToken == networkTokenLocal) &&
1524                 liquidity1.timestamp == liquidity2.timestamp &&
1525                 liquidity1.poolAmount <= liquidity2.poolAmount.add(1) &&
1526                 liquidity2.poolAmount <= liquidity1.poolAmount.add(1),
1527             "ERR_PROTECTIONS_MISMATCH"
1528         );
1529 
1530         // burn the governance tokens from the caller. we need to transfer the tokens to the contract itself, since only
1531         // token holders can burn their tokens
1532         uint256 amount = liquidity1.reserveToken == networkTokenLocal ? liquidity1.reserveAmount : liquidity2.reserveAmount;
1533         safeTransferFrom(govToken, msg.sender, address(this), amount);
1534         govTokenGovernance.burn(amount);
1535 
1536         // remove the protected liquidities from the store
1537         store.removeProtectedLiquidity(_id1);
1538         store.removeProtectedLiquidity(_id2);
1539 
1540         // transfer the pool tokens back to the caller
1541         store.withdrawTokens(liquidity1.poolToken, msg.sender, liquidity1.poolAmount.add(liquidity2.poolAmount));
1542     }
1543 
1544     /**
1545      * @dev adds protected liquidity to a pool
1546      * also mints new governance tokens for the caller if the caller adds network tokens
1547      *
1548      * @param _poolAnchor      anchor of the pool
1549      * @param _reserveToken    reserve token to add to the pool
1550      * @param _amount          amount of tokens to add to the pool
1551      * @return new protected liquidity id
1552      */
1553     function addLiquidity(IConverterAnchor _poolAnchor, IERC20Token _reserveToken, uint256 _amount)
1554         external
1555         payable
1556         protected
1557         poolSupported(_poolAnchor)
1558         poolWhitelisted(_poolAnchor)
1559         greaterThanZero(_amount)
1560         returns (uint256)
1561     {
1562         // save a local copy of `networkToken`
1563         IERC20Token networkTokenLocal = networkToken;
1564 
1565         if (_reserveToken == networkTokenLocal) {
1566             require(msg.value == 0, "ERR_ETH_AMOUNT_MISMATCH");
1567             return addNetworkTokenLiquidity(_poolAnchor, networkTokenLocal, _amount);
1568         }
1569 
1570         // verify that ETH was passed with the call if needed
1571         uint256 val = _reserveToken == ETH_RESERVE_ADDRESS ? _amount : 0;
1572         require(msg.value == val, "ERR_ETH_AMOUNT_MISMATCH");
1573         return addBaseTokenLiquidity(_poolAnchor, _reserveToken, networkTokenLocal, _amount);
1574     }
1575 
1576     /**
1577      * @dev adds protected network token liquidity to a pool
1578      * also mints new governance tokens for the caller
1579      *
1580      * @param _poolAnchor   anchor of the pool
1581      * @param _networkToken the network reserve token of the pool
1582      * @param _amount       amount of tokens to add to the pool
1583      * @return new protected liquidity id
1584      */
1585     function addNetworkTokenLiquidity(IConverterAnchor _poolAnchor, IERC20Token _networkToken, uint256 _amount) internal returns (uint256) {
1586         IDSToken poolToken = IDSToken(address(_poolAnchor));
1587 
1588         // get the rate between the pool token and the reserve
1589         Fraction memory poolRate = poolTokenRate(poolToken, _networkToken);
1590 
1591         // calculate the amount of pool tokens based on the amount of reserve tokens
1592         uint256 poolTokenAmount = _amount.mul(poolRate.d).div(poolRate.n);
1593 
1594         // remove the pool tokens from the system's ownership (will revert if not enough tokens are available)
1595         store.decSystemBalance(poolToken, poolTokenAmount);
1596 
1597         // add protected liquidity for the caller
1598         uint256 id = addProtectedLiquidity(msg.sender, poolToken, _networkToken, poolTokenAmount, _amount);
1599 
1600         // burns the network tokens from the caller. we need to transfer the tokens to the contract itself, since only
1601         // token holders can burn their tokens
1602         safeTransferFrom(_networkToken, msg.sender, address(this), _amount);
1603         networkTokenGovernance.burn(_amount);
1604 
1605         // mint governance tokens to the caller
1606         govTokenGovernance.mint(msg.sender, _amount);
1607 
1608         return id;
1609     }
1610 
1611     /**
1612      * @dev adds protected base token liquidity to a pool
1613      *
1614      * @param _poolAnchor   anchor of the pool
1615      * @param _baseToken    the base reserve token of the pool
1616      * @param _networkToken the network reserve token of the pool
1617      * @param _amount       amount of tokens to add to the pool
1618      * @return new protected liquidity id
1619      */
1620     function addBaseTokenLiquidity(
1621         IConverterAnchor _poolAnchor,
1622         IERC20Token _baseToken,
1623         IERC20Token _networkToken,
1624         uint256 _amount
1625     ) internal returns (uint256) {
1626         IDSToken poolToken = IDSToken(address(_poolAnchor));
1627 
1628         // get the reserve balances
1629         ILiquidityPoolV1Converter converter = ILiquidityPoolV1Converter(payable(_poolAnchor.owner()));
1630         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) = converterReserveBalances(
1631             converter,
1632             _baseToken,
1633             _networkToken
1634         );
1635 
1636         // calculate and mint the required amount of network tokens for adding liquidity
1637         uint256 networkLiquidityAmount = _amount.mul(reserveBalanceNetwork).div(reserveBalanceBase);
1638 
1639         // verify network token limits
1640         // note that the amount is divided by 2 since it's not possible to liquidate one reserve only
1641         Fraction memory poolRate = poolTokenRate(poolToken, _networkToken);
1642         uint256 newSystemBalance = store.systemBalance(poolToken);
1643         newSystemBalance = (newSystemBalance.mul(poolRate.n / 2).div(poolRate.d)).add(networkLiquidityAmount);
1644 
1645         require(newSystemBalance <= maxSystemNetworkTokenAmount, "ERR_MAX_AMOUNT_REACHED");
1646 
1647         if (!isHighTierPool(_poolAnchor)) {
1648             require(
1649                 newSystemBalance.mul(PPM_RESOLUTION) <=
1650                     reserveBalanceNetwork.add(networkLiquidityAmount).mul(maxSystemNetworkTokenRatio),
1651                 "ERR_MAX_RATIO_REACHED"
1652             );
1653         }
1654 
1655         // issue new network tokens to the system
1656         networkTokenGovernance.mint(address(this), networkLiquidityAmount);
1657 
1658         // transfer the base tokens from the caller and approve the converter
1659         ensureAllowance(_networkToken, address(converter), networkLiquidityAmount);
1660         if (_baseToken != ETH_RESERVE_ADDRESS) {
1661             safeTransferFrom(_baseToken, msg.sender, address(this), _amount);
1662             ensureAllowance(_baseToken, address(converter), _amount);
1663         }
1664 
1665         // add liquidity
1666         addLiquidity(converter, _baseToken, _networkToken, _amount, networkLiquidityAmount, msg.value);
1667 
1668         // transfer the new pool tokens to the store
1669         uint256 poolTokenAmount = poolToken.balanceOf(address(this));
1670         safeTransfer(poolToken, address(store), poolTokenAmount);
1671 
1672         // the system splits the pool tokens with the caller
1673         // increase the system's pool token balance and add protected liquidity for the caller
1674         store.incSystemBalance(poolToken, poolTokenAmount - poolTokenAmount / 2); // account for rounding errors
1675         return addProtectedLiquidity(msg.sender, poolToken, _baseToken, poolTokenAmount / 2, _amount);
1676     }
1677 
1678     /**
1679      * @dev transfers protected liquidity to a new provider
1680      *
1681      * @param _id          protected liquidity id
1682      * @param _newProvider new provider
1683      * @return new protected liquidity id
1684      */
1685     function transferLiquidity(uint256 _id, address _newProvider)
1686         external
1687         protected
1688         validAddress(_newProvider)
1689         notThis(_newProvider)
1690         returns (uint256)
1691     {
1692         ProtectedLiquidity memory liquidity = protectedLiquidity(_id, msg.sender);
1693 
1694         // remove the protected liquidity from the current provider
1695         store.removeProtectedLiquidity(_id);
1696 
1697         // add the protected liquidity to the new provider
1698         return
1699             store.addProtectedLiquidity(
1700                 _newProvider,
1701                 liquidity.poolToken,
1702                 liquidity.reserveToken,
1703                 liquidity.poolAmount,
1704                 liquidity.reserveAmount,
1705                 liquidity.reserveRateN,
1706                 liquidity.reserveRateD,
1707                 liquidity.timestamp
1708             );
1709     }
1710 
1711     /**
1712      * @dev returns the expected/actual amounts the provider will receive for removing liquidity
1713      * it's also possible to provide the remove liquidity time to get an estimation
1714      * for the return at that given point
1715      *
1716      * @param _id              protected liquidity id
1717      * @param _portion         portion of liquidity to remove, in PPM
1718      * @param _removeTimestamp time at which the liquidity is removed
1719      * @return expected return amount in the reserve token
1720      * @return actual return amount in the reserve token
1721      * @return compensation in the network token
1722      */
1723     function removeLiquidityReturn(
1724         uint256 _id,
1725         uint32 _portion,
1726         uint256 _removeTimestamp
1727     )
1728         external
1729         view
1730         validPortion(_portion)
1731         returns (
1732             uint256,
1733             uint256,
1734             uint256
1735         )
1736     {
1737         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
1738 
1739         // verify input
1740         require(liquidity.provider != address(0), "ERR_INVALID_ID");
1741         require(_removeTimestamp >= liquidity.timestamp, "ERR_INVALID_TIMESTAMP");
1742 
1743         // calculate the portion of the liquidity to remove
1744         if (_portion != PPM_RESOLUTION) {
1745             liquidity.poolAmount = liquidity.poolAmount.mul(_portion) / PPM_RESOLUTION;
1746             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion) / PPM_RESOLUTION;
1747         }
1748 
1749         // get the various rates between the reserves upon adding liquidity and now
1750         PackedRates memory packedRates = packRates(
1751             liquidity.poolToken,
1752             liquidity.reserveToken,
1753             liquidity.reserveRateN,
1754             liquidity.reserveRateD
1755         );
1756 
1757         uint256 targetAmount = removeLiquidityTargetAmount(
1758             liquidity.poolToken,
1759             liquidity.reserveToken,
1760             liquidity.poolAmount,
1761             liquidity.reserveAmount,
1762             packedRates,
1763             liquidity.timestamp,
1764             _removeTimestamp
1765         );
1766 
1767         // for network token, the return amount is identical to the target amount
1768         if (liquidity.reserveToken == networkToken) {
1769             return (targetAmount, targetAmount, 0);
1770         }
1771 
1772         // handle base token return
1773 
1774         // calculate the amount of pool tokens required for liquidation
1775         // note that the amount is doubled since it's not possible to liquidate one reserve only
1776         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1777         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
1778 
1779         // limit the amount of pool tokens by the amount the system/caller holds
1780         uint256 availableBalance = store.systemBalance(liquidity.poolToken).add(liquidity.poolAmount);
1781         poolAmount = poolAmount > availableBalance ? availableBalance : poolAmount;
1782 
1783         // calculate the base token amount received by liquidating the pool tokens
1784         // note that the amount is divided by 2 since the pool amount represents both reserves
1785         uint256 baseAmount = poolAmount.mul(poolRate.n / 2).div(poolRate.d);
1786         uint256 networkAmount = getNetworkCompensation(targetAmount, baseAmount, packedRates);
1787 
1788         return (targetAmount, baseAmount, networkAmount);
1789     }
1790 
1791     /**
1792      * @dev removes protected liquidity from a pool
1793      * also burns governance tokens from the caller if the caller removes network tokens
1794      *
1795      * @param _id      id in the caller's list of protected liquidity
1796      * @param _portion portion of liquidity to remove, in PPM
1797      */
1798     function removeLiquidity(uint256 _id, uint32 _portion) external validPortion(_portion) protected {
1799         ProtectedLiquidity memory liquidity = protectedLiquidity(_id, msg.sender);
1800 
1801         // save a local copy of `networkToken`
1802         IERC20Token networkTokenLocal = networkToken;
1803 
1804         // verify that the pool is whitelisted
1805         _poolWhitelisted(liquidity.poolToken);
1806 
1807         if (_portion == PPM_RESOLUTION) {
1808             // remove the pool tokens from the provider
1809             store.removeProtectedLiquidity(_id);
1810         } else {
1811             // remove portion of the pool tokens from the provider
1812             uint256 fullPoolAmount = liquidity.poolAmount;
1813             uint256 fullReserveAmount = liquidity.reserveAmount;
1814             liquidity.poolAmount = liquidity.poolAmount.mul(_portion) / PPM_RESOLUTION;
1815             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion) / PPM_RESOLUTION;
1816 
1817             store.updateProtectedLiquidityAmounts(
1818                 _id,
1819                 fullPoolAmount - liquidity.poolAmount,
1820                 fullReserveAmount - liquidity.reserveAmount
1821             );
1822         }
1823 
1824         // add the pool tokens to the system
1825         store.incSystemBalance(liquidity.poolToken, liquidity.poolAmount);
1826 
1827         // if removing network token liquidity, burn the governance tokens from the caller. we need to transfer the
1828         // tokens to the contract itself, since only token holders can burn their tokens
1829         if (liquidity.reserveToken == networkTokenLocal) {
1830             safeTransferFrom(govToken, msg.sender, address(this), liquidity.reserveAmount);
1831             govTokenGovernance.burn(liquidity.reserveAmount);
1832         }
1833 
1834         // get the various rates between the reserves upon adding liquidity and now
1835         PackedRates memory packedRates = packRates(
1836             liquidity.poolToken,
1837             liquidity.reserveToken,
1838             liquidity.reserveRateN,
1839             liquidity.reserveRateD
1840         );
1841 
1842         // get the target token amount
1843         uint256 targetAmount = removeLiquidityTargetAmount(
1844             liquidity.poolToken,
1845             liquidity.reserveToken,
1846             liquidity.poolAmount,
1847             liquidity.reserveAmount,
1848             packedRates,
1849             liquidity.timestamp,
1850             time()
1851         );
1852 
1853         // remove network token liquidity
1854         if (liquidity.reserveToken == networkTokenLocal) {
1855             // mint network tokens for the caller and lock them
1856             networkTokenGovernance.mint(address(store), targetAmount);
1857             lockTokens(msg.sender, targetAmount);
1858             return;
1859         }
1860 
1861         // remove base token liquidity
1862 
1863         // calculate the amount of pool tokens required for liquidation
1864         // note that the amount is doubled since it's not possible to liquidate one reserve only
1865         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1866         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
1867 
1868         // limit the amount of pool tokens by the amount the system holds
1869         uint256 systemBalance = store.systemBalance(liquidity.poolToken);
1870         poolAmount = poolAmount > systemBalance ? systemBalance : poolAmount;
1871 
1872         // withdraw the pool tokens from the store
1873         store.decSystemBalance(liquidity.poolToken, poolAmount);
1874         store.withdrawTokens(liquidity.poolToken, address(this), poolAmount);
1875 
1876         // remove liquidity
1877         removeLiquidity(liquidity.poolToken, poolAmount, liquidity.reserveToken, networkTokenLocal);
1878 
1879         // transfer the base tokens to the caller
1880         uint256 baseBalance;
1881         if (liquidity.reserveToken == ETH_RESERVE_ADDRESS) {
1882             baseBalance = address(this).balance;
1883             msg.sender.transfer(baseBalance);
1884         } else {
1885             baseBalance = liquidity.reserveToken.balanceOf(address(this));
1886             safeTransfer(liquidity.reserveToken, msg.sender, baseBalance);
1887         }
1888 
1889         // compensate the caller with network tokens if still needed
1890         uint256 delta = getNetworkCompensation(targetAmount, baseBalance, packedRates);
1891         if (delta > 0) {
1892             // check if there's enough network token balance, otherwise mint more
1893             uint256 networkBalance = networkTokenLocal.balanceOf(address(this));
1894             if (networkBalance < delta) {
1895                 networkTokenGovernance.mint(address(this), delta - networkBalance);
1896             }
1897 
1898             // lock network tokens for the caller
1899             safeTransfer(networkTokenLocal, address(store), delta);
1900             lockTokens(msg.sender, delta);
1901         }
1902 
1903         // if the contract still holds network token, burn them
1904         uint256 networkBalance = networkTokenLocal.balanceOf(address(this));
1905         if (networkBalance > 0) {
1906             networkTokenGovernance.burn(networkBalance);
1907         }
1908     }
1909 
1910     /**
1911      * @dev returns the amount the provider will receive for removing liquidity
1912      * it's also possible to provide the remove liquidity rate & time to get an estimation
1913      * for the return at that given point
1914      *
1915      * @param _poolToken       pool token
1916      * @param _reserveToken    reserve token
1917      * @param _poolAmount      pool token amount when the liquidity was added
1918      * @param _reserveAmount   reserve token amount that was added
1919      * @param _packedRates     see `struct PackedRates`
1920      * @param _addTimestamp    time at which the liquidity was added
1921      * @param _removeTimestamp time at which the liquidity is removed
1922      * @return amount received for removing liquidity
1923      */
1924     function removeLiquidityTargetAmount(
1925         IDSToken _poolToken,
1926         IERC20Token _reserveToken,
1927         uint256 _poolAmount,
1928         uint256 _reserveAmount,
1929         PackedRates memory _packedRates,
1930         uint256 _addTimestamp,
1931         uint256 _removeTimestamp
1932     ) internal view returns (uint256) {
1933         // get the rate between the reserves upon adding liquidity and now
1934         Fraction memory addSpotRate = Fraction({ n: _packedRates.addSpotRateN, d: _packedRates.addSpotRateD });
1935         Fraction memory removeSpotRate = Fraction({ n: _packedRates.removeSpotRateN, d: _packedRates.removeSpotRateD });
1936         Fraction memory removeAverageRate = Fraction({
1937             n: _packedRates.removeAverageRateN,
1938             d: _packedRates.removeAverageRateD
1939         });
1940 
1941         // calculate the protected amount of reserve tokens plus accumulated fee before compensation
1942         uint256 total = protectedAmountPlusFee(_poolToken, _reserveToken, _poolAmount, addSpotRate, removeSpotRate);
1943         if (total < _reserveAmount) {
1944             total = _reserveAmount;
1945         }
1946 
1947         // calculate the impermanent loss
1948         Fraction memory loss = impLoss(addSpotRate, removeAverageRate);
1949 
1950         // calculate the protection level
1951         Fraction memory level = protectionLevel(_addTimestamp, _removeTimestamp);
1952 
1953         // calculate the compensation amount
1954         return compensationAmount(_reserveAmount, total, loss, level);
1955     }
1956 
1957     /**
1958      * @dev allows the caller to claim network token balance that is no longer locked
1959      * note that the function can revert if the range is too large
1960      *
1961      * @param _startIndex  start index in the caller's list of locked balances
1962      * @param _endIndex    end index in the caller's list of locked balances (exclusive)
1963      */
1964     function claimBalance(uint256 _startIndex, uint256 _endIndex) external protected {
1965         // get the locked balances from the store
1966         (uint256[] memory amounts, uint256[] memory expirationTimes) = store.lockedBalanceRange(
1967             msg.sender,
1968             _startIndex,
1969             _endIndex
1970         );
1971 
1972         uint256 totalAmount = 0;
1973         uint256 length = amounts.length;
1974         assert(length == expirationTimes.length);
1975 
1976         // reverse iteration since we're removing from the list
1977         for (uint256 i = length; i > 0; i--) {
1978             uint256 index = i - 1;
1979             if (expirationTimes[index] > time()) {
1980                 continue;
1981             }
1982 
1983             // remove the locked balance item
1984             store.removeLockedBalance(msg.sender, _startIndex + index);
1985             totalAmount = totalAmount.add(amounts[index]);
1986         }
1987 
1988         if (totalAmount > 0) {
1989             // transfer the tokens to the caller in a single call
1990             store.withdrawTokens(networkToken, msg.sender, totalAmount);
1991         }
1992     }
1993 
1994     /**
1995      * @dev returns the ROI for removing liquidity in the current state after providing liquidity with the given args
1996      * the function assumes full protection is in effect
1997      * return value is in PPM and can be larger than PPM_RESOLUTION for positive ROI, 1M = 0% ROI
1998      *
1999      * @param _poolToken       pool token
2000      * @param _reserveToken    reserve token
2001      * @param _reserveAmount   reserve token amount that was added
2002      * @param _poolRateN       rate of 1 pool token in reserve token units when the liquidity was added (numerator)
2003      * @param _poolRateD       rate of 1 pool token in reserve token units when the liquidity was added (denominator)
2004      * @param _reserveRateN    rate of 1 reserve token in the other reserve token units when the liquidity was added (numerator)
2005      * @param _reserveRateD    rate of 1 reserve token in the other reserve token units when the liquidity was added (denominator)
2006      * @return ROI in PPM
2007      */
2008     function poolROI(
2009         IDSToken _poolToken,
2010         IERC20Token _reserveToken,
2011         uint256 _reserveAmount,
2012         uint256 _poolRateN,
2013         uint256 _poolRateD,
2014         uint256 _reserveRateN,
2015         uint256 _reserveRateD
2016     ) external view returns (uint256) {
2017         // calculate the amount of pool tokens based on the amount of reserve tokens
2018         uint256 poolAmount = _reserveAmount.mul(_poolRateD).div(_poolRateN);
2019 
2020         // get the various rates between the reserves upon adding liquidity and now
2021         PackedRates memory packedRates = packRates(_poolToken, _reserveToken, _reserveRateN, _reserveRateD);
2022 
2023         // get the current return
2024         uint256 protectedReturn = removeLiquidityTargetAmount(
2025             _poolToken,
2026             _reserveToken,
2027             poolAmount,
2028             _reserveAmount,
2029             packedRates,
2030             time().sub(maxProtectionDelay),
2031             time()
2032         );
2033 
2034         // calculate the ROI as the ratio between the current fully protected return and the initial amount
2035         return protectedReturn.mul(PPM_RESOLUTION).div(_reserveAmount);
2036     }
2037 
2038     /**
2039      * @dev utility to protect existing liquidity
2040      * also mints new governance tokens for the caller when protecting the network token reserve
2041      *
2042      * @param _poolAnchor      pool anchor
2043      * @param _converter       pool converter
2044      * @param _networkToken    the network reserve token of the pool
2045      * @param _reserveIndex    index of the reserve to protect
2046      * @param _poolAmount      amount of pool tokens to protect
2047      */
2048     function protectLiquidity(
2049         IDSToken _poolAnchor,
2050         IConverter _converter,
2051         IERC20Token _networkToken,
2052         uint256 _reserveIndex,
2053         uint256 _poolAmount
2054     ) internal {
2055         // get the reserves token
2056         IERC20Token reserveToken = _converter.connectorTokens(_reserveIndex);
2057 
2058         // get the pool token rate
2059         IDSToken poolToken = IDSToken(address(_poolAnchor));
2060         Fraction memory poolRate = poolTokenRate(poolToken, reserveToken);
2061 
2062         // calculate the reserve balance based on the amount provided and the pool token rate
2063         uint256 reserveAmount = _poolAmount.mul(poolRate.n).div(poolRate.d);
2064 
2065         // protect the liquidity
2066         addProtectedLiquidity(msg.sender, poolToken, reserveToken, _poolAmount, reserveAmount);
2067 
2068         // for network token liquidity, mint governance tokens to the caller
2069         if (reserveToken == _networkToken) {
2070             govTokenGovernance.mint(msg.sender, reserveAmount);
2071         }
2072     }
2073 
2074     /**
2075      * @dev adds protected liquidity for the caller to the store
2076      *
2077      * @param _provider        protected liquidity provider
2078      * @param _poolToken       pool token
2079      * @param _reserveToken    reserve token
2080      * @param _poolAmount      amount of pool tokens to protect
2081      * @param _reserveAmount   amount of reserve tokens to protect
2082      * @return new protected liquidity id
2083      */
2084     function addProtectedLiquidity(
2085         address _provider,
2086         IDSToken _poolToken,
2087         IERC20Token _reserveToken,
2088         uint256 _poolAmount,
2089         uint256 _reserveAmount
2090     ) internal returns (uint256) {
2091         Fraction memory rate = reserveTokenAverageRate(_poolToken, _reserveToken);
2092         return
2093             store.addProtectedLiquidity(
2094                 _provider,
2095                 _poolToken,
2096                 _reserveToken,
2097                 _poolAmount,
2098                 _reserveAmount,
2099                 rate.n,
2100                 rate.d,
2101                 time()
2102             );
2103     }
2104 
2105     /**
2106      * @dev locks network tokens for the provider and emits the tokens locked event
2107      *
2108      * @param _provider    tokens provider
2109      * @param _amount      amount of network tokens
2110      */
2111     function lockTokens(address _provider, uint256 _amount) internal {
2112         uint256 expirationTime = time().add(lockDuration);
2113         store.addLockedBalance(_provider, _amount, expirationTime);
2114     }
2115 
2116     /**
2117      * @dev returns the rate of 1 pool token in reserve token units
2118      *
2119      * @param _poolToken       pool token
2120      * @param _reserveToken    reserve token
2121      */
2122     function poolTokenRate(IDSToken _poolToken, IERC20Token _reserveToken) internal view returns (Fraction memory) {
2123         // get the pool token supply
2124         uint256 poolTokenSupply = _poolToken.totalSupply();
2125 
2126         // get the reserve balance
2127         IConverter converter = IConverter(payable(_poolToken.owner()));
2128         uint256 reserveBalance = converter.getConnectorBalance(_reserveToken);
2129 
2130         // for standard pools, 50% of the pool supply value equals the value of each reserve
2131         return Fraction({ n: reserveBalance.mul(2), d: poolTokenSupply });
2132     }
2133 
2134     /**
2135      * @dev returns the average rate of 1 reserve token in the other reserve token units
2136      *
2137      * @param _poolToken       pool token
2138      * @param _reserveToken    reserve token
2139      */
2140     function reserveTokenAverageRate(IDSToken _poolToken, IERC20Token _reserveToken)
2141         internal
2142         view
2143         returns (Fraction memory)
2144     {
2145         (, , uint256 averageRateN, uint256 averageRateD) = reserveTokenRates(_poolToken, _reserveToken);
2146         return Fraction(averageRateN, averageRateD);
2147     }
2148 
2149     /**
2150      * @dev returns the spot rate and average rate of 1 reserve token in the other reserve token units
2151      *
2152      * @param _poolToken       pool token
2153      * @param _reserveToken    reserve token
2154      */
2155     function reserveTokenRates(IDSToken _poolToken, IERC20Token _reserveToken)
2156         internal
2157         view
2158         returns (
2159             uint256,
2160             uint256,
2161             uint256,
2162             uint256
2163         )
2164     {
2165         ILiquidityPoolV1Converter converter = ILiquidityPoolV1Converter(payable(_poolToken.owner()));
2166 
2167         IERC20Token otherReserve = converter.connectorTokens(0);
2168         if (otherReserve == _reserveToken) {
2169             otherReserve = converter.connectorTokens(1);
2170         }
2171 
2172         (uint256 spotRateN, uint256 spotRateD) = converterReserveBalances(converter, otherReserve, _reserveToken);
2173         (uint256 averageRateN, uint256 averageRateD) = converter.recentAverageRate(_reserveToken);
2174 
2175         require(
2176             averageRateInRange(spotRateN, spotRateD, averageRateN, averageRateD, averageRateMaxDeviation),
2177             "ERR_INVALID_RATE"
2178         );
2179 
2180         return (spotRateN, spotRateD, averageRateN, averageRateD);
2181     }
2182 
2183     /**
2184      * @dev returns the various rates between the reserves
2185      *
2186      * @param _poolToken       pool token
2187      * @param _reserveToken    reserve token
2188      * @param _addSpotRateN    add spot rate numerator
2189      * @param _addSpotRateD    add spot rate denominator
2190      * @return see `struct PackedRates`
2191      */
2192     function packRates(
2193         IDSToken _poolToken,
2194         IERC20Token _reserveToken,
2195         uint256 _addSpotRateN,
2196         uint256 _addSpotRateD
2197     ) internal view returns (PackedRates memory) {
2198         (
2199             uint256 removeSpotRateN,
2200             uint256 removeSpotRateD,
2201             uint256 removeAverageRateN,
2202             uint256 removeAverageRateD
2203         ) = reserveTokenRates(_poolToken, _reserveToken);
2204 
2205         require(
2206             (_addSpotRateN <= MAX_UINT128 && _addSpotRateD <= MAX_UINT128) &&
2207                 (removeSpotRateN <= MAX_UINT128 && removeSpotRateD <= MAX_UINT128) &&
2208                 (removeAverageRateN <= MAX_UINT128 && removeAverageRateD <= MAX_UINT128),
2209             "ERR_INVALID_RATE"
2210         );
2211 
2212         return
2213             PackedRates({
2214                 addSpotRateN: uint128(_addSpotRateN),
2215                 addSpotRateD: uint128(_addSpotRateD),
2216                 removeSpotRateN: uint128(removeSpotRateN),
2217                 removeSpotRateD: uint128(removeSpotRateD),
2218                 removeAverageRateN: uint128(removeAverageRateN),
2219                 removeAverageRateD: uint128(removeAverageRateD)
2220             });
2221     }
2222 
2223     /**
2224      * @dev returns whether or not the deviation of the average rate from the spot rate is within range
2225      * for example, if the maximum permitted deviation is 5%, then return `95/100 <= average/spot <= 100/95`
2226      *
2227      * @param _spotRateN       spot rate numerator
2228      * @param _spotRateD       spot rate denominator
2229      * @param _averageRateN    average rate numerator
2230      * @param _averageRateD    average rate denominator
2231      * @param _maxDeviation    the maximum permitted deviation of the average rate from the spot rate
2232      */
2233     function averageRateInRange(
2234         uint256 _spotRateN,
2235         uint256 _spotRateD,
2236         uint256 _averageRateN,
2237         uint256 _averageRateD,
2238         uint32 _maxDeviation
2239     ) internal pure returns (bool) {
2240         uint256 min = _spotRateN.mul(_averageRateD).mul(PPM_RESOLUTION - _maxDeviation).mul(
2241             PPM_RESOLUTION - _maxDeviation
2242         );
2243         uint256 mid = _spotRateD.mul(_averageRateN).mul(PPM_RESOLUTION - _maxDeviation).mul(PPM_RESOLUTION);
2244         uint256 max = _spotRateN.mul(_averageRateD).mul(PPM_RESOLUTION).mul(PPM_RESOLUTION);
2245         return min <= mid && mid <= max;
2246     }
2247 
2248     /**
2249      * @dev utility to add liquidity to a converter
2250      *
2251      * @param _converter       converter
2252      * @param _reserveToken1   reserve token 1
2253      * @param _reserveToken2   reserve token 2
2254      * @param _reserveAmount1  reserve amount 1
2255      * @param _reserveAmount2  reserve amount 2
2256      * @param _value           ETH amount to add
2257      */
2258     function addLiquidity(
2259         ILiquidityPoolV1Converter _converter,
2260         IERC20Token _reserveToken1,
2261         IERC20Token _reserveToken2,
2262         uint256 _reserveAmount1,
2263         uint256 _reserveAmount2,
2264         uint256 _value
2265     ) internal {
2266         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
2267         uint256[] memory amounts = new uint256[](2);
2268         reserveTokens[0] = _reserveToken1;
2269         reserveTokens[1] = _reserveToken2;
2270         amounts[0] = _reserveAmount1;
2271         amounts[1] = _reserveAmount2;
2272 
2273         // ensure that the contract can receive ETH
2274         updatingLiquidity = true;
2275         _converter.addLiquidity{ value: _value }(reserveTokens, amounts, 1);
2276         updatingLiquidity = false;
2277     }
2278 
2279     /**
2280      * @dev utility to remove liquidity from a converter
2281      *
2282      * @param _poolToken       pool token of the converter
2283      * @param _poolAmount      amount of pool tokens to remove
2284      * @param _reserveToken1   reserve token 1
2285      * @param _reserveToken2   reserve token 2
2286      */
2287     function removeLiquidity(
2288         IDSToken _poolToken,
2289         uint256 _poolAmount,
2290         IERC20Token _reserveToken1,
2291         IERC20Token _reserveToken2
2292     ) internal {
2293         ILiquidityPoolV1Converter converter = ILiquidityPoolV1Converter(payable(_poolToken.owner()));
2294 
2295         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
2296         uint256[] memory minReturns = new uint256[](2);
2297         reserveTokens[0] = _reserveToken1;
2298         reserveTokens[1] = _reserveToken2;
2299         minReturns[0] = 1;
2300         minReturns[1] = 1;
2301 
2302         // ensure that the contract can receive ETH
2303         updatingLiquidity = true;
2304         converter.removeLiquidity(_poolAmount, reserveTokens, minReturns);
2305         updatingLiquidity = false;
2306     }
2307 
2308     /**
2309      * @dev returns a protected liquidity from the store
2310      *
2311      * @param _id  protected liquidity id
2312      * @return protected liquidity
2313      */
2314     function protectedLiquidity(uint256 _id) internal view returns (ProtectedLiquidity memory) {
2315         ProtectedLiquidity memory liquidity;
2316         (
2317             liquidity.provider,
2318             liquidity.poolToken,
2319             liquidity.reserveToken,
2320             liquidity.poolAmount,
2321             liquidity.reserveAmount,
2322             liquidity.reserveRateN,
2323             liquidity.reserveRateD,
2324             liquidity.timestamp
2325         ) = store.protectedLiquidity(_id);
2326 
2327         return liquidity;
2328     }
2329 
2330     /**
2331      * @dev returns a protected liquidity from the store
2332      *
2333      * @param _id          protected liquidity id
2334      * @param _provider    authorized provider
2335      * @return protected liquidity
2336      */
2337     function protectedLiquidity(uint256 _id, address _provider) internal view returns (ProtectedLiquidity memory) {
2338         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
2339         require(liquidity.provider == _provider, "ERR_ACCESS_DENIED");
2340         return liquidity;
2341     }
2342 
2343     /**
2344      * @dev returns the protected amount of reserve tokens plus accumulated fee before compensation
2345      *
2346      * @param _poolToken       pool token
2347      * @param _reserveToken    reserve token
2348      * @param _poolAmount      pool token amount when the liquidity was added
2349      * @param _addRate         rate of 1 reserve token in the other reserve token units when the liquidity was added
2350      * @param _removeRate      rate of 1 reserve token in the other reserve token units when the liquidity is removed
2351      * @return protected amount of reserve tokens plus accumulated fee = sqrt(_removeRate / _addRate) * poolRate * _poolAmount
2352      */
2353     function protectedAmountPlusFee(
2354         IDSToken _poolToken,
2355         IERC20Token _reserveToken,
2356         uint256 _poolAmount,
2357         Fraction memory _addRate,
2358         Fraction memory _removeRate
2359     ) internal view returns (uint256) {
2360         Fraction memory poolRate = poolTokenRate(_poolToken, _reserveToken);
2361         uint256 n = Math.ceilSqrt(_addRate.d.mul(_removeRate.n)).mul(poolRate.n);
2362         uint256 d = Math.floorSqrt(_addRate.n.mul(_removeRate.d)).mul(poolRate.d);
2363 
2364         uint256 x = n * _poolAmount;
2365         if (x / n == _poolAmount) {
2366             return x / d;
2367         }
2368 
2369         (uint256 hi, uint256 lo) = n > _poolAmount ? (n, _poolAmount) : (_poolAmount, n);
2370         (uint256 p, uint256 q) = Math.reducedRatio(hi, d, uint256(-1) / lo);
2371         return (p * lo) / q;
2372     }
2373 
2374     /**
2375      * @dev returns the impermanent loss incurred due to the change in rates between the reserve tokens
2376      *
2377      * @param _prevRate    previous rate between the reserves
2378      * @param _newRate     new rate between the reserves
2379      * @return impermanent loss (as a ratio)
2380      */
2381     function impLoss(Fraction memory _prevRate, Fraction memory _newRate) internal pure returns (Fraction memory) {
2382         uint256 ratioN = _newRate.n.mul(_prevRate.d);
2383         uint256 ratioD = _newRate.d.mul(_prevRate.n);
2384 
2385         uint256 prod = ratioN * ratioD;
2386         uint256 root = prod / ratioN == ratioD ? Math.floorSqrt(prod) : Math.floorSqrt(ratioN) * Math.floorSqrt(ratioD);
2387         uint256 sum = ratioN.add(ratioD);
2388         return Fraction({ n: sum.sub(root.mul(2)), d: sum });
2389     }
2390 
2391     /**
2392      * @dev returns the protection level based on the timestamp and protection delays
2393      *
2394      * @param _addTimestamp    time at which the liquidity was added
2395      * @param _removeTimestamp time at which the liquidity is removed
2396      * @return protection level (as a ratio)
2397      */
2398     function protectionLevel(uint256 _addTimestamp, uint256 _removeTimestamp) internal view returns (Fraction memory) {
2399         uint256 timeElapsed = _removeTimestamp.sub(_addTimestamp);
2400         if (timeElapsed < minProtectionDelay) {
2401             return Fraction({ n: 0, d: 1 });
2402         }
2403 
2404         if (timeElapsed >= maxProtectionDelay) {
2405             return Fraction({ n: 1, d: 1 });
2406         }
2407 
2408         return Fraction({ n: timeElapsed, d: maxProtectionDelay });
2409     }
2410 
2411     /**
2412      * @dev returns the compensation amount based on the impermanent loss and the protection level
2413      *
2414      * @param _amount  protected amount in units of the reserve token
2415      * @param _total   amount plus fee in units of the reserve token
2416      * @param _loss    protection level (as a ratio between 0 and 1)
2417      * @param _level   impermanent loss (as a ratio between 0 and 1)
2418      * @return compensation amount
2419      */
2420     function compensationAmount(
2421         uint256 _amount,
2422         uint256 _total,
2423         Fraction memory _loss,
2424         Fraction memory _level
2425     ) internal pure returns (uint256) {
2426         (uint256 lossN, uint256 lossD) = Math.reducedRatio(_loss.n, _loss.d, MAX_UINT128);
2427         return _total.mul(lossD.sub(lossN)).div(lossD).add(_amount.mul(lossN.mul(_level.n)).div(lossD.mul(_level.d)));
2428     }
2429 
2430     function getNetworkCompensation(
2431         uint256 _targetAmount,
2432         uint256 _baseAmount,
2433         PackedRates memory _packedRates
2434     ) internal view returns (uint256) {
2435         if (_targetAmount <= _baseAmount) {
2436             return 0;
2437         }
2438 
2439         // calculate the delta in network tokens
2440         uint256 delta = (_targetAmount - _baseAmount).mul(_packedRates.removeAverageRateN).div(
2441             _packedRates.removeAverageRateD
2442         );
2443 
2444         // the delta might be very small due to precision loss
2445         // in which case no compensation will take place (gas optimization)
2446         if (delta >= _minNetworkCompensation()) {
2447             return delta;
2448         }
2449 
2450         return 0;
2451     }
2452 
2453     /**
2454      * @dev transfers the ownership of a contract
2455      * can only be called by the contract owner
2456      *
2457      * @param _owned       the owned contract
2458      * @param _newOwner    the new owner of the contract
2459      */
2460     function transferOwnership(IOwned _owned, address _newOwner) internal ownerOnly {
2461         _owned.transferOwnership(_newOwner);
2462     }
2463 
2464     /**
2465      * @dev accepts the ownership of a contract
2466      * can only be called by the contract owner
2467      */
2468     function acceptOwnership(IOwned _owned) internal ownerOnly {
2469         _owned.acceptOwnership();
2470     }
2471 
2472     /**
2473      * @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
2474      * note that we use the non standard erc-20 interface in which `approve` has no return value so that
2475      * this function will work for both standard and non standard tokens
2476      *
2477      * @param _token   token to check the allowance in
2478      * @param _spender approved address
2479      * @param _value   allowance amount
2480      */
2481     function ensureAllowance(
2482         IERC20Token _token,
2483         address _spender,
2484         uint256 _value
2485     ) private {
2486         uint256 allowance = _token.allowance(address(this), _spender);
2487         if (allowance < _value) {
2488             if (allowance > 0) safeApprove(_token, _spender, 0);
2489             safeApprove(_token, _spender, _value);
2490         }
2491     }
2492 
2493     // utility to get the reserve balances
2494     function converterReserveBalances(
2495         IConverter _converter,
2496         IERC20Token _reserveToken1,
2497         IERC20Token _reserveToken2
2498     ) private view returns (uint256, uint256) {
2499         return (_converter.getConnectorBalance(_reserveToken1), _converter.getConnectorBalance(_reserveToken2));
2500     }
2501 
2502     // utility to get the reserve weight (including from older converters that don't support the new converterReserveWeight function)
2503     function converterReserveWeight(IConverter _converter, IERC20Token _reserveToken) private view returns (uint32) {
2504         (, uint32 weight, , , ) = _converter.connectors(_reserveToken);
2505         return weight;
2506     }
2507 
2508     /**
2509      * @dev returns minimum network tokens compensation
2510      * utility to allow overrides for tests
2511      */
2512     function _minNetworkCompensation() internal view virtual returns (uint256) {
2513         return minNetworkCompensation;
2514     }
2515 
2516     /**
2517      * @dev returns the current time
2518      * utility to allow overrides for tests
2519      */
2520     function time() internal view virtual returns (uint256) {
2521         return block.timestamp;
2522     }
2523 }
