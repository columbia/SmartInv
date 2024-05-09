1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.11;
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
110         _transferOwnership(_msgSender());
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
136         _transferOwnership(address(0));
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Can only be called by the current owner.
142      */
143     function transferOwnership(address newOwner) public virtual onlyOwner {
144         require(newOwner != address(0), "Ownable: new owner is the zero address");
145         _transferOwnership(newOwner);
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      * Internal function without access restriction.
151      */
152     function _transferOwnership(address newOwner) internal virtual {
153         address oldOwner = _owner;
154         _owner = newOwner;
155         emit OwnershipTransferred(oldOwner, newOwner);
156     }
157 }
158 
159 /**
160  * @dev Collection of functions related to the address type
161  */
162 library Address {
163     /**
164      * @dev Returns true if `account` is a contract.
165      *
166      * [IMPORTANT]
167      * ====
168      * It is unsafe to assume that an address for which this function returns
169      * false is an externally-owned account (EOA) and not a contract.
170      *
171      * Among others, `isContract` will return false for the following
172      * types of addresses:
173      *
174      *  - an externally-owned account
175      *  - a contract in construction
176      *  - an address where a contract will be created
177      *  - an address where a contract lived, but was destroyed
178      * ====
179      */
180     function isContract(address account) internal view returns (bool) {
181         // This method relies on extcodesize, which returns 0 for contracts in
182         // construction, since the code is only stored at the end of the
183         // constructor execution.
184 
185         uint256 size;
186         assembly {
187             size := extcodesize(account)
188         }
189         return size > 0;
190     }
191 
192     /**
193      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
194      * `recipient`, forwarding all available gas and reverting on errors.
195      *
196      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
197      * of certain opcodes, possibly making contracts go over the 2300 gas limit
198      * imposed by `transfer`, making them unable to receive funds via
199      * `transfer`. {sendValue} removes this limitation.
200      *
201      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
202      *
203      * IMPORTANT: because control is transferred to `recipient`, care must be
204      * taken to not create reentrancy vulnerabilities. Consider using
205      * {ReentrancyGuard} or the
206      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
207      */
208     function sendValue(address payable recipient, uint256 amount) internal {
209         require(address(this).balance >= amount, "Address: insufficient balance");
210 
211         (bool success, ) = recipient.call{value: amount}("");
212         require(success, "Address: unable to send value, recipient may have reverted");
213     }
214 
215     /**
216      * @dev Performs a Solidity function call using a low level `call`. A
217      * plain `call` is an unsafe replacement for a function call: use this
218      * function instead.
219      *
220      * If `target` reverts with a revert reason, it is bubbled up by this
221      * function (like regular Solidity function calls).
222      *
223      * Returns the raw returned data. To convert to the expected return value,
224      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
225      *
226      * Requirements:
227      *
228      * - `target` must be a contract.
229      * - calling `target` with `data` must not revert.
230      *
231      * _Available since v3.1._
232      */
233     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionCall(target, data, "Address: low-level call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
239      * `errorMessage` as a fallback revert reason when `target` reverts.
240      *
241      * _Available since v3.1._
242      */
243     function functionCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, 0, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but also transferring `value` wei to `target`.
254      *
255      * Requirements:
256      *
257      * - the calling contract must have an ETH balance of at least `value`.
258      * - the called Solidity function must be `payable`.
259      *
260      * _Available since v3.1._
261      */
262     function functionCallWithValue(
263         address target,
264         bytes memory data,
265         uint256 value
266     ) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
272      * with `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(
277         address target,
278         bytes memory data,
279         uint256 value,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(address(this).balance >= value, "Address: insufficient balance for call");
283         require(isContract(target), "Address: call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.call{value: value}(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
296         return functionStaticCall(target, data, "Address: low-level static call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
301      * but performing a static call.
302      *
303      * _Available since v3.3._
304      */
305     function functionStaticCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal view returns (bytes memory) {
310         require(isContract(target), "Address: static call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.staticcall(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but performing a delegate call.
319      *
320      * _Available since v3.4._
321      */
322     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
328      * but performing a delegate call.
329      *
330      * _Available since v3.4._
331      */
332     function functionDelegateCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         require(isContract(target), "Address: delegate call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.delegatecall(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
345      * revert reason using the provided one.
346      *
347      * _Available since v4.3._
348      */
349     function verifyCallResult(
350         bool success,
351         bytes memory returndata,
352         string memory errorMessage
353     ) internal pure returns (bytes memory) {
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 assembly {
362                     let returndata_size := mload(returndata)
363                     revert(add(32, returndata), returndata_size)
364                 }
365             } else {
366                 revert(errorMessage);
367             }
368         }
369     }
370 }
371 
372 /**
373  * @title ERC721 token receiver interface
374  * @dev Interface for any contract that wants to support safeTransfers
375  * from ERC721 asset contracts.
376  */
377 interface IERC721Receiver {
378     /**
379      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
380      * by `operator` from `from`, this function is called.
381      *
382      * It must return its Solidity selector to confirm the token transfer.
383      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
384      *
385      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
386      */
387     function onERC721Received(
388         address operator,
389         address from,
390         uint256 tokenId,
391         bytes calldata data
392     ) external returns (bytes4);
393 }
394 
395 /**
396  * @dev Interface of the ERC165 standard, as defined in the
397  * https://eips.ethereum.org/EIPS/eip-165[EIP].
398  *
399  * Implementers can declare support of contract interfaces, which can then be
400  * queried by others ({ERC165Checker}).
401  *
402  * For an implementation, see {ERC165}.
403  */
404 interface IERC165 {
405     /**
406      * @dev Returns true if this contract implements the interface defined by
407      * `interfaceId`. See the corresponding
408      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
409      * to learn more about how these ids are created.
410      *
411      * This function call must use less than 30 000 gas.
412      */
413     function supportsInterface(bytes4 interfaceId) external view returns (bool);
414 }
415 
416 /**
417  * @dev Implementation of the {IERC165} interface.
418  *
419  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
420  * for the additional interface id that will be supported. For example:
421  *
422  * ```solidity
423  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
424  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
425  * }
426  * ```
427  *
428  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
429  */
430 abstract contract ERC165 is IERC165 {
431     /**
432      * @dev See {IERC165-supportsInterface}.
433      */
434     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
435         return interfaceId == type(IERC165).interfaceId;
436     }
437 }
438 
439 /**
440  * @dev Required interface of an ERC721 compliant contract.
441  */
442 interface IERC721 is IERC165 {
443     /**
444      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
445      */
446     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
447 
448     /**
449      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
450      */
451     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
455      */
456     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
457 
458     /**
459      * @dev Returns the number of tokens in ``owner``'s account.
460      */
461     function balanceOf(address owner) external view returns (uint256 balance);
462 
463     /**
464      * @dev Returns the owner of the `tokenId` token.
465      *
466      * Requirements:
467      *
468      * - `tokenId` must exist.
469      */
470     function ownerOf(uint256 tokenId) external view returns (address owner);
471 
472     /**
473      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
474      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must exist and be owned by `from`.
481      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
482      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
483      *
484      * Emits a {Transfer} event.
485      */
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) external;
491 
492     /**
493      * @dev Transfers `tokenId` token from `from` to `to`.
494      *
495      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must be owned by `from`.
502      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
503      *
504      * Emits a {Transfer} event.
505      */
506     function transferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
514      * The approval is cleared when the token is transferred.
515      *
516      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
517      *
518      * Requirements:
519      *
520      * - The caller must own the token or be an approved operator.
521      * - `tokenId` must exist.
522      *
523      * Emits an {Approval} event.
524      */
525     function approve(address to, uint256 tokenId) external;
526 
527     /**
528      * @dev Returns the account approved for `tokenId` token.
529      *
530      * Requirements:
531      *
532      * - `tokenId` must exist.
533      */
534     function getApproved(uint256 tokenId) external view returns (address operator);
535 
536     /**
537      * @dev Approve or remove `operator` as an operator for the caller.
538      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
539      *
540      * Requirements:
541      *
542      * - The `operator` cannot be the caller.
543      *
544      * Emits an {ApprovalForAll} event.
545      */
546     function setApprovalForAll(address operator, bool _approved) external;
547 
548     /**
549      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
550      *
551      * See {setApprovalForAll}
552      */
553     function isApprovedForAll(address owner, address operator) external view returns (bool);
554 
555     /**
556      * @dev Safely transfers `tokenId` token from `from` to `to`.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must exist and be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId,
572         bytes calldata data
573     ) external;
574 }
575 
576 /**
577  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
578  * @dev See https://eips.ethereum.org/EIPS/eip-721
579  */
580 interface IERC721Enumerable is IERC721 {
581     /**
582      * @dev Returns the total amount of tokens stored by the contract.
583      */
584     function totalSupply() external view returns (uint256);
585 
586     /**
587      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
588      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
589      */
590     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
591 
592     /**
593      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
594      * Use along with {totalSupply} to enumerate all tokens.
595      */
596     function tokenByIndex(uint256 index) external view returns (uint256);
597 }
598 
599 
600 /**
601  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
602  * @dev See https://eips.ethereum.org/EIPS/eip-721
603  */
604 interface IERC721Metadata is IERC721 {
605     /**
606      * @dev Returns the token collection name.
607      */
608     function name() external view returns (string memory);
609 
610     /**
611      * @dev Returns the token collection symbol.
612      */
613     function symbol() external view returns (string memory);
614 
615     /**
616      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
617      */
618     function tokenURI(uint256 tokenId) external view returns (string memory);
619 }
620 
621 /**
622  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
623  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
624  *
625  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
626  *
627  * Does not support burning tokens to address(0).
628  *
629  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
630  */
631 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
632     using Address for address;
633     using Strings for uint256;
634 
635     struct TokenOwnership {
636         address addr;
637         uint64 startTimestamp;
638     }
639 
640     struct AddressData {
641         uint128 balance;
642         uint128 numberMinted;
643     }
644 
645     uint256 internal currentIndex;
646 
647     // Token name
648     string private _name;
649 
650     // Token symbol
651     string private _symbol;
652 
653     // Mapping from token ID to ownership details
654     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
655     mapping(uint256 => TokenOwnership) internal _ownerships;
656 
657     // Mapping owner address to address data
658     mapping(address => AddressData) private _addressData;
659 
660     // Mapping from token ID to approved address
661     mapping(uint256 => address) private _tokenApprovals;
662 
663     // Mapping from owner to operator approvals
664     mapping(address => mapping(address => bool)) private _operatorApprovals;
665 
666     constructor(string memory name_, string memory symbol_) {
667         _name = name_;
668         _symbol = symbol_;
669     }
670 
671     /**
672      * @dev See {IERC721Enumerable-totalSupply}.
673      */
674     function totalSupply() public view override returns (uint256) {
675         return currentIndex - 1;
676     }
677 
678     /**
679      * @dev See {IERC721Enumerable-tokenByIndex}.
680      */
681     function tokenByIndex(uint256 index) public view override returns (uint256) {
682         require(index < totalSupply(), 'ERC721A: global index out of bounds');
683         return index;
684     }
685 
686     /**
687      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
688      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
689      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
690      */
691     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
692         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
693         uint256 numMintedSoFar = totalSupply();
694         uint256 tokenIdsIdx;
695         address currOwnershipAddr;
696 
697         // currentIndex overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
698         unchecked {
699             for (uint256 i; i < numMintedSoFar; i++) {
700                 TokenOwnership memory ownership = _ownerships[i];
701                 if (ownership.addr != address(0)) {
702                     currOwnershipAddr = ownership.addr;
703                 }
704                 if (currOwnershipAddr == owner) {
705                     if (tokenIdsIdx == index) {
706                         return i;
707                     }
708                     tokenIdsIdx++;
709                 }
710             }
711         }
712 
713         revert('ERC721A: unable to get token of owner by index');
714     }
715 
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
720         return
721             interfaceId == type(IERC721).interfaceId ||
722             interfaceId == type(IERC721Metadata).interfaceId ||
723             interfaceId == type(IERC721Enumerable).interfaceId ||
724             super.supportsInterface(interfaceId);
725     }
726 
727     /**
728      * @dev See {IERC721-balanceOf}.
729      */
730     function balanceOf(address owner) public view override returns (uint256) {
731         require(owner != address(0), 'ERC721A: balance query for the zero address');
732         return uint256(_addressData[owner].balance);
733     }
734 
735     function _numberMinted(address owner) internal view returns (uint256) {
736         require(owner != address(0), 'ERC721A: number minted query for the zero address');
737         return uint256(_addressData[owner].numberMinted);
738     }
739 
740     /**
741      * Gas spent here starts off proportional to the maximum mint batch size.
742      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
743      */
744     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
745         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
746 
747         unchecked {
748             for (uint256 curr = tokenId; curr >= 0; curr--) {
749                 TokenOwnership memory ownership = _ownerships[curr];
750                 if (ownership.addr != address(0)) {
751                     return ownership;
752                 }
753             }
754         }
755 
756         revert('ERC721A: unable to determine the owner of token');
757     }
758 
759     /**
760      * @dev See {IERC721-ownerOf}.
761      */
762     function ownerOf(uint256 tokenId) public view override returns (address) {
763         return ownershipOf(tokenId).addr;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-name}.
768      */
769     function name() public view virtual override returns (string memory) {
770         return _name;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-symbol}.
775      */
776     function symbol() public view virtual override returns (string memory) {
777         return _symbol;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-tokenURI}.
782      */
783     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
784         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
785 
786         string memory baseURI = _baseURI();
787         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
788     }
789 
790     /**
791      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
792      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
793      * by default, can be overriden in child contracts.
794      */
795     function _baseURI() internal view virtual returns (string memory) {
796         return '';
797     }
798 
799     /**
800      * @dev See {IERC721-approve}.
801      */
802     function approve(address to, uint256 tokenId) public override {
803         address owner = ERC721A.ownerOf(tokenId);
804         require(to != owner, 'ERC721A: approval to current owner');
805 
806         require(
807             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
808             'ERC721A: approve caller is not owner nor approved for all'
809         );
810 
811         _approve(to, tokenId, owner);
812     }
813 
814     /**
815      * @dev See {IERC721-getApproved}.
816      */
817     function getApproved(uint256 tokenId) public view override returns (address) {
818         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
819 
820         return _tokenApprovals[tokenId];
821     }
822 
823     /**
824      * @dev See {IERC721-setApprovalForAll}.
825      */
826     function setApprovalForAll(address operator, bool approved) public override {
827         require(operator != _msgSender(), 'ERC721A: approve to caller');
828 
829         _operatorApprovals[_msgSender()][operator] = approved;
830         emit ApprovalForAll(_msgSender(), operator, approved);
831     }
832 
833     /**
834      * @dev See {IERC721-isApprovedForAll}.
835      */
836     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
837         return _operatorApprovals[owner][operator];
838     }
839 
840     /**
841      * @dev See {IERC721-transferFrom}.
842      */
843     function transferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public override {
848         _transfer(from, to, tokenId);
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) public override {
859         safeTransferFrom(from, to, tokenId, '');
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) public override {
871         _transfer(from, to, tokenId);
872         require(
873             _checkOnERC721Received(from, to, tokenId, _data),
874             'ERC721A: transfer to non ERC721Receiver implementer'
875         );
876     }
877 
878     /**
879      * @dev Returns whether `tokenId` exists.
880      *
881      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
882      *
883      * Tokens start existing when they are minted (`_mint`),
884      */
885     function _exists(uint256 tokenId) internal view returns (bool) {
886         return tokenId < currentIndex;
887     }
888 
889     function _safeMint(address to, uint256 quantity) internal {
890         _safeMint(to, quantity, '');
891     }
892 
893     /**
894      * @dev Safely mints `quantity` tokens and transfers them to `to`.
895      *
896      * Requirements:
897      *
898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
899      * - `quantity` must be greater than 0.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _safeMint(
904         address to,
905         uint256 quantity,
906         bytes memory _data
907     ) internal {
908         _mint(to, quantity, _data, true);
909     }
910 
911     /**
912      * @dev Mints `quantity` tokens and transfers them to `to`.
913      *
914      * Requirements:
915      *
916      * - `to` cannot be the zero address.
917      * - `quantity` must be greater than 0.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _mint(
922         address to,
923         uint256 quantity,
924         bytes memory _data,
925         bool safe
926     ) internal {
927         uint256 startTokenId = currentIndex;
928         require(to != address(0), 'ERC721A: mint to the zero address');
929         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
930 
931         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
932 
933         // Overflows are incredibly unrealistic.
934         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
935         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
936         unchecked {
937             _addressData[to].balance += uint128(quantity);
938             _addressData[to].numberMinted += uint128(quantity);
939 
940             _ownerships[startTokenId].addr = to;
941             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
942 
943             uint256 updatedIndex = startTokenId;
944 
945             for (uint256 i; i < quantity; i++) {
946                 emit Transfer(address(0), to, updatedIndex);
947                 if (safe) {
948                     require(
949                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
950                         'ERC721A: transfer to non ERC721Receiver implementer'
951                     );
952                 }
953 
954                 updatedIndex++;
955             }
956 
957             currentIndex = updatedIndex;
958         }
959 
960         _afterTokenTransfers(address(0), to, startTokenId, quantity);
961     }
962 
963     /**
964      * @dev Transfers `tokenId` from `from` to `to`.
965      *
966      * Requirements:
967      *
968      * - `to` cannot be the zero address.
969      * - `tokenId` token must be owned by `from`.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _transfer(
974         address from,
975         address to,
976         uint256 tokenId
977     ) private {
978         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
979 
980         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
981             getApproved(tokenId) == _msgSender() ||
982             isApprovedForAll(prevOwnership.addr, _msgSender()));
983 
984         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
985 
986         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
987         require(to != address(0), 'ERC721A: transfer to the zero address');
988 
989         _beforeTokenTransfers(from, to, tokenId, 1);
990 
991         // Clear approvals from the previous owner
992         _approve(address(0), tokenId, prevOwnership.addr);
993 
994         // Underflow of the sender's balance is impossible because we check for
995         // ownership above and the recipient's balance can't realistically overflow.
996         // currentIndex overflow is incredibly unrealistic as tokenId would have to be 2**256.
997         unchecked {
998             _addressData[from].balance -= 1;
999             _addressData[to].balance += 1;
1000 
1001             _ownerships[tokenId].addr = to;
1002             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1003 
1004             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1005             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1006             uint256 nextTokenId = tokenId + 1;
1007             if (_ownerships[nextTokenId].addr == address(0)) {
1008                 if (_exists(nextTokenId)) {
1009                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1010                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1011                 }
1012             }
1013         }
1014 
1015         emit Transfer(from, to, tokenId);
1016         _afterTokenTransfers(from, to, tokenId, 1);
1017     }
1018 
1019     /**
1020      * @dev Approve `to` to operate on `tokenId`
1021      *
1022      * Emits a {Approval} event.
1023      */
1024     function _approve(
1025         address to,
1026         uint256 tokenId,
1027         address owner
1028     ) private {
1029         _tokenApprovals[tokenId] = to;
1030         emit Approval(owner, to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1035      * The call is not executed if the target address is not a contract.
1036      *
1037      * @param from address representing the previous owner of the given token ID
1038      * @param to target address that will receive the tokens
1039      * @param tokenId uint256 ID of the token to be transferred
1040      * @param _data bytes optional data to send along with the call
1041      * @return bool whether the call correctly returned the expected magic value
1042      */
1043     function _checkOnERC721Received(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) private returns (bool) {
1049         if (to.isContract()) {
1050             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1051                 return retval == IERC721Receiver(to).onERC721Received.selector;
1052             } catch (bytes memory reason) {
1053                 if (reason.length == 0) {
1054                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1055                 } else {
1056                     assembly {
1057                         revert(add(32, reason), mload(reason))
1058                     }
1059                 }
1060             }
1061         } else {
1062             return true;
1063         }
1064     }
1065 
1066     /**
1067      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1068      *
1069      * startTokenId - the first token id to be transferred
1070      * quantity - the amount to be transferred
1071      *
1072      * Calling conditions:
1073      *
1074      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1075      * transferred to `to`.
1076      * - When `from` is zero, `tokenId` will be minted for `to`.
1077      */
1078     function _beforeTokenTransfers(
1079         address from,
1080         address to,
1081         uint256 startTokenId,
1082         uint256 quantity
1083     ) internal virtual {}
1084 
1085     /**
1086      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1087      * minting.
1088      *
1089      * startTokenId - the first token id to be transferred
1090      * quantity - the amount to be transferred
1091      *
1092      * Calling conditions:
1093      *
1094      * - when `from` and `to` are both non-zero.
1095      * - `from` and `to` are never both zero.
1096      */
1097     function _afterTokenTransfers(
1098         address from,
1099         address to,
1100         uint256 startTokenId,
1101         uint256 quantity
1102     ) internal virtual {}
1103 }
1104 
1105 contract BoredApePlayingCards is ERC721A, Ownable {
1106 
1107     uint8 public maxMintsPerWallet;
1108     uint public maxSupply;
1109     uint public whitelistPrice;
1110     uint public salePrice;
1111 
1112     string public baseURI;
1113 
1114     bool public saleStatus;
1115 
1116     address public token;
1117 
1118     mapping(address => bool) public _whitelisted;
1119     mapping(address => uint8) public _maxMintedPerWallet;
1120     
1121 
1122     constructor() ERC721A("BoredApePlayingCards", "BAPC") {}
1123 
1124     function setMaxSupply(uint _maxSupply) external onlyOwner {
1125         maxSupply = _maxSupply;
1126     }
1127 
1128     function setTokenForWhitelist(address _token) external onlyOwner {
1129         token = _token;
1130     }
1131 
1132     function addToWhitelist(address[] memory whitelisted) external onlyOwner {
1133         for(uint8 i=0; i<whitelisted.length; i++){
1134             _whitelisted[whitelisted[i]] = !_whitelisted[whitelisted[i]];
1135         }
1136     }
1137 
1138     function setWhitelistPrice(uint _whitelistPrice) external onlyOwner {
1139         whitelistPrice = _whitelistPrice;
1140     }
1141 
1142     function setSalePrice(uint _salePrice) external onlyOwner {
1143         salePrice = _salePrice;
1144     }
1145 
1146     function setMaxMintPerWallet(uint8 _maxMintsPerWallet) external onlyOwner {
1147         maxMintsPerWallet = _maxMintsPerWallet;
1148     }
1149 
1150     function flipSaleStatus() external onlyOwner {
1151         saleStatus = !saleStatus;
1152     }
1153 
1154     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1155         baseURI = _newBaseURI;
1156     }
1157 
1158     function withdraw() external onlyOwner {
1159         payable(msg.sender).transfer(address(this).balance);
1160     }
1161 
1162     function _baseURI() internal view override returns (string memory) {
1163         return baseURI;
1164     }
1165 
1166     function buyOne() external payable {
1167         require(saleStatus, "Sale not active!");
1168         require(_maxMintedPerWallet[msg.sender] < maxMintsPerWallet, "Mint limit reached!");
1169         require(currentIndex < maxSupply, "Sale finished!");
1170         uint balance = IERC721(token).balanceOf(msg.sender);
1171         if(balance > 0 || _whitelisted[msg.sender]){
1172             require(msg.value == whitelistPrice, "Incorrect value!");
1173             _safeMint(msg.sender, 1);
1174             _maxMintedPerWallet[msg.sender]++;
1175         }else{
1176             require(msg.value == salePrice, "Incorrect value!");
1177             _safeMint(msg.sender, 1);
1178             _maxMintedPerWallet[msg.sender]++;
1179         }
1180     }
1181 
1182     function buyFive() external payable {
1183         require(saleStatus, "Sale not active!");
1184         require(_maxMintedPerWallet[msg.sender] + 5 <= maxMintsPerWallet, "Exceeds mint limit!");
1185         require(currentIndex + 5 < maxSupply, "Not enough tokens!");
1186         uint balance = IERC721(token).balanceOf(msg.sender);
1187         if(balance > 0 || _whitelisted[msg.sender]){
1188             uint priceDiscounted = whitelistPrice * 90 / 100;
1189             uint price = priceDiscounted * 5;
1190             require(msg.value == price, "Incorrect value!");
1191             _safeMint(msg.sender, 5);
1192             _maxMintedPerWallet[msg.sender]+= 5;
1193         }else{ 
1194             uint priceDiscounted = salePrice * 90 / 100;
1195             uint price = priceDiscounted * 5;
1196             require(msg.value == price, "Incorrect value!");
1197             _safeMint(msg.sender, 5);
1198             _maxMintedPerWallet[msg.sender]+= 5;
1199         }
1200     }
1201 
1202     function buyTen() external payable {
1203         require(saleStatus, "Sale not active!");
1204         require(_maxMintedPerWallet[msg.sender] + 10 <= maxMintsPerWallet, "Exceeds mint limit!");
1205         require(currentIndex + 10 < maxSupply, "Not enough tokens!");
1206         uint balance = IERC721(token).balanceOf(msg.sender);
1207         if(balance > 0 || _whitelisted[msg.sender]){
1208             uint priceDiscounted = whitelistPrice * 80 / 100;
1209             uint price = priceDiscounted * 10;
1210             require(msg.value == price, "Incorrect value!");
1211             _safeMint(msg.sender, 10);
1212             _maxMintedPerWallet[msg.sender]+= 10;
1213         }else{
1214             uint priceDiscounted = salePrice * 80 / 100;
1215             uint price = priceDiscounted * 10;
1216             require(msg.value == price, "Incorrect value!");
1217             _safeMint(msg.sender, 10);
1218             _maxMintedPerWallet[msg.sender]+= 10;
1219         }
1220     }
1221 }