1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Collection of functions related to the address type
93  */
94 library Address {
95     /**
96      * @dev Returns true if `account` is a contract.
97      *
98      * [IMPORTANT]
99      * ====
100      * It is unsafe to assume that an address for which this function returns
101      * false is an externally-owned account (EOA) and not a contract.
102      *
103      * Among others, `isContract` will return false for the following
104      * types of addresses:
105      *
106      *  - an externally-owned account
107      *  - a contract in construction
108      *  - an address where a contract will be created
109      *  - an address where a contract lived, but was destroyed
110      * ====
111      */
112     function isContract(address account) internal view returns (bool) {
113         // This method relies on extcodesize, which returns 0 for contracts in
114         // construction, since the code is only stored at the end of the
115         // constructor execution.
116 
117         uint256 size;
118         assembly {
119             size := extcodesize(account)
120         }
121         return size > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @dev Interface of the ERC165 standard, as defined in the
307  * https://eips.ethereum.org/EIPS/eip-165[EIP].
308  *
309  * Implementers can declare support of contract interfaces, which can then be
310  * queried by others ({ERC165Checker}).
311  *
312  * For an implementation, see {ERC165}.
313  */
314 interface IERC165 {
315     /**
316      * @dev Returns true if this contract implements the interface defined by
317      * `interfaceId`. See the corresponding
318      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
319      * to learn more about how these ids are created.
320      *
321      * This function call must use less than 30 000 gas.
322      */
323     function supportsInterface(bytes4 interfaceId) external view returns (bool);
324 }
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @title ERC721 token receiver interface
329  * @dev Interface for any contract that wants to support safeTransfers
330  * from ERC721 asset contracts.
331  */
332 interface IERC721Receiver {
333     /**
334      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
335      * by `operator` from `from`, this function is called.
336      *
337      * It must return its Solidity selector to confirm the token transfer.
338      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
339      *
340      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
341      */
342     function onERC721Received(
343         address operator,
344         address from,
345         uint256 tokenId,
346         bytes calldata data
347     ) external returns (bytes4);
348 }
349 pragma solidity ^0.8.0;
350 
351 
352 /**
353  * @dev Contract module which provides a basic access control mechanism, where
354  * there is an account (an owner) that can be granted exclusive access to
355  * specific functions.
356  *
357  * By default, the owner account will be the one that deploys the contract. This
358  * can later be changed with {transferOwnership}.
359  *
360  * This module is used through inheritance. It will make available the modifier
361  * `onlyOwner`, which can be applied to your functions to restrict their use to
362  * the owner.
363  */
364 abstract contract Ownable is Context {
365     address private _owner;
366 
367     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
368 
369     /**
370      * @dev Initializes the contract setting the deployer as the initial owner.
371      */
372     constructor() {
373         _setOwner(_msgSender());
374     }
375 
376     /**
377      * @dev Returns the address of the current owner.
378      */
379     function owner() public view virtual returns (address) {
380         return _owner;
381     }
382 
383     /**
384      * @dev Throws if called by any account other than the owner.
385      */
386     modifier onlyOwner() {
387         require(owner() == _msgSender(), "Ownable: caller is not the owner");
388         _;
389     }
390 
391     /**
392      * @dev Leaves the contract without owner. It will not be possible to call
393      * `onlyOwner` functions anymore. Can only be called by the current owner.
394      *
395      * NOTE: Renouncing ownership will leave the contract without an owner,
396      * thereby removing any functionality that is only available to the owner.
397      */
398     function renounceOwnership() public virtual onlyOwner {
399         _setOwner(address(0));
400     }
401 
402     /**
403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
404      * Can only be called by the current owner.
405      */
406     function transferOwnership(address newOwner) public virtual onlyOwner {
407         require(newOwner != address(0), "Ownable: new owner is the zero address");
408         _setOwner(newOwner);
409     }
410 
411     function _setOwner(address newOwner) private {
412         address oldOwner = _owner;
413         _owner = newOwner;
414         emit OwnershipTransferred(oldOwner, newOwner);
415     }
416 }
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Implementation of the {IERC165} interface.
422  *
423  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
424  * for the additional interface id that will be supported. For example:
425  *
426  * ```solidity
427  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
429  * }
430  * ```
431  *
432  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
433  */
434 abstract contract ERC165 is IERC165 {
435     /**
436      * @dev See {IERC165-supportsInterface}.
437      */
438     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439         return interfaceId == type(IERC165).interfaceId;
440     }
441 }
442 pragma solidity ^0.8.0;
443 
444 
445 /**
446  * @dev Required interface of an ERC721 compliant contract.
447  */
448 interface IERC721 is IERC165 {
449     /**
450      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
451      */
452     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
453 
454     /**
455      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
456      */
457     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
458 
459     /**
460      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
461      */
462     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
463 
464     /**
465      * @dev Returns the number of tokens in ``owner``'s account.
466      */
467     function balanceOf(address owner) external view returns (uint256 balance);
468 
469     /**
470      * @dev Returns the owner of the `tokenId` token.
471      *
472      * Requirements:
473      *
474      * - `tokenId` must exist.
475      */
476     function ownerOf(uint256 tokenId) external view returns (address owner);
477 
478     /**
479      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
480      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must exist and be owned by `from`.
487      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
489      *
490      * Emits a {Transfer} event.
491      */
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) external;
497 
498     /**
499      * @dev Transfers `tokenId` token from `from` to `to`.
500      *
501      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must be owned by `from`.
508      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
509      *
510      * Emits a {Transfer} event.
511      */
512     function transferFrom(
513         address from,
514         address to,
515         uint256 tokenId
516     ) external;
517 
518     /**
519      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
520      * The approval is cleared when the token is transferred.
521      *
522      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
523      *
524      * Requirements:
525      *
526      * - The caller must own the token or be an approved operator.
527      * - `tokenId` must exist.
528      *
529      * Emits an {Approval} event.
530      */
531     function approve(address to, uint256 tokenId) external;
532 
533     /**
534      * @dev Returns the account approved for `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function getApproved(uint256 tokenId) external view returns (address operator);
541 
542     /**
543      * @dev Approve or remove `operator` as an operator for the caller.
544      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
545      *
546      * Requirements:
547      *
548      * - The `operator` cannot be the caller.
549      *
550      * Emits an {ApprovalForAll} event.
551      */
552     function setApprovalForAll(address operator, bool _approved) external;
553 
554     /**
555      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
556      *
557      * See {setApprovalForAll}
558      */
559     function isApprovedForAll(address owner, address operator) external view returns (bool);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId,
578         bytes calldata data
579     ) external;
580 }
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
586  * @dev See https://eips.ethereum.org/EIPS/eip-721
587  */
588 interface IERC721Metadata is IERC721 {
589     /**
590      * @dev Returns the token collection name.
591      */
592     function name() external view returns (string memory);
593 
594     /**
595      * @dev Returns the token collection symbol.
596      */
597     function symbol() external view returns (string memory);
598 
599     /**
600      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
601      */
602     function tokenURI(uint256 tokenId) external view returns (string memory);
603 }
604 interface IERC721Enumerable is IERC721 {
605     /**
606      * @dev Returns the total amount of tokens stored by the contract.
607      */
608     function totalSupply() external view returns (uint256);
609 
610     /**
611      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
612      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
613      */
614     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
615 
616     /**
617      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
618      * Use along with {totalSupply} to enumerate all tokens.
619      */
620     function tokenByIndex(uint256 index) external view returns (uint256);
621 }
622 error ApprovalCallerNotOwnerNorApproved();
623 error ApprovalQueryForNonexistentToken();
624 error ApproveToCaller();
625 error ApprovalToCurrentOwner();
626 error BalanceQueryForZeroAddress();
627 error MintedQueryForZeroAddress();
628 error BurnedQueryForZeroAddress();
629 error AuxQueryForZeroAddress();
630 error MintToZeroAddress();
631 error MintZeroQuantity();
632 error OwnerIndexOutOfBounds();
633 error OwnerQueryForNonexistentToken();
634 error TokenIndexOutOfBounds();
635 error TransferCallerNotOwnerNorApproved();
636 error TransferFromIncorrectOwner();
637 error TransferToNonERC721ReceiverImplementer();
638 error TransferToZeroAddress();
639 error URIQueryForNonexistentToken();
640 
641 /**
642  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
643  * the Metadata extension. Built to optimize for lower gas during batch mints.
644  *
645  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
646  *
647  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
648  *
649  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
650  */
651 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
652     using Address for address;
653     using Strings for uint256;
654 
655     // Compiler will pack this into a single 256bit word.
656     struct TokenOwnership {
657         // The address of the owner.
658         address addr;
659         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
660         uint64 startTimestamp;
661         // Whether the token has been burned.
662         bool burned;
663     }
664 
665     // Compiler will pack this into a single 256bit word.
666     struct AddressData {
667         // Realistically, 2**64-1 is more than enough.
668         uint64 balance;
669         // Keeps track of mint count with minimal overhead for tokenomics.
670         uint64 numberMinted;
671         // Keeps track of burn count with minimal overhead for tokenomics.
672         uint64 numberBurned;
673         // For miscellaneous variable(s) pertaining to the address
674         // (e.g. number of whitelist mint slots used). 
675         // If there are multiple variables, please pack them into a uint64.
676         uint64 aux;
677     }
678 
679     // The tokenId of the next token to be minted.
680     uint256 internal _currentIndex = 1;
681 
682     // The number of tokens burned.
683     uint256 internal _burnCounter;
684 
685     // Token name
686     string private _name;
687 
688     // Token symbol
689     string private _symbol;
690 
691     // Mapping from token ID to ownership details
692     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
693     mapping(uint256 => TokenOwnership) internal _ownerships;
694 
695     // Mapping owner address to address data
696     mapping(address => AddressData) private _addressData;
697 
698     // Mapping from token ID to approved address
699     mapping(uint256 => address) private _tokenApprovals;
700 
701     // Mapping from owner to operator approvals
702     mapping(address => mapping(address => bool)) private _operatorApprovals;
703 
704     constructor(string memory name_, string memory symbol_) {
705         _name = name_;
706         _symbol = symbol_;
707     }
708 
709     /**
710      * @dev See {IERC721Enumerable-totalSupply}.
711      */
712     function totalSupply() public view returns (uint256) {
713         // Counter underflow is impossible as _burnCounter cannot be incremented
714         // more than _currentIndex times
715         unchecked {
716             return (_currentIndex - _burnCounter) - 1;    
717         }
718     }
719 
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
724         return
725             interfaceId == type(IERC721).interfaceId ||
726             interfaceId == type(IERC721Metadata).interfaceId ||
727             super.supportsInterface(interfaceId);
728     }
729 
730     /**
731      * @dev See {IERC721-balanceOf}.
732      */
733     function balanceOf(address owner) public view override returns (uint256) {
734         if (owner == address(0)) revert BalanceQueryForZeroAddress();
735         return uint256(_addressData[owner].balance);
736     }
737 
738     /**
739      * Returns the number of tokens minted by `owner`.
740      */
741     function _numberMinted(address owner) internal view returns (uint256) {
742         if (owner == address(0)) revert MintedQueryForZeroAddress();
743         return uint256(_addressData[owner].numberMinted);
744     }
745 
746     /**
747      * Returns the number of tokens burned by or on behalf of `owner`.
748      */
749     function _numberBurned(address owner) internal view returns (uint256) {
750         if (owner == address(0)) revert BurnedQueryForZeroAddress();
751         return uint256(_addressData[owner].numberBurned);
752     }
753 
754     /**
755      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
756      */
757     function _getAux(address owner) internal view returns (uint64) {
758         if (owner == address(0)) revert AuxQueryForZeroAddress();
759         return _addressData[owner].aux;
760     }
761 
762     /**
763      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
764      * If there are multiple variables, please pack them into a uint64.
765      */
766     function _setAux(address owner, uint64 aux) internal {
767         if (owner == address(0)) revert AuxQueryForZeroAddress();
768         _addressData[owner].aux = aux;
769     }
770 
771     /**
772      * Gas spent here starts off proportional to the maximum mint batch size.
773      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
774      */
775     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
776         uint256 curr = tokenId;
777 
778         unchecked {
779             if (curr < _currentIndex) {
780                 TokenOwnership memory ownership = _ownerships[curr];
781                 if (!ownership.burned) {
782                     if (ownership.addr != address(0)) {
783                         return ownership;
784                     }
785                     // Invariant: 
786                     // There will always be an ownership that has an address and is not burned 
787                     // before an ownership that does not have an address and is not burned.
788                     // Hence, curr will not underflow.
789                     while (true) {
790                         curr--;
791                         ownership = _ownerships[curr];
792                         if (ownership.addr != address(0)) {
793                             return ownership;
794                         }
795                     }
796                 }
797             }
798         }
799         revert OwnerQueryForNonexistentToken();
800     }
801 
802     /**
803      * @dev See {IERC721-ownerOf}.
804      */
805     function ownerOf(uint256 tokenId) public view override returns (address) {
806         return ownershipOf(tokenId).addr;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-name}.
811      */
812     function name() public view virtual override returns (string memory) {
813         return _name;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-symbol}.
818      */
819     function symbol() public view virtual override returns (string memory) {
820         return _symbol;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-tokenURI}.
825      */
826     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
827         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
828 
829         string memory baseURI = _baseURI();
830         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
831     }
832 
833     /**
834      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
835      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
836      * by default, can be overriden in child contracts.
837      */
838     function _baseURI() internal view virtual returns (string memory) {
839         return '';
840     }
841 
842     /**
843      * @dev See {IERC721-approve}.
844      */
845     function approve(address to, uint256 tokenId) public override {
846         address owner = ERC721A.ownerOf(tokenId);
847         if (to == owner) revert ApprovalToCurrentOwner();
848 
849         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
850             revert ApprovalCallerNotOwnerNorApproved();
851         }
852 
853         _approve(to, tokenId, owner);
854     }
855 
856     /**
857      * @dev See {IERC721-getApproved}.
858      */
859     function getApproved(uint256 tokenId) public view override returns (address) {
860         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
861 
862         return _tokenApprovals[tokenId];
863     }
864 
865     /**
866      * @dev See {IERC721-setApprovalForAll}.
867      */
868     function setApprovalForAll(address operator, bool approved) public override {
869         if (operator == _msgSender()) revert ApproveToCaller();
870 
871         _operatorApprovals[_msgSender()][operator] = approved;
872         emit ApprovalForAll(_msgSender(), operator, approved);
873     }
874 
875     /**
876      * @dev See {IERC721-isApprovedForAll}.
877      */
878     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
879         return _operatorApprovals[owner][operator];
880     }
881 
882     /**
883      * @dev See {IERC721-transferFrom}.
884      */
885     function transferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         _transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, '');
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) public virtual override {
913         _transfer(from, to, tokenId);
914         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
915             revert TransferToNonERC721ReceiverImplementer();
916         }
917     }
918 
919     /**
920      * @dev Returns whether `tokenId` exists.
921      *
922      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
923      *
924      * Tokens start existing when they are minted (`_mint`),
925      */
926     function _exists(uint256 tokenId) internal view returns (bool) {
927         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
928     }
929 
930     function _safeMint(address to, uint256 quantity) internal {
931         _safeMint(to, quantity, '');
932     }
933 
934     /**
935      * @dev Safely mints `quantity` tokens and transfers them to `to`.
936      *
937      * Requirements:
938      *
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
940      * - `quantity` must be greater than 0.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _safeMint(
945         address to,
946         uint256 quantity,
947         bytes memory _data
948     ) internal {
949         _mint(to, quantity, _data, true);
950     }
951 
952     /**
953      * @dev Mints `quantity` tokens and transfers them to `to`.
954      *
955      * Requirements:
956      *
957      * - `to` cannot be the zero address.
958      * - `quantity` must be greater than 0.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _mint(
963         address to,
964         uint256 quantity,
965         bytes memory _data,
966         bool safe
967     ) internal {
968         uint256 startTokenId = _currentIndex;
969         if (to == address(0)) revert MintToZeroAddress();
970         if (quantity == 0) revert MintZeroQuantity();
971 
972         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
973 
974         // Overflows are incredibly unrealistic.
975         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
976         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
977         unchecked {
978             _addressData[to].balance += uint64(quantity);
979             _addressData[to].numberMinted += uint64(quantity);
980 
981             _ownerships[startTokenId].addr = to;
982             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
983 
984             uint256 updatedIndex = startTokenId;
985 
986             for (uint256 i; i < quantity; i++) {
987                 emit Transfer(address(0), to, updatedIndex);
988                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
989                     revert TransferToNonERC721ReceiverImplementer();
990                 }
991                 updatedIndex++;
992             }
993 
994             _currentIndex = updatedIndex;
995         }
996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
997     }
998 
999     /**
1000      * @dev Transfers `tokenId` from `from` to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must be owned by `from`.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) private {
1014         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1015 
1016         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1017             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1018             getApproved(tokenId) == _msgSender());
1019 
1020         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1021         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1022         if (to == address(0)) revert TransferToZeroAddress();
1023 
1024         _beforeTokenTransfers(from, to, tokenId, 1);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId, prevOwnership.addr);
1028 
1029         // Underflow of the sender's balance is impossible because we check for
1030         // ownership above and the recipient's balance can't realistically overflow.
1031         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1032         unchecked {
1033             _addressData[from].balance -= 1;
1034             _addressData[to].balance += 1;
1035 
1036             _ownerships[tokenId].addr = to;
1037             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1038 
1039             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1040             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1041             uint256 nextTokenId = tokenId + 1;
1042             if (_ownerships[nextTokenId].addr == address(0)) {
1043                 // This will suffice for checking _exists(nextTokenId),
1044                 // as a burned slot cannot contain the zero address.
1045                 if (nextTokenId < _currentIndex) {
1046                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1047                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1048                 }
1049             }
1050         }
1051 
1052         emit Transfer(from, to, tokenId);
1053         _afterTokenTransfers(from, to, tokenId, 1);
1054     }
1055 
1056     /**
1057      * @dev Destroys `tokenId`.
1058      * The approval is cleared when the token is burned.
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must exist.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _burn(uint256 tokenId) internal virtual {
1067         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1068 
1069         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1070 
1071         // Clear approvals from the previous owner
1072         _approve(address(0), tokenId, prevOwnership.addr);
1073 
1074         // Underflow of the sender's balance is impossible because we check for
1075         // ownership above and the recipient's balance can't realistically overflow.
1076         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1077         unchecked {
1078             _addressData[prevOwnership.addr].balance -= 1;
1079             _addressData[prevOwnership.addr].numberBurned += 1;
1080 
1081             // Keep track of who burned the token, and the timestamp of burning.
1082             _ownerships[tokenId].addr = prevOwnership.addr;
1083             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1084             _ownerships[tokenId].burned = true;
1085 
1086             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1087             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1088             uint256 nextTokenId = tokenId + 1;
1089             if (_ownerships[nextTokenId].addr == address(0)) {
1090                 // This will suffice for checking _exists(nextTokenId),
1091                 // as a burned slot cannot contain the zero address.
1092                 if (nextTokenId < _currentIndex) {
1093                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1094                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1095                 }
1096             }
1097         }
1098 
1099         emit Transfer(prevOwnership.addr, address(0), tokenId);
1100         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1101 
1102         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1103         unchecked { 
1104             _burnCounter++;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Approve `to` to operate on `tokenId`
1110      *
1111      * Emits a {Approval} event.
1112      */
1113     function _approve(
1114         address to,
1115         uint256 tokenId,
1116         address owner
1117     ) private {
1118         _tokenApprovals[tokenId] = to;
1119         emit Approval(owner, to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1124      * The call is not executed if the target address is not a contract.
1125      *
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param _data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) private returns (bool) {
1138         if (to.isContract()) {
1139             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1140                 return retval == IERC721Receiver(to).onERC721Received.selector;
1141             } catch (bytes memory reason) {
1142                 if (reason.length == 0) {
1143                     revert TransferToNonERC721ReceiverImplementer();
1144                 } else {
1145                     assembly {
1146                         revert(add(32, reason), mload(reason))
1147                     }
1148                 }
1149             }
1150         } else {
1151             return true;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1157      * And also called before burning one token.
1158      *
1159      * startTokenId - the first token id to be transferred
1160      * quantity - the amount to be transferred
1161      *
1162      * Calling conditions:
1163      *
1164      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1165      * transferred to `to`.
1166      * - When `from` is zero, `tokenId` will be minted for `to`.
1167      * - When `to` is zero, `tokenId` will be burned by `from`.
1168      * - `from` and `to` are never both zero.
1169      */
1170     function _beforeTokenTransfers(
1171         address from,
1172         address to,
1173         uint256 startTokenId,
1174         uint256 quantity
1175     ) internal virtual {}
1176 
1177     /**
1178      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1179      * minting.
1180      * And also called after one token has been burned.
1181      *
1182      * startTokenId - the first token id to be transferred
1183      * quantity - the amount to be transferred
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` has been minted for `to`.
1190      * - When `to` is zero, `tokenId` has been burned by `from`.
1191      * - `from` and `to` are never both zero.
1192      */
1193     function _afterTokenTransfers(
1194         address from,
1195         address to,
1196         uint256 startTokenId,
1197         uint256 quantity
1198     ) internal virtual {}
1199 }
1200 
1201 library ECDSA {
1202     enum RecoverError {
1203         NoError,
1204         InvalidSignature,
1205         InvalidSignatureLength,
1206         InvalidSignatureS,
1207         InvalidSignatureV
1208     }
1209 
1210     function _throwError(RecoverError error) private pure {
1211         if (error == RecoverError.NoError) {
1212             return; // no error: do nothing
1213         } else if (error == RecoverError.InvalidSignature) {
1214             revert("ECDSA: invalid signature");
1215         } else if (error == RecoverError.InvalidSignatureLength) {
1216             revert("ECDSA: invalid signature length");
1217         } else if (error == RecoverError.InvalidSignatureS) {
1218             revert("ECDSA: invalid signature 's' value");
1219         } else if (error == RecoverError.InvalidSignatureV) {
1220             revert("ECDSA: invalid signature 'v' value");
1221         }
1222     }
1223 
1224     /**
1225      * @dev Returns the address that signed a hashed message (`hash`) with
1226      * `signature` or error string. This address can then be used for verification purposes.
1227      *
1228      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1229      * this function rejects them by requiring the `s` value to be in the lower
1230      * half order, and the `v` value to be either 27 or 28.
1231      *
1232      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1233      * verification to be secure: it is possible to craft signatures that
1234      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1235      * this is by receiving a hash of the original message (which may otherwise
1236      * be too long), and then calling {toEthSignedMessageHash} on it.
1237      *
1238      * Documentation for signature generation:
1239      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1240      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1241      *
1242      * _Available since v4.3._
1243      */
1244     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1245         // Check the signature length
1246         // - case 65: r,s,v signature (standard)
1247         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1248         if (signature.length == 65) {
1249             bytes32 r;
1250             bytes32 s;
1251             uint8 v;
1252             // ecrecover takes the signature parameters, and the only way to get them
1253             // currently is to use assembly.
1254             assembly {
1255                 r := mload(add(signature, 0x20))
1256                 s := mload(add(signature, 0x40))
1257                 v := byte(0, mload(add(signature, 0x60)))
1258             }
1259             return tryRecover(hash, v, r, s);
1260         } else if (signature.length == 64) {
1261             bytes32 r;
1262             bytes32 vs;
1263             // ecrecover takes the signature parameters, and the only way to get them
1264             // currently is to use assembly.
1265             assembly {
1266                 r := mload(add(signature, 0x20))
1267                 vs := mload(add(signature, 0x40))
1268             }
1269             return tryRecover(hash, r, vs);
1270         } else {
1271             return (address(0), RecoverError.InvalidSignatureLength);
1272         }
1273     }
1274 
1275     /**
1276      * @dev Returns the address that signed a hashed message (`hash`) with
1277      * `signature`. This address can then be used for verification purposes.
1278      *
1279      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1280      * this function rejects them by requiring the `s` value to be in the lower
1281      * half order, and the `v` value to be either 27 or 28.
1282      *
1283      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1284      * verification to be secure: it is possible to craft signatures that
1285      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1286      * this is by receiving a hash of the original message (which may otherwise
1287      * be too long), and then calling {toEthSignedMessageHash} on it.
1288      */
1289     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1290         (address recovered, RecoverError error) = tryRecover(hash, signature);
1291         _throwError(error);
1292         return recovered;
1293     }
1294 
1295     /**
1296      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1297      *
1298      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1299      *
1300      * _Available since v4.3._
1301      */
1302     function tryRecover(
1303         bytes32 hash,
1304         bytes32 r,
1305         bytes32 vs
1306     ) internal pure returns (address, RecoverError) {
1307         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1308         uint8 v = uint8((uint256(vs) >> 255) + 27);
1309         return tryRecover(hash, v, r, s);
1310     }
1311 
1312     /**
1313      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1314      *
1315      * _Available since v4.2._
1316      */
1317     function recover(
1318         bytes32 hash,
1319         bytes32 r,
1320         bytes32 vs
1321     ) internal pure returns (address) {
1322         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1323         _throwError(error);
1324         return recovered;
1325     }
1326 
1327     /**
1328      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1329      * `r` and `s` signature fields separately.
1330      *
1331      * _Available since v4.3._
1332      */
1333     function tryRecover(
1334         bytes32 hash,
1335         uint8 v,
1336         bytes32 r,
1337         bytes32 s
1338     ) internal pure returns (address, RecoverError) {
1339         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1340         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1341         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1342         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1343         //
1344         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1345         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1346         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1347         // these malleable signatures as well.
1348         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1349             return (address(0), RecoverError.InvalidSignatureS);
1350         }
1351         if (v != 27 && v != 28) {
1352             return (address(0), RecoverError.InvalidSignatureV);
1353         }
1354 
1355         // If the signature is valid (and not malleable), return the signer address
1356         address signer = ecrecover(hash, v, r, s);
1357         if (signer == address(0)) {
1358             return (address(0), RecoverError.InvalidSignature);
1359         }
1360 
1361         return (signer, RecoverError.NoError);
1362     }
1363 
1364     /**
1365      * @dev Overload of {ECDSA-recover} that receives the `v`,
1366      * `r` and `s` signature fields separately.
1367      */
1368     function recover(
1369         bytes32 hash,
1370         uint8 v,
1371         bytes32 r,
1372         bytes32 s
1373     ) internal pure returns (address) {
1374         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1375         _throwError(error);
1376         return recovered;
1377     }
1378 
1379     /**
1380      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1381      * produces hash corresponding to the one signed with the
1382      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1383      * JSON-RPC method as part of EIP-191.
1384      *
1385      * See {recover}.
1386      */
1387     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1388         // 32 is the length in bytes of hash,
1389         // enforced by the type signature above
1390         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1391     }
1392 
1393     /**
1394      * @dev Returns an Ethereum Signed Message, created from `s`. This
1395      * produces hash corresponding to the one signed with the
1396      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1397      * JSON-RPC method as part of EIP-191.
1398      *
1399      * See {recover}.
1400      */
1401     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1402         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1403     }
1404 
1405     /**
1406      * @dev Returns an Ethereum Signed Typed Data, created from a
1407      * `domainSeparator` and a `structHash`. This produces hash corresponding
1408      * to the one signed with the
1409      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1410      * JSON-RPC method as part of EIP-712.
1411      *
1412      * See {recover}.
1413      */
1414     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1415         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1416     }
1417 }
1418 abstract contract EIP712 {
1419     /* solhint-disable var-name-mixedcase */
1420     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1421     // invalidate the cached domain separator if the chain id changes.
1422     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1423     uint256 private immutable _CACHED_CHAIN_ID;
1424     address private immutable _CACHED_THIS;
1425 
1426     bytes32 private immutable _HASHED_NAME;
1427     bytes32 private immutable _HASHED_VERSION;
1428     bytes32 private immutable _TYPE_HASH;
1429 
1430     /* solhint-enable var-name-mixedcase */
1431 
1432     /**
1433      * @dev Initializes the domain separator and parameter caches.
1434      *
1435      * The meaning of `name` and `version` is specified in
1436      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1437      *
1438      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1439      * - `version`: the current major version of the signing domain.
1440      *
1441      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1442      * contract upgrade].
1443      */
1444     constructor(string memory name, string memory version) {
1445         bytes32 hashedName = keccak256(bytes(name));
1446         bytes32 hashedVersion = keccak256(bytes(version));
1447         bytes32 typeHash = keccak256(
1448             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1449         );
1450         _HASHED_NAME = hashedName;
1451         _HASHED_VERSION = hashedVersion;
1452         _CACHED_CHAIN_ID = block.chainid;
1453         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1454         _CACHED_THIS = address(this);
1455         _TYPE_HASH = typeHash;
1456     }
1457 
1458     /**
1459      * @dev Returns the domain separator for the current chain.
1460      */
1461     function _domainSeparatorV4() internal view returns (bytes32) {
1462         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1463             return _CACHED_DOMAIN_SEPARATOR;
1464         } else {
1465             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1466         }
1467     }
1468 
1469     function _buildDomainSeparator(
1470         bytes32 typeHash,
1471         bytes32 nameHash,
1472         bytes32 versionHash
1473     ) private view returns (bytes32) {
1474         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1475     }
1476 
1477     /**
1478      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1479      * function returns the hash of the fully encoded EIP712 message for this domain.
1480      *
1481      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1482      *
1483      * ```solidity
1484      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1485      *     keccak256("Mail(address to,string contents)"),
1486      *     mailTo,
1487      *     keccak256(bytes(mailContents))
1488      * )));
1489      * address signer = ECDSA.recover(digest, signature);
1490      * ```
1491      */
1492     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1493         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1494     }
1495 }
1496 
1497 contract AIALIENBYGENIE is Ownable, ERC721A {
1498 
1499     uint256 public adoptionLimit =2;
1500     using Strings for uint256;
1501 
1502     mapping(uint256 => string) private _tokenURIs;
1503     bool public publicSaleOpen = false;
1504     string public baseURI = "ipfs://QmYXyQUNaw6jBp7TxgrQ51mBgr6VcFaQSJPVHYm3TT44HG/";
1505     string public _extension = ".json";
1506     uint256 public price = 0 ether;
1507     uint256 public maxSupply = 999;
1508 
1509     constructor() ERC721A("AI ALIEN BY GENIE", "AABG"){}
1510     
1511     function mintNFT(uint256 _quantity) public payable {
1512         require(_quantity > 0 && _quantity <= adoptionLimit, "Wrong Quantity.");
1513         require(totalSupply() + _quantity <= maxSupply, "Reaching max supply");
1514         require(msg.value == price * _quantity, "Needs to send more eth");
1515         require(getMintedCount(msg.sender) + _quantity <= adoptionLimit, "Exceed max minting amount");
1516         require(publicSaleOpen, "Public Sale Not Started Yet!");
1517 
1518         _safeMint(msg.sender, _quantity);
1519 
1520     }
1521 
1522 
1523     function sendGifts(address[] memory _wallets) external onlyOwner{
1524         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
1525         for(uint i = 0; i < _wallets.length; i++)
1526             _safeMint(_wallets[i], 1);
1527 
1528     }
1529    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
1530                require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
1531             _safeMint(_wallet, _num);
1532     }
1533 
1534 
1535     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1536         require(
1537             _exists(_tokenId),
1538             "ERC721Metadata: URI set of nonexistent token"
1539         );
1540 
1541         return string(abi.encodePacked(baseURI, _tokenId.toString(), _extension));
1542     }
1543 
1544     function updateBaseURI(string memory _newBaseURI) onlyOwner public {
1545         baseURI = _newBaseURI;
1546     }
1547     function updateExtension(string memory _temp) onlyOwner public {
1548         _extension = _temp;
1549     }
1550 
1551     function getBaseURI() external view returns(string memory) {
1552         return baseURI;
1553     }
1554 
1555     function setPrice(uint256 _price) public onlyOwner() {
1556         price = _price;
1557     }
1558     function setAdoptionlimits(uint256 _adoptionLimit) public onlyOwner() {
1559         adoptionLimit = _adoptionLimit;
1560     }
1561 
1562     function setmaxSupply(uint256 _supply) public onlyOwner() {
1563         maxSupply = _supply;
1564     }
1565 
1566     function toggleSale() public onlyOwner() {
1567         publicSaleOpen = !publicSaleOpen;
1568     }
1569 
1570 
1571     function getBalance() public view returns(uint) {
1572         return address(this).balance;
1573     }
1574 
1575     function getMintedCount(address owner) public view returns (uint256) {
1576     return _numberMinted(owner);
1577   }
1578 
1579     function withdraw() external onlyOwner {
1580         uint _balance = address(this).balance;
1581         payable(owner()).transfer(_balance); //Owner
1582     }
1583 
1584     function getOwnershipData(uint256 tokenId)
1585     external
1586     view
1587     returns (TokenOwnership memory)
1588   {
1589     return ownershipOf(tokenId);
1590   }
1591 
1592     receive() external payable {}
1593 
1594 }