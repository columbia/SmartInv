1 // SPDX-License-Identifier: MIT
2 // notBanksy
3 // Who will be the final winner? BS15HH
4 // 9741 Nfts
5 // 0.05 ETH Mint
6 // Max 2 x Transaction
7 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
8 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
9 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
10 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
11 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
12 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
13 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
14 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
15 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
16 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
17 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
18 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
19 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
20 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
21 
22 // File: contracts/Strings.sol
23 
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 // File: contracts/Context.sol
92 
93 
94 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         return msg.data;
115     }
116 }
117 // File: contracts/Ownable.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor() {
146         _transferOwnership(_msgSender());
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         _transferOwnership(address(0));
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _transferOwnership(newOwner);
182     }
183 
184     /**
185      * @dev Transfers ownership of the contract to a new account (`newOwner`).
186      * Internal function without access restriction.
187      */
188     function _transferOwnership(address newOwner) internal virtual {
189         address oldOwner = _owner;
190         _owner = newOwner;
191         emit OwnershipTransferred(oldOwner, newOwner);
192     }
193 }
194 // File: contracts/Address.sol
195 
196 
197 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
198 
199 pragma solidity ^0.8.1;
200 
201 /**
202  * @dev Collection of functions related to the address type
203  */
204 library Address {
205     /**
206      * @dev Returns true if `account` is a contract.
207      *
208      * [IMPORTANT]
209      * ====
210      * It is unsafe to assume that an address for which this function returns
211      * false is an externally-owned account (EOA) and not a contract.
212      *
213      * Among others, `isContract` will return false for the following
214      * types of addresses:
215      *
216      *  - an externally-owned account
217      *  - a contract in construction
218      *  - an address where a contract will be created
219      *  - an address where a contract lived, but was destroyed
220      * ====
221      *
222      * [IMPORTANT]
223      * ====
224      * You shouldn't rely on `isContract` to protect against flash loan attacks!
225      *
226      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
227      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
228      * constructor.
229      * ====
230      */
231     function isContract(address account) internal view returns (bool) {
232         // This method relies on extcodesize/address.code.length, which returns 0
233         // for contracts in construction, since the code is only stored at the end
234         // of the constructor execution.
235 
236         return account.code.length > 0;
237     }
238 
239     /**
240      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
241      * `recipient`, forwarding all available gas and reverting on errors.
242      *
243      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
244      * of certain opcodes, possibly making contracts go over the 2300 gas limit
245      * imposed by `transfer`, making them unable to receive funds via
246      * `transfer`. {sendValue} removes this limitation.
247      *
248      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
249      *
250      * IMPORTANT: because control is transferred to `recipient`, care must be
251      * taken to not create reentrancy vulnerabilities. Consider using
252      * {ReentrancyGuard} or the
253      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
254      */
255     function sendValue(address payable recipient, uint256 amount) internal {
256         require(address(this).balance >= amount, "Address: insufficient balance");
257 
258         (bool success, ) = recipient.call{value: amount}("");
259         require(success, "Address: unable to send value, recipient may have reverted");
260     }
261 
262     /**
263      * @dev Performs a Solidity function call using a low level `call`. A
264      * plain `call` is an unsafe replacement for a function call: use this
265      * function instead.
266      *
267      * If `target` reverts with a revert reason, it is bubbled up by this
268      * function (like regular Solidity function calls).
269      *
270      * Returns the raw returned data. To convert to the expected return value,
271      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
272      *
273      * Requirements:
274      *
275      * - `target` must be a contract.
276      * - calling `target` with `data` must not revert.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
281         return functionCall(target, data, "Address: low-level call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
286      * `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, 0, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but also transferring `value` wei to `target`.
301      *
302      * Requirements:
303      *
304      * - the calling contract must have an ETH balance of at least `value`.
305      * - the called Solidity function must be `payable`.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value
313     ) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(address(this).balance >= value, "Address: insufficient balance for call");
330         require(isContract(target), "Address: call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.call{value: value}(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal view returns (bytes memory) {
357         require(isContract(target), "Address: static call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.staticcall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(isContract(target), "Address: delegate call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.delegatecall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
392      * revert reason using the provided one.
393      *
394      * _Available since v4.3._
395      */
396     function verifyCallResult(
397         bool success,
398         bytes memory returndata,
399         string memory errorMessage
400     ) internal pure returns (bytes memory) {
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 // File: contracts/IERC721Receiver.sol
419 
420 
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @title ERC721 token receiver interface
426  * @dev Interface for any contract that wants to support safeTransfers
427  * from ERC721 asset contracts.
428  */
429 interface IERC721Receiver {
430     /**
431      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
432      * by `operator` from `from`, this function is called.
433      *
434      * It must return its Solidity selector to confirm the token transfer.
435      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
436      *
437      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
438      */
439     function onERC721Received(
440         address operator,
441         address from,
442         uint256 tokenId,
443         bytes calldata data
444     ) external returns (bytes4);
445 }
446 // File: contracts/IERC165.sol
447 
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev Interface of the ERC165 standard, as defined in the
453  * https://eips.ethereum.org/EIPS/eip-165[EIP].
454  *
455  * Implementers can declare support of contract interfaces, which can then be
456  * queried by others ({ERC165Checker}).
457  *
458  * For an implementation, see {ERC165}.
459  */
460 interface IERC165 {
461     /**
462      * @dev Returns true if this contract implements the interface defined by
463      * `interfaceId`. See the corresponding
464      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
465      * to learn more about how these ids are created.
466      *
467      * This function call must use less than 30 000 gas.
468      */
469     function supportsInterface(bytes4 interfaceId) external view returns (bool);
470 }
471 // File: contracts/ERC165.sol
472 
473 
474 pragma solidity ^0.8.0;
475 
476 
477 /**
478  * @dev Implementation of the {IERC165} interface.
479  *
480  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
481  * for the additional interface id that will be supported. For example:
482  *
483  * ```solidity
484  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
486  * }
487  * ```
488  *
489  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
490  */
491 abstract contract ERC165 is IERC165 {
492     /**
493      * @dev See {IERC165-supportsInterface}.
494      */
495     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496         return interfaceId == type(IERC165).interfaceId;
497     }
498 }
499 // File: contracts/IERC721.sol
500 
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Required interface of an ERC721 compliant contract.
507  */
508 interface IERC721 is IERC165 {
509     /**
510      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
511      */
512     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
516      */
517     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
518 
519     /**
520      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
521      */
522     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
523 
524     /**
525      * @dev Returns the number of tokens in ``owner``'s account.
526      */
527     function balanceOf(address owner) external view returns (uint256 balance);
528 
529     /**
530      * @dev Returns the owner of the `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function ownerOf(uint256 tokenId) external view returns (address owner);
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
540      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must exist and be owned by `from`.
547      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
548      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
549      *
550      * Emits a {Transfer} event.
551      */
552     function safeTransferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) external;
557 
558     /**
559      * @dev Transfers `tokenId` token from `from` to `to`.
560      *
561      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      *
570      * Emits a {Transfer} event.
571      */
572     function transferFrom(
573         address from,
574         address to,
575         uint256 tokenId
576     ) external;
577 
578     /**
579      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
580      * The approval is cleared when the token is transferred.
581      *
582      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
583      *
584      * Requirements:
585      *
586      * - The caller must own the token or be an approved operator.
587      * - `tokenId` must exist.
588      *
589      * Emits an {Approval} event.
590      */
591     function approve(address to, uint256 tokenId) external;
592 
593     /**
594      * @dev Returns the account approved for `tokenId` token.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      */
600     function getApproved(uint256 tokenId) external view returns (address operator);
601 
602     /**
603      * @dev Approve or remove `operator` as an operator for the caller.
604      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
605      *
606      * Requirements:
607      *
608      * - The `operator` cannot be the caller.
609      *
610      * Emits an {ApprovalForAll} event.
611      */
612     function setApprovalForAll(address operator, bool _approved) external;
613 
614     /**
615      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
616      *
617      * See {setApprovalForAll}
618      */
619     function isApprovedForAll(address owner, address operator) external view returns (bool);
620 
621     /**
622      * @dev Safely transfers `tokenId` token from `from` to `to`.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId,
638         bytes calldata data
639     ) external;
640 }
641 // File: contracts/IERC721Enumerable.sol
642 
643 
644 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 
649 /**
650  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
651  * @dev See https://eips.ethereum.org/EIPS/eip-721
652  */
653 interface IERC721Enumerable is IERC721 {
654     /**
655      * @dev Returns the total amount of tokens stored by the contract.
656      */
657     function totalSupply() external view returns (uint256);
658 
659     /**
660      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
661      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
662      */
663     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
664 
665     /**
666      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
667      * Use along with {totalSupply} to enumerate all tokens.
668      */
669     function tokenByIndex(uint256 index) external view returns (uint256);
670 }
671 // File: contracts/IERC721Metadata.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 
679 /**
680  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
681  * @dev See https://eips.ethereum.org/EIPS/eip-721
682  */
683 interface IERC721Metadata is IERC721 {
684     /**
685      * @dev Returns the token collection name.
686      */
687     function name() external view returns (string memory);
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() external view returns (string memory);
693 
694     /**
695      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
696      */
697     function tokenURI(uint256 tokenId) external view returns (string memory);
698 }
699 // File: contracts/ERC721A.sol
700 
701 
702 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 
708 
709 
710 
711 
712 
713 
714 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
715     using Address for address;
716     using Strings for uint256;
717 
718     struct TokenOwnership {
719         address addr;
720         uint64 startTimestamp;
721     }
722 
723     struct AddressData {
724         uint128 balance;
725         uint128 numberMinted;
726     }
727 
728     uint256 internal currentIndex = 0;
729 
730     uint256 internal immutable maxBatchSize;
731 
732     // Token name
733     string private _name;
734 
735     // Token symbol
736     string private _symbol;
737 
738     // Mapping from token ID to ownership details
739     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
740     mapping(uint256 => TokenOwnership) internal _ownerships;
741 
742     // Mapping owner address to address data
743     mapping(address => AddressData) private _addressData;
744 
745     // Mapping from token ID to approved address
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     // Mapping from owner to operator approvals
749     mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751     /**
752      * @dev
753      * `maxBatchSize` refers to how much a minter can mint at a time.
754      */
755     constructor(
756         string memory name_,
757         string memory symbol_,
758         uint256 maxBatchSize_
759     ) {
760         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
761         _name = name_;
762         _symbol = symbol_;
763         maxBatchSize = maxBatchSize_;
764     }
765 
766     /**
767      * @dev See {IERC721Enumerable-totalSupply}.
768      */
769     function totalSupply() public view override returns (uint256) {
770         return currentIndex;
771     }
772 
773     /**
774      * @dev See {IERC721Enumerable-tokenByIndex}.
775      */
776     function tokenByIndex(uint256 index) public view override returns (uint256) {
777         require(index < totalSupply(), 'ERC721A: global index out of bounds');
778         return index;
779     }
780 
781     /**
782      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
783      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
784      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
785      */
786     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
787         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
788         uint256 numMintedSoFar = totalSupply();
789         uint256 tokenIdsIdx = 0;
790         address currOwnershipAddr = address(0);
791         for (uint256 i = 0; i < numMintedSoFar; i++) {
792             TokenOwnership memory ownership = _ownerships[i];
793             if (ownership.addr != address(0)) {
794                 currOwnershipAddr = ownership.addr;
795             }
796             if (currOwnershipAddr == owner) {
797                 if (tokenIdsIdx == index) {
798                     return i;
799                 }
800                 tokenIdsIdx++;
801             }
802         }
803         revert('ERC721A: unable to get token of owner by index');
804     }
805 
806     /**
807      * @dev See {IERC165-supportsInterface}.
808      */
809     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
810         return
811             interfaceId == type(IERC721).interfaceId ||
812             interfaceId == type(IERC721Metadata).interfaceId ||
813             interfaceId == type(IERC721Enumerable).interfaceId ||
814             super.supportsInterface(interfaceId);
815     }
816 
817     /**
818      * @dev See {IERC721-balanceOf}.
819      */
820     function balanceOf(address owner) public view override returns (uint256) {
821         require(owner != address(0), 'ERC721A: balance query for the zero address');
822         return uint256(_addressData[owner].balance);
823     }
824 
825     function _numberMinted(address owner) internal view returns (uint256) {
826         require(owner != address(0), 'ERC721A: number minted query for the zero address');
827         return uint256(_addressData[owner].numberMinted);
828     }
829 
830     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
831         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
832 
833         uint256 lowestTokenToCheck;
834         if (tokenId >= maxBatchSize) {
835             lowestTokenToCheck = tokenId - maxBatchSize + 1;
836         }
837 
838         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
839             TokenOwnership memory ownership = _ownerships[curr];
840             if (ownership.addr != address(0)) {
841                 return ownership;
842             }
843         }
844 
845         revert('ERC721A: unable to determine the owner of token');
846     }
847 
848     /**
849      * @dev See {IERC721-ownerOf}.
850      */
851     function ownerOf(uint256 tokenId) public view override returns (address) {
852         return ownershipOf(tokenId).addr;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-name}.
857      */
858     function name() public view virtual override returns (string memory) {
859         return _name;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-symbol}.
864      */
865     function symbol() public view virtual override returns (string memory) {
866         return _symbol;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-tokenURI}.
871      */
872     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
873         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
874 
875         string memory baseURI = _baseURI();
876         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
877     }
878 
879     /**
880      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
881      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
882      * by default, can be overriden in child contracts.
883      */
884     function _baseURI() internal view virtual returns (string memory) {
885         return '';
886     }
887 
888     /**
889      * @dev See {IERC721-approve}.
890      */
891     function approve(address to, uint256 tokenId) public override {
892         address owner = ERC721A.ownerOf(tokenId);
893         require(to != owner, 'ERC721A: approval to current owner');
894 
895         require(
896             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
897             'ERC721A: approve caller is not owner nor approved for all'
898         );
899 
900         _approve(to, tokenId, owner);
901     }
902 
903     /**
904      * @dev See {IERC721-getApproved}.
905      */
906     function getApproved(uint256 tokenId) public view override returns (address) {
907         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
908 
909         return _tokenApprovals[tokenId];
910     }
911 
912     /**
913      * @dev See {IERC721-setApprovalForAll}.
914      */
915     function setApprovalForAll(address operator, bool approved) public override {
916         require(operator != _msgSender(), 'ERC721A: approve to caller');
917 
918         _operatorApprovals[_msgSender()][operator] = approved;
919         emit ApprovalForAll(_msgSender(), operator, approved);
920     }
921 
922     /**
923      * @dev See {IERC721-isApprovedForAll}.
924      */
925     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
926         return _operatorApprovals[owner][operator];
927     }
928 
929     /**
930      * @dev See {IERC721-transferFrom}.
931      */
932     function transferFrom(
933         address from,
934         address to,
935         uint256 tokenId
936     ) public override {
937         _transfer(from, to, tokenId);
938     }
939 
940     /**
941      * @dev See {IERC721-safeTransferFrom}.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public override {
948         safeTransferFrom(from, to, tokenId, '');
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) public override {
960         _transfer(from, to, tokenId);
961         require(
962             _checkOnERC721Received(from, to, tokenId, _data),
963             'ERC721A: transfer to non ERC721Receiver implementer'
964         );
965     }
966 
967     /**
968      * @dev Returns whether `tokenId` exists.
969      *
970      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
971      *
972      * Tokens start existing when they are minted (`_mint`),
973      */
974     function _exists(uint256 tokenId) internal view returns (bool) {
975         return tokenId < currentIndex;
976     }
977 
978     function _safeMint(address to, uint256 quantity) internal {
979         _safeMint(to, quantity, '');
980     }
981 
982     /**
983      * @dev Mints `quantity` tokens and transfers them to `to`.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      * - `quantity` cannot be larger than the max batch size.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _safeMint(
993         address to,
994         uint256 quantity,
995         bytes memory _data
996     ) internal {
997         uint256 startTokenId = currentIndex;
998         require(to != address(0), 'ERC721A: mint to the zero address');
999         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1000         require(!_exists(startTokenId), 'ERC721A: token already minted');
1001         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1002         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1003 
1004         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1005 
1006         AddressData memory addressData = _addressData[to];
1007         _addressData[to] = AddressData(
1008             addressData.balance + uint128(quantity),
1009             addressData.numberMinted + uint128(quantity)
1010         );
1011         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1012 
1013         uint256 updatedIndex = startTokenId;
1014 
1015         for (uint256 i = 0; i < quantity; i++) {
1016             emit Transfer(address(0), to, updatedIndex);
1017             require(
1018                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1019                 'ERC721A: transfer to non ERC721Receiver implementer'
1020             );
1021             updatedIndex++;
1022         }
1023 
1024         currentIndex = updatedIndex;
1025         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1026     }
1027 
1028     /**
1029      * @dev Transfers `tokenId` from `from` to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `to` cannot be the zero address.
1034      * - `tokenId` token must be owned by `from`.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _transfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) private {
1043         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1044 
1045         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1046             getApproved(tokenId) == _msgSender() ||
1047             isApprovedForAll(prevOwnership.addr, _msgSender()));
1048 
1049         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1050 
1051         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1052         require(to != address(0), 'ERC721A: transfer to the zero address');
1053 
1054         _beforeTokenTransfers(from, to, tokenId, 1);
1055 
1056         // Clear approvals from the previous owner
1057         _approve(address(0), tokenId, prevOwnership.addr);
1058 
1059         // Underflow of the sender's balance is impossible because we check for
1060         // ownership above and the recipient's balance can't realistically overflow.
1061         unchecked {
1062             _addressData[from].balance -= 1;
1063             _addressData[to].balance += 1;
1064         }
1065 
1066         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1067 
1068         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1069         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1070         uint256 nextTokenId = tokenId + 1;
1071         if (_ownerships[nextTokenId].addr == address(0)) {
1072             if (_exists(nextTokenId)) {
1073                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1074             }
1075         }
1076 
1077         emit Transfer(from, to, tokenId);
1078         _afterTokenTransfers(from, to, tokenId, 1);
1079     }
1080 
1081     /**
1082      * @dev Approve `to` to operate on `tokenId`
1083      *
1084      * Emits a {Approval} event.
1085      */
1086     function _approve(
1087         address to,
1088         uint256 tokenId,
1089         address owner
1090     ) private {
1091         _tokenApprovals[tokenId] = to;
1092         emit Approval(owner, to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1097      * The call is not executed if the target address is not a contract.
1098      *
1099      * @param from address representing the previous owner of the given token ID
1100      * @param to target address that will receive the tokens
1101      * @param tokenId uint256 ID of the token to be transferred
1102      * @param _data bytes optional data to send along with the call
1103      * @return bool whether the call correctly returned the expected magic value
1104      */
1105     function _checkOnERC721Received(
1106         address from,
1107         address to,
1108         uint256 tokenId,
1109         bytes memory _data
1110     ) private returns (bool) {
1111         if (to.isContract()) {
1112             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1113                 return retval == IERC721Receiver(to).onERC721Received.selector;
1114             } catch (bytes memory reason) {
1115                 if (reason.length == 0) {
1116                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1117                 } else {
1118                     assembly {
1119                         revert(add(32, reason), mload(reason))
1120                     }
1121                 }
1122             }
1123         } else {
1124             return true;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1130      *
1131      * startTokenId - the first token id to be transferred
1132      * quantity - the amount to be transferred
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` will be minted for `to`.
1139      */
1140     function _beforeTokenTransfers(
1141         address from,
1142         address to,
1143         uint256 startTokenId,
1144         uint256 quantity
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1149      * minting.
1150      *
1151      * startTokenId - the first token id to be transferred
1152      * quantity - the amount to be transferred
1153      *
1154      * Calling conditions:
1155      *
1156      * - when `from` and `to` are both non-zero.
1157      * - `from` and `to` are never both zero.
1158      */
1159     function _afterTokenTransfers(
1160         address from,
1161         address to,
1162         uint256 startTokenId,
1163         uint256 quantity
1164     ) internal virtual {}
1165 }
1166 
1167 // File: contracts/notBanksyFinale.sol
1168 
1169 
1170 pragma solidity ^0.8.7;
1171 
1172 // notBanksy
1173 // Who will be the final winner? BS15HH
1174 // 9741 Nfts
1175 // 0.05 ETH Mint
1176 // Max 2 x Transaction
1177 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1178 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1179 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1180 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1181 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1182 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1183 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1184 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1185 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1186 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1187 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1188 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1189 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1190 // Who will be the final winner BS15HH Who will be the final winner BS15HH Who will be the final winner BS15HH  
1191 
1192 
1193 
1194 
1195 contract notBanksyFinale is ERC721A, Ownable {
1196   using Strings for uint256;
1197 
1198   string private uriPrefix = "ipfs://_______NOTBANKSY____/";
1199   string private uriSuffix = ".json";
1200   string public hiddenMetadataUri;
1201   
1202   uint256 public price = 0.05 ether; 
1203   uint256 public maxSupply = 9741; 
1204   uint256 public maxMintAmountPerTx = 2; 
1205   
1206   bool public paused = true;
1207   bool public revealed = false;
1208   mapping(address => uint256) public addressMintedBalance;
1209 
1210 
1211   constructor() ERC721A("notBanksyFinale", "NBFINALE", maxMintAmountPerTx) {
1212     setHiddenMetadataUri("ipfs://QmWpBkD7i1uHA59BGXHf8n1AAN88Hg7mYbqMURgwDUHjvG");
1213   }
1214 
1215   modifier mintCompliance(uint256 _mintAmount) {
1216     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1217     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1218     _;
1219   }
1220 
1221   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1222    {
1223     require(!paused, "The contract is paused!");
1224     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1225     
1226     
1227     _safeMint(msg.sender, _mintAmount);
1228   }
1229 
1230    
1231   function notBanksytoAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1232     _safeMint(_to, _mintAmount);
1233   }
1234 
1235  
1236   function walletOfOwner(address _owner)
1237     public
1238     view
1239     returns (uint256[] memory)
1240   {
1241     uint256 ownerTokenCount = balanceOf(_owner);
1242     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1243     uint256 currentTokenId = 0;
1244     uint256 ownedTokenIndex = 0;
1245 
1246     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1247       address currentTokenOwner = ownerOf(currentTokenId);
1248 
1249       if (currentTokenOwner == _owner) {
1250         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1251 
1252         ownedTokenIndex++;
1253       }
1254 
1255       currentTokenId++;
1256     }
1257 
1258     return ownedTokenIds;
1259   }
1260 
1261   function tokenURI(uint256 _tokenId)
1262     public
1263     view
1264     virtual
1265     override
1266     returns (string memory)
1267   {
1268     require(
1269       _exists(_tokenId),
1270       "ERC721Metadata: URI query for nonexistent token"
1271     );
1272 
1273     if (revealed == false) {
1274       return hiddenMetadataUri;
1275     }
1276 
1277     string memory currentBaseURI = _baseURI();
1278     return bytes(currentBaseURI).length > 0
1279         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1280         : "";
1281   }
1282 
1283   function setRevealed(bool _state) public onlyOwner {
1284     revealed = _state;
1285   
1286   }
1287 
1288   function setPrice(uint256 _price) public onlyOwner {
1289     price = _price;
1290 
1291   }
1292  
1293   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1294     hiddenMetadataUri = _hiddenMetadataUri;
1295   }
1296 
1297 
1298 
1299   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1300     uriPrefix = _uriPrefix;
1301   }
1302 
1303   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1304     uriSuffix = _uriSuffix;
1305   }
1306 
1307   function setPaused(bool _state) public onlyOwner {
1308     paused = _state;
1309   }
1310 
1311   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1312       _safeMint(_receiver, _mintAmount);
1313   }
1314 
1315   function _baseURI() internal view virtual override returns (string memory) {
1316     return uriPrefix;
1317     
1318   }
1319 
1320     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1321     maxMintAmountPerTx = _maxMintAmountPerTx;
1322 
1323   }
1324 
1325     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1326     maxSupply = _maxSupply;
1327 
1328   }
1329 
1330 
1331   // withdrawall addresses
1332   address t1 = 0xfF1989eEf3a78DB2F55F485423DE00B8f282e128; 
1333   
1334 
1335   function withdrawall() public onlyOwner {
1336         uint256 _balance = address(this).balance;
1337         
1338         require(payable(t1).send(_balance * 100 / 100 ));
1339         
1340     }
1341 
1342   function withdraw() public onlyOwner {
1343     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1344     require(os);
1345     
1346 
1347  
1348   }
1349   
1350 }