1 // File: contracts/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 // File: contracts/Address.sol
70 
71 
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      *
96      * [IMPORTANT]
97      * ====
98      * You shouldn't rely on `isContract` to protect against flash loan attacks!
99      *
100      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
101      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
102      * constructor.
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize/address.code.length, which returns 0
107         // for contracts in construction, since the code is only stored at the end
108         // of the constructor execution.
109 
110         return account.code.length > 0;
111     }
112 
113     /**
114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
115      * `recipient`, forwarding all available gas and reverting on errors.
116      *
117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
119      * imposed by `transfer`, making them unable to receive funds via
120      * `transfer`. {sendValue} removes this limitation.
121      *
122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
123      *
124      * IMPORTANT: because control is transferred to `recipient`, care must be
125      * taken to not create reentrancy vulnerabilities. Consider using
126      * {ReentrancyGuard} or the
127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
128      */
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         (bool success, ) = recipient.call{value: amount}("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     /**
137      * @dev Performs a Solidity function call using a low level `call`. A
138      * plain `call` is an unsafe replacement for a function call: use this
139      * function instead.
140      *
141      * If `target` reverts with a revert reason, it is bubbled up by this
142      * function (like regular Solidity function calls).
143      *
144      * Returns the raw returned data. To convert to the expected return value,
145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
146      *
147      * Requirements:
148      *
149      * - `target` must be a contract.
150      * - calling `target` with `data` must not revert.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155         return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
160      * `errorMessage` as a fallback revert reason when `target` reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         require(address(this).balance >= value, "Address: insufficient balance for call");
204         require(isContract(target), "Address: call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.call{value: value}(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
217         return functionStaticCall(target, data, "Address: low-level static call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal view returns (bytes memory) {
231         require(isContract(target), "Address: static call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.staticcall(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
244         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         require(isContract(target), "Address: delegate call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.delegatecall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
266      * revert reason using the provided one.
267      *
268      * _Available since v4.3._
269      */
270     function verifyCallResult(
271         bool success,
272         bytes memory returndata,
273         string memory errorMessage
274     ) internal pure returns (bytes memory) {
275         if (success) {
276             return returndata;
277         } else {
278             // Look for revert reason and bubble it up if present
279             if (returndata.length > 0) {
280                 // The easiest way to bubble the revert reason is using memory via assembly
281 
282                 assembly {
283                     let returndata_size := mload(returndata)
284                     revert(add(32, returndata), returndata_size)
285                 }
286             } else {
287                 revert(errorMessage);
288             }
289         }
290     }
291 }
292 // File: contracts/IERC721Receiver.sol
293 
294 
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 // File: contracts/IERC165.sol
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @dev Interface of the ERC165 standard, as defined in the
328  * https://eips.ethereum.org/EIPS/eip-165[EIP].
329  *
330  * Implementers can declare support of contract interfaces, which can then be
331  * queried by others ({ERC165Checker}).
332  *
333  * For an implementation, see {ERC165}.
334  */
335 interface IERC165 {
336     /**
337      * @dev Returns true if this contract implements the interface defined by
338      * `interfaceId`. See the corresponding
339      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
340      * to learn more about how these ids are created.
341      *
342      * This function call must use less than 30 000 gas.
343      */
344     function supportsInterface(bytes4 interfaceId) external view returns (bool);
345 }
346 // File: contracts/ERC165.sol
347 
348 
349 
350 pragma solidity ^0.8.0;
351 
352 
353 /**
354  * @dev Implementation of the {IERC165} interface.
355  *
356  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
357  * for the additional interface id that will be supported. For example:
358  *
359  * ```solidity
360  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
361  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
362  * }
363  * ```
364  *
365  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
366  */
367 abstract contract ERC165 is IERC165 {
368     /**
369      * @dev See {IERC165-supportsInterface}.
370      */
371     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372         return interfaceId == type(IERC165).interfaceId;
373     }
374 }
375 // File: contracts/IERC721.sol
376 
377 
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Required interface of an ERC721 compliant contract.
384  */
385 interface IERC721 is IERC165 {
386     /**
387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
393      */
394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
398      */
399     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
400 
401     /**
402      * @dev Returns the number of tokens in ``owner``'s account.
403      */
404     function balanceOf(address owner) external view returns (uint256 balance);
405 
406     /**
407      * @dev Returns the owner of the `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function ownerOf(uint256 tokenId) external view returns (address owner);
414 
415     /**
416      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
417      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId
433     ) external;
434 
435     /**
436      * @dev Transfers `tokenId` token from `from` to `to`.
437      *
438      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
457      * The approval is cleared when the token is transferred.
458      *
459      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
460      *
461      * Requirements:
462      *
463      * - The caller must own the token or be an approved operator.
464      * - `tokenId` must exist.
465      *
466      * Emits an {Approval} event.
467      */
468     function approve(address to, uint256 tokenId) external;
469 
470     /**
471      * @dev Returns the account approved for `tokenId` token.
472      *
473      * Requirements:
474      *
475      * - `tokenId` must exist.
476      */
477     function getApproved(uint256 tokenId) external view returns (address operator);
478 
479     /**
480      * @dev Approve or remove `operator` as an operator for the caller.
481      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
482      *
483      * Requirements:
484      *
485      * - The `operator` cannot be the caller.
486      *
487      * Emits an {ApprovalForAll} event.
488      */
489     function setApprovalForAll(address operator, bool _approved) external;
490 
491     /**
492      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
493      *
494      * See {setApprovalForAll}
495      */
496     function isApprovedForAll(address owner, address operator) external view returns (bool);
497 
498     /**
499      * @dev Safely transfers `tokenId` token from `from` to `to`.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId,
515         bytes calldata data
516     ) external;
517 }
518 // File: contracts/IERC721Metadata.sol
519 
520 
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
527  * @dev See https://eips.ethereum.org/EIPS/eip-721
528  */
529 interface IERC721Metadata is IERC721 {
530     /**
531      * @dev Returns the token collection name.
532      */
533     function name() external view returns (string memory);
534 
535     /**
536      * @dev Returns the token collection symbol.
537      */
538     function symbol() external view returns (string memory);
539 
540     /**
541      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
542      */
543     function tokenURI(uint256 tokenId) external view returns (string memory);
544 }
545 // File: contracts/Context.sol
546 
547 
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Provides information about the current execution context, including the
553  * sender of the transaction and its data. While these are generally available
554  * via msg.sender and msg.data, they should not be accessed in such a direct
555  * manner, since when dealing with meta-transactions the account sending and
556  * paying for execution may not be the actual sender (as far as an application
557  * is concerned).
558  *
559  * This contract is only required for intermediate, library-like contracts.
560  */
561 abstract contract Context {
562     function _msgSender() internal view virtual returns (address) {
563         return msg.sender;
564     }
565 
566     function _msgData() internal view virtual returns (bytes calldata) {
567         return msg.data;
568     }
569 }
570 // File: contracts/Ownable.sol
571 
572 
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @dev Contract module which provides a basic access control mechanism, where
579  * there is an account (an owner) that can be granted exclusive access to
580  * specific functions.
581  *
582  * By default, the owner account will be the one that deploys the contract. This
583  * can later be changed with {transferOwnership}.
584  *
585  * This module is used through inheritance. It will make available the modifier
586  * `onlyOwner`, which can be applied to your functions to restrict their use to
587  * the owner.
588  */
589 abstract contract Ownable is Context {
590     address private _owner;
591 
592     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
593 
594     /**
595      * @dev Initializes the contract setting the deployer as the initial owner.
596      */
597     constructor() {
598         _transferOwnership(_msgSender());
599     }
600 
601     /**
602      * @dev Returns the address of the current owner.
603      */
604     function owner() public view virtual returns (address) {
605         return _owner;
606     }
607 
608     /**
609      * @dev Throws if called by any account other than the owner.
610      */
611     modifier onlyOwner() {
612         require(owner() == _msgSender(), "Ownable: caller is not the owner");
613         _;
614     }
615 
616     /**
617      * @dev Leaves the contract without owner. It will not be possible to call
618      * `onlyOwner` functions anymore. Can only be called by the current owner.
619      *
620      * NOTE: Renouncing ownership will leave the contract without an owner,
621      * thereby removing any functionality that is only available to the owner.
622      */
623     function renounceOwnership() public virtual onlyOwner {
624         _transferOwnership(address(0));
625     }
626 
627     /**
628      * @dev Transfers ownership of the contract to a new account (`newOwner`).
629      * Can only be called by the current owner.
630      */
631     function transferOwnership(address newOwner) public virtual onlyOwner {
632         require(newOwner != address(0), "Ownable: new owner is the zero address");
633         _transferOwnership(newOwner);
634     }
635 
636     /**
637      * @dev Transfers ownership of the contract to a new account (`newOwner`).
638      * Internal function without access restriction.
639      */
640     function _transferOwnership(address newOwner) internal virtual {
641         address oldOwner = _owner;
642         _owner = newOwner;
643         emit OwnershipTransferred(oldOwner, newOwner);
644     }
645 }
646 // File: contracts/MRSC-Mainnet.sol
647 
648 
649 pragma solidity ^0.8.0;
650 
651 
652 
653 
654 
655 
656 
657 
658 /*
659   It saves bytecode to revert on custom errors instead of using require
660   statements. We are just declaring these errors for reverting with upon various
661   conditions later in this contract. Thanks, Chiru Labs!
662 // */
663 // error ApprovalCallerNotOwnerNorApproved();
664 // error ApprovalQueryForNonexistentToken();
665 // error ApproveToCaller();
666 // error CapExceeded();
667 // error MintedQueryForZeroAddress();
668 // error MintToZeroAddress();
669 // error MintZeroQuantity();
670 // error NotAnAdmin();
671 // error OwnerIndexOutOfBounds();
672 // error OwnerQueryForNonexistentToken();
673 // error TokenIndexOutOfBounds();
674 // error TransferCallerNotOwnerNorApproved();
675 // error TransferFromIncorrectOwner();
676 // error TransferIsLockedGlobally();
677 // error TransferIsLocked();
678 // error TransferToNonERC721ReceiverImplementer();
679 // error TransferToZeroAddress();
680 // error URIQueryForNonexistentToken();
681 
682 /**
683   @title A minimalistic, gas-efficient ERC-721 implementation forked from the
684     `Super721` ERC-721 implementation used by SuperFarm.
685   
686   We honor the brvae knights:
687   
688   Tim Clancy
689   0xthrpw
690   Qazawat Zirak
691   Rostislav Khlebnikov
692 
693   This contract includes the gas efficiency techniques graciously shared with
694   the world in the specific ERC-721 implementation by Chiru Labs that is being
695   called "ERC-721A" (https://github.com/chiru-labs/ERC721A). We have validated
696   this contract against their test cases.
697 */
698 
699 /**
700 
701    ▄█   ▄█▄ ███▄▄▄▄    ▄█     ▄██████▄     ▄█    █▄        ███        ▄████████     ███      ▄██████▄   ▄█     █▄  ███▄▄▄▄   
702   ███ ▄███▀ ███▀▀▀██▄ ███    ███    ███   ███    ███   ▀█████████▄   ███    ███ ▀█████████▄ ███    ███ ███     ███ ███▀▀▀██▄ 
703   ███▐██▀   ███   ███ ███▌   ███    █▀    ███    ███      ▀███▀▀██   ███    █▀     ▀███▀▀██ ███    ███ ███     ███ ███   ███ 
704  ▄█████▀    ███   ███ ███▌  ▄███         ▄███▄▄▄▄███▄▄     ███   ▀   ███            ███   ▀ ███    ███ ███     ███ ███   ███ 
705 ▀▀█████▄    ███   ███ ███▌ ▀▀███ ████▄  ▀▀███▀▀▀▀███▀      ███     ▀███████████     ███     ███    ███ ███     ███ ███   ███ 
706   ███▐██▄   ███   ███ ███    ███    ███   ███    ███       ███              ███     ███     ███    ███ ███     ███ ███   ███ 
707   ███ ▀███▄ ███   ███ ███    ███    ███   ███    ███       ███        ▄█    ███     ███     ███    ███ ███ ▄█▄ ███ ███   ███ 
708   ███   ▀█▀  ▀█   █▀  █▀     ████████▀    ███    █▀       ▄████▀    ▄████████▀     ▄████▀    ▀██████▀   ▀███▀███▀   ▀█   █▀  
709   ▀                                                                                                                          
710 
711 */
712 
713 
714 contract knightstown is ERC165, IERC721, IERC721Metadata, Ownable{
715     using Address for address;
716     using Strings for uint256;
717 
718     string _name;
719 
720     string _symbol;
721 
722     string public metadataUri;
723 
724     uint256 private nextId = 1;
725 
726     mapping ( uint256 => address ) private owners;
727 
728     mapping ( address => uint256 ) private balances;
729 
730     mapping ( uint256 => address ) private tokenApprovals;
731 
732     mapping ( address => mapping( address => bool )) private operatorApprovals;
733 
734     mapping ( address => bool ) private administrators;
735 
736     mapping ( uint256 => bool ) public transferLocks;
737 
738     mapping(address => uint256) public ALAddressToCap;
739 
740     bool public PublicMintingPaused = true;
741     bool public ALMintingPaused = true;
742 
743     uint256 public MAX_CAP = 6969;
744 
745     uint8 public MAX_MINT_PER_TX = 2;
746 
747     uint256 private _price = 0 ether;
748 
749     /**
750       A modifier to see if a caller is an approved administrator.
751     */
752     modifier onlyAdmin () {
753         if (_msgSender() != owner() && !administrators[_msgSender()]) {
754           revert ("NotAnAdmin");
755         }
756         _;
757     }
758 
759     constructor () {
760         _name = "knightstown.wtf";
761         _symbol = "KNIGHT";
762         metadataUri = "";
763     }
764 
765   function name() external override view returns (string memory name_ret){
766       return _name;
767   }
768 
769   function symbol() external override view returns (string memory symbol_ret){
770       return _symbol;
771   }
772 
773     /**
774       Flag this contract as supporting the ERC-721 standard, the ERC-721 metadata
775       extension, and the enumerable ERC-721 extension.
776 
777       @param _interfaceId The identifier, as defined by ERC-165, of the contract
778         interface to support.
779 
780       @return Whether or not the interface being tested is supported.
781     */
782     function supportsInterface (
783       bytes4 _interfaceId
784     ) public view virtual override(ERC165, IERC165) returns (bool) {
785         return (  _interfaceId == type(IERC721).interfaceId)
786                   || (_interfaceId == type(IERC721Metadata).interfaceId)
787                   || (super.supportsInterface(_interfaceId)
788                 );
789     }
790 
791     /**
792       Return the total number of this token that have ever been minted.
793 
794       @return The total supply of minted tokens.
795     */
796     function totalSupply () public view returns (uint256) {
797         return nextId - 1;
798     }
799 
800     /**
801       Retrieve the number of distinct token IDs held by `_owner`.
802 
803       @param _owner The address to retrieve a count of held tokens for.
804 
805       @return The number of tokens held by `_owner`.
806     */
807     function balanceOf (
808       address _owner
809     ) external view override returns (uint256) {
810         return balances[_owner];
811     }
812 
813     /**
814       Just as Chiru Labs does, we maintain a sparse list of token owners; for
815       example if Alice owns tokens with ID #1 through #3 and Bob owns tokens #4
816       through #5, the ownership list would look like:
817 
818       [ 1: Alice, 2: 0x0, 3: 0x0, 4: Bob, 5: 0x0, ... ].
819 
820       This function is able to consume that sparse list for determining an actual
821       owner. Chiru Labs says that the gas spent here starts off proportional to
822       the maximum mint batch size and gradually moves to O(1) as tokens get
823       transferred.
824 
825       @param _id The ID of the token which we are finding the owner for.
826 
827       @return owner The owner of the token with ID of `_id`.
828     */
829     function _ownershipOf (
830       uint256 _id
831     ) private view returns (address owner) {
832       if (!_exists(_id)) { revert ("OwnerQueryForNonexistentToken"); }
833 
834       unchecked {
835           for (uint256 curr = _id;; curr--) {
836             owner = owners[curr];
837             if (owner != address(0)) {
838               return owner;
839             }
840           }
841       }
842     }
843 
844     /**
845       Return the address that holds a particular token ID.
846 
847       @param _id The token ID to check for the holding address of.
848 
849       @return The address that holds the token with ID of `_id`.
850     */
851     function ownerOf (
852       uint256 _id
853     ) external view override returns (address) {
854         return _ownershipOf(_id);
855     }
856 
857     /**
858       Return whether a particular token ID has been minted or not.
859 
860       @param _id The ID of a specific token to check for existence.
861 
862       @return Whether or not the token of ID `_id` exists.
863     */
864     function _exists (
865       uint256 _id
866     ) public view returns (bool) {
867         return _id > 0 && _id < nextId;
868     }
869 
870     /**
871       Return the address approved to perform transfers on behalf of the owner of
872       token `_id`. If no address is approved, this returns the zero address.
873 
874       @param _id The specific token ID to check for an approved address.
875 
876       @return The address that may operate on token `_id` on its owner's behalf.
877     */
878     function getApproved (
879       uint256 _id
880     ) public view override returns (address) {
881         if (!_exists(_id)) { revert ("ApprovalQueryForNonexistentToken"); }
882         return tokenApprovals[_id];
883     }
884 
885     /**
886       This function returns true if `_operator` is approved to transfer items
887       owned by `_owner`.
888 
889       @param _owner The owner of items to check for transfer ability.
890       @param _operator The potential transferrer of `_owner`'s items.
891 
892       @return Whether `_operator` may transfer items owned by `_owner`.
893     */
894     function isApprovedForAll (
895       address _owner,
896       address _operator
897     ) public view virtual override returns (bool) {
898         return operatorApprovals[_owner][_operator];
899     }
900 
901     /**
902       Return the token URI of the token with the specified `_id`. The token URI is
903       dynamically constructed from this contract's `metadataUri`.
904 
905       @param _id The ID of the token to retrive a metadata URI for.
906 
907       @return The metadata URI of the token with the ID of `_id`.
908     */
909     function tokenURI (
910       uint256 _id
911     ) external view virtual override returns (string memory) {
912         if (!_exists(_id)) { revert ("URIQueryForNonexistentToken"); }
913         return bytes(metadataUri).length != 0
914         ? string(abi.encodePacked(metadataUri, _id.toString(), ".json"))
915         : '';
916     }
917 
918     /**
919       This private helper function updates the token approval address of the token
920       with ID of `_id` to the address `_to` and emits an event that the address
921       `_owner` triggered this approval. This function emits an {Approval} event.
922 
923       @param _owner The owner of the token with the ID of `_id`.
924       @param _to The address that is being granted approval to the token `_id`.
925       @param _id The ID of the token that is having its approval granted.
926     */
927     function _approve (
928       address _owner,
929       address _to,
930       uint256 _id
931     ) private {
932       tokenApprovals[_id] = _to;
933       emit Approval(_owner, _to, _id);
934     }
935 
936     /**
937       Allow the owner of a particular token ID, or an approved operator of the
938       owner, to set the approved address of a particular token ID.
939 
940       @param _approved The address being approved to transfer the token of ID `_id`.
941       @param _id The token ID with its approved address being set to `_approved`.
942     */
943     function approve (
944       address _approved,
945       uint256 _id
946     ) external override {
947         address owner = _ownershipOf(_id);
948         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
949             revert ("ApprovalCallerNotOwnerNorApproved");
950         }
951 
952         _approve(owner, _approved, _id);
953     }
954 
955     /**
956       Enable or disable approval for a third party `_operator` address to manage
957       all of the caller's tokens.
958 
959       @param _operator The address to grant management rights over all of the
960         caller's tokens.
961       @param _approved The status of the `_operator`'s approval for the caller.
962     */
963     function setApprovalForAll (
964       address _operator,
965       bool _approved
966     ) external override {
967         operatorApprovals[_msgSender()][_operator] = _approved;
968         emit ApprovalForAll(_msgSender(), _operator, _approved);
969     }
970 
971     /**
972       This private helper function handles the portion of transferring an ERC-721
973       token that is common to both the unsafe `transferFrom` and the
974       `safeTransferFrom` variants.
975 
976       This function does not support burning tokens and emits a {Transfer} event.
977 
978       @param _from The address to transfer the token with ID of `_id` from.
979       @param _to The address to transfer the token to.
980       @param _id The ID of the token to transfer.
981     */
982     function _transfer (
983       address _from,
984       address _to,
985       uint256 _id
986     ) private {
987         address previousOwner = _ownershipOf(_id);
988         bool isApprovedOrOwner = (_msgSender() == previousOwner)
989         || (isApprovedForAll(previousOwner, _msgSender()))
990         || (getApproved(_id) == _msgSender());
991 
992         if (!isApprovedOrOwner) { revert ("TransferCallerNotOwnerNorApproved"); }
993         if (previousOwner != _from) { revert ("TransferFromIncorrectOwner"); }
994         if (_to == address(0)) { revert ("TransferToZeroAddress"); }
995         if (transferLocks[_id]) { revert ("TransferIsLocked"); }
996 
997         // Clear any token approval set by the previous owner.
998         _approve(previousOwner, address(0), _id);
999 
1000         unchecked {
1001           balances[_from] -= 1;
1002           balances[_to] += 1;
1003           owners[_id] = _to;
1004 
1005           uint256 nextTokenId = _id + 1;
1006           if (owners[nextTokenId] == address(0) && _exists(nextTokenId)) {
1007               owners[nextTokenId] = previousOwner;
1008           }
1009         }
1010 
1011         emit Transfer(_from, _to, _id);
1012     }
1013 
1014     function mintCommunityKnights(uint256 _mintAmount) external onlyOwner{
1015       uint256 supply = totalSupply();
1016 
1017       require( ( (!PublicMintingPaused) || ( msg.sender == owner() )), "Contract is paused");
1018       require(_mintAmount > 0, "Mint amount must be greater than 0");
1019       require(supply + _mintAmount <= MAX_CAP, "Mint amount exceeds max supply");
1020 
1021       cheapMint(msg.sender, _mintAmount);
1022     }
1023 
1024     function mintAllowList(uint256 _mintAmount) public {
1025         uint256 supply = totalSupply();
1026         require(!ALMintingPaused, "Private sale not active");
1027         require(PublicMintingPaused, "AL Finished, public sale active");
1028         require(_mintAmount > 0, "Mint amount must be greater than 0");
1029         require(_mintAmount <= MAX_MINT_PER_TX, "Mint amount exceeds max per transaction");
1030         require(supply + _mintAmount <= MAX_CAP, "Mint amount exceeds max supply");
1031         require(ALAddressToCap[msg.sender] > 0, "not eligible for allowlist mint");
1032         require(ALAddressToCap[msg.sender] >= _mintAmount, "can't mint that many");
1033 
1034         //Reduce number of allocation
1035         ALAddressToCap[msg.sender] -= _mintAmount;
1036         cheapMint(msg.sender, _mintAmount);
1037     }
1038 
1039 
1040 
1041     function mintPublic(uint256 _mintAmount) public payable {
1042       uint256 supply = totalSupply();
1043       require(ALMintingPaused, "Private sale still active");
1044       require( ( (!PublicMintingPaused) || ( msg.sender == owner() )), "Contract is paused");
1045       require(_mintAmount > 0, "Mint amount must be greater than 0");
1046       require(_mintAmount <= MAX_MINT_PER_TX, "Mint amount exceeds max per transaction");
1047       require(supply + _mintAmount <= MAX_CAP, "Mint amount exceeds max supply");
1048 
1049       if (msg.sender != owner()) {
1050           require(msg.value >= _price * _mintAmount);
1051       }
1052 
1053       cheapMint(msg.sender, _mintAmount);
1054     }
1055 
1056 
1057     /**
1058       This function performs an unsafe transfer of token ID `_id` from address
1059       `_from` to address `_to`. The transfer is considered unsafe because it does
1060       not validate that the receiver can actually take proper receipt of an
1061       ERC-721 token.
1062 
1063       @param _from The address to transfer the token from.
1064       @param _to The address to transfer the token to.
1065       @param _id The ID of the token being transferred.
1066     */
1067     function transferFrom (
1068       address _from,
1069       address _to,
1070       uint256 _id
1071     ) external virtual override {
1072         _transfer(_from, _to, _id);
1073     }
1074 
1075     /**
1076       This is an private helper function used to, if the transfer destination is
1077       found to be a smart contract, check to see if that contract reports itself
1078       as safely handling ERC-721 tokens by returning the magical value from its
1079       `onERC721Received` function.
1080 
1081       @param _from The address of the previous owner of token `_id`.
1082       @param _to The destination address that will receive the token.
1083       @param _id The ID of the token being transferred.
1084       @param _data Optional data to send along with the transfer check.
1085 
1086       @return Whether or not the destination contract reports itself as being able
1087         to handle ERC-721 tokens.
1088     */
1089     function _checkOnERC721Received(
1090       address _from,
1091       address _to,
1092       uint256 _id,
1093       bytes memory _data
1094     ) private returns (bool) {
1095         if (_to.isContract()) {
1096           try IERC721Receiver(_to).onERC721Received(_msgSender(), _from, _id, _data)
1097           returns (bytes4 retval) {
1098               return retval == IERC721Receiver(_to).onERC721Received.selector;
1099           } catch (bytes memory reason) {
1100               if (reason.length == 0) revert ("TransferToNonERC721ReceiverImplementer");
1101               else {
1102                 assembly {
1103                   revert(add(32, reason), mload(reason))
1104                 }
1105               }
1106           }
1107         } else {
1108           return true;
1109         }
1110     }
1111 
1112     /**
1113       This function performs transfer of token ID `_id` from address `_from` to
1114       address `_to`. This function validates that the receiving address reports
1115       itself as being able to properly handle an ERC-721 token.
1116 
1117       @param _from The address to transfer the token from.
1118       @param _to The address to transfer the token to.
1119       @param _id The ID of the token being transferred.
1120     */
1121     function safeTransferFrom(
1122       address _from,
1123       address _to,
1124       uint256 _id
1125     ) public virtual override {
1126         safeTransferFrom(_from, _to, _id, '');
1127     }
1128 
1129     /**
1130       This function performs transfer of token ID `_id` from address `_from` to
1131       address `_to`. This function validates that the receiving address reports
1132       itself as being able to properly handle an ERC-721 token. This variant also
1133       sends `_data` along with the transfer check.
1134 
1135       @param _from The address to transfer the token from.
1136       @param _to The address to transfer the token to.
1137       @param _id The ID of the token being transferred.
1138       @param _data Optional data to send along with the transfer check.
1139     */
1140     function safeTransferFrom(
1141       address _from,
1142       address _to,
1143       uint256 _id,
1144       bytes memory _data
1145     ) public override {
1146         _transfer(_from, _to, _id);
1147         if (!_checkOnERC721Received(_from, _to, _id, _data)) {
1148             revert ("TransferToNonERC721ReceiverImplementer");
1149         }
1150     }
1151 
1152     /**
1153       This function allows permissioned minters of this contract to mint one or
1154       more tokens dictated by the `_amount` parameter. Any minted tokens are sent
1155       to the `_recipient` address.
1156 
1157       Note that tokens are always minted sequentially starting at one. That is,
1158       the list of token IDs is always increasing and looks like [ 1, 2, 3... ].
1159       Also note that per our use cases the intended recipient of these minted
1160       items will always be externally-owned accounts and not other contracts. As a
1161       result there is no safety check on whether or not the mint destination can
1162       actually correctly handle an ERC-721 token.
1163 
1164       @param _recipient The recipient of the tokens being minted.
1165       @param _amount The amount of tokens to mint.
1166     */
1167     function cheapMint (
1168       address _recipient,
1169       uint256 _amount
1170     ) internal {
1171         if (_recipient == address(0)) { revert ("MintToZeroAddress"); }
1172         if (_amount == 0) { revert ("MintZeroQuantity"); }
1173         if (nextId - 1 + _amount > MAX_CAP) { revert ("CapExceeded"); }
1174 
1175           uint256 startTokenId = nextId;
1176           unchecked {
1177               balances[_recipient] += _amount;
1178               owners[startTokenId] = _recipient;
1179 
1180               uint256 updatedIndex = startTokenId;
1181               for (uint256 i; i < _amount; i++) {
1182                 emit Transfer(address(0), _recipient, updatedIndex);
1183                 updatedIndex++;
1184               }
1185               nextId = updatedIndex;
1186           }
1187     }
1188 
1189     /**
1190       This function allows the original owner of the contract to add or remove
1191       other addresses as administrators. Administrators may perform mints and may
1192       lock token transfers.
1193 
1194       @param _newAdmin The new admin to update permissions for.
1195       @param _isAdmin Whether or not the new admin should be an admin.
1196     */
1197     function setAdmin (
1198       address _newAdmin,
1199       bool _isAdmin
1200     ) external onlyOwner {
1201         administrators[_newAdmin] = _isAdmin;
1202     }
1203 
1204     /**
1205       Allow the item collection owner to update the metadata URI of this
1206       collection.
1207 
1208       @param _uri The new URI to update to.
1209     */
1210     function setURI (
1211       string calldata _uri
1212     ) external virtual onlyOwner {
1213         metadataUri = _uri;
1214     }
1215 
1216 
1217     /**
1218       This function allows an administrative caller to lock the transfer of
1219       particular token IDs. This is designed for a non-escrow staking contract
1220       that comes later to lock a user's NFT while still letting them keep it in
1221       their wallet.
1222 
1223       @param _id The ID of the token to lock.
1224       @param _locked The status of the lock; true to lock, false to unlock.
1225     */
1226     function lockKinght (
1227     uint256 _id,
1228     bool _locked
1229     ) external onlyAdmin {
1230       transferLocks[_id] = _locked;
1231     }
1232 
1233 
1234     function pauseMint(bool _val) external onlyOwner {
1235         PublicMintingPaused = _val;
1236     }
1237 
1238     function pauseALSale(bool _val) external onlyOwner {
1239         ALMintingPaused = _val;
1240     }
1241 
1242 
1243     /**
1244       Sets maximum mint per wallet / transaction
1245 
1246       @param _val True or false
1247     */
1248     function setMaxMintCapPerWallet(uint8 _val) external onlyOwner {
1249         MAX_MINT_PER_TX = _val;
1250     }
1251 
1252     /**
1253       Sets whitelists addresss with respective allowed mint count number
1254 
1255       @param _allowlisted Addresses to be whitelisted
1256       @param _allowedMintCnt Number of possible allowlist mints
1257     */
1258     function addToAllowListArray(address[] memory _allowlisted, uint256[] memory _allowedMintCnt) public onlyOwner {
1259       require(_allowlisted.length == _allowedMintCnt.length, "MRSC 400 - 2 arrays shall have the same length");
1260       for (uint256 i=0; i<_allowlisted.length; i++)
1261       {
1262           ALAddressToCap[_allowlisted[i]] = _allowedMintCnt[i];
1263       }
1264     }
1265 
1266     /**
1267       Checks how many WL mints are available for the given address
1268 
1269       @param _whitelistedAddr WhitelistedAddress
1270     */
1271     function getWlQuotaByAddress(address _whitelistedAddr) public view returns (uint256) {
1272         return ALAddressToCap[_whitelistedAddr];
1273     }
1274 
1275     /**
1276       Sets new price
1277 
1278       @param _newPrice New price
1279     */
1280     function setPrice(uint256 _newPrice) public onlyOwner() {
1281         _price = _newPrice;
1282     }
1283 
1284     function getPrice() public view returns (uint256){
1285         return _price;
1286     }
1287 
1288     function withdraw(address payable recipient) public onlyOwner {
1289       uint256 balance = address(this).balance;
1290       recipient.transfer(balance);
1291   }
1292 }