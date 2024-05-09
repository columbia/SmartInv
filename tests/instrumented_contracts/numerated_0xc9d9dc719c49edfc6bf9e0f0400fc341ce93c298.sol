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
135 // File: solidity/contracts/utility/interfaces/ICheckpointStore.sol
136 
137 
138 pragma solidity 0.6.12;
139 
140 /**
141  * @dev Checkpoint store contract interface
142  */
143 interface ICheckpointStore {
144     function addCheckpoint(address _address) external;
145 
146     function addPastCheckpoint(address _address, uint256 _time) external;
147 
148     function addPastCheckpoints(address[] calldata _addresses, uint256[] calldata _times) external;
149 
150     function checkpoint(address _address) external view returns (uint256);
151 }
152 
153 // File: solidity/contracts/utility/ReentrancyGuard.sol
154 
155 
156 pragma solidity 0.6.12;
157 
158 /**
159  * @dev This contract provides protection against calling a function
160  * (directly or indirectly) from within itself.
161  */
162 contract ReentrancyGuard {
163     uint256 private constant UNLOCKED = 1;
164     uint256 private constant LOCKED = 2;
165 
166     // LOCKED while protected code is being executed, UNLOCKED otherwise
167     uint256 private state = UNLOCKED;
168 
169     /**
170      * @dev ensures instantiation only by sub-contracts
171      */
172     constructor() internal {}
173 
174     // protects a function against reentrancy attacks
175     modifier protected() {
176         _protected();
177         state = LOCKED;
178         _;
179         state = UNLOCKED;
180     }
181 
182     // error message binary size optimization
183     function _protected() internal view {
184         require(state == UNLOCKED, "ERR_REENTRANCY");
185     }
186 }
187 
188 // File: solidity/contracts/utility/interfaces/IOwned.sol
189 
190 
191 pragma solidity 0.6.12;
192 
193 /*
194     Owned contract interface
195 */
196 interface IOwned {
197     // this function isn't since the compiler emits automatically generated getter functions as external
198     function owner() external view returns (address);
199 
200     function transferOwnership(address _newOwner) external;
201 
202     function acceptOwnership() external;
203 }
204 
205 // File: solidity/contracts/utility/Owned.sol
206 
207 
208 pragma solidity 0.6.12;
209 
210 
211 /**
212  * @dev This contract provides support and utilities for contract ownership.
213  */
214 contract Owned is IOwned {
215     address public override owner;
216     address public newOwner;
217 
218     /**
219      * @dev triggered when the owner is updated
220      *
221      * @param _prevOwner previous owner
222      * @param _newOwner  new owner
223      */
224     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
225 
226     /**
227      * @dev initializes a new Owned instance
228      */
229     constructor() public {
230         owner = msg.sender;
231     }
232 
233     // allows execution by the owner only
234     modifier ownerOnly {
235         _ownerOnly();
236         _;
237     }
238 
239     // error message binary size optimization
240     function _ownerOnly() internal view {
241         require(msg.sender == owner, "ERR_ACCESS_DENIED");
242     }
243 
244     /**
245      * @dev allows transferring the contract ownership
246      * the new owner still needs to accept the transfer
247      * can only be called by the contract owner
248      *
249      * @param _newOwner    new contract owner
250      */
251     function transferOwnership(address _newOwner) public override ownerOnly {
252         require(_newOwner != owner, "ERR_SAME_OWNER");
253         newOwner = _newOwner;
254     }
255 
256     /**
257      * @dev used by a new owner to accept an ownership transfer
258      */
259     function acceptOwnership() public override {
260         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
261         emit OwnerUpdate(owner, newOwner);
262         owner = newOwner;
263         newOwner = address(0);
264     }
265 }
266 
267 // File: solidity/contracts/utility/SafeMath.sol
268 
269 
270 pragma solidity 0.6.12;
271 
272 /**
273  * @dev This library supports basic math operations with overflow/underflow protection.
274  */
275 library SafeMath {
276     /**
277      * @dev returns the sum of _x and _y, reverts if the calculation overflows
278      *
279      * @param _x   value 1
280      * @param _y   value 2
281      *
282      * @return sum
283      */
284     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
285         uint256 z = _x + _y;
286         require(z >= _x, "ERR_OVERFLOW");
287         return z;
288     }
289 
290     /**
291      * @dev returns the difference of _x minus _y, reverts if the calculation underflows
292      *
293      * @param _x   minuend
294      * @param _y   subtrahend
295      *
296      * @return difference
297      */
298     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
299         require(_x >= _y, "ERR_UNDERFLOW");
300         return _x - _y;
301     }
302 
303     /**
304      * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
305      *
306      * @param _x   factor 1
307      * @param _y   factor 2
308      *
309      * @return product
310      */
311     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
312         // gas optimization
313         if (_x == 0) return 0;
314 
315         uint256 z = _x * _y;
316         require(z / _x == _y, "ERR_OVERFLOW");
317         return z;
318     }
319 
320     /**
321      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
322      *
323      * @param _x   dividend
324      * @param _y   divisor
325      *
326      * @return quotient
327      */
328     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
329         require(_y > 0, "ERR_DIVIDE_BY_ZERO");
330         uint256 c = _x / _y;
331         return c;
332     }
333 }
334 
335 // File: solidity/contracts/utility/Math.sol
336 
337 
338 pragma solidity 0.6.12;
339 
340 /**
341  * @dev This library provides a set of complex math operations.
342  */
343 library Math {
344     /**
345      * @dev returns the largest integer smaller than or equal to the square root of a positive integer
346      *
347      * @param _num a positive integer
348      *
349      * @return the largest integer smaller than or equal to the square root of the positive integer
350      */
351     function floorSqrt(uint256 _num) internal pure returns (uint256) {
352         uint256 x = _num / 2 + 1;
353         uint256 y = (x + _num / x) / 2;
354         while (x > y) {
355             x = y;
356             y = (x + _num / x) / 2;
357         }
358         return x;
359     }
360 
361     /**
362      * @dev returns the smallest integer larger than or equal to the square root of a positive integer
363      *
364      * @param _num a positive integer
365      *
366      * @return the smallest integer larger than or equal to the square root of the positive integer
367      */
368     function ceilSqrt(uint256 _num) internal pure returns (uint256) {
369         uint256 x = floorSqrt(_num);
370         return x * x == _num ? x : x + 1;
371     }
372 
373     /**
374      * @dev computes a reduced-scalar ratio
375      *
376      * @param _n   ratio numerator
377      * @param _d   ratio denominator
378      * @param _max maximum desired scalar
379      *
380      * @return ratio's numerator and denominator
381      */
382     function reducedRatio(
383         uint256 _n,
384         uint256 _d,
385         uint256 _max
386     ) internal pure returns (uint256, uint256) {
387         (uint256 n, uint256 d) = (_n, _d);
388         if (n > _max || d > _max) {
389             (n, d) = normalizedRatio(n, d, _max);
390         }
391         if (n != d) {
392             return (n, d);
393         }
394         return (1, 1);
395     }
396 
397     /**
398      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)".
399      */
400     function normalizedRatio(
401         uint256 _a,
402         uint256 _b,
403         uint256 _scale
404     ) internal pure returns (uint256, uint256) {
405         if (_a <= _b) {
406             return accurateRatio(_a, _b, _scale);
407         }
408         (uint256 y, uint256 x) = accurateRatio(_b, _a, _scale);
409         return (x, y);
410     }
411 
412     /**
413      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)", assuming that "a <= b".
414      */
415     function accurateRatio(
416         uint256 _a,
417         uint256 _b,
418         uint256 _scale
419     ) internal pure returns (uint256, uint256) {
420         uint256 maxVal = uint256(-1) / _scale;
421         if (_a > maxVal) {
422             uint256 c = _a / (maxVal + 1) + 1;
423             _a /= c; // we can now safely compute `_a * _scale`
424             _b /= c;
425         }
426         if (_a != _b) {
427             uint256 n = _a * _scale;
428             uint256 d = _a + _b; // can overflow
429             if (d >= _a) { // no overflow in `_a + _b`
430                 uint256 x = roundDiv(n, d); // we can now safely compute `_scale - x`
431                 uint256 y = _scale - x;
432                 return (x, y);
433             }
434             if (n < _b - (_b - _a) / 2) {
435                 return (0, _scale); // `_a * _scale < (_a + _b) / 2 < MAX_UINT256 < _a + _b`
436             }
437             return (1, _scale - 1); // `(_a + _b) / 2 < _a * _scale < MAX_UINT256 < _a + _b`
438         }
439         return (_scale / 2, _scale / 2); // allow reduction to `(1, 1)` in the calling function
440     }
441 
442     /**
443      * @dev computes the nearest integer to a given quotient without overflowing or underflowing.
444      */
445     function roundDiv(uint256 _n, uint256 _d) internal pure returns (uint256) {
446         return _n / _d + (_n % _d) / (_d - _d / 2);
447     }
448 
449     /**
450      * @dev returns the average number of decimal digits in a given list of positive integers
451      *
452      * @param _values  list of positive integers
453      *
454      * @return the average number of decimal digits in the given list of positive integers
455      */
456     function geometricMean(uint256[] memory _values) internal pure returns (uint256) {
457         uint256 numOfDigits = 0;
458         uint256 length = _values.length;
459         for (uint256 i = 0; i < length; i++) {
460             numOfDigits += decimalLength(_values[i]);
461         }
462         return uint256(10)**(roundDivUnsafe(numOfDigits, length) - 1);
463     }
464 
465     /**
466      * @dev returns the number of decimal digits in a given positive integer
467      *
468      * @param _x   positive integer
469      *
470      * @return the number of decimal digits in the given positive integer
471      */
472     function decimalLength(uint256 _x) internal pure returns (uint256) {
473         uint256 y = 0;
474         for (uint256 x = _x; x > 0; x /= 10) {
475             y++;
476         }
477         return y;
478     }
479 
480     /**
481      * @dev returns the nearest integer to a given quotient
482      * the computation is overflow-safe assuming that the input is sufficiently small
483      *
484      * @param _n   quotient numerator
485      * @param _d   quotient denominator
486      *
487      * @return the nearest integer to the given quotient
488      */
489     function roundDivUnsafe(uint256 _n, uint256 _d) internal pure returns (uint256) {
490         return (_n + _d / 2) / _d;
491     }
492 
493     /**
494      * @dev returns the larger of two values
495      *
496      * @param _val1 the first value
497      * @param _val2 the second value
498      */
499     function max(uint256 _val1, uint256 _val2) internal pure returns (uint256) {
500         return _val1 > _val2 ? _val1 : _val2;
501     }
502 }
503 
504 // File: solidity/contracts/token/interfaces/IERC20Token.sol
505 
506 
507 pragma solidity 0.6.12;
508 
509 /*
510     ERC20 Standard Token interface
511 */
512 interface IERC20Token {
513     function name() external view returns (string memory);
514 
515     function symbol() external view returns (string memory);
516 
517     function decimals() external view returns (uint8);
518 
519     function totalSupply() external view returns (uint256);
520 
521     function balanceOf(address _owner) external view returns (uint256);
522 
523     function allowance(address _owner, address _spender) external view returns (uint256);
524 
525     function transfer(address _to, uint256 _value) external returns (bool);
526 
527     function transferFrom(
528         address _from,
529         address _to,
530         uint256 _value
531     ) external returns (bool);
532 
533     function approve(address _spender, uint256 _value) external returns (bool);
534 }
535 
536 // File: solidity/contracts/utility/TokenHandler.sol
537 
538 
539 pragma solidity 0.6.12;
540 
541 
542 contract TokenHandler {
543     bytes4 private constant APPROVE_FUNC_SELECTOR = bytes4(keccak256("approve(address,uint256)"));
544     bytes4 private constant TRANSFER_FUNC_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
545     bytes4 private constant TRANSFER_FROM_FUNC_SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));
546 
547     /**
548      * @dev executes the ERC20 token's `approve` function and reverts upon failure
549      * the main purpose of this function is to prevent a non standard ERC20 token
550      * from failing silently
551      *
552      * @param _token   ERC20 token address
553      * @param _spender approved address
554      * @param _value   allowance amount
555      */
556     function safeApprove(
557         IERC20Token _token,
558         address _spender,
559         uint256 _value
560     ) internal {
561         (bool success, bytes memory data) = address(_token).call(
562             abi.encodeWithSelector(APPROVE_FUNC_SELECTOR, _spender, _value)
563         );
564         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_APPROVE_FAILED");
565     }
566 
567     /**
568      * @dev executes the ERC20 token's `transfer` function and reverts upon failure
569      * the main purpose of this function is to prevent a non standard ERC20 token
570      * from failing silently
571      *
572      * @param _token   ERC20 token address
573      * @param _to      target address
574      * @param _value   transfer amount
575      */
576     function safeTransfer(
577         IERC20Token _token,
578         address _to,
579         uint256 _value
580     ) internal {
581         (bool success, bytes memory data) = address(_token).call(
582             abi.encodeWithSelector(TRANSFER_FUNC_SELECTOR, _to, _value)
583         );
584         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_TRANSFER_FAILED");
585     }
586 
587     /**
588      * @dev executes the ERC20 token's `transferFrom` function and reverts upon failure
589      * the main purpose of this function is to prevent a non standard ERC20 token
590      * from failing silently
591      *
592      * @param _token   ERC20 token address
593      * @param _from    source address
594      * @param _to      target address
595      * @param _value   transfer amount
596      */
597     function safeTransferFrom(
598         IERC20Token _token,
599         address _from,
600         address _to,
601         uint256 _value
602     ) internal {
603         (bool success, bytes memory data) = address(_token).call(
604             abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value)
605         );
606         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_TRANSFER_FROM_FAILED");
607     }
608 }
609 
610 // File: solidity/contracts/utility/Types.sol
611 
612 
613 pragma solidity 0.6.12;
614 
615 /**
616  * @dev This contract provides types which can be used by various contracts.
617  */
618 
619 struct Fraction {
620     uint256 n; // numerator
621     uint256 d; // denominator
622 }
623 
624 // File: solidity/contracts/utility/Time.sol
625 
626 
627 pragma solidity 0.6.12;
628 
629 /*
630     Time implementing contract
631 */
632 contract Time {
633     /**
634      * @dev returns the current time
635      */
636     function time() internal view virtual returns (uint256) {
637         return block.timestamp;
638     }
639 }
640 
641 // File: solidity/contracts/utility/Utils.sol
642 
643 
644 pragma solidity 0.6.12;
645 
646 /**
647  * @dev Utilities & Common Modifiers
648  */
649 contract Utils {
650     // verifies that a value is greater than zero
651     modifier greaterThanZero(uint256 _value) {
652         _greaterThanZero(_value);
653         _;
654     }
655 
656     // error message binary size optimization
657     function _greaterThanZero(uint256 _value) internal pure {
658         require(_value > 0, "ERR_ZERO_VALUE");
659     }
660 
661     // validates an address - currently only checks that it isn't null
662     modifier validAddress(address _address) {
663         _validAddress(_address);
664         _;
665     }
666 
667     // error message binary size optimization
668     function _validAddress(address _address) internal pure {
669         require(_address != address(0), "ERR_INVALID_ADDRESS");
670     }
671 
672     // verifies that the address is different than this contract address
673     modifier notThis(address _address) {
674         _notThis(_address);
675         _;
676     }
677 
678     // error message binary size optimization
679     function _notThis(address _address) internal view {
680         require(_address != address(this), "ERR_ADDRESS_IS_SELF");
681     }
682 }
683 
684 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
685 
686 
687 pragma solidity 0.6.12;
688 
689 
690 /*
691     Converter Anchor interface
692 */
693 interface IConverterAnchor is IOwned {
694 
695 }
696 
697 // File: solidity/contracts/token/interfaces/IDSToken.sol
698 
699 
700 pragma solidity 0.6.12;
701 
702 
703 
704 
705 /*
706     DSToken interface
707 */
708 interface IDSToken is IConverterAnchor, IERC20Token {
709     function issue(address _to, uint256 _amount) external;
710 
711     function destroy(address _from, uint256 _amount) external;
712 }
713 
714 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionStore.sol
715 
716 
717 pragma solidity 0.6.12;
718 
719 
720 
721 
722 
723 /*
724     Liquidity Protection Store interface
725 */
726 interface ILiquidityProtectionStore is IOwned {
727     function withdrawTokens(
728         IERC20Token _token,
729         address _to,
730         uint256 _amount
731     ) external;
732 
733     function protectedLiquidity(uint256 _id)
734         external
735         view
736         returns (
737             address,
738             IDSToken,
739             IERC20Token,
740             uint256,
741             uint256,
742             uint256,
743             uint256,
744             uint256
745         );
746 
747     function addProtectedLiquidity(
748         address _provider,
749         IDSToken _poolToken,
750         IERC20Token _reserveToken,
751         uint256 _poolAmount,
752         uint256 _reserveAmount,
753         uint256 _reserveRateN,
754         uint256 _reserveRateD,
755         uint256 _timestamp
756     ) external returns (uint256);
757 
758     function updateProtectedLiquidityAmounts(
759         uint256 _id,
760         uint256 _poolNewAmount,
761         uint256 _reserveNewAmount
762     ) external;
763 
764     function removeProtectedLiquidity(uint256 _id) external;
765 
766     function lockedBalance(address _provider, uint256 _index) external view returns (uint256, uint256);
767 
768     function lockedBalanceRange(
769         address _provider,
770         uint256 _startIndex,
771         uint256 _endIndex
772     ) external view returns (uint256[] memory, uint256[] memory);
773 
774     function addLockedBalance(
775         address _provider,
776         uint256 _reserveAmount,
777         uint256 _expirationTime
778     ) external returns (uint256);
779 
780     function removeLockedBalance(address _provider, uint256 _index) external;
781 
782     function systemBalance(IERC20Token _poolToken) external view returns (uint256);
783 
784     function incSystemBalance(IERC20Token _poolToken, uint256 _poolAmount) external;
785 
786     function decSystemBalance(IERC20Token _poolToken, uint256 _poolAmount) external;
787 }
788 
789 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionSettings.sol
790 
791 
792 pragma solidity 0.6.12;
793 
794 
795 /*
796     Liquidity Protection Store Settings interface
797 */
798 interface ILiquidityProtectionSettings {
799     function addPoolToWhitelist(IConverterAnchor _poolAnchor) external;
800 
801     function removePoolFromWhitelist(IConverterAnchor _poolAnchor) external;
802 
803     function isPoolWhitelisted(IConverterAnchor _poolAnchor) external view returns (bool);
804 
805     function isPoolSupported(IConverterAnchor _poolAnchor) external view returns (bool);
806 
807     function minNetworkTokenLiquidityForMinting() external view returns (uint256);
808 
809     function defaultNetworkTokenMintingLimit() external view returns (uint256);
810 
811     function networkTokenMintingLimits(IConverterAnchor _poolAnchor) external view returns (uint256);
812 
813     function networkTokensMinted(IConverterAnchor _poolAnchor) external view returns (uint256);
814 
815     function incNetworkTokensMinted(IConverterAnchor _poolAnchor, uint256 _amount) external;
816 
817     function decNetworkTokensMinted(IConverterAnchor _poolAnchor, uint256 _amount) external;
818 
819     function minProtectionDelay() external view returns (uint256);
820 
821     function maxProtectionDelay() external view returns (uint256);
822 
823     function setProtectionDelays(uint256 _minProtectionDelay, uint256 _maxProtectionDelay) external;
824 
825     function minNetworkCompensation() external view returns (uint256);
826 
827     function setMinNetworkCompensation(uint256 _minCompensation) external;
828 
829     function lockDuration() external view returns (uint256);
830 
831     function setLockDuration(uint256 _lockDuration) external;
832 
833     function averageRateMaxDeviation() external view returns (uint32);
834 
835     function setAverageRateMaxDeviation(uint32 _averageRateMaxDeviation) external;
836 }
837 
838 // File: solidity/contracts/converter/interfaces/IConverter.sol
839 
840 
841 pragma solidity 0.6.12;
842 
843 
844 
845 
846 /*
847     Converter interface
848 */
849 interface IConverter is IOwned {
850     function converterType() external pure returns (uint16);
851 
852     function anchor() external view returns (IConverterAnchor);
853 
854     function isActive() external view returns (bool);
855 
856     function targetAmountAndFee(
857         IERC20Token _sourceToken,
858         IERC20Token _targetToken,
859         uint256 _amount
860     ) external view returns (uint256, uint256);
861 
862     function convert(
863         IERC20Token _sourceToken,
864         IERC20Token _targetToken,
865         uint256 _amount,
866         address _trader,
867         address payable _beneficiary
868     ) external payable returns (uint256);
869 
870     function conversionFee() external view returns (uint32);
871 
872     function maxConversionFee() external view returns (uint32);
873 
874     function reserveBalance(IERC20Token _reserveToken) external view returns (uint256);
875 
876     receive() external payable;
877 
878     function transferAnchorOwnership(address _newOwner) external;
879 
880     function acceptAnchorOwnership() external;
881 
882     function setConversionFee(uint32 _conversionFee) external;
883 
884     function withdrawTokens(
885         IERC20Token _token,
886         address _to,
887         uint256 _amount
888     ) external;
889 
890     function withdrawETH(address payable _to) external;
891 
892     function addReserve(IERC20Token _token, uint32 _ratio) external;
893 
894     // deprecated, backward compatibility
895     function token() external view returns (IConverterAnchor);
896 
897     function transferTokenOwnership(address _newOwner) external;
898 
899     function acceptTokenOwnership() external;
900 
901     function connectors(IERC20Token _address)
902         external
903         view
904         returns (
905             uint256,
906             uint32,
907             bool,
908             bool,
909             bool
910         );
911 
912     function getConnectorBalance(IERC20Token _connectorToken) external view returns (uint256);
913 
914     function connectorTokens(uint256 _index) external view returns (IERC20Token);
915 
916     function connectorTokenCount() external view returns (uint16);
917 
918     /**
919      * @dev triggered when the converter is activated
920      *
921      * @param _type        converter type
922      * @param _anchor      converter anchor
923      * @param _activated   true if the converter was activated, false if it was deactivated
924      */
925     event Activation(uint16 indexed _type, IConverterAnchor indexed _anchor, bool indexed _activated);
926 
927     /**
928      * @dev triggered when a conversion between two tokens occurs
929      *
930      * @param _fromToken       source ERC20 token
931      * @param _toToken         target ERC20 token
932      * @param _trader          wallet that initiated the trade
933      * @param _amount          input amount in units of the source token
934      * @param _return          output amount minus conversion fee in units of the target token
935      * @param _conversionFee   conversion fee in units of the target token
936      */
937     event Conversion(
938         IERC20Token indexed _fromToken,
939         IERC20Token indexed _toToken,
940         address indexed _trader,
941         uint256 _amount,
942         uint256 _return,
943         int256 _conversionFee
944     );
945 
946     /**
947      * @dev triggered when the rate between two tokens in the converter changes
948      * note that the event might be dispatched for rate updates between any two tokens in the converter
949      *
950      * @param  _token1 address of the first token
951      * @param  _token2 address of the second token
952      * @param  _rateN  rate of 1 unit of `_token1` in `_token2` (numerator)
953      * @param  _rateD  rate of 1 unit of `_token1` in `_token2` (denominator)
954      */
955     event TokenRateUpdate(IERC20Token indexed _token1, IERC20Token indexed _token2, uint256 _rateN, uint256 _rateD);
956 
957     /**
958      * @dev triggered when the conversion fee is updated
959      *
960      * @param  _prevFee    previous fee percentage, represented in ppm
961      * @param  _newFee     new fee percentage, represented in ppm
962      */
963     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
964 }
965 
966 // File: solidity/contracts/converter/interfaces/IConverterRegistry.sol
967 
968 
969 pragma solidity 0.6.12;
970 
971 
972 
973 interface IConverterRegistry {
974     function getAnchorCount() external view returns (uint256);
975 
976     function getAnchors() external view returns (address[] memory);
977 
978     function getAnchor(uint256 _index) external view returns (IConverterAnchor);
979 
980     function isAnchor(address _value) external view returns (bool);
981 
982     function getLiquidityPoolCount() external view returns (uint256);
983 
984     function getLiquidityPools() external view returns (address[] memory);
985 
986     function getLiquidityPool(uint256 _index) external view returns (IConverterAnchor);
987 
988     function isLiquidityPool(address _value) external view returns (bool);
989 
990     function getConvertibleTokenCount() external view returns (uint256);
991 
992     function getConvertibleTokens() external view returns (address[] memory);
993 
994     function getConvertibleToken(uint256 _index) external view returns (IERC20Token);
995 
996     function isConvertibleToken(address _value) external view returns (bool);
997 
998     function getConvertibleTokenAnchorCount(IERC20Token _convertibleToken) external view returns (uint256);
999 
1000     function getConvertibleTokenAnchors(IERC20Token _convertibleToken) external view returns (address[] memory);
1001 
1002     function getConvertibleTokenAnchor(IERC20Token _convertibleToken, uint256 _index)
1003         external
1004         view
1005         returns (IConverterAnchor);
1006 
1007     function isConvertibleTokenAnchor(IERC20Token _convertibleToken, address _value) external view returns (bool);
1008 }
1009 
1010 // File: solidity/contracts/liquidity-protection/LiquidityProtection.sol
1011 
1012 
1013 pragma solidity 0.6.12;
1014 
1015 
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 
1024 
1025 
1026 
1027 
1028 
1029 
1030 
1031 
1032 
1033 interface ILiquidityPoolConverter is IConverter {
1034     function addLiquidity(
1035         IERC20Token[] memory _reserveTokens,
1036         uint256[] memory _reserveAmounts,
1037         uint256 _minReturn
1038     ) external payable;
1039 
1040     function removeLiquidity(
1041         uint256 _amount,
1042         IERC20Token[] memory _reserveTokens,
1043         uint256[] memory _reserveMinReturnAmounts
1044     ) external;
1045 
1046     function recentAverageRate(IERC20Token _reserveToken) external view returns (uint256, uint256);
1047 }
1048 
1049 /**
1050  * @dev This contract implements the liquidity protection mechanism.
1051  */
1052 contract LiquidityProtection is TokenHandler, Utils, Owned, ReentrancyGuard, Time {
1053     using SafeMath for uint256;
1054     using Math for *;
1055 
1056     struct ProtectedLiquidity {
1057         address provider; // liquidity provider
1058         IDSToken poolToken; // pool token address
1059         IERC20Token reserveToken; // reserve token address
1060         uint256 poolAmount; // pool token amount
1061         uint256 reserveAmount; // reserve token amount
1062         uint256 reserveRateN; // rate of 1 protected reserve token in units of the other reserve token (numerator)
1063         uint256 reserveRateD; // rate of 1 protected reserve token in units of the other reserve token (denominator)
1064         uint256 timestamp; // timestamp
1065     }
1066 
1067     // various rates between the two reserve tokens. the rate is of 1 unit of the protected reserve token in units of the other reserve token
1068     struct PackedRates {
1069         uint128 addSpotRateN; // spot rate of 1 A in units of B when liquidity was added (numerator)
1070         uint128 addSpotRateD; // spot rate of 1 A in units of B when liquidity was added (denominator)
1071         uint128 removeSpotRateN; // spot rate of 1 A in units of B when liquidity is removed (numerator)
1072         uint128 removeSpotRateD; // spot rate of 1 A in units of B when liquidity is removed (denominator)
1073         uint128 removeAverageRateN; // average rate of 1 A in units of B when liquidity is removed (numerator)
1074         uint128 removeAverageRateD; // average rate of 1 A in units of B when liquidity is removed (denominator)
1075     }
1076 
1077     IERC20Token internal constant ETH_RESERVE_ADDRESS = IERC20Token(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1078     uint32 internal constant PPM_RESOLUTION = 1000000;
1079     uint256 internal constant MAX_UINT128 = 2**128 - 1;
1080     uint256 internal constant MAX_UINT256 = uint256(-1);
1081 
1082     ILiquidityProtectionSettings public immutable settings;
1083     ILiquidityProtectionStore public immutable store;
1084     IERC20Token public immutable networkToken;
1085     ITokenGovernance public immutable networkTokenGovernance;
1086     IERC20Token public immutable govToken;
1087     ITokenGovernance public immutable govTokenGovernance;
1088     ICheckpointStore public immutable lastRemoveCheckpointStore;
1089 
1090     // true if the contract is currently adding/removing liquidity from a converter, used for accepting ETH
1091     bool private updatingLiquidity = false;
1092 
1093     /**
1094      * @dev initializes a new LiquidityProtection contract
1095      *
1096      * @param _settings liquidity protection settings
1097      * @param _store liquidity protection store
1098      * @param _networkTokenGovernance network token governance
1099      * @param _govTokenGovernance governance token governance
1100      * @param _lastRemoveCheckpointStore last liquidity removal/unprotection checkpoints store
1101      */
1102     constructor(
1103         ILiquidityProtectionSettings _settings,
1104         ILiquidityProtectionStore _store,
1105         ITokenGovernance _networkTokenGovernance,
1106         ITokenGovernance _govTokenGovernance,
1107         ICheckpointStore _lastRemoveCheckpointStore
1108     )
1109         public
1110         validAddress(address(_settings))
1111         validAddress(address(_store))
1112         validAddress(address(_networkTokenGovernance))
1113         validAddress(address(_govTokenGovernance))
1114         notThis(address(_settings))
1115         notThis(address(_store))
1116         notThis(address(_networkTokenGovernance))
1117         notThis(address(_govTokenGovernance))
1118     {
1119         settings = _settings;
1120         store = _store;
1121 
1122         networkTokenGovernance = _networkTokenGovernance;
1123         networkToken = IERC20Token(address(_networkTokenGovernance.token()));
1124         govTokenGovernance = _govTokenGovernance;
1125         govToken = IERC20Token(address(_govTokenGovernance.token()));
1126 
1127         lastRemoveCheckpointStore = _lastRemoveCheckpointStore;
1128     }
1129 
1130     // ensures that the contract is currently removing liquidity from a converter
1131     modifier updatingLiquidityOnly() {
1132         _updatingLiquidityOnly();
1133         _;
1134     }
1135 
1136     // error message binary size optimization
1137     function _updatingLiquidityOnly() internal view {
1138         require(updatingLiquidity, "ERR_NOT_UPDATING_LIQUIDITY");
1139     }
1140 
1141     // ensures that the portion is valid
1142     modifier validPortion(uint32 _portion) {
1143         _validPortion(_portion);
1144         _;
1145     }
1146 
1147     // error message binary size optimization
1148     function _validPortion(uint32 _portion) internal pure {
1149         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PORTION");
1150     }
1151 
1152     // ensures that the pool is supported
1153     modifier poolSupported(IConverterAnchor _poolAnchor) {
1154         _poolSupported(_poolAnchor);
1155         _;
1156     }
1157 
1158     // error message binary size optimization
1159     function _poolSupported(IConverterAnchor _poolAnchor) internal view {
1160         require(settings.isPoolSupported(_poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1161     }
1162 
1163     // ensures that the pool is whitelisted
1164     modifier poolWhitelisted(IConverterAnchor _poolAnchor) {
1165         _poolWhitelisted(_poolAnchor);
1166         _;
1167     }
1168 
1169     // error message binary size optimization
1170     function _poolWhitelisted(IConverterAnchor _poolAnchor) internal view {
1171         require(settings.isPoolWhitelisted(_poolAnchor), "ERR_POOL_NOT_WHITELISTED");
1172     }
1173 
1174     /**
1175      * @dev accept ETH
1176      * used when removing liquidity from ETH converters
1177      */
1178     receive() external payable updatingLiquidityOnly() {}
1179 
1180     /**
1181      * @dev transfers the ownership of the store
1182      * can only be called by the contract owner
1183      *
1184      * @param _newOwner    the new owner of the store
1185      */
1186     function transferStoreOwnership(address _newOwner) external ownerOnly {
1187         store.transferOwnership(_newOwner);
1188     }
1189 
1190     /**
1191      * @dev accepts the ownership of the store
1192      * can only be called by the contract owner
1193      */
1194     function acceptStoreOwnership() external ownerOnly {
1195         store.acceptOwnership();
1196     }
1197 
1198     /**
1199      * @dev adds protected liquidity to a pool for a specific recipient
1200      * also mints new governance tokens for the caller if the caller adds network tokens
1201      *
1202      * @param _owner       protected liquidity owner
1203      * @param _poolAnchor      anchor of the pool
1204      * @param _reserveToken    reserve token to add to the pool
1205      * @param _amount          amount of tokens to add to the pool
1206      * @return new protected liquidity id
1207      */
1208     function addLiquidityFor(
1209         address _owner,
1210         IConverterAnchor _poolAnchor,
1211         IERC20Token _reserveToken,
1212         uint256 _amount
1213     )
1214         external
1215         payable
1216         protected
1217         validAddress(_owner)
1218         poolSupported(_poolAnchor)
1219         poolWhitelisted(_poolAnchor)
1220         greaterThanZero(_amount)
1221         returns (uint256)
1222     {
1223         return addLiquidity(_owner, _poolAnchor, _reserveToken, _amount);
1224     }
1225 
1226     /**
1227      * @dev adds protected liquidity to a pool
1228      * also mints new governance tokens for the caller if the caller adds network tokens
1229      *
1230      * @param _poolAnchor      anchor of the pool
1231      * @param _reserveToken    reserve token to add to the pool
1232      * @param _amount          amount of tokens to add to the pool
1233      * @return new protected liquidity id
1234      */
1235     function addLiquidity(
1236         IConverterAnchor _poolAnchor,
1237         IERC20Token _reserveToken,
1238         uint256 _amount
1239     )
1240         external
1241         payable
1242         protected
1243         poolSupported(_poolAnchor)
1244         poolWhitelisted(_poolAnchor)
1245         greaterThanZero(_amount)
1246         returns (uint256)
1247     {
1248         return addLiquidity(msg.sender, _poolAnchor, _reserveToken, _amount);
1249     }
1250 
1251     /**
1252      * @dev adds protected liquidity to a pool for a specific recipient
1253      * also mints new governance tokens for the caller if the caller adds network tokens
1254      *
1255      * @param _owner       protected liquidity owner
1256      * @param _poolAnchor      anchor of the pool
1257      * @param _reserveToken    reserve token to add to the pool
1258      * @param _amount          amount of tokens to add to the pool
1259      * @return new protected liquidity id
1260      */
1261     function addLiquidity(
1262         address _owner,
1263         IConverterAnchor _poolAnchor,
1264         IERC20Token _reserveToken,
1265         uint256 _amount
1266     ) private returns (uint256) {
1267         // save a local copy of `networkToken`
1268         IERC20Token networkTokenLocal = networkToken;
1269 
1270         if (_reserveToken == networkTokenLocal) {
1271             require(msg.value == 0, "ERR_ETH_AMOUNT_MISMATCH");
1272             return addNetworkTokenLiquidity(_owner, _poolAnchor, networkTokenLocal, _amount);
1273         }
1274 
1275         // verify that ETH was passed with the call if needed
1276         uint256 val = _reserveToken == ETH_RESERVE_ADDRESS ? _amount : 0;
1277         require(msg.value == val, "ERR_ETH_AMOUNT_MISMATCH");
1278         return addBaseTokenLiquidity(_owner, _poolAnchor, _reserveToken, networkTokenLocal, _amount);
1279     }
1280 
1281     /**
1282      * @dev adds protected network token liquidity to a pool
1283      * also mints new governance tokens for the caller
1284      *
1285      * @param _owner    protected liquidity owner
1286      * @param _poolAnchor   anchor of the pool
1287      * @param _networkToken the network reserve token of the pool
1288      * @param _amount       amount of tokens to add to the pool
1289      * @return new protected liquidity id
1290      */
1291     function addNetworkTokenLiquidity(
1292         address _owner,
1293         IConverterAnchor _poolAnchor,
1294         IERC20Token _networkToken,
1295         uint256 _amount
1296     ) internal returns (uint256) {
1297         IDSToken poolToken = IDSToken(address(_poolAnchor));
1298 
1299         // get the rate between the pool token and the reserve
1300         Fraction memory poolRate = poolTokenRate(poolToken, _networkToken);
1301 
1302         // calculate the amount of pool tokens based on the amount of reserve tokens
1303         uint256 poolTokenAmount = _amount.mul(poolRate.d).div(poolRate.n);
1304 
1305         // remove the pool tokens from the system's ownership (will revert if not enough tokens are available)
1306         store.decSystemBalance(poolToken, poolTokenAmount);
1307 
1308         // add protected liquidity for the recipient
1309         uint256 id = addProtectedLiquidity(_owner, poolToken, _networkToken, poolTokenAmount, _amount);
1310 
1311         // burns the network tokens from the caller. we need to transfer the tokens to the contract itself, since only
1312         // token holders can burn their tokens
1313         safeTransferFrom(_networkToken, msg.sender, address(this), _amount);
1314         networkTokenGovernance.burn(_amount);
1315         settings.decNetworkTokensMinted(_poolAnchor, _amount);
1316 
1317         // mint governance tokens to the recipient
1318         govTokenGovernance.mint(_owner, _amount);
1319 
1320         return id;
1321     }
1322 
1323     /**
1324      * @dev adds protected base token liquidity to a pool
1325      *
1326      * @param _owner    protected liquidity owner
1327      * @param _poolAnchor   anchor of the pool
1328      * @param _baseToken    the base reserve token of the pool
1329      * @param _networkToken the network reserve token of the pool
1330      * @param _amount       amount of tokens to add to the pool
1331      * @return new protected liquidity id
1332      */
1333     function addBaseTokenLiquidity(
1334         address _owner,
1335         IConverterAnchor _poolAnchor,
1336         IERC20Token _baseToken,
1337         IERC20Token _networkToken,
1338         uint256 _amount
1339     ) internal returns (uint256) {
1340         IDSToken poolToken = IDSToken(address(_poolAnchor));
1341 
1342         // get the reserve balances
1343         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolAnchor)));
1344         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
1345             converterReserveBalances(converter, _baseToken, _networkToken);
1346 
1347         require(reserveBalanceNetwork >= settings.minNetworkTokenLiquidityForMinting(), "ERR_NOT_ENOUGH_LIQUIDITY");
1348 
1349         // calculate and mint the required amount of network tokens for adding liquidity
1350         uint256 newNetworkLiquidityAmount = _amount.mul(reserveBalanceNetwork).div(reserveBalanceBase);
1351 
1352         // verify network token minting limit
1353         uint256 mintingLimit = settings.networkTokenMintingLimits(_poolAnchor);
1354         if (mintingLimit == 0) {
1355             mintingLimit = settings.defaultNetworkTokenMintingLimit();
1356         }
1357 
1358         uint256 newNetworkTokensMinted = settings.networkTokensMinted(_poolAnchor).add(newNetworkLiquidityAmount);
1359         require(newNetworkTokensMinted <= mintingLimit, "ERR_MAX_AMOUNT_REACHED");
1360 
1361         // issue new network tokens to the system
1362         networkTokenGovernance.mint(address(this), newNetworkLiquidityAmount);
1363         settings.incNetworkTokensMinted(_poolAnchor, newNetworkLiquidityAmount);
1364 
1365         // transfer the base tokens from the caller and approve the converter
1366         ensureAllowance(_networkToken, address(converter), newNetworkLiquidityAmount);
1367         if (_baseToken != ETH_RESERVE_ADDRESS) {
1368             safeTransferFrom(_baseToken, msg.sender, address(this), _amount);
1369             ensureAllowance(_baseToken, address(converter), _amount);
1370         }
1371 
1372         // add liquidity
1373         addLiquidity(converter, _baseToken, _networkToken, _amount, newNetworkLiquidityAmount, msg.value);
1374 
1375         // transfer the new pool tokens to the store
1376         uint256 poolTokenAmount = poolToken.balanceOf(address(this));
1377         safeTransfer(poolToken, address(store), poolTokenAmount);
1378 
1379         // the system splits the pool tokens with the caller
1380         // increase the system's pool token balance and add protected liquidity for the caller
1381         store.incSystemBalance(poolToken, poolTokenAmount - poolTokenAmount / 2); // account for rounding errors
1382         return addProtectedLiquidity(_owner, poolToken, _baseToken, poolTokenAmount / 2, _amount);
1383     }
1384 
1385     /**
1386      * @dev returns the single-side staking limits of a given pool
1387      *
1388      * @param _poolAnchor   anchor of the pool
1389      * @return maximum amount of base tokens that can be single-side staked in the pool
1390      * @return maximum amount of network tokens that can be single-side staked in the pool
1391      */
1392     function poolAvailableSpace(IConverterAnchor _poolAnchor)
1393         external
1394         view
1395         poolSupported(_poolAnchor)
1396         poolWhitelisted(_poolAnchor)
1397         returns (uint256, uint256)
1398     {
1399         IERC20Token networkTokenLocal = networkToken;
1400         return (
1401             baseTokenAvailableSpace(_poolAnchor, networkTokenLocal),
1402             networkTokenAvailableSpace(_poolAnchor, networkTokenLocal)
1403         );
1404     }
1405 
1406     /**
1407      * @dev returns the base-token staking limits of a given pool
1408      *
1409      * @param _poolAnchor   anchor of the pool
1410      * @return maximum amount of base tokens that can be single-side staked in the pool
1411      */
1412     function baseTokenAvailableSpace(IConverterAnchor _poolAnchor)
1413         external
1414         view
1415         poolSupported(_poolAnchor)
1416         poolWhitelisted(_poolAnchor)
1417         returns (uint256)
1418     {
1419         return baseTokenAvailableSpace(_poolAnchor, networkToken);
1420     }
1421 
1422     /**
1423      * @dev returns the network-token staking limits of a given pool
1424      *
1425      * @param _poolAnchor   anchor of the pool
1426      * @return maximum amount of network tokens that can be single-side staked in the pool
1427      */
1428     function networkTokenAvailableSpace(IConverterAnchor _poolAnchor)
1429         external
1430         view
1431         poolSupported(_poolAnchor)
1432         poolWhitelisted(_poolAnchor)
1433         returns (uint256)
1434     {
1435         return networkTokenAvailableSpace(_poolAnchor, networkToken);
1436     }
1437 
1438     /**
1439      * @dev returns the base-token staking limits of a given pool
1440      *
1441      * @param _poolAnchor   anchor of the pool
1442      * @param _networkToken the network token
1443      * @return maximum amount of base tokens that can be single-side staked in the pool
1444      */
1445     function baseTokenAvailableSpace(IConverterAnchor _poolAnchor, IERC20Token _networkToken)
1446         internal
1447         view
1448         returns (uint256)
1449     {
1450         // get the pool converter
1451         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolAnchor)));
1452 
1453         // get the base token
1454         IERC20Token baseToken = converterOtherReserve(converter, _networkToken);
1455 
1456         // get the reserve balances
1457         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
1458             converterReserveBalances(converter, baseToken, _networkToken);
1459 
1460         // get the network token minting limit
1461         uint256 mintingLimit = settings.networkTokenMintingLimits(_poolAnchor);
1462         if (mintingLimit == 0) {
1463             mintingLimit = settings.defaultNetworkTokenMintingLimit();
1464         }
1465 
1466         // get the amount of network tokens already minted for the pool
1467         uint256 networkTokensMinted = settings.networkTokensMinted(_poolAnchor);
1468 
1469         // get the amount of network tokens which can minted for the pool
1470         uint256 networkTokensCanBeMinted = Math.max(mintingLimit, networkTokensMinted) - networkTokensMinted;
1471 
1472         // return the maximum amount of base token liquidity that can be single-sided staked in the pool
1473         return networkTokensCanBeMinted.mul(reserveBalanceBase).div(reserveBalanceNetwork);
1474     }
1475 
1476     /**
1477      * @dev returns the network-token staking limits of a given pool
1478      *
1479      * @param _poolAnchor   anchor of the pool
1480      * @param _networkToken the network token
1481      * @return maximum amount of network tokens that can be single-side staked in the pool
1482      */
1483     function networkTokenAvailableSpace(IConverterAnchor _poolAnchor, IERC20Token _networkToken)
1484         internal
1485         view
1486         returns (uint256)
1487     {
1488         // get the pool token
1489         IDSToken poolToken = IDSToken(address(_poolAnchor));
1490 
1491         // get the pool token rate
1492         Fraction memory poolRate = poolTokenRate(poolToken, _networkToken);
1493 
1494         // return the maximum amount of network token liquidity that can be single-sided staked in the pool
1495         return store.systemBalance(poolToken).mul(poolRate.n).add(poolRate.n).sub(1).div(poolRate.d);
1496     }
1497 
1498     /**
1499      * @dev returns the expected/actual amounts the provider will receive for removing liquidity
1500      * it's also possible to provide the remove liquidity time to get an estimation
1501      * for the return at that given point
1502      *
1503      * @param _id              protected liquidity id
1504      * @param _portion         portion of liquidity to remove, in PPM
1505      * @param _removeTimestamp time at which the liquidity is removed
1506      * @return expected return amount in the reserve token
1507      * @return actual return amount in the reserve token
1508      * @return compensation in the network token
1509      */
1510     function removeLiquidityReturn(
1511         uint256 _id,
1512         uint32 _portion,
1513         uint256 _removeTimestamp
1514     )
1515         external
1516         view
1517         validPortion(_portion)
1518         returns (
1519             uint256,
1520             uint256,
1521             uint256
1522         )
1523     {
1524         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
1525 
1526         // verify input
1527         require(liquidity.provider != address(0), "ERR_INVALID_ID");
1528         require(_removeTimestamp >= liquidity.timestamp, "ERR_INVALID_TIMESTAMP");
1529 
1530         // calculate the portion of the liquidity to remove
1531         if (_portion != PPM_RESOLUTION) {
1532             liquidity.poolAmount = liquidity.poolAmount.mul(_portion) / PPM_RESOLUTION;
1533             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion) / PPM_RESOLUTION;
1534         }
1535 
1536         // get the various rates between the reserves upon adding liquidity and now
1537         PackedRates memory packedRates =
1538             packRates(
1539                 liquidity.poolToken,
1540                 liquidity.reserveToken,
1541                 liquidity.reserveRateN,
1542                 liquidity.reserveRateD,
1543                 false
1544             );
1545 
1546         uint256 targetAmount =
1547             removeLiquidityTargetAmount(
1548                 liquidity.poolToken,
1549                 liquidity.reserveToken,
1550                 liquidity.poolAmount,
1551                 liquidity.reserveAmount,
1552                 packedRates,
1553                 liquidity.timestamp,
1554                 _removeTimestamp
1555             );
1556 
1557         // for network token, the return amount is identical to the target amount
1558         if (liquidity.reserveToken == networkToken) {
1559             return (targetAmount, targetAmount, 0);
1560         }
1561 
1562         // handle base token return
1563 
1564         // calculate the amount of pool tokens required for liquidation
1565         // note that the amount is doubled since it's not possible to liquidate one reserve only
1566         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1567         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
1568 
1569         // limit the amount of pool tokens by the amount the system/caller holds
1570         uint256 availableBalance = store.systemBalance(liquidity.poolToken).add(liquidity.poolAmount);
1571         poolAmount = poolAmount > availableBalance ? availableBalance : poolAmount;
1572 
1573         // calculate the base token amount received by liquidating the pool tokens
1574         // note that the amount is divided by 2 since the pool amount represents both reserves
1575         uint256 baseAmount = poolAmount.mul(poolRate.n / 2).div(poolRate.d);
1576         uint256 networkAmount = getNetworkCompensation(targetAmount, baseAmount, packedRates);
1577 
1578         return (targetAmount, baseAmount, networkAmount);
1579     }
1580 
1581     /**
1582      * @dev removes protected liquidity from a pool
1583      * also burns governance tokens from the caller if the caller removes network tokens
1584      *
1585      * @param _id      id in the caller's list of protected liquidity
1586      * @param _portion portion of liquidity to remove, in PPM
1587      */
1588     function removeLiquidity(uint256 _id, uint32 _portion) external validPortion(_portion) protected {
1589         ProtectedLiquidity memory liquidity = protectedLiquidity(_id, msg.sender);
1590 
1591         // save a local copy of `networkToken`
1592         IERC20Token networkTokenLocal = networkToken;
1593 
1594         // verify that the pool is whitelisted
1595         _poolWhitelisted(liquidity.poolToken);
1596 
1597         // verify that the protected liquidity is not removed on the same block in which it was added
1598         require(liquidity.timestamp < time(), "ERR_TOO_EARLY");
1599 
1600         if (_portion == PPM_RESOLUTION) {
1601             // remove the protected liquidity from the provider
1602             store.removeProtectedLiquidity(_id);
1603         } else {
1604             // remove a portion of the protected liquidity from the provider
1605             uint256 fullPoolAmount = liquidity.poolAmount;
1606             uint256 fullReserveAmount = liquidity.reserveAmount;
1607             liquidity.poolAmount = liquidity.poolAmount.mul(_portion) / PPM_RESOLUTION;
1608             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion) / PPM_RESOLUTION;
1609 
1610             store.updateProtectedLiquidityAmounts(
1611                 _id,
1612                 fullPoolAmount - liquidity.poolAmount,
1613                 fullReserveAmount - liquidity.reserveAmount
1614             );
1615         }
1616 
1617         // update last liquidity removal checkpoint
1618         lastRemoveCheckpointStore.addCheckpoint(msg.sender);
1619 
1620         // add the pool tokens to the system
1621         store.incSystemBalance(liquidity.poolToken, liquidity.poolAmount);
1622 
1623         // if removing network token liquidity, burn the governance tokens from the caller. we need to transfer the
1624         // tokens to the contract itself, since only token holders can burn their tokens
1625         if (liquidity.reserveToken == networkTokenLocal) {
1626             safeTransferFrom(govToken, msg.sender, address(this), liquidity.reserveAmount);
1627             govTokenGovernance.burn(liquidity.reserveAmount);
1628         }
1629 
1630         // get the various rates between the reserves upon adding liquidity and now
1631         PackedRates memory packedRates =
1632             packRates(
1633                 liquidity.poolToken,
1634                 liquidity.reserveToken,
1635                 liquidity.reserveRateN,
1636                 liquidity.reserveRateD,
1637                 true
1638             );
1639 
1640         // get the target token amount
1641         uint256 targetAmount =
1642             removeLiquidityTargetAmount(
1643                 liquidity.poolToken,
1644                 liquidity.reserveToken,
1645                 liquidity.poolAmount,
1646                 liquidity.reserveAmount,
1647                 packedRates,
1648                 liquidity.timestamp,
1649                 time()
1650             );
1651 
1652         // remove network token liquidity
1653         if (liquidity.reserveToken == networkTokenLocal) {
1654             // mint network tokens for the caller and lock them
1655             networkTokenGovernance.mint(address(store), targetAmount);
1656             settings.incNetworkTokensMinted(liquidity.poolToken, targetAmount);
1657             lockTokens(msg.sender, targetAmount);
1658             return;
1659         }
1660 
1661         // remove base token liquidity
1662 
1663         // calculate the amount of pool tokens required for liquidation
1664         // note that the amount is doubled since it's not possible to liquidate one reserve only
1665         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1666         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
1667 
1668         // limit the amount of pool tokens by the amount the system holds
1669         uint256 systemBalance = store.systemBalance(liquidity.poolToken);
1670         poolAmount = poolAmount > systemBalance ? systemBalance : poolAmount;
1671 
1672         // withdraw the pool tokens from the store
1673         store.decSystemBalance(liquidity.poolToken, poolAmount);
1674         store.withdrawTokens(liquidity.poolToken, address(this), poolAmount);
1675 
1676         // remove liquidity
1677         removeLiquidity(liquidity.poolToken, poolAmount, liquidity.reserveToken, networkTokenLocal);
1678 
1679         // transfer the base tokens to the caller
1680         uint256 baseBalance;
1681         if (liquidity.reserveToken == ETH_RESERVE_ADDRESS) {
1682             baseBalance = address(this).balance;
1683             msg.sender.transfer(baseBalance);
1684         } else {
1685             baseBalance = liquidity.reserveToken.balanceOf(address(this));
1686             safeTransfer(liquidity.reserveToken, msg.sender, baseBalance);
1687         }
1688 
1689         // compensate the caller with network tokens if still needed
1690         uint256 delta = getNetworkCompensation(targetAmount, baseBalance, packedRates);
1691         if (delta > 0) {
1692             // check if there's enough network token balance, otherwise mint more
1693             uint256 networkBalance = networkTokenLocal.balanceOf(address(this));
1694             if (networkBalance < delta) {
1695                 networkTokenGovernance.mint(address(this), delta - networkBalance);
1696             }
1697 
1698             // lock network tokens for the caller
1699             safeTransfer(networkTokenLocal, address(store), delta);
1700             lockTokens(msg.sender, delta);
1701         }
1702 
1703         // if the contract still holds network tokens, burn them
1704         uint256 networkBalance = networkTokenLocal.balanceOf(address(this));
1705         if (networkBalance > 0) {
1706             networkTokenGovernance.burn(networkBalance);
1707             settings.decNetworkTokensMinted(liquidity.poolToken, networkBalance);
1708         }
1709     }
1710 
1711     /**
1712      * @dev returns the amount the provider will receive for removing liquidity
1713      * it's also possible to provide the remove liquidity rate & time to get an estimation
1714      * for the return at that given point
1715      *
1716      * @param _poolToken       pool token
1717      * @param _reserveToken    reserve token
1718      * @param _poolAmount      pool token amount when the liquidity was added
1719      * @param _reserveAmount   reserve token amount that was added
1720      * @param _packedRates     see `struct PackedRates`
1721      * @param _addTimestamp    time at which the liquidity was added
1722      * @param _removeTimestamp time at which the liquidity is removed
1723      * @return amount received for removing liquidity
1724      */
1725     function removeLiquidityTargetAmount(
1726         IDSToken _poolToken,
1727         IERC20Token _reserveToken,
1728         uint256 _poolAmount,
1729         uint256 _reserveAmount,
1730         PackedRates memory _packedRates,
1731         uint256 _addTimestamp,
1732         uint256 _removeTimestamp
1733     ) internal view returns (uint256) {
1734         // get the rate between the pool token and the reserve token
1735         Fraction memory poolRate = poolTokenRate(_poolToken, _reserveToken);
1736 
1737         // get the rate between the reserves upon adding liquidity and now
1738         Fraction memory addSpotRate = Fraction({ n: _packedRates.addSpotRateN, d: _packedRates.addSpotRateD });
1739         Fraction memory removeSpotRate = Fraction({ n: _packedRates.removeSpotRateN, d: _packedRates.removeSpotRateD });
1740         Fraction memory removeAverageRate =
1741             Fraction({ n: _packedRates.removeAverageRateN, d: _packedRates.removeAverageRateD });
1742 
1743         // calculate the protected amount of reserve tokens plus accumulated fee before compensation
1744         uint256 total = protectedAmountPlusFee(_poolAmount, poolRate, addSpotRate, removeSpotRate);
1745 
1746         // calculate the impermanent loss
1747         Fraction memory loss = impLoss(addSpotRate, removeAverageRate);
1748 
1749         // calculate the protection level
1750         Fraction memory level = protectionLevel(_addTimestamp, _removeTimestamp);
1751 
1752         // calculate the compensation amount
1753         return compensationAmount(_reserveAmount, Math.max(_reserveAmount, total), loss, level);
1754     }
1755 
1756     /**
1757      * @dev allows the caller to claim network token balance that is no longer locked
1758      * note that the function can revert if the range is too large
1759      *
1760      * @param _startIndex  start index in the caller's list of locked balances
1761      * @param _endIndex    end index in the caller's list of locked balances (exclusive)
1762      */
1763     function claimBalance(uint256 _startIndex, uint256 _endIndex) external protected {
1764         // get the locked balances from the store
1765         (uint256[] memory amounts, uint256[] memory expirationTimes) =
1766             store.lockedBalanceRange(msg.sender, _startIndex, _endIndex);
1767 
1768         uint256 totalAmount = 0;
1769         uint256 length = amounts.length;
1770         assert(length == expirationTimes.length);
1771 
1772         // reverse iteration since we're removing from the list
1773         for (uint256 i = length; i > 0; i--) {
1774             uint256 index = i - 1;
1775             if (expirationTimes[index] > time()) {
1776                 continue;
1777             }
1778 
1779             // remove the locked balance item
1780             store.removeLockedBalance(msg.sender, _startIndex + index);
1781             totalAmount = totalAmount.add(amounts[index]);
1782         }
1783 
1784         if (totalAmount > 0) {
1785             // transfer the tokens to the caller in a single call
1786             store.withdrawTokens(networkToken, msg.sender, totalAmount);
1787         }
1788     }
1789 
1790     /**
1791      * @dev returns the ROI for removing liquidity in the current state after providing liquidity with the given args
1792      * the function assumes full protection is in effect
1793      * return value is in PPM and can be larger than PPM_RESOLUTION for positive ROI, 1M = 0% ROI
1794      *
1795      * @param _poolToken       pool token
1796      * @param _reserveToken    reserve token
1797      * @param _reserveAmount   reserve token amount that was added
1798      * @param _poolRateN       rate of 1 pool token in reserve token units when the liquidity was added (numerator)
1799      * @param _poolRateD       rate of 1 pool token in reserve token units when the liquidity was added (denominator)
1800      * @param _reserveRateN    rate of 1 reserve token in the other reserve token units when the liquidity was added (numerator)
1801      * @param _reserveRateD    rate of 1 reserve token in the other reserve token units when the liquidity was added (denominator)
1802      * @return ROI in PPM
1803      */
1804     function poolROI(
1805         IDSToken _poolToken,
1806         IERC20Token _reserveToken,
1807         uint256 _reserveAmount,
1808         uint256 _poolRateN,
1809         uint256 _poolRateD,
1810         uint256 _reserveRateN,
1811         uint256 _reserveRateD
1812     ) external view returns (uint256) {
1813         // calculate the amount of pool tokens based on the amount of reserve tokens
1814         uint256 poolAmount = _reserveAmount.mul(_poolRateD).div(_poolRateN);
1815 
1816         // get the various rates between the reserves upon adding liquidity and now
1817         PackedRates memory packedRates = packRates(_poolToken, _reserveToken, _reserveRateN, _reserveRateD, false);
1818 
1819         // get the current return
1820         uint256 protectedReturn =
1821             removeLiquidityTargetAmount(
1822                 _poolToken,
1823                 _reserveToken,
1824                 poolAmount,
1825                 _reserveAmount,
1826                 packedRates,
1827                 time().sub(settings.maxProtectionDelay()),
1828                 time()
1829             );
1830 
1831         // calculate the ROI as the ratio between the current fully protected return and the initial amount
1832         return protectedReturn.mul(PPM_RESOLUTION).div(_reserveAmount);
1833     }
1834 
1835     /**
1836      * @dev adds protected liquidity for the caller to the store
1837      *
1838      * @param _provider        protected liquidity provider
1839      * @param _poolToken       pool token
1840      * @param _reserveToken    reserve token
1841      * @param _poolAmount      amount of pool tokens to protect
1842      * @param _reserveAmount   amount of reserve tokens to protect
1843      * @return new protected liquidity id
1844      */
1845     function addProtectedLiquidity(
1846         address _provider,
1847         IDSToken _poolToken,
1848         IERC20Token _reserveToken,
1849         uint256 _poolAmount,
1850         uint256 _reserveAmount
1851     ) internal returns (uint256) {
1852         Fraction memory rate = reserveTokenAverageRate(_poolToken, _reserveToken, true);
1853         return
1854             store.addProtectedLiquidity(
1855                 _provider,
1856                 _poolToken,
1857                 _reserveToken,
1858                 _poolAmount,
1859                 _reserveAmount,
1860                 rate.n,
1861                 rate.d,
1862                 time()
1863             );
1864     }
1865 
1866     /**
1867      * @dev locks network tokens for the provider and emits the tokens locked event
1868      *
1869      * @param _provider    tokens provider
1870      * @param _amount      amount of network tokens
1871      */
1872     function lockTokens(address _provider, uint256 _amount) internal {
1873         uint256 expirationTime = time().add(settings.lockDuration());
1874         store.addLockedBalance(_provider, _amount, expirationTime);
1875     }
1876 
1877     /**
1878      * @dev returns the rate of 1 pool token in reserve token units
1879      *
1880      * @param _poolToken       pool token
1881      * @param _reserveToken    reserve token
1882      */
1883     function poolTokenRate(IDSToken _poolToken, IERC20Token _reserveToken) internal view virtual returns (Fraction memory) {
1884         // get the pool token supply
1885         uint256 poolTokenSupply = _poolToken.totalSupply();
1886 
1887         // get the reserve balance
1888         IConverter converter = IConverter(payable(ownedBy(_poolToken)));
1889         uint256 reserveBalance = converter.getConnectorBalance(_reserveToken);
1890 
1891         // for standard pools, 50% of the pool supply value equals the value of each reserve
1892         return Fraction({ n: reserveBalance.mul(2), d: poolTokenSupply });
1893     }
1894 
1895     /**
1896      * @dev returns the average rate of 1 reserve token in the other reserve token units
1897      *
1898      * @param _poolToken            pool token
1899      * @param _reserveToken         reserve token
1900      * @param _validateAverageRate  true to validate the average rate; false otherwise
1901      */
1902     function reserveTokenAverageRate(
1903         IDSToken _poolToken,
1904         IERC20Token _reserveToken,
1905         bool _validateAverageRate
1906     ) internal view returns (Fraction memory) {
1907         (, , uint256 averageRateN, uint256 averageRateD) =
1908             reserveTokenRates(_poolToken, _reserveToken, _validateAverageRate);
1909         return Fraction(averageRateN, averageRateD);
1910     }
1911 
1912     /**
1913      * @dev returns the spot rate and average rate of 1 reserve token in the other reserve token units
1914      *
1915      * @param _poolToken            pool token
1916      * @param _reserveToken         reserve token
1917      * @param _validateAverageRate  true to validate the average rate; false otherwise
1918      */
1919     function reserveTokenRates(
1920         IDSToken _poolToken,
1921         IERC20Token _reserveToken,
1922         bool _validateAverageRate
1923     )
1924         internal
1925         view
1926         returns (
1927             uint256,
1928             uint256,
1929             uint256,
1930             uint256
1931         )
1932     {
1933         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolToken)));
1934         IERC20Token otherReserve = converterOtherReserve(converter, _reserveToken);
1935 
1936         (uint256 spotRateN, uint256 spotRateD) = converterReserveBalances(converter, otherReserve, _reserveToken);
1937         (uint256 averageRateN, uint256 averageRateD) = converter.recentAverageRate(_reserveToken);
1938 
1939         require(
1940             !_validateAverageRate ||
1941                 averageRateInRange(
1942                     spotRateN,
1943                     spotRateD,
1944                     averageRateN,
1945                     averageRateD,
1946                     settings.averageRateMaxDeviation()
1947                 ),
1948             "ERR_INVALID_RATE"
1949         );
1950 
1951         return (spotRateN, spotRateD, averageRateN, averageRateD);
1952     }
1953 
1954     /**
1955      * @dev returns the various rates between the reserves
1956      *
1957      * @param _poolToken            pool token
1958      * @param _reserveToken         reserve token
1959      * @param _addSpotRateN         add spot rate numerator
1960      * @param _addSpotRateD         add spot rate denominator
1961      * @param _validateAverageRate  true to validate the average rate; false otherwise
1962      * @return see `struct PackedRates`
1963      */
1964     function packRates(
1965         IDSToken _poolToken,
1966         IERC20Token _reserveToken,
1967         uint256 _addSpotRateN,
1968         uint256 _addSpotRateD,
1969         bool _validateAverageRate
1970     ) internal view returns (PackedRates memory) {
1971         (uint256 removeSpotRateN, uint256 removeSpotRateD, uint256 removeAverageRateN, uint256 removeAverageRateD) =
1972             reserveTokenRates(_poolToken, _reserveToken, _validateAverageRate);
1973 
1974         require(
1975             (_addSpotRateN <= MAX_UINT128 && _addSpotRateD <= MAX_UINT128) &&
1976                 (removeSpotRateN <= MAX_UINT128 && removeSpotRateD <= MAX_UINT128) &&
1977                 (removeAverageRateN <= MAX_UINT128 && removeAverageRateD <= MAX_UINT128),
1978             "ERR_INVALID_RATE"
1979         );
1980 
1981         return
1982             PackedRates({
1983                 addSpotRateN: uint128(_addSpotRateN),
1984                 addSpotRateD: uint128(_addSpotRateD),
1985                 removeSpotRateN: uint128(removeSpotRateN),
1986                 removeSpotRateD: uint128(removeSpotRateD),
1987                 removeAverageRateN: uint128(removeAverageRateN),
1988                 removeAverageRateD: uint128(removeAverageRateD)
1989             });
1990     }
1991 
1992     /**
1993      * @dev returns whether or not the deviation of the average rate from the spot rate is within range
1994      * for example, if the maximum permitted deviation is 5%, then return `95/100 <= average/spot <= 100/95`
1995      *
1996      * @param _spotRateN       spot rate numerator
1997      * @param _spotRateD       spot rate denominator
1998      * @param _averageRateN    average rate numerator
1999      * @param _averageRateD    average rate denominator
2000      * @param _maxDeviation    the maximum permitted deviation of the average rate from the spot rate
2001      */
2002     function averageRateInRange(
2003         uint256 _spotRateN,
2004         uint256 _spotRateD,
2005         uint256 _averageRateN,
2006         uint256 _averageRateD,
2007         uint32 _maxDeviation
2008     ) internal pure returns (bool) {
2009         uint256 min =
2010             _spotRateN.mul(_averageRateD).mul(PPM_RESOLUTION - _maxDeviation).mul(PPM_RESOLUTION - _maxDeviation);
2011         uint256 mid = _spotRateD.mul(_averageRateN).mul(PPM_RESOLUTION - _maxDeviation).mul(PPM_RESOLUTION);
2012         uint256 max = _spotRateN.mul(_averageRateD).mul(PPM_RESOLUTION).mul(PPM_RESOLUTION);
2013         return min <= mid && mid <= max;
2014     }
2015 
2016     /**
2017      * @dev utility to add liquidity to a converter
2018      *
2019      * @param _converter       converter
2020      * @param _reserveToken1   reserve token 1
2021      * @param _reserveToken2   reserve token 2
2022      * @param _reserveAmount1  reserve amount 1
2023      * @param _reserveAmount2  reserve amount 2
2024      * @param _value           ETH amount to add
2025      */
2026     function addLiquidity(
2027         ILiquidityPoolConverter _converter,
2028         IERC20Token _reserveToken1,
2029         IERC20Token _reserveToken2,
2030         uint256 _reserveAmount1,
2031         uint256 _reserveAmount2,
2032         uint256 _value
2033     ) internal {
2034         // ensure that the contract can receive ETH
2035         updatingLiquidity = true;
2036 
2037         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
2038         uint256[] memory amounts = new uint256[](2);
2039         reserveTokens[0] = _reserveToken1;
2040         reserveTokens[1] = _reserveToken2;
2041         amounts[0] = _reserveAmount1;
2042         amounts[1] = _reserveAmount2;
2043         _converter.addLiquidity{ value: _value }(reserveTokens, amounts, 1);
2044 
2045         // ensure that the contract can receive ETH
2046         updatingLiquidity = false;
2047     }
2048 
2049     /**
2050      * @dev utility to remove liquidity from a converter
2051      *
2052      * @param _poolToken       pool token of the converter
2053      * @param _poolAmount      amount of pool tokens to remove
2054      * @param _reserveToken1   reserve token 1
2055      * @param _reserveToken2   reserve token 2
2056      */
2057     function removeLiquidity(
2058         IDSToken _poolToken,
2059         uint256 _poolAmount,
2060         IERC20Token _reserveToken1,
2061         IERC20Token _reserveToken2
2062     ) internal {
2063         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolToken)));
2064 
2065         // ensure that the contract can receive ETH
2066         updatingLiquidity = true;
2067 
2068         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
2069         uint256[] memory minReturns = new uint256[](2);
2070         reserveTokens[0] = _reserveToken1;
2071         reserveTokens[1] = _reserveToken2;
2072         minReturns[0] = 1;
2073         minReturns[1] = 1;
2074         converter.removeLiquidity(_poolAmount, reserveTokens, minReturns);
2075 
2076         // ensure that the contract can receive ETH
2077         updatingLiquidity = false;
2078     }
2079 
2080     /**
2081      * @dev returns a protected liquidity from the store
2082      *
2083      * @param _id  protected liquidity id
2084      * @return protected liquidity
2085      */
2086     function protectedLiquidity(uint256 _id) internal view returns (ProtectedLiquidity memory) {
2087         ProtectedLiquidity memory liquidity;
2088         (
2089             liquidity.provider,
2090             liquidity.poolToken,
2091             liquidity.reserveToken,
2092             liquidity.poolAmount,
2093             liquidity.reserveAmount,
2094             liquidity.reserveRateN,
2095             liquidity.reserveRateD,
2096             liquidity.timestamp
2097         ) = store.protectedLiquidity(_id);
2098 
2099         return liquidity;
2100     }
2101 
2102     /**
2103      * @dev returns a protected liquidity from the store
2104      *
2105      * @param _id          protected liquidity id
2106      * @param _provider    authorized provider
2107      * @return protected liquidity
2108      */
2109     function protectedLiquidity(uint256 _id, address _provider) internal view returns (ProtectedLiquidity memory) {
2110         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
2111         require(liquidity.provider == _provider, "ERR_ACCESS_DENIED");
2112         return liquidity;
2113     }
2114 
2115     /**
2116      * @dev returns the protected amount of reserve tokens plus accumulated fee before compensation
2117      *
2118      * @param _poolAmount      pool token amount when the liquidity was added
2119      * @param _poolRate        rate of 1 pool token in the related reserve token units
2120      * @param _addRate         rate of 1 reserve token in the other reserve token units when the liquidity was added
2121      * @param _removeRate      rate of 1 reserve token in the other reserve token units when the liquidity is removed
2122      * @return protected amount of reserve tokens plus accumulated fee = sqrt(_removeRate / _addRate) * _poolRate * _poolAmount
2123      */
2124     function protectedAmountPlusFee(
2125         uint256 _poolAmount,
2126         Fraction memory _poolRate,
2127         Fraction memory _addRate,
2128         Fraction memory _removeRate
2129     ) internal pure returns (uint256) {
2130         uint256 n = Math.ceilSqrt(_addRate.d.mul(_removeRate.n)).mul(_poolRate.n);
2131         uint256 d = Math.floorSqrt(_addRate.n.mul(_removeRate.d)).mul(_poolRate.d);
2132 
2133         uint256 x = n * _poolAmount;
2134         if (x / n == _poolAmount) {
2135             return x / d;
2136         }
2137 
2138         (uint256 hi, uint256 lo) = n > _poolAmount ? (n, _poolAmount) : (_poolAmount, n);
2139         (uint256 p, uint256 q) = Math.reducedRatio(hi, d, MAX_UINT256 / lo);
2140         uint256 min = (hi / d).mul(lo);
2141 
2142         if (q > 0) {
2143             return Math.max(min, p * lo / q);
2144         }
2145         return min;
2146     }
2147 
2148     /**
2149      * @dev returns the impermanent loss incurred due to the change in rates between the reserve tokens
2150      *
2151      * @param _prevRate    previous rate between the reserves
2152      * @param _newRate     new rate between the reserves
2153      * @return impermanent loss (as a ratio)
2154      */
2155     function impLoss(Fraction memory _prevRate, Fraction memory _newRate) internal pure returns (Fraction memory) {
2156         uint256 ratioN = _newRate.n.mul(_prevRate.d);
2157         uint256 ratioD = _newRate.d.mul(_prevRate.n);
2158 
2159         uint256 prod = ratioN * ratioD;
2160         uint256 root = prod / ratioN == ratioD ? Math.floorSqrt(prod) : Math.floorSqrt(ratioN) * Math.floorSqrt(ratioD);
2161         uint256 sum = ratioN.add(ratioD);
2162 
2163         // the arithmetic below is safe because `x + y >= sqrt(x * y) * 2`
2164         if (sum % 2 == 0) {
2165             sum /= 2;
2166             return Fraction({ n: sum - root, d: sum });
2167         }
2168         return Fraction({ n: sum - root * 2, d: sum });
2169     }
2170 
2171     /**
2172      * @dev returns the protection level based on the timestamp and protection delays
2173      *
2174      * @param _addTimestamp    time at which the liquidity was added
2175      * @param _removeTimestamp time at which the liquidity is removed
2176      * @return protection level (as a ratio)
2177      */
2178     function protectionLevel(uint256 _addTimestamp, uint256 _removeTimestamp) internal view returns (Fraction memory) {
2179         uint256 timeElapsed = _removeTimestamp.sub(_addTimestamp);
2180         uint256 minProtectionDelay = settings.minProtectionDelay();
2181         uint256 maxProtectionDelay = settings.maxProtectionDelay();
2182         if (timeElapsed < minProtectionDelay) {
2183             return Fraction({ n: 0, d: 1 });
2184         }
2185 
2186         if (timeElapsed >= maxProtectionDelay) {
2187             return Fraction({ n: 1, d: 1 });
2188         }
2189 
2190         return Fraction({ n: timeElapsed, d: maxProtectionDelay });
2191     }
2192 
2193     /**
2194      * @dev returns the compensation amount based on the impermanent loss and the protection level
2195      *
2196      * @param _amount  protected amount in units of the reserve token
2197      * @param _total   amount plus fee in units of the reserve token
2198      * @param _loss    protection level (as a ratio between 0 and 1)
2199      * @param _level   impermanent loss (as a ratio between 0 and 1)
2200      * @return compensation amount
2201      */
2202     function compensationAmount(
2203         uint256 _amount,
2204         uint256 _total,
2205         Fraction memory _loss,
2206         Fraction memory _level
2207     ) internal pure returns (uint256) {
2208         uint256 levelN = _level.n.mul(_amount);
2209         uint256 levelD = _level.d;
2210         uint256 maxVal = Math.max(Math.max(levelN, levelD), _total);
2211         (uint256 lossN, uint256 lossD) = Math.reducedRatio(_loss.n, _loss.d, MAX_UINT256 / maxVal);
2212         return _total.mul(lossD.sub(lossN)).div(lossD).add(lossN.mul(levelN).div(lossD.mul(levelD)));
2213     }
2214 
2215     function getNetworkCompensation(
2216         uint256 _targetAmount,
2217         uint256 _baseAmount,
2218         PackedRates memory _packedRates
2219     ) internal view returns (uint256) {
2220         if (_targetAmount <= _baseAmount) {
2221             return 0;
2222         }
2223 
2224         // calculate the delta in network tokens
2225         uint256 delta =
2226             (_targetAmount - _baseAmount).mul(_packedRates.removeAverageRateN).div(_packedRates.removeAverageRateD);
2227 
2228         // the delta might be very small due to precision loss
2229         // in which case no compensation will take place (gas optimization)
2230         if (delta >= settings.minNetworkCompensation()) {
2231             return delta;
2232         }
2233 
2234         return 0;
2235     }
2236 
2237     /**
2238      * @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
2239      * note that we use the non standard erc-20 interface in which `approve` has no return value so that
2240      * this function will work for both standard and non standard tokens
2241      *
2242      * @param _token   token to check the allowance in
2243      * @param _spender approved address
2244      * @param _value   allowance amount
2245      */
2246     function ensureAllowance(
2247         IERC20Token _token,
2248         address _spender,
2249         uint256 _value
2250     ) private {
2251         uint256 allowance = _token.allowance(address(this), _spender);
2252         if (allowance < _value) {
2253             if (allowance > 0) safeApprove(_token, _spender, 0);
2254             safeApprove(_token, _spender, _value);
2255         }
2256     }
2257 
2258     // utility to get the reserve balances
2259     function converterReserveBalances(
2260         IConverter _converter,
2261         IERC20Token _reserveToken1,
2262         IERC20Token _reserveToken2
2263     ) private view returns (uint256, uint256) {
2264         return (_converter.getConnectorBalance(_reserveToken1), _converter.getConnectorBalance(_reserveToken2));
2265     }
2266 
2267     // utility to get the other reserve
2268     function converterOtherReserve(
2269         IConverter _converter,
2270         IERC20Token _thisReserve
2271     ) private view returns (IERC20Token) {
2272         IERC20Token otherReserve = _converter.connectorTokens(0);
2273         return otherReserve != _thisReserve ? otherReserve : _converter.connectorTokens(1);
2274     }
2275 
2276     // utility to get the owner
2277     function ownedBy(IOwned _owned) private view returns (address) {
2278         return _owned.owner();
2279     }
2280 }
