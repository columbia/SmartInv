1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _transferOwnership(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _transferOwnership(newOwner);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Internal function without access restriction.
89      */
90     function _transferOwnership(address newOwner) internal virtual {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Contract module that helps prevent reentrant calls to a function.
101  *
102  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
103  * available, which can be applied to functions to make sure there are no nested
104  * (reentrant) calls to them.
105  *
106  * Note that because there is a single `nonReentrant` guard, functions marked as
107  * `nonReentrant` may not call one another. This can be worked around by making
108  * those functions `private`, and then adding `external` `nonReentrant` entry
109  * points to them.
110  *
111  * TIP: If you would like to learn more about reentrancy and alternative ways
112  * to protect against it, check out our blog post
113  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
114  */
115 abstract contract ReentrancyGuard {
116     // Booleans are more expensive than uint256 or any type that takes up a full
117     // word because each write operation emits an extra SLOAD to first read the
118     // slot's contents, replace the bits taken up by the boolean, and then write
119     // back. This is the compiler's defense against contract upgrades and
120     // pointer aliasing, and it cannot be disabled.
121 
122     // The values being non-zero value makes deployment a bit more expensive,
123     // but in exchange the refund on every call to nonReentrant will be lower in
124     // amount. Since refunds are capped to a percentage of the total
125     // transaction's gas, it is best to keep them low in cases like this one, to
126     // increase the likelihood of the full refund coming into effect.
127     uint256 private constant _NOT_ENTERED = 1;
128     uint256 private constant _ENTERED = 2;
129 
130     uint256 private _status;
131 
132     constructor() {
133         _status = _NOT_ENTERED;
134     }
135 
136     /**
137      * @dev Prevents a contract from calling itself, directly or indirectly.
138      * Calling a `nonReentrant` function from another `nonReentrant`
139      * function is not supported. It is possible to prevent this from happening
140      * by making the `nonReentrant` function external, and making it call a
141      * `private` function that does the actual work.
142      */
143     modifier nonReentrant() {
144         // On the first call to nonReentrant, _notEntered will be true
145         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
146 
147         // Any calls to nonReentrant after this point will fail
148         _status = _ENTERED;
149 
150         _;
151 
152         // By storing the original value once again, a refund is triggered (see
153         // https://eips.ethereum.org/EIPS/eip-2200)
154         _status = _NOT_ENTERED;
155     }
156 }
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev String operations.
162  */
163 library Strings {
164     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
168      */
169     function toString(uint256 value) internal pure returns (string memory) {
170         // Inspired by OraclizeAPI's implementation - MIT licence
171         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
172 
173         if (value == 0) {
174             return "0";
175         }
176         uint256 temp = value;
177         uint256 digits;
178         while (temp != 0) {
179             digits++;
180             temp /= 10;
181         }
182         bytes memory buffer = new bytes(digits);
183         while (value != 0) {
184             digits -= 1;
185             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
186             value /= 10;
187         }
188         return string(buffer);
189     }
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
193      */
194     function toHexString(uint256 value) internal pure returns (string memory) {
195         if (value == 0) {
196             return "0x00";
197         }
198         uint256 temp = value;
199         uint256 length = 0;
200         while (temp != 0) {
201             length++;
202             temp >>= 8;
203         }
204         return toHexString(value, length);
205     }
206 
207     /**
208      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
209      */
210     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
211         bytes memory buffer = new bytes(2 * length + 2);
212         buffer[0] = "0";
213         buffer[1] = "x";
214         for (uint256 i = 2 * length + 1; i > 1; --i) {
215             buffer[i] = _HEX_SYMBOLS[value & 0xf];
216             value >>= 4;
217         }
218         require(value == 0, "Strings: hex length insufficient");
219         return string(buffer);
220     }
221 }
222 
223 pragma solidity ^0.8.1;
224 
225 /**
226  * @dev Collection of functions related to the address type
227  */
228 library Address {
229     /**
230      * @dev Returns true if `account` is a contract.
231      *
232      * [IMPORTANT]
233      * ====
234      * It is unsafe to assume that an address for which this function returns
235      * false is an externally-owned account (EOA) and not a contract.
236      *
237      * Among others, `isContract` will return false for the following
238      * types of addresses:
239      *
240      *  - an externally-owned account
241      *  - a contract in construction
242      *  - an address where a contract will be created
243      *  - an address where a contract lived, but was destroyed
244      * ====
245      *
246      * [IMPORTANT]
247      * ====
248      * You shouldn't rely on `isContract` to protect against flash loan attacks!
249      *
250      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
251      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
252      * constructor.
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize/address.code.length, which returns 0
257         // for contracts in construction, since the code is only stored at the end
258         // of the constructor execution.
259 
260         return account.code.length > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev Interface of the ERC165 standard, as defined in the
447  * https://eips.ethereum.org/EIPS/eip-165[EIP].
448  *
449  * Implementers can declare support of contract interfaces, which can then be
450  * queried by others ({ERC165Checker}).
451  *
452  * For an implementation, see {ERC165}.
453  */
454 interface IERC165 {
455     /**
456      * @dev Returns true if this contract implements the interface defined by
457      * `interfaceId`. See the corresponding
458      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
459      * to learn more about how these ids are created.
460      *
461      * This function call must use less than 30 000 gas.
462      */
463     function supportsInterface(bytes4 interfaceId) external view returns (bool);
464 }
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Required interface of an ERC721 compliant contract.
470  */
471 interface IERC721 is IERC165 {
472     /**
473      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
474      */
475     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
476 
477     /**
478      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
479      */
480     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
481 
482     /**
483      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
484      */
485     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
486 
487     /**
488      * @dev Returns the number of tokens in ``owner``'s account.
489      */
490     function balanceOf(address owner) external view returns (uint256 balance);
491 
492     /**
493      * @dev Returns the owner of the `tokenId` token.
494      *
495      * Requirements:
496      *
497      * - `tokenId` must exist.
498      */
499     function ownerOf(uint256 tokenId) external view returns (address owner);
500 
501     /**
502      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
503      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     /**
522      * @dev Transfers `tokenId` token from `from` to `to`.
523      *
524      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must be owned by `from`.
531      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
532      *
533      * Emits a {Transfer} event.
534      */
535     function transferFrom(
536         address from,
537         address to,
538         uint256 tokenId
539     ) external;
540 
541     /**
542      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
543      * The approval is cleared when the token is transferred.
544      *
545      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
546      *
547      * Requirements:
548      *
549      * - The caller must own the token or be an approved operator.
550      * - `tokenId` must exist.
551      *
552      * Emits an {Approval} event.
553      */
554     function approve(address to, uint256 tokenId) external;
555 
556     /**
557      * @dev Returns the account approved for `tokenId` token.
558      *
559      * Requirements:
560      *
561      * - `tokenId` must exist.
562      */
563     function getApproved(uint256 tokenId) external view returns (address operator);
564 
565     /**
566      * @dev Approve or remove `operator` as an operator for the caller.
567      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
568      *
569      * Requirements:
570      *
571      * - The `operator` cannot be the caller.
572      *
573      * Emits an {ApprovalForAll} event.
574      */
575     function setApprovalForAll(address operator, bool _approved) external;
576 
577     /**
578      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
579      *
580      * See {setApprovalForAll}
581      */
582     function isApprovedForAll(address owner, address operator) external view returns (bool);
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(
598         address from,
599         address to,
600         uint256 tokenId,
601         bytes calldata data
602     ) external;
603 }
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @title ERC721 token receiver interface
609  * @dev Interface for any contract that wants to support safeTransfers
610  * from ERC721 asset contracts.
611  */
612 interface IERC721Receiver {
613     /**
614      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
615      * by `operator` from `from`, this function is called.
616      *
617      * It must return its Solidity selector to confirm the token transfer.
618      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
619      *
620      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
621      */
622     function onERC721Received(
623         address operator,
624         address from,
625         uint256 tokenId,
626         bytes calldata data
627     ) external returns (bytes4);
628 }
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
634  * @dev See https://eips.ethereum.org/EIPS/eip-721
635  */
636 interface IERC721Metadata is IERC721 {
637     /**
638      * @dev Returns the token collection name.
639      */
640     function name() external view returns (string memory);
641 
642     /**
643      * @dev Returns the token collection symbol.
644      */
645     function symbol() external view returns (string memory);
646 
647     /**
648      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
649      */
650     function tokenURI(uint256 tokenId) external view returns (string memory);
651 }
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
657  * @dev See https://eips.ethereum.org/EIPS/eip-721
658  */
659 interface IERC721Enumerable is IERC721 {
660     /**
661      * @dev Returns the total amount of tokens stored by the contract.
662      */
663     function totalSupply() external view returns (uint256);
664 
665     /**
666      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
667      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
668      */
669     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
670 
671     /**
672      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
673      * Use along with {totalSupply} to enumerate all tokens.
674      */
675     function tokenByIndex(uint256 index) external view returns (uint256);
676 }
677 
678 pragma solidity ^0.8.0;
679 
680 /**
681  * @dev Implementation of the {IERC165} interface.
682  *
683  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
684  * for the additional interface id that will be supported. For example:
685  *
686  * ```solidity
687  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
689  * }
690  * ```
691  *
692  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
693  */
694 abstract contract ERC165 is IERC165 {
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699         return interfaceId == type(IERC165).interfaceId;
700     }
701 }
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
707  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
708  *
709  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
710  *
711  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
712  *
713  * Does not support burning tokens to address(0).
714  */
715 contract ERC721A is
716   Context,
717   ERC165,
718   IERC721,
719   IERC721Metadata,
720   IERC721Enumerable
721 {
722   using Address for address;
723   using Strings for uint256;
724 
725   struct TokenOwnership {
726     address addr;
727     uint64 startTimestamp;
728   }
729 
730   struct AddressData {
731     uint128 balance;
732     uint128 numberMinted;
733   }
734 
735   uint256 private currentIndex = 0;
736 
737   uint256 internal immutable collectionSize;
738   uint256 internal immutable maxBatchSize;
739 
740   // Token name
741   string private _name;
742 
743   // Token symbol
744   string private _symbol;
745 
746   // Mapping from token ID to ownership details
747   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
748   mapping(uint256 => TokenOwnership) private _ownerships;
749 
750   // Mapping owner address to address data
751   mapping(address => AddressData) private _addressData;
752 
753   // Mapping from token ID to approved address
754   mapping(uint256 => address) private _tokenApprovals;
755 
756   // Mapping from owner to operator approvals
757   mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759   /**
760    * @dev
761    * `maxBatchSize` refers to how much a minter can mint at a time.
762    * `collectionSize_` refers to how many tokens are in the collection.
763    */
764   constructor(
765     string memory name_,
766     string memory symbol_,
767     uint256 maxBatchSize_,
768     uint256 collectionSize_
769   ) {
770     require(
771       collectionSize_ > 0,
772       "ERC721A: collection must have a nonzero supply"
773     );
774     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
775     _name = name_;
776     _symbol = symbol_;
777     maxBatchSize = maxBatchSize_;
778     collectionSize = collectionSize_;
779   }
780 
781   /**
782    * @dev See {IERC721Enumerable-totalSupply}.
783    */
784   function totalSupply() public view override returns (uint256) {
785     return currentIndex;
786   }
787 
788   /**
789    * @dev See {IERC721Enumerable-tokenByIndex}.
790    */
791   function tokenByIndex(uint256 index) public view override returns (uint256) {
792     require(index < totalSupply(), "ERC721A: global index out of bounds");
793     return index;
794   }
795 
796   /**
797    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
798    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
799    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
800    */
801   function tokenOfOwnerByIndex(address owner, uint256 index)
802     public
803     view
804     override
805     returns (uint256)
806   {
807     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
808     uint256 numMintedSoFar = totalSupply();
809     uint256 tokenIdsIdx = 0;
810     address currOwnershipAddr = address(0);
811     for (uint256 i = 0; i < numMintedSoFar; i++) {
812       TokenOwnership memory ownership = _ownerships[i];
813       if (ownership.addr != address(0)) {
814         currOwnershipAddr = ownership.addr;
815       }
816       if (currOwnershipAddr == owner) {
817         if (tokenIdsIdx == index) {
818           return i;
819         }
820         tokenIdsIdx++;
821       }
822     }
823     revert("ERC721A: unable to get token of owner by index");
824   }
825 
826   /**
827    * @dev See {IERC165-supportsInterface}.
828    */
829   function supportsInterface(bytes4 interfaceId)
830     public
831     view
832     virtual
833     override(ERC165, IERC165)
834     returns (bool)
835   {
836     return
837       interfaceId == type(IERC721).interfaceId ||
838       interfaceId == type(IERC721Metadata).interfaceId ||
839       interfaceId == type(IERC721Enumerable).interfaceId ||
840       super.supportsInterface(interfaceId);
841   }
842 
843   /**
844    * @dev See {IERC721-balanceOf}.
845    */
846   function balanceOf(address owner) public view override returns (uint256) {
847     require(owner != address(0), "ERC721A: balance query for the zero address");
848     return uint256(_addressData[owner].balance);
849   }
850 
851   function _numberMinted(address owner) internal view returns (uint256) {
852     require(
853       owner != address(0),
854       "ERC721A: number minted query for the zero address"
855     );
856     return uint256(_addressData[owner].numberMinted);
857   }
858 
859   function ownershipOf(uint256 tokenId)
860     internal
861     view
862     returns (TokenOwnership memory)
863   {
864     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
865 
866     uint256 lowestTokenToCheck;
867     if (tokenId >= maxBatchSize) {
868       lowestTokenToCheck = tokenId - maxBatchSize + 1;
869     }
870 
871     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
872       TokenOwnership memory ownership = _ownerships[curr];
873       if (ownership.addr != address(0)) {
874         return ownership;
875       }
876     }
877 
878     revert("ERC721A: unable to determine the owner of token");
879   }
880 
881   /**
882    * @dev See {IERC721-ownerOf}.
883    */
884   function ownerOf(uint256 tokenId) public view override returns (address) {
885     return ownershipOf(tokenId).addr;
886   }
887 
888   /**
889    * @dev See {IERC721Metadata-name}.
890    */
891   function name() public view virtual override returns (string memory) {
892     return _name;
893   }
894 
895   /**
896    * @dev See {IERC721Metadata-symbol}.
897    */
898   function symbol() public view virtual override returns (string memory) {
899     return _symbol;
900   }
901 
902   /**
903    * @dev See {IERC721Metadata-tokenURI}.
904    */
905   function tokenURI(uint256 tokenId)
906     public
907     view
908     virtual
909     override
910     returns (string memory)
911   {
912     require(
913       _exists(tokenId),
914       "ERC721Metadata: URI query for nonexistent token"
915     );
916 
917     string memory baseURI = _baseURI();
918     return
919       bytes(baseURI).length > 0
920         ? string(abi.encodePacked(baseURI, tokenId.toString()))
921         : "";
922   }
923 
924   /**
925    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
926    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
927    * by default, can be overriden in child contracts.
928    */
929   function _baseURI() internal view virtual returns (string memory) {
930     return "";
931   }
932 
933   /**
934    * @dev See {IERC721-approve}.
935    */
936   function approve(address to, uint256 tokenId) public override {
937     address owner = ERC721A.ownerOf(tokenId);
938     require(to != owner, "ERC721A: approval to current owner");
939 
940     require(
941       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
942       "ERC721A: approve caller is not owner nor approved for all"
943     );
944 
945     _approve(to, tokenId, owner);
946   }
947 
948   /**
949    * @dev See {IERC721-getApproved}.
950    */
951   function getApproved(uint256 tokenId) public view override returns (address) {
952     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
953 
954     return _tokenApprovals[tokenId];
955   }
956 
957   /**
958    * @dev See {IERC721-setApprovalForAll}.
959    */
960   function setApprovalForAll(address operator, bool approved) public override {
961     require(operator != _msgSender(), "ERC721A: approve to caller");
962 
963     _operatorApprovals[_msgSender()][operator] = approved;
964     emit ApprovalForAll(_msgSender(), operator, approved);
965   }
966 
967   /**
968    * @dev See {IERC721-isApprovedForAll}.
969    */
970   function isApprovedForAll(address owner, address operator)
971     public
972     view
973     virtual
974     override
975     returns (bool)
976   {
977     return _operatorApprovals[owner][operator];
978   }
979 
980   /**
981    * @dev See {IERC721-transferFrom}.
982    */
983   function transferFrom(
984     address from,
985     address to,
986     uint256 tokenId
987   ) public override {
988     _transfer(from, to, tokenId);
989   }
990 
991   /**
992    * @dev See {IERC721-safeTransferFrom}.
993    */
994   function safeTransferFrom(
995     address from,
996     address to,
997     uint256 tokenId
998   ) public override {
999     safeTransferFrom(from, to, tokenId, "");
1000   }
1001 
1002   /**
1003    * @dev See {IERC721-safeTransferFrom}.
1004    */
1005   function safeTransferFrom(
1006     address from,
1007     address to,
1008     uint256 tokenId,
1009     bytes memory _data
1010   ) public override {
1011     _transfer(from, to, tokenId);
1012     require(
1013       _checkOnERC721Received(from, to, tokenId, _data),
1014       "ERC721A: transfer to non ERC721Receiver implementer"
1015     );
1016   }
1017 
1018   /**
1019    * @dev Returns whether `tokenId` exists.
1020    *
1021    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1022    *
1023    * Tokens start existing when they are minted (`_mint`),
1024    */
1025   function _exists(uint256 tokenId) internal view returns (bool) {
1026     return tokenId < currentIndex;
1027   }
1028 
1029   function _safeMint(address to, uint256 quantity) internal {
1030     _safeMint(to, quantity, "");
1031   }
1032 
1033   /**
1034    * @dev Mints `quantity` tokens and transfers them to `to`.
1035    *
1036    * Requirements:
1037    *
1038    * - there must be `quantity` tokens remaining unminted in the total collection.
1039    * - `to` cannot be the zero address.
1040    * - `quantity` cannot be larger than the max batch size.
1041    *
1042    * Emits a {Transfer} event.
1043    */
1044   function _safeMint(
1045     address to,
1046     uint256 quantity,
1047     bytes memory _data
1048   ) internal {
1049     uint256 startTokenId = currentIndex;
1050     require(to != address(0), "ERC721A: mint to the zero address");
1051     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1052     require(!_exists(startTokenId), "ERC721A: token already minted");
1053     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1054 
1055     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1056 
1057     AddressData memory addressData = _addressData[to];
1058     _addressData[to] = AddressData(
1059       addressData.balance + uint128(quantity),
1060       addressData.numberMinted + uint128(quantity)
1061     );
1062     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1063 
1064     uint256 updatedIndex = startTokenId;
1065 
1066     for (uint256 i = 0; i < quantity; i++) {
1067       emit Transfer(address(0), to, updatedIndex);
1068       require(
1069         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1070         "ERC721A: transfer to non ERC721Receiver implementer"
1071       );
1072       updatedIndex++;
1073     }
1074 
1075     currentIndex = updatedIndex;
1076     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1077   }
1078 
1079   /**
1080    * @dev Transfers `tokenId` from `from` to `to`.
1081    *
1082    * Requirements:
1083    *
1084    * - `to` cannot be the zero address.
1085    * - `tokenId` token must be owned by `from`.
1086    *
1087    * Emits a {Transfer} event.
1088    */
1089   function _transfer(
1090     address from,
1091     address to,
1092     uint256 tokenId
1093   ) private {
1094     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1095 
1096     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1097       getApproved(tokenId) == _msgSender() ||
1098       isApprovedForAll(prevOwnership.addr, _msgSender()));
1099 
1100     require(
1101       isApprovedOrOwner,
1102       "ERC721A: transfer caller is not owner nor approved"
1103     );
1104 
1105     require(
1106       prevOwnership.addr == from,
1107       "ERC721A: transfer from incorrect owner"
1108     );
1109     require(to != address(0), "ERC721A: transfer to the zero address");
1110 
1111     _beforeTokenTransfers(from, to, tokenId, 1);
1112 
1113     // Clear approvals from the previous owner
1114     _approve(address(0), tokenId, prevOwnership.addr);
1115 
1116     _addressData[from].balance -= 1;
1117     _addressData[to].balance += 1;
1118     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1119 
1120     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1121     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1122     uint256 nextTokenId = tokenId + 1;
1123     if (_ownerships[nextTokenId].addr == address(0)) {
1124       if (_exists(nextTokenId)) {
1125         _ownerships[nextTokenId] = TokenOwnership(
1126           prevOwnership.addr,
1127           prevOwnership.startTimestamp
1128         );
1129       }
1130     }
1131 
1132     emit Transfer(from, to, tokenId);
1133     _afterTokenTransfers(from, to, tokenId, 1);
1134   }
1135 
1136   /**
1137    * @dev Approve `to` to operate on `tokenId`
1138    *
1139    * Emits a {Approval} event.
1140    */
1141   function _approve(
1142     address to,
1143     uint256 tokenId,
1144     address owner
1145   ) private {
1146     _tokenApprovals[tokenId] = to;
1147     emit Approval(owner, to, tokenId);
1148   }
1149 
1150   uint256 public nextOwnerToExplicitlySet = 0;
1151 
1152   /**
1153    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1154    */
1155   function _setOwnersExplicit(uint256 quantity) internal {
1156     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1157     require(quantity > 0, "quantity must be nonzero");
1158     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1159     if (endIndex > collectionSize - 1) {
1160       endIndex = collectionSize - 1;
1161     }
1162     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1163     require(_exists(endIndex), "not enough minted yet for this cleanup");
1164     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1165       if (_ownerships[i].addr == address(0)) {
1166         TokenOwnership memory ownership = ownershipOf(i);
1167         _ownerships[i] = TokenOwnership(
1168           ownership.addr,
1169           ownership.startTimestamp
1170         );
1171       }
1172     }
1173     nextOwnerToExplicitlySet = endIndex + 1;
1174   }
1175 
1176   /**
1177    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1178    * The call is not executed if the target address is not a contract.
1179    *
1180    * @param from address representing the previous owner of the given token ID
1181    * @param to target address that will receive the tokens
1182    * @param tokenId uint256 ID of the token to be transferred
1183    * @param _data bytes optional data to send along with the call
1184    * @return bool whether the call correctly returned the expected magic value
1185    */
1186   function _checkOnERC721Received(
1187     address from,
1188     address to,
1189     uint256 tokenId,
1190     bytes memory _data
1191   ) private returns (bool) {
1192     if (to.isContract()) {
1193       try
1194         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1195       returns (bytes4 retval) {
1196         return retval == IERC721Receiver(to).onERC721Received.selector;
1197       } catch (bytes memory reason) {
1198         if (reason.length == 0) {
1199           revert("ERC721A: transfer to non ERC721Receiver implementer");
1200         } else {
1201           assembly {
1202             revert(add(32, reason), mload(reason))
1203           }
1204         }
1205       }
1206     } else {
1207       return true;
1208     }
1209   }
1210 
1211   /**
1212    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1213    *
1214    * startTokenId - the first token id to be transferred
1215    * quantity - the amount to be transferred
1216    *
1217    * Calling conditions:
1218    *
1219    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1220    * transferred to `to`.
1221    * - When `from` is zero, `tokenId` will be minted for `to`.
1222    */
1223   function _beforeTokenTransfers(
1224     address from,
1225     address to,
1226     uint256 startTokenId,
1227     uint256 quantity
1228   ) internal virtual {}
1229 
1230   /**
1231    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1232    * minting.
1233    *
1234    * startTokenId - the first token id to be transferred
1235    * quantity - the amount to be transferred
1236    *
1237    * Calling conditions:
1238    *
1239    * - when `from` and `to` are both non-zero.
1240    * - `from` and `to` are never both zero.
1241    */
1242   function _afterTokenTransfers(
1243     address from,
1244     address to,
1245     uint256 startTokenId,
1246     uint256 quantity
1247   ) internal virtual {}
1248 }
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 
1253   
1254 
1255 contract GamersGuild is Ownable, ERC721A, ReentrancyGuard {
1256   uint256 public immutable maxPerAddressDuringMint;
1257   uint256 public immutable amountForDevs;
1258   uint256 public immutable amountForAuctionAndDev;
1259 
1260   struct SaleConfig {
1261     uint32 auctionSaleStartTime;
1262     uint32 publicSaleStartTime;
1263     uint64 mintlistPrice;
1264     uint64 publicPrice;
1265     uint32 publicSaleKey;
1266   }
1267 
1268   SaleConfig public saleConfig;
1269 
1270   mapping(address => uint256) public allowlist;
1271 
1272   constructor(
1273     uint256 maxBatchSize_,
1274     uint256 collectionSize_,
1275     uint256 amountForAuctionAndDev_,
1276     uint256 amountForDevs_
1277   ) ERC721A("GamersGuild", "GGE", maxBatchSize_, collectionSize_) {
1278     maxPerAddressDuringMint = maxBatchSize_;
1279     amountForAuctionAndDev = amountForAuctionAndDev_;
1280     amountForDevs = amountForDevs_;
1281     require(
1282       amountForAuctionAndDev_ <= collectionSize_,
1283       "larger collection size needed"
1284     );
1285   }
1286 
1287   modifier callerIsUser() {
1288     require(tx.origin == msg.sender, "The caller is another contract");
1289     _;
1290   }
1291 
1292 
1293   function allowlistMint() external payable callerIsUser {
1294     uint256 price = uint256(saleConfig.mintlistPrice);
1295     require(price != 0, "allowlist sale has not begun yet");
1296     require(allowlist[msg.sender] > 0, "not eligible for allowlist mint");
1297     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1298     allowlist[msg.sender]--;
1299     _safeMint(msg.sender, 1);
1300     refundIfOver(price);
1301   }
1302 
1303 
1304  function setSaleInfo(
1305     uint64 mintlistPriceWei,
1306     uint64 publicPriceWei,
1307     uint32 publicSaleStartTime
1308   ) external onlyOwner {
1309     saleConfig = SaleConfig(
1310       0,
1311       publicSaleStartTime,
1312       mintlistPriceWei,
1313       publicPriceWei,
1314       saleConfig.publicSaleKey
1315     );}
1316 
1317   function publicSaleMint(uint256 quantity, uint256 callerPublicSaleKey)
1318     external
1319     payable
1320     callerIsUser
1321   {
1322     SaleConfig memory config = saleConfig;
1323     uint256 publicSaleKey = uint256(config.publicSaleKey);
1324     uint256 publicPrice = uint256(config.publicPrice);
1325     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1326     require(
1327       publicSaleKey == callerPublicSaleKey,
1328       "called with incorrect public sale key"
1329     );
1330 
1331     require(
1332       isPublicSaleOn(publicPrice, publicSaleKey, publicSaleStartTime),
1333       "public sale has not begun yet"
1334     );
1335     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1336     require(
1337       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1338       "can not mint this many"
1339     );
1340     _safeMint(msg.sender, quantity);
1341     refundIfOver(publicPrice * quantity);
1342   }
1343 
1344   function refundIfOver(uint256 price) private {
1345     require(msg.value >= price, "Need to send more ETH.");
1346     if (msg.value > price) {
1347       payable(msg.sender).transfer(msg.value - price);
1348     }
1349   }
1350 
1351   function isPublicSaleOn(
1352     uint256 publicPriceWei,
1353     uint256 publicSaleKey,
1354     uint256 publicSaleStartTime
1355   ) public view returns (bool) {
1356     return
1357       publicPriceWei != 0 &&
1358       publicSaleKey != 0 &&
1359       block.timestamp >= publicSaleStartTime;
1360   }
1361 
1362 
1363   function setPublicSaleKey(uint32 key) external onlyOwner {
1364     saleConfig.publicSaleKey = key;
1365   }
1366 
1367   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1368     external
1369     onlyOwner
1370   {
1371     require(
1372       addresses.length == numSlots.length,
1373       "addresses does not match numSlots length"
1374     );
1375     for (uint256 i = 0; i < addresses.length; i++) {
1376       allowlist[addresses[i]] = numSlots[i];
1377     }
1378   }
1379 
1380   // For marketing etc.
1381   function devMint(uint256 quantity) external onlyOwner {
1382     require(
1383       totalSupply() + quantity <= amountForDevs,
1384       "too many already minted before dev mint"
1385     );
1386     require(
1387       quantity % maxBatchSize == 0,
1388       "can only mint a multiple of the maxBatchSize"
1389     );
1390     uint256 numChunks = quantity / maxBatchSize;
1391     for (uint256 i = 0; i < numChunks; i++) {
1392       _safeMint(msg.sender, maxBatchSize);
1393     }
1394   }
1395 
1396   // // metadata URI
1397   string private _baseTokenURI;
1398 
1399   function _baseURI() internal view virtual override returns (string memory) {
1400     return _baseTokenURI;
1401   }
1402 
1403   function setBaseURI(string calldata baseURI) external onlyOwner {
1404     _baseTokenURI = baseURI;
1405   }
1406 
1407   function withdrawMoney() external onlyOwner nonReentrant {
1408     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1409     require(success, "Transfer failed.");
1410   }
1411 
1412   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1413     _setOwnersExplicit(quantity);
1414   }
1415 
1416   function numberMinted(address owner) public view returns (uint256) {
1417     return _numberMinted(owner);
1418   }
1419 
1420   function getOwnershipData(uint256 tokenId)
1421     external
1422     view
1423     returns (TokenOwnership memory)
1424   {
1425     return ownershipOf(tokenId);
1426   }
1427 }