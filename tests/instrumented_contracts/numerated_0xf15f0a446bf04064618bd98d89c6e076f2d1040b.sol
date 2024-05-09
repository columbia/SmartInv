1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _setOwner(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _setOwner(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _setOwner(newOwner);
83     }
84 
85     function _setOwner(address newOwner) private {
86         address oldOwner = _owner;
87         _owner = newOwner;
88         emit OwnershipTransferred(oldOwner, newOwner);
89     }
90 }
91 
92 
93 /**
94  * @dev Interface of the ERC165 standard, as defined in the
95  * https://eips.ethereum.org/EIPS/eip-165[EIP].
96  *
97  * Implementers can declare support of contract interfaces, which can then be
98  * queried by others ({ERC165Checker}).
99  *
100  * For an implementation, see {ERC165}.
101  */
102 interface IERC165 {
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 }
113 
114 
115 /**
116  * @dev Required interface of an ERC721 compliant contract.
117  */
118 interface IERC721 is IERC165 {
119     /**
120      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
126      */
127     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
131      */
132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
133 
134     /**
135      * @dev Returns the number of tokens in ``owner``'s account.
136      */
137     function balanceOf(address owner) external view returns (uint256 balance);
138 
139     /**
140      * @dev Returns the owner of the `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function ownerOf(uint256 tokenId) external view returns (address owner);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
150      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId
166     ) external;
167 
168     /**
169      * @dev Transfers `tokenId` token from `from` to `to`.
170      *
171      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must be owned by `from`.
178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     /**
189      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
190      * The approval is cleared when the token is transferred.
191      *
192      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
193      *
194      * Requirements:
195      *
196      * - The caller must own the token or be an approved operator.
197      * - `tokenId` must exist.
198      *
199      * Emits an {Approval} event.
200      */
201     function approve(address to, uint256 tokenId) external;
202 
203     /**
204      * @dev Returns the account approved for `tokenId` token.
205      *
206      * Requirements:
207      *
208      * - `tokenId` must exist.
209      */
210     function getApproved(uint256 tokenId) external view returns (address operator);
211 
212     /**
213      * @dev Approve or remove `operator` as an operator for the caller.
214      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
215      *
216      * Requirements:
217      *
218      * - The `operator` cannot be the caller.
219      *
220      * Emits an {ApprovalForAll} event.
221      */
222     function setApprovalForAll(address operator, bool _approved) external;
223 
224     /**
225      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
226      *
227      * See {setApprovalForAll}
228      */
229     function isApprovedForAll(address owner, address operator) external view returns (bool);
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `tokenId` token must exist and be owned by `from`.
239      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
241      *
242      * Emits a {Transfer} event.
243      */
244     function safeTransferFrom(
245         address from,
246         address to,
247         uint256 tokenId,
248         bytes calldata data
249     ) external;
250 }
251 
252 
253 /**
254  * @title ERC721 token receiver interface
255  * @dev Interface for any contract that wants to support safeTransfers
256  * from ERC721 asset contracts.
257  */
258 interface IERC721Receiver {
259     /**
260      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
261      * by `operator` from `from`, this function is called.
262      *
263      * It must return its Solidity selector to confirm the token transfer.
264      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
265      *
266      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
267      */
268     function onERC721Received(
269         address operator,
270         address from,
271         uint256 tokenId,
272         bytes calldata data
273     ) external returns (bytes4);
274 }
275 
276 
277 /**
278  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
279  * @dev See https://eips.ethereum.org/EIPS/eip-721
280  */
281 interface IERC721Metadata is IERC721 {
282     /**
283      * @dev Returns the token collection name.
284      */
285     function name() external view returns (string memory);
286 
287     /**
288      * @dev Returns the token collection symbol.
289      */
290     function symbol() external view returns (string memory);
291 
292     /**
293      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
294      */
295     function tokenURI(uint256 tokenId) external view returns (string memory);
296 }
297 
298 
299 /**
300  * @dev Collection of functions related to the address type
301  */
302 library Address {
303     /**
304      * @dev Returns true if `account` is a contract.
305      *
306      * [IMPORTANT]
307      * ====
308      * It is unsafe to assume that an address for which this function returns
309      * false is an externally-owned account (EOA) and not a contract.
310      *
311      * Among others, `isContract` will return false for the following
312      * types of addresses:
313      *
314      *  - an externally-owned account
315      *  - a contract in construction
316      *  - an address where a contract will be created
317      *  - an address where a contract lived, but was destroyed
318      * ====
319      */
320     function isContract(address account) internal view returns (bool) {
321         // This method relies on extcodesize, which returns 0 for contracts in
322         // construction, since the code is only stored at the end of the
323         // constructor execution.
324 
325         uint256 size;
326         assembly {
327             size := extcodesize(account)
328         }
329         return size > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         (bool success, ) = recipient.call{value: amount}("");
352         require(success, "Address: unable to send value, recipient may have reverted");
353     }
354 
355     /**
356      * @dev Performs a Solidity function call using a low level `call`. A
357      * plain `call` is an unsafe replacement for a function call: use this
358      * function instead.
359      *
360      * If `target` reverts with a revert reason, it is bubbled up by this
361      * function (like regular Solidity function calls).
362      *
363      * Returns the raw returned data. To convert to the expected return value,
364      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365      *
366      * Requirements:
367      *
368      * - `target` must be a contract.
369      * - calling `target` with `data` must not revert.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionCall(target, data, "Address: low-level call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
379      * `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, 0, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but also transferring `value` wei to `target`.
394      *
395      * Requirements:
396      *
397      * - the calling contract must have an ETH balance of at least `value`.
398      * - the called Solidity function must be `payable`.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value
406     ) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(address(this).balance >= value, "Address: insufficient balance for call");
423         require(isContract(target), "Address: call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.call{value: value}(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
436         return functionStaticCall(target, data, "Address: low-level static call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal view returns (bytes memory) {
450         require(isContract(target), "Address: static call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.staticcall(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
463         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(isContract(target), "Address: delegate call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.delegatecall(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
485      * revert reason using the provided one.
486      *
487      * _Available since v4.3._
488      */
489     function verifyCallResult(
490         bool success,
491         bytes memory returndata,
492         string memory errorMessage
493     ) internal pure returns (bytes memory) {
494         if (success) {
495             return returndata;
496         } else {
497             // Look for revert reason and bubble it up if present
498             if (returndata.length > 0) {
499                 // The easiest way to bubble the revert reason is using memory via assembly
500 
501                 assembly {
502                     let returndata_size := mload(returndata)
503                     revert(add(32, returndata), returndata_size)
504                 }
505             } else {
506                 revert(errorMessage);
507             }
508         }
509     }
510 }
511 
512 
513 /**
514  * @dev String operations.
515  */
516 library Strings {
517     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
521      */
522     function toString(uint256 value) internal pure returns (string memory) {
523         // Inspired by OraclizeAPI's implementation - MIT licence
524         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
525 
526         if (value == 0) {
527             return "0";
528         }
529         uint256 temp = value;
530         uint256 digits;
531         while (temp != 0) {
532             digits++;
533             temp /= 10;
534         }
535         bytes memory buffer = new bytes(digits);
536         while (value != 0) {
537             digits -= 1;
538             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
539             value /= 10;
540         }
541         return string(buffer);
542     }
543 
544     /**
545      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
546      */
547     function toHexString(uint256 value) internal pure returns (string memory) {
548         if (value == 0) {
549             return "0x00";
550         }
551         uint256 temp = value;
552         uint256 length = 0;
553         while (temp != 0) {
554             length++;
555             temp >>= 8;
556         }
557         return toHexString(value, length);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
562      */
563     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
564         bytes memory buffer = new bytes(2 * length + 2);
565         buffer[0] = "0";
566         buffer[1] = "x";
567         for (uint256 i = 2 * length + 1; i > 1; --i) {
568             buffer[i] = _HEX_SYMBOLS[value & 0xf];
569             value >>= 4;
570         }
571         require(value == 0, "Strings: hex length insufficient");
572         return string(buffer);
573     }
574 }
575 
576 
577 /**
578  * @dev Implementation of the {IERC165} interface.
579  *
580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
581  * for the additional interface id that will be supported. For example:
582  *
583  * ```solidity
584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
586  * }
587  * ```
588  *
589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
590  */
591 abstract contract ERC165 is IERC165 {
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596         return interfaceId == type(IERC165).interfaceId;
597     }
598 }
599 
600 
601 /**
602  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
603  * the Metadata extension, but not including the Enumerable extension, which is available separately as
604  * {ERC721Enumerable}.
605  */
606 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
607     using Address for address;
608     using Strings for uint256;
609 
610     // Token name
611     string private _name;
612 
613     // Token symbol
614     string private _symbol;
615 
616     // Mapping from token ID to owner address
617     mapping(uint256 => address) private _owners;
618 
619     // Mapping owner address to token count
620     mapping(address => uint256) private _balances;
621 
622     // Mapping from token ID to approved address
623     mapping(uint256 => address) private _tokenApprovals;
624 
625     // Mapping from owner to operator approvals
626     mapping(address => mapping(address => bool)) private _operatorApprovals;
627 
628     /**
629      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
630      */
631     constructor(string memory name_, string memory symbol_) {
632         _name = name_;
633         _symbol = symbol_;
634     }
635 
636     /**
637      * @dev See {IERC165-supportsInterface}.
638      */
639     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
640         return
641             interfaceId == type(IERC721).interfaceId ||
642             interfaceId == type(IERC721Metadata).interfaceId ||
643             super.supportsInterface(interfaceId);
644     }
645 
646     /**
647      * @dev See {IERC721-balanceOf}.
648      */
649     function balanceOf(address owner) public view virtual override returns (uint256) {
650         require(owner != address(0), "ERC721: balance query for the zero address");
651         return _balances[owner];
652     }
653 
654     /**
655      * @dev See {IERC721-ownerOf}.
656      */
657     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
658         address owner = _owners[tokenId];
659         require(owner != address(0), "ERC721: owner query for nonexistent token");
660         return owner;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-name}.
665      */
666     function name() public view virtual override returns (string memory) {
667         return _name;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-symbol}.
672      */
673     function symbol() public view virtual override returns (string memory) {
674         return _symbol;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-tokenURI}.
679      */
680     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
681         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
682 
683         string memory baseURI = _baseURI();
684         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
685     }
686 
687     /**
688      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
689      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
690      * by default, can be overriden in child contracts.
691      */
692     function _baseURI() internal view virtual returns (string memory) {
693         return "";
694     }
695 
696     /**
697      * @dev See {IERC721-approve}.
698      */
699     function approve(address to, uint256 tokenId) public virtual override {
700         address owner = ERC721.ownerOf(tokenId);
701         require(to != owner, "ERC721: approval to current owner");
702 
703         require(
704             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
705             "ERC721: approve caller is not owner nor approved for all"
706         );
707 
708         _approve(to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-getApproved}.
713      */
714     function getApproved(uint256 tokenId) public view virtual override returns (address) {
715         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
716 
717         return _tokenApprovals[tokenId];
718     }
719 
720     /**
721      * @dev See {IERC721-setApprovalForAll}.
722      */
723     function setApprovalForAll(address operator, bool approved) public virtual override {
724         require(operator != _msgSender(), "ERC721: approve to caller");
725 
726         _operatorApprovals[_msgSender()][operator] = approved;
727         emit ApprovalForAll(_msgSender(), operator, approved);
728     }
729 
730     /**
731      * @dev See {IERC721-isApprovedForAll}.
732      */
733     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-transferFrom}.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         //solhint-disable-next-line max-line-length
746         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
747 
748         _transfer(from, to, tokenId);
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         safeTransferFrom(from, to, tokenId, "");
760     }
761 
762     /**
763      * @dev See {IERC721-safeTransferFrom}.
764      */
765     function safeTransferFrom(
766         address from,
767         address to,
768         uint256 tokenId,
769         bytes memory _data
770     ) public virtual override {
771         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
772         _safeTransfer(from, to, tokenId, _data);
773     }
774 
775     /**
776      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
777      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
778      *
779      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
780      *
781      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
782      * implement alternative mechanisms to perform token transfer, such as signature-based.
783      *
784      * Requirements:
785      *
786      * - `from` cannot be the zero address.
787      * - `to` cannot be the zero address.
788      * - `tokenId` token must exist and be owned by `from`.
789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _safeTransfer(
794         address from,
795         address to,
796         uint256 tokenId,
797         bytes memory _data
798     ) internal virtual {
799         _transfer(from, to, tokenId);
800         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
801     }
802 
803     /**
804      * @dev Returns whether `tokenId` exists.
805      *
806      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
807      *
808      * Tokens start existing when they are minted (`_mint`),
809      * and stop existing when they are burned (`_burn`).
810      */
811     function _exists(uint256 tokenId) internal view virtual returns (bool) {
812         return _owners[tokenId] != address(0);
813     }
814 
815     /**
816      * @dev Returns whether `spender` is allowed to manage `tokenId`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      */
822     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
823         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
824         address owner = ERC721.ownerOf(tokenId);
825         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
826     }
827 
828     /**
829      * @dev Safely mints `tokenId` and transfers it to `to`.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must not exist.
834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _safeMint(address to, uint256 tokenId) internal virtual {
839         _safeMint(to, tokenId, "");
840     }
841 
842     /**
843      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
844      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
845      */
846     function _safeMint(
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) internal virtual {
851         _mint(to, tokenId);
852         require(
853             _checkOnERC721Received(address(0), to, tokenId, _data),
854             "ERC721: transfer to non ERC721Receiver implementer"
855         );
856     }
857 
858     /**
859      * @dev Mints `tokenId` and transfers it to `to`.
860      *
861      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
862      *
863      * Requirements:
864      *
865      * - `tokenId` must not exist.
866      * - `to` cannot be the zero address.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _mint(address to, uint256 tokenId) internal virtual {
871         require(to != address(0), "ERC721: mint to the zero address");
872         require(!_exists(tokenId), "ERC721: token already minted");
873 
874         _beforeTokenTransfer(address(0), to, tokenId);
875 
876         _balances[to] += 1;
877         _owners[tokenId] = to;
878 
879         emit Transfer(address(0), to, tokenId);
880     }
881 
882     /**
883      * @dev Destroys `tokenId`.
884      * The approval is cleared when the token is burned.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must exist.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _burn(uint256 tokenId) internal virtual {
893         address owner = ERC721.ownerOf(tokenId);
894 
895         _beforeTokenTransfer(owner, address(0), tokenId);
896 
897         // Clear approvals
898         _approve(address(0), tokenId);
899 
900         _balances[owner] -= 1;
901         delete _owners[tokenId];
902 
903         emit Transfer(owner, address(0), tokenId);
904     }
905 
906     /**
907      * @dev Transfers `tokenId` from `from` to `to`.
908      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
909      *
910      * Requirements:
911      *
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must be owned by `from`.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _transfer(
918         address from,
919         address to,
920         uint256 tokenId
921     ) internal virtual {
922         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
923         require(to != address(0), "ERC721: transfer to the zero address");
924 
925         _beforeTokenTransfer(from, to, tokenId);
926 
927         // Clear approvals from the previous owner
928         _approve(address(0), tokenId);
929 
930         _balances[from] -= 1;
931         _balances[to] += 1;
932         _owners[tokenId] = to;
933 
934         emit Transfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev Approve `to` to operate on `tokenId`
939      *
940      * Emits a {Approval} event.
941      */
942     function _approve(address to, uint256 tokenId) internal virtual {
943         _tokenApprovals[tokenId] = to;
944         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
945     }
946 
947     /**
948      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
949      * The call is not executed if the target address is not a contract.
950      *
951      * @param from address representing the previous owner of the given token ID
952      * @param to target address that will receive the tokens
953      * @param tokenId uint256 ID of the token to be transferred
954      * @param _data bytes optional data to send along with the call
955      * @return bool whether the call correctly returned the expected magic value
956      */
957     function _checkOnERC721Received(
958         address from,
959         address to,
960         uint256 tokenId,
961         bytes memory _data
962     ) private returns (bool) {
963         if (to.isContract()) {
964             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
965                 return retval == IERC721Receiver.onERC721Received.selector;
966             } catch (bytes memory reason) {
967                 if (reason.length == 0) {
968                     revert("ERC721: transfer to non ERC721Receiver implementer");
969                 } else {
970                     assembly {
971                         revert(add(32, reason), mload(reason))
972                     }
973                 }
974             }
975         } else {
976             return true;
977         }
978     }
979 
980     /**
981      * @dev Hook that is called before any token transfer. This includes minting
982      * and burning.
983      *
984      * Calling conditions:
985      *
986      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
987      * transferred to `to`.
988      * - When `from` is zero, `tokenId` will be minted for `to`.
989      * - When `to` is zero, ``from``'s `tokenId` will be burned.
990      * - `from` and `to` are never both zero.
991      *
992      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
993      */
994     function _beforeTokenTransfer(
995         address from,
996         address to,
997         uint256 tokenId
998     ) internal virtual {}
999 }
1000 
1001 
1002 /**
1003  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1004  * @dev See https://eips.ethereum.org/EIPS/eip-721
1005  */
1006 interface IERC721Enumerable is IERC721 {
1007     /**
1008      * @dev Returns the total amount of tokens stored by the contract.
1009      */
1010     function totalSupply() external view returns (uint256);
1011 
1012     /**
1013      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1014      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1015      */
1016     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1017 
1018     /**
1019      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1020      * Use along with {totalSupply} to enumerate all tokens.
1021      */
1022     function tokenByIndex(uint256 index) external view returns (uint256);
1023 }
1024 
1025 
1026 /**
1027  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1028  * enumerability of all the token ids in the contract as well as all token ids owned by each
1029  * account.
1030  */
1031 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1032     // Mapping from owner to list of owned token IDs
1033     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1034 
1035     // Mapping from token ID to index of the owner tokens list
1036     mapping(uint256 => uint256) private _ownedTokensIndex;
1037 
1038     // Array with all token ids, used for enumeration
1039     uint256[] private _allTokens;
1040 
1041     // Mapping from token id to position in the allTokens array
1042     mapping(uint256 => uint256) private _allTokensIndex;
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      */
1047     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1048         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1053      */
1054     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1055         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1056         return _ownedTokens[owner][index];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-totalSupply}.
1061      */
1062     function totalSupply() public view virtual override returns (uint256) {
1063         return _allTokens.length;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Enumerable-tokenByIndex}.
1068      */
1069     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1070         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1071         return _allTokens[index];
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before any token transfer. This includes minting
1076      * and burning.
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1084      * - `from` cannot be the zero address.
1085      * - `to` cannot be the zero address.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _beforeTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual override {
1094         super._beforeTokenTransfer(from, to, tokenId);
1095 
1096         if (from == address(0)) {
1097             _addTokenToAllTokensEnumeration(tokenId);
1098         } else if (from != to) {
1099             _removeTokenFromOwnerEnumeration(from, tokenId);
1100         }
1101         if (to == address(0)) {
1102             _removeTokenFromAllTokensEnumeration(tokenId);
1103         } else if (to != from) {
1104             _addTokenToOwnerEnumeration(to, tokenId);
1105         }
1106     }
1107 
1108     /**
1109      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1110      * @param to address representing the new owner of the given token ID
1111      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1112      */
1113     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1114         uint256 length = ERC721.balanceOf(to);
1115         _ownedTokens[to][length] = tokenId;
1116         _ownedTokensIndex[tokenId] = length;
1117     }
1118 
1119     /**
1120      * @dev Private function to add a token to this extension's token tracking data structures.
1121      * @param tokenId uint256 ID of the token to be added to the tokens list
1122      */
1123     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1124         _allTokensIndex[tokenId] = _allTokens.length;
1125         _allTokens.push(tokenId);
1126     }
1127 
1128     /**
1129      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1130      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1131      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1132      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1133      * @param from address representing the previous owner of the given token ID
1134      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1135      */
1136     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1137         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1138         // then delete the last slot (swap and pop).
1139 
1140         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1141         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1142 
1143         // When the token to delete is the last token, the swap operation is unnecessary
1144         if (tokenIndex != lastTokenIndex) {
1145             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1146 
1147             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149         }
1150 
1151         // This also deletes the contents at the last position of the array
1152         delete _ownedTokensIndex[tokenId];
1153         delete _ownedTokens[from][lastTokenIndex];
1154     }
1155 
1156     /**
1157      * @dev Private function to remove a token from this extension's token tracking data structures.
1158      * This has O(1) time complexity, but alters the order of the _allTokens array.
1159      * @param tokenId uint256 ID of the token to be removed from the tokens list
1160      */
1161     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1162         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1163         // then delete the last slot (swap and pop).
1164 
1165         uint256 lastTokenIndex = _allTokens.length - 1;
1166         uint256 tokenIndex = _allTokensIndex[tokenId];
1167 
1168         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1169         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1170         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1171         uint256 lastTokenId = _allTokens[lastTokenIndex];
1172 
1173         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1174         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1175 
1176         // This also deletes the contents at the last position of the array
1177         delete _allTokensIndex[tokenId];
1178         _allTokens.pop();
1179     }
1180 }
1181 
1182 
1183 contract ZAPES is ERC721Enumerable, Ownable {
1184     using Strings for uint256;
1185     event MintZApe(address indexed sender, uint256 startWith, uint256 times);
1186 
1187     //supply counters 
1188     uint256 public totalZApes;
1189     uint256 public totalPublicZApes;
1190     uint256 public totalPrivZApes;
1191     uint256 public maxPublic = 9899;
1192     uint256 public maxPrivate = 100;
1193 
1194     uint256 public maxBatch = 10;
1195     uint256 public price = 90000000000000000;
1196     address public mintAddress;
1197 
1198     string private baseURI;
1199     string public hiddenURI;
1200 
1201     bool private started = false;
1202     bool private revealed = false;
1203 
1204     //constructor args 
1205     constructor(string memory name_, string memory symbol_, string memory hiddenURI_) ERC721(name_, symbol_) {
1206         hiddenURI = hiddenURI_;
1207     }
1208 
1209     //basic functions. 
1210     function _baseURI() internal view virtual override returns (string memory){
1211         return baseURI;
1212     }
1213 
1214     function setBaseURI(string memory _newURI) public onlyOwner {
1215         baseURI = _newURI;
1216     }
1217 
1218     function setHiddenURI(string memory _newHiddenURI) public onlyOwner {
1219         hiddenURI = _newHiddenURI;
1220     }
1221 
1222     function setMintAddress(address mint_) public onlyOwner {
1223         mintAddress = mint_;
1224     }
1225 
1226     function reveal() public onlyOwner {
1227         revealed = true;
1228     }
1229 
1230     //erc721 
1231     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1232         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1233 
1234         if(revealed == false) {
1235             return hiddenURI;
1236         }
1237 
1238         string memory baseURI_ = _baseURI();
1239         return bytes(baseURI_).length > 0
1240             ? string(abi.encodePacked(baseURI_, tokenId.toString(), ".json")) : '.json';
1241     }
1242 
1243     function setStart(bool _start) public onlyOwner {
1244         started = _start;
1245     }
1246 
1247     function tokensOfOwner(address owner)
1248         public
1249         view
1250         returns (uint256[] memory)
1251     {
1252         uint256 count = balanceOf(owner);
1253         uint256[] memory ids = new uint256[](count);
1254         for (uint256 i = 0; i < count; i++) {
1255             ids[i] = tokenOfOwnerByIndex(owner, i);
1256         }
1257         return ids;
1258     }
1259 
1260     // Only a limited quantity can be minted
1261     function mintDev(address to, uint256 _times) external {
1262         require(_msgSender() == owner() || _msgSender() == mintAddress, "only owner or the mintAddress are allowed");
1263         require(totalPrivZApes + _times <= maxPrivate, "max supply reached for owner");
1264         emit MintZApe(_msgSender(), totalZApes+1, _times);
1265         for(uint256 i=0; i< _times; i++){
1266             totalPrivZApes++;
1267             _mint(to, 1 + totalZApes++);
1268         }
1269     }  
1270 
1271     function mint(uint256 _times) payable public {
1272         require(started, "not started");
1273         require(_times >0 && _times <= maxBatch, "must mint fewer in each batch");
1274         require(totalPublicZApes + _times <= maxPublic, "max supply reached!");
1275         require(msg.value == _times * price, "value error, please check price.");
1276         payable(owner()).transfer(msg.value);
1277         emit MintZApe(_msgSender(), totalZApes+1, _times);
1278         for(uint256 i=0; i< _times; i++){
1279             totalPublicZApes++;
1280             _mint(_msgSender(), 1 + totalZApes++);
1281         }
1282     }  
1283 }