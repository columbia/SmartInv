1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/access/Ownable.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169     /**
170      * @dev Initializes the contract setting the deployer as the initial owner.
171      */
172     constructor() {
173         _transferOwnership(_msgSender());
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     /**
192      * @dev Leaves the contract without owner. It will not be possible to call
193      * `onlyOwner` functions anymore. Can only be called by the current owner.
194      *
195      * NOTE: Renouncing ownership will leave the contract without an owner,
196      * thereby removing any functionality that is only available to the owner.
197      */
198     function renounceOwnership() public virtual onlyOwner {
199         _transferOwnership(address(0));
200     }
201 
202     /**
203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
204      * Can only be called by the current owner.
205      */
206     function transferOwnership(address newOwner) public virtual onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         _transferOwnership(newOwner);
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Internal function without access restriction.
214      */
215     function _transferOwnership(address newOwner) internal virtual {
216         address oldOwner = _owner;
217         _owner = newOwner;
218         emit OwnershipTransferred(oldOwner, newOwner);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Address.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
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
445 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
462      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
534 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
573      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
574      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must exist and be owned by `from`.
581      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
582      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
583      *
584      * Emits a {Transfer} event.
585      */
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 tokenId
590     ) external;
591 
592     /**
593      * @dev Transfers `tokenId` token from `from` to `to`.
594      *
595      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603      *
604      * Emits a {Transfer} event.
605      */
606     function transferFrom(
607         address from,
608         address to,
609         uint256 tokenId
610     ) external;
611 
612     /**
613      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
614      * The approval is cleared when the token is transferred.
615      *
616      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
617      *
618      * Requirements:
619      *
620      * - The caller must own the token or be an approved operator.
621      * - `tokenId` must exist.
622      *
623      * Emits an {Approval} event.
624      */
625     function approve(address to, uint256 tokenId) external;
626 
627     /**
628      * @dev Returns the account approved for `tokenId` token.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function getApproved(uint256 tokenId) external view returns (address operator);
635 
636     /**
637      * @dev Approve or remove `operator` as an operator for the caller.
638      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
639      *
640      * Requirements:
641      *
642      * - The `operator` cannot be the caller.
643      *
644      * Emits an {ApprovalForAll} event.
645      */
646     function setApprovalForAll(address operator, bool _approved) external;
647 
648     /**
649      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
650      *
651      * See {setApprovalForAll}
652      */
653     function isApprovedForAll(address owner, address operator) external view returns (bool);
654 
655     /**
656      * @dev Safely transfers `tokenId` token from `from` to `to`.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665      *
666      * Emits a {Transfer} event.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes calldata data
673     ) external;
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
708 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
808      * by default, can be overriden in child contracts.
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
940         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
995     }
996 
997     /**
998      * @dev Destroys `tokenId`.
999      * The approval is cleared when the token is burned.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _burn(uint256 tokenId) internal virtual {
1008         address owner = ERC721.ownerOf(tokenId);
1009 
1010         _beforeTokenTransfer(owner, address(0), tokenId);
1011 
1012         // Clear approvals
1013         _approve(address(0), tokenId);
1014 
1015         _balances[owner] -= 1;
1016         delete _owners[tokenId];
1017 
1018         emit Transfer(owner, address(0), tokenId);
1019     }
1020 
1021     /**
1022      * @dev Transfers `tokenId` from `from` to `to`.
1023      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must be owned by `from`.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _transfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) internal virtual {
1037         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1038         require(to != address(0), "ERC721: transfer to the zero address");
1039 
1040         _beforeTokenTransfer(from, to, tokenId);
1041 
1042         // Clear approvals from the previous owner
1043         _approve(address(0), tokenId);
1044 
1045         _balances[from] -= 1;
1046         _balances[to] += 1;
1047         _owners[tokenId] = to;
1048 
1049         emit Transfer(from, to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Approve `to` to operate on `tokenId`
1054      *
1055      * Emits a {Approval} event.
1056      */
1057     function _approve(address to, uint256 tokenId) internal virtual {
1058         _tokenApprovals[tokenId] = to;
1059         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev Approve `operator` to operate on all of `owner` tokens
1064      *
1065      * Emits a {ApprovalForAll} event.
1066      */
1067     function _setApprovalForAll(
1068         address owner,
1069         address operator,
1070         bool approved
1071     ) internal virtual {
1072         require(owner != operator, "ERC721: approve to caller");
1073         _operatorApprovals[owner][operator] = approved;
1074         emit ApprovalForAll(owner, operator, approved);
1075     }
1076 
1077     /**
1078      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1079      * The call is not executed if the target address is not a contract.
1080      *
1081      * @param from address representing the previous owner of the given token ID
1082      * @param to target address that will receive the tokens
1083      * @param tokenId uint256 ID of the token to be transferred
1084      * @param _data bytes optional data to send along with the call
1085      * @return bool whether the call correctly returned the expected magic value
1086      */
1087     function _checkOnERC721Received(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) private returns (bool) {
1093         if (to.isContract()) {
1094             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1095                 return retval == IERC721Receiver.onERC721Received.selector;
1096             } catch (bytes memory reason) {
1097                 if (reason.length == 0) {
1098                     revert("ERC721: transfer to non ERC721Receiver implementer");
1099                 } else {
1100                     assembly {
1101                         revert(add(32, reason), mload(reason))
1102                     }
1103                 }
1104             }
1105         } else {
1106             return true;
1107         }
1108     }
1109 
1110     /**
1111      * @dev Hook that is called before any token transfer. This includes minting
1112      * and burning.
1113      *
1114      * Calling conditions:
1115      *
1116      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1117      * transferred to `to`.
1118      * - When `from` is zero, `tokenId` will be minted for `to`.
1119      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1120      * - `from` and `to` are never both zero.
1121      *
1122      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1123      */
1124     function _beforeTokenTransfer(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) internal virtual {}
1129 }
1130 
1131 // File: amongus.sol
1132 
1133 
1134 
1135 
1136  
1137  /*
1138 
1139 ============================================== COOLAMONGUS.CLUB ==============================================
1140 */                                                                                                         
1141 
1142 
1143 
1144 pragma solidity ^0.8.0;
1145 
1146 
1147 
1148 
1149 /**
1150  * @title among us
1151  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1152  */
1153                                                                                                      
1154                                                                                             
1155 
1156  contract OwnableDelegateProxy {}
1157 
1158 contract ProxyRegistry {
1159     mapping(address => OwnableDelegateProxy) public proxies;
1160 }
1161  
1162 contract CoolAmongUs is ERC721, Ownable {
1163 
1164     bool public saleIsActive = false;
1165     string private _baseURIextended = "https://coolamongus.s3.us-west-1.amazonaws.com/metadata/coolamongus-metadata-";
1166 
1167     uint256 public Price = 0.015 ether;
1168 	uint public maxPerTx =10;
1169 	uint public maxFreeMintPerWallet = 20;
1170 	uint public amountAvailableFreeMint = 2000;
1171 	uint public maxSupply = 5555;
1172 	address proxyRegistryAddress ; 
1173 	mapping(address => uint) public addressFreeMinted;
1174 	
1175 	
1176 	
1177 
1178     using Counters for Counters.Counter;
1179     Counters.Counter private _tokenSupply;
1180 
1181 
1182 
1183     constructor() ERC721("CoolAmongUs", "CAU") {
1184     }
1185 
1186     function totalSupply() public view returns (uint256 supply) {
1187         return _tokenSupply.current();
1188     }
1189 
1190     function setBaseURI(string memory baseURI_) external onlyOwner() {
1191         _baseURIextended = baseURI_;
1192     }
1193 
1194     function _baseURI() internal view virtual override returns (string memory) {
1195         return _baseURIextended;
1196     }
1197 
1198     function setSaleState(bool newState) public onlyOwner {
1199         saleIsActive = newState;
1200     }
1201 
1202     // function isSaleActive() external view returns (bool) {
1203     //     return saleIsActive;
1204     // }
1205 
1206     function setPrice(uint256 newPrice) public onlyOwner {
1207         Price = newPrice;
1208     }
1209 
1210     // rinkeby: 0xf57b2c51ded3a29e6891aba85459d600256cf317
1211     // mainnet: 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1212     function setProxyRegistryAddress(address proxyAddress) external onlyOwner {
1213         proxyRegistryAddress = proxyAddress;
1214     }
1215 
1216     function isApprovedForAll(address owner, address operator)
1217         public
1218         view
1219         override
1220         returns (bool)
1221     {
1222         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1223         if (address(proxyRegistry.proxies(owner)) == operator) {
1224             return true;
1225         }
1226 
1227         return super.isApprovedForAll(owner, operator);
1228     }
1229 
1230     function mint(uint numberOfTokens) external payable {
1231         require(saleIsActive, "Sale is inactive.");
1232         require(numberOfTokens <= maxPerTx, "You can only mint 10 at a time.");
1233         require(_tokenSupply.current() + numberOfTokens <= maxSupply, "Purchase would exceed max supply of tokens");
1234         
1235         if (_tokenSupply.current() + numberOfTokens > amountAvailableFreeMint) {
1236             require((Price * numberOfTokens) <= msg.value, "Don't send under (in ETH).");
1237         } else {
1238 			require(msg.value == 0, "Don't send ether for the free mint.");
1239 			require(addressFreeMinted[msg.sender] < maxFreeMintPerWallet, "You can only adopt 20 free CAU per wallet. Wait for the paid adoption.");
1240 		}
1241 		
1242 		addressFreeMinted[msg.sender] += numberOfTokens;
1243         for(uint i = 0; i < numberOfTokens; i++) {
1244 		  uint256 _tokenId = _tokenSupply.current() + 1;
1245             _safeMint(msg.sender, _tokenId);
1246             _tokenSupply.increment();
1247         }
1248     }
1249 
1250      function gift(address _to) external onlyOwner {
1251         uint256 _tokenId = _tokenSupply.current() + 1;
1252         _safeMint(_to, _tokenId);
1253         _tokenSupply.increment();
1254     }
1255 
1256     function withdraw() public onlyOwner {
1257         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1258         require(
1259             success,
1260             "Address: unable to send value, recipient may have reverted"
1261         );
1262     }
1263 
1264     // function withdraw() public onlyOwner {
1265     //     uint256 balance = address(this).balance;
1266     //     Address.sendValue(shareholderAddress, balance);
1267     // }
1268 
1269 }