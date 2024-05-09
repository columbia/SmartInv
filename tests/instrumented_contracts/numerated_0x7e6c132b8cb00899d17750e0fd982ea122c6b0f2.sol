1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/contracts/Authorizable.sol
114 
115 
116 pragma solidity >=0.4.22 <0.9.0;
117 
118 
119 contract Authorizable is Ownable {
120     mapping(address => bool) public trustees;
121 
122     constructor() {}
123 
124     modifier onlyAuthorized() {
125         require(trustees[msg.sender] || msg.sender == owner());
126         _;
127     }
128 
129     function addTrustee(address _trustee) public onlyOwner {
130         trustees[_trustee] = true;
131     }
132 
133     function removeTrustee(address _trustee) public onlyOwner {
134         delete trustees[_trustee];
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Address.sol
139 
140 
141 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
142 
143 pragma solidity ^0.8.1;
144 
145 /**
146  * @dev Collection of functions related to the address type
147  */
148 library Address {
149     /**
150      * @dev Returns true if `account` is a contract.
151      *
152      * [IMPORTANT]
153      * ====
154      * It is unsafe to assume that an address for which this function returns
155      * false is an externally-owned account (EOA) and not a contract.
156      *
157      * Among others, `isContract` will return false for the following
158      * types of addresses:
159      *
160      *  - an externally-owned account
161      *  - a contract in construction
162      *  - an address where a contract will be created
163      *  - an address where a contract lived, but was destroyed
164      * ====
165      *
166      * [IMPORTANT]
167      * ====
168      * You shouldn't rely on `isContract` to protect against flash loan attacks!
169      *
170      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
171      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
172      * constructor.
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies on extcodesize/address.code.length, which returns 0
177         // for contracts in construction, since the code is only stored at the end
178         // of the constructor execution.
179 
180         return account.code.length > 0;
181     }
182 
183     /**
184      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
185      * `recipient`, forwarding all available gas and reverting on errors.
186      *
187      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
188      * of certain opcodes, possibly making contracts go over the 2300 gas limit
189      * imposed by `transfer`, making them unable to receive funds via
190      * `transfer`. {sendValue} removes this limitation.
191      *
192      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
193      *
194      * IMPORTANT: because control is transferred to `recipient`, care must be
195      * taken to not create reentrancy vulnerabilities. Consider using
196      * {ReentrancyGuard} or the
197      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
198      */
199     function sendValue(address payable recipient, uint256 amount) internal {
200         require(address(this).balance >= amount, "Address: insufficient balance");
201 
202         (bool success, ) = recipient.call{value: amount}("");
203         require(success, "Address: unable to send value, recipient may have reverted");
204     }
205 
206     /**
207      * @dev Performs a Solidity function call using a low level `call`. A
208      * plain `call` is an unsafe replacement for a function call: use this
209      * function instead.
210      *
211      * If `target` reverts with a revert reason, it is bubbled up by this
212      * function (like regular Solidity function calls).
213      *
214      * Returns the raw returned data. To convert to the expected return value,
215      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
216      *
217      * Requirements:
218      *
219      * - `target` must be a contract.
220      * - calling `target` with `data` must not revert.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
230      * `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but also transferring `value` wei to `target`.
245      *
246      * Requirements:
247      *
248      * - the calling contract must have an ETH balance of at least `value`.
249      * - the called Solidity function must be `payable`.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value
257     ) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
263      * with `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(address(this).balance >= value, "Address: insufficient balance for call");
274         (bool success, bytes memory returndata) = target.call{value: value}(data);
275         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a static call.
281      *
282      * _Available since v3.3._
283      */
284     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
285         return functionStaticCall(target, data, "Address: low-level static call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal view returns (bytes memory) {
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.4._
318      */
319     function functionDelegateCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         (bool success, bytes memory returndata) = target.delegatecall(data);
325         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
330      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
331      *
332      * _Available since v4.8._
333      */
334     function verifyCallResultFromTarget(
335         address target,
336         bool success,
337         bytes memory returndata,
338         string memory errorMessage
339     ) internal view returns (bytes memory) {
340         if (success) {
341             if (returndata.length == 0) {
342                 // only check isContract if the call was successful and the return data is empty
343                 // otherwise we already know that it was a contract
344                 require(isContract(target), "Address: call to non-contract");
345             }
346             return returndata;
347         } else {
348             _revert(returndata, errorMessage);
349         }
350     }
351 
352     /**
353      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
354      * revert reason or using the provided one.
355      *
356      * _Available since v4.3._
357      */
358     function verifyCallResult(
359         bool success,
360         bytes memory returndata,
361         string memory errorMessage
362     ) internal pure returns (bytes memory) {
363         if (success) {
364             return returndata;
365         } else {
366             _revert(returndata, errorMessage);
367         }
368     }
369 
370     function _revert(bytes memory returndata, string memory errorMessage) private pure {
371         // Look for revert reason and bubble it up if present
372         if (returndata.length > 0) {
373             // The easiest way to bubble the revert reason is using memory via assembly
374             /// @solidity memory-safe-assembly
375             assembly {
376                 let returndata_size := mload(returndata)
377                 revert(add(32, returndata), returndata_size)
378             }
379         } else {
380             revert(errorMessage);
381         }
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
386 
387 
388 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 /**
393  * @title ERC721 token receiver interface
394  * @dev Interface for any contract that wants to support safeTransfers
395  * from ERC721 asset contracts.
396  */
397 interface IERC721Receiver {
398     /**
399      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
400      * by `operator` from `from`, this function is called.
401      *
402      * It must return its Solidity selector to confirm the token transfer.
403      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
404      *
405      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
406      */
407     function onERC721Received(
408         address operator,
409         address from,
410         uint256 tokenId,
411         bytes calldata data
412     ) external returns (bytes4);
413 }
414 
415 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev Interface of the ERC165 standard, as defined in the
424  * https://eips.ethereum.org/EIPS/eip-165[EIP].
425  *
426  * Implementers can declare support of contract interfaces, which can then be
427  * queried by others ({ERC165Checker}).
428  *
429  * For an implementation, see {ERC165}.
430  */
431 interface IERC165 {
432     /**
433      * @dev Returns true if this contract implements the interface defined by
434      * `interfaceId`. See the corresponding
435      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
436      * to learn more about how these ids are created.
437      *
438      * This function call must use less than 30 000 gas.
439      */
440     function supportsInterface(bytes4 interfaceId) external view returns (bool);
441 }
442 
443 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
444 
445 
446 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @dev Interface for the NFT Royalty Standard.
453  *
454  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
455  * support for royalty payments across all NFT marketplaces and ecosystem participants.
456  *
457  * _Available since v4.5._
458  */
459 interface IERC2981 is IERC165 {
460     /**
461      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
462      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
463      */
464     function royaltyInfo(uint256 tokenId, uint256 salePrice)
465         external
466         view
467         returns (address receiver, uint256 royaltyAmount);
468 }
469 
470 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Implementation of the {IERC165} interface.
480  *
481  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
482  * for the additional interface id that will be supported. For example:
483  *
484  * ```solidity
485  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
487  * }
488  * ```
489  *
490  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
491  */
492 abstract contract ERC165 is IERC165 {
493     /**
494      * @dev See {IERC165-supportsInterface}.
495      */
496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497         return interfaceId == type(IERC165).interfaceId;
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
502 
503 
504 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Required interface of an ERC721 compliant contract.
511  */
512 interface IERC721 is IERC165 {
513     /**
514      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
515      */
516     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
520      */
521     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
525      */
526     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
527 
528     /**
529      * @dev Returns the number of tokens in ``owner``'s account.
530      */
531     function balanceOf(address owner) external view returns (uint256 balance);
532 
533     /**
534      * @dev Returns the owner of the `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function ownerOf(uint256 tokenId) external view returns (address owner);
541 
542     /**
543      * @dev Safely transfers `tokenId` token from `from` to `to`.
544      *
545      * Requirements:
546      *
547      * - `from` cannot be the zero address.
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must exist and be owned by `from`.
550      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
551      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
552      *
553      * Emits a {Transfer} event.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId,
559         bytes calldata data
560     ) external;
561 
562     /**
563      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
564      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581 
582     /**
583      * @dev Transfers `tokenId` token from `from` to `to`.
584      *
585      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
586      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
587      * understand this adds an external call which potentially creates a reentrancy vulnerability.
588      *
589      * Requirements:
590      *
591      * - `from` cannot be the zero address.
592      * - `to` cannot be the zero address.
593      * - `tokenId` token must be owned by `from`.
594      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
595      *
596      * Emits a {Transfer} event.
597      */
598     function transferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) external;
603 
604     /**
605      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
606      * The approval is cleared when the token is transferred.
607      *
608      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
609      *
610      * Requirements:
611      *
612      * - The caller must own the token or be an approved operator.
613      * - `tokenId` must exist.
614      *
615      * Emits an {Approval} event.
616      */
617     function approve(address to, uint256 tokenId) external;
618 
619     /**
620      * @dev Approve or remove `operator` as an operator for the caller.
621      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
622      *
623      * Requirements:
624      *
625      * - The `operator` cannot be the caller.
626      *
627      * Emits an {ApprovalForAll} event.
628      */
629     function setApprovalForAll(address operator, bool _approved) external;
630 
631     /**
632      * @dev Returns the account approved for `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function getApproved(uint256 tokenId) external view returns (address operator);
639 
640     /**
641      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
642      *
643      * See {setApprovalForAll}
644      */
645     function isApprovedForAll(address owner, address operator) external view returns (bool);
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
649 
650 
651 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Enumerable is IERC721 {
661     /**
662      * @dev Returns the total amount of tokens stored by the contract.
663      */
664     function totalSupply() external view returns (uint256);
665 
666     /**
667      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
668      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
669      */
670     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
671 
672     /**
673      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
674      * Use along with {totalSupply} to enumerate all tokens.
675      */
676     function tokenByIndex(uint256 index) external view returns (uint256);
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 
687 /**
688  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
689  * @dev See https://eips.ethereum.org/EIPS/eip-721
690  */
691 interface IERC721Metadata is IERC721 {
692     /**
693      * @dev Returns the token collection name.
694      */
695     function name() external view returns (string memory);
696 
697     /**
698      * @dev Returns the token collection symbol.
699      */
700     function symbol() external view returns (string memory);
701 
702     /**
703      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
704      */
705     function tokenURI(uint256 tokenId) external view returns (string memory);
706 }
707 
708 // File: @openzeppelin/contracts/utils/math/Math.sol
709 
710 
711 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Standard math utilities missing in the Solidity language.
717  */
718 library Math {
719     enum Rounding {
720         Down, // Toward negative infinity
721         Up, // Toward infinity
722         Zero // Toward zero
723     }
724 
725     /**
726      * @dev Returns the largest of two numbers.
727      */
728     function max(uint256 a, uint256 b) internal pure returns (uint256) {
729         return a > b ? a : b;
730     }
731 
732     /**
733      * @dev Returns the smallest of two numbers.
734      */
735     function min(uint256 a, uint256 b) internal pure returns (uint256) {
736         return a < b ? a : b;
737     }
738 
739     /**
740      * @dev Returns the average of two numbers. The result is rounded towards
741      * zero.
742      */
743     function average(uint256 a, uint256 b) internal pure returns (uint256) {
744         // (a + b) / 2 can overflow.
745         return (a & b) + (a ^ b) / 2;
746     }
747 
748     /**
749      * @dev Returns the ceiling of the division of two numbers.
750      *
751      * This differs from standard division with `/` in that it rounds up instead
752      * of rounding down.
753      */
754     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
755         // (a + b - 1) / b can overflow on addition, so we distribute.
756         return a == 0 ? 0 : (a - 1) / b + 1;
757     }
758 
759     /**
760      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
761      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
762      * with further edits by Uniswap Labs also under MIT license.
763      */
764     function mulDiv(
765         uint256 x,
766         uint256 y,
767         uint256 denominator
768     ) internal pure returns (uint256 result) {
769         unchecked {
770             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
771             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
772             // variables such that product = prod1 * 2^256 + prod0.
773             uint256 prod0; // Least significant 256 bits of the product
774             uint256 prod1; // Most significant 256 bits of the product
775             assembly {
776                 let mm := mulmod(x, y, not(0))
777                 prod0 := mul(x, y)
778                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
779             }
780 
781             // Handle non-overflow cases, 256 by 256 division.
782             if (prod1 == 0) {
783                 return prod0 / denominator;
784             }
785 
786             // Make sure the result is less than 2^256. Also prevents denominator == 0.
787             require(denominator > prod1);
788 
789             ///////////////////////////////////////////////
790             // 512 by 256 division.
791             ///////////////////////////////////////////////
792 
793             // Make division exact by subtracting the remainder from [prod1 prod0].
794             uint256 remainder;
795             assembly {
796                 // Compute remainder using mulmod.
797                 remainder := mulmod(x, y, denominator)
798 
799                 // Subtract 256 bit number from 512 bit number.
800                 prod1 := sub(prod1, gt(remainder, prod0))
801                 prod0 := sub(prod0, remainder)
802             }
803 
804             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
805             // See https://cs.stackexchange.com/q/138556/92363.
806 
807             // Does not overflow because the denominator cannot be zero at this stage in the function.
808             uint256 twos = denominator & (~denominator + 1);
809             assembly {
810                 // Divide denominator by twos.
811                 denominator := div(denominator, twos)
812 
813                 // Divide [prod1 prod0] by twos.
814                 prod0 := div(prod0, twos)
815 
816                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
817                 twos := add(div(sub(0, twos), twos), 1)
818             }
819 
820             // Shift in bits from prod1 into prod0.
821             prod0 |= prod1 * twos;
822 
823             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
824             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
825             // four bits. That is, denominator * inv = 1 mod 2^4.
826             uint256 inverse = (3 * denominator) ^ 2;
827 
828             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
829             // in modular arithmetic, doubling the correct bits in each step.
830             inverse *= 2 - denominator * inverse; // inverse mod 2^8
831             inverse *= 2 - denominator * inverse; // inverse mod 2^16
832             inverse *= 2 - denominator * inverse; // inverse mod 2^32
833             inverse *= 2 - denominator * inverse; // inverse mod 2^64
834             inverse *= 2 - denominator * inverse; // inverse mod 2^128
835             inverse *= 2 - denominator * inverse; // inverse mod 2^256
836 
837             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
838             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
839             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
840             // is no longer required.
841             result = prod0 * inverse;
842             return result;
843         }
844     }
845 
846     /**
847      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
848      */
849     function mulDiv(
850         uint256 x,
851         uint256 y,
852         uint256 denominator,
853         Rounding rounding
854     ) internal pure returns (uint256) {
855         uint256 result = mulDiv(x, y, denominator);
856         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
857             result += 1;
858         }
859         return result;
860     }
861 
862     /**
863      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
864      *
865      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
866      */
867     function sqrt(uint256 a) internal pure returns (uint256) {
868         if (a == 0) {
869             return 0;
870         }
871 
872         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
873         //
874         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
875         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
876         //
877         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
878         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
879         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
880         //
881         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
882         uint256 result = 1 << (log2(a) >> 1);
883 
884         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
885         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
886         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
887         // into the expected uint128 result.
888         unchecked {
889             result = (result + a / result) >> 1;
890             result = (result + a / result) >> 1;
891             result = (result + a / result) >> 1;
892             result = (result + a / result) >> 1;
893             result = (result + a / result) >> 1;
894             result = (result + a / result) >> 1;
895             result = (result + a / result) >> 1;
896             return min(result, a / result);
897         }
898     }
899 
900     /**
901      * @notice Calculates sqrt(a), following the selected rounding direction.
902      */
903     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
904         unchecked {
905             uint256 result = sqrt(a);
906             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
907         }
908     }
909 
910     /**
911      * @dev Return the log in base 2, rounded down, of a positive value.
912      * Returns 0 if given 0.
913      */
914     function log2(uint256 value) internal pure returns (uint256) {
915         uint256 result = 0;
916         unchecked {
917             if (value >> 128 > 0) {
918                 value >>= 128;
919                 result += 128;
920             }
921             if (value >> 64 > 0) {
922                 value >>= 64;
923                 result += 64;
924             }
925             if (value >> 32 > 0) {
926                 value >>= 32;
927                 result += 32;
928             }
929             if (value >> 16 > 0) {
930                 value >>= 16;
931                 result += 16;
932             }
933             if (value >> 8 > 0) {
934                 value >>= 8;
935                 result += 8;
936             }
937             if (value >> 4 > 0) {
938                 value >>= 4;
939                 result += 4;
940             }
941             if (value >> 2 > 0) {
942                 value >>= 2;
943                 result += 2;
944             }
945             if (value >> 1 > 0) {
946                 result += 1;
947             }
948         }
949         return result;
950     }
951 
952     /**
953      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
954      * Returns 0 if given 0.
955      */
956     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
957         unchecked {
958             uint256 result = log2(value);
959             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
960         }
961     }
962 
963     /**
964      * @dev Return the log in base 10, rounded down, of a positive value.
965      * Returns 0 if given 0.
966      */
967     function log10(uint256 value) internal pure returns (uint256) {
968         uint256 result = 0;
969         unchecked {
970             if (value >= 10**64) {
971                 value /= 10**64;
972                 result += 64;
973             }
974             if (value >= 10**32) {
975                 value /= 10**32;
976                 result += 32;
977             }
978             if (value >= 10**16) {
979                 value /= 10**16;
980                 result += 16;
981             }
982             if (value >= 10**8) {
983                 value /= 10**8;
984                 result += 8;
985             }
986             if (value >= 10**4) {
987                 value /= 10**4;
988                 result += 4;
989             }
990             if (value >= 10**2) {
991                 value /= 10**2;
992                 result += 2;
993             }
994             if (value >= 10**1) {
995                 result += 1;
996             }
997         }
998         return result;
999     }
1000 
1001     /**
1002      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1003      * Returns 0 if given 0.
1004      */
1005     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1006         unchecked {
1007             uint256 result = log10(value);
1008             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1009         }
1010     }
1011 
1012     /**
1013      * @dev Return the log in base 256, rounded down, of a positive value.
1014      * Returns 0 if given 0.
1015      *
1016      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1017      */
1018     function log256(uint256 value) internal pure returns (uint256) {
1019         uint256 result = 0;
1020         unchecked {
1021             if (value >> 128 > 0) {
1022                 value >>= 128;
1023                 result += 16;
1024             }
1025             if (value >> 64 > 0) {
1026                 value >>= 64;
1027                 result += 8;
1028             }
1029             if (value >> 32 > 0) {
1030                 value >>= 32;
1031                 result += 4;
1032             }
1033             if (value >> 16 > 0) {
1034                 value >>= 16;
1035                 result += 2;
1036             }
1037             if (value >> 8 > 0) {
1038                 result += 1;
1039             }
1040         }
1041         return result;
1042     }
1043 
1044     /**
1045      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1046      * Returns 0 if given 0.
1047      */
1048     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1049         unchecked {
1050             uint256 result = log256(value);
1051             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1052         }
1053     }
1054 }
1055 
1056 // File: @openzeppelin/contracts/utils/Strings.sol
1057 
1058 
1059 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1060 
1061 pragma solidity ^0.8.0;
1062 
1063 
1064 /**
1065  * @dev String operations.
1066  */
1067 library Strings {
1068     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1069     uint8 private constant _ADDRESS_LENGTH = 20;
1070 
1071     /**
1072      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1073      */
1074     function toString(uint256 value) internal pure returns (string memory) {
1075         unchecked {
1076             uint256 length = Math.log10(value) + 1;
1077             string memory buffer = new string(length);
1078             uint256 ptr;
1079             /// @solidity memory-safe-assembly
1080             assembly {
1081                 ptr := add(buffer, add(32, length))
1082             }
1083             while (true) {
1084                 ptr--;
1085                 /// @solidity memory-safe-assembly
1086                 assembly {
1087                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1088                 }
1089                 value /= 10;
1090                 if (value == 0) break;
1091             }
1092             return buffer;
1093         }
1094     }
1095 
1096     /**
1097      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1098      */
1099     function toHexString(uint256 value) internal pure returns (string memory) {
1100         unchecked {
1101             return toHexString(value, Math.log256(value) + 1);
1102         }
1103     }
1104 
1105     /**
1106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1107      */
1108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1109         bytes memory buffer = new bytes(2 * length + 2);
1110         buffer[0] = "0";
1111         buffer[1] = "x";
1112         for (uint256 i = 2 * length + 1; i > 1; --i) {
1113             buffer[i] = _SYMBOLS[value & 0xf];
1114             value >>= 4;
1115         }
1116         require(value == 0, "Strings: hex length insufficient");
1117         return string(buffer);
1118     }
1119 
1120     /**
1121      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1122      */
1123     function toHexString(address addr) internal pure returns (string memory) {
1124         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1125     }
1126 }
1127 
1128 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1129 
1130 
1131 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1132 
1133 pragma solidity ^0.8.0;
1134 
1135 
1136 
1137 
1138 
1139 
1140 
1141 
1142 /**
1143  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1144  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1145  * {ERC721Enumerable}.
1146  */
1147 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1148     using Address for address;
1149     using Strings for uint256;
1150 
1151     // Token name
1152     string private _name;
1153 
1154     // Token symbol
1155     string private _symbol;
1156 
1157     // Mapping from token ID to owner address
1158     mapping(uint256 => address) private _owners;
1159 
1160     // Mapping owner address to token count
1161     mapping(address => uint256) private _balances;
1162 
1163     // Mapping from token ID to approved address
1164     mapping(uint256 => address) private _tokenApprovals;
1165 
1166     // Mapping from owner to operator approvals
1167     mapping(address => mapping(address => bool)) private _operatorApprovals;
1168 
1169     /**
1170      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1171      */
1172     constructor(string memory name_, string memory symbol_) {
1173         _name = name_;
1174         _symbol = symbol_;
1175     }
1176 
1177     /**
1178      * @dev See {IERC165-supportsInterface}.
1179      */
1180     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1181         return
1182             interfaceId == type(IERC721).interfaceId ||
1183             interfaceId == type(IERC721Metadata).interfaceId ||
1184             super.supportsInterface(interfaceId);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-balanceOf}.
1189      */
1190     function balanceOf(address owner) public view virtual override returns (uint256) {
1191         require(owner != address(0), "ERC721: address zero is not a valid owner");
1192         return _balances[owner];
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-ownerOf}.
1197      */
1198     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1199         address owner = _ownerOf(tokenId);
1200         require(owner != address(0), "ERC721: invalid token ID");
1201         return owner;
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Metadata-name}.
1206      */
1207     function name() public view virtual override returns (string memory) {
1208         return _name;
1209     }
1210 
1211     /**
1212      * @dev See {IERC721Metadata-symbol}.
1213      */
1214     function symbol() public view virtual override returns (string memory) {
1215         return _symbol;
1216     }
1217 
1218     /**
1219      * @dev See {IERC721Metadata-tokenURI}.
1220      */
1221     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1222         _requireMinted(tokenId);
1223 
1224         string memory baseURI = _baseURI();
1225         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1226     }
1227 
1228     /**
1229      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1230      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1231      * by default, can be overridden in child contracts.
1232      */
1233     function _baseURI() internal view virtual returns (string memory) {
1234         return "";
1235     }
1236 
1237     /**
1238      * @dev See {IERC721-approve}.
1239      */
1240     function approve(address to, uint256 tokenId) public virtual override {
1241         address owner = ERC721.ownerOf(tokenId);
1242         require(to != owner, "ERC721: approval to current owner");
1243 
1244         require(
1245             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1246             "ERC721: approve caller is not token owner or approved for all"
1247         );
1248 
1249         _approve(to, tokenId);
1250     }
1251 
1252     /**
1253      * @dev See {IERC721-getApproved}.
1254      */
1255     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1256         _requireMinted(tokenId);
1257 
1258         return _tokenApprovals[tokenId];
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-setApprovalForAll}.
1263      */
1264     function setApprovalForAll(address operator, bool approved) public virtual override {
1265         _setApprovalForAll(_msgSender(), operator, approved);
1266     }
1267 
1268     /**
1269      * @dev See {IERC721-isApprovedForAll}.
1270      */
1271     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1272         return _operatorApprovals[owner][operator];
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-transferFrom}.
1277      */
1278     function transferFrom(
1279         address from,
1280         address to,
1281         uint256 tokenId
1282     ) public virtual override {
1283         //solhint-disable-next-line max-line-length
1284         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1285 
1286         _transfer(from, to, tokenId);
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-safeTransferFrom}.
1291      */
1292     function safeTransferFrom(
1293         address from,
1294         address to,
1295         uint256 tokenId
1296     ) public virtual override {
1297         safeTransferFrom(from, to, tokenId, "");
1298     }
1299 
1300     /**
1301      * @dev See {IERC721-safeTransferFrom}.
1302      */
1303     function safeTransferFrom(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory data
1308     ) public virtual override {
1309         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1310         _safeTransfer(from, to, tokenId, data);
1311     }
1312 
1313     /**
1314      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1315      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1316      *
1317      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1318      *
1319      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1320      * implement alternative mechanisms to perform token transfer, such as signature-based.
1321      *
1322      * Requirements:
1323      *
1324      * - `from` cannot be the zero address.
1325      * - `to` cannot be the zero address.
1326      * - `tokenId` token must exist and be owned by `from`.
1327      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function _safeTransfer(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes memory data
1336     ) internal virtual {
1337         _transfer(from, to, tokenId);
1338         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1339     }
1340 
1341     /**
1342      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1343      */
1344     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1345         return _owners[tokenId];
1346     }
1347 
1348     /**
1349      * @dev Returns whether `tokenId` exists.
1350      *
1351      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1352      *
1353      * Tokens start existing when they are minted (`_mint`),
1354      * and stop existing when they are burned (`_burn`).
1355      */
1356     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1357         return _ownerOf(tokenId) != address(0);
1358     }
1359 
1360     /**
1361      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1362      *
1363      * Requirements:
1364      *
1365      * - `tokenId` must exist.
1366      */
1367     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1368         address owner = ERC721.ownerOf(tokenId);
1369         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1370     }
1371 
1372     /**
1373      * @dev Safely mints `tokenId` and transfers it to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - `tokenId` must not exist.
1378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _safeMint(address to, uint256 tokenId) internal virtual {
1383         _safeMint(to, tokenId, "");
1384     }
1385 
1386     /**
1387      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1388      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1389      */
1390     function _safeMint(
1391         address to,
1392         uint256 tokenId,
1393         bytes memory data
1394     ) internal virtual {
1395         _mint(to, tokenId);
1396         require(
1397             _checkOnERC721Received(address(0), to, tokenId, data),
1398             "ERC721: transfer to non ERC721Receiver implementer"
1399         );
1400     }
1401 
1402     /**
1403      * @dev Mints `tokenId` and transfers it to `to`.
1404      *
1405      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1406      *
1407      * Requirements:
1408      *
1409      * - `tokenId` must not exist.
1410      * - `to` cannot be the zero address.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function _mint(address to, uint256 tokenId) internal virtual {
1415         require(to != address(0), "ERC721: mint to the zero address");
1416         require(!_exists(tokenId), "ERC721: token already minted");
1417 
1418         _beforeTokenTransfer(address(0), to, tokenId, 1);
1419 
1420         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1421         require(!_exists(tokenId), "ERC721: token already minted");
1422 
1423         unchecked {
1424             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1425             // Given that tokens are minted one by one, it is impossible in practice that
1426             // this ever happens. Might change if we allow batch minting.
1427             // The ERC fails to describe this case.
1428             _balances[to] += 1;
1429         }
1430 
1431         _owners[tokenId] = to;
1432 
1433         emit Transfer(address(0), to, tokenId);
1434 
1435         _afterTokenTransfer(address(0), to, tokenId, 1);
1436     }
1437 
1438     /**
1439      * @dev Destroys `tokenId`.
1440      * The approval is cleared when the token is burned.
1441      * This is an internal function that does not check if the sender is authorized to operate on the token.
1442      *
1443      * Requirements:
1444      *
1445      * - `tokenId` must exist.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function _burn(uint256 tokenId) internal virtual {
1450         address owner = ERC721.ownerOf(tokenId);
1451 
1452         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1453 
1454         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1455         owner = ERC721.ownerOf(tokenId);
1456 
1457         // Clear approvals
1458         delete _tokenApprovals[tokenId];
1459 
1460         unchecked {
1461             // Cannot overflow, as that would require more tokens to be burned/transferred
1462             // out than the owner initially received through minting and transferring in.
1463             _balances[owner] -= 1;
1464         }
1465         delete _owners[tokenId];
1466 
1467         emit Transfer(owner, address(0), tokenId);
1468 
1469         _afterTokenTransfer(owner, address(0), tokenId, 1);
1470     }
1471 
1472     /**
1473      * @dev Transfers `tokenId` from `from` to `to`.
1474      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1475      *
1476      * Requirements:
1477      *
1478      * - `to` cannot be the zero address.
1479      * - `tokenId` token must be owned by `from`.
1480      *
1481      * Emits a {Transfer} event.
1482      */
1483     function _transfer(
1484         address from,
1485         address to,
1486         uint256 tokenId
1487     ) internal virtual {
1488         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1489         require(to != address(0), "ERC721: transfer to the zero address");
1490 
1491         _beforeTokenTransfer(from, to, tokenId, 1);
1492 
1493         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1494         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1495 
1496         // Clear approvals from the previous owner
1497         delete _tokenApprovals[tokenId];
1498 
1499         unchecked {
1500             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1501             // `from`'s balance is the number of token held, which is at least one before the current
1502             // transfer.
1503             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1504             // all 2**256 token ids to be minted, which in practice is impossible.
1505             _balances[from] -= 1;
1506             _balances[to] += 1;
1507         }
1508         _owners[tokenId] = to;
1509 
1510         emit Transfer(from, to, tokenId);
1511 
1512         _afterTokenTransfer(from, to, tokenId, 1);
1513     }
1514 
1515     /**
1516      * @dev Approve `to` to operate on `tokenId`
1517      *
1518      * Emits an {Approval} event.
1519      */
1520     function _approve(address to, uint256 tokenId) internal virtual {
1521         _tokenApprovals[tokenId] = to;
1522         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1523     }
1524 
1525     /**
1526      * @dev Approve `operator` to operate on all of `owner` tokens
1527      *
1528      * Emits an {ApprovalForAll} event.
1529      */
1530     function _setApprovalForAll(
1531         address owner,
1532         address operator,
1533         bool approved
1534     ) internal virtual {
1535         require(owner != operator, "ERC721: approve to caller");
1536         _operatorApprovals[owner][operator] = approved;
1537         emit ApprovalForAll(owner, operator, approved);
1538     }
1539 
1540     /**
1541      * @dev Reverts if the `tokenId` has not been minted yet.
1542      */
1543     function _requireMinted(uint256 tokenId) internal view virtual {
1544         require(_exists(tokenId), "ERC721: invalid token ID");
1545     }
1546 
1547     /**
1548      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1549      * The call is not executed if the target address is not a contract.
1550      *
1551      * @param from address representing the previous owner of the given token ID
1552      * @param to target address that will receive the tokens
1553      * @param tokenId uint256 ID of the token to be transferred
1554      * @param data bytes optional data to send along with the call
1555      * @return bool whether the call correctly returned the expected magic value
1556      */
1557     function _checkOnERC721Received(
1558         address from,
1559         address to,
1560         uint256 tokenId,
1561         bytes memory data
1562     ) private returns (bool) {
1563         if (to.isContract()) {
1564             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1565                 return retval == IERC721Receiver.onERC721Received.selector;
1566             } catch (bytes memory reason) {
1567                 if (reason.length == 0) {
1568                     revert("ERC721: transfer to non ERC721Receiver implementer");
1569                 } else {
1570                     /// @solidity memory-safe-assembly
1571                     assembly {
1572                         revert(add(32, reason), mload(reason))
1573                     }
1574                 }
1575             }
1576         } else {
1577             return true;
1578         }
1579     }
1580 
1581     /**
1582      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1583      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1584      *
1585      * Calling conditions:
1586      *
1587      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1588      * - When `from` is zero, the tokens will be minted for `to`.
1589      * - When `to` is zero, ``from``'s tokens will be burned.
1590      * - `from` and `to` are never both zero.
1591      * - `batchSize` is non-zero.
1592      *
1593      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1594      */
1595     function _beforeTokenTransfer(
1596         address from,
1597         address to,
1598         uint256, /* firstTokenId */
1599         uint256 batchSize
1600     ) internal virtual {
1601         if (batchSize > 1) {
1602             if (from != address(0)) {
1603                 _balances[from] -= batchSize;
1604             }
1605             if (to != address(0)) {
1606                 _balances[to] += batchSize;
1607             }
1608         }
1609     }
1610 
1611     /**
1612      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1613      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1614      *
1615      * Calling conditions:
1616      *
1617      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1618      * - When `from` is zero, the tokens were minted for `to`.
1619      * - When `to` is zero, ``from``'s tokens were burned.
1620      * - `from` and `to` are never both zero.
1621      * - `batchSize` is non-zero.
1622      *
1623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1624      */
1625     function _afterTokenTransfer(
1626         address from,
1627         address to,
1628         uint256 firstTokenId,
1629         uint256 batchSize
1630     ) internal virtual {}
1631 }
1632 
1633 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1634 
1635 
1636 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1637 
1638 pragma solidity ^0.8.0;
1639 
1640 
1641 
1642 /**
1643  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1644  * enumerability of all the token ids in the contract as well as all token ids owned by each
1645  * account.
1646  */
1647 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1648     // Mapping from owner to list of owned token IDs
1649     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1650 
1651     // Mapping from token ID to index of the owner tokens list
1652     mapping(uint256 => uint256) private _ownedTokensIndex;
1653 
1654     // Array with all token ids, used for enumeration
1655     uint256[] private _allTokens;
1656 
1657     // Mapping from token id to position in the allTokens array
1658     mapping(uint256 => uint256) private _allTokensIndex;
1659 
1660     /**
1661      * @dev See {IERC165-supportsInterface}.
1662      */
1663     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1664         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1665     }
1666 
1667     /**
1668      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1669      */
1670     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1671         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1672         return _ownedTokens[owner][index];
1673     }
1674 
1675     /**
1676      * @dev See {IERC721Enumerable-totalSupply}.
1677      */
1678     function totalSupply() public view virtual override returns (uint256) {
1679         return _allTokens.length;
1680     }
1681 
1682     /**
1683      * @dev See {IERC721Enumerable-tokenByIndex}.
1684      */
1685     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1686         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1687         return _allTokens[index];
1688     }
1689 
1690     /**
1691      * @dev See {ERC721-_beforeTokenTransfer}.
1692      */
1693     function _beforeTokenTransfer(
1694         address from,
1695         address to,
1696         uint256 firstTokenId,
1697         uint256 batchSize
1698     ) internal virtual override {
1699         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1700 
1701         if (batchSize > 1) {
1702             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1703             revert("ERC721Enumerable: consecutive transfers not supported");
1704         }
1705 
1706         uint256 tokenId = firstTokenId;
1707 
1708         if (from == address(0)) {
1709             _addTokenToAllTokensEnumeration(tokenId);
1710         } else if (from != to) {
1711             _removeTokenFromOwnerEnumeration(from, tokenId);
1712         }
1713         if (to == address(0)) {
1714             _removeTokenFromAllTokensEnumeration(tokenId);
1715         } else if (to != from) {
1716             _addTokenToOwnerEnumeration(to, tokenId);
1717         }
1718     }
1719 
1720     /**
1721      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1722      * @param to address representing the new owner of the given token ID
1723      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1724      */
1725     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1726         uint256 length = ERC721.balanceOf(to);
1727         _ownedTokens[to][length] = tokenId;
1728         _ownedTokensIndex[tokenId] = length;
1729     }
1730 
1731     /**
1732      * @dev Private function to add a token to this extension's token tracking data structures.
1733      * @param tokenId uint256 ID of the token to be added to the tokens list
1734      */
1735     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1736         _allTokensIndex[tokenId] = _allTokens.length;
1737         _allTokens.push(tokenId);
1738     }
1739 
1740     /**
1741      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1742      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1743      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1744      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1745      * @param from address representing the previous owner of the given token ID
1746      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1747      */
1748     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1749         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1750         // then delete the last slot (swap and pop).
1751 
1752         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1753         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1754 
1755         // When the token to delete is the last token, the swap operation is unnecessary
1756         if (tokenIndex != lastTokenIndex) {
1757             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1758 
1759             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1760             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1761         }
1762 
1763         // This also deletes the contents at the last position of the array
1764         delete _ownedTokensIndex[tokenId];
1765         delete _ownedTokens[from][lastTokenIndex];
1766     }
1767 
1768     /**
1769      * @dev Private function to remove a token from this extension's token tracking data structures.
1770      * This has O(1) time complexity, but alters the order of the _allTokens array.
1771      * @param tokenId uint256 ID of the token to be removed from the tokens list
1772      */
1773     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1774         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1775         // then delete the last slot (swap and pop).
1776 
1777         uint256 lastTokenIndex = _allTokens.length - 1;
1778         uint256 tokenIndex = _allTokensIndex[tokenId];
1779 
1780         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1781         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1782         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1783         uint256 lastTokenId = _allTokens[lastTokenIndex];
1784 
1785         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1786         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1787 
1788         // This also deletes the contents at the last position of the array
1789         delete _allTokensIndex[tokenId];
1790         _allTokens.pop();
1791     }
1792 }
1793 
1794 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1795 
1796 
1797 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1798 
1799 pragma solidity ^0.8.0;
1800 
1801 
1802 /**
1803  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1804  *
1805  * These functions can be used to verify that a message was signed by the holder
1806  * of the private keys of a given address.
1807  */
1808 library ECDSA {
1809     enum RecoverError {
1810         NoError,
1811         InvalidSignature,
1812         InvalidSignatureLength,
1813         InvalidSignatureS,
1814         InvalidSignatureV // Deprecated in v4.8
1815     }
1816 
1817     function _throwError(RecoverError error) private pure {
1818         if (error == RecoverError.NoError) {
1819             return; // no error: do nothing
1820         } else if (error == RecoverError.InvalidSignature) {
1821             revert("ECDSA: invalid signature");
1822         } else if (error == RecoverError.InvalidSignatureLength) {
1823             revert("ECDSA: invalid signature length");
1824         } else if (error == RecoverError.InvalidSignatureS) {
1825             revert("ECDSA: invalid signature 's' value");
1826         }
1827     }
1828 
1829     /**
1830      * @dev Returns the address that signed a hashed message (`hash`) with
1831      * `signature` or error string. This address can then be used for verification purposes.
1832      *
1833      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1834      * this function rejects them by requiring the `s` value to be in the lower
1835      * half order, and the `v` value to be either 27 or 28.
1836      *
1837      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1838      * verification to be secure: it is possible to craft signatures that
1839      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1840      * this is by receiving a hash of the original message (which may otherwise
1841      * be too long), and then calling {toEthSignedMessageHash} on it.
1842      *
1843      * Documentation for signature generation:
1844      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1845      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1846      *
1847      * _Available since v4.3._
1848      */
1849     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1850         if (signature.length == 65) {
1851             bytes32 r;
1852             bytes32 s;
1853             uint8 v;
1854             // ecrecover takes the signature parameters, and the only way to get them
1855             // currently is to use assembly.
1856             /// @solidity memory-safe-assembly
1857             assembly {
1858                 r := mload(add(signature, 0x20))
1859                 s := mload(add(signature, 0x40))
1860                 v := byte(0, mload(add(signature, 0x60)))
1861             }
1862             return tryRecover(hash, v, r, s);
1863         } else {
1864             return (address(0), RecoverError.InvalidSignatureLength);
1865         }
1866     }
1867 
1868     /**
1869      * @dev Returns the address that signed a hashed message (`hash`) with
1870      * `signature`. This address can then be used for verification purposes.
1871      *
1872      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1873      * this function rejects them by requiring the `s` value to be in the lower
1874      * half order, and the `v` value to be either 27 or 28.
1875      *
1876      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1877      * verification to be secure: it is possible to craft signatures that
1878      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1879      * this is by receiving a hash of the original message (which may otherwise
1880      * be too long), and then calling {toEthSignedMessageHash} on it.
1881      */
1882     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1883         (address recovered, RecoverError error) = tryRecover(hash, signature);
1884         _throwError(error);
1885         return recovered;
1886     }
1887 
1888     /**
1889      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1890      *
1891      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1892      *
1893      * _Available since v4.3._
1894      */
1895     function tryRecover(
1896         bytes32 hash,
1897         bytes32 r,
1898         bytes32 vs
1899     ) internal pure returns (address, RecoverError) {
1900         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1901         uint8 v = uint8((uint256(vs) >> 255) + 27);
1902         return tryRecover(hash, v, r, s);
1903     }
1904 
1905     /**
1906      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1907      *
1908      * _Available since v4.2._
1909      */
1910     function recover(
1911         bytes32 hash,
1912         bytes32 r,
1913         bytes32 vs
1914     ) internal pure returns (address) {
1915         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1916         _throwError(error);
1917         return recovered;
1918     }
1919 
1920     /**
1921      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1922      * `r` and `s` signature fields separately.
1923      *
1924      * _Available since v4.3._
1925      */
1926     function tryRecover(
1927         bytes32 hash,
1928         uint8 v,
1929         bytes32 r,
1930         bytes32 s
1931     ) internal pure returns (address, RecoverError) {
1932         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1933         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1934         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1935         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1936         //
1937         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1938         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1939         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1940         // these malleable signatures as well.
1941         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1942             return (address(0), RecoverError.InvalidSignatureS);
1943         }
1944 
1945         // If the signature is valid (and not malleable), return the signer address
1946         address signer = ecrecover(hash, v, r, s);
1947         if (signer == address(0)) {
1948             return (address(0), RecoverError.InvalidSignature);
1949         }
1950 
1951         return (signer, RecoverError.NoError);
1952     }
1953 
1954     /**
1955      * @dev Overload of {ECDSA-recover} that receives the `v`,
1956      * `r` and `s` signature fields separately.
1957      */
1958     function recover(
1959         bytes32 hash,
1960         uint8 v,
1961         bytes32 r,
1962         bytes32 s
1963     ) internal pure returns (address) {
1964         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1965         _throwError(error);
1966         return recovered;
1967     }
1968 
1969     /**
1970      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1971      * produces hash corresponding to the one signed with the
1972      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1973      * JSON-RPC method as part of EIP-191.
1974      *
1975      * See {recover}.
1976      */
1977     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1978         // 32 is the length in bytes of hash,
1979         // enforced by the type signature above
1980         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1981     }
1982 
1983     /**
1984      * @dev Returns an Ethereum Signed Message, created from `s`. This
1985      * produces hash corresponding to the one signed with the
1986      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1987      * JSON-RPC method as part of EIP-191.
1988      *
1989      * See {recover}.
1990      */
1991     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1992         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1993     }
1994 
1995     /**
1996      * @dev Returns an Ethereum Signed Typed Data, created from a
1997      * `domainSeparator` and a `structHash`. This produces hash corresponding
1998      * to the one signed with the
1999      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2000      * JSON-RPC method as part of EIP-712.
2001      *
2002      * See {recover}.
2003      */
2004     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2005         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2006     }
2007 }
2008 
2009 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/contracts/FeralfileArtworkV3.sol
2010 
2011 
2012 pragma solidity ^0.8.0;
2013 
2014 
2015 
2016 
2017 
2018 
2019 contract FeralfileExhibitionV3 is ERC721Enumerable, Authorizable, IERC2981 {
2020     using Strings for uint256;
2021 
2022     // royalty payout address
2023     address public royaltyPayoutAddress;
2024 
2025     // the basis points of royalty payments for each secondary sales
2026     uint256 public immutable secondarySaleRoyaltyBPS;
2027 
2028     // the maximum basis points of royalty payments
2029     uint256 public constant MAX_ROYALITY_BPS = 100_00;
2030 
2031     // version code of contract
2032     string public constant codeVersion = "FeralfileExhibitionV3";
2033 
2034     // burnable
2035     bool public isBurnable;
2036 
2037     // bridgeable
2038     bool public isBridgeable;
2039 
2040     // token base URI
2041     string private _tokenBaseURI;
2042 
2043     // contract URI
2044     string private _contractURI;
2045 
2046     /// @notice A structure for Feral File artwork
2047     struct Artwork {
2048         string title;
2049         string artistName;
2050         string fingerprint;
2051         uint256 editionSize;
2052         uint256 AEAmount;
2053         uint256 PPAmount;
2054     }
2055 
2056     struct ArtworkEdition {
2057         uint256 editionID;
2058         string ipfsCID;
2059     }
2060 
2061     struct TransferArtworkParam {
2062         address from;
2063         address to;
2064         uint256 tokenID;
2065         uint256 expireTime;
2066         bytes32 r_;
2067         bytes32 s_;
2068         uint8 v_;
2069     }
2070 
2071     struct MintArtworkParam {
2072         uint256 artworkID;
2073         uint256 edition;
2074         address artist;
2075         address owner;
2076         string ipfsCID;
2077     }
2078 
2079     struct ArtworkEditionIndex {
2080         uint256 artworkID;
2081         uint256 index;
2082     }
2083 
2084     uint256[] private _allArtworks;
2085     mapping(uint256 => Artwork) public artworks; // artworkID => Artwork
2086     mapping(uint256 => ArtworkEdition) public artworkEditions; // artworkEditionID => ArtworkEdition
2087     mapping(uint256 => uint256[]) internal allArtworkEditions; // artworkID => []ArtworkEditionID
2088     mapping(string => bool) internal registeredIPFSCIDs; // ipfsCID => bool
2089     mapping(uint256 => ArtworkEditionIndex) internal allArtworkEditionsIndex; // editionID => ArtworkEditionIndex
2090 
2091     constructor(
2092         string memory name_,
2093         string memory symbol_,
2094         uint256 secondarySaleRoyaltyBPS_,
2095         address royaltyPayoutAddress_,
2096         string memory contractURI_,
2097         string memory tokenBaseURI_,
2098         bool isBurnable_,
2099         bool isBridgeable_
2100     ) ERC721(name_, symbol_) {
2101         require(
2102             secondarySaleRoyaltyBPS_ <= MAX_ROYALITY_BPS,
2103             "royalty BPS for secondary sales can not be greater than the maximum royalty BPS"
2104         );
2105         require(
2106             royaltyPayoutAddress_ != address(0),
2107             "invalid royalty payout address"
2108         );
2109 
2110         secondarySaleRoyaltyBPS = secondarySaleRoyaltyBPS_;
2111         royaltyPayoutAddress = royaltyPayoutAddress_;
2112         _contractURI = contractURI_;
2113         _tokenBaseURI = tokenBaseURI_;
2114         isBurnable = isBurnable_;
2115         isBridgeable = isBridgeable_;
2116     }
2117 
2118     function supportsInterface(bytes4 interfaceId)
2119         public
2120         view
2121         virtual
2122         override(ERC721Enumerable, IERC165)
2123         returns (bool)
2124     {
2125         return
2126             interfaceId == type(IERC721Enumerable).interfaceId ||
2127             super.supportsInterface(interfaceId);
2128     }
2129 
2130     /// @notice Call to create an artwork in the exhibition
2131     /// @param fingerprint - the fingerprint of an artwork
2132     /// @param title - the title of an artwork
2133     /// @param artistName - the artist of an artwork
2134     /// @param editionSize - the maximum edition size of an artwork
2135     function _createArtwork(
2136         string memory fingerprint,
2137         string memory title,
2138         string memory artistName,
2139         uint256 editionSize,
2140         uint256 aeAmount,
2141         uint256 ppAmount
2142     ) private {
2143         require(bytes(title).length != 0, "title can not be empty");
2144         require(bytes(artistName).length != 0, "artist can not be empty");
2145         require(bytes(fingerprint).length != 0, "fingerprint can not be empty");
2146         require(editionSize > 0, "edition size needs to be at least 1");
2147 
2148         uint256 artworkID = uint256(keccak256(abi.encode(fingerprint)));
2149 
2150         /// @notice make sure the artwork have not been registered
2151         require(
2152             bytes(artworks[artworkID].fingerprint).length == 0,
2153             "an artwork with the same fingerprint has already registered"
2154         );
2155 
2156         Artwork memory artwork = Artwork(
2157             title = title,
2158             artistName = artistName,
2159             fingerprint = fingerprint,
2160             editionSize = editionSize,
2161             aeAmount = aeAmount,
2162             ppAmount = ppAmount
2163         );
2164 
2165         _allArtworks.push(artworkID);
2166         artworks[artworkID] = artwork;
2167 
2168         emit NewArtwork(artworkID);
2169     }
2170 
2171     /// @notice createArtworks use for create list of artworks in a transaction
2172     /// @param artworks_ - the array of artwork
2173     function createArtworks(Artwork[] memory artworks_)
2174         external
2175         onlyAuthorized
2176     {
2177         for (uint256 i = 0; i < artworks_.length; i++) {
2178             _createArtwork(
2179                 artworks_[i].fingerprint,
2180                 artworks_[i].title,
2181                 artworks_[i].artistName,
2182                 artworks_[i].editionSize,
2183                 artworks_[i].AEAmount,
2184                 artworks_[i].PPAmount
2185             );
2186         }
2187     }
2188 
2189     /// @notice Return a count of artworks registered in this exhibition
2190     function totalArtworks() public view virtual returns (uint256) {
2191         return _allArtworks.length;
2192     }
2193 
2194     /// @notice Return the token identifier for the `index`th artwork
2195     function getArtworkByIndex(uint256 index)
2196         public
2197         view
2198         virtual
2199         returns (uint256)
2200     {
2201         require(
2202             index < totalArtworks(),
2203             "artworks: global index out of bounds"
2204         );
2205         return _allArtworks[index];
2206     }
2207 
2208     /// @notice Update the IPFS cid of an edition to a new value
2209     function updateArtworkEditionIPFSCid(uint256 tokenId, string memory ipfsCID)
2210         external
2211         onlyAuthorized
2212     {
2213         require(_exists(tokenId), "artwork edition is not found");
2214         require(!registeredIPFSCIDs[ipfsCID], "ipfs id has registered");
2215 
2216         ArtworkEdition storage edition = artworkEditions[tokenId];
2217         delete registeredIPFSCIDs[edition.ipfsCID];
2218         registeredIPFSCIDs[ipfsCID] = true;
2219         edition.ipfsCID = ipfsCID;
2220     }
2221 
2222     /// @notice setRoyaltyPayoutAddress assigns a payout address so
2223     //          that we can split the royalty.
2224     /// @param royaltyPayoutAddress_ - the new royalty payout address
2225     function setRoyaltyPayoutAddress(address royaltyPayoutAddress_)
2226         external
2227         onlyAuthorized
2228     {
2229         require(
2230             royaltyPayoutAddress_ != address(0),
2231             "invalid royalty payout address"
2232         );
2233         royaltyPayoutAddress = royaltyPayoutAddress_;
2234     }
2235 
2236     /// @notice Return the edition counts for an artwork
2237     function totalEditionOfArtwork(uint256 artworkID)
2238         public
2239         view
2240         returns (uint256)
2241     {
2242         return allArtworkEditions[artworkID].length;
2243     }
2244 
2245     /// @notice Return the edition id of an artwork by index
2246     function getArtworkEditionByIndex(uint256 artworkID, uint256 index)
2247         public
2248         view
2249         returns (uint256)
2250     {
2251         require(index < totalEditionOfArtwork(artworkID));
2252         return allArtworkEditions[artworkID][index];
2253     }
2254 
2255     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
2256     function tokenURI(uint256 tokenId)
2257         public
2258         view
2259         virtual
2260         override
2261         returns (string memory)
2262     {
2263         require(
2264             _exists(tokenId),
2265             "ERC721Metadata: URI query for nonexistent token"
2266         );
2267 
2268         string memory baseURI = _tokenBaseURI;
2269         if (bytes(baseURI).length == 0) {
2270             baseURI = "ipfs://";
2271         }
2272 
2273         return
2274             string(abi.encodePacked(baseURI, artworkEditions[tokenId].ipfsCID));
2275     }
2276 
2277     /// @notice Update the base URI for all tokens
2278     function setTokenBaseURI(string memory baseURI_) external onlyAuthorized {
2279         _tokenBaseURI = baseURI_;
2280     }
2281 
2282     /// @notice A URL for the opensea storefront-level metadata
2283     function contractURI() public view returns (string memory) {
2284         return _contractURI;
2285     }
2286 
2287     /// @notice Called with the sale price to determine how much royalty
2288     //          is owed and to whom.
2289     /// @param tokenId - the NFT asset queried for royalty information
2290     /// @param salePrice - the sale price of the NFT asset specified by tokenId
2291     /// @return receiver - address of who should be sent the royalty payment
2292     /// @return royaltyAmount - the royalty payment amount for salePrice
2293     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2294         external
2295         view
2296         override
2297         returns (address receiver, uint256 royaltyAmount)
2298     {
2299         require(
2300             _exists(tokenId),
2301             "ERC2981: query royalty info for nonexistent token"
2302         );
2303 
2304         receiver = royaltyPayoutAddress;
2305 
2306         royaltyAmount =
2307             (salePrice * secondarySaleRoyaltyBPS) /
2308             MAX_ROYALITY_BPS;
2309     }
2310 
2311     /// @notice isValidRequest validates a message by ecrecover to ensure
2312     //          it is signed by owner of token.
2313     /// @param message_ - the raw message for signing
2314     /// @param owner_ - owner address of token
2315     /// @param r_ - part of signature for validating parameters integrity
2316     /// @param s_ - part of signature for validating parameters integrity
2317     /// @param v_ - part of signature for validating parameters integrity
2318     function isValidRequest(
2319         bytes32 message_,
2320         address owner_,
2321         bytes32 r_,
2322         bytes32 s_,
2323         uint8 v_
2324     ) internal pure returns (bool) {
2325         address signer = ECDSA.recover(
2326             ECDSA.toEthSignedMessageHash(message_),
2327             v_,
2328             r_,
2329             s_
2330         );
2331         return signer == owner_;
2332     }
2333 
2334     /// @notice authorizedTransfer use for transfer list of items in a transaction
2335     /// @param transferParams_ - the array of transfer parameters
2336     function authorizedTransfer(TransferArtworkParam[] memory transferParams_)
2337         external
2338         onlyAuthorized
2339     {
2340         for (uint256 i = 0; i < transferParams_.length; i++) {
2341             _authorizedTransfer(transferParams_[i]);
2342         }
2343     }
2344 
2345     function _authorizedTransfer(TransferArtworkParam memory transferParam_)
2346         private
2347     {
2348         require(
2349             _exists(transferParam_.tokenID),
2350             "ERC721: artwork edition is not found"
2351         );
2352 
2353         require(
2354             _isApprovedOrOwner(transferParam_.from, transferParam_.tokenID),
2355             "ERC721: caller is not token owner nor approved"
2356         );
2357 
2358         require(
2359             block.timestamp <= transferParam_.expireTime,
2360             "FeralfileExhibitionV3: the transfer request is expired"
2361         );
2362 
2363         bytes32 requestHash = keccak256(
2364             abi.encode(
2365                 transferParam_.from,
2366                 transferParam_.to,
2367                 transferParam_.tokenID,
2368                 transferParam_.expireTime
2369             )
2370         );
2371 
2372         require(
2373             isValidRequest(
2374                 requestHash,
2375                 transferParam_.from,
2376                 transferParam_.r_,
2377                 transferParam_.s_,
2378                 transferParam_.v_
2379             ),
2380             "FeralfileExhibitionV3: the transfer request is not authorized"
2381         );
2382 
2383         _safeTransfer(
2384             transferParam_.from,
2385             transferParam_.to,
2386             transferParam_.tokenID,
2387             ""
2388         );
2389     }
2390 
2391     /// @notice batchMint is function mint array of tokens
2392     /// @param mintParams_ - the array of transfer parameters
2393     function batchMint(MintArtworkParam[] memory mintParams_)
2394         external
2395         onlyAuthorized
2396     {
2397         for (uint256 i = 0; i < mintParams_.length; i++) {
2398             _mintArtwork(
2399                 mintParams_[i].artworkID,
2400                 mintParams_[i].edition,
2401                 mintParams_[i].artist,
2402                 mintParams_[i].owner,
2403                 mintParams_[i].ipfsCID
2404             );
2405         }
2406     }
2407 
2408     /// @notice mint artwork to ERC721
2409     /// @param artworkID_ - the artwork id where the new edition is referenced to
2410     /// @param editionNumber_ - the edition number of the artwork edition
2411     /// @param artist_ - the artist address of the new minted token
2412     /// @param owner_ - the owner address of the new minted token
2413     /// @param ipfsCID_ - the IPFS cid for the new token
2414     function _mintArtwork(
2415         uint256 artworkID_,
2416         uint256 editionNumber_,
2417         address artist_,
2418         address owner_,
2419         string memory ipfsCID_
2420     ) private {
2421         /// @notice the edition size is not set implies the artwork is not created
2422         require(
2423             artworks[artworkID_].editionSize > 0,
2424             "FeralfileExhibitionV3: artwork is not found"
2425         );
2426         /// @notice The range of editionNumber should be between 0 to artwork.editionSize + artwork.AEAmount + artwork.PPAmount - 1
2427         require(
2428             editionNumber_ <
2429                 artworks[artworkID_].editionSize +
2430                     artworks[artworkID_].AEAmount +
2431                     artworks[artworkID_].PPAmount,
2432             "FeralfileExhibitionV3: edition number exceed the edition size of the artwork"
2433         );
2434         require(artist_ != address(0), "invalid artist address");
2435         require(owner_ != address(0), "invalid owner address");
2436         require(!registeredIPFSCIDs[ipfsCID_], "ipfs id has registered");
2437 
2438         uint256 editionID = artworkID_ + editionNumber_;
2439         require(
2440             artworkEditions[editionID].editionID == 0,
2441             "FeralfileExhibitionV3: the edition is existent"
2442         );
2443 
2444         ArtworkEdition memory edition = ArtworkEdition(editionID, ipfsCID_);
2445 
2446         artworkEditions[editionID] = edition;
2447         allArtworkEditions[artworkID_].push(editionID);
2448         allArtworkEditionsIndex[editionID] = ArtworkEditionIndex(
2449             artworkID_,
2450             allArtworkEditions[artworkID_].length - 1
2451         );
2452 
2453         registeredIPFSCIDs[ipfsCID_] = true;
2454 
2455         _safeMint(artist_, editionID);
2456 
2457         if (artist_ != owner_) {
2458             _safeTransfer(artist_, owner_, editionID, "");
2459         }
2460 
2461         emit NewArtworkEdition(owner_, artworkID_, editionID);
2462     }
2463 
2464     /// @notice remove an edition from allArtworkEditions
2465     /// @param editionID - the edition id where we are going to remove from allArtworkEditions
2466     function _removeEditionFromAllArtworkEditions(uint256 editionID) private {
2467         ArtworkEditionIndex
2468             memory artworkEditionIndex = allArtworkEditionsIndex[editionID];
2469 
2470         require(
2471             artworkEditionIndex.artworkID > 0,
2472             "FeralfileExhibitionV3: artworkID is no found for the artworkEditionIndex"
2473         );
2474 
2475         uint256[] storage artworkEditions_ = allArtworkEditions[
2476             artworkEditionIndex.artworkID
2477         ];
2478 
2479         require(
2480             artworkEditions_.length > 0,
2481             "FeralfileExhibitionV3: no editions in this artwork of allArtworkEditions"
2482         );
2483 
2484         uint256 lastEditionIndex = artworkEditions_.length - 1;
2485         uint256 lastEditionID = artworkEditions_[artworkEditions_.length - 1];
2486 
2487         // Swap between the last token and the to-delete token and pop up the last token
2488         artworkEditions_[artworkEditionIndex.index] = lastEditionID;
2489         artworkEditions_[lastEditionIndex] = artworkEditionIndex.index;
2490         artworkEditions_.pop();
2491 
2492         delete allArtworkEditionsIndex[editionID];
2493     }
2494 
2495     /// @notice burn editions
2496     /// @param editionIDs_ - the list of edition id will be burned
2497     function burnEditions(uint256[] memory editionIDs_) public {
2498         require(isBurnable, "FeralfileExhibitionV3: not allow burn edition");
2499 
2500         for (uint256 i = 0; i < editionIDs_.length; i++) {
2501             require(
2502                 _exists(editionIDs_[i]),
2503                 "ERC721: artwork edition is not found"
2504             );
2505             require(
2506                 _isApprovedOrOwner(_msgSender(), editionIDs_[i]),
2507                 "ERC721: caller is not token owner nor approved"
2508             );
2509             ArtworkEdition memory edition = artworkEditions[editionIDs_[i]];
2510 
2511             delete registeredIPFSCIDs[edition.ipfsCID];
2512             delete artworkEditions[editionIDs_[i]];
2513 
2514             _removeEditionFromAllArtworkEditions(editionIDs_[i]);
2515 
2516             _burn(editionIDs_[i]);
2517 
2518             emit BurnArtworkEdition(editionIDs_[i]);
2519         }
2520     }
2521 
2522     event NewArtwork(uint256 indexed artworkID);
2523     event NewArtworkEdition(
2524         address indexed owner,
2525         uint256 indexed artworkID,
2526         uint256 indexed editionID
2527     );
2528     event BurnArtworkEdition(uint256 indexed editionID);
2529 }