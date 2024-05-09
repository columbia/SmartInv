1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Leaves the contract without owner. It will not be possible to call
149      * `onlyOwner` functions anymore. Can only be called by the current owner.
150      *
151      * NOTE: Renouncing ownership will leave the contract without an owner,
152      * thereby removing any functionality that is only available to the owner.
153      */
154     function renounceOwnership() public virtual onlyOwner {
155         _transferOwnership(address(0));
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Can only be called by the current owner.
161      */
162     function transferOwnership(address newOwner) public virtual onlyOwner {
163         require(newOwner != address(0), "Ownable: new owner is the zero address");
164         _transferOwnership(newOwner);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Internal function without access restriction.
170      */
171     function _transferOwnership(address newOwner) internal virtual {
172         address oldOwner = _owner;
173         _owner = newOwner;
174         emit OwnershipTransferred(oldOwner, newOwner);
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Address.sol
179 
180 
181 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
182 
183 pragma solidity ^0.8.1;
184 
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      *
206      * [IMPORTANT]
207      * ====
208      * You shouldn't rely on `isContract` to protect against flash loan attacks!
209      *
210      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
211      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
212      * constructor.
213      * ====
214      */
215     function isContract(address account) internal view returns (bool) {
216         // This method relies on extcodesize/address.code.length, which returns 0
217         // for contracts in construction, since the code is only stored at the end
218         // of the constructor execution.
219 
220         return account.code.length > 0;
221     }
222 
223     /**
224      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
225      * `recipient`, forwarding all available gas and reverting on errors.
226      *
227      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
228      * of certain opcodes, possibly making contracts go over the 2300 gas limit
229      * imposed by `transfer`, making them unable to receive funds via
230      * `transfer`. {sendValue} removes this limitation.
231      *
232      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
233      *
234      * IMPORTANT: because control is transferred to `recipient`, care must be
235      * taken to not create reentrancy vulnerabilities. Consider using
236      * {ReentrancyGuard} or the
237      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
238      */
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(address(this).balance >= amount, "Address: insufficient balance");
241 
242         (bool success, ) = recipient.call{value: amount}("");
243         require(success, "Address: unable to send value, recipient may have reverted");
244     }
245 
246     /**
247      * @dev Performs a Solidity function call using a low level `call`. A
248      * plain `call` is an unsafe replacement for a function call: use this
249      * function instead.
250      *
251      * If `target` reverts with a revert reason, it is bubbled up by this
252      * function (like regular Solidity function calls).
253      *
254      * Returns the raw returned data. To convert to the expected return value,
255      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
256      *
257      * Requirements:
258      *
259      * - `target` must be a contract.
260      * - calling `target` with `data` must not revert.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionCall(target, data, "Address: low-level call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
270      * `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         return functionCallWithValue(target, data, 0, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but also transferring `value` wei to `target`.
285      *
286      * Requirements:
287      *
288      * - the calling contract must have an ETH balance of at least `value`.
289      * - the called Solidity function must be `payable`.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
303      * with `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         require(address(this).balance >= value, "Address: insufficient balance for call");
314         require(isContract(target), "Address: call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.call{value: value}(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
327         return functionStaticCall(target, data, "Address: low-level static call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal view returns (bytes memory) {
341         require(isContract(target), "Address: static call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.staticcall(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(isContract(target), "Address: delegate call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
376      * revert reason using the provided one.
377      *
378      * _Available since v4.3._
379      */
380     function verifyCallResult(
381         bool success,
382         bytes memory returndata,
383         string memory errorMessage
384     ) internal pure returns (bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @title ERC721 token receiver interface
412  * @dev Interface for any contract that wants to support safeTransfers
413  * from ERC721 asset contracts.
414  */
415 interface IERC721Receiver {
416     /**
417      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
418      * by `operator` from `from`, this function is called.
419      *
420      * It must return its Solidity selector to confirm the token transfer.
421      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
422      *
423      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
424      */
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Interface of the ERC165 standard, as defined in the
442  * https://eips.ethereum.org/EIPS/eip-165[EIP].
443  *
444  * Implementers can declare support of contract interfaces, which can then be
445  * queried by others ({ERC165Checker}).
446  *
447  * For an implementation, see {ERC165}.
448  */
449 interface IERC165 {
450     /**
451      * @dev Returns true if this contract implements the interface defined by
452      * `interfaceId`. See the corresponding
453      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
454      * to learn more about how these ids are created.
455      *
456      * This function call must use less than 30 000 gas.
457      */
458     function supportsInterface(bytes4 interfaceId) external view returns (bool);
459 }
460 
461 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
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
495 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
534      * @dev Safely transfers `tokenId` token from `from` to `to`.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must exist and be owned by `from`.
541      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
543      *
544      * Emits a {Transfer} event.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId,
550         bytes calldata data
551     ) external;
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
555      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must exist and be owned by `from`.
562      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
563      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
564      *
565      * Emits a {Transfer} event.
566      */
567     function safeTransferFrom(
568         address from,
569         address to,
570         uint256 tokenId
571     ) external;
572 
573     /**
574      * @dev Transfers `tokenId` token from `from` to `to`.
575      *
576      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      *
585      * Emits a {Transfer} event.
586      */
587     function transferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
595      * The approval is cleared when the token is transferred.
596      *
597      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
598      *
599      * Requirements:
600      *
601      * - The caller must own the token or be an approved operator.
602      * - `tokenId` must exist.
603      *
604      * Emits an {Approval} event.
605      */
606     function approve(address to, uint256 tokenId) external;
607 
608     /**
609      * @dev Approve or remove `operator` as an operator for the caller.
610      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
611      *
612      * Requirements:
613      *
614      * - The `operator` cannot be the caller.
615      *
616      * Emits an {ApprovalForAll} event.
617      */
618     function setApprovalForAll(address operator, bool _approved) external;
619 
620     /**
621      * @dev Returns the account approved for `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function getApproved(uint256 tokenId) external view returns (address operator);
628 
629     /**
630      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
631      *
632      * See {setApprovalForAll}
633      */
634     function isApprovedForAll(address owner, address operator) external view returns (bool);
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
638 
639 
640 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
647  * @dev See https://eips.ethereum.org/EIPS/eip-721
648  */
649 interface IERC721Enumerable is IERC721 {
650     /**
651      * @dev Returns the total amount of tokens stored by the contract.
652      */
653     function totalSupply() external view returns (uint256);
654 
655     /**
656      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
657      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
658      */
659     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
660 
661     /**
662      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
663      * Use along with {totalSupply} to enumerate all tokens.
664      */
665     function tokenByIndex(uint256 index) external view returns (uint256);
666 }
667 
668 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 
676 /**
677  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
678  * @dev See https://eips.ethereum.org/EIPS/eip-721
679  */
680 interface IERC721Metadata is IERC721 {
681     /**
682      * @dev Returns the token collection name.
683      */
684     function name() external view returns (string memory);
685 
686     /**
687      * @dev Returns the token collection symbol.
688      */
689     function symbol() external view returns (string memory);
690 
691     /**
692      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
693      */
694     function tokenURI(uint256 tokenId) external view returns (string memory);
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 
706 
707 
708 
709 
710 
711 /**
712  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
713  * the Metadata extension, but not including the Enumerable extension, which is available separately as
714  * {ERC721Enumerable}.
715  */
716 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
717     using Address for address;
718     using Strings for uint256;
719 
720     // Token name
721     string private _name;
722 
723     // Token symbol
724     string private _symbol;
725 
726     // Mapping from token ID to owner address
727     mapping(uint256 => address) private _owners;
728 
729     // Mapping owner address to token count
730     mapping(address => uint256) private _balances;
731 
732     // Mapping from token ID to approved address
733     mapping(uint256 => address) private _tokenApprovals;
734 
735     // Mapping from owner to operator approvals
736     mapping(address => mapping(address => bool)) private _operatorApprovals;
737 
738     /**
739      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
740      */
741     constructor(string memory name_, string memory symbol_) {
742         _name = name_;
743         _symbol = symbol_;
744     }
745 
746     /**
747      * @dev See {IERC165-supportsInterface}.
748      */
749     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
750         return
751             interfaceId == type(IERC721).interfaceId ||
752             interfaceId == type(IERC721Metadata).interfaceId ||
753             super.supportsInterface(interfaceId);
754     }
755 
756     /**
757      * @dev See {IERC721-balanceOf}.
758      */
759     function balanceOf(address owner) public view virtual override returns (uint256) {
760         require(owner != address(0), "ERC721: balance query for the zero address");
761         return _balances[owner];
762     }
763 
764     /**
765      * @dev See {IERC721-ownerOf}.
766      */
767     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
768         address owner = _owners[tokenId];
769         require(owner != address(0), "ERC721: owner query for nonexistent token");
770         return owner;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-name}.
775      */
776     function name() public view virtual override returns (string memory) {
777         return _name;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-symbol}.
782      */
783     function symbol() public view virtual override returns (string memory) {
784         return _symbol;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-tokenURI}.
789      */
790     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
791         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
792 
793         string memory baseURI = _baseURI();
794         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
795     }
796 
797     /**
798      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
799      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
800      * by default, can be overridden in child contracts.
801      */
802     function _baseURI() internal view virtual returns (string memory) {
803         return "";
804     }
805 
806     /**
807      * @dev See {IERC721-approve}.
808      */
809     function approve(address to, uint256 tokenId) public virtual override {
810         address owner = ERC721.ownerOf(tokenId);
811         require(to != owner, "ERC721: approval to current owner");
812 
813         require(
814             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
815             "ERC721: approve caller is not owner nor approved for all"
816         );
817 
818         _approve(to, tokenId);
819     }
820 
821     /**
822      * @dev See {IERC721-getApproved}.
823      */
824     function getApproved(uint256 tokenId) public view virtual override returns (address) {
825         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
826 
827         return _tokenApprovals[tokenId];
828     }
829 
830     /**
831      * @dev See {IERC721-setApprovalForAll}.
832      */
833     function setApprovalForAll(address operator, bool approved) public virtual override {
834         _setApprovalForAll(_msgSender(), operator, approved);
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
932         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
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
987 
988         _afterTokenTransfer(address(0), to, tokenId);
989     }
990 
991     /**
992      * @dev Destroys `tokenId`.
993      * The approval is cleared when the token is burned.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _burn(uint256 tokenId) internal virtual {
1002         address owner = ERC721.ownerOf(tokenId);
1003 
1004         _beforeTokenTransfer(owner, address(0), tokenId);
1005 
1006         // Clear approvals
1007         _approve(address(0), tokenId);
1008 
1009         _balances[owner] -= 1;
1010         delete _owners[tokenId];
1011 
1012         emit Transfer(owner, address(0), tokenId);
1013 
1014         _afterTokenTransfer(owner, address(0), tokenId);
1015     }
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _transfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) internal virtual {
1033         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1034         require(to != address(0), "ERC721: transfer to the zero address");
1035 
1036         _beforeTokenTransfer(from, to, tokenId);
1037 
1038         // Clear approvals from the previous owner
1039         _approve(address(0), tokenId);
1040 
1041         _balances[from] -= 1;
1042         _balances[to] += 1;
1043         _owners[tokenId] = to;
1044 
1045         emit Transfer(from, to, tokenId);
1046 
1047         _afterTokenTransfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Approve `to` to operate on `tokenId`
1052      *
1053      * Emits a {Approval} event.
1054      */
1055     function _approve(address to, uint256 tokenId) internal virtual {
1056         _tokenApprovals[tokenId] = to;
1057         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Approve `operator` to operate on all of `owner` tokens
1062      *
1063      * Emits a {ApprovalForAll} event.
1064      */
1065     function _setApprovalForAll(
1066         address owner,
1067         address operator,
1068         bool approved
1069     ) internal virtual {
1070         require(owner != operator, "ERC721: approve to caller");
1071         _operatorApprovals[owner][operator] = approved;
1072         emit ApprovalForAll(owner, operator, approved);
1073     }
1074 
1075     /**
1076      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1077      * The call is not executed if the target address is not a contract.
1078      *
1079      * @param from address representing the previous owner of the given token ID
1080      * @param to target address that will receive the tokens
1081      * @param tokenId uint256 ID of the token to be transferred
1082      * @param _data bytes optional data to send along with the call
1083      * @return bool whether the call correctly returned the expected magic value
1084      */
1085     function _checkOnERC721Received(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) private returns (bool) {
1091         if (to.isContract()) {
1092             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1093                 return retval == IERC721Receiver.onERC721Received.selector;
1094             } catch (bytes memory reason) {
1095                 if (reason.length == 0) {
1096                     revert("ERC721: transfer to non ERC721Receiver implementer");
1097                 } else {
1098                     assembly {
1099                         revert(add(32, reason), mload(reason))
1100                     }
1101                 }
1102             }
1103         } else {
1104             return true;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Hook that is called before any token transfer. This includes minting
1110      * and burning.
1111      *
1112      * Calling conditions:
1113      *
1114      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1115      * transferred to `to`.
1116      * - When `from` is zero, `tokenId` will be minted for `to`.
1117      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1118      * - `from` and `to` are never both zero.
1119      *
1120      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1121      */
1122     function _beforeTokenTransfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual {}
1127 
1128     /**
1129      * @dev Hook that is called after any transfer of tokens. This includes
1130      * minting and burning.
1131      *
1132      * Calling conditions:
1133      *
1134      * - when `from` and `to` are both non-zero.
1135      * - `from` and `to` are never both zero.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _afterTokenTransfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) internal virtual {}
1144 }
1145 
1146 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1147 
1148 
1149 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1150 
1151 pragma solidity ^0.8.0;
1152 
1153 
1154 
1155 /**
1156  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1157  * enumerability of all the token ids in the contract as well as all token ids owned by each
1158  * account.
1159  */
1160 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1161     // Mapping from owner to list of owned token IDs
1162     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1163 
1164     // Mapping from token ID to index of the owner tokens list
1165     mapping(uint256 => uint256) private _ownedTokensIndex;
1166 
1167     // Array with all token ids, used for enumeration
1168     uint256[] private _allTokens;
1169 
1170     // Mapping from token id to position in the allTokens array
1171     mapping(uint256 => uint256) private _allTokensIndex;
1172 
1173     /**
1174      * @dev See {IERC165-supportsInterface}.
1175      */
1176     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1177         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1182      */
1183     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1184         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1185         return _ownedTokens[owner][index];
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Enumerable-totalSupply}.
1190      */
1191     function totalSupply() public view virtual override returns (uint256) {
1192         return _allTokens.length;
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Enumerable-tokenByIndex}.
1197      */
1198     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1199         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1200         return _allTokens[index];
1201     }
1202 
1203     /**
1204      * @dev Hook that is called before any token transfer. This includes minting
1205      * and burning.
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` will be minted for `to`.
1212      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1213      * - `from` cannot be the zero address.
1214      * - `to` cannot be the zero address.
1215      *
1216      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1217      */
1218     function _beforeTokenTransfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) internal virtual override {
1223         super._beforeTokenTransfer(from, to, tokenId);
1224 
1225         if (from == address(0)) {
1226             _addTokenToAllTokensEnumeration(tokenId);
1227         } else if (from != to) {
1228             _removeTokenFromOwnerEnumeration(from, tokenId);
1229         }
1230         if (to == address(0)) {
1231             _removeTokenFromAllTokensEnumeration(tokenId);
1232         } else if (to != from) {
1233             _addTokenToOwnerEnumeration(to, tokenId);
1234         }
1235     }
1236 
1237     /**
1238      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1239      * @param to address representing the new owner of the given token ID
1240      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1241      */
1242     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1243         uint256 length = ERC721.balanceOf(to);
1244         _ownedTokens[to][length] = tokenId;
1245         _ownedTokensIndex[tokenId] = length;
1246     }
1247 
1248     /**
1249      * @dev Private function to add a token to this extension's token tracking data structures.
1250      * @param tokenId uint256 ID of the token to be added to the tokens list
1251      */
1252     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1253         _allTokensIndex[tokenId] = _allTokens.length;
1254         _allTokens.push(tokenId);
1255     }
1256 
1257     /**
1258      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1259      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1260      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1261      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1262      * @param from address representing the previous owner of the given token ID
1263      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1264      */
1265     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1266         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1267         // then delete the last slot (swap and pop).
1268 
1269         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1270         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1271 
1272         // When the token to delete is the last token, the swap operation is unnecessary
1273         if (tokenIndex != lastTokenIndex) {
1274             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1275 
1276             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1277             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1278         }
1279 
1280         // This also deletes the contents at the last position of the array
1281         delete _ownedTokensIndex[tokenId];
1282         delete _ownedTokens[from][lastTokenIndex];
1283     }
1284 
1285     /**
1286      * @dev Private function to remove a token from this extension's token tracking data structures.
1287      * This has O(1) time complexity, but alters the order of the _allTokens array.
1288      * @param tokenId uint256 ID of the token to be removed from the tokens list
1289      */
1290     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1291         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1292         // then delete the last slot (swap and pop).
1293 
1294         uint256 lastTokenIndex = _allTokens.length - 1;
1295         uint256 tokenIndex = _allTokensIndex[tokenId];
1296 
1297         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1298         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1299         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1300         uint256 lastTokenId = _allTokens[lastTokenIndex];
1301 
1302         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1303         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1304 
1305         // This also deletes the contents at the last position of the array
1306         delete _allTokensIndex[tokenId];
1307         _allTokens.pop();
1308     }
1309 }
1310 
1311 // File: contracts/thetales.sol
1312 
1313 /*
1314 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1315 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1316 MMMMXOkOOOkkxkkOOkk0XKkkXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kkOOOkkxxkOOOkOXMMMMMMMMMMMW0kkXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1317 MMMWxlkOOOd. ;kOOOdlOO,.dWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0odOOOOk: .dOOOklxWMMMMMMMMMMWO'.xMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1318 MMMWXNMMMMX; oWMMMWXXX:.dWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXXWMMMMWd ;XMMMMNXWMMMMMMMMMMMX;.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1319 MMMMMMMMMMX; oWMMMMMMX:.oXOkkxkKWMMMMMN0kkkxkKWMMMMMMMMMMMMMMMWd.;XMMMMMMNOkkkxkKWMMMX;.dMMMMN0kkkkkXWMMMWKkxkxkONMMMMMM
1320 MMMMMMMMMMX; oWMMMMMMX: ,dk0KOl,lXMMWO::x0K0d:lKMMMMMMMMMMMMMMWd.;XMMMMWk;ckKKOc,dNMMX;.dMMNk:ck0KOo;oXMNd,lOK0xcoXMMMMM
1321 MMMMMMMMMMX; oWMMMMMMX: ;KMMMMNc.oWWk.,0MMMMWx.;KMMMMMMMMMMMMMWd ;XMMMMXocKMMMMK,.kMMX;.xMWx.;KMMMMWo.:XK,.dNMMMXOXMMMMM
1322 MMMMMMMMMMX; oWMMMMMMX: oWMMMMWo cNX: ,xkkkkko'.xWMMMMMMMMMMMMWd ;XMMMMMWWNXK00x'.dMMX;.xMK, :xkkkkko.'OWO;';lkXWMMMMMMM
1323 MMMMMMMMMMX; oWMMMMMMX:.dWMMMMWo cNK, :000000000NMMMMMMMMMMMMMWd ;XMMMMXxcodxkkd'.dMMX;.xM0'.l00000000KNMMW0dc,':kNMMMMM
1324 MMMMMMMMMMX; oWMMMMMMX:.dWMMMMWo cNNc cNMMMMMMWXNMMMMMMMMMMMMMWd ;XMMMXc.cXMMMMX;.dMMX;.dMX;.oWMMMMMMNXWNKWMMWNk,.cXMMMM
1325 MMMMMMMMMMX; oWMMMMMMX:.dWMMMMWo cNM0,'kWMMMMWOdXMMMMMMMMMMMMMWd ;XMMMX;.oWMMMWk..dMMX;.dMWk',0MMMMMWxdNKlxWMMMMk.,KMMMM
1326 MMMMMMMMMWO'.cXWMMMMWO,.cKWMMWK: ;0WWKocok0OkocxNMMMMMMMMMMMMWXc.'kWMMWO;,oO0Oxo'.cXWO,.cXMW0lcdO0OkockWNd:okOOkc:kWMMMM
1327 MMMMMMMMMWKOkOXWMMMMWKOkOXWMMWXOkOKWMMWX0kkkk0XWMMMMMMMMMMMMMWXOkOKWMMMMN0kkkOKNKOOXNKOkOXWMMWXOkkkk0NMMMWX0kkkO0NMMMMMM
1328 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1329 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1330 */
1331 
1332 pragma solidity ^0.8.6;
1333 
1334 
1335 
1336 contract TheTales is ERC721Enumerable, Ownable {
1337 
1338     string private _baseTokenURI;
1339     uint256 private _maxSupply = 5000;
1340     uint256 private _price = 0.15 ether;
1341     uint256 private _presaleLimit = 3;
1342     uint256 private _reserved = 92;
1343     bool private _preSaleActive = false;
1344     bool private _mainSaleActive = false;
1345     bool private _mintActive = true;
1346 
1347     constructor() ERC721("The Tales", "TALES") {
1348     }
1349 
1350     mapping(address => bool) private _inPresale;
1351     mapping(address => uint256) private _totalClaimed;
1352 
1353     function addToPresale(address[] calldata addresses) external onlyOwner {
1354         for (uint256 i = 0; i < addresses.length; i++) {
1355             require(addresses[i] != address(0), "Cannot add null address");
1356 
1357             _inPresale[addresses[i]] = true;
1358             _totalClaimed[addresses[i]] > 0 ? _totalClaimed[addresses[i]] : 0;
1359         }
1360     }
1361 
1362     function mintPresale(uint256 num) external payable {
1363         uint256 supply = totalSupply();
1364         require( _mintActive, "Mint is ended" );
1365         require( _preSaleActive, "Presale has not started");
1366         require( _inPresale[msg.sender], "You are not eligible for the presale");
1367         require( _reserved + supply + num <= _maxSupply, "No more NFT's available for mint");
1368         require( _totalClaimed[msg.sender] + num <= _presaleLimit, "Not enough available to mint during presale");
1369         require( msg.value >= _price * num, "Please send correct amount of ether" );
1370 
1371         for (uint256 i = 0; i < num; i++){
1372                _totalClaimed[msg.sender] += 1;
1373                _safeMint( msg.sender, supply + i + 1);
1374         }
1375     }
1376 
1377     function mintMainSale(uint256 num) external payable {
1378         uint256 supply = totalSupply();
1379         require( _mintActive, "Mint is ended" );
1380         require( _mainSaleActive, "Main Sale is not available yet" );
1381         require( num > 0 && num < 11, "Only 1 to 10 mints per transaction" );
1382         require( _reserved + supply + num <= _maxSupply, "No more available to mint" );
1383         require( msg.value >= _price * num, "Please send correct amount of ether" );
1384 
1385         for(uint256 i = 0; i < num; i++){
1386             _safeMint( msg.sender, supply + i + 1);
1387         }
1388     }
1389 
1390     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1391         uint256 tokenCount = balanceOf(_owner);
1392 
1393         uint256[] memory tokensId = new uint256[](tokenCount);
1394         for(uint256 i = 0; i < tokenCount; i++){
1395             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1396         }
1397         return tokensId;
1398     }
1399 
1400     function setPrice(uint256 _newPrice) external onlyOwner {
1401         _price = _newPrice;
1402     }
1403 
1404     function inPresale(address addr) external view returns(bool) {
1405         return _inPresale[addr];
1406     }
1407 
1408     function resumePresale() external onlyOwner {
1409         _preSaleActive = true;
1410     }
1411 
1412     function resumeMainSale() external onlyOwner {
1413         _mainSaleActive = true;
1414     }
1415 
1416     function pausePresale() external onlyOwner {
1417         _preSaleActive = false;
1418     }
1419 
1420     function pauseMainSale() external onlyOwner {
1421         _mainSaleActive = false;
1422     }
1423 
1424     //Once minting is ended, no more mainsale / presale mint indefinitely
1425     function endMint() external onlyOwner {
1426         _mintActive = false;
1427     }
1428 
1429     function _baseURI() internal view virtual override returns (string memory) {
1430         return _baseTokenURI;
1431     }
1432 
1433     function setBaseURI(string memory uri) external onlyOwner {
1434         _baseTokenURI = string(uri);
1435     }
1436 
1437     function getPrice() external view returns (uint256) {
1438         return _price;
1439     }
1440 
1441     function getBaseTokenURI() external view onlyOwner returns (string memory) {
1442         return _baseTokenURI;
1443     }
1444 
1445     function getTokensLeft() external view returns (uint256) {
1446         uint256 supply = totalSupply();
1447         return _maxSupply - supply - _reserved;
1448     }
1449 
1450     function giveAway(address to, uint256 quantity) external onlyOwner {
1451         uint256 supply = totalSupply();
1452         require(quantity <= _reserved , "Exceeds NFT minting limit");
1453 
1454         _reserved -= quantity;
1455         for(uint256 i = 0; i < quantity; i++){
1456             _safeMint( to, supply + i + 1);
1457         }
1458     }
1459 
1460     function withdraw() external onlyOwner {
1461         require(payable(msg.sender).send(address(this).balance));
1462     }
1463 }