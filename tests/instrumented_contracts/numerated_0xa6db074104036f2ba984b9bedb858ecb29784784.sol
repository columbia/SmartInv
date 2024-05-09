1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: contracts/AggregatorV3Interface.sol
5 
6 
7 
8 pragma solidity >= 0.6.0;
9 
10 interface AggregatorV3Interface {
11 
12   function decimals()
13     external
14     view
15     returns (
16       uint8
17     );
18 
19   function description()
20     external
21     view
22     returns (
23       string memory
24     );
25 
26   function version()
27     external
28     view
29     returns (
30       uint256
31     );
32 
33   // getRoundData and latestRoundData should both raise "No data present"
34   // if they do not have data to report, instead of returning unset values
35   // which could be misinterpreted as actual reported values.
36   function getRoundData(
37     uint80 _roundId
38   )
39     external
40     view
41     returns (
42       uint80 roundId,
43       int256 answer,
44       uint256 startedAt,
45       uint256 updatedAt,
46       uint80 answeredInRound
47     );
48 
49   function latestRoundData()
50     external
51     view
52     returns (
53       uint80 roundId,
54       int256 answer,
55       uint256 startedAt,
56       uint256 updatedAt,
57       uint80 answeredInRound
58     );
59 }
60 // File: @openzeppelin/contracts/utils/Address.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
64 
65 pragma solidity ^0.8.1;
66 
67 /**
68  * @dev Collection of functions related to the address type
69  */
70 library Address {
71     /**
72      * @dev Returns true if `account` is a contract.
73      *
74      * [IMPORTANT]
75      * ====
76      * It is unsafe to assume that an address for which this function returns
77      * false is an externally-owned account (EOA) and not a contract.
78      *
79      * Among others, `isContract` will return false for the following
80      * types of addresses:
81      *
82      *  - an externally-owned account
83      *  - a contract in construction
84      *  - an address where a contract will be created
85      *  - an address where a contract lived, but was destroyed
86      * ====
87      *
88      * [IMPORTANT]
89      * ====
90      * You shouldn't rely on `isContract` to protect against flash loan attacks!
91      *
92      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
93      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
94      * constructor.
95      * ====
96      */
97     function isContract(address account) internal view returns (bool) {
98         // This method relies on extcodesize/address.code.length, which returns 0
99         // for contracts in construction, since the code is only stored at the end
100         // of the constructor execution.
101 
102         return account.code.length > 0;
103     }
104 
105     /**
106      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
107      * `recipient`, forwarding all available gas and reverting on errors.
108      *
109      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
110      * of certain opcodes, possibly making contracts go over the 2300 gas limit
111      * imposed by `transfer`, making them unable to receive funds via
112      * `transfer`. {sendValue} removes this limitation.
113      *
114      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
115      *
116      * IMPORTANT: because control is transferred to `recipient`, care must be
117      * taken to not create reentrancy vulnerabilities. Consider using
118      * {ReentrancyGuard} or the
119      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
120      */
121     function sendValue(address payable recipient, uint256 amount) internal {
122         require(address(this).balance >= amount, "Address: insufficient balance");
123 
124         (bool success, ) = recipient.call{value: amount}("");
125         require(success, "Address: unable to send value, recipient may have reverted");
126     }
127 
128     /**
129      * @dev Performs a Solidity function call using a low level `call`. A
130      * plain `call` is an unsafe replacement for a function call: use this
131      * function instead.
132      *
133      * If `target` reverts with a revert reason, it is bubbled up by this
134      * function (like regular Solidity function calls).
135      *
136      * Returns the raw returned data. To convert to the expected return value,
137      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
138      *
139      * Requirements:
140      *
141      * - `target` must be a contract.
142      * - calling `target` with `data` must not revert.
143      *
144      * _Available since v3.1._
145      */
146     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
147         return functionCall(target, data, "Address: low-level call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
152      * `errorMessage` as a fallback revert reason when `target` reverts.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal returns (bytes memory) {
161         return functionCallWithValue(target, data, 0, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but also transferring `value` wei to `target`.
167      *
168      * Requirements:
169      *
170      * - the calling contract must have an ETH balance of at least `value`.
171      * - the called Solidity function must be `payable`.
172      *
173      * _Available since v3.1._
174      */
175     function functionCallWithValue(
176         address target,
177         bytes memory data,
178         uint256 value
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
185      * with `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value,
193         string memory errorMessage
194     ) internal returns (bytes memory) {
195         require(address(this).balance >= value, "Address: insufficient balance for call");
196         require(isContract(target), "Address: call to non-contract");
197 
198         (bool success, bytes memory returndata) = target.call{value: value}(data);
199         return verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but performing a static call.
205      *
206      * _Available since v3.3._
207      */
208     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
209         return functionStaticCall(target, data, "Address: low-level static call failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
214      * but performing a static call.
215      *
216      * _Available since v3.3._
217      */
218     function functionStaticCall(
219         address target,
220         bytes memory data,
221         string memory errorMessage
222     ) internal view returns (bytes memory) {
223         require(isContract(target), "Address: static call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.staticcall(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a delegate call.
232      *
233      * _Available since v3.4._
234      */
235     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
236         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal returns (bytes memory) {
250         require(isContract(target), "Address: delegate call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.delegatecall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
258      * revert reason using the provided one.
259      *
260      * _Available since v4.3._
261      */
262     function verifyCallResult(
263         bool success,
264         bytes memory returndata,
265         string memory errorMessage
266     ) internal pure returns (bytes memory) {
267         if (success) {
268             return returndata;
269         } else {
270             // Look for revert reason and bubble it up if present
271             if (returndata.length > 0) {
272                 // The easiest way to bubble the revert reason is using memory via assembly
273                 /// @solidity memory-safe-assembly
274                 assembly {
275                     let returndata_size := mload(returndata)
276                     revert(add(32, returndata), returndata_size)
277                 }
278             } else {
279                 revert(errorMessage);
280             }
281         }
282     }
283 }
284 
285 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
294  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
295  *
296  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
297  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
298  * need to send a transaction, and thus is not required to hold Ether at all.
299  */
300 interface IERC20Permit {
301     /**
302      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
303      * given ``owner``'s signed approval.
304      *
305      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
306      * ordering also apply here.
307      *
308      * Emits an {Approval} event.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      * - `deadline` must be a timestamp in the future.
314      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
315      * over the EIP712-formatted function arguments.
316      * - the signature must use ``owner``'s current nonce (see {nonces}).
317      *
318      * For more information on the signature format, see the
319      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
320      * section].
321      */
322     function permit(
323         address owner,
324         address spender,
325         uint256 value,
326         uint256 deadline,
327         uint8 v,
328         bytes32 r,
329         bytes32 s
330     ) external;
331 
332     /**
333      * @dev Returns the current nonce for `owner`. This value must be
334      * included whenever a signature is generated for {permit}.
335      *
336      * Every successful call to {permit} increases ``owner``'s nonce by one. This
337      * prevents a signature from being used multiple times.
338      */
339     function nonces(address owner) external view returns (uint256);
340 
341     /**
342      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
343      */
344     // solhint-disable-next-line func-name-mixedcase
345     function DOMAIN_SEPARATOR() external view returns (bytes32);
346 }
347 
348 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
349 
350 
351 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev Interface of the ERC20 standard as defined in the EIP.
357  */
358 interface IERC20 {
359     /**
360      * @dev Emitted when `value` tokens are moved from one account (`from`) to
361      * another (`to`).
362      *
363      * Note that `value` may be zero.
364      */
365     event Transfer(address indexed from, address indexed to, uint256 value);
366 
367     /**
368      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
369      * a call to {approve}. `value` is the new allowance.
370      */
371     event Approval(address indexed owner, address indexed spender, uint256 value);
372 
373     /**
374      * @dev Returns the amount of tokens in existence.
375      */
376     function totalSupply() external view returns (uint256);
377 
378     /**
379      * @dev Returns the amount of tokens owned by `account`.
380      */
381     function balanceOf(address account) external view returns (uint256);
382 
383     /**
384      * @dev Moves `amount` tokens from the caller's account to `to`.
385      *
386      * Returns a boolean value indicating whether the operation succeeded.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transfer(address to, uint256 amount) external returns (bool);
391 
392     /**
393      * @dev Returns the remaining number of tokens that `spender` will be
394      * allowed to spend on behalf of `owner` through {transferFrom}. This is
395      * zero by default.
396      *
397      * This value changes when {approve} or {transferFrom} are called.
398      */
399     function allowance(address owner, address spender) external view returns (uint256);
400 
401     /**
402      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
403      *
404      * Returns a boolean value indicating whether the operation succeeded.
405      *
406      * IMPORTANT: Beware that changing an allowance with this method brings the risk
407      * that someone may use both the old and the new allowance by unfortunate
408      * transaction ordering. One possible solution to mitigate this race
409      * condition is to first reduce the spender's allowance to 0 and set the
410      * desired value afterwards:
411      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
412      *
413      * Emits an {Approval} event.
414      */
415     function approve(address spender, uint256 amount) external returns (bool);
416 
417     /**
418      * @dev Moves `amount` tokens from `from` to `to` using the
419      * allowance mechanism. `amount` is then deducted from the caller's
420      * allowance.
421      *
422      * Returns a boolean value indicating whether the operation succeeded.
423      *
424      * Emits a {Transfer} event.
425      */
426     function transferFrom(
427         address from,
428         address to,
429         uint256 amount
430     ) external returns (bool);
431 }
432 
433 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
434 
435 
436 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 
441 
442 
443 /**
444  * @title SafeERC20
445  * @dev Wrappers around ERC20 operations that throw on failure (when the token
446  * contract returns false). Tokens that return no value (and instead revert or
447  * throw on failure) are also supported, non-reverting calls are assumed to be
448  * successful.
449  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
450  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
451  */
452 library SafeERC20 {
453     using Address for address;
454 
455     function safeTransfer(
456         IERC20 token,
457         address to,
458         uint256 value
459     ) internal {
460         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
461     }
462 
463     function safeTransferFrom(
464         IERC20 token,
465         address from,
466         address to,
467         uint256 value
468     ) internal {
469         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
470     }
471 
472     /**
473      * @dev Deprecated. This function has issues similar to the ones found in
474      * {IERC20-approve}, and its usage is discouraged.
475      *
476      * Whenever possible, use {safeIncreaseAllowance} and
477      * {safeDecreaseAllowance} instead.
478      */
479     function safeApprove(
480         IERC20 token,
481         address spender,
482         uint256 value
483     ) internal {
484         // safeApprove should only be called when setting an initial allowance,
485         // or when resetting it to zero. To increase and decrease it, use
486         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
487         require(
488             (value == 0) || (token.allowance(address(this), spender) == 0),
489             "SafeERC20: approve from non-zero to non-zero allowance"
490         );
491         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
492     }
493 
494     function safeIncreaseAllowance(
495         IERC20 token,
496         address spender,
497         uint256 value
498     ) internal {
499         uint256 newAllowance = token.allowance(address(this), spender) + value;
500         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501     }
502 
503     function safeDecreaseAllowance(
504         IERC20 token,
505         address spender,
506         uint256 value
507     ) internal {
508         unchecked {
509             uint256 oldAllowance = token.allowance(address(this), spender);
510             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
511             uint256 newAllowance = oldAllowance - value;
512             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
513         }
514     }
515 
516     function safePermit(
517         IERC20Permit token,
518         address owner,
519         address spender,
520         uint256 value,
521         uint256 deadline,
522         uint8 v,
523         bytes32 r,
524         bytes32 s
525     ) internal {
526         uint256 nonceBefore = token.nonces(owner);
527         token.permit(owner, spender, value, deadline, v, r, s);
528         uint256 nonceAfter = token.nonces(owner);
529         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
530     }
531 
532     /**
533      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
534      * on the return value: the return value is optional (but if data is returned, it must not be false).
535      * @param token The token targeted by the call.
536      * @param data The call data (encoded using abi.encode or one of its variants).
537      */
538     function _callOptionalReturn(IERC20 token, bytes memory data) private {
539         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
540         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
541         // the target address contains contract code and also asserts for success in the low-level call.
542 
543         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
544         if (returndata.length > 0) {
545             // Return data is optional
546             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
547         }
548     }
549 }
550 
551 // File: @openzeppelin/contracts/interfaces/IERC20.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Contract module that helps prevent reentrant calls to a function.
568  *
569  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
570  * available, which can be applied to functions to make sure there are no nested
571  * (reentrant) calls to them.
572  *
573  * Note that because there is a single `nonReentrant` guard, functions marked as
574  * `nonReentrant` may not call one another. This can be worked around by making
575  * those functions `private`, and then adding `external` `nonReentrant` entry
576  * points to them.
577  *
578  * TIP: If you would like to learn more about reentrancy and alternative ways
579  * to protect against it, check out our blog post
580  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
581  */
582 abstract contract ReentrancyGuard {
583     // Booleans are more expensive than uint256 or any type that takes up a full
584     // word because each write operation emits an extra SLOAD to first read the
585     // slot's contents, replace the bits taken up by the boolean, and then write
586     // back. This is the compiler's defense against contract upgrades and
587     // pointer aliasing, and it cannot be disabled.
588 
589     // The values being non-zero value makes deployment a bit more expensive,
590     // but in exchange the refund on every call to nonReentrant will be lower in
591     // amount. Since refunds are capped to a percentage of the total
592     // transaction's gas, it is best to keep them low in cases like this one, to
593     // increase the likelihood of the full refund coming into effect.
594     uint256 private constant _NOT_ENTERED = 1;
595     uint256 private constant _ENTERED = 2;
596 
597     uint256 private _status;
598 
599     constructor() {
600         _status = _NOT_ENTERED;
601     }
602 
603     /**
604      * @dev Prevents a contract from calling itself, directly or indirectly.
605      * Calling a `nonReentrant` function from another `nonReentrant`
606      * function is not supported. It is possible to prevent this from happening
607      * by making the `nonReentrant` function external, and making it call a
608      * `private` function that does the actual work.
609      */
610     modifier nonReentrant() {
611         // On the first call to nonReentrant, _notEntered will be true
612         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
613 
614         // Any calls to nonReentrant after this point will fail
615         _status = _ENTERED;
616 
617         _;
618 
619         // By storing the original value once again, a refund is triggered (see
620         // https://eips.ethereum.org/EIPS/eip-2200)
621         _status = _NOT_ENTERED;
622     }
623 }
624 
625 // File: @openzeppelin/contracts/utils/Context.sol
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev Provides information about the current execution context, including the
634  * sender of the transaction and its data. While these are generally available
635  * via msg.sender and msg.data, they should not be accessed in such a direct
636  * manner, since when dealing with meta-transactions the account sending and
637  * paying for execution may not be the actual sender (as far as an application
638  * is concerned).
639  *
640  * This contract is only required for intermediate, library-like contracts.
641  */
642 abstract contract Context {
643     function _msgSender() internal view virtual returns (address) {
644         return msg.sender;
645     }
646 
647     function _msgData() internal view virtual returns (bytes calldata) {
648         return msg.data;
649     }
650 }
651 
652 // File: @openzeppelin/contracts/access/Ownable.sol
653 
654 
655 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @dev Contract module which provides a basic access control mechanism, where
662  * there is an account (an owner) that can be granted exclusive access to
663  * specific functions.
664  *
665  * By default, the owner account will be the one that deploys the contract. This
666  * can later be changed with {transferOwnership}.
667  *
668  * This module is used through inheritance. It will make available the modifier
669  * `onlyOwner`, which can be applied to your functions to restrict their use to
670  * the owner.
671  */
672 abstract contract Ownable is Context {
673     address private _owner;
674 
675     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
676 
677     /**
678      * @dev Initializes the contract setting the deployer as the initial owner.
679      */
680     constructor() {
681         _transferOwnership(_msgSender());
682     }
683 
684     /**
685      * @dev Throws if called by any account other than the owner.
686      */
687     modifier onlyOwner() {
688         _checkOwner();
689         _;
690     }
691 
692     /**
693      * @dev Returns the address of the current owner.
694      */
695     function owner() public view virtual returns (address) {
696         return _owner;
697     }
698 
699     /**
700      * @dev Throws if the sender is not the owner.
701      */
702     function _checkOwner() internal view virtual {
703         require(owner() == _msgSender(), "Ownable: caller is not the owner");
704     }
705 
706     /**
707      * @dev Leaves the contract without owner. It will not be possible to call
708      * `onlyOwner` functions anymore. Can only be called by the current owner.
709      *
710      * NOTE: Renouncing ownership will leave the contract without an owner,
711      * thereby removing any functionality that is only available to the owner.
712      */
713     function renounceOwnership() public virtual onlyOwner {
714         _transferOwnership(address(0));
715     }
716 
717     /**
718      * @dev Transfers ownership of the contract to a new account (`newOwner`).
719      * Can only be called by the current owner.
720      */
721     function transferOwnership(address newOwner) public virtual onlyOwner {
722         require(newOwner != address(0), "Ownable: new owner is the zero address");
723         _transferOwnership(newOwner);
724     }
725 
726     /**
727      * @dev Transfers ownership of the contract to a new account (`newOwner`).
728      * Internal function without access restriction.
729      */
730     function _transferOwnership(address newOwner) internal virtual {
731         address oldOwner = _owner;
732         _owner = newOwner;
733         emit OwnershipTransferred(oldOwner, newOwner);
734     }
735 }
736 
737 // File: contracts/girlesPresale.sol
738 
739 
740 
741 pragma solidity ^0.8.0;
742 
743 
744 
745 contract GirlesPresale is Ownable, ReentrancyGuard {
746     using SafeERC20 for IERC20;
747 
748     IERC20 public immutable USDT;
749     IERC20 public immutable Girles;
750 
751     bool public enableVesting;
752 
753     uint public MAX_USDT_DEPOSIT;
754     uint public MIN_USDT_DEPOSIT;
755     uint public MAX_ETH_DEPOSIT;
756     uint public MIN_ETH_DEPOSIT;
757 
758     uint private totalAddedGirles;
759     uint private remainedGirles;
760 
761     uint public totalFundsETH;
762     uint public totalFundsUSDT;
763 
764     uint public MAX_PERIOD_DURATION = 1 hours;
765     uint public periodDuration = 30 days;    // Period to deposit GIRLES
766 
767     uint public depositBegin;
768     uint public depositEnd;
769 
770     struct Recipient {
771         uint shares;
772         uint sharesbyUSDT;
773         uint totalRewards;
774         uint claimed;
775     }
776     
777     mapping(address => Recipient) public recipients;
778 
779     AggregatorV3Interface private priceFeedofUSDT2ETH;
780 
781     uint public pricebyUSDT;
782 
783     event PresaleTokenAdded(address indexed sender, uint amount);
784     event DepositETH(address indexed sender, uint amount);
785     event DepositUSDT(address indexed sender, uint amount);
786     event Claim(address indexed account, uint amount);
787     event WithdrawETH(address indexed account, uint amount);
788     event WithdrawUSDT(address indexed account, uint amount);
789     event WithdrawGirles(address indexed account, uint amount);
790 
791     constructor(address token_, uint _pricebyUSDT) {
792         Girles = IERC20(token_);
793         
794         // Ethereum mainnet
795         USDT = IERC20(address(0xdAC17F958D2ee523a2206206994597C13D831ec7));
796 
797         // Ethereum USDT/ETH data feeds
798         priceFeedofUSDT2ETH = AggregatorV3Interface(0xEe9F2375b4bdF6387aa8265dD4FB8F16512A1d46);
799 
800         depositBegin = block.timestamp;
801         depositEnd = depositBegin + periodDuration;
802 
803         pricebyUSDT = _pricebyUSDT;
804 
805         setMaxDepositAmount(1000000 * 1e6);
806         setMinDepositAmount(10 * 1e6);
807     }
808 
809     receive() external payable {
810         revert("Girles Presale: BAD_CALL");
811     }
812 
813     function setEnableVesting(bool _enable) external onlyOwner {
814         enableVesting = _enable;
815     }
816 
817     function addPresaleToken(uint256 _amount)
818         external
819         onlyOwner
820     {
821         //transfer from (need allowance)
822         remainedGirles += _amount;
823         totalAddedGirles += _amount;
824 
825         Girles.safeTransferFrom(msg.sender, address(this), _amount);
826 
827         emit PresaleTokenAdded(msg.sender, _amount);
828     }
829 
830     function calculateETHfromUSDT(uint _amountUSDT) public view returns(uint amountETH) {
831         (, int pricefeedETH, , , ) = priceFeedofUSDT2ETH.latestRoundData();
832 
833         amountETH = _amountUSDT * uint(pricefeedETH) / 1e6;
834 
835         return amountETH;
836     }
837 
838     function setGirlesPrice(uint _rateUSDT) public onlyOwner {
839         pricebyUSDT = _rateUSDT;
840     }
841 
842     function setMaxDepositAmount(uint _amountUSDT) public onlyOwner {
843         MAX_USDT_DEPOSIT = _amountUSDT;
844         MAX_ETH_DEPOSIT = calculateETHfromUSDT(_amountUSDT);
845     }
846 
847     function setMinDepositAmount(uint _amountUSDT) public onlyOwner {
848         MIN_USDT_DEPOSIT = _amountUSDT;
849         MIN_ETH_DEPOSIT = calculateETHfromUSDT(_amountUSDT);
850     }
851 
852     function setPresaleDuration(uint _periodDuration) public onlyOwner {
853         require(_periodDuration >= MAX_PERIOD_DURATION, "Period Duration: INVALID_VALUE");
854         periodDuration = _periodDuration;
855         depositEnd = depositBegin + periodDuration;
856     }
857 
858     function deposit() external payable {
859         require(block.timestamp >= depositBegin, "Girles Presale: TOO_SOON");
860         require(block.timestamp < depositEnd, "Girles Presale: TOO_LATE");
861 
862         require(msg.value >= MIN_ETH_DEPOSIT, "Girles Presale: INVALID_VALUE");
863         require(msg.value <= MAX_ETH_DEPOSIT, "Girles Presale: INVALID_VALUE");
864 
865         uint priceETH = calculateETHfromUSDT(pricebyUSDT);
866         uint amount = msg.value * 1e6 / priceETH;
867         require(amount <= remainedGirles, "Girles Presale: Girles balancer not sufficient");
868 
869         recipients[msg.sender].shares += msg.value;
870         recipients[msg.sender].totalRewards += amount;
871 
872         totalFundsETH += msg.value;
873 
874         remainedGirles -= amount;
875 
876         if (remainedGirles == 0) {
877             depositEnd = block.timestamp;
878         }
879 
880         emit DepositETH(msg.sender, msg.value);
881     }
882 
883     function depositbyUSDT(uint _fund) external {
884         require(block.timestamp >= depositBegin, "Girles Presale: TOO_SOON");
885         require(block.timestamp <= depositEnd, "Girles Presale: TOO_LATE");
886 
887         require(_fund >= MIN_USDT_DEPOSIT, "Girles Presale: INVALID_VALUE");
888         require(_fund <= MAX_USDT_DEPOSIT, "Girles Presale: INVALID_VALUE");
889 
890         uint amount = _fund * 1e6 / pricebyUSDT;
891         require(amount <= remainedGirles, "Girles Presale: Girles balancer not sufficient");
892 
893         recipients[msg.sender].sharesbyUSDT += _fund;
894         recipients[msg.sender].totalRewards += amount;
895 
896         totalFundsUSDT += _fund;
897 
898         remainedGirles -= amount;
899 
900         if (remainedGirles == 0) {
901             depositEnd = block.timestamp;
902         }
903 
904         USDT.safeTransferFrom( msg.sender, address(this), _fund);
905 
906         emit DepositUSDT(msg.sender, _fund);
907     }
908 
909     function calculateCredit(address _account) public view returns (uint credit) {
910        return recipients[_account].totalRewards - recipients[msg.sender].claimed;
911     }
912 
913     function claim() external nonReentrant {
914         require(enableVesting, "Girles Presale: Vesting not enabled");
915         require(block.timestamp > depositEnd, "Girles Presale: TOO_EARLY");
916 
917         uint amount = calculateCredit(msg.sender);
918         require(amount > 0, "Girles Presale: No claimable Girles.");
919         
920         require(Girles.balanceOf(address(this)) >= amount, "Girles Presale: Insufficient Girles balance.");
921 
922         recipients[msg.sender].claimed = amount;
923         Girles.safeTransfer(msg.sender, amount);
924         
925         emit Claim(msg.sender, amount);
926     }
927 
928     function getTotalAddedGirles() public view returns (uint) {
929         return totalAddedGirles;
930     }
931 
932     function getBalanceOfGirles() public view returns (uint) {
933         return remainedGirles;
934     }
935 
936     function getFundAmount() public view returns(uint) {
937         return address(this).balance;
938     }
939 
940     function getUSDTFundAmount() public view returns(uint) {
941         return USDT.balanceOf(address(this));
942     }
943 
944     /**
945      * @dev It allows the admin to withdraw ETH sent to the contract by the users, 
946      * only callable by owner.
947      */
948     function withdrawETH() public onlyOwner nonReentrant {
949         uint256 funds = address(this).balance;
950 
951         require(funds > 0, "Girles Presale: No balance of ETH.");
952         require(payable(msg.sender).send(funds));
953 
954         emit WithdrawETH(msg.sender, address(this).balance);
955     }
956 
957     /**
958      * @dev It allows the admin to withdraw USDT sent to the contract by the users, 
959      * only callable by owner.
960      */
961     function withdrawUSDT() public onlyOwner nonReentrant {
962         uint256 funds = USDT.balanceOf(address(this));
963 
964         require(funds > 0, "Girles Presale: No balance of USDT.");
965         USDT.safeTransfer(msg.sender, funds);
966 
967         emit WithdrawUSDT(msg.sender, funds);
968     }
969 
970     /**
971      * @dev It allows the admin to withdraw USDT sent to the contract by the users, 
972      * only callable by owner.
973      */
974     function withdrawGirles() public onlyOwner nonReentrant {
975         require(remainedGirles > 0, "Girles Presale: No balance of Girles.");
976         require(remainedGirles <= Girles.balanceOf(address(this)), "Girles Presale: Insufficient balance of Girles.");
977 
978         Girles.safeTransfer(msg.sender, remainedGirles);
979 
980         emit WithdrawGirles(msg.sender, remainedGirles);
981 
982         remainedGirles = 0;
983     }
984 }