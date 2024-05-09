1 /********************************************************************************
2     * United Metaverse Nation
3 
4                                                       ..:---=====---:..                                  
5                 
6                                                .-=*#%@@@@@@@@@@@@@@@@@@@%#*=-.                           
7                 
8                                            :=#@@@@@@@@@@@@@@@@@@@@@@#*%@@@@@@@@*=:                       
9                 
10                                         -*%@@@@@@@@%##@@@@@@@@@@@@@=:.*@@@@@@@@@@@%*-                    
11                 
12                                      :+@@@@%*#@@@@%.=@@@@@+*+=-=-:.   :#@@@@@@@@@@@@@%*:                 
13                 
14                                    -#@@@@%#=-=##+**@@@@@@%#-           :*@@@@@@@@@@@@@@@#=               
15                 
16                                  -%@@@@@*@@@*. -%@@@#*+=:      -****:.+@@@@@@@@@@@@@@@@@@@%=              
17                 
18                                .#@@@@@@@@@@@=. =::-          .#@%#@@*%@@@@@@@@@@@@@@@@@@@@@@#-           
19                 
20                               =@@@@@@@@@@**#.               -@@@=-+%@@@@@@@@@@@@@@@@@@@@@@@@@%*          
21                 
22                     .-----===*@@@@@@**=%#-#                 .:=#. *@@@@@@@@@@@@@@@@@@@@@@@@@@@%#.        
23                 
24                       ..=@@@@@#=:                        =@%**@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#.          
25                 
26                        -@@@%#:                       :=*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###**+          
27                 
28                       :@@@%%.                        +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:::::..         
29                 
30                       %@@@%*                      =@%%@@%+=+*=+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%=        
31                 
32                      =@@@@*-                      @@@@%%-   .%++@=:@@@%@@@@@@@@@@@@@@@@@@@##@@@%%.       
33                 
34                     .@@@@%+-                      :**#%%*##*#+ .       =@@@@@@@@@@@@@@@@@@* #@@@%+       
35                 
36                     -@@@@% #.                   :#@@@@@@@@@@@*. -+===++%@@@@@@*#@#*++:-.*@# :@@@%%       
37                 
38                     *@@@%%..                  :+@@@@@@@@@@@@@@@@@@@@@@@%*@@@@@@@%@@@%%:  #@  @@@%%:      
39                 
40                     %@@@@%*                 .*@@@@@@@@@@@@@@@@@@@@@@@@@@*.+@@@@@@@@@%%:   %- #@@@%-      
41                 
42                     =+==++#****++=          :::---=+++++++++++*@@@@@@@@@@%*@@@@@@**@@@***++= -=+=+-:**++=
43                 
44                           =@@@@@@%+               #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@==@@%@#+.        -@@@%#
45                 
46                           -@@@@@@@%+             .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*#+#=*-        =@@@%*
47                 
48                           .@@@@@@@%%.            .+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%.        #@@%%-
49                 
50                  =+++++++++%@@@@@@@%#:             -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%=        :@@@%% 
51                 
52                  -=======+++@@@@@@@@@@*-            .+#%%%%*+*@@@@@@@@@@@@@@@@@@@@@@@@@%=         #@@@%= 
53                 
54                             +@@@@@@@@@@%%-                     .:*@@@@@@@@@@@@@@@@@@@%*.         =@@@%#  
55                 
56                              #@@@@@@@@@@%%:                      %@@@@@@@@@@@@@@@@@@%*          :@@@%%:  
57                 
58                              .%@@@@@@@@@%%.                      .+@@@@@@@@@@@@@@@@%%:         :@@@%%-   
59                 
60                             ..:%@@@@@@%%#=                         :======#@@@@@@@@%%:     ...-@@%##-    
61                 
62                             =@@@@@@@%#                             =@@@@@@@@@@@@@@@%#    -@@@@%=         
63                 
64                              :%@@@@%=                             -@@@@@@@@@@@@@@@#:   .*@@@%%:          
65                 
66                                +@@@@%+                            .%@@@@@@@@@@@@%+    .+***+=            
67                 
68                                 .*@@@@%+.                           #@@@@@@@@@@#-   ::::::               
69                 
70                                   .*@@@@@*-                         .%@@@@@@%*-  -*@@@@%+.               
71                 
72                                     .=%@@@@%+:                       .-:-::.  -*@@@@@#=                  
73                 
74                                        :+%@@@@@#=:                       .-+#@@@@@#=.                    
75                 
76                                           .=*%@@@@@%*+-:..       ..:-=*#@@@@@@%+-.                       
77                 
78                                               .:=*#%@@@@@@@@@@@@@@@@@@@@%#+=:                             
79                 
80                                                      ..:--========--:.  
81     ******************************************************************************/
82 
83 // Sources flattened with hardhat v2.6.1 https://hardhat.org
84 
85 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
86 
87 // SPDX-License-Identifier: MIT
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Interface of the ERC165 standard, as defined in the
93  * https://eips.ethereum.org/EIPS/eip-165[EIP].
94  *
95  * Implementers can declare support of contract interfaces, which can then be
96  * queried by others ({ERC165Checker}).
97  *
98  * For an implementation, see {ERC165}.
99  */
100 interface IERC165 {
101     /**
102      * @dev Returns true if this contract implements the interface defined by
103      * `interfaceId`. See the corresponding
104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
105      * to learn more about how these ids are created.
106      *
107      * This function call must use less than 30 000 gas.
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
110 }
111 
112 
113 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
114 
115 
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Required interface of an ERC721 compliant contract.
121  */
122 interface IERC721 is IERC165 {
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
135      */
136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
137 
138     /**
139      * @dev Returns the number of tokens in ``owner``'s account.
140      */
141     function balanceOf(address owner) external view returns (uint256 balance);
142 
143     /**
144      * @dev Returns the owner of the `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function ownerOf(uint256 tokenId) external view returns (address owner);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
154      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be have been whiteed to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 
172     /**
173      * @dev Transfers `tokenId` token from `from` to `to`.
174      *
175      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint256 tokenId
190     ) external;
191 
192     /**
193      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
194      * The approval is cleared when the token is transferred.
195      *
196      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
197      *
198      * Requirements:
199      *
200      * - The caller must own the token or be an approved operator.
201      * - `tokenId` must exist.
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address to, uint256 tokenId) external;
206 
207     /**
208      * @dev Returns the account approved for `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function getApproved(uint256 tokenId) external view returns (address operator);
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns if the `operator` is whiteed to manage all of the assets of `owner`.
230      *
231      * See {setApprovalForAll}
232      */
233     function isApprovedForAll(address owner, address operator) external view returns (bool);
234 
235     /**
236      * @dev Safely transfers `tokenId` token from `from` to `to`.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId,
252         bytes calldata data
253     ) external;
254 }
255 
256 
257 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.0
258 
259 
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @title ERC721 token receiver interface
265  * @dev Interface for any contract that wants to support safeTransfers
266  * from ERC721 asset contracts.
267  */
268 interface IERC721Receiver {
269     /**
270      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
271      * by `operator` from `from`, this function is called.
272      *
273      * It must return its Solidity selector to confirm the token transfer.
274      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
275      *
276      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
277      */
278     function onERC721Received(
279         address operator,
280         address from,
281         uint256 tokenId,
282         bytes calldata data
283     ) external returns (bytes4);
284 }
285 
286 
287 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.0
288 
289 
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
295  * @dev See https://eips.ethereum.org/EIPS/eip-721
296  */
297 interface IERC721Metadata is IERC721 {
298     /**
299      * @dev Returns the token collection name.
300      */
301     function name() external view returns (string memory);
302 
303     /**
304      * @dev Returns the token collection symbol.
305      */
306     function symbol() external view returns (string memory);
307 
308     /**
309      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
310      */
311     function tokenURI(uint256 tokenId) external view returns (string memory);
312 }
313 
314 
315 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
316 
317 
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Collection of functions related to the address type
323  */
324 library Address {
325     /**
326      * @dev Returns true if `account` is a contract.
327      *
328      * [IMPORTANT]
329      * ====
330      * It is unsafe to assume that an address for which this function returns
331      * false is an externally-owned account (EOA) and not a contract.
332      *
333      * Among others, `isContract` will return false for the following
334      * types of addresses:
335      *
336      *  - an externally-owned account
337      *  - a contract in construction
338      *  - an address where a contract will be created
339      *  - an address where a contract lived, but was destroyed
340      * ====
341      */
342     function isContract(address account) internal view returns (bool) {
343         // This method relies on extcodesize, which returns 0 for contracts in
344         // construction, since the code is only stored at the end of the
345         // constructor execution.
346 
347         uint256 size;
348         assembly {
349             size := extcodesize(account)
350         }
351         return size > 0;
352     }
353 
354     /**
355      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
356      * `recipient`, forwarding all available gas and reverting on errors.
357      *
358      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
359      * of certain opcodes, possibly making contracts go over the 2300 gas limit
360      * imposed by `transfer`, making them unable to receive funds via
361      * `transfer`. {sendValue} removes this limitation.
362      *
363      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
364      *
365      * IMPORTANT: because control is transferred to `recipient`, care must be
366      * taken to not create reentrancy vulnerabilities. Consider using
367      * {ReentrancyGuard} or the
368      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
369      */
370     function sendValue(address payable recipient, uint256 amount) internal {
371         require(address(this).balance >= amount, "Address: insufficient balance");
372 
373         (bool success, ) = recipient.call{value: amount}("");
374         require(success, "Address: unable to send value, recipient may have reverted");
375     }
376 
377     /**
378      * @dev Performs a Solidity function call using a low level `call`. A
379      * plain `call` is an unsafe replacement for a function call: use this
380      * function instead.
381      *
382      * If `target` reverts with a revert reason, it is bubbled up by this
383      * function (like regular Solidity function calls).
384      *
385      * Returns the raw returned data. To convert to the expected return value,
386      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
387      *
388      * Requirements:
389      *
390      * - `target` must be a contract.
391      * - calling `target` with `data` must not revert.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
396         return functionCall(target, data, "Address: low-level call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
401      * `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         return functionCallWithValue(target, data, 0, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but also transferring `value` wei to `target`.
416      *
417      * Requirements:
418      *
419      * - the calling contract must have an ETH balance of at least `value`.
420      * - the called Solidity function must be `payable`.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value
428     ) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
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
444         require(address(this).balance >= value, "Address: insufficient balance for call");
445         require(isContract(target), "Address: call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.call{value: value}(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
458         return functionStaticCall(target, data, "Address: low-level static call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal view returns (bytes memory) {
472         require(isContract(target), "Address: static call to non-contract");
473 
474         (bool success, bytes memory returndata) = target.staticcall(data);
475         return verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
485         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
490      * but performing a delegate call.
491      *
492      * _Available since v3.4._
493      */
494     function functionDelegateCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal returns (bytes memory) {
499         require(isContract(target), "Address: delegate call to non-contract");
500 
501         (bool success, bytes memory returndata) = target.delegatecall(data);
502         return verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
507      * revert reason using the provided one.
508      *
509      * _Available since v4.3._
510      */
511     function verifyCallResult(
512         bool success,
513         bytes memory returndata,
514         string memory errorMessage
515     ) internal pure returns (bytes memory) {
516         if (success) {
517             return returndata;
518         } else {
519             // Look for revert reason and bubble it up if present
520             if (returndata.length > 0) {
521                 // The easiest way to bubble the revert reason is using memory via assembly
522 
523                 assembly {
524                     let returndata_size := mload(returndata)
525                     revert(add(32, returndata), returndata_size)
526                 }
527             } else {
528                 revert(errorMessage);
529             }
530         }
531     }
532 }
533 
534 
535 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Provides information about the current execution context, including the
543  * sender of the transaction and its data. While these are generally available
544  * via msg.sender and msg.data, they should not be accessed in such a direct
545  * manner, since when dealing with meta-transactions the account sending and
546  * paying for execution may not be the actual sender (as far as an application
547  * is concerned).
548  *
549  * This contract is only required for intermediate, library-like contracts.
550  */
551 abstract contract Context {
552     function _msgSender() internal view virtual returns (address) {
553         return msg.sender;
554     }
555 
556     function _msgData() internal view virtual returns (bytes calldata) {
557         return msg.data;
558     }
559 }
560 
561 
562 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
563 
564 
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev String operations.
570  */
571 library Strings {
572     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
576      */
577     function toString(uint256 value) internal pure returns (string memory) {
578         // Inspired by OraclizeAPI's implementation - MIT licence
579         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
580 
581         if (value == 0) {
582             return "0";
583         }
584         uint256 temp = value;
585         uint256 digits;
586         while (temp != 0) {
587             digits++;
588             temp /= 10;
589         }
590         bytes memory buffer = new bytes(digits);
591         while (value != 0) {
592             digits -= 1;
593             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
594             value /= 10;
595         }
596         return string(buffer);
597     }
598 
599     /**
600      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
601      */
602     function toHexString(uint256 value) internal pure returns (string memory) {
603         if (value == 0) {
604             return "0x00";
605         }
606         uint256 temp = value;
607         uint256 length = 0;
608         while (temp != 0) {
609             length++;
610             temp >>= 8;
611         }
612         return toHexString(value, length);
613     }
614 
615     /**
616      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
617      */
618     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
619         bytes memory buffer = new bytes(2 * length + 2);
620         buffer[0] = "0";
621         buffer[1] = "x";
622         for (uint256 i = 2 * length + 1; i > 1; --i) {
623             buffer[i] = _HEX_SYMBOLS[value & 0xf];
624             value >>= 4;
625         }
626         require(value == 0, "Strings: hex length insufficient");
627         return string(buffer);
628     }
629 }
630 
631 
632 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.0
633 
634 
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Implementation of the {IERC165} interface.
640  *
641  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
642  * for the additional interface id that will be supported. For example:
643  *
644  * ```solidity
645  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
646  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
647  * }
648  * ```
649  *
650  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
651  */
652 abstract contract ERC165 is IERC165 {
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
657         return interfaceId == type(IERC165).interfaceId;
658     }
659 }
660 
661 
662 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.0
663 
664 
665 
666 pragma solidity ^0.8.0;
667 
668 
669 
670 
671 
672 
673 
674 /**
675  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
676  * the Metadata extension, but not including the Enumerable extension, which is available separately as
677  * {ERC721Enumerable}.
678  */
679 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
680     using Address for address;
681     using Strings for uint256;
682 
683     // Token name
684     string private _name;
685 
686     // Token symbol
687     string private _symbol;
688 
689     // Mapping from token ID to owner address
690     mapping(uint256 => address) private _owners;
691 
692     // Mapping owner address to token count
693     mapping(address => uint256) private _balances;
694 
695     // Mapping from token ID to approved address
696     mapping(uint256 => address) private _tokenApprovals;
697 
698     // Mapping from owner to operator approvals
699     mapping(address => mapping(address => bool)) private _operatorApprovals;
700 
701     /**
702      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
703      */
704     constructor(string memory name_, string memory symbol_) {
705         _name = name_;
706         _symbol = symbol_;
707     }
708 
709     /**
710      * @dev See {IERC165-supportsInterface}.
711      */
712     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
713         return
714             interfaceId == type(IERC721).interfaceId ||
715             interfaceId == type(IERC721Metadata).interfaceId ||
716             super.supportsInterface(interfaceId);
717     }
718 
719     /**
720      * @dev See {IERC721-balanceOf}.
721      */
722     function balanceOf(address owner) public view virtual override returns (uint256) {
723         require(owner != address(0), "ERC721: balance query for the zero address");
724         return _balances[owner];
725     }
726 
727     /**
728      * @dev See {IERC721-ownerOf}.
729      */
730     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
731         address owner = _owners[tokenId];
732         require(owner != address(0), "ERC721: owner query for nonexistent token");
733         return owner;
734     }
735 
736     /**
737      * @dev See {IERC721Metadata-name}.
738      */
739     function name() public view virtual override returns (string memory) {
740         return _name;
741     }
742 
743     /**
744      * @dev See {IERC721Metadata-symbol}.
745      */
746     function symbol() public view virtual override returns (string memory) {
747         return _symbol;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-tokenURI}.
752      */
753     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
754         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
755 
756         string memory baseURI = _baseURI();
757         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
758     }
759 
760     /**
761      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
762      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
763      * by default, can be overriden in child contracts.
764      */
765     function _baseURI() internal view virtual returns (string memory) {
766         return "";
767     }
768 
769     /**
770      * @dev See {IERC721-approve}.
771      */
772     function approve(address to, uint256 tokenId) public virtual override {
773         address owner = ERC721.ownerOf(tokenId);
774         require(to != owner, "ERC721: approval to current owner");
775 
776         require(
777             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
778             "ERC721: approve caller is not owner nor approved for all"
779         );
780 
781         _approve(to, tokenId);
782     }
783 
784     /**
785      * @dev See {IERC721-getApproved}.
786      */
787     function getApproved(uint256 tokenId) public view virtual override returns (address) {
788         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
789 
790         return _tokenApprovals[tokenId];
791     }
792 
793     /**
794      * @dev See {IERC721-setApprovalForAll}.
795      */
796     function setApprovalForAll(address operator, bool approved) public virtual override {
797         require(operator != _msgSender(), "ERC721: approve to caller");
798 
799         _operatorApprovals[_msgSender()][operator] = approved;
800         emit ApprovalForAll(_msgSender(), operator, approved);
801     }
802 
803     /**
804      * @dev See {IERC721-isApprovedForAll}.
805      */
806     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
807         return _operatorApprovals[owner][operator];
808     }
809 
810     /**
811      * @dev See {IERC721-transferFrom}.
812      */
813     function transferFrom(
814         address from,
815         address to,
816         uint256 tokenId
817     ) public virtual override {
818         //solhint-disable-next-line max-line-length
819         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
820 
821         _transfer(from, to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-safeTransferFrom}.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) public virtual override {
832         safeTransferFrom(from, to, tokenId, "");
833     }
834 
835     /**
836      * @dev See {IERC721-safeTransferFrom}.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) public virtual override {
844         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
845         _safeTransfer(from, to, tokenId, _data);
846     }
847 
848     /**
849      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
850      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
851      *
852      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
853      *
854      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
855      * implement alternative mechanisms to perform token transfer, such as signature-based.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must exist and be owned by `from`.
862      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _safeTransfer(
867         address from,
868         address to,
869         uint256 tokenId,
870         bytes memory _data
871     ) internal virtual {
872         _transfer(from, to, tokenId);
873         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
874     }
875 
876     /**
877      * @dev Returns whether `tokenId` exists.
878      *
879      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
880      *
881      * Tokens start existing when they are minted (`_mint`),
882      * and stop existing when they are burned (`_burn`).
883      */
884     function _exists(uint256 tokenId) internal view virtual returns (bool) {
885         return _owners[tokenId] != address(0);
886     }
887 
888     /**
889      * @dev Returns whether `spender` is whiteed to manage `tokenId`.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must exist.
894      */
895     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
896         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
897         address owner = ERC721.ownerOf(tokenId);
898         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
899     }
900 
901     /**
902      * @dev Safely mints `tokenId` and transfers it to `to`.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must not exist.
907      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _safeMint(address to, uint256 tokenId) internal virtual {
912         _safeMint(to, tokenId, "");
913     }
914 
915     /**
916      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
917      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
918      */
919     function _safeMint(
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) internal virtual {
924         _mint(to, tokenId);
925         require(
926             _checkOnERC721Received(address(0), to, tokenId, _data),
927             "ERC721: transfer to non ERC721Receiver implementer"
928         );
929     }
930 
931     /**
932      * @dev Mints `tokenId` and transfers it to `to`.
933      *
934      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
935      *
936      * Requirements:
937      *
938      * - `tokenId` must not exist.
939      * - `to` cannot be the zero address.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _mint(address to, uint256 tokenId) internal virtual {
944         require(to != address(0), "ERC721: mint to the zero address");
945         require(!_exists(tokenId), "ERC721: token already minted");
946 
947         _beforeTokenTransfer(address(0), to, tokenId);
948 
949         _balances[to] += 1;
950         _owners[tokenId] = to;
951 
952         emit Transfer(address(0), to, tokenId);
953     }
954 
955     /**
956      * @dev Destroys `tokenId`.
957      * The approval is cleared when the token is burned.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _burn(uint256 tokenId) internal virtual {
966         address owner = ERC721.ownerOf(tokenId);
967 
968         _beforeTokenTransfer(owner, address(0), tokenId);
969 
970         // Clear approvals
971         _approve(address(0), tokenId);
972 
973         _balances[owner] -= 1;
974         delete _owners[tokenId];
975 
976         emit Transfer(owner, address(0), tokenId);
977     }
978 
979     /**
980      * @dev Transfers `tokenId` from `from` to `to`.
981      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _transfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) internal virtual {
995         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
996         require(to != address(0), "ERC721: transfer to the zero address");
997 
998         _beforeTokenTransfer(from, to, tokenId);
999 
1000         // Clear approvals from the previous owner
1001         _approve(address(0), tokenId);
1002 
1003         _balances[from] -= 1;
1004         _balances[to] += 1;
1005         _owners[tokenId] = to;
1006 
1007         emit Transfer(from, to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev Approve `to` to operate on `tokenId`
1012      *
1013      * Emits a {Approval} event.
1014      */
1015     function _approve(address to, uint256 tokenId) internal virtual {
1016         _tokenApprovals[tokenId] = to;
1017         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1022      * The call is not executed if the target address is not a contract.
1023      *
1024      * @param from address representing the previous owner of the given token ID
1025      * @param to target address that will receive the tokens
1026      * @param tokenId uint256 ID of the token to be transferred
1027      * @param _data bytes optional data to send along with the call
1028      * @return bool whether the call correctly returned the expected magic value
1029      */
1030     function _checkOnERC721Received(
1031         address from,
1032         address to,
1033         uint256 tokenId,
1034         bytes memory _data
1035     ) private returns (bool) {
1036         if (to.isContract()) {
1037             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1038                 return retval == IERC721Receiver.onERC721Received.selector;
1039             } catch (bytes memory reason) {
1040                 if (reason.length == 0) {
1041                     revert("ERC721: transfer to non ERC721Receiver implementer");
1042                 } else {
1043                     assembly {
1044                         revert(add(32, reason), mload(reason))
1045                     }
1046                 }
1047             }
1048         } else {
1049             return true;
1050         }
1051     }
1052 
1053     /**
1054      * @dev Hook that is called before any token transfer. This includes minting
1055      * and burning.
1056      *
1057      * Calling conditions:
1058      *
1059      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1060      * transferred to `to`.
1061      * - When `from` is zero, `tokenId` will be minted for `to`.
1062      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1063      * - `from` and `to` are never both zero.
1064      *
1065      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1066      */
1067     function _beforeTokenTransfer(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) internal virtual {}
1072 }
1073 
1074 
1075 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.0
1076 
1077 
1078 
1079 pragma solidity ^0.8.0;
1080 
1081 /**
1082  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1083  * @dev See https://eips.ethereum.org/EIPS/eip-721
1084  */
1085 interface IERC721Enumerable is IERC721 {
1086     /**
1087      * @dev Returns the total amount of tokens stored by the contract.
1088      */
1089     function totalSupply() external view returns (uint256);
1090 
1091     /**
1092      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1093      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1094      */
1095     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1096 
1097     /**
1098      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1099      * Use along with {totalSupply} to enumerate all tokens.
1100      */
1101     function tokenByIndex(uint256 index) external view returns (uint256);
1102 }
1103 
1104 
1105 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.0
1106 
1107 
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 
1112 /**
1113  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1114  * enumerability of all the token ids in the contract as well as all token ids owned by each
1115  * account.
1116  */
1117 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1118     // Mapping from owner to list of owned token IDs
1119     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1120 
1121     // Mapping from token ID to index of the owner tokens list
1122     mapping(uint256 => uint256) private _ownedTokensIndex;
1123 
1124     // Array with all token ids, used for enumeration
1125     uint256[] private _allTokens;
1126 
1127     // Mapping from token id to position in the allTokens array
1128     mapping(uint256 => uint256) private _allTokensIndex;
1129 
1130     /**
1131      * @dev See {IERC165-supportsInterface}.
1132      */
1133     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1134         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1139      */
1140     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1141         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1142         return _ownedTokens[owner][index];
1143     }
1144 
1145     /**
1146      * @dev See {IERC721Enumerable-totalSupply}.
1147      */
1148     function totalSupply() public view virtual override returns (uint256) {
1149         return _allTokens.length;
1150     }
1151 
1152     /**
1153      * @dev See {IERC721Enumerable-tokenByIndex}.
1154      */
1155     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1156         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1157         return _allTokens[index];
1158     }
1159 
1160     /**
1161      * @dev Hook that is called before any token transfer. This includes minting
1162      * and burning.
1163      *
1164      * Calling conditions:
1165      *
1166      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1167      * transferred to `to`.
1168      * - When `from` is zero, `tokenId` will be minted for `to`.
1169      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1170      * - `from` cannot be the zero address.
1171      * - `to` cannot be the zero address.
1172      *
1173      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1174      */
1175     function _beforeTokenTransfer(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) internal virtual override {
1180         super._beforeTokenTransfer(from, to, tokenId);
1181 
1182         if (from == address(0)) {
1183             _addTokenToAllTokensEnumeration(tokenId);
1184         } else if (from != to) {
1185             _removeTokenFromOwnerEnumeration(from, tokenId);
1186         }
1187         if (to == address(0)) {
1188             _removeTokenFromAllTokensEnumeration(tokenId);
1189         } else if (to != from) {
1190             _addTokenToOwnerEnumeration(to, tokenId);
1191         }
1192     }
1193 
1194     /**
1195      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1196      * @param to address representing the new owner of the given token ID
1197      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1198      */
1199     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1200         uint256 length = ERC721.balanceOf(to);
1201         _ownedTokens[to][length] = tokenId;
1202         _ownedTokensIndex[tokenId] = length;
1203     }
1204 
1205     /**
1206      * @dev Private function to add a token to this extension's token tracking data structures.
1207      * @param tokenId uint256 ID of the token to be added to the tokens list
1208      */
1209     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1210         _allTokensIndex[tokenId] = _allTokens.length;
1211         _allTokens.push(tokenId);
1212     }
1213 
1214     /**
1215      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1216      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this whites for
1217      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1218      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1219      * @param from address representing the previous owner of the given token ID
1220      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1221      */
1222     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1223         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1224         // then delete the last slot (swap and pop).
1225 
1226         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1227         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1228 
1229         // When the token to delete is the last token, the swap operation is unnecessary
1230         if (tokenIndex != lastTokenIndex) {
1231             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1232 
1233             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1234             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1235         }
1236 
1237         // This also deletes the contents at the last position of the array
1238         delete _ownedTokensIndex[tokenId];
1239         delete _ownedTokens[from][lastTokenIndex];
1240     }
1241 
1242     /**
1243      * @dev Private function to remove a token from this extension's token tracking data structures.
1244      * This has O(1) time complexity, but alters the order of the _allTokens array.
1245      * @param tokenId uint256 ID of the token to be removed from the tokens list
1246      */
1247     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1248         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1249         // then delete the last slot (swap and pop).
1250 
1251         uint256 lastTokenIndex = _allTokens.length - 1;
1252         uint256 tokenIndex = _allTokensIndex[tokenId];
1253 
1254         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1255         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1256         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1257         uint256 lastTokenId = _allTokens[lastTokenIndex];
1258 
1259         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1260         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1261 
1262         // This also deletes the contents at the last position of the array
1263         delete _allTokensIndex[tokenId];
1264         _allTokens.pop();
1265     }
1266 }
1267 
1268 
1269 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.0
1270 
1271 
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 // CAUTION
1276 // This version of SafeMath should only be used with Solidity 0.8 or later,
1277 // because it relies on the compiler's built in overflow checks.
1278 
1279 /**
1280  * @dev Wrappers over Solidity's arithmetic operations.
1281  *
1282  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1283  * now has built in overflow checking.
1284  */
1285 library SafeMath {
1286     /**
1287      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1288      *
1289      * _Available since v3.4._
1290      */
1291     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1292         unchecked {
1293             uint256 c = a + b;
1294             if (c < a) return (false, 0);
1295             return (true, c);
1296         }
1297     }
1298 
1299     /**
1300      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1301      *
1302      * _Available since v3.4._
1303      */
1304     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1305         unchecked {
1306             if (b > a) return (false, 0);
1307             return (true, a - b);
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1313      *
1314      * _Available since v3.4._
1315      */
1316     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1317         unchecked {
1318             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1319             // benefit is lost if 'b' is also tested.
1320             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1321             if (a == 0) return (true, 0);
1322             uint256 c = a * b;
1323             if (c / a != b) return (false, 0);
1324             return (true, c);
1325         }
1326     }
1327 
1328     /**
1329      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1330      *
1331      * _Available since v3.4._
1332      */
1333     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1334         unchecked {
1335             if (b == 0) return (false, 0);
1336             return (true, a / b);
1337         }
1338     }
1339 
1340     /**
1341      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1342      *
1343      * _Available since v3.4._
1344      */
1345     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1346         unchecked {
1347             if (b == 0) return (false, 0);
1348             return (true, a % b);
1349         }
1350     }
1351 
1352     /**
1353      * @dev Returns the addition of two unsigned integers, reverting on
1354      * overflow.
1355      *
1356      * Counterpart to Solidity's `+` operator.
1357      *
1358      * Requirements:
1359      *
1360      * - Addition cannot overflow.
1361      */
1362     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1363         return a + b;
1364     }
1365 
1366     /**
1367      * @dev Returns the subtraction of two unsigned integers, reverting on
1368      * overflow (when the result is negative).
1369      *
1370      * Counterpart to Solidity's `-` operator.
1371      *
1372      * Requirements:
1373      *
1374      * - Subtraction cannot overflow.
1375      */
1376     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1377         return a - b;
1378     }
1379 
1380     /**
1381      * @dev Returns the multiplication of two unsigned integers, reverting on
1382      * overflow.
1383      *
1384      * Counterpart to Solidity's `*` operator.
1385      *
1386      * Requirements:
1387      *
1388      * - Multiplication cannot overflow.
1389      */
1390     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1391         return a * b;
1392     }
1393 
1394     /**
1395      * @dev Returns the integer division of two unsigned integers, reverting on
1396      * division by zero. The result is rounded towards zero.
1397      *
1398      * Counterpart to Solidity's `/` operator.
1399      *
1400      * Requirements:
1401      *
1402      * - The divisor cannot be zero.
1403      */
1404     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1405         return a / b;
1406     }
1407 
1408     /**
1409      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1410      * reverting when dividing by zero.
1411      *
1412      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1413      * opcode (which leaves remaining gas untouched) while Solidity uses an
1414      * invalid opcode to revert (consuming all remaining gas).
1415      *
1416      * Requirements:
1417      *
1418      * - The divisor cannot be zero.
1419      */
1420     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1421         return a % b;
1422     }
1423 
1424     /**
1425      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1426      * overflow (when the result is negative).
1427      *
1428      * CAUTION: This function is deprecated because it requires allocating memory for the error
1429      * message unnecessarily. For custom revert reasons use {trySub}.
1430      *
1431      * Counterpart to Solidity's `-` operator.
1432      *
1433      * Requirements:
1434      *
1435      * - Subtraction cannot overflow.
1436      */
1437     function sub(
1438         uint256 a,
1439         uint256 b,
1440         string memory errorMessage
1441     ) internal pure returns (uint256) {
1442         unchecked {
1443             require(b <= a, errorMessage);
1444             return a - b;
1445         }
1446     }
1447 
1448     /**
1449      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1450      * division by zero. The result is rounded towards zero.
1451      *
1452      * Counterpart to Solidity's `/` operator. Note: this function uses a
1453      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1454      * uses an invalid opcode to revert (consuming all remaining gas).
1455      *
1456      * Requirements:
1457      *
1458      * - The divisor cannot be zero.
1459      */
1460     function div(
1461         uint256 a,
1462         uint256 b,
1463         string memory errorMessage
1464     ) internal pure returns (uint256) {
1465         unchecked {
1466             require(b > 0, errorMessage);
1467             return a / b;
1468         }
1469     }
1470 
1471     /**
1472      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1473      * reverting with custom message when dividing by zero.
1474      *
1475      * CAUTION: This function is deprecated because it requires allocating memory for the error
1476      * message unnecessarily. For custom revert reasons use {tryMod}.
1477      *
1478      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1479      * opcode (which leaves remaining gas untouched) while Solidity uses an
1480      * invalid opcode to revert (consuming all remaining gas).
1481      *
1482      * Requirements:
1483      *
1484      * - The divisor cannot be zero.
1485      */
1486     function mod(
1487         uint256 a,
1488         uint256 b,
1489         string memory errorMessage
1490     ) internal pure returns (uint256) {
1491         unchecked {
1492             require(b > 0, errorMessage);
1493             return a % b;
1494         }
1495     }
1496 }
1497 
1498 
1499 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
1500 
1501 
1502 
1503 pragma solidity ^0.8.0;
1504 
1505 /**
1506  * @dev Contract module which provides a basic access control mechanism, where
1507  * there is an account (an owner) that can be granted exclusive access to
1508  * specific functions.
1509  *
1510  * By default, the owner account will be the one that deploys the contract. This
1511  * can later be changed with {transferOwnership}.
1512  *
1513  * This module is used through inheritance. It will make available the modifier
1514  * `onlyOwner`, which can be applied to your functions to restrict their use to
1515  * the owner.
1516  */
1517 abstract contract Ownable is Context {
1518     address private _owner;
1519 
1520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1521 
1522     /**
1523      * @dev Initializes the contract setting the deployer as the initial owner.
1524      */
1525     constructor() {
1526         _setOwner(_msgSender());
1527     }
1528 
1529     /**
1530      * @dev Returns the address of the current owner.
1531      */
1532     function owner() public view virtual returns (address) {
1533         return _owner;
1534     }
1535 
1536     /**
1537      * @dev Throws if called by any account other than the owner.
1538      */
1539     modifier onlyOwner() {
1540         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1541         _;
1542     }
1543 
1544     /**
1545      * @dev Leaves the contract without owner. It will not be possible to call
1546      * `onlyOwner` functions anymore. Can only be called by the current owner.
1547      *
1548      * NOTE: Renouncing ownership will leave the contract without an owner,
1549      * thereby removing any functionality that is only available to the owner.
1550      */
1551     function renounceOwnership() public virtual onlyOwner {
1552         _setOwner(address(0));
1553     }
1554 
1555     /**
1556      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1557      * Can only be called by the current owner.
1558      */
1559     function transferOwnership(address newOwner) public virtual onlyOwner {
1560         require(newOwner != address(0), "Ownable: new owner is the zero address");
1561         _setOwner(newOwner);
1562     }
1563 
1564     function _setOwner(address newOwner) private {
1565         address oldOwner = _owner;
1566         _owner = newOwner;
1567         emit OwnershipTransferred(oldOwner, newOwner);
1568     }
1569 }
1570 
1571 pragma solidity 0.8.4;
1572 
1573 contract UnitedMetaverseNation is ERC721("United Metaverse Nation", "UMN"), ERC721Enumerable, Ownable {
1574     using SafeMath for uint256;
1575     using Strings for uint256;
1576     /*
1577      * Currently Assuming there will be one baseURI.
1578      * If it fails to upload all NFTs data under one baseURI,
1579      * we will divide baseURI and tokenURI function will be changed accordingly.
1580     */
1581     string private baseURI;
1582     string private blindURI;
1583     uint256 public constant BUY_LIMIT_PER_TX = 10;
1584     uint256 public constant MAX_NFT_PUBLIC = 10931;
1585     uint256 private constant MAX_NFT = 11111;
1586     uint256 public NFTPrice = 100000000000000000;  // 0.1 ETH
1587     bool public reveal;
1588     bool public isActive;
1589     bool public isPresaleActive;
1590     uint256 public constant WHITELIST_MAX_MINT = 2;
1591     mapping(address => bool) private whiteList;
1592     mapping(address => uint256) private whiteListClaimed;
1593     
1594     /*
1595      * Function to reveal all NFTs
1596     */
1597     function revealNow() 
1598         external 
1599         onlyOwner 
1600     {
1601         reveal = true;
1602     }
1603     
1604     /*
1605      * Function addToWhiteList to add whitelisted addresses to presale
1606     */
1607     function addToWhiteList(
1608         address[] memory _addresses
1609     ) 
1610         external
1611         onlyOwner
1612     {
1613         for (uint256 i = 0; i < _addresses.length; i++) {
1614             require(_addresses[i] != address(0), "Cannot add the null address");
1615             whiteList[_addresses[i]] = true;
1616             /**
1617             * @dev We don't want to reset _whiteListClaimed count
1618             * if we try to add someone more than once.
1619             */
1620             whiteListClaimed[_addresses[i]] > 0 ? whiteListClaimed[_addresses[i]] : 0;
1621         }
1622     }
1623     
1624     /*
1625      * Function onWhiteList returns if address is whitelisted or not 
1626     */
1627     function onWhiteList(
1628         address _addr
1629     ) 
1630         external 
1631         view
1632         returns (bool) 
1633     {
1634         return whiteList[_addr];
1635     }
1636     
1637     /*
1638      * Function setIsActive to activate/desactivate the smart contract
1639     */
1640     function setIsActive(
1641         bool _isActive
1642     ) 
1643         external 
1644         onlyOwner 
1645     {
1646         isActive = _isActive;
1647     }
1648     
1649     /*
1650      * Function setPresaleActive to activate/desactivate the presale  
1651     */
1652     function setPresaleActive(
1653         bool _isActive
1654     ) 
1655         external 
1656         onlyOwner 
1657     {
1658         isPresaleActive = _isActive;
1659     }
1660     
1661     /*
1662      * Function to set Base and Blind URI 
1663     */
1664     function setURIs(
1665         string memory _blindURI, 
1666         string memory _URI
1667     ) 
1668         external 
1669         onlyOwner 
1670     {
1671         blindURI = _blindURI;
1672         baseURI = _URI;
1673     }
1674     
1675     /*
1676      * Function to withdraw collected amount during minting by the owner
1677     */
1678     function withdraw(
1679         address _to
1680     ) 
1681         public 
1682         onlyOwner 
1683     {
1684         uint balance = address(this).balance;
1685         require(balance > 0, "Balance should be more then zero");
1686         payable(_to).transfer(balance);
1687     }
1688     
1689     /*
1690      * Function to mint new NFTs during the public sale
1691      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1692     */
1693     function mintNFT(
1694         uint256 _numOfTokens
1695     ) 
1696         public 
1697         payable 
1698     {
1699     
1700         require(isActive, 'Contract is not active');
1701         require(!isPresaleActive, 'Only whiteing from White List');
1702         require(_numOfTokens <= BUY_LIMIT_PER_TX, "Cannot mint above limit");
1703         require(totalSupply().add(_numOfTokens) <= MAX_NFT_PUBLIC, "Purchase would exceed max public supply of NFTs");
1704         require(NFTPrice.mul(_numOfTokens) == msg.value, "Ether value sent is not correct");
1705         
1706         for(uint i = 0; i < _numOfTokens; i++) {
1707             _safeMint(msg.sender, totalSupply());
1708         }
1709     }
1710     
1711     /*
1712      * Function to mint new NFTs during the presale
1713      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1714     */ 
1715     function mintNFTDuringPresale(
1716         uint256 _numOfTokens
1717     ) 
1718         public 
1719         payable
1720     {
1721         require(isActive, 'Contract is not active');
1722         require(isPresaleActive, 'Only whiteing from White List');
1723         require(whiteList[msg.sender], 'You are not on the White List');
1724         require(totalSupply() < MAX_NFT_PUBLIC, 'All public tokens have been minted');
1725         require(_numOfTokens <= WHITELIST_MAX_MINT, 'Cannot purchase this many tokens');
1726         require(totalSupply().add(_numOfTokens) <= MAX_NFT_PUBLIC, 'Purchase would exceed max public supply of NFTs');
1727         require(whiteListClaimed[msg.sender].add(_numOfTokens) <= WHITELIST_MAX_MINT, 'Purchase exceeds max whiteed');
1728         require(NFTPrice.mul(_numOfTokens) == msg.value, "Ether value sent is not correct");
1729         for (uint256 i = 0; i < _numOfTokens; i++) {
1730             
1731             whiteListClaimed[msg.sender] += 1;
1732             _safeMint(msg.sender, totalSupply());
1733         }
1734     }
1735     
1736     /*
1737      * Function to mint all NFTs for giveaway and partnerships
1738     */
1739     function mintByOwner(
1740         address _to, 
1741         uint256 _tokenId
1742     ) 
1743         public 
1744         onlyOwner
1745     {
1746         require(_tokenId > MAX_NFT_PUBLIC, "Tokens number to mint must exceed number of public tokens");
1747         require(_tokenId <= MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1748         _safeMint(_to, _tokenId);
1749     }
1750     
1751     /*
1752      * Function to get token URI of given token ID
1753      * URI will be blank untill totalSupply reaches MAX_NFT_PUBLIC
1754     */
1755     function tokenURI(
1756         uint256 _tokenId
1757     ) 
1758         public 
1759         view 
1760         virtual 
1761         override 
1762         returns (string memory) 
1763     {
1764         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1765         if (!reveal) {
1766             return string(abi.encodePacked(blindURI));
1767         } else {
1768             return string(abi.encodePacked(baseURI, _tokenId.toString()));
1769         }
1770     }
1771     
1772     function supportsInterface(
1773         bytes4 _interfaceId
1774     ) 
1775         public
1776         view 
1777         override (ERC721, ERC721Enumerable) 
1778         returns (bool) 
1779     {
1780         return super.supportsInterface(_interfaceId);
1781     }
1782 
1783     // Standard functions to be overridden 
1784     function _beforeTokenTransfer(
1785         address _from, 
1786         address _to, 
1787         uint256 _tokenId
1788     ) 
1789         internal 
1790         override(ERC721, ERC721Enumerable) 
1791     {
1792         super._beforeTokenTransfer(_from, _to, _tokenId);
1793     }
1794 }