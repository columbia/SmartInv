1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
77         bytes memory buffer = new bytes(2 * length + 2);
78         buffer[0] = "0";
79         buffer[1] = "x";
80         for (uint256 i = 2 * length + 1; i > 1; --i) {
81             buffer[i] = _HEX_SYMBOLS[value & 0xf];
82             value >>= 4;
83         }
84         require(value == 0, "Strings: hex length insufficient");
85         return string(buffer);
86     }
87 }
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Collection of functions related to the address type
92  */
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize, which returns 0 for contracts in
113         // construction, since the code is only stored at the end of the
114         // constructor execution.
115 
116         uint256 size;
117         assembly {
118             size := extcodesize(account)
119         }
120         return size > 0;
121     }
122 
123     /**
124      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
125      * `recipient`, forwarding all available gas and reverting on errors.
126      *
127      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
128      * of certain opcodes, possibly making contracts go over the 2300 gas limit
129      * imposed by `transfer`, making them unable to receive funds via
130      * `transfer`. {sendValue} removes this limitation.
131      *
132      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
133      *
134      * IMPORTANT: because control is transferred to `recipient`, care must be
135      * taken to not create reentrancy vulnerabilities. Consider using
136      * {ReentrancyGuard} or the
137      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
138      */
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(address(this).balance >= amount, "Address: insufficient balance");
141 
142         (bool success, ) = recipient.call{value: amount}("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain `call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.staticcall(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(isContract(target), "Address: delegate call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.delegatecall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
276      * revert reason using the provided one.
277      *
278      * _Available since v4.3._
279      */
280     function verifyCallResult(
281         bool success,
282         bytes memory returndata,
283         string memory errorMessage
284     ) internal pure returns (bytes memory) {
285         if (success) {
286             return returndata;
287         } else {
288             // Look for revert reason and bubble it up if present
289             if (returndata.length > 0) {
290                 // The easiest way to bubble the revert reason is using memory via assembly
291 
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Interface of the ERC165 standard, as defined in the
306  * https://eips.ethereum.org/EIPS/eip-165[EIP].
307  *
308  * Implementers can declare support of contract interfaces, which can then be
309  * queried by others ({ERC165Checker}).
310  *
311  * For an implementation, see {ERC165}.
312  */
313 interface IERC165 {
314     /**
315      * @dev Returns true if this contract implements the interface defined by
316      * `interfaceId`. See the corresponding
317      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
318      * to learn more about how these ids are created.
319      *
320      * This function call must use less than 30 000 gas.
321      */
322     function supportsInterface(bytes4 interfaceId) external view returns (bool);
323 }
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @title ERC721 token receiver interface
328  * @dev Interface for any contract that wants to support safeTransfers
329  * from ERC721 asset contracts.
330  */
331 interface IERC721Receiver {
332     /**
333      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
334      * by `operator` from `from`, this function is called.
335      *
336      * It must return its Solidity selector to confirm the token transfer.
337      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
338      *
339      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
340      */
341     function onERC721Received(
342         address operator,
343         address from,
344         uint256 tokenId,
345         bytes calldata data
346     ) external returns (bytes4);
347 }
348 pragma solidity ^0.8.0;
349 
350 
351 /**
352  * @dev Contract module which provides a basic access control mechanism, where
353  * there is an account (an owner) that can be granted exclusive access to
354  * specific functions.
355  *
356  * By default, the owner account will be the one that deploys the contract. This
357  * can later be changed with {transferOwnership}.
358  *
359  * This module is used through inheritance. It will make available the modifier
360  * `onlyOwner`, which can be applied to your functions to restrict their use to
361  * the owner.
362  */
363 abstract contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor() {
372         _setOwner(_msgSender());
373     }
374 
375     /**
376      * @dev Returns the address of the current owner.
377      */
378     function owner() public view virtual returns (address) {
379         return _owner;
380     }
381 
382     /**
383      * @dev Throws if called by any account other than the owner.
384      */
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     /**
391      * @dev Leaves the contract without owner. It will not be possible to call
392      * `onlyOwner` functions anymore. Can only be called by the current owner.
393      *
394      * NOTE: Renouncing ownership will leave the contract without an owner,
395      * thereby removing any functionality that is only available to the owner.
396      */
397     function renounceOwnership() public virtual onlyOwner {
398         _setOwner(address(0));
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Can only be called by the current owner.
404      */
405     function transferOwnership(address newOwner) public virtual onlyOwner {
406         require(newOwner != address(0), "Ownable: new owner is the zero address");
407         _setOwner(newOwner);
408     }
409 
410     function _setOwner(address newOwner) private {
411         address oldOwner = _owner;
412         _owner = newOwner;
413         emit OwnershipTransferred(oldOwner, newOwner);
414     }
415 }
416 pragma solidity ^0.8.0;
417 
418 
419 /**
420  * @dev Implementation of the {IERC165} interface.
421  *
422  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
423  * for the additional interface id that will be supported. For example:
424  *
425  * ```solidity
426  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
427  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
428  * }
429  * ```
430  *
431  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
432  */
433 abstract contract ERC165 is IERC165 {
434     /**
435      * @dev See {IERC165-supportsInterface}.
436      */
437     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
438         return interfaceId == type(IERC165).interfaceId;
439     }
440 }
441 pragma solidity ^0.8.0;
442 
443 
444 /**
445  * @dev Required interface of an ERC721 compliant contract.
446  */
447 interface IERC721 is IERC165 {
448     /**
449      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
450      */
451     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
455      */
456     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
460      */
461     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Returns the account approved for `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function getApproved(uint256 tokenId) external view returns (address operator);
540 
541     /**
542      * @dev Approve or remove `operator` as an operator for the caller.
543      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
544      *
545      * Requirements:
546      *
547      * - The `operator` cannot be the caller.
548      *
549      * Emits an {ApprovalForAll} event.
550      */
551     function setApprovalForAll(address operator, bool _approved) external;
552 
553     /**
554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555      *
556      * See {setApprovalForAll}
557      */
558     function isApprovedForAll(address owner, address operator) external view returns (bool);
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570      *
571      * Emits a {Transfer} event.
572      */
573     function safeTransferFrom(
574         address from,
575         address to,
576         uint256 tokenId,
577         bytes calldata data
578     ) external;
579 }
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
585  * @dev See https://eips.ethereum.org/EIPS/eip-721
586  */
587 interface IERC721Metadata is IERC721 {
588     /**
589      * @dev Returns the token collection name.
590      */
591     function name() external view returns (string memory);
592 
593     /**
594      * @dev Returns the token collection symbol.
595      */
596     function symbol() external view returns (string memory);
597 
598     /**
599      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
600      */
601     function tokenURI(uint256 tokenId) external view returns (string memory);
602 }
603 interface IERC721Enumerable is IERC721 {
604     /**
605      * @dev Returns the total amount of tokens stored by the contract.
606      */
607     function totalSupply() external view returns (uint256);
608 
609     /**
610      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
611      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
612      */
613     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
614 
615     /**
616      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
617      * Use along with {totalSupply} to enumerate all tokens.
618      */
619     function tokenByIndex(uint256 index) external view returns (uint256);
620 }
621 error ApprovalCallerNotOwnerNorApproved();
622 error ApprovalQueryForNonexistentToken();
623 error ApproveToCaller();
624 error ApprovalToCurrentOwner();
625 error BalanceQueryForZeroAddress();
626 error MintedQueryForZeroAddress();
627 error BurnedQueryForZeroAddress();
628 error AuxQueryForZeroAddress();
629 error MintToZeroAddress();
630 error MintZeroQuantity();
631 error OwnerIndexOutOfBounds();
632 error OwnerQueryForNonexistentToken();
633 error TokenIndexOutOfBounds();
634 error TransferCallerNotOwnerNorApproved();
635 error TransferFromIncorrectOwner();
636 error TransferToNonERC721ReceiverImplementer();
637 error TransferToZeroAddress();
638 error URIQueryForNonexistentToken();
639 
640 /**
641  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
642  * the Metadata extension. Built to optimize for lower gas during batch mints.
643  *
644  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
645  *
646  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
647  *
648  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
649  */
650 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
651     using Address for address;
652     using Strings for uint256;
653 
654     // Compiler will pack this into a single 256bit word.
655     struct TokenOwnership {
656         // The address of the owner.
657         address addr;
658         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
659         uint64 startTimestamp;
660         // Whether the token has been burned.
661         bool burned;
662     }
663 
664     // Compiler will pack this into a single 256bit word.
665     struct AddressData {
666         // Realistically, 2**64-1 is more than enough.
667         uint64 balance;
668         // Keeps track of mint count with minimal overhead for tokenomics.
669         uint64 numberMinted;
670         // Keeps track of burn count with minimal overhead for tokenomics.
671         uint64 numberBurned;
672         // For miscellaneous variable(s) pertaining to the address
673         // (e.g. number of whitelist mint slots used). 
674         // If there are multiple variables, please pack them into a uint64.
675         uint64 aux;
676     }
677 
678     // The tokenId of the next token to be minted.
679     uint256 internal _currentIndex = 1;
680 
681     // The number of tokens burned.
682     uint256 internal _burnCounter;
683 
684     // Token name
685     string private _name;
686 
687     // Token symbol
688     string private _symbol;
689 
690     // Mapping from token ID to ownership details
691     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
692     mapping(uint256 => TokenOwnership) internal _ownerships;
693 
694     // Mapping owner address to address data
695     mapping(address => AddressData) private _addressData;
696 
697     // Mapping from token ID to approved address
698     mapping(uint256 => address) private _tokenApprovals;
699 
700     // Mapping from owner to operator approvals
701     mapping(address => mapping(address => bool)) private _operatorApprovals;
702 
703     constructor(string memory name_, string memory symbol_) {
704         _name = name_;
705         _symbol = symbol_;
706     }
707 
708     /**
709      * @dev See {IERC721Enumerable-totalSupply}.
710      */
711     function totalSupply() public view returns (uint256) {
712         // Counter underflow is impossible as _burnCounter cannot be incremented
713         // more than _currentIndex times
714         unchecked {
715             return (_currentIndex - _burnCounter) - 1;    
716         }
717     }
718 
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
723         return
724             interfaceId == type(IERC721).interfaceId ||
725             interfaceId == type(IERC721Metadata).interfaceId ||
726             super.supportsInterface(interfaceId);
727     }
728 
729     /**
730      * @dev See {IERC721-balanceOf}.
731      */
732     function balanceOf(address owner) public view override returns (uint256) {
733         if (owner == address(0)) revert BalanceQueryForZeroAddress();
734         return uint256(_addressData[owner].balance);
735     }
736 
737     /**
738      * Returns the number of tokens minted by `owner`.
739      */
740     function _numberMinted(address owner) internal view returns (uint256) {
741         if (owner == address(0)) revert MintedQueryForZeroAddress();
742         return uint256(_addressData[owner].numberMinted);
743     }
744 
745     /**
746      * Returns the number of tokens burned by or on behalf of `owner`.
747      */
748     function _numberBurned(address owner) internal view returns (uint256) {
749         if (owner == address(0)) revert BurnedQueryForZeroAddress();
750         return uint256(_addressData[owner].numberBurned);
751     }
752 
753     /**
754      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
755      */
756     function _getAux(address owner) internal view returns (uint64) {
757         if (owner == address(0)) revert AuxQueryForZeroAddress();
758         return _addressData[owner].aux;
759     }
760 
761     /**
762      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
763      * If there are multiple variables, please pack them into a uint64.
764      */
765     function _setAux(address owner, uint64 aux) internal {
766         if (owner == address(0)) revert AuxQueryForZeroAddress();
767         _addressData[owner].aux = aux;
768     }
769 
770     /**
771      * Gas spent here starts off proportional to the maximum mint batch size.
772      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
773      */
774     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
775         uint256 curr = tokenId;
776 
777         unchecked {
778             if (curr < _currentIndex) {
779                 TokenOwnership memory ownership = _ownerships[curr];
780                 if (!ownership.burned) {
781                     if (ownership.addr != address(0)) {
782                         return ownership;
783                     }
784                     // Invariant: 
785                     // There will always be an ownership that has an address and is not burned 
786                     // before an ownership that does not have an address and is not burned.
787                     // Hence, curr will not underflow.
788                     while (true) {
789                         curr--;
790                         ownership = _ownerships[curr];
791                         if (ownership.addr != address(0)) {
792                             return ownership;
793                         }
794                     }
795                 }
796             }
797         }
798         revert OwnerQueryForNonexistentToken();
799     }
800 
801     /**
802      * @dev See {IERC721-ownerOf}.
803      */
804     function ownerOf(uint256 tokenId) public view override returns (address) {
805         return ownershipOf(tokenId).addr;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-name}.
810      */
811     function name() public view virtual override returns (string memory) {
812         return _name;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-symbol}.
817      */
818     function symbol() public view virtual override returns (string memory) {
819         return _symbol;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-tokenURI}.
824      */
825     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
826         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
827 
828         string memory baseURI = _baseURI();
829         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
830     }
831 
832     /**
833      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
834      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
835      * by default, can be overriden in child contracts.
836      */
837     function _baseURI() internal view virtual returns (string memory) {
838         return '';
839     }
840 
841     /**
842      * @dev See {IERC721-approve}.
843      */
844     function approve(address to, uint256 tokenId) public override {
845         address owner = ERC721A.ownerOf(tokenId);
846         if (to == owner) revert ApprovalToCurrentOwner();
847 
848         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
849             revert ApprovalCallerNotOwnerNorApproved();
850         }
851 
852         _approve(to, tokenId, owner);
853     }
854 
855     /**
856      * @dev See {IERC721-getApproved}.
857      */
858     function getApproved(uint256 tokenId) public view override returns (address) {
859         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
860 
861         return _tokenApprovals[tokenId];
862     }
863 
864     /**
865      * @dev See {IERC721-setApprovalForAll}.
866      */
867     function setApprovalForAll(address operator, bool approved) public override {
868         if (operator == _msgSender()) revert ApproveToCaller();
869 
870         _operatorApprovals[_msgSender()][operator] = approved;
871         emit ApprovalForAll(_msgSender(), operator, approved);
872     }
873 
874     /**
875      * @dev See {IERC721-isApprovedForAll}.
876      */
877     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
878         return _operatorApprovals[owner][operator];
879     }
880 
881     /**
882      * @dev See {IERC721-transferFrom}.
883      */
884     function transferFrom(
885         address from,
886         address to,
887         uint256 tokenId
888     ) public virtual override {
889         _transfer(from, to, tokenId);
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public virtual override {
900         safeTransferFrom(from, to, tokenId, '');
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) public virtual override {
912         _transfer(from, to, tokenId);
913         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
914             revert TransferToNonERC721ReceiverImplementer();
915         }
916     }
917 
918     /**
919      * @dev Returns whether `tokenId` exists.
920      *
921      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
922      *
923      * Tokens start existing when they are minted (`_mint`),
924      */
925     function _exists(uint256 tokenId) internal view returns (bool) {
926         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
927     }
928 
929     function _safeMint(address to, uint256 quantity) internal {
930         _safeMint(to, quantity, '');
931     }
932 
933     /**
934      * @dev Safely mints `quantity` tokens and transfers them to `to`.
935      *
936      * Requirements:
937      *
938      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
939      * - `quantity` must be greater than 0.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeMint(
944         address to,
945         uint256 quantity,
946         bytes memory _data
947     ) internal {
948         _mint(to, quantity, _data, true);
949     }
950 
951     /**
952      * @dev Mints `quantity` tokens and transfers them to `to`.
953      *
954      * Requirements:
955      *
956      * - `to` cannot be the zero address.
957      * - `quantity` must be greater than 0.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _mint(
962         address to,
963         uint256 quantity,
964         bytes memory _data,
965         bool safe
966     ) internal {
967         uint256 startTokenId = _currentIndex;
968         if (to == address(0)) revert MintToZeroAddress();
969         if (quantity == 0) revert MintZeroQuantity();
970 
971         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
972 
973         // Overflows are incredibly unrealistic.
974         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
975         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
976         unchecked {
977             _addressData[to].balance += uint64(quantity);
978             _addressData[to].numberMinted += uint64(quantity);
979 
980             _ownerships[startTokenId].addr = to;
981             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
982 
983             uint256 updatedIndex = startTokenId;
984 
985             for (uint256 i; i < quantity; i++) {
986                 emit Transfer(address(0), to, updatedIndex);
987                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
988                     revert TransferToNonERC721ReceiverImplementer();
989                 }
990                 updatedIndex++;
991             }
992 
993             _currentIndex = updatedIndex;
994         }
995         _afterTokenTransfers(address(0), to, startTokenId, quantity);
996     }
997 
998     /**
999      * @dev Transfers `tokenId` from `from` to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must be owned by `from`.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _transfer(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) private {
1013         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1014 
1015         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1016             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1017             getApproved(tokenId) == _msgSender());
1018 
1019         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1020         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1021         if (to == address(0)) revert TransferToZeroAddress();
1022 
1023         _beforeTokenTransfers(from, to, tokenId, 1);
1024 
1025         // Clear approvals from the previous owner
1026         _approve(address(0), tokenId, prevOwnership.addr);
1027 
1028         // Underflow of the sender's balance is impossible because we check for
1029         // ownership above and the recipient's balance can't realistically overflow.
1030         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1031         unchecked {
1032             _addressData[from].balance -= 1;
1033             _addressData[to].balance += 1;
1034 
1035             _ownerships[tokenId].addr = to;
1036             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1037 
1038             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1039             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1040             uint256 nextTokenId = tokenId + 1;
1041             if (_ownerships[nextTokenId].addr == address(0)) {
1042                 // This will suffice for checking _exists(nextTokenId),
1043                 // as a burned slot cannot contain the zero address.
1044                 if (nextTokenId < _currentIndex) {
1045                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1046                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1047                 }
1048             }
1049         }
1050 
1051         emit Transfer(from, to, tokenId);
1052         _afterTokenTransfers(from, to, tokenId, 1);
1053     }
1054 
1055     /**
1056      * @dev Destroys `tokenId`.
1057      * The approval is cleared when the token is burned.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _burn(uint256 tokenId) internal virtual {
1066         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1067 
1068         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1069 
1070         // Clear approvals from the previous owner
1071         _approve(address(0), tokenId, prevOwnership.addr);
1072 
1073         // Underflow of the sender's balance is impossible because we check for
1074         // ownership above and the recipient's balance can't realistically overflow.
1075         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1076         unchecked {
1077             _addressData[prevOwnership.addr].balance -= 1;
1078             _addressData[prevOwnership.addr].numberBurned += 1;
1079 
1080             // Keep track of who burned the token, and the timestamp of burning.
1081             _ownerships[tokenId].addr = prevOwnership.addr;
1082             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1083             _ownerships[tokenId].burned = true;
1084 
1085             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1086             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1087             uint256 nextTokenId = tokenId + 1;
1088             if (_ownerships[nextTokenId].addr == address(0)) {
1089                 // This will suffice for checking _exists(nextTokenId),
1090                 // as a burned slot cannot contain the zero address.
1091                 if (nextTokenId < _currentIndex) {
1092                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1093                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1094                 }
1095             }
1096         }
1097 
1098         emit Transfer(prevOwnership.addr, address(0), tokenId);
1099         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1100 
1101         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1102         unchecked { 
1103             _burnCounter++;
1104         }
1105     }
1106 
1107     /**
1108      * @dev Approve `to` to operate on `tokenId`
1109      *
1110      * Emits a {Approval} event.
1111      */
1112     function _approve(
1113         address to,
1114         uint256 tokenId,
1115         address owner
1116     ) private {
1117         _tokenApprovals[tokenId] = to;
1118         emit Approval(owner, to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1123      * The call is not executed if the target address is not a contract.
1124      *
1125      * @param from address representing the previous owner of the given token ID
1126      * @param to target address that will receive the tokens
1127      * @param tokenId uint256 ID of the token to be transferred
1128      * @param _data bytes optional data to send along with the call
1129      * @return bool whether the call correctly returned the expected magic value
1130      */
1131     function _checkOnERC721Received(
1132         address from,
1133         address to,
1134         uint256 tokenId,
1135         bytes memory _data
1136     ) private returns (bool) {
1137         if (to.isContract()) {
1138             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1139                 return retval == IERC721Receiver(to).onERC721Received.selector;
1140             } catch (bytes memory reason) {
1141                 if (reason.length == 0) {
1142                     revert TransferToNonERC721ReceiverImplementer();
1143                 } else {
1144                     assembly {
1145                         revert(add(32, reason), mload(reason))
1146                     }
1147                 }
1148             }
1149         } else {
1150             return true;
1151         }
1152     }
1153 
1154     /**
1155      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1156      * And also called before burning one token.
1157      *
1158      * startTokenId - the first token id to be transferred
1159      * quantity - the amount to be transferred
1160      *
1161      * Calling conditions:
1162      *
1163      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1164      * transferred to `to`.
1165      * - When `from` is zero, `tokenId` will be minted for `to`.
1166      * - When `to` is zero, `tokenId` will be burned by `from`.
1167      * - `from` and `to` are never both zero.
1168      */
1169     function _beforeTokenTransfers(
1170         address from,
1171         address to,
1172         uint256 startTokenId,
1173         uint256 quantity
1174     ) internal virtual {}
1175 
1176     /**
1177      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1178      * minting.
1179      * And also called after one token has been burned.
1180      *
1181      * startTokenId - the first token id to be transferred
1182      * quantity - the amount to be transferred
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` has been minted for `to`.
1189      * - When `to` is zero, `tokenId` has been burned by `from`.
1190      * - `from` and `to` are never both zero.
1191      */
1192     function _afterTokenTransfers(
1193         address from,
1194         address to,
1195         uint256 startTokenId,
1196         uint256 quantity
1197     ) internal virtual {}
1198 }
1199 
1200 library ECDSA {
1201     enum RecoverError {
1202         NoError,
1203         InvalidSignature,
1204         InvalidSignatureLength,
1205         InvalidSignatureS,
1206         InvalidSignatureV
1207     }
1208 
1209     function _throwError(RecoverError error) private pure {
1210         if (error == RecoverError.NoError) {
1211             return; // no error: do nothing
1212         } else if (error == RecoverError.InvalidSignature) {
1213             revert("ECDSA: invalid signature");
1214         } else if (error == RecoverError.InvalidSignatureLength) {
1215             revert("ECDSA: invalid signature length");
1216         } else if (error == RecoverError.InvalidSignatureS) {
1217             revert("ECDSA: invalid signature 's' value");
1218         } else if (error == RecoverError.InvalidSignatureV) {
1219             revert("ECDSA: invalid signature 'v' value");
1220         }
1221     }
1222 
1223     /**
1224      * @dev Returns the address that signed a hashed message (`hash`) with
1225      * `signature` or error string. This address can then be used for verification purposes.
1226      *
1227      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1228      * this function rejects them by requiring the `s` value to be in the lower
1229      * half order, and the `v` value to be either 27 or 28.
1230      *
1231      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1232      * verification to be secure: it is possible to craft signatures that
1233      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1234      * this is by receiving a hash of the original message (which may otherwise
1235      * be too long), and then calling {toEthSignedMessageHash} on it.
1236      *
1237      * Documentation for signature generation:
1238      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1239      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1240      *
1241      * _Available since v4.3._
1242      */
1243     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1244         // Check the signature length
1245         // - case 65: r,s,v signature (standard)
1246         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1247         if (signature.length == 65) {
1248             bytes32 r;
1249             bytes32 s;
1250             uint8 v;
1251             // ecrecover takes the signature parameters, and the only way to get them
1252             // currently is to use assembly.
1253             assembly {
1254                 r := mload(add(signature, 0x20))
1255                 s := mload(add(signature, 0x40))
1256                 v := byte(0, mload(add(signature, 0x60)))
1257             }
1258             return tryRecover(hash, v, r, s);
1259         } else if (signature.length == 64) {
1260             bytes32 r;
1261             bytes32 vs;
1262             // ecrecover takes the signature parameters, and the only way to get them
1263             // currently is to use assembly.
1264             assembly {
1265                 r := mload(add(signature, 0x20))
1266                 vs := mload(add(signature, 0x40))
1267             }
1268             return tryRecover(hash, r, vs);
1269         } else {
1270             return (address(0), RecoverError.InvalidSignatureLength);
1271         }
1272     }
1273 
1274     /**
1275      * @dev Returns the address that signed a hashed message (`hash`) with
1276      * `signature`. This address can then be used for verification purposes.
1277      *
1278      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1279      * this function rejects them by requiring the `s` value to be in the lower
1280      * half order, and the `v` value to be either 27 or 28.
1281      *
1282      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1283      * verification to be secure: it is possible to craft signatures that
1284      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1285      * this is by receiving a hash of the original message (which may otherwise
1286      * be too long), and then calling {toEthSignedMessageHash} on it.
1287      */
1288     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1289         (address recovered, RecoverError error) = tryRecover(hash, signature);
1290         _throwError(error);
1291         return recovered;
1292     }
1293 
1294     /**
1295      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1296      *
1297      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1298      *
1299      * _Available since v4.3._
1300      */
1301     function tryRecover(
1302         bytes32 hash,
1303         bytes32 r,
1304         bytes32 vs
1305     ) internal pure returns (address, RecoverError) {
1306         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1307         uint8 v = uint8((uint256(vs) >> 255) + 27);
1308         return tryRecover(hash, v, r, s);
1309     }
1310 
1311     /**
1312      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1313      *
1314      * _Available since v4.2._
1315      */
1316     function recover(
1317         bytes32 hash,
1318         bytes32 r,
1319         bytes32 vs
1320     ) internal pure returns (address) {
1321         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1322         _throwError(error);
1323         return recovered;
1324     }
1325 
1326     /**
1327      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1328      * `r` and `s` signature fields separately.
1329      *
1330      * _Available since v4.3._
1331      */
1332     function tryRecover(
1333         bytes32 hash,
1334         uint8 v,
1335         bytes32 r,
1336         bytes32 s
1337     ) internal pure returns (address, RecoverError) {
1338         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1339         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1340         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1341         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1342         //
1343         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1344         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1345         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1346         // these malleable signatures as well.
1347         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1348             return (address(0), RecoverError.InvalidSignatureS);
1349         }
1350         if (v != 27 && v != 28) {
1351             return (address(0), RecoverError.InvalidSignatureV);
1352         }
1353 
1354         // If the signature is valid (and not malleable), return the signer address
1355         address signer = ecrecover(hash, v, r, s);
1356         if (signer == address(0)) {
1357             return (address(0), RecoverError.InvalidSignature);
1358         }
1359 
1360         return (signer, RecoverError.NoError);
1361     }
1362 
1363     /**
1364      * @dev Overload of {ECDSA-recover} that receives the `v`,
1365      * `r` and `s` signature fields separately.
1366      */
1367     function recover(
1368         bytes32 hash,
1369         uint8 v,
1370         bytes32 r,
1371         bytes32 s
1372     ) internal pure returns (address) {
1373         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1374         _throwError(error);
1375         return recovered;
1376     }
1377 
1378     /**
1379      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1380      * produces hash corresponding to the one signed with the
1381      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1382      * JSON-RPC method as part of EIP-191.
1383      *
1384      * See {recover}.
1385      */
1386     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1387         // 32 is the length in bytes of hash,
1388         // enforced by the type signature above
1389         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1390     }
1391 
1392     /**
1393      * @dev Returns an Ethereum Signed Message, created from `s`. This
1394      * produces hash corresponding to the one signed with the
1395      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1396      * JSON-RPC method as part of EIP-191.
1397      *
1398      * See {recover}.
1399      */
1400     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1401         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1402     }
1403 
1404     /**
1405      * @dev Returns an Ethereum Signed Typed Data, created from a
1406      * `domainSeparator` and a `structHash`. This produces hash corresponding
1407      * to the one signed with the
1408      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1409      * JSON-RPC method as part of EIP-712.
1410      *
1411      * See {recover}.
1412      */
1413     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1414         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1415     }
1416 }
1417 abstract contract EIP712 {
1418     /* solhint-disable var-name-mixedcase */
1419     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1420     // invalidate the cached domain separator if the chain id changes.
1421     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1422     uint256 private immutable _CACHED_CHAIN_ID;
1423     address private immutable _CACHED_THIS;
1424 
1425     bytes32 private immutable _HASHED_NAME;
1426     bytes32 private immutable _HASHED_VERSION;
1427     bytes32 private immutable _TYPE_HASH;
1428 
1429     /* solhint-enable var-name-mixedcase */
1430 
1431     /**
1432      * @dev Initializes the domain separator and parameter caches.
1433      *
1434      * The meaning of `name` and `version` is specified in
1435      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1436      *
1437      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1438      * - `version`: the current major version of the signing domain.
1439      *
1440      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1441      * contract upgrade].
1442      */
1443     constructor(string memory name, string memory version) {
1444         bytes32 hashedName = keccak256(bytes(name));
1445         bytes32 hashedVersion = keccak256(bytes(version));
1446         bytes32 typeHash = keccak256(
1447             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1448         );
1449         _HASHED_NAME = hashedName;
1450         _HASHED_VERSION = hashedVersion;
1451         _CACHED_CHAIN_ID = block.chainid;
1452         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1453         _CACHED_THIS = address(this);
1454         _TYPE_HASH = typeHash;
1455     }
1456 
1457     /**
1458      * @dev Returns the domain separator for the current chain.
1459      */
1460     function _domainSeparatorV4() internal view returns (bytes32) {
1461         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1462             return _CACHED_DOMAIN_SEPARATOR;
1463         } else {
1464             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1465         }
1466     }
1467 
1468     function _buildDomainSeparator(
1469         bytes32 typeHash,
1470         bytes32 nameHash,
1471         bytes32 versionHash
1472     ) private view returns (bytes32) {
1473         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1474     }
1475 
1476     /**
1477      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1478      * function returns the hash of the fully encoded EIP712 message for this domain.
1479      *
1480      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1481      *
1482      * ```solidity
1483      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1484      *     keccak256("Mail(address to,string contents)"),
1485      *     mailTo,
1486      *     keccak256(bytes(mailContents))
1487      * )));
1488      * address signer = ECDSA.recover(digest, signature);
1489      * ```
1490      */
1491     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1492         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1493     }
1494 }
1495 
1496 contract SECAPES is Ownable, ERC721A {
1497 
1498     uint256 public adoptionLimit =5;
1499     using Strings for uint256;
1500 
1501     mapping(uint256 => string) private _tokenURIs;
1502     bool public publicSaleOpen = false;
1503     string public baseURI = "ipfs://QmYqzsd851ujmka3H31YihQZcGCuutKbA2xrb5Xzc8TZqw/";
1504     string public _extension = ".json";
1505     uint256 public price = 0 ether;
1506     uint256 public maxSupply = 5000;
1507 
1508     constructor() ERC721A("SEC APES", "SECAPES"){}
1509     
1510     function mintNFT(uint256 _quantity) public payable {
1511         require(_quantity > 0 && _quantity <= adoptionLimit, "Wrong Quantity.");
1512         require(totalSupply() + _quantity <= maxSupply, "Reaching max supply");
1513         require(msg.value == price * _quantity, "Needs to send more eth");
1514         require(getMintedCount(msg.sender) + _quantity <= adoptionLimit, "Exceed max minting amount");
1515         require(publicSaleOpen, "Public Sale Not Started Yet!");
1516 
1517         _safeMint(msg.sender, _quantity);
1518 
1519     }
1520 
1521 
1522     function sendGifts(address[] memory _wallets) external onlyOwner{
1523         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
1524         for(uint i = 0; i < _wallets.length; i++)
1525             _safeMint(_wallets[i], 1);
1526 
1527     }
1528    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
1529                require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
1530             _safeMint(_wallet, _num);
1531     }
1532 
1533 
1534     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1535         require(
1536             _exists(_tokenId),
1537             "ERC721Metadata: URI set of nonexistent token"
1538         );
1539 
1540         return string(abi.encodePacked(baseURI, _tokenId.toString(), _extension));
1541     }
1542 
1543     function updateBaseURI(string memory _newBaseURI) onlyOwner public {
1544         baseURI = _newBaseURI;
1545     }
1546     function updateExtension(string memory _temp) onlyOwner public {
1547         _extension = _temp;
1548     }
1549 
1550     function getBaseURI() external view returns(string memory) {
1551         return baseURI;
1552     }
1553 
1554     function setPrice(uint256 _price) public onlyOwner() {
1555         price = _price;
1556     }
1557     function setAdoptionlimits(uint256 _adoptionLimit) public onlyOwner() {
1558         adoptionLimit = _adoptionLimit;
1559     }
1560 
1561     function setmaxSupply(uint256 _supply) public onlyOwner() {
1562         maxSupply = _supply;
1563     }
1564 
1565     function toggleSale() public onlyOwner() {
1566         publicSaleOpen = !publicSaleOpen;
1567     }
1568 
1569 
1570     function getBalance() public view returns(uint) {
1571         return address(this).balance;
1572     }
1573 
1574     function getMintedCount(address owner) public view returns (uint256) {
1575     return _numberMinted(owner);
1576   }
1577 
1578     function withdraw() external onlyOwner {
1579         uint _balance = address(this).balance;
1580         payable(owner()).transfer(_balance); //Owner
1581     }
1582 
1583     function getOwnershipData(uint256 tokenId)
1584     external
1585     view
1586     returns (TokenOwnership memory)
1587   {
1588     return ownershipOf(tokenId);
1589   }
1590 
1591     receive() external payable {}
1592 
1593 }