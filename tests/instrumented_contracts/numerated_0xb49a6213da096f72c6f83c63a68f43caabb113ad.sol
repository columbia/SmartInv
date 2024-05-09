1 /*
2 
3                                              
4                             ::::::::::::::::::::::::::::::::::                            
5                             #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                            
6                       :%%%%%***@@@============================%%%%%+                      
7                    .==+*****+++@@@----------------------------******==:                   
8                  ..-@@#---==+**@@@---------------------------------+@@+..                 
9                  @@%-----=++%@@---------------------------------------*@@:                
10               +##+++-----=++%@@---------------------------------------+**###              
11               #@@-----===+**@@@+++++=----------------=+++++++++++-----=++%@@              
12               #@@-----=++#@@@@@@@@@@#----------------*@@@@@@@@@@%--------%@@              
13            +%%***+++++*@@+..........-@@*----------+@@+..........-@@#-----+**%%%           
14            *@@%#######*++:          .++***=-----***++:  :========+++**+--+++@@@           
15            *@@@@@@@@@@*                =@@+-----@@#     *@@@@@@@#  -@@*--+++@@@           
16            *@@*++--+@@*                =@@+-----@@#     *@@@@@@@#  -@@*--+++@@@           
17            *@@*++--+@@*                =@@+-----@@#     *@@@@@@@#  -@@*--+++@@@           
18         .::*%%*++--+@@*  .:::::        =@@+-----@@#     =#######+  -@@*--=++%%%::.        
19         =@@#++=----+@@*  =@@@@@        =@@+-----@@#                -@@*-----+++@@*        
20         =@@#++=----+@@#::*@@@@@      ::*@@+-----@@%::.           ::=@@*-----+++@@*        
21         =@@#++=----=##*++******.....:++*##=-----##*++-..........:++*##+-----+++@@*        
22         =@@#++=-------+@@*::::::::::+@@*----------+@@*::::::::::=@@#--------+++@@*        
23         =@@#++=----------*@@@@@@@@@@#----------------*@@@@@@@@@@%-----------+++@@*        
24         =@@#++=----------+**********+----------------+**********+-----------+++@@*        
25         =@@#++=-------------------------------------------------------------+++@@*        
26         =@@#++=-------------------------------------------------------------+++@@*        
27         =@@#+++++--------------@@@@@@@@@@@@@@@@@@@@@@@@@@@@+-------------++++++@@*        
28         =@@#+++++--------------###@@@@@@@@@@@@@@@@@@@@@@%##=-------------++++++@@*        
29         =@@#+++++-----------------@@@@@@@@@@@@@@@@@@@@@@+----------------++++++@@*        
30            *@@*+++++--------------------------------------------------=+++++@@@           
31            *@@*+++++--------------------------------------------------=+++++@@@           
32            +%%***+++=====----------------------------------------======++***%%%           
33               #@@++++++++=--------------------------------------=++++++++%@@              
34               .::%%%%%#++++++++----------------------------=+++++++*%%%%%=::              
35                  +++++*########============================*#######*+++++.                
36                       -@@@@@@@@++++++++++++++++++++++++++++%@@@@@@@*                      
37                                @@@@@@@@@@@@@@@@@@@@@@@@@@@@:                              
38                                ============================.                              
39                                                                  
40 
41 ## KEVolution is an experimental play to win blockchain gaming event and meme based series of 5 derivative NFT sets. ##
42 ## Find matches between sets to win a share of 270 ETH in prizes and free mints galore. ##
43 
44 https://kevolution.art
45 https://twitter.com/kevolutionNFTs
46 
47 */
48 
49 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Interface of the ERC165 standard, as defined in the
57  * https://eips.ethereum.org/EIPS/eip-165[EIP].
58  *
59  * Implementers can declare support of contract interfaces, which can then be
60  * queried by others ({ERC165Checker}).
61  *
62  * For an implementation, see {ERC165}.
63  */
64 interface IERC165 {
65     /**
66      * @dev Returns true if this contract implements the interface defined by
67      * `interfaceId`. See the corresponding
68      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
69      * to learn more about how these ids are created.
70      *
71      * This function call must use less than 30 000 gas.
72      */
73     function supportsInterface(bytes4 interfaceId) external view returns (bool);
74 }
75 
76 
77 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
78 
79 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
80 
81 
82 /**
83  * @dev Required interface of an ERC721 compliant contract.
84  */
85 interface IERC721 is IERC165 {
86     /**
87      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
90 
91     /**
92      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
93      */
94     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
95 
96     /**
97      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
98      */
99     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
100 
101     /**
102      * @dev Returns the number of tokens in ``owner``'s account.
103      */
104     function balanceOf(address owner) external view returns (uint256 balance);
105 
106     /**
107      * @dev Returns the owner of the `tokenId` token.
108      *
109      * Requirements:
110      *
111      * - `tokenId` must exist.
112      */
113     function ownerOf(uint256 tokenId) external view returns (address owner);
114 
115     /**
116      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
117      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must exist and be owned by `from`.
124      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
125      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
126      *
127      * Emits a {Transfer} event.
128      */
129     function safeTransferFrom(
130         address from,
131         address to,
132         uint256 tokenId
133     ) external;
134 
135     /**
136      * @dev Transfers `tokenId` token from `from` to `to`.
137      *
138      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
139      *
140      * Requirements:
141      *
142      * - `from` cannot be the zero address.
143      * - `to` cannot be the zero address.
144      * - `tokenId` token must be owned by `from`.
145      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(
150         address from,
151         address to,
152         uint256 tokenId
153     ) external;
154 
155     /**
156      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
157      * The approval is cleared when the token is transferred.
158      *
159      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
160      *
161      * Requirements:
162      *
163      * - The caller must own the token or be an approved operator.
164      * - `tokenId` must exist.
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address to, uint256 tokenId) external;
169 
170     /**
171      * @dev Returns the account approved for `tokenId` token.
172      *
173      * Requirements:
174      *
175      * - `tokenId` must exist.
176      */
177     function getApproved(uint256 tokenId) external view returns (address operator);
178 
179     /**
180      * @dev Approve or remove `operator` as an operator for the caller.
181      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
182      *
183      * Requirements:
184      *
185      * - The `operator` cannot be the caller.
186      *
187      * Emits an {ApprovalForAll} event.
188      */
189     function setApprovalForAll(address operator, bool _approved) external;
190 
191     /**
192      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
193      *
194      * See {setApprovalForAll}
195      */
196     function isApprovedForAll(address owner, address operator) external view returns (bool);
197 
198     /**
199      * @dev Safely transfers `tokenId` token from `from` to `to`.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must exist and be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
207      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
208      *
209      * Emits a {Transfer} event.
210      */
211     function safeTransferFrom(
212         address from,
213         address to,
214         uint256 tokenId,
215         bytes calldata data
216     ) external;
217 }
218 
219 
220 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
221 
222 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
223 
224 
225 /**
226  * @title ERC721 token receiver interface
227  * @dev Interface for any contract that wants to support safeTransfers
228  * from ERC721 asset contracts.
229  */
230 interface IERC721Receiver {
231     /**
232      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
233      * by `operator` from `from`, this function is called.
234      *
235      * It must return its Solidity selector to confirm the token transfer.
236      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
237      *
238      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
239      */
240     function onERC721Received(
241         address operator,
242         address from,
243         uint256 tokenId,
244         bytes calldata data
245     ) external returns (bytes4);
246 }
247 
248 
249 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
250 
251 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
252 
253 
254 /**
255  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
256  * @dev See https://eips.ethereum.org/EIPS/eip-721
257  */
258 interface IERC721Metadata is IERC721 {
259     /**
260      * @dev Returns the token collection name.
261      */
262     function name() external view returns (string memory);
263 
264     /**
265      * @dev Returns the token collection symbol.
266      */
267     function symbol() external view returns (string memory);
268 
269     /**
270      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
271      */
272     function tokenURI(uint256 tokenId) external view returns (string memory);
273 }
274 
275 
276 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
279 
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         uint256 size;
308         assembly {
309             size := extcodesize(account)
310         }
311         return size > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain `call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         require(isContract(target), "Address: call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.call{value: value}(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
418         return functionStaticCall(target, data, "Address: low-level static call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
467      * revert reason using the provided one.
468      *
469      * _Available since v4.3._
470      */
471     function verifyCallResult(
472         bool success,
473         bytes memory returndata,
474         string memory errorMessage
475     ) internal pure returns (bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 
495 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
498 
499 
500 /**
501  * @dev Provides information about the current execution context, including the
502  * sender of the transaction and its data. While these are generally available
503  * via msg.sender and msg.data, they should not be accessed in such a direct
504  * manner, since when dealing with meta-transactions the account sending and
505  * paying for execution may not be the actual sender (as far as an application
506  * is concerned).
507  *
508  * This contract is only required for intermediate, library-like contracts.
509  */
510 abstract contract Context {
511     function _msgSender() internal view virtual returns (address) {
512         return msg.sender;
513     }
514 
515     function _msgData() internal view virtual returns (bytes calldata) {
516         return msg.data;
517     }
518 }
519 
520 
521 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
524 
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
590 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
591 
592 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
593 
594 
595 /**
596  * @dev Implementation of the {IERC165} interface.
597  *
598  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
599  * for the additional interface id that will be supported. For example:
600  *
601  * ```solidity
602  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
604  * }
605  * ```
606  *
607  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
608  */
609 abstract contract ERC165 is IERC165 {
610     /**
611      * @dev See {IERC165-supportsInterface}.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614         return interfaceId == type(IERC165).interfaceId;
615     }
616 }
617 
618 
619 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.2
620 
621 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
622 
623 
624 
625 
626 
627 
628 
629 
630 /**
631  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
632  * the Metadata extension, but not including the Enumerable extension, which is available separately as
633  * {ERC721Enumerable}.
634  */
635 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
636     using Address for address;
637     using Strings for uint256;
638 
639     // Token name
640     string private _name;
641 
642     // Token symbol
643     string private _symbol;
644 
645     // Mapping from token ID to owner address
646     mapping(uint256 => address) private _owners;
647 
648     // Mapping owner address to token count
649     mapping(address => uint256) private _balances;
650 
651     // Mapping from token ID to approved address
652     mapping(uint256 => address) private _tokenApprovals;
653 
654     // Mapping from owner to operator approvals
655     mapping(address => mapping(address => bool)) private _operatorApprovals;
656 
657     /**
658      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
659      */
660     constructor(string memory name_, string memory symbol_) {
661         _name = name_;
662         _symbol = symbol_;
663     }
664 
665     /**
666      * @dev See {IERC165-supportsInterface}.
667      */
668     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
669         return
670             interfaceId == type(IERC721).interfaceId ||
671             interfaceId == type(IERC721Metadata).interfaceId ||
672             super.supportsInterface(interfaceId);
673     }
674 
675     /**
676      * @dev See {IERC721-balanceOf}.
677      */
678     function balanceOf(address owner) public view virtual override returns (uint256) {
679         require(owner != address(0), "ERC721: balance query for the zero address");
680         return _balances[owner];
681     }
682 
683     /**
684      * @dev See {IERC721-ownerOf}.
685      */
686     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
687         address owner = _owners[tokenId];
688         require(owner != address(0), "ERC721: owner query for nonexistent token");
689         return owner;
690     }
691 
692     /**
693      * @dev See {IERC721Metadata-name}.
694      */
695     function name() public view virtual override returns (string memory) {
696         return _name;
697     }
698 
699     /**
700      * @dev See {IERC721Metadata-symbol}.
701      */
702     function symbol() public view virtual override returns (string memory) {
703         return _symbol;
704     }
705 
706     /**
707      * @dev See {IERC721Metadata-tokenURI}.
708      */
709     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
710         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
711 
712         string memory baseURI = _baseURI();
713         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
714     }
715 
716     /**
717      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
718      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
719      * by default, can be overriden in child contracts.
720      */
721     function _baseURI() internal view virtual returns (string memory) {
722         return "";
723     }
724 
725     /**
726      * @dev See {IERC721-approve}.
727      */
728     function approve(address to, uint256 tokenId) public virtual override {
729         address owner = ERC721.ownerOf(tokenId);
730         require(to != owner, "ERC721: approval to current owner");
731 
732         require(
733             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
734             "ERC721: approve caller is not owner nor approved for all"
735         );
736 
737         _approve(to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-getApproved}.
742      */
743     function getApproved(uint256 tokenId) public view virtual override returns (address) {
744         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
745 
746         return _tokenApprovals[tokenId];
747     }
748 
749     /**
750      * @dev See {IERC721-setApprovalForAll}.
751      */
752     function setApprovalForAll(address operator, bool approved) public virtual override {
753         _setApprovalForAll(_msgSender(), operator, approved);
754     }
755 
756     /**
757      * @dev See {IERC721-isApprovedForAll}.
758      */
759     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
760         return _operatorApprovals[owner][operator];
761     }
762 
763     /**
764      * @dev See {IERC721-transferFrom}.
765      */
766     function transferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) public virtual override {
771         //solhint-disable-next-line max-line-length
772         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
773 
774         _transfer(from, to, tokenId);
775     }
776 
777     /**
778      * @dev See {IERC721-safeTransferFrom}.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) public virtual override {
785         safeTransferFrom(from, to, tokenId, "");
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) public virtual override {
797         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
798         _safeTransfer(from, to, tokenId, _data);
799     }
800 
801     /**
802      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
803      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
804      *
805      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
806      *
807      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
808      * implement alternative mechanisms to perform token transfer, such as signature-based.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must exist and be owned by `from`.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _safeTransfer(
820         address from,
821         address to,
822         uint256 tokenId,
823         bytes memory _data
824     ) internal virtual {
825         _transfer(from, to, tokenId);
826         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
827     }
828 
829     /**
830      * @dev Returns whether `tokenId` exists.
831      *
832      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
833      *
834      * Tokens start existing when they are minted (`_mint`),
835      * and stop existing when they are burned (`_burn`).
836      */
837     function _exists(uint256 tokenId) internal view virtual returns (bool) {
838         return _owners[tokenId] != address(0);
839     }
840 
841     /**
842      * @dev Returns whether `spender` is allowed to manage `tokenId`.
843      *
844      * Requirements:
845      *
846      * - `tokenId` must exist.
847      */
848     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
849         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
850         address owner = ERC721.ownerOf(tokenId);
851         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
852     }
853 
854     /**
855      * @dev Safely mints `tokenId` and transfers it to `to`.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must not exist.
860      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _safeMint(address to, uint256 tokenId) internal virtual {
865         _safeMint(to, tokenId, "");
866     }
867 
868     /**
869      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
870      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
871      */
872     function _safeMint(
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) internal virtual {
877         _mint(to, tokenId);
878         require(
879             _checkOnERC721Received(address(0), to, tokenId, _data),
880             "ERC721: transfer to non ERC721Receiver implementer"
881         );
882     }
883 
884     /**
885      * @dev Mints `tokenId` and transfers it to `to`.
886      *
887      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
888      *
889      * Requirements:
890      *
891      * - `tokenId` must not exist.
892      * - `to` cannot be the zero address.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _mint(address to, uint256 tokenId) internal virtual {
897         require(to != address(0), "ERC721: mint to the zero address");
898         require(!_exists(tokenId), "ERC721: token already minted");
899 
900         _beforeTokenTransfer(address(0), to, tokenId);
901 
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(address(0), to, tokenId);
906     }
907 
908     /**
909      * @dev Destroys `tokenId`.
910      * The approval is cleared when the token is burned.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _burn(uint256 tokenId) internal virtual {
919         address owner = ERC721.ownerOf(tokenId);
920 
921         _beforeTokenTransfer(owner, address(0), tokenId);
922 
923         // Clear approvals
924         _approve(address(0), tokenId);
925 
926         _balances[owner] -= 1;
927         delete _owners[tokenId];
928 
929         emit Transfer(owner, address(0), tokenId);
930     }
931 
932     /**
933      * @dev Transfers `tokenId` from `from` to `to`.
934      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
935      *
936      * Requirements:
937      *
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must be owned by `from`.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _transfer(
944         address from,
945         address to,
946         uint256 tokenId
947     ) internal virtual {
948         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
949         require(to != address(0), "ERC721: transfer to the zero address");
950 
951         _beforeTokenTransfer(from, to, tokenId);
952 
953         // Clear approvals from the previous owner
954         _approve(address(0), tokenId);
955 
956         _balances[from] -= 1;
957         _balances[to] += 1;
958         _owners[tokenId] = to;
959 
960         emit Transfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev Approve `to` to operate on `tokenId`
965      *
966      * Emits a {Approval} event.
967      */
968     function _approve(address to, uint256 tokenId) internal virtual {
969         _tokenApprovals[tokenId] = to;
970         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
971     }
972 
973     /**
974      * @dev Approve `operator` to operate on all of `owner` tokens
975      *
976      * Emits a {ApprovalForAll} event.
977      */
978     function _setApprovalForAll(
979         address owner,
980         address operator,
981         bool approved
982     ) internal virtual {
983         require(owner != operator, "ERC721: approve to caller");
984         _operatorApprovals[owner][operator] = approved;
985         emit ApprovalForAll(owner, operator, approved);
986     }
987 
988     /**
989      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
990      * The call is not executed if the target address is not a contract.
991      *
992      * @param from address representing the previous owner of the given token ID
993      * @param to target address that will receive the tokens
994      * @param tokenId uint256 ID of the token to be transferred
995      * @param _data bytes optional data to send along with the call
996      * @return bool whether the call correctly returned the expected magic value
997      */
998     function _checkOnERC721Received(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) private returns (bool) {
1004         if (to.isContract()) {
1005             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1006                 return retval == IERC721Receiver.onERC721Received.selector;
1007             } catch (bytes memory reason) {
1008                 if (reason.length == 0) {
1009                     revert("ERC721: transfer to non ERC721Receiver implementer");
1010                 } else {
1011                     assembly {
1012                         revert(add(32, reason), mload(reason))
1013                     }
1014                 }
1015             }
1016         } else {
1017             return true;
1018         }
1019     }
1020 
1021     /**
1022      * @dev Hook that is called before any token transfer. This includes minting
1023      * and burning.
1024      *
1025      * Calling conditions:
1026      *
1027      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1028      * transferred to `to`.
1029      * - When `from` is zero, `tokenId` will be minted for `to`.
1030      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1031      * - `from` and `to` are never both zero.
1032      *
1033      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1034      */
1035     function _beforeTokenTransfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) internal virtual {}
1040 }
1041 
1042 
1043 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
1044 
1045 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1046 
1047 
1048 /**
1049  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1050  * @dev See https://eips.ethereum.org/EIPS/eip-721
1051  */
1052 interface IERC721Enumerable is IERC721 {
1053     /**
1054      * @dev Returns the total amount of tokens stored by the contract.
1055      */
1056     function totalSupply() external view returns (uint256);
1057 
1058     /**
1059      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1060      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1061      */
1062     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1063 
1064     /**
1065      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1066      * Use along with {totalSupply} to enumerate all tokens.
1067      */
1068     function tokenByIndex(uint256 index) external view returns (uint256);
1069 }
1070 
1071 
1072 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.4.2
1073 
1074 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1075 
1076 
1077 
1078 /**
1079  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1080  * enumerability of all the token ids in the contract as well as all token ids owned by each
1081  * account.
1082  */
1083 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1084     // Mapping from owner to list of owned token IDs
1085     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1086 
1087     // Mapping from token ID to index of the owner tokens list
1088     mapping(uint256 => uint256) private _ownedTokensIndex;
1089 
1090     // Array with all token ids, used for enumeration
1091     uint256[] private _allTokens;
1092 
1093     // Mapping from token id to position in the allTokens array
1094     mapping(uint256 => uint256) private _allTokensIndex;
1095 
1096     /**
1097      * @dev See {IERC165-supportsInterface}.
1098      */
1099     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1100         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1105      */
1106     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1107         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1108         return _ownedTokens[owner][index];
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Enumerable-totalSupply}.
1113      */
1114     function totalSupply() public view virtual override returns (uint256) {
1115         return _allTokens.length;
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Enumerable-tokenByIndex}.
1120      */
1121     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1122         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1123         return _allTokens[index];
1124     }
1125 
1126     /**
1127      * @dev Hook that is called before any token transfer. This includes minting
1128      * and burning.
1129      *
1130      * Calling conditions:
1131      *
1132      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1133      * transferred to `to`.
1134      * - When `from` is zero, `tokenId` will be minted for `to`.
1135      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1136      * - `from` cannot be the zero address.
1137      * - `to` cannot be the zero address.
1138      *
1139      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1140      */
1141     function _beforeTokenTransfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) internal virtual override {
1146         super._beforeTokenTransfer(from, to, tokenId);
1147 
1148         if (from == address(0)) {
1149             _addTokenToAllTokensEnumeration(tokenId);
1150         } else if (from != to) {
1151             _removeTokenFromOwnerEnumeration(from, tokenId);
1152         }
1153         if (to == address(0)) {
1154             _removeTokenFromAllTokensEnumeration(tokenId);
1155         } else if (to != from) {
1156             _addTokenToOwnerEnumeration(to, tokenId);
1157         }
1158     }
1159 
1160     /**
1161      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1162      * @param to address representing the new owner of the given token ID
1163      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1164      */
1165     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1166         uint256 length = ERC721.balanceOf(to);
1167         _ownedTokens[to][length] = tokenId;
1168         _ownedTokensIndex[tokenId] = length;
1169     }
1170 
1171     /**
1172      * @dev Private function to add a token to this extension's token tracking data structures.
1173      * @param tokenId uint256 ID of the token to be added to the tokens list
1174      */
1175     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1176         _allTokensIndex[tokenId] = _allTokens.length;
1177         _allTokens.push(tokenId);
1178     }
1179 
1180     /**
1181      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1182      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1183      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1184      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1185      * @param from address representing the previous owner of the given token ID
1186      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1187      */
1188     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1189         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1190         // then delete the last slot (swap and pop).
1191 
1192         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1193         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1194 
1195         // When the token to delete is the last token, the swap operation is unnecessary
1196         if (tokenIndex != lastTokenIndex) {
1197             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1198 
1199             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1200             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1201         }
1202 
1203         // This also deletes the contents at the last position of the array
1204         delete _ownedTokensIndex[tokenId];
1205         delete _ownedTokens[from][lastTokenIndex];
1206     }
1207 
1208     /**
1209      * @dev Private function to remove a token from this extension's token tracking data structures.
1210      * This has O(1) time complexity, but alters the order of the _allTokens array.
1211      * @param tokenId uint256 ID of the token to be removed from the tokens list
1212      */
1213     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1214         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1215         // then delete the last slot (swap and pop).
1216 
1217         uint256 lastTokenIndex = _allTokens.length - 1;
1218         uint256 tokenIndex = _allTokensIndex[tokenId];
1219 
1220         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1221         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1222         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1223         uint256 lastTokenId = _allTokens[lastTokenIndex];
1224 
1225         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1226         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1227 
1228         // This also deletes the contents at the last position of the array
1229         delete _allTokensIndex[tokenId];
1230         _allTokens.pop();
1231     }
1232 }
1233 
1234 
1235 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
1236 
1237 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
1238 
1239 
1240 /**
1241  * @dev Interface of the ERC20 standard as defined in the EIP.
1242  */
1243 interface IERC20 {
1244     /**
1245      * @dev Returns the amount of tokens in existence.
1246      */
1247     function totalSupply() external view returns (uint256);
1248 
1249     /**
1250      * @dev Returns the amount of tokens owned by `account`.
1251      */
1252     function balanceOf(address account) external view returns (uint256);
1253 
1254     /**
1255      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1256      *
1257      * Returns a boolean value indicating whether the operation succeeded.
1258      *
1259      * Emits a {Transfer} event.
1260      */
1261     function transfer(address recipient, uint256 amount) external returns (bool);
1262 
1263     /**
1264      * @dev Returns the remaining number of tokens that `spender` will be
1265      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1266      * zero by default.
1267      *
1268      * This value changes when {approve} or {transferFrom} are called.
1269      */
1270     function allowance(address owner, address spender) external view returns (uint256);
1271 
1272     /**
1273      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1274      *
1275      * Returns a boolean value indicating whether the operation succeeded.
1276      *
1277      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1278      * that someone may use both the old and the new allowance by unfortunate
1279      * transaction ordering. One possible solution to mitigate this race
1280      * condition is to first reduce the spender's allowance to 0 and set the
1281      * desired value afterwards:
1282      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1283      *
1284      * Emits an {Approval} event.
1285      */
1286     function approve(address spender, uint256 amount) external returns (bool);
1287 
1288     /**
1289      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1290      * allowance mechanism. `amount` is then deducted from the caller's
1291      * allowance.
1292      *
1293      * Returns a boolean value indicating whether the operation succeeded.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function transferFrom(
1298         address sender,
1299         address recipient,
1300         uint256 amount
1301     ) external returns (bool);
1302 
1303     /**
1304      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1305      * another (`to`).
1306      *
1307      * Note that `value` may be zero.
1308      */
1309     event Transfer(address indexed from, address indexed to, uint256 value);
1310 
1311     /**
1312      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1313      * a call to {approve}. `value` is the new allowance.
1314      */
1315     event Approval(address indexed owner, address indexed spender, uint256 value);
1316 }
1317 
1318 
1319 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
1320 
1321 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1322 
1323 
1324 /**
1325  * @dev Contract module which provides a basic access control mechanism, where
1326  * there is an account (an owner) that can be granted exclusive access to
1327  * specific functions.
1328  *
1329  * By default, the owner account will be the one that deploys the contract. This
1330  * can later be changed with {transferOwnership}.
1331  *
1332  * This module is used through inheritance. It will make available the modifier
1333  * `onlyOwner`, which can be applied to your functions to restrict their use to
1334  * the owner.
1335  */
1336 abstract contract Ownable is Context {
1337     address private _owner;
1338 
1339     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1340 
1341     /**
1342      * @dev Initializes the contract setting the deployer as the initial owner.
1343      */
1344     constructor() {
1345         _transferOwnership(_msgSender());
1346     }
1347 
1348     /**
1349      * @dev Returns the address of the current owner.
1350      */
1351     function owner() public view virtual returns (address) {
1352         return _owner;
1353     }
1354 
1355     /**
1356      * @dev Throws if called by any account other than the owner.
1357      */
1358     modifier onlyOwner() {
1359         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1360         _;
1361     }
1362 
1363     /**
1364      * @dev Leaves the contract without owner. It will not be possible to call
1365      * `onlyOwner` functions anymore. Can only be called by the current owner.
1366      *
1367      * NOTE: Renouncing ownership will leave the contract without an owner,
1368      * thereby removing any functionality that is only available to the owner.
1369      */
1370     function renounceOwnership() public virtual onlyOwner {
1371         _transferOwnership(address(0));
1372     }
1373 
1374     /**
1375      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1376      * Can only be called by the current owner.
1377      */
1378     function transferOwnership(address newOwner) public virtual onlyOwner {
1379         require(newOwner != address(0), "Ownable: new owner is the zero address");
1380         _transferOwnership(newOwner);
1381     }
1382 
1383     /**
1384      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1385      * Internal function without access restriction.
1386      */
1387     function _transferOwnership(address newOwner) internal virtual {
1388         address oldOwner = _owner;
1389         _owner = newOwner;
1390         emit OwnershipTransferred(oldOwner, newOwner);
1391     }
1392 }
1393 
1394 
1395 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.2
1396 
1397 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1398 
1399 
1400 /**
1401  * @dev Contract module that helps prevent reentrant calls to a function.
1402  *
1403  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1404  * available, which can be applied to functions to make sure there are no nested
1405  * (reentrant) calls to them.
1406  *
1407  * Note that because there is a single `nonReentrant` guard, functions marked as
1408  * `nonReentrant` may not call one another. This can be worked around by making
1409  * those functions `private`, and then adding `external` `nonReentrant` entry
1410  * points to them.
1411  *
1412  * TIP: If you would like to learn more about reentrancy and alternative ways
1413  * to protect against it, check out our blog post
1414  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1415  */
1416 abstract contract ReentrancyGuard {
1417     // Booleans are more expensive than uint256 or any type that takes up a full
1418     // word because each write operation emits an extra SLOAD to first read the
1419     // slot's contents, replace the bits taken up by the boolean, and then write
1420     // back. This is the compiler's defense against contract upgrades and
1421     // pointer aliasing, and it cannot be disabled.
1422 
1423     // The values being non-zero value makes deployment a bit more expensive,
1424     // but in exchange the refund on every call to nonReentrant will be lower in
1425     // amount. Since refunds are capped to a percentage of the total
1426     // transaction's gas, it is best to keep them low in cases like this one, to
1427     // increase the likelihood of the full refund coming into effect.
1428     uint256 private constant _NOT_ENTERED = 1;
1429     uint256 private constant _ENTERED = 2;
1430 
1431     uint256 private _status;
1432 
1433     constructor() {
1434         _status = _NOT_ENTERED;
1435     }
1436 
1437     /**
1438      * @dev Prevents a contract from calling itself, directly or indirectly.
1439      * Calling a `nonReentrant` function from another `nonReentrant`
1440      * function is not supported. It is possible to prevent this from happening
1441      * by making the `nonReentrant` function external, and making it call a
1442      * `private` function that does the actual work.
1443      */
1444     modifier nonReentrant() {
1445         // On the first call to nonReentrant, _notEntered will be true
1446         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1447 
1448         // Any calls to nonReentrant after this point will fail
1449         _status = _ENTERED;
1450 
1451         _;
1452 
1453         // By storing the original value once again, a refund is triggered (see
1454         // https://eips.ethereum.org/EIPS/eip-2200)
1455         _status = _NOT_ENTERED;
1456     }
1457 }
1458 
1459 
1460 // File contracts/Kevolution.sol
1461 
1462 //SPDX-License-Identifier: Unlicense
1463 
1464 
1465 
1466 
1467 contract Kevolution is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {
1468   mapping(uint256 => string) public baseURIs;
1469   bool public paused = true;
1470 
1471   uint256 public constant MAX_VERSION_SUPPLY = 4444;
1472   uint256 public constant FINAL_VERSION = 5;
1473 
1474   mapping(uint256 => uint256) public versionSupply;
1475   mapping(uint256 => uint256) public versionPrice;
1476 
1477   address public addyKevLogicContract;
1478 
1479   event PairMinted(address indexed to, uint256 indexed rootTokenId, uint256 indexed version, uint256 newMintTokenId);
1480 
1481   constructor() ERC721('KEVOLUTION NFT', 'KEVO') { }
1482 
1483   /** ONLY OWNER */
1484 
1485   function setBaseURI(string memory _uri, uint256 _version) external onlyOwner {
1486     baseURIs[_version] = _uri;
1487   }
1488 
1489   function setKevLogicContract(address _address) external onlyOwner {
1490     addyKevLogicContract = _address;
1491   }
1492 
1493   function setPrice(uint256 _version, uint256 _price) external onlyOwner {
1494     versionPrice[_version] = _price;
1495   }
1496 
1497   function setPause(bool _pause) external onlyOwner {
1498     paused = _pause;
1499   }
1500 
1501   function withdrawTokens(address _tokenAddress) external onlyOwner {
1502     uint256 amount = IERC20(_tokenAddress).balanceOf(address(this));
1503 
1504     IERC20(_tokenAddress).transfer(owner(), amount);
1505   }
1506 
1507   function withdrawETH() external onlyOwner {
1508     uint256 amount = address(this).balance;
1509 
1510     (bool success, ) = owner().call{ value: amount }('');
1511     require(success, 'Failed to send Ether');
1512   }
1513 
1514   /** PUBLIC */
1515 
1516   function freeMint(uint256 _amount) external nonReentrant {
1517     require(!paused, 'Minting is paused');
1518 
1519     require(_amount > 0, 'Amount should be 1 or more');
1520     require(_amount <= 10, 'Amount should be 10 or less');
1521 
1522     uint256 supply = totalSupply();
1523     require(supply + _amount <= MAX_VERSION_SUPPLY, 'Exceeds free mint supply');
1524 
1525     require(balanceOf(_msgSender()) + _amount <= 20, 'Max 20 per wallet');
1526 
1527     for (uint256 i = 0; i < _amount; i++) {
1528       _safeMint(msg.sender, supply + i + 1);
1529     }
1530   }
1531 
1532   function mint(uint256 _amount, uint256 _version) external payable nonReentrant {
1533     require(!paused, 'Minting is paused');
1534 
1535     uint256 supply = totalSupply();
1536 
1537     require(_version >= 2, 'Version must be 2 or higher');
1538     require(_version <= FINAL_VERSION, 'Version exceeds max');
1539 
1540     if (_version == 2) {
1541       require(supply >= MAX_VERSION_SUPPLY, 'Free mint must be sold out first');
1542     } else {
1543       require(supply >= MAX_VERSION_SUPPLY * 2, 'Version 2 must be sold out first');
1544     }
1545 
1546     require(versionPrice[_version] > 0, 'Price must be set');
1547     require(_amount > 0, 'Amount should be 1 or more');
1548     require(_amount <= 10, 'Amount should be 10 or less');
1549 
1550     require(msg.value >= versionPrice[_version] * _amount, 'Invalid price');
1551     require(versionSupply[_version] + _amount <= MAX_VERSION_SUPPLY, 'Exceeds version supply');
1552 
1553     uint256 tokenId = ((_version - 1) * MAX_VERSION_SUPPLY) + versionSupply[_version] + 1;
1554 
1555     for (uint256 i = 0; i < _amount; i++) {
1556       _safeMint(msg.sender, tokenId);
1557       tokenId++;
1558     }
1559 
1560     versionSupply[_version] += _amount;
1561   }
1562 
1563   function version(uint256 _tokenId) public view returns (uint256) {
1564     if (!_exists(_tokenId)) {
1565       return 0;
1566     }
1567 
1568     return ((_tokenId - 1) / MAX_VERSION_SUPPLY) + 1;
1569   }
1570 
1571   function pairMint(
1572     address _to,
1573     uint256 _rootTokenId,
1574     uint256 _version
1575   ) external {
1576     require(!paused, 'Minting is paused');
1577 
1578     require(_msgSender() == addyKevLogicContract, 'Access denied');
1579 
1580     require(_version > 2, 'Version must be 3 or higher');
1581     require(_version <= FINAL_VERSION, 'Version exceeds max');
1582     require(versionSupply[_version] + 1 <= MAX_VERSION_SUPPLY, 'Exceeds version supply');
1583 
1584     uint256 tokenId = ((_version - 1) * MAX_VERSION_SUPPLY) + versionSupply[_version] + 1;
1585 
1586     if (_version == FINAL_VERSION) {
1587       tokenId = (MAX_VERSION_SUPPLY * (FINAL_VERSION - 1)) + _rootTokenId;
1588     }
1589 
1590     _safeMint(_to, tokenId);
1591 
1592     versionSupply[_version]++;
1593 
1594     emit PairMinted(_to, _rootTokenId, _version, tokenId);
1595   }
1596 
1597   /** OVERRIDES */
1598   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1599     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1600 
1601     string memory baseURI = baseURIs[version(_tokenId)];
1602     return
1603       bytes(baseURI).length > 0
1604         ? string(abi.encodePacked(baseURI, Strings.toString(_tokenId)))
1605         : '';
1606   }
1607 
1608   function _beforeTokenTransfer(
1609     address from,
1610     address to,
1611     uint256 tokenId
1612   ) internal virtual override(ERC721, ERC721Enumerable) {
1613     super._beforeTokenTransfer(from, to, tokenId);
1614   }
1615 
1616   /**
1617    * @dev See {IERC165-supportsInterface}.
1618    */
1619   function supportsInterface(bytes4 interfaceId)
1620     public
1621     view
1622     virtual
1623     override(ERC721, ERC721Enumerable)
1624     returns (bool)
1625   {
1626     return super.supportsInterface(interfaceId);
1627   }
1628 }