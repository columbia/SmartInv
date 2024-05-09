1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.11;
3 
4 library Strings {
5     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
6 
7     /**
8      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
9      */
10     function toString(uint256 value) internal pure returns (string memory) {
11         // Inspired by OraclizeAPI's implementation - MIT licence
12         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
13 
14         if (value == 0) {
15             return "0";
16         }
17         uint256 temp = value;
18         uint256 digits;
19         while (temp != 0) {
20             digits++;
21             temp /= 10;
22         }
23         bytes memory buffer = new bytes(digits);
24         while (value != 0) {
25             digits -= 1;
26             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
27             value /= 10;
28         }
29         return string(buffer);
30     }
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
34      */
35     function toHexString(uint256 value) internal pure returns (string memory) {
36         if (value == 0) {
37             return "0x00";
38         }
39         uint256 temp = value;
40         uint256 length = 0;
41         while (temp != 0) {
42             length++;
43             temp >>= 8;
44         }
45         return toHexString(value, length);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
50      */
51     function toHexString(uint256 value, uint256 length) 
52         internal 
53         pure 
54         returns (string memory) 
55     {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes calldata) {
74         return msg.data;
75     }
76 }
77 
78 abstract contract Pausable is Context {
79     /**
80      * @dev Emitted when the pause is triggered by `account`.
81      */
82     event Paused(address account);
83 
84     /**
85      * @dev Emitted when the pause is lifted by `account`.
86      */
87     event Unpaused(address account);
88 
89     bool private _paused;
90 
91     /**
92      * @dev Initializes the contract in unpaused state.
93      */
94     constructor() {
95         _paused = false;
96     }
97 
98     /**
99      * @dev Returns true if the contract is paused, and false otherwise.
100      */
101     function paused() public view virtual returns (bool) {
102         return _paused;
103     }
104 
105     /**
106      * @dev Modifier to make a function callable only when the contract is not paused.
107      *
108      * Requirements:
109      *
110      * - The contract must not be paused.
111      */
112     modifier whenNotPaused() {
113         require(!paused(), "Pausable: paused");
114         _;
115     }
116 
117     /**
118      * @dev Modifier to make a function callable only when the contract is paused.
119      *
120      * Requirements:
121      *
122      * - The contract must be paused.
123      */
124     modifier whenPaused() {
125         require(paused(), "Pausable: not paused");
126         _;
127     }
128 
129     /**
130      * @dev Triggers stopped state.
131      *
132      * Requirements:
133      *
134      * - The contract must not be paused.
135      */
136     function _pause() internal virtual whenNotPaused {
137         _paused = true;
138         emit Paused(_msgSender());
139     }
140 
141     /**
142      * @dev Returns to normal state.
143      *
144      * Requirements:
145      *
146      * - The contract must be paused.
147      */
148     function _unpause() internal virtual whenPaused {
149         _paused = false;
150         emit Unpaused(_msgSender());
151     }
152 }
153 
154 interface IERC165 {
155     /**
156      * @dev Returns true if this contract implements the interface defined by
157      * `interfaceId`. See the corresponding
158      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
159      * to learn more about how these ids are created.
160      *
161      * This function call must use less than 30 000 gas.
162      */
163     function supportsInterface(bytes4 interfaceId) external view returns (bool);
164 }
165 
166 interface IERC721 is IERC165 {
167     /**
168      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
169      */
170     event Transfer(
171         address indexed from, 
172         address indexed to, 
173         uint256 indexed tokenId
174     );
175 
176     /**
177      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
178      */
179     event Approval(
180         address indexed owner, 
181         address indexed approved, 
182         uint256 indexed tokenId
183     );
184 
185     /**
186      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
187      */
188     event ApprovalForAll(
189         address indexed owner, 
190         address indexed operator, 
191         bool approved
192     );
193 
194     /**
195      * @dev Returns the number of tokens in ``owner``'s account.
196      */
197     function balanceOf(address owner) external view returns (uint256 balance);
198 
199     /**
200      * @dev Returns the owner of the `tokenId` token.
201      *
202      * Requirements:
203      *
204      * - `tokenId` must exist.
205      */
206     function ownerOf(uint256 tokenId) external view returns (address owner);
207 
208     /**
209      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
210      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must exist and be owned by `from`.
217      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
218      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
219      *
220      * Emits a {Transfer} event.
221      */
222     function safeTransferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external;
227 
228     /**
229      * @dev Transfers `tokenId` token from `from` to `to`.
230      *
231      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(
243         address from,
244         address to,
245         uint256 tokenId
246     ) external;
247 
248     /**
249      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
250      * The approval is cleared when the token is transferred.
251      *
252      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
253      *
254      * Requirements:
255      *
256      * - The caller must own the token or be an approved operator.
257      * - `tokenId` must exist.
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address to, uint256 tokenId) external;
262 
263     /**
264      * @dev Returns the account approved for `tokenId` token.
265      *
266      * Requirements:
267      *
268      * - `tokenId` must exist.
269      */
270     function getApproved(uint256 tokenId) 
271         external 
272         view 
273         returns (address operator);
274 
275     /**
276      * @dev Approve or remove `operator` as an operator for the caller.
277      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
278      *
279      * Requirements:
280      *
281      * - The `operator` cannot be the caller.
282      *
283      * Emits an {ApprovalForAll} event.
284      */
285     function setApprovalForAll(address operator, bool _approved) external;
286 
287     /**
288      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
289      *
290      * See {setApprovalForAll}
291      */
292     function isApprovedForAll(address owner, address operator) 
293         external 
294         view 
295         returns (bool);
296 
297     /**
298      * @dev Safely transfers `tokenId` token from `from` to `to`.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must exist and be owned by `from`.
305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
306      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
307      *
308      * Emits a {Transfer} event.
309      */
310     function safeTransferFrom(
311         address from,
312         address to,
313         uint256 tokenId,
314         bytes calldata data
315     ) external;
316 }
317 
318 interface IERC721Receiver {
319     /**
320      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
321      * by `operator` from `from`, this function is called.
322      *
323      * It must return its Solidity selector to confirm the token transfer.
324      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
325      *
326      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
327      */
328     function onERC721Received(
329         address operator,
330         address from,
331         uint256 tokenId,
332         bytes calldata data
333     ) external returns (bytes4);
334 }
335 
336 interface IERC721Metadata is IERC721 {
337     /**
338      * @dev Returns the token collection name.
339      */
340     function name() external view returns (string memory);
341 
342     /**
343      * @dev Returns the token collection symbol.
344      */
345     function symbol() external view returns (string memory);
346 
347     /**
348      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
349      */
350     function tokenURI(uint256 tokenId) external view returns (string memory);
351 }
352 
353 library Address {
354     /**
355      * @dev Returns true if `account` is a contract.
356      *
357      * [IMPORTANT]
358      * ====
359      * It is unsafe to assume that an address for which this function returns
360      * false is an externally-owned account (EOA) and not a contract.
361      *
362      * Among others, `isContract` will return false for the following
363      * types of addresses:
364      *
365      *  - an externally-owned account
366      *  - a contract in construction
367      *  - an address where a contract will be created
368      *  - an address where a contract lived, but was destroyed
369      * ====
370      */
371     function isContract(address account) internal view returns (bool) {
372         // This method relies on extcodesize, which returns 0 for contracts in
373         // construction, since the code is only stored at the end of the
374         // constructor execution.
375 
376         uint256 size;
377         assembly {
378             size := extcodesize(account)
379         }
380         return size > 0;
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(
401             address(this).balance >= amount, 
402             "Address: insufficient balance"
403         );
404 
405         (bool success, ) = recipient.call{value: amount}("");
406         require(
407             success, 
408             "Address: unable to send value, recipient may have reverted"
409         );
410     }
411 
412     /**
413      * @dev Performs a Solidity function call using a low level `call`. A
414      * plain `call` is an unsafe replacement for a function call: use this
415      * function instead.
416      *
417      * If `target` reverts with a revert reason, it is bubbled up by this
418      * function (like regular Solidity function calls).
419      *
420      * Returns the raw returned data. To convert to the expected return value,
421      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
422      *
423      * Requirements:
424      *
425      * - `target` must be a contract.
426      * - calling `target` with `data` must not revert.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data) 
431         internal 
432         returns (bytes memory) 
433     {
434         return functionCall(target, data, "Address: low-level call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
439      * `errorMessage` as a fallback revert reason when `target` reverts.
440      *
441      * _Available since v3.1._
442      */
443     function functionCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         return functionCallWithValue(target, data, 0, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but also transferring `value` wei to `target`.
454      *
455      * Requirements:
456      *
457      * - the calling contract must have an ETH balance of at least `value`.
458      * - the called Solidity function must be `payable`.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value
466     ) internal returns (bytes memory) {
467         return 
468             functionCallWithValue(
469                 target, 
470                 data, 
471                 value, 
472                 "Address: low-level call with value failed"
473             );
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
478      * with `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(
489             address(this).balance >= value, 
490             "Address: insufficient balance for call"
491         );
492         require(isContract(target), "Address: call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.call{value: value}(
495             data
496         );
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but performing a static call.
503      *
504      * _Available since v3.3._
505      */
506     function functionStaticCall(address target, bytes memory data) 
507         internal 
508         view 
509         returns (bytes memory) 
510     {
511         return 
512             functionStaticCall(
513                 target, 
514                 data, 
515                 "Address: low-level static call failed"
516             );
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal view returns (bytes memory) {
530         require(isContract(target), "Address: static call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.staticcall(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but performing a delegate call.
539      *
540      * _Available since v3.4._
541      */
542     function functionDelegateCall(address target, bytes memory data) 
543         internal 
544         returns (bytes memory) 
545     {
546         return 
547             functionDelegateCall(
548                 target, 
549                 data, 
550                 "Address: low-level delegate call failed"
551             );
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(isContract(target), "Address: delegate call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.delegatecall(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
573      * revert reason using the provided one.
574      *
575      * _Available since v4.3._
576      */
577     function verifyCallResult(
578         bool success,
579         bytes memory returndata,
580         string memory errorMessage
581     ) internal pure returns (bytes memory) {
582         if (success) {
583             return returndata;
584         } else {
585             // Look for revert reason and bubble it up if present
586             if (returndata.length > 0) {
587                 // The easiest way to bubble the revert reason is using memory via assembly
588 
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 abstract contract ERC165 is IERC165 {
601     /**
602      * @dev See {IERC165-supportsInterface}.
603      */
604     function supportsInterface(bytes4 interfaceId) 
605         public 
606         view 
607         virtual 
608         override 
609         returns (bool) 
610     {
611         return interfaceId == type(IERC165).interfaceId;
612     }
613 }
614 
615 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
616     using Address for address;
617     using Strings for uint256;
618 
619     // Token name
620     string private _name;
621 
622     // Token symbol
623     string private _symbol;
624 
625     // Mapping from token ID to owner address
626     mapping(uint256 => address) private _owners;
627 
628     // Mapping owner address to token count
629     mapping(address => uint256) private _balances;
630 
631     // Mapping from token ID to approved address
632     mapping(uint256 => address) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     /**
638      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
639      */
640     constructor(string memory name_, string memory symbol_) {
641         _name = name_;
642         _symbol = symbol_;
643     }
644 
645     /**
646      * @dev See {IERC165-supportsInterface}.
647      */
648     function supportsInterface(bytes4 interfaceId) 
649         public 
650         view 
651         virtual 
652         override(ERC165, IERC165) 
653         returns (bool) 
654     {
655         return
656             interfaceId == type(IERC721).interfaceId ||
657             interfaceId == type(IERC721Metadata).interfaceId ||
658             super.supportsInterface(interfaceId);
659     }
660 
661     /**
662      * @dev See {IERC721-balanceOf}.
663      */
664     function balanceOf(address owner) 
665         public 
666         view 
667         virtual 
668         override 
669         returns (uint256) 
670     {
671         require(
672             owner != address(0), 
673             "ERC721: balance query for the zero address"
674         );
675         return _balances[owner];
676     }
677 
678     /**
679      * @dev See {IERC721-ownerOf}.
680      */
681     function ownerOf(uint256 tokenId) 
682         public 
683         view 
684         virtual 
685         override 
686         returns (address) 
687     {
688         address owner = _owners[tokenId];
689         require(
690             owner != address(0), 
691             "ERC721: owner query for nonexistent token"
692         );
693         return owner;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-name}.
698      */
699     function name() public view virtual override returns (string memory) {
700         return _name;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-symbol}.
705      */
706     function symbol() public view virtual override returns (string memory) {
707         return _symbol;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-tokenURI}.
712      */
713     function tokenURI(uint256 tokenId) 
714         public 
715         view 
716         virtual 
717         override 
718         returns (string memory) 
719     {
720         require(
721             _exists(tokenId), 
722             "ERC721Metadata: URI query for nonexistent token"
723         );
724 
725         string memory baseURI = _baseURI();
726         return 
727             bytes(baseURI).length > 0 
728                 ? string(abi.encodePacked(baseURI, tokenId.toString())) 
729                 : "";
730     }
731 
732     /**
733      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
734      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
735      * by default, can be overriden in child contracts.
736      */
737     function _baseURI() internal view virtual returns (string memory) {
738         return "";
739     }
740 
741     /**
742      * @dev See {IERC721-approve}.
743      */
744     function approve(address to, uint256 tokenId) public virtual override {
745         address owner = ERC721.ownerOf(tokenId);
746         require(to != owner, "ERC721: approval to current owner");
747 
748         require(
749             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
750             "ERC721: approve caller is not owner nor approved for all"
751         );
752 
753         _approve(to, tokenId);
754     }
755 
756     /**
757      * @dev See {IERC721-getApproved}.
758      */
759     function getApproved(uint256 tokenId) 
760         public 
761         view 
762         virtual 
763         override 
764         returns (address) 
765     {
766         require(
767             _exists(tokenId), 
768             "ERC721: approved query for nonexistent token"
769         );
770 
771         return _tokenApprovals[tokenId];
772     }
773 
774     /**
775      * @dev See {IERC721-setApprovalForAll}.
776      */
777     function setApprovalForAll(address operator, bool approved) 
778         public 
779         virtual 
780         override 
781     {
782         require(operator != _msgSender(), "ERC721: approve to caller");
783 
784         _operatorApprovals[_msgSender()][operator] = approved;
785         emit ApprovalForAll(_msgSender(), operator, approved);
786     }
787 
788     /**
789      * @dev See {IERC721-isApprovedForAll}.
790      */
791     function isApprovedForAll(address owner, address operator) 
792         public 
793         view 
794         virtual 
795         override 
796         returns (bool) 
797     {
798         return _operatorApprovals[owner][operator];
799     }
800 
801     /**
802      * @dev See {IERC721-transferFrom}.
803      */
804     function transferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) public virtual override {
809         //solhint-disable-next-line max-line-length
810         require(
811             _isApprovedOrOwner(_msgSender(), tokenId), 
812             "ERC721: transfer caller is not owner nor approved"
813         );
814 
815         _transfer(from, to, tokenId);
816     }
817 
818     /**
819      * @dev See {IERC721-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) public virtual override {
826         safeTransferFrom(from, to, tokenId, "");
827     }
828 
829     /**
830      * @dev See {IERC721-safeTransferFrom}.
831      */
832     function safeTransferFrom(
833         address from,
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) public virtual override {
838         require(
839             _isApprovedOrOwner(_msgSender(), tokenId), 
840             "ERC721: transfer caller is not owner nor approved"
841         );
842         _safeTransfer(from, to, tokenId, _data);
843     }
844 
845     /**
846      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
847      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
848      *
849      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
850      *
851      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
852      * implement alternative mechanisms to perform token transfer, such as signature-based.
853      *
854      * Requirements:
855      *
856      * - `from` cannot be the zero address.
857      * - `to` cannot be the zero address.
858      * - `tokenId` token must exist and be owned by `from`.
859      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _safeTransfer(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) internal virtual {
869         _transfer(from, to, tokenId);
870         require(
871             _checkOnERC721Received(from, to, tokenId, _data), 
872             "ERC721: transfer to non ERC721Receiver implementer"
873         );
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
889      * @dev Returns whether `spender` is allowed to manage `tokenId`.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must exist.
894      */
895     function _isApprovedOrOwner(address spender, uint256 tokenId) 
896         internal 
897         view 
898         virtual 
899         returns (bool) 
900     {
901         require(
902             _exists(tokenId), 
903             "ERC721: operator query for nonexistent token"
904         );
905         address owner = ERC721.ownerOf(tokenId);
906         return (spender == owner || 
907             getApproved(tokenId) == spender || 
908             isApprovedForAll(owner, spender));
909     }
910 
911     /**
912      * @dev Safely mints `tokenId` and transfers it to `to`.
913      *
914      * Requirements:
915      *
916      * - `tokenId` must not exist.
917      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _safeMint(address to, uint256 tokenId) internal virtual {
922         _safeMint(to, tokenId, "");
923     }
924 
925     /**
926      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
927      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
928      */
929     function _safeMint(
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) internal virtual {
934         _mint(to, tokenId);
935         require(
936             _checkOnERC721Received(address(0), to, tokenId, _data),
937             "ERC721: transfer to non ERC721Receiver implementer"
938         );
939     }
940 
941     /**
942      * @dev Mints `tokenId` and transfers it to `to`.
943      *
944      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
945      *
946      * Requirements:
947      *
948      * - `tokenId` must not exist.
949      * - `to` cannot be the zero address.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _mint(address to, uint256 tokenId) internal virtual {
954         require(to != address(0), "ERC721: mint to the zero address");
955         require(!_exists(tokenId), "ERC721: token already minted");
956 
957         _beforeTokenTransfer(address(0), to, tokenId);
958 
959         _balances[to] += 1;
960         _owners[tokenId] = to;
961 
962         emit Transfer(address(0), to, tokenId);
963     }
964 
965     /**
966      * @dev Destroys `tokenId`.
967      * The approval is cleared when the token is burned.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must exist.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _burn(uint256 tokenId) internal virtual {
976         address owner = ERC721.ownerOf(tokenId);
977 
978         _beforeTokenTransfer(owner, address(0), tokenId);
979 
980         // Clear approvals
981         _approve(address(0), tokenId);
982 
983         _balances[owner] -= 1;
984         delete _owners[tokenId];
985 
986         emit Transfer(owner, address(0), tokenId);
987     }
988 
989     /**
990      * @dev Transfers `tokenId` from `from` to `to`.
991      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
992      *
993      * Requirements:
994      *
995      * - `to` cannot be the zero address.
996      * - `tokenId` token must be owned by `from`.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _transfer(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) internal virtual {
1005         require(
1006             ERC721.ownerOf(tokenId) == from, 
1007             "ERC721: transfer of token that is not own"
1008         );
1009         require(to != address(0), "ERC721: transfer to the zero address");
1010 
1011         _beforeTokenTransfer(from, to, tokenId);
1012 
1013         // Clear approvals from the previous owner
1014         _approve(address(0), tokenId);
1015 
1016         _balances[from] -= 1;
1017         _balances[to] += 1;
1018         _owners[tokenId] = to;
1019 
1020         emit Transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev Approve `to` to operate on `tokenId`
1025      *
1026      * Emits a {Approval} event.
1027      */
1028     function _approve(address to, uint256 tokenId) internal virtual {
1029         _tokenApprovals[tokenId] = to;
1030         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1035      * The call is not executed if the target address is not a contract.
1036      *
1037      * @param from address representing the previous owner of the given token ID
1038      * @param to target address that will receive the tokens
1039      * @param tokenId uint256 ID of the token to be transferred
1040      * @param _data bytes optional data to send along with the call
1041      * @return bool whether the call correctly returned the expected magic value
1042      */
1043     function _checkOnERC721Received(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) private returns (bool) {
1049         if (to.isContract()) {
1050             try 
1051                 IERC721Receiver(to).onERC721Received(
1052                     _msgSender(), 
1053                     from, 
1054                     tokenId, 
1055                     _data
1056                 ) 
1057             returns (bytes4 retval) {
1058                 return retval == IERC721Receiver.onERC721Received.selector;
1059             } catch (bytes memory reason) {
1060                 if (reason.length == 0) {
1061                     revert(
1062                         "ERC721: transfer to non ERC721Receiver implementer"
1063                     );
1064                 } else {
1065                     assembly {
1066                         revert(add(32, reason), mload(reason))
1067                     }
1068                 }
1069             }
1070         } else {
1071             return true;
1072         }
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before any token transfer. This includes minting
1077      * and burning.
1078      *
1079      * Calling conditions:
1080      *
1081      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1082      * transferred to `to`.
1083      * - When `from` is zero, `tokenId` will be minted for `to`.
1084      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1085      * - `from` and `to` are never both zero.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _beforeTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual {}
1094 }
1095 
1096 
1097 library SafeMath {
1098     /**
1099      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1100      *
1101      * _Available since v3.4._
1102      */
1103     function tryAdd(uint256 a, uint256 b) 
1104         internal 
1105         pure 
1106         returns (bool, uint256) 
1107     {
1108         unchecked {
1109             uint256 c = a + b;
1110             if (c < a) return (false, 0);
1111             return (true, c);
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1117      *
1118      * _Available since v3.4._
1119      */
1120     function trySub(uint256 a, uint256 b) 
1121         internal 
1122         pure 
1123         returns (bool, uint256) 
1124     {
1125         unchecked {
1126             if (b > a) return (false, 0);
1127             return (true, a - b);
1128         }
1129     }
1130 
1131     /**
1132      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1133      *
1134      * _Available since v3.4._
1135      */
1136     function tryMul(uint256 a, uint256 b) 
1137         internal 
1138         pure 
1139         returns (bool, uint256) 
1140     {
1141         unchecked {
1142             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1143             // benefit is lost if 'b' is also tested.
1144             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1145             if (a == 0) return (true, 0);
1146             uint256 c = a * b;
1147             if (c / a != b) return (false, 0);
1148             return (true, c);
1149         }
1150     }
1151 
1152     /**
1153      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1154      *
1155      * _Available since v3.4._
1156      */
1157     function tryDiv(uint256 a, uint256 b) 
1158         internal 
1159         pure 
1160         returns (bool, uint256) 
1161     {
1162         unchecked {
1163             if (b == 0) return (false, 0);
1164             return (true, a / b);
1165         }
1166     }
1167 
1168     /**
1169      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1170      *
1171      * _Available since v3.4._
1172      */
1173     function tryMod(uint256 a, uint256 b) 
1174         internal 
1175         pure 
1176         returns (bool, uint256) 
1177     {
1178         unchecked {
1179             if (b == 0) return (false, 0);
1180             return (true, a % b);
1181         }
1182     }
1183 
1184     /**
1185      * @dev Returns the addition of two unsigned integers, reverting on
1186      * overflow.
1187      *
1188      * Counterpart to Solidity's `+` operator.
1189      *
1190      * Requirements:
1191      *
1192      * - Addition cannot overflow.
1193      */
1194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1195         return a + b;
1196     }
1197 
1198     /**
1199      * @dev Returns the subtraction of two unsigned integers, reverting on
1200      * overflow (when the result is negative).
1201      *
1202      * Counterpart to Solidity's `-` operator.
1203      *
1204      * Requirements:
1205      *
1206      * - Subtraction cannot overflow.
1207      */
1208     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1209         return a - b;
1210     }
1211 
1212     /**
1213      * @dev Returns the multiplication of two unsigned integers, reverting on
1214      * overflow.
1215      *
1216      * Counterpart to Solidity's `*` operator.
1217      *
1218      * Requirements:
1219      *
1220      * - Multiplication cannot overflow.
1221      */
1222     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1223         return a * b;
1224     }
1225 
1226     /**
1227      * @dev Returns the integer division of two unsigned integers, reverting on
1228      * division by zero. The result is rounded towards zero.
1229      *
1230      * Counterpart to Solidity's `/` operator.
1231      *
1232      * Requirements:
1233      *
1234      * - The divisor cannot be zero.
1235      */
1236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1237         return a / b;
1238     }
1239 
1240     /**
1241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1242      * reverting when dividing by zero.
1243      *
1244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1245      * opcode (which leaves remaining gas untouched) while Solidity uses an
1246      * invalid opcode to revert (consuming all remaining gas).
1247      *
1248      * Requirements:
1249      *
1250      * - The divisor cannot be zero.
1251      */
1252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1253         return a % b;
1254     }
1255 
1256     /**
1257      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1258      * overflow (when the result is negative).
1259      *
1260      * CAUTION: This function is deprecated because it requires allocating memory for the error
1261      * message unnecessarily. For custom revert reasons use {trySub}.
1262      *
1263      * Counterpart to Solidity's `-` operator.
1264      *
1265      * Requirements:
1266      *
1267      * - Subtraction cannot overflow.
1268      */
1269     function sub(
1270         uint256 a,
1271         uint256 b,
1272         string memory errorMessage
1273     ) internal pure returns (uint256) {
1274         unchecked {
1275             require(b <= a, errorMessage);
1276             return a - b;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1282      * division by zero. The result is rounded towards zero.
1283      *
1284      * Counterpart to Solidity's `/` operator. Note: this function uses a
1285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1286      * uses an invalid opcode to revert (consuming all remaining gas).
1287      *
1288      * Requirements:
1289      *
1290      * - The divisor cannot be zero.
1291      */
1292     function div(
1293         uint256 a,
1294         uint256 b,
1295         string memory errorMessage
1296     ) internal pure returns (uint256) {
1297         unchecked {
1298             require(b > 0, errorMessage);
1299             return a / b;
1300         }
1301     }
1302 
1303     /**
1304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1305      * reverting with custom message when dividing by zero.
1306      *
1307      * CAUTION: This function is deprecated because it requires allocating memory for the error
1308      * message unnecessarily. For custom revert reasons use {tryMod}.
1309      *
1310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1311      * opcode (which leaves remaining gas untouched) while Solidity uses an
1312      * invalid opcode to revert (consuming all remaining gas).
1313      *
1314      * Requirements:
1315      *
1316      * - The divisor cannot be zero.
1317      */
1318     function mod(
1319         uint256 a,
1320         uint256 b,
1321         string memory errorMessage
1322     ) internal pure returns (uint256) {
1323         unchecked {
1324             require(b > 0, errorMessage);
1325             return a % b;
1326         }
1327     }
1328 }
1329 
1330 abstract contract Ownable is Context {
1331     address private _owner;
1332 
1333     event OwnershipTransferred(
1334         address indexed previousOwner, 
1335         address indexed newOwner
1336     );
1337 
1338     /**
1339      * @dev Initializes the contract setting the deployer as the initial owner.
1340      */
1341     constructor() {
1342         _setOwner(_msgSender());
1343     }
1344 
1345     /**
1346      * @dev Returns the address of the current owner.
1347      */
1348     function owner() public view virtual returns (address) {
1349         return _owner;
1350     }
1351 
1352     /**
1353      * @dev Throws if called by any account other than the owner.
1354      */
1355     modifier onlyOwner() {
1356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1357         _;
1358     }
1359 
1360     /**
1361      * @dev Leaves the contract without owner. It will not be possible to call
1362      * `onlyOwner` functions anymore. Can only be called by the current owner.
1363      *
1364      * NOTE: Renouncing ownership will leave the contract without an owner,
1365      * thereby removing any functionality that is only available to the owner.
1366      */
1367     function renounceOwnership() public virtual onlyOwner {
1368         _setOwner(address(0));
1369     }
1370 
1371     /**
1372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1373      * Can only be called by the current owner.
1374      */
1375     function transferOwnership(address newOwner) public virtual onlyOwner {
1376         require(
1377             newOwner != address(0), 
1378             "Ownable: new owner is the zero address"
1379         );
1380         _setOwner(newOwner);
1381     }
1382 
1383     function _setOwner(address newOwner) private {
1384         address oldOwner = _owner;
1385         _owner = newOwner;
1386         emit OwnershipTransferred(oldOwner, newOwner);
1387     }
1388 }
1389 
1390 abstract contract ReentrancyGuard {
1391     // Booleans are more expensive than uint256 or any type that takes up a full
1392     // word because each write operation emits an extra SLOAD to first read the
1393     // slot's contents, replace the bits taken up by the boolean, and then write
1394     // back. This is the compiler's defense against contract upgrades and
1395     // pointer aliasing, and it cannot be disabled.
1396 
1397     // The values being non-zero value makes deployment a bit more expensive,
1398     // but in exchange the refund on every call to nonReentrant will be lower in
1399     // amount. Since refunds are capped to a percentage of the total
1400     // transaction's gas, it is best to keep them low in cases like this one, to
1401     // increase the likelihood of the full refund coming into effect.
1402     uint256 private constant _NOT_ENTERED = 1;
1403     uint256 private constant _ENTERED = 2;
1404 
1405     uint256 private _status;
1406 
1407     constructor() {
1408         _status = _NOT_ENTERED;
1409     }
1410 
1411     /**
1412      * @dev Prevents a contract from calling itself, directly or indirectly.
1413      * Calling a `nonReentrant` function from another `nonReentrant`
1414      * function is not supported. It is possible to prevent this from happening
1415      * by making the `nonReentrant` function external, and make it call a
1416      * `private` function that does the actual work.
1417      */
1418     modifier nonReentrant() {
1419         // On the first call to nonReentrant, _notEntered will be true
1420         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1421 
1422         // Any calls to nonReentrant after this point will fail
1423         _status = _ENTERED;
1424 
1425         _;
1426 
1427         // By storing the original value once again, a refund is triggered (see
1428         // https://eips.ethereum.org/EIPS/eip-2200)
1429         _status = _NOT_ENTERED;
1430     }
1431 }
1432 
1433 
1434 
1435 contract WarriorMfers is ERC721, Ownable, Pausable, ReentrancyGuard {
1436     using Strings for uint256;
1437     using SafeMath for uint256;
1438     using SafeMath for uint8;
1439 
1440     uint256 public constant MAX_SUPPLY = 6500;
1441     uint256 public constant MAX_MINT_PER_TX = 20;
1442     uint256 public constant MAX_MINT_PER_PRESALE = 1;
1443     uint256 public MINT_PRICE_PUBLIC = 0.015 ether;
1444     uint256 public PRE_MINT_PRICE = 0.0 ether;
1445 
1446     uint256 public totalSupply = 0;
1447 
1448     bool public saleStarted = false;
1449     bool public preSaleStarted = false;
1450     bool public revealed = false;
1451 
1452     string public baseExtension = ".json";
1453     string public baseURI;
1454     string public notRevealedURI;
1455 
1456     // Merkle Tree Root
1457     bytes32 private _merkleRoot;
1458 
1459     mapping(address => uint256) balanceOfAddress;
1460 
1461     constructor(
1462         string memory _initBaseURI,
1463         string memory _initNotRevealedURI
1464     ) ERC721("Warrior Mfers", "WM") {
1465         setBaseURI(_initBaseURI);
1466         setNotRevealedURI(_initNotRevealedURI);
1467     }
1468 
1469     function _baseURI() internal view virtual override returns (string memory) {
1470         return baseURI;
1471     }
1472 
1473     function airdrop(uint256 _count, address _account) external onlyOwner {
1474         require(totalSupply + _count <= MAX_SUPPLY, "max airdrop limit exceeded");
1475         for (uint256 i = 1; i <= _count; i++) {
1476             _safeMint(_account, totalSupply + i);
1477         }
1478         totalSupply += _count;
1479     }
1480 
1481     
1482     function _leaf(address account) private pure returns (bytes32) {
1483         return keccak256(abi.encodePacked(account));
1484     }
1485 
1486     
1487     function verifyWhitelist(bytes32 leaf, bytes32[] memory proof)
1488         private
1489         view
1490         returns (bool)
1491     {
1492         bytes32 computedHash = leaf;
1493 
1494         for (uint256 i = 0; i < proof.length; i++) {
1495             bytes32 proofElement = proof[i];
1496 
1497             if (computedHash < proofElement) {
1498                 computedHash = keccak256(
1499                     abi.encodePacked(computedHash, proofElement)
1500                 );
1501             } else {
1502                 computedHash = keccak256(
1503                     abi.encodePacked(proofElement, computedHash)
1504                 );
1505             }
1506         }
1507 
1508         return computedHash == _merkleRoot;
1509     }
1510 
1511    
1512     function whitelistMint(uint256 _count, bytes32[] memory _proof)
1513         external
1514         payable
1515     {
1516         require(preSaleStarted, "premint not started yet");
1517         require(!paused(), "contract paused");
1518         require(
1519             verifyWhitelist(_leaf(msg.sender), _proof) == true,
1520             "invalid address"
1521         );
1522 
1523         require(
1524             _count > 0 && balanceOfAddress[msg.sender] + _count <= MAX_MINT_PER_PRESALE,
1525             "max mint per trx exceeded"
1526         );
1527         require(totalSupply + _count <= MAX_SUPPLY, "max supply reached");
1528 
1529         if (msg.sender != owner()) {
1530             require(msg.value >= PRE_MINT_PRICE * _count);
1531         }
1532 
1533         for (uint256 i = 1; i <= _count; i++) {
1534             _safeMint(msg.sender, totalSupply + i);
1535         }
1536         totalSupply += _count;
1537         balanceOfAddress[msg.sender] += _count;
1538     }
1539 
1540     
1541     function mint(uint256 _count) public payable {
1542         require(saleStarted, "public mint not started yet");
1543         require(!paused(), "contract paused");
1544         require(
1545             _count > 0 && _count <= MAX_MINT_PER_TX,
1546             "max mint per trx exceeded"
1547         );
1548         require(totalSupply + _count <= MAX_SUPPLY, "max supply reached");
1549 
1550         if (msg.sender != owner()) {
1551             require(msg.value >= MINT_PRICE_PUBLIC * _count);
1552         }
1553 
1554         for (uint256 i = 1; i <= _count; i++) {
1555             _safeMint(msg.sender, totalSupply + i);
1556         }
1557         totalSupply += _count;
1558     }
1559 
1560     
1561     function tokenURI(uint256 tokenId)
1562         public
1563         view
1564         virtual
1565         override
1566         returns (string memory)
1567     {
1568         require(_exists(tokenId), "token not exist");
1569 
1570         string memory currentBaseURI = _baseURI();
1571         if (revealed == false) {
1572 
1573             return notRevealedURI;
1574         }
1575         else {
1576             currentBaseURI = _baseURI();
1577 
1578             return
1579             bytes(currentBaseURI).length > 0
1580                 ? string(
1581                     abi.encodePacked(
1582                         currentBaseURI,
1583                         tokenId.toString(),
1584                         baseExtension
1585                     )
1586                 )
1587                 : "";
1588         }        
1589     }
1590 
1591     function withdraw() external onlyOwner {
1592         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1593         require(os);
1594     }
1595 
1596     function setSaleStarted(bool _hasStarted) external onlyOwner {
1597         require(saleStarted != _hasStarted, "main sale start already");
1598         saleStarted = _hasStarted;
1599     }
1600 
1601 
1602     function setPreSaleStarted(bool _hasStarted) external onlyOwner {
1603         require(preSaleStarted != _hasStarted, "presale started already");
1604         preSaleStarted = _hasStarted;
1605     }
1606 
1607     function setMintPrice(uint256 newMintPrice) public onlyOwner {
1608         MINT_PRICE_PUBLIC = newMintPrice;
1609     }
1610     function setPreMintPrice(uint256 newMintPrice) public onlyOwner {
1611         PRE_MINT_PRICE = newMintPrice;
1612     }
1613 
1614     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1615         baseURI = _newBaseURI;
1616     }
1617 
1618     function reveal() public onlyOwner {
1619         revealed = true;
1620     }
1621 
1622     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1623         notRevealedURI = _notRevealedURI;
1624     }
1625 
1626     function setMerkleRoot(bytes32 _merkleRootValue)
1627         external
1628         onlyOwner
1629         returns (bytes32)
1630     {
1631         _merkleRoot = _merkleRootValue;
1632         return _merkleRoot;
1633     }
1634 
1635     function pause() external onlyOwner {
1636         require(!paused(), "contract already paused");
1637         _pause();
1638     }
1639 
1640     function unpause() external onlyOwner {
1641         require(paused(), "contract already unpaused");
1642         _unpause();
1643     }
1644 }