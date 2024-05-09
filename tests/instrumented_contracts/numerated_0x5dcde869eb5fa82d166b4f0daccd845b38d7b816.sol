1 // File: contracts/DegenBoyz.sol
2 
3 //SPDX-License-Identifier: MIT
4 
5 /*
6 ██████╗░███████╗░██████╗░███████╗███╗░░██╗  ██████╗░░█████╗░██╗░░░██╗███████╗
7 ██╔══██╗██╔════╝██╔════╝░██╔════╝████╗░██║  ██╔══██╗██╔══██╗╚██╗░██╔╝╚════██║
8 ██║░░██║█████╗░░██║░░██╗░█████╗░░██╔██╗██║  ██████╦╝██║░░██║░╚████╔╝░░░███╔═╝
9 ██║░░██║██╔══╝░░██║░░╚██╗██╔══╝░░██║╚████║  ██╔══██╗██║░░██║░░╚██╔╝░░██╔══╝░░
10 ██████╔╝███████╗╚██████╔╝███████╗██║░╚███║  ██████╦╝╚█████╔╝░░░██║░░░███████╗
11 ╚═════╝░╚══════╝░╚═════╝░╚══════╝╚═╝░░╚══╝  ╚═════╝░░╚════╝░░░░╚═╝░░░╚══════╝
12 */
13 
14 pragma solidity ^0.8.0;
15 
16 abstract contract ReentrancyGuard {
17     uint256 private constant _NOT_ENTERED = 1;
18     uint256 private constant _ENTERED = 2;
19     uint256 private _status;
20 
21     constructor() {
22         _status = _NOT_ENTERED;
23     }
24 
25     /**
26      * @dev Prevents a contract from calling itself, directly or indirectly.
27      * Calling a `nonReentrant` function from another `nonReentrant`
28      * function is not supported. It is possible to prevent this from happening
29      * by making the `nonReentrant` function external, and making it call a
30      * `private` function that does the actual work.
31      */
32     modifier nonReentrant() {
33         // On the first call to nonReentrant, _notEntered will be true
34         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
35 
36         // Any calls to nonReentrant after this point will fail
37         _status = _ENTERED;
38 
39         _;
40 
41         // By storing the original value once again, a refund is triggered (see
42         // https://eips.ethereum.org/EIPS/eip-2200)
43         _status = _NOT_ENTERED;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 // File: @openzeppelin/contracts/access/Ownable.sol
142 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
143 
144 pragma solidity ^0.8.0;
145 /**
146  * @dev Contract module which provides a basic access control mechanism, where
147  * there is an account (an owner) that can be granted exclusive access to
148  * specific functions.
149  *
150  * By default, the owner account will be the one that deploys the contract. This
151  * can later be changed with {transferOwnership}.
152  *
153  * This module is used through inheritance. It will make available the modifier
154  * `onlyOwner`, which can be applied to your functions to restrict their use to
155  * the owner.
156  */
157 abstract contract Ownable is Context {
158     address private _owner;
159 
160     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162     /**
163      * @dev Initializes the contract setting the deployer as the initial owner.
164      */
165     constructor() {
166         _transferOwnership(_msgSender());
167     }
168 
169     /**
170      * @dev Returns the address of the current owner.
171      */
172     function owner() public view virtual returns (address) {
173         return _owner;
174     }
175 
176     /**
177      * @dev Throws if called by any account other than the owner.
178      */
179     modifier onlyOwner() {
180         require(owner() == _msgSender(), "Ownable: caller is not the owner");
181         _;
182     }
183 
184     /**
185      * @dev Leaves the contract without owner. It will not be possible to call
186      * `onlyOwner` functions anymore. Can only be called by the current owner.
187      *
188      * NOTE: Renouncing ownership will leave the contract without an owner,
189      * thereby removing any functionality that is only available to the owner.
190      */
191     function renounceOwnership() public virtual onlyOwner {
192         _transferOwnership(address(0));
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Can only be called by the current owner.
198      */
199     function transferOwnership(address newOwner) public virtual onlyOwner {
200         require(newOwner != address(0), "Ownable: new owner is the zero address");
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Internal function without access restriction.
207      */
208     function _transferOwnership(address newOwner) internal virtual {
209         address oldOwner = _owner;
210         _owner = newOwner;
211         emit OwnershipTransferred(oldOwner, newOwner);
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/Address.sol
216 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
217 
218 pragma solidity ^0.8.1;
219 
220 /**
221  * @dev Collection of functions related to the address type
222  */
223 library Address {
224     /**
225      * @dev Returns true if `account` is a contract.
226      *
227      * [IMPORTANT]
228      * ====
229      * It is unsafe to assume that an address for which this function returns
230      * false is an externally-owned account (EOA) and not a contract.
231      *
232      * Among others, `isContract` will return false for the following
233      * types of addresses:
234      *
235      *  - an externally-owned account
236      *  - a contract in construction
237      *  - an address where a contract will be created
238      *  - an address where a contract lived, but was destroyed
239      * ====
240      *
241      * [IMPORTANT]
242      * ====
243      * You shouldn't rely on `isContract` to protect against flash loan attacks!
244      *
245      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
246      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
247      * constructor.
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize/address.code.length, which returns 0
252         // for contracts in construction, since the code is only stored at the end
253         // of the constructor execution.
254 
255         return account.code.length > 0;
256     }
257 
258     /**
259      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260      * `recipient`, forwarding all available gas and reverting on errors.
261      *
262      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263      * of certain opcodes, possibly making contracts go over the 2300 gas limit
264      * imposed by `transfer`, making them unable to receive funds via
265      * `transfer`. {sendValue} removes this limitation.
266      *
267      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268      *
269      * IMPORTANT: because control is transferred to `recipient`, care must be
270      * taken to not create reentrancy vulnerabilities. Consider using
271      * {ReentrancyGuard} or the
272      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273      */
274     function sendValue(address payable recipient, uint256 amount) internal {
275         require(address(this).balance >= amount, "Address: insufficient balance");
276 
277         (bool success, ) = recipient.call{value: amount}("");
278         require(success, "Address: unable to send value, recipient may have reverted");
279     }
280 
281     /**
282      * @dev Performs a Solidity function call using a low level `call`. A
283      * plain `call` is an unsafe replacement for a function call: use this
284      * function instead.
285      *
286      * If `target` reverts with a revert reason, it is bubbled up by this
287      * function (like regular Solidity function calls).
288      *
289      * Returns the raw returned data. To convert to the expected return value,
290      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
291      *
292      * Requirements:
293      *
294      * - `target` must be a contract.
295      * - calling `target` with `data` must not revert.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
300         return functionCall(target, data, "Address: low-level call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
305      * `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(
310         address target,
311         bytes memory data,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, 0, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but also transferring `value` wei to `target`.
320      *
321      * Requirements:
322      *
323      * - the calling contract must have an ETH balance of at least `value`.
324      * - the called Solidity function must be `payable`.
325      *
326      * _Available since v3.1._
327      */
328     function functionCallWithValue(
329         address target,
330         bytes memory data,
331         uint256 value
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338      * with `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value,
346         string memory errorMessage
347     ) internal returns (bytes memory) {
348         require(address(this).balance >= value, "Address: insufficient balance for call");
349         require(isContract(target), "Address: call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.call{value: value}(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a static call.
358      *
359      * _Available since v3.3._
360      */
361     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
362         return functionStaticCall(target, data, "Address: low-level static call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal view returns (bytes memory) {
376         require(isContract(target), "Address: static call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.staticcall(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.4._
387      */
388     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         require(isContract(target), "Address: delegate call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.delegatecall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
411      * revert reason using the provided one.
412      *
413      * _Available since v4.3._
414      */
415     function verifyCallResult(
416         bool success,
417         bytes memory returndata,
418         string memory errorMessage
419     ) internal pure returns (bytes memory) {
420         if (success) {
421             return returndata;
422         } else {
423             // Look for revert reason and bubble it up if present
424             if (returndata.length > 0) {
425                 // The easiest way to bubble the revert reason is using memory via assembly
426 
427                 assembly {
428                     let returndata_size := mload(returndata)
429                     revert(add(32, returndata), returndata_size)
430                 }
431             } else {
432                 revert(errorMessage);
433             }
434         }
435     }
436 }
437 
438 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
439 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @title ERC721 token receiver interface
445  * @dev Interface for any contract that wants to support safeTransfers
446  * from ERC721 asset contracts.
447  */
448 interface IERC721Receiver {
449     /**
450      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
451      * by `operator` from `from`, this function is called.
452      *
453      * It must return its Solidity selector to confirm the token transfer.
454      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
455      *
456      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
457      */
458     function onERC721Received(
459         address operator,
460         address from,
461         uint256 tokenId,
462         bytes calldata data
463     ) external returns (bytes4);
464 }
465 
466 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
467 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev Interface of the ERC165 standard, as defined in the
473  * https://eips.ethereum.org/EIPS/eip-165[EIP].
474  *
475  * Implementers can declare support of contract interfaces, which can then be
476  * queried by others ({ERC165Checker}).
477  *
478  * For an implementation, see {ERC165}.
479  */
480 interface IERC165 {
481     /**
482      * @dev Returns true if this contract implements the interface defined by
483      * `interfaceId`. See the corresponding
484      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
485      * to learn more about how these ids are created.
486      *
487      * This function call must use less than 30 000 gas.
488      */
489     function supportsInterface(bytes4 interfaceId) external view returns (bool);
490 }
491 
492 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
493 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
494 
495 pragma solidity ^0.8.0;
496 /**
497  * @dev Implementation of the {IERC165} interface.
498  *
499  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
500  * for the additional interface id that will be supported. For example:
501  *
502  * ```solidity
503  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
505  * }
506  * ```
507  *
508  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
509  */
510 abstract contract ERC165 is IERC165 {
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515         return interfaceId == type(IERC165).interfaceId;
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
520 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
521 
522 pragma solidity ^0.8.0;
523 /**
524  * @dev Required interface of an ERC721 compliant contract.
525  */
526 interface IERC721 is IERC165 {
527     /**
528      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
529      */
530     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
534      */
535     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
539      */
540     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
541 
542     /**
543      * @dev Returns the number of tokens in ``owner``'s account.
544      */
545     function balanceOf(address owner) external view returns (uint256 balance);
546 
547     /**
548      * @dev Returns the owner of the `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function ownerOf(uint256 tokenId) external view returns (address owner);
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must exist and be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId,
573         bytes calldata data
574     ) external;
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
578      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Transfers `tokenId` token from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      *
608      * Emits a {Transfer} event.
609      */
610     function transferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Approve or remove `operator` as an operator for the caller.
633      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
634      *
635      * Requirements:
636      *
637      * - The `operator` cannot be the caller.
638      *
639      * Emits an {ApprovalForAll} event.
640      */
641     function setApprovalForAll(address operator, bool _approved) external;
642 
643     /**
644      * @dev Returns the account approved for `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function getApproved(uint256 tokenId) external view returns (address operator);
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
661 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
662 
663 pragma solidity ^0.8.0;
664 /**
665  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
666  * @dev See https://eips.ethereum.org/EIPS/eip-721
667  */
668 interface IERC721Metadata is IERC721 {
669     /**
670      * @dev Returns the token collection name.
671      */
672     function name() external view returns (string memory);
673 
674     /**
675      * @dev Returns the token collection symbol.
676      */
677     function symbol() external view returns (string memory);
678 
679     /**
680      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
681      */
682     function tokenURI(uint256 tokenId) external view returns (string memory);
683 }
684 
685 // ERC721A Contracts v3.3.0
686 // Creator: Chiru Labs
687 
688 pragma solidity ^0.8.4;
689 /**
690  * @dev Interface of an ERC721A compliant contract.
691  */
692 interface IERC721A is IERC721, IERC721Metadata {
693     /**
694      * The caller must own the token or be an approved operator.
695      */
696     error ApprovalCallerNotOwnerNorApproved();
697 
698     /**
699      * The token does not exist.
700      */
701     error ApprovalQueryForNonexistentToken();
702 
703     /**
704      * The caller cannot approve to their own address.
705      */
706     error ApproveToCaller();
707 
708     /**
709      * The caller cannot approve to the current owner.
710      */
711     error ApprovalToCurrentOwner();
712 
713     /**
714      * Cannot query the balance for the zero address.
715      */
716     error BalanceQueryForZeroAddress();
717 
718     /**
719      * Cannot mint to the zero address.
720      */
721     error MintToZeroAddress();
722 
723     /**
724      * The quantity of tokens minted must be more than zero.
725      */
726     error MintZeroQuantity();
727 
728     /**
729      * The token does not exist.
730      */
731     error OwnerQueryForNonexistentToken();
732 
733     /**
734      * The caller must own the token or be an approved operator.
735      */
736     error TransferCallerNotOwnerNorApproved();
737 
738     /**
739      * The token must be owned by `from`.
740      */
741     error TransferFromIncorrectOwner();
742 
743     /**
744      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
745      */
746     error TransferToNonERC721ReceiverImplementer();
747 
748     /**
749      * Cannot transfer to the zero address.
750      */
751     error TransferToZeroAddress();
752 
753     /**
754      * The token does not exist.
755      */
756     error URIQueryForNonexistentToken();
757 
758     // Compiler will pack this into a single 256bit word.
759     struct TokenOwnership {
760         // The address of the owner.
761         address addr;
762         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
763         uint64 startTimestamp;
764         // Whether the token has been burned.
765         bool burned;
766     }
767 
768     // Compiler will pack this into a single 256bit word.
769     struct AddressData {
770         // Realistically, 2**64-1 is more than enough.
771         uint64 balance;
772         // Keeps track of mint count with minimal overhead for tokenomics.
773         uint64 numberMinted;
774         // Keeps track of burn count with minimal overhead for tokenomics.
775         uint64 numberBurned;
776         // For miscellaneous variable(s) pertaining to the address
777         // (e.g. number of whitelist mint slots used).
778         // If there are multiple variables, please pack them into a uint64.
779         uint64 aux;
780     }
781 
782     /**
783      * @dev Returns the total amount of tokens stored by the contract.
784      * 
785      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
786      */
787     function totalSupply() external view returns (uint256);
788 }
789 
790 // ERC721A Contracts v3.3.0
791 // Creator: Chiru Labs
792 
793 pragma solidity ^0.8.4;
794 
795 /**
796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
797  * the Metadata extension. Built to optimize for lower gas during batch mints.
798  *
799  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
800  *
801  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
802  *
803  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
804  */
805 contract ERC721A is Context, ERC165, IERC721A {
806     using Address for address;
807     using Strings for uint256;
808 
809     // The tokenId of the next token to be minted.
810     uint256 internal _currentIndex;
811 
812     // The number of tokens burned.
813     uint256 internal _burnCounter;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to ownership details
822     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
823     mapping(uint256 => TokenOwnership) internal _ownerships;
824 
825     // Mapping owner address to address data
826     mapping(address => AddressData) private _addressData;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837         _currentIndex = _startTokenId();
838     }
839 
840     /**
841      * To change the starting tokenId, please override this function.
842      */
843     function _startTokenId() internal view virtual returns (uint256) {
844         return 0;
845     }
846 
847     /**
848      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
849      */
850     function totalSupply() public view override returns (uint256) {
851         // Counter underflow is impossible as _burnCounter cannot be incremented
852         // more than _currentIndex - _startTokenId() times
853         unchecked {
854             return _currentIndex - _burnCounter - _startTokenId();
855         }
856     }
857 
858     /**
859      * Returns the total amount of tokens minted in the contract.
860      */
861     function _totalMinted() internal view returns (uint256) {
862         // Counter underflow is impossible as _currentIndex does not decrement,
863         // and it is initialized to _startTokenId()
864         unchecked {
865             return _currentIndex - _startTokenId();
866         }
867     }
868 
869     /**
870      * @dev See {IERC165-supportsInterface}.
871      */
872     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
873         return
874             interfaceId == type(IERC721).interfaceId ||
875             interfaceId == type(IERC721Metadata).interfaceId ||
876             super.supportsInterface(interfaceId);
877     }
878 
879     /**
880      * @dev See {IERC721-balanceOf}.
881      */
882     function balanceOf(address owner) public view override returns (uint256) {
883         if (owner == address(0)) revert BalanceQueryForZeroAddress();
884         return uint256(_addressData[owner].balance);
885     }
886 
887     /**
888      * Returns the number of tokens minted by `owner`.
889      */
890     function _numberMinted(address owner) internal view returns (uint256) {
891         return uint256(_addressData[owner].numberMinted);
892     }
893 
894     /**
895      * Returns the number of tokens burned by or on behalf of `owner`.
896      */
897     function _numberBurned(address owner) internal view returns (uint256) {
898         return uint256(_addressData[owner].numberBurned);
899     }
900 
901     /**
902      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
903      */
904     function _getAux(address owner) internal view returns (uint64) {
905         return _addressData[owner].aux;
906     }
907 
908     /**
909      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      * If there are multiple variables, please pack them into a uint64.
911      */
912     function _setAux(address owner, uint64 aux) internal {
913         _addressData[owner].aux = aux;
914     }
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         uint256 curr = tokenId;
922 
923         unchecked {
924             if (_startTokenId() <= curr) if (curr < _currentIndex) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (!ownership.burned) {
927                     if (ownership.addr != address(0)) {
928                         return ownership;
929                     }
930                     // Invariant:
931                     // There will always be an ownership that has an address and is not burned
932                     // before an ownership that does not have an address and is not burned.
933                     // Hence, curr will not underflow.
934                     while (true) {
935                         curr--;
936                         ownership = _ownerships[curr];
937                         if (ownership.addr != address(0)) {
938                             return ownership;
939                         }
940                     }
941                 }
942             }
943         }
944         revert OwnerQueryForNonexistentToken();
945     }
946 
947     /**
948      * @dev See {IERC721-ownerOf}.
949      */
950     function ownerOf(uint256 tokenId) public view override returns (address) {
951         return _ownershipOf(tokenId).addr;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-name}.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-symbol}.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-tokenURI}.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, can be overriden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return '';
985     }
986 
987     /**
988      * @dev See {IERC721-approve}.
989      */
990     function approve(address to, uint256 tokenId) public override {
991         address owner = ERC721A.ownerOf(tokenId);
992         if (to == owner) revert ApprovalToCurrentOwner();
993 
994         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
995             revert ApprovalCallerNotOwnerNorApproved();
996         }
997 
998         _approve(to, tokenId, owner);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId) public view override returns (address) {
1005         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1006 
1007         return _tokenApprovals[tokenId];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-setApprovalForAll}.
1012      */
1013     function setApprovalForAll(address operator, bool approved) public virtual override {
1014         if (operator == _msgSender()) revert ApproveToCaller();
1015 
1016         _operatorApprovals[_msgSender()][operator] = approved;
1017         emit ApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1024         return _operatorApprovals[owner][operator];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-transferFrom}.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         safeTransferFrom(from, to, tokenId, '');
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         _transfer(from, to, tokenId);
1059         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1060             revert TransferToNonERC721ReceiverImplementer();
1061         }
1062     }
1063 
1064     /**
1065      * @dev Returns whether `tokenId` exists.
1066      *
1067      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1068      *
1069      * Tokens start existing when they are minted (`_mint`),
1070      */
1071     function _exists(uint256 tokenId) internal view returns (bool) {
1072         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1073     }
1074 
1075     /**
1076      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1077      */
1078     function _safeMint(address to, uint256 quantity) internal {
1079         _safeMint(to, quantity, '');
1080     }
1081 
1082     /**
1083      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - If `to` refers to a smart contract, it must implement
1088      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _safeMint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data
1097     ) internal {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1106         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1107         unchecked {
1108             _addressData[to].balance += uint64(quantity);
1109             _addressData[to].numberMinted += uint64(quantity);
1110 
1111             _ownerships[startTokenId].addr = to;
1112             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1113 
1114             uint256 updatedIndex = startTokenId;
1115             uint256 end = updatedIndex + quantity;
1116 
1117             if (to.isContract()) {
1118                 do {
1119                     emit Transfer(address(0), to, updatedIndex);
1120                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1121                         revert TransferToNonERC721ReceiverImplementer();
1122                     }
1123                 } while (updatedIndex < end);
1124                 // Reentrancy protection
1125                 if (_currentIndex != startTokenId) revert();
1126             } else {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex++);
1129                 } while (updatedIndex < end);
1130             }
1131             _currentIndex = updatedIndex;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Mints `quantity` tokens and transfers them to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `quantity` must be greater than 0.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _mint(address to, uint256 quantity) internal {
1147         uint256 startTokenId = _currentIndex;
1148         if (to == address(0)) revert MintToZeroAddress();
1149         if (quantity == 0) revert MintZeroQuantity();
1150 
1151         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1152 
1153         // Overflows are incredibly unrealistic.
1154         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1155         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1156         unchecked {
1157             _addressData[to].balance += uint64(quantity);
1158             _addressData[to].numberMinted += uint64(quantity);
1159 
1160             _ownerships[startTokenId].addr = to;
1161             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             uint256 updatedIndex = startTokenId;
1164             uint256 end = updatedIndex + quantity;
1165 
1166             do {
1167                 emit Transfer(address(0), to, updatedIndex++);
1168             } while (updatedIndex < end);
1169 
1170             _currentIndex = updatedIndex;
1171         }
1172         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1173     }
1174 
1175     /**
1176      * @dev Transfers `tokenId` from `from` to `to`.
1177      *
1178      * Requirements:
1179      *
1180      * - `to` cannot be the zero address.
1181      * - `tokenId` token must be owned by `from`.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _transfer(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) private {
1190         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1191 
1192         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1193 
1194         bool isApprovedOrOwner = (_msgSender() == from ||
1195             isApprovedForAll(from, _msgSender()) ||
1196             getApproved(tokenId) == _msgSender());
1197 
1198         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1199         if (to == address(0)) revert TransferToZeroAddress();
1200 
1201         _beforeTokenTransfers(from, to, tokenId, 1);
1202 
1203         // Clear approvals from the previous owner
1204         _approve(address(0), tokenId, from);
1205 
1206         // Underflow of the sender's balance is impossible because we check for
1207         // ownership above and the recipient's balance can't realistically overflow.
1208         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1209         unchecked {
1210             _addressData[from].balance -= 1;
1211             _addressData[to].balance += 1;
1212 
1213             TokenOwnership storage currSlot = _ownerships[tokenId];
1214             currSlot.addr = to;
1215             currSlot.startTimestamp = uint64(block.timestamp);
1216 
1217             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1218             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1219             uint256 nextTokenId = tokenId + 1;
1220             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1221             if (nextSlot.addr == address(0)) {
1222                 // This will suffice for checking _exists(nextTokenId),
1223                 // as a burned slot cannot contain the zero address.
1224                 if (nextTokenId != _currentIndex) {
1225                     nextSlot.addr = from;
1226                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(from, to, tokenId);
1232         _afterTokenTransfers(from, to, tokenId, 1);
1233     }
1234 
1235     /**
1236      * @dev Equivalent to `_burn(tokenId, false)`.
1237      */
1238     function _burn(uint256 tokenId) internal virtual {
1239         _burn(tokenId, false);
1240     }
1241 
1242     /**
1243      * @dev Destroys `tokenId`.
1244      * The approval is cleared when the token is burned.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must exist.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1253         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1254 
1255         address from = prevOwnership.addr;
1256 
1257         if (approvalCheck) {
1258             bool isApprovedOrOwner = (_msgSender() == from ||
1259                 isApprovedForAll(from, _msgSender()) ||
1260                 getApproved(tokenId) == _msgSender());
1261 
1262             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1263         }
1264 
1265         _beforeTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Clear approvals from the previous owner
1268         _approve(address(0), tokenId, from);
1269 
1270         // Underflow of the sender's balance is impossible because we check for
1271         // ownership above and the recipient's balance can't realistically overflow.
1272         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1273         unchecked {
1274             AddressData storage addressData = _addressData[from];
1275             addressData.balance -= 1;
1276             addressData.numberBurned += 1;
1277 
1278             // Keep track of who burned the token, and the timestamp of burning.
1279             TokenOwnership storage currSlot = _ownerships[tokenId];
1280             currSlot.addr = from;
1281             currSlot.startTimestamp = uint64(block.timestamp);
1282             currSlot.burned = true;
1283 
1284             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1285             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1286             uint256 nextTokenId = tokenId + 1;
1287             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1288             if (nextSlot.addr == address(0)) {
1289                 // This will suffice for checking _exists(nextTokenId),
1290                 // as a burned slot cannot contain the zero address.
1291                 if (nextTokenId != _currentIndex) {
1292                     nextSlot.addr = from;
1293                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1294                 }
1295             }
1296         }
1297 
1298         emit Transfer(from, address(0), tokenId);
1299         _afterTokenTransfers(from, address(0), tokenId, 1);
1300 
1301         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1302         unchecked {
1303             _burnCounter++;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Approve `to` to operate on `tokenId`
1309      *
1310      * Emits a {Approval} event.
1311      */
1312     function _approve(
1313         address to,
1314         uint256 tokenId,
1315         address owner
1316     ) private {
1317         _tokenApprovals[tokenId] = to;
1318         emit Approval(owner, to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkContractOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1337             return retval == IERC721Receiver(to).onERC721Received.selector;
1338         } catch (bytes memory reason) {
1339             if (reason.length == 0) {
1340                 revert TransferToNonERC721ReceiverImplementer();
1341             } else {
1342                 assembly {
1343                     revert(add(32, reason), mload(reason))
1344                 }
1345             }
1346         }
1347     }
1348 
1349     /**
1350      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1351      * And also called before burning one token.
1352      *
1353      * startTokenId - the first token id to be transferred
1354      * quantity - the amount to be transferred
1355      *
1356      * Calling conditions:
1357      *
1358      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1359      * transferred to `to`.
1360      * - When `from` is zero, `tokenId` will be minted for `to`.
1361      * - When `to` is zero, `tokenId` will be burned by `from`.
1362      * - `from` and `to` are never both zero.
1363      */
1364     function _beforeTokenTransfers(
1365         address from,
1366         address to,
1367         uint256 startTokenId,
1368         uint256 quantity
1369     ) internal virtual {}
1370 
1371     /**
1372      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1373      * minting.
1374      * And also called after one token has been burned.
1375      *
1376      * startTokenId - the first token id to be transferred
1377      * quantity - the amount to be transferred
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` has been minted for `to`.
1384      * - When `to` is zero, `tokenId` has been burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _afterTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 }
1394 
1395 // File: contracts/DegenBoyz.sol
1396 
1397 pragma solidity >=0.8.9 <0.9.0;
1398 
1399 contract DegenBoyz is ERC721A, Ownable, ReentrancyGuard {
1400     using Strings for uint256;
1401 
1402     string baseURI;
1403     string public baseExtension = ".json";
1404     uint256 public price = 0.002 ether;
1405     uint256 public maxPerTx = 2;
1406     uint256 public totalFree = 400;
1407     uint256 public maxSupply = 1000;
1408     uint256 public maxPerWallet = 15;
1409     bool public paused = true;
1410     
1411     constructor(
1412     string memory _initBaseURI
1413     ) ERC721A("Degen Boyz", "DEGENBOYZ") { 
1414     setBaseURI(_initBaseURI);
1415     }
1416 
1417     function _baseURI() internal view virtual override returns (string memory) {
1418     return baseURI;
1419         }
1420 
1421     function mint(uint256 _mintAmount) external payable {
1422         uint256 cost = price;
1423         if (totalSupply() + _mintAmount < totalFree + 1) {
1424             cost = 0;
1425         }
1426 
1427         require(msg.value >= _mintAmount * cost, "Not enough ETH.");
1428         require(totalSupply() + _mintAmount < maxSupply + 1, "Exceeds supply.");
1429         require(!paused, "Minting is not live yet.");
1430         require(_mintAmount < maxPerTx + 1, "Max per TX reached.");
1431         require(_numberMinted(msg.sender) + _mintAmount <= maxPerWallet,"Too many per wallet!");
1432 
1433         _safeMint(msg.sender, _mintAmount);
1434     }
1435 
1436   function tokenURI(uint256 tokenId)
1437     public
1438     view
1439     virtual
1440     override
1441     returns (string memory)
1442   {
1443     require(
1444       _exists(tokenId),
1445       "ERC721Metadata: URI query for nonexistent token"
1446     );
1447 
1448     string memory currentBaseURI = _baseURI();
1449     return bytes(currentBaseURI).length > 0
1450         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1451         : "";
1452   }
1453 
1454     function setFreeAmount(uint256 amount) external onlyOwner {
1455         totalFree = amount;
1456     }
1457 
1458     function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
1459         maxPerWallet = _maxPerWallet;
1460     }
1461     
1462     function setMaxPerTx(uint256 _maxPerTx) public onlyOwner {
1463         maxPerTx = _maxPerTx;
1464     }
1465 
1466     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1467         maxSupply = _maxSupply;
1468     }
1469 
1470     function ownerAirdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
1471         _safeMint(_receiver, _mintAmount);
1472     }
1473 
1474     function setPrice(uint256 _newPrice) external onlyOwner {
1475         price = _newPrice;
1476     }
1477 
1478     function setPaused() public onlyOwner {
1479         paused = !paused;
1480     }
1481 
1482   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1483     baseURI = _newBaseURI;
1484   }
1485 
1486   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1487     baseExtension = _newBaseExtension;
1488   }
1489 
1490     function _startTokenId() internal view virtual override returns (uint256) {
1491         return 1;
1492     }
1493 
1494     function withdraw() external onlyOwner {
1495         uint256 balance = address(this).balance;
1496         (bool success, ) = _msgSender().call{value: balance}("");
1497         require(success, "Failed to send");
1498     }      
1499 }