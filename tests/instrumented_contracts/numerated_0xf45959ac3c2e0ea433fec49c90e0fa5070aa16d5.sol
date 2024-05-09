1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 //     ___                                  _ 
5 //   /'___)                   _            ( )
6 //  | (__  _   _  _ __  _ __ (_)   __     _| |
7 //  | ,__)( ) ( )( '__)( '__)| | /'__`\ /'_` |
8 //  | |   | (_) || |   | |   | |(  ___/( (_| |
9 //  (_)   `\___/'(_)   (_)   (_)`\____)`\__,_)
10 //   ..... the bears are back .... NOV 2022...                                         
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev String operations.
35  */
36 library Strings {
37     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
66      */
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
82      */
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Collection of functions related to the address type
99  */
100 library Address {
101     /**
102      * @dev Returns true if `account` is a contract.
103      *
104      * [IMPORTANT]
105      * ====
106      * It is unsafe to assume that an address for which this function returns
107      * false is an externally-owned account (EOA) and not a contract.
108      *
109      * Among others, `isContract` will return false for the following
110      * types of addresses:
111      *
112      *  - an externally-owned account
113      *  - a contract in construction
114      *  - an address where a contract will be created
115      *  - an address where a contract lived, but was destroyed
116      * ====
117      */
118     function isContract(address account) internal view returns (bool) {
119         // This method relies on extcodesize, which returns 0 for contracts in
120         // construction, since the code is only stored at the end of the
121         // constructor execution.
122 
123         uint256 size;
124         assembly {
125             size := extcodesize(account)
126         }
127         return size > 0;
128     }
129 
130     /**
131      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
132      * `recipient`, forwarding all available gas and reverting on errors.
133      *
134      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
135      * of certain opcodes, possibly making contracts go over the 2300 gas limit
136      * imposed by `transfer`, making them unable to receive funds via
137      * `transfer`. {sendValue} removes this limitation.
138      *
139      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
140      *
141      * IMPORTANT: because control is transferred to `recipient`, care must be
142      * taken to not create reentrancy vulnerabilities. Consider using
143      * {ReentrancyGuard} or the
144      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
145      */
146     function sendValue(address payable recipient, uint256 amount) internal {
147         require(address(this).balance >= amount, "Address: insufficient balance");
148 
149         (bool success, ) = recipient.call{value: amount}("");
150         require(success, "Address: unable to send value, recipient may have reverted");
151     }
152 
153     /**
154      * @dev Performs a Solidity function call using a low level `call`. A
155      * plain `call` is an unsafe replacement for a function call: use this
156      * function instead.
157      *
158      * If `target` reverts with a revert reason, it is bubbled up by this
159      * function (like regular Solidity function calls).
160      *
161      * Returns the raw returned data. To convert to the expected return value,
162      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
163      *
164      * Requirements:
165      *
166      * - `target` must be a contract.
167      * - calling `target` with `data` must not revert.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionCall(target, data, "Address: low-level call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
177      * `errorMessage` as a fallback revert reason when `target` reverts.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, 0, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but also transferring `value` wei to `target`.
192      *
193      * Requirements:
194      *
195      * - the calling contract must have an ETH balance of at least `value`.
196      * - the called Solidity function must be `payable`.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value
204     ) internal returns (bytes memory) {
205         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
210      * with `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(address(this).balance >= value, "Address: insufficient balance for call");
221         require(isContract(target), "Address: call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
234         return functionStaticCall(target, data, "Address: low-level static call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal view returns (bytes memory) {
248         require(isContract(target), "Address: static call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.staticcall(data);
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(isContract(target), "Address: delegate call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.delegatecall(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
283      * revert reason using the provided one.
284      *
285      * _Available since v4.3._
286      */
287     function verifyCallResult(
288         bool success,
289         bytes memory returndata,
290         string memory errorMessage
291     ) internal pure returns (bytes memory) {
292         if (success) {
293             return returndata;
294         } else {
295             // Look for revert reason and bubble it up if present
296             if (returndata.length > 0) {
297                 // The easiest way to bubble the revert reason is using memory via assembly
298 
299                 assembly {
300                     let returndata_size := mload(returndata)
301                     revert(add(32, returndata), returndata_size)
302                 }
303             } else {
304                 revert(errorMessage);
305             }
306         }
307     }
308 }
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Interface of the ERC165 standard, as defined in the
313  * https://eips.ethereum.org/EIPS/eip-165[EIP].
314  *
315  * Implementers can declare support of contract interfaces, which can then be
316  * queried by others ({ERC165Checker}).
317  *
318  * For an implementation, see {ERC165}.
319  */
320 interface IERC165 {
321     /**
322      * @dev Returns true if this contract implements the interface defined by
323      * `interfaceId`. See the corresponding
324      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
325      * to learn more about how these ids are created.
326      *
327      * This function call must use less than 30 000 gas.
328      */
329     function supportsInterface(bytes4 interfaceId) external view returns (bool);
330 }
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @title ERC721 token receiver interface
335  * @dev Interface for any contract that wants to support safeTransfers
336  * from ERC721 asset contracts.
337  */
338 interface IERC721Receiver {
339     /**
340      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
341      * by `operator` from `from`, this function is called.
342      *
343      * It must return its Solidity selector to confirm the token transfer.
344      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
345      *
346      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
347      */
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Contract module which provides a basic access control mechanism, where
360  * there is an account (an owner) that can be granted exclusive access to
361  * specific functions.
362  *
363  * By default, the owner account will be the one that deploys the contract. This
364  * can later be changed with {transferOwnership}.
365  *
366  * This module is used through inheritance. It will make available the modifier
367  * `onlyOwner`, which can be applied to your functions to restrict their use to
368  * the owner.
369  */
370 abstract contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376      * @dev Initializes the contract setting the deployer as the initial owner.
377      */
378     constructor() {
379         _setOwner(_msgSender());
380     }
381 
382     /**
383      * @dev Returns the address of the current owner.
384      */
385     function owner() public view virtual returns (address) {
386         return _owner;
387     }
388 
389     /**
390      * @dev Throws if called by any account other than the owner.
391      */
392     modifier onlyOwner() {
393         require(owner() == _msgSender(), "Ownable: caller is not the owner");
394         _;
395     }
396 
397     /**
398      * @dev Leaves the contract without owner. It will not be possible to call
399      * `onlyOwner` functions anymore. Can only be called by the current owner.
400      *
401      * NOTE: Renouncing ownership will leave the contract without an owner,
402      * thereby removing any functionality that is only available to the owner.
403      */
404     function renounceOwnership() public virtual onlyOwner {
405         _setOwner(address(0));
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is the zero address");
414         _setOwner(newOwner);
415     }
416 
417     function _setOwner(address newOwner) private {
418         address oldOwner = _owner;
419         _owner = newOwner;
420         emit OwnershipTransferred(oldOwner, newOwner);
421     }
422 }
423 pragma solidity ^0.8.0;
424 
425 
426 /**
427  * @dev Implementation of the {IERC165} interface.
428  *
429  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
430  * for the additional interface id that will be supported. For example:
431  *
432  * ```solidity
433  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
434  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
435  * }
436  * ```
437  *
438  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
439  */
440 abstract contract ERC165 is IERC165 {
441     /**
442      * @dev See {IERC165-supportsInterface}.
443      */
444     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445         return interfaceId == type(IERC165).interfaceId;
446     }
447 }
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @dev Required interface of an ERC721 compliant contract.
453  */
454 interface IERC721 is IERC165 {
455     /**
456      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
457      */
458     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
459 
460     /**
461      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
462      */
463     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
467      */
468     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
469 
470     /**
471      * @dev Returns the number of tokens in ``owner``'s account.
472      */
473     function balanceOf(address owner) external view returns (uint256 balance);
474 
475     /**
476      * @dev Returns the owner of the `tokenId` token.
477      *
478      * Requirements:
479      *
480      * - `tokenId` must exist.
481      */
482     function ownerOf(uint256 tokenId) external view returns (address owner);
483 
484     /**
485      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
486      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
487      *
488      * Requirements:
489      *
490      * - `from` cannot be the zero address.
491      * - `to` cannot be the zero address.
492      * - `tokenId` token must exist and be owned by `from`.
493      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
494      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
495      *
496      * Emits a {Transfer} event.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId
502     ) external;
503 
504     /**
505      * @dev Transfers `tokenId` token from `from` to `to`.
506      *
507      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must be owned by `from`.
514      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
515      *
516      * Emits a {Transfer} event.
517      */
518     function transferFrom(
519         address from,
520         address to,
521         uint256 tokenId
522     ) external;
523 
524     /**
525      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
526      * The approval is cleared when the token is transferred.
527      *
528      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
529      *
530      * Requirements:
531      *
532      * - The caller must own the token or be an approved operator.
533      * - `tokenId` must exist.
534      *
535      * Emits an {Approval} event.
536      */
537     function approve(address to, uint256 tokenId) external;
538 
539     /**
540      * @dev Returns the account approved for `tokenId` token.
541      *
542      * Requirements:
543      *
544      * - `tokenId` must exist.
545      */
546     function getApproved(uint256 tokenId) external view returns (address operator);
547 
548     /**
549      * @dev Approve or remove `operator` as an operator for the caller.
550      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
551      *
552      * Requirements:
553      *
554      * - The `operator` cannot be the caller.
555      *
556      * Emits an {ApprovalForAll} event.
557      */
558     function setApprovalForAll(address operator, bool _approved) external;
559 
560     /**
561      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
562      *
563      * See {setApprovalForAll}
564      */
565     function isApprovedForAll(address owner, address operator) external view returns (bool);
566 
567     /**
568      * @dev Safely transfers `tokenId` token from `from` to `to`.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must exist and be owned by `from`.
575      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
576      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
577      *
578      * Emits a {Transfer} event.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 tokenId,
584         bytes calldata data
585     ) external;
586 }
587 pragma solidity ^0.8.0;
588 
589 
590 /**
591  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
592  * @dev See https://eips.ethereum.org/EIPS/eip-721
593  */
594 interface IERC721Metadata is IERC721 {
595     /**
596      * @dev Returns the token collection name.
597      */
598     function name() external view returns (string memory);
599 
600     /**
601      * @dev Returns the token collection symbol.
602      */
603     function symbol() external view returns (string memory);
604 
605     /**
606      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
607      */
608     function tokenURI(uint256 tokenId) external view returns (string memory);
609 }
610 interface IERC721Enumerable is IERC721 {
611     /**
612      * @dev Returns the total amount of tokens stored by the contract.
613      */
614     function totalSupply() external view returns (uint256);
615 
616     /**
617      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
618      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
619      */
620     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
621 
622     /**
623      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
624      * Use along with {totalSupply} to enumerate all tokens.
625      */
626     function tokenByIndex(uint256 index) external view returns (uint256);
627 }
628 error ApprovalCallerNotOwnerNorApproved();
629 error ApprovalQueryForNonexistentToken();
630 error ApproveToCaller();
631 error ApprovalToCurrentOwner();
632 error BalanceQueryForZeroAddress();
633 error MintedQueryForZeroAddress();
634 error BurnedQueryForZeroAddress();
635 error AuxQueryForZeroAddress();
636 error MintToZeroAddress();
637 error MintZeroQuantity();
638 error OwnerIndexOutOfBounds();
639 error OwnerQueryForNonexistentToken();
640 error TokenIndexOutOfBounds();
641 error TransferCallerNotOwnerNorApproved();
642 error TransferFromIncorrectOwner();
643 error TransferToNonERC721ReceiverImplementer();
644 error TransferToZeroAddress();
645 error URIQueryForNonexistentToken();
646 
647 /**
648  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
649  * the Metadata extension. Built to optimize for lower gas during batch mints.
650  *
651  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
652  *
653  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
654  *
655  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
656  */
657 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
658     using Address for address;
659     using Strings for uint256;
660 
661     // Compiler will pack this into a single 256bit word.
662     struct TokenOwnership {
663         // The address of the owner.
664         address addr;
665         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
666         uint64 startTimestamp;
667         // Whether the token has been burned.
668         bool burned;
669     }
670 
671     // Compiler will pack this into a single 256bit word.
672     struct AddressData {
673         // Realistically, 2**64-1 is more than enough.
674         uint64 balance;
675         // Keeps track of mint count with minimal overhead for tokenomics.
676         uint64 numberMinted;
677         // Keeps track of burn count with minimal overhead for tokenomics.
678         uint64 numberBurned;
679         // For miscellaneous variable(s) pertaining to the address
680         // (e.g. number of whitelist mint slots used). 
681         // If there are multiple variables, please pack them into a uint64.
682         uint64 aux;
683     }
684 
685     // The tokenId of the next token to be minted.
686     uint256 internal _currentIndex = 1;
687 
688     // The number of tokens burned.
689     uint256 internal _burnCounter;
690 
691     // Token name
692     string private _name;
693 
694     // Token symbol
695     string private _symbol;
696 
697     // Mapping from token ID to ownership details
698     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
699     mapping(uint256 => TokenOwnership) internal _ownerships;
700 
701     // Mapping owner address to address data
702     mapping(address => AddressData) private _addressData;
703 
704     // Mapping from token ID to approved address
705     mapping(uint256 => address) private _tokenApprovals;
706 
707     // Mapping from owner to operator approvals
708     mapping(address => mapping(address => bool)) private _operatorApprovals;
709 
710     constructor(string memory name_, string memory symbol_) {
711         _name = name_;
712         _symbol = symbol_;
713     }
714 
715     /**
716      * @dev See {IERC721Enumerable-totalSupply}.
717      */
718     function totalSupply() public view returns (uint256) {
719         // Counter underflow is impossible as _burnCounter cannot be incremented
720         // more than _currentIndex times
721         unchecked {
722             return (_currentIndex - _burnCounter) - 1;    
723         }
724     }
725 
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
730         return
731             interfaceId == type(IERC721).interfaceId ||
732             interfaceId == type(IERC721Metadata).interfaceId ||
733             super.supportsInterface(interfaceId);
734     }
735 
736     /**
737      * @dev See {IERC721-balanceOf}.
738      */
739     function balanceOf(address owner) public view override returns (uint256) {
740         if (owner == address(0)) revert BalanceQueryForZeroAddress();
741         return uint256(_addressData[owner].balance);
742     }
743 
744     /**
745      * Returns the number of tokens minted by `owner`.
746      */
747     function _numberMinted(address owner) internal view returns (uint256) {
748         if (owner == address(0)) revert MintedQueryForZeroAddress();
749         return uint256(_addressData[owner].numberMinted);
750     }
751 
752     /**
753      * Returns the number of tokens burned by or on behalf of `owner`.
754      */
755     function _numberBurned(address owner) internal view returns (uint256) {
756         if (owner == address(0)) revert BurnedQueryForZeroAddress();
757         return uint256(_addressData[owner].numberBurned);
758     }
759 
760     /**
761      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
762      */
763     function _getAux(address owner) internal view returns (uint64) {
764         if (owner == address(0)) revert AuxQueryForZeroAddress();
765         return _addressData[owner].aux;
766     }
767 
768     /**
769      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
770      * If there are multiple variables, please pack them into a uint64.
771      */
772     function _setAux(address owner, uint64 aux) internal {
773         if (owner == address(0)) revert AuxQueryForZeroAddress();
774         _addressData[owner].aux = aux;
775     }
776 
777     /**
778      * Gas spent here starts off proportional to the maximum mint batch size.
779      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
780      */
781     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
782         uint256 curr = tokenId;
783 
784         unchecked {
785             if (curr < _currentIndex) {
786                 TokenOwnership memory ownership = _ownerships[curr];
787                 if (!ownership.burned) {
788                     if (ownership.addr != address(0)) {
789                         return ownership;
790                     }
791                     // Invariant: 
792                     // There will always be an ownership that has an address and is not burned 
793                     // before an ownership that does not have an address and is not burned.
794                     // Hence, curr will not underflow.
795                     while (true) {
796                         curr--;
797                         ownership = _ownerships[curr];
798                         if (ownership.addr != address(0)) {
799                             return ownership;
800                         }
801                     }
802                 }
803             }
804         }
805         revert OwnerQueryForNonexistentToken();
806     }
807 
808     /**
809      * @dev See {IERC721-ownerOf}.
810      */
811     function ownerOf(uint256 tokenId) public view override returns (address) {
812         return ownershipOf(tokenId).addr;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-name}.
817      */
818     function name() public view virtual override returns (string memory) {
819         return _name;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-symbol}.
824      */
825     function symbol() public view virtual override returns (string memory) {
826         return _symbol;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-tokenURI}.
831      */
832     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
833         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
834 
835         string memory baseURI = _baseURI();
836         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
837     }
838 
839     /**
840      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
841      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
842      * by default, can be overriden in child contracts.
843      */
844     function _baseURI() internal view virtual returns (string memory) {
845         return '';
846     }
847 
848     /**
849      * @dev See {IERC721-approve}.
850      */
851     function approve(address to, uint256 tokenId) public override {
852         address owner = ERC721A.ownerOf(tokenId);
853         if (to == owner) revert ApprovalToCurrentOwner();
854 
855         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
856             revert ApprovalCallerNotOwnerNorApproved();
857         }
858 
859         _approve(to, tokenId, owner);
860     }
861 
862     /**
863      * @dev See {IERC721-getApproved}.
864      */
865     function getApproved(uint256 tokenId) public view override returns (address) {
866         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
867 
868         return _tokenApprovals[tokenId];
869     }
870 
871     /**
872      * @dev See {IERC721-setApprovalForAll}.
873      */
874     function setApprovalForAll(address operator, bool approved) public override {
875         if (operator == _msgSender()) revert ApproveToCaller();
876 
877         _operatorApprovals[_msgSender()][operator] = approved;
878         emit ApprovalForAll(_msgSender(), operator, approved);
879     }
880 
881     /**
882      * @dev See {IERC721-isApprovedForAll}.
883      */
884     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
885         return _operatorApprovals[owner][operator];
886     }
887 
888     /**
889      * @dev See {IERC721-transferFrom}.
890      */
891     function transferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) public virtual override {
896         _transfer(from, to, tokenId);
897     }
898 
899     /**
900      * @dev See {IERC721-safeTransferFrom}.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         safeTransferFrom(from, to, tokenId, '');
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) public virtual override {
919         _transfer(from, to, tokenId);
920         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
921             revert TransferToNonERC721ReceiverImplementer();
922         }
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted (`_mint`),
931      */
932     function _exists(uint256 tokenId) internal view returns (bool) {
933         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
934     }
935 
936     function _safeMint(address to, uint256 quantity) internal {
937         _safeMint(to, quantity, '');
938     }
939 
940     /**
941      * @dev Safely mints `quantity` tokens and transfers them to `to`.
942      *
943      * Requirements:
944      *
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
946      * - `quantity` must be greater than 0.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _safeMint(
951         address to,
952         uint256 quantity,
953         bytes memory _data
954     ) internal {
955         _mint(to, quantity, _data, true);
956     }
957 
958     /**
959      * @dev Mints `quantity` tokens and transfers them to `to`.
960      *
961      * Requirements:
962      *
963      * - `to` cannot be the zero address.
964      * - `quantity` must be greater than 0.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(
969         address to,
970         uint256 quantity,
971         bytes memory _data,
972         bool safe
973     ) internal {
974         uint256 startTokenId = _currentIndex;
975         if (to == address(0)) revert MintToZeroAddress();
976         if (quantity == 0) revert MintZeroQuantity();
977 
978         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
979 
980         // Overflows are incredibly unrealistic.
981         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
982         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
983         unchecked {
984             _addressData[to].balance += uint64(quantity);
985             _addressData[to].numberMinted += uint64(quantity);
986 
987             _ownerships[startTokenId].addr = to;
988             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
989 
990             uint256 updatedIndex = startTokenId;
991 
992             for (uint256 i; i < quantity; i++) {
993                 emit Transfer(address(0), to, updatedIndex);
994                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
995                     revert TransferToNonERC721ReceiverImplementer();
996                 }
997                 updatedIndex++;
998             }
999 
1000             _currentIndex = updatedIndex;
1001         }
1002         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1003     }
1004 
1005     /**
1006      * @dev Transfers `tokenId` from `from` to `to`.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _transfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) private {
1020         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1021 
1022         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1023             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1024             getApproved(tokenId) == _msgSender());
1025 
1026         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1027         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1028         if (to == address(0)) revert TransferToZeroAddress();
1029 
1030         _beforeTokenTransfers(from, to, tokenId, 1);
1031 
1032         // Clear approvals from the previous owner
1033         _approve(address(0), tokenId, prevOwnership.addr);
1034 
1035         // Underflow of the sender's balance is impossible because we check for
1036         // ownership above and the recipient's balance can't realistically overflow.
1037         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1038         unchecked {
1039             _addressData[from].balance -= 1;
1040             _addressData[to].balance += 1;
1041 
1042             _ownerships[tokenId].addr = to;
1043             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1044 
1045             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1046             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1047             uint256 nextTokenId = tokenId + 1;
1048             if (_ownerships[nextTokenId].addr == address(0)) {
1049                 // This will suffice for checking _exists(nextTokenId),
1050                 // as a burned slot cannot contain the zero address.
1051                 if (nextTokenId < _currentIndex) {
1052                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1053                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1054                 }
1055             }
1056         }
1057 
1058         emit Transfer(from, to, tokenId);
1059         _afterTokenTransfers(from, to, tokenId, 1);
1060     }
1061 
1062     /**
1063      * @dev Destroys `tokenId`.
1064      * The approval is cleared when the token is burned.
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must exist.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _burn(uint256 tokenId) internal virtual {
1073         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1074 
1075         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1076 
1077         // Clear approvals from the previous owner
1078         _approve(address(0), tokenId, prevOwnership.addr);
1079 
1080         // Underflow of the sender's balance is impossible because we check for
1081         // ownership above and the recipient's balance can't realistically overflow.
1082         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1083         unchecked {
1084             _addressData[prevOwnership.addr].balance -= 1;
1085             _addressData[prevOwnership.addr].numberBurned += 1;
1086 
1087             // Keep track of who burned the token, and the timestamp of burning.
1088             _ownerships[tokenId].addr = prevOwnership.addr;
1089             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1090             _ownerships[tokenId].burned = true;
1091 
1092             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1093             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1094             uint256 nextTokenId = tokenId + 1;
1095             if (_ownerships[nextTokenId].addr == address(0)) {
1096                 // This will suffice for checking _exists(nextTokenId),
1097                 // as a burned slot cannot contain the zero address.
1098                 if (nextTokenId < _currentIndex) {
1099                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1100                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1101                 }
1102             }
1103         }
1104 
1105         emit Transfer(prevOwnership.addr, address(0), tokenId);
1106         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1107 
1108         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1109         unchecked { 
1110             _burnCounter++;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Approve `to` to operate on `tokenId`
1116      *
1117      * Emits a {Approval} event.
1118      */
1119     function _approve(
1120         address to,
1121         uint256 tokenId,
1122         address owner
1123     ) private {
1124         _tokenApprovals[tokenId] = to;
1125         emit Approval(owner, to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1130      * The call is not executed if the target address is not a contract.
1131      *
1132      * @param from address representing the previous owner of the given token ID
1133      * @param to target address that will receive the tokens
1134      * @param tokenId uint256 ID of the token to be transferred
1135      * @param _data bytes optional data to send along with the call
1136      * @return bool whether the call correctly returned the expected magic value
1137      */
1138     function _checkOnERC721Received(
1139         address from,
1140         address to,
1141         uint256 tokenId,
1142         bytes memory _data
1143     ) private returns (bool) {
1144         if (to.isContract()) {
1145             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1146                 return retval == IERC721Receiver(to).onERC721Received.selector;
1147             } catch (bytes memory reason) {
1148                 if (reason.length == 0) {
1149                     revert TransferToNonERC721ReceiverImplementer();
1150                 } else {
1151                     assembly {
1152                         revert(add(32, reason), mload(reason))
1153                     }
1154                 }
1155             }
1156         } else {
1157             return true;
1158         }
1159     }
1160 
1161     /**
1162      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1163      * And also called before burning one token.
1164      *
1165      * startTokenId - the first token id to be transferred
1166      * quantity - the amount to be transferred
1167      *
1168      * Calling conditions:
1169      *
1170      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1171      * transferred to `to`.
1172      * - When `from` is zero, `tokenId` will be minted for `to`.
1173      * - When `to` is zero, `tokenId` will be burned by `from`.
1174      * - `from` and `to` are never both zero.
1175      */
1176     function _beforeTokenTransfers(
1177         address from,
1178         address to,
1179         uint256 startTokenId,
1180         uint256 quantity
1181     ) internal virtual {}
1182 
1183     /**
1184      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1185      * minting.
1186      * And also called after one token has been burned.
1187      *
1188      * startTokenId - the first token id to be transferred
1189      * quantity - the amount to be transferred
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` has been minted for `to`.
1196      * - When `to` is zero, `tokenId` has been burned by `from`.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _afterTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 }
1206 
1207 library ECDSA {
1208     enum RecoverError {
1209         NoError,
1210         InvalidSignature,
1211         InvalidSignatureLength,
1212         InvalidSignatureS,
1213         InvalidSignatureV
1214     }
1215 
1216     function _throwError(RecoverError error) private pure {
1217         if (error == RecoverError.NoError) {
1218             return; // no error: do nothing
1219         } else if (error == RecoverError.InvalidSignature) {
1220             revert("ECDSA: invalid signature");
1221         } else if (error == RecoverError.InvalidSignatureLength) {
1222             revert("ECDSA: invalid signature length");
1223         } else if (error == RecoverError.InvalidSignatureS) {
1224             revert("ECDSA: invalid signature 's' value");
1225         } else if (error == RecoverError.InvalidSignatureV) {
1226             revert("ECDSA: invalid signature 'v' value");
1227         }
1228     }
1229 
1230     /**
1231      * @dev Returns the address that signed a hashed message (`hash`) with
1232      * `signature` or error string. This address can then be used for verification purposes.
1233      *
1234      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1235      * this function rejects them by requiring the `s` value to be in the lower
1236      * half order, and the `v` value to be either 27 or 28.
1237      *
1238      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1239      * verification to be secure: it is possible to craft signatures that
1240      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1241      * this is by receiving a hash of the original message (which may otherwise
1242      * be too long), and then calling {toEthSignedMessageHash} on it.
1243      *
1244      * Documentation for signature generation:
1245      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1246      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1247      *
1248      * _Available since v4.3._
1249      */
1250     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1251         // Check the signature length
1252         // - case 65: r,s,v signature (standard)
1253         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1254         if (signature.length == 65) {
1255             bytes32 r;
1256             bytes32 s;
1257             uint8 v;
1258             // ecrecover takes the signature parameters, and the only way to get them
1259             // currently is to use assembly.
1260             assembly {
1261                 r := mload(add(signature, 0x20))
1262                 s := mload(add(signature, 0x40))
1263                 v := byte(0, mload(add(signature, 0x60)))
1264             }
1265             return tryRecover(hash, v, r, s);
1266         } else if (signature.length == 64) {
1267             bytes32 r;
1268             bytes32 vs;
1269             // ecrecover takes the signature parameters, and the only way to get them
1270             // currently is to use assembly.
1271             assembly {
1272                 r := mload(add(signature, 0x20))
1273                 vs := mload(add(signature, 0x40))
1274             }
1275             return tryRecover(hash, r, vs);
1276         } else {
1277             return (address(0), RecoverError.InvalidSignatureLength);
1278         }
1279     }
1280 
1281     /**
1282      * @dev Returns the address that signed a hashed message (`hash`) with
1283      * `signature`. This address can then be used for verification purposes.
1284      *
1285      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1286      * this function rejects them by requiring the `s` value to be in the lower
1287      * half order, and the `v` value to be either 27 or 28.
1288      *
1289      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1290      * verification to be secure: it is possible to craft signatures that
1291      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1292      * this is by receiving a hash of the original message (which may otherwise
1293      * be too long), and then calling {toEthSignedMessageHash} on it.
1294      */
1295     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1296         (address recovered, RecoverError error) = tryRecover(hash, signature);
1297         _throwError(error);
1298         return recovered;
1299     }
1300 
1301     /**
1302      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1303      *
1304      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1305      *
1306      * _Available since v4.3._
1307      */
1308     function tryRecover(
1309         bytes32 hash,
1310         bytes32 r,
1311         bytes32 vs
1312     ) internal pure returns (address, RecoverError) {
1313         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1314         uint8 v = uint8((uint256(vs) >> 255) + 27);
1315         return tryRecover(hash, v, r, s);
1316     }
1317 
1318     /**
1319      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1320      *
1321      * _Available since v4.2._
1322      */
1323     function recover(
1324         bytes32 hash,
1325         bytes32 r,
1326         bytes32 vs
1327     ) internal pure returns (address) {
1328         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1329         _throwError(error);
1330         return recovered;
1331     }
1332 
1333     /**
1334      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1335      * `r` and `s` signature fields separately.
1336      *
1337      * _Available since v4.3._
1338      */
1339     function tryRecover(
1340         bytes32 hash,
1341         uint8 v,
1342         bytes32 r,
1343         bytes32 s
1344     ) internal pure returns (address, RecoverError) {
1345         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1346         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1347         // the valid range for s in (301): 0 < s < secp256k1n � 2 + 1, and for v in (302): v ? {27, 28}. Most
1348         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1349         //
1350         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1351         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1352         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1353         // these malleable signatures as well.
1354         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1355             return (address(0), RecoverError.InvalidSignatureS);
1356         }
1357         if (v != 27 && v != 28) {
1358             return (address(0), RecoverError.InvalidSignatureV);
1359         }
1360 
1361         // If the signature is valid (and not malleable), return the signer address
1362         address signer = ecrecover(hash, v, r, s);
1363         if (signer == address(0)) {
1364             return (address(0), RecoverError.InvalidSignature);
1365         }
1366 
1367         return (signer, RecoverError.NoError);
1368     }
1369 
1370     /**
1371      * @dev Overload of {ECDSA-recover} that receives the `v`,
1372      * `r` and `s` signature fields separately.
1373      */
1374     function recover(
1375         bytes32 hash,
1376         uint8 v,
1377         bytes32 r,
1378         bytes32 s
1379     ) internal pure returns (address) {
1380         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1381         _throwError(error);
1382         return recovered;
1383     }
1384 
1385     /**
1386      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1387      * produces hash corresponding to the one signed with the
1388      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1389      * JSON-RPC method as part of EIP-191.
1390      *
1391      * See {recover}.
1392      */
1393     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1394         // 32 is the length in bytes of hash,
1395         // enforced by the type signature above
1396         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1397     }
1398 
1399     /**
1400      * @dev Returns an Ethereum Signed Message, created from `s`. This
1401      * produces hash corresponding to the one signed with the
1402      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1403      * JSON-RPC method as part of EIP-191.
1404      *
1405      * See {recover}.
1406      */
1407     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1408         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1409     }
1410 
1411     /**
1412      * @dev Returns an Ethereum Signed Typed Data, created from a
1413      * `domainSeparator` and a `structHash`. This produces hash corresponding
1414      * to the one signed with the
1415      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1416      * JSON-RPC method as part of EIP-712.
1417      *
1418      * See {recover}.
1419      */
1420     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1421         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1422     }
1423 }
1424 abstract contract EIP712 {
1425     /* solhint-disable var-name-mixedcase */
1426     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1427     // invalidate the cached domain separator if the chain id changes.
1428     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1429     uint256 private immutable _CACHED_CHAIN_ID;
1430     address private immutable _CACHED_THIS;
1431 
1432     bytes32 private immutable _HASHED_NAME;
1433     bytes32 private immutable _HASHED_VERSION;
1434     bytes32 private immutable _TYPE_HASH;
1435 
1436     /* solhint-enable var-name-mixedcase */
1437 
1438     /**
1439      * @dev Initializes the domain separator and parameter caches.
1440      *
1441      * The meaning of `name` and `version` is specified in
1442      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1443      *
1444      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1445      * - `version`: the current major version of the signing domain.
1446      *
1447      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1448      * contract upgrade].
1449      */
1450     constructor(string memory name, string memory version) {
1451         bytes32 hashedName = keccak256(bytes(name));
1452         bytes32 hashedVersion = keccak256(bytes(version));
1453         bytes32 typeHash = keccak256(
1454             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1455         );
1456         _HASHED_NAME = hashedName;
1457         _HASHED_VERSION = hashedVersion;
1458         _CACHED_CHAIN_ID = block.chainid;
1459         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1460         _CACHED_THIS = address(this);
1461         _TYPE_HASH = typeHash;
1462     }
1463 
1464     /**
1465      * @dev Returns the domain separator for the current chain.
1466      */
1467     function _domainSeparatorV4() internal view returns (bytes32) {
1468         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1469             return _CACHED_DOMAIN_SEPARATOR;
1470         } else {
1471             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1472         }
1473     }
1474 
1475     function _buildDomainSeparator(
1476         bytes32 typeHash,
1477         bytes32 nameHash,
1478         bytes32 versionHash
1479     ) private view returns (bytes32) {
1480         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1481     }
1482 
1483     /**
1484      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1485      * function returns the hash of the fully encoded EIP712 message for this domain.
1486      *
1487      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1488      *
1489      * ```solidity
1490      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1491      *     keccak256("Mail(address to,string contents)"),
1492      *     mailTo,
1493      *     keccak256(bytes(mailContents))
1494      * )));
1495      * address signer = ECDSA.recover(digest, signature);
1496      * ```
1497      */
1498     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1499         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1500     }
1501 }
1502 
1503 contract Furried is Ownable, ERC721A {
1504 
1505     uint256 public walletMax = 2;
1506     using Strings for uint256;
1507 
1508     mapping(uint256 => string) private _tokenURIs;
1509     bool public publicSaleOpen = false;
1510     string public baseURI = "ipfs://willbeupdated/";
1511     string public _extension = ".json";
1512     uint256 public price = 0 ether;
1513     uint256 public maxSupply = 1533;
1514 
1515     constructor() ERC721A("Furried", "FURIED"){}
1516     
1517     function mintNFT(uint256 _quantity) public payable {
1518         require(_quantity > 0 && _quantity <= walletMax, "Wallet full, check max per wallet!");
1519         require(totalSupply() + _quantity <= maxSupply, "Reached max supply!");
1520         require(msg.value == price * _quantity, "Needs to send more ETH!");
1521         require(getMintedCount(msg.sender) + _quantity <= walletMax, "Exceeded max minting amount!");
1522         require(publicSaleOpen, "Public sale not yet started!");
1523 
1524         _safeMint(msg.sender, _quantity);
1525 
1526     }
1527 
1528 
1529     function sendGifts(address[] memory _wallets) external onlyOwner{
1530         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
1531         for(uint i = 0; i < _wallets.length; i++)
1532             _safeMint(_wallets[i], 1);
1533 
1534     }
1535    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
1536                require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
1537             _safeMint(_wallet, _num);
1538     }
1539 
1540 
1541     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1542         require(
1543             _exists(_tokenId),
1544             "ERC721Metadata: URI set of nonexistent token"
1545         );
1546 
1547         return string(abi.encodePacked(baseURI, _tokenId.toString(), _extension));
1548     }
1549 
1550     function updateBaseURI(string memory _newBaseURI) onlyOwner public {
1551         baseURI = _newBaseURI;
1552     }
1553     function updateExtension(string memory _temp) onlyOwner public {
1554         _extension = _temp;
1555     }
1556 
1557     function getBaseURI() external view returns(string memory) {
1558         return baseURI;
1559     }
1560 
1561     function setPrice(uint256 _price) public onlyOwner() {
1562         price = _price;
1563     }
1564     function setWalletMaxs(uint256 _walletMax) public onlyOwner() {
1565         walletMax = _walletMax;
1566     }
1567 
1568     function setmaxSupply(uint256 _supply) public onlyOwner() {
1569         require(_supply <= 5858, "Error: New max supply cant be higher than original max.");
1570         maxSupply = _supply;
1571     }
1572 
1573     function toggleSale() public onlyOwner() {
1574         publicSaleOpen = !publicSaleOpen;
1575     }
1576 
1577 
1578     function getBalance() public view returns(uint) {
1579         return address(this).balance;
1580     }
1581 
1582     function getMintedCount(address owner) public view returns (uint256) {
1583     return _numberMinted(owner);
1584   }
1585 
1586     function withdraw() external onlyOwner {
1587         uint _balance = address(this).balance;
1588         payable(owner()).transfer(_balance); //Owner
1589     }
1590 
1591     function getOwnershipData(uint256 tokenId)
1592     external
1593     view
1594     returns (TokenOwnership memory)
1595   {
1596     return ownershipOf(tokenId);
1597   }
1598     receive() external payable {}
1599 }