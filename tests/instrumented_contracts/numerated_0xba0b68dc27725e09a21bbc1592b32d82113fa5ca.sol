1 /*
2  _______                                  ______          ______                                                           _______
3 |       \                                /      \        /      \                                                         |       \
4 | $$$$$$$\  ______    ______    ______  |  $$$$$$\      |  $$$$$$\  _______   _______   ______    _______   _______       | $$$$$$$\ ______    _______   _______
5 | $$__/ $$ /      \  /      \  /      \ | $$_  \$$      | $$__| $$ /       \ /       \ /      \  /       \ /       \      | $$__/ $$|      \  /       \ /       \
6 | $$    $$|  $$$$$$\|  $$$$$$\|  $$$$$$\| $$ \          | $$    $$|  $$$$$$$|  $$$$$$$|  $$$$$$\|  $$$$$$$|  $$$$$$$      | $$    $$ \$$$$$$\|  $$$$$$$|  $$$$$$$
7 | $$$$$$$ | $$   \$$| $$  | $$| $$  | $$| $$$$          | $$$$$$$$| $$      | $$      | $$    $$ \$$    \  \$$    \       | $$$$$$$ /      $$ \$$    \  \$$    \
8 | $$      | $$      | $$__/ $$| $$__/ $$| $$            | $$  | $$| $$_____ | $$_____ | $$$$$$$$ _\$$$$$$\ _\$$$$$$\      | $$     |  $$$$$$$ _\$$$$$$\ _\$$$$$$\
9 | $$      | $$       \$$    $$ \$$    $$| $$            | $$  | $$ \$$     \ \$$     \ \$$     \|       $$|       $$      | $$      \$$    $$|       $$|       $$
10  \$$       \$$        \$$$$$$   \$$$$$$  \$$             \$$   \$$  \$$$$$$$  \$$$$$$$  \$$$$$$$ \$$$$$$$  \$$$$$$$        \$$       \$$$$$$$ \$$$$$$$  \$$$$$$$
11 
12 */
13 // File: @openzeppelin/contracts/utils/Strings.sol
14 // SPDX-License-Identifier: MIT
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
29      */
30     function toString(uint256 value) internal pure returns (string memory) {
31         // Inspired by OraclizeAPI's implementation - MIT licence
32         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
54      */
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
70      */
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Context.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/access/Ownable.sol
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 
119 /**
120  * @dev Contract module which provides a basic access control mechanism, where
121  * there is an account (an owner) that can be granted exclusive access to
122  * specific functions.
123  *
124  * By default, the owner account will be the one that deploys the contract. This
125  * can later be changed with {transferOwnership}.
126  *
127  * This module is used through inheritance. It will make available the modifier
128  * `onlyOwner`, which can be applied to your functions to restrict their use to
129  * the owner.
130  */
131 abstract contract Ownable is Context {
132     address private _owner;
133 
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136     /**
137      * @dev Initializes the contract setting the deployer as the initial owner.
138      */
139     constructor() {
140         _transferOwnership(_msgSender());
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if called by any account other than the owner.
152      */
153     modifier onlyOwner() {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     /**
159      * @dev Leaves the contract without owner. It will not be possible to call
160      * `onlyOwner` functions anymore. Can only be called by the current owner.
161      *
162      * NOTE: Renouncing ownership will leave the contract without an owner,
163      * thereby removing any functionality that is only available to the owner.
164      */
165     function renounceOwnership() public virtual onlyOwner {
166         _transferOwnership(address(0));
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         _transferOwnership(newOwner);
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Internal function without access restriction.
181      */
182     function _transferOwnership(address newOwner) internal virtual {
183         address oldOwner = _owner;
184         _owner = newOwner;
185         emit OwnershipTransferred(oldOwner, newOwner);
186     }
187 }
188 
189 // File: @openzeppelin/contracts/utils/Address.sol
190 
191 
192 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
193 
194 pragma solidity ^0.8.1;
195 
196 /**
197  * @dev Collection of functions related to the address type
198  */
199 library Address {
200     /**
201      * @dev Returns true if `account` is a contract.
202      *
203      * [IMPORTANT]
204      * ====
205      * It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      *
208      * Among others, `isContract` will return false for the following
209      * types of addresses:
210      *
211      *  - an externally-owned account
212      *  - a contract in construction
213      *  - an address where a contract will be created
214      *  - an address where a contract lived, but was destroyed
215      * ====
216      *
217      * [IMPORTANT]
218      * ====
219      * You shouldn't rely on `isContract` to protect against flash loan attacks!
220      *
221      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
222      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
223      * constructor.
224      * ====
225      */
226     function isContract(address account) internal view returns (bool) {
227         // This method relies on extcodesize/address.code.length, which returns 0
228         // for contracts in construction, since the code is only stored at the end
229         // of the constructor execution.
230 
231         return account.code.length > 0;
232     }
233 
234     /**
235      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
236      * `recipient`, forwarding all available gas and reverting on errors.
237      *
238      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
239      * of certain opcodes, possibly making contracts go over the 2300 gas limit
240      * imposed by `transfer`, making them unable to receive funds via
241      * `transfer`. {sendValue} removes this limitation.
242      *
243      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
244      *
245      * IMPORTANT: because control is transferred to `recipient`, care must be
246      * taken to not create reentrancy vulnerabilities. Consider using
247      * {ReentrancyGuard} or the
248      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
249      */
250     function sendValue(address payable recipient, uint256 amount) internal {
251         require(address(this).balance >= amount, "Address: insufficient balance");
252 
253         (bool success, ) = recipient.call{value: amount}("");
254         require(success, "Address: unable to send value, recipient may have reverted");
255     }
256 
257     /**
258      * @dev Performs a Solidity function call using a low level `call`. A
259      * plain `call` is an unsafe replacement for a function call: use this
260      * function instead.
261      *
262      * If `target` reverts with a revert reason, it is bubbled up by this
263      * function (like regular Solidity function calls).
264      *
265      * Returns the raw returned data. To convert to the expected return value,
266      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
267      *
268      * Requirements:
269      *
270      * - `target` must be a contract.
271      * - calling `target` with `data` must not revert.
272      *
273      * _Available since v3.1._
274      */
275     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
276         return functionCall(target, data, "Address: low-level call failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
281      * `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCall(
286         address target,
287         bytes memory data,
288         string memory errorMessage
289     ) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, 0, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but also transferring `value` wei to `target`.
296      *
297      * Requirements:
298      *
299      * - the calling contract must have an ETH balance of at least `value`.
300      * - the called Solidity function must be `payable`.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value
308     ) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
314      * with `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(
319         address target,
320         bytes memory data,
321         uint256 value,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         require(address(this).balance >= value, "Address: insufficient balance for call");
325         require(isContract(target), "Address: call to non-contract");
326 
327         (bool success, bytes memory returndata) = target.call{value: value}(data);
328         return verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
338         return functionStaticCall(target, data, "Address: low-level static call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal view returns (bytes memory) {
352         require(isContract(target), "Address: static call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.staticcall(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a delegate call.
361      *
362      * _Available since v3.4._
363      */
364     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
365         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a delegate call.
371      *
372      * _Available since v3.4._
373      */
374     function functionDelegateCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         require(isContract(target), "Address: delegate call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.delegatecall(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
387      * revert reason using the provided one.
388      *
389      * _Available since v4.3._
390      */
391     function verifyCallResult(
392         bool success,
393         bytes memory returndata,
394         string memory errorMessage
395     ) internal pure returns (bytes memory) {
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
415 
416 
417 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 /**
422  * @title ERC721 token receiver interface
423  * @dev Interface for any contract that wants to support safeTransfers
424  * from ERC721 asset contracts.
425  */
426 interface IERC721Receiver {
427     /**
428      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
429      * by `operator` from `from`, this function is called.
430      *
431      * It must return its Solidity selector to confirm the token transfer.
432      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
433      *
434      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
435      */
436     function onERC721Received(
437         address operator,
438         address from,
439         uint256 tokenId,
440         bytes calldata data
441     ) external returns (bytes4);
442 }
443 
444 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev Interface of the ERC165 standard, as defined in the
453  * https://eips.ethereum.org/EIPS/eip-165[EIP].
454  *
455  * Implementers can declare support of contract interfaces, which can then be
456  * queried by others ({ERC165Checker}).
457  *
458  * For an implementation, see {ERC165}.
459  */
460 interface IERC165 {
461     /**
462      * @dev Returns true if this contract implements the interface defined by
463      * `interfaceId`. See the corresponding
464      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
465      * to learn more about how these ids are created.
466      *
467      * This function call must use less than 30 000 gas.
468      */
469     function supportsInterface(bytes4 interfaceId) external view returns (bool);
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 
480 /**
481  * @dev Implementation of the {IERC165} interface.
482  *
483  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
484  * for the additional interface id that will be supported. For example:
485  *
486  * ```solidity
487  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
489  * }
490  * ```
491  *
492  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
493  */
494 abstract contract ERC165 is IERC165 {
495     /**
496      * @dev See {IERC165-supportsInterface}.
497      */
498     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499         return interfaceId == type(IERC165).interfaceId;
500     }
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
504 
505 
506 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Required interface of an ERC721 compliant contract.
513  */
514 interface IERC721 is IERC165 {
515     /**
516      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
517      */
518     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
519 
520     /**
521      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
522      */
523     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
524 
525     /**
526      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
527      */
528     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
529 
530     /**
531      * @dev Returns the number of tokens in ``owner``'s account.
532      */
533     function balanceOf(address owner) external view returns (uint256 balance);
534 
535     /**
536      * @dev Returns the owner of the `tokenId` token.
537      *
538      * Requirements:
539      *
540      * - `tokenId` must exist.
541      */
542     function ownerOf(uint256 tokenId) external view returns (address owner);
543 
544     /**
545      * @dev Safely transfers `tokenId` token from `from` to `to`.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
554      *
555      * Emits a {Transfer} event.
556      */
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId,
561         bytes calldata data
562     ) external;
563 
564     /**
565      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
566      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
567      *
568      * Requirements:
569      *
570      * - `from` cannot be the zero address.
571      * - `to` cannot be the zero address.
572      * - `tokenId` token must exist and be owned by `from`.
573      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
574      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
575      *
576      * Emits a {Transfer} event.
577      */
578     function safeTransferFrom(
579         address from,
580         address to,
581         uint256 tokenId
582     ) external;
583 
584     /**
585      * @dev Transfers `tokenId` token from `from` to `to`.
586      *
587      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
588      *
589      * Requirements:
590      *
591      * - `from` cannot be the zero address.
592      * - `to` cannot be the zero address.
593      * - `tokenId` token must be owned by `from`.
594      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
595      *
596      * Emits a {Transfer} event.
597      */
598     function transferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) external;
603 
604     /**
605      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
606      * The approval is cleared when the token is transferred.
607      *
608      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
609      *
610      * Requirements:
611      *
612      * - The caller must own the token or be an approved operator.
613      * - `tokenId` must exist.
614      *
615      * Emits an {Approval} event.
616      */
617     function approve(address to, uint256 tokenId) external;
618 
619     /**
620      * @dev Approve or remove `operator` as an operator for the caller.
621      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
622      *
623      * Requirements:
624      *
625      * - The `operator` cannot be the caller.
626      *
627      * Emits an {ApprovalForAll} event.
628      */
629     function setApprovalForAll(address operator, bool _approved) external;
630 
631     /**
632      * @dev Returns the account approved for `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function getApproved(uint256 tokenId) external view returns (address operator);
639 
640     /**
641      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
642      *
643      * See {setApprovalForAll}
644      */
645     function isApprovedForAll(address owner, address operator) external view returns (bool);
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Metadata is IERC721 {
661     /**
662      * @dev Returns the token collection name.
663      */
664     function name() external view returns (string memory);
665 
666     /**
667      * @dev Returns the token collection symbol.
668      */
669     function symbol() external view returns (string memory);
670 
671     /**
672      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
673      */
674     function tokenURI(uint256 tokenId) external view returns (string memory);
675 }
676 
677 // File: contracts/ERC721A.sol
678 
679 
680 // Creator: Chiru Labs
681 
682 pragma solidity ^0.8.4;
683 
684 
685 
686 
687 
688 
689 
690 
691     error ApprovalCallerNotOwnerNorApproved();
692     error ApprovalQueryForNonexistentToken();
693     error ApproveToCaller();
694     error ApprovalToCurrentOwner();
695     error BalanceQueryForZeroAddress();
696     error MintToZeroAddress();
697     error MintZeroQuantity();
698     error OwnerQueryForNonexistentToken();
699     error TransferCallerNotOwnerNorApproved();
700     error TransferFromIncorrectOwner();
701     error TransferToNonERC721ReceiverImplementer();
702     error TransferToZeroAddress();
703     error URIQueryForNonexistentToken();
704 
705 /**
706  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
707  * the Metadata extension. Built to optimize for lower gas during batch mints.
708  *
709  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
710  *
711  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
712  *
713  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
714  */
715 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
716     using Address for address;
717     using Strings for uint256;
718 
719     // Compiler will pack this into a single 256bit word.
720     struct TokenOwnership {
721         // The address of the owner.
722         address addr;
723         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
724         uint64 startTimestamp;
725         // Whether the token has been burned.
726         bool burned;
727     }
728 
729     // Compiler will pack this into a single 256bit word.
730     struct AddressData {
731         // Realistically, 2**64-1 is more than enough.
732         uint64 balance;
733         // Keeps track of mint count with minimal overhead for tokenomics.
734         uint64 numberMinted;
735         // Keeps track of burn count with minimal overhead for tokenomics.
736         uint64 numberBurned;
737         // For miscellaneous variable(s) pertaining to the address
738         // (e.g. number of whitelist mint slots used).
739         // If there are multiple variables, please pack them into a uint64.
740         uint64 aux;
741     }
742 
743     // The tokenId of the next token to be minted.
744     uint256 internal _currentIndex;
745 
746     // The number of tokens burned.
747     uint256 internal _burnCounter;
748 
749     // Token name
750     string private _name;
751 
752     // Token symbol
753     string private _symbol;
754 
755     // Mapping from token ID to ownership details
756     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
757     mapping(uint256 => TokenOwnership) internal _ownerships;
758 
759     // Mapping owner address to address data
760     mapping(address => AddressData) private _addressData;
761 
762     // Mapping from token ID to approved address
763     mapping(uint256 => address) private _tokenApprovals;
764 
765     // Mapping from owner to operator approvals
766     mapping(address => mapping(address => bool)) private _operatorApprovals;
767 
768     constructor(string memory name_, string memory symbol_) {
769         _name = name_;
770         _symbol = symbol_;
771         _currentIndex = _startTokenId();
772     }
773 
774     /**
775      * To change the starting tokenId, please override this function.
776      */
777     function _startTokenId() internal view virtual returns (uint256) {
778         return 1;
779     }
780 
781     /**
782      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
783      */
784     function totalSupply() public view returns (uint256) {
785         // Counter underflow is impossible as _burnCounter cannot be incremented
786         // more than _currentIndex - _startTokenId() times
787     unchecked {
788         return _currentIndex - _burnCounter - _startTokenId();
789     }
790     }
791 
792     /**
793      * Returns the total amount of tokens minted in the contract.
794      */
795     function _totalMinted() internal view returns (uint256) {
796         // Counter underflow is impossible as _currentIndex does not decrement,
797         // and it is initialized to _startTokenId()
798     unchecked {
799         return _currentIndex - _startTokenId();
800     }
801     }
802 
803     /**
804      * @dev See {IERC165-supportsInterface}.
805      */
806     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
807         return
808         interfaceId == type(IERC721).interfaceId ||
809         interfaceId == type(IERC721Metadata).interfaceId ||
810         super.supportsInterface(interfaceId);
811     }
812 
813     /**
814      * @dev See {IERC721-balanceOf}.
815      */
816     function balanceOf(address owner) public view override returns (uint256) {
817         if (owner == address(0)) revert BalanceQueryForZeroAddress();
818         return uint256(_addressData[owner].balance);
819     }
820 
821     /**
822      * Returns the number of tokens minted by `owner`.
823      */
824     function _numberMinted(address owner) internal view returns (uint256) {
825         return uint256(_addressData[owner].numberMinted);
826     }
827 
828     /**
829      * Returns the number of tokens burned by or on behalf of `owner`.
830      */
831     function _numberBurned(address owner) internal view returns (uint256) {
832         return uint256(_addressData[owner].numberBurned);
833     }
834 
835     /**
836      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
837      */
838     function _getAux(address owner) internal view returns (uint64) {
839         return _addressData[owner].aux;
840     }
841 
842     /**
843      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
844      * If there are multiple variables, please pack them into a uint64.
845      */
846     function _setAux(address owner, uint64 aux) internal {
847         _addressData[owner].aux = aux;
848     }
849 
850     /**
851      * Gas spent here starts off proportional to the maximum mint batch size.
852      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
853      */
854     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
855         uint256 curr = tokenId;
856 
857     unchecked {
858         if (_startTokenId() <= curr && curr < _currentIndex) {
859             TokenOwnership memory ownership = _ownerships[curr];
860             if (!ownership.burned) {
861                 if (ownership.addr != address(0)) {
862                     return ownership;
863                 }
864                 // Invariant:
865                 // There will always be an ownership that has an address and is not burned
866                 // before an ownership that does not have an address and is not burned.
867                 // Hence, curr will not underflow.
868                 while (true) {
869                     curr--;
870                     ownership = _ownerships[curr];
871                     if (ownership.addr != address(0)) {
872                         return ownership;
873                     }
874                 }
875             }
876         }
877     }
878         revert OwnerQueryForNonexistentToken();
879     }
880 
881     /**
882      * @dev See {IERC721-ownerOf}.
883      */
884     function ownerOf(uint256 tokenId) public view override returns (address) {
885         return _ownershipOf(tokenId).addr;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-name}.
890      */
891     function name() public view virtual override returns (string memory) {
892         return _name;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-symbol}.
897      */
898     function symbol() public view virtual override returns (string memory) {
899         return _symbol;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-tokenURI}.
904      */
905     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
906         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
907 
908         string memory baseURI = _baseURI();
909         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
910     }
911 
912     /**
913      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
914      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
915      * by default, can be overriden in child contracts.
916      */
917     function _baseURI() internal view virtual returns (string memory) {
918         return '';
919     }
920 
921     /**
922      * @dev See {IERC721-approve}.
923      */
924     function approve(address to, uint256 tokenId) public override {
925         address owner = ERC721A.ownerOf(tokenId);
926         if (to == owner) revert ApprovalToCurrentOwner();
927 
928         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
929             revert ApprovalCallerNotOwnerNorApproved();
930         }
931 
932         _approve(to, tokenId, owner);
933     }
934 
935     /**
936      * @dev See {IERC721-getApproved}.
937      */
938     function getApproved(uint256 tokenId) public view override returns (address) {
939         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
940 
941         return _tokenApprovals[tokenId];
942     }
943 
944     /**
945      * @dev See {IERC721-setApprovalForAll}.
946      */
947     function setApprovalForAll(address operator, bool approved) public virtual override {
948         if (operator == _msgSender()) revert ApproveToCaller();
949 
950         _operatorApprovals[_msgSender()][operator] = approved;
951         emit ApprovalForAll(_msgSender(), operator, approved);
952     }
953 
954     /**
955      * @dev See {IERC721-isApprovedForAll}.
956      */
957     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
958         return _operatorApprovals[owner][operator];
959     }
960 
961     /**
962      * @dev See {IERC721-transferFrom}.
963      */
964     function transferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public virtual override {
969         _transfer(from, to, tokenId);
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId
979     ) public virtual override {
980         safeTransferFrom(from, to, tokenId, '');
981     }
982 
983     /**
984      * @dev See {IERC721-safeTransferFrom}.
985      */
986     function safeTransferFrom(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) public virtual override {
992         _transfer(from, to, tokenId);
993         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
994             revert TransferToNonERC721ReceiverImplementer();
995         }
996     }
997 
998     /**
999      * @dev Returns whether `tokenId` exists.
1000      *
1001      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1002      *
1003      * Tokens start existing when they are minted (`_mint`),
1004      */
1005     function _exists(uint256 tokenId) internal view returns (bool) {
1006         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1007     }
1008 
1009     function _safeMint(address to, uint256 quantity) internal {
1010         _safeMint(to, quantity, '');
1011     }
1012 
1013     /**
1014      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1019      * - `quantity` must be greater than 0.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _safeMint(
1024         address to,
1025         uint256 quantity,
1026         bytes memory _data
1027     ) internal {
1028         _mint(to, quantity, _data, true);
1029     }
1030 
1031     /**
1032      * @dev Mints `quantity` tokens and transfers them to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `quantity` must be greater than 0.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _mint(
1042         address to,
1043         uint256 quantity,
1044         bytes memory _data,
1045         bool safe
1046     ) internal {
1047         uint256 startTokenId = _currentIndex;
1048         if (to == address(0)) revert MintToZeroAddress();
1049         if (quantity == 0) revert MintZeroQuantity();
1050 
1051         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1052 
1053         // Overflows are incredibly unrealistic.
1054         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1055         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1056     unchecked {
1057         _addressData[to].balance += uint64(quantity);
1058         _addressData[to].numberMinted += uint64(quantity);
1059 
1060         _ownerships[startTokenId].addr = to;
1061         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1062 
1063         uint256 updatedIndex = startTokenId;
1064         uint256 end = updatedIndex + quantity;
1065 
1066         if (safe && to.isContract()) {
1067             do {
1068                 emit Transfer(address(0), to, updatedIndex);
1069                 if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1070                     revert TransferToNonERC721ReceiverImplementer();
1071                 }
1072             } while (updatedIndex != end);
1073             // Reentrancy protection
1074             if (_currentIndex != startTokenId) revert();
1075         } else {
1076             do {
1077                 emit Transfer(address(0), to, updatedIndex++);
1078             } while (updatedIndex != end);
1079         }
1080         _currentIndex = updatedIndex;
1081     }
1082         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1083     }
1084 
1085     /**
1086      * @dev Transfers `tokenId` from `from` to `to`.
1087      *
1088      * Requirements:
1089      *
1090      * - `to` cannot be the zero address.
1091      * - `tokenId` token must be owned by `from`.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _transfer(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) private {
1100         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1101 
1102         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1103 
1104         bool isApprovedOrOwner = (_msgSender() == from ||
1105         isApprovedForAll(from, _msgSender()) ||
1106         getApproved(tokenId) == _msgSender());
1107 
1108         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1109         if (to == address(0)) revert TransferToZeroAddress();
1110 
1111         _beforeTokenTransfers(from, to, tokenId, 1);
1112 
1113         // Clear approvals from the previous owner
1114         _approve(address(0), tokenId, from);
1115 
1116         // Underflow of the sender's balance is impossible because we check for
1117         // ownership above and the recipient's balance can't realistically overflow.
1118         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1119     unchecked {
1120         _addressData[from].balance -= 1;
1121         _addressData[to].balance += 1;
1122 
1123         TokenOwnership storage currSlot = _ownerships[tokenId];
1124         currSlot.addr = to;
1125         currSlot.startTimestamp = uint64(block.timestamp);
1126 
1127         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1128         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1129         uint256 nextTokenId = tokenId + 1;
1130         TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1131         if (nextSlot.addr == address(0)) {
1132             // This will suffice for checking _exists(nextTokenId),
1133             // as a burned slot cannot contain the zero address.
1134             if (nextTokenId != _currentIndex) {
1135                 nextSlot.addr = from;
1136                 nextSlot.startTimestamp = prevOwnership.startTimestamp;
1137             }
1138         }
1139     }
1140 
1141         emit Transfer(from, to, tokenId);
1142         _afterTokenTransfers(from, to, tokenId, 1);
1143     }
1144 
1145     /**
1146      * @dev This is equivalent to _burn(tokenId, false)
1147      */
1148     function _burn(uint256 tokenId) internal virtual {
1149         _burn(tokenId, false);
1150     }
1151 
1152     /**
1153      * @dev Destroys `tokenId`.
1154      * The approval is cleared when the token is burned.
1155      *
1156      * Requirements:
1157      *
1158      * - `tokenId` must exist.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1163         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1164 
1165         address from = prevOwnership.addr;
1166 
1167         if (approvalCheck) {
1168             bool isApprovedOrOwner = (_msgSender() == from ||
1169             isApprovedForAll(from, _msgSender()) ||
1170             getApproved(tokenId) == _msgSender());
1171 
1172             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1173         }
1174 
1175         _beforeTokenTransfers(from, address(0), tokenId, 1);
1176 
1177         // Clear approvals from the previous owner
1178         _approve(address(0), tokenId, from);
1179 
1180         // Underflow of the sender's balance is impossible because we check for
1181         // ownership above and the recipient's balance can't realistically overflow.
1182         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1183     unchecked {
1184         AddressData storage addressData = _addressData[from];
1185         addressData.balance -= 1;
1186         addressData.numberBurned += 1;
1187 
1188         // Keep track of who burned the token, and the timestamp of burning.
1189         TokenOwnership storage currSlot = _ownerships[tokenId];
1190         currSlot.addr = from;
1191         currSlot.startTimestamp = uint64(block.timestamp);
1192         currSlot.burned = true;
1193 
1194         // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1195         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1196         uint256 nextTokenId = tokenId + 1;
1197         TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1198         if (nextSlot.addr == address(0)) {
1199             // This will suffice for checking _exists(nextTokenId),
1200             // as a burned slot cannot contain the zero address.
1201             if (nextTokenId != _currentIndex) {
1202                 nextSlot.addr = from;
1203                 nextSlot.startTimestamp = prevOwnership.startTimestamp;
1204             }
1205         }
1206     }
1207 
1208         emit Transfer(from, address(0), tokenId);
1209         _afterTokenTransfers(from, address(0), tokenId, 1);
1210 
1211         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1212     unchecked {
1213         _burnCounter++;
1214     }
1215     }
1216 
1217     /**
1218      * @dev Approve `to` to operate on `tokenId`
1219      *
1220      * Emits a {Approval} event.
1221      */
1222     function _approve(
1223         address to,
1224         uint256 tokenId,
1225         address owner
1226     ) private {
1227         _tokenApprovals[tokenId] = to;
1228         emit Approval(owner, to, tokenId);
1229     }
1230 
1231     /**
1232      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1233      *
1234      * @param from address representing the previous owner of the given token ID
1235      * @param to target address that will receive the tokens
1236      * @param tokenId uint256 ID of the token to be transferred
1237      * @param _data bytes optional data to send along with the call
1238      * @return bool whether the call correctly returned the expected magic value
1239      */
1240     function _checkContractOnERC721Received(
1241         address from,
1242         address to,
1243         uint256 tokenId,
1244         bytes memory _data
1245     ) private returns (bool) {
1246         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1247             return retval == IERC721Receiver(to).onERC721Received.selector;
1248         } catch (bytes memory reason) {
1249             if (reason.length == 0) {
1250                 revert TransferToNonERC721ReceiverImplementer();
1251             } else {
1252                 assembly {
1253                     revert(add(32, reason), mload(reason))
1254                 }
1255             }
1256         }
1257     }
1258 
1259     /**
1260      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1261      * And also called before burning one token.
1262      *
1263      * startTokenId - the first token id to be transferred
1264      * quantity - the amount to be transferred
1265      *
1266      * Calling conditions:
1267      *
1268      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1269      * transferred to `to`.
1270      * - When `from` is zero, `tokenId` will be minted for `to`.
1271      * - When `to` is zero, `tokenId` will be burned by `from`.
1272      * - `from` and `to` are never both zero.
1273      */
1274     function _beforeTokenTransfers(
1275         address from,
1276         address to,
1277         uint256 startTokenId,
1278         uint256 quantity
1279     ) internal virtual {}
1280 
1281     /**
1282      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1283      * minting.
1284      * And also called after one token has been burned.
1285      *
1286      * startTokenId - the first token id to be transferred
1287      * quantity - the amount to be transferred
1288      *
1289      * Calling conditions:
1290      *
1291      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1292      * transferred to `to`.
1293      * - When `from` is zero, `tokenId` has been minted for `to`.
1294      * - When `to` is zero, `tokenId` has been burned by `from`.
1295      * - `from` and `to` are never both zero.
1296      */
1297     function _afterTokenTransfers(
1298         address from,
1299         address to,
1300         uint256 startTokenId,
1301         uint256 quantity
1302     ) internal virtual {}
1303 }
1304 // File: contracts/ProofA.sol
1305 
1306 
1307 pragma solidity ^0.8.4;
1308 
1309 contract ProofAccessPass is Ownable, ERC721A {
1310     using Strings for uint256;
1311 
1312     uint256 public start; // Start time
1313     uint256 public price; // Price of each tokens
1314     uint256 public collectionSize; // Total collection size
1315     uint256 public maxBatchSize; // Total max mint per tx allowed
1316     uint256 public saleLimit; // Stop limit for current minting phase
1317     uint256 public maxPerWallet; // Max number of mints a wallet can hold and still mint
1318     uint256 public maxPerWalletWhitelist; // Max number of mints a wallet can hold and still mint while whitelisted
1319     string public baseTokenURI; // Placeholder during mint
1320     string public revealedTokenURI; // Revealed URI
1321     bool public isPaused; // Pauses contract
1322     mapping(address => bool) public whitelisted;
1323 
1324     /**
1325      * @notice Checks if the msg.sender is a contract or a proxy
1326      */
1327     modifier notContract() {
1328         require(!_isContract(msg.sender), 'contract not allowed');
1329         require(msg.sender == tx.origin, 'proxy contract not allowed');
1330         _;
1331     }
1332 
1333     modifier pausable() {
1334         require(!isPaused, 'public actions are paused');
1335         _;
1336     }
1337 
1338     /**
1339      * @notice Checks if address is a contract
1340      * @dev It prevents contract from being targeted
1341      */
1342     function _isContract(address addr) internal view returns (bool) {
1343         uint256 size;
1344         assembly {
1345             size := extcodesize(addr)
1346         }
1347         return size > 0;
1348     }
1349 
1350     /** @notice Public mint day after whitelist */
1351     function publicMint() external payable notContract pausable {
1352         // Check ethereum paid
1353         uint256 mintAmount = msg.value / price;
1354 
1355         // Check for whitelist to bypass start date
1356         if (start > block.timestamp) {
1357             if (whitelisted[msg.sender] != true) {
1358                 require(
1359                     start <= block.timestamp,
1360                     'Mint: Public sale not yet started, bud.'
1361                 );
1362             } else {
1363                 // Enforce max wallet rule for whitelist
1364                 uint256 balance = balanceOf(msg.sender);
1365                 if (balance + mintAmount > maxPerWalletWhitelist) {
1366                     uint256 over = (balance + mintAmount) - maxPerWalletWhitelist;
1367                     safeTransferETH(msg.sender, over * price);
1368                     mintAmount = maxPerWalletWhitelist - balance;
1369                 }
1370             }
1371         } else {
1372             uint256 balance = balanceOf(msg.sender);
1373             if (balance + mintAmount > maxPerWallet) {
1374                 uint256 over = (balance + mintAmount) - maxPerWallet;
1375                 safeTransferETH(msg.sender, over * price);
1376                 mintAmount = maxPerWallet - balance;
1377             }
1378         }
1379 
1380         if (totalSupply() + mintAmount > saleLimit && saleLimit < collectionSize) {
1381             uint256 over = (totalSupply() + mintAmount) - saleLimit;
1382             safeTransferETH(msg.sender, over * price);
1383 
1384             mintAmount = saleLimit - totalSupply(); // Last person gets the rest.
1385         }
1386 
1387         if (totalSupply() + mintAmount > collectionSize && saleLimit >= collectionSize) {
1388             uint256 over = (totalSupply() + mintAmount) - collectionSize;
1389             safeTransferETH(msg.sender, over * price);
1390 
1391             mintAmount = collectionSize - totalSupply(); // Last person gets the rest.
1392         }
1393 
1394         require(mintAmount <= maxBatchSize);
1395         require(mintAmount > 0, 'Mint: Can not mint 0 fren.');
1396 
1397         _safeMint(msg.sender, mintAmount);
1398     }
1399 
1400     function burn(uint256 tokenId) external {
1401         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1402 
1403         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1404         isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1405         getApproved(tokenId) == _msgSender());
1406 
1407         require(isApprovedOrOwner, "Not approved");
1408         _burn(tokenId);
1409     }
1410 
1411     /** @notice Gift mints after all minted */
1412     function mint(address to, uint256 amount) external onlyOwner {
1413         require(
1414             totalSupply() + amount <= collectionSize,
1415             'Mint: Bruh you are overminting.'
1416         );
1417         _safeMint(to, amount);
1418     }
1419 
1420     /** @notice Set Start Time */
1421     function setStart(uint256 time) external onlyOwner {
1422         start = time;
1423     }
1424 
1425     /** @notice Set Base URI */
1426     function setBaseTokenURI(string memory uri) external onlyOwner {
1427         baseTokenURI = uri;
1428     }
1429 
1430     /** @notice Whitelist User */
1431     function whitelistUser(address _user) public onlyOwner {
1432         whitelisted[_user] = true;
1433     }
1434 
1435     /** @notice Whitelist Users Bulk */
1436     function addBulkWhitelistUsers(address[] memory _users) public onlyOwner {
1437         for (uint256 i = 0; i < _users.length; i++) {
1438             whitelisted[_users[i]] = true;
1439         }
1440     }
1441 
1442     /** @notice Remove User from Whitelist */
1443     function removeWhitelistUser(address _user) public onlyOwner {
1444         whitelisted[_user] = false;
1445     }
1446 
1447     /** @notice Remove Bulk Users from Whitelist */
1448     function removeBulkWhitelistUser(address[] memory _users) public onlyOwner {
1449         for (uint256 i = 0; i < _users.length; i++) {
1450             whitelisted[_users[i]] = false;
1451         }
1452     }
1453 
1454     /** @notice Set Sale Limit */
1455     function setSaleLimit(uint256 _saleLimit) external onlyOwner {
1456         require(_saleLimit <= collectionSize);
1457         saleLimit = _saleLimit;
1458     }
1459 
1460     /** @notice Set Max Per Wallet*/
1461     function setMaxPerWallet(uint256 _walletLimit) external onlyOwner {
1462         maxPerWallet = _walletLimit;
1463     }
1464 
1465     /** @notice Set Max Per Wallet*/
1466     function setMaxPerWalletWhitelist(uint256 _walletLimit) external onlyOwner {
1467         maxPerWalletWhitelist = _walletLimit;
1468     }
1469 
1470     /** @notice Set Max Batch Size*/
1471     function setMaxBatchSize(uint256 _maxBatchSize) external onlyOwner {
1472         maxBatchSize = _maxBatchSize;
1473     }
1474 
1475     /** @notice Set Reveal URI */
1476     function setRevealedTokenUri(string memory uri) external onlyOwner {
1477         revealedTokenURI = uri;
1478     }
1479 
1480      /** @notice Set Base URI */
1481     function setBaseTokenUri(string memory uri) external onlyOwner {
1482         baseTokenURI = uri;
1483     }
1484 
1485     /** @notice Set Price */
1486     function setPrice(uint256 newPrice) external onlyOwner {
1487         price = newPrice;
1488     }
1489 
1490     /** @notice Set isPaused Ethereum */
1491     function setIsPaused(bool _isPaused) external onlyOwner {
1492         isPaused = _isPaused;
1493     }
1494 
1495     /** @notice Withdraw All Ethereum */
1496     function withdrawAll(address to) external onlyOwner {
1497         uint256 balance = address(this).balance;
1498 
1499         safeTransferETH(to, balance);
1500     }
1501 
1502     /** Utility Function */
1503     function safeTransferETH(address to, uint256 value) internal {
1504         (bool success, ) = to.call{value: value}(new bytes(0));
1505         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1506     }
1507 
1508     function getCollectionSize() external view returns (uint256) {
1509         return collectionSize;
1510     }
1511 
1512     /** @notice Image URI */
1513     function tokenURI(uint256 tokenId)
1514     public
1515     view
1516     override(ERC721A)
1517     returns (string memory)
1518     {
1519         require(_exists(tokenId), 'URI: Token does not exist');
1520 
1521         // Convert string to bytes so we can check if it's empty or not.
1522         return
1523         bytes(revealedTokenURI).length > 0
1524         ? string(abi.encodePacked(revealedTokenURI, tokenId.toString()))
1525         : baseTokenURI;
1526     }
1527 
1528     /** @notice initialize contract */
1529 
1530     constructor(
1531         string memory _name,
1532         string memory _symbol,
1533         uint256 _maxBatchSize,
1534         uint256 _collectionSize,
1535         string memory _baseTokenURI
1536     ) ERC721A(_name, _symbol) {
1537         baseTokenURI = _baseTokenURI;
1538         maxBatchSize = _maxBatchSize;
1539         collectionSize = _collectionSize;
1540         start = 1643127258;
1541         price = 0.03 ether;
1542         saleLimit = _collectionSize;
1543         maxPerWallet = 500;
1544         maxPerWalletWhitelist = 10; //only for whitelist presale
1545         isPaused = false;
1546     }
1547 }