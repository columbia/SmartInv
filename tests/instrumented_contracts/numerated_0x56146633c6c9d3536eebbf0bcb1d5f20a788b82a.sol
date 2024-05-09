1 pragma solidity >=0.8.4;
2 
3 
4 interface TDNS {
5     // Logged when the owner of a node assigns a new owner to a subnode.
6     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
7 
8     // Logged when the owner of a node transfers ownership to a new account.
9     event Transfer(bytes32 indexed node, address owner);
10 
11     // Logged when the resolver for a node changes.
12     event NewResolver(bytes32 indexed node, address resolver);
13 
14     // Logged when the TTL of a node changes
15     event NewTTL(bytes32 indexed node, uint64 ttl);
16 
17     event NewOwnerRegistrar(bytes32 indexed subnode, address owner);
18 
19 
20     // Logged when an operator is added or removed.
21     event ApprovalForAll(
22         address indexed owner,
23         address indexed operator,
24         bool approved
25     );
26 
27     function setRecord(
28         bytes32 node,
29         address owner,
30         address resolver,
31         uint64 ttl
32     ) external;
33 
34     function setSubnodeRecord(
35         bytes32 node,
36         bytes32 label,
37         address owner,
38         address resolver,
39         uint64 ttl
40     ) external;
41 
42     function setSubnodeOwnerRegistrar(
43         bytes32 subnode,
44         address owner
45     ) external returns (bytes32);
46 
47     function setSubnodeOwner(
48         bytes32 node,
49         bytes32 label,
50         address owner
51     ) external returns (bytes32);
52 
53     function setResolver(bytes32 node, address resolver) external;
54 
55     function setOwner(bytes32 node, address owner) external;
56 
57     function setTTL(bytes32 node, uint64 ttl) external;
58 
59     function setApprovalForAll(address operator, bool approved) external;
60 
61     function owner(bytes32 node) external view returns (address);
62 
63     function resolver(bytes32 node) external view returns (address);
64 
65     function ttl(bytes32 node) external view returns (uint64);
66 
67     function recordExists(bytes32 node) external view returns (bool);
68 
69     function isApprovedForAll(address owner, address operator)
70         external
71         view
72         returns (bool);
73 }
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      *
96      * [IMPORTANT]
97      * ====
98      * You shouldn't rely on `isContract` to protect against flash loan attacks!
99      *
100      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
101      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
102      * constructor.
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize/address.code.length, which returns 0
107         // for contracts in construction, since the code is only stored at the end
108         // of the constructor execution.
109 
110         return account.code.length > 0;
111     }
112 
113     /**
114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
115      * `recipient`, forwarding all available gas and reverting on errors.
116      *
117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
119      * imposed by `transfer`, making them unable to receive funds via
120      * `transfer`. {sendValue} removes this limitation.
121      *
122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
123      *
124      * IMPORTANT: because control is transferred to `recipient`, care must be
125      * taken to not create reentrancy vulnerabilities. Consider using
126      * {ReentrancyGuard} or the
127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
128      */
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         (bool success, ) = recipient.call{value: amount}("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     /**
137      * @dev Performs a Solidity function call using a low level `call`. A
138      * plain `call` is an unsafe replacement for a function call: use this
139      * function instead.
140      *
141      * If `target` reverts with a revert reason, it is bubbled up by this
142      * function (like regular Solidity function calls).
143      *
144      * Returns the raw returned data. To convert to the expected return value,
145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
146      *
147      * Requirements:
148      *
149      * - `target` must be a contract.
150      * - calling `target` with `data` must not revert.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155         return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
160      * `errorMessage` as a fallback revert reason when `target` reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         require(address(this).balance >= value, "Address: insufficient balance for call");
204         require(isContract(target), "Address: call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.call{value: value}(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
217         return functionStaticCall(target, data, "Address: low-level static call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal view returns (bytes memory) {
231         require(isContract(target), "Address: static call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.staticcall(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
244         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         require(isContract(target), "Address: delegate call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.delegatecall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
266      * revert reason using the provided one.
267      *
268      * _Available since v4.3._
269      */
270     function verifyCallResult(
271         bool success,
272         bytes memory returndata,
273         string memory errorMessage
274     ) internal pure returns (bytes memory) {
275         if (success) {
276             return returndata;
277         } else {
278             // Look for revert reason and bubble it up if present
279             if (returndata.length > 0) {
280                 // The easiest way to bubble the revert reason is using memory via assembly
281 
282                 assembly {
283                     let returndata_size := mload(returndata)
284                     revert(add(32, returndata), returndata_size)
285                 }
286             } else {
287                 revert(errorMessage);
288             }
289         }
290     }
291 }
292 
293 /**
294  * @dev Provides information about the current execution context, including the
295  * sender of the transaction and its data. While these are generally available
296  * via msg.sender and msg.data, they should not be accessed in such a direct
297  * manner, since when dealing with meta-transactions the account sending and
298  * paying for execution may not be the actual sender (as far as an application
299  * is concerned).
300  *
301  * This contract is only required for intermediate, library-like contracts.
302  */
303 abstract contract Context {
304     function _msgSender() internal view virtual returns (address) {
305         return msg.sender;
306     }
307 
308     function _msgData() internal view virtual returns (bytes calldata) {
309         return msg.data;
310     }
311 }
312 
313 
314 /**
315  * @dev Contract module which provides a basic access control mechanism, where
316  * there is an account (an owner) that can be granted exclusive access to
317  * specific functions.
318  *
319  * By default, the owner account will be the one that deploys the contract. This
320  * can later be changed with {transferOwnership}.
321  *
322  * This module is used through inheritance. It will make available the modifier
323  * `onlyOwner`, which can be applied to your functions to restrict their use to
324  * the owner.
325  */
326 abstract contract Ownable is Context {
327     address private _owner;
328 
329     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
330 
331     /**
332      * @dev Initializes the contract setting the deployer as the initial owner.
333      */
334     constructor() {
335         _transferOwnership(_msgSender());
336     }
337 
338     /**
339      * @dev Returns the address of the current owner.
340      */
341     function owner() public view virtual returns (address) {
342         return _owner;
343     }
344 
345     /**
346      * @dev Throws if called by any account other than the owner.
347      */
348     modifier onlyOwner() {
349         require(owner() == _msgSender(), "Ownable: caller is not the owner");
350         _;
351     }
352 
353     /**
354      * @dev Leaves the contract without owner. It will not be possible to call
355      * `onlyOwner` functions anymore. Can only be called by the current owner.
356      *
357      * NOTE: Renouncing ownership will leave the contract without an owner,
358      * thereby removing any functionality that is only available to the owner.
359      */
360     function renounceOwnership() public virtual onlyOwner {
361         _transferOwnership(address(0));
362     }
363 
364     /**
365      * @dev Transfers ownership of the contract to a new account (`newOwner`).
366      * Can only be called by the current owner.
367      */
368     function transferOwnership(address newOwner) public virtual onlyOwner {
369         require(newOwner != address(0), "Ownable: new owner is the zero address");
370         _transferOwnership(newOwner);
371     }
372 
373     /**
374      * @dev Transfers ownership of the contract to a new account (`newOwner`).
375      * Internal function without access restriction.
376      */
377     function _transferOwnership(address newOwner) internal virtual {
378         address oldOwner = _owner;
379         _owner = newOwner;
380         emit OwnershipTransferred(oldOwner, newOwner);
381     }
382 }
383 
384 
385 /**
386  * @dev Interface of the ERC165 standard, as defined in the
387  * https://eips.ethereum.org/EIPS/eip-165[EIP].
388  *
389  * Implementers can declare support of contract interfaces, which can then be
390  * queried by others ({ERC165Checker}).
391  *
392  * For an implementation, see {ERC165}.
393  */
394 interface IERC165 {
395     /**
396      * @dev Returns true if this contract implements the interface defined by
397      * `interfaceId`. See the corresponding
398      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
399      * to learn more about how these ids are created.
400      *
401      * This function call must use less than 30 000 gas.
402      */
403     function supportsInterface(bytes4 interfaceId) external view returns (bool);
404 }
405 
406 /**
407  * @dev Required interface of an ERC721 compliant contract.
408  */
409 interface IERC721 is IERC165 {
410     /**
411      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
417      */
418     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
419 
420     /**
421      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
422      */
423     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
424 
425     /**
426      * @dev Returns the number of tokens in ``owner``'s account.
427      */
428     function balanceOf(address owner) external view returns (uint256 balance);
429 
430     /**
431      * @dev Returns the owner of the `tokenId` token.
432      *
433      * Requirements:
434      *
435      * - `tokenId` must exist.
436      */
437     function ownerOf(uint256 tokenId) external view returns (address owner);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
441      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
442      *
443      * Requirements:
444      *
445      * - `from` cannot be the zero address.
446      * - `to` cannot be the zero address.
447      * - `tokenId` token must exist and be owned by `from`.
448      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
449      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
450      *
451      * Emits a {Transfer} event.
452      */
453     function safeTransferFrom(
454         address from,
455         address to,
456         uint256 tokenId
457     ) external;
458 
459     /**
460      * @dev Transfers `tokenId` token from `from` to `to`.
461      *
462      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
463      *
464      * Requirements:
465      *
466      * - `from` cannot be the zero address.
467      * - `to` cannot be the zero address.
468      * - `tokenId` token must be owned by `from`.
469      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external;
478 
479     /**
480      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
481      * The approval is cleared when the token is transferred.
482      *
483      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
484      *
485      * Requirements:
486      *
487      * - The caller must own the token or be an approved operator.
488      * - `tokenId` must exist.
489      *
490      * Emits an {Approval} event.
491      */
492     function approve(address to, uint256 tokenId) external;
493 
494     /**
495      * @dev Returns the account approved for `tokenId` token.
496      *
497      * Requirements:
498      *
499      * - `tokenId` must exist.
500      */
501     function getApproved(uint256 tokenId) external view returns (address operator);
502 
503     /**
504      * @dev Approve or remove `operator` as an operator for the caller.
505      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
506      *
507      * Requirements:
508      *
509      * - The `operator` cannot be the caller.
510      *
511      * Emits an {ApprovalForAll} event.
512      */
513     function setApprovalForAll(address operator, bool _approved) external;
514 
515     /**
516      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
517      *
518      * See {setApprovalForAll}
519      */
520     function isApprovedForAll(address owner, address operator) external view returns (bool);
521 
522     /**
523      * @dev Safely transfers `tokenId` token from `from` to `to`.
524      *
525      * Requirements:
526      *
527      * - `from` cannot be the zero address.
528      * - `to` cannot be the zero address.
529      * - `tokenId` token must exist and be owned by `from`.
530      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
531      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
532      *
533      * Emits a {Transfer} event.
534      */
535     function safeTransferFrom(
536         address from,
537         address to,
538         uint256 tokenId,
539         bytes calldata data
540     ) external;
541 }
542 
543 interface IBaseRegistrar is IERC721 {
544 
545     event ControllerAdded(address indexed controller);
546     event ControllerRemoved(address indexed controller);
547     event NameMigrated(
548         uint256 indexed id,
549         address indexed owner,
550         uint256 expires
551     );
552     event NameRegistered(
553         uint256 indexed id,
554         address indexed owner,
555         uint256 expires
556     );
557     event NameRenewed(uint256 indexed id, uint256 expires);
558     // Authorises a controller, who can register and renew domains.
559     function addController(address controller) external;
560 
561     // Revoke controller permission for an address.
562     function removeController(address controller) external;
563 
564     // Set the resolver for the TLD this registrar manages.
565     function setResolver(address resolver) external;
566 
567     // Returns the expiration timestamp of the specified label hash.
568     function nameExpires(uint256 id) external view returns (uint256);
569 
570     // Returns true iff the specified name is available for registration.
571     function available(uint256 id) external view returns (bool);
572 
573     /**
574      * @dev Register a name.
575      */
576     function register(
577         uint256 id,
578         address owner,
579         uint256 duration
580     ) external returns (uint256);
581 
582     function renew(uint256 id, uint256 duration) external returns (uint256);
583 
584     /**
585      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
586      */
587     function reclaim(uint256 id, address owner) external;
588 }
589 
590 
591 /**
592  * @title ERC721 token receiver interface
593  * @dev Interface for any contract that wants to support safeTransfers
594  * from ERC721 asset contracts.
595  */
596 interface IERC721Receiver {
597     /**
598      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
599      * by `operator` from `from`, this function is called.
600      *
601      * It must return its Solidity selector to confirm the token transfer.
602      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
603      *
604      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
605      */
606     function onERC721Received(
607         address operator,
608         address from,
609         uint256 tokenId,
610         bytes calldata data
611     ) external returns (bytes4);
612 }
613 
614 /**
615  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
616  * @dev See https://eips.ethereum.org/EIPS/eip-721
617  */
618 interface IERC721Metadata is IERC721 {
619     /**
620      * @dev Returns the token collection name.
621      */
622     function name() external view returns (string memory);
623 
624     /**
625      * @dev Returns the token collection symbol.
626      */
627     function symbol() external view returns (string memory);
628 
629     /**
630      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
631      */
632     function tokenURI(uint256 tokenId) external view returns (string memory);
633 }
634 
635 /**
636  * @dev String operations.
637  */
638 library Strings {
639     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
640 
641     /**
642      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
643      */
644     function toString(uint256 value) internal pure returns (string memory) {
645         // Inspired by OraclizeAPI's implementation - MIT licence
646         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
647 
648         if (value == 0) {
649             return "0";
650         }
651         uint256 temp = value;
652         uint256 digits;
653         while (temp != 0) {
654             digits++;
655             temp /= 10;
656         }
657         bytes memory buffer = new bytes(digits);
658         while (value != 0) {
659             digits -= 1;
660             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
661             value /= 10;
662         }
663         return string(buffer);
664     }
665 
666     /**
667      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
668      */
669     function toHexString(uint256 value) internal pure returns (string memory) {
670         if (value == 0) {
671             return "0x00";
672         }
673         uint256 temp = value;
674         uint256 length = 0;
675         while (temp != 0) {
676             length++;
677             temp >>= 8;
678         }
679         return toHexString(value, length);
680     }
681 
682     /**
683      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
684      */
685     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
686         bytes memory buffer = new bytes(2 * length + 2);
687         buffer[0] = "0";
688         buffer[1] = "x";
689         for (uint256 i = 2 * length + 1; i > 1; --i) {
690             buffer[i] = _HEX_SYMBOLS[value & 0xf];
691             value >>= 4;
692         }
693         require(value == 0, "Strings: hex length insufficient");
694         return string(buffer);
695     }
696 }
697 
698 /**
699  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
700  * the Metadata extension, but not including the Enumerable extension, which is available separately as
701  * {ERC721Enumerable}.
702  */
703 
704 
705 /**
706  * @dev Implementation of the {IERC165} interface.
707  *
708  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
709  * for the additional interface id that will be supported. For example:
710  *
711  * ```solidity
712  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
713  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
714  * }
715  * ```
716  *
717  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
718  */
719 abstract contract ERC165 is IERC165 {
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724         return interfaceId == type(IERC165).interfaceId;
725     }
726 }
727 
728 
729 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
730     using Address for address;
731     using Strings for uint256;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to owner address
740     mapping(uint256 => address) private _owners;
741 
742     // Mapping owner address to token count
743     mapping(address => uint256) private _balances;
744 
745     // Mapping from token ID to approved address
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     // Mapping from owner to operator approvals
749     mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751     /**
752      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
753      */
754     constructor(string memory name_, string memory symbol_) {
755         _name = name_;
756         _symbol = symbol_;
757     }
758 
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner) public view virtual override returns (uint256) {
773         require(owner != address(0), "ERC721: balance query for the zero address");
774         return _balances[owner];
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
781         address owner = _owners[tokenId];
782         require(owner != address(0), "ERC721: owner query for nonexistent token");
783         return owner;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-name}.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-symbol}.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-tokenURI}.
802      */
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
805 
806         string memory baseURI = _baseURI();
807         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
808     }
809 
810     /**
811      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
812      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
813      * by default, can be overriden in child contracts.
814      */
815     function _baseURI() internal view virtual returns (string memory) {
816         return "";
817     }
818 
819     /**
820      * @dev See {IERC721-approve}.
821      */
822     function approve(address to, uint256 tokenId) public virtual override {
823         address owner = ERC721.ownerOf(tokenId);
824         require(to != owner, "ERC721: approval to current owner");
825 
826         require(
827             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
828             "ERC721: approve caller is not owner nor approved for all"
829         );
830 
831         _approve(to, tokenId);
832     }
833 
834     /**
835      * @dev See {IERC721-getApproved}.
836      */
837     function getApproved(uint256 tokenId) public view virtual override returns (address) {
838         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
839 
840         return _tokenApprovals[tokenId];
841     }
842 
843     /**
844      * @dev See {IERC721-setApprovalForAll}.
845      */
846     function setApprovalForAll(address operator, bool approved) public virtual override {
847         _setApprovalForAll(_msgSender(), operator, approved);
848     }
849 
850     /**
851      * @dev See {IERC721-isApprovedForAll}.
852      */
853     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
854         return _operatorApprovals[owner][operator];
855     }
856 
857     /**
858      * @dev See {IERC721-transferFrom}.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         //solhint-disable-next-line max-line-length
866         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
867 
868         _transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         safeTransferFrom(from, to, tokenId, "");
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) public virtual override {
891         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
892         _safeTransfer(from, to, tokenId, _data);
893     }
894 
895     /**
896      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
897      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
898      *
899      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
900      *
901      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
902      * implement alternative mechanisms to perform token transfer, such as signature-based.
903      *
904      * Requirements:
905      *
906      * - `from` cannot be the zero address.
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must exist and be owned by `from`.
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _safeTransfer(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) internal virtual {
919         _transfer(from, to, tokenId);
920         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      * and stop existing when they are burned (`_burn`).
930      */
931     function _exists(uint256 tokenId) internal view virtual returns (bool) {
932         return _owners[tokenId] != address(0);
933     }
934 
935     /**
936      * @dev Returns whether `spender` is allowed to manage `tokenId`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      */
942     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
943         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
944         address owner = ERC721.ownerOf(tokenId);
945         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
946     }
947 
948     /**
949      * @dev Safely mints `tokenId` and transfers it to `to`.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must not exist.
954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _safeMint(address to, uint256 tokenId) internal virtual {
959         _safeMint(to, tokenId, "");
960     }
961 
962     /**
963      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
964      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
965      */
966     function _safeMint(
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) internal virtual {
971         _mint(to, tokenId);
972         require(
973             _checkOnERC721Received(address(0), to, tokenId, _data),
974             "ERC721: transfer to non ERC721Receiver implementer"
975         );
976     }
977 
978     /**
979      * @dev Mints `tokenId` and transfers it to `to`.
980      *
981      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
982      *
983      * Requirements:
984      *
985      * - `tokenId` must not exist.
986      * - `to` cannot be the zero address.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _mint(address to, uint256 tokenId) internal virtual {
991         require(to != address(0), "ERC721: mint to the zero address");
992         require(!_exists(tokenId), "ERC721: token already minted");
993 
994         _beforeTokenTransfer(address(0), to, tokenId);
995 
996         _balances[to] += 1;
997         _owners[tokenId] = to;
998 
999         emit Transfer(address(0), to, tokenId);
1000 
1001         _afterTokenTransfer(address(0), to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Destroys `tokenId`.
1006      * The approval is cleared when the token is burned.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _burn(uint256 tokenId) internal virtual {
1015         address owner = ERC721.ownerOf(tokenId);
1016 
1017         _beforeTokenTransfer(owner, address(0), tokenId);
1018 
1019         // Clear approvals
1020         _approve(address(0), tokenId);
1021 
1022         _balances[owner] -= 1;
1023         delete _owners[tokenId];
1024 
1025         emit Transfer(owner, address(0), tokenId);
1026 
1027         _afterTokenTransfer(owner, address(0), tokenId);
1028     }
1029 
1030     /**
1031      * @dev Transfers `tokenId` from `from` to `to`.
1032      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must be owned by `from`.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _transfer(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) internal virtual {
1046         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1047         require(to != address(0), "ERC721: transfer to the zero address");
1048 
1049         _beforeTokenTransfer(from, to, tokenId);
1050 
1051         // Clear approvals from the previous owner
1052         _approve(address(0), tokenId);
1053 
1054         _balances[from] -= 1;
1055         _balances[to] += 1;
1056         _owners[tokenId] = to;
1057 
1058         emit Transfer(from, to, tokenId);
1059 
1060         _afterTokenTransfer(from, to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev Approve `to` to operate on `tokenId`
1065      *
1066      * Emits a {Approval} event.
1067      */
1068     function _approve(address to, uint256 tokenId) internal virtual {
1069         _tokenApprovals[tokenId] = to;
1070         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Approve `operator` to operate on all of `owner` tokens
1075      *
1076      * Emits a {ApprovalForAll} event.
1077      */
1078     function _setApprovalForAll(
1079         address owner,
1080         address operator,
1081         bool approved
1082     ) internal virtual {
1083         require(owner != operator, "ERC721: approve to caller");
1084         _operatorApprovals[owner][operator] = approved;
1085         emit ApprovalForAll(owner, operator, approved);
1086     }
1087 
1088     /**
1089      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1090      * The call is not executed if the target address is not a contract.
1091      *
1092      * @param from address representing the previous owner of the given token ID
1093      * @param to target address that will receive the tokens
1094      * @param tokenId uint256 ID of the token to be transferred
1095      * @param _data bytes optional data to send along with the call
1096      * @return bool whether the call correctly returned the expected magic value
1097      */
1098     function _checkOnERC721Received(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) private returns (bool) {
1104         if (to.isContract()) {
1105             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1106                 return retval == IERC721Receiver.onERC721Received.selector;
1107             } catch (bytes memory reason) {
1108                 if (reason.length == 0) {
1109                     revert("ERC721: transfer to non ERC721Receiver implementer");
1110                 } else {
1111                     assembly {
1112                         revert(add(32, reason), mload(reason))
1113                     }
1114                 }
1115             }
1116         } else {
1117             return true;
1118         }
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before any token transfer. This includes minting
1123      * and burning.
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` will be minted for `to`.
1130      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1131      * - `from` and `to` are never both zero.
1132      *
1133      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1134      */
1135     function _beforeTokenTransfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) internal virtual {}
1140 
1141     /**
1142      * @dev Hook that is called after any transfer of tokens. This includes
1143      * minting and burning.
1144      *
1145      * Calling conditions:
1146      *
1147      * - when `from` and `to` are both non-zero.
1148      * - `from` and `to` are never both zero.
1149      *
1150      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1151      */
1152     function _afterTokenTransfer(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) internal virtual {}
1157 }
1158 
1159 contract BaseRegistrarImplementation is ERC721, IBaseRegistrar, Ownable  {
1160     // A map of expiry times
1161     mapping(uint256=>uint) expiries;
1162     // The ENS registry
1163     TDNS public tdns;
1164     // The namehash of the TLD this registrar owns (eg, .eth)
1165     bytes32 public baseNode;
1166     // A map of addresses that are authorised to register and renew names.
1167     mapping(address => bool) public controllers;
1168     uint256 public constant GRACE_PERIOD = 90 days;
1169     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
1170     bytes4 constant private ERC721_ID = bytes4(
1171         keccak256("balanceOf(address)") ^
1172         keccak256("ownerOf(uint256)") ^
1173         keccak256("approve(address,uint256)") ^
1174         keccak256("getApproved(uint256)") ^
1175         keccak256("setApprovalForAll(address,bool)") ^
1176         keccak256("isApprovedForAll(address,address)") ^
1177         keccak256("transferFrom(address,address,uint256)") ^
1178         keccak256("safeTransferFrom(address,address,uint256)") ^
1179         keccak256("safeTransferFrom(address,address,uint256,bytes)")
1180     );
1181     bytes4 constant private RECLAIM_ID = bytes4(keccak256("reclaim(uint256,address)"));
1182 
1183     /**
1184      * v2.1.3 version of _isApprovedOrOwner which calls ownerOf(tokenId) and takes grace period into consideration instead of ERC721.ownerOf(tokenId);
1185      * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.1.3/contracts/token/ERC721/ERC721.sol#L187
1186      * @dev Returns whether the given spender can transfer a given token ID
1187      * @param spender address of the spender to query
1188      * @param tokenId uint256 ID of the token to be transferred
1189      * @return bool whether the msg.sender is approved for the given token ID,
1190      *    is an operator of the owner, or is the owner of the token
1191      */
1192     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
1193         address owner = ownerOf(tokenId);
1194         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1195     }
1196 
1197     constructor(TDNS _tdns, bytes32 _baseNode) ERC721("Tomi Domain Name Service","TDNS") {
1198         tdns = _tdns;
1199         baseNode = _baseNode;
1200     }
1201 
1202     modifier live {
1203         require(tdns.owner(baseNode) == address(this));
1204         _;
1205     }
1206 
1207     modifier onlyController {
1208         require(controllers[msg.sender]);
1209         _;
1210     }
1211 
1212     /**
1213      * @dev Gets the owner of the specified token ID. Names become unowned
1214      *      when their registration expires.
1215      * @param tokenId uint256 ID of the token to query the owner of
1216      * @return address currently marked as the owner of the given token ID
1217      */
1218     function ownerOf(uint256 tokenId) public view override(IERC721, ERC721) returns (address) {
1219         require(expiries[tokenId] > block.timestamp);
1220         return super.ownerOf(tokenId);
1221     }
1222 
1223     // Authorises a controller, who can register and renew domains.
1224     function addController(address controller) external override onlyOwner {
1225         controllers[controller] = true;
1226         emit ControllerAdded(controller);
1227     }
1228 
1229     // Revoke controller permission for an address.
1230     function removeController(address controller) external override onlyOwner {
1231         controllers[controller] = false;
1232         emit ControllerRemoved(controller);
1233     }
1234 
1235     // Set the resolver for the TLD this registrar manages.
1236     function setResolver(address resolver) external override onlyOwner {
1237         tdns.setResolver(baseNode, resolver);
1238     }
1239 
1240     // Returns the expiration timestamp of the specified id.
1241     function nameExpires(uint256 id) external view override returns(uint) {
1242         return expiries[id];
1243     }
1244 
1245     // Returns true iff the specified name is available for registration.
1246     function available(uint256 id) public view override returns(bool) {
1247         // Not available if it's registered here or in its grace period.
1248         return expiries[id] + GRACE_PERIOD < block.timestamp;
1249     }
1250 
1251     /**
1252      * @dev Register a name.
1253      * @param id The token ID (keccak256 of the label).
1254      * @param owner The address that should own the registration.
1255      * @param duration Duration in seconds for the registration.
1256      */
1257     function register(uint256 id, address owner, uint duration) external override returns(uint) {
1258       return _register(id, owner, duration, true);
1259     }
1260 
1261     /**
1262      * @dev Register a name, without modifying the registry.
1263      * @param id The token ID (keccak256 of the label).
1264      * @param owner The address that should own the registration.
1265      * @param duration Duration in seconds for the registration.
1266      */
1267     function registerOnly(uint256 id, address owner, uint duration) external returns(uint) {
1268       return _register(id, owner, duration, false);
1269     }
1270 
1271     function _register(uint256 id, address owner, uint duration, bool updateRegistry) internal live onlyController returns(uint) {
1272         require(available(id));
1273         require(block.timestamp + duration + GRACE_PERIOD > block.timestamp + GRACE_PERIOD); // Prevent future overflow
1274 
1275         expiries[id] = block.timestamp + duration;
1276         if(_exists(id)) {
1277             // Name was previously owned, and expired
1278             _burn(id);
1279         }
1280         _mint(owner, id);
1281         if(updateRegistry) {
1282             tdns.setSubnodeOwnerRegistrar(bytes32(id), owner);
1283         }
1284 
1285         emit NameRegistered(id, owner, block.timestamp + duration);
1286 
1287         return block.timestamp + duration;
1288     }
1289 
1290     function renew(uint256 id, uint duration) external override live onlyController returns(uint) {
1291         require(expiries[id] + GRACE_PERIOD >= block.timestamp); // Name must be registered here or in grace period
1292         require(expiries[id] + duration + GRACE_PERIOD > duration + GRACE_PERIOD); // Prevent future overflow
1293 
1294         expiries[id] += duration;
1295         emit NameRenewed(id, expiries[id]);
1296         return expiries[id];
1297     }
1298 
1299     
1300     /**
1301      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
1302      */
1303     function reclaim(uint256 id, address owner) public override live {
1304         require(_isApprovedOrOwner(msg.sender, id));
1305         tdns.setSubnodeOwnerRegistrar(bytes32(id), owner);
1306     }
1307 
1308      /**
1309      * @dev See {IERC721-transferFrom}.
1310      */
1311     function transferFrom(
1312         address from,
1313         address to,
1314         uint256 tokenId
1315     ) public override(ERC721,IERC721) {
1316         //solhint-disable-next-line max-line-length
1317         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1318         reclaim(tokenId, to);
1319         _transfer(from, to, tokenId);
1320     }
1321 
1322 
1323     function supportsInterface(bytes4 interfaceID) public override(ERC721, IERC165) view returns (bool) {
1324         return interfaceID == INTERFACE_META_ID ||
1325                interfaceID == ERC721_ID ||
1326                interfaceID == RECLAIM_ID;
1327     }
1328 }
1329 
1330 library StringUtils {
1331     /**
1332      * @dev Returns the length of a given string
1333      *
1334      * @param s The string to measure the length of
1335      * @return The length of the input string
1336      */
1337     function strlen(string memory s) internal pure returns (uint) {
1338         uint len;
1339         uint i = 0;
1340         uint bytelength = bytes(s).length;
1341         for(len = 0; i < bytelength; len++) {
1342             bytes1 b = bytes(s)[i];
1343             if(b < 0x80) {
1344                 i += 1;
1345             } else if (b < 0xE0) {
1346                 i += 2;
1347             } else if (b < 0xF0) {
1348                 i += 3;
1349             } else if (b < 0xF8) {
1350                 i += 4;
1351             } else if (b < 0xFC) {
1352                 i += 5;
1353             } else {
1354                 i += 6;
1355             }
1356         }
1357         return len;
1358     }
1359 }
1360 
1361 interface IABIResolver {
1362     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
1363     /**
1364      * Returns the ABI associated with an ENS node.
1365      * Defined in EIP205.
1366      * @param node The ENS node to query
1367      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
1368      * @return contentType The content type of the return value
1369      * @return data The ABI data
1370      */
1371     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory);
1372 }
1373 
1374 abstract contract ResolverBase is ERC165 {
1375     function isAuthorised(bytes32 node) internal virtual view returns(bool);
1376 
1377     modifier authorised(bytes32 node) {
1378         require(isAuthorised(node));
1379         _;
1380     }
1381 }
1382 
1383 
1384 /**
1385  * Interface for the new (multicoin) addr function.
1386  */
1387 interface IAddressResolver {
1388     event AddressChanged(bytes32 indexed node, uint coinType, bytes newAddress);
1389 
1390     function addr(bytes32 node, uint coinType) external view returns(bytes memory);
1391 }
1392 
1393 
1394 /**
1395  * Interface for the legacy (ETH-only) addr function.
1396  */
1397 interface IAddrResolver {
1398     event AddrChanged(bytes32 indexed node, address a);
1399 
1400     /**
1401      * Returns the address associated with an ENS node.
1402      * @param node The ENS node to query.
1403      * @return The associated address.
1404      */
1405     function addr(bytes32 node) external view returns (address payable);
1406 }
1407 
1408 
1409 
1410 interface IContentHashResolver {
1411     event ContenthashChanged(bytes32 indexed node, bytes hash);
1412 
1413     /**
1414      * Returns the contenthash associated with an ENS node.
1415      * @param node The ENS node to query.
1416      * @return The associated contenthash.
1417      */
1418     function contenthash(bytes32 node) external view returns (bytes memory);
1419 }
1420 
1421 interface IDNSRecordResolver {
1422     // DNSRecordChanged is emitted whenever a given node/name/resource's RRSET is updated.
1423     event DNSRecordChanged(bytes32 indexed node, bytes name, uint16 resource, bytes record);
1424     // DNSRecordDeleted is emitted whenever a given node/name/resource's RRSET is deleted.
1425     event DNSRecordDeleted(bytes32 indexed node, bytes name, uint16 resource);
1426     // DNSZoneCleared is emitted whenever a given node's zone information is cleared.
1427     event DNSZoneCleared(bytes32 indexed node);
1428 
1429     /**
1430      * Obtain a DNS record.
1431      * @param node the namehash of the node for which to fetch the record
1432      * @param name the keccak-256 hash of the fully-qualified name for which to fetch the record
1433      * @param resource the ID of the resource as per https://en.wikipedia.org/wiki/List_of_DNS_record_types
1434      * @return the DNS record in wire format if present, otherwise empty
1435      */
1436     function dnsRecord(bytes32 node, bytes32 name, uint16 resource) external view returns (bytes memory);
1437 }
1438 
1439 interface IDNSZoneResolver {
1440     // DNSZonehashChanged is emitted whenever a given node's zone hash is updated.
1441     event DNSZonehashChanged(bytes32 indexed node, bytes lastzonehash, bytes zonehash);
1442 
1443     /**
1444      * zonehash obtains the hash for the zone.
1445      * @param node The ENS node to query.
1446      * @return The associated contenthash.
1447      */
1448     function zonehash(bytes32 node) external view returns (bytes memory);
1449 }
1450 
1451 interface IInterfaceResolver {
1452     event InterfaceChanged(bytes32 indexed node, bytes4 indexed interfaceID, address implementer);
1453 
1454     /**
1455      * Returns the address of a contract that implements the specified interface for this name.
1456      * If an implementer has not been set for this interfaceID and name, the resolver will query
1457      * the contract at `addr()`. If `addr()` is set, a contract exists at that address, and that
1458      * contract implements EIP165 and returns `true` for the specified interfaceID, its address
1459      * will be returned.
1460      * @param node The ENS node to query.
1461      * @param interfaceID The EIP 165 interface ID to check for.
1462      * @return The address that implements this interface, or 0 if the interface is unsupported.
1463      */
1464     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address);
1465 }
1466 
1467 
1468 interface INameResolver {
1469     event NameChanged(bytes32 indexed node, string name);
1470 
1471     /**
1472      * Returns the name associated with an ENS node, for reverse records.
1473      * Defined in EIP181.
1474      * @param node The ENS node to query.
1475      * @return The associated name.
1476      */
1477     function name(bytes32 node) external view returns (string memory);
1478 }
1479 
1480 interface IPubkeyResolver {
1481     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
1482 
1483     /**
1484      * Returns the SECP256k1 public key associated with an ENS node.
1485      * Defined in EIP 619.
1486      * @param node The ENS node to query
1487      * @return x The X coordinate of the curve point for the public key.
1488      * @return y The Y coordinate of the curve point for the public key.
1489      */
1490     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y);
1491 }
1492 
1493 interface ITextResolver {
1494     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
1495 
1496     /**
1497      * Returns the text data associated with an ENS node and key.
1498      * @param node The ENS node to query.
1499      * @param key The text data key to query.
1500      * @return The associated text data.
1501      */
1502     function text(bytes32 node, string calldata key) external view returns (string memory);
1503 }
1504 
1505 interface IExtendedResolver {
1506     function resolve(bytes memory name, bytes memory data)
1507         external
1508         view
1509         returns (bytes memory, address);
1510 }
1511 
1512 
1513 /**
1514  * A generic resolver interface which includes all the functions including the ones deprecated
1515  */
1516 interface Resolver is
1517     IERC165,
1518     IABIResolver,
1519     IAddressResolver,
1520     IAddrResolver,
1521     IContentHashResolver,
1522     IDNSRecordResolver,
1523     IDNSZoneResolver,
1524     IInterfaceResolver,
1525     INameResolver,
1526     IPubkeyResolver,
1527     ITextResolver,
1528     IExtendedResolver
1529 {
1530     /* Deprecated events */
1531     event ContentChanged(bytes32 indexed node, bytes32 hash);
1532 
1533     function setABI(
1534         bytes32 node,
1535         uint256 contentType,
1536         bytes calldata data
1537     ) external;
1538 
1539     function setAddr(bytes32 node, address addr) external;
1540 
1541     function setAddr(
1542         bytes32 node,
1543         uint256 coinType,
1544         bytes calldata a
1545     ) external;
1546 
1547     function setContenthash(bytes32 node, bytes calldata hash) external;
1548 
1549     function setDnsrr(bytes32 node, bytes calldata data) external;
1550 
1551     function setName(bytes32 node, string calldata _name) external;
1552 
1553     function setPubkey(
1554         bytes32 node,
1555         bytes32 x,
1556         bytes32 y
1557     ) external;
1558 
1559     function setText(
1560         bytes32 node,
1561         string calldata key,
1562         string calldata value
1563     ) external;
1564 
1565     function setInterface(
1566         bytes32 node,
1567         bytes4 interfaceID,
1568         address implementer
1569     ) external;
1570 
1571     function multicall(bytes[] calldata data)
1572         external
1573         returns (bytes[] memory results);
1574 
1575     /* Deprecated functions */
1576     function content(bytes32 node) external view returns (bytes32);
1577 
1578     function multihash(bytes32 node) external view returns (bytes memory);
1579 
1580     function setContent(bytes32 node, bytes32 hash) external;
1581 
1582     function setMultihash(bytes32 node, bytes calldata hash) external;
1583 }
1584 
1585 
1586 interface IReverseRegistrar {
1587     function setDefaultResolver(address resolver) external;
1588 
1589     function claim(address owner) external returns (bytes32);
1590 
1591     function claimForAddr(
1592         address addr,
1593         address owner,
1594         address resolver
1595     ) external returns (bytes32);
1596 
1597     function claimWithResolver(address owner, address resolver)
1598         external
1599         returns (bytes32);
1600 
1601     function setName(string memory name) external returns (bytes32);
1602 
1603     function setNameForAddr(
1604         address addr,
1605         address owner,
1606         address resolver,
1607         string memory name
1608     ) external returns (bytes32);
1609 
1610     function node(address addr) external pure returns (bytes32);
1611 }
1612 
1613 contract Controllable is Ownable {
1614     mapping(address => bool) public controllers;
1615 
1616     event ControllerChanged(address indexed controller, bool enabled);
1617 
1618     modifier onlyController {
1619         require(
1620             controllers[msg.sender],
1621             "Controllable: Caller is not a controller"
1622         );
1623         _;
1624     }
1625 
1626     function setController(address controller, bool enabled) public onlyOwner {
1627         controllers[controller] = enabled;
1628         emit ControllerChanged(controller, enabled);
1629     }
1630 }
1631 
1632 
1633 abstract contract NameResolver {
1634     function setName(bytes32 node, string memory name) public virtual;
1635 }
1636 
1637 bytes32 constant lookup = 0x3031323334353637383961626364656600000000000000000000000000000000;
1638 
1639 bytes32 constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
1640 
1641 // namehash('addr.reverse')
1642 
1643 contract ReverseRegistrar is Ownable, Controllable, IReverseRegistrar {
1644     TDNS public immutable tdns;
1645     NameResolver public defaultResolver;
1646 
1647     event ReverseClaimed(address indexed addr, bytes32 indexed node);
1648 
1649     /**
1650      * @dev Constructor
1651      * @param tdnsAddr The address of the ENS registry.
1652      */
1653     constructor(TDNS tdnsAddr) {
1654         tdns = tdnsAddr;
1655 
1656         // Assign ownership of the reverse record to our deployer
1657         ReverseRegistrar oldRegistrar = ReverseRegistrar(
1658             tdnsAddr.owner(ADDR_REVERSE_NODE)
1659         );
1660         if (address(oldRegistrar) != address(0x0)) {
1661             oldRegistrar.claim(msg.sender);
1662         }
1663     }
1664 
1665     modifier authorised(address addr) {
1666         require(
1667             addr == msg.sender ||
1668                 controllers[msg.sender] ||
1669                 tdns.isApprovedForAll(addr, msg.sender) ||
1670                 ownsContract(addr),
1671             "ReverseRegistrar: Caller is not a controller or authorised by address or the address itself"
1672         );
1673         _;
1674     }
1675 
1676     function setDefaultResolver(address resolver) public override onlyOwner {
1677         require(
1678             address(resolver) != address(0),
1679             "ReverseRegistrar: Resolver address must not be 0"
1680         );
1681         defaultResolver = NameResolver(resolver);
1682     }
1683 
1684     /**
1685      * @dev Transfers ownership of the reverse ENS record associated with the
1686      *      calling account.
1687      * @param owner The address to set as the owner of the reverse record in ENS.
1688      * @return The ENS node hash of the reverse record.
1689      */
1690     function claim(address owner) public override returns (bytes32) {
1691         return claimForAddr(msg.sender, owner, address(defaultResolver));
1692     }
1693 
1694     /**
1695      * @dev Transfers ownership of the reverse ENS record associated with the
1696      *      calling account.
1697      * @param addr The reverse record to set
1698      * @param owner The address to set as the owner of the reverse record in ENS.
1699      * @return The ENS node hash of the reverse record.
1700      */
1701     function claimForAddr(
1702         address addr,
1703         address owner,
1704         address resolver
1705     ) public override authorised(addr) returns (bytes32) {
1706         bytes32 labelHash = sha3HexAddress(addr);
1707         bytes32 reverseNode = keccak256(
1708             abi.encodePacked(ADDR_REVERSE_NODE, labelHash)
1709         );
1710         emit ReverseClaimed(addr, reverseNode);
1711         tdns.setSubnodeRecord(ADDR_REVERSE_NODE, labelHash, owner, resolver, 0);
1712         return reverseNode;
1713     }
1714 
1715     /**
1716      * @dev Transfers ownership of the reverse ENS record associated with the
1717      *      calling account.
1718      * @param owner The address to set as the owner of the reverse record in ENS.
1719      * @param resolver The address of the resolver to set; 0 to leave unchanged.
1720      * @return The ENS node hash of the reverse record.
1721      */
1722     function claimWithResolver(address owner, address resolver)
1723         public
1724         override
1725         returns (bytes32)
1726     {
1727         return claimForAddr(msg.sender, owner, resolver);
1728     }
1729 
1730     /**
1731      * @dev Sets the `name()` record for the reverse ENS record associated with
1732      * the calling account. First updates the resolver to the default reverse
1733      * resolver if necessary.
1734      * @param name The name to set for this address.
1735      * @return The ENS node hash of the reverse record.
1736      */
1737     function setName(string memory name) public override returns (bytes32) {
1738         return
1739             setNameForAddr(
1740                 msg.sender,
1741                 msg.sender,
1742                 address(defaultResolver),
1743                 name
1744             );
1745     }
1746 
1747     /**
1748      * @dev Sets the `name()` record for the reverse ENS record associated with
1749      * the account provided. First updates the resolver to the default reverse
1750      * resolver if necessary.
1751      * Only callable by controllers and authorised users
1752      * @param addr The reverse record to set
1753      * @param owner The owner of the reverse node
1754      * @param name The name to set for this address.
1755      * @return The ENS node hash of the reverse record.
1756      */
1757     function setNameForAddr(
1758         address addr,
1759         address owner,
1760         address resolver,
1761         string memory name
1762     ) public override returns (bytes32) {
1763         bytes32 node = claimForAddr(addr, owner, resolver);
1764         NameResolver(resolver).setName(node, name);
1765         return node;
1766     }
1767 
1768     /**
1769      * @dev Returns the node hash for a given account's reverse records.
1770      * @param addr The address to hash
1771      * @return The ENS node hash.
1772      */
1773     function node(address addr) public pure override returns (bytes32) {
1774         return
1775             keccak256(
1776                 abi.encodePacked(ADDR_REVERSE_NODE, sha3HexAddress(addr))
1777             );
1778     }
1779 
1780     /**
1781      * @dev An optimised function to compute the sha3 of the lower-case
1782      *      hexadecimal representation of an Ethereum address.
1783      * @param addr The address to hash
1784      * @return ret The SHA3 hash of the lower-case hexadecimal encoding of the
1785      *         input address.
1786      */
1787     function sha3HexAddress(address addr) private pure returns (bytes32 ret) {
1788         assembly {
1789             for {
1790                 let i := 40
1791             } gt(i, 0) {
1792 
1793             } {
1794                 i := sub(i, 1)
1795                 mstore8(i, byte(and(addr, 0xf), lookup))
1796                 addr := div(addr, 0x10)
1797                 i := sub(i, 1)
1798                 mstore8(i, byte(and(addr, 0xf), lookup))
1799                 addr := div(addr, 0x10)
1800             }
1801 
1802             ret := keccak256(0, 40)
1803         }
1804     }
1805 
1806     function ownsContract(address addr) internal view returns (bool) {
1807         try Ownable(addr).owner() returns (address owner) {
1808             return owner == msg.sender;
1809         } catch {
1810             return false;
1811         }
1812     }
1813 }
1814 
1815 
1816 interface IETHRegistrarController {
1817 
1818     struct domain{
1819         string name;
1820         string tld;
1821     }
1822 
1823     function rentPrice(string memory, uint256, bytes32)
1824         external
1825         returns (IPriceOracle.Price memory);
1826 
1827     function NODES(string memory)
1828         external
1829         returns (bytes32);
1830 
1831     function available(string memory, string memory) external returns (bool);
1832 
1833     function makeCommitment(
1834         domain calldata,
1835         address,
1836         uint256,
1837         bytes32,
1838         address,
1839         bytes[] calldata,
1840         bool,
1841         uint32
1842     ) external returns (bytes32);
1843 
1844     function commit(bytes32) external;
1845 
1846     function register(
1847         domain calldata,
1848         address,
1849         uint256,
1850         bytes32,
1851         address,
1852         bytes[] calldata,
1853         bool,
1854         uint32,
1855         uint64
1856     ) external payable;
1857 
1858     function renew(string calldata, uint256,string calldata tld) external payable;
1859 }
1860 
1861 
1862 
1863 /**
1864  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1865  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1866  *
1867  * _Available since v3.1._
1868  */
1869 interface IERC1155 is IERC165 {
1870     /**
1871      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1872      */
1873     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1874 
1875     /**
1876      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1877      * transfers.
1878      */
1879     event TransferBatch(
1880         address indexed operator,
1881         address indexed from,
1882         address indexed to,
1883         uint256[] ids,
1884         uint256[] values
1885     );
1886 
1887     /**
1888      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1889      * `approved`.
1890      */
1891     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1892 
1893     /**
1894      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1895      *
1896      * If an {URI} event was emitted for `id`, the standard
1897      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1898      * returned by {IERC1155MetadataURI-uri}.
1899      */
1900     event URI(string value, uint256 indexed id);
1901 
1902     /**
1903      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1904      *
1905      * Requirements:
1906      *
1907      * - `account` cannot be the zero address.
1908      */
1909     function balanceOf(address account, uint256 id) external view returns (uint256);
1910 
1911     /**
1912      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1913      *
1914      * Requirements:
1915      *
1916      * - `accounts` and `ids` must have the same length.
1917      */
1918     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1919         external
1920         view
1921         returns (uint256[] memory);
1922 
1923     /**
1924      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1925      *
1926      * Emits an {ApprovalForAll} event.
1927      *
1928      * Requirements:
1929      *
1930      * - `operator` cannot be the caller.
1931      */
1932     function setApprovalForAll(address operator, bool approved) external;
1933 
1934     /**
1935      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1936      *
1937      * See {setApprovalForAll}.
1938      */
1939     function isApprovedForAll(address account, address operator) external view returns (bool);
1940 
1941     /**
1942      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1943      *
1944      * Emits a {TransferSingle} event.
1945      *
1946      * Requirements:
1947      *
1948      * - `to` cannot be the zero address.
1949      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1950      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1951      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1952      * acceptance magic value.
1953      */
1954     function safeTransferFrom(
1955         address from,
1956         address to,
1957         uint256 id,
1958         uint256 amount,
1959         bytes calldata data
1960     ) external;
1961 
1962     /**
1963      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1964      *
1965      * Emits a {TransferBatch} event.
1966      *
1967      * Requirements:
1968      *
1969      * - `ids` and `amounts` must have the same length.
1970      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1971      * acceptance magic value.
1972      */
1973     function safeBatchTransferFrom(
1974         address from,
1975         address to,
1976         uint256[] calldata ids,
1977         uint256[] calldata amounts,
1978         bytes calldata data
1979     ) external;
1980 }
1981 
1982 interface IMetadataService {
1983     function uri(uint256) external view returns (string memory);
1984 }
1985 
1986 
1987 interface IPriceOracle {
1988     struct Price {
1989         uint256 base;
1990         uint256 premium;
1991     }
1992 
1993     /**
1994      * @dev Returns the price to register or renew a name.
1995      * @param name The name being registered or renewed.
1996      * @param expires When the name presently expires (0 if this is a new registration).
1997      * @param duration How long the name is being registered or extended for, in seconds.
1998      * @return base premium tuple of base price + premium price
1999      */
2000     function price(
2001         string calldata name,
2002         uint256 expires,
2003         uint256 duration,
2004         bytes32 namehash
2005     ) external view returns (Price calldata);
2006     
2007 
2008     function setPrice(bytes32 namehash, uint256 price_) external;
2009 }
2010 
2011 
2012 
2013 uint32 constant CANNOT_UNWRAP = 1;
2014 uint32 constant CANNOT_BURN_FUSES = 2;
2015 uint32 constant CANNOT_TRANSFER = 4;
2016 uint32 constant CANNOT_SET_RESOLVER = 8;
2017 uint32 constant CANNOT_SET_TTL = 16;
2018 uint32 constant CANNOT_CREATE_SUBDOMAIN = 32;
2019 uint32 constant PARENT_CANNOT_CONTROL = 64;
2020 uint32 constant CAN_DO_EVERYTHING = 0;
2021 
2022 interface INameWrapper is IERC1155 {
2023     event NameWrapped(
2024         bytes32 indexed node,
2025         bytes name,
2026         address owner,
2027         uint32 fuses,
2028         uint64 expiry
2029     );
2030 
2031     event NameUnwrapped(bytes32 indexed node, address owner);
2032 
2033     event FusesSet(bytes32 indexed node, uint32 fuses, uint64 expiry);
2034 
2035     function tdns() external view returns (TDNS);
2036 
2037     function registrar() external view returns (IBaseRegistrar);
2038 
2039     function metadataService() external view returns (IMetadataService);
2040 
2041     function names(bytes32) external view returns (bytes memory);
2042 
2043     function wrap(
2044         bytes calldata name,
2045         address wrappedOwner,
2046         address resolver
2047     ) external;
2048 
2049     function wrapETH2LD(
2050         string calldata label,
2051         address wrappedOwner,
2052         uint32 fuses,
2053         uint64 _expiry,
2054         address resolver,
2055         string calldata tld
2056     ) external returns (uint64 expiry);
2057 
2058     function registerAndWrapETH2LD(
2059         IETHRegistrarController.domain calldata name,
2060         address wrappedOwner,
2061         uint256 duration,
2062         address resolver,
2063         uint256 amount
2064     ) external returns (uint256 registrarExpiry);
2065 
2066     function renew(
2067         uint256 labelHash,
2068         uint256 duration,
2069         uint64 expiry
2070     ) external returns (uint256 expires);
2071 
2072     function unwrap(
2073         bytes32 node,
2074         bytes32 label,
2075         address owner
2076     ) external;
2077 
2078     function unwrapETH2LD(
2079         bytes32 label,
2080         address newRegistrant,
2081         address newController,
2082         string calldata tld
2083     ) external;
2084 
2085     function setFuses(bytes32 node, uint32 fuses)
2086         external
2087         returns (uint32 newFuses);
2088 
2089     function setChildFuses(
2090         bytes32 parentNode,
2091         bytes32 labelhash,
2092         uint32 fuses,
2093         uint64 expiry
2094     ) external;
2095 
2096     function setSubnodeRecord(
2097         bytes32 node,
2098         string calldata label,
2099         address owner,
2100         address resolver,
2101         uint64 ttl,
2102         uint32 fuses,
2103         uint64 expiry
2104     ) external;
2105 
2106     function setRecord(
2107         bytes32 node,
2108         address owner,
2109         address resolver,
2110         uint64 ttl
2111     ) external;
2112 
2113     function setSubnodeOwner(
2114         bytes32 node,
2115         string calldata label,
2116         address newOwner,
2117         uint32 fuses,
2118         uint64 expiry
2119     ) external returns (bytes32);
2120 
2121     function isTokenOwnerOrApproved(bytes32 node, address addr)
2122         external
2123         returns (bool);
2124 
2125     function setResolver(bytes32 node, address resolver) external;
2126 
2127     function setTTL(bytes32 node, uint64 ttl) external;
2128 
2129     function ownerOf(uint256 id) external returns (address owner);
2130 
2131     function getFuses(bytes32 node)
2132         external
2133         returns (uint32 fuses, uint64 expiry);
2134 
2135     function allFusesBurned(bytes32 node, uint32 fuseMask)
2136         external
2137         view
2138         returns (bool);
2139 
2140     function addTld(string calldata tld, bytes32 namehash) external;
2141 
2142     function removeTld(string calldata tld) external;
2143 }
2144 
2145 /**
2146  * @dev Interface of the ERC20 standard as defined in the EIP.
2147  */
2148 interface IERC20 {
2149     /**
2150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2151      * another (`to`).
2152      *
2153      * Note that `value` may be zero.
2154      */
2155     event Transfer(address indexed from, address indexed to, uint256 value);
2156 
2157     /**
2158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2159      * a call to {approve}. `value` is the new allowance.
2160      */
2161     event Approval(address indexed owner, address indexed spender, uint256 value);
2162 
2163     /**
2164      * @dev Returns the amount of tokens in existence.
2165      */
2166     function totalSupply() external view returns (uint256);
2167 
2168     /**
2169      * @dev Returns the amount of tokens owned by `account`.
2170      */
2171     function balanceOf(address account) external view returns (uint256);
2172 
2173     /**
2174      * @dev Moves `amount` tokens from the caller's account to `to`.
2175      *
2176      * Returns a boolean value indicating whether the operation succeeded.
2177      *
2178      * Emits a {Transfer} event.
2179      */
2180     function transfer(address to, uint256 amount) external returns (bool);
2181 
2182     /**
2183      * @dev Returns the remaining number of tokens that `spender` will be
2184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2185      * zero by default.
2186      *
2187      * This value changes when {approve} or {transferFrom} are called.
2188      */
2189     function allowance(address owner, address spender) external view returns (uint256);
2190 
2191     /**
2192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2193      *
2194      * Returns a boolean value indicating whether the operation succeeded.
2195      *
2196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2197      * that someone may use both the old and the new allowance by unfortunate
2198      * transaction ordering. One possible solution to mitigate this race
2199      * condition is to first reduce the spender's allowance to 0 and set the
2200      * desired value afterwards:
2201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2202      *
2203      * Emits an {Approval} event.
2204      */
2205     function approve(address spender, uint256 amount) external returns (bool);
2206 
2207     /**
2208      * @dev Moves `amount` tokens from `from` to `to` using the
2209      * allowance mechanism. `amount` is then deducted from the caller's
2210      * allowance.
2211      *
2212      * Returns a boolean value indicating whether the operation succeeded.
2213      *
2214      * Emits a {Transfer} event.
2215      */
2216     function transferFrom(
2217         address from,
2218         address to,
2219         uint256 amount
2220     ) external returns (bool);
2221 }
2222 
2223 /**
2224  * @dev A registrar controller for registering and renewing names at fixed cost.
2225  */
2226 contract ETHRegistrarController is Ownable, IETHRegistrarController {
2227     using StringUtils for *;
2228     using Address for address;
2229 
2230     uint256 public constant MIN_REGISTRATION_DURATION = 28 days;
2231     mapping(string => bytes32) public NODES;
2232 
2233     BaseRegistrarImplementation immutable base;
2234     IPriceOracle public immutable prices;
2235     uint256 public immutable minCommitmentAge;
2236     uint256 public immutable maxCommitmentAge;
2237     ReverseRegistrar public immutable reverseRegistrar;
2238     INameWrapper public immutable nameWrapper;
2239 
2240     mapping(bytes32 => uint256) public commitments;
2241 
2242     IERC20 public tomi;
2243     address public auction;
2244 
2245     event NameRegistered(
2246         IETHRegistrarController.domain name,
2247         bytes32 indexed label,
2248         address indexed owner,
2249         uint256 baseCost,
2250         uint256 premium,
2251         uint256 expires
2252     );
2253     
2254     event NameRenewed(
2255         string name,
2256         bytes32 indexed label,
2257         uint256 cost,
2258         uint256 expires,
2259         string tld
2260     );
2261 
2262     event TldAdded(
2263         string name,
2264         bytes32 indexed namehash,
2265         uint256 price,
2266         address percenatgeReceiver
2267     );
2268 
2269     event TldRemoved(
2270         string name
2271     );
2272 
2273     constructor(
2274         BaseRegistrarImplementation _base,
2275         IPriceOracle _prices,
2276         uint256 _minCommitmentAge,
2277         uint256 _maxCommitmentAge,
2278         ReverseRegistrar _reverseRegistrar,
2279         INameWrapper _nameWrapper,
2280         IERC20 _tomi
2281     ) {
2282         require(_maxCommitmentAge > _minCommitmentAge);
2283         base = _base;
2284         prices = _prices;
2285         minCommitmentAge = _minCommitmentAge;
2286         maxCommitmentAge = _maxCommitmentAge;
2287         reverseRegistrar = _reverseRegistrar;
2288         nameWrapper = _nameWrapper;
2289         tomi = _tomi;
2290         NODES["tomi"] = 0x7bb8237b54e801cf108eb3efb5a3d06b2366985979ad8184e49263d2a74e6fd4;
2291         NODES["com"] = 0xac2c11ea5d4a4826f418d3befbf0537de7f13572d2a433edfe4a7314ea5dc896;
2292     }
2293 
2294      /**
2295      * @notice Set the metadata service. Only the owner can do this
2296      */
2297 
2298       function setAuction(address _auction) external onlyOwner {
2299         auction = _auction;
2300     }
2301 
2302 
2303     function addTld(string calldata tld, uint256 price_, address percenatgeReceiver) external onlyOwner{
2304         bytes32 namehash = computeNamehash(tld);
2305         NODES[tld] = namehash;
2306         nameWrapper.addTld(tld , namehash);
2307 
2308         prices.setPrice(namehash, price_);
2309         emit TldAdded(tld, namehash , price_, percenatgeReceiver);
2310     }
2311 
2312 
2313     function removeTld(string calldata tld) external onlyOwner{
2314         NODES[tld] = bytes32(0);
2315         nameWrapper.removeTld(tld);
2316         emit TldRemoved(tld);
2317     }
2318 
2319 
2320     function rentPrice(string memory name, uint256 duration, bytes32 tld_)
2321         public
2322         view
2323         override
2324         returns (IPriceOracle.Price memory price)
2325     {
2326         bytes32 label = keccak256(bytes(name));
2327         price = prices.price(name, base.nameExpires(uint256(label)), duration, tld_);
2328     }
2329 
2330     function valid(string memory name, string memory tld) public view returns (bool) {
2331         return NODES[tld] != bytes32(0) && name.strlen() >= 3;
2332     }
2333 
2334 
2335     function available(string memory name, string memory tld) public view override returns (bool) {
2336         bytes32 label = keccak256(bytes(name));
2337         bytes32 node = _makeNode(NODES[tld] , label);
2338         return valid(name ,tld) && base.available(uint256(node));
2339     }
2340     
2341 
2342     function makeCommitment(
2343         IETHRegistrarController.domain memory name,
2344         address owner,
2345         uint256 duration,
2346         bytes32 secret,
2347         address resolver,
2348         bytes[] calldata data,
2349         bool reverseRecord,
2350         uint32 fuses
2351     ) public pure override returns (bytes32) {
2352         bytes32 label = keccak256(bytes(name.name));
2353         bytes32 tld = keccak256(bytes(name.tld));
2354 
2355         if (data.length > 0) {
2356             require(
2357                 resolver != address(0),
2358                 "ETHRegistrarController: resolver is required when data is supplied"
2359             );
2360         }
2361         return
2362             keccak256(
2363                 abi.encode(
2364                     label,
2365                     tld,
2366                     owner,
2367                     duration,
2368                     resolver,
2369                     data,
2370                     secret,
2371                     reverseRecord,
2372                     fuses
2373                 )
2374             );
2375     }
2376 
2377     function commit(bytes32 commitment) public override {
2378         require(commitments[commitment] + maxCommitmentAge < block.timestamp);
2379         commitments[commitment] = block.timestamp;
2380     }
2381 
2382     function register(
2383         IETHRegistrarController.domain calldata name,
2384         address owner,
2385         uint256 duration,
2386         bytes32 secret,
2387         address resolver,
2388         bytes[] calldata data,
2389         bool reverseRecord,
2390         uint32 fuses,
2391         uint64 wrapperExpiry
2392     ) public payable override {
2393         IPriceOracle.Price memory price = rentPrice(name.name, duration, NODES[name.tld]);
2394         require(
2395             tomi.allowance(msg.sender, address(this)) >= (price.base + price.premium),
2396             "ETHRegistrarController: Not enough tomi tokens approved"
2397         );
2398         require(NODES[name.tld] != bytes32(0) , "TLD not supported");
2399 
2400         tomi.transferFrom(msg.sender, auction, price.base + price.premium);
2401 
2402         _consumeCommitment(
2403             name.name,
2404             name.tld,
2405             duration,
2406             makeCommitment(
2407                 name,
2408                 owner,
2409                 duration,
2410                 secret,
2411                 resolver,
2412                 data,
2413                 reverseRecord,
2414                 fuses
2415             )
2416         );
2417 
2418         uint256 expires = nameWrapper.registerAndWrapETH2LD(
2419             name,
2420             owner,
2421             duration,
2422             resolver,
2423             price.base + price.premium
2424         );
2425         
2426         bytes32 nodehash = keccak256(abi.encodePacked(NODES[name.tld], keccak256(bytes(name.name))));
2427         _setRecords(resolver, nodehash, data);
2428 
2429         if (reverseRecord) {
2430             _setReverseRecord(string.concat(name.name, name.tld), resolver, msg.sender);
2431         }
2432 
2433         emit NameRegistered(
2434             name,
2435             keccak256(bytes(name.name)),
2436             owner,
2437             price.base,
2438             price.premium,
2439             expires
2440         );
2441     }
2442 
2443     function renew(string calldata name, uint256 duration, string calldata tld)
2444         external
2445         payable
2446         override
2447     {
2448         require(NODES[tld] != bytes32(0) , "TLD not supported");
2449         bytes32 label = keccak256(bytes(name));
2450         bytes32 node = _makeNode(NODES[tld] , label);
2451         IPriceOracle.Price memory price = rentPrice(name, duration, NODES[tld]);
2452         require(
2453             msg.value >= price.base,
2454             "ETHController: Not enough Ether provided for renewal"
2455         );
2456 
2457         uint256 expires = base.renew(uint256(node), duration);
2458 
2459         if (msg.value > price.base) {
2460             payable(msg.sender).transfer(msg.value - price.base);
2461         }
2462 
2463         emit NameRenewed(name, label, msg.value, expires ,tld);
2464     }
2465 
2466     function withdraw() public {
2467         payable(owner()).transfer(address(this).balance);
2468     }
2469 
2470     function supportsInterface(bytes4 interfaceID)
2471         external
2472         pure
2473         returns (bool)
2474     {
2475         return
2476             interfaceID == type(IERC165).interfaceId ||
2477             interfaceID == type(IETHRegistrarController).interfaceId;
2478     }
2479 
2480     /* Internal functions */
2481 
2482     function _consumeCommitment(
2483         string memory name,
2484         string memory tld,
2485         uint256 duration,
2486         bytes32 commitment
2487     ) internal {
2488         // Require a valid commitment (is old enough and is committed)
2489         require(
2490             commitments[commitment] + minCommitmentAge <= block.timestamp,
2491             "ETHRegistrarController: Commitment is not valid"
2492         );
2493 
2494         // If the commitment is too old, or the name is registered, stop
2495         require(
2496             commitments[commitment] + maxCommitmentAge > block.timestamp,
2497             "ETHRegistrarController: Commitment has expired"
2498         );
2499         require(available(name, tld), "ETHRegistrarController: Name is unavailable");
2500 
2501         delete (commitments[commitment]);
2502 
2503         require(duration >= MIN_REGISTRATION_DURATION, "ETHRegistrarController: Duration too low");
2504     }
2505 
2506     function _setRecords(
2507         address resolver,
2508         bytes32 nodehash,
2509         bytes[] calldata data
2510     ) internal {
2511         for (uint256 i = 0; i < data.length; i++) {
2512             // check first few bytes are namehash
2513             bytes32 txNamehash = bytes32(data[i][4:36]);
2514             require(
2515                 txNamehash == nodehash,
2516                 "ETHRegistrarController: Namehash on record do not match the name being registered"
2517             );
2518             resolver.functionCall(
2519                 data[i],
2520                 "ETHRegistrarController: Failed to set Record"
2521             );
2522         }
2523     }
2524 
2525     function _setReverseRecord(
2526         string memory name,
2527         address resolver,
2528         address owner
2529     ) internal {
2530         reverseRegistrar.setNameForAddr(
2531             msg.sender,
2532             owner,
2533             resolver,
2534             name
2535         );
2536     }
2537 
2538      function _makeNode(bytes32 node, bytes32 labelhash)
2539         private
2540         pure
2541         returns (bytes32)
2542     {
2543         return keccak256(abi.encodePacked(node, labelhash));
2544     }
2545 
2546     function computeNamehash(string calldata _name) public pure returns (bytes32 namehash_) {
2547         namehash_ = 0x0000000000000000000000000000000000000000000000000000000000000000;
2548         namehash_ = keccak256(
2549         abi.encodePacked(namehash_, keccak256(abi.encodePacked(_name)))
2550   ); 
2551 }
2552 
2553 }