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
41 ## Kev0 is a unique omni-chain NFT collection of 4004 Zombi-Goblins, based upon the KEVoLUTION chain-game. ##
42 
43 https://kevos.art
44 https://twitter.com/kevolutionNFTs
45 
46 */
47 
48 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
49 
50 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
51 
52 /**
53  * @dev Interface of the ERC20 standard as defined in the EIP.
54  */
55 interface IERC20 {
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `to`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address to, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender)
83         external
84         view
85         returns (uint256);
86 
87     /**
88      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * IMPORTANT: Beware that changing an allowance with this method brings the risk
93      * that someone may use both the old and the new allowance by unfortunate
94      * transaction ordering. One possible solution to mitigate this race
95      * condition is to first reduce the spender's allowance to 0 and set the
96      * desired value afterwards:
97      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98      *
99      * Emits an {Approval} event.
100      */
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Moves `amount` tokens from `from` to `to` using the
105      * allowance mechanism. `amount` is then deducted from the caller's
106      * allowance.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 amount
116     ) external returns (bool);
117 
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to {approve}. `value` is the new allowance.
129      */
130     event Approval(
131         address indexed owner,
132         address indexed spender,
133         uint256 value
134     );
135 }
136 
137 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
140 
141 /**
142  * @dev Interface of the ERC165 standard, as defined in the
143  * https://eips.ethereum.org/EIPS/eip-165[EIP].
144  *
145  * Implementers can declare support of contract interfaces, which can then be
146  * queried by others ({ERC165Checker}).
147  *
148  * For an implementation, see {ERC165}.
149  */
150 interface IERC165 {
151     /**
152      * @dev Returns true if this contract implements the interface defined by
153      * `interfaceId`. See the corresponding
154      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
155      * to learn more about how these ids are created.
156      *
157      * This function call must use less than 30 000 gas.
158      */
159     function supportsInterface(bytes4 interfaceId) external view returns (bool);
160 }
161 
162 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
163 
164 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
165 
166 /**
167  * @dev Required interface of an ERC721 compliant contract.
168  */
169 interface IERC721 is IERC165 {
170     /**
171      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
172      */
173     event Transfer(
174         address indexed from,
175         address indexed to,
176         uint256 indexed tokenId
177     );
178 
179     /**
180      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
181      */
182     event Approval(
183         address indexed owner,
184         address indexed approved,
185         uint256 indexed tokenId
186     );
187 
188     /**
189      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
190      */
191     event ApprovalForAll(
192         address indexed owner,
193         address indexed operator,
194         bool approved
195     );
196 
197     /**
198      * @dev Returns the number of tokens in ``owner``'s account.
199      */
200     function balanceOf(address owner) external view returns (uint256 balance);
201 
202     /**
203      * @dev Returns the owner of the `tokenId` token.
204      *
205      * Requirements:
206      *
207      * - `tokenId` must exist.
208      */
209     function ownerOf(uint256 tokenId) external view returns (address owner);
210 
211     /**
212      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
213      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
214      *
215      * Requirements:
216      *
217      * - `from` cannot be the zero address.
218      * - `to` cannot be the zero address.
219      * - `tokenId` token must exist and be owned by `from`.
220      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
222      *
223      * Emits a {Transfer} event.
224      */
225     function safeTransferFrom(
226         address from,
227         address to,
228         uint256 tokenId
229     ) external;
230 
231     /**
232      * @dev Transfers `tokenId` token from `from` to `to`.
233      *
234      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
235      *
236      * Requirements:
237      *
238      * - `from` cannot be the zero address.
239      * - `to` cannot be the zero address.
240      * - `tokenId` token must be owned by `from`.
241      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(
246         address from,
247         address to,
248         uint256 tokenId
249     ) external;
250 
251     /**
252      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
253      * The approval is cleared when the token is transferred.
254      *
255      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
256      *
257      * Requirements:
258      *
259      * - The caller must own the token or be an approved operator.
260      * - `tokenId` must exist.
261      *
262      * Emits an {Approval} event.
263      */
264     function approve(address to, uint256 tokenId) external;
265 
266     /**
267      * @dev Returns the account approved for `tokenId` token.
268      *
269      * Requirements:
270      *
271      * - `tokenId` must exist.
272      */
273     function getApproved(uint256 tokenId)
274         external
275         view
276         returns (address operator);
277 
278     /**
279      * @dev Approve or remove `operator` as an operator for the caller.
280      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
281      *
282      * Requirements:
283      *
284      * - The `operator` cannot be the caller.
285      *
286      * Emits an {ApprovalForAll} event.
287      */
288     function setApprovalForAll(address operator, bool _approved) external;
289 
290     /**
291      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
292      *
293      * See {setApprovalForAll}
294      */
295     function isApprovedForAll(address owner, address operator)
296         external
297         view
298         returns (bool);
299 
300     /**
301      * @dev Safely transfers `tokenId` token from `from` to `to`.
302      *
303      * Requirements:
304      *
305      * - `from` cannot be the zero address.
306      * - `to` cannot be the zero address.
307      * - `tokenId` token must exist and be owned by `from`.
308      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
309      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
310      *
311      * Emits a {Transfer} event.
312      */
313     function safeTransferFrom(
314         address from,
315         address to,
316         uint256 tokenId,
317         bytes calldata data
318     ) external;
319 }
320 
321 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
322 
323 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
324 
325 /**
326  * @title ERC721 token receiver interface
327  * @dev Interface for any contract that wants to support safeTransfers
328  * from ERC721 asset contracts.
329  */
330 interface IERC721Receiver {
331     /**
332      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
333      * by `operator` from `from`, this function is called.
334      *
335      * It must return its Solidity selector to confirm the token transfer.
336      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
337      *
338      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
339      */
340     function onERC721Received(
341         address operator,
342         address from,
343         uint256 tokenId,
344         bytes calldata data
345     ) external returns (bytes4);
346 }
347 
348 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
349 
350 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
351 
352 /**
353  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
354  * @dev See https://eips.ethereum.org/EIPS/eip-721
355  */
356 interface IERC721Metadata is IERC721 {
357     /**
358      * @dev Returns the token collection name.
359      */
360     function name() external view returns (string memory);
361 
362     /**
363      * @dev Returns the token collection symbol.
364      */
365     function symbol() external view returns (string memory);
366 
367     /**
368      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
369      */
370     function tokenURI(uint256 tokenId) external view returns (string memory);
371 }
372 
373 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
374 
375 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
376 
377 /**
378  * @dev Collection of functions related to the address type
379  */
380 library Address {
381     /**
382      * @dev Returns true if `account` is a contract.
383      *
384      * [IMPORTANT]
385      * ====
386      * It is unsafe to assume that an address for which this function returns
387      * false is an externally-owned account (EOA) and not a contract.
388      *
389      * Among others, `isContract` will return false for the following
390      * types of addresses:
391      *
392      *  - an externally-owned account
393      *  - a contract in construction
394      *  - an address where a contract will be created
395      *  - an address where a contract lived, but was destroyed
396      * ====
397      *
398      * [IMPORTANT]
399      * ====
400      * You shouldn't rely on `isContract` to protect against flash loan attacks!
401      *
402      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
403      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
404      * constructor.
405      * ====
406      */
407     function isContract(address account) internal view returns (bool) {
408         // This method relies on extcodesize/address.code.length, which returns 0
409         // for contracts in construction, since the code is only stored at the end
410         // of the constructor execution.
411 
412         return account.code.length > 0;
413     }
414 
415     /**
416      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
417      * `recipient`, forwarding all available gas and reverting on errors.
418      *
419      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
420      * of certain opcodes, possibly making contracts go over the 2300 gas limit
421      * imposed by `transfer`, making them unable to receive funds via
422      * `transfer`. {sendValue} removes this limitation.
423      *
424      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
425      *
426      * IMPORTANT: because control is transferred to `recipient`, care must be
427      * taken to not create reentrancy vulnerabilities. Consider using
428      * {ReentrancyGuard} or the
429      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
430      */
431     function sendValue(address payable recipient, uint256 amount) internal {
432         require(
433             address(this).balance >= amount,
434             "Address: insufficient balance"
435         );
436 
437         (bool success, ) = recipient.call{value: amount}("");
438         require(
439             success,
440             "Address: unable to send value, recipient may have reverted"
441         );
442     }
443 
444     /**
445      * @dev Performs a Solidity function call using a low level `call`. A
446      * plain `call` is an unsafe replacement for a function call: use this
447      * function instead.
448      *
449      * If `target` reverts with a revert reason, it is bubbled up by this
450      * function (like regular Solidity function calls).
451      *
452      * Returns the raw returned data. To convert to the expected return value,
453      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
454      *
455      * Requirements:
456      *
457      * - `target` must be a contract.
458      * - calling `target` with `data` must not revert.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(address target, bytes memory data)
463         internal
464         returns (bytes memory)
465     {
466         return functionCall(target, data, "Address: low-level call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
471      * `errorMessage` as a fallback revert reason when `target` reverts.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(
476         address target,
477         bytes memory data,
478         string memory errorMessage
479     ) internal returns (bytes memory) {
480         return functionCallWithValue(target, data, 0, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but also transferring `value` wei to `target`.
486      *
487      * Requirements:
488      *
489      * - the calling contract must have an ETH balance of at least `value`.
490      * - the called Solidity function must be `payable`.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value
498     ) internal returns (bytes memory) {
499         return
500             functionCallWithValue(
501                 target,
502                 data,
503                 value,
504                 "Address: low-level call with value failed"
505             );
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(
521             address(this).balance >= value,
522             "Address: insufficient balance for call"
523         );
524         require(isContract(target), "Address: call to non-contract");
525 
526         (bool success, bytes memory returndata) = target.call{value: value}(
527             data
528         );
529         return verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a static call.
535      *
536      * _Available since v3.3._
537      */
538     function functionStaticCall(address target, bytes memory data)
539         internal
540         view
541         returns (bytes memory)
542     {
543         return
544             functionStaticCall(
545                 target,
546                 data,
547                 "Address: low-level static call failed"
548             );
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal view returns (bytes memory) {
562         require(isContract(target), "Address: static call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.staticcall(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(address target, bytes memory data)
575         internal
576         returns (bytes memory)
577     {
578         return
579             functionDelegateCall(
580                 target,
581                 data,
582                 "Address: low-level delegate call failed"
583             );
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         require(isContract(target), "Address: delegate call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.delegatecall(data);
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
605      * revert reason using the provided one.
606      *
607      * _Available since v4.3._
608      */
609     function verifyCallResult(
610         bool success,
611         bytes memory returndata,
612         string memory errorMessage
613     ) internal pure returns (bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             // Look for revert reason and bubble it up if present
618             if (returndata.length > 0) {
619                 // The easiest way to bubble the revert reason is using memory via assembly
620 
621                 assembly {
622                     let returndata_size := mload(returndata)
623                     revert(add(32, returndata), returndata_size)
624                 }
625             } else {
626                 revert(errorMessage);
627             }
628         }
629     }
630 }
631 
632 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
633 
634 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
635 
636 /**
637  * @dev Provides information about the current execution context, including the
638  * sender of the transaction and its data. While these are generally available
639  * via msg.sender and msg.data, they should not be accessed in such a direct
640  * manner, since when dealing with meta-transactions the account sending and
641  * paying for execution may not be the actual sender (as far as an application
642  * is concerned).
643  *
644  * This contract is only required for intermediate, library-like contracts.
645  */
646 abstract contract Context {
647     function _msgSender() internal view virtual returns (address) {
648         return msg.sender;
649     }
650 
651     function _msgData() internal view virtual returns (bytes calldata) {
652         return msg.data;
653     }
654 }
655 
656 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
657 
658 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
659 
660 /**
661  * @dev String operations.
662  */
663 library Strings {
664     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
665 
666     /**
667      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
668      */
669     function toString(uint256 value) internal pure returns (string memory) {
670         // Inspired by OraclizeAPI's implementation - MIT licence
671         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
672 
673         if (value == 0) {
674             return "0";
675         }
676         uint256 temp = value;
677         uint256 digits;
678         while (temp != 0) {
679             digits++;
680             temp /= 10;
681         }
682         bytes memory buffer = new bytes(digits);
683         while (value != 0) {
684             digits -= 1;
685             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
686             value /= 10;
687         }
688         return string(buffer);
689     }
690 
691     /**
692      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
693      */
694     function toHexString(uint256 value) internal pure returns (string memory) {
695         if (value == 0) {
696             return "0x00";
697         }
698         uint256 temp = value;
699         uint256 length = 0;
700         while (temp != 0) {
701             length++;
702             temp >>= 8;
703         }
704         return toHexString(value, length);
705     }
706 
707     /**
708      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
709      */
710     function toHexString(uint256 value, uint256 length)
711         internal
712         pure
713         returns (string memory)
714     {
715         bytes memory buffer = new bytes(2 * length + 2);
716         buffer[0] = "0";
717         buffer[1] = "x";
718         for (uint256 i = 2 * length + 1; i > 1; --i) {
719             buffer[i] = _HEX_SYMBOLS[value & 0xf];
720             value >>= 4;
721         }
722         require(value == 0, "Strings: hex length insufficient");
723         return string(buffer);
724     }
725 }
726 
727 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
728 
729 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
730 
731 /**
732  * @dev Implementation of the {IERC165} interface.
733  *
734  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
735  * for the additional interface id that will be supported. For example:
736  *
737  * ```solidity
738  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
739  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
740  * }
741  * ```
742  *
743  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
744  */
745 abstract contract ERC165 is IERC165 {
746     /**
747      * @dev See {IERC165-supportsInterface}.
748      */
749     function supportsInterface(bytes4 interfaceId)
750         public
751         view
752         virtual
753         override
754         returns (bool)
755     {
756         return interfaceId == type(IERC165).interfaceId;
757     }
758 }
759 
760 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
761 
762 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
763 
764 /**
765  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
766  * the Metadata extension, but not including the Enumerable extension, which is available separately as
767  * {ERC721Enumerable}.
768  */
769 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
770     using Address for address;
771     using Strings for uint256;
772 
773     // Token name
774     string private _name;
775 
776     // Token symbol
777     string private _symbol;
778 
779     // Mapping from token ID to owner address
780     mapping(uint256 => address) private _owners;
781 
782     // Mapping owner address to token count
783     mapping(address => uint256) private _balances;
784 
785     // Mapping from token ID to approved address
786     mapping(uint256 => address) private _tokenApprovals;
787 
788     // Mapping from owner to operator approvals
789     mapping(address => mapping(address => bool)) private _operatorApprovals;
790 
791     /**
792      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
793      */
794     constructor(string memory name_, string memory symbol_) {
795         _name = name_;
796         _symbol = symbol_;
797     }
798 
799     /**
800      * @dev See {IERC165-supportsInterface}.
801      */
802     function supportsInterface(bytes4 interfaceId)
803         public
804         view
805         virtual
806         override(ERC165, IERC165)
807         returns (bool)
808     {
809         return
810             interfaceId == type(IERC721).interfaceId ||
811             interfaceId == type(IERC721Metadata).interfaceId ||
812             super.supportsInterface(interfaceId);
813     }
814 
815     /**
816      * @dev See {IERC721-balanceOf}.
817      */
818     function balanceOf(address owner)
819         public
820         view
821         virtual
822         override
823         returns (uint256)
824     {
825         require(
826             owner != address(0),
827             "ERC721: balance query for the zero address"
828         );
829         return _balances[owner];
830     }
831 
832     /**
833      * @dev See {IERC721-ownerOf}.
834      */
835     function ownerOf(uint256 tokenId)
836         public
837         view
838         virtual
839         override
840         returns (address)
841     {
842         address owner = _owners[tokenId];
843         require(
844             owner != address(0),
845             "ERC721: owner query for nonexistent token"
846         );
847         return owner;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId)
868         public
869         view
870         virtual
871         override
872         returns (string memory)
873     {
874         require(
875             _exists(tokenId),
876             "ERC721Metadata: URI query for nonexistent token"
877         );
878 
879         string memory baseURI = _baseURI();
880         return
881             bytes(baseURI).length > 0
882                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
883                 : "";
884     }
885 
886     /**
887      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
888      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
889      * by default, can be overriden in child contracts.
890      */
891     function _baseURI() internal view virtual returns (string memory) {
892         return "";
893     }
894 
895     /**
896      * @dev See {IERC721-approve}.
897      */
898     function approve(address to, uint256 tokenId) public virtual override {
899         address owner = ERC721.ownerOf(tokenId);
900         require(to != owner, "ERC721: approval to current owner");
901 
902         require(
903             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
904             "ERC721: approve caller is not owner nor approved for all"
905         );
906 
907         _approve(to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId)
914         public
915         view
916         virtual
917         override
918         returns (address)
919     {
920         require(
921             _exists(tokenId),
922             "ERC721: approved query for nonexistent token"
923         );
924 
925         return _tokenApprovals[tokenId];
926     }
927 
928     /**
929      * @dev See {IERC721-setApprovalForAll}.
930      */
931     function setApprovalForAll(address operator, bool approved)
932         public
933         virtual
934         override
935     {
936         _setApprovalForAll(_msgSender(), operator, approved);
937     }
938 
939     /**
940      * @dev See {IERC721-isApprovedForAll}.
941      */
942     function isApprovedForAll(address owner, address operator)
943         public
944         view
945         virtual
946         override
947         returns (bool)
948     {
949         return _operatorApprovals[owner][operator];
950     }
951 
952     /**
953      * @dev See {IERC721-transferFrom}.
954      */
955     function transferFrom(
956         address from,
957         address to,
958         uint256 tokenId
959     ) public virtual override {
960         //solhint-disable-next-line max-line-length
961         require(
962             _isApprovedOrOwner(_msgSender(), tokenId),
963             "ERC721: transfer caller is not owner nor approved"
964         );
965 
966         _transfer(from, to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         safeTransferFrom(from, to, tokenId, "");
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) public virtual override {
989         require(
990             _isApprovedOrOwner(_msgSender(), tokenId),
991             "ERC721: transfer caller is not owner nor approved"
992         );
993         _safeTransfer(from, to, tokenId, _data);
994     }
995 
996     /**
997      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
998      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
999      *
1000      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1001      *
1002      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1003      * implement alternative mechanisms to perform token transfer, such as signature-based.
1004      *
1005      * Requirements:
1006      *
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must exist and be owned by `from`.
1010      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _safeTransfer(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) internal virtual {
1020         _transfer(from, to, tokenId);
1021         require(
1022             _checkOnERC721Received(from, to, tokenId, _data),
1023             "ERC721: transfer to non ERC721Receiver implementer"
1024         );
1025     }
1026 
1027     /**
1028      * @dev Returns whether `tokenId` exists.
1029      *
1030      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1031      *
1032      * Tokens start existing when they are minted (`_mint`),
1033      * and stop existing when they are burned (`_burn`).
1034      */
1035     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1036         return _owners[tokenId] != address(0);
1037     }
1038 
1039     /**
1040      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      */
1046     function _isApprovedOrOwner(address spender, uint256 tokenId)
1047         internal
1048         view
1049         virtual
1050         returns (bool)
1051     {
1052         require(
1053             _exists(tokenId),
1054             "ERC721: operator query for nonexistent token"
1055         );
1056         address owner = ERC721.ownerOf(tokenId);
1057         return (spender == owner ||
1058             getApproved(tokenId) == spender ||
1059             isApprovedForAll(owner, spender));
1060     }
1061 
1062     /**
1063      * @dev Safely mints `tokenId` and transfers it to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must not exist.
1068      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _safeMint(address to, uint256 tokenId) internal virtual {
1073         _safeMint(to, tokenId, "");
1074     }
1075 
1076     /**
1077      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1078      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1079      */
1080     function _safeMint(
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) internal virtual {
1085         _mint(to, tokenId);
1086         require(
1087             _checkOnERC721Received(address(0), to, tokenId, _data),
1088             "ERC721: transfer to non ERC721Receiver implementer"
1089         );
1090     }
1091 
1092     /**
1093      * @dev Mints `tokenId` and transfers it to `to`.
1094      *
1095      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must not exist.
1100      * - `to` cannot be the zero address.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _mint(address to, uint256 tokenId) internal virtual {
1105         require(to != address(0), "ERC721: mint to the zero address");
1106         require(!_exists(tokenId), "ERC721: token already minted");
1107 
1108         _beforeTokenTransfer(address(0), to, tokenId);
1109 
1110         _balances[to] += 1;
1111         _owners[tokenId] = to;
1112 
1113         emit Transfer(address(0), to, tokenId);
1114 
1115         _afterTokenTransfer(address(0), to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev Destroys `tokenId`.
1120      * The approval is cleared when the token is burned.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must exist.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _burn(uint256 tokenId) internal virtual {
1129         address owner = ERC721.ownerOf(tokenId);
1130 
1131         _beforeTokenTransfer(owner, address(0), tokenId);
1132 
1133         // Clear approvals
1134         _approve(address(0), tokenId);
1135 
1136         _balances[owner] -= 1;
1137         delete _owners[tokenId];
1138 
1139         emit Transfer(owner, address(0), tokenId);
1140 
1141         _afterTokenTransfer(owner, address(0), tokenId);
1142     }
1143 
1144     /**
1145      * @dev Transfers `tokenId` from `from` to `to`.
1146      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1147      *
1148      * Requirements:
1149      *
1150      * - `to` cannot be the zero address.
1151      * - `tokenId` token must be owned by `from`.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _transfer(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) internal virtual {
1160         require(
1161             ERC721.ownerOf(tokenId) == from,
1162             "ERC721: transfer from incorrect owner"
1163         );
1164         require(to != address(0), "ERC721: transfer to the zero address");
1165 
1166         _beforeTokenTransfer(from, to, tokenId);
1167 
1168         // Clear approvals from the previous owner
1169         _approve(address(0), tokenId);
1170 
1171         _balances[from] -= 1;
1172         _balances[to] += 1;
1173         _owners[tokenId] = to;
1174 
1175         emit Transfer(from, to, tokenId);
1176 
1177         _afterTokenTransfer(from, to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev Approve `to` to operate on `tokenId`
1182      *
1183      * Emits a {Approval} event.
1184      */
1185     function _approve(address to, uint256 tokenId) internal virtual {
1186         _tokenApprovals[tokenId] = to;
1187         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1188     }
1189 
1190     /**
1191      * @dev Approve `operator` to operate on all of `owner` tokens
1192      *
1193      * Emits a {ApprovalForAll} event.
1194      */
1195     function _setApprovalForAll(
1196         address owner,
1197         address operator,
1198         bool approved
1199     ) internal virtual {
1200         require(owner != operator, "ERC721: approve to caller");
1201         _operatorApprovals[owner][operator] = approved;
1202         emit ApprovalForAll(owner, operator, approved);
1203     }
1204 
1205     /**
1206      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1207      * The call is not executed if the target address is not a contract.
1208      *
1209      * @param from address representing the previous owner of the given token ID
1210      * @param to target address that will receive the tokens
1211      * @param tokenId uint256 ID of the token to be transferred
1212      * @param _data bytes optional data to send along with the call
1213      * @return bool whether the call correctly returned the expected magic value
1214      */
1215     function _checkOnERC721Received(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) private returns (bool) {
1221         if (to.isContract()) {
1222             try
1223                 IERC721Receiver(to).onERC721Received(
1224                     _msgSender(),
1225                     from,
1226                     tokenId,
1227                     _data
1228                 )
1229             returns (bytes4 retval) {
1230                 return retval == IERC721Receiver.onERC721Received.selector;
1231             } catch (bytes memory reason) {
1232                 if (reason.length == 0) {
1233                     revert(
1234                         "ERC721: transfer to non ERC721Receiver implementer"
1235                     );
1236                 } else {
1237                     assembly {
1238                         revert(add(32, reason), mload(reason))
1239                     }
1240                 }
1241             }
1242         } else {
1243             return true;
1244         }
1245     }
1246 
1247     /**
1248      * @dev Hook that is called before any token transfer. This includes minting
1249      * and burning.
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1257      * - `from` and `to` are never both zero.
1258      *
1259      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1260      */
1261     function _beforeTokenTransfer(
1262         address from,
1263         address to,
1264         uint256 tokenId
1265     ) internal virtual {}
1266 
1267     /**
1268      * @dev Hook that is called after any transfer of tokens. This includes
1269      * minting and burning.
1270      *
1271      * Calling conditions:
1272      *
1273      * - when `from` and `to` are both non-zero.
1274      * - `from` and `to` are never both zero.
1275      *
1276      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1277      */
1278     function _afterTokenTransfer(
1279         address from,
1280         address to,
1281         uint256 tokenId
1282     ) internal virtual {}
1283 }
1284 
1285 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.5.0
1286 
1287 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1288 
1289 /**
1290  * @title ERC721 Burnable Token
1291  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1292  */
1293 abstract contract ERC721Burnable is Context, ERC721 {
1294     /**
1295      * @dev Burns `tokenId`. See {ERC721-_burn}.
1296      *
1297      * Requirements:
1298      *
1299      * - The caller must own `tokenId` or be an approved operator.
1300      */
1301     function burn(uint256 tokenId) public virtual {
1302         //solhint-disable-next-line max-line-length
1303         require(
1304             _isApprovedOrOwner(_msgSender(), tokenId),
1305             "ERC721Burnable: caller is not owner nor approved"
1306         );
1307         _burn(tokenId);
1308     }
1309 }
1310 
1311 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
1312 
1313 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1314 
1315 /**
1316  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1317  * @dev See https://eips.ethereum.org/EIPS/eip-721
1318  */
1319 interface IERC721Enumerable is IERC721 {
1320     /**
1321      * @dev Returns the total amount of tokens stored by the contract.
1322      */
1323     function totalSupply() external view returns (uint256);
1324 
1325     /**
1326      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1327      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1328      */
1329     function tokenOfOwnerByIndex(address owner, uint256 index)
1330         external
1331         view
1332         returns (uint256);
1333 
1334     /**
1335      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1336      * Use along with {totalSupply} to enumerate all tokens.
1337      */
1338     function tokenByIndex(uint256 index) external view returns (uint256);
1339 }
1340 
1341 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.5.0
1342 
1343 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1344 
1345 /**
1346  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1347  * enumerability of all the token ids in the contract as well as all token ids owned by each
1348  * account.
1349  */
1350 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1351     // Mapping from owner to list of owned token IDs
1352     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1353 
1354     // Mapping from token ID to index of the owner tokens list
1355     mapping(uint256 => uint256) private _ownedTokensIndex;
1356 
1357     // Array with all token ids, used for enumeration
1358     uint256[] private _allTokens;
1359 
1360     // Mapping from token id to position in the allTokens array
1361     mapping(uint256 => uint256) private _allTokensIndex;
1362 
1363     /**
1364      * @dev See {IERC165-supportsInterface}.
1365      */
1366     function supportsInterface(bytes4 interfaceId)
1367         public
1368         view
1369         virtual
1370         override(IERC165, ERC721)
1371         returns (bool)
1372     {
1373         return
1374             interfaceId == type(IERC721Enumerable).interfaceId ||
1375             super.supportsInterface(interfaceId);
1376     }
1377 
1378     /**
1379      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1380      */
1381     function tokenOfOwnerByIndex(address owner, uint256 index)
1382         public
1383         view
1384         virtual
1385         override
1386         returns (uint256)
1387     {
1388         require(
1389             index < ERC721.balanceOf(owner),
1390             "ERC721Enumerable: owner index out of bounds"
1391         );
1392         return _ownedTokens[owner][index];
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Enumerable-totalSupply}.
1397      */
1398     function totalSupply() public view virtual override returns (uint256) {
1399         return _allTokens.length;
1400     }
1401 
1402     /**
1403      * @dev See {IERC721Enumerable-tokenByIndex}.
1404      */
1405     function tokenByIndex(uint256 index)
1406         public
1407         view
1408         virtual
1409         override
1410         returns (uint256)
1411     {
1412         require(
1413             index < ERC721Enumerable.totalSupply(),
1414             "ERC721Enumerable: global index out of bounds"
1415         );
1416         return _allTokens[index];
1417     }
1418 
1419     /**
1420      * @dev Hook that is called before any token transfer. This includes minting
1421      * and burning.
1422      *
1423      * Calling conditions:
1424      *
1425      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1426      * transferred to `to`.
1427      * - When `from` is zero, `tokenId` will be minted for `to`.
1428      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1429      * - `from` cannot be the zero address.
1430      * - `to` cannot be the zero address.
1431      *
1432      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1433      */
1434     function _beforeTokenTransfer(
1435         address from,
1436         address to,
1437         uint256 tokenId
1438     ) internal virtual override {
1439         super._beforeTokenTransfer(from, to, tokenId);
1440 
1441         if (from == address(0)) {
1442             _addTokenToAllTokensEnumeration(tokenId);
1443         } else if (from != to) {
1444             _removeTokenFromOwnerEnumeration(from, tokenId);
1445         }
1446         if (to == address(0)) {
1447             _removeTokenFromAllTokensEnumeration(tokenId);
1448         } else if (to != from) {
1449             _addTokenToOwnerEnumeration(to, tokenId);
1450         }
1451     }
1452 
1453     /**
1454      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1455      * @param to address representing the new owner of the given token ID
1456      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1457      */
1458     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1459         uint256 length = ERC721.balanceOf(to);
1460         _ownedTokens[to][length] = tokenId;
1461         _ownedTokensIndex[tokenId] = length;
1462     }
1463 
1464     /**
1465      * @dev Private function to add a token to this extension's token tracking data structures.
1466      * @param tokenId uint256 ID of the token to be added to the tokens list
1467      */
1468     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1469         _allTokensIndex[tokenId] = _allTokens.length;
1470         _allTokens.push(tokenId);
1471     }
1472 
1473     /**
1474      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1475      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1476      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1477      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1478      * @param from address representing the previous owner of the given token ID
1479      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1480      */
1481     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1482         private
1483     {
1484         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1485         // then delete the last slot (swap and pop).
1486 
1487         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1488         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1489 
1490         // When the token to delete is the last token, the swap operation is unnecessary
1491         if (tokenIndex != lastTokenIndex) {
1492             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1493 
1494             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1495             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1496         }
1497 
1498         // This also deletes the contents at the last position of the array
1499         delete _ownedTokensIndex[tokenId];
1500         delete _ownedTokens[from][lastTokenIndex];
1501     }
1502 
1503     /**
1504      * @dev Private function to remove a token from this extension's token tracking data structures.
1505      * This has O(1) time complexity, but alters the order of the _allTokens array.
1506      * @param tokenId uint256 ID of the token to be removed from the tokens list
1507      */
1508     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1509         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1510         // then delete the last slot (swap and pop).
1511 
1512         uint256 lastTokenIndex = _allTokens.length - 1;
1513         uint256 tokenIndex = _allTokensIndex[tokenId];
1514 
1515         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1516         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1517         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1518         uint256 lastTokenId = _allTokens[lastTokenIndex];
1519 
1520         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1521         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1522 
1523         // This also deletes the contents at the last position of the array
1524         delete _allTokensIndex[tokenId];
1525         _allTokens.pop();
1526     }
1527 }
1528 
1529 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1530 
1531 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1532 
1533 /**
1534  * @dev Contract module which provides a basic access control mechanism, where
1535  * there is an account (an owner) that can be granted exclusive access to
1536  * specific functions.
1537  *
1538  * By default, the owner account will be the one that deploys the contract. This
1539  * can later be changed with {transferOwnership}.
1540  *
1541  * This module is used through inheritance. It will make available the modifier
1542  * `onlyOwner`, which can be applied to your functions to restrict their use to
1543  * the owner.
1544  */
1545 abstract contract Ownable is Context {
1546     address private _owner;
1547 
1548     event OwnershipTransferred(
1549         address indexed previousOwner,
1550         address indexed newOwner
1551     );
1552 
1553     /**
1554      * @dev Initializes the contract setting the deployer as the initial owner.
1555      */
1556     constructor() {
1557         _transferOwnership(_msgSender());
1558     }
1559 
1560     /**
1561      * @dev Returns the address of the current owner.
1562      */
1563     function owner() public view virtual returns (address) {
1564         return _owner;
1565     }
1566 
1567     /**
1568      * @dev Throws if called by any account other than the owner.
1569      */
1570     modifier onlyOwner() {
1571         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1572         _;
1573     }
1574 
1575     /**
1576      * @dev Leaves the contract without owner. It will not be possible to call
1577      * `onlyOwner` functions anymore. Can only be called by the current owner.
1578      *
1579      * NOTE: Renouncing ownership will leave the contract without an owner,
1580      * thereby removing any functionality that is only available to the owner.
1581      */
1582     function renounceOwnership() public virtual onlyOwner {
1583         _transferOwnership(address(0));
1584     }
1585 
1586     /**
1587      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1588      * Can only be called by the current owner.
1589      */
1590     function transferOwnership(address newOwner) public virtual onlyOwner {
1591         require(
1592             newOwner != address(0),
1593             "Ownable: new owner is the zero address"
1594         );
1595         _transferOwnership(newOwner);
1596     }
1597 
1598     /**
1599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1600      * Internal function without access restriction.
1601      */
1602     function _transferOwnership(address newOwner) internal virtual {
1603         address oldOwner = _owner;
1604         _owner = newOwner;
1605         emit OwnershipTransferred(oldOwner, newOwner);
1606     }
1607 }
1608 
1609 // File contracts/interfaces/ILayerZeroReceiver.sol
1610 
1611 interface ILayerZeroReceiver {
1612     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
1613     // @param _srcChainId - the source endpoint identifier
1614     // @param _srcAddress - the source sending contract address from the source chain
1615     // @param _nonce - the ordered message nonce
1616     // @param _payload - the signed payload is the UA bytes has encoded to be sent
1617     function lzReceive(
1618         uint16 _srcChainId,
1619         bytes calldata _srcAddress,
1620         uint64 _nonce,
1621         bytes calldata _payload
1622     ) external;
1623 }
1624 
1625 // File contracts/interfaces/ILayerZeroUserApplicationConfig.sol
1626 
1627 interface ILayerZeroUserApplicationConfig {
1628     // @notice set the configuration of the LayerZero messaging library of the specified version
1629     // @param _version - messaging library version
1630     // @param _chainId - the chainId for the pending config change
1631     // @param _configType - type of configuration. every messaging library has its own convention.
1632     // @param _config - configuration in the bytes. can encode arbitrary content.
1633     function setConfig(
1634         uint16 _version,
1635         uint16 _chainId,
1636         uint256 _configType,
1637         bytes calldata _config
1638     ) external;
1639 
1640     // @notice set the send() LayerZero messaging library version to _version
1641     // @param _version - new messaging library version
1642     function setSendVersion(uint16 _version) external;
1643 
1644     // @notice set the lzReceive() LayerZero messaging library version to _version
1645     // @param _version - new messaging library version
1646     function setReceiveVersion(uint16 _version) external;
1647 
1648     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
1649     // @param _srcChainId - the chainId of the source chain
1650     // @param _srcAddress - the contract address of the source contract at the source chain
1651     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
1652         external;
1653 }
1654 
1655 // File contracts/interfaces/ILayerZeroEndpoint.sol
1656 
1657 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
1658     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
1659     // @param _dstChainId - the destination chain identifier
1660     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
1661     // @param _payload - a custom bytes payload to send to the destination contract
1662     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
1663     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
1664     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
1665     function send(
1666         uint16 _dstChainId,
1667         bytes calldata _destination,
1668         bytes calldata _payload,
1669         address payable _refundAddress,
1670         address _zroPaymentAddress,
1671         bytes calldata _adapterParams
1672     ) external payable;
1673 
1674     // @notice used by the messaging library to publish verified payload
1675     // @param _srcChainId - the source chain identifier
1676     // @param _srcAddress - the source contract (as bytes) at the source chain
1677     // @param _dstAddress - the address on destination chain
1678     // @param _nonce - the unbound message ordering nonce
1679     // @param _gasLimit - the gas limit for external contract execution
1680     // @param _payload - verified payload to send to the destination contract
1681     function receivePayload(
1682         uint16 _srcChainId,
1683         bytes calldata _srcAddress,
1684         address _dstAddress,
1685         uint64 _nonce,
1686         uint256 _gasLimit,
1687         bytes calldata _payload
1688     ) external;
1689 
1690     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
1691     // @param _srcChainId - the source chain identifier
1692     // @param _srcAddress - the source chain contract address
1693     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
1694         external
1695         view
1696         returns (uint64);
1697 
1698     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
1699     // @param _srcAddress - the source chain contract address
1700     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
1701         external
1702         view
1703         returns (uint64);
1704 
1705     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
1706     // @param _dstChainId - the destination chain identifier
1707     // @param _userApplication - the user app address on this EVM chain
1708     // @param _payload - the custom message to send over LayerZero
1709     // @param _payInZRO - if false, user app pays the protocol fee in native token
1710     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
1711     function estimateFees(
1712         uint16 _dstChainId,
1713         address _userApplication,
1714         bytes calldata _payload,
1715         bool _payInZRO,
1716         bytes calldata _adapterParam
1717     ) external view returns (uint256 nativeFee, uint256 zroFee);
1718 
1719     // @notice get this Endpoint's immutable source identifier
1720     function getChainId() external view returns (uint16);
1721 
1722     // @notice the interface to retry failed message on this Endpoint destination
1723     // @param _srcChainId - the source chain identifier
1724     // @param _srcAddress - the source chain contract address
1725     // @param _payload - the payload to be retried
1726     function retryPayload(
1727         uint16 _srcChainId,
1728         bytes calldata _srcAddress,
1729         bytes calldata _payload
1730     ) external;
1731 
1732     // @notice query if any STORED payload (message blocking) at the endpoint.
1733     // @param _srcChainId - the source chain identifier
1734     // @param _srcAddress - the source chain contract address
1735     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
1736         external
1737         view
1738         returns (bool);
1739 
1740     // @notice query if the _libraryAddress is valid for sending msgs.
1741     // @param _userApplication - the user app address on this EVM chain
1742     function getSendLibraryAddress(address _userApplication)
1743         external
1744         view
1745         returns (address);
1746 
1747     // @notice query if the _libraryAddress is valid for receiving msgs.
1748     // @param _userApplication - the user app address on this EVM chain
1749     function getReceiveLibraryAddress(address _userApplication)
1750         external
1751         view
1752         returns (address);
1753 
1754     // @notice query if the non-reentrancy guard for send() is on
1755     // @return true if the guard is on. false otherwise
1756     function isSendingPayload() external view returns (bool);
1757 
1758     // @notice query if the non-reentrancy guard for receive() is on
1759     // @return true if the guard is on. false otherwise
1760     function isReceivingPayload() external view returns (bool);
1761 
1762     // @notice get the configuration of the LayerZero messaging library of the specified version
1763     // @param _version - messaging library version
1764     // @param _chainId - the chainId for the pending config change
1765     // @param _userApplication - the contract address of the user application
1766     // @param _configType - type of configuration. every messaging library has its own convention.
1767     function getConfig(
1768         uint16 _version,
1769         uint16 _chainId,
1770         address _userApplication,
1771         uint256 _configType
1772     ) external view returns (bytes memory);
1773 
1774     // @notice get the send() LayerZero messaging library version
1775     // @param _userApplication - the contract address of the user application
1776     function getSendVersion(address _userApplication)
1777         external
1778         view
1779         returns (uint16);
1780 
1781     // @notice get the lzReceive() LayerZero messaging library version
1782     // @param _userApplication - the contract address of the user application
1783     function getReceiveVersion(address _userApplication)
1784         external
1785         view
1786         returns (uint16);
1787 }
1788 
1789 // File contracts/LayerZeroable.sol
1790 
1791 abstract contract LayerZeroable is
1792     Ownable,
1793     ILayerZeroReceiver,
1794     ILayerZeroUserApplicationConfig
1795 {
1796     ILayerZeroEndpoint public layerZeroEndpoint;
1797     mapping(uint16 => bytes) public remotes;
1798 
1799     uint256 public destGasAmount = 300000;
1800 
1801     function setLayerZeroEndpoint(address _layerZeroEndpoint)
1802         external
1803         onlyOwner
1804     {
1805         layerZeroEndpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1806     }
1807 
1808     function setRemote(uint16 _chainId, bytes calldata _remoteAddress)
1809         external
1810         onlyOwner
1811     {
1812         remotes[_chainId] = _remoteAddress;
1813     }
1814 
1815     function setConfig(
1816         uint16, /*_version*/
1817         uint16 _chainId,
1818         uint256 _configType,
1819         bytes calldata _config
1820     ) external override onlyOwner {
1821         layerZeroEndpoint.setConfig(
1822             layerZeroEndpoint.getSendVersion(address(this)),
1823             _chainId,
1824             _configType,
1825             _config
1826         );
1827     }
1828 
1829     function setSendVersion(uint16 version) external override onlyOwner {
1830         layerZeroEndpoint.setSendVersion(version);
1831     }
1832 
1833     function setReceiveVersion(uint16 version) external override onlyOwner {
1834         layerZeroEndpoint.setReceiveVersion(version);
1835     }
1836 
1837     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
1838         external
1839         override
1840         onlyOwner
1841     {
1842         layerZeroEndpoint.forceResumeReceive(_srcChainId, _srcAddress);
1843     }
1844 
1845     function setDestGasAmount(uint256 _amount) external onlyOwner {
1846         destGasAmount = _amount;
1847     }
1848 
1849     function _bytesToAddress(bytes memory bys)
1850         internal
1851         pure
1852         returns (address addr)
1853     {
1854         assembly {
1855             addr := mload(add(bys, 20))
1856         }
1857     }
1858 }
1859 
1860 // File contracts/Kev0.sol
1861 
1862 contract Kev0 is Ownable, ERC721Burnable, ERC721Enumerable, LayerZeroable {
1863     uint16 public mintedSupply = 0;
1864     uint256 public lastTokenId = 0;
1865 
1866     string public constant BASE_URI =
1867         "ipfs://bafybeibjv2gnanwheimnz7c2ymdt5w4khzo26jlwlooh5xe6d2o5l36f4y/";
1868     uint256 public constant MAX_SUPPLY = 572;
1869 
1870     constructor(uint256 _lastTokenId, address _layerZeroEndpoint)
1871         ERC721("kev0", "kev0")
1872     {
1873         lastTokenId = _lastTokenId;
1874 
1875         layerZeroEndpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1876     }
1877 
1878     fallback() external payable {}
1879 
1880     receive() external payable {}
1881 
1882     /* Only owner */
1883 
1884     function withdrawTokens(address _tokenAddress) external onlyOwner {
1885         uint256 amount = IERC20(_tokenAddress).balanceOf(address(this));
1886 
1887         IERC20(_tokenAddress).transfer(owner(), amount);
1888     }
1889 
1890     function withdrawETH() external onlyOwner {
1891         uint256 amount = address(this).balance;
1892 
1893         (bool success, ) = owner().call{value: amount}("");
1894         require(success, "Failed to send Ether");
1895     }
1896 
1897     /* Endpoint methods */
1898 
1899     function lzReceive(
1900         uint16 _srcChainId,
1901         bytes memory _srcAddress,
1902         uint64,
1903         bytes memory _payload
1904     ) external override {
1905         require(msg.sender == address(layerZeroEndpoint));
1906         require(
1907             _srcAddress.length == remotes[_srcChainId].length &&
1908                 keccak256(_srcAddress) == keccak256(remotes[_srcChainId]),
1909             "Invalid remote sender address. owner should call setRemote() to enable remote contract"
1910         );
1911 
1912         // Decode payload
1913         (address to, uint256 tokenId) = abi.decode(
1914             _payload,
1915             (address, uint256)
1916         );
1917 
1918         _safeMint(to, tokenId);
1919     }
1920 
1921     /* Public methods */
1922 
1923     function _baseURI() internal pure override returns (string memory) {
1924         return BASE_URI;
1925     }
1926 
1927     function mint() public payable {
1928         require(mintedSupply < MAX_SUPPLY, "Max mint supply reached");
1929         mintedSupply++;
1930         _safeMint(_msgSender(), ++lastTokenId);
1931     }
1932 
1933     function transferToChain(
1934         uint256 _tokenId,
1935         address _to,
1936         uint16 _chainId
1937     ) external payable {
1938         require(ownerOf(_tokenId) == _msgSender(), "Sender is not owner");
1939         require(remotes[_chainId].length > 0, "Remote not configured");
1940 
1941         _burn(_tokenId);
1942 
1943         bytes memory payload = abi.encode(_to, _tokenId);
1944 
1945         uint16 version = 1;
1946         bytes memory adapterParams = abi.encodePacked(version, destGasAmount);
1947 
1948         (uint256 messageFee, ) = layerZeroEndpoint.estimateFees(
1949             _chainId,
1950             _bytesToAddress(remotes[_chainId]),
1951             payload,
1952             false,
1953             adapterParams
1954         );
1955         require(
1956             msg.value >= messageFee,
1957             "Insufficient amount to cover gas costs"
1958         );
1959 
1960         layerZeroEndpoint.send{value: msg.value}(
1961             _chainId,
1962             remotes[_chainId],
1963             payload,
1964             payable(msg.sender),
1965             address(0x0),
1966             adapterParams
1967         );
1968     }
1969 
1970     function estimateFee(
1971         uint256 _tokenId,
1972         address _to,
1973         uint16 _chainId
1974     ) external view returns (uint256 nativeFee, uint256 zroFee) {
1975         bytes memory payload = abi.encode(_to, _tokenId);
1976 
1977         uint16 version = 1;
1978         bytes memory adapterParams = abi.encodePacked(version, destGasAmount);
1979 
1980         return
1981             layerZeroEndpoint.estimateFees(
1982                 _chainId,
1983                 _bytesToAddress(remotes[_chainId]),
1984                 payload,
1985                 false,
1986                 adapterParams
1987             );
1988     }
1989 
1990     /* Overrides */
1991 
1992     function _beforeTokenTransfer(
1993         address from,
1994         address to,
1995         uint256 tokenId
1996     ) internal virtual override(ERC721, ERC721Enumerable) {
1997         super._beforeTokenTransfer(from, to, tokenId);
1998     }
1999 
2000     function supportsInterface(bytes4 interfaceId)
2001         public
2002         view
2003         virtual
2004         override(ERC721, ERC721Enumerable)
2005         returns (bool)
2006     {
2007         return super.supportsInterface(interfaceId);
2008     }
2009 }