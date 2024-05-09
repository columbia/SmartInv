1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-23
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Context.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/access/Ownable.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
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
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Address.sol
181 
182 
183 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
184 
185 pragma solidity ^0.8.1;
186 
187 /**
188  * @dev Collection of functions related to the address type
189  */
190 library Address {
191     /**
192      * @dev Returns true if `account` is a contract.
193      *
194      * [IMPORTANT]
195      * ====
196      * It is unsafe to assume that an address for which this function returns
197      * false is an externally-owned account (EOA) and not a contract.
198      *
199      * Among others, `isContract` will return false for the following
200      * types of addresses:
201      *
202      *  - an externally-owned account
203      *  - a contract in construction
204      *  - an address where a contract will be created
205      *  - an address where a contract lived, but was destroyed
206      * ====
207      *
208      * [IMPORTANT]
209      * ====
210      * You shouldn't rely on `isContract` to protect against flash loan attacks!
211      *
212      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
213      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
214      * constructor.
215      * ====
216      */
217     function isContract(address account) internal view returns (bool) {
218         // This method relies on extcodesize/address.code.length, which returns 0
219         // for contracts in construction, since the code is only stored at the end
220         // of the constructor execution.
221 
222         return account.code.length > 0;
223     }
224 
225     /**
226      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
227      * `recipient`, forwarding all available gas and reverting on errors.
228      *
229      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
230      * of certain opcodes, possibly making contracts go over the 2300 gas limit
231      * imposed by `transfer`, making them unable to receive funds via
232      * `transfer`. {sendValue} removes this limitation.
233      *
234      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
235      *
236      * IMPORTANT: because control is transferred to `recipient`, care must be
237      * taken to not create reentrancy vulnerabilities. Consider using
238      * {ReentrancyGuard} or the
239      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
240      */
241     function sendValue(address payable recipient, uint256 amount) internal {
242         require(address(this).balance >= amount, "Address: insufficient balance");
243 
244         (bool success, ) = recipient.call{value: amount}("");
245         require(success, "Address: unable to send value, recipient may have reverted");
246     }
247 
248     /**
249      * @dev Performs a Solidity function call using a low level `call`. A
250      * plain `call` is an unsafe replacement for a function call: use this
251      * function instead.
252      *
253      * If `target` reverts with a revert reason, it is bubbled up by this
254      * function (like regular Solidity function calls).
255      *
256      * Returns the raw returned data. To convert to the expected return value,
257      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
258      *
259      * Requirements:
260      *
261      * - `target` must be a contract.
262      * - calling `target` with `data` must not revert.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionCall(target, data, "Address: low-level call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
272      * `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, 0, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but also transferring `value` wei to `target`.
287      *
288      * Requirements:
289      *
290      * - the calling contract must have an ETH balance of at least `value`.
291      * - the called Solidity function must be `payable`.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value
299     ) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
305      * with `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(address(this).balance >= value, "Address: insufficient balance for call");
316         require(isContract(target), "Address: call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.call{value: value}(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
329         return functionStaticCall(target, data, "Address: low-level static call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal view returns (bytes memory) {
343         require(isContract(target), "Address: static call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.staticcall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         require(isContract(target), "Address: delegate call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.delegatecall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
378      * revert reason using the provided one.
379      *
380      * _Available since v4.3._
381      */
382     function verifyCallResult(
383         bool success,
384         bytes memory returndata,
385         string memory errorMessage
386     ) internal pure returns (bytes memory) {
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @title ERC721 token receiver interface
414  * @dev Interface for any contract that wants to support safeTransfers
415  * from ERC721 asset contracts.
416  */
417 interface IERC721Receiver {
418     /**
419      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
420      * by `operator` from `from`, this function is called.
421      *
422      * It must return its Solidity selector to confirm the token transfer.
423      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
424      *
425      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
426      */
427     function onERC721Received(
428         address operator,
429         address from,
430         uint256 tokenId,
431         bytes calldata data
432     ) external returns (bytes4);
433 }
434 
435 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Interface of the ERC165 standard, as defined in the
444  * https://eips.ethereum.org/EIPS/eip-165[EIP].
445  *
446  * Implementers can declare support of contract interfaces, which can then be
447  * queried by others ({ERC165Checker}).
448  *
449  * For an implementation, see {ERC165}.
450  */
451 interface IERC165 {
452     /**
453      * @dev Returns true if this contract implements the interface defined by
454      * `interfaceId`. See the corresponding
455      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
456      * to learn more about how these ids are created.
457      *
458      * This function call must use less than 30 000 gas.
459      */
460     function supportsInterface(bytes4 interfaceId) external view returns (bool);
461 }
462 
463 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 
471 /**
472  * @dev Implementation of the {IERC165} interface.
473  *
474  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
475  * for the additional interface id that will be supported. For example:
476  *
477  * ```solidity
478  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
480  * }
481  * ```
482  *
483  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
484  */
485 abstract contract ERC165 is IERC165 {
486     /**
487      * @dev See {IERC165-supportsInterface}.
488      */
489     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490         return interfaceId == type(IERC165).interfaceId;
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 
502 /**
503  * @dev Required interface of an ERC721 compliant contract.
504  */
505 interface IERC721 is IERC165 {
506     /**
507      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
508      */
509     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
510 
511     /**
512      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
513      */
514     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
515 
516     /**
517      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
518      */
519     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
520 
521     /**
522      * @dev Returns the number of tokens in ``owner``'s account.
523      */
524     function balanceOf(address owner) external view returns (uint256 balance);
525 
526     /**
527      * @dev Returns the owner of the `tokenId` token.
528      *
529      * Requirements:
530      *
531      * - `tokenId` must exist.
532      */
533     function ownerOf(uint256 tokenId) external view returns (address owner);
534 
535     /**
536      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
537      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must exist and be owned by `from`.
544      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
546      *
547      * Emits a {Transfer} event.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 tokenId
553     ) external;
554 
555     /**
556      * @dev Transfers `tokenId` token from `from` to `to`.
557      *
558      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must be owned by `from`.
565      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
566      *
567      * Emits a {Transfer} event.
568      */
569     function transferFrom(
570         address from,
571         address to,
572         uint256 tokenId
573     ) external;
574 
575     /**
576      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
577      * The approval is cleared when the token is transferred.
578      *
579      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
580      *
581      * Requirements:
582      *
583      * - The caller must own the token or be an approved operator.
584      * - `tokenId` must exist.
585      *
586      * Emits an {Approval} event.
587      */
588     function approve(address to, uint256 tokenId) external;
589 
590     /**
591      * @dev Returns the account approved for `tokenId` token.
592      *
593      * Requirements:
594      *
595      * - `tokenId` must exist.
596      */
597     function getApproved(uint256 tokenId) external view returns (address operator);
598 
599     /**
600      * @dev Approve or remove `operator` as an operator for the caller.
601      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
602      *
603      * Requirements:
604      *
605      * - The `operator` cannot be the caller.
606      *
607      * Emits an {ApprovalForAll} event.
608      */
609     function setApprovalForAll(address operator, bool _approved) external;
610 
611     /**
612      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
613      *
614      * See {setApprovalForAll}
615      */
616     function isApprovedForAll(address owner, address operator) external view returns (bool);
617 
618     /**
619      * @dev Safely transfers `tokenId` token from `from` to `to`.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must exist and be owned by `from`.
626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 tokenId,
635         bytes calldata data
636     ) external;
637 }
638 
639 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
649  * @dev See https://eips.ethereum.org/EIPS/eip-721
650  */
651 interface IERC721Enumerable is IERC721 {
652     /**
653      * @dev Returns the total amount of tokens stored by the contract.
654      */
655     function totalSupply() external view returns (uint256);
656 
657     /**
658      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
659      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
660      */
661     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
662 
663     /**
664      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
665      * Use along with {totalSupply} to enumerate all tokens.
666      */
667     function tokenByIndex(uint256 index) external view returns (uint256);
668 }
669 
670 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 
678 /**
679  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
680  * @dev See https://eips.ethereum.org/EIPS/eip-721
681  */
682 interface IERC721Metadata is IERC721 {
683     /**
684      * @dev Returns the token collection name.
685      */
686     function name() external view returns (string memory);
687 
688     /**
689      * @dev Returns the token collection symbol.
690      */
691     function symbol() external view returns (string memory);
692 
693     /**
694      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
695      */
696     function tokenURI(uint256 tokenId) external view returns (string memory);
697 }
698 
699 // File: erc721a/contracts/ERC721A.sol
700 
701 
702 // Creator: Chiru Labs
703 
704 pragma solidity ^0.8.4;
705 
706 
707 
708 
709 
710 
711 
712 
713 
714 error ApprovalCallerNotOwnerNorApproved();
715 error ApprovalQueryForNonexistentToken();
716 error ApproveToCaller();
717 error ApprovalToCurrentOwner();
718 error BalanceQueryForZeroAddress();
719 error MintedQueryForZeroAddress();
720 error BurnedQueryForZeroAddress();
721 error MintToZeroAddress();
722 error MintZeroQuantity();
723 error OwnerIndexOutOfBounds();
724 error OwnerQueryForNonexistentToken();
725 error TokenIndexOutOfBounds();
726 error TransferCallerNotOwnerNorApproved();
727 error TransferFromIncorrectOwner();
728 error TransferToNonERC721ReceiverImplementer();
729 error TransferToZeroAddress();
730 error URIQueryForNonexistentToken();
731 
732 /**
733  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
734  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
735  *
736  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
737  *
738  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
739  *
740  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
741  */
742 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
743     using Address for address;
744     using Strings for uint256;
745 
746     // Compiler will pack this into a single 256bit word.
747     struct TokenOwnership {
748         // The address of the owner.
749         address addr;
750         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
751         uint64 startTimestamp;
752         // Whether the token has been burned.
753         bool burned;
754     }
755 
756     // Compiler will pack this into a single 256bit word.
757     struct AddressData {
758         // Realistically, 2**64-1 is more than enough.
759         uint64 balance;
760         // Keeps track of mint count with minimal overhead for tokenomics.
761         uint64 numberMinted;
762         // Keeps track of burn count with minimal overhead for tokenomics.
763         uint64 numberBurned;
764     }
765 
766     // Compiler will pack the following 
767     // _currentIndex and _burnCounter into a single 256bit word.
768     
769     // The tokenId of the next token to be minted.
770     uint128 internal _currentIndex;
771 
772     // The number of tokens burned.
773     uint128 internal _burnCounter;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to ownership details
782     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
783     mapping(uint256 => TokenOwnership) internal _ownerships;
784 
785     // Mapping owner address to address data
786     mapping(address => AddressData) private _addressData;
787 
788     // Mapping from token ID to approved address
789     mapping(uint256 => address) private _tokenApprovals;
790 
791     // Mapping from owner to operator approvals
792     mapping(address => mapping(address => bool)) private _operatorApprovals;
793 
794     constructor(string memory name_, string memory symbol_) {
795         _name = name_;
796         _symbol = symbol_;
797     }
798 
799     /**
800      * @dev See {IERC721Enumerable-totalSupply}.
801      */
802     function totalSupply() public view override returns (uint256) {
803         // Counter underflow is impossible as _burnCounter cannot be incremented
804         // more than _currentIndex times
805         unchecked {
806             return _currentIndex - _burnCounter;    
807         }
808     }
809 
810     /**
811      * @dev See {IERC721Enumerable-tokenByIndex}.
812      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
813      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
814      */
815     function tokenByIndex(uint256 index) public view override returns (uint256) {
816         uint256 numMintedSoFar = _currentIndex;
817         uint256 tokenIdsIdx;
818 
819         // Counter overflow is impossible as the loop breaks when
820         // uint256 i is equal to another uint256 numMintedSoFar.
821         unchecked {
822             for (uint256 i; i < numMintedSoFar; i++) {
823                 TokenOwnership memory ownership = _ownerships[i];
824                 if (!ownership.burned) {
825                     if (tokenIdsIdx == index) {
826                         return i;
827                     }
828                     tokenIdsIdx++;
829                 }
830             }
831         }
832         revert TokenIndexOutOfBounds();
833     }
834 
835     /**
836      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
837      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
838      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
839      */
840     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
841         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
842         uint256 numMintedSoFar = _currentIndex;
843         uint256 tokenIdsIdx;
844         address currOwnershipAddr;
845 
846         // Counter overflow is impossible as the loop breaks when
847         // uint256 i is equal to another uint256 numMintedSoFar.
848         unchecked {
849             for (uint256 i; i < numMintedSoFar; i++) {
850                 TokenOwnership memory ownership = _ownerships[i];
851                 if (ownership.burned) {
852                     continue;
853                 }
854                 if (ownership.addr != address(0)) {
855                     currOwnershipAddr = ownership.addr;
856                 }
857                 if (currOwnershipAddr == owner) {
858                     if (tokenIdsIdx == index) {
859                         return i;
860                     }
861                     tokenIdsIdx++;
862                 }
863             }
864         }
865 
866         // Execution should never reach this point.
867         revert();
868     }
869 
870     /**
871      * @dev See {IERC165-supportsInterface}.
872      */
873     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
874         return
875             interfaceId == type(IERC721).interfaceId ||
876             interfaceId == type(IERC721Metadata).interfaceId ||
877             interfaceId == type(IERC721Enumerable).interfaceId ||
878             super.supportsInterface(interfaceId);
879     }
880 
881     /**
882      * @dev See {IERC721-balanceOf}.
883      */
884     function balanceOf(address owner) public view override returns (uint256) {
885         if (owner == address(0)) revert BalanceQueryForZeroAddress();
886         return uint256(_addressData[owner].balance);
887     }
888 
889     function _numberMinted(address owner) internal view returns (uint256) {
890         if (owner == address(0)) revert MintedQueryForZeroAddress();
891         return uint256(_addressData[owner].numberMinted);
892     }
893 
894     function _numberBurned(address owner) internal view returns (uint256) {
895         if (owner == address(0)) revert BurnedQueryForZeroAddress();
896         return uint256(_addressData[owner].numberBurned);
897     }
898 
899     /**
900      * Gas spent here starts off proportional to the maximum mint batch size.
901      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
902      */
903     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
904         uint256 curr = tokenId;
905 
906         unchecked {
907             if (curr < _currentIndex) {
908                 TokenOwnership memory ownership = _ownerships[curr];
909                 if (!ownership.burned) {
910                     if (ownership.addr != address(0)) {
911                         return ownership;
912                     }
913                     // Invariant: 
914                     // There will always be an ownership that has an address and is not burned 
915                     // before an ownership that does not have an address and is not burned.
916                     // Hence, curr will not underflow.
917                     while (true) {
918                         curr--;
919                         ownership = _ownerships[curr];
920                         if (ownership.addr != address(0)) {
921                             return ownership;
922                         }
923                     }
924                 }
925             }
926         }
927         revert OwnerQueryForNonexistentToken();
928     }
929 
930     /**
931      * @dev See {IERC721-ownerOf}.
932      */
933     function ownerOf(uint256 tokenId) public view override returns (address) {
934         return ownershipOf(tokenId).addr;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-name}.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-symbol}.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-tokenURI}.
953      */
954     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
955         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
956 
957         string memory baseURI = _baseURI();
958         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
959     }
960 
961     /**
962      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
963      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
964      * by default, can be overriden in child contracts.
965      */
966     function _baseURI() internal view virtual returns (string memory) {
967         return '';
968     }
969 
970     /**
971      * @dev See {IERC721-approve}.
972      */
973     function approve(address to, uint256 tokenId) public override {
974         address owner = ERC721A.ownerOf(tokenId);
975         if (to == owner) revert ApprovalToCurrentOwner();
976 
977         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
978             revert ApprovalCallerNotOwnerNorApproved();
979         }
980 
981         _approve(to, tokenId, owner);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId) public view override returns (address) {
988         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
989 
990         return _tokenApprovals[tokenId];
991     }
992 
993     /**
994      * @dev See {IERC721-setApprovalForAll}.
995      */
996     function setApprovalForAll(address operator, bool approved) public override {
997         if (operator == _msgSender()) revert ApproveToCaller();
998 
999         _operatorApprovals[_msgSender()][operator] = approved;
1000         emit ApprovalForAll(_msgSender(), operator, approved);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-isApprovedForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1007         return _operatorApprovals[owner][operator];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-transferFrom}.
1012      */
1013     function transferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         _transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         safeTransferFrom(from, to, tokenId, '');
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) public virtual override {
1041         _transfer(from, to, tokenId);
1042         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1043             revert TransferToNonERC721ReceiverImplementer();
1044         }
1045     }
1046 
1047     /**
1048      * @dev Returns whether `tokenId` exists.
1049      *
1050      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051      *
1052      * Tokens start existing when they are minted (`_mint`),
1053      */
1054     function _exists(uint256 tokenId) internal view returns (bool) {
1055         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1056     }
1057 
1058     function _safeMint(address to, uint256 quantity) internal {
1059         _safeMint(to, quantity, '');
1060     }
1061 
1062     /**
1063      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1068      * - `quantity` must be greater than 0.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _safeMint(
1073         address to,
1074         uint256 quantity,
1075         bytes memory _data
1076     ) internal {
1077         _mint(to, quantity, _data, true);
1078     }
1079 
1080     /**
1081      * @dev Mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - `to` cannot be the zero address.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _mint(
1091         address to,
1092         uint256 quantity,
1093         bytes memory _data,
1094         bool safe
1095     ) internal {
1096         uint256 startTokenId = _currentIndex;
1097         if (to == address(0)) revert MintToZeroAddress();
1098         if (quantity == 0) revert MintZeroQuantity();
1099 
1100         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1101 
1102         // Overflows are incredibly unrealistic.
1103         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1104         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1105         unchecked {
1106             _addressData[to].balance += uint64(quantity);
1107             _addressData[to].numberMinted += uint64(quantity);
1108 
1109             _ownerships[startTokenId].addr = to;
1110             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1111 
1112             uint256 updatedIndex = startTokenId;
1113 
1114             for (uint256 i; i < quantity; i++) {
1115                 emit Transfer(address(0), to, updatedIndex);
1116                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1117                     revert TransferToNonERC721ReceiverImplementer();
1118                 }
1119                 updatedIndex++;
1120             }
1121 
1122             _currentIndex = uint128(updatedIndex);
1123         }
1124         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1125     }
1126 
1127     /**
1128      * @dev Transfers `tokenId` from `from` to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - `to` cannot be the zero address.
1133      * - `tokenId` token must be owned by `from`.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _transfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) private {
1142         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1143 
1144         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1145             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1146             getApproved(tokenId) == _msgSender());
1147 
1148         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1149         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1150         if (to == address(0)) revert TransferToZeroAddress();
1151 
1152         _beforeTokenTransfers(from, to, tokenId, 1);
1153 
1154         // Clear approvals from the previous owner
1155         _approve(address(0), tokenId, prevOwnership.addr);
1156 
1157         // Underflow of the sender's balance is impossible because we check for
1158         // ownership above and the recipient's balance can't realistically overflow.
1159         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1160         unchecked {
1161             _addressData[from].balance -= 1;
1162             _addressData[to].balance += 1;
1163 
1164             _ownerships[tokenId].addr = to;
1165             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1166 
1167             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1168             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1169             uint256 nextTokenId = tokenId + 1;
1170             if (_ownerships[nextTokenId].addr == address(0)) {
1171                 // This will suffice for checking _exists(nextTokenId),
1172                 // as a burned slot cannot contain the zero address.
1173                 if (nextTokenId < _currentIndex) {
1174                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1175                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1176                 }
1177             }
1178         }
1179 
1180         emit Transfer(from, to, tokenId);
1181         _afterTokenTransfers(from, to, tokenId, 1);
1182     }
1183 
1184     /**
1185      * @dev Destroys `tokenId`.
1186      * The approval is cleared when the token is burned.
1187      *
1188      * Requirements:
1189      *
1190      * - `tokenId` must exist.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _burn(uint256 tokenId) internal virtual {
1195         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1196 
1197         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1198 
1199         // Clear approvals from the previous owner
1200         _approve(address(0), tokenId, prevOwnership.addr);
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1205         unchecked {
1206             _addressData[prevOwnership.addr].balance -= 1;
1207             _addressData[prevOwnership.addr].numberBurned += 1;
1208 
1209             // Keep track of who burned the token, and the timestamp of burning.
1210             _ownerships[tokenId].addr = prevOwnership.addr;
1211             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1212             _ownerships[tokenId].burned = true;
1213 
1214             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1215             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1216             uint256 nextTokenId = tokenId + 1;
1217             if (_ownerships[nextTokenId].addr == address(0)) {
1218                 // This will suffice for checking _exists(nextTokenId),
1219                 // as a burned slot cannot contain the zero address.
1220                 if (nextTokenId < _currentIndex) {
1221                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1222                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1223                 }
1224             }
1225         }
1226 
1227         emit Transfer(prevOwnership.addr, address(0), tokenId);
1228         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1229 
1230         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1231         unchecked { 
1232             _burnCounter++;
1233         }
1234     }
1235 
1236     /**
1237      * @dev Approve `to` to operate on `tokenId`
1238      *
1239      * Emits a {Approval} event.
1240      */
1241     function _approve(
1242         address to,
1243         uint256 tokenId,
1244         address owner
1245     ) private {
1246         _tokenApprovals[tokenId] = to;
1247         emit Approval(owner, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1252      * The call is not executed if the target address is not a contract.
1253      *
1254      * @param from address representing the previous owner of the given token ID
1255      * @param to target address that will receive the tokens
1256      * @param tokenId uint256 ID of the token to be transferred
1257      * @param _data bytes optional data to send along with the call
1258      * @return bool whether the call correctly returned the expected magic value
1259      */
1260     function _checkOnERC721Received(
1261         address from,
1262         address to,
1263         uint256 tokenId,
1264         bytes memory _data
1265     ) private returns (bool) {
1266         if (to.isContract()) {
1267             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1268                 return retval == IERC721Receiver(to).onERC721Received.selector;
1269             } catch (bytes memory reason) {
1270                 if (reason.length == 0) {
1271                     revert TransferToNonERC721ReceiverImplementer();
1272                 } else {
1273                     assembly {
1274                         revert(add(32, reason), mload(reason))
1275                     }
1276                 }
1277             }
1278         } else {
1279             return true;
1280         }
1281     }
1282 
1283     /**
1284      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1285      * And also called before burning one token.
1286      *
1287      * startTokenId - the first token id to be transferred
1288      * quantity - the amount to be transferred
1289      *
1290      * Calling conditions:
1291      *
1292      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1293      * transferred to `to`.
1294      * - When `from` is zero, `tokenId` will be minted for `to`.
1295      * - When `to` is zero, `tokenId` will be burned by `from`.
1296      * - `from` and `to` are never both zero.
1297      */
1298     function _beforeTokenTransfers(
1299         address from,
1300         address to,
1301         uint256 startTokenId,
1302         uint256 quantity
1303     ) internal virtual {}
1304 
1305     /**
1306      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1307      * minting.
1308      * And also called after one token has been burned.
1309      *
1310      * startTokenId - the first token id to be transferred
1311      * quantity - the amount to be transferred
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` has been minted for `to`.
1318      * - When `to` is zero, `tokenId` has been burned by `from`.
1319      * - `from` and `to` are never both zero.
1320      */
1321     function _afterTokenTransfers(
1322         address from,
1323         address to,
1324         uint256 startTokenId,
1325         uint256 quantity
1326     ) internal virtual {}
1327 }
1328 
1329 pragma solidity ^0.8.7;
1330 
1331 contract NotTrippinApeTribe is ERC721A, Ownable {
1332 
1333     uint256 constant public MAX_MINT = 10000;
1334     uint256 constant public MAX_FREE_MINT = 1000;
1335 
1336     uint256 constant public MAX_MINT_PER_TX = 3;
1337     uint256 constant public MAX_FREE_MINT_PER_TX = 1;
1338 
1339     uint256 public cost = 0.02 ether;
1340 
1341     string public baseURI = "";
1342     string public baseExtension = ".json";
1343     bool public paused;
1344 
1345     constructor() ERC721A("Not Trippin' Ape Tribe", "NotTrippinApeTribe") {}
1346 
1347     function Mint(uint256 quantity) external payable {
1348         require(!paused, "Sale is currently paused.");
1349         require(quantity > 0, "Mint quantity less than 0.");
1350         require(totalSupply() + quantity <= MAX_MINT, "Cannot exceed max mint amount.");
1351         require(quantity <= MAX_MINT_PER_TX, "Cannot exeeds 3 quantity per tx.");
1352         require(msg.value >= quantity * cost, "Not enough ETHER sent.");
1353 
1354         _safeMint(msg.sender, quantity);
1355     }
1356 
1357     function FreeMint(uint256 quantity) external payable {
1358         require(!paused, "Sale is currently paused.");
1359         require(quantity <= MAX_FREE_MINT_PER_TX, "Cannot exeeds 1 quantity per tx.");
1360         require(totalSupply() + quantity <= MAX_FREE_MINT, "Cannot exceed max free mint amount.");
1361 
1362         _safeMint(msg.sender, quantity);
1363     }
1364 
1365     function setCost(uint256 _newCost) external onlyOwner() {
1366         cost = _newCost;
1367     }
1368 
1369     function setBaseExtension(uint256 _newCost) external onlyOwner() {
1370         cost = _newCost;
1371     }
1372 
1373     function setBaseURI(string calldata uri) external onlyOwner {
1374         baseURI = uri;
1375     }
1376 
1377     function toggleSale() external onlyOwner {
1378         paused = !paused;
1379     }
1380 
1381     function _baseURI() internal view override returns (string memory) {
1382         return baseURI;
1383     }
1384 
1385     function withdraw() external onlyOwner {
1386         payable(owner()).transfer(address(this).balance);
1387     }
1388 }