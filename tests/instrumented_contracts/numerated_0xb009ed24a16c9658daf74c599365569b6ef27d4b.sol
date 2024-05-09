1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.12;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 
69 /**
70  * @dev Provides information about the current execution context, including the
71  * sender of the transaction and its data. While these are generally available
72  * via msg.sender and msg.data, they should not be accessed in such a direct
73  * manner, since when dealing with meta-transactions the account sending and
74  * paying for execution may not be the actual sender (as far as an application
75  * is concerned).
76  *
77  * This contract is only required for intermediate, library-like contracts.
78  */
79 abstract contract Context {
80     function _msgSender() internal view virtual returns (address) {
81         return msg.sender;
82     }
83 
84     function _msgData() internal view virtual returns (bytes calldata) {
85         return msg.data;
86     }
87 }
88 
89 /**
90  * @dev Contract module which provides a basic access control mechanism, where
91  * there is an account (an owner) that can be granted exclusive access to
92  * specific functions.
93  *
94  * By default, the owner account will be the one that deploys the contract. This
95  * can later be changed with {transferOwnership}.
96  *
97  * This module is used through inheritance. It will make available the modifier
98  * `onlyOwner`, which can be applied to your functions to restrict their use to
99  * the owner.
100  */
101 abstract contract Ownable is Context {
102     address private _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     /**
107      * @dev Initializes the contract setting the deployer as the initial owner.
108      */
109     constructor() {
110         _setOwner(_msgSender());
111     }
112 
113     /**
114      * @dev Returns the address of the current owner.
115      */
116     function owner() public view virtual returns (address) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     /**
129      * @dev Leaves the contract without owner. It will not be possible to call
130      * `onlyOwner` functions anymore. Can only be called by the current owner.
131      *
132      * NOTE: Renouncing ownership will leave the contract without an owner,
133      * thereby removing any functionality that is only available to the owner.
134      */
135     function renounceOwnership() public virtual onlyOwner {
136         _setOwner(address(0));
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Can only be called by the current owner.
142      */
143     function transferOwnership(address newOwner) public virtual onlyOwner {
144         require(newOwner != address(0), "Ownable: new owner is the zero address");
145         _setOwner(newOwner);
146     }
147 
148     function _setOwner(address newOwner) private {
149         address oldOwner = _owner;
150         _owner = newOwner;
151         emit OwnershipTransferred(oldOwner, newOwner);
152     }
153 }
154 
155 /**
156  * @dev Collection of functions related to the address type
157  */
158 library Address {
159     /**
160      * @dev Returns true if `account` is a contract.
161      *
162      * [IMPORTANT]
163      * ====
164      * It is unsafe to assume that an address for which this function returns
165      * false is an externally-owned account (EOA) and not a contract.
166      *
167      * Among others, `isContract` will return false for the following
168      * types of addresses:
169      *
170      *  - an externally-owned account
171      *  - a contract in construction
172      *  - an address where a contract will be created
173      *  - an address where a contract lived, but was destroyed
174      * ====
175      */
176     function isContract(address account) internal view returns (bool) {
177         // This method relies on extcodesize, which returns 0 for contracts in
178         // construction, since the code is only stored at the end of the
179         // constructor execution.
180 
181         uint256 size;
182         assembly {
183             size := extcodesize(account)
184         }
185         return size > 0;
186     }
187 
188     /**
189      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
190      * `recipient`, forwarding all available gas and reverting on errors.
191      *
192      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
193      * of certain opcodes, possibly making contracts go over the 2300 gas limit
194      * imposed by `transfer`, making them unable to receive funds via
195      * `transfer`. {sendValue} removes this limitation.
196      *
197      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
198      *
199      * IMPORTANT: because control is transferred to `recipient`, care must be
200      * taken to not create reentrancy vulnerabilities. Consider using
201      * {ReentrancyGuard} or the
202      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
203      */
204     function sendValue(address payable recipient, uint256 amount) internal {
205         require(address(this).balance >= amount, "Address: insufficient balance");
206 
207         (bool success, ) = recipient.call{value: amount}("");
208         require(success, "Address: unable to send value, recipient may have reverted");
209     }
210 
211     /**
212      * @dev Performs a Solidity function call using a low level `call`. A
213      * plain `call` is an unsafe replacement for a function call: use this
214      * function instead.
215      *
216      * If `target` reverts with a revert reason, it is bubbled up by this
217      * function (like regular Solidity function calls).
218      *
219      * Returns the raw returned data. To convert to the expected return value,
220      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
221      *
222      * Requirements:
223      *
224      * - `target` must be a contract.
225      * - calling `target` with `data` must not revert.
226      *
227      * _Available since v3.1._
228      */
229     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
230         return functionCall(target, data, "Address: low-level call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
235      * `errorMessage` as a fallback revert reason when `target` reverts.
236      *
237      * _Available since v3.1._
238      */
239     function functionCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal returns (bytes memory) {
244         return functionCallWithValue(target, data, 0, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but also transferring `value` wei to `target`.
250      *
251      * Requirements:
252      *
253      * - the calling contract must have an ETH balance of at least `value`.
254      * - the called Solidity function must be `payable`.
255      *
256      * _Available since v3.1._
257      */
258     function functionCallWithValue(
259         address target,
260         bytes memory data,
261         uint256 value
262     ) internal returns (bytes memory) {
263         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
268      * with `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCallWithValue(
273         address target,
274         bytes memory data,
275         uint256 value,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         require(address(this).balance >= value, "Address: insufficient balance for call");
279         require(isContract(target), "Address: call to non-contract");
280 
281         (bool success, bytes memory returndata) = target.call{value: value}(data);
282         return verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but performing a static call.
288      *
289      * _Available since v3.3._
290      */
291     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
292         return functionStaticCall(target, data, "Address: low-level static call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
297      * but performing a static call.
298      *
299      * _Available since v3.3._
300      */
301     function functionStaticCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal view returns (bytes memory) {
306         require(isContract(target), "Address: static call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.staticcall(data);
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a delegate call.
315      *
316      * _Available since v3.4._
317      */
318     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a delegate call.
325      *
326      * _Available since v3.4._
327      */
328     function functionDelegateCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(isContract(target), "Address: delegate call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.delegatecall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
341      * revert reason using the provided one.
342      *
343      * _Available since v4.3._
344      */
345     function verifyCallResult(
346         bool success,
347         bytes memory returndata,
348         string memory errorMessage
349     ) internal pure returns (bytes memory) {
350         if (success) {
351             return returndata;
352         } else {
353             // Look for revert reason and bubble it up if present
354             if (returndata.length > 0) {
355                 // The easiest way to bubble the revert reason is using memory via assembly
356 
357                 assembly {
358                     let returndata_size := mload(returndata)
359                     revert(add(32, returndata), returndata_size)
360                 }
361             } else {
362                 revert(errorMessage);
363             }
364         }
365     }
366 }
367 
368 /**
369  * @title ERC721 token receiver interface
370  * @dev Interface for any contract that wants to support safeTransfers
371  * from ERC721 asset contracts.
372  */
373 interface IERC721Receiver {
374     /**
375      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
376      * by `operator` from `from`, this function is called.
377      *
378      * It must return its Solidity selector to confirm the token transfer.
379      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
380      *
381      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
382      */
383     function onERC721Received(
384         address operator,
385         address from,
386         uint256 tokenId,
387         bytes calldata data
388     ) external returns (bytes4);
389 }
390 
391 /**
392  * @dev Interface of the ERC165 standard, as defined in the
393  * https://eips.ethereum.org/EIPS/eip-165[EIP].
394  *
395  * Implementers can declare support of contract interfaces, which can then be
396  * queried by others ({ERC165Checker}).
397  *
398  * For an implementation, see {ERC165}.
399  */
400 interface IERC165 {
401     /**
402      * @dev Returns true if this contract implements the interface defined by
403      * `interfaceId`. See the corresponding
404      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
405      * to learn more about how these ids are created.
406      *
407      * This function call must use less than 30 000 gas.
408      */
409     function supportsInterface(bytes4 interfaceId) external view returns (bool);
410 }
411 
412 /**
413  * @dev Implementation of the {IERC165} interface.
414  *
415  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
416  * for the additional interface id that will be supported. For example:
417  *
418  * ```solidity
419  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
420  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
421  * }
422  * ```
423  *
424  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
425  */
426 abstract contract ERC165 is IERC165 {
427     /**
428      * @dev See {IERC165-supportsInterface}.
429      */
430     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431         return interfaceId == type(IERC165).interfaceId;
432     }
433 }
434 
435 /**
436  * @dev Required interface of an ERC721 compliant contract.
437  */
438 interface IERC721 is IERC165 {
439     /**
440      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
441      */
442     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
443 
444     /**
445      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
446      */
447     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
448 
449     /**
450      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
451      */
452     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
453 
454     /**
455      * @dev Returns the number of tokens in ``owner``'s account.
456      */
457     function balanceOf(address owner) external view returns (uint256 balance);
458 
459     /**
460      * @dev Returns the owner of the `tokenId` token.
461      *
462      * Requirements:
463      *
464      * - `tokenId` must exist.
465      */
466     function ownerOf(uint256 tokenId) external view returns (address owner);
467 
468     /**
469      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
470      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must exist and be owned by `from`.
477      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
478      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
479      *
480      * Emits a {Transfer} event.
481      */
482     function safeTransferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Transfers `tokenId` token from `from` to `to`.
490      *
491      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transferFrom(
503         address from,
504         address to,
505         uint256 tokenId
506     ) external;
507 
508     /**
509      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
510      * The approval is cleared when the token is transferred.
511      *
512      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
513      *
514      * Requirements:
515      *
516      * - The caller must own the token or be an approved operator.
517      * - `tokenId` must exist.
518      *
519      * Emits an {Approval} event.
520      */
521     function approve(address to, uint256 tokenId) external;
522 
523     /**
524      * @dev Returns the account approved for `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function getApproved(uint256 tokenId) external view returns (address operator);
531 
532     /**
533      * @dev Approve or remove `operator` as an operator for the caller.
534      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
535      *
536      * Requirements:
537      *
538      * - The `operator` cannot be the caller.
539      *
540      * Emits an {ApprovalForAll} event.
541      */
542     function setApprovalForAll(address operator, bool _approved) external;
543 
544     /**
545      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
546      *
547      * See {setApprovalForAll}
548      */
549     function isApprovedForAll(address owner, address operator) external view returns (bool);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId,
568         bytes calldata data
569     ) external;
570 }
571 
572 /**
573  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
574  * @dev See https://eips.ethereum.org/EIPS/eip-721
575  */
576 interface IERC721Enumerable is IERC721 {
577     /**
578      * @dev Returns the total amount of tokens stored by the contract.
579      */
580     function totalSupply() external view returns (uint256);
581 
582     /**
583      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
584      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
585      */
586     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
587 
588     /**
589      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
590      * Use along with {totalSupply} to enumerate all tokens.
591      */
592     function tokenByIndex(uint256 index) external view returns (uint256);
593 }
594 
595 
596 /**
597  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
598  * @dev See https://eips.ethereum.org/EIPS/eip-721
599  */
600 interface IERC721Metadata is IERC721 {
601     /**
602      * @dev Returns the token collection name.
603      */
604     function name() external view returns (string memory);
605 
606     /**
607      * @dev Returns the token collection symbol.
608      */
609     function symbol() external view returns (string memory);
610 
611     /**
612      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
613      */
614     function tokenURI(uint256 tokenId) external view returns (string memory);
615 }
616 
617 /**
618  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
619  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
620  *
621  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
622  *
623  * Does not support burning tokens to address(0).
624  *
625  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
626  */
627 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
628     using Address for address;
629     using Strings for uint256;
630 
631     struct TokenOwnership {
632         address addr;
633         uint64 startTimestamp;
634     }
635 
636     struct AddressData {
637         uint128 balance;
638         uint128 numberMinted;
639     }
640 
641     uint256 internal currentIndex = 1;
642 
643     // Token name
644     string private _name;
645 
646     // Token symbol
647     string private _symbol;
648 
649     // Mapping from token ID to ownership details
650     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
651     mapping(uint256 => TokenOwnership) internal _ownerships;
652 
653     // Mapping owner address to address data
654     mapping(address => AddressData) private _addressData;
655 
656     // Mapping from token ID to approved address
657     mapping(uint256 => address) private _tokenApprovals;
658 
659     // Mapping from owner to operator approvals
660     mapping(address => mapping(address => bool)) private _operatorApprovals;
661 
662     constructor(string memory name_, string memory symbol_) {
663         _name = name_;
664         _symbol = symbol_;
665     }
666 
667     /**
668      * @dev See {IERC721Enumerable-totalSupply}.
669      */
670     function totalSupply() public view override returns (uint256) {
671         return currentIndex - 1;
672     }
673 
674     /**
675      * @dev See {IERC721Enumerable-tokenByIndex}.
676      */
677     function tokenByIndex(uint256 index) public view override returns (uint256) {
678         require(index < totalSupply(), 'ERC721A: global index out of bounds');
679         return index;
680     }
681 
682     /**
683      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
684      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
685      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
686      */
687     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
688         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
689         uint256 numMintedSoFar = totalSupply();
690         uint256 tokenIdsIdx;
691         address currOwnershipAddr;
692 
693         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
694         unchecked {
695             for (uint256 i; i < numMintedSoFar; i++) {
696                 TokenOwnership memory ownership = _ownerships[i];
697                 if (ownership.addr != address(0)) {
698                     currOwnershipAddr = ownership.addr;
699                 }
700                 if (currOwnershipAddr == owner) {
701                     if (tokenIdsIdx == index) {
702                         return i;
703                     }
704                     tokenIdsIdx++;
705                 }
706             }
707         }
708 
709         revert('ERC721A: unable to get token of owner by index');
710     }
711 
712     /**
713      * @dev See {IERC165-supportsInterface}.
714      */
715     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
716         return
717             interfaceId == type(IERC721).interfaceId ||
718             interfaceId == type(IERC721Metadata).interfaceId ||
719             interfaceId == type(IERC721Enumerable).interfaceId ||
720             super.supportsInterface(interfaceId);
721     }
722 
723     /**
724      * @dev See {IERC721-balanceOf}.
725      */
726     function balanceOf(address owner) public view override returns (uint256) {
727         require(owner != address(0), 'ERC721A: balance query for the zero address');
728         return uint256(_addressData[owner].balance);
729     }
730 
731     function _numberMinted(address owner) internal view returns (uint256) {
732         require(owner != address(0), 'ERC721A: number minted query for the zero address');
733         return uint256(_addressData[owner].numberMinted);
734     }
735 
736     /**
737      * Gas spent here starts off proportional to the maximum mint batch size.
738      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
739      */
740     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
741         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
742 
743         unchecked {
744             for (uint256 curr = tokenId; curr >= 0; curr--) {
745                 TokenOwnership memory ownership = _ownerships[curr];
746                 if (ownership.addr != address(0)) {
747                     return ownership;
748                 }
749             }
750         }
751 
752         revert('ERC721A: unable to determine the owner of token');
753     }
754 
755     /**
756      * @dev See {IERC721-ownerOf}.
757      */
758     function ownerOf(uint256 tokenId) public view override returns (address) {
759         return ownershipOf(tokenId).addr;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-name}.
764      */
765     function name() public view virtual override returns (string memory) {
766         return _name;
767     }
768 
769     /**
770      * @dev See {IERC721Metadata-symbol}.
771      */
772     function symbol() public view virtual override returns (string memory) {
773         return _symbol;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-tokenURI}.
778      */
779     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
780         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
781 
782         string memory baseURI = _baseURI();
783         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, "Duckle%20%23", tokenId.toString(), ".json")) : '';
784     }
785 
786     /**
787      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
788      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
789      * by default, can be overriden in child contracts.
790      */
791     function _baseURI() internal view virtual returns (string memory) {
792         return "ipfs:/QmSQMJZcEfnzc9M5tL13etoHnbdsw5SV8Pi2J948dhAepz/";
793     }
794 
795     /**
796      * @dev See {IERC721-approve}.
797      */
798     function approve(address to, uint256 tokenId) public override {
799         address owner = ERC721A.ownerOf(tokenId);
800         require(to != owner, 'ERC721A: approval to current owner');
801 
802         require(
803             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
804             'ERC721A: approve caller is not owner nor approved for all'
805         );
806 
807         _approve(to, tokenId, owner);
808     }
809 
810     /**
811      * @dev See {IERC721-getApproved}.
812      */
813     function getApproved(uint256 tokenId) public view override returns (address) {
814         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
815 
816         return _tokenApprovals[tokenId];
817     }
818 
819     /**
820      * @dev See {IERC721-setApprovalForAll}.
821      */
822     function setApprovalForAll(address operator, bool approved) public override {
823         require(operator != _msgSender(), 'ERC721A: approve to caller');
824 
825         _operatorApprovals[_msgSender()][operator] = approved;
826         emit ApprovalForAll(_msgSender(), operator, approved);
827     }
828 
829     /**
830      * @dev See {IERC721-isApprovedForAll}.
831      */
832     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
833         return _operatorApprovals[owner][operator];
834     }
835 
836     /**
837      * @dev See {IERC721-transferFrom}.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public override {
844         _transfer(from, to, tokenId);
845     }
846 
847     /**
848      * @dev See {IERC721-safeTransferFrom}.
849      */
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId
854     ) public override {
855         safeTransferFrom(from, to, tokenId, '');
856     }
857 
858     /**
859      * @dev See {IERC721-safeTransferFrom}.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) public override {
867         _transfer(from, to, tokenId);
868         require(
869             _checkOnERC721Received(from, to, tokenId, _data),
870             'ERC721A: transfer to non ERC721Receiver implementer'
871         );
872     }
873 
874     /**
875      * @dev Returns whether `tokenId` exists.
876      *
877      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
878      *
879      * Tokens start existing when they are minted (`_mint`),
880      */
881     function _exists(uint256 tokenId) internal view returns (bool) {
882         return tokenId < currentIndex && tokenId > 0;
883     }
884 
885     function _safeMint(address to, uint256 quantity) internal {
886         _safeMint(to, quantity, '');
887     }
888 
889     /**
890      * @dev Safely mints `quantity` tokens and transfers them to `to`.
891      *
892      * Requirements:
893      *
894      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
895      * - `quantity` must be greater than 0.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _safeMint(
900         address to,
901         uint256 quantity,
902         bytes memory _data
903     ) internal {
904         _mint(to, quantity, _data, true);
905     }
906 
907     /**
908      * @dev Mints `quantity` tokens and transfers them to `to`.
909      *
910      * Requirements:
911      *
912      * - `to` cannot be the zero address.
913      * - `quantity` must be greater than 0.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _mint(
918         address to,
919         uint256 quantity,
920         bytes memory _data,
921         bool safe
922     ) internal {
923         uint256 startTokenId = currentIndex;
924         require(to != address(0), 'ERC721A: mint to the zero address');
925         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
926 
927         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
928 
929         // Overflows are incredibly unrealistic.
930         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
931         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
932         unchecked {
933             _addressData[to].balance += uint128(quantity);
934             _addressData[to].numberMinted += uint128(quantity);
935 
936             _ownerships[startTokenId].addr = to;
937             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
938 
939             uint256 updatedIndex = startTokenId;
940 
941             for (uint256 i; i < quantity; i++) {
942                 emit Transfer(address(0), to, updatedIndex);
943                 if (safe) {
944                     require(
945                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
946                         'ERC721A: transfer to non ERC721Receiver implementer'
947                     );
948                 }
949 
950                 updatedIndex++;
951             }
952 
953             currentIndex = updatedIndex;
954         }
955 
956         _afterTokenTransfers(address(0), to, startTokenId, quantity);
957     }
958 
959     /**
960      * @dev Transfers `tokenId` from `from` to `to`.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - `tokenId` token must be owned by `from`.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _transfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) private {
974         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
975 
976         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
977             getApproved(tokenId) == _msgSender() ||
978             isApprovedForAll(prevOwnership.addr, _msgSender()));
979 
980         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
981 
982         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
983         require(to != address(0), 'ERC721A: transfer to the zero address');
984 
985         _beforeTokenTransfers(from, to, tokenId, 1);
986 
987         // Clear approvals from the previous owner
988         _approve(address(0), tokenId, prevOwnership.addr);
989 
990         // Underflow of the sender's balance is impossible because we check for
991         // ownership above and the recipient's balance can't realistically overflow.
992         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
993         unchecked {
994             _addressData[from].balance -= 1;
995             _addressData[to].balance += 1;
996 
997             _ownerships[tokenId].addr = to;
998             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
999 
1000             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1001             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1002             uint256 nextTokenId = tokenId + 1;
1003             if (_ownerships[nextTokenId].addr == address(0)) {
1004                 if (_exists(nextTokenId)) {
1005                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1006                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1007                 }
1008             }
1009         }
1010 
1011         emit Transfer(from, to, tokenId);
1012         _afterTokenTransfers(from, to, tokenId, 1);
1013     }
1014 
1015     /**
1016      * @dev Approve `to` to operate on `tokenId`
1017      *
1018      * Emits a {Approval} event.
1019      */
1020     function _approve(
1021         address to,
1022         uint256 tokenId,
1023         address owner
1024     ) private {
1025         _tokenApprovals[tokenId] = to;
1026         emit Approval(owner, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1031      * The call is not executed if the target address is not a contract.
1032      *
1033      * @param from address representing the previous owner of the given token ID
1034      * @param to target address that will receive the tokens
1035      * @param tokenId uint256 ID of the token to be transferred
1036      * @param _data bytes optional data to send along with the call
1037      * @return bool whether the call correctly returned the expected magic value
1038      */
1039     function _checkOnERC721Received(
1040         address from,
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) private returns (bool) {
1045         if (to.isContract()) {
1046             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1047                 return retval == IERC721Receiver(to).onERC721Received.selector;
1048             } catch (bytes memory reason) {
1049                 if (reason.length == 0) {
1050                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1051                 } else {
1052                     assembly {
1053                         revert(add(32, reason), mload(reason))
1054                     }
1055                 }
1056             }
1057         } else {
1058             return true;
1059         }
1060     }
1061 
1062     /**
1063      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1064      *
1065      * startTokenId - the first token id to be transferred
1066      * quantity - the amount to be transferred
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      */
1074     function _beforeTokenTransfers(
1075         address from,
1076         address to,
1077         uint256 startTokenId,
1078         uint256 quantity
1079     ) internal virtual {}
1080 
1081     /**
1082      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1083      * minting.
1084      *
1085      * startTokenId - the first token id to be transferred
1086      * quantity - the amount to be transferred
1087      *
1088      * Calling conditions:
1089      *
1090      * - when `from` and `to` are both non-zero.
1091      * - `from` and `to` are never both zero.
1092      */
1093     function _afterTokenTransfers(
1094         address from,
1095         address to,
1096         uint256 startTokenId,
1097         uint256 quantity
1098     ) internal virtual {}
1099 }
1100 
1101 contract Duckles is ERC721A, Ownable {
1102 
1103     constructor() ERC721A("Duckles", "DCKLS") {}
1104 
1105     // ---------------------------------------------------------------------------------------------
1106     // CONSTANTS
1107     // ---------------------------------------------------------------------------------------------
1108 
1109     uint64 public constant FREE_SUPPLY = 7264;  
1110     uint64 public constant MAX_SUPPLY = 10000;     
1111     uint64 public constant FOUNDERS_SUPPLY = 100;  
1112     uint64 public constant MAX_FREE_PER_WALLET_AND_TX = 10;  
1113 
1114     // ---------------------------------------------------------------------------------------------
1115     // VARIABLES
1116     // ---------------------------------------------------------------------------------------------
1117 
1118     bool private saleStatus;  
1119     uint256 public price = 0.03 ether;
1120  
1121     // ---------------------------------------------------------------------------------------------
1122     // MAPPINGS
1123     // ---------------------------------------------------------------------------------------------
1124 
1125     mapping(address => uint) public _freeMinted;
1126 
1127     // ---------------------------------------------------------------------------------------------
1128     // OWNER SETTERS
1129     // ---------------------------------------------------------------------------------------------
1130 
1131     function setPrice(uint256 _price) external onlyOwner {
1132         price = _price;
1133     } 
1134 
1135     function startSale() external onlyOwner {
1136         _safeMint(msg.sender, FOUNDERS_SUPPLY);
1137         saleStatus = !saleStatus;
1138     }
1139 
1140     function withdraw() external onlyOwner {
1141         payable(msg.sender).transfer(address(this).balance);
1142     }
1143 
1144     // ---------------------------------------------------------------------------------------------
1145     // PUBLIC SETTERS
1146     // ---------------------------------------------------------------------------------------------
1147 
1148     function freeMint(uint256 amount) external {
1149         require(saleStatus, "SALE_NOT_ACTIVE!");
1150         require(amount <= MAX_FREE_PER_WALLET_AND_TX, "EXCEEDS_MAX_PER_TX!");    
1151         require(currentIndex + amount <= FREE_SUPPLY + 1, "NOT_ENOUGH_TOKENS!");
1152         require(_freeMinted[msg.sender] + amount <= MAX_FREE_PER_WALLET_AND_TX, "EXCEEDS_MAX_PER_WALLET!");
1153         _safeMint(msg.sender, amount);
1154         _freeMinted[msg.sender] += amount;
1155     }
1156 
1157     function saleMint(uint256 amount) external payable {
1158         require(saleStatus, "SALE_NOT_ACTIVE!");
1159         require(msg.value == price * amount, "INCORRECT_VALUE!");          
1160         require(amount <= MAX_FREE_PER_WALLET_AND_TX, "EXCEEDS_MAX_PER_TX!");
1161         require(currentIndex + amount > FREE_SUPPLY && currentIndex + amount <= MAX_SUPPLY + 1, "NOT_ALLOWED!");
1162         _safeMint(msg.sender, amount);
1163     }
1164 }