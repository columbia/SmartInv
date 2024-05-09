1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.2;
3 
4 
5 // File: contracts/utils/Counters.sol
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 
47 // File: contracts/utils/Strings.sol
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
112 
113 // File: contracts/utils/Context.sol
114 
115 /**
116  * @dev Provides information about the current execution context, including the
117  * sender of the transaction and its data. While these are generally available
118  * via msg.sender and msg.data, they should not be accessed in such a direct
119  * manner, since when dealing with meta-transactions the account sending and
120  * paying for execution may not be the actual sender (as far as an application
121  * is concerned).
122  *
123  * This contract is only required for intermediate, library-like contracts.
124  */
125 abstract contract Context {
126     function _msgSender() internal view virtual returns (address) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view virtual returns (bytes calldata) {
131         return msg.data;
132     }
133 }
134 
135 
136 // File: contracts/access/Ownable.sol
137 
138 /**
139  * @dev Contract module which provides a basic access control mechanism, where
140  * there is an account (an owner) that can be granted exclusive access to
141  * specific functions.
142  *
143  * By default, the owner account will be the one that deploys the contract. This
144  * can later be changed with {transferOwnership}.
145  *
146  * This module is used through inheritance. It will make available the modifier
147  * `onlyOwner`, which can be applied to your functions to restrict their use to
148  * the owner.
149  */
150 abstract contract Ownable is Context {
151     address private _owner;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     /**
156      * @dev Initializes the contract setting the deployer as the initial owner.
157      */
158     constructor() {
159         _setOwner(_msgSender());
160     }
161 
162     /**
163      * @dev Returns the address of the current owner.
164      */
165     function owner() public view virtual returns (address) {
166         return _owner;
167     }
168 
169     /**
170      * @dev Throws if called by any account other than the owner.
171      */
172     modifier onlyOwner() {
173         require(owner() == _msgSender(), "Ownable: caller is not the owner");
174         _;
175     }
176 
177     /**
178      * @dev Leaves the contract without owner. It will not be possible to call
179      * `onlyOwner` functions anymore. Can only be called by the current owner.
180      *
181      * NOTE: Renouncing ownership will leave the contract without an owner,
182      * thereby removing any functionality that is only available to the owner.
183      */
184     function renounceOwnership() public virtual onlyOwner {
185         _setOwner(address(0));
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Can only be called by the current owner.
191      */
192     function transferOwnership(address newOwner) public virtual onlyOwner {
193         require(newOwner != address(0), "Ownable: new owner is the zero address");
194         _setOwner(newOwner);
195     }
196 
197     function _setOwner(address newOwner) private {
198         address oldOwner = _owner;
199         _owner = newOwner;
200         emit OwnershipTransferred(oldOwner, newOwner);
201     }
202 }
203 
204 
205 // File: contracts/utils/Address.sol
206 
207 /**
208  * @dev Collection of functions related to the address type
209  */
210 library Address {
211     /**
212      * @dev Returns true if `account` is a contract.
213      *
214      * [IMPORTANT]
215      * ====
216      * It is unsafe to assume that an address for which this function returns
217      * false is an externally-owned account (EOA) and not a contract.
218      *
219      * Among others, `isContract` will return false for the following
220      * types of addresses:
221      *
222      *  - an externally-owned account
223      *  - a contract in construction
224      *  - an address where a contract will be created
225      *  - an address where a contract lived, but was destroyed
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize, which returns 0 for contracts in
230         // construction, since the code is only stored at the end of the
231         // constructor execution.
232 
233         uint256 size;
234         assembly {
235             size := extcodesize(account)
236         }
237         return size > 0;
238     }
239 
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         (bool success, ) = recipient.call{value: amount}("");
260         require(success, "Address: unable to send value, recipient may have reverted");
261     }
262 
263     /**
264      * @dev Performs a Solidity function call using a low level `call`. A
265      * plain `call` is an unsafe replacement for a function call: use this
266      * function instead.
267      *
268      * If `target` reverts with a revert reason, it is bubbled up by this
269      * function (like regular Solidity function calls).
270      *
271      * Returns the raw returned data. To convert to the expected return value,
272      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
273      *
274      * Requirements:
275      *
276      * - `target` must be a contract.
277      * - calling `target` with `data` must not revert.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionCall(target, data, "Address: low-level call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
287      * `errorMessage` as a fallback revert reason when `target` reverts.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, 0, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but also transferring `value` wei to `target`.
302      *
303      * Requirements:
304      *
305      * - the calling contract must have an ETH balance of at least `value`.
306      * - the called Solidity function must be `payable`.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value
314     ) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
320      * with `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         require(address(this).balance >= value, "Address: insufficient balance for call");
331         require(isContract(target), "Address: call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.call{value: value}(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
344         return functionStaticCall(target, data, "Address: low-level static call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal view returns (bytes memory) {
358         require(isContract(target), "Address: static call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.staticcall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(isContract(target), "Address: delegate call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.delegatecall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
393      * revert reason using the provided one.
394      *
395      * _Available since v4.3._
396      */
397     function verifyCallResult(
398         bool success,
399         bytes memory returndata,
400         string memory errorMessage
401     ) internal pure returns (bytes memory) {
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408 
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 
421 // File: contracts/token/ERC721/IERC721Receiver.sol
422 
423 /**
424  * @title ERC721 token receiver interface
425  * @dev Interface for any contract that wants to support safeTransfers
426  * from ERC721 asset contracts.
427  */
428 interface IERC721Receiver {
429     /**
430      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
431      * by `operator` from `from`, this function is called.
432      *
433      * It must return its Solidity selector to confirm the token transfer.
434      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
435      *
436      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
437      */
438     function onERC721Received(
439         address operator,
440         address from,
441         uint256 tokenId,
442         bytes calldata data
443     ) external returns (bytes4);
444 }
445 
446 
447 // File: contracts/utils/introspection/IERC165.sol
448 
449 /**
450  * @dev Interface of the ERC165 standard, as defined in the
451  * https://eips.ethereum.org/EIPS/eip-165[EIP].
452  *
453  * Implementers can declare support of contract interfaces, which can then be
454  * queried by others ({ERC165Checker}).
455  *
456  * For an implementation, see {ERC165}.
457  */
458 interface IERC165 {
459     /**
460      * @dev Returns true if this contract implements the interface defined by
461      * `interfaceId`. See the corresponding
462      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
463      * to learn more about how these ids are created.
464      *
465      * This function call must use less than 30 000 gas.
466      */
467     function supportsInterface(bytes4 interfaceId) external view returns (bool);
468 }
469 
470 
471 // File: contracts/utils/introspection/ERC165.sol
472 
473 /**
474  * @dev Implementation of the {IERC165} interface.
475  *
476  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
477  * for the additional interface id that will be supported. For example:
478  *
479  * ```solidity
480  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
482  * }
483  * ```
484  *
485  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
486  */
487 abstract contract ERC165 is IERC165 {
488     /**
489      * @dev See {IERC165-supportsInterface}.
490      */
491     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
492         return interfaceId == type(IERC165).interfaceId;
493     }
494 }
495 
496 
497 // File: contracts/token/ERC721/IERC721.sol
498 
499 /**
500  * @dev Required interface of an ERC721 compliant contract.
501  */
502 interface IERC721 is IERC165 {
503     /**
504      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
505      */
506     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
510      */
511     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
515      */
516     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
517 
518     /**
519      * @dev Returns the number of tokens in ``owner``'s account.
520      */
521     function balanceOf(address owner) external view returns (uint256 balance);
522 
523     /**
524      * @dev Returns the owner of the `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function ownerOf(uint256 tokenId) external view returns (address owner);
531 
532     /**
533      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
534      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must exist and be owned by `from`.
541      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
543      *
544      * Emits a {Transfer} event.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) external;
551 
552     /**
553      * @dev Transfers `tokenId` token from `from` to `to`.
554      *
555      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must be owned by `from`.
562      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
563      *
564      * Emits a {Transfer} event.
565      */
566     function transferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
574      * The approval is cleared when the token is transferred.
575      *
576      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
577      *
578      * Requirements:
579      *
580      * - The caller must own the token or be an approved operator.
581      * - `tokenId` must exist.
582      *
583      * Emits an {Approval} event.
584      */
585     function approve(address to, uint256 tokenId) external;
586 
587     /**
588      * @dev Returns the account approved for `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function getApproved(uint256 tokenId) external view returns (address operator);
595 
596     /**
597      * @dev Approve or remove `operator` as an operator for the caller.
598      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
599      *
600      * Requirements:
601      *
602      * - The `operator` cannot be the caller.
603      *
604      * Emits an {ApprovalForAll} event.
605      */
606     function setApprovalForAll(address operator, bool _approved) external;
607 
608     /**
609      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
610      *
611      * See {setApprovalForAll}
612      */
613     function isApprovedForAll(address owner, address operator) external view returns (bool);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
634 }
635 
636 
637 // File: contracts/token/ERC721/extensions/IERC721Metadata.sol
638 
639 /**
640  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
641  * @dev See https://eips.ethereum.org/EIPS/eip-721
642  */
643 interface IERC721Metadata is IERC721 {
644     /**
645      * @dev Returns the token collection name.
646      */
647     function name() external view returns (string memory);
648 
649     /**
650      * @dev Returns the token collection symbol.
651      */
652     function symbol() external view returns (string memory);
653 
654     /**
655      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
656      */
657     function tokenURI(uint256 tokenId) external view returns (string memory);
658 }
659 
660 
661 // File: contracts/token/ERC721/ERC721.sol
662 
663 /**
664  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
665  * the Metadata extension, but not including the Enumerable extension, which is available separately as
666  * {ERC721Enumerable}.
667  */
668 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
669     using Address for address;
670     using Strings for uint256;
671 
672     // Token name
673     string private _name;
674 
675     // Token symbol
676     string private _symbol;
677 
678     // Mapping from token ID to owner address
679     mapping(uint256 => address) private _owners;
680 
681     // Mapping owner address to token count
682     mapping(address => uint256) private _balances;
683 
684     // Mapping from token ID to approved address
685     mapping(uint256 => address) private _tokenApprovals;
686 
687     // Mapping from owner to operator approvals
688     mapping(address => mapping(address => bool)) private _operatorApprovals;
689 
690     /**
691      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
692      */
693     constructor(string memory name_, string memory symbol_) {
694         _name = name_;
695         _symbol = symbol_;
696     }
697 
698     /**
699      * @dev See {IERC165-supportsInterface}.
700      */
701     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
702         return
703             interfaceId == type(IERC721).interfaceId ||
704             interfaceId == type(IERC721Metadata).interfaceId ||
705             super.supportsInterface(interfaceId);
706     }
707 
708     /**
709      * @dev See {IERC721-balanceOf}.
710      */
711     function balanceOf(address owner) public view virtual override returns (uint256) {
712         require(owner != address(0), "ERC721: balance query for the zero address");
713         return _balances[owner];
714     }
715 
716     /**
717      * @dev See {IERC721-ownerOf}.
718      */
719     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
720         address owner = _owners[tokenId];
721         require(owner != address(0), "ERC721: owner query for nonexistent token");
722         return owner;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-name}.
727      */
728     function name() public view virtual override returns (string memory) {
729         return _name;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-symbol}.
734      */
735     function symbol() public view virtual override returns (string memory) {
736         return _symbol;
737     }
738 
739     /**
740      * @dev See {IERC721Metadata-tokenURI}.
741      */
742     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
743         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
744 
745         string memory baseURI = _baseURI();
746         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
747     }
748 
749     /**
750      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
751      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
752      * by default, can be overriden in child contracts.
753      */
754     function _baseURI() internal view virtual returns (string memory) {
755         return "";
756     }
757 
758     /**
759      * @dev See {IERC721-approve}.
760      */
761     function approve(address to, uint256 tokenId) public virtual override {
762         address owner = ERC721.ownerOf(tokenId);
763         require(to != owner, "ERC721: approval to current owner");
764 
765         require(
766             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
767             "ERC721: approve caller is not owner nor approved for all"
768         );
769 
770         _approve(to, tokenId);
771     }
772 
773     /**
774      * @dev See {IERC721-getApproved}.
775      */
776     function getApproved(uint256 tokenId) public view virtual override returns (address) {
777         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
778 
779         return _tokenApprovals[tokenId];
780     }
781 
782     /**
783      * @dev See {IERC721-setApprovalForAll}.
784      */
785     function setApprovalForAll(address operator, bool approved) public virtual override {
786         require(operator != _msgSender(), "ERC721: approve to caller");
787 
788         _operatorApprovals[_msgSender()][operator] = approved;
789         emit ApprovalForAll(_msgSender(), operator, approved);
790     }
791 
792     /**
793      * @dev See {IERC721-isApprovedForAll}.
794      */
795     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
796         return _operatorApprovals[owner][operator];
797     }
798 
799     /**
800      * @dev See {IERC721-transferFrom}.
801      */
802     function transferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) public virtual override {
807         //solhint-disable-next-line max-line-length
808         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
809 
810         _transfer(from, to, tokenId);
811     }
812 
813     /**
814      * @dev See {IERC721-safeTransferFrom}.
815      */
816     function safeTransferFrom(
817         address from,
818         address to,
819         uint256 tokenId
820     ) public virtual override {
821         safeTransferFrom(from, to, tokenId, "");
822     }
823 
824     /**
825      * @dev See {IERC721-safeTransferFrom}.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId,
831         bytes memory _data
832     ) public virtual override {
833         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
834         _safeTransfer(from, to, tokenId, _data);
835     }
836 
837     /**
838      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
839      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
840      *
841      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
842      *
843      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
844      * implement alternative mechanisms to perform token transfer, such as signature-based.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must exist and be owned by `from`.
851      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _safeTransfer(
856         address from,
857         address to,
858         uint256 tokenId,
859         bytes memory _data
860     ) internal virtual {
861         _transfer(from, to, tokenId);
862         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
863     }
864 
865     /**
866      * @dev Returns whether `tokenId` exists.
867      *
868      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
869      *
870      * Tokens start existing when they are minted (`_mint`),
871      * and stop existing when they are burned (`_burn`).
872      */
873     function _exists(uint256 tokenId) internal view virtual returns (bool) {
874         return _owners[tokenId] != address(0);
875     }
876 
877     /**
878      * @dev Returns whether `spender` is allowed to manage `tokenId`.
879      *
880      * Requirements:
881      *
882      * - `tokenId` must exist.
883      */
884     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
885         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
886         address owner = ERC721.ownerOf(tokenId);
887         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
888     }
889 
890     /**
891      * @dev Safely mints `tokenId` and transfers it to `to`.
892      *
893      * Requirements:
894      *
895      * - `tokenId` must not exist.
896      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _safeMint(address to, uint256 tokenId) internal virtual {
901         _safeMint(to, tokenId, "");
902     }
903 
904     /**
905      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
906      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
907      */
908     function _safeMint(
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) internal virtual {
913         _mint(to, tokenId);
914         require(
915             _checkOnERC721Received(address(0), to, tokenId, _data),
916             "ERC721: transfer to non ERC721Receiver implementer"
917         );
918     }
919 
920     /**
921      * @dev Mints `tokenId` and transfers it to `to`.
922      *
923      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
924      *
925      * Requirements:
926      *
927      * - `tokenId` must not exist.
928      * - `to` cannot be the zero address.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _mint(address to, uint256 tokenId) internal virtual {
933         require(to != address(0), "ERC721: mint to the zero address");
934         require(!_exists(tokenId), "ERC721: token already minted");
935 
936         _beforeTokenTransfer(address(0), to, tokenId);
937 
938         _balances[to] += 1;
939         _owners[tokenId] = to;
940 
941         emit Transfer(address(0), to, tokenId);
942     }
943 
944     /**
945      * @dev Destroys `tokenId`.
946      * The approval is cleared when the token is burned.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _burn(uint256 tokenId) internal virtual {
955         address owner = ERC721.ownerOf(tokenId);
956 
957         _beforeTokenTransfer(owner, address(0), tokenId);
958 
959         // Clear approvals
960         _approve(address(0), tokenId);
961 
962         _balances[owner] -= 1;
963         delete _owners[tokenId];
964 
965         emit Transfer(owner, address(0), tokenId);
966     }
967 
968     /**
969      * @dev Transfers `tokenId` from `from` to `to`.
970      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
971      *
972      * Requirements:
973      *
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must be owned by `from`.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _transfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {
984         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
985         require(to != address(0), "ERC721: transfer to the zero address");
986 
987         _beforeTokenTransfer(from, to, tokenId);
988 
989         // Clear approvals from the previous owner
990         _approve(address(0), tokenId);
991 
992         _balances[from] -= 1;
993         _balances[to] += 1;
994         _owners[tokenId] = to;
995 
996         emit Transfer(from, to, tokenId);
997     }
998 
999     /**
1000      * @dev Approve `to` to operate on `tokenId`
1001      *
1002      * Emits a {Approval} event.
1003      */
1004     function _approve(address to, uint256 tokenId) internal virtual {
1005         _tokenApprovals[tokenId] = to;
1006         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1011      * The call is not executed if the target address is not a contract.
1012      *
1013      * @param from address representing the previous owner of the given token ID
1014      * @param to target address that will receive the tokens
1015      * @param tokenId uint256 ID of the token to be transferred
1016      * @param _data bytes optional data to send along with the call
1017      * @return bool whether the call correctly returned the expected magic value
1018      */
1019     function _checkOnERC721Received(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) private returns (bool) {
1025         if (to.isContract()) {
1026             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1027                 return retval == IERC721Receiver.onERC721Received.selector;
1028             } catch (bytes memory reason) {
1029                 if (reason.length == 0) {
1030                     revert("ERC721: transfer to non ERC721Receiver implementer");
1031                 } else {
1032                     assembly {
1033                         revert(add(32, reason), mload(reason))
1034                     }
1035                 }
1036             }
1037         } else {
1038             return true;
1039         }
1040     }
1041 
1042     /**
1043      * @dev Hook that is called before any token transfer. This includes minting
1044      * and burning.
1045      *
1046      * Calling conditions:
1047      *
1048      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1049      * transferred to `to`.
1050      * - When `from` is zero, `tokenId` will be minted for `to`.
1051      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1052      * - `from` and `to` are never both zero.
1053      *
1054      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1055      */
1056     function _beforeTokenTransfer(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) internal virtual {}
1061 }
1062 
1063 
1064 // File: contracts/token/ERC721/extensions/ERC721URIStorage.sol
1065 
1066 /**
1067  * @dev ERC721 token with storage based token URI management.
1068  */
1069 abstract contract ERC721URIStorage is ERC721 {
1070     using Strings for uint256;
1071 
1072     // Optional mapping for token URIs
1073     mapping(uint256 => string) private _tokenURIs;
1074 
1075     /**
1076      * @dev See {IERC721Metadata-tokenURI}.
1077      */
1078     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1079         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1080 
1081         string memory _tokenURI = _tokenURIs[tokenId];
1082         string memory base = _baseURI();
1083 
1084         // If there is no base URI, return the token URI.
1085         if (bytes(base).length == 0) {
1086             return _tokenURI;
1087         }
1088         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1089         if (bytes(_tokenURI).length > 0) {
1090             return string(abi.encodePacked(base, _tokenURI));
1091         }
1092 
1093         return super.tokenURI(tokenId);
1094     }
1095 
1096     /**
1097      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      */
1103     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1104         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1105         _tokenURIs[tokenId] = _tokenURI;
1106     }
1107 
1108     /**
1109      * @dev Destroys `tokenId`.
1110      * The approval is cleared when the token is burned.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must exist.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _burn(uint256 tokenId) internal virtual override {
1119         super._burn(tokenId);
1120 
1121         if (bytes(_tokenURIs[tokenId]).length != 0) {
1122             delete _tokenURIs[tokenId];
1123         }
1124     }
1125 }
1126 
1127 
1128 // File: contracts/munie.sol
1129 // Munie contract
1130 
1131 contract Munie is ERC721, ERC721URIStorage, Ownable {
1132     using Counters for Counters.Counter;
1133 
1134     Counters.Counter private _tokenIdCounter;
1135     mapping(string => uint8) hashes;
1136     
1137     constructor() ERC721("Munie", "MNI") {}
1138 
1139     function mintItem(address recipient, string memory hash, string memory metadata)
1140         public
1141         onlyOwner
1142         returns (uint256)
1143     {
1144         require(hashes[hash] != 1);
1145         hashes[hash] = 1;
1146         _tokenIdCounter.increment();
1147         uint256 newItemId = _tokenIdCounter.current();
1148         _mint(recipient, newItemId);
1149         _setTokenURI(newItemId, metadata);
1150         return newItemId;
1151     }
1152 
1153     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1154         super._burn(tokenId);
1155     }
1156 
1157     function tokenURI(uint256 tokenId)
1158         public
1159         view
1160         override(ERC721, ERC721URIStorage)
1161         returns (string memory)
1162     {
1163         return super.tokenURI(tokenId);
1164     }
1165 }