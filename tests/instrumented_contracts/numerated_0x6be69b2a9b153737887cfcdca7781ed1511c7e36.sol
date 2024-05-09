1 //             ((((((((((((((((((.                                             
2 //         ((((((((((((((((((((((((((*                                         
3 //      /(((((((((((((((((((((((((((((((*                                      
4 //     ((((((((((((#             #(((((((((                                    
5 //   (((((((((((                     ((((((((((((((((((((((,                   
6 //   ((((((((#         ((((((((((       (((((((((((((((((((((((((              
7 //  *(((((((       #(((((((((((((((((               /(((((((((((((((           
8 //  *((((((/     #((((((#        .((((((                 .((((((((((((.        
9 //   ((((((.    ((((((               #(((((((((((((#         (((((((((((       
10 //   ((((((/    ((((/                         .((((((((.      .((((((((((      
11 //   *((((((    ((((                              (((((((       ((((((((((     
12 //    ((((((,   ,(((.                               ((((((      .(((((((((     
13 //     ((((((    ((((                                (((((*      (((((((((     
14 //      ((((((    ((((                              ((((((      #(((((((((     
15 //       ((((((    #(((                            #(((((      ((((((((((      
16 //        ((((((/   .(((.                        ((((((,      ((((((((((       
17 //          ((((((    ((((                    (((((((       ((((((((((         
18 //           ((((((    /(((             ,((((((((        ((((((((((/           
19 //            /(((((#    ((((     ((((((((((         #(((((((((((              
20 //              ((((((    ((((((((((((          #((((((((((((*                 
21 //               ((((((/    ((,           (((((((((((((((                      
22 //                 ((((((          ,(((((((((((((((/                           
23 //                  ((((((*(((((((((((((((((((                                 
24 //                   ,(((((((((((((((((*                                       
25 //                     (((((((((,  
26 //           
27 // Killer GF by Zeronis and uwulabs                                  
28 // Made with love <3                                            
29 
30 
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Collection of functions related to the address type
37  */
38 library Address {
39     /**
40      * @dev Returns true if `account` is a contract.
41      *
42      * [IMPORTANT]
43      * ====
44      * It is unsafe to assume that an address for which this function returns
45      * false is an externally-owned account (EOA) and not a contract.
46      *
47      * Among others, `isContract` will return false for the following
48      * types of addresses:
49      *
50      *  - an externally-owned account
51      *  - a contract in construction
52      *  - an address where a contract will be created
53      *  - an address where a contract lived, but was destroyed
54      * ====
55      */
56     function isContract(address account) internal view returns (bool) {
57         // This method relies on extcodesize, which returns 0 for contracts in
58         // construction, since the code is only stored at the end of the
59         // constructor execution.
60 
61         uint256 size;
62         // solhint-disable-next-line no-inline-assembly
63         assembly { size := extcodesize(account) }
64         return size > 0;
65     }
66 
67     /**
68      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
69      * `recipient`, forwarding all available gas and reverting on errors.
70      *
71      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
72      * of certain opcodes, possibly making contracts go over the 2300 gas limit
73      * imposed by `transfer`, making them unable to receive funds via
74      * `transfer`. {sendValue} removes this limitation.
75      *
76      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
77      *
78      * IMPORTANT: because control is transferred to `recipient`, care must be
79      * taken to not create reentrancy vulnerabilities. Consider using
80      * {ReentrancyGuard} or the
81      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
82      */
83     function sendValue(address payable recipient, uint256 amount) internal {
84         require(address(this).balance >= amount, "Address: insufficient balance");
85 
86         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
87         (bool success, ) = recipient.call{ value: amount }("");
88         require(success, "Address: unable to send value, recipient may have reverted");
89     }
90 
91     /**
92      * @dev Performs a Solidity function call using a low level `call`. A
93      * plain`call` is an unsafe replacement for a function call: use this
94      * function instead.
95      *
96      * If `target` reverts with a revert reason, it is bubbled up by this
97      * function (like regular Solidity function calls).
98      *
99      * Returns the raw returned data. To convert to the expected return value,
100      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
101      *
102      * Requirements:
103      *
104      * - `target` must be a contract.
105      * - calling `target` with `data` must not revert.
106      *
107      * _Available since v3.1._
108      */
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110       return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
115      * `errorMessage` as a fallback revert reason when `target` reverts.
116      *
117      * _Available since v3.1._
118      */
119     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, 0, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
125      * but also transferring `value` wei to `target`.
126      *
127      * Requirements:
128      *
129      * - the calling contract must have an ETH balance of at least `value`.
130      * - the called Solidity function must be `payable`.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
140      * with `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
145         require(address(this).balance >= value, "Address: insufficient balance for call");
146         require(isContract(target), "Address: call to non-contract");
147 
148         // solhint-disable-next-line avoid-low-level-calls
149         (bool success, bytes memory returndata) = target.call{ value: value }(data);
150         return _verifyCallResult(success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
160         return functionStaticCall(target, data, "Address: low-level static call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
170         require(isContract(target), "Address: static call to non-contract");
171 
172         // solhint-disable-next-line avoid-low-level-calls
173         (bool success, bytes memory returndata) = target.staticcall(data);
174         return _verifyCallResult(success, returndata, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
184         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
189      * but performing a delegate call.
190      *
191      * _Available since v3.4._
192      */
193     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         // solhint-disable-next-line avoid-low-level-calls
197         (bool success, bytes memory returndata) = target.delegatecall(data);
198         return _verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
202         if (success) {
203             return returndata;
204         } else {
205             // Look for revert reason and bubble it up if present
206             if (returndata.length > 0) {
207                 // The easiest way to bubble the revert reason is using memory via assembly
208 
209                 // solhint-disable-next-line no-inline-assembly
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 /*
222  * @dev Provides information about the current execution context, including the
223  * sender of the transaction and its data. While these are generally available
224  * via msg.sender and msg.data, they should not be accessed in such a direct
225  * manner, since when dealing with meta-transactions the account sending and
226  * paying for execution may not be the actual sender (as far as an application
227  * is concerned).
228  *
229  * This contract is only required for intermediate, library-like contracts.
230  */
231 abstract contract Context {
232     function _msgSender() internal view virtual returns (address) {
233         return msg.sender;
234     }
235 
236     function _msgData() internal view virtual returns (bytes calldata) {
237         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
238         return msg.data;
239     }
240 }
241 
242 
243 /**
244  * @dev String operations.
245  */
246 library Strings {
247     bytes16 private constant alphabet = "0123456789abcdef";
248 
249     /**
250      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
251      */
252     function toString(uint256 value) internal pure returns (string memory) {
253         // Inspired by OraclizeAPI's implementation - MIT licence
254         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
255 
256         if (value == 0) {
257             return "0";
258         }
259         uint256 temp = value;
260         uint256 digits;
261         while (temp != 0) {
262             digits++;
263             temp /= 10;
264         }
265         bytes memory buffer = new bytes(digits);
266         while (value != 0) {
267             digits -= 1;
268             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
269             value /= 10;
270         }
271         return string(buffer);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
276      */
277     function toHexString(uint256 value) internal pure returns (string memory) {
278         if (value == 0) {
279             return "0x00";
280         }
281         uint256 temp = value;
282         uint256 length = 0;
283         while (temp != 0) {
284             length++;
285             temp >>= 8;
286         }
287         return toHexString(value, length);
288     }
289 
290     /**
291      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
292      */
293     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
294         bytes memory buffer = new bytes(2 * length + 2);
295         buffer[0] = "0";
296         buffer[1] = "x";
297         for (uint256 i = 2 * length + 1; i > 1; --i) {
298             buffer[i] = alphabet[value & 0xf];
299             value >>= 4;
300         }
301         require(value == 0, "Strings: hex length insufficient");
302         return string(buffer);
303     }
304 
305 }
306 
307 /**
308  * @dev Interface of the ERC165 standard, as defined in the
309  * https://eips.ethereum.org/EIPS/eip-165[EIP].
310  *
311  * Implementers can declare support of contract interfaces, which can then be
312  * queried by others ({ERC165Checker}).
313  *
314  * For an implementation, see {ERC165}.
315  */
316 interface IERC165 {
317     /**
318      * @dev Returns true if this contract implements the interface defined by
319      * `interfaceId`. See the corresponding
320      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
321      * to learn more about how these ids are created.
322      *
323      * This function call must use less than 30 000 gas.
324      */
325     function supportsInterface(bytes4 interfaceId) external view returns (bool);
326 }
327 
328 /**
329  * @dev Required interface of an ERC721 compliant contract.
330  */
331 interface IERC721 is IERC165 {
332     /**
333      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
334      */
335     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
339      */
340     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
341 
342     /**
343      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
344      */
345     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
346 
347     /**
348      * @dev Returns the number of tokens in ``owner``'s account.
349      */
350     function balanceOf(address owner) external view returns (uint256 balance);
351 
352     /**
353      * @dev Returns the owner of the `tokenId` token.
354      *
355      * Requirements:
356      *
357      * - `tokenId` must exist.
358      */
359     function ownerOf(uint256 tokenId) external view returns (address owner);
360 
361     /**
362      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
363      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
364      *
365      * Requirements:
366      *
367      * - `from` cannot be the zero address.
368      * - `to` cannot be the zero address.
369      * - `tokenId` token must exist and be owned by `from`.
370      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
371      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
372      *
373      * Emits a {Transfer} event.
374      */
375     function safeTransferFrom(
376         address from,
377         address to,
378         uint256 tokenId
379     ) external;
380 
381     /**
382      * @dev Transfers `tokenId` token from `from` to `to`.
383      *
384      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
385      *
386      * Requirements:
387      *
388      * - `from` cannot be the zero address.
389      * - `to` cannot be the zero address.
390      * - `tokenId` token must be owned by `from`.
391      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transferFrom(
396         address from,
397         address to,
398         uint256 tokenId
399     ) external;
400 
401     /**
402      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
403      * The approval is cleared when the token is transferred.
404      *
405      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
406      *
407      * Requirements:
408      *
409      * - The caller must own the token or be an approved operator.
410      * - `tokenId` must exist.
411      *
412      * Emits an {Approval} event.
413      */
414     function approve(address to, uint256 tokenId) external;
415 
416     /**
417      * @dev Returns the account approved for `tokenId` token.
418      *
419      * Requirements:
420      *
421      * - `tokenId` must exist.
422      */
423     function getApproved(uint256 tokenId) external view returns (address operator);
424 
425     /**
426      * @dev Approve or remove `operator` as an operator for the caller.
427      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
428      *
429      * Requirements:
430      *
431      * - The `operator` cannot be the caller.
432      *
433      * Emits an {ApprovalForAll} event.
434      */
435     function setApprovalForAll(address operator, bool _approved) external;
436 
437     /**
438      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
439      *
440      * See {setApprovalForAll}
441      */
442     function isApprovedForAll(address owner, address operator) external view returns (bool);
443 
444     /**
445      * @dev Safely transfers `tokenId` token from `from` to `to`.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId,
461         bytes calldata data
462     ) external;
463 }
464 
465 
466 /**
467  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
468  * @dev See https://eips.ethereum.org/EIPS/eip-721
469  */
470 interface IERC721Metadata is IERC721 {
471     /**
472      * @dev Returns the token collection name.
473      */
474     function name() external view returns (string memory);
475 
476     /**
477      * @dev Returns the token collection symbol.
478      */
479     function symbol() external view returns (string memory);
480 
481     /**
482      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
483      */
484     function tokenURI(uint256 tokenId) external view returns (string memory);
485 }
486 
487 /**
488  * @title ERC721 token receiver interface
489  * @dev Interface for any contract that wants to support safeTransfers
490  * from ERC721 asset contracts.
491  */
492 interface IERC721Receiver {
493     /**
494      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
495      * by `operator` from `from`, this function is called.
496      *
497      * It must return its Solidity selector to confirm the token transfer.
498      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
499      *
500      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
501      */
502     function onERC721Received(
503         address operator,
504         address from,
505         uint256 tokenId,
506         bytes calldata data
507     ) external returns (bytes4);
508 }
509 
510 
511 /**
512  * @dev Implementation of the {IERC165} interface.
513  *
514  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
515  * for the additional interface id that will be supported. For example:
516  *
517  * ```solidity
518  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
519  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
520  * }
521  * ```
522  *
523  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
524  */
525 abstract contract ERC165 is IERC165 {
526     /**
527      * @dev See {IERC165-supportsInterface}.
528      */
529     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530         return interfaceId == type(IERC165).interfaceId;
531     }
532 }
533 
534 /**
535  * @dev Implementation of the {IERC721Receiver} interface.
536  *
537  * Accepts all token transfers.
538  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
539  */
540 contract ERC721Holder is IERC721Receiver {
541     /**
542      * @dev See {IERC721Receiver-onERC721Received}.
543      *
544      * Always returns `IERC721Receiver.onERC721Received.selector`.
545      */
546     function onERC721Received(
547         address,
548         address,
549         uint256,
550         bytes memory
551     ) public virtual override returns (bytes4) {
552         return this.onERC721Received.selector;
553     }
554 }
555 
556 /**
557  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
558  * the Metadata extension, but not including the Enumerable extension, which is available separately as
559  * {ERC721Enumerable}.
560  */
561 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, ERC721Holder {
562     using Address for address;
563     using Strings for uint256;
564 
565     // Token name
566     string private _name;
567 
568     // Token symbol
569     string private _symbol;
570 
571     // Supply of token.
572     uint256 public totalSupply;    
573 
574     // Mapping from token ID to owner address
575     mapping(uint256 => address) private _owners;
576 
577     // Mapping owner address to token count
578     mapping(address => uint256) private _balances;
579 
580     // Mapping from token ID to approved address
581     mapping(uint256 => address) private _tokenApprovals;
582 
583     // Mapping from owner to operator approvals
584     mapping(address => mapping(address => bool)) private _operatorApprovals;
585 
586     /**
587      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
588      */
589     constructor(string memory name_, string memory symbol_) {
590         _name = name_;
591         _symbol = symbol_;
592     }
593 
594     /**
595      * @dev See {IERC165-supportsInterface}.
596      */
597     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
598         return
599             interfaceId == type(IERC721).interfaceId ||
600             interfaceId == type(IERC721Metadata).interfaceId ||
601             super.supportsInterface(interfaceId);
602     }
603 
604     /**
605      * @dev See {IERC721-balanceOf}.
606      */
607     function balanceOf(address owner) public view virtual override returns (uint256) {
608         require(owner != address(0), "ERC721: balance query for the zero address");
609         return _balances[owner];
610     }
611 
612     /**
613      * @dev See {IERC721-ownerOf}.
614      */
615     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
616         address owner = _owners[tokenId];
617         require(owner != address(0), "ERC721: owner query for nonexistent token");
618         return owner;
619     }
620 
621     /**
622      * @dev See {IERC721Metadata-name}.
623      */
624     function name() public view virtual override returns (string memory) {
625         return _name;
626     }
627 
628     /**
629      * @dev See {IERC721Metadata-symbol}.
630      */
631     function symbol() public view virtual override returns (string memory) {
632         return _symbol;
633     }
634 
635     /**
636      * @dev See {IERC721Metadata-tokenURI}.
637      */
638     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
639         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
640 
641         string memory baseURI = _baseURI();
642         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
643     }
644 
645     /**
646      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
647      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
648      * by default, can be overriden in child contracts.
649      */
650     function _baseURI() internal view virtual returns (string memory) {
651         return "";
652     }
653 
654     /**
655      * @dev See {IERC721-approve}.
656      */
657     function approve(address to, uint256 tokenId) public virtual override {
658         address owner = ERC721.ownerOf(tokenId);
659         require(to != owner, "ERC721: approval to current owner");
660 
661         require(
662             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
663             "ERC721: approve caller is not owner nor approved for all"
664         );
665 
666         _approve(to, tokenId);
667     }
668 
669     /**
670      * @dev See {IERC721-getApproved}.
671      */
672     function getApproved(uint256 tokenId) public view virtual override returns (address) {
673         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
674 
675         return _tokenApprovals[tokenId];
676     }
677 
678     /**
679      * @dev See {IERC721-setApprovalForAll}.
680      */
681     function setApprovalForAll(address operator, bool approved) public virtual override {
682         require(operator != _msgSender(), "ERC721: approve to caller");
683 
684         _operatorApprovals[_msgSender()][operator] = approved;
685         emit ApprovalForAll(_msgSender(), operator, approved);
686     }
687 
688     /**
689      * @dev See {IERC721-isApprovedForAll}.
690      */
691     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
692         return _operatorApprovals[owner][operator];
693     }
694 
695     /**
696      * @dev See {IERC721-transferFrom}.
697      */
698     function transferFrom(
699         address from,
700         address to,
701         uint256 tokenId
702     ) public virtual override {
703         //solhint-disable-next-line max-line-length
704         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
705 
706         _transfer(from, to, tokenId);
707     }
708 
709     /**
710      * @dev See {IERC721-safeTransferFrom}.
711      */
712     function safeTransferFrom(
713         address from,
714         address to,
715         uint256 tokenId
716     ) public virtual override {
717         safeTransferFrom(from, to, tokenId, "");
718     }
719 
720     /**
721      * @dev See {IERC721-safeTransferFrom}.
722      */
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 tokenId,
727         bytes memory _data
728     ) public virtual override {
729         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
730         _safeTransfer(from, to, tokenId, _data);
731     }
732 
733     /**
734      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
735      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
736      *
737      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
738      *
739      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
740      * implement alternative mechanisms to perform token transfer, such as signature-based.
741      *
742      * Requirements:
743      *
744      * - `from` cannot be the zero address.
745      * - `to` cannot be the zero address.
746      * - `tokenId` token must exist and be owned by `from`.
747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748      *
749      * Emits a {Transfer} event.
750      */
751     function _safeTransfer(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes memory _data
756     ) internal virtual {
757         _transfer(from, to, tokenId);
758         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
759     }
760 
761     /**
762      * @dev Returns whether `tokenId` exists.
763      *
764      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
765      *
766      * Tokens start existing when they are minted (`_mint`),
767      * and stop existing when they are burned (`_burn`).
768      */
769     function _exists(uint256 tokenId) internal view virtual returns (bool) {
770         return _owners[tokenId] != address(0);
771     }
772 
773     /**
774      * @dev Returns whether `spender` is allowed to manage `tokenId`.
775      *
776      * Requirements:
777      *
778      * - `tokenId` must exist.
779      */
780     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
781         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
782         address owner = ERC721.ownerOf(tokenId);
783         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
784     }
785 
786     /**
787      * @dev Safely mints `tokenId` and transfers it to `to`.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must not exist.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _safeMint(address to, uint256 tokenId) internal virtual {
797         _safeMint(to, tokenId, "");
798     }
799 
800     /**
801      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
802      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
803      */
804     function _safeMint(
805         address to,
806         uint256 tokenId,
807         bytes memory _data
808     ) internal virtual {
809         _mint(to, tokenId);
810         require(
811             _checkOnERC721Received(address(0), to, tokenId, _data),
812             "ERC721: transfer to non ERC721Receiver implementer"
813         );
814     }
815 
816     /**
817      * @dev Mints `tokenId` and transfers it to `to`.
818      *
819      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
820      *
821      * Requirements:
822      *
823      * - `tokenId` must not exist.
824      * - `to` cannot be the zero address.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _mint(address to, uint256 tokenId) internal virtual {
829         uint256[] memory ids = new uint256[](1);
830         ids[0] = tokenId;
831         _mintNFTs(to, ids);
832     }
833 
834     function _mintNFTs(address to, uint256[] memory tokenIds) internal virtual {
835         require(to != address(0), "ERC721: mint to the zero address");
836 
837         uint256 _totalSupply = totalSupply;
838         uint256 _length = tokenIds.length;
839 
840         totalSupply = _totalSupply + _length;
841         _balances[to] += _length;
842         
843         for (uint256 i; i < _length; ++i) {
844             uint256 tokenId = tokenIds[i];
845             require(!_exists(tokenId), "ERC721: token already minted");
846             _beforeTokenTransfer(address(0), to, tokenId);
847 
848             _owners[tokenId] = to;
849             emit Transfer(address(0), to, tokenId);
850         }
851     }
852 
853     /**
854      * @dev Destroys `tokenId`.
855      * The approval is cleared when the token is burned.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _burn(uint256 tokenId) internal virtual {
864         address owner = ERC721.ownerOf(tokenId);
865 
866         _beforeTokenTransfer(owner, address(0), tokenId);
867 
868         // Clear approvals
869         _approve(address(0), tokenId);
870 
871         _balances[owner] -= 1;
872         delete _owners[tokenId];
873 
874         emit Transfer(owner, address(0), tokenId);
875     }
876 
877     /**
878      * @dev Transfers `tokenId` from `from` to `to`.
879      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
880      *
881      * Requirements:
882      *
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must be owned by `from`.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _transfer(
889         address from,
890         address to,
891         uint256 tokenId
892     ) internal virtual {
893         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
894         require(to != address(0), "ERC721: transfer to the zero address");
895 
896         _beforeTokenTransfer(from, to, tokenId);
897 
898         // Clear approvals from the previous owner
899         _approve(address(0), tokenId);
900 
901         _balances[from] -= 1;
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev Approve `to` to operate on `tokenId`
910      *
911      * Emits a {Approval} event.
912      */
913     function _approve(address to, uint256 tokenId) internal virtual {
914         _tokenApprovals[tokenId] = to;
915         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
916     }
917 
918     /**
919      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
920      * The call is not executed if the target address is not a contract.
921      *
922      * @param from address representing the previous owner of the given token ID
923      * @param to target address that will receive the tokens
924      * @param tokenId uint256 ID of the token to be transferred
925      * @param _data bytes optional data to send along with the call
926      * @return bool whether the call correctly returned the expected magic value
927      */
928     function _checkOnERC721Received(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) private returns (bool) {
934         if (to.isContract()) {
935             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
936                 return retval == IERC721Receiver.onERC721Received.selector;
937             } catch (bytes memory reason) {
938                 if (reason.length == 0) {
939                     revert("ERC721: transfer to non ERC721Receiver implementer");
940                 } else {
941                     assembly {
942                         revert(add(32, reason), mload(reason))
943                     }
944                 }
945             }
946         } else {
947             return true;
948         }
949     }
950 
951     /**
952      * @dev Hook that is called before any token transfer. This includes minting
953      * and burning.
954      *
955      * Calling conditions:
956      *
957      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
958      * transferred to `to`.
959      * - When `from` is zero, `tokenId` will be minted for `to`.
960      * - When `to` is zero, ``from``'s `tokenId` will be burned.
961      * - `from` and `to` are never both zero.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _beforeTokenTransfer(
966         address from,
967         address to,
968         uint256 tokenId
969     ) internal virtual {}
970 }
971 
972 /**
973  * @dev Contract module which provides a basic access control mechanism, where
974  * there is an account (an owner) that can be granted exclusive access to
975  * specific functions.
976  *
977  * By default, the owner account will be the one that deploys the contract. This
978  * can later be changed with {transferOwnership}.
979  *
980  * This module is used through inheritance. It will make available the modifier
981  * `onlyOwner`, which can be applied to your functions to restrict their use to
982  * the owner.
983  */
984 abstract contract Ownable is Context {
985     address private _owner;
986 
987     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
988 
989     /**
990      * @dev Initializes the contract setting the deployer as the initial owner.
991      */
992     constructor() {
993         address msgSender = _msgSender();
994         _owner = msgSender;
995         emit OwnershipTransferred(address(0), msgSender);
996     }
997 
998     /**
999      * @dev Returns the address of the current owner.
1000      */
1001     function owner() public view virtual returns (address) {
1002         return _owner;
1003     }
1004 
1005     /**
1006      * @dev Throws if called by any account other than the owner.
1007      */
1008     modifier onlyOwner() {
1009         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1010         _;
1011     }
1012 
1013     /**
1014      * @dev Leaves the contract without owner. It will not be possible to call
1015      * `onlyOwner` functions anymore. Can only be called by the current owner.
1016      *
1017      * NOTE: Renouncing ownership will leave the contract without an owner,
1018      * thereby removing any functionality that is only available to the owner.
1019      */
1020     function renounceOwnership() public virtual onlyOwner {
1021         emit OwnershipTransferred(_owner, address(0));
1022         _owner = address(0);
1023     }
1024 
1025     /**
1026      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1027      * Can only be called by the current owner.
1028      */
1029     function transferOwnership(address newOwner) public virtual onlyOwner {
1030         require(newOwner != address(0), "Ownable: new owner is the zero address");
1031         emit OwnershipTransferred(_owner, newOwner);
1032         _owner = newOwner;
1033     }
1034 }
1035 
1036 interface IGetRoyalties {
1037   function getRoyalties(uint256 tokenId)
1038     external
1039     view
1040     returns (address payable[] memory recipients, uint256[] memory feesInBasisPoints);
1041 }
1042 
1043 /**
1044  * @notice An interface for communicating fees to 3rd party marketplaces.
1045  * @dev Originally implemented in mainnet contract 0x44d6e8933f8271abcf253c72f9ed7e0e4c0323b3
1046  */
1047 interface IGetFees {
1048   function getFeeRecipients(uint256 id) external view returns (address payable[] memory);
1049 
1050   function getFeeBps(uint256 id) external view returns (uint256[] memory);
1051 }
1052 
1053 interface ITokenCreator {
1054   function tokenCreator(uint256 tokenId) external view returns (address payable);
1055 }
1056 
1057 interface ITokenCreatorPaymentAddress {
1058   function getTokenCreatorPaymentAddress(uint256 tokenId)
1059     external
1060     view
1061     returns (address payable tokenCreatorPaymentAddress);
1062 }
1063 
1064 contract KillerGF is Ownable, IGetRoyalties, IGetFees, ITokenCreator, ITokenCreatorPaymentAddress, ERC721 {
1065   uint256 public immutable MAX_SUPPLY;
1066 
1067   address public saleContract;
1068 
1069   string public baseURI;
1070 
1071   /**
1072    * @dev Stores an optional alternate address to receive creator revenue and royalty payments.
1073    * The target address may be a contract which could split or escrow payments.
1074    */
1075   address payable private _creatorPaymentAddress;
1076   address payable private _tokenCreator;
1077 
1078   uint256 private _royaltyInBasisPoints = 300;
1079 
1080   constructor(string memory _name, string memory _symbol, uint256 maxSupply) Ownable() ERC721(_name, _symbol) {
1081     MAX_SUPPLY = maxSupply;
1082   }
1083 
1084   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1085     if (
1086       interfaceId == type(IGetRoyalties).interfaceId ||
1087       interfaceId == type(ITokenCreator).interfaceId ||
1088       interfaceId == type(ITokenCreatorPaymentAddress).interfaceId ||
1089       interfaceId == type(IGetFees).interfaceId
1090     ) {
1091       return true;
1092     }
1093     return super.supportsInterface(interfaceId);
1094   }
1095 
1096   function mintNFTs(address to, uint256[] memory tokenIds) public virtual {
1097     require(msg.sender == saleContract, "Nice try lol");
1098     uint256 length = tokenIds.length;
1099     for (uint256 i; i < length; ++i) {
1100       require(tokenIds[i] != 0 && tokenIds[i] <= MAX_SUPPLY, "ID > MAX_SUPPLY");
1101     }
1102     _mintNFTs(to, tokenIds);
1103   }
1104 
1105   function prepareSale(address _saleContract) public onlyOwner {
1106     require(saleContract == address(0), "Immutable");
1107     saleContract = _saleContract;
1108   }
1109 
1110   function renounceMinting() public onlyOwner {
1111     saleContract = 0x000000000000000000000000000000000000dEaD;
1112   }
1113 
1114   function setTokenCreator(address payable newCreator) external onlyOwner {
1115     _tokenCreator = newCreator;
1116   }
1117 
1118   function setTokenCreatorPaymentAddress(address payable tokenCreatorPaymentAddress) external onlyOwner {
1119     _creatorPaymentAddress = tokenCreatorPaymentAddress;
1120   }
1121 
1122   function setRoyaltyInBasisPoints(uint256 royaltyInBasisPoints) external onlyOwner {
1123     _royaltyInBasisPoints = royaltyInBasisPoints;
1124   }
1125 
1126   function setBaseURI(string memory newURI) public onlyOwner {
1127     baseURI = newURI;
1128   }
1129 
1130   function _baseURI() internal view virtual override returns (string memory) {
1131     return baseURI;
1132   }
1133 
1134   /**
1135    * @notice Returns an array of recipient addresses to which royalties for secondary sales should be sent.
1136    * The expected royalty amount is communicated with `getFeeBps`.
1137    */
1138   function getFeeRecipients(uint256 /*id*/) external view returns (address payable[] memory recipients) {
1139     recipients = new address payable[](1);
1140     recipients[0] = _creatorPaymentAddress;
1141   }
1142 
1143   /**
1144    * @notice Returns an array of royalties to be sent for secondary sales in basis points.
1145    * The expected recipients is communicated with `getFeeRecipients`.
1146    */
1147   function getFeeBps(
1148     uint256 /* id */
1149   ) external view returns (uint256[] memory feesInBasisPoints) {
1150     feesInBasisPoints = new uint256[](1);
1151     feesInBasisPoints[0] = _royaltyInBasisPoints;
1152   }
1153 
1154   /**
1155    * @notice Returns an array of royalties to be sent for secondary sales.
1156    */
1157   function getRoyalties(uint256 /*tokenId*/)
1158     external
1159     view
1160     returns (address payable[] memory recipients, uint256[] memory feesInBasisPoints)
1161   {
1162     recipients = new address payable[](1);
1163     recipients[0] = _creatorPaymentAddress;
1164     feesInBasisPoints = new uint256[](1);
1165     feesInBasisPoints[0] = _royaltyInBasisPoints;
1166   }
1167 
1168   /**
1169    * @notice Returns the creator for an NFT, which is always the collection owner.
1170    */
1171   function tokenCreator(
1172     uint256 /* tokenId */
1173   ) external view returns (address payable) {
1174     return _tokenCreator;
1175   }
1176 
1177   /**
1178    * @notice Returns the desired payment address to be used for any transfers to the creator.
1179    * @dev The payment address may be assigned for each individual NFT, if not defined the collection owner is returned.
1180    */
1181   function getTokenCreatorPaymentAddress(uint256 /* tokenId */)
1182     public
1183     view
1184     returns (address payable)
1185   {
1186     return _creatorPaymentAddress;
1187   }
1188 }