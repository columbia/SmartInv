1 // File: contracts/AiLlama.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-05-30
5 */
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
8 // SPDX-License-Identifier: MIT
9 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
10 
11 /*
12 
13  █████╗ ██╗    
14 ██╔══██╗██║      
15 ██╔══██║██║      
16 ██║  ██║██║       
17 ╚═╝  ╚═╝╚═╝          
18 
19 */
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 
44 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
45 
46 
47 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
48 
49 
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 
122 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
126 
127 
128 
129 /**
130  * @dev String operations.
131  */
132 library Strings {
133     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
137      */
138     function toString(uint256 value) internal pure returns (string memory) {
139         // Inspired by OraclizeAPI's implementation - MIT licence
140         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
141 
142         if (value == 0) {
143             return "0";
144         }
145         uint256 temp = value;
146         uint256 digits;
147         while (temp != 0) {
148             digits++;
149             temp /= 10;
150         }
151         bytes memory buffer = new bytes(digits);
152         while (value != 0) {
153             digits -= 1;
154             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
155             value /= 10;
156         }
157         return string(buffer);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
162      */
163     function toHexString(uint256 value) internal pure returns (string memory) {
164         if (value == 0) {
165             return "0x00";
166         }
167         uint256 temp = value;
168         uint256 length = 0;
169         while (temp != 0) {
170             length++;
171             temp >>= 8;
172         }
173         return toHexString(value, length);
174     }
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
178      */
179     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
180         bytes memory buffer = new bytes(2 * length + 2);
181         buffer[0] = "0";
182         buffer[1] = "x";
183         for (uint256 i = 2 * length + 1; i > 1; --i) {
184             buffer[i] = _HEX_SYMBOLS[value & 0xf];
185             value >>= 4;
186         }
187         require(value == 0, "Strings: hex length insufficient");
188         return string(buffer);
189     }
190 }
191 
192 
193 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
194 
195 
196 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
197 
198 
199 
200 /**
201  * @dev Interface of the ERC165 standard, as defined in the
202  * https://eips.ethereum.org/EIPS/eip-165[EIP].
203  *
204  * Implementers can declare support of contract interfaces, which can then be
205  * queried by others ({ERC165Checker}).
206  *
207  * For an implementation, see {ERC165}.
208  */
209 interface IERC165 {
210     /**
211      * @dev Returns true if this contract implements the interface defined by
212      * `interfaceId`. See the corresponding
213      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
214      * to learn more about how these ids are created.
215      *
216      * This function call must use less than 30 000 gas.
217      */
218     function supportsInterface(bytes4 interfaceId) external view returns (bool);
219 }
220 
221 
222 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
226 
227 
228 
229 /**
230  * @dev Required interface of an ERC721 compliant contract.
231  */
232 interface IERC721 is IERC165 {
233     /**
234      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
235      */
236     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
237 
238     /**
239      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
240      */
241     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
245      */
246     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
247 
248     /**
249      * @dev Returns the number of tokens in ``owner``'s account.
250      */
251     function balanceOf(address owner) external view returns (uint256 balance);
252 
253     /**
254      * @dev Returns the owner of the `tokenId` token.
255      *
256      * Requirements:
257      *
258      * - `tokenId` must exist.
259      */
260     function ownerOf(uint256 tokenId) external view returns (address owner);
261 
262     /**
263      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
264      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
265      *
266      * Requirements:
267      *
268      * - `from` cannot be the zero address.
269      * - `to` cannot be the zero address.
270      * - `tokenId` token must exist and be owned by `from`.
271      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
272      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
273      *
274      * Emits a {Transfer} event.
275      */
276     function safeTransferFrom(
277         address from,
278         address to,
279         uint256 tokenId
280     ) external;
281 
282     /**
283      * @dev Transfers `tokenId` token from `from` to `to`.
284      *
285      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
286      *
287      * Requirements:
288      *
289      * - `from` cannot be the zero address.
290      * - `to` cannot be the zero address.
291      * - `tokenId` token must be owned by `from`.
292      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
293      *
294      * Emits a {Transfer} event.
295      */
296     function transferFrom(
297         address from,
298         address to,
299         uint256 tokenId
300     ) external;
301 
302     /**
303      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
304      * The approval is cleared when the token is transferred.
305      *
306      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
307      *
308      * Requirements:
309      *
310      * - The caller must own the token or be an approved operator.
311      * - `tokenId` must exist.
312      *
313      * Emits an {Approval} event.
314      */
315     function approve(address to, uint256 tokenId) external;
316 
317     /**
318      * @dev Returns the account approved for `tokenId` token.
319      *
320      * Requirements:
321      *
322      * - `tokenId` must exist.
323      */
324     function getApproved(uint256 tokenId) external view returns (address operator);
325 
326     /**
327      * @dev Approve or remove `operator` as an operator for the caller.
328      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
329      *
330      * Requirements:
331      *
332      * - The `operator` cannot be the caller.
333      *
334      * Emits an {ApprovalForAll} event.
335      */
336     function setApprovalForAll(address operator, bool _approved) external;
337 
338     /**
339      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
340      *
341      * See {setApprovalForAll}
342      */
343     function isApprovedForAll(address owner, address operator) external view returns (bool);
344 
345     /**
346      * @dev Safely transfers `tokenId` token from `from` to `to`.
347      *
348      * Requirements:
349      *
350      * - `from` cannot be the zero address.
351      * - `to` cannot be the zero address.
352      * - `tokenId` token must exist and be owned by `from`.
353      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
354      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
355      *
356      * Emits a {Transfer} event.
357      */
358     function safeTransferFrom(
359         address from,
360         address to,
361         uint256 tokenId,
362         bytes calldata data
363     ) external;
364 }
365 
366 
367 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
371 
372 
373 
374 /**
375  * @title ERC721 token receiver interface
376  * @dev Interface for any contract that wants to support safeTransfers
377  * from ERC721 asset contracts.
378  */
379 interface IERC721Receiver {
380     /**
381      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
382      * by `operator` from `from`, this function is called.
383      *
384      * It must return its Solidity selector to confirm the token transfer.
385      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
386      *
387      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
388      */
389     function onERC721Received(
390         address operator,
391         address from,
392         uint256 tokenId,
393         bytes calldata data
394     ) external returns (bytes4);
395 }
396 
397 
398 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
402 
403 
404 
405 /**
406  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
407  * @dev See https://eips.ethereum.org/EIPS/eip-721
408  */
409 interface IERC721Metadata is IERC721 {
410     /**
411      * @dev Returns the token collection name.
412      */
413     function name() external view returns (string memory);
414 
415     /**
416      * @dev Returns the token collection symbol.
417      */
418     function symbol() external view returns (string memory);
419 
420     /**
421      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
422      */
423     function tokenURI(uint256 tokenId) external view returns (string memory);
424 }
425 
426 
427 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
428 
429 
430 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
431 
432 
433 
434 /**
435  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
436  * @dev See https://eips.ethereum.org/EIPS/eip-721
437  */
438 interface IERC721Enumerable is IERC721 {
439     /**
440      * @dev Returns the total amount of tokens stored by the contract.
441      */
442     function totalSupply() external view returns (uint256);
443 
444     /**
445      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
446      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
447      */
448     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
449 
450     /**
451      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
452      * Use along with {totalSupply} to enumerate all tokens.
453      */
454     function tokenByIndex(uint256 index) external view returns (uint256);
455 }
456 
457 
458 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
462 
463 
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      */
486     function isContract(address account) internal view returns (bool) {
487         // This method relies on extcodesize, which returns 0 for contracts in
488         // construction, since the code is only stored at the end of the
489         // constructor execution.
490 
491         uint256 size;
492         assembly {
493             size := extcodesize(account)
494         }
495         return size > 0;
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         (bool success, ) = recipient.call{value: amount}("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 
521     /**
522      * @dev Performs a Solidity function call using a low level `call`. A
523      * plain `call` is an unsafe replacement for a function call: use this
524      * function instead.
525      *
526      * If `target` reverts with a revert reason, it is bubbled up by this
527      * function (like regular Solidity function calls).
528      *
529      * Returns the raw returned data. To convert to the expected return value,
530      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
531      *
532      * Requirements:
533      *
534      * - `target` must be a contract.
535      * - calling `target` with `data` must not revert.
536      *
537      * _Available since v3.1._
538      */
539     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
540         return functionCall(target, data, "Address: low-level call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
545      * `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, 0, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but also transferring `value` wei to `target`.
560      *
561      * Requirements:
562      *
563      * - the calling contract must have an ETH balance of at least `value`.
564      * - the called Solidity function must be `payable`.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(
583         address target,
584         bytes memory data,
585         uint256 value,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(address(this).balance >= value, "Address: insufficient balance for call");
589         require(isContract(target), "Address: call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.call{value: value}(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a static call.
598      *
599      * _Available since v3.3._
600      */
601     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
602         return functionStaticCall(target, data, "Address: low-level static call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a static call.
608      *
609      * _Available since v3.3._
610      */
611     function functionStaticCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal view returns (bytes memory) {
616         require(isContract(target), "Address: static call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.staticcall(data);
619         return verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
624      * but performing a delegate call.
625      *
626      * _Available since v3.4._
627      */
628     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
629         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
634      * but performing a delegate call.
635      *
636      * _Available since v3.4._
637      */
638     function functionDelegateCall(
639         address target,
640         bytes memory data,
641         string memory errorMessage
642     ) internal returns (bytes memory) {
643         require(isContract(target), "Address: delegate call to non-contract");
644 
645         (bool success, bytes memory returndata) = target.delegatecall(data);
646         return verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
651      * revert reason using the provided one.
652      *
653      * _Available since v4.3._
654      */
655     function verifyCallResult(
656         bool success,
657         bytes memory returndata,
658         string memory errorMessage
659     ) internal pure returns (bytes memory) {
660         if (success) {
661             return returndata;
662         } else {
663             // Look for revert reason and bubble it up if present
664             if (returndata.length > 0) {
665                 // The easiest way to bubble the revert reason is using memory via assembly
666 
667                 assembly {
668                     let returndata_size := mload(returndata)
669                     revert(add(32, returndata), returndata_size)
670                 }
671             } else {
672                 revert(errorMessage);
673             }
674         }
675     }
676 }
677 
678 
679 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
683 
684 
685 
686 /**
687  * @dev Implementation of the {IERC165} interface.
688  *
689  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
690  * for the additional interface id that will be supported. For example:
691  *
692  * ```solidity
693  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
695  * }
696  * ```
697  *
698  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
699  */
700 abstract contract ERC165 is IERC165 {
701     /**
702      * @dev See {IERC165-supportsInterface}.
703      */
704     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
705         return interfaceId == type(IERC165).interfaceId;
706     }
707 }
708 
709 
710 // File contracts/ERC721A.sol
711 
712 
713 // Creator: Chiru Labs
714 
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
719  *
720  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
721  *
722  * Does not support burning tokens to address(0).
723  *
724  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
725  */
726 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
727     using Address for address;
728     using Strings for uint256;
729 
730     struct TokenOwnership {
731         address addr;
732         uint64 startTimestamp;
733     }
734 
735     struct AddressData {
736         uint128 balance;
737         uint128 numberMinted;
738     }
739 
740     uint256 internal currentIndex = 1;
741 
742     // Token name
743     string private _name;
744 
745     // Token symbol
746     string private _symbol;
747 
748     // Mapping from token ID to ownership details
749     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
750     mapping(uint256 => TokenOwnership) internal _ownerships;
751 
752     // Mapping owner address to address data
753     mapping(address => AddressData) private _addressData;
754 
755     // Mapping from token ID to approved address
756     mapping(uint256 => address) private _tokenApprovals;
757 
758     // Mapping from owner to operator approvals
759     mapping(address => mapping(address => bool)) private _operatorApprovals;
760 
761     constructor(string memory name_, string memory symbol_) {
762         _name = name_;
763         _symbol = symbol_;
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
833         for (uint256 curr = tokenId; ; curr--) {
834             TokenOwnership memory ownership = _ownerships[curr];
835             if (ownership.addr != address(0)) {
836                 return ownership;
837             }
838         }
839 
840         revert('ERC721A: unable to determine the owner of token');
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId) public view override returns (address) {
847         return ownershipOf(tokenId).addr;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return '';
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public override {
887         address owner = ERC721A.ownerOf(tokenId);
888         require(to != owner, 'ERC721A: approval to current owner');
889 
890         require(
891             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892             'ERC721A: approve caller is not owner nor approved for all'
893         );
894 
895         _approve(to, tokenId, owner);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view override returns (address) {
902         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public override {
911         require(operator != _msgSender(), 'ERC721A: approve to caller');
912 
913         _operatorApprovals[_msgSender()][operator] = approved;
914         emit ApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public override {
932         _transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public override {
943         safeTransferFrom(from, to, tokenId, '');
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) public override {
955         _transfer(from, to, tokenId);
956         require(
957             _checkOnERC721Received(from, to, tokenId, _data),
958             'ERC721A: transfer to non ERC721Receiver implementer'
959         );
960     }
961 
962     /**
963      * @dev Returns whether `tokenId` exists.
964      *
965      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
966      *
967      * Tokens start existing when they are minted (`_mint`),
968      */
969     function _exists(uint256 tokenId) internal view returns (bool) {
970         return tokenId < currentIndex;
971     }
972 
973     function _safeMint(address to, uint256 quantity) internal {
974         _safeMint(to, quantity, '');
975     }
976 
977     /**
978      * @dev Mints `quantity` tokens and transfers them to `to`.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `quantity` cannot be larger than the max batch size.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _safeMint(
988         address to,
989         uint256 quantity,
990         bytes memory _data
991     ) internal {
992         uint256 startTokenId = currentIndex;
993         require(to != address(0), 'ERC721A: mint to the zero address');
994         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
995         require(!_exists(startTokenId), 'ERC721A: token already minted');
996         require(quantity > 0, 'ERC721A: quantity must be greater 0');
997 
998         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
999 
1000         AddressData memory addressData = _addressData[to];
1001         _addressData[to] = AddressData(
1002             addressData.balance + uint128(quantity),
1003             addressData.numberMinted + uint128(quantity)
1004         );
1005         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1006 
1007         uint256 updatedIndex = startTokenId;
1008 
1009         for (uint256 i = 0; i < quantity; i++) {
1010             emit Transfer(address(0), to, updatedIndex);
1011             require(
1012                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1013                 'ERC721A: transfer to non ERC721Receiver implementer'
1014             );
1015             updatedIndex++;
1016         }
1017 
1018         currentIndex = updatedIndex;
1019         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1020     }
1021 
1022     /**
1023      * @dev Transfers `tokenId` from `from` to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must be owned by `from`.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _transfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) private {
1037         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1038 
1039         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1040             getApproved(tokenId) == _msgSender() ||
1041             isApprovedForAll(prevOwnership.addr, _msgSender()));
1042 
1043         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1044 
1045         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1046         require(to != address(0), 'ERC721A: transfer to the zero address');
1047 
1048         _beforeTokenTransfers(from, to, tokenId, 1);
1049 
1050         // Clear approvals from the previous owner
1051         _approve(address(0), tokenId, prevOwnership.addr);
1052 
1053         // Underflow of the sender's balance is impossible because we check for
1054         // ownership above and the recipient's balance can't realistically overflow.
1055         unchecked {
1056             _addressData[from].balance -= 1;
1057             _addressData[to].balance += 1;
1058         }
1059 
1060         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1061 
1062         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1063         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1064         uint256 nextTokenId = tokenId + 1;
1065         if (_ownerships[nextTokenId].addr == address(0)) {
1066             if (_exists(nextTokenId)) {
1067                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1068             }
1069         }
1070 
1071         emit Transfer(from, to, tokenId);
1072         _afterTokenTransfers(from, to, tokenId, 1);
1073     }
1074 
1075     /**
1076      * @dev Approve `to` to operate on `tokenId`
1077      *
1078      * Emits a {Approval} event.
1079      */
1080     function _approve(
1081         address to,
1082         uint256 tokenId,
1083         address owner
1084     ) private {
1085         _tokenApprovals[tokenId] = to;
1086         emit Approval(owner, to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param _data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1107                 return retval == IERC721Receiver(to).onERC721Received.selector;
1108             } catch (bytes memory reason) {
1109                 if (reason.length == 0) {
1110                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1111                 } else {
1112                     assembly {
1113                         revert(add(32, reason), mload(reason))
1114                     }
1115                 }
1116             }
1117         } else {
1118             return true;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1124      *
1125      * startTokenId - the first token id to be transferred
1126      * quantity - the amount to be transferred
1127      *
1128      * Calling conditions:
1129      *
1130      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1131      * transferred to `to`.
1132      * - When `from` is zero, `tokenId` will be minted for `to`.
1133      */
1134     function _beforeTokenTransfers(
1135         address from,
1136         address to,
1137         uint256 startTokenId,
1138         uint256 quantity
1139     ) internal virtual {}
1140 
1141     /**
1142      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1143      * minting.
1144      *
1145      * startTokenId - the first token id to be transferred
1146      * quantity - the amount to be transferred
1147      *
1148      * Calling conditions:
1149      *
1150      * - when `from` and `to` are both non-zero.
1151      * - `from` and `to` are never both zero.
1152      */
1153     function _afterTokenTransfers(
1154         address from,
1155         address to,
1156         uint256 startTokenId,
1157         uint256 quantity
1158     ) internal virtual {}
1159 }
1160 
1161 
1162 // File contracts/AILlama.sol
1163 
1164 
1165 contract AILlama is ERC721A, Ownable {
1166 
1167     string public baseURI = "";
1168     string public contractURI = "";
1169     string public constant baseExtension = ".json";
1170     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1171 
1172     uint256 public constant MAX_PER_TX_FREE = 4;
1173     uint256 public constant MAX_PER_TX = 8;
1174     uint256 public constant FREE_MAX_SUPPLY = 1500;
1175     uint256 public constant MAX_SUPPLY = 3501;
1176     uint256 public price = 0.005 ether;
1177 
1178     bool public paused = true;
1179 
1180     constructor() ERC721A("AILlama", "AIL") {}
1181 
1182     function mint(uint256 _amount) external payable {
1183         address _caller = _msgSender();
1184         require(!paused, "Paused");
1185         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1186         require(_amount > 0, "No 0 mints");
1187         require(tx.origin == _caller, "No contracts");
1188 
1189         if(FREE_MAX_SUPPLY >= totalSupply()){
1190             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1191         }else{
1192             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1193             require(_amount * price == msg.value, "Invalid funds provided");
1194         }
1195 
1196         _safeMint(_caller, _amount);
1197     }
1198 
1199     function setCost(uint256 _newCost) public onlyOwner {
1200         price = _newCost;
1201     }
1202 
1203     function isApprovedForAll(address owner, address operator)
1204         override
1205         public
1206         view
1207         returns (bool)
1208     {
1209         // Whitelist OpenSea proxy contract for easy trading.
1210         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1211         if (address(proxyRegistry.proxies(owner)) == operator) {
1212             return true;
1213         }
1214 
1215         return super.isApprovedForAll(owner, operator);
1216     }
1217 
1218     function withdraw() external onlyOwner {
1219         uint256 balance = address(this).balance;
1220         (bool success, ) = _msgSender().call{value: balance}("");
1221         require(success, "Failed to send");
1222     }
1223 
1224     function setupOS() external onlyOwner {
1225         _safeMint(_msgSender(), 1);
1226     }
1227 
1228     function pause(bool _state) external onlyOwner {
1229         paused = _state;
1230     }
1231 
1232     function setBaseURI(string memory baseURI_) external onlyOwner {
1233         baseURI = baseURI_;
1234     }
1235 
1236     function setContractURI(string memory _contractURI) external onlyOwner {
1237         contractURI = _contractURI;
1238     }
1239 
1240     function Currentprice() public view returns (uint256){
1241         if (FREE_MAX_SUPPLY >= totalSupply()) {
1242             return 0;
1243         }else{
1244             return price;
1245         }
1246     }
1247 
1248     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1249         require(_exists(_tokenId), "Token does not exist.");
1250         return bytes(baseURI).length > 0 ? string(
1251             abi.encodePacked(
1252               baseURI,
1253               Strings.toString(_tokenId),
1254               baseExtension
1255             )
1256         ) : "";
1257     }
1258 }
1259 
1260 contract OwnableDelegateProxy { }
1261 contract ProxyRegistry {
1262     mapping(address => OwnableDelegateProxy) public proxies;
1263 }