1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _transferOwnership(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _transferOwnership(newOwner);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Internal function without access restriction.
86      */
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 /**
95  * @dev Interface of the ERC165 standard, as defined in the
96  * https://eips.ethereum.org/EIPS/eip-165[EIP].
97  *
98  * Implementers can declare support of contract interfaces, which can then be
99  * queried by others ({ERC165Checker}).
100  *
101  * For an implementation, see {ERC165}.
102  */
103 interface IERC165 {
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30 000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 /**
116  * @dev Required interface of an ERC721 compliant contract.
117  */
118 interface IERC721 is IERC165 {
119     /**
120      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
126      */
127     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
131      */
132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
133 
134     /**
135      * @dev Returns the number of tokens in ``owner``'s account.
136      */
137     function balanceOf(address owner) external view returns (uint256 balance);
138 
139     /**
140      * @dev Returns the owner of the `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function ownerOf(uint256 tokenId) external view returns (address owner);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
150      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId
166     ) external;
167 
168     /**
169      * @dev Transfers `tokenId` token from `from` to `to`.
170      *
171      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must be owned by `from`.
178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     /**
189      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
190      * The approval is cleared when the token is transferred.
191      *
192      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
193      *
194      * Requirements:
195      *
196      * - The caller must own the token or be an approved operator.
197      * - `tokenId` must exist.
198      *
199      * Emits an {Approval} event.
200      */
201     function approve(address to, uint256 tokenId) external;
202 
203     /**
204      * @dev Returns the account approved for `tokenId` token.
205      *
206      * Requirements:
207      *
208      * - `tokenId` must exist.
209      */
210     function getApproved(uint256 tokenId) external view returns (address operator);
211 
212     /**
213      * @dev Approve or remove `operator` as an operator for the caller.
214      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
215      *
216      * Requirements:
217      *
218      * - The `operator` cannot be the caller.
219      *
220      * Emits an {ApprovalForAll} event.
221      */
222     function setApprovalForAll(address operator, bool _approved) external;
223 
224     /**
225      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
226      *
227      * See {setApprovalForAll}
228      */
229     function isApprovedForAll(address owner, address operator) external view returns (bool);
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `tokenId` token must exist and be owned by `from`.
239      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
241      *
242      * Emits a {Transfer} event.
243      */
244     function safeTransferFrom(
245         address from,
246         address to,
247         uint256 tokenId,
248         bytes calldata data
249     ) external;
250 }
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by `operator` from `from`, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
266      */
267     function onERC721Received(
268         address operator,
269         address from,
270         uint256 tokenId,
271         bytes calldata data
272     ) external returns (bytes4);
273 }
274 
275 /**
276  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
277  * @dev See https://eips.ethereum.org/EIPS/eip-721
278  */
279 interface IERC721Metadata is IERC721 {
280     /**
281      * @dev Returns the token collection name.
282      */
283     function name() external view returns (string memory);
284 
285     /**
286      * @dev Returns the token collection symbol.
287      */
288     function symbol() external view returns (string memory);
289 
290     /**
291      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
292      */
293     function tokenURI(uint256 tokenId) external view returns (string memory);
294 }
295 
296 /**
297  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
298  * @dev See https://eips.ethereum.org/EIPS/eip-721
299  */
300 interface IERC721Enumerable is IERC721 {
301     /**
302      * @dev Returns the total amount of tokens stored by the contract.
303      */
304     function totalSupply() external view returns (uint256);
305 
306     /**
307      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
308      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
309      */
310     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
311 
312     /**
313      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
314      * Use along with {totalSupply} to enumerate all tokens.
315      */
316     function tokenByIndex(uint256 index) external view returns (uint256);
317 }
318 
319 /**
320  * @dev Collection of functions related to the address type
321  */
322 library Address {
323     /**
324      * @dev Returns true if `account` is a contract.
325      *
326      * [IMPORTANT]
327      * ====
328      * It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      *
331      * Among others, `isContract` will return false for the following
332      * types of addresses:
333      *
334      *  - an externally-owned account
335      *  - a contract in construction
336      *  - an address where a contract will be created
337      *  - an address where a contract lived, but was destroyed
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize, which returns 0 for contracts in
342         // construction, since the code is only stored at the end of the
343         // constructor execution.
344 
345         uint256 size;
346         assembly {
347             size := extcodesize(account)
348         }
349         return size > 0;
350     }
351 
352     /**
353      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
354      * `recipient`, forwarding all available gas and reverting on errors.
355      *
356      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
357      * of certain opcodes, possibly making contracts go over the 2300 gas limit
358      * imposed by `transfer`, making them unable to receive funds via
359      * `transfer`. {sendValue} removes this limitation.
360      *
361      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
362      *
363      * IMPORTANT: because control is transferred to `recipient`, care must be
364      * taken to not create reentrancy vulnerabilities. Consider using
365      * {ReentrancyGuard} or the
366      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         (bool success, ) = recipient.call{value: amount}("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain `call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
432      * with `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         require(address(this).balance >= value, "Address: insufficient balance for call");
443         require(isContract(target), "Address: call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.call{value: value}(data);
446         return verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
456         return functionStaticCall(target, data, "Address: low-level static call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal view returns (bytes memory) {
470         require(isContract(target), "Address: static call to non-contract");
471 
472         (bool success, bytes memory returndata) = target.staticcall(data);
473         return verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.delegatecall(data);
500         return verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
505      * revert reason using the provided one.
506      *
507      * _Available since v4.3._
508      */
509     function verifyCallResult(
510         bool success,
511         bytes memory returndata,
512         string memory errorMessage
513     ) internal pure returns (bytes memory) {
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 assembly {
522                     let returndata_size := mload(returndata)
523                     revert(add(32, returndata), returndata_size)
524                 }
525             } else {
526                 revert(errorMessage);
527             }
528         }
529     }
530 }
531 
532 /**
533  * @dev String operations.
534  */
535 library Strings {
536     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
537 
538     /**
539      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
540      */
541     function toString(uint256 value) internal pure returns (string memory) {
542         // Inspired by OraclizeAPI's implementation - MIT licence
543         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
544 
545         if (value == 0) {
546             return "0";
547         }
548         uint256 temp = value;
549         uint256 digits;
550         while (temp != 0) {
551             digits++;
552             temp /= 10;
553         }
554         bytes memory buffer = new bytes(digits);
555         while (value != 0) {
556             digits -= 1;
557             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
558             value /= 10;
559         }
560         return string(buffer);
561     }
562 
563     /**
564      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
565      */
566     function toHexString(uint256 value) internal pure returns (string memory) {
567         if (value == 0) {
568             return "0x00";
569         }
570         uint256 temp = value;
571         uint256 length = 0;
572         while (temp != 0) {
573             length++;
574             temp >>= 8;
575         }
576         return toHexString(value, length);
577     }
578 
579     /**
580      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
581      */
582     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
583         bytes memory buffer = new bytes(2 * length + 2);
584         buffer[0] = "0";
585         buffer[1] = "x";
586         for (uint256 i = 2 * length + 1; i > 1; --i) {
587             buffer[i] = _HEX_SYMBOLS[value & 0xf];
588             value >>= 4;
589         }
590         require(value == 0, "Strings: hex length insufficient");
591         return string(buffer);
592     }
593 }
594 
595 /**
596  * @dev Implementation of the {IERC165} interface.
597  *
598  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
599  * for the additional interface id that will be supported. For example:
600  *
601  * ```solidity
602  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
604  * }
605  * ```
606  *
607  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
608  */
609 abstract contract ERC165 is IERC165 {
610     /**
611      * @dev See {IERC165-supportsInterface}.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614         return interfaceId == type(IERC165).interfaceId;
615     }
616 }
617 
618 error ApprovalCallerNotOwnerNorApproved();
619 error ApprovalQueryForNonexistentToken();
620 error ApproveToCaller();
621 error ApprovalToCurrentOwner();
622 error BalanceQueryForZeroAddress();
623 error MintedQueryForZeroAddress();
624 error BurnedQueryForZeroAddress();
625 error AuxQueryForZeroAddress();
626 error MintToZeroAddress();
627 error MintZeroQuantity();
628 error OwnerIndexOutOfBounds();
629 error OwnerQueryForNonexistentToken();
630 error TokenIndexOutOfBounds();
631 error TransferCallerNotOwnerNorApproved();
632 error TransferFromIncorrectOwner();
633 error TransferToNonERC721ReceiverImplementer();
634 error TransferToZeroAddress();
635 error URIQueryForNonexistentToken();
636 
637 /**
638  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
639  * the Metadata extension. Built to optimize for lower gas during batch mints.
640  *
641  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
642  *
643  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
644  *
645  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
646  */
647 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
648     using Address for address;
649     using Strings for uint256;
650 
651     // Compiler will pack this into a single 256bit word.
652     struct TokenOwnership {
653         // The address of the owner.
654         address addr;
655         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
656         uint64 startTimestamp;
657         // Whether the token has been burned.
658         bool burned;
659     }
660 
661     // Compiler will pack this into a single 256bit word.
662     struct AddressData {
663         // Realistically, 2**64-1 is more than enough.
664         uint64 balance;
665         // Keeps track of mint count with minimal overhead for tokenomics.
666         uint64 numberMinted;
667         // Keeps track of burn count with minimal overhead for tokenomics.
668         uint64 numberBurned;
669         // For miscellaneous variable(s) pertaining to the address
670         // (e.g. number of whitelist mint slots used). 
671         // If there are multiple variables, please pack them into a uint64.
672         uint64 aux;
673     }
674 
675     // The tokenId of the next token to be minted.
676     uint256 internal _currentIndex;
677 
678     // The number of tokens burned.
679     uint256 internal _burnCounter;
680 
681     // Token name
682     string private _name;
683 
684     // Token symbol
685     string private _symbol;
686 
687     // Mapping from token ID to ownership details
688     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
689     mapping(uint256 => TokenOwnership) internal _ownerships;
690 
691     // Mapping owner address to address data
692     mapping(address => AddressData) private _addressData;
693 
694     // Mapping from token ID to approved address
695     mapping(uint256 => address) private _tokenApprovals;
696 
697     // Mapping from owner to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703     }
704 
705     /**
706      * @dev See {IERC721Enumerable-totalSupply}.
707      */
708     function totalSupply() public view returns (uint256) {
709         // Counter underflow is impossible as _burnCounter cannot be incremented
710         // more than _currentIndex times
711         unchecked {
712             return _currentIndex - _burnCounter;    
713         }
714     }
715 
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
720         return
721             interfaceId == type(IERC721).interfaceId ||
722             interfaceId == type(IERC721Metadata).interfaceId ||
723             super.supportsInterface(interfaceId);
724     }
725 
726     /**
727      * @dev See {IERC721-balanceOf}.
728      */
729     function balanceOf(address owner) public view override returns (uint256) {
730         if (owner == address(0)) revert BalanceQueryForZeroAddress();
731         return uint256(_addressData[owner].balance);
732     }
733 
734     /**
735      * Returns the number of tokens minted by `owner`.
736      */
737     function _numberMinted(address owner) internal view returns (uint256) {
738         if (owner == address(0)) revert MintedQueryForZeroAddress();
739         return uint256(_addressData[owner].numberMinted);
740     }
741 
742     /**
743      * Returns the number of tokens burned by or on behalf of `owner`.
744      */
745     function _numberBurned(address owner) internal view returns (uint256) {
746         if (owner == address(0)) revert BurnedQueryForZeroAddress();
747         return uint256(_addressData[owner].numberBurned);
748     }
749 
750     /**
751      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
752      */
753     function _getAux(address owner) internal view returns (uint64) {
754         if (owner == address(0)) revert AuxQueryForZeroAddress();
755         return _addressData[owner].aux;
756     }
757 
758     /**
759      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
760      * If there are multiple variables, please pack them into a uint64.
761      */
762     function _setAux(address owner, uint64 aux) internal {
763         if (owner == address(0)) revert AuxQueryForZeroAddress();
764         _addressData[owner].aux = aux;
765     }
766 
767     /**
768      * Gas spent here starts off proportional to the maximum mint batch size.
769      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
770      */
771     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
772         uint256 curr = tokenId;
773 
774         unchecked {
775             if (curr < _currentIndex) {
776                 TokenOwnership memory ownership = _ownerships[curr];
777                 if (!ownership.burned) {
778                     if (ownership.addr != address(0)) {
779                         return ownership;
780                     }
781                     // Invariant: 
782                     // There will always be an ownership that has an address and is not burned 
783                     // before an ownership that does not have an address and is not burned.
784                     // Hence, curr will not underflow.
785                     while (true) {
786                         curr--;
787                         ownership = _ownerships[curr];
788                         if (ownership.addr != address(0)) {
789                             return ownership;
790                         }
791                     }
792                 }
793             }
794         }
795         revert OwnerQueryForNonexistentToken();
796     }
797 
798     /**
799      * @dev See {IERC721-ownerOf}.
800      */
801     function ownerOf(uint256 tokenId) public view override returns (address) {
802         return ownershipOf(tokenId).addr;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-name}.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-symbol}.
814      */
815     function symbol() public view virtual override returns (string memory) {
816         return _symbol;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-tokenURI}.
821      */
822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
823         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
824 
825         string memory baseURI = _baseURI();
826         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
827     }
828 
829     /**
830      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
831      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
832      * by default, can be overriden in child contracts.
833      */
834     function _baseURI() internal view virtual returns (string memory) {
835         return '';
836     }
837 
838     /**
839      * @dev See {IERC721-approve}.
840      */
841     function approve(address to, uint256 tokenId) public override {
842         address owner = ERC721A.ownerOf(tokenId);
843         if (to == owner) revert ApprovalToCurrentOwner();
844 
845         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
846             revert ApprovalCallerNotOwnerNorApproved();
847         }
848 
849         _approve(to, tokenId, owner);
850     }
851 
852     /**
853      * @dev See {IERC721-getApproved}.
854      */
855     function getApproved(uint256 tokenId) public view override returns (address) {
856         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
857 
858         return _tokenApprovals[tokenId];
859     }
860 
861     /**
862      * @dev See {IERC721-setApprovalForAll}.
863      */
864     function setApprovalForAll(address operator, bool approved) public override {
865         if (operator == _msgSender()) revert ApproveToCaller();
866 
867         _operatorApprovals[_msgSender()][operator] = approved;
868         emit ApprovalForAll(_msgSender(), operator, approved);
869     }
870 
871     /**
872      * @dev See {IERC721-isApprovedForAll}.
873      */
874     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
875         return _operatorApprovals[owner][operator];
876     }
877 
878     /**
879      * @dev See {IERC721-transferFrom}.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public virtual override {
886         _transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         safeTransferFrom(from, to, tokenId, '');
898     }
899 
900     /**
901      * @dev See {IERC721-safeTransferFrom}.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) public virtual override {
909         _transfer(from, to, tokenId);
910         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
911             revert TransferToNonERC721ReceiverImplementer();
912         }
913     }
914 
915     /**
916      * @dev Returns whether `tokenId` exists.
917      *
918      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
919      *
920      * Tokens start existing when they are minted (`_mint`),
921      */
922     function _exists(uint256 tokenId) internal view returns (bool) {
923         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
924     }
925 
926     function _safeMint(address to, uint256 quantity) internal {
927         _safeMint(to, quantity, '');
928     }
929 
930     /**
931      * @dev Safely mints `quantity` tokens and transfers them to `to`.
932      *
933      * Requirements:
934      *
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
936      * - `quantity` must be greater than 0.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _safeMint(
941         address to,
942         uint256 quantity,
943         bytes memory _data
944     ) internal {
945         _mint(to, quantity, _data, true);
946     }
947 
948     /**
949      * @dev Mints `quantity` tokens and transfers them to `to`.
950      *
951      * Requirements:
952      *
953      * - `to` cannot be the zero address.
954      * - `quantity` must be greater than 0.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _mint(
959         address to,
960         uint256 quantity,
961         bytes memory _data,
962         bool safe
963     ) internal {
964         uint256 startTokenId = _currentIndex;
965         if (to == address(0)) revert MintToZeroAddress();
966         if (quantity == 0) revert MintZeroQuantity();
967 
968         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
969 
970         // Overflows are incredibly unrealistic.
971         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
972         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
973         unchecked {
974             _addressData[to].balance += uint64(quantity);
975             _addressData[to].numberMinted += uint64(quantity);
976 
977             _ownerships[startTokenId].addr = to;
978             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
979 
980             uint256 updatedIndex = startTokenId;
981 
982             for (uint256 i; i < quantity; i++) {
983                 emit Transfer(address(0), to, updatedIndex);
984                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
985                     revert TransferToNonERC721ReceiverImplementer();
986                 }
987                 updatedIndex++;
988             }
989 
990             _currentIndex = updatedIndex;
991         }
992         _afterTokenTransfers(address(0), to, startTokenId, quantity);
993     }
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must be owned by `from`.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _transfer(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) private {
1010         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1011 
1012         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1013             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1014             getApproved(tokenId) == _msgSender());
1015 
1016         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1017         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1018         if (to == address(0)) revert TransferToZeroAddress();
1019 
1020         _beforeTokenTransfers(from, to, tokenId, 1);
1021 
1022         // Clear approvals from the previous owner
1023         _approve(address(0), tokenId, prevOwnership.addr);
1024 
1025         // Underflow of the sender's balance is impossible because we check for
1026         // ownership above and the recipient's balance can't realistically overflow.
1027         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1028         unchecked {
1029             _addressData[from].balance -= 1;
1030             _addressData[to].balance += 1;
1031 
1032             _ownerships[tokenId].addr = to;
1033             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1034 
1035             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1036             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1037             uint256 nextTokenId = tokenId + 1;
1038             if (_ownerships[nextTokenId].addr == address(0)) {
1039                 // This will suffice for checking _exists(nextTokenId),
1040                 // as a burned slot cannot contain the zero address.
1041                 if (nextTokenId < _currentIndex) {
1042                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1043                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1044                 }
1045             }
1046         }
1047 
1048         emit Transfer(from, to, tokenId);
1049         _afterTokenTransfers(from, to, tokenId, 1);
1050     }
1051 
1052     /**
1053      * @dev Destroys `tokenId`.
1054      * The approval is cleared when the token is burned.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _burn(uint256 tokenId) internal virtual {
1063         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1064 
1065         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1066 
1067         // Clear approvals from the previous owner
1068         _approve(address(0), tokenId, prevOwnership.addr);
1069 
1070         // Underflow of the sender's balance is impossible because we check for
1071         // ownership above and the recipient's balance can't realistically overflow.
1072         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1073         unchecked {
1074             _addressData[prevOwnership.addr].balance -= 1;
1075             _addressData[prevOwnership.addr].numberBurned += 1;
1076 
1077             // Keep track of who burned the token, and the timestamp of burning.
1078             _ownerships[tokenId].addr = prevOwnership.addr;
1079             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1080             _ownerships[tokenId].burned = true;
1081 
1082             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1083             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1084             uint256 nextTokenId = tokenId + 1;
1085             if (_ownerships[nextTokenId].addr == address(0)) {
1086                 // This will suffice for checking _exists(nextTokenId),
1087                 // as a burned slot cannot contain the zero address.
1088                 if (nextTokenId < _currentIndex) {
1089                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1090                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1091                 }
1092             }
1093         }
1094 
1095         emit Transfer(prevOwnership.addr, address(0), tokenId);
1096         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1097 
1098         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1099         unchecked { 
1100             _burnCounter++;
1101         }
1102     }
1103 
1104     /**
1105      * @dev Approve `to` to operate on `tokenId`
1106      *
1107      * Emits a {Approval} event.
1108      */
1109     function _approve(
1110         address to,
1111         uint256 tokenId,
1112         address owner
1113     ) private {
1114         _tokenApprovals[tokenId] = to;
1115         emit Approval(owner, to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1120      * The call is not executed if the target address is not a contract.
1121      *
1122      * @param from address representing the previous owner of the given token ID
1123      * @param to target address that will receive the tokens
1124      * @param tokenId uint256 ID of the token to be transferred
1125      * @param _data bytes optional data to send along with the call
1126      * @return bool whether the call correctly returned the expected magic value
1127      */
1128     function _checkOnERC721Received(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) private returns (bool) {
1134         if (to.isContract()) {
1135             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1136                 return retval == IERC721Receiver(to).onERC721Received.selector;
1137             } catch (bytes memory reason) {
1138                 if (reason.length == 0) {
1139                     revert TransferToNonERC721ReceiverImplementer();
1140                 } else {
1141                     assembly {
1142                         revert(add(32, reason), mload(reason))
1143                     }
1144                 }
1145             }
1146         } else {
1147             return true;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1153      * And also called before burning one token.
1154      *
1155      * startTokenId - the first token id to be transferred
1156      * quantity - the amount to be transferred
1157      *
1158      * Calling conditions:
1159      *
1160      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1161      * transferred to `to`.
1162      * - When `from` is zero, `tokenId` will be minted for `to`.
1163      * - When `to` is zero, `tokenId` will be burned by `from`.
1164      * - `from` and `to` are never both zero.
1165      */
1166     function _beforeTokenTransfers(
1167         address from,
1168         address to,
1169         uint256 startTokenId,
1170         uint256 quantity
1171     ) internal virtual {}
1172 
1173     /**
1174      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1175      * minting.
1176      * And also called after one token has been burned.
1177      *
1178      * startTokenId - the first token id to be transferred
1179      * quantity - the amount to be transferred
1180      *
1181      * Calling conditions:
1182      *
1183      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1184      * transferred to `to`.
1185      * - When `from` is zero, `tokenId` has been minted for `to`.
1186      * - When `to` is zero, `tokenId` has been burned by `from`.
1187      * - `from` and `to` are never both zero.
1188      */
1189     function _afterTokenTransfers(
1190         address from,
1191         address to,
1192         uint256 startTokenId,
1193         uint256 quantity
1194     ) internal virtual {}
1195 }
1196 
1197 interface INFT {
1198 
1199     function mintedNunber(address addr) external returns(uint256);
1200 
1201 }
1202 
1203 contract SlothNFT is ERC721A, Ownable, INFT {
1204     using Strings for uint256;
1205     event PurchaseEvent(address purchaseWallet, uint256 nftID, uint256 purchaseTimestamp);
1206     uint256 public constant INVENTORY = 38777;
1207     uint256 private anti_hacker_limit = 0.002 ether;
1208     uint8 private _free_mint_available = 1;
1209     uint256 private _free_mint_start = 1655038800; //2022-06-12 13:00(UTC)
1210     uint256 private MINT_LIMIT = 2;
1211     bool private _is_revealed = false;
1212     string private _base_uri = "";
1213     string private _blindbox_uri = "https://ipfs.slothnft.org/sloth/blind/";
1214     
1215     function _baseURI() internal view override returns (string memory) {
1216         return _base_uri;
1217     }
1218 
1219     constructor() ERC721A("Sloth NFT", "SlothNFT") {
1220         mintTo(msg.sender, 1); 
1221     }
1222 
1223     function freeMint(uint256 amount) external payable {
1224         freeMintValidator(msg.sender, amount);
1225         mintTo(msg.sender, amount);
1226     }
1227 
1228     function freeMintValidator(address mintUser, uint256 amount) private {
1229         require(_free_mint_available == 1, "free mint not available now!");
1230         require(block.timestamp >= _free_mint_start, "free mint not start yet!");
1231         require(msg.value >= anti_hacker_limit * amount, "value less than anti_hacker_limit!");
1232         require(isEnough(amount), "free mint limit reached!");
1233         require((_numberMinted(mintUser) + amount) <= MINT_LIMIT, "free mint over limit");
1234     } 
1235 
1236     function startFreeMint() external onlyOwner{
1237         _free_mint_available = 1;
1238     }
1239 
1240     function stopFreeMint() external onlyOwner{
1241         _free_mint_available = 0;
1242     }
1243 
1244     function updateFreeMintTime(uint256 time_) external onlyOwner{
1245         _free_mint_start = time_;
1246     }
1247 
1248     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1249         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1250         if (!_is_revealed) {
1251             return bytes(_blindbox_uri).length > 0 ? string(abi.encodePacked(_blindbox_uri, tokenId.toString())) : "";
1252         }
1253         string memory baseURI = _baseURI();
1254         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1255     }
1256 
1257     function isEnough(uint256 amount) private view returns (bool enough) {
1258         uint256 solded = totalSupply();
1259         uint256 afterPurchased = solded + amount;
1260         enough = true;
1261         require(afterPurchased <= INVENTORY, "Max limit");
1262     }
1263 
1264     function isOwner(uint256 nftID, address owner) external view returns(bool isNFTOwner) {
1265         address tokenOwner = ownerOf(nftID);
1266         isNFTOwner = (tokenOwner == owner);
1267     }
1268 
1269     function mintedNunber(address addr) external override view returns(uint256) {
1270         return _numberMinted(addr);
1271     }
1272 
1273     function listMyNFT(address owner) external view returns (uint256[] memory tokens) {
1274         uint256 owned = balanceOf(owner);
1275         tokens = new uint256[](owned);
1276         uint256 start = 0;
1277         for (uint i=0; i<totalSupply(); i++) {
1278             if (ownerOf(i) == owner) {
1279                 tokens[start] = i;
1280                 start ++;
1281             }
1282         }
1283     }
1284 
1285     function mintTo(address purchaseUser, uint256 amount) private {
1286         _safeMint(purchaseUser, amount);
1287     }
1288 
1289     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1290         return super.supportsInterface(interfaceId);
1291     }
1292 
1293     function setBaseData(bool isRevealed, string memory uri) external onlyOwner {
1294         _base_uri = uri;
1295         _is_revealed = isRevealed;
1296     }
1297 
1298     function setReveal(bool reveal_) external onlyOwner {
1299         _is_revealed = reveal_;
1300     }
1301 
1302     function withdrawETH(address wallet) external onlyOwner {
1303         payable(wallet).transfer(address(this).balance);
1304     }
1305 
1306     function withdrawTo(address wallet, uint256 amount) external onlyOwner {
1307         payable(wallet).transfer(amount);
1308     }
1309 
1310     function updateBlindboxURI(string memory url) external onlyOwner {
1311         _blindbox_uri = url;
1312     }
1313 
1314     function updateAntiHacker(uint256 price_) external onlyOwner {
1315         anti_hacker_limit = price_;
1316     }
1317 
1318     function updateMintLimit(uint256 limit_) external onlyOwner {
1319         MINT_LIMIT = limit_;
1320     }
1321 }