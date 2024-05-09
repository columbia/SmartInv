1 // File: BunnyKnights.sol
2 
3 /**
4             ,----------------,              ,---------,
5         ,-----------------------,          ,"        ,"|
6       ,"                      ,"|        ,"        ,"  |
7      +-----------------------+  |      ,"        ,"    |
8      |  .-----------------.  |  |     +---------+      |
9      |  |                 |  |  |     | -==----'|      |
10      |  |  I LOVE NFT!    |  |  |     |         |      |
11      |  |  BUT HATE FREE  |  |  |/----|`---=    |      |
12      |  |  C:\>_          |  |  |   ,/|=== 2ooo |      ;
13      |  |                 |  |  |  // |(((( [33]|    ,"
14      |  `-----------------'  |," .;'| |((((     |  ,"
15      +-----------------------+  ;;  | |         |,"
16         /_)______________(_/  //'   | +---------+
17    ___________________________/___  `,
18   /  oBunnyoKnightso  .o.  oooo /,   \,"-----------
19  / ==oRoboForooFunoo==.o.  ooo= //   ,`\--{)B     ,"
20 /_==__==========__==_ooo__ooo=_/'   /___________,"
21 */
22 
23 pragma solidity ^0.8.14;
24 
25 /**
26  * @dev String operations.
27  */
28 library Strings {
29     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
33      */
34     function toString(uint256 value) internal pure returns (string memory) {
35         // Inspired by OraclizeAPI's implementation - MIT licence
36         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
58      */
59     function toHexString(uint256 value) internal pure returns (string memory) {
60         if (value == 0) {
61             return "0x00";
62         }
63         uint256 temp = value;
64         uint256 length = 0;
65         while (temp != 0) {
66             length++;
67             temp >>= 8;
68         }
69         return toHexString(value, length);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
74      */
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 }
87 
88 // Context.sol
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 
110 // Ownable.sol
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _setOwner(_msgSender());
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view virtual returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public virtual onlyOwner {
158         _setOwner(address(0));
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Can only be called by the current owner.
164      */
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         _setOwner(newOwner);
168     }
169 
170     function _setOwner(address newOwner) private {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // Address.sol
178 /**
179  * @dev Collection of functions related to the address type
180  */
181 library Address {
182     /**
183      * @dev Returns true if `account` is a contract.
184      *
185      * [IMPORTANT]
186      * ====
187      * It is unsafe to assume that an address for which this function returns
188      * false is an externally-owned account (EOA) and not a contract.
189      *
190      * Among others, `isContract` will return false for the following
191      * types of addresses:
192      *
193      *  - an externally-owned account
194      *  - a contract in construction
195      *  - an address where a contract will be created
196      *  - an address where a contract lived, but was destroyed
197      * ====
198      */
199     function isContract(address account) internal view returns (bool) {
200         // This method relies on extcodesize, which returns 0 for contracts in
201         // construction, since the code is only stored at the end of the
202         // constructor execution.
203 
204         uint256 size;
205         assembly {
206             size := extcodesize(account)
207         }
208         return size > 0;
209     }
210 
211     /**
212      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
213      * `recipient`, forwarding all available gas and reverting on errors.
214      *
215      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
216      * of certain opcodes, possibly making contracts go over the 2300 gas limit
217      * imposed by `transfer`, making them unable to receive funds via
218      * `transfer`. {sendValue} removes this limitation.
219      *
220      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
221      *
222      * IMPORTANT: because control is transferred to `recipient`, care must be
223      * taken to not create reentrancy vulnerabilities. Consider using
224      * {ReentrancyGuard} or the
225      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
226      */
227     function sendValue(address payable recipient, uint256 amount) internal {
228         require(address(this).balance >= amount, "Address: insufficient balance");
229 
230         (bool success, ) = recipient.call{value: amount}("");
231         require(success, "Address: unable to send value, recipient may have reverted");
232     }
233 
234     /**
235      * @dev Performs a Solidity function call using a low level `call`. A
236      * plain `call` is an unsafe replacement for a function call: use this
237      * function instead.
238      *
239      * If `target` reverts with a revert reason, it is bubbled up by this
240      * function (like regular Solidity function calls).
241      *
242      * Returns the raw returned data. To convert to the expected return value,
243      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
244      *
245      * Requirements:
246      *
247      * - `target` must be a contract.
248      * - calling `target` with `data` must not revert.
249      *
250      * _Available since v3.1._
251      */
252     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionCall(target, data, "Address: low-level call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
258      * `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, 0, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but also transferring `value` wei to `target`.
273      *
274      * Requirements:
275      *
276      * - the calling contract must have an ETH balance of at least `value`.
277      * - the called Solidity function must be `payable`.
278      *
279      * _Available since v3.1._
280      */
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
291      * with `errorMessage` as a fallback revert reason when `target` reverts.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(address(this).balance >= value, "Address: insufficient balance for call");
302         require(isContract(target), "Address: call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.call{value: value}(data);
305         return _verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a static call.
311      *
312      * _Available since v3.3._
313      */
314     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
315         return functionStaticCall(target, data, "Address: low-level static call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal view returns (bytes memory) {
329         require(isContract(target), "Address: static call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.staticcall(data);
332         return _verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a delegate call.
338      *
339      * _Available since v3.4._
340      */
341     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(isContract(target), "Address: delegate call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.delegatecall(data);
359         return _verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     function _verifyCallResult(
363         bool success,
364         bytes memory returndata,
365         string memory errorMessage
366     ) private pure returns (bytes memory) {
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 // IERC721Receiver.sol
386 /**
387  * @title ERC721 token receiver interface
388  * @dev Interface for any contract that wants to support safeTransfers
389  * from ERC721 asset contracts.
390  */
391 interface IERC721Receiver {
392     /**
393      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
394      * by `operator` from `from`, this function is called.
395      *
396      * It must return its Solidity selector to confirm the token transfer.
397      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
398      *
399      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
400      */
401     function onERC721Received(
402         address operator,
403         address from,
404         uint256 tokenId,
405         bytes calldata data
406     ) external returns (bytes4);
407 }
408 
409 // IERC165.sol
410 /**
411  * @dev Interface of the ERC165 standard, as defined in the
412  * https://eips.ethereum.org/EIPS/eip-165[EIP].
413  *
414  * Implementers can declare support of contract interfaces, which can then be
415  * queried by others ({ERC165Checker}).
416  *
417  * For an implementation, see {ERC165}.
418  */
419 interface IERC165 {
420     /**
421      * @dev Returns true if this contract implements the interface defined by
422      * `interfaceId`. See the corresponding
423      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
424      * to learn more about how these ids are created.
425      *
426      * This function call must use less than 30 000 gas.
427      */
428     function supportsInterface(bytes4 interfaceId) external view returns (bool);
429 }
430 
431 // ERC165.sol
432 /**
433  * @dev Implementation of the {IERC165} interface.
434  *
435  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
436  * for the additional interface id that will be supported. For example:
437  *
438  * ```solidity
439  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
440  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
441  * }
442  * ```
443  *
444  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
445  */
446 abstract contract ERC165 is IERC165 {
447     /**
448      * @dev See {IERC165-supportsInterface}.
449      */
450     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
451         return interfaceId == type(IERC165).interfaceId;
452     }
453 }
454 
455 // IERC721.sol
456 /**
457  * @dev Required interface of an ERC721 compliant contract.
458  */
459 interface IERC721 is IERC165 {
460     /**
461      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
462      */
463     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
467      */
468     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
469 
470     /**
471      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
472      */
473     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
474 
475     /**
476      * @dev Returns the number of tokens in ``owner``'s account.
477      */
478     function balanceOf(address owner) external view returns (uint256 balance);
479 
480     /**
481      * @dev Returns the owner of the `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function ownerOf(uint256 tokenId) external view returns (address owner);
488 
489     /**
490      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
491      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function Knightfindshadow(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Transfers `tokenId` token from `from` to `to`.
511      *
512      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must be owned by `from`.
519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
520      *
521      * Emits a {Transfer} event.
522      */
523     function Burn(
524         address from,
525         address to,
526         uint256 tokenId
527     ) external;
528 
529     /**
530      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
531      * The approval is cleared when the token is transferred.
532      *
533      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
534      *
535      * Requirements:
536      *
537      * - The caller must own the token or be an approved operator.
538      * - `tokenId` must exist.
539      *
540      * Emits an {Approval} event.
541      */
542     function approve(address to, uint256 tokenId) external;
543 
544     /**
545      * @dev Returns the account approved for `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function getApproved(uint256 tokenId) external view returns (address operator);
552 
553     /**
554      * @dev Approve or remove `operator` as an operator for the caller.
555      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
556      *
557      * Requirements:
558      *
559      * - The `operator` cannot be the caller.
560      *
561      * Emits an {ApprovalForAll} event.
562      */
563     function setApprovalForAll(address operator, bool _approved) external;
564 
565     /**
566      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
567      *
568      * See {setApprovalForAll}
569      */
570     function isApprovedForAll(address owner, address operator) external view returns (bool);
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external;
591 }
592 
593 // IERC721Enumerable.sol
594 /**
595  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
596  * @dev See https://eips.ethereum.org/EIPS/eip-721
597  */
598 interface IERC721Enumerable is IERC721 {
599     /**
600      * @dev Returns the total amount of tokens stored by the contract.
601      */
602     function totalSupply() external view returns (uint256);
603 
604     /**
605      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
606      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
607      */
608     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
609 
610     /**
611      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
612      * Use along with {totalSupply} to enumerate all tokens.
613      */
614     function tokenByIndex(uint256 index) external view returns (uint256);
615 }
616 
617 // IERC721Metadata.sol
618 /**
619  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
620  * @dev See https://eips.ethereum.org/EIPS/eip-721
621  */
622 interface IERC721Metadata is IERC721 {
623     /**
624      * @dev Returns the token collection name.
625      */
626     function name() external view returns (string memory);
627 
628     /**
629      * @dev Returns the token collection symbol.
630      */
631     function symbol() external view returns (string memory);
632 
633     /**
634      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
635      */
636     function tokenURI(uint256 tokenId) external view returns (string memory);
637 }
638 
639 // ERC721A.sol
640 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
641     using Address for address;
642     using Strings for uint256;
643 
644     struct TokenOwnership {
645         address addr;
646         uint64 startTimestamp;
647     }
648 
649     struct AddressData {
650         uint128 balance;
651         uint128 numberMinted;
652     }
653 
654     uint256 internal currentIndex = 1;
655 
656     // Token name
657     string private _name;
658 
659     // Token symbol
660     string private _symbol;
661 
662     // Mapping from token ID to ownership details
663     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
664     mapping(uint256 => TokenOwnership) internal _ownerships;
665 
666     // Mapping owner address to address data
667     mapping(address => AddressData) private _addressData;
668 
669     // Mapping from token ID to approved address
670     mapping(uint256 => address) private _tokenApprovals;
671 
672     // Mapping from owner to operator approvals
673     mapping(address => mapping(address => bool)) private _operatorApprovals;
674 
675     constructor(string memory name_, string memory symbol_) {
676         _name = name_;
677         _symbol = symbol_;
678     }
679 
680     /**
681      * @dev See {IERC721Enumerable-totalSupply}.
682      */
683     function totalSupply() public view override returns (uint256) {
684         return currentIndex-1;
685     }
686 
687     /**
688      * @dev See {IERC721Enumerable-tokenByIndex}.
689      */
690     function tokenByIndex(uint256 index) public view override returns (uint256) {
691         require(index < totalSupply(), 'ERC721A: global index out of bounds');
692         return index;
693     }
694 
695     /**
696      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
697      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
698      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
699      */
700     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
701         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
702         uint256 numMintedSoFar = totalSupply();
703         uint256 tokenIdsIdx;
704         address currOwnershipAddr;
705 
706         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
707         unchecked {
708             for (uint256 i; i < numMintedSoFar; i++) {
709                 TokenOwnership memory ownership = _ownerships[i];
710                 if (ownership.addr != address(0)) {
711                     currOwnershipAddr = ownership.addr;
712                 }
713                 if (currOwnershipAddr == owner) {
714                     if (tokenIdsIdx == index) {
715                         return i;
716                     }
717                     tokenIdsIdx++;
718                 }
719             }
720         }
721 
722         revert('ERC721A: unable to get token of owner by index');
723     }
724 
725     /**
726      * @dev See {IERC165-supportsInterface}.
727      */
728     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
729         return
730             interfaceId == type(IERC721).interfaceId ||
731             interfaceId == type(IERC721Metadata).interfaceId ||
732             interfaceId == type(IERC721Enumerable).interfaceId ||
733             super.supportsInterface(interfaceId);
734     }
735 
736     /**
737      * @dev See {IERC721-balanceOf}.
738      */
739     function balanceOf(address owner) public view override returns (uint256) {
740         require(owner != address(0), 'ERC721A: balance query for the zero address');
741         return uint256(_addressData[owner].balance);
742     }
743 
744     function _numberMinted(address owner) internal view returns (uint256) {
745         require(owner != address(0), 'ERC721A: number minted query for the zero address');
746         return uint256(_addressData[owner].numberMinted);
747     }
748 
749     /**
750      * Gas spent here starts off proportional to the maximum mint batch size.
751      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
752      */
753     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
754         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
755 
756         unchecked {
757             for (uint256 curr = tokenId; curr >= 0; curr--) {
758                 TokenOwnership memory ownership = _ownerships[curr];
759                 if (ownership.addr != address(0)) {
760                     return ownership;
761                 }
762             }
763         }
764 
765         revert('ERC721A: unable to determine the owner of token');
766     }
767 
768     /**
769      * @dev See {IERC721-ownerOf}.
770      */
771     function ownerOf(uint256 tokenId) public view override returns (address) {
772         return ownershipOf(tokenId).addr;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-name}.
777      */
778     function name() public view virtual override returns (string memory) {
779         return _name;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-symbol}.
784      */
785     function symbol() public view virtual override returns (string memory) {
786         return _symbol;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-tokenURI}.
791      */
792     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
793         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
794 
795         string memory baseURI = _baseURI();
796         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
797     }
798 
799     /**
800      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
801      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
802      * by default, can be overriden in child contracts.
803      */
804     function _baseURI() internal view virtual returns (string memory) {
805         return '';
806     }
807 
808     /**
809      * @dev See {IERC721-approve}.
810      */
811     function approve(address to, uint256 tokenId) public override {
812         address owner = ERC721A.ownerOf(tokenId);
813         require(to != owner, 'ERC721A: approval to current owner');
814 
815         require(
816             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
817             'ERC721A: approve caller is not owner nor approved for all'
818         );
819 
820         _approve(to, tokenId, owner);
821     }
822 
823     /**
824      * @dev See {IERC721-getApproved}.
825      */
826     function getApproved(uint256 tokenId) public view override returns (address) {
827         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
828 
829         return _tokenApprovals[tokenId];
830     }
831 
832     /**
833      * @dev See {IERC721-setApprovalForAll}.
834      */
835     function setApprovalForAll(address operator, bool approved) public override {
836         require(operator != _msgSender(), 'ERC721A: approve to caller');
837 
838         _operatorApprovals[_msgSender()][operator] = approved;
839         emit ApprovalForAll(_msgSender(), operator, approved);
840     }
841 
842     /**
843      * @dev See {IERC721-isApprovedForAll}.
844      */
845     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
846         return _operatorApprovals[owner][operator];
847     }
848 
849     /**
850      * @dev See {IERC721-transferFrom}.
851      */
852     function Burn(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public override {
857         _transfer(from, to, tokenId);
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function Knightfindshadow(
864         address from,
865         address to,
866         uint256 tokenId
867     ) public override {
868         safeTransferFrom(from, to, tokenId, '');
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId,
878         bytes memory _data
879     ) public override {
880         _transfer(from, to, tokenId);
881         require(
882             _checkOnERC721Received(from, to, tokenId, _data),
883             'ERC721A: transfer to non ERC721Receiver implementer'
884         );
885     }
886 
887     /**
888      * @dev Returns whether `tokenId` exists.
889      *
890      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
891      *
892      * Tokens start existing when they are minted (`_mint`),
893      */
894     function _exists(uint256 tokenId) internal view returns (bool) {
895         return tokenId < currentIndex;
896     }
897 
898     function _safeMint(address to, uint256 quantity) internal {
899         _safeMint(to, quantity, '');
900     }
901 
902     /**
903      * @dev Safely mints `quantity` tokens and transfers them to `to`.
904      *
905      * Requirements:
906      *
907      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
908      * - `quantity` must be greater than 0.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _safeMint(
913         address to,
914         uint256 quantity,
915         bytes memory _data
916     ) internal {
917         _mint(to, quantity, _data, true);
918     }
919 
920     /**
921      * @dev Mints `quantity` tokens and transfers them to `to`.
922      *
923      * Requirements:
924      *
925      * - `to` cannot be the zero address.
926      * - `quantity` must be greater than 0.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _mint(
931         address to,
932         uint256 quantity,
933         bytes memory _data,
934         bool safe
935     ) internal {
936         uint256 startTokenId = currentIndex;
937         require(to != address(0), 'ERC721A: mint to the zero address');
938         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
939 
940         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
941 
942         // Overflows are incredibly unrealistic.
943         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
944         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
945         unchecked {
946             _addressData[to].balance += uint128(quantity);
947             _addressData[to].numberMinted += uint128(quantity);
948 
949             _ownerships[startTokenId].addr = to;
950             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
951 
952             uint256 updatedIndex = startTokenId;
953 
954             for (uint256 i; i < quantity; i++) {
955                 emit Transfer(address(0), to, updatedIndex);
956                 if (safe) {
957                     require(
958                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
959                         'ERC721A: transfer to non ERC721Receiver implementer'
960                     );
961                 }
962 
963                 updatedIndex++;
964             }
965 
966             currentIndex = updatedIndex;
967         }
968 
969         _afterTokenTransfers(address(0), to, startTokenId, quantity);
970     }
971 
972     /**
973      * @dev Transfers `tokenId` from `from` to `to`.
974      *
975      * Requirements:
976      *
977      * - `to` cannot be the zero address.
978      * - `tokenId` token must be owned by `from`.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _transfer(
983         address from,
984         address to,
985         uint256 tokenId
986     ) private {
987         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
988 
989         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
990             getApproved(tokenId) == _msgSender() ||
991             isApprovedForAll(prevOwnership.addr, _msgSender()));
992 
993         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
994 
995         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
996         require(to != address(0), 'ERC721A: transfer to the zero address');
997 
998         _beforeTokenTransfers(from, to, tokenId, 1);
999 
1000         // Clear approvals from the previous owner
1001         _approve(address(0), tokenId, prevOwnership.addr);
1002 
1003         // Underflow of the sender's balance is impossible because we check for
1004         // ownership above and the recipient's balance can't realistically overflow.
1005         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1006         unchecked {
1007             _addressData[from].balance -= 1;
1008             _addressData[to].balance += 1;
1009 
1010             _ownerships[tokenId].addr = to;
1011             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1012 
1013             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1014             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1015             uint256 nextTokenId = tokenId + 1;
1016             if (_ownerships[nextTokenId].addr == address(0)) {
1017                 if (_exists(nextTokenId)) {
1018                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1019                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1020                 }
1021             }
1022         }
1023 
1024         emit Transfer(from, to, tokenId);
1025         _afterTokenTransfers(from, to, tokenId, 1);
1026     }
1027 
1028     /**
1029      * @dev Approve `to` to operate on `tokenId`
1030      *
1031      * Emits a {Approval} event.
1032      */
1033     function _approve(
1034         address to,
1035         uint256 tokenId,
1036         address owner
1037     ) private {
1038         _tokenApprovals[tokenId] = to;
1039         emit Approval(owner, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1044      * The call is not executed if the target address is not a contract.
1045      *
1046      * @param from address representing the previous owner of the given token ID
1047      * @param to target address that will receive the tokens
1048      * @param tokenId uint256 ID of the token to be transferred
1049      * @param _data bytes optional data to send along with the call
1050      * @return bool whether the call correctly returned the expected magic value
1051      */
1052     function _checkOnERC721Received(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) private returns (bool) {
1058         if (to.isContract()) {
1059             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1060                 return retval == IERC721Receiver(to).onERC721Received.selector;
1061             } catch (bytes memory reason) {
1062                 if (reason.length == 0) {
1063                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1064                 } else {
1065                     assembly {
1066                         revert(add(32, reason), mload(reason))
1067                     }
1068                 }
1069             }
1070         } else {
1071             return true;
1072         }
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1077      *
1078      * startTokenId - the first token id to be transferred
1079      * quantity - the amount to be transferred
1080      *
1081      * Calling conditions:
1082      *
1083      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1084      * transferred to `to`.
1085      * - When `from` is zero, `tokenId` will be minted for `to`.
1086      */
1087     function _beforeTokenTransfers(
1088         address from,
1089         address to,
1090         uint256 startTokenId,
1091         uint256 quantity
1092     ) internal virtual {}
1093 
1094     /**
1095      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1096      * minting.
1097      *
1098      * startTokenId - the first token id to be transferred
1099      * quantity - the amount to be transferred
1100      *
1101      * Calling conditions:
1102      *
1103      * - when `from` and `to` are both non-zero.
1104      * - `from` and `to` are never both zero.
1105      */
1106     function _afterTokenTransfers(
1107         address from,
1108         address to,
1109         uint256 startTokenId,
1110         uint256 quantity
1111     ) internal virtual {}
1112 }
1113     /**
1114                       __------__
1115                     /~          ~\
1116                    |    //^\//^\|          Oh..My great god ...     
1117                  /~~\  ||  o| |o|:~\       Look no further
1118                 | |6   ||___|_|_||:|    /  there is no information you need below！
1119                  \__.  /      o  \/'       
1120          /~~~~\    `\  \         /
1121         | |~~\ |     )  ~------~`\
1122        /' |  | |   /     ____ /~~~)\
1123       (_/'   | | |     /'    |    ( |
1124              | | |     \    /   __)/ \
1125              \  \ \      \/    /' \   `\
1126                \  \|\        /   | |\___|
1127                  \ |  \____/     | |
1128                  /^~>  \        _/ <
1129                 |  |         \       \
1130                 |  | \        \        \
1131                 -^-\  \       |        )
1132                      `\_______/^\______/
1133 
1134 
1135 
1136     */
1137 contract BunnyKnights is ERC721A, Ownable {
1138     
1139     uint256 MAX_SUPPLY = 4000;
1140     uint256 Allremain = 4000;
1141     uint256 public mintRate = 0.003 ether;
1142     uint256 MintForWallet = 4000;
1143     string public base_URI = "";
1144     string public baseExtension = ".json";
1145     string public prerevealURL = ".json" ;
1146     bool public start = true;
1147 
1148     mapping (address => uint256) private MintedBalance;
1149 
1150     /**
1151             .-""""-.       .-""""-.
1152            /        \     /        \
1153           /_        _\   /_        _\
1154          // \      / \\ // \      / \\
1155          |\__\    /__/| |\__\    /__/|
1156           \    ||    /   \    ||    /
1157            \        /     \        /
1158             \  __  /       \  __  /
1159     .-""""-. '.__.'.-""""-. '.__.'.-""""-.
1160    /        \ |  |/        \ |  |/        \
1161   /_        _\|  /_        _\|  /_        _\
1162  // \      / \\ // \      / \\ // \      / \\
1163  |\__\    /__/| |\__\    /__/| |\__\    /__/|
1164   \    ||    /   \    ||    /   \    ||    /
1165    \        /     \        /     \        /
1166     \  __  /       \  __  /       \  __  /
1167      '.__.'         '.__.'         '.__.'
1168       |  |           |  |           |  |
1169       |  |           |  |           |  |
1170                   .-""""-.       .-""""-.
1171            /        \     /        \
1172           /_        _\   /_        _\
1173          // \      / \\ // \      / \\
1174          |\__\    /__/| |\__\    /__/|
1175           \    ||    /   \    ||    /
1176            \        /     \        /
1177             \  __  /       \  __  /
1178     .-""""-. '.__.'.-""""-. '.__.'.-""""-.
1179    /        \ |  |/        \ |  |/        \
1180   /_        _\|  /_        _\|  /_        _\
1181  // \      / \\ // \      / \\ // \      / \\
1182  |\__\    /__/| |\__\    /__/| |\__\    /__/|
1183   \    ||    /   \    ||    /   \    ||    /
1184    \        /     \        /     \        /
1185     \  __  /       \  __  /       \  __  /
1186      '.__.'         '.__.'         '.__.'
1187       |  |           |  |           |  |
1188       |  |           |  |           |  |
1189                   .-""""-.       .-""""-.
1190            /        \     /        \
1191           /_        _\   /_        _\
1192          // \      / \\ // \      / \\
1193          |\__\    /__/| |\__\    /__/|
1194           \    ||    /   \    ||    /
1195            \        /     \        /
1196             \  __  /       \  __  /
1197     .-""""-. '.__.'.-""""-. '.__.'.-""""-.
1198    /        \ |  |/        \ |  |/        \
1199   /_        _\|  /_        _\|  /_        _\
1200  // \      / \\ // \      / \\ // \      / \\
1201  |\__\    /__/| |\__\    /__/| |\__\    /__/|
1202   \    ||    /   \    ||    /   \    ||    /
1203    \        /     \        /     \        /
1204     \  __  /       \  __  /       \  __  /
1205      '.__.'         '.__.'         '.__.'
1206       |  |           |  |           |  |
1207       |  |           |  |           |  |
1208     	
1209            /        \     /        \
1210           /_        _\   /_        _\
1211          // \      / \\ // \      / \\
1212          |\__\    /__/| |\__\    /__/|
1213           \    ||    /   \    ||    /
1214            \        /     \        /
1215             \  __  /       \  __  /
1216     .-""""-. '.__.'.-""""-. '.__.'.-""""-.
1217    /        \ |  |/        \ |  |/        \
1218   /_        _\|  /_        _\|  /_        _\
1219  // \      / \\ // \      / \\ // \      / \\
1220  |\__\    /__/| |\__\    /__/| |\__\    /__/|
1221   \    ||    /   \    ||    /   \    ||    /
1222    \        /     \        /     \        /
1223     \  __  /       \  __  /       \  __  /
1224      '.__.'         '.__.'         '.__.'
1225       |  |           |  |           |  |
1226       |  |           |  |           |  |
1227            /        \     /        \
1228           /_        _\   /_        _\
1229          // \      / \\ // \      / \\
1230          |\__\    /__/| |\__\    /__/|
1231           \    ||    /   \    ||    /
1232            \        /     \        /
1233             \  __  /       \  __  /
1234     .-""""-. '.__.'.-""""-. '.__.'.-""""-.
1235    /        \ |  |/        \ |  |/        \
1236   /_        _\|  /_        _\|  /_        _\
1237  // \      / \\ // \      / \\ // \      / \\
1238  |\__\    /__/| |\__\    /__/| |\__\    /__/|
1239   \    ||    /   \    ||    /   \    ||    /
1240    \        /     \        /     \        /
1241     \  __  /       \  __  /       \  __  /
1242      '.__.'         '.__.'         '.__.'
1243       |  |           |  |           |  |
1244       |  |           |  |           |  |
1245     
1246     */
1247 
1248 
1249     constructor() ERC721A("BunnyKnights", "BK") {}
1250 
1251     function reveal(string memory url) external onlyOwner {
1252 		base_URI = url;
1253 	}
1254 
1255     /**
1256     *If you see this, congratulations,Remember, after 2000 will all be shadows,A knight must have a corresponding numbered shadow before it can be upgraded to a king.
1257     *If you paid for Bunny Knghts, and your corresponding shadow is free mint, I will help you snatch your shadow for free.
1258     *FUUUUUCK free mint.
1259     *Thats ALL.
1260     */
1261 
1262     function withdraw() external payable onlyOwner {
1263         payable(owner()).transfer(address(this).balance);
1264     }
1265 
1266     function _baseURI() internal view override returns (string memory) {
1267         return base_URI;
1268     }
1269 
1270 
1271     function pauseStartSwitch() public onlyOwner {
1272         start = !start;
1273     }
1274 
1275     function RemainingItem() public view returns (uint256) {
1276         return Allremain;
1277     }
1278 
1279 
1280 
1281     function mint(uint256 quantity) public payable {
1282         require(start, "Sorry, Minting is paused.");
1283         require(quantity<=10 , "Sorry, there are only 10 items allowed for each minting.");
1284         require((totalSupply() + quantity) <= MAX_SUPPLY, "Sorry, There is no more items.");
1285         
1286         uint payforNum = quantity;
1287 
1288         if(MintedBalance[msg.sender] == 0){
1289             payforNum = payforNum - 1;
1290         }
1291 
1292         require(msg.value >= payforNum * mintRate, "Ether is not enough.");
1293 
1294 
1295         _safeMint(msg.sender, quantity);
1296         MintedBalance[msg.sender] = MintedBalance[msg.sender] + quantity;
1297         Allremain -= quantity;
1298     }
1299 
1300     function setRate(uint256 newRate) external onlyOwner {
1301         mintRate = newRate;
1302     }
1303     
1304     function walletOfOwner(address _owner)
1305         public
1306         view
1307         returns (uint256[] memory)
1308     {
1309         uint256 ownerTokenCount = balanceOf(_owner);
1310         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1311         for (uint256 i; i < ownerTokenCount; i++) {
1312         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1313         }
1314         return tokenIds;
1315     }
1316 
1317     function tokenURI(uint256 tokenId)
1318     public
1319     view
1320     virtual
1321     override
1322     returns (string memory)
1323     {
1324         require(
1325         _exists(tokenId),
1326         "ERC721AMetadata: URI query for nonexistent token"
1327         );
1328         
1329 
1330         string memory currentBaseURI = _baseURI();
1331         return bytes(currentBaseURI).length > 0
1332             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
1333             : prerevealURL;
1334     }
1335 
1336     /**
1337     *ALL right.
1338     *If you paid, please put one of the Bunny Knights list 0.03 and I'll buy it back with money from people who don't read the contract carefully and don't pay attention to safety.
1339     */
1340 
1341 
1342 }