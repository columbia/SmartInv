1 pragma solidity 0.8.10;
2 
3 // SPDX-License-Identifier: MIT
4 
5 // @title: The Sad Cats
6 // @website: https://sadgirlsbar.io/sad-cats
7 // @twitter: https://twitter.com/sad_girls_bar
8 // @discord: https://discord.com/invite/aA467bQRDj
9 // @opensea: https://opensea.io/collection/thesadcats
10 //
11 //
12 //               :+++/-`                                        ``
13 //              -d- `.:o/.                                   .:++o+
14 //              d+/    `-o+.      -`                 `    `:oo/` -m
15 //             :M-:  `:.  -o+`   --                 `-  `/oo/.  ::d
16 //             /N.:   `:/`  :s:` /                  -` -s//.    +/m
17 //             /N.:     `+:  -+o/- `` `  `    `.:   : -h-/`     :/N`
18 //             :N`/     `:/- :``s--sdy+/sy++++hd/-. //+//.-     :-m-
19 //             `N:+`    `/o- .- /.+:oo+.:-.  `..-o+::..+:-:-    :.y+
20 //              yh./      ::  / --   -             /  / .oy-    ``+s
21 //              -N--/`   `-  `/` /   /            -. :` /--       +s
22 //               ys .o  //`  :.: +  :`            .   `/` `-    / +s
23 //               h+  s`..    `-+`-- :                 `        +- oo
24 //               ys  `         `- `                         -./+  d-
25 //               `ys       :-.`                   `..`       //  :h
26 //               .d/      /N/-/s:.            `-+:`+Nd.         .d.
27 //              /h/       -dy-:Nmo-         `:sNM/ oMm-         o/
28 //             +h.         `:::-.    `.`    ```:+o+s/.  ```..-..:s
29 //            /ms                 -``::: `         ``.--..```````s+`
30 //            omo....-.-..```     d+:`.::s.      `----.-:::::--..-y:`
31 //             +m-   ````.::/-``  .:hmdo/s`     .//::::--.....```-my
32 //            `.+o---------.```` `  `m/`    ` ` .  ....`     ``..:do
33 //            `  y` .-..-:-. ```   .ohhhs/`     ` --::::-.`      mm-
34 //               +o.`.--. ` `     od:  `:yd.  .``   .-   `----. `h-`
35 //           `... h:-. ---`      sm`      :m-       +:::::`   `.s:
36 //         ...  `-.y: -:`-  :`   h-        :o     `:     `-::.yh+
37 //        .`  `-`  `s+:      `-                 - +         `++:`
38 //                 `.`+o-                       . `        `++ `--`
39 //                     `+o-o:`                          `:/+.    `.
40 //                       ./ohdho/:--....``....-----::///:-`
41 //                          .--``..--::::::---.-....``
42 //
43 //
44 
45 // OpenZeppelin
46 
47 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
48 
49 
50 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
51 
52 
53 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
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
76 /**
77  * @dev Required interface of an ERC721 compliant contract.
78  */
79 interface IERC721 is IERC165 {
80     /**
81      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
84 
85     /**
86      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
87      */
88     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
89 
90     /**
91      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
92      */
93     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
94 
95     /**
96      * @dev Returns the number of tokens in ``owner``'s account.
97      */
98     function balanceOf(address owner) external view returns (uint256 balance);
99 
100     /**
101      * @dev Returns the owner of the `tokenId` token.
102      *
103      * Requirements:
104      *
105      * - `tokenId` must exist.
106      */
107     function ownerOf(uint256 tokenId) external view returns (address owner);
108 
109     /**
110      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
111      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must exist and be owned by `from`.
118      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
119      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
120      *
121      * Emits a {Transfer} event.
122      */
123     function safeTransferFrom(
124         address from,
125         address to,
126         uint256 tokenId
127     ) external;
128 
129     /**
130      * @dev Transfers `tokenId` token from `from` to `to`.
131      *
132      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
133      *
134      * Requirements:
135      *
136      * - `from` cannot be the zero address.
137      * - `to` cannot be the zero address.
138      * - `tokenId` token must be owned by `from`.
139      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address from,
145         address to,
146         uint256 tokenId
147     ) external;
148 
149     /**
150      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
151      * The approval is cleared when the token is transferred.
152      *
153      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
154      *
155      * Requirements:
156      *
157      * - The caller must own the token or be an approved operator.
158      * - `tokenId` must exist.
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address to, uint256 tokenId) external;
163 
164     /**
165      * @dev Returns the account approved for `tokenId` token.
166      *
167      * Requirements:
168      *
169      * - `tokenId` must exist.
170      */
171     function getApproved(uint256 tokenId) external view returns (address operator);
172 
173     /**
174      * @dev Approve or remove `operator` as an operator for the caller.
175      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
176      *
177      * Requirements:
178      *
179      * - The `operator` cannot be the caller.
180      *
181      * Emits an {ApprovalForAll} event.
182      */
183     function setApprovalForAll(address operator, bool _approved) external;
184 
185     /**
186      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
187      *
188      * See {setApprovalForAll}
189      */
190     function isApprovedForAll(address owner, address operator) external view returns (bool);
191 
192     /**
193      * @dev Safely transfers `tokenId` token from `from` to `to`.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must exist and be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
202      *
203      * Emits a {Transfer} event.
204      */
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId,
209         bytes calldata data
210     ) external;
211 }
212 
213 
214 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
215 
216 /**
217  * @title ERC721 token receiver interface
218  * @dev Interface for any contract that wants to support safeTransfers
219  * from ERC721 asset contracts.
220  */
221 interface IERC721Receiver {
222     /**
223      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
224      * by `operator` from `from`, this function is called.
225      *
226      * It must return its Solidity selector to confirm the token transfer.
227      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
228      *
229      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
230      */
231     function onERC721Received(
232         address operator,
233         address from,
234         uint256 tokenId,
235         bytes calldata data
236     ) external returns (bytes4);
237 }
238 
239 
240 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
241 
242 /**
243  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
244  * @dev See https://eips.ethereum.org/EIPS/eip-721
245  */
246 interface IERC721Metadata is IERC721 {
247     /**
248      * @dev Returns the token collection name.
249      */
250     function name() external view returns (string memory);
251 
252     /**
253      * @dev Returns the token collection symbol.
254      */
255     function symbol() external view returns (string memory);
256 
257     /**
258      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
259      */
260     function tokenURI(uint256 tokenId) external view returns (string memory);
261 }
262 
263 
264 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         assembly {
294             size := extcodesize(account)
295         }
296         return size > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 
480 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
481 
482 /**
483  * @dev Provides information about the current execution context, including the
484  * sender of the transaction and its data. While these are generally available
485  * via msg.sender and msg.data, they should not be accessed in such a direct
486  * manner, since when dealing with meta-transactions the account sending and
487  * paying for execution may not be the actual sender (as far as an application
488  * is concerned).
489  *
490  * This contract is only required for intermediate, library-like contracts.
491  */
492 abstract contract Context {
493     function _msgSender() internal view virtual returns (address) {
494         return msg.sender;
495     }
496 
497     function _msgData() internal view virtual returns (bytes calldata) {
498         return msg.data;
499     }
500 }
501 
502 
503 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
504 
505 /**
506  * @dev String operations.
507  */
508 library Strings {
509     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
513      */
514     function toString(uint256 value) internal pure returns (string memory) {
515         // Inspired by OraclizeAPI's implementation - MIT licence
516         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
517 
518         if (value == 0) {
519             return "0";
520         }
521         uint256 temp = value;
522         uint256 digits;
523         while (temp != 0) {
524             digits++;
525             temp /= 10;
526         }
527         bytes memory buffer = new bytes(digits);
528         while (value != 0) {
529             digits -= 1;
530             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
531             value /= 10;
532         }
533         return string(buffer);
534     }
535 
536     /**
537      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
538      */
539     function toHexString(uint256 value) internal pure returns (string memory) {
540         if (value == 0) {
541             return "0x00";
542         }
543         uint256 temp = value;
544         uint256 length = 0;
545         while (temp != 0) {
546             length++;
547             temp >>= 8;
548         }
549         return toHexString(value, length);
550     }
551 
552     /**
553      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
554      */
555     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
556         bytes memory buffer = new bytes(2 * length + 2);
557         buffer[0] = "0";
558         buffer[1] = "x";
559         for (uint256 i = 2 * length + 1; i > 1; --i) {
560             buffer[i] = _HEX_SYMBOLS[value & 0xf];
561             value >>= 4;
562         }
563         require(value == 0, "Strings: hex length insufficient");
564         return string(buffer);
565     }
566 }
567 
568 
569 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
570 
571 /**
572  * @dev Implementation of the {IERC165} interface.
573  *
574  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
575  * for the additional interface id that will be supported. For example:
576  *
577  * ```solidity
578  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
580  * }
581  * ```
582  *
583  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
584  */
585 abstract contract ERC165 is IERC165 {
586     /**
587      * @dev See {IERC165-supportsInterface}.
588      */
589     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
590         return interfaceId == type(IERC165).interfaceId;
591     }
592 }
593 
594 /**
595  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
596  * the Metadata extension, but not including the Enumerable extension, which is available separately as
597  * {ERC721Enumerable}.
598  */
599 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
600     using Address for address;
601     using Strings for uint256;
602 
603     // Token name
604     string private _name;
605 
606     // Token symbol
607     string private _symbol;
608 
609     // Mapping from token ID to owner address
610     mapping(uint256 => address) private _owners;
611 
612     // Mapping owner address to token count
613     mapping(address => uint256) private _balances;
614 
615     // Mapping from token ID to approved address
616     mapping(uint256 => address) private _tokenApprovals;
617 
618     // Mapping from owner to operator approvals
619     mapping(address => mapping(address => bool)) private _operatorApprovals;
620 
621     /**
622      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
623      */
624     constructor(string memory name_, string memory symbol_) {
625         _name = name_;
626         _symbol = symbol_;
627     }
628 
629     /**
630      * @dev See {IERC165-supportsInterface}.
631      */
632     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
633         return
634             interfaceId == type(IERC721).interfaceId ||
635             interfaceId == type(IERC721Metadata).interfaceId ||
636             super.supportsInterface(interfaceId);
637     }
638 
639     /**
640      * @dev See {IERC721-balanceOf}.
641      */
642     function balanceOf(address owner) public view virtual override returns (uint256) {
643         require(owner != address(0), "ERC721: balance query for the zero address");
644         return _balances[owner];
645     }
646 
647     /**
648      * @dev See {IERC721-ownerOf}.
649      */
650     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
651         address owner = _owners[tokenId];
652         require(owner != address(0), "ERC721: owner query for nonexistent token");
653         return owner;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-name}.
658      */
659     function name() public view virtual override returns (string memory) {
660         return _name;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-symbol}.
665      */
666     function symbol() public view virtual override returns (string memory) {
667         return _symbol;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-tokenURI}.
672      */
673     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
674         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
675 
676         string memory baseURI = _baseURI();
677         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
678     }
679 
680     /**
681      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
682      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
683      * by default, can be overriden in child contracts.
684      */
685     function _baseURI() internal view virtual returns (string memory) {
686         return "";
687     }
688 
689     /**
690      * @dev See {IERC721-approve}.
691      */
692     function approve(address to, uint256 tokenId) public virtual override {
693         address owner = ERC721.ownerOf(tokenId);
694         require(to != owner, "ERC721: approval to current owner");
695 
696         require(
697             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
698             "ERC721: approve caller is not owner nor approved for all"
699         );
700 
701         _approve(to, tokenId);
702     }
703 
704     /**
705      * @dev See {IERC721-getApproved}.
706      */
707     function getApproved(uint256 tokenId) public view virtual override returns (address) {
708         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
709 
710         return _tokenApprovals[tokenId];
711     }
712 
713     /**
714      * @dev See {IERC721-setApprovalForAll}.
715      */
716     function setApprovalForAll(address operator, bool approved) public virtual override {
717         _setApprovalForAll(_msgSender(), operator, approved);
718     }
719 
720     /**
721      * @dev See {IERC721-isApprovedForAll}.
722      */
723     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
724         return _operatorApprovals[owner][operator];
725     }
726 
727     /**
728      * @dev See {IERC721-transferFrom}.
729      */
730     function transferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) public virtual override {
735         //solhint-disable-next-line max-line-length
736         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
737 
738         _transfer(from, to, tokenId);
739     }
740 
741     /**
742      * @dev See {IERC721-safeTransferFrom}.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId
748     ) public virtual override {
749         safeTransferFrom(from, to, tokenId, "");
750     }
751 
752     /**
753      * @dev See {IERC721-safeTransferFrom}.
754      */
755     function safeTransferFrom(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes memory _data
760     ) public virtual override {
761         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
762         _safeTransfer(from, to, tokenId, _data);
763     }
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
767      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
768      *
769      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
770      *
771      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
772      * implement alternative mechanisms to perform token transfer, such as signature-based.
773      *
774      * Requirements:
775      *
776      * - `from` cannot be the zero address.
777      * - `to` cannot be the zero address.
778      * - `tokenId` token must exist and be owned by `from`.
779      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _safeTransfer(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes memory _data
788     ) internal virtual {
789         _transfer(from, to, tokenId);
790         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
791     }
792 
793     /**
794      * @dev Returns whether `tokenId` exists.
795      *
796      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
797      *
798      * Tokens start existing when they are minted (`_mint`),
799      * and stop existing when they are burned (`_burn`).
800      */
801     function _exists(uint256 tokenId) internal view virtual returns (bool) {
802         return _owners[tokenId] != address(0);
803     }
804 
805     /**
806      * @dev Returns whether `spender` is allowed to manage `tokenId`.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must exist.
811      */
812     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
813         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
814         address owner = ERC721.ownerOf(tokenId);
815         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
816     }
817 
818     /**
819      * @dev Safely mints `tokenId` and transfers it to `to`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must not exist.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _safeMint(address to, uint256 tokenId) internal virtual {
829         _safeMint(to, tokenId, "");
830     }
831 
832     /**
833      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
834      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
835      */
836     function _safeMint(
837         address to,
838         uint256 tokenId,
839         bytes memory _data
840     ) internal virtual {
841         _mint(to, tokenId);
842         require(
843             _checkOnERC721Received(address(0), to, tokenId, _data),
844             "ERC721: transfer to non ERC721Receiver implementer"
845         );
846     }
847 
848     /**
849      * @dev Mints `tokenId` and transfers it to `to`.
850      *
851      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
852      *
853      * Requirements:
854      *
855      * - `tokenId` must not exist.
856      * - `to` cannot be the zero address.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _mint(address to, uint256 tokenId) internal virtual {
861         require(to != address(0), "ERC721: mint to the zero address");
862         require(!_exists(tokenId), "ERC721: token already minted");
863 
864         _beforeTokenTransfer(address(0), to, tokenId);
865 
866         _balances[to] += 1;
867         _owners[tokenId] = to;
868 
869         emit Transfer(address(0), to, tokenId);
870     }
871 
872     /**
873      * @dev Destroys `tokenId`.
874      * The approval is cleared when the token is burned.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _burn(uint256 tokenId) internal virtual {
883         address owner = ERC721.ownerOf(tokenId);
884 
885         _beforeTokenTransfer(owner, address(0), tokenId);
886 
887         // Clear approvals
888         _approve(address(0), tokenId);
889 
890         _balances[owner] -= 1;
891         delete _owners[tokenId];
892 
893         emit Transfer(owner, address(0), tokenId);
894     }
895 
896     /**
897      * @dev Transfers `tokenId` from `from` to `to`.
898      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
899      *
900      * Requirements:
901      *
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must be owned by `from`.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _transfer(
908         address from,
909         address to,
910         uint256 tokenId
911     ) internal virtual {
912         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
913         require(to != address(0), "ERC721: transfer to the zero address");
914 
915         _beforeTokenTransfer(from, to, tokenId);
916 
917         // Clear approvals from the previous owner
918         _approve(address(0), tokenId);
919 
920         _balances[from] -= 1;
921         _balances[to] += 1;
922         _owners[tokenId] = to;
923 
924         emit Transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev Approve `to` to operate on `tokenId`
929      *
930      * Emits a {Approval} event.
931      */
932     function _approve(address to, uint256 tokenId) internal virtual {
933         _tokenApprovals[tokenId] = to;
934         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
935     }
936 
937     /**
938      * @dev Approve `operator` to operate on all of `owner` tokens
939      *
940      * Emits a {ApprovalForAll} event.
941      */
942     function _setApprovalForAll(
943         address owner,
944         address operator,
945         bool approved
946     ) internal virtual {
947         require(owner != operator, "ERC721: approve to caller");
948         _operatorApprovals[owner][operator] = approved;
949         emit ApprovalForAll(owner, operator, approved);
950     }
951 
952     /**
953      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
954      * The call is not executed if the target address is not a contract.
955      *
956      * @param from address representing the previous owner of the given token ID
957      * @param to target address that will receive the tokens
958      * @param tokenId uint256 ID of the token to be transferred
959      * @param _data bytes optional data to send along with the call
960      * @return bool whether the call correctly returned the expected magic value
961      */
962     function _checkOnERC721Received(
963         address from,
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) private returns (bool) {
968         if (to.isContract()) {
969             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
970                 return retval == IERC721Receiver.onERC721Received.selector;
971             } catch (bytes memory reason) {
972                 if (reason.length == 0) {
973                     revert("ERC721: transfer to non ERC721Receiver implementer");
974                 } else {
975                     assembly {
976                         revert(add(32, reason), mload(reason))
977                     }
978                 }
979             }
980         } else {
981             return true;
982         }
983     }
984 
985     /**
986      * @dev Hook that is called before any token transfer. This includes minting
987      * and burning.
988      *
989      * Calling conditions:
990      *
991      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
992      * transferred to `to`.
993      * - When `from` is zero, `tokenId` will be minted for `to`.
994      * - When `to` is zero, ``from``'s `tokenId` will be burned.
995      * - `from` and `to` are never both zero.
996      *
997      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
998      */
999     function _beforeTokenTransfer(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) internal virtual {}
1004 }
1005 
1006 
1007 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1011 
1012 /**
1013  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1014  * @dev See https://eips.ethereum.org/EIPS/eip-721
1015  */
1016 interface IERC721Enumerable is IERC721 {
1017     /**
1018      * @dev Returns the total amount of tokens stored by the contract.
1019      */
1020     function totalSupply() external view returns (uint256);
1021 
1022     /**
1023      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1024      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1025      */
1026     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1027 
1028     /**
1029      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1030      * Use along with {totalSupply} to enumerate all tokens.
1031      */
1032     function tokenByIndex(uint256 index) external view returns (uint256);
1033 }
1034 
1035 /**
1036  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1037  * enumerability of all the token ids in the contract as well as all token ids owned by each
1038  * account.
1039  */
1040 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1041     // Mapping from owner to list of owned token IDs
1042     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1043 
1044     // Mapping from token ID to index of the owner tokens list
1045     mapping(uint256 => uint256) private _ownedTokensIndex;
1046 
1047     // Array with all token ids, used for enumeration
1048     uint256[] private _allTokens;
1049 
1050     // Mapping from token id to position in the allTokens array
1051     mapping(uint256 => uint256) private _allTokensIndex;
1052 
1053     /**
1054      * @dev See {IERC165-supportsInterface}.
1055      */
1056     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1057         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1062      */
1063     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1064         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1065         return _ownedTokens[owner][index];
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-totalSupply}.
1070      */
1071     function totalSupply() public view virtual override returns (uint256) {
1072         return _allTokens.length;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Enumerable-tokenByIndex}.
1077      */
1078     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1079         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1080         return _allTokens[index];
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before any token transfer. This includes minting
1085      * and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` will be minted for `to`.
1092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1093      * - `from` cannot be the zero address.
1094      * - `to` cannot be the zero address.
1095      *
1096      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1097      */
1098     function _beforeTokenTransfer(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) internal virtual override {
1103         super._beforeTokenTransfer(from, to, tokenId);
1104 
1105         if (from == address(0)) {
1106             _addTokenToAllTokensEnumeration(tokenId);
1107         } else if (from != to) {
1108             _removeTokenFromOwnerEnumeration(from, tokenId);
1109         }
1110         if (to == address(0)) {
1111             _removeTokenFromAllTokensEnumeration(tokenId);
1112         } else if (to != from) {
1113             _addTokenToOwnerEnumeration(to, tokenId);
1114         }
1115     }
1116 
1117     /**
1118      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1119      * @param to address representing the new owner of the given token ID
1120      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1121      */
1122     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1123         uint256 length = ERC721.balanceOf(to);
1124         _ownedTokens[to][length] = tokenId;
1125         _ownedTokensIndex[tokenId] = length;
1126     }
1127 
1128     /**
1129      * @dev Private function to add a token to this extension's token tracking data structures.
1130      * @param tokenId uint256 ID of the token to be added to the tokens list
1131      */
1132     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1133         _allTokensIndex[tokenId] = _allTokens.length;
1134         _allTokens.push(tokenId);
1135     }
1136 
1137     /**
1138      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1139      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1140      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1141      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1142      * @param from address representing the previous owner of the given token ID
1143      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1144      */
1145     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1146         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1147         // then delete the last slot (swap and pop).
1148 
1149         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1150         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1151 
1152         // When the token to delete is the last token, the swap operation is unnecessary
1153         if (tokenIndex != lastTokenIndex) {
1154             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1155 
1156             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1157             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1158         }
1159 
1160         // This also deletes the contents at the last position of the array
1161         delete _ownedTokensIndex[tokenId];
1162         delete _ownedTokens[from][lastTokenIndex];
1163     }
1164 
1165     /**
1166      * @dev Private function to remove a token from this extension's token tracking data structures.
1167      * This has O(1) time complexity, but alters the order of the _allTokens array.
1168      * @param tokenId uint256 ID of the token to be removed from the tokens list
1169      */
1170     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1171         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1172         // then delete the last slot (swap and pop).
1173 
1174         uint256 lastTokenIndex = _allTokens.length - 1;
1175         uint256 tokenIndex = _allTokensIndex[tokenId];
1176 
1177         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1178         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1179         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1180         uint256 lastTokenId = _allTokens[lastTokenIndex];
1181 
1182         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1183         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1184 
1185         // This also deletes the contents at the last position of the array
1186         delete _allTokensIndex[tokenId];
1187         _allTokens.pop();
1188     }
1189 }
1190 
1191 
1192 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1193 
1194 /**
1195  * @dev Contract module which provides a basic access control mechanism, where
1196  * there is an account (an owner) that can be granted exclusive access to
1197  * specific functions.
1198  *
1199  * By default, the owner account will be the one that deploys the contract. This
1200  * can later be changed with {transferOwnership}.
1201  *
1202  * This module is used through inheritance. It will make available the modifier
1203  * `onlyOwner`, which can be applied to your functions to restrict their use to
1204  * the owner.
1205  */
1206 abstract contract Ownable is Context {
1207     address private _owner;
1208 
1209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1210 
1211     /**
1212      * @dev Initializes the contract setting the deployer as the initial owner.
1213      */
1214     constructor() {
1215         _transferOwnership(_msgSender());
1216     }
1217 
1218     /**
1219      * @dev Returns the address of the current owner.
1220      */
1221     function owner() public view virtual returns (address) {
1222         return _owner;
1223     }
1224 
1225     /**
1226      * @dev Throws if called by any account other than the owner.
1227      */
1228     modifier onlyOwner() {
1229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1230         _;
1231     }
1232 
1233     /**
1234      * @dev Leaves the contract without owner. It will not be possible to call
1235      * `onlyOwner` functions anymore. Can only be called by the current owner.
1236      *
1237      * NOTE: Renouncing ownership will leave the contract without an owner,
1238      * thereby removing any functionality that is only available to the owner.
1239      */
1240     function renounceOwnership() public virtual onlyOwner {
1241         _transferOwnership(address(0));
1242     }
1243 
1244     /**
1245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1246      * Can only be called by the current owner.
1247      */
1248     function transferOwnership(address newOwner) public virtual onlyOwner {
1249         require(newOwner != address(0), "Ownable: new owner is the zero address");
1250         _transferOwnership(newOwner);
1251     }
1252 
1253     /**
1254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1255      * Internal function without access restriction.
1256      */
1257     function _transferOwnership(address newOwner) internal virtual {
1258         address oldOwner = _owner;
1259         _owner = newOwner;
1260         emit OwnershipTransferred(oldOwner, newOwner);
1261     }
1262 }
1263 
1264 
1265 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
1266 
1267 /**
1268  * @dev Contract module that helps prevent reentrant calls to a function.
1269  *
1270  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1271  * available, which can be applied to functions to make sure there are no nested
1272  * (reentrant) calls to them.
1273  *
1274  * Note that because there is a single `nonReentrant` guard, functions marked as
1275  * `nonReentrant` may not call one another. This can be worked around by making
1276  * those functions `private`, and then adding `external` `nonReentrant` entry
1277  * points to them.
1278  *
1279  * TIP: If you would like to learn more about reentrancy and alternative ways
1280  * to protect against it, check out our blog post
1281  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1282  */
1283 abstract contract ReentrancyGuard {
1284     // Booleans are more expensive than uint256 or any type that takes up a full
1285     // word because each write operation emits an extra SLOAD to first read the
1286     // slot's contents, replace the bits taken up by the boolean, and then write
1287     // back. This is the compiler's defense against contract upgrades and
1288     // pointer aliasing, and it cannot be disabled.
1289 
1290     // The values being non-zero value makes deployment a bit more expensive,
1291     // but in exchange the refund on every call to nonReentrant will be lower in
1292     // amount. Since refunds are capped to a percentage of the total
1293     // transaction's gas, it is best to keep them low in cases like this one, to
1294     // increase the likelihood of the full refund coming into effect.
1295     uint256 private constant _NOT_ENTERED = 1;
1296     uint256 private constant _ENTERED = 2;
1297 
1298     uint256 private _status;
1299 
1300     constructor() {
1301         _status = _NOT_ENTERED;
1302     }
1303 
1304     /**
1305      * @dev Prevents a contract from calling itself, directly or indirectly.
1306      * Calling a `nonReentrant` function from another `nonReentrant`
1307      * function is not supported. It is possible to prevent this from happening
1308      * by making the `nonReentrant` function external, and making it call a
1309      * `private` function that does the actual work.
1310      */
1311     modifier nonReentrant() {
1312         // On the first call to nonReentrant, _notEntered will be true
1313         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1314 
1315         // Any calls to nonReentrant after this point will fail
1316         _status = _ENTERED;
1317 
1318         _;
1319 
1320         // By storing the original value once again, a refund is triggered (see
1321         // https://eips.ethereum.org/EIPS/eip-2200)
1322         _status = _NOT_ENTERED;
1323     }
1324 }
1325 
1326 
1327 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
1328 
1329 // CAUTION
1330 // This version of SafeMath should only be used with Solidity 0.8 or later,
1331 // because it relies on the compiler's built in overflow checks.
1332 
1333 /**
1334  * @dev Wrappers over Solidity's arithmetic operations.
1335  *
1336  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1337  * now has built in overflow checking.
1338  */
1339 library SafeMath {
1340     /**
1341      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1342      *
1343      * _Available since v3.4._
1344      */
1345     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1346         unchecked {
1347             uint256 c = a + b;
1348             if (c < a) return (false, 0);
1349             return (true, c);
1350         }
1351     }
1352 
1353     /**
1354      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1355      *
1356      * _Available since v3.4._
1357      */
1358     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1359         unchecked {
1360             if (b > a) return (false, 0);
1361             return (true, a - b);
1362         }
1363     }
1364 
1365     /**
1366      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1367      *
1368      * _Available since v3.4._
1369      */
1370     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1371         unchecked {
1372             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1373             // benefit is lost if 'b' is also tested.
1374             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1375             if (a == 0) return (true, 0);
1376             uint256 c = a * b;
1377             if (c / a != b) return (false, 0);
1378             return (true, c);
1379         }
1380     }
1381 
1382     /**
1383      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1384      *
1385      * _Available since v3.4._
1386      */
1387     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1388         unchecked {
1389             if (b == 0) return (false, 0);
1390             return (true, a / b);
1391         }
1392     }
1393 
1394     /**
1395      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1396      *
1397      * _Available since v3.4._
1398      */
1399     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1400         unchecked {
1401             if (b == 0) return (false, 0);
1402             return (true, a % b);
1403         }
1404     }
1405 
1406     /**
1407      * @dev Returns the addition of two unsigned integers, reverting on
1408      * overflow.
1409      *
1410      * Counterpart to Solidity's `+` operator.
1411      *
1412      * Requirements:
1413      *
1414      * - Addition cannot overflow.
1415      */
1416     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1417         return a + b;
1418     }
1419 
1420     /**
1421      * @dev Returns the subtraction of two unsigned integers, reverting on
1422      * overflow (when the result is negative).
1423      *
1424      * Counterpart to Solidity's `-` operator.
1425      *
1426      * Requirements:
1427      *
1428      * - Subtraction cannot overflow.
1429      */
1430     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1431         return a - b;
1432     }
1433 
1434     /**
1435      * @dev Returns the multiplication of two unsigned integers, reverting on
1436      * overflow.
1437      *
1438      * Counterpart to Solidity's `*` operator.
1439      *
1440      * Requirements:
1441      *
1442      * - Multiplication cannot overflow.
1443      */
1444     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1445         return a * b;
1446     }
1447 
1448     /**
1449      * @dev Returns the integer division of two unsigned integers, reverting on
1450      * division by zero. The result is rounded towards zero.
1451      *
1452      * Counterpart to Solidity's `/` operator.
1453      *
1454      * Requirements:
1455      *
1456      * - The divisor cannot be zero.
1457      */
1458     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1459         return a / b;
1460     }
1461 
1462     /**
1463      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1464      * reverting when dividing by zero.
1465      *
1466      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1467      * opcode (which leaves remaining gas untouched) while Solidity uses an
1468      * invalid opcode to revert (consuming all remaining gas).
1469      *
1470      * Requirements:
1471      *
1472      * - The divisor cannot be zero.
1473      */
1474     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1475         return a % b;
1476     }
1477 
1478     /**
1479      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1480      * overflow (when the result is negative).
1481      *
1482      * CAUTION: This function is deprecated because it requires allocating memory for the error
1483      * message unnecessarily. For custom revert reasons use {trySub}.
1484      *
1485      * Counterpart to Solidity's `-` operator.
1486      *
1487      * Requirements:
1488      *
1489      * - Subtraction cannot overflow.
1490      */
1491     function sub(
1492         uint256 a,
1493         uint256 b,
1494         string memory errorMessage
1495     ) internal pure returns (uint256) {
1496         unchecked {
1497             require(b <= a, errorMessage);
1498             return a - b;
1499         }
1500     }
1501 
1502     /**
1503      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1504      * division by zero. The result is rounded towards zero.
1505      *
1506      * Counterpart to Solidity's `/` operator. Note: this function uses a
1507      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1508      * uses an invalid opcode to revert (consuming all remaining gas).
1509      *
1510      * Requirements:
1511      *
1512      * - The divisor cannot be zero.
1513      */
1514     function div(
1515         uint256 a,
1516         uint256 b,
1517         string memory errorMessage
1518     ) internal pure returns (uint256) {
1519         unchecked {
1520             require(b > 0, errorMessage);
1521             return a / b;
1522         }
1523     }
1524 
1525     /**
1526      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1527      * reverting with custom message when dividing by zero.
1528      *
1529      * CAUTION: This function is deprecated because it requires allocating memory for the error
1530      * message unnecessarily. For custom revert reasons use {tryMod}.
1531      *
1532      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1533      * opcode (which leaves remaining gas untouched) while Solidity uses an
1534      * invalid opcode to revert (consuming all remaining gas).
1535      *
1536      * Requirements:
1537      *
1538      * - The divisor cannot be zero.
1539      */
1540     function mod(
1541         uint256 a,
1542         uint256 b,
1543         string memory errorMessage
1544     ) internal pure returns (uint256) {
1545         unchecked {
1546             require(b > 0, errorMessage);
1547             return a % b;
1548         }
1549     }
1550 }
1551 
1552 contract SadGirlsBarClient {
1553   function balanceOf(address owner) public view virtual returns (uint256) {}
1554 }
1555 
1556 
1557 
1558 
1559 
1560 
1561 
1562 
1563 
1564 
1565 
1566 
1567 
1568 
1569 
1570 
1571 
1572 
1573 
1574 contract TheSadCats is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {
1575   using SafeMath for uint8;
1576   using SafeMath for uint256;
1577   using Strings for string;
1578 
1579   uint public contractState = 0;
1580   // 0 - closed
1581   // 1 - opened only for holders
1582   // 2 - opened for all
1583 
1584   string public baseTokenURI;
1585   address public sgbAddress;
1586   uint256 public _maxBatchSize = 20;
1587   uint public catPrice = 0.05 ether;
1588   uint public giveawayLeft = 100;
1589   uint public targetSupply = 7000;
1590   uint public lastTokenId = 0;
1591 
1592   /*
1593    * Set up the basics
1594    *
1595    * @dev It will NOT be ready to start sale immediately upon deploy
1596    */
1597   constructor(string memory metadataLocation, address sgbContractAddress) ERC721("TheSadCats", "TheSadCats") {
1598     sgbAddress = sgbContractAddress;
1599     baseTokenURI = metadataLocation;
1600   }
1601 
1602   function _setAddr(address addr) public onlyOwner {
1603     sgbAddress = addr;
1604   }
1605   /*
1606    * Get the tokens owned by _owner
1607    */
1608   function tokensOfOwner(address _owner) public view returns(uint256[] memory ) {
1609     uint256 tokenCount = balanceOf(_owner);
1610     if (tokenCount == 0) {
1611       // Return an empty array
1612       return new uint256[](0);
1613     } else {
1614       uint256[] memory result = new uint256[](tokenCount);
1615       uint256 index;
1616       for (index = 0; index < tokenCount; index++) {
1617         result[index] = tokenOfOwnerByIndex(_owner, index);
1618       }
1619       return result;
1620     }
1621   }
1622 
1623 
1624   function isSgbHolder(address _owner) public view returns (bool) {
1625     SadGirlsBarClient sgb = SadGirlsBarClient(sgbAddress);
1626     return sgb.balanceOf(_owner) > 0;
1627   }
1628 
1629 
1630   /* Minting started here... */
1631   function mint(uint256 numTokens, address to) external payable nonReentrant {
1632     // Check we're is online...
1633     require(contractState > 0, "Sales not started");
1634 
1635     if (contractState == 1) {
1636       require(isSgbHolder(_msgSender()), "Sales are open to holders only");
1637     }
1638 
1639     // ...and not exceed limit
1640     require(totalSupply() < targetSupply, "We've got all");
1641     // ...and not try to get more tokens than allowed...
1642     require(numTokens > 0 && numTokens <= _maxBatchSize, "Too much");
1643     // ...and not try to get more tokens than TOTALLY allowed...
1644     require(totalSupply().add(numTokens) <= targetSupply.sub(giveawayLeft), "Can't get more than 10000 NFTs");
1645     // ...and we have enough money for that.
1646     require(msg.value >= catPrice.mul(numTokens),
1647       "Not enough ETH for transaction");
1648 
1649     // mint all of these tokens
1650     uint _lastTokenId = lastTokenId;
1651     address mintTo = address(0) == to ? _msgSender() : to;
1652 
1653     for (uint i = 0; i < numTokens; i++) {
1654       _lastTokenId++;
1655       _safeMint(mintTo, _lastTokenId);
1656     }
1657     lastTokenId = _lastTokenId;
1658   }
1659 
1660 
1661   /* Allow to mint tokens for giveaways at any time (but limited count) */
1662   function mintGiveaway(uint256 numTokens, address to) public onlyOwner {
1663     require(totalSupply().add(numTokens) <= targetSupply.sub(giveawayLeft), "Only 100 tokens max");
1664     uint _lastTokenId = lastTokenId;
1665     for (uint i = 0; i < numTokens; i++) {
1666       _lastTokenId++;
1667       _safeMint(to, _lastTokenId);
1668     }
1669     giveawayLeft = giveawayLeft.sub(numTokens);
1670     lastTokenId = _lastTokenId; 
1671   }
1672 
1673 
1674   function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1675   internal
1676   override(ERC721, ERC721Enumerable)
1677   {
1678     super._beforeTokenTransfer(from, to, tokenId);
1679   }
1680 
1681   function supportsInterface(bytes4 interfaceId)
1682   public
1683   view
1684   override(ERC721, ERC721Enumerable)
1685   returns (bool)
1686   {
1687     return super.supportsInterface(interfaceId);
1688   }
1689 
1690   function _setBaseURI(string memory baseURI) internal virtual {
1691     baseTokenURI = baseURI;
1692   }
1693 
1694   function _baseURI() internal view override returns (string memory) {
1695     return baseTokenURI;
1696   }
1697 
1698   function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1699     string memory _tokenURI = super.tokenURI(tokenId);
1700     return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1701   }
1702 
1703   // Administrative zone
1704   function setBaseURI(string memory baseURI) public onlyOwner {
1705     _setBaseURI(baseURI);
1706   }
1707 
1708   function setMaxBatchSize(uint256 maxBatchSize) public onlyOwner {
1709     _maxBatchSize = maxBatchSize;
1710   }
1711 
1712   function setPrice(uint256 newPrice) public onlyOwner {
1713     require(newPrice > 0);
1714     catPrice = newPrice;
1715   }
1716 
1717   function setContractState(uint256 newContractState) public onlyOwner {
1718     require(newContractState >= 0 && newContractState <=2);
1719     contractState = newContractState;
1720   }
1721   
1722   function reduceSupply(uint256 newSupply) public onlyOwner {
1723     require(newSupply < targetSupply);
1724     require(newSupply > lastTokenId.add(giveawayLeft));
1725     targetSupply = newSupply;
1726   }
1727 
1728   function withdrawAll() public payable onlyOwner {
1729     require(payable(msg.sender).send(address(this).balance));
1730   }
1731 
1732 
1733 }