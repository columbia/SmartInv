1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         _checkOwner();
131         _;
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if the sender is not the owner.
143      */
144     function _checkOwner() internal view virtual {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 // CAUTION
187 // This version of SafeMath should only be used with Solidity 0.8 or later,
188 // because it relies on the compiler's built in overflow checks.
189 
190 /**
191  * @dev Wrappers over Solidity's arithmetic operations.
192  *
193  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
194  * now has built in overflow checking.
195  */
196 library SafeMath {
197     /**
198      * @dev Returns the addition of two unsigned integers, with an overflow flag.
199      *
200      * _Available since v3.4._
201      */
202     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
203         unchecked {
204             uint256 c = a + b;
205             if (c < a) return (false, 0);
206             return (true, c);
207         }
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
212      *
213      * _Available since v3.4._
214      */
215     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
216         unchecked {
217             if (b > a) return (false, 0);
218             return (true, a - b);
219         }
220     }
221 
222     /**
223      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
224      *
225      * _Available since v3.4._
226      */
227     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
228         unchecked {
229             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
230             // benefit is lost if 'b' is also tested.
231             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
232             if (a == 0) return (true, 0);
233             uint256 c = a * b;
234             if (c / a != b) return (false, 0);
235             return (true, c);
236         }
237     }
238 
239     /**
240      * @dev Returns the division of two unsigned integers, with a division by zero flag.
241      *
242      * _Available since v3.4._
243      */
244     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
245         unchecked {
246             if (b == 0) return (false, 0);
247             return (true, a / b);
248         }
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
253      *
254      * _Available since v3.4._
255      */
256     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b == 0) return (false, 0);
259             return (true, a % b);
260         }
261     }
262 
263     /**
264      * @dev Returns the addition of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `+` operator.
268      *
269      * Requirements:
270      *
271      * - Addition cannot overflow.
272      */
273     function add(uint256 a, uint256 b) internal pure returns (uint256) {
274         return a + b;
275     }
276 
277     /**
278      * @dev Returns the subtraction of two unsigned integers, reverting on
279      * overflow (when the result is negative).
280      *
281      * Counterpart to Solidity's `-` operator.
282      *
283      * Requirements:
284      *
285      * - Subtraction cannot overflow.
286      */
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a - b;
289     }
290 
291     /**
292      * @dev Returns the multiplication of two unsigned integers, reverting on
293      * overflow.
294      *
295      * Counterpart to Solidity's `*` operator.
296      *
297      * Requirements:
298      *
299      * - Multiplication cannot overflow.
300      */
301     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a * b;
303     }
304 
305     /**
306      * @dev Returns the integer division of two unsigned integers, reverting on
307      * division by zero. The result is rounded towards zero.
308      *
309      * Counterpart to Solidity's `/` operator.
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function div(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a / b;
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * reverting when dividing by zero.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
332         return a % b;
333     }
334 
335     /**
336      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
337      * overflow (when the result is negative).
338      *
339      * CAUTION: This function is deprecated because it requires allocating memory for the error
340      * message unnecessarily. For custom revert reasons use {trySub}.
341      *
342      * Counterpart to Solidity's `-` operator.
343      *
344      * Requirements:
345      *
346      * - Subtraction cannot overflow.
347      */
348     function sub(
349         uint256 a,
350         uint256 b,
351         string memory errorMessage
352     ) internal pure returns (uint256) {
353         unchecked {
354             require(b <= a, errorMessage);
355             return a - b;
356         }
357     }
358 
359     /**
360      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
361      * division by zero. The result is rounded towards zero.
362      *
363      * Counterpart to Solidity's `/` operator. Note: this function uses a
364      * `revert` opcode (which leaves remaining gas untouched) while Solidity
365      * uses an invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function div(
372         uint256 a,
373         uint256 b,
374         string memory errorMessage
375     ) internal pure returns (uint256) {
376         unchecked {
377             require(b > 0, errorMessage);
378             return a / b;
379         }
380     }
381 
382     /**
383      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
384      * reverting with custom message when dividing by zero.
385      *
386      * CAUTION: This function is deprecated because it requires allocating memory for the error
387      * message unnecessarily. For custom revert reasons use {tryMod}.
388      *
389      * Counterpart to Solidity's `%` operator. This function uses a `revert`
390      * opcode (which leaves remaining gas untouched) while Solidity uses an
391      * invalid opcode to revert (consuming all remaining gas).
392      *
393      * Requirements:
394      *
395      * - The divisor cannot be zero.
396      */
397     function mod(
398         uint256 a,
399         uint256 b,
400         string memory errorMessage
401     ) internal pure returns (uint256) {
402         unchecked {
403             require(b > 0, errorMessage);
404             return a % b;
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/utils/Address.sol
410 
411 
412 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
413 
414 pragma solidity ^0.8.1;
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      *
437      * [IMPORTANT]
438      * ====
439      * You shouldn't rely on `isContract` to protect against flash loan attacks!
440      *
441      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
442      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
443      * constructor.
444      * ====
445      */
446     function isContract(address account) internal view returns (bool) {
447         // This method relies on extcodesize/address.code.length, which returns 0
448         // for contracts in construction, since the code is only stored at the end
449         // of the constructor execution.
450 
451         return account.code.length > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         (bool success, ) = recipient.call{value: amount}("");
474         require(success, "Address: unable to send value, recipient may have reverted");
475     }
476 
477     /**
478      * @dev Performs a Solidity function call using a low level `call`. A
479      * plain `call` is an unsafe replacement for a function call: use this
480      * function instead.
481      *
482      * If `target` reverts with a revert reason, it is bubbled up by this
483      * function (like regular Solidity function calls).
484      *
485      * Returns the raw returned data. To convert to the expected return value,
486      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
487      *
488      * Requirements:
489      *
490      * - `target` must be a contract.
491      * - calling `target` with `data` must not revert.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionCall(target, data, "Address: low-level call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
501      * `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, 0, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but also transferring `value` wei to `target`.
516      *
517      * Requirements:
518      *
519      * - the calling contract must have an ETH balance of at least `value`.
520      * - the called Solidity function must be `payable`.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(
525         address target,
526         bytes memory data,
527         uint256 value
528     ) internal returns (bytes memory) {
529         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
534      * with `errorMessage` as a fallback revert reason when `target` reverts.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(address(this).balance >= value, "Address: insufficient balance for call");
545         require(isContract(target), "Address: call to non-contract");
546 
547         (bool success, bytes memory returndata) = target.call{value: value}(data);
548         return verifyCallResult(success, returndata, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
558         return functionStaticCall(target, data, "Address: low-level static call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
563      * but performing a static call.
564      *
565      * _Available since v3.3._
566      */
567     function functionStaticCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal view returns (bytes memory) {
572         require(isContract(target), "Address: static call to non-contract");
573 
574         (bool success, bytes memory returndata) = target.staticcall(data);
575         return verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
585         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a delegate call.
591      *
592      * _Available since v3.4._
593      */
594     function functionDelegateCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal returns (bytes memory) {
599         require(isContract(target), "Address: delegate call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.delegatecall(data);
602         return verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
607      * revert reason using the provided one.
608      *
609      * _Available since v4.3._
610      */
611     function verifyCallResult(
612         bool success,
613         bytes memory returndata,
614         string memory errorMessage
615     ) internal pure returns (bytes memory) {
616         if (success) {
617             return returndata;
618         } else {
619             // Look for revert reason and bubble it up if present
620             if (returndata.length > 0) {
621                 // The easiest way to bubble the revert reason is using memory via assembly
622                 /// @solidity memory-safe-assembly
623                 assembly {
624                     let returndata_size := mload(returndata)
625                     revert(add(32, returndata), returndata_size)
626                 }
627             } else {
628                 revert(errorMessage);
629             }
630         }
631     }
632 }
633 
634 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 /**
642  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
643  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
644  *
645  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
646  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
647  * need to send a transaction, and thus is not required to hold Ether at all.
648  */
649 interface IERC20Permit {
650     /**
651      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
652      * given ``owner``'s signed approval.
653      *
654      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
655      * ordering also apply here.
656      *
657      * Emits an {Approval} event.
658      *
659      * Requirements:
660      *
661      * - `spender` cannot be the zero address.
662      * - `deadline` must be a timestamp in the future.
663      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
664      * over the EIP712-formatted function arguments.
665      * - the signature must use ``owner``'s current nonce (see {nonces}).
666      *
667      * For more information on the signature format, see the
668      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
669      * section].
670      */
671     function permit(
672         address owner,
673         address spender,
674         uint256 value,
675         uint256 deadline,
676         uint8 v,
677         bytes32 r,
678         bytes32 s
679     ) external;
680 
681     /**
682      * @dev Returns the current nonce for `owner`. This value must be
683      * included whenever a signature is generated for {permit}.
684      *
685      * Every successful call to {permit} increases ``owner``'s nonce by one. This
686      * prevents a signature from being used multiple times.
687      */
688     function nonces(address owner) external view returns (uint256);
689 
690     /**
691      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
692      */
693     // solhint-disable-next-line func-name-mixedcase
694     function DOMAIN_SEPARATOR() external view returns (bytes32);
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 /**
705  * @dev Interface of the ERC20 standard as defined in the EIP.
706  */
707 interface IERC20 {
708     /**
709      * @dev Emitted when `value` tokens are moved from one account (`from`) to
710      * another (`to`).
711      *
712      * Note that `value` may be zero.
713      */
714     event Transfer(address indexed from, address indexed to, uint256 value);
715 
716     /**
717      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
718      * a call to {approve}. `value` is the new allowance.
719      */
720     event Approval(address indexed owner, address indexed spender, uint256 value);
721 
722     /**
723      * @dev Returns the amount of tokens in existence.
724      */
725     function totalSupply() external view returns (uint256);
726 
727     /**
728      * @dev Returns the amount of tokens owned by `account`.
729      */
730     function balanceOf(address account) external view returns (uint256);
731 
732     /**
733      * @dev Moves `amount` tokens from the caller's account to `to`.
734      *
735      * Returns a boolean value indicating whether the operation succeeded.
736      *
737      * Emits a {Transfer} event.
738      */
739     function transfer(address to, uint256 amount) external returns (bool);
740 
741     /**
742      * @dev Returns the remaining number of tokens that `spender` will be
743      * allowed to spend on behalf of `owner` through {transferFrom}. This is
744      * zero by default.
745      *
746      * This value changes when {approve} or {transferFrom} are called.
747      */
748     function allowance(address owner, address spender) external view returns (uint256);
749 
750     /**
751      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
752      *
753      * Returns a boolean value indicating whether the operation succeeded.
754      *
755      * IMPORTANT: Beware that changing an allowance with this method brings the risk
756      * that someone may use both the old and the new allowance by unfortunate
757      * transaction ordering. One possible solution to mitigate this race
758      * condition is to first reduce the spender's allowance to 0 and set the
759      * desired value afterwards:
760      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
761      *
762      * Emits an {Approval} event.
763      */
764     function approve(address spender, uint256 amount) external returns (bool);
765 
766     /**
767      * @dev Moves `amount` tokens from `from` to `to` using the
768      * allowance mechanism. `amount` is then deducted from the caller's
769      * allowance.
770      *
771      * Returns a boolean value indicating whether the operation succeeded.
772      *
773      * Emits a {Transfer} event.
774      */
775     function transferFrom(
776         address from,
777         address to,
778         uint256 amount
779     ) external returns (bool);
780 }
781 
782 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
783 
784 
785 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 
790 
791 
792 /**
793  * @title SafeERC20
794  * @dev Wrappers around ERC20 operations that throw on failure (when the token
795  * contract returns false). Tokens that return no value (and instead revert or
796  * throw on failure) are also supported, non-reverting calls are assumed to be
797  * successful.
798  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
799  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
800  */
801 library SafeERC20 {
802     using Address for address;
803 
804     function safeTransfer(
805         IERC20 token,
806         address to,
807         uint256 value
808     ) internal {
809         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
810     }
811 
812     function safeTransferFrom(
813         IERC20 token,
814         address from,
815         address to,
816         uint256 value
817     ) internal {
818         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
819     }
820 
821     /**
822      * @dev Deprecated. This function has issues similar to the ones found in
823      * {IERC20-approve}, and its usage is discouraged.
824      *
825      * Whenever possible, use {safeIncreaseAllowance} and
826      * {safeDecreaseAllowance} instead.
827      */
828     function safeApprove(
829         IERC20 token,
830         address spender,
831         uint256 value
832     ) internal {
833         // safeApprove should only be called when setting an initial allowance,
834         // or when resetting it to zero. To increase and decrease it, use
835         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
836         require(
837             (value == 0) || (token.allowance(address(this), spender) == 0),
838             "SafeERC20: approve from non-zero to non-zero allowance"
839         );
840         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
841     }
842 
843     function safeIncreaseAllowance(
844         IERC20 token,
845         address spender,
846         uint256 value
847     ) internal {
848         uint256 newAllowance = token.allowance(address(this), spender) + value;
849         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
850     }
851 
852     function safeDecreaseAllowance(
853         IERC20 token,
854         address spender,
855         uint256 value
856     ) internal {
857         unchecked {
858             uint256 oldAllowance = token.allowance(address(this), spender);
859             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
860             uint256 newAllowance = oldAllowance - value;
861             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
862         }
863     }
864 
865     function safePermit(
866         IERC20Permit token,
867         address owner,
868         address spender,
869         uint256 value,
870         uint256 deadline,
871         uint8 v,
872         bytes32 r,
873         bytes32 s
874     ) internal {
875         uint256 nonceBefore = token.nonces(owner);
876         token.permit(owner, spender, value, deadline, v, r, s);
877         uint256 nonceAfter = token.nonces(owner);
878         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
879     }
880 
881     /**
882      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
883      * on the return value: the return value is optional (but if data is returned, it must not be false).
884      * @param token The token targeted by the call.
885      * @param data The call data (encoded using abi.encode or one of its variants).
886      */
887     function _callOptionalReturn(IERC20 token, bytes memory data) private {
888         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
889         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
890         // the target address contains contract code and also asserts for success in the low-level call.
891 
892         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
893         if (returndata.length > 0) {
894             // Return data is optional
895             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
896         }
897     }
898 }
899 
900 // File: FarmLock.sol
901 
902 
903 pragma solidity ^0.8.0;
904 
905 
906 
907 
908 
909 contract FarmLock is Ownable, ReentrancyGuard {
910 
911     using SafeMath for uint256;
912     using SafeERC20 for IERC20;
913 
914     // Whether it is initialized
915     bool public isInitialized;
916     uint256 public duration;
917 
918     uint256 public slot;
919 
920     // Whether a limit is set for users
921     bool public hasUserLimit;
922     // The pool limit (0 if none)
923     uint256 public poolLimitPerUser;
924 
925     // The block number when staking starts.
926     uint256 public startBlock;
927     // The block number when staking ends.
928     uint256 public bonusEndBlock;
929 
930     address public walletA;
931 
932     uint256 private constant  MIN_SLOT = 1;
933     uint256 private constant  MAX_SLOT = 60 * 60 * 24;
934     uint256 private constant  DAY_LENGTH = 60 * 60 * 24;
935     uint256 private constant  MAX_INT = type(uint256).max;
936 
937     // The staked token
938     address stakingToken;
939     address rewardsToken;
940 
941     uint256 private totalEarnedTokenDeposed;
942 
943     struct Lockup {
944         uint8 stakeType;
945         uint256 duration;
946         uint256 depositFee;
947         uint256 withdrawFee;
948         uint256 rate;
949         uint256 lastRewardBlock;
950         uint256 totalStaked;
951         uint256 totalEarned;
952         uint256 totalCompounded;
953         uint256 totalWithdrawn;
954         bool depositFeeReverse;
955         bool withdrawFeeReverse;
956     }
957 
958     struct UserInfo {
959         uint256 lastRewardBlock;
960         uint256 totalStaked;
961         uint256 totalEarned;
962         uint256 totalCompounded;
963         uint256 totalWithdrawn;
964     }
965 
966     struct Stake {
967         uint8 stakeType;
968         uint256 duration;
969         uint256 end;
970         uint256 lastRewardBlock;
971         uint256 staked;
972         uint256 earned;
973         uint256 compounded;
974         uint256 withdrawn;
975     }
976 
977     uint256 constant MAX_STAKES = 2048;
978 
979     Lockup[] public lockups;
980     mapping(address => Stake[]) public userStakes;
981     mapping(address => mapping(uint8 => UserInfo)) public userStaked;
982 
983     event Deposit(address indexed user, uint256 stakeType, uint256 amount, uint256 depositFee, bool depositFeeReverse, uint256 fee);
984     event Withdraw(address indexed user, uint256 stakeType, uint256 amount, uint256 depositFee, bool depositFeeReverse, uint256 fee);
985     event EmergencyWithdraw(address indexed user, uint256 amount);
986     event AdminTokenRecovered(address tokenRecovered, uint256 amount);
987 
988     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
989     event LockupUpdated(uint8 _type, uint256 _duration, uint256 _fee0, uint256 _fee1, uint256 _rate, bool _depositFeeReverse, bool _withdrawFeeReverse);
990     event NewPoolLimit(bool hasUserLimit, uint256 poolLimitPerUser);
991     event RewardsStop(uint256 blockNumber);
992     event DurationUpdated(uint256 duration);
993 
994     event SetSettings(
995         address _walletA
996     );
997 
998     /* +++
999      * @notice Initialize the contract
1000      * @param _stakingToken: staked token address
1001      */
1002     function initialize(
1003         address _stakingToken,
1004         address _rewardsToken,
1005         uint256 _slot,
1006         uint256 _duration
1007     ) external onlyOwner {
1008         require(!isInitialized, "Already initialized");
1009         require(_slot >= MIN_SLOT && _slot <= MAX_SLOT, "Incorrect slot!");
1010         require((DAY_LENGTH / _slot) * _slot == DAY_LENGTH, "Incorrect slot!");
1011         require(_duration > 0, "Incorrect duration!");
1012 
1013         slot = _slot;
1014         duration = _duration;
1015 
1016         // Make this contract initialized
1017         isInitialized = true;
1018         stakingToken = _stakingToken;
1019         rewardsToken = _rewardsToken;
1020         walletA = msg.sender;
1021 
1022     }
1023 
1024     /* +++
1025      * @notice Deposit staked tokens
1026      */
1027     function deposit(uint256 _amount, uint8 _stakeType) external nonReentrant {
1028         require(isInitialized, "Not initialized");
1029         require(startBlock > 0, "Pool not started");
1030         require(_amount > 0, "Amount should be greater than 0");
1031         require(_stakeType < lockups.length, "Invalid stake type");
1032 
1033         UserInfo storage user = userStaked[msg.sender][_stakeType];
1034         Lockup storage lockup = lockups[_stakeType];
1035 
1036         //calc user and lockup reward
1037         _calcUserLockupReward(_stakeType);
1038 
1039         uint256 beforeAmount = IERC20(stakingToken).balanceOf(address(this));
1040         IERC20(stakingToken).safeTransferFrom(
1041             address(msg.sender),
1042             address(this),
1043             _amount
1044         );
1045         uint256 afterAmount = IERC20(stakingToken).balanceOf(address(this));
1046         uint256 realAmount = afterAmount.sub(beforeAmount);
1047 
1048         if (hasUserLimit) {
1049             require(
1050                 realAmount.add(user.totalStaked) <= poolLimitPerUser,
1051                 "User amount above limit"
1052             );
1053         }
1054         uint256 fee;
1055         if (lockup.depositFee > 0) {
1056             fee = realAmount.mul(lockup.depositFee).div(10000);
1057             if (fee > 0) {
1058                 if(lockup.depositFeeReverse == false){
1059                     IERC20(stakingToken).safeTransfer(walletA, fee);
1060                     realAmount = realAmount.sub(fee);
1061                 } else {
1062                     realAmount = realAmount.add(fee);
1063                 }
1064             }
1065         }
1066 
1067         _addStake(_stakeType, msg.sender, lockup.duration, realAmount);
1068 
1069         user.totalStaked = user.totalStaked.add(realAmount);
1070         lockup.totalStaked = lockup.totalStaked.add(realAmount);
1071 
1072         emit Deposit(msg.sender, _stakeType, realAmount, lockup.depositFee, lockup.depositFeeReverse, fee);
1073     }
1074 
1075     /* +++ */
1076     function _addStake(uint8 _stakeType, address _account, uint256 _duration, uint256 _amount) internal {
1077         Stake[] storage stakes = userStakes[_account];
1078 
1079         // uint256 end = _getSlot().add(_duration.mul(DAY_LENGTH / slot));
1080         uint256 end = block.timestamp.add(_duration).div(slot);
1081 
1082         uint256 i = stakes.length;
1083         require(i < MAX_STAKES, "Max stakes");
1084 
1085         stakes.push();
1086 
1087         // insert the stake
1088         Stake storage newStake = stakes[i];
1089         newStake.stakeType = _stakeType;
1090         newStake.duration = _duration;
1091         newStake.end = end;
1092         newStake.staked = _amount;
1093         newStake.lastRewardBlock = _getSlot();
1094 
1095     }
1096 
1097     /* +++
1098      * @notice Withdraw staked tokens and collect reward tokens
1099      * @param _amount: amount to withdraw (in earnedToken)
1100      */
1101     function withdraw(uint256 _amount, uint8 _stakeType) external nonReentrant {
1102         require(isInitialized, "Not initialized");
1103         require(startBlock > 0, "Pool not started");
1104         require(_amount > 0, "Amount should be greator than 0");
1105         require(_stakeType < lockups.length, "Invalid stake type");
1106 
1107         UserInfo storage user = userStaked[msg.sender][_stakeType];
1108         Stake[] storage stakes = userStakes[msg.sender];
1109         Lockup storage lockup = lockups[_stakeType];
1110 
1111         //calc user and lockup reward
1112         _calcUserLockupReward(_stakeType);
1113         //calc stake reward
1114         _calcStakeReward(_stakeType);
1115 
1116         uint256 remained = _amount;
1117 //        uint256 rewardAmount = _claimReward(_stakeType, _amount);
1118 //        if (rewardAmount >= remained) {
1119 //            remained = 0;
1120 //        } else {
1121 //            remained = remained.sub(rewardAmount);
1122 //        }
1123 
1124         uint256 pending = 0;
1125 
1126         for (uint256 j = 0; j < stakes.length; j++) {
1127             Stake storage stake = stakes[j];
1128             if (stake.stakeType != _stakeType) continue;
1129             if (stake.staked == 0) continue;
1130             if (_getSlot() <= stake.end) continue;
1131             if (remained == 0) break;
1132 
1133             uint256 _pending = stake.staked;
1134             if (_pending > remained) {
1135                 _pending = remained;
1136             }
1137 
1138             stake.staked = stake.staked.sub(_pending);
1139             remained = remained.sub(_pending);
1140             pending = pending.add(_pending);
1141         }
1142 
1143         if (pending > 0) {
1144             require(availableTokens() >= pending, "Insufficient tokens");
1145 
1146             lockup.totalStaked = lockup.totalStaked.sub(pending);
1147             user.totalStaked = user.totalStaked.sub(pending);
1148 
1149             uint256 fee;
1150             if (lockup.withdrawFee > 0) {
1151                 fee = pending.mul(lockup.withdrawFee).div(10000);
1152                 if(fee > 0){
1153                     if(lockup.withdrawFeeReverse == false){
1154                         IERC20(stakingToken).safeTransfer(walletA, fee);
1155                         pending = pending.sub(fee);
1156                     } else {
1157                         pending = pending.add(fee);
1158                     }
1159                 }
1160             }
1161 
1162             IERC20(stakingToken).safeTransfer(address(msg.sender), pending);
1163             emit Withdraw(msg.sender, _stakeType, pending, lockup.withdrawFee, lockup.withdrawFeeReverse, fee);
1164 
1165         }
1166 
1167     }
1168 
1169 
1170     /* +++ */
1171     function _claimReward(uint8 _stakeType, uint256 _amount) internal returns (uint256){
1172         require(isInitialized, "Not initialized");
1173         require(startBlock > 0, "Pool not started");
1174         require(_amount > 0, "Amount should be greator than 0");
1175         require(_stakeType < lockups.length, "Invalid stake type");
1176 
1177         UserInfo storage user = userStaked[msg.sender][_stakeType];
1178         Stake[] storage stakes = userStakes[msg.sender];
1179         Lockup storage lockup = lockups[_stakeType];
1180 
1181         //calc user and lockup reward
1182         _calcUserLockupReward(_stakeType);
1183         //calc stake reward
1184         _calcStakeReward(_stakeType);
1185 
1186         uint256 remained = _amount;
1187         uint256 pending = 0;
1188 
1189         for (uint256 j = 0; j < stakes.length; j++) {
1190             Stake storage stake = stakes[j];
1191             if (stake.stakeType != _stakeType) continue;
1192             // if (stake.amount == 0) continue;
1193             if (_getSlot() <= stake.end) continue;
1194 
1195             uint256 _pending = stake.earned.sub(stake.compounded).sub(stake.withdrawn);
1196 
1197             if (_pending > remained) {
1198                 _pending = remained;
1199             }
1200 
1201             remained = remained.sub(_pending);
1202 
1203             pending = pending.add(_pending);
1204             stake.withdrawn = stake.withdrawn + _pending;
1205 
1206             if (remained == 0) {
1207                 break;
1208             }
1209 
1210         }
1211 
1212         if (pending > 0) {
1213             require(availableRewardTokens() >= pending, "Insufficient reward tokens");
1214             IERC20(rewardsToken).safeTransfer(address(msg.sender), pending);
1215 
1216             lockup.totalWithdrawn = lockup.totalWithdrawn + pending;
1217             user.totalWithdrawn = user.totalWithdrawn + pending;
1218 
1219             emit Withdraw(msg.sender, _stakeType, pending, lockup.withdrawFee, lockup.withdrawFeeReverse, 0);
1220 
1221         }
1222 
1223         return pending;
1224     }
1225 
1226 
1227     /* +++ */
1228     function claimReward(uint8 _stakeType) external payable nonReentrant {
1229         require(isInitialized, "Not initialized");
1230         require(startBlock > 0, "Pool not started");
1231         require(_stakeType < lockups.length, "Invalid stake type");
1232 
1233         _claimReward(_stakeType, MAX_INT);
1234     }
1235 
1236     /* +++ */
1237     function claimReward(uint8 _stakeType, uint256 _amount) external payable nonReentrant {
1238         require(isInitialized, "Not initialized");
1239         require(startBlock > 0, "Pool not started");
1240         require(_stakeType < lockups.length, "Invalid stake type");
1241 
1242         _claimReward(_stakeType, _amount);
1243     }
1244 
1245     /* +++ */
1246     function _calcUserLockupReward(uint8 _stakeType) internal {
1247         require(isInitialized, "Not initialized");
1248         require(startBlock > 0, "Pool not started");
1249         require(_stakeType < lockups.length, "Invalid stake type");
1250 
1251         Lockup storage lockup = lockups[_stakeType];
1252         UserInfo storage user = userStaked[msg.sender][_stakeType];
1253         uint256 currentSlot = _getSlot();
1254         uint256 rate;
1255         uint256 pending;
1256 
1257         rate = _getRate(lockup.rate).mul(_getMultiplier(lockup.lastRewardBlock, currentSlot));
1258         // pending = lockup.totalStaked.mul(rate).div(10 ** 24);
1259         if(lockup.totalStaked == 0)
1260             pending = 0;
1261         else        
1262             pending = rate.div(10 ** 24);
1263         lockup.totalEarned = lockup.totalEarned + pending;
1264         lockup.lastRewardBlock = currentSlot;
1265 
1266         rate = _getRate(lockup.rate).mul(_getMultiplier(user.lastRewardBlock, currentSlot));
1267         // pending = user.totalStaked.mul(rate).div(10 ** 24);
1268         if(lockup.totalStaked == 0)
1269             pending = 0;
1270         else
1271             pending = rate.mul(user.totalStaked).div(lockup.totalStaked).div(10 ** 24);
1272         user.totalEarned = user.totalEarned + pending;
1273         user.lastRewardBlock = currentSlot;
1274 
1275     }
1276 
1277     /* +++ */
1278     function _calcStakeReward(uint8 _stakeType) internal {
1279         require(isInitialized, "Not initialized");
1280         require(startBlock > 0, "Pool not started");
1281         require(_stakeType < lockups.length, "Invalid stake type");
1282 
1283         Stake[] storage stakes = userStakes[msg.sender];
1284         Lockup storage lockup = lockups[_stakeType];
1285 
1286         uint256 currentSlot = _getSlot();
1287         uint256 rate;
1288         uint256 pending;
1289 
1290         for (uint256 j = 0; j < stakes.length; j++) {
1291             Stake storage stake = stakes[j];
1292             if (stake.stakeType != _stakeType) continue;
1293             if (stake.staked == 0) continue;
1294 
1295             rate = _getRate(lockup.rate).mul(_getMultiplier(stake.lastRewardBlock, currentSlot));
1296 
1297             // pending = stake.staked.mul(rate).div(10 ** 24);
1298             if(lockup.totalStaked == 0)
1299                 pending = 0;
1300             else    
1301                 pending = rate.mul(stake.staked).div(lockup.totalStaked).div(10 ** 24);
1302             stake.earned = stake.earned.add(pending);
1303             stake.lastRewardBlock = currentSlot;
1304         }
1305 
1306     }
1307 
1308     /* +++
1309      * @notice Withdraw staked tokens without caring about rewards
1310      * @dev Needs to be for emergency.
1311      */
1312     function emergencyWithdraw(uint8 _stakeType) external nonReentrant {
1313         require(isInitialized, "Not initialized");
1314         require(startBlock > 0, "Pool not started");
1315         require(_stakeType < lockups.length, "Invalid stake type");
1316 
1317         UserInfo storage user = userStaked[msg.sender][_stakeType];
1318         Stake[] storage stakes = userStakes[msg.sender];
1319         Lockup storage lockup = lockups[_stakeType];
1320 
1321         //calc user and lockup reward
1322         _calcUserLockupReward(_stakeType);
1323         //calc stake reward
1324         _calcStakeReward(_stakeType);
1325 
1326         uint256 amountToTransfer = 0;
1327         uint256 totalStaked = 0;
1328         uint256 totalCompounded = 0;
1329         uint256 totalEarned = 0;
1330 
1331         for (uint256 j = 0; j < stakes.length; j++) {
1332             Stake storage stake = stakes[j];
1333             if (stake.stakeType != _stakeType) continue;
1334             if (stake.staked == 0) continue;
1335             if (_getSlot() > stake.end) continue;
1336 
1337 
1338             amountToTransfer = amountToTransfer.add(stake.staked).sub(stake.compounded);
1339             totalStaked = totalStaked.add(stake.staked);
1340             totalCompounded = totalCompounded.add(stake.compounded);
1341             totalEarned = totalEarned.add(stake.earned);
1342 
1343             stake.staked = 0;
1344             stake.earned = 0;
1345             stake.withdrawn = 0;
1346             stake.compounded = 0;
1347         }
1348 
1349         if (amountToTransfer > 0) {
1350 
1351             lockup.totalStaked = lockup.totalStaked.sub(totalStaked);
1352             lockup.totalEarned = lockup.totalEarned.sub(totalEarned);
1353             lockup.totalCompounded = lockup.totalCompounded.sub(totalCompounded);
1354 
1355             user.totalStaked = user.totalStaked.sub(totalStaked);
1356             user.totalEarned = user.totalEarned.sub(totalEarned);
1357             user.totalCompounded = user.totalCompounded.sub(totalCompounded);
1358 
1359             IERC20(stakingToken).safeTransfer(address(msg.sender), amountToTransfer);
1360 
1361         }
1362 
1363         emit EmergencyWithdraw(msg.sender, amountToTransfer);
1364     }
1365 
1366     /* +++ */
1367     function rewardPerStakeType(uint8 _stakeType) public view returns (uint256) {
1368         if (_stakeType >= lockups.length) return 0;
1369 
1370         return lockups[_stakeType].rate;
1371     }
1372 
1373     /** +++
1374      * @notice Available amount of reward token
1375      */
1376     function availableRewardTokens() public view returns (uint256) {
1377 
1378         uint256 _amount = IERC20(rewardsToken).balanceOf(address(this));
1379 
1380         uint256 reserved;
1381 
1382         if (_amount > reserved)
1383             return _amount.sub(reserved);
1384         else
1385             return 0;
1386     }
1387 
1388     function availableTokens() public view returns (uint256) {
1389 
1390         uint256 _amount = IERC20(stakingToken).balanceOf(address(this));
1391 
1392         uint256 reserved;
1393 
1394         if (_amount > reserved)
1395             return _amount.sub(reserved);
1396         else
1397             return 0;
1398     }
1399 
1400     /* +++ */
1401     function userInfo(uint8 _stakeType, address _account) public view returns (uint256 amount, uint256 available, uint256 locked) {
1402         Stake[] storage stakes = userStakes[_account];
1403 
1404         for (uint256 i = 0; i < stakes.length; i++) {
1405             Stake storage stake = stakes[i];
1406 
1407             if (stake.stakeType != _stakeType) continue;
1408             if (stake.staked == 0) continue;
1409 
1410             amount = amount.add(stake.staked);
1411             if (_getSlot() > stake.end) {
1412                 available = available.add(stake.staked);
1413             } else {
1414                 locked = locked.add(stake.staked);
1415             }
1416         }
1417     }
1418 
1419     /* +++
1420      * @notice View function to see pending reward on frontend.
1421      * @param _user: user address
1422      * @return Pending reward for a given user
1423      */
1424     function pendingReward(address _account, uint8 _stakeType) external view returns (uint256) {
1425         if (_stakeType >= lockups.length) return 0;
1426         if (startBlock == 0) return 0;
1427 
1428         Stake[] storage stakes = userStakes[_account];
1429         Lockup storage lockup = lockups[_stakeType];
1430 
1431         if (lockup.totalStaked == 0) return 0;
1432 
1433         uint256 pending = 0;
1434         for (uint256 i = 0; i < stakes.length; i++) {
1435             Stake storage stake = stakes[i];
1436             if (stake.stakeType != _stakeType) continue;
1437             // if (stake.staked == 0) continue;
1438 
1439             pending = pending.add(stake.earned - stake.compounded - stake.withdrawn);
1440             uint256 rate = _getRate(lockup.rate).mul(_getMultiplier(stake.lastRewardBlock, _getSlot()));
1441             uint256 reward = stake.staked.mul(rate).div(lockup.totalStaked).div(10 ** 24);
1442             pending = pending.add(reward);
1443 
1444         }
1445         return pending;
1446     }
1447 
1448     function countStakes(address _account, uint8 _stakeType) external view returns (uint256) {
1449         if (_stakeType >= lockups.length) return 0;
1450         if (startBlock == 0) return 0;
1451 
1452         Stake[] storage stakes = userStakes[_account];
1453 
1454         return stakes.length;
1455     }
1456 
1457 
1458     function pendingUnlockReward(address _account, uint8 _stakeType) external view returns (uint256 pending, uint256 available, uint256 locked) {
1459         if (_stakeType >= lockups.length) return (0, 0, 0);
1460         if (startBlock == 0) return (0, 0, 0);
1461 
1462         Stake[] storage stakes = userStakes[_account];
1463         Lockup storage lockup = lockups[_stakeType];
1464 
1465         if (lockup.totalStaked == 0) return (0, 0, 0);
1466 
1467         // uint256 pending = 0;
1468         for (uint256 i = 0; i < stakes.length; i++) {
1469             Stake storage stake = stakes[i];
1470             if (stake.stakeType != _stakeType) continue;
1471             // if (stake.staked == 0) continue;
1472 
1473             pending = pending.add(stake.earned - stake.compounded - stake.withdrawn);
1474             if (_getSlot() <= stake.end) {
1475                 locked = locked.add(stake.earned - stake.compounded - stake.withdrawn);
1476             }else{
1477                 available = available.add(stake.earned - stake.compounded - stake.withdrawn);
1478             }
1479 
1480             uint256 rate = _getRate(lockup.rate).mul(_getMultiplier(stake.lastRewardBlock, _getSlot()));
1481             uint256 reward = stake.staked.mul(rate).div(lockup.totalStaked).div(10 ** 24);
1482             pending = pending.add(reward);
1483             if (_getSlot() <= stake.end) {
1484                 locked = locked.add(reward);
1485             }else{
1486                 available = available.add(reward);
1487             }
1488         }
1489     }
1490 
1491 
1492     function pendingUnlock(address _account, uint8 _stakeType) external view returns (uint256 near, uint256 last) {
1493         if (_stakeType >= lockups.length) return (0, 0);
1494         if (startBlock == 0) return (0, 0);
1495 
1496         Stake[] storage stakes = userStakes[_account];
1497         Lockup storage lockup = lockups[_stakeType];
1498 
1499         if (lockup.totalStaked == 0) return (0, 0);
1500         
1501         last = 0;
1502         near = MAX_INT;
1503 
1504         // uint256 pending = 0;
1505         for (uint256 i = 0; i < stakes.length; i++) {
1506             Stake storage stake = stakes[i];
1507             if (stake.stakeType != _stakeType) continue;
1508             if (stake.staked == 0) continue;
1509 
1510             if(stake.end > last) last = stake.end;
1511             if(stake.end < near) near = stake.end;
1512 
1513         }
1514     }
1515 
1516 
1517     /* +++
1518      * @notice Deposit reward token
1519      * @dev Only call by owner. Needs to be for deposit of reward token.
1520      */
1521     function depositRewards(uint _amount) external onlyOwner nonReentrant {
1522         require(_amount > 0);
1523 
1524         uint256 beforeAmt = IERC20(rewardsToken).balanceOf(address(this));
1525         IERC20(rewardsToken).safeTransferFrom(msg.sender, address(this), _amount);
1526         uint256 afterAmt = IERC20(rewardsToken).balanceOf(address(this));
1527 
1528         totalEarnedTokenDeposed = totalEarnedTokenDeposed.add(afterAmt).sub(beforeAmt);
1529     }
1530 
1531     /* +++
1532      * @notice It allows the admin to recover wrong tokens sent to the contract
1533      */
1534     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
1535         uint256 reserved;
1536 
1537         if (_tokenAddress == stakingToken) {
1538             for (uint256 j = 0; j < lockups.length; j++) {
1539                 Lockup storage lockup = lockups[j];
1540                 reserved = reserved.add(lockup.totalStaked);
1541             }
1542         }
1543 
1544         if (reserved > 0) {
1545             uint256 tokenBal = IERC20(_tokenAddress).balanceOf(address(this));
1546             require(_tokenAmount <= tokenBal.sub(reserved), "Insufficient balance");
1547         }
1548 
1549         if (_tokenAddress == address(0x0)) {
1550             payable(msg.sender).transfer(_tokenAmount);
1551         } else {
1552             IERC20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
1553         }
1554 
1555         emit AdminTokenRecovered(_tokenAddress, _tokenAmount);
1556     }
1557 
1558     /* +++ */
1559     function startReward() external onlyOwner {
1560         require(startBlock == 0, "Pool was already started");
1561 
1562         startBlock = _getSlot().add(1);
1563         bonusEndBlock = startBlock.add(duration.mul(DAY_LENGTH / slot));
1564 
1565         emit NewStartAndEndBlocks(startBlock, bonusEndBlock);
1566     }
1567 
1568     /* +++ */
1569     function stopReward() external onlyOwner {
1570         bonusEndBlock = _getSlot();
1571     }
1572 
1573     /* +++
1574      * @notice Update pool
1575      * @dev Only callable by owner.
1576      */
1577     function updatePoolLimitPerUser(bool _hasUserLimit, uint256 _poolLimitPerUser) external onlyOwner {
1578         hasUserLimit = _hasUserLimit;
1579         if (_hasUserLimit) {
1580             poolLimitPerUser = _poolLimitPerUser;
1581         } else {
1582             poolLimitPerUser = 0;
1583         }
1584         emit NewPoolLimit(hasUserLimit, poolLimitPerUser);
1585     }
1586 
1587     /* +++ */
1588     function updateLockup(uint8 _stakeType, uint256 _duration, uint256 _depositFee, uint256 _withdrawFee, uint256 _rate, bool _depositFeeReverse, bool _withdrawFeeReverse) external onlyOwner {
1589         require(_stakeType < lockups.length, "Lockup Not found");
1590         require(_depositFee < 2000, "Invalid deposit fee");
1591         require(_withdrawFee < 2000, "Invalid withdraw fee");
1592 
1593         Lockup storage _lockup = lockups[_stakeType];
1594         // require(_lockup.totalStaked == 0, "Lockup already staked");
1595 
1596         if(_lockup.totalStaked == 0){
1597             _lockup.duration = _duration;
1598             _lockup.rate = _rate;
1599         }
1600 
1601         _lockup.depositFee = _depositFee;
1602         _lockup.withdrawFee = _withdrawFee;
1603         _lockup.depositFeeReverse = _depositFeeReverse;
1604         _lockup.withdrawFeeReverse = _withdrawFeeReverse;
1605 
1606         emit LockupUpdated(_stakeType, _lockup.duration, _depositFee, _withdrawFee, _lockup.rate, _depositFeeReverse, _withdrawFeeReverse);
1607     }
1608 
1609     /* +++ */
1610     function addLockup(uint256 _duration, uint256 _depositFee, uint256 _withdrawFee, uint256 _rate, bool _depositFeeReverse, bool _withdrawFeeReverse) external onlyOwner {
1611         require(_depositFee < 2000, "Invalid deposit fee");
1612         require(_withdrawFee < 2000, "Invalid withdraw fee");
1613 
1614         lockups.push();
1615 
1616         Lockup storage _lockup = lockups[lockups.length - 1];
1617         _lockup.duration = _duration;
1618         _lockup.depositFee = _depositFee;
1619         _lockup.withdrawFee = _withdrawFee;
1620         _lockup.rate = _rate;
1621         _lockup.depositFeeReverse = _depositFeeReverse;
1622         _lockup.withdrawFeeReverse = _withdrawFeeReverse;
1623 
1624         emit LockupUpdated(uint8(lockups.length - 1), _duration, _depositFee, _withdrawFee, _rate, _depositFeeReverse, _withdrawFeeReverse);
1625     }
1626 
1627     /* +++ */
1628     function setDuration(uint256 _duration) external onlyOwner {
1629         require(startBlock == 0, "Pool was already started");
1630         require(_duration >= 30, "lower limit reached");
1631 
1632         duration = _duration;
1633         emit DurationUpdated(_duration);
1634     }
1635 
1636     /* +++ */
1637     function setSettings(
1638         address _feeAddr
1639     ) external onlyOwner {
1640         require(_feeAddr != address(0x0), "Invalid Address");
1641         walletA = _feeAddr;
1642 
1643         emit SetSettings(_feeAddr);
1644     }
1645 
1646     /* +++
1647      * @notice Return reward rate per slot.
1648      */
1649     function _getRate(uint256 _rate)
1650     internal
1651     view
1652     returns (uint256)
1653     {
1654 
1655         // uint256 rate = _rate.mul(10 ** 20).div(365).div(DAY_LENGTH / slot);
1656         uint256 rate = _rate.mul(10 ** 24).div(DAY_LENGTH / slot);
1657         return rate;
1658 
1659     }
1660 
1661     /* +++
1662      * @notice Return reward multiplier over the given _from to _to block.
1663      */
1664     function _getMultiplier(uint256 _from, uint256 _to)
1665     internal
1666     view
1667     returns (uint256)
1668     {
1669         if (_from >= bonusEndBlock) {
1670             return 0;
1671         } else if (_to <= bonusEndBlock) {
1672             return _to.sub(_from);
1673         } else {
1674             return bonusEndBlock.sub(_from);
1675         }
1676     }
1677 
1678     /* +++ */
1679     function _getSlot()
1680     internal
1681     view
1682     returns (uint256 _slot)
1683     {
1684         _slot = block.timestamp.div(slot);
1685     }
1686 
1687 
1688 receive() external payable {}
1689 }