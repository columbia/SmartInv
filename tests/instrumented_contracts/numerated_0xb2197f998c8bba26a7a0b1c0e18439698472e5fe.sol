1 // File: contracts/IERC721A.sol
2 
3 
4 // ERC721A Contracts v4.0.0
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Interface of an ERC721A compliant contract.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * The caller cannot approve to the current owner.
30      */
31     error ApprovalToCurrentOwner();
32 
33     /**
34      * Cannot query the balance for the zero address.
35      */
36     error BalanceQueryForZeroAddress();
37 
38     /**
39      * Cannot mint to the zero address.
40      */
41     error MintToZeroAddress();
42 
43     /**
44      * The quantity of tokens minted must be more than zero.
45      */
46     error MintZeroQuantity();
47 
48     /**
49      * The token does not exist.
50      */
51     error OwnerQueryForNonexistentToken();
52 
53     /**
54      * The caller must own the token or be an approved operator.
55      */
56     error TransferCallerNotOwnerNorApproved();
57 
58     /**
59      * The token must be owned by `from`.
60      */
61     error TransferFromIncorrectOwner();
62 
63     /**
64      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
65      */
66     error TransferToNonERC721ReceiverImplementer();
67 
68     /**
69      * Cannot transfer to the zero address.
70      */
71     error TransferToZeroAddress();
72 
73     /**
74      * The token does not exist.
75      */
76     error URIQueryForNonexistentToken();
77 
78     struct TokenOwnership {
79         // The address of the owner.
80         address addr;
81         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
82         uint64 startTimestamp;
83         // Whether the token has been burned.
84         bool burned;
85     }
86 
87     /**
88      * @dev Returns the total amount of tokens stored by the contract.
89      *
90      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     // ==============================
95     //            IERC165
96     // ==============================
97 
98     /**
99      * @dev Returns true if this contract implements the interface defined by
100      * `interfaceId`. See the corresponding
101      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
102      * to learn more about how these ids are created.
103      *
104      * This function call must use less than 30 000 gas.
105      */
106     function supportsInterface(bytes4 interfaceId) external view returns (bool);
107 
108     // ==============================
109     //            IERC721
110     // ==============================
111 
112     /**
113      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
119      */
120     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
126 
127     /**
128      * @dev Returns the number of tokens in ``owner``'s account.
129      */
130     function balanceOf(address owner) external view returns (uint256 balance);
131 
132     /**
133      * @dev Returns the owner of the `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function ownerOf(uint256 tokenId) external view returns (address owner);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Transfers `tokenId` token from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
203      * The approval is cleared when the token is transferred.
204      *
205      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
206      *
207      * Requirements:
208      *
209      * - The caller must own the token or be an approved operator.
210      * - `tokenId` must exist.
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns the account approved for `tokenId` token.
230      *
231      * Requirements:
232      *
233      * - `tokenId` must exist.
234      */
235     function getApproved(uint256 tokenId) external view returns (address operator);
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator) external view returns (bool);
243 
244     // ==============================
245     //        IERC721Metadata
246     // ==============================
247 
248     /**
249      * @dev Returns the token collection name.
250      */
251     function name() external view returns (string memory);
252 
253     /**
254      * @dev Returns the token collection symbol.
255      */
256     function symbol() external view returns (string memory);
257 
258     /**
259      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
260      */
261     function tokenURI(uint256 tokenId) external view returns (string memory);
262 }
263 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @dev Contract module that helps prevent reentrant calls to a function.
272  *
273  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
274  * available, which can be applied to functions to make sure there are no nested
275  * (reentrant) calls to them.
276  *
277  * Note that because there is a single `nonReentrant` guard, functions marked as
278  * `nonReentrant` may not call one another. This can be worked around by making
279  * those functions `private`, and then adding `external` `nonReentrant` entry
280  * points to them.
281  *
282  * TIP: If you would like to learn more about reentrancy and alternative ways
283  * to protect against it, check out our blog post
284  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
285  */
286 abstract contract ReentrancyGuard {
287     // Booleans are more expensive than uint256 or any type that takes up a full
288     // word because each write operation emits an extra SLOAD to first read the
289     // slot's contents, replace the bits taken up by the boolean, and then write
290     // back. This is the compiler's defense against contract upgrades and
291     // pointer aliasing, and it cannot be disabled.
292 
293     // The values being non-zero value makes deployment a bit more expensive,
294     // but in exchange the refund on every call to nonReentrant will be lower in
295     // amount. Since refunds are capped to a percentage of the total
296     // transaction's gas, it is best to keep them low in cases like this one, to
297     // increase the likelihood of the full refund coming into effect.
298     uint256 private constant _NOT_ENTERED = 1;
299     uint256 private constant _ENTERED = 2;
300 
301     uint256 private _status;
302 
303     constructor() {
304         _status = _NOT_ENTERED;
305     }
306 
307     /**
308      * @dev Prevents a contract from calling itself, directly or indirectly.
309      * Calling a `nonReentrant` function from another `nonReentrant`
310      * function is not supported. It is possible to prevent this from happening
311      * by making the `nonReentrant` function external, and making it call a
312      * `private` function that does the actual work.
313      */
314     modifier nonReentrant() {
315         // On the first call to nonReentrant, _notEntered will be true
316         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
317 
318         // Any calls to nonReentrant after this point will fail
319         _status = _ENTERED;
320 
321         _;
322 
323         // By storing the original value once again, a refund is triggered (see
324         // https://eips.ethereum.org/EIPS/eip-2200)
325         _status = _NOT_ENTERED;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/utils/Context.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Provides information about the current execution context, including the
338  * sender of the transaction and its data. While these are generally available
339  * via msg.sender and msg.data, they should not be accessed in such a direct
340  * manner, since when dealing with meta-transactions the account sending and
341  * paying for execution may not be the actual sender (as far as an application
342  * is concerned).
343  *
344  * This contract is only required for intermediate, library-like contracts.
345  */
346 abstract contract Context {
347     function _msgSender() internal view virtual returns (address) {
348         return msg.sender;
349     }
350 
351     function _msgData() internal view virtual returns (bytes calldata) {
352         return msg.data;
353     }
354 }
355 
356 // File: @openzeppelin/contracts/access/Ownable.sol
357 
358 
359 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Contract module which provides a basic access control mechanism, where
366  * there is an account (an owner) that can be granted exclusive access to
367  * specific functions.
368  *
369  * By default, the owner account will be the one that deploys the contract. This
370  * can later be changed with {transferOwnership}.
371  *
372  * This module is used through inheritance. It will make available the modifier
373  * `onlyOwner`, which can be applied to your functions to restrict their use to
374  * the owner.
375  */
376 abstract contract Ownable is Context {
377     address private _owner;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     /**
382      * @dev Initializes the contract setting the deployer as the initial owner.
383      */
384     constructor() {
385         _transferOwnership(_msgSender());
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         _checkOwner();
393         _;
394     }
395 
396     /**
397      * @dev Returns the address of the current owner.
398      */
399     function owner() public view virtual returns (address) {
400         return _owner;
401     }
402 
403     /**
404      * @dev Throws if the sender is not the owner.
405      */
406     function _checkOwner() internal view virtual {
407         require(owner() == _msgSender(), "Ownable: caller is not the owner");
408     }
409 
410     /**
411      * @dev Leaves the contract without owner. It will not be possible to call
412      * `onlyOwner` functions anymore. Can only be called by the current owner.
413      *
414      * NOTE: Renouncing ownership will leave the contract without an owner,
415      * thereby removing any functionality that is only available to the owner.
416      */
417     function renounceOwnership() public virtual onlyOwner {
418         _transferOwnership(address(0));
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Can only be called by the current owner.
424      */
425     function transferOwnership(address newOwner) public virtual onlyOwner {
426         require(newOwner != address(0), "Ownable: new owner is the zero address");
427         _transferOwnership(newOwner);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Internal function without access restriction.
433      */
434     function _transferOwnership(address newOwner) internal virtual {
435         address oldOwner = _owner;
436         _owner = newOwner;
437         emit OwnershipTransferred(oldOwner, newOwner);
438     }
439 }
440 
441 // File: @openzeppelin/contracts/utils/Address.sol
442 
443 
444 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
445 
446 pragma solidity ^0.8.1;
447 
448 /**
449  * @dev Collection of functions related to the address type
450  */
451 library Address {
452     /**
453      * @dev Returns true if `account` is a contract.
454      *
455      * [IMPORTANT]
456      * ====
457      * It is unsafe to assume that an address for which this function returns
458      * false is an externally-owned account (EOA) and not a contract.
459      *
460      * Among others, `isContract` will return false for the following
461      * types of addresses:
462      *
463      *  - an externally-owned account
464      *  - a contract in construction
465      *  - an address where a contract will be created
466      *  - an address where a contract lived, but was destroyed
467      * ====
468      *
469      * [IMPORTANT]
470      * ====
471      * You shouldn't rely on `isContract` to protect against flash loan attacks!
472      *
473      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
474      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
475      * constructor.
476      * ====
477      */
478     function isContract(address account) internal view returns (bool) {
479         // This method relies on extcodesize/address.code.length, which returns 0
480         // for contracts in construction, since the code is only stored at the end
481         // of the constructor execution.
482 
483         return account.code.length > 0;
484     }
485 
486     /**
487      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
488      * `recipient`, forwarding all available gas and reverting on errors.
489      *
490      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
491      * of certain opcodes, possibly making contracts go over the 2300 gas limit
492      * imposed by `transfer`, making them unable to receive funds via
493      * `transfer`. {sendValue} removes this limitation.
494      *
495      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
496      *
497      * IMPORTANT: because control is transferred to `recipient`, care must be
498      * taken to not create reentrancy vulnerabilities. Consider using
499      * {ReentrancyGuard} or the
500      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
501      */
502     function sendValue(address payable recipient, uint256 amount) internal {
503         require(address(this).balance >= amount, "Address: insufficient balance");
504 
505         (bool success, ) = recipient.call{value: amount}("");
506         require(success, "Address: unable to send value, recipient may have reverted");
507     }
508 
509     /**
510      * @dev Performs a Solidity function call using a low level `call`. A
511      * plain `call` is an unsafe replacement for a function call: use this
512      * function instead.
513      *
514      * If `target` reverts with a revert reason, it is bubbled up by this
515      * function (like regular Solidity function calls).
516      *
517      * Returns the raw returned data. To convert to the expected return value,
518      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
519      *
520      * Requirements:
521      *
522      * - `target` must be a contract.
523      * - calling `target` with `data` must not revert.
524      *
525      * _Available since v3.1._
526      */
527     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
528         return functionCall(target, data, "Address: low-level call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
533      * `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         return functionCallWithValue(target, data, 0, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but also transferring `value` wei to `target`.
548      *
549      * Requirements:
550      *
551      * - the calling contract must have an ETH balance of at least `value`.
552      * - the called Solidity function must be `payable`.
553      *
554      * _Available since v3.1._
555      */
556     function functionCallWithValue(
557         address target,
558         bytes memory data,
559         uint256 value
560     ) internal returns (bytes memory) {
561         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
566      * with `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(
571         address target,
572         bytes memory data,
573         uint256 value,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(address(this).balance >= value, "Address: insufficient balance for call");
577         require(isContract(target), "Address: call to non-contract");
578 
579         (bool success, bytes memory returndata) = target.call{value: value}(data);
580         return verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but performing a static call.
586      *
587      * _Available since v3.3._
588      */
589     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
590         return functionStaticCall(target, data, "Address: low-level static call failed");
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(
600         address target,
601         bytes memory data,
602         string memory errorMessage
603     ) internal view returns (bytes memory) {
604         require(isContract(target), "Address: static call to non-contract");
605 
606         (bool success, bytes memory returndata) = target.staticcall(data);
607         return verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but performing a delegate call.
613      *
614      * _Available since v3.4._
615      */
616     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
617         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(
627         address target,
628         bytes memory data,
629         string memory errorMessage
630     ) internal returns (bytes memory) {
631         require(isContract(target), "Address: delegate call to non-contract");
632 
633         (bool success, bytes memory returndata) = target.delegatecall(data);
634         return verifyCallResult(success, returndata, errorMessage);
635     }
636 
637     /**
638      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
639      * revert reason using the provided one.
640      *
641      * _Available since v4.3._
642      */
643     function verifyCallResult(
644         bool success,
645         bytes memory returndata,
646         string memory errorMessage
647     ) internal pure returns (bytes memory) {
648         if (success) {
649             return returndata;
650         } else {
651             // Look for revert reason and bubble it up if present
652             if (returndata.length > 0) {
653                 // The easiest way to bubble the revert reason is using memory via assembly
654                 /// @solidity memory-safe-assembly
655                 assembly {
656                     let returndata_size := mload(returndata)
657                     revert(add(32, returndata), returndata_size)
658                 }
659             } else {
660                 revert(errorMessage);
661             }
662         }
663     }
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
675  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
676  *
677  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
678  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
679  * need to send a transaction, and thus is not required to hold Ether at all.
680  */
681 interface IERC20Permit {
682     /**
683      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
684      * given ``owner``'s signed approval.
685      *
686      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
687      * ordering also apply here.
688      *
689      * Emits an {Approval} event.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      * - `deadline` must be a timestamp in the future.
695      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
696      * over the EIP712-formatted function arguments.
697      * - the signature must use ``owner``'s current nonce (see {nonces}).
698      *
699      * For more information on the signature format, see the
700      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
701      * section].
702      */
703     function permit(
704         address owner,
705         address spender,
706         uint256 value,
707         uint256 deadline,
708         uint8 v,
709         bytes32 r,
710         bytes32 s
711     ) external;
712 
713     /**
714      * @dev Returns the current nonce for `owner`. This value must be
715      * included whenever a signature is generated for {permit}.
716      *
717      * Every successful call to {permit} increases ``owner``'s nonce by one. This
718      * prevents a signature from being used multiple times.
719      */
720     function nonces(address owner) external view returns (uint256);
721 
722     /**
723      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
724      */
725     // solhint-disable-next-line func-name-mixedcase
726     function DOMAIN_SEPARATOR() external view returns (bytes32);
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
730 
731 
732 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 /**
737  * @dev Interface of the ERC20 standard as defined in the EIP.
738  */
739 interface IERC20 {
740     /**
741      * @dev Emitted when `value` tokens are moved from one account (`from`) to
742      * another (`to`).
743      *
744      * Note that `value` may be zero.
745      */
746     event Transfer(address indexed from, address indexed to, uint256 value);
747 
748     /**
749      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
750      * a call to {approve}. `value` is the new allowance.
751      */
752     event Approval(address indexed owner, address indexed spender, uint256 value);
753 
754     /**
755      * @dev Returns the amount of tokens in existence.
756      */
757     function totalSupply() external view returns (uint256);
758 
759     /**
760      * @dev Returns the amount of tokens owned by `account`.
761      */
762     function balanceOf(address account) external view returns (uint256);
763 
764     /**
765      * @dev Moves `amount` tokens from the caller's account to `to`.
766      *
767      * Returns a boolean value indicating whether the operation succeeded.
768      *
769      * Emits a {Transfer} event.
770      */
771     function transfer(address to, uint256 amount) external returns (bool);
772 
773     /**
774      * @dev Returns the remaining number of tokens that `spender` will be
775      * allowed to spend on behalf of `owner` through {transferFrom}. This is
776      * zero by default.
777      *
778      * This value changes when {approve} or {transferFrom} are called.
779      */
780     function allowance(address owner, address spender) external view returns (uint256);
781 
782     /**
783      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
784      *
785      * Returns a boolean value indicating whether the operation succeeded.
786      *
787      * IMPORTANT: Beware that changing an allowance with this method brings the risk
788      * that someone may use both the old and the new allowance by unfortunate
789      * transaction ordering. One possible solution to mitigate this race
790      * condition is to first reduce the spender's allowance to 0 and set the
791      * desired value afterwards:
792      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
793      *
794      * Emits an {Approval} event.
795      */
796     function approve(address spender, uint256 amount) external returns (bool);
797 
798     /**
799      * @dev Moves `amount` tokens from `from` to `to` using the
800      * allowance mechanism. `amount` is then deducted from the caller's
801      * allowance.
802      *
803      * Returns a boolean value indicating whether the operation succeeded.
804      *
805      * Emits a {Transfer} event.
806      */
807     function transferFrom(
808         address from,
809         address to,
810         uint256 amount
811     ) external returns (bool);
812 }
813 
814 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
815 
816 
817 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 
822 
823 
824 /**
825  * @title SafeERC20
826  * @dev Wrappers around ERC20 operations that throw on failure (when the token
827  * contract returns false). Tokens that return no value (and instead revert or
828  * throw on failure) are also supported, non-reverting calls are assumed to be
829  * successful.
830  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
831  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
832  */
833 library SafeERC20 {
834     using Address for address;
835 
836     function safeTransfer(
837         IERC20 token,
838         address to,
839         uint256 value
840     ) internal {
841         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
842     }
843 
844     function safeTransferFrom(
845         IERC20 token,
846         address from,
847         address to,
848         uint256 value
849     ) internal {
850         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
851     }
852 
853     /**
854      * @dev Deprecated. This function has issues similar to the ones found in
855      * {IERC20-approve}, and its usage is discouraged.
856      *
857      * Whenever possible, use {safeIncreaseAllowance} and
858      * {safeDecreaseAllowance} instead.
859      */
860     function safeApprove(
861         IERC20 token,
862         address spender,
863         uint256 value
864     ) internal {
865         // safeApprove should only be called when setting an initial allowance,
866         // or when resetting it to zero. To increase and decrease it, use
867         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
868         require(
869             (value == 0) || (token.allowance(address(this), spender) == 0),
870             "SafeERC20: approve from non-zero to non-zero allowance"
871         );
872         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
873     }
874 
875     function safeIncreaseAllowance(
876         IERC20 token,
877         address spender,
878         uint256 value
879     ) internal {
880         uint256 newAllowance = token.allowance(address(this), spender) + value;
881         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
882     }
883 
884     function safeDecreaseAllowance(
885         IERC20 token,
886         address spender,
887         uint256 value
888     ) internal {
889         unchecked {
890             uint256 oldAllowance = token.allowance(address(this), spender);
891             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
892             uint256 newAllowance = oldAllowance - value;
893             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
894         }
895     }
896 
897     function safePermit(
898         IERC20Permit token,
899         address owner,
900         address spender,
901         uint256 value,
902         uint256 deadline,
903         uint8 v,
904         bytes32 r,
905         bytes32 s
906     ) internal {
907         uint256 nonceBefore = token.nonces(owner);
908         token.permit(owner, spender, value, deadline, v, r, s);
909         uint256 nonceAfter = token.nonces(owner);
910         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
911     }
912 
913     /**
914      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
915      * on the return value: the return value is optional (but if data is returned, it must not be false).
916      * @param token The token targeted by the call.
917      * @param data The call data (encoded using abi.encode or one of its variants).
918      */
919     function _callOptionalReturn(IERC20 token, bytes memory data) private {
920         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
921         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
922         // the target address contains contract code and also asserts for success in the low-level call.
923 
924         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
925         if (returndata.length > 0) {
926             // Return data is optional
927             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
928         }
929     }
930 }
931 
932 // File: contracts/DucksMigration.sol
933 
934 
935 pragma solidity ^0.8.4;
936 
937 
938 
939 
940 
941 
942 contract DucksMigration is Ownable, ReentrancyGuard {
943     using SafeERC20 for IERC20;
944 
945     // Interfaces for ERC20 and ERC721
946     IERC20 public immutable rewardsToken;
947     IERC721A public immutable nftCollection;
948 
949     // Migrator info
950     struct Migrator {
951         // Amount of ERC721 Tokens staked
952         uint256 amountMigrated;
953         // Last time of details update for this User
954         uint256 timeOfLastUpdate;
955         // Calculated, but unclaimed rewards for the User. The rewards are
956         // calculated each time the user writes to the Smart Contract
957         uint256 unclaimedRewards;
958         uint256[] stakedTokens;
959     }
960 
961     // Rewards per day per token deposited in wei.
962     // Rewards are cumulated once every day.
963     uint256 private rewardsPerDay = 1;
964     uint256 public lockPeriod = 120;
965 
966     // Mapping of User Address to Migrator info
967     mapping(address => Migrator) public migrators;
968     // Mapping of Token Id to Migrator. Made for the SC to remeber
969     // who to send back the ERC721 Token to.
970     mapping(uint256 => address) public migratorAddress;
971     // Mapping of Token Id to Time Staked. Made to check if lock up
972     // period is over.
973     mapping(uint256 => uint256) public tokenUnlockTime;
974 
975     address[] public migratorsArray;
976 
977     // Constructor function
978     constructor(IERC721A _nftCollection, IERC20 _rewardsToken) {
979         nftCollection = _nftCollection;
980         rewardsToken = _rewardsToken;
981     }
982 
983     // If address already has ERC721 Token/s staked, calculate the rewards.
984     // For every new Token Id in param transferFrom user to this Smart Contract,
985     // increment the amountMigrated and map msg.sender to the Token Id of the staked
986     // Token to later send back on withdrawal. Finally give timeOfLastUpdate the
987     // value of now.
988     function stake(uint256[] calldata _tokenIds) external nonReentrant {
989         if (migrators[msg.sender].amountMigrated > 0) {
990             uint256 rewards = calculateRewards(msg.sender);
991             migrators[msg.sender].unclaimedRewards += rewards;
992         } else {
993             migratorsArray.push(msg.sender);
994         }
995         uint256 len = _tokenIds.length;
996         for (uint256 i; i < len; ++i) {
997             require(
998                 nftCollection.ownerOf(_tokenIds[i]) == msg.sender,
999                 "Can't stake tokens you don't own!"
1000             );
1001             nftCollection.transferFrom(msg.sender, address(this), _tokenIds[i]);
1002             migrators[msg.sender].stakedTokens.push(_tokenIds[i]);
1003             migratorAddress[_tokenIds[i]] = msg.sender;
1004             tokenUnlockTime[_tokenIds[i]] = block.timestamp + lockPeriod;
1005         }
1006         migrators[msg.sender].amountMigrated += len;
1007         migrators[msg.sender].timeOfLastUpdate = block.timestamp;
1008     }
1009 
1010     // Check if user has any ERC721 Tokens Staked and if he tried to withdraw,
1011     // calculate the rewards and store them in the unclaimedRewards and for each
1012     // ERC721 Token in param: check if msg.sender is the original Migrator, decrement
1013     // the amountMigrated of the user and transfer the ERC721 token back to them
1014     function withdraw(uint256[] calldata _tokenIds) external nonReentrant {
1015         require(
1016             migrators[msg.sender].amountMigrated > 0,
1017             "You have no tokens staked"
1018         );
1019         uint256 rewards = calculateRewards(msg.sender);
1020         migrators[msg.sender].unclaimedRewards += rewards;
1021         uint256 len = _tokenIds.length;
1022         for (uint256 i; i < len; ++i) {
1023             require(migratorAddress[_tokenIds[i]] == msg.sender);
1024             require(block.timestamp >= tokenUnlockTime[_tokenIds[i]], "Duck not done migrating yet.");
1025             migratorAddress[_tokenIds[i]] = address(0);
1026             tokenUnlockTime[_tokenIds[i]] = 0;
1027             nftCollection.transferFrom(address(this), msg.sender, _tokenIds[i]);
1028         }
1029         migrators[msg.sender].amountMigrated -= len;
1030         migrators[msg.sender].timeOfLastUpdate = block.timestamp;
1031         if (migrators[msg.sender].amountMigrated == 0) {
1032             for (uint256 i; i < migratorsArray.length; ++i) {
1033                 if (migratorsArray[i] == msg.sender) {
1034                     migratorsArray[i] = migratorsArray[migratorsArray.length - 1];
1035                     migratorsArray.pop();
1036                 }
1037             }
1038         }
1039     }
1040 
1041     // Calculate rewards for the msg.sender, check if there are any rewards
1042     // claim, set unclaimedRewards to 0 and transfer the ERC20 Reward token
1043     // to the user.
1044     function claimRewards() external {
1045         uint256 rewards = calculateRewards(msg.sender) +
1046             migrators[msg.sender].unclaimedRewards;
1047         require(rewards > 0, "You have no rewards to claim");
1048         migrators[msg.sender].timeOfLastUpdate = block.timestamp;
1049         migrators[msg.sender].unclaimedRewards = 0;
1050         rewardsToken.safeTransfer(msg.sender, rewards);
1051     }
1052 
1053     // Set the rewardsPerDay variable
1054     // Because the rewards are calculated passively, the owner has to first update the rewards
1055     // to all the migrators, witch could result in very heavy load and expensive transactions or
1056     // even reverting due to reaching the gas limit per block. Redesign incoming to bound loop.
1057     function setrewardsPerDay(uint256 _newValue) public onlyOwner {
1058         address[] memory _migrators = migratorsArray;
1059         uint256 len = _migrators.length;
1060         for (uint256 i; i < len; ++i) {
1061             address user = _migrators[i];
1062             migrators[user].unclaimedRewards += calculateRewards(user);
1063             migrators[msg.sender].timeOfLastUpdate = block.timestamp;
1064         }
1065         rewardsPerDay = _newValue;
1066     }
1067 
1068     //////////
1069     // View //
1070     //////////
1071 
1072     function userStakeInfo(address _user)
1073         public
1074         view
1075         returns (uint256 _tokensStaked, uint256 _availableRewards)
1076     {
1077         return (migrators[_user].amountMigrated, availableRewards(_user));
1078     }
1079 
1080     function getStakedTokens(address _user) public view returns (uint256[] memory) {
1081         // Check if we know this user
1082         if (migrators[_user].amountMigrated > 0) {
1083             // Return all the tokens in the stakedToken Array for this user that are not -1
1084             uint256[] memory _stakedTokens = new uint256[](migrators[_user].amountMigrated);
1085             uint256 _index = 0;
1086 
1087             for (uint256 j = 0; j < migrators[_user].stakedTokens.length; j++) {
1088                     _stakedTokens[_index] = migrators[_user].stakedTokens[j];
1089                     _index++;
1090             }
1091 
1092             return _stakedTokens;
1093         }
1094         
1095         // Otherwise, return empty array
1096         else {
1097             return new uint256[](0);
1098         }
1099     }
1100 
1101     function availableRewards(address _user) internal view returns (uint256) {
1102         if (migrators[_user].amountMigrated == 0) {
1103             return migrators[_user].unclaimedRewards;
1104         }
1105         uint256 _rewards = migrators[_user].unclaimedRewards +
1106             calculateRewards(_user);
1107         return _rewards;
1108     }
1109 
1110     /////////////
1111     // Internal//
1112     /////////////
1113 
1114     // Calculate rewards for param _migrator by calculating the time passed
1115     // since last update in hours and mulitplying it to ERC721 Tokens Staked
1116     // and rewardsPerDay.
1117     function calculateRewards(address _migrator)
1118         internal
1119         view
1120         returns (uint256 _rewards)
1121     {
1122         Migrator memory migrator = migrators[_migrator];
1123         return (((
1124             ((block.timestamp - migrator.timeOfLastUpdate) * migrator.amountMigrated)
1125         ) * rewardsPerDay) / 300);
1126     }
1127 }