1 // SPDX-License-Identifier: MIT
2 // File: utils/Context.sol
3 
4 pragma solidity ^0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: Ownable.sol
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: extensions/IERC165.sol
97 
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Interface of the ERC165 standard, as defined in the
103  * https://eips.ethereum.org/EIPS/eip-165[EIP].
104  *
105  * Implementers can declare support of contract interfaces, which can then be
106  * queried by others ({ERC165Checker}).
107  *
108  * For an implementation, see {ERC165}.
109  */
110 interface IERC165 {
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30 000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 }
121 
122 // File: extensions/IERC721.sol
123 
124 
125 pragma solidity ^0.8.0;
126 
127 
128 /**
129  * @dev Required interface of an ERC721 compliant contract.
130  */
131 interface IERC721 is IERC165 {
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     /**
148      * @dev Returns the number of tokens in ``owner``'s account.
149      */
150     function balanceOf(address owner) external view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function ownerOf(uint256 tokenId) external view returns (address owner);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(address from, address to, uint256 tokenId) external;
176 
177     /**
178      * @dev Transfers `tokenId` token from `from` to `to`.
179      *
180      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
181      *
182      * Requirements:
183      *
184      * - `from` cannot be the zero address.
185      * - `to` cannot be the zero address.
186      * - `tokenId` token must be owned by `from`.
187      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(address from, address to, uint256 tokenId) external;
192 
193     /**
194      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
195      * The approval is cleared when the token is transferred.
196      *
197      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
198      *
199      * Requirements:
200      *
201      * - The caller must own the token or be an approved operator.
202      * - `tokenId` must exist.
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address to, uint256 tokenId) external;
207 
208     /**
209      * @dev Returns the account approved for `tokenId` token.
210      *
211      * Requirements:
212      *
213      * - `tokenId` must exist.
214      */
215     function getApproved(uint256 tokenId) external view returns (address operator);
216 
217     /**
218      * @dev Approve or remove `operator` as an operator for the caller.
219      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
220      *
221      * Requirements:
222      *
223      * - The `operator` cannot be the caller.
224      *
225      * Emits an {ApprovalForAll} event.
226      */
227     function setApprovalForAll(address operator, bool _approved) external;
228 
229     /**
230      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
231      *
232      * See {setApprovalForAll}
233      */
234     function isApprovedForAll(address owner, address operator) external view returns (bool);
235 
236     /**
237       * @dev Safely transfers `tokenId` token from `from` to `to`.
238       *
239       * Requirements:
240       *
241       * - `from` cannot be the zero address.
242       * - `to` cannot be the zero address.
243       * - `tokenId` token must exist and be owned by `from`.
244       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
245       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
246       *
247       * Emits a {Transfer} event.
248       */
249     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
250 }
251 
252 // File: extensions/IERC721Receiver.sol
253 
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @title ERC721 token receiver interface
259  * @dev Interface for any contract that wants to support safeTransfers
260  * from ERC721 asset contracts.
261  */
262 interface IERC721Receiver {
263     /**
264      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
265      * by `operator` from `from`, this function is called.
266      *
267      * It must return its Solidity selector to confirm the token transfer.
268      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
269      *
270      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
271      */
272     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
273 }
274 
275 // File: extensions/IERC721Metadata.sol
276 
277 
278 pragma solidity ^0.8.0;
279 
280 
281 /**
282  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
283  * @dev See https://eips.ethereum.org/EIPS/eip-721
284  */
285 interface IERC721Metadata is IERC721 {
286 
287     /**
288      * @dev Returns the token collection name.
289      */
290     function name() external view returns (string memory);
291 
292     /**
293      * @dev Returns the token collection symbol.
294      */
295     function symbol() external view returns (string memory);
296 
297     /**
298      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
299      */
300     function tokenURI(uint256 tokenId) external view returns (string memory);
301 }
302 
303 // File: extensions/IERC721Enumerable.sol
304 
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
311  * @dev See https://eips.ethereum.org/EIPS/eip-721
312  */
313 interface IERC721Enumerable is IERC721 {
314 
315     /**
316      * @dev Returns the total amount of tokens stored by the contract.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     /**
321      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
322      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
323      */
324     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
325 
326     /**
327      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
328      * Use along with {totalSupply} to enumerate all tokens.
329      */
330     function tokenByIndex(uint256 index) external view returns (uint256);
331 }
332 
333 // File: extensions/ERC165.sol
334 
335 
336 pragma solidity ^0.8.0;
337 
338 
339 /**
340  * @dev Implementation of the {IERC165} interface.
341  *
342  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
343  * for the additional interface id that will be supported. For example:
344  *
345  * ```solidity
346  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
347  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
348  * }
349  * ```
350  *
351  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
352  */
353 abstract contract ERC165 is IERC165 {
354     /**
355      * @dev See {IERC165-supportsInterface}.
356      */
357     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
358         return interfaceId == type(IERC165).interfaceId;
359     }
360 }
361 
362 // File: utils/Address.sol
363 
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Collection of functions related to the address type
369  */
370 library Address {
371     /**
372      * @dev Returns true if `account` is a contract.
373      *
374      * [IMPORTANT]
375      * ====
376      * It is unsafe to assume that an address for which this function returns
377      * false is an externally-owned account (EOA) and not a contract.
378      *
379      * Among others, `isContract` will return false for the following
380      * types of addresses:
381      *
382      *  - an externally-owned account
383      *  - a contract in construction
384      *  - an address where a contract will be created
385      *  - an address where a contract lived, but was destroyed
386      * ====
387      */
388     function isContract(address account) internal view returns (bool) {
389         // This method relies on extcodesize, which returns 0 for contracts in
390         // construction, since the code is only stored at the end of the
391         // constructor execution.
392 
393         uint256 size;
394         // solhint-disable-next-line no-inline-assembly
395         assembly { size := extcodesize(account) }
396         return size > 0;
397     }
398 
399     /**
400      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
401      * `recipient`, forwarding all available gas and reverting on errors.
402      *
403      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
404      * of certain opcodes, possibly making contracts go over the 2300 gas limit
405      * imposed by `transfer`, making them unable to receive funds via
406      * `transfer`. {sendValue} removes this limitation.
407      *
408      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
409      *
410      * IMPORTANT: because control is transferred to `recipient`, care must be
411      * taken to not create reentrancy vulnerabilities. Consider using
412      * {ReentrancyGuard} or the
413      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
414      */
415     function sendValue(address payable recipient, uint256 amount) internal {
416         require(address(this).balance >= amount, "Address: insufficient balance");
417 
418         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
419         (bool success, ) = recipient.call{ value: amount }("");
420         require(success, "Address: unable to send value, recipient may have reverted");
421     }
422 
423     /**
424      * @dev Performs a Solidity function call using a low level `call`. A
425      * plain`call` is an unsafe replacement for a function call: use this
426      * function instead.
427      *
428      * If `target` reverts with a revert reason, it is bubbled up by this
429      * function (like regular Solidity function calls).
430      *
431      * Returns the raw returned data. To convert to the expected return value,
432      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
433      *
434      * Requirements:
435      *
436      * - `target` must be a contract.
437      * - calling `target` with `data` must not revert.
438      *
439      * _Available since v3.1._
440      */
441     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
442       return functionCall(target, data, "Address: low-level call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
447      * `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, 0, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but also transferring `value` wei to `target`.
458      *
459      * Requirements:
460      *
461      * - the calling contract must have an ETH balance of at least `value`.
462      * - the called Solidity function must be `payable`.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
472      * with `errorMessage` as a fallback revert reason when `target` reverts.
473      *
474      * _Available since v3.1._
475      */
476     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
477         require(address(this).balance >= value, "Address: insufficient balance for call");
478         require(isContract(target), "Address: call to non-contract");
479 
480         // solhint-disable-next-line avoid-low-level-calls
481         (bool success, bytes memory returndata) = target.call{ value: value }(data);
482         return _verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
492         return functionStaticCall(target, data, "Address: low-level static call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a static call.
498      *
499      * _Available since v3.3._
500      */
501     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
502         require(isContract(target), "Address: static call to non-contract");
503 
504         // solhint-disable-next-line avoid-low-level-calls
505         (bool success, bytes memory returndata) = target.staticcall(data);
506         return _verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a delegate call.
522      *
523      * _Available since v3.4._
524      */
525     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
526         require(isContract(target), "Address: delegate call to non-contract");
527 
528         // solhint-disable-next-line avoid-low-level-calls
529         (bool success, bytes memory returndata) = target.delegatecall(data);
530         return _verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 // solhint-disable-next-line no-inline-assembly
542                 assembly {
543                     let returndata_size := mload(returndata)
544                     revert(add(32, returndata), returndata_size)
545                 }
546             } else {
547                 revert(errorMessage);
548             }
549         }
550     }
551 }
552 
553 // File: utils/Strings.sol
554 
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev String operations.
560  */
561 library Strings {
562     bytes16 private constant alphabet = "0123456789abcdef";
563 
564     /**
565      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
566      */
567     function toString(uint256 value) internal pure returns (string memory) {
568         // Inspired by OraclizeAPI's implementation - MIT licence
569         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
570 
571         if (value == 0) {
572             return "0";
573         }
574         uint256 temp = value;
575         uint256 digits;
576         while (temp != 0) {
577             digits++;
578             temp /= 10;
579         }
580         bytes memory buffer = new bytes(digits);
581         while (value != 0) {
582             digits -= 1;
583             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
584             value /= 10;
585         }
586         return string(buffer);
587     }
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
591      */
592     function toHexString(uint256 value) internal pure returns (string memory) {
593         if (value == 0) {
594             return "0x00";
595         }
596         uint256 temp = value;
597         uint256 length = 0;
598         while (temp != 0) {
599             length++;
600             temp >>= 8;
601         }
602         return toHexString(value, length);
603     }
604 
605     /**
606      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
607      */
608     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
609         bytes memory buffer = new bytes(2 * length + 2);
610         buffer[0] = "0";
611         buffer[1] = "x";
612         for (uint256 i = 2 * length + 1; i > 1; --i) {
613             buffer[i] = alphabet[value & 0xf];
614             value >>= 4;
615         }
616         require(value == 0, "Strings: hex length insufficient");
617         return string(buffer);
618     }
619 
620 }
621 
622 // File: ERC721.sol
623 
624 
625 pragma solidity ^0.8.0;
626 
627 
628 
629 
630 
631 
632 
633 
634 
635 /**
636  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
637  * the Metadata extension, but not including the Enumerable extension, which is available separately as
638  * {ERC721Enumerable}.
639  */
640 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
641     using Address for address;
642     using Strings for uint256;
643 
644     // Token name
645     string private _name;
646 
647     // Token symbol
648     string private _symbol;
649 
650     // Mapping from token ID to owner address
651     mapping (uint256 => address) private _owners;
652 
653     // Mapping owner address to token count
654     mapping (address => uint256) private _balances;
655 
656     // Mapping from token ID to approved address
657     mapping (uint256 => address) private _tokenApprovals;
658 
659     // Mapping from owner to operator approvals
660     mapping (address => mapping (address => bool)) private _operatorApprovals;
661 
662     /**
663      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
664      */
665     constructor (string memory name_, string memory symbol_) {
666         _name = name_;
667         _symbol = symbol_;
668     }
669 
670     /**
671      * @dev See {IERC165-supportsInterface}.
672      */
673     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
674         return interfaceId == type(IERC721).interfaceId
675             || interfaceId == type(IERC721Metadata).interfaceId
676             || super.supportsInterface(interfaceId);
677     }
678 
679     /**
680      * @dev See {IERC721-balanceOf}.
681      */
682     function balanceOf(address owner) public view virtual override returns (uint256) {
683         require(owner != address(0), "ERC721: balance query for the zero address");
684         return _balances[owner];
685     }
686 
687     /**
688      * @dev See {IERC721-ownerOf}.
689      */
690     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
691         address owner = _owners[tokenId];
692         require(owner != address(0), "ERC721: owner query for nonexistent token");
693         return owner;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-name}.
698      */
699     function name() public view virtual override returns (string memory) {
700         return _name;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-symbol}.
705      */
706     function symbol() public view virtual override returns (string memory) {
707         return _symbol;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-tokenURI}.
712      */
713     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
714         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
715 
716         string memory baseURI = _baseURI();
717         return bytes(baseURI).length > 0
718             ? string(abi.encodePacked(baseURI, tokenId.toString()))
719             : '';
720     }
721 
722     /**
723      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
724      * in child contracts.
725      */
726     function _baseURI() internal view virtual returns (string memory) {
727         return "";
728     }
729 
730     /**
731      * @dev See {IERC721-approve}.
732      */
733     function approve(address to, uint256 tokenId) public virtual override {
734         address owner = ERC721.ownerOf(tokenId);
735         require(to != owner, "ERC721: approval to current owner");
736 
737         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
738             "ERC721: approve caller is not owner nor approved for all"
739         );
740 
741         _approve(to, tokenId);
742     }
743 
744     /**
745      * @dev See {IERC721-getApproved}.
746      */
747     function getApproved(uint256 tokenId) public view virtual override returns (address) {
748         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
749 
750         return _tokenApprovals[tokenId];
751     }
752 
753     /**
754      * @dev See {IERC721-setApprovalForAll}.
755      */
756     function setApprovalForAll(address operator, bool approved) public virtual override {
757         require(operator != _msgSender(), "ERC721: approve to caller");
758 
759         _operatorApprovals[_msgSender()][operator] = approved;
760         emit ApprovalForAll(_msgSender(), operator, approved);
761     }
762 
763     /**
764      * @dev See {IERC721-isApprovedForAll}.
765      */
766     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
767         return _operatorApprovals[owner][operator];
768     }
769 
770     /**
771      * @dev See {IERC721-transferFrom}.
772      */
773     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
774         //solhint-disable-next-line max-line-length
775         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
776 
777         _transfer(from, to, tokenId);
778     }
779 
780     /**
781      * @dev See {IERC721-safeTransferFrom}.
782      */
783     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
784         safeTransferFrom(from, to, tokenId, "");
785     }
786 
787     /**
788      * @dev See {IERC721-safeTransferFrom}.
789      */
790     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
791         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
792         _safeTransfer(from, to, tokenId, _data);
793     }
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
797      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
798      *
799      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
800      *
801      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
802      * implement alternative mechanisms to perform token transfer, such as signature-based.
803      *
804      * Requirements:
805      *
806      * - `from` cannot be the zero address.
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must exist and be owned by `from`.
809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
814         _transfer(from, to, tokenId);
815         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
816     }
817 
818     /**
819      * @dev Returns whether `tokenId` exists.
820      *
821      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
822      *
823      * Tokens start existing when they are minted (`_mint`),
824      * and stop existing when they are burned (`_burn`).
825      */
826     function _exists(uint256 tokenId) internal view virtual returns (bool) {
827         return _owners[tokenId] != address(0);
828     }
829 
830     /**
831      * @dev Returns whether `spender` is allowed to manage `tokenId`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      */
837     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
838         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
839         address owner = ERC721.ownerOf(tokenId);
840         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
841     }
842 
843     /**
844      * @dev Safely mints `tokenId` and transfers it to `to`.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must not exist.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _safeMint(address to, uint256 tokenId) internal virtual {
854         _safeMint(to, tokenId, "");
855     }
856 
857     /**
858      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
859      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
860      */
861     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
862         _mint(to, tokenId);
863         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
864     }
865 
866     /**
867      * @dev Mints `tokenId` and transfers it to `to`.
868      *
869      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
870      *
871      * Requirements:
872      *
873      * - `tokenId` must not exist.
874      * - `to` cannot be the zero address.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _mint(address to, uint256 tokenId) internal virtual {
879         require(to != address(0), "ERC721: mint to the zero address");
880         require(!_exists(tokenId), "ERC721: token already minted");
881 
882         _beforeTokenTransfer(address(0), to, tokenId);
883 
884         _balances[to] += 1;
885         _owners[tokenId] = to;
886 
887         emit Transfer(address(0), to, tokenId);
888     }
889 
890     /**
891      * @dev Destroys `tokenId`.
892      * The approval is cleared when the token is burned.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _burn(uint256 tokenId) internal virtual {
901         address owner = ERC721.ownerOf(tokenId);
902 
903         _beforeTokenTransfer(owner, address(0), tokenId);
904 
905         // Clear approvals
906         _approve(address(0), tokenId);
907 
908         _balances[owner] -= 1;
909         delete _owners[tokenId];
910 
911         emit Transfer(owner, address(0), tokenId);
912     }
913 
914     /**
915      * @dev Transfers `tokenId` from `from` to `to`.
916      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
917      *
918      * Requirements:
919      *
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must be owned by `from`.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _transfer(address from, address to, uint256 tokenId) internal virtual {
926         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
927         require(to != address(0), "ERC721: transfer to the zero address");
928 
929         _beforeTokenTransfer(from, to, tokenId);
930 
931         // Clear approvals from the previous owner
932         _approve(address(0), tokenId);
933 
934         _balances[from] -= 1;
935         _balances[to] += 1;
936         _owners[tokenId] = to;
937 
938         emit Transfer(from, to, tokenId);
939     }
940 
941     /**
942      * @dev Approve `to` to operate on `tokenId`
943      *
944      * Emits a {Approval} event.
945      */
946     function _approve(address to, uint256 tokenId) internal virtual {
947         _tokenApprovals[tokenId] = to;
948         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
949     }
950 
951     /**
952      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
953      * The call is not executed if the target address is not a contract.
954      *
955      * @param from address representing the previous owner of the given token ID
956      * @param to target address that will receive the tokens
957      * @param tokenId uint256 ID of the token to be transferred
958      * @param _data bytes optional data to send along with the call
959      * @return bool whether the call correctly returned the expected magic value
960      */
961     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
962         private returns (bool)
963     {
964         if (to.isContract()) {
965             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
966                 return retval == IERC721Receiver(to).onERC721Received.selector;
967             } catch (bytes memory reason) {
968                 if (reason.length == 0) {
969                     revert("ERC721: transfer to non ERC721Receiver implementer");
970                 } else {
971                     // solhint-disable-next-line no-inline-assembly
972                     assembly {
973                         revert(add(32, reason), mload(reason))
974                     }
975                 }
976             }
977         } else {
978             return true;
979         }
980     }
981 
982     /**
983      * @dev Hook that is called before any token transfer. This includes minting
984      * and burning.
985      *
986      * Calling conditions:
987      *
988      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
989      * transferred to `to`.
990      * - When `from` is zero, `tokenId` will be minted for `to`.
991      * - When `to` is zero, ``from``'s `tokenId` will be burned.
992      * - `from` cannot be the zero address.
993      * - `to` cannot be the zero address.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
998 }
999 
1000 // File: ERC721EnumerableSimple.sol
1001 
1002 pragma solidity ^0.8.0;
1003 
1004 
1005 
1006 
1007 /**
1008  * @dev This is a fork of openzeppelin ERC721Enumerable. It is gas-optimizated for NFT collection
1009  * with sequential token IDs. The updated part includes:
1010  * - replaced the array `_allToken`  with a simple uint `_totalSupply`,
1011  * - updated the functions `totalSupply` and `_beforeTokenTransfer`.
1012  */
1013 abstract contract ERC721EnumerableSimple is ERC721, IERC721Enumerable {
1014     // user => tokenId[]
1015     mapping(address => mapping(uint => uint)) private _ownedTokens;
1016 
1017     // tokenId => index of _ownedTokens[user] (used when changing token ownership)
1018     mapping(uint => uint) private _ownedTokensIndex;
1019 
1020     // current total amount of token minted
1021     uint private _totalSupply;
1022 
1023     /// @dev See {IERC165-supportsInterface}.
1024     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1025         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1026     }
1027 
1028     /// @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1029     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1030         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1031         return _ownedTokens[owner][index];
1032     }
1033 
1034     /// @dev See {IERC721Enumerable-totalSupply}.
1035     function totalSupply() public view virtual override returns (uint256) {
1036         return _totalSupply;
1037     }
1038 
1039     /// @dev See {IERC721Enumerable-tokenByIndex}.
1040     function tokenByIndex(uint index) public view virtual override returns (uint) {
1041         require(index < ERC721EnumerableSimple.totalSupply(), "ERC721Enumerable: global index out of bounds");
1042         return index;
1043     }
1044 
1045     /// @dev Hook that is called before any token transfer. This includes minting
1046     function _beforeTokenTransfer(
1047         address from,
1048         address to,
1049         uint tokenId
1050     ) internal virtual override {
1051         super._beforeTokenTransfer(from, to, tokenId);
1052 
1053         if (from == address(0)) {
1054             assert(tokenId == _totalSupply); // Ensure token is minted sequentially
1055             _totalSupply += 1;
1056         } else if (from != to) {
1057             _removeTokenFromOwnerEnumeration(from, tokenId);
1058         }
1059 
1060         if (to == address(0)) {
1061             // do nothing
1062         } else if (to != from) {
1063             _addTokenToOwnerEnumeration(to, tokenId);
1064         }
1065     }
1066 
1067     /**
1068      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1069      * @param to address representing the new owner of the given token ID
1070      * @param tokenId uint ID of the token to be added to the tokens list of the given address
1071      */
1072     function _addTokenToOwnerEnumeration(address to, uint tokenId) private {
1073         uint length = ERC721.balanceOf(to);
1074         _ownedTokens[to][length] = tokenId;
1075         _ownedTokensIndex[tokenId] = length;
1076     }
1077 
1078     /**
1079      * @dev See {ERC721Enumerable-_removeTokenFromOwnerEnumeration}.
1080      * @param from address representing the previous owner of the given token ID
1081      * @param tokenId uint ID of the token to be removed from the tokens list of the given address
1082      */
1083     function _removeTokenFromOwnerEnumeration(address from, uint tokenId) private {
1084         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1085         // then delete the last slot (swap and pop).
1086 
1087         uint lastTokenIndex = ERC721.balanceOf(from) - 1;
1088         uint tokenIndex = _ownedTokensIndex[tokenId];
1089 
1090         // When the token to delete is the last token, the swap operation is unnecessary
1091         if (tokenIndex != lastTokenIndex) {
1092             uint lastTokenId = _ownedTokens[from][lastTokenIndex];
1093 
1094             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1095             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1096         }
1097 
1098         // This also deletes the contents at the last position of the array
1099         delete _ownedTokensIndex[tokenId];
1100         delete _ownedTokens[from][lastTokenIndex];
1101     }
1102 }
1103 
1104 // File: LIBIDO.sol
1105 
1106 pragma solidity ^0.8.0;
1107 
1108 
1109 
1110 
1111 contract LIBIDO is ERC721EnumerableSimple, Ownable {
1112     // Maximum amount of NFTToken in existance. Ever.
1113     // uint public constant MAX_NFTTOKEN_SUPPLY = 10000;
1114 
1115     // The provenance hash of all NFTToken. (Root hash of all NFTToken hashes concatenated)
1116     string public constant METADATA_PROVENANCE_HASH =
1117         "F5E8F9752F537EB428B0DC3A3A0F6B3646417E6FBD79AEC314D19D41AC48AF79";
1118 
1119     // Bsae URI of NFTToken's metadata
1120     string private baseURI;
1121 
1122     constructor() ERC721("LIBIDO", "LIBIDO") {}
1123 
1124     function tokensOfOwner(address _owner) external view returns (uint[] memory) {
1125         uint tokenCount = balanceOf(_owner);
1126         if (tokenCount == 0) {
1127             return new uint[](0); // Return an empty array
1128         } else {
1129             uint[] memory result = new uint[](tokenCount);
1130             for (uint index = 0; index < tokenCount; index++) {
1131                 result[index] = tokenOfOwnerByIndex(_owner, index);
1132             }
1133             return result;
1134         }
1135     }
1136 
1137     function mint() public onlyOwner {
1138         uint _totalSupply = totalSupply();
1139 
1140         // require(_totalSupply <= MAX_NFTTOKEN_SUPPLY, "Exceeds maximum NFTToken supply");
1141 
1142         _safeMint(msg.sender, _totalSupply);
1143     }
1144 
1145     function _baseURI() internal view override returns (string memory) {
1146         return baseURI;
1147     }
1148 
1149     function setBaseURI(string memory __baseURI) public onlyOwner {
1150         baseURI = __baseURI;
1151     }
1152 
1153     function burn(uint256 tokenId) public {
1154         require(_isApprovedOrOwner(msg.sender, tokenId));
1155         _burn(tokenId);
1156     }
1157 }