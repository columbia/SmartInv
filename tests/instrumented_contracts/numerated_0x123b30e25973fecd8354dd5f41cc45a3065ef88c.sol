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
26 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721.sol
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(
38         address indexed from,
39         address indexed to,
40         uint256 indexed tokenId
41     );
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(
47         address indexed owner,
48         address indexed approved,
49         uint256 indexed tokenId
50     );
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(
56         address indexed owner,
57         address indexed operator,
58         bool approved
59     );
60 
61     /**
62      * @dev Returns the number of tokens in ``owner``'s account.
63      */
64     function balanceOf(address owner) external view returns (uint256 balance);
65 
66     /**
67      * @dev Returns the owner of the `tokenId` token.
68      *
69      * Requirements:
70      *
71      * - `tokenId` must exist.
72      */
73     function ownerOf(uint256 tokenId) external view returns (address owner);
74 
75     /**
76      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
77      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
78      *
79      * Requirements:
80      *
81      * - `from` cannot be the zero address.
82      * - `to` cannot be the zero address.
83      * - `tokenId` token must exist and be owned by `from`.
84      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
85      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
86      *
87      * Emits a {Transfer} event.
88      */
89     function safeTransferFrom(
90         address from,
91         address to,
92         uint256 tokenId
93     ) external;
94 
95     /**
96      * @dev Transfers `tokenId` token from `from` to `to`.
97      *
98      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must be owned by `from`.
105      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     /**
116      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
117      * The approval is cleared when the token is transferred.
118      *
119      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
120      *
121      * Requirements:
122      *
123      * - The caller must own the token or be an approved operator.
124      * - `tokenId` must exist.
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Returns the account approved for `tokenId` token.
132      *
133      * Requirements:
134      *
135      * - `tokenId` must exist.
136      */
137     function getApproved(uint256 tokenId)
138         external
139         view
140         returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator)
160         external
161         view
162         returns (bool);
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external;
183 }
184 
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Contract module that helps prevent reentrant calls to a function.
190  *
191  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
192  * available, which can be applied to functions to make sure there are no nested
193  * (reentrant) calls to them.
194  *
195  * Note that because there is a single `nonReentrant` guard, functions marked as
196  * `nonReentrant` may not call one another. This can be worked around by making
197  * those functions `private`, and then adding `external` `nonReentrant` entry
198  * points to them.
199  *
200  * TIP: If you would like to learn more about reentrancy and alternative ways
201  * to protect against it, check out our blog post
202  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
203  */
204 abstract contract ReentrancyGuard {
205     // Booleans are more expensive than uint256 or any type that takes up a full
206     // word because each write operation emits an extra SLOAD to first read the
207     // slot's contents, replace the bits taken up by the boolean, and then write
208     // back. This is the compiler's defense against contract upgrades and
209     // pointer aliasing, and it cannot be disabled.
210 
211     // The values being non-zero value makes deployment a bit more expensive,
212     // but in exchange the refund on every call to nonReentrant will be lower in
213     // amount. Since refunds are capped to a percentage of the total
214     // transaction's gas, it is best to keep them low in cases like this one, to
215     // increase the likelihood of the full refund coming into effect.
216     uint256 private constant _NOT_ENTERED = 1;
217     uint256 private constant _ENTERED = 2;
218 
219     uint256 private _status;
220 
221     constructor() {
222         _status = _NOT_ENTERED;
223     }
224 
225     /**
226      * @dev Prevents a contract from calling itself, directly or indirectly.
227      * Calling a `nonReentrant` function from another `nonReentrant`
228      * function is not supported. It is possible to prevent this from happening
229      * by making the `nonReentrant` function external, and make it call a
230      * `private` function that does the actual work.
231      */
232     modifier nonReentrant() {
233         // On the first call to nonReentrant, _notEntered will be true
234         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
235 
236         // Any calls to nonReentrant after this point will fail
237         _status = _ENTERED;
238 
239         _;
240 
241         // By storing the original value once again, a refund is triggered (see
242         // https://eips.ethereum.org/EIPS/eip-2200)
243         _status = _NOT_ENTERED;
244     }
245 }
246 
247 
248 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Receiver.sol
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by `operator` from `from`, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
266      */
267     function onERC721Received(
268         address operator,
269         address from,
270         uint256 tokenId,
271         bytes calldata data
272     ) external returns (bytes4);
273 }
274 
275 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Metadata.sol
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @title ERC-721 Non-ALIENFRENSble Token Standard, optional metadata extension
281  * @dev See https://eips.ethereum.org/EIPS/eip-721
282  */
283 interface IERC721Metadata is IERC721 {
284     /**
285      * @dev Returns the token collection name.
286      */
287     function name() external view returns (string memory);
288 
289     /**
290      * @dev Returns the token collection symbol.
291      */
292     function symbol() external view returns (string memory);
293 
294     /**
295      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
296      */
297     function tokenURI(uint256 tokenId) external view returns (string memory);
298 }
299 
300 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         // solhint-disable-next-line no-inline-assembly
332         assembly {
333             size := extcodesize(account)
334         }
335         return size > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(
356             address(this).balance >= amount,
357             "Address: insufficient balance"
358         );
359 
360         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
361         (bool success, ) = recipient.call{value: amount}("");
362         require(
363             success,
364             "Address: unable to send value, recipient may have reverted"
365         );
366     }
367 
368     /**
369      * @dev Performs a Solidity function call using a low level `call`. A
370      * plain`call` is an unsafe replacement for a function call: use this
371      * function instead.
372      *
373      * If `target` reverts with a revert reason, it is bubbled up by this
374      * function (like regular Solidity function calls).
375      *
376      * Returns the raw returned data. To convert to the expected return value,
377      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378      *
379      * Requirements:
380      *
381      * - `target` must be a contract.
382      * - calling `target` with `data` must not revert.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data)
387         internal
388         returns (bytes memory)
389     {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return
424             functionCallWithValue(
425                 target,
426                 data,
427                 value,
428                 "Address: low-level call with value failed"
429             );
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
434      * with `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 value,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(
445             address(this).balance >= value,
446             "Address: insufficient balance for call"
447         );
448         require(isContract(target), "Address: call to non-contract");
449 
450         // solhint-disable-next-line avoid-low-level-calls
451         (bool success, bytes memory returndata) = target.call{value: value}(
452             data
453         );
454         return _verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data)
464         internal
465         view
466         returns (bytes memory)
467     {
468         return
469             functionStaticCall(
470                 target,
471                 data,
472                 "Address: low-level static call failed"
473             );
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a static call.
479      *
480      * _Available since v3.3._
481      */
482     function functionStaticCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal view returns (bytes memory) {
487         require(isContract(target), "Address: static call to non-contract");
488 
489         // solhint-disable-next-line avoid-low-level-calls
490         (bool success, bytes memory returndata) = target.staticcall(data);
491         return _verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
496      * but performing a delegate call.
497      *
498      * _Available since v3.4._
499      */
500     function functionDelegateCall(address target, bytes memory data)
501         internal
502         returns (bytes memory)
503     {
504         return
505             functionDelegateCall(
506                 target,
507                 data,
508                 "Address: low-level delegate call failed"
509             );
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525         // solhint-disable-next-line avoid-low-level-calls
526         (bool success, bytes memory returndata) = target.delegatecall(data);
527         return _verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     function _verifyCallResult(
531         bool success,
532         bytes memory returndata,
533         string memory errorMessage
534     ) private pure returns (bytes memory) {
535         if (success) {
536             return returndata;
537         } else {
538             // Look for revert reason and bubble it up if present
539             if (returndata.length > 0) {
540                 // The easiest way to bubble the revert reason is using memory via assembly
541 
542                 // solhint-disable-next-line no-inline-assembly
543                 assembly {
544                     let returndata_size := mload(returndata)
545                     revert(add(32, returndata), returndata_size)
546                 }
547             } else {
548                 revert(errorMessage);
549             }
550         }
551     }
552 }
553 
554 // File: node_modules\openzeppelin-solidity\contracts\utils\Context.sol
555 
556 pragma solidity ^0.8.0;
557 
558 /*
559  * @dev Provides information about the current execution context, including the
560  * sender of the transaction and its data. While these are generally available
561  * via msg.sender and msg.data, they should not be accessed in such a direct
562  * manner, since when dealing with meta-transactions the account sending and
563  * paying for execution may not be the actual sender (as far as an application
564  * is concerned).
565  *
566  * This contract is only required for intermediate, library-like contracts.
567  */
568 abstract contract Context {
569     function _msgSender() internal view virtual returns (address) {
570         return msg.sender;
571     }
572 
573     function _msgData() internal view virtual returns (bytes calldata) {
574         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
575         return msg.data;
576     }
577 }
578 
579 // File: node_modules\openzeppelin-solidity\contracts\utils\Strings.sol
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev String operations.
585  */
586 library Strings {
587     bytes16 private constant alphabet = "0123456789abcdef";
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
591      */
592     function toString(uint256 value) internal pure returns (string memory) {
593         // Inspired by OraclizeAPI's implementation - MIT licence
594         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
595 
596         if (value == 0) {
597             return "0";
598         }
599         uint256 temp = value;
600         uint256 digits;
601         while (temp != 0) {
602             digits++;
603             temp /= 10;
604         }
605         bytes memory buffer = new bytes(digits);
606         while (value != 0) {
607             digits -= 1;
608             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
609             value /= 10;
610         }
611         return string(buffer);
612     }
613 
614     /**
615      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
616      */
617     function toHexString(uint256 value) internal pure returns (string memory) {
618         if (value == 0) {
619             return "0x00";
620         }
621         uint256 temp = value;
622         uint256 length = 0;
623         while (temp != 0) {
624             length++;
625             temp >>= 8;
626         }
627         return toHexString(value, length);
628     }
629 
630     /**
631      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
632      */
633     function toHexString(uint256 value, uint256 length)
634         internal
635         pure
636         returns (string memory)
637     {
638         bytes memory buffer = new bytes(2 * length + 2);
639         buffer[0] = "0";
640         buffer[1] = "x";
641         for (uint256 i = 2 * length + 1; i > 1; --i) {
642             buffer[i] = alphabet[value & 0xf];
643             value >>= 4;
644         }
645         require(value == 0, "Strings: hex length insufficient");
646         return string(buffer);
647     }
648 }
649 
650 // File: node_modules\openzeppelin-solidity\contracts\utils\introspection\ERC165.sol
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Implementation of the {IERC165} interface.
656  *
657  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
658  * for the additional interface id that will be supported. For example:
659  *
660  * ```solidity
661  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
662  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
663  * }
664  * ```
665  *
666  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
667  */
668 abstract contract ERC165 is IERC165 {
669     /**
670      * @dev See {IERC165-supportsInterface}.
671      */
672     function supportsInterface(bytes4 interfaceId)
673         public
674         view
675         virtual
676         override
677         returns (bool)
678     {
679         return interfaceId == type(IERC165).interfaceId;
680     }
681 }
682 
683 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-ALIENFRENSble Token Standard, including
689  * the Metadata extension, but not including the Enumerable extension, which is available separately as
690  * {ERC721Enumerable}.
691  */
692 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
693     using Address for address;
694     using Strings for uint256;
695 
696     // Token name
697     string private _name;
698 
699     // Token symbol
700     string private _symbol;
701 
702     // Mapping from token ID to owner address
703     mapping(uint256 => address) private _owners;
704 
705     // Mapping owner address to token count
706     mapping(address => uint256) private _balances;
707 
708     // Mapping from token ID to approved address
709     mapping(uint256 => address) private _tokenApprovals;
710 
711     // Mapping from owner to operator approvals
712     mapping(address => mapping(address => bool)) private _operatorApprovals;
713 
714     /**
715      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
716      */
717     constructor(string memory name_, string memory symbol_) {
718         _name = name_;
719         _symbol = symbol_;
720     }
721 
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId)
726         public
727         view
728         virtual
729         override(ERC165, IERC165)
730         returns (bool)
731     {
732         return
733             interfaceId == type(IERC721).interfaceId ||
734             interfaceId == type(IERC721Metadata).interfaceId ||
735             super.supportsInterface(interfaceId);
736     }
737 
738     /**
739      * @dev See {IERC721-balanceOf}.
740      */
741     function balanceOf(address owner)
742         public
743         view
744         virtual
745         override
746         returns (uint256)
747     {
748         require(
749             owner != address(0),
750             "ERC721: balance query for the zero address"
751         );
752         return _balances[owner];
753     }
754 
755     /**
756      * @dev See {IERC721-ownerOf}.
757      */
758     function ownerOf(uint256 tokenId)
759         public
760         view
761         virtual
762         override
763         returns (address)
764     {
765         address owner = _owners[tokenId];
766         require(
767             owner != address(0),
768             "ERC721: owner query for nonexistent token"
769         );
770         return owner;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-name}.
775      */
776     function name() public view virtual override returns (string memory) {
777         return _name;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-symbol}.
782      */
783     function symbol() public view virtual override returns (string memory) {
784         return _symbol;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-tokenURI}.
789      */
790     function tokenURI(uint256 tokenId)
791         public
792         view
793         virtual
794         override
795         returns (string memory)
796     {
797         require(
798             _exists(tokenId),
799             "ERC721Metadata: URI query for nonexistent token"
800         );
801 
802         string memory baseURI = _baseURI();
803         return
804             bytes(baseURI).length > 0
805                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
806                 : "";
807     }
808 
809     /**
810      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
811      * in child contracts.
812      */
813     function _baseURI() internal view virtual returns (string memory) {
814         return "";
815     }
816 
817     /**
818      * @dev See {IERC721-approve}.
819      */
820     function approve(address to, uint256 tokenId) public virtual override {
821         address owner = ERC721.ownerOf(tokenId);
822         require(to != owner, "ERC721: approval to current owner");
823 
824         require(
825             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
826             "ERC721: approve caller is not owner nor approved for all"
827         );
828 
829         _approve(to, tokenId);
830     }
831 
832     /**
833      * @dev See {IERC721-getApproved}.
834      */
835     function getApproved(uint256 tokenId)
836         public
837         view
838         virtual
839         override
840         returns (address)
841     {
842         require(
843             _exists(tokenId),
844             "ERC721: approved query for nonexistent token"
845         );
846 
847         return _tokenApprovals[tokenId];
848     }
849 
850     /**
851      * @dev See {IERC721-setApprovalForAll}.
852      */
853     function setApprovalForAll(address operator, bool approved)
854         public
855         virtual
856         override
857     {
858         require(operator != _msgSender(), "ERC721: approve to caller");
859 
860         _operatorApprovals[_msgSender()][operator] = approved;
861         emit ApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     /**
865      * @dev See {IERC721-isApprovedForAll}.
866      */
867     function isApprovedForAll(address owner, address operator)
868         public
869         view
870         virtual
871         override
872         returns (bool)
873     {
874         return _operatorApprovals[owner][operator];
875     }
876 
877     /**
878      * @dev See {IERC721-transferFrom}.
879      */
880     function transferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         //solhint-disable-next-line max-line-length
886         require(
887             _isApprovedOrOwner(_msgSender(), tokenId),
888             "ERC721: transfer caller is not owner nor approved"
889         );
890 
891         _transfer(from, to, tokenId);
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         safeTransferFrom(from, to, tokenId, "");
903     }
904 
905     /**
906      * @dev See {IERC721-safeTransferFrom}.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) public virtual override {
914         require(
915             _isApprovedOrOwner(_msgSender(), tokenId),
916             "ERC721: transfer caller is not owner nor approved"
917         );
918         _safeTransfer(from, to, tokenId, _data);
919     }
920 
921     /**
922      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
923      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
924      *
925      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
926      *
927      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
928      * implement alternative mechanisms to perform token transfer, such as signature-based.
929      *
930      * Requirements:
931      *
932      * - `from` cannot be the zero address.
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must exist and be owned by `from`.
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeTransfer(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) internal virtual {
945         _transfer(from, to, tokenId);
946         require(
947             _checkOnERC721Received(from, to, tokenId, _data),
948             "ERC721: transfer to non ERC721Receiver implementer"
949         );
950     }
951 
952     /**
953      * @dev Returns whether `tokenId` exists.
954      *
955      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
956      *
957      * Tokens start existing when they are minted (`_mint`),
958      * and stop existing when they are burned (`_burn`).
959      */
960     function _exists(uint256 tokenId) internal view virtual returns (bool) {
961         return _owners[tokenId] != address(0);
962     }
963 
964     /**
965      * @dev Returns whether `spender` is allowed to manage `tokenId`.
966      *
967      * Requirements:
968      *
969      * - `tokenId` must exist.
970      */
971     function _isApprovedOrOwner(address spender, uint256 tokenId)
972         internal
973         view
974         virtual
975         returns (bool)
976     {
977         require(
978             _exists(tokenId),
979             "ERC721: operator query for nonexistent token"
980         );
981         address owner = ERC721.ownerOf(tokenId);
982         return (spender == owner ||
983             getApproved(tokenId) == spender ||
984             isApprovedForAll(owner, spender));
985     }
986 
987     /**
988      * @dev Safely mints `tokenId` and transfers it to `to`.
989      *
990      * Requirements:
991      *
992      * - `tokenId` must not exist.
993      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _safeMint(address to, uint256 tokenId) internal virtual {
998         _safeMint(to, tokenId, "");
999     }
1000 
1001     /**
1002      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1003      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1004      */
1005     function _safeMint(
1006         address to,
1007         uint256 tokenId,
1008         bytes memory _data
1009     ) internal virtual {
1010         _mint(to, tokenId);
1011         require(
1012             _checkOnERC721Received(address(0), to, tokenId, _data),
1013             "ERC721: transfer to non ERC721Receiver implementer"
1014         );
1015     }
1016 
1017     /**
1018      * @dev Mints `tokenId` and transfers it to `to`.
1019      *
1020      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must not exist.
1025      * - `to` cannot be the zero address.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _mint(address to, uint256 tokenId) internal virtual {
1030         require(to != address(0), "ERC721: mint to the zero address");
1031         require(!_exists(tokenId), "ERC721: token already minted");
1032 
1033         _beforeTokenTransfer(address(0), to, tokenId);
1034 
1035         _balances[to] += 1;
1036         _owners[tokenId] = to;
1037 
1038         emit Transfer(address(0), to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev Destroys `tokenId`.
1043      * The approval is cleared when the token is burned.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must exist.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _burn(uint256 tokenId) internal virtual {
1052         address owner = ERC721.ownerOf(tokenId);
1053 
1054         _beforeTokenTransfer(owner, address(0), tokenId);
1055 
1056         // Clear approvals
1057         _approve(address(0), tokenId);
1058 
1059         _balances[owner] -= 1;
1060         delete _owners[tokenId];
1061 
1062         emit Transfer(owner, address(0), tokenId);
1063     }
1064 
1065     /**
1066      * @dev Transfers `tokenId` from `from` to `to`.
1067      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `tokenId` token must be owned by `from`.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _transfer(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) internal virtual {
1081         require(
1082             ERC721.ownerOf(tokenId) == from,
1083             "ERC721: transfer of token that is not own"
1084         );
1085         require(to != address(0), "ERC721: transfer to the zero address");
1086 
1087         _beforeTokenTransfer(from, to, tokenId);
1088 
1089         // Clear approvals from the previous owner
1090         _approve(address(0), tokenId);
1091 
1092         _balances[from] -= 1;
1093         _balances[to] += 1;
1094         _owners[tokenId] = to;
1095 
1096         emit Transfer(from, to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev Approve `to` to operate on `tokenId`
1101      *
1102      * Emits a {Approval} event.
1103      */
1104     function _approve(address to, uint256 tokenId) internal virtual {
1105         _tokenApprovals[tokenId] = to;
1106         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1111      * The call is not executed if the target address is not a contract.
1112      *
1113      * @param from address representing the previous owner of the given token ID
1114      * @param to target address that will receive the tokens
1115      * @param tokenId uint256 ID of the token to be transferred
1116      * @param _data bytes optional data to send along with the call
1117      * @return bool whether the call correctly returned the expected magic value
1118      */
1119     function _checkOnERC721Received(
1120         address from,
1121         address to,
1122         uint256 tokenId,
1123         bytes memory _data
1124     ) private returns (bool) {
1125         if (to.isContract()) {
1126             try
1127                 IERC721Receiver(to).onERC721Received(
1128                     _msgSender(),
1129                     from,
1130                     tokenId,
1131                     _data
1132                 )
1133             returns (bytes4 retval) {
1134                 return retval == IERC721Receiver(to).onERC721Received.selector;
1135             } catch (bytes memory reason) {
1136                 if (reason.length == 0) {
1137                     revert(
1138                         "ERC721: transfer to non ERC721Receiver implementer"
1139                     );
1140                 } else {
1141                     // solhint-disable-next-line no-inline-assembly
1142                     assembly {
1143                         revert(add(32, reason), mload(reason))
1144                     }
1145                 }
1146             }
1147         } else {
1148             return true;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Hook that is called before any token transfer. This includes minting
1154      * and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` will be minted for `to`.
1161      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1162      * - `from` cannot be the zero address.
1163      * - `to` cannot be the zero address.
1164      *
1165      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1166      */
1167     function _beforeTokenTransfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) internal virtual {}
1172 }
1173 
1174 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Enumerable.sol
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 /**
1179  * @title ERC-721 Non-ALIENFRENSble Token Standard, optional enumeration extension
1180  * @dev See https://eips.ethereum.org/EIPS/eip-721
1181  */
1182 interface IERC721Enumerable is IERC721 {
1183     /**
1184      * @dev Returns the total amount of tokens stored by the contract.
1185      */
1186     function totalSupply() external view returns (uint256);
1187 
1188     /**
1189      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1190      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1191      */
1192     function tokenOfOwnerByIndex(address owner, uint256 index)
1193         external
1194         view
1195         returns (uint256 tokenId);
1196 
1197     /**
1198      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1199      * Use along with {totalSupply} to enumerate all tokens.
1200      */
1201     function tokenByIndex(uint256 index) external view returns (uint256);
1202 }
1203 
1204 // File: openzeppelin-solidity\contracts\token\ERC721\extensions\ERC721Enumerable.sol
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 /**
1209  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1210  * enumerability of all the token ids in the contract as well as all token ids owned by each
1211  * account.
1212  */
1213 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1214     // Mapping from owner to list of owned token IDs
1215     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1216 
1217     // Mapping from token ID to index of the owner tokens list
1218     mapping(uint256 => uint256) private _ownedTokensIndex;
1219 
1220     // Array with all token ids, used for enumeration
1221     uint256[] private _allTokens;
1222 
1223     // Mapping from token id to position in the allTokens array
1224     mapping(uint256 => uint256) private _allTokensIndex;
1225 
1226     /**
1227      * @dev See {IERC165-supportsInterface}.
1228      */
1229     function supportsInterface(bytes4 interfaceId)
1230         public
1231         view
1232         virtual
1233         override(IERC165, ERC721)
1234         returns (bool)
1235     {
1236         return
1237             interfaceId == type(IERC721Enumerable).interfaceId ||
1238             super.supportsInterface(interfaceId);
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1243      */
1244     function tokenOfOwnerByIndex(address owner, uint256 index)
1245         public
1246         view
1247         virtual
1248         override
1249         returns (uint256)
1250     {
1251         require(
1252             index < ERC721.balanceOf(owner),
1253             "ERC721Enumerable: owner index out of bounds"
1254         );
1255         return _ownedTokens[owner][index];
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Enumerable-totalSupply}.
1260      */
1261     function totalSupply() public view virtual override returns (uint256) {
1262         return _allTokens.length;
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Enumerable-tokenByIndex}.
1267      */
1268     function tokenByIndex(uint256 index)
1269         public
1270         view
1271         virtual
1272         override
1273         returns (uint256)
1274     {
1275         require(
1276             index < ERC721Enumerable.totalSupply(),
1277             "ERC721Enumerable: global index out of bounds"
1278         );
1279         return _allTokens[index];
1280     }
1281 
1282     /**
1283      * @dev Hook that is called before any token transfer. This includes minting
1284      * and burning.
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` will be minted for `to`.
1291      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1292      * - `from` cannot be the zero address.
1293      * - `to` cannot be the zero address.
1294      *
1295      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1296      */
1297     function _beforeTokenTransfer(
1298         address from,
1299         address to,
1300         uint256 tokenId
1301     ) internal virtual override {
1302         super._beforeTokenTransfer(from, to, tokenId);
1303 
1304         if (from == address(0)) {
1305             _addTokenToAllTokensEnumeration(tokenId);
1306         } else if (from != to) {
1307             _removeTokenFromOwnerEnumeration(from, tokenId);
1308         }
1309         if (to == address(0)) {
1310             _removeTokenFromAllTokensEnumeration(tokenId);
1311         } else if (to != from) {
1312             _addTokenToOwnerEnumeration(to, tokenId);
1313         }
1314     }
1315 
1316     /**
1317      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1318      * @param to address representing the new owner of the given token ID
1319      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1320      */
1321     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1322         uint256 length = ERC721.balanceOf(to);
1323         _ownedTokens[to][length] = tokenId;
1324         _ownedTokensIndex[tokenId] = length;
1325     }
1326 
1327     /**
1328      * @dev Private function to add a token to this extension's token tracking data structures.
1329      * @param tokenId uint256 ID of the token to be added to the tokens list
1330      */
1331     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1332         _allTokensIndex[tokenId] = _allTokens.length;
1333         _allTokens.push(tokenId);
1334     }
1335 
1336     /**
1337      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1338      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1339      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1340      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1341      * @param from address representing the previous owner of the given token ID
1342      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1343      */
1344     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1345         private
1346     {
1347         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1348         // then delete the last slot (swap and pop).
1349 
1350         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1351         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1352 
1353         // When the token to delete is the last token, the swap operation is unnecessary
1354         if (tokenIndex != lastTokenIndex) {
1355             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1356 
1357             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1358             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1359         }
1360 
1361         // This also deletes the contents at the last position of the array
1362         delete _ownedTokensIndex[tokenId];
1363         delete _ownedTokens[from][lastTokenIndex];
1364     }
1365 
1366     /**
1367      * @dev Private function to remove a token from this extension's token tracking data structures.
1368      * This has O(1) time complexity, but alters the order of the _allTokens array.
1369      * @param tokenId uint256 ID of the token to be removed from the tokens list
1370      */
1371     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1372         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1373         // then delete the last slot (swap and pop).
1374 
1375         uint256 lastTokenIndex = _allTokens.length - 1;
1376         uint256 tokenIndex = _allTokensIndex[tokenId];
1377 
1378         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1379         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1380         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1381         uint256 lastTokenId = _allTokens[lastTokenIndex];
1382 
1383         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1384         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1385 
1386         // This also deletes the contents at the last position of the array
1387         delete _allTokensIndex[tokenId];
1388         _allTokens.pop();
1389     }
1390 }
1391 
1392 // File: contracts\lib\Counters.sol
1393 
1394 pragma solidity ^0.8.0;
1395 
1396 /**
1397  * @title Counters
1398  * @author Matt Condon (@shrugs)
1399  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1400  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1401  *
1402  * Include with `using Counters for Counters.Counter;`
1403  */
1404 library Counters {
1405     struct Counter {
1406         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1407         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1408         // this feature: see https://github.com/ethereum/solidity/issues/4637
1409         uint256 _value; // default: 0
1410     }
1411 
1412     function current(Counter storage counter) internal view returns (uint256) {
1413         return counter._value;
1414     }
1415 
1416     function increment(Counter storage counter) internal {
1417         {
1418             counter._value += 1;
1419         }
1420     }
1421 
1422     function decrement(Counter storage counter) internal {
1423         uint256 value = counter._value;
1424         require(value > 0, "Counter: decrement overflow");
1425         {
1426             counter._value = value - 1;
1427         }
1428     }
1429 }
1430 
1431 // File: openzeppelin-solidity\contracts\access\Ownable.sol
1432 
1433 pragma solidity ^0.8.0;
1434 
1435 /**
1436  * @dev Contract module which provides a basic access control mechanism, where
1437  * there is an account (an owner) that can be granted exclusive access to
1438  * specific functions.
1439  *
1440  * By default, the owner account will be the one that deploys the contract. This
1441  * can later be changed with {transferOwnership}.
1442  *
1443  * This module is used through inheritance. It will make available the modifier
1444  * `onlyOwner`, which can be applied to your functions to restrict their use to
1445  * the owner.
1446  */
1447 abstract contract Ownable is Context {
1448     address private _owner;
1449 
1450     event OwnershipTransferred(
1451         address indexed previousOwner,
1452         address indexed newOwner
1453     );
1454 
1455     /**
1456      * @dev Initializes the contract setting the deployer as the initial owner.
1457      */
1458     constructor() {
1459         address msgSender = _msgSender();
1460         _owner = msgSender;
1461         emit OwnershipTransferred(address(0), msgSender);
1462     }
1463 
1464     /**
1465      * @dev Returns the address of the current owner.
1466      */
1467     function owner() public view virtual returns (address) {
1468         return _owner;
1469     }
1470 
1471     /**
1472      * @dev Throws if called by any account other than the owner.
1473      */
1474     modifier onlyOwner() {
1475         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1476         _;
1477     }
1478 
1479     /**
1480      * @dev Leaves the contract without owner. It will not be possible to call
1481      * `onlyOwner` functions anymore. Can only be called by the current owner.
1482      *
1483      * NOTE: Renouncing ownership will leave the contract without an owner,
1484      * thereby removing any functionality that is only available to the owner.
1485      */
1486     function renounceOwnership() public virtual onlyOwner {
1487         emit OwnershipTransferred(_owner, address(0));
1488         _owner = address(0);
1489     }
1490 
1491     /**
1492      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1493      * Can only be called by the current owner.
1494      */
1495     function transferOwnership(address newOwner) public virtual onlyOwner {
1496         require(
1497             newOwner != address(0),
1498             "Ownable: new owner is the zero address"
1499         );
1500         emit OwnershipTransferred(_owner, newOwner);
1501         _owner = newOwner;
1502     }
1503 }
1504 
1505 
1506 pragma solidity ^0.8.0;
1507 
1508 contract ALIENFRENS is ERC721Enumerable, Ownable, ReentrancyGuard {
1509     using Counters for Counters.Counter;
1510     using Strings for uint256;
1511 
1512     uint256 public constant ALIENFRENS_PUBLIC = 10000;
1513     uint256 public constant ALIENFRENS_MAX = ALIENFRENS_PUBLIC;
1514     uint256 public constant PURCHASE_LIMIT = 10;
1515     uint256 public constant PRICE = 20_000_000_000_000_000; // 0.02 ETH
1516     uint256 public allowListMaxMint = 10;
1517     string private _contractURI = "";
1518     string private _tokenBaseURI = "";
1519     bool private _isActive = false;
1520     bool public isAllowListActive = false;
1521     
1522     mapping(address => bool) private _allowList;
1523     mapping(address => uint256) private _allowListClaimed;
1524 
1525     Counters.Counter private _publicALIENFRENS;
1526 
1527     constructor() ERC721("ALIENFRENS", "ALIENFRENS") {
1528 
1529     }
1530 
1531     function setActive(bool isActive) external onlyOwner {
1532         _isActive = isActive;
1533     }
1534 
1535     function setContractURI(string memory URI) external onlyOwner {
1536         _contractURI = URI;
1537     }
1538 
1539     function setBaseURI(string memory URI) external onlyOwner {
1540         _tokenBaseURI = URI;
1541     }
1542 
1543     // owner minting
1544     function ownerMinting(address to, uint256 numberOfTokens)
1545         external
1546         payable
1547         onlyOwner
1548     {
1549         require(
1550             _publicALIENFRENS.current() < ALIENFRENS_PUBLIC,
1551             "Purchase would exceed ALIENFRENS_PUBLIC"
1552         );
1553 
1554         for (uint256 i = 0; i < numberOfTokens; i++) {
1555             uint256 tokenId = _publicALIENFRENS.current();
1556 
1557             if (_publicALIENFRENS.current() < ALIENFRENS_PUBLIC) {
1558                 _publicALIENFRENS.increment();
1559                 _safeMint(to, tokenId);
1560             }
1561         }
1562     }
1563 
1564      function setIsAllowListActive(bool _isAllowListActive) external onlyOwner {
1565         isAllowListActive = _isAllowListActive;
1566       }
1567     
1568       function setAllowListMaxMint(uint256 maxMint) external onlyOwner {
1569         allowListMaxMint = maxMint;
1570       }
1571       
1572       function addToAllowList(address[] calldata addresses) external onlyOwner {
1573         for (uint256 i = 0; i < addresses.length; i++) {
1574           require(addresses[i] != address(0), "Can't add the null address");
1575           
1576           _allowList[addresses[i]] = true;
1577           
1578           /**
1579           * @dev We don't want to reset _allowListClaimed count
1580           * if we try to add someone more than once.
1581           */
1582           _allowListClaimed[addresses[i]] > 0 ? _allowListClaimed[addresses[i]] : 0;
1583         }
1584       }
1585      
1586       
1587       function allowListClaimedBy(address owner) external view returns (uint256){
1588         require(owner != address(0), "Zero address not on Allow List");
1589     
1590         return _allowListClaimed[owner];
1591       }
1592     
1593       function onAllowList(address addr) external view returns (bool) {
1594         return _allowList[addr];
1595       }
1596     
1597       function removeFromAllowList(address[] calldata addresses) external onlyOwner {
1598         for (uint256 i = 0; i < addresses.length; i++) {
1599           require(addresses[i] != address(0), "Can't add the null address");
1600     
1601           /// @dev We don't want to reset possible _allowListClaimed numbers.
1602           _allowList[addresses[i]] = false;
1603         }
1604       }
1605     
1606     function purchaseAllowList(uint256 numberOfTokens) external payable nonReentrant {
1607         require(
1608             numberOfTokens <= PURCHASE_LIMIT,
1609             "Can only mint up to 10 token"
1610         );
1611         
1612         require(isAllowListActive, "Allow List is not active");
1613         require(_allowList[msg.sender], "You are not on the Allow List");
1614         require(
1615             _publicALIENFRENS.current() < ALIENFRENS_PUBLIC,
1616             "Purchase would exceed max"
1617         );
1618         require(numberOfTokens <= allowListMaxMint, "Cannot purchase this many tokens");
1619         require(_allowListClaimed[msg.sender] + numberOfTokens <= allowListMaxMint, "Purchase exceeds max allowed");
1620         require(PRICE * numberOfTokens <= msg.value, "ETH amount is not sufficient");
1621         require(
1622             _publicALIENFRENS.current() < ALIENFRENS_PUBLIC,
1623             "Purchase would exceed ALIENFRENS_PUBLIC"
1624         );
1625         for (uint256 i = 0; i < numberOfTokens; i++) {
1626             uint256 tokenId = _publicALIENFRENS.current();
1627 
1628             if (_publicALIENFRENS.current() < ALIENFRENS_PUBLIC) {
1629                 _publicALIENFRENS.increment();
1630                 _allowListClaimed[msg.sender] += 1;
1631                 _safeMint(msg.sender, tokenId);
1632             }
1633         }
1634         
1635       }
1636 
1637     function purchase(uint256 numberOfTokens) external payable nonReentrant {
1638         require(_isActive, "Contract is not active");
1639         require(
1640             numberOfTokens <= PURCHASE_LIMIT,
1641             "Can only mint up to 10 tokens"
1642         );
1643         require(
1644             _publicALIENFRENS.current() < ALIENFRENS_PUBLIC,
1645             "Purchase would exceed ALIENFRENS_PUBLIC"
1646         );
1647         require(
1648             PRICE * numberOfTokens <= msg.value,
1649             "ETH amount is not sufficient"
1650         );
1651 
1652         for (uint256 i = 0; i < numberOfTokens; i++) {
1653             uint256 tokenId = _publicALIENFRENS.current();
1654 
1655             if (_publicALIENFRENS.current() < ALIENFRENS_PUBLIC) {
1656                 _publicALIENFRENS.increment();
1657                 _safeMint(msg.sender, tokenId);
1658             }
1659         }
1660     }
1661 
1662     function contractURI() public view returns (string memory) {
1663         return _contractURI;
1664     }
1665 
1666     function tokenURI(uint256 tokenId)
1667         public
1668         view
1669         override(ERC721)
1670         returns (string memory)
1671     {
1672         require(_exists(tokenId), "Token does not exist");
1673 
1674         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1675     }
1676 
1677     function withdraw() external onlyOwner {
1678         uint256 balance = address(this).balance;
1679 
1680         payable(msg.sender).transfer(balance);
1681     }
1682 }