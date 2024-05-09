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
220 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
221 
222 pragma solidity ^0.8.1;
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
244      *
245      * [IMPORTANT]
246      * ====
247      * You shouldn't rely on `isContract` to protect against flash loan attacks!
248      *
249      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
250      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
251      * constructor.
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies on extcodesize/address.code.length, which returns 0
256         // for contracts in construction, since the code is only stored at the end
257         // of the constructor execution.
258 
259         return account.code.length > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
443 
444 
445 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @title ERC721 token receiver interface
451  * @dev Interface for any contract that wants to support safeTransfers
452  * from ERC721 asset contracts.
453  */
454 interface IERC721Receiver {
455     /**
456      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
457      * by `operator` from `from`, this function is called.
458      *
459      * It must return its Solidity selector to confirm the token transfer.
460      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
461      *
462      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
463      */
464     function onERC721Received(
465         address operator,
466         address from,
467         uint256 tokenId,
468         bytes calldata data
469     ) external returns (bytes4);
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Interface of the ERC165 standard, as defined in the
481  * https://eips.ethereum.org/EIPS/eip-165[EIP].
482  *
483  * Implementers can declare support of contract interfaces, which can then be
484  * queried by others ({ERC165Checker}).
485  *
486  * For an implementation, see {ERC165}.
487  */
488 interface IERC165 {
489     /**
490      * @dev Returns true if this contract implements the interface defined by
491      * `interfaceId`. See the corresponding
492      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
493      * to learn more about how these ids are created.
494      *
495      * This function call must use less than 30 000 gas.
496      */
497     function supportsInterface(bytes4 interfaceId) external view returns (bool);
498 }
499 
500 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
501 
502 
503 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Implementation of the {IERC165} interface.
510  *
511  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
512  * for the additional interface id that will be supported. For example:
513  *
514  * ```solidity
515  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
517  * }
518  * ```
519  *
520  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
521  */
522 abstract contract ERC165 is IERC165 {
523     /**
524      * @dev See {IERC165-supportsInterface}.
525      */
526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527         return interfaceId == type(IERC165).interfaceId;
528     }
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
532 
533 
534 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Required interface of an ERC721 compliant contract.
541  */
542 interface IERC721 is IERC165 {
543     /**
544      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
545      */
546     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
547 
548     /**
549      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
550      */
551     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
552 
553     /**
554      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
555      */
556     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
557 
558     /**
559      * @dev Returns the number of tokens in ``owner``'s account.
560      */
561     function balanceOf(address owner) external view returns (uint256 balance);
562 
563     /**
564      * @dev Returns the owner of the `tokenId` token.
565      *
566      * Requirements:
567      *
568      * - `tokenId` must exist.
569      */
570     function ownerOf(uint256 tokenId) external view returns (address owner);
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external;
591 
592     /**
593      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
594      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must exist and be owned by `from`.
601      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
602      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
603      *
604      * Emits a {Transfer} event.
605      */
606     function safeTransferFrom(
607         address from,
608         address to,
609         uint256 tokenId
610     ) external;
611 
612     /**
613      * @dev Transfers `tokenId` token from `from` to `to`.
614      *
615      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      *
624      * Emits a {Transfer} event.
625      */
626     function transferFrom(
627         address from,
628         address to,
629         uint256 tokenId
630     ) external;
631 
632     /**
633      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
634      * The approval is cleared when the token is transferred.
635      *
636      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
637      *
638      * Requirements:
639      *
640      * - The caller must own the token or be an approved operator.
641      * - `tokenId` must exist.
642      *
643      * Emits an {Approval} event.
644      */
645     function approve(address to, uint256 tokenId) external;
646 
647     /**
648      * @dev Approve or remove `operator` as an operator for the caller.
649      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
650      *
651      * Requirements:
652      *
653      * - The `operator` cannot be the caller.
654      *
655      * Emits an {ApprovalForAll} event.
656      */
657     function setApprovalForAll(address operator, bool _approved) external;
658 
659     /**
660      * @dev Returns the account approved for `tokenId` token.
661      *
662      * Requirements:
663      *
664      * - `tokenId` must exist.
665      */
666     function getApproved(uint256 tokenId) external view returns (address operator);
667 
668     /**
669      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
670      *
671      * See {setApprovalForAll}
672      */
673     function isApprovedForAll(address owner, address operator) external view returns (bool);
674 }
675 
676 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
686  * @dev See https://eips.ethereum.org/EIPS/eip-721
687  */
688 interface IERC721Metadata is IERC721 {
689     /**
690      * @dev Returns the token collection name.
691      */
692     function name() external view returns (string memory);
693 
694     /**
695      * @dev Returns the token collection symbol.
696      */
697     function symbol() external view returns (string memory);
698 
699     /**
700      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
701      */
702     function tokenURI(uint256 tokenId) external view returns (string memory);
703 }
704 
705 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
706 
707 
708 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 
713 
714 
715 
716 
717 
718 
719 /**
720  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
721  * the Metadata extension, but not including the Enumerable extension, which is available separately as
722  * {ERC721Enumerable}.
723  */
724 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
725     using Address for address;
726     using Strings for uint256;
727 
728     // Token name
729     string private _name;
730 
731     // Token symbol
732     string private _symbol;
733 
734     // Mapping from token ID to owner address
735     mapping(uint256 => address) private _owners;
736 
737     // Mapping owner address to token count
738     mapping(address => uint256) private _balances;
739 
740     // Mapping from token ID to approved address
741     mapping(uint256 => address) private _tokenApprovals;
742 
743     // Mapping from owner to operator approvals
744     mapping(address => mapping(address => bool)) private _operatorApprovals;
745 
746     /**
747      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
748      */
749     constructor(string memory name_, string memory symbol_) {
750         _name = name_;
751         _symbol = symbol_;
752     }
753 
754     /**
755      * @dev See {IERC165-supportsInterface}.
756      */
757     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
758         return
759             interfaceId == type(IERC721).interfaceId ||
760             interfaceId == type(IERC721Metadata).interfaceId ||
761             super.supportsInterface(interfaceId);
762     }
763 
764     /**
765      * @dev See {IERC721-balanceOf}.
766      */
767     function balanceOf(address owner) public view virtual override returns (uint256) {
768         require(owner != address(0), "ERC721: balance query for the zero address");
769         return _balances[owner];
770     }
771 
772     /**
773      * @dev See {IERC721-ownerOf}.
774      */
775     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
776         address owner = _owners[tokenId];
777         require(owner != address(0), "ERC721: owner query for nonexistent token");
778         return owner;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-name}.
783      */
784     function name() public view virtual override returns (string memory) {
785         return _name;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-symbol}.
790      */
791     function symbol() public view virtual override returns (string memory) {
792         return _symbol;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-tokenURI}.
797      */
798     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
799         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
800 
801         string memory baseURI = _baseURI();
802         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
803     }
804 
805     /**
806      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
807      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
808      * by default, can be overridden in child contracts.
809      */
810     function _baseURI() internal view virtual returns (string memory) {
811         return "";
812     }
813 
814     /**
815      * @dev See {IERC721-approve}.
816      */
817     function approve(address to, uint256 tokenId) public virtual override {
818         address owner = ERC721.ownerOf(tokenId);
819         require(to != owner, "ERC721: approval to current owner");
820 
821         require(
822             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
823             "ERC721: approve caller is not owner nor approved for all"
824         );
825 
826         _approve(to, tokenId);
827     }
828 
829     /**
830      * @dev See {IERC721-getApproved}.
831      */
832     function getApproved(uint256 tokenId) public view virtual override returns (address) {
833         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
834 
835         return _tokenApprovals[tokenId];
836     }
837 
838     /**
839      * @dev See {IERC721-setApprovalForAll}.
840      */
841     function setApprovalForAll(address operator, bool approved) public virtual override {
842         _setApprovalForAll(_msgSender(), operator, approved);
843     }
844 
845     /**
846      * @dev See {IERC721-isApprovedForAll}.
847      */
848     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
849         return _operatorApprovals[owner][operator];
850     }
851 
852     /**
853      * @dev See {IERC721-transferFrom}.
854      */
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) public virtual override {
860         //solhint-disable-next-line max-line-length
861         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
862 
863         _transfer(from, to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-safeTransferFrom}.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) public virtual override {
874         safeTransferFrom(from, to, tokenId, "");
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId,
884         bytes memory _data
885     ) public virtual override {
886         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
887         _safeTransfer(from, to, tokenId, _data);
888     }
889 
890     /**
891      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
892      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
893      *
894      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
895      *
896      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
897      * implement alternative mechanisms to perform token transfer, such as signature-based.
898      *
899      * Requirements:
900      *
901      * - `from` cannot be the zero address.
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must exist and be owned by `from`.
904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _safeTransfer(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) internal virtual {
914         _transfer(from, to, tokenId);
915         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
916     }
917 
918     /**
919      * @dev Returns whether `tokenId` exists.
920      *
921      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
922      *
923      * Tokens start existing when they are minted (`_mint`),
924      * and stop existing when they are burned (`_burn`).
925      */
926     function _exists(uint256 tokenId) internal view virtual returns (bool) {
927         return _owners[tokenId] != address(0);
928     }
929 
930     /**
931      * @dev Returns whether `spender` is allowed to manage `tokenId`.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must exist.
936      */
937     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
938         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
939         address owner = ERC721.ownerOf(tokenId);
940         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
941     }
942 
943     /**
944      * @dev Safely mints `tokenId` and transfers it to `to`.
945      *
946      * Requirements:
947      *
948      * - `tokenId` must not exist.
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _safeMint(address to, uint256 tokenId) internal virtual {
954         _safeMint(to, tokenId, "");
955     }
956 
957     /**
958      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
959      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
960      */
961     function _safeMint(
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) internal virtual {
966         _mint(to, tokenId);
967         require(
968             _checkOnERC721Received(address(0), to, tokenId, _data),
969             "ERC721: transfer to non ERC721Receiver implementer"
970         );
971     }
972 
973     /**
974      * @dev Mints `tokenId` and transfers it to `to`.
975      *
976      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
977      *
978      * Requirements:
979      *
980      * - `tokenId` must not exist.
981      * - `to` cannot be the zero address.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _mint(address to, uint256 tokenId) internal virtual {
986         require(to != address(0), "ERC721: mint to the zero address");
987         require(!_exists(tokenId), "ERC721: token already minted");
988 
989         _beforeTokenTransfer(address(0), to, tokenId);
990 
991         _balances[to] += 1;
992         _owners[tokenId] = to;
993 
994         emit Transfer(address(0), to, tokenId);
995 
996         _afterTokenTransfer(address(0), to, tokenId);
997     }
998 
999     /**
1000      * @dev Destroys `tokenId`.
1001      * The approval is cleared when the token is burned.
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must exist.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _burn(uint256 tokenId) internal virtual {
1010         address owner = ERC721.ownerOf(tokenId);
1011 
1012         _beforeTokenTransfer(owner, address(0), tokenId);
1013 
1014         // Clear approvals
1015         _approve(address(0), tokenId);
1016 
1017         _balances[owner] -= 1;
1018         delete _owners[tokenId];
1019 
1020         emit Transfer(owner, address(0), tokenId);
1021 
1022         _afterTokenTransfer(owner, address(0), tokenId);
1023     }
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) internal virtual {
1041         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1042         require(to != address(0), "ERC721: transfer to the zero address");
1043 
1044         _beforeTokenTransfer(from, to, tokenId);
1045 
1046         // Clear approvals from the previous owner
1047         _approve(address(0), tokenId);
1048 
1049         _balances[from] -= 1;
1050         _balances[to] += 1;
1051         _owners[tokenId] = to;
1052 
1053         emit Transfer(from, to, tokenId);
1054 
1055         _afterTokenTransfer(from, to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Approve `to` to operate on `tokenId`
1060      *
1061      * Emits a {Approval} event.
1062      */
1063     function _approve(address to, uint256 tokenId) internal virtual {
1064         _tokenApprovals[tokenId] = to;
1065         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Approve `operator` to operate on all of `owner` tokens
1070      *
1071      * Emits a {ApprovalForAll} event.
1072      */
1073     function _setApprovalForAll(
1074         address owner,
1075         address operator,
1076         bool approved
1077     ) internal virtual {
1078         require(owner != operator, "ERC721: approve to caller");
1079         _operatorApprovals[owner][operator] = approved;
1080         emit ApprovalForAll(owner, operator, approved);
1081     }
1082 
1083     /**
1084      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1085      * The call is not executed if the target address is not a contract.
1086      *
1087      * @param from address representing the previous owner of the given token ID
1088      * @param to target address that will receive the tokens
1089      * @param tokenId uint256 ID of the token to be transferred
1090      * @param _data bytes optional data to send along with the call
1091      * @return bool whether the call correctly returned the expected magic value
1092      */
1093     function _checkOnERC721Received(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) private returns (bool) {
1099         if (to.isContract()) {
1100             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1101                 return retval == IERC721Receiver.onERC721Received.selector;
1102             } catch (bytes memory reason) {
1103                 if (reason.length == 0) {
1104                     revert("ERC721: transfer to non ERC721Receiver implementer");
1105                 } else {
1106                     assembly {
1107                         revert(add(32, reason), mload(reason))
1108                     }
1109                 }
1110             }
1111         } else {
1112             return true;
1113         }
1114     }
1115 
1116     /**
1117      * @dev Hook that is called before any token transfer. This includes minting
1118      * and burning.
1119      *
1120      * Calling conditions:
1121      *
1122      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1123      * transferred to `to`.
1124      * - When `from` is zero, `tokenId` will be minted for `to`.
1125      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1126      * - `from` and `to` are never both zero.
1127      *
1128      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1129      */
1130     function _beforeTokenTransfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) internal virtual {}
1135 
1136     /**
1137      * @dev Hook that is called after any transfer of tokens. This includes
1138      * minting and burning.
1139      *
1140      * Calling conditions:
1141      *
1142      * - when `from` and `to` are both non-zero.
1143      * - `from` and `to` are never both zero.
1144      *
1145      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1146      */
1147     function _afterTokenTransfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) internal virtual {}
1152 }
1153 
1154 // File: contracts/OsakaGirlScouts.sol
1155 
1156 
1157 
1158 
1159 pragma solidity >=0.7.0 <0.9.0;
1160 
1161 
1162 
1163 
1164 contract OSAKAGIRLSCOUTS is ERC721, Ownable {
1165   using Strings for uint256;
1166   using Counters for Counters.Counter;
1167 
1168   Counters.Counter private supply;
1169 
1170   string public uriPrefix = "ipfs://bafybeiaz32a5cixs2s65gitvxd3qckl4uqkhrsap7jqpgpan57xxnm464q/";
1171   string public uriSuffix = ".json";
1172   string public hiddenMetadataUri;
1173   
1174   uint256 public cost = 0.00 ether;
1175   uint256 public maxSupply = 2222;
1176   uint256 public maxMintAmountPerTx = 5;
1177 
1178   bool public paused = false;
1179   bool public revealed = true;
1180 
1181   constructor() ERC721("OSAKAGIRLSCOUTS", "OGS") {
1182     setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1183   }
1184 
1185   modifier mintCompliance(uint256 _mintAmount) {
1186     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1187     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1188     _;
1189   }
1190 
1191   function totalSupply() public view returns (uint256) {
1192     return supply.current();
1193   }
1194 
1195   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1196     require(!paused, "The contract is paused!");
1197     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1198 
1199     _mintLoop(msg.sender, _mintAmount);
1200   }
1201   
1202   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1203     _mintLoop(_receiver, _mintAmount);
1204   }
1205 
1206   function walletOfOwner(address _owner)
1207     public
1208     view
1209     returns (uint256[] memory)
1210   {
1211     uint256 ownerTokenCount = balanceOf(_owner);
1212     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1213     uint256 currentTokenId = 1;
1214     uint256 ownedTokenIndex = 0;
1215 
1216     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1217       address currentTokenOwner = ownerOf(currentTokenId);
1218 
1219       if (currentTokenOwner == _owner) {
1220         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1221 
1222         ownedTokenIndex++;
1223       }
1224 
1225       currentTokenId++;
1226     }
1227 
1228     return ownedTokenIds;
1229   }
1230 
1231   function tokenURI(uint256 _tokenId)
1232     public
1233     view
1234     virtual
1235     override
1236     returns (string memory)
1237   {
1238     require(
1239       _exists(_tokenId),
1240       "ERC721Metadata: URI query for nonexistent token"
1241     );
1242 
1243     if (revealed == false) {
1244       return hiddenMetadataUri;
1245     }
1246 
1247     string memory currentBaseURI = _baseURI();
1248     return bytes(currentBaseURI).length > 0
1249         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1250         : "";
1251   }
1252 
1253   function setRevealed(bool _state) public onlyOwner {
1254     revealed = _state;
1255   }
1256 
1257   function setCost(uint256 _cost) public onlyOwner {
1258     cost = _cost;
1259   }
1260 
1261   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1262     maxMintAmountPerTx = _maxMintAmountPerTx;
1263   }
1264 
1265   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1266     hiddenMetadataUri = _hiddenMetadataUri;
1267   }
1268 
1269   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1270     uriPrefix = _uriPrefix;
1271   }
1272 
1273   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1274     uriSuffix = _uriSuffix;
1275   }
1276 
1277   function setPaused(bool _state) public onlyOwner {
1278     paused = _state;
1279   }
1280 
1281   function withdraw() public onlyOwner {
1282 
1283 
1284     // This will transfer the remaining contract balance to the owner.
1285     // Do not remove this otherwise you will not be able to withdraw the funds.
1286     // =============================================================================
1287     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1288     require(os);
1289     // =============================================================================
1290   }
1291 
1292   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1293     for (uint256 i = 0; i < _mintAmount; i++) {
1294       supply.increment();
1295       _safeMint(_receiver, supply.current());
1296     }
1297   }
1298 
1299   function _baseURI() internal view virtual override returns (string memory) {
1300     return uriPrefix;
1301   }
1302 }