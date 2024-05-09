1 // SPDX-License-Identifier: MIT
2 
3 /*
4    ___   _                ___             _      _              _    _     
5   / _ \ | |__ __ _  _  _ |   \  _  _  __ | |__  /_\   ___ _  _ | |__(_) ___
6  | (_) || / // _` || || || |) || || |/ _|| / / / _ \ |_ /| || || / /| |(_-<
7   \___/ |_\_\\__,_| \_, ||___/  \_,_|\__||_\_\/_/ \_\/__| \_,_||_\_\|_|/__/
8                     |__/                                                   
9 */
10 
11 // File 1: Address.sol
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
14 
15 pragma solidity ^0.8.1;
16 
17 /**
18  * @dev Collection of functions related to the address type
19  */
20 library Address {
21     /**
22      * @dev Returns true if `account` is a contract.
23      *
24      * [IMPORTANT]
25      * ====
26      * It is unsafe to assume that an address for which this function returns
27      * false is an externally-owned account (EOA) and not a contract.
28      *
29      * Among others, `isContract` will return false for the following
30      * types of addresses:
31      *
32      *  - an externally-owned account
33      *  - a contract in construction
34      *  - an address where a contract will be created
35      *  - an address where a contract lived, but was destroyed
36      * ====
37      *
38      * [IMPORTANT]
39      * ====
40      * You shouldn't rely on `isContract` to protect against flash loan attacks!
41      *
42      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
43      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
44      * constructor.
45      * ====
46      */
47     function isContract(address account) internal view returns (bool) {
48         // This method relies on extcodesize/address.code.length, which returns 0
49         // for contracts in construction, since the code is only stored at the end
50         // of the constructor execution.
51 
52         return account.code.length > 0;
53     }
54 
55     /**
56      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
57      * `recipient`, forwarding all available gas and reverting on errors.
58      *
59      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
60      * of certain opcodes, possibly making contracts go over the 2300 gas limit
61      * imposed by `transfer`, making them unable to receive funds via
62      * `transfer`. {sendValue} removes this limitation.
63      *
64      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
65      *
66      * IMPORTANT: because control is transferred to `recipient`, care must be
67      * taken to not create reentrancy vulnerabilities. Consider using
68      * {ReentrancyGuard} or the
69      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
70      */
71     function sendValue(address payable recipient, uint256 amount) internal {
72         require(address(this).balance >= amount, "Address: insufficient balance");
73 
74         (bool success, ) = recipient.call{value: amount}("");
75         require(success, "Address: unable to send value, recipient may have reverted");
76     }
77 
78     /**
79      * @dev Performs a Solidity function call using a low level `call`. A
80      * plain `call` is an unsafe replacement for a function call: use this
81      * function instead.
82      *
83      * If `target` reverts with a revert reason, it is bubbled up by this
84      * function (like regular Solidity function calls).
85      *
86      * Returns the raw returned data. To convert to the expected return value,
87      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
88      *
89      * Requirements:
90      *
91      * - `target` must be a contract.
92      * - calling `target` with `data` must not revert.
93      *
94      * _Available since v3.1._
95      */
96     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
97         return functionCall(target, data, "Address: low-level call failed");
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
102      * `errorMessage` as a fallback revert reason when `target` reverts.
103      *
104      * _Available since v3.1._
105      */
106     function functionCall(
107         address target,
108         bytes memory data,
109         string memory errorMessage
110     ) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, 0, errorMessage);
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
116      * but also transferring `value` wei to `target`.
117      *
118      * Requirements:
119      *
120      * - the calling contract must have an ETH balance of at least `value`.
121      * - the called Solidity function must be `payable`.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value
129     ) internal returns (bytes memory) {
130         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
135      * with `errorMessage` as a fallback revert reason when `target` reverts.
136      *
137      * _Available since v3.1._
138      */
139     function functionCallWithValue(
140         address target,
141         bytes memory data,
142         uint256 value,
143         string memory errorMessage
144     ) internal returns (bytes memory) {
145         require(address(this).balance >= value, "Address: insufficient balance for call");
146         require(isContract(target), "Address: call to non-contract");
147 
148         (bool success, bytes memory returndata) = target.call{value: value}(data);
149         return verifyCallResult(success, returndata, errorMessage);
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
154      * but performing a static call.
155      *
156      * _Available since v3.3._
157      */
158     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
159         return functionStaticCall(target, data, "Address: low-level static call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
164      * but performing a static call.
165      *
166      * _Available since v3.3._
167      */
168     function functionStaticCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal view returns (bytes memory) {
173         require(isContract(target), "Address: static call to non-contract");
174 
175         (bool success, bytes memory returndata) = target.staticcall(data);
176         return verifyCallResult(success, returndata, errorMessage);
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
181      * but performing a delegate call.
182      *
183      * _Available since v3.4._
184      */
185     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
191      * but performing a delegate call.
192      *
193      * _Available since v3.4._
194      */
195     function functionDelegateCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         require(isContract(target), "Address: delegate call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.delegatecall(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
208      * revert reason using the provided one.
209      *
210      * _Available since v4.3._
211      */
212     function verifyCallResult(
213         bool success,
214         bytes memory returndata,
215         string memory errorMessage
216     ) internal pure returns (bytes memory) {
217         if (success) {
218             return returndata;
219         } else {
220             // Look for revert reason and bubble it up if present
221             if (returndata.length > 0) {
222                 // The easiest way to bubble the revert reason is using memory via assembly
223 
224                 assembly {
225                     let returndata_size := mload(returndata)
226                     revert(add(32, returndata), returndata_size)
227                 }
228             } else {
229                 revert(errorMessage);
230             }
231         }
232     }
233 }
234 
235 
236 // FILE 2: Context.sol
237 pragma solidity ^0.8.0;
238 
239 /*
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 abstract contract Context {
250     function _msgSender() internal view virtual returns (address) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes calldata) {
255         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256         return msg.data;
257     }
258 }
259 
260 // File 3: Strings.sol
261 
262 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev String operations.
268  */
269 library Strings {
270     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
271 
272     /**
273      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
274      */
275     function toString(uint256 value) internal pure returns (string memory) {
276         // Inspired by OraclizeAPI's implementation - MIT licence
277         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
278 
279         if (value == 0) {
280             return "0";
281         }
282         uint256 temp = value;
283         uint256 digits;
284         while (temp != 0) {
285             digits++;
286             temp /= 10;
287         }
288         bytes memory buffer = new bytes(digits);
289         while (value != 0) {
290             digits -= 1;
291             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
292             value /= 10;
293         }
294         return string(buffer);
295     }
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
299      */
300     function toHexString(uint256 value) internal pure returns (string memory) {
301         if (value == 0) {
302             return "0x00";
303         }
304         uint256 temp = value;
305         uint256 length = 0;
306         while (temp != 0) {
307             length++;
308             temp >>= 8;
309         }
310         return toHexString(value, length);
311     }
312 
313     /**
314      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
315      */
316     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
317         bytes memory buffer = new bytes(2 * length + 2);
318         buffer[0] = "0";
319         buffer[1] = "x";
320         for (uint256 i = 2 * length + 1; i > 1; --i) {
321             buffer[i] = _HEX_SYMBOLS[value & 0xf];
322             value >>= 4;
323         }
324         require(value == 0, "Strings: hex length insufficient");
325         return string(buffer);
326     }
327 }
328 
329 
330 // File: @openzeppelin/contracts/utils/Counters.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @title Counters
339  * @author Matt Condon (@shrugs)
340  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
341  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
342  *
343  * Include with `using Counters for Counters.Counter;`
344  */
345 library Counters {
346     struct Counter {
347         // This variable should never be directly accessed by users of the library: interactions must be restricted to
348         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
349         // this feature: see https://github.com/ethereum/solidity/issues/4637
350         uint256 _value; // default: 0
351     }
352 
353     function current(Counter storage counter) internal view returns (uint256) {
354         return counter._value;
355     }
356 
357     function increment(Counter storage counter) internal {
358         unchecked {
359             counter._value += 1;
360         }
361     }
362 
363     function decrement(Counter storage counter) internal {
364         uint256 value = counter._value;
365         require(value > 0, "Counter: decrement overflow");
366         unchecked {
367             counter._value = value - 1;
368         }
369     }
370 
371     function reset(Counter storage counter) internal {
372         counter._value = 0;
373     }
374 }
375 
376 // File 4: Ownable.sol
377 
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 abstract contract Ownable is Context {
395     address private _owner;
396 
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398 
399     /**
400      * @dev Initializes the contract setting the deployer as the initial owner.
401      */
402     constructor () {
403         address msgSender = _msgSender();
404         _owner = msgSender;
405         emit OwnershipTransferred(address(0), msgSender);
406     }
407 
408     /**
409      * @dev Returns the address of the current owner.
410      */
411     function owner() public view virtual returns (address) {
412         return _owner;
413     }
414 
415     /**
416      * @dev Throws if called by any account other than the owner.
417      */
418     modifier onlyOwner() {
419         require(owner() == _msgSender(), "Ownable: caller is not the owner");
420         _;
421     }
422 
423     /**
424      * @dev Leaves the contract without owner. It will not be possible to call
425      * `onlyOwner` functions anymore. Can only be called by the current owner.
426      *
427      * NOTE: Renouncing ownership will leave the contract without an owner,
428      * thereby removing any functionality that is only available to the owner.
429      */
430     function renounceOwnership() public virtual onlyOwner {
431         emit OwnershipTransferred(_owner, address(0));
432         _owner = address(0);
433     }
434 
435     /**
436      * @dev Transfers ownership of the contract to a new account (`newOwner`).
437      * Can only be called by the current owner.
438      */
439     function transferOwnership(address newOwner) public virtual onlyOwner {
440         require(newOwner != address(0), "Ownable: new owner is the zero address");
441         emit OwnershipTransferred(_owner, newOwner);
442         _owner = newOwner;
443     }
444 }
445 
446 
447 
448 
449 
450 // File 5: IERC165.sol
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Interface of the ERC165 standard, as defined in the
456  * https://eips.ethereum.org/EIPS/eip-165[EIP].
457  *
458  * Implementers can declare support of contract interfaces, which can then be
459  * queried by others ({ERC165Checker}).
460  *
461  * For an implementation, see {ERC165}.
462  */
463 interface IERC165 {
464     /**
465      * @dev Returns true if this contract implements the interface defined by
466      * `interfaceId`. See the corresponding
467      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
468      * to learn more about how these ids are created.
469      *
470      * This function call must use less than 30 000 gas.
471      */
472     function supportsInterface(bytes4 interfaceId) external view returns (bool);
473 }
474 
475 
476 // File 6: IERC721.sol
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Required interface of an ERC721 compliant contract.
483  */
484 interface IERC721 is IERC165 {
485     /**
486      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
487      */
488     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
489 
490     /**
491      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
492      */
493     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
494 
495     /**
496      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
497      */
498     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
499 
500     /**
501      * @dev Returns the number of tokens in ``owner``'s account.
502      */
503     function balanceOf(address owner) external view returns (uint256 balance);
504 
505     /**
506      * @dev Returns the owner of the `tokenId` token.
507      *
508      * Requirements:
509      *
510      * - `tokenId` must exist.
511      */
512     function ownerOf(uint256 tokenId) external view returns (address owner);
513 
514     /**
515      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
516      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
517      *
518      * Requirements:
519      *
520      * - `from` cannot be the zero address.
521      * - `to` cannot be the zero address.
522      * - `tokenId` token must exist and be owned by `from`.
523      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
524      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
525      *
526      * Emits a {Transfer} event.
527      */
528     function safeTransferFrom(address from, address to, uint256 tokenId) external;
529 
530     /**
531      * @dev Transfers `tokenId` token from `from` to `to`.
532      *
533      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must be owned by `from`.
540      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
541      *
542      * Emits a {Transfer} event.
543      */
544     function transferFrom(address from, address to, uint256 tokenId) external;
545 
546     /**
547      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
548      * The approval is cleared when the token is transferred.
549      *
550      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
551      *
552      * Requirements:
553      *
554      * - The caller must own the token or be an approved operator.
555      * - `tokenId` must exist.
556      *
557      * Emits an {Approval} event.
558      */
559     function approve(address to, uint256 tokenId) external;
560 
561     /**
562      * @dev Returns the account approved for `tokenId` token.
563      *
564      * Requirements:
565      *
566      * - `tokenId` must exist.
567      */
568     function getApproved(uint256 tokenId) external view returns (address operator);
569 
570     /**
571      * @dev Approve or remove `operator` as an operator for the caller.
572      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
573      *
574      * Requirements:
575      *
576      * - The `operator` cannot be the caller.
577      *
578      * Emits an {ApprovalForAll} event.
579      */
580     function setApprovalForAll(address operator, bool _approved) external;
581 
582     /**
583      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
584      *
585      * See {setApprovalForAll}
586      */
587     function isApprovedForAll(address owner, address operator) external view returns (bool);
588 
589     /**
590       * @dev Safely transfers `tokenId` token from `from` to `to`.
591       *
592       * Requirements:
593       *
594       * - `from` cannot be the zero address.
595       * - `to` cannot be the zero address.
596       * - `tokenId` token must exist and be owned by `from`.
597       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
598       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
599       *
600       * Emits a {Transfer} event.
601       */
602     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
603 }
604 
605 
606 
607 // File 7: IERC721Metadata.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 
615 /**
616  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
617  * @dev See https://eips.ethereum.org/EIPS/eip-721
618  */
619 interface IERC721Metadata is IERC721 {
620     /**
621      * @dev Returns the token collection name.
622      */
623     function name() external view returns (string memory);
624 
625     /**
626      * @dev Returns the token collection symbol.
627      */
628     function symbol() external view returns (string memory);
629 
630     /**
631      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
632      */
633     function tokenURI(uint256 tokenId) external returns (string memory);
634 }
635 
636 
637 
638 
639 // File 8: ERC165.sol
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 
646 /**
647  * @dev Implementation of the {IERC165} interface.
648  *
649  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
650  * for the additional interface id that will be supported. For example:
651  *
652  * ```solidity
653  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
654  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
655  * }
656  * ```
657  *
658  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
659  */
660 abstract contract ERC165 is IERC165 {
661     /**
662      * @dev See {IERC165-supportsInterface}.
663      */
664     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
665         return interfaceId == type(IERC165).interfaceId;
666     }
667 }
668 
669 
670 // File 9: ERC721.sol
671 
672 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 
677 /**
678  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
679  * the Metadata extension, but not including the Enumerable extension, which is available separately as
680  * {ERC721Enumerable}.
681  */
682 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
683     using Address for address;
684     using Strings for uint256;
685 
686     // Token name
687     string private _name;
688 
689     // Token symbol
690     string private _symbol;
691 
692     // Mapping from token ID to owner address
693     mapping(uint256 => address) private _owners;
694 
695     // Mapping owner address to token count
696     mapping(address => uint256) private _balances;
697 
698     // Mapping from token ID to approved address
699     mapping(uint256 => address) private _tokenApprovals;
700 
701     // Mapping from owner to operator approvals
702     mapping(address => mapping(address => bool)) private _operatorApprovals;
703 
704     /**
705      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
706      */
707     constructor(string memory name_, string memory symbol_) {
708         _name = name_;
709         _symbol = symbol_;
710     }
711 
712     /**
713      * @dev See {IERC165-supportsInterface}.
714      */
715     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
716         return
717             interfaceId == type(IERC721).interfaceId ||
718             interfaceId == type(IERC721Metadata).interfaceId ||
719             super.supportsInterface(interfaceId);
720     }
721 
722     /**
723      * @dev See {IERC721-balanceOf}.
724      */
725     function balanceOf(address owner) public view virtual override returns (uint256) {
726         require(owner != address(0), "ERC721: balance query for the zero address");
727         return _balances[owner];
728     }
729 
730     /**
731      * @dev See {IERC721-ownerOf}.
732      */
733     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
734         address owner = _owners[tokenId];
735         require(owner != address(0), "ERC721: owner query for nonexistent token");
736         return owner;
737     }
738 
739     /**
740      * @dev See {IERC721Metadata-name}.
741      */
742     function name() public view virtual override returns (string memory) {
743         return _name;
744     }
745 
746     /**
747      * @dev See {IERC721Metadata-symbol}.
748      */
749     function symbol() public view virtual override returns (string memory) {
750         return _symbol;
751     }
752 
753     /**
754      * @dev See {IERC721Metadata-tokenURI}.
755      */
756     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
757         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
758 
759         string memory baseURI = _baseURI();
760         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
761     }
762 
763     /**
764      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
765      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
766      * by default, can be overridden in child contracts.
767      */
768     function _baseURI() internal view virtual returns (string memory) {
769         return "";
770     }
771 
772     /**
773      * @dev See {IERC721-approve}.
774      */
775     function approve(address to, uint256 tokenId) public virtual override {
776         address owner = ERC721.ownerOf(tokenId);
777         require(to != owner, "ERC721: approval to current owner");
778 
779         require(
780             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
781             "ERC721: approve caller is not owner nor approved for all"
782         );
783         if (to.isContract()) {
784             revert ("Token transfer to contract address is not allowed.");
785         } else {
786             _approve(to, tokenId);
787         }
788         // _approve(to, tokenId);
789     }
790 
791     /**
792      * @dev See {IERC721-getApproved}.
793      */
794     function getApproved(uint256 tokenId) public view virtual override returns (address) {
795         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
796 
797         return _tokenApprovals[tokenId];
798     }
799 
800     /**
801      * @dev See {IERC721-setApprovalForAll}.
802      */
803     function setApprovalForAll(address operator, bool approved) public virtual override {
804         _setApprovalForAll(_msgSender(), operator, approved);
805     }
806 
807     /**
808      * @dev See {IERC721-isApprovedForAll}.
809      */
810     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
811         return _operatorApprovals[owner][operator];
812     }
813 
814     /**
815      * @dev See {IERC721-transferFrom}.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) public virtual override {
822         //solhint-disable-next-line max-line-length
823         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
824 
825         _transfer(from, to, tokenId);
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public virtual override {
836         safeTransferFrom(from, to, tokenId, "");
837     }
838 
839     /**
840      * @dev See {IERC721-safeTransferFrom}.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) public virtual override {
848         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
849         _safeTransfer(from, to, tokenId, _data);
850     }
851 
852     /**
853      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
854      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
855      *
856      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
857      *
858      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
859      * implement alternative mechanisms to perform token transfer, such as signature-based.
860      *
861      * Requirements:
862      *
863      * - `from` cannot be the zero address.
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must exist and be owned by `from`.
866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _safeTransfer(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) internal virtual {
876         _transfer(from, to, tokenId);
877         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
878     }
879 
880     /**
881      * @dev Returns whether `tokenId` exists.
882      *
883      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
884      *
885      * Tokens start existing when they are minted (`_mint`),
886      * and stop existing when they are burned (`_burn`).
887      */
888     function _exists(uint256 tokenId) internal view virtual returns (bool) {
889         return _owners[tokenId] != address(0);
890     }
891 
892     /**
893      * @dev Returns whether `spender` is allowed to manage `tokenId`.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
900         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
901         address owner = ERC721.ownerOf(tokenId);
902         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
903     }
904 
905     /**
906      * @dev Safely mints `tokenId` and transfers it to `to`.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must not exist.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeMint(address to, uint256 tokenId) internal virtual {
916         _safeMint(to, tokenId, "");
917     }
918 
919     /**
920      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
921      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
922      */
923     function _safeMint(
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) internal virtual {
928         _mint(to, tokenId);
929         require(
930             _checkOnERC721Received(address(0), to, tokenId, _data),
931             "ERC721: transfer to non ERC721Receiver implementer"
932         );
933     }
934 
935     /**
936      * @dev Mints `tokenId` and transfers it to `to`.
937      *
938      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
939      *
940      * Requirements:
941      *
942      * - `tokenId` must not exist.
943      * - `to` cannot be the zero address.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _mint(address to, uint256 tokenId) internal virtual {
948         require(to != address(0), "ERC721: mint to the zero address");
949         require(!_exists(tokenId), "ERC721: token already minted");
950 
951         _beforeTokenTransfer(address(0), to, tokenId);
952 
953         _balances[to] += 1;
954         _owners[tokenId] = to;
955 
956         emit Transfer(address(0), to, tokenId);
957 
958         _afterTokenTransfer(address(0), to, tokenId);
959     }
960 
961     /**
962      * @dev Destroys `tokenId`.
963      * The approval is cleared when the token is burned.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must exist.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _burn(uint256 tokenId) internal virtual {
972         address owner = ERC721.ownerOf(tokenId);
973 
974         _beforeTokenTransfer(owner, address(0), tokenId);
975 
976         // Clear approvals
977         _approve(address(0), tokenId);
978 
979         _balances[owner] -= 1;
980         delete _owners[tokenId];
981 
982         emit Transfer(owner, address(0), tokenId);
983 
984         _afterTokenTransfer(owner, address(0), tokenId);
985     }
986 
987     /**
988      * @dev Transfers `tokenId` from `from` to `to`.
989      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
990      *
991      * Requirements:
992      *
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must be owned by `from`.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _transfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) internal virtual {
1003         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1004         require(to != address(0), "ERC721: transfer to the zero address");
1005 
1006         _beforeTokenTransfer(from, to, tokenId);
1007 
1008         // Clear approvals from the previous owner
1009         _approve(address(0), tokenId);
1010 
1011         _balances[from] -= 1;
1012         _balances[to] += 1;
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(from, to, tokenId);
1016 
1017         _afterTokenTransfer(from, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Approve `to` to operate on `tokenId`
1022      *
1023      * Emits a {Approval} event.
1024      */
1025     function _approve(address to, uint256 tokenId) internal virtual {
1026         _tokenApprovals[tokenId] = to;
1027         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev Approve `operator` to operate on all of `owner` tokens
1032      *
1033      * Emits a {ApprovalForAll} event.
1034      */
1035     function _setApprovalForAll(
1036         address owner,
1037         address operator,
1038         bool approved
1039     ) internal virtual {
1040         require(owner != operator, "ERC721: approve to caller");
1041         _operatorApprovals[owner][operator] = approved;
1042         emit ApprovalForAll(owner, operator, approved);
1043     }
1044 
1045     /**
1046      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1047      * The call is not executed if the target address is not a contract.
1048      *
1049      * @param from address representing the previous owner of the given token ID
1050      * @param to target address that will receive the tokens
1051      * @param tokenId uint256 ID of the token to be transferred
1052      * @param _data bytes optional data to send along with the call
1053      * @return bool whether the call correctly returned the expected magic value
1054      */
1055     function _checkOnERC721Received(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) private returns (bool) {
1061         if (to.isContract()) {
1062             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1063                 return retval == IERC721Receiver.onERC721Received.selector;
1064             } catch (bytes memory reason) {
1065                 if (reason.length == 0) {
1066                     revert("ERC721: transfer to non ERC721Receiver implementer");
1067                 } else {
1068                     assembly {
1069                         revert(add(32, reason), mload(reason))
1070                     }
1071                 }
1072             }
1073         } else {
1074             return true;
1075         }
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` and `to` are never both zero.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual {}
1097 
1098     /**
1099      * @dev Hook that is called after any transfer of tokens. This includes
1100      * minting and burning.
1101      *
1102      * Calling conditions:
1103      *
1104      * - when `from` and `to` are both non-zero.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _afterTokenTransfer(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) internal virtual {}
1114 }
1115 
1116 
1117 
1118 
1119 
1120 // File 10: IERC721Enumerable.sol
1121 
1122 pragma solidity ^0.8.0;
1123 
1124 
1125 /**
1126  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1127  * @dev See https://eips.ethereum.org/EIPS/eip-721
1128  */
1129 interface IERC721Enumerable is IERC721 {
1130 
1131     /**
1132      * @dev Returns the total amount of tokens stored by the contract.
1133      */
1134     function totalSupply() external view returns (uint256);
1135 
1136     /**
1137      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1138      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1139      */
1140     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1141 
1142     /**
1143      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1144      * Use along with {totalSupply} to enumerate all tokens.
1145      */
1146     function tokenByIndex(uint256 index) external view returns (uint256);
1147 }
1148 
1149 
1150 
1151 
1152 
1153 
1154 // File 11: ERC721Enumerable.sol
1155 
1156 pragma solidity ^0.8.0;
1157 
1158 
1159 /**
1160  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1161  * enumerability of all the token ids in the contract as well as all token ids owned by each
1162  * account.
1163  */
1164 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1165     // Mapping from owner to list of owned token IDs
1166     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1167 
1168     // Mapping from token ID to index of the owner tokens list
1169     mapping(uint256 => uint256) private _ownedTokensIndex;
1170 
1171     // Array with all token ids, used for enumeration
1172     uint256[] private _allTokens;
1173 
1174     // Mapping from token id to position in the allTokens array
1175     mapping(uint256 => uint256) private _allTokensIndex;
1176 
1177     /**
1178      * @dev See {IERC165-supportsInterface}.
1179      */
1180     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1181         return interfaceId == type(IERC721Enumerable).interfaceId
1182             || super.supportsInterface(interfaceId);
1183     }
1184 
1185     /**
1186      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1187      */
1188     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1189         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1190         return _ownedTokens[owner][index];
1191     }
1192 
1193     /**
1194      * @dev See {IERC721Enumerable-totalSupply}.
1195      */
1196     function totalSupply() public view virtual override returns (uint256) {
1197         return _allTokens.length;
1198     }
1199 
1200     /**
1201      * @dev See {IERC721Enumerable-tokenByIndex}.
1202      */
1203     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1204         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1205         return _allTokens[index];
1206     }
1207 
1208     /**
1209      * @dev Hook that is called before any token transfer. This includes minting
1210      * and burning.
1211      *
1212      * Calling conditions:
1213      *
1214      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1215      * transferred to `to`.
1216      * - When `from` is zero, `tokenId` will be minted for `to`.
1217      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1218      * - `from` cannot be the zero address.
1219      * - `to` cannot be the zero address.
1220      *
1221      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1222      */
1223     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1224         super._beforeTokenTransfer(from, to, tokenId);
1225 
1226         if (from == address(0)) {
1227             _addTokenToAllTokensEnumeration(tokenId);
1228         } else if (from != to) {
1229             _removeTokenFromOwnerEnumeration(from, tokenId);
1230         }
1231         if (to == address(0)) {
1232             _removeTokenFromAllTokensEnumeration(tokenId);
1233         } else if (to != from) {
1234             _addTokenToOwnerEnumeration(to, tokenId);
1235         }
1236     }
1237 
1238     /**
1239      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1240      * @param to address representing the new owner of the given token ID
1241      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1242      */
1243     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1244         uint256 length = ERC721.balanceOf(to);
1245         _ownedTokens[to][length] = tokenId;
1246         _ownedTokensIndex[tokenId] = length;
1247     }
1248 
1249     /**
1250      * @dev Private function to add a token to this extension's token tracking data structures.
1251      * @param tokenId uint256 ID of the token to be added to the tokens list
1252      */
1253     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1254         _allTokensIndex[tokenId] = _allTokens.length;
1255         _allTokens.push(tokenId);
1256     }
1257 
1258     /**
1259      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1260      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1261      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1262      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1263      * @param from address representing the previous owner of the given token ID
1264      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1265      */
1266     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1267         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1268         // then delete the last slot (swap and pop).
1269 
1270         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1271         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1272 
1273         // When the token to delete is the last token, the swap operation is unnecessary
1274         if (tokenIndex != lastTokenIndex) {
1275             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1276 
1277             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1278             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1279         }
1280 
1281         // This also deletes the contents at the last position of the array
1282         delete _ownedTokensIndex[tokenId];
1283         delete _ownedTokens[from][lastTokenIndex];
1284     }
1285 
1286     /**
1287      * @dev Private function to remove a token from this extension's token tracking data structures.
1288      * This has O(1) time complexity, but alters the order of the _allTokens array.
1289      * @param tokenId uint256 ID of the token to be removed from the tokens list
1290      */
1291     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1292         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1293         // then delete the last slot (swap and pop).
1294 
1295         uint256 lastTokenIndex = _allTokens.length - 1;
1296         uint256 tokenIndex = _allTokensIndex[tokenId];
1297 
1298         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1299         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1300         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1301         uint256 lastTokenId = _allTokens[lastTokenIndex];
1302 
1303         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1304         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1305 
1306         // This also deletes the contents at the last position of the array
1307         delete _allTokensIndex[tokenId];
1308         _allTokens.pop();
1309     }
1310 }
1311 
1312 
1313 
1314 // File 12: IERC721Receiver.sol
1315 
1316 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1317 
1318 pragma solidity ^0.8.0;
1319 
1320 /**
1321  * @title ERC721 token receiver interface
1322  * @dev Interface for any contract that wants to support safeTransfers
1323  * from ERC721 asset contracts.
1324  */
1325 interface IERC721Receiver {
1326     /**
1327      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1328      * by `operator` from `from`, this function is called.
1329      *
1330      * It must return its Solidity selector to confirm the token transfer.
1331      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1332      *
1333      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1334      */
1335     function onERC721Received(
1336         address operator,
1337         address from,
1338         uint256 tokenId,
1339         bytes calldata data
1340     ) external returns (bytes4);
1341 }
1342 
1343 
1344 
1345 // File 13: ERC721A.sol
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 
1350 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1351     using Address for address;
1352     using Strings for uint256;
1353 
1354     struct TokenOwnership {
1355         address addr;
1356         uint64 startTimestamp;
1357     }
1358 
1359     struct AddressData {
1360         uint128 balance;
1361         uint128 numberMinted;
1362     }
1363 
1364     uint256 internal currentIndex;
1365 
1366     // Token name
1367     string private _name;
1368 
1369     // Token symbol
1370     string private _symbol;
1371 
1372     // Mapping from token ID to ownership details
1373     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1374     mapping(uint256 => TokenOwnership) internal _ownerships;
1375 
1376     // Mapping owner address to address data
1377     mapping(address => AddressData) private _addressData;
1378 
1379     // Mapping from token ID to approved address
1380     mapping(uint256 => address) private _tokenApprovals;
1381 
1382     // Mapping from owner to operator approvals
1383     mapping(address => mapping(address => bool)) private _operatorApprovals;
1384 
1385     constructor(string memory name_, string memory symbol_) {
1386         _name = name_;
1387         _symbol = symbol_;
1388     }
1389 
1390     /**
1391      * @dev See {IERC721Enumerable-totalSupply}.
1392      */
1393     function totalSupply() public view override virtual returns (uint256) {
1394         return currentIndex;
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Enumerable-tokenByIndex}.
1399      */
1400     function tokenByIndex(uint256 index) public view override returns (uint256) {
1401         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1402         return index;
1403     }
1404 
1405     /**
1406      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1407      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1408      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1409      */
1410     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1411         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1412         uint256 numMintedSoFar = totalSupply();
1413         uint256 tokenIdsIdx;
1414         address currOwnershipAddr;
1415 
1416         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1417         unchecked {
1418             for (uint256 i; i < numMintedSoFar; i++) {
1419                 TokenOwnership memory ownership = _ownerships[i];
1420                 if (ownership.addr != address(0)) {
1421                     currOwnershipAddr = ownership.addr;
1422                 }
1423                 if (currOwnershipAddr == owner) {
1424                     if (tokenIdsIdx == index) {
1425                         return i;
1426                     }
1427                     tokenIdsIdx++;
1428                 }
1429             }
1430         }
1431 
1432         revert('ERC721A: unable to get token of owner by index');
1433     }
1434 
1435     /**
1436      * @dev See {IERC165-supportsInterface}.
1437      */
1438     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1439         return
1440             interfaceId == type(IERC721).interfaceId ||
1441             interfaceId == type(IERC721Metadata).interfaceId ||
1442             interfaceId == type(IERC721Enumerable).interfaceId ||
1443             super.supportsInterface(interfaceId);
1444     }
1445 
1446     /**
1447      * @dev See {IERC721-balanceOf}.
1448      */
1449     function balanceOf(address owner) public view override returns (uint256) {
1450         require(owner != address(0), 'ERC721A: balance query for the zero address');
1451         return uint256(_addressData[owner].balance);
1452     }
1453 
1454     function _numberMinted(address owner) internal view returns (uint256) {
1455         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1456         return uint256(_addressData[owner].numberMinted);
1457     }
1458 
1459     /**
1460      * Gas spent here starts off proportional to the maximum mint batch size.
1461      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1462      */
1463     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1464         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1465 
1466         unchecked {
1467             for (uint256 curr = tokenId; curr >= 0; curr--) {
1468                 TokenOwnership memory ownership = _ownerships[curr];
1469                 if (ownership.addr != address(0)) {
1470                     return ownership;
1471                 }
1472             }
1473         }
1474 
1475         revert('ERC721A: unable to determine the owner of token');
1476     }
1477 
1478     /**
1479      * @dev See {IERC721-ownerOf}.
1480      */
1481     function ownerOf(uint256 tokenId) public view override returns (address) {
1482         return ownershipOf(tokenId).addr;
1483     }
1484 
1485     /**
1486      * @dev See {IERC721Metadata-name}.
1487      */
1488     function name() public view virtual override returns (string memory) {
1489         return _name;
1490     }
1491 
1492     /**
1493      * @dev See {IERC721Metadata-symbol}.
1494      */
1495     function symbol() public view virtual override returns (string memory) {
1496         return _symbol;
1497     }
1498 
1499     /**
1500      * @dev See {IERC721Metadata-tokenURI}.
1501      */
1502     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1503         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1504 
1505         string memory baseURI = _baseURI();
1506         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1507     }
1508 
1509     /**
1510      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1511      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1512      * by default, can be overriden in child contracts.
1513      */
1514     function _baseURI() internal view virtual returns (string memory) {
1515         return '';
1516     }
1517 
1518     /**
1519      * @dev See {IERC721-approve}.
1520      */
1521     function approve(address to, uint256 tokenId) public override {
1522         address owner = ERC721A.ownerOf(tokenId);
1523         require(to != owner, 'ERC721A: approval to current owner');
1524 
1525         require(
1526             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1527             'ERC721A: approve caller is not owner nor approved for all'
1528         );
1529 
1530         _approve(to, tokenId, owner);
1531     }
1532 
1533     /**
1534      * @dev See {IERC721-getApproved}.
1535      */
1536     function getApproved(uint256 tokenId) public view override returns (address) {
1537         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1538 
1539         return _tokenApprovals[tokenId];
1540     }
1541 
1542     /**
1543      * @dev See {IERC721-setApprovalForAll}.
1544      */
1545     function setApprovalForAll(address operator, bool approved) public override {
1546         require(operator != _msgSender(), 'ERC721A: approve to caller');
1547 
1548         _operatorApprovals[_msgSender()][operator] = approved;
1549         emit ApprovalForAll(_msgSender(), operator, approved);
1550     }
1551 
1552     /**
1553      * @dev See {IERC721-isApprovedForAll}.
1554      */
1555     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1556         return _operatorApprovals[owner][operator];
1557     }
1558 
1559     /**
1560      * @dev See {IERC721-transferFrom}.
1561      */
1562     function transferFrom(
1563         address from,
1564         address to,
1565         uint256 tokenId
1566     ) public override {
1567         _transfer(from, to, tokenId);
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-safeTransferFrom}.
1572      */
1573     function safeTransferFrom(
1574         address from,
1575         address to,
1576         uint256 tokenId
1577     ) public override {
1578         safeTransferFrom(from, to, tokenId, '');
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-safeTransferFrom}.
1583      */
1584     function safeTransferFrom(
1585         address from,
1586         address to,
1587         uint256 tokenId,
1588         bytes memory _data
1589     ) public override {
1590         _transfer(from, to, tokenId);
1591         require(
1592             _checkOnERC721Received(from, to, tokenId, _data),
1593             'ERC721A: transfer to non ERC721Receiver implementer'
1594         );
1595     }
1596 
1597     /**
1598      * @dev Returns whether `tokenId` exists.
1599      *
1600      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1601      *
1602      * Tokens start existing when they are minted (`_mint`),
1603      */
1604     function _exists(uint256 tokenId) internal view returns (bool) {
1605         return tokenId < currentIndex;
1606     }
1607 
1608     function _safeMint(address to, uint256 quantity) internal {
1609         _safeMint(to, quantity, '');
1610     }
1611 
1612     /**
1613      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1614      *
1615      * Requirements:
1616      *
1617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1618      * - `quantity` must be greater than 0.
1619      *
1620      * Emits a {Transfer} event.
1621      */
1622     function _safeMint(
1623         address to,
1624         uint256 quantity,
1625         bytes memory _data
1626     ) internal {
1627         _mint(to, quantity, _data, true);
1628     }
1629 
1630     /**
1631      * @dev Mints `quantity` tokens and transfers them to `to`.
1632      *
1633      * Requirements:
1634      *
1635      * - `to` cannot be the zero address.
1636      * - `quantity` must be greater than 0.
1637      *
1638      * Emits a {Transfer} event.
1639      */
1640     function _mint(
1641         address to,
1642         uint256 quantity,
1643         bytes memory _data,
1644         bool safe
1645     ) internal {
1646         uint256 startTokenId = currentIndex;
1647         require(to != address(0), 'ERC721A: mint to the zero address');
1648         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1649 
1650         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1651 
1652         // Overflows are incredibly unrealistic.
1653         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1654         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1655         unchecked {
1656             _addressData[to].balance += uint128(quantity);
1657             _addressData[to].numberMinted += uint128(quantity);
1658 
1659             _ownerships[startTokenId].addr = to;
1660             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1661 
1662             uint256 updatedIndex = startTokenId;
1663 
1664             for (uint256 i; i < quantity; i++) {
1665                 emit Transfer(address(0), to, updatedIndex);
1666                 if (safe) {
1667                     require(
1668                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1669                         'ERC721A: transfer to non ERC721Receiver implementer'
1670                     );
1671                 }
1672 
1673                 updatedIndex++;
1674             }
1675 
1676             currentIndex = updatedIndex;
1677         }
1678 
1679         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1680     }
1681 
1682     /**
1683      * @dev Transfers `tokenId` from `from` to `to`.
1684      *
1685      * Requirements:
1686      *
1687      * - `to` cannot be the zero address.
1688      * - `tokenId` token must be owned by `from`.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _transfer(
1693         address from,
1694         address to,
1695         uint256 tokenId
1696     ) private {
1697         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1698 
1699         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1700             getApproved(tokenId) == _msgSender() ||
1701             isApprovedForAll(prevOwnership.addr, _msgSender()));
1702 
1703         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1704 
1705         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1706         require(to != address(0), 'ERC721A: transfer to the zero address');
1707 
1708         _beforeTokenTransfers(from, to, tokenId, 1);
1709 
1710         // Clear approvals from the previous owner
1711         _approve(address(0), tokenId, prevOwnership.addr);
1712 
1713         // Underflow of the sender's balance is impossible because we check for
1714         // ownership above and the recipient's balance can't realistically overflow.
1715         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1716         unchecked {
1717             _addressData[from].balance -= 1;
1718             _addressData[to].balance += 1;
1719 
1720             _ownerships[tokenId].addr = to;
1721             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1722 
1723             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1724             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1725             uint256 nextTokenId = tokenId + 1;
1726             if (_ownerships[nextTokenId].addr == address(0)) {
1727                 if (_exists(nextTokenId)) {
1728                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1729                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1730                 }
1731             }
1732         }
1733 
1734         emit Transfer(from, to, tokenId);
1735         _afterTokenTransfers(from, to, tokenId, 1);
1736     }
1737 
1738     /**
1739      * @dev Approve `to` to operate on `tokenId`
1740      *
1741      * Emits a {Approval} event.
1742      */
1743     function _approve(
1744         address to,
1745         uint256 tokenId,
1746         address owner
1747     ) private {
1748         _tokenApprovals[tokenId] = to;
1749         emit Approval(owner, to, tokenId);
1750     }
1751 
1752     /**
1753      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1754      * The call is not executed if the target address is not a contract.
1755      *
1756      * @param from address representing the previous owner of the given token ID
1757      * @param to target address that will receive the tokens
1758      * @param tokenId uint256 ID of the token to be transferred
1759      * @param _data bytes optional data to send along with the call
1760      * @return bool whether the call correctly returned the expected magic value
1761      */
1762     function _checkOnERC721Received(
1763         address from,
1764         address to,
1765         uint256 tokenId,
1766         bytes memory _data
1767     ) private returns (bool) {
1768         if (to.isContract()) {
1769             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1770                 return retval == IERC721Receiver(to).onERC721Received.selector;
1771             } catch (bytes memory reason) {
1772                 if (reason.length == 0) {
1773                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1774                 } else {
1775                     assembly {
1776                         revert(add(32, reason), mload(reason))
1777                     }
1778                 }
1779             }
1780         } else {
1781             return true;
1782         }
1783     }
1784 
1785     /**
1786      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1787      *
1788      * startTokenId - the first token id to be transferred
1789      * quantity - the amount to be transferred
1790      *
1791      * Calling conditions:
1792      *
1793      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1794      * transferred to `to`.
1795      * - When `from` is zero, `tokenId` will be minted for `to`.
1796      */
1797     function _beforeTokenTransfers(
1798         address from,
1799         address to,
1800         uint256 startTokenId,
1801         uint256 quantity
1802     ) internal virtual {}
1803 
1804     /**
1805      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1806      * minting.
1807      *
1808      * startTokenId - the first token id to be transferred
1809      * quantity - the amount to be transferred
1810      *
1811      * Calling conditions:
1812      *
1813      * - when `from` and `to` are both non-zero.
1814      * - `from` and `to` are never both zero.
1815      */
1816     function _afterTokenTransfers(
1817         address from,
1818         address to,
1819         uint256 startTokenId,
1820         uint256 quantity
1821     ) internal virtual {}
1822 }
1823 
1824 // FILE 14: OkayDuckAzukis.sol
1825 
1826 pragma solidity ^0.8.0;
1827 
1828 contract OkayDuckAzukis is ERC721A, Ownable {
1829   using Strings for uint256;
1830   using Counters for Counters.Counter;
1831 
1832   string private uriPrefix = "";
1833   string public uriSuffix = ".json";
1834   string private hiddenMetadataUri;
1835 
1836     constructor() ERC721A("OkayDuckAzukis", "OKDAZUKI") {
1837         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1838     }
1839 
1840     uint256 public constant maxSupply = 9999;
1841     uint256 private mintCount = 0;
1842     uint256 public maxMintPerTx = 3;
1843     uint256 public maxMintPerWallet = 3;   
1844     uint256 public price = 0.0099 ether;
1845      
1846   bool public paused = true;
1847   bool public revealed = true;
1848   bool public dynamicCost = true;
1849 
1850   mapping (address => uint256) public addressMintedBalance;
1851   event Minted(uint256 totalMinted);
1852      
1853     function totalSupply() public view override returns (uint256) {
1854         return mintCount;
1855     }
1856 
1857     function changePrice(uint256 _newPrice) external onlyOwner {
1858         price = _newPrice;
1859     }
1860 
1861     function withdraw() external onlyOwner {
1862         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1863         require(success, "Transfer failed.");
1864     }
1865 
1866     function needToUpdateCost(uint256 _supply) internal pure returns (uint256 _cost){
1867         if(_supply < 1000) {
1868             return 0 ether;
1869         }
1870         if(_supply <= maxSupply) {
1871             return 0.0099 ether;
1872         }
1873     }
1874 
1875     // dynamic mint
1876     function mint(uint256 _mintAmount) public payable {
1877     uint256 supply = totalSupply();
1878     require(!paused, "The contract is paused!");
1879     require(_mintAmount > 0, "Minimum 1 NFT has to be minted per transaction");
1880     require(supply + _mintAmount <= maxSupply, "Exceeds maximum supply");
1881 
1882     if (msg.sender != owner()) {
1883         require(_mintAmount <= maxMintPerTx, "max per tx exceeded!");
1884 
1885         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1886         require (ownerMintedCount + _mintAmount <= maxMintPerWallet, "max per address exceeded!");
1887 
1888         if(dynamicCost == true) {
1889             require(msg.value >= needToUpdateCost(supply) * _mintAmount, "Not enough funds");
1890         }
1891 
1892         if(dynamicCost == false) {
1893             require(msg.value >= price * _mintAmount, "Not enough funds");
1894         }
1895     }
1896  
1897     mintCount += _mintAmount;
1898     addressMintedBalance[msg.sender]+= _mintAmount;      
1899     _safeMint(msg.sender, _mintAmount);
1900     emit Minted(_mintAmount);
1901   }
1902 
1903     function walletOfOwner(address _owner)
1904         public
1905         view
1906         returns (uint256[] memory)
1907     {
1908         uint256 ownerTokenCount = balanceOf(_owner);
1909         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1910         uint256 currentTokenId = 1;
1911         uint256 ownedTokenIndex = 0;
1912 
1913         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1914         address currentTokenOwner = ownerOf(currentTokenId);
1915             if (currentTokenOwner == _owner) {
1916                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1917                 ownedTokenIndex++;
1918             }
1919         currentTokenId++;
1920         }
1921         return ownedTokenIds;
1922     }
1923   
1924   function tokenURI(uint256 _tokenId)
1925     public
1926     view
1927     virtual
1928     override
1929     returns (string memory)
1930   {
1931     require(
1932       _exists(_tokenId),
1933       "ERC721Metadata: URI query for nonexistent token"
1934     );
1935     if (revealed == false) {
1936       return hiddenMetadataUri;
1937     }
1938     string memory currentBaseURI = _baseURI();
1939     return bytes(currentBaseURI).length > 0
1940         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1941         : "";
1942   }
1943 
1944   function setRevealed(bool _state) public onlyOwner {
1945     revealed = _state;
1946   }  
1947 
1948   function setMaxMintPerTx(uint256 _maxMintPerTx) public onlyOwner {
1949     maxMintPerTx = _maxMintPerTx;
1950   }
1951 
1952   function setMaxMintPerWallet(uint256 _maxMintPerWallet) public onlyOwner {
1953     maxMintPerWallet = _maxMintPerWallet;
1954   }  
1955 
1956   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1957     hiddenMetadataUri = _hiddenMetadataUri;
1958   }  
1959 
1960   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1961     uriPrefix = _uriPrefix;
1962   }  
1963 
1964   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1965     uriSuffix = _uriSuffix;
1966   }
1967 
1968   function setPaused(bool _state) public onlyOwner {
1969     paused = _state;
1970   }
1971 
1972   function setdynamicCost(bool _state) public onlyOwner {
1973         dynamicCost = _state;
1974     }
1975 
1976     function _baseURI() internal view virtual override returns (string memory) {
1977         return uriPrefix;
1978     }
1979 }