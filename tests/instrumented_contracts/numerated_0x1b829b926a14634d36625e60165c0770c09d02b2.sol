1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.0.0
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.8.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.0.0
31 
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 
100 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.0.0
101 
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 
127 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.0.0
128 
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Required interface of an ERC721 compliant contract.
134  */
135 interface IERC721 is IERC165 {
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
148      */
149     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
150 
151     /**
152      * @dev Returns the number of tokens in ``owner``'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
167      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(address from, address to, uint256 tokenId) external;
180 
181     /**
182      * @dev Transfers `tokenId` token from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(address from, address to, uint256 tokenId) external;
196 
197     /**
198      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
199      * The approval is cleared when the token is transferred.
200      *
201      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
202      *
203      * Requirements:
204      *
205      * - The caller must own the token or be an approved operator.
206      * - `tokenId` must exist.
207      *
208      * Emits an {Approval} event.
209      */
210     function approve(address to, uint256 tokenId) external;
211 
212     /**
213      * @dev Returns the account approved for `tokenId` token.
214      *
215      * Requirements:
216      *
217      * - `tokenId` must exist.
218      */
219     function getApproved(uint256 tokenId) external view returns (address operator);
220 
221     /**
222      * @dev Approve or remove `operator` as an operator for the caller.
223      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
224      *
225      * Requirements:
226      *
227      * - The `operator` cannot be the caller.
228      *
229      * Emits an {ApprovalForAll} event.
230      */
231     function setApprovalForAll(address operator, bool _approved) external;
232 
233     /**
234      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
235      *
236      * See {setApprovalForAll}
237      */
238     function isApprovedForAll(address owner, address operator) external view returns (bool);
239 
240     /**
241       * @dev Safely transfers `tokenId` token from `from` to `to`.
242       *
243       * Requirements:
244       *
245       * - `from` cannot be the zero address.
246       * - `to` cannot be the zero address.
247       * - `tokenId` token must exist and be owned by `from`.
248       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
249       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
250       *
251       * Emits a {Transfer} event.
252       */
253     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
254 }
255 
256 
257 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.0.0
258 
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @title ERC721 token receiver interface
264  * @dev Interface for any contract that wants to support safeTransfers
265  * from ERC721 asset contracts.
266  */
267 interface IERC721Receiver {
268     /**
269      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
270      * by `operator` from `from`, this function is called.
271      *
272      * It must return its Solidity selector to confirm the token transfer.
273      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
274      *
275      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
276      */
277     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
278 }
279 
280 
281 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.0.0
282 
283 
284 pragma solidity ^0.8.0;
285 
286 /**
287  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
288  * @dev See https://eips.ethereum.org/EIPS/eip-721
289  */
290 interface IERC721Metadata is IERC721 {
291 
292     /**
293      * @dev Returns the token collection name.
294      */
295     function name() external view returns (string memory);
296 
297     /**
298      * @dev Returns the token collection symbol.
299      */
300     function symbol() external view returns (string memory);
301 
302     /**
303      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
304      */
305     function tokenURI(uint256 tokenId) external view returns (string memory);
306 }
307 
308 
309 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.0.0
310 
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
316  * @dev See https://eips.ethereum.org/EIPS/eip-721
317  */
318 interface IERC721Enumerable is IERC721 {
319 
320     /**
321      * @dev Returns the total amount of tokens stored by the contract.
322      */
323     function totalSupply() external view returns (uint256);
324 
325     /**
326      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
327      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
328      */
329     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
330 
331     /**
332      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
333      * Use along with {totalSupply} to enumerate all tokens.
334      */
335     function tokenByIndex(uint256 index) external view returns (uint256);
336 }
337 
338 
339 // File @openzeppelin/contracts/utils/Address.sol@v4.0.0
340 
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Collection of functions related to the address type
346  */
347 library Address {
348     /**
349      * @dev Returns true if `account` is a contract.
350      *
351      * [IMPORTANT]
352      * ====
353      * It is unsafe to assume that an address for which this function returns
354      * false is an externally-owned account (EOA) and not a contract.
355      *
356      * Among others, `isContract` will return false for the following
357      * types of addresses:
358      *
359      *  - an externally-owned account
360      *  - a contract in construction
361      *  - an address where a contract will be created
362      *  - an address where a contract lived, but was destroyed
363      * ====
364      */
365     function isContract(address account) internal view returns (bool) {
366         // This method relies on extcodesize, which returns 0 for contracts in
367         // construction, since the code is only stored at the end of the
368         // constructor execution.
369 
370         uint256 size;
371         // solhint-disable-next-line no-inline-assembly
372         assembly { size := extcodesize(account) }
373         return size > 0;
374     }
375 
376     /**
377      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
378      * `recipient`, forwarding all available gas and reverting on errors.
379      *
380      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
381      * of certain opcodes, possibly making contracts go over the 2300 gas limit
382      * imposed by `transfer`, making them unable to receive funds via
383      * `transfer`. {sendValue} removes this limitation.
384      *
385      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
386      *
387      * IMPORTANT: because control is transferred to `recipient`, care must be
388      * taken to not create reentrancy vulnerabilities. Consider using
389      * {ReentrancyGuard} or the
390      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
391      */
392     function sendValue(address payable recipient, uint256 amount) internal {
393         require(address(this).balance >= amount, "Address: insufficient balance");
394 
395         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
396         (bool success, ) = recipient.call{ value: amount }("");
397         require(success, "Address: unable to send value, recipient may have reverted");
398     }
399 
400     /**
401      * @dev Performs a Solidity function call using a low level `call`. A
402      * plain`call` is an unsafe replacement for a function call: use this
403      * function instead.
404      *
405      * If `target` reverts with a revert reason, it is bubbled up by this
406      * function (like regular Solidity function calls).
407      *
408      * Returns the raw returned data. To convert to the expected return value,
409      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
410      *
411      * Requirements:
412      *
413      * - `target` must be a contract.
414      * - calling `target` with `data` must not revert.
415      *
416      * _Available since v3.1._
417      */
418     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
419       return functionCall(target, data, "Address: low-level call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
424      * `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, 0, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but also transferring `value` wei to `target`.
435      *
436      * Requirements:
437      *
438      * - the calling contract must have an ETH balance of at least `value`.
439      * - the called Solidity function must be `payable`.
440      *
441      * _Available since v3.1._
442      */
443     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
449      * with `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
454         require(address(this).balance >= value, "Address: insufficient balance for call");
455         require(isContract(target), "Address: call to non-contract");
456 
457         // solhint-disable-next-line avoid-low-level-calls
458         (bool success, bytes memory returndata) = target.call{ value: value }(data);
459         return _verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
469         return functionStaticCall(target, data, "Address: low-level static call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
479         require(isContract(target), "Address: static call to non-contract");
480 
481         // solhint-disable-next-line avoid-low-level-calls
482         (bool success, bytes memory returndata) = target.staticcall(data);
483         return _verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
503         require(isContract(target), "Address: delegate call to non-contract");
504 
505         // solhint-disable-next-line avoid-low-level-calls
506         (bool success, bytes memory returndata) = target.delegatecall(data);
507         return _verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517 
518                 // solhint-disable-next-line no-inline-assembly
519                 assembly {
520                     let returndata_size := mload(returndata)
521                     revert(add(32, returndata), returndata_size)
522                 }
523             } else {
524                 revert(errorMessage);
525             }
526         }
527     }
528 }
529 
530 
531 // File @openzeppelin/contracts/utils/Strings.sol@v4.0.0
532 
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev String operations.
538  */
539 library Strings {
540     bytes16 private constant alphabet = "0123456789abcdef";
541 
542     /**
543      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
544      */
545     function toString(uint256 value) internal pure returns (string memory) {
546         // Inspired by OraclizeAPI's implementation - MIT licence
547         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
548 
549         if (value == 0) {
550             return "0";
551         }
552         uint256 temp = value;
553         uint256 digits;
554         while (temp != 0) {
555             digits++;
556             temp /= 10;
557         }
558         bytes memory buffer = new bytes(digits);
559         while (value != 0) {
560             digits -= 1;
561             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
562             value /= 10;
563         }
564         return string(buffer);
565     }
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
569      */
570     function toHexString(uint256 value) internal pure returns (string memory) {
571         if (value == 0) {
572             return "0x00";
573         }
574         uint256 temp = value;
575         uint256 length = 0;
576         while (temp != 0) {
577             length++;
578             temp >>= 8;
579         }
580         return toHexString(value, length);
581     }
582 
583     /**
584      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
585      */
586     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
587         bytes memory buffer = new bytes(2 * length + 2);
588         buffer[0] = "0";
589         buffer[1] = "x";
590         for (uint256 i = 2 * length + 1; i > 1; --i) {
591             buffer[i] = alphabet[value & 0xf];
592             value >>= 4;
593         }
594         require(value == 0, "Strings: hex length insufficient");
595         return string(buffer);
596     }
597 
598 }
599 
600 
601 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.0.0
602 
603 
604 pragma solidity ^0.8.0;
605 
606 /**
607  * @dev Implementation of the {IERC165} interface.
608  *
609  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
610  * for the additional interface id that will be supported. For example:
611  *
612  * ```solidity
613  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
615  * }
616  * ```
617  *
618  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
619  */
620 abstract contract ERC165 is IERC165 {
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625         return interfaceId == type(IERC165).interfaceId;
626     }
627 }
628 
629 
630 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.0.0
631 
632 
633 pragma solidity ^0.8.0;
634 
635 
636 
637 
638 
639 
640 
641 
642 /**
643  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
644  * the Metadata extension, but not including the Enumerable extension, which is available separately as
645  * {ERC721Enumerable}.
646  */
647 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
648     using Address for address;
649     using Strings for uint256;
650 
651     // Token name
652     string private _name;
653 
654     // Token symbol
655     string private _symbol;
656 
657     // Mapping from token ID to owner address
658     mapping (uint256 => address) private _owners;
659 
660     // Mapping owner address to token count
661     mapping (address => uint256) private _balances;
662 
663     // Mapping from token ID to approved address
664     mapping (uint256 => address) private _tokenApprovals;
665 
666     // Mapping from owner to operator approvals
667     mapping (address => mapping (address => bool)) private _operatorApprovals;
668 
669     /**
670      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
671      */
672     constructor (string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675     }
676 
677     /**
678      * @dev See {IERC165-supportsInterface}.
679      */
680     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
681         return interfaceId == type(IERC721).interfaceId
682             || interfaceId == type(IERC721Metadata).interfaceId
683             || super.supportsInterface(interfaceId);
684     }
685 
686     /**
687      * @dev See {IERC721-balanceOf}.
688      */
689     function balanceOf(address owner) public view virtual override returns (uint256) {
690         require(owner != address(0), "ERC721: balance query for the zero address");
691         return _balances[owner];
692     }
693 
694     /**
695      * @dev See {IERC721-ownerOf}.
696      */
697     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
698         address owner = _owners[tokenId];
699         require(owner != address(0), "ERC721: owner query for nonexistent token");
700         return owner;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-name}.
705      */
706     function name() public view virtual override returns (string memory) {
707         return _name;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-symbol}.
712      */
713     function symbol() public view virtual override returns (string memory) {
714         return _symbol;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-tokenURI}.
719      */
720     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
721         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
722 
723         string memory baseURI = _baseURI();
724         return bytes(baseURI).length > 0
725             ? string(abi.encodePacked(baseURI, tokenId.toString()))
726             : '';
727     }
728 
729     /**
730      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
731      * in child contracts.
732      */
733     function _baseURI() internal view virtual returns (string memory) {
734         return "";
735     }
736 
737     /**
738      * @dev See {IERC721-approve}.
739      */
740     function approve(address to, uint256 tokenId) public virtual override {
741         address owner = ERC721.ownerOf(tokenId);
742         require(to != owner, "ERC721: approval to current owner");
743 
744         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
745             "ERC721: approve caller is not owner nor approved for all"
746         );
747 
748         _approve(to, tokenId);
749     }
750 
751     /**
752      * @dev See {IERC721-getApproved}.
753      */
754     function getApproved(uint256 tokenId) public view virtual override returns (address) {
755         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
756 
757         return _tokenApprovals[tokenId];
758     }
759 
760     /**
761      * @dev See {IERC721-setApprovalForAll}.
762      */
763     function setApprovalForAll(address operator, bool approved) public virtual override {
764         require(operator != _msgSender(), "ERC721: approve to caller");
765 
766         _operatorApprovals[_msgSender()][operator] = approved;
767         emit ApprovalForAll(_msgSender(), operator, approved);
768     }
769 
770     /**
771      * @dev See {IERC721-isApprovedForAll}.
772      */
773     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
774         return _operatorApprovals[owner][operator];
775     }
776 
777     /**
778      * @dev See {IERC721-transferFrom}.
779      */
780     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
781         //solhint-disable-next-line max-line-length
782         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
783 
784         _transfer(from, to, tokenId);
785     }
786 
787     /**
788      * @dev See {IERC721-safeTransferFrom}.
789      */
790     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
791         safeTransferFrom(from, to, tokenId, "");
792     }
793 
794     /**
795      * @dev See {IERC721-safeTransferFrom}.
796      */
797     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
798         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
799         _safeTransfer(from, to, tokenId, _data);
800     }
801 
802     /**
803      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
804      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
805      *
806      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
807      *
808      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
809      * implement alternative mechanisms to perform token transfer, such as signature-based.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must exist and be owned by `from`.
816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
821         _transfer(from, to, tokenId);
822         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
823     }
824 
825     /**
826      * @dev Returns whether `tokenId` exists.
827      *
828      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
829      *
830      * Tokens start existing when they are minted (`_mint`),
831      * and stop existing when they are burned (`_burn`).
832      */
833     function _exists(uint256 tokenId) internal view virtual returns (bool) {
834         return _owners[tokenId] != address(0);
835     }
836 
837     /**
838      * @dev Returns whether `spender` is allowed to manage `tokenId`.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      */
844     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
845         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
846         address owner = ERC721.ownerOf(tokenId);
847         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
848     }
849 
850     /**
851      * @dev Safely mints `tokenId` and transfers it to `to`.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must not exist.
856      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _safeMint(address to, uint256 tokenId) internal virtual {
861         _safeMint(to, tokenId, "");
862     }
863 
864     /**
865      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
866      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
867      */
868     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
869         _mint(to, tokenId);
870         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
871     }
872 
873     /**
874      * @dev Mints `tokenId` and transfers it to `to`.
875      *
876      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
877      *
878      * Requirements:
879      *
880      * - `tokenId` must not exist.
881      * - `to` cannot be the zero address.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _mint(address to, uint256 tokenId) internal virtual {
886         require(to != address(0), "ERC721: mint to the zero address");
887         require(!_exists(tokenId), "ERC721: token already minted");
888 
889         _beforeTokenTransfer(address(0), to, tokenId);
890 
891         _balances[to] += 1;
892         _owners[tokenId] = to;
893 
894         emit Transfer(address(0), to, tokenId);
895     }
896 
897     /**
898      * @dev Destroys `tokenId`.
899      * The approval is cleared when the token is burned.
900      *
901      * Requirements:
902      *
903      * - `tokenId` must exist.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _burn(uint256 tokenId) internal virtual {
908         address owner = ERC721.ownerOf(tokenId);
909 
910         _beforeTokenTransfer(owner, address(0), tokenId);
911 
912         // Clear approvals
913         _approve(address(0), tokenId);
914 
915         _balances[owner] -= 1;
916         delete _owners[tokenId];
917 
918         emit Transfer(owner, address(0), tokenId);
919     }
920 
921     /**
922      * @dev Transfers `tokenId` from `from` to `to`.
923      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - `tokenId` token must be owned by `from`.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _transfer(address from, address to, uint256 tokenId) internal virtual {
933         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
934         require(to != address(0), "ERC721: transfer to the zero address");
935 
936         _beforeTokenTransfer(from, to, tokenId);
937 
938         // Clear approvals from the previous owner
939         _approve(address(0), tokenId);
940 
941         _balances[from] -= 1;
942         _balances[to] += 1;
943         _owners[tokenId] = to;
944 
945         emit Transfer(from, to, tokenId);
946     }
947 
948     /**
949      * @dev Approve `to` to operate on `tokenId`
950      *
951      * Emits a {Approval} event.
952      */
953     function _approve(address to, uint256 tokenId) internal virtual {
954         _tokenApprovals[tokenId] = to;
955         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
956     }
957 
958     /**
959      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
960      * The call is not executed if the target address is not a contract.
961      *
962      * @param from address representing the previous owner of the given token ID
963      * @param to target address that will receive the tokens
964      * @param tokenId uint256 ID of the token to be transferred
965      * @param _data bytes optional data to send along with the call
966      * @return bool whether the call correctly returned the expected magic value
967      */
968     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
969         private returns (bool)
970     {
971         if (to.isContract()) {
972             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
973                 return retval == IERC721Receiver(to).onERC721Received.selector;
974             } catch (bytes memory reason) {
975                 if (reason.length == 0) {
976                     revert("ERC721: transfer to non ERC721Receiver implementer");
977                 } else {
978                     // solhint-disable-next-line no-inline-assembly
979                     assembly {
980                         revert(add(32, reason), mload(reason))
981                     }
982                 }
983             }
984         } else {
985             return true;
986         }
987     }
988 
989     /**
990      * @dev Hook that is called before any token transfer. This includes minting
991      * and burning.
992      *
993      * Calling conditions:
994      *
995      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
996      * transferred to `to`.
997      * - When `from` is zero, `tokenId` will be minted for `to`.
998      * - When `to` is zero, ``from``'s `tokenId` will be burned.
999      * - `from` cannot be the zero address.
1000      * - `to` cannot be the zero address.
1001      *
1002      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003      */
1004     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1005 }
1006 
1007 
1008 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.0.0
1009 
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 /**
1015  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1016  * enumerability of all the token ids in the contract as well as all token ids owned by each
1017  * account.
1018  */
1019 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1020     // Mapping from owner to list of owned token IDs
1021     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1022 
1023     // Mapping from token ID to index of the owner tokens list
1024     mapping(uint256 => uint256) private _ownedTokensIndex;
1025 
1026     // Array with all token ids, used for enumeration
1027     uint256[] private _allTokens;
1028 
1029     // Mapping from token id to position in the allTokens array
1030     mapping(uint256 => uint256) private _allTokensIndex;
1031 
1032     /**
1033      * @dev See {IERC165-supportsInterface}.
1034      */
1035     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1036         return interfaceId == type(IERC721Enumerable).interfaceId
1037             || super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1042      */
1043     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1045         return _ownedTokens[owner][index];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-totalSupply}.
1050      */
1051     function totalSupply() public view virtual override returns (uint256) {
1052         return _allTokens.length;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenByIndex}.
1057      */
1058     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1060         return _allTokens[index];
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any token transfer. This includes minting
1065      * and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` will be minted for `to`.
1072      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1079         super._beforeTokenTransfer(from, to, tokenId);
1080 
1081         if (from == address(0)) {
1082             _addTokenToAllTokensEnumeration(tokenId);
1083         } else if (from != to) {
1084             _removeTokenFromOwnerEnumeration(from, tokenId);
1085         }
1086         if (to == address(0)) {
1087             _removeTokenFromAllTokensEnumeration(tokenId);
1088         } else if (to != from) {
1089             _addTokenToOwnerEnumeration(to, tokenId);
1090         }
1091     }
1092 
1093     /**
1094      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1095      * @param to address representing the new owner of the given token ID
1096      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1097      */
1098     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1099         uint256 length = ERC721.balanceOf(to);
1100         _ownedTokens[to][length] = tokenId;
1101         _ownedTokensIndex[tokenId] = length;
1102     }
1103 
1104     /**
1105      * @dev Private function to add a token to this extension's token tracking data structures.
1106      * @param tokenId uint256 ID of the token to be added to the tokens list
1107      */
1108     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1109         _allTokensIndex[tokenId] = _allTokens.length;
1110         _allTokens.push(tokenId);
1111     }
1112 
1113     /**
1114      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1115      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1116      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1117      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1118      * @param from address representing the previous owner of the given token ID
1119      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1120      */
1121     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1122         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1123         // then delete the last slot (swap and pop).
1124 
1125         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1126         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1127 
1128         // When the token to delete is the last token, the swap operation is unnecessary
1129         if (tokenIndex != lastTokenIndex) {
1130             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1131 
1132             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1133             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1134         }
1135 
1136         // This also deletes the contents at the last position of the array
1137         delete _ownedTokensIndex[tokenId];
1138         delete _ownedTokens[from][lastTokenIndex];
1139     }
1140 
1141     /**
1142      * @dev Private function to remove a token from this extension's token tracking data structures.
1143      * This has O(1) time complexity, but alters the order of the _allTokens array.
1144      * @param tokenId uint256 ID of the token to be removed from the tokens list
1145      */
1146     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1147         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1148         // then delete the last slot (swap and pop).
1149 
1150         uint256 lastTokenIndex = _allTokens.length - 1;
1151         uint256 tokenIndex = _allTokensIndex[tokenId];
1152 
1153         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1154         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1155         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1156         uint256 lastTokenId = _allTokens[lastTokenIndex];
1157 
1158         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1159         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1160 
1161         // This also deletes the contents at the last position of the array
1162         delete _allTokensIndex[tokenId];
1163         _allTokens.pop();
1164     }
1165 }
1166 
1167 
1168 // File @openzeppelin/contracts/utils/Counters.sol@v4.0.0
1169 
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 /**
1174  * @title Counters
1175  * @author Matt Condon (@shrugs)
1176  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1177  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1178  *
1179  * Include with `using Counters for Counters.Counter;`
1180  */
1181 library Counters {
1182     struct Counter {
1183         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1184         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1185         // this feature: see https://github.com/ethereum/solidity/issues/4637
1186         uint256 _value; // default: 0
1187     }
1188 
1189     function current(Counter storage counter) internal view returns (uint256) {
1190         return counter._value;
1191     }
1192 
1193     function increment(Counter storage counter) internal {
1194         unchecked {
1195             counter._value += 1;
1196         }
1197     }
1198 
1199     function decrement(Counter storage counter) internal {
1200         uint256 value = counter._value;
1201         require(value > 0, "Counter: decrement overflow");
1202         unchecked {
1203             counter._value = value - 1;
1204         }
1205     }
1206 }
1207 
1208 
1209 // File contracts/Treeverse.sol
1210 
1211 pragma solidity ^0.8.0;
1212 
1213 
1214 
1215 contract Treeverse is ERC721Enumerable, Ownable {
1216 
1217     using Strings for uint256;
1218 
1219     struct Collection {
1220         uint128 tokenPriceInWei;
1221         uint32 tokensMinted;
1222         uint32 maxTokensAvailable;
1223         uint32 collectionNumber;
1224         bool created;
1225         bool locked; 
1226         bool active; 
1227         string name;
1228         string description;
1229         string baseURI;
1230     }
1231 
1232     mapping(uint256 => Collection) public collections;
1233 
1234     uint256 constant ONE_MILLION = 1_000_000;
1235     uint256 public nextCollectionNumber = 1;
1236     string public customURI;
1237 
1238     constructor(string memory _customURI) ERC721("Treeverse", "TRV"){
1239         customURI = _customURI;
1240     }
1241 
1242     modifier ifCollectionExists(uint256 _collectionNumber) {
1243         require(collections[_collectionNumber].created, "Collection has not been created yet");
1244         _;
1245     }
1246 
1247     modifier ifCollectionActive(uint256 _collectionNumber) {
1248         require(collections[_collectionNumber].active, "The collection is not active");
1249         _;
1250     }
1251     
1252     modifier ifCollectionNotLocked(uint256 _collectionNumber){
1253         require(!collections[_collectionNumber].locked, "The collection is locked");
1254         _;
1255     }
1256 
1257     function withdraw() public onlyOwner {
1258         uint balance = address(this).balance;
1259         payable(msg.sender).transfer(balance);
1260     }
1261 
1262     function createCollection(
1263         string memory _name, 
1264         string memory _description, 
1265         string memory _collectionBaseURI, 
1266         uint128 _tokenPriceInWei, 
1267         uint32 _maxTokensAvailable,
1268         uint32 _collectionNumber
1269         ) public onlyOwner
1270     {   
1271 
1272         require(!collections[_collectionNumber].created, "A collection with this collection number already exists");
1273         require(_maxTokensAvailable < ONE_MILLION, "The maximum number of tokens available per collection must be less than 1 million");
1274         require(_collectionNumber == nextCollectionNumber, "You are trying to create a collection that doesn't match the nextCollectionNumber");
1275         Collection memory newCollection = Collection({
1276             name: _name,
1277             description: _description,
1278             baseURI: _collectionBaseURI,
1279             tokenPriceInWei: _tokenPriceInWei,
1280             maxTokensAvailable: _maxTokensAvailable,
1281             collectionNumber: _collectionNumber,
1282             created: true, 
1283             locked: false,
1284             active: false,
1285             tokensMinted: 0
1286         });
1287         collections[nextCollectionNumber++] = newCollection;
1288     }
1289 
1290     function changeName(uint256 _collectionNumber, string memory _name) public onlyOwner ifCollectionExists(_collectionNumber) ifCollectionNotLocked(_collectionNumber)  {
1291         collections[_collectionNumber].name = _name;
1292     }
1293 
1294     function changeDescription(uint256 _collectionNumber, string memory _description) public onlyOwner ifCollectionExists(_collectionNumber) ifCollectionNotLocked(_collectionNumber) {
1295         collections[_collectionNumber].description = _description;
1296     }
1297 
1298     function changeBaseURI(uint256 _collectionNumber, string memory _collectionBaseURI) public onlyOwner ifCollectionExists(_collectionNumber)  ifCollectionNotLocked(_collectionNumber){
1299         collections[_collectionNumber].baseURI = _collectionBaseURI;
1300     }
1301 
1302     function changeTokenPriceInWei(uint256 _collectionNumber, uint128 _tokenPriceInWei) public onlyOwner ifCollectionExists(_collectionNumber) ifCollectionNotLocked(_collectionNumber) {
1303         collections[_collectionNumber].tokenPriceInWei = _tokenPriceInWei;
1304     }
1305 
1306     function changeMaxTokensAvailable(uint256 _collectionNumber, uint32 _maxTokensAvailable) public onlyOwner ifCollectionExists(_collectionNumber) ifCollectionNotLocked(_collectionNumber) {
1307         collections[_collectionNumber].maxTokensAvailable = _maxTokensAvailable;
1308     }
1309 
1310     function lockCollection(uint256 _collectionNumber) public onlyOwner ifCollectionExists(_collectionNumber) ifCollectionNotLocked(_collectionNumber) {
1311         collections[_collectionNumber].locked = true;
1312     }
1313 
1314     function toggleActive(uint256 _collectionNumber) public onlyOwner ifCollectionExists(_collectionNumber) ifCollectionNotLocked(_collectionNumber) {
1315         collections[_collectionNumber].active = !collections[_collectionNumber].active;
1316     }
1317 
1318     function purchaseNft(uint256 _collectionNumber, uint256 _quantity)
1319         public
1320         payable
1321         ifCollectionExists(_collectionNumber)
1322         ifCollectionActive(_collectionNumber)
1323         ifCollectionNotLocked(_collectionNumber)
1324     {
1325         require(_quantity > 0 ,  "Number of tokens to purchase must be greater than 0");
1326         Collection storage collection = collections[_collectionNumber];
1327 
1328         require(collection.tokensMinted + _quantity <= collection.maxTokensAvailable, "This transaction would exceed the maximum number of tokens in this collection");
1329         require(msg.value == _quantity * collection.tokenPriceInWei, "You did not send the correct amount of ether");
1330         for(uint256 i=0; i< _quantity; i++){
1331             _mintNft(msg.sender, _collectionNumber);
1332         }
1333     }
1334     
1335     function devMint(uint256 _collectionNumber, address _to, uint256 _quantity)
1336         public
1337         onlyOwner
1338         ifCollectionExists(_collectionNumber)
1339         ifCollectionNotLocked(_collectionNumber)
1340     {  
1341         require(_quantity > 0 ,  "Number of tokens to mint must be greater than 0");
1342         Collection storage collection = collections[_collectionNumber];
1343         require(collection.tokensMinted + _quantity <= collection.maxTokensAvailable, "This transaction would exceed the maximum number of tokens in this collection");
1344         for(uint256 i=0; i< _quantity; i++){
1345             _mintNft(_to, _collectionNumber);
1346         }
1347     }
1348 
1349     function _mintNft(address _to, uint256 _collectionNumber) internal{
1350         uint256 tokenIdToMint = (_collectionNumber * ONE_MILLION) + (++collections[_collectionNumber].tokensMinted);
1351         _safeMint(_to, tokenIdToMint);
1352     }
1353 
1354     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1355         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1356         string memory baseURI = collections[_tokenId/ONE_MILLION].baseURI;
1357         return bytes(baseURI).length > 0
1358             ? string(abi.encodePacked(baseURI, _tokenId.toString()))
1359             : '';
1360     }
1361 
1362     function changeCustomURI(string memory _newUri) public onlyOwner {
1363         customURI = _newUri;
1364     }
1365 
1366     function customTokenURI(uint256 _tokenId) public view returns (string memory){
1367         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1368         return bytes(customURI).length > 0
1369             ? string(abi.encodePacked(customURI, _tokenId.toString()))
1370             : '';
1371     }
1372 
1373     function getOwnedTokenIds(address _owner) public view returns(uint256[] memory tokenIds) {
1374         uint256 balanceOfOwner = balanceOf(_owner);
1375 
1376         tokenIds = new uint256[](balanceOfOwner);
1377             
1378         for(uint256 index = 0; index < balanceOfOwner; index++){
1379             tokenIds[index] = tokenOfOwnerByIndex(_owner, index);
1380         }
1381     }
1382 
1383     function getTokenIdsInCollection(uint256 _collectionNumber) public view returns(uint256[] memory tokenIds) {
1384 
1385         Collection storage collection = collections[_collectionNumber];
1386         require(collection.created, "Collection does not exist");
1387 
1388         uint256 totalMinted = collection.tokensMinted;
1389 
1390         tokenIds = new uint256[](totalMinted);
1391 
1392         for(uint256 index=0; index < totalMinted; index++){
1393             tokenIds[index] = (_collectionNumber * ONE_MILLION) + index + 1;
1394         }
1395     }
1396 }