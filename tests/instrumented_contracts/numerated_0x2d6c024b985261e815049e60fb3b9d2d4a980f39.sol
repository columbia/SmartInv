1 // File: contracts/BagheadBros.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private  _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 
105 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
106 
107 
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev Contract module that helps prevent reentrant calls to a function.
113  *
114  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
115  * available, which can be applied to functions to make sure there are no nested
116  * (reentrant) calls to them.
117  *
118  * Note that because there is a single `nonReentrant` guard, functions marked as
119  * `nonReentrant` may not call one another. This can be worked around by making
120  * those functions `private`, and then adding `external` `nonReentrant` entry
121  * points to them.
122  *
123  * TIP: If you would like to learn more about reentrancy and alternative ways
124  * to protect against it, check out our blog post
125  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
126  */
127 abstract contract ReentrancyGuard {
128     // Booleans are more expensive than uint256 or any type that takes up a full
129     // word because each write operation emits an extra SLOAD to first read the
130     // slot's contents, replace the bits taken up by the boolean, and then write
131     // back. This is the compiler's defense against contract upgrades and
132     // pointer aliasing, and it cannot be disabled.
133 
134     // The values being non-zero value makes deployment a bit more expensive,
135     // but in exchange the refund on every call to nonReentrant will be lower in
136     // amount. Since refunds are capped to a percentage of the total
137     // transaction's gas, it is best to keep them low in cases like this one, to
138     // increase the likelihood of the full refund coming into effect.
139     uint256 private constant _NOT_ENTERED = 1;
140     uint256 private constant _ENTERED = 2;
141 
142     uint256 private _status;
143 
144     constructor() {
145         _status = _NOT_ENTERED;
146     }
147 
148     /**
149      * @dev Prevents a contract from calling itself, directly or indirectly.
150      * Calling a `nonReentrant` function from another `nonReentrant`
151      * function is not supported. It is possible to prevent this from happening
152      * by making the `nonReentrant` function external, and making it call a
153      * `private` function that does the actual work.
154      */
155     modifier nonReentrant() {
156         // On the first call to nonReentrant, _notEntered will be true
157         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
158 
159         // Any calls to nonReentrant after this point will fail
160         _status = _ENTERED;
161 
162         _;
163 
164         // By storing the original value once again, a refund is triggered (see
165         // https://eips.ethereum.org/EIPS/eip-2200)
166         _status = _NOT_ENTERED;
167     }
168 }
169 
170 
171 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
172 
173 
174 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Interface of the ERC20 standard as defined in the EIP.
180  */
181 interface IERC20 {
182     /**
183      * @dev Returns the amount of tokens in existence.
184      */
185     function totalSupply() external view returns (uint256);
186 
187     /**
188      * @dev Returns the amount of tokens owned by `account`.
189      */
190     function balanceOf(address account) external view returns (uint256);
191 
192     /**
193      * @dev Moves `amount` tokens from the caller's account to `to`.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transfer(address to, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Returns the remaining number of tokens that `spender` will be
203      * allowed to spend on behalf of `owner` through {transferFrom}. This is
204      * zero by default.
205      *
206      * This value changes when {approve} or {transferFrom} are called.
207      */
208     function allowance(address owner, address spender) external view returns (uint256);
209 
210     /**
211      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * IMPORTANT: Beware that changing an allowance with this method brings the risk
216      * that someone may use both the old and the new allowance by unfortunate
217      * transaction ordering. One possible solution to mitigate this race
218      * condition is to first reduce the spender's allowance to 0 and set the
219      * desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address spender, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Moves `amount` tokens from `from` to `to` using the
228      * allowance mechanism. `amount` is then deducted from the caller's
229      * allowance.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * Emits a {Transfer} event.
234      */
235     function transferFrom(
236         address from,
237         address to,
238         uint256 amount
239     ) external returns (bool);
240 
241     /**
242      * @dev Emitted when `value` tokens are moved from one account (`from`) to
243      * another (`to`).
244      *
245      * Note that `value` may be zero.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 value);
248 
249     /**
250      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
251      * a call to {approve}. `value` is the new allowance.
252      */
253     event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 
257 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
258 
259 
260 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
261 
262 pragma solidity ^0.8.1;
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      *
285      * [IMPORTANT]
286      * ====
287      * You shouldn't rely on `isContract` to protect against flash loan attacks!
288      *
289      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
290      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
291      * constructor.
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies on extcodesize/address.code.length, which returns 0
296         // for contracts in construction, since the code is only stored at the end
297         // of the constructor execution.
298 
299         return account.code.length > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         (bool success, ) = recipient.call{value: amount}("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain `call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value
376     ) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(
387         address target,
388         bytes memory data,
389         uint256 value,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         require(isContract(target), "Address: call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.call{value: value}(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
406         return functionStaticCall(target, data, "Address: low-level static call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal view returns (bytes memory) {
420         require(isContract(target), "Address: static call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.staticcall(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a delegate call.
429      *
430      * _Available since v3.4._
431      */
432     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
433         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal returns (bytes memory) {
447         require(isContract(target), "Address: delegate call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.delegatecall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
455      * revert reason using the provided one.
456      *
457      * _Available since v4.3._
458      */
459     function verifyCallResult(
460         bool success,
461         bytes memory returndata,
462         string memory errorMessage
463     ) internal pure returns (bytes memory) {
464         if (success) {
465             return returndata;
466         } else {
467             // Look for revert reason and bubble it up if present
468             if (returndata.length > 0) {
469                 // The easiest way to bubble the revert reason is using memory via assembly
470 
471                 assembly {
472                     let returndata_size := mload(returndata)
473                     revert(add(32, returndata), returndata_size)
474                 }
475             } else {
476                 revert(errorMessage);
477             }
478         }
479     }
480 }
481 
482 
483 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 
491 /**
492  * @title SafeERC20
493  * @dev Wrappers around ERC20 operations that throw on failure (when the token
494  * contract returns false). Tokens that return no value (and instead revert or
495  * throw on failure) are also supported, non-reverting calls are assumed to be
496  * successful.
497  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
498  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
499  */
500 library SafeERC20 {
501     using Address for address;
502 
503     function safeTransfer(
504         IERC20 token,
505         address to,
506         uint256 value
507     ) internal {
508         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
509     }
510 
511     function safeTransferFrom(
512         IERC20 token,
513         address from,
514         address to,
515         uint256 value
516     ) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
518     }
519 
520     /**
521      * @dev Deprecated. This function has issues similar to the ones found in
522      * {IERC20-approve}, and its usage is discouraged.
523      *
524      * Whenever possible, use {safeIncreaseAllowance} and
525      * {safeDecreaseAllowance} instead.
526      */
527     function safeApprove(
528         IERC20 token,
529         address spender,
530         uint256 value
531     ) internal {
532         // safeApprove should only be called when setting an initial allowance,
533         // or when resetting it to zero. To increase and decrease it, use
534         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
535         require(
536             (value == 0) || (token.allowance(address(this), spender) == 0),
537             "SafeERC20: approve from non-zero to non-zero allowance"
538         );
539         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
540     }
541 
542     function safeIncreaseAllowance(
543         IERC20 token,
544         address spender,
545         uint256 value
546     ) internal {
547         uint256 newAllowance = token.allowance(address(this), spender) + value;
548         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
549     }
550 
551     function safeDecreaseAllowance(
552         IERC20 token,
553         address spender,
554         uint256 value
555     ) internal {
556         unchecked {
557             uint256 oldAllowance = token.allowance(address(this), spender);
558             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
559             uint256 newAllowance = oldAllowance - value;
560             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
561         }
562     }
563 
564     /**
565      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
566      * on the return value: the return value is optional (but if data is returned, it must not be false).
567      * @param token The token targeted by the call.
568      * @param data The call data (encoded using abi.encode or one of its variants).
569      */
570     function _callOptionalReturn(IERC20 token, bytes memory data) private {
571         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
572         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
573         // the target address contains contract code and also asserts for success in the low-level call.
574 
575         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
576         if (returndata.length > 0) {
577             // Return data is optional
578             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
579         }
580     }
581 }
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Interface of the ERC165 standard, as defined in the
587  * https://eips.ethereum.org/EIPS/eip-165[EIP].
588  *
589  * Implementers can declare support of contract interfaces, which can then be
590  * queried by others ({ERC165Checker}).
591  *
592  * For an implementation, see {ERC165}.
593  */
594 interface IERC165 {
595     /**
596      * @dev Returns true if this contract implements the interface defined by
597      * `interfaceId`. See the corresponding
598      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
599      * to learn more about how these ids are created.
600      *
601      * This function call must use less than 30 000 gas.
602      */
603     function supportsInterface(bytes4 interfaceId) external view returns (bool);
604 }
605 
606 
607 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Required interface of an ERC721 compliant contract.
616  */
617 interface IERC721 is IERC165 {
618     /**
619      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
620      */
621     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
622 
623     /**
624      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
625      */
626     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
630      */
631     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
632 
633     /**
634      * @dev Returns the number of tokens in ``owner``'s account.
635      */
636     function balanceOf(address owner) external view returns (uint256 balance);
637 
638     /**
639      * @dev Returns the owner of the `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function ownerOf(uint256 tokenId) external view returns (address owner);
646 
647     /**
648      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
649      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
650      *
651      * Requirements:
652      *
653      * - `from` cannot be the zero address.
654      * - `to` cannot be the zero address.
655      * - `tokenId` token must exist and be owned by `from`.
656      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
657      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
658      *
659      * Emits a {Transfer} event.
660      */
661     function safeTransferFrom(
662         address from,
663         address to,
664         uint256 tokenId
665     ) external;
666 
667     /**
668      * @dev Transfers `tokenId` token from `from` to `to`.
669      *
670      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must be owned by `from`.
677      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
678      *
679      * Emits a {Transfer} event.
680      */
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) external;
686 
687     /**
688      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
689      * The approval is cleared when the token is transferred.
690      *
691      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
692      *
693      * Requirements:
694      *
695      * - The caller must own the token or be an approved operator.
696      * - `tokenId` must exist.
697      *
698      * Emits an {Approval} event.
699      */
700     function approve(address to, uint256 tokenId) external;
701 
702     /**
703      * @dev Returns the account approved for `tokenId` token.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function getApproved(uint256 tokenId) external view returns (address operator);
710 
711     /**
712      * @dev Approve or remove `operator` as an operator for the caller.
713      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
714      *
715      * Requirements:
716      *
717      * - The `operator` cannot be the caller.
718      *
719      * Emits an {ApprovalForAll} event.
720      */
721     function setApprovalForAll(address operator, bool _approved) external;
722 
723     /**
724      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
725      *
726      * See {setApprovalForAll}
727      */
728     function isApprovedForAll(address owner, address operator) external view returns (bool);
729 
730     /**
731      * @dev Safely transfers `tokenId` token from `from` to `to`.
732      *
733      * Requirements:
734      *
735      * - `from` cannot be the zero address.
736      * - `to` cannot be the zero address.
737      * - `tokenId` token must exist and be owned by `from`.
738      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
739      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
740      *
741      * Emits a {Transfer} event.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes calldata data
748     ) external;
749 }
750 
751 
752 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 /**
760  * @title ERC721 token receiver interface
761  * @dev Interface for any contract that wants to support safeTransfers
762  * from ERC721 asset contracts.
763  */
764 interface IERC721Receiver {
765     /**
766      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
767      * by `operator` from `from`, this function is called.
768      *
769      * It must return its Solidity selector to confirm the token transfer.
770      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
771      *
772      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
773      */
774     function onERC721Received(
775         address operator,
776         address from,
777         uint256 tokenId,
778         bytes calldata data
779     ) external returns (bytes4);
780 }
781 
782 
783 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
784 
785 
786 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 /**
791  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
792  * @dev See https://eips.ethereum.org/EIPS/eip-721
793  */
794 interface IERC721Metadata is IERC721 {
795     /**
796      * @dev Returns the token collection name.
797      */
798     function name() external view returns (string memory);
799 
800     /**
801      * @dev Returns the token collection symbol.
802      */
803     function symbol() external view returns (string memory);
804 
805     /**
806      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
807      */
808     function tokenURI(uint256 tokenId) external view returns (string memory);
809 }
810 
811 
812 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
813 
814 
815 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 /**
820  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
821  * @dev See https://eips.ethereum.org/EIPS/eip-721
822  */
823 interface IERC721Enumerable is IERC721 {
824     /**
825      * @dev Returns the total amount of tokens stored by the contract.
826      */
827     function totalSupply() external view returns (uint256);
828 
829     /**
830      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
831      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
832      */
833     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
834 
835     /**
836      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
837      * Use along with {totalSupply} to enumerate all tokens.
838      */
839     function tokenByIndex(uint256 index) external view returns (uint256);
840 }
841 
842 
843 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
844 
845 
846 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
847 
848 pragma solidity ^0.8.0;
849 
850 /**
851  * @dev String operations.
852  */
853 library Strings {
854     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
855 
856     /**
857      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
858      */
859     function toString(uint256 value) internal pure returns (string memory) {
860         // Inspired by OraclizeAPI's implementation - MIT licence
861         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
862 
863         if (value == 0) {
864             return "0";
865         }
866         uint256 temp = value;
867         uint256 digits;
868         while (temp != 0) {
869             digits++;
870             temp /= 10;
871         }
872         bytes memory buffer = new bytes(digits);
873         while (value != 0) {
874             digits -= 1;
875             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
876             value /= 10;
877         }
878         return string(buffer);
879     }
880 
881     /**
882      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
883      */
884     function toHexString(uint256 value) internal pure returns (string memory) {
885         if (value == 0) {
886             return "0x00";
887         }
888         uint256 temp = value;
889         uint256 length = 0;
890         while (temp != 0) {
891             length++;
892             temp >>= 8;
893         }
894         return toHexString(value, length);
895     }
896 
897     /**
898      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
899      */
900     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
901         bytes memory buffer = new bytes(2 * length + 2);
902         buffer[0] = "0";
903         buffer[1] = "x";
904         for (uint256 i = 2 * length + 1; i > 1; --i) {
905             buffer[i] = _HEX_SYMBOLS[value & 0xf];
906             value >>= 4;
907         }
908         require(value == 0, "Strings: hex length insufficient");
909         return string(buffer);
910     }
911 }
912 
913 
914 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
915 
916 
917 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
918 
919 pragma solidity ^0.8.0;
920 
921 /**
922  * @dev Implementation of the {IERC165} interface.
923  *
924  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
925  * for the additional interface id that will be supported. For example:
926  *
927  * ```solidity
928  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
929  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
930  * }
931  * ```
932  *
933  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
934  */
935 abstract contract ERC165 is IERC165 {
936     /**
937      * @dev See {IERC165-supportsInterface}.
938      */
939     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
940         return interfaceId == type(IERC165).interfaceId;
941     }
942 }
943 
944 
945 
946 // props to chiru for 721A
947 pragma solidity ^0.8.4;
948 
949 
950 
951 error ApprovalCallerNotOwnerNorApproved();
952 error ApprovalQueryForNonexistentToken();
953 error ApproveToCaller();
954 error ApprovalToCurrentOwner();
955 error BalanceQueryForZeroAddress();
956 error MintToZeroAddress();
957 error MintZeroQuantity();
958 error OwnerQueryForNonexistentToken();
959 error TransferCallerNotOwnerNorApproved();
960 error TransferFromIncorrectOwner();
961 error TransferToNonERC721ReceiverImplementer();
962 error TransferToZeroAddress();
963 error URIQueryForNonexistentToken();
964 
965 /**
966  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
967  * the Metadata extension. Built to optimize for lower gas during batch mints.
968  *
969  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
970  *
971  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
972  *
973  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
974  */
975 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
976     using Address for address;
977     using Strings for uint256;
978 
979     // Compiler will pack this into a single 256bit word.
980     struct TokenOwnership {
981         // The address of the owner.
982         address addr;
983         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
984         uint64 startTimestamp;
985         // Whether the token has been burned.
986         bool burned;
987     }
988 
989     // Compiler will pack this into a single 256bit word.
990     struct AddressData {
991         
992         // Realistically, 2**64-1 is more than enough.
993         uint64 balance;
994         // Keeps track of mint count with minimal overhead for tokenomics.
995         uint64 numberMinted;
996         // Keeps track of burn count with minimal overhead for tokenomics.
997         uint64 numberBurned;
998         // For miscellaneous variable(s) pertaining to the address
999         // (e.g. number of whitelist mint slots used).
1000         // If there are multiple variables, please pack them into a uint64.
1001         uint64 aux;
1002     }
1003 
1004     
1005 
1006     // The tokenId of the next token to be minted.
1007     uint256 internal _currentIndex;
1008 
1009     // The number of tokens burned.
1010     uint256 internal _burnCounter;
1011 
1012     // Token name
1013     string private _name;
1014 
1015     // Token symbol
1016     string private _symbol;
1017 
1018     // Mapping from token ID to ownership details
1019     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1020     mapping(uint256 => TokenOwnership) internal _ownerships;
1021 
1022     // Mapping owner address to address data
1023     mapping(address => AddressData) private _addressData;
1024 
1025     // Mapping from token ID to approved address
1026     mapping(uint256 => address) private _tokenApprovals;
1027 
1028     // Mapping from owner to operator approvals
1029     mapping(address => mapping(address => bool)) private _operatorApprovals;
1030 
1031   
1032  
1033     constructor(string memory name_, string memory symbol_) {
1034         _name = name_;
1035         _symbol = symbol_;
1036         _currentIndex = _startTokenId();
1037         
1038     }
1039     
1040     /**
1041      * To change the starting tokenId, please override this function.
1042      */
1043     function _startTokenId() internal view virtual returns (uint256) {
1044         return 1;
1045     }
1046 
1047     /**
1048      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1049      */
1050     function totalSupply() public view returns (uint256) {
1051         // Counter underflow is impossible as _burnCounter cannot be incremented
1052         // more than _currentIndex - _startTokenId() times
1053         unchecked {
1054             return _currentIndex - _burnCounter - _startTokenId();
1055         }
1056     }
1057 
1058     /**
1059      * Returns the total amount of tokens minted in the contract.
1060      */
1061     function _totalMinted() internal view returns (uint256) {
1062         // Counter underflow is impossible as _currentIndex does not decrement,
1063         // and it is initialized to _startTokenId()
1064         unchecked {
1065             return _currentIndex - _startTokenId();
1066         }
1067     }
1068 
1069     /**
1070      * @dev See {IERC165-supportsInterface}.
1071      */
1072     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1073         return
1074             interfaceId == type(IERC721).interfaceId ||
1075             interfaceId == type(IERC721Metadata).interfaceId ||
1076             super.supportsInterface(interfaceId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-balanceOf}.
1081      */
1082     function balanceOf(address owner) public view override returns (uint256) {
1083         
1084         return uint256(_addressData[owner].balance);
1085     }
1086 
1087     /**
1088      * Returns the number of tokens minted by `owner`.
1089      */
1090     function _numberMinted(address owner) internal view returns (uint256) {
1091         return uint256(_addressData[owner].numberMinted);
1092     }
1093 
1094     /**
1095      * Returns the number of tokens burned by or on behalf of `owner`.
1096      */
1097     function _numberBurned(address owner) internal view returns (uint256) {
1098         return uint256(_addressData[owner].numberBurned);
1099     }
1100 
1101     /**
1102      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1103      */
1104     function _getAux(address owner) internal view returns (uint64) {
1105         return _addressData[owner].aux;
1106     }
1107 
1108     /**
1109      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1110      * If there are multiple variables, please pack them into a uint64.
1111      */
1112     function _setAux(address owner, uint64 aux) internal {
1113         _addressData[owner].aux = aux;
1114     }
1115 
1116     /**
1117      * Gas spent here starts off proportional to the maximum mint batch size.
1118      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1119      */
1120     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1121         uint256 curr = tokenId;
1122 
1123         unchecked {
1124             if (_startTokenId() <= curr && curr < _currentIndex) {
1125                 TokenOwnership memory ownership = _ownerships[curr];
1126                 if (!ownership.burned) {
1127                     if (ownership.addr != address(0)) {
1128                         return ownership;
1129                     }
1130                     // Invariant:
1131                     // There will always be an ownership that has an address and is not burned
1132                     // before an ownership that does not have an address and is not burned.
1133                     // Hence, curr will not underflow.
1134                     while (true) {
1135                         curr--;
1136                         ownership = _ownerships[curr];
1137                         if (ownership.addr != address(0)) {
1138                             return ownership;
1139                         }
1140                     }
1141                 }
1142             }
1143         }
1144         revert OwnerQueryForNonexistentToken();
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-ownerOf}.
1149      */
1150     function ownerOf(uint256 tokenId) public view override returns (address) {
1151         return _ownershipOf(tokenId).addr;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Metadata-name}.
1156      */
1157     function name() public view virtual override returns (string memory) {
1158         return _name;
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Metadata-symbol}.
1163      */
1164     function symbol() public view virtual override returns (string memory) {
1165         return _symbol;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Metadata-tokenURI}.
1170      */
1171     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1172         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1173 
1174         string memory baseURI = _baseURI();
1175         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1176     }
1177 
1178     /**
1179      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1180      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1181      * by default, can be overriden in child contracts.
1182      */
1183     function _baseURI() internal view virtual returns (string memory) {
1184         return '';
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-approve}.
1189      */
1190     function approve(address to, uint256 tokenId) public override {
1191         address owner = ERC721A.ownerOf(tokenId);
1192         if (to == owner) revert ApprovalToCurrentOwner();
1193 
1194         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1195             revert ApprovalCallerNotOwnerNorApproved();
1196         }
1197 
1198         _approve(to, tokenId, owner);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-getApproved}.
1203      */
1204     function getApproved(uint256 tokenId) public view override returns (address) {
1205         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1206 
1207         return _tokenApprovals[tokenId];
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-setApprovalForAll}.
1212      */
1213     function setApprovalForAll(address operator, bool approved) public virtual override {
1214         if (operator == _msgSender()) revert ApproveToCaller();
1215 
1216         _operatorApprovals[_msgSender()][operator] = approved;
1217         emit ApprovalForAll(_msgSender(), operator, approved);
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-isApprovedForAll}.
1222      */
1223     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1224         return _operatorApprovals[owner][operator];
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-transferFrom}.
1229      */
1230     function transferFrom(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) public virtual override {
1235         _transfer(from, to, tokenId);
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-safeTransferFrom}.
1240      */
1241     function safeTransferFrom(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) public virtual override {
1246         safeTransferFrom(from, to, tokenId, '');
1247     }
1248 
1249     /**
1250      * @dev See {IERC721-safeTransferFrom}.
1251      */
1252     function safeTransferFrom(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) public virtual override {
1258         _transfer(from, to, tokenId);
1259         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1260             revert TransferToNonERC721ReceiverImplementer();
1261         }
1262     }
1263 
1264     /**
1265      * @dev Returns whether `tokenId` exists.
1266      *
1267      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1268      *
1269      * Tokens start existing when they are minted (`_mint`),
1270      */
1271     function _exists(uint256 tokenId) internal view returns (bool) {
1272         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1273     }
1274 
1275     function _safeMint(address to, uint256 quantity) internal {
1276         _safeMint(to, quantity, '');
1277     }
1278 
1279     /**
1280      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1285      * - `quantity` must be greater than 0.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _safeMint(
1290         address to,
1291         uint256 quantity,
1292         bytes memory _data
1293     ) internal {
1294         _mint(to, quantity, _data, true);
1295     }
1296 
1297     /**
1298      * @dev Mints `quantity` tokens and transfers them to `to`.
1299      *
1300      * Requirements:
1301      *
1302      * - `to` cannot be the zero address.
1303      * - `quantity` must be greater than 0.
1304      *
1305      * Emits a {Transfer} event.
1306      */
1307     function _mint(
1308         address to,
1309         uint256 quantity,
1310         bytes memory _data,
1311         bool safe
1312     ) internal {
1313         
1314         uint256 startTokenId = _currentIndex;
1315         
1316         if (quantity == 0) revert MintZeroQuantity();
1317           
1318         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1319        
1320         
1321         // Overflows are incredibly unrealistic.
1322         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1323         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1324         unchecked {
1325             _addressData[to].balance += uint64(quantity);
1326             _addressData[to].numberMinted += uint64(quantity);
1327 
1328             _ownerships[startTokenId].addr = to;
1329             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1330 
1331             uint256 updatedIndex = startTokenId;
1332             uint256 end = updatedIndex + quantity;
1333 
1334             if (safe && to.isContract()) {
1335                 do {
1336                     emit Transfer(address(0), to, updatedIndex);
1337                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1338                         revert TransferToNonERC721ReceiverImplementer();
1339                     }
1340                 } while (updatedIndex != end);
1341                 // Reentrancy protection
1342                 if (_currentIndex != startTokenId) revert();
1343             } else {
1344                 do {
1345                     emit Transfer(address(0), to, updatedIndex++);
1346                 } while (updatedIndex != end);
1347             }
1348             _currentIndex = updatedIndex;
1349         }
1350         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1351     }
1352 
1353     /**
1354      * @dev Transfers `tokenId` from `from` to `to`.
1355      *
1356      * Requirements:
1357      *
1358      * - `to` cannot be the zero address.
1359      * - `tokenId` token must be owned by `from`.
1360      *
1361      * Emits a {Transfer} event.
1362      */
1363     function _transfer(
1364         address from,
1365         address to,
1366         uint256 tokenId
1367     ) private {
1368         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1369 
1370         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1371 
1372         bool isApprovedOrOwner = (_msgSender() == from ||
1373             isApprovedForAll(from, _msgSender()) ||
1374             getApproved(tokenId) == _msgSender());
1375 
1376         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1377         if (to == address(0)) revert TransferToZeroAddress();
1378 
1379         _beforeTokenTransfers(from, to, tokenId, 1);
1380 
1381         // Clear approvals from the previous owner
1382         _approve(address(0), tokenId, from);
1383 
1384         // Underflow of the sender's balance is impossible because we check for
1385         // ownership above and the recipient's balance can't realistically overflow.
1386         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1387         unchecked {
1388             _addressData[from].balance -= 1;
1389             _addressData[to].balance += 1;
1390 
1391             TokenOwnership storage currSlot = _ownerships[tokenId];
1392             currSlot.addr = to;
1393             currSlot.startTimestamp = uint64(block.timestamp);
1394 
1395             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1396             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1397             uint256 nextTokenId = tokenId + 1;
1398             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1399             if (nextSlot.addr == address(0)) {
1400                 // This will suffice for checking _exists(nextTokenId),
1401                 // as a burned slot cannot contain the zero address.
1402                 if (nextTokenId != _currentIndex) {
1403                     nextSlot.addr = from;
1404                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1405                 }
1406             }
1407         }
1408  
1409         _afterTokenTransfers(from, to, tokenId, 1);
1410     }
1411 
1412     /**
1413      * @dev This is equivalent to _burn(tokenId, false)
1414      */
1415     function _burn(uint256 tokenId) internal virtual {
1416         _burn(tokenId, false);
1417     }
1418 
1419     /**
1420      * @dev Destroys `tokenId`.
1421      * The approval is cleared when the token is burned.
1422      *
1423      * Requirements:
1424      *
1425      * - `tokenId` must exist.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1430         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1431 
1432         address from = prevOwnership.addr;
1433 
1434         if (approvalCheck) {
1435             bool isApprovedOrOwner = (_msgSender() == from ||
1436                 isApprovedForAll(from, _msgSender()) ||
1437                 getApproved(tokenId) == _msgSender());
1438 
1439             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1440         }
1441 
1442         _beforeTokenTransfers(from, address(0), tokenId, 1);
1443 
1444         // Clear approvals from the previous owner
1445         _approve(address(0), tokenId, from);
1446 
1447         // Underflow of the sender's balance is impossible because we check for
1448         // ownership above and the recipient's balance can't realistically overflow.
1449         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1450         unchecked {
1451             AddressData storage addressData = _addressData[from];
1452             addressData.balance -= 1;
1453             addressData.numberBurned += 1;
1454 
1455             // Keep track of who burned the token, and the timestamp of burning.
1456             TokenOwnership storage currSlot = _ownerships[tokenId];
1457             currSlot.addr = from;
1458             currSlot.startTimestamp = uint64(block.timestamp);
1459             currSlot.burned = true;
1460 
1461             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1462             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1463             uint256 nextTokenId = tokenId + 1;
1464             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1465             if (nextSlot.addr == address(0)) {
1466                 // This will suffice for checking _exists(nextTokenId),
1467                 // as a burned slot cannot contain the zero address.
1468                 if (nextTokenId != _currentIndex) {
1469                     nextSlot.addr = from;
1470                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1471                 }
1472             }
1473         }
1474 
1475         emit Transfer(from, address(0), tokenId);
1476         _afterTokenTransfers(from, address(0), tokenId, 1);
1477 
1478         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1479         unchecked {
1480             _burnCounter++;
1481         }
1482     }
1483 
1484     /**
1485      * @dev Approve `to` to operate on `tokenId`
1486      *
1487      * Emits a {Approval} event.
1488      */
1489     function _approve(
1490         address to,
1491         uint256 tokenId,
1492         address owner
1493     ) private {
1494         _tokenApprovals[tokenId] = to;
1495         emit Approval(owner, to, tokenId);
1496     }
1497 
1498     /**
1499      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1500      *
1501      * @param from address representing the previous owner of the given token ID
1502      * @param to target address that will receive the tokens
1503      * @param tokenId uint256 ID of the token to be transferred
1504      * @param _data bytes optional data to send along with the call
1505      * @return bool whether the call correctly returned the expected magic value
1506      */
1507     function _checkContractOnERC721Received(
1508         address from,
1509         address to,
1510         uint256 tokenId,
1511         bytes memory _data
1512     ) private returns (bool) {
1513         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1514             return retval == IERC721Receiver(to).onERC721Received.selector;
1515         } catch (bytes memory reason) {
1516             if (reason.length == 0) {
1517                 revert TransferToNonERC721ReceiverImplementer();
1518             } else {
1519                 assembly {
1520                     revert(add(32, reason), mload(reason))
1521                 }
1522             }
1523         }
1524     }
1525 
1526     /**
1527      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1528      * And also called before burning one token.
1529      *
1530      * startTokenId - the first token id to be transferred
1531      * quantity - the amount to be transferred
1532      *
1533      * Calling conditions:
1534      *
1535      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1536      * transferred to `to`.
1537      * - When `from` is zero, `tokenId` will be minted for `to`.
1538      * - When `to` is zero, `tokenId` will be burned by `from`.
1539      * - `from` and `to` are never both zero.
1540      */
1541     function _beforeTokenTransfers(
1542         address from,
1543         address to,
1544         uint256 startTokenId,
1545         uint256 quantity
1546     ) internal virtual {}
1547 
1548     /**
1549      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1550      * minting.
1551      * And also called after one token has been burned.
1552      *
1553      * startTokenId - the first token id to be transferred
1554      * quantity - the amount to be transferred
1555      *
1556      * Calling conditions:
1557      *
1558      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1559      * transferred to `to`.
1560      * - When `from` is zero, `tokenId` has been minted for `to`.
1561      * - When `to` is zero, `tokenId` has been burned by `from`.
1562      * - `from` and `to` are never both zero.
1563      */
1564     function _afterTokenTransfers(
1565         address from,
1566         address to,
1567         uint256 startTokenId,
1568         uint256 quantity
1569     ) internal virtual {}
1570 }
1571 /**/
1572 pragma solidity ^0.8.0;
1573 
1574 contract BagheadBros is ERC721A, Ownable {
1575     
1576     using Strings for uint;
1577     
1578 //Standard Variables
1579     
1580     uint public cost = 0;
1581     uint private constant totalBagheads = 1987;
1582     uint private constant maxPerMint = 5;
1583     bool paused = true;
1584 
1585     
1586 
1587     constructor(
1588     ) ERC721A("BagHeadBros", "BHB")payable{
1589         _mint(msg.sender, 1,"",true);
1590     }
1591 
1592   
1593 //Public Functions
1594 
1595 
1596 
1597     function publicMint(uint qty) external payable
1598     
1599     {
1600         uint tm = _totalMinted();
1601         require(msg.sender == tx.origin, "no bots asshole");
1602         require(qty<6,"10 max bruh");
1603         require(tm + qty < 1988, "SOLD OUT!");
1604         
1605                                   
1606                 _mint(msg.sender, qty,"",true);       
1607     }
1608  
1609 //Metadata Functions
1610     string private _baseTokenURI;
1611 
1612     function _baseURI() internal view virtual override returns (string memory) 
1613     {
1614         return _baseTokenURI;
1615     }
1616 
1617     function exists(uint256 tokenId) public view returns (bool) 
1618     {
1619         return _exists(tokenId);
1620     }
1621 
1622     function tokenURI(uint tokenId) public view virtual override returns (string memory) 
1623     {
1624       
1625     string memory currentBaseURI = _baseURI();
1626     return bytes(currentBaseURI).length > 0
1627         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1628         : "";
1629     }
1630 
1631 //OnlyOwner Functions
1632     
1633     function setBaseURI(string memory baseURI) external onlyOwner 
1634     {
1635         _baseTokenURI = baseURI;
1636     }
1637 
1638     
1639     function giftMint(address recipient, uint qty) external onlyOwner 
1640     {
1641         require(_totalMinted() + qty <10001, "SOLD OUT!");
1642 
1643                 _mint(recipient, qty, '', true);
1644     }
1645 
1646     function airDrop(address[] memory users) external onlyOwner 
1647     {
1648         for (uint256 i; i < users.length; i++) 
1649         {
1650             _mint(users[i], 1, '', true);
1651         }
1652     }
1653 
1654     function pause(bool _state) public onlyOwner() 
1655     {
1656         paused = _state;
1657     }
1658 
1659 
1660     function withdraw() public payable onlyOwner 
1661     {
1662         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1663         require(success);
1664     }
1665 
1666     
1667 }