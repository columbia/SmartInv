1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4     
5  _______         __   __                    
6 |    ___|.---.-.|  |_|  |_.--.--.           
7 |    ___||  _  ||   _|   _|  |  |           
8 |___|    |___._||____|____|___  |           
9                           |_____|           
10  _______                 __ __              
11 |    ___|.-----.-----.--|  |  |.-----.-----.
12 |    ___||  _  |  _  |  _  |  ||  -__|__ --|
13 |___|    |_____|_____|_____|__||_____|_____|
14 
15 www.fattyfoodles.com                                           
16     
17     
18 */
19 
20 // File: @openzeppelin/contracts/utils/Strings.sol
21 
22 
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
77         bytes memory buffer = new bytes(2 * length + 2);
78         buffer[0] = "0";
79         buffer[1] = "x";
80         for (uint256 i = 2 * length + 1; i > 1; --i) {
81             buffer[i] = _HEX_SYMBOLS[value & 0xf];
82             value >>= 4;
83         }
84         require(value == 0, "Strings: hex length insufficient");
85         return string(buffer);
86     }
87 }
88 
89 // File: @openzeppelin/contracts/utils/Context.sol
90 
91 
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         return msg.data;
112     }
113 }
114 
115 // File: @openzeppelin/contracts/access/Ownable.sol
116 
117 
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         _setOwner(_msgSender());
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if called by any account other than the owner.
155      */
156     modifier onlyOwner() {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public virtual onlyOwner {
169         _setOwner(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _setOwner(newOwner);
179     }
180 
181     function _setOwner(address newOwner) private {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 // File: @openzeppelin/contracts/utils/Address.sol
189 
190 
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Collection of functions related to the address type
196  */
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * [IMPORTANT]
202      * ====
203      * It is unsafe to assume that an address for which this function returns
204      * false is an externally-owned account (EOA) and not a contract.
205      *
206      * Among others, `isContract` will return false for the following
207      * types of addresses:
208      *
209      *  - an externally-owned account
210      *  - a contract in construction
211      *  - an address where a contract will be created
212      *  - an address where a contract lived, but was destroyed
213      * ====
214      */
215     function isContract(address account) internal view returns (bool) {
216         // This method relies on extcodesize, which returns 0 for contracts in
217         // construction, since the code is only stored at the end of the
218         // constructor execution.
219 
220         uint256 size;
221         assembly {
222             size := extcodesize(account)
223         }
224         return size > 0;
225     }
226 
227     /**
228      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
229      * `recipient`, forwarding all available gas and reverting on errors.
230      *
231      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
232      * of certain opcodes, possibly making contracts go over the 2300 gas limit
233      * imposed by `transfer`, making them unable to receive funds via
234      * `transfer`. {sendValue} removes this limitation.
235      *
236      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
237      *
238      * IMPORTANT: because control is transferred to `recipient`, care must be
239      * taken to not create reentrancy vulnerabilities. Consider using
240      * {ReentrancyGuard} or the
241      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
242      */
243     function sendValue(address payable recipient, uint256 amount) internal {
244         require(address(this).balance >= amount, "Address: insufficient balance");
245 
246         (bool success, ) = recipient.call{value: amount}("");
247         require(success, "Address: unable to send value, recipient may have reverted");
248     }
249 
250     /**
251      * @dev Performs a Solidity function call using a low level `call`. A
252      * plain `call` is an unsafe replacement for a function call: use this
253      * function instead.
254      *
255      * If `target` reverts with a revert reason, it is bubbled up by this
256      * function (like regular Solidity function calls).
257      *
258      * Returns the raw returned data. To convert to the expected return value,
259      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
260      *
261      * Requirements:
262      *
263      * - `target` must be a contract.
264      * - calling `target` with `data` must not revert.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionCall(target, data, "Address: low-level call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
307      * with `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(address(this).balance >= value, "Address: insufficient balance for call");
318         require(isContract(target), "Address: call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.call{value: value}(data);
321         return verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
331         return functionStaticCall(target, data, "Address: low-level static call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal view returns (bytes memory) {
345         require(isContract(target), "Address: static call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.staticcall(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
358         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(isContract(target), "Address: delegate call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
380      * revert reason using the provided one.
381      *
382      * _Available since v4.3._
383      */
384     function verifyCallResult(
385         bool success,
386         bytes memory returndata,
387         string memory errorMessage
388     ) internal pure returns (bytes memory) {
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
408 
409 
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @title ERC721 token receiver interface
415  * @dev Interface for any contract that wants to support safeTransfers
416  * from ERC721 asset contracts.
417  */
418 interface IERC721Receiver {
419     /**
420      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
421      * by `operator` from `from`, this function is called.
422      *
423      * It must return its Solidity selector to confirm the token transfer.
424      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
425      *
426      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
427      */
428     function onERC721Received(
429         address operator,
430         address from,
431         uint256 tokenId,
432         bytes calldata data
433     ) external returns (bytes4);
434 }
435 
436 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
437 
438 
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Interface of the ERC165 standard, as defined in the
444  * https://eips.ethereum.org/EIPS/eip-165[EIP].
445  *
446  * Implementers can declare support of contract interfaces, which can then be
447  * queried by others ({ERC165Checker}).
448  *
449  * For an implementation, see {ERC165}.
450  */
451 interface IERC165 {
452     /**
453      * @dev Returns true if this contract implements the interface defined by
454      * `interfaceId`. See the corresponding
455      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
456      * to learn more about how these ids are created.
457      *
458      * This function call must use less than 30 000 gas.
459      */
460     function supportsInterface(bytes4 interfaceId) external view returns (bool);
461 }
462 
463 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
464 
465 
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
494 
495 
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @dev Required interface of an ERC721 compliant contract.
502  */
503 interface IERC721 is IERC165 {
504     /**
505      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
506      */
507     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
511      */
512     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
516      */
517     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
518 
519     /**
520      * @dev Returns the number of tokens in ``owner``'s account.
521      */
522     function balanceOf(address owner) external view returns (uint256 balance);
523 
524     /**
525      * @dev Returns the owner of the `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function ownerOf(uint256 tokenId) external view returns (address owner);
532 
533     /**
534      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
535      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
536      *
537      * Requirements:
538      *
539      * - `from` cannot be the zero address.
540      * - `to` cannot be the zero address.
541      * - `tokenId` token must exist and be owned by `from`.
542      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
544      *
545      * Emits a {Transfer} event.
546      */
547     function safeTransferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) external;
552 
553     /**
554      * @dev Transfers `tokenId` token from `from` to `to`.
555      *
556      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      *
565      * Emits a {Transfer} event.
566      */
567     function transferFrom(
568         address from,
569         address to,
570         uint256 tokenId
571     ) external;
572 
573     /**
574      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
575      * The approval is cleared when the token is transferred.
576      *
577      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
578      *
579      * Requirements:
580      *
581      * - The caller must own the token or be an approved operator.
582      * - `tokenId` must exist.
583      *
584      * Emits an {Approval} event.
585      */
586     function approve(address to, uint256 tokenId) external;
587 
588     /**
589      * @dev Returns the account approved for `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function getApproved(uint256 tokenId) external view returns (address operator);
596 
597     /**
598      * @dev Approve or remove `operator` as an operator for the caller.
599      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
600      *
601      * Requirements:
602      *
603      * - The `operator` cannot be the caller.
604      *
605      * Emits an {ApprovalForAll} event.
606      */
607     function setApprovalForAll(address operator, bool _approved) external;
608 
609     /**
610      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
611      *
612      * See {setApprovalForAll}
613      */
614     function isApprovedForAll(address owner, address operator) external view returns (bool);
615 
616     /**
617      * @dev Safely transfers `tokenId` token from `from` to `to`.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must exist and be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
626      *
627      * Emits a {Transfer} event.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId,
633         bytes calldata data
634     ) external;
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
638 
639 
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
646  * @dev See https://eips.ethereum.org/EIPS/eip-721
647  */
648 interface IERC721Enumerable is IERC721 {
649     /**
650      * @dev Returns the total amount of tokens stored by the contract.
651      */
652     function totalSupply() external view returns (uint256);
653 
654     /**
655      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
656      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
657      */
658     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
659 
660     /**
661      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
662      * Use along with {totalSupply} to enumerate all tokens.
663      */
664     function tokenByIndex(uint256 index) external view returns (uint256);
665 }
666 
667 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
668 
669 
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Metadata is IERC721 {
679     /**
680      * @dev Returns the token collection name.
681      */
682     function name() external view returns (string memory);
683 
684     /**
685      * @dev Returns the token collection symbol.
686      */
687     function symbol() external view returns (string memory);
688 
689     /**
690      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
691      */
692     function tokenURI(uint256 tokenId) external view returns (string memory);
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
696 
697 
698 
699 pragma solidity ^0.8.0;
700 
701 
702 
703 
704 
705 
706 
707 
708 /**
709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
710  * the Metadata extension, but not including the Enumerable extension, which is available separately as
711  * {ERC721Enumerable}.
712  */
713 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
714     using Address for address;
715     using Strings for uint256;
716 
717     // Token name
718     string private _name;
719 
720     // Token symbol
721     string private _symbol;
722 
723     // Mapping from token ID to owner address
724     mapping(uint256 => address) private _owners;
725 
726     // Mapping owner address to token count
727     mapping(address => uint256) private _balances;
728 
729     // Mapping from token ID to approved address
730     mapping(uint256 => address) private _tokenApprovals;
731 
732     // Mapping from owner to operator approvals
733     mapping(address => mapping(address => bool)) private _operatorApprovals;
734 
735     /**
736      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
737      */
738     constructor(string memory name_, string memory symbol_) {
739         _name = name_;
740         _symbol = symbol_;
741     }
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
747         return
748             interfaceId == type(IERC721).interfaceId ||
749             interfaceId == type(IERC721Metadata).interfaceId ||
750             super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      */
756     function balanceOf(address owner) public view virtual override returns (uint256) {
757         require(owner != address(0), "ERC721: balance query for the zero address");
758         return _balances[owner];
759     }
760 
761     /**
762      * @dev See {IERC721-ownerOf}.
763      */
764     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
765         address owner = _owners[tokenId];
766         require(owner != address(0), "ERC721: owner query for nonexistent token");
767         return owner;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-name}.
772      */
773     function name() public view virtual override returns (string memory) {
774         return _name;
775     }
776 
777     /**
778      * @dev See {IERC721Metadata-symbol}.
779      */
780     function symbol() public view virtual override returns (string memory) {
781         return _symbol;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-tokenURI}.
786      */
787     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
788         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
789 
790         string memory baseURI = _baseURI();
791         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
792     }
793 
794     /**
795      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
796      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
797      * by default, can be overriden in child contracts.
798      */
799     function _baseURI() internal view virtual returns (string memory) {
800         return "";
801     }
802 
803     /**
804      * @dev See {IERC721-approve}.
805      */
806     function approve(address to, uint256 tokenId) public virtual override {
807         address owner = ERC721.ownerOf(tokenId);
808         require(to != owner, "ERC721: approval to current owner");
809 
810         require(
811             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
812             "ERC721: approve caller is not owner nor approved for all"
813         );
814 
815         _approve(to, tokenId);
816     }
817 
818     /**
819      * @dev See {IERC721-getApproved}.
820      */
821     function getApproved(uint256 tokenId) public view virtual override returns (address) {
822         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
823 
824         return _tokenApprovals[tokenId];
825     }
826 
827     /**
828      * @dev See {IERC721-setApprovalForAll}.
829      */
830     function setApprovalForAll(address operator, bool approved) public virtual override {
831         require(operator != _msgSender(), "ERC721: approve to caller");
832 
833         _operatorApprovals[_msgSender()][operator] = approved;
834         emit ApprovalForAll(_msgSender(), operator, approved);
835     }
836 
837     /**
838      * @dev See {IERC721-isApprovedForAll}.
839      */
840     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
841         return _operatorApprovals[owner][operator];
842     }
843 
844     /**
845      * @dev See {IERC721-transferFrom}.
846      */
847     function transferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         //solhint-disable-next-line max-line-length
853         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
854 
855         _transfer(from, to, tokenId);
856     }
857 
858     /**
859      * @dev See {IERC721-safeTransferFrom}.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) public virtual override {
866         safeTransferFrom(from, to, tokenId, "");
867     }
868 
869     /**
870      * @dev See {IERC721-safeTransferFrom}.
871      */
872     function safeTransferFrom(
873         address from,
874         address to,
875         uint256 tokenId,
876         bytes memory _data
877     ) public virtual override {
878         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
879         _safeTransfer(from, to, tokenId, _data);
880     }
881 
882     /**
883      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
884      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
885      *
886      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
887      *
888      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
889      * implement alternative mechanisms to perform token transfer, such as signature-based.
890      *
891      * Requirements:
892      *
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      * - `tokenId` token must exist and be owned by `from`.
896      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _safeTransfer(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) internal virtual {
906         _transfer(from, to, tokenId);
907         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
908     }
909 
910     /**
911      * @dev Returns whether `tokenId` exists.
912      *
913      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
914      *
915      * Tokens start existing when they are minted (`_mint`),
916      * and stop existing when they are burned (`_burn`).
917      */
918     function _exists(uint256 tokenId) internal view virtual returns (bool) {
919         return _owners[tokenId] != address(0);
920     }
921 
922     /**
923      * @dev Returns whether `spender` is allowed to manage `tokenId`.
924      *
925      * Requirements:
926      *
927      * - `tokenId` must exist.
928      */
929     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
930         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
931         address owner = ERC721.ownerOf(tokenId);
932         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
933     }
934 
935     /**
936      * @dev Safely mints `tokenId` and transfers it to `to`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must not exist.
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeMint(address to, uint256 tokenId) internal virtual {
946         _safeMint(to, tokenId, "");
947     }
948 
949     /**
950      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
951      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
952      */
953     function _safeMint(
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) internal virtual {
958         _mint(to, tokenId);
959         require(
960             _checkOnERC721Received(address(0), to, tokenId, _data),
961             "ERC721: transfer to non ERC721Receiver implementer"
962         );
963     }
964 
965     /**
966      * @dev Mints `tokenId` and transfers it to `to`.
967      *
968      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
969      *
970      * Requirements:
971      *
972      * - `tokenId` must not exist.
973      * - `to` cannot be the zero address.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _mint(address to, uint256 tokenId) internal virtual {
978         require(to != address(0), "ERC721: mint to the zero address");
979         require(!_exists(tokenId), "ERC721: token already minted");
980 
981         _beforeTokenTransfer(address(0), to, tokenId);
982 
983         _balances[to] += 1;
984         _owners[tokenId] = to;
985 
986         emit Transfer(address(0), to, tokenId);
987     }
988 
989     /**
990      * @dev Destroys `tokenId`.
991      * The approval is cleared when the token is burned.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _burn(uint256 tokenId) internal virtual {
1000         address owner = ERC721.ownerOf(tokenId);
1001 
1002         _beforeTokenTransfer(owner, address(0), tokenId);
1003 
1004         // Clear approvals
1005         _approve(address(0), tokenId);
1006 
1007         _balances[owner] -= 1;
1008         delete _owners[tokenId];
1009 
1010         emit Transfer(owner, address(0), tokenId);
1011     }
1012 
1013     /**
1014      * @dev Transfers `tokenId` from `from` to `to`.
1015      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must be owned by `from`.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _transfer(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) internal virtual {
1029         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1030         require(to != address(0), "ERC721: transfer to the zero address");
1031 
1032         _beforeTokenTransfer(from, to, tokenId);
1033 
1034         // Clear approvals from the previous owner
1035         _approve(address(0), tokenId);
1036 
1037         _balances[from] -= 1;
1038         _balances[to] += 1;
1039         _owners[tokenId] = to;
1040 
1041         emit Transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Approve `to` to operate on `tokenId`
1046      *
1047      * Emits a {Approval} event.
1048      */
1049     function _approve(address to, uint256 tokenId) internal virtual {
1050         _tokenApprovals[tokenId] = to;
1051         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1056      * The call is not executed if the target address is not a contract.
1057      *
1058      * @param from address representing the previous owner of the given token ID
1059      * @param to target address that will receive the tokens
1060      * @param tokenId uint256 ID of the token to be transferred
1061      * @param _data bytes optional data to send along with the call
1062      * @return bool whether the call correctly returned the expected magic value
1063      */
1064     function _checkOnERC721Received(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) private returns (bool) {
1070         if (to.isContract()) {
1071             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1072                 return retval == IERC721Receiver.onERC721Received.selector;
1073             } catch (bytes memory reason) {
1074                 if (reason.length == 0) {
1075                     revert("ERC721: transfer to non ERC721Receiver implementer");
1076                 } else {
1077                     assembly {
1078                         revert(add(32, reason), mload(reason))
1079                     }
1080                 }
1081             }
1082         } else {
1083             return true;
1084         }
1085     }
1086 
1087     /**
1088      * @dev Hook that is called before any token transfer. This includes minting
1089      * and burning.
1090      *
1091      * Calling conditions:
1092      *
1093      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1094      * transferred to `to`.
1095      * - When `from` is zero, `tokenId` will be minted for `to`.
1096      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1097      * - `from` and `to` are never both zero.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _beforeTokenTransfer(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) internal virtual {}
1106 }
1107 
1108 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1109 
1110 
1111 
1112 pragma solidity ^0.8.0;
1113 
1114 
1115 
1116 /**
1117  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1118  * enumerability of all the token ids in the contract as well as all token ids owned by each
1119  * account.
1120  */
1121 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1122     // Mapping from owner to list of owned token IDs
1123     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1124 
1125     // Mapping from token ID to index of the owner tokens list
1126     mapping(uint256 => uint256) private _ownedTokensIndex;
1127 
1128     // Array with all token ids, used for enumeration
1129     uint256[] private _allTokens;
1130 
1131     // Mapping from token id to position in the allTokens array
1132     mapping(uint256 => uint256) private _allTokensIndex;
1133 
1134     /**
1135      * @dev See {IERC165-supportsInterface}.
1136      */
1137     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1138         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1139     }
1140 
1141     /**
1142      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1143      */
1144     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1145         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1146         return _ownedTokens[owner][index];
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Enumerable-totalSupply}.
1151      */
1152     function totalSupply() public view virtual override returns (uint256) {
1153         return _allTokens.length;
1154     }
1155 
1156     /**
1157      * @dev See {IERC721Enumerable-tokenByIndex}.
1158      */
1159     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1160         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1161         return _allTokens[index];
1162     }
1163 
1164     /**
1165      * @dev Hook that is called before any token transfer. This includes minting
1166      * and burning.
1167      *
1168      * Calling conditions:
1169      *
1170      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1171      * transferred to `to`.
1172      * - When `from` is zero, `tokenId` will be minted for `to`.
1173      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1174      * - `from` cannot be the zero address.
1175      * - `to` cannot be the zero address.
1176      *
1177      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1178      */
1179     function _beforeTokenTransfer(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) internal virtual override {
1184         super._beforeTokenTransfer(from, to, tokenId);
1185 
1186         if (from == address(0)) {
1187             _addTokenToAllTokensEnumeration(tokenId);
1188         } else if (from != to) {
1189             _removeTokenFromOwnerEnumeration(from, tokenId);
1190         }
1191         if (to == address(0)) {
1192             _removeTokenFromAllTokensEnumeration(tokenId);
1193         } else if (to != from) {
1194             _addTokenToOwnerEnumeration(to, tokenId);
1195         }
1196     }
1197 
1198     /**
1199      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1200      * @param to address representing the new owner of the given token ID
1201      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1202      */
1203     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1204         uint256 length = ERC721.balanceOf(to);
1205         _ownedTokens[to][length] = tokenId;
1206         _ownedTokensIndex[tokenId] = length;
1207     }
1208 
1209     /**
1210      * @dev Private function to add a token to this extension's token tracking data structures.
1211      * @param tokenId uint256 ID of the token to be added to the tokens list
1212      */
1213     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1214         _allTokensIndex[tokenId] = _allTokens.length;
1215         _allTokens.push(tokenId);
1216     }
1217 
1218     /**
1219      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1220      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1221      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1222      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1223      * @param from address representing the previous owner of the given token ID
1224      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1225      */
1226     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1227         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1228         // then delete the last slot (swap and pop).
1229 
1230         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1231         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1232 
1233         // When the token to delete is the last token, the swap operation is unnecessary
1234         if (tokenIndex != lastTokenIndex) {
1235             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1236 
1237             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1238             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1239         }
1240 
1241         // This also deletes the contents at the last position of the array
1242         delete _ownedTokensIndex[tokenId];
1243         delete _ownedTokens[from][lastTokenIndex];
1244     }
1245 
1246     /**
1247      * @dev Private function to remove a token from this extension's token tracking data structures.
1248      * This has O(1) time complexity, but alters the order of the _allTokens array.
1249      * @param tokenId uint256 ID of the token to be removed from the tokens list
1250      */
1251     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1252         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1253         // then delete the last slot (swap and pop).
1254 
1255         uint256 lastTokenIndex = _allTokens.length - 1;
1256         uint256 tokenIndex = _allTokensIndex[tokenId];
1257 
1258         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1259         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1260         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1261         uint256 lastTokenId = _allTokens[lastTokenIndex];
1262 
1263         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1264         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1265 
1266         // This also deletes the contents at the last position of the array
1267         delete _allTokensIndex[tokenId];
1268         _allTokens.pop();
1269     }
1270 }
1271 
1272 // File: contracts/FattyFoodles.sol
1273 
1274 
1275 pragma solidity >=0.7.0 <0.9.0;
1276 
1277 
1278 
1279 contract FattyFoodles is ERC721Enumerable, Ownable {
1280   using Strings for uint256;
1281 
1282   string public baseURI;
1283   string public baseExtension = ".json";
1284   uint256 public cost = 0.015 ether;
1285   uint256 public maxSupply = 2000;
1286   uint256 public maxMintAmount = 20;
1287   bool public paused = false;
1288   mapping(address => bool) public whitelisted;
1289 
1290   constructor(
1291     string memory _name,
1292     string memory _symbol,
1293     string memory _initBaseURI
1294   ) ERC721(_name, _symbol) {
1295     setBaseURI(_initBaseURI);
1296   }
1297 
1298   // internal
1299   function _baseURI() internal view virtual override returns (string memory) {
1300     return baseURI;
1301   }
1302 
1303   // public
1304   function mint(address _to, uint256 _mintAmount) public payable {
1305     uint256 supply = totalSupply();
1306     require(!paused);
1307     require(_mintAmount > 0);
1308     require(_mintAmount <= maxMintAmount);
1309     require(supply + _mintAmount <= maxSupply);
1310 
1311     if (msg.sender != owner()) {
1312         if(whitelisted[msg.sender] != true) {
1313           require(msg.value >= cost * _mintAmount);
1314         }
1315     }
1316 
1317     for (uint256 i = 1; i <= _mintAmount; i++) {
1318       _safeMint(_to, supply + i);
1319     }
1320   }
1321 
1322   function walletOfOwner(address _owner)
1323     public
1324     view
1325     returns (uint256[] memory)
1326   {
1327     uint256 ownerTokenCount = balanceOf(_owner);
1328     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1329     for (uint256 i; i < ownerTokenCount; i++) {
1330       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1331     }
1332     return tokenIds;
1333   }
1334 
1335   function tokenURI(uint256 tokenId)
1336     public
1337     view
1338     virtual
1339     override
1340     returns (string memory)
1341   {
1342     require(
1343       _exists(tokenId),
1344       "ERC721Metadata: URI query for nonexistent token"
1345     );
1346 
1347     string memory currentBaseURI = _baseURI();
1348     return bytes(currentBaseURI).length > 0
1349         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1350         : "";
1351   }
1352 
1353   //only owner
1354   function setCost(uint256 _newCost) public onlyOwner {
1355     cost = _newCost;
1356   }
1357 
1358   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1359     maxMintAmount = _newmaxMintAmount;
1360   }
1361 
1362   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1363     baseURI = _newBaseURI;
1364   }
1365 
1366   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1367     baseExtension = _newBaseExtension;
1368   }
1369 
1370   function pause(bool _state) public onlyOwner {
1371     paused = _state;
1372   }
1373  
1374  function whitelistUser(address _user) public onlyOwner {
1375     whitelisted[_user] = true;
1376   }
1377  
1378   function removeWhitelistUser(address _user) public onlyOwner {
1379     whitelisted[_user] = false;
1380   }
1381 
1382   function withdraw() public payable onlyOwner {
1383       
1384     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1385     require(os);
1386 
1387   }
1388 }