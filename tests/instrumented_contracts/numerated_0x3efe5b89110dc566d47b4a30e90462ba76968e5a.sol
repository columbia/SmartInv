1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 // File: https://github.com/chiru-labs/ERC721A/contracts/IERC721A.sol
204 
205 
206 // ERC721A Contracts v3.3.0
207 // Creator: Chiru Labs
208 
209 pragma solidity ^0.8.4;
210 
211 
212 
213 /**
214  * @dev Interface of an ERC721A compliant contract.
215  */
216 interface IERC721A is IERC721, IERC721Metadata {
217     /**
218      * The caller must own the token or be an approved operator.
219      */
220     error ApprovalCallerNotOwnerNorApproved();
221 
222     /**
223      * The token does not exist.
224      */
225     error ApprovalQueryForNonexistentToken();
226 
227     /**
228      * The caller cannot approve to their own address.
229      */
230     error ApproveToCaller();
231 
232     /**
233      * The caller cannot approve to the current owner.
234      */
235     error ApprovalToCurrentOwner();
236 
237     /**
238      * Cannot query the balance for the zero address.
239      */
240     error BalanceQueryForZeroAddress();
241 
242     /**
243      * Cannot mint to the zero address.
244      */
245     error MintToZeroAddress();
246 
247     /**
248      * The quantity of tokens minted must be more than zero.
249      */
250     error MintZeroQuantity();
251 
252     /**
253      * The token does not exist.
254      */
255     error OwnerQueryForNonexistentToken();
256 
257     /**
258      * The caller must own the token or be an approved operator.
259      */
260     error TransferCallerNotOwnerNorApproved();
261 
262     /**
263      * The token must be owned by `from`.
264      */
265     error TransferFromIncorrectOwner();
266 
267     /**
268      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
269      */
270     error TransferToNonERC721ReceiverImplementer();
271 
272     /**
273      * Cannot transfer to the zero address.
274      */
275     error TransferToZeroAddress();
276 
277     /**
278      * The token does not exist.
279      */
280     error URIQueryForNonexistentToken();
281 
282     // Compiler will pack this into a single 256bit word.
283     struct TokenOwnership {
284         // The address of the owner.
285         address addr;
286         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
287         uint64 startTimestamp;
288         // Whether the token has been burned.
289         bool burned;
290     }
291 
292     // Compiler will pack this into a single 256bit word.
293     struct AddressData {
294         // Realistically, 2**64-1 is more than enough.
295         uint64 balance;
296         // Keeps track of mint count with minimal overhead for tokenomics.
297         uint64 numberMinted;
298         // Keeps track of burn count with minimal overhead for tokenomics.
299         uint64 numberBurned;
300         // For miscellaneous variable(s) pertaining to the address
301         // (e.g. number of whitelist mint slots used).
302         // If there are multiple variables, please pack them into a uint64.
303         uint64 aux;
304     }
305 
306     /**
307      * @dev Returns the total amount of tokens stored by the contract.
308      * 
309      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
310      */
311     function totalSupply() external view returns (uint256);
312 }
313 
314 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
315 
316 
317 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 
322 /**
323  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
324  * @dev See https://eips.ethereum.org/EIPS/eip-721
325  */
326 interface IERC721Enumerable is IERC721 {
327     /**
328      * @dev Returns the total amount of tokens stored by the contract.
329      */
330     function totalSupply() external view returns (uint256);
331 
332     /**
333      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
334      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
335      */
336     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
337 
338     /**
339      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
340      * Use along with {totalSupply} to enumerate all tokens.
341      */
342     function tokenByIndex(uint256 index) external view returns (uint256);
343 }
344 
345 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
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
375 
376 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
377 
378 
379 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 /**
384  * @title ERC721 token receiver interface
385  * @dev Interface for any contract that wants to support safeTransfers
386  * from ERC721 asset contracts.
387  */
388 interface IERC721Receiver {
389     /**
390      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
391      * by `operator` from `from`, this function is called.
392      *
393      * It must return its Solidity selector to confirm the token transfer.
394      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
395      *
396      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
397      */
398     function onERC721Received(
399         address operator,
400         address from,
401         uint256 tokenId,
402         bytes calldata data
403     ) external returns (bytes4);
404 }
405 
406 // File: @openzeppelin/contracts/utils/Address.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
410 
411 pragma solidity ^0.8.1;
412 
413 /**
414  * @dev Collection of functions related to the address type
415  */
416 library Address {
417     /**
418      * @dev Returns true if `account` is a contract.
419      *
420      * [IMPORTANT]
421      * ====
422      * It is unsafe to assume that an address for which this function returns
423      * false is an externally-owned account (EOA) and not a contract.
424      *
425      * Among others, `isContract` will return false for the following
426      * types of addresses:
427      *
428      *  - an externally-owned account
429      *  - a contract in construction
430      *  - an address where a contract will be created
431      *  - an address where a contract lived, but was destroyed
432      * ====
433      *
434      * [IMPORTANT]
435      * ====
436      * You shouldn't rely on `isContract` to protect against flash loan attacks!
437      *
438      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
439      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
440      * constructor.
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize/address.code.length, which returns 0
445         // for contracts in construction, since the code is only stored at the end
446         // of the constructor execution.
447 
448         return account.code.length > 0;
449     }
450 
451     /**
452      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
453      * `recipient`, forwarding all available gas and reverting on errors.
454      *
455      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
456      * of certain opcodes, possibly making contracts go over the 2300 gas limit
457      * imposed by `transfer`, making them unable to receive funds via
458      * `transfer`. {sendValue} removes this limitation.
459      *
460      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
461      *
462      * IMPORTANT: because control is transferred to `recipient`, care must be
463      * taken to not create reentrancy vulnerabilities. Consider using
464      * {ReentrancyGuard} or the
465      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
466      */
467     function sendValue(address payable recipient, uint256 amount) internal {
468         require(address(this).balance >= amount, "Address: insufficient balance");
469 
470         (bool success, ) = recipient.call{value: amount}("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 
474     /**
475      * @dev Performs a Solidity function call using a low level `call`. A
476      * plain `call` is an unsafe replacement for a function call: use this
477      * function instead.
478      *
479      * If `target` reverts with a revert reason, it is bubbled up by this
480      * function (like regular Solidity function calls).
481      *
482      * Returns the raw returned data. To convert to the expected return value,
483      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
484      *
485      * Requirements:
486      *
487      * - `target` must be a contract.
488      * - calling `target` with `data` must not revert.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionCall(target, data, "Address: low-level call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
498      * `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value
525     ) internal returns (bytes memory) {
526         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
531      * with `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(address(this).balance >= value, "Address: insufficient balance for call");
542         require(isContract(target), "Address: call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.call{value: value}(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
555         return functionStaticCall(target, data, "Address: low-level static call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal view returns (bytes memory) {
569         require(isContract(target), "Address: static call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.staticcall(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
582         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(isContract(target), "Address: delegate call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.delegatecall(data);
599         return verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
604      * revert reason using the provided one.
605      *
606      * _Available since v4.3._
607      */
608     function verifyCallResult(
609         bool success,
610         bytes memory returndata,
611         string memory errorMessage
612     ) internal pure returns (bytes memory) {
613         if (success) {
614             return returndata;
615         } else {
616             // Look for revert reason and bubble it up if present
617             if (returndata.length > 0) {
618                 // The easiest way to bubble the revert reason is using memory via assembly
619 
620                 assembly {
621                     let returndata_size := mload(returndata)
622                     revert(add(32, returndata), returndata_size)
623                 }
624             } else {
625                 revert(errorMessage);
626             }
627         }
628     }
629 }
630 
631 // File: @openzeppelin/contracts/utils/Context.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Provides information about the current execution context, including the
640  * sender of the transaction and its data. While these are generally available
641  * via msg.sender and msg.data, they should not be accessed in such a direct
642  * manner, since when dealing with meta-transactions the account sending and
643  * paying for execution may not be the actual sender (as far as an application
644  * is concerned).
645  *
646  * This contract is only required for intermediate, library-like contracts.
647  */
648 abstract contract Context {
649     function _msgSender() internal view virtual returns (address) {
650         return msg.sender;
651     }
652 
653     function _msgData() internal view virtual returns (bytes calldata) {
654         return msg.data;
655     }
656 }
657 
658 // File: @openzeppelin/contracts/access/Ownable.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @dev Contract module which provides a basic access control mechanism, where
668  * there is an account (an owner) that can be granted exclusive access to
669  * specific functions.
670  *
671  * By default, the owner account will be the one that deploys the contract. This
672  * can later be changed with {transferOwnership}.
673  *
674  * This module is used through inheritance. It will make available the modifier
675  * `onlyOwner`, which can be applied to your functions to restrict their use to
676  * the owner.
677  */
678 abstract contract Ownable is Context {
679     address private _owner;
680 
681     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
682 
683     /**
684      * @dev Initializes the contract setting the deployer as the initial owner.
685      */
686     constructor() {
687         _transferOwnership(_msgSender());
688     }
689 
690     /**
691      * @dev Returns the address of the current owner.
692      */
693     function owner() public view virtual returns (address) {
694         return _owner;
695     }
696 
697     /**
698      * @dev Throws if called by any account other than the owner.
699      */
700     modifier onlyOwner() {
701         require(owner() == _msgSender(), "Ownable: caller is not the owner");
702         _;
703     }
704 
705     /**
706      * @dev Leaves the contract without owner. It will not be possible to call
707      * `onlyOwner` functions anymore. Can only be called by the current owner.
708      *
709      * NOTE: Renouncing ownership will leave the contract without an owner,
710      * thereby removing any functionality that is only available to the owner.
711      */
712     function renounceOwnership() public virtual onlyOwner {
713         _transferOwnership(address(0));
714     }
715 
716     /**
717      * @dev Transfers ownership of the contract to a new account (`newOwner`).
718      * Can only be called by the current owner.
719      */
720     function transferOwnership(address newOwner) public virtual onlyOwner {
721         require(newOwner != address(0), "Ownable: new owner is the zero address");
722         _transferOwnership(newOwner);
723     }
724 
725     /**
726      * @dev Transfers ownership of the contract to a new account (`newOwner`).
727      * Internal function without access restriction.
728      */
729     function _transferOwnership(address newOwner) internal virtual {
730         address oldOwner = _owner;
731         _owner = newOwner;
732         emit OwnershipTransferred(oldOwner, newOwner);
733     }
734 }
735 
736 // File: @openzeppelin/contracts/utils/Strings.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 /**
744  * @dev String operations.
745  */
746 library Strings {
747     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
748 
749     /**
750      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
751      */
752     function toString(uint256 value) internal pure returns (string memory) {
753         // Inspired by OraclizeAPI's implementation - MIT licence
754         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
755 
756         if (value == 0) {
757             return "0";
758         }
759         uint256 temp = value;
760         uint256 digits;
761         while (temp != 0) {
762             digits++;
763             temp /= 10;
764         }
765         bytes memory buffer = new bytes(digits);
766         while (value != 0) {
767             digits -= 1;
768             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
769             value /= 10;
770         }
771         return string(buffer);
772     }
773 
774     /**
775      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
776      */
777     function toHexString(uint256 value) internal pure returns (string memory) {
778         if (value == 0) {
779             return "0x00";
780         }
781         uint256 temp = value;
782         uint256 length = 0;
783         while (temp != 0) {
784             length++;
785             temp >>= 8;
786         }
787         return toHexString(value, length);
788     }
789 
790     /**
791      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
792      */
793     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
794         bytes memory buffer = new bytes(2 * length + 2);
795         buffer[0] = "0";
796         buffer[1] = "x";
797         for (uint256 i = 2 * length + 1; i > 1; --i) {
798             buffer[i] = _HEX_SYMBOLS[value & 0xf];
799             value >>= 4;
800         }
801         require(value == 0, "Strings: hex length insufficient");
802         return string(buffer);
803     }
804 }
805 
806 // File: https://github.com/chiru-labs/ERC721A/contracts/ERC721A.sol
807 
808 
809 // ERC721A Contracts v3.3.0
810 // Creator: Chiru Labs
811 
812 pragma solidity ^0.8.4;
813 
814 
815 
816 
817 
818 
819 
820 /**
821  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
822  * the Metadata extension. Built to optimize for lower gas during batch mints.
823  *
824  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
825  *
826  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
827  *
828  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
829  */
830 contract ERC721A is Context, ERC165, IERC721A {
831     using Address for address;
832     using Strings for uint256;
833 
834     // The tokenId of the next token to be minted.
835     uint256 internal _currentIndex;
836 
837     // The number of tokens burned.
838     uint256 internal _burnCounter;
839 
840     // Token name
841     string private _name;
842 
843     // Token symbol
844     string private _symbol;
845 
846     // Mapping from token ID to ownership details
847     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
848     mapping(uint256 => TokenOwnership) internal _ownerships;
849 
850     // Mapping owner address to address data
851     mapping(address => AddressData) private _addressData;
852 
853     // Mapping from token ID to approved address
854     mapping(uint256 => address) private _tokenApprovals;
855 
856     // Mapping from owner to operator approvals
857     mapping(address => mapping(address => bool)) private _operatorApprovals;
858 
859     constructor(string memory name_, string memory symbol_) {
860         _name = name_;
861         _symbol = symbol_;
862         _currentIndex = _startTokenId();
863     }
864 
865     /**
866      * To change the starting tokenId, please override this function.
867      */
868     function _startTokenId() internal view virtual returns (uint256) {
869         return 0;
870     }
871 
872     /**
873      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
874      */
875     function totalSupply() public view override returns (uint256) {
876         // Counter underflow is impossible as _burnCounter cannot be incremented
877         // more than _currentIndex - _startTokenId() times
878         unchecked {
879             return _currentIndex - _burnCounter - _startTokenId();
880         }
881     }
882 
883     /**
884      * Returns the total amount of tokens minted in the contract.
885      */
886     function _totalMinted() internal view returns (uint256) {
887         // Counter underflow is impossible as _currentIndex does not decrement,
888         // and it is initialized to _startTokenId()
889         unchecked {
890             return _currentIndex - _startTokenId();
891         }
892     }
893 
894     /**
895      * @dev See {IERC165-supportsInterface}.
896      */
897     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
898         return
899             interfaceId == type(IERC721).interfaceId ||
900             interfaceId == type(IERC721Metadata).interfaceId ||
901             super.supportsInterface(interfaceId);
902     }
903 
904     /**
905      * @dev See {IERC721-balanceOf}.
906      */
907     function balanceOf(address owner) public view override returns (uint256) {
908         if (owner == address(0)) revert BalanceQueryForZeroAddress();
909         return uint256(_addressData[owner].balance);
910     }
911 
912     /**
913      * Returns the number of tokens minted by `owner`.
914      */
915     function _numberMinted(address owner) internal view returns (uint256) {
916         return uint256(_addressData[owner].numberMinted);
917     }
918 
919     /**
920      * Returns the number of tokens burned by or on behalf of `owner`.
921      */
922     function _numberBurned(address owner) internal view returns (uint256) {
923         return uint256(_addressData[owner].numberBurned);
924     }
925 
926     /**
927      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
928      */
929     function _getAux(address owner) internal view returns (uint64) {
930         return _addressData[owner].aux;
931     }
932 
933     /**
934      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
935      * If there are multiple variables, please pack them into a uint64.
936      */
937     function _setAux(address owner, uint64 aux) internal {
938         _addressData[owner].aux = aux;
939     }
940 
941     /**
942      * Gas spent here starts off proportional to the maximum mint batch size.
943      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
944      */
945     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
946         uint256 curr = tokenId;
947 
948         unchecked {
949             if (_startTokenId() <= curr) if (curr < _currentIndex) {
950                 TokenOwnership memory ownership = _ownerships[curr];
951                 if (!ownership.burned) {
952                     if (ownership.addr != address(0)) {
953                         return ownership;
954                     }
955                     // Invariant:
956                     // There will always be an ownership that has an address and is not burned
957                     // before an ownership that does not have an address and is not burned.
958                     // Hence, curr will not underflow.
959                     while (true) {
960                         curr--;
961                         ownership = _ownerships[curr];
962                         if (ownership.addr != address(0)) {
963                             return ownership;
964                         }
965                     }
966                 }
967             }
968         }
969         revert OwnerQueryForNonexistentToken();
970     }
971 
972     /**
973      * @dev See {IERC721-ownerOf}.
974      */
975     function ownerOf(uint256 tokenId) public view override returns (address) {
976         return _ownershipOf(tokenId).addr;
977     }
978 
979     /**
980      * @dev See {IERC721Metadata-name}.
981      */
982     function name() public view virtual override returns (string memory) {
983         return _name;
984     }
985 
986     /**
987      * @dev See {IERC721Metadata-symbol}.
988      */
989     function symbol() public view virtual override returns (string memory) {
990         return _symbol;
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-tokenURI}.
995      */
996     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
997         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
998 
999         string memory baseURI = _baseURI();
1000         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1001     }
1002 
1003     /**
1004      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1005      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1006      * by default, can be overriden in child contracts.
1007      */
1008     function _baseURI() internal view virtual returns (string memory) {
1009         return '';
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-approve}.
1014      */
1015     function approve(address to, uint256 tokenId) public override {
1016         address owner = ERC721A.ownerOf(tokenId);
1017         if (to == owner) revert ApprovalToCurrentOwner();
1018 
1019         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1020             revert ApprovalCallerNotOwnerNorApproved();
1021         }
1022 
1023         _tokenApprovals[tokenId] = to;
1024         emit Approval(owner, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-getApproved}.
1029      */
1030     function getApproved(uint256 tokenId) public view override returns (address) {
1031         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1032 
1033         return _tokenApprovals[tokenId];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-setApprovalForAll}.
1038      */
1039     function setApprovalForAll(address operator, bool approved) public virtual override {
1040         if (operator == _msgSender()) revert ApproveToCaller();
1041 
1042         _operatorApprovals[_msgSender()][operator] = approved;
1043         emit ApprovalForAll(_msgSender(), operator, approved);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-isApprovedForAll}.
1048      */
1049     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1050         return _operatorApprovals[owner][operator];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-transferFrom}.
1055      */
1056     function transferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public virtual override {
1061         _transfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-safeTransferFrom}.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) public virtual override {
1072         safeTransferFrom(from, to, tokenId, '');
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) public virtual override {
1084         _transfer(from, to, tokenId);
1085         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1086             revert TransferToNonERC721ReceiverImplementer();
1087         }
1088     }
1089 
1090     /**
1091      * @dev Returns whether `tokenId` exists.
1092      *
1093      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1094      *
1095      * Tokens start existing when they are minted (`_mint`),
1096      */
1097     function _exists(uint256 tokenId) internal view returns (bool) {
1098         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1099     }
1100 
1101     /**
1102      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1103      */
1104     function _safeMint(address to, uint256 quantity) internal {
1105         _safeMint(to, quantity, '');
1106     }
1107 
1108     /**
1109      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - If `to` refers to a smart contract, it must implement
1114      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1115      * - `quantity` must be greater than 0.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _safeMint(
1120         address to,
1121         uint256 quantity,
1122         bytes memory _data
1123     ) internal {
1124         uint256 startTokenId = _currentIndex;
1125         if (to == address(0)) revert MintToZeroAddress();
1126         if (quantity == 0) revert MintZeroQuantity();
1127 
1128         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1129 
1130         // Overflows are incredibly unrealistic.
1131         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1132         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1133         unchecked {
1134             _addressData[to].balance += uint64(quantity);
1135             _addressData[to].numberMinted += uint64(quantity);
1136 
1137             _ownerships[startTokenId].addr = to;
1138             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1139 
1140             uint256 updatedIndex = startTokenId;
1141             uint256 end = updatedIndex + quantity;
1142 
1143             if (to.isContract()) {
1144                 do {
1145                     emit Transfer(address(0), to, updatedIndex);
1146                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1147                         revert TransferToNonERC721ReceiverImplementer();
1148                     }
1149                 } while (updatedIndex < end);
1150                 // Reentrancy protection
1151                 if (_currentIndex != startTokenId) revert();
1152             } else {
1153                 do {
1154                     emit Transfer(address(0), to, updatedIndex++);
1155                 } while (updatedIndex < end);
1156             }
1157             _currentIndex = updatedIndex;
1158         }
1159         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1160     }
1161 
1162     /**
1163      * @dev Mints `quantity` tokens and transfers them to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `to` cannot be the zero address.
1168      * - `quantity` must be greater than 0.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _mint(address to, uint256 quantity) internal {
1173         uint256 startTokenId = _currentIndex;
1174         if (to == address(0)) revert MintToZeroAddress();
1175         if (quantity == 0) revert MintZeroQuantity();
1176 
1177         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1178 
1179         // Overflows are incredibly unrealistic.
1180         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1181         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1182         unchecked {
1183             _addressData[to].balance += uint64(quantity);
1184             _addressData[to].numberMinted += uint64(quantity);
1185 
1186             _ownerships[startTokenId].addr = to;
1187             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1188 
1189             uint256 updatedIndex = startTokenId;
1190             uint256 end = updatedIndex + quantity;
1191 
1192             do {
1193                 emit Transfer(address(0), to, updatedIndex++);
1194             } while (updatedIndex < end);
1195 
1196             _currentIndex = updatedIndex;
1197         }
1198         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1199     }
1200 
1201     /**
1202      * @dev Transfers `tokenId` from `from` to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must be owned by `from`.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _transfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) private {
1216         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1217 
1218         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1219 
1220         bool isApprovedOrOwner = (_msgSender() == from ||
1221             isApprovedForAll(from, _msgSender()) ||
1222             getApproved(tokenId) == _msgSender());
1223 
1224         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1225         if (to == address(0)) revert TransferToZeroAddress();
1226 
1227         _beforeTokenTransfers(from, to, tokenId, 1);
1228 
1229         // Clear approvals from the previous owner.
1230         delete _tokenApprovals[tokenId];
1231 
1232         // Underflow of the sender's balance is impossible because we check for
1233         // ownership above and the recipient's balance can't realistically overflow.
1234         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1235         unchecked {
1236             _addressData[from].balance -= 1;
1237             _addressData[to].balance += 1;
1238 
1239             TokenOwnership storage currSlot = _ownerships[tokenId];
1240             currSlot.addr = to;
1241             currSlot.startTimestamp = uint64(block.timestamp);
1242 
1243             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1244             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1245             uint256 nextTokenId = tokenId + 1;
1246             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1247             if (nextSlot.addr == address(0)) {
1248                 // This will suffice for checking _exists(nextTokenId),
1249                 // as a burned slot cannot contain the zero address.
1250                 if (nextTokenId != _currentIndex) {
1251                     nextSlot.addr = from;
1252                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1253                 }
1254             }
1255         }
1256 
1257         emit Transfer(from, to, tokenId);
1258         _afterTokenTransfers(from, to, tokenId, 1);
1259     }
1260 
1261     /**
1262      * @dev Equivalent to `_burn(tokenId, false)`.
1263      */
1264     function _burn(uint256 tokenId) internal virtual {
1265         _burn(tokenId, false);
1266     }
1267 
1268     /**
1269      * @dev Destroys `tokenId`.
1270      * The approval is cleared when the token is burned.
1271      *
1272      * Requirements:
1273      *
1274      * - `tokenId` must exist.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1279         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1280 
1281         address from = prevOwnership.addr;
1282 
1283         if (approvalCheck) {
1284             bool isApprovedOrOwner = (_msgSender() == from ||
1285                 isApprovedForAll(from, _msgSender()) ||
1286                 getApproved(tokenId) == _msgSender());
1287 
1288             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1289         }
1290 
1291         _beforeTokenTransfers(from, address(0), tokenId, 1);
1292 
1293         // Clear approvals from the previous owner.
1294         delete _tokenApprovals[tokenId];
1295 
1296         // Underflow of the sender's balance is impossible because we check for
1297         // ownership above and the recipient's balance can't realistically overflow.
1298         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1299         unchecked {
1300             AddressData storage addressData = _addressData[from];
1301             addressData.balance -= 1;
1302             addressData.numberBurned += 1;
1303 
1304             // Keep track of who burned the token, and the timestamp of burning.
1305             TokenOwnership storage currSlot = _ownerships[tokenId];
1306             currSlot.addr = from;
1307             currSlot.startTimestamp = uint64(block.timestamp);
1308             currSlot.burned = true;
1309 
1310             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1311             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1312             uint256 nextTokenId = tokenId + 1;
1313             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1314             if (nextSlot.addr == address(0)) {
1315                 // This will suffice for checking _exists(nextTokenId),
1316                 // as a burned slot cannot contain the zero address.
1317                 if (nextTokenId != _currentIndex) {
1318                     nextSlot.addr = from;
1319                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1320                 }
1321             }
1322         }
1323 
1324         emit Transfer(from, address(0), tokenId);
1325         _afterTokenTransfers(from, address(0), tokenId, 1);
1326 
1327         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1328         unchecked {
1329             _burnCounter++;
1330         }
1331     }
1332 
1333     /**
1334      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1335      *
1336      * @param from address representing the previous owner of the given token ID
1337      * @param to target address that will receive the tokens
1338      * @param tokenId uint256 ID of the token to be transferred
1339      * @param _data bytes optional data to send along with the call
1340      * @return bool whether the call correctly returned the expected magic value
1341      */
1342     function _checkContractOnERC721Received(
1343         address from,
1344         address to,
1345         uint256 tokenId,
1346         bytes memory _data
1347     ) private returns (bool) {
1348         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1349             return retval == IERC721Receiver(to).onERC721Received.selector;
1350         } catch (bytes memory reason) {
1351             if (reason.length == 0) {
1352                 revert TransferToNonERC721ReceiverImplementer();
1353             } else {
1354                 assembly {
1355                     revert(add(32, reason), mload(reason))
1356                 }
1357             }
1358         }
1359     }
1360 
1361     /**
1362      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1363      * And also called before burning one token.
1364      *
1365      * startTokenId - the first token id to be transferred
1366      * quantity - the amount to be transferred
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` will be minted for `to`.
1373      * - When `to` is zero, `tokenId` will be burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _beforeTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 
1383     /**
1384      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1385      * minting.
1386      * And also called after one token has been burned.
1387      *
1388      * startTokenId - the first token id to be transferred
1389      * quantity - the amount to be transferred
1390      *
1391      * Calling conditions:
1392      *
1393      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1394      * transferred to `to`.
1395      * - When `from` is zero, `tokenId` has been minted for `to`.
1396      * - When `to` is zero, `tokenId` has been burned by `from`.
1397      * - `from` and `to` are never both zero.
1398      */
1399     function _afterTokenTransfers(
1400         address from,
1401         address to,
1402         uint256 startTokenId,
1403         uint256 quantity
1404     ) internal virtual {}
1405 }
1406 
1407 // File: PufferGs.sol
1408 
1409 
1410 
1411 // Puffer Gang NFT contract created by NickNack using ERC-721A
1412 // Puffer Gang has become a free-to-mint NFT however, we reserve the right to amend this at any point.
1413 // This is not currently the intention
1414 
1415 pragma solidity >=0.8.0 <0.9.0;
1416 
1417 
1418 
1419 
1420 
1421 
1422 
1423 
1424 
1425 
1426 //Interface with the $FISH token to allow NFT minters to receive rewards upon mint.
1427 
1428 interface FishToken {
1429     function updateRewardOnMint(address _to, uint256 _amount) external;
1430     function updateReward(address _from, address _to) external;
1431     function getReward(address _to) external;
1432     function spend(address _from, uint256 _amount) external;
1433 }
1434 
1435 contract PufferGang is ERC721A, Ownable {
1436     using Strings for uint256;
1437 
1438     string public baseURI;
1439     string public notRevealedUri;
1440 
1441     bool public isPaused = true;
1442     bool public isRevealed = false;
1443 
1444     uint256 public constant MAX_SUPPLY = 9876;
1445     uint256 public constant MAX_TX_MINT_AMOUNT = 5;
1446     uint256 public maxMintAmount = 5;
1447     uint256 public cost = 0 ether;
1448     uint256 public marketingSupply = 500;
1449 
1450     FishToken public fishToken;
1451 
1452     event NewPufferMinted(address sender, uint256 mintAmount);
1453 
1454     constructor(
1455         string memory _name,
1456         string memory _symbol,
1457         string memory _initNotRevealedUri
1458     ) ERC721A(_name, _symbol) {
1459         setNotRevealedURI(_initNotRevealedUri);
1460     }
1461 
1462 // Check that minter meets conditions before mint and set minting conditions.
1463 
1464     modifier checks(uint256 _mintAmount) {
1465         require(
1466             (!isPaused || msg.sender == owner()) &&
1467                 _mintAmount > 0 &&
1468                 (_mintAmount <= MAX_TX_MINT_AMOUNT) &&
1469                 totalSupply() + _mintAmount <= MAX_SUPPLY - marketingSupply,
1470             isPaused
1471                 ? "Sale is paused"
1472                 : (
1473                             _mintAmount > MAX_TX_MINT_AMOUNT
1474                                 ? "Maximum mint amount exceeded"
1475                                 : "Supply limit exceeded"
1476                         )
1477                 );
1478 
1479             require(
1480                 _numberMinted(msg.sender) + _mintAmount <= maxMintAmount,
1481                 "Maximum mint amount exceeded"
1482             );
1483         _;
1484     }
1485 
1486 // Set initial token ID
1487 
1488     function _startTokenId() internal view virtual override returns (uint256) {
1489         return 1;
1490     }
1491 
1492 // Set base URI for fully revealed NFT
1493 
1494     function _baseURI() internal view virtual override returns (string memory) {
1495         return baseURI;
1496     }
1497 
1498     function tokenURI(uint256 tokenId)
1499         public
1500         view
1501         virtual
1502         override
1503         returns (string memory)
1504     {
1505         require(_exists(tokenId));
1506         if (isRevealed == false) {
1507             return notRevealedUri;
1508         }
1509         string memory currentBaseURI = _baseURI();
1510         return
1511             bytes(currentBaseURI).length > 0
1512                 ? string(
1513                     abi.encodePacked(
1514                         currentBaseURI,
1515                         tokenId.toString(),
1516                         ".json"
1517                     )
1518                 )
1519                 : "";
1520     }
1521 
1522 // Mint and award $FISH tokens
1523 
1524     function _processMint(uint256 _mintAmount) internal {
1525         _safeMint(msg.sender, _mintAmount);
1526         emit NewPufferMinted(msg.sender, _mintAmount);
1527         fishToken.updateRewardOnMint(msg.sender, _mintAmount);
1528     }
1529 
1530     function mint(uint256 _mintAmount)
1531         public
1532         payable
1533         checks(_mintAmount)
1534     {
1535         _processMint(_mintAmount);
1536     }
1537 
1538     function walletOfOwner(address _owner)
1539         public
1540         view
1541         returns (uint256[] memory)
1542     {
1543         uint256 ownerTokenCount = balanceOf(_owner);
1544         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1545         uint256 currentTokenId = _startTokenId();
1546         uint256 ownedTokenIndex = 0;
1547         address latestOwnerAddress;
1548 
1549         while (
1550             ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY
1551         ) {
1552             TokenOwnership memory ownership = _ownerships[currentTokenId];
1553 
1554             if (!ownership.burned && ownership.addr != address(0)) {
1555                 latestOwnerAddress = ownership.addr;
1556             }
1557 
1558             if (latestOwnerAddress == _owner) {
1559                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1560 
1561                 ownedTokenIndex++;
1562             }
1563 
1564             currentTokenId++;
1565         }
1566         return ownedTokenIds;
1567     }
1568 
1569     function mintedTotalOf(address _owner) public view returns (uint256) {
1570         return _numberMinted(_owner);
1571     }
1572 
1573     function toggleIsPaused() public onlyOwner {
1574         isPaused = !isPaused;
1575     }
1576 
1577     function toggleIsRevealed() public onlyOwner {
1578         if (!isRevealed) require(bytes(baseURI).length > 0, "BaseURI not set");
1579         isRevealed = !isRevealed;
1580     }
1581 
1582     function setToken(address _contract) external onlyOwner {
1583         fishToken = FishToken(_contract);
1584     }
1585 
1586     function setCost(uint256 _newCost) public onlyOwner {
1587         cost = _newCost;
1588     }
1589 
1590     function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
1591         maxMintAmount = _newMaxMintAmount;
1592     }
1593 
1594     function setMarketingSupply(uint256 _newMarketingSupply) public onlyOwner {
1595         require(
1596             _newMarketingSupply <= MAX_SUPPLY - totalSupply(),
1597             "Must be less than remaining supply"
1598         );
1599         marketingSupply = _newMarketingSupply;
1600     }
1601 
1602 //URI for pre-reveal - directs to a singular token IF
1603 
1604     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1605         notRevealedUri = _notRevealedURI;
1606     }
1607 
1608 //URI for revealed NFT
1609 
1610     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1611         baseURI = _newBaseURI;
1612     }
1613 
1614 // Airdrop tokens for marketing or rewards
1615 
1616     function airdrop(address[] calldata _users) public payable onlyOwner {
1617         require(
1618             marketingSupply > 0 &&
1619                 _users.length <= marketingSupply &&
1620                 _users.length > 0 &&
1621                 (totalSupply() + _users.length < MAX_SUPPLY - marketingSupply),
1622             marketingSupply <= 0
1623                 ? "Marketing supply empty"
1624                 : (
1625                     _users.length > marketingSupply
1626                         ? "Addresses exceed marketing supply"
1627                         : (
1628                             _users.length == 0
1629                                 ? "At least 1 address required"
1630                                 : "Supply limit exceeded"
1631                         )
1632                 )
1633         );
1634 
1635         for (uint256 i = 0; i < _users.length; i++) {
1636             _safeMint(_users[i], 1);
1637             emit NewPufferMinted(_users[i], 1);
1638             --marketingSupply;
1639             fishToken.updateReward(address(0), _users[i]);
1640         }
1641     //Withdraw function for contract (if required)
1642 
1643     }
1644      function withdrawMoneyTo(address payable _to) public onlyOwner {
1645         _to.transfer(getBalanceContract());
1646     }
1647     function getBalanceContract() public view onlyOwner returns(uint){
1648         return address(this).balance;
1649     }
1650 
1651     function claimTokens() external {
1652         fishToken.updateReward(msg.sender, address(0));
1653         fishToken.getReward(msg.sender);
1654     }
1655 
1656     function spendTokens(uint256 _amount) external {
1657         fishToken.spend(msg.sender, _amount);
1658     }
1659 
1660     function _beforeTokenTransfers(
1661         address from,
1662         address to,
1663         uint256 tokenId,
1664         uint256 quantity
1665     ) internal virtual override {
1666         super._beforeTokenTransfers(from, to, tokenId, quantity);
1667         if (from != address(0)) {
1668             fishToken.updateReward(from, to);
1669         }
1670     }
1671 }