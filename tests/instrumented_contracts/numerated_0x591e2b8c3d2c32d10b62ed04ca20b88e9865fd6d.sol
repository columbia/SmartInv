1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 
32 
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 
173 
174 
175 /**
176  * @dev String operations.
177  */
178 library Strings {
179     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
180 
181     /**
182      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
183      */
184     function toString(uint256 value) internal pure returns (string memory) {
185         // Inspired by OraclizeAPI's implementation - MIT licence
186         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
187 
188         if (value == 0) {
189             return "0";
190         }
191         uint256 temp = value;
192         uint256 digits;
193         while (temp != 0) {
194             digits++;
195             temp /= 10;
196         }
197         bytes memory buffer = new bytes(digits);
198         while (value != 0) {
199             digits -= 1;
200             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
201             value /= 10;
202         }
203         return string(buffer);
204     }
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
208      */
209     function toHexString(uint256 value) internal pure returns (string memory) {
210         if (value == 0) {
211             return "0x00";
212         }
213         uint256 temp = value;
214         uint256 length = 0;
215         while (temp != 0) {
216             length++;
217             temp >>= 8;
218         }
219         return toHexString(value, length);
220     }
221 
222     /**
223      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
224      */
225     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
226         bytes memory buffer = new bytes(2 * length + 2);
227         buffer[0] = "0";
228         buffer[1] = "x";
229         for (uint256 i = 2 * length + 1; i > 1; --i) {
230             buffer[i] = _HEX_SYMBOLS[value & 0xf];
231             value >>= 4;
232         }
233         require(value == 0, "Strings: hex length insufficient");
234         return string(buffer);
235     }
236 }
237 
238 
239 
240 
241 /*
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 /**
262  * @dev Contract module that helps prevent reentrant calls to a function.
263  *
264  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
265  * available, which can be applied to functions to make sure there are no nested
266  * (reentrant) calls to them.
267  *
268  * Note that because there is a single `nonReentrant` guard, functions marked as
269  * `nonReentrant` may not call one another. This can be worked around by making
270  * those functions `private`, and then adding `external` `nonReentrant` entry
271  * points to them.
272  *
273  * TIP: If you would like to learn more about reentrancy and alternative ways
274  * to protect against it, check out our blog post
275  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
276  */
277 abstract contract ReentrancyGuard {
278     // Booleans are more expensive than uint256 or any type that takes up a full
279     // word because each write operation emits an extra SLOAD to first read the
280     // slot's contents, replace the bits taken up by the boolean, and then write
281     // back. This is the compiler's defense against contract upgrades and
282     // pointer aliasing, and it cannot be disabled.
283 
284     // The values being non-zero value makes deployment a bit more expensive,
285     // but in exchange the refund on every call to nonReentrant will be lower in
286     // amount. Since refunds are capped to a percentage of the total
287     // transaction's gas, it is best to keep them low in cases like this one, to
288     // increase the likelihood of the full refund coming into effect.
289     uint256 private constant _NOT_ENTERED = 1;
290     uint256 private constant _ENTERED = 2;
291 
292     uint256 private _status;
293 
294     constructor() {
295         _status = _NOT_ENTERED;
296     }
297 
298     /**
299      * @dev Prevents a contract from calling itself, directly or indirectly.
300      * Calling a `nonReentrant` function from another `nonReentrant`
301      * function is not supported. It is possible to prevent this from happening
302      * by making the `nonReentrant` function external, and make it call a
303      * `private` function that does the actual work.
304      */
305     modifier nonReentrant() {
306         // On the first call to nonReentrant, _notEntered will be true
307         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
308 
309         // Any calls to nonReentrant after this point will fail
310         _status = _ENTERED;
311 
312         _;
313 
314         // By storing the original value once again, a refund is triggered (see
315         // https://eips.ethereum.org/EIPS/eip-2200)
316         _status = _NOT_ENTERED;
317     }
318 }
319 
320 
321 
322 
323 
324 
325 
326 
327 
328 
329 
330 
331 
332 
333 /**
334  * @title ERC721 token receiver interface
335  * @dev Interface for any contract that wants to support safeTransfers
336  * from ERC721 asset contracts.
337  */
338 interface IERC721Receiver {
339     /**
340      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
341      * by `operator` from `from`, this function is called.
342      *
343      * It must return its Solidity selector to confirm the token transfer.
344      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
345      *
346      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
347      */
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 
357 
358 
359 
360 
361 
362 /**
363  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
364  * @dev See https://eips.ethereum.org/EIPS/eip-721
365  */
366 interface IERC721Metadata is IERC721 {
367     /**
368      * @dev Returns the token collection name.
369      */
370     function name() external view returns (string memory);
371 
372     /**
373      * @dev Returns the token collection symbol.
374      */
375     function symbol() external view returns (string memory);
376 
377     /**
378      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
379      */
380     function tokenURI(uint256 tokenId) external view returns (string memory);
381 }
382 
383 
384 
385 
386 
387 /**
388  * @dev Collection of functions related to the address type
389  */
390 library Address {
391     /**
392      * @dev Returns true if `account` is a contract.
393      *
394      * [IMPORTANT]
395      * ====
396      * It is unsafe to assume that an address for which this function returns
397      * false is an externally-owned account (EOA) and not a contract.
398      *
399      * Among others, `isContract` will return false for the following
400      * types of addresses:
401      *
402      *  - an externally-owned account
403      *  - a contract in construction
404      *  - an address where a contract will be created
405      *  - an address where a contract lived, but was destroyed
406      * ====
407      */
408     function isContract(address account) internal view returns (bool) {
409         // This method relies on extcodesize, which returns 0 for contracts in
410         // construction, since the code is only stored at the end of the
411         // constructor execution.
412 
413         uint256 size;
414         assembly {
415             size := extcodesize(account)
416         }
417         return size > 0;
418     }
419 
420     /**
421      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
422      * `recipient`, forwarding all available gas and reverting on errors.
423      *
424      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
425      * of certain opcodes, possibly making contracts go over the 2300 gas limit
426      * imposed by `transfer`, making them unable to receive funds via
427      * `transfer`. {sendValue} removes this limitation.
428      *
429      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
430      *
431      * IMPORTANT: because control is transferred to `recipient`, care must be
432      * taken to not create reentrancy vulnerabilities. Consider using
433      * {ReentrancyGuard} or the
434      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
435      */
436     function sendValue(address payable recipient, uint256 amount) internal {
437         require(address(this).balance >= amount, "Address: insufficient balance");
438 
439         (bool success, ) = recipient.call{value: amount}("");
440         require(success, "Address: unable to send value, recipient may have reverted");
441     }
442 
443     /**
444      * @dev Performs a Solidity function call using a low level `call`. A
445      * plain `call` is an unsafe replacement for a function call: use this
446      * function instead.
447      *
448      * If `target` reverts with a revert reason, it is bubbled up by this
449      * function (like regular Solidity function calls).
450      *
451      * Returns the raw returned data. To convert to the expected return value,
452      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
453      *
454      * Requirements:
455      *
456      * - `target` must be a contract.
457      * - calling `target` with `data` must not revert.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
467      * `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         return functionCallWithValue(target, data, 0, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but also transferring `value` wei to `target`.
482      *
483      * Requirements:
484      *
485      * - the calling contract must have an ETH balance of at least `value`.
486      * - the called Solidity function must be `payable`.
487      *
488      * _Available since v3.1._
489      */
490     function functionCallWithValue(
491         address target,
492         bytes memory data,
493         uint256 value
494     ) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
500      * with `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         require(address(this).balance >= value, "Address: insufficient balance for call");
511         require(isContract(target), "Address: call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.call{value: value}(data);
514         return _verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
524         return functionStaticCall(target, data, "Address: low-level static call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal view returns (bytes memory) {
538         require(isContract(target), "Address: static call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.staticcall(data);
541         return _verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
551         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(isContract(target), "Address: delegate call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.delegatecall(data);
568         return _verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     function _verifyCallResult(
572         bool success,
573         bytes memory returndata,
574         string memory errorMessage
575     ) private pure returns (bytes memory) {
576         if (success) {
577             return returndata;
578         } else {
579             // Look for revert reason and bubble it up if present
580             if (returndata.length > 0) {
581                 // The easiest way to bubble the revert reason is using memory via assembly
582 
583                 assembly {
584                     let returndata_size := mload(returndata)
585                     revert(add(32, returndata), returndata_size)
586                 }
587             } else {
588                 revert(errorMessage);
589             }
590         }
591     }
592 }
593 
594 
595 
596 
597 
598 
599 
600 
601 
602 /**
603  * @dev Implementation of the {IERC165} interface.
604  *
605  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
606  * for the additional interface id that will be supported. For example:
607  *
608  * ```solidity
609  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
611  * }
612  * ```
613  *
614  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
615  */
616 abstract contract ERC165 is IERC165 {
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
621         return interfaceId == type(IERC165).interfaceId;
622     }
623 }
624 
625 
626 /**
627  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
628  * the Metadata extension, but not including the Enumerable extension, which is available separately as
629  * {ERC721Enumerable}.
630  */
631 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
632     using Address for address;
633     using Strings for uint256;
634 
635     // Token name
636     string private _name;
637 
638     // Token symbol
639     string private _symbol;
640 
641     // Mapping from token ID to owner address
642     mapping(uint256 => address) private _owners;
643 
644     // Mapping owner address to token count
645     mapping(address => uint256) private _balances;
646 
647     // Mapping from token ID to approved address
648     mapping(uint256 => address) private _tokenApprovals;
649 
650     // Mapping from owner to operator approvals
651     mapping(address => mapping(address => bool)) private _operatorApprovals;
652 
653     /**
654      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
655      */
656     constructor(string memory name_, string memory symbol_) {
657         _name = name_;
658         _symbol = symbol_;
659     }
660 
661     /**
662      * @dev See {IERC165-supportsInterface}.
663      */
664     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
665         return
666             interfaceId == type(IERC721).interfaceId ||
667             interfaceId == type(IERC721Metadata).interfaceId ||
668             super.supportsInterface(interfaceId);
669     }
670 
671     /**
672      * @dev See {IERC721-balanceOf}.
673      */
674     function balanceOf(address owner) public view virtual override returns (uint256) {
675         require(owner != address(0), "ERC721: balance query for the zero address");
676         return _balances[owner];
677     }
678 
679     /**
680      * @dev See {IERC721-ownerOf}.
681      */
682     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
683         address owner = _owners[tokenId];
684         require(owner != address(0), "ERC721: owner query for nonexistent token");
685         return owner;
686     }
687 
688     /**
689      * @dev See {IERC721Metadata-name}.
690      */
691     function name() public view virtual override returns (string memory) {
692         return _name;
693     }
694 
695     /**
696      * @dev See {IERC721Metadata-symbol}.
697      */
698     function symbol() public view virtual override returns (string memory) {
699         return _symbol;
700     }
701 
702     /**
703      * @dev See {IERC721Metadata-tokenURI}.
704      */
705     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
706         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
707 
708         string memory baseURI = _baseURI();
709         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
710     }
711 
712     /**
713      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
714      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
715      * by default, can be overriden in child contracts.
716      */
717     function _baseURI() internal view virtual returns (string memory) {
718         return "";
719     }
720 
721     /**
722      * @dev See {IERC721-approve}.
723      */
724     function approve(address to, uint256 tokenId) public virtual override {
725         address owner = ERC721.ownerOf(tokenId);
726         require(to != owner, "ERC721: approval to current owner");
727 
728         require(
729             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
730             "ERC721: approve caller is not owner nor approved for all"
731         );
732 
733         _approve(to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-getApproved}.
738      */
739     function getApproved(uint256 tokenId) public view virtual override returns (address) {
740         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
741 
742         return _tokenApprovals[tokenId];
743     }
744 
745     /**
746      * @dev See {IERC721-setApprovalForAll}.
747      */
748     function setApprovalForAll(address operator, bool approved) public virtual override {
749         require(operator != _msgSender(), "ERC721: approve to caller");
750 
751         _operatorApprovals[_msgSender()][operator] = approved;
752         emit ApprovalForAll(_msgSender(), operator, approved);
753     }
754 
755     /**
756      * @dev See {IERC721-isApprovedForAll}.
757      */
758     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
759         return _operatorApprovals[owner][operator];
760     }
761 
762     /**
763      * @dev See {IERC721-transferFrom}.
764      */
765     function transferFrom(
766         address from,
767         address to,
768         uint256 tokenId
769     ) public virtual override {
770         //solhint-disable-next-line max-line-length
771         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
772 
773         _transfer(from, to, tokenId);
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId
783     ) public virtual override {
784         safeTransferFrom(from, to, tokenId, "");
785     }
786 
787     /**
788      * @dev See {IERC721-safeTransferFrom}.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes memory _data
795     ) public virtual override {
796         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
797         _safeTransfer(from, to, tokenId, _data);
798     }
799 
800     /**
801      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
802      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
803      *
804      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
805      *
806      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
807      * implement alternative mechanisms to perform token transfer, such as signature-based.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must exist and be owned by `from`.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _safeTransfer(
819         address from,
820         address to,
821         uint256 tokenId,
822         bytes memory _data
823     ) internal virtual {
824         _transfer(from, to, tokenId);
825         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
826     }
827 
828     /**
829      * @dev Returns whether `tokenId` exists.
830      *
831      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
832      *
833      * Tokens start existing when they are minted (`_mint`),
834      * and stop existing when they are burned (`_burn`).
835      */
836     function _exists(uint256 tokenId) internal view virtual returns (bool) {
837         return _owners[tokenId] != address(0);
838     }
839 
840     /**
841      * @dev Returns whether `spender` is allowed to manage `tokenId`.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must exist.
846      */
847     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
848         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
849         address owner = ERC721.ownerOf(tokenId);
850         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
851     }
852 
853     /**
854      * @dev Safely mints `tokenId` and transfers it to `to`.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must not exist.
859      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _safeMint(address to, uint256 tokenId) internal virtual {
864         _safeMint(to, tokenId, "");
865     }
866 
867     /**
868      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
869      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
870      */
871     function _safeMint(
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) internal virtual {
876         _mint(to, tokenId);
877         require(
878             _checkOnERC721Received(address(0), to, tokenId, _data),
879             "ERC721: transfer to non ERC721Receiver implementer"
880         );
881     }
882 
883     /**
884      * @dev Mints `tokenId` and transfers it to `to`.
885      *
886      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
887      *
888      * Requirements:
889      *
890      * - `tokenId` must not exist.
891      * - `to` cannot be the zero address.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _mint(address to, uint256 tokenId) internal virtual {
896         require(to != address(0), "ERC721: mint to the zero address");
897         require(!_exists(tokenId), "ERC721: token already minted");
898 
899         _beforeTokenTransfer(address(0), to, tokenId);
900 
901         _balances[to] += 1;
902         _owners[tokenId] = to;
903 
904         emit Transfer(address(0), to, tokenId);
905     }
906 
907     /**
908      * @dev Destroys `tokenId`.
909      * The approval is cleared when the token is burned.
910      *
911      * Requirements:
912      *
913      * - `tokenId` must exist.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _burn(uint256 tokenId) internal virtual {
918         address owner = ERC721.ownerOf(tokenId);
919 
920         _beforeTokenTransfer(owner, address(0), tokenId);
921 
922         // Clear approvals
923         _approve(address(0), tokenId);
924 
925         _balances[owner] -= 1;
926         delete _owners[tokenId];
927 
928         emit Transfer(owner, address(0), tokenId);
929     }
930 
931     /**
932      * @dev Transfers `tokenId` from `from` to `to`.
933      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
934      *
935      * Requirements:
936      *
937      * - `to` cannot be the zero address.
938      * - `tokenId` token must be owned by `from`.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _transfer(
943         address from,
944         address to,
945         uint256 tokenId
946     ) internal virtual {
947         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
948         require(to != address(0), "ERC721: transfer to the zero address");
949 
950         _beforeTokenTransfer(from, to, tokenId);
951 
952         // Clear approvals from the previous owner
953         _approve(address(0), tokenId);
954 
955         _balances[from] -= 1;
956         _balances[to] += 1;
957         _owners[tokenId] = to;
958 
959         emit Transfer(from, to, tokenId);
960     }
961 
962     /**
963      * @dev Approve `to` to operate on `tokenId`
964      *
965      * Emits a {Approval} event.
966      */
967     function _approve(address to, uint256 tokenId) internal virtual {
968         _tokenApprovals[tokenId] = to;
969         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
970     }
971 
972     /**
973      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
974      * The call is not executed if the target address is not a contract.
975      *
976      * @param from address representing the previous owner of the given token ID
977      * @param to target address that will receive the tokens
978      * @param tokenId uint256 ID of the token to be transferred
979      * @param _data bytes optional data to send along with the call
980      * @return bool whether the call correctly returned the expected magic value
981      */
982     function _checkOnERC721Received(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) private returns (bool) {
988         if (to.isContract()) {
989             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
990                 return retval == IERC721Receiver(to).onERC721Received.selector;
991             } catch (bytes memory reason) {
992                 if (reason.length == 0) {
993                     revert("ERC721: transfer to non ERC721Receiver implementer");
994                 } else {
995                     assembly {
996                         revert(add(32, reason), mload(reason))
997                     }
998                 }
999             }
1000         } else {
1001             return true;
1002         }
1003     }
1004 
1005     /**
1006      * @dev Hook that is called before any token transfer. This includes minting
1007      * and burning.
1008      *
1009      * Calling conditions:
1010      *
1011      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1012      * transferred to `to`.
1013      * - When `from` is zero, `tokenId` will be minted for `to`.
1014      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1015      * - `from` and `to` are never both zero.
1016      *
1017      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1018      */
1019     function _beforeTokenTransfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) internal virtual {}
1024 }
1025 
1026 
1027 
1028 
1029 
1030 
1031 
1032 /**
1033  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1034  * @dev See https://eips.ethereum.org/EIPS/eip-721
1035  */
1036 interface IERC721Enumerable is IERC721 {
1037     /**
1038      * @dev Returns the total amount of tokens stored by the contract.
1039      */
1040     function totalSupply() external view returns (uint256);
1041 
1042     /**
1043      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1044      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1045      */
1046     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1047 
1048     /**
1049      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1050      * Use along with {totalSupply} to enumerate all tokens.
1051      */
1052     function tokenByIndex(uint256 index) external view returns (uint256);
1053 }
1054 
1055 
1056 /**
1057  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1058  * enumerability of all the token ids in the contract as well as all token ids owned by each
1059  * account.
1060  */
1061 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1062     // Mapping from owner to list of owned token IDs
1063     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1064 
1065     // Mapping from token ID to index of the owner tokens list
1066     mapping(uint256 => uint256) private _ownedTokensIndex;
1067 
1068     // Array with all token ids, used for enumeration
1069     uint256[] private _allTokens;
1070 
1071     // Mapping from token id to position in the allTokens array
1072     mapping(uint256 => uint256) private _allTokensIndex;
1073 
1074     /**
1075      * @dev See {IERC165-supportsInterface}.
1076      */
1077     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1078         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1083      */
1084     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1085         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1086         return _ownedTokens[owner][index];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Enumerable-totalSupply}.
1091      */
1092     function totalSupply() public view virtual override returns (uint256) {
1093         return _allTokens.length;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Enumerable-tokenByIndex}.
1098      */
1099     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1100         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1101         return _allTokens[index];
1102     }
1103 
1104     /**
1105      * @dev Hook that is called before any token transfer. This includes minting
1106      * and burning.
1107      *
1108      * Calling conditions:
1109      *
1110      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1111      * transferred to `to`.
1112      * - When `from` is zero, `tokenId` will be minted for `to`.
1113      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1114      * - `from` cannot be the zero address.
1115      * - `to` cannot be the zero address.
1116      *
1117      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1118      */
1119     function _beforeTokenTransfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual override {
1124         super._beforeTokenTransfer(from, to, tokenId);
1125 
1126         if (from == address(0)) {
1127             _addTokenToAllTokensEnumeration(tokenId);
1128         } else if (from != to) {
1129             _removeTokenFromOwnerEnumeration(from, tokenId);
1130         }
1131         if (to == address(0)) {
1132             _removeTokenFromAllTokensEnumeration(tokenId);
1133         } else if (to != from) {
1134             _addTokenToOwnerEnumeration(to, tokenId);
1135         }
1136     }
1137 
1138     /**
1139      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1140      * @param to address representing the new owner of the given token ID
1141      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1142      */
1143     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1144         uint256 length = ERC721.balanceOf(to);
1145         _ownedTokens[to][length] = tokenId;
1146         _ownedTokensIndex[tokenId] = length;
1147     }
1148 
1149     /**
1150      * @dev Private function to add a token to this extension's token tracking data structures.
1151      * @param tokenId uint256 ID of the token to be added to the tokens list
1152      */
1153     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1154         _allTokensIndex[tokenId] = _allTokens.length;
1155         _allTokens.push(tokenId);
1156     }
1157 
1158     /**
1159      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1160      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1161      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1162      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1163      * @param from address representing the previous owner of the given token ID
1164      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1165      */
1166     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1167         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1168         // then delete the last slot (swap and pop).
1169 
1170         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1171         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1172 
1173         // When the token to delete is the last token, the swap operation is unnecessary
1174         if (tokenIndex != lastTokenIndex) {
1175             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1176 
1177             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1178             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1179         }
1180 
1181         // This also deletes the contents at the last position of the array
1182         delete _ownedTokensIndex[tokenId];
1183         delete _ownedTokens[from][lastTokenIndex];
1184     }
1185 
1186     /**
1187      * @dev Private function to remove a token from this extension's token tracking data structures.
1188      * This has O(1) time complexity, but alters the order of the _allTokens array.
1189      * @param tokenId uint256 ID of the token to be removed from the tokens list
1190      */
1191     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1192         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1193         // then delete the last slot (swap and pop).
1194 
1195         uint256 lastTokenIndex = _allTokens.length - 1;
1196         uint256 tokenIndex = _allTokensIndex[tokenId];
1197 
1198         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1199         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1200         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1201         uint256 lastTokenId = _allTokens[lastTokenIndex];
1202 
1203         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1204         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1205 
1206         // This also deletes the contents at the last position of the array
1207         delete _allTokensIndex[tokenId];
1208         _allTokens.pop();
1209     }
1210 }
1211 
1212 
1213 contract StageName is ERC721Enumerable, ReentrancyGuard {
1214 
1215     string[] private first = [
1216         "Bittah",
1217         "Tha",
1218         "Mad",
1219         "Master",
1220         "Dynamic",
1221         "E-ratic",
1222         "Wacko",
1223         "Fearless",
1224         "Misunderstood",
1225         "Quiet",
1226         "Pesty",
1227         "Gentlemen",
1228         "Profound",
1229         "Respected",
1230         "Amateur",
1231         "Shriekin'",
1232         "Lucky",
1233         "Phantom",
1234         "Smilin'",
1235         "Thunderous",
1236         "Tuff",
1237         "Scratchin'",
1238         "Drunken",
1239         "X-cessive",
1240         "X-pert",
1241         "Zexy",
1242         "Ruff",
1243         "Intellectual",
1244         "Unlucky",
1245         "Vizual",
1246         "Foolish",
1247         "Midnight",
1248         "Mighty",
1249         "Violent",
1250         "Vulgar",
1251         "Crazy",
1252         "Annoyin'",
1253         "Arrogant",
1254         "B-loved",
1255         "Sarkastik",
1256         "Insane",
1257         "Irate",
1258         "Wicked",
1259         "Lazy-assed",
1260         "Amazing"
1261     ];
1262     
1263     string[] private last = [
1264         "Madman",
1265         "Genius",
1266         "Hunter",
1267         "Killah",
1268         "Professional",
1269         "Artist",
1270         "Dreamer",
1271         "Observer",
1272         "Bastard",
1273         "Wizard",
1274         "Swami",
1275         "Wanderer",
1276         "Assassin",
1277         "Bandit",
1278         "Leader",
1279         "Ambassador",
1280         "Warrior",
1281         "Menace",
1282         "Worlock",
1283         "Conqueror",
1284         "Lover",
1285         "Magician",
1286         "Desperado",
1287         "Specialist",
1288         "Mercenary",
1289         "Ninja",
1290         "Contender",
1291         "Mastermind",
1292         "Demon",
1293         "Watcher",
1294         "Destroyer",
1295         "Beggar",
1296         "Commander",
1297         "Dominator",
1298         "Overlord",
1299         "Samurai",
1300         "Knight",
1301         "Pupil",
1302         "Prophet",
1303         "Criminal"
1304     ];
1305     
1306     string[] private color = [
1307         "White",
1308         "White",
1309         "White",
1310         "White",
1311         "White",
1312         "White",
1313         "White",
1314         "White",
1315         "White",
1316         "Yellow"
1317     ];
1318     
1319     function random(string memory input) internal pure returns (uint256) {
1320         return uint256(keccak256(abi.encodePacked(input)));
1321     }
1322     
1323     function getFirst(uint256 tokenId) public view returns (string memory) {
1324         return pluck(tokenId, "FIRST", first);
1325     }
1326     
1327     function getLast(uint256 tokenId) public view returns (string memory) {
1328         return pluck(tokenId, "LAST", last);
1329     }
1330     
1331     function getColor(uint256 tokenId) public view returns (string memory) {
1332         return pluck(tokenId, "COLOR", color);
1333     }
1334     
1335     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
1336         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1337         string memory output = sourceArray[rand % sourceArray.length];
1338         return output;
1339     }
1340 
1341     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1342         string[7] memory parts;
1343         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: ';
1344         
1345         parts[1] = getColor(tokenId);
1346         
1347         parts[2] = '; font-family: serif; font-size: 24px; }</style><rect width="100%" height="100%" fill="black" /><text x="20" y="20" class="base">';
1348 
1349         parts[3] = getFirst(tokenId);
1350 
1351         parts[4] = ' ';
1352 
1353         parts[5] = getLast(tokenId);
1354 
1355         parts[6] = '</text></svg>';
1356 
1357         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
1358         
1359         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Stage Name #', toString(tokenId), '", "description": "Stage Names are random onchain names inspired by the Wu-Tang Clan name generator. Feel free to use Stage Names in any way you want.", "attributes": [{"trait_type": "Color","value": "', getColor(tokenId), '"}, {"trait_type": "Adjective","value": "', getFirst(tokenId), '"}, {"trait_type": "Noun","value": "', getLast(tokenId), '"}], "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1360         output = string(abi.encodePacked('data:application/json;base64,', json));
1361 
1362         return output;
1363     }
1364 
1365     function claim(uint256 tokenId) public nonReentrant {
1366         require(tokenId > 0 && tokenId < 421, "Token ID invalid");
1367         _safeMint(_msgSender(), tokenId);
1368     }
1369     
1370     function toString(uint256 value) internal pure returns (string memory) {
1371     // Inspired by OraclizeAPI's implementation - MIT license
1372     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1373 
1374         if (value == 0) {
1375             return "0";
1376         }
1377         uint256 temp = value;
1378         uint256 digits;
1379         while (temp != 0) {
1380             digits++;
1381             temp /= 10;
1382         }
1383         bytes memory buffer = new bytes(digits);
1384         while (value != 0) {
1385             digits -= 1;
1386             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1387             value /= 10;
1388         }
1389         return string(buffer);
1390     }
1391     
1392     constructor() ERC721("Stage Names (For Rappers)", "NAMES") {}
1393 }
1394 
1395 /// [MIT License]
1396 /// @title Base64
1397 /// @notice Provides a function for encoding some bytes in base64
1398 /// @author Brecht Devos <brecht@loopring.org>
1399 library Base64 {
1400     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1401 
1402     /// @notice Encodes some bytes to the base64 representation
1403     function encode(bytes memory data) internal pure returns (string memory) {
1404         uint256 len = data.length;
1405         if (len == 0) return "";
1406 
1407         // multiply by 4/3 rounded up
1408         uint256 encodedLen = 4 * ((len + 2) / 3);
1409 
1410         // Add some extra buffer at the end
1411         bytes memory result = new bytes(encodedLen + 32);
1412 
1413         bytes memory table = TABLE;
1414 
1415         assembly {
1416             let tablePtr := add(table, 1)
1417             let resultPtr := add(result, 32)
1418 
1419             for {
1420                 let i := 0
1421             } lt(i, len) {
1422 
1423             } {
1424                 i := add(i, 3)
1425                 let input := and(mload(add(data, i)), 0xffffff)
1426 
1427                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1428                 out := shl(8, out)
1429                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1430                 out := shl(8, out)
1431                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1432                 out := shl(8, out)
1433                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1434                 out := shl(224, out)
1435 
1436                 mstore(resultPtr, out)
1437 
1438                 resultPtr := add(resultPtr, 4)
1439             }
1440 
1441             switch mod(len, 3)
1442             case 1 {
1443                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1444             }
1445             case 2 {
1446                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1447             }
1448 
1449             mstore(result, encodedLen)
1450         }
1451 
1452         return string(result);
1453     }
1454 }