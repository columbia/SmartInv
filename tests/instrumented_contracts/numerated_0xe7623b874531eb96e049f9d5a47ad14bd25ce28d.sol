1 // File: utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: Ownable.sol
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: extensions/IERC165.sol
98 
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Interface of the ERC165 standard, as defined in the
104  * https://eips.ethereum.org/EIPS/eip-165[EIP].
105  *
106  * Implementers can declare support of contract interfaces, which can then be
107  * queried by others ({ERC165Checker}).
108  *
109  * For an implementation, see {ERC165}.
110  */
111 interface IERC165 {
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30 000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 }
122 
123 // File: extensions/IERC721.sol
124 
125 
126 pragma solidity ^0.8.0;
127 
128 
129 /**
130  * @dev Required interface of an ERC721 compliant contract.
131  */
132 interface IERC721 is IERC165 {
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in ``owner``'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(address from, address to, uint256 tokenId) external;
177 
178     /**
179      * @dev Transfers `tokenId` token from `from` to `to`.
180      *
181      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must be owned by `from`.
188      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(address from, address to, uint256 tokenId) external;
193 
194     /**
195      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
196      * The approval is cleared when the token is transferred.
197      *
198      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
199      *
200      * Requirements:
201      *
202      * - The caller must own the token or be an approved operator.
203      * - `tokenId` must exist.
204      *
205      * Emits an {Approval} event.
206      */
207     function approve(address to, uint256 tokenId) external;
208 
209     /**
210      * @dev Returns the account approved for `tokenId` token.
211      *
212      * Requirements:
213      *
214      * - `tokenId` must exist.
215      */
216     function getApproved(uint256 tokenId) external view returns (address operator);
217 
218     /**
219      * @dev Approve or remove `operator` as an operator for the caller.
220      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
221      *
222      * Requirements:
223      *
224      * - The `operator` cannot be the caller.
225      *
226      * Emits an {ApprovalForAll} event.
227      */
228     function setApprovalForAll(address operator, bool _approved) external;
229 
230     /**
231      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
232      *
233      * See {setApprovalForAll}
234      */
235     function isApprovedForAll(address owner, address operator) external view returns (bool);
236 
237     /**
238       * @dev Safely transfers `tokenId` token from `from` to `to`.
239       *
240       * Requirements:
241       *
242       * - `from` cannot be the zero address.
243       * - `to` cannot be the zero address.
244       * - `tokenId` token must exist and be owned by `from`.
245       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
246       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
247       *
248       * Emits a {Transfer} event.
249       */
250     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
251 }
252 
253 // File: extensions/IERC721Receiver.sol
254 
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @title ERC721 token receiver interface
260  * @dev Interface for any contract that wants to support safeTransfers
261  * from ERC721 asset contracts.
262  */
263 interface IERC721Receiver {
264     /**
265      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
266      * by `operator` from `from`, this function is called.
267      *
268      * It must return its Solidity selector to confirm the token transfer.
269      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
270      *
271      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
272      */
273     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
274 }
275 
276 // File: extensions/IERC721Metadata.sol
277 
278 
279 pragma solidity ^0.8.0;
280 
281 
282 /**
283  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
284  * @dev See https://eips.ethereum.org/EIPS/eip-721
285  */
286 interface IERC721Metadata is IERC721 {
287 
288     /**
289      * @dev Returns the token collection name.
290      */
291     function name() external view returns (string memory);
292 
293     /**
294      * @dev Returns the token collection symbol.
295      */
296     function symbol() external view returns (string memory);
297 
298     /**
299      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
300      */
301     function tokenURI(uint256 tokenId) external view returns (string memory);
302 }
303 
304 // File: extensions/IERC721Enumerable.sol
305 
306 
307 pragma solidity ^0.8.0;
308 
309 
310 /**
311  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
312  * @dev See https://eips.ethereum.org/EIPS/eip-721
313  */
314 interface IERC721Enumerable is IERC721 {
315 
316     /**
317      * @dev Returns the total amount of tokens stored by the contract.
318      */
319     function totalSupply() external view returns (uint256);
320 
321     /**
322      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
323      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
324      */
325     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
326 
327     /**
328      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
329      * Use along with {totalSupply} to enumerate all tokens.
330      */
331     function tokenByIndex(uint256 index) external view returns (uint256);
332 }
333 
334 // File: extensions/ERC165.sol
335 
336 
337 pragma solidity ^0.8.0;
338 
339 
340 /**
341  * @dev Implementation of the {IERC165} interface.
342  *
343  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
344  * for the additional interface id that will be supported. For example:
345  *
346  * ```solidity
347  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
348  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
349  * }
350  * ```
351  *
352  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
353  */
354 abstract contract ERC165 is IERC165 {
355     /**
356      * @dev See {IERC165-supportsInterface}.
357      */
358     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
359         return interfaceId == type(IERC165).interfaceId;
360     }
361 }
362 
363 // File: utils/Address.sol
364 
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev Collection of functions related to the address type
370  */
371 library Address {
372     /**
373      * @dev Returns true if `account` is a contract.
374      *
375      * [IMPORTANT]
376      * ====
377      * It is unsafe to assume that an address for which this function returns
378      * false is an externally-owned account (EOA) and not a contract.
379      *
380      * Among others, `isContract` will return false for the following
381      * types of addresses:
382      *
383      *  - an externally-owned account
384      *  - a contract in construction
385      *  - an address where a contract will be created
386      *  - an address where a contract lived, but was destroyed
387      * ====
388      */
389     function isContract(address account) internal view returns (bool) {
390         // This method relies on extcodesize, which returns 0 for contracts in
391         // construction, since the code is only stored at the end of the
392         // constructor execution.
393 
394         uint256 size;
395         // solhint-disable-next-line no-inline-assembly
396         assembly { size := extcodesize(account) }
397         return size > 0;
398     }
399 
400     /**
401      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
402      * `recipient`, forwarding all available gas and reverting on errors.
403      *
404      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
405      * of certain opcodes, possibly making contracts go over the 2300 gas limit
406      * imposed by `transfer`, making them unable to receive funds via
407      * `transfer`. {sendValue} removes this limitation.
408      *
409      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
410      *
411      * IMPORTANT: because control is transferred to `recipient`, care must be
412      * taken to not create reentrancy vulnerabilities. Consider using
413      * {ReentrancyGuard} or the
414      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
415      */
416     function sendValue(address payable recipient, uint256 amount) internal {
417         require(address(this).balance >= amount, "Address: insufficient balance");
418 
419         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
420         (bool success, ) = recipient.call{ value: amount }("");
421         require(success, "Address: unable to send value, recipient may have reverted");
422     }
423 
424     /**
425      * @dev Performs a Solidity function call using a low level `call`. A
426      * plain`call` is an unsafe replacement for a function call: use this
427      * function instead.
428      *
429      * If `target` reverts with a revert reason, it is bubbled up by this
430      * function (like regular Solidity function calls).
431      *
432      * Returns the raw returned data. To convert to the expected return value,
433      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
434      *
435      * Requirements:
436      *
437      * - `target` must be a contract.
438      * - calling `target` with `data` must not revert.
439      *
440      * _Available since v3.1._
441      */
442     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
443       return functionCall(target, data, "Address: low-level call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
448      * `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, 0, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but also transferring `value` wei to `target`.
459      *
460      * Requirements:
461      *
462      * - the calling contract must have an ETH balance of at least `value`.
463      * - the called Solidity function must be `payable`.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
473      * with `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
478         require(address(this).balance >= value, "Address: insufficient balance for call");
479         require(isContract(target), "Address: call to non-contract");
480 
481         // solhint-disable-next-line avoid-low-level-calls
482         (bool success, bytes memory returndata) = target.call{ value: value }(data);
483         return _verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
493         return functionStaticCall(target, data, "Address: low-level static call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a static call.
499      *
500      * _Available since v3.3._
501      */
502     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
503         require(isContract(target), "Address: static call to non-contract");
504 
505         // solhint-disable-next-line avoid-low-level-calls
506         (bool success, bytes memory returndata) = target.staticcall(data);
507         return _verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
527         require(isContract(target), "Address: delegate call to non-contract");
528 
529         // solhint-disable-next-line avoid-low-level-calls
530         (bool success, bytes memory returndata) = target.delegatecall(data);
531         return _verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
535         if (success) {
536             return returndata;
537         } else {
538             // Look for revert reason and bubble it up if present
539             if (returndata.length > 0) {
540                 // The easiest way to bubble the revert reason is using memory via assembly
541 
542                 // solhint-disable-next-line no-inline-assembly
543                 assembly {
544                     let returndata_size := mload(returndata)
545                     revert(add(32, returndata), returndata_size)
546                 }
547             } else {
548                 revert(errorMessage);
549             }
550         }
551     }
552 }
553 
554 // File: utils/Strings.sol
555 
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev String operations.
561  */
562 library Strings {
563     bytes16 private constant alphabet = "0123456789abcdef";
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
614             buffer[i] = alphabet[value & 0xf];
615             value >>= 4;
616         }
617         require(value == 0, "Strings: hex length insufficient");
618         return string(buffer);
619     }
620 
621 }
622 
623 // File: ERC721.sol
624 
625 
626 pragma solidity ^0.8.0;
627 
628 
629 
630 
631 
632 
633 
634 
635 
636 /**
637  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
638  * the Metadata extension, but not including the Enumerable extension, which is available separately as
639  * {ERC721Enumerable}.
640  */
641 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
642     using Address for address;
643     using Strings for uint256;
644 
645     // Token name
646     string private _name;
647 
648     // Token symbol
649     string private _symbol;
650 
651     // Mapping from token ID to owner address
652     mapping (uint256 => address) private _owners;
653 
654     // Mapping owner address to token count
655     mapping (address => uint256) private _balances;
656 
657     // Mapping from token ID to approved address
658     mapping (uint256 => address) private _tokenApprovals;
659 
660     // Mapping from owner to operator approvals
661     mapping (address => mapping (address => bool)) private _operatorApprovals;
662 
663     /**
664      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
665      */
666     constructor (string memory name_, string memory symbol_) {
667         _name = name_;
668         _symbol = symbol_;
669     }
670 
671     /**
672      * @dev See {IERC165-supportsInterface}.
673      */
674     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
675         return interfaceId == type(IERC721).interfaceId
676             || interfaceId == type(IERC721Metadata).interfaceId
677             || super.supportsInterface(interfaceId);
678     }
679 
680     /**
681      * @dev See {IERC721-balanceOf}.
682      */
683     function balanceOf(address owner) public view virtual override returns (uint256) {
684         require(owner != address(0), "ERC721: balance query for the zero address");
685         return _balances[owner];
686     }
687 
688     /**
689      * @dev See {IERC721-ownerOf}.
690      */
691     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
692         address owner = _owners[tokenId];
693         require(owner != address(0), "ERC721: owner query for nonexistent token");
694         return owner;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-name}.
699      */
700     function name() public view virtual override returns (string memory) {
701         return _name;
702     }
703 
704     /**
705      * @dev See {IERC721Metadata-symbol}.
706      */
707     function symbol() public view virtual override returns (string memory) {
708         return _symbol;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-tokenURI}.
713      */
714     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
715         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
716 
717         string memory baseURI = _baseURI();
718         return bytes(baseURI).length > 0
719             ? string(abi.encodePacked(baseURI, tokenId.toString()))
720             : '';
721     }
722 
723     /**
724      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
725      * in child contracts.
726      */
727     function _baseURI() internal view virtual returns (string memory) {
728         return "";
729     }
730 
731     /**
732      * @dev See {IERC721-approve}.
733      */
734     function approve(address to, uint256 tokenId) public virtual override {
735         address owner = ERC721.ownerOf(tokenId);
736         require(to != owner, "ERC721: approval to current owner");
737 
738         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
739             "ERC721: approve caller is not owner nor approved for all"
740         );
741 
742         _approve(to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-getApproved}.
747      */
748     function getApproved(uint256 tokenId) public view virtual override returns (address) {
749         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
750 
751         return _tokenApprovals[tokenId];
752     }
753 
754     /**
755      * @dev See {IERC721-setApprovalForAll}.
756      */
757     function setApprovalForAll(address operator, bool approved) public virtual override {
758         require(operator != _msgSender(), "ERC721: approve to caller");
759 
760         _operatorApprovals[_msgSender()][operator] = approved;
761         emit ApprovalForAll(_msgSender(), operator, approved);
762     }
763 
764     /**
765      * @dev See {IERC721-isApprovedForAll}.
766      */
767     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
768         return _operatorApprovals[owner][operator];
769     }
770 
771     /**
772      * @dev See {IERC721-transferFrom}.
773      */
774     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
775         //solhint-disable-next-line max-line-length
776         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
777 
778         _transfer(from, to, tokenId);
779     }
780 
781     /**
782      * @dev See {IERC721-safeTransferFrom}.
783      */
784     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
785         safeTransferFrom(from, to, tokenId, "");
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
792         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
793         _safeTransfer(from, to, tokenId, _data);
794     }
795 
796     /**
797      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
798      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
799      *
800      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
801      *
802      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
803      * implement alternative mechanisms to perform token transfer, such as signature-based.
804      *
805      * Requirements:
806      *
807      * - `from` cannot be the zero address.
808      * - `to` cannot be the zero address.
809      * - `tokenId` token must exist and be owned by `from`.
810      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
815         _transfer(from, to, tokenId);
816         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
817     }
818 
819     /**
820      * @dev Returns whether `tokenId` exists.
821      *
822      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
823      *
824      * Tokens start existing when they are minted (`_mint`),
825      * and stop existing when they are burned (`_burn`).
826      */
827     function _exists(uint256 tokenId) internal view virtual returns (bool) {
828         return _owners[tokenId] != address(0);
829     }
830 
831     /**
832      * @dev Returns whether `spender` is allowed to manage `tokenId`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      */
838     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
839         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
840         address owner = ERC721.ownerOf(tokenId);
841         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
842     }
843 
844     /**
845      * @dev Safely mints `tokenId` and transfers it to `to`.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must not exist.
850      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
851      *
852      * Emits a {Transfer} event.
853      */
854     function _safeMint(address to, uint256 tokenId) internal virtual {
855         _safeMint(to, tokenId, "");
856     }
857 
858     /**
859      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
860      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
861      */
862     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
863         _mint(to, tokenId);
864         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
865     }
866 
867     /**
868      * @dev Mints `tokenId` and transfers it to `to`.
869      *
870      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
871      *
872      * Requirements:
873      *
874      * - `tokenId` must not exist.
875      * - `to` cannot be the zero address.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _mint(address to, uint256 tokenId) internal virtual {
880         require(to != address(0), "ERC721: mint to the zero address");
881         require(!_exists(tokenId), "ERC721: token already minted");
882 
883         _beforeTokenTransfer(address(0), to, tokenId);
884 
885         _balances[to] += 1;
886         _owners[tokenId] = to;
887 
888         emit Transfer(address(0), to, tokenId);
889     }
890 
891     /**
892      * @dev Destroys `tokenId`.
893      * The approval is cleared when the token is burned.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _burn(uint256 tokenId) internal virtual {
902         address owner = ERC721.ownerOf(tokenId);
903 
904         _beforeTokenTransfer(owner, address(0), tokenId);
905 
906         // Clear approvals
907         _approve(address(0), tokenId);
908 
909         _balances[owner] -= 1;
910         delete _owners[tokenId];
911 
912         emit Transfer(owner, address(0), tokenId);
913     }
914 
915     /**
916      * @dev Transfers `tokenId` from `from` to `to`.
917      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
918      *
919      * Requirements:
920      *
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must be owned by `from`.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _transfer(address from, address to, uint256 tokenId) internal virtual {
927         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
928         require(to != address(0), "ERC721: transfer to the zero address");
929 
930         _beforeTokenTransfer(from, to, tokenId);
931 
932         // Clear approvals from the previous owner
933         _approve(address(0), tokenId);
934 
935         _balances[from] -= 1;
936         _balances[to] += 1;
937         _owners[tokenId] = to;
938 
939         emit Transfer(from, to, tokenId);
940     }
941 
942     /**
943      * @dev Approve `to` to operate on `tokenId`
944      *
945      * Emits a {Approval} event.
946      */
947     function _approve(address to, uint256 tokenId) internal virtual {
948         _tokenApprovals[tokenId] = to;
949         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
950     }
951 
952     /**
953      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
954      * The call is not executed if the target address is not a contract.
955      *
956      * @param from address representing the previous owner of the given token ID
957      * @param to target address that will receive the tokens
958      * @param tokenId uint256 ID of the token to be transferred
959      * @param _data bytes optional data to send along with the call
960      * @return bool whether the call correctly returned the expected magic value
961      */
962     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
963         private returns (bool)
964     {
965         if (to.isContract()) {
966             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
967                 return retval == IERC721Receiver(to).onERC721Received.selector;
968             } catch (bytes memory reason) {
969                 if (reason.length == 0) {
970                     revert("ERC721: transfer to non ERC721Receiver implementer");
971                 } else {
972                     // solhint-disable-next-line no-inline-assembly
973                     assembly {
974                         revert(add(32, reason), mload(reason))
975                     }
976                 }
977             }
978         } else {
979             return true;
980         }
981     }
982 
983     /**
984      * @dev Hook that is called before any token transfer. This includes minting
985      * and burning.
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` will be minted for `to`.
992      * - When `to` is zero, ``from``'s `tokenId` will be burned.
993      * - `from` cannot be the zero address.
994      * - `to` cannot be the zero address.
995      *
996      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
997      */
998     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
999 }
1000 
1001 // File: ERC721EnumerableSimple.sol
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 
1006 
1007 
1008 /**
1009  * @dev This is a fork of openzeppelin ERC721Enumerable. It is gas-optimizated for NFT collection
1010  * with sequential token IDs. The updated part includes:
1011  * - replaced the array `_allToken`  with a simple uint `_totalSupply`,
1012  * - updated the functions `totalSupply` and `_beforeTokenTransfer`.
1013  */
1014 abstract contract ERC721EnumerableSimple is ERC721, IERC721Enumerable {
1015     // user => tokenId[]
1016     mapping(address => mapping(uint => uint)) private _ownedTokens;
1017 
1018     // tokenId => index of _ownedTokens[user] (used when changing token ownership)
1019     mapping(uint => uint) private _ownedTokensIndex;
1020 
1021     // current total amount of token minted
1022     uint private _totalSupply;
1023 
1024     /// @dev See {IERC165-supportsInterface}.
1025     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1026         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1027     }
1028 
1029     /// @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1030     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1031         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1032         return _ownedTokens[owner][index];
1033     }
1034 
1035     /// @dev See {IERC721Enumerable-totalSupply}.
1036     function totalSupply() public view virtual override returns (uint256) {
1037         return _totalSupply;
1038     }
1039 
1040     /// @dev See {IERC721Enumerable-tokenByIndex}.
1041     function tokenByIndex(uint index) public view virtual override returns (uint) {
1042         require(index < ERC721EnumerableSimple.totalSupply(), "ERC721Enumerable: global index out of bounds");
1043         return index;
1044     }
1045 
1046     /// @dev Hook that is called before any token transfer. This includes minting
1047     function _beforeTokenTransfer(
1048         address from,
1049         address to,
1050         uint tokenId
1051     ) internal virtual override {
1052         super._beforeTokenTransfer(from, to, tokenId);
1053 
1054         if (from == address(0)) {
1055             assert(tokenId == _totalSupply); // Ensure token is minted sequentially
1056             _totalSupply += 1;
1057         } else if (from != to) {
1058             _removeTokenFromOwnerEnumeration(from, tokenId);
1059         }
1060 
1061         if (to == address(0)) {
1062             // do nothing
1063         } else if (to != from) {
1064             _addTokenToOwnerEnumeration(to, tokenId);
1065         }
1066     }
1067 
1068     /**
1069      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1070      * @param to address representing the new owner of the given token ID
1071      * @param tokenId uint ID of the token to be added to the tokens list of the given address
1072      */
1073     function _addTokenToOwnerEnumeration(address to, uint tokenId) private {
1074         uint length = ERC721.balanceOf(to);
1075         _ownedTokens[to][length] = tokenId;
1076         _ownedTokensIndex[tokenId] = length;
1077     }
1078 
1079     /**
1080      * @dev See {ERC721Enumerable-_removeTokenFromOwnerEnumeration}.
1081      * @param from address representing the previous owner of the given token ID
1082      * @param tokenId uint ID of the token to be removed from the tokens list of the given address
1083      */
1084     function _removeTokenFromOwnerEnumeration(address from, uint tokenId) private {
1085         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1086         // then delete the last slot (swap and pop).
1087 
1088         uint lastTokenIndex = ERC721.balanceOf(from) - 1;
1089         uint tokenIndex = _ownedTokensIndex[tokenId];
1090 
1091         // When the token to delete is the last token, the swap operation is unnecessary
1092         if (tokenIndex != lastTokenIndex) {
1093             uint lastTokenId = _ownedTokens[from][lastTokenIndex];
1094 
1095             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1096             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1097         }
1098 
1099         // This also deletes the contents at the last position of the array
1100         delete _ownedTokensIndex[tokenId];
1101         delete _ownedTokens[from][lastTokenIndex];
1102     }
1103 }
1104 
1105 // File: RAKUZA.sol
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 contract RAKUZA is ERC721EnumerableSimple, Ownable {
1111     // Maximum amount of NFTToken in existance. Ever.
1112     // uint public constant MAX_NFTTOKEN_SUPPLY = 10000;
1113 
1114     // The provenance hash of all NFTToken. (Root hash of all NFTToken hashes concatenated)
1115     string public constant METADATA_PROVENANCE_HASH =
1116         "F5E8F9752F537EB428B0DC3A3A0F6B3646417E6FBD79AEC314D19D41AC48AF25";
1117 
1118     // Bsae URI of NFTToken's metadata
1119     string private baseURI;
1120 
1121     constructor() ERC721("RAKUZA", "RAKUZA") {}
1122 
1123     function tokensOfOwner(address _owner) external view returns (uint[] memory) {
1124         uint tokenCount = balanceOf(_owner);
1125         if (tokenCount == 0) {
1126             return new uint[](0); // Return an empty array
1127         } else {
1128             uint[] memory result = new uint[](tokenCount);
1129             for (uint index = 0; index < tokenCount; index++) {
1130                 result[index] = tokenOfOwnerByIndex(_owner, index);
1131             }
1132             return result;
1133         }
1134     }
1135 
1136     function mint() public onlyOwner {
1137         uint _totalSupply = totalSupply();
1138 
1139         // require(_totalSupply <= MAX_NFTTOKEN_SUPPLY, "Exceeds maximum NFTToken supply");
1140 
1141         _safeMint(msg.sender, _totalSupply);
1142     }
1143 
1144     function _baseURI() internal view override returns (string memory) {
1145         return baseURI;
1146     }
1147 
1148     function setBaseURI(string memory __baseURI) public onlyOwner {
1149         baseURI = __baseURI;
1150     }
1151 
1152     function burn(uint256 tokenId) public {
1153         require(_isApprovedOrOwner(msg.sender, tokenId));
1154         _burn(tokenId);
1155     }
1156 }