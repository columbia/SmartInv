1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // File: @openzeppelin/contracts/utils/Context.sol
5 
6 /**
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
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _setOwner(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _setOwner(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _setOwner(newOwner);
85     }
86 
87     function _setOwner(address newOwner) private {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 
95 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
96 
97 /**
98  * @dev Interface of the ERC165 standard, as defined in the
99  * https://eips.ethereum.org/EIPS/eip-165[EIP].
100  *
101  * Implementers can declare support of contract interfaces, which can then be
102  * queried by others ({ERC165Checker}).
103  *
104  * For an implementation, see {ERC165}.
105  */
106 interface IERC165 {
107     /**
108      * @dev Returns true if this contract implements the interface defined by
109      * `interfaceId`. See the corresponding
110      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
111      * to learn more about how these ids are created.
112      *
113      * This function call must use less than 30 000 gas.
114      */
115     function supportsInterface(bytes4 interfaceId) external view returns (bool);
116 }
117 
118 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
119 
120 /**
121  * @dev Required interface of an ERC721 compliant contract.
122  */
123 interface IERC721 is IERC165 {
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
136      */
137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
138 
139     /**
140      * @dev Returns the number of tokens in ``owner``'s account.
141      */
142     function balanceOf(address owner) external view returns (uint256 balance);
143 
144     /**
145      * @dev Returns the owner of the `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function ownerOf(uint256 tokenId) external view returns (address owner);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
155      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId
171     ) external;
172 
173     /**
174      * @dev Transfers `tokenId` token from `from` to `to`.
175      *
176      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must be owned by `from`.
183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
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
237      * @dev Safely transfers `tokenId` token from `from` to `to`.
238      *
239      * Requirements:
240      *
241      * - `from` cannot be the zero address.
242      * - `to` cannot be the zero address.
243      * - `tokenId` token must exist and be owned by `from`.
244      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
245      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
246      *
247      * Emits a {Transfer} event.
248      */
249     function safeTransferFrom(
250         address from,
251         address to,
252         uint256 tokenId,
253         bytes calldata data
254     ) external;
255 }
256 
257 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
258 
259 /**
260  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
261  * @dev See https://eips.ethereum.org/EIPS/eip-721
262  */
263 interface IERC721Enumerable is IERC721 {
264     /**
265      * @dev Returns the total amount of tokens stored by the contract.
266      */
267     function totalSupply() external view returns (uint256);
268 
269     /**
270      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
271      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
272      */
273     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
274 
275     /**
276      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
277      * Use along with {totalSupply} to enumerate all tokens.
278      */
279     function tokenByIndex(uint256 index) external view returns (uint256);
280 }
281 
282 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
283 
284 
285 /**
286  * @dev Implementation of the {IERC165} interface.
287  *
288  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
289  * for the additional interface id that will be supported. For example:
290  *
291  * ```solidity
292  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
293  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
294  * }
295  * ```
296  *
297  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
298  */
299 abstract contract ERC165 is IERC165 {
300     /**
301      * @dev See {IERC165-supportsInterface}.
302      */
303     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
304         return interfaceId == type(IERC165).interfaceId;
305     }
306 }
307 
308 // File: @openzeppelin/contracts/utils/Strings.sol
309 
310 /**
311  * @dev String operations.
312  */
313 library Strings {
314     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
315 
316     /**
317      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
318      */
319     function toString(uint256 value) internal pure returns (string memory) {
320         // Inspired by OraclizeAPI's implementation - MIT licence
321         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
322 
323         if (value == 0) {
324             return "0";
325         }
326         uint256 temp = value;
327         uint256 digits;
328         while (temp != 0) {
329             digits++;
330             temp /= 10;
331         }
332         bytes memory buffer = new bytes(digits);
333         while (value != 0) {
334             digits -= 1;
335             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
336             value /= 10;
337         }
338         return string(buffer);
339     }
340 
341     /**
342      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
343      */
344     function toHexString(uint256 value) internal pure returns (string memory) {
345         if (value == 0) {
346             return "0x00";
347         }
348         uint256 temp = value;
349         uint256 length = 0;
350         while (temp != 0) {
351             length++;
352             temp >>= 8;
353         }
354         return toHexString(value, length);
355     }
356 
357     /**
358      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
359      */
360     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
361         bytes memory buffer = new bytes(2 * length + 2);
362         buffer[0] = "0";
363         buffer[1] = "x";
364         for (uint256 i = 2 * length + 1; i > 1; --i) {
365             buffer[i] = _HEX_SYMBOLS[value & 0xf];
366             value >>= 4;
367         }
368         require(value == 0, "Strings: hex length insufficient");
369         return string(buffer);
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Address.sol
374 
375 /**
376  * @dev Collection of functions related to the address type
377  */
378 library Address {
379     /**
380      * @dev Returns true if `account` is a contract.
381      *
382      * [IMPORTANT]
383      * ====
384      * It is unsafe to assume that an address for which this function returns
385      * false is an externally-owned account (EOA) and not a contract.
386      *
387      * Among others, `isContract` will return false for the following
388      * types of addresses:
389      *
390      *  - an externally-owned account
391      *  - a contract in construction
392      *  - an address where a contract will be created
393      *  - an address where a contract lived, but was destroyed
394      * ====
395      */
396     function isContract(address account) internal view returns (bool) {
397         // This method relies on extcodesize, which returns 0 for contracts in
398         // construction, since the code is only stored at the end of the
399         // constructor execution.
400 
401         uint256 size;
402         assembly {
403             size := extcodesize(account)
404         }
405         return size > 0;
406     }
407 
408     /**
409      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
410      * `recipient`, forwarding all available gas and reverting on errors.
411      *
412      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
413      * of certain opcodes, possibly making contracts go over the 2300 gas limit
414      * imposed by `transfer`, making them unable to receive funds via
415      * `transfer`. {sendValue} removes this limitation.
416      *
417      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
418      *
419      * IMPORTANT: because control is transferred to `recipient`, care must be
420      * taken to not create reentrancy vulnerabilities. Consider using
421      * {ReentrancyGuard} or the
422      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
423      */
424     function sendValue(address payable recipient, uint256 amount) internal {
425         require(address(this).balance >= amount, "Address: insufficient balance");
426 
427         (bool success, ) = recipient.call{value: amount}("");
428         require(success, "Address: unable to send value, recipient may have reverted");
429     }
430 
431     /**
432      * @dev Performs a Solidity function call using a low level `call`. A
433      * plain `call` is an unsafe replacement for a function call: use this
434      * function instead.
435      *
436      * If `target` reverts with a revert reason, it is bubbled up by this
437      * function (like regular Solidity function calls).
438      *
439      * Returns the raw returned data. To convert to the expected return value,
440      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
441      *
442      * Requirements:
443      *
444      * - `target` must be a contract.
445      * - calling `target` with `data` must not revert.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
450         return functionCall(target, data, "Address: low-level call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
455      * `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         return functionCallWithValue(target, data, 0, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but also transferring `value` wei to `target`.
470      *
471      * Requirements:
472      *
473      * - the calling contract must have an ETH balance of at least `value`.
474      * - the called Solidity function must be `payable`.
475      *
476      * _Available since v3.1._
477      */
478     function functionCallWithValue(
479         address target,
480         bytes memory data,
481         uint256 value
482     ) internal returns (bytes memory) {
483         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
488      * with `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCallWithValue(
493         address target,
494         bytes memory data,
495         uint256 value,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         require(address(this).balance >= value, "Address: insufficient balance for call");
499         require(isContract(target), "Address: call to non-contract");
500 
501         (bool success, bytes memory returndata) = target.call{value: value}(data);
502         return verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
507      * but performing a static call.
508      *
509      * _Available since v3.3._
510      */
511     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
512         return functionStaticCall(target, data, "Address: low-level static call failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(
522         address target,
523         bytes memory data,
524         string memory errorMessage
525     ) internal view returns (bytes memory) {
526         require(isContract(target), "Address: static call to non-contract");
527 
528         (bool success, bytes memory returndata) = target.staticcall(data);
529         return verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a delegate call.
535      *
536      * _Available since v3.4._
537      */
538     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
544      * but performing a delegate call.
545      *
546      * _Available since v3.4._
547      */
548     function functionDelegateCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         require(isContract(target), "Address: delegate call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.delegatecall(data);
556         return verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     /**
560      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
561      * revert reason using the provided one.
562      *
563      * _Available since v4.3._
564      */
565     function verifyCallResult(
566         bool success,
567         bytes memory returndata,
568         string memory errorMessage
569     ) internal pure returns (bytes memory) {
570         if (success) {
571             return returndata;
572         } else {
573             // Look for revert reason and bubble it up if present
574             if (returndata.length > 0) {
575                 // The easiest way to bubble the revert reason is using memory via assembly
576 
577                 assembly {
578                     let returndata_size := mload(returndata)
579                     revert(add(32, returndata), returndata_size)
580                 }
581             } else {
582                 revert(errorMessage);
583             }
584         }
585     }
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
589 
590 /**
591  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
592  * @dev See https://eips.ethereum.org/EIPS/eip-721
593  */
594 interface IERC721Metadata is IERC721 {
595     /**
596      * @dev Returns the token collection name.
597      */
598     function name() external view returns (string memory);
599 
600     /**
601      * @dev Returns the token collection symbol.
602      */
603     function symbol() external view returns (string memory);
604 
605     /**
606      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
607      */
608     function tokenURI(uint256 tokenId) external view returns (string memory);
609 }
610 
611 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
612 
613 /**
614  * @title ERC721 token receiver interface
615  * @dev Interface for any contract that wants to support safeTransfers
616  * from ERC721 asset contracts.
617  */
618 interface IERC721Receiver {
619     /**
620      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
621      * by `operator` from `from`, this function is called.
622      *
623      * It must return its Solidity selector to confirm the token transfer.
624      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
625      *
626      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
627      */
628     function onERC721Received(
629         address operator,
630         address from,
631         uint256 tokenId,
632         bytes calldata data
633     ) external returns (bytes4);
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
637 
638 /**
639  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
640  * the Metadata extension, but not including the Enumerable extension, which is available separately as
641  * {ERC721Enumerable}.
642  */
643 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
644     using Address for address;
645     using Strings for uint256;
646 
647     // Token name
648     string private _name;
649 
650     // Token symbol
651     string private _symbol;
652 
653     // Mapping from token ID to owner address
654     mapping(uint256 => address) private _owners;
655 
656     // Mapping owner address to token count
657     mapping(address => uint256) private _balances;
658 
659     // Mapping from token ID to approved address
660     mapping(uint256 => address) private _tokenApprovals;
661 
662     // Mapping from owner to operator approvals
663     mapping(address => mapping(address => bool)) private _operatorApprovals;
664 
665     /**
666      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
667      */
668     constructor(string memory name_, string memory symbol_) {
669         _name = name_;
670         _symbol = symbol_;
671     }
672 
673     /**
674      * @dev See {IERC165-supportsInterface}.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
677         return
678             interfaceId == type(IERC721).interfaceId ||
679             interfaceId == type(IERC721Metadata).interfaceId ||
680             super.supportsInterface(interfaceId);
681     }
682 
683     /**
684      * @dev See {IERC721-balanceOf}.
685      */
686     function balanceOf(address owner) public view virtual override returns (uint256) {
687         require(owner != address(0), "ERC721: balance query for the zero address");
688         return _balances[owner];
689     }
690 
691     /**
692      * @dev See {IERC721-ownerOf}.
693      */
694     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
695         address owner = _owners[tokenId];
696         require(owner != address(0), "ERC721: owner query for nonexistent token");
697         return owner;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-name}.
702      */
703     function name() public view virtual override returns (string memory) {
704         return _name;
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-symbol}.
709      */
710     function symbol() public view virtual override returns (string memory) {
711         return _symbol;
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-tokenURI}.
716      */
717     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
718         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
719 
720         string memory baseURI = _baseURI();
721         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
722     }
723 
724     /**
725      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
726      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
727      * by default, can be overriden in child contracts.
728      */
729     function _baseURI() internal view virtual returns (string memory) {
730         return "";
731     }
732 
733     /**
734      * @dev See {IERC721-approve}.
735      */
736     function approve(address to, uint256 tokenId) public virtual override {
737         address owner = ERC721.ownerOf(tokenId);
738         require(to != owner, "ERC721: approval to current owner");
739 
740         require(
741             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
742             "ERC721: approve caller is not owner nor approved for all"
743         );
744 
745         _approve(to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-getApproved}.
750      */
751     function getApproved(uint256 tokenId) public view virtual override returns (address) {
752         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
753 
754         return _tokenApprovals[tokenId];
755     }
756 
757     /**
758      * @dev See {IERC721-setApprovalForAll}.
759      */
760     function setApprovalForAll(address operator, bool approved) public virtual override {
761         require(operator != _msgSender(), "ERC721: approve to caller");
762 
763         _operatorApprovals[_msgSender()][operator] = approved;
764         emit ApprovalForAll(_msgSender(), operator, approved);
765     }
766 
767     /**
768      * @dev See {IERC721-isApprovedForAll}.
769      */
770     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
771         return _operatorApprovals[owner][operator];
772     }
773 
774     /**
775      * @dev See {IERC721-transferFrom}.
776      */
777     function transferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) public virtual override {
782         //solhint-disable-next-line max-line-length
783         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
784 
785         _transfer(from, to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) public virtual override {
796         safeTransferFrom(from, to, tokenId, "");
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) public virtual override {
808         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
809         _safeTransfer(from, to, tokenId, _data);
810     }
811 
812     /**
813      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
814      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
815      *
816      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
817      *
818      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
819      * implement alternative mechanisms to perform token transfer, such as signature-based.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must exist and be owned by `from`.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeTransfer(
831         address from,
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _transfer(from, to, tokenId);
837         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
838     }
839 
840     /**
841      * @dev Returns whether `tokenId` exists.
842      *
843      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
844      *
845      * Tokens start existing when they are minted (`_mint`),
846      * and stop existing when they are burned (`_burn`).
847      */
848     function _exists(uint256 tokenId) internal view virtual returns (bool) {
849         return _owners[tokenId] != address(0);
850     }
851 
852     /**
853      * @dev Returns whether `spender` is allowed to manage `tokenId`.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
860         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
861         address owner = ERC721.ownerOf(tokenId);
862         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
863     }
864 
865     /**
866      * @dev Safely mints `tokenId` and transfers it to `to`.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must not exist.
871      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _safeMint(address to, uint256 tokenId) internal virtual {
876         _safeMint(to, tokenId, "");
877     }
878 
879     /**
880      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
881      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
882      */
883     function _safeMint(
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) internal virtual {
888         _mint(to, tokenId);
889         require(
890             _checkOnERC721Received(address(0), to, tokenId, _data),
891             "ERC721: transfer to non ERC721Receiver implementer"
892         );
893     }
894 
895     /**
896      * @dev Mints `tokenId` and transfers it to `to`.
897      *
898      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - `to` cannot be the zero address.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _mint(address to, uint256 tokenId) internal virtual {
908         require(to != address(0), "ERC721: mint to the zero address");
909         require(!_exists(tokenId), "ERC721: token already minted");
910 
911         _beforeTokenTransfer(address(0), to, tokenId);
912 
913         _balances[to] += 1;
914         _owners[tokenId] = to;
915 
916         emit Transfer(address(0), to, tokenId);
917     }
918 
919     /**
920      * @dev Destroys `tokenId`.
921      * The approval is cleared when the token is burned.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must exist.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _burn(uint256 tokenId) internal virtual {
930         address owner = ERC721.ownerOf(tokenId);
931 
932         _beforeTokenTransfer(owner, address(0), tokenId);
933 
934         // Clear approvals
935         _approve(address(0), tokenId);
936 
937         _balances[owner] -= 1;
938         delete _owners[tokenId];
939 
940         emit Transfer(owner, address(0), tokenId);
941     }
942 
943     /**
944      * @dev Transfers `tokenId` from `from` to `to`.
945      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must be owned by `from`.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _transfer(
955         address from,
956         address to,
957         uint256 tokenId
958     ) internal virtual {
959         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
960         require(to != address(0), "ERC721: transfer to the zero address");
961 
962         _beforeTokenTransfer(from, to, tokenId);
963 
964         // Clear approvals from the previous owner
965         _approve(address(0), tokenId);
966 
967         _balances[from] -= 1;
968         _balances[to] += 1;
969         _owners[tokenId] = to;
970 
971         emit Transfer(from, to, tokenId);
972     }
973 
974     /**
975      * @dev Approve `to` to operate on `tokenId`
976      *
977      * Emits a {Approval} event.
978      */
979     function _approve(address to, uint256 tokenId) internal virtual {
980         _tokenApprovals[tokenId] = to;
981         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
982     }
983 
984     /**
985      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
986      * The call is not executed if the target address is not a contract.
987      *
988      * @param from address representing the previous owner of the given token ID
989      * @param to target address that will receive the tokens
990      * @param tokenId uint256 ID of the token to be transferred
991      * @param _data bytes optional data to send along with the call
992      * @return bool whether the call correctly returned the expected magic value
993      */
994     function _checkOnERC721Received(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) private returns (bool) {
1000         if (to.isContract()) {
1001             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1002                 return retval == IERC721Receiver.onERC721Received.selector;
1003             } catch (bytes memory reason) {
1004                 if (reason.length == 0) {
1005                     revert("ERC721: transfer to non ERC721Receiver implementer");
1006                 } else {
1007                     assembly {
1008                         revert(add(32, reason), mload(reason))
1009                     }
1010                 }
1011             }
1012         } else {
1013             return true;
1014         }
1015     }
1016 
1017     /**
1018      * @dev Hook that is called before any token transfer. This includes minting
1019      * and burning.
1020      *
1021      * Calling conditions:
1022      *
1023      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1024      * transferred to `to`.
1025      * - When `from` is zero, `tokenId` will be minted for `to`.
1026      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1027      * - `from` and `to` are never both zero.
1028      *
1029      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1030      */
1031     function _beforeTokenTransfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual {}
1036 }
1037 
1038 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1039 
1040 /**
1041  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1042  * enumerability of all the token ids in the contract as well as all token ids owned by each
1043  * account.
1044  */
1045 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1046     // Mapping from owner to list of owned token IDs
1047     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1048 
1049     // Mapping from token ID to index of the owner tokens list
1050     mapping(uint256 => uint256) private _ownedTokensIndex;
1051 
1052     // Array with all token ids, used for enumeration
1053     uint256[] private _allTokens;
1054 
1055     // Mapping from token id to position in the allTokens array
1056     mapping(uint256 => uint256) private _allTokensIndex;
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1062         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1067      */
1068     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1069         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1070         return _ownedTokens[owner][index];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Enumerable-totalSupply}.
1075      */
1076     function totalSupply() public view virtual override returns (uint256) {
1077         return _allTokens.length;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-tokenByIndex}.
1082      */
1083     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1084         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1085         return _allTokens[index];
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before any token transfer. This includes minting
1090      * and burning.
1091      *
1092      * Calling conditions:
1093      *
1094      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1095      * transferred to `to`.
1096      * - When `from` is zero, `tokenId` will be minted for `to`.
1097      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1098      * - `from` cannot be the zero address.
1099      * - `to` cannot be the zero address.
1100      *
1101      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1102      */
1103     function _beforeTokenTransfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) internal virtual override {
1108         super._beforeTokenTransfer(from, to, tokenId);
1109 
1110         if (from == address(0)) {
1111             _addTokenToAllTokensEnumeration(tokenId);
1112         } else if (from != to) {
1113             _removeTokenFromOwnerEnumeration(from, tokenId);
1114         }
1115         if (to == address(0)) {
1116             _removeTokenFromAllTokensEnumeration(tokenId);
1117         } else if (to != from) {
1118             _addTokenToOwnerEnumeration(to, tokenId);
1119         }
1120     }
1121 
1122     /**
1123      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1124      * @param to address representing the new owner of the given token ID
1125      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1126      */
1127     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1128         uint256 length = ERC721.balanceOf(to);
1129         _ownedTokens[to][length] = tokenId;
1130         _ownedTokensIndex[tokenId] = length;
1131     }
1132 
1133     /**
1134      * @dev Private function to add a token to this extension's token tracking data structures.
1135      * @param tokenId uint256 ID of the token to be added to the tokens list
1136      */
1137     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1138         _allTokensIndex[tokenId] = _allTokens.length;
1139         _allTokens.push(tokenId);
1140     }
1141 
1142     /**
1143      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1144      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1145      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1146      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1147      * @param from address representing the previous owner of the given token ID
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1149      */
1150     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1151         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1155         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary
1158         if (tokenIndex != lastTokenIndex) {
1159             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1160 
1161             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1162             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1163         }
1164 
1165         // This also deletes the contents at the last position of the array
1166         delete _ownedTokensIndex[tokenId];
1167         delete _ownedTokens[from][lastTokenIndex];
1168     }
1169 
1170     /**
1171      * @dev Private function to remove a token from this extension's token tracking data structures.
1172      * This has O(1) time complexity, but alters the order of the _allTokens array.
1173      * @param tokenId uint256 ID of the token to be removed from the tokens list
1174      */
1175     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1176         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1177         // then delete the last slot (swap and pop).
1178 
1179         uint256 lastTokenIndex = _allTokens.length - 1;
1180         uint256 tokenIndex = _allTokensIndex[tokenId];
1181 
1182         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1183         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1184         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1185         uint256 lastTokenId = _allTokens[lastTokenIndex];
1186 
1187         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1188         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1189 
1190         // This also deletes the contents at the last position of the array
1191         delete _allTokensIndex[tokenId];
1192         _allTokens.pop();
1193     }
1194 }
1195 
1196 
1197 contract m101Shelter is ERC721Enumerable, Ownable{
1198     uint public constant MAX_NFTS = 10101;
1199     bool public presalePaused = true;
1200 	bool public paused = true;
1201 	string _baseTokenURI = "https://metadata/";
1202 	uint private price;
1203 	uint private maxCount = 10;
1204 	mapping (address => uint) private wihiteList;
1205 
1206     constructor() ERC721("M101Shelter", "M101Shelter")  {
1207 
1208     }
1209 
1210     function mint(address _to, uint _count) public payable {
1211         require(!paused || !presalePaused, "Pause");
1212         if (!presalePaused){
1213             require(inWhiteListCount(msg.sender) > 0, "Sender not found in  White List");
1214             require(inWhiteListCount(msg.sender) - _count >= 0, "Max presale limit");
1215         }
1216         require(_count <= getMaxCount(), "Transaction limit exceeded");
1217         require(msg.value >= getPrice(_count), "Value below price");
1218         require(totalSupply() + _count <= MAX_NFTS, "Max limit");
1219         require(totalSupply() < MAX_NFTS, "Sale end");
1220         
1221         for(uint i = 0; i < _count; i++){
1222             _safeMint(_to, totalSupply());
1223         }
1224         
1225         if (!presalePaused){
1226             wihiteList[msg.sender] = wihiteList[msg.sender]  - _count;
1227         }
1228     }
1229     
1230     function inWhiteListCount(address _address) public view returns (uint) {
1231         return wihiteList[_address];
1232     }
1233     
1234     function addToWhiteList(address[] memory _addreses) external onlyOwner {
1235         for(uint i = 0; i < _addreses.length; i++){
1236             wihiteList[_addreses[i]] = 3;
1237         }
1238     }
1239     
1240     function deleteFromWhiteList(address[] memory _addreses) external onlyOwner {
1241         for(uint i = 0; i < _addreses.length; i++){
1242             wihiteList[_addreses[i]] = 0;
1243         }
1244     }
1245     
1246     function getPrice(uint _count) public view returns (uint256) {
1247         return _count * price;
1248     }
1249     
1250     function setPrice(uint _price) external onlyOwner {
1251         price = _price;
1252     }
1253     
1254     function getMaxCount() public view returns (uint256) {
1255         return maxCount;
1256     }
1257     
1258     function setMaxCount(uint _count) external onlyOwner {
1259         maxCount = _count;
1260     }
1261     
1262         
1263     function _baseURI() internal view virtual override returns (string memory) {
1264         return _baseTokenURI;
1265     }
1266     
1267     function setBaseURI(string memory baseURI) public onlyOwner {
1268         _baseTokenURI = baseURI;
1269     }
1270 
1271     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1272         uint tokenCount = balanceOf(_owner);
1273         uint256[] memory tokensId = new uint256[](tokenCount);
1274         for(uint i = 0; i < tokenCount; i++){
1275             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1276         }
1277         return tokensId;
1278     }
1279     
1280     function pause(bool val) public onlyOwner {
1281         paused = val;
1282     }
1283     
1284     function pausePresale(bool val) public onlyOwner {
1285         presalePaused = val;
1286     }
1287 
1288     function withdrawAll() public payable onlyOwner {
1289         require(payable(msg.sender).send(address(this).balance));
1290     }
1291     
1292 }