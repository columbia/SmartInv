1 /**
2 
3 ███████╗██╗███╗   ███╗███╗   ███╗██╗   ██╗███╗   ███╗ ██████╗ ███╗   ██╗
4 ╚══███╔╝██║████╗ ████║████╗ ████║╚██╗ ██╔╝████╗ ████║██╔═══██╗████╗  ██║
5   ███╔╝ ██║██╔████╔██║██╔████╔██║ ╚████╔╝ ██╔████╔██║██║   ██║██╔██╗ ██║
6  ███╔╝  ██║██║╚██╔╝██║██║╚██╔╝██║  ╚██╔╝  ██║╚██╔╝██║██║   ██║██║╚██╗██║
7 ███████╗██║██║ ╚═╝ ██║██║ ╚═╝ ██║   ██║   ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
8 ╚══════╝╚═╝╚═╝     ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
9                                                                         
10 /**
11                                                                                                  
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @title ERC721 token receiver interface
18  * @dev Interface for any contract that wants to support safeTransfers
19  * from ERC721 asset contracts.
20  */
21 interface IERC721Receiver {
22     /**
23      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
24      * by `operator` from `from`, this function is called.
25      *
26      * It must return its Solidity selector to confirm the token transfer.
27      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
28      *
29      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
30      */
31     function onERC721Received(
32         address operator,
33         address from,
34         uint256 tokenId,
35         bytes calldata data
36     ) external returns (bytes4);
37 }
38 
39 pragma solidity ^0.8.1;
40 
41 /**
42  * @dev Collection of functions related to the address type
43  */
44 library Address {
45     /**
46      * @dev Returns true if `account` is a contract.
47      *
48      * [IMPORTANT]
49      * ====
50      * It is unsafe to assume that an address for which this function returns
51      * false is an externally-owned account (EOA) and not a contract.
52      *
53      * Among others, `isContract` will return false for the following
54      * types of addresses:
55      *
56      *  - an externally-owned account
57      *  - a contract in construction
58      *  - an address where a contract will be created
59      *  - an address where a contract lived, but was destroyed
60      * ====
61      *
62      * [IMPORTANT]
63      * ====
64      * You shouldn't rely on `isContract` to protect against flash loan attacks!
65      *
66      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
67      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
68      * constructor.
69      * ====
70      */
71     function isContract(address account) internal view returns (bool) {
72         // This method relies on extcodesize/address.code.length, which returns 0
73         // for contracts in construction, since the code is only stored at the end
74         // of the constructor execution.
75 
76         return account.code.length > 0;
77     }
78 
79     /**
80      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
81      * `recipient`, forwarding all available gas and reverting on errors.
82      *
83      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
84      * of certain opcodes, possibly making contracts go over the 2300 gas limit
85      * imposed by `transfer`, making them unable to receive funds via
86      * `transfer`. {sendValue} removes this limitation.
87      *
88      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
89      *
90      * IMPORTANT: because control is transferred to `recipient`, care must be
91      * taken to not create reentrancy vulnerabilities. Consider using
92      * {ReentrancyGuard} or the
93      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
94      */
95     function sendValue(address payable recipient, uint256 amount) internal {
96         require(address(this).balance >= amount, "Address: insufficient balance");
97 
98         (bool success, ) = recipient.call{value: amount}("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     /**
103      * @dev Performs a Solidity function call using a low level `call`. A
104      * plain `call` is an unsafe replacement for a function call: use this
105      * function instead.
106      *
107      * If `target` reverts with a revert reason, it is bubbled up by this
108      * function (like regular Solidity function calls).
109      *
110      * Returns the raw returned data. To convert to the expected return value,
111      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
112      *
113      * Requirements:
114      *
115      * - `target` must be a contract.
116      * - calling `target` with `data` must not revert.
117      *
118      * _Available since v3.1._
119      */
120     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
121         return functionCall(target, data, "Address: low-level call failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
126      * `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCall(
131         address target,
132         bytes memory data,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, 0, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but also transferring `value` wei to `target`.
141      *
142      * Requirements:
143      *
144      * - the calling contract must have an ETH balance of at least `value`.
145      * - the called Solidity function must be `payable`.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value
153     ) internal returns (bytes memory) {
154         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
159      * with `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCallWithValue(
164         address target,
165         bytes memory data,
166         uint256 value,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         require(address(this).balance >= value, "Address: insufficient balance for call");
170         require(isContract(target), "Address: call to non-contract");
171 
172         (bool success, bytes memory returndata) = target.call{value: value}(data);
173         return verifyCallResult(success, returndata, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but performing a static call.
179      *
180      * _Available since v3.3._
181      */
182     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
183         return functionStaticCall(target, data, "Address: low-level static call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
188      * but performing a static call.
189      *
190      * _Available since v3.3._
191      */
192     function functionStaticCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal view returns (bytes memory) {
197         require(isContract(target), "Address: static call to non-contract");
198 
199         (bool success, bytes memory returndata) = target.staticcall(data);
200         return verifyCallResult(success, returndata, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but performing a delegate call.
206      *
207      * _Available since v3.4._
208      */
209     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
210         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
215      * but performing a delegate call.
216      *
217      * _Available since v3.4._
218      */
219     function functionDelegateCall(
220         address target,
221         bytes memory data,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(isContract(target), "Address: delegate call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.delegatecall(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
232      * revert reason using the provided one.
233      *
234      * _Available since v4.3._
235      */
236     function verifyCallResult(
237         bool success,
238         bytes memory returndata,
239         string memory errorMessage
240     ) internal pure returns (bytes memory) {
241         if (success) {
242             return returndata;
243         } else {
244             // Look for revert reason and bubble it up if present
245             if (returndata.length > 0) {
246                 // The easiest way to bubble the revert reason is using memory via assembly
247 
248                 assembly {
249                     let returndata_size := mload(returndata)
250                     revert(add(32, returndata), returndata_size)
251                 }
252             } else {
253                 revert(errorMessage);
254             }
255         }
256     }
257 }
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev Provides information about the current execution context, including the
263  * sender of the transaction and its data. While these are generally available
264  * via msg.sender and msg.data, they should not be accessed in such a direct
265  * manner, since when dealing with meta-transactions the account sending and
266  * paying for execution may not be the actual sender (as far as an application
267  * is concerned).
268  *
269  * This contract is only required for intermediate, library-like contracts.
270  */
271 abstract contract Context {
272     function _msgSender() internal view virtual returns (address) {
273         return msg.sender;
274     }
275 
276     function _msgData() internal view virtual returns (bytes calldata) {
277         return msg.data;
278     }
279 }
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev String operations.
285  */
286 library Strings {
287     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
288 
289     /**
290      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
291      */
292     function toString(uint256 value) internal pure returns (string memory) {
293         // Inspired by OraclizeAPI's implementation - MIT licence
294         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
295 
296         if (value == 0) {
297             return "0";
298         }
299         uint256 temp = value;
300         uint256 digits;
301         while (temp != 0) {
302             digits++;
303             temp /= 10;
304         }
305         bytes memory buffer = new bytes(digits);
306         while (value != 0) {
307             digits -= 1;
308             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
309             value /= 10;
310         }
311         return string(buffer);
312     }
313 
314     /**
315      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
316      */
317     function toHexString(uint256 value) internal pure returns (string memory) {
318         if (value == 0) {
319             return "0x00";
320         }
321         uint256 temp = value;
322         uint256 length = 0;
323         while (temp != 0) {
324             length++;
325             temp >>= 8;
326         }
327         return toHexString(value, length);
328     }
329 
330     /**
331      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
332      */
333     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
334         bytes memory buffer = new bytes(2 * length + 2);
335         buffer[0] = "0";
336         buffer[1] = "x";
337         for (uint256 i = 2 * length + 1; i > 1; --i) {
338             buffer[i] = _HEX_SYMBOLS[value & 0xf];
339             value >>= 4;
340         }
341         require(value == 0, "Strings: hex length insufficient");
342         return string(buffer);
343     }
344 }
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @dev Interface of the ERC165 standard, as defined in the
350  * https://eips.ethereum.org/EIPS/eip-165[EIP].
351  *
352  * Implementers can declare support of contract interfaces, which can then be
353  * queried by others ({ERC165Checker}).
354  *
355  * For an implementation, see {ERC165}.
356  */
357 interface IERC165 {
358     /**
359      * @dev Returns true if this contract implements the interface defined by
360      * `interfaceId`. See the corresponding
361      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
362      * to learn more about how these ids are created.
363      *
364      * This function call must use less than 30 000 gas.
365      */
366     function supportsInterface(bytes4 interfaceId) external view returns (bool);
367 }
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @dev Implementation of the {IERC165} interface.
373  *
374  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
375  * for the additional interface id that will be supported. For example:
376  *
377  * ```solidity
378  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
379  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
380  * }
381  * ```
382  *
383  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
384  */
385 abstract contract ERC165 is IERC165 {
386     /**
387      * @dev See {IERC165-supportsInterface}.
388      */
389     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
390         return interfaceId == type(IERC165).interfaceId;
391     }
392 }
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Required interface of an ERC721 compliant contract.
398  */
399 interface IERC721 is IERC165 {
400     /**
401      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
404 
405     /**
406      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
407      */
408     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
412      */
413     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
414 
415     /**
416      * @dev Returns the number of tokens in ``owner``'s account.
417      */
418     function balanceOf(address owner) external view returns (uint256 balance);
419 
420     /**
421      * @dev Returns the owner of the `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function ownerOf(uint256 tokenId) external view returns (address owner);
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
431      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId
447     ) external;
448 
449     /**
450      * @dev Transfers `tokenId` token from `from` to `to`.
451      *
452      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must be owned by `from`.
459      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
471      * The approval is cleared when the token is transferred.
472      *
473      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
474      *
475      * Requirements:
476      *
477      * - The caller must own the token or be an approved operator.
478      * - `tokenId` must exist.
479      *
480      * Emits an {Approval} event.
481      */
482     function approve(address to, uint256 tokenId) external;
483 
484     /**
485      * @dev Returns the account approved for `tokenId` token.
486      *
487      * Requirements:
488      *
489      * - `tokenId` must exist.
490      */
491     function getApproved(uint256 tokenId) external view returns (address operator);
492 
493     /**
494      * @dev Approve or remove `operator` as an operator for the caller.
495      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
496      *
497      * Requirements:
498      *
499      * - The `operator` cannot be the caller.
500      *
501      * Emits an {ApprovalForAll} event.
502      */
503     function setApprovalForAll(address operator, bool _approved) external;
504 
505     /**
506      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
507      *
508      * See {setApprovalForAll}
509      */
510     function isApprovedForAll(address owner, address operator) external view returns (bool);
511 
512     /**
513      * @dev Safely transfers `tokenId` token from `from` to `to`.
514      *
515      * Requirements:
516      *
517      * - `from` cannot be the zero address.
518      * - `to` cannot be the zero address.
519      * - `tokenId` token must exist and be owned by `from`.
520      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
521      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
522      *
523      * Emits a {Transfer} event.
524      */
525     function safeTransferFrom(
526         address from,
527         address to,
528         uint256 tokenId,
529         bytes calldata data
530     ) external;
531 }
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
537  * @dev See https://eips.ethereum.org/EIPS/eip-721
538  */
539 interface IERC721Metadata is IERC721 {
540     /**
541      * @dev Returns the token collection name.
542      */
543     function name() external view returns (string memory);
544 
545     /**
546      * @dev Returns the token collection symbol.
547      */
548     function symbol() external view returns (string memory);
549 
550     /**
551      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
552      */
553     function tokenURI(uint256 tokenId) external view returns (string memory);
554 }
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
560  * @dev See https://eips.ethereum.org/EIPS/eip-721
561  */
562 interface IERC721Enumerable is IERC721 {
563     /**
564      * @dev Returns the total amount of tokens stored by the contract.
565      */
566     function totalSupply() external view returns (uint256);
567 
568     /**
569      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
570      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
571      */
572     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
573 
574     /**
575      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
576      * Use along with {totalSupply} to enumerate all tokens.
577      */
578     function tokenByIndex(uint256 index) external view returns (uint256);
579 }
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Contract module which provides a basic access control mechanism, where
585  * there is an account (an owner) that can be granted exclusive access to
586  * specific functions.
587  *
588  * By default, the owner account will be the one that deploys the contract. This
589  * can later be changed with {transferOwnership}.
590  *
591  * This module is used through inheritance. It will make available the modifier
592  * `onlyOwner`, which can be applied to your functions to restrict their use to
593  * the owner.
594  */
595 abstract contract Ownable is Context {
596     address private _owner;
597 
598     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
599 
600     /**
601      * @dev Initializes the contract setting the deployer as the initial owner.
602      */
603     constructor() {
604         _transferOwnership(_msgSender());
605     }
606 
607     /**
608      * @dev Returns the address of the current owner.
609      */
610     function owner() public view virtual returns (address) {
611         return _owner;
612     }
613 
614     /**
615      * @dev Throws if called by any account other than the owner.
616      */
617     modifier onlyOwner() {
618         require(owner() == _msgSender(), "Ownable: caller is not the owner");
619         _;
620     }
621 
622     /**
623      * @dev Leaves the contract without owner. It will not be possible to call
624      * `onlyOwner` functions anymore. Can only be called by the current owner.
625      *
626      * NOTE: Renouncing ownership will leave the contract without an owner,
627      * thereby removing any functionality that is only available to the owner.
628      */
629     function renounceOwnership() public virtual onlyOwner {
630         _transferOwnership(address(0));
631     }
632 
633     /**
634      * @dev Transfers ownership of the contract to a new account (`newOwner`).
635      * Can only be called by the current owner.
636      */
637     function transferOwnership(address newOwner) public virtual onlyOwner {
638         require(newOwner != address(0), "Ownable: new owner is the zero address");
639         _transferOwnership(newOwner);
640     }
641 
642     /**
643      * @dev Transfers ownership of the contract to a new account (`newOwner`).
644      * Internal function without access restriction.
645      */
646     function _transferOwnership(address newOwner) internal virtual {
647         address oldOwner = _owner;
648         _owner = newOwner;
649         emit OwnershipTransferred(oldOwner, newOwner);
650     }
651 }
652 
653 pragma solidity ^0.8.4;
654 
655 error ApprovalCallerNotOwnerNorApproved();
656 error ApprovalQueryForNonexistentToken();
657 error ApproveToCaller();
658 error ApprovalToCurrentOwner();
659 error BalanceQueryForZeroAddress();
660 error MintedQueryForZeroAddress();
661 error BurnedQueryForZeroAddress();
662 error MintToZeroAddress();
663 error MintZeroQuantity();
664 error OwnerIndexOutOfBounds();
665 error OwnerQueryForNonexistentToken();
666 error TokenIndexOutOfBounds();
667 error TransferCallerNotOwnerNorApproved();
668 error TransferFromIncorrectOwner();
669 error TransferToNonERC721ReceiverImplementer();
670 error TransferToZeroAddress();
671 error URIQueryForNonexistentToken();
672 
673 /**
674  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
675  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
676  *
677  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
678  *
679  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
680  *
681  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
682  */
683 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
684     using Address for address;
685     using Strings for uint256;
686 
687     // Compiler will pack this into a single 256bit word.
688     struct TokenOwnership {
689         // The address of the owner.
690         address addr;
691         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
692         uint64 startTimestamp;
693         // Whether the token has been burned.
694         bool burned;
695     }
696 
697     // Compiler will pack this into a single 256bit word.
698     struct AddressData {
699         // Realistically, 2**64-1 is more than enough.
700         uint64 balance;
701         // Keeps track of mint count with minimal overhead for tokenomics.
702         uint64 numberMinted;
703         // Keeps track of burn count with minimal overhead for tokenomics.
704         uint64 numberBurned;
705     }
706 
707     // Compiler will pack the following 
708     // _currentIndex and _burnCounter into a single 256bit word.
709     
710     // The tokenId of the next token to be minted.
711     uint128 internal _currentIndex;
712 
713     // The number of tokens burned.
714     uint128 internal _burnCounter;
715 
716     // Token name
717     string private _name;
718 
719     // Token symbol
720     string private _symbol;
721 
722     // Mapping from token ID to ownership details
723     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
724     mapping(uint256 => TokenOwnership) internal _ownerships;
725 
726     // Mapping owner address to address data
727     mapping(address => AddressData) private _addressData;
728 
729     // Mapping from token ID to approved address
730     mapping(uint256 => address) private _tokenApprovals;
731 
732     // Mapping from owner to operator approvals
733     mapping(address => mapping(address => bool)) private _operatorApprovals;
734 
735     constructor(string memory name_, string memory symbol_) {
736         _name = name_;
737         _symbol = symbol_;
738     }
739 
740     /**
741      * @dev See {IERC721Enumerable-totalSupply}.
742      */
743     function totalSupply() public view override returns (uint256) {
744         // Counter underflow is impossible as _burnCounter cannot be incremented
745         // more than _currentIndex times
746         unchecked {
747             return _currentIndex - _burnCounter;    
748         }
749     }
750 
751     /**
752      * @dev See {IERC721Enumerable-tokenByIndex}.
753      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
754      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
755      */
756     function tokenByIndex(uint256 index) public view override returns (uint256) {
757         uint256 numMintedSoFar = _currentIndex;
758         uint256 tokenIdsIdx;
759 
760         // Counter overflow is impossible as the loop breaks when
761         // uint256 i is equal to another uint256 numMintedSoFar.
762         unchecked {
763             for (uint256 i; i < numMintedSoFar; i++) {
764                 TokenOwnership memory ownership = _ownerships[i];
765                 if (!ownership.burned) {
766                     if (tokenIdsIdx == index) {
767                         return i;
768                     }
769                     tokenIdsIdx++;
770                 }
771             }
772         }
773         revert TokenIndexOutOfBounds();
774     }
775 
776     /**
777      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
778      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
779      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
780      */
781     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
782         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
783         uint256 numMintedSoFar = _currentIndex;
784         uint256 tokenIdsIdx;
785         address currOwnershipAddr;
786 
787         // Counter overflow is impossible as the loop breaks when
788         // uint256 i is equal to another uint256 numMintedSoFar.
789         unchecked {
790             for (uint256 i; i < numMintedSoFar; i++) {
791                 TokenOwnership memory ownership = _ownerships[i];
792                 if (ownership.burned) {
793                     continue;
794                 }
795                 if (ownership.addr != address(0)) {
796                     currOwnershipAddr = ownership.addr;
797                 }
798                 if (currOwnershipAddr == owner) {
799                     if (tokenIdsIdx == index) {
800                         return i;
801                     }
802                     tokenIdsIdx++;
803                 }
804             }
805         }
806 
807         // Execution should never reach this point.
808         revert();
809     }
810 
811     /**
812      * @dev See {IERC165-supportsInterface}.
813      */
814     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
815         return
816             interfaceId == type(IERC721).interfaceId ||
817             interfaceId == type(IERC721Metadata).interfaceId ||
818             interfaceId == type(IERC721Enumerable).interfaceId ||
819             super.supportsInterface(interfaceId);
820     }
821 
822     /**
823      * @dev See {IERC721-balanceOf}.
824      */
825     function balanceOf(address owner) public view override returns (uint256) {
826         if (owner == address(0)) revert BalanceQueryForZeroAddress();
827         return uint256(_addressData[owner].balance);
828     }
829 
830     function _numberMinted(address owner) internal view returns (uint256) {
831         if (owner == address(0)) revert MintedQueryForZeroAddress();
832         return uint256(_addressData[owner].numberMinted);
833     }
834 
835     function _numberBurned(address owner) internal view returns (uint256) {
836         if (owner == address(0)) revert BurnedQueryForZeroAddress();
837         return uint256(_addressData[owner].numberBurned);
838     }
839 
840     /**
841      * Gas spent here starts off proportional to the maximum mint batch size.
842      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
843      */
844     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
845         uint256 curr = tokenId;
846 
847         unchecked {
848             if (curr < _currentIndex) {
849                 TokenOwnership memory ownership = _ownerships[curr];
850                 if (!ownership.burned) {
851                     if (ownership.addr != address(0)) {
852                         return ownership;
853                     }
854                     // Invariant: 
855                     // There will always be an ownership that has an address and is not burned 
856                     // before an ownership that does not have an address and is not burned.
857                     // Hence, curr will not underflow.
858                     while (true) {
859                         curr--;
860                         ownership = _ownerships[curr];
861                         if (ownership.addr != address(0)) {
862                             return ownership;
863                         }
864                     }
865                 }
866             }
867         }
868         revert OwnerQueryForNonexistentToken();
869     }
870 
871     /**
872      * @dev See {IERC721-ownerOf}.
873      */
874     function ownerOf(uint256 tokenId) public view override returns (address) {
875         return ownershipOf(tokenId).addr;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-name}.
880      */
881     function name() public view virtual override returns (string memory) {
882         return _name;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-symbol}.
887      */
888     function symbol() public view virtual override returns (string memory) {
889         return _symbol;
890     }
891 
892     /**
893      * @dev See {IERC721Metadata-tokenURI}.
894      */
895     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
896         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
897 
898         string memory baseURI = _baseURI();
899         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
900     }
901 
902     /**
903      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
904      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
905      * by default, can be overriden in child contracts.
906      */
907     function _baseURI() internal view virtual returns (string memory) {
908         return '';
909     }
910 
911     /**
912      * @dev See {IERC721-approve}.
913      */
914     function approve(address to, uint256 tokenId) public override {
915         address owner = ERC721A.ownerOf(tokenId);
916         if (to == owner) revert ApprovalToCurrentOwner();
917 
918         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
919             revert ApprovalCallerNotOwnerNorApproved();
920         }
921 
922         _approve(to, tokenId, owner);
923     }
924 
925     /**
926      * @dev See {IERC721-getApproved}.
927      */
928     function getApproved(uint256 tokenId) public view override returns (address) {
929         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
930 
931         return _tokenApprovals[tokenId];
932     }
933 
934     /**
935      * @dev See {IERC721-setApprovalForAll}.
936      */
937     function setApprovalForAll(address operator, bool approved) public override {
938         if (operator == _msgSender()) revert ApproveToCaller();
939 
940         _operatorApprovals[_msgSender()][operator] = approved;
941         emit ApprovalForAll(_msgSender(), operator, approved);
942     }
943 
944     /**
945      * @dev See {IERC721-isApprovedForAll}.
946      */
947     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
948         return _operatorApprovals[owner][operator];
949     }
950 
951     /**
952      * @dev See {IERC721-transferFrom}.
953      */
954     function transferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         _transfer(from, to, tokenId);
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         safeTransferFrom(from, to, tokenId, '');
971     }
972 
973     /**
974      * @dev See {IERC721-safeTransferFrom}.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) public virtual override {
982         _transfer(from, to, tokenId);
983         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
984             revert TransferToNonERC721ReceiverImplementer();
985         }
986     }
987 
988     /**
989      * @dev Returns whether `tokenId` exists.
990      *
991      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
992      *
993      * Tokens start existing when they are minted (`_mint`),
994      */
995     function _exists(uint256 tokenId) internal view returns (bool) {
996         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
997     }
998 
999     function _safeMint(address to, uint256 quantity) internal {
1000         _safeMint(to, quantity, '');
1001     }
1002 
1003     /**
1004      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1009      * - `quantity` must be greater than 0.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 quantity,
1016         bytes memory _data
1017     ) internal {
1018         _mint(to, quantity, _data, true);
1019     }
1020 
1021     /**
1022      * @dev Mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(
1032         address to,
1033         uint256 quantity,
1034         bytes memory _data,
1035         bool safe
1036     ) internal {
1037         uint256 startTokenId = _currentIndex;
1038         if (to == address(0)) revert MintToZeroAddress();
1039         if (quantity == 0) revert MintZeroQuantity();
1040 
1041         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1042 
1043         // Overflows are incredibly unrealistic.
1044         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1045         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1046         unchecked {
1047             _addressData[to].balance += uint64(quantity);
1048             _addressData[to].numberMinted += uint64(quantity);
1049 
1050             _ownerships[startTokenId].addr = to;
1051             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1052 
1053             uint256 updatedIndex = startTokenId;
1054 
1055             for (uint256 i; i < quantity; i++) {
1056                 emit Transfer(address(0), to, updatedIndex);
1057                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1058                     revert TransferToNonERC721ReceiverImplementer();
1059                 }
1060                 updatedIndex++;
1061             }
1062 
1063             _currentIndex = uint128(updatedIndex);
1064         }
1065         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1066     }
1067 
1068     /**
1069      * @dev Transfers `tokenId` from `from` to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - `to` cannot be the zero address.
1074      * - `tokenId` token must be owned by `from`.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _transfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) private {
1083         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1084 
1085         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1086             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1087             getApproved(tokenId) == _msgSender());
1088 
1089         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1090         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1091         if (to == address(0)) revert TransferToZeroAddress();
1092 
1093         _beforeTokenTransfers(from, to, tokenId, 1);
1094 
1095         // Clear approvals from the previous owner
1096         _approve(address(0), tokenId, prevOwnership.addr);
1097 
1098         // Underflow of the sender's balance is impossible because we check for
1099         // ownership above and the recipient's balance can't realistically overflow.
1100         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1101         unchecked {
1102             _addressData[from].balance -= 1;
1103             _addressData[to].balance += 1;
1104 
1105             _ownerships[tokenId].addr = to;
1106             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1107 
1108             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1109             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1110             uint256 nextTokenId = tokenId + 1;
1111             if (_ownerships[nextTokenId].addr == address(0)) {
1112                 // This will suffice for checking _exists(nextTokenId),
1113                 // as a burned slot cannot contain the zero address.
1114                 if (nextTokenId < _currentIndex) {
1115                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1116                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1117                 }
1118             }
1119         }
1120 
1121         emit Transfer(from, to, tokenId);
1122         _afterTokenTransfers(from, to, tokenId, 1);
1123     }
1124 
1125     /**
1126      * @dev Destroys `tokenId`.
1127      * The approval is cleared when the token is burned.
1128      *
1129      * Requirements:
1130      *
1131      * - `tokenId` must exist.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _burn(uint256 tokenId) internal virtual {
1136         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1137 
1138         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1139 
1140         // Clear approvals from the previous owner
1141         _approve(address(0), tokenId, prevOwnership.addr);
1142 
1143         // Underflow of the sender's balance is impossible because we check for
1144         // ownership above and the recipient's balance can't realistically overflow.
1145         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1146         unchecked {
1147             _addressData[prevOwnership.addr].balance -= 1;
1148             _addressData[prevOwnership.addr].numberBurned += 1;
1149 
1150             // Keep track of who burned the token, and the timestamp of burning.
1151             _ownerships[tokenId].addr = prevOwnership.addr;
1152             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1153             _ownerships[tokenId].burned = true;
1154 
1155             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1156             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1157             uint256 nextTokenId = tokenId + 1;
1158             if (_ownerships[nextTokenId].addr == address(0)) {
1159                 // This will suffice for checking _exists(nextTokenId),
1160                 // as a burned slot cannot contain the zero address.
1161                 if (nextTokenId < _currentIndex) {
1162                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1163                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1164                 }
1165             }
1166         }
1167 
1168         emit Transfer(prevOwnership.addr, address(0), tokenId);
1169         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1170 
1171         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1172         unchecked { 
1173             _burnCounter++;
1174         }
1175     }
1176 
1177     /**
1178      * @dev Approve `to` to operate on `tokenId`
1179      *
1180      * Emits a {Approval} event.
1181      */
1182     function _approve(
1183         address to,
1184         uint256 tokenId,
1185         address owner
1186     ) private {
1187         _tokenApprovals[tokenId] = to;
1188         emit Approval(owner, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1193      * The call is not executed if the target address is not a contract.
1194      *
1195      * @param from address representing the previous owner of the given token ID
1196      * @param to target address that will receive the tokens
1197      * @param tokenId uint256 ID of the token to be transferred
1198      * @param _data bytes optional data to send along with the call
1199      * @return bool whether the call correctly returned the expected magic value
1200      */
1201     function _checkOnERC721Received(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes memory _data
1206     ) private returns (bool) {
1207         if (to.isContract()) {
1208             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1209                 return retval == IERC721Receiver(to).onERC721Received.selector;
1210             } catch (bytes memory reason) {
1211                 if (reason.length == 0) {
1212                     revert TransferToNonERC721ReceiverImplementer();
1213                 } else {
1214                     assembly {
1215                         revert(add(32, reason), mload(reason))
1216                     }
1217                 }
1218             }
1219         } else {
1220             return true;
1221         }
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1226      * And also called before burning one token.
1227      *
1228      * startTokenId - the first token id to be transferred
1229      * quantity - the amount to be transferred
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, `tokenId` will be burned by `from`.
1237      * - `from` and `to` are never both zero.
1238      */
1239     function _beforeTokenTransfers(
1240         address from,
1241         address to,
1242         uint256 startTokenId,
1243         uint256 quantity
1244     ) internal virtual {}
1245 
1246     /**
1247      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1248      * minting.
1249      * And also called after one token has been burned.
1250      *
1251      * startTokenId - the first token id to be transferred
1252      * quantity - the amount to be transferred
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` has been minted for `to`.
1259      * - When `to` is zero, `tokenId` has been burned by `from`.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _afterTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 }
1269 
1270 pragma solidity ^0.8.0;
1271 
1272 /**
1273  * @dev These functions deal with verification of Merkle Trees proofs.
1274  *
1275  * The proofs can be generated using the JavaScript library
1276  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1277  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1278  *
1279  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1280  *
1281  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1282  * hashing, or use a hash function other than keccak256 for hashing leaves.
1283  * This is because the concatenation of a sorted pair of internal nodes in
1284  * the merkle tree could be reinterpreted as a leaf value.
1285  */
1286 library MerkleProof {
1287     /**
1288      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1289      * defined by `root`. For this, a `proof` must be provided, containing
1290      * sibling hashes on the branch from the leaf to the root of the tree. Each
1291      * pair of leaves and each pair of pre-images are assumed to be sorted.
1292      */
1293     function verify(
1294         bytes32[] memory proof,
1295         bytes32 root,
1296         bytes32 leaf
1297     ) internal pure returns (bool) {
1298         return processProof(proof, leaf) == root;
1299     }
1300 
1301     /**
1302      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1303      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1304      * hash matches the root of the tree. When processing the proof, the pairs
1305      * of leafs & pre-images are assumed to be sorted.
1306      *
1307      * _Available since v4.4._
1308      */
1309     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1310         bytes32 computedHash = leaf;
1311         for (uint256 i = 0; i < proof.length; i++) {
1312             bytes32 proofElement = proof[i];
1313             if (computedHash <= proofElement) {
1314                 // Hash(current computed hash + current element of the proof)
1315                 computedHash = _efficientHash(computedHash, proofElement);
1316             } else {
1317                 // Hash(current element of the proof + current computed hash)
1318                 computedHash = _efficientHash(proofElement, computedHash);
1319             }
1320         }
1321         return computedHash;
1322     }
1323 
1324     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1325         assembly {
1326             mstore(0x00, a)
1327             mstore(0x20, b)
1328             value := keccak256(0x00, 0x40)
1329         }
1330     }
1331 }
1332 
1333 contract Zimmymon is ERC721A, Ownable {
1334     uint256 public constant MAX_MINTS = 1;
1335     uint256 public constant MAX_SUPPLY = 5208;
1336     uint256 public constant NUMBER_RESERVED_TOKENS = 25;
1337     uint256 public reservedTokensMinted = 0;
1338     uint256 public mintRate = 0 ether;
1339 
1340     bool public saleIsActive = false;
1341 
1342     mapping(address => uint256) public timesMinted;
1343 
1344     bytes32 public rootHashA;
1345     bytes32 public rootHashB;
1346 
1347     string public baseURI;
1348 
1349     constructor() ERC721A("Zimmymon", "Zimmymon") {
1350     }
1351 
1352     function claimA(uint256 quantity, bytes32[] calldata _proof) external payable {
1353         // _safeMint's second argument now takes in a quantity, not a tokenId.
1354         bytes32 _address = keccak256(abi.encodePacked(msg.sender));
1355         require(MerkleProof.verify(_proof, rootHashA, _address), "Address not found in whitelist");
1356         require(quantity + timesMinted[msg.sender] <= MAX_MINTS, "Only 1 mint per wallet");
1357         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1358         require(saleIsActive, "Mint period not active");
1359 
1360         _safeMint(msg.sender, quantity);
1361         timesMinted[msg.sender] += quantity;
1362     }
1363 
1364     function claimB(uint256 quantity, bytes32[] calldata _proof) external payable {
1365         // _safeMint's second argument now takes in a quantity, not a tokenId.
1366         bytes32 _address = keccak256(abi.encodePacked(msg.sender));
1367         require(MerkleProof.verify(_proof, rootHashB, _address), "Address not found in whitelist");
1368         require(quantity + timesMinted[msg.sender] <= MAX_MINTS, "Only 1 mint per wallet");
1369         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1370         require(saleIsActive, "Mint period not active");
1371 
1372         _safeMint(msg.sender, quantity);
1373         timesMinted[msg.sender] += quantity;
1374     }
1375 
1376     function mintReservedTokens(address to, uint16 quantity) external onlyOwner 
1377     {
1378         require(reservedTokensMinted + quantity <= NUMBER_RESERVED_TOKENS, "This amount is more than max allowed");
1379 
1380         reservedTokensMinted += quantity;
1381 
1382         _safeMint(to, quantity); 
1383     }
1384 
1385     function withdraw() external payable onlyOwner {
1386         payable(owner()).transfer(address(this).balance);
1387     }
1388 
1389     function _baseURI() internal view override returns (string memory) {
1390         return baseURI;
1391     }
1392 
1393     function setMintRate(uint256 _mintRate) public onlyOwner {
1394         mintRate = _mintRate;
1395     }
1396 
1397     function setBaseURI(string memory uri) public onlyOwner {
1398         baseURI = uri;
1399     }
1400 
1401     function flipSaleState() public onlyOwner {
1402         saleIsActive = !saleIsActive;
1403     }
1404 
1405     function setRootHashA(bytes32 _hashA) public onlyOwner {
1406         rootHashA = _hashA;
1407     }
1408 
1409     function setRootHashB(bytes32 _hashB) public onlyOwner {
1410         rootHashB = _hashB;
1411     }
1412 }