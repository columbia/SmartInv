1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 pragma solidity ^0.8.0;
27 
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
170  * @dev See https://eips.ethereum.org/EIPS/eip-721
171  */
172 interface IERC721Enumerable is IERC721 {
173     /**
174      * @dev Returns the total amount of tokens stored by the contract.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
180      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
181      */
182     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
183 
184     /**
185      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
186      * Use along with {totalSupply} to enumerate all tokens.
187      */
188     function tokenByIndex(uint256 index) external view returns (uint256);
189 }
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721Metadata is IERC721 {
198     /**
199      * @dev Returns the token collection name.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the token collection symbol.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
210      */
211     function tokenURI(uint256 tokenId) external view returns (string memory);
212 }
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @title ERC721 token receiver interface
218  * @dev Interface for any contract that wants to support safeTransfers
219  * from ERC721 asset contracts.
220  */
221 interface IERC721Receiver {
222     /**
223      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
224      * by `operator` from `from`, this function is called.
225      *
226      * It must return its Solidity selector to confirm the token transfer.
227      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
228      *
229      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
230      */
231     function onERC721Received(
232         address operator,
233         address from,
234         uint256 tokenId,
235         bytes calldata data
236     ) external returns (bytes4);
237 }
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev String operations.
243  */
244 library Strings {
245     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
246 
247     /**
248      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
249      */
250     function toString(uint256 value) internal pure returns (string memory) {
251         // Inspired by OraclizeAPI's implementation - MIT licence
252         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
253 
254         if (value == 0) {
255             return "0";
256         }
257         uint256 temp = value;
258         uint256 digits;
259         while (temp != 0) {
260             digits++;
261             temp /= 10;
262         }
263         bytes memory buffer = new bytes(digits);
264         while (value != 0) {
265             digits -= 1;
266             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
267             value /= 10;
268         }
269         return string(buffer);
270     }
271 
272     /**
273      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
274      */
275     function toHexString(uint256 value) internal pure returns (string memory) {
276         if (value == 0) {
277             return "0x00";
278         }
279         uint256 temp = value;
280         uint256 length = 0;
281         while (temp != 0) {
282             length++;
283             temp >>= 8;
284         }
285         return toHexString(value, length);
286     }
287 
288     /**
289      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
290      */
291     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
292         bytes memory buffer = new bytes(2 * length + 2);
293         buffer[0] = "0";
294         buffer[1] = "x";
295         for (uint256 i = 2 * length + 1; i > 1; --i) {
296             buffer[i] = _HEX_SYMBOLS[value & 0xf];
297             value >>= 4;
298         }
299         require(value == 0, "Strings: hex length insufficient");
300         return string(buffer);
301     }
302 }
303 
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      */
328     function isContract(address account) internal view returns (bool) {
329         // This method relies on extcodesize, which returns 0 for contracts in
330         // construction, since the code is only stored at the end of the
331         // constructor execution.
332 
333         uint256 size;
334         assembly {
335             size := extcodesize(account)
336         }
337         return size > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         (bool success, ) = recipient.call{value: amount}("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain `call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.call{value: value}(data);
434         return _verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return _verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(isContract(target), "Address: delegate call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.delegatecall(data);
488         return _verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     function _verifyCallResult(
492         bool success,
493         bytes memory returndata,
494         string memory errorMessage
495     ) private pure returns (bytes memory) {
496         if (success) {
497             return returndata;
498         } else {
499             // Look for revert reason and bubble it up if present
500             if (returndata.length > 0) {
501                 // The easiest way to bubble the revert reason is using memory via assembly
502 
503                 assembly {
504                     let returndata_size := mload(returndata)
505                     revert(add(32, returndata), returndata_size)
506                 }
507             } else {
508                 revert(errorMessage);
509             }
510         }
511     }
512 }
513 
514 
515 pragma solidity ^0.8.0;
516 
517 /*
518  * @dev Provides information about the current execution context, including the
519  * sender of the transaction and its data. While these are generally available
520  * via msg.sender and msg.data, they should not be accessed in such a direct
521  * manner, since when dealing with meta-transactions the account sending and
522  * paying for execution may not be the actual sender (as far as an application
523  * is concerned).
524  *
525  * This contract is only required for intermediate, library-like contracts.
526  */
527 abstract contract Context {
528     function _msgSender() internal view virtual returns (address) {
529         return msg.sender;
530     }
531 
532     function _msgData() internal view virtual returns (bytes calldata) {
533         return msg.data;
534     }
535 }
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev Contract module which provides a basic access control mechanism, where
541  * there is an account (an owner) that can be granted exclusive access to
542  * specific functions.
543  *
544  * By default, the owner account will be the one that deploys the contract. This
545  * can later be changed with {transferOwnership}.
546  *
547  * This module is used through inheritance. It will make available the modifier
548  * `onlyOwner`, which can be applied to your functions to restrict their use to
549  * the owner.
550  */
551 abstract contract Ownable is Context {
552     address private _owner;
553 
554     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
555 
556     /**
557      * @dev Initializes the contract setting the deployer as the initial owner.
558      */
559     constructor() {
560         _setOwner(_msgSender());
561     }
562 
563     /**
564      * @dev Returns the address of the current owner.
565      */
566     function owner() public view virtual returns (address) {
567         return _owner;
568     }
569 
570     /**
571      * @dev Throws if called by any account other than the owner.
572      */
573     modifier onlyOwner() {
574         require(owner() == _msgSender(), "Ownable: caller is not the owner");
575         _;
576     }
577 
578     /**
579      * @dev Leaves the contract without owner. It will not be possible to call
580      * `onlyOwner` functions anymore. Can only be called by the current owner.
581      *
582      * NOTE: Renouncing ownership will leave the contract without an owner,
583      * thereby removing any functionality that is only available to the owner.
584      */
585     function renounceOwnership() public virtual onlyOwner {
586         _setOwner(address(0));
587     }
588 
589     /**
590      * @dev Transfers ownership of the contract to a new account (`newOwner`).
591      * Can only be called by the current owner.
592      */
593     function transferOwnership(address newOwner) public virtual onlyOwner {
594         require(newOwner != address(0), "Ownable: new owner is the zero address");
595         _setOwner(newOwner);
596     }
597 
598     function _setOwner(address newOwner) private {
599         address oldOwner = _owner;
600         _owner = newOwner;
601         emit OwnershipTransferred(oldOwner, newOwner);
602     }
603 }
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Implementation of the {IERC165} interface.
609  *
610  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
611  * for the additional interface id that will be supported. For example:
612  *
613  * ```solidity
614  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
616  * }
617  * ```
618  *
619  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
620  */
621 abstract contract ERC165 is IERC165 {
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
626         return interfaceId == type(IERC165).interfaceId;
627     }
628 }
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
634  * the Metadata extension, but not including the Enumerable extension, which is available separately as
635  * {ERC721Enumerable}.
636  */
637 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
638     using Address for address;
639     using Strings for uint256;
640 
641     // Token name
642     string private _name;
643 
644     // Token symbol
645     string private _symbol;
646 
647     // Mapping from token ID to owner address
648     mapping(uint256 => address) private _owners;
649 
650     // Mapping owner address to token count
651     mapping(address => uint256) private _balances;
652 
653     // Mapping from token ID to approved address
654     mapping(uint256 => address) private _tokenApprovals;
655 
656     // Mapping from owner to operator approvals
657     mapping(address => mapping(address => bool)) private _operatorApprovals;
658 
659     /**
660      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
661      */
662     constructor(string memory name_, string memory symbol_) {
663         _name = name_;
664         _symbol = symbol_;
665     }
666 
667     /**
668      * @dev See {IERC165-supportsInterface}.
669      */
670     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
671         return
672             interfaceId == type(IERC721).interfaceId ||
673             interfaceId == type(IERC721Metadata).interfaceId ||
674             super.supportsInterface(interfaceId);
675     }
676 
677     /**
678      * @dev See {IERC721-balanceOf}.
679      */
680     function balanceOf(address owner) public view virtual override returns (uint256) {
681         require(owner != address(0), "ERC721: balance query for the zero address");
682         return _balances[owner];
683     }
684 
685     /**
686      * @dev See {IERC721-ownerOf}.
687      */
688     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
689         address owner = _owners[tokenId];
690         require(owner != address(0), "ERC721: owner query for nonexistent token");
691         return owner;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-name}.
696      */
697     function name() public view virtual override returns (string memory) {
698         return _name;
699     }
700 
701     /**
702      * @dev See {IERC721Metadata-symbol}.
703      */
704     function symbol() public view virtual override returns (string memory) {
705         return _symbol;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-tokenURI}.
710      */
711     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
712         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
713 
714         string memory baseURI = _baseURI();
715         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
716     }
717 
718     /**
719      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
720      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
721      * by default, can be overriden in child contracts.
722      */
723     function _baseURI() internal view virtual returns (string memory) {
724         return "";
725     }
726 
727     /**
728      * @dev See {IERC721-approve}.
729      */
730     function approve(address to, uint256 tokenId) public virtual override {
731         address owner = ERC721.ownerOf(tokenId);
732         require(to != owner, "ERC721: approval to current owner");
733 
734         require(
735             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
736             "ERC721: approve caller is not owner nor approved for all"
737         );
738 
739         _approve(to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-getApproved}.
744      */
745     function getApproved(uint256 tokenId) public view virtual override returns (address) {
746         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
747 
748         return _tokenApprovals[tokenId];
749     }
750 
751     /**
752      * @dev See {IERC721-setApprovalForAll}.
753      */
754     function setApprovalForAll(address operator, bool approved) public virtual override {
755         require(operator != _msgSender(), "ERC721: approve to caller");
756 
757         _operatorApprovals[_msgSender()][operator] = approved;
758         emit ApprovalForAll(_msgSender(), operator, approved);
759     }
760 
761     /**
762      * @dev See {IERC721-isApprovedForAll}.
763      */
764     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
765         return _operatorApprovals[owner][operator];
766     }
767 
768     /**
769      * @dev See {IERC721-transferFrom}.
770      */
771     function transferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) public virtual override {
776         //solhint-disable-next-line max-line-length
777         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
778 
779         _transfer(from, to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         safeTransferFrom(from, to, tokenId, "");
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) public virtual override {
802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
803         _safeTransfer(from, to, tokenId, _data);
804     }
805 
806     /**
807      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
808      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
809      *
810      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
811      *
812      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
813      * implement alternative mechanisms to perform token transfer, such as signature-based.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must exist and be owned by `from`.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _safeTransfer(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) internal virtual {
830         _transfer(from, to, tokenId);
831         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
832     }
833 
834     /**
835      * @dev Returns whether `tokenId` exists.
836      *
837      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
838      *
839      * Tokens start existing when they are minted (`_mint`),
840      * and stop existing when they are burned (`_burn`).
841      */
842     function _exists(uint256 tokenId) internal view virtual returns (bool) {
843         return _owners[tokenId] != address(0);
844     }
845 
846     /**
847      * @dev Returns whether `spender` is allowed to manage `tokenId`.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
854         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
855         address owner = ERC721.ownerOf(tokenId);
856         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
857     }
858 
859     /**
860      * @dev Safely mints `tokenId` and transfers it to `to`.
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _safeMint(address to, uint256 tokenId) internal virtual {
870         _safeMint(to, tokenId, "");
871     }
872 
873     /**
874      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
875      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
876      */
877     function _safeMint(
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) internal virtual {
882         _mint(to, tokenId);
883         require(
884             _checkOnERC721Received(address(0), to, tokenId, _data),
885             "ERC721: transfer to non ERC721Receiver implementer"
886         );
887     }
888 
889     /**
890      * @dev Mints `tokenId` and transfers it to `to`.
891      *
892      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
893      *
894      * Requirements:
895      *
896      * - `tokenId` must not exist.
897      * - `to` cannot be the zero address.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _mint(address to, uint256 tokenId) internal virtual {
902         require(to != address(0), "ERC721: mint to the zero address");
903         require(!_exists(tokenId), "ERC721: token already minted");
904 
905         _beforeTokenTransfer(address(0), to, tokenId);
906 
907         _balances[to] += 1;
908         _owners[tokenId] = to;
909 
910         emit Transfer(address(0), to, tokenId);
911     }
912 
913     /**
914      * @dev Destroys `tokenId`.
915      * The approval is cleared when the token is burned.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _burn(uint256 tokenId) internal virtual {
924         address owner = ERC721.ownerOf(tokenId);
925 
926         _beforeTokenTransfer(owner, address(0), tokenId);
927 
928         // Clear approvals
929         _approve(address(0), tokenId);
930 
931         _balances[owner] -= 1;
932         delete _owners[tokenId];
933 
934         emit Transfer(owner, address(0), tokenId);
935     }
936 
937     /**
938      * @dev Transfers `tokenId` from `from` to `to`.
939      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
940      *
941      * Requirements:
942      *
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must be owned by `from`.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _transfer(
949         address from,
950         address to,
951         uint256 tokenId
952     ) internal virtual {
953         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
954         require(to != address(0), "ERC721: transfer to the zero address");
955 
956         _beforeTokenTransfer(from, to, tokenId);
957 
958         // Clear approvals from the previous owner
959         _approve(address(0), tokenId);
960 
961         _balances[from] -= 1;
962         _balances[to] += 1;
963         _owners[tokenId] = to;
964 
965         emit Transfer(from, to, tokenId);
966     }
967 
968     /**
969      * @dev Approve `to` to operate on `tokenId`
970      *
971      * Emits a {Approval} event.
972      */
973     function _approve(address to, uint256 tokenId) internal virtual {
974         _tokenApprovals[tokenId] = to;
975         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
976     }
977 
978     /**
979      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
980      * The call is not executed if the target address is not a contract.
981      *
982      * @param from address representing the previous owner of the given token ID
983      * @param to target address that will receive the tokens
984      * @param tokenId uint256 ID of the token to be transferred
985      * @param _data bytes optional data to send along with the call
986      * @return bool whether the call correctly returned the expected magic value
987      */
988     function _checkOnERC721Received(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) private returns (bool) {
994         if (to.isContract()) {
995             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
996                 return retval == IERC721Receiver(to).onERC721Received.selector;
997             } catch (bytes memory reason) {
998                 if (reason.length == 0) {
999                     revert("ERC721: transfer to non ERC721Receiver implementer");
1000                 } else {
1001                     assembly {
1002                         revert(add(32, reason), mload(reason))
1003                     }
1004                 }
1005             }
1006         } else {
1007             return true;
1008         }
1009     }
1010 
1011     /**
1012      * @dev Hook that is called before any token transfer. This includes minting
1013      * and burning.
1014      *
1015      * Calling conditions:
1016      *
1017      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1018      * transferred to `to`.
1019      * - When `from` is zero, `tokenId` will be minted for `to`.
1020      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1021      * - `from` and `to` are never both zero.
1022      *
1023      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1024      */
1025     function _beforeTokenTransfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) internal virtual {}
1030 }
1031 
1032 
1033 pragma solidity ^0.8.0;
1034 
1035 /**
1036  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1037  * enumerability of all the token ids in the contract as well as all token ids owned by each
1038  * account.
1039  */
1040 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1041     // Mapping from owner to list of owned token IDs
1042     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1043 
1044     // Mapping from token ID to index of the owner tokens list
1045     mapping(uint256 => uint256) private _ownedTokensIndex;
1046 
1047     // Array with all token ids, used for enumeration
1048     uint256[] private _allTokens;
1049 
1050     // Mapping from token id to position in the allTokens array
1051     mapping(uint256 => uint256) private _allTokensIndex;
1052 
1053     /**
1054      * @dev See {IERC165-supportsInterface}.
1055      */
1056     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1057         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1062      */
1063     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1064         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1065         return _ownedTokens[owner][index];
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-totalSupply}.
1070      */
1071     function totalSupply() public view virtual override returns (uint256) {
1072         return _allTokens.length;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Enumerable-tokenByIndex}.
1077      */
1078     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1079         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1080         return _allTokens[index];
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before any token transfer. This includes minting
1085      * and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` will be minted for `to`.
1092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1093      * - `from` cannot be the zero address.
1094      * - `to` cannot be the zero address.
1095      *
1096      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1097      */
1098     function _beforeTokenTransfer(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) internal virtual override {
1103         super._beforeTokenTransfer(from, to, tokenId);
1104 
1105         if (from == address(0)) {
1106             _addTokenToAllTokensEnumeration(tokenId);
1107         } else if (from != to) {
1108             _removeTokenFromOwnerEnumeration(from, tokenId);
1109         }
1110         if (to == address(0)) {
1111             _removeTokenFromAllTokensEnumeration(tokenId);
1112         } else if (to != from) {
1113             _addTokenToOwnerEnumeration(to, tokenId);
1114         }
1115     }
1116 
1117     /**
1118      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1119      * @param to address representing the new owner of the given token ID
1120      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1121      */
1122     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1123         uint256 length = ERC721.balanceOf(to);
1124         _ownedTokens[to][length] = tokenId;
1125         _ownedTokensIndex[tokenId] = length;
1126     }
1127 
1128     /**
1129      * @dev Private function to add a token to this extension's token tracking data structures.
1130      * @param tokenId uint256 ID of the token to be added to the tokens list
1131      */
1132     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1133         _allTokensIndex[tokenId] = _allTokens.length;
1134         _allTokens.push(tokenId);
1135     }
1136 
1137     /**
1138      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1139      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1140      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1141      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1142      * @param from address representing the previous owner of the given token ID
1143      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1144      */
1145     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1146         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1147         // then delete the last slot (swap and pop).
1148 
1149         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1150         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1151 
1152         // When the token to delete is the last token, the swap operation is unnecessary
1153         if (tokenIndex != lastTokenIndex) {
1154             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1155 
1156             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1157             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1158         }
1159 
1160         // This also deletes the contents at the last position of the array
1161         delete _ownedTokensIndex[tokenId];
1162         delete _ownedTokens[from][lastTokenIndex];
1163     }
1164 
1165     /**
1166      * @dev Private function to remove a token from this extension's token tracking data structures.
1167      * This has O(1) time complexity, but alters the order of the _allTokens array.
1168      * @param tokenId uint256 ID of the token to be removed from the tokens list
1169      */
1170     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1171         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1172         // then delete the last slot (swap and pop).
1173 
1174         uint256 lastTokenIndex = _allTokens.length - 1;
1175         uint256 tokenIndex = _allTokensIndex[tokenId];
1176 
1177         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1178         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1179         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1180         uint256 lastTokenId = _allTokens[lastTokenIndex];
1181 
1182         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1183         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1184 
1185         // This also deletes the contents at the last position of the array
1186         delete _allTokensIndex[tokenId];
1187         _allTokens.pop();
1188     }
1189 }
1190 
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 // CAUTION
1195 // This version of SafeMath should only be used with Solidity 0.8 or later,
1196 // because it relies on the compiler's built in overflow checks.
1197 
1198 /**
1199  * @dev Wrappers over Solidity's arithmetic operations.
1200  *
1201  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1202  * now has built in overflow checking.
1203  */
1204 library SafeMath {
1205     /**
1206      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1207      *
1208      * _Available since v3.4._
1209      */
1210     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1211     unchecked {
1212         uint256 c = a + b;
1213         if (c < a) return (false, 0);
1214         return (true, c);
1215     }
1216     }
1217 
1218     /**
1219      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1220      *
1221      * _Available since v3.4._
1222      */
1223     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1224     unchecked {
1225         if (b > a) return (false, 0);
1226         return (true, a - b);
1227     }
1228     }
1229 
1230     /**
1231      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1232      *
1233      * _Available since v3.4._
1234      */
1235     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1236     unchecked {
1237         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1238         // benefit is lost if 'b' is also tested.
1239         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1240         if (a == 0) return (true, 0);
1241         uint256 c = a * b;
1242         if (c / a != b) return (false, 0);
1243         return (true, c);
1244     }
1245     }
1246 
1247     /**
1248      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1249      *
1250      * _Available since v3.4._
1251      */
1252     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1253     unchecked {
1254         if (b == 0) return (false, 0);
1255         return (true, a / b);
1256     }
1257     }
1258 
1259     /**
1260      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1261      *
1262      * _Available since v3.4._
1263      */
1264     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1265     unchecked {
1266         if (b == 0) return (false, 0);
1267         return (true, a % b);
1268     }
1269     }
1270 
1271     /**
1272      * @dev Returns the addition of two unsigned integers, reverting on
1273      * overflow.
1274      *
1275      * Counterpart to Solidity's `+` operator.
1276      *
1277      * Requirements:
1278      *
1279      * - Addition cannot overflow.
1280      */
1281     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1282         return a + b;
1283     }
1284 
1285     /**
1286      * @dev Returns the subtraction of two unsigned integers, reverting on
1287      * overflow (when the result is negative).
1288      *
1289      * Counterpart to Solidity's `-` operator.
1290      *
1291      * Requirements:
1292      *
1293      * - Subtraction cannot overflow.
1294      */
1295     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1296         return a - b;
1297     }
1298 
1299     /**
1300      * @dev Returns the multiplication of two unsigned integers, reverting on
1301      * overflow.
1302      *
1303      * Counterpart to Solidity's `*` operator.
1304      *
1305      * Requirements:
1306      *
1307      * - Multiplication cannot overflow.
1308      */
1309     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1310         return a * b;
1311     }
1312 
1313     /**
1314      * @dev Returns the integer division of two unsigned integers, reverting on
1315      * division by zero. The result is rounded towards zero.
1316      *
1317      * Counterpart to Solidity's `/` operator.
1318      *
1319      * Requirements:
1320      *
1321      * - The divisor cannot be zero.
1322      */
1323     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1324         return a / b;
1325     }
1326 
1327     /**
1328      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1329      * reverting when dividing by zero.
1330      *
1331      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1332      * opcode (which leaves remaining gas untouched) while Solidity uses an
1333      * invalid opcode to revert (consuming all remaining gas).
1334      *
1335      * Requirements:
1336      *
1337      * - The divisor cannot be zero.
1338      */
1339     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1340         return a % b;
1341     }
1342 
1343     /**
1344      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1345      * overflow (when the result is negative).
1346      *
1347      * CAUTION: This function is deprecated because it requires allocating memory for the error
1348      * message unnecessarily. For custom revert reasons use {trySub}.
1349      *
1350      * Counterpart to Solidity's `-` operator.
1351      *
1352      * Requirements:
1353      *
1354      * - Subtraction cannot overflow.
1355      */
1356     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1357     unchecked {
1358         require(b <= a, errorMessage);
1359         return a - b;
1360     }
1361     }
1362 
1363     /**
1364      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1365      * division by zero. The result is rounded towards zero.
1366      *
1367      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1368      * opcode (which leaves remaining gas untouched) while Solidity uses an
1369      * invalid opcode to revert (consuming all remaining gas).
1370      *
1371      * Counterpart to Solidity's `/` operator. Note: this function uses a
1372      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1373      * uses an invalid opcode to revert (consuming all remaining gas).
1374      *
1375      * Requirements:
1376      *
1377      * - The divisor cannot be zero.
1378      */
1379     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1380     unchecked {
1381         require(b > 0, errorMessage);
1382         return a / b;
1383     }
1384     }
1385 
1386     /**
1387      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1388      * reverting with custom message when dividing by zero.
1389      *
1390      * CAUTION: This function is deprecated because it requires allocating memory for the error
1391      * message unnecessarily. For custom revert reasons use {tryMod}.
1392      *
1393      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1394      * opcode (which leaves remaining gas untouched) while Solidity uses an
1395      * invalid opcode to revert (consuming all remaining gas).
1396      *
1397      * Requirements:
1398      *
1399      * - The divisor cannot be zero.
1400      */
1401     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1402     unchecked {
1403         require(b > 0, errorMessage);
1404         return a % b;
1405     }
1406     }
1407 }
1408 
1409 pragma solidity >=0.7.0 <0.9.0;
1410 // _________                        __          _______        ___.   .__                 
1411 // \_   ___ \_______ ___.__._______/  |_  ____  \      \   ____\_ |__ |  |   ____   ______
1412 // /    \  \/\_  __ <   |  |\____ \   __\/  _ \ /   |   \ /  _ \| __ \|  | _/ __ \ /  ___/
1413 // \     \____|  | \/\___  ||  |_> >  | (  <_> )    |    (  <_> ) \_\ \  |_\  ___/ \___ \ 
1414 //  \______  /|__|   / ____||   __/|__|  \____/\____|__  /\____/|___  /____/\___  >____  >
1415 //         \/        \/     |__|                       \/           \/          \/     \/ 
1416 contract CryptoNobles is ERC721, ERC721Enumerable, Ownable {
1417   using Strings for uint256;
1418   using SafeMath for uint256;
1419   string public baseURI;
1420   string public baseExtension = ".json";
1421   uint256 public cost = 0.06 ether;
1422   uint256 public whitelistCost = 0.04 ether;
1423   uint256 public maxSupply = 2500;
1424   uint256 public maxMintAmount = 3;
1425   uint256 public whiteListLength = 0;
1426   uint256 public maxWhitelistSpots = 500;
1427   mapping(address => bool) public whitelisted;
1428   bool public paused = true;
1429   bool public pauseWhitelistDrop = true; 
1430   bool public pauseWhitelist = false; 
1431 
1432   constructor(
1433     string memory _name,
1434     string memory _symbol,
1435     string memory _initBaseURI
1436   ) ERC721(_name, _symbol) {
1437     setBaseURI(_initBaseURI);
1438   }
1439 
1440   // internal
1441   function _baseURI() internal view virtual override returns (string memory) {
1442     return baseURI;
1443   } 
1444   
1445   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1446       super._beforeTokenTransfer(from, to, tokenId);
1447   }
1448 
1449   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1450       return super.supportsInterface(interfaceId);
1451   }
1452 
1453   // public
1454   function mint(address _to, uint256 _mintAmount) public payable {
1455     uint256 supply = totalSupply();
1456     require(!paused);
1457     require(_mintAmount > 0);
1458     require(_mintAmount <= maxMintAmount);
1459     require((cost.mul(_mintAmount)) <= msg.value);
1460     require(supply + _mintAmount <= maxSupply);
1461     require(walletOfOwner(_to).length < 3);
1462     for (uint256 i = 1; i <= _mintAmount; i++) {
1463       _safeMint(_to, supply + i);
1464     }
1465   }
1466 
1467   function mintFromWhiteList(address _to, uint256 _mintAmount) public payable {
1468     uint256 supply = totalSupply();
1469     require(!pauseWhitelistDrop);
1470     require(whitelisted[_to] != false);
1471     require(_mintAmount > 0);
1472     require(_mintAmount <= maxMintAmount);
1473     require((whitelistCost.mul(_mintAmount)) <= msg.value);
1474     require(supply + _mintAmount <= maxSupply);
1475     require(walletOfOwner(_to).length < 3);
1476     for (uint256 i = 1; i <= _mintAmount; i++) {
1477       _safeMint(_to, supply + i);
1478     }
1479   }
1480 
1481   function walletOfOwner(address _owner)
1482     public
1483     view
1484     returns (uint256[] memory)
1485   {
1486     uint256 ownerTokenCount = balanceOf(_owner);
1487     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1488     for (uint256 i; i < ownerTokenCount; i++) {
1489       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1490     }
1491     return tokenIds;
1492   }
1493 
1494   function tokenURI(uint256 tokenId)
1495     public
1496     view
1497     virtual
1498     override
1499     returns (string memory)
1500   {
1501     require(
1502       _exists(tokenId),
1503       "ERC721Metadata: URI query for nonexistent token"
1504     );
1505 
1506     string memory currentBaseURI = _baseURI();
1507     return bytes(currentBaseURI).length > 0
1508         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1509         : "";
1510   }
1511 
1512   function setCost(uint256 _newCost) public onlyOwner {
1513     cost = _newCost;
1514   }
1515 
1516   function setWhitelistCost(uint256 _newCost) public onlyOwner {
1517     whitelistCost = _newCost;
1518   }
1519 
1520   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1521     maxMintAmount = _newmaxMintAmount;
1522   }
1523    
1524    function setmaxWhitelistSpots(uint256 _newmaxWhitelistSpots) public onlyOwner {
1525     maxWhitelistSpots = _newmaxWhitelistSpots;
1526   }
1527 
1528   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1529     baseURI = _newBaseURI;
1530   }
1531 
1532   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1533     baseExtension = _newBaseExtension;
1534   }
1535 
1536   function pause(bool _state) public onlyOwner {
1537     paused = _state;
1538   }
1539 
1540   function setPauseWhitelistDrop(bool _state) public onlyOwner {
1541     pauseWhitelistDrop = _state;
1542   }
1543 
1544   function setPauseWhitelist(bool _state) public onlyOwner {
1545     pauseWhitelist = _state;
1546   }
1547 
1548   function whitelistUser() public payable {
1549     require(whiteListLength < maxWhitelistSpots);
1550     require(whitelisted[msg.sender] != true);
1551     require(!pauseWhitelist);
1552     whitelisted[msg.sender] = true;
1553     whiteListLength ++;
1554   }
1555  
1556   function removeWhitelistUser(address _user) public onlyOwner {
1557     whitelisted[_user] = false;
1558     whiteListLength --;
1559   }
1560 
1561   function withdrawAll() public payable onlyOwner {
1562       require(payable(msg.sender).send(address(this).balance));
1563   }
1564 }