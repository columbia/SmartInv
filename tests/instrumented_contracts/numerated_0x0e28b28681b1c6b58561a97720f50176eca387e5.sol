1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts@4.5.0/utils/Strings.sol
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
73 // File: @openzeppelin/contracts@4.5.0/utils/Context.sol
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
100 // File: @openzeppelin/contracts@4.5.0/access/Ownable.sol
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
178 // File: @openzeppelin/contracts@4.5.0/utils/Address.sol
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
403 // File: @openzeppelin/contracts@4.5.0/token/ERC721/IERC721Receiver.sol
404 
405 
406 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
423      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
424      */
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 // File: @openzeppelin/contracts@4.5.0/utils/introspection/IERC165.sol
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
461 // File: @openzeppelin/contracts@4.5.0/utils/introspection/ERC165.sol
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
492 // File: @openzeppelin/contracts@4.5.0/token/ERC721/IERC721.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
637 // File: @openzeppelin/contracts@4.5.0/token/ERC721/extensions/IERC721Metadata.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
647  * @dev See https://eips.ethereum.org/EIPS/eip-721
648  */
649 interface IERC721Metadata is IERC721 {
650     /**
651      * @dev Returns the token collection name.
652      */
653     function name() external view returns (string memory);
654 
655     /**
656      * @dev Returns the token collection symbol.
657      */
658     function symbol() external view returns (string memory);
659 
660     /**
661      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
662      */
663     function tokenURI(uint256 tokenId) external view returns (string memory);
664 }
665 
666 // File: @openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol
667 
668 
669 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 
675 
676 
677 
678 
679 
680 /**
681  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
682  * the Metadata extension, but not including the Enumerable extension, which is available separately as
683  * {ERC721Enumerable}.
684  */
685 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
686     using Address for address;
687     using Strings for uint256;
688 
689     // Token name
690     string private _name;
691 
692     // Token symbol
693     string private _symbol;
694 
695     // Mapping from token ID to owner address
696     mapping(uint256 => address) private _owners;
697 
698     // Mapping owner address to token count
699     mapping(address => uint256) private _balances;
700 
701     // Mapping from token ID to approved address
702     mapping(uint256 => address) private _tokenApprovals;
703 
704     // Mapping from owner to operator approvals
705     mapping(address => mapping(address => bool)) private _operatorApprovals;
706 
707     /**
708      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
709      */
710     constructor(string memory name_, string memory symbol_) {
711         _name = name_;
712         _symbol = symbol_;
713     }
714 
715     /**
716      * @dev See {IERC165-supportsInterface}.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
719         return
720             interfaceId == type(IERC721).interfaceId ||
721             interfaceId == type(IERC721Metadata).interfaceId ||
722             super.supportsInterface(interfaceId);
723     }
724 
725     /**
726      * @dev See {IERC721-balanceOf}.
727      */
728     function balanceOf(address owner) public view virtual override returns (uint256) {
729         require(owner != address(0), "ERC721: balance query for the zero address");
730         return _balances[owner];
731     }
732 
733     /**
734      * @dev See {IERC721-ownerOf}.
735      */
736     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
737         address owner = _owners[tokenId];
738         require(owner != address(0), "ERC721: owner query for nonexistent token");
739         return owner;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-name}.
744      */
745     function name() public view virtual override returns (string memory) {
746         return _name;
747     }
748 
749     /**
750      * @dev See {IERC721Metadata-symbol}.
751      */
752     function symbol() public view virtual override returns (string memory) {
753         return _symbol;
754     }
755 
756     /**
757      * @dev See {IERC721Metadata-tokenURI}.
758      */
759     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
760         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
761 
762         string memory baseURI = _baseURI();
763         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
764     }
765 
766     /**
767      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
768      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
769      * by default, can be overriden in child contracts.
770      */
771     function _baseURI() internal view virtual returns (string memory) {
772         return "";
773     }
774 
775     /**
776      * @dev See {IERC721-approve}.
777      */
778     function approve(address to, uint256 tokenId) public virtual override {
779         address owner = ERC721.ownerOf(tokenId);
780         require(to != owner, "ERC721: approval to current owner");
781 
782         require(
783             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
784             "ERC721: approve caller is not owner nor approved for all"
785         );
786 
787         _approve(to, tokenId);
788     }
789 
790     /**
791      * @dev See {IERC721-getApproved}.
792      */
793     function getApproved(uint256 tokenId) public view virtual override returns (address) {
794         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
795 
796         return _tokenApprovals[tokenId];
797     }
798 
799     /**
800      * @dev See {IERC721-setApprovalForAll}.
801      */
802     function setApprovalForAll(address operator, bool approved) public virtual override {
803         _setApprovalForAll(_msgSender(), operator, approved);
804     }
805 
806     /**
807      * @dev See {IERC721-isApprovedForAll}.
808      */
809     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
810         return _operatorApprovals[owner][operator];
811     }
812 
813     /**
814      * @dev See {IERC721-transferFrom}.
815      */
816     function transferFrom(
817         address from,
818         address to,
819         uint256 tokenId
820     ) public virtual override {
821         //solhint-disable-next-line max-line-length
822         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
823 
824         _transfer(from, to, tokenId);
825     }
826 
827     /**
828      * @dev See {IERC721-safeTransferFrom}.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public virtual override {
835         safeTransferFrom(from, to, tokenId, "");
836     }
837 
838     /**
839      * @dev See {IERC721-safeTransferFrom}.
840      */
841     function safeTransferFrom(
842         address from,
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) public virtual override {
847         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
848         _safeTransfer(from, to, tokenId, _data);
849     }
850 
851     /**
852      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
853      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
854      *
855      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
856      *
857      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
858      * implement alternative mechanisms to perform token transfer, such as signature-based.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must exist and be owned by `from`.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _safeTransfer(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes memory _data
874     ) internal virtual {
875         _transfer(from, to, tokenId);
876         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
877     }
878 
879     /**
880      * @dev Returns whether `tokenId` exists.
881      *
882      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
883      *
884      * Tokens start existing when they are minted (`_mint`),
885      * and stop existing when they are burned (`_burn`).
886      */
887     function _exists(uint256 tokenId) internal view virtual returns (bool) {
888         return _owners[tokenId] != address(0);
889     }
890 
891     /**
892      * @dev Returns whether `spender` is allowed to manage `tokenId`.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      */
898     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
899         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
900         address owner = ERC721.ownerOf(tokenId);
901         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
902     }
903 
904     /**
905      * @dev Safely mints `tokenId` and transfers it to `to`.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must not exist.
910      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _safeMint(address to, uint256 tokenId) internal virtual {
915         _safeMint(to, tokenId, "");
916     }
917 
918     /**
919      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
920      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
921      */
922     function _safeMint(
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) internal virtual {
927         _mint(to, tokenId);
928         require(
929             _checkOnERC721Received(address(0), to, tokenId, _data),
930             "ERC721: transfer to non ERC721Receiver implementer"
931         );
932     }
933 
934     /**
935      * @dev Mints `tokenId` and transfers it to `to`.
936      *
937      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
938      *
939      * Requirements:
940      *
941      * - `tokenId` must not exist.
942      * - `to` cannot be the zero address.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _mint(address to, uint256 tokenId) internal virtual {
947         require(to != address(0), "ERC721: mint to the zero address");
948         require(!_exists(tokenId), "ERC721: token already minted");
949 
950         _beforeTokenTransfer(address(0), to, tokenId);
951 
952         _balances[to] += 1;
953         _owners[tokenId] = to;
954 
955         emit Transfer(address(0), to, tokenId);
956 
957         _afterTokenTransfer(address(0), to, tokenId);
958     }
959 
960     /**
961      * @dev Destroys `tokenId`.
962      * The approval is cleared when the token is burned.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _burn(uint256 tokenId) internal virtual {
971         address owner = ERC721.ownerOf(tokenId);
972 
973         _beforeTokenTransfer(owner, address(0), tokenId);
974 
975         // Clear approvals
976         _approve(address(0), tokenId);
977 
978         _balances[owner] -= 1;
979         delete _owners[tokenId];
980 
981         emit Transfer(owner, address(0), tokenId);
982 
983         _afterTokenTransfer(owner, address(0), tokenId);
984     }
985 
986     /**
987      * @dev Transfers `tokenId` from `from` to `to`.
988      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must be owned by `from`.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _transfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) internal virtual {
1002         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1003         require(to != address(0), "ERC721: transfer to the zero address");
1004 
1005         _beforeTokenTransfer(from, to, tokenId);
1006 
1007         // Clear approvals from the previous owner
1008         _approve(address(0), tokenId);
1009 
1010         _balances[from] -= 1;
1011         _balances[to] += 1;
1012         _owners[tokenId] = to;
1013 
1014         emit Transfer(from, to, tokenId);
1015 
1016         _afterTokenTransfer(from, to, tokenId);
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
1096 
1097     /**
1098      * @dev Hook that is called after any transfer of tokens. This includes
1099      * minting and burning.
1100      *
1101      * Calling conditions:
1102      *
1103      * - when `from` and `to` are both non-zero.
1104      * - `from` and `to` are never both zero.
1105      *
1106      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1107      */
1108     function _afterTokenTransfer(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) internal virtual {}
1113 }
1114 
1115 // File: seagull.sol
1116 
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 contract SeagullFinds is ERC721, Ownable {
1121 
1122     IERC721 AlphaBetty = IERC721(0x6d05064fe99e40F1C3464E7310A23FFADed56E20);
1123 
1124     string private baseURI;
1125     string public SEAGULL_PROVENANCE;
1126 
1127     uint16 public maxSupply = 10000;
1128     uint16 private supply = 0;
1129 
1130     bool public paused = true;
1131     bool public mintIsBurned = false;
1132     
1133     constructor() ERC721("Seagull Finds", "SEAGULL") {}
1134 
1135     modifier mintCompliance {
1136         require(!mintIsBurned, "Minting has ended");
1137         require(!paused, "Minting is not active");
1138         _;
1139     }
1140 
1141     function mintSeagull(uint id) public mintCompliance {
1142         require(AlphaBetty.ownerOf(id) == msg.sender, "You have to own this AlphaBetty with this id");
1143         unchecked {
1144             supply += 1;
1145         }
1146         _safeMint(msg.sender, id);
1147     }
1148 
1149     function mintSeagulls(uint[] memory ids) public mintCompliance {
1150         for(uint i = 0; i < ids.length; i++){
1151             require(AlphaBetty.ownerOf(ids[i]) == msg.sender,"You don't own these AlphaBettys");
1152             _safeMint(msg.sender, ids[i]);
1153         }
1154         unchecked {
1155             supply += uint16(ids.length);
1156         }
1157     }
1158 
1159     function burnSeagulls() public onlyOwner {
1160         maxSupply = supply;
1161         mintIsBurned = true;
1162     }
1163 
1164     function tokenRedeemed(uint id) public view returns (bool) {
1165         require(id<10000,"Out of bound");
1166         return _exists(id);
1167     }
1168 
1169     function togglePause() public onlyOwner {
1170         paused = !paused;
1171     }
1172 
1173     function totalSupply() public view returns (uint256) {
1174         return supply;
1175     }
1176 
1177     function mintForAddress(uint id, address _receiver) public onlyOwner {
1178         require(!mintIsBurned, "Minting has ended");
1179         require(paused, "Mint must be stopped");
1180         require(id<10000, "Out of bound");
1181         unchecked {
1182             supply += 1;
1183         }
1184         _safeMint(_receiver, id);
1185     }
1186 
1187     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1188         uint256 ownerTokenCount = balanceOf(_owner);
1189         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1190         uint256 currentTokenId = 0;
1191         uint256 ownedTokenIndex = 0;
1192 
1193         while (ownedTokenIndex < ownerTokenCount && currentTokenId < 10000) {
1194             if(_exists(currentTokenId)){
1195                 address currentTokenOwner = ownerOf(currentTokenId);
1196 
1197                 if (currentTokenOwner == _owner) {
1198                     ownedTokenIds[ownedTokenIndex] = currentTokenId;
1199                     ownedTokenIndex++;
1200                 }
1201             }
1202             currentTokenId++;
1203         }
1204         return ownedTokenIds;
1205     }
1206 
1207     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1208         SEAGULL_PROVENANCE = provenanceHash;
1209     }
1210 
1211     function _baseURI() internal view override returns (string memory) {
1212       return baseURI;
1213     }
1214     
1215     function setBaseURI(string memory uri) public onlyOwner {
1216       baseURI = uri;
1217     }
1218 }