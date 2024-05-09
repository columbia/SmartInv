1 // File: FantasticBeasts.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-05-27
5 */
6 
7 // File: Ningen.sol
8 
9 //SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 abstract contract ReentrancyGuard {
14   
15     uint256 private constant _NOT_ENTERED = 1;
16     uint256 private constant _ENTERED = 2;
17 
18     uint256 private _status;
19 
20     constructor() {
21         _status = _NOT_ENTERED;
22     }
23 
24     /**
25      * @dev Prevents a contract from calling itself, directly or indirectly.
26      * Calling a `nonReentrant` function from another `nonReentrant`
27      * function is not supported. It is possible to prevent this from happening
28      * by making the `nonReentrant` function external, and making it call a
29      * `private` function that does the actual work.
30      */
31     modifier nonReentrant() {
32         // On the first call to nonReentrant, _notEntered will be true
33         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
34 
35         // Any calls to nonReentrant after this point will fail
36         _status = _ENTERED;
37 
38         _;
39 
40         // By storing the original value once again, a refund is triggered (see
41         // https://eips.ethereum.org/EIPS/eip-2200)
42         _status = _NOT_ENTERED;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/Strings.sol
47 
48 
49 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev String operations.
55  */
56 library Strings {
57     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
61      */
62     function toString(uint256 value) internal pure returns (string memory) {
63         // Inspired by OraclizeAPI's implementation - MIT licence
64         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
65 
66         if (value == 0) {
67             return "0";
68         }
69         uint256 temp = value;
70         uint256 digits;
71         while (temp != 0) {
72             digits++;
73             temp /= 10;
74         }
75         bytes memory buffer = new bytes(digits);
76         while (value != 0) {
77             digits -= 1;
78             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
79             value /= 10;
80         }
81         return string(buffer);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
86      */
87     function toHexString(uint256 value) internal pure returns (string memory) {
88         if (value == 0) {
89             return "0x00";
90         }
91         uint256 temp = value;
92         uint256 length = 0;
93         while (temp != 0) {
94             length++;
95             temp >>= 8;
96         }
97         return toHexString(value, length);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
102      */
103     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
104         bytes memory buffer = new bytes(2 * length + 2);
105         buffer[0] = "0";
106         buffer[1] = "x";
107         for (uint256 i = 2 * length + 1; i > 1; --i) {
108             buffer[i] = _HEX_SYMBOLS[value & 0xf];
109             value >>= 4;
110         }
111         require(value == 0, "Strings: hex length insufficient");
112         return string(buffer);
113     }
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/access/Ownable.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 /**
152  * @dev Contract module which provides a basic access control mechanism, where
153  * there is an account (an owner) that can be granted exclusive access to
154  * specific functions.
155  *
156  * By default, the owner account will be the one that deploys the contract. This
157  * can later be changed with {transferOwnership}.
158  *
159  * This module is used through inheritance. It will make available the modifier
160  * `onlyOwner`, which can be applied to your functions to restrict their use to
161  * the owner.
162  */
163 abstract contract Ownable is Context {
164     address private _owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168     /**
169      * @dev Initializes the contract setting the deployer as the initial owner.
170      */
171     constructor() {
172         _transferOwnership(_msgSender());
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view virtual returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if called by any account other than the owner.
184      */
185     modifier onlyOwner() {
186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
187         _;
188     }
189 
190     /**
191      * @dev Leaves the contract without owner. It will not be possible to call
192      * `onlyOwner` functions anymore. Can only be called by the current owner.
193      *
194      * NOTE: Renouncing ownership will leave the contract without an owner,
195      * thereby removing any functionality that is only available to the owner.
196      */
197     function renounceOwnership() public virtual onlyOwner {
198         _transferOwnership(address(0));
199     }
200 
201     /**
202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
203      * Can only be called by the current owner.
204      */
205     function transferOwnership(address newOwner) public virtual onlyOwner {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         _transferOwnership(newOwner);
208     }
209 
210     /**
211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
212      * Internal function without access restriction.
213      */
214     function _transferOwnership(address newOwner) internal virtual {
215         address oldOwner = _owner;
216         _owner = newOwner;
217         emit OwnershipTransferred(oldOwner, newOwner);
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Address.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
225 
226 pragma solidity ^0.8.1;
227 
228 /**
229  * @dev Collection of functions related to the address type
230  */
231 library Address {
232     /**
233      * @dev Returns true if `account` is a contract.
234      *
235      * [IMPORTANT]
236      * ====
237      * It is unsafe to assume that an address for which this function returns
238      * false is an externally-owned account (EOA) and not a contract.
239      *
240      * Among others, `isContract` will return false for the following
241      * types of addresses:
242      *
243      *  - an externally-owned account
244      *  - a contract in construction
245      *  - an address where a contract will be created
246      *  - an address where a contract lived, but was destroyed
247      * ====
248      *
249      * [IMPORTANT]
250      * ====
251      * You shouldn't rely on `isContract` to protect against flash loan attacks!
252      *
253      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
254      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
255      * constructor.
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies on extcodesize/address.code.length, which returns 0
260         // for contracts in construction, since the code is only stored at the end
261         // of the constructor execution.
262 
263         return account.code.length > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain `call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         require(isContract(target), "Address: call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.call{value: value}(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
370         return functionStaticCall(target, data, "Address: low-level static call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.staticcall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(isContract(target), "Address: delegate call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.delegatecall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
419      * revert reason using the provided one.
420      *
421      * _Available since v4.3._
422      */
423     function verifyCallResult(
424         bool success,
425         bytes memory returndata,
426         string memory errorMessage
427     ) internal pure returns (bytes memory) {
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434 
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
447 
448 
449 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @title ERC721 token receiver interface
455  * @dev Interface for any contract that wants to support safeTransfers
456  * from ERC721 asset contracts.
457  */
458 interface IERC721Receiver {
459     /**
460      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
461      * by `operator` from `from`, this function is called.
462      *
463      * It must return its Solidity selector to confirm the token transfer.
464      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
465      *
466      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
467      */
468     function onERC721Received(
469         address operator,
470         address from,
471         uint256 tokenId,
472         bytes calldata data
473     ) external returns (bytes4);
474 }
475 
476 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Interface of the ERC165 standard, as defined in the
485  * https://eips.ethereum.org/EIPS/eip-165[EIP].
486  *
487  * Implementers can declare support of contract interfaces, which can then be
488  * queried by others ({ERC165Checker}).
489  *
490  * For an implementation, see {ERC165}.
491  */
492 interface IERC165 {
493     /**
494      * @dev Returns true if this contract implements the interface defined by
495      * `interfaceId`. See the corresponding
496      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
497      * to learn more about how these ids are created.
498      *
499      * This function call must use less than 30 000 gas.
500      */
501     function supportsInterface(bytes4 interfaceId) external view returns (bool);
502 }
503 
504 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Implementation of the {IERC165} interface.
514  *
515  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
516  * for the additional interface id that will be supported. For example:
517  *
518  * ```solidity
519  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
521  * }
522  * ```
523  *
524  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
525  */
526 abstract contract ERC165 is IERC165 {
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IERC165).interfaceId;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev Required interface of an ERC721 compliant contract.
545  */
546 interface IERC721 is IERC165 {
547     /**
548      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
549      */
550     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
551 
552     /**
553      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
554      */
555     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
556 
557     /**
558      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
559      */
560     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
561 
562     /**
563      * @dev Returns the number of tokens in ``owner``'s account.
564      */
565     function balanceOf(address owner) external view returns (uint256 balance);
566 
567     /**
568      * @dev Returns the owner of the `tokenId` token.
569      *
570      * Requirements:
571      *
572      * - `tokenId` must exist.
573      */
574     function ownerOf(uint256 tokenId) external view returns (address owner);
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
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
598      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Transfers `tokenId` token from `from` to `to`.
618      *
619      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must be owned by `from`.
626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      *
628      * Emits a {Transfer} event.
629      */
630     function transferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
638      * The approval is cleared when the token is transferred.
639      *
640      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
641      *
642      * Requirements:
643      *
644      * - The caller must own the token or be an approved operator.
645      * - `tokenId` must exist.
646      *
647      * Emits an {Approval} event.
648      */
649     function approve(address to, uint256 tokenId) external;
650 
651     /**
652      * @dev Approve or remove `operator` as an operator for the caller.
653      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
654      *
655      * Requirements:
656      *
657      * - The `operator` cannot be the caller.
658      *
659      * Emits an {ApprovalForAll} event.
660      */
661     function setApprovalForAll(address operator, bool _approved) external;
662 
663     /**
664      * @dev Returns the account approved for `tokenId` token.
665      *
666      * Requirements:
667      *
668      * - `tokenId` must exist.
669      */
670     function getApproved(uint256 tokenId) external view returns (address operator);
671 
672     /**
673      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
674      *
675      * See {setApprovalForAll}
676      */
677     function isApprovedForAll(address owner, address operator) external view returns (bool);
678 }
679 
680 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 
688 /**
689  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
690  * @dev See https://eips.ethereum.org/EIPS/eip-721
691  */
692 interface IERC721Metadata is IERC721 {
693     /**
694      * @dev Returns the token collection name.
695      */
696     function name() external view returns (string memory);
697 
698     /**
699      * @dev Returns the token collection symbol.
700      */
701     function symbol() external view returns (string memory);
702 
703     /**
704      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
705      */
706     function tokenURI(uint256 tokenId) external view returns (string memory);
707 }
708 
709 // File: erc721a/contracts/IERC721A.sol
710 
711 // ERC721A Contracts v3.3.0
712 // Creator: Chiru Labs
713 
714 pragma solidity ^0.8.4;
715 
716 /**
717  * @dev Interface of an ERC721A compliant contract.
718  */
719 interface IERC721A is IERC721, IERC721Metadata {
720     /**
721      * The caller must own the token or be an approved operator.
722      */
723     error ApprovalCallerNotOwnerNorApproved();
724 
725     /**
726      * The token does not exist.
727      */
728     error ApprovalQueryForNonexistentToken();
729 
730     /**
731      * The caller cannot approve to their own address.
732      */
733     error ApproveToCaller();
734 
735     /**
736      * The caller cannot approve to the current owner.
737      */
738     error ApprovalToCurrentOwner();
739 
740     /**
741      * Cannot query the balance for the zero address.
742      */
743     error BalanceQueryForZeroAddress();
744 
745     /**
746      * Cannot mint to the zero address.
747      */
748     error MintToZeroAddress();
749 
750     /**
751      * The quantity of tokens minted must be more than zero.
752      */
753     error MintZeroQuantity();
754 
755     /**
756      * The token does not exist.
757      */
758     error OwnerQueryForNonexistentToken();
759 
760     /**
761      * The caller must own the token or be an approved operator.
762      */
763     error TransferCallerNotOwnerNorApproved();
764 
765     /**
766      * The token must be owned by `from`.
767      */
768     error TransferFromIncorrectOwner();
769 
770     /**
771      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
772      */
773     error TransferToNonERC721ReceiverImplementer();
774 
775     /**
776      * Cannot transfer to the zero address.
777      */
778     error TransferToZeroAddress();
779 
780     /**
781      * The token does not exist.
782      */
783     error URIQueryForNonexistentToken();
784 
785     // Compiler will pack this into a single 256bit word.
786     struct TokenOwnership {
787         // The address of the owner.
788         address addr;
789         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
790         uint64 startTimestamp;
791         // Whether the token has been burned.
792         bool burned;
793     }
794 
795     // Compiler will pack this into a single 256bit word.
796     struct AddressData {
797         // Realistically, 2**64-1 is more than enough.
798         uint64 balance;
799         // Keeps track of mint count with minimal overhead for tokenomics.
800         uint64 numberMinted;
801         // Keeps track of burn count with minimal overhead for tokenomics.
802         uint64 numberBurned;
803         // For miscellaneous variable(s) pertaining to the address
804         // (e.g. number of whitelist mint slots used).
805         // If there are multiple variables, please pack them into a uint64.
806         uint64 aux;
807     }
808 
809     /**
810      * @dev Returns the total amount of tokens stored by the contract.
811      * 
812      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
813      */
814     function totalSupply() external view returns (uint256);
815 }
816 
817 // File: erc721a/contracts/ERC721A.sol
818 
819 
820 // ERC721A Contracts v3.3.0
821 // Creator: Chiru Labs
822 
823 pragma solidity ^0.8.4;
824 
825 /**
826  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
827  * the Metadata extension. Built to optimize for lower gas during batch mints.
828  *
829  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
830  *
831  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
832  *
833  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
834  */
835 contract ERC721A is Context, ERC165, IERC721A {
836     using Address for address;
837     using Strings for uint256;
838 
839     // The tokenId of the next token to be minted.
840     uint256 internal _currentIndex;
841 
842     // The number of tokens burned.
843     uint256 internal _burnCounter;
844 
845     // Token name
846     string private _name;
847 
848     // Token symbol
849     string private _symbol;
850 
851     // Mapping from token ID to ownership details
852     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
853     mapping(uint256 => TokenOwnership) internal _ownerships;
854 
855     // Mapping owner address to address data
856     mapping(address => AddressData) private _addressData;
857 
858     // Mapping from token ID to approved address
859     mapping(uint256 => address) private _tokenApprovals;
860 
861     // Mapping from owner to operator approvals
862     mapping(address => mapping(address => bool)) private _operatorApprovals;
863 
864     constructor(string memory name_, string memory symbol_) {
865         _name = name_;
866         _symbol = symbol_;
867         _currentIndex = _startTokenId();
868     }
869 
870     /**
871      * To change the starting tokenId, please override this function.
872      */
873     function _startTokenId() internal view virtual returns (uint256) {
874         return 0;
875     }
876 
877     /**
878      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
879      */
880     function totalSupply() public view override returns (uint256) {
881         // Counter underflow is impossible as _burnCounter cannot be incremented
882         // more than _currentIndex - _startTokenId() times
883         unchecked {
884             return _currentIndex - _burnCounter - _startTokenId();
885         }
886     }
887 
888     /**
889      * Returns the total amount of tokens minted in the contract.
890      */
891     function _totalMinted() internal view returns (uint256) {
892         // Counter underflow is impossible as _currentIndex does not decrement,
893         // and it is initialized to _startTokenId()
894         unchecked {
895             return _currentIndex - _startTokenId();
896         }
897     }
898 
899     /**
900      * @dev See {IERC165-supportsInterface}.
901      */
902     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
903         return
904             interfaceId == type(IERC721).interfaceId ||
905             interfaceId == type(IERC721Metadata).interfaceId ||
906             super.supportsInterface(interfaceId);
907     }
908 
909     /**
910      * @dev See {IERC721-balanceOf}.
911      */
912     function balanceOf(address owner) public view override returns (uint256) {
913         if (owner == address(0)) revert BalanceQueryForZeroAddress();
914         return uint256(_addressData[owner].balance);
915     }
916 
917     /**
918      * Returns the number of tokens minted by `owner`.
919      */
920     function _numberMinted(address owner) internal view returns (uint256) {
921         return uint256(_addressData[owner].numberMinted);
922     }
923 
924     /**
925      * Returns the number of tokens burned by or on behalf of `owner`.
926      */
927     function _numberBurned(address owner) internal view returns (uint256) {
928         return uint256(_addressData[owner].numberBurned);
929     }
930 
931     /**
932      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
933      */
934     function _getAux(address owner) internal view returns (uint64) {
935         return _addressData[owner].aux;
936     }
937 
938     /**
939      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
940      * If there are multiple variables, please pack them into a uint64.
941      */
942     function _setAux(address owner, uint64 aux) internal {
943         _addressData[owner].aux = aux;
944     }
945 
946     /**
947      * Gas spent here starts off proportional to the maximum mint batch size.
948      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
949      */
950     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
951         uint256 curr = tokenId;
952 
953         unchecked {
954             if (_startTokenId() <= curr) if (curr < _currentIndex) {
955                 TokenOwnership memory ownership = _ownerships[curr];
956                 if (!ownership.burned) {
957                     if (ownership.addr != address(0)) {
958                         return ownership;
959                     }
960                     // Invariant:
961                     // There will always be an ownership that has an address and is not burned
962                     // before an ownership that does not have an address and is not burned.
963                     // Hence, curr will not underflow.
964                     while (true) {
965                         curr--;
966                         ownership = _ownerships[curr];
967                         if (ownership.addr != address(0)) {
968                             return ownership;
969                         }
970                     }
971                 }
972             }
973         }
974         revert OwnerQueryForNonexistentToken();
975     }
976 
977     /**
978      * @dev See {IERC721-ownerOf}.
979      */
980     function ownerOf(uint256 tokenId) public view override returns (address) {
981         return _ownershipOf(tokenId).addr;
982     }
983 
984     /**
985      * @dev See {IERC721Metadata-name}.
986      */
987     function name() public view virtual override returns (string memory) {
988         return _name;
989     }
990 
991     /**
992      * @dev See {IERC721Metadata-symbol}.
993      */
994     function symbol() public view virtual override returns (string memory) {
995         return _symbol;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-tokenURI}.
1000      */
1001     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1002         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1003 
1004         string memory baseURI = _baseURI();
1005         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1006     }
1007 
1008     /**
1009      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1010      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1011      * by default, can be overriden in child contracts.
1012      */
1013     function _baseURI() internal view virtual returns (string memory) {
1014         return '';
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-approve}.
1019      */
1020     function approve(address to, uint256 tokenId) public override {
1021         address owner = ERC721A.ownerOf(tokenId);
1022         if (to == owner) revert ApprovalToCurrentOwner();
1023 
1024         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1025             revert ApprovalCallerNotOwnerNorApproved();
1026         }
1027 
1028         _approve(to, tokenId, owner);
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-getApproved}.
1033      */
1034     function getApproved(uint256 tokenId) public view override returns (address) {
1035         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1036 
1037         return _tokenApprovals[tokenId];
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-setApprovalForAll}.
1042      */
1043     function setApprovalForAll(address operator, bool approved) public virtual override {
1044         if (operator == _msgSender()) revert ApproveToCaller();
1045 
1046         _operatorApprovals[_msgSender()][operator] = approved;
1047         emit ApprovalForAll(_msgSender(), operator, approved);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-isApprovedForAll}.
1052      */
1053     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1054         return _operatorApprovals[owner][operator];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-transferFrom}.
1059      */
1060     function transferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) public virtual override {
1065         _transfer(from, to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-safeTransferFrom}.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) public virtual override {
1076         safeTransferFrom(from, to, tokenId, '');
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-safeTransferFrom}.
1081      */
1082     function safeTransferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) public virtual override {
1088         _transfer(from, to, tokenId);
1089         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1090             revert TransferToNonERC721ReceiverImplementer();
1091         }
1092     }
1093 
1094     /**
1095      * @dev Returns whether `tokenId` exists.
1096      *
1097      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1098      *
1099      * Tokens start existing when they are minted (`_mint`),
1100      */
1101     function _exists(uint256 tokenId) internal view returns (bool) {
1102         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1103     }
1104 
1105     /**
1106      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1107      */
1108     function _safeMint(address to, uint256 quantity) internal {
1109         _safeMint(to, quantity, '');
1110     }
1111 
1112     /**
1113      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - If `to` refers to a smart contract, it must implement
1118      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1119      * - `quantity` must be greater than 0.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _safeMint(
1124         address to,
1125         uint256 quantity,
1126         bytes memory _data
1127     ) internal {
1128         uint256 startTokenId = _currentIndex;
1129         if (to == address(0)) revert MintToZeroAddress();
1130         if (quantity == 0) revert MintZeroQuantity();
1131 
1132         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1133 
1134         // Overflows are incredibly unrealistic.
1135         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1136         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1137         unchecked {
1138             _addressData[to].balance += uint64(quantity);
1139             _addressData[to].numberMinted += uint64(quantity);
1140 
1141             _ownerships[startTokenId].addr = to;
1142             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1143 
1144             uint256 updatedIndex = startTokenId;
1145             uint256 end = updatedIndex + quantity;
1146 
1147             if (to.isContract()) {
1148                 do {
1149                     emit Transfer(address(0), to, updatedIndex);
1150                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1151                         revert TransferToNonERC721ReceiverImplementer();
1152                     }
1153                 } while (updatedIndex < end);
1154                 // Reentrancy protection
1155                 if (_currentIndex != startTokenId) revert();
1156             } else {
1157                 do {
1158                     emit Transfer(address(0), to, updatedIndex++);
1159                 } while (updatedIndex < end);
1160             }
1161             _currentIndex = updatedIndex;
1162         }
1163         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1164     }
1165 
1166     /**
1167      * @dev Mints `quantity` tokens and transfers them to `to`.
1168      *
1169      * Requirements:
1170      *
1171      * - `to` cannot be the zero address.
1172      * - `quantity` must be greater than 0.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function _mint(address to, uint256 quantity) internal {
1177         uint256 startTokenId = _currentIndex;
1178         if (to == address(0)) revert MintToZeroAddress();
1179         if (quantity == 0) revert MintZeroQuantity();
1180 
1181         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1182 
1183         // Overflows are incredibly unrealistic.
1184         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1185         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1186         unchecked {
1187             _addressData[to].balance += uint64(quantity);
1188             _addressData[to].numberMinted += uint64(quantity);
1189 
1190             _ownerships[startTokenId].addr = to;
1191             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1192 
1193             uint256 updatedIndex = startTokenId;
1194             uint256 end = updatedIndex + quantity;
1195 
1196             do {
1197                 emit Transfer(address(0), to, updatedIndex++);
1198             } while (updatedIndex < end);
1199 
1200             _currentIndex = updatedIndex;
1201         }
1202         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1203     }
1204 
1205     /**
1206      * @dev Transfers `tokenId` from `from` to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `tokenId` token must be owned by `from`.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _transfer(
1216         address from,
1217         address to,
1218         uint256 tokenId
1219     ) private {
1220         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1221 
1222         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1223 
1224         bool isApprovedOrOwner = (_msgSender() == from ||
1225             isApprovedForAll(from, _msgSender()) ||
1226             getApproved(tokenId) == _msgSender());
1227 
1228         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1229         if (to == address(0)) revert TransferToZeroAddress();
1230 
1231         _beforeTokenTransfers(from, to, tokenId, 1);
1232 
1233         // Clear approvals from the previous owner
1234         _approve(address(0), tokenId, from);
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1239         unchecked {
1240             _addressData[from].balance -= 1;
1241             _addressData[to].balance += 1;
1242 
1243             TokenOwnership storage currSlot = _ownerships[tokenId];
1244             currSlot.addr = to;
1245             currSlot.startTimestamp = uint64(block.timestamp);
1246 
1247             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1248             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1249             uint256 nextTokenId = tokenId + 1;
1250             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1251             if (nextSlot.addr == address(0)) {
1252                 // This will suffice for checking _exists(nextTokenId),
1253                 // as a burned slot cannot contain the zero address.
1254                 if (nextTokenId != _currentIndex) {
1255                     nextSlot.addr = from;
1256                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(from, to, tokenId);
1262         _afterTokenTransfers(from, to, tokenId, 1);
1263     }
1264 
1265     /**
1266      * @dev Equivalent to `_burn(tokenId, false)`.
1267      */
1268     function _burn(uint256 tokenId) internal virtual {
1269         _burn(tokenId, false);
1270     }
1271 
1272     /**
1273      * @dev Destroys `tokenId`.
1274      * The approval is cleared when the token is burned.
1275      *
1276      * Requirements:
1277      *
1278      * - `tokenId` must exist.
1279      *
1280      * Emits a {Transfer} event.
1281      */
1282     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1283         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1284 
1285         address from = prevOwnership.addr;
1286 
1287         if (approvalCheck) {
1288             bool isApprovedOrOwner = (_msgSender() == from ||
1289                 isApprovedForAll(from, _msgSender()) ||
1290                 getApproved(tokenId) == _msgSender());
1291 
1292             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1293         }
1294 
1295         _beforeTokenTransfers(from, address(0), tokenId, 1);
1296 
1297         // Clear approvals from the previous owner
1298         _approve(address(0), tokenId, from);
1299 
1300         // Underflow of the sender's balance is impossible because we check for
1301         // ownership above and the recipient's balance can't realistically overflow.
1302         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1303         unchecked {
1304             AddressData storage addressData = _addressData[from];
1305             addressData.balance -= 1;
1306             addressData.numberBurned += 1;
1307 
1308             // Keep track of who burned the token, and the timestamp of burning.
1309             TokenOwnership storage currSlot = _ownerships[tokenId];
1310             currSlot.addr = from;
1311             currSlot.startTimestamp = uint64(block.timestamp);
1312             currSlot.burned = true;
1313 
1314             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1315             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1316             uint256 nextTokenId = tokenId + 1;
1317             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1318             if (nextSlot.addr == address(0)) {
1319                 // This will suffice for checking _exists(nextTokenId),
1320                 // as a burned slot cannot contain the zero address.
1321                 if (nextTokenId != _currentIndex) {
1322                     nextSlot.addr = from;
1323                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1324                 }
1325             }
1326         }
1327 
1328         emit Transfer(from, address(0), tokenId);
1329         _afterTokenTransfers(from, address(0), tokenId, 1);
1330 
1331         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1332         unchecked {
1333             _burnCounter++;
1334         }
1335     }
1336 
1337     /**
1338      * @dev Approve `to` to operate on `tokenId`
1339      *
1340      * Emits a {Approval} event.
1341      */
1342     function _approve(
1343         address to,
1344         uint256 tokenId,
1345         address owner
1346     ) private {
1347         _tokenApprovals[tokenId] = to;
1348         emit Approval(owner, to, tokenId);
1349     }
1350 
1351     /**
1352      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1353      *
1354      * @param from address representing the previous owner of the given token ID
1355      * @param to target address that will receive the tokens
1356      * @param tokenId uint256 ID of the token to be transferred
1357      * @param _data bytes optional data to send along with the call
1358      * @return bool whether the call correctly returned the expected magic value
1359      */
1360     function _checkContractOnERC721Received(
1361         address from,
1362         address to,
1363         uint256 tokenId,
1364         bytes memory _data
1365     ) private returns (bool) {
1366         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1367             return retval == IERC721Receiver(to).onERC721Received.selector;
1368         } catch (bytes memory reason) {
1369             if (reason.length == 0) {
1370                 revert TransferToNonERC721ReceiverImplementer();
1371             } else {
1372                 assembly {
1373                     revert(add(32, reason), mload(reason))
1374                 }
1375             }
1376         }
1377     }
1378 
1379     /**
1380      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1381      * And also called before burning one token.
1382      *
1383      * startTokenId - the first token id to be transferred
1384      * quantity - the amount to be transferred
1385      *
1386      * Calling conditions:
1387      *
1388      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1389      * transferred to `to`.
1390      * - When `from` is zero, `tokenId` will be minted for `to`.
1391      * - When `to` is zero, `tokenId` will be burned by `from`.
1392      * - `from` and `to` are never both zero.
1393      */
1394     function _beforeTokenTransfers(
1395         address from,
1396         address to,
1397         uint256 startTokenId,
1398         uint256 quantity
1399     ) internal virtual {}
1400 
1401     /**
1402      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1403      * minting.
1404      * And also called after one token has been burned.
1405      *
1406      * startTokenId - the first token id to be transferred
1407      * quantity - the amount to be transferred
1408      *
1409      * Calling conditions:
1410      *
1411      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1412      * transferred to `to`.
1413      * - When `from` is zero, `tokenId` has been minted for `to`.
1414      * - When `to` is zero, `tokenId` has been burned by `from`.
1415      * - `from` and `to` are never both zero.
1416      */
1417     function _afterTokenTransfers(
1418         address from,
1419         address to,
1420         uint256 startTokenId,
1421         uint256 quantity
1422     ) internal virtual {}
1423 }
1424 
1425 // File: contracts/FantasticBeasts.sol
1426 
1427 pragma solidity ^0.8.9;
1428 
1429 contract FantasticBeasts is ERC721A, Ownable, ReentrancyGuard {
1430     using Strings for uint256;
1431 
1432     string baseURI;
1433     string public baseExtension = ".json";
1434     uint256 public price = 0.004 ether;
1435     uint256 public maxPerTx = 2;
1436     uint256 public totalFree = 400;
1437     uint256 public maxSupply = 600;
1438     uint256 public maxPerWallet = 20;
1439     bool public paused = true;
1440     
1441     constructor(
1442         string memory _initBaseURI
1443         ) ERC721A(
1444             "Fantastic Beasts", "FBEASTS"
1445         ) { 
1446         setBaseURI(_initBaseURI);
1447         _safeMint(msg.sender, 1);
1448     }
1449 
1450     function _baseURI() 
1451         internal 
1452         view 
1453         virtual 
1454         override 
1455         returns (string memory) {
1456         return baseURI;
1457     }
1458 
1459     function mint(uint256 _mintAmount) external payable {
1460         uint256 cost = price;
1461 
1462         if (totalSupply() + _mintAmount < totalFree + 1) {
1463             cost = 0;
1464         }
1465 
1466         require(msg.value >= _mintAmount * cost, "Not enough ETH.");
1467         require(totalSupply() + _mintAmount < maxSupply + 1, "Exceeds supply.");
1468         require(!paused, "Minting is not live yet.");
1469         require(_mintAmount < maxPerTx + 1, "Max per TX reached.");
1470         require(_numberMinted(msg.sender) + _mintAmount <= maxPerWallet,"Too many per wallet!");
1471 
1472         _safeMint(msg.sender, _mintAmount);
1473     }
1474 
1475     function tokenURI(uint256 tokenId)
1476         public
1477         view
1478         virtual
1479         override
1480         returns (string memory)
1481     {
1482         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1483         string memory currentBaseURI = _baseURI();
1484         return bytes(currentBaseURI).length > 0
1485             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1486             : "";
1487     }
1488 
1489     function setFreeAmount(uint256 amount) external onlyOwner {
1490         totalFree = amount;
1491     }
1492 
1493     function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
1494         maxPerWallet = _maxPerWallet;
1495     }
1496     
1497     function setMaxPerTx(uint256 _maxPerTx) public onlyOwner {
1498         maxPerTx = _maxPerTx;
1499     }
1500 
1501     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1502         maxSupply = _maxSupply;
1503     }
1504 
1505     function setPrice(uint256 _newPrice) external onlyOwner {
1506         price = _newPrice;
1507     }
1508 
1509     function setPaused() public onlyOwner {
1510         paused = !paused;
1511     }
1512 
1513     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1514         baseURI = _newBaseURI;
1515     }
1516 
1517     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1518         baseExtension = _newBaseExtension;
1519     }
1520 
1521     function _startTokenId() internal view virtual override returns (uint256) {
1522         return 1;
1523     }
1524 
1525     function withdraw() external onlyOwner {
1526         uint256 balance = address(this).balance;
1527         (bool success, ) = _msgSender().call{value: balance}("");
1528         require(success, "Failed to send");
1529     }      
1530 }