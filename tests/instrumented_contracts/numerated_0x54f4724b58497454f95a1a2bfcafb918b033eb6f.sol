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
800      * by default, can be overriden in child contracts.
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
1055      * @dev Approve `operator` to operate on all of `owner` tokens
1056      *
1057      * Emits a {ApprovalForAll} event.
1058      */
1059     function _setApprovalForAll(
1060         address owner,
1061         address operator,
1062         bool approved
1063     ) internal virtual {
1064         require(owner != operator, "ERC721: approve to caller");
1065         _operatorApprovals[owner][operator] = approved;
1066         emit ApprovalForAll(owner, operator, approved);
1067     }
1068 
1069     /**
1070      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1071      * The call is not executed if the target address is not a contract.
1072      *
1073      * @param from address representing the previous owner of the given token ID
1074      * @param to target address that will receive the tokens
1075      * @param tokenId uint256 ID of the token to be transferred
1076      * @param _data bytes optional data to send along with the call
1077      * @return bool whether the call correctly returned the expected magic value
1078      */
1079     function _checkOnERC721Received(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) private returns (bool) {
1085         if (to.isContract()) {
1086             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1087                 return retval == IERC721Receiver.onERC721Received.selector;
1088             } catch (bytes memory reason) {
1089                 if (reason.length == 0) {
1090                     revert("ERC721: transfer to non ERC721Receiver implementer");
1091                 } else {
1092                     assembly {
1093                         revert(add(32, reason), mload(reason))
1094                     }
1095                 }
1096             }
1097         } else {
1098             return true;
1099         }
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before any token transfer. This includes minting
1104      * and burning.
1105      *
1106      * Calling conditions:
1107      *
1108      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1109      * transferred to `to`.
1110      * - When `from` is zero, `tokenId` will be minted for `to`.
1111      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1112      * - `from` and `to` are never both zero.
1113      *
1114      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1115      */
1116     function _beforeTokenTransfer(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) internal virtual {}
1121 }
1122 
1123 // File: contracts/LowGas.sol
1124 
1125 
1126 
1127 pragma solidity >=0.7.0 <0.9.0;
1128 
1129 
1130 contract TheOfficialAzukiApe is ERC721, Ownable {
1131   using Strings for uint256;
1132   using Counters for Counters.Counter;
1133 
1134   Counters.Counter private supply;
1135 
1136   string public uriPrefix = "";
1137   string public uriSuffix = ".json";
1138   string public hiddenMetadataUri;
1139   
1140   uint256 public cost = 0.01 ether;
1141   uint256 public maxSupply = 3333;
1142   uint256 public maxMintAmountPerTx = 2;
1143   uint256 public maxTokensPerWallet = 6;
1144 
1145   bool public paused = true;
1146   bool public revealed = false;
1147 
1148   mapping(address => uint256) public _tokensMintedPerWallet;
1149 
1150   constructor() ERC721("The Official Azuki Ape", "AA") {
1151     setHiddenMetadataUri("ipfs://QmR7xJF1cp73sRmEQ1BPwHTbQ1oiJecTboUFxrUgAkqWSD/hidden.json");
1152   }
1153  
1154   modifier mintCompliance(uint256 _mintAmount) {
1155     require( (_tokensMintedPerWallet[msg.sender] + _mintAmount) <= needToUpdateMaxPerWallet(totalSupply()), "Exceeds max tokens per account!");
1156     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1157     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1158     _;
1159   }
1160 
1161   function totalSupply() public view returns (uint256) {
1162     return supply.current();
1163   }
1164 
1165   function costCheck() public view returns (uint256 _cost) {
1166       return needToUpdateCost(totalSupply());
1167   }
1168 
1169   function maxTokensPerWalletCheck() public view returns (uint256 _cost) {
1170       return needToUpdateMaxPerWallet(totalSupply());
1171   }
1172 
1173   function needToUpdateCost(uint256 _supply) internal view returns(uint256 _cost)
1174   {
1175       if(_supply < 300 && cost == 10000000000000000){
1176            return 0.00 ether;
1177        } 
1178       else if (_supply < 300 && cost != 10000000000000000){
1179            return cost;
1180        }
1181       else if (_supply <= maxSupply && cost == 10000000000000000){
1182            return 0.01 ether;
1183        }
1184        else if (_supply <= maxSupply && cost != 10000000000000000){
1185            return cost;
1186        }
1187   }
1188 
1189   function needToUpdateMaxPerWallet(uint256 _supply) internal view returns(uint256 _cost)
1190   {
1191        if(_supply < 300 && maxTokensPerWallet == 6) {
1192            return 6;
1193        } 
1194        else if (_supply < 300 &&  maxTokensPerWallet != 6){
1195            return maxTokensPerWallet;
1196        }
1197        else if (_supply <= maxSupply && maxTokensPerWallet == 6){
1198            return 100;
1199        }
1200         else if (_supply <= maxSupply && maxTokensPerWallet != 6){
1201            return maxTokensPerWallet;
1202        }
1203   }
1204 
1205 
1206   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1207     require(!paused, "The contract is paused!");
1208     require(msg.value >= needToUpdateCost(totalSupply()) * _mintAmount, "Insufficient funds!");
1209     require( (_tokensMintedPerWallet[msg.sender] + _mintAmount) <= needToUpdateMaxPerWallet(totalSupply()), "Exceeds max tokens per account!");
1210 
1211     _mintLoop(msg.sender, _mintAmount);
1212   }
1213   
1214   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1215     _mintLoop(_receiver, _mintAmount);
1216   }
1217 
1218   function walletOfOwner(address _owner)
1219     public
1220     view
1221     returns (uint256[] memory)
1222   {
1223     uint256 ownerTokenCount = balanceOf(_owner);
1224     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1225     uint256 currentTokenId = 1;
1226     uint256 ownedTokenIndex = 0;
1227 
1228     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1229       address currentTokenOwner = ownerOf(currentTokenId);
1230 
1231       if (currentTokenOwner == _owner) {
1232         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1233 
1234         ownedTokenIndex++;
1235       }
1236 
1237       currentTokenId++;
1238     }
1239 
1240     return ownedTokenIds;
1241   }
1242 
1243   function tokenURI(uint256 _tokenId)
1244     public
1245     view
1246     virtual
1247     override
1248     returns (string memory)
1249   {
1250     require(
1251       _exists(_tokenId),
1252       "ERC721Metadata: URI query for nonexistent token"
1253     );
1254 
1255     if (revealed == false) {
1256       return hiddenMetadataUri;
1257     }
1258 
1259     string memory currentBaseURI = _baseURI();
1260     return bytes(currentBaseURI).length > 0
1261         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1262         : "";
1263   }
1264 
1265    function setMaxTokensPerWallet(uint8 _maxTokensPerWallet) external onlyOwner {
1266         maxTokensPerWallet = _maxTokensPerWallet;
1267     }
1268 
1269   function setRevealed(bool _state) public onlyOwner {
1270     revealed = _state;
1271   }
1272 
1273   function setCost(uint256 _cost) public onlyOwner {
1274     cost = _cost;
1275   }
1276 
1277   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1278     maxMintAmountPerTx = _maxMintAmountPerTx;
1279   }
1280 
1281    function Set_Token(uint256 _token) public onlyOwner {
1282     maxSupply = _token;
1283   }
1284 
1285   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1286     hiddenMetadataUri = _hiddenMetadataUri;
1287   }
1288 
1289   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1290     uriPrefix = _uriPrefix;
1291   }
1292 
1293   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1294     uriSuffix = _uriSuffix;
1295   }
1296 
1297   function setPaused(bool _state) public onlyOwner {
1298     paused = _state;
1299   }
1300 
1301   function withdraw() public onlyOwner {    
1302     // This will transfer the remaining contract balance to the owner.
1303     // Do not remove this otherwise you will not be able to withdraw the funds.
1304     // =============================================================================
1305     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1306     require(os);
1307     // =============================================================================
1308   }
1309 
1310   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1311     for (uint256 i = 0; i < _mintAmount; i++) {
1312       supply.increment();
1313       _tokensMintedPerWallet[msg.sender]++;
1314       _safeMint(_receiver, supply.current());
1315     }
1316   }
1317 
1318   function _baseURI() internal view virtual override returns (string memory) {
1319     return uriPrefix;
1320   }
1321 }