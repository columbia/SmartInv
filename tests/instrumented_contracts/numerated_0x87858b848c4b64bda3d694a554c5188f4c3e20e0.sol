1 // SPDX-License-Identifier: BUSL-1.1
2 // File: lib/ipor-protocol-commons/src/errors/IporErrors.sol
3 
4 
5 pragma solidity 0.8.17;
6 
7 library IporErrors {
8     // 000-199 - general codes
9 
10     /// @notice General problem, address is wrong
11     string public constant WRONG_ADDRESS = "IPOR_000";
12 
13     /// @notice General problem. Wrong decimals
14     string public constant WRONG_DECIMALS = "IPOR_001";
15 
16     string public constant ADDRESSES_MISMATCH = "IPOR_002";
17 
18     //@notice Trader doesnt have enought tokens to execute transaction
19     string public constant ASSET_BALANCE_TOO_LOW = "IPOR_003";
20 
21     string public constant VALUE_NOT_GREATER_THAN_ZERO = "IPOR_004";
22 
23     string public constant INPUT_ARRAYS_LENGTH_MISMATCH = "IPOR_005";
24 
25     //@notice Amount is too low to transfer
26     string public constant NOT_ENOUGH_AMOUNT_TO_TRANSFER = "IPOR_006";
27 
28     //@notice msg.sender is not an appointed owner, so cannot confirm his appointment to be an owner of a specific smart contract
29     string public constant SENDER_NOT_APPOINTED_OWNER = "IPOR_007";
30 
31     //only milton can have access to function
32     string public constant CALLER_NOT_MILTON = "IPOR_008";
33 
34     string public constant CHUNK_SIZE_EQUAL_ZERO = "IPOR_009";
35 
36     string public constant CHUNK_SIZE_TOO_BIG = "IPOR_010";
37 }
38 
39 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
40 
41 
42 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Contract module that helps prevent reentrant calls to a function.
48  *
49  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
50  * available, which can be applied to functions to make sure there are no nested
51  * (reentrant) calls to them.
52  *
53  * Note that because there is a single `nonReentrant` guard, functions marked as
54  * `nonReentrant` may not call one another. This can be worked around by making
55  * those functions `private`, and then adding `external` `nonReentrant` entry
56  * points to them.
57  *
58  * TIP: If you would like to learn more about reentrancy and alternative ways
59  * to protect against it, check out our blog post
60  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
61  */
62 abstract contract ReentrancyGuard {
63     // Booleans are more expensive than uint256 or any type that takes up a full
64     // word because each write operation emits an extra SLOAD to first read the
65     // slot's contents, replace the bits taken up by the boolean, and then write
66     // back. This is the compiler's defense against contract upgrades and
67     // pointer aliasing, and it cannot be disabled.
68 
69     // The values being non-zero value makes deployment a bit more expensive,
70     // but in exchange the refund on every call to nonReentrant will be lower in
71     // amount. Since refunds are capped to a percentage of the total
72     // transaction's gas, it is best to keep them low in cases like this one, to
73     // increase the likelihood of the full refund coming into effect.
74     uint256 private constant _NOT_ENTERED = 1;
75     uint256 private constant _ENTERED = 2;
76 
77     uint256 private _status;
78 
79     constructor() {
80         _status = _NOT_ENTERED;
81     }
82 
83     /**
84      * @dev Prevents a contract from calling itself, directly or indirectly.
85      * Calling a `nonReentrant` function from another `nonReentrant`
86      * function is not supported. It is possible to prevent this from happening
87      * by making the `nonReentrant` function external, and making it call a
88      * `private` function that does the actual work.
89      */
90     modifier nonReentrant() {
91         _nonReentrantBefore();
92         _;
93         _nonReentrantAfter();
94     }
95 
96     function _nonReentrantBefore() private {
97         // On the first call to nonReentrant, _status will be _NOT_ENTERED
98         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
99 
100         // Any calls to nonReentrant after this point will fail
101         _status = _ENTERED;
102     }
103 
104     function _nonReentrantAfter() private {
105         // By storing the original value once again, a refund is triggered (see
106         // https://eips.ethereum.org/EIPS/eip-2200)
107         _status = _NOT_ENTERED;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Context.sol
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         return msg.data;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/access/Ownable.sol
139 
140 
141 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 
146 /**
147  * @dev Contract module which provides a basic access control mechanism, where
148  * there is an account (an owner) that can be granted exclusive access to
149  * specific functions.
150  *
151  * By default, the owner account will be the one that deploys the contract. This
152  * can later be changed with {transferOwnership}.
153  *
154  * This module is used through inheritance. It will make available the modifier
155  * `onlyOwner`, which can be applied to your functions to restrict their use to
156  * the owner.
157  */
158 abstract contract Ownable is Context {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     /**
164      * @dev Initializes the contract setting the deployer as the initial owner.
165      */
166     constructor() {
167         _transferOwnership(_msgSender());
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         _checkOwner();
175         _;
176     }
177 
178     /**
179      * @dev Returns the address of the current owner.
180      */
181     function owner() public view virtual returns (address) {
182         return _owner;
183     }
184 
185     /**
186      * @dev Throws if the sender is not the owner.
187      */
188     function _checkOwner() internal view virtual {
189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: lib/ipor-protocol-commons/src/security/IporOwnable.sol
224 
225 
226 pragma solidity 0.8.17;
227 
228 
229 
230 abstract contract IporOwnable is Ownable {
231     address private _appointedOwner;
232 
233     event AppointedToTransferOwnership(address indexed appointedOwner);
234 
235     modifier onlyAppointedOwner() {
236         require(
237             _appointedOwner == _msgSender(),
238             IporErrors.SENDER_NOT_APPOINTED_OWNER
239         );
240         _;
241     }
242 
243     function transferOwnership(address appointedOwner)
244         public
245         override
246         onlyOwner
247     {
248         require(appointedOwner != address(0), IporErrors.WRONG_ADDRESS);
249         _appointedOwner = appointedOwner;
250         emit AppointedToTransferOwnership(appointedOwner);
251     }
252 
253     function confirmTransferOwnership() external onlyAppointedOwner {
254         _appointedOwner = address(0);
255         _transferOwnership(_msgSender());
256     }
257 
258     function renounceOwnership() public virtual override onlyOwner {
259         _transferOwnership(address(0));
260         _appointedOwner = address(0);
261     }
262 }
263 
264 // File: @openzeppelin/contracts/security/Pausable.sol
265 
266 
267 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 
272 /**
273  * @dev Contract module which allows children to implement an emergency stop
274  * mechanism that can be triggered by an authorized account.
275  *
276  * This module is used through inheritance. It will make available the
277  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
278  * the functions of your contract. Note that they will not be pausable by
279  * simply including this module, only once the modifiers are put in place.
280  */
281 abstract contract Pausable is Context {
282     /**
283      * @dev Emitted when the pause is triggered by `account`.
284      */
285     event Paused(address account);
286 
287     /**
288      * @dev Emitted when the pause is lifted by `account`.
289      */
290     event Unpaused(address account);
291 
292     bool private _paused;
293 
294     /**
295      * @dev Initializes the contract in unpaused state.
296      */
297     constructor() {
298         _paused = false;
299     }
300 
301     /**
302      * @dev Modifier to make a function callable only when the contract is not paused.
303      *
304      * Requirements:
305      *
306      * - The contract must not be paused.
307      */
308     modifier whenNotPaused() {
309         _requireNotPaused();
310         _;
311     }
312 
313     /**
314      * @dev Modifier to make a function callable only when the contract is paused.
315      *
316      * Requirements:
317      *
318      * - The contract must be paused.
319      */
320     modifier whenPaused() {
321         _requirePaused();
322         _;
323     }
324 
325     /**
326      * @dev Returns true if the contract is paused, and false otherwise.
327      */
328     function paused() public view virtual returns (bool) {
329         return _paused;
330     }
331 
332     /**
333      * @dev Throws if the contract is paused.
334      */
335     function _requireNotPaused() internal view virtual {
336         require(!paused(), "Pausable: paused");
337     }
338 
339     /**
340      * @dev Throws if the contract is not paused.
341      */
342     function _requirePaused() internal view virtual {
343         require(paused(), "Pausable: not paused");
344     }
345 
346     /**
347      * @dev Triggers stopped state.
348      *
349      * Requirements:
350      *
351      * - The contract must not be paused.
352      */
353     function _pause() internal virtual whenNotPaused {
354         _paused = true;
355         emit Paused(_msgSender());
356     }
357 
358     /**
359      * @dev Returns to normal state.
360      *
361      * Requirements:
362      *
363      * - The contract must be paused.
364      */
365     function _unpause() internal virtual whenPaused {
366         _paused = false;
367         emit Unpaused(_msgSender());
368     }
369 }
370 
371 // File: src/airdrop/AirdropTypes.sol
372 
373 
374 pragma solidity 0.8.17;
375 
376 library AirdropTypes {
377     struct State {
378         uint128 initialValue;
379         uint128 released;
380     }
381 }
382 
383 // File: lib/ipor-protocol-commons/src/errors/IporAirdropErrors.sol
384 
385 
386 pragma solidity 0.8.17;
387 
388 library IporAirdropErrors {
389     // 000-199 - general codes
390 
391     /// @notice General problem, address is wrong
392     string public constant WRONG_ADDRESS = "IPOR_750";
393     //@notice msg.sender is not an appointed owner, so cannot confirm his appointment to be an owner of a specific smart contract
394     string public constant SENDER_NOT_APPOINTED_OWNER = "IPOR_751";
395 
396     string public constant INPUT_ARRAYS_LENGTH_MISMATCH = "IPOR_752";
397 
398     string public constant NO_AIRDROPS = "IPOR_753";
399 
400     string public constant NO_STAKEHOLDERS = "IPOR_754";
401 
402     string public constant ALREADY_RELEASED = "IPOR_755";
403 
404     string public constant AIRDROP_ALREADY_EXISTS = "IPOR_756";
405 
406     string public constant AMOUNT_HIGHER_THAN_INITIAL_VALUE = "IPOR_757";
407 
408     string public constant VESTING_DURATION_SHOULD_BE_HIGHER_THAN_ZERO =
409         "IPOR_758";
410 
411     string
412         public constant VESTING_START_TIME_SHOULD_BE_HIGHER_THAN_BLOCK_TIMESTAMP =
413         "IPOR_759";
414 
415     /// @notice General problem, contract is wrong
416     string public constant WRONG_CONTRACT_ID = "IPOR_760";
417 
418     string public constant ONLY_CONFIRMED_TERMS_OF_USE = "IPOR_761";
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev Interface of the ERC20 standard as defined in the EIP.
430  */
431 interface IERC20 {
432     /**
433      * @dev Emitted when `value` tokens are moved from one account (`from`) to
434      * another (`to`).
435      *
436      * Note that `value` may be zero.
437      */
438     event Transfer(address indexed from, address indexed to, uint256 value);
439 
440     /**
441      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
442      * a call to {approve}. `value` is the new allowance.
443      */
444     event Approval(address indexed owner, address indexed spender, uint256 value);
445 
446     /**
447      * @dev Returns the amount of tokens in existence.
448      */
449     function totalSupply() external view returns (uint256);
450 
451     /**
452      * @dev Returns the amount of tokens owned by `account`.
453      */
454     function balanceOf(address account) external view returns (uint256);
455 
456     /**
457      * @dev Moves `amount` tokens from the caller's account to `to`.
458      *
459      * Returns a boolean value indicating whether the operation succeeded.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transfer(address to, uint256 amount) external returns (bool);
464 
465     /**
466      * @dev Returns the remaining number of tokens that `spender` will be
467      * allowed to spend on behalf of `owner` through {transferFrom}. This is
468      * zero by default.
469      *
470      * This value changes when {approve} or {transferFrom} are called.
471      */
472     function allowance(address owner, address spender) external view returns (uint256);
473 
474     /**
475      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
476      *
477      * Returns a boolean value indicating whether the operation succeeded.
478      *
479      * IMPORTANT: Beware that changing an allowance with this method brings the risk
480      * that someone may use both the old and the new allowance by unfortunate
481      * transaction ordering. One possible solution to mitigate this race
482      * condition is to first reduce the spender's allowance to 0 and set the
483      * desired value afterwards:
484      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
485      *
486      * Emits an {Approval} event.
487      */
488     function approve(address spender, uint256 amount) external returns (bool);
489 
490     /**
491      * @dev Moves `amount` tokens from `from` to `to` using the
492      * allowance mechanism. `amount` is then deducted from the caller's
493      * allowance.
494      *
495      * Returns a boolean value indicating whether the operation succeeded.
496      *
497      * Emits a {Transfer} event.
498      */
499     function transferFrom(
500         address from,
501         address to,
502         uint256 amount
503     ) external returns (bool);
504 }
505 
506 // File: src/interface/IIporToken.sol
507 
508 
509 pragma solidity 0.8.17;
510 
511 
512 /// @title Interface of iporToken
513 interface IIporToken is IERC20 {
514     function getContractId() external pure returns (bytes32);
515 }
516 
517 // File: @openzeppelin/contracts/utils/math/SafeCast.sol
518 
519 
520 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SafeCast.sol)
521 // This file was procedurally generated from scripts/generate/templates/SafeCast.js.
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
527  * checks.
528  *
529  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
530  * easily result in undesired exploitation or bugs, since developers usually
531  * assume that overflows raise errors. `SafeCast` restores this intuition by
532  * reverting the transaction when such an operation overflows.
533  *
534  * Using this library instead of the unchecked operations eliminates an entire
535  * class of bugs, so it's recommended to use it always.
536  *
537  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
538  * all math on `uint256` and `int256` and then downcasting.
539  */
540 library SafeCast {
541     /**
542      * @dev Returns the downcasted uint248 from uint256, reverting on
543      * overflow (when the input is greater than largest uint248).
544      *
545      * Counterpart to Solidity's `uint248` operator.
546      *
547      * Requirements:
548      *
549      * - input must fit into 248 bits
550      *
551      * _Available since v4.7._
552      */
553     function toUint248(uint256 value) internal pure returns (uint248) {
554         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
555         return uint248(value);
556     }
557 
558     /**
559      * @dev Returns the downcasted uint240 from uint256, reverting on
560      * overflow (when the input is greater than largest uint240).
561      *
562      * Counterpart to Solidity's `uint240` operator.
563      *
564      * Requirements:
565      *
566      * - input must fit into 240 bits
567      *
568      * _Available since v4.7._
569      */
570     function toUint240(uint256 value) internal pure returns (uint240) {
571         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
572         return uint240(value);
573     }
574 
575     /**
576      * @dev Returns the downcasted uint232 from uint256, reverting on
577      * overflow (when the input is greater than largest uint232).
578      *
579      * Counterpart to Solidity's `uint232` operator.
580      *
581      * Requirements:
582      *
583      * - input must fit into 232 bits
584      *
585      * _Available since v4.7._
586      */
587     function toUint232(uint256 value) internal pure returns (uint232) {
588         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
589         return uint232(value);
590     }
591 
592     /**
593      * @dev Returns the downcasted uint224 from uint256, reverting on
594      * overflow (when the input is greater than largest uint224).
595      *
596      * Counterpart to Solidity's `uint224` operator.
597      *
598      * Requirements:
599      *
600      * - input must fit into 224 bits
601      *
602      * _Available since v4.2._
603      */
604     function toUint224(uint256 value) internal pure returns (uint224) {
605         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
606         return uint224(value);
607     }
608 
609     /**
610      * @dev Returns the downcasted uint216 from uint256, reverting on
611      * overflow (when the input is greater than largest uint216).
612      *
613      * Counterpart to Solidity's `uint216` operator.
614      *
615      * Requirements:
616      *
617      * - input must fit into 216 bits
618      *
619      * _Available since v4.7._
620      */
621     function toUint216(uint256 value) internal pure returns (uint216) {
622         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
623         return uint216(value);
624     }
625 
626     /**
627      * @dev Returns the downcasted uint208 from uint256, reverting on
628      * overflow (when the input is greater than largest uint208).
629      *
630      * Counterpart to Solidity's `uint208` operator.
631      *
632      * Requirements:
633      *
634      * - input must fit into 208 bits
635      *
636      * _Available since v4.7._
637      */
638     function toUint208(uint256 value) internal pure returns (uint208) {
639         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
640         return uint208(value);
641     }
642 
643     /**
644      * @dev Returns the downcasted uint200 from uint256, reverting on
645      * overflow (when the input is greater than largest uint200).
646      *
647      * Counterpart to Solidity's `uint200` operator.
648      *
649      * Requirements:
650      *
651      * - input must fit into 200 bits
652      *
653      * _Available since v4.7._
654      */
655     function toUint200(uint256 value) internal pure returns (uint200) {
656         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
657         return uint200(value);
658     }
659 
660     /**
661      * @dev Returns the downcasted uint192 from uint256, reverting on
662      * overflow (when the input is greater than largest uint192).
663      *
664      * Counterpart to Solidity's `uint192` operator.
665      *
666      * Requirements:
667      *
668      * - input must fit into 192 bits
669      *
670      * _Available since v4.7._
671      */
672     function toUint192(uint256 value) internal pure returns (uint192) {
673         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
674         return uint192(value);
675     }
676 
677     /**
678      * @dev Returns the downcasted uint184 from uint256, reverting on
679      * overflow (when the input is greater than largest uint184).
680      *
681      * Counterpart to Solidity's `uint184` operator.
682      *
683      * Requirements:
684      *
685      * - input must fit into 184 bits
686      *
687      * _Available since v4.7._
688      */
689     function toUint184(uint256 value) internal pure returns (uint184) {
690         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
691         return uint184(value);
692     }
693 
694     /**
695      * @dev Returns the downcasted uint176 from uint256, reverting on
696      * overflow (when the input is greater than largest uint176).
697      *
698      * Counterpart to Solidity's `uint176` operator.
699      *
700      * Requirements:
701      *
702      * - input must fit into 176 bits
703      *
704      * _Available since v4.7._
705      */
706     function toUint176(uint256 value) internal pure returns (uint176) {
707         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
708         return uint176(value);
709     }
710 
711     /**
712      * @dev Returns the downcasted uint168 from uint256, reverting on
713      * overflow (when the input is greater than largest uint168).
714      *
715      * Counterpart to Solidity's `uint168` operator.
716      *
717      * Requirements:
718      *
719      * - input must fit into 168 bits
720      *
721      * _Available since v4.7._
722      */
723     function toUint168(uint256 value) internal pure returns (uint168) {
724         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
725         return uint168(value);
726     }
727 
728     /**
729      * @dev Returns the downcasted uint160 from uint256, reverting on
730      * overflow (when the input is greater than largest uint160).
731      *
732      * Counterpart to Solidity's `uint160` operator.
733      *
734      * Requirements:
735      *
736      * - input must fit into 160 bits
737      *
738      * _Available since v4.7._
739      */
740     function toUint160(uint256 value) internal pure returns (uint160) {
741         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
742         return uint160(value);
743     }
744 
745     /**
746      * @dev Returns the downcasted uint152 from uint256, reverting on
747      * overflow (when the input is greater than largest uint152).
748      *
749      * Counterpart to Solidity's `uint152` operator.
750      *
751      * Requirements:
752      *
753      * - input must fit into 152 bits
754      *
755      * _Available since v4.7._
756      */
757     function toUint152(uint256 value) internal pure returns (uint152) {
758         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
759         return uint152(value);
760     }
761 
762     /**
763      * @dev Returns the downcasted uint144 from uint256, reverting on
764      * overflow (when the input is greater than largest uint144).
765      *
766      * Counterpart to Solidity's `uint144` operator.
767      *
768      * Requirements:
769      *
770      * - input must fit into 144 bits
771      *
772      * _Available since v4.7._
773      */
774     function toUint144(uint256 value) internal pure returns (uint144) {
775         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
776         return uint144(value);
777     }
778 
779     /**
780      * @dev Returns the downcasted uint136 from uint256, reverting on
781      * overflow (when the input is greater than largest uint136).
782      *
783      * Counterpart to Solidity's `uint136` operator.
784      *
785      * Requirements:
786      *
787      * - input must fit into 136 bits
788      *
789      * _Available since v4.7._
790      */
791     function toUint136(uint256 value) internal pure returns (uint136) {
792         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
793         return uint136(value);
794     }
795 
796     /**
797      * @dev Returns the downcasted uint128 from uint256, reverting on
798      * overflow (when the input is greater than largest uint128).
799      *
800      * Counterpart to Solidity's `uint128` operator.
801      *
802      * Requirements:
803      *
804      * - input must fit into 128 bits
805      *
806      * _Available since v2.5._
807      */
808     function toUint128(uint256 value) internal pure returns (uint128) {
809         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
810         return uint128(value);
811     }
812 
813     /**
814      * @dev Returns the downcasted uint120 from uint256, reverting on
815      * overflow (when the input is greater than largest uint120).
816      *
817      * Counterpart to Solidity's `uint120` operator.
818      *
819      * Requirements:
820      *
821      * - input must fit into 120 bits
822      *
823      * _Available since v4.7._
824      */
825     function toUint120(uint256 value) internal pure returns (uint120) {
826         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
827         return uint120(value);
828     }
829 
830     /**
831      * @dev Returns the downcasted uint112 from uint256, reverting on
832      * overflow (when the input is greater than largest uint112).
833      *
834      * Counterpart to Solidity's `uint112` operator.
835      *
836      * Requirements:
837      *
838      * - input must fit into 112 bits
839      *
840      * _Available since v4.7._
841      */
842     function toUint112(uint256 value) internal pure returns (uint112) {
843         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
844         return uint112(value);
845     }
846 
847     /**
848      * @dev Returns the downcasted uint104 from uint256, reverting on
849      * overflow (when the input is greater than largest uint104).
850      *
851      * Counterpart to Solidity's `uint104` operator.
852      *
853      * Requirements:
854      *
855      * - input must fit into 104 bits
856      *
857      * _Available since v4.7._
858      */
859     function toUint104(uint256 value) internal pure returns (uint104) {
860         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
861         return uint104(value);
862     }
863 
864     /**
865      * @dev Returns the downcasted uint96 from uint256, reverting on
866      * overflow (when the input is greater than largest uint96).
867      *
868      * Counterpart to Solidity's `uint96` operator.
869      *
870      * Requirements:
871      *
872      * - input must fit into 96 bits
873      *
874      * _Available since v4.2._
875      */
876     function toUint96(uint256 value) internal pure returns (uint96) {
877         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
878         return uint96(value);
879     }
880 
881     /**
882      * @dev Returns the downcasted uint88 from uint256, reverting on
883      * overflow (when the input is greater than largest uint88).
884      *
885      * Counterpart to Solidity's `uint88` operator.
886      *
887      * Requirements:
888      *
889      * - input must fit into 88 bits
890      *
891      * _Available since v4.7._
892      */
893     function toUint88(uint256 value) internal pure returns (uint88) {
894         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
895         return uint88(value);
896     }
897 
898     /**
899      * @dev Returns the downcasted uint80 from uint256, reverting on
900      * overflow (when the input is greater than largest uint80).
901      *
902      * Counterpart to Solidity's `uint80` operator.
903      *
904      * Requirements:
905      *
906      * - input must fit into 80 bits
907      *
908      * _Available since v4.7._
909      */
910     function toUint80(uint256 value) internal pure returns (uint80) {
911         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
912         return uint80(value);
913     }
914 
915     /**
916      * @dev Returns the downcasted uint72 from uint256, reverting on
917      * overflow (when the input is greater than largest uint72).
918      *
919      * Counterpart to Solidity's `uint72` operator.
920      *
921      * Requirements:
922      *
923      * - input must fit into 72 bits
924      *
925      * _Available since v4.7._
926      */
927     function toUint72(uint256 value) internal pure returns (uint72) {
928         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
929         return uint72(value);
930     }
931 
932     /**
933      * @dev Returns the downcasted uint64 from uint256, reverting on
934      * overflow (when the input is greater than largest uint64).
935      *
936      * Counterpart to Solidity's `uint64` operator.
937      *
938      * Requirements:
939      *
940      * - input must fit into 64 bits
941      *
942      * _Available since v2.5._
943      */
944     function toUint64(uint256 value) internal pure returns (uint64) {
945         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
946         return uint64(value);
947     }
948 
949     /**
950      * @dev Returns the downcasted uint56 from uint256, reverting on
951      * overflow (when the input is greater than largest uint56).
952      *
953      * Counterpart to Solidity's `uint56` operator.
954      *
955      * Requirements:
956      *
957      * - input must fit into 56 bits
958      *
959      * _Available since v4.7._
960      */
961     function toUint56(uint256 value) internal pure returns (uint56) {
962         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
963         return uint56(value);
964     }
965 
966     /**
967      * @dev Returns the downcasted uint48 from uint256, reverting on
968      * overflow (when the input is greater than largest uint48).
969      *
970      * Counterpart to Solidity's `uint48` operator.
971      *
972      * Requirements:
973      *
974      * - input must fit into 48 bits
975      *
976      * _Available since v4.7._
977      */
978     function toUint48(uint256 value) internal pure returns (uint48) {
979         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
980         return uint48(value);
981     }
982 
983     /**
984      * @dev Returns the downcasted uint40 from uint256, reverting on
985      * overflow (when the input is greater than largest uint40).
986      *
987      * Counterpart to Solidity's `uint40` operator.
988      *
989      * Requirements:
990      *
991      * - input must fit into 40 bits
992      *
993      * _Available since v4.7._
994      */
995     function toUint40(uint256 value) internal pure returns (uint40) {
996         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
997         return uint40(value);
998     }
999 
1000     /**
1001      * @dev Returns the downcasted uint32 from uint256, reverting on
1002      * overflow (when the input is greater than largest uint32).
1003      *
1004      * Counterpart to Solidity's `uint32` operator.
1005      *
1006      * Requirements:
1007      *
1008      * - input must fit into 32 bits
1009      *
1010      * _Available since v2.5._
1011      */
1012     function toUint32(uint256 value) internal pure returns (uint32) {
1013         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1014         return uint32(value);
1015     }
1016 
1017     /**
1018      * @dev Returns the downcasted uint24 from uint256, reverting on
1019      * overflow (when the input is greater than largest uint24).
1020      *
1021      * Counterpart to Solidity's `uint24` operator.
1022      *
1023      * Requirements:
1024      *
1025      * - input must fit into 24 bits
1026      *
1027      * _Available since v4.7._
1028      */
1029     function toUint24(uint256 value) internal pure returns (uint24) {
1030         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
1031         return uint24(value);
1032     }
1033 
1034     /**
1035      * @dev Returns the downcasted uint16 from uint256, reverting on
1036      * overflow (when the input is greater than largest uint16).
1037      *
1038      * Counterpart to Solidity's `uint16` operator.
1039      *
1040      * Requirements:
1041      *
1042      * - input must fit into 16 bits
1043      *
1044      * _Available since v2.5._
1045      */
1046     function toUint16(uint256 value) internal pure returns (uint16) {
1047         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1048         return uint16(value);
1049     }
1050 
1051     /**
1052      * @dev Returns the downcasted uint8 from uint256, reverting on
1053      * overflow (when the input is greater than largest uint8).
1054      *
1055      * Counterpart to Solidity's `uint8` operator.
1056      *
1057      * Requirements:
1058      *
1059      * - input must fit into 8 bits
1060      *
1061      * _Available since v2.5._
1062      */
1063     function toUint8(uint256 value) internal pure returns (uint8) {
1064         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1065         return uint8(value);
1066     }
1067 
1068     /**
1069      * @dev Converts a signed int256 into an unsigned uint256.
1070      *
1071      * Requirements:
1072      *
1073      * - input must be greater than or equal to 0.
1074      *
1075      * _Available since v3.0._
1076      */
1077     function toUint256(int256 value) internal pure returns (uint256) {
1078         require(value >= 0, "SafeCast: value must be positive");
1079         return uint256(value);
1080     }
1081 
1082     /**
1083      * @dev Returns the downcasted int248 from int256, reverting on
1084      * overflow (when the input is less than smallest int248 or
1085      * greater than largest int248).
1086      *
1087      * Counterpart to Solidity's `int248` operator.
1088      *
1089      * Requirements:
1090      *
1091      * - input must fit into 248 bits
1092      *
1093      * _Available since v4.7._
1094      */
1095     function toInt248(int256 value) internal pure returns (int248 downcasted) {
1096         downcasted = int248(value);
1097         require(downcasted == value, "SafeCast: value doesn't fit in 248 bits");
1098     }
1099 
1100     /**
1101      * @dev Returns the downcasted int240 from int256, reverting on
1102      * overflow (when the input is less than smallest int240 or
1103      * greater than largest int240).
1104      *
1105      * Counterpart to Solidity's `int240` operator.
1106      *
1107      * Requirements:
1108      *
1109      * - input must fit into 240 bits
1110      *
1111      * _Available since v4.7._
1112      */
1113     function toInt240(int256 value) internal pure returns (int240 downcasted) {
1114         downcasted = int240(value);
1115         require(downcasted == value, "SafeCast: value doesn't fit in 240 bits");
1116     }
1117 
1118     /**
1119      * @dev Returns the downcasted int232 from int256, reverting on
1120      * overflow (when the input is less than smallest int232 or
1121      * greater than largest int232).
1122      *
1123      * Counterpart to Solidity's `int232` operator.
1124      *
1125      * Requirements:
1126      *
1127      * - input must fit into 232 bits
1128      *
1129      * _Available since v4.7._
1130      */
1131     function toInt232(int256 value) internal pure returns (int232 downcasted) {
1132         downcasted = int232(value);
1133         require(downcasted == value, "SafeCast: value doesn't fit in 232 bits");
1134     }
1135 
1136     /**
1137      * @dev Returns the downcasted int224 from int256, reverting on
1138      * overflow (when the input is less than smallest int224 or
1139      * greater than largest int224).
1140      *
1141      * Counterpart to Solidity's `int224` operator.
1142      *
1143      * Requirements:
1144      *
1145      * - input must fit into 224 bits
1146      *
1147      * _Available since v4.7._
1148      */
1149     function toInt224(int256 value) internal pure returns (int224 downcasted) {
1150         downcasted = int224(value);
1151         require(downcasted == value, "SafeCast: value doesn't fit in 224 bits");
1152     }
1153 
1154     /**
1155      * @dev Returns the downcasted int216 from int256, reverting on
1156      * overflow (when the input is less than smallest int216 or
1157      * greater than largest int216).
1158      *
1159      * Counterpart to Solidity's `int216` operator.
1160      *
1161      * Requirements:
1162      *
1163      * - input must fit into 216 bits
1164      *
1165      * _Available since v4.7._
1166      */
1167     function toInt216(int256 value) internal pure returns (int216 downcasted) {
1168         downcasted = int216(value);
1169         require(downcasted == value, "SafeCast: value doesn't fit in 216 bits");
1170     }
1171 
1172     /**
1173      * @dev Returns the downcasted int208 from int256, reverting on
1174      * overflow (when the input is less than smallest int208 or
1175      * greater than largest int208).
1176      *
1177      * Counterpart to Solidity's `int208` operator.
1178      *
1179      * Requirements:
1180      *
1181      * - input must fit into 208 bits
1182      *
1183      * _Available since v4.7._
1184      */
1185     function toInt208(int256 value) internal pure returns (int208 downcasted) {
1186         downcasted = int208(value);
1187         require(downcasted == value, "SafeCast: value doesn't fit in 208 bits");
1188     }
1189 
1190     /**
1191      * @dev Returns the downcasted int200 from int256, reverting on
1192      * overflow (when the input is less than smallest int200 or
1193      * greater than largest int200).
1194      *
1195      * Counterpart to Solidity's `int200` operator.
1196      *
1197      * Requirements:
1198      *
1199      * - input must fit into 200 bits
1200      *
1201      * _Available since v4.7._
1202      */
1203     function toInt200(int256 value) internal pure returns (int200 downcasted) {
1204         downcasted = int200(value);
1205         require(downcasted == value, "SafeCast: value doesn't fit in 200 bits");
1206     }
1207 
1208     /**
1209      * @dev Returns the downcasted int192 from int256, reverting on
1210      * overflow (when the input is less than smallest int192 or
1211      * greater than largest int192).
1212      *
1213      * Counterpart to Solidity's `int192` operator.
1214      *
1215      * Requirements:
1216      *
1217      * - input must fit into 192 bits
1218      *
1219      * _Available since v4.7._
1220      */
1221     function toInt192(int256 value) internal pure returns (int192 downcasted) {
1222         downcasted = int192(value);
1223         require(downcasted == value, "SafeCast: value doesn't fit in 192 bits");
1224     }
1225 
1226     /**
1227      * @dev Returns the downcasted int184 from int256, reverting on
1228      * overflow (when the input is less than smallest int184 or
1229      * greater than largest int184).
1230      *
1231      * Counterpart to Solidity's `int184` operator.
1232      *
1233      * Requirements:
1234      *
1235      * - input must fit into 184 bits
1236      *
1237      * _Available since v4.7._
1238      */
1239     function toInt184(int256 value) internal pure returns (int184 downcasted) {
1240         downcasted = int184(value);
1241         require(downcasted == value, "SafeCast: value doesn't fit in 184 bits");
1242     }
1243 
1244     /**
1245      * @dev Returns the downcasted int176 from int256, reverting on
1246      * overflow (when the input is less than smallest int176 or
1247      * greater than largest int176).
1248      *
1249      * Counterpart to Solidity's `int176` operator.
1250      *
1251      * Requirements:
1252      *
1253      * - input must fit into 176 bits
1254      *
1255      * _Available since v4.7._
1256      */
1257     function toInt176(int256 value) internal pure returns (int176 downcasted) {
1258         downcasted = int176(value);
1259         require(downcasted == value, "SafeCast: value doesn't fit in 176 bits");
1260     }
1261 
1262     /**
1263      * @dev Returns the downcasted int168 from int256, reverting on
1264      * overflow (when the input is less than smallest int168 or
1265      * greater than largest int168).
1266      *
1267      * Counterpart to Solidity's `int168` operator.
1268      *
1269      * Requirements:
1270      *
1271      * - input must fit into 168 bits
1272      *
1273      * _Available since v4.7._
1274      */
1275     function toInt168(int256 value) internal pure returns (int168 downcasted) {
1276         downcasted = int168(value);
1277         require(downcasted == value, "SafeCast: value doesn't fit in 168 bits");
1278     }
1279 
1280     /**
1281      * @dev Returns the downcasted int160 from int256, reverting on
1282      * overflow (when the input is less than smallest int160 or
1283      * greater than largest int160).
1284      *
1285      * Counterpart to Solidity's `int160` operator.
1286      *
1287      * Requirements:
1288      *
1289      * - input must fit into 160 bits
1290      *
1291      * _Available since v4.7._
1292      */
1293     function toInt160(int256 value) internal pure returns (int160 downcasted) {
1294         downcasted = int160(value);
1295         require(downcasted == value, "SafeCast: value doesn't fit in 160 bits");
1296     }
1297 
1298     /**
1299      * @dev Returns the downcasted int152 from int256, reverting on
1300      * overflow (when the input is less than smallest int152 or
1301      * greater than largest int152).
1302      *
1303      * Counterpart to Solidity's `int152` operator.
1304      *
1305      * Requirements:
1306      *
1307      * - input must fit into 152 bits
1308      *
1309      * _Available since v4.7._
1310      */
1311     function toInt152(int256 value) internal pure returns (int152 downcasted) {
1312         downcasted = int152(value);
1313         require(downcasted == value, "SafeCast: value doesn't fit in 152 bits");
1314     }
1315 
1316     /**
1317      * @dev Returns the downcasted int144 from int256, reverting on
1318      * overflow (when the input is less than smallest int144 or
1319      * greater than largest int144).
1320      *
1321      * Counterpart to Solidity's `int144` operator.
1322      *
1323      * Requirements:
1324      *
1325      * - input must fit into 144 bits
1326      *
1327      * _Available since v4.7._
1328      */
1329     function toInt144(int256 value) internal pure returns (int144 downcasted) {
1330         downcasted = int144(value);
1331         require(downcasted == value, "SafeCast: value doesn't fit in 144 bits");
1332     }
1333 
1334     /**
1335      * @dev Returns the downcasted int136 from int256, reverting on
1336      * overflow (when the input is less than smallest int136 or
1337      * greater than largest int136).
1338      *
1339      * Counterpart to Solidity's `int136` operator.
1340      *
1341      * Requirements:
1342      *
1343      * - input must fit into 136 bits
1344      *
1345      * _Available since v4.7._
1346      */
1347     function toInt136(int256 value) internal pure returns (int136 downcasted) {
1348         downcasted = int136(value);
1349         require(downcasted == value, "SafeCast: value doesn't fit in 136 bits");
1350     }
1351 
1352     /**
1353      * @dev Returns the downcasted int128 from int256, reverting on
1354      * overflow (when the input is less than smallest int128 or
1355      * greater than largest int128).
1356      *
1357      * Counterpart to Solidity's `int128` operator.
1358      *
1359      * Requirements:
1360      *
1361      * - input must fit into 128 bits
1362      *
1363      * _Available since v3.1._
1364      */
1365     function toInt128(int256 value) internal pure returns (int128 downcasted) {
1366         downcasted = int128(value);
1367         require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
1368     }
1369 
1370     /**
1371      * @dev Returns the downcasted int120 from int256, reverting on
1372      * overflow (when the input is less than smallest int120 or
1373      * greater than largest int120).
1374      *
1375      * Counterpart to Solidity's `int120` operator.
1376      *
1377      * Requirements:
1378      *
1379      * - input must fit into 120 bits
1380      *
1381      * _Available since v4.7._
1382      */
1383     function toInt120(int256 value) internal pure returns (int120 downcasted) {
1384         downcasted = int120(value);
1385         require(downcasted == value, "SafeCast: value doesn't fit in 120 bits");
1386     }
1387 
1388     /**
1389      * @dev Returns the downcasted int112 from int256, reverting on
1390      * overflow (when the input is less than smallest int112 or
1391      * greater than largest int112).
1392      *
1393      * Counterpart to Solidity's `int112` operator.
1394      *
1395      * Requirements:
1396      *
1397      * - input must fit into 112 bits
1398      *
1399      * _Available since v4.7._
1400      */
1401     function toInt112(int256 value) internal pure returns (int112 downcasted) {
1402         downcasted = int112(value);
1403         require(downcasted == value, "SafeCast: value doesn't fit in 112 bits");
1404     }
1405 
1406     /**
1407      * @dev Returns the downcasted int104 from int256, reverting on
1408      * overflow (when the input is less than smallest int104 or
1409      * greater than largest int104).
1410      *
1411      * Counterpart to Solidity's `int104` operator.
1412      *
1413      * Requirements:
1414      *
1415      * - input must fit into 104 bits
1416      *
1417      * _Available since v4.7._
1418      */
1419     function toInt104(int256 value) internal pure returns (int104 downcasted) {
1420         downcasted = int104(value);
1421         require(downcasted == value, "SafeCast: value doesn't fit in 104 bits");
1422     }
1423 
1424     /**
1425      * @dev Returns the downcasted int96 from int256, reverting on
1426      * overflow (when the input is less than smallest int96 or
1427      * greater than largest int96).
1428      *
1429      * Counterpart to Solidity's `int96` operator.
1430      *
1431      * Requirements:
1432      *
1433      * - input must fit into 96 bits
1434      *
1435      * _Available since v4.7._
1436      */
1437     function toInt96(int256 value) internal pure returns (int96 downcasted) {
1438         downcasted = int96(value);
1439         require(downcasted == value, "SafeCast: value doesn't fit in 96 bits");
1440     }
1441 
1442     /**
1443      * @dev Returns the downcasted int88 from int256, reverting on
1444      * overflow (when the input is less than smallest int88 or
1445      * greater than largest int88).
1446      *
1447      * Counterpart to Solidity's `int88` operator.
1448      *
1449      * Requirements:
1450      *
1451      * - input must fit into 88 bits
1452      *
1453      * _Available since v4.7._
1454      */
1455     function toInt88(int256 value) internal pure returns (int88 downcasted) {
1456         downcasted = int88(value);
1457         require(downcasted == value, "SafeCast: value doesn't fit in 88 bits");
1458     }
1459 
1460     /**
1461      * @dev Returns the downcasted int80 from int256, reverting on
1462      * overflow (when the input is less than smallest int80 or
1463      * greater than largest int80).
1464      *
1465      * Counterpart to Solidity's `int80` operator.
1466      *
1467      * Requirements:
1468      *
1469      * - input must fit into 80 bits
1470      *
1471      * _Available since v4.7._
1472      */
1473     function toInt80(int256 value) internal pure returns (int80 downcasted) {
1474         downcasted = int80(value);
1475         require(downcasted == value, "SafeCast: value doesn't fit in 80 bits");
1476     }
1477 
1478     /**
1479      * @dev Returns the downcasted int72 from int256, reverting on
1480      * overflow (when the input is less than smallest int72 or
1481      * greater than largest int72).
1482      *
1483      * Counterpart to Solidity's `int72` operator.
1484      *
1485      * Requirements:
1486      *
1487      * - input must fit into 72 bits
1488      *
1489      * _Available since v4.7._
1490      */
1491     function toInt72(int256 value) internal pure returns (int72 downcasted) {
1492         downcasted = int72(value);
1493         require(downcasted == value, "SafeCast: value doesn't fit in 72 bits");
1494     }
1495 
1496     /**
1497      * @dev Returns the downcasted int64 from int256, reverting on
1498      * overflow (when the input is less than smallest int64 or
1499      * greater than largest int64).
1500      *
1501      * Counterpart to Solidity's `int64` operator.
1502      *
1503      * Requirements:
1504      *
1505      * - input must fit into 64 bits
1506      *
1507      * _Available since v3.1._
1508      */
1509     function toInt64(int256 value) internal pure returns (int64 downcasted) {
1510         downcasted = int64(value);
1511         require(downcasted == value, "SafeCast: value doesn't fit in 64 bits");
1512     }
1513 
1514     /**
1515      * @dev Returns the downcasted int56 from int256, reverting on
1516      * overflow (when the input is less than smallest int56 or
1517      * greater than largest int56).
1518      *
1519      * Counterpart to Solidity's `int56` operator.
1520      *
1521      * Requirements:
1522      *
1523      * - input must fit into 56 bits
1524      *
1525      * _Available since v4.7._
1526      */
1527     function toInt56(int256 value) internal pure returns (int56 downcasted) {
1528         downcasted = int56(value);
1529         require(downcasted == value, "SafeCast: value doesn't fit in 56 bits");
1530     }
1531 
1532     /**
1533      * @dev Returns the downcasted int48 from int256, reverting on
1534      * overflow (when the input is less than smallest int48 or
1535      * greater than largest int48).
1536      *
1537      * Counterpart to Solidity's `int48` operator.
1538      *
1539      * Requirements:
1540      *
1541      * - input must fit into 48 bits
1542      *
1543      * _Available since v4.7._
1544      */
1545     function toInt48(int256 value) internal pure returns (int48 downcasted) {
1546         downcasted = int48(value);
1547         require(downcasted == value, "SafeCast: value doesn't fit in 48 bits");
1548     }
1549 
1550     /**
1551      * @dev Returns the downcasted int40 from int256, reverting on
1552      * overflow (when the input is less than smallest int40 or
1553      * greater than largest int40).
1554      *
1555      * Counterpart to Solidity's `int40` operator.
1556      *
1557      * Requirements:
1558      *
1559      * - input must fit into 40 bits
1560      *
1561      * _Available since v4.7._
1562      */
1563     function toInt40(int256 value) internal pure returns (int40 downcasted) {
1564         downcasted = int40(value);
1565         require(downcasted == value, "SafeCast: value doesn't fit in 40 bits");
1566     }
1567 
1568     /**
1569      * @dev Returns the downcasted int32 from int256, reverting on
1570      * overflow (when the input is less than smallest int32 or
1571      * greater than largest int32).
1572      *
1573      * Counterpart to Solidity's `int32` operator.
1574      *
1575      * Requirements:
1576      *
1577      * - input must fit into 32 bits
1578      *
1579      * _Available since v3.1._
1580      */
1581     function toInt32(int256 value) internal pure returns (int32 downcasted) {
1582         downcasted = int32(value);
1583         require(downcasted == value, "SafeCast: value doesn't fit in 32 bits");
1584     }
1585 
1586     /**
1587      * @dev Returns the downcasted int24 from int256, reverting on
1588      * overflow (when the input is less than smallest int24 or
1589      * greater than largest int24).
1590      *
1591      * Counterpart to Solidity's `int24` operator.
1592      *
1593      * Requirements:
1594      *
1595      * - input must fit into 24 bits
1596      *
1597      * _Available since v4.7._
1598      */
1599     function toInt24(int256 value) internal pure returns (int24 downcasted) {
1600         downcasted = int24(value);
1601         require(downcasted == value, "SafeCast: value doesn't fit in 24 bits");
1602     }
1603 
1604     /**
1605      * @dev Returns the downcasted int16 from int256, reverting on
1606      * overflow (when the input is less than smallest int16 or
1607      * greater than largest int16).
1608      *
1609      * Counterpart to Solidity's `int16` operator.
1610      *
1611      * Requirements:
1612      *
1613      * - input must fit into 16 bits
1614      *
1615      * _Available since v3.1._
1616      */
1617     function toInt16(int256 value) internal pure returns (int16 downcasted) {
1618         downcasted = int16(value);
1619         require(downcasted == value, "SafeCast: value doesn't fit in 16 bits");
1620     }
1621 
1622     /**
1623      * @dev Returns the downcasted int8 from int256, reverting on
1624      * overflow (when the input is less than smallest int8 or
1625      * greater than largest int8).
1626      *
1627      * Counterpart to Solidity's `int8` operator.
1628      *
1629      * Requirements:
1630      *
1631      * - input must fit into 8 bits
1632      *
1633      * _Available since v3.1._
1634      */
1635     function toInt8(int256 value) internal pure returns (int8 downcasted) {
1636         downcasted = int8(value);
1637         require(downcasted == value, "SafeCast: value doesn't fit in 8 bits");
1638     }
1639 
1640     /**
1641      * @dev Converts an unsigned uint256 into a signed int256.
1642      *
1643      * Requirements:
1644      *
1645      * - input must be less than or equal to maxInt256.
1646      *
1647      * _Available since v3.0._
1648      */
1649     function toInt256(uint256 value) internal pure returns (int256) {
1650         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1651         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1652         return int256(value);
1653     }
1654 }
1655 
1656 // File: src/airdrop/AirdropBase.sol
1657 
1658 
1659 pragma solidity 0.8.17;
1660 
1661 
1662 
1663 
1664 
1665 
1666 
1667 
1668 
1669 
1670 abstract contract AirdropBase is Context, Pausable, ReentrancyGuard, IporOwnable {
1671     using SafeCast for uint256;
1672 
1673     bytes32 internal constant _IPOR_TOKEN_ID =
1674         0xdba05ed67d0251facfcab8345f27ccd3e72b5a1da8cebfabbcccf4316e6d053c;
1675 
1676     event StakeholderAdded(address indexed account, uint256 amount);
1677     event TokenReleased(address indexed to, uint256 amount);
1678     event ConfirmedTermsOfUse(address indexed account, string declaration);
1679 
1680     address internal immutable _dao;
1681     address internal immutable _iporToken;
1682     mapping(address => AirdropTypes.State) internal _states;
1683     uint128 internal _totalReleased;
1684     uint128 internal _totalStakeholders;
1685 
1686     modifier onlyConfirmedTermsOfUse(string memory declaration) {
1687         require(
1688             keccak256(abi.encodePacked(declaration)) ==
1689                 keccak256(
1690                     abi.encodePacked(
1691                         "I confirm that I am in compliance with the Terms of Use located at https://www.ipor.io/terms-of-use."
1692                     )
1693                 ),
1694             IporAirdropErrors.ONLY_CONFIRMED_TERMS_OF_USE
1695         );
1696         _;
1697     }
1698 
1699     constructor(
1700         address dao,
1701         address iporToken,
1702         address[] memory stakeholders,
1703         uint256[] memory amounts
1704     ) {
1705         require(dao != address(0), IporAirdropErrors.WRONG_ADDRESS);
1706         require(iporToken != address(0), IporAirdropErrors.WRONG_ADDRESS);
1707         require(
1708             IIporToken(iporToken).getContractId() == _IPOR_TOKEN_ID,
1709             IporAirdropErrors.WRONG_CONTRACT_ID
1710         );
1711         uint256 stakeholdersLength = stakeholders.length;
1712         require(
1713             stakeholdersLength == amounts.length,
1714             IporAirdropErrors.INPUT_ARRAYS_LENGTH_MISMATCH
1715         );
1716         require(stakeholdersLength > 0, IporAirdropErrors.NO_STAKEHOLDERS);
1717 
1718         uint256 amount;
1719         address account;
1720 
1721         for (uint256 i; i < stakeholdersLength; ++i) {
1722             amount = amounts[i];
1723             account = stakeholders[i];
1724             require(account != address(0), IporAirdropErrors.WRONG_ADDRESS);
1725             require(amount > 0, IporAirdropErrors.NO_AIRDROPS);
1726             // TODO: check that account is not already a stakeholder
1727             _states[account] = AirdropTypes.State(amount.toUint128(), 0);
1728             emit StakeholderAdded(account, amount);
1729         }
1730         _totalStakeholders += stakeholdersLength.toUint128();
1731 
1732         _dao = dao;
1733         _iporToken = iporToken;
1734         _pause();
1735     }
1736 
1737     function getState(address account)
1738         external
1739         view
1740         returns (uint256 initialValue, uint256 released)
1741     {
1742         AirdropTypes.State memory state = _states[account];
1743         initialValue = state.initialValue;
1744         released = state.released;
1745     }
1746 
1747     function getTotalReleased() external view returns (uint256) {
1748         return _totalReleased;
1749     }
1750 
1751     function getTotalStakeholders() external view returns (uint256) {
1752         return _totalStakeholders;
1753     }
1754 
1755     function addStakeholders(address[] calldata stakeholders, uint256[] calldata amounts)
1756         external
1757         onlyOwner
1758     {
1759         uint256 stakeholdersLength = stakeholders.length;
1760         require(
1761             stakeholdersLength == amounts.length,
1762             IporAirdropErrors.INPUT_ARRAYS_LENGTH_MISMATCH
1763         );
1764         require(stakeholdersLength > 0, IporAirdropErrors.NO_STAKEHOLDERS);
1765         for (uint256 i; i < stakeholdersLength; ++i) {
1766             _addStakeholder(stakeholders[i], amounts[i]);
1767         }
1768         _totalStakeholders += stakeholdersLength.toUint128();
1769     }
1770 
1771     function pause() external onlyOwner {
1772         _pause();
1773     }
1774 
1775     function unpause() external onlyOwner {
1776         _unpause();
1777     }
1778 
1779     function withdrawAllToDao() external onlyOwner {
1780         IERC20(_iporToken).transfer(_dao, IERC20(_iporToken).balanceOf(address(this)));
1781     }
1782 
1783     function _addStakeholder(address account, uint256 amount) private {
1784         require(account != address(0), IporAirdropErrors.WRONG_ADDRESS);
1785         require(amount > 0, IporAirdropErrors.NO_AIRDROPS);
1786         require(_states[account].initialValue == 0, IporAirdropErrors.AIRDROP_ALREADY_EXISTS);
1787 
1788         _states[account] = AirdropTypes.State(amount.toUint128(), 0);
1789         emit StakeholderAdded(account, amount);
1790     }
1791 }
1792 
1793 // File: src/airdrop/VestingAirdrop.sol
1794 
1795 
1796 pragma solidity 0.8.17;
1797 
1798 
1799 
1800 
1801 
1802 
1803 contract VestingAirdrop is AirdropBase {
1804     using SafeCast for uint256;
1805 
1806     uint64 private immutable _start;
1807     uint64 private immutable _duration;
1808 
1809     /**
1810      * @dev Set the beneficiaries, start timestamp and vesting duration of the vesting wallet.
1811      */
1812     constructor(
1813         address dao,
1814         address iporToken,
1815         uint64 startTimestamp,
1816         uint64 durationSeconds,
1817         address[] memory stakeholders,
1818         uint256[] memory amounts
1819     ) AirdropBase(dao, iporToken, stakeholders, amounts) {
1820         require(
1821             startTimestamp > block.timestamp,
1822             IporAirdropErrors.VESTING_START_TIME_SHOULD_BE_HIGHER_THAN_BLOCK_TIMESTAMP
1823         );
1824         require(durationSeconds > 0, IporAirdropErrors.VESTING_DURATION_SHOULD_BE_HIGHER_THAN_ZERO);
1825         _start = startTimestamp;
1826         _duration = durationSeconds;
1827     }
1828 
1829     function getStart() external view virtual returns (uint256) {
1830         return _start;
1831     }
1832 
1833     function getDuration() external view virtual returns (uint256) {
1834         return _duration;
1835     }
1836 
1837     function getVestedAmount(address account, uint64 timestamp)
1838         external
1839         view
1840         virtual
1841         returns (uint256)
1842     {
1843         return _calculateVestingAmount(_states[account].initialValue, timestamp);
1844     }
1845 
1846     function releasable(address account) public view virtual returns (uint256) {
1847         return _releasable(_states[account]);
1848     }
1849 
1850     function release(string calldata declaration)
1851         external
1852         whenNotPaused
1853         nonReentrant
1854         onlyConfirmedTermsOfUse(declaration)
1855     {
1856         address msgSender = _msgSender();
1857 
1858         AirdropTypes.State memory state = _states[msgSender];
1859 
1860         require(state.initialValue > 0, IporAirdropErrors.NO_AIRDROPS);
1861         require(state.initialValue - state.released > 0, IporAirdropErrors.ALREADY_RELEASED);
1862 
1863         uint256 amount = _releasable(state);
1864 
1865         require(
1866             state.initialValue >= state.released + amount,
1867             IporAirdropErrors.AMOUNT_HIGHER_THAN_INITIAL_VALUE
1868         );
1869 
1870         state.released += amount.toUint128();
1871 
1872         _states[msgSender] = state;
1873 
1874         _totalReleased += amount.toUint128();
1875 
1876         IERC20(_iporToken).transfer(msgSender, amount);
1877 
1878         emit ConfirmedTermsOfUse(msgSender, declaration);
1879         emit TokenReleased(msgSender, amount);
1880     }
1881 
1882     function _releasable(AirdropTypes.State memory state) internal view returns (uint256) {
1883         return
1884             _calculateVestingAmount(state.initialValue, uint64(block.timestamp)) - state.released;
1885     }
1886 
1887     function _calculateVestingAmount(uint256 initialValue, uint64 timestamp)
1888         internal
1889         view
1890         virtual
1891         returns (uint256)
1892     {
1893         if (timestamp < _start) {
1894             return 0;
1895         }
1896 
1897         if (timestamp > _start + _duration) {
1898             return initialValue;
1899         }
1900 
1901         return (initialValue * (timestamp - _start)) / _duration;
1902     }
1903 }