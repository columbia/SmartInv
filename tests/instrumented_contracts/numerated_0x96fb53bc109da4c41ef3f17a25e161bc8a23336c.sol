1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-01
7 */
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 
33 
34 
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 
175 
176 
177 /**
178  * @dev String operations.
179  */
180 library Strings {
181     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
182 
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
185      */
186     function toString(uint256 value) internal pure returns (string memory) {
187         // Inspired by OraclizeAPI's implementation - MIT licence
188         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
189 
190         if (value == 0) {
191             return "0";
192         }
193         uint256 temp = value;
194         uint256 digits;
195         while (temp != 0) {
196             digits++;
197             temp /= 10;
198         }
199         bytes memory buffer = new bytes(digits);
200         while (value != 0) {
201             digits -= 1;
202             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
203             value /= 10;
204         }
205         return string(buffer);
206     }
207 
208     /**
209      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
210      */
211     function toHexString(uint256 value) internal pure returns (string memory) {
212         if (value == 0) {
213             return "0x00";
214         }
215         uint256 temp = value;
216         uint256 length = 0;
217         while (temp != 0) {
218             length++;
219             temp >>= 8;
220         }
221         return toHexString(value, length);
222     }
223 
224     /**
225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
226      */
227     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
228         bytes memory buffer = new bytes(2 * length + 2);
229         buffer[0] = "0";
230         buffer[1] = "x";
231         for (uint256 i = 2 * length + 1; i > 1; --i) {
232             buffer[i] = _HEX_SYMBOLS[value & 0xf];
233             value >>= 4;
234         }
235         require(value == 0, "Strings: hex length insufficient");
236         return string(buffer);
237     }
238 }
239 
240 
241 
242 
243 /*
244  * @dev Provides information about the current execution context, including the
245  * sender of the transaction and its data. While these are generally available
246  * via msg.sender and msg.data, they should not be accessed in such a direct
247  * manner, since when dealing with meta-transactions the account sending and
248  * paying for execution may not be the actual sender (as far as an application
249  * is concerned).
250  *
251  * This contract is only required for intermediate, library-like contracts.
252  */
253 abstract contract Context {
254     function _msgSender() internal view virtual returns (address) {
255         return msg.sender;
256     }
257 
258     function _msgData() internal view virtual returns (bytes calldata) {
259         return msg.data;
260     }
261 }
262 
263 
264 
265 
266 
267 
268 
269 
270 
271 /**
272  * @dev Contract module which provides a basic access control mechanism, where
273  * there is an account (an owner) that can be granted exclusive access to
274  * specific functions.
275  *
276  * By default, the owner account will be the one that deploys the contract. This
277  * can later be changed with {transferOwnership}.
278  *
279  * This module is used through inheritance. It will make available the modifier
280  * `onlyOwner`, which can be applied to your functions to restrict their use to
281  * the owner.
282  */
283 abstract contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     /**
289      * @dev Initializes the contract setting the deployer as the initial owner.
290      */
291     constructor() {
292         _setOwner(_msgSender());
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public virtual onlyOwner {
318         _setOwner(address(0));
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         _setOwner(newOwner);
328     }
329 
330     function _setOwner(address newOwner) private {
331         address oldOwner = _owner;
332         _owner = newOwner;
333         emit OwnershipTransferred(oldOwner, newOwner);
334     }
335 }
336 
337 
338 
339 
340 
341 
342 
343 
344 
345 
346 
347 
348 
349 
350 /**
351  * @title ERC721 token receiver interface
352  * @dev Interface for any contract that wants to support safeTransfers
353  * from ERC721 asset contracts.
354  */
355 interface IERC721Receiver {
356     /**
357      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
358      * by `operator` from `from`, this function is called.
359      *
360      * It must return its Solidity selector to confirm the token transfer.
361      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
362      *
363      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
364      */
365     function onERC721Received(
366         address operator,
367         address from,
368         uint256 tokenId,
369         bytes calldata data
370     ) external returns (bytes4);
371 }
372 
373 
374 
375 
376 
377 
378 
379 /**
380  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
381  * @dev See https://eips.ethereum.org/EIPS/eip-721
382  */
383 interface IERC721Metadata is IERC721 {
384     /**
385      * @dev Returns the token collection name.
386      */
387     function name() external view returns (string memory);
388 
389     /**
390      * @dev Returns the token collection symbol.
391      */
392     function symbol() external view returns (string memory);
393 
394     /**
395      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
396      */
397     function tokenURI(uint256 tokenId) external view returns (string memory);
398 }
399 
400 
401 
402 
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies on extcodesize, which returns 0 for contracts in
427         // construction, since the code is only stored at the end of the
428         // constructor execution.
429 
430         uint256 size;
431         assembly {
432             size := extcodesize(account)
433         }
434         return size > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         (bool success, ) = recipient.call{value: amount}("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 
460     /**
461      * @dev Performs a Solidity function call using a low level `call`. A
462      * plain `call` is an unsafe replacement for a function call: use this
463      * function instead.
464      *
465      * If `target` reverts with a revert reason, it is bubbled up by this
466      * function (like regular Solidity function calls).
467      *
468      * Returns the raw returned data. To convert to the expected return value,
469      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
470      *
471      * Requirements:
472      *
473      * - `target` must be a contract.
474      * - calling `target` with `data` must not revert.
475      *
476      * _Available since v3.1._
477      */
478     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
517      * with `errorMessage` as a fallback revert reason when `target` reverts.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(address(this).balance >= value, "Address: insufficient balance for call");
528         require(isContract(target), "Address: call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.call{value: value}(data);
531         return _verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
541         return functionStaticCall(target, data, "Address: low-level static call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal view returns (bytes memory) {
555         require(isContract(target), "Address: static call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.staticcall(data);
558         return _verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but performing a delegate call.
564      *
565      * _Available since v3.4._
566      */
567     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
568         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
573      * but performing a delegate call.
574      *
575      * _Available since v3.4._
576      */
577     function functionDelegateCall(
578         address target,
579         bytes memory data,
580         string memory errorMessage
581     ) internal returns (bytes memory) {
582         require(isContract(target), "Address: delegate call to non-contract");
583 
584         (bool success, bytes memory returndata) = target.delegatecall(data);
585         return _verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     function _verifyCallResult(
589         bool success,
590         bytes memory returndata,
591         string memory errorMessage
592     ) private pure returns (bytes memory) {
593         if (success) {
594             return returndata;
595         } else {
596             // Look for revert reason and bubble it up if present
597             if (returndata.length > 0) {
598                 // The easiest way to bubble the revert reason is using memory via assembly
599 
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 
612 
613 
614 
615 
616 
617 
618 
619 /**
620  * @dev Implementation of the {IERC165} interface.
621  *
622  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
623  * for the additional interface id that will be supported. For example:
624  *
625  * ```solidity
626  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
627  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
628  * }
629  * ```
630  *
631  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
632  */
633 abstract contract ERC165 is IERC165 {
634     /**
635      * @dev See {IERC165-supportsInterface}.
636      */
637     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
638         return interfaceId == type(IERC165).interfaceId;
639     }
640 }
641 
642 
643 /**
644  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
645  * the Metadata extension, but not including the Enumerable extension, which is available separately as
646  * {ERC721Enumerable}.
647  */
648 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
649     using Address for address;
650     using Strings for uint256;
651 
652     // Token name
653     string private _name;
654 
655     // Token symbol
656     string private _symbol;
657 
658     // Mapping from token ID to owner address
659     mapping(uint256 => address) private _owners;
660 
661     // Mapping owner address to token count
662     mapping(address => uint256) private _balances;
663 
664     // Mapping from token ID to approved address
665     mapping(uint256 => address) private _tokenApprovals;
666 
667     // Mapping from owner to operator approvals
668     mapping(address => mapping(address => bool)) private _operatorApprovals;
669 
670     /**
671      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
672      */
673     constructor(string memory name_, string memory symbol_) {
674         _name = name_;
675         _symbol = symbol_;
676     }
677 
678     /**
679      * @dev See {IERC165-supportsInterface}.
680      */
681     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
682         return
683             interfaceId == type(IERC721).interfaceId ||
684             interfaceId == type(IERC721Metadata).interfaceId ||
685             super.supportsInterface(interfaceId);
686     }
687 
688     /**
689      * @dev See {IERC721-balanceOf}.
690      */
691     function balanceOf(address owner) public view virtual override returns (uint256) {
692         require(owner != address(0), "ERC721: balance query for the zero address");
693         return _balances[owner];
694     }
695 
696     /**
697      * @dev See {IERC721-ownerOf}.
698      */
699     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
700         address owner = _owners[tokenId];
701         require(owner != address(0), "ERC721: owner query for nonexistent token");
702         return owner;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-name}.
707      */
708     function name() public view virtual override returns (string memory) {
709         return _name;
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-symbol}.
714      */
715     function symbol() public view virtual override returns (string memory) {
716         return _symbol;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-tokenURI}.
721      */
722     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
723         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
724 
725         string memory baseURI = _baseURI();
726         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
727     }
728 
729     /**
730      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
731      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
732      * by default, can be overriden in child contracts.
733      */
734     function _baseURI() internal view virtual returns (string memory) {
735         return "";
736     }
737 
738     /**
739      * @dev See {IERC721-approve}.
740      */
741     function approve(address to, uint256 tokenId) public virtual override {
742         address owner = ERC721.ownerOf(tokenId);
743         require(to != owner, "ERC721: approval to current owner");
744 
745         require(
746             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
747             "ERC721: approve caller is not owner nor approved for all"
748         );
749 
750         _approve(to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-getApproved}.
755      */
756     function getApproved(uint256 tokenId) public view virtual override returns (address) {
757         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
758 
759         return _tokenApprovals[tokenId];
760     }
761 
762     /**
763      * @dev See {IERC721-setApprovalForAll}.
764      */
765     function setApprovalForAll(address operator, bool approved) public virtual override {
766         require(operator != _msgSender(), "ERC721: approve to caller");
767 
768         _operatorApprovals[_msgSender()][operator] = approved;
769         emit ApprovalForAll(_msgSender(), operator, approved);
770     }
771 
772     /**
773      * @dev See {IERC721-isApprovedForAll}.
774      */
775     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
776         return _operatorApprovals[owner][operator];
777     }
778 
779     /**
780      * @dev See {IERC721-transferFrom}.
781      */
782     function transferFrom(
783         address from,
784         address to,
785         uint256 tokenId
786     ) public virtual override {
787         //solhint-disable-next-line max-line-length
788         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
789 
790         _transfer(from, to, tokenId);
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) public virtual override {
801         safeTransferFrom(from, to, tokenId, "");
802     }
803 
804     /**
805      * @dev See {IERC721-safeTransferFrom}.
806      */
807     function safeTransferFrom(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) public virtual override {
813         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
814         _safeTransfer(from, to, tokenId, _data);
815     }
816 
817     /**
818      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
819      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
820      *
821      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
822      *
823      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
824      * implement alternative mechanisms to perform token transfer, such as signature-based.
825      *
826      * Requirements:
827      *
828      * - `from` cannot be the zero address.
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must exist and be owned by `from`.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _safeTransfer(
836         address from,
837         address to,
838         uint256 tokenId,
839         bytes memory _data
840     ) internal virtual {
841         _transfer(from, to, tokenId);
842         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
843     }
844 
845     /**
846      * @dev Returns whether `tokenId` exists.
847      *
848      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
849      *
850      * Tokens start existing when they are minted (`_mint`),
851      * and stop existing when they are burned (`_burn`).
852      */
853     function _exists(uint256 tokenId) internal view virtual returns (bool) {
854         return _owners[tokenId] != address(0);
855     }
856 
857     /**
858      * @dev Returns whether `spender` is allowed to manage `tokenId`.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      */
864     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
865         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
866         address owner = ERC721.ownerOf(tokenId);
867         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
868     }
869 
870     /**
871      * @dev Safely mints `tokenId` and transfers it to `to`.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must not exist.
876      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _safeMint(address to, uint256 tokenId) internal virtual {
881         _safeMint(to, tokenId, "");
882     }
883 
884     /**
885      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
886      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
887      */
888     function _safeMint(
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) internal virtual {
893         _mint(to, tokenId);
894         require(
895             _checkOnERC721Received(address(0), to, tokenId, _data),
896             "ERC721: transfer to non ERC721Receiver implementer"
897         );
898     }
899 
900     /**
901      * @dev Mints `tokenId` and transfers it to `to`.
902      *
903      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
904      *
905      * Requirements:
906      *
907      * - `tokenId` must not exist.
908      * - `to` cannot be the zero address.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _mint(address to, uint256 tokenId) internal virtual {
913         require(to != address(0), "ERC721: mint to the zero address");
914         require(!_exists(tokenId), "ERC721: token already minted");
915 
916         _beforeTokenTransfer(address(0), to, tokenId);
917 
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(address(0), to, tokenId);
922     }
923 
924     /**
925      * @dev Destroys `tokenId`.
926      * The approval is cleared when the token is burned.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _burn(uint256 tokenId) internal virtual {
935         address owner = ERC721.ownerOf(tokenId);
936 
937         _beforeTokenTransfer(owner, address(0), tokenId);
938 
939         // Clear approvals
940         _approve(address(0), tokenId);
941 
942         _balances[owner] -= 1;
943         delete _owners[tokenId];
944 
945         emit Transfer(owner, address(0), tokenId);
946     }
947 
948     /**
949      * @dev Transfers `tokenId` from `from` to `to`.
950      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
951      *
952      * Requirements:
953      *
954      * - `to` cannot be the zero address.
955      * - `tokenId` token must be owned by `from`.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _transfer(
960         address from,
961         address to,
962         uint256 tokenId
963     ) internal virtual {
964         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
965         require(to != address(0), "ERC721: transfer to the zero address");
966 
967         _beforeTokenTransfer(from, to, tokenId);
968 
969         // Clear approvals from the previous owner
970         _approve(address(0), tokenId);
971 
972         _balances[from] -= 1;
973         _balances[to] += 1;
974         _owners[tokenId] = to;
975 
976         emit Transfer(from, to, tokenId);
977     }
978 
979     /**
980      * @dev Approve `to` to operate on `tokenId`
981      *
982      * Emits a {Approval} event.
983      */
984     function _approve(address to, uint256 tokenId) internal virtual {
985         _tokenApprovals[tokenId] = to;
986         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
987     }
988 
989     /**
990      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
991      * The call is not executed if the target address is not a contract.
992      *
993      * @param from address representing the previous owner of the given token ID
994      * @param to target address that will receive the tokens
995      * @param tokenId uint256 ID of the token to be transferred
996      * @param _data bytes optional data to send along with the call
997      * @return bool whether the call correctly returned the expected magic value
998      */
999     function _checkOnERC721Received(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes memory _data
1004     ) private returns (bool) {
1005         if (to.isContract()) {
1006             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1007                 return retval == IERC721Receiver(to).onERC721Received.selector;
1008             } catch (bytes memory reason) {
1009                 if (reason.length == 0) {
1010                     revert("ERC721: transfer to non ERC721Receiver implementer");
1011                 } else {
1012                     assembly {
1013                         revert(add(32, reason), mload(reason))
1014                     }
1015                 }
1016             }
1017         } else {
1018             return true;
1019         }
1020     }
1021 
1022     /**
1023      * @dev Hook that is called before any token transfer. This includes minting
1024      * and burning.
1025      *
1026      * Calling conditions:
1027      *
1028      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1029      * transferred to `to`.
1030      * - When `from` is zero, `tokenId` will be minted for `to`.
1031      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1032      * - `from` and `to` are never both zero.
1033      *
1034      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1035      */
1036     function _beforeTokenTransfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) internal virtual {}
1041 }
1042 
1043 
1044 
1045 
1046 
1047 
1048 
1049 /**
1050  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1051  * @dev See https://eips.ethereum.org/EIPS/eip-721
1052  */
1053 interface IERC721Enumerable is IERC721 {
1054     /**
1055      * @dev Returns the total amount of tokens stored by the contract.
1056      */
1057     function totalSupply() external view returns (uint256);
1058 
1059     /**
1060      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1061      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1062      */
1063     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1064 
1065     /**
1066      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1067      * Use along with {totalSupply} to enumerate all tokens.
1068      */
1069     function tokenByIndex(uint256 index) external view returns (uint256);
1070 }
1071 
1072 
1073 /**
1074  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1075  * enumerability of all the token ids in the contract as well as all token ids owned by each
1076  * account.
1077  */
1078 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1079     // Mapping from owner to list of owned token IDs
1080     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1081 
1082     // Mapping from token ID to index of the owner tokens list
1083     mapping(uint256 => uint256) private _ownedTokensIndex;
1084 
1085     // Array with all token ids, used for enumeration
1086     uint256[] private _allTokens;
1087 
1088     // Mapping from token id to position in the allTokens array
1089     mapping(uint256 => uint256) private _allTokensIndex;
1090 
1091     /**
1092      * @dev See {IERC165-supportsInterface}.
1093      */
1094     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1095         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1096     }
1097 
1098     /**
1099      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1100      */
1101     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1102         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1103         return _ownedTokens[owner][index];
1104     }
1105 
1106     /**
1107      * @dev See {IERC721Enumerable-totalSupply}.
1108      */
1109     function totalSupply() public view virtual override returns (uint256) {
1110         return _allTokens.length;
1111     }
1112 
1113     /**
1114      * @dev See {IERC721Enumerable-tokenByIndex}.
1115      */
1116     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1117         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1118         return _allTokens[index];
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before any token transfer. This includes minting
1123      * and burning.
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` will be minted for `to`.
1130      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1131      * - `from` cannot be the zero address.
1132      * - `to` cannot be the zero address.
1133      *
1134      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1135      */
1136     function _beforeTokenTransfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) internal virtual override {
1141         super._beforeTokenTransfer(from, to, tokenId);
1142 
1143         if (from == address(0)) {
1144             _addTokenToAllTokensEnumeration(tokenId);
1145         } else if (from != to) {
1146             _removeTokenFromOwnerEnumeration(from, tokenId);
1147         }
1148         if (to == address(0)) {
1149             _removeTokenFromAllTokensEnumeration(tokenId);
1150         } else if (to != from) {
1151             _addTokenToOwnerEnumeration(to, tokenId);
1152         }
1153     }
1154 
1155     /**
1156      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1157      * @param to address representing the new owner of the given token ID
1158      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1159      */
1160     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1161         uint256 length = ERC721.balanceOf(to);
1162         _ownedTokens[to][length] = tokenId;
1163         _ownedTokensIndex[tokenId] = length;
1164     }
1165 
1166     /**
1167      * @dev Private function to add a token to this extension's token tracking data structures.
1168      * @param tokenId uint256 ID of the token to be added to the tokens list
1169      */
1170     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1171         _allTokensIndex[tokenId] = _allTokens.length;
1172         _allTokens.push(tokenId);
1173     }
1174 
1175     /**
1176      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1177      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1178      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1179      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1180      * @param from address representing the previous owner of the given token ID
1181      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1182      */
1183     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1184         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1185         // then delete the last slot (swap and pop).
1186 
1187         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1188         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1189 
1190         // When the token to delete is the last token, the swap operation is unnecessary
1191         if (tokenIndex != lastTokenIndex) {
1192             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1193 
1194             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1195             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1196         }
1197 
1198         // This also deletes the contents at the last position of the array
1199         delete _ownedTokensIndex[tokenId];
1200         delete _ownedTokens[from][lastTokenIndex];
1201     }
1202 
1203     /**
1204      * @dev Private function to remove a token from this extension's token tracking data structures.
1205      * This has O(1) time complexity, but alters the order of the _allTokens array.
1206      * @param tokenId uint256 ID of the token to be removed from the tokens list
1207      */
1208     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1209         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1210         // then delete the last slot (swap and pop).
1211 
1212         uint256 lastTokenIndex = _allTokens.length - 1;
1213         uint256 tokenIndex = _allTokensIndex[tokenId];
1214 
1215         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1216         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1217         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1218         uint256 lastTokenId = _allTokens[lastTokenIndex];
1219 
1220         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1221         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1222 
1223         // This also deletes the contents at the last position of the array
1224         delete _allTokensIndex[tokenId];
1225         _allTokens.pop();
1226     }
1227 }
1228 
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 
1233 contract Brainoids is ERC721Enumerable, Ownable {
1234     string baseURI;
1235     uint256 public constant MAX_BRAIN = 5555;
1236     uint256 public price = 55000000000000000;  //0.055 ETH
1237     uint256 public prePrice = 45000000000000000;  //0.045 ETH
1238     bool public publicSale = false;
1239     bool public preSale = false;
1240     mapping (address => uint256) public preMintAddrs;
1241     uint256 public preMintNums;
1242     address benefitAddr = 0x5eD624152EA66eE99fC50521430bf96Db69e1dfC;
1243     address devAddr = 0x3d0c83F3ABdEf9D19E2421Ed119A6C4557178c3B;
1244     
1245     constructor(string memory name, string memory symbol) ERC721(name, symbol) {
1246     }
1247     
1248     function getPreMintAddrNums() public view returns (uint256){
1249         return preMintAddrs[_msgSender()];
1250     }
1251     
1252     function getPrice() public view returns (uint256){
1253         return price;
1254     }
1255     
1256     function getPrePrice() public view returns (uint256){
1257         return prePrice;
1258     }
1259     
1260     function getSoldNum() public view returns (uint256){
1261         return totalSupply();
1262     }
1263     
1264     function withdraw() public onlyOwner {
1265         payable(devAddr).transfer(address(this).balance*5/100);
1266         payable(benefitAddr).transfer(address(this).balance);
1267     }
1268 
1269     function flipSaleState() public onlyOwner {
1270         publicSale = !publicSale;
1271     }
1272     
1273     function flipPreSaleState() public onlyOwner {
1274         preSale = !preSale;
1275     }
1276     
1277     function changePrice(uint256 newPrice) public onlyOwner {
1278         price = newPrice;
1279     }
1280     
1281     function changePrePrice(uint256 newPrice) public onlyOwner {
1282         prePrice = newPrice;
1283     }
1284     
1285     function setBaseURI(string memory _uri) public onlyOwner {
1286         baseURI = _uri;
1287     }
1288     
1289     function _baseURI() internal view virtual override returns (string memory) {
1290         return baseURI;
1291     }
1292     
1293     function ownerMint(uint nums) public onlyOwner{
1294         require(totalSupply() + nums < MAX_BRAIN, "sold out.");
1295         
1296         for(uint i = 0; i < nums; i++){
1297             uint id = totalSupply();
1298             if(id < MAX_BRAIN){
1299                 _safeMint(0xe6519aB01cEc48F59465E65d18619737e6697D11, id);
1300             }
1301         }
1302     }
1303     
1304     function setPreMintAddr(address[] memory addr) public onlyOwner{
1305         require(preSale, "Pre Sale not started.");
1306 
1307         uint addrLength = addr.length;
1308 
1309         for(uint i = 0; i < addrLength; i++){
1310             preMintAddrs[addr[i]] = preMintAddrs[addr[i]] + 5;
1311         }
1312     }
1313     
1314     function preMint(uint nums) external payable {
1315         require(preSale, "Pre Sale not started.");
1316         require(preMintAddrs[_msgSender()] >= nums, "can not pre mint more than you own.");
1317         require(preMintNums < 400, "ony 400 address can pre mint.");
1318         require(totalSupply() < MAX_BRAIN, "sold out.");
1319         require(totalSupply() + nums <= MAX_BRAIN, "not enough left.");
1320         
1321         uint salePrice = prePrice * nums;
1322         require(msg.value >= salePrice, "not enough funds to purchase.");
1323         
1324         for(uint i = 0; i < nums; i++){
1325             uint id = totalSupply();
1326             if(id < MAX_BRAIN){
1327                 _safeMint(_msgSender(), id);
1328             }
1329         }
1330         
1331         preMintAddrs[_msgSender()] = preMintAddrs[_msgSender()] - nums;
1332         preMintNums = preMintNums + 1;
1333     }
1334     
1335     function mint(uint nums) external payable {
1336         require(publicSale, "Sale not started.");
1337         require(nums <= 20, "nums not more than 20.");
1338         require(totalSupply() < MAX_BRAIN, "sold out.");
1339         require(totalSupply() + nums <= MAX_BRAIN, "not enough left.");
1340         
1341         uint salePrice = price * nums;
1342         require(msg.value >= salePrice, "not enough funds to purchase.");
1343         
1344         for(uint i = 0; i < nums; i++){
1345             uint id = totalSupply();
1346             if(id < MAX_BRAIN){
1347                 _safeMint(_msgSender(), id);
1348             }
1349         }
1350     }
1351 }