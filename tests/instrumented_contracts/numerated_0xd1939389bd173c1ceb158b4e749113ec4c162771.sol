1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * Total Supply 5000
9  * Free To Mint First 2000
10  * Remaining Punks Will Cost 0.01 Eth Each
11  * You Can Mint 5PUNKS/Transaction
12  */
13 library Counters {
14     struct Counter {
15         // This variable should never be directly accessed by users of the library: interactions must be restricted to
16         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
17         // this feature: see https://github.com/ethereum/solidity/issues/4637
18         uint256 _value; // default: 0
19     }
20 
21     function current(Counter storage counter) internal view returns (uint256) {
22         return counter._value;
23     }
24 
25     function increment(Counter storage counter) internal {
26         unchecked {
27             counter._value += 1;
28         }
29     }
30 
31     function decrement(Counter storage counter) internal {
32         uint256 value = counter._value;
33         require(value > 0, "Counter: decrement overflow");
34         unchecked {
35             counter._value = value - 1;
36         }
37     }
38 
39     function reset(Counter storage counter) internal {
40         counter._value = 0;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/utils/Strings.sol
45 
46 
47 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
48 
49 pragma solidity ^0.8.0;
50 
51 /**
52  * @dev String operations.
53  */
54 library Strings {
55     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
59      */
60     function toString(uint256 value) internal pure returns (string memory) {
61         // Inspired by OraclizeAPI's implementation - MIT licence
62         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
63 
64         if (value == 0) {
65             return "0";
66         }
67         uint256 temp = value;
68         uint256 digits;
69         while (temp != 0) {
70             digits++;
71             temp /= 10;
72         }
73         bytes memory buffer = new bytes(digits);
74         while (value != 0) {
75             digits -= 1;
76             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
77             value /= 10;
78         }
79         return string(buffer);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
84      */
85     function toHexString(uint256 value) internal pure returns (string memory) {
86         if (value == 0) {
87             return "0x00";
88         }
89         uint256 temp = value;
90         uint256 length = 0;
91         while (temp != 0) {
92             length++;
93             temp >>= 8;
94         }
95         return toHexString(value, length);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
100      */
101     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
102         bytes memory buffer = new bytes(2 * length + 2);
103         buffer[0] = "0";
104         buffer[1] = "x";
105         for (uint256 i = 2 * length + 1; i > 1; --i) {
106             buffer[i] = _HEX_SYMBOLS[value & 0xf];
107             value >>= 4;
108         }
109         require(value == 0, "Strings: hex length insufficient");
110         return string(buffer);
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/Context.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 // File: @openzeppelin/contracts/access/Ownable.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 
149 /**
150  * @dev Contract module which provides a basic access control mechanism, where
151  * there is an account (an owner) that can be granted exclusive access to
152  * specific functions.
153  *
154  * By default, the owner account will be the one that deploys the contract. This
155  * can later be changed with {transferOwnership}.
156  *
157  * This module is used through inheritance. It will make available the modifier
158  * `onlyOwner`, which can be applied to your functions to restrict their use to
159  * the owner.
160  */
161 abstract contract Ownable is Context {
162     address private _owner;
163 
164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166     /**
167      * @dev Initializes the contract setting the deployer as the initial owner.
168      */
169     constructor() {
170         _transferOwnership(_msgSender());
171     }
172 
173     /**
174      * @dev Returns the address of the current owner.
175      */
176     function owner() public view virtual returns (address) {
177         return _owner;
178     }
179 
180     /**
181      * @dev Throws if called by any account other than the owner.
182      */
183     modifier onlyOwner() {
184         require(owner() == _msgSender(), "Ownable: caller is not the owner");
185         _;
186     }
187 
188     /**
189      * @dev Leaves the contract without owner. It will not be possible to call
190      * `onlyOwner` functions anymore. Can only be called by the current owner.
191      *
192      * NOTE: Renouncing ownership will leave the contract without an owner,
193      * thereby removing any functionality that is only available to the owner.
194      */
195     function renounceOwnership() public virtual onlyOwner {
196         _transferOwnership(address(0));
197     }
198 
199     /**
200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
201      * Can only be called by the current owner.
202      */
203     function transferOwnership(address newOwner) public virtual onlyOwner {
204         require(newOwner != address(0), "Ownable: new owner is the zero address");
205         _transferOwnership(newOwner);
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Internal function without access restriction.
211      */
212     function _transferOwnership(address newOwner) internal virtual {
213         address oldOwner = _owner;
214         _owner = newOwner;
215         emit OwnershipTransferred(oldOwner, newOwner);
216     }
217 }
218 
219 // File: @openzeppelin/contracts/utils/Address.sol
220 
221 
222 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
223 
224 pragma solidity ^0.8.1;
225 
226 /**
227  * @dev Collection of functions related to the address type
228  */
229 library Address {
230     /**
231      * @dev Returns true if `account` is a contract.
232      *
233      * [IMPORTANT]
234      * ====
235      * It is unsafe to assume that an address for which this function returns
236      * false is an externally-owned account (EOA) and not a contract.
237      *
238      * Among others, `isContract` will return false for the following
239      * types of addresses:
240      *
241      *  - an externally-owned account
242      *  - a contract in construction
243      *  - an address where a contract will be created
244      *  - an address where a contract lived, but was destroyed
245      * ====
246      *
247      * [IMPORTANT]
248      * ====
249      * You shouldn't rely on `isContract` to protect against flash loan attacks!
250      *
251      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
252      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
253      * constructor.
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies on extcodesize/address.code.length, which returns 0
258         // for contracts in construction, since the code is only stored at the end
259         // of the constructor execution.
260 
261         return account.code.length > 0;
262     }
263 
264     /**
265      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
266      * `recipient`, forwarding all available gas and reverting on errors.
267      *
268      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
269      * of certain opcodes, possibly making contracts go over the 2300 gas limit
270      * imposed by `transfer`, making them unable to receive funds via
271      * `transfer`. {sendValue} removes this limitation.
272      *
273      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
274      *
275      * IMPORTANT: because control is transferred to `recipient`, care must be
276      * taken to not create reentrancy vulnerabilities. Consider using
277      * {ReentrancyGuard} or the
278      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
279      */
280     function sendValue(address payable recipient, uint256 amount) internal {
281         require(address(this).balance >= amount, "Address: insufficient balance");
282 
283         (bool success, ) = recipient.call{value: amount}("");
284         require(success, "Address: unable to send value, recipient may have reverted");
285     }
286 
287     /**
288      * @dev Performs a Solidity function call using a low level `call`. A
289      * plain `call` is an unsafe replacement for a function call: use this
290      * function instead.
291      *
292      * If `target` reverts with a revert reason, it is bubbled up by this
293      * function (like regular Solidity function calls).
294      *
295      * Returns the raw returned data. To convert to the expected return value,
296      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
297      *
298      * Requirements:
299      *
300      * - `target` must be a contract.
301      * - calling `target` with `data` must not revert.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
306         return functionCall(target, data, "Address: low-level call failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
311      * `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(
316         address target,
317         bytes memory data,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         return functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         require(isContract(target), "Address: call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.call{value: value}(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
368         return functionStaticCall(target, data, "Address: low-level static call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal view returns (bytes memory) {
382         require(isContract(target), "Address: static call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.staticcall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
395         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         require(isContract(target), "Address: delegate call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.delegatecall(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
417      * revert reason using the provided one.
418      *
419      * _Available since v4.3._
420      */
421     function verifyCallResult(
422         bool success,
423         bytes memory returndata,
424         string memory errorMessage
425     ) internal pure returns (bytes memory) {
426         if (success) {
427             return returndata;
428         } else {
429             // Look for revert reason and bubble it up if present
430             if (returndata.length > 0) {
431                 // The easiest way to bubble the revert reason is using memory via assembly
432 
433                 assembly {
434                     let returndata_size := mload(returndata)
435                     revert(add(32, returndata), returndata_size)
436                 }
437             } else {
438                 revert(errorMessage);
439             }
440         }
441     }
442 }
443 
444 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
445 
446 
447 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @title ERC721 token receiver interface
453  * @dev Interface for any contract that wants to support safeTransfers
454  * from ERC721 asset contracts.
455  */
456 interface IERC721Receiver {
457     /**
458      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
459      * by `operator` from `from`, this function is called.
460      *
461      * It must return its Solidity selector to confirm the token transfer.
462      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
463      *
464      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
465      */
466     function onERC721Received(
467         address operator,
468         address from,
469         uint256 tokenId,
470         bytes calldata data
471     ) external returns (bytes4);
472 }
473 
474 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev Interface of the ERC165 standard, as defined in the
483  * https://eips.ethereum.org/EIPS/eip-165[EIP].
484  *
485  * Implementers can declare support of contract interfaces, which can then be
486  * queried by others ({ERC165Checker}).
487  *
488  * For an implementation, see {ERC165}.
489  */
490 interface IERC165 {
491     /**
492      * @dev Returns true if this contract implements the interface defined by
493      * `interfaceId`. See the corresponding
494      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
495      * to learn more about how these ids are created.
496      *
497      * This function call must use less than 30 000 gas.
498      */
499     function supportsInterface(bytes4 interfaceId) external view returns (bool);
500 }
501 
502 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 
510 /**
511  * @dev Implementation of the {IERC165} interface.
512  *
513  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
514  * for the additional interface id that will be supported. For example:
515  *
516  * ```solidity
517  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
519  * }
520  * ```
521  *
522  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
523  */
524 abstract contract ERC165 is IERC165 {
525     /**
526      * @dev See {IERC165-supportsInterface}.
527      */
528     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529         return interfaceId == type(IERC165).interfaceId;
530     }
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
534 
535 
536 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Required interface of an ERC721 compliant contract.
543  */
544 interface IERC721 is IERC165 {
545     /**
546      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
547      */
548     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
549 
550     /**
551      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
552      */
553     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
557      */
558     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
559 
560     /**
561      * @dev Returns the number of tokens in ``owner``'s account.
562      */
563     function balanceOf(address owner) external view returns (uint256 balance);
564 
565     /**
566      * @dev Returns the owner of the `tokenId` token.
567      *
568      * Requirements:
569      *
570      * - `tokenId` must exist.
571      */
572     function ownerOf(uint256 tokenId) external view returns (address owner);
573 
574     /**
575      * @dev Safely transfers `tokenId` token from `from` to `to`.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId,
591         bytes calldata data
592     ) external;
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
596      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must exist and be owned by `from`.
603      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
604      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
605      *
606      * Emits a {Transfer} event.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) external;
613 
614     /**
615      * @dev Transfers `tokenId` token from `from` to `to`.
616      *
617      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      *
626      * Emits a {Transfer} event.
627      */
628     function transferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
636      * The approval is cleared when the token is transferred.
637      *
638      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
639      *
640      * Requirements:
641      *
642      * - The caller must own the token or be an approved operator.
643      * - `tokenId` must exist.
644      *
645      * Emits an {Approval} event.
646      */
647     function approve(address to, uint256 tokenId) external;
648 
649     /**
650      * @dev Approve or remove `operator` as an operator for the caller.
651      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
652      *
653      * Requirements:
654      *
655      * - The `operator` cannot be the caller.
656      *
657      * Emits an {ApprovalForAll} event.
658      */
659     function setApprovalForAll(address operator, bool _approved) external;
660 
661     /**
662      * @dev Returns the account approved for `tokenId` token.
663      *
664      * Requirements:
665      *
666      * - `tokenId` must exist.
667      */
668     function getApproved(uint256 tokenId) external view returns (address operator);
669 
670     /**
671      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
672      *
673      * See {setApprovalForAll}
674      */
675     function isApprovedForAll(address owner, address operator) external view returns (bool);
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
688  * @dev See https://eips.ethereum.org/EIPS/eip-721
689  */
690 interface IERC721Metadata is IERC721 {
691     /**
692      * @dev Returns the token collection name.
693      */
694     function name() external view returns (string memory);
695 
696     /**
697      * @dev Returns the token collection symbol.
698      */
699     function symbol() external view returns (string memory);
700 
701     /**
702      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
703      */
704     function tokenURI(uint256 tokenId) external view returns (string memory);
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
708 
709 
710 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 
716 
717 
718 
719 
720 
721 /**
722  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
723  * the Metadata extension, but not including the Enumerable extension, which is available separately as
724  * {ERC721Enumerable}.
725  */
726 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
727     using Address for address;
728     using Strings for uint256;
729 
730     // Token name
731     string private _name;
732 
733     // Token symbol
734     string private _symbol;
735 
736     // Mapping from token ID to owner address
737     mapping(uint256 => address) private _owners;
738 
739     // Mapping owner address to token count
740     mapping(address => uint256) private _balances;
741 
742     // Mapping from token ID to approved address
743     mapping(uint256 => address) private _tokenApprovals;
744 
745     // Mapping from owner to operator approvals
746     mapping(address => mapping(address => bool)) private _operatorApprovals;
747 
748     /**
749      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
750      */
751     constructor(string memory name_, string memory symbol_) {
752         _name = name_;
753         _symbol = symbol_;
754     }
755 
756     /**
757      * @dev See {IERC165-supportsInterface}.
758      */
759     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
760         return
761             interfaceId == type(IERC721).interfaceId ||
762             interfaceId == type(IERC721Metadata).interfaceId ||
763             super.supportsInterface(interfaceId);
764     }
765 
766     /**
767      * @dev See {IERC721-balanceOf}.
768      */
769     function balanceOf(address owner) public view virtual override returns (uint256) {
770         require(owner != address(0), "ERC721: balance query for the zero address");
771         return _balances[owner];
772     }
773 
774     /**
775      * @dev See {IERC721-ownerOf}.
776      */
777     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
778         address owner = _owners[tokenId];
779         require(owner != address(0), "ERC721: owner query for nonexistent token");
780         return owner;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-name}.
785      */
786     function name() public view virtual override returns (string memory) {
787         return _name;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-symbol}.
792      */
793     function symbol() public view virtual override returns (string memory) {
794         return _symbol;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-tokenURI}.
799      */
800     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
801         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
802 
803         string memory baseURI = _baseURI();
804         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
805     }
806 
807     /**
808      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
809      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
810      * by default, can be overridden in child contracts.
811      */
812     function _baseURI() internal view virtual returns (string memory) {
813         return "";
814     }
815 
816     /**
817      * @dev See {IERC721-approve}.
818      */
819     function approve(address to, uint256 tokenId) public virtual override {
820         address owner = ERC721.ownerOf(tokenId);
821         require(to != owner, "ERC721: approval to current owner");
822 
823         require(
824             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
825             "ERC721: approve caller is not owner nor approved for all"
826         );
827 
828         _approve(to, tokenId);
829     }
830 
831     /**
832      * @dev See {IERC721-getApproved}.
833      */
834     function getApproved(uint256 tokenId) public view virtual override returns (address) {
835         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
836 
837         return _tokenApprovals[tokenId];
838     }
839 
840     /**
841      * @dev See {IERC721-setApprovalForAll}.
842      */
843     function setApprovalForAll(address operator, bool approved) public virtual override {
844         _setApprovalForAll(_msgSender(), operator, approved);
845     }
846 
847     /**
848      * @dev See {IERC721-isApprovedForAll}.
849      */
850     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
851         return _operatorApprovals[owner][operator];
852     }
853 
854     /**
855      * @dev See {IERC721-transferFrom}.
856      */
857     function transferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public virtual override {
862         //solhint-disable-next-line max-line-length
863         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
864 
865         _transfer(from, to, tokenId);
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId
875     ) public virtual override {
876         safeTransferFrom(from, to, tokenId, "");
877     }
878 
879     /**
880      * @dev See {IERC721-safeTransferFrom}.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) public virtual override {
888         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
889         _safeTransfer(from, to, tokenId, _data);
890     }
891 
892     /**
893      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
894      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
895      *
896      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
897      *
898      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
899      * implement alternative mechanisms to perform token transfer, such as signature-based.
900      *
901      * Requirements:
902      *
903      * - `from` cannot be the zero address.
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must exist and be owned by `from`.
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _safeTransfer(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) internal virtual {
916         _transfer(from, to, tokenId);
917         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
918     }
919 
920     /**
921      * @dev Returns whether `tokenId` exists.
922      *
923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
924      *
925      * Tokens start existing when they are minted (`_mint`),
926      * and stop existing when they are burned (`_burn`).
927      */
928     function _exists(uint256 tokenId) internal view virtual returns (bool) {
929         return _owners[tokenId] != address(0);
930     }
931 
932     /**
933      * @dev Returns whether `spender` is allowed to manage `tokenId`.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      */
939     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
940         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
941         address owner = ERC721.ownerOf(tokenId);
942         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
943     }
944 
945     /**
946      * @dev Safely mints `tokenId` and transfers it to `to`.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must not exist.
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _safeMint(address to, uint256 tokenId) internal virtual {
956         _safeMint(to, tokenId, "");
957     }
958 
959     /**
960      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
961      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
962      */
963     function _safeMint(
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) internal virtual {
968         _mint(to, tokenId);
969         require(
970             _checkOnERC721Received(address(0), to, tokenId, _data),
971             "ERC721: transfer to non ERC721Receiver implementer"
972         );
973     }
974 
975     /**
976      * @dev Mints `tokenId` and transfers it to `to`.
977      *
978      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
979      *
980      * Requirements:
981      *
982      * - `tokenId` must not exist.
983      * - `to` cannot be the zero address.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _mint(address to, uint256 tokenId) internal virtual {
988         require(to != address(0), "ERC721: mint to the zero address");
989         require(!_exists(tokenId), "ERC721: token already minted");
990 
991         _beforeTokenTransfer(address(0), to, tokenId);
992 
993         _balances[to] += 1;
994         _owners[tokenId] = to;
995 
996         emit Transfer(address(0), to, tokenId);
997 
998         _afterTokenTransfer(address(0), to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Destroys `tokenId`.
1003      * The approval is cleared when the token is burned.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _burn(uint256 tokenId) internal virtual {
1012         address owner = ERC721.ownerOf(tokenId);
1013 
1014         _beforeTokenTransfer(owner, address(0), tokenId);
1015 
1016         // Clear approvals
1017         _approve(address(0), tokenId);
1018 
1019         _balances[owner] -= 1;
1020         delete _owners[tokenId];
1021 
1022         emit Transfer(owner, address(0), tokenId);
1023 
1024         _afterTokenTransfer(owner, address(0), tokenId);
1025     }
1026 
1027     /**
1028      * @dev Transfers `tokenId` from `from` to `to`.
1029      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1030      *
1031      * Requirements:
1032      *
1033      * - `to` cannot be the zero address.
1034      * - `tokenId` token must be owned by `from`.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _transfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) internal virtual {
1043         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1044         require(to != address(0), "ERC721: transfer to the zero address");
1045 
1046         _beforeTokenTransfer(from, to, tokenId);
1047 
1048         // Clear approvals from the previous owner
1049         _approve(address(0), tokenId);
1050 
1051         _balances[from] -= 1;
1052         _balances[to] += 1;
1053         _owners[tokenId] = to;
1054 
1055         emit Transfer(from, to, tokenId);
1056 
1057         _afterTokenTransfer(from, to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Approve `to` to operate on `tokenId`
1062      *
1063      * Emits a {Approval} event.
1064      */
1065     function _approve(address to, uint256 tokenId) internal virtual {
1066         _tokenApprovals[tokenId] = to;
1067         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev Approve `operator` to operate on all of `owner` tokens
1072      *
1073      * Emits a {ApprovalForAll} event.
1074      */
1075     function _setApprovalForAll(
1076         address owner,
1077         address operator,
1078         bool approved
1079     ) internal virtual {
1080         require(owner != operator, "ERC721: approve to caller");
1081         _operatorApprovals[owner][operator] = approved;
1082         emit ApprovalForAll(owner, operator, approved);
1083     }
1084 
1085     /**
1086      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1087      * The call is not executed if the target address is not a contract.
1088      *
1089      * @param from address representing the previous owner of the given token ID
1090      * @param to target address that will receive the tokens
1091      * @param tokenId uint256 ID of the token to be transferred
1092      * @param _data bytes optional data to send along with the call
1093      * @return bool whether the call correctly returned the expected magic value
1094      */
1095     function _checkOnERC721Received(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) private returns (bool) {
1101         if (to.isContract()) {
1102             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1103                 return retval == IERC721Receiver.onERC721Received.selector;
1104             } catch (bytes memory reason) {
1105                 if (reason.length == 0) {
1106                     revert("ERC721: transfer to non ERC721Receiver implementer");
1107                 } else {
1108                     assembly {
1109                         revert(add(32, reason), mload(reason))
1110                     }
1111                 }
1112             }
1113         } else {
1114             return true;
1115         }
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before any token transfer. This includes minting
1120      * and burning.
1121      *
1122      * Calling conditions:
1123      *
1124      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1125      * transferred to `to`.
1126      * - When `from` is zero, `tokenId` will be minted for `to`.
1127      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1128      * - `from` and `to` are never both zero.
1129      *
1130      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1131      */
1132     function _beforeTokenTransfer(
1133         address from,
1134         address to,
1135         uint256 tokenId
1136     ) internal virtual {}
1137 
1138     /**
1139      * @dev Hook that is called after any transfer of tokens. This includes
1140      * minting and burning.
1141      *
1142      * Calling conditions:
1143      *
1144      * - when `from` and `to` are both non-zero.
1145      * - `from` and `to` are never both zero.
1146      *
1147      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1148      */
1149     function _afterTokenTransfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) internal virtual {}
1154 }
1155 
1156 // File: contracts/modern.sol
1157 
1158 
1159 
1160 pragma solidity >=0.7.0 <0.9.0;
1161 
1162 
1163 
1164 
1165 contract ModernGuysPunks is ERC721, Ownable {
1166   using Strings for uint256;
1167   using Counters for Counters.Counter;
1168 
1169   Counters.Counter private supply;
1170 
1171   string public uriPrefix = "";
1172   string public uriSuffix = ".json";
1173   string public hiddenMetadataUri;
1174   
1175   uint256 public cost = 0 ether;
1176   uint256 public maxSupply = 4999;
1177   uint256 public maxMintAmountPerTx = 5;
1178 
1179   bool public paused = false;
1180   bool public revealed = true;
1181 
1182   constructor() ERC721("Modern Guys Punks", "MGP") {
1183     setHiddenMetadataUri("ipfs://QmRk1vy4p2ihgdxn3D5XqkzoLrdtntWKsozCsdaK2sYzJS/1.json");
1184   }
1185 
1186   modifier mintCompliance(uint256 _mintAmount) {
1187     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1188     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1189     _;
1190   }
1191 
1192   function totalSupply() public view returns (uint256) {
1193     return supply.current();
1194   }
1195 
1196   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1197     require(!paused, "The contract is paused!");
1198     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1199 
1200     _mintLoop(msg.sender, _mintAmount);
1201   }
1202   
1203   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1204     _mintLoop(_receiver, _mintAmount);
1205   }
1206 
1207   function walletOfOwner(address _owner)
1208     public
1209     view
1210     returns (uint256[] memory)
1211   {
1212     uint256 ownerTokenCount = balanceOf(_owner);
1213     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1214     uint256 currentTokenId = 1;
1215     uint256 ownedTokenIndex = 0;
1216 
1217     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1218       address currentTokenOwner = ownerOf(currentTokenId);
1219 
1220       if (currentTokenOwner == _owner) {
1221         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1222 
1223         ownedTokenIndex++;
1224       }
1225 
1226       currentTokenId++;
1227     }
1228 
1229     return ownedTokenIds;
1230   }
1231 
1232   function tokenURI(uint256 _tokenId)
1233     public
1234     view
1235     virtual
1236     override
1237     returns (string memory)
1238   {
1239     require(
1240       _exists(_tokenId),
1241       "ERC721Metadata: URI query for nonexistent token"
1242     );
1243 
1244     if (revealed == false) {
1245       return hiddenMetadataUri;
1246     }
1247 
1248     string memory currentBaseURI = _baseURI();
1249     return bytes(currentBaseURI).length > 0
1250         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1251         : "";
1252   }
1253 
1254   function setRevealed(bool _state) public onlyOwner {
1255     revealed = _state;
1256   }
1257 
1258   function setCost(uint256 _cost) public onlyOwner {
1259     cost = _cost;
1260   }
1261 
1262   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1263     maxMintAmountPerTx = _maxMintAmountPerTx;
1264   }
1265 
1266   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1267     hiddenMetadataUri = _hiddenMetadataUri;
1268   }
1269 
1270   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1271     uriPrefix = _uriPrefix;
1272   }
1273 
1274   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1275     uriSuffix = _uriSuffix;
1276   }
1277 
1278   function setPaused(bool _state) public onlyOwner {
1279     paused = _state;
1280   }
1281 
1282   function withdraw() public onlyOwner {
1283 
1284     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1285     require(os);
1286 
1287   }
1288 
1289   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1290     for (uint256 i = 0; i < _mintAmount; i++) {
1291       supply.increment();
1292       _safeMint(_receiver, supply.current());
1293     }
1294   }
1295 
1296   function _baseURI() internal view virtual override returns (string memory) {
1297     return uriPrefix;
1298   }
1299 }