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
645     uint256 internal currentIndex = 56;
646 
647     // Token name
648     string private _name;
649 
650     // Token symbol
651     string private _symbol;
652 
653     bool public revealStatus;
654 
655     string public constant unrevealedURI = "QmdQR4fftQ7TLW6eoqpRD33q2i8kTSt6cHCCJQZitprQCJ";
656     string public revealedURI;
657 
658     // Mapping from token ID to ownership details
659     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
660     mapping(uint256 => TokenOwnership) internal _ownerships;
661 
662     // Mapping owner address to address data
663     mapping(address => AddressData) private _addressData;
664 
665     // Mapping from token ID to approved address
666     mapping(uint256 => address) private _tokenApprovals;
667 
668     // Mapping from owner to operator approvals
669     mapping(address => mapping(address => bool)) private _operatorApprovals;
670 
671     constructor(string memory name_, string memory symbol_) {
672         _name = name_;
673         _symbol = symbol_;
674     }
675 
676     /**
677      * @dev See {IERC721Enumerable-totalSupply}.
678      */
679     function totalSupply() public view override returns (uint256) {
680         return currentIndex - 1;
681     }
682 
683     /**
684      * @dev See {IERC721Enumerable-tokenByIndex}.
685      */
686     function tokenByIndex(uint256 index) public view override returns (uint256) {
687         require(index < totalSupply(), 'ERC721A: global index out of bounds');
688         return index;
689     }
690 
691     /**
692      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
693      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
694      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
695      */
696     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
697         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
698         uint256 numMintedSoFar = totalSupply();
699         uint256 tokenIdsIdx;
700         address currOwnershipAddr;
701 
702         // currentIndex overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
703         unchecked {
704             for (uint256 i; i < numMintedSoFar; i++) {
705                 TokenOwnership memory ownership = _ownerships[i];
706                 if (ownership.addr != address(0)) {
707                     currOwnershipAddr = ownership.addr;
708                 }
709                 if (currOwnershipAddr == owner) {
710                     if (tokenIdsIdx == index) {
711                         return i;
712                     }
713                     tokenIdsIdx++;
714                 }
715             }
716         }
717 
718         revert('ERC721A: unable to get token of owner by index');
719     }
720 
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
725         return
726             interfaceId == type(IERC721).interfaceId ||
727             interfaceId == type(IERC721Metadata).interfaceId ||
728             interfaceId == type(IERC721Enumerable).interfaceId ||
729             super.supportsInterface(interfaceId);
730     }
731 
732     /**
733      * @dev See {IERC721-balanceOf}.
734      */
735     function balanceOf(address owner) public view override returns (uint256) {
736         require(owner != address(0), 'ERC721A: balance query for the zero address');
737         return uint256(_addressData[owner].balance);
738     }
739 
740     function _numberMinted(address owner) internal view returns (uint256) {
741         require(owner != address(0), 'ERC721A: number minted query for the zero address');
742         return uint256(_addressData[owner].numberMinted);
743     }
744 
745     /**
746      * Gas spent here starts off proportional to the maximum mint batch size.
747      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
748      */
749     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
750         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
751 
752         unchecked {
753             for (uint256 curr = tokenId; curr >= 0; curr--) {
754                 TokenOwnership memory ownership = _ownerships[curr];
755                 if (ownership.addr != address(0)) {
756                     return ownership;
757                 }
758             }
759         }
760 
761         revert('ERC721A: unable to determine the owner of token');
762     }
763 
764     /**
765      * @dev See {IERC721-ownerOf}.
766      */
767     function ownerOf(uint256 tokenId) public view override returns (address) {
768         return ownershipOf(tokenId).addr;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-name}.
773      */
774     function name() public view virtual override returns (string memory) {
775         return _name;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-symbol}.
780      */
781     function symbol() public view virtual override returns (string memory) {
782         return _symbol;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-tokenURI}.
787      */
788     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
789         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
790         if(!revealStatus){
791             string memory baseURI = _baseURI();
792             return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", tokenId.toString(), ".json")) : '';
793         }else{
794             string memory baseURI = _baseURI();
795             return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", tokenId.toString(), ".json")) : '';
796         }
797 
798     }
799 
800     /**
801      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
802      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
803      * by default, can be overriden in child contracts.
804      */
805     function _baseURI() internal view returns (string memory) {
806         if (!revealStatus) {
807             return unrevealedURI;
808         } else {
809             return revealedURI;
810         }
811     }
812 
813     /**
814      * @dev See {IERC721-approve}.
815      */
816     function approve(address to, uint256 tokenId) public override {
817         address owner = ERC721A.ownerOf(tokenId);
818         require(to != owner, 'ERC721A: approval to current owner');
819 
820         require(
821             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
822             'ERC721A: approve caller is not owner nor approved for all'
823         );
824 
825         _approve(to, tokenId, owner);
826     }
827 
828     /**
829      * @dev See {IERC721-getApproved}.
830      */
831     function getApproved(uint256 tokenId) public view override returns (address) {
832         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
833 
834         return _tokenApprovals[tokenId];
835     }
836 
837     /**
838      * @dev See {IERC721-setApprovalForAll}.
839      */
840     function setApprovalForAll(address operator, bool approved) public override {
841         require(operator != _msgSender(), 'ERC721A: approve to caller');
842 
843         _operatorApprovals[_msgSender()][operator] = approved;
844         emit ApprovalForAll(_msgSender(), operator, approved);
845     }
846 
847     /**
848      * @dev See {IERC721-isApprovedForAll}.
849      */
850     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
851         return _operatorApprovals[owner][operator];
852     }
853 
854     /**
855      * @dev See {IERC721-transferFrom}.
856      */
857     function transferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public override {
862         _transfer(from, to, tokenId);
863     }
864 
865     /**
866      * @dev See {IERC721-safeTransferFrom}.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public override {
873         safeTransferFrom(from, to, tokenId, '');
874     }
875 
876     /**
877      * @dev See {IERC721-safeTransferFrom}.
878      */
879     function safeTransferFrom(
880         address from,
881         address to,
882         uint256 tokenId,
883         bytes memory _data
884     ) public override {
885         _transfer(from, to, tokenId);
886         require(
887             _checkOnERC721Received(from, to, tokenId, _data),
888             'ERC721A: transfer to non ERC721Receiver implementer'
889         );
890     }
891 
892     /**
893      * @dev Returns whether `tokenId` exists.
894      *
895      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
896      *
897      * Tokens start existing when they are minted (`_mint`),
898      */
899     function _exists(uint256 tokenId) internal view returns (bool) {
900         return tokenId < currentIndex && tokenId != 0 ;
901     }
902 
903     function _safeMint(address to, uint256 quantity) internal {
904         _safeMint(to, quantity, '');
905     }
906 
907     /**
908      * @dev Safely mints `quantity` tokens and transfers them to `to`.
909      *
910      * Requirements:
911      *
912      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
913      * - `quantity` must be greater than 0.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _safeMint(
918         address to,
919         uint256 quantity,
920         bytes memory _data
921     ) internal {
922         _mint(to, quantity, _data, true);
923     }
924 
925     /**
926      * @dev Mints `quantity` tokens and transfers them to `to`.
927      *
928      * Requirements:
929      *
930      * - `to` cannot be the zero address.
931      * - `quantity` must be greater than 0.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _mint(
936         address to,
937         uint256 quantity,
938         bytes memory _data,
939         bool safe
940     ) internal {
941         uint256 startTokenId = currentIndex;
942         require(to != address(0), 'ERC721A: mint to the zero address');
943         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
944 
945         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
946 
947         // Overflows are incredibly unrealistic.
948         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
949         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
950         unchecked {
951             _addressData[to].balance += uint128(quantity);
952             _addressData[to].numberMinted += uint128(quantity);
953 
954             _ownerships[startTokenId].addr = to;
955             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
956 
957             uint256 updatedIndex = startTokenId;
958 
959             for (uint256 i; i < quantity; i++) {
960                 emit Transfer(address(0), to, updatedIndex);
961                 if (safe) {
962                     require(
963                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
964                         'ERC721A: transfer to non ERC721Receiver implementer'
965                     );
966                 }
967 
968                 updatedIndex++;
969             }
970 
971             currentIndex = updatedIndex;
972         }
973 
974         _afterTokenTransfers(address(0), to, startTokenId, quantity);
975     }
976 
977     /**
978      * @dev Transfers `tokenId` from `from` to `to`.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must be owned by `from`.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _transfer(
988         address from,
989         address to,
990         uint256 tokenId
991     ) private {
992         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
993 
994         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
995             getApproved(tokenId) == _msgSender() ||
996             isApprovedForAll(prevOwnership.addr, _msgSender()));
997 
998         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
999 
1000         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1001         require(to != address(0), 'ERC721A: transfer to the zero address');
1002 
1003         _beforeTokenTransfers(from, to, tokenId, 1);
1004 
1005         // Clear approvals from the previous owner
1006         _approve(address(0), tokenId, prevOwnership.addr);
1007 
1008         // Underflow of the sender's balance is impossible because we check for
1009         // ownership above and the recipient's balance can't realistically overflow.
1010         // currentIndex overflow is incredibly unrealistic as tokenId would have to be 2**256.
1011         unchecked {
1012             _addressData[from].balance -= 1;
1013             _addressData[to].balance += 1;
1014 
1015             _ownerships[tokenId].addr = to;
1016             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1017 
1018             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1019             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1020             uint256 nextTokenId = tokenId + 1;
1021             if (_ownerships[nextTokenId].addr == address(0)) {
1022                 if (_exists(nextTokenId)) {
1023                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1024                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1025                 }
1026             }
1027         }
1028 
1029         emit Transfer(from, to, tokenId);
1030         _afterTokenTransfers(from, to, tokenId, 1);
1031     }
1032 
1033     /**
1034      * @dev Approve `to` to operate on `tokenId`
1035      *
1036      * Emits a {Approval} event.
1037      */
1038     function _approve(
1039         address to,
1040         uint256 tokenId,
1041         address owner
1042     ) private {
1043         _tokenApprovals[tokenId] = to;
1044         emit Approval(owner, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1049      * The call is not executed if the target address is not a contract.
1050      *
1051      * @param from address representing the previous owner of the given token ID
1052      * @param to target address that will receive the tokens
1053      * @param tokenId uint256 ID of the token to be transferred
1054      * @param _data bytes optional data to send along with the call
1055      * @return bool whether the call correctly returned the expected magic value
1056      */
1057     function _checkOnERC721Received(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) private returns (bool) {
1063         if (to.isContract()) {
1064             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1065                 return retval == IERC721Receiver(to).onERC721Received.selector;
1066             } catch (bytes memory reason) {
1067                 if (reason.length == 0) {
1068                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1069                 } else {
1070                     assembly {
1071                         revert(add(32, reason), mload(reason))
1072                     }
1073                 }
1074             }
1075         } else {
1076             return true;
1077         }
1078     }
1079 
1080     /**
1081      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1082      *
1083      * startTokenId - the first token id to be transferred
1084      * quantity - the amount to be transferred
1085      *
1086      * Calling conditions:
1087      *
1088      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1089      * transferred to `to`.
1090      * - When `from` is zero, `tokenId` will be minted for `to`.
1091      */
1092     function _beforeTokenTransfers(
1093         address from,
1094         address to,
1095         uint256 startTokenId,
1096         uint256 quantity
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1101      * minting.
1102      *
1103      * startTokenId - the first token id to be transferred
1104      * quantity - the amount to be transferred
1105      *
1106      * Calling conditions:
1107      *
1108      * - when `from` and `to` are both non-zero.
1109      * - `from` and `to` are never both zero.
1110      */
1111     function _afterTokenTransfers(
1112         address from,
1113         address to,
1114         uint256 startTokenId,
1115         uint256 quantity
1116     ) internal virtual {}
1117 }
1118 
1119 contract Doodbeast is ERC721A, Ownable {
1120 
1121     uint public ownerCounter = 1;
1122     uint public ownerAssignments;
1123     uint public maxSupply = 5555;
1124     uint public price = 0.015 ether;
1125 
1126     mapping(address => uint) public _airdrops;
1127     mapping(address => uint) public _freeTokensMinted;
1128 
1129     event Reveal (string unrevealedURI, string revealedURI);
1130 
1131     constructor() ERC721A("Doodbeast", "BEAST") {}
1132 
1133     function reveal(string memory _revealedURI) external onlyOwner {
1134         require(!revealStatus, "Collection already revealed!");
1135         revealedURI = _revealedURI;
1136         revealStatus = !revealStatus;
1137         emit Reveal(unrevealedURI, revealedURI);
1138     }
1139 
1140     function setPrice(uint _price) external onlyOwner {
1141         price = _price;
1142     }
1143 
1144     function claimAirdrop() external {
1145         require(_airdrops[msg.sender] > 0, "No tokens to claim!");
1146         uint amount = _airdrops[msg.sender];
1147         uint pastIndex = currentIndex;
1148         currentIndex = ownerCounter;
1149         _safeMint(msg.sender, amount);
1150         currentIndex = pastIndex;
1151         ownerCounter += amount;
1152         _airdrops[msg.sender] = 0;
1153     }
1154 
1155     function ownerAssignment(address wallet, uint amount) external onlyOwner {
1156         require(ownerAssignments + amount <= 55, "Not enough tokens to assign");
1157         _airdrops[wallet] += amount;
1158         ownerAssignments += amount;
1159     }
1160 
1161     function freeMint(uint amount) external {
1162         require(currentIndex + amount <= 556, "Not enough free tokens available!");
1163         require(amount <= 4, "Not allowed!");
1164         require(_freeTokensMinted[msg.sender] < 4, "Max free tokens already minted!");
1165         _safeMint(msg.sender, amount);
1166         _freeTokensMinted[msg.sender] += amount;
1167     }
1168 
1169     function saleMint(uint amount) external payable {
1170         require(amount <= 15, "Incorrect amount!");
1171         require(currentIndex > 555, "Free round not finished!");
1172         require(msg.value == amount * price, "Incorrect value!");
1173         require(currentIndex + amount <= maxSupply + 1, "Not enough tokens!");
1174         _safeMint(msg.sender, amount);
1175     }
1176 
1177     function withdraw() external onlyOwner {
1178         payable(msg.sender).transfer(address(this).balance);
1179     }
1180 }