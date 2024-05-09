1 // SPDX-License-Identifier: BSD-3-Clause
2 
3 pragma solidity ^0.8.0;
4 
5 /*                                                                               
6                                                                                 
7                                   .@                #/                          
8                              %                            ,.                    
9                          @                                    /                 
10                       &                          .@.          #( /              
11                     *                       &                                   
12                   (                      &                                      
13                 .                     .                                         
14                (                     .                                          
15               (                    ,                                            
16                                   /                                             
17              /                                                                 
18              .                   (                                              
19                                  /                                              
20              .                   (                                              
21              /                                                                  
22                                   ,                                             
23               *                                                                 
24                ,                     *                                          
25                 .                      .                                        
26                   %                      @                                      
27                     @                       .*                                  
28                       *                           *@.        (&  @              
29                          #                                    @                 
30                              &                            &                     
31                                    *&              /&                           
32                                                                                 
33  
34 */
35 
36 
37 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
38 
39 /**
40  * @dev Interface of the ERC165 standard, as defined in the
41  * https://eips.ethereum.org/EIPS/eip-165[EIP].
42  *
43  * Implementers can declare support of contract interfaces, which can then be
44  * queried by others ({ERC165Checker}).
45  *
46  * For an implementation, see {ERC165}.
47  */
48 interface IERC165 {
49     /**
50      * @dev Returns true if this contract implements the interface defined by
51      * `interfaceId`. See the corresponding
52      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
53      * to learn more about how these ids are created.
54      *
55      * This function call must use less than 30 000 gas.
56      */
57     function supportsInterface(bytes4 interfaceId) external view returns (bool);
58 }
59 
60 
61 
62 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
63 
64 pragma solidity ^0.8.0;
65 
66 /**
67  * @dev Required interface of an ERC721 compliant contract.
68  */
69 interface IERC721 is IERC165 {
70     /**
71      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
74 
75     /**
76      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
77      */
78     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
82      */
83     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
84 
85     /**
86      * @dev Returns the number of tokens in ``owner``'s account.
87      */
88     function balanceOf(address owner) external view returns (uint256 balance);
89 
90     /**
91      * @dev Returns the owner of the `tokenId` token.
92      *
93      * Requirements:
94      *
95      * - `tokenId` must exist.
96      */
97     function ownerOf(uint256 tokenId) external view returns (address owner);
98 
99     /**
100      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
101      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must exist and be owned by `from`.
108      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
110      *
111      * Emits a {Transfer} event.
112      */
113     function safeTransferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Transfers `tokenId` token from `from` to `to`.
121      *
122      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
123      *
124      * Requirements:
125      *
126      * - `from` cannot be the zero address.
127      * - `to` cannot be the zero address.
128      * - `tokenId` token must be owned by `from`.
129      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transferFrom(
134         address from,
135         address to,
136         uint256 tokenId
137     ) external;
138 
139     /**
140      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
141      * The approval is cleared when the token is transferred.
142      *
143      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
144      *
145      * Requirements:
146      *
147      * - The caller must own the token or be an approved operator.
148      * - `tokenId` must exist.
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address to, uint256 tokenId) external;
153 
154     /**
155      * @dev Returns the account approved for `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function getApproved(uint256 tokenId) external view returns (address operator);
162 
163     /**
164      * @dev Approve or remove `operator` as an operator for the caller.
165      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
166      *
167      * Requirements:
168      *
169      * - The `operator` cannot be the caller.
170      *
171      * Emits an {ApprovalForAll} event.
172      */
173     function setApprovalForAll(address operator, bool _approved) external;
174 
175     /**
176      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
177      *
178      * See {setApprovalForAll}
179      */
180     function isApprovedForAll(address owner, address operator) external view returns (bool);
181 
182     /**
183      * @dev Safely transfers `tokenId` token from `from` to `to`.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId,
199         bytes calldata data
200     ) external;
201 }
202 
203 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @title ERC721 token receiver interface
209  * @dev Interface for any contract that wants to support safeTransfers
210  * from ERC721 asset contracts.
211  */
212 interface IERC721Receiver {
213     /**
214      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
215      * by `operator` from `from`, this function is called.
216      *
217      * It must return its Solidity selector to confirm the token transfer.
218      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
219      *
220      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
221      */
222     function onERC721Received(
223         address operator,
224         address from,
225         uint256 tokenId,
226         bytes calldata data
227     ) external returns (bytes4);
228 }
229 
230 
231 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
232 
233 
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
239  * @dev See https://eips.ethereum.org/EIPS/eip-721
240  */
241 interface IERC721Metadata is IERC721 {
242     /**
243      * @dev Returns the token collection name.
244      */
245     function name() external view returns (string memory);
246 
247     /**
248      * @dev Returns the token collection symbol.
249      */
250     function symbol() external view returns (string memory);
251 
252     /**
253      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
254      */
255     function tokenURI(uint256 tokenId) external view returns (string memory);
256 }
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
262  * @dev See https://eips.ethereum.org/EIPS/eip-721
263  */
264 interface IERC721Enumerable is IERC721 {
265     /**
266      * @dev Returns the total amount of tokens stored by the contract.
267      */
268     function totalSupply() external view returns (uint256);
269 
270     /**
271      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
272      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
273      */
274     function tokenOfOwnerByIndex(address owner, uint256 index)
275         external
276         view
277         returns (uint256 tokenId);
278 
279     /**
280      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
281      * Use along with {totalSupply} to enumerate all tokens.
282      */
283     function tokenByIndex(uint256 index) external view returns (uint256);
284 }
285 
286 
287 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
288 
289 
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // This method relies on extcodesize, which returns 0 for contracts in
316         // construction, since the code is only stored at the end of the
317         // constructor execution.
318 
319         uint256 size;
320         assembly {
321             size := extcodesize(account)
322         }
323         return size > 0;
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         (bool success, ) = recipient.call{value: amount}("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain `call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(address(this).balance >= value, "Address: insufficient balance for call");
417         require(isContract(target), "Address: call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.call{value: value}(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal view returns (bytes memory) {
444         require(isContract(target), "Address: static call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         require(isContract(target), "Address: delegate call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.delegatecall(data);
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
479      * revert reason using the provided one.
480      *
481      * _Available since v4.3._
482      */
483     function verifyCallResult(
484         bool success,
485         bytes memory returndata,
486         string memory errorMessage
487     ) internal pure returns (bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             // Look for revert reason and bubble it up if present
492             if (returndata.length > 0) {
493                 // The easiest way to bubble the revert reason is using memory via assembly
494 
495                 assembly {
496                     let returndata_size := mload(returndata)
497                     revert(add(32, returndata), returndata_size)
498                 }
499             } else {
500                 revert(errorMessage);
501             }
502         }
503     }
504 }
505 
506 
507 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev Provides information about the current execution context, including the
515  * sender of the transaction and its data. While these are generally available
516  * via msg.sender and msg.data, they should not be accessed in such a direct
517  * manner, since when dealing with meta-transactions the account sending and
518  * paying for execution may not be the actual sender (as far as an application
519  * is concerned).
520  *
521  * This contract is only required for intermediate, library-like contracts.
522  */
523 abstract contract Context {
524     function _msgSender() internal view virtual returns (address) {
525         return msg.sender;
526     }
527 
528     function _msgData() internal view virtual returns (bytes calldata) {
529         return msg.data;
530     }
531 }
532 
533 
534 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
535 
536 
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev Implementation of the {IERC165} interface.
542  *
543  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
544  * for the additional interface id that will be supported. For example:
545  *
546  * ```solidity
547  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
549  * }
550  * ```
551  *
552  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
553  */
554 abstract contract ERC165 is IERC165 {
555     /**
556      * @dev See {IERC165-supportsInterface}.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559         return interfaceId == type(IERC165).interfaceId;
560     }
561 }
562 
563 
564 // File contracts/Blimpie/ERC721B.sol
565 
566 
567 pragma solidity ^0.8.0;
568 
569 /********************
570 * @author: Squeebo *
571 ********************/
572 
573 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
574     using Address for address;
575 
576     // Token name
577     string private _name;
578 
579     // Token symbol
580     string private _symbol;
581 
582     // Mapping from token ID to owner address
583     address[] internal _owners;
584 
585     // Mapping from token ID to approved address
586     mapping(uint256 => address) private _tokenApprovals;
587 
588     // Mapping from owner to operator approvals
589     mapping(address => mapping(address => bool)) private _operatorApprovals;
590 
591     /**
592      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
593      */
594     constructor(string memory name_, string memory symbol_) {
595         _name = name_;
596         _symbol = symbol_;
597     }
598 
599     /**
600      * @dev See {IERC165-supportsInterface}.
601      */
602     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
603         return
604             interfaceId == type(IERC721).interfaceId ||
605             interfaceId == type(IERC721Metadata).interfaceId ||
606             super.supportsInterface(interfaceId);
607     }
608 
609     /**
610      * @dev See {IERC721-balanceOf}.
611      */
612     function balanceOf(address owner) public view virtual override returns (uint256) {
613         require(owner != address(0), "ERC721: balance query for the zero address");
614 
615         uint count = 0;
616         uint length = _owners.length;
617         for( uint i = 0; i < length; ++i ){
618           if( owner == _owners[i] ){
619             ++count;
620           }
621         }
622 
623         delete length;
624         return count;
625     }
626 
627     /**
628      * @dev See {IERC721-ownerOf}.
629      */
630     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
631         address owner = _owners[tokenId];
632         require(owner != address(0), "ERC721: owner query for nonexistent token");
633         return owner;
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-name}.
638      */
639     function name() public view virtual override returns (string memory) {
640         return _name;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-symbol}.
645      */
646     function symbol() public view virtual override returns (string memory) {
647         return _symbol;
648     }
649 
650     /**
651      * @dev See {IERC721-approve}.
652      */
653     function approve(address to, uint256 tokenId) public virtual override {
654         address owner = ERC721B.ownerOf(tokenId);
655         require(to != owner, "ERC721: approval to current owner");
656 
657         require(
658             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
659             "ERC721: approve caller is not owner nor approved for all"
660         );
661 
662         _approve(to, tokenId);
663     }
664 
665     /**
666      * @dev See {IERC721-getApproved}.
667      */
668     function getApproved(uint256 tokenId) public view virtual override returns (address) {
669         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
670 
671         return _tokenApprovals[tokenId];
672     }
673 
674     /**
675      * @dev See {IERC721-setApprovalForAll}.
676      */
677     function setApprovalForAll(address operator, bool approved) public virtual override {
678         require(operator != _msgSender(), "ERC721: approve to caller");
679 
680         _operatorApprovals[_msgSender()][operator] = approved;
681         emit ApprovalForAll(_msgSender(), operator, approved);
682     }
683 
684     /**
685      * @dev See {IERC721-isApprovedForAll}.
686      */
687     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
688         return _operatorApprovals[owner][operator];
689     }
690 
691 
692     /**
693      * @dev See {IERC721-transferFrom}.
694      */
695     function transferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) public virtual override {
700         //solhint-disable-next-line max-line-length
701         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
702 
703         _transfer(from, to, tokenId);
704     }
705 
706     /**
707      * @dev See {IERC721-safeTransferFrom}.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId
713     ) public virtual override {
714         safeTransferFrom(from, to, tokenId, "");
715     }
716 
717     /**
718      * @dev See {IERC721-safeTransferFrom}.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId,
724         bytes memory _data
725     ) public virtual override {
726         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
727         _safeTransfer(from, to, tokenId, _data);
728     }
729 
730     /**
731      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
732      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
733      *
734      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
735      *
736      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
737      * implement alternative mechanisms to perform token transfer, such as signature-based.
738      *
739      * Requirements:
740      *
741      * - `from` cannot be the zero address.
742      * - `to` cannot be the zero address.
743      * - `tokenId` token must exist and be owned by `from`.
744      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
745      *
746      * Emits a {Transfer} event.
747      */
748     function _safeTransfer(
749         address from,
750         address to,
751         uint256 tokenId,
752         bytes memory _data
753     ) internal virtual {
754         _transfer(from, to, tokenId);
755         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
756     }
757 
758     /**
759      * @dev Returns whether `tokenId` exists.
760      *
761      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
762      *
763      * Tokens start existing when they are minted (`_mint`),
764      * and stop existing when they are burned (`_burn`).
765      */
766     function _exists(uint256 tokenId) internal view virtual returns (bool) {
767         return tokenId < _owners.length && _owners[tokenId] != address(0);
768     }
769 
770     /**
771      * @dev Returns whether `spender` is allowed to manage `tokenId`.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      */
777     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
778         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
779         address owner = ERC721B.ownerOf(tokenId);
780         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
781     }
782 
783     /**
784      * @dev Safely mints `tokenId` and transfers it to `to`.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must not exist.
789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _safeMint(address to, uint256 tokenId) internal virtual {
794         _safeMint(to, tokenId, "");
795     }
796 
797 
798     /**
799      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
800      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
801      */
802     function _safeMint(
803         address to,
804         uint256 tokenId,
805         bytes memory _data
806     ) internal virtual {
807         _mint(to, tokenId);
808         require(
809             _checkOnERC721Received(address(0), to, tokenId, _data),
810             "ERC721: transfer to non ERC721Receiver implementer"
811         );
812     }
813 
814     /**
815      * @dev Mints `tokenId` and transfers it to `to`.
816      *
817      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
818      *
819      * Requirements:
820      *
821      * - `tokenId` must not exist.
822      * - `to` cannot be the zero address.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _mint(address to, uint256 tokenId) internal virtual {
827         require(to != address(0), "ERC721: mint to the zero address");
828         require(!_exists(tokenId), "ERC721: token already minted");
829 
830         _beforeTokenTransfer(address(0), to, tokenId);
831         _owners.push(to);
832 
833         emit Transfer(address(0), to, tokenId);
834     }
835 
836     /**
837      * @dev Destroys `tokenId`.
838      * The approval is cleared when the token is burned.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _burn(uint256 tokenId) internal virtual {
847         address owner = ERC721B.ownerOf(tokenId);
848 
849         _beforeTokenTransfer(owner, address(0), tokenId);
850 
851         // Clear approvals
852         _approve(address(0), tokenId);
853         _owners[tokenId] = address(0);
854 
855         emit Transfer(owner, address(0), tokenId);
856     }
857 
858     /**
859      * @dev Transfers `tokenId` from `from` to `to`.
860      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
861      *
862      * Requirements:
863      *
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must be owned by `from`.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _transfer(
870         address from,
871         address to,
872         uint256 tokenId
873     ) internal virtual {
874         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
875         require(to != address(0), "ERC721: transfer to the zero address");
876 
877         _beforeTokenTransfer(from, to, tokenId);
878 
879         // Clear approvals from the previous owner
880         _approve(address(0), tokenId);
881         _owners[tokenId] = to;
882 
883         emit Transfer(from, to, tokenId);
884     }
885 
886     /**
887      * @dev Approve `to` to operate on `tokenId`
888      *
889      * Emits a {Approval} event.
890      */
891     function _approve(address to, uint256 tokenId) internal virtual {
892         _tokenApprovals[tokenId] = to;
893         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
894     }
895 
896 
897     /**
898      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
899      * The call is not executed if the target address is not a contract.
900      *
901      * @param from address representing the previous owner of the given token ID
902      * @param to target address that will receive the tokens
903      * @param tokenId uint256 ID of the token to be transferred
904      * @param _data bytes optional data to send along with the call
905      * @return bool whether the call correctly returned the expected magic value
906      */
907     function _checkOnERC721Received(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) private returns (bool) {
913         if (to.isContract()) {
914             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
915                 return retval == IERC721Receiver.onERC721Received.selector;
916             } catch (bytes memory reason) {
917                 if (reason.length == 0) {
918                     revert("ERC721: transfer to non ERC721Receiver implementer");
919                 } else {
920                     assembly {
921                         revert(add(32, reason), mload(reason))
922                     }
923                 }
924             }
925         } else {
926             return true;
927         }
928     }
929 
930     /**
931      * @dev Hook that is called before any token transfer. This includes minting
932      * and burning.
933      *
934      * Calling conditions:
935      *
936      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
937      * transferred to `to`.
938      * - When `from` is zero, `tokenId` will be minted for `to`.
939      * - When `to` is zero, ``from``'s `tokenId` will be burned.
940      * - `from` and `to` are never both zero.
941      *
942      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
943      */
944     function _beforeTokenTransfer(
945         address from,
946         address to,
947         uint256 tokenId
948     ) internal virtual {}
949 }
950 
951 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
952 
953 
954 
955 pragma solidity ^0.8.0;
956 
957 /**
958  * @dev String operations.
959  */
960 library Strings {
961     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
962 
963     /**
964      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
965      */
966     function toString(uint256 value) internal pure returns (string memory) {
967         // Inspired by OraclizeAPI's implementation - MIT licence
968         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
969 
970         if (value == 0) {
971             return "0";
972         }
973         uint256 temp = value;
974         uint256 digits;
975         while (temp != 0) {
976             digits++;
977             temp /= 10;
978         }
979         bytes memory buffer = new bytes(digits);
980         while (value != 0) {
981             digits -= 1;
982             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
983             value /= 10;
984         }
985         return string(buffer);
986     }
987 
988     /**
989      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
990      */
991     function toHexString(uint256 value) internal pure returns (string memory) {
992         if (value == 0) {
993             return "0x00";
994         }
995         uint256 temp = value;
996         uint256 length = 0;
997         while (temp != 0) {
998             length++;
999             temp >>= 8;
1000         }
1001         return toHexString(value, length);
1002     }
1003 
1004     /**
1005      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1006      */
1007     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1008         bytes memory buffer = new bytes(2 * length + 2);
1009         buffer[0] = "0";
1010         buffer[1] = "x";
1011         for (uint256 i = 2 * length + 1; i > 1; --i) {
1012             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1013             value >>= 4;
1014         }
1015         require(value == 0, "Strings: hex length insufficient");
1016         return string(buffer);
1017     }
1018 }
1019 
1020 
1021 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1022 
1023 
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 /**
1028  * @dev Contract module which provides a basic access control mechanism, where
1029  * there is an account (an owner) that can be granted exclusive access to
1030  * specific functions.
1031  *
1032  * By default, the owner account will be the one that deploys the contract. This
1033  * can later be changed with {transferOwnership}.
1034  *
1035  * This module is used through inheritance. It will make available the modifier
1036  * `onlyOwner`, which can be applied to your functions to restrict their use to
1037  * the owner.
1038  */
1039 abstract contract Ownable is Context {
1040     address private _owner;
1041 
1042     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1043 
1044     /**
1045      * @dev Initializes the contract setting the deployer as the initial owner.
1046      */
1047     constructor() {
1048         _setOwner(_msgSender());
1049     }
1050 
1051     /**
1052      * @dev Returns the address of the current owner.
1053      */
1054     function owner() public view virtual returns (address) {
1055         return _owner;
1056     }
1057 
1058     /**
1059      * @dev Throws if called by any account other than the owner.
1060      */
1061     modifier onlyOwner() {
1062         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1063         _;
1064     }
1065 
1066     /**
1067      * @dev Leaves the contract without owner. It will not be possible to call
1068      * `onlyOwner` functions anymore. Can only be called by the current owner.
1069      *
1070      * NOTE: Renouncing ownership will leave the contract without an owner,
1071      * thereby removing any functionality that is only available to the owner.
1072      */
1073     function renounceOwnership() public virtual onlyOwner {
1074         _setOwner(address(0));
1075     }
1076 
1077     /**
1078      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1079      * Can only be called by the current owner.
1080      */
1081     function transferOwnership(address newOwner) public virtual onlyOwner {
1082         require(newOwner != address(0), "Ownable: new owner is the zero address");
1083         _setOwner(newOwner);
1084     }
1085 
1086     function _setOwner(address newOwner) private {
1087         address oldOwner = _owner;
1088         _owner = newOwner;
1089         emit OwnershipTransferred(oldOwner, newOwner);
1090     }
1091 }
1092 
1093 pragma solidity ^0.8.7;
1094 
1095 contract WENMOON is Ownable, ERC721B {
1096 
1097     using Strings for uint256;
1098 
1099     uint256 public constant maxSupply = 10000;
1100     uint256 public constant giftSupply = 200;
1101 
1102     uint256 public constant purchaseLimit = 2;
1103 
1104     string public provenance;
1105 
1106     uint256 public giftedAmount;
1107 
1108     string private _tokenBaseURI;
1109 
1110     address private withdrawAddress = 0xa0B36E284D0994b57B4f2812E36115b91FaEd92B;
1111 
1112     bool public saleLive;
1113 
1114     mapping(address => uint256) private purchases;
1115     
1116     constructor(
1117         string memory baseUri
1118     ) ERC721B("WEN MOON?", "MOON") { 
1119         _tokenBaseURI = baseUri;
1120     }
1121 
1122     /* ---- Functions ---- */
1123 
1124     function mint(uint256 tokenQuantity) external payable {
1125         require(saleLive, "SALE_CLOSED");
1126         require(tokenQuantity <= purchaseLimit, "EXCEED_MOON_PER_MINT");
1127         require(totalSupply() + tokenQuantity < maxSupply, "EXCEED_MAX_SALE_SUPPLY");
1128         require(purchases[msg.sender] + tokenQuantity <= purchaseLimit, "EXCEED_ALLOC");
1129 
1130         purchases[msg.sender] += tokenQuantity;
1131 
1132         for (uint256 i = 0; i < tokenQuantity; i++) {
1133             uint mintIndex = totalSupply();
1134             _mint( msg.sender, mintIndex );
1135         }
1136     } 
1137 
1138     function gift(address _to, uint256 _reserveAmount) external onlyOwner {
1139         require(totalSupply() + _reserveAmount <= maxSupply, "MAX_MINT");
1140         require(giftedAmount + _reserveAmount <= giftSupply, "NO_GIFTS");
1141         
1142         giftedAmount += _reserveAmount;
1143 
1144         for (uint256 i = 0; i < _reserveAmount; i++) {
1145             uint mintIndex = totalSupply();
1146             _safeMint( _to, mintIndex );
1147         }
1148     }
1149 
1150     function withdraw() external onlyOwner {
1151         uint balance = address(this).balance;
1152         _withdraw(withdrawAddress, balance);
1153     }
1154 
1155     function _withdraw(address _address, uint256 _amount) private {
1156         (bool success, ) = _address.call{value: _amount}("");
1157         require(success, "Transfer failed.");
1158     }
1159     
1160     /* ---- Setters ---- */
1161 
1162     function toggleSaleStatus() external onlyOwner {
1163         saleLive = !saleLive;
1164     }
1165 
1166     function setBaseURI(string calldata URI) external onlyOwner {
1167         _tokenBaseURI = URI;
1168     }
1169     
1170     function setProvenanceHash(string calldata hash) external onlyOwner {
1171         provenance = hash;
1172     } 
1173 
1174     /* ---- Misc ---- */
1175 
1176     function totalSupply() public view virtual returns (uint256) {
1177         return _owners.length;
1178     }
1179 
1180     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
1181         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1182         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1183     }
1184 }