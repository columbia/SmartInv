1 /*
2     The Nimrodz NFT Minting Contract ERC721A
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.14;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // Context.sol
72 /**
73  * @dev Provides information about the current execution context, including the
74  * sender of the transaction and its data. While these are generally available
75  * via msg.sender and msg.data, they should not be accessed in such a direct
76  * manner, since when dealing with meta-transactions the account sending and
77  * paying for execution may not be the actual sender (as far as an application
78  * is concerned).
79  *
80  * This contract is only required for intermediate, library-like contracts.
81  */
82 abstract contract Context {
83     function _msgSender() internal view virtual returns (address) {
84         return msg.sender;
85     }
86 
87     function _msgData() internal view virtual returns (bytes calldata) {
88         return msg.data;
89     }
90 }
91 
92 
93 // Ownable.sol
94 /**
95  * @dev Contract module which provides a basic access control mechanism, where
96  * there is an account (an owner) that can be granted exclusive access to
97  * specific functions.
98  *
99  * By default, the owner account will be the one that deploys the contract. This
100  * can later be changed with {transferOwnership}.
101  *
102  * This module is used through inheritance. It will make available the modifier
103  * `onlyOwner`, which can be applied to your functions to restrict their use to
104  * the owner.
105  */
106 abstract contract Ownable is Context {
107     address private _owner;
108 
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111     /**
112      * @dev Initializes the contract setting the deployer as the initial owner.
113      */
114     constructor() {
115         _setOwner(_msgSender());
116     }
117 
118     /**
119      * @dev Returns the address of the current owner.
120      */
121     function owner() public view virtual returns (address) {
122         return _owner;
123     }
124 
125     /**
126      * @dev Throws if called by any account other than the owner.
127      */
128     modifier onlyOwner() {
129         require(owner() == _msgSender(), "Ownable: caller is not the owner");
130         _;
131     }
132 
133     /**
134      * @dev Leaves the contract without owner. It will not be possible to call
135      * `onlyOwner` functions anymore. Can only be called by the current owner.
136      *
137      * NOTE: Renouncing ownership will leave the contract without an owner,
138      * thereby removing any functionality that is only available to the owner.
139      */
140     function renounceOwnership() public virtual onlyOwner {
141         _setOwner(address(0));
142     }
143 
144     /**
145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
146      * Can only be called by the current owner.
147      */
148     function transferOwnership(address newOwner) public virtual onlyOwner {
149         require(newOwner != address(0), "Ownable: new owner is the zero address");
150         _setOwner(newOwner);
151     }
152 
153     function _setOwner(address newOwner) private {
154         address oldOwner = _owner;
155         _owner = newOwner;
156         emit OwnershipTransferred(oldOwner, newOwner);
157     }
158 }
159 
160 // Address.sol
161 /**
162  * @dev Collection of functions related to the address type
163  */
164 library Address {
165     /**
166      * @dev Returns true if `account` is a contract.
167      *
168      * [IMPORTANT]
169      * ====
170      * It is unsafe to assume that an address for which this function returns
171      * false is an externally-owned account (EOA) and not a contract.
172      *
173      * Among others, `isContract` will return false for the following
174      * types of addresses:
175      *
176      *  - an externally-owned account
177      *  - a contract in construction
178      *  - an address where a contract will be created
179      *  - an address where a contract lived, but was destroyed
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies on extcodesize, which returns 0 for contracts in
184         // construction, since the code is only stored at the end of the
185         // constructor execution.
186 
187         uint256 size;
188         assembly {
189             size := extcodesize(account)
190         }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         (bool success, ) = recipient.call{value: amount}("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217     /**
218      * @dev Performs a Solidity function call using a low level `call`. A
219      * plain `call` is an unsafe replacement for a function call: use this
220      * function instead.
221      *
222      * If `target` reverts with a revert reason, it is bubbled up by this
223      * function (like regular Solidity function calls).
224      *
225      * Returns the raw returned data. To convert to the expected return value,
226      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
227      *
228      * Requirements:
229      *
230      * - `target` must be a contract.
231      * - calling `target` with `data` must not revert.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
236         return functionCall(target, data, "Address: low-level call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
241      * `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal returns (bytes memory) {
250         return functionCallWithValue(target, data, 0, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but also transferring `value` wei to `target`.
256      *
257      * Requirements:
258      *
259      * - the calling contract must have an ETH balance of at least `value`.
260      * - the called Solidity function must be `payable`.
261      *
262      * _Available since v3.1._
263      */
264     function functionCallWithValue(
265         address target,
266         bytes memory data,
267         uint256 value
268     ) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
274      * with `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCallWithValue(
279         address target,
280         bytes memory data,
281         uint256 value,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         require(address(this).balance >= value, "Address: insufficient balance for call");
285         require(isContract(target), "Address: call to non-contract");
286 
287         (bool success, bytes memory returndata) = target.call{value: value}(data);
288         return _verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but performing a static call.
294      *
295      * _Available since v3.3._
296      */
297     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
298         return functionStaticCall(target, data, "Address: low-level static call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
303      * but performing a static call.
304      *
305      * _Available since v3.3._
306      */
307     function functionStaticCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal view returns (bytes memory) {
312         require(isContract(target), "Address: static call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.staticcall(data);
315         return _verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.4._
323      */
324     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a delegate call.
331      *
332      * _Available since v3.4._
333      */
334     function functionDelegateCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         require(isContract(target), "Address: delegate call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.delegatecall(data);
342         return _verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     function _verifyCallResult(
346         bool success,
347         bytes memory returndata,
348         string memory errorMessage
349     ) private pure returns (bytes memory) {
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
368 // IERC721Receiver.sol
369 /**
370  * @title ERC721 token receiver interface
371  * @dev Interface for any contract that wants to support safeTransfers
372  * from ERC721 asset contracts.
373  */
374 interface IERC721Receiver {
375     /**
376      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
377      * by `operator` from `from`, this function is called.
378      *
379      * It must return its Solidity selector to confirm the token transfer.
380      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
381      *
382      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
383      */
384     function onERC721Received(
385         address operator,
386         address from,
387         uint256 tokenId,
388         bytes calldata data
389     ) external returns (bytes4);
390 }
391 
392 // IERC165.sol
393 /**
394  * @dev Interface of the ERC165 standard, as defined in the
395  * https://eips.ethereum.org/EIPS/eip-165[EIP].
396  *
397  * Implementers can declare support of contract interfaces, which can then be
398  * queried by others ({ERC165Checker}).
399  *
400  * For an implementation, see {ERC165}.
401  */
402 interface IERC165 {
403     /**
404      * @dev Returns true if this contract implements the interface defined by
405      * `interfaceId`. See the corresponding
406      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
407      * to learn more about how these ids are created.
408      *
409      * This function call must use less than 30 000 gas.
410      */
411     function supportsInterface(bytes4 interfaceId) external view returns (bool);
412 }
413 
414 // ERC165.sol
415 /**
416  * @dev Implementation of the {IERC165} interface.
417  *
418  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
419  * for the additional interface id that will be supported. For example:
420  *
421  * ```solidity
422  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
423  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
424  * }
425  * ```
426  *
427  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
428  */
429 abstract contract ERC165 is IERC165 {
430     /**
431      * @dev See {IERC165-supportsInterface}.
432      */
433     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
434         return interfaceId == type(IERC165).interfaceId;
435     }
436 }
437 
438 // IERC721.sol
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
576 // IERC721Enumerable.sol
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
579  * @dev See https://eips.ethereum.org/EIPS/eip-721
580  */
581 interface IERC721Enumerable is IERC721 {
582     /**
583      * @dev Returns the total amount of tokens stored by the contract.
584      */
585     function totalSupply() external view returns (uint256);
586 
587     /**
588      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
589      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
590      */
591     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
592 
593     /**
594      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
595      * Use along with {totalSupply} to enumerate all tokens.
596      */
597     function tokenByIndex(uint256 index) external view returns (uint256);
598 }
599 
600 // IERC721Metadata.sol
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Metadata is IERC721 {
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the token collection symbol.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
618      */
619     function tokenURI(uint256 tokenId) external view returns (string memory);
620 }
621 
622 // ERC721A.sol
623 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
624     using Address for address;
625     using Strings for uint256;
626 
627     struct TokenOwnership {
628         address addr;
629         uint64 startTimestamp;
630     }
631 
632     struct AddressData {
633         uint128 balance;
634         uint128 numberMinted;
635     }
636 
637     uint256 internal currentIndex;
638 
639     // Token name
640     string private _name;
641 
642     // Token symbol
643     string private _symbol;
644 
645     // Mapping from token ID to ownership details
646     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
647     mapping(uint256 => TokenOwnership) internal _ownerships;
648 
649     // Mapping owner address to address data
650     mapping(address => AddressData) private _addressData;
651 
652     // Mapping from token ID to approved address
653     mapping(uint256 => address) private _tokenApprovals;
654 
655     // Mapping from owner to operator approvals
656     mapping(address => mapping(address => bool)) private _operatorApprovals;
657 
658     constructor(string memory name_, string memory symbol_) {
659         _name = name_;
660         _symbol = symbol_;
661     }
662 
663     /**
664      * @dev See {IERC721Enumerable-totalSupply}.
665      */
666     function totalSupply() public view override returns (uint256) {
667         return currentIndex;
668     }
669 
670     /**
671      * @dev See {IERC721Enumerable-tokenByIndex}.
672      */
673     function tokenByIndex(uint256 index) public view override returns (uint256) {
674         require(index < totalSupply(), 'ERC721A: global index out of bounds');
675         return index;
676     }
677 
678     /**
679      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
680      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
681      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
682      */
683     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
684         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
685         uint256 numMintedSoFar = totalSupply();
686         uint256 tokenIdsIdx;
687         address currOwnershipAddr;
688 
689         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
690         unchecked {
691             for (uint256 i; i < numMintedSoFar; i++) {
692                 TokenOwnership memory ownership = _ownerships[i];
693                 if (ownership.addr != address(0)) {
694                     currOwnershipAddr = ownership.addr;
695                 }
696                 if (currOwnershipAddr == owner) {
697                     if (tokenIdsIdx == index) {
698                         return i;
699                     }
700                     tokenIdsIdx++;
701                 }
702             }
703         }
704 
705         revert('ERC721A: unable to get token of owner by index');
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
712         return
713             interfaceId == type(IERC721).interfaceId ||
714             interfaceId == type(IERC721Metadata).interfaceId ||
715             interfaceId == type(IERC721Enumerable).interfaceId ||
716             super.supportsInterface(interfaceId);
717     }
718 
719     /**
720      * @dev See {IERC721-balanceOf}.
721      */
722     function balanceOf(address owner) public view override returns (uint256) {
723         require(owner != address(0), 'ERC721A: balance query for the zero address');
724         return uint256(_addressData[owner].balance);
725     }
726 
727     function _numberMinted(address owner) internal view returns (uint256) {
728         require(owner != address(0), 'ERC721A: number minted query for the zero address');
729         return uint256(_addressData[owner].numberMinted);
730     }
731 
732     /**
733      * Gas spent here starts off proportional to the maximum mint batch size.
734      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
735      */
736     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
737         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
738 
739         unchecked {
740             for (uint256 curr = tokenId; curr >= 0; curr--) {
741                 TokenOwnership memory ownership = _ownerships[curr];
742                 if (ownership.addr != address(0)) {
743                     return ownership;
744                 }
745             }
746         }
747 
748         revert('ERC721A: unable to determine the owner of token');
749     }
750 
751     /**
752      * @dev See {IERC721-ownerOf}.
753      */
754     function ownerOf(uint256 tokenId) public view override returns (address) {
755         return ownershipOf(tokenId).addr;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-name}.
760      */
761     function name() public view virtual override returns (string memory) {
762         return _name;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-symbol}.
767      */
768     function symbol() public view virtual override returns (string memory) {
769         return _symbol;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-tokenURI}.
774      */
775     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
776         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
777 
778         string memory baseURI = _baseURI();
779         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
780     }
781 
782     /**
783      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
784      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
785      * by default, can be overriden in child contracts.
786      */
787     function _baseURI() internal view virtual returns (string memory) {
788         return '';
789     }
790 
791     /**
792      * @dev See {IERC721-approve}.
793      */
794     function approve(address to, uint256 tokenId) public override {
795         address owner = ERC721A.ownerOf(tokenId);
796         require(to != owner, 'ERC721A: approval to current owner');
797 
798         require(
799             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
800             'ERC721A: approve caller is not owner nor approved for all'
801         );
802 
803         _approve(to, tokenId, owner);
804     }
805 
806     /**
807      * @dev See {IERC721-getApproved}.
808      */
809     function getApproved(uint256 tokenId) public view override returns (address) {
810         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
811 
812         return _tokenApprovals[tokenId];
813     }
814 
815     /**
816      * @dev See {IERC721-setApprovalForAll}.
817      */
818     function setApprovalForAll(address operator, bool approved) public override {
819         require(operator != _msgSender(), 'ERC721A: approve to caller');
820 
821         _operatorApprovals[_msgSender()][operator] = approved;
822         emit ApprovalForAll(_msgSender(), operator, approved);
823     }
824 
825     /**
826      * @dev See {IERC721-isApprovedForAll}.
827      */
828     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
829         return _operatorApprovals[owner][operator];
830     }
831 
832     /**
833      * @dev See {IERC721-transferFrom}.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) public override {
840         _transfer(from, to, tokenId);
841     }
842 
843     /**
844      * @dev See {IERC721-safeTransferFrom}.
845      */
846     function safeTransferFrom(
847         address from,
848         address to,
849         uint256 tokenId
850     ) public override {
851         safeTransferFrom(from, to, tokenId, '');
852     }
853 
854     /**
855      * @dev See {IERC721-safeTransferFrom}.
856      */
857     function safeTransferFrom(
858         address from,
859         address to,
860         uint256 tokenId,
861         bytes memory _data
862     ) public override {
863         _transfer(from, to, tokenId);
864         require(
865             _checkOnERC721Received(from, to, tokenId, _data),
866             'ERC721A: transfer to non ERC721Receiver implementer'
867         );
868     }
869 
870     /**
871      * @dev Returns whether `tokenId` exists.
872      *
873      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
874      *
875      * Tokens start existing when they are minted (`_mint`),
876      */
877     function _exists(uint256 tokenId) internal view returns (bool) {
878         return tokenId < currentIndex;
879     }
880 
881     function _safeMint(address to, uint256 quantity) internal {
882         _safeMint(to, quantity, '');
883     }
884 
885     /**
886      * @dev Safely mints `quantity` tokens and transfers them to `to`.
887      *
888      * Requirements:
889      *
890      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
891      * - `quantity` must be greater than 0.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _safeMint(
896         address to,
897         uint256 quantity,
898         bytes memory _data
899     ) internal {
900         _mint(to, quantity, _data, true);
901     }
902 
903     /**
904      * @dev Mints `quantity` tokens and transfers them to `to`.
905      *
906      * Requirements:
907      *
908      * - `to` cannot be the zero address.
909      * - `quantity` must be greater than 0.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _mint(
914         address to,
915         uint256 quantity,
916         bytes memory _data,
917         bool safe
918     ) internal {
919         uint256 startTokenId = currentIndex;
920         require(to != address(0), 'ERC721A: mint to the zero address');
921         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
922 
923         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
924 
925         // Overflows are incredibly unrealistic.
926         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
927         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
928         unchecked {
929             _addressData[to].balance += uint128(quantity);
930             _addressData[to].numberMinted += uint128(quantity);
931 
932             _ownerships[startTokenId].addr = to;
933             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
934 
935             uint256 updatedIndex = startTokenId;
936 
937             for (uint256 i; i < quantity; i++) {
938                 emit Transfer(address(0), to, updatedIndex);
939                 if (safe) {
940                     require(
941                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
942                         'ERC721A: transfer to non ERC721Receiver implementer'
943                     );
944                 }
945 
946                 updatedIndex++;
947             }
948 
949             currentIndex = updatedIndex;
950         }
951 
952         _afterTokenTransfers(address(0), to, startTokenId, quantity);
953     }
954 
955     /**
956      * @dev Transfers `tokenId` from `from` to `to`.
957      *
958      * Requirements:
959      *
960      * - `to` cannot be the zero address.
961      * - `tokenId` token must be owned by `from`.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _transfer(
966         address from,
967         address to,
968         uint256 tokenId
969     ) private {
970         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
971 
972         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
973             getApproved(tokenId) == _msgSender() ||
974             isApprovedForAll(prevOwnership.addr, _msgSender()));
975 
976         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
977 
978         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
979         require(to != address(0), 'ERC721A: transfer to the zero address');
980 
981         _beforeTokenTransfers(from, to, tokenId, 1);
982 
983         // Clear approvals from the previous owner
984         _approve(address(0), tokenId, prevOwnership.addr);
985 
986         // Underflow of the sender's balance is impossible because we check for
987         // ownership above and the recipient's balance can't realistically overflow.
988         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
989         unchecked {
990             _addressData[from].balance -= 1;
991             _addressData[to].balance += 1;
992 
993             _ownerships[tokenId].addr = to;
994             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
995 
996             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
997             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
998             uint256 nextTokenId = tokenId + 1;
999             if (_ownerships[nextTokenId].addr == address(0)) {
1000                 if (_exists(nextTokenId)) {
1001                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1002                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1003                 }
1004             }
1005         }
1006 
1007         emit Transfer(from, to, tokenId);
1008         _afterTokenTransfers(from, to, tokenId, 1);
1009     }
1010 
1011     /**
1012      * @dev Approve `to` to operate on `tokenId`
1013      *
1014      * Emits a {Approval} event.
1015      */
1016     function _approve(
1017         address to,
1018         uint256 tokenId,
1019         address owner
1020     ) private {
1021         _tokenApprovals[tokenId] = to;
1022         emit Approval(owner, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1027      * The call is not executed if the target address is not a contract.
1028      *
1029      * @param from address representing the previous owner of the given token ID
1030      * @param to target address that will receive the tokens
1031      * @param tokenId uint256 ID of the token to be transferred
1032      * @param _data bytes optional data to send along with the call
1033      * @return bool whether the call correctly returned the expected magic value
1034      */
1035     function _checkOnERC721Received(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) private returns (bool) {
1041         if (to.isContract()) {
1042             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1043                 return retval == IERC721Receiver(to).onERC721Received.selector;
1044             } catch (bytes memory reason) {
1045                 if (reason.length == 0) {
1046                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1047                 } else {
1048                     assembly {
1049                         revert(add(32, reason), mload(reason))
1050                     }
1051                 }
1052             }
1053         } else {
1054             return true;
1055         }
1056     }
1057 
1058     /**
1059      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1060      *
1061      * startTokenId - the first token id to be transferred
1062      * quantity - the amount to be transferred
1063      *
1064      * Calling conditions:
1065      *
1066      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1067      * transferred to `to`.
1068      * - When `from` is zero, `tokenId` will be minted for `to`.
1069      */
1070     function _beforeTokenTransfers(
1071         address from,
1072         address to,
1073         uint256 startTokenId,
1074         uint256 quantity
1075     ) internal virtual {}
1076 
1077     /**
1078      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1079      * minting.
1080      *
1081      * startTokenId - the first token id to be transferred
1082      * quantity - the amount to be transferred
1083      *
1084      * Calling conditions:
1085      *
1086      * - when `from` and `to` are both non-zero.
1087      * - `from` and `to` are never both zero.
1088      */
1089     function _afterTokenTransfers(
1090         address from,
1091         address to,
1092         uint256 startTokenId,
1093         uint256 quantity
1094     ) internal virtual {}
1095 }
1096 
1097 // ReentrancyGuard.sol
1098 /**
1099  * @dev Contract module that helps prevent reentrant calls to a function.
1100  *
1101  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1102  * available, which can be applied to functions to make sure there are no nested
1103  * (reentrant) calls to them.
1104  *
1105  * Note that because there is a single `nonReentrant` guard, functions marked as
1106  * `nonReentrant` may not call one another. This can be worked around by making
1107  * those functions `private`, and then adding `external` `nonReentrant` entry
1108  * points to them.
1109  *
1110  * TIP: If you would like to learn more about reentrancy and alternative ways
1111  * to protect against it, check out our blog post
1112  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1113  */
1114 abstract contract ReentrancyGuard {
1115     // Booleans are more expensive than uint256 or any type that takes up a full
1116     // word because each write operation emits an extra SLOAD to first read the
1117     // slot's contents, replace the bits taken up by the boolean, and then write
1118     // back. This is the compiler's defense against contract upgrades and
1119     // pointer aliasing, and it cannot be disabled.
1120 
1121     // The values being non-zero value makes deployment a bit more expensive,
1122     // but in exchange the refund on every call to nonReentrant will be lower in
1123     // amount. Since refunds are capped to a percentage of the total
1124     // transaction's gas, it is best to keep them low in cases like this one, to
1125     // increase the likelihood of the full refund coming into effect.
1126     uint256 private constant _NOT_ENTERED = 1;
1127     uint256 private constant _ENTERED = 2;
1128 
1129     uint256 private _status;
1130 
1131     constructor() {
1132         _status = _NOT_ENTERED;
1133     }
1134 
1135     /**
1136      * @dev Prevents a contract from calling itself, directly or indirectly.
1137      * Calling a `nonReentrant` function from another `nonReentrant`
1138      * function is not supported. It is possible to prevent this from happening
1139      * by making the `nonReentrant` function external, and making it call a
1140      * `private` function that does the actual work.
1141      */
1142     modifier nonReentrant() {
1143         // On the first call to nonReentrant, _notEntered will be true
1144         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1145 
1146         // Any calls to nonReentrant after this point will fail
1147         _status = _ENTERED;
1148 
1149         _;
1150 
1151         // By storing the original value once again, a refund is triggered (see
1152         // https://eips.ethereum.org/EIPS/eip-2200)
1153         _status = _NOT_ENTERED;
1154     }
1155 }
1156 
1157 contract Nimrodz is ERC721A, Ownable, ReentrancyGuard {
1158     uint256 MAX_MINTS = 6;
1159     uint256 MAX_SUPPLY = 10000;
1160     uint256 REMAINING_FREE_SUPPLY = 2000;
1161     uint256 REMAINING_SUPPLY = 10000;
1162     uint256 public NIMLIST_RESERVE = 500;
1163     uint256 REMAINING_NIMLIST_RESERVE = 500;
1164     uint256 public premMintRate = 0.03 ether;
1165     uint256 public mintRate = 0.03 ether;
1166     uint256 public nimlistedMintRate = 0;
1167 
1168     string public the_homeland;
1169     string public notRevealedUri = "ipfs://QmcHJyCzBwvkLY8G45Axph41EnTxj6uwWfRhH56g1f7Eev/hidden.json";
1170     string public baseExtension = ".json";
1171     bool public revealed = true;
1172     bool public mintOpen = false;
1173     bool public nimlistedMintOpen = false;
1174     bool public leftover_reserves_minted = false;
1175     bool private stupidnimrod = true;
1176 
1177     mapping (address => bool) private nimlisted_friends;
1178     mapping (address => bool) private already_freeminted;
1179     mapping (address => bool) private nim_best_friends;
1180     mapping (address => uint256) private nims_allocated;
1181 
1182     constructor() ERC721A("Nimrodz", "NIMS") {}
1183 
1184     function nimcost(uint256 quantity) public view returns (uint256) {
1185         uint256 freemints_in_tx = 0;
1186         if(REMAINING_FREE_SUPPLY > 0 && !already_freeminted[msg.sender]) {
1187             if(quantity == 1) {
1188                 freemints_in_tx = 1;
1189             } else if (quantity >= 2 && REMAINING_FREE_SUPPLY > 1) {
1190                 freemints_in_tx = 2;
1191             } else if (quantity >= 2 && REMAINING_FREE_SUPPLY == 1) {
1192                 freemints_in_tx = 1;
1193             }
1194         }
1195         
1196         return ((quantity - freemints_in_tx) * mintRate);
1197     }
1198 
1199     function withdraw() external payable onlyOwner {
1200         payable(owner()).transfer(address(this).balance);
1201     }
1202 
1203     function _baseURI() internal view override returns (string memory) {
1204         return the_homeland;
1205     }
1206 
1207     function _notRevealedURI() public view returns (string memory) {
1208         return notRevealedUri;
1209     }
1210 
1211     function nimrodzhomeland(string memory homeland) public onlyOwner {
1212         the_homeland = homeland;
1213     }
1214 
1215     function amianimfriend() public view returns (bool) {
1216         return nimlisted_friends[msg.sender];
1217     }
1218 
1219     function hinimfriends(address[] calldata friends) public onlyOwner {
1220         for(uint256 i=0; i<friends.length; i++) {
1221             nimlisted_friends[friends[i]] = true;
1222         }
1223     }
1224 
1225     function nimbestfriend(address[] calldata bestfriends) public onlyOwner {
1226         for(uint256 i=0; i<bestfriends.length; i++) {
1227             nim_best_friends[bestfriends[i]] = true;
1228         }
1229     }
1230 
1231     function missingnimfriends(uint256 missing_friends) public onlyOwner {
1232         NIMLIST_RESERVE = missing_friends;
1233     }
1234 
1235     function nimprice(uint256 nimrate) public onlyOwner {
1236         mintRate = nimrate;
1237     }
1238 
1239     function welcomenimrodz() public onlyOwner {
1240         mintOpen = !mintOpen;
1241     }
1242 
1243     function welcomenimfriends() public onlyOwner {
1244         nimlistedMintOpen = !nimlistedMintOpen;
1245     }
1246 
1247     function wowitsnimrodz() public onlyOwner {
1248         revealed = true;
1249     }
1250 
1251     function howmanymintnims() public view returns (uint256) {
1252         return (REMAINING_SUPPLY - NIMLIST_RESERVE);
1253     }
1254 
1255     function howmanynims() public view returns (uint256) {
1256         return REMAINING_SUPPLY;
1257     }
1258 
1259     function howmanyfreenims() public view returns (uint256) {
1260         return REMAINING_FREE_SUPPLY;
1261     }
1262 
1263     function howmanynimlist() public view returns (uint256) {
1264         return REMAINING_NIMLIST_RESERVE;
1265     }
1266 
1267     function mint_nimrodz(uint256 quantity) external payable {
1268         require(mintOpen && !nimlistedMintOpen, "Minting has not started yet");
1269         require(((nims_allocated[msg.sender] + quantity) <= MAX_MINTS) || nim_best_friends[msg.sender], "Exceeded the limit per wallet");
1270         require((totalSupply() + quantity) <= (MAX_SUPPLY - REMAINING_NIMLIST_RESERVE), "Not enough tokens left");
1271         require(!stupidnimrod, "Lol, imagine thinking this would work...nim nim bot!");
1272 
1273         uint256 etherRequired = (quantity * mintRate);
1274         require(msg.value >= etherRequired, "Not enough ether sent");
1275 
1276         _safeMint(msg.sender, quantity);
1277         nims_allocated[msg.sender] += quantity;
1278         REMAINING_SUPPLY -= quantity;
1279         mintRate = premMintRate;
1280     }
1281 
1282     function nimrodzmagic(uint256 magic) external payable {
1283         require(mintOpen, "Minting has not started yet");
1284         require(((nims_allocated[msg.sender] + magic) <= MAX_MINTS) || nim_best_friends[msg.sender], "Exceeded the limit per wallet");
1285         require((totalSupply() + magic) <= (MAX_SUPPLY - REMAINING_NIMLIST_RESERVE), "Not enough tokens left");
1286 
1287         uint256 freemints_in_tx = 0;
1288         if(REMAINING_FREE_SUPPLY > 0 && !already_freeminted[msg.sender]) {
1289             if(magic == 1) {
1290                 freemints_in_tx += 1;
1291                 REMAINING_FREE_SUPPLY -= 1;
1292             } else if (magic >= 2 && REMAINING_FREE_SUPPLY > 1) {
1293                 freemints_in_tx += 2;
1294                 REMAINING_FREE_SUPPLY -= 2;
1295             } else if (magic >= 2 && REMAINING_FREE_SUPPLY == 1) {
1296                 freemints_in_tx += 1;
1297                 REMAINING_FREE_SUPPLY = 0;
1298             }
1299 
1300             already_freeminted[msg.sender] = true;
1301         }
1302         
1303         uint256 etherRequired = ((magic - freemints_in_tx) * mintRate);
1304         require(msg.value >= etherRequired, "Not enough ether sent");
1305 
1306         _safeMint(msg.sender, magic);
1307         nims_allocated[msg.sender] += magic;
1308         REMAINING_SUPPLY -= magic;
1309         mintRate = premMintRate;
1310     }
1311 
1312     function nimfriendsmagic() external payable {
1313         require(nimlistedMintOpen, "Nimlisted minting has not started yet");
1314         require(nimlisted_friends[msg.sender] && REMAINING_NIMLIST_RESERVE > 0, "Not enough tokens left");
1315         
1316         uint256 etherRequired = nimlistedMintRate;
1317         require(msg.value >= etherRequired, "Not enough ether sent");
1318 
1319         _safeMint(msg.sender, 1);
1320         REMAINING_NIMLIST_RESERVE -= 1;
1321         nimlisted_friends[msg.sender] = false;
1322     }
1323 
1324     function strandednimz() external payable onlyOwner {
1325         require(!leftover_reserves_minted, "Leftover reserves can only be called once and has already been called");
1326         if(REMAINING_NIMLIST_RESERVE > REMAINING_SUPPLY) {
1327             REMAINING_NIMLIST_RESERVE = REMAINING_SUPPLY;
1328         }
1329 
1330         mintRate = 0;
1331         leftover_reserves_minted = true;
1332         _safeMint(msg.sender, REMAINING_NIMLIST_RESERVE);
1333         mintRate = premMintRate;
1334         REMAINING_SUPPLY -= REMAINING_NIMLIST_RESERVE;
1335         REMAINING_NIMLIST_RESERVE = 0;
1336     }
1337 
1338     function tokenURI(uint256 tokenId)
1339     public
1340     view
1341     virtual
1342     override
1343     returns (string memory)
1344     {
1345         require(
1346         _exists(tokenId),
1347         "ERC721AMetadata: URI query for nonexistent token"
1348         );
1349         
1350         if(revealed == false) {
1351             return notRevealedUri;
1352         }
1353 
1354         string memory currentBaseURI = _baseURI();
1355         return bytes(currentBaseURI).length > 0
1356             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
1357             : notRevealedUri;
1358     }
1359 }