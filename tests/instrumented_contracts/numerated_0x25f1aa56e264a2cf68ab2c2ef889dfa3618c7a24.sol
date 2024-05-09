1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/access/Ownable.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Contract module which provides a basic access control mechanism, where
155  * there is an account (an owner) that can be granted exclusive access to
156  * specific functions.
157  *
158  * By default, the owner account will be the one that deploys the contract. This
159  * can later be changed with {transferOwnership}.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be applied to your functions to restrict their use to
163  * the owner.
164  */
165 abstract contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Initializes the contract setting the deployer as the initial owner.
172      */
173     constructor() {
174         _transferOwnership(_msgSender());
175     }
176 
177     /**
178      * @dev Returns the address of the current owner.
179      */
180     function owner() public view virtual returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/Address.sol
224 
225 
226 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
227 
228 pragma solidity ^0.8.1;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      *
251      * [IMPORTANT]
252      * ====
253      * You shouldn't rely on `isContract` to protect against flash loan attacks!
254      *
255      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
256      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
257      * constructor.
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize/address.code.length, which returns 0
262         // for contracts in construction, since the code is only stored at the end
263         // of the constructor execution.
264 
265         return account.code.length > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
421      * revert reason using the provided one.
422      *
423      * _Available since v4.3._
424      */
425     function verifyCallResult(
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal pure returns (bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @title ERC721 token receiver interface
457  * @dev Interface for any contract that wants to support safeTransfers
458  * from ERC721 asset contracts.
459  */
460 interface IERC721Receiver {
461     /**
462      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
463      * by `operator` from `from`, this function is called.
464      *
465      * It must return its Solidity selector to confirm the token transfer.
466      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
467      *
468      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
469      */
470     function onERC721Received(
471         address operator,
472         address from,
473         uint256 tokenId,
474         bytes calldata data
475     ) external returns (bytes4);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 interface IERC165 {
486     /**
487      * @dev Returns true if this contract implements the interface defined by
488      * `interfaceId`. See the corresponding
489      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
490      * to learn more about how these ids are created.
491      *
492      * This function call must use less than 30 000 gas.
493      */
494     function supportsInterface(bytes4 interfaceId) external view returns (bool);
495 }
496 
497 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Implementation of the {IERC165} interface.
507  *
508  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
509  * for the additional interface id that will be supported. For example:
510  *
511  * ```solidity
512  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
514  * }
515  * ```
516  *
517  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
518  */
519 abstract contract ERC165 is IERC165 {
520     /**
521      * @dev See {IERC165-supportsInterface}.
522      */
523     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524         return interfaceId == type(IERC165).interfaceId;
525     }
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Required interface of an ERC721 compliant contract.
538  */
539 interface IERC721 is IERC165 {
540     /**
541      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
542      */
543     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
544 
545     /**
546      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
547      */
548     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
549 
550     /**
551      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
552      */
553     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
554 
555     /**
556      * @dev Returns the number of tokens in ``owner``'s account.
557      */
558     function balanceOf(address owner) external view returns (uint256 balance);
559 
560     /**
561      * @dev Returns the owner of the `tokenId` token.
562      *
563      * Requirements:
564      *
565      * - `tokenId` must exist.
566      */
567     function ownerOf(uint256 tokenId) external view returns (address owner);
568 
569     /**
570      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
571      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) external;
588 
589     /**
590      * @dev Transfers `tokenId` token from `from` to `to`.
591      *
592      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
611      * The approval is cleared when the token is transferred.
612      *
613      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
614      *
615      * Requirements:
616      *
617      * - The caller must own the token or be an approved operator.
618      * - `tokenId` must exist.
619      *
620      * Emits an {Approval} event.
621      */
622     function approve(address to, uint256 tokenId) external;
623 
624     /**
625      * @dev Returns the account approved for `tokenId` token.
626      *
627      * Requirements:
628      *
629      * - `tokenId` must exist.
630      */
631     function getApproved(uint256 tokenId) external view returns (address operator);
632 
633     /**
634      * @dev Approve or remove `operator` as an operator for the caller.
635      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
636      *
637      * Requirements:
638      *
639      * - The `operator` cannot be the caller.
640      *
641      * Emits an {ApprovalForAll} event.
642      */
643     function setApprovalForAll(address operator, bool _approved) external;
644 
645     /**
646      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
647      *
648      * See {setApprovalForAll}
649      */
650     function isApprovedForAll(address owner, address operator) external view returns (bool);
651 
652     /**
653      * @dev Safely transfers `tokenId` token from `from` to `to`.
654      *
655      * Requirements:
656      *
657      * - `from` cannot be the zero address.
658      * - `to` cannot be the zero address.
659      * - `tokenId` token must exist and be owned by `from`.
660      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
661      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662      *
663      * Emits a {Transfer} event.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId,
669         bytes calldata data
670     ) external;
671 }
672 
673 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 
681 /**
682  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
683  * @dev See https://eips.ethereum.org/EIPS/eip-721
684  */
685 interface IERC721Metadata is IERC721 {
686     /**
687      * @dev Returns the token collection name.
688      */
689     function name() external view returns (string memory);
690 
691     /**
692      * @dev Returns the token collection symbol.
693      */
694     function symbol() external view returns (string memory);
695 
696     /**
697      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
698      */
699     function tokenURI(uint256 tokenId) external view returns (string memory);
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
703 
704 
705 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 
711 
712 
713 
714 
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata extension, but not including the Enumerable extension, which is available separately as
719  * {ERC721Enumerable}.
720  */
721 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
722     using Address for address;
723     using Strings for uint256;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to owner address
732     mapping(uint256 => address) private _owners;
733 
734     // Mapping owner address to token count
735     mapping(address => uint256) private _balances;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     /**
744      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
745      */
746     constructor(string memory name_, string memory symbol_) {
747         _name = name_;
748         _symbol = symbol_;
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
755         return
756             interfaceId == type(IERC721).interfaceId ||
757             interfaceId == type(IERC721Metadata).interfaceId ||
758             super.supportsInterface(interfaceId);
759     }
760 
761     /**
762      * @dev See {IERC721-balanceOf}.
763      */
764     function balanceOf(address owner) public view virtual override returns (uint256) {
765         require(owner != address(0), "ERC721: balance query for the zero address");
766         return _balances[owner];
767     }
768 
769     /**
770      * @dev See {IERC721-ownerOf}.
771      */
772     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
773         address owner = _owners[tokenId];
774         require(owner != address(0), "ERC721: owner query for nonexistent token");
775         return owner;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-name}.
780      */
781     function name() public view virtual override returns (string memory) {
782         return _name;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-symbol}.
787      */
788     function symbol() public view virtual override returns (string memory) {
789         return _symbol;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-tokenURI}.
794      */
795     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
796         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
797 
798         string memory baseURI = _baseURI();
799         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
800     }
801 
802     /**
803      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
804      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
805      * by default, can be overriden in child contracts.
806      */
807     function _baseURI() internal view virtual returns (string memory) {
808         return "";
809     }
810 
811     /**
812      * @dev See {IERC721-approve}.
813      */
814     function approve(address to, uint256 tokenId) public virtual override {
815         address owner = ERC721.ownerOf(tokenId);
816         require(to != owner, "ERC721: approval to current owner");
817 
818         require(
819             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
820             "ERC721: approve caller is not owner nor approved for all"
821         );
822 
823         _approve(to, tokenId);
824     }
825 
826     /**
827      * @dev See {IERC721-getApproved}.
828      */
829     function getApproved(uint256 tokenId) public view virtual override returns (address) {
830         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
831 
832         return _tokenApprovals[tokenId];
833     }
834 
835     /**
836      * @dev See {IERC721-setApprovalForAll}.
837      */
838     function setApprovalForAll(address operator, bool approved) public virtual override {
839         _setApprovalForAll(_msgSender(), operator, approved);
840     }
841 
842     /**
843      * @dev See {IERC721-isApprovedForAll}.
844      */
845     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
846         return _operatorApprovals[owner][operator];
847     }
848 
849     /**
850      * @dev See {IERC721-transferFrom}.
851      */
852     function transferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         //solhint-disable-next-line max-line-length
858         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
859 
860         _transfer(from, to, tokenId);
861     }
862 
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) public virtual override {
868         safeTransferFrom(from, to, tokenId, "");
869     }
870 
871 
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
882  
883     function _safeTransfer(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) internal virtual {
889         _transfer(from, to, tokenId);
890         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
891     }
892 
893 
894     function _exists(uint256 tokenId) internal view virtual returns (bool) {
895         return _owners[tokenId] != address(0);
896     }
897 
898 
899     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
900         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
901         address owner = ERC721.ownerOf(tokenId);
902         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
903     }
904 
905     function _safeMint(address to, uint256 tokenId) internal virtual {
906         _safeMint(to, tokenId, "");
907     }
908 
909   
910     function _safeMint(
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) internal virtual {
915         _mint(to, tokenId);
916         require(
917             _checkOnERC721Received(address(0), to, tokenId, _data),
918             "ERC721: transfer to non ERC721Receiver implementer"
919         );
920     }
921 
922     function _mint(address to, uint256 tokenId) internal virtual {
923         require(to != address(0), "ERC721: mint to the zero address");
924         require(!_exists(tokenId), "ERC721: token already minted");
925 
926         _beforeTokenTransfer(address(0), to, tokenId);
927 
928         _balances[to] += 1;
929         _owners[tokenId] = to;
930 
931         emit Transfer(address(0), to, tokenId);
932 
933         _afterTokenTransfer(address(0), to, tokenId);
934     }
935 
936     function _burn(uint256 tokenId) internal virtual {
937         address owner = ERC721.ownerOf(tokenId);
938 
939         _beforeTokenTransfer(owner, address(0), tokenId);
940 
941        
942         _approve(address(0), tokenId);
943 
944         _balances[owner] -= 1;
945         delete _owners[tokenId];
946 
947         emit Transfer(owner, address(0), tokenId);
948 
949         _afterTokenTransfer(owner, address(0), tokenId);
950     }
951 
952     function _transfer(
953         address from,
954         address to,
955         uint256 tokenId
956     ) internal virtual {
957         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
958         require(to != address(0), "ERC721: transfer to the zero address");
959 
960         _beforeTokenTransfer(from, to, tokenId);
961 
962         // Clear approvals from the previous owner
963         _approve(address(0), tokenId);
964 
965         _balances[from] -= 1;
966         _balances[to] += 1;
967         _owners[tokenId] = to;
968 
969         emit Transfer(from, to, tokenId);
970 
971         _afterTokenTransfer(from, to, tokenId);
972     }
973 
974 
975     function _approve(address to, uint256 tokenId) internal virtual {
976         _tokenApprovals[tokenId] = to;
977         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
978     }
979 
980     function _setApprovalForAll(
981         address owner,
982         address operator,
983         bool approved
984     ) internal virtual {
985         require(owner != operator, "ERC721: approve to caller");
986         _operatorApprovals[owner][operator] = approved;
987         emit ApprovalForAll(owner, operator, approved);
988     }
989 
990     function _checkOnERC721Received(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) private returns (bool) {
996         if (to.isContract()) {
997             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
998                 return retval == IERC721Receiver.onERC721Received.selector;
999             } catch (bytes memory reason) {
1000                 if (reason.length == 0) {
1001                     revert("ERC721: transfer to non ERC721Receiver implementer");
1002                 } else {
1003                     assembly {
1004                         revert(add(32, reason), mload(reason))
1005                     }
1006                 }
1007             }
1008         } else {
1009             return true;
1010         }
1011     }
1012 
1013     function _beforeTokenTransfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) internal virtual {}
1018 
1019     function _afterTokenTransfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) internal virtual {}
1024 }
1025 
1026 // File: contracts/Cuteskullzr.sol
1027 
1028 
1029 
1030 
1031 pragma solidity >=0.7.0 <0.9.0;
1032 
1033 
1034 
1035 
1036 contract CuteSkullz_Official is ERC721, Ownable {
1037   using Strings for uint256;
1038   using Counters for Counters.Counter;
1039 
1040   Counters.Counter private supply;
1041 
1042   string public uriPrefix = "";
1043   string public uriSuffix = ".json";
1044   
1045   uint256 public cost = 0 ether;
1046   uint256 public maxSupply = 2222;
1047   uint256 public maxMintAmountPerTx = 3;
1048 
1049   bool public paused = false;
1050   bool public revealed = true;
1051 
1052   constructor() ERC721("Cute Skullz Official", "CS") {
1053   }
1054 
1055   modifier mintCompliance(uint256 _mintAmount) {
1056     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1057     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1058     _;
1059   }
1060 
1061   function totalSupply() public view returns (uint256) {
1062     return supply.current();
1063   }
1064 
1065   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1066     require(!paused, "The contract is paused!");
1067     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1068 
1069     _mintLoop(msg.sender, _mintAmount);
1070   }
1071   
1072   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1073     _mintLoop(_receiver, _mintAmount);
1074   }
1075 
1076   function walletOfOwner(address _owner)
1077     public
1078     view
1079     returns (uint256[] memory)
1080   {
1081     uint256 ownerTokenCount = balanceOf(_owner);
1082     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1083     uint256 currentTokenId = 1;
1084     uint256 ownedTokenIndex = 0;
1085 
1086     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1087       address currentTokenOwner = ownerOf(currentTokenId);
1088 
1089       if (currentTokenOwner == _owner) {
1090         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1091 
1092         ownedTokenIndex++;
1093       }
1094 
1095       currentTokenId++;
1096     }
1097 
1098     return ownedTokenIds;
1099   }
1100 
1101   function tokenURI(uint256 _tokenId)
1102     public
1103     view
1104     virtual
1105     override
1106     returns (string memory)
1107   {
1108     require(
1109       _exists(_tokenId),
1110       "ERC721Metadata: URI query for nonexistent token"
1111     );
1112 
1113     if (revealed == false) {
1114       
1115     }
1116 
1117     string memory currentBaseURI = _baseURI();
1118     return bytes(currentBaseURI).length > 0
1119         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1120         : "";
1121   }
1122 
1123   function setRevealed(bool _state) public onlyOwner {
1124     revealed = _state;
1125   }
1126 
1127   function setCost(uint256 _cost) public onlyOwner {
1128     cost = _cost;
1129   }
1130 
1131   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1132     maxMintAmountPerTx = _maxMintAmountPerTx;
1133   }
1134 
1135 
1136 
1137   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1138     uriPrefix = _uriPrefix;
1139   }
1140 
1141   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1142     uriSuffix = _uriSuffix;
1143   }
1144 
1145   function setPaused(bool _state) public onlyOwner {
1146     paused = _state;
1147   }
1148 
1149   function withdraw() public onlyOwner {
1150     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1151     require(os);
1152   }
1153 
1154   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1155     for (uint256 i = 0; i < _mintAmount; i++) {
1156       supply.increment();
1157       _safeMint(_receiver, supply.current());
1158     }
1159   }
1160 
1161   function _baseURI() internal view virtual override returns (string memory) {
1162     return uriPrefix;
1163   }
1164 }