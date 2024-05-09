1 // SPDX-License-Identifier: MIT
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
26 
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 
165 /**
166  * @dev String operations.
167  */
168 library Strings {
169     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
173      */
174     function toString(uint256 value) internal pure returns (string memory) {
175         // Inspired by OraclizeAPI's implementation - MIT licence
176         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
177 
178         if (value == 0) {
179             return "0";
180         }
181         uint256 temp = value;
182         uint256 digits;
183         while (temp != 0) {
184             digits++;
185             temp /= 10;
186         }
187         bytes memory buffer = new bytes(digits);
188         while (value != 0) {
189             digits -= 1;
190             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
191             value /= 10;
192         }
193         return string(buffer);
194     }
195 
196     /**
197      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
198      */
199     function toHexString(uint256 value) internal pure returns (string memory) {
200         if (value == 0) {
201             return "0x00";
202         }
203         uint256 temp = value;
204         uint256 length = 0;
205         while (temp != 0) {
206             length++;
207             temp >>= 8;
208         }
209         return toHexString(value, length);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
214      */
215     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
216         bytes memory buffer = new bytes(2 * length + 2);
217         buffer[0] = "0";
218         buffer[1] = "x";
219         for (uint256 i = 2 * length + 1; i > 1; --i) {
220             buffer[i] = _HEX_SYMBOLS[value & 0xf];
221             value >>= 4;
222         }
223         require(value == 0, "Strings: hex length insufficient");
224         return string(buffer);
225     }
226 }
227 
228 
229 
230 
231 /*
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 abstract contract Context {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes calldata) {
247         return msg.data;
248     }
249 }
250 
251 
252 
253 
254 
255 
256 
257 
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor() {
280         _setOwner(_msgSender());
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions anymore. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _setOwner(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         _setOwner(newOwner);
316     }
317 
318     function _setOwner(address newOwner) private {
319         address oldOwner = _owner;
320         _owner = newOwner;
321         emit OwnershipTransferred(oldOwner, newOwner);
322     }
323 }
324 
325 
326 
327 
328 
329 /**
330  * @dev Contract module that helps prevent reentrant calls to a function.
331  *
332  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
333  * available, which can be applied to functions to make sure there are no nested
334  * (reentrant) calls to them.
335  *
336  * Note that because there is a single `nonReentrant` guard, functions marked as
337  * `nonReentrant` may not call one another. This can be worked around by making
338  * those functions `private`, and then adding `external` `nonReentrant` entry
339  * points to them.
340  *
341  * TIP: If you would like to learn more about reentrancy and alternative ways
342  * to protect against it, check out our blog post
343  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
344  */
345 abstract contract ReentrancyGuard {
346     // Booleans are more expensive than uint256 or any type that takes up a full
347     // word because each write operation emits an extra SLOAD to first read the
348     // slot's contents, replace the bits taken up by the boolean, and then write
349     // back. This is the compiler's defense against contract upgrades and
350     // pointer aliasing, and it cannot be disabled.
351 
352     // The values being non-zero value makes deployment a bit more expensive,
353     // but in exchange the refund on every call to nonReentrant will be lower in
354     // amount. Since refunds are capped to a percentage of the total
355     // transaction's gas, it is best to keep them low in cases like this one, to
356     // increase the likelihood of the full refund coming into effect.
357     uint256 private constant _NOT_ENTERED = 1;
358     uint256 private constant _ENTERED = 2;
359 
360     uint256 private _status;
361 
362     constructor() {
363         _status = _NOT_ENTERED;
364     }
365 
366     /**
367      * @dev Prevents a contract from calling itself, directly or indirectly.
368      * Calling a `nonReentrant` function from another `nonReentrant`
369      * function is not supported. It is possible to prevent this from happening
370      * by making the `nonReentrant` function external, and make it call a
371      * `private` function that does the actual work.
372      */
373     modifier nonReentrant() {
374         // On the first call to nonReentrant, _notEntered will be true
375         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
376 
377         // Any calls to nonReentrant after this point will fail
378         _status = _ENTERED;
379 
380         _;
381 
382         // By storing the original value once again, a refund is triggered (see
383         // https://eips.ethereum.org/EIPS/eip-2200)
384         _status = _NOT_ENTERED;
385     }
386 }
387 
388 
389 /**
390  * @title ERC721 token receiver interface
391  * @dev Interface for any contract that wants to support safeTransfers
392  * from ERC721 asset contracts.
393  */
394 interface IERC721Receiver {
395     /**
396      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
397      * by `operator` from `from`, this function is called.
398      *
399      * It must return its Solidity selector to confirm the token transfer.
400      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
401      *
402      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
403      */
404     function onERC721Received(
405         address operator,
406         address from,
407         uint256 tokenId,
408         bytes calldata data
409     ) external returns (bytes4);
410 }
411 
412 
413 /**
414  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
415  * @dev See https://eips.ethereum.org/EIPS/eip-721
416  */
417 interface IERC721Metadata is IERC721 {
418     /**
419      * @dev Returns the token collection name.
420      */
421     function name() external view returns (string memory);
422 
423     /**
424      * @dev Returns the token collection symbol.
425      */
426     function symbol() external view returns (string memory);
427 
428     /**
429      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
430      */
431     function tokenURI(uint256 tokenId) external view returns (string memory);
432 }
433 
434 
435 
436 
437 
438 /**
439  * @dev Collection of functions related to the address type
440  */
441 library Address {
442     /**
443      * @dev Returns true if `account` is a contract.
444      *
445      * [IMPORTANT]
446      * ====
447      * It is unsafe to assume that an address for which this function returns
448      * false is an externally-owned account (EOA) and not a contract.
449      *
450      * Among others, `isContract` will return false for the following
451      * types of addresses:
452      *
453      *  - an externally-owned account
454      *  - a contract in construction
455      *  - an address where a contract will be created
456      *  - an address where a contract lived, but was destroyed
457      * ====
458      */
459     function isContract(address account) internal view returns (bool) {
460         // This method relies on extcodesize, which returns 0 for contracts in
461         // construction, since the code is only stored at the end of the
462         // constructor execution.
463 
464         uint256 size;
465         assembly {
466             size := extcodesize(account)
467         }
468         return size > 0;
469     }
470 
471     /**
472      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
473      * `recipient`, forwarding all available gas and reverting on errors.
474      *
475      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
476      * of certain opcodes, possibly making contracts go over the 2300 gas limit
477      * imposed by `transfer`, making them unable to receive funds via
478      * `transfer`. {sendValue} removes this limitation.
479      *
480      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
481      *
482      * IMPORTANT: because control is transferred to `recipient`, care must be
483      * taken to not create reentrancy vulnerabilities. Consider using
484      * {ReentrancyGuard} or the
485      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
486      */
487     function sendValue(address payable recipient, uint256 amount) internal {
488         require(address(this).balance >= amount, "Address: insufficient balance");
489 
490         (bool success, ) = recipient.call{value: amount}("");
491         require(success, "Address: unable to send value, recipient may have reverted");
492     }
493 
494     /**
495      * @dev Performs a Solidity function call using a low level `call`. A
496      * plain `call` is an unsafe replacement for a function call: use this
497      * function instead.
498      *
499      * If `target` reverts with a revert reason, it is bubbled up by this
500      * function (like regular Solidity function calls).
501      *
502      * Returns the raw returned data. To convert to the expected return value,
503      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
504      *
505      * Requirements:
506      *
507      * - `target` must be a contract.
508      * - calling `target` with `data` must not revert.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
513         return functionCall(target, data, "Address: low-level call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
518      * `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, 0, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but also transferring `value` wei to `target`.
533      *
534      * Requirements:
535      *
536      * - the calling contract must have an ETH balance of at least `value`.
537      * - the called Solidity function must be `payable`.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
551      * with `errorMessage` as a fallback revert reason when `target` reverts.
552      *
553      * _Available since v3.1._
554      */
555     function functionCallWithValue(
556         address target,
557         bytes memory data,
558         uint256 value,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(address(this).balance >= value, "Address: insufficient balance for call");
562         require(isContract(target), "Address: call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.call{value: value}(data);
565         return _verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
570      * but performing a static call.
571      *
572      * _Available since v3.3._
573      */
574     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
575         return functionStaticCall(target, data, "Address: low-level static call failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
580      * but performing a static call.
581      *
582      * _Available since v3.3._
583      */
584     function functionStaticCall(
585         address target,
586         bytes memory data,
587         string memory errorMessage
588     ) internal view returns (bytes memory) {
589         require(isContract(target), "Address: static call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.staticcall(data);
592         return _verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a delegate call.
598      *
599      * _Available since v3.4._
600      */
601     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
602         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal returns (bytes memory) {
616         require(isContract(target), "Address: delegate call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.delegatecall(data);
619         return _verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     function _verifyCallResult(
623         bool success,
624         bytes memory returndata,
625         string memory errorMessage
626     ) private pure returns (bytes memory) {
627         if (success) {
628             return returndata;
629         } else {
630             // Look for revert reason and bubble it up if present
631             if (returndata.length > 0) {
632                 // The easiest way to bubble the revert reason is using memory via assembly
633 
634                 assembly {
635                     let returndata_size := mload(returndata)
636                     revert(add(32, returndata), returndata_size)
637                 }
638             } else {
639                 revert(errorMessage);
640             }
641         }
642     }
643 }
644 
645 
646 /**
647  * @dev Implementation of the {IERC165} interface.
648  *
649  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
650  * for the additional interface id that will be supported. For example:
651  *
652  * ```solidity
653  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
654  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
655  * }
656  * ```
657  *
658  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
659  */
660 abstract contract ERC165 is IERC165 {
661     /**
662      * @dev See {IERC165-supportsInterface}.
663      */
664     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
665         return interfaceId == type(IERC165).interfaceId;
666     }
667 }
668 
669 
670 /**
671  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
672  * the Metadata extension, but not including the Enumerable extension, which is available separately as
673  * {ERC721Enumerable}.
674  */
675 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
676     using Address for address;
677     using Strings for uint256;
678 
679     // Token name
680     string private _name;
681 
682     // Token symbol
683     string private _symbol;
684 
685     // Mapping from token ID to owner address
686     mapping(uint256 => address) private _owners;
687 
688     // Mapping owner address to token count
689     mapping(address => uint256) private _balances;
690 
691     // Mapping from token ID to approved address
692     mapping(uint256 => address) private _tokenApprovals;
693 
694     // Mapping from owner to operator approvals
695     mapping(address => mapping(address => bool)) private _operatorApprovals;
696 
697     /**
698      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
699      */
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703     }
704 
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
709         return
710             interfaceId == type(IERC721).interfaceId ||
711             interfaceId == type(IERC721Metadata).interfaceId ||
712             super.supportsInterface(interfaceId);
713     }
714 
715     /**
716      * @dev See {IERC721-balanceOf}.
717      */
718     function balanceOf(address owner) public view virtual override returns (uint256) {
719         require(owner != address(0), "ERC721: balance query for the zero address");
720         return _balances[owner];
721     }
722 
723     /**
724      * @dev See {IERC721-ownerOf}.
725      */
726     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
727         address owner = _owners[tokenId];
728         require(owner != address(0), "ERC721: owner query for nonexistent token");
729         return owner;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-name}.
734      */
735     function name() public view virtual override returns (string memory) {
736         return _name;
737     }
738 
739     /**
740      * @dev See {IERC721Metadata-symbol}.
741      */
742     function symbol() public view virtual override returns (string memory) {
743         return _symbol;
744     }
745 
746     /**
747      * @dev See {IERC721Metadata-tokenURI}.
748      */
749     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
750         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
751 
752         string memory baseURI = _baseURI();
753         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
754     }
755 
756     /**
757      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
758      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
759      * by default, can be overriden in child contracts.
760      */
761     function _baseURI() internal view virtual returns (string memory) {
762         return "";
763     }
764 
765     /**
766      * @dev See {IERC721-approve}.
767      */
768     function approve(address to, uint256 tokenId) public virtual override {
769         address owner = ERC721.ownerOf(tokenId);
770         require(to != owner, "ERC721: approval to current owner");
771 
772         require(
773             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
774             "ERC721: approve caller is not owner nor approved for all"
775         );
776 
777         _approve(to, tokenId);
778     }
779 
780     /**
781      * @dev See {IERC721-getApproved}.
782      */
783     function getApproved(uint256 tokenId) public view virtual override returns (address) {
784         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
785 
786         return _tokenApprovals[tokenId];
787     }
788 
789     /**
790      * @dev See {IERC721-setApprovalForAll}.
791      */
792     function setApprovalForAll(address operator, bool approved) public virtual override {
793         require(operator != _msgSender(), "ERC721: approve to caller");
794 
795         _operatorApprovals[_msgSender()][operator] = approved;
796         emit ApprovalForAll(_msgSender(), operator, approved);
797     }
798 
799     /**
800      * @dev See {IERC721-isApprovedForAll}.
801      */
802     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
803         return _operatorApprovals[owner][operator];
804     }
805 
806     /**
807      * @dev See {IERC721-transferFrom}.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) public virtual override {
814         //solhint-disable-next-line max-line-length
815         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
816 
817         _transfer(from, to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-safeTransferFrom}.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) public virtual override {
828         safeTransferFrom(from, to, tokenId, "");
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) public virtual override {
840         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
841         _safeTransfer(from, to, tokenId, _data);
842     }
843 
844     /**
845      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
846      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
847      *
848      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
849      *
850      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
851      * implement alternative mechanisms to perform token transfer, such as signature-based.
852      *
853      * Requirements:
854      *
855      * - `from` cannot be the zero address.
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must exist and be owned by `from`.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _safeTransfer(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) internal virtual {
868         _transfer(from, to, tokenId);
869         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
870     }
871 
872     /**
873      * @dev Returns whether `tokenId` exists.
874      *
875      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
876      *
877      * Tokens start existing when they are minted (`_mint`),
878      * and stop existing when they are burned (`_burn`).
879      */
880     function _exists(uint256 tokenId) internal view virtual returns (bool) {
881         return _owners[tokenId] != address(0);
882     }
883 
884     /**
885      * @dev Returns whether `spender` is allowed to manage `tokenId`.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
892         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
893         address owner = ERC721.ownerOf(tokenId);
894         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
895     }
896 
897     /**
898      * @dev Safely mints `tokenId` and transfers it to `to`.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeMint(address to, uint256 tokenId) internal virtual {
908         _safeMint(to, tokenId, "");
909     }
910 
911     /**
912      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
913      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
914      */
915     function _safeMint(
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) internal virtual {
920         _mint(to, tokenId);
921         require(
922             _checkOnERC721Received(address(0), to, tokenId, _data),
923             "ERC721: transfer to non ERC721Receiver implementer"
924         );
925     }
926 
927     /**
928      * @dev Mints `tokenId` and transfers it to `to`.
929      *
930      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
931      *
932      * Requirements:
933      *
934      * - `tokenId` must not exist.
935      * - `to` cannot be the zero address.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _mint(address to, uint256 tokenId) internal virtual {
940         require(to != address(0), "ERC721: mint to the zero address");
941         require(!_exists(tokenId), "ERC721: token already minted");
942 
943         _beforeTokenTransfer(address(0), to, tokenId);
944 
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(address(0), to, tokenId);
949     }
950 
951     /**
952      * @dev Destroys `tokenId`.
953      * The approval is cleared when the token is burned.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _burn(uint256 tokenId) internal virtual {
962         address owner = ERC721.ownerOf(tokenId);
963 
964         _beforeTokenTransfer(owner, address(0), tokenId);
965 
966         // Clear approvals
967         _approve(address(0), tokenId);
968 
969         _balances[owner] -= 1;
970         delete _owners[tokenId];
971 
972         emit Transfer(owner, address(0), tokenId);
973     }
974 
975     /**
976      * @dev Transfers `tokenId` from `from` to `to`.
977      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _transfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) internal virtual {
991         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
992         require(to != address(0), "ERC721: transfer to the zero address");
993 
994         _beforeTokenTransfer(from, to, tokenId);
995 
996         // Clear approvals from the previous owner
997         _approve(address(0), tokenId);
998 
999         _balances[from] -= 1;
1000         _balances[to] += 1;
1001         _owners[tokenId] = to;
1002 
1003         emit Transfer(from, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev Approve `to` to operate on `tokenId`
1008      *
1009      * Emits a {Approval} event.
1010      */
1011     function _approve(address to, uint256 tokenId) internal virtual {
1012         _tokenApprovals[tokenId] = to;
1013         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1018      * The call is not executed if the target address is not a contract.
1019      *
1020      * @param from address representing the previous owner of the given token ID
1021      * @param to target address that will receive the tokens
1022      * @param tokenId uint256 ID of the token to be transferred
1023      * @param _data bytes optional data to send along with the call
1024      * @return bool whether the call correctly returned the expected magic value
1025      */
1026     function _checkOnERC721Received(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory _data
1031     ) private returns (bool) {
1032         if (to.isContract()) {
1033             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1034                 return retval == IERC721Receiver(to).onERC721Received.selector;
1035             } catch (bytes memory reason) {
1036                 if (reason.length == 0) {
1037                     revert("ERC721: transfer to non ERC721Receiver implementer");
1038                 } else {
1039                     assembly {
1040                         revert(add(32, reason), mload(reason))
1041                     }
1042                 }
1043             }
1044         } else {
1045             return true;
1046         }
1047     }
1048 
1049     /**
1050      * @dev Hook that is called before any token transfer. This includes minting
1051      * and burning.
1052      *
1053      * Calling conditions:
1054      *
1055      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1056      * transferred to `to`.
1057      * - When `from` is zero, `tokenId` will be minted for `to`.
1058      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1059      * - `from` and `to` are never both zero.
1060      *
1061      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1062      */
1063     function _beforeTokenTransfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual {}
1068 }
1069 
1070 
1071 /**
1072  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1073  * @dev See https://eips.ethereum.org/EIPS/eip-721
1074  */
1075 interface IERC721Enumerable is IERC721 {
1076     /**
1077      * @dev Returns the total amount of tokens stored by the contract.
1078      */
1079     function totalSupply() external view returns (uint256);
1080 
1081     /**
1082      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1083      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1084      */
1085     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1086 
1087     /**
1088      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1089      * Use along with {totalSupply} to enumerate all tokens.
1090      */
1091     function tokenByIndex(uint256 index) external view returns (uint256);
1092 }
1093 
1094 
1095 /**
1096  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1097  * enumerability of all the token ids in the contract as well as all token ids owned by each
1098  * account.
1099  */
1100 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1101     // Mapping from owner to list of owned token IDs
1102     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1103 
1104     // Mapping from token ID to index of the owner tokens list
1105     mapping(uint256 => uint256) private _ownedTokensIndex;
1106 
1107     // Array with all token ids, used for enumeration
1108     uint256[] private _allTokens;
1109 
1110     // Mapping from token id to position in the allTokens array
1111     mapping(uint256 => uint256) private _allTokensIndex;
1112 
1113     /**
1114      * @dev See {IERC165-supportsInterface}.
1115      */
1116     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1117         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1122      */
1123     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1124         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1125         return _ownedTokens[owner][index];
1126     }
1127 
1128     /**
1129      * @dev See {IERC721Enumerable-totalSupply}.
1130      */
1131     function totalSupply() public view virtual override returns (uint256) {
1132         return _allTokens.length;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Enumerable-tokenByIndex}.
1137      */
1138     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1139         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1140         return _allTokens[index];
1141     }
1142 
1143     /**
1144      * @dev Hook that is called before any token transfer. This includes minting
1145      * and burning.
1146      *
1147      * Calling conditions:
1148      *
1149      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1150      * transferred to `to`.
1151      * - When `from` is zero, `tokenId` will be minted for `to`.
1152      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1153      * - `from` cannot be the zero address.
1154      * - `to` cannot be the zero address.
1155      *
1156      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1157      */
1158     function _beforeTokenTransfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) internal virtual override {
1163         super._beforeTokenTransfer(from, to, tokenId);
1164 
1165         if (from == address(0)) {
1166             _addTokenToAllTokensEnumeration(tokenId);
1167         } else if (from != to) {
1168             _removeTokenFromOwnerEnumeration(from, tokenId);
1169         }
1170         if (to == address(0)) {
1171             _removeTokenFromAllTokensEnumeration(tokenId);
1172         } else if (to != from) {
1173             _addTokenToOwnerEnumeration(to, tokenId);
1174         }
1175     }
1176 
1177     /**
1178      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1179      * @param to address representing the new owner of the given token ID
1180      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1181      */
1182     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1183         uint256 length = ERC721.balanceOf(to);
1184         _ownedTokens[to][length] = tokenId;
1185         _ownedTokensIndex[tokenId] = length;
1186     }
1187 
1188     /**
1189      * @dev Private function to add a token to this extension's token tracking data structures.
1190      * @param tokenId uint256 ID of the token to be added to the tokens list
1191      */
1192     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1193         _allTokensIndex[tokenId] = _allTokens.length;
1194         _allTokens.push(tokenId);
1195     }
1196 
1197     /**
1198      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1199      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1200      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1201      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1202      * @param from address representing the previous owner of the given token ID
1203      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1204      */
1205     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1206         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1207         // then delete the last slot (swap and pop).
1208 
1209         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1210         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1211 
1212         // When the token to delete is the last token, the swap operation is unnecessary
1213         if (tokenIndex != lastTokenIndex) {
1214             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1215 
1216             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1217             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1218         }
1219 
1220         // This also deletes the contents at the last position of the array
1221         delete _ownedTokensIndex[tokenId];
1222         delete _ownedTokens[from][lastTokenIndex];
1223     }
1224 
1225     /**
1226      * @dev Private function to remove a token from this extension's token tracking data structures.
1227      * This has O(1) time complexity, but alters the order of the _allTokens array.
1228      * @param tokenId uint256 ID of the token to be removed from the tokens list
1229      */
1230     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1231         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1232         // then delete the last slot (swap and pop).
1233 
1234         uint256 lastTokenIndex = _allTokens.length - 1;
1235         uint256 tokenIndex = _allTokensIndex[tokenId];
1236 
1237         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1238         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1239         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1240         uint256 lastTokenId = _allTokens[lastTokenIndex];
1241 
1242         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1243         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1244 
1245         // This also deletes the contents at the last position of the array
1246         delete _allTokensIndex[tokenId];
1247         _allTokens.pop();
1248     }
1249 }
1250 
1251 
1252 contract Fuxi is ERC721Enumerable, ReentrancyGuard, Ownable {
1253     // NFT upper limit
1254     uint256 public maxLimit = 8888;
1255 
1256     mapping (uint256 => uint256) private numbers;
1257  
1258     // background
1259     struct Color{
1260         string backGroundColor;
1261         string strokeWidth;
1262         string strokeColor;
1263         string fillTextColor;
1264         string strokeTextColor;
1265         string taijiColor;
1266         string name;
1267     }
1268 
1269     string[] private fiveElements = [
1270         unicode"金",
1271         unicode"木",
1272         unicode"水",
1273         unicode"火",
1274         unicode"土"
1275     ];
1276 
1277     string[] private gossip = [
1278         unicode"巽",
1279         unicode"震",
1280         unicode"离",
1281         unicode"坤",
1282         unicode"艮",
1283         unicode"乾",
1284         unicode"兑",
1285         unicode"坎"
1286     ];
1287 
1288     string[] private tenDry = [
1289         unicode"甲",
1290         unicode"乙",
1291         unicode"丙",
1292         unicode"丁",
1293         unicode"戊",
1294         unicode"己",
1295         unicode"庚",
1296         unicode"辛",
1297         unicode"壬",
1298         unicode"癸"
1299     ];
1300 
1301     string[] private earthlyBranch = [
1302         unicode"寅",
1303         unicode"卯",
1304         unicode"巳",
1305         unicode"午",
1306         unicode"辰",
1307         unicode"戌",
1308         unicode"丑",
1309         unicode"未",
1310         unicode"申",
1311         unicode"酉",
1312         unicode"亥",
1313         unicode"子"
1314     ];
1315     
1316     function random(string memory input) internal pure returns (uint256) {
1317         return uint256(keccak256(abi.encodePacked(input)));
1318     }
1319     
1320     function getFiveElements(uint256 tokenId) public view returns (string memory) {
1321         return pluck(tokenId, "FIVEELEMENTS", fiveElements);
1322     }
1323     
1324     function getGossip(uint256 tokenId) public view returns (string memory) {
1325         return pluck(tokenId, "GOSSIP", gossip);
1326     }
1327     
1328     function getTenDry(uint256 tokenId) public view returns (string memory) {
1329         return pluck(tokenId, "TENDRY", tenDry);
1330     }
1331 
1332     function geTearthlyBranch(uint256 tokenId) public view returns (string memory) {
1333         return pluck(tokenId, "EARTHLYBRANCH", earthlyBranch);
1334     }
1335 
1336     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1337         uint256 number = numbers[tokenId];
1338         require( number != 0, "tokenId is invalid");
1339         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId+number))));
1340         string memory output = sourceArray[rand % sourceArray.length];
1341         return output;
1342     }
1343 
1344     function getBackGround(uint256 tokenId) public view returns (Color memory info){
1345         uint256 number = numbers[tokenId];
1346         require( number != 0, "tokenId is invalid");
1347         uint256 rand = random(string(abi.encodePacked('BACKGROUNDCOLOR', toString(tokenId+number))));
1348         uint256 greatness = rand % 100;   
1349 
1350         if (greatness <= 19) {
1351             info = Color({  
1352                 backGroundColor: unicode' fill="#bc9d6e"/> ',
1353                 strokeWidth: unicode' stroke-width="1.5" ',
1354                 strokeColor: unicode' stroke="#000000"/> ',
1355                 fillTextColor: unicode' fill="#000000" ',
1356                 strokeTextColor: unicode' stroke="#000000" ',
1357                 taijiColor: unicode' fill="#bc9d6e" ',
1358                 name: 'yellow'
1359             });
1360         }else if (greatness >89) {  
1361             info = Color({
1362                 backGroundColor:  unicode' fill="#ffffff"/> ',
1363                 strokeWidth: unicode' stroke-width="1.5" ',
1364                 strokeColor: unicode' stroke="#000000"/> ',
1365                 fillTextColor: unicode' fill="#000000" ',
1366                 strokeTextColor: unicode' stroke="#000000" ',
1367                 taijiColor: unicode' fill="#ffffff" ',
1368                 name: 'white'
1369             });       
1370         }else{
1371             info = Color({
1372                 backGroundColor: unicode' fill="#19130a"/> ',
1373                 strokeWidth: unicode' stroke-width="1.5" ',
1374                 strokeColor: unicode' stroke="#dfc082"/> ', 
1375                 fillTextColor: unicode' fill="#dfc082" ',
1376                 strokeTextColor: unicode' stroke="#dfc082" ',
1377                 taijiColor: unicode' fill="#dfc082" ',
1378                 name: 'black'
1379             });   
1380         }
1381         
1382         return info;
1383     }
1384 
1385     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1386         string[60] memory parts;
1387         Color memory info = getBackGround(tokenId);
1388         
1389         parts[0] = unicode'<svg viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg">';    
1390         parts[1] = unicode'<g><title>background</title><rect x="-1" y="-1" width="100%" height="100%" id="canvas_background"';
1391         parts[2] = info.backGroundColor;
1392         parts[3] = unicode'<g id="canvasGrid" display="none"><rect id="svg_1" width="100%" height="100%" x="0" y="0" stroke-width="0" fill="url(#gridpattern)"/></g></g>';
1393         parts[4] = unicode'<g><title>Layer 1</title><g id="svg_16" stroke="null"><g id="svg_8" fill="none" fill-rule="evenodd" transform="matrix(1.0289597692403862,0,0,1.0289597692403862,79.4289146949628,44.69235436252555)"><g id="svg_9" stroke="null"><g id="svg_10" stroke="null"><circle id="svg_14" ';
1394         parts[5] = info.strokeWidth;
1395         parts[6] = unicode'cx="93.56665" cy="76.789077" r="50.25" ';
1396         parts[7] = info.strokeColor;
1397         parts[8] = unicode'<path d="m93.56665,27.03298c27.47953,0 49.7561,22.27657 49.7561,49.7561c0,27.20474 -21.83326,49.31005 -48.93329,49.74943l-0.38557,0.0029c13.53805,-0.23331 24.44081,-11.28056 24.44081,-24.87428c0,-13.73977 -11.13828,-24.87805 -24.87805,-24.87805l-0.4114,-0.00333c-13.55002,-0.2197 -24.46665,-11.27235 -24.46665,-24.87472c0,-13.60237 10.91663,-24.65502 24.46665,-24.87471l0.4114,-0.00334zm0,12.43903c-6.86988,0 -12.43902,5.56914 -12.43902,12.43902c0,6.86988 5.56914,12.43903 12.43902,12.43903c6.86988,0 12.43902,-5.56915 12.43902,-12.43903c0,-6.86988 -5.56914,-12.43902 -12.43902,-12.43902z" id="svg_13" ';
1398         parts[9] = info.taijiColor;
1399         parts[10] = unicode'stroke="null"/><path d="m93.09825,27.0373c-13.52362,0.24972 -24.40965,11.29044 -24.40965,24.87373c0,13.60237 10.91663,24.65502 24.46665,24.87472l0.4114,0.00333c13.73977,0 24.87805,11.13828 24.87805,24.87805c0,13.60237 -10.91663,24.65502 -24.46665,24.87471l-0.4114,0.00334c-27.47953,0 -49.7561,-22.27657 -49.7561,-49.7561c0,-27.20474 21.83326,-49.31005 48.93329,-49.74943l0.35441,-0.00235zm0.4684,62.18704c-6.86988,0 -12.43902,5.56914 -12.43902,12.43902c0,6.86989 5.56914,12.43903 12.43902,12.43903c6.86988,0 12.43902,-5.56914 12.43902,-12.43903c0,-6.86988 -5.56914,-12.43902 -12.43902,-12.43902z" id="svg_12" fill="#000000" stroke="null"/><circle id="svg_11" ';
1400         parts[11] = info.taijiColor;
1401         parts[12] = unicode'cx="93.56665" cy="101.663361" r="12.439024" stroke="null"/><circle id="椭圆形" fill="#000000" cx="93.56665" cy="51.924022" r="12.439024" stroke="null"/></g></g></g></g>';
1402         parts[13] = unicode'<text letter-spacing="1px" style="cursor: move;" ';
1403         parts[14] = info.fillTextColor;
1404         parts[15] = unicode'stroke="#000" stroke-width="0" x="24" y="33" id="svg_17" font-size="14" font-family="宋体" text-anchor="start" xml:space="preserve">#</text><line fill="none" ';
1405         parts[16] = info.strokeTextColor;
1406         parts[17] = unicode'stroke-width="0.5" x1="87" y1="224" x2="87" y2="299" id="svg_20" stroke-linejoin="undefined" stroke-linecap="undefined" fill-opacity="0"/><line fill="none" ';
1407         parts[18] = info.strokeTextColor;
1408         parts[19] = unicode'stroke-width="0.5" x1="135" y1="224" x2="135" y2="299" id="svg_2" stroke-linejoin="undefined" stroke-linecap="undefined" fill-opacity="0"/><line fill="none" ';
1409         parts[20] = info.strokeTextColor;
1410         parts[21] = unicode'stroke-width="0.5" x1="183" y1="224" x2="183" y2="299" id="svg_3" stroke-linejoin="undefined" stroke-linecap="undefined" fill-opacity="0"/><line fill="none" ';
1411         parts[22] = info.strokeTextColor;
1412         parts[23] = unicode'stroke-width="0.5" x1="231" y1="224" x2="231" y2="299" id="svg_4" stroke-linejoin="undefined" stroke-linecap="undefined" fill-opacity="0"/><text font-weight="normal" letter-spacing="5px" writing-mode="tb-rl" xml:space="preserve" text-anchor="start" font-family="宋体" font-size="12" id="svg_6" y="226.500001" x="98" stroke-width="0" ';
1413         parts[24] = info.strokeTextColor;
1414         parts[25] = info.fillTextColor;
1415         parts[26] = unicode'>五行</text><text font-weight="normal" letter-spacing="5px" writing-mode="tb-rl" xml:space="preserve" text-anchor="start" font-family="宋体" font-size="12" id="svg_7" y="226.259257" x="146" stroke-width="0" ';
1416         parts[27] = info.strokeTextColor;
1417         parts[28] = info.fillTextColor;
1418         parts[29] = unicode'>八卦</text><text style="cursor: move;" letter-spacing="5px" writing-mode="tb-rl" xml:space="preserve" text-anchor="start" font-family="宋体" font-size="12" id="svg_15" y="227" x="192.875001" stroke-width="0" ';
1419         parts[30] = info.strokeTextColor;
1420         parts[31] = info.fillTextColor;
1421         parts[32] = unicode'>天干</text><text style="cursor: move;" letter-spacing="5px" writing-mode="tb-rl" xml:space="preserve" text-anchor="start" font-family="宋体" font-size="12" id="svg_19" y="227.249995" x="241.951429" stroke-width="0" ';
1422         parts[33] = info.strokeTextColor;
1423         parts[34] = info.fillTextColor;
1424         parts[35] = unicode'>地支</text><text ';
1425         parts[36] = info.fillTextColor;
1426         parts[37] = unicode' stroke="#000" stroke-width="0" x="33.812748" y="33" id="svg_21" font-size="14" font-family="宋体" text-anchor="start" xml:space="preserve">';
1427         parts[38] = toString(tokenId);
1428         parts[39] = unicode'</text><text font-weight="bold" letter-spacing="5px" writing-mode="tb-rl" xml:space="preserve" text-anchor="start" font-family="宋体" font-size="24" id="svg_22" y="271.062036" x="104.875" stroke-width="0" ';
1429         parts[40] = info.strokeTextColor;
1430         parts[41] = info.fillTextColor;
1431         parts[42] = unicode'>';
1432         parts[43] = getFiveElements(tokenId);
1433         parts[44] = unicode'</text><text font-weight="bold" letter-spacing="5px" writing-mode="tb-rl" xml:space="preserve" text-anchor="start" font-family="宋体" font-size="24" id="svg_23" y="271.062036" x="153.037991" stroke-width="0" ';
1434         parts[45] = info.strokeTextColor;
1435         parts[46] = info.fillTextColor;
1436         parts[47] = unicode'>';
1437         parts[48] = getGossip(tokenId);
1438         parts[49] = unicode'</text><text font-weight="bold" letter-spacing="5px" writing-mode="tb-rl" xml:space="preserve" text-anchor="start" font-family="宋体" font-size="24" id="svg_24" y="271.062036" x="201" stroke-width="0" ';
1439         parts[50] = info.strokeTextColor;
1440         parts[51] = info.fillTextColor;
1441         parts[52] = unicode'>';
1442         parts[53] = getTenDry(tokenId);
1443         parts[54] = unicode'</text><text font-weight="bold" letter-spacing="5px" writing-mode="tb-rl" xml:space="preserve" text-anchor="start" font-family="宋体" font-size="24" id="svg_25" y="271.062036" x="249.355301" stroke-width="0" ';
1444         parts[55] = info.strokeTextColor;
1445         parts[56] = info.fillTextColor;
1446         parts[57] = unicode'>';
1447         parts[58] = geTearthlyBranch(tokenId);
1448         parts[59] = '</text></g></svg>';
1449 
1450         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7],parts[8]));
1451         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14],parts[15],parts[16]));
1452         output = string(abi.encodePacked(output, parts[17], parts[18], parts[19], parts[20], parts[21],parts[22],parts[23],parts[24]));
1453         output = string(abi.encodePacked(output, parts[25], parts[26], parts[27], parts[28], parts[29],parts[30],parts[31],parts[32]));
1454         output = string(abi.encodePacked(output, parts[33], parts[34], parts[35], parts[36], parts[37], parts[38],parts[39],parts[40]));
1455         output = string(abi.encodePacked(output, parts[41], parts[42], parts[43], parts[44], parts[45], parts[46],parts[47],parts[48]));
1456         output = string(abi.encodePacked(output, parts[49], parts[50], parts[51], parts[52], parts[53], parts[54],parts[55],parts[56]));
1457         output = string(abi.encodePacked(output, parts[57], parts[58], parts[59]));
1458         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Fuxi #', toString(tokenId), '", "description": "Fuxi was the creator of gossip. Fuxi\'s First Era created 8,888 NFTs, ranging from #1 to #8888. You can randomly make a gossip NFT based on the address code, and then start divination, battle and other gameplay.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1459         output = string(abi.encodePacked('data:application/json;base64,', json));
1460         return output;
1461     }
1462 
1463     function claim() public nonReentrant {
1464         uint256 tokenId = totalSupply()+1;
1465         require(tokenId <= maxLimit, "The upper limit of token ID is 8888");
1466         numbers[tokenId] = block.timestamp;
1467         _safeMint(_msgSender(), tokenId);
1468     }
1469     
1470     function toString(uint256 value) internal pure returns (string memory) {
1471     // Inspired by OraclizeAPI's implementation - MIT license
1472     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1473 
1474         if (value == 0) {
1475             return "0";
1476         }
1477         uint256 temp = value;
1478         uint256 digits;
1479         while (temp != 0) {
1480             digits++;
1481             temp /= 10;
1482         }
1483         bytes memory buffer = new bytes(digits);
1484         while (value != 0) {
1485             digits -= 1;
1486             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1487             value /= 10;
1488         }
1489         return string(buffer);
1490     }
1491     
1492     constructor() ERC721("Fuxi", "FUXI") Ownable() {}
1493 }
1494 
1495 /// [MIT License]
1496 /// @title Base64
1497 /// @notice Provides a function for encoding some bytes in base64
1498 /// @author Brecht Devos <brecht@loopring.org>
1499 library Base64 {
1500     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1501 
1502     /// @notice Encodes some bytes to the base64 representation
1503     function encode(bytes memory data) internal pure returns (string memory) {
1504         uint256 len = data.length;
1505         if (len == 0) return "";
1506 
1507         // multiply by 4/3 rounded up
1508         uint256 encodedLen = 4 * ((len + 2) / 3);
1509 
1510         // Add some extra buffer at the end
1511         bytes memory result = new bytes(encodedLen + 32);
1512 
1513         bytes memory table = TABLE;
1514 
1515         assembly {
1516             let tablePtr := add(table, 1)
1517             let resultPtr := add(result, 32)
1518 
1519             for {
1520                 let i := 0
1521             } lt(i, len) {
1522 
1523             } {
1524                 i := add(i, 3)
1525                 let input := and(mload(add(data, i)), 0xffffff)
1526 
1527                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1528                 out := shl(8, out)
1529                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1530                 out := shl(8, out)
1531                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1532                 out := shl(8, out)
1533                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1534                 out := shl(224, out)
1535 
1536                 mstore(resultPtr, out)
1537 
1538                 resultPtr := add(resultPtr, 4)
1539             }
1540 
1541             switch mod(len, 3)
1542             case 1 {
1543                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1544             }
1545             case 2 {
1546                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1547             }
1548 
1549             mstore(result, encodedLen)
1550         }
1551 
1552         return string(result);
1553     }
1554 }