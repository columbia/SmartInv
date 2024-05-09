1 // File: contracts/LetterQ.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 
106 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
110 
111 
112 
113 /**
114  * @dev String operations.
115  */
116 library Strings {
117     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
121      */
122     function toString(uint256 value) internal pure returns (string memory) {
123         // Inspired by OraclizeAPI's implementation - MIT licence
124         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
125 
126         if (value == 0) {
127             return "0";
128         }
129         uint256 temp = value;
130         uint256 digits;
131         while (temp != 0) {
132             digits++;
133             temp /= 10;
134         }
135         bytes memory buffer = new bytes(digits);
136         while (value != 0) {
137             digits -= 1;
138             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
139             value /= 10;
140         }
141         return string(buffer);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
146      */
147     function toHexString(uint256 value) internal pure returns (string memory) {
148         if (value == 0) {
149             return "0x00";
150         }
151         uint256 temp = value;
152         uint256 length = 0;
153         while (temp != 0) {
154             length++;
155             temp >>= 8;
156         }
157         return toHexString(value, length);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
162      */
163     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
164         bytes memory buffer = new bytes(2 * length + 2);
165         buffer[0] = "0";
166         buffer[1] = "x";
167         for (uint256 i = 2 * length + 1; i > 1; --i) {
168             buffer[i] = _HEX_SYMBOLS[value & 0xf];
169             value >>= 4;
170         }
171         require(value == 0, "Strings: hex length insufficient");
172         return string(buffer);
173     }
174 }
175 
176 
177 
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
181 
182 
183 
184 /**
185  * @dev Interface of the ERC165 standard, as defined in the
186  * https://eips.ethereum.org/EIPS/eip-165[EIP].
187  *
188  * Implementers can declare support of contract interfaces, which can then be
189  * queried by others ({ERC165Checker}).
190  *
191  * For an implementation, see {ERC165}.
192  */
193 interface IERC165 {
194     /**
195      * @dev Returns true if this contract implements the interface defined by
196      * `interfaceId`. See the corresponding
197      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
198      * to learn more about how these ids are created.
199      *
200      * This function call must use less than 30 000 gas.
201      */
202     function supportsInterface(bytes4 interfaceId) external view returns (bool);
203 }
204 
205 
206 
207 
208 
209 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
210 
211 
212 
213 /**
214  * @dev Required interface of an ERC721 compliant contract.
215  */
216 interface IERC721 is IERC165 {
217     /**
218      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
219      */
220     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
221 
222     /**
223      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
224      */
225     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
226 
227     /**
228      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
229      */
230     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
231 
232     /**
233      * @dev Returns the number of tokens in ``owner``'s account.
234      */
235     function balanceOf(address owner) external view returns (uint256 balance);
236 
237     /**
238      * @dev Returns the owner of the `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function ownerOf(uint256 tokenId) external view returns (address owner);
245 
246     /**
247      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
248      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId
264     ) external;
265 
266     /**
267      * @dev Transfers `tokenId` token from `from` to `to`.
268      *
269      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must be owned by `from`.
276      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transferFrom(
281         address from,
282         address to,
283         uint256 tokenId
284     ) external;
285 
286     /**
287      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
288      * The approval is cleared when the token is transferred.
289      *
290      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
291      *
292      * Requirements:
293      *
294      * - The caller must own the token or be an approved operator.
295      * - `tokenId` must exist.
296      *
297      * Emits an {Approval} event.
298      */
299     function approve(address to, uint256 tokenId) external;
300 
301     /**
302      * @dev Returns the account approved for `tokenId` token.
303      *
304      * Requirements:
305      *
306      * - `tokenId` must exist.
307      */
308     function getApproved(uint256 tokenId) external view returns (address operator);
309 
310     /**
311      * @dev Approve or remove `operator` as an operator for the caller.
312      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
313      *
314      * Requirements:
315      *
316      * - The `operator` cannot be the caller.
317      *
318      * Emits an {ApprovalForAll} event.
319      */
320     function setApprovalForAll(address operator, bool _approved) external;
321 
322     /**
323      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
324      *
325      * See {setApprovalForAll}
326      */
327     function isApprovedForAll(address owner, address operator) external view returns (bool);
328 
329     /**
330      * @dev Safely transfers `tokenId` token from `from` to `to`.
331      *
332      * Requirements:
333      *
334      * - `from` cannot be the zero address.
335      * - `to` cannot be the zero address.
336      * - `tokenId` token must exist and be owned by `from`.
337      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
338      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
339      *
340      * Emits a {Transfer} event.
341      */
342     function safeTransferFrom(
343         address from,
344         address to,
345         uint256 tokenId,
346         bytes calldata data
347     ) external;
348 }
349 
350 
351 
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
355 
356 
357 
358 /**
359  * @title ERC721 token receiver interface
360  * @dev Interface for any contract that wants to support safeTransfers
361  * from ERC721 asset contracts.
362  */
363 interface IERC721Receiver {
364     /**
365      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
366      * by `operator` from `from`, this function is called.
367      *
368      * It must return its Solidity selector to confirm the token transfer.
369      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
370      *
371      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
372      */
373     function onERC721Received(
374         address operator,
375         address from,
376         uint256 tokenId,
377         bytes calldata data
378     ) external returns (bytes4);
379 }
380 
381 
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
385 
386 
387 
388 /**
389  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
390  * @dev See https://eips.ethereum.org/EIPS/eip-721
391  */
392 interface IERC721Metadata is IERC721 {
393     /**
394      * @dev Returns the token collection name.
395      */
396     function name() external view returns (string memory);
397 
398     /**
399      * @dev Returns the token collection symbol.
400      */
401     function symbol() external view returns (string memory);
402 
403     /**
404      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
405      */
406     function tokenURI(uint256 tokenId) external view returns (string memory);
407 }
408 
409 
410 
411 
412 
413 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
414 
415 
416 
417 /**
418  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
419  * @dev See https://eips.ethereum.org/EIPS/eip-721
420  */
421 interface IERC721Enumerable is IERC721 {
422     /**
423      * @dev Returns the total amount of tokens stored by the contract.
424      */
425     function totalSupply() external view returns (uint256);
426 
427     /**
428      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
429      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
430      */
431     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
432 
433     /**
434      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
435      * Use along with {totalSupply} to enumerate all tokens.
436      */
437     function tokenByIndex(uint256 index) external view returns (uint256);
438 }
439 
440 
441 
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
445 
446 
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
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies on extcodesize, which returns 0 for contracts in
471         // construction, since the code is only stored at the end of the
472         // constructor execution.
473 
474         uint256 size;
475         assembly {
476             size := extcodesize(account)
477         }
478         return size > 0;
479     }
480 
481     /**
482      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
483      * `recipient`, forwarding all available gas and reverting on errors.
484      *
485      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
486      * of certain opcodes, possibly making contracts go over the 2300 gas limit
487      * imposed by `transfer`, making them unable to receive funds via
488      * `transfer`. {sendValue} removes this limitation.
489      *
490      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
491      *
492      * IMPORTANT: because control is transferred to `recipient`, care must be
493      * taken to not create reentrancy vulnerabilities. Consider using
494      * {ReentrancyGuard} or the
495      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
496      */
497     function sendValue(address payable recipient, uint256 amount) internal {
498         require(address(this).balance >= amount, "Address: insufficient balance");
499 
500         (bool success, ) = recipient.call{value: amount}("");
501         require(success, "Address: unable to send value, recipient may have reverted");
502     }
503 
504     /**
505      * @dev Performs a Solidity function call using a low level `call`. A
506      * plain `call` is an unsafe replacement for a function call: use this
507      * function instead.
508      *
509      * If `target` reverts with a revert reason, it is bubbled up by this
510      * function (like regular Solidity function calls).
511      *
512      * Returns the raw returned data. To convert to the expected return value,
513      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
514      *
515      * Requirements:
516      *
517      * - `target` must be a contract.
518      * - calling `target` with `data` must not revert.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
523         return functionCall(target, data, "Address: low-level call failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
528      * `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCall(
533         address target,
534         bytes memory data,
535         string memory errorMessage
536     ) internal returns (bytes memory) {
537         return functionCallWithValue(target, data, 0, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but also transferring `value` wei to `target`.
543      *
544      * Requirements:
545      *
546      * - the calling contract must have an ETH balance of at least `value`.
547      * - the called Solidity function must be `payable`.
548      *
549      * _Available since v3.1._
550      */
551     function functionCallWithValue(
552         address target,
553         bytes memory data,
554         uint256 value
555     ) internal returns (bytes memory) {
556         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
561      * with `errorMessage` as a fallback revert reason when `target` reverts.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value,
569         string memory errorMessage
570     ) internal returns (bytes memory) {
571         require(address(this).balance >= value, "Address: insufficient balance for call");
572         require(isContract(target), "Address: call to non-contract");
573 
574         (bool success, bytes memory returndata) = target.call{value: value}(data);
575         return verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a static call.
581      *
582      * _Available since v3.3._
583      */
584     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
585         return functionStaticCall(target, data, "Address: low-level static call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal view returns (bytes memory) {
599         require(isContract(target), "Address: static call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.staticcall(data);
602         return verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
612         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.4._
620      */
621     function functionDelegateCall(
622         address target,
623         bytes memory data,
624         string memory errorMessage
625     ) internal returns (bytes memory) {
626         require(isContract(target), "Address: delegate call to non-contract");
627 
628         (bool success, bytes memory returndata) = target.delegatecall(data);
629         return verifyCallResult(success, returndata, errorMessage);
630     }
631 
632     /**
633      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
634      * revert reason using the provided one.
635      *
636      * _Available since v4.3._
637      */
638     function verifyCallResult(
639         bool success,
640         bytes memory returndata,
641         string memory errorMessage
642     ) internal pure returns (bytes memory) {
643         if (success) {
644             return returndata;
645         } else {
646             // Look for revert reason and bubble it up if present
647             if (returndata.length > 0) {
648                 // The easiest way to bubble the revert reason is using memory via assembly
649 
650                 assembly {
651                     let returndata_size := mload(returndata)
652                     revert(add(32, returndata), returndata_size)
653                 }
654             } else {
655                 revert(errorMessage);
656             }
657         }
658     }
659 }
660 
661 
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
665 
666 
667 
668 /**
669  * @dev Implementation of the {IERC165} interface.
670  *
671  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
672  * for the additional interface id that will be supported. For example:
673  *
674  * ```solidity
675  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
676  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
677  * }
678  * ```
679  *
680  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
681  */
682 abstract contract ERC165 is IERC165 {
683     /**
684      * @dev See {IERC165-supportsInterface}.
685      */
686     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687         return interfaceId == type(IERC165).interfaceId;
688     }
689 }
690 
691 
692 // File contracts/ERC721A.sol
693 
694 
695 // Creator: Chiru Labs
696 
697 
698 /**
699  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
700  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
701  *
702  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
703  *
704  * Does not support burning tokens to address(0).
705  *
706  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
707  */
708 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
709     using Address for address;
710     using Strings for uint256;
711 
712     struct TokenOwnership {
713         address addr;
714         uint64 startTimestamp;
715     }
716 
717     struct AddressData {
718         uint128 balance;
719         uint128 numberMinted;
720     }
721 
722     uint256 internal currentIndex = 0;
723 
724     // Token name
725     string private _name;
726 
727     // Token symbol
728     string private _symbol;
729 
730     // Mapping from token ID to ownership details
731     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
732     mapping(uint256 => TokenOwnership) internal _ownerships;
733 
734     // Mapping owner address to address data
735     mapping(address => AddressData) private _addressData;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     constructor(string memory name_, string memory symbol_) {
744         _name = name_;
745         _symbol = symbol_;
746     }
747 
748     /**
749      * @dev See {IERC721Enumerable-totalSupply}.
750      */
751     function totalSupply() public view override returns (uint256) {
752         return currentIndex;
753     }
754 
755     /**
756      * @dev See {IERC721Enumerable-tokenByIndex}.
757      */
758     function tokenByIndex(uint256 index) public view override returns (uint256) {
759         require(index < totalSupply(), 'ERC721A: global index out of bounds');
760         return index;
761     }
762 
763     /**
764      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
765      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
766      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
767      */
768     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
769         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
770         uint256 numMintedSoFar = totalSupply();
771         uint256 tokenIdsIdx = 0;
772         address currOwnershipAddr = address(0);
773         for (uint256 i = 0; i < numMintedSoFar; i++) {
774             TokenOwnership memory ownership = _ownerships[i];
775             if (ownership.addr != address(0)) {
776                 currOwnershipAddr = ownership.addr;
777             }
778             if (currOwnershipAddr == owner) {
779                 if (tokenIdsIdx == index) {
780                     return i;
781                 }
782                 tokenIdsIdx++;
783             }
784         }
785         revert('ERC721A: unable to get token of owner by index');
786     }
787 
788     /**
789      * @dev See {IERC165-supportsInterface}.
790      */
791     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
792         return
793             interfaceId == type(IERC721).interfaceId ||
794             interfaceId == type(IERC721Metadata).interfaceId ||
795             interfaceId == type(IERC721Enumerable).interfaceId ||
796             super.supportsInterface(interfaceId);
797     }
798 
799     /**
800      * @dev See {IERC721-balanceOf}.
801      */
802     function balanceOf(address owner) public view override returns (uint256) {
803         require(owner != address(0), 'ERC721A: balance query for the zero address');
804         return uint256(_addressData[owner].balance);
805     }
806 
807     function _numberMinted(address owner) internal view returns (uint256) {
808         require(owner != address(0), 'ERC721A: number minted query for the zero address');
809         return uint256(_addressData[owner].numberMinted);
810     }
811 
812     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
813         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
814 
815         for (uint256 curr = tokenId; ; curr--) {
816             TokenOwnership memory ownership = _ownerships[curr];
817             if (ownership.addr != address(0)) {
818                 return ownership;
819             }
820         }
821 
822         revert('ERC721A: unable to determine the owner of token');
823     }
824 
825     /**
826      * @dev See {IERC721-ownerOf}.
827      */
828     function ownerOf(uint256 tokenId) public view override returns (address) {
829         return ownershipOf(tokenId).addr;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-name}.
834      */
835     function name() public view virtual override returns (string memory) {
836         return _name;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-symbol}.
841      */
842     function symbol() public view virtual override returns (string memory) {
843         return _symbol;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-tokenURI}.
848      */
849     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
850         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
851 
852         string memory baseURI = _baseURI();
853         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
854     }
855 
856     /**
857      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
858      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
859      * by default, can be overriden in child contracts.
860      */
861     function _baseURI() internal view virtual returns (string memory) {
862         return '';
863     }
864 
865     /**
866      * @dev See {IERC721-approve}.
867      */
868     function approve(address to, uint256 tokenId) public override {
869         address owner = ERC721A.ownerOf(tokenId);
870         require(to != owner, 'ERC721A: approval to current owner');
871 
872         require(
873             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
874             'ERC721A: approve caller is not owner nor approved for all'
875         );
876 
877         _approve(to, tokenId, owner);
878     }
879 
880     /**
881      * @dev See {IERC721-getApproved}.
882      */
883     function getApproved(uint256 tokenId) public view override returns (address) {
884         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
885 
886         return _tokenApprovals[tokenId];
887     }
888 
889     /**
890      * @dev See {IERC721-setApprovalForAll}.
891      */
892     function setApprovalForAll(address operator, bool approved) public override {
893         require(operator != _msgSender(), 'ERC721A: approve to caller');
894 
895         _operatorApprovals[_msgSender()][operator] = approved;
896         emit ApprovalForAll(_msgSender(), operator, approved);
897     }
898 
899     /**
900      * @dev See {IERC721-isApprovedForAll}.
901      */
902     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
903         return _operatorApprovals[owner][operator];
904     }
905 
906     /**
907      * @dev See {IERC721-transferFrom}.
908      */
909     function transferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public override {
914         _transfer(from, to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) public override {
925         safeTransferFrom(from, to, tokenId, '');
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) public override {
937         _transfer(from, to, tokenId);
938         require(
939             _checkOnERC721Received(from, to, tokenId, _data),
940             'ERC721A: transfer to non ERC721Receiver implementer'
941         );
942     }
943 
944     /**
945      * @dev Returns whether `tokenId` exists.
946      *
947      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
948      *
949      * Tokens start existing when they are minted (`_mint`),
950      */
951     function _exists(uint256 tokenId) internal view returns (bool) {
952         return tokenId < currentIndex;
953     }
954 
955     function _safeMint(address to, uint256 quantity) internal {
956         _safeMint(to, quantity, '');
957     }
958 
959     /**
960      * @dev Mints `quantity` tokens and transfers them to `to`.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - `quantity` cannot be larger than the max batch size.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeMint(
970         address to,
971         uint256 quantity,
972         bytes memory _data
973     ) internal {
974         uint256 startTokenId = currentIndex;
975         require(to != address(0), 'ERC721A: mint to the zero address');
976         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
977         require(!_exists(startTokenId), 'ERC721A: token already minted');
978         require(quantity > 0, 'ERC721A: quantity must be greater 0');
979 
980         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
981 
982         AddressData memory addressData = _addressData[to];
983         _addressData[to] = AddressData(
984             addressData.balance + uint128(quantity),
985             addressData.numberMinted + uint128(quantity)
986         );
987         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
988 
989         uint256 updatedIndex = startTokenId;
990 
991         for (uint256 i = 0; i < quantity; i++) {
992             emit Transfer(address(0), to, updatedIndex);
993             require(
994                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
995                 'ERC721A: transfer to non ERC721Receiver implementer'
996             );
997             updatedIndex++;
998         }
999 
1000       currentIndex = updatedIndex;
1001         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _transfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) private {
1019         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1020 
1021         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1022             getApproved(tokenId) == _msgSender() ||
1023             isApprovedForAll(prevOwnership.addr, _msgSender()));
1024 
1025         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1026 
1027         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1028         require(to != address(0), 'ERC721A: transfer to the zero address');
1029 
1030         _beforeTokenTransfers(from, to, tokenId, 1);
1031 
1032         // Clear approvals from the previous owner
1033         _approve(address(0), tokenId, prevOwnership.addr);
1034 
1035         // Underflow of the sender's balance is impossible because we check for
1036         // ownership above and the recipient's balance can't realistically overflow.
1037         unchecked {
1038             _addressData[from].balance -= 1;
1039             _addressData[to].balance += 1;
1040         }
1041 
1042         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1043 
1044         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1045         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1046         uint256 nextTokenId = tokenId + 1;
1047         if (_ownerships[nextTokenId].addr == address(0)) {
1048             if (_exists(nextTokenId)) {
1049                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1050             }
1051         }
1052 
1053         emit Transfer(from, to, tokenId);
1054         _afterTokenTransfers(from, to, tokenId, 1);
1055     }
1056 
1057     /**
1058      * @dev Approve `to` to operate on `tokenId`
1059      *
1060      * Emits a {Approval} event.
1061      */
1062     function _approve(
1063         address to,
1064         uint256 tokenId,
1065         address owner
1066     ) private {
1067         _tokenApprovals[tokenId] = to;
1068         emit Approval(owner, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1073      * The call is not executed if the target address is not a contract.
1074      *
1075      * @param from address representing the previous owner of the given token ID
1076      * @param to target address that will receive the tokens
1077      * @param tokenId uint256 ID of the token to be transferred
1078      * @param _data bytes optional data to send along with the call
1079      * @return bool whether the call correctly returned the expected magic value
1080      */
1081     function _checkOnERC721Received(
1082         address from,
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) private returns (bool) {
1087         if (to.isContract()) {
1088             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1089                 return retval == IERC721Receiver(to).onERC721Received.selector;
1090             } catch (bytes memory reason) {
1091                 if (reason.length == 0) {
1092                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1093                 } else {
1094                     assembly {
1095                         revert(add(32, reason), mload(reason))
1096                     }
1097                 }
1098             }
1099         } else {
1100             return true;
1101         }
1102     }
1103 
1104     /**
1105      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1106      *
1107      * startTokenId - the first token id to be transferred
1108      * quantity - the amount to be transferred
1109      *
1110      * Calling conditions:
1111      *
1112      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1113      * transferred to `to`.
1114      * - When `from` is zero, `tokenId` will be minted for `to`.
1115      */
1116     function _beforeTokenTransfers(
1117         address from,
1118         address to,
1119         uint256 startTokenId,
1120         uint256 quantity
1121     ) internal virtual {}
1122 
1123     /**
1124      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1125      * minting.
1126      *
1127      * startTokenId - the first token id to be transferred
1128      * quantity - the amount to be transferred
1129      *
1130      * Calling conditions:
1131      *
1132      * - when `from` and `to` are both non-zero.
1133      * - `from` and `to` are never both zero.
1134      */
1135     function _afterTokenTransfers(
1136         address from,
1137         address to,
1138         uint256 startTokenId,
1139         uint256 quantity
1140     ) internal virtual {}
1141 }
1142 
1143 contract LetterQ is ERC721A, Ownable {
1144 
1145     string public baseURI = "ipfs://QmbNnSeqEtHLzvyDxPzbBZdcwi5FJ3vXixbQRS87R7AVeX/";
1146     string public contractURI = "ipfs://QmbNnSeqEtHLzvyDxPzbBZdcwi5FJ3vXixbQRS87R7AVeX";
1147     string public constant baseExtension = ".json";
1148     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1149 
1150     uint256 public constant MAX_PER_TX_FREE = 2;
1151     uint256 public constant MAX_PER_TX = 20;
1152     uint256 public constant FREE_MAX_SUPPLY = 100;
1153     uint256 public MAX_SUPPLY = 1000;
1154     uint256 public price = 0.005 ether;
1155 
1156     bool public paused = true;
1157 
1158     constructor() ERC721A("The Letter Q", "Q") {}
1159 
1160     function mint(uint256 _amount) external payable {
1161         address _caller = _msgSender();
1162         require(!paused, "Paused");
1163         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1164         require(_amount > 0, "No 0 mints");
1165         require(tx.origin == _caller, "No contracts");
1166 
1167         if(FREE_MAX_SUPPLY >= totalSupply()){
1168             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1169         }else{
1170             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1171             require(_amount * price == msg.value, "Invalid funds provided");
1172         }
1173 
1174         _safeMint(_caller, _amount);
1175     }
1176 
1177 
1178 
1179     function withdraw() external onlyOwner {
1180         uint256 balance = address(this).balance;
1181         (bool success, ) = _msgSender().call{value: balance}("");
1182         require(success, "Failed to send");
1183     }
1184 
1185     function pause(bool _state) external onlyOwner {
1186         paused = _state;
1187     }
1188 
1189     function setBaseURI(string memory baseURI_) external onlyOwner {
1190         baseURI = baseURI_;
1191     }
1192 
1193     function setContractURI(string memory _contractURI) external onlyOwner {
1194         contractURI = _contractURI;
1195     }
1196 
1197 function setPrice(uint256 newPrice) public onlyOwner {
1198         price = newPrice;
1199 }
1200 
1201 function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1202         MAX_SUPPLY = newSupply;
1203 }
1204 
1205 
1206     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1207         require(_exists(_tokenId), "Token does not exist.");
1208         return bytes(baseURI).length > 0 ? string(
1209             abi.encodePacked(
1210               baseURI,
1211               Strings.toString(_tokenId),
1212               baseExtension
1213             )
1214         ) : "";
1215     }
1216 }