1 // SPDX-License-Identifier: MIT
2 
3 /*
4 _     _____ _____ ___________  ___   _       _____  _____ _   _ ___________   _____   ___  ___  ___ _____ 
5 | |   |_   _|_   _|  ___| ___ \/ _ \ | |     /  ___||  _  | | | |_   _|  _  \ |  __ \ / _ \ |  \/  ||  ___|
6 | |     | |   | | | |__ | |_/ / /_\ \| |     \ `--. | | | | | | | | | | | | | | |  \// /_\ \| .  . || |__  
7 | |     | |   | | |  __||    /|  _  || |      `--. \| | | | | | | | | | | | | | | __ |  _  || |\/| ||  __| 
8 | |_____| |_  | | | |___| |\ \| | | || |____ /\__/ /\ \/' / |_| |_| |_| |/ /  | |_\ \| | | || |  | || |___ 
9 \_____/\___/  \_/ \____/\_| \_\_| |_/\_____/ \____/  \_/\_\\___/ \___/|___/    \____/\_| |_/\_|  |_/\____/ 
10                                                                                                            
11                                                                                                            
12 */
13 
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
87 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
114 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
192 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
193 
194 pragma solidity ^0.8.0;
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
216      */
217     function isContract(address account) internal view returns (bool) {
218         // This method relies on extcodesize, which returns 0 for contracts in
219         // construction, since the code is only stored at the end of the
220         // constructor execution.
221 
222         uint256 size;
223         assembly {
224             size := extcodesize(account)
225         }
226         return size > 0;
227     }
228 
229     /**
230      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
231      * `recipient`, forwarding all available gas and reverting on errors.
232      *
233      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
234      * of certain opcodes, possibly making contracts go over the 2300 gas limit
235      * imposed by `transfer`, making them unable to receive funds via
236      * `transfer`. {sendValue} removes this limitation.
237      *
238      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
239      *
240      * IMPORTANT: because control is transferred to `recipient`, care must be
241      * taken to not create reentrancy vulnerabilities. Consider using
242      * {ReentrancyGuard} or the
243      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
244      */
245     function sendValue(address payable recipient, uint256 amount) internal {
246         require(address(this).balance >= amount, "Address: insufficient balance");
247 
248         (bool success, ) = recipient.call{value: amount}("");
249         require(success, "Address: unable to send value, recipient may have reverted");
250     }
251 
252     /**
253      * @dev Performs a Solidity function call using a low level `call`. A
254      * plain `call` is an unsafe replacement for a function call: use this
255      * function instead.
256      *
257      * If `target` reverts with a revert reason, it is bubbled up by this
258      * function (like regular Solidity function calls).
259      *
260      * Returns the raw returned data. To convert to the expected return value,
261      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
262      *
263      * Requirements:
264      *
265      * - `target` must be a contract.
266      * - calling `target` with `data` must not revert.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionCall(target, data, "Address: low-level call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
276      * `errorMessage` as a fallback revert reason when `target` reverts.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, 0, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but also transferring `value` wei to `target`.
291      *
292      * Requirements:
293      *
294      * - the calling contract must have an ETH balance of at least `value`.
295      * - the called Solidity function must be `payable`.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value
303     ) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
309      * with `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         require(address(this).balance >= value, "Address: insufficient balance for call");
320         require(isContract(target), "Address: call to non-contract");
321 
322         (bool success, bytes memory returndata) = target.call{value: value}(data);
323         return verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
333         return functionStaticCall(target, data, "Address: low-level static call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal view returns (bytes memory) {
347         require(isContract(target), "Address: static call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.staticcall(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(isContract(target), "Address: delegate call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
382      * revert reason using the provided one.
383      *
384      * _Available since v4.3._
385      */
386     function verifyCallResult(
387         bool success,
388         bytes memory returndata,
389         string memory errorMessage
390     ) internal pure returns (bytes memory) {
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
410 
411 
412 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 /**
417  * @title ERC721 token receiver interface
418  * @dev Interface for any contract that wants to support safeTransfers
419  * from ERC721 asset contracts.
420  */
421 interface IERC721Receiver {
422     /**
423      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
424      * by `operator` from `from`, this function is called.
425      *
426      * It must return its Solidity selector to confirm the token transfer.
427      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
428      *
429      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
430      */
431     function onERC721Received(
432         address operator,
433         address from,
434         uint256 tokenId,
435         bytes calldata data
436     ) external returns (bytes4);
437 }
438 
439 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Interface of the ERC165 standard, as defined in the
448  * https://eips.ethereum.org/EIPS/eip-165[EIP].
449  *
450  * Implementers can declare support of contract interfaces, which can then be
451  * queried by others ({ERC165Checker}).
452  *
453  * For an implementation, see {ERC165}.
454  */
455 interface IERC165 {
456     /**
457      * @dev Returns true if this contract implements the interface defined by
458      * `interfaceId`. See the corresponding
459      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
460      * to learn more about how these ids are created.
461      *
462      * This function call must use less than 30 000 gas.
463      */
464     function supportsInterface(bytes4 interfaceId) external view returns (bool);
465 }
466 
467 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 
475 /**
476  * @dev Implementation of the {IERC165} interface.
477  *
478  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
479  * for the additional interface id that will be supported. For example:
480  *
481  * ```solidity
482  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
484  * }
485  * ```
486  *
487  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
488  */
489 abstract contract ERC165 is IERC165 {
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494         return interfaceId == type(IERC165).interfaceId;
495     }
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 
506 /**
507  * @dev Required interface of an ERC721 compliant contract.
508  */
509 interface IERC721 is IERC165 {
510     /**
511      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
512      */
513     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
514 
515     /**
516      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
517      */
518     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
519 
520     /**
521      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
522      */
523     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
524 
525     /**
526      * @dev Returns the number of tokens in ``owner``'s account.
527      */
528     function balanceOf(address owner) external view returns (uint256 balance);
529 
530     /**
531      * @dev Returns the owner of the `tokenId` token.
532      *
533      * Requirements:
534      *
535      * - `tokenId` must exist.
536      */
537     function ownerOf(uint256 tokenId) external view returns (address owner);
538 
539     /**
540      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
541      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must exist and be owned by `from`.
548      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
550      *
551      * Emits a {Transfer} event.
552      */
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId
557     ) external;
558 
559     /**
560      * @dev Transfers `tokenId` token from `from` to `to`.
561      *
562      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must be owned by `from`.
569      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570      *
571      * Emits a {Transfer} event.
572      */
573     function transferFrom(
574         address from,
575         address to,
576         uint256 tokenId
577     ) external;
578 
579     /**
580      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
581      * The approval is cleared when the token is transferred.
582      *
583      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
584      *
585      * Requirements:
586      *
587      * - The caller must own the token or be an approved operator.
588      * - `tokenId` must exist.
589      *
590      * Emits an {Approval} event.
591      */
592     function approve(address to, uint256 tokenId) external;
593 
594     /**
595      * @dev Returns the account approved for `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function getApproved(uint256 tokenId) external view returns (address operator);
602 
603     /**
604      * @dev Approve or remove `operator` as an operator for the caller.
605      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
606      *
607      * Requirements:
608      *
609      * - The `operator` cannot be the caller.
610      *
611      * Emits an {ApprovalForAll} event.
612      */
613     function setApprovalForAll(address operator, bool _approved) external;
614 
615     /**
616      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
617      *
618      * See {setApprovalForAll}
619      */
620     function isApprovedForAll(address owner, address operator) external view returns (bool);
621 
622     /**
623      * @dev Safely transfers `tokenId` token from `from` to `to`.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must exist and be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
632      *
633      * Emits a {Transfer} event.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId,
639         bytes calldata data
640     ) external;
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
644 
645 
646 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 
651 /**
652  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
653  * @dev See https://eips.ethereum.org/EIPS/eip-721
654  */
655 interface IERC721Metadata is IERC721 {
656     /**
657      * @dev Returns the token collection name.
658      */
659     function name() external view returns (string memory);
660 
661     /**
662      * @dev Returns the token collection symbol.
663      */
664     function symbol() external view returns (string memory);
665 
666     /**
667      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
668      */
669     function tokenURI(uint256 tokenId) external view returns (string memory);
670 }
671 
672 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
673 
674 
675 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 
680 
681 
682 
683 
684 
685 
686 /**
687  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
688  * the Metadata extension, but not including the Enumerable extension, which is available separately as
689  * {ERC721Enumerable}.
690  */
691 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
692     using Address for address;
693     using Strings for uint256;
694 
695     // Token name
696     string private _name;
697 
698     // Token symbol
699     string private _symbol;
700 
701     // Mapping from token ID to owner address
702     mapping(uint256 => address) private _owners;
703 
704     // Mapping owner address to token count
705     mapping(address => uint256) private _balances;
706 
707     // Mapping from token ID to approved address
708     mapping(uint256 => address) private _tokenApprovals;
709 
710     // Mapping from owner to operator approvals
711     mapping(address => mapping(address => bool)) private _operatorApprovals;
712 
713     /**
714      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
715      */
716     constructor(string memory name_, string memory symbol_) {
717         _name = name_;
718         _symbol = symbol_;
719     }
720 
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
725         return
726             interfaceId == type(IERC721).interfaceId ||
727             interfaceId == type(IERC721Metadata).interfaceId ||
728             super.supportsInterface(interfaceId);
729     }
730 
731     /**
732      * @dev See {IERC721-balanceOf}.
733      */
734     function balanceOf(address owner) public view virtual override returns (uint256) {
735         require(owner != address(0), "ERC721: balance query for the zero address");
736         return _balances[owner];
737     }
738 
739     /**
740      * @dev See {IERC721-ownerOf}.
741      */
742     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
743         address owner = _owners[tokenId];
744         require(owner != address(0), "ERC721: owner query for nonexistent token");
745         return owner;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-name}.
750      */
751     function name() public view virtual override returns (string memory) {
752         return _name;
753     }
754 
755     /**
756      * @dev See {IERC721Metadata-symbol}.
757      */
758     function symbol() public view virtual override returns (string memory) {
759         return _symbol;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-tokenURI}.
764      */
765     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
766         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
767 
768         string memory baseURI = _baseURI();
769         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
770     }
771 
772     /**
773      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
774      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
775      * by default, can be overriden in child contracts.
776      */
777     function _baseURI() internal view virtual returns (string memory) {
778         return "";
779     }
780 
781     /**
782      * @dev See {IERC721-approve}.
783      */
784     function approve(address to, uint256 tokenId) public virtual override {
785         address owner = ERC721.ownerOf(tokenId);
786         require(to != owner, "ERC721: approval to current owner");
787 
788         require(
789             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
790             "ERC721: approve caller is not owner nor approved for all"
791         );
792 
793         _approve(to, tokenId);
794     }
795 
796     /**
797      * @dev See {IERC721-getApproved}.
798      */
799     function getApproved(uint256 tokenId) public view virtual override returns (address) {
800         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
801 
802         return _tokenApprovals[tokenId];
803     }
804 
805     /**
806      * @dev See {IERC721-setApprovalForAll}.
807      */
808     function setApprovalForAll(address operator, bool approved) public virtual override {
809         _setApprovalForAll(_msgSender(), operator, approved);
810     }
811 
812     /**
813      * @dev See {IERC721-isApprovedForAll}.
814      */
815     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
816         return _operatorApprovals[owner][operator];
817     }
818 
819     /**
820      * @dev See {IERC721-transferFrom}.
821      */
822     function transferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) public virtual override {
827         //solhint-disable-next-line max-line-length
828         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
829 
830         _transfer(from, to, tokenId);
831     }
832 
833     /**
834      * @dev See {IERC721-safeTransferFrom}.
835      */
836     function safeTransferFrom(
837         address from,
838         address to,
839         uint256 tokenId
840     ) public virtual override {
841         safeTransferFrom(from, to, tokenId, "");
842     }
843 
844     /**
845      * @dev See {IERC721-safeTransferFrom}.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) public virtual override {
853         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
854         _safeTransfer(from, to, tokenId, _data);
855     }
856 
857     /**
858      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
859      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
860      *
861      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
862      *
863      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
864      * implement alternative mechanisms to perform token transfer, such as signature-based.
865      *
866      * Requirements:
867      *
868      * - `from` cannot be the zero address.
869      * - `to` cannot be the zero address.
870      * - `tokenId` token must exist and be owned by `from`.
871      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _safeTransfer(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) internal virtual {
881         _transfer(from, to, tokenId);
882         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
883     }
884 
885     /**
886      * @dev Returns whether `tokenId` exists.
887      *
888      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
889      *
890      * Tokens start existing when they are minted (`_mint`),
891      * and stop existing when they are burned (`_burn`).
892      */
893     function _exists(uint256 tokenId) internal view virtual returns (bool) {
894         return _owners[tokenId] != address(0);
895     }
896 
897     /**
898      * @dev Returns whether `spender` is allowed to manage `tokenId`.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      */
904     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
905         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
906         address owner = ERC721.ownerOf(tokenId);
907         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
908     }
909 
910     /**
911      * @dev Safely mints `tokenId` and transfers it to `to`.
912      *
913      * Requirements:
914      *
915      * - `tokenId` must not exist.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _safeMint(address to, uint256 tokenId) internal virtual {
921         _safeMint(to, tokenId, "");
922     }
923 
924     /**
925      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
926      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
927      */
928     function _safeMint(
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _mint(to, tokenId);
934         require(
935             _checkOnERC721Received(address(0), to, tokenId, _data),
936             "ERC721: transfer to non ERC721Receiver implementer"
937         );
938     }
939 
940     /**
941      * @dev Mints `tokenId` and transfers it to `to`.
942      *
943      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
944      *
945      * Requirements:
946      *
947      * - `tokenId` must not exist.
948      * - `to` cannot be the zero address.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _mint(address to, uint256 tokenId) internal virtual {
953         require(to != address(0), "ERC721: mint to the zero address");
954         require(!_exists(tokenId), "ERC721: token already minted");
955 
956         _beforeTokenTransfer(address(0), to, tokenId);
957 
958         _balances[to] += 1;
959         _owners[tokenId] = to;
960 
961         emit Transfer(address(0), to, tokenId);
962     }
963 
964     /**
965      * @dev Destroys `tokenId`.
966      * The approval is cleared when the token is burned.
967      *
968      * Requirements:
969      *
970      * - `tokenId` must exist.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _burn(uint256 tokenId) internal virtual {
975         address owner = ERC721.ownerOf(tokenId);
976 
977         _beforeTokenTransfer(owner, address(0), tokenId);
978 
979         // Clear approvals
980         _approve(address(0), tokenId);
981 
982         _balances[owner] -= 1;
983         delete _owners[tokenId];
984 
985         emit Transfer(owner, address(0), tokenId);
986     }
987 
988     /**
989      * @dev Transfers `tokenId` from `from` to `to`.
990      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
991      *
992      * Requirements:
993      *
994      * - `to` cannot be the zero address.
995      * - `tokenId` token must be owned by `from`.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _transfer(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) internal virtual {
1004         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1005         require(to != address(0), "ERC721: transfer to the zero address");
1006 
1007         _beforeTokenTransfer(from, to, tokenId);
1008 
1009         // Clear approvals from the previous owner
1010         _approve(address(0), tokenId);
1011 
1012         _balances[from] -= 1;
1013         _balances[to] += 1;
1014         _owners[tokenId] = to;
1015 
1016         emit Transfer(from, to, tokenId);
1017     }
1018 
1019     /**
1020      * @dev Approve `to` to operate on `tokenId`
1021      *
1022      * Emits a {Approval} event.
1023      */
1024     function _approve(address to, uint256 tokenId) internal virtual {
1025         _tokenApprovals[tokenId] = to;
1026         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev Approve `operator` to operate on all of `owner` tokens
1031      *
1032      * Emits a {ApprovalForAll} event.
1033      */
1034     function _setApprovalForAll(
1035         address owner,
1036         address operator,
1037         bool approved
1038     ) internal virtual {
1039         require(owner != operator, "ERC721: approve to caller");
1040         _operatorApprovals[owner][operator] = approved;
1041         emit ApprovalForAll(owner, operator, approved);
1042     }
1043 
1044     /**
1045      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1046      * The call is not executed if the target address is not a contract.
1047      *
1048      * @param from address representing the previous owner of the given token ID
1049      * @param to target address that will receive the tokens
1050      * @param tokenId uint256 ID of the token to be transferred
1051      * @param _data bytes optional data to send along with the call
1052      * @return bool whether the call correctly returned the expected magic value
1053      */
1054     function _checkOnERC721Received(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) private returns (bool) {
1060         if (to.isContract()) {
1061             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1062                 return retval == IERC721Receiver.onERC721Received.selector;
1063             } catch (bytes memory reason) {
1064                 if (reason.length == 0) {
1065                     revert("ERC721: transfer to non ERC721Receiver implementer");
1066                 } else {
1067                     assembly {
1068                         revert(add(32, reason), mload(reason))
1069                     }
1070                 }
1071             }
1072         } else {
1073             return true;
1074         }
1075     }
1076 
1077     /**
1078      * @dev Hook that is called before any token transfer. This includes minting
1079      * and burning.
1080      *
1081      * Calling conditions:
1082      *
1083      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1084      * transferred to `to`.
1085      * - When `from` is zero, `tokenId` will be minted for `to`.
1086      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1087      * - `from` and `to` are never both zero.
1088      *
1089      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1090      */
1091     function _beforeTokenTransfer(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) internal virtual {}
1096 }
1097 
1098 // File: contracts/Shark.sol
1099 
1100 
1101 
1102 pragma solidity ^0.8.9;
1103 
1104 
1105 
1106 interface IInkk {
1107     function balanceOf(address owner) external view returns (uint);
1108     function burn(address account, uint amount) external;
1109 }
1110 
1111 interface IReef {
1112     function randomSharkOwner() external returns (address);
1113     function addTokensToStake(address account, uint16[] calldata tokenIds) external;
1114 }
1115 
1116 contract SquidGame is ERC721, Ownable {
1117     uint public MAX_TOKENS = 50000;
1118     uint constant public MINT_PER_TX_LIMIT = 20;
1119 
1120     uint public tokensMinted = 0;
1121     uint16 public phase = 1;
1122     uint16 public sharkStolen = 0;
1123     uint16 public squidStolen = 0;
1124     uint16 public sharkMinted = 0;
1125     uint16 public maxFreeMint = 888;
1126 
1127     bool private _paused = true;
1128 
1129     mapping(uint16 => uint) public phasePrice;
1130 
1131     IReef public reef;
1132     IInkk public inkk;
1133 
1134     string private _apiURI; //NEED TO UPDATE
1135     mapping(uint16 => bool) private _isShark;
1136     
1137     uint16[] private _availableTokens;
1138     uint16 private _randomIndex = 0;
1139     uint private _randomCalls = 0;
1140 
1141     mapping(uint16 => address) private _randomSource;
1142 
1143     event TokenStolen(address owner, uint16 tokenId, address thief);
1144 
1145     constructor() ERC721("LiteralSquidGame", "LSG") {
1146         _safeMint(msg.sender, 0);
1147         tokensMinted += 1;
1148 
1149         // Phase 1 is available in the beginning
1150         switchToSalePhase(1, true);
1151 
1152         // Set default price for each phase
1153         phasePrice[1] = 0.042 ether;
1154         phasePrice[2] = 20000 ether;
1155         phasePrice[3] = 40000 ether;
1156         phasePrice[4] = 80000 ether;
1157         
1158         // Fill random source addresses
1159         _randomSource[0] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1160         _randomSource[1] = 0x3cD751E6b0078Be393132286c442345e5DC49699;
1161         _randomSource[2] = 0xb5d85CBf7cB3EE0D56b3bB207D5Fc4B82f43F511;
1162         _randomSource[3] = 0xC098B2a3Aa256D2140208C3de6543aAEf5cd3A94;
1163         _randomSource[4] = 0x28C6c06298d514Db089934071355E5743bf21d60;
1164         _randomSource[5] = 0x2FAF487A4414Fe77e2327F0bf4AE2a264a776AD2;
1165         _randomSource[6] = 0x267be1C1D684F78cb4F6a176C4911b741E4Ffdc0;
1166     }
1167 
1168     function paused() public view virtual returns (bool) {
1169         return _paused;
1170     }
1171 
1172     modifier whenNotPaused() {
1173         require(!paused(), "Pausable: paused");
1174         _;
1175     }
1176     modifier whenPaused() {
1177         require(paused(), "Pausable: not paused");
1178         _;
1179     }
1180 
1181     function setPaused(bool _state) external onlyOwner {
1182         _paused = _state;
1183     }
1184 
1185     function addAvailableTokens(uint16 _from, uint16 _to) public onlyOwner {
1186         internalAddTokens(_from, _to);
1187     }
1188 
1189     function internalAddTokens(uint16 _from, uint16 _to) internal {
1190         for (uint16 i = _from; i <= _to; i++) {
1191             _availableTokens.push(i);
1192         }
1193     }
1194 
1195     function switchToSalePhase(uint16 _phase, bool _setTokens) public onlyOwner {
1196         phase = _phase;
1197 
1198         if (!_setTokens) {
1199             return;
1200         }
1201 
1202         if (phase == 1) {
1203             internalAddTokens(1, 9999);
1204         } else if (phase == 2) {
1205             internalAddTokens(10000, 20000);
1206         } else if (phase == 3) {
1207             internalAddTokens(20001, 40000);
1208         } else if (phase == 4) {
1209             internalAddTokens(40001, 49999);
1210         }
1211     }
1212 
1213     function giveAway(uint _amount, address _address) public onlyOwner {
1214         require(tokensMinted + _amount <= MAX_TOKENS, "All tokens minted");
1215         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1216 
1217         for (uint i = 0; i < _amount; i++) {
1218             uint16 tokenId = getTokenToBeMinted();
1219             _safeMint(_address, tokenId);
1220         }
1221     }
1222 
1223     function freeMint() external whenNotPaused {
1224         require(tokensMinted < maxFreeMint, "there are no free mints remaining");
1225         tokensMinted++;
1226         uint16 tokenId = getTokenToBeMinted();
1227         _safeMint(msg.sender, tokenId);
1228     }
1229 
1230     function mint(uint _amount, bool _stake) public payable whenNotPaused {
1231         require(tx.origin == msg.sender, "Only EOA");
1232         require(tokensMinted + _amount <= MAX_TOKENS, "All tokens minted");
1233         require(_amount > 0 && _amount <= MINT_PER_TX_LIMIT, "Invalid mint amount");
1234         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1235 
1236         uint totalInkkCost = 0;
1237 
1238         if (phase == 1) {
1239             // Paid mint
1240             require(mintPrice(_amount) == msg.value, "Invalid payment amount");
1241         } else {
1242             // Mint via inkk burn
1243             require(msg.value == 0, "Minting is now done with INKK");
1244             totalInkkCost = mintPrice(_amount);
1245             require(inkk.balanceOf(msg.sender) >= totalInkkCost, "Not enough INKK");
1246         }
1247 
1248         if (totalInkkCost > 0) {
1249             inkk.burn(msg.sender, totalInkkCost);
1250         }
1251 
1252         tokensMinted += _amount;
1253         uint16[] memory tokenIds = _stake ? new uint16[](_amount) : new uint16[](0);
1254         for (uint i = 0; i < _amount; i++) {
1255             address recipient = selectRecipient();
1256             if (phase != 1) {
1257                 updateRandomIndex();
1258             }
1259 
1260             uint16 tokenId = getTokenToBeMinted();
1261 
1262             if (isShark(tokenId)) {
1263                 sharkMinted += 1;
1264             }
1265 
1266             if (recipient != msg.sender) {
1267                 isShark(tokenId) ? sharkStolen += 1 : squidStolen += 1;
1268                 emit TokenStolen(msg.sender, tokenId, recipient);
1269             }
1270             
1271             if (!_stake || recipient != msg.sender) {
1272                 _safeMint(recipient, tokenId);
1273             } else {
1274                 _safeMint(address(reef), tokenId);
1275                 tokenIds[i] = tokenId;
1276             }
1277         }
1278         if (_stake) {
1279             reef.addTokensToStake(msg.sender, tokenIds);
1280         }
1281     }
1282 
1283     function selectRecipient() internal returns (address) {
1284         if (phase == 1) {
1285             return msg.sender; // During ETH sale there is no chance to steal NTF
1286         }
1287 
1288         // 10% chance to steal NTF
1289         if (getSomeRandomNumber(sharkMinted, 100) >= 10) {
1290             return msg.sender; // 90%
1291         }
1292 
1293         address thief = reef.randomSharkOwner();
1294         if (thief == address(0x0)) {
1295             return msg.sender;
1296         }
1297         return thief;
1298     }
1299 
1300     function mintPrice(uint _amount) public view returns (uint) {
1301         return _amount * phasePrice[phase];
1302     }
1303 
1304     function isShark(uint16 id) public view returns (bool) {
1305         return _isShark[id];
1306     }
1307 
1308     function getTokenToBeMinted() private returns (uint16) {
1309         uint random = getSomeRandomNumber(_availableTokens.length, _availableTokens.length);
1310         uint16 tokenId = _availableTokens[random];
1311 
1312         _availableTokens[random] = _availableTokens[_availableTokens.length - 1];
1313         _availableTokens.pop();
1314 
1315         return tokenId;
1316     }
1317     
1318     function updateRandomIndex() internal {
1319         _randomIndex += 1;
1320         _randomCalls += 1;
1321         if (_randomIndex > 6) _randomIndex = 0;
1322     }
1323 
1324     function getSomeRandomNumber(uint _seed, uint _limit) internal view returns (uint16) {
1325         uint extra = 0;
1326         for (uint16 i = 0; i < 7; i++) {
1327             extra += _randomSource[_randomIndex].balance;
1328         }
1329 
1330         uint random = uint(
1331             keccak256(
1332                 abi.encodePacked(
1333                     _seed,
1334                     blockhash(block.number - 1),
1335                     block.coinbase,
1336                     block.difficulty,
1337                     msg.sender,
1338                     tokensMinted,
1339                     extra,
1340                     _randomCalls,
1341                     _randomIndex
1342                 )
1343             )
1344         );
1345 
1346         return uint16(random % _limit);
1347     }
1348 
1349     function shuffleSeeds(uint _seed, uint _max) external onlyOwner {
1350         uint shuffleCount = getSomeRandomNumber(_seed, _max);
1351         _randomIndex = uint16(shuffleCount);
1352         for (uint i = 0; i < shuffleCount; i++) {
1353             updateRandomIndex();
1354         }
1355     }
1356 
1357     function setSharkId(uint16 id, bool special) external onlyOwner {
1358         _isShark[id] = special;
1359     }
1360 
1361     function setSharkIds(uint16[] calldata ids) external onlyOwner {
1362         for (uint i = 0; i < ids.length; i++) {
1363             _isShark[ids[i]] = true;
1364         }
1365     }
1366 
1367     function setReef(address _reef) external onlyOwner {
1368         reef = IReef(_reef);
1369     }
1370 
1371     function setInkk(address _inkk) external onlyOwner {
1372         inkk = IInkk(_inkk);
1373     }
1374 
1375     function changePhasePrice(uint16 _phase, uint _weiPrice) external onlyOwner {
1376         phasePrice[_phase] = _weiPrice;
1377     }
1378 
1379     function transferFrom(address from, address to, uint tokenId) public virtual override {
1380         // Hardcode the Manager's approval so that users don't have to waste gas approving
1381         if (_msgSender() != address(reef))
1382             require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1383         _transfer(from, to, tokenId);
1384     }
1385 
1386     function totalSupply() external view returns (uint) {
1387         return tokensMinted;
1388     }
1389 
1390     function _baseURI() internal view override returns (string memory) {
1391         return _apiURI;
1392     }
1393 
1394     function setBaseURI(string memory uri) external onlyOwner {
1395         _apiURI = uri;
1396     }
1397 
1398     function changeRandomSource(uint16 _id, address _address) external onlyOwner {
1399         _randomSource[_id] = _address;
1400     }
1401 
1402     function withdraw(address to) external onlyOwner { //UPDATE WITH BREAKDOWN BY ADDRESS
1403         uint balance = address(this).balance;
1404         uint share = (balance * 20) / 100;
1405         payable(address(0x000000)).transfer(share);
1406         payable(to).transfer(balance - share);
1407     }
1408     
1409     function withdrawAll() public onlyOwner {
1410         uint256 balance = address(this).balance;
1411         require(balance > 0);
1412 
1413         _withdraw(0xeB9308d65EF1d3729b5acfa0fF6983407366fAe2, (balance * 125) / 1000);
1414         _withdraw(0x8942bfA6390710039e94D27cF461f4AF90Bd6698, (balance * 113) / 1000);
1415         _withdraw(0x05542104Ce35D64D94A02d1169B19f3c6692e1C6, (balance * 125) / 1000);
1416         _withdraw(0x45062131e00aBd9Ce764Cc0F59E5BA5aa4bcE6C0, (balance * 125) / 1000);
1417         _withdraw(0xFcE6a0067A3530967E888beF2fd0f03bb3C71c08, (balance * 125) / 1000);
1418         _withdraw(0xD51DcF312de6b68DD832cacAB0fCe8D191b1F4B0, (balance * 61) / 1000);
1419         _withdraw(0xEaA86e6108D77B9461E944a9c6768D755Fdf9d8D, (balance * 99) / 1000);
1420         _withdraw(0xEfeB49409434D8A4d97254363Ff0AabE95366e61, (balance * 99) / 1000);
1421         _withdraw(0x641fB314Fb59D0352B6bFd90A98f1DA643fF9e5c, (balance * 125) / 1000);
1422         _withdraw(0x46e6634E84570dc13020d16017839614E6FEE495, (balance * 3) / 1000);
1423     }
1424 
1425     function _withdraw(address _address, uint256 _amount) private {
1426         (bool success, ) = _address.call{value: _amount}("");
1427         require(success, "Transfer failed.");
1428     }
1429     function ownerWithdraw() external onlyOwner {
1430         payable(owner()).transfer(address(this).balance);
1431     }
1432 }