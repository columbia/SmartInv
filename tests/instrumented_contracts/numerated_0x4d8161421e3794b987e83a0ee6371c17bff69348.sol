1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.14;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 
67 // Context.sol
68 /**
69  * @dev Provides information about the current execution context, including the
70  * sender of the transaction and its data. While these are generally available
71  * via msg.sender and msg.data, they should not be accessed in such a direct
72  * manner, since when dealing with meta-transactions the account sending and
73  * paying for execution may not be the actual sender (as far as an application
74  * is concerned).
75  *
76  * This contract is only required for intermediate, library-like contracts.
77  */
78 abstract contract Context {
79     function _msgSender() internal view virtual returns (address) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view virtual returns (bytes calldata) {
84         return msg.data;
85     }
86 }
87 
88 
89 // Ownable.sol
90 /**
91  * @dev Contract module which provides a basic access control mechanism, where
92  * there is an account (an owner) that can be granted exclusive access to
93  * specific functions.
94  *
95  * By default, the owner account will be the one that deploys the contract. This
96  * can later be changed with {transferOwnership}.
97  *
98  * This module is used through inheritance. It will make available the modifier
99  * `onlyOwner`, which can be applied to your functions to restrict their use to
100  * the owner.
101  */
102 abstract contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     /**
108      * @dev Initializes the contract setting the deployer as the initial owner.
109      */
110     constructor() {
111         _setOwner(_msgSender());
112     }
113 
114     /**
115      * @dev Returns the address of the current owner.
116      */
117     function owner() public view virtual returns (address) {
118         return _owner;
119     }
120 
121     /**
122      * @dev Throws if called by any account other than the owner.
123      */
124     modifier onlyOwner() {
125         require(owner() == _msgSender(), "Ownable: caller is not the owner");
126         _;
127     }
128 
129     /**
130      * @dev Leaves the contract without owner. It will not be possible to call
131      * `onlyOwner` functions anymore. Can only be called by the current owner.
132      *
133      * NOTE: Renouncing ownership will leave the contract without an owner,
134      * thereby removing any functionality that is only available to the owner.
135      */
136     function renounceOwnership() public virtual onlyOwner {
137         _setOwner(address(0));
138     }
139 
140     /**
141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
142      * Can only be called by the current owner.
143      */
144     function transferOwnership(address newOwner) public virtual onlyOwner {
145         require(newOwner != address(0), "Ownable: new owner is the zero address");
146         _setOwner(newOwner);
147     }
148 
149     function _setOwner(address newOwner) private {
150         address oldOwner = _owner;
151         _owner = newOwner;
152         emit OwnershipTransferred(oldOwner, newOwner);
153     }
154 }
155 
156 // Address.sol
157 /**
158  * @dev Collection of functions related to the address type
159  */
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      */
178     function isContract(address account) internal view returns (bool) {
179         // This method relies on extcodesize, which returns 0 for contracts in
180         // construction, since the code is only stored at the end of the
181         // constructor execution.
182 
183         uint256 size;
184         assembly {
185             size := extcodesize(account)
186         }
187         return size > 0;
188     }
189 
190     /**
191      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
192      * `recipient`, forwarding all available gas and reverting on errors.
193      *
194      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
195      * of certain opcodes, possibly making contracts go over the 2300 gas limit
196      * imposed by `transfer`, making them unable to receive funds via
197      * `transfer`. {sendValue} removes this limitation.
198      *
199      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
200      *
201      * IMPORTANT: because control is transferred to `recipient`, care must be
202      * taken to not create reentrancy vulnerabilities. Consider using
203      * {ReentrancyGuard} or the
204      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
205      */
206     function sendValue(address payable recipient, uint256 amount) internal {
207         require(address(this).balance >= amount, "Address: insufficient balance");
208 
209         (bool success, ) = recipient.call{value: amount}("");
210         require(success, "Address: unable to send value, recipient may have reverted");
211     }
212 
213     /**
214      * @dev Performs a Solidity function call using a low level `call`. A
215      * plain `call` is an unsafe replacement for a function call: use this
216      * function instead.
217      *
218      * If `target` reverts with a revert reason, it is bubbled up by this
219      * function (like regular Solidity function calls).
220      *
221      * Returns the raw returned data. To convert to the expected return value,
222      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
223      *
224      * Requirements:
225      *
226      * - `target` must be a contract.
227      * - calling `target` with `data` must not revert.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionCall(target, data, "Address: low-level call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
237      * `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
270      * with `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Address: insufficient balance for call");
281         require(isContract(target), "Address: call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.call{value: value}(data);
284         return _verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a static call.
290      *
291      * _Available since v3.3._
292      */
293     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
294         return functionStaticCall(target, data, "Address: low-level static call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a static call.
300      *
301      * _Available since v3.3._
302      */
303     function functionStaticCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal view returns (bytes memory) {
308         require(isContract(target), "Address: static call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.staticcall(data);
311         return _verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a delegate call.
327      *
328      * _Available since v3.4._
329      */
330     function functionDelegateCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(isContract(target), "Address: delegate call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.delegatecall(data);
338         return _verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     function _verifyCallResult(
342         bool success,
343         bytes memory returndata,
344         string memory errorMessage
345     ) private pure returns (bytes memory) {
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 // IERC721Receiver.sol
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
388 // IERC165.sol
389 /**
390  * @dev Interface of the ERC165 standard, as defined in the
391  * https://eips.ethereum.org/EIPS/eip-165[EIP].
392  *
393  * Implementers can declare support of contract interfaces, which can then be
394  * queried by others ({ERC165Checker}).
395  *
396  * For an implementation, see {ERC165}.
397  */
398 interface IERC165 {
399     /**
400      * @dev Returns true if this contract implements the interface defined by
401      * `interfaceId`. See the corresponding
402      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
403      * to learn more about how these ids are created.
404      *
405      * This function call must use less than 30 000 gas.
406      */
407     function supportsInterface(bytes4 interfaceId) external view returns (bool);
408 }
409 
410 // ERC165.sol
411 /**
412  * @dev Implementation of the {IERC165} interface.
413  *
414  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
415  * for the additional interface id that will be supported. For example:
416  *
417  * ```solidity
418  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
420  * }
421  * ```
422  *
423  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
424  */
425 abstract contract ERC165 is IERC165 {
426     /**
427      * @dev See {IERC165-supportsInterface}.
428      */
429     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430         return interfaceId == type(IERC165).interfaceId;
431     }
432 }
433 
434 // IERC721.sol
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
572 // IERC721Enumerable.sol
573 /**
574  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
575  * @dev See https://eips.ethereum.org/EIPS/eip-721
576  */
577 interface IERC721Enumerable is IERC721 {
578     /**
579      * @dev Returns the total amount of tokens stored by the contract.
580      */
581     function totalSupply() external view returns (uint256);
582 
583     /**
584      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
585      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
586      */
587     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
588 
589     /**
590      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
591      * Use along with {totalSupply} to enumerate all tokens.
592      */
593     function tokenByIndex(uint256 index) external view returns (uint256);
594 }
595 
596 // IERC721Metadata.sol
597 /**
598  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
599  * @dev See https://eips.ethereum.org/EIPS/eip-721
600  */
601 interface IERC721Metadata is IERC721 {
602     /**
603      * @dev Returns the token collection name.
604      */
605     function name() external view returns (string memory);
606 
607     /**
608      * @dev Returns the token collection symbol.
609      */
610     function symbol() external view returns (string memory);
611 
612     /**
613      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
614      */
615     function tokenURI(uint256 tokenId) external view returns (string memory);
616 }
617 
618 // ERC721A.sol
619 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
620     using Address for address;
621     using Strings for uint256;
622 
623     struct TokenOwnership {
624         address addr;
625         uint64 startTimestamp;
626     }
627 
628     struct AddressData {
629         uint128 balance;
630         uint128 numberMinted;
631     }
632 
633     uint256 internal currentIndex = 1;
634 
635     // Token name
636     string private _name;
637 
638     // Token symbol
639     string private _symbol;
640 
641     // Mapping from token ID to ownership details
642     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
643     mapping(uint256 => TokenOwnership) internal _ownerships;
644 
645     // Mapping owner address to address data
646     mapping(address => AddressData) private _addressData;
647 
648     // Mapping from token ID to approved address
649     mapping(uint256 => address) private _tokenApprovals;
650 
651     // Mapping from owner to operator approvals
652     mapping(address => mapping(address => bool)) private _operatorApprovals;
653 
654     constructor(string memory name_, string memory symbol_) {
655         _name = name_;
656         _symbol = symbol_;
657     }
658 
659     /**
660      * @dev See {IERC721Enumerable-totalSupply}.
661      */
662     function totalSupply() public view override returns (uint256) {
663         return currentIndex-1;
664     }
665 
666     /**
667      * @dev See {IERC721Enumerable-tokenByIndex}.
668      */
669     function tokenByIndex(uint256 index) public view override returns (uint256) {
670         require(index < totalSupply(), 'ERC721A: global index out of bounds');
671         return index;
672     }
673 
674     /**
675      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
676      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
677      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
678      */
679     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
680         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
681         uint256 numMintedSoFar = totalSupply();
682         uint256 tokenIdsIdx;
683         address currOwnershipAddr;
684 
685         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
686         unchecked {
687             for (uint256 i; i < numMintedSoFar; i++) {
688                 TokenOwnership memory ownership = _ownerships[i];
689                 if (ownership.addr != address(0)) {
690                     currOwnershipAddr = ownership.addr;
691                 }
692                 if (currOwnershipAddr == owner) {
693                     if (tokenIdsIdx == index) {
694                         return i;
695                     }
696                     tokenIdsIdx++;
697                 }
698             }
699         }
700 
701         revert('ERC721A: unable to get token of owner by index');
702     }
703 
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
708         return
709             interfaceId == type(IERC721).interfaceId ||
710             interfaceId == type(IERC721Metadata).interfaceId ||
711             interfaceId == type(IERC721Enumerable).interfaceId ||
712             super.supportsInterface(interfaceId);
713     }
714 
715     /**
716      * @dev See {IERC721-balanceOf}.
717      */
718     function balanceOf(address owner) public view override returns (uint256) {
719         require(owner != address(0), 'ERC721A: balance query for the zero address');
720         return uint256(_addressData[owner].balance);
721     }
722 
723     function _numberMinted(address owner) internal view returns (uint256) {
724         require(owner != address(0), 'ERC721A: number minted query for the zero address');
725         return uint256(_addressData[owner].numberMinted);
726     }
727 
728     /**
729      * Gas spent here starts off proportional to the maximum mint batch size.
730      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
731      */
732     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
733         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
734 
735         unchecked {
736             for (uint256 curr = tokenId; curr >= 0; curr--) {
737                 TokenOwnership memory ownership = _ownerships[curr];
738                 if (ownership.addr != address(0)) {
739                     return ownership;
740                 }
741             }
742         }
743 
744         revert('ERC721A: unable to determine the owner of token');
745     }
746 
747     /**
748      * @dev See {IERC721-ownerOf}.
749      */
750     function ownerOf(uint256 tokenId) public view override returns (address) {
751         return ownershipOf(tokenId).addr;
752     }
753 
754     /**
755      * @dev See {IERC721Metadata-name}.
756      */
757     function name() public view virtual override returns (string memory) {
758         return _name;
759     }
760 
761     /**
762      * @dev See {IERC721Metadata-symbol}.
763      */
764     function symbol() public view virtual override returns (string memory) {
765         return _symbol;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-tokenURI}.
770      */
771     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
772         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
773 
774         string memory baseURI = _baseURI();
775         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
776     }
777 
778     /**
779      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
780      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
781      * by default, can be overriden in child contracts.
782      */
783     function _baseURI() internal view virtual returns (string memory) {
784         return '';
785     }
786 
787     /**
788      * @dev See {IERC721-approve}.
789      */
790     function approve(address to, uint256 tokenId) public override {
791         address owner = ERC721A.ownerOf(tokenId);
792         require(to != owner, 'ERC721A: approval to current owner');
793 
794         require(
795             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
796             'ERC721A: approve caller is not owner nor approved for all'
797         );
798 
799         _approve(to, tokenId, owner);
800     }
801 
802     /**
803      * @dev See {IERC721-getApproved}.
804      */
805     function getApproved(uint256 tokenId) public view override returns (address) {
806         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
807 
808         return _tokenApprovals[tokenId];
809     }
810 
811     /**
812      * @dev See {IERC721-setApprovalForAll}.
813      */
814     function setApprovalForAll(address operator, bool approved) public override {
815         require(operator != _msgSender(), 'ERC721A: approve to caller');
816 
817         _operatorApprovals[_msgSender()][operator] = approved;
818         emit ApprovalForAll(_msgSender(), operator, approved);
819     }
820 
821     /**
822      * @dev See {IERC721-isApprovedForAll}.
823      */
824     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
825         return _operatorApprovals[owner][operator];
826     }
827 
828     /**
829      * @dev See {IERC721-transferFrom}.
830      */
831     function transferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public override {
836         _transfer(from, to, tokenId);
837     }
838 
839     /**
840      * @dev See {IERC721-safeTransferFrom}.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public override {
847         safeTransferFrom(from, to, tokenId, '');
848     }
849 
850     /**
851      * @dev See {IERC721-safeTransferFrom}.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) public override {
859         _transfer(from, to, tokenId);
860         require(
861             _checkOnERC721Received(from, to, tokenId, _data),
862             'ERC721A: transfer to non ERC721Receiver implementer'
863         );
864     }
865 
866     /**
867      * @dev Returns whether `tokenId` exists.
868      *
869      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
870      *
871      * Tokens start existing when they are minted (`_mint`),
872      */
873     function _exists(uint256 tokenId) internal view returns (bool) {
874         return tokenId < currentIndex;
875     }
876 
877     function _safeMint(address to, uint256 quantity) internal {
878         _safeMint(to, quantity, '');
879     }
880 
881     /**
882      * @dev Safely mints `quantity` tokens and transfers them to `to`.
883      *
884      * Requirements:
885      *
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
887      * - `quantity` must be greater than 0.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _safeMint(
892         address to,
893         uint256 quantity,
894         bytes memory _data
895     ) internal {
896         _mint(to, quantity, _data, true);
897     }
898 
899     /**
900      * @dev Mints `quantity` tokens and transfers them to `to`.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `quantity` must be greater than 0.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _mint(
910         address to,
911         uint256 quantity,
912         bytes memory _data,
913         bool safe
914     ) internal {
915         uint256 startTokenId = currentIndex;
916         require(to != address(0), 'ERC721A: mint to the zero address');
917         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
918 
919         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
920 
921         // Overflows are incredibly unrealistic.
922         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
923         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
924         unchecked {
925             _addressData[to].balance += uint128(quantity);
926             _addressData[to].numberMinted += uint128(quantity);
927 
928             _ownerships[startTokenId].addr = to;
929             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
930 
931             uint256 updatedIndex = startTokenId;
932 
933             for (uint256 i; i < quantity; i++) {
934                 emit Transfer(address(0), to, updatedIndex);
935                 if (safe) {
936                     require(
937                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
938                         'ERC721A: transfer to non ERC721Receiver implementer'
939                     );
940                 }
941 
942                 updatedIndex++;
943             }
944 
945             currentIndex = updatedIndex;
946         }
947 
948         _afterTokenTransfers(address(0), to, startTokenId, quantity);
949     }
950 
951     /**
952      * @dev Transfers `tokenId` from `from` to `to`.
953      *
954      * Requirements:
955      *
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must be owned by `from`.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _transfer(
962         address from,
963         address to,
964         uint256 tokenId
965     ) private {
966         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
967 
968         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
969             getApproved(tokenId) == _msgSender() ||
970             isApprovedForAll(prevOwnership.addr, _msgSender()));
971 
972         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
973 
974         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
975         require(to != address(0), 'ERC721A: transfer to the zero address');
976 
977         _beforeTokenTransfers(from, to, tokenId, 1);
978 
979         // Clear approvals from the previous owner
980         _approve(address(0), tokenId, prevOwnership.addr);
981 
982         // Underflow of the sender's balance is impossible because we check for
983         // ownership above and the recipient's balance can't realistically overflow.
984         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
985         unchecked {
986             _addressData[from].balance -= 1;
987             _addressData[to].balance += 1;
988 
989             _ownerships[tokenId].addr = to;
990             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
991 
992             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
993             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
994             uint256 nextTokenId = tokenId + 1;
995             if (_ownerships[nextTokenId].addr == address(0)) {
996                 if (_exists(nextTokenId)) {
997                     _ownerships[nextTokenId].addr = prevOwnership.addr;
998                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
999                 }
1000             }
1001         }
1002 
1003         emit Transfer(from, to, tokenId);
1004         _afterTokenTransfers(from, to, tokenId, 1);
1005     }
1006 
1007     /**
1008      * @dev Approve `to` to operate on `tokenId`
1009      *
1010      * Emits a {Approval} event.
1011      */
1012     function _approve(
1013         address to,
1014         uint256 tokenId,
1015         address owner
1016     ) private {
1017         _tokenApprovals[tokenId] = to;
1018         emit Approval(owner, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1023      * The call is not executed if the target address is not a contract.
1024      *
1025      * @param from address representing the previous owner of the given token ID
1026      * @param to target address that will receive the tokens
1027      * @param tokenId uint256 ID of the token to be transferred
1028      * @param _data bytes optional data to send along with the call
1029      * @return bool whether the call correctly returned the expected magic value
1030      */
1031     function _checkOnERC721Received(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) private returns (bool) {
1037         if (to.isContract()) {
1038             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1039                 return retval == IERC721Receiver(to).onERC721Received.selector;
1040             } catch (bytes memory reason) {
1041                 if (reason.length == 0) {
1042                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1043                 } else {
1044                     assembly {
1045                         revert(add(32, reason), mload(reason))
1046                     }
1047                 }
1048             }
1049         } else {
1050             return true;
1051         }
1052     }
1053 
1054     /**
1055      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1056      *
1057      * startTokenId - the first token id to be transferred
1058      * quantity - the amount to be transferred
1059      *
1060      * Calling conditions:
1061      *
1062      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1063      * transferred to `to`.
1064      * - When `from` is zero, `tokenId` will be minted for `to`.
1065      */
1066     function _beforeTokenTransfers(
1067         address from,
1068         address to,
1069         uint256 startTokenId,
1070         uint256 quantity
1071     ) internal virtual {}
1072 
1073     /**
1074      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1075      * minting.
1076      *
1077      * startTokenId - the first token id to be transferred
1078      * quantity - the amount to be transferred
1079      *
1080      * Calling conditions:
1081      *
1082      * - when `from` and `to` are both non-zero.
1083      * - `from` and `to` are never both zero.
1084      */
1085     function _afterTokenTransfers(
1086         address from,
1087         address to,
1088         uint256 startTokenId,
1089         uint256 quantity
1090     ) internal virtual {}
1091 }
1092 
1093 contract LyingNFT is ERC721A, Ownable {
1094     
1095     uint256 MAX_SUPPLY = 5555;
1096     uint256 Allremain = 5555;
1097     uint256 public mintRate = 0.005 ether;
1098     uint256 MintForWallet = 5555;
1099     string public base_URI = "";
1100     string public baseExtension = ".json";
1101     string public prerevealURL = "ipfs://Qme7XF3CeWQ1PWKrKTpuNxH6pQiL1FhgcEPzSxene5WmxL?filename=hidden.json" ;
1102     bool public start = true;
1103 
1104     mapping (address => uint256) private MintedBalance;
1105 
1106     constructor() ERC721A("Lying NFT", "Lying") {}
1107 
1108 
1109 
1110     function reveal(string memory url) external onlyOwner {
1111 		base_URI = url;
1112 	}
1113 
1114     function withdraw() external payable onlyOwner {
1115         payable(owner()).transfer(address(this).balance);
1116     }
1117 
1118     function _baseURI() internal view override returns (string memory) {
1119         return base_URI;
1120     }
1121 
1122 
1123     function pauseStartSwitch() public onlyOwner {
1124         start = !start;
1125     }
1126 
1127     function RemainingItem() public view returns (uint256) {
1128         return Allremain;
1129     }
1130 
1131 
1132 
1133     function mint(uint256 quantity) public payable {
1134         require(start, "Sorry, Minting is paused.");
1135         require(quantity<=10 , "Sorry, there are only 10 items allowed for each minting.");
1136         require((totalSupply() + quantity) <= MAX_SUPPLY, "Sorry, There is no more items.");
1137         
1138         uint payforNum = quantity;
1139 
1140         if(MintedBalance[msg.sender] == 0){
1141             payforNum = payforNum - 1;
1142         }
1143 
1144         require(msg.value >= payforNum * mintRate, "Ether is not enough.");
1145 
1146 
1147         _safeMint(msg.sender, quantity);
1148         MintedBalance[msg.sender] = MintedBalance[msg.sender] + quantity;
1149         Allremain -= quantity;
1150     }
1151 
1152     function setRate(uint256 newRate) external onlyOwner {
1153         mintRate = newRate;
1154     }
1155     
1156     function walletOfOwner(address _owner)
1157         public
1158         view
1159         returns (uint256[] memory)
1160     {
1161         uint256 ownerTokenCount = balanceOf(_owner);
1162         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1163         for (uint256 i; i < ownerTokenCount; i++) {
1164         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1165         }
1166         return tokenIds;
1167     }
1168 
1169     function tokenURI(uint256 tokenId)
1170     public
1171     view
1172     virtual
1173     override
1174     returns (string memory)
1175     {
1176         require(
1177         _exists(tokenId),
1178         "ERC721AMetadata: URI query for nonexistent token"
1179         );
1180         
1181 
1182         string memory currentBaseURI = _baseURI();
1183         return bytes(currentBaseURI).length > 0
1184             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
1185             : prerevealURL;
1186     }
1187 
1188 }