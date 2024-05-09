1 // File: contracts/bcbears.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/Address.sol
180 
181 
182 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      */
207     function isContract(address account) internal view returns (bool) {
208         // This method relies on extcodesize, which returns 0 for contracts in
209         // construction, since the code is only stored at the end of the
210         // constructor execution.
211 
212         uint256 size;
213         assembly {
214             size := extcodesize(account)
215         }
216         return size > 0;
217     }
218 
219     /**
220      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
221      * `recipient`, forwarding all available gas and reverting on errors.
222      *
223      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
224      * of certain opcodes, possibly making contracts go over the 2300 gas limit
225      * imposed by `transfer`, making them unable to receive funds via
226      * `transfer`. {sendValue} removes this limitation.
227      *
228      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
229      *
230      * IMPORTANT: because control is transferred to `recipient`, care must be
231      * taken to not create reentrancy vulnerabilities. Consider using
232      * {ReentrancyGuard} or the
233      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
234      */
235     function sendValue(address payable recipient, uint256 amount) internal {
236         require(address(this).balance >= amount, "Address: insufficient balance");
237 
238         (bool success, ) = recipient.call{value: amount}("");
239         require(success, "Address: unable to send value, recipient may have reverted");
240     }
241 
242     /**
243      * @dev Performs a Solidity function call using a low level `call`. A
244      * plain `call` is an unsafe replacement for a function call: use this
245      * function instead.
246      *
247      * If `target` reverts with a revert reason, it is bubbled up by this
248      * function (like regular Solidity function calls).
249      *
250      * Returns the raw returned data. To convert to the expected return value,
251      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
252      *
253      * Requirements:
254      *
255      * - `target` must be a contract.
256      * - calling `target` with `data` must not revert.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionCall(target, data, "Address: low-level call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
266      * `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, 0, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but also transferring `value` wei to `target`.
281      *
282      * Requirements:
283      *
284      * - the calling contract must have an ETH balance of at least `value`.
285      * - the called Solidity function must be `payable`.
286      *
287      * _Available since v3.1._
288      */
289     function functionCallWithValue(
290         address target,
291         bytes memory data,
292         uint256 value
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
299      * with `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(
304         address target,
305         bytes memory data,
306         uint256 value,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         require(address(this).balance >= value, "Address: insufficient balance for call");
310         require(isContract(target), "Address: call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.call{value: value}(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but performing a static call.
319      *
320      * _Available since v3.3._
321      */
322     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
323         return functionStaticCall(target, data, "Address: low-level static call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal view returns (bytes memory) {
337         require(isContract(target), "Address: static call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.staticcall(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a delegate call.
346      *
347      * _Available since v3.4._
348      */
349     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(isContract(target), "Address: delegate call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.delegatecall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
372      * revert reason using the provided one.
373      *
374      * _Available since v4.3._
375      */
376     function verifyCallResult(
377         bool success,
378         bytes memory returndata,
379         string memory errorMessage
380     ) internal pure returns (bytes memory) {
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @title ERC721 token receiver interface
408  * @dev Interface for any contract that wants to support safeTransfers
409  * from ERC721 asset contracts.
410  */
411 interface IERC721Receiver {
412     /**
413      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
414      * by `operator` from `from`, this function is called.
415      *
416      * It must return its Solidity selector to confirm the token transfer.
417      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
418      *
419      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
420      */
421     function onERC721Received(
422         address operator,
423         address from,
424         uint256 tokenId,
425         bytes calldata data
426     ) external returns (bytes4);
427 }
428 
429 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
430 
431 
432 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 /**
437  * @dev Interface of the ERC165 standard, as defined in the
438  * https://eips.ethereum.org/EIPS/eip-165[EIP].
439  *
440  * Implementers can declare support of contract interfaces, which can then be
441  * queried by others ({ERC165Checker}).
442  *
443  * For an implementation, see {ERC165}.
444  */
445 interface IERC165 {
446     /**
447      * @dev Returns true if this contract implements the interface defined by
448      * `interfaceId`. See the corresponding
449      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
450      * to learn more about how these ids are created.
451      *
452      * This function call must use less than 30 000 gas.
453      */
454     function supportsInterface(bytes4 interfaceId) external view returns (bool);
455 }
456 
457 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @dev Implementation of the {IERC165} interface.
467  *
468  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
469  * for the additional interface id that will be supported. For example:
470  *
471  * ```solidity
472  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
474  * }
475  * ```
476  *
477  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
478  */
479 abstract contract ERC165 is IERC165 {
480     /**
481      * @dev See {IERC165-supportsInterface}.
482      */
483     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484         return interfaceId == type(IERC165).interfaceId;
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Required interface of an ERC721 compliant contract.
498  */
499 interface IERC721 is IERC165 {
500     /**
501      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
502      */
503     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
504 
505     /**
506      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
507      */
508     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
512      */
513     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
514 
515     /**
516      * @dev Returns the number of tokens in ``owner``'s account.
517      */
518     function balanceOf(address owner) external view returns (uint256 balance);
519 
520     /**
521      * @dev Returns the owner of the `tokenId` token.
522      *
523      * Requirements:
524      *
525      * - `tokenId` must exist.
526      */
527     function ownerOf(uint256 tokenId) external view returns (address owner);
528 
529     /**
530      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
531      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must exist and be owned by `from`.
538      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
539      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540      *
541      * Emits a {Transfer} event.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId
547     ) external;
548 
549     /**
550      * @dev Transfers `tokenId` token from `from` to `to`.
551      *
552      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      *
561      * Emits a {Transfer} event.
562      */
563     function transferFrom(
564         address from,
565         address to,
566         uint256 tokenId
567     ) external;
568 
569     /**
570      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
571      * The approval is cleared when the token is transferred.
572      *
573      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
574      *
575      * Requirements:
576      *
577      * - The caller must own the token or be an approved operator.
578      * - `tokenId` must exist.
579      *
580      * Emits an {Approval} event.
581      */
582     function approve(address to, uint256 tokenId) external;
583 
584     /**
585      * @dev Returns the account approved for `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function getApproved(uint256 tokenId) external view returns (address operator);
592 
593     /**
594      * @dev Approve or remove `operator` as an operator for the caller.
595      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
596      *
597      * Requirements:
598      *
599      * - The `operator` cannot be the caller.
600      *
601      * Emits an {ApprovalForAll} event.
602      */
603     function setApprovalForAll(address operator, bool _approved) external;
604 
605     /**
606      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
607      *
608      * See {setApprovalForAll}
609      */
610     function isApprovedForAll(address owner, address operator) external view returns (bool);
611 
612     /**
613      * @dev Safely transfers `tokenId` token from `from` to `to`.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId,
629         bytes calldata data
630     ) external;
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
643  * @dev See https://eips.ethereum.org/EIPS/eip-721
644  */
645 interface IERC721Enumerable is IERC721 {
646     /**
647      * @dev Returns the total amount of tokens stored by the contract.
648      */
649     function totalSupply() external view returns (uint256);
650 
651     /**
652      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
653      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
654      */
655     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
656 
657     /**
658      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
659      * Use along with {totalSupply} to enumerate all tokens.
660      */
661     function tokenByIndex(uint256 index) external view returns (uint256);
662 }
663 
664 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
674  * @dev See https://eips.ethereum.org/EIPS/eip-721
675  */
676 interface IERC721Metadata is IERC721 {
677     /**
678      * @dev Returns the token collection name.
679      */
680     function name() external view returns (string memory);
681 
682     /**
683      * @dev Returns the token collection symbol.
684      */
685     function symbol() external view returns (string memory);
686 
687     /**
688      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
689      */
690     function tokenURI(uint256 tokenId) external view returns (string memory);
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
830         _setApprovalForAll(_msgSender(), operator, approved);
831     }
832 
833     /**
834      * @dev See {IERC721-isApprovedForAll}.
835      */
836     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
837         return _operatorApprovals[owner][operator];
838     }
839 
840     /**
841      * @dev See {IERC721-transferFrom}.
842      */
843     function transferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         //solhint-disable-next-line max-line-length
849         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
850 
851         _transfer(from, to, tokenId);
852     }
853 
854     /**
855      * @dev See {IERC721-safeTransferFrom}.
856      */
857     function safeTransferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public virtual override {
862         safeTransferFrom(from, to, tokenId, "");
863     }
864 
865     /**
866      * @dev See {IERC721-safeTransferFrom}.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId,
872         bytes memory _data
873     ) public virtual override {
874         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
875         _safeTransfer(from, to, tokenId, _data);
876     }
877 
878     /**
879      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
880      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
881      *
882      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
883      *
884      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
885      * implement alternative mechanisms to perform token transfer, such as signature-based.
886      *
887      * Requirements:
888      *
889      * - `from` cannot be the zero address.
890      * - `to` cannot be the zero address.
891      * - `tokenId` token must exist and be owned by `from`.
892      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _safeTransfer(
897         address from,
898         address to,
899         uint256 tokenId,
900         bytes memory _data
901     ) internal virtual {
902         _transfer(from, to, tokenId);
903         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
904     }
905 
906     /**
907      * @dev Returns whether `tokenId` exists.
908      *
909      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
910      *
911      * Tokens start existing when they are minted (`_mint`),
912      * and stop existing when they are burned (`_burn`).
913      */
914     function _exists(uint256 tokenId) internal view virtual returns (bool) {
915         return _owners[tokenId] != address(0);
916     }
917 
918     /**
919      * @dev Returns whether `spender` is allowed to manage `tokenId`.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      */
925     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
926         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
927         address owner = ERC721.ownerOf(tokenId);
928         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
929     }
930 
931     /**
932      * @dev Safely mints `tokenId` and transfers it to `to`.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must not exist.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _safeMint(address to, uint256 tokenId) internal virtual {
942         _safeMint(to, tokenId, "");
943     }
944 
945     /**
946      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
947      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
948      */
949     function _safeMint(
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) internal virtual {
954         _mint(to, tokenId);
955         require(
956             _checkOnERC721Received(address(0), to, tokenId, _data),
957             "ERC721: transfer to non ERC721Receiver implementer"
958         );
959     }
960 
961     /**
962      * @dev Mints `tokenId` and transfers it to `to`.
963      *
964      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
965      *
966      * Requirements:
967      *
968      * - `tokenId` must not exist.
969      * - `to` cannot be the zero address.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _mint(address to, uint256 tokenId) internal virtual {
974         require(to != address(0), "ERC721: mint to the zero address");
975         require(!_exists(tokenId), "ERC721: token already minted");
976 
977         _beforeTokenTransfer(address(0), to, tokenId);
978 
979         _balances[to] += 1;
980         _owners[tokenId] = to;
981 
982         emit Transfer(address(0), to, tokenId);
983     }
984 
985     /**
986      * @dev Destroys `tokenId`.
987      * The approval is cleared when the token is burned.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _burn(uint256 tokenId) internal virtual {
996         address owner = ERC721.ownerOf(tokenId);
997 
998         _beforeTokenTransfer(owner, address(0), tokenId);
999 
1000         // Clear approvals
1001         _approve(address(0), tokenId);
1002 
1003         _balances[owner] -= 1;
1004         delete _owners[tokenId];
1005 
1006         emit Transfer(owner, address(0), tokenId);
1007     }
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must be owned by `from`.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _transfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) internal virtual {
1025         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1026         require(to != address(0), "ERC721: transfer to the zero address");
1027 
1028         _beforeTokenTransfer(from, to, tokenId);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId);
1032 
1033         _balances[from] -= 1;
1034         _balances[to] += 1;
1035         _owners[tokenId] = to;
1036 
1037         emit Transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev Approve `to` to operate on `tokenId`
1042      *
1043      * Emits a {Approval} event.
1044      */
1045     function _approve(address to, uint256 tokenId) internal virtual {
1046         _tokenApprovals[tokenId] = to;
1047         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Approve `operator` to operate on all of `owner` tokens
1052      *
1053      * Emits a {ApprovalForAll} event.
1054      */
1055     function _setApprovalForAll(
1056         address owner,
1057         address operator,
1058         bool approved
1059     ) internal virtual {
1060         require(owner != operator, "ERC721: approve to caller");
1061         _operatorApprovals[owner][operator] = approved;
1062         emit ApprovalForAll(owner, operator, approved);
1063     }
1064 
1065     /**
1066      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1067      * The call is not executed if the target address is not a contract.
1068      *
1069      * @param from address representing the previous owner of the given token ID
1070      * @param to target address that will receive the tokens
1071      * @param tokenId uint256 ID of the token to be transferred
1072      * @param _data bytes optional data to send along with the call
1073      * @return bool whether the call correctly returned the expected magic value
1074      */
1075     function _checkOnERC721Received(
1076         address from,
1077         address to,
1078         uint256 tokenId,
1079         bytes memory _data
1080     ) private returns (bool) {
1081         if (to.isContract()) {
1082             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1083                 return retval == IERC721Receiver.onERC721Received.selector;
1084             } catch (bytes memory reason) {
1085                 if (reason.length == 0) {
1086                     revert("ERC721: transfer to non ERC721Receiver implementer");
1087                 } else {
1088                     assembly {
1089                         revert(add(32, reason), mload(reason))
1090                     }
1091                 }
1092             }
1093         } else {
1094             return true;
1095         }
1096     }
1097 
1098     /**
1099      * @dev Hook that is called before any token transfer. This includes minting
1100      * and burning.
1101      *
1102      * Calling conditions:
1103      *
1104      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1105      * transferred to `to`.
1106      * - When `from` is zero, `tokenId` will be minted for `to`.
1107      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1108      * - `from` and `to` are never both zero.
1109      *
1110      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1111      */
1112     function _beforeTokenTransfer(
1113         address from,
1114         address to,
1115         uint256 tokenId
1116     ) internal virtual {}
1117 }
1118 
1119 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1120 
1121 
1122 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 
1127 
1128 /**
1129  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1130  * enumerability of all the token ids in the contract as well as all token ids owned by each
1131  * account.
1132  */
1133 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1134     // Mapping from owner to list of owned token IDs
1135     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1136 
1137     // Mapping from token ID to index of the owner tokens list
1138     mapping(uint256 => uint256) private _ownedTokensIndex;
1139 
1140     // Array with all token ids, used for enumeration
1141     uint256[] private _allTokens;
1142 
1143     // Mapping from token id to position in the allTokens array
1144     mapping(uint256 => uint256) private _allTokensIndex;
1145 
1146     /**
1147      * @dev See {IERC165-supportsInterface}.
1148      */
1149     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1150         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1155      */
1156     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1157         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1158         return _ownedTokens[owner][index];
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Enumerable-totalSupply}.
1163      */
1164     function totalSupply() public view virtual override returns (uint256) {
1165         return _allTokens.length;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Enumerable-tokenByIndex}.
1170      */
1171     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1172         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1173         return _allTokens[index];
1174     }
1175 
1176     /**
1177      * @dev Hook that is called before any token transfer. This includes minting
1178      * and burning.
1179      *
1180      * Calling conditions:
1181      *
1182      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1183      * transferred to `to`.
1184      * - When `from` is zero, `tokenId` will be minted for `to`.
1185      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1186      * - `from` cannot be the zero address.
1187      * - `to` cannot be the zero address.
1188      *
1189      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1190      */
1191     function _beforeTokenTransfer(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) internal virtual override {
1196         super._beforeTokenTransfer(from, to, tokenId);
1197 
1198         if (from == address(0)) {
1199             _addTokenToAllTokensEnumeration(tokenId);
1200         } else if (from != to) {
1201             _removeTokenFromOwnerEnumeration(from, tokenId);
1202         }
1203         if (to == address(0)) {
1204             _removeTokenFromAllTokensEnumeration(tokenId);
1205         } else if (to != from) {
1206             _addTokenToOwnerEnumeration(to, tokenId);
1207         }
1208     }
1209 
1210     /**
1211      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1212      * @param to address representing the new owner of the given token ID
1213      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1214      */
1215     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1216         uint256 length = ERC721.balanceOf(to);
1217         _ownedTokens[to][length] = tokenId;
1218         _ownedTokensIndex[tokenId] = length;
1219     }
1220 
1221     /**
1222      * @dev Private function to add a token to this extension's token tracking data structures.
1223      * @param tokenId uint256 ID of the token to be added to the tokens list
1224      */
1225     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1226         _allTokensIndex[tokenId] = _allTokens.length;
1227         _allTokens.push(tokenId);
1228     }
1229 
1230     /**
1231      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1232      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1233      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1234      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1235      * @param from address representing the previous owner of the given token ID
1236      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1237      */
1238     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1239         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1240         // then delete the last slot (swap and pop).
1241 
1242         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1243         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1244 
1245         // When the token to delete is the last token, the swap operation is unnecessary
1246         if (tokenIndex != lastTokenIndex) {
1247             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1248 
1249             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1250             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1251         }
1252 
1253         // This also deletes the contents at the last position of the array
1254         delete _ownedTokensIndex[tokenId];
1255         delete _ownedTokens[from][lastTokenIndex];
1256     }
1257 
1258     /**
1259      * @dev Private function to remove a token from this extension's token tracking data structures.
1260      * This has O(1) time complexity, but alters the order of the _allTokens array.
1261      * @param tokenId uint256 ID of the token to be removed from the tokens list
1262      */
1263     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1264         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1265         // then delete the last slot (swap and pop).
1266 
1267         uint256 lastTokenIndex = _allTokens.length - 1;
1268         uint256 tokenIndex = _allTokensIndex[tokenId];
1269 
1270         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1271         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1272         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1273         uint256 lastTokenId = _allTokens[lastTokenIndex];
1274 
1275         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1276         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1277 
1278         // This also deletes the contents at the last position of the array
1279         delete _allTokensIndex[tokenId];
1280         _allTokens.pop();
1281     }
1282 }
1283 
1284 // File: BB-flat.sol
1285 
1286 
1287 
1288 pragma solidity >=0.7.0 <0.9.0;
1289 
1290 
1291 
1292 contract NFT is ERC721Enumerable, Ownable {
1293   using Strings for uint256;
1294 
1295   string public baseURI;
1296   string public baseExtension = ".json";
1297   string public notRevealedUri;
1298   uint256 public cost = .06 ether;
1299   uint256 public maxSupply = 10000;
1300   uint256 public maxMintAmount = 3;
1301   uint256 public nftPerAddressLimit = 3;
1302   uint256 public presaleSupply = 500;
1303   bool public paused = true;
1304   bool public revealed = true;
1305   bool public onlyWhitelisted = true;
1306   address[] public whitelistedAddresses;
1307   mapping(address => uint256) public addressMintedBalance;
1308 
1309 
1310   constructor(
1311     string memory _name,
1312     string memory _symbol,
1313     string memory _initBaseURI,
1314     string memory _initNotRevealedUri
1315   ) ERC721(_name, _symbol) {
1316     setBaseURI(_initBaseURI);
1317     setNotRevealedURI(_initNotRevealedUri);
1318 
1319   }
1320 
1321   // internal
1322   function _baseURI() internal view virtual override returns (string memory) {
1323     return baseURI;
1324   }
1325 
1326   // public
1327   function mint(uint256 _mintAmount) public payable {
1328     require(!paused, "the contract is paused");
1329     uint256 supply = totalSupply();
1330     require(_mintAmount > 0, "need to mint at least 1 NFT");
1331     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1332     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1333 
1334     if (msg.sender != owner()) {
1335         if(onlyWhitelisted == true) {
1336             require(isWhitelisted(msg.sender), "user is not whitelisted");
1337 
1338         }
1339         
1340         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1341         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1342         require(msg.value >= cost * _mintAmount, "insufficient funds");
1343     }
1344     
1345     for (uint256 i = 1; i <= _mintAmount; i++) {
1346         addressMintedBalance[msg.sender]++;
1347       _safeMint(msg.sender, supply + i);
1348         if (supply + i == presaleSupply) {
1349             paused = true;
1350         }
1351     }
1352   }
1353   
1354   function isWhitelisted(address _user) public view returns (bool) {
1355     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1356       if (whitelistedAddresses[i] == _user) {
1357           return true;
1358       }
1359     }
1360     return false;
1361   }
1362 
1363   function walletOfOwner(address _owner)
1364     public
1365     view
1366     returns (uint256[] memory)
1367   {
1368     uint256 ownerTokenCount = balanceOf(_owner);
1369     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1370     for (uint256 i; i < ownerTokenCount; i++) {
1371       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1372     }
1373     return tokenIds;
1374   }
1375 
1376   function tokenURI(uint256 tokenId)
1377     public
1378     view
1379     virtual
1380     override
1381     returns (string memory)
1382   {
1383     require(
1384       _exists(tokenId),
1385       "ERC721Metadata: URI query for nonexistent token"
1386     );
1387     
1388     if(revealed == false) {
1389         return notRevealedUri;
1390     }
1391 
1392     string memory currentBaseURI = _baseURI();
1393     return bytes(currentBaseURI).length > 0
1394         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1395         : "";
1396   }
1397 
1398   //only owner
1399   function reveal() public onlyOwner {
1400       revealed = true;
1401   }
1402   
1403   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1404     nftPerAddressLimit = _limit;
1405   }
1406 
1407   function setPresaleSupply(uint256 _newPresaleSupply) public onlyOwner {
1408     presaleSupply = _newPresaleSupply;
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
1439   function whitelistUsers(address[] calldata _users) public onlyOwner {
1440     delete whitelistedAddresses;
1441     whitelistedAddresses = _users;
1442   }
1443  
1444   function withdraw() public payable onlyOwner {
1445     // =============================================================================
1446     uint256 p0 = address(this).balance * 3 / 100;
1447     uint256 p1 = address(this).balance * 37 / 100;
1448     uint256 p2 = address(this).balance * 30 / 2 / 100;
1449     uint256 p3 = address(this).balance * 30 / 2 / 100;
1450     uint256 p4 = address(this).balance * 30 / 4 / 100;
1451     uint256 p5 = address(this).balance * 30 / 4 / 100;
1452     uint256 p6 = address(this).balance * 30 / 4 / 100;
1453 
1454     (bool s0, ) = payable(0xA7c8EF131344639F8C4aC295fb6F08695721198b).call{value: p0}("");
1455     require(s0);
1456     (bool s1, ) = payable(0x700e5E296bf36A5a694826e472641BF1c81FC3b3).call{value: p1}("");
1457     require(s1);
1458     (bool s2, ) = payable(0x567a1E928B09F7976d5fF4cF3Feb60593f958335).call{value: p2}("");
1459     require(s2);
1460     (bool s3, ) = payable(0xC85E088f49c240c719FD6E31931a76b1718C2e0b).call{value: p3}("");
1461     require(s3);
1462     (bool s4, ) = payable(0x4c942729c2d10e0ca17770F283ec2C360eaA4140).call{value: p4}("");
1463     require(s4);
1464     (bool s5, ) = payable(0x2cD0B53f32ecaa5b16CE8A0C93227325c74943BB).call{value: p5}("");
1465     require(s5);
1466     (bool s6, ) = payable(0x3228cB2E514943aDD4F0aE2EAD6ceD399996821E).call{value: p6}("");
1467     require(s6);
1468     // =============================================================================
1469     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1470     require(os);
1471     // =============================================================================
1472   }
1473 }