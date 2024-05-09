1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 pragma solidity ^0.8.0;
5 
6 
7 library Counters {
8     struct Counter {
9         // This variable should never be directly accessed by users of the library: interactions must be restricted to
10         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
11         // this feature: see https://github.com/ethereum/solidity/issues/4637
12         uint256 _value; // default: 0
13     }
14 
15     function current(Counter storage counter) internal view returns (uint256) {
16         return counter._value;
17     }
18 
19     function increment(Counter storage counter) internal {
20         unchecked {
21             counter._value += 1;
22         }
23     }
24 
25     function decrement(Counter storage counter) internal {
26         uint256 value = counter._value;
27         require(value > 0, "Counter: decrement overflow");
28         unchecked {
29             counter._value = value - 1;
30         }
31     }
32 
33     function reset(Counter storage counter) internal {
34         counter._value = 0;
35     }
36 }
37 
38 
39 pragma solidity ^0.8.0;
40 
41 
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 
47     function _msgData() internal view virtual returns (bytes calldata) {
48         return msg.data;
49     }
50 }
51 
52 
53 pragma solidity ^0.8.0;
54 
55 
56 interface IERC165 {
57     
58     function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
60 
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev Required interface of an ERC721 compliant contract.
66  */
67 interface IERC721 is IERC165 {
68     /**
69      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
70      */
71     event Transfer(
72         address indexed from,
73         address indexed to,
74         uint256 indexed tokenId
75     );
76 
77     /**
78      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
79      */
80     event Approval(
81         address indexed owner,
82         address indexed approved,
83         uint256 indexed tokenId
84     );
85 
86     /**
87      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
88      */
89     event ApprovalForAll(
90         address indexed owner,
91         address indexed operator,
92         bool approved
93     );
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
109     
110     function safeTransferFrom(
111         address from,
112         address to,
113         uint256 tokenId
114     ) external;
115 
116    
117     function transferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId)
134         external
135         view
136         returns (address operator);
137 
138     
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator)
147         external
148         view
149         returns (bool);
150 
151    
152     function safeTransferFrom(
153         address from,
154         address to,
155         uint256 tokenId,
156         bytes calldata data
157     ) external;
158 }
159 
160 
161 pragma solidity ^0.8.0;
162 
163 abstract contract Ownable is Context {
164     address private _owner;
165 
166     event OwnershipTransferred(
167         address indexed previousOwner,
168         address indexed newOwner
169     );
170 
171     /**
172      * @dev Initializes the contract setting the deployer as the initial owner.
173      */
174     constructor() {
175         _setOwner(_msgSender());
176     }
177 
178     /**
179      * @dev Returns the address of the current owner.
180      */
181     function owner() public view virtual returns (address) {
182         return _owner;
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
190         _;
191     }
192 
193     
194     function renounceOwnership() public virtual onlyOwner {
195         _setOwner(address(0));
196     }
197 
198     /**
199      * @dev Transfers ownership of the contract to a new account (`newOwner`).
200      * Can only be called by the current owner.
201      */
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(
204             newOwner != address(0),
205             "Ownable: new owner is the zero address"
206         );
207         _setOwner(newOwner);
208     }
209 
210     function _setOwner(address newOwner) private {
211         address oldOwner = _owner;
212         _owner = newOwner;
213         emit OwnershipTransferred(oldOwner, newOwner);
214     }
215 }
216 
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
222  * @dev See https://eips.ethereum.org/EIPS/eip-721
223  */
224 interface IERC721Enumerable is IERC721 {
225     /**
226      * @dev Returns the total amount of tokens stored by the contract.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     /**
231      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
232      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
233      */
234     function tokenOfOwnerByIndex(address owner, uint256 index)
235         external
236         view
237         returns (uint256 tokenId);
238 
239     /**
240      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
241      * Use along with {totalSupply} to enumerate all tokens.
242      */
243     function tokenByIndex(uint256 index) external view returns (uint256);
244 }
245 
246 
247 pragma solidity ^0.8.0;
248 
249 
250 abstract contract ERC165 is IERC165 {
251     /**
252      * @dev See {IERC165-supportsInterface}.
253      */
254     function supportsInterface(bytes4 interfaceId)
255         public
256         view
257         virtual
258         override
259         returns (bool)
260     {
261         return interfaceId == type(IERC165).interfaceId;
262     }
263 }
264 
265 
266 pragma solidity ^0.8.0;
267 
268 /**
269  * @dev String operations.
270  */
271 library Strings {
272     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
276      */
277     function toString(uint256 value) internal pure returns (string memory) {
278         // Inspired by OraclizeAPI's implementation - MIT licence
279         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
280 
281         if (value == 0) {
282             return "0";
283         }
284         uint256 temp = value;
285         uint256 digits;
286         while (temp != 0) {
287             digits++;
288             temp /= 10;
289         }
290         bytes memory buffer = new bytes(digits);
291         while (value != 0) {
292             digits -= 1;
293             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
294             value /= 10;
295         }
296         return string(buffer);
297     }
298 
299     /**
300      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
301      */
302     function toHexString(uint256 value) internal pure returns (string memory) {
303         if (value == 0) {
304             return "0x00";
305         }
306         uint256 temp = value;
307         uint256 length = 0;
308         while (temp != 0) {
309             length++;
310             temp >>= 8;
311         }
312         return toHexString(value, length);
313     }
314 
315     /**
316      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
317      */
318     function toHexString(uint256 value, uint256 length)
319         internal
320         pure
321         returns (string memory)
322     {
323         bytes memory buffer = new bytes(2 * length + 2);
324         buffer[0] = "0";
325         buffer[1] = "x";
326         for (uint256 i = 2 * length + 1; i > 1; --i) {
327             buffer[i] = _HEX_SYMBOLS[value & 0xf];
328             value >>= 4;
329         }
330         require(value == 0, "Strings: hex length insufficient");
331         return string(buffer);
332     }
333 }
334 
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 library Address {
342     
343     function isContract(address account) internal view returns (bool) {
344         // This method relies on extcodesize, which returns 0 for contracts in
345         // construction, since the code is only stored at the end of the
346         // constructor execution.
347 
348         uint256 size;
349         assembly {
350             size := extcodesize(account)
351         }
352         return size > 0;
353     }
354 
355    
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(
358             address(this).balance >= amount,
359             "Address: insufficient balance"
360         );
361 
362         (bool success, ) = recipient.call{value: amount}("");
363         require(
364             success,
365             "Address: unable to send value, recipient may have reverted"
366         );
367     }
368     
369     function functionCall(address target, bytes memory data)
370         internal
371         returns (bytes memory)
372     {
373         return functionCall(target, data, "Address: low-level call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
378      * `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value
395     ) internal returns (bytes memory) {
396         return
397             functionCallWithValue(
398                 target,
399                 data,
400                 value,
401                 "Address: low-level call with value failed"
402             );
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(
412         address target,
413         bytes memory data,
414         uint256 value,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(
418             address(this).balance >= value,
419             "Address: insufficient balance for call"
420         );
421         require(isContract(target), "Address: call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.call{value: value}(
424             data
425         );
426         return _verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(address target, bytes memory data)
436         internal
437         view
438         returns (bytes memory)
439     {
440         return
441             functionStaticCall(
442                 target,
443                 data,
444                 "Address: low-level static call failed"
445             );
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a static call.
451      *
452      * _Available since v3.3._
453      */
454     function functionStaticCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal view returns (bytes memory) {
459         require(isContract(target), "Address: static call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.staticcall(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(address target, bytes memory data)
472         internal
473         returns (bytes memory)
474     {
475         return
476             functionDelegateCall(
477                 target,
478                 data,
479                 "Address: low-level delegate call failed"
480             );
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return _verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     function _verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) private pure returns (bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511 
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
528  * @dev See https://eips.ethereum.org/EIPS/eip-721
529  */
530 interface IERC721Metadata is IERC721 {
531     /**
532      * @dev Returns the token collection name.
533      */
534     function name() external view returns (string memory);
535 
536     /**
537      * @dev Returns the token collection symbol.
538      */
539     function symbol() external view returns (string memory);
540 
541     /**
542      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
543      */
544     function tokenURI(uint256 tokenId) external view returns (string memory);
545 }
546 
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @title ERC721 token receiver interface
552  * @dev Interface for any contract that wants to support safeTransfers
553  * from ERC721 asset contracts.
554  */
555 interface IERC721Receiver {
556     
557     function onERC721Received(
558         address operator,
559         address from,
560         uint256 tokenId,
561         bytes calldata data
562     ) external returns (bytes4);
563 }
564 
565 
566 
567 pragma solidity ^0.8.0;
568 
569 
570 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
571     using Address for address;
572     using Strings for uint256;
573 
574     // Token name
575     string private _name;
576 
577     // Token symbol
578     string private _symbol;
579 
580     // Mapping from token ID to owner address
581     mapping(uint256 => address) private _owners;
582 
583     // Mapping owner address to token count
584     mapping(address => uint256) private _balances;
585 
586     // Mapping from token ID to approved address
587     mapping(uint256 => address) private _tokenApprovals;
588 
589     // Mapping from owner to operator approvals
590     mapping(address => mapping(address => bool)) private _operatorApprovals;
591 
592     /**
593      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
594      */
595     constructor(string memory name_, string memory symbol_) {
596         _name = name_;
597         _symbol = symbol_;
598     }
599 
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId)
604         public
605         view
606         virtual
607         override(ERC165, IERC165)
608         returns (bool)
609     {
610         return
611             interfaceId == type(IERC721).interfaceId ||
612             interfaceId == type(IERC721Metadata).interfaceId ||
613             super.supportsInterface(interfaceId);
614     }
615 
616     /**
617      * @dev See {IERC721-balanceOf}.
618      */
619     function balanceOf(address owner)
620         public
621         view
622         virtual
623         override
624         returns (uint256)
625     {
626         require(
627             owner != address(0),
628             "ERC721: balance query for the zero address"
629         );
630         return _balances[owner];
631     }
632 
633     /**
634      * @dev See {IERC721-ownerOf}.
635      */
636     function ownerOf(uint256 tokenId)
637         public
638         view
639         virtual
640         override
641         returns (address)
642     {
643         address owner = _owners[tokenId];
644         require(
645             owner != address(0),
646             "ERC721: owner query for nonexistent token"
647         );
648         return owner;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-name}.
653      */
654     function name() public view virtual override returns (string memory) {
655         return _name;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-symbol}.
660      */
661     function symbol() public view virtual override returns (string memory) {
662         return _symbol;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-tokenURI}.
667      */
668     function tokenURI(uint256 tokenId)
669         public
670         view
671         virtual
672         override
673         returns (string memory)
674     {
675         require(
676             _exists(tokenId),
677             "ERC721Metadata: URI query for nonexistent token"
678         );
679 
680         string memory baseURI = _baseURI();
681         return
682             bytes(baseURI).length > 0
683                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
684                 : "";
685     }
686 
687     /**
688      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
689      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
690      * by default, can be overriden in child contracts.
691      */
692     function _baseURI() internal view virtual returns (string memory) {
693         return "";
694     }
695 
696     /**
697      * @dev See {IERC721-approve}.
698      */
699     function approve(address to, uint256 tokenId) public virtual override {
700         address owner = ERC721.ownerOf(tokenId);
701         require(to != owner, "ERC721: approval to current owner");
702 
703         require(
704             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
705             "ERC721: approve caller is not owner nor approved for all"
706         );
707 
708         _approve(to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-getApproved}.
713      */
714     function getApproved(uint256 tokenId)
715         public
716         view
717         virtual
718         override
719         returns (address)
720     {
721         require(
722             _exists(tokenId),
723             "ERC721: approved query for nonexistent token"
724         );
725 
726         return _tokenApprovals[tokenId];
727     }
728 
729     /**
730      * @dev See {IERC721-setApprovalForAll}.
731      */
732     function setApprovalForAll(address operator, bool approved)
733         public
734         virtual
735         override
736     {
737         require(operator != _msgSender(), "ERC721: approve to caller");
738 
739         _operatorApprovals[_msgSender()][operator] = approved;
740         emit ApprovalForAll(_msgSender(), operator, approved);
741     }
742 
743     /**
744      * @dev See {IERC721-isApprovedForAll}.
745      */
746     function isApprovedForAll(address owner, address operator)
747         public
748         view
749         virtual
750         override
751         returns (bool)
752     {
753         return _operatorApprovals[owner][operator];
754     }
755 
756     /**
757      * @dev See {IERC721-transferFrom}.
758      */
759     function transferFrom(
760         address from,
761         address to,
762         uint256 tokenId
763     ) public virtual override {
764         //solhint-disable-next-line max-line-length
765         require(
766             _isApprovedOrOwner(_msgSender(), tokenId),
767             "ERC721: transfer caller is not owner nor approved"
768         );
769 
770         _transfer(from, to, tokenId);
771     }
772 
773     /**
774      * @dev See {IERC721-safeTransferFrom}.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) public virtual override {
781         safeTransferFrom(from, to, tokenId, "");
782     }
783 
784     /**
785      * @dev See {IERC721-safeTransferFrom}.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) public virtual override {
793         require(
794             _isApprovedOrOwner(_msgSender(), tokenId),
795             "ERC721: transfer caller is not owner nor approved"
796         );
797         _safeTransfer(from, to, tokenId, _data);
798     }
799 
800     
801     function _safeTransfer(
802         address from,
803         address to,
804         uint256 tokenId,
805         bytes memory _data
806     ) internal virtual {
807         _transfer(from, to, tokenId);
808         require(
809             _checkOnERC721Received(from, to, tokenId, _data),
810             "ERC721: transfer to non ERC721Receiver implementer"
811         );
812     }
813 
814     /**
815      * @dev Returns whether `tokenId` exists.
816      *
817      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
818      *
819      * Tokens start existing when they are minted (`_mint`),
820      * and stop existing when they are burned (`_burn`).
821      */
822     function _exists(uint256 tokenId) internal view virtual returns (bool) {
823         return _owners[tokenId] != address(0);
824     }
825 
826     /**
827      * @dev Returns whether `spender` is allowed to manage `tokenId`.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      */
833     function _isApprovedOrOwner(address spender, uint256 tokenId)
834         internal
835         view
836         virtual
837         returns (bool)
838     {
839         require(
840             _exists(tokenId),
841             "ERC721: operator query for nonexistent token"
842         );
843         address owner = ERC721.ownerOf(tokenId);
844         return (spender == owner ||
845             getApproved(tokenId) == spender ||
846             isApprovedForAll(owner, spender));
847     }
848    
849     function _safeMint(address to, uint256 tokenId) internal virtual {
850         _safeMint(to, tokenId, "");
851     }
852 
853     /**
854      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
855      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
856      */
857     function _safeMint(
858         address to,
859         uint256 tokenId,
860         bytes memory _data
861     ) internal virtual {
862         _mint(to, tokenId);
863         require(
864             _checkOnERC721Received(address(0), to, tokenId, _data),
865             "ERC721: transfer to non ERC721Receiver implementer"
866         );
867     }
868    
869     function _mint(address to, uint256 tokenId) internal virtual {
870         require(to != address(0), "ERC721: mint to the zero address");
871         require(!_exists(tokenId), "ERC721: token already minted");
872 
873         _beforeTokenTransfer(address(0), to, tokenId);
874 
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(address(0), to, tokenId);
879     }
880     
881     function _burn(uint256 tokenId) internal virtual {
882         address owner = ERC721.ownerOf(tokenId);
883 
884         _beforeTokenTransfer(owner, address(0), tokenId);
885 
886         // Clear approvals
887         _approve(address(0), tokenId);
888 
889         _balances[owner] -= 1;
890         delete _owners[tokenId];
891 
892         emit Transfer(owner, address(0), tokenId);
893     }
894    
895     function _transfer(
896         address from,
897         address to,
898         uint256 tokenId
899     ) internal virtual {
900         require(
901             ERC721.ownerOf(tokenId) == from,
902             "ERC721: transfer of token that is not own"
903         );
904         require(to != address(0), "ERC721: transfer to the zero address");
905 
906         _beforeTokenTransfer(from, to, tokenId);
907 
908         // Clear approvals from the previous owner
909         _approve(address(0), tokenId);
910 
911         _balances[from] -= 1;
912         _balances[to] += 1;
913         _owners[tokenId] = to;
914 
915         emit Transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev Approve `to` to operate on `tokenId`
920      *
921      * Emits a {Approval} event.
922      */
923     function _approve(address to, uint256 tokenId) internal virtual {
924         _tokenApprovals[tokenId] = to;
925         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
926     }
927 
928     function _checkOnERC721Received(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) private returns (bool) {
934         if (to.isContract()) {
935             try
936                 IERC721Receiver(to).onERC721Received(
937                     _msgSender(),
938                     from,
939                     tokenId,
940                     _data
941                 )
942             returns (bytes4 retval) {
943                 return retval == IERC721Receiver(to).onERC721Received.selector;
944             } catch (bytes memory reason) {
945                 if (reason.length == 0) {
946                     revert(
947                         "ERC721: transfer to non ERC721Receiver implementer"
948                     );
949                 } else {
950                     assembly {
951                         revert(add(32, reason), mload(reason))
952                     }
953                 }
954             }
955         } else {
956             return true;
957         }
958     }
959    
960     function _beforeTokenTransfer(
961         address from,
962         address to,
963         uint256 tokenId
964     ) internal virtual {}
965 }
966 
967 
968 
969 pragma solidity ^0.8.0;
970 
971 /**
972  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
973  * enumerability of all the token ids in the contract as well as all token ids owned by each
974  * account.
975  */
976 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
977     // Mapping from owner to list of owned token IDs
978     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
979 
980     // Mapping from token ID to index of the owner tokens list
981     mapping(uint256 => uint256) private _ownedTokensIndex;
982 
983     // Array with all token ids, used for enumeration
984     uint256[] private _allTokens;
985 
986     // Mapping from token id to position in the allTokens array
987     mapping(uint256 => uint256) private _allTokensIndex;
988 
989     /**
990      * @dev See {IERC165-supportsInterface}.
991      */
992     function supportsInterface(bytes4 interfaceId)
993         public
994         view
995         virtual
996         override(IERC165, ERC721)
997         returns (bool)
998     {
999         return
1000             interfaceId == type(IERC721Enumerable).interfaceId ||
1001             super.supportsInterface(interfaceId);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1006      */
1007     function tokenOfOwnerByIndex(address owner, uint256 index)
1008         public
1009         view
1010         virtual
1011         override
1012         returns (uint256)
1013     {
1014         require(
1015             index < ERC721.balanceOf(owner),
1016             "ERC721Enumerable: owner index out of bounds"
1017         );
1018         return _ownedTokens[owner][index];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-totalSupply}.
1023      */
1024     function totalSupply() public view virtual override returns (uint256) {
1025         return _allTokens.length;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-tokenByIndex}.
1030      */
1031     function tokenByIndex(uint256 index)
1032         public
1033         view
1034         virtual
1035         override
1036         returns (uint256)
1037     {
1038         require(
1039             index < ERC721Enumerable.totalSupply(),
1040             "ERC721Enumerable: global index out of bounds"
1041         );
1042         return _allTokens[index];
1043     }
1044 
1045     function _beforeTokenTransfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) internal virtual override {
1050         super._beforeTokenTransfer(from, to, tokenId);
1051 
1052         if (from == address(0)) {
1053             _addTokenToAllTokensEnumeration(tokenId);
1054         } else if (from != to) {
1055             _removeTokenFromOwnerEnumeration(from, tokenId);
1056         }
1057         if (to == address(0)) {
1058             _removeTokenFromAllTokensEnumeration(tokenId);
1059         } else if (to != from) {
1060             _addTokenToOwnerEnumeration(to, tokenId);
1061         }
1062     }
1063 
1064     /**
1065      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1066      * @param to address representing the new owner of the given token ID
1067      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1068      */
1069     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1070         uint256 length = ERC721.balanceOf(to);
1071         _ownedTokens[to][length] = tokenId;
1072         _ownedTokensIndex[tokenId] = length;
1073     }
1074 
1075     /**
1076      * @dev Private function to add a token to this extension's token tracking data structures.
1077      * @param tokenId uint256 ID of the token to be added to the tokens list
1078      */
1079     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1080         _allTokensIndex[tokenId] = _allTokens.length;
1081         _allTokens.push(tokenId);
1082     }
1083 
1084     
1085     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1086         private
1087     {
1088         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1089         // then delete the last slot (swap and pop).
1090 
1091         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1092         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1093 
1094         // When the token to delete is the last token, the swap operation is unnecessary
1095         if (tokenIndex != lastTokenIndex) {
1096             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1097 
1098             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1099             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1100         }
1101 
1102         // This also deletes the contents at the last position of the array
1103         delete _ownedTokensIndex[tokenId];
1104         delete _ownedTokens[from][lastTokenIndex];
1105     }
1106 
1107     /**
1108      * @dev Private function to remove a token from this extension's token tracking data structures.
1109      * This has O(1) time complexity, but alters the order of the _allTokens array.
1110      * @param tokenId uint256 ID of the token to be removed from the tokens list
1111      */
1112     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1113         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1114         // then delete the last slot (swap and pop).
1115 
1116         uint256 lastTokenIndex = _allTokens.length - 1;
1117         uint256 tokenIndex = _allTokensIndex[tokenId];
1118         
1119         uint256 lastTokenId = _allTokens[lastTokenIndex];
1120 
1121         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1122         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1123 
1124         // This also deletes the contents at the last position of the array
1125         delete _allTokensIndex[tokenId];
1126         _allTokens.pop();
1127     }
1128 }
1129 
1130 pragma solidity ^0.8.0;
1131 
1132 /**
1133  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1134  *
1135  * These functions can be used to verify that a message was signed by the holder
1136  * of the private keys of a given address.
1137  */
1138 library ECDSA {
1139     enum RecoverError {
1140         NoError,
1141         InvalidSignature,
1142         InvalidSignatureLength,
1143         InvalidSignatureS,
1144         InvalidSignatureV
1145     }
1146 
1147     function _throwError(RecoverError error) private pure {
1148         if (error == RecoverError.NoError) {
1149             return; // no error: do nothing
1150         } else if (error == RecoverError.InvalidSignature) {
1151             revert("ECDSA: invalid signature");
1152         } else if (error == RecoverError.InvalidSignatureLength) {
1153             revert("ECDSA: invalid signature length");
1154         } else if (error == RecoverError.InvalidSignatureS) {
1155             revert("ECDSA: invalid signature 's' value");
1156         } else if (error == RecoverError.InvalidSignatureV) {
1157             revert("ECDSA: invalid signature 'v' value");
1158         }
1159     }
1160 
1161     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1162         // Check the signature length
1163         // - case 65: r,s,v signature (standard)
1164         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1165         if (signature.length == 65) {
1166             bytes32 r;
1167             bytes32 s;
1168             uint8 v;
1169             // ecrecover takes the signature parameters, and the only way to get them
1170             // currently is to use assembly.
1171             assembly {
1172                 r := mload(add(signature, 0x20))
1173                 s := mload(add(signature, 0x40))
1174                 v := byte(0, mload(add(signature, 0x60)))
1175             }
1176             return tryRecover(hash, v, r, s);
1177         } else if (signature.length == 64) {
1178             bytes32 r;
1179             bytes32 vs;
1180             // ecrecover takes the signature parameters, and the only way to get them
1181             // currently is to use assembly.
1182             assembly {
1183                 r := mload(add(signature, 0x20))
1184                 vs := mload(add(signature, 0x40))
1185             }
1186             return tryRecover(hash, r, vs);
1187         } else {
1188             return (address(0), RecoverError.InvalidSignatureLength);
1189         }
1190     }
1191     
1192     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1193         (address recovered, RecoverError error) = tryRecover(hash, signature);
1194         _throwError(error);
1195         return recovered;
1196     }
1197 
1198     /**
1199      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1200      *
1201      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1202      *
1203      * _Available since v4.3._
1204      */
1205     function tryRecover(
1206         bytes32 hash,
1207         bytes32 r,
1208         bytes32 vs
1209     ) internal pure returns (address, RecoverError) {
1210         bytes32 s;
1211         uint8 v;
1212         assembly {
1213             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1214             v := add(shr(255, vs), 27)
1215         }
1216         return tryRecover(hash, v, r, s);
1217     }
1218 
1219     /**
1220      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1221      *
1222      * _Available since v4.2._
1223      */
1224     function recover(
1225         bytes32 hash,
1226         bytes32 r,
1227         bytes32 vs
1228     ) internal pure returns (address) {
1229         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1230         _throwError(error);
1231         return recovered;
1232     }
1233 
1234     /**
1235      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1236      * `r` and `s` signature fields separately.
1237      *
1238      * _Available since v4.3._
1239      */
1240     function tryRecover(
1241         bytes32 hash,
1242         uint8 v,
1243         bytes32 r,
1244         bytes32 s
1245     ) internal pure returns (address, RecoverError) {
1246         
1247         // these malleable signatures as well.
1248         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1249             return (address(0), RecoverError.InvalidSignatureS);
1250         }
1251         if (v != 27 && v != 28) {
1252             return (address(0), RecoverError.InvalidSignatureV);
1253         }
1254 
1255         // If the signature is valid (and not malleable), return the signer address
1256         address signer = ecrecover(hash, v, r, s);
1257         if (signer == address(0)) {
1258             return (address(0), RecoverError.InvalidSignature);
1259         }
1260 
1261         return (signer, RecoverError.NoError);
1262     }
1263 
1264     /**
1265      * @dev Overload of {ECDSA-recover} that receives the `v`,
1266      * `r` and `s` signature fields separately.
1267      */
1268     function recover(
1269         bytes32 hash,
1270         uint8 v,
1271         bytes32 r,
1272         bytes32 s
1273     ) internal pure returns (address) {
1274         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1275         _throwError(error);
1276         return recovered;
1277     }
1278 
1279     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1280         // 32 is the length in bytes of hash,
1281         // enforced by the type signature above
1282         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1283     }
1284 
1285     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1286         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1287     }
1288 }
1289 
1290 pragma solidity ^0.8.4;
1291 
1292 /*
1293   __          __  ________  __    __ __________   ________   ________   __     __ 
1294   \ \        / / | _______| | |  / / \___  ____/ / /    \ \  |      /   \ \   / /
1295    \ \      / /  | |______  | |_/ /     |  |    / /      \ \ |  ___/     \ \ / /
1296     \ \    / /   | |______| | |_ /      |  |    \ \      / / | | \ \      \ \ /
1297      \ \__/ /    | |______  | | \ \     |  |     \ \ ___/ /  | |  \ \     / /\ \
1298       \____/     |________| |_|  \_\    |__|      \______/   |_|   \_\   /_/  \_\
1299 
1300       
1301 */
1302 
1303 
1304 contract VektorX is ERC721Enumerable, Ownable {
1305     using Strings for uint256;
1306     using ECDSA for bytes32;
1307     string baseURI;
1308     uint256 public constant VektorX_PRIVATE = 2500;
1309     uint256 public constant VektorX_MAX =  7500;
1310     uint256 public constant VektorX_PRICE1 = 0.03 ether;
1311     uint256 public constant VektorX_PRICE2 = 0.04 ether;
1312     uint256 public constant VektorX_PRICE_Public = 0.05 ether;
1313     uint256 public constant VektorX_PER_PUBLIC_MINT = 10;
1314     mapping(address => uint256) public presalerListPurchases;    
1315     string private constant Sig_WORD = "private";
1316     address payable commissions = payable(0x748aF6Cbe0DD12148D36DD946d43Ef783a85a73f);
1317     address private _signerAddress = 0x748aF6Cbe0DD12148D36DD946d43Ef783a85a73f;
1318     address private a1 = 0xD7Ac55F70b1077854eE1ff593035146fEC62bDe0;
1319     uint256 public privateAmountMinted;
1320     uint256 public presale1PurchaseLimit = 2;
1321     uint256 public presale2PurchaseLimit = 7;
1322     bool public presaleLive;
1323     bool public saleLive;
1324     bool public locked;
1325 
1326     constructor(
1327         string memory _name,
1328         string memory _symbol,
1329         string memory _initBaseURI
1330     ) ERC721(_name, _symbol) {
1331         setBaseURI(_initBaseURI);        
1332     }
1333 
1334     modifier notLocked {
1335         require(!locked, "Contract metadata methods are locked");
1336         _;
1337     }
1338 
1339     function _baseURI() internal view virtual override returns (string memory) {
1340         return baseURI;
1341     }
1342 
1343     function matchAddresSigner(bytes memory signature) private view returns(bool) {
1344          bytes32 hash = keccak256(abi.encodePacked(
1345             "\x19Ethereum Signed Message:\n32",
1346             keccak256(abi.encodePacked(msg.sender, Sig_WORD)))
1347           );
1348         return _signerAddress == hash.recover(signature);
1349     }
1350 
1351     function founderMint(uint256 tokenQuantity) external onlyOwner {
1352         require(totalSupply() + tokenQuantity <= VektorX_MAX, "EXCEED_MAX");
1353         for(uint256 i = 0; i < tokenQuantity; i++) {
1354             _safeMint(msg.sender, totalSupply() + 1);
1355         }
1356     }
1357 
1358     function gift(address[] calldata receivers) external onlyOwner {
1359         require(totalSupply() + receivers.length <= VektorX_MAX, "EXCEED_MAX");
1360         for (uint256 i = 0; i < receivers.length; i++) {
1361             _safeMint(receivers[i], totalSupply() + 1);
1362         }
1363     }
1364 
1365     function buy(uint256 tokenQuantity) external payable {
1366         require(saleLive, "SALE_CLOSED");
1367         require(!presaleLive, "ONLY_PRESALE");
1368         require(totalSupply() + tokenQuantity <= VektorX_MAX, "EXCEED_MAX");
1369         require(tokenQuantity <= VektorX_PER_PUBLIC_MINT, "EXCEED_VektorX_PER_PUBLIC_MINT");
1370         require(VektorX_PRICE_Public * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1371 
1372         for(uint256 i = 0; i < tokenQuantity; i++) {
1373             _safeMint(msg.sender, totalSupply() + 1);
1374         }
1375 
1376         (bool success, ) = payable(commissions).call{value: msg.value * 10 / 100}("");
1377         require(success);
1378     }
1379 
1380     function presaleBuy(uint256 tokenQuantity) external payable {
1381         require(!saleLive && presaleLive, "PRESALE_CLOSED");
1382         // require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
1383         require(privateAmountMinted + tokenQuantity <= VektorX_MAX, "EXCEED_PRIVATE");
1384         
1385         if ( totalSupply() < 1000 ) {
1386             require(presalerListPurchases[msg.sender] + tokenQuantity <= presale1PurchaseLimit, "EXCEED_ALLOC");
1387             require(VektorX_PRICE1 * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");            
1388         } else {
1389             require(presalerListPurchases[msg.sender] + tokenQuantity <= presale2PurchaseLimit, "EXCEED_ALLOC");
1390             require(VektorX_PRICE2 * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1391         }
1392         
1393         for(uint256 i = 0; i < tokenQuantity; i++) {
1394             privateAmountMinted++;
1395             presalerListPurchases[msg.sender]++;
1396             _safeMint(msg.sender, totalSupply() + 1);
1397         }
1398 
1399         (bool success, ) = payable(commissions).call{value: msg.value * 10 / 100}("");
1400         require(success);
1401     }
1402 
1403     function withdraw() external {
1404         uint256 balance = address(this).balance;
1405         require(balance > 0);
1406         payable(a1).transfer(address(this).balance);
1407     }
1408     
1409     function Initialreveal(uint256 _mintAmount) public onlyOwner() {
1410         uint256 supply = totalSupply();
1411         
1412         for (uint256 i = 1; i <= _mintAmount; i++) {            
1413             _safeMint(msg.sender, supply + i);
1414         }
1415     }
1416 
1417     function presalePurchasedCount(address addr) external view returns (uint256) {
1418         return presalerListPurchases[addr];
1419     }
1420 
1421     function lockMetadata() external onlyOwner {
1422         locked = true;
1423     }
1424 
1425     function togglePresaleStatus() external onlyOwner {
1426         presaleLive = !presaleLive;
1427     }
1428 
1429     function toggleSaleStatus() external onlyOwner {
1430         saleLive = !saleLive;
1431     }
1432 
1433     function setSignerAddress(address addr) external onlyOwner {
1434         _signerAddress = addr;
1435     }
1436 
1437     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1438         baseURI = _newBaseURI;
1439     }
1440 
1441     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1442         require(_exists(tokenId), "Cannot query non-existent token");
1443 
1444         string memory currentBaseURI = _baseURI();
1445         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString())): "";        
1446     }
1447 }