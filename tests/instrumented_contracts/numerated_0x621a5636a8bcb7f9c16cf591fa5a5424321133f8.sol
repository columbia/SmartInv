1 // SPDX-License-Identifier: MIT
2 // Creator: andreitoma8
3 pragma solidity ^0.8.11;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Emitted when `value` tokens are moved from one account (`from`) to
11      * another (`to`).
12      *
13      * Note that `value` may be zero.
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     /**
18      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
19      * a call to {approve}. `value` is the new allowance.
20      */
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `to`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address to, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `from` to `to` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address from,
78         address to,
79         uint256 amount
80     ) external returns (bool);
81 }
82 
83 /**
84  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
85  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
86  *
87  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
88  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
89  * need to send a transaction, and thus is not required to hold Ether at all.
90  */
91 interface IERC20Permit {
92     /**
93      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
94      * given ``owner``'s signed approval.
95      *
96      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
97      * ordering also apply here.
98      *
99      * Emits an {Approval} event.
100      *
101      * Requirements:
102      *
103      * - `spender` cannot be the zero address.
104      * - `deadline` must be a timestamp in the future.
105      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
106      * over the EIP712-formatted function arguments.
107      * - the signature must use ``owner``'s current nonce (see {nonces}).
108      *
109      * For more information on the signature format, see the
110      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
111      * section].
112      */
113     function permit(
114         address owner,
115         address spender,
116         uint256 value,
117         uint256 deadline,
118         uint8 v,
119         bytes32 r,
120         bytes32 s
121     ) external;
122 
123     /**
124      * @dev Returns the current nonce for `owner`. This value must be
125      * included whenever a signature is generated for {permit}.
126      *
127      * Every successful call to {permit} increases ``owner``'s nonce by one. This
128      * prevents a signature from being used multiple times.
129      */
130     function nonces(address owner) external view returns (uint256);
131 
132     /**
133      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
134      */
135     // solhint-disable-next-line func-name-mixedcase
136     function DOMAIN_SEPARATOR() external view returns (bytes32);
137 }
138 /**
139  * @dev Collection of functions related to the address type
140  */
141 library Address {
142     /**
143      * @dev Returns true if `account` is a contract.
144      *
145      * [IMPORTANT]
146      * ====
147      * It is unsafe to assume that an address for which this function returns
148      * false is an externally-owned account (EOA) and not a contract.
149      *
150      * Among others, `isContract` will return false for the following
151      * types of addresses:
152      *
153      *  - an externally-owned account
154      *  - a contract in construction
155      *  - an address where a contract will be created
156      *  - an address where a contract lived, but was destroyed
157      * ====
158      *
159      * [IMPORTANT]
160      * ====
161      * You shouldn't rely on `isContract` to protect against flash loan attacks!
162      *
163      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
164      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
165      * constructor.
166      * ====
167      */
168     function isContract(address account) internal view returns (bool) {
169         // This method relies on extcodesize/address.code.length, which returns 0
170         // for contracts in construction, since the code is only stored at the end
171         // of the constructor execution.
172 
173         return account.code.length > 0;
174     }
175 
176     /**
177      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
178      * `recipient`, forwarding all available gas and reverting on errors.
179      *
180      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
181      * of certain opcodes, possibly making contracts go over the 2300 gas limit
182      * imposed by `transfer`, making them unable to receive funds via
183      * `transfer`. {sendValue} removes this limitation.
184      *
185      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
186      *
187      * IMPORTANT: because control is transferred to `recipient`, care must be
188      * taken to not create reentrancy vulnerabilities. Consider using
189      * {ReentrancyGuard} or the
190      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
191      */
192     function sendValue(address payable recipient, uint256 amount) internal {
193         require(address(this).balance >= amount, "Address: insufficient balance");
194 
195         (bool success, ) = recipient.call{value: amount}("");
196         require(success, "Address: unable to send value, recipient may have reverted");
197     }
198 
199     /**
200      * @dev Performs a Solidity function call using a low level `call`. A
201      * plain `call` is an unsafe replacement for a function call: use this
202      * function instead.
203      *
204      * If `target` reverts with a revert reason, it is bubbled up by this
205      * function (like regular Solidity function calls).
206      *
207      * Returns the raw returned data. To convert to the expected return value,
208      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
209      *
210      * Requirements:
211      *
212      * - `target` must be a contract.
213      * - calling `target` with `data` must not revert.
214      *
215      * _Available since v3.1._
216      */
217     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
223      * `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, 0, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but also transferring `value` wei to `target`.
238      *
239      * Requirements:
240      *
241      * - the calling contract must have an ETH balance of at least `value`.
242      * - the called Solidity function must be `payable`.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
256      * with `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(address(this).balance >= value, "Address: insufficient balance for call");
267         (bool success, bytes memory returndata) = target.call{value: value}(data);
268         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
278         return functionStaticCall(target, data, "Address: low-level static call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal view returns (bytes memory) {
292         (bool success, bytes memory returndata) = target.staticcall(data);
293         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         (bool success, bytes memory returndata) = target.delegatecall(data);
318         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
323      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
324      *
325      * _Available since v4.8._
326      */
327     function verifyCallResultFromTarget(
328         address target,
329         bool success,
330         bytes memory returndata,
331         string memory errorMessage
332     ) internal view returns (bytes memory) {
333         if (success) {
334             if (returndata.length == 0) {
335                 // only check isContract if the call was successful and the return data is empty
336                 // otherwise we already know that it was a contract
337                 require(isContract(target), "Address: call to non-contract");
338             }
339             return returndata;
340         } else {
341             _revert(returndata, errorMessage);
342         }
343     }
344 
345     /**
346      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
347      * revert reason or using the provided one.
348      *
349      * _Available since v4.3._
350      */
351     function verifyCallResult(
352         bool success,
353         bytes memory returndata,
354         string memory errorMessage
355     ) internal pure returns (bytes memory) {
356         if (success) {
357             return returndata;
358         } else {
359             _revert(returndata, errorMessage);
360         }
361     }
362 
363     function _revert(bytes memory returndata, string memory errorMessage) private pure {
364         // Look for revert reason and bubble it up if present
365         if (returndata.length > 0) {
366             // The easiest way to bubble the revert reason is using memory via assembly
367             /// @solidity memory-safe-assembly
368             assembly {
369                 let returndata_size := mload(returndata)
370                 revert(add(32, returndata), returndata_size)
371             }
372         } else {
373             revert(errorMessage);
374         }
375     }
376 }
377 
378 /**
379  * @title SafeERC20
380  * @dev Wrappers around ERC20 operations that throw on failure (when the token
381  * contract returns false). Tokens that return no value (and instead revert or
382  * throw on failure) are also supported, non-reverting calls are assumed to be
383  * successful.
384  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
385  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
386  */
387 library SafeERC20 {
388     using Address for address;
389 
390     function safeTransfer(
391         IERC20 token,
392         address to,
393         uint256 value
394     ) internal {
395         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
396     }
397 
398     function safeTransferFrom(
399         IERC20 token,
400         address from,
401         address to,
402         uint256 value
403     ) internal {
404         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
405     }
406 
407     /**
408      * @dev Deprecated. This function has issues similar to the ones found in
409      * {IERC20-approve}, and its usage is discouraged.
410      *
411      * Whenever possible, use {safeIncreaseAllowance} and
412      * {safeDecreaseAllowance} instead.
413      */
414     function safeApprove(
415         IERC20 token,
416         address spender,
417         uint256 value
418     ) internal {
419         // safeApprove should only be called when setting an initial allowance,
420         // or when resetting it to zero. To increase and decrease it, use
421         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
422         require(
423             (value == 0) || (token.allowance(address(this), spender) == 0),
424             "SafeERC20: approve from non-zero to non-zero allowance"
425         );
426         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
427     }
428 
429     function safeIncreaseAllowance(
430         IERC20 token,
431         address spender,
432         uint256 value
433     ) internal {
434         uint256 newAllowance = token.allowance(address(this), spender) + value;
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
436     }
437 
438     function safeDecreaseAllowance(
439         IERC20 token,
440         address spender,
441         uint256 value
442     ) internal {
443         unchecked {
444             uint256 oldAllowance = token.allowance(address(this), spender);
445             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
446             uint256 newAllowance = oldAllowance - value;
447             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
448         }
449     }
450 
451     function safePermit(
452         IERC20Permit token,
453         address owner,
454         address spender,
455         uint256 value,
456         uint256 deadline,
457         uint8 v,
458         bytes32 r,
459         bytes32 s
460     ) internal {
461         uint256 nonceBefore = token.nonces(owner);
462         token.permit(owner, spender, value, deadline, v, r, s);
463         uint256 nonceAfter = token.nonces(owner);
464         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
465     }
466 
467     /**
468      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
469      * on the return value: the return value is optional (but if data is returned, it must not be false).
470      * @param token The token targeted by the call.
471      * @param data The call data (encoded using abi.encode or one of its variants).
472      */
473     function _callOptionalReturn(IERC20 token, bytes memory data) private {
474         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
475         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
476         // the target address contains contract code and also asserts for success in the low-level call.
477 
478         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
479         if (returndata.length > 0) {
480             // Return data is optional
481             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
482         }
483     }
484 }
485 
486 /**
487  * @dev Interface of the ERC165 standard, as defined in the
488  * https://eips.ethereum.org/EIPS/eip-165[EIP].
489  *
490  * Implementers can declare support of contract interfaces, which can then be
491  * queried by others ({ERC165Checker}).
492  *
493  * For an implementation, see {ERC165}.
494  */
495 interface IERC165 {
496     /**
497      * @dev Returns true if this contract implements the interface defined by
498      * `interfaceId`. See the corresponding
499      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
500      * to learn more about how these ids are created.
501      *
502      * This function call must use less than 30 000 gas.
503      */
504     function supportsInterface(bytes4 interfaceId) external view returns (bool);
505 }
506 
507 /**
508  * @dev Required interface of an ERC721 compliant contract.
509  */
510 interface IERC721 is IERC165 {
511     /**
512      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
513      */
514     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
515 
516     /**
517      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
518      */
519     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
523      */
524     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
525 
526     /**
527      * @dev Returns the number of tokens in ``owner``'s account.
528      */
529     function balanceOf(address owner) external view returns (uint256 balance);
530 
531     /**
532      * @dev Returns the owner of the `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function ownerOf(uint256 tokenId) external view returns (address owner);
539 
540     /**
541      * @dev Safely transfers `tokenId` token from `from` to `to`.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must exist and be owned by `from`.
548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
550      *
551      * Emits a {Transfer} event.
552      */
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId,
557         bytes calldata data
558     ) external;
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
562      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external;
579 
580     /**
581      * @dev Transfers `tokenId` token from `from` to `to`.
582      *
583      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must be owned by `from`.
590      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
591      *
592      * Emits a {Transfer} event.
593      */
594     function transferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
602      * The approval is cleared when the token is transferred.
603      *
604      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
605      *
606      * Requirements:
607      *
608      * - The caller must own the token or be an approved operator.
609      * - `tokenId` must exist.
610      *
611      * Emits an {Approval} event.
612      */
613     function approve(address to, uint256 tokenId) external;
614 
615     /**
616      * @dev Approve or remove `operator` as an operator for the caller.
617      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
618      *
619      * Requirements:
620      *
621      * - The `operator` cannot be the caller.
622      *
623      * Emits an {ApprovalForAll} event.
624      */
625     function setApprovalForAll(address operator, bool _approved) external;
626 
627     /**
628      * @dev Returns the account approved for `tokenId` token.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function getApproved(uint256 tokenId) external view returns (address operator);
635 
636     /**
637      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
638      *
639      * See {setApprovalForAll}
640      */
641     function isApprovedForAll(address owner, address operator) external view returns (bool);
642 }
643 
644 /**
645  * @dev Provides information about the current execution context, including the
646  * sender of the transaction and its data. While these are generally available
647  * via msg.sender and msg.data, they should not be accessed in such a direct
648  * manner, since when dealing with meta-transactions the account sending and
649  * paying for execution may not be the actual sender (as far as an application
650  * is concerned).
651  *
652  * This contract is only required for intermediate, library-like contracts.
653  */
654 abstract contract Context {
655     function _msgSender() internal view virtual returns (address) {
656         return msg.sender;
657     }
658 
659     function _msgData() internal view virtual returns (bytes calldata) {
660         return msg.data;
661     }
662 }
663 
664 /**
665  * @dev Contract module which provides a basic access control mechanism, where
666  * there is an account (an owner) that can be granted exclusive access to
667  * specific functions.
668  *
669  * By default, the owner account will be the one that deploys the contract. This
670  * can later be changed with {transferOwnership}.
671  *
672  * This module is used through inheritance. It will make available the modifier
673  * `onlyOwner`, which can be applied to your functions to restrict their use to
674  * the owner.
675  */
676 abstract contract Ownable is Context {
677     address private _owner;
678 
679     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
680 
681     /**
682      * @dev Initializes the contract setting the deployer as the initial owner.
683      */
684     constructor() {
685         _transferOwnership(_msgSender());
686     }
687 
688     /**
689      * @dev Throws if called by any account other than the owner.
690      */
691     modifier onlyOwner() {
692         _checkOwner();
693         _;
694     }
695 
696     /**
697      * @dev Returns the address of the current owner.
698      */
699     function owner() public view virtual returns (address) {
700         return _owner;
701     }
702 
703     /**
704      * @dev Throws if the sender is not the owner.
705      */
706     function _checkOwner() internal view virtual {
707         require(owner() == _msgSender(), "Ownable: caller is not the owner");
708     }
709 
710     /**
711      * @dev Leaves the contract without owner. It will not be possible to call
712      * `onlyOwner` functions anymore. Can only be called by the current owner.
713      *
714      * NOTE: Renouncing ownership will leave the contract without an owner,
715      * thereby removing any functionality that is only available to the owner.
716      */
717     function renounceOwnership() public virtual onlyOwner {
718         _transferOwnership(address(0));
719     }
720 
721     /**
722      * @dev Transfers ownership of the contract to a new account (`newOwner`).
723      * Can only be called by the current owner.
724      */
725     function transferOwnership(address newOwner) public virtual onlyOwner {
726         require(newOwner != address(0), "Ownable: new owner is the zero address");
727         _transferOwnership(newOwner);
728     }
729 
730     /**
731      * @dev Transfers ownership of the contract to a new account (`newOwner`).
732      * Internal function without access restriction.
733      */
734     function _transferOwnership(address newOwner) internal virtual {
735         address oldOwner = _owner;
736         _owner = newOwner;
737         emit OwnershipTransferred(oldOwner, newOwner);
738     }
739 }
740 /**
741  * @dev Contract module that helps prevent reentrant calls to a function.
742  *
743  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
744  * available, which can be applied to functions to make sure there are no nested
745  * (reentrant) calls to them.
746  *
747  * Note that because there is a single `nonReentrant` guard, functions marked as
748  * `nonReentrant` may not call one another. This can be worked around by making
749  * those functions `private`, and then adding `external` `nonReentrant` entry
750  * points to them.
751  *
752  * TIP: If you would like to learn more about reentrancy and alternative ways
753  * to protect against it, check out our blog post
754  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
755  */
756 abstract contract ReentrancyGuard {
757     // Booleans are more expensive than uint256 or any type that takes up a full
758     // word because each write operation emits an extra SLOAD to first read the
759     // slot's contents, replace the bits taken up by the boolean, and then write
760     // back. This is the compiler's defense against contract upgrades and
761     // pointer aliasing, and it cannot be disabled.
762 
763     // The values being non-zero value makes deployment a bit more expensive,
764     // but in exchange the refund on every call to nonReentrant will be lower in
765     // amount. Since refunds are capped to a percentage of the total
766     // transaction's gas, it is best to keep them low in cases like this one, to
767     // increase the likelihood of the full refund coming into effect.
768     uint256 private constant _NOT_ENTERED = 1;
769     uint256 private constant _ENTERED = 2;
770 
771     uint256 private _status;
772 
773     constructor() {
774         _status = _NOT_ENTERED;
775     }
776 
777     /**
778      * @dev Prevents a contract from calling itself, directly or indirectly.
779      * Calling a `nonReentrant` function from another `nonReentrant`
780      * function is not supported. It is possible to prevent this from happening
781      * by making the `nonReentrant` function external, and making it call a
782      * `private` function that does the actual work.
783      */
784     modifier nonReentrant() {
785         _nonReentrantBefore();
786         _;
787         _nonReentrantAfter();
788     }
789 
790     function _nonReentrantBefore() private {
791         // On the first call to nonReentrant, _notEntered will be true
792         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
793 
794         // Any calls to nonReentrant after this point will fail
795         _status = _ENTERED;
796     }
797 
798     function _nonReentrantAfter() private {
799         // By storing the original value once again, a refund is triggered (see
800         // https://eips.ethereum.org/EIPS/eip-2200)
801         _status = _NOT_ENTERED;
802     }
803 }
804 
805 library Strings {
806     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
807     uint8 private constant _ADDRESS_LENGTH = 20;
808 
809     /**
810      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
811      */
812     function toString(uint256 value) internal pure returns (string memory) {
813         // Inspired by OraclizeAPI's implementation - MIT licence
814         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
815 
816         if (value == 0) {
817             return "0";
818         }
819         uint256 temp = value;
820         uint256 digits;
821         while (temp != 0) {
822             digits++;
823             temp /= 10;
824         }
825         bytes memory buffer = new bytes(digits);
826         while (value != 0) {
827             digits -= 1;
828             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
829             value /= 10;
830         }
831         return string(buffer);
832     }
833 
834     /**
835      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
836      */
837     function toHexString(uint256 value) internal pure returns (string memory) {
838         if (value == 0) {
839             return "0x00";
840         }
841         uint256 temp = value;
842         uint256 length = 0;
843         while (temp != 0) {
844             length++;
845             temp >>= 8;
846         }
847         return toHexString(value, length);
848     }
849 
850     /**
851      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
852      */
853     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
854         bytes memory buffer = new bytes(2 * length + 2);
855         buffer[0] = "0";
856         buffer[1] = "x";
857         for (uint256 i = 2 * length + 1; i > 1; --i) {
858             buffer[i] = _HEX_SYMBOLS[value & 0xf];
859             value >>= 4;
860         }
861         require(value == 0, "Strings: hex length insufficient");
862         return string(buffer);
863     }
864 
865     /**
866      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
867      */
868     function toHexString(address addr) internal pure returns (string memory) {
869         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
870     }
871 }
872 
873 contract BBRCStaking is Ownable, ReentrancyGuard {
874     using SafeERC20 for IERC20;
875 
876     // Interfaces for ERC20 and ERC721
877     // Rinkeby network
878     IERC20 public immutable rewardsToken = IERC20(0x42F116bdB4E9f7625A413722a16462AeF0d57Ebc);
879     IERC721 public immutable nftCollection  = IERC721(0x9450ff0503f3FbF2BC85E9d71f46e47d61777F63);
880 
881     // Goerli network
882     //IERC20 public immutable rewardsToken = IERC20(0x2dd3E8BaCa63a6685276f4b30cd5274ACA929C6b);
883     //IERC721 public immutable nftCollection  = IERC721(0x47C3A6F40E4fD7f2f7b9a9a43B50609d18C934da);
884 
885     // Staker info
886     struct Staker {
887         // Amount of ERC721 Tokens staked
888         uint256 amountStaked;
889         // Last time of details update for this User
890         uint256 timeOfLastUpdate;
891         // Calculated, but unclaimed rewards for the User. The rewards are
892         // calculated each time the user writes to the Smart Contract
893         uint256 unclaimedRewards;
894         // date stake
895         uint256 timeOfLastStake;
896     }
897 
898     // Rewards per hour per token deposited in wei.
899     // Rewards are cumulated once every hour.
900     uint256 private rewardsPerHour = 1000000000000000;
901 
902     // agree withdraw tokens after some hours
903     uint private agreeWithdrawAfterHours = 24;
904 
905     // Mapping of User Address to Staker info
906     mapping(address => Staker) public stakers;
907     // Mapping of Token Id to staker. Made for the SC to remeber
908     // who to send back the ERC721 Token to.
909     mapping(uint256 => address) public stakerAddress;
910 
911     uint256[] public stakedTokenIds;
912 
913     // Constructor function
914     constructor() {
915     }
916 
917     // If address already has ERC721 Token/s staked, calculate the rewards.
918     // For every new Token Id in param transferFrom user to this Smart Contract,
919     // increment the amountStaked and map msg.sender to the Token Id of the staked
920     // Token to later send back on withdrawal. Finally give timeOfLastUpdate the
921     // value of now.
922     function stake(uint256[] calldata _tokenIds) external nonReentrant {
923         uint256 len = 0;
924         for (uint256 i = 0; i < _tokenIds.length; i++) {
925             if( nftCollection.ownerOf(_tokenIds[i]) == msg.sender && stakerAddress[_tokenIds[i]] != msg.sender ){
926                 nftCollection.transferFrom(msg.sender, address(this), _tokenIds[i]);
927                 stakerAddress[_tokenIds[i]] = msg.sender;
928                 stakedTokenIds.push(_tokenIds[i]);
929                 len++;
930             }
931         }
932         if(len > 0){
933             if (stakers[msg.sender].amountStaked > 0) {
934                 uint256 rewards = calculateRewards(msg.sender);
935                 stakers[msg.sender].unclaimedRewards += rewards;
936             }
937             stakers[msg.sender].amountStaked += len;
938             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
939             stakers[msg.sender].timeOfLastStake = block.timestamp;
940         }
941     }
942 
943     // Check if user has any ERC721 Tokens Staked and if he tried to withdraw,
944     // calculate the rewards and store them in the unclaimedRewards and for each
945     // ERC721 Token in param: check if msg.sender is the original staker, decrement
946     // the amountStaked of the user and transfer the ERC721 token back to them
947     function withdraw(uint256[] calldata _tokenIds) external nonReentrant {
948         require(
949             stakers[msg.sender].amountStaked > 0,
950             "You have no tokens staked"
951         );
952 
953         require(
954             (block.timestamp - stakers[msg.sender].timeOfLastStake)/3600 >= agreeWithdrawAfterHours,
955             "You only withdraw tokens after a few hours from the last stake"
956         );        
957         uint256 len = 0;
958         for (uint256 i = 0; i < _tokenIds.length; i++) {
959             if(stakerAddress[_tokenIds[i]] == msg.sender){
960                 stakerAddress[_tokenIds[i]] = address(0);
961                 nftCollection.transferFrom(address(this), msg.sender, _tokenIds[i]);
962                 removeElement(stakedTokenIds,_tokenIds[i]);
963                 len++;
964             }
965         }
966         if(len > 0){
967             uint256 rewards = calculateRewards(msg.sender);
968             stakers[msg.sender].unclaimedRewards += rewards;
969             stakers[msg.sender].amountStaked -= len;
970             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
971         }
972     }
973 
974     // Calculate rewards for the msg.sender, check if there are any rewards
975     // claim, set unclaimedRewards to 0 and transfer the ERC20 Reward token
976     // to the user.
977     function claimRewards() external {
978         uint256 rewards = calculateRewards(msg.sender) + stakers[msg.sender].unclaimedRewards;
979         require(rewards > 0, "You have no rewards to claim");
980         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
981         stakers[msg.sender].unclaimedRewards = 0;
982         rewardsToken.safeTransfer(msg.sender, rewards);
983     }
984 
985     function removeElement(uint256[] storage _array, uint256 _element) internal {
986         for (uint256 i; i<_array.length; i++) {
987             if (_array[i] == _element) {
988                 _array[i] = _array[_array.length - 1];
989                 _array.pop();
990                 break;
991             }
992         }
993     }
994 
995     //////////
996     // View //
997     //////////
998 
999     function userStakeInfo(address _user)
1000         public
1001         view
1002         returns (string memory _stakedTokenIds, uint256 _availableRewards, uint256 _totalStakedTokenId)
1003     {
1004         string memory tokenIds = "";
1005         uint256 index = 0;
1006         for(uint256 i = 0; i < stakedTokenIds.length; i++){
1007             if(stakerAddress[stakedTokenIds[i]] == _user){
1008                 tokenIds = string(abi.encodePacked(tokenIds, index == 0 ? "" : "," , Strings.toString( stakedTokenIds[i] )));
1009                 index++;
1010             }
1011         }
1012         return (tokenIds, availableRewards(_user), index);
1013     }
1014 
1015     function stakeInfo()
1016         public
1017         view
1018         returns (uint256 _totalStakedTokenId, uint256 _agreeWithdrawAfterHours, uint256 _rewardsPerHour)
1019     {
1020         //string memory tokenIds = "";
1021         uint256 index = 0;
1022         for(uint256 i = 0; i < stakedTokenIds.length; i++){
1023             if(stakerAddress[stakedTokenIds[i]] != address(0)){
1024                 index++;
1025             }
1026         }
1027         return (index, agreeWithdrawAfterHours, rewardsPerHour);
1028     }
1029 
1030 
1031     function availableRewards(address _user) internal view returns (uint256) {
1032         uint256 _rewards = stakers[_user].unclaimedRewards + calculateRewards(_user);
1033         return _rewards;
1034     }
1035 
1036     /////////////
1037     // Internal//
1038     /////////////
1039 
1040     // Calculate rewards for param _staker by calculating the time passed
1041     // since last update in hours and mulitplying it to ERC721 Tokens Staked
1042     // and rewardsPerHour.
1043     function calculateRewards(address _staker)
1044         internal
1045         view
1046         returns (uint256 _rewards)
1047     {
1048         if(stakers[_staker].amountStaked <= 0){
1049             return 0;
1050         }
1051         return (((
1052             ((block.timestamp - stakers[_staker].timeOfLastUpdate) *
1053                 stakers[_staker].amountStaked)
1054         ) * rewardsPerHour) / 3600);
1055     }
1056 
1057     function setAgreeWithdrawAfterHours(uint _agreeWithdrawAfterHours) public onlyOwner{
1058         agreeWithdrawAfterHours = _agreeWithdrawAfterHours;
1059     }
1060 
1061     function setRewardsPerHour(uint _rewardsPerHour) public onlyOwner{
1062         rewardsPerHour = _rewardsPerHour;
1063     }
1064 
1065     function withdrawErc20() public onlyOwner{
1066         rewardsToken.safeTransfer(msg.sender, rewardsToken.balanceOf(address(this)));
1067     }
1068 }