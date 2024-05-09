1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 //Developer Info:
5 //Written by Blockchainguy.net
6 //Email: info@blockchainguy.net
7 //Instagram: @sheraz.manzoor
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev String operations.
32  */
33 library Strings {
34     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
38      */
39     function toString(uint256 value) internal pure returns (string memory) {
40         // Inspired by OraclizeAPI's implementation - MIT licence
41         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
42 
43         if (value == 0) {
44             return "0";
45         }
46         uint256 temp = value;
47         uint256 digits;
48         while (temp != 0) {
49             digits++;
50             temp /= 10;
51         }
52         bytes memory buffer = new bytes(digits);
53         while (value != 0) {
54             digits -= 1;
55             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
56             value /= 10;
57         }
58         return string(buffer);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
63      */
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
79      */
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 }
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize, which returns 0 for contracts in
117         // construction, since the code is only stored at the end of the
118         // constructor execution.
119 
120         uint256 size;
121         assembly {
122             size := extcodesize(account)
123         }
124         return size > 0;
125     }
126 
127     /**
128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
129      * `recipient`, forwarding all available gas and reverting on errors.
130      *
131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
133      * imposed by `transfer`, making them unable to receive funds via
134      * `transfer`. {sendValue} removes this limitation.
135      *
136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
137      *
138      * IMPORTANT: because control is transferred to `recipient`, care must be
139      * taken to not create reentrancy vulnerabilities. Consider using
140      * {ReentrancyGuard} or the
141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
142      */
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain `call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal view returns (bytes memory) {
245         require(isContract(target), "Address: static call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.staticcall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(isContract(target), "Address: delegate call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.delegatecall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
280      * revert reason using the provided one.
281      *
282      * _Available since v4.3._
283      */
284     function verifyCallResult(
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal pure returns (bytes memory) {
289         if (success) {
290             return returndata;
291         } else {
292             // Look for revert reason and bubble it up if present
293             if (returndata.length > 0) {
294                 // The easiest way to bubble the revert reason is using memory via assembly
295 
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @dev Interface of the ERC165 standard, as defined in the
310  * https://eips.ethereum.org/EIPS/eip-165[EIP].
311  *
312  * Implementers can declare support of contract interfaces, which can then be
313  * queried by others ({ERC165Checker}).
314  *
315  * For an implementation, see {ERC165}.
316  */
317 interface IERC165 {
318     /**
319      * @dev Returns true if this contract implements the interface defined by
320      * `interfaceId`. See the corresponding
321      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
322      * to learn more about how these ids are created.
323      *
324      * This function call must use less than 30 000 gas.
325      */
326     function supportsInterface(bytes4 interfaceId) external view returns (bool);
327 }
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @title ERC721 token receiver interface
332  * @dev Interface for any contract that wants to support safeTransfers
333  * from ERC721 asset contracts.
334  */
335 interface IERC721Receiver {
336     /**
337      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
338      * by `operator` from `from`, this function is called.
339      *
340      * It must return its Solidity selector to confirm the token transfer.
341      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
342      *
343      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
344      */
345     function onERC721Received(
346         address operator,
347         address from,
348         uint256 tokenId,
349         bytes calldata data
350     ) external returns (bytes4);
351 }
352 pragma solidity ^0.8.0;
353 
354 
355 /**
356  * @dev Contract module which provides a basic access control mechanism, where
357  * there is an account (an owner) that can be granted exclusive access to
358  * specific functions.
359  *
360  * By default, the owner account will be the one that deploys the contract. This
361  * can later be changed with {transferOwnership}.
362  *
363  * This module is used through inheritance. It will make available the modifier
364  * `onlyOwner`, which can be applied to your functions to restrict their use to
365  * the owner.
366  */
367 abstract contract Ownable is Context {
368     address private _owner;
369 
370     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372     /**
373      * @dev Initializes the contract setting the deployer as the initial owner.
374      */
375     constructor() {
376         _setOwner(_msgSender());
377     }
378 
379     /**
380      * @dev Returns the address of the current owner.
381      */
382     function owner() public view virtual returns (address) {
383         return _owner;
384     }
385 
386     /**
387      * @dev Throws if called by any account other than the owner.
388      */
389     modifier onlyOwner() {
390         require(owner() == _msgSender(), "Ownable: caller is not the owner");
391         _;
392     }
393 
394     /**
395      * @dev Leaves the contract without owner. It will not be possible to call
396      * `onlyOwner` functions anymore. Can only be called by the current owner.
397      *
398      * NOTE: Renouncing ownership will leave the contract without an owner,
399      * thereby removing any functionality that is only available to the owner.
400      */
401     function renounceOwnership() public virtual onlyOwner {
402         _setOwner(address(0));
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      * Can only be called by the current owner.
408      */
409     function transferOwnership(address newOwner) public virtual onlyOwner {
410         require(newOwner != address(0), "Ownable: new owner is the zero address");
411         _setOwner(newOwner);
412     }
413 
414     function _setOwner(address newOwner) private {
415         address oldOwner = _owner;
416         _owner = newOwner;
417         emit OwnershipTransferred(oldOwner, newOwner);
418     }
419 }
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Implementation of the {IERC165} interface.
425  *
426  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
427  * for the additional interface id that will be supported. For example:
428  *
429  * ```solidity
430  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
432  * }
433  * ```
434  *
435  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
436  */
437 abstract contract ERC165 is IERC165 {
438     /**
439      * @dev See {IERC165-supportsInterface}.
440      */
441     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
442         return interfaceId == type(IERC165).interfaceId;
443     }
444 }
445 pragma solidity ^0.8.0;
446 
447 
448 /**
449  * @dev Required interface of an ERC721 compliant contract.
450  */
451 interface IERC721 is IERC165 {
452     /**
453      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
454      */
455     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
459      */
460     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
461 
462     /**
463      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
464      */
465     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
466 
467     /**
468      * @dev Returns the number of tokens in ``owner``'s account.
469      */
470     function balanceOf(address owner) external view returns (uint256 balance);
471 
472     /**
473      * @dev Returns the owner of the `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function ownerOf(uint256 tokenId) external view returns (address owner);
480 
481     /**
482      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
483      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must exist and be owned by `from`.
490      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
491      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
492      *
493      * Emits a {Transfer} event.
494      */
495     function safeTransferFrom(
496         address from,
497         address to,
498         uint256 tokenId
499     ) external;
500 
501     /**
502      * @dev Transfers `tokenId` token from `from` to `to`.
503      *
504      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must be owned by `from`.
511      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
512      *
513      * Emits a {Transfer} event.
514      */
515     function transferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     /**
522      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
523      * The approval is cleared when the token is transferred.
524      *
525      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
526      *
527      * Requirements:
528      *
529      * - The caller must own the token or be an approved operator.
530      * - `tokenId` must exist.
531      *
532      * Emits an {Approval} event.
533      */
534     function approve(address to, uint256 tokenId) external;
535 
536     /**
537      * @dev Returns the account approved for `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function getApproved(uint256 tokenId) external view returns (address operator);
544 
545     /**
546      * @dev Approve or remove `operator` as an operator for the caller.
547      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
548      *
549      * Requirements:
550      *
551      * - The `operator` cannot be the caller.
552      *
553      * Emits an {ApprovalForAll} event.
554      */
555     function setApprovalForAll(address operator, bool _approved) external;
556 
557     /**
558      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
559      *
560      * See {setApprovalForAll}
561      */
562     function isApprovedForAll(address owner, address operator) external view returns (bool);
563 
564     /**
565      * @dev Safely transfers `tokenId` token from `from` to `to`.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId,
581         bytes calldata data
582     ) external;
583 }
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
589  * @dev See https://eips.ethereum.org/EIPS/eip-721
590  */
591 interface IERC721Metadata is IERC721 {
592     /**
593      * @dev Returns the token collection name.
594      */
595     function name() external view returns (string memory);
596 
597     /**
598      * @dev Returns the token collection symbol.
599      */
600     function symbol() external view returns (string memory);
601 
602     /**
603      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
604      */
605     function tokenURI(uint256 tokenId) external view returns (string memory);
606 }
607 pragma solidity ^0.8.0;
608 
609 
610 /**
611  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
612  * the Metadata extension, but not including the Enumerable extension, which is available separately as
613  * {ERC721Enumerable}.
614  */
615 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
616     using Address for address;
617     using Strings for uint256;
618 
619     // Token name
620     string private _name;
621 
622     // Token symbol
623     string private _symbol;
624 
625     // Mapping from token ID to owner address
626     mapping(uint256 => address) private _owners;
627 
628     // Mapping owner address to token count
629     mapping(address => uint256) private _balances;
630 
631     // Mapping from token ID to approved address
632     mapping(uint256 => address) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     /**
638      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
639      */
640     constructor(string memory name_, string memory symbol_) {
641         _name = name_;
642         _symbol = symbol_;
643     }
644 
645     /**
646      * @dev See {IERC165-supportsInterface}.
647      */
648     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
649         return
650             interfaceId == type(IERC721).interfaceId ||
651             interfaceId == type(IERC721Metadata).interfaceId ||
652             super.supportsInterface(interfaceId);
653     }
654 
655     /**
656      * @dev See {IERC721-balanceOf}.
657      */
658     function balanceOf(address owner) public view virtual override returns (uint256) {
659         require(owner != address(0), "ERC721: balance query for the zero address");
660         return _balances[owner];
661     }
662 
663     /**
664      * @dev See {IERC721-ownerOf}.
665      */
666     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
667         address owner = _owners[tokenId];
668         require(owner != address(0), "ERC721: owner query for nonexistent token");
669         return owner;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-name}.
674      */
675     function name() public view virtual override returns (string memory) {
676         return _name;
677     }
678 
679     /**
680      * @dev See {IERC721Metadata-symbol}.
681      */
682     function symbol() public view virtual override returns (string memory) {
683         return _symbol;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-tokenURI}.
688      */
689     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
690         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
691 
692         string memory baseURI = _baseURI();
693         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
694     }
695 
696     /**
697      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
698      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
699      * by default, can be overriden in child contracts.
700      */
701     function _baseURI() internal view virtual returns (string memory) {
702         return "";
703     }
704 
705     /**
706      * @dev See {IERC721-approve}.
707      */
708     function approve(address to, uint256 tokenId) public virtual override {
709         address owner = ERC721.ownerOf(tokenId);
710         require(to != owner, "ERC721: approval to current owner");
711 
712         require(
713             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
714             "ERC721: approve caller is not owner nor approved for all"
715         );
716 
717         _approve(to, tokenId);
718     }
719 
720     /**
721      * @dev See {IERC721-getApproved}.
722      */
723     function getApproved(uint256 tokenId) public view virtual override returns (address) {
724         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
725 
726         return _tokenApprovals[tokenId];
727     }
728 
729     /**
730      * @dev See {IERC721-setApprovalForAll}.
731      */
732     function setApprovalForAll(address operator, bool approved) public virtual override {
733         require(operator != _msgSender(), "ERC721: approve to caller");
734 
735         _operatorApprovals[_msgSender()][operator] = approved;
736         emit ApprovalForAll(_msgSender(), operator, approved);
737     }
738 
739     /**
740      * @dev See {IERC721-isApprovedForAll}.
741      */
742     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
743         return _operatorApprovals[owner][operator];
744     }
745 
746     /**
747      * @dev See {IERC721-transferFrom}.
748      */
749     function transferFrom(
750         address from,
751         address to,
752         uint256 tokenId
753     ) public virtual override {
754         //solhint-disable-next-line max-line-length
755         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
756 
757         _transfer(from, to, tokenId);
758     }
759 
760     /**
761      * @dev See {IERC721-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId
767     ) public virtual override {
768         safeTransferFrom(from, to, tokenId, "");
769     }
770 
771     /**
772      * @dev See {IERC721-safeTransferFrom}.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) public virtual override {
780         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
781         _safeTransfer(from, to, tokenId, _data);
782     }
783 
784     /**
785      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
786      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
787      *
788      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
789      *
790      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
791      * implement alternative mechanisms to perform token transfer, such as signature-based.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _safeTransfer(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) internal virtual {
808         _transfer(from, to, tokenId);
809         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
810     }
811 
812     /**
813      * @dev Returns whether `tokenId` exists.
814      *
815      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
816      *
817      * Tokens start existing when they are minted (`_mint`),
818      * and stop existing when they are burned (`_burn`).
819      */
820     function _exists(uint256 tokenId) internal view virtual returns (bool) {
821         return _owners[tokenId] != address(0);
822     }
823 
824     /**
825      * @dev Returns whether `spender` is allowed to manage `tokenId`.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must exist.
830      */
831     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
832         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
833         address owner = ERC721.ownerOf(tokenId);
834         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
835     }
836 
837     /**
838      * @dev Safely mints `tokenId` and transfers it to `to`.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must not exist.
843      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _safeMint(address to, uint256 tokenId) internal virtual {
848         _safeMint(to, tokenId, "");
849     }
850 
851     /**
852      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
853      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
854      */
855     function _safeMint(
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) internal virtual {
860         _mint(to, tokenId);
861         require(
862             _checkOnERC721Received(address(0), to, tokenId, _data),
863             "ERC721: transfer to non ERC721Receiver implementer"
864         );
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
926     function _transfer(
927         address from,
928         address to,
929         uint256 tokenId
930     ) internal virtual {
931         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
932         require(to != address(0), "ERC721: transfer to the zero address");
933 
934         _beforeTokenTransfer(from, to, tokenId);
935 
936         // Clear approvals from the previous owner
937         _approve(address(0), tokenId);
938 
939         _balances[from] -= 1;
940         _balances[to] += 1;
941         _owners[tokenId] = to;
942 
943         emit Transfer(from, to, tokenId);
944     }
945 
946     /**
947      * @dev Approve `to` to operate on `tokenId`
948      *
949      * Emits a {Approval} event.
950      */
951     function _approve(address to, uint256 tokenId) internal virtual {
952         _tokenApprovals[tokenId] = to;
953         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
954     }
955 
956     /**
957      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
958      * The call is not executed if the target address is not a contract.
959      *
960      * @param from address representing the previous owner of the given token ID
961      * @param to target address that will receive the tokens
962      * @param tokenId uint256 ID of the token to be transferred
963      * @param _data bytes optional data to send along with the call
964      * @return bool whether the call correctly returned the expected magic value
965      */
966     function _checkOnERC721Received(
967         address from,
968         address to,
969         uint256 tokenId,
970         bytes memory _data
971     ) private returns (bool) {
972         if (to.isContract()) {
973             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
974                 return retval == IERC721Receiver.onERC721Received.selector;
975             } catch (bytes memory reason) {
976                 if (reason.length == 0) {
977                     revert("ERC721: transfer to non ERC721Receiver implementer");
978                 } else {
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
999      * - `from` and `to` are never both zero.
1000      *
1001      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1002      */
1003     function _beforeTokenTransfer(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) internal virtual {}
1008 }pragma solidity ^0.8.0;
1009 
1010 
1011 contract tokenpuss is Ownable, ERC721 {
1012     uint public tokenPrice = 0.05 ether;
1013     uint public maxSupply = 10133;
1014     
1015     uint public totalSupply = 0;
1016     
1017     uint public sale_startTime = 1639332000;
1018     uint public presale_startTime = 1639245600;
1019     bool public pause_sale = false;
1020 
1021     address public dev_wallet = 0xBAa6F3dDaCa46cD0F5e882f0DdA8391bB58Ffd70;
1022 
1023     string public baseURI;
1024     mapping(address => bool) private presaleList;
1025     constructor() ERC721("Tokenpuss", "TT"){}
1026 
1027    function buy(uint _count) public payable{
1028         require(_count > 0, "mint at least one token");
1029         require(_count <= 10, "Max 10 Allowed.");
1030         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1031         require(msg.value == tokenPrice * _count, "incorrect ether amount");
1032         require(block.timestamp >= sale_startTime,"Sale not Started Yet.");
1033         require(pause_sale == false, "Sale is Paused.");
1034         
1035         for(uint i = 0; i < _count; i++)
1036             _safeMint(msg.sender, totalSupply + 1 + i);
1037             
1038             totalSupply += _count;
1039     }
1040    function buy_Presale(uint _count) public payable{
1041         require(_count > 0, "mint at least one token");
1042         require(_count <= 10, "Max 10 Allowed.");
1043         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1044         require(msg.value == tokenPrice * _count, "incorrect ether amount");
1045         require(block.timestamp >= presale_startTime,"Presale have not started yet.");
1046         require(block.timestamp < sale_startTime,"Presale Ended.");
1047         require(pause_sale == false, "Sale is Paused.");
1048 
1049         
1050         
1051         for(uint i = 0; i < _count; i++)
1052             _safeMint(msg.sender, totalSupply + 1 + i);
1053             
1054             totalSupply += _count;
1055     }
1056     function sendGifts(address[] memory _wallets) public onlyOwner{
1057         require(totalSupply + _wallets.length <= maxSupply, "not enough tokens left");
1058         for(uint i = 0; i < _wallets.length; i++)
1059             _safeMint(_wallets[i], totalSupply + 1 + i);
1060         totalSupply += _wallets.length;
1061     }
1062 
1063     function addPresaleList(address[] memory _wallets) public onlyOwner{
1064         for(uint i; i < _wallets.length; i++)
1065             presaleList[_wallets[i]] = true;
1066     }
1067 
1068     function setBaseUri(string memory _uri) external onlyOwner {
1069         baseURI = _uri;
1070     }
1071     function setPauseSale(bool temp) external onlyOwner {
1072         pause_sale = temp;
1073     }
1074     
1075     function set_tokenPrice(uint256 _price) external onlyOwner{
1076         tokenPrice = _price;
1077     }    
1078     function _baseURI() internal view virtual override returns (string memory) {
1079         return baseURI;
1080     }
1081     function set_start_time(uint256 time) external onlyOwner{
1082         sale_startTime = time;
1083     }
1084     function change_dev_Wallet(address _wallet) external{
1085         require(msg.sender == dev_wallet , "You are not developer.");
1086         dev_wallet = _wallet;
1087     } 
1088     function set_max_supply(uint _limit) external onlyOwner{
1089         maxSupply = _limit;
1090     }  
1091     function set_total_supply(uint _limit) external onlyOwner{
1092         totalSupply = _limit;
1093     }    
1094     function withdraw() external onlyOwner {
1095         uint _balance = address(this).balance;
1096         payable(dev_wallet).transfer(_balance * 5 / 100);
1097         payable(owner()).transfer(_balance * 95 / 100);
1098 
1099     }
1100 }