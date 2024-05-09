1 // Sources flattened with hardhat v2.6.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _setOwner(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
104 
105 
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Interface of the ERC165 standard, as defined in the
111  * https://eips.ethereum.org/EIPS/eip-165[EIP].
112  *
113  * Implementers can declare support of contract interfaces, which can then be
114  * queried by others ({ERC165Checker}).
115  *
116  * For an implementation, see {ERC165}.
117  */
118 interface IERC165 {
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30 000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 }
129 
130 
131 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
132 
133 
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Required interface of an ERC721 compliant contract.
139  */
140 interface IERC721 is IERC165 {
141     /**
142      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
148      */
149     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
153      */
154     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
155 
156     /**
157      * @dev Returns the number of tokens in ``owner``'s account.
158      */
159     function balanceOf(address owner) external view returns (uint256 balance);
160 
161     /**
162      * @dev Returns the owner of the `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function ownerOf(uint256 tokenId) external view returns (address owner);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Transfers `tokenId` token from `from` to `to`.
192      *
193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Returns the account approved for `tokenId` token.
227      *
228      * Requirements:
229      *
230      * - `tokenId` must exist.
231      */
232     function getApproved(uint256 tokenId) external view returns (address operator);
233 
234     /**
235      * @dev Approve or remove `operator` as an operator for the caller.
236      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
237      *
238      * Requirements:
239      *
240      * - The `operator` cannot be the caller.
241      *
242      * Emits an {ApprovalForAll} event.
243      */
244     function setApprovalForAll(address operator, bool _approved) external;
245 
246     /**
247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
248      *
249      * See {setApprovalForAll}
250      */
251     function isApprovedForAll(address owner, address operator) external view returns (bool);
252 
253     /**
254      * @dev Safely transfers `tokenId` token from `from` to `to`.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
263      *
264      * Emits a {Transfer} event.
265      */
266     function safeTransferFrom(
267         address from,
268         address to,
269         uint256 tokenId,
270         bytes calldata data
271     ) external;
272 }
273 
274 
275 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
276 
277 
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @title ERC721 token receiver interface
283  * @dev Interface for any contract that wants to support safeTransfers
284  * from ERC721 asset contracts.
285  */
286 interface IERC721Receiver {
287     /**
288      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
289      * by `operator` from `from`, this function is called.
290      *
291      * It must return its Solidity selector to confirm the token transfer.
292      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
293      *
294      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
295      */
296     function onERC721Received(
297         address operator,
298         address from,
299         uint256 tokenId,
300         bytes calldata data
301     ) external returns (bytes4);
302 }
303 
304 
305 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
306 
307 
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
313  * @dev See https://eips.ethereum.org/EIPS/eip-721
314  */
315 interface IERC721Metadata is IERC721 {
316     /**
317      * @dev Returns the token collection name.
318      */
319     function name() external view returns (string memory);
320 
321     /**
322      * @dev Returns the token collection symbol.
323      */
324     function symbol() external view returns (string memory);
325 
326     /**
327      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
328      */
329     function tokenURI(uint256 tokenId) external view returns (string memory);
330 }
331 
332 
333 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
334 
335 
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Collection of functions related to the address type
341  */
342 library Address {
343     /**
344      * @dev Returns true if `account` is a contract.
345      *
346      * [IMPORTANT]
347      * ====
348      * It is unsafe to assume that an address for which this function returns
349      * false is an externally-owned account (EOA) and not a contract.
350      *
351      * Among others, `isContract` will return false for the following
352      * types of addresses:
353      *
354      *  - an externally-owned account
355      *  - a contract in construction
356      *  - an address where a contract will be created
357      *  - an address where a contract lived, but was destroyed
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize, which returns 0 for contracts in
362         // construction, since the code is only stored at the end of the
363         // constructor execution.
364 
365         uint256 size;
366         assembly {
367             size := extcodesize(account)
368         }
369         return size > 0;
370     }
371 
372     /**
373      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
374      * `recipient`, forwarding all available gas and reverting on errors.
375      *
376      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
377      * of certain opcodes, possibly making contracts go over the 2300 gas limit
378      * imposed by `transfer`, making them unable to receive funds via
379      * `transfer`. {sendValue} removes this limitation.
380      *
381      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
382      *
383      * IMPORTANT: because control is transferred to `recipient`, care must be
384      * taken to not create reentrancy vulnerabilities. Consider using
385      * {ReentrancyGuard} or the
386      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
387      */
388     function sendValue(address payable recipient, uint256 amount) internal {
389         require(address(this).balance >= amount, "Address: insufficient balance");
390 
391         (bool success, ) = recipient.call{value: amount}("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain `call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, 0, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but also transferring `value` wei to `target`.
434      *
435      * Requirements:
436      *
437      * - the calling contract must have an ETH balance of at least `value`.
438      * - the called Solidity function must be `payable`.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value
446     ) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         require(isContract(target), "Address: call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.call{value: value}(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
476         return functionStaticCall(target, data, "Address: low-level static call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal view returns (bytes memory) {
490         require(isContract(target), "Address: static call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.staticcall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
503         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(
513         address target,
514         bytes memory data,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         require(isContract(target), "Address: delegate call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.delegatecall(data);
520         return verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
525      * revert reason using the provided one.
526      *
527      * _Available since v4.3._
528      */
529     function verifyCallResult(
530         bool success,
531         bytes memory returndata,
532         string memory errorMessage
533     ) internal pure returns (bytes memory) {
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 assembly {
542                     let returndata_size := mload(returndata)
543                     revert(add(32, returndata), returndata_size)
544                 }
545             } else {
546                 revert(errorMessage);
547             }
548         }
549     }
550 }
551 
552 
553 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
554 
555 
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev String operations.
561  */
562 library Strings {
563     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
564 
565     /**
566      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
567      */
568     function toString(uint256 value) internal pure returns (string memory) {
569         // Inspired by OraclizeAPI's implementation - MIT licence
570         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
571 
572         if (value == 0) {
573             return "0";
574         }
575         uint256 temp = value;
576         uint256 digits;
577         while (temp != 0) {
578             digits++;
579             temp /= 10;
580         }
581         bytes memory buffer = new bytes(digits);
582         while (value != 0) {
583             digits -= 1;
584             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
585             value /= 10;
586         }
587         return string(buffer);
588     }
589 
590     /**
591      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
592      */
593     function toHexString(uint256 value) internal pure returns (string memory) {
594         if (value == 0) {
595             return "0x00";
596         }
597         uint256 temp = value;
598         uint256 length = 0;
599         while (temp != 0) {
600             length++;
601             temp >>= 8;
602         }
603         return toHexString(value, length);
604     }
605 
606     /**
607      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
608      */
609     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
610         bytes memory buffer = new bytes(2 * length + 2);
611         buffer[0] = "0";
612         buffer[1] = "x";
613         for (uint256 i = 2 * length + 1; i > 1; --i) {
614             buffer[i] = _HEX_SYMBOLS[value & 0xf];
615             value >>= 4;
616         }
617         require(value == 0, "Strings: hex length insufficient");
618         return string(buffer);
619     }
620 }
621 
622 
623 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
624 
625 
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Implementation of the {IERC165} interface.
631  *
632  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
633  * for the additional interface id that will be supported. For example:
634  *
635  * ```solidity
636  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
637  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
638  * }
639  * ```
640  *
641  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
642  */
643 abstract contract ERC165 is IERC165 {
644     /**
645      * @dev See {IERC165-supportsInterface}.
646      */
647     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
648         return interfaceId == type(IERC165).interfaceId;
649     }
650 }
651 
652 
653 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
654 
655 
656 
657 pragma solidity ^0.8.0;
658 
659 
660 
661 
662 
663 
664 
665 /**
666  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
667  * the Metadata extension, but not including the Enumerable extension, which is available separately as
668  * {ERC721Enumerable}.
669  */
670 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
671     using Address for address;
672     using Strings for uint256;
673 
674     // Token name
675     string private _name;
676 
677     // Token symbol
678     string private _symbol;
679 
680     // Mapping from token ID to owner address
681     mapping(uint256 => address) private _owners;
682 
683     // Mapping owner address to token count
684     mapping(address => uint256) private _balances;
685 
686     // Mapping from token ID to approved address
687     mapping(uint256 => address) private _tokenApprovals;
688 
689     // Mapping from owner to operator approvals
690     mapping(address => mapping(address => bool)) private _operatorApprovals;
691 
692     /**
693      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
694      */
695     constructor(string memory name_, string memory symbol_) {
696         _name = name_;
697         _symbol = symbol_;
698     }
699 
700     /**
701      * @dev See {IERC165-supportsInterface}.
702      */
703     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
704         return
705             interfaceId == type(IERC721).interfaceId ||
706             interfaceId == type(IERC721Metadata).interfaceId ||
707             super.supportsInterface(interfaceId);
708     }
709 
710     /**
711      * @dev See {IERC721-balanceOf}.
712      */
713     function balanceOf(address owner) public view virtual override returns (uint256) {
714         require(owner != address(0), "ERC721: balance query for the zero address");
715         return _balances[owner];
716     }
717 
718     /**
719      * @dev See {IERC721-ownerOf}.
720      */
721     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
722         address owner = _owners[tokenId];
723         require(owner != address(0), "ERC721: owner query for nonexistent token");
724         return owner;
725     }
726 
727     /**
728      * @dev See {IERC721Metadata-name}.
729      */
730     function name() public view virtual override returns (string memory) {
731         return _name;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-symbol}.
736      */
737     function symbol() public view virtual override returns (string memory) {
738         return _symbol;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-tokenURI}.
743      */
744     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
745         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
746 
747         string memory baseURI = _baseURI();
748         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
749     }
750 
751     /**
752      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
753      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
754      * by default, can be overriden in child contracts.
755      */
756     function _baseURI() internal view virtual returns (string memory) {
757         return "";
758     }
759 
760     /**
761      * @dev See {IERC721-approve}.
762      */
763     function approve(address to, uint256 tokenId) public virtual override {
764         address owner = ERC721.ownerOf(tokenId);
765         require(to != owner, "ERC721: approval to current owner");
766 
767         require(
768             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
769             "ERC721: approve caller is not owner nor approved for all"
770         );
771 
772         _approve(to, tokenId);
773     }
774 
775     /**
776      * @dev See {IERC721-getApproved}.
777      */
778     function getApproved(uint256 tokenId) public view virtual override returns (address) {
779         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
780 
781         return _tokenApprovals[tokenId];
782     }
783 
784     /**
785      * @dev See {IERC721-setApprovalForAll}.
786      */
787     function setApprovalForAll(address operator, bool approved) public virtual override {
788         require(operator != _msgSender(), "ERC721: approve to caller");
789 
790         _operatorApprovals[_msgSender()][operator] = approved;
791         emit ApprovalForAll(_msgSender(), operator, approved);
792     }
793 
794     /**
795      * @dev See {IERC721-isApprovedForAll}.
796      */
797     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
798         return _operatorApprovals[owner][operator];
799     }
800 
801     /**
802      * @dev See {IERC721-transferFrom}.
803      */
804     function transferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) public virtual override {
809         //solhint-disable-next-line max-line-length
810         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
811 
812         _transfer(from, to, tokenId);
813     }
814 
815     /**
816      * @dev See {IERC721-safeTransferFrom}.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) public virtual override {
823         safeTransferFrom(from, to, tokenId, "");
824     }
825 
826     /**
827      * @dev See {IERC721-safeTransferFrom}.
828      */
829     function safeTransferFrom(
830         address from,
831         address to,
832         uint256 tokenId,
833         bytes memory _data
834     ) public virtual override {
835         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
836         _safeTransfer(from, to, tokenId, _data);
837     }
838 
839     /**
840      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
841      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
842      *
843      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
844      *
845      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
846      * implement alternative mechanisms to perform token transfer, such as signature-based.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must exist and be owned by `from`.
853      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _safeTransfer(
858         address from,
859         address to,
860         uint256 tokenId,
861         bytes memory _data
862     ) internal virtual {
863         _transfer(from, to, tokenId);
864         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
865     }
866 
867     /**
868      * @dev Returns whether `tokenId` exists.
869      *
870      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
871      *
872      * Tokens start existing when they are minted (`_mint`),
873      * and stop existing when they are burned (`_burn`).
874      */
875     function _exists(uint256 tokenId) internal view virtual returns (bool) {
876         return _owners[tokenId] != address(0);
877     }
878 
879     /**
880      * @dev Returns whether `spender` is allowed to manage `tokenId`.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      */
886     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
887         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
888         address owner = ERC721.ownerOf(tokenId);
889         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
890     }
891 
892     /**
893      * @dev Safely mints `tokenId` and transfers it to `to`.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must not exist.
898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _safeMint(address to, uint256 tokenId) internal virtual {
903         _safeMint(to, tokenId, "");
904     }
905 
906     /**
907      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
908      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
909      */
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
922     /**
923      * @dev Mints `tokenId` and transfers it to `to`.
924      *
925      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
926      *
927      * Requirements:
928      *
929      * - `tokenId` must not exist.
930      * - `to` cannot be the zero address.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _mint(address to, uint256 tokenId) internal virtual {
935         require(to != address(0), "ERC721: mint to the zero address");
936         require(!_exists(tokenId), "ERC721: token already minted");
937 
938         _beforeTokenTransfer(address(0), to, tokenId);
939 
940         _balances[to] += 1;
941         _owners[tokenId] = to;
942 
943         emit Transfer(address(0), to, tokenId);
944     }
945 
946     /**
947      * @dev Destroys `tokenId`.
948      * The approval is cleared when the token is burned.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _burn(uint256 tokenId) internal virtual {
957         address owner = ERC721.ownerOf(tokenId);
958 
959         _beforeTokenTransfer(owner, address(0), tokenId);
960 
961         // Clear approvals
962         _approve(address(0), tokenId);
963 
964         _balances[owner] -= 1;
965         delete _owners[tokenId];
966 
967         emit Transfer(owner, address(0), tokenId);
968     }
969 
970     /**
971      * @dev Transfers `tokenId` from `from` to `to`.
972      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
973      *
974      * Requirements:
975      *
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must be owned by `from`.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _transfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) internal virtual {
986         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
987         require(to != address(0), "ERC721: transfer to the zero address");
988 
989         _beforeTokenTransfer(from, to, tokenId);
990 
991         // Clear approvals from the previous owner
992         _approve(address(0), tokenId);
993 
994         _balances[from] -= 1;
995         _balances[to] += 1;
996         _owners[tokenId] = to;
997 
998         emit Transfer(from, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Approve `to` to operate on `tokenId`
1003      *
1004      * Emits a {Approval} event.
1005      */
1006     function _approve(address to, uint256 tokenId) internal virtual {
1007         _tokenApprovals[tokenId] = to;
1008         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1013      * The call is not executed if the target address is not a contract.
1014      *
1015      * @param from address representing the previous owner of the given token ID
1016      * @param to target address that will receive the tokens
1017      * @param tokenId uint256 ID of the token to be transferred
1018      * @param _data bytes optional data to send along with the call
1019      * @return bool whether the call correctly returned the expected magic value
1020      */
1021     function _checkOnERC721Received(
1022         address from,
1023         address to,
1024         uint256 tokenId,
1025         bytes memory _data
1026     ) private returns (bool) {
1027         if (to.isContract()) {
1028             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1029                 return retval == IERC721Receiver.onERC721Received.selector;
1030             } catch (bytes memory reason) {
1031                 if (reason.length == 0) {
1032                     revert("ERC721: transfer to non ERC721Receiver implementer");
1033                 } else {
1034                     assembly {
1035                         revert(add(32, reason), mload(reason))
1036                     }
1037                 }
1038             }
1039         } else {
1040             return true;
1041         }
1042     }
1043 
1044     /**
1045      * @dev Hook that is called before any token transfer. This includes minting
1046      * and burning.
1047      *
1048      * Calling conditions:
1049      *
1050      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1051      * transferred to `to`.
1052      * - When `from` is zero, `tokenId` will be minted for `to`.
1053      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1054      * - `from` and `to` are never both zero.
1055      *
1056      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1057      */
1058     function _beforeTokenTransfer(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) internal virtual {}
1063 }
1064 
1065 
1066 // File contracts/Axolittles.sol
1067 
1068 
1069 
1070 // SHA256: EFB6E06BEDED5D5D286FD426867ABFCFBC6D3781EE7AB8E46B4A6C8C8EC75D39
1071 
1072 /**
1073    #                                                            
1074   # #   #    #  ####  #      # ##### ##### #      ######  ####  
1075  #   #   #  #  #    # #      #   #     #   #      #      #      
1076 #     #   ##   #    # #      #   #     #   #      #####   ####  
1077 #######   ##   #    # #      #   #     #   #      #           # 
1078 #     #  #  #  #    # #      #   #     #   #      #      #    # 
1079 #     # #    #  ####  ###### #   #     #   ###### ######  ####  
1080  */
1081 
1082 pragma solidity ^0.8.7;
1083 
1084 
1085 contract Axolittles is ERC721, Ownable {
1086 
1087     uint public mintPrice = 0.07 ether; // Mutable by owner
1088     uint public maxItems = 10000;
1089     uint public totalSupply = 0;
1090     uint public maxItemsPerTx = 10; // Mutable by owner
1091     string public _baseTokenURI;
1092     bool public publicMintPaused = false;
1093     uint public startTimestamp = 1630944000; // Monday, September 6, 2021 at 12pm Eastern
1094 
1095     event Mint(address indexed owner, uint indexed tokenId);
1096 
1097     constructor() ERC721("Axolittles", "AXOLITTLE") {}
1098 
1099     receive() external payable {}
1100 
1101     function giveawayMint(address to, uint amount) external onlyOwner {
1102         _mintWithoutValidation(to, amount);
1103     }
1104 
1105     function publicMint() external payable {
1106         require(block.timestamp >= startTimestamp, "publicMint: Not open yet");
1107         require(!publicMintPaused, "publicMint: Paused");
1108         uint remainder = msg.value % mintPrice;
1109         uint amount = msg.value / mintPrice;
1110         require(remainder == 0, "publicMint: Send a divisible amount of eth");
1111         require(amount <= maxItemsPerTx, "publicMint: Surpasses maxItemsPerTx");
1112 
1113         _mintWithoutValidation(msg.sender, amount);
1114     }
1115 
1116     function _mintWithoutValidation(address to, uint amount) internal {
1117         require(totalSupply + amount <= maxItems, "mintWithoutValidation: Sold out");
1118         for (uint i = 0; i < amount; i++) {
1119             _mint(to, totalSupply);
1120             emit Mint(to, totalSupply);
1121             totalSupply += 1;
1122         }
1123     }
1124 
1125     function isOpen() external view returns (bool) {
1126         return block.timestamp >= startTimestamp && !publicMintPaused && totalSupply < maxItems;
1127     }
1128 
1129     // ADMIN FUNCTIONALITY
1130 
1131     function setStartTimestamp(uint _startTimestamp) external onlyOwner {
1132         startTimestamp = _startTimestamp;
1133     }
1134 
1135     function setMintPrice(uint _mintPrice) external onlyOwner {
1136         mintPrice = _mintPrice;
1137     }
1138 
1139     function setPublicMintPaused(bool _publicMintPaused) external onlyOwner {
1140         publicMintPaused = _publicMintPaused;
1141     }
1142 
1143     function setMaxItemsPerTx(uint _maxItemsPerTx) external onlyOwner {
1144         maxItemsPerTx = _maxItemsPerTx;
1145     }
1146 
1147     function setBaseTokenURI(string memory __baseTokenURI) external onlyOwner {
1148         _baseTokenURI = __baseTokenURI;
1149     }
1150 
1151     /**
1152      * @dev Withdraw the contract balance to the dev address or splitter address
1153      */
1154     function withdraw() external onlyOwner {
1155         sendEth(owner(), address(this).balance);
1156     }
1157 
1158     function sendEth(address to, uint amount) internal {
1159         (bool success,) = to.call{value: amount}("");
1160         require(success, "Failed to send ether");
1161     }
1162 
1163     // METADATA FUNCTIONALITY
1164 
1165     /**
1166      * @dev Returns a URI for a given token ID's metadata
1167      */
1168     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1169         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
1170     }
1171 
1172 }