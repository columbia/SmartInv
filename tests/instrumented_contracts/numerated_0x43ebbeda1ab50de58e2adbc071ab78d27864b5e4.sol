1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 //AIBoredApe ERC721A CONTRACT
5 //First 1000 is free, remaining 4000 at 0.005
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
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev String operations.
30  */
31 library Strings {
32     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
33 
34     /**
35      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
36      */
37     function toString(uint256 value) internal pure returns (string memory) {
38         // Inspired by OraclizeAPI's implementation - MIT licence
39         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
40 
41         if (value == 0) {
42             return "0";
43         }
44         uint256 temp = value;
45         uint256 digits;
46         while (temp != 0) {
47             digits++;
48             temp /= 10;
49         }
50         bytes memory buffer = new bytes(digits);
51         while (value != 0) {
52             digits -= 1;
53             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
54             value /= 10;
55         }
56         return string(buffer);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
61      */
62     function toHexString(uint256 value) internal pure returns (string memory) {
63         if (value == 0) {
64             return "0x00";
65         }
66         uint256 temp = value;
67         uint256 length = 0;
68         while (temp != 0) {
69             length++;
70             temp >>= 8;
71         }
72         return toHexString(value, length);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
77      */
78     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
79         bytes memory buffer = new bytes(2 * length + 2);
80         buffer[0] = "0";
81         buffer[1] = "x";
82         for (uint256 i = 2 * length + 1; i > 1; --i) {
83             buffer[i] = _HEX_SYMBOLS[value & 0xf];
84             value >>= 4;
85         }
86         require(value == 0, "Strings: hex length insufficient");
87         return string(buffer);
88     }
89 }
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // This method relies on extcodesize, which returns 0 for contracts in
115         // construction, since the code is only stored at the end of the
116         // constructor execution.
117 
118         uint256 size;
119         assembly {
120             size := extcodesize(account)
121         }
122         return size > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Interface of the ERC165 standard, as defined in the
308  * https://eips.ethereum.org/EIPS/eip-165[EIP].
309  *
310  * Implementers can declare support of contract interfaces, which can then be
311  * queried by others ({ERC165Checker}).
312  *
313  * For an implementation, see {ERC165}.
314  */
315 interface IERC165 {
316     /**
317      * @dev Returns true if this contract implements the interface defined by
318      * `interfaceId`. See the corresponding
319      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
320      * to learn more about how these ids are created.
321      *
322      * This function call must use less than 30 000 gas.
323      */
324     function supportsInterface(bytes4 interfaceId) external view returns (bool);
325 }
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @title ERC721 token receiver interface
330  * @dev Interface for any contract that wants to support safeTransfers
331  * from ERC721 asset contracts.
332  */
333 interface IERC721Receiver {
334     /**
335      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
336      * by `operator` from `from`, this function is called.
337      *
338      * It must return its Solidity selector to confirm the token transfer.
339      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
340      *
341      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
342      */
343     function onERC721Received(
344         address operator,
345         address from,
346         uint256 tokenId,
347         bytes calldata data
348     ) external returns (bytes4);
349 }
350 pragma solidity ^0.8.0;
351 
352 
353 /**
354  * @dev Contract module which provides a basic access control mechanism, where
355  * there is an account (an owner) that can be granted exclusive access to
356  * specific functions.
357  *
358  * By default, the owner account will be the one that deploys the contract. This
359  * can later be changed with {transferOwnership}.
360  *
361  * This module is used through inheritance. It will make available the modifier
362  * `onlyOwner`, which can be applied to your functions to restrict their use to
363  * the owner.
364  */
365 abstract contract Ownable is Context {
366     address private _owner;
367 
368     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
369 
370     /**
371      * @dev Initializes the contract setting the deployer as the initial owner.
372      */
373     constructor() {
374         _setOwner(_msgSender());
375     }
376 
377     /**
378      * @dev Returns the address of the current owner.
379      */
380     function owner() public view virtual returns (address) {
381         return _owner;
382     }
383 
384     /**
385      * @dev Throws if called by any account other than the owner.
386      */
387     modifier onlyOwner() {
388         require(owner() == _msgSender(), "Ownable: caller is not the owner");
389         _;
390     }
391 
392     /**
393      * @dev Leaves the contract without owner. It will not be possible to call
394      * `onlyOwner` functions anymore. Can only be called by the current owner.
395      *
396      * NOTE: Renouncing ownership will leave the contract without an owner,
397      * thereby removing any functionality that is only available to the owner.
398      */
399     function renounceOwnership() public virtual onlyOwner {
400         _setOwner(address(0));
401     }
402 
403     /**
404      * @dev Transfers ownership of the contract to a new account (`newOwner`).
405      * Can only be called by the current owner.
406      */
407     function transferOwnership(address newOwner) public virtual onlyOwner {
408         require(newOwner != address(0), "Ownable: new owner is the zero address");
409         _setOwner(newOwner);
410     }
411 
412     function _setOwner(address newOwner) private {
413         address oldOwner = _owner;
414         _owner = newOwner;
415         emit OwnershipTransferred(oldOwner, newOwner);
416     }
417 }
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Implementation of the {IERC165} interface.
423  *
424  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
425  * for the additional interface id that will be supported. For example:
426  *
427  * ```solidity
428  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
429  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
430  * }
431  * ```
432  *
433  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
434  */
435 abstract contract ERC165 is IERC165 {
436     /**
437      * @dev See {IERC165-supportsInterface}.
438      */
439     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
440         return interfaceId == type(IERC165).interfaceId;
441     }
442 }
443 pragma solidity ^0.8.0;
444 
445 
446 /**
447  * @dev Required interface of an ERC721 compliant contract.
448  */
449 interface IERC721 is IERC165 {
450     /**
451      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
452      */
453     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
454 
455     /**
456      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
457      */
458     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
459 
460     /**
461      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
462      */
463     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
464 
465     /**
466      * @dev Returns the number of tokens in ``owner``'s account.
467      */
468     function balanceOf(address owner) external view returns (uint256 balance);
469 
470     /**
471      * @dev Returns the owner of the `tokenId` token.
472      *
473      * Requirements:
474      *
475      * - `tokenId` must exist.
476      */
477     function ownerOf(uint256 tokenId) external view returns (address owner);
478 
479     /**
480      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
481      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
482      *
483      * Requirements:
484      *
485      * - `from` cannot be the zero address.
486      * - `to` cannot be the zero address.
487      * - `tokenId` token must exist and be owned by `from`.
488      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
489      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
490      *
491      * Emits a {Transfer} event.
492      */
493     function safeTransferFrom(
494         address from,
495         address to,
496         uint256 tokenId
497     ) external;
498 
499     /**
500      * @dev Transfers `tokenId` token from `from` to `to`.
501      *
502      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
503      *
504      * Requirements:
505      *
506      * - `from` cannot be the zero address.
507      * - `to` cannot be the zero address.
508      * - `tokenId` token must be owned by `from`.
509      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
510      *
511      * Emits a {Transfer} event.
512      */
513     function transferFrom(
514         address from,
515         address to,
516         uint256 tokenId
517     ) external;
518 
519     /**
520      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
521      * The approval is cleared when the token is transferred.
522      *
523      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
524      *
525      * Requirements:
526      *
527      * - The caller must own the token or be an approved operator.
528      * - `tokenId` must exist.
529      *
530      * Emits an {Approval} event.
531      */
532     function approve(address to, uint256 tokenId) external;
533 
534     /**
535      * @dev Returns the account approved for `tokenId` token.
536      *
537      * Requirements:
538      *
539      * - `tokenId` must exist.
540      */
541     function getApproved(uint256 tokenId) external view returns (address operator);
542 
543     /**
544      * @dev Approve or remove `operator` as an operator for the caller.
545      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
546      *
547      * Requirements:
548      *
549      * - The `operator` cannot be the caller.
550      *
551      * Emits an {ApprovalForAll} event.
552      */
553     function setApprovalForAll(address operator, bool _approved) external;
554 
555     /**
556      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
557      *
558      * See {setApprovalForAll}
559      */
560     function isApprovedForAll(address owner, address operator) external view returns (bool);
561 
562     /**
563      * @dev Safely transfers `tokenId` token from `from` to `to`.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must exist and be owned by `from`.
570      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId,
579         bytes calldata data
580     ) external;
581 }
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
587  * @dev See https://eips.ethereum.org/EIPS/eip-721
588  */
589 interface IERC721Metadata is IERC721 {
590     /**
591      * @dev Returns the token collection name.
592      */
593     function name() external view returns (string memory);
594 
595     /**
596      * @dev Returns the token collection symbol.
597      */
598     function symbol() external view returns (string memory);
599 
600     /**
601      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
602      */
603     function tokenURI(uint256 tokenId) external view returns (string memory);
604 }
605 interface IERC721Enumerable is IERC721 {
606     /**
607      * @dev Returns the total amount of tokens stored by the contract.
608      */
609     function totalSupply() external view returns (uint256);
610 
611     /**
612      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
613      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
614      */
615     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
616 
617     /**
618      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
619      * Use along with {totalSupply} to enumerate all tokens.
620      */
621     function tokenByIndex(uint256 index) external view returns (uint256);
622 }
623 error ApprovalCallerNotOwnerNorApproved();
624 error ApprovalQueryForNonexistentToken();
625 error ApproveToCaller();
626 error ApprovalToCurrentOwner();
627 error BalanceQueryForZeroAddress();
628 error MintedQueryForZeroAddress();
629 error BurnedQueryForZeroAddress();
630 error AuxQueryForZeroAddress();
631 error MintToZeroAddress();
632 error MintZeroQuantity();
633 error OwnerIndexOutOfBounds();
634 error OwnerQueryForNonexistentToken();
635 error TokenIndexOutOfBounds();
636 error TransferCallerNotOwnerNorApproved();
637 error TransferFromIncorrectOwner();
638 error TransferToNonERC721ReceiverImplementer();
639 error TransferToZeroAddress();
640 error URIQueryForNonexistentToken();
641 
642 /**
643  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
644  * the Metadata extension. Built to optimize for lower gas during batch mints.
645  *
646  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
647  *
648  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
649  *
650  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
651  */
652 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
653     using Address for address;
654     using Strings for uint256;
655 
656     // Compiler will pack this into a single 256bit word.
657     struct TokenOwnership {
658         // The address of the owner.
659         address addr;
660         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
661         uint64 startTimestamp;
662         // Whether the token has been burned.
663         bool burned;
664     }
665 
666     // Compiler will pack this into a single 256bit word.
667     struct AddressData {
668         // Realistically, 2**64-1 is more than enough.
669         uint64 balance;
670         // Keeps track of mint count with minimal overhead for tokenomics.
671         uint64 numberMinted;
672         // Keeps track of burn count with minimal overhead for tokenomics.
673         uint64 numberBurned;
674         // For miscellaneous variable(s) pertaining to the address
675         // (e.g. number of whitelist mint slots used). 
676         // If there are multiple variables, please pack them into a uint64.
677         uint64 aux;
678     }
679 
680     // The tokenId of the next token to be minted.
681     uint256 internal _currentIndex = 1;
682 
683     // The number of tokens burned.
684     uint256 internal _burnCounter;
685 
686     // Token name
687     string private _name;
688 
689     // Token symbol
690     string private _symbol;
691 
692     // Mapping from token ID to ownership details
693     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
694     mapping(uint256 => TokenOwnership) internal _ownerships;
695 
696     // Mapping owner address to address data
697     mapping(address => AddressData) private _addressData;
698 
699     // Mapping from token ID to approved address
700     mapping(uint256 => address) private _tokenApprovals;
701 
702     // Mapping from owner to operator approvals
703     mapping(address => mapping(address => bool)) private _operatorApprovals;
704 
705     constructor(string memory name_, string memory symbol_) {
706         _name = name_;
707         _symbol = symbol_;
708     }
709 
710     /**
711      * @dev See {IERC721Enumerable-totalSupply}.
712      */
713     function totalSupply() public view returns (uint256) {
714         // Counter underflow is impossible as _burnCounter cannot be incremented
715         // more than _currentIndex times
716         unchecked {
717             return (_currentIndex - _burnCounter) - 1;    
718         }
719     }
720 
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
725         return
726             interfaceId == type(IERC721).interfaceId ||
727             interfaceId == type(IERC721Metadata).interfaceId ||
728             super.supportsInterface(interfaceId);
729     }
730 
731     /**
732      * @dev See {IERC721-balanceOf}.
733      */
734     function balanceOf(address owner) public view override returns (uint256) {
735         if (owner == address(0)) revert BalanceQueryForZeroAddress();
736         return uint256(_addressData[owner].balance);
737     }
738 
739     /**
740      * Returns the number of tokens minted by `owner`.
741      */
742     function _numberMinted(address owner) internal view returns (uint256) {
743         if (owner == address(0)) revert MintedQueryForZeroAddress();
744         return uint256(_addressData[owner].numberMinted);
745     }
746 
747     /**
748      * Returns the number of tokens burned by or on behalf of `owner`.
749      */
750     function _numberBurned(address owner) internal view returns (uint256) {
751         if (owner == address(0)) revert BurnedQueryForZeroAddress();
752         return uint256(_addressData[owner].numberBurned);
753     }
754 
755     /**
756      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
757      */
758     function _getAux(address owner) internal view returns (uint64) {
759         if (owner == address(0)) revert AuxQueryForZeroAddress();
760         return _addressData[owner].aux;
761     }
762 
763     /**
764      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
765      * If there are multiple variables, please pack them into a uint64.
766      */
767     function _setAux(address owner, uint64 aux) internal {
768         if (owner == address(0)) revert AuxQueryForZeroAddress();
769         _addressData[owner].aux = aux;
770     }
771 
772     /**
773      * Gas spent here starts off proportional to the maximum mint batch size.
774      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
775      */
776     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
777         uint256 curr = tokenId;
778 
779         unchecked {
780             if (curr < _currentIndex) {
781                 TokenOwnership memory ownership = _ownerships[curr];
782                 if (!ownership.burned) {
783                     if (ownership.addr != address(0)) {
784                         return ownership;
785                     }
786                     // Invariant: 
787                     // There will always be an ownership that has an address and is not burned 
788                     // before an ownership that does not have an address and is not burned.
789                     // Hence, curr will not underflow.
790                     while (true) {
791                         curr--;
792                         ownership = _ownerships[curr];
793                         if (ownership.addr != address(0)) {
794                             return ownership;
795                         }
796                     }
797                 }
798             }
799         }
800         revert OwnerQueryForNonexistentToken();
801     }
802 
803     /**
804      * @dev See {IERC721-ownerOf}.
805      */
806     function ownerOf(uint256 tokenId) public view override returns (address) {
807         return ownershipOf(tokenId).addr;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-name}.
812      */
813     function name() public view virtual override returns (string memory) {
814         return _name;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-symbol}.
819      */
820     function symbol() public view virtual override returns (string memory) {
821         return _symbol;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-tokenURI}.
826      */
827     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
828         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
829 
830         string memory baseURI = _baseURI();
831         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
832     }
833 
834     /**
835      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
836      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
837      * by default, can be overriden in child contracts.
838      */
839     function _baseURI() internal view virtual returns (string memory) {
840         return '';
841     }
842 
843     /**
844      * @dev See {IERC721-approve}.
845      */
846     function approve(address to, uint256 tokenId) public override {
847         address owner = ERC721A.ownerOf(tokenId);
848         if (to == owner) revert ApprovalToCurrentOwner();
849 
850         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
851             revert ApprovalCallerNotOwnerNorApproved();
852         }
853 
854         _approve(to, tokenId, owner);
855     }
856 
857     /**
858      * @dev See {IERC721-getApproved}.
859      */
860     function getApproved(uint256 tokenId) public view override returns (address) {
861         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
862 
863         return _tokenApprovals[tokenId];
864     }
865 
866     /**
867      * @dev See {IERC721-setApprovalForAll}.
868      */
869     function setApprovalForAll(address operator, bool approved) public override {
870         if (operator == _msgSender()) revert ApproveToCaller();
871 
872         _operatorApprovals[_msgSender()][operator] = approved;
873         emit ApprovalForAll(_msgSender(), operator, approved);
874     }
875 
876     /**
877      * @dev See {IERC721-isApprovedForAll}.
878      */
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882 
883     /**
884      * @dev See {IERC721-transferFrom}.
885      */
886     function transferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         _transfer(from, to, tokenId);
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         safeTransferFrom(from, to, tokenId, '');
903     }
904 
905     /**
906      * @dev See {IERC721-safeTransferFrom}.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) public virtual override {
914         _transfer(from, to, tokenId);
915         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
916             revert TransferToNonERC721ReceiverImplementer();
917         }
918     }
919 
920     /**
921      * @dev Returns whether `tokenId` exists.
922      *
923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
924      *
925      * Tokens start existing when they are minted (`_mint`),
926      */
927     function _exists(uint256 tokenId) internal view returns (bool) {
928         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
929     }
930 
931     function _safeMint(address to, uint256 quantity) internal {
932         _safeMint(to, quantity, '');
933     }
934 
935     /**
936      * @dev Safely mints `quantity` tokens and transfers them to `to`.
937      *
938      * Requirements:
939      *
940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
941      * - `quantity` must be greater than 0.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeMint(
946         address to,
947         uint256 quantity,
948         bytes memory _data
949     ) internal {
950         _mint(to, quantity, _data, true);
951     }
952 
953     /**
954      * @dev Mints `quantity` tokens and transfers them to `to`.
955      *
956      * Requirements:
957      *
958      * - `to` cannot be the zero address.
959      * - `quantity` must be greater than 0.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _mint(
964         address to,
965         uint256 quantity,
966         bytes memory _data,
967         bool safe
968     ) internal {
969         uint256 startTokenId = _currentIndex;
970         if (to == address(0)) revert MintToZeroAddress();
971         if (quantity == 0) revert MintZeroQuantity();
972 
973         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
974 
975         // Overflows are incredibly unrealistic.
976         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
977         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
978         unchecked {
979             _addressData[to].balance += uint64(quantity);
980             _addressData[to].numberMinted += uint64(quantity);
981 
982             _ownerships[startTokenId].addr = to;
983             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
984 
985             uint256 updatedIndex = startTokenId;
986 
987             for (uint256 i; i < quantity; i++) {
988                 emit Transfer(address(0), to, updatedIndex);
989                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
990                     revert TransferToNonERC721ReceiverImplementer();
991                 }
992                 updatedIndex++;
993             }
994 
995             _currentIndex = updatedIndex;
996         }
997         _afterTokenTransfers(address(0), to, startTokenId, quantity);
998     }
999 
1000     /**
1001      * @dev Transfers `tokenId` from `from` to `to`.
1002      *
1003      * Requirements:
1004      *
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must be owned by `from`.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _transfer(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) private {
1015         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1016 
1017         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1018             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1019             getApproved(tokenId) == _msgSender());
1020 
1021         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1022         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1023         if (to == address(0)) revert TransferToZeroAddress();
1024 
1025         _beforeTokenTransfers(from, to, tokenId, 1);
1026 
1027         // Clear approvals from the previous owner
1028         _approve(address(0), tokenId, prevOwnership.addr);
1029 
1030         // Underflow of the sender's balance is impossible because we check for
1031         // ownership above and the recipient's balance can't realistically overflow.
1032         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1033         unchecked {
1034             _addressData[from].balance -= 1;
1035             _addressData[to].balance += 1;
1036 
1037             _ownerships[tokenId].addr = to;
1038             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1039 
1040             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1041             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1042             uint256 nextTokenId = tokenId + 1;
1043             if (_ownerships[nextTokenId].addr == address(0)) {
1044                 // This will suffice for checking _exists(nextTokenId),
1045                 // as a burned slot cannot contain the zero address.
1046                 if (nextTokenId < _currentIndex) {
1047                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1048                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1049                 }
1050             }
1051         }
1052 
1053         emit Transfer(from, to, tokenId);
1054         _afterTokenTransfers(from, to, tokenId, 1);
1055     }
1056 
1057     /**
1058      * @dev Destroys `tokenId`.
1059      * The approval is cleared when the token is burned.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _burn(uint256 tokenId) internal virtual {
1068         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1069 
1070         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1071 
1072         // Clear approvals from the previous owner
1073         _approve(address(0), tokenId, prevOwnership.addr);
1074 
1075         // Underflow of the sender's balance is impossible because we check for
1076         // ownership above and the recipient's balance can't realistically overflow.
1077         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1078         unchecked {
1079             _addressData[prevOwnership.addr].balance -= 1;
1080             _addressData[prevOwnership.addr].numberBurned += 1;
1081 
1082             // Keep track of who burned the token, and the timestamp of burning.
1083             _ownerships[tokenId].addr = prevOwnership.addr;
1084             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1085             _ownerships[tokenId].burned = true;
1086 
1087             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1088             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1089             uint256 nextTokenId = tokenId + 1;
1090             if (_ownerships[nextTokenId].addr == address(0)) {
1091                 // This will suffice for checking _exists(nextTokenId),
1092                 // as a burned slot cannot contain the zero address.
1093                 if (nextTokenId < _currentIndex) {
1094                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1095                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1096                 }
1097             }
1098         }
1099 
1100         emit Transfer(prevOwnership.addr, address(0), tokenId);
1101         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1102 
1103         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1104         unchecked { 
1105             _burnCounter++;
1106         }
1107     }
1108 
1109     /**
1110      * @dev Approve `to` to operate on `tokenId`
1111      *
1112      * Emits a {Approval} event.
1113      */
1114     function _approve(
1115         address to,
1116         uint256 tokenId,
1117         address owner
1118     ) private {
1119         _tokenApprovals[tokenId] = to;
1120         emit Approval(owner, to, tokenId);
1121     }
1122 
1123     /**
1124      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1125      * The call is not executed if the target address is not a contract.
1126      *
1127      * @param from address representing the previous owner of the given token ID
1128      * @param to target address that will receive the tokens
1129      * @param tokenId uint256 ID of the token to be transferred
1130      * @param _data bytes optional data to send along with the call
1131      * @return bool whether the call correctly returned the expected magic value
1132      */
1133     function _checkOnERC721Received(
1134         address from,
1135         address to,
1136         uint256 tokenId,
1137         bytes memory _data
1138     ) private returns (bool) {
1139         if (to.isContract()) {
1140             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1141                 return retval == IERC721Receiver(to).onERC721Received.selector;
1142             } catch (bytes memory reason) {
1143                 if (reason.length == 0) {
1144                     revert TransferToNonERC721ReceiverImplementer();
1145                 } else {
1146                     assembly {
1147                         revert(add(32, reason), mload(reason))
1148                     }
1149                 }
1150             }
1151         } else {
1152             return true;
1153         }
1154     }
1155 
1156     /**
1157      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1158      * And also called before burning one token.
1159      *
1160      * startTokenId - the first token id to be transferred
1161      * quantity - the amount to be transferred
1162      *
1163      * Calling conditions:
1164      *
1165      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1166      * transferred to `to`.
1167      * - When `from` is zero, `tokenId` will be minted for `to`.
1168      * - When `to` is zero, `tokenId` will be burned by `from`.
1169      * - `from` and `to` are never both zero.
1170      */
1171     function _beforeTokenTransfers(
1172         address from,
1173         address to,
1174         uint256 startTokenId,
1175         uint256 quantity
1176     ) internal virtual {}
1177 
1178     /**
1179      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1180      * minting.
1181      * And also called after one token has been burned.
1182      *
1183      * startTokenId - the first token id to be transferred
1184      * quantity - the amount to be transferred
1185      *
1186      * Calling conditions:
1187      *
1188      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1189      * transferred to `to`.
1190      * - When `from` is zero, `tokenId` has been minted for `to`.
1191      * - When `to` is zero, `tokenId` has been burned by `from`.
1192      * - `from` and `to` are never both zero.
1193      */
1194     function _afterTokenTransfers(
1195         address from,
1196         address to,
1197         uint256 startTokenId,
1198         uint256 quantity
1199     ) internal virtual {}
1200 }
1201 
1202 library ECDSA {
1203     enum RecoverError {
1204         NoError,
1205         InvalidSignature,
1206         InvalidSignatureLength,
1207         InvalidSignatureS,
1208         InvalidSignatureV
1209     }
1210 
1211     function _throwError(RecoverError error) private pure {
1212         if (error == RecoverError.NoError) {
1213             return; // no error: do nothing
1214         } else if (error == RecoverError.InvalidSignature) {
1215             revert("ECDSA: invalid signature");
1216         } else if (error == RecoverError.InvalidSignatureLength) {
1217             revert("ECDSA: invalid signature length");
1218         } else if (error == RecoverError.InvalidSignatureS) {
1219             revert("ECDSA: invalid signature 's' value");
1220         } else if (error == RecoverError.InvalidSignatureV) {
1221             revert("ECDSA: invalid signature 'v' value");
1222         }
1223     }
1224 
1225     /**
1226      * @dev Returns the address that signed a hashed message (`hash`) with
1227      * `signature` or error string. This address can then be used for verification purposes.
1228      *
1229      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1230      * this function rejects them by requiring the `s` value to be in the lower
1231      * half order, and the `v` value to be either 27 or 28.
1232      *
1233      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1234      * verification to be secure: it is possible to craft signatures that
1235      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1236      * this is by receiving a hash of the original message (which may otherwise
1237      * be too long), and then calling {toEthSignedMessageHash} on it.
1238      *
1239      * Documentation for signature generation:
1240      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1241      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1242      *
1243      * _Available since v4.3._
1244      */
1245     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1246         // Check the signature length
1247         // - case 65: r,s,v signature (standard)
1248         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1249         if (signature.length == 65) {
1250             bytes32 r;
1251             bytes32 s;
1252             uint8 v;
1253             // ecrecover takes the signature parameters, and the only way to get them
1254             // currently is to use assembly.
1255             assembly {
1256                 r := mload(add(signature, 0x20))
1257                 s := mload(add(signature, 0x40))
1258                 v := byte(0, mload(add(signature, 0x60)))
1259             }
1260             return tryRecover(hash, v, r, s);
1261         } else if (signature.length == 64) {
1262             bytes32 r;
1263             bytes32 vs;
1264             // ecrecover takes the signature parameters, and the only way to get them
1265             // currently is to use assembly.
1266             assembly {
1267                 r := mload(add(signature, 0x20))
1268                 vs := mload(add(signature, 0x40))
1269             }
1270             return tryRecover(hash, r, vs);
1271         } else {
1272             return (address(0), RecoverError.InvalidSignatureLength);
1273         }
1274     }
1275 
1276     /**
1277      * @dev Returns the address that signed a hashed message (`hash`) with
1278      * `signature`. This address can then be used for verification purposes.
1279      *
1280      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1281      * this function rejects them by requiring the `s` value to be in the lower
1282      * half order, and the `v` value to be either 27 or 28.
1283      *
1284      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1285      * verification to be secure: it is possible to craft signatures that
1286      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1287      * this is by receiving a hash of the original message (which may otherwise
1288      * be too long), and then calling {toEthSignedMessageHash} on it.
1289      */
1290     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1291         (address recovered, RecoverError error) = tryRecover(hash, signature);
1292         _throwError(error);
1293         return recovered;
1294     }
1295 
1296     /**
1297      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1298      *
1299      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1300      *
1301      * _Available since v4.3._
1302      */
1303     function tryRecover(
1304         bytes32 hash,
1305         bytes32 r,
1306         bytes32 vs
1307     ) internal pure returns (address, RecoverError) {
1308         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1309         uint8 v = uint8((uint256(vs) >> 255) + 27);
1310         return tryRecover(hash, v, r, s);
1311     }
1312 
1313     /**
1314      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1315      *
1316      * _Available since v4.2._
1317      */
1318     function recover(
1319         bytes32 hash,
1320         bytes32 r,
1321         bytes32 vs
1322     ) internal pure returns (address) {
1323         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1324         _throwError(error);
1325         return recovered;
1326     }
1327 
1328     /**
1329      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1330      * `r` and `s` signature fields separately.
1331      *
1332      * _Available since v4.3._
1333      */
1334     function tryRecover(
1335         bytes32 hash,
1336         uint8 v,
1337         bytes32 r,
1338         bytes32 s
1339     ) internal pure returns (address, RecoverError) {
1340         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1341         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1342         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1343         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1344         //
1345         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1346         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1347         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1348         // these malleable signatures as well.
1349         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1350             return (address(0), RecoverError.InvalidSignatureS);
1351         }
1352         if (v != 27 && v != 28) {
1353             return (address(0), RecoverError.InvalidSignatureV);
1354         }
1355 
1356         // If the signature is valid (and not malleable), return the signer address
1357         address signer = ecrecover(hash, v, r, s);
1358         if (signer == address(0)) {
1359             return (address(0), RecoverError.InvalidSignature);
1360         }
1361 
1362         return (signer, RecoverError.NoError);
1363     }
1364 
1365     /**
1366      * @dev Overload of {ECDSA-recover} that receives the `v`,
1367      * `r` and `s` signature fields separately.
1368      */
1369     function recover(
1370         bytes32 hash,
1371         uint8 v,
1372         bytes32 r,
1373         bytes32 s
1374     ) internal pure returns (address) {
1375         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1376         _throwError(error);
1377         return recovered;
1378     }
1379 
1380     /**
1381      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1382      * produces hash corresponding to the one signed with the
1383      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1384      * JSON-RPC method as part of EIP-191.
1385      *
1386      * See {recover}.
1387      */
1388     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1389         // 32 is the length in bytes of hash,
1390         // enforced by the type signature above
1391         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1392     }
1393 
1394     /**
1395      * @dev Returns an Ethereum Signed Message, created from `s`. This
1396      * produces hash corresponding to the one signed with the
1397      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1398      * JSON-RPC method as part of EIP-191.
1399      *
1400      * See {recover}.
1401      */
1402     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1403         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1404     }
1405 
1406     /**
1407      * @dev Returns an Ethereum Signed Typed Data, created from a
1408      * `domainSeparator` and a `structHash`. This produces hash corresponding
1409      * to the one signed with the
1410      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1411      * JSON-RPC method as part of EIP-712.
1412      *
1413      * See {recover}.
1414      */
1415     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1416         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1417     }
1418 }
1419 abstract contract EIP712 {
1420     /* solhint-disable var-name-mixedcase */
1421     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1422     // invalidate the cached domain separator if the chain id changes.
1423     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1424     uint256 private immutable _CACHED_CHAIN_ID;
1425     address private immutable _CACHED_THIS;
1426 
1427     bytes32 private immutable _HASHED_NAME;
1428     bytes32 private immutable _HASHED_VERSION;
1429     bytes32 private immutable _TYPE_HASH;
1430 
1431     /* solhint-enable var-name-mixedcase */
1432 
1433     /**
1434      * @dev Initializes the domain separator and parameter caches.
1435      *
1436      * The meaning of `name` and `version` is specified in
1437      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1438      *
1439      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1440      * - `version`: the current major version of the signing domain.
1441      *
1442      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1443      * contract upgrade].
1444      */
1445     constructor(string memory name, string memory version) {
1446         bytes32 hashedName = keccak256(bytes(name));
1447         bytes32 hashedVersion = keccak256(bytes(version));
1448         bytes32 typeHash = keccak256(
1449             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1450         );
1451         _HASHED_NAME = hashedName;
1452         _HASHED_VERSION = hashedVersion;
1453         _CACHED_CHAIN_ID = block.chainid;
1454         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1455         _CACHED_THIS = address(this);
1456         _TYPE_HASH = typeHash;
1457     }
1458 
1459     /**
1460      * @dev Returns the domain separator for the current chain.
1461      */
1462     function _domainSeparatorV4() internal view returns (bytes32) {
1463         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1464             return _CACHED_DOMAIN_SEPARATOR;
1465         } else {
1466             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1467         }
1468     }
1469 
1470     function _buildDomainSeparator(
1471         bytes32 typeHash,
1472         bytes32 nameHash,
1473         bytes32 versionHash
1474     ) private view returns (bytes32) {
1475         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1476     }
1477 
1478     /**
1479      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1480      * function returns the hash of the fully encoded EIP712 message for this domain.
1481      *
1482      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1483      *
1484      * ```solidity
1485      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1486      *     keccak256("Mail(address to,string contents)"),
1487      *     mailTo,
1488      *     keccak256(bytes(mailContents))
1489      * )));
1490      * address signer = ECDSA.recover(digest, signature);
1491      * ```
1492      */
1493     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1494         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1495     }
1496 }
1497 
1498 contract AIBoredApe is Ownable, ERC721A {
1499 
1500     uint256 public adoptionLimit =30;
1501     using Strings for uint256;
1502 
1503     mapping(uint256 => string) private _tokenURIs;
1504     bool public publicSaleOpen = false;
1505     string public baseURI = "ipfs://";
1506     string public _extension = ".json";
1507     uint256 public price = 0 ether;
1508     uint256 public maxSupply = 5000;
1509 
1510     constructor() ERC721A("AIBoredApe", "AIBAPE"){}
1511     
1512     function mintNFT(uint256 _quantity) public payable {
1513         require(_quantity > 0 && _quantity <= adoptionLimit, "Wrong Quantity.");
1514         require(totalSupply() + _quantity <= maxSupply, "Reaching max supply");
1515         require(msg.value == price * _quantity, "Needs to send more eth");
1516         require(getMintedCount(msg.sender) + _quantity <= adoptionLimit, "Exceed max minting amount");
1517         require(publicSaleOpen, "Public Sale Not Started Yet!");
1518 
1519         _safeMint(msg.sender, _quantity);
1520 
1521     }
1522 
1523 
1524     function sendGifts(address[] memory _wallets) external onlyOwner{
1525         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
1526         for(uint i = 0; i < _wallets.length; i++)
1527             _safeMint(_wallets[i], 1);
1528 
1529     }
1530    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
1531                require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
1532             _safeMint(_wallet, _num);
1533     }
1534 
1535 
1536     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1537         require(
1538             _exists(_tokenId),
1539             "ERC721Metadata: URI set of nonexistent token"
1540         );
1541 
1542         return string(abi.encodePacked(baseURI, _tokenId.toString(), _extension));
1543     }
1544 
1545     function updateBaseURI(string memory _newBaseURI) onlyOwner public {
1546         baseURI = _newBaseURI;
1547     }
1548     function updateExtension(string memory _temp) onlyOwner public {
1549         _extension = _temp;
1550     }
1551 
1552     function getBaseURI() external view returns(string memory) {
1553         return baseURI;
1554     }
1555 
1556     function setPrice(uint256 _price) public onlyOwner() {
1557         price = _price;
1558     }
1559     function setAdoptionlimits(uint256 _adoptionLimit) public onlyOwner() {
1560         adoptionLimit = _adoptionLimit;
1561     }
1562 
1563     function setmaxSupply(uint256 _supply) public onlyOwner() {
1564         maxSupply = _supply;
1565     }
1566 
1567     function toggleSale() public onlyOwner() {
1568         publicSaleOpen = !publicSaleOpen;
1569     }
1570 
1571 
1572     function getBalance() public view returns(uint) {
1573         return address(this).balance;
1574     }
1575 
1576     function getMintedCount(address owner) public view returns (uint256) {
1577     return _numberMinted(owner);
1578   }
1579 
1580     function withdraw() external onlyOwner {
1581         uint _balance = address(this).balance;
1582         payable(owner()).transfer(_balance); //Owner
1583     }
1584 
1585     function getOwnershipData(uint256 tokenId)
1586     external
1587     view
1588     returns (TokenOwnership memory)
1589   {
1590     return ownershipOf(tokenId);
1591   }
1592 
1593     receive() external payable {}
1594 
1595 }