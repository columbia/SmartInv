1 //SPDX-License-Identifier: UNLICENSED
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
226 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
227 
228 pragma solidity ^0.8.0;
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
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @title ERC721 token receiver interface
452  * @dev Interface for any contract that wants to support safeTransfers
453  * from ERC721 asset contracts.
454  */
455 interface IERC721Receiver {
456     /**
457      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
458      * by `operator` from `from`, this function is called.
459      *
460      * It must return its Solidity selector to confirm the token transfer.
461      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
462      *
463      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
464      */
465     function onERC721Received(
466         address operator,
467         address from,
468         uint256 tokenId,
469         bytes calldata data
470     ) external returns (bytes4);
471 }
472 
473 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Interface of the ERC165 standard, as defined in the
482  * https://eips.ethereum.org/EIPS/eip-165[EIP].
483  *
484  * Implementers can declare support of contract interfaces, which can then be
485  * queried by others ({ERC165Checker}).
486  *
487  * For an implementation, see {ERC165}.
488  */
489 interface IERC165 {
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30 000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Required interface of an ERC721 compliant contract.
542  */
543 interface IERC721 is IERC165 {
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
556      */
557     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
558 
559     /**
560      * @dev Returns the number of tokens in ``owner``'s account.
561      */
562     function balanceOf(address owner) external view returns (uint256 balance);
563 
564     /**
565      * @dev Returns the owner of the `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function ownerOf(uint256 tokenId) external view returns (address owner);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Transfers `tokenId` token from `from` to `to`.
595      *
596      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must be owned by `from`.
603      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
618      *
619      * Requirements:
620      *
621      * - The caller must own the token or be an approved operator.
622      * - `tokenId` must exist.
623      *
624      * Emits an {Approval} event.
625      */
626     function approve(address to, uint256 tokenId) external;
627 
628     /**
629      * @dev Returns the account approved for `tokenId` token.
630      *
631      * Requirements:
632      *
633      * - `tokenId` must exist.
634      */
635     function getApproved(uint256 tokenId) external view returns (address operator);
636 
637     /**
638      * @dev Approve or remove `operator` as an operator for the caller.
639      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
640      *
641      * Requirements:
642      *
643      * - The `operator` cannot be the caller.
644      *
645      * Emits an {ApprovalForAll} event.
646      */
647     function setApprovalForAll(address operator, bool _approved) external;
648 
649     /**
650      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
651      *
652      * See {setApprovalForAll}
653      */
654     function isApprovedForAll(address owner, address operator) external view returns (bool);
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
666      *
667      * Emits a {Transfer} event.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId,
673         bytes calldata data
674     ) external;
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
687  * @dev See https://eips.ethereum.org/EIPS/eip-721
688  */
689 interface IERC721Metadata is IERC721 {
690     /**
691      * @dev Returns the token collection name.
692      */
693     function name() external view returns (string memory);
694 
695     /**
696      * @dev Returns the token collection symbol.
697      */
698     function symbol() external view returns (string memory);
699 
700     /**
701      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
702      */
703     function tokenURI(uint256 tokenId) external view returns (string memory);
704 }
705 
706 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
710 
711 pragma solidity ^0.8.0;
712 /**
713  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
714  * the Metadata extension, but not including the Enumerable extension, which is available separately as
715  * {ERC721Enumerable}.
716  */
717 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
718     using Address for address;
719     using Strings for uint256;
720 
721     // Token name
722     string private _name;
723 
724     // Token symbol
725     string private _symbol;
726 
727     // Mapping from token ID to owner address
728     mapping(uint256 => address) private _owners;
729 
730     // Mapping owner address to token count
731     mapping(address => uint256) private _balances;
732 
733     // Mapping from token ID to approved address
734     mapping(uint256 => address) private _tokenApprovals;
735 
736     // Mapping from owner to operator approvals
737     mapping(address => mapping(address => bool)) private _operatorApprovals;
738 
739     /**
740      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
741      */
742     constructor(string memory name_, string memory symbol_) {
743         _name = name_;
744         _symbol = symbol_;
745     }
746 
747     /**
748      * @dev See {IERC165-supportsInterface}.
749      */
750     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
751         return
752             interfaceId == type(IERC721).interfaceId ||
753             interfaceId == type(IERC721Metadata).interfaceId ||
754             super.supportsInterface(interfaceId);
755     }
756 
757     /**
758      * @dev See {IERC721-balanceOf}.
759      */
760     function balanceOf(address owner) public view virtual override returns (uint256) {
761         require(owner != address(0), "ERC721: balance query for the zero address");
762         return _balances[owner];
763     }
764 
765     /**
766      * @dev See {IERC721-ownerOf}.
767      */
768     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
769         address owner = _owners[tokenId];
770         require(owner != address(0), "ERC721: owner query for nonexistent token");
771         return owner;
772     }
773 
774     /**
775      * @dev See {IERC721Metadata-name}.
776      */
777     function name() public view virtual override returns (string memory) {
778         return _name;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-symbol}.
783      */
784     function symbol() public view virtual override returns (string memory) {
785         return _symbol;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-tokenURI}.
790      */
791     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
792         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
793 
794         string memory baseURI = _baseURI();
795         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
796     }
797 
798     /**
799      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
800      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
801      * by default, can be overriden in child contracts.
802      */
803     function _baseURI() internal view virtual returns (string memory) {
804         return "";
805     }
806 
807     /**
808      * @dev See {IERC721-approve}.
809      */
810     function approve(address to, uint256 tokenId) public virtual override {
811         address owner = ERC721.ownerOf(tokenId);
812         require(to != owner, "ERC721: approval to current owner");
813 
814         require(
815             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
816             "ERC721: approve caller is not owner nor approved for all"
817         );
818 
819         _approve(to, tokenId);
820     }
821 
822     /**
823      * @dev See {IERC721-getApproved}.
824      */
825     function getApproved(uint256 tokenId) public view virtual override returns (address) {
826         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
827 
828         return _tokenApprovals[tokenId];
829     }
830 
831     /**
832      * @dev See {IERC721-setApprovalForAll}.
833      */
834     function setApprovalForAll(address operator, bool approved) public virtual override {
835         _setApprovalForAll(_msgSender(), operator, approved);
836     }
837 
838     /**
839      * @dev See {IERC721-isApprovedForAll}.
840      */
841     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
842         return _operatorApprovals[owner][operator];
843     }
844 
845     /**
846      * @dev See {IERC721-transferFrom}.
847      */
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         //solhint-disable-next-line max-line-length
854         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
855 
856         _transfer(from, to, tokenId);
857     }
858 
859     /**
860      * @dev See {IERC721-safeTransferFrom}.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public virtual override {
867         safeTransferFrom(from, to, tokenId, "");
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId,
877         bytes memory _data
878     ) public virtual override {
879         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
880         _safeTransfer(from, to, tokenId, _data);
881     }
882 
883     /**
884      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
885      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
886      *
887      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
888      *
889      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
890      * implement alternative mechanisms to perform token transfer, such as signature-based.
891      *
892      * Requirements:
893      *
894      * - `from` cannot be the zero address.
895      * - `to` cannot be the zero address.
896      * - `tokenId` token must exist and be owned by `from`.
897      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _safeTransfer(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) internal virtual {
907         _transfer(from, to, tokenId);
908         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
909     }
910 
911     /**
912      * @dev Returns whether `tokenId` exists.
913      *
914      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
915      *
916      * Tokens start existing when they are minted (`_mint`),
917      * and stop existing when they are burned (`_burn`).
918      */
919     function _exists(uint256 tokenId) internal view virtual returns (bool) {
920         return _owners[tokenId] != address(0);
921     }
922 
923     /**
924      * @dev Returns whether `spender` is allowed to manage `tokenId`.
925      *
926      * Requirements:
927      *
928      * - `tokenId` must exist.
929      */
930     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
931         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
932         address owner = ERC721.ownerOf(tokenId);
933         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
934     }
935 
936     /**
937      * @dev Safely mints `tokenId` and transfers it to `to`.
938      *
939      * Requirements:
940      *
941      * - `tokenId` must not exist.
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _safeMint(address to, uint256 tokenId) internal virtual {
947         _safeMint(to, tokenId, "");
948     }
949 
950     /**
951      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
952      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
953      */
954     function _safeMint(
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) internal virtual {
959         _mint(to, tokenId);
960         require(
961             _checkOnERC721Received(address(0), to, tokenId, _data),
962             "ERC721: transfer to non ERC721Receiver implementer"
963         );
964     }
965 
966     /**
967      * @dev Mints `tokenId` and transfers it to `to`.
968      *
969      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
970      *
971      * Requirements:
972      *
973      * - `tokenId` must not exist.
974      * - `to` cannot be the zero address.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _mint(address to, uint256 tokenId) internal virtual {
979         require(to != address(0), "ERC721: mint to the zero address");
980         require(!_exists(tokenId), "ERC721: token already minted");
981 
982         _beforeTokenTransfer(address(0), to, tokenId);
983 
984         _balances[to] += 1;
985         _owners[tokenId] = to;
986 
987         emit Transfer(address(0), to, tokenId);
988     }
989 
990     /**
991      * @dev Destroys `tokenId`.
992      * The approval is cleared when the token is burned.
993      *
994      * Requirements:
995      *
996      * - `tokenId` must exist.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _burn(uint256 tokenId) internal virtual {
1001         address owner = ERC721.ownerOf(tokenId);
1002 
1003         _beforeTokenTransfer(owner, address(0), tokenId);
1004 
1005         // Clear approvals
1006         _approve(address(0), tokenId);
1007 
1008         _balances[owner] -= 1;
1009         delete _owners[tokenId];
1010 
1011         emit Transfer(owner, address(0), tokenId);
1012     }
1013 
1014     /**
1015      * @dev Transfers `tokenId` from `from` to `to`.
1016      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _transfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) internal virtual {
1030         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1031         require(to != address(0), "ERC721: transfer to the zero address");
1032 
1033         _beforeTokenTransfer(from, to, tokenId);
1034 
1035         // Clear approvals from the previous owner
1036         _approve(address(0), tokenId);
1037 
1038         _balances[from] -= 1;
1039         _balances[to] += 1;
1040         _owners[tokenId] = to;
1041 
1042         emit Transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Approve `to` to operate on `tokenId`
1047      *
1048      * Emits a {Approval} event.
1049      */
1050     function _approve(address to, uint256 tokenId) internal virtual {
1051         _tokenApprovals[tokenId] = to;
1052         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Approve `operator` to operate on all of `owner` tokens
1057      *
1058      * Emits a {ApprovalForAll} event.
1059      */
1060     function _setApprovalForAll(
1061         address owner,
1062         address operator,
1063         bool approved
1064     ) internal virtual {
1065         require(owner != operator, "ERC721: approve to caller");
1066         _operatorApprovals[owner][operator] = approved;
1067         emit ApprovalForAll(owner, operator, approved);
1068     }
1069 
1070     /**
1071      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1072      * The call is not executed if the target address is not a contract.
1073      *
1074      * @param from address representing the previous owner of the given token ID
1075      * @param to target address that will receive the tokens
1076      * @param tokenId uint256 ID of the token to be transferred
1077      * @param _data bytes optional data to send along with the call
1078      * @return bool whether the call correctly returned the expected magic value
1079      */
1080     function _checkOnERC721Received(
1081         address from,
1082         address to,
1083         uint256 tokenId,
1084         bytes memory _data
1085     ) private returns (bool) {
1086         if (to.isContract()) {
1087             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1088                 return retval == IERC721Receiver.onERC721Received.selector;
1089             } catch (bytes memory reason) {
1090                 if (reason.length == 0) {
1091                     revert("ERC721: transfer to non ERC721Receiver implementer");
1092                 } else {
1093                     assembly {
1094                         revert(add(32, reason), mload(reason))
1095                     }
1096                 }
1097             }
1098         } else {
1099             return true;
1100         }
1101     }
1102 
1103     /**
1104      * @dev Hook that is called before any token transfer. This includes minting
1105      * and burning.
1106      *
1107      * Calling conditions:
1108      *
1109      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1110      * transferred to `to`.
1111      * - When `from` is zero, `tokenId` will be minted for `to`.
1112      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1113      * - `from` and `to` are never both zero.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) internal virtual {}
1122 }
1123 
1124 
1125 pragma solidity >=0.7.0 <0.9.0;
1126 
1127 contract DickMFers is ERC721, Ownable {
1128   using Strings for uint256;
1129   using Counters for Counters.Counter;
1130 
1131   Counters.Counter private supply;
1132 
1133   string public uriPrefix = "";
1134   string public uriSuffix = ".json";
1135   string public hiddenMetadataUri;
1136   
1137   uint256 public cost = 0.01 ether;
1138   uint256 public wlcost = 0.01 ether;
1139   uint256 public maxSupply = 10000;
1140   uint256 public _freeSupply = 1000;
1141   uint256 public _freeMintLimit = 20;
1142   uint256 public maxMintAmountPerTx = 20;
1143   uint256 public maxMintPerUser = 100;
1144 
1145   bool public whiteListActive = false;
1146   mapping(address => bool) private _whitelist;
1147 
1148   uint256 private startTime;
1149   uint256 private _WLstartTime;
1150   bool public paused = true;
1151   bool public revealed = false;
1152 
1153   constructor() ERC721("Dick MFers", "Dick MFers") {
1154     setHiddenMetadataUri("ipfs://looool/hidden.json");
1155   }
1156 
1157   modifier mintCompliance(uint256 _mintAmount) {
1158     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1159     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1160     _;
1161   }
1162 
1163   function setStartTime(uint256 _startTime) external onlyOwner {
1164       startTime = _startTime;
1165   }
1166   
1167   function setWLStartTime(uint256 WLstartTime) external onlyOwner {
1168       _WLstartTime = WLstartTime;
1169   }
1170 
1171   function totalSupply() public view returns (uint256) {
1172     return supply.current();
1173   }
1174 
1175   function setwhiteListActive() external onlyOwner {
1176         whiteListActive = true;
1177       }
1178 
1179   function setwhiteListInActive() external onlyOwner {
1180         whiteListActive = false;
1181       }
1182 
1183   function setMaxMintPerUser(uint256 _maxMintPerUser) external onlyOwner {
1184       maxMintPerUser = _maxMintPerUser;
1185   }
1186 
1187   function addSingleWhiteList(address _addr) public onlyOwner {
1188       _whitelist[_addr] = true;
1189   }
1190 
1191   function addMultipleToWhiteList(address[] memory addresses) external onlyOwner {
1192         for (uint256 i = 0; i < addresses.length; i++) {
1193           require(addresses[i] != address(0), "Can't add the null address");
1194           _whitelist[addresses[i]] = true;
1195           
1196         }
1197       }  
1198 
1199   function isInWhiteList(address _addr) private view returns (bool) {
1200       return _whitelist[_addr];
1201   }
1202 
1203   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1204     require(!paused, "The contract is paused!");
1205     require(msg.value == cost * _mintAmount, "Insufficient funds!");
1206     require(block.timestamp >= startTime,"The sale has not started yet.");
1207     require(balanceOf(msg.sender)+_mintAmount <= maxMintPerUser, "Please Lower Amount");
1208     _mintLoop(msg.sender, _mintAmount);
1209   }
1210   
1211 
1212   function setfreemintlimit (uint256 limit) public onlyOwner {
1213       _freeMintLimit = limit;
1214   }
1215 
1216   function setfreeSupply (uint256 freeamt) public onlyOwner {
1217       _freeSupply = freeamt;
1218   }
1219 
1220   function freemint( uint256 _mintAmount) public payable {
1221       require(owner() == msg.sender || !paused, "Mint disabled");
1222       require(totalSupply() + _mintAmount <= _freeSupply, "Exceed max free supply");
1223       require(_mintAmount <= _freeMintLimit, "Cant mint more than mint limit");
1224       require(_mintAmount > 0, "Must mint at least 1 token");
1225       require(balanceOf(msg.sender)+_mintAmount <= maxMintPerUser, "Please Lower Amount");
1226       _mintLoop(msg.sender, _mintAmount);
1227   }
1228   
1229   function WhiteListMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1230     require(!whiteListActive, "The contract is paused!");
1231     require(msg.value >= wlcost * _mintAmount, "Insufficient funds!");
1232     require(block.timestamp >= _WLstartTime,"The sale has not started yet.");
1233     require(_whitelist[msg.sender], "You are not on the  WhiteList");
1234     require(balanceOf(msg.sender)+_mintAmount <= maxMintPerUser, "Please Lower Amount");
1235     _mintLoop(msg.sender, _mintAmount);
1236   }
1237   
1238   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1239     _mintLoop(_receiver, _mintAmount);
1240   }
1241 
1242   function walletOfOwner(address _owner)
1243     public
1244     view
1245     returns (uint256[] memory)
1246   {
1247     uint256 ownerTokenCount = balanceOf(_owner);
1248     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1249     uint256 currentTokenId = 1;
1250     uint256 ownedTokenIndex = 0;
1251 
1252     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1253       address currentTokenOwner = ownerOf(currentTokenId);
1254 
1255       if (currentTokenOwner == _owner) {
1256         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1257 
1258         ownedTokenIndex++;
1259       }
1260 
1261       currentTokenId++;
1262     }
1263 
1264     return ownedTokenIds;
1265   }
1266 
1267   function tokenURI(uint256 _tokenId)
1268     public
1269     view
1270     virtual
1271     override
1272     returns (string memory)
1273   {
1274     require(
1275       _exists(_tokenId),
1276       "ERC721Metadata: URI query for nonexistent token"
1277     );
1278 
1279     if (revealed == false) {
1280       return hiddenMetadataUri;
1281     }
1282 
1283     string memory currentBaseURI = _baseURI();
1284     return bytes(currentBaseURI).length > 0
1285         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1286         : "";
1287   }
1288 
1289   function setRevealed(bool _state) public onlyOwner {
1290     revealed = _state;
1291   }
1292 
1293   function setCost(uint256 _cost) public onlyOwner {
1294     cost = _cost;
1295   }
1296 
1297   function setWLCost(uint256 _wlcost) public onlyOwner {
1298     wlcost = _wlcost;
1299   }
1300 
1301   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1302     maxMintAmountPerTx = _maxMintAmountPerTx;
1303   }
1304 
1305   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1306     hiddenMetadataUri = _hiddenMetadataUri;
1307   }
1308 
1309   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1310     uriPrefix = _uriPrefix;
1311   }
1312 
1313   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1314     uriSuffix = _uriSuffix;
1315   }
1316 
1317   function setPaused(bool _state) public onlyOwner {
1318     paused = _state;
1319   }
1320 
1321   function withdraw() public onlyOwner {
1322     (bool project, ) = payable(owner()).call{value: address(this).balance}("");
1323     require(project);
1324   }
1325 
1326   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1327     for (uint256 i = 0; i < _mintAmount; i++) {
1328       supply.increment();
1329       _safeMint(_receiver, supply.current());
1330     }
1331   }
1332 
1333   function _baseURI() internal view virtual override returns (string memory) {
1334     return uriPrefix;
1335   }
1336 }