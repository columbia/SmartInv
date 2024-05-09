1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor() {
23         _transferOwnership(_msgSender());
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         _checkOwner();
31         _;
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if the sender is not the owner.
43      */
44     function _checkOwner() internal view virtual {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * NOTE: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public virtual onlyOwner {
56         _transferOwnership(address(0));
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Internal function without access restriction.
71      */
72     function _transferOwnership(address newOwner) internal virtual {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 abstract contract ReentrancyGuard {
80     // Booleans are more expensive than uint256 or any type that takes up a full
81     // word because each write operation emits an extra SLOAD to first read the
82     // slot's contents, replace the bits taken up by the boolean, and then write
83     // back. This is the compiler's defense against contract upgrades and
84     // pointer aliasing, and it cannot be disabled.
85 
86     // The values being non-zero value makes deployment a bit more expensive,
87     // but in exchange the refund on every call to nonReentrant will be lower in
88     // amount. Since refunds are capped to a percentage of the total
89     // transaction's gas, it is best to keep them low in cases like this one, to
90     // increase the likelihood of the full refund coming into effect.
91     uint256 private constant _NOT_ENTERED = 1;
92     uint256 private constant _ENTERED = 2;
93 
94     uint256 private _status;
95 
96     constructor() {
97         _status = _NOT_ENTERED;
98     }
99 
100     /**
101      * @dev Prevents a contract from calling itself, directly or indirectly.
102      * Calling a `nonReentrant` function from another `nonReentrant`
103      * function is not supported. It is possible to prevent this from happening
104      * by making the `nonReentrant` function external, and making it call a
105      * `private` function that does the actual work.
106      */
107     modifier nonReentrant() {
108         _nonReentrantBefore();
109         _;
110         _nonReentrantAfter();
111     }
112 
113     function _nonReentrantBefore() private {
114         // On the first call to nonReentrant, _status will be _NOT_ENTERED
115         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
116 
117         // Any calls to nonReentrant after this point will fail
118         _status = _ENTERED;
119     }
120 
121     function _nonReentrantAfter() private {
122         // By storing the original value once again, a refund is triggered (see
123         // https://eips.ethereum.org/EIPS/eip-2200)
124         _status = _NOT_ENTERED;
125     }
126 }
127 
128 interface IERC20Permit {
129     /**
130      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
131      * given ``owner``'s signed approval.
132      *
133      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
134      * ordering also apply here.
135      *
136      * Emits an {Approval} event.
137      *
138      * Requirements:
139      *
140      * - `spender` cannot be the zero address.
141      * - `deadline` must be a timestamp in the future.
142      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
143      * over the EIP712-formatted function arguments.
144      * - the signature must use ``owner``'s current nonce (see {nonces}).
145      *
146      * For more information on the signature format, see the
147      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
148      * section].
149      */
150     function permit(
151         address owner,
152         address spender,
153         uint256 value,
154         uint256 deadline,
155         uint8 v,
156         bytes32 r,
157         bytes32 s
158     ) external;
159 
160     /**
161      * @dev Returns the current nonce for `owner`. This value must be
162      * included whenever a signature is generated for {permit}.
163      *
164      * Every successful call to {permit} increases ``owner``'s nonce by one. This
165      * prevents a signature from being used multiple times.
166      */
167     function nonces(address owner) external view returns (uint256);
168 
169     /**
170      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
171      */
172     // solhint-disable-next-line func-name-mixedcase
173     function DOMAIN_SEPARATOR() external view returns (bytes32);
174 }
175 
176 interface IERC20 {
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184 
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to {approve}. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 
191     /**
192      * @dev Returns the amount of tokens in existence.
193      */
194     function totalSupply() external view returns (uint256);
195 
196     /**
197      * @dev Returns the amount of tokens owned by `account`.
198      */
199     function balanceOf(address account) external view returns (uint256);
200 
201     /**
202      * @dev Moves `amount` tokens from the caller's account to `to`.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transfer(address to, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Returns the remaining number of tokens that `spender` will be
212      * allowed to spend on behalf of `owner` through {transferFrom}. This is
213      * zero by default.
214      *
215      * This value changes when {approve} or {transferFrom} are called.
216      */
217     function allowance(address owner, address spender) external view returns (uint256);
218 
219     /**
220      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * IMPORTANT: Beware that changing an allowance with this method brings the risk
225      * that someone may use both the old and the new allowance by unfortunate
226      * transaction ordering. One possible solution to mitigate this race
227      * condition is to first reduce the spender's allowance to 0 and set the
228      * desired value afterwards:
229      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230      *
231      * Emits an {Approval} event.
232      */
233     function approve(address spender, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Moves `amount` tokens from `from` to `to` using the
237      * allowance mechanism. `amount` is then deducted from the caller's
238      * allowance.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transferFrom(
245         address from,
246         address to,
247         uint256 amount
248     ) external returns (bool);
249 }
250 
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      *
269      * [IMPORTANT]
270      * ====
271      * You shouldn't rely on `isContract` to protect against flash loan attacks!
272      *
273      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
274      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
275      * constructor.
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies on extcodesize/address.code.length, which returns 0
280         // for contracts in construction, since the code is only stored at the end
281         // of the constructor execution.
282 
283         return account.code.length > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         (bool success, ) = recipient.call{value: amount}("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain `call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         (bool success, bytes memory returndata) = target.call{value: value}(data);
378         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
388         return functionStaticCall(target, data, "Address: low-level static call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal view returns (bytes memory) {
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         (bool success, bytes memory returndata) = target.delegatecall(data);
428         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
433      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
434      *
435      * _Available since v4.8._
436      */
437     function verifyCallResultFromTarget(
438         address target,
439         bool success,
440         bytes memory returndata,
441         string memory errorMessage
442     ) internal view returns (bytes memory) {
443         if (success) {
444             if (returndata.length == 0) {
445                 // only check isContract if the call was successful and the return data is empty
446                 // otherwise we already know that it was a contract
447                 require(isContract(target), "Address: call to non-contract");
448             }
449             return returndata;
450         } else {
451             _revert(returndata, errorMessage);
452         }
453     }
454 
455     /**
456      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
457      * revert reason or using the provided one.
458      *
459      * _Available since v4.3._
460      */
461     function verifyCallResult(
462         bool success,
463         bytes memory returndata,
464         string memory errorMessage
465     ) internal pure returns (bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             _revert(returndata, errorMessage);
470         }
471     }
472 
473     function _revert(bytes memory returndata, string memory errorMessage) private pure {
474         // Look for revert reason and bubble it up if present
475         if (returndata.length > 0) {
476             // The easiest way to bubble the revert reason is using memory via assembly
477             /// @solidity memory-safe-assembly
478             assembly {
479                 let returndata_size := mload(returndata)
480                 revert(add(32, returndata), returndata_size)
481             }
482         } else {
483             revert(errorMessage);
484         }
485     }
486 }
487 
488 library SafeERC20 {
489     using Address for address;
490 
491     function safeTransfer(
492         IERC20 token,
493         address to,
494         uint256 value
495     ) internal {
496         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
497     }
498 
499     function safeTransferFrom(
500         IERC20 token,
501         address from,
502         address to,
503         uint256 value
504     ) internal {
505         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
506     }
507 
508     /**
509      * @dev Deprecated. This function has issues similar to the ones found in
510      * {IERC20-approve}, and its usage is discouraged.
511      *
512      * Whenever possible, use {safeIncreaseAllowance} and
513      * {safeDecreaseAllowance} instead.
514      */
515     function safeApprove(
516         IERC20 token,
517         address spender,
518         uint256 value
519     ) internal {
520         // safeApprove should only be called when setting an initial allowance,
521         // or when resetting it to zero. To increase and decrease it, use
522         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
523         require(
524             (value == 0) || (token.allowance(address(this), spender) == 0),
525             "SafeERC20: approve from non-zero to non-zero allowance"
526         );
527         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
528     }
529 
530     function safeIncreaseAllowance(
531         IERC20 token,
532         address spender,
533         uint256 value
534     ) internal {
535         uint256 newAllowance = token.allowance(address(this), spender) + value;
536         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
537     }
538 
539     function safeDecreaseAllowance(
540         IERC20 token,
541         address spender,
542         uint256 value
543     ) internal {
544         unchecked {
545             uint256 oldAllowance = token.allowance(address(this), spender);
546             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
547             uint256 newAllowance = oldAllowance - value;
548             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
549         }
550     }
551 
552     function safePermit(
553         IERC20Permit token,
554         address owner,
555         address spender,
556         uint256 value,
557         uint256 deadline,
558         uint8 v,
559         bytes32 r,
560         bytes32 s
561     ) internal {
562         uint256 nonceBefore = token.nonces(owner);
563         token.permit(owner, spender, value, deadline, v, r, s);
564         uint256 nonceAfter = token.nonces(owner);
565         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
566     }
567 
568     /**
569      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
570      * on the return value: the return value is optional (but if data is returned, it must not be false).
571      * @param token The token targeted by the call.
572      * @param data The call data (encoded using abi.encode or one of its variants).
573      */
574     function _callOptionalReturn(IERC20 token, bytes memory data) private {
575         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
576         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
577         // the target address contains contract code and also asserts for success in the low-level call.
578 
579         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
580         if (returndata.length > 0) {
581             // Return data is optional
582             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
583         }
584     }
585 }
586 
587 library SafeMath {
588     /**
589      * @dev Returns the addition of two unsigned integers, with an overflow flag.
590      *
591      * _Available since v3.4._
592      */
593     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
594         unchecked {
595             uint256 c = a + b;
596             if (c < a) return (false, 0);
597             return (true, c);
598         }
599     }
600 
601     /**
602      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
603      *
604      * _Available since v3.4._
605      */
606     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
607         unchecked {
608             if (b > a) return (false, 0);
609             return (true, a - b);
610         }
611     }
612 
613     /**
614      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
615      *
616      * _Available since v3.4._
617      */
618     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
619         unchecked {
620             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
621             // benefit is lost if 'b' is also tested.
622             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
623             if (a == 0) return (true, 0);
624             uint256 c = a * b;
625             if (c / a != b) return (false, 0);
626             return (true, c);
627         }
628     }
629 
630     /**
631      * @dev Returns the division of two unsigned integers, with a division by zero flag.
632      *
633      * _Available since v3.4._
634      */
635     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
636         unchecked {
637             if (b == 0) return (false, 0);
638             return (true, a / b);
639         }
640     }
641 
642     /**
643      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
644      *
645      * _Available since v3.4._
646      */
647     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
648         unchecked {
649             if (b == 0) return (false, 0);
650             return (true, a % b);
651         }
652     }
653 
654     /**
655      * @dev Returns the addition of two unsigned integers, reverting on
656      * overflow.
657      *
658      * Counterpart to Solidity's `+` operator.
659      *
660      * Requirements:
661      *
662      * - Addition cannot overflow.
663      */
664     function add(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a + b;
666     }
667 
668     /**
669      * @dev Returns the subtraction of two unsigned integers, reverting on
670      * overflow (when the result is negative).
671      *
672      * Counterpart to Solidity's `-` operator.
673      *
674      * Requirements:
675      *
676      * - Subtraction cannot overflow.
677      */
678     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a - b;
680     }
681 
682     /**
683      * @dev Returns the multiplication of two unsigned integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `*` operator.
687      *
688      * Requirements:
689      *
690      * - Multiplication cannot overflow.
691      */
692     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
693         return a * b;
694     }
695 
696     /**
697      * @dev Returns the integer division of two unsigned integers, reverting on
698      * division by zero. The result is rounded towards zero.
699      *
700      * Counterpart to Solidity's `/` operator.
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function div(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a / b;
708     }
709 
710     /**
711      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
712      * reverting when dividing by zero.
713      *
714      * Counterpart to Solidity's `%` operator. This function uses a `revert`
715      * opcode (which leaves remaining gas untouched) while Solidity uses an
716      * invalid opcode to revert (consuming all remaining gas).
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
723         return a % b;
724     }
725 
726     /**
727      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
728      * overflow (when the result is negative).
729      *
730      * CAUTION: This function is deprecated because it requires allocating memory for the error
731      * message unnecessarily. For custom revert reasons use {trySub}.
732      *
733      * Counterpart to Solidity's `-` operator.
734      *
735      * Requirements:
736      *
737      * - Subtraction cannot overflow.
738      */
739     function sub(
740         uint256 a,
741         uint256 b,
742         string memory errorMessage
743     ) internal pure returns (uint256) {
744         unchecked {
745             require(b <= a, errorMessage);
746             return a - b;
747         }
748     }
749 
750     /**
751      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
752      * division by zero. The result is rounded towards zero.
753      *
754      * Counterpart to Solidity's `/` operator. Note: this function uses a
755      * `revert` opcode (which leaves remaining gas untouched) while Solidity
756      * uses an invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function div(
763         uint256 a,
764         uint256 b,
765         string memory errorMessage
766     ) internal pure returns (uint256) {
767         unchecked {
768             require(b > 0, errorMessage);
769             return a / b;
770         }
771     }
772 
773     /**
774      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
775      * reverting with custom message when dividing by zero.
776      *
777      * CAUTION: This function is deprecated because it requires allocating memory for the error
778      * message unnecessarily. For custom revert reasons use {tryMod}.
779      *
780      * Counterpart to Solidity's `%` operator. This function uses a `revert`
781      * opcode (which leaves remaining gas untouched) while Solidity uses an
782      * invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function mod(
789         uint256 a,
790         uint256 b,
791         string memory errorMessage
792     ) internal pure returns (uint256) {
793         unchecked {
794             require(b > 0, errorMessage);
795             return a % b;
796         }
797     }
798 }
799 
800 library Math {
801     enum Rounding {
802         Down, // Toward negative infinity
803         Up, // Toward infinity
804         Zero // Toward zero
805     }
806 
807     /**
808      * @dev Returns the largest of two numbers.
809      */
810     function max(uint256 a, uint256 b) internal pure returns (uint256) {
811         return a > b ? a : b;
812     }
813 
814     /**
815      * @dev Returns the smallest of two numbers.
816      */
817     function min(uint256 a, uint256 b) internal pure returns (uint256) {
818         return a < b ? a : b;
819     }
820 
821     /**
822      * @dev Returns the average of two numbers. The result is rounded towards
823      * zero.
824      */
825     function average(uint256 a, uint256 b) internal pure returns (uint256) {
826         // (a + b) / 2 can overflow.
827         return (a & b) + (a ^ b) / 2;
828     }
829 
830     /**
831      * @dev Returns the ceiling of the division of two numbers.
832      *
833      * This differs from standard division with `/` in that it rounds up instead
834      * of rounding down.
835      */
836     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
837         // (a + b - 1) / b can overflow on addition, so we distribute.
838         return a == 0 ? 0 : (a - 1) / b + 1;
839     }
840 
841     /**
842      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
843      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
844      * with further edits by Uniswap Labs also under MIT license.
845      */
846     function mulDiv(
847         uint256 x,
848         uint256 y,
849         uint256 denominator
850     ) internal pure returns (uint256 result) {
851         unchecked {
852             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
853             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
854             // variables such that product = prod1 * 2^256 + prod0.
855             uint256 prod0; // Least significant 256 bits of the product
856             uint256 prod1; // Most significant 256 bits of the product
857             assembly {
858                 let mm := mulmod(x, y, not(0))
859                 prod0 := mul(x, y)
860                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
861             }
862 
863             // Handle non-overflow cases, 256 by 256 division.
864             if (prod1 == 0) {
865                 return prod0 / denominator;
866             }
867 
868             // Make sure the result is less than 2^256. Also prevents denominator == 0.
869             require(denominator > prod1);
870 
871             ///////////////////////////////////////////////
872             // 512 by 256 division.
873             ///////////////////////////////////////////////
874 
875             // Make division exact by subtracting the remainder from [prod1 prod0].
876             uint256 remainder;
877             assembly {
878                 // Compute remainder using mulmod.
879                 remainder := mulmod(x, y, denominator)
880 
881                 // Subtract 256 bit number from 512 bit number.
882                 prod1 := sub(prod1, gt(remainder, prod0))
883                 prod0 := sub(prod0, remainder)
884             }
885 
886             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
887             // See https://cs.stackexchange.com/q/138556/92363.
888 
889             // Does not overflow because the denominator cannot be zero at this stage in the function.
890             uint256 twos = denominator & (~denominator + 1);
891             assembly {
892                 // Divide denominator by twos.
893                 denominator := div(denominator, twos)
894 
895                 // Divide [prod1 prod0] by twos.
896                 prod0 := div(prod0, twos)
897 
898                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
899                 twos := add(div(sub(0, twos), twos), 1)
900             }
901 
902             // Shift in bits from prod1 into prod0.
903             prod0 |= prod1 * twos;
904 
905             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
906             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
907             // four bits. That is, denominator * inv = 1 mod 2^4.
908             uint256 inverse = (3 * denominator) ^ 2;
909 
910             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
911             // in modular arithmetic, doubling the correct bits in each step.
912             inverse *= 2 - denominator * inverse; // inverse mod 2^8
913             inverse *= 2 - denominator * inverse; // inverse mod 2^16
914             inverse *= 2 - denominator * inverse; // inverse mod 2^32
915             inverse *= 2 - denominator * inverse; // inverse mod 2^64
916             inverse *= 2 - denominator * inverse; // inverse mod 2^128
917             inverse *= 2 - denominator * inverse; // inverse mod 2^256
918 
919             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
920             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
921             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
922             // is no longer required.
923             result = prod0 * inverse;
924             return result;
925         }
926     }
927 
928     /**
929      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
930      */
931     function mulDiv(
932         uint256 x,
933         uint256 y,
934         uint256 denominator,
935         Rounding rounding
936     ) internal pure returns (uint256) {
937         uint256 result = mulDiv(x, y, denominator);
938         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
939             result += 1;
940         }
941         return result;
942     }
943 
944     /**
945      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
946      *
947      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
948      */
949     function sqrt(uint256 a) internal pure returns (uint256) {
950         if (a == 0) {
951             return 0;
952         }
953 
954         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
955         //
956         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
957         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
958         //
959         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
960         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
961         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
962         //
963         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
964         uint256 result = 1 << (log2(a) >> 1);
965 
966         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
967         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
968         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
969         // into the expected uint128 result.
970         unchecked {
971             result = (result + a / result) >> 1;
972             result = (result + a / result) >> 1;
973             result = (result + a / result) >> 1;
974             result = (result + a / result) >> 1;
975             result = (result + a / result) >> 1;
976             result = (result + a / result) >> 1;
977             result = (result + a / result) >> 1;
978             return min(result, a / result);
979         }
980     }
981 
982     /**
983      * @notice Calculates sqrt(a), following the selected rounding direction.
984      */
985     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
986         unchecked {
987             uint256 result = sqrt(a);
988             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
989         }
990     }
991 
992     /**
993      * @dev Return the log in base 2, rounded down, of a positive value.
994      * Returns 0 if given 0.
995      */
996     function log2(uint256 value) internal pure returns (uint256) {
997         uint256 result = 0;
998         unchecked {
999             if (value >> 128 > 0) {
1000                 value >>= 128;
1001                 result += 128;
1002             }
1003             if (value >> 64 > 0) {
1004                 value >>= 64;
1005                 result += 64;
1006             }
1007             if (value >> 32 > 0) {
1008                 value >>= 32;
1009                 result += 32;
1010             }
1011             if (value >> 16 > 0) {
1012                 value >>= 16;
1013                 result += 16;
1014             }
1015             if (value >> 8 > 0) {
1016                 value >>= 8;
1017                 result += 8;
1018             }
1019             if (value >> 4 > 0) {
1020                 value >>= 4;
1021                 result += 4;
1022             }
1023             if (value >> 2 > 0) {
1024                 value >>= 2;
1025                 result += 2;
1026             }
1027             if (value >> 1 > 0) {
1028                 result += 1;
1029             }
1030         }
1031         return result;
1032     }
1033 
1034     /**
1035      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1036      * Returns 0 if given 0.
1037      */
1038     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1039         unchecked {
1040             uint256 result = log2(value);
1041             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1042         }
1043     }
1044 
1045     /**
1046      * @dev Return the log in base 10, rounded down, of a positive value.
1047      * Returns 0 if given 0.
1048      */
1049     function log10(uint256 value) internal pure returns (uint256) {
1050         uint256 result = 0;
1051         unchecked {
1052             if (value >= 10**64) {
1053                 value /= 10**64;
1054                 result += 64;
1055             }
1056             if (value >= 10**32) {
1057                 value /= 10**32;
1058                 result += 32;
1059             }
1060             if (value >= 10**16) {
1061                 value /= 10**16;
1062                 result += 16;
1063             }
1064             if (value >= 10**8) {
1065                 value /= 10**8;
1066                 result += 8;
1067             }
1068             if (value >= 10**4) {
1069                 value /= 10**4;
1070                 result += 4;
1071             }
1072             if (value >= 10**2) {
1073                 value /= 10**2;
1074                 result += 2;
1075             }
1076             if (value >= 10**1) {
1077                 result += 1;
1078             }
1079         }
1080         return result;
1081     }
1082 
1083     /**
1084      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1085      * Returns 0 if given 0.
1086      */
1087     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1088         unchecked {
1089             uint256 result = log10(value);
1090             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1091         }
1092     }
1093 
1094     /**
1095      * @dev Return the log in base 256, rounded down, of a positive value.
1096      * Returns 0 if given 0.
1097      *
1098      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1099      */
1100     function log256(uint256 value) internal pure returns (uint256) {
1101         uint256 result = 0;
1102         unchecked {
1103             if (value >> 128 > 0) {
1104                 value >>= 128;
1105                 result += 16;
1106             }
1107             if (value >> 64 > 0) {
1108                 value >>= 64;
1109                 result += 8;
1110             }
1111             if (value >> 32 > 0) {
1112                 value >>= 32;
1113                 result += 4;
1114             }
1115             if (value >> 16 > 0) {
1116                 value >>= 16;
1117                 result += 2;
1118             }
1119             if (value >> 8 > 0) {
1120                 result += 1;
1121             }
1122         }
1123         return result;
1124     }
1125 
1126     /**
1127      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1128      * Returns 0 if given 0.
1129      */
1130     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1131         unchecked {
1132             uint256 result = log256(value);
1133             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1134         }
1135     }
1136 }
1137 
1138 interface IERC165 {
1139     /**
1140      * @dev Returns true if this contract implements the interface defined by
1141      * `interfaceId`. See the corresponding
1142      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1143      * to learn more about how these ids are created.
1144      *
1145      * This function call must use less than 30 000 gas.
1146      */
1147     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1148 }
1149 
1150 interface IERC721 is IERC165 {
1151     /**
1152      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1153      */
1154     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1155 
1156     /**
1157      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1158      */
1159     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1160 
1161     /**
1162      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1163      */
1164     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1165 
1166     /**
1167      * @dev Returns the number of tokens in ``owner``'s account.
1168      */
1169     function balanceOf(address owner) external view returns (uint256 balance);
1170 
1171     /**
1172      * @dev Returns the owner of the `tokenId` token.
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must exist.
1177      */
1178     function ownerOf(uint256 tokenId) external view returns (address owner);
1179 
1180     /**
1181      * @dev Safely transfers `tokenId` token from `from` to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `from` cannot be the zero address.
1186      * - `to` cannot be the zero address.
1187      * - `tokenId` token must exist and be owned by `from`.
1188      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function safeTransferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId,
1197         bytes calldata data
1198     ) external;
1199 
1200     /**
1201      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1202      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1203      *
1204      * Requirements:
1205      *
1206      * - `from` cannot be the zero address.
1207      * - `to` cannot be the zero address.
1208      * - `tokenId` token must exist and be owned by `from`.
1209      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function safeTransferFrom(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) external;
1219 
1220     /**
1221      * @dev Transfers `tokenId` token from `from` to `to`.
1222      *
1223      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1224      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1225      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1226      *
1227      * Requirements:
1228      *
1229      * - `from` cannot be the zero address.
1230      * - `to` cannot be the zero address.
1231      * - `tokenId` token must be owned by `from`.
1232      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function transferFrom(
1237         address from,
1238         address to,
1239         uint256 tokenId
1240     ) external;
1241 
1242     /**
1243      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1244      * The approval is cleared when the token is transferred.
1245      *
1246      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1247      *
1248      * Requirements:
1249      *
1250      * - The caller must own the token or be an approved operator.
1251      * - `tokenId` must exist.
1252      *
1253      * Emits an {Approval} event.
1254      */
1255     function approve(address to, uint256 tokenId) external;
1256 
1257     /**
1258      * @dev Approve or remove `operator` as an operator for the caller.
1259      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1260      *
1261      * Requirements:
1262      *
1263      * - The `operator` cannot be the caller.
1264      *
1265      * Emits an {ApprovalForAll} event.
1266      */
1267     function setApprovalForAll(address operator, bool _approved) external;
1268 
1269     /**
1270      * @dev Returns the account approved for `tokenId` token.
1271      *
1272      * Requirements:
1273      *
1274      * - `tokenId` must exist.
1275      */
1276     function getApproved(uint256 tokenId) external view returns (address operator);
1277 
1278     /**
1279      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1280      *
1281      * See {setApprovalForAll}
1282      */
1283     function isApprovedForAll(address owner, address operator) external view returns (bool);
1284 }
1285 
1286 interface IERC721Receiver {
1287     /**
1288      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1289      * by `operator` from `from`, this function is called.
1290      *
1291      * It must return its Solidity selector to confirm the token transfer.
1292      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1293      *
1294      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1295      */
1296     function onERC721Received(
1297         address operator,
1298         address from,
1299         uint256 tokenId,
1300         bytes calldata data
1301     ) external returns (bytes4);
1302 }
1303 
1304 
1305 contract SquidGrowStaking is Ownable, ReentrancyGuard, IERC721Receiver {
1306     using SafeERC20 for IERC20;
1307     using SafeMath for uint256;
1308 
1309     // Info of each user.
1310     struct UserInfo {
1311         uint256 amount;         // How many LP tokens the user has provided.
1312         uint256 rewardDebt;     // Reward debt. See explanation below.
1313         uint256 pendingReward;     // pending reward
1314         uint256 nftStaked;      // number of NFT staked
1315         uint256 lastRewardBlock; // last block when reward was claimed.
1316     }
1317 
1318     // Info of each pool. This contract has several reward method. First method is one that has reward per block and Second method has fixed apr.
1319     struct PoolInfo {
1320         IERC20 stakedToken;           // Address of staked token contract.
1321         uint256 allocPoint;       // How many allocation points assigned to this pool. Squidgrows to distribute per block.
1322         uint256 lastRewardBlock;  // Last block number that Squidgrows distribution occurs.
1323         uint256 accSquidgrowPerShare;   // Accumulated Squidgrows per share, times 1e13. See below.
1324         uint256 totalStaked;
1325     }
1326 
1327     struct StakedNft {
1328         address staker;
1329         uint256 tokenId;
1330         address collection;
1331     }
1332 
1333     // NFT Staker info
1334     struct NftStaker {
1335         // Amount of tokens staked by the staker
1336         uint256 amountStaked;
1337 
1338         // Staked token ids
1339         StakedNft[] stakedNfts;        
1340     }
1341 
1342     struct Checkpoint {
1343         uint256 blockNumber;                    // blocknumber for checkpoint
1344         uint256 accSquidgrowPerSquidgrow;
1345         bool isToggleCheckpoint;                // true -> nftBoostToggle checkpoint ; false -> nft whitelist checkpoint
1346         bool state;                             // true -> boost enabled / collection whitelisted  ; false -> boost disabled, collection unwhitelisted
1347         address collection;                     // address of collection whitelisted.
1348     }
1349 
1350     // The Squidgrow TOKEN!
1351     IERC20 public Squidgrow;
1352     address private feeAddress;
1353     uint256 public squidStakingPoolId = 0;
1354 
1355     // Squidgrow tokens created per block.
1356     uint256 public SquidgrowPerBlock;
1357 
1358     // Toggle reward harvesting without withdrawing all the staked tokens.
1359     bool public isHarvestingEnabled = true;
1360 
1361     // Info of each pool.
1362     PoolInfo[] public poolInfo;
1363 
1364     // Info of each user that stakes tokens.
1365     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1366 
1367 
1368     // whitelist info for fee
1369     mapping(address => bool) public isWhiteListed;
1370 
1371     // blacklist info for reward
1372     mapping(address => bool) public isBlackListed;
1373 
1374     // Total allocation points. Must be the sum of all allocation points in all pools.
1375     uint256 public totalAllocPoint = 0;
1376 
1377     // Max fee rate: 10%.
1378     uint16 public constant MAXIMUM_FEE_RATE = 1000;
1379 
1380     // whitlisted NFTs for staking
1381     mapping(address => bool) public isNftWhitelisted;
1382 
1383     address [] public whitelistedNFTs;
1384 
1385     Checkpoint [] public checkpoints;
1386 
1387 
1388     // owner of staked NFTs (collection => tokenId => owner)
1389     mapping(address => mapping (uint256 => address)) public vault;
1390 
1391     // info of staked NFT ( user => NftStaker)
1392     mapping(address  => NftStaker) public stakedNfts;
1393 
1394     // // count of nft staked (staker => collection => count)
1395     mapping(address => mapping(address => uint256)) public nftStaked;
1396 
1397     // On/Off Nft staking
1398     bool public nftBoostEnabled = true;
1399 
1400     // Boost reward % on staking NFTs
1401     uint256 public boostAPRPerNft = 200; // 20%
1402     // The block number when SQUID mining starts.
1403     uint256 immutable public startBlock;
1404 
1405     uint256 depositTax = 200;
1406     uint256 withdrawTax = 200;
1407     uint256 harvestTax = 600;
1408 
1409     event PoolAdded(uint256 indexed poolId, address indexed stakedToken, uint256 allocPoint, uint256 totalAllocPoint);
1410     event PoolUpdated(uint256 indexed poolId, uint256 allocPoint, uint256 totalAllocPoint);
1411     event WhitelistedNFT(address indexed nftCollection);
1412     event UnwhitelistedNFT(address indexed nftCollection);
1413     event Deposited(address indexed user, uint256 indexed poolId, uint256 amount);
1414     event Harvested(address indexed user, uint256 indexed poolId, uint256 amount);
1415     event Withdrawn(address indexed user, uint256 indexed poolId, uint256 amount);
1416     event DepositedNFTs(address indexed user, address indexed nftCollection, uint256 amount);
1417     event WithdrawnNFTs(address indexed user, address indexed nftCollection, uint256 amount);
1418     event WithdrawnAllNFTs(address indexed user, uint256 amount);
1419     event EmergencyWithdrawn(address indexed user, uint256 indexed poolId);
1420     event UpdatedEmissionRate(uint256 oldEmissionRate, uint256 newEmissionRate);
1421     event Whitelisted(address indexed user);
1422     event Unwhitelisted(address indexed user);
1423     event Blacklisted(address indexed user);
1424     event Unblacklisted(address indexed user);
1425     event NftBoostingEnabled(uint256 accSquidgrowPerSquidgrow);
1426     event NftBoostingDisabled(uint256 accSquidgrowPerSquidgrow);
1427     event BoostAPRPerNftUpdated(uint256 oldBoostAPR, uint256 newBoostAPR);
1428     event StakingTaxUpdated(uint256 withdrawTax, uint256 depositTax, uint256 harvestTax);
1429     event FeeAddressUpdated(address oldFeeAddress, address newFeeAddress);
1430     event UnsupportedTokenRecovered(address indexed receiver, address indexed token, uint256 amount);
1431     event HarvestingEnabled();
1432     event HarvestingDisabled();
1433     event UpdatedSquidgrowAddress(address squidgrow);
1434 
1435     constructor(
1436         IERC20 _squidgrow,
1437         address _feeAddress,
1438         uint256 _squidPerBlock,
1439         uint256 _startBlock
1440     ) {
1441         require(address(_squidgrow) != address(0), "Can't be zero address");
1442         Squidgrow = _squidgrow;
1443         feeAddress = _feeAddress;
1444         SquidgrowPerBlock = _squidPerBlock;
1445         startBlock = _startBlock;
1446 
1447         // staking pool
1448         poolInfo.push(PoolInfo({
1449             stakedToken: _squidgrow,
1450             allocPoint: 1000,
1451             lastRewardBlock: startBlock,
1452             accSquidgrowPerShare: 0,
1453             totalStaked: 0
1454 
1455         }));
1456 
1457         totalAllocPoint = 1000;
1458 
1459         emit PoolAdded(0, address(_squidgrow), 1000, totalAllocPoint);
1460     }
1461 
1462     // Add a new token to the pool. Can only be called by the owner.
1463     // XXX DO NOT add the same token more than once. Rewards will be messed up if you do.
1464     function add(IERC20 _stakedToken, uint256 _allocPoint, bool _withUpdate) external onlyOwner {
1465         require(address(_stakedToken) != address(0), "Can't be zero address");
1466         if (_withUpdate) {
1467             massUpdatePools();
1468         }
1469 
1470         uint256 length = poolInfo.length;
1471         for (uint256 i = 0 ; i < length; i++) {
1472             require(poolInfo[i].stakedToken != _stakedToken, "Pool Already added");
1473         }
1474         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1475         totalAllocPoint = totalAllocPoint + _allocPoint;
1476         poolInfo.push(PoolInfo({
1477             stakedToken: _stakedToken,
1478             allocPoint: _allocPoint,
1479             lastRewardBlock: lastRewardBlock,
1480             accSquidgrowPerShare: 0,
1481             totalStaked: 0
1482         }));
1483 
1484         emit PoolAdded(poolInfo.length - 1, address(_stakedToken), _allocPoint, totalAllocPoint);
1485     }
1486 
1487     // Update the given pool's Squidgrow allocation point. Can only be called by the owner.
1488     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external onlyOwner {
1489         if (_withUpdate) {
1490             massUpdatePools();
1491         }
1492         uint256 prevAllocPoint = poolInfo[_pid].allocPoint;
1493         poolInfo[_pid].allocPoint = _allocPoint;
1494         if (prevAllocPoint != _allocPoint) {
1495             totalAllocPoint = totalAllocPoint - prevAllocPoint + _allocPoint;
1496         }
1497 
1498         emit PoolUpdated(_pid, _allocPoint, totalAllocPoint);
1499     }
1500 
1501     // Whitelist NFT colletion for staking (to boost SQUID pool reward)
1502     function whitelistNFT(address nftCollection) external onlyOwner {
1503         require(nftCollection != address(0), "Can't be zero address");
1504         require(!isNftWhitelisted[nftCollection], "Already whitlisted");
1505         isNftWhitelisted[nftCollection] = true;
1506         whitelistedNFTs.push(nftCollection);
1507         updatePool(squidStakingPoolId);
1508         Checkpoint memory newcheckpoint = Checkpoint (block.number, poolInfo[squidStakingPoolId].accSquidgrowPerShare, false, true, nftCollection);
1509         checkpoints.push(newcheckpoint);
1510 
1511         emit WhitelistedNFT(nftCollection);
1512     }
1513 
1514     function removeWhitelistNFT(address nftCollection) external onlyOwner {
1515         require(nftCollection != address(0), "Can't be zero address");
1516         require(isNftWhitelisted[nftCollection], "Already non - whitlisted");
1517         isNftWhitelisted[nftCollection] = false;
1518         uint256 length = whitelistedNFTs.length;
1519         for(uint256 i =0; i< length; i++) {
1520             if (whitelistedNFTs[i] == nftCollection) {
1521                 whitelistedNFTs[i] = whitelistedNFTs[length - 1];
1522                 break;
1523             }
1524         }
1525         whitelistedNFTs.pop();
1526         updatePool(squidStakingPoolId);
1527         Checkpoint memory newcheckpoint = Checkpoint (block.number, poolInfo[squidStakingPoolId].accSquidgrowPerShare, false, false, nftCollection);
1528         checkpoints.push(newcheckpoint);
1529 
1530         emit UnwhitelistedNFT(nftCollection);
1531     }
1532 
1533     // Return reward multiplier over the given _from to _to block.
1534     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1535         return _to - _from;
1536     }
1537 
1538     // View function to see pending Squidgrows on frontend.
1539     function pendingSquidgrow(uint256 _pid, address _user) external view returns (uint256) {
1540         PoolInfo memory pool = poolInfo[_pid];
1541         UserInfo memory user = userInfo[_pid][_user];
1542 
1543         
1544         uint256 accSquidgrowPerShare = pool.accSquidgrowPerShare;
1545         if (block.number > pool.lastRewardBlock && pool.totalStaked != 0) {
1546             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1547             uint256 SquidgrowReward = (multiplier * SquidgrowPerBlock * pool.allocPoint) / totalAllocPoint;
1548             accSquidgrowPerShare = accSquidgrowPerShare.add(SquidgrowReward.mul(1e13).div(pool.totalStaked));
1549         }
1550         uint256 equivalentAmount = getBoostEquivalentAmount(_user, _pid);
1551         uint256 pending = 0;
1552 
1553         if ( checkpoints.length!= 0 && user.lastRewardBlock <= checkpoints[checkpoints.length - 1].blockNumber && _pid == 0 && stakedNfts[msg.sender].amountStaked != 0) {
1554 
1555             uint256 index = checkpoints.length ;
1556             pending = equivalentAmount.mul(accSquidgrowPerShare).div(1e13).sub(equivalentAmount.mul(checkpoints[index -1].accSquidgrowPerSquidgrow).div(1e13));
1557             uint256 nftCount = _getWhitelistedNft(_user);
1558             uint256 boostedAmount = getBoostedAmount(user.amount, nftCount);
1559             bool boostEnable = nftBoostEnabled;
1560             for (uint256 i = index; i >= 1 ; --i) {
1561                 if(user.lastRewardBlock > checkpoints[i-1].blockNumber)
1562                     break;
1563                 
1564                 if(checkpoints[i-1].isToggleCheckpoint) {
1565                     boostEnable = !boostEnable;
1566                     if(boostEnable) {
1567                         pending += boostedAmount.mul(checkpoints[i-1].accSquidgrowPerSquidgrow).div(1e13).sub(i == 1 || user.lastRewardBlock > checkpoints[i-2].blockNumber ? user.rewardDebt: boostedAmount.mul(checkpoints[i - 2].accSquidgrowPerSquidgrow).div(1e13));
1568                     } else {
1569                         pending += user.amount.mul(checkpoints[i-1].accSquidgrowPerSquidgrow).div(1e13).sub( i == 1 || user.lastRewardBlock > checkpoints[i-2].blockNumber ?user.rewardDebt : user.amount.mul(checkpoints[i - 2].accSquidgrowPerSquidgrow).div(1e13));
1570                     }
1571                     
1572                 }else {
1573                     uint256 amount = nftStaked[_user][checkpoints[i-1].collection];
1574                     if(amount != 0) {
1575                         nftCount = checkpoints[i-1].state ? nftCount - amount : nftCount + amount;
1576                         boostedAmount = getBoostedAmount(user.amount, nftCount);
1577                     }
1578                     if(boostEnable) {
1579                         pending += boostedAmount.mul(checkpoints[i-1].accSquidgrowPerSquidgrow).div(1e13).sub(i == 1 || user.lastRewardBlock > checkpoints[i-2].blockNumber ? user.rewardDebt: boostedAmount.mul(checkpoints[i - 2].accSquidgrowPerSquidgrow).div(1e13));
1580                     } else {
1581                         pending += user.amount.mul(checkpoints[i-1].accSquidgrowPerSquidgrow).div(1e13).sub( i == 1 || user.lastRewardBlock > checkpoints[i-2].blockNumber ?user.rewardDebt : user.amount.mul(checkpoints[i - 2].accSquidgrowPerSquidgrow).div(1e13));
1582                     }
1583 
1584                 }
1585             }
1586         }else {
1587             pending = equivalentAmount.mul(accSquidgrowPerShare).div(1e13).sub(user.rewardDebt);
1588         }
1589         return pending + user.pendingReward;
1590 
1591     }
1592 
1593     // Update reward variables for all pools. Be careful of gas spending!
1594     function massUpdatePools() public {
1595         uint256 length = poolInfo.length;
1596         for (uint256 pid = 0; pid < length; ++pid) {
1597             updatePool(pid);
1598         }
1599     }
1600 
1601     // Update reward variables of the given pool to be up-to-date.
1602     function updatePool(uint256 _pid) public {
1603         PoolInfo storage pool = poolInfo[_pid];
1604         if (block.number <= pool.lastRewardBlock) {
1605             return;
1606         }
1607         if (pool.totalStaked == 0) {
1608             pool.lastRewardBlock = block.number;
1609             return;
1610         }
1611         uint256 accSquidgrowPerShare = pool.accSquidgrowPerShare;
1612         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1613 
1614         uint256 SquidgrowReward = multiplier.mul(SquidgrowPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1615 
1616 
1617         pool.accSquidgrowPerShare = accSquidgrowPerShare.add(SquidgrowReward.mul(1e13).div(pool.totalStaked));
1618         pool.lastRewardBlock = block.number;
1619 
1620     }
1621 
1622     // Deposit LP tokens to MasterChef for Squidgrow allocation.
1623     function deposit(uint256 _pid, uint256 _amount) public nonReentrant {
1624         require(!isBlackListed[msg.sender], "user is blacklisted");
1625         require(_amount > 0 , "zero amount");
1626         PoolInfo storage pool = poolInfo[_pid];
1627         UserInfo storage user = userInfo[_pid][msg.sender];
1628         updatePool(_pid);
1629 
1630         uint256 equivalentAmount = getBoostEquivalentAmount(msg.sender, _pid);
1631         uint256 pending = 0;
1632 
1633         if ( checkpoints.length!= 0 && user.lastRewardBlock <= checkpoints[checkpoints.length - 1].blockNumber && _pid == 0 && stakedNfts[msg.sender].amountStaked != 0) {
1634             pending = getPendingreward(pool, msg.sender, user);
1635         } else {
1636             pending = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13).sub(user.rewardDebt);
1637         }
1638         user.pendingReward += isHarvestingEnabled ? 0 : pending;
1639 
1640         if(pending > 0 && isHarvestingEnabled){
1641             if (!isWhiteListed[msg.sender]) {
1642                 uint256 harvestFee = pending.mul(harvestTax).div(10000);
1643                 pending = pending - harvestFee;
1644                 if(harvestFee > 0)
1645                     safeSquidgrowTransfer(feeAddress, harvestFee);
1646             }
1647 
1648             safeSquidgrowTransfer(msg.sender, pending);
1649         }   
1650 
1651         uint256 depositFee = 0;
1652 
1653         if (!isWhiteListed[msg.sender]) {
1654             depositFee = _amount.mul(depositTax).div(10000);
1655             if (depositFee > 0)
1656                 pool.stakedToken.safeTransferFrom(msg.sender, feeAddress, depositFee);
1657         }
1658                 
1659         uint256 balancebefore = pool.stakedToken.balanceOf(address(this));
1660 
1661         pool.stakedToken.safeTransferFrom(msg.sender, address(this), _amount - depositFee );
1662         // staked Tokens, might have transfer tax.
1663         uint256 amountReceived = pool.stakedToken.balanceOf(address(this)).sub(balancebefore);
1664         user.amount = user.amount.add(amountReceived);
1665         pool.totalStaked = pool.totalStaked.add(amountReceived);
1666             
1667         
1668         equivalentAmount =  getBoostEquivalentAmount(msg.sender, _pid);
1669         user.rewardDebt = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13);
1670         user.lastRewardBlock = block.number;
1671 
1672         emit Deposited(msg.sender, _pid, amountReceived);
1673     }
1674 
1675     function getBoostEquivalentAmount(address _account, uint256 _pid) public view returns (uint256) {
1676         UserInfo memory user = userInfo[_pid][_account];
1677         uint256 equivalentAmount = user.amount;
1678 
1679         if (_pid == squidStakingPoolId && nftBoostEnabled) { // NFT boost only for Squid staking pool (pid = 0)
1680             uint256 nftCount = _getWhitelistedNft(_account);
1681             equivalentAmount = getBoostedAmount(user.amount, nftCount);
1682         }
1683         return equivalentAmount;
1684     }
1685 
1686     // Harvest Reward
1687     function harvest(uint256 _pid) public nonReentrant {
1688         require(isHarvestingEnabled, "reward harvesting is not enabled, need to withdraw token to harvest reward!");
1689         require(!isBlackListed[msg.sender], "user is blacklisted");
1690         PoolInfo storage pool = poolInfo[_pid];
1691         UserInfo storage user = userInfo[_pid][msg.sender];
1692         require(user.amount > 0, "harvest: not good");
1693         updatePool((_pid));
1694         
1695         uint256 equivalentAmount = getBoostEquivalentAmount(msg.sender, _pid);
1696 
1697         uint256 pending = 0;
1698         
1699         if ( checkpoints.length!= 0 && user.lastRewardBlock <= checkpoints[checkpoints.length - 1].blockNumber && _pid == 0 && stakedNfts[msg.sender].amountStaked != 0) {
1700             pending = getPendingreward(pool, msg.sender, user);
1701         } else {
1702             pending = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13).sub(user.rewardDebt);
1703         }
1704 
1705         pending += user.pendingReward;
1706         user.pendingReward = 0;
1707         if(pending > 0){
1708             if (!isWhiteListed[msg.sender]) {
1709                 uint256 harvestFee = pending.mul(harvestTax).div(10000);
1710                 pending = pending - harvestFee;
1711                 if(harvestFee > 0)
1712                     safeSquidgrowTransfer(feeAddress, harvestFee);
1713             }
1714                 
1715             safeSquidgrowTransfer(msg.sender, pending);
1716         }
1717 
1718         equivalentAmount = getBoostEquivalentAmount(msg.sender, _pid);
1719         user.rewardDebt = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13);
1720         user.lastRewardBlock = block.number;
1721 
1722         emit Harvested(msg.sender, _pid, pending);
1723     }
1724 
1725     function getPendingreward(PoolInfo memory pool, address account, UserInfo memory user) internal view returns(uint256){
1726         uint256 index = checkpoints.length ;
1727         uint256 equivalentAmount = getBoostEquivalentAmount( account, 0);
1728         uint256 pending = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13).sub(equivalentAmount.mul(checkpoints[index -1].accSquidgrowPerSquidgrow).div(1e13));
1729         uint256 nftCount = _getWhitelistedNft(account);
1730         uint256 boostedAmount = getBoostedAmount(user.amount, nftCount);
1731         bool boostEnable = nftBoostEnabled;
1732         for (uint256 i = index; i >= 1 ; --i) {
1733             if(user.lastRewardBlock > checkpoints[i-1].blockNumber)
1734                 break;
1735             
1736             if(checkpoints[i-1].isToggleCheckpoint) {
1737                 boostEnable = !boostEnable;
1738                 if(boostEnable) {
1739                     pending += boostedAmount.mul(checkpoints[i-1].accSquidgrowPerSquidgrow).div(1e13).sub(i == 1 || user.lastRewardBlock > checkpoints[i-2].blockNumber ? user.rewardDebt: boostedAmount.mul(checkpoints[i - 2].accSquidgrowPerSquidgrow).div(1e13));
1740                 } else {
1741                     pending += user.amount.mul(checkpoints[i-1].accSquidgrowPerSquidgrow).div(1e13).sub( i == 1 || user.lastRewardBlock > checkpoints[i-2].blockNumber ?user.rewardDebt : user.amount.mul(checkpoints[i - 2].accSquidgrowPerSquidgrow).div(1e13));
1742                 }
1743                 
1744                 
1745             }else {
1746                 uint256 amount = nftStaked[account][checkpoints[i-1].collection];
1747                 if(amount != 0) {
1748                     nftCount = checkpoints[i-1].state ? nftCount - amount : nftCount + amount;
1749                     boostedAmount = getBoostedAmount(user.amount, nftCount);
1750                 }
1751                 if(boostEnable) {
1752                     pending += boostedAmount.mul(checkpoints[i-1].accSquidgrowPerSquidgrow).div(1e13).sub(i == 1 || user.lastRewardBlock > checkpoints[i-2].blockNumber ? user.rewardDebt: boostedAmount.mul(checkpoints[i - 2].accSquidgrowPerSquidgrow).div(1e13));
1753                 } else {
1754                     pending += user.amount.mul(checkpoints[i-1].accSquidgrowPerSquidgrow).div(1e13).sub( i == 1 || user.lastRewardBlock > checkpoints[i-2].blockNumber ?user.rewardDebt : user.amount.mul(checkpoints[i - 2].accSquidgrowPerSquidgrow).div(1e13));
1755                 }
1756 
1757             }
1758 
1759 
1760         }
1761         return pending;
1762 
1763     }
1764 
1765     function getBoostedAmount(uint256 amount, uint256 nftCount) public view returns (uint256) {
1766         // multiplying nftCount by 10^8 and dividing the result by sqrt(10^8) = 10^4 for precision
1767         return amount + (amount * Math.sqrt(nftCount * 100_000_000) * boostAPRPerNft) / (1000 * 10_000);
1768     }
1769 
1770     // Withdraw LP tokens from Staking.
1771     function withdraw(uint256 _pid, uint256 _amount) public nonReentrant {
1772         PoolInfo storage pool = poolInfo[_pid];
1773         UserInfo storage user = userInfo[_pid][msg.sender];
1774         require(user.amount >= _amount, "withdraw: not good");
1775         updatePool(_pid);
1776        
1777         uint256 equivalentAmount = getBoostEquivalentAmount(msg.sender, _pid);
1778 
1779         uint256 pending = 0;
1780         
1781         if ( checkpoints.length!= 0 && user.lastRewardBlock <= checkpoints[checkpoints.length - 1].blockNumber && _pid == squidStakingPoolId && stakedNfts[msg.sender].amountStaked != 0) {
1782             pending = getPendingreward(pool, msg.sender, user);
1783         } else {
1784             pending = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13).sub(user.rewardDebt);
1785         }      
1786         user.pendingReward += isHarvestingEnabled ? 0 : pending; 
1787         uint256 withdrawFee = 0;
1788         if(pending > 0 && isHarvestingEnabled){
1789             if (!isWhiteListed[msg.sender]) {
1790                 uint256 harvestFee = pending.mul(harvestTax).div(10000);
1791                 pending = pending - harvestFee;
1792                 if(harvestFee > 0)
1793                     safeSquidgrowTransfer(feeAddress, harvestFee);
1794             }
1795             if(!isBlackListed[msg.sender]) {
1796                 safeSquidgrowTransfer(msg.sender, pending);
1797             }
1798         }
1799 
1800         if (!isWhiteListed[msg.sender]) {
1801             withdrawFee = (_amount * withdrawTax) / 10000;
1802             if(withdrawFee > 0)
1803                 pool.stakedToken.safeTransfer(feeAddress, withdrawFee);
1804         }
1805 
1806 
1807         pool.stakedToken.safeTransfer(msg.sender, _amount - withdrawFee);
1808         pool.totalStaked=pool.totalStaked.sub(_amount);
1809         user.amount = user.amount.sub(_amount);
1810 
1811         equivalentAmount = getBoostEquivalentAmount(msg.sender, _pid);
1812 
1813         user.rewardDebt = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13);
1814         user.lastRewardBlock = block.number;
1815 
1816         if(user.amount == 0) {
1817             pending  = user.pendingReward;
1818             if(pending> 0 && !isHarvestingEnabled) {
1819                 if (!isWhiteListed[msg.sender]) {
1820                     uint256 harvestFee = pending.mul(harvestTax).div(10000);
1821                     pending = pending - harvestFee;
1822                     if(harvestFee > 0)
1823                         safeSquidgrowTransfer(feeAddress, harvestFee);
1824                 }
1825                 if(!isBlackListed[msg.sender]) {
1826                     safeSquidgrowTransfer(msg.sender, pending);
1827                 }
1828             }
1829 
1830             if( _pid == squidStakingPoolId && stakedNfts[msg.sender].amountStaked != 0)  {
1831                 _withdrawAllNft(msg.sender);
1832             }
1833         }
1834         
1835 
1836         emit Withdrawn(msg.sender, _pid, _amount);
1837     }
1838 
1839     // Deposit NFT token to Staking
1840     function depositNft(address _collection, uint256[] calldata _tokenIds) public nonReentrant {
1841         require(!isBlackListed[msg.sender], "user is blacklisted");
1842         require(nftBoostEnabled, "NFT staking is turned off.");
1843         require(isNftWhitelisted[_collection], "Collection not whitelisted");
1844         updatePool(squidStakingPoolId);
1845 
1846         PoolInfo storage pool = poolInfo[squidStakingPoolId]; // pool id = 0 --> Squid staking pool
1847         UserInfo storage user = userInfo[squidStakingPoolId][msg.sender];
1848         require(user.amount > 0, "You should stake squid to deposit NFT.");
1849         uint256 equivalentAmount = getBoostEquivalentAmount(msg.sender, squidStakingPoolId);
1850 
1851        uint256 pending = 0;
1852         
1853         if ( checkpoints.length!= 0 && user.lastRewardBlock <= checkpoints[checkpoints.length - 1].blockNumber && stakedNfts[msg.sender].amountStaked != 0) {
1854             pending = getPendingreward(pool, msg.sender, user);
1855         } else {
1856             pending = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13).sub(user.rewardDebt);
1857         }
1858         user.pendingReward += isHarvestingEnabled ? 0 : pending; 
1859         if(pending > 0 && isHarvestingEnabled){
1860             if (!isWhiteListed[msg.sender]) {
1861                 uint256 harvestFee = pending.mul(harvestTax).div(10000);
1862                 pending = pending - harvestFee;
1863                 if(harvestFee > 0)
1864                     safeSquidgrowTransfer(feeAddress, harvestFee);
1865             }
1866             safeSquidgrowTransfer(msg.sender, pending);
1867         }
1868 
1869         uint256 stakeAmount = _tokenIds.length;
1870         for (uint256 i = 0; i < stakeAmount; i++) {
1871             require(IERC721(_collection).ownerOf(_tokenIds[i]) == msg.sender, "Sender not owner");
1872             IERC721(_collection).safeTransferFrom(msg.sender, address(this), _tokenIds[i]);
1873             vault[_collection][_tokenIds[i]] = msg.sender;
1874     
1875             StakedNft memory stakedNft = StakedNft(msg.sender, _tokenIds[i], _collection);
1876             stakedNfts[msg.sender].stakedNfts.push(stakedNft);
1877         }
1878         stakedNfts[msg.sender].amountStaked += stakeAmount;
1879         nftStaked[msg.sender][_collection] += stakeAmount;
1880 
1881         equivalentAmount = getBoostEquivalentAmount(msg.sender, squidStakingPoolId);
1882         user.rewardDebt = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13);
1883         user.lastRewardBlock = block.number;
1884 
1885         emit DepositedNFTs(msg.sender, _collection, _tokenIds.length);
1886     }
1887 
1888     // Withdraw Nft Token from staking
1889     function withdrawNft(address _collection, uint256[] calldata _tokenIds) public nonReentrant {
1890         require(
1891             stakedNfts[msg.sender].amountStaked > 0,
1892             "You have no NFT staked"
1893         );
1894         updatePool(squidStakingPoolId);
1895         PoolInfo storage pool = poolInfo[squidStakingPoolId]; // pool id = 0 --> Squid staking pool
1896         UserInfo storage user = userInfo[squidStakingPoolId][msg.sender];
1897         uint256 equivalentAmount = getBoostEquivalentAmount(msg.sender, squidStakingPoolId);
1898 
1899         uint256 pending = 0;
1900         
1901         if ( checkpoints.length!= 0 && user.lastRewardBlock <= checkpoints[checkpoints.length - 1].blockNumber && stakedNfts[msg.sender].amountStaked != 0) {
1902             pending = getPendingreward(pool, msg.sender, user);
1903         } else {
1904             pending = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13).sub(user.rewardDebt);
1905         }
1906         user.pendingReward += isHarvestingEnabled ? 0 : pending; 
1907 
1908         if(pending > 0 && isHarvestingEnabled){
1909             if (!isWhiteListed[msg.sender]) {
1910                 uint256 harvestFee = pending.mul(harvestTax).div(10000);
1911                 pending = pending - harvestFee;
1912                 if(harvestFee > 0)
1913                     safeSquidgrowTransfer(feeAddress, harvestFee);
1914             }
1915 
1916             if (!isBlackListed[msg.sender]) {
1917                 safeSquidgrowTransfer(msg.sender, pending);
1918             }
1919         }
1920         uint256 unstakeAmount = _tokenIds.length;
1921         for (uint256 i = 0; i < unstakeAmount; i++) {
1922             require(vault[_collection][_tokenIds[i]] == msg.sender, "You don't own this token!");
1923 
1924             // Find the index of this token id in the stakedTokens array
1925             uint256 index = 0;
1926             for (uint256 j = 0; i < stakedNfts[msg.sender].stakedNfts.length; j++) {
1927                 if (
1928                     stakedNfts[msg.sender].stakedNfts[j].collection == _collection
1929                     &&
1930                     stakedNfts[msg.sender].stakedNfts[j].tokenId == _tokenIds[i] 
1931                     && 
1932                     stakedNfts[msg.sender].stakedNfts[j].staker != address(0)
1933                 ) {
1934                     index = j;
1935                     break;
1936                 }
1937             }
1938             stakedNfts[msg.sender].stakedNfts[index].staker = address(0);
1939 
1940             vault[_collection][_tokenIds[i]] = address(0);
1941             IERC721(_collection).safeTransferFrom(address(this), msg.sender, _tokenIds[i]);
1942         }
1943         stakedNfts[msg.sender].amountStaked -= unstakeAmount;
1944         nftStaked[msg.sender][_collection] -= unstakeAmount;
1945 
1946         equivalentAmount = getBoostEquivalentAmount(msg.sender, squidStakingPoolId);
1947         user.rewardDebt = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13);
1948         user.lastRewardBlock = block.number;
1949 
1950         emit WithdrawnNFTs(msg.sender, _collection, _tokenIds.length);
1951 
1952     }
1953 
1954     function withdrawAllNft() external nonReentrant{
1955         require(
1956             stakedNfts[msg.sender].amountStaked > 0,
1957             "You have no NFT staked"
1958         );
1959         _withdrawAllNft(msg.sender);
1960     }
1961 
1962     function _withdrawAllNft(address account) internal {
1963         
1964         updatePool(squidStakingPoolId);
1965         
1966         PoolInfo storage pool = poolInfo[squidStakingPoolId]; // pool id = 0 --> Squid staking pool
1967         UserInfo storage user = userInfo[squidStakingPoolId][account];
1968         uint256 equivalentAmount = getBoostEquivalentAmount(account, squidStakingPoolId);
1969 
1970         uint256 pending = 0;
1971         
1972         if ( checkpoints.length!= 0 && user.lastRewardBlock <= checkpoints[checkpoints.length - 1].blockNumber && stakedNfts[msg.sender].amountStaked != 0) {
1973             pending = getPendingreward(pool, msg.sender, user);
1974         } else {
1975             pending = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13).sub(user.rewardDebt);
1976         }
1977         user.pendingReward += isHarvestingEnabled ? 0 : pending; 
1978 
1979         if(pending > 0 && isHarvestingEnabled){
1980             if (!isWhiteListed[account]) {
1981                 uint256 harvestFee = pending.mul(harvestTax).div(10000);
1982                 pending = pending - harvestFee;
1983                 if(harvestFee > 0)
1984                     safeSquidgrowTransfer(feeAddress, harvestFee);
1985             }
1986 
1987             if (!isBlackListed[account]) {
1988                 safeSquidgrowTransfer(account, pending);
1989             }
1990         }
1991 
1992         emit WithdrawnAllNFTs(account, stakedNfts[msg.sender].amountStaked);
1993         stakedNfts[account].amountStaked = 0;
1994 
1995         for (uint256 i = 0; i < stakedNfts[account].stakedNfts.length; i++) {
1996             if (stakedNfts[account].stakedNfts[i].staker != address(0)) {
1997                 stakedNfts[account].stakedNfts[i].staker = address(0);
1998                 
1999                 vault[stakedNfts[account].stakedNfts[i].collection][stakedNfts[account].stakedNfts[i].tokenId] = address(0);
2000                 nftStaked[account][stakedNfts[account].stakedNfts[i].collection] = 0;
2001                 IERC721(stakedNfts[account].stakedNfts[i].collection).safeTransferFrom(address(this), account,stakedNfts[account].stakedNfts[i].tokenId);
2002             }
2003         }
2004             
2005 
2006         equivalentAmount = getBoostEquivalentAmount(account, squidStakingPoolId);
2007         user.rewardDebt = equivalentAmount.mul(pool.accSquidgrowPerShare).div(1e13);
2008         user.lastRewardBlock = block.number;
2009 
2010     }
2011 
2012     // Withdraw without caring about rewards. EMERGENCY ONLY.
2013     function emergencyWithdraw(uint256 _pid) public nonReentrant {
2014         PoolInfo storage pool = poolInfo[_pid];
2015         UserInfo storage user = userInfo[_pid][msg.sender];
2016         uint256 amount = user.amount;
2017         user.amount = 0;
2018         user.rewardDebt = 0;
2019         pool.totalStaked = pool.totalStaked.sub(amount);
2020         
2021         uint256 withdrawFee = 0;
2022         if (!isWhiteListed[msg.sender]) {
2023             withdrawFee = (amount * withdrawTax) / 10000;
2024             if(withdrawFee > 0)
2025                 pool.stakedToken.safeTransfer(feeAddress, withdrawFee);
2026         }
2027         pool.stakedToken.safeTransfer(msg.sender, amount - withdrawFee);
2028 
2029         if(_pid == squidStakingPoolId && stakedNfts[msg.sender].amountStaked != 0) {
2030             _withdrawAllNft(msg.sender);
2031         }
2032 
2033        emit EmergencyWithdrawn(msg.sender, _pid);
2034     }
2035 
2036     // Safe Squidgrow transfer function, just in case if rounding error causes pool to not have enough FOXs.
2037     function safeSquidgrowTransfer(address _to, uint256 _amount) internal {
2038         uint256 SquidgrowBal = Squidgrow.balanceOf(address(this));
2039         PoolInfo storage pool = poolInfo[squidStakingPoolId];
2040         uint256 rewardBalance = SquidgrowBal - pool.totalStaked;
2041         bool transferSuccess = false;
2042         if (_amount > rewardBalance) {
2043             transferSuccess = Squidgrow.transfer(_to, rewardBalance);
2044         } else {
2045             transferSuccess = Squidgrow.transfer(_to, _amount);
2046         }
2047         require(transferSuccess, "safeSquidgrowTransfer: Transfer failed");
2048     }
2049 
2050     function updateSquidStakingPoolId(uint256 _newId) external onlyOwner {
2051         squidStakingPoolId = _newId;
2052     }
2053 
2054     function changeSquidgrowAddress(address _squidgrow, bool _withUpdate) external onlyOwner {
2055         require(_squidgrow != address(0), "Can't be zero address");
2056         Squidgrow = IERC20(_squidgrow);
2057         if (_withUpdate) {
2058             massUpdatePools();
2059         }
2060         emit UpdatedSquidgrowAddress(_squidgrow);
2061     }
2062 
2063     // Recover unsupported tokens that are sent accidently.
2064     function recoverUnsupportedToken(address _addr, uint256 _amount) external onlyOwner {
2065         require(_addr != address(0), "non-zero address");
2066         uint256 totalDeposit = 0;
2067         uint256 length = poolInfo.length;
2068         for (uint256 pid = 0; pid < length; ++pid) {
2069             if (poolInfo[pid].stakedToken == IERC20(_addr)) {
2070                 totalDeposit = poolInfo[pid].totalStaked;
2071                 break;
2072             }
2073         }
2074         uint256 balance = IERC20(_addr).balanceOf(address(this));
2075         uint256 amt = balance.sub(totalDeposit);
2076         if (_amount > 0 && _amount <= amt) {
2077             IERC20(_addr).safeTransfer(msg.sender, _amount);
2078         }
2079 
2080         emit UnsupportedTokenRecovered(msg.sender, _addr, _amount);
2081     }
2082 
2083     // set fee address
2084     function setFeeAddress(address _feeAddress) external onlyOwner {
2085         require(_feeAddress != address(0),"non-zero");
2086         emit FeeAddressUpdated(feeAddress, _feeAddress);
2087         feeAddress = _feeAddress;
2088     }
2089 
2090     // update reward per block
2091     function updateEmissionRate(uint256 _SquidgrowPerBlock) external onlyOwner {
2092         massUpdatePools();
2093         emit UpdatedEmissionRate(SquidgrowPerBlock, _SquidgrowPerBlock);
2094         SquidgrowPerBlock = _SquidgrowPerBlock;
2095     }
2096 
2097     // add peoples to whitelist for deposit fee
2098     function whiteList(address[] memory _addresses) external onlyOwner {
2099         uint256 count = _addresses.length;
2100         for (uint256 i =0 ; i< count; i++) {
2101             isWhiteListed[_addresses[i]] = true;
2102             emit Whitelisted(_addresses[i]);
2103         }
2104     }
2105 
2106     // remove peoples from whitelist for deposit fee
2107     function removeWhiteList(address[] memory _addresses) external onlyOwner {
2108         uint256 count = _addresses.length;
2109         for (uint256 i =0 ; i< count; i++) {
2110             isWhiteListed[_addresses[i]] = false;
2111             emit Unwhitelisted(_addresses[i]);
2112         }
2113     }
2114 
2115 
2116     // add peoples to blacklist for reward
2117     function blackList(address[] memory _addresses) external onlyOwner {
2118         uint256 count = _addresses.length;
2119         for (uint256 i =0 ; i< count; i++) {
2120             isBlackListed[_addresses[i]] = true;
2121             emit Blacklisted(_addresses[i]);
2122         }
2123     }
2124 
2125     // remove peoples from blacklist
2126     function removeBlackList(address[] memory _addresses) external onlyOwner {
2127         uint256 count = _addresses.length;
2128         for (uint256 i =0 ; i< count; i++) {
2129             isBlackListed[_addresses[i]] = false;
2130             emit Unblacklisted(_addresses[i]);
2131         }
2132     }
2133 
2134     function enableRewardHarvesting() external onlyOwner {
2135         require(!isHarvestingEnabled, "already enabled");
2136         isHarvestingEnabled = true;
2137         emit HarvestingEnabled();
2138     }
2139 
2140     function disableRewardHarvesting() external onlyOwner {
2141         require(isHarvestingEnabled, "already disabled");
2142         isHarvestingEnabled = false;
2143         emit HarvestingDisabled();
2144     }
2145 
2146     // get pool length
2147     function poolLength() external view returns (uint256) {
2148         return poolInfo.length;
2149     }
2150 
2151     // Turn on Nft staking
2152     function turnOnNftStaking() external onlyOwner {
2153         require(!nftBoostEnabled, "already enable");
2154         nftBoostEnabled = true;
2155         updatePool(squidStakingPoolId);
2156         Checkpoint memory newcheckpoint = Checkpoint (block.number, poolInfo[squidStakingPoolId].accSquidgrowPerShare, true, true, address(0));
2157         checkpoints.push(newcheckpoint);
2158 
2159         emit NftBoostingEnabled(poolInfo[squidStakingPoolId].accSquidgrowPerShare);
2160     }
2161 
2162     // Turn off Nft staking
2163     function turnOffNftStaking() external onlyOwner {
2164         require(nftBoostEnabled, "already disable");
2165         nftBoostEnabled = false;
2166         updatePool(squidStakingPoolId);
2167         Checkpoint memory newcheckpoint = Checkpoint (block.number, poolInfo[squidStakingPoolId].accSquidgrowPerShare, true, false, address(0));
2168         checkpoints.push(newcheckpoint);
2169 
2170         emit NftBoostingDisabled(poolInfo[squidStakingPoolId].accSquidgrowPerShare);
2171     }
2172     
2173     function updateBoostAPRPerNft(uint256 _newBoostAPRPerNft) external onlyOwner {
2174         require(_newBoostAPRPerNft > 0 , "should be greater than zero");
2175 
2176         emit BoostAPRPerNftUpdated(boostAPRPerNft, _newBoostAPRPerNft);
2177 
2178         boostAPRPerNft = _newBoostAPRPerNft;
2179     }
2180     
2181     function setStakingTax(uint256 _newWithdrawTax, uint256 _newDepositTax, uint256 _newHarvestTax) external onlyOwner {
2182         require(_newWithdrawTax +  _newDepositTax + _newHarvestTax <= MAXIMUM_FEE_RATE, "Tax mustn't be greater than 10%");
2183         withdrawTax = _newWithdrawTax;
2184         depositTax = _newDepositTax;
2185         harvestTax = _newHarvestTax;
2186 
2187         emit StakingTaxUpdated(_newWithdrawTax, _newDepositTax, _newHarvestTax);
2188     }
2189 
2190     function getStakedNfts(address _user) public view returns (uint256[] memory, address[] memory) {
2191         // Check if we know this user
2192         if (stakedNfts[_user].amountStaked > 0) {
2193             // Return all the tokens in the stakedToken Array for this user that are not -1
2194             uint256[] memory _stakedNfts = new uint256[](stakedNfts[_user].amountStaked);
2195             address[] memory _collection = new address[](stakedNfts[_user].amountStaked);
2196             uint256 _index = 0;
2197 
2198             for (uint256 j = 0; j < stakedNfts[_user].stakedNfts.length; j++) {
2199                 if (stakedNfts[_user].stakedNfts[j].staker != (address(0))) {
2200                     _stakedNfts[_index] = stakedNfts[_user].stakedNfts[j].tokenId;
2201                     _collection[_index] = stakedNfts[_user].stakedNfts[j].collection;
2202                     _index++;
2203                 }
2204             }
2205 
2206             return (_stakedNfts, _collection);
2207         }
2208         
2209         // Otherwise, return empty array
2210         else {
2211             return (new uint256[](0), new address[](0));
2212         }
2213     }
2214 
2215     function _getWhitelistedNft(address user) internal view returns(uint256) {
2216         uint256 count = whitelistedNFTs.length;
2217         uint256 nftCount = 0;
2218         for (uint256 i = 0 ; i< count ; i++) {
2219             nftCount += nftStaked[user][whitelistedNFTs[i]];
2220         }
2221         return nftCount;
2222     }
2223 
2224     function onERC721Received(
2225         address,
2226         address,
2227         uint256,
2228         bytes calldata
2229     ) external pure override returns (bytes4) {
2230         return IERC721Receiver.onERC721Received.selector;
2231     }
2232     
2233 }