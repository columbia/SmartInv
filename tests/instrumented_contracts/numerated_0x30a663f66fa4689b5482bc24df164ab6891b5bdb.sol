1 /**
2 ███████╗██╗███╗   ███╗███╗   ███╗██╗   ██╗    ██████╗  █████╗ ██╗██████╗ ███████╗██████╗ ███████╗
3 ╚══███╔╝██║████╗ ████║████╗ ████║╚██╗ ██╔╝    ██╔══██╗██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██╔════╝
4   ███╔╝ ██║██╔████╔██║██╔████╔██║ ╚████╔╝     ██████╔╝███████║██║██║  ██║█████╗  ██████╔╝███████╗
5  ███╔╝  ██║██║╚██╔╝██║██║╚██╔╝██║  ╚██╔╝      ██╔══██╗██╔══██║██║██║  ██║██╔══╝  ██╔══██╗╚════██║
6 ███████╗██║██║ ╚═╝ ██║██║ ╚═╝ ██║   ██║       ██║  ██║██║  ██║██║██████╔╝███████╗██║  ██║███████║
7 ╚══════╝╚═╝╚═╝     ╚═╝╚═╝     ╚═╝   ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝
8 /**
9                                                                                                  
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @title ERC721 token receiver interface
16  * @dev Interface for any contract that wants to support safeTransfers
17  * from ERC721 asset contracts.
18  */
19 interface IERC721Receiver {
20     /**
21      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
22      * by `operator` from `from`, this function is called.
23      *
24      * It must return its Solidity selector to confirm the token transfer.
25      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
26      *
27      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
28      */
29     function onERC721Received(
30         address operator,
31         address from,
32         uint256 tokenId,
33         bytes calldata data
34     ) external returns (bytes4);
35 }
36 
37 pragma solidity ^0.8.1;
38 
39 /**
40  * @dev Collection of functions related to the address type
41  */
42 library Address {
43     /**
44      * @dev Returns true if `account` is a contract.
45      *
46      * [IMPORTANT]
47      * ====
48      * It is unsafe to assume that an address for which this function returns
49      * false is an externally-owned account (EOA) and not a contract.
50      *
51      * Among others, `isContract` will return false for the following
52      * types of addresses:
53      *
54      *  - an externally-owned account
55      *  - a contract in construction
56      *  - an address where a contract will be created
57      *  - an address where a contract lived, but was destroyed
58      * ====
59      *
60      * [IMPORTANT]
61      * ====
62      * You shouldn't rely on `isContract` to protect against flash loan attacks!
63      *
64      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
65      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
66      * constructor.
67      * ====
68      */
69     function isContract(address account) internal view returns (bool) {
70         // This method relies on extcodesize/address.code.length, which returns 0
71         // for contracts in construction, since the code is only stored at the end
72         // of the constructor execution.
73 
74         return account.code.length > 0;
75     }
76 
77     /**
78      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
79      * `recipient`, forwarding all available gas and reverting on errors.
80      *
81      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
82      * of certain opcodes, possibly making contracts go over the 2300 gas limit
83      * imposed by `transfer`, making them unable to receive funds via
84      * `transfer`. {sendValue} removes this limitation.
85      *
86      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
87      *
88      * IMPORTANT: because control is transferred to `recipient`, care must be
89      * taken to not create reentrancy vulnerabilities. Consider using
90      * {ReentrancyGuard} or the
91      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
92      */
93     function sendValue(address payable recipient, uint256 amount) internal {
94         require(address(this).balance >= amount, "Address: insufficient balance");
95 
96         (bool success, ) = recipient.call{value: amount}("");
97         require(success, "Address: unable to send value, recipient may have reverted");
98     }
99 
100     /**
101      * @dev Performs a Solidity function call using a low level `call`. A
102      * plain `call` is an unsafe replacement for a function call: use this
103      * function instead.
104      *
105      * If `target` reverts with a revert reason, it is bubbled up by this
106      * function (like regular Solidity function calls).
107      *
108      * Returns the raw returned data. To convert to the expected return value,
109      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
110      *
111      * Requirements:
112      *
113      * - `target` must be a contract.
114      * - calling `target` with `data` must not revert.
115      *
116      * _Available since v3.1._
117      */
118     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
119         return functionCall(target, data, "Address: low-level call failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
124      * `errorMessage` as a fallback revert reason when `target` reverts.
125      *
126      * _Available since v3.1._
127      */
128     function functionCall(
129         address target,
130         bytes memory data,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, 0, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
138      * but also transferring `value` wei to `target`.
139      *
140      * Requirements:
141      *
142      * - the calling contract must have an ETH balance of at least `value`.
143      * - the called Solidity function must be `payable`.
144      *
145      * _Available since v3.1._
146      */
147     function functionCallWithValue(
148         address target,
149         bytes memory data,
150         uint256 value
151     ) internal returns (bytes memory) {
152         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
157      * with `errorMessage` as a fallback revert reason when `target` reverts.
158      *
159      * _Available since v3.1._
160      */
161     function functionCallWithValue(
162         address target,
163         bytes memory data,
164         uint256 value,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         require(address(this).balance >= value, "Address: insufficient balance for call");
168         require(isContract(target), "Address: call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.call{value: value}(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
181         return functionStaticCall(target, data, "Address: low-level static call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
186      * but performing a static call.
187      *
188      * _Available since v3.3._
189      */
190     function functionStaticCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal view returns (bytes memory) {
195         require(isContract(target), "Address: static call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.staticcall(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but performing a delegate call.
204      *
205      * _Available since v3.4._
206      */
207     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
208         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
213      * but performing a delegate call.
214      *
215      * _Available since v3.4._
216      */
217     function functionDelegateCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(isContract(target), "Address: delegate call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.delegatecall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
230      * revert reason using the provided one.
231      *
232      * _Available since v4.3._
233      */
234     function verifyCallResult(
235         bool success,
236         bytes memory returndata,
237         string memory errorMessage
238     ) internal pure returns (bytes memory) {
239         if (success) {
240             return returndata;
241         } else {
242             // Look for revert reason and bubble it up if present
243             if (returndata.length > 0) {
244                 // The easiest way to bubble the revert reason is using memory via assembly
245 
246                 assembly {
247                     let returndata_size := mload(returndata)
248                     revert(add(32, returndata), returndata_size)
249                 }
250             } else {
251                 revert(errorMessage);
252             }
253         }
254     }
255 }
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Provides information about the current execution context, including the
261  * sender of the transaction and its data. While these are generally available
262  * via msg.sender and msg.data, they should not be accessed in such a direct
263  * manner, since when dealing with meta-transactions the account sending and
264  * paying for execution may not be the actual sender (as far as an application
265  * is concerned).
266  *
267  * This contract is only required for intermediate, library-like contracts.
268  */
269 abstract contract Context {
270     function _msgSender() internal view virtual returns (address) {
271         return msg.sender;
272     }
273 
274     function _msgData() internal view virtual returns (bytes calldata) {
275         return msg.data;
276     }
277 }
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev String operations.
283  */
284 library Strings {
285     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
289      */
290     function toString(uint256 value) internal pure returns (string memory) {
291         // Inspired by OraclizeAPI's implementation - MIT licence
292         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
293 
294         if (value == 0) {
295             return "0";
296         }
297         uint256 temp = value;
298         uint256 digits;
299         while (temp != 0) {
300             digits++;
301             temp /= 10;
302         }
303         bytes memory buffer = new bytes(digits);
304         while (value != 0) {
305             digits -= 1;
306             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
307             value /= 10;
308         }
309         return string(buffer);
310     }
311 
312     /**
313      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
314      */
315     function toHexString(uint256 value) internal pure returns (string memory) {
316         if (value == 0) {
317             return "0x00";
318         }
319         uint256 temp = value;
320         uint256 length = 0;
321         while (temp != 0) {
322             length++;
323             temp >>= 8;
324         }
325         return toHexString(value, length);
326     }
327 
328     /**
329      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
330      */
331     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
332         bytes memory buffer = new bytes(2 * length + 2);
333         buffer[0] = "0";
334         buffer[1] = "x";
335         for (uint256 i = 2 * length + 1; i > 1; --i) {
336             buffer[i] = _HEX_SYMBOLS[value & 0xf];
337             value >>= 4;
338         }
339         require(value == 0, "Strings: hex length insufficient");
340         return string(buffer);
341     }
342 }
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Interface of the ERC165 standard, as defined in the
348  * https://eips.ethereum.org/EIPS/eip-165[EIP].
349  *
350  * Implementers can declare support of contract interfaces, which can then be
351  * queried by others ({ERC165Checker}).
352  *
353  * For an implementation, see {ERC165}.
354  */
355 interface IERC165 {
356     /**
357      * @dev Returns true if this contract implements the interface defined by
358      * `interfaceId`. See the corresponding
359      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
360      * to learn more about how these ids are created.
361      *
362      * This function call must use less than 30 000 gas.
363      */
364     function supportsInterface(bytes4 interfaceId) external view returns (bool);
365 }
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Implementation of the {IERC165} interface.
371  *
372  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
373  * for the additional interface id that will be supported. For example:
374  *
375  * ```solidity
376  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
378  * }
379  * ```
380  *
381  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
382  */
383 abstract contract ERC165 is IERC165 {
384     /**
385      * @dev See {IERC165-supportsInterface}.
386      */
387     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
388         return interfaceId == type(IERC165).interfaceId;
389     }
390 }
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Required interface of an ERC721 compliant contract.
396  */
397 interface IERC721 is IERC165 {
398     /**
399      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
405      */
406     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
410      */
411     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
412 
413     /**
414      * @dev Returns the number of tokens in ``owner``'s account.
415      */
416     function balanceOf(address owner) external view returns (uint256 balance);
417 
418     /**
419      * @dev Returns the owner of the `tokenId` token.
420      *
421      * Requirements:
422      *
423      * - `tokenId` must exist.
424      */
425     function ownerOf(uint256 tokenId) external view returns (address owner);
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
429      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Transfers `tokenId` token from `from` to `to`.
449      *
450      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      *
459      * Emits a {Transfer} event.
460      */
461     function transferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
469      * The approval is cleared when the token is transferred.
470      *
471      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
472      *
473      * Requirements:
474      *
475      * - The caller must own the token or be an approved operator.
476      * - `tokenId` must exist.
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address to, uint256 tokenId) external;
481 
482     /**
483      * @dev Returns the account approved for `tokenId` token.
484      *
485      * Requirements:
486      *
487      * - `tokenId` must exist.
488      */
489     function getApproved(uint256 tokenId) external view returns (address operator);
490 
491     /**
492      * @dev Approve or remove `operator` as an operator for the caller.
493      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
494      *
495      * Requirements:
496      *
497      * - The `operator` cannot be the caller.
498      *
499      * Emits an {ApprovalForAll} event.
500      */
501     function setApprovalForAll(address operator, bool _approved) external;
502 
503     /**
504      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
505      *
506      * See {setApprovalForAll}
507      */
508     function isApprovedForAll(address owner, address operator) external view returns (bool);
509 
510     /**
511      * @dev Safely transfers `tokenId` token from `from` to `to`.
512      *
513      * Requirements:
514      *
515      * - `from` cannot be the zero address.
516      * - `to` cannot be the zero address.
517      * - `tokenId` token must exist and be owned by `from`.
518      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
519      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
520      *
521      * Emits a {Transfer} event.
522      */
523     function safeTransferFrom(
524         address from,
525         address to,
526         uint256 tokenId,
527         bytes calldata data
528     ) external;
529 }
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Metadata is IERC721 {
538     /**
539      * @dev Returns the token collection name.
540      */
541     function name() external view returns (string memory);
542 
543     /**
544      * @dev Returns the token collection symbol.
545      */
546     function symbol() external view returns (string memory);
547 
548     /**
549      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
558  * @dev See https://eips.ethereum.org/EIPS/eip-721
559  */
560 interface IERC721Enumerable is IERC721 {
561     /**
562      * @dev Returns the total amount of tokens stored by the contract.
563      */
564     function totalSupply() external view returns (uint256);
565 
566     /**
567      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
568      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
569      */
570     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
571 
572     /**
573      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
574      * Use along with {totalSupply} to enumerate all tokens.
575      */
576     function tokenByIndex(uint256 index) external view returns (uint256);
577 }
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Contract module which provides a basic access control mechanism, where
583  * there is an account (an owner) that can be granted exclusive access to
584  * specific functions.
585  *
586  * By default, the owner account will be the one that deploys the contract. This
587  * can later be changed with {transferOwnership}.
588  *
589  * This module is used through inheritance. It will make available the modifier
590  * `onlyOwner`, which can be applied to your functions to restrict their use to
591  * the owner.
592  */
593 abstract contract Ownable is Context {
594     address private _owner;
595 
596     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
597 
598     /**
599      * @dev Initializes the contract setting the deployer as the initial owner.
600      */
601     constructor() {
602         _transferOwnership(_msgSender());
603     }
604 
605     /**
606      * @dev Returns the address of the current owner.
607      */
608     function owner() public view virtual returns (address) {
609         return _owner;
610     }
611 
612     /**
613      * @dev Throws if called by any account other than the owner.
614      */
615     modifier onlyOwner() {
616         require(owner() == _msgSender(), "Ownable: caller is not the owner");
617         _;
618     }
619 
620     /**
621      * @dev Leaves the contract without owner. It will not be possible to call
622      * `onlyOwner` functions anymore. Can only be called by the current owner.
623      *
624      * NOTE: Renouncing ownership will leave the contract without an owner,
625      * thereby removing any functionality that is only available to the owner.
626      */
627     function renounceOwnership() public virtual onlyOwner {
628         _transferOwnership(address(0));
629     }
630 
631     /**
632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
633      * Can only be called by the current owner.
634      */
635     function transferOwnership(address newOwner) public virtual onlyOwner {
636         require(newOwner != address(0), "Ownable: new owner is the zero address");
637         _transferOwnership(newOwner);
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      * Internal function without access restriction.
643      */
644     function _transferOwnership(address newOwner) internal virtual {
645         address oldOwner = _owner;
646         _owner = newOwner;
647         emit OwnershipTransferred(oldOwner, newOwner);
648     }
649 }
650 
651 pragma solidity ^0.8.4;
652 
653 error ApprovalCallerNotOwnerNorApproved();
654 error ApprovalQueryForNonexistentToken();
655 error ApproveToCaller();
656 error ApprovalToCurrentOwner();
657 error BalanceQueryForZeroAddress();
658 error MintedQueryForZeroAddress();
659 error BurnedQueryForZeroAddress();
660 error MintToZeroAddress();
661 error MintZeroQuantity();
662 error OwnerIndexOutOfBounds();
663 error OwnerQueryForNonexistentToken();
664 error TokenIndexOutOfBounds();
665 error TransferCallerNotOwnerNorApproved();
666 error TransferFromIncorrectOwner();
667 error TransferToNonERC721ReceiverImplementer();
668 error TransferToZeroAddress();
669 error URIQueryForNonexistentToken();
670 
671 /**
672  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
673  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
674  *
675  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
676  *
677  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
678  *
679  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
680  */
681 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
682     using Address for address;
683     using Strings for uint256;
684 
685     // Compiler will pack this into a single 256bit word.
686     struct TokenOwnership {
687         // The address of the owner.
688         address addr;
689         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
690         uint64 startTimestamp;
691         // Whether the token has been burned.
692         bool burned;
693     }
694 
695     // Compiler will pack this into a single 256bit word.
696     struct AddressData {
697         // Realistically, 2**64-1 is more than enough.
698         uint64 balance;
699         // Keeps track of mint count with minimal overhead for tokenomics.
700         uint64 numberMinted;
701         // Keeps track of burn count with minimal overhead for tokenomics.
702         uint64 numberBurned;
703     }
704 
705     // Compiler will pack the following 
706     // _currentIndex and _burnCounter into a single 256bit word.
707     
708     // The tokenId of the next token to be minted.
709     uint128 internal _currentIndex;
710 
711     // The number of tokens burned.
712     uint128 internal _burnCounter;
713 
714     // Token name
715     string private _name;
716 
717     // Token symbol
718     string private _symbol;
719 
720     // Mapping from token ID to ownership details
721     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
722     mapping(uint256 => TokenOwnership) internal _ownerships;
723 
724     // Mapping owner address to address data
725     mapping(address => AddressData) private _addressData;
726 
727     // Mapping from token ID to approved address
728     mapping(uint256 => address) private _tokenApprovals;
729 
730     // Mapping from owner to operator approvals
731     mapping(address => mapping(address => bool)) private _operatorApprovals;
732 
733     constructor(string memory name_, string memory symbol_) {
734         _name = name_;
735         _symbol = symbol_;
736     }
737 
738     /**
739      * @dev See {IERC721Enumerable-totalSupply}.
740      */
741     function totalSupply() public view override returns (uint256) {
742         // Counter underflow is impossible as _burnCounter cannot be incremented
743         // more than _currentIndex times
744         unchecked {
745             return _currentIndex - _burnCounter;    
746         }
747     }
748 
749     /**
750      * @dev See {IERC721Enumerable-tokenByIndex}.
751      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
752      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
753      */
754     function tokenByIndex(uint256 index) public view override returns (uint256) {
755         uint256 numMintedSoFar = _currentIndex;
756         uint256 tokenIdsIdx;
757 
758         // Counter overflow is impossible as the loop breaks when
759         // uint256 i is equal to another uint256 numMintedSoFar.
760         unchecked {
761             for (uint256 i; i < numMintedSoFar; i++) {
762                 TokenOwnership memory ownership = _ownerships[i];
763                 if (!ownership.burned) {
764                     if (tokenIdsIdx == index) {
765                         return i;
766                     }
767                     tokenIdsIdx++;
768                 }
769             }
770         }
771         revert TokenIndexOutOfBounds();
772     }
773 
774     /**
775      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
776      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
777      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
778      */
779     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
780         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
781         uint256 numMintedSoFar = _currentIndex;
782         uint256 tokenIdsIdx;
783         address currOwnershipAddr;
784 
785         // Counter overflow is impossible as the loop breaks when
786         // uint256 i is equal to another uint256 numMintedSoFar.
787         unchecked {
788             for (uint256 i; i < numMintedSoFar; i++) {
789                 TokenOwnership memory ownership = _ownerships[i];
790                 if (ownership.burned) {
791                     continue;
792                 }
793                 if (ownership.addr != address(0)) {
794                     currOwnershipAddr = ownership.addr;
795                 }
796                 if (currOwnershipAddr == owner) {
797                     if (tokenIdsIdx == index) {
798                         return i;
799                     }
800                     tokenIdsIdx++;
801                 }
802             }
803         }
804 
805         // Execution should never reach this point.
806         revert();
807     }
808 
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
813         return
814             interfaceId == type(IERC721).interfaceId ||
815             interfaceId == type(IERC721Metadata).interfaceId ||
816             interfaceId == type(IERC721Enumerable).interfaceId ||
817             super.supportsInterface(interfaceId);
818     }
819 
820     /**
821      * @dev See {IERC721-balanceOf}.
822      */
823     function balanceOf(address owner) public view override returns (uint256) {
824         if (owner == address(0)) revert BalanceQueryForZeroAddress();
825         return uint256(_addressData[owner].balance);
826     }
827 
828     function _numberMinted(address owner) internal view returns (uint256) {
829         if (owner == address(0)) revert MintedQueryForZeroAddress();
830         return uint256(_addressData[owner].numberMinted);
831     }
832 
833     function _numberBurned(address owner) internal view returns (uint256) {
834         if (owner == address(0)) revert BurnedQueryForZeroAddress();
835         return uint256(_addressData[owner].numberBurned);
836     }
837 
838     /**
839      * Gas spent here starts off proportional to the maximum mint batch size.
840      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
841      */
842     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
843         uint256 curr = tokenId;
844 
845         unchecked {
846             if (curr < _currentIndex) {
847                 TokenOwnership memory ownership = _ownerships[curr];
848                 if (!ownership.burned) {
849                     if (ownership.addr != address(0)) {
850                         return ownership;
851                     }
852                     // Invariant: 
853                     // There will always be an ownership that has an address and is not burned 
854                     // before an ownership that does not have an address and is not burned.
855                     // Hence, curr will not underflow.
856                     while (true) {
857                         curr--;
858                         ownership = _ownerships[curr];
859                         if (ownership.addr != address(0)) {
860                             return ownership;
861                         }
862                     }
863                 }
864             }
865         }
866         revert OwnerQueryForNonexistentToken();
867     }
868 
869     /**
870      * @dev See {IERC721-ownerOf}.
871      */
872     function ownerOf(uint256 tokenId) public view override returns (address) {
873         return ownershipOf(tokenId).addr;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-name}.
878      */
879     function name() public view virtual override returns (string memory) {
880         return _name;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-symbol}.
885      */
886     function symbol() public view virtual override returns (string memory) {
887         return _symbol;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-tokenURI}.
892      */
893     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
894         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
895 
896         string memory baseURI = _baseURI();
897         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
898     }
899 
900     /**
901      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
902      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
903      * by default, can be overriden in child contracts.
904      */
905     function _baseURI() internal view virtual returns (string memory) {
906         return '';
907     }
908 
909     /**
910      * @dev See {IERC721-approve}.
911      */
912     function approve(address to, uint256 tokenId) public override {
913         address owner = ERC721A.ownerOf(tokenId);
914         if (to == owner) revert ApprovalToCurrentOwner();
915 
916         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
917             revert ApprovalCallerNotOwnerNorApproved();
918         }
919 
920         _approve(to, tokenId, owner);
921     }
922 
923     /**
924      * @dev See {IERC721-getApproved}.
925      */
926     function getApproved(uint256 tokenId) public view override returns (address) {
927         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
928 
929         return _tokenApprovals[tokenId];
930     }
931 
932     /**
933      * @dev See {IERC721-setApprovalForAll}.
934      */
935     function setApprovalForAll(address operator, bool approved) public override {
936         if (operator == _msgSender()) revert ApproveToCaller();
937 
938         _operatorApprovals[_msgSender()][operator] = approved;
939         emit ApprovalForAll(_msgSender(), operator, approved);
940     }
941 
942     /**
943      * @dev See {IERC721-isApprovedForAll}.
944      */
945     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
946         return _operatorApprovals[owner][operator];
947     }
948 
949     /**
950      * @dev See {IERC721-transferFrom}.
951      */
952     function transferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         _transfer(from, to, tokenId);
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId
967     ) public virtual override {
968         safeTransferFrom(from, to, tokenId, '');
969     }
970 
971     /**
972      * @dev See {IERC721-safeTransferFrom}.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) public virtual override {
980         _transfer(from, to, tokenId);
981         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
982             revert TransferToNonERC721ReceiverImplementer();
983         }
984     }
985 
986     /**
987      * @dev Returns whether `tokenId` exists.
988      *
989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
990      *
991      * Tokens start existing when they are minted (`_mint`),
992      */
993     function _exists(uint256 tokenId) internal view returns (bool) {
994         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
995     }
996 
997     function _safeMint(address to, uint256 quantity) internal {
998         _safeMint(to, quantity, '');
999     }
1000 
1001     /**
1002      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1007      * - `quantity` must be greater than 0.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _safeMint(
1012         address to,
1013         uint256 quantity,
1014         bytes memory _data
1015     ) internal {
1016         _mint(to, quantity, _data, true);
1017     }
1018 
1019     /**
1020      * @dev Mints `quantity` tokens and transfers them to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `quantity` must be greater than 0.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _mint(
1030         address to,
1031         uint256 quantity,
1032         bytes memory _data,
1033         bool safe
1034     ) internal {
1035         uint256 startTokenId = _currentIndex;
1036         if (to == address(0)) revert MintToZeroAddress();
1037         if (quantity == 0) revert MintZeroQuantity();
1038 
1039         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1040 
1041         // Overflows are incredibly unrealistic.
1042         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1043         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1044         unchecked {
1045             _addressData[to].balance += uint64(quantity);
1046             _addressData[to].numberMinted += uint64(quantity);
1047 
1048             _ownerships[startTokenId].addr = to;
1049             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1050 
1051             uint256 updatedIndex = startTokenId;
1052 
1053             for (uint256 i; i < quantity; i++) {
1054                 emit Transfer(address(0), to, updatedIndex);
1055                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1056                     revert TransferToNonERC721ReceiverImplementer();
1057                 }
1058                 updatedIndex++;
1059             }
1060 
1061             _currentIndex = uint128(updatedIndex);
1062         }
1063         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1064     }
1065 
1066     /**
1067      * @dev Transfers `tokenId` from `from` to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `tokenId` token must be owned by `from`.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _transfer(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) private {
1081         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1082 
1083         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1084             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1085             getApproved(tokenId) == _msgSender());
1086 
1087         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1088         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1089         if (to == address(0)) revert TransferToZeroAddress();
1090 
1091         _beforeTokenTransfers(from, to, tokenId, 1);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId, prevOwnership.addr);
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1099         unchecked {
1100             _addressData[from].balance -= 1;
1101             _addressData[to].balance += 1;
1102 
1103             _ownerships[tokenId].addr = to;
1104             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1105 
1106             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1107             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1108             uint256 nextTokenId = tokenId + 1;
1109             if (_ownerships[nextTokenId].addr == address(0)) {
1110                 // This will suffice for checking _exists(nextTokenId),
1111                 // as a burned slot cannot contain the zero address.
1112                 if (nextTokenId < _currentIndex) {
1113                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1114                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1115                 }
1116             }
1117         }
1118 
1119         emit Transfer(from, to, tokenId);
1120         _afterTokenTransfers(from, to, tokenId, 1);
1121     }
1122 
1123     /**
1124      * @dev Destroys `tokenId`.
1125      * The approval is cleared when the token is burned.
1126      *
1127      * Requirements:
1128      *
1129      * - `tokenId` must exist.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _burn(uint256 tokenId) internal virtual {
1134         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1135 
1136         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1137 
1138         // Clear approvals from the previous owner
1139         _approve(address(0), tokenId, prevOwnership.addr);
1140 
1141         // Underflow of the sender's balance is impossible because we check for
1142         // ownership above and the recipient's balance can't realistically overflow.
1143         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1144         unchecked {
1145             _addressData[prevOwnership.addr].balance -= 1;
1146             _addressData[prevOwnership.addr].numberBurned += 1;
1147 
1148             // Keep track of who burned the token, and the timestamp of burning.
1149             _ownerships[tokenId].addr = prevOwnership.addr;
1150             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1151             _ownerships[tokenId].burned = true;
1152 
1153             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1154             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1155             uint256 nextTokenId = tokenId + 1;
1156             if (_ownerships[nextTokenId].addr == address(0)) {
1157                 // This will suffice for checking _exists(nextTokenId),
1158                 // as a burned slot cannot contain the zero address.
1159                 if (nextTokenId < _currentIndex) {
1160                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1161                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1162                 }
1163             }
1164         }
1165 
1166         emit Transfer(prevOwnership.addr, address(0), tokenId);
1167         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1168 
1169         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1170         unchecked { 
1171             _burnCounter++;
1172         }
1173     }
1174 
1175     /**
1176      * @dev Approve `to` to operate on `tokenId`
1177      *
1178      * Emits a {Approval} event.
1179      */
1180     function _approve(
1181         address to,
1182         uint256 tokenId,
1183         address owner
1184     ) private {
1185         _tokenApprovals[tokenId] = to;
1186         emit Approval(owner, to, tokenId);
1187     }
1188 
1189     /**
1190      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1191      * The call is not executed if the target address is not a contract.
1192      *
1193      * @param from address representing the previous owner of the given token ID
1194      * @param to target address that will receive the tokens
1195      * @param tokenId uint256 ID of the token to be transferred
1196      * @param _data bytes optional data to send along with the call
1197      * @return bool whether the call correctly returned the expected magic value
1198      */
1199     function _checkOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         if (to.isContract()) {
1206             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1207                 return retval == IERC721Receiver(to).onERC721Received.selector;
1208             } catch (bytes memory reason) {
1209                 if (reason.length == 0) {
1210                     revert TransferToNonERC721ReceiverImplementer();
1211                 } else {
1212                     assembly {
1213                         revert(add(32, reason), mload(reason))
1214                     }
1215                 }
1216             }
1217         } else {
1218             return true;
1219         }
1220     }
1221 
1222     /**
1223      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1224      * And also called before burning one token.
1225      *
1226      * startTokenId - the first token id to be transferred
1227      * quantity - the amount to be transferred
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` will be minted for `to`.
1234      * - When `to` is zero, `tokenId` will be burned by `from`.
1235      * - `from` and `to` are never both zero.
1236      */
1237     function _beforeTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1246      * minting.
1247      * And also called after one token has been burned.
1248      *
1249      * startTokenId - the first token id to be transferred
1250      * quantity - the amount to be transferred
1251      *
1252      * Calling conditions:
1253      *
1254      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1255      * transferred to `to`.
1256      * - When `from` is zero, `tokenId` has been minted for `to`.
1257      * - When `to` is zero, `tokenId` has been burned by `from`.
1258      * - `from` and `to` are never both zero.
1259      */
1260     function _afterTokenTransfers(
1261         address from,
1262         address to,
1263         uint256 startTokenId,
1264         uint256 quantity
1265     ) internal virtual {}
1266 }
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 /**
1271  * @dev These functions deal with verification of Merkle Trees proofs.
1272  *
1273  * The proofs can be generated using the JavaScript library
1274  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1275  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1276  *
1277  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1278  *
1279  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1280  * hashing, or use a hash function other than keccak256 for hashing leaves.
1281  * This is because the concatenation of a sorted pair of internal nodes in
1282  * the merkle tree could be reinterpreted as a leaf value.
1283  */
1284 library MerkleProof {
1285     /**
1286      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1287      * defined by `root`. For this, a `proof` must be provided, containing
1288      * sibling hashes on the branch from the leaf to the root of the tree. Each
1289      * pair of leaves and each pair of pre-images are assumed to be sorted.
1290      */
1291     function verify(
1292         bytes32[] memory proof,
1293         bytes32 root,
1294         bytes32 leaf
1295     ) internal pure returns (bool) {
1296         return processProof(proof, leaf) == root;
1297     }
1298 
1299     /**
1300      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1301      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1302      * hash matches the root of the tree. When processing the proof, the pairs
1303      * of leafs & pre-images are assumed to be sorted.
1304      *
1305      * _Available since v4.4._
1306      */
1307     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1308         bytes32 computedHash = leaf;
1309         for (uint256 i = 0; i < proof.length; i++) {
1310             bytes32 proofElement = proof[i];
1311             if (computedHash <= proofElement) {
1312                 // Hash(current computed hash + current element of the proof)
1313                 computedHash = _efficientHash(computedHash, proofElement);
1314             } else {
1315                 // Hash(current element of the proof + current computed hash)
1316                 computedHash = _efficientHash(proofElement, computedHash);
1317             }
1318         }
1319         return computedHash;
1320     }
1321 
1322     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1323         assembly {
1324             mstore(0x00, a)
1325             mstore(0x20, b)
1326             value := keccak256(0x00, 0x40)
1327         }
1328     }
1329 }
1330 
1331 contract zimmy_raiders is ERC721A, Ownable {
1332     uint256 public constant MAX_MINTS = 4;
1333     uint256 public constant MAX_SUPPLY = 5208;
1334     uint256 public constant NUMBER_RESERVED_TOKENS = 240;
1335     uint256 public reservedTokensMinted = 0;
1336     uint256 public mintRate = 0.065 ether;
1337     uint256 public alRate = 0.055 ether;
1338 
1339     bool public allowListIsActive = false;
1340     bool public saleIsActive = false;
1341 
1342     mapping(address => uint256) public allowListTimesMinted;
1343 
1344     bytes32 public rootHash;
1345 
1346     string public baseURI;
1347 
1348     constructor(bytes32 _rootHash) ERC721A("Zimmy Raiders", "ZR") {
1349         rootHash = _rootHash;
1350     }
1351 
1352     function mint(uint256 quantity) external payable {
1353         // _safeMint's second argument now takes in a quantity, not a tokenId.
1354         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1355         require(msg.value >= (mintRate * quantity), "Not enough ether sent");
1356         require(saleIsActive, "Public mint period not active");
1357         _safeMint(msg.sender, quantity);
1358     }
1359 
1360     function allowListMint(uint256 quantity, bytes32[] calldata _proof) external payable {
1361         // _safeMint's second argument now takes in a quantity, not a tokenId.
1362         bytes32 _address = keccak256(abi.encodePacked(msg.sender));
1363         require(MerkleProof.verify(_proof, rootHash, _address), "Address not found in whitelist");
1364         require(quantity + allowListTimesMinted[msg.sender] <= MAX_MINTS, "Only 4 allow list mints per wallet");
1365         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1366         require(msg.value >= (alRate * quantity), "Not enough ether sent");
1367         require(allowListIsActive, "Allow list mint period not active");
1368 
1369         allowListTimesMinted[msg.sender] += quantity;
1370         _safeMint(msg.sender, quantity);
1371     }
1372 
1373     function mintReservedTokens(address to, uint16 quantity) external onlyOwner 
1374     {
1375         require(reservedTokensMinted + quantity <= NUMBER_RESERVED_TOKENS, "This amount is more than max allowed");
1376 
1377         reservedTokensMinted += quantity;
1378 
1379         _safeMint(to, quantity); 
1380     }
1381 
1382     function withdraw() external payable onlyOwner {
1383         payable(owner()).transfer(address(this).balance);
1384     }
1385 
1386     function _baseURI() internal view override returns (string memory) {
1387         return baseURI;
1388     }
1389 
1390     function setMintRate(uint256 _mintRate) public onlyOwner {
1391         mintRate = _mintRate;
1392     }
1393 
1394     function setBaseURI(string memory uri) public onlyOwner {
1395         baseURI = uri;
1396     }
1397 
1398     function flipSaleState() public onlyOwner {
1399         saleIsActive = !saleIsActive;
1400     }
1401 
1402     function setRootHash(bytes32 _hash) public onlyOwner {
1403         rootHash = _hash;
1404     }
1405 
1406     function flipAllowlistState() public onlyOwner {
1407         allowListIsActive = !allowListIsActive;
1408     }
1409 }