1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-16
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
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
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Interface of the ERC20 standard as defined in the EIP.
592  */
593 interface IERC20 {
594 
595     /**
596      * @dev Returns the amount of tokens owned by `account`.
597      */
598     function balanceOf(address account) external view returns (uint256);
599 }
600 
601 pragma solidity ^0.8.0;
602 
603 
604 /**
605  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
606  * @dev See https://eips.ethereum.org/EIPS/eip-721
607  */
608 interface IERC721Metadata is IERC721 {
609     /**
610      * @dev Returns the token collection name.
611      */
612     function name() external view returns (string memory);
613 
614     /**
615      * @dev Returns the token collection symbol.
616      */
617     function symbol() external view returns (string memory);
618 
619     /**
620      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
621      */
622     function tokenURI(uint256 tokenId) external view returns (string memory);
623 }
624 pragma solidity ^0.8.0;
625 
626 
627 /**
628  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
629  * the Metadata extension, but not including the Enumerable extension, which is available separately as
630  * {ERC721Enumerable}.
631  */
632 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
633     using Address for address;
634     using Strings for uint256;
635 
636     // Token name
637     string private _name;
638 
639     // Token symbol
640     string private _symbol;
641 
642     // Mapping from token ID to owner address
643     mapping(uint256 => address) private _owners;
644 
645     // Mapping owner address to token count
646     mapping(address => uint256) private _balances;
647 
648     // Mapping from token ID to approved address
649     mapping(uint256 => address) private _tokenApprovals;
650 
651     // Mapping from owner to operator approvals
652     mapping(address => mapping(address => bool)) private _operatorApprovals;
653 
654     /**
655      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
656      */
657     constructor(string memory name_, string memory symbol_) {
658         _name = name_;
659         _symbol = symbol_;
660     }
661 
662     /**
663      * @dev See {IERC165-supportsInterface}.
664      */
665     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
666         return
667             interfaceId == type(IERC721).interfaceId ||
668             interfaceId == type(IERC721Metadata).interfaceId ||
669             super.supportsInterface(interfaceId);
670     }
671 
672     /**
673      * @dev See {IERC721-balanceOf}.
674      */
675     function balanceOf(address owner) public view virtual override returns (uint256) {
676         require(owner != address(0), "ERC721: balance query for the zero address");
677         return _balances[owner];
678     }
679 
680     /**
681      * @dev See {IERC721-ownerOf}.
682      */
683     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
684         address owner = _owners[tokenId];
685         require(owner != address(0), "ERC721: owner query for nonexistent token");
686         return owner;
687     }
688 
689     /**
690      * @dev See {IERC721Metadata-name}.
691      */
692     function name() public view virtual override returns (string memory) {
693         return _name;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-symbol}.
698      */
699     function symbol() public view virtual override returns (string memory) {
700         return _symbol;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-tokenURI}.
705      */
706     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
707         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
708 
709         string memory baseURI = _baseURI();
710         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
711     }
712 
713     /**
714      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
715      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
716      * by default, can be overriden in child contracts.
717      */
718     function _baseURI() internal view virtual returns (string memory) {
719         return "";
720     }
721 
722     /**
723      * @dev See {IERC721-approve}.
724      */
725     function approve(address to, uint256 tokenId) public virtual override {
726         address owner = ERC721.ownerOf(tokenId);
727         require(to != owner, "ERC721: approval to current owner");
728 
729         require(
730             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
731             "ERC721: approve caller is not owner nor approved for all"
732         );
733 
734         _approve(to, tokenId);
735     }
736 
737     /**
738      * @dev See {IERC721-getApproved}.
739      */
740     function getApproved(uint256 tokenId) public view virtual override returns (address) {
741         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
742 
743         return _tokenApprovals[tokenId];
744     }
745 
746     /**
747      * @dev See {IERC721-setApprovalForAll}.
748      */
749     function setApprovalForAll(address operator, bool approved) public virtual override {
750         require(operator != _msgSender(), "ERC721: approve to caller");
751 
752         _operatorApprovals[_msgSender()][operator] = approved;
753         emit ApprovalForAll(_msgSender(), operator, approved);
754     }
755 
756     /**
757      * @dev See {IERC721-isApprovedForAll}.
758      */
759     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
760         return _operatorApprovals[owner][operator];
761     }
762 
763     /**
764      * @dev See {IERC721-transferFrom}.
765      */
766     function transferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) public virtual override {
771         //solhint-disable-next-line max-line-length
772         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
773 
774         _transfer(from, to, tokenId);
775     }
776 
777     /**
778      * @dev See {IERC721-safeTransferFrom}.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) public virtual override {
785         safeTransferFrom(from, to, tokenId, "");
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) public virtual override {
797         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
798         _safeTransfer(from, to, tokenId, _data);
799     }
800 
801     /**
802      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
803      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
804      *
805      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
806      *
807      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
808      * implement alternative mechanisms to perform token transfer, such as signature-based.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must exist and be owned by `from`.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _safeTransfer(
820         address from,
821         address to,
822         uint256 tokenId,
823         bytes memory _data
824     ) internal virtual {
825         _transfer(from, to, tokenId);
826         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
827     }
828 
829     /**
830      * @dev Returns whether `tokenId` exists.
831      *
832      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
833      *
834      * Tokens start existing when they are minted (`_mint`),
835      * and stop existing when they are burned (`_burn`).
836      */
837     function _exists(uint256 tokenId) internal view virtual returns (bool) {
838         return _owners[tokenId] != address(0);
839     }
840 
841     /**
842      * @dev Returns whether `spender` is allowed to manage `tokenId`.
843      *
844      * Requirements:
845      *
846      * - `tokenId` must exist.
847      */
848     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
849         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
850         address owner = ERC721.ownerOf(tokenId);
851         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
852     }
853 
854     /**
855      * @dev Safely mints `tokenId` and transfers it to `to`.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must not exist.
860      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _safeMint(address to, uint256 tokenId) internal virtual {
865         _safeMint(to, tokenId, "");
866     }
867 
868     /**
869      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
870      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
871      */
872     function _safeMint(
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) internal virtual {
877         _mint(to, tokenId);
878         require(
879             _checkOnERC721Received(address(0), to, tokenId, _data),
880             "ERC721: transfer to non ERC721Receiver implementer"
881         );
882     }
883 
884     /**
885      * @dev Mints `tokenId` and transfers it to `to`.
886      *
887      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
888      *
889      * Requirements:
890      *
891      * - `tokenId` must not exist.
892      * - `to` cannot be the zero address.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _mint(address to, uint256 tokenId) internal virtual {
897         require(to != address(0), "ERC721: mint to the zero address");
898         require(!_exists(tokenId), "ERC721: token already minted");
899 
900         _beforeTokenTransfer(address(0), to, tokenId);
901 
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(address(0), to, tokenId);
906     }
907 
908     /**
909      * @dev Destroys `tokenId`.
910      * The approval is cleared when the token is burned.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _burn(uint256 tokenId) internal virtual {
919         address owner = ERC721.ownerOf(tokenId);
920 
921         _beforeTokenTransfer(owner, address(0), tokenId);
922 
923         // Clear approvals
924         _approve(address(0), tokenId);
925 
926         _balances[owner] -= 1;
927         delete _owners[tokenId];
928 
929         emit Transfer(owner, address(0), tokenId);
930     }
931 
932     /**
933      * @dev Transfers `tokenId` from `from` to `to`.
934      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
935      *
936      * Requirements:
937      *
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must be owned by `from`.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _transfer(
944         address from,
945         address to,
946         uint256 tokenId
947     ) internal virtual {
948         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
949         require(to != address(0), "ERC721: transfer to the zero address");
950 
951         _beforeTokenTransfer(from, to, tokenId);
952 
953         // Clear approvals from the previous owner
954         _approve(address(0), tokenId);
955 
956         _balances[from] -= 1;
957         _balances[to] += 1;
958         _owners[tokenId] = to;
959 
960         emit Transfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev Approve `to` to operate on `tokenId`
965      *
966      * Emits a {Approval} event.
967      */
968     function _approve(address to, uint256 tokenId) internal virtual {
969         _tokenApprovals[tokenId] = to;
970         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
971     }
972 
973     /**
974      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
975      * The call is not executed if the target address is not a contract.
976      *
977      * @param from address representing the previous owner of the given token ID
978      * @param to target address that will receive the tokens
979      * @param tokenId uint256 ID of the token to be transferred
980      * @param _data bytes optional data to send along with the call
981      * @return bool whether the call correctly returned the expected magic value
982      */
983     function _checkOnERC721Received(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) private returns (bool) {
989         if (to.isContract()) {
990             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
991                 return retval == IERC721Receiver.onERC721Received.selector;
992             } catch (bytes memory reason) {
993                 if (reason.length == 0) {
994                     revert("ERC721: transfer to non ERC721Receiver implementer");
995                 } else {
996                     assembly {
997                         revert(add(32, reason), mload(reason))
998                     }
999                 }
1000             }
1001         } else {
1002             return true;
1003         }
1004     }
1005 
1006     /**
1007      * @dev Hook that is called before any token transfer. This includes minting
1008      * and burning.
1009      *
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` will be minted for `to`.
1015      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1016      * - `from` and `to` are never both zero.
1017      *
1018      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1019      */
1020     function _beforeTokenTransfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) internal virtual {}
1025 }
1026 
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 
1031 contract AnimoonPotion is Ownable, ERC721 {
1032     
1033 
1034     uint constant maxSupply = 1000;
1035     uint public totalSupply = 0;
1036     bool public public_sale_status = false;
1037     uint public minimumrequired = 1;
1038     string public baseURI;
1039     uint public maxPerTransaction = 10;  //Max Limit for Sale
1040     uint public maxPerWallet = 10; //Max Limit perwallet
1041          
1042     constructor() ERC721("Animoon Potion 2", "Potion"){}
1043 
1044    function buy(uint _count) public payable {
1045          require(public_sale_status == true, "Sale is Paused.");
1046         require(_count <= maxPerTransaction, "mint limit is 10 tokens");
1047          require(checknftholder(msg.sender) >= minimumrequired, "You do not have enough Animoon nfts");
1048         require(balanceOf(msg.sender) < maxPerTransaction, "maximum limit reached");
1049         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1050         
1051         for(uint i = 0; i < _count; i++)
1052             _safeMint(msg.sender, totalSupply + 1 + i);
1053         totalSupply += _count;
1054     }
1055 
1056 
1057     function sendGifts(address[] memory _wallets) public onlyOwner{
1058         require(_wallets.length > 0, "mint at least one token");
1059         require(_wallets.length <= maxPerTransaction, "max per transaction 20");
1060         require(totalSupply + _wallets.length <= maxSupply, "not enough tokens left");
1061         for(uint i = 0; i < _wallets.length; i++)
1062             _safeMint(_wallets[i], totalSupply + 1 + i);
1063         totalSupply += _wallets.length;
1064     }
1065 
1066     function setBaseUri(string memory _uri) external onlyOwner {
1067         baseURI = _uri;
1068     }
1069 
1070     function publicSale_status(bool temp) external onlyOwner {
1071         public_sale_status = temp;
1072     }
1073     function _baseURI() internal view virtual override returns (string memory) {
1074         return baseURI;
1075     }
1076    function withdraw() external onlyOwner {
1077         payable(owner()).transfer(address(this).balance);
1078     }
1079 
1080  function checknftholder(address recnft) public view returns(uint) {
1081     address othercontractadd = 0x988a3e9834f1a4977e6F727E18EA167089349bA2;
1082     IERC20 tokenob = IERC20(othercontractadd);
1083     return tokenob.balanceOf(recnft);
1084   }
1085 
1086 }