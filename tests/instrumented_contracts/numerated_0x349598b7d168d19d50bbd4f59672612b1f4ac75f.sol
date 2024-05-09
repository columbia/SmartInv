1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @title ERC721 token receiver interface
80  * @dev Interface for any contract that wants to support safeTransfers
81  * from ERC721 asset contracts.
82  */
83 interface IERC721Receiver {
84     /**
85      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
86      * by `operator` from `from`, this function is called.
87      *
88      * It must return its Solidity selector to confirm the token transfer.
89      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
90      *
91      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
92      */
93     function onERC721Received(
94         address operator,
95         address from,
96         uint256 tokenId,
97         bytes calldata data
98     ) external returns (bytes4);
99 }
100 
101 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC165 standard, as defined in the
110  * https://eips.ethereum.org/EIPS/eip-165[EIP].
111  *
112  * Implementers can declare support of contract interfaces, which can then be
113  * queried by others ({ERC165Checker}).
114  *
115  * For an implementation, see {ERC165}.
116  */
117 interface IERC165 {
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30 000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 }
128 
129 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 
137 /**
138  * @dev Implementation of the {IERC165} interface.
139  *
140  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
141  * for the additional interface id that will be supported. For example:
142  *
143  * ```solidity
144  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
145  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
146  * }
147  * ```
148  *
149  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
150  */
151 abstract contract ERC165 is IERC165 {
152     /**
153      * @dev See {IERC165-supportsInterface}.
154      */
155     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
156         return interfaceId == type(IERC165).interfaceId;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 
168 /**
169  * @dev Required interface of an ERC721 compliant contract.
170  */
171 interface IERC721 is IERC165 {
172     /**
173      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
176 
177     /**
178      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
179      */
180     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
181 
182     /**
183      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
184      */
185     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
186 
187     /**
188      * @dev Returns the number of tokens in ``owner``'s account.
189      */
190     function balanceOf(address owner) external view returns (uint256 balance);
191 
192     /**
193      * @dev Returns the owner of the `tokenId` token.
194      *
195      * Requirements:
196      *
197      * - `tokenId` must exist.
198      */
199     function ownerOf(uint256 tokenId) external view returns (address owner);
200 
201     /**
202      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
203      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must exist and be owned by `from`.
210      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
211      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
212      *
213      * Emits a {Transfer} event.
214      */
215     function safeTransferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Transfers `tokenId` token from `from` to `to`.
223      *
224      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
225      *
226      * Requirements:
227      *
228      * - `from` cannot be the zero address.
229      * - `to` cannot be the zero address.
230      * - `tokenId` token must be owned by `from`.
231      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
232      *
233      * Emits a {Transfer} event.
234      */
235     function transferFrom(
236         address from,
237         address to,
238         uint256 tokenId
239     ) external;
240 
241     /**
242      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
243      * The approval is cleared when the token is transferred.
244      *
245      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
246      *
247      * Requirements:
248      *
249      * - The caller must own the token or be an approved operator.
250      * - `tokenId` must exist.
251      *
252      * Emits an {Approval} event.
253      */
254     function approve(address to, uint256 tokenId) external;
255 
256     /**
257      * @dev Returns the account approved for `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function getApproved(uint256 tokenId) external view returns (address operator);
264 
265     /**
266      * @dev Approve or remove `operator` as an operator for the caller.
267      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
268      *
269      * Requirements:
270      *
271      * - The `operator` cannot be the caller.
272      *
273      * Emits an {ApprovalForAll} event.
274      */
275     function setApprovalForAll(address operator, bool _approved) external;
276 
277     /**
278      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
279      *
280      * See {setApprovalForAll}
281      */
282     function isApprovedForAll(address owner, address operator) external view returns (bool);
283 
284     /**
285      * @dev Safely transfers `tokenId` token from `from` to `to`.
286      *
287      * Requirements:
288      *
289      * - `from` cannot be the zero address.
290      * - `to` cannot be the zero address.
291      * - `tokenId` token must exist and be owned by `from`.
292      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
293      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
294      *
295      * Emits a {Transfer} event.
296      */
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 tokenId,
301         bytes calldata data
302     ) external;
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
315  * @dev See https://eips.ethereum.org/EIPS/eip-721
316  */
317 interface IERC721Enumerable is IERC721 {
318     /**
319      * @dev Returns the total amount of tokens stored by the contract.
320      */
321     function totalSupply() external view returns (uint256);
322 
323     /**
324      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
325      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
326      */
327     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
328 
329     /**
330      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
331      * Use along with {totalSupply} to enumerate all tokens.
332      */
333     function tokenByIndex(uint256 index) external view returns (uint256);
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 
344 /**
345  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
346  * @dev See https://eips.ethereum.org/EIPS/eip-721
347  */
348 interface IERC721Metadata is IERC721 {
349     /**
350      * @dev Returns the token collection name.
351      */
352     function name() external view returns (string memory);
353 
354     /**
355      * @dev Returns the token collection symbol.
356      */
357     function symbol() external view returns (string memory);
358 
359     /**
360      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
361      */
362     function tokenURI(uint256 tokenId) external view returns (string memory);
363 }
364 
365 // File: @openzeppelin/contracts/utils/Context.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @dev Provides information about the current execution context, including the
374  * sender of the transaction and its data. While these are generally available
375  * via msg.sender and msg.data, they should not be accessed in such a direct
376  * manner, since when dealing with meta-transactions the account sending and
377  * paying for execution may not be the actual sender (as far as an application
378  * is concerned).
379  *
380  * This contract is only required for intermediate, library-like contracts.
381  */
382 abstract contract Context {
383     function _msgSender() internal view virtual returns (address) {
384         return msg.sender;
385     }
386 
387     function _msgData() internal view virtual returns (bytes calldata) {
388         return msg.data;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/access/Ownable.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev Contract module which provides a basic access control mechanism, where
402  * there is an account (an owner) that can be granted exclusive access to
403  * specific functions.
404  *
405  * By default, the owner account will be the one that deploys the contract. This
406  * can later be changed with {transferOwnership}.
407  *
408  * This module is used through inheritance. It will make available the modifier
409  * `onlyOwner`, which can be applied to your functions to restrict their use to
410  * the owner.
411  */
412 abstract contract Ownable is Context {
413     address private _owner;
414 
415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
416 
417     /**
418      * @dev Initializes the contract setting the deployer as the initial owner.
419      */
420     constructor() {
421         _transferOwnership(_msgSender());
422     }
423 
424     /**
425      * @dev Returns the address of the current owner.
426      */
427     function owner() public view virtual returns (address) {
428         return _owner;
429     }
430 
431     /**
432      * @dev Throws if called by any account other than the owner.
433      */
434     modifier onlyOwner() {
435         require(owner() == _msgSender(), "Ownable: caller is not the owner");
436         _;
437     }
438 
439     /**
440      * @dev Leaves the contract without owner. It will not be possible to call
441      * `onlyOwner` functions anymore. Can only be called by the current owner.
442      *
443      * NOTE: Renouncing ownership will leave the contract without an owner,
444      * thereby removing any functionality that is only available to the owner.
445      */
446     function renounceOwnership() public virtual onlyOwner {
447         _transferOwnership(address(0));
448     }
449 
450     /**
451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
452      * Can only be called by the current owner.
453      */
454     function transferOwnership(address newOwner) public virtual onlyOwner {
455         require(newOwner != address(0), "Ownable: new owner is the zero address");
456         _transferOwnership(newOwner);
457     }
458 
459     /**
460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
461      * Internal function without access restriction.
462      */
463     function _transferOwnership(address newOwner) internal virtual {
464         address oldOwner = _owner;
465         _owner = newOwner;
466         emit OwnershipTransferred(oldOwner, newOwner);
467     }
468 }
469 
470 // File: @openzeppelin/contracts/utils/Address.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Collection of functions related to the address type
479  */
480 library Address {
481     /**
482      * @dev Returns true if `account` is a contract.
483      *
484      * [IMPORTANT]
485      * ====
486      * It is unsafe to assume that an address for which this function returns
487      * false is an externally-owned account (EOA) and not a contract.
488      *
489      * Among others, `isContract` will return false for the following
490      * types of addresses:
491      *
492      *  - an externally-owned account
493      *  - a contract in construction
494      *  - an address where a contract will be created
495      *  - an address where a contract lived, but was destroyed
496      * ====
497      */
498     function isContract(address account) internal view returns (bool) {
499         // This method relies on extcodesize, which returns 0 for contracts in
500         // construction, since the code is only stored at the end of the
501         // constructor execution.
502 
503         uint256 size;
504         assembly {
505             size := extcodesize(account)
506         }
507         return size > 0;
508     }
509 
510     /**
511      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
512      * `recipient`, forwarding all available gas and reverting on errors.
513      *
514      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
515      * of certain opcodes, possibly making contracts go over the 2300 gas limit
516      * imposed by `transfer`, making them unable to receive funds via
517      * `transfer`. {sendValue} removes this limitation.
518      *
519      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
520      *
521      * IMPORTANT: because control is transferred to `recipient`, care must be
522      * taken to not create reentrancy vulnerabilities. Consider using
523      * {ReentrancyGuard} or the
524      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
525      */
526     function sendValue(address payable recipient, uint256 amount) internal {
527         require(address(this).balance >= amount, "Address: insufficient balance");
528 
529         (bool success, ) = recipient.call{value: amount}("");
530         require(success, "Address: unable to send value, recipient may have reverted");
531     }
532 
533     /**
534      * @dev Performs a Solidity function call using a low level `call`. A
535      * plain `call` is an unsafe replacement for a function call: use this
536      * function instead.
537      *
538      * If `target` reverts with a revert reason, it is bubbled up by this
539      * function (like regular Solidity function calls).
540      *
541      * Returns the raw returned data. To convert to the expected return value,
542      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
543      *
544      * Requirements:
545      *
546      * - `target` must be a contract.
547      * - calling `target` with `data` must not revert.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
552         return functionCall(target, data, "Address: low-level call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
557      * `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal returns (bytes memory) {
566         return functionCallWithValue(target, data, 0, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but also transferring `value` wei to `target`.
572      *
573      * Requirements:
574      *
575      * - the calling contract must have an ETH balance of at least `value`.
576      * - the called Solidity function must be `payable`.
577      *
578      * _Available since v3.1._
579      */
580     function functionCallWithValue(
581         address target,
582         bytes memory data,
583         uint256 value
584     ) internal returns (bytes memory) {
585         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
590      * with `errorMessage` as a fallback revert reason when `target` reverts.
591      *
592      * _Available since v3.1._
593      */
594     function functionCallWithValue(
595         address target,
596         bytes memory data,
597         uint256 value,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(address(this).balance >= value, "Address: insufficient balance for call");
601         require(isContract(target), "Address: call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.call{value: value}(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but performing a static call.
610      *
611      * _Available since v3.3._
612      */
613     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
614         return functionStaticCall(target, data, "Address: low-level static call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
619      * but performing a static call.
620      *
621      * _Available since v3.3._
622      */
623     function functionStaticCall(
624         address target,
625         bytes memory data,
626         string memory errorMessage
627     ) internal view returns (bytes memory) {
628         require(isContract(target), "Address: static call to non-contract");
629 
630         (bool success, bytes memory returndata) = target.staticcall(data);
631         return verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
636      * but performing a delegate call.
637      *
638      * _Available since v3.4._
639      */
640     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
641         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
646      * but performing a delegate call.
647      *
648      * _Available since v3.4._
649      */
650     function functionDelegateCall(
651         address target,
652         bytes memory data,
653         string memory errorMessage
654     ) internal returns (bytes memory) {
655         require(isContract(target), "Address: delegate call to non-contract");
656 
657         (bool success, bytes memory returndata) = target.delegatecall(data);
658         return verifyCallResult(success, returndata, errorMessage);
659     }
660 
661     /**
662      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
663      * revert reason using the provided one.
664      *
665      * _Available since v4.3._
666      */
667     function verifyCallResult(
668         bool success,
669         bytes memory returndata,
670         string memory errorMessage
671     ) internal pure returns (bytes memory) {
672         if (success) {
673             return returndata;
674         } else {
675             // Look for revert reason and bubble it up if present
676             if (returndata.length > 0) {
677                 // The easiest way to bubble the revert reason is using memory via assembly
678 
679                 assembly {
680                     let returndata_size := mload(returndata)
681                     revert(add(32, returndata), returndata_size)
682                 }
683             } else {
684                 revert(errorMessage);
685             }
686         }
687     }
688 }
689 
690 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 
699 
700 
701 
702 
703 
704 /**
705  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
706  * the Metadata extension, but not including the Enumerable extension, which is available separately as
707  * {ERC721Enumerable}.
708  */
709 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
710     using Address for address;
711     using Strings for uint256;
712 
713     // Token name
714     string private _name;
715 
716     // Token symbol
717     string private _symbol;
718 
719     // Mapping from token ID to owner address
720     mapping(uint256 => address) private _owners;
721 
722     // Mapping owner address to token count
723     mapping(address => uint256) private _balances;
724 
725     // Mapping from token ID to approved address
726     mapping(uint256 => address) private _tokenApprovals;
727 
728     // Mapping from owner to operator approvals
729     mapping(address => mapping(address => bool)) private _operatorApprovals;
730 
731     /**
732      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
733      */
734     constructor(string memory name_, string memory symbol_) {
735         _name = name_;
736         _symbol = symbol_;
737     }
738 
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
743         return
744             interfaceId == type(IERC721).interfaceId ||
745             interfaceId == type(IERC721Metadata).interfaceId ||
746             super.supportsInterface(interfaceId);
747     }
748 
749     /**
750      * @dev See {IERC721-balanceOf}.
751      */
752     function balanceOf(address owner) public view virtual override returns (uint256) {
753         require(owner != address(0), "ERC721: balance query for the zero address");
754         return _balances[owner];
755     }
756 
757     /**
758      * @dev See {IERC721-ownerOf}.
759      */
760     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
761         address owner = _owners[tokenId];
762         require(owner != address(0), "ERC721: owner query for nonexistent token");
763         return owner;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-name}.
768      */
769     function name() public view virtual override returns (string memory) {
770         return _name;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-symbol}.
775      */
776     function symbol() public view virtual override returns (string memory) {
777         return _symbol;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-tokenURI}.
782      */
783     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
784         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
785 
786         string memory baseURI = _baseURI();
787         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
788     }
789 
790     /**
791      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
792      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
793      * by default, can be overriden in child contracts.
794      */
795     function _baseURI() internal view virtual returns (string memory) {
796         return "";
797     }
798 
799     /**
800      * @dev See {IERC721-approve}.
801      */
802     function approve(address to, uint256 tokenId) public virtual override {
803         address owner = ERC721.ownerOf(tokenId);
804         require(to != owner, "ERC721: approval to current owner");
805 
806         require(
807             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
808             "ERC721: approve caller is not owner nor approved for all"
809         );
810 
811         _approve(to, tokenId);
812     }
813 
814     /**
815      * @dev See {IERC721-getApproved}.
816      */
817     function getApproved(uint256 tokenId) public view virtual override returns (address) {
818         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
819 
820         return _tokenApprovals[tokenId];
821     }
822 
823     /**
824      * @dev See {IERC721-setApprovalForAll}.
825      */
826     function setApprovalForAll(address operator, bool approved) public virtual override {
827         _setApprovalForAll(_msgSender(), operator, approved);
828     }
829 
830     /**
831      * @dev See {IERC721-isApprovedForAll}.
832      */
833     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
834         return _operatorApprovals[owner][operator];
835     }
836 
837     /**
838      * @dev See {IERC721-transferFrom}.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public virtual override {
845         //solhint-disable-next-line max-line-length
846         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
847 
848         _transfer(from, to, tokenId);
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) public virtual override {
859         safeTransferFrom(from, to, tokenId, "");
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) public virtual override {
871         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
872         _safeTransfer(from, to, tokenId, _data);
873     }
874 
875     /**
876      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
877      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
878      *
879      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
880      *
881      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
882      * implement alternative mechanisms to perform token transfer, such as signature-based.
883      *
884      * Requirements:
885      *
886      * - `from` cannot be the zero address.
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must exist and be owned by `from`.
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _safeTransfer(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) internal virtual {
899         _transfer(from, to, tokenId);
900         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
901     }
902 
903     /**
904      * @dev Returns whether `tokenId` exists.
905      *
906      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
907      *
908      * Tokens start existing when they are minted (`_mint`),
909      * and stop existing when they are burned (`_burn`).
910      */
911     function _exists(uint256 tokenId) internal view virtual returns (bool) {
912         return _owners[tokenId] != address(0);
913     }
914 
915     /**
916      * @dev Returns whether `spender` is allowed to manage `tokenId`.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must exist.
921      */
922     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
923         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
924         address owner = ERC721.ownerOf(tokenId);
925         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
926     }
927 
928     /**
929      * @dev Safely mints `tokenId` and transfers it to `to`.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must not exist.
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _safeMint(address to, uint256 tokenId) internal virtual {
939         _safeMint(to, tokenId, "");
940     }
941 
942     /**
943      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
944      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
945      */
946     function _safeMint(
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) internal virtual {
951         _mint(to, tokenId);
952         require(
953             _checkOnERC721Received(address(0), to, tokenId, _data),
954             "ERC721: transfer to non ERC721Receiver implementer"
955         );
956     }
957 
958     /**
959      * @dev Mints `tokenId` and transfers it to `to`.
960      *
961      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
962      *
963      * Requirements:
964      *
965      * - `tokenId` must not exist.
966      * - `to` cannot be the zero address.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _mint(address to, uint256 tokenId) internal virtual {
971         require(to != address(0), "ERC721: mint to the zero address");
972         require(!_exists(tokenId), "ERC721: token already minted");
973 
974         _beforeTokenTransfer(address(0), to, tokenId);
975 
976         _balances[to] += 1;
977         _owners[tokenId] = to;
978 
979         emit Transfer(address(0), to, tokenId);
980     }
981 
982     /**
983      * @dev Destroys `tokenId`.
984      * The approval is cleared when the token is burned.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _burn(uint256 tokenId) internal virtual {
993         address owner = ERC721.ownerOf(tokenId);
994 
995         _beforeTokenTransfer(owner, address(0), tokenId);
996 
997         // Clear approvals
998         _approve(address(0), tokenId);
999 
1000         _balances[owner] -= 1;
1001         delete _owners[tokenId];
1002 
1003         emit Transfer(owner, address(0), tokenId);
1004     }
1005 
1006     /**
1007      * @dev Transfers `tokenId` from `from` to `to`.
1008      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1009      *
1010      * Requirements:
1011      *
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must be owned by `from`.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual {
1022         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1023         require(to != address(0), "ERC721: transfer to the zero address");
1024 
1025         _beforeTokenTransfer(from, to, tokenId);
1026 
1027         // Clear approvals from the previous owner
1028         _approve(address(0), tokenId);
1029 
1030         _balances[from] -= 1;
1031         _balances[to] += 1;
1032         _owners[tokenId] = to;
1033 
1034         emit Transfer(from, to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Approve `to` to operate on `tokenId`
1039      *
1040      * Emits a {Approval} event.
1041      */
1042     function _approve(address to, uint256 tokenId) internal virtual {
1043         _tokenApprovals[tokenId] = to;
1044         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev Approve `operator` to operate on all of `owner` tokens
1049      *
1050      * Emits a {ApprovalForAll} event.
1051      */
1052     function _setApprovalForAll(
1053         address owner,
1054         address operator,
1055         bool approved
1056     ) internal virtual {
1057         require(owner != operator, "ERC721: approve to caller");
1058         _operatorApprovals[owner][operator] = approved;
1059         emit ApprovalForAll(owner, operator, approved);
1060     }
1061 
1062     /**
1063      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1064      * The call is not executed if the target address is not a contract.
1065      *
1066      * @param from address representing the previous owner of the given token ID
1067      * @param to target address that will receive the tokens
1068      * @param tokenId uint256 ID of the token to be transferred
1069      * @param _data bytes optional data to send along with the call
1070      * @return bool whether the call correctly returned the expected magic value
1071      */
1072     function _checkOnERC721Received(
1073         address from,
1074         address to,
1075         uint256 tokenId,
1076         bytes memory _data
1077     ) private returns (bool) {
1078         if (to.isContract()) {
1079             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1080                 return retval == IERC721Receiver.onERC721Received.selector;
1081             } catch (bytes memory reason) {
1082                 if (reason.length == 0) {
1083                     revert("ERC721: transfer to non ERC721Receiver implementer");
1084                 } else {
1085                     assembly {
1086                         revert(add(32, reason), mload(reason))
1087                     }
1088                 }
1089             }
1090         } else {
1091             return true;
1092         }
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any token transfer. This includes minting
1097      * and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` will be minted for `to`.
1104      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) internal virtual {}
1114 }
1115 
1116 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1117 
1118 
1119 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1120 
1121 pragma solidity ^0.8.0;
1122 
1123 
1124 
1125 /**
1126  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1127  * enumerability of all the token ids in the contract as well as all token ids owned by each
1128  * account.
1129  */
1130 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1131     // Mapping from owner to list of owned token IDs
1132     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1133 
1134     // Mapping from token ID to index of the owner tokens list
1135     mapping(uint256 => uint256) private _ownedTokensIndex;
1136 
1137     // Array with all token ids, used for enumeration
1138     uint256[] private _allTokens;
1139 
1140     // Mapping from token id to position in the allTokens array
1141     mapping(uint256 => uint256) private _allTokensIndex;
1142 
1143     /**
1144      * @dev See {IERC165-supportsInterface}.
1145      */
1146     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1147         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1152      */
1153     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1154         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1155         return _ownedTokens[owner][index];
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Enumerable-totalSupply}.
1160      */
1161     function totalSupply() public view virtual override returns (uint256) {
1162         return _allTokens.length;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Enumerable-tokenByIndex}.
1167      */
1168     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1169         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1170         return _allTokens[index];
1171     }
1172 
1173     /**
1174      * @dev Hook that is called before any token transfer. This includes minting
1175      * and burning.
1176      *
1177      * Calling conditions:
1178      *
1179      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1180      * transferred to `to`.
1181      * - When `from` is zero, `tokenId` will be minted for `to`.
1182      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1183      * - `from` cannot be the zero address.
1184      * - `to` cannot be the zero address.
1185      *
1186      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1187      */
1188     function _beforeTokenTransfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) internal virtual override {
1193         super._beforeTokenTransfer(from, to, tokenId);
1194 
1195         if (from == address(0)) {
1196             _addTokenToAllTokensEnumeration(tokenId);
1197         } else if (from != to) {
1198             _removeTokenFromOwnerEnumeration(from, tokenId);
1199         }
1200         if (to == address(0)) {
1201             _removeTokenFromAllTokensEnumeration(tokenId);
1202         } else if (to != from) {
1203             _addTokenToOwnerEnumeration(to, tokenId);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1209      * @param to address representing the new owner of the given token ID
1210      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1211      */
1212     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1213         uint256 length = ERC721.balanceOf(to);
1214         _ownedTokens[to][length] = tokenId;
1215         _ownedTokensIndex[tokenId] = length;
1216     }
1217 
1218     /**
1219      * @dev Private function to add a token to this extension's token tracking data structures.
1220      * @param tokenId uint256 ID of the token to be added to the tokens list
1221      */
1222     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1223         _allTokensIndex[tokenId] = _allTokens.length;
1224         _allTokens.push(tokenId);
1225     }
1226 
1227     /**
1228      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1229      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1230      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1231      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1232      * @param from address representing the previous owner of the given token ID
1233      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1234      */
1235     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1236         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1237         // then delete the last slot (swap and pop).
1238 
1239         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1240         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1241 
1242         // When the token to delete is the last token, the swap operation is unnecessary
1243         if (tokenIndex != lastTokenIndex) {
1244             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1245 
1246             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1247             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1248         }
1249 
1250         // This also deletes the contents at the last position of the array
1251         delete _ownedTokensIndex[tokenId];
1252         delete _ownedTokens[from][lastTokenIndex];
1253     }
1254 
1255     /**
1256      * @dev Private function to remove a token from this extension's token tracking data structures.
1257      * This has O(1) time complexity, but alters the order of the _allTokens array.
1258      * @param tokenId uint256 ID of the token to be removed from the tokens list
1259      */
1260     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1261         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1262         // then delete the last slot (swap and pop).
1263 
1264         uint256 lastTokenIndex = _allTokens.length - 1;
1265         uint256 tokenIndex = _allTokensIndex[tokenId];
1266 
1267         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1268         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1269         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1270         uint256 lastTokenId = _allTokens[lastTokenIndex];
1271 
1272         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1273         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1274 
1275         // This also deletes the contents at the last position of the array
1276         delete _allTokensIndex[tokenId];
1277         _allTokens.pop();
1278     }
1279 }
1280 
1281 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1282 
1283 
1284 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 /**
1289  * @dev Interface of the ERC20 standard as defined in the EIP.
1290  */
1291 interface IERC20 {
1292     /**
1293      * @dev Returns the amount of tokens in existence.
1294      */
1295     function totalSupply() external view returns (uint256);
1296 
1297     /**
1298      * @dev Returns the amount of tokens owned by `account`.
1299      */
1300     function balanceOf(address account) external view returns (uint256);
1301 
1302     /**
1303      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1304      *
1305      * Returns a boolean value indicating whether the operation succeeded.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function transfer(address recipient, uint256 amount) external returns (bool);
1310 
1311     /**
1312      * @dev Returns the remaining number of tokens that `spender` will be
1313      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1314      * zero by default.
1315      *
1316      * This value changes when {approve} or {transferFrom} are called.
1317      */
1318     function allowance(address owner, address spender) external view returns (uint256);
1319 
1320     /**
1321      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1322      *
1323      * Returns a boolean value indicating whether the operation succeeded.
1324      *
1325      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1326      * that someone may use both the old and the new allowance by unfortunate
1327      * transaction ordering. One possible solution to mitigate this race
1328      * condition is to first reduce the spender's allowance to 0 and set the
1329      * desired value afterwards:
1330      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1331      *
1332      * Emits an {Approval} event.
1333      */
1334     function approve(address spender, uint256 amount) external returns (bool);
1335 
1336     /**
1337      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1338      * allowance mechanism. `amount` is then deducted from the caller's
1339      * allowance.
1340      *
1341      * Returns a boolean value indicating whether the operation succeeded.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function transferFrom(
1346         address sender,
1347         address recipient,
1348         uint256 amount
1349     ) external returns (bool);
1350 
1351     /**
1352      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1353      * another (`to`).
1354      *
1355      * Note that `value` may be zero.
1356      */
1357     event Transfer(address indexed from, address indexed to, uint256 value);
1358 
1359     /**
1360      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1361      * a call to {approve}. `value` is the new allowance.
1362      */
1363     event Approval(address indexed owner, address indexed spender, uint256 value);
1364 }
1365 
1366 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1367 
1368 
1369 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 
1374 
1375 /**
1376  * @title SafeERC20
1377  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1378  * contract returns false). Tokens that return no value (and instead revert or
1379  * throw on failure) are also supported, non-reverting calls are assumed to be
1380  * successful.
1381  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1382  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1383  */
1384 library SafeERC20 {
1385     using Address for address;
1386 
1387     function safeTransfer(
1388         IERC20 token,
1389         address to,
1390         uint256 value
1391     ) internal {
1392         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1393     }
1394 
1395     function safeTransferFrom(
1396         IERC20 token,
1397         address from,
1398         address to,
1399         uint256 value
1400     ) internal {
1401         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1402     }
1403 
1404     /**
1405      * @dev Deprecated. This function has issues similar to the ones found in
1406      * {IERC20-approve}, and its usage is discouraged.
1407      *
1408      * Whenever possible, use {safeIncreaseAllowance} and
1409      * {safeDecreaseAllowance} instead.
1410      */
1411     function safeApprove(
1412         IERC20 token,
1413         address spender,
1414         uint256 value
1415     ) internal {
1416         // safeApprove should only be called when setting an initial allowance,
1417         // or when resetting it to zero. To increase and decrease it, use
1418         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1419         require(
1420             (value == 0) || (token.allowance(address(this), spender) == 0),
1421             "SafeERC20: approve from non-zero to non-zero allowance"
1422         );
1423         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1424     }
1425 
1426     function safeIncreaseAllowance(
1427         IERC20 token,
1428         address spender,
1429         uint256 value
1430     ) internal {
1431         uint256 newAllowance = token.allowance(address(this), spender) + value;
1432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1433     }
1434 
1435     function safeDecreaseAllowance(
1436         IERC20 token,
1437         address spender,
1438         uint256 value
1439     ) internal {
1440         unchecked {
1441             uint256 oldAllowance = token.allowance(address(this), spender);
1442             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1443             uint256 newAllowance = oldAllowance - value;
1444             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1445         }
1446     }
1447 
1448     /**
1449      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1450      * on the return value: the return value is optional (but if data is returned, it must not be false).
1451      * @param token The token targeted by the call.
1452      * @param data The call data (encoded using abi.encode or one of its variants).
1453      */
1454     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1455         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1456         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1457         // the target address contains contract code and also asserts for success in the low-level call.
1458 
1459         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1460         if (returndata.length > 0) {
1461             // Return data is optional
1462             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1463         }
1464     }
1465 }
1466 
1467 // File: contracts/ccnft.sol
1468 
1469 
1470 pragma solidity 0.8.7;
1471 
1472 
1473 
1474 
1475 
1476 
1477 
1478 /**
1479 ERROR TABLE (saves gas and contract size)
1480     ER1:    Ownable: caller is not the owner
1481     ER2: "Ownable: new owner is the zero address"
1482     ER3: "Address: insufficient balance"
1483     ER4: "Address: unable to send value, recipient may have reverted"
1484     ER5: "Address: low-level call failed"
1485     ER6: "Address: low-level call with value failed"
1486     ER7: "Address: insufficient balance for call"
1487     ER8: "Address: call to non-contract"
1488     ER9: "Address: low-level static call failed"
1489     ER10: "Address: static call to non-contract"
1490     ER11: "Address: low-level delegate call failed"
1491     ER12: "Address: delegate call to non-contract"
1492     ER13: "Strings: hex length insufficient"
1493     ER14: "ERC721: balance query for the zero address"
1494     ER15: "ERC721: owner query for nonexistent token"
1495     ER16: ERC721Metadata: URI query for nonexistent token
1496     ER17: ERC721: approval to current owner
1497     ER18: ERC721: approve caller is not owner nor approved for all
1498     ER19: ERC721: approved query for nonexistent token
1499     ER20: ERC721: approve to caller
1500     ER21: ERC721: transfer caller is not owner nor approved
1501     ER22: ERC721: transfer caller is not owner nor approved
1502     ER23: ERC721: transfer to non ERC721Receiver implementer
1503     ER24: ERC721: operator query for nonexistent token
1504     ER25: ERC721: transfer to non ERC721Receiver implementer
1505     ER26: ERC721: mint to the zero address
1506     ER27: ERC721: token already minted
1507     ER28: ERC721: transfer of token that is not own
1508     ER29: ERC721: transfer to the zero address
1509     ER30: ERC721: transfer to non ERC721Receiver implementer
1510     ER31: ERC721Enumerable: owner index out of bounds
1511     ER32: ERC721Enumerable: global index out of bounds
1512     ER33: insufficient funds
1513     ER34: XMartianNFT: checkMintQty() Exceeds Max Mint QTY
1514     ER35: the contract is paused
1515     ER36: max NFT limit exceeded for collection
1516     ER37: max NFT limit exceeded for collection
1517     ER38: max NFT limit exceeded
1518     ER39: ERC721Metadata: URI query for nonexistent token
1519 */
1520 
1521 
1522 
1523 
1524 contract Ccnft is ERC721Enumerable, Ownable {
1525     using Strings for uint256;
1526 
1527 
1528     uint16 public maxMintQty = 200;
1529     uint16 public constant MAX_SUPPLY = 2_500;
1530     bool public autoFloor = true;
1531     bool public paused = true;
1532 
1533     string public baseExtension = ".json";
1534     string public placeHolderURL;
1535     string[] public baseURIs;
1536 
1537     mapping(uint8 => uint32) public currentSubCollectionSupply;
1538     mapping(uint8 => uint256) public cost;
1539 
1540     mapping(uint8 => uint16) public maxSubCollectionMints;
1541     mapping(uint256 => uint8) public addressUrlType;
1542     mapping(uint256 => uint256) public urlToId;
1543     mapping(uint256 => string) public idUrlCustom;
1544 
1545     // USAGE: customMintables[address] = customMintableNFTS
1546     mapping(address => uint8) public customMintables;
1547 
1548     // USAGE: giveAwayAllowance[subCollectionNumber][address] = number address can claim
1549     mapping(uint8 => mapping(address => uint8)) public giveAwayAllowance;
1550     // USAGE: remainingReserved[subCollectionNumber] = number of remaining items reserved for presale addresses
1551     mapping(uint8 => uint16) public remainingReserved;
1552     // USAGE: holderReservedCount[subCollectionNumber][address] = number of reserved items for address
1553     mapping(uint8 => mapping(address => uint16)) public holderReservedCount;
1554 
1555     function batchAddCustomMintables(
1556         address[] memory addr,
1557         uint8[] memory count
1558     ) external onlyOwner {
1559         _iterateBatchAddCustomMintables(addr, count);
1560     }
1561 
1562     function _iterateBatchAddCustomMintables(
1563         address[] memory addr,
1564         uint8[] memory count
1565     ) internal {
1566         for (uint16 i = 0; i < addr.length; i++) {
1567             customMintables[addr[i]] = count[i];
1568         }
1569     }
1570 
1571     function batchAddGiveAwayAllowance(
1572         address[] memory addr,
1573         uint8[] memory count,
1574         uint8[] memory collectionNumber
1575     ) external onlyOwner {
1576 
1577         _iterateBatchAddToGiveAway(addr,count,collectionNumber);
1578     }
1579 
1580     function _iterateBatchAddToGiveAway(
1581         address[] memory addr,
1582         uint8[] memory count,
1583         uint8[] memory collectionNumber
1584     ) internal {
1585         for (uint16 i = 0; i < addr.length; i++) {
1586             giveAwayAllowance[collectionNumber[i]][addr[i]] = count[i];
1587         }
1588     }
1589 
1590     function batchAddHolderReservedCount(
1591         address[] memory addr,
1592         uint8[] memory count,
1593         uint8[] memory collectionNumber
1594     ) external onlyOwner {
1595     
1596         _iterateBatchAddHolderReservedCount(addr,count,collectionNumber);
1597     }
1598 
1599     function _iterateBatchAddHolderReservedCount(
1600         address[] memory addr,
1601         uint8[] memory count,
1602         uint8[] memory collectionNumber
1603     ) internal {
1604         for (uint16 i = 0; i < addr.length; i++) {
1605             holderReservedCount[collectionNumber[i]][addr[i]] = count[i];
1606             remainingReserved[collectionNumber[i]] = remainingReserved[collectionNumber[i]] + count[i];
1607         }
1608     }
1609 
1610     constructor(
1611         string memory _name,
1612         string memory _symbol,
1613         string[] memory _initBaseURIs,
1614         string memory _placeHolderURL,
1615         address[] memory payees,
1616          uint256[] memory shares_
1617     ) ERC721(_name, _symbol) {
1618         setBaseURIs(_initBaseURIs);
1619         placeHolderURL = _placeHolderURL;
1620 
1621         cost[0] = 75000000000000000 ;
1622 
1623         maxSubCollectionMints[0] = 2500;
1624 
1625         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1626         require(payees.length > 0, "PaymentSplitter: no payees");
1627 
1628         for (uint256 i = 0; i < payees.length; i++) {
1629             _addPayee(payees[i], shares_[i]);
1630         }
1631     }
1632 
1633   // internal
1634     function _baseURIs() public view virtual returns (string[] memory) {
1635         return baseURIs;
1636     }
1637 
1638     function mint1(uint8 mintQty) public payable { _iterateMint(0, mintQty); }
1639 
1640     // public
1641     function _iterateMint(uint8 subCollection, uint8 mintQty) internal {
1642         checkPaused();
1643         checkMintQty(mintQty, maxMintQty);
1644         uint256 _afterMintSupply = totalSupply() + mintQty;
1645         checkMaxSupply(_afterMintSupply);
1646         checkSupplyAndReserved(subCollection, mintQty);
1647     // if the msgSender has a free giveaway allowance
1648         if(mintQty <= giveAwayAllowance[subCollection][_msgSender()]){
1649             // subtract mint qty from giveAway allowance
1650             giveAwayAllowance[subCollection][_msgSender()] = mintQty;
1651         } else {
1652             checkTxCost(msg.value, (cost[subCollection] * mintQty));
1653         }
1654         for (uint256 i; i < mintQty; i++) {
1655             _mintTx(subCollection);
1656         }
1657     }
1658 
1659     function getTxCost(uint8 subCollection, uint8 mintQty) public view returns (uint256 value){
1660         if(mintQty <= giveAwayAllowance[subCollection][_msgSender()]){
1661             return 0;
1662         } else {
1663             return (cost[subCollection] * mintQty);
1664         }
1665     }
1666 
1667 
1668     function _mintTx(uint8 subCollection) internal {
1669         uint256 tokenId = totalSupply() + 1;
1670         addressUrlType[tokenId] = subCollection;
1671         currentSubCollectionSupply[subCollection]++;
1672         urlToId[tokenId] = currentSubCollectionSupply[subCollection];
1673         _safeMint(_msgSender(), tokenId);
1674     }
1675 
1676 
1677     function _mintCustom() internal {
1678         checkPaused();
1679         if(customMintables[_msgSender()] > 0 || _msgSender() == owner()){
1680             if (_msgSender() != owner()) {
1681                 customMintables[_msgSender()]--;
1682                 require(msg.value >= cost[4] , "insufficient funds");
1683             }
1684             uint256 tokenId = totalSupply() + 1;
1685             currentSubCollectionSupply[4]++;
1686             addressUrlType[tokenId] = 4;
1687             _safeMint(_msgSender(), tokenId);
1688             idUrlCustom[tokenId] = placeHolderURL;
1689         }
1690     }
1691 
1692 
1693     function _setPrice(
1694         uint256 costSubCol0
1695 
1696     ) internal {
1697         cost[0] = costSubCol0;
1698      }
1699 
1700     function setPrice(
1701         uint256 Mint1Cost_
1702     ) external onlyOwner {
1703         cost[0] = Mint1Cost_;
1704     }
1705 
1706     function walletOfOwner(address _owner)
1707         public
1708         view
1709         returns (uint256[] memory)
1710     {
1711         uint256 ownerTokenCount = balanceOf(_owner);
1712         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1713         for (uint256 i; i < ownerTokenCount; i++) {
1714           tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1715         }
1716         return tokenIds;
1717     }
1718 
1719     function tokenURI(uint256 tokenId)
1720         public
1721         view
1722         virtual
1723         override
1724         returns (string memory)
1725     {
1726         require(
1727             _exists(tokenId),
1728             "ER39"
1729         );
1730 
1731         string[] memory currentBaseURI = _baseURIs();
1732         if (addressUrlType[tokenId] == 4) {
1733             return bytes(idUrlCustom[tokenId]).length > 0
1734                 ? string(abi.encodePacked(idUrlCustom[tokenId], baseExtension))
1735                 : "";
1736         } else {
1737             return bytes(currentBaseURI[addressUrlType[tokenId]]).length > 0
1738                 ? string(abi.encodePacked(currentBaseURI[addressUrlType[tokenId]], urlToId[tokenId].toString(), baseExtension))
1739                 : "";
1740         }
1741     }
1742 
1743     //only owner
1744     function togglePaused() external onlyOwner {
1745         paused?
1746         paused = false:
1747         paused = true;
1748     }
1749 
1750     function toggleAutoFloor() external onlyOwner {
1751         autoFloor?
1752         autoFloor = false:
1753         autoFloor = true;
1754     }
1755 
1756     function setBaseURIs(string[] memory _newBaseURIs) public onlyOwner {baseURIs = _newBaseURIs;}
1757     function setMaxMintQty(uint16 new_maxMintQty) public onlyOwner {maxMintQty = new_maxMintQty;}
1758     function setCustomUrl(uint256 tokenId, string memory newUrl) public onlyOwner  {idUrlCustom[tokenId] = newUrl;}
1759     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {baseExtension = _newBaseExtension;}
1760 
1761     // check functions with Revert statements
1762     function checkMaxSupply(uint256 afterMintSupply_) internal pure {
1763         require(afterMintSupply_ <= MAX_SUPPLY, "ER38");
1764     }
1765 
1766     function checkSupplyAndReserved(uint8 collectionNumber, uint16 mintQty) internal {
1767         address sender = _msgSender();
1768         uint16 holderReserved_ = holderReservedCount[collectionNumber][sender];
1769         uint16 remainingReserved_ = remainingReserved[collectionNumber];
1770         uint16 maxSubCollectionMints_ = maxSubCollectionMints[collectionNumber];
1771         if(holderReserved_ == 0) {
1772             require(
1773                 currentSubCollectionSupply[collectionNumber] + mintQty <= maxSubCollectionMints_ - remainingReserved_,
1774                 "ER36"
1775             );
1776         } else {
1777             require(
1778                 currentSubCollectionSupply[collectionNumber] + mintQty <= maxSubCollectionMints_,
1779                 "ER37"
1780             );
1781             if(mintQty >= holderReserved_) {
1782                 remainingReserved[collectionNumber] = remainingReserved_ - holderReserved_;
1783                 holderReservedCount[collectionNumber][sender] = 0;
1784             } else {
1785                 remainingReserved[collectionNumber] = remainingReserved_ - mintQty;
1786                 holderReservedCount[collectionNumber][sender] = holderReserved_ - mintQty;
1787             }
1788         }
1789     }
1790 
1791     function checkTxCost(uint256 msgValue, uint256 totalMintCost) internal pure {
1792         require(msgValue >= totalMintCost, "ER33");
1793     }
1794 
1795     function checkMintQty(uint8 mintQty, uint16 maxMintQty_) internal pure {
1796         require(mintQty <= maxMintQty_, "ER34");
1797     }
1798 
1799     function checkPaused() internal view {
1800         require(!paused || _msgSender() == owner(), "ER35");
1801     }
1802 
1803 
1804      event PayeeAdded(address account, uint256 shares);
1805     event PaymentReleased(address to, uint256 amount);
1806     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1807     event PaymentReceived(address from, uint256 amount);
1808 
1809     uint256 private _totalShares;
1810     uint256 private _totalReleased;
1811 
1812     mapping(address => uint256) private _shares;
1813     mapping(address => uint256) private _released;
1814     address[] private _payees;
1815 
1816     mapping(IERC20 => uint256) private _erc20TotalReleased;
1817     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1818 
1819 
1820     /**
1821      * @dev Getter for the total shares held by payees.
1822      */
1823     function totalShares() public view returns (uint256) {
1824         return _totalShares;
1825     }
1826 
1827     /**
1828      * @dev Getter for the total amount of Ether already released.
1829      */
1830     function totalReleased() public view returns (uint256) {
1831         return _totalReleased;
1832     }
1833 
1834     /**
1835      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1836      * contract.
1837      */
1838     function totalReleased(IERC20 token) public view returns (uint256) {
1839         return _erc20TotalReleased[token];
1840     }
1841 
1842     /**
1843      * @dev Getter for the amount of shares held by an account.
1844      */
1845     function shares(address account) public view returns (uint256) {
1846         return _shares[account];
1847     }
1848 
1849     /**
1850      * @dev Getter for the amount of Ether already released to a payee.
1851      */
1852     function released(address account) public view returns (uint256) {
1853         return _released[account];
1854     }
1855 
1856     /**
1857      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1858      * IERC20 contract.
1859      */
1860     function released(IERC20 token, address account) public view returns (uint256) {
1861         return _erc20Released[token][account];
1862     }
1863 
1864     /**
1865      * @dev Getter for the address of the payee number `index`.
1866      */
1867     function payee(uint256 index) public view returns (address) {
1868         return _payees[index];
1869     }
1870 
1871     /**
1872      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1873      * total shares and their previous withdrawals.
1874      */
1875     function release(address payable account) public virtual {
1876         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1877 
1878         uint256 totalReceived = address(this).balance + totalReleased();
1879         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1880 
1881         require(payment != 0, "PaymentSplitter: account is not due payment");
1882 
1883         _released[account] += payment;
1884         _totalReleased += payment;
1885 
1886         Address.sendValue(account, payment);
1887         emit PaymentReleased(account, payment);
1888     }
1889 
1890     /**
1891      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1892      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1893      * contract.
1894      */
1895     function release(IERC20 token, address account) public virtual {
1896         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1897 
1898         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1899         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1900 
1901         require(payment != 0, "PaymentSplitter: account is not due payment");
1902 
1903         _erc20Released[token][account] += payment;
1904         _erc20TotalReleased[token] += payment;
1905 
1906         SafeERC20.safeTransfer(token, account, payment);
1907         emit ERC20PaymentReleased(token, account, payment);
1908     }
1909 
1910     /**
1911      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1912      * already released amounts.
1913      */
1914     function _pendingPayment(
1915         address account,
1916         uint256 totalReceived,
1917         uint256 alreadyReleased
1918     ) private view returns (uint256) {
1919         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1920     }
1921 
1922     /**
1923      * @dev Add a new payee to the contract.
1924      * @param account The address of the payee to add.
1925      * @param shares_ The number of shares owned by the payee.
1926      */
1927     function _addPayee(address account, uint256 shares_) private {
1928         require(account != address(0), "PaymentSplitter: account is the zero address");
1929         require(shares_ > 0, "PaymentSplitter: shares are 0");
1930         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1931 
1932         _payees.push(account);
1933         _shares[account] = shares_;
1934         _totalShares = _totalShares + shares_;
1935         emit PayeeAdded(account, shares_);
1936     }
1937 
1938     fallback() external payable {  }
1939     receive() external payable {emit PaymentReceived(_msgSender(), msg.value);}
1940 }