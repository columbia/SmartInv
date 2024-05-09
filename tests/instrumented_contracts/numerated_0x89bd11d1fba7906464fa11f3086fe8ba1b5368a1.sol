1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-15
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 pragma solidity ^0.8.11;
7 
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) 
56         internal 
57         pure 
58         returns (string memory) 
59     {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 abstract contract Context {
73     function _msgSender() internal view virtual returns (address) {
74         return msg.sender;
75     }
76 
77     function _msgData() internal view virtual returns (bytes calldata) {
78         return msg.data;
79     }
80 }
81 
82 abstract contract Pausable is Context {
83     /**
84      * @dev Emitted when the pause is triggered by `account`.
85      */
86     event Paused(address account);
87 
88     /**
89      * @dev Emitted when the pause is lifted by `account`.
90      */
91     event Unpaused(address account);
92 
93     bool private _paused;
94 
95     /**
96      * @dev Initializes the contract in unpaused state.
97      */
98     constructor() {
99         _paused = false;
100     }
101 
102     /**
103      * @dev Returns true if the contract is paused, and false otherwise.
104      */
105     function paused() public view virtual returns (bool) {
106         return _paused;
107     }
108 
109     /**
110      * @dev Modifier to make a function callable only when the contract is not paused.
111      *
112      * Requirements:
113      *
114      * - The contract must not be paused.
115      */
116     modifier whenNotPaused() {
117         require(!paused(), "Pausable: paused");
118         _;
119     }
120 
121     /**
122      * @dev Modifier to make a function callable only when the contract is paused.
123      *
124      * Requirements:
125      *
126      * - The contract must be paused.
127      */
128     modifier whenPaused() {
129         require(paused(), "Pausable: not paused");
130         _;
131     }
132 
133     /**
134      * @dev Triggers stopped state.
135      *
136      * Requirements:
137      *
138      * - The contract must not be paused.
139      */
140     function _pause() internal virtual whenNotPaused {
141         _paused = true;
142         emit Paused(_msgSender());
143     }
144 
145     /**
146      * @dev Returns to normal state.
147      *
148      * Requirements:
149      *
150      * - The contract must be paused.
151      */
152     function _unpause() internal virtual whenPaused {
153         _paused = false;
154         emit Unpaused(_msgSender());
155     }
156 }
157 
158 interface IERC165 {
159     /**
160      * @dev Returns true if this contract implements the interface defined by
161      * `interfaceId`. See the corresponding
162      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
163      * to learn more about how these ids are created.
164      *
165      * This function call must use less than 30 000 gas.
166      */
167     function supportsInterface(bytes4 interfaceId) external view returns (bool);
168 }
169 
170 interface IERC721 is IERC165 {
171     /**
172      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
173      */
174     event Transfer(
175         address indexed from, 
176         address indexed to, 
177         uint256 indexed tokenId
178     );
179 
180     /**
181      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
182      */
183     event Approval(
184         address indexed owner, 
185         address indexed approved, 
186         uint256 indexed tokenId
187     );
188 
189     /**
190      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
191      */
192     event ApprovalForAll(
193         address indexed owner, 
194         address indexed operator, 
195         bool approved
196     );
197 
198     /**
199      * @dev Returns the number of tokens in ``owner``'s account.
200      */
201     function balanceOf(address owner) external view returns (uint256 balance);
202 
203     /**
204      * @dev Returns the owner of the `tokenId` token.
205      *
206      * Requirements:
207      *
208      * - `tokenId` must exist.
209      */
210     function ownerOf(uint256 tokenId) external view returns (address owner);
211 
212     /**
213      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
214      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
215      *
216      * Requirements:
217      *
218      * - `from` cannot be the zero address.
219      * - `to` cannot be the zero address.
220      * - `tokenId` token must exist and be owned by `from`.
221      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
222      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
223      *
224      * Emits a {Transfer} event.
225      */
226     function safeTransferFrom(
227         address from,
228         address to,
229         uint256 tokenId
230     ) external;
231 
232     /**
233      * @dev Transfers `tokenId` token from `from` to `to`.
234      *
235      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must be owned by `from`.
242      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
243      *
244      * Emits a {Transfer} event.
245      */
246     function transferFrom(
247         address from,
248         address to,
249         uint256 tokenId
250     ) external;
251 
252     /**
253      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
254      * The approval is cleared when the token is transferred.
255      *
256      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
257      *
258      * Requirements:
259      *
260      * - The caller must own the token or be an approved operator.
261      * - `tokenId` must exist.
262      *
263      * Emits an {Approval} event.
264      */
265     function approve(address to, uint256 tokenId) external;
266 
267     /**
268      * @dev Returns the account approved for `tokenId` token.
269      *
270      * Requirements:
271      *
272      * - `tokenId` must exist.
273      */
274     function getApproved(uint256 tokenId) 
275         external 
276         view 
277         returns (address operator);
278 
279     /**
280      * @dev Approve or remove `operator` as an operator for the caller.
281      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
282      *
283      * Requirements:
284      *
285      * - The `operator` cannot be the caller.
286      *
287      * Emits an {ApprovalForAll} event.
288      */
289     function setApprovalForAll(address operator, bool _approved) external;
290 
291     /**
292      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
293      *
294      * See {setApprovalForAll}
295      */
296     function isApprovedForAll(address owner, address operator) 
297         external 
298         view 
299         returns (bool);
300 
301     /**
302      * @dev Safely transfers `tokenId` token from `from` to `to`.
303      *
304      * Requirements:
305      *
306      * - `from` cannot be the zero address.
307      * - `to` cannot be the zero address.
308      * - `tokenId` token must exist and be owned by `from`.
309      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
310      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
311      *
312      * Emits a {Transfer} event.
313      */
314     function safeTransferFrom(
315         address from,
316         address to,
317         uint256 tokenId,
318         bytes calldata data
319     ) external;
320 }
321 
322 interface IERC721Receiver {
323     /**
324      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
325      * by `operator` from `from`, this function is called.
326      *
327      * It must return its Solidity selector to confirm the token transfer.
328      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
329      *
330      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
331      */
332     function onERC721Received(
333         address operator,
334         address from,
335         uint256 tokenId,
336         bytes calldata data
337     ) external returns (bytes4);
338 }
339 
340 interface IERC721Metadata is IERC721 {
341     /**
342      * @dev Returns the token collection name.
343      */
344     function name() external view returns (string memory);
345 
346     /**
347      * @dev Returns the token collection symbol.
348      */
349     function symbol() external view returns (string memory);
350 
351     /**
352      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
353      */
354     function tokenURI(uint256 tokenId) external view returns (string memory);
355 }
356 
357 library Address {
358     /**
359      * @dev Returns true if `account` is a contract.
360      *
361      * [IMPORTANT]
362      * ====
363      * It is unsafe to assume that an address for which this function returns
364      * false is an externally-owned account (EOA) and not a contract.
365      *
366      * Among others, `isContract` will return false for the following
367      * types of addresses:
368      *
369      *  - an externally-owned account
370      *  - a contract in construction
371      *  - an address where a contract will be created
372      *  - an address where a contract lived, but was destroyed
373      * ====
374      */
375     function isContract(address account) internal view returns (bool) {
376         // This method relies on extcodesize, which returns 0 for contracts in
377         // construction, since the code is only stored at the end of the
378         // constructor execution.
379 
380         uint256 size;
381         assembly {
382             size := extcodesize(account)
383         }
384         return size > 0;
385     }
386 
387     /**
388      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
389      * `recipient`, forwarding all available gas and reverting on errors.
390      *
391      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
392      * of certain opcodes, possibly making contracts go over the 2300 gas limit
393      * imposed by `transfer`, making them unable to receive funds via
394      * `transfer`. {sendValue} removes this limitation.
395      *
396      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
397      *
398      * IMPORTANT: because control is transferred to `recipient`, care must be
399      * taken to not create reentrancy vulnerabilities. Consider using
400      * {ReentrancyGuard} or the
401      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
402      */
403     function sendValue(address payable recipient, uint256 amount) internal {
404         require(
405             address(this).balance >= amount, 
406             "Address: insufficient balance"
407         );
408 
409         (bool success, ) = recipient.call{value: amount}("");
410         require(
411             success, 
412             "Address: unable to send value, recipient may have reverted"
413         );
414     }
415 
416     /**
417      * @dev Performs a Solidity function call using a low level `call`. A
418      * plain `call` is an unsafe replacement for a function call: use this
419      * function instead.
420      *
421      * If `target` reverts with a revert reason, it is bubbled up by this
422      * function (like regular Solidity function calls).
423      *
424      * Returns the raw returned data. To convert to the expected return value,
425      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
426      *
427      * Requirements:
428      *
429      * - `target` must be a contract.
430      * - calling `target` with `data` must not revert.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(address target, bytes memory data) 
435         internal 
436         returns (bytes memory) 
437     {
438         return functionCall(target, data, "Address: low-level call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
443      * `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, 0, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but also transferring `value` wei to `target`.
458      *
459      * Requirements:
460      *
461      * - the calling contract must have an ETH balance of at least `value`.
462      * - the called Solidity function must be `payable`.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value
470     ) internal returns (bytes memory) {
471         return 
472             functionCallWithValue(
473                 target, 
474                 data, 
475                 value, 
476                 "Address: low-level call with value failed"
477             );
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
482      * with `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(
487         address target,
488         bytes memory data,
489         uint256 value,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(
493             address(this).balance >= value, 
494             "Address: insufficient balance for call"
495         );
496         require(isContract(target), "Address: call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.call{value: value}(
499             data
500         );
501         return verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but performing a static call.
507      *
508      * _Available since v3.3._
509      */
510     function functionStaticCall(address target, bytes memory data) 
511         internal 
512         view 
513         returns (bytes memory) 
514     {
515         return 
516             functionStaticCall(
517                 target, 
518                 data, 
519                 "Address: low-level static call failed"
520             );
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal view returns (bytes memory) {
534         require(isContract(target), "Address: static call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.staticcall(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a delegate call.
543      *
544      * _Available since v3.4._
545      */
546     function functionDelegateCall(address target, bytes memory data) 
547         internal 
548         returns (bytes memory) 
549     {
550         return 
551             functionDelegateCall(
552                 target, 
553                 data, 
554                 "Address: low-level delegate call failed"
555             );
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a delegate call.
561      *
562      * _Available since v3.4._
563      */
564     function functionDelegateCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         require(isContract(target), "Address: delegate call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.delegatecall(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
577      * revert reason using the provided one.
578      *
579      * _Available since v4.3._
580      */
581     function verifyCallResult(
582         bool success,
583         bytes memory returndata,
584         string memory errorMessage
585     ) internal pure returns (bytes memory) {
586         if (success) {
587             return returndata;
588         } else {
589             // Look for revert reason and bubble it up if present
590             if (returndata.length > 0) {
591                 // The easiest way to bubble the revert reason is using memory via assembly
592 
593                 assembly {
594                     let returndata_size := mload(returndata)
595                     revert(add(32, returndata), returndata_size)
596                 }
597             } else {
598                 revert(errorMessage);
599             }
600         }
601     }
602 }
603 
604 abstract contract ERC165 is IERC165 {
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId) 
609         public 
610         view 
611         virtual 
612         override 
613         returns (bool) 
614     {
615         return interfaceId == type(IERC165).interfaceId;
616     }
617 }
618 
619 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
620     using Address for address;
621     using Strings for uint256;
622 
623     // Token name
624     string private _name;
625 
626     // Token symbol
627     string private _symbol;
628 
629     // Mapping from token ID to owner address
630     mapping(uint256 => address) private _owners;
631 
632     // Mapping owner address to token count
633     mapping(address => uint256) private _balances;
634 
635     // Mapping from token ID to approved address
636     mapping(uint256 => address) private _tokenApprovals;
637 
638     // Mapping from owner to operator approvals
639     mapping(address => mapping(address => bool)) private _operatorApprovals;
640 
641     /**
642      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
643      */
644     constructor(string memory name_, string memory symbol_) {
645         _name = name_;
646         _symbol = symbol_;
647     }
648 
649     /**
650      * @dev See {IERC165-supportsInterface}.
651      */
652     function supportsInterface(bytes4 interfaceId) 
653         public 
654         view 
655         virtual 
656         override(ERC165, IERC165) 
657         returns (bool) 
658     {
659         return
660             interfaceId == type(IERC721).interfaceId ||
661             interfaceId == type(IERC721Metadata).interfaceId ||
662             super.supportsInterface(interfaceId);
663     }
664 
665     /**
666      * @dev See {IERC721-balanceOf}.
667      */
668     function balanceOf(address owner) 
669         public 
670         view 
671         virtual 
672         override 
673         returns (uint256) 
674     {
675         require(
676             owner != address(0), 
677             "ERC721: balance query for the zero address"
678         );
679         return _balances[owner];
680     }
681 
682     /**
683      * @dev See {IERC721-ownerOf}.
684      */
685     function ownerOf(uint256 tokenId) 
686         public 
687         view 
688         virtual 
689         override 
690         returns (address) 
691     {
692         address owner = _owners[tokenId];
693         require(
694             owner != address(0), 
695             "ERC721: owner query for nonexistent token"
696         );
697         return owner;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-name}.
702      */
703     function name() public view virtual override returns (string memory) {
704         return _name;
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-symbol}.
709      */
710     function symbol() public view virtual override returns (string memory) {
711         return _symbol;
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-tokenURI}.
716      */
717     function tokenURI(uint256 tokenId) 
718         public 
719         view 
720         virtual 
721         override 
722         returns (string memory) 
723     {
724         require(
725             _exists(tokenId), 
726             "ERC721Metadata: URI query for nonexistent token"
727         );
728 
729         string memory baseURI = _baseURI();
730         return 
731             bytes(baseURI).length > 0 
732                 ? string(abi.encodePacked(baseURI, tokenId.toString())) 
733                 : "";
734     }
735 
736     /**
737      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
738      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
739      * by default, can be overriden in child contracts.
740      */
741     function _baseURI() internal view virtual returns (string memory) {
742         return "";
743     }
744 
745     /**
746      * @dev See {IERC721-approve}.
747      */
748     function approve(address to, uint256 tokenId) public virtual override {
749         address owner = ERC721.ownerOf(tokenId);
750         require(to != owner, "ERC721: approval to current owner");
751 
752         require(
753             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
754             "ERC721: approve caller is not owner nor approved for all"
755         );
756 
757         _approve(to, tokenId);
758     }
759 
760     /**
761      * @dev See {IERC721-getApproved}.
762      */
763     function getApproved(uint256 tokenId) 
764         public 
765         view 
766         virtual 
767         override 
768         returns (address) 
769     {
770         require(
771             _exists(tokenId), 
772             "ERC721: approved query for nonexistent token"
773         );
774 
775         return _tokenApprovals[tokenId];
776     }
777 
778     /**
779      * @dev See {IERC721-setApprovalForAll}.
780      */
781     function setApprovalForAll(address operator, bool approved) 
782         public 
783         virtual 
784         override 
785     {
786         require(operator != _msgSender(), "ERC721: approve to caller");
787 
788         _operatorApprovals[_msgSender()][operator] = approved;
789         emit ApprovalForAll(_msgSender(), operator, approved);
790     }
791 
792     /**
793      * @dev See {IERC721-isApprovedForAll}.
794      */
795     function isApprovedForAll(address owner, address operator) 
796         public 
797         view 
798         virtual 
799         override 
800         returns (bool) 
801     {
802         return _operatorApprovals[owner][operator];
803     }
804 
805     /**
806      * @dev See {IERC721-transferFrom}.
807      */
808     function transferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) public virtual override {
813         //solhint-disable-next-line max-line-length
814         require(
815             _isApprovedOrOwner(_msgSender(), tokenId), 
816             "ERC721: transfer caller is not owner nor approved"
817         );
818 
819         _transfer(from, to, tokenId);
820     }
821 
822     /**
823      * @dev See {IERC721-safeTransferFrom}.
824      */
825     function safeTransferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public virtual override {
830         safeTransferFrom(from, to, tokenId, "");
831     }
832 
833     /**
834      * @dev See {IERC721-safeTransferFrom}.
835      */
836     function safeTransferFrom(
837         address from,
838         address to,
839         uint256 tokenId,
840         bytes memory _data
841     ) public virtual override {
842         require(
843             _isApprovedOrOwner(_msgSender(), tokenId), 
844             "ERC721: transfer caller is not owner nor approved"
845         );
846         _safeTransfer(from, to, tokenId, _data);
847     }
848 
849     /**
850      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
851      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
852      *
853      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
854      *
855      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
856      * implement alternative mechanisms to perform token transfer, such as signature-based.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must exist and be owned by `from`.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _safeTransfer(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) internal virtual {
873         _transfer(from, to, tokenId);
874         require(
875             _checkOnERC721Received(from, to, tokenId, _data), 
876             "ERC721: transfer to non ERC721Receiver implementer"
877         );
878     }
879 
880     /**
881      * @dev Returns whether `tokenId` exists.
882      *
883      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
884      *
885      * Tokens start existing when they are minted (`_mint`),
886      * and stop existing when they are burned (`_burn`).
887      */
888     function _exists(uint256 tokenId) internal view virtual returns (bool) {
889         return _owners[tokenId] != address(0);
890     }
891 
892     /**
893      * @dev Returns whether `spender` is allowed to manage `tokenId`.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function _isApprovedOrOwner(address spender, uint256 tokenId) 
900         internal 
901         view 
902         virtual 
903         returns (bool) 
904     {
905         require(
906             _exists(tokenId), 
907             "ERC721: operator query for nonexistent token"
908         );
909         address owner = ERC721.ownerOf(tokenId);
910         return (spender == owner || 
911             getApproved(tokenId) == spender || 
912             isApprovedForAll(owner, spender));
913     }
914 
915     /**
916      * @dev Safely mints `tokenId` and transfers it to `to`.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must not exist.
921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _safeMint(address to, uint256 tokenId) internal virtual {
926         _safeMint(to, tokenId, "");
927     }
928 
929     /**
930      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
931      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
932      */
933     function _safeMint(
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) internal virtual {
938         _mint(to, tokenId);
939         require(
940             _checkOnERC721Received(address(0), to, tokenId, _data),
941             "ERC721: transfer to non ERC721Receiver implementer"
942         );
943     }
944 
945     /**
946      * @dev Mints `tokenId` and transfers it to `to`.
947      *
948      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - `to` cannot be the zero address.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _mint(address to, uint256 tokenId) internal virtual {
958         require(to != address(0), "ERC721: mint to the zero address");
959         require(!_exists(tokenId), "ERC721: token already minted");
960 
961         _beforeTokenTransfer(address(0), to, tokenId);
962 
963         _balances[to] += 1;
964         _owners[tokenId] = to;
965 
966         emit Transfer(address(0), to, tokenId);
967     }
968 
969     /**
970      * @dev Destroys `tokenId`.
971      * The approval is cleared when the token is burned.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must exist.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _burn(uint256 tokenId) internal virtual {
980         address owner = ERC721.ownerOf(tokenId);
981 
982         _beforeTokenTransfer(owner, address(0), tokenId);
983 
984         // Clear approvals
985         _approve(address(0), tokenId);
986 
987         _balances[owner] -= 1;
988         delete _owners[tokenId];
989 
990         emit Transfer(owner, address(0), tokenId);
991     }
992 
993     /**
994      * @dev Transfers `tokenId` from `from` to `to`.
995      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must be owned by `from`.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _transfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) internal virtual {
1009         require(
1010             ERC721.ownerOf(tokenId) == from, 
1011             "ERC721: transfer of token that is not own"
1012         );
1013         require(to != address(0), "ERC721: transfer to the zero address");
1014 
1015         _beforeTokenTransfer(from, to, tokenId);
1016 
1017         // Clear approvals from the previous owner
1018         _approve(address(0), tokenId);
1019 
1020         _balances[from] -= 1;
1021         _balances[to] += 1;
1022         _owners[tokenId] = to;
1023 
1024         emit Transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev Approve `to` to operate on `tokenId`
1029      *
1030      * Emits a {Approval} event.
1031      */
1032     function _approve(address to, uint256 tokenId) internal virtual {
1033         _tokenApprovals[tokenId] = to;
1034         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1039      * The call is not executed if the target address is not a contract.
1040      *
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkOnERC721Received(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) private returns (bool) {
1053         if (to.isContract()) {
1054             try 
1055                 IERC721Receiver(to).onERC721Received(
1056                     _msgSender(), 
1057                     from, 
1058                     tokenId, 
1059                     _data
1060                 ) 
1061             returns (bytes4 retval) {
1062                 return retval == IERC721Receiver.onERC721Received.selector;
1063             } catch (bytes memory reason) {
1064                 if (reason.length == 0) {
1065                     revert(
1066                         "ERC721: transfer to non ERC721Receiver implementer"
1067                     );
1068                 } else {
1069                     assembly {
1070                         revert(add(32, reason), mload(reason))
1071                     }
1072                 }
1073             }
1074         } else {
1075             return true;
1076         }
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` and `to` are never both zero.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {}
1098 }
1099 
1100 
1101 library SafeMath {
1102     /**
1103      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1104      *
1105      * _Available since v3.4._
1106      */
1107     function tryAdd(uint256 a, uint256 b) 
1108         internal 
1109         pure 
1110         returns (bool, uint256) 
1111     {
1112         unchecked {
1113             uint256 c = a + b;
1114             if (c < a) return (false, 0);
1115             return (true, c);
1116         }
1117     }
1118 
1119     /**
1120      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1121      *
1122      * _Available since v3.4._
1123      */
1124     function trySub(uint256 a, uint256 b) 
1125         internal 
1126         pure 
1127         returns (bool, uint256) 
1128     {
1129         unchecked {
1130             if (b > a) return (false, 0);
1131             return (true, a - b);
1132         }
1133     }
1134 
1135     /**
1136      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1137      *
1138      * _Available since v3.4._
1139      */
1140     function tryMul(uint256 a, uint256 b) 
1141         internal 
1142         pure 
1143         returns (bool, uint256) 
1144     {
1145         unchecked {
1146             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1147             // benefit is lost if 'b' is also tested.
1148             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1149             if (a == 0) return (true, 0);
1150             uint256 c = a * b;
1151             if (c / a != b) return (false, 0);
1152             return (true, c);
1153         }
1154     }
1155 
1156     /**
1157      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1158      *
1159      * _Available since v3.4._
1160      */
1161     function tryDiv(uint256 a, uint256 b) 
1162         internal 
1163         pure 
1164         returns (bool, uint256) 
1165     {
1166         unchecked {
1167             if (b == 0) return (false, 0);
1168             return (true, a / b);
1169         }
1170     }
1171 
1172     /**
1173      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1174      *
1175      * _Available since v3.4._
1176      */
1177     function tryMod(uint256 a, uint256 b) 
1178         internal 
1179         pure 
1180         returns (bool, uint256) 
1181     {
1182         unchecked {
1183             if (b == 0) return (false, 0);
1184             return (true, a % b);
1185         }
1186     }
1187 
1188     /**
1189      * @dev Returns the addition of two unsigned integers, reverting on
1190      * overflow.
1191      *
1192      * Counterpart to Solidity's `+` operator.
1193      *
1194      * Requirements:
1195      *
1196      * - Addition cannot overflow.
1197      */
1198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1199         return a + b;
1200     }
1201 
1202     /**
1203      * @dev Returns the subtraction of two unsigned integers, reverting on
1204      * overflow (when the result is negative).
1205      *
1206      * Counterpart to Solidity's `-` operator.
1207      *
1208      * Requirements:
1209      *
1210      * - Subtraction cannot overflow.
1211      */
1212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1213         return a - b;
1214     }
1215 
1216     /**
1217      * @dev Returns the multiplication of two unsigned integers, reverting on
1218      * overflow.
1219      *
1220      * Counterpart to Solidity's `*` operator.
1221      *
1222      * Requirements:
1223      *
1224      * - Multiplication cannot overflow.
1225      */
1226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1227         return a * b;
1228     }
1229 
1230     /**
1231      * @dev Returns the integer division of two unsigned integers, reverting on
1232      * division by zero. The result is rounded towards zero.
1233      *
1234      * Counterpart to Solidity's `/` operator.
1235      *
1236      * Requirements:
1237      *
1238      * - The divisor cannot be zero.
1239      */
1240     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1241         return a / b;
1242     }
1243 
1244     /**
1245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1246      * reverting when dividing by zero.
1247      *
1248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1249      * opcode (which leaves remaining gas untouched) while Solidity uses an
1250      * invalid opcode to revert (consuming all remaining gas).
1251      *
1252      * Requirements:
1253      *
1254      * - The divisor cannot be zero.
1255      */
1256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1257         return a % b;
1258     }
1259 
1260     /**
1261      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1262      * overflow (when the result is negative).
1263      *
1264      * CAUTION: This function is deprecated because it requires allocating memory for the error
1265      * message unnecessarily. For custom revert reasons use {trySub}.
1266      *
1267      * Counterpart to Solidity's `-` operator.
1268      *
1269      * Requirements:
1270      *
1271      * - Subtraction cannot overflow.
1272      */
1273     function sub(
1274         uint256 a,
1275         uint256 b,
1276         string memory errorMessage
1277     ) internal pure returns (uint256) {
1278         unchecked {
1279             require(b <= a, errorMessage);
1280             return a - b;
1281         }
1282     }
1283 
1284     /**
1285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1286      * division by zero. The result is rounded towards zero.
1287      *
1288      * Counterpart to Solidity's `/` operator. Note: this function uses a
1289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1290      * uses an invalid opcode to revert (consuming all remaining gas).
1291      *
1292      * Requirements:
1293      *
1294      * - The divisor cannot be zero.
1295      */
1296     function div(
1297         uint256 a,
1298         uint256 b,
1299         string memory errorMessage
1300     ) internal pure returns (uint256) {
1301         unchecked {
1302             require(b > 0, errorMessage);
1303             return a / b;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1309      * reverting with custom message when dividing by zero.
1310      *
1311      * CAUTION: This function is deprecated because it requires allocating memory for the error
1312      * message unnecessarily. For custom revert reasons use {tryMod}.
1313      *
1314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1315      * opcode (which leaves remaining gas untouched) while Solidity uses an
1316      * invalid opcode to revert (consuming all remaining gas).
1317      *
1318      * Requirements:
1319      *
1320      * - The divisor cannot be zero.
1321      */
1322     function mod(
1323         uint256 a,
1324         uint256 b,
1325         string memory errorMessage
1326     ) internal pure returns (uint256) {
1327         unchecked {
1328             require(b > 0, errorMessage);
1329             return a % b;
1330         }
1331     }
1332 }
1333 
1334 abstract contract Ownable is Context {
1335     address private _owner;
1336 
1337     event OwnershipTransferred(
1338         address indexed previousOwner, 
1339         address indexed newOwner
1340     );
1341 
1342     /**
1343      * @dev Initializes the contract setting the deployer as the initial owner.
1344      */
1345     constructor() {
1346         _setOwner(_msgSender());
1347     }
1348 
1349     /**
1350      * @dev Returns the address of the current owner.
1351      */
1352     function owner() public view virtual returns (address) {
1353         return _owner;
1354     }
1355 
1356     /**
1357      * @dev Throws if called by any account other than the owner.
1358      */
1359     modifier onlyOwner() {
1360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1361         _;
1362     }
1363 
1364     /**
1365      * @dev Leaves the contract without owner. It will not be possible to call
1366      * `onlyOwner` functions anymore. Can only be called by the current owner.
1367      *
1368      * NOTE: Renouncing ownership will leave the contract without an owner,
1369      * thereby removing any functionality that is only available to the owner.
1370      */
1371     function renounceOwnership() public virtual onlyOwner {
1372         _setOwner(address(0));
1373     }
1374 
1375     /**
1376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1377      * Can only be called by the current owner.
1378      */
1379     function transferOwnership(address newOwner) public virtual onlyOwner {
1380         require(
1381             newOwner != address(0), 
1382             "Ownable: new owner is the zero address"
1383         );
1384         _setOwner(newOwner);
1385     }
1386 
1387     function _setOwner(address newOwner) private {
1388         address oldOwner = _owner;
1389         _owner = newOwner;
1390         emit OwnershipTransferred(oldOwner, newOwner);
1391     }
1392 }
1393 
1394 abstract contract ReentrancyGuard {
1395     // Booleans are more expensive than uint256 or any type that takes up a full
1396     // word because each write operation emits an extra SLOAD to first read the
1397     // slot's contents, replace the bits taken up by the boolean, and then write
1398     // back. This is the compiler's defense against contract upgrades and
1399     // pointer aliasing, and it cannot be disabled.
1400 
1401     // The values being non-zero value makes deployment a bit more expensive,
1402     // but in exchange the refund on every call to nonReentrant will be lower in
1403     // amount. Since refunds are capped to a percentage of the total
1404     // transaction's gas, it is best to keep them low in cases like this one, to
1405     // increase the likelihood of the full refund coming into effect.
1406     uint256 private constant _NOT_ENTERED = 1;
1407     uint256 private constant _ENTERED = 2;
1408 
1409     uint256 private _status;
1410 
1411     constructor() {
1412         _status = _NOT_ENTERED;
1413     }
1414 
1415     /**
1416      * @dev Prevents a contract from calling itself, directly or indirectly.
1417      * Calling a `nonReentrant` function from another `nonReentrant`
1418      * function is not supported. It is possible to prevent this from happening
1419      * by making the `nonReentrant` function external, and make it call a
1420      * `private` function that does the actual work.
1421      */
1422     modifier nonReentrant() {
1423         // On the first call to nonReentrant, _notEntered will be true
1424         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1425 
1426         // Any calls to nonReentrant after this point will fail
1427         _status = _ENTERED;
1428 
1429         _;
1430 
1431         // By storing the original value once again, a refund is triggered (see
1432         // https://eips.ethereum.org/EIPS/eip-2200)
1433         _status = _NOT_ENTERED;
1434     }
1435 }
1436 
1437 /* 
1438      __   ___   _____  _____ 
1439     |  \ | | | | |   \| | __|
1440     |   \| | |_| | |) | | _| 
1441     |_|\___|\___/|___/|_|___|
1442 
1443  */
1444 /**
1445  * @title A contract for NUDIE COMMUNITY
1446  * @author Hiro
1447  * @notice NFT Minting
1448  */
1449 contract NudieCommunityNFT is ERC721, Ownable, Pausable, ReentrancyGuard {
1450     using Strings for uint256;
1451     using SafeMath for uint256;
1452     using SafeMath for uint8;
1453 
1454     uint256 public constant MAX_SUPPLY = 10000;
1455     uint256 public constant MINT_PRICE = 0.07 ether;
1456     uint256 public constant MINT_PRICE_PUBLIC = 0.07 ether;
1457     uint256 public constant MAX_MINT_PER_TX = 10;
1458     uint256 public constant MAX_MINT_PER_WL = 2;
1459     uint256 public constant MAX_MINT_PER_VIP = 5;
1460     uint256 public constant MAX_MINT_PER_WHALE = 20;
1461     uint256 public constant GIVEAWAY_SUPPLY = 200;
1462     uint256 public totalSupply = 0;
1463 
1464     bool public saleStarted = false;
1465     bool public preSaleStarted = false;
1466     bool public revealed = false;
1467 
1468     string public baseExtension = ".json";
1469     string public baseURI;
1470     string public notRevealedURI;
1471 
1472     // Merkle Tree Root
1473     bytes32 private _merkleRoot;
1474 
1475     // Team wallet
1476     address[] private _royaltyAddresses = [
1477         0xe2F5fa401aac8bF406863f61AEBA4fB17073C85b, // Wallet 1 address
1478         0x68Bf599600F01B056b5Ea831Ee7a72FA6f6D6F37, // Wallet 2 address
1479         0xfa9727c0a5B3fa203E3775e33E600248c9a5aB89, // Wallet 3 address
1480         0x9FB36a94e0CC99b5ba717c9E6D0EB0e370ddDDa1, // Wallet 4 address
1481         0xfE3Ef407AAa9ca27AEC0CA2c3C5789431749f892, // Wallet 5 address
1482         0x412aAbb45DAF6687Ab689b584101d18050DD7353, // Wallet 6 address
1483         0x27eA5D3eAE66a66b1164d2137403FFd9Ae1049eA, // Wallet 7 address
1484         0x86D7c4e370e9661A907bBaB77448bCe9203Ecb75, // Wallet 8 address
1485         0xAbEec041894DCE885fdc04cbDDecEE09CE2C53c2  // Wallet 9 address
1486     ];
1487 
1488     mapping(address => uint256) private _royaltyShares;
1489     mapping(address => uint256) balanceOfAddress;
1490 
1491     constructor(
1492         string memory _name,
1493         string memory _symbol,
1494         string memory _initBaseURI,
1495         string memory _initNotRevealedURI
1496     ) ERC721(_name, _symbol) {
1497         setBaseURI(_initBaseURI);
1498         setNotRevealedURI(_initNotRevealedURI);
1499 
1500         _royaltyShares[_royaltyAddresses[0]] = 20; // Royalty for Wallet 1
1501         _royaltyShares[_royaltyAddresses[1]] = 20; // Royalty for Wallet 2
1502         _royaltyShares[_royaltyAddresses[2]] = 20; // Royalty for Wallet 3
1503         _royaltyShares[_royaltyAddresses[3]] = 13; // Royalty for Wallet 4
1504         _royaltyShares[_royaltyAddresses[4]] = 13; //  Royalty for Wallet 5
1505         _royaltyShares[_royaltyAddresses[5]] = 7;  //  Royalty for Wallet 6
1506         _royaltyShares[_royaltyAddresses[6]] = 5;  //  Royalty for Wallet 7
1507         _royaltyShares[_royaltyAddresses[7]] = 1;  //  Royalty for Wallet 8
1508         _royaltyShares[_royaltyAddresses[8]] = 1;  //  Royalty for Wallet 9
1509     }
1510 
1511     /// @dev    Getter for the base URI 
1512     /// @return String of the base URI
1513     function _baseURI() internal view virtual override returns (string memory) {
1514         return baseURI;
1515     }
1516 
1517     /// @dev Mint NFTs for giveway
1518     function mintForGiveaway() external onlyOwner {
1519         require(totalSupply == 0, "MINT_ALREADY_STARTED");
1520 
1521         for (uint256 i = 1; i <= GIVEAWAY_SUPPLY; i++) {
1522             _safeMint(msg.sender, totalSupply + i);
1523         }
1524         totalSupply += GIVEAWAY_SUPPLY;
1525     }
1526 
1527     /// @dev   Admin mint for allocated NFTs
1528     /// @param _amount Number of NFTs to mint
1529     /// @param _to NFT receiver
1530     function mintAdmin(uint256 _amount, address _to) external onlyOwner {
1531         require(totalSupply + _amount <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1532         require(totalSupply >= GIVEAWAY_SUPPLY, "GIVEAWAY_NOT_MINTED");
1533         require(msg.sender == owner(), "MINT_NOT_OWNER");
1534 
1535 
1536         for (uint256 i = 1; i <= _amount; i++) {
1537             _safeMint(_to, totalSupply + i);
1538         }
1539         totalSupply += _amount;
1540     }
1541 
1542     /// @dev    Add a hashed address to the merkle tree as a leaf
1543     /// @param  account Leaf address for MerkleTree
1544     /// @return bytes32 hashed version of the merkle leaf address
1545     function _leaf(address account) private pure returns (bytes32) {
1546         return keccak256(abi.encodePacked(account));
1547     }
1548 
1549     /// @dev    Verify the whitelist using the merkle tree
1550     /// @param  leaf Hashed address leaf from _leaf() to search for
1551     /// @param  proof Submitted root proof from MerkleTree
1552     /// @return bool True if address is allowed to mint
1553     function verifyWhitelist(bytes32 leaf, bytes32[] memory proof)
1554         private
1555         view
1556         returns (bool)
1557     {
1558         bytes32 computedHash = leaf;
1559 
1560         for (uint256 i = 0; i < proof.length; i++) {
1561             bytes32 proofElement = proof[i];
1562 
1563             if (computedHash < proofElement) {
1564                 computedHash = keccak256(
1565                     abi.encodePacked(computedHash, proofElement)
1566                 );
1567             } else {
1568                 computedHash = keccak256(
1569                     abi.encodePacked(proofElement, computedHash)
1570                 );
1571             }
1572         }
1573 
1574         return computedHash == _merkleRoot;
1575     }
1576 
1577     /// @dev   General whitelist presale mint
1578     /// @param _count Amount to mint
1579     /// @param _proof Root merkle proof to submit
1580     function mintWhitelist(uint256 _count, bytes32[] memory _proof)
1581         external
1582         payable
1583     {
1584         require(preSaleStarted, "MINT_NOT_STARTED");
1585         require(
1586             verifyWhitelist(_leaf(msg.sender), _proof) == true,
1587             "ADDRESS_INVALID"
1588         );
1589 
1590         uint256 ownerTokenCount = balanceOf(msg.sender);
1591         require(
1592             _count > 0 && ownerTokenCount + _count <= MAX_MINT_PER_WL,
1593             "COUNT_INVALID"
1594         );
1595         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1596         require(totalSupply >= GIVEAWAY_SUPPLY, "GIVEAWAY_NOT_MINTED");
1597 
1598         if (msg.sender != owner()) {
1599             require(msg.value >= MINT_PRICE * _count);
1600         }
1601 
1602         for (uint256 i = 1; i <= _count; i++) {
1603             _safeMint(msg.sender, totalSupply + i);
1604         }
1605         totalSupply += _count;
1606     }
1607 
1608     /// @dev   VIP whitelist presale mint
1609     /// @param _count Amount to mint
1610     /// @param _proof Root merkle proof to submit
1611     function mintWhitelistForVIP(uint256 _count, bytes32[] memory _proof)
1612         external
1613         payable
1614     {
1615         require(preSaleStarted, "MINT_NOT_STARTED");
1616         require(
1617             verifyWhitelist(_leaf(msg.sender), _proof) == true,
1618             "ADDRESS_INVALID"
1619         );
1620 
1621         uint256 ownerTokenCount = balanceOf(msg.sender);
1622         require(
1623             _count > 0 && ownerTokenCount + _count <= MAX_MINT_PER_VIP,
1624             "COUNT_INVALID"
1625         );
1626         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1627         require(totalSupply >= GIVEAWAY_SUPPLY, "GIVEAWAY_NOT_MINTED");
1628 
1629         if (msg.sender != owner()) {
1630             require(msg.value >= MINT_PRICE * _count);
1631         }
1632 
1633         for (uint256 i = 1; i <= _count; i++) {
1634             _safeMint(msg.sender, totalSupply + i);
1635         }
1636         totalSupply += _count;
1637     }
1638 
1639     /// @dev   Whale whitelist presale mint
1640     /// @param _count Amount to mint
1641     /// @param _proof Root merkle proof to submit
1642     function mintWhitelistForWhale(uint256 _count, bytes32[] memory _proof)
1643         external
1644         payable
1645     {
1646         require(preSaleStarted, "MINT_NOT_STARTED");
1647         require(
1648             verifyWhitelist(_leaf(msg.sender), _proof) == true,
1649             "ADDRESS_INVALID"
1650         );
1651 
1652         uint256 ownerTokenCount = balanceOf(msg.sender);
1653         require(
1654             _count > 0 && ownerTokenCount + _count <= MAX_MINT_PER_WHALE,
1655             "COUNT_INVALID"
1656         );
1657         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1658         require(totalSupply >= GIVEAWAY_SUPPLY, "GIVEAWAY_NOT_MINTED");
1659 
1660         if (msg.sender != owner()) {
1661             require(msg.value >= MINT_PRICE * _count);
1662         }
1663 
1664         for (uint256 i = 1; i <= _count; i++) {
1665             _safeMint(msg.sender, totalSupply + i);
1666         }
1667         totalSupply += _count;
1668     }
1669 
1670     /// @dev   Mint a single NFT
1671     /// @param _count Number of NFTs to mint
1672     function mint(uint256 _count) public payable {
1673         require(saleStarted, "MINT_NOT_STARTED");
1674         uint256 ownerTokenCount = balanceOf(msg.sender);
1675         require(
1676             _count > 0 && ownerTokenCount + _count <= MAX_MINT_PER_TX,
1677             "COUNT_INVALID"
1678         );
1679         require(totalSupply >= GIVEAWAY_SUPPLY, "GIVEAWAY_NOT_MINTED");
1680         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1681 
1682         if (msg.sender != owner()) {
1683             require(msg.value >= MINT_PRICE_PUBLIC * _count);
1684         }
1685 
1686         for (uint256 i = 1; i <= _count; i++) {
1687             _safeMint(msg.sender, totalSupply + i);
1688         }
1689         totalSupply += _count;
1690     }
1691 
1692     /// @dev    Override the current tokenURI
1693     /// @param  tokenId Token ID that you want to override
1694     /// @return String of new tokenURI
1695     function tokenURI(uint256 tokenId)
1696         public
1697         view
1698         virtual
1699         override
1700         returns (string memory)
1701     {
1702         require(_exists(tokenId), "Token does not exist");
1703 
1704         string memory currentBaseURI = "";
1705         if (revealed == false) {
1706             currentBaseURI = notRevealedURI;
1707         }
1708         else {
1709             currentBaseURI = _baseURI();
1710         }
1711         return
1712             bytes(currentBaseURI).length > 0
1713                 ? string(
1714                     abi.encodePacked(
1715                         currentBaseURI,
1716                         tokenId.toString(),
1717                         baseExtension
1718                     )
1719                 )
1720                 : "";
1721     }
1722 
1723     /// @dev Withdraw ether from the smart contract
1724     function withdraw() external onlyOwner {
1725         require(address(this).balance > 0, "EMPTY_BALANCE");
1726         uint256 balance = address(this).balance;
1727 
1728         for (uint256 i = 0; i < _royaltyAddresses.length; i++) {
1729             payable(_royaltyAddresses[i]).transfer(
1730                 balance.div(100).mul(_royaltyShares[_royaltyAddresses[i]])
1731             );
1732         }
1733     }
1734 
1735     /// @dev Set the sale to starting
1736     /// @param _hasStarted Boolean to set sale to starting
1737     function setSaleStarted(bool _hasStarted) external onlyOwner {
1738         require(saleStarted != _hasStarted, "SALE_STARTED_ALREADY_SET");
1739         saleStarted = _hasStarted;
1740     }
1741 
1742     /// @dev   Set the presale to starting
1743     /// @param _hasStarted Boolean to set presale to starting
1744     function setPreSaleStarted(bool _hasStarted) external onlyOwner {
1745         require(preSaleStarted != _hasStarted, "PRESALE_STARTED_ALREADY_SET");
1746         preSaleStarted = _hasStarted;
1747     }
1748 
1749     /// @dev   Set a new base URI for the NFT metadata
1750     /// @param _newBaseURI String of new baseURI
1751     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1752         baseURI = _newBaseURI;
1753     }
1754 
1755     /// @dev Open the reveal gates!
1756     function reveal() public onlyOwner {
1757         revealed = true;
1758     }
1759 
1760     /// @dev   Set the new tokenURI for a specific token
1761     /// @param _notRevealedURI String of not revealed URI
1762     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1763         notRevealedURI = _notRevealedURI;
1764     }
1765 
1766     /// @dev Set the merkle root
1767     /// @param _merkleRootValue String of merkle root
1768     /// @return Bytes32 merkle root
1769     function setMerkleRoot(bytes32 _merkleRootValue)
1770         external
1771         onlyOwner
1772         returns (bytes32)
1773     {
1774         _merkleRoot = _merkleRootValue;
1775         return _merkleRoot;
1776     }
1777 
1778     /// @dev Pause the contract as an emergency switch
1779     function pause() external onlyOwner {
1780         require(!paused(), "ALREADY_PAUSED");
1781         _pause();
1782     }
1783 
1784     /// @dev Unpause the contract as an emergency switch
1785     function unpause() external onlyOwner {
1786         require(paused(), "ALREADY_UNPAUSED");
1787         _unpause();
1788     }
1789 }