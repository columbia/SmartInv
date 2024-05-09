1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.0;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Context
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address) {
209         return msg.sender;
210     }
211 
212     function _msgData() internal view virtual returns (bytes calldata) {
213         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
214         return msg.data;
215     }
216 }
217 
218 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC165
219 
220 /**
221  * @dev Interface of the ERC165 standard, as defined in the
222  * https://eips.ethereum.org/EIPS/eip-165[EIP].
223  *
224  * Implementers can declare support of contract interfaces, which can then be
225  * queried by others ({ERC165Checker}).
226  *
227  * For an implementation, see {ERC165}.
228  */
229 interface IERC165 {
230     /**
231      * @dev Returns true if this contract implements the interface defined by
232      * `interfaceId`. See the corresponding
233      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
234      * to learn more about how these ids are created.
235      *
236      * This function call must use less than 30 000 gas.
237      */
238     function supportsInterface(bytes4 interfaceId) external view returns (bool);
239 }
240 
241 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC721Receiver
242 
243 /**
244  * @title ERC721 token receiver interface
245  * @dev Interface for any contract that wants to support safeTransfers
246  * from ERC721 asset contracts.
247  */
248 interface IERC721Receiver {
249     /**
250      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
251      * by `operator` from `from`, this function is called.
252      *
253      * It must return its Solidity selector to confirm the token transfer.
254      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
255      *
256      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
257      */
258     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
259 }
260 
261 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Strings
262 
263 /**
264  * @dev String operations.
265  */
266 library Strings {
267     bytes16 private constant alphabet = "0123456789abcdef";
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
271      */
272     function toString(uint256 value) internal pure returns (string memory) {
273         // Inspired by OraclizeAPI's implementation - MIT licence
274         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
275 
276         if (value == 0) {
277             return "0";
278         }
279         uint256 temp = value;
280         uint256 digits;
281         while (temp != 0) {
282             digits++;
283             temp /= 10;
284         }
285         bytes memory buffer = new bytes(digits);
286         while (value != 0) {
287             digits -= 1;
288             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
289             value /= 10;
290         }
291         return string(buffer);
292     }
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
296      */
297     function toHexString(uint256 value) internal pure returns (string memory) {
298         if (value == 0) {
299             return "0x00";
300         }
301         uint256 temp = value;
302         uint256 length = 0;
303         while (temp != 0) {
304             length++;
305             temp >>= 8;
306         }
307         return toHexString(value, length);
308     }
309 
310     /**
311      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
312      */
313     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
314         bytes memory buffer = new bytes(2 * length + 2);
315         buffer[0] = "0";
316         buffer[1] = "x";
317         for (uint256 i = 2 * length + 1; i > 1; --i) {
318             buffer[i] = alphabet[value & 0xf];
319             value >>= 4;
320         }
321         require(value == 0, "Strings: hex length insufficient");
322         return string(buffer);
323     }
324 
325 }
326 
327 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/ERC165
328 
329 /**
330  * @dev Implementation of the {IERC165} interface.
331  *
332  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
333  * for the additional interface id that will be supported. For example:
334  *
335  * ```solidity
336  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
337  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
338  * }
339  * ```
340  *
341  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
342  */
343 abstract contract ERC165 is IERC165 {
344     /**
345      * @dev See {IERC165-supportsInterface}.
346      */
347     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
348         return interfaceId == type(IERC165).interfaceId;
349     }
350 }
351 
352 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC721
353 
354 /**
355  * @dev Required interface of an ERC721 compliant contract.
356  */
357 interface IERC721 is IERC165 {
358     /**
359      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
360      */
361     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
365      */
366     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
367 
368     /**
369      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
370      */
371     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
372 
373     /**
374      * @dev Returns the number of tokens in ``owner``'s account.
375      */
376     function balanceOf(address owner) external view returns (uint256 balance);
377 
378     /**
379      * @dev Returns the owner of the `tokenId` token.
380      *
381      * Requirements:
382      *
383      * - `tokenId` must exist.
384      */
385     function ownerOf(uint256 tokenId) external view returns (address owner);
386 
387     /**
388      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
389      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
390      *
391      * Requirements:
392      *
393      * - `from` cannot be the zero address.
394      * - `to` cannot be the zero address.
395      * - `tokenId` token must exist and be owned by `from`.
396      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
397      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
398      *
399      * Emits a {Transfer} event.
400      */
401     function safeTransferFrom(address from, address to, uint256 tokenId) external;
402 
403     /**
404      * @dev Transfers `tokenId` token from `from` to `to`.
405      *
406      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must be owned by `from`.
413      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(address from, address to, uint256 tokenId) external;
418 
419     /**
420      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
421      * The approval is cleared when the token is transferred.
422      *
423      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
424      *
425      * Requirements:
426      *
427      * - The caller must own the token or be an approved operator.
428      * - `tokenId` must exist.
429      *
430      * Emits an {Approval} event.
431      */
432     function approve(address to, uint256 tokenId) external;
433 
434     /**
435      * @dev Returns the account approved for `tokenId` token.
436      *
437      * Requirements:
438      *
439      * - `tokenId` must exist.
440      */
441     function getApproved(uint256 tokenId) external view returns (address operator);
442 
443     /**
444      * @dev Approve or remove `operator` as an operator for the caller.
445      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
446      *
447      * Requirements:
448      *
449      * - The `operator` cannot be the caller.
450      *
451      * Emits an {ApprovalForAll} event.
452      */
453     function setApprovalForAll(address operator, bool _approved) external;
454 
455     /**
456      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
457      *
458      * See {setApprovalForAll}
459      */
460     function isApprovedForAll(address owner, address operator) external view returns (bool);
461 
462     /**
463       * @dev Safely transfers `tokenId` token from `from` to `to`.
464       *
465       * Requirements:
466       *
467       * - `from` cannot be the zero address.
468       * - `to` cannot be the zero address.
469       * - `tokenId` token must exist and be owned by `from`.
470       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
471       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
472       *
473       * Emits a {Transfer} event.
474       */
475     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
476 }
477 
478 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Ownable
479 
480 /**
481  * @dev Contract module which provides a basic access control mechanism, where
482  * there is an account (an owner) that can be granted exclusive access to
483  * specific functions.
484  *
485  * By default, the owner account will be the one that deploys the contract. This
486  * can later be changed with {transferOwnership}.
487  *
488  * This module is used through inheritance. It will make available the modifier
489  * `onlyOwner`, which can be applied to your functions to restrict their use to
490  * the owner.
491  */
492 abstract contract Ownable is Context {
493     address private _owner;
494 
495     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
496 
497     /**
498      * @dev Initializes the contract setting the deployer as the initial owner.
499      */
500     constructor () {
501         address msgSender = _msgSender();
502         _owner = msgSender;
503         emit OwnershipTransferred(address(0), msgSender);
504     }
505 
506     /**
507      * @dev Returns the address of the current owner.
508      */
509     function owner() public view virtual returns (address) {
510         return _owner;
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         require(owner() == _msgSender(), "Ownable: caller is not the owner");
518         _;
519     }
520 
521     /**
522      * @dev Leaves the contract without owner. It will not be possible to call
523      * `onlyOwner` functions anymore. Can only be called by the current owner.
524      *
525      * NOTE: Renouncing ownership will leave the contract without an owner,
526      * thereby removing any functionality that is only available to the owner.
527      */
528     function renounceOwnership() public virtual onlyOwner {
529         emit OwnershipTransferred(_owner, address(0));
530         _owner = address(0);
531     }
532 
533     /**
534      * @dev Transfers ownership of the contract to a new account (`newOwner`).
535      * Can only be called by the current owner.
536      */
537     function transferOwnership(address newOwner) public virtual onlyOwner {
538         require(newOwner != address(0), "Ownable: new owner is the zero address");
539         emit OwnershipTransferred(_owner, newOwner);
540         _owner = newOwner;
541     }
542 }
543 
544 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC721Enumerable
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Enumerable is IERC721 {
551 
552     /**
553      * @dev Returns the total amount of tokens stored by the contract.
554      */
555     function totalSupply() external view returns (uint256);
556 
557     /**
558      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
559      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
560      */
561     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
562 
563     /**
564      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
565      * Use along with {totalSupply} to enumerate all tokens.
566      */
567     function tokenByIndex(uint256 index) external view returns (uint256);
568 }
569 
570 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC721Metadata
571 
572 /**
573  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
574  * @dev See https://eips.ethereum.org/EIPS/eip-721
575  */
576 interface IERC721Metadata is IERC721 {
577 
578     /**
579      * @dev Returns the token collection name.
580      */
581     function name() external view returns (string memory);
582 
583     /**
584      * @dev Returns the token collection symbol.
585      */
586     function symbol() external view returns (string memory);
587 
588     /**
589      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
590      */
591     function tokenURI(uint256 tokenId) external view returns (string memory);
592 }
593 
594 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/ERC721
595 
596 /**
597  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
598  * the Metadata extension, but not including the Enumerable extension, which is available separately as
599  * {ERC721Enumerable}.
600  */
601 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
602     using Address for address;
603     using Strings for uint256;
604 
605     // Token name
606     string private _name;
607 
608     // Token symbol
609     string private _symbol;
610 
611     // Mapping from token ID to owner address
612     mapping (uint256 => address) private _owners;
613 
614     // Mapping owner address to token count
615     mapping (address => uint256) private _balances;
616 
617     // Mapping from token ID to approved address
618     mapping (uint256 => address) private _tokenApprovals;
619 
620     // Mapping from owner to operator approvals
621     mapping (address => mapping (address => bool)) private _operatorApprovals;
622 
623     /**
624      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
625      */
626     constructor (string memory name_, string memory symbol_) {
627         _name = name_;
628         _symbol = symbol_;
629     }
630 
631     /**
632      * @dev See {IERC165-supportsInterface}.
633      */
634     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
635         return interfaceId == type(IERC721).interfaceId
636             || interfaceId == type(IERC721Metadata).interfaceId
637             || super.supportsInterface(interfaceId);
638     }
639 
640     /**
641      * @dev See {IERC721-balanceOf}.
642      */
643     function balanceOf(address owner) public view virtual override returns (uint256) {
644         require(owner != address(0), "ERC721: balance query for the zero address");
645         return _balances[owner];
646     }
647 
648     /**
649      * @dev See {IERC721-ownerOf}.
650      */
651     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
652         address owner = _owners[tokenId];
653         require(owner != address(0), "ERC721: owner query for nonexistent token");
654         return owner;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-name}.
659      */
660     function name() public view virtual override returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-symbol}.
666      */
667     function symbol() public view virtual override returns (string memory) {
668         return _symbol;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-tokenURI}.
673      */
674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
675         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
676 
677         string memory baseURI = _baseURI();
678         return bytes(baseURI).length > 0
679             ? string(abi.encodePacked(baseURI, tokenId.toString()))
680             : '';
681     }
682 
683     /**
684      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
685      * in child contracts.
686      */
687     function _baseURI() internal view virtual returns (string memory) {
688         return "";
689     }
690 
691     /**
692      * @dev See {IERC721-approve}.
693      */
694     function approve(address to, uint256 tokenId) public virtual override {
695         address owner = ERC721.ownerOf(tokenId);
696         require(to != owner, "ERC721: approval to current owner");
697 
698         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
699             "ERC721: approve caller is not owner nor approved for all"
700         );
701 
702         _approve(to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-getApproved}.
707      */
708     function getApproved(uint256 tokenId) public view virtual override returns (address) {
709         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
710 
711         return _tokenApprovals[tokenId];
712     }
713 
714     /**
715      * @dev See {IERC721-setApprovalForAll}.
716      */
717     function setApprovalForAll(address operator, bool approved) public virtual override {
718         require(operator != _msgSender(), "ERC721: approve to caller");
719 
720         _operatorApprovals[_msgSender()][operator] = approved;
721         emit ApprovalForAll(_msgSender(), operator, approved);
722     }
723 
724     /**
725      * @dev See {IERC721-isApprovedForAll}.
726      */
727     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
728         return _operatorApprovals[owner][operator];
729     }
730 
731     /**
732      * @dev See {IERC721-transferFrom}.
733      */
734     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
735         //solhint-disable-next-line max-line-length
736         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
737 
738         _transfer(from, to, tokenId);
739     }
740 
741     /**
742      * @dev See {IERC721-safeTransferFrom}.
743      */
744     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
745         safeTransferFrom(from, to, tokenId, "");
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
752         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
753         _safeTransfer(from, to, tokenId, _data);
754     }
755 
756     /**
757      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
758      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
759      *
760      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
761      *
762      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
763      * implement alternative mechanisms to perform token transfer, such as signature-based.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
775         _transfer(from, to, tokenId);
776         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
777     }
778 
779     /**
780      * @dev Returns whether `tokenId` exists.
781      *
782      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
783      *
784      * Tokens start existing when they are minted (`_mint`),
785      * and stop existing when they are burned (`_burn`).
786      */
787     function _exists(uint256 tokenId) internal view virtual returns (bool) {
788         return _owners[tokenId] != address(0);
789     }
790 
791     /**
792      * @dev Returns whether `spender` is allowed to manage `tokenId`.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must exist.
797      */
798     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
799         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
800         address owner = ERC721.ownerOf(tokenId);
801         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
802     }
803 
804     /**
805      * @dev Safely mints `tokenId` and transfers it to `to`.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must not exist.
810      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _safeMint(address to, uint256 tokenId) internal virtual {
815         _safeMint(to, tokenId, "");
816     }
817 
818     /**
819      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
820      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
821      */
822     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
823         _mint(to, tokenId);
824         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
825     }
826 
827     /**
828      * @dev Mints `tokenId` and transfers it to `to`.
829      *
830      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
831      *
832      * Requirements:
833      *
834      * - `tokenId` must not exist.
835      * - `to` cannot be the zero address.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _mint(address to, uint256 tokenId) internal virtual {
840         require(to != address(0), "ERC721: mint to the zero address");
841         require(!_exists(tokenId), "ERC721: token already minted");
842 
843         _beforeTokenTransfer(address(0), to, tokenId);
844 
845         _balances[to] += 1;
846         _owners[tokenId] = to;
847 
848         emit Transfer(address(0), to, tokenId);
849     }
850 
851     /**
852      * @dev Destroys `tokenId`.
853      * The approval is cleared when the token is burned.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _burn(uint256 tokenId) internal virtual {
862         address owner = ERC721.ownerOf(tokenId);
863 
864         _beforeTokenTransfer(owner, address(0), tokenId);
865 
866         // Clear approvals
867         _approve(address(0), tokenId);
868 
869         _balances[owner] -= 1;
870         delete _owners[tokenId];
871 
872         emit Transfer(owner, address(0), tokenId);
873     }
874 
875     /**
876      * @dev Transfers `tokenId` from `from` to `to`.
877      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
878      *
879      * Requirements:
880      *
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must be owned by `from`.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _transfer(address from, address to, uint256 tokenId) internal virtual {
887         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
888         require(to != address(0), "ERC721: transfer to the zero address");
889 
890         _beforeTokenTransfer(from, to, tokenId);
891 
892         // Clear approvals from the previous owner
893         _approve(address(0), tokenId);
894 
895         _balances[from] -= 1;
896         _balances[to] += 1;
897         _owners[tokenId] = to;
898 
899         emit Transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev Approve `to` to operate on `tokenId`
904      *
905      * Emits a {Approval} event.
906      */
907     function _approve(address to, uint256 tokenId) internal virtual {
908         _tokenApprovals[tokenId] = to;
909         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
910     }
911 
912     /**
913      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
914      * The call is not executed if the target address is not a contract.
915      *
916      * @param from address representing the previous owner of the given token ID
917      * @param to target address that will receive the tokens
918      * @param tokenId uint256 ID of the token to be transferred
919      * @param _data bytes optional data to send along with the call
920      * @return bool whether the call correctly returned the expected magic value
921      */
922     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
923         private returns (bool)
924     {
925         if (to.isContract()) {
926             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
927                 return retval == IERC721Receiver(to).onERC721Received.selector;
928             } catch (bytes memory reason) {
929                 if (reason.length == 0) {
930                     revert("ERC721: transfer to non ERC721Receiver implementer");
931                 } else {
932                     // solhint-disable-next-line no-inline-assembly
933                     assembly {
934                         revert(add(32, reason), mload(reason))
935                     }
936                 }
937             }
938         } else {
939             return true;
940         }
941     }
942 
943     /**
944      * @dev Hook that is called before any token transfer. This includes minting
945      * and burning.
946      *
947      * Calling conditions:
948      *
949      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
950      * transferred to `to`.
951      * - When `from` is zero, `tokenId` will be minted for `to`.
952      * - When `to` is zero, ``from``'s `tokenId` will be burned.
953      * - `from` cannot be the zero address.
954      * - `to` cannot be the zero address.
955      *
956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
957      */
958     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
959 }
960 
961 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/ERC721Enumerable
962 
963 /**
964  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
965  * enumerability of all the token ids in the contract as well as all token ids owned by each
966  * account.
967  */
968 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
969     // Mapping from owner to list of owned token IDs
970     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
971 
972     // Mapping from token ID to index of the owner tokens list
973     mapping(uint256 => uint256) private _ownedTokensIndex;
974 
975     // Array with all token ids, used for enumeration
976     uint256[] private _allTokens;
977 
978     // Mapping from token id to position in the allTokens array
979     mapping(uint256 => uint256) private _allTokensIndex;
980 
981     /**
982      * @dev See {IERC165-supportsInterface}.
983      */
984     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
985         return interfaceId == type(IERC721Enumerable).interfaceId
986             || super.supportsInterface(interfaceId);
987     }
988 
989     /**
990      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
991      */
992     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
993         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
994         return _ownedTokens[owner][index];
995     }
996 
997     /**
998      * @dev See {IERC721Enumerable-totalSupply}.
999      */
1000     function totalSupply() public view virtual override returns (uint256) {
1001         return _allTokens.length;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Enumerable-tokenByIndex}.
1006      */
1007     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1008         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1009         return _allTokens[index];
1010     }
1011 
1012     /**
1013      * @dev Hook that is called before any token transfer. This includes minting
1014      * and burning.
1015      *
1016      * Calling conditions:
1017      *
1018      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1019      * transferred to `to`.
1020      * - When `from` is zero, `tokenId` will be minted for `to`.
1021      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1022      * - `from` cannot be the zero address.
1023      * - `to` cannot be the zero address.
1024      *
1025      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1026      */
1027     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1028         super._beforeTokenTransfer(from, to, tokenId);
1029 
1030         if (from == address(0)) {
1031             _addTokenToAllTokensEnumeration(tokenId);
1032         } else if (from != to) {
1033             _removeTokenFromOwnerEnumeration(from, tokenId);
1034         }
1035         if (to == address(0)) {
1036             _removeTokenFromAllTokensEnumeration(tokenId);
1037         } else if (to != from) {
1038             _addTokenToOwnerEnumeration(to, tokenId);
1039         }
1040     }
1041 
1042     /**
1043      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1044      * @param to address representing the new owner of the given token ID
1045      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1046      */
1047     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1048         uint256 length = ERC721.balanceOf(to);
1049         _ownedTokens[to][length] = tokenId;
1050         _ownedTokensIndex[tokenId] = length;
1051     }
1052 
1053     /**
1054      * @dev Private function to add a token to this extension's token tracking data structures.
1055      * @param tokenId uint256 ID of the token to be added to the tokens list
1056      */
1057     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1058         _allTokensIndex[tokenId] = _allTokens.length;
1059         _allTokens.push(tokenId);
1060     }
1061 
1062     /**
1063      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1064      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1065      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1066      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1067      * @param from address representing the previous owner of the given token ID
1068      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1069      */
1070     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1071         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1072         // then delete the last slot (swap and pop).
1073 
1074         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1075         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1076 
1077         // When the token to delete is the last token, the swap operation is unnecessary
1078         if (tokenIndex != lastTokenIndex) {
1079             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1080 
1081             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1082             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1083         }
1084 
1085         // This also deletes the contents at the last position of the array
1086         delete _ownedTokensIndex[tokenId];
1087         delete _ownedTokens[from][lastTokenIndex];
1088     }
1089 
1090     /**
1091      * @dev Private function to remove a token from this extension's token tracking data structures.
1092      * This has O(1) time complexity, but alters the order of the _allTokens array.
1093      * @param tokenId uint256 ID of the token to be removed from the tokens list
1094      */
1095     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1096         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1097         // then delete the last slot (swap and pop).
1098 
1099         uint256 lastTokenIndex = _allTokens.length - 1;
1100         uint256 tokenIndex = _allTokensIndex[tokenId];
1101 
1102         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1103         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1104         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1105         uint256 lastTokenId = _allTokens[lastTokenIndex];
1106 
1107         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1108         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1109 
1110         // This also deletes the contents at the last position of the array
1111         delete _allTokensIndex[tokenId];
1112         _allTokens.pop();
1113     }
1114 }
1115 
1116 // File: ExtinctPunks.sol
1117 
1118 contract ExtinctPunks is ERC721Enumerable, Ownable {
1119     using Strings for uint256;
1120     event MintPunks(address indexed sender, uint256 startWith, uint256 times);
1121 
1122     //supply counters 
1123     uint256 public totalPunks;
1124     uint256 public totalCount = 22077; // 2077 for DystoPunks V2, and 10000 for SpaceFunksClub, and 10000 reserved for Community-selected PUNK project.
1125     
1126     mapping (uint256 => uint256) private treatlevel;    
1127     mapping (uint256 => uint256) private timeaftertreat;
1128     mapping (uint256 => uint256) private timeleft_totreat;
1129     mapping (uint256 => uint256) private first_aided;
1130 
1131     //token Index tracker 
1132     uint256 public price = 20000000000000000;
1133 
1134     //string
1135     string public baseURI;
1136     string public contractsURI;
1137 
1138     //bool
1139     bool private started;
1140 
1141     //constructor args 
1142     constructor(string memory name_, string memory symbol_, string memory baseURI_, string memory contractsURI_) ERC721(name_, symbol_) {
1143         baseURI = baseURI_;
1144         contractsURI = contractsURI_;
1145     }
1146 
1147     //basic functions. 
1148     function _baseURI() internal view virtual override returns (string memory){
1149         return baseURI;
1150     }
1151 
1152     function _contractURI() internal view virtual returns (string memory){
1153         return contractsURI;
1154     }
1155 
1156 
1157     function setBaseURI(string memory _newURI) public onlyOwner {
1158         baseURI = _newURI;
1159     }
1160 
1161     function FirstAid(uint256 tokenId) public virtual returns (string memory) {
1162         require(first_aided[tokenId] == 0, "First-aid is only once.");
1163         treatlevel[tokenId] = 0;
1164         first_aided[tokenId] = 1;
1165         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1166         require(treatlevel[tokenId] == 0, "Current Level must be bigger than 0");
1167         
1168         address owner = ERC721.ownerOf(tokenId);
1169         require(_msgSender() == owner,"ERC721: approve caller is not owner nor approved for all");
1170 
1171         string memory level = "_level_";
1172         string memory baseURI_ = _baseURI();
1173 
1174         if (treatlevel[tokenId] == 0) {
1175             uint256 lastrun = block.timestamp;
1176             timeaftertreat[tokenId] = lastrun;
1177             timeleft_totreat[tokenId] = 60*60*24*2;
1178             treatlevel[tokenId]++;
1179         }
1180         
1181         //string memory baseURI = _baseURI();
1182         return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString(), level, treatlevel[tokenId].toString())):"";
1183         }
1184 
1185 
1186     function Treat(uint256 tokenId) public virtual returns (string memory) {
1187         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1188         require(treatlevel[tokenId] >= 1, "Current Level must be bigger than 0");
1189         require(treatlevel[tokenId] <= 4, "Current Level must be smaller than 5 (max 4)");
1190 
1191         address owner = ERC721.ownerOf(tokenId);
1192         require(_msgSender() == owner,"ERC721: approve caller is not owner nor approved for all");
1193 
1194         string memory level = "_level_";
1195         string memory baseURI_ = _baseURI();
1196 
1197         if (timeleft_totreat[tokenId] == 0) {
1198             uint256 lastrun = block.timestamp;
1199             timeaftertreat[tokenId] = lastrun;
1200             timeleft_totreat[tokenId] = 60*60*24*2;
1201             treatlevel[tokenId]++;
1202         }
1203         else {
1204             timeleft_totreat[tokenId] = block.timestamp - timeaftertreat[tokenId];
1205             require(timeleft_totreat[tokenId] >= 60*60*24*2, "You can treat once in every other day");
1206 
1207             uint256 lastrun = block.timestamp;
1208             timeaftertreat[tokenId] = lastrun;
1209             timeleft_totreat[tokenId] = 60*60*24*2;
1210             treatlevel[tokenId]++;
1211         }
1212         
1213         //string memory baseURI = _baseURI();
1214         return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString(), level, treatlevel[tokenId].toString())):"";
1215     }
1216 
1217     function PunkHealth(uint256 tokenId) public view virtual returns (string memory) {
1218         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1219 
1220         return string(abi.encodePacked(treatlevel[tokenId].toString()));       
1221     }
1222 
1223     function TimeLeftToTreat(uint256 tokenId) public view virtual returns (string memory) {
1224     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1225 
1226         return string(abi.encodePacked(timeleft_totreat[tokenId].toString()));       
1227     }
1228 
1229     function CheckTimeLeftToTreat(uint256 tokenId) public virtual returns (string memory) {
1230     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1231 
1232         timeleft_totreat[tokenId] = 60*60*24*2 - (block.timestamp - timeaftertreat[tokenId]);
1233 
1234         return string(abi.encodePacked(timeleft_totreat[tokenId].toString()));       
1235     }
1236 
1237     //erc721 URIs
1238     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1239         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1240 
1241         string memory level = "_level_";
1242         string memory baseURI_ = _baseURI();
1243         return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString(), level, treatlevel[tokenId].toString())):"";       
1244     }
1245  
1246     function contractURI() public view returns (string memory) {
1247         string memory contractsURI_ = _contractURI();
1248         return bytes(contractsURI_).length > 0 ? string(abi.encodePacked(contractsURI_)) : "";       
1249     }
1250 
1251     function setStart(bool _start) public onlyOwner {
1252         started = _start;
1253     }
1254 
1255     function ResetTimeleftToTreat(uint256 tokenId) public onlyOwner{
1256         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1257         
1258         address owner = ERC721.ownerOf(tokenId);
1259         require(_msgSender() == owner,"ERC721: approve caller is not owner nor approved for all");
1260 
1261         timeaftertreat[tokenId] = block.timestamp;
1262         timeleft_totreat[tokenId] = 0;
1263         }
1264 
1265 
1266     function tokensOfOwner(address owner)
1267         public
1268         view
1269         returns (uint256[] memory)
1270     {
1271         uint256 count = balanceOf(owner);
1272         uint256[] memory ids = new uint256[](count);
1273         for (uint256 i = 0; i < count; i++) {
1274             ids[i] = tokenOfOwnerByIndex(owner, i);
1275         }
1276         return ids;
1277     }
1278 
1279     function mint(uint256 _times) payable public {
1280         require(started, "not started");
1281         require(totalPunks + _times <= totalCount, "max supply reached!");
1282         require(msg.value == _times * price, "value error, please check price.");
1283         payable(owner()).transfer(msg.value);
1284         emit MintPunks(_msgSender(), totalPunks+1, _times);
1285         for(uint256 i=0; i< _times; i++){
1286             _mint(_msgSender(), 1 + totalPunks++);
1287         }
1288     }  
1289 }
