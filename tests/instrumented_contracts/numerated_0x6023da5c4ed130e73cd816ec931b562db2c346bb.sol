1 pragma solidity ^0.8.0;
2 
3 
4 /*
5 
6     █████▀███████████████████████████████████████████████████████████████
7     █─▄▄▄▄██▀▄─██▄─▀█▀─▄█▄─▄▄─███▄─▄▄▀█▄─▄█─▄▄▄▄█▄─▄▄─██▀▄─██─▄▄▄▄█▄─▄▄─█
8     █─██▄─██─▀─███─█▄█─███─▄█▀████─██─██─██▄▄▄▄─██─▄█▀██─▀─██▄▄▄▄─██─▄█▀█
9     ▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀▄▄▄▀▄▄▄▄▄▀▀▀▄▄▄▄▀▀▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀
10 
11 
12                                        .:--==----:..                                      
13                                .:===----==+====-------::.:::                              
14                             .-+*##%###***+--===+---------:=+*-                            
15                          -*%%%%%%%%%%%%%%%%#+*+========---==-==.....                      
16                        :#%%%%%%%%%%%%%%%%%%%%%#+----=+=---==-:==***++=-.                  
17                       -#%%%%%@@@@@@@@@@@@@@@@@%%%*--------==----*#@@@%+--:-:              
18                       ###%%%%@@@@@@@@@@@@@@@@@@@@@%*=---=====--:++#@*==-:-==-             
19                     .=###%%%@@@@@@@%%%%%%%%@@@@@@@@@@*=--=+===--+*-#--:::-===             
20                    .==###%%%@@%%@@@%%#####%%@@@@@@@@@@@*==-=+=-=*#+#########=.            
21                   -*#*-##%%%%%#%%@@%%#**+*%%#*+++*#%@@@@%*====++#%%@#++==+*##:            
22                  --=--:-#%#%%%==++#%@%#==*%+=-++::--+%%@@@%+++=+%@@*==---:-=-=            
23                  .=----=+#++=---:=+#@@#==%#=-=%@#*--:*%%%%**#++*%@%+===-.:=+::            
24                 =##%#*-+*#**+++==**#@#+-=@#+==*##+==-*#***#%@@**@###%%%%%%##:             
25               .#@@@%@#=%@*#%%##%%%%%*+=-=*%%#*****+===+++=+*+#@%%#%@@@@@@@@@%.            
26                %@@@@@@***+++++***#*++==::==*%%#**++++++==-=+==*%#.*@@@@@@@@@@=            
27                 *@@@@@#+--==*###*#%%%%%%##+=***#**##*++++-.---:*@..+%##**+==:             
28                   :-==**++****++###%%%%##%#*=++++###****+- :--:#%+                        
29                       =#++++##%%@@@@@@%+%%#**#++*+##***+=..--:.***                        
30                       .#++*#*#%%%#**++###*+#@@%***##***=:.-=-..*+=                        
31                        +++%%#%%%#%%%@%%%@@%#%@@#**##**=::-=-::==:                         
32                        :**%#*@@@@@@@@@%%##%@@@%**###*=--=+=: :=-                          
33                         =#%%*%@@@%#*##*++*%@@@%=+##*==-=+=-::-.                           
34                          *%#%##@#+++%*++*%@@@%#:-**=====+=--=.                            
35                           *%#%##*+++%+==*%@@@#+-=+========--.                             
36                            -%#%#*++*#=+=+##%%#+=--===-==-=-:                              
37                             .#%%**+**===**%%#*+--====--===-                               
38                               **++++====**@#**=-====--====                                
39                               -%=+=+-==*+#%#*+=========--:                                
40                               +*+++==+**-%#*+=-==++===-=-                                 
41                              .#+++++=+==#**+=--=+++===--                                  
42                               +%@%#%*#+****=-=+++++=--=.                                  
43                                :+=*##*-+**+-=+++++==--:                                   
44                                   -+#****+==+++++=----                                    
45                                   :%###*+++++*+++---=.                                    
46                                   .:=%%###*****++----                                     
47                                      #@@%#*****+=-=-.                                     
48                                      :%@%#*****+----                                      
49                                       =%%##****+----                                      
50                                        +%##***+=--::                                      
51                                         #%#**++----:             
52 */
53 
54 // made with love for The Game Disease by tinque.
55 // dsc tinque@8854
56 
57 // SPDX-License-Identifier: MIT
58 
59 interface IERC165 {
60     /**
61      * @dev Returns true if this contract implements the interface defined by
62      * `interfaceId`. See the corresponding
63      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
64      * to learn more about how these ids are created.
65      *
66      * This function call must use less than 30 000 gas.
67      */
68     function supportsInterface(bytes4 interfaceId) external view returns (bool);
69 }
70 
71 
72 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
73 
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Required interface of an ERC721 compliant contract.
79  */
80 interface IERC721 is IERC165 {
81     /**
82      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
85 
86     /**
87      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
88      */
89     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
90 
91     /**
92      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
93      */
94     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
95 
96     /**
97      * @dev Returns the number of tokens in ``owner``'s account.
98      */
99     function balanceOf(address owner) external view returns (uint256 balance);
100 
101     /**
102      * @dev Returns the owner of the `tokenId` token.
103      *
104      * Requirements:
105      *
106      * - `tokenId` must exist.
107      */
108     function ownerOf(uint256 tokenId) external view returns (address owner);
109 
110     /**
111      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
112      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must exist and be owned by `from`.
119      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
120      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
121      *
122      * Emits a {Transfer} event.
123      */
124     function safeTransferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Transfers `tokenId` token from `from` to `to`.
132      *
133      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
134      *
135      * Requirements:
136      *
137      * - `from` cannot be the zero address.
138      * - `to` cannot be the zero address.
139      * - `tokenId` token must be owned by `from`.
140      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(
145         address from,
146         address to,
147         uint256 tokenId
148     ) external;
149 
150     /**
151      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
152      * The approval is cleared when the token is transferred.
153      *
154      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
155      *
156      * Requirements:
157      *
158      * - The caller must own the token or be an approved operator.
159      * - `tokenId` must exist.
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address to, uint256 tokenId) external;
164 
165     /**
166      * @dev Returns the account approved for `tokenId` token.
167      *
168      * Requirements:
169      *
170      * - `tokenId` must exist.
171      */
172     function getApproved(uint256 tokenId) external view returns (address operator);
173 
174     /**
175      * @dev Approve or remove `operator` as an operator for the caller.
176      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
177      *
178      * Requirements:
179      *
180      * - The `operator` cannot be the caller.
181      *
182      * Emits an {ApprovalForAll} event.
183      */
184     function setApprovalForAll(address operator, bool _approved) external;
185 
186     /**
187      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
188      *
189      * See {setApprovalForAll}
190      */
191     function isApprovedForAll(address owner, address operator) external view returns (bool);
192 
193     /**
194      * @dev Safely transfers `tokenId` token from `from` to `to`.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must exist and be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
203      *
204      * Emits a {Transfer} event.
205      */
206     function safeTransferFrom(
207         address from,
208         address to,
209         uint256 tokenId,
210         bytes calldata data
211     ) external;
212 }
213 
214 
215 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
216 
217 
218 
219 pragma solidity ^0.8.0;
220 
221 /**
222  * @title ERC721 token receiver interface
223  * @dev Interface for any contract that wants to support safeTransfers
224  * from ERC721 asset contracts.
225  */
226 interface IERC721Receiver {
227     /**
228      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
229      * by `operator` from `from`, this function is called.
230      *
231      * It must return its Solidity selector to confirm the token transfer.
232      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
233      *
234      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
235      */
236     function onERC721Received(
237         address operator,
238         address from,
239         uint256 tokenId,
240         bytes calldata data
241     ) external returns (bytes4);
242 }
243 
244 
245 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
246 
247 
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
253  * @dev See https://eips.ethereum.org/EIPS/eip-721
254  */
255 interface IERC721Metadata is IERC721 {
256     /**
257      * @dev Returns the token collection name.
258      */
259     function name() external view returns (string memory);
260 
261     /**
262      * @dev Returns the token collection symbol.
263      */
264     function symbol() external view returns (string memory);
265 
266     /**
267      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
268      */
269     function tokenURI(uint256 tokenId) external view returns (string memory);
270 }
271 
272 
273 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
274 
275 
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies on extcodesize, which returns 0 for contracts in
302         // construction, since the code is only stored at the end of the
303         // constructor execution.
304 
305         uint256 size;
306         assembly {
307             size := extcodesize(account)
308         }
309         return size > 0;
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         (bool success, ) = recipient.call{value: amount}("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain `call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value
386     ) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
392      * with `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         require(address(this).balance >= value, "Address: insufficient balance for call");
403         require(isContract(target), "Address: call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.call{value: value}(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
416         return functionStaticCall(target, data, "Address: low-level static call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a static call.
422      *
423      * _Available since v3.3._
424      */
425     function functionStaticCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal view returns (bytes memory) {
430         require(isContract(target), "Address: static call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.staticcall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
443         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         require(isContract(target), "Address: delegate call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.delegatecall(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
465      * revert reason using the provided one.
466      *
467      * _Available since v4.3._
468      */
469     function verifyCallResult(
470         bool success,
471         bytes memory returndata,
472         string memory errorMessage
473     ) internal pure returns (bytes memory) {
474         if (success) {
475             return returndata;
476         } else {
477             // Look for revert reason and bubble it up if present
478             if (returndata.length > 0) {
479                 // The easiest way to bubble the revert reason is using memory via assembly
480 
481                 assembly {
482                     let returndata_size := mload(returndata)
483                     revert(add(32, returndata), returndata_size)
484                 }
485             } else {
486                 revert(errorMessage);
487             }
488         }
489     }
490 }
491 
492 
493 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
494 
495 
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev Provides information about the current execution context, including the
501  * sender of the transaction and its data. While these are generally available
502  * via msg.sender and msg.data, they should not be accessed in such a direct
503  * manner, since when dealing with meta-transactions the account sending and
504  * paying for execution may not be the actual sender (as far as an application
505  * is concerned).
506  *
507  * This contract is only required for intermediate, library-like contracts.
508  */
509 abstract contract Context {
510     function _msgSender() internal view virtual returns (address) {
511         return msg.sender;
512     }
513 
514     function _msgData() internal view virtual returns (bytes calldata) {
515         return msg.data;
516     }
517 }
518 
519 
520 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
521 
522 
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev String operations.
528  */
529 library Strings {
530     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
534      */
535     function toString(uint256 value) internal pure returns (string memory) {
536         // Inspired by OraclizeAPI's implementation - MIT licence
537         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
538 
539         if (value == 0) {
540             return "0";
541         }
542         uint256 temp = value;
543         uint256 digits;
544         while (temp != 0) {
545             digits++;
546             temp /= 10;
547         }
548         bytes memory buffer = new bytes(digits);
549         while (value != 0) {
550             digits -= 1;
551             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
552             value /= 10;
553         }
554         return string(buffer);
555     }
556 
557     /**
558      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
559      */
560     function toHexString(uint256 value) internal pure returns (string memory) {
561         if (value == 0) {
562             return "0x00";
563         }
564         uint256 temp = value;
565         uint256 length = 0;
566         while (temp != 0) {
567             length++;
568             temp >>= 8;
569         }
570         return toHexString(value, length);
571     }
572 
573     /**
574      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
575      */
576     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
577         bytes memory buffer = new bytes(2 * length + 2);
578         buffer[0] = "0";
579         buffer[1] = "x";
580         for (uint256 i = 2 * length + 1; i > 1; --i) {
581             buffer[i] = _HEX_SYMBOLS[value & 0xf];
582             value >>= 4;
583         }
584         require(value == 0, "Strings: hex length insufficient");
585         return string(buffer);
586     }
587 }
588 
589 
590 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
591 
592 
593 
594 pragma solidity ^0.8.0;
595 
596 /**
597  * @dev Implementation of the {IERC165} interface.
598  *
599  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
600  * for the additional interface id that will be supported. For example:
601  *
602  * ```solidity
603  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
604  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
605  * }
606  * ```
607  *
608  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
609  */
610 abstract contract ERC165 is IERC165 {
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615         return interfaceId == type(IERC165).interfaceId;
616     }
617 }
618 
619 
620 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
621 
622 
623 
624 pragma solidity ^0.8.0;
625 
626 
627 
628 
629 
630 
631 
632 /**
633  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
634  * the Metadata extension, but not including the Enumerable extension, which is available separately as
635  * {ERC721Enumerable}.
636  */
637 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
638     using Address for address;
639     using Strings for uint256;
640 
641     // Token name
642     string private _name;
643 
644     // Token symbol
645     string private _symbol;
646 
647     // Mapping from token ID to owner address
648     mapping(uint256 => address) private _owners;
649 
650     // Mapping owner address to token count
651     mapping(address => uint256) private _balances;
652 
653     // Mapping from token ID to approved address
654     mapping(uint256 => address) private _tokenApprovals;
655 
656     // Mapping from owner to operator approvals
657     mapping(address => mapping(address => bool)) private _operatorApprovals;
658 
659     /**
660      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
661      */
662     constructor(string memory name_, string memory symbol_) {
663         _name = name_;
664         _symbol = symbol_;
665     }
666 
667     /**
668      * @dev See {IERC165-supportsInterface}.
669      */
670     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
671         return
672             interfaceId == type(IERC721).interfaceId ||
673             interfaceId == type(IERC721Metadata).interfaceId ||
674             super.supportsInterface(interfaceId);
675     }
676 
677     /**
678      * @dev See {IERC721-balanceOf}.
679      */
680     function balanceOf(address owner) public view virtual override returns (uint256) {
681         require(owner != address(0), "ERC721: balance query for the zero address");
682         return _balances[owner];
683     }
684 
685     /**
686      * @dev See {IERC721-ownerOf}.
687      */
688     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
689         address owner = _owners[tokenId];
690         require(owner != address(0), "ERC721: owner query for nonexistent token");
691         return owner;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-name}.
696      */
697     function name() public view virtual override returns (string memory) {
698         return _name;
699     }
700 
701     /**
702      * @dev See {IERC721Metadata-symbol}.
703      */
704     function symbol() public view virtual override returns (string memory) {
705         return _symbol;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-tokenURI}.
710      */
711     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
712         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
713 
714         string memory baseURI = _baseURI();
715         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
716     }
717 
718     /**
719      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
720      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
721      * by default, can be overriden in child contracts.
722      */
723     function _baseURI() internal view virtual returns (string memory) {
724         return "";
725     }
726 
727     /**
728      * @dev See {IERC721-approve}.
729      */
730     function approve(address to, uint256 tokenId) public virtual override {
731         address owner = ERC721.ownerOf(tokenId);
732         require(to != owner, "ERC721: approval to current owner");
733 
734         require(
735             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
736             "ERC721: approve caller is not owner nor approved for all"
737         );
738 
739         _approve(to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-getApproved}.
744      */
745     function getApproved(uint256 tokenId) public view virtual override returns (address) {
746         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
747 
748         return _tokenApprovals[tokenId];
749     }
750 
751     /**
752      * @dev See {IERC721-setApprovalForAll}.
753      */
754     function setApprovalForAll(address operator, bool approved) public virtual override {
755         require(operator != _msgSender(), "ERC721: approve to caller");
756 
757         _operatorApprovals[_msgSender()][operator] = approved;
758         emit ApprovalForAll(_msgSender(), operator, approved);
759     }
760 
761     /**
762      * @dev See {IERC721-isApprovedForAll}.
763      */
764     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
765         return _operatorApprovals[owner][operator];
766     }
767 
768     /**
769      * @dev See {IERC721-transferFrom}.
770      */
771     function transferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) public virtual override {
776         //solhint-disable-next-line max-line-length
777         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
778 
779         _transfer(from, to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         safeTransferFrom(from, to, tokenId, "");
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) public virtual override {
802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
803         _safeTransfer(from, to, tokenId, _data);
804     }
805 
806     /**
807      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
808      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
809      *
810      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
811      *
812      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
813      * implement alternative mechanisms to perform token transfer, such as signature-based.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must exist and be owned by `from`.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _safeTransfer(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) internal virtual {
830         _transfer(from, to, tokenId);
831         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
832     }
833 
834     /**
835      * @dev Returns whether `tokenId` exists.
836      *
837      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
838      *
839      * Tokens start existing when they are minted (`_mint`),
840      * and stop existing when they are burned (`_burn`).
841      */
842     function _exists(uint256 tokenId) internal view virtual returns (bool) {
843         return _owners[tokenId] != address(0);
844     }
845 
846     /**
847      * @dev Returns whether `spender` is allowed to manage `tokenId`.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
854         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
855         address owner = ERC721.ownerOf(tokenId);
856         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
857     }
858 
859     /**
860      * @dev Safely mints `tokenId` and transfers it to `to`.
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _safeMint(address to, uint256 tokenId) internal virtual {
870         _safeMint(to, tokenId, "");
871     }
872 
873     /**
874      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
875      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
876      */
877     function _safeMint(
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) internal virtual {
882         _mint(to, tokenId);
883         require(
884             _checkOnERC721Received(address(0), to, tokenId, _data),
885             "ERC721: transfer to non ERC721Receiver implementer"
886         );
887     }
888 
889     /**
890      * @dev Mints `tokenId` and transfers it to `to`.
891      *
892      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
893      *
894      * Requirements:
895      *
896      * - `tokenId` must not exist.
897      * - `to` cannot be the zero address.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _mint(address to, uint256 tokenId) internal virtual {
902         require(to != address(0), "ERC721: mint to the zero address");
903         require(!_exists(tokenId), "ERC721: token already minted");
904 
905         _beforeTokenTransfer(address(0), to, tokenId);
906 
907         _balances[to] += 1;
908         _owners[tokenId] = to;
909 
910         emit Transfer(address(0), to, tokenId);
911     }
912 
913     /**
914      * @dev Destroys `tokenId`.
915      * The approval is cleared when the token is burned.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _burn(uint256 tokenId) internal virtual {
924         address owner = ERC721.ownerOf(tokenId);
925 
926         _beforeTokenTransfer(owner, address(0), tokenId);
927 
928         // Clear approvals
929         _approve(address(0), tokenId);
930 
931         _balances[owner] -= 1;
932         delete _owners[tokenId];
933 
934         emit Transfer(owner, address(0), tokenId);
935     }
936 
937     /**
938      * @dev Transfers `tokenId` from `from` to `to`.
939      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
940      *
941      * Requirements:
942      *
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must be owned by `from`.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _transfer(
949         address from,
950         address to,
951         uint256 tokenId
952     ) internal virtual {
953         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
954         require(to != address(0), "ERC721: transfer to the zero address");
955 
956         _beforeTokenTransfer(from, to, tokenId);
957 
958         // Clear approvals from the previous owner
959         _approve(address(0), tokenId);
960 
961         _balances[from] -= 1;
962         _balances[to] += 1;
963         _owners[tokenId] = to;
964 
965         emit Transfer(from, to, tokenId);
966     }
967 
968     /**
969      * @dev Approve `to` to operate on `tokenId`
970      *
971      * Emits a {Approval} event.
972      */
973     function _approve(address to, uint256 tokenId) internal virtual {
974         _tokenApprovals[tokenId] = to;
975         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
976     }
977 
978     /**
979      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
980      * The call is not executed if the target address is not a contract.
981      *
982      * @param from address representing the previous owner of the given token ID
983      * @param to target address that will receive the tokens
984      * @param tokenId uint256 ID of the token to be transferred
985      * @param _data bytes optional data to send along with the call
986      * @return bool whether the call correctly returned the expected magic value
987      */
988     function _checkOnERC721Received(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) private returns (bool) {
994         if (to.isContract()) {
995             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
996                 return retval == IERC721Receiver.onERC721Received.selector;
997             } catch (bytes memory reason) {
998                 if (reason.length == 0) {
999                     revert("ERC721: transfer to non ERC721Receiver implementer");
1000                 } else {
1001                     assembly {
1002                         revert(add(32, reason), mload(reason))
1003                     }
1004                 }
1005             }
1006         } else {
1007             return true;
1008         }
1009     }
1010 
1011     /**
1012      * @dev Hook that is called before any token transfer. This includes minting
1013      * and burning.
1014      *
1015      * Calling conditions:
1016      *
1017      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1018      * transferred to `to`.
1019      * - When `from` is zero, `tokenId` will be minted for `to`.
1020      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1021      * - `from` and `to` are never both zero.
1022      *
1023      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1024      */
1025     function _beforeTokenTransfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) internal virtual {}
1030 }
1031 
1032 
1033 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
1034 
1035 
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 /**
1040  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1041  * @dev See https://eips.ethereum.org/EIPS/eip-721
1042  */
1043 interface IERC721Enumerable is IERC721 {
1044     /**
1045      * @dev Returns the total amount of tokens stored by the contract.
1046      */
1047     function totalSupply() external view returns (uint256);
1048 
1049     /**
1050      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1051      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1052      */
1053     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1054 
1055     /**
1056      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1057      * Use along with {totalSupply} to enumerate all tokens.
1058      */
1059     function tokenByIndex(uint256 index) external view returns (uint256);
1060 }
1061 
1062 
1063 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1064 
1065 
1066 
1067 pragma solidity ^0.8.0;
1068 
1069 
1070 /**
1071  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1072  * enumerability of all the token ids in the contract as well as all token ids owned by each
1073  * account.
1074  */
1075 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1076     // Mapping from owner to list of owned token IDs
1077     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1078 
1079     // Mapping from token ID to index of the owner tokens list
1080     mapping(uint256 => uint256) private _ownedTokensIndex;
1081 
1082     // Array with all token ids, used for enumeration
1083     uint256[] private _allTokens;
1084 
1085     // Mapping from token id to position in the allTokens array
1086     mapping(uint256 => uint256) private _allTokensIndex;
1087 
1088     /**
1089      * @dev See {IERC165-supportsInterface}.
1090      */
1091     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1092         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1097      */
1098     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1099         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1100         return _ownedTokens[owner][index];
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Enumerable-totalSupply}.
1105      */
1106     function totalSupply() public view virtual override returns (uint256) {
1107         return _allTokens.length;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Enumerable-tokenByIndex}.
1112      */
1113     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1114         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1115         return _allTokens[index];
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before any token transfer. This includes minting
1120      * and burning.
1121      *
1122      * Calling conditions:
1123      *
1124      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1125      * transferred to `to`.
1126      * - When `from` is zero, `tokenId` will be minted for `to`.
1127      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1128      * - `from` cannot be the zero address.
1129      * - `to` cannot be the zero address.
1130      *
1131      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1132      */
1133     function _beforeTokenTransfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) internal virtual override {
1138         super._beforeTokenTransfer(from, to, tokenId);
1139 
1140         if (from == address(0)) {
1141             _addTokenToAllTokensEnumeration(tokenId);
1142         } else if (from != to) {
1143             _removeTokenFromOwnerEnumeration(from, tokenId);
1144         }
1145         if (to == address(0)) {
1146             _removeTokenFromAllTokensEnumeration(tokenId);
1147         } else if (to != from) {
1148             _addTokenToOwnerEnumeration(to, tokenId);
1149         }
1150     }
1151 
1152     /**
1153      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1154      * @param to address representing the new owner of the given token ID
1155      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1156      */
1157     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1158         uint256 length = ERC721.balanceOf(to);
1159         _ownedTokens[to][length] = tokenId;
1160         _ownedTokensIndex[tokenId] = length;
1161     }
1162 
1163     /**
1164      * @dev Private function to add a token to this extension's token tracking data structures.
1165      * @param tokenId uint256 ID of the token to be added to the tokens list
1166      */
1167     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1168         _allTokensIndex[tokenId] = _allTokens.length;
1169         _allTokens.push(tokenId);
1170     }
1171 
1172     /**
1173      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1174      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1175      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1176      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1177      * @param from address representing the previous owner of the given token ID
1178      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1179      */
1180     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1181         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1182         // then delete the last slot (swap and pop).
1183 
1184         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1185         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1186 
1187         // When the token to delete is the last token, the swap operation is unnecessary
1188         if (tokenIndex != lastTokenIndex) {
1189             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1190 
1191             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1192             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1193         }
1194 
1195         // This also deletes the contents at the last position of the array
1196         delete _ownedTokensIndex[tokenId];
1197         delete _ownedTokens[from][lastTokenIndex];
1198     }
1199 
1200     /**
1201      * @dev Private function to remove a token from this extension's token tracking data structures.
1202      * This has O(1) time complexity, but alters the order of the _allTokens array.
1203      * @param tokenId uint256 ID of the token to be removed from the tokens list
1204      */
1205     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1206         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1207         // then delete the last slot (swap and pop).
1208 
1209         uint256 lastTokenIndex = _allTokens.length - 1;
1210         uint256 tokenIndex = _allTokensIndex[tokenId];
1211 
1212         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1213         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1214         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1215         uint256 lastTokenId = _allTokens[lastTokenIndex];
1216 
1217         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1218         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1219 
1220         // This also deletes the contents at the last position of the array
1221         delete _allTokensIndex[tokenId];
1222         _allTokens.pop();
1223     }
1224 }
1225 
1226 
1227 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1228 
1229 
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 /**
1234  * @dev Contract module which provides a basic access control mechanism, where
1235  * there is an account (an owner) that can be granted exclusive access to
1236  * specific functions.
1237  *
1238  * By default, the owner account will be the one that deploys the contract. This
1239  * can later be changed with {transferOwnership}.
1240  *
1241  * This module is used through inheritance. It will make available the modifier
1242  * `onlyOwner`, which can be applied to your functions to restrict their use to
1243  * the owner.
1244  */
1245 abstract contract Ownable is Context {
1246     address private _owner;
1247 
1248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1249 
1250     /**
1251      * @dev Initializes the contract setting the deployer as the initial owner.
1252      */
1253     constructor() {
1254         _setOwner(_msgSender());
1255     }
1256 
1257     /**
1258      * @dev Returns the address of the current owner.
1259      */
1260     function owner() public view virtual returns (address) {
1261         return _owner;
1262     }
1263 
1264     /**
1265      * @dev Throws if called by any account other than the owner.
1266      */
1267     modifier onlyOwner() {
1268         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1269         _;
1270     }
1271 
1272     /**
1273      * @dev Leaves the contract without owner. It will not be possible to call
1274      * `onlyOwner` functions anymore. Can only be called by the current owner.
1275      *
1276      * NOTE: Renouncing ownership will leave the contract without an owner,
1277      * thereby removing any functionality that is only available to the owner.
1278      */
1279     function renounceOwnership() public virtual onlyOwner {
1280         _setOwner(address(0));
1281     }
1282 
1283     /**
1284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1285      * Can only be called by the current owner.
1286      */
1287     function transferOwnership(address newOwner) public virtual onlyOwner {
1288         require(newOwner != address(0), "Ownable: new owner is the zero address");
1289         _setOwner(newOwner);
1290     }
1291 
1292     function _setOwner(address newOwner) private {
1293         address oldOwner = _owner;
1294         _owner = newOwner;
1295         emit OwnershipTransferred(oldOwner, newOwner);
1296     }
1297 }
1298 
1299 
1300 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.2
1301 
1302 
1303 
1304 pragma solidity ^0.8.0;
1305 
1306 // CAUTION
1307 // This version of SafeMath should only be used with Solidity 0.8 or later,
1308 // because it relies on the compiler's built in overflow checks.
1309 
1310 /**
1311  * @dev Wrappers over Solidity's arithmetic operations.
1312  *
1313  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1314  * now has built in overflow checking.
1315  */
1316 library SafeMath {
1317     /**
1318      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1319      *
1320      * _Available since v3.4._
1321      */
1322     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1323         unchecked {
1324             uint256 c = a + b;
1325             if (c < a) return (false, 0);
1326             return (true, c);
1327         }
1328     }
1329 
1330     /**
1331      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1332      *
1333      * _Available since v3.4._
1334      */
1335     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1336         unchecked {
1337             if (b > a) return (false, 0);
1338             return (true, a - b);
1339         }
1340     }
1341 
1342     /**
1343      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1344      *
1345      * _Available since v3.4._
1346      */
1347     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1348         unchecked {
1349             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1350             // benefit is lost if 'b' is also tested.
1351             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1352             if (a == 0) return (true, 0);
1353             uint256 c = a * b;
1354             if (c / a != b) return (false, 0);
1355             return (true, c);
1356         }
1357     }
1358 
1359     /**
1360      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1361      *
1362      * _Available since v3.4._
1363      */
1364     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1365         unchecked {
1366             if (b == 0) return (false, 0);
1367             return (true, a / b);
1368         }
1369     }
1370 
1371     /**
1372      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1373      *
1374      * _Available since v3.4._
1375      */
1376     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1377         unchecked {
1378             if (b == 0) return (false, 0);
1379             return (true, a % b);
1380         }
1381     }
1382 
1383     /**
1384      * @dev Returns the addition of two unsigned integers, reverting on
1385      * overflow.
1386      *
1387      * Counterpart to Solidity's `+` operator.
1388      *
1389      * Requirements:
1390      *
1391      * - Addition cannot overflow.
1392      */
1393     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1394         return a + b;
1395     }
1396 
1397     /**
1398      * @dev Returns the subtraction of two unsigned integers, reverting on
1399      * overflow (when the result is negative).
1400      *
1401      * Counterpart to Solidity's `-` operator.
1402      *
1403      * Requirements:
1404      *
1405      * - Subtraction cannot overflow.
1406      */
1407     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1408         return a - b;
1409     }
1410 
1411     /**
1412      * @dev Returns the multiplication of two unsigned integers, reverting on
1413      * overflow.
1414      *
1415      * Counterpart to Solidity's `*` operator.
1416      *
1417      * Requirements:
1418      *
1419      * - Multiplication cannot overflow.
1420      */
1421     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1422         return a * b;
1423     }
1424 
1425     /**
1426      * @dev Returns the integer division of two unsigned integers, reverting on
1427      * division by zero. The result is rounded towards zero.
1428      *
1429      * Counterpart to Solidity's `/` operator.
1430      *
1431      * Requirements:
1432      *
1433      * - The divisor cannot be zero.
1434      */
1435     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1436         return a / b;
1437     }
1438 
1439     /**
1440      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1441      * reverting when dividing by zero.
1442      *
1443      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1444      * opcode (which leaves remaining gas untouched) while Solidity uses an
1445      * invalid opcode to revert (consuming all remaining gas).
1446      *
1447      * Requirements:
1448      *
1449      * - The divisor cannot be zero.
1450      */
1451     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1452         return a % b;
1453     }
1454 
1455     /**
1456      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1457      * overflow (when the result is negative).
1458      *
1459      * CAUTION: This function is deprecated because it requires allocating memory for the error
1460      * message unnecessarily. For custom revert reasons use {trySub}.
1461      *
1462      * Counterpart to Solidity's `-` operator.
1463      *
1464      * Requirements:
1465      *
1466      * - Subtraction cannot overflow.
1467      */
1468     function sub(
1469         uint256 a,
1470         uint256 b,
1471         string memory errorMessage
1472     ) internal pure returns (uint256) {
1473         unchecked {
1474             require(b <= a, errorMessage);
1475             return a - b;
1476         }
1477     }
1478 
1479     /**
1480      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1481      * division by zero. The result is rounded towards zero.
1482      *
1483      * Counterpart to Solidity's `/` operator. Note: this function uses a
1484      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1485      * uses an invalid opcode to revert (consuming all remaining gas).
1486      *
1487      * Requirements:
1488      *
1489      * - The divisor cannot be zero.
1490      */
1491     function div(
1492         uint256 a,
1493         uint256 b,
1494         string memory errorMessage
1495     ) internal pure returns (uint256) {
1496         unchecked {
1497             require(b > 0, errorMessage);
1498             return a / b;
1499         }
1500     }
1501 
1502     /**
1503      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1504      * reverting with custom message when dividing by zero.
1505      *
1506      * CAUTION: This function is deprecated because it requires allocating memory for the error
1507      * message unnecessarily. For custom revert reasons use {tryMod}.
1508      *
1509      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1510      * opcode (which leaves remaining gas untouched) while Solidity uses an
1511      * invalid opcode to revert (consuming all remaining gas).
1512      *
1513      * Requirements:
1514      *
1515      * - The divisor cannot be zero.
1516      */
1517     function mod(
1518         uint256 a,
1519         uint256 b,
1520         string memory errorMessage
1521     ) internal pure returns (uint256) {
1522         unchecked {
1523             require(b > 0, errorMessage);
1524             return a % b;
1525         }
1526     }
1527 }
1528 
1529 
1530 
1531 pragma solidity ^0.8.0;
1532 
1533 
1534 // COMMENT ANDRE: add merkle
1535 // import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
1536 
1537 
1538 contract Splitter is Context {
1539     using SafeMath for uint256;
1540     event PaymentReceived(address from, uint256 amount);
1541 
1542     uint256 private _totalShares;
1543     uint256 private _totalReleased;
1544     uint256[5] private _shares;
1545     uint256[5] private _released;
1546     uint256[5] private _payeeOutputIndex;
1547     address[][5] private _payeeAccounts;
1548 
1549     constructor() {
1550         uint payee = 0;
1551 
1552         _shares[payee] = 95;
1553         _payeeAccounts[payee].push(0xC63f9B0000B7c346d97CC82A0513720023B78AB3);
1554         _payeeAccounts[payee].push(0x41957aDA7C03Ea49B991FcBde56a9AE205dE7b13);
1555         _payeeAccounts[payee].push(0x9090f44F984468f29a2F94913fff24043B5E4776);
1556 
1557         payee++;
1558 
1559         _shares[payee] = 95;
1560         _payeeAccounts[payee].push(0x630E495249FA4050e781f3B803C4e8C9c4d6ceBC);
1561         _payeeAccounts[payee].push(0x41957aDA7C03Ea49B991FcBde56a9AE205dE7b13);
1562         _payeeAccounts[payee].push(0x9090f44F984468f29a2F94913fff24043B5E4776);
1563 
1564         payee++;
1565         _payeeAccounts[payee].push(0x4107705D474bEB1361Cd594C4043D4d0d0a4E22b);
1566         _payeeAccounts[payee].push(0x41957aDA7C03Ea49B991FcBde56a9AE205dE7b13);
1567         _payeeAccounts[payee].push(0x9090f44F984468f29a2F94913fff24043B5E4776);
1568         _shares[payee] = 95;
1569 
1570         payee++;
1571         _payeeAccounts[payee].push(0x47E56C9921fD2847EE51d8020E8954a4a1b94F71);
1572         _payeeAccounts[payee].push(0x9090f44F984468f29a2F94913fff24043B5E4776);
1573         _payeeAccounts[payee].push(0x41957aDA7C03Ea49B991FcBde56a9AE205dE7b13);
1574         _shares[payee] = 95;
1575 
1576         payee++;
1577         _payeeAccounts[payee].push(0x2784A0aa97985709dAE212112C3Ab2E6f7347143);
1578         _payeeAccounts[payee].push(0x9090f44F984468f29a2F94913fff24043B5E4776);
1579         _shares[payee] = 20;
1580 
1581         _totalShares = _shares[0] + _shares[1] + _shares[2] + _shares[3] + _shares[4];
1582     }
1583 
1584 
1585     receive () external payable {
1586         emit PaymentReceived(_msgSender(), msg.value);
1587     }
1588 
1589     function isActivePayee(address addr) private view returns (bool) {
1590         return  _payeeAccounts[0][_payeeOutputIndex[0]] == addr || 
1591                 _payeeAccounts[1][_payeeOutputIndex[1]] == addr || 
1592                 _payeeAccounts[2][_payeeOutputIndex[2]] == addr || 
1593                 _payeeAccounts[3][_payeeOutputIndex[3]] == addr || 
1594                 _payeeAccounts[4][_payeeOutputIndex[4]] == addr;
1595     }
1596 
1597 
1598     function release() public {
1599         require(isActivePayee(msg.sender), 'not an active payee');
1600 
1601         for (uint256 i = 0; i < _payeeAccounts.length; i++) {
1602             uint256 totalReceived = address(this).balance.add(_totalReleased);
1603             uint256 payment = totalReceived.mul(_shares[i]).div(_totalShares).sub(_released[i]);
1604             if (payment > 0) {
1605                 _released[i] = _released[i].add(payment);
1606                 _totalReleased = _totalReleased.add(payment);
1607                 address account = _payeeAccounts[i][_payeeOutputIndex[i]];
1608                 Address.sendValue(payable(account), payment);
1609             }
1610         }
1611     }
1612 
1613     function respawn(uint256 payeeIndex) public {
1614         require(isActivePayee(msg.sender), 'not an active payee');
1615         require(payeeIndex < 5, 'invalid payee index');
1616         require(_payeeOutputIndex[payeeIndex] < _payeeAccounts[payeeIndex].length - 1, "No more respawns");
1617         _payeeOutputIndex[payeeIndex] += 1;
1618     }
1619 }
1620 
1621 contract GameDisease is ERC721, Ownable, Splitter, ERC721Enumerable {
1622   using SafeMath for uint256;
1623 
1624     event gifted(uint256 indexed tokenId, address indexed to);
1625     event minted(uint256 indexed tokenId, address indexed by);
1626     event bought(uint256 indexed tokenId, address indexed by);
1627     event PermanentURI(string _value, uint256 indexed _id);
1628 
1629     mapping(address => bool) public EARLY_BIRDS;
1630 
1631     string public PROVENANCE_HASH = "611f8478445246ab15a022c42642210f479a47e863a012d8a84fe53ff8fe5e7c";
1632 
1633     address public OG_COLLECTION_1 = 0x1c903a2F35Fb7c6dC1792dAeC11c033f8B222D5B;
1634     address public OG_COLLECTION_2 = 0x83815C9D5790bdDc2B83490D13412E6Abb2BEbBe;
1635     uint256 public OGS_GIFT_ALLOCATION = 661;
1636     uint256 public TEAM_ALLOCATION = 60;
1637     uint256 public MAX_SUPPLY = 9999;
1638     uint256 public OPEN_SALE_MAX_MINTS_PER_WALLET = 15;
1639     uint256 public EARLY_BIRD_WHITELIST_MINTS = 3;
1640     uint256 public MINT_PRICE = 0.2 ether;
1641     
1642     // 13hs EST 28/10/2021
1643     uint256 public EARLY_BIRD_START = 1635440400;
1644     // 17hs EST 28/10/2021
1645     uint256 public SALE_START = 1635454800;
1646     // 17hs EST 29/10/201
1647     uint256 public OG_GIFT_CLAIM_END = 1635541200;
1648     // 13hs EST 1/11/2021
1649     uint256 public REVEAL = 1635786000;
1650 
1651     uint256 public reserved = OGS_GIFT_ALLOCATION + TEAM_ALLOCATION;
1652     uint256 public infected = 0;
1653     uint256 public claimedgifts = 0;
1654     uint8 public baseUriChanges = 0;
1655     string public baseUri;
1656     bool public shuffled = false;
1657     uint256 public shuffleOffset = 0;
1658     uint256 public lastBlockHash = 0;
1659     mapping(address => bool) public earlyMinters;
1660     mapping(address => uint256) public openSaleMinters;
1661     mapping(address => bool) public giftClaimers;
1662     mapping(address => mapping(uint256 => bool)) OGS_claimed_gifts;
1663     mapping(address => mapping(uint256 => bool)) OGS_early_mints;
1664 
1665     constructor() ERC721("GameDisease", "GD")
1666     {   
1667         // placeholder metadata
1668         baseUri = "ipfs://QmTnfpW6bf1MWcHX3PAQKeb3eMrhxF3Uzj8iGxoeNsFdfa/";
1669     }
1670 
1671     /* private */
1672 
1673     function tokenReward(address collection, uint256 tokenId) view private returns (uint256) {
1674         uint256 rewards = 0;
1675         if (collection == OG_COLLECTION_1) {
1676             if (tokenId == 19600030001) {
1677                 rewards += 20; // How much am I w0rth? https://opensea.io/assets/0x1c903a2F35Fb7c6dC1792dAeC11c033f8B222D5B/19600030001
1678             } else if (tokenId >= 19600010001 && tokenId <= 19600010023) {
1679                 rewards += 6; // How I l0st my last days https://opensea.io/assets/0x1c903a2F35Fb7c6dC1792dAeC11c033f8B222D5B/19600010001
1680             } else if (tokenId >= 19600020001 && tokenId <= 19600020043) {
1681                 rewards += 4; // TO TH3 M000000000000N https://opensea.io/assets/0x1c903a2F35Fb7c6dC1792dAeC11c033f8B222D5B/19600020001
1682             } else if (tokenId >= 19600040001 && tokenId <= 19600040150) {
1683                 rewards += 3; // I'm 0 years old and I'm a crypto artist https://opensea.io/assets/0x1c903a2F35Fb7c6dC1792dAeC11c033f8B222D5B/19600040001
1684             }
1685         } else if (collection == OG_COLLECTION_2) {
1686             if (tokenId >= 35900010001 && tokenId <= 35900010010) {
1687                 rewards += 8; // HYP3 BOI https://opensea.io/assets/0x83815c9d5790bddc2b83490d13412e6abb2bebbe/35900010001
1688             } else if (tokenId >= 35900020001 && tokenId <= 35900020100) {
1689                 rewards += 4; // Mamabicho's Pilgrimage https://opensea.io/assets/0x83815c9d5790bddc2b83490d13412e6abb2bebbe/35900020001
1690             } else if (tokenId >= 35900030001 && tokenId <= 35900030333) {
1691                 rewards += 3; // Rat in a $ofa https://opensea.io/assets/0x83815c9d5790bddc2b83490d13412e6abb2bebbe/35900030001
1692             }
1693         }
1694         return rewards;
1695     }
1696 
1697 
1698     function claimOGEarlyMintReward() private returns (uint256){
1699         uint256 earlyMints = 0;
1700         address[2] memory collections = [OG_COLLECTION_1, OG_COLLECTION_2];
1701         for (uint256 j = 0; j < collections.length; j++) {
1702             address collection = collections[j];
1703             uint256 balance = ERC721Enumerable(collection).balanceOf(msg.sender);
1704             for (uint256 i = 0; i < balance; i++) {
1705                 uint256 tokenId = ERC721Enumerable(collection).tokenOfOwnerByIndex(msg.sender, i);
1706                 if (!OGS_early_mints[collection][tokenId]) {
1707                     OGS_early_mints[collection][tokenId] = true;
1708                     earlyMints += tokenReward(collection, tokenId);
1709                 } 
1710             }
1711         }
1712         return earlyMints;
1713     }
1714 
1715 
1716     function mint(uint256 tokenId) private returns (uint256) {
1717         require(totalSupply() < MAX_SUPPLY, 'no more tokens left');
1718         _safeMint(msg.sender, tokenId);
1719         emit minted(tokenId, msg.sender);
1720         return tokenId;
1721     }
1722 
1723 
1724     /* owner */
1725 
1726     function setBaseURI(string memory newBaseURI) public onlyOwner {
1727         require(baseUriChanges < 3, 'out of attempts');
1728         baseUriChanges += 1;
1729         baseUri = newBaseURI;
1730     }
1731 
1732     function reveal() public onlyOwner {
1733         require(block.timestamp > REVEAL, 'not yet');
1734         require(!shuffled, 'can only reveal once');
1735         shuffled = true;
1736         shuffleOffset = lastBlockHash % MAX_SUPPLY;
1737     }
1738 
1739     function whitelist(address[] memory addresses) public onlyOwner {
1740         require(block.timestamp < EARLY_BIRD_START, 'too late');
1741         for (uint256 i = 0; i < addresses.length; i++) {
1742             EARLY_BIRDS[addresses[i]] = true;
1743         }
1744     }
1745 
1746     function perish(uint256 amount) public onlyOwner {        
1747         require(reserved > 0, 'its all done now');
1748         require(amount > 0, 'amount is <= 0');
1749         require(block.timestamp > OG_GIFT_CLAIM_END, "gifts havent ended yet");
1750         while (reserved > 0 && amount > 0) {
1751             uint256 tokenId = MAX_SUPPLY - claimedgifts;
1752             mint(tokenId);
1753             emit gifted(tokenId, msg.sender);
1754             claimedgifts+=1;
1755             reserved-=1;
1756             amount-=1;
1757         }
1758     }
1759 
1760 
1761     /* views */
1762 
1763     function _baseURI() internal view override returns (string memory) {
1764         return baseUri;
1765     }
1766 
1767     function checkRemainingMints() public view returns (uint256) {
1768         uint256 remaining = OPEN_SALE_MAX_MINTS_PER_WALLET - openSaleMinters[msg.sender];
1769         uint256 available = MAX_SUPPLY - totalSupply().add(reserved);       
1770         return remaining <= available ? remaining : available;
1771     }
1772 
1773     function checkEarlyMintReward() public view returns (uint256) {
1774         if (earlyMinters[msg.sender]) {
1775             return 0;
1776         }
1777 
1778         int256 available = int256(MAX_SUPPLY - totalSupply().add(reserved));       
1779         if (available <= 0) {
1780             return 0;
1781         }
1782 
1783         uint256 reward = 0;
1784         if (EARLY_BIRDS[msg.sender]) {  
1785             reward += EARLY_BIRD_WHITELIST_MINTS;
1786         }
1787 
1788         address[2] memory collections = [OG_COLLECTION_1, OG_COLLECTION_2];
1789         for (uint256 j = 0; j < collections.length; j++) {
1790             address collection = collections[j];
1791             uint256 balance = ERC721Enumerable(collection).balanceOf(msg.sender);
1792             for (uint256 i = 0; i < balance; i++) {
1793                 uint256 tokenId = ERC721Enumerable(collection).tokenOfOwnerByIndex(msg.sender, i);
1794                 if (!OGS_early_mints[collection][tokenId]) {
1795                     reward += tokenReward(collection, tokenId);
1796                 } 
1797             }
1798         }
1799 
1800         return reward <= uint256(available) ? reward : uint256(available);
1801     }
1802     
1803     function checkGiftReward() public view returns (uint256) {
1804         if (giftClaimers[msg.sender]) {
1805             return 0;
1806         }
1807 
1808         int256 remainingGifts = int256(reserved - TEAM_ALLOCATION);
1809         if (remainingGifts <= 0) {
1810             return 0;
1811         }
1812 
1813         uint256 gifts = 0;
1814         address[2] memory collections = [OG_COLLECTION_1, OG_COLLECTION_2];
1815         for (uint256 j = 0; j < collections.length; j++) {
1816             address collection = collections[j];
1817             uint256 balance = ERC721Enumerable(collection).balanceOf(msg.sender);
1818             for (uint256 i = 0; i < balance; i++) {
1819                 uint256 tokenId = ERC721Enumerable(collection).tokenOfOwnerByIndex(msg.sender, i);
1820                 uint256 rewards = tokenReward(collection, tokenId);
1821                 if (rewards > 0 && !OGS_claimed_gifts[collection][tokenId]) {
1822                     gifts += 1;
1823                 }
1824             }
1825         }
1826         
1827         return gifts <= uint256(remainingGifts) ? gifts : uint256(remainingGifts);
1828     }
1829 
1830 
1831     /* public */
1832 
1833     function spreadDiseases(uint amount) public payable {
1834         require(amount > 0, "what are you doing?");
1835         require(block.timestamp > EARLY_BIRD_START, "Get out");
1836         require(MINT_PRICE.mul(amount) <= msg.value, "won't cut");
1837         uint256 available = MAX_SUPPLY - totalSupply().add(reserved);
1838         require(available > 0, "there are no more left");
1839         require(amount <= available, 'sorry, I cant return the change.');
1840 
1841         if (block.timestamp < SALE_START) {
1842             require(!earlyMinters[msg.sender], 'already minted early bird');
1843             earlyMinters[msg.sender] = true;
1844             uint256 earlyMintAmount = 0;
1845             if (EARLY_BIRDS[msg.sender]) {
1846                 earlyMintAmount += EARLY_BIRD_WHITELIST_MINTS;
1847             }
1848             earlyMintAmount += claimOGEarlyMintReward();
1849             require(earlyMintAmount > 0, 'no early mints for you');
1850             require(amount <= earlyMintAmount, 'early mint limit exceeded');
1851         } else {
1852             int256 remainingMints = int256(OPEN_SALE_MAX_MINTS_PER_WALLET) - int256(openSaleMinters[msg.sender]);
1853             require(remainingMints > 0, 'minted too much with this wallet');
1854             require(amount <= uint256(remainingMints), 'sorry, I cant return the change.');
1855             openSaleMinters[msg.sender] += amount;
1856         }
1857         
1858         for(uint i = 0; i < amount; i++) {
1859             uint256 tokenId = ++infected;
1860             mint(tokenId);
1861             emit bought(tokenId, msg.sender);
1862         }
1863 
1864         lastBlockHash = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
1865     }
1866 
1867     function OGGift() public {
1868         require(block.timestamp > EARLY_BIRD_START, "Get out");
1869         require(block.timestamp < OG_GIFT_CLAIM_END, "too late");
1870         require(!giftClaimers[msg.sender], 'can only claim gifts once');
1871         giftClaimers[msg.sender] = true;
1872         int256 remaining = int256(reserved - TEAM_ALLOCATION);
1873         require(remaining > 0, 'im sorry');
1874 
1875         uint256 gifts = 0;
1876         address[2] memory collections = [OG_COLLECTION_1, OG_COLLECTION_2];
1877         for (uint256 j = 0; j < collections.length; j++) {
1878             address collection = collections[j];
1879             uint256 balance = ERC721Enumerable(collection).balanceOf(msg.sender);
1880             for (uint256 i = 0; i < balance; i++) {
1881                 uint256 tokenId = ERC721Enumerable(collection).tokenOfOwnerByIndex(msg.sender, i);
1882                 uint256 rewards = tokenReward(collection, tokenId);
1883                 if (rewards > 0 && !OGS_claimed_gifts[collection][tokenId]) {
1884                     OGS_claimed_gifts[collection][tokenId] = true;
1885                     gifts += 1;
1886                 }
1887             }
1888         }
1889         require(gifts > 0, 'no gifts for you');
1890 
1891         uint256 amount = gifts < uint256(remaining) ? gifts : uint256(remaining);
1892         for (uint256 i = 0; i < amount; i++) {
1893             // gifts get last tokens.
1894             uint256 tokenId = MAX_SUPPLY - claimedgifts - i;
1895             mint(tokenId);
1896             emit gifted(tokenId, msg.sender);
1897         }
1898         reserved -= amount;
1899         claimedgifts += amount;
1900     }
1901 
1902 
1903     /* neccesary overridings, i guess */
1904 
1905     function _beforeTokenTransfer(
1906         address from,
1907         address to,
1908         uint256 tokenId
1909     ) internal virtual override(ERC721, ERC721Enumerable) {
1910         super._beforeTokenTransfer(from, to, tokenId);
1911     }
1912 
1913     function supportsInterface(bytes4 interfaceId)
1914         public
1915         view
1916         virtual
1917         override(ERC721, ERC721Enumerable)
1918         returns (bool)
1919     {
1920         return super.supportsInterface(interfaceId);
1921     }
1922 }