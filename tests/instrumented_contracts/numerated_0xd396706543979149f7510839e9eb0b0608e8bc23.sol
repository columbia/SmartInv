1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 pragma solidity ^0.8.0;
5 
6 //                               @                            
7 //                              @@@                          
8 //                            @@@@@@@                          
9 //                           @@@@@@@@@                         
10 //                          @@@@@@@@@@@                        
11 //                        @@@@@@@@@@@@@@@                       
12 //                      @@@@@@@@@@@@@@@@@@@                    
13 //                   @@@@@@@@@@@@@@@@@@@@@@@@@                
14 //                    @@@@@ KARMELEONS @@@@@                   
15 //        %@@@@@@@@@      @@@@@@@@@@@@@@@      @@@@@@@@@%      
16 //     @@@@@@@@@@@@@@@@@    @@@@@@@@@@@    @@@@@@@@@@@@@@@@@   
17 //   @@@@@@@@@@@@@@@@@@@@%   @@@@@@@@@   %@@@@@@@@@@@@@@@@@@@@ 
18 //  @@@@@@@@@@@@@@@@@@@@@@%   @@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@
19 //                            %@@@@@%                          
20 //                            @@@@@@@                          
21 //  @@@@@@@@@#   @@@@@@@@@    @@@@@@@    @@@@@@@@@   #@@@@@@@@@
22 //   #@@@@@@@@@@@@@@@@@@@    @@@@@@@@@    @@@@@@@@@@@@@@@@@@@# 
23 //      @@@@@@@@@@@@@@@    @@@@@@@@@@@@@    @@@@@@@@@@@@@@@    
24 // @%        (@@(        @@@@@@@@@@@@@@@@@        (@@(       %@
25 // @@@@@@&           @@@@@@    @@@@@    @@@@@@           &@@@@@
26 // @@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@
27 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
28 // @@@@@@@@@@@@@@@@@@@@@&                 &@@@@@@@@@@@@@@@@@@@@
29 //  @@@@@@@@@                                        @@@@@@@@@
30 //               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             
31 //       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     
32 //              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            
33 //                      @@@@@@@@@@@@@@@@@@@   
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others ({ERC165Checker}).
41  *
42  * For an implementation, see {ERC165}.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
57 pragma solidity ^0.8.0;
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 
174     /**
175      * @dev Safely transfers `tokenId` token from `from` to `to`.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external;
193 }
194 
195 
196 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
197 pragma solidity ^0.8.0;
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Enumerable is IERC721 {
203     /**
204      * @dev Returns the total amount of tokens stored by the contract.
205      */
206     function totalSupply() external view returns (uint256);
207 
208     /**
209      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
210      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
211      */
212     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
213 
214     /**
215      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
216      * Use along with {totalSupply} to enumerate all tokens.
217      */
218     function tokenByIndex(uint256 index) external view returns (uint256);
219 }
220 
221 
222 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
223 pragma solidity ^0.8.0;
224 /**
225  * @dev Implementation of the {IERC165} interface.
226  *
227  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
228  * for the additional interface id that will be supported. For example:
229  *
230  * ```solidity
231  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
232  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
233  * }
234  * ```
235  *
236  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
237  */
238 abstract contract ERC165 is IERC165 {
239     /**
240      * @dev See {IERC165-supportsInterface}.
241      */
242     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
243         return interfaceId == type(IERC165).interfaceId;
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Strings.sol
248 
249 
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @dev String operations.
255  */
256 library Strings {
257     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
261      */
262     function toString(uint256 value) internal pure returns (string memory) {
263         // Inspired by OraclizeAPI's implementation - MIT licence
264         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
265 
266         if (value == 0) {
267             return "0";
268         }
269         uint256 temp = value;
270         uint256 digits;
271         while (temp != 0) {
272             digits++;
273             temp /= 10;
274         }
275         bytes memory buffer = new bytes(digits);
276         while (value != 0) {
277             digits -= 1;
278             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
279             value /= 10;
280         }
281         return string(buffer);
282     }
283 
284     /**
285      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
286      */
287     function toHexString(uint256 value) internal pure returns (string memory) {
288         if (value == 0) {
289             return "0x00";
290         }
291         uint256 temp = value;
292         uint256 length = 0;
293         while (temp != 0) {
294             length++;
295             temp >>= 8;
296         }
297         return toHexString(value, length);
298     }
299 
300     /**
301      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
302      */
303     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
304         bytes memory buffer = new bytes(2 * length + 2);
305         buffer[0] = "0";
306         buffer[1] = "x";
307         for (uint256 i = 2 * length + 1; i > 1; --i) {
308             buffer[i] = _HEX_SYMBOLS[value & 0xf];
309             value >>= 4;
310         }
311         require(value == 0, "Strings: hex length insufficient");
312         return string(buffer);
313     }
314 }
315 
316 // File: @openzeppelin/contracts/utils/Address.sol
317 
318 
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      */
343     function isContract(address account) internal view returns (bool) {
344         // This method relies on extcodesize, which returns 0 for contracts in
345         // construction, since the code is only stored at the end of the
346         // constructor execution.
347 
348         uint256 size;
349         assembly {
350             size := extcodesize(account)
351         }
352         return size > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         (bool success, ) = recipient.call{value: amount}("");
375         require(success, "Address: unable to send value, recipient may have reverted");
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain `call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionCall(target, data, "Address: low-level call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402      * `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(
426         address target,
427         bytes memory data,
428         uint256 value
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
435      * with `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(address(this).balance >= value, "Address: insufficient balance for call");
446         require(isContract(target), "Address: call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.call{value: value}(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
459         return functionStaticCall(target, data, "Address: low-level static call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal view returns (bytes memory) {
473         require(isContract(target), "Address: static call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.staticcall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.4._
494      */
495     function functionDelegateCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(isContract(target), "Address: delegate call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.delegatecall(data);
503         return verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
508      * revert reason using the provided one.
509      *
510      * _Available since v4.3._
511      */
512     function verifyCallResult(
513         bool success,
514         bytes memory returndata,
515         string memory errorMessage
516     ) internal pure returns (bytes memory) {
517         if (success) {
518             return returndata;
519         } else {
520             // Look for revert reason and bubble it up if present
521             if (returndata.length > 0) {
522                 // The easiest way to bubble the revert reason is using memory via assembly
523 
524                 assembly {
525                     let returndata_size := mload(returndata)
526                     revert(add(32, returndata), returndata_size)
527                 }
528             } else {
529                 revert(errorMessage);
530             }
531         }
532     }
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
544  * @dev See https://eips.ethereum.org/EIPS/eip-721
545  */
546 interface IERC721Metadata is IERC721 {
547     /**
548      * @dev Returns the token collection name.
549      */
550     function name() external view returns (string memory);
551 
552     /**
553      * @dev Returns the token collection symbol.
554      */
555     function symbol() external view returns (string memory);
556 
557     /**
558      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
559      */
560     function tokenURI(uint256 tokenId) external view returns (string memory);
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
564 
565 
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @title ERC721 token receiver interface
571  * @dev Interface for any contract that wants to support safeTransfers
572  * from ERC721 asset contracts.
573  */
574 interface IERC721Receiver {
575     /**
576      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
577      * by `operator` from `from`, this function is called.
578      *
579      * It must return its Solidity selector to confirm the token transfer.
580      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
581      *
582      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
583      */
584     function onERC721Received(
585         address operator,
586         address from,
587         uint256 tokenId,
588         bytes calldata data
589     ) external returns (bytes4);
590 }
591 
592 // File: @openzeppelin/contracts/utils/Context.sol
593 pragma solidity ^0.8.0;
594 /**
595  * @dev Provides information about the current execution context, including the
596  * sender of the transaction and its data. While these are generally available
597  * via msg.sender and msg.data, they should not be accessed in such a direct
598  * manner, since when dealing with meta-transactions the account sending and
599  * paying for execution may not be the actual sender (as far as an application
600  * is concerned).
601  *
602  * This contract is only required for intermediate, library-like contracts.
603  */
604 abstract contract Context {
605     function _msgSender() internal view virtual returns (address) {
606         return msg.sender;
607     }
608 
609     function _msgData() internal view virtual returns (bytes calldata) {
610         return msg.data;
611     }
612 }
613 
614 
615 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
616 pragma solidity ^0.8.0;
617 /**
618  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
619  * the Metadata extension, but not including the Enumerable extension, which is available separately as
620  * {ERC721Enumerable}.
621  */
622 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
623     using Address for address;
624     using Strings for uint256;
625 
626     // Token name
627     string private _name;
628 
629     // Token symbol
630     string private _symbol;
631 
632     // Mapping from token ID to owner address
633     mapping(uint256 => address) private _owners;
634 
635     // Mapping owner address to token count
636     mapping(address => uint256) private _balances;
637 
638     // Mapping from token ID to approved address
639     mapping(uint256 => address) private _tokenApprovals;
640 
641     // Mapping from owner to operator approvals
642     mapping(address => mapping(address => bool)) private _operatorApprovals;
643 
644     /**
645      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
646      */
647     constructor(string memory name_, string memory symbol_) {
648         _name = name_;
649         _symbol = symbol_;
650     }
651 
652     /**
653      * @dev See {IERC165-supportsInterface}.
654      */
655     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
656         return
657             interfaceId == type(IERC721).interfaceId ||
658             interfaceId == type(IERC721Metadata).interfaceId ||
659             super.supportsInterface(interfaceId);
660     }
661 
662     /**
663      * @dev See {IERC721-balanceOf}.
664      */
665     function balanceOf(address owner) public view virtual override returns (uint256) {
666         require(owner != address(0), "ERC721: balance query for the zero address");
667         return _balances[owner];
668     }
669 
670     /**
671      * @dev See {IERC721-ownerOf}.
672      */
673     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
674         address owner = _owners[tokenId];
675         require(owner != address(0), "ERC721: owner query for nonexistent token");
676         return owner;
677     }
678 
679     /**
680      * @dev See {IERC721Metadata-name}.
681      */
682     function name() public view virtual override returns (string memory) {
683         return _name;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-symbol}.
688      */
689     function symbol() public view virtual override returns (string memory) {
690         return _symbol;
691     }
692 
693     /**
694      * @dev See {IERC721Metadata-tokenURI}.
695      */
696     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
697         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
698 
699         string memory baseURI = _baseURI();
700         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
701     }
702 
703     /**
704      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
705      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
706      * by default, can be overriden in child contracts.
707      */
708     function _baseURI() internal view virtual returns (string memory) {
709         return "";
710     }
711 
712     /**
713      * @dev See {IERC721-approve}.
714      */
715     function approve(address to, uint256 tokenId) public virtual override {
716         address owner = ERC721.ownerOf(tokenId);
717         require(to != owner, "ERC721: approval to current owner");
718 
719         require(
720             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
721             "ERC721: approve caller is not owner nor approved for all"
722         );
723 
724         _approve(to, tokenId);
725     }
726 
727     /**
728      * @dev See {IERC721-getApproved}.
729      */
730     function getApproved(uint256 tokenId) public view virtual override returns (address) {
731         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
732 
733         return _tokenApprovals[tokenId];
734     }
735 
736     /**
737      * @dev See {IERC721-setApprovalForAll}.
738      */
739     function setApprovalForAll(address operator, bool approved) public virtual override {
740         require(operator != _msgSender(), "ERC721: approve to caller");
741 
742         _operatorApprovals[_msgSender()][operator] = approved;
743         emit ApprovalForAll(_msgSender(), operator, approved);
744     }
745 
746     /**
747      * @dev See {IERC721-isApprovedForAll}.
748      */
749     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
750         return _operatorApprovals[owner][operator];
751     }
752 
753     /**
754      * @dev See {IERC721-transferFrom}.
755      */
756     function transferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) public virtual override {
761         //solhint-disable-next-line max-line-length
762         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
763 
764         _transfer(from, to, tokenId);
765     }
766 
767     /**
768      * @dev See {IERC721-safeTransferFrom}.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) public virtual override {
775         safeTransferFrom(from, to, tokenId, "");
776     }
777 
778     /**
779      * @dev See {IERC721-safeTransferFrom}.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes memory _data
786     ) public virtual override {
787         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
788         _safeTransfer(from, to, tokenId, _data);
789     }
790 
791     /**
792      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
793      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
794      *
795      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
796      *
797      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
798      * implement alternative mechanisms to perform token transfer, such as signature-based.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must exist and be owned by `from`.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _safeTransfer(
810         address from,
811         address to,
812         uint256 tokenId,
813         bytes memory _data
814     ) internal virtual {
815         _transfer(from, to, tokenId);
816         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
817     }
818 
819     /**
820      * @dev Returns whether `tokenId` exists.
821      *
822      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
823      *
824      * Tokens start existing when they are minted (`_mint`),
825      * and stop existing when they are burned (`_burn`).
826      */
827     function _exists(uint256 tokenId) internal view virtual returns (bool) {
828         return _owners[tokenId] != address(0);
829     }
830 
831     /**
832      * @dev Returns whether `spender` is allowed to manage `tokenId`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      */
838     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
839         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
840         address owner = ERC721.ownerOf(tokenId);
841         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
842     }
843 
844     /**
845      * @dev Safely mints `tokenId` and transfers it to `to`.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must not exist.
850      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
851      *
852      * Emits a {Transfer} event.
853      */
854     function _safeMint(address to, uint256 tokenId) internal virtual {
855         _safeMint(to, tokenId, "");
856     }
857 
858     /**
859      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
860      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
861      */
862     function _safeMint(
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) internal virtual {
867         _mint(to, tokenId);
868         require(
869             _checkOnERC721Received(address(0), to, tokenId, _data),
870             "ERC721: transfer to non ERC721Receiver implementer"
871         );
872     }
873 
874     /**
875      * @dev Mints `tokenId` and transfers it to `to`.
876      *
877      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
878      *
879      * Requirements:
880      *
881      * - `tokenId` must not exist.
882      * - `to` cannot be the zero address.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _mint(address to, uint256 tokenId) internal virtual {
887         require(to != address(0), "ERC721: mint to the zero address");
888         require(!_exists(tokenId), "ERC721: token already minted");
889 
890         _beforeTokenTransfer(address(0), to, tokenId);
891 
892         _balances[to] += 1;
893         _owners[tokenId] = to;
894 
895         emit Transfer(address(0), to, tokenId);
896     }
897 
898     /**
899      * @dev Destroys `tokenId`.
900      * The approval is cleared when the token is burned.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _burn(uint256 tokenId) internal virtual {
909         address owner = ERC721.ownerOf(tokenId);
910 
911         _beforeTokenTransfer(owner, address(0), tokenId);
912 
913         // Clear approvals
914         _approve(address(0), tokenId);
915 
916         _balances[owner] -= 1;
917         delete _owners[tokenId];
918 
919         emit Transfer(owner, address(0), tokenId);
920     }
921 
922     /**
923      * @dev Transfers `tokenId` from `from` to `to`.
924      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
925      *
926      * Requirements:
927      *
928      * - `to` cannot be the zero address.
929      * - `tokenId` token must be owned by `from`.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _transfer(
934         address from,
935         address to,
936         uint256 tokenId
937     ) internal virtual {
938         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
939         require(to != address(0), "ERC721: transfer to the zero address");
940 
941         _beforeTokenTransfer(from, to, tokenId);
942 
943         // Clear approvals from the previous owner
944         _approve(address(0), tokenId);
945 
946         _balances[from] -= 1;
947         _balances[to] += 1;
948         _owners[tokenId] = to;
949 
950         emit Transfer(from, to, tokenId);
951     }
952 
953     /**
954      * @dev Approve `to` to operate on `tokenId`
955      *
956      * Emits a {Approval} event.
957      */
958     function _approve(address to, uint256 tokenId) internal virtual {
959         _tokenApprovals[tokenId] = to;
960         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
961     }
962 
963     /**
964      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
965      * The call is not executed if the target address is not a contract.
966      *
967      * @param from address representing the previous owner of the given token ID
968      * @param to target address that will receive the tokens
969      * @param tokenId uint256 ID of the token to be transferred
970      * @param _data bytes optional data to send along with the call
971      * @return bool whether the call correctly returned the expected magic value
972      */
973     function _checkOnERC721Received(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) private returns (bool) {
979         if (to.isContract()) {
980             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
981                 return retval == IERC721Receiver.onERC721Received.selector;
982             } catch (bytes memory reason) {
983                 if (reason.length == 0) {
984                     revert("ERC721: transfer to non ERC721Receiver implementer");
985                 } else {
986                     assembly {
987                         revert(add(32, reason), mload(reason))
988                     }
989                 }
990             }
991         } else {
992             return true;
993         }
994     }
995 
996     /**
997      * @dev Hook that is called before any token transfer. This includes minting
998      * and burning.
999      *
1000      * Calling conditions:
1001      *
1002      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1003      * transferred to `to`.
1004      * - When `from` is zero, `tokenId` will be minted for `to`.
1005      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1006      * - `from` and `to` are never both zero.
1007      *
1008      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1009      */
1010     function _beforeTokenTransfer(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) internal virtual {}
1015 }
1016 
1017 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1018 
1019 
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 
1024 
1025 /**
1026  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1027  * enumerability of all the token ids in the contract as well as all token ids owned by each
1028  * account.
1029  */
1030 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1031     // Mapping from owner to list of owned token IDs
1032     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1033 
1034     // Mapping from token ID to index of the owner tokens list
1035     mapping(uint256 => uint256) private _ownedTokensIndex;
1036 
1037     // Array with all token ids, used for enumeration
1038     uint256[] private _allTokens;
1039 
1040     // Mapping from token id to position in the allTokens array
1041     mapping(uint256 => uint256) private _allTokensIndex;
1042 
1043     /**
1044      * @dev See {IERC165-supportsInterface}.
1045      */
1046     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1047         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1052      */
1053     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1054         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1055         return _ownedTokens[owner][index];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-totalSupply}.
1060      */
1061     function totalSupply() public view virtual override returns (uint256) {
1062         return _allTokens.length;
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-tokenByIndex}.
1067      */
1068     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1069         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1070         return _allTokens[index];
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before any token transfer. This includes minting
1075      * and burning.
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` will be minted for `to`.
1082      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _beforeTokenTransfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual override {
1093         super._beforeTokenTransfer(from, to, tokenId);
1094 
1095         if (from == address(0)) {
1096             _addTokenToAllTokensEnumeration(tokenId);
1097         } else if (from != to) {
1098             _removeTokenFromOwnerEnumeration(from, tokenId);
1099         }
1100         if (to == address(0)) {
1101             _removeTokenFromAllTokensEnumeration(tokenId);
1102         } else if (to != from) {
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
1181 
1182 // File: @openzeppelin/contracts/access/Ownable.sol
1183 pragma solidity ^0.8.0;
1184 /**
1185  * @dev Contract module which provides a basic access control mechanism, where
1186  * there is an account (an owner) that can be granted exclusive access to
1187  * specific functions.
1188  *
1189  * By default, the owner account will be the one that deploys the contract. This
1190  * can later be changed with {transferOwnership}.
1191  *
1192  * This module is used through inheritance. It will make available the modifier
1193  * `onlyOwner`, which can be applied to your functions to restrict their use to
1194  * the owner.
1195  */
1196 abstract contract Ownable is Context {
1197     address private _owner;
1198 
1199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1200 
1201     /**
1202      * @dev Initializes the contract setting the deployer as the initial owner.
1203      */
1204     constructor() {
1205         _setOwner(_msgSender());
1206     }
1207 
1208     /**
1209      * @dev Returns the address of the current owner.
1210      */
1211     function owner() public view virtual returns (address) {
1212         return _owner;
1213     }
1214 
1215     /**
1216      * @dev Throws if called by any account other than the owner.
1217      */
1218     modifier onlyOwner() {
1219         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1220         _;
1221     }
1222 
1223     /**
1224      * @dev Leaves the contract without owner. It will not be possible to call
1225      * `onlyOwner` functions anymore. Can only be called by the current owner.
1226      *
1227      * NOTE: Renouncing ownership will leave the contract without an owner,
1228      * thereby removing any functionality that is only available to the owner.
1229      */
1230     function renounceOwnership() public virtual onlyOwner {
1231         _setOwner(address(0));
1232     }
1233 
1234     /**
1235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1236      * Can only be called by the current owner.
1237      */
1238     function transferOwnership(address newOwner) public virtual onlyOwner {
1239         require(newOwner != address(0), "Ownable: new owner is the zero address");
1240         _setOwner(newOwner);
1241     }
1242 
1243     function _setOwner(address newOwner) private {
1244         address oldOwner = _owner;
1245         _owner = newOwner;
1246         emit OwnershipTransferred(oldOwner, newOwner);
1247     }
1248 }
1249 
1250 pragma solidity >=0.7.0 <0.9.0;
1251 
1252 contract Karmeleons is ERC721Enumerable, Ownable {
1253   using Strings for uint256;
1254 
1255   string baseURI;
1256   string public baseExtension = ".json";
1257   uint256 public cost = 0.07 ether;
1258   uint256 public maxSupply = 3333;
1259   uint256 public maxMintAmount = 3;
1260   bool public paused = true;
1261   bool public revealed = false;
1262   string public notRevealedUri;
1263 
1264   constructor(
1265     string memory _name,
1266     string memory _symbol,
1267     string memory _initBaseURI,
1268     string memory _initNotRevealedUri
1269   ) ERC721(_name, _symbol) {
1270     setBaseURI(_initBaseURI);
1271     setNotRevealedURI(_initNotRevealedUri);
1272   }
1273 
1274   // internal
1275   function _baseURI() internal view virtual override returns (string memory) {
1276     return baseURI;
1277   }
1278 
1279   // public
1280   function mint(uint256 _mintAmount) public payable {
1281     uint256 supply = totalSupply();
1282     require(!paused);
1283     require(_mintAmount > 0);
1284     require(_mintAmount <= maxMintAmount);
1285     require(supply + _mintAmount <= maxSupply);
1286 
1287     if (msg.sender != owner()) {
1288       require(msg.value >= cost * _mintAmount);
1289     }
1290 
1291     for (uint256 i = 1; i <= _mintAmount; i++) {
1292       _safeMint(msg.sender, supply + i);
1293     }
1294   }
1295 
1296   function walletOfOwner(address _owner)
1297     public
1298     view
1299     returns (uint256[] memory)
1300   {
1301     uint256 ownerTokenCount = balanceOf(_owner);
1302     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1303     for (uint256 i; i < ownerTokenCount; i++) {
1304       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1305     }
1306     return tokenIds;
1307   }
1308 
1309   function tokenURI(uint256 tokenId)
1310     public
1311     view
1312     virtual
1313     override
1314     returns (string memory)
1315   {
1316     require(
1317       _exists(tokenId),
1318       "ERC721Metadata: URI query for nonexistent token"
1319     );
1320     
1321     if(revealed == false) {
1322         return notRevealedUri;
1323     }
1324 
1325     string memory currentBaseURI = _baseURI();
1326     return bytes(currentBaseURI).length > 0
1327         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1328         : "";
1329   }
1330 
1331   //only owner
1332   function reveal() public onlyOwner {
1333       revealed = true;
1334   }
1335   
1336   function setCost(uint256 _newCost) public onlyOwner {
1337     cost = _newCost;
1338   }
1339 
1340   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1341     maxMintAmount = _newmaxMintAmount;
1342   }
1343   
1344   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1345     notRevealedUri = _notRevealedURI;
1346   }
1347 
1348   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1349     baseURI = _newBaseURI;
1350   }
1351 
1352   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1353     baseExtension = _newBaseExtension;
1354   }
1355 
1356   function pause(bool _state) public onlyOwner {
1357     paused = _state;
1358   }
1359  
1360   function withdraw() public payable onlyOwner {
1361     // This will pay HashLips 5% of the initial sale.
1362     // You can remove this if you want, or keep it in to support HashLips and his channel.
1363     // =============================================================================
1364     // (bool hs, ) = payable(0x943590A42C27D08e3744202c4Ae5eD55c2dE240D).call{value: address(this).balance * 5 / 100}("");
1365     // require(hs);
1366     // =============================================================================
1367     
1368     // This will payout the owner 95% of the contract balance.
1369     // Do not remove this otherwise you will not be able to withdraw the funds.
1370     // =============================================================================
1371     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1372     require(os);
1373     // =============================================================================
1374   }
1375 }