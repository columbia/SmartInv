1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
26 
27 
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private  _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _transferOwnership(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 
102 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
103 
104 
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Contract module that helps prevent reentrant calls to a function.
110  *
111  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
112  * available, which can be applied to functions to make sure there are no nested
113  * (reentrant) calls to them.
114  *
115  * Note that because there is a single `nonReentrant` guard, functions marked as
116  * `nonReentrant` may not call one another. This can be worked around by making
117  * those functions `private`, and then adding `external` `nonReentrant` entry
118  * points to them.
119  *
120  * TIP: If you would like to learn more about reentrancy and alternative ways
121  * to protect against it, check out our blog post
122  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
123  */
124 abstract contract ReentrancyGuard {
125     // Booleans are more expensive than uint256 or any type that takes up a full
126     // word because each write operation emits an extra SLOAD to first read the
127     // slot's contents, replace the bits taken up by the boolean, and then write
128     // back. This is the compiler's defense against contract upgrades and
129     // pointer aliasing, and it cannot be disabled.
130 
131     // The values being non-zero value makes deployment a bit more expensive,
132     // but in exchange the refund on every call to nonReentrant will be lower in
133     // amount. Since refunds are capped to a percentage of the total
134     // transaction's gas, it is best to keep them low in cases like this one, to
135     // increase the likelihood of the full refund coming into effect.
136     uint256 private constant _NOT_ENTERED = 1;
137     uint256 private constant _ENTERED = 2;
138 
139     uint256 private _status;
140 
141     constructor() {
142         _status = _NOT_ENTERED;
143     }
144 
145     /**
146      * @dev Prevents a contract from calling itself, directly or indirectly.
147      * Calling a `nonReentrant` function from another `nonReentrant`
148      * function is not supported. It is possible to prevent this from happening
149      * by making the `nonReentrant` function external, and making it call a
150      * `private` function that does the actual work.
151      */
152     modifier nonReentrant() {
153         // On the first call to nonReentrant, _notEntered will be true
154         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
155 
156         // Any calls to nonReentrant after this point will fail
157         _status = _ENTERED;
158 
159         _;
160 
161         // By storing the original value once again, a refund is triggered (see
162         // https://eips.ethereum.org/EIPS/eip-2200)
163         _status = _NOT_ENTERED;
164     }
165 }
166 
167 
168 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
169 
170 
171 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Interface of the ERC20 standard as defined in the EIP.
177  */
178 interface IERC20 {
179     /**
180      * @dev Returns the amount of tokens in existence.
181      */
182     function totalSupply() external view returns (uint256);
183 
184     /**
185      * @dev Returns the amount of tokens owned by `account`.
186      */
187     function balanceOf(address account) external view returns (uint256);
188 
189     /**
190      * @dev Moves `amount` tokens from the caller's account to `to`.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transfer(address to, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Returns the remaining number of tokens that `spender` will be
200      * allowed to spend on behalf of `owner` through {transferFrom}. This is
201      * zero by default.
202      *
203      * This value changes when {approve} or {transferFrom} are called.
204      */
205     function allowance(address owner, address spender) external view returns (uint256);
206 
207     /**
208      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * IMPORTANT: Beware that changing an allowance with this method brings the risk
213      * that someone may use both the old and the new allowance by unfortunate
214      * transaction ordering. One possible solution to mitigate this race
215      * condition is to first reduce the spender's allowance to 0 and set the
216      * desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      *
219      * Emits an {Approval} event.
220      */
221     function approve(address spender, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Moves `amount` tokens from `from` to `to` using the
225      * allowance mechanism. `amount` is then deducted from the caller's
226      * allowance.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * Emits a {Transfer} event.
231      */
232     function transferFrom(
233         address from,
234         address to,
235         uint256 amount
236     ) external returns (bool);
237 
238     /**
239      * @dev Emitted when `value` tokens are moved from one account (`from`) to
240      * another (`to`).
241      *
242      * Note that `value` may be zero.
243      */
244     event Transfer(address indexed from, address indexed to, uint256 value);
245 
246     /**
247      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
248      * a call to {approve}. `value` is the new allowance.
249      */
250     event Approval(address indexed owner, address indexed spender, uint256 value);
251 }
252 
253 
254 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
255 
256 
257 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
258 
259 pragma solidity ^0.8.1;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      *
282      * [IMPORTANT]
283      * ====
284      * You shouldn't rely on `isContract` to protect against flash loan attacks!
285      *
286      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
287      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
288      * constructor.
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize/address.code.length, which returns 0
293         // for contracts in construction, since the code is only stored at the end
294         // of the constructor execution.
295 
296         return account.code.length > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 
480 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @title SafeERC20
490  * @dev Wrappers around ERC20 operations that throw on failure (when the token
491  * contract returns false). Tokens that return no value (and instead revert or
492  * throw on failure) are also supported, non-reverting calls are assumed to be
493  * successful.
494  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
495  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
496  */
497 library SafeERC20 {
498     using Address for address;
499 
500     function safeTransfer(
501         IERC20 token,
502         address to,
503         uint256 value
504     ) internal {
505         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
506     }
507 
508     function safeTransferFrom(
509         IERC20 token,
510         address from,
511         address to,
512         uint256 value
513     ) internal {
514         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
515     }
516 
517     /**
518      * @dev Deprecated. This function has issues similar to the ones found in
519      * {IERC20-approve}, and its usage is discouraged.
520      *
521      * Whenever possible, use {safeIncreaseAllowance} and
522      * {safeDecreaseAllowance} instead.
523      */
524     function safeApprove(
525         IERC20 token,
526         address spender,
527         uint256 value
528     ) internal {
529         // safeApprove should only be called when setting an initial allowance,
530         // or when resetting it to zero. To increase and decrease it, use
531         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
532         require(
533             (value == 0) || (token.allowance(address(this), spender) == 0),
534             "SafeERC20: approve from non-zero to non-zero allowance"
535         );
536         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
537     }
538 
539     function safeIncreaseAllowance(
540         IERC20 token,
541         address spender,
542         uint256 value
543     ) internal {
544         uint256 newAllowance = token.allowance(address(this), spender) + value;
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     function safeDecreaseAllowance(
549         IERC20 token,
550         address spender,
551         uint256 value
552     ) internal {
553         unchecked {
554             uint256 oldAllowance = token.allowance(address(this), spender);
555             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
556             uint256 newAllowance = oldAllowance - value;
557             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
558         }
559     }
560 
561     /**
562      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
563      * on the return value: the return value is optional (but if data is returned, it must not be false).
564      * @param token The token targeted by the call.
565      * @param data The call data (encoded using abi.encode or one of its variants).
566      */
567     function _callOptionalReturn(IERC20 token, bytes memory data) private {
568         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
569         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
570         // the target address contains contract code and also asserts for success in the low-level call.
571 
572         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
573         if (returndata.length > 0) {
574             // Return data is optional
575             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
576         }
577     }
578 }
579 
580 pragma solidity ^0.8.0;
581 
582 /**
583  * @dev Interface of the ERC165 standard, as defined in the
584  * https://eips.ethereum.org/EIPS/eip-165[EIP].
585  *
586  * Implementers can declare support of contract interfaces, which can then be
587  * queried by others ({ERC165Checker}).
588  *
589  * For an implementation, see {ERC165}.
590  */
591 interface IERC165 {
592     /**
593      * @dev Returns true if this contract implements the interface defined by
594      * `interfaceId`. See the corresponding
595      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
596      * to learn more about how these ids are created.
597      *
598      * This function call must use less than 30 000 gas.
599      */
600     function supportsInterface(bytes4 interfaceId) external view returns (bool);
601 }
602 
603 
604 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @dev Required interface of an ERC721 compliant contract.
613  */
614 interface IERC721 is IERC165 {
615     /**
616      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
617      */
618     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
619 
620     /**
621      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
622      */
623     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
624 
625     /**
626      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
627      */
628     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
629 
630     /**
631      * @dev Returns the number of tokens in ``owner``'s account.
632      */
633     function balanceOf(address owner) external view returns (uint256 balance);
634 
635     /**
636      * @dev Returns the owner of the `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function ownerOf(uint256 tokenId) external view returns (address owner);
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Transfers `tokenId` token from `from` to `to`.
666      *
667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Returns the account approved for `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function getApproved(uint256 tokenId) external view returns (address operator);
707 
708     /**
709      * @dev Approve or remove `operator` as an operator for the caller.
710      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
711      *
712      * Requirements:
713      *
714      * - The `operator` cannot be the caller.
715      *
716      * Emits an {ApprovalForAll} event.
717      */
718     function setApprovalForAll(address operator, bool _approved) external;
719 
720     /**
721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
722      *
723      * See {setApprovalForAll}
724      */
725     function isApprovedForAll(address owner, address operator) external view returns (bool);
726 
727     /**
728      * @dev Safely transfers `tokenId` token from `from` to `to`.
729      *
730      * Requirements:
731      *
732      * - `from` cannot be the zero address.
733      * - `to` cannot be the zero address.
734      * - `tokenId` token must exist and be owned by `from`.
735      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId,
744         bytes calldata data
745     ) external;
746 }
747 
748 
749 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @title ERC721 token receiver interface
758  * @dev Interface for any contract that wants to support safeTransfers
759  * from ERC721 asset contracts.
760  */
761 interface IERC721Receiver {
762     /**
763      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
764      * by `operator` from `from`, this function is called.
765      *
766      * It must return its Solidity selector to confirm the token transfer.
767      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
768      *
769      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
770      */
771     function onERC721Received(
772         address operator,
773         address from,
774         uint256 tokenId,
775         bytes calldata data
776     ) external returns (bytes4);
777 }
778 
779 
780 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
781 
782 
783 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
789  * @dev See https://eips.ethereum.org/EIPS/eip-721
790  */
791 interface IERC721Metadata is IERC721 {
792     /**
793      * @dev Returns the token collection name.
794      */
795     function name() external view returns (string memory);
796 
797     /**
798      * @dev Returns the token collection symbol.
799      */
800     function symbol() external view returns (string memory);
801 
802     /**
803      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
804      */
805     function tokenURI(uint256 tokenId) external view returns (string memory);
806 }
807 
808 
809 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
810 
811 
812 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 /**
817  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
818  * @dev See https://eips.ethereum.org/EIPS/eip-721
819  */
820 interface IERC721Enumerable is IERC721 {
821     /**
822      * @dev Returns the total amount of tokens stored by the contract.
823      */
824     function totalSupply() external view returns (uint256);
825 
826     /**
827      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
828      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
829      */
830     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
831 
832     /**
833      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
834      * Use along with {totalSupply} to enumerate all tokens.
835      */
836     function tokenByIndex(uint256 index) external view returns (uint256);
837 }
838 
839 
840 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
841 
842 
843 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 /**
848  * @dev String operations.
849  */
850 library Strings {
851     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
852 
853     /**
854      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
855      */
856     function toString(uint256 value) internal pure returns (string memory) {
857         // Inspired by OraclizeAPI's implementation - MIT licence
858         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
859 
860         if (value == 0) {
861             return "0";
862         }
863         uint256 temp = value;
864         uint256 digits;
865         while (temp != 0) {
866             digits++;
867             temp /= 10;
868         }
869         bytes memory buffer = new bytes(digits);
870         while (value != 0) {
871             digits -= 1;
872             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
873             value /= 10;
874         }
875         return string(buffer);
876     }
877 
878     /**
879      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
880      */
881     function toHexString(uint256 value) internal pure returns (string memory) {
882         if (value == 0) {
883             return "0x00";
884         }
885         uint256 temp = value;
886         uint256 length = 0;
887         while (temp != 0) {
888             length++;
889             temp >>= 8;
890         }
891         return toHexString(value, length);
892     }
893 
894     /**
895      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
896      */
897     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
898         bytes memory buffer = new bytes(2 * length + 2);
899         buffer[0] = "0";
900         buffer[1] = "x";
901         for (uint256 i = 2 * length + 1; i > 1; --i) {
902             buffer[i] = _HEX_SYMBOLS[value & 0xf];
903             value >>= 4;
904         }
905         require(value == 0, "Strings: hex length insufficient");
906         return string(buffer);
907     }
908 }
909 
910 
911 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 /**
919  * @dev Implementation of the {IERC165} interface.
920  *
921  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
922  * for the additional interface id that will be supported. For example:
923  *
924  * ```solidity
925  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
926  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
927  * }
928  * ```
929  *
930  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
931  */
932 abstract contract ERC165 is IERC165 {
933     /**
934      * @dev See {IERC165-supportsInterface}.
935      */
936     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
937         return interfaceId == type(IERC165).interfaceId;
938     }
939 }
940 
941 
942 
943 // props to chiru for 721A
944 pragma solidity ^0.8.4;
945 
946 
947 
948 error ApprovalCallerNotOwnerNorApproved();
949 error ApprovalQueryForNonexistentToken();
950 error ApproveToCaller();
951 error ApprovalToCurrentOwner();
952 error BalanceQueryForZeroAddress();
953 error MintToZeroAddress();
954 error MintZeroQuantity();
955 error OwnerQueryForNonexistentToken();
956 error TransferCallerNotOwnerNorApproved();
957 error TransferFromIncorrectOwner();
958 error TransferToNonERC721ReceiverImplementer();
959 error TransferToZeroAddress();
960 error URIQueryForNonexistentToken();
961 
962 /**
963  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
964  * the Metadata extension. Built to optimize for lower gas during batch mints.
965  *
966  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
967  *
968  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
969  *
970  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
971  */
972 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
973     using Address for address;
974     using Strings for uint256;
975 
976     // Compiler will pack this into a single 256bit word.
977     struct TokenOwnership {
978         // The address of the owner.
979         address addr;
980         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
981         uint64 startTimestamp;
982         // Whether the token has been burned.
983         bool burned;
984     }
985 
986     // Compiler will pack this into a single 256bit word.
987     struct AddressData {
988         
989         // Realistically, 2**64-1 is more than enough.
990         uint64 balance;
991         // Keeps track of mint count with minimal overhead for tokenomics.
992         uint64 numberMinted;
993         // Keeps track of burn count with minimal overhead for tokenomics.
994         uint64 numberBurned;
995         // For miscellaneous variable(s) pertaining to the address
996         // (e.g. number of whitelist mint slots used).
997         // If there are multiple variables, please pack them into a uint64.
998         uint64 aux;
999     }
1000 
1001     
1002 
1003     // The tokenId of the next token to be minted.
1004     uint256 internal _currentIndex;
1005 
1006     // The number of tokens burned.
1007     uint256 internal _burnCounter;
1008 
1009     // Token name
1010     string private _name;
1011 
1012     // Token symbol
1013     string private _symbol;
1014 
1015     // Mapping from token ID to ownership details
1016     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1017     mapping(uint256 => TokenOwnership) internal _ownerships;
1018 
1019     // Mapping owner address to address data
1020     mapping(address => AddressData) private _addressData;
1021 
1022     // Mapping from token ID to approved address
1023     mapping(uint256 => address) private _tokenApprovals;
1024 
1025     // Mapping from owner to operator approvals
1026     mapping(address => mapping(address => bool)) private _operatorApprovals;
1027 
1028   
1029  
1030     constructor(string memory name_, string memory symbol_) {
1031         _name = name_;
1032         _symbol = symbol_;
1033         _currentIndex = _startTokenId();
1034         
1035     }
1036     
1037     /**
1038      * To change the starting tokenId, please override this function.
1039      */
1040     function _startTokenId() internal view virtual returns (uint256) {
1041         return 1;
1042     }
1043 
1044     /**
1045      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1046      */
1047     function totalSupply() public view returns (uint256) {
1048         // Counter underflow is impossible as _burnCounter cannot be incremented
1049         // more than _currentIndex - _startTokenId() times
1050         unchecked {
1051             return _currentIndex - _burnCounter - _startTokenId();
1052         }
1053     }
1054 
1055     /**
1056      * Returns the total amount of tokens minted in the contract.
1057      */
1058     function _totalMinted() internal view returns (uint256) {
1059         // Counter underflow is impossible as _currentIndex does not decrement,
1060         // and it is initialized to _startTokenId()
1061         unchecked {
1062             return _currentIndex - _startTokenId();
1063         }
1064     }
1065 
1066     /**
1067      * @dev See {IERC165-supportsInterface}.
1068      */
1069     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1070         return
1071             interfaceId == type(IERC721).interfaceId ||
1072             interfaceId == type(IERC721Metadata).interfaceId ||
1073             super.supportsInterface(interfaceId);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-balanceOf}.
1078      */
1079     function balanceOf(address owner) public view override returns (uint256) {
1080         
1081         return uint256(_addressData[owner].balance);
1082     }
1083 
1084     /**
1085      * Returns the number of tokens minted by `owner`.
1086      */
1087     function _numberMinted(address owner) internal view returns (uint256) {
1088         return uint256(_addressData[owner].numberMinted);
1089     }
1090 
1091     /**
1092      * Returns the number of tokens burned by or on behalf of `owner`.
1093      */
1094     function _numberBurned(address owner) internal view returns (uint256) {
1095         return uint256(_addressData[owner].numberBurned);
1096     }
1097 
1098     /**
1099      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1100      */
1101     function _getAux(address owner) internal view returns (uint64) {
1102         return _addressData[owner].aux;
1103     }
1104 
1105     /**
1106      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1107      * If there are multiple variables, please pack them into a uint64.
1108      */
1109     function _setAux(address owner, uint64 aux) internal {
1110         _addressData[owner].aux = aux;
1111     }
1112 
1113     /**
1114      * Gas spent here starts off proportional to the maximum mint batch size.
1115      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1116      */
1117     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1118         uint256 curr = tokenId;
1119 
1120         unchecked {
1121             if (_startTokenId() <= curr && curr < _currentIndex) {
1122                 TokenOwnership memory ownership = _ownerships[curr];
1123                 if (!ownership.burned) {
1124                     if (ownership.addr != address(0)) {
1125                         return ownership;
1126                     }
1127                     // Invariant:
1128                     // There will always be an ownership that has an address and is not burned
1129                     // before an ownership that does not have an address and is not burned.
1130                     // Hence, curr will not underflow.
1131                     while (true) {
1132                         curr--;
1133                         ownership = _ownerships[curr];
1134                         if (ownership.addr != address(0)) {
1135                             return ownership;
1136                         }
1137                     }
1138                 }
1139             }
1140         }
1141         revert OwnerQueryForNonexistentToken();
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-ownerOf}.
1146      */
1147     function ownerOf(uint256 tokenId) public view override returns (address) {
1148         return _ownershipOf(tokenId).addr;
1149     }
1150 
1151     /**
1152      * @dev See {IERC721Metadata-name}.
1153      */
1154     function name() public view virtual override returns (string memory) {
1155         return _name;
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Metadata-symbol}.
1160      */
1161     function symbol() public view virtual override returns (string memory) {
1162         return _symbol;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Metadata-tokenURI}.
1167      */
1168     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1169         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1170 
1171         string memory baseURI = _baseURI();
1172         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1173     }
1174 
1175     /**
1176      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1177      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1178      * by default, can be overriden in child contracts.
1179      */
1180     function _baseURI() internal view virtual returns (string memory) {
1181         return '';
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-approve}.
1186      */
1187     function approve(address to, uint256 tokenId) public override {
1188         address owner = ERC721A.ownerOf(tokenId);
1189         if (to == owner) revert ApprovalToCurrentOwner();
1190 
1191         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1192             revert ApprovalCallerNotOwnerNorApproved();
1193         }
1194 
1195         _approve(to, tokenId, owner);
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-getApproved}.
1200      */
1201     function getApproved(uint256 tokenId) public view override returns (address) {
1202         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1203 
1204         return _tokenApprovals[tokenId];
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-setApprovalForAll}.
1209      */
1210     function setApprovalForAll(address operator, bool approved) public virtual override {
1211         if (operator == _msgSender()) revert ApproveToCaller();
1212 
1213         _operatorApprovals[_msgSender()][operator] = approved;
1214         emit ApprovalForAll(_msgSender(), operator, approved);
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-isApprovedForAll}.
1219      */
1220     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1221         return _operatorApprovals[owner][operator];
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-transferFrom}.
1226      */
1227     function transferFrom(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) public virtual override {
1232         _transfer(from, to, tokenId);
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-safeTransferFrom}.
1237      */
1238     function safeTransferFrom(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) public virtual override {
1243         safeTransferFrom(from, to, tokenId, '');
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-safeTransferFrom}.
1248      */
1249     function safeTransferFrom(
1250         address from,
1251         address to,
1252         uint256 tokenId,
1253         bytes memory _data
1254     ) public virtual override {
1255         _transfer(from, to, tokenId);
1256         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1257             revert TransferToNonERC721ReceiverImplementer();
1258         }
1259     }
1260 
1261     /**
1262      * @dev Returns whether `tokenId` exists.
1263      *
1264      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1265      *
1266      * Tokens start existing when they are minted (`_mint`),
1267      */
1268     function _exists(uint256 tokenId) internal view returns (bool) {
1269         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1270     }
1271 
1272     function _safeMint(address to, uint256 quantity) internal {
1273         _safeMint(to, quantity, '');
1274     }
1275 
1276     /**
1277      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1278      *
1279      * Requirements:
1280      *
1281      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1282      * - `quantity` must be greater than 0.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _safeMint(
1287         address to,
1288         uint256 quantity,
1289         bytes memory _data
1290     ) internal {
1291         _mint(to, quantity, _data, true);
1292     }
1293 
1294     /**
1295      * @dev Mints `quantity` tokens and transfers them to `to`.
1296      *
1297      * Requirements:
1298      *
1299      * - `to` cannot be the zero address.
1300      * - `quantity` must be greater than 0.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function _mint(
1305         address to,
1306         uint256 quantity,
1307         bytes memory _data,
1308         bool safe
1309     ) internal {
1310         
1311         uint256 startTokenId = _currentIndex;
1312         
1313         if (quantity == 0) revert MintZeroQuantity();
1314           
1315         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1316        
1317         
1318         // Overflows are incredibly unrealistic.
1319         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1320         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1321         unchecked {
1322             _addressData[to].balance += uint64(quantity);
1323             _addressData[to].numberMinted += uint64(quantity);
1324 
1325             _ownerships[startTokenId].addr = to;
1326             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1327 
1328             uint256 updatedIndex = startTokenId;
1329             uint256 end = updatedIndex + quantity;
1330 
1331             if (safe && to.isContract()) {
1332                 do {
1333                     emit Transfer(address(0), to, updatedIndex);
1334                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1335                         revert TransferToNonERC721ReceiverImplementer();
1336                     }
1337                 } while (updatedIndex != end);
1338                 // Reentrancy protection
1339                 if (_currentIndex != startTokenId) revert();
1340             } else {
1341                 do {
1342                     emit Transfer(address(0), to, updatedIndex++);
1343                 } while (updatedIndex != end);
1344             }
1345             _currentIndex = updatedIndex;
1346         }
1347         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1348     }
1349 
1350     /**
1351      * @dev Transfers `tokenId` from `from` to `to`.
1352      *
1353      * Requirements:
1354      *
1355      * - `to` cannot be the zero address.
1356      * - `tokenId` token must be owned by `from`.
1357      *
1358      * Emits a {Transfer} event.
1359      */
1360     function _transfer(
1361         address from,
1362         address to,
1363         uint256 tokenId
1364     ) private {
1365         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1366 
1367         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1368 
1369         bool isApprovedOrOwner = (_msgSender() == from ||
1370             isApprovedForAll(from, _msgSender()) ||
1371             getApproved(tokenId) == _msgSender());
1372 
1373         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1374         if (to == address(0)) revert TransferToZeroAddress();
1375 
1376         _beforeTokenTransfers(from, to, tokenId, 1);
1377 
1378         // Clear approvals from the previous owner
1379         _approve(address(0), tokenId, from);
1380 
1381         // Underflow of the sender's balance is impossible because we check for
1382         // ownership above and the recipient's balance can't realistically overflow.
1383         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1384         unchecked {
1385             _addressData[from].balance -= 1;
1386             _addressData[to].balance += 1;
1387 
1388             TokenOwnership storage currSlot = _ownerships[tokenId];
1389             currSlot.addr = to;
1390             currSlot.startTimestamp = uint64(block.timestamp);
1391 
1392             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1393             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1394             uint256 nextTokenId = tokenId + 1;
1395             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1396             if (nextSlot.addr == address(0)) {
1397                 // This will suffice for checking _exists(nextTokenId),
1398                 // as a burned slot cannot contain the zero address.
1399                 if (nextTokenId != _currentIndex) {
1400                     nextSlot.addr = from;
1401                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1402                 }
1403             }
1404         }
1405  
1406         _afterTokenTransfers(from, to, tokenId, 1);
1407     }
1408 
1409     /**
1410      * @dev This is equivalent to _burn(tokenId, false)
1411      */
1412     function _burn(uint256 tokenId) internal virtual {
1413         _burn(tokenId, false);
1414     }
1415 
1416     /**
1417      * @dev Destroys `tokenId`.
1418      * The approval is cleared when the token is burned.
1419      *
1420      * Requirements:
1421      *
1422      * - `tokenId` must exist.
1423      *
1424      * Emits a {Transfer} event.
1425      */
1426     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1427         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1428 
1429         address from = prevOwnership.addr;
1430 
1431         if (approvalCheck) {
1432             bool isApprovedOrOwner = (_msgSender() == from ||
1433                 isApprovedForAll(from, _msgSender()) ||
1434                 getApproved(tokenId) == _msgSender());
1435 
1436             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1437         }
1438 
1439         _beforeTokenTransfers(from, address(0), tokenId, 1);
1440 
1441         // Clear approvals from the previous owner
1442         _approve(address(0), tokenId, from);
1443 
1444         // Underflow of the sender's balance is impossible because we check for
1445         // ownership above and the recipient's balance can't realistically overflow.
1446         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1447         unchecked {
1448             AddressData storage addressData = _addressData[from];
1449             addressData.balance -= 1;
1450             addressData.numberBurned += 1;
1451 
1452             // Keep track of who burned the token, and the timestamp of burning.
1453             TokenOwnership storage currSlot = _ownerships[tokenId];
1454             currSlot.addr = from;
1455             currSlot.startTimestamp = uint64(block.timestamp);
1456             currSlot.burned = true;
1457 
1458             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1459             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1460             uint256 nextTokenId = tokenId + 1;
1461             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1462             if (nextSlot.addr == address(0)) {
1463                 // This will suffice for checking _exists(nextTokenId),
1464                 // as a burned slot cannot contain the zero address.
1465                 if (nextTokenId != _currentIndex) {
1466                     nextSlot.addr = from;
1467                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1468                 }
1469             }
1470         }
1471 
1472         emit Transfer(from, address(0), tokenId);
1473         _afterTokenTransfers(from, address(0), tokenId, 1);
1474 
1475         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1476         unchecked {
1477             _burnCounter++;
1478         }
1479     }
1480 
1481     /**
1482      * @dev Approve `to` to operate on `tokenId`
1483      *
1484      * Emits a {Approval} event.
1485      */
1486     function _approve(
1487         address to,
1488         uint256 tokenId,
1489         address owner
1490     ) private {
1491         _tokenApprovals[tokenId] = to;
1492         emit Approval(owner, to, tokenId);
1493     }
1494 
1495     /**
1496      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1497      *
1498      * @param from address representing the previous owner of the given token ID
1499      * @param to target address that will receive the tokens
1500      * @param tokenId uint256 ID of the token to be transferred
1501      * @param _data bytes optional data to send along with the call
1502      * @return bool whether the call correctly returned the expected magic value
1503      */
1504     function _checkContractOnERC721Received(
1505         address from,
1506         address to,
1507         uint256 tokenId,
1508         bytes memory _data
1509     ) private returns (bool) {
1510         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1511             return retval == IERC721Receiver(to).onERC721Received.selector;
1512         } catch (bytes memory reason) {
1513             if (reason.length == 0) {
1514                 revert TransferToNonERC721ReceiverImplementer();
1515             } else {
1516                 assembly {
1517                     revert(add(32, reason), mload(reason))
1518                 }
1519             }
1520         }
1521     }
1522 
1523     /**
1524      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1525      * And also called before burning one token.
1526      *
1527      * startTokenId - the first token id to be transferred
1528      * quantity - the amount to be transferred
1529      *
1530      * Calling conditions:
1531      *
1532      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1533      * transferred to `to`.
1534      * - When `from` is zero, `tokenId` will be minted for `to`.
1535      * - When `to` is zero, `tokenId` will be burned by `from`.
1536      * - `from` and `to` are never both zero.
1537      */
1538     function _beforeTokenTransfers(
1539         address from,
1540         address to,
1541         uint256 startTokenId,
1542         uint256 quantity
1543     ) internal virtual {}
1544 
1545     /**
1546      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1547      * minting.
1548      * And also called after one token has been burned.
1549      *
1550      * startTokenId - the first token id to be transferred
1551      * quantity - the amount to be transferred
1552      *
1553      * Calling conditions:
1554      *
1555      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1556      * transferred to `to`.
1557      * - When `from` is zero, `tokenId` has been minted for `to`.
1558      * - When `to` is zero, `tokenId` has been burned by `from`.
1559      * - `from` and `to` are never both zero.
1560      */
1561     function _afterTokenTransfers(
1562         address from,
1563         address to,
1564         uint256 startTokenId,
1565         uint256 quantity
1566     ) internal virtual {}
1567 }
1568 /**/
1569 pragma solidity ^0.8.0;
1570 
1571 contract Katanaz is ERC721A, Ownable {
1572     
1573     using Strings for uint;
1574     
1575 //Standard Variables
1576     
1577     uint256 MAX_MINTS = 1;
1578     uint256 MAX_SUPPLY = 888;
1579     uint256 public mintRate = 0.0 ether;
1580     bool public paused = true;
1581     bool public wlOnly = true;
1582 
1583     address[] private wl;
1584 
1585     constructor(
1586     ) ERC721A("Kozoku Katanaz", "KK")payable{
1587         _mint(msg.sender, 100,"",true);
1588     }
1589 
1590   
1591 //Public Functions
1592 
1593 
1594 
1595     function publicMint(uint qty) external payable
1596     
1597     {
1598         require(
1599             totalSupply() + qty <= MAX_SUPPLY,
1600             "Not enough tokens left"
1601         );
1602 
1603         if (msg.sender != owner()) {
1604             require(!paused);
1605             require(
1606                 qty + _numberMinted(msg.sender) <= MAX_MINTS,
1607                 "Exceeded the limit"
1608             );
1609             require(balanceOf(msg.sender) < 1, "Exceeded the limit");
1610             require(msg.value >= mintRate * qty);
1611 
1612             if (wlOnly) {
1613                 require(onWl(msg.sender), "Not On Whitelist");
1614             }
1615 
1616         }
1617 
1618         _safeMint(msg.sender, qty);       
1619     }
1620  
1621 //Metadata Functions
1622     string private _baseTokenURI;
1623 
1624     function _baseURI() internal view virtual override returns (string memory) 
1625     {
1626         return _baseTokenURI;
1627     }
1628 
1629     function exists(uint256 tokenId) public view returns (bool) 
1630     {
1631         return _exists(tokenId);
1632     }
1633 
1634     function tokenURI(uint tokenId) public view virtual override returns (string memory) 
1635     {
1636       
1637     string memory currentBaseURI = _baseURI();
1638     return bytes(currentBaseURI).length > 0
1639         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1640         : "";
1641     }
1642 
1643 //OnlyOwner Functions
1644     
1645     function setBaseURI(string memory baseURI) external onlyOwner 
1646     {
1647         _baseTokenURI = baseURI;
1648     }
1649 
1650     
1651     function giftMint(address recipient, uint qty) external onlyOwner 
1652     {
1653         require(_totalMinted() + qty < MAX_SUPPLY, "SOLD OUT!");
1654 
1655                 _mint(recipient, qty, '', true);
1656     }
1657 
1658     function airDrop(address[] memory users) external onlyOwner 
1659     {
1660         for (uint256 i; i < users.length; i++) 
1661         {
1662             _mint(users[i], 1, '', true);
1663         }
1664     }
1665 
1666     function pause(bool _state) public onlyOwner() 
1667     {
1668         paused = _state;
1669     }
1670 
1671     function setWL(address[] calldata _wallets) external onlyOwner {
1672         delete wl;
1673         wl = _wallets;
1674     }
1675 
1676     function wlGate(bool _wlOnly) public onlyOwner {
1677         wlOnly = _wlOnly;
1678     }
1679 
1680     function onWl(address _u) public view returns (bool) {
1681         uint i = 0;
1682         while(i < wl.length){
1683             if(wl[i] == _u){
1684                 return true;
1685             }
1686             i++;
1687         }
1688         return false;
1689     }
1690 
1691 
1692     function withdraw() public payable onlyOwner 
1693     {
1694         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1695         require(success);
1696     }
1697 
1698     
1699 }