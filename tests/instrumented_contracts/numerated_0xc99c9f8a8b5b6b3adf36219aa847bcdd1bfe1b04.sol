1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 
73 /**
74  * @dev Provides information about the current execution context, including the
75  * sender of the transaction and its data. While these are generally available
76  * via msg.sender and msg.data, they should not be accessed in such a direct
77  * manner, since when dealing with meta-transactions the account sending and
78  * paying for execution may not be the actual sender (as far as an application
79  * is concerned).
80  *
81  * This contract is only required for intermediate, library-like contracts.
82  */
83 abstract contract Context {
84     function _msgSender() internal view virtual returns (address) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view virtual returns (bytes calldata) {
89         return msg.data;
90     }
91 }
92 
93 // File: @openzeppelin/contracts/access/Ownable.sol
94 
95 
96 
97 /**
98  * @dev Contract module which provides a basic access control mechanism, where
99  * there is an account (an owner) that can be granted exclusive access to
100  * specific functions.
101  *
102  * By default, the owner account will be the one that deploys the contract. This
103  * can later be changed with {transferOwnership}.
104  *
105  * This module is used through inheritance. It will make available the modifier
106  * `onlyOwner`, which can be applied to your functions to restrict their use to
107  * the owner.
108  */
109 abstract contract Ownable is Context {
110     address private _owner;
111 
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     /**
115      * @dev Initializes the contract setting the deployer as the initial owner.
116      */
117     constructor() {
118         _setOwner(_msgSender());
119     }
120 
121     /**
122      * @dev Returns the address of the current owner.
123      */
124     function owner() public view virtual returns (address) {
125         return _owner;
126     }
127 
128     /**
129      * @dev Throws if called by any account other than the owner.
130      */
131     modifier onlyOwner() {
132         require(owner() == _msgSender(), "Ownable: caller is not the owner");
133         _;
134     }
135 
136     /**
137      * @dev Leaves the contract without owner. It will not be possible to call
138      * `onlyOwner` functions anymore. Can only be called by the current owner.
139      *
140      * NOTE: Renouncing ownership will leave the contract without an owner,
141      * thereby removing any functionality that is only available to the owner.
142      */
143     function renounceOwnership() public virtual onlyOwner {
144         _setOwner(address(0));
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new account (`newOwner`).
149      * Can only be called by the current owner.
150      */
151     function transferOwnership(address newOwner) public virtual onlyOwner {
152         require(newOwner != address(0), "Ownable: new owner is the zero address");
153         _setOwner(newOwner);
154     }
155 
156     function _setOwner(address newOwner) private {
157         address oldOwner = _owner;
158         _owner = newOwner;
159         emit OwnershipTransferred(oldOwner, newOwner);
160     }
161 }
162 
163 // File: @openzeppelin/contracts/utils/Address.sol
164 
165 
166 /**
167  * @dev Collection of functions related to the address type
168  */
169 library Address {
170     /**
171      * @dev Returns true if `account` is a contract.
172      *
173      * [IMPORTANT]
174      * ====
175      * It is unsafe to assume that an address for which this function returns
176      * false is an externally-owned account (EOA) and not a contract.
177      *
178      * Among others, `isContract` will return false for the following
179      * types of addresses:
180      *
181      *  - an externally-owned account
182      *  - a contract in construction
183      *  - an address where a contract will be created
184      *  - an address where a contract lived, but was destroyed
185      * ====
186      */
187     function isContract(address account) internal view returns (bool) {
188         // This method relies on extcodesize, which returns 0 for contracts in
189         // construction, since the code is only stored at the end of the
190         // constructor execution.
191 
192         uint256 size;
193         assembly {
194             size := extcodesize(account)
195         }
196         return size > 0;
197     }
198 
199     /**
200      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
201      * `recipient`, forwarding all available gas and reverting on errors.
202      *
203      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
204      * of certain opcodes, possibly making contracts go over the 2300 gas limit
205      * imposed by `transfer`, making them unable to receive funds via
206      * `transfer`. {sendValue} removes this limitation.
207      *
208      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
209      *
210      * IMPORTANT: because control is transferred to `recipient`, care must be
211      * taken to not create reentrancy vulnerabilities. Consider using
212      * {ReentrancyGuard} or the
213      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
214      */
215     function sendValue(address payable recipient, uint256 amount) internal {
216         require(address(this).balance >= amount, "Address: insufficient balance");
217 
218         (bool success, ) = recipient.call{value: amount}("");
219         require(success, "Address: unable to send value, recipient may have reverted");
220     }
221 
222     /**
223      * @dev Performs a Solidity function call using a low level `call`. A
224      * plain `call` is an unsafe replacement for a function call: use this
225      * function instead.
226      *
227      * If `target` reverts with a revert reason, it is bubbled up by this
228      * function (like regular Solidity function calls).
229      *
230      * Returns the raw returned data. To convert to the expected return value,
231      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
232      *
233      * Requirements:
234      *
235      * - `target` must be a contract.
236      * - calling `target` with `data` must not revert.
237      *
238      * _Available since v3.1._
239      */
240     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
241         return functionCall(target, data, "Address: low-level call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
246      * `errorMessage` as a fallback revert reason when `target` reverts.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, 0, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but also transferring `value` wei to `target`.
261      *
262      * Requirements:
263      *
264      * - the calling contract must have an ETH balance of at least `value`.
265      * - the called Solidity function must be `payable`.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(
270         address target,
271         bytes memory data,
272         uint256 value
273     ) internal returns (bytes memory) {
274         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
279      * with `errorMessage` as a fallback revert reason when `target` reverts.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(address(this).balance >= value, "Address: insufficient balance for call");
290         require(isContract(target), "Address: call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.call{value: value}(data);
293         return verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but performing a static call.
299      *
300      * _Available since v3.3._
301      */
302     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
303         return functionStaticCall(target, data, "Address: low-level static call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
308      * but performing a static call.
309      *
310      * _Available since v3.3._
311      */
312     function functionStaticCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal view returns (bytes memory) {
317         require(isContract(target), "Address: static call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.staticcall(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a delegate call.
326      *
327      * _Available since v3.4._
328      */
329     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a delegate call.
336      *
337      * _Available since v3.4._
338      */
339     function functionDelegateCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(isContract(target), "Address: delegate call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.delegatecall(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
352      * revert reason using the provided one.
353      *
354      * _Available since v4.3._
355      */
356     function verifyCallResult(
357         bool success,
358         bytes memory returndata,
359         string memory errorMessage
360     ) internal pure returns (bytes memory) {
361         if (success) {
362             return returndata;
363         } else {
364             // Look for revert reason and bubble it up if present
365             if (returndata.length > 0) {
366                 // The easiest way to bubble the revert reason is using memory via assembly
367 
368                 assembly {
369                     let returndata_size := mload(returndata)
370                     revert(add(32, returndata), returndata_size)
371                 }
372             } else {
373                 revert(errorMessage);
374             }
375         }
376     }
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
380 
381 /**
382  * @title ERC721 token receiver interface
383  * @dev Interface for any contract that wants to support safeTransfers
384  * from ERC721 asset contracts.
385  */
386 interface IERC721Receiver {
387     /**
388      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
389      * by `operator` from `from`, this function is called.
390      *
391      * It must return its Solidity selector to confirm the token transfer.
392      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
393      *
394      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
395      */
396     function onERC721Received(
397         address operator,
398         address from,
399         uint256 tokenId,
400         bytes calldata data
401     ) external returns (bytes4);
402 }
403 
404 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
405 
406 /**
407  * @dev Interface of the ERC165 standard, as defined in the
408  * https://eips.ethereum.org/EIPS/eip-165[EIP].
409  *
410  * Implementers can declare support of contract interfaces, which can then be
411  * queried by others ({ERC165Checker}).
412  *
413  * For an implementation, see {ERC165}.
414  */
415 interface IERC165 {
416     /**
417      * @dev Returns true if this contract implements the interface defined by
418      * `interfaceId`. See the corresponding
419      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
420      * to learn more about how these ids are created.
421      *
422      * This function call must use less than 30 000 gas.
423      */
424     function supportsInterface(bytes4 interfaceId) external view returns (bool);
425 }
426 
427 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
428 
429 
430 
431 /**
432  * @dev Implementation of the {IERC165} interface.
433  *
434  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
435  * for the additional interface id that will be supported. For example:
436  *
437  * ```solidity
438  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
440  * }
441  * ```
442  *
443  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
444  */
445 abstract contract ERC165 is IERC165 {
446     /**
447      * @dev See {IERC165-supportsInterface}.
448      */
449     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
450         return interfaceId == type(IERC165).interfaceId;
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
455 
456 
457 /**
458  * @dev Required interface of an ERC721 compliant contract.
459  */
460 interface IERC721 is IERC165 {
461     /**
462      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
463      */
464     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
465 
466     /**
467      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
468      */
469     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
470 
471     /**
472      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
473      */
474     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
475 
476     /**
477      * @dev Returns the number of tokens in ``owner``'s account.
478      */
479     function balanceOf(address owner) external view returns (uint256 balance);
480 
481     /**
482      * @dev Returns the owner of the `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function ownerOf(uint256 tokenId) external view returns (address owner);
489 
490     /**
491      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
492      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
493      *
494      * Requirements:
495      *
496      * - `from` cannot be the zero address.
497      * - `to` cannot be the zero address.
498      * - `tokenId` token must exist and be owned by `from`.
499      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
500      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
501      *
502      * Emits a {Transfer} event.
503      */
504     function safeTransferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Transfers `tokenId` token from `from` to `to`.
512      *
513      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
514      *
515      * Requirements:
516      *
517      * - `from` cannot be the zero address.
518      * - `to` cannot be the zero address.
519      * - `tokenId` token must be owned by `from`.
520      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
521      *
522      * Emits a {Transfer} event.
523      */
524     function transferFrom(
525         address from,
526         address to,
527         uint256 tokenId
528     ) external;
529 
530     /**
531      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
532      * The approval is cleared when the token is transferred.
533      *
534      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
535      *
536      * Requirements:
537      *
538      * - The caller must own the token or be an approved operator.
539      * - `tokenId` must exist.
540      *
541      * Emits an {Approval} event.
542      */
543     function approve(address to, uint256 tokenId) external;
544 
545     /**
546      * @dev Returns the account approved for `tokenId` token.
547      *
548      * Requirements:
549      *
550      * - `tokenId` must exist.
551      */
552     function getApproved(uint256 tokenId) external view returns (address operator);
553 
554     /**
555      * @dev Approve or remove `operator` as an operator for the caller.
556      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
557      *
558      * Requirements:
559      *
560      * - The `operator` cannot be the caller.
561      *
562      * Emits an {ApprovalForAll} event.
563      */
564     function setApprovalForAll(address operator, bool _approved) external;
565 
566     /**
567      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
568      *
569      * See {setApprovalForAll}
570      */
571     function isApprovedForAll(address owner, address operator) external view returns (bool);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must exist and be owned by `from`.
581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
582      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
583      *
584      * Emits a {Transfer} event.
585      */
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 tokenId,
590         bytes calldata data
591     ) external;
592 }
593 
594 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
595 
596 
597 /**
598  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
599  * @dev See https://eips.ethereum.org/EIPS/eip-721
600  */
601 interface IERC721Metadata is IERC721 {
602     /**
603      * @dev Returns the token collection name.
604      */
605     function name() external view returns (string memory);
606 
607     /**
608      * @dev Returns the token collection symbol.
609      */
610     function symbol() external view returns (string memory);
611 
612     /**
613      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
614      */
615     function tokenURI(uint256 tokenId) external view returns (string memory);
616 }
617 
618 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
619     using Address for address;
620     using Strings for uint256;
621 
622     // Token name
623     string private _name;
624 
625     // Token symbol
626     string private _symbol;
627 
628     // Mapping from token ID to owner address
629     mapping(uint256 => address) private _owners;
630 
631     // Mapping owner address to token count
632     mapping(address => uint256) private _balances;
633 
634     // Mapping from token ID to approved address
635     mapping(uint256 => address) private _tokenApprovals;
636 
637     // Mapping from owner to operator approvals
638     mapping(address => mapping(address => bool)) private _operatorApprovals;
639     
640     //Mapping para atribuirle un URI para cada token
641     mapping(uint256 => string) internal id_to_URI;
642 
643     /**
644      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
645      */
646     constructor(string memory name_, string memory symbol_) {
647         _name = name_;
648         _symbol = symbol_;
649     }
650 
651     /**
652      * @dev See {IERC165-supportsInterface}.
653      */
654     
655     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
656         return
657             interfaceId == type(IERC721).interfaceId ||
658             interfaceId == type(IERC721Metadata).interfaceId ||
659             super.supportsInterface(interfaceId);
660     }
661     
662 
663     /**
664      * @dev See {IERC721-balanceOf}.
665      */
666     function balanceOf(address owner) public view virtual override returns (uint256) {
667         require(owner != address(0), "ERC721: balance query for the zero address");
668         return _balances[owner];
669     }
670 
671     /**
672      * @dev See {IERC721-ownerOf}.
673      */
674     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
675         address owner = _owners[tokenId];
676         require(owner != address(0), "ERC721: owner query for nonexistent token");
677         return owner;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-name}.
682      */
683     function name() public view virtual override returns (string memory) {
684         return _name;
685     }
686 
687     /**
688      * @dev See {IERC721Metadata-symbol}.
689      */
690     function symbol() public view virtual override returns (string memory) {
691         return _symbol;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-tokenURI}.
696      */
697     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {}
698 
699     /**
700      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
701      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
702      * by default, can be overridden in child contracts.
703      */
704     function _baseURI() internal view virtual returns (string memory) {
705         return "";
706     }
707 
708     /**
709      * @dev See {IERC721-approve}.
710      */
711     function approve(address to, uint256 tokenId) public virtual override {
712         address owner = ERC721.ownerOf(tokenId);
713         require(to != owner, "ERC721: approval to current owner");
714 
715         require(
716             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
717             "ERC721: approve caller is not owner nor approved for all"
718         );
719 
720         _approve(to, tokenId);
721     }
722 
723     /**
724      * @dev See {IERC721-getApproved}.
725      */
726     function getApproved(uint256 tokenId) public view virtual override returns (address) {
727         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
728 
729         return _tokenApprovals[tokenId];
730     }
731 
732     /**
733      * @dev See {IERC721-setApprovalForAll}.
734      */
735     function setApprovalForAll(address operator, bool approved) public virtual override {
736         require(operator != _msgSender(), "ERC721: approve to caller");
737 
738         _operatorApprovals[_msgSender()][operator] = approved;
739         emit ApprovalForAll(_msgSender(), operator, approved);
740     }
741 
742     /**
743      * @dev See {IERC721-isApprovedForAll}.
744      */
745     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
746         return _operatorApprovals[owner][operator];
747     }
748 
749     /**
750      * @dev See {IERC721-transferFrom}.
751      */
752     function transferFrom(
753         address from,
754         address to,
755         uint256 tokenId
756     ) public virtual override {
757         //solhint-disable-next-line max-line-length
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759 
760         _transfer(from, to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-safeTransferFrom}.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) public virtual override {
771         safeTransferFrom(from, to, tokenId, "");
772     }
773 
774     /**
775      * @dev See {IERC721-safeTransferFrom}.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) public virtual override {
783         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
784         _safeTransfer(from, to, tokenId, _data);
785     }
786 
787     /**
788      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
789      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
790      *
791      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
792      *
793      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
794      * implement alternative mechanisms to perform token transfer, such as signature-based.
795      *
796      * Requirements:
797      *
798      * - `from` cannot be the zero address.
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must exist and be owned by `from`.
801      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _safeTransfer(
806         address from,
807         address to,
808         uint256 tokenId,
809         bytes memory _data
810     ) internal virtual {
811         _transfer(from, to, tokenId);
812         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
813     }
814 
815     /**
816      * @dev Returns whether `tokenId` exists.
817      *
818      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
819      *
820      * Tokens start existing when they are minted (`_mint`),
821      * and stop existing when they are burned (`_burn`).
822      */
823     function _exists(uint256 tokenId) internal view virtual returns (bool) {
824         return _owners[tokenId] != address(0);
825     }
826 
827     /**
828      * @dev Returns whether `spender` is allowed to manage `tokenId`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must exist.
833      */
834     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
835         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
836         address owner = ERC721.ownerOf(tokenId);
837         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
838     }
839 
840     /**
841      * @dev Safely mints `tokenId` and transfers it to `to`.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must not exist.
846      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _safeMint(address to, uint256 tokenId) internal virtual {
851         _safeMint(to, tokenId, "");
852     }
853 
854     /**
855      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
856      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
857      */
858     function _safeMint(
859         address to,
860         uint256 tokenId,
861         bytes memory _data
862     ) internal virtual {
863         _mint(to, tokenId);
864         require(
865             _checkOnERC721Received(address(0), to, tokenId, _data),
866             "ERC721: transfer to non ERC721Receiver implementer"
867         );
868     }
869 
870     /**
871      * @dev Mints `tokenId` and transfers it to `to`.
872      *
873      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
874      *
875      * Requirements:
876      *
877      * - `tokenId` must not exist.
878      * - `to` cannot be the zero address.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _mint(address to, uint256 tokenId) internal virtual {
883         require(to != address(0), "ERC721: mint to the zero address");
884         require(!_exists(tokenId), "ERC721: token already minted");
885 
886         _beforeTokenTransfer(address(0), to, tokenId);
887 
888         _balances[to] += 1;
889         _owners[tokenId] = to;
890 
891         emit Transfer(address(0), to, tokenId);
892     }
893 
894     /**
895      * @dev Destroys `tokenId`.
896      * The approval is cleared when the token is burned.
897      *
898      * Requirements:
899      *
900      * - `tokenId` must exist.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _burn(uint256 tokenId) internal virtual {
905         address owner = ERC721.ownerOf(tokenId);
906 
907         _beforeTokenTransfer(owner, address(0), tokenId);
908 
909         // Clear approvals
910         _approve(address(0), tokenId);
911 
912         _balances[owner] -= 1;
913         delete _owners[tokenId];
914 
915         emit Transfer(owner, address(0), tokenId);
916     }
917 
918     /**
919      * @dev Transfers `tokenId` from `from` to `to`.
920      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
921      *
922      * Requirements:
923      *
924      * - `to` cannot be the zero address.
925      * - `tokenId` token must be owned by `from`.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _transfer(
930         address from,
931         address to,
932         uint256 tokenId
933     ) internal virtual {
934         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
935         require(to != address(0), "ERC721: transfer to the zero address");
936 
937         _beforeTokenTransfer(from, to, tokenId);
938 
939         // Clear approvals from the previous owner
940         _approve(address(0), tokenId);
941 
942         _balances[from] -= 1;
943         _balances[to] += 1;
944         _owners[tokenId] = to;
945 
946         emit Transfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev Approve `to` to operate on `tokenId`
951      *
952      * Emits a {Approval} event.
953      */
954     function _approve(address to, uint256 tokenId) internal virtual {
955         _tokenApprovals[tokenId] = to;
956         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
957     }
958 
959     /**
960      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
961      * The call is not executed if the target address is not a contract.
962      *
963      * @param from address representing the previous owner of the given token ID
964      * @param to target address that will receive the tokens
965      * @param tokenId uint256 ID of the token to be transferred
966      * @param _data bytes optional data to send along with the call
967      * @return bool whether the call correctly returned the expected magic value
968      */
969     function _checkOnERC721Received(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) private returns (bool) {
975         if (to.isContract()) {
976             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
977                 return retval == IERC721Receiver.onERC721Received.selector;
978             } catch (bytes memory reason) {
979                 if (reason.length == 0) {
980                     revert("ERC721: transfer to non ERC721Receiver implementer");
981                 } else {
982                     assembly {
983                         revert(add(32, reason), mload(reason))
984                     }
985                 }
986             }
987         } else {
988             return true;
989         }
990     }
991 
992     /**
993      * @dev Hook that is called before any token transfer. This includes minting
994      * and burning.
995      *
996      * Calling conditions:
997      *
998      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
999      * transferred to `to`.
1000      * - When `from` is zero, `tokenId` will be minted for `to`.
1001      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1002      * - `from` and `to` are never both zero.
1003      *
1004      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1005      */
1006     function _beforeTokenTransfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) internal virtual {}
1011 }
1012 
1013 interface IERC721Enumerable is IERC721 {
1014     /**
1015      * @dev Returns the total amount of tokens stored by the contract.
1016      */
1017     function totalSupply() external view returns (uint256);
1018 
1019     /**
1020      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1021      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1022      */
1023     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1024 
1025     /**
1026      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1027      * Use along with {totalSupply} to enumerate all tokens.
1028      */
1029     function tokenByIndex(uint256 index) external view returns (uint256);
1030 }
1031 
1032 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1033     // Mapping from owner to list of owned token IDs
1034     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1035 
1036     // Mapping from token ID to index of the owner tokens list
1037     mapping(uint256 => uint256) private _ownedTokensIndex;
1038 
1039     // Array with all token ids, used for enumeration
1040     uint256[] private _allTokens;
1041 
1042     // Mapping from token id to position in the allTokens array
1043     mapping(uint256 => uint256) private _allTokensIndex;
1044 
1045     /**
1046      * @dev See {IERC165-supportsInterface}.
1047      */
1048     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1049         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1054      */
1055     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1056         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1057         return _ownedTokens[owner][index];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Enumerable-totalSupply}.
1062      */
1063     function totalSupply() public view virtual override returns (uint256) {
1064         return _allTokens.length;
1065     }
1066 
1067     /**
1068      * @dev See {IERC721Enumerable-tokenByIndex}.
1069      */
1070     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1071         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1072         return _allTokens[index];
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before any token transfer. This includes minting
1077      * and burning.
1078      *
1079      * Calling conditions:
1080      *
1081      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1082      * transferred to `to`.
1083      * - When `from` is zero, `tokenId` will be minted for `to`.
1084      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1085      * - `from` cannot be the zero address.
1086      * - `to` cannot be the zero address.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(address from,address to, uint256 tokenId) internal virtual override {
1091         super._beforeTokenTransfer(from, to, tokenId);
1092 
1093         if (from == address(0)) {
1094             _addTokenToAllTokensEnumeration(tokenId);
1095         } 
1096         else if (from != to) {
1097             _removeTokenFromOwnerEnumeration(from, tokenId);
1098         }
1099         if (to == address(0)) {
1100             _removeTokenFromAllTokensEnumeration(tokenId);
1101         } 
1102         else if (to != from) {
1103             _addTokenToOwnerEnumeration(to, tokenId);
1104         }
1105     }
1106 
1107     /**
1108      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1109      * @param to address representing the new owner of the given token ID
1110      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1111      */
1112     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1113         uint256 length = ERC721.balanceOf(to);
1114         _ownedTokens[to][length] = tokenId;
1115         _ownedTokensIndex[tokenId] = length;
1116     }
1117 
1118     /**
1119      * @dev Private function to add a token to this extension's token tracking data structures.
1120      * @param tokenId uint256 ID of the token to be added to the tokens list
1121      */
1122     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1123         _allTokensIndex[tokenId] = _allTokens.length;
1124         _allTokens.push(tokenId);
1125     }
1126 
1127     /**
1128      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1129      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1130      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1131      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1132      * @param from address representing the previous owner of the given token ID
1133      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1134      */
1135     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1136         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1137         // then delete the last slot (swap and pop).
1138 
1139         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1140         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1141 
1142         // When the token to delete is the last token, the swap operation is unnecessary
1143         if (tokenIndex != lastTokenIndex) {
1144             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1145 
1146             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1147             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1148         }
1149 
1150         // This also deletes the contents at the last position of the array
1151         delete _ownedTokensIndex[tokenId];
1152         delete _ownedTokens[from][lastTokenIndex];
1153     }
1154 
1155     /**
1156      * @dev Private function to remove a token from this extension's token tracking data structures.
1157      * This has O(1) time complexity, but alters the order of the _allTokens array.
1158      * @param tokenId uint256 ID of the token to be removed from the tokens list
1159      */
1160     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1161         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1162         // then delete the last slot (swap and pop).
1163 
1164         uint256 lastTokenIndex = _allTokens.length - 1;
1165         uint256 tokenIndex = _allTokensIndex[tokenId];
1166 
1167         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1168         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1169         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1170         uint256 lastTokenId = _allTokens[lastTokenIndex];
1171 
1172         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1173         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1174 
1175         // This also deletes the contents at the last position of the array
1176         delete _allTokensIndex[tokenId];
1177         _allTokens.pop();
1178     }
1179 }
1180 
1181 contract nft is ERC721Enumerable, Ownable {
1182     using Strings for uint256;
1183 
1184     //declares the maximum amount of tokens that can be minted, total and in presale
1185     uint256 private maxTotalTokens;
1186     //declares the amount of tokens able to be sold in presale
1187     uint256 private maxTokensPresale;
1188     
1189     //initial part of the URI for the metadata
1190     string private _currentBaseURI;
1191     //uri for unrevealed stage of NFTs
1192     string private unrevealedURI;
1193         
1194     //cost of mints depending on state of sale    
1195     uint private _mintCost = 0.0777 ether;
1196     
1197     //the amount of reserved mints that have currently been executed by creator and by marketing wallet
1198     uint private _reservedMints;
1199     //the maximum amount of reserved mints allowed for creator and marketing wallet
1200     uint private maxReservedMints;
1201     
1202     //number of mints an address can have maximum
1203     uint private maxMints;
1204     
1205     //the addresses of the shareholders
1206     address public shareholder1 = 0x318cBF186eB13C74533943b054959867eE44eFFE; //Dev
1207     address public shareholder2 = 0xAC5bECB84A3F732150D2333992339dd0E45F48cE; //Gnosis Safe
1208     
1209     //dummy address that we use to sign the mint transaction to make sure it is valid
1210     address private dummy = 0x80E4929c869102140E69550BBECC20bEd61B080c;
1211 
1212     //amount of mints that each address has executed
1213     mapping(address => uint256) public mintsPerAddress;
1214     
1215     //current state os sale
1216     enum State {NoSale, Presale, PublicSale}
1217     
1218     //the timestamp of when presale opens
1219     uint256 private presaleLaunchTime;
1220     //the timestamp of when presale opens
1221     uint256 private publicSaleLaunchTime;
1222     //the timestamp of when the NFTs get revealed
1223     uint256 private revealTime;
1224         
1225     //declaring initial values for variables
1226     constructor() ERC721('Gnomies', 'G') {
1227         //max number of NFTs that will be minted
1228         maxTotalTokens = 10000;
1229         //limit for presale
1230         maxTokensPresale = 5000;
1231         //URI of the placeholder image and metadata that will show before the collection has been revealed
1232         unrevealedURI = 'ipfs://QmfMH95cX9no1gfYPk3vKqbvUarFkznd3niU21XLX2BSiM/';
1233         
1234         //the max number of reserved mints for team/giveaway/marketing will be 100
1235         maxReservedMints = 777;
1236 
1237         //setting the amount of maxMints per person
1238         maxMints = 2;
1239         
1240     }
1241     
1242     //in case somebody accidentaly sends funds or transaction to contract
1243     receive() payable external {}
1244     fallback() payable external {
1245         revert();
1246     }
1247     
1248     //visualize baseURI
1249     function _baseURI() internal view virtual override returns (string memory) {
1250         return _currentBaseURI;
1251     }
1252     
1253     //change baseURI in case needed for IPFS
1254     function changeBaseURI(string memory baseURI_) public onlyOwner {
1255         _currentBaseURI = baseURI_;
1256     }
1257     
1258     //gets the tokenID of NFT to be minted
1259     function tokenId() internal view returns(uint256) {
1260         return totalSupply() + 1;
1261     }
1262     
1263     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1264         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
1265         _;
1266     }
1267  
1268     /* 
1269     * @dev Verifies if message was signed by owner to give access to _add for this contract.
1270     *      Assumes Geth signature prefix.
1271     * @param _add Address of agent with access
1272     * @param _v ECDSA signature parameter v.
1273     * @param _r ECDSA signature parameters r.
1274     * @param _s ECDSA signature parameters s.
1275     * @return Validity of access message for a given address.
1276     */
1277     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1278         bytes32 hash = keccak256(abi.encodePacked(address(this), _add));
1279         return dummy == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1280     }
1281     
1282     //mint a @param number of NFTs
1283     //@param _v ECDSA signature parameter v.
1284     //@param _r ECDSA signature parameters r.
1285     //@param _s ECDSA signature parameters s.
1286     function presaleMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) external payable {
1287         require(saleState() != State.NoSale, "Sale in not open yet!");
1288         require(saleState() != State.PublicSale, "Presale has closed!");
1289         require(totalSupply() + number <= maxTokensPresale, "Not enough NFTs left to mint in Presale..");
1290         require(mintsPerAddress[msg.sender] + number <= maxMints, "Only 2 Mints are allowed per Address");
1291         require(msg.value >= number * mintCost(), "Insufficient Funds to mint this number of Tokens!");
1292         
1293         /*
1294         //function to blacklist bots
1295         if (block.timestamp == saleLaunchTime) {
1296             blacklist[msg.sender] = true;
1297         }
1298         */
1299         
1300         for (uint256 i = 0; i < number; i++) {
1301             uint256 tid = tokenId();
1302             _safeMint(msg.sender, tid);
1303             mintsPerAddress[msg.sender] += 1;
1304         }
1305 
1306     }
1307 
1308     function publicSaleMint(uint256 number) external payable {
1309         require(saleState() != State.NoSale, "Sale in not open yet!");
1310         require(saleState() == State.PublicSale, "Public Sale in not open yet!");
1311         require(totalSupply() + number <= maxTotalTokens - (maxReservedMints -  _reservedMints), "Not enough NFTs left to mint..");
1312         require(mintsPerAddress[msg.sender] + number <= maxMints + 1, "Only 3 Mints are allowed per Address");
1313         require(msg.value >= number * mintCost(), "Insufficient Funds to mint this number of Tokens!");
1314         
1315         /*
1316         //function to blacklist bots
1317         if (block.timestamp == saleLaunchTime) {
1318             blacklist[msg.sender] = true;
1319         }
1320         */
1321         
1322         for (uint256 i = 0; i < number; i++) {
1323             uint256 tid = tokenId();
1324             _safeMint(msg.sender, tid);
1325             mintsPerAddress[msg.sender] += 1;
1326         }
1327 
1328     }
1329 
1330         /**
1331      * @dev See {IERC721Metadata-tokenURI}.
1332      */
1333     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1334         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1335 
1336         if (revealTime == 0) {
1337             return unrevealedURI;
1338         }    
1339         else {
1340             string memory baseURI = _baseURI();
1341             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId_.toString(), '.json')) : "";
1342         }
1343         
1344             
1345     }
1346     
1347     //reserved NFTs for creatorç
1348     //mint a @param number of reserved NFTs
1349     function reservedMint(uint256 number) public onlyOwner {
1350         require(totalSupply() + number <= maxTotalTokens, "No NFTs left to mint.."); //In case we burn tokens
1351         require(_reservedMints + number <= maxReservedMints, "Not enough Reserved NFTs for Creator left to mint..");
1352         for (uint256 i = 0; i < number; i++) {
1353             uint256 tid = tokenId();
1354             _safeMint(msg.sender, tid);
1355             mintsPerAddress[msg.sender] += 1;
1356             _reservedMints += 1;
1357         }
1358     }
1359     
1360     //begins the minting of the NFTs
1361     function switchToPresale() public onlyOwner{
1362         require(saleState() == State.NoSale, "Sale has already opened!");
1363         presaleLaunchTime = block.timestamp;
1364     }
1365 
1366     //begins the minting of the NFTs
1367     function switchToPublicSale() public onlyOwner{
1368         require(saleState() != State.PublicSale, "Already in Public Sale!");
1369         require(saleState() == State.Presale, "Sale has not opened yet!");
1370         publicSaleLaunchTime = block.timestamp;
1371     }
1372     
1373     function reveal() public onlyOwner {
1374         revealTime = block.timestamp;
1375     }
1376 
1377     //burn the tokens that have not been sold yet
1378     function burnUnmintedTokens() public onlyOwner {
1379         maxTotalTokens = totalSupply();
1380         maxTokensPresale = totalSupply();
1381     }
1382     
1383     //se the current account balance
1384     function accountBalance() public onlyOwner view returns(uint) {
1385         return address(this).balance;
1386     }
1387     
1388     //change the dummy account used for signing transactions
1389     function changeDummy(address _dummy) public onlyOwner {
1390         dummy = _dummy;
1391     }
1392     
1393     //see the total amount of reserved mints that creator has left
1394     function reservedMintsLeft() public onlyOwner view returns(uint) {
1395         return maxReservedMints - _reservedMints;
1396     }
1397     
1398     //withdraw funds and distribute them to the shareholders
1399     function withdrawAll() public onlyOwner {
1400         uint balance = accountBalance();
1401         require(balance > 0, "Balance must be greater than 0");
1402         
1403         withdraw(payable(shareholder1), ((balance * 35) / 1000));
1404         withdraw(payable(shareholder2), accountBalance());
1405     }
1406     
1407     function withdraw(address payable _address, uint amount) internal {
1408         (bool sent, ) = _address.call{value: amount}("");
1409         require(sent, "Failed to send Ether");
1410     }
1411     
1412     //see the time that sale launched
1413     function publicSalelaunch() public view returns(uint256) {
1414         require(publicSaleLaunchTime != 0, 'Public Sale has not opened yet!');
1415         return publicSaleLaunchTime;
1416     }
1417 
1418     //see the time that sale launched
1419     function presalelaunch() public view returns(uint256) {
1420         require(presaleLaunchTime != 0, 'Presale has not opened yet!');
1421         return presaleLaunchTime;
1422     }
1423 
1424     //see the current state of sale
1425     function saleState() public view returns(State) {
1426         if (presaleLaunchTime == 0) {
1427             return State.NoSale;
1428         }
1429         else if (publicSaleLaunchTime == 0) {
1430             return State.Presale;
1431         }
1432         else {
1433             return State.PublicSale;
1434         }
1435     }
1436 
1437     //see the price to mint
1438     function mintCost() public view returns(uint) {
1439         return _mintCost;
1440     }
1441 
1442     function changeMintCost(uint256 newCost) public onlyOwner {
1443         _mintCost = newCost;
1444     }
1445     
1446    
1447 }