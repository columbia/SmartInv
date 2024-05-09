1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 
11 library Counters {
12     struct Counter {
13         // This variable should never be directly accessed by users of the library: interactions must be restricted to
14         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
15         // this feature: see https://github.com/ethereum/solidity/issues/4637
16         uint256 _value; // default: 0
17     }
18 
19     function current(Counter storage counter) internal view returns (uint256) {
20         return counter._value;
21     }
22 
23     function increment(Counter storage counter) internal {
24         unchecked {
25             counter._value += 1;
26         }
27     }
28 
29     function decrement(Counter storage counter) internal {
30         uint256 value = counter._value;
31         require(value > 0, "Counter: decrement overflow");
32         unchecked {
33             counter._value = value - 1;
34         }
35     }
36 
37     function reset(Counter storage counter) internal {
38         counter._value = 0;
39     }
40 }
41 
42 // File: @openzeppelin/contracts/utils/Strings.sol
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev String operations.
51  */
52 library Strings {
53     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
57      */
58     function toString(uint256 value) internal pure returns (string memory) {
59         // Inspired by OraclizeAPI's implementation - MIT licence
60         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
61 
62         if (value == 0) {
63             return "0";
64         }
65         uint256 temp = value;
66         uint256 digits;
67         while (temp != 0) {
68             digits++;
69             temp /= 10;
70         }
71         bytes memory buffer = new bytes(digits);
72         while (value != 0) {
73             digits -= 1;
74             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
75             value /= 10;
76         }
77         return string(buffer);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
82      */
83     function toHexString(uint256 value) internal pure returns (string memory) {
84         if (value == 0) {
85             return "0x00";
86         }
87         uint256 temp = value;
88         uint256 length = 0;
89         while (temp != 0) {
90             length++;
91             temp >>= 8;
92         }
93         return toHexString(value, length);
94     }
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
98      */
99     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
100         bytes memory buffer = new bytes(2 * length + 2);
101         buffer[0] = "0";
102         buffer[1] = "x";
103         for (uint256 i = 2 * length + 1; i > 1; --i) {
104             buffer[i] = _HEX_SYMBOLS[value & 0xf];
105             value >>= 4;
106         }
107         require(value == 0, "Strings: hex length insufficient");
108         return string(buffer);
109     }
110 }
111 
112 // File: @openzeppelin/contracts/utils/Context.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 
139 // File: @openzeppelin/contracts/access/Ownable.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 
147 /**
148  * @dev Contract module which provides a basic access control mechanism, where
149  * there is an account (an owner) that can be granted exclusive access to
150  * specific functions.
151  *
152  * By default, the owner account will be the one that deploys the contract. This
153  * can later be changed with {transferOwnership}.
154  *
155  * This module is used through inheritance. It will make available the modifier
156  * `onlyOwner`, which can be applied to your functions to restrict their use to
157  * the owner.
158  */
159 abstract contract Ownable is Context {
160     address private _owner;
161 
162     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164     /**
165      * @dev Initializes the contract setting the deployer as the initial owner.
166      */
167     constructor() {
168         _transferOwnership(_msgSender());
169     }
170 
171     /**
172      * @dev Returns the address of the current owner.
173      */
174     function owner() public view virtual returns (address) {
175         return _owner;
176     }
177 
178     /**
179      * @dev Throws if called by any account other than the owner.
180      */
181     modifier onlyOwner() {
182         require(owner() == _msgSender(), "Ownable: caller is not the owner");
183         _;
184     }
185 
186     /**
187      * @dev Leaves the contract without owner. It will not be possible to call
188      * `onlyOwner` functions anymore. Can only be called by the current owner.
189      *
190      * NOTE: Renouncing ownership will leave the contract without an owner,
191      * thereby removing any functionality that is only available to the owner.
192      */
193     function renounceOwnership() public virtual onlyOwner {
194         _transferOwnership(address(0));
195     }
196 
197     /**
198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
199      * Can only be called by the current owner.
200      */
201     function transferOwnership(address newOwner) public virtual onlyOwner {
202         require(newOwner != address(0), "Ownable: new owner is the zero address");
203         _transferOwnership(newOwner);
204     }
205 
206     /**
207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
208      * Internal function without access restriction.
209      */
210     function _transferOwnership(address newOwner) internal virtual {
211         address oldOwner = _owner;
212         _owner = newOwner;
213         emit OwnershipTransferred(oldOwner, newOwner);
214     }
215 }
216 
217 // File: @openzeppelin/contracts/utils/Address.sol
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Collection of functions related to the address type
226  */
227 library Address {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      * ====
244      */
245     function isContract(address account) internal view returns (bool) {
246         // This method relies on extcodesize, which returns 0 for contracts in
247         // construction, since the code is only stored at the end of the
248         // constructor execution.
249 
250         uint256 size;
251         assembly {
252             size := extcodesize(account)
253         }
254         return size > 0;
255     }
256 
257     /**
258      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
259      * `recipient`, forwarding all available gas and reverting on errors.
260      *
261      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
262      * of certain opcodes, possibly making contracts go over the 2300 gas limit
263      * imposed by `transfer`, making them unable to receive funds via
264      * `transfer`. {sendValue} removes this limitation.
265      *
266      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
267      *
268      * IMPORTANT: because control is transferred to `recipient`, care must be
269      * taken to not create reentrancy vulnerabilities. Consider using
270      * {ReentrancyGuard} or the
271      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
272      */
273     function sendValue(address payable recipient, uint256 amount) internal {
274         require(address(this).balance >= amount, "Address: insufficient balance");
275 
276         (bool success, ) = recipient.call{value: amount}("");
277         require(success, "Address: unable to send value, recipient may have reverted");
278     }
279 
280     /**
281      * @dev Performs a Solidity function call using a low level `call`. A
282      * plain `call` is an unsafe replacement for a function call: use this
283      * function instead.
284      *
285      * If `target` reverts with a revert reason, it is bubbled up by this
286      * function (like regular Solidity function calls).
287      *
288      * Returns the raw returned data. To convert to the expected return value,
289      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
290      *
291      * Requirements:
292      *
293      * - `target` must be a contract.
294      * - calling `target` with `data` must not revert.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
299         return functionCall(target, data, "Address: low-level call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
304      * `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(
309         address target,
310         bytes memory data,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         return functionCallWithValue(target, data, 0, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but also transferring `value` wei to `target`.
319      *
320      * Requirements:
321      *
322      * - the calling contract must have an ETH balance of at least `value`.
323      * - the called Solidity function must be `payable`.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
337      * with `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         require(isContract(target), "Address: call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.call{value: value}(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a static call.
357      *
358      * _Available since v3.3._
359      */
360     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
361         return functionStaticCall(target, data, "Address: low-level static call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal view returns (bytes memory) {
375         require(isContract(target), "Address: static call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.staticcall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a delegate call.
384      *
385      * _Available since v3.4._
386      */
387     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         require(isContract(target), "Address: delegate call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.delegatecall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
410      * revert reason using the provided one.
411      *
412      * _Available since v4.3._
413      */
414     function verifyCallResult(
415         bool success,
416         bytes memory returndata,
417         string memory errorMessage
418     ) internal pure returns (bytes memory) {
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 assembly {
427                     let returndata_size := mload(returndata)
428                     revert(add(32, returndata), returndata_size)
429                 }
430             } else {
431                 revert(errorMessage);
432             }
433         }
434     }
435 }
436 
437 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
438 
439 
440 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 /**
445  * @title ERC721 token receiver interface
446  * @dev Interface for any contract that wants to support safeTransfers
447  * from ERC721 asset contracts.
448  */
449 interface IERC721Receiver {
450     /**
451      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
452      * by `operator` from `from`, this function is called.
453      *
454      * It must return its Solidity selector to confirm the token transfer.
455      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
456      *
457      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
458      */
459     function onERC721Received(
460         address operator,
461         address from,
462         uint256 tokenId,
463         bytes calldata data
464     ) external returns (bytes4);
465 }
466 
467 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @dev Interface of the ERC165 standard, as defined in the
476  * https://eips.ethereum.org/EIPS/eip-165[EIP].
477  *
478  * Implementers can declare support of contract interfaces, which can then be
479  * queried by others ({ERC165Checker}).
480  *
481  * For an implementation, see {ERC165}.
482  */
483 interface IERC165 {
484     /**
485      * @dev Returns true if this contract implements the interface defined by
486      * `interfaceId`. See the corresponding
487      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
488      * to learn more about how these ids are created.
489      *
490      * This function call must use less than 30 000 gas.
491      */
492     function supportsInterface(bytes4 interfaceId) external view returns (bool);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Implementation of the {IERC165} interface.
505  *
506  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
507  * for the additional interface id that will be supported. For example:
508  *
509  * ```solidity
510  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
512  * }
513  * ```
514  *
515  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
516  */
517 abstract contract ERC165 is IERC165 {
518     /**
519      * @dev See {IERC165-supportsInterface}.
520      */
521     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522         return interfaceId == type(IERC165).interfaceId;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Required interface of an ERC721 compliant contract.
536  */
537 interface IERC721 is IERC165 {
538     /**
539      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
540      */
541     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
542 
543     /**
544      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
545      */
546     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
547 
548     /**
549      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
550      */
551     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
552 
553     /**
554      * @dev Returns the number of tokens in ``owner``'s account.
555      */
556     function balanceOf(address owner) external view returns (uint256 balance);
557 
558     /**
559      * @dev Returns the owner of the `tokenId` token.
560      *
561      * Requirements:
562      *
563      * - `tokenId` must exist.
564      */
565     function ownerOf(uint256 tokenId) external view returns (address owner);
566 
567     /**
568      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
569      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
570      *
571      * Requirements:
572      *
573      * - `from` cannot be the zero address.
574      * - `to` cannot be the zero address.
575      * - `tokenId` token must exist and be owned by `from`.
576      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
577      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
578      *
579      * Emits a {Transfer} event.
580      */
581     function safeTransferFrom(
582         address from,
583         address to,
584         uint256 tokenId
585     ) external;
586 
587     /**
588      * @dev Transfers `tokenId` token from `from` to `to`.
589      *
590      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must be owned by `from`.
597      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
598      *
599      * Emits a {Transfer} event.
600      */
601     function transferFrom(
602         address from,
603         address to,
604         uint256 tokenId
605     ) external;
606 
607     /**
608      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
609      * The approval is cleared when the token is transferred.
610      *
611      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
612      *
613      * Requirements:
614      *
615      * - The caller must own the token or be an approved operator.
616      * - `tokenId` must exist.
617      *
618      * Emits an {Approval} event.
619      */
620     function approve(address to, uint256 tokenId) external;
621 
622     /**
623      * @dev Returns the account approved for `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function getApproved(uint256 tokenId) external view returns (address operator);
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
644      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
645      *
646      * See {setApprovalForAll}
647      */
648     function isApprovedForAll(address owner, address operator) external view returns (bool);
649 
650     /**
651      * @dev Safely transfers `tokenId` token from `from` to `to`.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660      *
661      * Emits a {Transfer} event.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId,
667         bytes calldata data
668     ) external;
669 }
670 
671 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 
679 /**
680  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
681  * @dev See https://eips.ethereum.org/EIPS/eip-721
682  */
683 interface IERC721Metadata is IERC721 {
684     /**
685      * @dev Returns the token collection name.
686      */
687     function name() external view returns (string memory);
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() external view returns (string memory);
693 
694     /**
695      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
696      */
697     function tokenURI(uint256 tokenId) external view returns (string memory);
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 
709 
710 
711 
712 
713 
714 /**
715  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
716  * the Metadata extension, but not including the Enumerable extension, which is available separately as
717  * {ERC721Enumerable}.
718  */
719 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
720     using Address for address;
721     using Strings for uint256;
722 
723     // Token name
724     string private _name;
725 
726     // Token symbol
727     string private _symbol;
728 
729     // Mapping from token ID to owner address
730     mapping(uint256 => address) private _owners;
731 
732     // Mapping owner address to token count
733     mapping(address => uint256) private _balances;
734 
735     // Mapping from token ID to approved address
736     mapping(uint256 => address) private _tokenApprovals;
737 
738     // Mapping from owner to operator approvals
739     mapping(address => mapping(address => bool)) private _operatorApprovals;
740 
741     /**
742      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
743      */
744     constructor(string memory name_, string memory symbol_) {
745         _name = name_;
746         _symbol = symbol_;
747     }
748 
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
753         return
754             interfaceId == type(IERC721).interfaceId ||
755             interfaceId == type(IERC721Metadata).interfaceId ||
756             super.supportsInterface(interfaceId);
757     }
758 
759     /**
760      * @dev See {IERC721-balanceOf}.
761      */
762     function balanceOf(address owner) public view virtual override returns (uint256) {
763         require(owner != address(0), "ERC721: balance query for the zero address");
764         return _balances[owner];
765     }
766 
767     /**
768      * @dev See {IERC721-ownerOf}.
769      */
770     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
771         address owner = _owners[tokenId];
772         require(owner != address(0), "ERC721: owner query for nonexistent token");
773         return owner;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-name}.
778      */
779     function name() public view virtual override returns (string memory) {
780         return _name;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-symbol}.
785      */
786     function symbol() public view virtual override returns (string memory) {
787         return _symbol;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-tokenURI}.
792      */
793     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
794         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
795 
796         string memory baseURI = _baseURI();
797         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
798     }
799 
800     /**
801      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
802      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
803      * by default, can be overriden in child contracts.
804      */
805     function _baseURI() internal view virtual returns (string memory) {
806         return "";
807     }
808 
809     /**
810      * @dev See {IERC721-approve}.
811      */
812     function approve(address to, uint256 tokenId) public virtual override {
813         address owner = ERC721.ownerOf(tokenId);
814         require(to != owner, "ERC721: approval to current owner");
815 
816         require(
817             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
818             "ERC721: approve caller is not owner nor approved for all"
819         );
820 
821         _approve(to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-getApproved}.
826      */
827     function getApproved(uint256 tokenId) public view virtual override returns (address) {
828         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
829 
830         return _tokenApprovals[tokenId];
831     }
832 
833     /**
834      * @dev See {IERC721-setApprovalForAll}.
835      */
836     function setApprovalForAll(address operator, bool approved) public virtual override {
837         _setApprovalForAll(_msgSender(), operator, approved);
838     }
839 
840     /**
841      * @dev See {IERC721-isApprovedForAll}.
842      */
843     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
844         return _operatorApprovals[owner][operator];
845     }
846 
847     /**
848      * @dev See {IERC721-transferFrom}.
849      */
850     function transferFrom(
851         address from,
852         address to,
853         uint256 tokenId
854     ) public virtual override {
855         //solhint-disable-next-line max-line-length
856         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
857 
858         _transfer(from, to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         safeTransferFrom(from, to, tokenId, "");
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) public virtual override {
881         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
882         _safeTransfer(from, to, tokenId, _data);
883     }
884 
885     /**
886      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
887      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
888      *
889      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
890      *
891      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
892      * implement alternative mechanisms to perform token transfer, such as signature-based.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must exist and be owned by `from`.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _safeTransfer(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) internal virtual {
909         _transfer(from, to, tokenId);
910         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
911     }
912 
913     /**
914      * @dev Returns whether `tokenId` exists.
915      *
916      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
917      *
918      * Tokens start existing when they are minted (`_mint`),
919      * and stop existing when they are burned (`_burn`).
920      */
921     function _exists(uint256 tokenId) internal view virtual returns (bool) {
922         return _owners[tokenId] != address(0);
923     }
924 
925     /**
926      * @dev Returns whether `spender` is allowed to manage `tokenId`.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      */
932     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
933         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
934         address owner = ERC721.ownerOf(tokenId);
935         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
936     }
937 
938     /**
939      * @dev Safely mints `tokenId` and transfers it to `to`.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must not exist.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(address to, uint256 tokenId) internal virtual {
949         _safeMint(to, tokenId, "");
950     }
951 
952     /**
953      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
954      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
955      */
956     function _safeMint(
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) internal virtual {
961         _mint(to, tokenId);
962         require(
963             _checkOnERC721Received(address(0), to, tokenId, _data),
964             "ERC721: transfer to non ERC721Receiver implementer"
965         );
966     }
967 
968     /**
969      * @dev Mints `tokenId` and transfers it to `to`.
970      *
971      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - `to` cannot be the zero address.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _mint(address to, uint256 tokenId) internal virtual {
981         require(to != address(0), "ERC721: mint to the zero address");
982         require(!_exists(tokenId), "ERC721: token already minted");
983 
984         _beforeTokenTransfer(address(0), to, tokenId);
985 
986         _balances[to] += 1;
987         _owners[tokenId] = to;
988 
989         emit Transfer(address(0), to, tokenId);
990     }
991 
992     /**
993      * @dev Destroys `tokenId`.
994      * The approval is cleared when the token is burned.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _burn(uint256 tokenId) internal virtual {
1003         address owner = ERC721.ownerOf(tokenId);
1004 
1005         _beforeTokenTransfer(owner, address(0), tokenId);
1006 
1007         // Clear approvals
1008         _approve(address(0), tokenId);
1009 
1010         _balances[owner] -= 1;
1011         delete _owners[tokenId];
1012 
1013         emit Transfer(owner, address(0), tokenId);
1014     }
1015 
1016     /**
1017      * @dev Transfers `tokenId` from `from` to `to`.
1018      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must be owned by `from`.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _transfer(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) internal virtual {
1032         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1033         require(to != address(0), "ERC721: transfer to the zero address");
1034 
1035         _beforeTokenTransfer(from, to, tokenId);
1036 
1037         // Clear approvals from the previous owner
1038         _approve(address(0), tokenId);
1039 
1040         _balances[from] -= 1;
1041         _balances[to] += 1;
1042         _owners[tokenId] = to;
1043 
1044         emit Transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev Approve `to` to operate on `tokenId`
1049      *
1050      * Emits a {Approval} event.
1051      */
1052     function _approve(address to, uint256 tokenId) internal virtual {
1053         _tokenApprovals[tokenId] = to;
1054         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Approve `operator` to operate on all of `owner` tokens
1059      *
1060      * Emits a {ApprovalForAll} event.
1061      */
1062     function _setApprovalForAll(
1063         address owner,
1064         address operator,
1065         bool approved
1066     ) internal virtual {
1067         require(owner != operator, "ERC721: approve to caller");
1068         _operatorApprovals[owner][operator] = approved;
1069         emit ApprovalForAll(owner, operator, approved);
1070     }
1071 
1072     /**
1073      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1074      * The call is not executed if the target address is not a contract.
1075      *
1076      * @param from address representing the previous owner of the given token ID
1077      * @param to target address that will receive the tokens
1078      * @param tokenId uint256 ID of the token to be transferred
1079      * @param _data bytes optional data to send along with the call
1080      * @return bool whether the call correctly returned the expected magic value
1081      */
1082     function _checkOnERC721Received(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) private returns (bool) {
1088         if (to.isContract()) {
1089             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1090                 return retval == IERC721Receiver.onERC721Received.selector;
1091             } catch (bytes memory reason) {
1092                 if (reason.length == 0) {
1093                     revert("ERC721: transfer to non ERC721Receiver implementer");
1094                 } else {
1095                     assembly {
1096                         revert(add(32, reason), mload(reason))
1097                     }
1098                 }
1099             }
1100         } else {
1101             return true;
1102         }
1103     }
1104 
1105     /**
1106      * @dev Hook that is called before any token transfer. This includes minting
1107      * and burning.
1108      *
1109      * Calling conditions:
1110      *
1111      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1112      * transferred to `to`.
1113      * - When `from` is zero, `tokenId` will be minted for `to`.
1114      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1115      * - `from` and `to` are never both zero.
1116      *
1117      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1118      */
1119     function _beforeTokenTransfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual {}
1124 }
1125 
1126 // File: contracts/LowGas.sol
1127 
1128 
1129 
1130 pragma solidity >=0.7.0 <0.9.0;
1131 
1132 
1133 contract WorldofApeWives is ERC721, Ownable {
1134   using Strings for uint256;
1135   using Counters for Counters.Counter;
1136 
1137   Counters.Counter private supply;
1138 
1139   string public uriPrefix = "";
1140   string public uriSuffix = ".json";
1141   string public hiddenMetadataUri;
1142   
1143   uint256 public cost = 0.03 ether;
1144   uint256 public maxSupply = 3333;
1145   uint256 public maxMintAmountPerTx = 3;
1146 
1147   bool public paused = true;
1148   bool public revealed = false;
1149 
1150   constructor() ERC721("World of ApeWives", "WAW") {
1151     setHiddenMetadataUri("ipfs://Qmeb9DQ5oL93XXZUCu51rk594rC2oAHbM1EJZn2CGWGyQS/hidden2.json");
1152   }
1153  
1154   modifier mintCompliance(uint256 _mintAmount) {
1155     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1156     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1157     _;
1158   }
1159 
1160   function totalSupply() public view returns (uint256) {
1161     return supply.current();
1162   }
1163 
1164   function costCheck() public view returns (uint256 _cost) {
1165       return needToUpdateCost(totalSupply());
1166   }
1167 
1168   function needToUpdateCost(uint256 _supply) internal view returns(uint256 _cost)
1169   {
1170       if(_supply < 666 && cost == 30000000000000000){
1171            return 0.00 ether;
1172        } 
1173       else if (_supply < 666 && cost != 30000000000000000){
1174            return cost;
1175        }
1176       else if (_supply <= maxSupply && cost == 30000000000000000){
1177            return 0.03 ether;
1178        }
1179        else if (_supply <= maxSupply && cost != 30000000000000000){
1180            return cost;
1181        }
1182   }
1183 
1184   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1185     require(!paused, "The contract is paused!");
1186     require(msg.value >= needToUpdateCost(totalSupply()) * _mintAmount, "Insufficient funds!");
1187 
1188     _mintLoop(msg.sender, _mintAmount);
1189   }
1190   
1191   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1192     _mintLoop(_receiver, _mintAmount);
1193   }
1194 
1195   function walletOfOwner(address _owner)
1196     public
1197     view
1198     returns (uint256[] memory)
1199   {
1200     uint256 ownerTokenCount = balanceOf(_owner);
1201     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1202     uint256 currentTokenId = 1;
1203     uint256 ownedTokenIndex = 0;
1204 
1205     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1206       address currentTokenOwner = ownerOf(currentTokenId);
1207 
1208       if (currentTokenOwner == _owner) {
1209         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1210 
1211         ownedTokenIndex++;
1212       }
1213 
1214       currentTokenId++;
1215     }
1216 
1217     return ownedTokenIds;
1218   }
1219 
1220   function tokenURI(uint256 _tokenId)
1221     public
1222     view
1223     virtual
1224     override
1225     returns (string memory)
1226   {
1227     require(
1228       _exists(_tokenId),
1229       "ERC721Metadata: URI query for nonexistent token"
1230     );
1231 
1232     if (revealed == false) {
1233       return hiddenMetadataUri;
1234     }
1235 
1236     string memory currentBaseURI = _baseURI();
1237     return bytes(currentBaseURI).length > 0
1238         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1239         : "";
1240   }
1241 
1242   function setRevealed(bool _state) public onlyOwner {
1243     revealed = _state;
1244   }
1245 
1246   function setCost(uint256 _cost) public onlyOwner {
1247     cost = _cost;
1248   }
1249 
1250   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1251     maxMintAmountPerTx = _maxMintAmountPerTx;
1252   }
1253 
1254   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1255     hiddenMetadataUri = _hiddenMetadataUri;
1256   }
1257 
1258   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1259     uriPrefix = _uriPrefix;
1260   }
1261 
1262   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1263     uriSuffix = _uriSuffix;
1264   }
1265 
1266   function setPaused(bool _state) public onlyOwner {
1267     paused = _state;
1268   }
1269 
1270   function withdraw() public onlyOwner {    
1271     // This will transfer the remaining contract balance to the owner.
1272     // Do not remove this otherwise you will not be able to withdraw the funds.
1273     // =============================================================================
1274     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1275     require(os);
1276     // =============================================================================
1277   }
1278 
1279   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1280     for (uint256 i = 0; i < _mintAmount; i++) {
1281       supply.increment();
1282       _safeMint(_receiver, supply.current());
1283     }
1284   }
1285 
1286   function _baseURI() internal view virtual override returns (string memory) {
1287     return uriPrefix;
1288   }
1289 }