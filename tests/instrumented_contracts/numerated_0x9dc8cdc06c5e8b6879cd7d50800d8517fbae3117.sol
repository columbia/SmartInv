1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4   ____        _   _   _                        _                                    
5  |  _ \      | | | | | |                      | |        /\                         
6  | |_) | __ _| |_| |_| | ___ _ __  _   _ _ __ | | __    /  \   _ __ ___ _ __   __ _ 
7  |  _ < / _` | __| __| |/ _ \ '_ \| | | | '_ \| |/ /   / /\ \ | '__/ _ \ '_ \ / _` |
8  | |_) | (_| | |_| |_| |  __/ |_) | |_| | | | |   <   / ____ \| | |  __/ | | | (_| |
9  |____/ \__,_|\__|\__|_|\___| .__/ \__,_|_| |_|_|\_\ /_/    \_\_|  \___|_| |_|\__,_|
10                             | |                                                     
11                             |_|                          
12  Official Battlepunk NFT Contract - The Founding Fathers of The Battlepunk Arena.                           
13 */
14 
15 // File: @openzeppelin/contracts/utils/Strings.sol
16 
17 
18 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev String operations.
24  */
25 library Strings {
26     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
27 
28     /**
29      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
30      */
31     function toString(uint256 value) internal pure returns (string memory) {
32         // Inspired by OraclizeAPI's implementation - MIT licence
33         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
34 
35         if (value == 0) {
36             return "0";
37         }
38         uint256 temp = value;
39         uint256 digits;
40         while (temp != 0) {
41             digits++;
42             temp /= 10;
43         }
44         bytes memory buffer = new bytes(digits);
45         while (value != 0) {
46             digits -= 1;
47             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
48             value /= 10;
49         }
50         return string(buffer);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
55      */
56     function toHexString(uint256 value) internal pure returns (string memory) {
57         if (value == 0) {
58             return "0x00";
59         }
60         uint256 temp = value;
61         uint256 length = 0;
62         while (temp != 0) {
63             length++;
64             temp >>= 8;
65         }
66         return toHexString(value, length);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
71      */
72     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
73         bytes memory buffer = new bytes(2 * length + 2);
74         buffer[0] = "0";
75         buffer[1] = "x";
76         for (uint256 i = 2 * length + 1; i > 1; --i) {
77             buffer[i] = _HEX_SYMBOLS[value & 0xf];
78             value >>= 4;
79         }
80         require(value == 0, "Strings: hex length insufficient");
81         return string(buffer);
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Context.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Provides information about the current execution context, including the
94  * sender of the transaction and its data. While these are generally available
95  * via msg.sender and msg.data, they should not be accessed in such a direct
96  * manner, since when dealing with meta-transactions the account sending and
97  * paying for execution may not be the actual sender (as far as an application
98  * is concerned).
99  *
100  * This contract is only required for intermediate, library-like contracts.
101  */
102 abstract contract Context {
103     function _msgSender() internal view virtual returns (address) {
104         return msg.sender;
105     }
106 
107     function _msgData() internal view virtual returns (bytes calldata) {
108         return msg.data;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/access/Ownable.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 abstract contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev Initializes the contract setting the deployer as the initial owner.
139      */
140     constructor() {
141         _transferOwnership(_msgSender());
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         _transferOwnership(address(0));
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Internal function without access restriction.
182      */
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/Address.sol
191 
192 
193 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Collection of functions related to the address type
199  */
200 library Address {
201     /**
202      * @dev Returns true if `account` is a contract.
203      *
204      * [IMPORTANT]
205      * ====
206      * It is unsafe to assume that an address for which this function returns
207      * false is an externally-owned account (EOA) and not a contract.
208      *
209      * Among others, `isContract` will return false for the following
210      * types of addresses:
211      *
212      *  - an externally-owned account
213      *  - a contract in construction
214      *  - an address where a contract will be created
215      *  - an address where a contract lived, but was destroyed
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize, which returns 0 for contracts in
220         // construction, since the code is only stored at the end of the
221         // constructor execution.
222 
223         uint256 size;
224         assembly {
225             size := extcodesize(account)
226         }
227         return size > 0;
228     }
229 
230     /**
231      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
232      * `recipient`, forwarding all available gas and reverting on errors.
233      *
234      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
235      * of certain opcodes, possibly making contracts go over the 2300 gas limit
236      * imposed by `transfer`, making them unable to receive funds via
237      * `transfer`. {sendValue} removes this limitation.
238      *
239      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
240      *
241      * IMPORTANT: because control is transferred to `recipient`, care must be
242      * taken to not create reentrancy vulnerabilities. Consider using
243      * {ReentrancyGuard} or the
244      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
245      */
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248 
249         (bool success, ) = recipient.call{value: amount}("");
250         require(success, "Address: unable to send value, recipient may have reverted");
251     }
252 
253     /**
254      * @dev Performs a Solidity function call using a low level `call`. A
255      * plain `call` is an unsafe replacement for a function call: use this
256      * function instead.
257      *
258      * If `target` reverts with a revert reason, it is bubbled up by this
259      * function (like regular Solidity function calls).
260      *
261      * Returns the raw returned data. To convert to the expected return value,
262      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
263      *
264      * Requirements:
265      *
266      * - `target` must be a contract.
267      * - calling `target` with `data` must not revert.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionCall(target, data, "Address: low-level call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
277      * `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, 0, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but also transferring `value` wei to `target`.
292      *
293      * Requirements:
294      *
295      * - the calling contract must have an ETH balance of at least `value`.
296      * - the called Solidity function must be `payable`.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
310      * with `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         require(address(this).balance >= value, "Address: insufficient balance for call");
321         require(isContract(target), "Address: call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.call{value: value}(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
334         return functionStaticCall(target, data, "Address: low-level static call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal view returns (bytes memory) {
348         require(isContract(target), "Address: static call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.staticcall(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(isContract(target), "Address: delegate call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.delegatecall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
383      * revert reason using the provided one.
384      *
385      * _Available since v4.3._
386      */
387     function verifyCallResult(
388         bool success,
389         bytes memory returndata,
390         string memory errorMessage
391     ) internal pure returns (bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
411 
412 
413 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 /**
418  * @title ERC721 token receiver interface
419  * @dev Interface for any contract that wants to support safeTransfers
420  * from ERC721 asset contracts.
421  */
422 interface IERC721Receiver {
423     /**
424      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
425      * by `operator` from `from`, this function is called.
426      *
427      * It must return its Solidity selector to confirm the token transfer.
428      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
429      *
430      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
431      */
432     function onERC721Received(
433         address operator,
434         address from,
435         uint256 tokenId,
436         bytes calldata data
437     ) external returns (bytes4);
438 }
439 
440 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @dev Interface of the ERC165 standard, as defined in the
449  * https://eips.ethereum.org/EIPS/eip-165[EIP].
450  *
451  * Implementers can declare support of contract interfaces, which can then be
452  * queried by others ({ERC165Checker}).
453  *
454  * For an implementation, see {ERC165}.
455  */
456 interface IERC165 {
457     /**
458      * @dev Returns true if this contract implements the interface defined by
459      * `interfaceId`. See the corresponding
460      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
461      * to learn more about how these ids are created.
462      *
463      * This function call must use less than 30 000 gas.
464      */
465     function supportsInterface(bytes4 interfaceId) external view returns (bool);
466 }
467 
468 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 
476 /**
477  * @dev Implementation of the {IERC165} interface.
478  *
479  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
480  * for the additional interface id that will be supported. For example:
481  *
482  * ```solidity
483  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
485  * }
486  * ```
487  *
488  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
489  */
490 abstract contract ERC165 is IERC165 {
491     /**
492      * @dev See {IERC165-supportsInterface}.
493      */
494     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
495         return interfaceId == type(IERC165).interfaceId;
496     }
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 
507 /**
508  * @dev Required interface of an ERC721 compliant contract.
509  */
510 interface IERC721 is IERC165 {
511     /**
512      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
513      */
514     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
515 
516     /**
517      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
518      */
519     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
523      */
524     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
525 
526     /**
527      * @dev Returns the number of tokens in ``owner``'s account.
528      */
529     function balanceOf(address owner) external view returns (uint256 balance);
530 
531     /**
532      * @dev Returns the owner of the `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function ownerOf(uint256 tokenId) external view returns (address owner);
539 
540     /**
541      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
542      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId
558     ) external;
559 
560     /**
561      * @dev Transfers `tokenId` token from `from` to `to`.
562      *
563      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must be owned by `from`.
570      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
571      *
572      * Emits a {Transfer} event.
573      */
574     function transferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external;
579 
580     /**
581      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
582      * The approval is cleared when the token is transferred.
583      *
584      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
585      *
586      * Requirements:
587      *
588      * - The caller must own the token or be an approved operator.
589      * - `tokenId` must exist.
590      *
591      * Emits an {Approval} event.
592      */
593     function approve(address to, uint256 tokenId) external;
594 
595     /**
596      * @dev Returns the account approved for `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function getApproved(uint256 tokenId) external view returns (address operator);
603 
604     /**
605      * @dev Approve or remove `operator` as an operator for the caller.
606      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
607      *
608      * Requirements:
609      *
610      * - The `operator` cannot be the caller.
611      *
612      * Emits an {ApprovalForAll} event.
613      */
614     function setApprovalForAll(address operator, bool _approved) external;
615 
616     /**
617      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
618      *
619      * See {setApprovalForAll}
620      */
621     function isApprovedForAll(address owner, address operator) external view returns (bool);
622 
623     /**
624      * @dev Safely transfers `tokenId` token from `from` to `to`.
625      *
626      * Requirements:
627      *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630      * - `tokenId` token must exist and be owned by `from`.
631      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
632      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
633      *
634      * Emits a {Transfer} event.
635      */
636     function safeTransferFrom(
637         address from,
638         address to,
639         uint256 tokenId,
640         bytes calldata data
641     ) external;
642 }
643 
644 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
645 
646 
647 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
648 
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
654  * @dev See https://eips.ethereum.org/EIPS/eip-721
655  */
656 interface IERC721Enumerable is IERC721 {
657     /**
658      * @dev Returns the total amount of tokens stored by the contract.
659      */
660     function totalSupply() external view returns (uint256);
661 
662     /**
663      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
664      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
665      */
666     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
667 
668     /**
669      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
670      * Use along with {totalSupply} to enumerate all tokens.
671      */
672     function tokenByIndex(uint256 index) external view returns (uint256);
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
685  * @dev See https://eips.ethereum.org/EIPS/eip-721
686  */
687 interface IERC721Metadata is IERC721 {
688     /**
689      * @dev Returns the token collection name.
690      */
691     function name() external view returns (string memory);
692 
693     /**
694      * @dev Returns the token collection symbol.
695      */
696     function symbol() external view returns (string memory);
697 
698     /**
699      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
700      */
701     function tokenURI(uint256 tokenId) external view returns (string memory);
702 }
703 
704 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
705 
706 
707 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 
712 
713 
714 
715 
716 
717 
718 /**
719  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
720  * the Metadata extension, but not including the Enumerable extension, which is available separately as
721  * {ERC721Enumerable}.
722  */
723 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
724     using Address for address;
725     using Strings for uint256;
726 
727     // Token name
728     string private _name;
729 
730     // Token symbol
731     string private _symbol;
732 
733     // Mapping from token ID to owner address
734     mapping(uint256 => address) private _owners;
735 
736     // Mapping owner address to token count
737     mapping(address => uint256) private _balances;
738 
739     // Mapping from token ID to approved address
740     mapping(uint256 => address) private _tokenApprovals;
741 
742     // Mapping from owner to operator approvals
743     mapping(address => mapping(address => bool)) private _operatorApprovals;
744 
745     /**
746      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
747      */
748     constructor(string memory name_, string memory symbol_) {
749         _name = name_;
750         _symbol = symbol_;
751     }
752 
753     /**
754      * @dev See {IERC165-supportsInterface}.
755      */
756     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
757         return
758             interfaceId == type(IERC721).interfaceId ||
759             interfaceId == type(IERC721Metadata).interfaceId ||
760             super.supportsInterface(interfaceId);
761     }
762 
763     /**
764      * @dev See {IERC721-balanceOf}.
765      */
766     function balanceOf(address owner) public view virtual override returns (uint256) {
767         require(owner != address(0), "ERC721: balance query for the zero address");
768         return _balances[owner];
769     }
770 
771     /**
772      * @dev See {IERC721-ownerOf}.
773      */
774     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
775         address owner = _owners[tokenId];
776         require(owner != address(0), "ERC721: owner query for nonexistent token");
777         return owner;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-name}.
782      */
783     function name() public view virtual override returns (string memory) {
784         return _name;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-symbol}.
789      */
790     function symbol() public view virtual override returns (string memory) {
791         return _symbol;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-tokenURI}.
796      */
797     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
798         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
799 
800         string memory baseURI = _baseURI();
801         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
802     }
803 
804     /**
805      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
806      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
807      * by default, can be overriden in child contracts.
808      */
809     function _baseURI() internal view virtual returns (string memory) {
810         return "";
811     }
812 
813     /**
814      * @dev See {IERC721-approve}.
815      */
816     function approve(address to, uint256 tokenId) public virtual override {
817         address owner = ERC721.ownerOf(tokenId);
818         require(to != owner, "ERC721: approval to current owner");
819 
820         require(
821             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
822             "ERC721: approve caller is not owner nor approved for all"
823         );
824 
825         _approve(to, tokenId);
826     }
827 
828     /**
829      * @dev See {IERC721-getApproved}.
830      */
831     function getApproved(uint256 tokenId) public view virtual override returns (address) {
832         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
833 
834         return _tokenApprovals[tokenId];
835     }
836 
837     /**
838      * @dev See {IERC721-setApprovalForAll}.
839      */
840     function setApprovalForAll(address operator, bool approved) public virtual override {
841         _setApprovalForAll(_msgSender(), operator, approved);
842     }
843 
844     /**
845      * @dev See {IERC721-isApprovedForAll}.
846      */
847     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
848         return _operatorApprovals[owner][operator];
849     }
850 
851     /**
852      * @dev See {IERC721-transferFrom}.
853      */
854     function transferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) public virtual override {
859         //solhint-disable-next-line max-line-length
860         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
861 
862         _transfer(from, to, tokenId);
863     }
864 
865     /**
866      * @dev See {IERC721-safeTransferFrom}.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public virtual override {
873         safeTransferFrom(from, to, tokenId, "");
874     }
875 
876     /**
877      * @dev See {IERC721-safeTransferFrom}.
878      */
879     function safeTransferFrom(
880         address from,
881         address to,
882         uint256 tokenId,
883         bytes memory _data
884     ) public virtual override {
885         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
886         _safeTransfer(from, to, tokenId, _data);
887     }
888 
889     /**
890      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
891      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
892      *
893      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
894      *
895      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
896      * implement alternative mechanisms to perform token transfer, such as signature-based.
897      *
898      * Requirements:
899      *
900      * - `from` cannot be the zero address.
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must exist and be owned by `from`.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeTransfer(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) internal virtual {
913         _transfer(from, to, tokenId);
914         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
915     }
916 
917     /**
918      * @dev Returns whether `tokenId` exists.
919      *
920      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
921      *
922      * Tokens start existing when they are minted (`_mint`),
923      * and stop existing when they are burned (`_burn`).
924      */
925     function _exists(uint256 tokenId) internal view virtual returns (bool) {
926         return _owners[tokenId] != address(0);
927     }
928 
929     /**
930      * @dev Returns whether `spender` is allowed to manage `tokenId`.
931      *
932      * Requirements:
933      *
934      * - `tokenId` must exist.
935      */
936     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
937         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
938         address owner = ERC721.ownerOf(tokenId);
939         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
940     }
941 
942     /**
943      * @dev Safely mints `tokenId` and transfers it to `to`.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must not exist.
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeMint(address to, uint256 tokenId) internal virtual {
953         _safeMint(to, tokenId, "");
954     }
955 
956     /**
957      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
958      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
959      */
960     function _safeMint(
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) internal virtual {
965         _mint(to, tokenId);
966         require(
967             _checkOnERC721Received(address(0), to, tokenId, _data),
968             "ERC721: transfer to non ERC721Receiver implementer"
969         );
970     }
971 
972     /**
973      * @dev Mints `tokenId` and transfers it to `to`.
974      *
975      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - `to` cannot be the zero address.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(address to, uint256 tokenId) internal virtual {
985         require(to != address(0), "ERC721: mint to the zero address");
986         require(!_exists(tokenId), "ERC721: token already minted");
987 
988         _beforeTokenTransfer(address(0), to, tokenId);
989 
990         _balances[to] += 1;
991         _owners[tokenId] = to;
992 
993         emit Transfer(address(0), to, tokenId);
994     }
995 
996     /**
997      * @dev Destroys `tokenId`.
998      * The approval is cleared when the token is burned.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _burn(uint256 tokenId) internal virtual {
1007         address owner = ERC721.ownerOf(tokenId);
1008 
1009         _beforeTokenTransfer(owner, address(0), tokenId);
1010 
1011         // Clear approvals
1012         _approve(address(0), tokenId);
1013 
1014         _balances[owner] -= 1;
1015         delete _owners[tokenId];
1016 
1017         emit Transfer(owner, address(0), tokenId);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual {
1036         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1037         require(to != address(0), "ERC721: transfer to the zero address");
1038 
1039         _beforeTokenTransfer(from, to, tokenId);
1040 
1041         // Clear approvals from the previous owner
1042         _approve(address(0), tokenId);
1043 
1044         _balances[from] -= 1;
1045         _balances[to] += 1;
1046         _owners[tokenId] = to;
1047 
1048         emit Transfer(from, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Approve `to` to operate on `tokenId`
1053      *
1054      * Emits a {Approval} event.
1055      */
1056     function _approve(address to, uint256 tokenId) internal virtual {
1057         _tokenApprovals[tokenId] = to;
1058         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Approve `operator` to operate on all of `owner` tokens
1063      *
1064      * Emits a {ApprovalForAll} event.
1065      */
1066     function _setApprovalForAll(
1067         address owner,
1068         address operator,
1069         bool approved
1070     ) internal virtual {
1071         require(owner != operator, "ERC721: approve to caller");
1072         _operatorApprovals[owner][operator] = approved;
1073         emit ApprovalForAll(owner, operator, approved);
1074     }
1075 
1076     /**
1077      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1078      * The call is not executed if the target address is not a contract.
1079      *
1080      * @param from address representing the previous owner of the given token ID
1081      * @param to target address that will receive the tokens
1082      * @param tokenId uint256 ID of the token to be transferred
1083      * @param _data bytes optional data to send along with the call
1084      * @return bool whether the call correctly returned the expected magic value
1085      */
1086     function _checkOnERC721Received(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes memory _data
1091     ) private returns (bool) {
1092         if (to.isContract()) {
1093             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1094                 return retval == IERC721Receiver.onERC721Received.selector;
1095             } catch (bytes memory reason) {
1096                 if (reason.length == 0) {
1097                     revert("ERC721: transfer to non ERC721Receiver implementer");
1098                 } else {
1099                     assembly {
1100                         revert(add(32, reason), mload(reason))
1101                     }
1102                 }
1103             }
1104         } else {
1105             return true;
1106         }
1107     }
1108 
1109     /**
1110      * @dev Hook that is called before any token transfer. This includes minting
1111      * and burning.
1112      *
1113      * Calling conditions:
1114      *
1115      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1116      * transferred to `to`.
1117      * - When `from` is zero, `tokenId` will be minted for `to`.
1118      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1119      * - `from` and `to` are never both zero.
1120      *
1121      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1122      */
1123     function _beforeTokenTransfer(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) internal virtual {}
1128 }
1129 
1130 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1131 
1132 
1133 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 
1138 
1139 /**
1140  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1141  * enumerability of all the token ids in the contract as well as all token ids owned by each
1142  * account.
1143  */
1144 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1145     // Mapping from owner to list of owned token IDs
1146     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1147 
1148     // Mapping from token ID to index of the owner tokens list
1149     mapping(uint256 => uint256) private _ownedTokensIndex;
1150 
1151     // Array with all token ids, used for enumeration
1152     uint256[] private _allTokens;
1153 
1154     // Mapping from token id to position in the allTokens array
1155     mapping(uint256 => uint256) private _allTokensIndex;
1156 
1157     /**
1158      * @dev See {IERC165-supportsInterface}.
1159      */
1160     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1161         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1166      */
1167     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1168         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1169         return _ownedTokens[owner][index];
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Enumerable-totalSupply}.
1174      */
1175     function totalSupply() public view virtual override returns (uint256) {
1176         return _allTokens.length;
1177     }
1178 
1179     /**
1180      * @dev See {IERC721Enumerable-tokenByIndex}.
1181      */
1182     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1183         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1184         return _allTokens[index];
1185     }
1186 
1187     /**
1188      * @dev Hook that is called before any token transfer. This includes minting
1189      * and burning.
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` will be minted for `to`.
1196      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1197      * - `from` cannot be the zero address.
1198      * - `to` cannot be the zero address.
1199      *
1200      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1201      */
1202     function _beforeTokenTransfer(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) internal virtual override {
1207         super._beforeTokenTransfer(from, to, tokenId);
1208 
1209         if (from == address(0)) {
1210             _addTokenToAllTokensEnumeration(tokenId);
1211         } else if (from != to) {
1212             _removeTokenFromOwnerEnumeration(from, tokenId);
1213         }
1214         if (to == address(0)) {
1215             _removeTokenFromAllTokensEnumeration(tokenId);
1216         } else if (to != from) {
1217             _addTokenToOwnerEnumeration(to, tokenId);
1218         }
1219     }
1220 
1221     /**
1222      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1223      * @param to address representing the new owner of the given token ID
1224      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1225      */
1226     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1227         uint256 length = ERC721.balanceOf(to);
1228         _ownedTokens[to][length] = tokenId;
1229         _ownedTokensIndex[tokenId] = length;
1230     }
1231 
1232     /**
1233      * @dev Private function to add a token to this extension's token tracking data structures.
1234      * @param tokenId uint256 ID of the token to be added to the tokens list
1235      */
1236     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1237         _allTokensIndex[tokenId] = _allTokens.length;
1238         _allTokens.push(tokenId);
1239     }
1240 
1241     /**
1242      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1243      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1244      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1245      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1246      * @param from address representing the previous owner of the given token ID
1247      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1248      */
1249     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1250         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1251         // then delete the last slot (swap and pop).
1252 
1253         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1254         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1255 
1256         // When the token to delete is the last token, the swap operation is unnecessary
1257         if (tokenIndex != lastTokenIndex) {
1258             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1259 
1260             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1261             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1262         }
1263 
1264         // This also deletes the contents at the last position of the array
1265         delete _ownedTokensIndex[tokenId];
1266         delete _ownedTokens[from][lastTokenIndex];
1267     }
1268 
1269     /**
1270      * @dev Private function to remove a token from this extension's token tracking data structures.
1271      * This has O(1) time complexity, but alters the order of the _allTokens array.
1272      * @param tokenId uint256 ID of the token to be removed from the tokens list
1273      */
1274     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1275         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1276         // then delete the last slot (swap and pop).
1277 
1278         uint256 lastTokenIndex = _allTokens.length - 1;
1279         uint256 tokenIndex = _allTokensIndex[tokenId];
1280 
1281         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1282         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1283         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1284         uint256 lastTokenId = _allTokens[lastTokenIndex];
1285 
1286         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1287         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1288 
1289         // This also deletes the contents at the last position of the array
1290         delete _allTokensIndex[tokenId];
1291         _allTokens.pop();
1292     }
1293 }
1294 
1295 // File: contracts/BattlepunkNFT.sol
1296 
1297 
1298 
1299 pragma solidity >=0.7.0 <0.9.0;
1300 
1301 
1302 
1303 contract NFT is ERC721Enumerable, Ownable {
1304   using Strings for uint256;
1305 
1306   string public baseURI;
1307   string public baseExtension = ".json";
1308   string public notRevealedUri;
1309   uint256 public cost = 0.07 ether;
1310   uint256 public maxSupply = 10000;
1311   uint256 public maxMintAmount = 10;
1312   uint256 public nftPerAddressLimit = 20;
1313   bool public paused = false;
1314   bool public revealed = false;
1315   bool public onlyWhitelisted = true;
1316   address[] public whitelistedAddresses;
1317   mapping(address => uint256) public addressMintedBalance;
1318 
1319 
1320   constructor(
1321     string memory _name,
1322     string memory _symbol,
1323     string memory _initBaseURI,
1324     string memory _initNotRevealedUri
1325   ) ERC721(_name, _symbol) {
1326     setBaseURI(_initBaseURI);
1327     setNotRevealedURI(_initNotRevealedUri);
1328   }
1329 
1330   // internal
1331   function _baseURI() internal view virtual override returns (string memory) {
1332     return baseURI;
1333   }
1334 
1335   // public
1336   function mint(uint256 _mintAmount) public payable {
1337     require(!paused, "the contract is paused");
1338     uint256 supply = totalSupply();
1339     require(_mintAmount > 0, "need to mint at least 1 NFT");
1340     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1341     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1342 
1343     if (msg.sender != owner()) {
1344         if(onlyWhitelisted == true) {
1345             require(isWhitelisted(msg.sender), "user is not whitelisted");
1346             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1347             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1348         }
1349         require(msg.value >= cost * _mintAmount, "insufficient funds");
1350     }
1351     
1352     for (uint256 i = 1; i <= _mintAmount; i++) {
1353         addressMintedBalance[msg.sender]++;
1354       _safeMint(msg.sender, supply + i);
1355     }
1356   }
1357   
1358   function isWhitelisted(address _user) public view returns (bool) {
1359     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1360       if (whitelistedAddresses[i] == _user) {
1361           return true;
1362       }
1363     }
1364     return false;
1365   }
1366 
1367   function walletOfOwner(address _owner)
1368     public
1369     view
1370     returns (uint256[] memory)
1371   {
1372     uint256 ownerTokenCount = balanceOf(_owner);
1373     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1374     for (uint256 i; i < ownerTokenCount; i++) {
1375       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1376     }
1377     return tokenIds;
1378   }
1379 
1380    function tokenURI(uint256 tokenId)
1381     public
1382     view
1383     virtual
1384     override
1385     returns (string memory)
1386   {
1387     require(
1388       _exists(tokenId),
1389       "ERC721Metadata: URI query for nonexistent token"
1390     );
1391     
1392     if(revealed == false) {
1393         return notRevealedUri;
1394     }
1395 
1396     string memory currentBaseURI = _baseURI();
1397     return bytes(currentBaseURI).length > 0
1398         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1399         : "";
1400   }
1401 
1402   //only owner
1403   function reveal() public onlyOwner {
1404       revealed = true;
1405   }
1406   
1407   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1408     nftPerAddressLimit = _limit;
1409   }
1410   
1411   function setCost(uint256 _newCost) public onlyOwner {
1412     cost = _newCost;
1413   }
1414 
1415   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1416     maxMintAmount = _newmaxMintAmount;
1417   }
1418 
1419   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1420     baseURI = _newBaseURI;
1421   }
1422 
1423   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1424     baseExtension = _newBaseExtension;
1425   }
1426   
1427   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1428     notRevealedUri = _notRevealedURI;
1429   }
1430 
1431   function pause(bool _state) public onlyOwner {
1432     paused = _state;
1433   }
1434   
1435   function setOnlyWhitelisted(bool _state) public onlyOwner {
1436     onlyWhitelisted = _state;
1437   }
1438 
1439   function addWhiteListUser(address _user) public onlyOwner {
1440     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1441       if (whitelistedAddresses[i] == _user) {
1442           return;
1443       }
1444     }
1445     whitelistedAddresses.push(_user);
1446   }
1447 
1448   function removeWhiteListUser(address _user) public onlyOwner {
1449     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1450       if (whitelistedAddresses[i] == _user) {
1451         delete whitelistedAddresses[i];
1452       }
1453     }
1454   }
1455   
1456   function whitelistUsers(address[] calldata _users) public onlyOwner {
1457     delete whitelistedAddresses;
1458     whitelistedAddresses = _users;
1459   }
1460  
1461   function withdraw() public payable onlyOwner {
1462     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1463     require(os);
1464   }
1465 }