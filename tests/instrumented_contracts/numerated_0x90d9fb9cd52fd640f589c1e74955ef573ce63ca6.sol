1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 /*
5 
6  ______     ______     ______     __  __        __  __    
7 /\  == \   /\  __ \   /\  == \   /\ \_\ \      /\_\_\_\   
8 \ \  __<   \ \  __ \  \ \  __<   \ \____ \     \/_/\_\/_  
9  \ \_____\  \ \_\ \_\  \ \_____\  \/\_____\      /\_\/\_\ 
10   \/_____/   \/_/\/_/   \/_____/   \/_____/      \/_/\/_/ 
11 
12 
13 BABY X
14 www.babyx.me
15 www.discord.gg/babyx
16 www.twitter.com/babyxnft
17 
18 
19 */
20 
21 // File: @openzeppelin/contracts/utils/Strings.sol
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev String operations.
27  */
28 library Strings {
29     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
33      */
34     function toString(uint256 value) internal pure returns (string memory) {
35         // Inspired by OraclizeAPI's implementation - MIT licence
36         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
58      */
59     function toHexString(uint256 value) internal pure returns (string memory) {
60         if (value == 0) {
61             return "0x00";
62         }
63         uint256 temp = value;
64         uint256 length = 0;
65         while (temp != 0) {
66             length++;
67             temp >>= 8;
68         }
69         return toHexString(value, length);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
74      */
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 }
87 
88 // File: @openzeppelin/contracts/utils/Context.sol
89 
90 
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/access/Ownable.sol
115 
116 
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor() {
142         _setOwner(_msgSender());
143     }
144 
145     /**
146      * @dev Returns the address of the current owner.
147      */
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157         _;
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _setOwner(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _setOwner(newOwner);
178     }
179 
180     function _setOwner(address newOwner) private {
181         address oldOwner = _owner;
182         _owner = newOwner;
183         emit OwnershipTransferred(oldOwner, newOwner);
184     }
185 }
186 
187 // File: @openzeppelin/contracts/utils/Address.sol
188 
189 
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev Collection of functions related to the address type
195  */
196 library Address {
197     /**
198      * @dev Returns true if `account` is a contract.
199      *
200      * [IMPORTANT]
201      * ====
202      * It is unsafe to assume that an address for which this function returns
203      * false is an externally-owned account (EOA) and not a contract.
204      *
205      * Among others, `isContract` will return false for the following
206      * types of addresses:
207      *
208      *  - an externally-owned account
209      *  - a contract in construction
210      *  - an address where a contract will be created
211      *  - an address where a contract lived, but was destroyed
212      * ====
213      */
214     function isContract(address account) internal view returns (bool) {
215         // This method relies on extcodesize, which returns 0 for contracts in
216         // construction, since the code is only stored at the end of the
217         // constructor execution.
218 
219         uint256 size;
220         assembly {
221             size := extcodesize(account)
222         }
223         return size > 0;
224     }
225 
226     /**
227      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
228      * `recipient`, forwarding all available gas and reverting on errors.
229      *
230      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
231      * of certain opcodes, possibly making contracts go over the 2300 gas limit
232      * imposed by `transfer`, making them unable to receive funds via
233      * `transfer`. {sendValue} removes this limitation.
234      *
235      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
236      *
237      * IMPORTANT: because control is transferred to `recipient`, care must be
238      * taken to not create reentrancy vulnerabilities. Consider using
239      * {ReentrancyGuard} or the
240      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
241      */
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(address(this).balance >= amount, "Address: insufficient balance");
244 
245         (bool success, ) = recipient.call{value: amount}("");
246         require(success, "Address: unable to send value, recipient may have reverted");
247     }
248 
249     /**
250      * @dev Performs a Solidity function call using a low level `call`. A
251      * plain `call` is an unsafe replacement for a function call: use this
252      * function instead.
253      *
254      * If `target` reverts with a revert reason, it is bubbled up by this
255      * function (like regular Solidity function calls).
256      *
257      * Returns the raw returned data. To convert to the expected return value,
258      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
259      *
260      * Requirements:
261      *
262      * - `target` must be a contract.
263      * - calling `target` with `data` must not revert.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionCall(target, data, "Address: low-level call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
273      * `errorMessage` as a fallback revert reason when `target` reverts.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, 0, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but also transferring `value` wei to `target`.
288      *
289      * Requirements:
290      *
291      * - the calling contract must have an ETH balance of at least `value`.
292      * - the called Solidity function must be `payable`.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
306      * with `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(address(this).balance >= value, "Address: insufficient balance for call");
317         require(isContract(target), "Address: call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.call{value: value}(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
330         return functionStaticCall(target, data, "Address: low-level static call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal view returns (bytes memory) {
344         require(isContract(target), "Address: static call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(isContract(target), "Address: delegate call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.delegatecall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
379      * revert reason using the provided one.
380      *
381      * _Available since v4.3._
382      */
383     function verifyCallResult(
384         bool success,
385         bytes memory returndata,
386         string memory errorMessage
387     ) internal pure returns (bytes memory) {
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
407 
408 
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @title ERC721 token receiver interface
414  * @dev Interface for any contract that wants to support safeTransfers
415  * from ERC721 asset contracts.
416  */
417 interface IERC721Receiver {
418     /**
419      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
420      * by `operator` from `from`, this function is called.
421      *
422      * It must return its Solidity selector to confirm the token transfer.
423      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
424      *
425      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
426      */
427     function onERC721Received(
428         address operator,
429         address from,
430         uint256 tokenId,
431         bytes calldata data
432     ) external returns (bytes4);
433 }
434 
435 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
436 
437 
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Interface of the ERC165 standard, as defined in the
443  * https://eips.ethereum.org/EIPS/eip-165[EIP].
444  *
445  * Implementers can declare support of contract interfaces, which can then be
446  * queried by others ({ERC165Checker}).
447  *
448  * For an implementation, see {ERC165}.
449  */
450 interface IERC165 {
451     /**
452      * @dev Returns true if this contract implements the interface defined by
453      * `interfaceId`. See the corresponding
454      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
455      * to learn more about how these ids are created.
456      *
457      * This function call must use less than 30 000 gas.
458      */
459     function supportsInterface(bytes4 interfaceId) external view returns (bool);
460 }
461 
462 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
463 
464 
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Implementation of the {IERC165} interface.
471  *
472  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
473  * for the additional interface id that will be supported. For example:
474  *
475  * ```solidity
476  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
477  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
478  * }
479  * ```
480  *
481  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
482  */
483 abstract contract ERC165 is IERC165 {
484     /**
485      * @dev See {IERC165-supportsInterface}.
486      */
487     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488         return interfaceId == type(IERC165).interfaceId;
489     }
490 }
491 
492 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
493 
494 
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @dev Required interface of an ERC721 compliant contract.
501  */
502 interface IERC721 is IERC165 {
503     /**
504      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
505      */
506     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
510      */
511     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
515      */
516     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
517 
518     /**
519      * @dev Returns the number of tokens in ``owner``'s account.
520      */
521     function balanceOf(address owner) external view returns (uint256 balance);
522 
523     /**
524      * @dev Returns the owner of the `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function ownerOf(uint256 tokenId) external view returns (address owner);
531 
532     /**
533      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
534      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must exist and be owned by `from`.
541      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
543      *
544      * Emits a {Transfer} event.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) external;
551 
552     /**
553      * @dev Transfers `tokenId` token from `from` to `to`.
554      *
555      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must be owned by `from`.
562      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
563      *
564      * Emits a {Transfer} event.
565      */
566     function transferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
574      * The approval is cleared when the token is transferred.
575      *
576      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
577      *
578      * Requirements:
579      *
580      * - The caller must own the token or be an approved operator.
581      * - `tokenId` must exist.
582      *
583      * Emits an {Approval} event.
584      */
585     function approve(address to, uint256 tokenId) external;
586 
587     /**
588      * @dev Returns the account approved for `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function getApproved(uint256 tokenId) external view returns (address operator);
595 
596     /**
597      * @dev Approve or remove `operator` as an operator for the caller.
598      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
599      *
600      * Requirements:
601      *
602      * - The `operator` cannot be the caller.
603      *
604      * Emits an {ApprovalForAll} event.
605      */
606     function setApprovalForAll(address operator, bool _approved) external;
607 
608     /**
609      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
610      *
611      * See {setApprovalForAll}
612      */
613     function isApprovedForAll(address owner, address operator) external view returns (bool);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
637 
638 
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Enumerable is IERC721 {
648     /**
649      * @dev Returns the total amount of tokens stored by the contract.
650      */
651     function totalSupply() external view returns (uint256);
652 
653     /**
654      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
655      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
656      */
657     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
658 
659     /**
660      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
661      * Use along with {totalSupply} to enumerate all tokens.
662      */
663     function tokenByIndex(uint256 index) external view returns (uint256);
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
667 
668 
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Metadata is IERC721 {
678     /**
679      * @dev Returns the token collection name.
680      */
681     function name() external view returns (string memory);
682 
683     /**
684      * @dev Returns the token collection symbol.
685      */
686     function symbol() external view returns (string memory);
687 
688     /**
689      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
690      */
691     function tokenURI(uint256 tokenId) external view returns (string memory);
692 }
693 
694 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
695 
696 
697 
698 pragma solidity ^0.8.0;
699 
700 
701 
702 
703 
704 
705 
706 
707 /**
708  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
709  * the Metadata extension, but not including the Enumerable extension, which is available separately as
710  * {ERC721Enumerable}.
711  */
712 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
713     using Address for address;
714     using Strings for uint256;
715 
716     // Token name
717     string private _name;
718 
719     // Token symbol
720     string private _symbol;
721 
722     // Mapping from token ID to owner address
723     mapping(uint256 => address) private _owners;
724 
725     // Mapping owner address to token count
726     mapping(address => uint256) private _balances;
727 
728     // Mapping from token ID to approved address
729     mapping(uint256 => address) private _tokenApprovals;
730 
731     // Mapping from owner to operator approvals
732     mapping(address => mapping(address => bool)) private _operatorApprovals;
733 
734     /**
735      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
736      */
737     constructor(string memory name_, string memory symbol_) {
738         _name = name_;
739         _symbol = symbol_;
740     }
741 
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
746         return
747             interfaceId == type(IERC721).interfaceId ||
748             interfaceId == type(IERC721Metadata).interfaceId ||
749             super.supportsInterface(interfaceId);
750     }
751 
752     /**
753      * @dev See {IERC721-balanceOf}.
754      */
755     function balanceOf(address owner) public view virtual override returns (uint256) {
756         require(owner != address(0), "ERC721: balance query for the zero address");
757         return _balances[owner];
758     }
759 
760     /**
761      * @dev See {IERC721-ownerOf}.
762      */
763     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
764         address owner = _owners[tokenId];
765         require(owner != address(0), "ERC721: owner query for nonexistent token");
766         return owner;
767     }
768 
769     /**
770      * @dev See {IERC721Metadata-name}.
771      */
772     function name() public view virtual override returns (string memory) {
773         return _name;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-symbol}.
778      */
779     function symbol() public view virtual override returns (string memory) {
780         return _symbol;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-tokenURI}.
785      */
786     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
787         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
788 
789         string memory baseURI = _baseURI();
790         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
791     }
792 
793     /**
794      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
795      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
796      * by default, can be overriden in child contracts.
797      */
798     function _baseURI() internal view virtual returns (string memory) {
799         return "";
800     }
801 
802     /**
803      * @dev See {IERC721-approve}.
804      */
805     function approve(address to, uint256 tokenId) public virtual override {
806         address owner = ERC721.ownerOf(tokenId);
807         require(to != owner, "ERC721: approval to current owner");
808 
809         require(
810             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
811             "ERC721: approve caller is not owner nor approved for all"
812         );
813 
814         _approve(to, tokenId);
815     }
816 
817     /**
818      * @dev See {IERC721-getApproved}.
819      */
820     function getApproved(uint256 tokenId) public view virtual override returns (address) {
821         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
822 
823         return _tokenApprovals[tokenId];
824     }
825 
826     /**
827      * @dev See {IERC721-setApprovalForAll}.
828      */
829     function setApprovalForAll(address operator, bool approved) public virtual override {
830         require(operator != _msgSender(), "ERC721: approve to caller");
831 
832         _operatorApprovals[_msgSender()][operator] = approved;
833         emit ApprovalForAll(_msgSender(), operator, approved);
834     }
835 
836     /**
837      * @dev See {IERC721-isApprovedForAll}.
838      */
839     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
840         return _operatorApprovals[owner][operator];
841     }
842 
843     /**
844      * @dev See {IERC721-transferFrom}.
845      */
846     function transferFrom(
847         address from,
848         address to,
849         uint256 tokenId
850     ) public virtual override {
851         //solhint-disable-next-line max-line-length
852         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
853 
854         _transfer(from, to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         safeTransferFrom(from, to, tokenId, "");
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) public virtual override {
877         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
878         _safeTransfer(from, to, tokenId, _data);
879     }
880 
881     /**
882      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
883      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
884      *
885      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
886      *
887      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
888      * implement alternative mechanisms to perform token transfer, such as signature-based.
889      *
890      * Requirements:
891      *
892      * - `from` cannot be the zero address.
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must exist and be owned by `from`.
895      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _safeTransfer(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) internal virtual {
905         _transfer(from, to, tokenId);
906         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
907     }
908 
909     /**
910      * @dev Returns whether `tokenId` exists.
911      *
912      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
913      *
914      * Tokens start existing when they are minted (`_mint`),
915      * and stop existing when they are burned (`_burn`).
916      */
917     function _exists(uint256 tokenId) internal view virtual returns (bool) {
918         return _owners[tokenId] != address(0);
919     }
920 
921     /**
922      * @dev Returns whether `spender` is allowed to manage `tokenId`.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      */
928     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
929         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
930         address owner = ERC721.ownerOf(tokenId);
931         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
932     }
933 
934     /**
935      * @dev Safely mints `tokenId` and transfers it to `to`.
936      *
937      * Requirements:
938      *
939      * - `tokenId` must not exist.
940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _safeMint(address to, uint256 tokenId) internal virtual {
945         _safeMint(to, tokenId, "");
946     }
947 
948     /**
949      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
950      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
951      */
952     function _safeMint(
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) internal virtual {
957         _mint(to, tokenId);
958         require(
959             _checkOnERC721Received(address(0), to, tokenId, _data),
960             "ERC721: transfer to non ERC721Receiver implementer"
961         );
962     }
963 
964     /**
965      * @dev Mints `tokenId` and transfers it to `to`.
966      *
967      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
968      *
969      * Requirements:
970      *
971      * - `tokenId` must not exist.
972      * - `to` cannot be the zero address.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _mint(address to, uint256 tokenId) internal virtual {
977         require(to != address(0), "ERC721: mint to the zero address");
978         require(!_exists(tokenId), "ERC721: token already minted");
979 
980         _beforeTokenTransfer(address(0), to, tokenId);
981 
982         _balances[to] += 1;
983         _owners[tokenId] = to;
984 
985         emit Transfer(address(0), to, tokenId);
986     }
987 
988     /**
989      * @dev Destroys `tokenId`.
990      * The approval is cleared when the token is burned.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must exist.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _burn(uint256 tokenId) internal virtual {
999         address owner = ERC721.ownerOf(tokenId);
1000 
1001         _beforeTokenTransfer(owner, address(0), tokenId);
1002 
1003         // Clear approvals
1004         _approve(address(0), tokenId);
1005 
1006         _balances[owner] -= 1;
1007         delete _owners[tokenId];
1008 
1009         emit Transfer(owner, address(0), tokenId);
1010     }
1011 
1012     /**
1013      * @dev Transfers `tokenId` from `from` to `to`.
1014      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1015      *
1016      * Requirements:
1017      *
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must be owned by `from`.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _transfer(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) internal virtual {
1028         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1029         require(to != address(0), "ERC721: transfer to the zero address");
1030 
1031         _beforeTokenTransfer(from, to, tokenId);
1032 
1033         // Clear approvals from the previous owner
1034         _approve(address(0), tokenId);
1035 
1036         _balances[from] -= 1;
1037         _balances[to] += 1;
1038         _owners[tokenId] = to;
1039 
1040         emit Transfer(from, to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev Approve `to` to operate on `tokenId`
1045      *
1046      * Emits a {Approval} event.
1047      */
1048     function _approve(address to, uint256 tokenId) internal virtual {
1049         _tokenApprovals[tokenId] = to;
1050         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1055      * The call is not executed if the target address is not a contract.
1056      *
1057      * @param from address representing the previous owner of the given token ID
1058      * @param to target address that will receive the tokens
1059      * @param tokenId uint256 ID of the token to be transferred
1060      * @param _data bytes optional data to send along with the call
1061      * @return bool whether the call correctly returned the expected magic value
1062      */
1063     function _checkOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         if (to.isContract()) {
1070             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1071                 return retval == IERC721Receiver.onERC721Received.selector;
1072             } catch (bytes memory reason) {
1073                 if (reason.length == 0) {
1074                     revert("ERC721: transfer to non ERC721Receiver implementer");
1075                 } else {
1076                     assembly {
1077                         revert(add(32, reason), mload(reason))
1078                     }
1079                 }
1080             }
1081         } else {
1082             return true;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before any token transfer. This includes minting
1088      * and burning.
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` will be minted for `to`.
1095      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1096      * - `from` and `to` are never both zero.
1097      *
1098      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1099      */
1100     function _beforeTokenTransfer(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) internal virtual {}
1105 }
1106 
1107 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1108 
1109 
1110 
1111 pragma solidity ^0.8.0;
1112 
1113 
1114 
1115 /**
1116  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1117  * enumerability of all the token ids in the contract as well as all token ids owned by each
1118  * account.
1119  */
1120 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1121     // Mapping from owner to list of owned token IDs
1122     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1123 
1124     // Mapping from token ID to index of the owner tokens list
1125     mapping(uint256 => uint256) private _ownedTokensIndex;
1126 
1127     // Array with all token ids, used for enumeration
1128     uint256[] private _allTokens;
1129 
1130     // Mapping from token id to position in the allTokens array
1131     mapping(uint256 => uint256) private _allTokensIndex;
1132 
1133     /**
1134      * @dev See {IERC165-supportsInterface}.
1135      */
1136     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1137         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1142      */
1143     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1144         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1145         return _ownedTokens[owner][index];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721Enumerable-totalSupply}.
1150      */
1151     function totalSupply() public view virtual override returns (uint256) {
1152         return _allTokens.length;
1153     }
1154 
1155     /**
1156      * @dev See {IERC721Enumerable-tokenByIndex}.
1157      */
1158     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1159         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1160         return _allTokens[index];
1161     }
1162 
1163     /**
1164      * @dev Hook that is called before any token transfer. This includes minting
1165      * and burning.
1166      *
1167      * Calling conditions:
1168      *
1169      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1170      * transferred to `to`.
1171      * - When `from` is zero, `tokenId` will be minted for `to`.
1172      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1173      * - `from` cannot be the zero address.
1174      * - `to` cannot be the zero address.
1175      *
1176      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1177      */
1178     function _beforeTokenTransfer(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) internal virtual override {
1183         super._beforeTokenTransfer(from, to, tokenId);
1184 
1185         if (from == address(0)) {
1186             _addTokenToAllTokensEnumeration(tokenId);
1187         } else if (from != to) {
1188             _removeTokenFromOwnerEnumeration(from, tokenId);
1189         }
1190         if (to == address(0)) {
1191             _removeTokenFromAllTokensEnumeration(tokenId);
1192         } else if (to != from) {
1193             _addTokenToOwnerEnumeration(to, tokenId);
1194         }
1195     }
1196 
1197     /**
1198      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1199      * @param to address representing the new owner of the given token ID
1200      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1201      */
1202     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1203         uint256 length = ERC721.balanceOf(to);
1204         _ownedTokens[to][length] = tokenId;
1205         _ownedTokensIndex[tokenId] = length;
1206     }
1207 
1208     /**
1209      * @dev Private function to add a token to this extension's token tracking data structures.
1210      * @param tokenId uint256 ID of the token to be added to the tokens list
1211      */
1212     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1213         _allTokensIndex[tokenId] = _allTokens.length;
1214         _allTokens.push(tokenId);
1215     }
1216 
1217     /**
1218      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1219      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1220      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1221      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1222      * @param from address representing the previous owner of the given token ID
1223      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1224      */
1225     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1226         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1227         // then delete the last slot (swap and pop).
1228 
1229         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1230         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1231 
1232         // When the token to delete is the last token, the swap operation is unnecessary
1233         if (tokenIndex != lastTokenIndex) {
1234             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1235 
1236             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1237             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1238         }
1239 
1240         // This also deletes the contents at the last position of the array
1241         delete _ownedTokensIndex[tokenId];
1242         delete _ownedTokens[from][lastTokenIndex];
1243     }
1244 
1245     /**
1246      * @dev Private function to remove a token from this extension's token tracking data structures.
1247      * This has O(1) time complexity, but alters the order of the _allTokens array.
1248      * @param tokenId uint256 ID of the token to be removed from the tokens list
1249      */
1250     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1251         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1252         // then delete the last slot (swap and pop).
1253 
1254         uint256 lastTokenIndex = _allTokens.length - 1;
1255         uint256 tokenIndex = _allTokensIndex[tokenId];
1256 
1257         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1258         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1259         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1260         uint256 lastTokenId = _allTokens[lastTokenIndex];
1261 
1262         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1263         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1264 
1265         // This also deletes the contents at the last position of the array
1266         delete _allTokensIndex[tokenId];
1267         _allTokens.pop();
1268     }
1269 }
1270 
1271 // File: contracts/BabyX.sol
1272 
1273 
1274 pragma solidity >=0.7.0 <0.9.0;
1275 
1276 
1277 
1278 contract BabyX is ERC721Enumerable, Ownable {
1279   using Strings for uint256;
1280 
1281   string public baseURI;
1282   string public baseExtension = ".json";
1283   string public notRevealedUri;
1284   uint256 public cost = 0.03 ether;
1285   uint256 public maxSupply = 3333;
1286   uint256 public maxMintAmount = 9;
1287   uint256 public nftPerAddressLimit = 18;
1288   bool public paused = false;
1289   bool public revealed = false;
1290   bool public onlyWhitelisted = true;
1291   address[] public whitelistedAddresses;
1292   mapping(address => uint256) public addressMintedBalance;
1293 
1294 
1295   constructor(
1296     string memory _name,
1297     string memory _symbol,
1298     string memory _initBaseURI,
1299     string memory _initNotRevealedUri
1300   ) ERC721(_name, _symbol) {
1301     setBaseURI(_initBaseURI);
1302     setNotRevealedURI(_initNotRevealedUri);
1303   }
1304 
1305   // internal
1306   function _baseURI() internal view virtual override returns (string memory) {
1307     return baseURI;
1308   }
1309 
1310   // public
1311   function mint(uint256 _mintAmount) public payable {
1312     require(!paused, "the contract is paused");
1313     uint256 supply = totalSupply();
1314     require(_mintAmount > 0, "need to mint at least 1 NFT");
1315     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1316     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1317 
1318     if (msg.sender != owner()) {
1319         if(onlyWhitelisted == true) {
1320             require(isWhitelisted(msg.sender), "user is not whitelisted");
1321             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1322             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1323         }
1324         require(msg.value >= cost * _mintAmount, "insufficient funds");
1325     }
1326     
1327     for (uint256 i = 1; i <= _mintAmount; i++) {
1328         addressMintedBalance[msg.sender]++;
1329       _safeMint(msg.sender, supply + i);
1330     }
1331   }
1332   
1333   function isWhitelisted(address _user) public view returns (bool) {
1334     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1335       if (whitelistedAddresses[i] == _user) {
1336           return true;
1337       }
1338     }
1339     return false;
1340   }
1341 
1342   function walletOfOwner(address _owner)
1343     public
1344     view
1345     returns (uint256[] memory)
1346   {
1347     uint256 ownerTokenCount = balanceOf(_owner);
1348     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1349     for (uint256 i; i < ownerTokenCount; i++) {
1350       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1351     }
1352     return tokenIds;
1353   }
1354 
1355   function tokenURI(uint256 tokenId)
1356     public
1357     view
1358     virtual
1359     override
1360     returns (string memory)
1361   {
1362     require(
1363       _exists(tokenId),
1364       "ERC721Metadata: URI query for nonexistent token"
1365     );
1366     
1367     if(revealed == false) {
1368         return notRevealedUri;
1369     }
1370 
1371     string memory currentBaseURI = _baseURI();
1372     return bytes(currentBaseURI).length > 0
1373         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1374         : "";
1375   }
1376 
1377   //only owner
1378   function reveal() public onlyOwner {
1379       revealed = true;
1380   }
1381   
1382   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1383     nftPerAddressLimit = _limit;
1384   }
1385   
1386   function setCost(uint256 _newCost) public onlyOwner {
1387     cost = _newCost;
1388   }
1389 
1390   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1391     maxMintAmount = _newmaxMintAmount;
1392   }
1393 
1394   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1395     baseURI = _newBaseURI;
1396   }
1397 
1398   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1399     baseExtension = _newBaseExtension;
1400   }
1401   
1402   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1403     notRevealedUri = _notRevealedURI;
1404   }
1405 
1406   function pause(bool _state) public onlyOwner {
1407     paused = _state;
1408   }
1409   
1410   function setOnlyWhitelisted(bool _state) public onlyOwner {
1411     onlyWhitelisted = _state;
1412   }
1413   
1414   function whitelistUsers(address[] calldata _users) public onlyOwner {
1415     delete whitelistedAddresses;
1416     whitelistedAddresses = _users;
1417   }
1418  
1419   function withdraw() public payable onlyOwner {
1420 
1421     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1422     require(os);
1423 
1424   }
1425 }