1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.7;
8 
9 /*
10        ....                                                             s                                           .                                .x+=:.   
11    .xH888888Hx.                                                        :8                                          @88>                             z`    ^%  
12  .H8888888888888:                                       u.    u.      .88       .u    .                    ..      %8P      u.    u.                   .   <k 
13  888*"""?""*88888X        .u          .        .u     x@88k u@88c.   :888ooo  .d88B :@8c        u        .@88i      .     x@88k u@88c.      .u       .@8Ned8" 
14 'f     d8x.   ^%88k    ud8888.   .udR88N    ud8888.  ^"8888""8888" -*8888888 ="8888f8888r    us888u.    ""%888>   .@88u  ^"8888""8888"   ud8888.   .@^%8888"  
15 '>    <88888X   '?8  :888'8888. <888'888k :888'8888.   8888  888R    8888      4888>'88"  .@88 "8888"     '88%   ''888E`   8888  888R  :888'8888. x88:  `)8b. 
16  `:..:`888888>    8> d888 '88%" 9888 'Y"  d888 '88%"   8888  888R    8888      4888> '    9888  9888    ..dILr~`   888E    8888  888R  d888 '88%" 8888N=*8888 
17         `"*88     X  8888.+"    9888      8888.+"      8888  888R    8888      4888>      9888  9888   '".-%88b    888E    8888  888R  8888.+"     %8"    R88 
18    .xHHhx.."      !  8888L      9888      8888L        8888  888R   .8888Lu=  .d888L .+   9888  9888    @  '888k   888E    8888  888R  8888L        @8Wou 9%  
19   X88888888hx. ..!   '8888c. .+ ?8888u../ '8888c. .+  "*88*" 8888"  ^%888*    ^"8888*"    9888  9888   8F   8888   888&   "*88*" 8888" '8888c. .+ .888888P`   
20  !   "*888888888"     "88888%    "8888P'   "88888%      ""   'Y"      'Y"        "Y"      "888*""888" '8    8888   R888"    ""   'Y"    "88888%   `   ^"F     
21         ^"***"`         "YP'       "P'       "YP'                                          ^Y"   ^Y'  '8    888F    ""                    "YP'                
22                                                                                                        %k  <88F                                               
23                                                                                                         "+:*%`                                                
24                                                                                                                                                               
25 */
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 
49 
50 
51 
52 
53 /**
54  * @dev Required interface of an ERC721 compliant contract.
55  */
56 interface IERC721 is IERC165 {
57     /**
58      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
59      */
60     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
64      */
65     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
69      */
70     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
71 
72     /**
73      * @dev Returns the number of tokens in ``owner``'s account.
74      */
75     function balanceOf(address owner) external view returns (uint256 balance);
76 
77     /**
78      * @dev Returns the owner of the `tokenId` token.
79      *
80      * Requirements:
81      *
82      * - `tokenId` must exist.
83      */
84     function ownerOf(uint256 tokenId) external view returns (address owner);
85 
86     /**
87      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
88      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must exist and be owned by `from`.
95      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
96      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
97      *
98      * Emits a {Transfer} event.
99      */
100     function safeTransferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Transfers `tokenId` token from `from` to `to`.
108      *
109      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must be owned by `from`.
116      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(
121         address from,
122         address to,
123         uint256 tokenId
124     ) external;
125 
126     /**
127      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
128      * The approval is cleared when the token is transferred.
129      *
130      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
131      *
132      * Requirements:
133      *
134      * - The caller must own the token or be an approved operator.
135      * - `tokenId` must exist.
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address to, uint256 tokenId) external;
140 
141     /**
142      * @dev Returns the account approved for `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function getApproved(uint256 tokenId) external view returns (address operator);
149 
150     /**
151      * @dev Approve or remove `operator` as an operator for the caller.
152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
153      *
154      * Requirements:
155      *
156      * - The `operator` cannot be the caller.
157      *
158      * Emits an {ApprovalForAll} event.
159      */
160     function setApprovalForAll(address operator, bool _approved) external;
161 
162     /**
163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
164      *
165      * See {setApprovalForAll}
166      */
167     function isApprovedForAll(address owner, address operator) external view returns (bool);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId,
186         bytes calldata data
187     ) external;
188 }
189 
190 
191 
192 
193 /**
194  * @dev String operations.
195  */
196 library Strings {
197     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
198 
199     /**
200      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
201      */
202     function toString(uint256 value) internal pure returns (string memory) {
203         // Inspired by OraclizeAPI's implementation - MIT licence
204         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
205 
206         if (value == 0) {
207             return "0";
208         }
209         uint256 temp = value;
210         uint256 digits;
211         while (temp != 0) {
212             digits++;
213             temp /= 10;
214         }
215         bytes memory buffer = new bytes(digits);
216         while (value != 0) {
217             digits -= 1;
218             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
219             value /= 10;
220         }
221         return string(buffer);
222     }
223 
224     /**
225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
226      */
227     function toHexString(uint256 value) internal pure returns (string memory) {
228         if (value == 0) {
229             return "0x00";
230         }
231         uint256 temp = value;
232         uint256 length = 0;
233         while (temp != 0) {
234             length++;
235             temp >>= 8;
236         }
237         return toHexString(value, length);
238     }
239 
240     /**
241      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
242      */
243     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
244         bytes memory buffer = new bytes(2 * length + 2);
245         buffer[0] = "0";
246         buffer[1] = "x";
247         for (uint256 i = 2 * length + 1; i > 1; --i) {
248             buffer[i] = _HEX_SYMBOLS[value & 0xf];
249             value >>= 4;
250         }
251         require(value == 0, "Strings: hex length insufficient");
252         return string(buffer);
253     }
254 }
255 
256 
257 
258 
259 /*
260  * @dev Provides information about the current execution context, including the
261  * sender of the transaction and its data. While these are generally available
262  * via msg.sender and msg.data, they should not be accessed in such a direct
263  * manner, since when dealing with meta-transactions the account sending and
264  * paying for execution may not be the actual sender (as far as an application
265  * is concerned).
266  *
267  * This contract is only required for intermediate, library-like contracts.
268  */
269 abstract contract Context {
270     function _msgSender() internal view virtual returns (address) {
271         return msg.sender;
272     }
273 
274     function _msgData() internal view virtual returns (bytes calldata) {
275         return msg.data;
276     }
277 }
278 
279 
280 
281 
282 
283 
284 
285 
286 
287 
288 
289 
290 
291 
292 
293 
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 
319 
320 
321 
322 
323 
324 /**
325  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
326  * @dev See https://eips.ethereum.org/EIPS/eip-721
327  */
328 interface IERC721Metadata is IERC721 {
329     /**
330      * @dev Returns the token collection name.
331      */
332     function name() external view returns (string memory);
333 
334     /**
335      * @dev Returns the token collection symbol.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
341      */
342     function tokenURI(uint256 tokenId) external view returns (string memory);
343 }
344 
345 
346 
347 
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies on extcodesize, which returns 0 for contracts in
372         // construction, since the code is only stored at the end of the
373         // constructor execution.
374 
375         uint256 size;
376         assembly {
377             size := extcodesize(account)
378         }
379         return size > 0;
380     }
381 
382     /**
383      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
384      * `recipient`, forwarding all available gas and reverting on errors.
385      *
386      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
387      * of certain opcodes, possibly making contracts go over the 2300 gas limit
388      * imposed by `transfer`, making them unable to receive funds via
389      * `transfer`. {sendValue} removes this limitation.
390      *
391      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
392      *
393      * IMPORTANT: because control is transferred to `recipient`, care must be
394      * taken to not create reentrancy vulnerabilities. Consider using
395      * {ReentrancyGuard} or the
396      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
397      */
398     function sendValue(address payable recipient, uint256 amount) internal {
399         require(address(this).balance >= amount, "Address: insufficient balance");
400 
401         (bool success, ) = recipient.call{value: amount}("");
402         require(success, "Address: unable to send value, recipient may have reverted");
403     }
404 
405     /**
406      * @dev Performs a Solidity function call using a low level `call`. A
407      * plain `call` is an unsafe replacement for a function call: use this
408      * function instead.
409      *
410      * If `target` reverts with a revert reason, it is bubbled up by this
411      * function (like regular Solidity function calls).
412      *
413      * Returns the raw returned data. To convert to the expected return value,
414      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
415      *
416      * Requirements:
417      *
418      * - `target` must be a contract.
419      * - calling `target` with `data` must not revert.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionCall(target, data, "Address: low-level call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
429      * `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, 0, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but also transferring `value` wei to `target`.
444      *
445      * Requirements:
446      *
447      * - the calling contract must have an ETH balance of at least `value`.
448      * - the called Solidity function must be `payable`.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(
453         address target,
454         bytes memory data,
455         uint256 value
456     ) internal returns (bytes memory) {
457         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
462      * with `errorMessage` as a fallback revert reason when `target` reverts.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         require(address(this).balance >= value, "Address: insufficient balance for call");
473         require(isContract(target), "Address: call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.call{value: value}(data);
476         return _verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
486         return functionStaticCall(target, data, "Address: low-level static call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
491      * but performing a static call.
492      *
493      * _Available since v3.3._
494      */
495     function functionStaticCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal view returns (bytes memory) {
500         require(isContract(target), "Address: static call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.staticcall(data);
503         return _verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
513         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
518      * but performing a delegate call.
519      *
520      * _Available since v3.4._
521      */
522     function functionDelegateCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(isContract(target), "Address: delegate call to non-contract");
528 
529         (bool success, bytes memory returndata) = target.delegatecall(data);
530         return _verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     function _verifyCallResult(
534         bool success,
535         bytes memory returndata,
536         string memory errorMessage
537     ) private pure returns (bytes memory) {
538         if (success) {
539             return returndata;
540         } else {
541             // Look for revert reason and bubble it up if present
542             if (returndata.length > 0) {
543                 // The easiest way to bubble the revert reason is using memory via assembly
544 
545                 assembly {
546                     let returndata_size := mload(returndata)
547                     revert(add(32, returndata), returndata_size)
548                 }
549             } else {
550                 revert(errorMessage);
551             }
552         }
553     }
554 }
555 
556 
557 
558 
559 
560 
561 
562 
563 
564 /**
565  * @dev Implementation of the {IERC165} interface.
566  *
567  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
568  * for the additional interface id that will be supported. For example:
569  *
570  * ```solidity
571  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
573  * }
574  * ```
575  *
576  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
577  */
578 abstract contract ERC165 is IERC165 {
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583         return interfaceId == type(IERC165).interfaceId;
584     }
585 }
586 
587 
588 /**
589  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
590  * the Metadata extension, but not including the Enumerable extension, which is available separately as
591  * {ERC721Enumerable}.
592  */
593 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
594     using Address for address;
595     using Strings for uint256;
596 
597     // Token name
598     string private _name;
599 
600     // Token symbol
601     string private _symbol;
602 
603     // Mapping from token ID to owner address
604     mapping(uint256 => address) private _owners;
605 
606     // Mapping owner address to token count
607     mapping(address => uint256) private _balances;
608 
609     // Mapping from token ID to approved address
610     mapping(uint256 => address) private _tokenApprovals;
611 
612     // Mapping from owner to operator approvals
613     mapping(address => mapping(address => bool)) private _operatorApprovals;
614 
615     /**
616      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
617      */
618     constructor(string memory name_, string memory symbol_) {
619         _name = name_;
620         _symbol = symbol_;
621     }
622 
623     /**
624      * @dev See {IERC165-supportsInterface}.
625      */
626     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
627         return
628             interfaceId == type(IERC721).interfaceId ||
629             interfaceId == type(IERC721Metadata).interfaceId ||
630             super.supportsInterface(interfaceId);
631     }
632 
633     /**
634      * @dev See {IERC721-balanceOf}.
635      */
636     function balanceOf(address owner) public view virtual override returns (uint256) {
637         require(owner != address(0), "ERC721: balance query for the zero address");
638         return _balances[owner];
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
645         address owner = _owners[tokenId];
646         require(owner != address(0), "ERC721: owner query for nonexistent token");
647         return owner;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-name}.
652      */
653     function name() public view virtual override returns (string memory) {
654         return _name;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-symbol}.
659      */
660     function symbol() public view virtual override returns (string memory) {
661         return _symbol;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-tokenURI}.
666      */
667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
668         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
669 
670         string memory baseURI = _baseURI();
671         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
672     }
673 
674     /**
675      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
676      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
677      * by default, can be overriden in child contracts.
678      */
679     function _baseURI() internal view virtual returns (string memory) {
680         return "";
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public virtual override {
687         address owner = ERC721.ownerOf(tokenId);
688         require(to != owner, "ERC721: approval to current owner");
689 
690         require(
691             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
692             "ERC721: approve caller is not owner nor approved for all"
693         );
694 
695         _approve(to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-getApproved}.
700      */
701     function getApproved(uint256 tokenId) public view virtual override returns (address) {
702         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
703 
704         return _tokenApprovals[tokenId];
705     }
706 
707     /**
708      * @dev See {IERC721-setApprovalForAll}.
709      */
710     function setApprovalForAll(address operator, bool approved) public virtual override {
711         require(operator != _msgSender(), "ERC721: approve to caller");
712 
713         _operatorApprovals[_msgSender()][operator] = approved;
714         emit ApprovalForAll(_msgSender(), operator, approved);
715     }
716 
717     /**
718      * @dev See {IERC721-isApprovedForAll}.
719      */
720     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
721         return _operatorApprovals[owner][operator];
722     }
723 
724     /**
725      * @dev See {IERC721-transferFrom}.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         //solhint-disable-next-line max-line-length
733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
734 
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, "");
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759         _safeTransfer(from, to, tokenId, _data);
760     }
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
767      *
768      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
769      * implement alternative mechanisms to perform token transfer, such as signature-based.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _safeTransfer(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _transfer(from, to, tokenId);
787         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
788     }
789 
790     /**
791      * @dev Returns whether `tokenId` exists.
792      *
793      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
794      *
795      * Tokens start existing when they are minted (`_mint`),
796      * and stop existing when they are burned (`_burn`).
797      */
798     function _exists(uint256 tokenId) internal view virtual returns (bool) {
799         return _owners[tokenId] != address(0);
800     }
801 
802     /**
803      * @dev Returns whether `spender` is allowed to manage `tokenId`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
810         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
811         address owner = ERC721.ownerOf(tokenId);
812         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
813     }
814 
815     /**
816      * @dev Safely mints `tokenId` and transfers it to `to`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _safeMint(address to, uint256 tokenId) internal virtual {
826         _safeMint(to, tokenId, "");
827     }
828 
829     /**
830      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
831      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
832      */
833     function _safeMint(
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) internal virtual {
838         _mint(to, tokenId);
839         require(
840             _checkOnERC721Received(address(0), to, tokenId, _data),
841             "ERC721: transfer to non ERC721Receiver implementer"
842         );
843     }
844 
845     /**
846      * @dev Mints `tokenId` and transfers it to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
849      *
850      * Requirements:
851      *
852      * - `tokenId` must not exist.
853      * - `to` cannot be the zero address.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _mint(address to, uint256 tokenId) internal virtual {
858         require(to != address(0), "ERC721: mint to the zero address");
859         require(!_exists(tokenId), "ERC721: token already minted");
860 
861         _beforeTokenTransfer(address(0), to, tokenId);
862 
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(address(0), to, tokenId);
867     }
868 
869     /**
870      * @dev Destroys `tokenId`.
871      * The approval is cleared when the token is burned.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         address owner = ERC721.ownerOf(tokenId);
881 
882         _beforeTokenTransfer(owner, address(0), tokenId);
883 
884         // Clear approvals
885         _approve(address(0), tokenId);
886 
887         _balances[owner] -= 1;
888         delete _owners[tokenId];
889 
890         emit Transfer(owner, address(0), tokenId);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {
909         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
910         require(to != address(0), "ERC721: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, tokenId);
913 
914         // Clear approvals from the previous owner
915         _approve(address(0), tokenId);
916 
917         _balances[from] -= 1;
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev Approve `to` to operate on `tokenId`
926      *
927      * Emits a {Approval} event.
928      */
929     function _approve(address to, uint256 tokenId) internal virtual {
930         _tokenApprovals[tokenId] = to;
931         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
932     }
933 
934     /**
935      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
936      * The call is not executed if the target address is not a contract.
937      *
938      * @param from address representing the previous owner of the given token ID
939      * @param to target address that will receive the tokens
940      * @param tokenId uint256 ID of the token to be transferred
941      * @param _data bytes optional data to send along with the call
942      * @return bool whether the call correctly returned the expected magic value
943      */
944     function _checkOnERC721Received(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) private returns (bool) {
950         if (to.isContract()) {
951             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
952                 return retval == IERC721Receiver(to).onERC721Received.selector;
953             } catch (bytes memory reason) {
954                 if (reason.length == 0) {
955                     revert("ERC721: transfer to non ERC721Receiver implementer");
956                 } else {
957                     assembly {
958                         revert(add(32, reason), mload(reason))
959                     }
960                 }
961             }
962         } else {
963             return true;
964         }
965     }
966 
967     /**
968      * @dev Hook that is called before any token transfer. This includes minting
969      * and burning.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` will be minted for `to`.
976      * - When `to` is zero, ``from``'s `tokenId` will be burned.
977      * - `from` and `to` are never both zero.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _beforeTokenTransfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) internal virtual {}
986 }
987 
988 
989 
990 
991 
992 
993 
994 /**
995  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
996  * @dev See https://eips.ethereum.org/EIPS/eip-721
997  */
998 interface IERC721Enumerable is IERC721 {
999     /**
1000      * @dev Returns the total amount of tokens stored by the contract.
1001      */
1002     function totalSupply() external view returns (uint256);
1003 
1004     /**
1005      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1006      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1007      */
1008     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1009 
1010     /**
1011      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1012      * Use along with {totalSupply} to enumerate all tokens.
1013      */
1014     function tokenByIndex(uint256 index) external view returns (uint256);
1015 }
1016 
1017 
1018 /**
1019  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1020  * enumerability of all the token ids in the contract as well as all token ids owned by each
1021  * account.
1022  */
1023 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1024     // Mapping from owner to list of owned token IDs
1025     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1026 
1027     // Mapping from token ID to index of the owner tokens list
1028     mapping(uint256 => uint256) private _ownedTokensIndex;
1029 
1030     // Array with all token ids, used for enumeration
1031     uint256[] private _allTokens;
1032 
1033     // Mapping from token id to position in the allTokens array
1034     mapping(uint256 => uint256) private _allTokensIndex;
1035 
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1040         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1045      */
1046     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1047         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1048         return _ownedTokens[owner][index];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-totalSupply}.
1053      */
1054     function totalSupply() public view virtual override returns (uint256) {
1055         return _allTokens.length;
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-tokenByIndex}.
1060      */
1061     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1062         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1063         return _allTokens[index];
1064     }
1065 
1066     /**
1067      * @dev Hook that is called before any token transfer. This includes minting
1068      * and burning.
1069      *
1070      * Calling conditions:
1071      *
1072      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1073      * transferred to `to`.
1074      * - When `from` is zero, `tokenId` will be minted for `to`.
1075      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) internal virtual override {
1086         super._beforeTokenTransfer(from, to, tokenId);
1087 
1088         if (from == address(0)) {
1089             _addTokenToAllTokensEnumeration(tokenId);
1090         } else if (from != to) {
1091             _removeTokenFromOwnerEnumeration(from, tokenId);
1092         }
1093         if (to == address(0)) {
1094             _removeTokenFromAllTokensEnumeration(tokenId);
1095         } else if (to != from) {
1096             _addTokenToOwnerEnumeration(to, tokenId);
1097         }
1098     }
1099 
1100     /**
1101      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1102      * @param to address representing the new owner of the given token ID
1103      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1104      */
1105     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1106         uint256 length = ERC721.balanceOf(to);
1107         _ownedTokens[to][length] = tokenId;
1108         _ownedTokensIndex[tokenId] = length;
1109     }
1110 
1111     /**
1112      * @dev Private function to add a token to this extension's token tracking data structures.
1113      * @param tokenId uint256 ID of the token to be added to the tokens list
1114      */
1115     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1116         _allTokensIndex[tokenId] = _allTokens.length;
1117         _allTokens.push(tokenId);
1118     }
1119 
1120     /**
1121      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1122      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1123      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1124      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1125      * @param from address representing the previous owner of the given token ID
1126      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1127      */
1128     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1129         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1130         // then delete the last slot (swap and pop).
1131 
1132         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1133         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1134 
1135         // When the token to delete is the last token, the swap operation is unnecessary
1136         if (tokenIndex != lastTokenIndex) {
1137             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1138 
1139             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1140             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1141         }
1142 
1143         // This also deletes the contents at the last position of the array
1144         delete _ownedTokensIndex[tokenId];
1145         delete _ownedTokens[from][lastTokenIndex];
1146     }
1147 
1148     /**
1149      * @dev Private function to remove a token from this extension's token tracking data structures.
1150      * This has O(1) time complexity, but alters the order of the _allTokens array.
1151      * @param tokenId uint256 ID of the token to be removed from the tokens list
1152      */
1153     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1154         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1155         // then delete the last slot (swap and pop).
1156 
1157         uint256 lastTokenIndex = _allTokens.length - 1;
1158         uint256 tokenIndex = _allTokensIndex[tokenId];
1159 
1160         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1161         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1162         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1163         uint256 lastTokenId = _allTokens[lastTokenIndex];
1164 
1165         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1166         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1167 
1168         // This also deletes the contents at the last position of the array
1169         delete _allTokensIndex[tokenId];
1170         _allTokens.pop();
1171     }
1172 }
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 /**
1181  * @dev Contract module which provides a basic access control mechanism, where
1182  * there is an account (an owner) that can be granted exclusive access to
1183  * specific functions.
1184  *
1185  * By default, the owner account will be the one that deploys the contract. This
1186  * can later be changed with {transferOwnership}.
1187  *
1188  * This module is used through inheritance. It will make available the modifier
1189  * `onlyOwner`, which can be applied to your functions to restrict their use to
1190  * the owner.
1191  */
1192 abstract contract Ownable is Context {
1193     address private _owner;
1194 
1195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1196 
1197     /**
1198      * @dev Initializes the contract setting the deployer as the initial owner.
1199      */
1200     constructor() {
1201         _setOwner(_msgSender());
1202     }
1203 
1204     /**
1205      * @dev Returns the address of the current owner.
1206      */
1207     function owner() public view virtual returns (address) {
1208         return _owner;
1209     }
1210 
1211     /**
1212      * @dev Throws if called by any account other than the owner.
1213      */
1214     modifier onlyOwner() {
1215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1216         _;
1217     }
1218 
1219     /**
1220      * @dev Leaves the contract without owner. It will not be possible to call
1221      * `onlyOwner` functions anymore. Can only be called by the current owner.
1222      *
1223      * NOTE: Renouncing ownership will leave the contract without an owner,
1224      * thereby removing any functionality that is only available to the owner.
1225      */
1226     function renounceOwnership() public virtual onlyOwner {
1227         _setOwner(address(0));
1228     }
1229 
1230     /**
1231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1232      * Can only be called by the current owner.
1233      */
1234     function transferOwnership(address newOwner) public virtual onlyOwner {
1235         require(newOwner != address(0), "Ownable: new owner is the zero address");
1236         _setOwner(newOwner);
1237     }
1238 
1239     function _setOwner(address newOwner) private {
1240         address oldOwner = _owner;
1241         _owner = newOwner;
1242         emit OwnershipTransferred(oldOwner, newOwner);
1243     }
1244 }
1245 
1246 
1247 
1248 
1249 
1250 /**
1251  * @dev These functions deal with verification of Merkle Trees proofs.
1252  *
1253  * The proofs can be generated using the JavaScript library
1254  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1255  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1256  *
1257  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1258  */
1259 library MerkleProof {
1260     /**
1261      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1262      * defined by `root`. For this, a `proof` must be provided, containing
1263      * sibling hashes on the branch from the leaf to the root of the tree. Each
1264      * pair of leaves and each pair of pre-images are assumed to be sorted.
1265      */
1266     function verify(
1267         bytes32[] memory proof,
1268         bytes32 root,
1269         bytes32 leaf
1270     ) internal pure returns (bool) {
1271         bytes32 computedHash = leaf;
1272 
1273         for (uint256 i = 0; i < proof.length; i++) {
1274             bytes32 proofElement = proof[i];
1275 
1276             if (computedHash <= proofElement) {
1277                 // Hash(current computed hash + current element of the proof)
1278                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1279             } else {
1280                 // Hash(current element of the proof + current computed hash)
1281                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1282             }
1283         }
1284 
1285         // Check if the computed hash (root) is equal to the provided root
1286         return computedHash == root;
1287     }
1288 }
1289 
1290 
1291 
1292 // CAUTION
1293 // This version of SafeMath should only be used with Solidity 0.8 or later,
1294 // because it relies on the compiler's built in overflow checks.
1295 
1296 /**
1297  * @dev Wrappers over Solidity's arithmetic operations.
1298  *
1299  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1300  * now has built in overflow checking.
1301  */
1302 library SafeMath {
1303     /**
1304      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1305      *
1306      * _Available since v3.4._
1307      */
1308     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1309         unchecked {
1310             uint256 c = a + b;
1311             if (c < a) return (false, 0);
1312             return (true, c);
1313         }
1314     }
1315 
1316     /**
1317      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1318      *
1319      * _Available since v3.4._
1320      */
1321     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1322         unchecked {
1323             if (b > a) return (false, 0);
1324             return (true, a - b);
1325         }
1326     }
1327 
1328     /**
1329      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1330      *
1331      * _Available since v3.4._
1332      */
1333     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1334         unchecked {
1335             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1336             // benefit is lost if 'b' is also tested.
1337             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1338             if (a == 0) return (true, 0);
1339             uint256 c = a * b;
1340             if (c / a != b) return (false, 0);
1341             return (true, c);
1342         }
1343     }
1344 
1345     /**
1346      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1347      *
1348      * _Available since v3.4._
1349      */
1350     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1351         unchecked {
1352             if (b == 0) return (false, 0);
1353             return (true, a / b);
1354         }
1355     }
1356 
1357     /**
1358      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1359      *
1360      * _Available since v3.4._
1361      */
1362     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1363         unchecked {
1364             if (b == 0) return (false, 0);
1365             return (true, a % b);
1366         }
1367     }
1368 
1369     /**
1370      * @dev Returns the addition of two unsigned integers, reverting on
1371      * overflow.
1372      *
1373      * Counterpart to Solidity's `+` operator.
1374      *
1375      * Requirements:
1376      *
1377      * - Addition cannot overflow.
1378      */
1379     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1380         return a + b;
1381     }
1382 
1383     /**
1384      * @dev Returns the subtraction of two unsigned integers, reverting on
1385      * overflow (when the result is negative).
1386      *
1387      * Counterpart to Solidity's `-` operator.
1388      *
1389      * Requirements:
1390      *
1391      * - Subtraction cannot overflow.
1392      */
1393     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1394         return a - b;
1395     }
1396 
1397     /**
1398      * @dev Returns the multiplication of two unsigned integers, reverting on
1399      * overflow.
1400      *
1401      * Counterpart to Solidity's `*` operator.
1402      *
1403      * Requirements:
1404      *
1405      * - Multiplication cannot overflow.
1406      */
1407     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1408         return a * b;
1409     }
1410 
1411     /**
1412      * @dev Returns the integer division of two unsigned integers, reverting on
1413      * division by zero. The result is rounded towards zero.
1414      *
1415      * Counterpart to Solidity's `/` operator.
1416      *
1417      * Requirements:
1418      *
1419      * - The divisor cannot be zero.
1420      */
1421     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1422         return a / b;
1423     }
1424 
1425     /**
1426      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1427      * reverting when dividing by zero.
1428      *
1429      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1430      * opcode (which leaves remaining gas untouched) while Solidity uses an
1431      * invalid opcode to revert (consuming all remaining gas).
1432      *
1433      * Requirements:
1434      *
1435      * - The divisor cannot be zero.
1436      */
1437     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1438         return a % b;
1439     }
1440 
1441     /**
1442      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1443      * overflow (when the result is negative).
1444      *
1445      * CAUTION: This function is deprecated because it requires allocating memory for the error
1446      * message unnecessarily. For custom revert reasons use {trySub}.
1447      *
1448      * Counterpart to Solidity's `-` operator.
1449      *
1450      * Requirements:
1451      *
1452      * - Subtraction cannot overflow.
1453      */
1454     function sub(
1455         uint256 a,
1456         uint256 b,
1457         string memory errorMessage
1458     ) internal pure returns (uint256) {
1459         unchecked {
1460             require(b <= a, errorMessage);
1461             return a - b;
1462         }
1463     }
1464 
1465     /**
1466      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1467      * division by zero. The result is rounded towards zero.
1468      *
1469      * Counterpart to Solidity's `/` operator. Note: this function uses a
1470      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1471      * uses an invalid opcode to revert (consuming all remaining gas).
1472      *
1473      * Requirements:
1474      *
1475      * - The divisor cannot be zero.
1476      */
1477     function div(
1478         uint256 a,
1479         uint256 b,
1480         string memory errorMessage
1481     ) internal pure returns (uint256) {
1482         unchecked {
1483             require(b > 0, errorMessage);
1484             return a / b;
1485         }
1486     }
1487 
1488     /**
1489      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1490      * reverting with custom message when dividing by zero.
1491      *
1492      * CAUTION: This function is deprecated because it requires allocating memory for the error
1493      * message unnecessarily. For custom revert reasons use {tryMod}.
1494      *
1495      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1496      * opcode (which leaves remaining gas untouched) while Solidity uses an
1497      * invalid opcode to revert (consuming all remaining gas).
1498      *
1499      * Requirements:
1500      *
1501      * - The divisor cannot be zero.
1502      */
1503     function mod(
1504         uint256 a,
1505         uint256 b,
1506         string memory errorMessage
1507     ) internal pure returns (uint256) {
1508         unchecked {
1509             require(b > 0, errorMessage);
1510             return a % b;
1511         }
1512     }
1513 }
1514 
1515 /*
1516 __/\\\\\\\\\\\\_______________________________________________________________________________________________________________________________________________________________________        
1517  _\/\\\////////\\\_____________________________________________________________________________________________________________________________________________________________________       
1518   _\/\\\______\//\\\_______________________________________________________________/\\\__________________________________________________/\\\___________________________________________      
1519   _\/\\\_______\/\\\_____/\\\\\\\\______/\\\\\\\\_____/\\\\\\\\___/\\/\\\\\\____/\\\\\\\\\\\__/\\/\\\\\\\___/\\\\\\\\\_____/\\\\\\\\\\\_\///___/\\/\\\\\\_______/\\\\\\\\___/\\\\\\\\\\_     
1520     _\/\\\_______\/\\\___/\\\/////\\\___/\\\//////____/\\\/////\\\_\/\\\////\\\__\////\\\////__\/\\\/////\\\_\////////\\\___\///////\\\/___/\\\_\/\\\////\\\____/\\\/////\\\_\/\\\//////__    
1521      _\/\\\_______\/\\\__/\\\\\\\\\\\___/\\\__________/\\\\\\\\\\\__\/\\\__\//\\\____\/\\\______\/\\\___\///____/\\\\\\\\\\_______/\\\/____\/\\\_\/\\\__\//\\\__/\\\\\\\\\\\__\/\\\\\\\\\\_   
1522       _\/\\\_______/\\\__\//\\///////___\//\\\________\//\\///////___\/\\\___\/\\\____\/\\\_/\\__\/\\\__________/\\\/////\\\_____/\\\/______\/\\\_\/\\\___\/\\\_\//\\///////___\////////\\\_  
1523       _\/\\\\\\\\\\\\/____\//\\\\\\\\\\__\///\\\\\\\\__\//\\\\\\\\\\_\/\\\___\/\\\____\//\\\\\___\/\\\_________\//\\\\\\\\/\\__/\\\\\\\\\\\_\/\\\_\/\\\___\/\\\__\//\\\\\\\\\\__/\\\\\\\\\\_ 
1524         _\////////////_______\//////////_____\////////____\//////////__\///____\///______\/////____\///___________\////////\//__\///////////__\///__\///____\///____\//////////__\//////////__
1525 */
1526 
1527 contract Decentrazines is ERC721Enumerable, Ownable {
1528     using SafeMath for uint256;
1529     
1530     mapping(address => uint256) private presaleLimit;
1531 
1532     string baseURI;
1533     bytes32 private merkleRoot;
1534     uint256 private reserved = 20;
1535     uint256 private mintCost = 0.03 ether; 
1536     uint256 private maxSupply = 10000;
1537     uint256 public presaleStartTime = 1633176000; 
1538     uint256 public presaleLengthTime = 16 hours;
1539 
1540 
1541     constructor(string memory baseTokenURI) ERC721("Decentrazines", "DZINE")  {
1542         setBaseURI(baseTokenURI);
1543     }
1544 
1545     function _baseURI() internal view virtual override returns (string memory) {
1546         return baseURI;
1547     }
1548 
1549     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1550         baseURI = _baseTokenURI;
1551     }
1552     
1553     function setMerkleRoot (bytes32 _merkleRoot) public onlyOwner {
1554         merkleRoot = _merkleRoot;
1555     }
1556     
1557     function claimPresale(
1558         bytes32[] memory proof,
1559         uint256 _quantity
1560     ) public payable {
1561         uint256 supply = totalSupply();
1562 
1563         require( block.timestamp >= presaleStartTime,           "Presale has not started yet" );
1564         require( supply + _quantity < maxSupply - reserved,     "Exceeds supply" );
1565         require( presaleLimit[msg.sender] + _quantity < 21,     "Maximum 20 Decentrazines per Address for presale");
1566         require( msg.value >= mintCost.mul(_quantity),          "Insufficient Ether" );
1567         
1568         // Verify that address belongs in MerkleTree
1569         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1570         bool merkleProof = MerkleProof.verify(proof, merkleRoot, leaf);
1571         require(merkleProof, 'Account ineligible');
1572         
1573         // Verify that amount is 20 or less
1574         require(_quantity < 21, "Max 20");
1575         require(presaleLimit[msg.sender] < 21, "Max 20 ");
1576         for(uint256 i; i < _quantity; i++) {
1577             _safeMint( msg.sender, supply + i + 1);
1578         }
1579         presaleLimit[msg.sender] = presaleLimit[msg.sender] + _quantity;
1580     }
1581     
1582     function claimPublicSale(
1583         uint256 _quantity
1584     ) public payable {
1585         uint256 supply = totalSupply();
1586         
1587         require( block.timestamp >= presaleStartTime + presaleLengthTime,   "Presale has not started yet" );
1588         require( supply + _quantity < maxSupply - reserved,                 "Exceeds supply" );
1589         require( msg.value >= mintCost.mul(_quantity),                      "Insufficient Ether" );
1590 
1591         // Verify that amount is 20 or less
1592         require(_quantity < 21, "Max 20");
1593         for(uint256 i; i < _quantity; i++){
1594             _safeMint( msg.sender, supply + i + 1);
1595         }
1596     }
1597     
1598     function teamClaim(address _to, uint256 _amount) external onlyOwner {
1599         require( _amount <= reserved, "Exceeds reserved supply" );
1600         uint256 supply = totalSupply();
1601         for(uint256 i=maxSupply-reserved; i < _amount+maxSupply-reserved; i++){
1602             _safeMint( _to, supply + i );
1603         }
1604     }
1605 
1606     function withdrawal() public payable onlyOwner {
1607         address a1 = 0x740975Bdc13e4253c0b8aF32f5271EF0aD6Dd52e;
1608         address a2 = 0x75760AbB406DF0aaf44944109fcaf5d581913063;
1609         address a3 = 0x13F3cF1111d47d8b6Fe0d7E1bea591e1F43f389c;
1610         address a4 = 0x666348D1E5403bbAA71e7C8e912bdE08a5c93Bf9;
1611         address a5 = 0x792c22EB036372007b37367ed50f164736034480;
1612         address a6 = 0xa7818c675469c3A09Fe6D26f6B17A33B3eFB93c5;
1613         address a7 = 0x4729f800b85D10be1b15785Fb0553F835E5B036e;
1614 
1615 
1616         uint256 bal1 = address(this).balance.mul(515).div(1000);
1617         uint256 bal2 = address(this).balance.mul(150).div(1000);
1618         uint256 bal3 = address(this).balance.mul(150).div(1000);
1619         uint256 bal4 = address(this).balance.mul(100).div(1000);
1620         uint256 bal5 = address(this).balance.mul(50).div(1000);
1621         uint256 bal6 = address(this).balance.mul(10).div(1000);
1622         uint256 bal7 = address(this).balance.mul(25).div(1000);
1623 
1624 
1625         require(payable(a1).send(bal1));
1626         require(payable(a2).send(bal2));
1627         require(payable(a3).send(bal3));
1628         require(payable(a4).send(bal4));
1629         require(payable(a5).send(bal5));
1630         require(payable(a6).send(bal6));
1631         require(payable(a7).send(bal7));
1632     }
1633 }