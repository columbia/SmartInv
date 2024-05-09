1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 /*
6                                                                                                                                                 
7 _/_/_/_/_/                                        _/                                    _/_/_/_/_/  _/                                          
8    _/      _/_/    _/_/_/      _/_/_/    _/_/_/        _/_/    _/    _/    _/_/_/          _/            _/_/_/    _/_/    _/  _/_/    _/_/_/   
9   _/    _/_/_/_/  _/    _/  _/    _/  _/        _/  _/    _/  _/    _/  _/_/              _/      _/  _/    _/  _/_/_/_/  _/_/      _/_/        
10  _/    _/        _/    _/  _/    _/  _/        _/  _/    _/  _/    _/      _/_/          _/      _/  _/    _/  _/        _/            _/_/     
11 _/      _/_/_/  _/    _/    _/_/_/    _/_/_/  _/    _/_/      _/_/_/  _/_/_/            _/      _/    _/_/_/    _/_/_/  _/        _/_/_/        
12                                                                                                          _/                                     
13                                                                                                     _/_/                                        
14 
15 
16                                                  ___..........__
17                            _,...._           _."'_,.++8n.n8898n.`"._        _....._
18                          .'       `".     _.'_.'" _.98n.68n. `"88n. `'.   ,"       `.
19                         /        .   `. ,'. "  -'" __.68`""'""=._`+8.  `.'     .     `.
20                        .       `   .   `.   ,d86+889" 8"""+898n, j8 9 ,"    .          \
21                       :     '       .,   ,d"'"   _..d88b..__ `"868' .'  . '            :
22                       :     .      .    _    ,n8""88":8"888."8.  "               '     :
23                        \     , '  , . .88" ,8P'     ,d8. _   `"8n  `+.      `.   .     '
24                         `.  .. .     d89' "  _..n689+^'8n88n.._ `+  . `  .  , '      ,'
25                           `.  . , '  8'    .d88+"    j:""' `886n.    b`.  ' .' .   ."
26                            '       , .j            ,d'8.         `  ."8.`.   `.  ':
27                             .    .' n8    ,_      .f A 6.      ,..    `8b, '.   .'_
28                           .' _    ,88'   :8"8    6'.d`i.`b.   d8"8     688.  ".    `'
29                         ," .88  .d868  _         ,9:' `8.`8   "'  ` _  8+""      b   `,
30                       _.  d8P  d'  .d :88.     .8'`j   ;+. "     n888b 8  .     ,88.   .
31                      `   :68' ,8   88     `.   '   :   l `     .'   `" jb  .`   688b.   ',
32                     .'  .688  6P   98  =+""`.      `   '       ,-"`+"'+88b 'b.  8689  `   '
33                    ;  .'"888 .8;  ."+b. : `" ;               .: "' ; ,n  `8 q8, '88:       \
34                    .   . 898  8:  :    `.`--"8.              d8`--' '   .d'  ;8  898        '
35                   ,      689  9:  8._       ,68 .        .  :89    ..n88+'   89  689,' `     .
36                   :     ,88'  88  `+88n  -   . .           .        " _.     6:  `868     '   '
37                   , '  .68h.  68      `"    . . .        .  . .             ,8'   8P'      .   .
38                   .      '88  'q.    _.f       .          .  .    '  .._,. .8"   .889        ,
39                  .'     `898   _8hnd8p'  ,  . ..           . .    ._   `89,8P    j"'  _   `
40                   \  `   .88, `q9868' ,9      ..           . .  .   8n .8 d8'   +'   n8. ,  '
41                   ,'    ,+"88n  `"8 .8'     . ..           . .       `8688P"   9'  ,d868'   .  .
42                   .      . `86b.    " .       .            ..          68'      _.698689;      :
43                    . '     ,889_.n8. ,  ` .   .___      ___.     .n"  `86n8b._  `8988'b      .,6
44                     '       q8689'`68.   . `  `:. `.__,' .:'  ,   +   +88 `"688n  `q8 q8.     88
45                     , .   '  "     `+8 n    .   `:.    .;'   . '    . ,89           "  `q,    `8
46                    .   .   ,        .    + c  ,   `:.,:"        , "   d8'               d8.    :
47                     . '  8n           ` , .         ::    . ' "  .  .68h.             .8'`8`.  6
48                      ,    8b.__. ,  .n8688b., .    .;:._     .___nn898868n.         n868b "`   8
49                       `.  `6889868n8898886888688898"' "+89n88898868868889'         688898b    .8
50                        :    q68   `""+8688898P ` " ' . ` '  ' `+688988P"          d8+8P'  `. .d8
51                        ,     88b.       `+88.     `   ` '     .889"'           ,.88'        .,88
52                         :    '988b        "88b.._  ,_      . n8p'           .d8"'      '     689
53                         '.     "888n._,      `"8"+88888n.8,88:`8 .     _ .n88P'   .  `      ;88'
54                          :8.     "q888.  .            "+888P"  "+888n,8n8'"      .  .     ,d986
55                          :.`8:     `88986                          `q8"           ,      :688"
56                          ;.  '8,      "88b .d                        '                  ,889'
57                          :..   `6n      '8988                                         b.89p
58                          :. .    '8.      `88b                                        988'
59                          :. .      8b       `q8.        '                     . '   .d89      '
60                          . .        `8:       `86n,.       " . ,        , "        ,98P      ,
61                          .. .         '6n.       +86b.        .      .         _,.n88'     .
62                            .            `"8b.      'q98n.        ,     .  _..n868688'          .
63                           ' . .            `"98.     `8868.       .  _.n688868898p"            d
64                            . .                '88.      "688.       q89888688868"            ,86
65                          mh '. .                 88.     `8898        " .889"'              .988
66 */
67 
68 /**
69  * @dev Interface of the ERC165 standard, as defined in the
70  * https://eips.ethereum.org/EIPS/eip-165[EIP].
71  *
72  * Implementers can declare support of contract interfaces, which can then be
73  * queried by others ({ERC165Checker}).
74  *
75  * For an implementation, see {ERC165}.
76  */
77 interface IERC165 {
78     /**
79      * @dev Returns true if this contract implements the interface defined by
80      * `interfaceId`. See the corresponding
81      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
82      * to learn more about how these ids are created.
83      *
84      * This function call must use less than 30 000 gas.
85      */
86     function supportsInterface(bytes4 interfaceId) external view returns (bool);
87 }
88 
89 
90 
91 
92 
93 
94 /**
95  * @dev Required interface of an ERC721 compliant contract.
96  */
97 interface IERC721 is IERC165 {
98     /**
99      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102 
103     /**
104      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
105      */
106     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
107 
108     /**
109      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
110      */
111     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
112 
113     /**
114      * @dev Returns the number of tokens in ``owner``'s account.
115      */
116     function balanceOf(address owner) external view returns (uint256 balance);
117 
118     /**
119      * @dev Returns the owner of the `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function ownerOf(uint256 tokenId) external view returns (address owner);
126 
127     /**
128      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
129      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
130      *
131      * Requirements:
132      *
133      * - `from` cannot be the zero address.
134      * - `to` cannot be the zero address.
135      * - `tokenId` token must exist and be owned by `from`.
136      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
137      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
138      *
139      * Emits a {Transfer} event.
140      */
141     function safeTransferFrom(
142         address from,
143         address to,
144         uint256 tokenId
145     ) external;
146 
147     /**
148      * @dev Transfers `tokenId` token from `from` to `to`.
149      *
150      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(
162         address from,
163         address to,
164         uint256 tokenId
165     ) external;
166 
167     /**
168      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
169      * The approval is cleared when the token is transferred.
170      *
171      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
172      *
173      * Requirements:
174      *
175      * - The caller must own the token or be an approved operator.
176      * - `tokenId` must exist.
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address to, uint256 tokenId) external;
181 
182     /**
183      * @dev Returns the account approved for `tokenId` token.
184      *
185      * Requirements:
186      *
187      * - `tokenId` must exist.
188      */
189     function getApproved(uint256 tokenId) external view returns (address operator);
190 
191     /**
192      * @dev Approve or remove `operator` as an operator for the caller.
193      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
194      *
195      * Requirements:
196      *
197      * - The `operator` cannot be the caller.
198      *
199      * Emits an {ApprovalForAll} event.
200      */
201     function setApprovalForAll(address operator, bool _approved) external;
202 
203     /**
204      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
205      *
206      * See {setApprovalForAll}
207      */
208     function isApprovedForAll(address owner, address operator) external view returns (bool);
209 
210     /**
211      * @dev Safely transfers `tokenId` token from `from` to `to`.
212      *
213      * Requirements:
214      *
215      * - `from` cannot be the zero address.
216      * - `to` cannot be the zero address.
217      * - `tokenId` token must exist and be owned by `from`.
218      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
220      *
221      * Emits a {Transfer} event.
222      */
223     function safeTransferFrom(
224         address from,
225         address to,
226         uint256 tokenId,
227         bytes calldata data
228     ) external;
229 }
230 
231 
232 
233 
234 /**
235  * @dev String operations.
236  */
237 library Strings {
238     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
239 
240     /**
241      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
242      */
243     function toString(uint256 value) internal pure returns (string memory) {
244         // Inspired by OraclizeAPI's implementation - MIT licence
245         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
246 
247         if (value == 0) {
248             return "0";
249         }
250         uint256 temp = value;
251         uint256 digits;
252         while (temp != 0) {
253             digits++;
254             temp /= 10;
255         }
256         bytes memory buffer = new bytes(digits);
257         while (value != 0) {
258             digits -= 1;
259             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
260             value /= 10;
261         }
262         return string(buffer);
263     }
264 
265     /**
266      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
267      */
268     function toHexString(uint256 value) internal pure returns (string memory) {
269         if (value == 0) {
270             return "0x00";
271         }
272         uint256 temp = value;
273         uint256 length = 0;
274         while (temp != 0) {
275             length++;
276             temp >>= 8;
277         }
278         return toHexString(value, length);
279     }
280 
281     /**
282      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
283      */
284     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
285         bytes memory buffer = new bytes(2 * length + 2);
286         buffer[0] = "0";
287         buffer[1] = "x";
288         for (uint256 i = 2 * length + 1; i > 1; --i) {
289             buffer[i] = _HEX_SYMBOLS[value & 0xf];
290             value >>= 4;
291         }
292         require(value == 0, "Strings: hex length insufficient");
293         return string(buffer);
294     }
295 }
296 
297 
298 
299 
300 /*
301  * @dev Provides information about the current execution context, including the
302  * sender of the transaction and its data. While these are generally available
303  * via msg.sender and msg.data, they should not be accessed in such a direct
304  * manner, since when dealing with meta-transactions the account sending and
305  * paying for execution may not be the actual sender (as far as an application
306  * is concerned).
307  *
308  * This contract is only required for intermediate, library-like contracts.
309  */
310 abstract contract Context {
311     function _msgSender() internal view virtual returns (address) {
312         return msg.sender;
313     }
314 
315     function _msgData() internal view virtual returns (bytes calldata) {
316         return msg.data;
317     }
318 }
319 
320 
321 
322 
323 
324 
325 
326 
327 
328 
329 
330 
331 
332 
333 
334 
335 
336 /**
337  * @title ERC721 token receiver interface
338  * @dev Interface for any contract that wants to support safeTransfers
339  * from ERC721 asset contracts.
340  */
341 interface IERC721Receiver {
342     /**
343      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
344      * by `operator` from `from`, this function is called.
345      *
346      * It must return its Solidity selector to confirm the token transfer.
347      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
348      *
349      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
350      */
351     function onERC721Received(
352         address operator,
353         address from,
354         uint256 tokenId,
355         bytes calldata data
356     ) external returns (bytes4);
357 }
358 
359 
360 
361 
362 
363 
364 
365 /**
366  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
367  * @dev See https://eips.ethereum.org/EIPS/eip-721
368  */
369 interface IERC721Metadata is IERC721 {
370     /**
371      * @dev Returns the token collection name.
372      */
373     function name() external view returns (string memory);
374 
375     /**
376      * @dev Returns the token collection symbol.
377      */
378     function symbol() external view returns (string memory);
379 
380     /**
381      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
382      */
383     function tokenURI(uint256 tokenId) external view returns (string memory);
384 }
385 
386 
387 
388 
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      */
411     function isContract(address account) internal view returns (bool) {
412         // This method relies on extcodesize, which returns 0 for contracts in
413         // construction, since the code is only stored at the end of the
414         // constructor execution.
415 
416         uint256 size;
417         assembly {
418             size := extcodesize(account)
419         }
420         return size > 0;
421     }
422 
423     /**
424      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
425      * `recipient`, forwarding all available gas and reverting on errors.
426      *
427      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
428      * of certain opcodes, possibly making contracts go over the 2300 gas limit
429      * imposed by `transfer`, making them unable to receive funds via
430      * `transfer`. {sendValue} removes this limitation.
431      *
432      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
433      *
434      * IMPORTANT: because control is transferred to `recipient`, care must be
435      * taken to not create reentrancy vulnerabilities. Consider using
436      * {ReentrancyGuard} or the
437      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
438      */
439     function sendValue(address payable recipient, uint256 amount) internal {
440         require(address(this).balance >= amount, "Address: insufficient balance");
441 
442         (bool success, ) = recipient.call{value: amount}("");
443         require(success, "Address: unable to send value, recipient may have reverted");
444     }
445 
446     /**
447      * @dev Performs a Solidity function call using a low level `call`. A
448      * plain `call` is an unsafe replacement for a function call: use this
449      * function instead.
450      *
451      * If `target` reverts with a revert reason, it is bubbled up by this
452      * function (like regular Solidity function calls).
453      *
454      * Returns the raw returned data. To convert to the expected return value,
455      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
456      *
457      * Requirements:
458      *
459      * - `target` must be a contract.
460      * - calling `target` with `data` must not revert.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
465         return functionCall(target, data, "Address: low-level call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
470      * `errorMessage` as a fallback revert reason when `target` reverts.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         return functionCallWithValue(target, data, 0, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but also transferring `value` wei to `target`.
485      *
486      * Requirements:
487      *
488      * - the calling contract must have an ETH balance of at least `value`.
489      * - the called Solidity function must be `payable`.
490      *
491      * _Available since v3.1._
492      */
493     function functionCallWithValue(
494         address target,
495         bytes memory data,
496         uint256 value
497     ) internal returns (bytes memory) {
498         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
503      * with `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(address(this).balance >= value, "Address: insufficient balance for call");
514         require(isContract(target), "Address: call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.call{value: value}(data);
517         return _verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a static call.
523      *
524      * _Available since v3.3._
525      */
526     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
527         return functionStaticCall(target, data, "Address: low-level static call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal view returns (bytes memory) {
541         require(isContract(target), "Address: static call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.staticcall(data);
544         return _verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
554         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(
564         address target,
565         bytes memory data,
566         string memory errorMessage
567     ) internal returns (bytes memory) {
568         require(isContract(target), "Address: delegate call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.delegatecall(data);
571         return _verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     function _verifyCallResult(
575         bool success,
576         bytes memory returndata,
577         string memory errorMessage
578     ) private pure returns (bytes memory) {
579         if (success) {
580             return returndata;
581         } else {
582             // Look for revert reason and bubble it up if present
583             if (returndata.length > 0) {
584                 // The easiest way to bubble the revert reason is using memory via assembly
585 
586                 assembly {
587                     let returndata_size := mload(returndata)
588                     revert(add(32, returndata), returndata_size)
589                 }
590             } else {
591                 revert(errorMessage);
592             }
593         }
594     }
595 }
596 
597 
598 
599 
600 
601 
602 
603 
604 
605 /**
606  * @dev Implementation of the {IERC165} interface.
607  *
608  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
609  * for the additional interface id that will be supported. For example:
610  *
611  * ```solidity
612  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
614  * }
615  * ```
616  *
617  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
618  */
619 abstract contract ERC165 is IERC165 {
620     /**
621      * @dev See {IERC165-supportsInterface}.
622      */
623     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
624         return interfaceId == type(IERC165).interfaceId;
625     }
626 }
627 
628 
629 /**
630  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
631  * the Metadata extension, but not including the Enumerable extension, which is available separately as
632  * {ERC721Enumerable}.
633  */
634 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
635     using Address for address;
636     using Strings for uint256;
637 
638     // Token name
639     string private _name;
640 
641     // Token symbol
642     string private _symbol;
643 
644     // Mapping from token ID to owner address
645     mapping(uint256 => address) private _owners;
646 
647     // Mapping owner address to token count
648     mapping(address => uint256) private _balances;
649 
650     // Mapping from token ID to approved address
651     mapping(uint256 => address) private _tokenApprovals;
652 
653     // Mapping from owner to operator approvals
654     mapping(address => mapping(address => bool)) private _operatorApprovals;
655 
656     /**
657      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
658      */
659     constructor(string memory name_, string memory symbol_) {
660         _name = name_;
661         _symbol = symbol_;
662     }
663 
664     /**
665      * @dev See {IERC165-supportsInterface}.
666      */
667     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
668         return
669             interfaceId == type(IERC721).interfaceId ||
670             interfaceId == type(IERC721Metadata).interfaceId ||
671             super.supportsInterface(interfaceId);
672     }
673 
674     /**
675      * @dev See {IERC721-balanceOf}.
676      */
677     function balanceOf(address owner) public view virtual override returns (uint256) {
678         require(owner != address(0), "ERC721: balance query for the zero address");
679         return _balances[owner];
680     }
681 
682     /**
683      * @dev See {IERC721-ownerOf}.
684      */
685     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
686         address owner = _owners[tokenId];
687         require(owner != address(0), "ERC721: owner query for nonexistent token");
688         return owner;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-name}.
693      */
694     function name() public view virtual override returns (string memory) {
695         return _name;
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-symbol}.
700      */
701     function symbol() public view virtual override returns (string memory) {
702         return _symbol;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-tokenURI}.
707      */
708     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
709         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
710 
711         string memory baseURI = _baseURI();
712         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
713     }
714 
715     /**
716      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
717      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
718      * by default, can be overriden in child contracts.
719      */
720     function _baseURI() internal view virtual returns (string memory) {
721         return "";
722     }
723 
724     /**
725      * @dev See {IERC721-approve}.
726      */
727     function approve(address to, uint256 tokenId) public virtual override {
728         address owner = ERC721.ownerOf(tokenId);
729         require(to != owner, "ERC721: approval to current owner");
730 
731         require(
732             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
733             "ERC721: approve caller is not owner nor approved for all"
734         );
735 
736         _approve(to, tokenId);
737     }
738 
739     /**
740      * @dev See {IERC721-getApproved}.
741      */
742     function getApproved(uint256 tokenId) public view virtual override returns (address) {
743         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
744 
745         return _tokenApprovals[tokenId];
746     }
747 
748     /**
749      * @dev See {IERC721-setApprovalForAll}.
750      */
751     function setApprovalForAll(address operator, bool approved) public virtual override {
752         require(operator != _msgSender(), "ERC721: approve to caller");
753 
754         _operatorApprovals[_msgSender()][operator] = approved;
755         emit ApprovalForAll(_msgSender(), operator, approved);
756     }
757 
758     /**
759      * @dev See {IERC721-isApprovedForAll}.
760      */
761     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
762         return _operatorApprovals[owner][operator];
763     }
764 
765     /**
766      * @dev See {IERC721-transferFrom}.
767      */
768     function transferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) public virtual override {
773         //solhint-disable-next-line max-line-length
774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
775 
776         _transfer(from, to, tokenId);
777     }
778 
779     /**
780      * @dev See {IERC721-safeTransferFrom}.
781      */
782     function safeTransferFrom(
783         address from,
784         address to,
785         uint256 tokenId
786     ) public virtual override {
787         safeTransferFrom(from, to, tokenId, "");
788     }
789 
790     /**
791      * @dev See {IERC721-safeTransferFrom}.
792      */
793     function safeTransferFrom(
794         address from,
795         address to,
796         uint256 tokenId,
797         bytes memory _data
798     ) public virtual override {
799         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
800         _safeTransfer(from, to, tokenId, _data);
801     }
802 
803     /**
804      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
805      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
806      *
807      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
808      *
809      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
810      * implement alternative mechanisms to perform token transfer, such as signature-based.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must exist and be owned by `from`.
817      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _safeTransfer(
822         address from,
823         address to,
824         uint256 tokenId,
825         bytes memory _data
826     ) internal virtual {
827         _transfer(from, to, tokenId);
828         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
829     }
830 
831     /**
832      * @dev Returns whether `tokenId` exists.
833      *
834      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
835      *
836      * Tokens start existing when they are minted (`_mint`),
837      * and stop existing when they are burned (`_burn`).
838      */
839     function _exists(uint256 tokenId) internal view virtual returns (bool) {
840         return _owners[tokenId] != address(0);
841     }
842 
843     /**
844      * @dev Returns whether `spender` is allowed to manage `tokenId`.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      */
850     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
851         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
852         address owner = ERC721.ownerOf(tokenId);
853         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
854     }
855 
856     /**
857      * @dev Safely mints `tokenId` and transfers it to `to`.
858      *
859      * Requirements:
860      *
861      * - `tokenId` must not exist.
862      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _safeMint(address to, uint256 tokenId) internal virtual {
867         _safeMint(to, tokenId, "");
868     }
869 
870     /**
871      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
872      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
873      */
874     function _safeMint(
875         address to,
876         uint256 tokenId,
877         bytes memory _data
878     ) internal virtual {
879         _mint(to, tokenId);
880         require(
881             _checkOnERC721Received(address(0), to, tokenId, _data),
882             "ERC721: transfer to non ERC721Receiver implementer"
883         );
884     }
885 
886     /**
887      * @dev Mints `tokenId` and transfers it to `to`.
888      *
889      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
890      *
891      * Requirements:
892      *
893      * - `tokenId` must not exist.
894      * - `to` cannot be the zero address.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _mint(address to, uint256 tokenId) internal virtual {
899         require(to != address(0), "ERC721: mint to the zero address");
900         require(!_exists(tokenId), "ERC721: token already minted");
901 
902         _beforeTokenTransfer(address(0), to, tokenId);
903 
904         _balances[to] += 1;
905         _owners[tokenId] = to;
906 
907         emit Transfer(address(0), to, tokenId);
908     }
909 
910     /**
911      * @dev Destroys `tokenId`.
912      * The approval is cleared when the token is burned.
913      *
914      * Requirements:
915      *
916      * - `tokenId` must exist.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _burn(uint256 tokenId) internal virtual {
921         address owner = ERC721.ownerOf(tokenId);
922 
923         _beforeTokenTransfer(owner, address(0), tokenId);
924 
925         // Clear approvals
926         _approve(address(0), tokenId);
927 
928         _balances[owner] -= 1;
929         delete _owners[tokenId];
930 
931         emit Transfer(owner, address(0), tokenId);
932     }
933 
934     /**
935      * @dev Transfers `tokenId` from `from` to `to`.
936      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
937      *
938      * Requirements:
939      *
940      * - `to` cannot be the zero address.
941      * - `tokenId` token must be owned by `from`.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _transfer(
946         address from,
947         address to,
948         uint256 tokenId
949     ) internal virtual {
950         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
951         require(to != address(0), "ERC721: transfer to the zero address");
952 
953         _beforeTokenTransfer(from, to, tokenId);
954 
955         // Clear approvals from the previous owner
956         _approve(address(0), tokenId);
957 
958         _balances[from] -= 1;
959         _balances[to] += 1;
960         _owners[tokenId] = to;
961 
962         emit Transfer(from, to, tokenId);
963     }
964 
965     /**
966      * @dev Approve `to` to operate on `tokenId`
967      *
968      * Emits a {Approval} event.
969      */
970     function _approve(address to, uint256 tokenId) internal virtual {
971         _tokenApprovals[tokenId] = to;
972         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
973     }
974 
975     /**
976      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
977      * The call is not executed if the target address is not a contract.
978      *
979      * @param from address representing the previous owner of the given token ID
980      * @param to target address that will receive the tokens
981      * @param tokenId uint256 ID of the token to be transferred
982      * @param _data bytes optional data to send along with the call
983      * @return bool whether the call correctly returned the expected magic value
984      */
985     function _checkOnERC721Received(
986         address from,
987         address to,
988         uint256 tokenId,
989         bytes memory _data
990     ) private returns (bool) {
991         if (to.isContract()) {
992             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
993                 return retval == IERC721Receiver(to).onERC721Received.selector;
994             } catch (bytes memory reason) {
995                 if (reason.length == 0) {
996                     revert("ERC721: transfer to non ERC721Receiver implementer");
997                 } else {
998                     assembly {
999                         revert(add(32, reason), mload(reason))
1000                     }
1001                 }
1002             }
1003         } else {
1004             return true;
1005         }
1006     }
1007 
1008     /**
1009      * @dev Hook that is called before any token transfer. This includes minting
1010      * and burning.
1011      *
1012      * Calling conditions:
1013      *
1014      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1015      * transferred to `to`.
1016      * - When `from` is zero, `tokenId` will be minted for `to`.
1017      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1018      * - `from` and `to` are never both zero.
1019      *
1020      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1021      */
1022     function _beforeTokenTransfer(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) internal virtual {}
1027 }
1028 
1029 
1030 
1031 
1032 
1033 
1034 
1035 /**
1036  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1037  * @dev See https://eips.ethereum.org/EIPS/eip-721
1038  */
1039 interface IERC721Enumerable is IERC721 {
1040     /**
1041      * @dev Returns the total amount of tokens stored by the contract.
1042      */
1043     function totalSupply() external view returns (uint256);
1044 
1045     /**
1046      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1047      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1048      */
1049     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1050 
1051     /**
1052      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1053      * Use along with {totalSupply} to enumerate all tokens.
1054      */
1055     function tokenByIndex(uint256 index) external view returns (uint256);
1056 }
1057 
1058 
1059 /**
1060  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1061  * enumerability of all the token ids in the contract as well as all token ids owned by each
1062  * account.
1063  */
1064 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1065     // Mapping from owner to list of owned token IDs
1066     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1067 
1068     // Mapping from token ID to index of the owner tokens list
1069     mapping(uint256 => uint256) private _ownedTokensIndex;
1070 
1071     // Array with all token ids, used for enumeration
1072     uint256[] private _allTokens;
1073 
1074     // Mapping from token id to position in the allTokens array
1075     mapping(uint256 => uint256) private _allTokensIndex;
1076 
1077     /**
1078      * @dev See {IERC165-supportsInterface}.
1079      */
1080     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1081         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1086      */
1087     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1088         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1089         return _ownedTokens[owner][index];
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Enumerable-totalSupply}.
1094      */
1095     function totalSupply() public view virtual override returns (uint256) {
1096         return _allTokens.length;
1097     }
1098 
1099     /**
1100      * @dev See {IERC721Enumerable-tokenByIndex}.
1101      */
1102     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1103         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1104         return _allTokens[index];
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before any token transfer. This includes minting
1109      * and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1117      * - `from` cannot be the zero address.
1118      * - `to` cannot be the zero address.
1119      *
1120      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1121      */
1122     function _beforeTokenTransfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual override {
1127         super._beforeTokenTransfer(from, to, tokenId);
1128 
1129         if (from == address(0)) {
1130             _addTokenToAllTokensEnumeration(tokenId);
1131         } else if (from != to) {
1132             _removeTokenFromOwnerEnumeration(from, tokenId);
1133         }
1134         if (to == address(0)) {
1135             _removeTokenFromAllTokensEnumeration(tokenId);
1136         } else if (to != from) {
1137             _addTokenToOwnerEnumeration(to, tokenId);
1138         }
1139     }
1140 
1141     /**
1142      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1143      * @param to address representing the new owner of the given token ID
1144      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1145      */
1146     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1147         uint256 length = ERC721.balanceOf(to);
1148         _ownedTokens[to][length] = tokenId;
1149         _ownedTokensIndex[tokenId] = length;
1150     }
1151 
1152     /**
1153      * @dev Private function to add a token to this extension's token tracking data structures.
1154      * @param tokenId uint256 ID of the token to be added to the tokens list
1155      */
1156     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1157         _allTokensIndex[tokenId] = _allTokens.length;
1158         _allTokens.push(tokenId);
1159     }
1160 
1161     /**
1162      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1163      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1164      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1165      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1166      * @param from address representing the previous owner of the given token ID
1167      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1168      */
1169     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1170         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1171         // then delete the last slot (swap and pop).
1172 
1173         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1174         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1175 
1176         // When the token to delete is the last token, the swap operation is unnecessary
1177         if (tokenIndex != lastTokenIndex) {
1178             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1179 
1180             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1181             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1182         }
1183 
1184         // This also deletes the contents at the last position of the array
1185         delete _ownedTokensIndex[tokenId];
1186         delete _ownedTokens[from][lastTokenIndex];
1187     }
1188 
1189     /**
1190      * @dev Private function to remove a token from this extension's token tracking data structures.
1191      * This has O(1) time complexity, but alters the order of the _allTokens array.
1192      * @param tokenId uint256 ID of the token to be removed from the tokens list
1193      */
1194     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1195         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1196         // then delete the last slot (swap and pop).
1197 
1198         uint256 lastTokenIndex = _allTokens.length - 1;
1199         uint256 tokenIndex = _allTokensIndex[tokenId];
1200 
1201         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1202         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1203         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1204         uint256 lastTokenId = _allTokens[lastTokenIndex];
1205 
1206         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1207         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1208 
1209         // This also deletes the contents at the last position of the array
1210         delete _allTokensIndex[tokenId];
1211         _allTokens.pop();
1212     }
1213 }
1214 
1215 
1216 
1217 
1218 
1219 
1220 
1221 /**
1222  * @dev Contract module which provides a basic access control mechanism, where
1223  * there is an account (an owner) that can be granted exclusive access to
1224  * specific functions.
1225  *
1226  * By default, the owner account will be the one that deploys the contract. This
1227  * can later be changed with {transferOwnership}.
1228  *
1229  * This module is used through inheritance. It will make available the modifier
1230  * `onlyOwner`, which can be applied to your functions to restrict their use to
1231  * the owner.
1232  */
1233 abstract contract Ownable is Context {
1234     address private _owner;
1235 
1236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1237 
1238     /**
1239      * @dev Initializes the contract setting the deployer as the initial owner.
1240      */
1241     constructor() {
1242         _setOwner(_msgSender());
1243     }
1244 
1245     /**
1246      * @dev Returns the address of the current owner.
1247      */
1248     function owner() public view virtual returns (address) {
1249         return _owner;
1250     }
1251 
1252     /**
1253      * @dev Throws if called by any account other than the owner.
1254      */
1255     modifier onlyOwner() {
1256         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1257         _;
1258     }
1259 
1260     /**
1261      * @dev Leaves the contract without owner. It will not be possible to call
1262      * `onlyOwner` functions anymore. Can only be called by the current owner.
1263      *
1264      * NOTE: Renouncing ownership will leave the contract without an owner,
1265      * thereby removing any functionality that is only available to the owner.
1266      */
1267     function renounceOwnership() public virtual onlyOwner {
1268         _setOwner(address(0));
1269     }
1270 
1271     /**
1272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1273      * Can only be called by the current owner.
1274      */
1275     function transferOwnership(address newOwner) public virtual onlyOwner {
1276         require(newOwner != address(0), "Ownable: new owner is the zero address");
1277         _setOwner(newOwner);
1278     }
1279 
1280     function _setOwner(address newOwner) private {
1281         address oldOwner = _owner;
1282         _owner = newOwner;
1283         emit OwnershipTransferred(oldOwner, newOwner);
1284     }
1285 }
1286 
1287 
1288 
1289 
1290 
1291 /**
1292  * @dev These functions deal with verification of Merkle Trees proofs.
1293  *
1294  * The proofs can be generated using the JavaScript library
1295  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1296  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1297  *
1298  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1299  */
1300 library MerkleProof {
1301     /**
1302      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1303      * defined by `root`. For this, a `proof` must be provided, containing
1304      * sibling hashes on the branch from the leaf to the root of the tree. Each
1305      * pair of leaves and each pair of pre-images are assumed to be sorted.
1306      */
1307     function verify(
1308         bytes32[] memory proof,
1309         bytes32 root,
1310         bytes32 leaf
1311     ) internal pure returns (bool) {
1312         bytes32 computedHash = leaf;
1313 
1314         for (uint256 i = 0; i < proof.length; i++) {
1315             bytes32 proofElement = proof[i];
1316 
1317             if (computedHash <= proofElement) {
1318                 // Hash(current computed hash + current element of the proof)
1319                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1320             } else {
1321                 // Hash(current element of the proof + current computed hash)
1322                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1323             }
1324         }
1325 
1326         // Check if the computed hash (root) is equal to the provided root
1327         return computedHash == root;
1328     }
1329 }
1330 
1331 
1332 
1333 // CAUTION
1334 // This version of SafeMath should only be used with Solidity 0.8 or later,
1335 // because it relies on the compiler's built in overflow checks.
1336 
1337 /**
1338  * @dev Wrappers over Solidity's arithmetic operations.
1339  *
1340  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1341  * now has built in overflow checking.
1342  */
1343 library SafeMath {
1344     /**
1345      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1346      *
1347      * _Available since v3.4._
1348      */
1349     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1350         unchecked {
1351             uint256 c = a + b;
1352             if (c < a) return (false, 0);
1353             return (true, c);
1354         }
1355     }
1356 
1357     /**
1358      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1359      *
1360      * _Available since v3.4._
1361      */
1362     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1363         unchecked {
1364             if (b > a) return (false, 0);
1365             return (true, a - b);
1366         }
1367     }
1368 
1369     /**
1370      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1371      *
1372      * _Available since v3.4._
1373      */
1374     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1375         unchecked {
1376             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1377             // benefit is lost if 'b' is also tested.
1378             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1379             if (a == 0) return (true, 0);
1380             uint256 c = a * b;
1381             if (c / a != b) return (false, 0);
1382             return (true, c);
1383         }
1384     }
1385 
1386     /**
1387      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1388      *
1389      * _Available since v3.4._
1390      */
1391     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1392         unchecked {
1393             if (b == 0) return (false, 0);
1394             return (true, a / b);
1395         }
1396     }
1397 
1398     /**
1399      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1400      *
1401      * _Available since v3.4._
1402      */
1403     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1404         unchecked {
1405             if (b == 0) return (false, 0);
1406             return (true, a % b);
1407         }
1408     }
1409 
1410     /**
1411      * @dev Returns the addition of two unsigned integers, reverting on
1412      * overflow.
1413      *
1414      * Counterpart to Solidity's `+` operator.
1415      *
1416      * Requirements:
1417      *
1418      * - Addition cannot overflow.
1419      */
1420     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1421         return a + b;
1422     }
1423 
1424     /**
1425      * @dev Returns the subtraction of two unsigned integers, reverting on
1426      * overflow (when the result is negative).
1427      *
1428      * Counterpart to Solidity's `-` operator.
1429      *
1430      * Requirements:
1431      *
1432      * - Subtraction cannot overflow.
1433      */
1434     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1435         return a - b;
1436     }
1437 
1438     /**
1439      * @dev Returns the multiplication of two unsigned integers, reverting on
1440      * overflow.
1441      *
1442      * Counterpart to Solidity's `*` operator.
1443      *
1444      * Requirements:
1445      *
1446      * - Multiplication cannot overflow.
1447      */
1448     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1449         return a * b;
1450     }
1451 
1452     /**
1453      * @dev Returns the integer division of two unsigned integers, reverting on
1454      * division by zero. The result is rounded towards zero.
1455      *
1456      * Counterpart to Solidity's `/` operator.
1457      *
1458      * Requirements:
1459      *
1460      * - The divisor cannot be zero.
1461      */
1462     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1463         return a / b;
1464     }
1465 
1466     /**
1467      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1468      * reverting when dividing by zero.
1469      *
1470      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1471      * opcode (which leaves remaining gas untouched) while Solidity uses an
1472      * invalid opcode to revert (consuming all remaining gas).
1473      *
1474      * Requirements:
1475      *
1476      * - The divisor cannot be zero.
1477      */
1478     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1479         return a % b;
1480     }
1481 
1482     /**
1483      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1484      * overflow (when the result is negative).
1485      *
1486      * CAUTION: This function is deprecated because it requires allocating memory for the error
1487      * message unnecessarily. For custom revert reasons use {trySub}.
1488      *
1489      * Counterpart to Solidity's `-` operator.
1490      *
1491      * Requirements:
1492      *
1493      * - Subtraction cannot overflow.
1494      */
1495     function sub(
1496         uint256 a,
1497         uint256 b,
1498         string memory errorMessage
1499     ) internal pure returns (uint256) {
1500         unchecked {
1501             require(b <= a, errorMessage);
1502             return a - b;
1503         }
1504     }
1505 
1506     /**
1507      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1508      * division by zero. The result is rounded towards zero.
1509      *
1510      * Counterpart to Solidity's `/` operator. Note: this function uses a
1511      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1512      * uses an invalid opcode to revert (consuming all remaining gas).
1513      *
1514      * Requirements:
1515      *
1516      * - The divisor cannot be zero.
1517      */
1518     function div(
1519         uint256 a,
1520         uint256 b,
1521         string memory errorMessage
1522     ) internal pure returns (uint256) {
1523         unchecked {
1524             require(b > 0, errorMessage);
1525             return a / b;
1526         }
1527     }
1528 
1529     /**
1530      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1531      * reverting with custom message when dividing by zero.
1532      *
1533      * CAUTION: This function is deprecated because it requires allocating memory for the error
1534      * message unnecessarily. For custom revert reasons use {tryMod}.
1535      *
1536      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1537      * opcode (which leaves remaining gas untouched) while Solidity uses an
1538      * invalid opcode to revert (consuming all remaining gas).
1539      *
1540      * Requirements:
1541      *
1542      * - The divisor cannot be zero.
1543      */
1544     function mod(
1545         uint256 a,
1546         uint256 b,
1547         string memory errorMessage
1548     ) internal pure returns (uint256) {
1549         unchecked {
1550             require(b > 0, errorMessage);
1551             return a % b;
1552         }
1553     }
1554 }
1555 
1556 
1557 contract TenaciousTigers is ERC721Enumerable, Ownable {
1558     using SafeMath for uint256;
1559     
1560     mapping(address => uint256) private presaleLimit;
1561 
1562     string baseURI;
1563     bytes32 private merkleRoot;
1564     uint256 private reserved = 109;
1565     uint256 public mintCost = 0.06 ether; 
1566     uint256 private maxPublicSupply = 10000;
1567     uint256 public MAX_PURCHASEABLE = 20;
1568     uint256 public presaleStartTime = 1635350400 - 2 days; 
1569     uint256 public publicStartTime = presaleStartTime + 2 days;
1570     uint256 public reserveSent = 0;
1571     string public PROVENANCE = "";
1572 
1573 
1574     constructor(string memory baseTokenURI) ERC721("TenaciousTigers", "TT")  {
1575         setBaseURI(baseTokenURI);
1576     }
1577     
1578 
1579     function _baseURI() internal view virtual override returns (string memory) {
1580         return baseURI;
1581     }
1582 
1583     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1584         baseURI = _baseTokenURI;
1585     }
1586     
1587     function setMerkleRoot (bytes32 _merkleRoot) public onlyOwner {
1588         merkleRoot = _merkleRoot;
1589     }
1590     
1591     function setPresaleStartTime (uint256 _startTime) public onlyOwner {
1592         presaleStartTime = _startTime;
1593     }
1594 
1595     function setPublicStartTime (uint256 _startTime) public onlyOwner {
1596         publicStartTime = _startTime;
1597     }
1598     
1599     function setProvenanceHash(string memory _provenanceHash) public onlyOwner {
1600         PROVENANCE = _provenanceHash;
1601     }
1602 
1603 
1604     function claimPresale(
1605         bytes32[] memory proof,
1606         uint256 _amountToMint
1607     ) public payable {
1608 
1609         require( block.timestamp >= presaleStartTime,                               "Presale window is not opened" );
1610         require( block.timestamp < presaleStartTime + 1 days,                       "Presale window is closed" );
1611         require( totalSupply() + _amountToMint - reserveSent < maxPublicSupply,     "Exceeds supply" );
1612         require( msg.value >= mintCost.mul(_amountToMint),                          "Insufficient Ether" );
1613         require( presaleLimit[msg.sender] + _amountToMint <= MAX_PURCHASEABLE,                     "Maximum 20 Tigers per Address for presale");
1614 
1615         // Verify that address belongs in MerkleTree
1616         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1617         bool merkleProof = MerkleProof.verify(proof, merkleRoot, leaf);
1618         require(merkleProof, 'Account ineligible');
1619         
1620         // Verify that amount is 20 or less
1621         require(_amountToMint <= MAX_PURCHASEABLE, "Max 20");
1622         for(uint256 i; i < _amountToMint; i++) {
1623             uint256 supply = totalSupply();
1624             _safeMint( msg.sender, supply );
1625         }
1626         presaleLimit[msg.sender] = presaleLimit[msg.sender] + _amountToMint;
1627     }
1628     
1629     function claimPublicSale(
1630         uint256 _amountToMint
1631     ) public payable {
1632 
1633         require( block.timestamp >= publicStartTime,                                "Presale has not started yet" );
1634         require( totalSupply() + _amountToMint - reserveSent < maxPublicSupply,     "Exceeds supply" );
1635         require( msg.value >= mintCost.mul(_amountToMint),                          "Insufficient Ether" );
1636 
1637         // Verify that amount is 20 or less
1638         require(_amountToMint < 21, "Max 20");
1639         for(uint256 i; i < _amountToMint; i++){
1640             uint256 supply = totalSupply();
1641             _safeMint( msg.sender, supply );
1642         }
1643     }
1644     
1645     function reserves(address _to, uint256 _amountToMint) external onlyOwner() {
1646         
1647         require( _amountToMint <= reserved, "Exceeds reserved supply" );
1648         
1649         for(uint256 i = 0; i < _amountToMint; i++){
1650             _safeMint( _to, maxPublicSupply + reserveSent + i );
1651         }
1652         reserveSent += _amountToMint;
1653         reserved -= _amountToMint;
1654     }
1655 
1656     function withdrawal() public payable onlyOwner {
1657         address a1 = 0x27859BD4747aCaE8262931d99973D8AD5F331Cd0;
1658         address a2 = 0xE8F3FD6b60E0a25DC9Fe096a70428153B7a0dC08;
1659 
1660         uint256 bal1 = address(this).balance.mul(13125).div(100000);
1661         uint256 bal2 = address(this).balance.sub(bal1);
1662 
1663         require(payable(a1).send(bal1));
1664         require(payable(a2).send(bal2));
1665     }
1666 }