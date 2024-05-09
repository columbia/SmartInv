1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-16
3 */
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
6 
7 // SPDX-License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
39 
40 
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 
113 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
117 
118 
119 
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
128      */
129     function toString(uint256 value) internal pure returns (string memory) {
130         // Inspired by OraclizeAPI's implementation - MIT licence
131         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
132 
133         if (value == 0) {
134             return "0";
135         }
136         uint256 temp = value;
137         uint256 digits;
138         while (temp != 0) {
139             digits++;
140             temp /= 10;
141         }
142         bytes memory buffer = new bytes(digits);
143         while (value != 0) {
144             digits -= 1;
145             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
146             value /= 10;
147         }
148         return string(buffer);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
153      */
154     function toHexString(uint256 value) internal pure returns (string memory) {
155         if (value == 0) {
156             return "0x00";
157         }
158         uint256 temp = value;
159         uint256 length = 0;
160         while (temp != 0) {
161             length++;
162             temp >>= 8;
163         }
164         return toHexString(value, length);
165     }
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
169      */
170     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
171         bytes memory buffer = new bytes(2 * length + 2);
172         buffer[0] = "0";
173         buffer[1] = "x";
174         for (uint256 i = 2 * length + 1; i > 1; --i) {
175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
176             value >>= 4;
177         }
178         require(value == 0, "Strings: hex length insufficient");
179         return string(buffer);
180     }
181 }
182 
183 
184 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
185 
186 
187 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
188 
189 
190 
191 /**
192  * @dev Interface of the ERC165 standard, as defined in the
193  * https://eips.ethereum.org/EIPS/eip-165[EIP].
194  *
195  * Implementers can declare support of contract interfaces, which can then be
196  * queried by others ({ERC165Checker}).
197  *
198  * For an implementation, see {ERC165}.
199  */
200 interface IERC165 {
201     /**
202      * @dev Returns true if this contract implements the interface defined by
203      * `interfaceId`. See the corresponding
204      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
205      * to learn more about how these ids are created.
206      *
207      * This function call must use less than 30 000 gas.
208      */
209     function supportsInterface(bytes4 interfaceId) external view returns (bool);
210 }
211 
212 
213 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
214 
215 
216 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
217 
218 
219 
220 /**
221  * @dev Required interface of an ERC721 compliant contract.
222  */
223 interface IERC721 is IERC165 {
224     /**
225      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
228 
229     /**
230      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
231      */
232     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
233 
234     /**
235      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
236      */
237     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
238 
239     /**
240      * @dev Returns the number of tokens in ``owner``'s account.
241      */
242     function balanceOf(address owner) external view returns (uint256 balance);
243 
244     /**
245      * @dev Returns the owner of the `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function ownerOf(uint256 tokenId) external view returns (address owner);
252 
253     /**
254      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
255      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must exist and be owned by `from`.
262      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
263      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
264      *
265      * Emits a {Transfer} event.
266      */
267     function safeTransferFrom(
268         address from,
269         address to,
270         uint256 tokenId
271     ) external;
272 
273     /**
274      * @dev Transfers `tokenId` token from `from` to `to`.
275      *
276      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must be owned by `from`.
283      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
284      *
285      * Emits a {Transfer} event.
286      */
287     function transferFrom(
288         address from,
289         address to,
290         uint256 tokenId
291     ) external;
292 
293     /**
294      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
295      * The approval is cleared when the token is transferred.
296      *
297      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
298      *
299      * Requirements:
300      *
301      * - The caller must own the token or be an approved operator.
302      * - `tokenId` must exist.
303      *
304      * Emits an {Approval} event.
305      */
306     function approve(address to, uint256 tokenId) external;
307 
308     /**
309      * @dev Returns the account approved for `tokenId` token.
310      *
311      * Requirements:
312      *
313      * - `tokenId` must exist.
314      */
315     function getApproved(uint256 tokenId) external view returns (address operator);
316 
317     /**
318      * @dev Approve or remove `operator` as an operator for the caller.
319      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
320      *
321      * Requirements:
322      *
323      * - The `operator` cannot be the caller.
324      *
325      * Emits an {ApprovalForAll} event.
326      */
327     function setApprovalForAll(address operator, bool _approved) external;
328 
329     /**
330      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
331      *
332      * See {setApprovalForAll}
333      */
334     function isApprovedForAll(address owner, address operator) external view returns (bool);
335 
336     /**
337      * @dev Safely transfers `tokenId` token from `from` to `to`.
338      *
339      * Requirements:
340      *
341      * - `from` cannot be the zero address.
342      * - `to` cannot be the zero address.
343      * - `tokenId` token must exist and be owned by `from`.
344      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
345      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
346      *
347      * Emits a {Transfer} event.
348      */
349     function safeTransferFrom(
350         address from,
351         address to,
352         uint256 tokenId,
353         bytes calldata data
354     ) external;
355 }
356 
357 
358 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
362 
363 
364 
365 /**
366  * @title ERC721 token receiver interface
367  * @dev Interface for any contract that wants to support safeTransfers
368  * from ERC721 asset contracts.
369  */
370 interface IERC721Receiver {
371     /**
372      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
373      * by `operator` from `from`, this function is called.
374      *
375      * It must return its Solidity selector to confirm the token transfer.
376      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
377      *
378      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
379      */
380     function onERC721Received(
381         address operator,
382         address from,
383         uint256 tokenId,
384         bytes calldata data
385     ) external returns (bytes4);
386 }
387 
388 
389 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
393 
394 
395 
396 /**
397  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
398  * @dev See https://eips.ethereum.org/EIPS/eip-721
399  */
400 interface IERC721Metadata is IERC721 {
401     /**
402      * @dev Returns the token collection name.
403      */
404     function name() external view returns (string memory);
405 
406     /**
407      * @dev Returns the token collection symbol.
408      */
409     function symbol() external view returns (string memory);
410 
411     /**
412      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
413      */
414     function tokenURI(uint256 tokenId) external view returns (string memory);
415 }
416 
417 
418 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
422 
423 
424 
425 /**
426  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
427  * @dev See https://eips.ethereum.org/EIPS/eip-721
428  */
429 interface IERC721Enumerable is IERC721 {
430     /**
431      * @dev Returns the total amount of tokens stored by the contract.
432      */
433     function totalSupply() external view returns (uint256);
434 
435     /**
436      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
437      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
438      */
439     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
440 
441     /**
442      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
443      * Use along with {totalSupply} to enumerate all tokens.
444      */
445     function tokenByIndex(uint256 index) external view returns (uint256);
446 }
447 
448 
449 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
450 
451 
452 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
453 
454 
455 
456 /**
457  * @dev Collection of functions related to the address type
458  */
459 library Address {
460     /**
461      * @dev Returns true if `account` is a contract.
462      *
463      * [IMPORTANT]
464      * ====
465      * It is unsafe to assume that an address for which this function returns
466      * false is an externally-owned account (EOA) and not a contract.
467      *
468      * Among others, `isContract` will return false for the following
469      * types of addresses:
470      *
471      *  - an externally-owned account
472      *  - a contract in construction
473      *  - an address where a contract will be created
474      *  - an address where a contract lived, but was destroyed
475      * ====
476      */
477     function isContract(address account) internal view returns (bool) {
478         // This method relies on extcodesize, which returns 0 for contracts in
479         // construction, since the code is only stored at the end of the
480         // constructor execution.
481 
482         uint256 size;
483         assembly {
484             size := extcodesize(account)
485         }
486         return size > 0;
487     }
488 
489     /**
490      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
491      * `recipient`, forwarding all available gas and reverting on errors.
492      *
493      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
494      * of certain opcodes, possibly making contracts go over the 2300 gas limit
495      * imposed by `transfer`, making them unable to receive funds via
496      * `transfer`. {sendValue} removes this limitation.
497      *
498      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
499      *
500      * IMPORTANT: because control is transferred to `recipient`, care must be
501      * taken to not create reentrancy vulnerabilities. Consider using
502      * {ReentrancyGuard} or the
503      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
504      */
505     function sendValue(address payable recipient, uint256 amount) internal {
506         require(address(this).balance >= amount, "Address: insufficient balance");
507 
508         (bool success, ) = recipient.call{value: amount}("");
509         require(success, "Address: unable to send value, recipient may have reverted");
510     }
511 
512     /**
513      * @dev Performs a Solidity function call using a low level `call`. A
514      * plain `call` is an unsafe replacement for a function call: use this
515      * function instead.
516      *
517      * If `target` reverts with a revert reason, it is bubbled up by this
518      * function (like regular Solidity function calls).
519      *
520      * Returns the raw returned data. To convert to the expected return value,
521      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
522      *
523      * Requirements:
524      *
525      * - `target` must be a contract.
526      * - calling `target` with `data` must not revert.
527      *
528      * _Available since v3.1._
529      */
530     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
531         return functionCall(target, data, "Address: low-level call failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
536      * `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(
541         address target,
542         bytes memory data,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         return functionCallWithValue(target, data, 0, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but also transferring `value` wei to `target`.
551      *
552      * Requirements:
553      *
554      * - the calling contract must have an ETH balance of at least `value`.
555      * - the called Solidity function must be `payable`.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value
563     ) internal returns (bytes memory) {
564         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
569      * with `errorMessage` as a fallback revert reason when `target` reverts.
570      *
571      * _Available since v3.1._
572      */
573     function functionCallWithValue(
574         address target,
575         bytes memory data,
576         uint256 value,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         require(address(this).balance >= value, "Address: insufficient balance for call");
580         require(isContract(target), "Address: call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.call{value: value}(data);
583         return verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
593         return functionStaticCall(target, data, "Address: low-level static call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(
603         address target,
604         bytes memory data,
605         string memory errorMessage
606     ) internal view returns (bytes memory) {
607         require(isContract(target), "Address: static call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.staticcall(data);
610         return verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but performing a delegate call.
616      *
617      * _Available since v3.4._
618      */
619     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
620         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
625      * but performing a delegate call.
626      *
627      * _Available since v3.4._
628      */
629     function functionDelegateCall(
630         address target,
631         bytes memory data,
632         string memory errorMessage
633     ) internal returns (bytes memory) {
634         require(isContract(target), "Address: delegate call to non-contract");
635 
636         (bool success, bytes memory returndata) = target.delegatecall(data);
637         return verifyCallResult(success, returndata, errorMessage);
638     }
639 
640     /**
641      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
642      * revert reason using the provided one.
643      *
644      * _Available since v4.3._
645      */
646     function verifyCallResult(
647         bool success,
648         bytes memory returndata,
649         string memory errorMessage
650     ) internal pure returns (bytes memory) {
651         if (success) {
652             return returndata;
653         } else {
654             // Look for revert reason and bubble it up if present
655             if (returndata.length > 0) {
656                 // The easiest way to bubble the revert reason is using memory via assembly
657 
658                 assembly {
659                     let returndata_size := mload(returndata)
660                     revert(add(32, returndata), returndata_size)
661                 }
662             } else {
663                 revert(errorMessage);
664             }
665         }
666     }
667 }
668 
669 
670 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
674 
675 
676 
677 /**
678  * @dev Implementation of the {IERC165} interface.
679  *
680  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
681  * for the additional interface id that will be supported. For example:
682  *
683  * ```solidity
684  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
685  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
686  * }
687  * ```
688  *
689  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
690  */
691 abstract contract ERC165 is IERC165 {
692     /**
693      * @dev See {IERC165-supportsInterface}.
694      */
695     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
696         return interfaceId == type(IERC165).interfaceId;
697     }
698 }
699 
700 
701 // File contracts/ERC721A.sol
702 
703 
704 // Creator: Chiru Labs
705 
706 
707 /**
708  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
709  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
710  *
711  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
712  *
713  * Does not support burning tokens to address(0).
714  *
715  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
716  */
717 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
718     using Address for address;
719     using Strings for uint256;
720 
721     struct TokenOwnership {
722         address addr;
723         uint64 startTimestamp;
724     }
725 
726     struct AddressData {
727         uint128 balance;
728         uint128 numberMinted;
729     }
730 
731     uint256 internal currentIndex = 0;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to ownership details
740     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
741     mapping(uint256 => TokenOwnership) internal _ownerships;
742 
743     // Mapping owner address to address data
744     mapping(address => AddressData) private _addressData;
745 
746     // Mapping from token ID to approved address
747     mapping(uint256 => address) private _tokenApprovals;
748 
749     // Mapping from owner to operator approvals
750     mapping(address => mapping(address => bool)) private _operatorApprovals;
751 
752     constructor(string memory name_, string memory symbol_) {
753         _name = name_;
754         _symbol = symbol_;
755     }
756 
757     /**
758      * @dev See {IERC721Enumerable-totalSupply}.
759      */
760     function totalSupply() public view override returns (uint256) {
761         return currentIndex;
762     }
763 
764     /**
765      * @dev See {IERC721Enumerable-tokenByIndex}.
766      */
767     function tokenByIndex(uint256 index) public view override returns (uint256) {
768         require(index < totalSupply(), 'ERC721A: global index out of bounds');
769         return index;
770     }
771 
772     /**
773      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
774      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
775      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
776      */
777     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
778         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
779         uint256 numMintedSoFar = totalSupply();
780         uint256 tokenIdsIdx = 0;
781         address currOwnershipAddr = address(0);
782         for (uint256 i = 0; i < numMintedSoFar; i++) {
783             TokenOwnership memory ownership = _ownerships[i];
784             if (ownership.addr != address(0)) {
785                 currOwnershipAddr = ownership.addr;
786             }
787             if (currOwnershipAddr == owner) {
788                 if (tokenIdsIdx == index) {
789                     return i;
790                 }
791                 tokenIdsIdx++;
792             }
793         }
794         revert('ERC721A: unable to get token of owner by index');
795     }
796 
797     /**
798      * @dev See {IERC165-supportsInterface}.
799      */
800     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
801         return
802             interfaceId == type(IERC721).interfaceId ||
803             interfaceId == type(IERC721Metadata).interfaceId ||
804             interfaceId == type(IERC721Enumerable).interfaceId ||
805             super.supportsInterface(interfaceId);
806     }
807 
808     /**
809      * @dev See {IERC721-balanceOf}.
810      */
811     function balanceOf(address owner) public view override returns (uint256) {
812         require(owner != address(0), 'ERC721A: balance query for the zero address');
813         return uint256(_addressData[owner].balance);
814     }
815 
816     function _numberMinted(address owner) internal view returns (uint256) {
817         require(owner != address(0), 'ERC721A: number minted query for the zero address');
818         return uint256(_addressData[owner].numberMinted);
819     }
820 
821     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
822         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
823 
824         for (uint256 curr = tokenId; ; curr--) {
825             TokenOwnership memory ownership = _ownerships[curr];
826             if (ownership.addr != address(0)) {
827                 return ownership;
828             }
829         }
830 
831         revert('ERC721A: unable to determine the owner of token');
832     }
833 
834     /**
835      * @dev See {IERC721-ownerOf}.
836      */
837     function ownerOf(uint256 tokenId) public view override returns (address) {
838         return ownershipOf(tokenId).addr;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-name}.
843      */
844     function name() public view virtual override returns (string memory) {
845         return _name;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-symbol}.
850      */
851     function symbol() public view virtual override returns (string memory) {
852         return _symbol;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-tokenURI}.
857      */
858     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
859         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
860 
861         string memory baseURI = _baseURI();
862         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
863     }
864 
865     /**
866      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
867      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
868      * by default, can be overriden in child contracts.
869      */
870     function _baseURI() internal view virtual returns (string memory) {
871         return '';
872     }
873 
874     /**
875      * @dev See {IERC721-approve}.
876      */
877     function approve(address to, uint256 tokenId) public override {
878         address owner = ERC721A.ownerOf(tokenId);
879         require(to != owner, 'ERC721A: approval to current owner');
880 
881         require(
882             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
883             'ERC721A: approve caller is not owner nor approved for all'
884         );
885 
886         _approve(to, tokenId, owner);
887     }
888 
889     /**
890      * @dev See {IERC721-getApproved}.
891      */
892     function getApproved(uint256 tokenId) public view override returns (address) {
893         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
894 
895         return _tokenApprovals[tokenId];
896     }
897 
898     /**
899      * @dev See {IERC721-setApprovalForAll}.
900      */
901     function setApprovalForAll(address operator, bool approved) public override {
902         require(operator != _msgSender(), 'ERC721A: approve to caller');
903 
904         _operatorApprovals[_msgSender()][operator] = approved;
905         emit ApprovalForAll(_msgSender(), operator, approved);
906     }
907 
908     /**
909      * @dev See {IERC721-isApprovedForAll}.
910      */
911     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
912         return _operatorApprovals[owner][operator];
913     }
914 
915     /**
916      * @dev See {IERC721-transferFrom}.
917      */
918     function transferFrom(
919         address from,
920         address to,
921         uint256 tokenId
922     ) public override {
923         _transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public override {
934         safeTransferFrom(from, to, tokenId, '');
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) public override {
946         _transfer(from, to, tokenId);
947         require(
948             _checkOnERC721Received(from, to, tokenId, _data),
949             'ERC721A: transfer to non ERC721Receiver implementer'
950         );
951     }
952 
953     /**
954      * @dev Returns whether `tokenId` exists.
955      *
956      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
957      *
958      * Tokens start existing when they are minted (`_mint`),
959      */
960     function _exists(uint256 tokenId) internal view returns (bool) {
961         return tokenId < currentIndex;
962     }
963 
964     function _safeMint(address to, uint256 quantity) internal {
965         _safeMint(to, quantity, '');
966     }
967 
968     /**
969      * @dev Mints `quantity` tokens and transfers them to `to`.
970      *
971      * Requirements:
972      *
973      * - `to` cannot be the zero address.
974      * - `quantity` cannot be larger than the max batch size.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _safeMint(
979         address to,
980         uint256 quantity,
981         bytes memory _data
982     ) internal {
983         uint256 startTokenId = currentIndex;
984         require(to != address(0), 'ERC721A: mint to the zero address');
985         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
986         require(!_exists(startTokenId), 'ERC721A: token already minted');
987         require(quantity > 0, 'ERC721A: quantity must be greater 0');
988 
989         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
990 
991         AddressData memory addressData = _addressData[to];
992         _addressData[to] = AddressData(
993             addressData.balance + uint128(quantity),
994             addressData.numberMinted + uint128(quantity)
995         );
996         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
997 
998         uint256 updatedIndex = startTokenId;
999 
1000         for (uint256 i = 0; i < quantity; i++) {
1001             emit Transfer(address(0), to, updatedIndex);
1002             require(
1003                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1004                 'ERC721A: transfer to non ERC721Receiver implementer'
1005             );
1006             updatedIndex++;
1007         }
1008 
1009         currentIndex = updatedIndex;
1010         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1011     }
1012 
1013     /**
1014      * @dev Transfers `tokenId` from `from` to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must be owned by `from`.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _transfer(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) private {
1028         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1029 
1030         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1031             getApproved(tokenId) == _msgSender() ||
1032             isApprovedForAll(prevOwnership.addr, _msgSender()));
1033 
1034         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1035 
1036         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1037         require(to != address(0), 'ERC721A: transfer to the zero address');
1038 
1039         _beforeTokenTransfers(from, to, tokenId, 1);
1040 
1041         // Clear approvals from the previous owner
1042         _approve(address(0), tokenId, prevOwnership.addr);
1043 
1044         // Underflow of the sender's balance is impossible because we check for
1045         // ownership above and the recipient's balance can't realistically overflow.
1046         unchecked {
1047             _addressData[from].balance -= 1;
1048             _addressData[to].balance += 1;
1049         }
1050 
1051         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1052 
1053         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1054         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1055         uint256 nextTokenId = tokenId + 1;
1056         if (_ownerships[nextTokenId].addr == address(0)) {
1057             if (_exists(nextTokenId)) {
1058                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1059             }
1060         }
1061 
1062         emit Transfer(from, to, tokenId);
1063         _afterTokenTransfers(from, to, tokenId, 1);
1064     }
1065 
1066     /**
1067      * @dev Approve `to` to operate on `tokenId`
1068      *
1069      * Emits a {Approval} event.
1070      */
1071     function _approve(
1072         address to,
1073         uint256 tokenId,
1074         address owner
1075     ) private {
1076         _tokenApprovals[tokenId] = to;
1077         emit Approval(owner, to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1082      * The call is not executed if the target address is not a contract.
1083      *
1084      * @param from address representing the previous owner of the given token ID
1085      * @param to target address that will receive the tokens
1086      * @param tokenId uint256 ID of the token to be transferred
1087      * @param _data bytes optional data to send along with the call
1088      * @return bool whether the call correctly returned the expected magic value
1089      */
1090     function _checkOnERC721Received(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) private returns (bool) {
1096         if (to.isContract()) {
1097             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1098                 return retval == IERC721Receiver(to).onERC721Received.selector;
1099             } catch (bytes memory reason) {
1100                 if (reason.length == 0) {
1101                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1102                 } else {
1103                     assembly {
1104                         revert(add(32, reason), mload(reason))
1105                     }
1106                 }
1107             }
1108         } else {
1109             return true;
1110         }
1111     }
1112 
1113     /**
1114      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1115      *
1116      * startTokenId - the first token id to be transferred
1117      * quantity - the amount to be transferred
1118      *
1119      * Calling conditions:
1120      *
1121      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1122      * transferred to `to`.
1123      * - When `from` is zero, `tokenId` will be minted for `to`.
1124      */
1125     function _beforeTokenTransfers(
1126         address from,
1127         address to,
1128         uint256 startTokenId,
1129         uint256 quantity
1130     ) internal virtual {}
1131 
1132     /**
1133      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1134      * minting.
1135      *
1136      * startTokenId - the first token id to be transferred
1137      * quantity - the amount to be transferred
1138      *
1139      * Calling conditions:
1140      *
1141      * - when `from` and `to` are both non-zero.
1142      * - `from` and `to` are never both zero.
1143      */
1144     function _afterTokenTransfers(
1145         address from,
1146         address to,
1147         uint256 startTokenId,
1148         uint256 quantity
1149     ) internal virtual {}
1150 }
1151 
1152 
1153 
1154 
1155 contract hmfers is ERC721A, Ownable {
1156 
1157     string public baseURI = "";
1158     string public contractURI = "";
1159     string public constant baseExtension = ".json";
1160     // Mainnet - 0xa5409ec958C83C3f309868babACA7c86DCB077c1
1161     // Rinkeby - 0xF57B2c51dED3A29e6891aba85459d600256Cf317
1162     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1163 
1164     uint256 public constant MAX_PER_TX_FREE = 10;
1165     uint256 public constant MAX_PER_TX = 20;
1166     uint256 public constant FREE_MAX_SUPPLY = 420;
1167     uint256 public constant MAX_SUPPLY = 6969;
1168     uint256 public constant price = 0.001 ether;
1169 
1170     bool public paused = true;
1171 
1172     constructor() ERC721A("Habibi Mfers", "hmfers") {}
1173 
1174     function mint(uint256 _amount) external payable {
1175         address _caller = _msgSender();
1176         require(!paused, "Paused");
1177         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1178         require(_amount > 0, "No 0 mints");
1179         require(tx.origin == _caller, "No contracts");
1180 
1181         if(FREE_MAX_SUPPLY >= totalSupply()){
1182             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1183         }else{
1184             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1185             require(_amount * price == msg.value, "Invalid funds provided");
1186         }
1187 
1188         _safeMint(_caller, _amount);
1189     }
1190 
1191     function isApprovedForAll(address owner, address operator)
1192         override
1193         public
1194         view
1195         returns (bool)
1196     {
1197         // Whitelist OpenSea proxy contract for easy trading.
1198         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1199         if (address(proxyRegistry.proxies(owner)) == operator) {
1200             return true;
1201         }
1202 
1203         return super.isApprovedForAll(owner, operator);
1204     }
1205 
1206     function withdraw() external onlyOwner {
1207         uint256 balance = address(this).balance;
1208         (bool success, ) = _msgSender().call{value: balance}("");
1209         require(success, "Failed to send");
1210     }
1211 
1212     function setupOS() external onlyOwner {
1213         _safeMint(_msgSender(), 1);
1214     }
1215 
1216     function pause(bool _state) external onlyOwner {
1217         paused = _state;
1218     }
1219 
1220     function setBaseURI(string memory baseURI_) external onlyOwner {
1221         baseURI = baseURI_;
1222     }
1223 
1224     function setContractURI(string memory _contractURI) external onlyOwner {
1225         contractURI = _contractURI;
1226     }
1227 
1228     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1229         require(_exists(_tokenId), "Token does not exist.");
1230         return bytes(baseURI).length > 0 ? string(
1231             abi.encodePacked(
1232               baseURI,
1233               Strings.toString(_tokenId),
1234               baseExtension
1235             )
1236         ) : "";
1237     }
1238 }
1239 
1240 contract OwnableDelegateProxy { }
1241 contract ProxyRegistry {
1242     mapping(address => OwnableDelegateProxy) public proxies;
1243 }