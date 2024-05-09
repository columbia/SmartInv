1 /**
2                                                                                           
3                                                                                           
4                                  --=-.                                                    
5                        -++=:    #:..:=+-      .                                           
6                      ++-...=+.  #.    .=+   -*=*:        .:   -+===                       
7                    .*:. ....:*- +-.    .:#. #:=:#.      ++:*-:*..-:*:                     
8                    #:.  ......*: #:.    .:*:* --:*     +=.:.#=#..:-:#.                    
9                   +=.   .:-:..:# .#:..  ..-#+  ..#    :*. +.-+#: .=:-+   .==-=+           
10                   %:.   -.=....-+==........*+ ...*.   #. +-..#-+  .-:#  +=....+-          
11                   #.   ::=**....*=*:-:.....::....*:  +- =%:..*.#. ...# ====-=-:           
12                   #.   -:# +-...:*:* .:-....*....#. :* .#*:..=-+-  .-+ ++.                
13                   %.   =*:.=*.:-.#-*  :++:..=:...#=+=.:.:::..-+:*  :#*++==+=:             
14                 -==...:-+==:...::=*#   .##:.....:*+-.:-.::-..:* # .=-.......==            
15                +=.........:+*....-#*   :*.#.  ..+=#. ..=+#- .:# #..:........:*            
16                *=---....=+-.#....-*#  .== .#. .:#*:  ..#.#. .:#.#.::=========             
17                  .:#. =.#  .#....+-#. .#   :*..+-#:..:*::*  .-*.#=+=.:----.               
18                   *-  =.#  :*....#.%..-*    +=::#.====  *-  .+:   -==:.  .*:              
19    ===---+==     .#.  =.+- -+.::== #.:#.    .#:+*       %.  :#   **===--===               
20   +=   .:-==#-   +=.  =.-+ -+::-*  %:*-     .*+         #: :*.                            
21    :----:.       #.   =.=+ -+.=+   =+:                   ==-              .=*%#*+:        
22        =----=--. #:...-.*:  ++:                                     :--=*%#=:        --   
23       -+---==--=  -=#:.:*                                     .     +@@@*:.      .:+%@@-  
24         .           .+==.:.     +*                           *@@@%#+=:.-+*%%%%%%%%*=:=@:  
25                     :=*#@@%    #@%          .:    -=*####*+:  *@#-=+@@-             :@#   
26              .-+*%@@@@@@@@*  =@@@+#%%#**+*#%@@:  @%-:          +@#-#@+           .-#@+    
27           :+%@@#*++==+*#*= =%@@@- :::-=+++@@%:   +@-            #@@@*-.      =#%@%*-      
28         .#@+: .-=++*+   -*@**@@-       .+@%-      %@::--==++=   .@@*=*@%=     .-.         
29        :@#. -=-=+#%+:=#%*-:=@@:      :*@%-        :@@**+++=-.    +@#   -#@%##%%=          
30       .@@=+*#%#*+++#@@%##*+@@-:++  -#@%-         -.%@            -@@      :::.            
31        ++=-::=+++=-.    .:%@#+=:.+@@*:          :@*%@.    ..-++  .%*                      
32            .-.           :@@. :*@%=            -@@%@#+#%%%##*=                            
33                          :@% #@@@**+==-:::::=*@@*#@#+:                                    
34                           :. ==----=+*##%%%%#+-                                           
35                                                                                           
36                                                                                           
37 
38 */
39 
40 // SPDX-License-Identifier: MIT
41 
42 
43 
44 // File: @openzeppelin/contracts/utils/Strings.sol
45 
46 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev String operations.
52  */
53 library Strings {
54     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
58      */
59     function toString(uint256 value) internal pure returns (string memory) {
60         // Inspired by OraclizeAPI's implementation - MIT licence
61         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
62 
63         if (value == 0) {
64             return "0";
65         }
66         uint256 temp = value;
67         uint256 digits;
68         while (temp != 0) {
69             digits++;
70             temp /= 10;
71         }
72         bytes memory buffer = new bytes(digits);
73         while (value != 0) {
74             digits -= 1;
75             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
76             value /= 10;
77         }
78         return string(buffer);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
83      */
84     function toHexString(uint256 value) internal pure returns (string memory) {
85         if (value == 0) {
86             return "0x00";
87         }
88         uint256 temp = value;
89         uint256 length = 0;
90         while (temp != 0) {
91             length++;
92             temp >>= 8;
93         }
94         return toHexString(value, length);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
99      */
100     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
101         bytes memory buffer = new bytes(2 * length + 2);
102         buffer[0] = "0";
103         buffer[1] = "x";
104         for (uint256 i = 2 * length + 1; i > 1; --i) {
105             buffer[i] = _HEX_SYMBOLS[value & 0xf];
106             value >>= 4;
107         }
108         require(value == 0, "Strings: hex length insufficient");
109         return string(buffer);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Context.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Provides information about the current execution context, including the
122  * sender of the transaction and its data. While these are generally available
123  * via msg.sender and msg.data, they should not be accessed in such a direct
124  * manner, since when dealing with meta-transactions the account sending and
125  * paying for execution may not be the actual sender (as far as an application
126  * is concerned).
127  *
128  * This contract is only required for intermediate, library-like contracts.
129  */
130 abstract contract Context {
131     function _msgSender() internal view virtual returns (address) {
132         return msg.sender;
133     }
134 
135     function _msgData() internal view virtual returns (bytes calldata) {
136         return msg.data;
137     }
138 }
139 
140 // File: @openzeppelin/contracts/utils/Address.sol
141 
142 
143 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
144 
145 pragma solidity ^0.8.1;
146 
147 /**
148  * @dev Collection of functions related to the address type
149  */
150 library Address {
151     /**
152      * @dev Returns true if `account` is a contract.
153      *
154      * [IMPORTANT]
155      * ====
156      * It is unsafe to assume that an address for which this function returns
157      * false is an externally-owned account (EOA) and not a contract.
158      *
159      * Among others, `isContract` will return false for the following
160      * types of addresses:
161      *
162      *  - an externally-owned account
163      *  - a contract in construction
164      *  - an address where a contract will be created
165      *  - an address where a contract lived, but was destroyed
166      * ====
167      *
168      * [IMPORTANT]
169      * ====
170      * You shouldn't rely on `isContract` to protect against flash loan attacks!
171      *
172      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
173      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
174      * constructor.
175      * ====
176      */
177     function isContract(address account) internal view returns (bool) {
178         // This method relies on extcodesize/address.code.length, which returns 0
179         // for contracts in construction, since the code is only stored at the end
180         // of the constructor execution.
181 
182         return account.code.length > 0;
183     }
184 
185     /**
186      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
187      * `recipient`, forwarding all available gas and reverting on errors.
188      *
189      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
190      * of certain opcodes, possibly making contracts go over the 2300 gas limit
191      * imposed by `transfer`, making them unable to receive funds via
192      * `transfer`. {sendValue} removes this limitation.
193      *
194      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
195      *
196      * IMPORTANT: because control is transferred to `recipient`, care must be
197      * taken to not create reentrancy vulnerabilities. Consider using
198      * {ReentrancyGuard} or the
199      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
200      */
201     function sendValue(address payable recipient, uint256 amount) internal {
202         require(address(this).balance >= amount, "Address: insufficient balance");
203 
204         (bool success, ) = recipient.call{value: amount}("");
205         require(success, "Address: unable to send value, recipient may have reverted");
206     }
207 
208     /**
209      * @dev Performs a Solidity function call using a low level `call`. A
210      * plain `call` is an unsafe replacement for a function call: use this
211      * function instead.
212      *
213      * If `target` reverts with a revert reason, it is bubbled up by this
214      * function (like regular Solidity function calls).
215      *
216      * Returns the raw returned data. To convert to the expected return value,
217      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
218      *
219      * Requirements:
220      *
221      * - `target` must be a contract.
222      * - calling `target` with `data` must not revert.
223      *
224      * _Available since v3.1._
225      */
226     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
227         return functionCall(target, data, "Address: low-level call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
232      * `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         return functionCallWithValue(target, data, 0, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but also transferring `value` wei to `target`.
247      *
248      * Requirements:
249      *
250      * - the calling contract must have an ETH balance of at least `value`.
251      * - the called Solidity function must be `payable`.
252      *
253      * _Available since v3.1._
254      */
255     function functionCallWithValue(
256         address target,
257         bytes memory data,
258         uint256 value
259     ) internal returns (bytes memory) {
260         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
265      * with `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(
270         address target,
271         bytes memory data,
272         uint256 value,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(address(this).balance >= value, "Address: insufficient balance for call");
276         require(isContract(target), "Address: call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.call{value: value}(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a static call.
285      *
286      * _Available since v3.3._
287      */
288     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
289         return functionStaticCall(target, data, "Address: low-level static call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a static call.
295      *
296      * _Available since v3.3._
297      */
298     function functionStaticCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal view returns (bytes memory) {
303         require(isContract(target), "Address: static call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.staticcall(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but performing a delegate call.
312      *
313      * _Available since v3.4._
314      */
315     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
321      * but performing a delegate call.
322      *
323      * _Available since v3.4._
324      */
325     function functionDelegateCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         require(isContract(target), "Address: delegate call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.delegatecall(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
338      * revert reason using the provided one.
339      *
340      * _Available since v4.3._
341      */
342     function verifyCallResult(
343         bool success,
344         bytes memory returndata,
345         string memory errorMessage
346     ) internal pure returns (bytes memory) {
347         if (success) {
348             return returndata;
349         } else {
350             // Look for revert reason and bubble it up if present
351             if (returndata.length > 0) {
352                 // The easiest way to bubble the revert reason is using memory via assembly
353 
354                 assembly {
355                     let returndata_size := mload(returndata)
356                     revert(add(32, returndata), returndata_size)
357                 }
358             } else {
359                 revert(errorMessage);
360             }
361         }
362     }
363 }
364 
365 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @title ERC721 token receiver interface
374  * @dev Interface for any contract that wants to support safeTransfers
375  * from ERC721 asset contracts.
376  */
377 interface IERC721Receiver {
378     /**
379      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
380      * by `operator` from `from`, this function is called.
381      *
382      * It must return its Solidity selector to confirm the token transfer.
383      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
384      *
385      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
386      */
387     function onERC721Received(
388         address operator,
389         address from,
390         uint256 tokenId,
391         bytes calldata data
392     ) external returns (bytes4);
393 }
394 
395 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @dev Interface of the ERC165 standard, as defined in the
404  * https://eips.ethereum.org/EIPS/eip-165[EIP].
405  *
406  * Implementers can declare support of contract interfaces, which can then be
407  * queried by others ({ERC165Checker}).
408  *
409  * For an implementation, see {ERC165}.
410  */
411 interface IERC165 {
412     /**
413      * @dev Returns true if this contract implements the interface defined by
414      * `interfaceId`. See the corresponding
415      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
416      * to learn more about how these ids are created.
417      *
418      * This function call must use less than 30 000 gas.
419      */
420     function supportsInterface(bytes4 interfaceId) external view returns (bool);
421 }
422 
423 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
427 
428 pragma solidity ^0.8.0;
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
457 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev Required interface of an ERC721 compliant contract.
464  */
465 interface IERC721 is IERC165 {
466     /**
467      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
468      */
469     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
470 
471     /**
472      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
473      */
474     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
475 
476     /**
477      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
478      */
479     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
480 
481     /**
482      * @dev Returns the number of tokens in ``owner``'s account.
483      */
484     function balanceOf(address owner) external view returns (uint256 balance);
485 
486     /**
487      * @dev Returns the owner of the `tokenId` token.
488      *
489      * Requirements:
490      *
491      * - `tokenId` must exist.
492      */
493     function ownerOf(uint256 tokenId) external view returns (address owner);
494 
495     /**
496      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
497      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Transfers `tokenId` token from `from` to `to`.
517      *
518      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
537      * The approval is cleared when the token is transferred.
538      *
539      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
540      *
541      * Requirements:
542      *
543      * - The caller must own the token or be an approved operator.
544      * - `tokenId` must exist.
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address to, uint256 tokenId) external;
549 
550     /**
551      * @dev Returns the account approved for `tokenId` token.
552      *
553      * Requirements:
554      *
555      * - `tokenId` must exist.
556      */
557     function getApproved(uint256 tokenId) external view returns (address operator);
558 
559     /**
560      * @dev Approve or remove `operator` as an operator for the caller.
561      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
562      *
563      * Requirements:
564      *
565      * - The `operator` cannot be the caller.
566      *
567      * Emits an {ApprovalForAll} event.
568      */
569     function setApprovalForAll(address operator, bool _approved) external;
570 
571     /**
572      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
573      *
574      * See {setApprovalForAll}
575      */
576     function isApprovedForAll(address owner, address operator) external view returns (bool);
577 
578     /**
579      * @dev Safely transfers `tokenId` token from `from` to `to`.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId,
595         bytes calldata data
596     ) external;
597 }
598 
599 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
609  * @dev See https://eips.ethereum.org/EIPS/eip-721
610  */
611 interface IERC721Metadata is IERC721 {
612     /**
613      * @dev Returns the token collection name.
614      */
615     function name() external view returns (string memory);
616 
617     /**
618      * @dev Returns the token collection symbol.
619      */
620     function symbol() external view returns (string memory);
621 
622     /**
623      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
624      */
625     function tokenURI(uint256 tokenId) external view returns (string memory);
626 }
627 
628 // File: contracts/new.sol
629 
630 
631 
632 
633 pragma solidity ^0.8.4;
634 
635 
636 
637 
638 
639 
640 
641 
642 error ApprovalCallerNotOwnerNorApproved();
643 error ApprovalQueryForNonexistentToken();
644 error ApproveToCaller();
645 error ApprovalToCurrentOwner();
646 error BalanceQueryForZeroAddress();
647 error MintToZeroAddress();
648 error MintZeroQuantity();
649 error OwnerQueryForNonexistentToken();
650 error TransferCallerNotOwnerNorApproved();
651 error TransferFromIncorrectOwner();
652 error TransferToNonERC721ReceiverImplementer();
653 error TransferToZeroAddress();
654 error URIQueryForNonexistentToken();
655 
656 /**
657  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
658  * the Metadata extension. Built to optimize for lower gas during batch mints.
659  *
660  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
661  *
662  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
663  *
664  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
665  */
666 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
667     using Address for address;
668     using Strings for uint256;
669 
670     // Compiler will pack this into a single 256bit word.
671     struct TokenOwnership {
672         // The address of the owner.
673         address addr;
674         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
675         uint64 startTimestamp;
676         // Whether the token has been burned.
677         bool burned;
678     }
679 
680     // Compiler will pack this into a single 256bit word.
681     struct AddressData {
682         // Realistically, 2**64-1 is more than enough.
683         uint64 balance;
684         // Keeps track of mint count with minimal overhead for tokenomics.
685         uint64 numberMinted;
686         // Keeps track of burn count with minimal overhead for tokenomics.
687         uint64 numberBurned;
688         // For miscellaneous variable(s) pertaining to the address
689         // (e.g. number of whitelist mint slots used).
690         // If there are multiple variables, please pack them into a uint64.
691         uint64 aux;
692     }
693 
694     // The tokenId of the next token to be minted.
695     uint256 internal _currentIndex;
696 
697     // The number of tokens burned.
698     uint256 internal _burnCounter;
699 
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Mapping from token ID to ownership details
707     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
708     mapping(uint256 => TokenOwnership) internal _ownerships;
709 
710     // Mapping owner address to address data
711     mapping(address => AddressData) private _addressData;
712 
713     // Mapping from token ID to approved address
714     mapping(uint256 => address) private _tokenApprovals;
715 
716     // Mapping from owner to operator approvals
717     mapping(address => mapping(address => bool)) private _operatorApprovals;
718 
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722         _currentIndex = _startTokenId();
723     }
724 
725     /**
726      * To change the starting tokenId, please override this function.
727      */
728     function _startTokenId() internal view virtual returns (uint256) {
729         return 1;
730     }
731 
732     /**
733      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
734      */
735     function totalSupply() public view returns (uint256) {
736         // Counter underflow is impossible as _burnCounter cannot be incremented
737         // more than _currentIndex - _startTokenId() times
738         unchecked {
739             return _currentIndex - _burnCounter - _startTokenId();
740         }
741     }
742 
743     /**
744      * Returns the total amount of tokens minted in the contract.
745      */
746     function _totalMinted() internal view returns (uint256) {
747         // Counter underflow is impossible as _currentIndex does not decrement,
748         // and it is initialized to _startTokenId()
749         unchecked {
750             return _currentIndex - _startTokenId();
751         }
752     }
753 
754     /**
755      * @dev See {IERC165-supportsInterface}.
756      */
757     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
758         return
759             interfaceId == type(IERC721).interfaceId ||
760             interfaceId == type(IERC721Metadata).interfaceId ||
761             super.supportsInterface(interfaceId);
762     }
763 
764     /**
765      * @dev See {IERC721-balanceOf}.
766      */
767     function balanceOf(address owner) public view override returns (uint256) {
768         if (owner == address(0)) revert BalanceQueryForZeroAddress();
769         return uint256(_addressData[owner].balance);
770     }
771 
772     /**
773      * Returns the number of tokens minted by `owner`.
774      */
775     function _numberMinted(address owner) internal view returns (uint256) {
776         return uint256(_addressData[owner].numberMinted);
777     }
778 
779     /**
780      * Returns the number of tokens burned by or on behalf of `owner`.
781      */
782     function _numberBurned(address owner) internal view returns (uint256) {
783         return uint256(_addressData[owner].numberBurned);
784     }
785 
786     /**
787      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
788      */
789     function _getAux(address owner) internal view returns (uint64) {
790         return _addressData[owner].aux;
791     }
792 
793     /**
794      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
795      * If there are multiple variables, please pack them into a uint64.
796      */
797     function _setAux(address owner, uint64 aux) internal {
798         _addressData[owner].aux = aux;
799     }
800 
801     /**
802      * Gas spent here starts off proportional to the maximum mint batch size.
803      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
804      */
805     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
806         uint256 curr = tokenId;
807 
808         unchecked {
809             if (_startTokenId() <= curr && curr < _currentIndex) {
810                 TokenOwnership memory ownership = _ownerships[curr];
811                 if (!ownership.burned) {
812                     if (ownership.addr != address(0)) {
813                         return ownership;
814                     }
815                     // Invariant:
816                     // There will always be an ownership that has an address and is not burned
817                     // before an ownership that does not have an address and is not burned.
818                     // Hence, curr will not underflow.
819                     while (true) {
820                         curr--;
821                         ownership = _ownerships[curr];
822                         if (ownership.addr != address(0)) {
823                             return ownership;
824                         }
825                     }
826                 }
827             }
828         }
829         revert OwnerQueryForNonexistentToken();
830     }
831 
832     /**
833      * @dev See {IERC721-ownerOf}.
834      */
835     function ownerOf(uint256 tokenId) public view override returns (address) {
836         return _ownershipOf(tokenId).addr;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-name}.
841      */
842     function name() public view virtual override returns (string memory) {
843         return _name;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-symbol}.
848      */
849     function symbol() public view virtual override returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-tokenURI}.
855      */
856     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
857         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
858 
859         string memory baseURI = _baseURI();
860         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
861     }
862 
863     /**
864      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
865      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
866      * by default, can be overriden in child contracts.
867      */
868     function _baseURI() internal view virtual returns (string memory) {
869         return '';
870     }
871 
872     /**
873      * @dev See {IERC721-approve}.
874      */
875     function approve(address to, uint256 tokenId) public override {
876         address owner = ERC721A.ownerOf(tokenId);
877         if (to == owner) revert ApprovalToCurrentOwner();
878 
879         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
880             revert ApprovalCallerNotOwnerNorApproved();
881         }
882 
883         _approve(to, tokenId, owner);
884     }
885 
886     /**
887      * @dev See {IERC721-getApproved}.
888      */
889     function getApproved(uint256 tokenId) public view override returns (address) {
890         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved) public virtual override {
899         if (operator == _msgSender()) revert ApproveToCaller();
900 
901         _operatorApprovals[_msgSender()][operator] = approved;
902         emit ApprovalForAll(_msgSender(), operator, approved);
903     }
904 
905     /**
906      * @dev See {IERC721-isApprovedForAll}.
907      */
908     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
909         return _operatorApprovals[owner][operator];
910     }
911 
912     /**
913      * @dev See {IERC721-transferFrom}.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         _transfer(from, to, tokenId);
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         safeTransferFrom(from, to, tokenId, '');
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) public virtual override {
943         _transfer(from, to, tokenId);
944         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
945             revert TransferToNonERC721ReceiverImplementer();
946         }
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      */
956     function _exists(uint256 tokenId) internal view returns (bool) {
957         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
958             !_ownerships[tokenId].burned;
959     }
960 
961      /**
962      * @dev Returns whether `spender` is allowed to manage `tokenId`.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
969         address owner = ERC721A.ownerOf(tokenId);
970         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
971     }
972 
973     function _safeMint(address to, uint256 quantity) internal {
974         _safeMint(to, quantity, '');
975     }
976 
977     /**
978      * @dev Safely mints `quantity` tokens and transfers them to `to`.
979      *
980      * Requirements:
981      *
982      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
983      * - `quantity` must be greater than 0.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _safeMint(
988         address to,
989         uint256 quantity,
990         bytes memory _data
991     ) internal {
992         _mint(to, quantity, _data, true);
993     }
994 
995     /**
996      * @dev Mints `quantity` tokens and transfers them to `to`.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `quantity` must be greater than 0.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _mint(
1006         address to,
1007         uint256 quantity,
1008         bytes memory _data,
1009         bool safe
1010     ) internal {
1011         uint256 startTokenId = _currentIndex;
1012         if (to == address(0)) revert MintToZeroAddress();
1013         if (quantity == 0) revert MintZeroQuantity();
1014 
1015         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1016 
1017         // Overflows are incredibly unrealistic.
1018         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1019         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1020         unchecked {
1021             _addressData[to].balance += uint64(quantity);
1022             _addressData[to].numberMinted += uint64(quantity);
1023 
1024             _ownerships[startTokenId].addr = to;
1025             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1026 
1027             uint256 updatedIndex = startTokenId;
1028             uint256 end = updatedIndex + quantity;
1029 
1030             if (safe && to.isContract()) {
1031                 do {
1032                     emit Transfer(address(0), to, updatedIndex);
1033                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1034                         revert TransferToNonERC721ReceiverImplementer();
1035                     }
1036                 } while (updatedIndex != end);
1037                 // Reentrancy protection
1038                 if (_currentIndex != startTokenId) revert();
1039             } else {
1040                 do {
1041                     emit Transfer(address(0), to, updatedIndex++);
1042                 } while (updatedIndex != end);
1043             }
1044             _currentIndex = updatedIndex;
1045         }
1046         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1047     }
1048 
1049     /**
1050      * @dev Transfers `tokenId` from `from` to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) private {
1064         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1065 
1066         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1067 
1068         bool isApprovedOrOwner = (_msgSender() == from ||
1069             isApprovedForAll(from, _msgSender()) ||
1070             getApproved(tokenId) == _msgSender());
1071 
1072         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1073         if (to == address(0)) revert TransferToZeroAddress();
1074 
1075         _beforeTokenTransfers(from, to, tokenId, 1);
1076 
1077         // Clear approvals from the previous owner
1078         _approve(address(0), tokenId, from);
1079 
1080         // Underflow of the sender's balance is impossible because we check for
1081         // ownership above and the recipient's balance can't realistically overflow.
1082         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1083         unchecked {
1084             _addressData[from].balance -= 1;
1085             _addressData[to].balance += 1;
1086 
1087             TokenOwnership storage currSlot = _ownerships[tokenId];
1088             currSlot.addr = to;
1089             currSlot.startTimestamp = uint64(block.timestamp);
1090 
1091             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1092             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1093             uint256 nextTokenId = tokenId + 1;
1094             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1095             if (nextSlot.addr == address(0)) {
1096                 // This will suffice for checking _exists(nextTokenId),
1097                 // as a burned slot cannot contain the zero address.
1098                 if (nextTokenId != _currentIndex) {
1099                     nextSlot.addr = from;
1100                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1101                 }
1102             }
1103         }
1104 
1105         emit Transfer(from, to, tokenId);
1106         _afterTokenTransfers(from, to, tokenId, 1);
1107     }
1108 
1109     /**
1110      * @dev This is equivalent to _burn(tokenId, false)
1111      */
1112     function _burn(uint256 tokenId) internal virtual {
1113         _burn(tokenId, false);
1114     }
1115 
1116     /**
1117      * @dev Destroys `tokenId`.
1118      * The approval is cleared when the token is burned.
1119      *
1120      * Requirements:
1121      *
1122      * - `tokenId` must exist.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1127         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1128 
1129         address from = prevOwnership.addr;
1130 
1131         if (approvalCheck) {
1132             bool isApprovedOrOwner = (_msgSender() == from ||
1133                 isApprovedForAll(from, _msgSender()) ||
1134                 getApproved(tokenId) == _msgSender());
1135 
1136             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1137         }
1138 
1139         _beforeTokenTransfers(from, address(0), tokenId, 1);
1140 
1141         // Clear approvals from the previous owner
1142         _approve(address(0), tokenId, from);
1143 
1144         // Underflow of the sender's balance is impossible because we check for
1145         // ownership above and the recipient's balance can't realistically overflow.
1146         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1147         unchecked {
1148             AddressData storage addressData = _addressData[from];
1149             addressData.balance -= 1;
1150             addressData.numberBurned += 1;
1151 
1152             // Keep track of who burned the token, and the timestamp of burning.
1153             TokenOwnership storage currSlot = _ownerships[tokenId];
1154             currSlot.addr = from;
1155             currSlot.startTimestamp = uint64(block.timestamp);
1156             currSlot.burned = true;
1157 
1158             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1159             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1160             uint256 nextTokenId = tokenId + 1;
1161             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1162             if (nextSlot.addr == address(0)) {
1163                 // This will suffice for checking _exists(nextTokenId),
1164                 // as a burned slot cannot contain the zero address.
1165                 if (nextTokenId != _currentIndex) {
1166                     nextSlot.addr = from;
1167                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1168                 }
1169             }
1170         }
1171 
1172         emit Transfer(from, address(0), tokenId);
1173         _afterTokenTransfers(from, address(0), tokenId, 1);
1174 
1175         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1176         unchecked {
1177             _burnCounter++;
1178         }
1179     }
1180 
1181     /**
1182      * @dev Approve `to` to operate on `tokenId`
1183      *
1184      * Emits a {Approval} event.
1185      */
1186     function _approve(
1187         address to,
1188         uint256 tokenId,
1189         address owner
1190     ) private {
1191         _tokenApprovals[tokenId] = to;
1192         emit Approval(owner, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1197      *
1198      * @param from address representing the previous owner of the given token ID
1199      * @param to target address that will receive the tokens
1200      * @param tokenId uint256 ID of the token to be transferred
1201      * @param _data bytes optional data to send along with the call
1202      * @return bool whether the call correctly returned the expected magic value
1203      */
1204     function _checkContractOnERC721Received(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) private returns (bool) {
1210         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1211             return retval == IERC721Receiver(to).onERC721Received.selector;
1212         } catch (bytes memory reason) {
1213             if (reason.length == 0) {
1214                 revert TransferToNonERC721ReceiverImplementer();
1215             } else {
1216                 assembly {
1217                     revert(add(32, reason), mload(reason))
1218                 }
1219             }
1220         }
1221     }
1222 
1223     /**
1224      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1225      * And also called before burning one token.
1226      *
1227      * startTokenId - the first token id to be transferred
1228      * quantity - the amount to be transferred
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` will be minted for `to`.
1235      * - When `to` is zero, `tokenId` will be burned by `from`.
1236      * - `from` and `to` are never both zero.
1237      */
1238     function _beforeTokenTransfers(
1239         address from,
1240         address to,
1241         uint256 startTokenId,
1242         uint256 quantity
1243     ) internal virtual {}
1244 
1245     /**
1246      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1247      * minting.
1248      * And also called after one token has been burned.
1249      *
1250      * startTokenId - the first token id to be transferred
1251      * quantity - the amount to be transferred
1252      *
1253      * Calling conditions:
1254      *
1255      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1256      * transferred to `to`.
1257      * - When `from` is zero, `tokenId` has been minted for `to`.
1258      * - When `to` is zero, `tokenId` has been burned by `from`.
1259      * - `from` and `to` are never both zero.
1260      */
1261     function _afterTokenTransfers(
1262         address from,
1263         address to,
1264         uint256 startTokenId,
1265         uint256 quantity
1266     ) internal virtual {}
1267 }
1268 
1269 abstract contract Ownable is Context {
1270     address private _owner;
1271 
1272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1273 
1274     /**
1275      * @dev Initializes the contract setting the deployer as the initial owner.
1276      */
1277     constructor() {
1278         _transferOwnership(_msgSender());
1279     }
1280 
1281     /**
1282      * @dev Returns the address of the current owner.
1283      */
1284     function owner() public view virtual returns (address) {
1285         return _owner;
1286     }
1287 
1288     /**
1289      * @dev Throws if called by any account other than the owner.
1290      */
1291     modifier onlyOwner() {
1292         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1293         _;
1294     }
1295 
1296     /**
1297      * @dev Leaves the contract without owner. It will not be possible to call
1298      * `onlyOwner` functions anymore. Can only be called by the current owner.
1299      *
1300      * NOTE: Renouncing ownership will leave the contract without an owner,
1301      * thereby removing any functionality that is only available to the owner.
1302      */
1303     function renounceOwnership() public virtual onlyOwner {
1304         _transferOwnership(address(0));
1305     }
1306 
1307     /**
1308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1309      * Can only be called by the current owner.
1310      */
1311     function transferOwnership(address newOwner) public virtual onlyOwner {
1312         require(newOwner != address(0), "Ownable: new owner is the zero address");
1313         _transferOwnership(newOwner);
1314     }
1315 
1316     /**
1317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1318      * Internal function without access restriction.
1319      */
1320     function _transferOwnership(address newOwner) internal virtual {
1321         address oldOwner = _owner;
1322         _owner = newOwner;
1323         emit OwnershipTransferred(oldOwner, newOwner);
1324     }
1325 }
1326 
1327 // File: closedsea/src/OperatorFilterer.sol
1328 
1329 
1330 pragma solidity ^0.8.4;
1331 
1332 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
1333 /// mandatory on-chain royalty enforcement in order for new collections to
1334 /// receive royalties.
1335 /// For more information, see:
1336 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
1337 abstract contract OperatorFilterer {
1338     /// @dev The default OpenSea operator blocklist subscription.
1339     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1340 
1341     /// @dev The OpenSea operator filter registry.
1342     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
1343 
1344     /// @dev Registers the current contract to OpenSea's operator filter,
1345     /// and subscribe to the default OpenSea operator blocklist.
1346     /// Note: Will not revert nor update existing settings for repeated registration.
1347     function _registerForOperatorFiltering() internal virtual {
1348         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
1349     }
1350 
1351     /// @dev Registers the current contract to OpenSea's operator filter.
1352     /// Note: Will not revert nor update existing settings for repeated registration.
1353     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
1354         internal
1355         virtual
1356     {
1357         /// @solidity memory-safe-assembly
1358         assembly {
1359             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
1360 
1361             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
1362             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
1363 
1364             for {} iszero(subscribe) {} {
1365                 if iszero(subscriptionOrRegistrantToCopy) {
1366                     functionSelector := 0x4420e486 // `register(address)`.
1367                     break
1368                 }
1369                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
1370                 break
1371             }
1372             // Store the function selector.
1373             mstore(0x00, shl(224, functionSelector))
1374             // Store the `address(this)`.
1375             mstore(0x04, address())
1376             // Store the `subscriptionOrRegistrantToCopy`.
1377             mstore(0x24, subscriptionOrRegistrantToCopy)
1378             // Register into the registry.
1379             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
1380                 // If the function selector has not been overwritten,
1381                 // it is an out-of-gas error.
1382                 if eq(shr(224, mload(0x00)), functionSelector) {
1383                     // To prevent gas under-estimation.
1384                     revert(0, 0)
1385                 }
1386             }
1387             // Restore the part of the free memory pointer that was overwritten,
1388             // which is guaranteed to be zero, because of Solidity's memory size limits.
1389             mstore(0x24, 0)
1390         }
1391     }
1392 
1393     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
1394     modifier onlyAllowedOperator(address from) virtual {
1395         if (from != msg.sender) {
1396             if (!_isPriorityOperator(msg.sender)) {
1397                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
1398             }
1399         }
1400         _;
1401     }
1402 
1403     /// @dev Modifier to guard a function from approving a blocked operator..
1404     modifier onlyAllowedOperatorApproval(address operator) virtual {
1405         if (!_isPriorityOperator(operator)) {
1406             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
1407         }
1408         _;
1409     }
1410 
1411     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
1412     function _revertIfBlocked(address operator) private view {
1413         /// @solidity memory-safe-assembly
1414         assembly {
1415             // Store the function selector of `isOperatorAllowed(address,address)`,
1416             // shifted left by 6 bytes, which is enough for 8tb of memory.
1417             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
1418             mstore(0x00, 0xc6171134001122334455)
1419             // Store the `address(this)`.
1420             mstore(0x1a, address())
1421             // Store the `operator`.
1422             mstore(0x3a, operator)
1423 
1424             // `isOperatorAllowed` always returns true if it does not revert.
1425             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
1426                 // Bubble up the revert if the staticcall reverts.
1427                 returndatacopy(0x00, 0x00, returndatasize())
1428                 revert(0x00, returndatasize())
1429             }
1430 
1431             // We'll skip checking if `from` is inside the blacklist.
1432             // Even though that can block transferring out of wrapper contracts,
1433             // we don't want tokens to be stuck.
1434 
1435             // Restore the part of the free memory pointer that was overwritten,
1436             // which is guaranteed to be zero, if less than 8tb of memory is used.
1437             mstore(0x3a, 0)
1438         }
1439     }
1440 
1441     /// @dev For deriving contracts to override, so that operator filtering
1442     /// can be turned on / off.
1443     /// Returns true by default.
1444     function _operatorFilteringEnabled() internal view virtual returns (bool) {
1445         return true;
1446     }
1447 
1448     /// @dev For deriving contracts to override, so that preferred marketplaces can
1449     /// skip operator filtering, helping users save gas.
1450     /// Returns false for all inputs by default.
1451     function _isPriorityOperator(address) internal view virtual returns (bool) {
1452         return false;
1453     }
1454 }
1455 // File: @openzeppelin/contracts@4.8.2/token/ERC721/extensions/ERC721Burnable.sol
1456 
1457 
1458 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1459 
1460 pragma solidity ^0.8.0;
1461 
1462 
1463 
1464 /**
1465  * @title ERC721 Burnable Token
1466  * @dev ERC721 Token that can be burned (destroyed).
1467  */
1468 abstract contract ERC721Burnable is Context, ERC721A {
1469     /**
1470      * @dev Burns `tokenId`. See {ERC721-_burn}.
1471      *
1472      * Requirements:
1473      *
1474      * - The caller must own `tokenId` or be an approved operator.
1475      */
1476     function burn(uint256 tokenId) public virtual {
1477         //solhint-disable-next-line max-line-length
1478         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1479         _burn(tokenId);
1480     }
1481 }
1482 
1483 
1484     pragma solidity ^0.8.13;
1485     
1486     contract AnalGazers is ERC721A, Ownable,  OperatorFilterer, ERC721Burnable {
1487     using Strings for uint256;
1488 
1489 
1490   string private uriPrefix = "ipfs://bafybeibz5c65wnuv7slcphpzevvygw5yjnmc2uzxc3velcsoejucnugq2u/";
1491   string private uriSuffix = ".json";
1492   string private hiddenURL;
1493 
1494   
1495   
1496 
1497   uint256 public cost = 0.005 ether;
1498  
1499   
1500 
1501   uint16 public maxSupply = 6969;
1502   uint8 public maxMintAmountPerTx = 10;
1503    uint8 public maxMintAmountPerWallet = 10;
1504     uint8 public maxFreeMintAmountPerWallet = 1;
1505     uint256 public freeNFTAlreadyMinted = 0;
1506      uint256 public  NUM_FREE_MINTS = 6969;
1507      bool public operatorFilteringEnabled;
1508                                                              
1509  
1510   bool public paused = true;
1511   bool public reveal = true;
1512 
1513 
1514  
1515   
1516   
1517  
1518   
1519 
1520     constructor(
1521     string memory _tokenName,
1522     string memory _tokenSymbol
1523    
1524   ) ERC721A(_tokenName, _tokenSymbol) {
1525      _registerForOperatorFiltering();
1526         operatorFilteringEnabled = true;
1527   }
1528 
1529    modifier callerIsUser() {
1530     require(tx.origin == msg.sender, "The caller is another contract");
1531     _;
1532   }
1533   
1534  
1535  
1536   function Mint(uint256 _mintAmount)
1537       external
1538       payable
1539       callerIsUser
1540   {
1541     require(!paused, "The contract is paused!");
1542     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1543      require (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerWallet, "max NFT per address exceeded");
1544     
1545 
1546     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1547         require(
1548             (cost * _mintAmount) <= msg.value,
1549             "Incorrect ETH value sent"
1550         );
1551     }
1552      else {
1553         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1554         require(
1555             (cost * _mintAmount) <= msg.value,
1556             "Incorrect ETH value sent"
1557         );
1558         require(
1559             _mintAmount <= maxMintAmountPerTx,
1560             "Max mints per transaction exceeded"
1561         );
1562         } else {
1563             require(
1564                 _mintAmount <= maxFreeMintAmountPerWallet,
1565                 "Max mints per transaction exceeded"
1566             );
1567             freeNFTAlreadyMinted += _mintAmount;
1568         }
1569     }
1570     _safeMint(msg.sender, _mintAmount);
1571   }
1572 
1573   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1574      uint16 totalSupply = uint16(totalSupply());
1575     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1576      _safeMint(_receiver , _mintAmount);
1577      delete _mintAmount;
1578      delete _receiver;
1579      delete totalSupply;
1580   }
1581 
1582   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1583      uint16 totalSupply = uint16(totalSupply());
1584      uint totalAmount =   _amountPerAddress * addresses.length;
1585     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1586      for (uint256 i = 0; i < addresses.length; i++) {
1587             _safeMint(addresses[i], _amountPerAddress);
1588         }
1589 
1590      delete _amountPerAddress;
1591      delete totalSupply;
1592   }
1593 
1594  
1595 
1596   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1597       maxSupply = _maxSupply;
1598   }
1599 
1600 
1601 
1602    
1603   function tokenURI(uint256 _tokenId)
1604     public
1605     view
1606     virtual
1607     override
1608     returns (string memory)
1609   {
1610     require(
1611       _exists(_tokenId),
1612       "ERC721Metadata: URI query for nonexistent token"
1613     );
1614     
1615   
1616 if ( reveal == false)
1617 {
1618     return hiddenURL;
1619 }
1620     
1621 
1622     string memory currentBaseURI = _baseURI();
1623     return bytes(currentBaseURI).length > 0
1624         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1625         : "";
1626   }
1627 
1628 
1629  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1630     maxFreeMintAmountPerWallet = _limit;
1631    delete _limit;
1632 
1633 }
1634 
1635     
1636    function seturiSuffix(string memory _uriSuffix) external onlyOwner {
1637     uriSuffix = _uriSuffix;
1638   }
1639 
1640 
1641   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1642     uriPrefix = _uriPrefix;
1643   }
1644    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1645     hiddenURL = _uriPrefix;
1646   }
1647 function setNumFreeMints(uint256 _numfreemints)
1648       external
1649       onlyOwner
1650   {
1651       NUM_FREE_MINTS = _numfreemints;
1652   }
1653 
1654   function setPaused() external onlyOwner {
1655     paused = !paused;
1656 
1657   }
1658 
1659   function setCost(uint _cost) external onlyOwner{
1660       cost = _cost;
1661 
1662   }
1663 
1664  function setRevealed() external onlyOwner{
1665      reveal = !reveal;
1666  }
1667 
1668   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1669       maxMintAmountPerTx = _maxtx;
1670 
1671   }
1672 
1673  function setmaxMintAmountPerWallet(uint8 _maxWL) external onlyOwner{
1674       maxMintAmountPerWallet = _maxWL;
1675 
1676   }
1677 
1678   function withdraw() public onlyOwner  {
1679     // This will transfer the remaining contract balance to the owner.
1680     // Do not remove this otherwise you will not be able to withdraw the funds.
1681     // =============================================================================
1682     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1683     require(os);
1684     // =============================================================================
1685   }
1686 
1687 
1688   function _baseURI() internal view  override returns (string memory) {
1689     return uriPrefix;
1690   }
1691     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1692     ERC721A.transferFrom(from, to, tokenId);
1693   }
1694 
1695   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1696     ERC721A.safeTransferFrom(from, to, tokenId);
1697   }
1698 
1699   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1700     public
1701     override
1702     onlyAllowedOperator(from)
1703   {
1704     ERC721A.safeTransferFrom(from, to, tokenId, data);
1705   }
1706      function setOperatorFilteringEnabled(bool value) public onlyOwner {
1707         operatorFilteringEnabled = value;
1708     }
1709 
1710     function _operatorFilteringEnabled() internal view override returns (bool) {
1711         return operatorFilteringEnabled;
1712     }
1713 }