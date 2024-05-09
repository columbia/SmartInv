1 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b)
26         internal
27         pure
28         returns (bool, uint256)
29     {
30         uint256 c = a + b;
31         if (c < a) return (false, 0);
32         return (true, c);
33     }
34 
35     /**
36      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
37      *
38      * _Available since v3.4._
39      */
40     function trySub(uint256 a, uint256 b)
41         internal
42         pure
43         returns (bool, uint256)
44     {
45         if (b > a) return (false, 0);
46         return (true, a - b);
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryMul(uint256 a, uint256 b)
55         internal
56         pure
57         returns (bool, uint256)
58     {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62         if (a == 0) return (true, 0);
63         uint256 c = a * b;
64         if (c / a != b) return (false, 0);
65         return (true, c);
66     }
67 
68     /**
69      * @dev Returns the division of two unsigned integers, with a division by zero flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryDiv(uint256 a, uint256 b)
74         internal
75         pure
76         returns (bool, uint256)
77     {
78         if (b == 0) return (false, 0);
79         return (true, a / b);
80     }
81 
82     /**
83      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryMod(uint256 a, uint256 b)
88         internal
89         pure
90         returns (bool, uint256)
91     {
92         if (b == 0) return (false, 0);
93         return (true, a % b);
94     }
95 
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      *
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         require(b <= a, "SafeMath: subtraction overflow");
124         return a - b;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      *
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         if (a == 0) return 0;
139         uint256 c = a * b;
140         require(c / a == b, "SafeMath: multiplication overflow");
141         return c;
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers, reverting on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0, "SafeMath: division by zero");
158         return a / b;
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * reverting when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         require(b > 0, "SafeMath: modulo by zero");
175         return a % b;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
180      * overflow (when the result is negative).
181      *
182      * CAUTION: This function is deprecated because it requires allocating memory for the error
183      * message unnecessarily. For custom revert reasons use {trySub}.
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         require(b <= a, errorMessage);
197         return a - b;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * CAUTION: This function is deprecated because it requires allocating memory for the error
205      * message unnecessarily. For custom revert reasons use {tryDiv}.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(
216         uint256 a,
217         uint256 b,
218         string memory errorMessage
219     ) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         return a / b;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * reverting with custom message when dividing by zero.
227      *
228      * CAUTION: This function is deprecated because it requires allocating memory for the error
229      * message unnecessarily. For custom revert reasons use {tryMod}.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(
240         uint256 a,
241         uint256 b,
242         string memory errorMessage
243     ) internal pure returns (uint256) {
244         require(b > 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v3.4.2
250 
251 pragma solidity >=0.6.2 <0.8.0;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library AddressUpgradeable {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize, which returns 0 for contracts in
276         // construction, since the code is only stored at the end of the
277         // constructor execution.
278 
279         uint256 size;
280         // solhint-disable-next-line no-inline-assembly
281         assembly {
282             size := extcodesize(account)
283         }
284         return size > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(
305             address(this).balance >= amount,
306             "Address: insufficient balance"
307         );
308 
309         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
310         (bool success, ) = recipient.call{value: amount}("");
311         require(
312             success,
313             "Address: unable to send value, recipient may have reverted"
314         );
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data)
336         internal
337         returns (bytes memory)
338     {
339         return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value
371     ) internal returns (bytes memory) {
372         return
373             functionCallWithValue(
374                 target,
375                 data,
376                 value,
377                 "Address: low-level call with value failed"
378             );
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(
394             address(this).balance >= value,
395             "Address: insufficient balance for call"
396         );
397         require(isContract(target), "Address: call to non-contract");
398 
399         // solhint-disable-next-line avoid-low-level-calls
400         (bool success, bytes memory returndata) = target.call{value: value}(
401             data
402         );
403         return _verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(address target, bytes memory data)
413         internal
414         view
415         returns (bytes memory)
416     {
417         return
418             functionStaticCall(
419                 target,
420                 data,
421                 "Address: low-level static call failed"
422             );
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal view returns (bytes memory) {
436         require(isContract(target), "Address: static call to non-contract");
437 
438         // solhint-disable-next-line avoid-low-level-calls
439         (bool success, bytes memory returndata) = target.staticcall(data);
440         return _verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     function _verifyCallResult(
444         bool success,
445         bytes memory returndata,
446         string memory errorMessage
447     ) private pure returns (bytes memory) {
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 // solhint-disable-next-line no-inline-assembly
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // File @openzeppelin/contracts-upgradeable/proxy/Initializable.sol@v3.4.2
468 
469 // solhint-disable-next-line compiler-version
470 pragma solidity >=0.4.24 <0.8.0;
471 
472 /**
473  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
474  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
475  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
476  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
477  *
478  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
479  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
480  *
481  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
482  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
483  */
484 abstract contract Initializable {
485     /**
486      * @dev Indicates that the contract has been initialized.
487      */
488     bool private _initialized;
489 
490     /**
491      * @dev Indicates that the contract is in the process of being initialized.
492      */
493     bool private _initializing;
494 
495     /**
496      * @dev Modifier to protect an initializer function from being invoked twice.
497      */
498     modifier initializer() {
499         require(
500             _initializing || _isConstructor() || !_initialized,
501             "Initializable: contract is already initialized"
502         );
503 
504         bool isTopLevelCall = !_initializing;
505         if (isTopLevelCall) {
506             _initializing = true;
507             _initialized = true;
508         }
509 
510         _;
511 
512         if (isTopLevelCall) {
513             _initializing = false;
514         }
515     }
516 
517     /// @dev Returns true if and only if the function is running in the constructor
518     function _isConstructor() private view returns (bool) {
519         return !AddressUpgradeable.isContract(address(this));
520     }
521 }
522 
523 // File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v3.4.2
524 
525 pragma solidity >=0.6.0 <0.8.0;
526 
527 /*
528  * @dev Provides information about the current execution context, including the
529  * sender of the transaction and its data. While these are generally available
530  * via msg.sender and msg.data, they should not be accessed in such a direct
531  * manner, since when dealing with GSN meta-transactions the account sending and
532  * paying for execution may not be the actual sender (as far as an application
533  * is concerned).
534  *
535  * This contract is only required for intermediate, library-like contracts.
536  */
537 abstract contract ContextUpgradeable is Initializable {
538     function __Context_init() internal initializer {
539         __Context_init_unchained();
540     }
541 
542     function __Context_init_unchained() internal initializer {}
543 
544     function _msgSender() internal view virtual returns (address payable) {
545         return msg.sender;
546     }
547 
548     function _msgData() internal view virtual returns (bytes memory) {
549         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
550         return msg.data;
551     }
552 
553     uint256[50] private __gap;
554 }
555 
556 // File @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol@v3.4.2
557 
558 pragma solidity >=0.6.0 <0.8.0;
559 
560 /**
561  * @dev Contract module which provides a basic access control mechanism, where
562  * there is an account (an owner) that can be granted exclusive access to
563  * specific functions.
564  *
565  * By default, the owner account will be the one that deploys the contract. This
566  * can later be changed with {transferOwnership}.
567  *
568  * This module is used through inheritance. It will make available the modifier
569  * `onlyOwner`, which can be applied to your functions to restrict their use to
570  * the owner.
571  */
572 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
573     address private _owner;
574 
575     event OwnershipTransferred(
576         address indexed previousOwner,
577         address indexed newOwner
578     );
579 
580     /**
581      * @dev Initializes the contract setting the deployer as the initial owner.
582      */
583     function __Ownable_init() internal initializer {
584         __Context_init_unchained();
585         __Ownable_init_unchained();
586     }
587 
588     function __Ownable_init_unchained() internal initializer {
589         address msgSender = _msgSender();
590         _owner = msgSender;
591         emit OwnershipTransferred(address(0), msgSender);
592     }
593 
594     /**
595      * @dev Returns the address of the current owner.
596      */
597     function owner() public view virtual returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if called by any account other than the owner.
603      */
604     modifier onlyOwner() {
605         require(owner() == _msgSender(), "Ownable: caller is not the owner");
606         _;
607     }
608 
609     /**
610      * @dev Leaves the contract without owner. It will not be possible to call
611      * `onlyOwner` functions anymore. Can only be called by the current owner.
612      *
613      * NOTE: Renouncing ownership will leave the contract without an owner,
614      * thereby removing any functionality that is only available to the owner.
615      */
616     function renounceOwnership() public virtual onlyOwner {
617         emit OwnershipTransferred(_owner, address(0));
618         _owner = address(0);
619     }
620 
621     /**
622      * @dev Transfers ownership of the contract to a new account (`newOwner`).
623      * Can only be called by the current owner.
624      */
625     function transferOwnership(address newOwner) public virtual onlyOwner {
626         require(
627             newOwner != address(0),
628             "Ownable: new owner is the zero address"
629         );
630         emit OwnershipTransferred(_owner, newOwner);
631         _owner = newOwner;
632     }
633 
634     uint256[49] private __gap;
635 }
636 
637 // File @openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol@v3.4.2
638 
639 pragma solidity >=0.6.0 <0.8.0;
640 
641 /**
642  * @dev Contract module that helps prevent reentrant calls to a function.
643  *
644  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
645  * available, which can be applied to functions to make sure there are no nested
646  * (reentrant) calls to them.
647  *
648  * Note that because there is a single `nonReentrant` guard, functions marked as
649  * `nonReentrant` may not call one another. This can be worked around by making
650  * those functions `private`, and then adding `external` `nonReentrant` entry
651  * points to them.
652  *
653  * TIP: If you would like to learn more about reentrancy and alternative ways
654  * to protect against it, check out our blog post
655  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
656  */
657 abstract contract ReentrancyGuardUpgradeable is Initializable {
658     // Booleans are more expensive than uint256 or any type that takes up a full
659     // word because each write operation emits an extra SLOAD to first read the
660     // slot's contents, replace the bits taken up by the boolean, and then write
661     // back. This is the compiler's defense against contract upgrades and
662     // pointer aliasing, and it cannot be disabled.
663 
664     // The values being non-zero value makes deployment a bit more expensive,
665     // but in exchange the refund on every call to nonReentrant will be lower in
666     // amount. Since refunds are capped to a percentage of the total
667     // transaction's gas, it is best to keep them low in cases like this one, to
668     // increase the likelihood of the full refund coming into effect.
669     uint256 private constant _NOT_ENTERED = 1;
670     uint256 private constant _ENTERED = 2;
671 
672     uint256 private _status;
673 
674     function __ReentrancyGuard_init() internal initializer {
675         __ReentrancyGuard_init_unchained();
676     }
677 
678     function __ReentrancyGuard_init_unchained() internal initializer {
679         _status = _NOT_ENTERED;
680     }
681 
682     /**
683      * @dev Prevents a contract from calling itself, directly or indirectly.
684      * Calling a `nonReentrant` function from another `nonReentrant`
685      * function is not supported. It is possible to prevent this from happening
686      * by making the `nonReentrant` function external, and make it call a
687      * `private` function that does the actual work.
688      */
689     modifier nonReentrant() {
690         // On the first call to nonReentrant, _notEntered will be true
691         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
692 
693         // Any calls to nonReentrant after this point will fail
694         _status = _ENTERED;
695 
696         _;
697 
698         // By storing the original value once again, a refund is triggered (see
699         // https://eips.ethereum.org/EIPS/eip-2200)
700         _status = _NOT_ENTERED;
701     }
702     uint256[49] private __gap;
703 }
704 
705 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2
706 
707 pragma solidity >=0.6.0 <0.8.0;
708 
709 /**
710  * @dev Interface of the ERC20 standard as defined in the EIP.
711  */
712 interface IERC20 {
713     /**
714      * @dev Returns the amount of tokens in existence.
715      */
716     function totalSupply() external view returns (uint256);
717 
718     /**
719      * @dev Returns the amount of tokens owned by `account`.
720      */
721     function balanceOf(address account) external view returns (uint256);
722 
723     /**
724      * @dev Moves `amount` tokens from the caller's account to `recipient`.
725      *
726      * Returns a boolean value indicating whether the operation succeeded.
727      *
728      * Emits a {Transfer} event.
729      */
730     function transfer(address recipient, uint256 amount)
731         external
732         returns (bool);
733 
734     /**
735      * @dev Returns the remaining number of tokens that `spender` will be
736      * allowed to spend on behalf of `owner` through {transferFrom}. This is
737      * zero by default.
738      *
739      * This value changes when {approve} or {transferFrom} are called.
740      */
741     function allowance(address owner, address spender)
742         external
743         view
744         returns (uint256);
745 
746     /**
747      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
748      *
749      * Returns a boolean value indicating whether the operation succeeded.
750      *
751      * IMPORTANT: Beware that changing an allowance with this method brings the risk
752      * that someone may use both the old and the new allowance by unfortunate
753      * transaction ordering. One possible solution to mitigate this race
754      * condition is to first reduce the spender's allowance to 0 and set the
755      * desired value afterwards:
756      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
757      *
758      * Emits an {Approval} event.
759      */
760     function approve(address spender, uint256 amount) external returns (bool);
761 
762     /**
763      * @dev Moves `amount` tokens from `sender` to `recipient` using the
764      * allowance mechanism. `amount` is then deducted from the caller's
765      * allowance.
766      *
767      * Returns a boolean value indicating whether the operation succeeded.
768      *
769      * Emits a {Transfer} event.
770      */
771     function transferFrom(
772         address sender,
773         address recipient,
774         uint256 amount
775     ) external returns (bool);
776 
777     /**
778      * @dev Emitted when `value` tokens are moved from one account (`from`) to
779      * another (`to`).
780      *
781      * Note that `value` may be zero.
782      */
783     event Transfer(address indexed from, address indexed to, uint256 value);
784 
785     /**
786      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
787      * a call to {approve}. `value` is the new allowance.
788      */
789     event Approval(
790         address indexed owner,
791         address indexed spender,
792         uint256 value
793     );
794 }
795 
796 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2
797 
798 pragma solidity >=0.6.2 <0.8.0;
799 
800 /**
801  * @dev Collection of functions related to the address type
802  */
803 library Address {
804     /**
805      * @dev Returns true if `account` is a contract.
806      *
807      * [IMPORTANT]
808      * ====
809      * It is unsafe to assume that an address for which this function returns
810      * false is an externally-owned account (EOA) and not a contract.
811      *
812      * Among others, `isContract` will return false for the following
813      * types of addresses:
814      *
815      *  - an externally-owned account
816      *  - a contract in construction
817      *  - an address where a contract will be created
818      *  - an address where a contract lived, but was destroyed
819      * ====
820      */
821     function isContract(address account) internal view returns (bool) {
822         // This method relies on extcodesize, which returns 0 for contracts in
823         // construction, since the code is only stored at the end of the
824         // constructor execution.
825 
826         uint256 size;
827         // solhint-disable-next-line no-inline-assembly
828         assembly {
829             size := extcodesize(account)
830         }
831         return size > 0;
832     }
833 
834     /**
835      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
836      * `recipient`, forwarding all available gas and reverting on errors.
837      *
838      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
839      * of certain opcodes, possibly making contracts go over the 2300 gas limit
840      * imposed by `transfer`, making them unable to receive funds via
841      * `transfer`. {sendValue} removes this limitation.
842      *
843      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
844      *
845      * IMPORTANT: because control is transferred to `recipient`, care must be
846      * taken to not create reentrancy vulnerabilities. Consider using
847      * {ReentrancyGuard} or the
848      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
849      */
850     function sendValue(address payable recipient, uint256 amount) internal {
851         require(
852             address(this).balance >= amount,
853             "Address: insufficient balance"
854         );
855 
856         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
857         (bool success, ) = recipient.call{value: amount}("");
858         require(
859             success,
860             "Address: unable to send value, recipient may have reverted"
861         );
862     }
863 
864     /**
865      * @dev Performs a Solidity function call using a low level `call`. A
866      * plain`call` is an unsafe replacement for a function call: use this
867      * function instead.
868      *
869      * If `target` reverts with a revert reason, it is bubbled up by this
870      * function (like regular Solidity function calls).
871      *
872      * Returns the raw returned data. To convert to the expected return value,
873      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
874      *
875      * Requirements:
876      *
877      * - `target` must be a contract.
878      * - calling `target` with `data` must not revert.
879      *
880      * _Available since v3.1._
881      */
882     function functionCall(address target, bytes memory data)
883         internal
884         returns (bytes memory)
885     {
886         return functionCall(target, data, "Address: low-level call failed");
887     }
888 
889     /**
890      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
891      * `errorMessage` as a fallback revert reason when `target` reverts.
892      *
893      * _Available since v3.1._
894      */
895     function functionCall(
896         address target,
897         bytes memory data,
898         string memory errorMessage
899     ) internal returns (bytes memory) {
900         return functionCallWithValue(target, data, 0, errorMessage);
901     }
902 
903     /**
904      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
905      * but also transferring `value` wei to `target`.
906      *
907      * Requirements:
908      *
909      * - the calling contract must have an ETH balance of at least `value`.
910      * - the called Solidity function must be `payable`.
911      *
912      * _Available since v3.1._
913      */
914     function functionCallWithValue(
915         address target,
916         bytes memory data,
917         uint256 value
918     ) internal returns (bytes memory) {
919         return
920             functionCallWithValue(
921                 target,
922                 data,
923                 value,
924                 "Address: low-level call with value failed"
925             );
926     }
927 
928     /**
929      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
930      * with `errorMessage` as a fallback revert reason when `target` reverts.
931      *
932      * _Available since v3.1._
933      */
934     function functionCallWithValue(
935         address target,
936         bytes memory data,
937         uint256 value,
938         string memory errorMessage
939     ) internal returns (bytes memory) {
940         require(
941             address(this).balance >= value,
942             "Address: insufficient balance for call"
943         );
944         require(isContract(target), "Address: call to non-contract");
945 
946         // solhint-disable-next-line avoid-low-level-calls
947         (bool success, bytes memory returndata) = target.call{value: value}(
948             data
949         );
950         return _verifyCallResult(success, returndata, errorMessage);
951     }
952 
953     /**
954      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
955      * but performing a static call.
956      *
957      * _Available since v3.3._
958      */
959     function functionStaticCall(address target, bytes memory data)
960         internal
961         view
962         returns (bytes memory)
963     {
964         return
965             functionStaticCall(
966                 target,
967                 data,
968                 "Address: low-level static call failed"
969             );
970     }
971 
972     /**
973      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
974      * but performing a static call.
975      *
976      * _Available since v3.3._
977      */
978     function functionStaticCall(
979         address target,
980         bytes memory data,
981         string memory errorMessage
982     ) internal view returns (bytes memory) {
983         require(isContract(target), "Address: static call to non-contract");
984 
985         // solhint-disable-next-line avoid-low-level-calls
986         (bool success, bytes memory returndata) = target.staticcall(data);
987         return _verifyCallResult(success, returndata, errorMessage);
988     }
989 
990     /**
991      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
992      * but performing a delegate call.
993      *
994      * _Available since v3.4._
995      */
996     function functionDelegateCall(address target, bytes memory data)
997         internal
998         returns (bytes memory)
999     {
1000         return
1001             functionDelegateCall(
1002                 target,
1003                 data,
1004                 "Address: low-level delegate call failed"
1005             );
1006     }
1007 
1008     /**
1009      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1010      * but performing a delegate call.
1011      *
1012      * _Available since v3.4._
1013      */
1014     function functionDelegateCall(
1015         address target,
1016         bytes memory data,
1017         string memory errorMessage
1018     ) internal returns (bytes memory) {
1019         require(isContract(target), "Address: delegate call to non-contract");
1020 
1021         // solhint-disable-next-line avoid-low-level-calls
1022         (bool success, bytes memory returndata) = target.delegatecall(data);
1023         return _verifyCallResult(success, returndata, errorMessage);
1024     }
1025 
1026     function _verifyCallResult(
1027         bool success,
1028         bytes memory returndata,
1029         string memory errorMessage
1030     ) private pure returns (bytes memory) {
1031         if (success) {
1032             return returndata;
1033         } else {
1034             // Look for revert reason and bubble it up if present
1035             if (returndata.length > 0) {
1036                 // The easiest way to bubble the revert reason is using memory via assembly
1037 
1038                 // solhint-disable-next-line no-inline-assembly
1039                 assembly {
1040                     let returndata_size := mload(returndata)
1041                     revert(add(32, returndata), returndata_size)
1042                 }
1043             } else {
1044                 revert(errorMessage);
1045             }
1046         }
1047     }
1048 }
1049 
1050 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.2
1051 
1052 pragma solidity >=0.6.0 <0.8.0;
1053 
1054 /**
1055  * @title SafeERC20
1056  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1057  * contract returns false). Tokens that return no value (and instead revert or
1058  * throw on failure) are also supported, non-reverting calls are assumed to be
1059  * successful.
1060  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1061  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1062  */
1063 library SafeERC20 {
1064     using SafeMath for uint256;
1065     using Address for address;
1066 
1067     function safeTransfer(
1068         IERC20 token,
1069         address to,
1070         uint256 value
1071     ) internal {
1072         _callOptionalReturn(
1073             token,
1074             abi.encodeWithSelector(token.transfer.selector, to, value)
1075         );
1076     }
1077 
1078     function safeTransferFrom(
1079         IERC20 token,
1080         address from,
1081         address to,
1082         uint256 value
1083     ) internal {
1084         _callOptionalReturn(
1085             token,
1086             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1087         );
1088     }
1089 
1090     /**
1091      * @dev Deprecated. This function has issues similar to the ones found in
1092      * {IERC20-approve}, and its usage is discouraged.
1093      *
1094      * Whenever possible, use {safeIncreaseAllowance} and
1095      * {safeDecreaseAllowance} instead.
1096      */
1097     function safeApprove(
1098         IERC20 token,
1099         address spender,
1100         uint256 value
1101     ) internal {
1102         // safeApprove should only be called when setting an initial allowance,
1103         // or when resetting it to zero. To increase and decrease it, use
1104         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1105         // solhint-disable-next-line max-line-length
1106         require(
1107             (value == 0) || (token.allowance(address(this), spender) == 0),
1108             "SafeERC20: approve from non-zero to non-zero allowance"
1109         );
1110         _callOptionalReturn(
1111             token,
1112             abi.encodeWithSelector(token.approve.selector, spender, value)
1113         );
1114     }
1115 
1116     function safeIncreaseAllowance(
1117         IERC20 token,
1118         address spender,
1119         uint256 value
1120     ) internal {
1121         uint256 newAllowance = token.allowance(address(this), spender).add(
1122             value
1123         );
1124         _callOptionalReturn(
1125             token,
1126             abi.encodeWithSelector(
1127                 token.approve.selector,
1128                 spender,
1129                 newAllowance
1130             )
1131         );
1132     }
1133 
1134     function safeDecreaseAllowance(
1135         IERC20 token,
1136         address spender,
1137         uint256 value
1138     ) internal {
1139         uint256 newAllowance = token.allowance(address(this), spender).sub(
1140             value,
1141             "SafeERC20: decreased allowance below zero"
1142         );
1143         _callOptionalReturn(
1144             token,
1145             abi.encodeWithSelector(
1146                 token.approve.selector,
1147                 spender,
1148                 newAllowance
1149             )
1150         );
1151     }
1152 
1153     /**
1154      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1155      * on the return value: the return value is optional (but if data is returned, it must not be false).
1156      * @param token The token targeted by the call.
1157      * @param data The call data (encoded using abi.encode or one of its variants).
1158      */
1159     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1160         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1161         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1162         // the target address contains contract code and also asserts for success in the low-level call.
1163 
1164         bytes memory returndata = address(token).functionCall(
1165             data,
1166             "SafeERC20: low-level call failed"
1167         );
1168         if (returndata.length > 0) {
1169             // Return data is optional
1170             // solhint-disable-next-line max-line-length
1171             require(
1172                 abi.decode(returndata, (bool)),
1173                 "SafeERC20: ERC20 operation did not succeed"
1174             );
1175         }
1176     }
1177 }
1178 
1179 // File contracts/DePoMasterChef.sol
1180 
1181 //** DePo MasterChef Contract */
1182 //** Author Alex Hong : DePo Finance 2021.10 */
1183 
1184 pragma solidity 0.6.12;
1185 pragma experimental ABIEncoderV2;
1186 
1187 contract DePoMasterChef is OwnableUpgradeable, ReentrancyGuardUpgradeable {
1188     using SafeMath for uint256;
1189     using SafeERC20 for IERC20;
1190     // Info of each user.
1191     struct UserInfo {
1192         uint256 amount; // How many LP tokens the user has provided.
1193         uint256 rewardDebt; // Reward debt. See explanation below.
1194         uint256 rewardLockedUp; // Reward locked up.
1195         uint256 nextHarvestUntil; // When can the user harvest again.
1196         //
1197         // We do some fancy math here. Basically, any point in time, the amount of DePos
1198         // entitled to a user but is pending to be distributed is:
1199         //
1200         //   pending reward = (user.amount * pool.accDePoPerShare) - user.rewardDebt
1201         //
1202         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1203         //   1. The pool's `accDePoPerShare` (and `lastRewardBlock`) gets updated.
1204         //   2. User receives the pending reward sent to his/her address.
1205         //   3. User's `amount` gets updated.
1206         //   4. User's `rewardDebt` gets updated.
1207     }
1208     // Info of each pool.
1209     struct PoolInfo {
1210         IERC20 lpToken; // Address of LP token contract.
1211         uint256 allocPoint; // How many allocation points assigned to this pool. DePos to distribute per block.
1212         uint256 lastRewardBlock; // Last block number that DePos distribution occurs.
1213         uint256 accDePoPerShare; // Accumulated DePos per share, times 1e12. See below.
1214         uint16 depositFeeBP; // Deposit fee in basis points
1215         uint256 harvestInterval; // Harvest interval in seconds
1216     }
1217     // The DePo TOKEN!
1218     IERC20 public depo;
1219 
1220     // Deposit Fee address
1221     address public feeAddress;
1222     // Reward tokens holder address
1223     address public rewardHolder;
1224     // DePos tokens created per block. 0.5 DePo per block. 10% to depo charity ( address )
1225     uint256 public depoPerBlock;
1226     // Bonus muliplier for early depo makers.
1227     uint256 public constant BONUS_MULTIPLIER = 1;
1228     // Max harvest interval: 14 days.
1229     uint256 public constant MAXIMUM_HARVEST_INTERVAL = 10 days;
1230     // Info of each pool.
1231     PoolInfo[] public poolInfo;
1232     // Info of each user that stakes LP tokens.
1233     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1234     // Total allocation points. Must be the sum of all allocation points in all pools.
1235     uint256 public totalAllocPoint;
1236     // The block number when DePos mining starts.
1237     uint256 public startBlock;
1238     // Total locked up rewards
1239     uint256 public totalLockedUpRewards;
1240 
1241     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1242     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1243     event Compound(address indexed user, uint256 indexed pid, uint256 amount);
1244     event EmergencyWithdraw(
1245         address indexed user,
1246         uint256 indexed pid,
1247         uint256 amount
1248     );
1249     event EmissionRateUpdated(
1250         address indexed caller,
1251         uint256 previousAmount,
1252         uint256 newAmount
1253     );
1254     event RewardLockedUp(
1255         address indexed user,
1256         uint256 indexed pid,
1257         uint256 amountLockedUp
1258     );
1259 
1260     function initialize(
1261         address _depo,
1262         address _feeAddress,
1263         address _rewardHolder,
1264         uint256 _startBlock,
1265         uint256 _depoPerBlock
1266     ) public initializer {
1267         depo = IERC20(_depo);
1268         rewardHolder = _rewardHolder;
1269         startBlock = _startBlock;
1270         depoPerBlock = _depoPerBlock;
1271 
1272         feeAddress = _feeAddress;
1273         totalAllocPoint = 0;
1274         __Ownable_init();
1275         __ReentrancyGuard_init();
1276     }
1277 
1278     function poolLength() external view returns (uint256) {
1279         return poolInfo.length;
1280     }
1281 
1282     // Add a new lp to the pool. Can only be called by the owner.
1283     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1284     function add(
1285         uint256 _allocPoint,
1286         IERC20 _lpToken,
1287         uint16 _depositFeeBP,
1288         uint256 _harvestInterval,
1289         bool _withUpdate
1290     ) public onlyOwner {
1291         require(_depositFeeBP <= 500, "add: invalid deposit fee basis points");
1292         require(
1293             _harvestInterval <= MAXIMUM_HARVEST_INTERVAL,
1294             "add: invalid harvest interval"
1295         );
1296         if (_withUpdate) {
1297             massUpdatePools();
1298         }
1299         uint256 lastRewardBlock = block.number > startBlock
1300             ? block.number
1301             : startBlock;
1302         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1303         poolInfo.push(
1304             PoolInfo({
1305                 lpToken: _lpToken,
1306                 allocPoint: _allocPoint,
1307                 lastRewardBlock: lastRewardBlock,
1308                 accDePoPerShare: 0,
1309                 depositFeeBP: _depositFeeBP,
1310                 harvestInterval: _harvestInterval
1311             })
1312         );
1313     }
1314 
1315     // Update the given pool's DePos allocation point and deposit fee. Can only be called by the owner.
1316     function set(
1317         uint256 _pid,
1318         uint256 _allocPoint,
1319         uint16 _depositFeeBP,
1320         uint256 _harvestInterval,
1321         bool _withUpdate
1322     ) public onlyOwner {
1323         require(_depositFeeBP <= 500, "set: invalid deposit fee basis points");
1324         require(
1325             _harvestInterval <= MAXIMUM_HARVEST_INTERVAL,
1326             "set: invalid harvest interval"
1327         );
1328         if (_withUpdate) {
1329             massUpdatePools();
1330         }
1331         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1332             _allocPoint
1333         );
1334         poolInfo[_pid].allocPoint = _allocPoint;
1335         poolInfo[_pid].depositFeeBP = _depositFeeBP;
1336         poolInfo[_pid].harvestInterval = _harvestInterval;
1337     }
1338 
1339     // Return reward multiplier over the given _from to _to block.
1340     function getMultiplier(uint256 _from, uint256 _to)
1341         public
1342         pure
1343         returns (uint256)
1344     {
1345         return _to.sub(_from).mul(BONUS_MULTIPLIER);
1346     }
1347 
1348     // View function to see pending DePos on frontend.
1349     function pendingDePo(uint256 _pid, address _user)
1350         external
1351         view
1352         returns (uint256)
1353     {
1354         PoolInfo storage pool = poolInfo[_pid];
1355         UserInfo storage user = userInfo[_pid][_user];
1356         uint256 accDePoPerShare = pool.accDePoPerShare;
1357         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1358         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1359             uint256 multiplier = getMultiplier(
1360                 pool.lastRewardBlock,
1361                 block.number
1362             );
1363             uint256 depoReward = multiplier
1364                 .mul(depoPerBlock)
1365                 .mul(pool.allocPoint)
1366                 .div(totalAllocPoint);
1367             accDePoPerShare = accDePoPerShare.add(
1368                 depoReward.mul(1e12).div(lpSupply)
1369             );
1370         }
1371         uint256 pending = user.amount.mul(accDePoPerShare).div(1e12).sub(
1372             user.rewardDebt
1373         );
1374         return pending.add(user.rewardLockedUp);
1375     }
1376 
1377     // View function to see if user can harvest DePos.
1378     function canHarvest(uint256 _pid, address _user)
1379         public
1380         view
1381         returns (bool)
1382     {
1383         UserInfo storage user = userInfo[_pid][_user];
1384         return block.timestamp >= user.nextHarvestUntil;
1385     }
1386 
1387     // Update reward variables for all pools. Be careful of gas spending!
1388     function massUpdatePools() public {
1389         uint256 length = poolInfo.length;
1390         for (uint256 pid = 0; pid < length; ++pid) {
1391             updatePool(pid);
1392         }
1393     }
1394 
1395     // Update reward variables of the given pool to be up-to-date.
1396     function updatePool(uint256 _pid) public {
1397         PoolInfo storage pool = poolInfo[_pid];
1398         if (block.number <= pool.lastRewardBlock) {
1399             return;
1400         }
1401         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1402         if (lpSupply == 0 || pool.allocPoint == 0) {
1403             pool.lastRewardBlock = block.number;
1404             return;
1405         }
1406         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1407         uint256 depoReward = multiplier
1408             .mul(depoPerBlock)
1409             .mul(pool.allocPoint)
1410             .div(totalAllocPoint);
1411 
1412         pool.accDePoPerShare = pool.accDePoPerShare.add(
1413             depoReward.mul(1e12).div(lpSupply)
1414         );
1415         pool.lastRewardBlock = block.number;
1416     }
1417 
1418     // Deposit LP tokens to MasterChef for DePos allocation.
1419     function deposit(uint256 _pid, uint256 _amount) public nonReentrant {
1420         PoolInfo storage pool = poolInfo[_pid];
1421         UserInfo storage user = userInfo[_pid][msg.sender];
1422         updatePool(_pid);
1423 
1424         payOrLockupPendingDePo(_pid);
1425         if (_amount > 0) {
1426             pool.lpToken.safeTransferFrom(
1427                 address(msg.sender),
1428                 address(this),
1429                 _amount
1430             );
1431             if (pool.depositFeeBP > 0) {
1432                 uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
1433                 pool.lpToken.safeTransfer(feeAddress, depositFee);
1434                 user.amount = user.amount.add(_amount).sub(depositFee);
1435             } else {
1436                 user.amount = user.amount.add(_amount);
1437             }
1438         }
1439         user.rewardDebt = user.amount.mul(pool.accDePoPerShare).div(1e12);
1440         emit Deposit(msg.sender, _pid, _amount);
1441     }
1442 
1443     // Withdraw LP tokens from MasterChef.
1444     function withdraw(uint256 _pid, uint256 _amount) public nonReentrant {
1445         PoolInfo storage pool = poolInfo[_pid];
1446         UserInfo storage user = userInfo[_pid][msg.sender];
1447         require(user.amount >= _amount, "withdraw: not good");
1448         updatePool(_pid);
1449         payOrLockupPendingDePo(_pid);
1450         if (_amount > 0) {
1451             user.amount = user.amount.sub(_amount);
1452             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1453         }
1454         user.rewardDebt = user.amount.mul(pool.accDePoPerShare).div(1e12);
1455         emit Withdraw(msg.sender, _pid, _amount);
1456     }
1457 
1458     // Compound tokens to DePo pool.
1459     function compound(uint256 _pid) public nonReentrant {
1460         PoolInfo storage pool = poolInfo[_pid];
1461         UserInfo storage user = userInfo[_pid][msg.sender];
1462         require(
1463             address(pool.lpToken) == address(depo),
1464             "compound: not able to compound"
1465         );
1466         updatePool(_pid);
1467         uint256 pending = user.amount.mul(pool.accDePoPerShare).div(1e12).sub(
1468             user.rewardDebt
1469         );
1470         safeDePoTransferFrom(rewardHolder, address(this), pending);
1471         user.amount = user.amount.add(pending);
1472         user.rewardDebt = user.amount.mul(pool.accDePoPerShare).div(1e12);
1473         emit Compound(msg.sender, _pid, pending);
1474     }
1475 
1476     // Withdraw without caring about rewards. EMERGENCY ONLY.
1477     function emergencyWithdraw(uint256 _pid) public nonReentrant {
1478         PoolInfo storage pool = poolInfo[_pid];
1479         UserInfo storage user = userInfo[_pid][msg.sender];
1480         uint256 amount = user.amount;
1481         user.amount = 0;
1482         user.rewardDebt = 0;
1483         user.rewardLockedUp = 0;
1484         user.nextHarvestUntil = 0;
1485         pool.lpToken.safeTransfer(address(msg.sender), amount);
1486         emit EmergencyWithdraw(msg.sender, _pid, amount);
1487     }
1488 
1489     // Pay or lockup pending DePos.
1490     function payOrLockupPendingDePo(uint256 _pid) internal {
1491         PoolInfo storage pool = poolInfo[_pid];
1492         UserInfo storage user = userInfo[_pid][msg.sender];
1493         if (user.nextHarvestUntil == 0) {
1494             user.nextHarvestUntil = block.timestamp.add(pool.harvestInterval);
1495         }
1496         uint256 pending = user.amount.mul(pool.accDePoPerShare).div(1e12).sub(
1497             user.rewardDebt
1498         );
1499         if (canHarvest(_pid, msg.sender)) {
1500             if (pending > 0 || user.rewardLockedUp > 0) {
1501                 uint256 totalRewards = pending.add(user.rewardLockedUp);
1502                 // reset lockup
1503                 totalLockedUpRewards = totalLockedUpRewards.sub(
1504                     user.rewardLockedUp
1505                 );
1506                 user.rewardLockedUp = 0;
1507                 user.nextHarvestUntil = block.timestamp.add(
1508                     pool.harvestInterval
1509                 );
1510                 // send rewards
1511                 safeDePoTransferFrom(rewardHolder, msg.sender, totalRewards);
1512             }
1513         } else if (pending > 0) {
1514             user.rewardLockedUp = user.rewardLockedUp.add(pending);
1515             totalLockedUpRewards = totalLockedUpRewards.add(pending);
1516             emit RewardLockedUp(msg.sender, _pid, pending);
1517         }
1518     }
1519 
1520     // Safe DePo transfer function, just in case if rounding error causes pool to not have enough depos.
1521     function safeDePoTransferFrom(
1522         address _from,
1523         address _to,
1524         uint256 _amount
1525     ) internal {
1526         uint256 depoBal = depo.balanceOf(rewardHolder);
1527         if (_amount > depoBal) {
1528             revert("Not enough balance");
1529         } else {
1530             depo.transferFrom(_from, _to, _amount);
1531         }
1532     }
1533 
1534     function setFeeAddress(address _feeAddress) public {
1535         require(msg.sender == feeAddress, "setFeeAddress: FORBIDDEN");
1536         require(_feeAddress != address(0), "setFeeAddress: ZERO");
1537         feeAddress = _feeAddress;
1538     }
1539 
1540     function setRewardHolder(address _rewardHolder) public {
1541         require(msg.sender == rewardHolder, "setRewardHolder: FORBIDDEN");
1542         require(_rewardHolder != address(0), "setRewardHolder: ZERO");
1543         rewardHolder = _rewardHolder;
1544     }
1545 
1546     // Pancake has to add hidden dummy pools in order to alter the emission, here we make it simple and transparent to all.
1547     function updateEmissionRate(uint256 _depoPerBlock) public onlyOwner {
1548         massUpdatePools();
1549         emit EmissionRateUpdated(msg.sender, depoPerBlock, _depoPerBlock);
1550         depoPerBlock = _depoPerBlock;
1551     }
1552 }