1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 
164 
165 
166 /**
167  * @dev String operations.
168  */
169 library Strings {
170     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
171 
172     /**
173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
174      */
175     function toString(uint256 value) internal pure returns (string memory) {
176         // Inspired by OraclizeAPI's implementation - MIT licence
177         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
178 
179         if (value == 0) {
180             return "0";
181         }
182         uint256 temp = value;
183         uint256 digits;
184         while (temp != 0) {
185             digits++;
186             temp /= 10;
187         }
188         bytes memory buffer = new bytes(digits);
189         while (value != 0) {
190             digits -= 1;
191             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
192             value /= 10;
193         }
194         return string(buffer);
195     }
196 
197     /**
198      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
199      */
200     function toHexString(uint256 value) internal pure returns (string memory) {
201         if (value == 0) {
202             return "0x00";
203         }
204         uint256 temp = value;
205         uint256 length = 0;
206         while (temp != 0) {
207             length++;
208             temp >>= 8;
209         }
210         return toHexString(value, length);
211     }
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
215      */
216     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
217         bytes memory buffer = new bytes(2 * length + 2);
218         buffer[0] = "0";
219         buffer[1] = "x";
220         for (uint256 i = 2 * length + 1; i > 1; --i) {
221             buffer[i] = _HEX_SYMBOLS[value & 0xf];
222             value >>= 4;
223         }
224         require(value == 0, "Strings: hex length insufficient");
225         return string(buffer);
226     }
227 }
228 
229 
230 
231 
232 /*
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         return msg.data;
249     }
250 }
251 
252 
253 
254 
255 
256 
257 
258 
259 
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * By default, the owner account will be the one that deploys the contract. This
266  * can later be changed with {transferOwnership}.
267  *
268  * This module is used through inheritance. It will make available the modifier
269  * `onlyOwner`, which can be applied to your functions to restrict their use to
270  * the owner.
271  */
272 abstract contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev Initializes the contract setting the deployer as the initial owner.
279      */
280     constructor() {
281         _setOwner(_msgSender());
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view virtual returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(owner() == _msgSender(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public virtual onlyOwner {
307         _setOwner(address(0));
308     }
309 
310     /**
311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
312      * Can only be called by the current owner.
313      */
314     function transferOwnership(address newOwner) public virtual onlyOwner {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         _setOwner(newOwner);
317     }
318 
319     function _setOwner(address newOwner) private {
320         address oldOwner = _owner;
321         _owner = newOwner;
322         emit OwnershipTransferred(oldOwner, newOwner);
323     }
324 }
325 
326 
327 
328 
329 
330 /**
331  * @dev Contract module that helps prevent reentrant calls to a function.
332  *
333  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
334  * available, which can be applied to functions to make sure there are no nested
335  * (reentrant) calls to them.
336  *
337  * Note that because there is a single `nonReentrant` guard, functions marked as
338  * `nonReentrant` may not call one another. This can be worked around by making
339  * those functions `private`, and then adding `external` `nonReentrant` entry
340  * points to them.
341  *
342  * TIP: If you would like to learn more about reentrancy and alternative ways
343  * to protect against it, check out our blog post
344  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
345  */
346 abstract contract ReentrancyGuard {
347     // Booleans are more expensive than uint256 or any type that takes up a full
348     // word because each write operation emits an extra SLOAD to first read the
349     // slot's contents, replace the bits taken up by the boolean, and then write
350     // back. This is the compiler's defense against contract upgrades and
351     // pointer aliasing, and it cannot be disabled.
352 
353     // The values being non-zero value makes deployment a bit more expensive,
354     // but in exchange the refund on every call to nonReentrant will be lower in
355     // amount. Since refunds are capped to a percentage of the total
356     // transaction's gas, it is best to keep them low in cases like this one, to
357     // increase the likelihood of the full refund coming into effect.
358     uint256 private constant _NOT_ENTERED = 1;
359     uint256 private constant _ENTERED = 2;
360 
361     uint256 private _status;
362 
363     constructor() {
364         _status = _NOT_ENTERED;
365     }
366 
367     /**
368      * @dev Prevents a contract from calling itself, directly or indirectly.
369      * Calling a `nonReentrant` function from another `nonReentrant`
370      * function is not supported. It is possible to prevent this from happening
371      * by making the `nonReentrant` function external, and make it call a
372      * `private` function that does the actual work.
373      */
374     modifier nonReentrant() {
375         // On the first call to nonReentrant, _notEntered will be true
376         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
377 
378         // Any calls to nonReentrant after this point will fail
379         _status = _ENTERED;
380 
381         _;
382 
383         // By storing the original value once again, a refund is triggered (see
384         // https://eips.ethereum.org/EIPS/eip-2200)
385         _status = _NOT_ENTERED;
386     }
387 }
388 
389 
390 
391 
392 
393 
394 
395 
396 
397 
398 
399 
400 
401 
402 /**
403  * @title ERC721 token receiver interface
404  * @dev Interface for any contract that wants to support safeTransfers
405  * from ERC721 asset contracts.
406  */
407 interface IERC721Receiver {
408     /**
409      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
410      * by `operator` from `from`, this function is called.
411      *
412      * It must return its Solidity selector to confirm the token transfer.
413      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
414      *
415      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
416      */
417     function onERC721Received(
418         address operator,
419         address from,
420         uint256 tokenId,
421         bytes calldata data
422     ) external returns (bytes4);
423 }
424 
425 
426 
427 
428 
429 
430 
431 /**
432  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
433  * @dev See https://eips.ethereum.org/EIPS/eip-721
434  */
435 interface IERC721Metadata is IERC721 {
436     /**
437      * @dev Returns the token collection name.
438      */
439     function name() external view returns (string memory);
440 
441     /**
442      * @dev Returns the token collection symbol.
443      */
444     function symbol() external view returns (string memory);
445 
446     /**
447      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
448      */
449     function tokenURI(uint256 tokenId) external view returns (string memory);
450 }
451 
452 
453 
454 
455 
456 /**
457  * @dev Collection of functions related to the address type
458  */
459 library Address {
460     /**
461      * @dev Returns true if `account` is a contract.
462      *
463      * [IMPORTANT]
464      * ====
465      * It is unsafe to assume that an address for which this function returns
466      * false is an externally-owned account (EOA) and not a contract.
467      *
468      * Among others, `isContract` will return false for the following
469      * types of addresses:
470      *
471      *  - an externally-owned account
472      *  - a contract in construction
473      *  - an address where a contract will be created
474      *  - an address where a contract lived, but was destroyed
475      * ====
476      */
477     function isContract(address account) internal view returns (bool) {
478         // This method relies on extcodesize, which returns 0 for contracts in
479         // construction, since the code is only stored at the end of the
480         // constructor execution.
481 
482         uint256 size;
483         assembly {
484             size := extcodesize(account)
485         }
486         return size > 0;
487     }
488 
489     /**
490      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
491      * `recipient`, forwarding all available gas and reverting on errors.
492      *
493      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
494      * of certain opcodes, possibly making contracts go over the 2300 gas limit
495      * imposed by `transfer`, making them unable to receive funds via
496      * `transfer`. {sendValue} removes this limitation.
497      *
498      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
499      *
500      * IMPORTANT: because control is transferred to `recipient`, care must be
501      * taken to not create reentrancy vulnerabilities. Consider using
502      * {ReentrancyGuard} or the
503      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
504      */
505     function sendValue(address payable recipient, uint256 amount) internal {
506         require(address(this).balance >= amount, "Address: insufficient balance");
507 
508         (bool success, ) = recipient.call{value: amount}("");
509         require(success, "Address: unable to send value, recipient may have reverted");
510     }
511 
512     /**
513      * @dev Performs a Solidity function call using a low level `call`. A
514      * plain `call` is an unsafe replacement for a function call: use this
515      * function instead.
516      *
517      * If `target` reverts with a revert reason, it is bubbled up by this
518      * function (like regular Solidity function calls).
519      *
520      * Returns the raw returned data. To convert to the expected return value,
521      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
522      *
523      * Requirements:
524      *
525      * - `target` must be a contract.
526      * - calling `target` with `data` must not revert.
527      *
528      * _Available since v3.1._
529      */
530     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
531         return functionCall(target, data, "Address: low-level call failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
536      * `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(
541         address target,
542         bytes memory data,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         return functionCallWithValue(target, data, 0, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but also transferring `value` wei to `target`.
551      *
552      * Requirements:
553      *
554      * - the calling contract must have an ETH balance of at least `value`.
555      * - the called Solidity function must be `payable`.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value
563     ) internal returns (bytes memory) {
564         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
569      * with `errorMessage` as a fallback revert reason when `target` reverts.
570      *
571      * _Available since v3.1._
572      */
573     function functionCallWithValue(
574         address target,
575         bytes memory data,
576         uint256 value,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         require(address(this).balance >= value, "Address: insufficient balance for call");
580         require(isContract(target), "Address: call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.call{value: value}(data);
583         return _verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
593         return functionStaticCall(target, data, "Address: low-level static call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(
603         address target,
604         bytes memory data,
605         string memory errorMessage
606     ) internal view returns (bytes memory) {
607         require(isContract(target), "Address: static call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.staticcall(data);
610         return _verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but performing a delegate call.
616      *
617      * _Available since v3.4._
618      */
619     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
620         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
625      * but performing a delegate call.
626      *
627      * _Available since v3.4._
628      */
629     function functionDelegateCall(
630         address target,
631         bytes memory data,
632         string memory errorMessage
633     ) internal returns (bytes memory) {
634         require(isContract(target), "Address: delegate call to non-contract");
635 
636         (bool success, bytes memory returndata) = target.delegatecall(data);
637         return _verifyCallResult(success, returndata, errorMessage);
638     }
639 
640     function _verifyCallResult(
641         bool success,
642         bytes memory returndata,
643         string memory errorMessage
644     ) private pure returns (bytes memory) {
645         if (success) {
646             return returndata;
647         } else {
648             // Look for revert reason and bubble it up if present
649             if (returndata.length > 0) {
650                 // The easiest way to bubble the revert reason is using memory via assembly
651 
652                 assembly {
653                     let returndata_size := mload(returndata)
654                     revert(add(32, returndata), returndata_size)
655                 }
656             } else {
657                 revert(errorMessage);
658             }
659         }
660     }
661 }
662 
663 
664 
665 
666 
667 
668 
669 
670 
671 /**
672  * @dev Implementation of the {IERC165} interface.
673  *
674  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
675  * for the additional interface id that will be supported. For example:
676  *
677  * ```solidity
678  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
679  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
680  * }
681  * ```
682  *
683  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
684  */
685 abstract contract ERC165 is IERC165 {
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690         return interfaceId == type(IERC165).interfaceId;
691     }
692 }
693 
694 
695 /**
696  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
697  * the Metadata extension, but not including the Enumerable extension, which is available separately as
698  * {ERC721Enumerable}.
699  */
700 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
701     using Address for address;
702     using Strings for uint256;
703 
704     // Token name
705     string private _name;
706 
707     // Token symbol
708     string private _symbol;
709 
710     // Mapping from token ID to owner address
711     mapping(uint256 => address) private _owners;
712 
713     // Mapping owner address to token count
714     mapping(address => uint256) private _balances;
715 
716     // Mapping from token ID to approved address
717     mapping(uint256 => address) private _tokenApprovals;
718 
719     // Mapping from owner to operator approvals
720     mapping(address => mapping(address => bool)) private _operatorApprovals;
721 
722     /**
723      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
724      */
725     constructor(string memory name_, string memory symbol_) {
726         _name = name_;
727         _symbol = symbol_;
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
734         return
735             interfaceId == type(IERC721).interfaceId ||
736             interfaceId == type(IERC721Metadata).interfaceId ||
737             super.supportsInterface(interfaceId);
738     }
739 
740     /**
741      * @dev See {IERC721-balanceOf}.
742      */
743     function balanceOf(address owner) public view virtual override returns (uint256) {
744         require(owner != address(0), "ERC721: balance query for the zero address");
745         return _balances[owner];
746     }
747 
748     /**
749      * @dev See {IERC721-ownerOf}.
750      */
751     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
752         address owner = _owners[tokenId];
753         require(owner != address(0), "ERC721: owner query for nonexistent token");
754         return owner;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-name}.
759      */
760     function name() public view virtual override returns (string memory) {
761         return _name;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-symbol}.
766      */
767     function symbol() public view virtual override returns (string memory) {
768         return _symbol;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-tokenURI}.
773      */
774     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
775         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
776 
777         string memory baseURI = _baseURI();
778         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
779     }
780 
781     /**
782      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
783      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
784      * by default, can be overriden in child contracts.
785      */
786     function _baseURI() internal view virtual returns (string memory) {
787         return "";
788     }
789 
790     /**
791      * @dev See {IERC721-approve}.
792      */
793     function approve(address to, uint256 tokenId) public virtual override {
794         address owner = ERC721.ownerOf(tokenId);
795         require(to != owner, "ERC721: approval to current owner");
796 
797         require(
798             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
799             "ERC721: approve caller is not owner nor approved for all"
800         );
801 
802         _approve(to, tokenId);
803     }
804 
805     /**
806      * @dev See {IERC721-getApproved}.
807      */
808     function getApproved(uint256 tokenId) public view virtual override returns (address) {
809         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
810 
811         return _tokenApprovals[tokenId];
812     }
813 
814     /**
815      * @dev See {IERC721-setApprovalForAll}.
816      */
817     function setApprovalForAll(address operator, bool approved) public virtual override {
818         require(operator != _msgSender(), "ERC721: approve to caller");
819 
820         _operatorApprovals[_msgSender()][operator] = approved;
821         emit ApprovalForAll(_msgSender(), operator, approved);
822     }
823 
824     /**
825      * @dev See {IERC721-isApprovedForAll}.
826      */
827     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
828         return _operatorApprovals[owner][operator];
829     }
830 
831     /**
832      * @dev See {IERC721-transferFrom}.
833      */
834     function transferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) public virtual override {
839         //solhint-disable-next-line max-line-length
840         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
841 
842         _transfer(from, to, tokenId);
843     }
844 
845     /**
846      * @dev See {IERC721-safeTransferFrom}.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         safeTransferFrom(from, to, tokenId, "");
854     }
855 
856     /**
857      * @dev See {IERC721-safeTransferFrom}.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) public virtual override {
865         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
866         _safeTransfer(from, to, tokenId, _data);
867     }
868 
869     /**
870      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
871      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
872      *
873      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
874      *
875      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
876      * implement alternative mechanisms to perform token transfer, such as signature-based.
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must exist and be owned by `from`.
883      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _safeTransfer(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) internal virtual {
893         _transfer(from, to, tokenId);
894         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
895     }
896 
897     /**
898      * @dev Returns whether `tokenId` exists.
899      *
900      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
901      *
902      * Tokens start existing when they are minted (`_mint`),
903      * and stop existing when they are burned (`_burn`).
904      */
905     function _exists(uint256 tokenId) internal view virtual returns (bool) {
906         return _owners[tokenId] != address(0);
907     }
908 
909     /**
910      * @dev Returns whether `spender` is allowed to manage `tokenId`.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      */
916     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
917         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
918         address owner = ERC721.ownerOf(tokenId);
919         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
920     }
921 
922     /**
923      * @dev Safely mints `tokenId` and transfers it to `to`.
924      *
925      * Requirements:
926      *
927      * - `tokenId` must not exist.
928      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _safeMint(address to, uint256 tokenId) internal virtual {
933         _safeMint(to, tokenId, "");
934     }
935 
936     /**
937      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
938      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
939      */
940     function _safeMint(
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) internal virtual {
945         _mint(to, tokenId);
946         require(
947             _checkOnERC721Received(address(0), to, tokenId, _data),
948             "ERC721: transfer to non ERC721Receiver implementer"
949         );
950     }
951 
952     /**
953      * @dev Mints `tokenId` and transfers it to `to`.
954      *
955      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
956      *
957      * Requirements:
958      *
959      * - `tokenId` must not exist.
960      * - `to` cannot be the zero address.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _mint(address to, uint256 tokenId) internal virtual {
965         require(to != address(0), "ERC721: mint to the zero address");
966         require(!_exists(tokenId), "ERC721: token already minted");
967 
968         _beforeTokenTransfer(address(0), to, tokenId);
969 
970         _balances[to] += 1;
971         _owners[tokenId] = to;
972 
973         emit Transfer(address(0), to, tokenId);
974     }
975 
976     /**
977      * @dev Destroys `tokenId`.
978      * The approval is cleared when the token is burned.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _burn(uint256 tokenId) internal virtual {
987         address owner = ERC721.ownerOf(tokenId);
988 
989         _beforeTokenTransfer(owner, address(0), tokenId);
990 
991         // Clear approvals
992         _approve(address(0), tokenId);
993 
994         _balances[owner] -= 1;
995         delete _owners[tokenId];
996 
997         emit Transfer(owner, address(0), tokenId);
998     }
999 
1000     /**
1001      * @dev Transfers `tokenId` from `from` to `to`.
1002      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _transfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) internal virtual {
1016         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1017         require(to != address(0), "ERC721: transfer to the zero address");
1018 
1019         _beforeTokenTransfer(from, to, tokenId);
1020 
1021         // Clear approvals from the previous owner
1022         _approve(address(0), tokenId);
1023 
1024         _balances[from] -= 1;
1025         _balances[to] += 1;
1026         _owners[tokenId] = to;
1027 
1028         emit Transfer(from, to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Approve `to` to operate on `tokenId`
1033      *
1034      * Emits a {Approval} event.
1035      */
1036     function _approve(address to, uint256 tokenId) internal virtual {
1037         _tokenApprovals[tokenId] = to;
1038         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1043      * The call is not executed if the target address is not a contract.
1044      *
1045      * @param from address representing the previous owner of the given token ID
1046      * @param to target address that will receive the tokens
1047      * @param tokenId uint256 ID of the token to be transferred
1048      * @param _data bytes optional data to send along with the call
1049      * @return bool whether the call correctly returned the expected magic value
1050      */
1051     function _checkOnERC721Received(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) private returns (bool) {
1057         if (to.isContract()) {
1058             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1059                 return retval == IERC721Receiver(to).onERC721Received.selector;
1060             } catch (bytes memory reason) {
1061                 if (reason.length == 0) {
1062                     revert("ERC721: transfer to non ERC721Receiver implementer");
1063                 } else {
1064                     assembly {
1065                         revert(add(32, reason), mload(reason))
1066                     }
1067                 }
1068             }
1069         } else {
1070             return true;
1071         }
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
1084      * - `from` and `to` are never both zero.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _beforeTokenTransfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual {}
1093 }
1094 
1095 
1096 
1097 
1098 
1099 
1100 
1101 /**
1102  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1103  * @dev See https://eips.ethereum.org/EIPS/eip-721
1104  */
1105 interface IERC721Enumerable is IERC721 {
1106     /**
1107      * @dev Returns the total amount of tokens stored by the contract.
1108      */
1109     function totalSupply() external view returns (uint256);
1110 
1111     /**
1112      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1113      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1114      */
1115     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1116 
1117     /**
1118      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1119      * Use along with {totalSupply} to enumerate all tokens.
1120      */
1121     function tokenByIndex(uint256 index) external view returns (uint256);
1122 }
1123 
1124 
1125 /**
1126  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1127  * enumerability of all the token ids in the contract as well as all token ids owned by each
1128  * account.
1129  */
1130 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1131     // Mapping from owner to list of owned token IDs
1132     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1133 
1134     // Mapping from token ID to index of the owner tokens list
1135     mapping(uint256 => uint256) private _ownedTokensIndex;
1136 
1137     // Array with all token ids, used for enumeration
1138     uint256[] private _allTokens;
1139 
1140     // Mapping from token id to position in the allTokens array
1141     mapping(uint256 => uint256) private _allTokensIndex;
1142 
1143     /**
1144      * @dev See {IERC165-supportsInterface}.
1145      */
1146     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1147         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1152      */
1153     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1154         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1155         return _ownedTokens[owner][index];
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Enumerable-totalSupply}.
1160      */
1161     function totalSupply() public view virtual override returns (uint256) {
1162         return _allTokens.length;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Enumerable-tokenByIndex}.
1167      */
1168     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1169         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1170         return _allTokens[index];
1171     }
1172 
1173     /**
1174      * @dev Hook that is called before any token transfer. This includes minting
1175      * and burning.
1176      *
1177      * Calling conditions:
1178      *
1179      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1180      * transferred to `to`.
1181      * - When `from` is zero, `tokenId` will be minted for `to`.
1182      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1183      * - `from` cannot be the zero address.
1184      * - `to` cannot be the zero address.
1185      *
1186      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1187      */
1188     function _beforeTokenTransfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) internal virtual override {
1193         super._beforeTokenTransfer(from, to, tokenId);
1194 
1195         if (from == address(0)) {
1196             _addTokenToAllTokensEnumeration(tokenId);
1197         } else if (from != to) {
1198             _removeTokenFromOwnerEnumeration(from, tokenId);
1199         }
1200         if (to == address(0)) {
1201             _removeTokenFromAllTokensEnumeration(tokenId);
1202         } else if (to != from) {
1203             _addTokenToOwnerEnumeration(to, tokenId);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1209      * @param to address representing the new owner of the given token ID
1210      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1211      */
1212     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1213         uint256 length = ERC721.balanceOf(to);
1214         _ownedTokens[to][length] = tokenId;
1215         _ownedTokensIndex[tokenId] = length;
1216     }
1217 
1218     /**
1219      * @dev Private function to add a token to this extension's token tracking data structures.
1220      * @param tokenId uint256 ID of the token to be added to the tokens list
1221      */
1222     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1223         _allTokensIndex[tokenId] = _allTokens.length;
1224         _allTokens.push(tokenId);
1225     }
1226 
1227     /**
1228      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1229      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1230      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1231      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1232      * @param from address representing the previous owner of the given token ID
1233      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1234      */
1235     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1236         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1237         // then delete the last slot (swap and pop).
1238 
1239         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1240         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1241 
1242         // When the token to delete is the last token, the swap operation is unnecessary
1243         if (tokenIndex != lastTokenIndex) {
1244             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1245 
1246             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1247             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1248         }
1249 
1250         // This also deletes the contents at the last position of the array
1251         delete _ownedTokensIndex[tokenId];
1252         delete _ownedTokens[from][lastTokenIndex];
1253     }
1254 
1255     /**
1256      * @dev Private function to remove a token from this extension's token tracking data structures.
1257      * This has O(1) time complexity, but alters the order of the _allTokens array.
1258      * @param tokenId uint256 ID of the token to be removed from the tokens list
1259      */
1260     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1261         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1262         // then delete the last slot (swap and pop).
1263 
1264         uint256 lastTokenIndex = _allTokens.length - 1;
1265         uint256 tokenIndex = _allTokensIndex[tokenId];
1266 
1267         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1268         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1269         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1270         uint256 lastTokenId = _allTokens[lastTokenIndex];
1271 
1272         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1273         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1274 
1275         // This also deletes the contents at the last position of the array
1276         delete _allTokensIndex[tokenId];
1277         _allTokens.pop();
1278     }
1279 }
1280 
1281 contract TINY83 is ERC721Enumerable, Ownable {
1282 
1283     uint256 public price = 40000000000000000; //0.04 Eth
1284     uint256 public MAX_SUPPLY = 5555;
1285     bool public saleIsActive = true;
1286 
1287     string constant header = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500"> <rect x="0" y="0" width="500" height="500" style="fill:#';
1288 
1289     string constant face = '" /> <rect x="200" y="50" width="110" height="10" style="fill:#000" /> <rect x="300" y="50" width="10" height="20" style="fill:#000" /> <rect x="200" y="50" width="10" height="60" style="fill:#000" /> <rect x="190" y="100" width="30" height="40" style="fill:#000" /> <rect x="250" y="100" width="20" height="30" style="fill:#fff" /> <rect x="280" y="100" width="20" height="30" style="fill:#fff" /> <rect x="260" y="110" width="10" height="20" style="fill:#000" /> <rect x="290" y="110" width="10" height="20" style="fill:#000" /> <rect x="270" y="140" width="10" height="10" style="fill:#e74c3c" /> <rect x="210" y="170" width="80" height="20" style="fill:#000" /> <rect x="135" y="185" width="230" height="150" style="fill:#';
1290 
1291     struct Calculator {
1292         uint8 bg;
1293         uint8 head;
1294         uint8 screen;
1295         uint8 legs;
1296     }
1297 
1298     string[] private bg = ["ac8", "ebf", "9de", "df9", "dda", "ed9", "999", "89c"];
1299     string[] private head = ["70d", "653", "90f", "2b7", "22d", "22d", "fd1", "b91", "22d", "b91", "22d", "b91", "70d", "f80", "f80", "653", "22d", "f80", "70d", "22d", "653", "f80", "fd1", "70d", "653", "b91", "22d", "f80", "90f", "f80", "f80", "90f", "653", "22d", "653", "b91"];
1300     string[] private screen = ["f48", "ff0", "90f", "d00", "f48", "d60", "f48", "0f0", "90f", "d00", "90f", "00d", "ddd", "0f0", "90f", "0f0", "ddd", "0f0", "90f", "ff0", "d00", "d00", "d60", "0f0", "ff0", "d00", "ff0", "ff0", "d00", "0f0", "d60", "0f0", "90f", "90f", "d60", "0f0"];
1301     string[] private pixels = ["661b36", "666600", "3d0066", "580000", "661b36", "582800", "661b36", "006600", "3d0066", "580000", "3d0066", "000058", "585858", "006600", "3d0066", "006600", "585858", "006600", "3d0066", "666600", "580000", "580000", "582800", "006600", "666600", "580000", "666600", "666600", "580000", "006600", "582800", "006600", "3d0066", "3d0066", "582800", "006600"];
1302     string[] private legs = ["00f", "f48", "d0d", "f00", "d0d", "d0d", "f80", "ff0", "f48", "f0f", "00f", "f80", "90f", "f0f", "f48", "f48", "f80", "d0d", "f0f", "f00", "f00", "00f", "00f", "f48", "f0f", "f80", "f80", "f80", "00f", "f80", "f80", "f48", "ff0", "f0f", "f0f", "f48"];
1303 
1304     struct Curve {
1305         uint160 leftPart;
1306         uint160 rightPart;
1307     }
1308 
1309     mapping (uint256 => Curve) public curves;
1310 
1311     function withdraw() public onlyOwner {
1312         uint balance = address(this).balance;
1313         payable(msg.sender).transfer(balance);
1314     }
1315 
1316     function flipSaleState() public onlyOwner {
1317         saleIsActive = !saleIsActive;
1318     }
1319 
1320     function random(bytes memory input, uint256 range) internal pure returns (uint256) {
1321         return uint256(keccak256(abi.encodePacked(input))) % range;
1322     }
1323 
1324     function getCalculator(uint256 tokenId) internal pure returns (Calculator memory) {
1325         Calculator memory calc;
1326 
1327         calc.bg = uint8(random(abi.encodePacked("BACKGROUND", toString(tokenId)), 8));
1328         calc.head = uint8(random(abi.encodePacked("HEAD", toString(tokenId)), 36));
1329         calc.screen = uint8(random(abi.encodePacked("SCREEN", toString(tokenId)), 36));
1330         calc.legs = uint8(random(abi.encodePacked("LEGS", toString(tokenId)), 36));
1331 
1332         return calc;
1333     }
1334 
1335     function getBoolean(uint256 _packedBools, uint256 _boolNumber) internal pure returns(bool) {
1336         uint256 flag = (_packedBools >> _boolNumber) & uint256(1);
1337         return (flag == 1 ? true : false);
1338     }
1339 
1340     function updateScreen(uint160 leftPart, uint160 rightPart, uint256 tokenId) public {
1341         require(ownerOf(tokenId) == _msgSender(), "Not the owner of this token");
1342         Curve memory curve;
1343         curve.leftPart = leftPart;
1344         curve.rightPart = rightPart;
1345         curves[tokenId] = curve;
1346     }
1347 
1348     function draw(Calculator memory calc, Curve memory curve) internal view returns (string memory) {
1349         string[8] memory parts;
1350 
1351         parts[0] = '"/> <rect x="190" y="70" width="120" height="100" style="fill:#';
1352         parts[1] = '" /> <rect x="180" y="80" width="140" height="80" style="fill:#';
1353         parts[2] = ';stroke-width:10;stroke:#000" /> <rect x="130" y="330" width="20" height="40" style="fill:#000" /> <rect x="350" y="330" width="20" height="40" style="fill:#000" /> <rect x="130" y="370" width="20" height="20" style="fill:#';
1354         parts[3] = '" /> <rect x="350" y="370" width="20" height="20" style="fill:#';
1355         parts[4] = '" /> <rect x="180" y="330" width="140" height="40" style="fill:#000" /> <rect x="180" y="370" width="140" height="60" style="fill:#';
1356         parts[5] = '" /> <rect x="210" y="390" width="80" height="40" style="fill:#';
1357         parts[6] = '" /> <rect x="180" y="430" width="160" height="10" style="fill:#000" /> <rect x="180" y="440" width="160" height="10" style="fill:#fff" /> <rect x="230" y="420" width="60" height="40" style="fill:#';
1358         parts[7] = '" />';
1359 
1360         string memory output = string(abi.encodePacked(bg[calc.bg], parts[0], head[calc.head], parts[1], head[calc.head], face, screen[calc.screen], parts[2], screen[calc.screen]));
1361         output = string(abi.encodePacked(output, parts[3], screen[calc.screen], parts[4], legs[calc.legs], parts[5], bg[calc.bg], parts[6], bg[calc.bg], parts[7]));
1362 
1363         for (uint256 i = 0; i < 154; i++) {
1364             if (getBoolean(curve.leftPart, i)) {
1365                 output = string(abi.encodePacked(output, '<rect x="', toString(140+(i/14)*10), '" y="', toString(190+(i%14)*10), '" width="10" height="10" style="fill:#', pixels[calc.screen],'" />'));
1366             }
1367 
1368             if (getBoolean(curve.rightPart, i)) {
1369                 output = string(abi.encodePacked(output, '<rect x="', toString(250+(i/14)*10), '" y="', toString(190+(i%14)*10), '" width="10" height="10" style="fill:#', pixels[calc.screen],'" />'));
1370             }
1371         }
1372 
1373         output = string(abi.encodePacked(output, '</svg>'));
1374         return output;
1375     }
1376 
1377     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1378         Calculator memory calc = getCalculator(tokenId);
1379 
1380         string memory output;
1381         output = header;
1382 
1383         string memory ds = draw(calc, curves[tokenId]);
1384         output = string(abi.encodePacked(output, ds));
1385 
1386         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Calculator #', toString(tokenId), '", "description": "5555 graphing calculator friends who can draw any function, 100% on chain. This project is the implementation of an idea shared by dom, Vine co-founder.", "attributes": [{"trait_type": "Background", "value": "#', bg[calc.bg], '"}, {"trait_type": "Head", "value": "#', head[calc.head], '"}, {"trait_type": "Screen", "value": "#', screen[calc.screen], '"}, {"trait_type": "Legs", "value": "#', legs[calc.legs], '"}], "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1387 
1388         output = string(abi.encodePacked('data:application/json;base64,', json));
1389 
1390         return output;
1391     }
1392 
1393     function mint(uint160 leftPart, uint160 rightPart) public payable {
1394         require(saleIsActive, "Sale must be active to mint");
1395         require(totalSupply() < MAX_SUPPLY, "Mint would exceed max supply");
1396         require(price <= msg.value, "Ether value sent is not correct");
1397 
1398         Curve memory curve;
1399         curve.leftPart = leftPart;
1400         curve.rightPart = rightPart;
1401         curves[totalSupply()] = curve;
1402 
1403         _safeMint(_msgSender(), totalSupply());
1404     }
1405 
1406     function toString(uint256 value) internal pure returns (string memory) {
1407     // Inspired by OraclizeAPI's implementation - MIT license
1408     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1409 
1410         if (value == 0) {
1411             return "0";
1412         }
1413         uint256 temp = value;
1414         uint256 digits;
1415         while (temp != 0) {
1416             digits++;
1417             temp /= 10;
1418         }
1419         bytes memory buffer = new bytes(digits);
1420         while (value != 0) {
1421             digits -= 1;
1422             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1423             value /= 10;
1424         }
1425         return string(buffer);
1426     }
1427 
1428     constructor() ERC721("TINY83", "TINY83") Ownable() {}
1429 }
1430 
1431 /// [MIT License]
1432 /// @title Base64
1433 /// @notice Provides a function for encoding some bytes in base64
1434 /// @author Brecht Devos <brecht@loopring.org>
1435 library Base64 {
1436     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1437 
1438     /// @notice Encodes some bytes to the base64 representation
1439     function encode(bytes memory data) internal pure returns (string memory) {
1440         uint256 len = data.length;
1441         if (len == 0) return "";
1442 
1443         // multiply by 4/3 rounded up
1444         uint256 encodedLen = 4 * ((len + 2) / 3);
1445 
1446         // Add some extra buffer at the end
1447         bytes memory result = new bytes(encodedLen + 32);
1448 
1449         bytes memory table = TABLE;
1450 
1451         assembly {
1452             let tablePtr := add(table, 1)
1453             let resultPtr := add(result, 32)
1454 
1455             for {
1456                 let i := 0
1457             } lt(i, len) {
1458 
1459             } {
1460                 i := add(i, 3)
1461                 let input := and(mload(add(data, i)), 0xffffff)
1462 
1463                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1464                 out := shl(8, out)
1465                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1466                 out := shl(8, out)
1467                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1468                 out := shl(8, out)
1469                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1470                 out := shl(224, out)
1471 
1472                 mstore(resultPtr, out)
1473 
1474                 resultPtr := add(resultPtr, 4)
1475             }
1476 
1477             switch mod(len, 3)
1478             case 1 {
1479                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1480             }
1481             case 2 {
1482                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1483             }
1484 
1485             mstore(result, encodedLen)
1486         }
1487 
1488         return string(result);
1489     }
1490 }