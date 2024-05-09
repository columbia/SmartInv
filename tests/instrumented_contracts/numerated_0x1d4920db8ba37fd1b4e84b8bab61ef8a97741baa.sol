1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-10
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-03-01
7 */
8 
9 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
10 
11 // SPDX-License-Identifier: MIT
12 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 
37 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
38 
39 
40 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
41 
42 
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
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
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 
115 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
119 
120 
121 
122 /**
123  * @dev String operations.
124  */
125 library Strings {
126     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
130      */
131     function toString(uint256 value) internal pure returns (string memory) {
132         // Inspired by OraclizeAPI's implementation - MIT licence
133         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
134 
135         if (value == 0) {
136             return "0";
137         }
138         uint256 temp = value;
139         uint256 digits;
140         while (temp != 0) {
141             digits++;
142             temp /= 10;
143         }
144         bytes memory buffer = new bytes(digits);
145         while (value != 0) {
146             digits -= 1;
147             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
148             value /= 10;
149         }
150         return string(buffer);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
155      */
156     function toHexString(uint256 value) internal pure returns (string memory) {
157         if (value == 0) {
158             return "0x00";
159         }
160         uint256 temp = value;
161         uint256 length = 0;
162         while (temp != 0) {
163             length++;
164             temp >>= 8;
165         }
166         return toHexString(value, length);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
171      */
172     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
173         bytes memory buffer = new bytes(2 * length + 2);
174         buffer[0] = "0";
175         buffer[1] = "x";
176         for (uint256 i = 2 * length + 1; i > 1; --i) {
177             buffer[i] = _HEX_SYMBOLS[value & 0xf];
178             value >>= 4;
179         }
180         require(value == 0, "Strings: hex length insufficient");
181         return string(buffer);
182     }
183 }
184 
185 
186 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
187 
188 
189 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
190 
191 
192 
193 /**
194  * @dev Interface of the ERC165 standard, as defined in the
195  * https://eips.ethereum.org/EIPS/eip-165[EIP].
196  *
197  * Implementers can declare support of contract interfaces, which can then be
198  * queried by others ({ERC165Checker}).
199  *
200  * For an implementation, see {ERC165}.
201  */
202 interface IERC165 {
203     /**
204      * @dev Returns true if this contract implements the interface defined by
205      * `interfaceId`. See the corresponding
206      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
207      * to learn more about how these ids are created.
208      *
209      * This function call must use less than 30 000 gas.
210      */
211     function supportsInterface(bytes4 interfaceId) external view returns (bool);
212 }
213 
214 
215 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
216 
217 
218 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
219 
220 
221 
222 /**
223  * @dev Required interface of an ERC721 compliant contract.
224  */
225 interface IERC721 is IERC165 {
226     /**
227      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
228      */
229     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
230 
231     /**
232      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
233      */
234     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
235 
236     /**
237      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
238      */
239     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
240 
241     /**
242      * @dev Returns the number of tokens in ``owner``'s account.
243      */
244     function balanceOf(address owner) external view returns (uint256 balance);
245 
246     /**
247      * @dev Returns the owner of the `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function ownerOf(uint256 tokenId) external view returns (address owner);
254 
255     /**
256      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
257      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `tokenId` token must exist and be owned by `from`.
264      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
265      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
266      *
267      * Emits a {Transfer} event.
268      */
269     function safeTransferFrom(
270         address from,
271         address to,
272         uint256 tokenId
273     ) external;
274 
275     /**
276      * @dev Transfers `tokenId` token from `from` to `to`.
277      *
278      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
279      *
280      * Requirements:
281      *
282      * - `from` cannot be the zero address.
283      * - `to` cannot be the zero address.
284      * - `tokenId` token must be owned by `from`.
285      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
286      *
287      * Emits a {Transfer} event.
288      */
289     function transferFrom(
290         address from,
291         address to,
292         uint256 tokenId
293     ) external;
294 
295     /**
296      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
297      * The approval is cleared when the token is transferred.
298      *
299      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
300      *
301      * Requirements:
302      *
303      * - The caller must own the token or be an approved operator.
304      * - `tokenId` must exist.
305      *
306      * Emits an {Approval} event.
307      */
308     function approve(address to, uint256 tokenId) external;
309 
310     /**
311      * @dev Returns the account approved for `tokenId` token.
312      *
313      * Requirements:
314      *
315      * - `tokenId` must exist.
316      */
317     function getApproved(uint256 tokenId) external view returns (address operator);
318 
319     /**
320      * @dev Approve or remove `operator` as an operator for the caller.
321      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
322      *
323      * Requirements:
324      *
325      * - The `operator` cannot be the caller.
326      *
327      * Emits an {ApprovalForAll} event.
328      */
329     function setApprovalForAll(address operator, bool _approved) external;
330 
331     /**
332      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
333      *
334      * See {setApprovalForAll}
335      */
336     function isApprovedForAll(address owner, address operator) external view returns (bool);
337 
338     /**
339      * @dev Safely transfers `tokenId` token from `from` to `to`.
340      *
341      * Requirements:
342      *
343      * - `from` cannot be the zero address.
344      * - `to` cannot be the zero address.
345      * - `tokenId` token must exist and be owned by `from`.
346      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
347      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
348      *
349      * Emits a {Transfer} event.
350      */
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 tokenId,
355         bytes calldata data
356     ) external;
357 }
358 
359 
360 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
364 
365 
366 
367 /**
368  * @title ERC721 token receiver interface
369  * @dev Interface for any contract that wants to support safeTransfers
370  * from ERC721 asset contracts.
371  */
372 interface IERC721Receiver {
373     /**
374      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
375      * by `operator` from `from`, this function is called.
376      *
377      * It must return its Solidity selector to confirm the token transfer.
378      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
379      *
380      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
381      */
382     function onERC721Received(
383         address operator,
384         address from,
385         uint256 tokenId,
386         bytes calldata data
387     ) external returns (bytes4);
388 }
389 
390 
391 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
392 
393 
394 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
395 
396 
397 
398 /**
399  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
400  * @dev See https://eips.ethereum.org/EIPS/eip-721
401  */
402 interface IERC721Metadata is IERC721 {
403     /**
404      * @dev Returns the token collection name.
405      */
406     function name() external view returns (string memory);
407 
408     /**
409      * @dev Returns the token collection symbol.
410      */
411     function symbol() external view returns (string memory);
412 
413     /**
414      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
415      */
416     function tokenURI(uint256 tokenId) external view returns (string memory);
417 }
418 
419 
420 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
421 
422 
423 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
424 
425 
426 
427 /**
428  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
429  * @dev See https://eips.ethereum.org/EIPS/eip-721
430  */
431 interface IERC721Enumerable is IERC721 {
432     /**
433      * @dev Returns the total amount of tokens stored by the contract.
434      */
435     function totalSupply() external view returns (uint256);
436 
437     /**
438      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
439      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
440      */
441     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
442 
443     /**
444      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
445      * Use along with {totalSupply} to enumerate all tokens.
446      */
447     function tokenByIndex(uint256 index) external view returns (uint256);
448 }
449 
450 
451 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
455 
456 
457 
458 /**
459  * @dev Collection of functions related to the address type
460  */
461 library Address {
462     /**
463      * @dev Returns true if `account` is a contract.
464      *
465      * [IMPORTANT]
466      * ====
467      * It is unsafe to assume that an address for which this function returns
468      * false is an externally-owned account (EOA) and not a contract.
469      *
470      * Among others, `isContract` will return false for the following
471      * types of addresses:
472      *
473      *  - an externally-owned account
474      *  - a contract in construction
475      *  - an address where a contract will be created
476      *  - an address where a contract lived, but was destroyed
477      * ====
478      */
479     function isContract(address account) internal view returns (bool) {
480         // This method relies on extcodesize, which returns 0 for contracts in
481         // construction, since the code is only stored at the end of the
482         // constructor execution.
483 
484         uint256 size;
485         assembly {
486             size := extcodesize(account)
487         }
488         return size > 0;
489     }
490 
491     /**
492      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
493      * `recipient`, forwarding all available gas and reverting on errors.
494      *
495      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
496      * of certain opcodes, possibly making contracts go over the 2300 gas limit
497      * imposed by `transfer`, making them unable to receive funds via
498      * `transfer`. {sendValue} removes this limitation.
499      *
500      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
501      *
502      * IMPORTANT: because control is transferred to `recipient`, care must be
503      * taken to not create reentrancy vulnerabilities. Consider using
504      * {ReentrancyGuard} or the
505      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
506      */
507     function sendValue(address payable recipient, uint256 amount) internal {
508         require(address(this).balance >= amount, "Address: insufficient balance");
509 
510         (bool success, ) = recipient.call{value: amount}("");
511         require(success, "Address: unable to send value, recipient may have reverted");
512     }
513 
514     /**
515      * @dev Performs a Solidity function call using a low level `call`. A
516      * plain `call` is an unsafe replacement for a function call: use this
517      * function instead.
518      *
519      * If `target` reverts with a revert reason, it is bubbled up by this
520      * function (like regular Solidity function calls).
521      *
522      * Returns the raw returned data. To convert to the expected return value,
523      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
524      *
525      * Requirements:
526      *
527      * - `target` must be a contract.
528      * - calling `target` with `data` must not revert.
529      *
530      * _Available since v3.1._
531      */
532     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
533         return functionCall(target, data, "Address: low-level call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
538      * `errorMessage` as a fallback revert reason when `target` reverts.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         return functionCallWithValue(target, data, 0, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but also transferring `value` wei to `target`.
553      *
554      * Requirements:
555      *
556      * - the calling contract must have an ETH balance of at least `value`.
557      * - the called Solidity function must be `payable`.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value
565     ) internal returns (bytes memory) {
566         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
571      * with `errorMessage` as a fallback revert reason when `target` reverts.
572      *
573      * _Available since v3.1._
574      */
575     function functionCallWithValue(
576         address target,
577         bytes memory data,
578         uint256 value,
579         string memory errorMessage
580     ) internal returns (bytes memory) {
581         require(address(this).balance >= value, "Address: insufficient balance for call");
582         require(isContract(target), "Address: call to non-contract");
583 
584         (bool success, bytes memory returndata) = target.call{value: value}(data);
585         return verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
595         return functionStaticCall(target, data, "Address: low-level static call failed");
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
600      * but performing a static call.
601      *
602      * _Available since v3.3._
603      */
604     function functionStaticCall(
605         address target,
606         bytes memory data,
607         string memory errorMessage
608     ) internal view returns (bytes memory) {
609         require(isContract(target), "Address: static call to non-contract");
610 
611         (bool success, bytes memory returndata) = target.staticcall(data);
612         return verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.4._
620      */
621     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
622         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
627      * but performing a delegate call.
628      *
629      * _Available since v3.4._
630      */
631     function functionDelegateCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         require(isContract(target), "Address: delegate call to non-contract");
637 
638         (bool success, bytes memory returndata) = target.delegatecall(data);
639         return verifyCallResult(success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
644      * revert reason using the provided one.
645      *
646      * _Available since v4.3._
647      */
648     function verifyCallResult(
649         bool success,
650         bytes memory returndata,
651         string memory errorMessage
652     ) internal pure returns (bytes memory) {
653         if (success) {
654             return returndata;
655         } else {
656             // Look for revert reason and bubble it up if present
657             if (returndata.length > 0) {
658                 // The easiest way to bubble the revert reason is using memory via assembly
659 
660                 assembly {
661                     let returndata_size := mload(returndata)
662                     revert(add(32, returndata), returndata_size)
663                 }
664             } else {
665                 revert(errorMessage);
666             }
667         }
668     }
669 }
670 
671 
672 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
676 
677 
678 
679 /**
680  * @dev Implementation of the {IERC165} interface.
681  *
682  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
683  * for the additional interface id that will be supported. For example:
684  *
685  * ```solidity
686  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
688  * }
689  * ```
690  *
691  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
692  */
693 abstract contract ERC165 is IERC165 {
694     /**
695      * @dev See {IERC165-supportsInterface}.
696      */
697     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698         return interfaceId == type(IERC165).interfaceId;
699     }
700 }
701 
702 
703 // File contracts/ERC721A.sol
704 
705 
706 // Creator: Chiru Labs
707 
708 
709 /**
710  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
711  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
712  *
713  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
714  *
715  * Does not support burning tokens to address(0).
716  *
717  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
718  */
719 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
720     using Address for address;
721     using Strings for uint256;
722 
723     struct TokenOwnership {
724         address addr;
725         uint64 startTimestamp;
726     }
727 
728     struct AddressData {
729         uint128 balance;
730         uint128 numberMinted;
731     }
732 
733     uint256 internal currentIndex = 1;
734 
735     // Token name
736     string private _name;
737 
738     // Token symbol
739     string private _symbol;
740 
741     // Mapping from token ID to ownership details
742     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
743     mapping(uint256 => TokenOwnership) internal _ownerships;
744 
745     // Mapping owner address to address data
746     mapping(address => AddressData) private _addressData;
747 
748     // Mapping from token ID to approved address
749     mapping(uint256 => address) private _tokenApprovals;
750 
751     // Mapping from owner to operator approvals
752     mapping(address => mapping(address => bool)) private _operatorApprovals;
753 
754     constructor(string memory name_, string memory symbol_) {
755         _name = name_;
756         _symbol = symbol_;
757     }
758 
759     /**
760      * @dev See {IERC721Enumerable-totalSupply}.
761      */
762     function totalSupply() public view override returns (uint256) {
763         return currentIndex;
764     }
765 
766     /**
767      * @dev See {IERC721Enumerable-tokenByIndex}.
768      */
769     function tokenByIndex(uint256 index) public view override returns (uint256) {
770         require(index < totalSupply(), 'ERC721A: global index out of bounds');
771         return index;
772     }
773 
774     /**
775      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
776      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
777      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
778      */
779     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
780         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
781         uint256 numMintedSoFar = totalSupply();
782         uint256 tokenIdsIdx = 0;
783         address currOwnershipAddr = address(0);
784         for (uint256 i = 0; i < numMintedSoFar; i++) {
785             TokenOwnership memory ownership = _ownerships[i];
786             if (ownership.addr != address(0)) {
787                 currOwnershipAddr = ownership.addr;
788             }
789             if (currOwnershipAddr == owner) {
790                 if (tokenIdsIdx == index) {
791                     return i;
792                 }
793                 tokenIdsIdx++;
794             }
795         }
796         revert('ERC721A: unable to get token of owner by index');
797     }
798 
799     /**
800      * @dev See {IERC165-supportsInterface}.
801      */
802     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
803         return
804             interfaceId == type(IERC721).interfaceId ||
805             interfaceId == type(IERC721Metadata).interfaceId ||
806             interfaceId == type(IERC721Enumerable).interfaceId ||
807             super.supportsInterface(interfaceId);
808     }
809 
810     /**
811      * @dev See {IERC721-balanceOf}.
812      */
813     function balanceOf(address owner) public view override returns (uint256) {
814         require(owner != address(0), 'ERC721A: balance query for the zero address');
815         return uint256(_addressData[owner].balance);
816     }
817 
818     function _numberMinted(address owner) internal view returns (uint256) {
819         require(owner != address(0), 'ERC721A: number minted query for the zero address');
820         return uint256(_addressData[owner].numberMinted);
821     }
822 
823     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
824         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
825 
826         for (uint256 curr = tokenId; ; curr--) {
827             TokenOwnership memory ownership = _ownerships[curr];
828             if (ownership.addr != address(0)) {
829                 return ownership;
830             }
831         }
832 
833         revert('ERC721A: unable to determine the owner of token');
834     }
835 
836     /**
837      * @dev See {IERC721-ownerOf}.
838      */
839     function ownerOf(uint256 tokenId) public view override returns (address) {
840         return ownershipOf(tokenId).addr;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-name}.
845      */
846     function name() public view virtual override returns (string memory) {
847         return _name;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-symbol}.
852      */
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-tokenURI}.
859      */
860     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
861         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
862 
863         string memory baseURI = _baseURI();
864         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
865     }
866 
867     /**
868      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
869      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
870      * by default, can be overriden in child contracts.
871      */
872     function _baseURI() internal view virtual returns (string memory) {
873         return '';
874     }
875 
876     /**
877      * @dev See {IERC721-approve}.
878      */
879     function approve(address to, uint256 tokenId) public override {
880         address owner = ERC721A.ownerOf(tokenId);
881         require(to != owner, 'ERC721A: approval to current owner');
882 
883         require(
884             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
885             'ERC721A: approve caller is not owner nor approved for all'
886         );
887 
888         _approve(to, tokenId, owner);
889     }
890 
891     /**
892      * @dev See {IERC721-getApproved}.
893      */
894     function getApproved(uint256 tokenId) public view override returns (address) {
895         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
896 
897         return _tokenApprovals[tokenId];
898     }
899 
900     /**
901      * @dev See {IERC721-setApprovalForAll}.
902      */
903     function setApprovalForAll(address operator, bool approved) public override {
904         require(operator != _msgSender(), 'ERC721A: approve to caller');
905 
906         _operatorApprovals[_msgSender()][operator] = approved;
907         emit ApprovalForAll(_msgSender(), operator, approved);
908     }
909 
910     /**
911      * @dev See {IERC721-isApprovedForAll}.
912      */
913     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
914         return _operatorApprovals[owner][operator];
915     }
916 
917     /**
918      * @dev See {IERC721-transferFrom}.
919      */
920     function transferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) public override {
925         _transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public override {
936         safeTransferFrom(from, to, tokenId, '');
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) public override {
948         _transfer(from, to, tokenId);
949         require(
950             _checkOnERC721Received(from, to, tokenId, _data),
951             'ERC721A: transfer to non ERC721Receiver implementer'
952         );
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted (`_mint`),
961      */
962     function _exists(uint256 tokenId) internal view returns (bool) {
963         return tokenId < currentIndex;
964     }
965 
966     function _safeMint(address to, uint256 quantity) internal {
967         _safeMint(to, quantity, '');
968     }
969 
970     /**
971      * @dev Mints `quantity` tokens and transfers them to `to`.
972      *
973      * Requirements:
974      *
975      * - `to` cannot be the zero address.
976      * - `quantity` cannot be larger than the max batch size.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeMint(
981         address to,
982         uint256 quantity,
983         bytes memory _data
984     ) internal {
985         uint256 startTokenId = currentIndex;
986         require(to != address(0), 'ERC721A: mint to the zero address');
987         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
988         require(!_exists(startTokenId), 'ERC721A: token already minted');
989         require(quantity > 0, 'ERC721A: quantity must be greater 0');
990 
991         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
992 
993         AddressData memory addressData = _addressData[to];
994         _addressData[to] = AddressData(
995             addressData.balance + uint128(quantity),
996             addressData.numberMinted + uint128(quantity)
997         );
998         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
999 
1000         uint256 updatedIndex = startTokenId;
1001 
1002         for (uint256 i = 0; i < quantity; i++) {
1003             emit Transfer(address(0), to, updatedIndex);
1004             require(
1005                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1006                 'ERC721A: transfer to non ERC721Receiver implementer'
1007             );
1008             updatedIndex++;
1009         }
1010 
1011         currentIndex = updatedIndex;
1012         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _transfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) private {
1030         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1031 
1032         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1033             getApproved(tokenId) == _msgSender() ||
1034             isApprovedForAll(prevOwnership.addr, _msgSender()));
1035 
1036         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1037 
1038         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1039         require(to != address(0), 'ERC721A: transfer to the zero address');
1040 
1041         _beforeTokenTransfers(from, to, tokenId, 1);
1042 
1043         // Clear approvals from the previous owner
1044         _approve(address(0), tokenId, prevOwnership.addr);
1045 
1046         // Underflow of the sender's balance is impossible because we check for
1047         // ownership above and the recipient's balance can't realistically overflow.
1048         unchecked {
1049             _addressData[from].balance -= 1;
1050             _addressData[to].balance += 1;
1051         }
1052 
1053         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1054 
1055         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1056         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1057         uint256 nextTokenId = tokenId + 1;
1058         if (_ownerships[nextTokenId].addr == address(0)) {
1059             if (_exists(nextTokenId)) {
1060                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1061             }
1062         }
1063 
1064         emit Transfer(from, to, tokenId);
1065         _afterTokenTransfers(from, to, tokenId, 1);
1066     }
1067 
1068     /**
1069      * @dev Approve `to` to operate on `tokenId`
1070      *
1071      * Emits a {Approval} event.
1072      */
1073     function _approve(
1074         address to,
1075         uint256 tokenId,
1076         address owner
1077     ) private {
1078         _tokenApprovals[tokenId] = to;
1079         emit Approval(owner, to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1084      * The call is not executed if the target address is not a contract.
1085      *
1086      * @param from address representing the previous owner of the given token ID
1087      * @param to target address that will receive the tokens
1088      * @param tokenId uint256 ID of the token to be transferred
1089      * @param _data bytes optional data to send along with the call
1090      * @return bool whether the call correctly returned the expected magic value
1091      */
1092     function _checkOnERC721Received(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) private returns (bool) {
1098         if (to.isContract()) {
1099             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1100                 return retval == IERC721Receiver(to).onERC721Received.selector;
1101             } catch (bytes memory reason) {
1102                 if (reason.length == 0) {
1103                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1104                 } else {
1105                     assembly {
1106                         revert(add(32, reason), mload(reason))
1107                     }
1108                 }
1109             }
1110         } else {
1111             return true;
1112         }
1113     }
1114 
1115     /**
1116      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1117      *
1118      * startTokenId - the first token id to be transferred
1119      * quantity - the amount to be transferred
1120      *
1121      * Calling conditions:
1122      *
1123      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1124      * transferred to `to`.
1125      * - When `from` is zero, `tokenId` will be minted for `to`.
1126      */
1127     function _beforeTokenTransfers(
1128         address from,
1129         address to,
1130         uint256 startTokenId,
1131         uint256 quantity
1132     ) internal virtual {}
1133 
1134     /**
1135      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1136      * minting.
1137      *
1138      * startTokenId - the first token id to be transferred
1139      * quantity - the amount to be transferred
1140      *
1141      * Calling conditions:
1142      *
1143      * - when `from` and `to` are both non-zero.
1144      * - `from` and `to` are never both zero.
1145      */
1146     function _afterTokenTransfers(
1147         address from,
1148         address to,
1149         uint256 startTokenId,
1150         uint256 quantity
1151     ) internal virtual {}
1152 }
1153 
1154 contract MeePunk is ERC721A, Ownable {
1155 
1156     string public baseURI = "ipfs://QmaQR8Cd87EA7w3T4qK5CQa9DaXxrwrEYT6NLX9UReziZ2/";
1157     string public contractURI = "ipfs://QmS59PYEwBeBwpmfz7k5zmEjTBQMygqNf6RBdMpckPa7iv";
1158     string public constant baseExtension = ".json";
1159     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1160 
1161     uint256 public constant MAX_PER_TX = 3;
1162     uint256 public constant MAX_PER_WALLET = 6;
1163     uint256 public constant MAX_SUPPLY = 1111;
1164     uint256 public constant price = 0.00 ether;
1165 
1166     bool public paused = false;
1167 
1168     mapping(address => uint256) public addressMinted;
1169 
1170     constructor() ERC721A("Yuga MeePunk", "MEEPUNK") {}
1171 
1172     function mint(uint256 _amount) external payable {
1173         address _caller = _msgSender();
1174         require(!paused, "Paused");
1175         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1176         require(_amount > 0, "No 0 mints");
1177         require(tx.origin == _caller, "No contracts");
1178         require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
1179         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1180         require(_amount * price == msg.value, "Invalid funds provided");
1181          addressMinted[msg.sender] += _amount;
1182         _safeMint(_caller, _amount);
1183     }
1184 
1185     function isApprovedForAll(address owner, address operator)
1186         override
1187         public
1188         view
1189         returns (bool)
1190     {
1191         // Whitelist OpenSea proxy contract for easy trading.
1192         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1193         if (address(proxyRegistry.proxies(owner)) == operator) {
1194             return true;
1195         }
1196 
1197         return super.isApprovedForAll(owner, operator);
1198     }
1199 
1200     function withdraw() external onlyOwner {
1201         uint256 balance = address(this).balance;
1202         (bool success, ) = _msgSender().call{value: balance}("");
1203         require(success, "Failed to send");
1204     }
1205 
1206     function pause(bool _state) external onlyOwner {
1207         paused = _state;
1208     }
1209 
1210     function setBaseURI(string memory baseURI_) external onlyOwner {
1211         baseURI = baseURI_;
1212     }
1213 
1214     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1215         require(_exists(_tokenId), "Token does not exist.");
1216         return bytes(baseURI).length > 0 ? string(
1217             abi.encodePacked(
1218               baseURI,
1219               Strings.toString(_tokenId),
1220               baseExtension
1221             )
1222         ) : "";
1223     }
1224 }
1225 
1226 contract OwnableDelegateProxy { }
1227 contract ProxyRegistry {
1228     mapping(address => OwnableDelegateProxy) public proxies;
1229 }