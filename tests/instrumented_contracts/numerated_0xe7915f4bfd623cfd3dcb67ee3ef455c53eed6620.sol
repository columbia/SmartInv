1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 //                                ,----,                        
5 //          ,--.                ,/   .`|                        
6 //        ,--.'|    ,---,.    ,`   .'  :                        
7 //    ,--,:  : |  ,'  .' |  ;    ;     /     ,---.              
8 // ,`--.'`|  ' :,---.'   |.'___,/    ,'     /__./|       ,----, 
9 // |   :  :  | ||   |   .'|    :     | ,---.;  ; |     .'   .`| 
10 // :   |   \ | ::   :  :  ;    |.';  ;/___/ \  | |  .'   .'  .' 
11 // |   : '  '; |:   |  |-,`----'  |  |\   ;  \ ' |,---, '   ./  
12 // '   ' ;.    ;|   :  ;/|    '   :  ; \   \  \: |;   | .'  /   
13 // |   | | \   ||   |   .'    |   |  '  ;   \  ' .`---' /  ;--, 
14 // '   : |  ; .''   :  '      '   :  |   \   \   '  /  /  / .`| 
15 // |   | '`--'  |   |  |      ;   |.'     \   `  ;./__;     .'  
16 // '   : |      |   :  \      '---'        :   \ |;   |  .'     
17 // ;   |.'      |   | ,'                    '---" `---'         
18 // '---'        `----'                                          
19 // ========================== NFTVz ==========================
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev String operations.
44  */
45 library Strings {
46     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
50      */
51     function toString(uint256 value) internal pure returns (string memory) {
52         // Inspired by OraclizeAPI's implementation - MIT licence
53         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
54 
55         if (value == 0) {
56             return "0";
57         }
58         uint256 temp = value;
59         uint256 digits;
60         while (temp != 0) {
61             digits++;
62             temp /= 10;
63         }
64         bytes memory buffer = new bytes(digits);
65         while (value != 0) {
66             digits -= 1;
67             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
68             value /= 10;
69         }
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
75      */
76     function toHexString(uint256 value) internal pure returns (string memory) {
77         if (value == 0) {
78             return "0x00";
79         }
80         uint256 temp = value;
81         uint256 length = 0;
82         while (temp != 0) {
83             length++;
84             temp >>= 8;
85         }
86         return toHexString(value, length);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
91      */
92     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
93         bytes memory buffer = new bytes(2 * length + 2);
94         buffer[0] = "0";
95         buffer[1] = "x";
96         for (uint256 i = 2 * length + 1; i > 1; --i) {
97             buffer[i] = _HEX_SYMBOLS[value & 0xf];
98             value >>= 4;
99         }
100         require(value == 0, "Strings: hex length insufficient");
101         return string(buffer);
102     }
103 }
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Collection of functions related to the address type
108  */
109 library Address {
110     /**
111      * @dev Returns true if `account` is a contract.
112      *
113      * [IMPORTANT]
114      * ====
115      * It is unsafe to assume that an address for which this function returns
116      * false is an externally-owned account (EOA) and not a contract.
117      *
118      * Among others, `isContract` will return false for the following
119      * types of addresses:
120      *
121      *  - an externally-owned account
122      *  - a contract in construction
123      *  - an address where a contract will be created
124      *  - an address where a contract lived, but was destroyed
125      * ====
126      */
127     function isContract(address account) internal view returns (bool) {
128         // This method relies on extcodesize, which returns 0 for contracts in
129         // construction, since the code is only stored at the end of the
130         // constructor execution.
131 
132         uint256 size;
133         assembly {
134             size := extcodesize(account)
135         }
136         return size > 0;
137     }
138 
139     /**
140      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
141      * `recipient`, forwarding all available gas and reverting on errors.
142      *
143      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
144      * of certain opcodes, possibly making contracts go over the 2300 gas limit
145      * imposed by `transfer`, making them unable to receive funds via
146      * `transfer`. {sendValue} removes this limitation.
147      *
148      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
149      *
150      * IMPORTANT: because control is transferred to `recipient`, care must be
151      * taken to not create reentrancy vulnerabilities. Consider using
152      * {ReentrancyGuard} or the
153      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
154      */
155     function sendValue(address payable recipient, uint256 amount) internal {
156         require(address(this).balance >= amount, "Address: insufficient balance");
157 
158         (bool success, ) = recipient.call{value: amount}("");
159         require(success, "Address: unable to send value, recipient may have reverted");
160     }
161 
162     /**
163      * @dev Performs a Solidity function call using a low level `call`. A
164      * plain `call` is an unsafe replacement for a function call: use this
165      * function instead.
166      *
167      * If `target` reverts with a revert reason, it is bubbled up by this
168      * function (like regular Solidity function calls).
169      *
170      * Returns the raw returned data. To convert to the expected return value,
171      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
172      *
173      * Requirements:
174      *
175      * - `target` must be a contract.
176      * - calling `target` with `data` must not revert.
177      *
178      * _Available since v3.1._
179      */
180     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
181         return functionCall(target, data, "Address: low-level call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
186      * `errorMessage` as a fallback revert reason when `target` reverts.
187      *
188      * _Available since v3.1._
189      */
190     function functionCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal returns (bytes memory) {
195         return functionCallWithValue(target, data, 0, errorMessage);
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
200      * but also transferring `value` wei to `target`.
201      *
202      * Requirements:
203      *
204      * - the calling contract must have an ETH balance of at least `value`.
205      * - the called Solidity function must be `payable`.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
219      * with `errorMessage` as a fallback revert reason when `target` reverts.
220      *
221      * _Available since v3.1._
222      */
223     function functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 value,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         require(address(this).balance >= value, "Address: insufficient balance for call");
230         require(isContract(target), "Address: call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.call{value: value}(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a static call.
239      *
240      * _Available since v3.3._
241      */
242     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
243         return functionStaticCall(target, data, "Address: low-level static call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a static call.
249      *
250      * _Available since v3.3._
251      */
252     function functionStaticCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal view returns (bytes memory) {
257         require(isContract(target), "Address: static call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.staticcall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a delegate call.
266      *
267      * _Available since v3.4._
268      */
269     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a delegate call.
276      *
277      * _Available since v3.4._
278      */
279     function functionDelegateCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         require(isContract(target), "Address: delegate call to non-contract");
285 
286         (bool success, bytes memory returndata) = target.delegatecall(data);
287         return verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     /**
291      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
292      * revert reason using the provided one.
293      *
294      * _Available since v4.3._
295      */
296     function verifyCallResult(
297         bool success,
298         bytes memory returndata,
299         string memory errorMessage
300     ) internal pure returns (bytes memory) {
301         if (success) {
302             return returndata;
303         } else {
304             // Look for revert reason and bubble it up if present
305             if (returndata.length > 0) {
306                 // The easiest way to bubble the revert reason is using memory via assembly
307 
308                 assembly {
309                     let returndata_size := mload(returndata)
310                     revert(add(32, returndata), returndata_size)
311                 }
312             } else {
313                 revert(errorMessage);
314             }
315         }
316     }
317 }
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Interface of the ERC165 standard, as defined in the
322  * https://eips.ethereum.org/EIPS/eip-165[EIP].
323  *
324  * Implementers can declare support of contract interfaces, which can then be
325  * queried by others ({ERC165Checker}).
326  *
327  * For an implementation, see {ERC165}.
328  */
329 interface IERC165 {
330     /**
331      * @dev Returns true if this contract implements the interface defined by
332      * `interfaceId`. See the corresponding
333      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
334      * to learn more about how these ids are created.
335      *
336      * This function call must use less than 30 000 gas.
337      */
338     function supportsInterface(bytes4 interfaceId) external view returns (bool);
339 }
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @title ERC721 token receiver interface
344  * @dev Interface for any contract that wants to support safeTransfers
345  * from ERC721 asset contracts.
346  */
347 interface IERC721Receiver {
348     /**
349      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
350      * by `operator` from `from`, this function is called.
351      *
352      * It must return its Solidity selector to confirm the token transfer.
353      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
354      *
355      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
356      */
357     function onERC721Received(
358         address operator,
359         address from,
360         uint256 tokenId,
361         bytes calldata data
362     ) external returns (bytes4);
363 }
364 pragma solidity ^0.8.0;
365 
366 
367 /**
368  * @dev Contract module which provides a basic access control mechanism, where
369  * there is an account (an owner) that can be granted exclusive access to
370  * specific functions.
371  *
372  * By default, the owner account will be the one that deploys the contract. This
373  * can later be changed with {transferOwnership}.
374  *
375  * This module is used through inheritance. It will make available the modifier
376  * `onlyOwner`, which can be applied to your functions to restrict their use to
377  * the owner.
378  */
379 abstract contract Ownable is Context {
380     address private _owner;
381 
382     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
383 
384     /**
385      * @dev Initializes the contract setting the deployer as the initial owner.
386      */
387     constructor() {
388         _setOwner(_msgSender());
389     }
390 
391     /**
392      * @dev Returns the address of the current owner.
393      */
394     function owner() public view virtual returns (address) {
395         return _owner;
396     }
397 
398     /**
399      * @dev Throws if called by any account other than the owner.
400      */
401     modifier onlyOwner() {
402         require(owner() == _msgSender(), "Ownable: caller is not the owner");
403         _;
404     }
405 
406     /**
407      * @dev Leaves the contract without owner. It will not be possible to call
408      * `onlyOwner` functions anymore. Can only be called by the current owner.
409      *
410      * NOTE: Renouncing ownership will leave the contract without an owner,
411      * thereby removing any functionality that is only available to the owner.
412      */
413     function renounceOwnership() public virtual onlyOwner {
414         _setOwner(address(0));
415     }
416 
417     /**
418      * @dev Transfers ownership of the contract to a new account (`newOwner`).
419      * Can only be called by the current owner.
420      */
421     function transferOwnership(address newOwner) public virtual onlyOwner {
422         require(newOwner != address(0), "Ownable: new owner is the zero address");
423         _setOwner(newOwner);
424     }
425 
426     function _setOwner(address newOwner) private {
427         address oldOwner = _owner;
428         _owner = newOwner;
429         emit OwnershipTransferred(oldOwner, newOwner);
430     }
431 }
432 pragma solidity ^0.8.0;
433 
434 
435 /**
436  * @dev Implementation of the {IERC165} interface.
437  *
438  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
439  * for the additional interface id that will be supported. For example:
440  *
441  * ```solidity
442  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
443  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
444  * }
445  * ```
446  *
447  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
448  */
449 abstract contract ERC165 is IERC165 {
450     /**
451      * @dev See {IERC165-supportsInterface}.
452      */
453     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
454         return interfaceId == type(IERC165).interfaceId;
455     }
456 }
457 pragma solidity ^0.8.0;
458 
459 
460 /**
461  * @dev Required interface of an ERC721 compliant contract.
462  */
463 interface IERC721 is IERC165 {
464     /**
465      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
466      */
467     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
468 
469     /**
470      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
471      */
472     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
473 
474     /**
475      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
476      */
477     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
478 
479     /**
480      * @dev Returns the number of tokens in ``owner``'s account.
481      */
482     function balanceOf(address owner) external view returns (uint256 balance);
483 
484     /**
485      * @dev Returns the owner of the `tokenId` token.
486      *
487      * Requirements:
488      *
489      * - `tokenId` must exist.
490      */
491     function ownerOf(uint256 tokenId) external view returns (address owner);
492 
493     /**
494      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
495      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must exist and be owned by `from`.
502      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
503      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
504      *
505      * Emits a {Transfer} event.
506      */
507     function safeTransferFrom(
508         address from,
509         address to,
510         uint256 tokenId
511     ) external;
512 
513     /**
514      * @dev Transfers `tokenId` token from `from` to `to`.
515      *
516      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
517      *
518      * Requirements:
519      *
520      * - `from` cannot be the zero address.
521      * - `to` cannot be the zero address.
522      * - `tokenId` token must be owned by `from`.
523      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
524      *
525      * Emits a {Transfer} event.
526      */
527     function transferFrom(
528         address from,
529         address to,
530         uint256 tokenId
531     ) external;
532 
533     /**
534      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
535      * The approval is cleared when the token is transferred.
536      *
537      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
538      *
539      * Requirements:
540      *
541      * - The caller must own the token or be an approved operator.
542      * - `tokenId` must exist.
543      *
544      * Emits an {Approval} event.
545      */
546     function approve(address to, uint256 tokenId) external;
547 
548     /**
549      * @dev Returns the account approved for `tokenId` token.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      */
555     function getApproved(uint256 tokenId) external view returns (address operator);
556 
557     /**
558      * @dev Approve or remove `operator` as an operator for the caller.
559      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
560      *
561      * Requirements:
562      *
563      * - The `operator` cannot be the caller.
564      *
565      * Emits an {ApprovalForAll} event.
566      */
567     function setApprovalForAll(address operator, bool _approved) external;
568 
569     /**
570      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
571      *
572      * See {setApprovalForAll}
573      */
574     function isApprovedForAll(address owner, address operator) external view returns (bool);
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
585      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
586      *
587      * Emits a {Transfer} event.
588      */
589     function safeTransferFrom(
590         address from,
591         address to,
592         uint256 tokenId,
593         bytes calldata data
594     ) external;
595 }
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
601  * @dev See https://eips.ethereum.org/EIPS/eip-721
602  */
603 interface IERC721Metadata is IERC721 {
604     /**
605      * @dev Returns the token collection name.
606      */
607     function name() external view returns (string memory);
608 
609     /**
610      * @dev Returns the token collection symbol.
611      */
612     function symbol() external view returns (string memory);
613 
614     /**
615      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
616      */
617     function tokenURI(uint256 tokenId) external view returns (string memory);
618 }
619 interface IERC721Enumerable is IERC721 {
620     /**
621      * @dev Returns the total amount of tokens stored by the contract.
622      */
623     function totalSupply() external view returns (uint256);
624 
625     /**
626      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
627      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
628      */
629     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
630 
631     /**
632      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
633      * Use along with {totalSupply} to enumerate all tokens.
634      */
635     function tokenByIndex(uint256 index) external view returns (uint256);
636 }
637 error ApprovalCallerNotOwnerNorApproved();
638 error ApprovalQueryForNonexistentToken();
639 error ApproveToCaller();
640 error ApprovalToCurrentOwner();
641 error BalanceQueryForZeroAddress();
642 error MintedQueryForZeroAddress();
643 error BurnedQueryForZeroAddress();
644 error AuxQueryForZeroAddress();
645 error MintToZeroAddress();
646 error MintZeroQuantity();
647 error OwnerIndexOutOfBounds();
648 error OwnerQueryForNonexistentToken();
649 error TokenIndexOutOfBounds();
650 error TransferCallerNotOwnerNorApproved();
651 error TransferFromIncorrectOwner();
652 error TransferToNonERC721ReceiverImplementer();
653 error TransferToZeroAddress();
654 error URIQueryForNonexistentToken();
655 
656 /**
657  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
658  * the Metadata extension. Built to optimize for lower gas during batch mints.
659  *
660  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
661  *
662  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
663  *
664  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
665  */
666 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
667     using Address for address;
668     using Strings for uint256;
669 
670     // Compiler will pack this into a single 256bit word.
671     struct TokenOwnership {
672         // The address of the owner.
673         address addr;
674         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
675         uint64 startTimestamp;
676         // Whether the token has been burned.
677         bool burned;
678     }
679 
680     // Compiler will pack this into a single 256bit word.
681     struct AddressData {
682         // Realistically, 2**64-1 is more than enough.
683         uint64 balance;
684         // Keeps track of mint count with minimal overhead for tokenomics.
685         uint64 numberMinted;
686         // Keeps track of burn count with minimal overhead for tokenomics.
687         uint64 numberBurned;
688         // For miscellaneous variable(s) pertaining to the address
689         // (e.g. number of whitelist mint slots used). 
690         // If there are multiple variables, please pack them into a uint64.
691         uint64 aux;
692     }
693 
694     // The tokenId of the next token to be minted.
695     uint256 internal _currentIndex = 1;
696 
697     // The number of tokens burned.
698     uint256 internal _burnCounter;
699 
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Mapping from token ID to ownership details
707     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
708     mapping(uint256 => TokenOwnership) internal _ownerships;
709 
710     // Mapping owner address to address data
711     mapping(address => AddressData) private _addressData;
712 
713     // Mapping from token ID to approved address
714     mapping(uint256 => address) private _tokenApprovals;
715 
716     // Mapping from owner to operator approvals
717     mapping(address => mapping(address => bool)) private _operatorApprovals;
718 
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722     }
723 
724     /**
725      * @dev See {IERC721Enumerable-totalSupply}.
726      */
727     function totalSupply() public view returns (uint256) {
728         // Counter underflow is impossible as _burnCounter cannot be incremented
729         // more than _currentIndex times
730         unchecked {
731             return (_currentIndex - _burnCounter) - 1;    
732         }
733     }
734 
735     /**
736      * @dev See {IERC165-supportsInterface}.
737      */
738     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
739         return
740             interfaceId == type(IERC721).interfaceId ||
741             interfaceId == type(IERC721Metadata).interfaceId ||
742             super.supportsInterface(interfaceId);
743     }
744 
745     /**
746      * @dev See {IERC721-balanceOf}.
747      */
748     function balanceOf(address owner) public view override returns (uint256) {
749         if (owner == address(0)) revert BalanceQueryForZeroAddress();
750         return uint256(_addressData[owner].balance);
751     }
752 
753     /**
754      * Returns the number of tokens minted by `owner`.
755      */
756     function _numberMinted(address owner) internal view returns (uint256) {
757         if (owner == address(0)) revert MintedQueryForZeroAddress();
758         return uint256(_addressData[owner].numberMinted);
759     }
760 
761     /**
762      * Returns the number of tokens burned by or on behalf of `owner`.
763      */
764     function _numberBurned(address owner) internal view returns (uint256) {
765         if (owner == address(0)) revert BurnedQueryForZeroAddress();
766         return uint256(_addressData[owner].numberBurned);
767     }
768 
769     /**
770      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
771      */
772     function _getAux(address owner) internal view returns (uint64) {
773         if (owner == address(0)) revert AuxQueryForZeroAddress();
774         return _addressData[owner].aux;
775     }
776 
777     /**
778      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
779      * If there are multiple variables, please pack them into a uint64.
780      */
781     function _setAux(address owner, uint64 aux) internal {
782         if (owner == address(0)) revert AuxQueryForZeroAddress();
783         _addressData[owner].aux = aux;
784     }
785 
786     /**
787      * Gas spent here starts off proportional to the maximum mint batch size.
788      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
789      */
790     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
791         uint256 curr = tokenId;
792 
793         unchecked {
794             if (curr < _currentIndex) {
795                 TokenOwnership memory ownership = _ownerships[curr];
796                 if (!ownership.burned) {
797                     if (ownership.addr != address(0)) {
798                         return ownership;
799                     }
800                     // Invariant: 
801                     // There will always be an ownership that has an address and is not burned 
802                     // before an ownership that does not have an address and is not burned.
803                     // Hence, curr will not underflow.
804                     while (true) {
805                         curr--;
806                         ownership = _ownerships[curr];
807                         if (ownership.addr != address(0)) {
808                             return ownership;
809                         }
810                     }
811                 }
812             }
813         }
814         revert OwnerQueryForNonexistentToken();
815     }
816 
817     /**
818      * @dev See {IERC721-ownerOf}.
819      */
820     function ownerOf(uint256 tokenId) public view override returns (address) {
821         return ownershipOf(tokenId).addr;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-name}.
826      */
827     function name() public view virtual override returns (string memory) {
828         return _name;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-symbol}.
833      */
834     function symbol() public view virtual override returns (string memory) {
835         return _symbol;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-tokenURI}.
840      */
841     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
842         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
843 
844         string memory baseURI = _baseURI();
845         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
846     }
847 
848     /**
849      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
850      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
851      * by default, can be overriden in child contracts.
852      */
853     function _baseURI() internal view virtual returns (string memory) {
854         return '';
855     }
856 
857     /**
858      * @dev See {IERC721-approve}.
859      */
860     function approve(address to, uint256 tokenId) public override {
861         address owner = ERC721A.ownerOf(tokenId);
862         if (to == owner) revert ApprovalToCurrentOwner();
863 
864         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
865             revert ApprovalCallerNotOwnerNorApproved();
866         }
867 
868         _approve(to, tokenId, owner);
869     }
870 
871     /**
872      * @dev See {IERC721-getApproved}.
873      */
874     function getApproved(uint256 tokenId) public view override returns (address) {
875         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
876 
877         return _tokenApprovals[tokenId];
878     }
879 
880     /**
881      * @dev See {IERC721-setApprovalForAll}.
882      */
883     function setApprovalForAll(address operator, bool approved) public override {
884         if (operator == _msgSender()) revert ApproveToCaller();
885 
886         _operatorApprovals[_msgSender()][operator] = approved;
887         emit ApprovalForAll(_msgSender(), operator, approved);
888     }
889 
890     /**
891      * @dev See {IERC721-isApprovedForAll}.
892      */
893     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
894         return _operatorApprovals[owner][operator];
895     }
896 
897     /**
898      * @dev See {IERC721-transferFrom}.
899      */
900     function transferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         _transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public virtual override {
916         safeTransferFrom(from, to, tokenId, '');
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) public virtual override {
928         _transfer(from, to, tokenId);
929         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
930             revert TransferToNonERC721ReceiverImplementer();
931         }
932     }
933 
934     /**
935      * @dev Returns whether `tokenId` exists.
936      *
937      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
938      *
939      * Tokens start existing when they are minted (`_mint`),
940      */
941     function _exists(uint256 tokenId) internal view returns (bool) {
942         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
943     }
944 
945     function _safeMint(address to, uint256 quantity) internal {
946         _safeMint(to, quantity, '');
947     }
948 
949     /**
950      * @dev Safely mints `quantity` tokens and transfers them to `to`.
951      *
952      * Requirements:
953      *
954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
955      * - `quantity` must be greater than 0.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _safeMint(
960         address to,
961         uint256 quantity,
962         bytes memory _data
963     ) internal {
964         _mint(to, quantity, _data, true);
965     }
966 
967     /**
968      * @dev Mints `quantity` tokens and transfers them to `to`.
969      *
970      * Requirements:
971      *
972      * - `to` cannot be the zero address.
973      * - `quantity` must be greater than 0.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _mint(
978         address to,
979         uint256 quantity,
980         bytes memory _data,
981         bool safe
982     ) internal {
983         uint256 startTokenId = _currentIndex;
984         if (to == address(0)) revert MintToZeroAddress();
985         if (quantity == 0) revert MintZeroQuantity();
986 
987         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
988 
989         // Overflows are incredibly unrealistic.
990         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
991         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
992         unchecked {
993             _addressData[to].balance += uint64(quantity);
994             _addressData[to].numberMinted += uint64(quantity);
995 
996             _ownerships[startTokenId].addr = to;
997             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
998 
999             uint256 updatedIndex = startTokenId;
1000 
1001             for (uint256 i; i < quantity; i++) {
1002                 emit Transfer(address(0), to, updatedIndex);
1003                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1004                     revert TransferToNonERC721ReceiverImplementer();
1005                 }
1006                 updatedIndex++;
1007             }
1008 
1009             _currentIndex = updatedIndex;
1010         }
1011         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1012     }
1013 
1014     /**
1015      * @dev Transfers `tokenId` from `from` to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must be owned by `from`.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _transfer(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) private {
1029         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1030 
1031         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1032             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1033             getApproved(tokenId) == _msgSender());
1034 
1035         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1036         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1037         if (to == address(0)) revert TransferToZeroAddress();
1038 
1039         _beforeTokenTransfers(from, to, tokenId, 1);
1040 
1041         // Clear approvals from the previous owner
1042         _approve(address(0), tokenId, prevOwnership.addr);
1043 
1044         // Underflow of the sender's balance is impossible because we check for
1045         // ownership above and the recipient's balance can't realistically overflow.
1046         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1047         unchecked {
1048             _addressData[from].balance -= 1;
1049             _addressData[to].balance += 1;
1050 
1051             _ownerships[tokenId].addr = to;
1052             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1053 
1054             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1055             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1056             uint256 nextTokenId = tokenId + 1;
1057             if (_ownerships[nextTokenId].addr == address(0)) {
1058                 // This will suffice for checking _exists(nextTokenId),
1059                 // as a burned slot cannot contain the zero address.
1060                 if (nextTokenId < _currentIndex) {
1061                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1062                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1063                 }
1064             }
1065         }
1066 
1067         emit Transfer(from, to, tokenId);
1068         _afterTokenTransfers(from, to, tokenId, 1);
1069     }
1070 
1071     /**
1072      * @dev Destroys `tokenId`.
1073      * The approval is cleared when the token is burned.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _burn(uint256 tokenId) internal virtual {
1082         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1083 
1084         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1085 
1086         // Clear approvals from the previous owner
1087         _approve(address(0), tokenId, prevOwnership.addr);
1088 
1089         // Underflow of the sender's balance is impossible because we check for
1090         // ownership above and the recipient's balance can't realistically overflow.
1091         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1092         unchecked {
1093             _addressData[prevOwnership.addr].balance -= 1;
1094             _addressData[prevOwnership.addr].numberBurned += 1;
1095 
1096             // Keep track of who burned the token, and the timestamp of burning.
1097             _ownerships[tokenId].addr = prevOwnership.addr;
1098             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1099             _ownerships[tokenId].burned = true;
1100 
1101             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1102             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1103             uint256 nextTokenId = tokenId + 1;
1104             if (_ownerships[nextTokenId].addr == address(0)) {
1105                 // This will suffice for checking _exists(nextTokenId),
1106                 // as a burned slot cannot contain the zero address.
1107                 if (nextTokenId < _currentIndex) {
1108                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1109                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1110                 }
1111             }
1112         }
1113 
1114         emit Transfer(prevOwnership.addr, address(0), tokenId);
1115         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1116 
1117         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1118         unchecked { 
1119             _burnCounter++;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Approve `to` to operate on `tokenId`
1125      *
1126      * Emits a {Approval} event.
1127      */
1128     function _approve(
1129         address to,
1130         uint256 tokenId,
1131         address owner
1132     ) private {
1133         _tokenApprovals[tokenId] = to;
1134         emit Approval(owner, to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1139      * The call is not executed if the target address is not a contract.
1140      *
1141      * @param from address representing the previous owner of the given token ID
1142      * @param to target address that will receive the tokens
1143      * @param tokenId uint256 ID of the token to be transferred
1144      * @param _data bytes optional data to send along with the call
1145      * @return bool whether the call correctly returned the expected magic value
1146      */
1147     function _checkOnERC721Received(
1148         address from,
1149         address to,
1150         uint256 tokenId,
1151         bytes memory _data
1152     ) private returns (bool) {
1153         if (to.isContract()) {
1154             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1155                 return retval == IERC721Receiver(to).onERC721Received.selector;
1156             } catch (bytes memory reason) {
1157                 if (reason.length == 0) {
1158                     revert TransferToNonERC721ReceiverImplementer();
1159                 } else {
1160                     assembly {
1161                         revert(add(32, reason), mload(reason))
1162                     }
1163                 }
1164             }
1165         } else {
1166             return true;
1167         }
1168     }
1169 
1170     /**
1171      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1172      * And also called before burning one token.
1173      *
1174      * startTokenId - the first token id to be transferred
1175      * quantity - the amount to be transferred
1176      *
1177      * Calling conditions:
1178      *
1179      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1180      * transferred to `to`.
1181      * - When `from` is zero, `tokenId` will be minted for `to`.
1182      * - When `to` is zero, `tokenId` will be burned by `from`.
1183      * - `from` and `to` are never both zero.
1184      */
1185     function _beforeTokenTransfers(
1186         address from,
1187         address to,
1188         uint256 startTokenId,
1189         uint256 quantity
1190     ) internal virtual {}
1191 
1192     /**
1193      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1194      * minting.
1195      * And also called after one token has been burned.
1196      *
1197      * startTokenId - the first token id to be transferred
1198      * quantity - the amount to be transferred
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` has been minted for `to`.
1205      * - When `to` is zero, `tokenId` has been burned by `from`.
1206      * - `from` and `to` are never both zero.
1207      */
1208     function _afterTokenTransfers(
1209         address from,
1210         address to,
1211         uint256 startTokenId,
1212         uint256 quantity
1213     ) internal virtual {}
1214 }
1215 
1216 library ECDSA {
1217     enum RecoverError {
1218         NoError,
1219         InvalidSignature,
1220         InvalidSignatureLength,
1221         InvalidSignatureS,
1222         InvalidSignatureV
1223     }
1224 
1225     function _throwError(RecoverError error) private pure {
1226         if (error == RecoverError.NoError) {
1227             return; // no error: do nothing
1228         } else if (error == RecoverError.InvalidSignature) {
1229             revert("ECDSA: invalid signature");
1230         } else if (error == RecoverError.InvalidSignatureLength) {
1231             revert("ECDSA: invalid signature length");
1232         } else if (error == RecoverError.InvalidSignatureS) {
1233             revert("ECDSA: invalid signature 's' value");
1234         } else if (error == RecoverError.InvalidSignatureV) {
1235             revert("ECDSA: invalid signature 'v' value");
1236         }
1237     }
1238 
1239     /**
1240      * @dev Returns the address that signed a hashed message (`hash`) with
1241      * `signature` or error string. This address can then be used for verification purposes.
1242      *
1243      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1244      * this function rejects them by requiring the `s` value to be in the lower
1245      * half order, and the `v` value to be either 27 or 28.
1246      *
1247      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1248      * verification to be secure: it is possible to craft signatures that
1249      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1250      * this is by receiving a hash of the original message (which may otherwise
1251      * be too long), and then calling {toEthSignedMessageHash} on it.
1252      *
1253      * Documentation for signature generation:
1254      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1255      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1256      *
1257      * _Available since v4.3._
1258      */
1259     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1260         // Check the signature length
1261         // - case 65: r,s,v signature (standard)
1262         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1263         if (signature.length == 65) {
1264             bytes32 r;
1265             bytes32 s;
1266             uint8 v;
1267             // ecrecover takes the signature parameters, and the only way to get them
1268             // currently is to use assembly.
1269             assembly {
1270                 r := mload(add(signature, 0x20))
1271                 s := mload(add(signature, 0x40))
1272                 v := byte(0, mload(add(signature, 0x60)))
1273             }
1274             return tryRecover(hash, v, r, s);
1275         } else if (signature.length == 64) {
1276             bytes32 r;
1277             bytes32 vs;
1278             // ecrecover takes the signature parameters, and the only way to get them
1279             // currently is to use assembly.
1280             assembly {
1281                 r := mload(add(signature, 0x20))
1282                 vs := mload(add(signature, 0x40))
1283             }
1284             return tryRecover(hash, r, vs);
1285         } else {
1286             return (address(0), RecoverError.InvalidSignatureLength);
1287         }
1288     }
1289 
1290     /**
1291      * @dev Returns the address that signed a hashed message (`hash`) with
1292      * `signature`. This address can then be used for verification purposes.
1293      *
1294      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1295      * this function rejects them by requiring the `s` value to be in the lower
1296      * half order, and the `v` value to be either 27 or 28.
1297      *
1298      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1299      * verification to be secure: it is possible to craft signatures that
1300      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1301      * this is by receiving a hash of the original message (which may otherwise
1302      * be too long), and then calling {toEthSignedMessageHash} on it.
1303      */
1304     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1305         (address recovered, RecoverError error) = tryRecover(hash, signature);
1306         _throwError(error);
1307         return recovered;
1308     }
1309 
1310     /**
1311      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1312      *
1313      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1314      *
1315      * _Available since v4.3._
1316      */
1317     function tryRecover(
1318         bytes32 hash,
1319         bytes32 r,
1320         bytes32 vs
1321     ) internal pure returns (address, RecoverError) {
1322         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1323         uint8 v = uint8((uint256(vs) >> 255) + 27);
1324         return tryRecover(hash, v, r, s);
1325     }
1326 
1327     /**
1328      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1329      *
1330      * _Available since v4.2._
1331      */
1332     function recover(
1333         bytes32 hash,
1334         bytes32 r,
1335         bytes32 vs
1336     ) internal pure returns (address) {
1337         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1338         _throwError(error);
1339         return recovered;
1340     }
1341 
1342     /**
1343      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1344      * `r` and `s` signature fields separately.
1345      *
1346      * _Available since v4.3._
1347      */
1348     function tryRecover(
1349         bytes32 hash,
1350         uint8 v,
1351         bytes32 r,
1352         bytes32 s
1353     ) internal pure returns (address, RecoverError) {
1354         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1355         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1356         // the valid range for s in (301): 0 < s < secp256k1n � 2 + 1, and for v in (302): v ? {27, 28}. Most
1357         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1358         //
1359         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1360         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1361         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1362         // these malleable signatures as well.
1363         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1364             return (address(0), RecoverError.InvalidSignatureS);
1365         }
1366         if (v != 27 && v != 28) {
1367             return (address(0), RecoverError.InvalidSignatureV);
1368         }
1369 
1370         // If the signature is valid (and not malleable), return the signer address
1371         address signer = ecrecover(hash, v, r, s);
1372         if (signer == address(0)) {
1373             return (address(0), RecoverError.InvalidSignature);
1374         }
1375 
1376         return (signer, RecoverError.NoError);
1377     }
1378 
1379     /**
1380      * @dev Overload of {ECDSA-recover} that receives the `v`,
1381      * `r` and `s` signature fields separately.
1382      */
1383     function recover(
1384         bytes32 hash,
1385         uint8 v,
1386         bytes32 r,
1387         bytes32 s
1388     ) internal pure returns (address) {
1389         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1390         _throwError(error);
1391         return recovered;
1392     }
1393 
1394     /**
1395      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1396      * produces hash corresponding to the one signed with the
1397      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1398      * JSON-RPC method as part of EIP-191.
1399      *
1400      * See {recover}.
1401      */
1402     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1403         // 32 is the length in bytes of hash,
1404         // enforced by the type signature above
1405         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1406     }
1407 
1408     /**
1409      * @dev Returns an Ethereum Signed Message, created from `s`. This
1410      * produces hash corresponding to the one signed with the
1411      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1412      * JSON-RPC method as part of EIP-191.
1413      *
1414      * See {recover}.
1415      */
1416     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1417         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1418     }
1419 
1420     /**
1421      * @dev Returns an Ethereum Signed Typed Data, created from a
1422      * `domainSeparator` and a `structHash`. This produces hash corresponding
1423      * to the one signed with the
1424      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1425      * JSON-RPC method as part of EIP-712.
1426      *
1427      * See {recover}.
1428      */
1429     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1430         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1431     }
1432 }
1433 abstract contract EIP712 {
1434     /* solhint-disable var-name-mixedcase */
1435     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1436     // invalidate the cached domain separator if the chain id changes.
1437     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1438     uint256 private immutable _CACHED_CHAIN_ID;
1439     address private immutable _CACHED_THIS;
1440 
1441     bytes32 private immutable _HASHED_NAME;
1442     bytes32 private immutable _HASHED_VERSION;
1443     bytes32 private immutable _TYPE_HASH;
1444 
1445     /* solhint-enable var-name-mixedcase */
1446 
1447     /**
1448      * @dev Initializes the domain separator and parameter caches.
1449      *
1450      * The meaning of `name` and `version` is specified in
1451      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1452      *
1453      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1454      * - `version`: the current major version of the signing domain.
1455      *
1456      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1457      * contract upgrade].
1458      */
1459     constructor(string memory name, string memory version) {
1460         bytes32 hashedName = keccak256(bytes(name));
1461         bytes32 hashedVersion = keccak256(bytes(version));
1462         bytes32 typeHash = keccak256(
1463             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1464         );
1465         _HASHED_NAME = hashedName;
1466         _HASHED_VERSION = hashedVersion;
1467         _CACHED_CHAIN_ID = block.chainid;
1468         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1469         _CACHED_THIS = address(this);
1470         _TYPE_HASH = typeHash;
1471     }
1472 
1473     /**
1474      * @dev Returns the domain separator for the current chain.
1475      */
1476     function _domainSeparatorV4() internal view returns (bytes32) {
1477         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1478             return _CACHED_DOMAIN_SEPARATOR;
1479         } else {
1480             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1481         }
1482     }
1483 
1484     function _buildDomainSeparator(
1485         bytes32 typeHash,
1486         bytes32 nameHash,
1487         bytes32 versionHash
1488     ) private view returns (bytes32) {
1489         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1490     }
1491 
1492     /**
1493      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1494      * function returns the hash of the fully encoded EIP712 message for this domain.
1495      *
1496      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1497      *
1498      * ```solidity
1499      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1500      *     keccak256("Mail(address to,string contents)"),
1501      *     mailTo,
1502      *     keccak256(bytes(mailContents))
1503      * )));
1504      * address signer = ECDSA.recover(digest, signature);
1505      * ```
1506      */
1507     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1508         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1509     }
1510 }
1511 
1512 contract NFTVz is Ownable, ERC721A {
1513 
1514     uint256 public adoptionLimit = 5;
1515     using Strings for uint256;
1516 
1517     mapping(uint256 => string) private _tokenURIs;
1518     bool public publicSaleOpen = false;
1519     string public baseURI = "ipfs://bafybeighd5vlaz4v5lnvtkrehjqxvj2vmpq7lh2aifb6yq2a3ellazothm/";
1520     string public _extension = ".json";
1521     uint256 public price = 0 ether;
1522     uint256 public maxSupply = 4444;
1523 
1524     constructor() ERC721A("NFTVz", "NFTV"){}
1525     
1526     function mintNFT(uint256 _quantity) public payable {
1527         require(_quantity > 0 && _quantity <= adoptionLimit, "Wallet full, check max per wallet!");
1528         require(totalSupply() + _quantity <= maxSupply, "Reached max supply!");
1529         require(msg.value == price * _quantity, "Needs to send more ETH!");
1530         require(getMintedCount(msg.sender) + _quantity <= adoptionLimit, "Exceeded max minting amount!");
1531         require(publicSaleOpen, "Public sale not yet started!");
1532 
1533         _safeMint(msg.sender, _quantity);
1534 
1535     }
1536 
1537 
1538     function sendGifts(address[] memory _wallets) external onlyOwner{
1539         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
1540         for(uint i = 0; i < _wallets.length; i++)
1541             _safeMint(_wallets[i], 1);
1542 
1543     }
1544    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
1545                require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
1546             _safeMint(_wallet, _num);
1547     }
1548 
1549 
1550     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1551         require(
1552             _exists(_tokenId),
1553             "ERC721Metadata: URI set of nonexistent token"
1554         );
1555 
1556         return string(abi.encodePacked(baseURI, _tokenId.toString(), _extension));
1557     }
1558 
1559     function updateBaseURI(string memory _newBaseURI) onlyOwner public {
1560         baseURI = _newBaseURI;
1561     }
1562     function updateExtension(string memory _temp) onlyOwner public {
1563         _extension = _temp;
1564     }
1565 
1566     function getBaseURI() external view returns(string memory) {
1567         return baseURI;
1568     }
1569 
1570     function setPrice(uint256 _price) public onlyOwner() {
1571         price = _price;
1572     }
1573     function setAdoptionlimits(uint256 _adoptionLimit) public onlyOwner() {
1574         adoptionLimit = _adoptionLimit;
1575     }
1576 
1577     function setmaxSupply(uint256 _supply) public onlyOwner() {
1578         maxSupply = _supply;
1579     }
1580 
1581     function toggleSale() public onlyOwner() {
1582         publicSaleOpen = !publicSaleOpen;
1583     }
1584 
1585 
1586     function getBalance() public view returns(uint) {
1587         return address(this).balance;
1588     }
1589 
1590     function getMintedCount(address owner) public view returns (uint256) {
1591     return _numberMinted(owner);
1592   }
1593 
1594     function withdraw() external onlyOwner {
1595         uint _balance = address(this).balance;
1596         payable(owner()).transfer(_balance); //Owner
1597     }
1598 
1599     function getOwnershipData(uint256 tokenId)
1600     external
1601     view
1602     returns (TokenOwnership memory)
1603   {
1604     return ownershipOf(tokenId);
1605   }
1606 
1607     receive() external payable {}
1608 
1609 }