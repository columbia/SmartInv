1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 /*      
5 
6 #######                  #     #                             
7 #       #      ######    #  #  #  ####  #####  #      #####  
8 #       #      #         #  #  # #    # #    # #      #    # 
9 #####   #      #####     #  #  # #    # #    # #      #    # 
10 #       #      #         #  #  # #    # #####  #      #    # 
11 #       #      #         #  #  # #    # #   #  #      #    # 
12 ####### ###### #          ## ##   ####  #    # ###### #####  
13  
14                                                                      */
15 
16 
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
19 
20 pragma solidity >=0.7.0 <0.9.0;
21 
22 library Counters {
23     struct Counter {
24 
25         uint256 _value; // default: 0
26     }
27 
28     function current(Counter storage counter) internal view returns (uint256) {
29         return counter._value;
30     }
31 
32     function increment(Counter storage counter) internal {
33         unchecked {
34             counter._value += 1;
35         }
36     }
37 
38     function decrement(Counter storage counter) internal {
39         uint256 value = counter._value;
40         require(value > 0, "Counter: decrement overflow");
41         unchecked {
42             counter._value = value - 1;
43         }
44     }
45 
46     function reset(Counter storage counter) internal {
47         counter._value = 0;
48     }
49 }
50 
51 
52 pragma solidity >=0.7.0 <0.9.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64 
65 
66         if (value == 0) {
67             return "0";
68         }
69         uint256 temp = value;
70         uint256 digits;
71         while (temp != 0) {
72             digits++;
73             temp /= 10;
74         }
75         bytes memory buffer = new bytes(digits);
76         while (value != 0) {
77             digits -= 1;
78             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
79             value /= 10;
80         }
81         return string(buffer);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
86      */
87     function toHexString(uint256 value) internal pure returns (string memory) {
88         if (value == 0) {
89             return "0x00";
90         }
91         uint256 temp = value;
92         uint256 length = 0;
93         while (temp != 0) {
94             length++;
95             temp >>= 8;
96         }
97         return toHexString(value, length);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
102      */
103     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
104         bytes memory buffer = new bytes(2 * length + 2);
105         buffer[0] = "0";
106         buffer[1] = "x";
107         for (uint256 i = 2 * length + 1; i > 1; --i) {
108             buffer[i] = _HEX_SYMBOLS[value & 0xf];
109             value >>= 4;
110         }
111         require(value == 0, "Strings: hex length insufficient");
112         return string(buffer);
113     }
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity >=0.7.0 <0.9.0;
122 
123 abstract contract Context {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes calldata) {
129         return msg.data;
130     }
131 }
132 
133 // File: @openzeppelin/contracts/access/Ownable.sol
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
137 
138 pragma solidity >=0.7.0 <0.9.0;
139 
140 
141 abstract contract Ownable is Context {
142     address private _owner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     /**
147      * @dev Initializes the contract setting the deployer as the initial owner.
148      */
149     constructor() {
150         _transferOwnership(_msgSender());
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view virtual returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(owner() == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     function renounceOwnership() public virtual onlyOwner {
169         _transferOwnership(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _transferOwnership(newOwner);
179     }
180 
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 // File: @openzeppelin/contracts/utils/Address.sol
189 
190 
191 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
192 
193 pragma solidity >=0.7.0 <0.9.0;
194 
195 /**
196  * @dev Collection of functions related to the address type
197  */
198 library Address {
199 
200     function isContract(address account) internal view returns (bool) {
201 
202 
203         uint256 size;
204         assembly {
205             size := extcodesize(account)
206         }
207         return size > 0;
208     }
209 
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         (bool success, ) = recipient.call{value: amount}("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217 
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionCall(target, data, "Address: low-level call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
224      * `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236 
237     function functionCallWithValue(
238         address target,
239         bytes memory data,
240         uint256 value
241     ) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
243     }
244 
245     function functionCallWithValue(
246         address target,
247         bytes memory data,
248         uint256 value,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         require(address(this).balance >= value, "Address: insufficient balance for call");
252         require(isContract(target), "Address: call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.call{value: value}(data);
255         return verifyCallResult(success, returndata, errorMessage);
256     }
257 
258 
259     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
260         return functionStaticCall(target, data, "Address: low-level static call failed");
261     }
262 
263  
264     function functionStaticCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal view returns (bytes memory) {
269         require(isContract(target), "Address: static call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.staticcall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275 
276     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
278     }
279 
280   
281     function functionDelegateCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         require(isContract(target), "Address: delegate call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.delegatecall(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292  
293     function verifyCallResult(
294         bool success,
295         bytes memory returndata,
296         string memory errorMessage
297     ) internal pure returns (bytes memory) {
298         if (success) {
299             return returndata;
300         } else {
301             // Look for revert reason and bubble it up if present
302             if (returndata.length > 0) {
303                 // The easiest way to bubble the revert reason is using memory via assembly
304 
305                 assembly {
306                     let returndata_size := mload(returndata)
307                     revert(add(32, returndata), returndata_size)
308                 }
309             } else {
310                 revert(errorMessage);
311             }
312         }
313     }
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
320 
321 pragma solidity >=0.7.0 <0.9.0;
322 
323 interface IERC721Receiver {
324 
325     function onERC721Received(
326         address operator,
327         address from,
328         uint256 tokenId,
329         bytes calldata data
330     ) external returns (bytes4);
331 }
332 
333 
334 
335 pragma solidity >=0.7.0 <0.9.0;
336 
337 
338 interface IERC165 {
339 
340     function supportsInterface(bytes4 interfaceId) external view returns (bool);
341 }
342 
343 
344 pragma solidity >=0.7.0 <0.9.0;
345 
346 
347 abstract contract ERC165 is IERC165 {
348     /**
349      * @dev See {IERC165-supportsInterface}.
350      */
351     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
352         return interfaceId == type(IERC165).interfaceId;
353     }
354 }
355 
356 
357 
358 pragma solidity >=0.7.0 <0.9.0;
359 
360 
361 /**
362  * @dev Required interface of an ERC721 compliant contract.
363  */
364 interface IERC721 is IERC165 {
365     /**
366      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
367      */
368     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
369 
370     /**
371      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
372      */
373     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
374 
375     /**
376      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
377      */
378     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
379 
380     /**
381      * @dev Returns the number of tokens in ``owner``'s account.
382      */
383     function balanceOf(address owner) external view returns (uint256 balance);
384 
385     function ownerOf(uint256 tokenId) external view returns (address owner);
386 
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) external;
392 
393 
394     function transferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) external;
399 
400 
401     function approve(address to, uint256 tokenId) external;
402 
403 
404     function getApproved(uint256 tokenId) external view returns (address operator);
405 
406     function setApprovalForAll(address operator, bool _approved) external;
407 
408     function isApprovedForAll(address owner, address operator) external view returns (bool);
409 
410     
411     function safeTransferFrom(
412         address from,
413         address to,
414         uint256 tokenId,
415         bytes calldata data
416     ) external;
417 }
418 
419 
420 
421 pragma solidity >=0.7.0 <0.9.0;
422 
423 
424 
425 interface IERC721Metadata is IERC721 {
426     /**
427      * @dev Returns the token collection name.
428      */
429     function name() external view returns (string memory);
430 
431     /**
432      * @dev Returns the token collection symbol.
433      */
434     function symbol() external view returns (string memory);
435 
436     /**
437      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
438      */
439     function tokenURI(uint256 tokenId) external view returns (string memory);
440 }
441 
442 
443 pragma solidity >=0.7.0 <0.9.0;
444 
445 
446 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
447     using Address for address;
448     using Strings for uint256;
449 
450     // Token name
451     string private _name;
452 
453     // Token symbol
454     string private _symbol;
455 
456     // Mapping from token ID to owner address
457     mapping(uint256 => address) private _owners;
458 
459     // Mapping owner address to token count
460     mapping(address => uint256) private _balances;
461 
462     // Mapping from token ID to approved address
463     mapping(uint256 => address) private _tokenApprovals;
464 
465     // Mapping from owner to operator approvals
466     mapping(address => mapping(address => bool)) private _operatorApprovals;
467 
468     /**
469      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
470      */
471     constructor(string memory name_, string memory symbol_) {
472         _name = name_;
473         _symbol = symbol_;
474     }
475 
476     /**
477      * @dev See {IERC165-supportsInterface}.
478      */
479     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
480         return
481             interfaceId == type(IERC721).interfaceId ||
482             interfaceId == type(IERC721Metadata).interfaceId ||
483             super.supportsInterface(interfaceId);
484     }
485 
486     /**
487      * @dev See {IERC721-balanceOf}.
488      */
489     function balanceOf(address owner) public view virtual override returns (uint256) {
490         require(owner != address(0), "ERC721: balance query for the zero address");
491         return _balances[owner];
492     }
493 
494     /**
495      * @dev See {IERC721-ownerOf}.
496      */
497     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
498         address owner = _owners[tokenId];
499         require(owner != address(0), "ERC721: owner query for nonexistent token");
500         return owner;
501     }
502 
503     /**
504      * @dev See {IERC721Metadata-name}.
505      */
506     function name() public view virtual override returns (string memory) {
507         return _name;
508     }
509 
510     /**
511      * @dev See {IERC721Metadata-symbol}.
512      */
513     function symbol() public view virtual override returns (string memory) {
514         return _symbol;
515     }
516 
517     /**
518      * @dev See {IERC721Metadata-tokenURI}.
519      */
520     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
521         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
522 
523         string memory baseURI = _baseURI();
524         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
525     }
526 
527 
528     function _baseURI() internal view virtual returns (string memory) {
529         return "";
530     }
531 
532     /**
533      * @dev See {IERC721-approve}.
534      */
535     function approve(address to, uint256 tokenId) public virtual override {
536         address owner = ERC721.ownerOf(tokenId);
537         require(to != owner, "ERC721: approval to current owner");
538 
539         require(
540             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
541             "ERC721: approve caller is not owner nor approved for all"
542         );
543 
544         _approve(to, tokenId);
545     }
546 
547     /**
548      * @dev See {IERC721-getApproved}.
549      */
550     function getApproved(uint256 tokenId) public view virtual override returns (address) {
551         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
552 
553         return _tokenApprovals[tokenId];
554     }
555 
556     /**
557      * @dev See {IERC721-setApprovalForAll}.
558      */
559     function setApprovalForAll(address operator, bool approved) public virtual override {
560         _setApprovalForAll(_msgSender(), operator, approved);
561     }
562 
563     /**
564      * @dev See {IERC721-isApprovedForAll}.
565      */
566     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
567         return _operatorApprovals[owner][operator];
568     }
569 
570     /**
571      * @dev See {IERC721-transferFrom}.
572      */
573     function transferFrom(
574         address from,
575         address to,
576         uint256 tokenId
577     ) public virtual override {
578         //solhint-disable-next-line max-line-length
579         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
580 
581         _transfer(from, to, tokenId);
582     }
583 
584     /**
585      * @dev See {IERC721-safeTransferFrom}.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) public virtual override {
592         safeTransferFrom(from, to, tokenId, "");
593     }
594 
595     /**
596      * @dev See {IERC721-safeTransferFrom}.
597      */
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId,
602         bytes memory _data
603     ) public virtual override {
604         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
605         _safeTransfer(from, to, tokenId, _data);
606     }
607 
608 
609     function _safeTransfer(
610         address from,
611         address to,
612         uint256 tokenId,
613         bytes memory _data
614     ) internal virtual {
615         _transfer(from, to, tokenId);
616         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
617     }
618 
619 
620     function _exists(uint256 tokenId) internal view virtual returns (bool) {
621         return _owners[tokenId] != address(0);
622     }
623 
624 
625     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
626         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
627         address owner = ERC721.ownerOf(tokenId);
628         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
629     }
630 
631 
632     function _safeMint(address to, uint256 tokenId) internal virtual {
633         _safeMint(to, tokenId, "");
634     }
635 
636   
637     function _safeMint(
638         address to,
639         uint256 tokenId,
640         bytes memory _data
641     ) internal virtual {
642         _mint(to, tokenId);
643         require(
644             _checkOnERC721Received(address(0), to, tokenId, _data),
645             "ERC721: transfer to non ERC721Receiver implementer"
646         );
647     }
648 
649 
650     function _mint(address to, uint256 tokenId) internal virtual {
651         require(to != address(0), "ERC721: mint to the zero address");
652         require(!_exists(tokenId), "ERC721: token already minted");
653 
654         _beforeTokenTransfer(address(0), to, tokenId);
655 
656         _balances[to] += 1;
657         _owners[tokenId] = to;
658 
659         emit Transfer(address(0), to, tokenId);
660     }
661 
662     function _burn(uint256 tokenId) internal virtual {
663         address owner = ERC721.ownerOf(tokenId);
664 
665         _beforeTokenTransfer(owner, address(0), tokenId);
666 
667         // Clear approvals
668         _approve(address(0), tokenId);
669 
670         _balances[owner] -= 1;
671         delete _owners[tokenId];
672 
673         emit Transfer(owner, address(0), tokenId);
674     }
675 
676 
677     function _transfer(
678         address from,
679         address to,
680         uint256 tokenId
681     ) internal virtual {
682         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
683         require(to != address(0), "ERC721: transfer to the zero address");
684 
685         _beforeTokenTransfer(from, to, tokenId);
686 
687         // Clear approvals from the previous owner
688         _approve(address(0), tokenId);
689 
690         _balances[from] -= 1;
691         _balances[to] += 1;
692         _owners[tokenId] = to;
693 
694         emit Transfer(from, to, tokenId);
695     }
696 
697 
698     function _approve(address to, uint256 tokenId) internal virtual {
699         _tokenApprovals[tokenId] = to;
700         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
701     }
702 
703 
704     function _setApprovalForAll(
705         address owner,
706         address operator,
707         bool approved
708     ) internal virtual {
709         require(owner != operator, "ERC721: approve to caller");
710         _operatorApprovals[owner][operator] = approved;
711         emit ApprovalForAll(owner, operator, approved);
712     }
713 
714 
715     function _checkOnERC721Received(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes memory _data
720     ) private returns (bool) {
721         if (to.isContract()) {
722             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
723                 return retval == IERC721Receiver.onERC721Received.selector;
724             } catch (bytes memory reason) {
725                 if (reason.length == 0) {
726                     revert("ERC721: transfer to non ERC721Receiver implementer");
727                 } else {
728                     assembly {
729                         revert(add(32, reason), mload(reason))
730                     }
731                 }
732             }
733         } else {
734             return true;
735         }
736     }
737 
738 
739     function _beforeTokenTransfer(
740         address from,
741         address to,
742         uint256 tokenId
743     ) internal virtual {}
744 }
745 
746 
747 
748 pragma solidity >=0.7.0 <0.9.0;
749 
750 
751 library MerkleProof {
752 
753     function verify(
754         bytes32[] memory proof,
755         bytes32 root,
756         bytes32 leaf
757     ) internal pure returns (bool) {
758         return processProof(proof, leaf) == root;
759     }
760 
761 
762     function verifyCalldata(
763         bytes32[] calldata proof,
764         bytes32 root,
765         bytes32 leaf
766     ) internal pure returns (bool) {
767         return processProofCalldata(proof, leaf) == root;
768     }
769 
770 
771     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
772         bytes32 computedHash = leaf;
773         for (uint256 i = 0; i < proof.length; i++) {
774             computedHash = _hashPair(computedHash, proof[i]);
775         }
776         return computedHash;
777     }
778 
779 
780     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
781         bytes32 computedHash = leaf;
782         for (uint256 i = 0; i < proof.length; i++) {
783             computedHash = _hashPair(computedHash, proof[i]);
784         }
785         return computedHash;
786     }
787 
788     function multiProofVerify(
789         bytes32[] memory proof,
790         bool[] memory proofFlags,
791         bytes32 root,
792         bytes32[] memory leaves
793     ) internal pure returns (bool) {
794         return processMultiProof(proof, proofFlags, leaves) == root;
795     }
796 
797     function multiProofVerifyCalldata(
798         bytes32[] calldata proof,
799         bool[] calldata proofFlags,
800         bytes32 root,
801         bytes32[] memory leaves
802     ) internal pure returns (bool) {
803         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
804     }
805 
806     function processMultiProof(
807         bytes32[] memory proof,
808         bool[] memory proofFlags,
809         bytes32[] memory leaves
810     ) internal pure returns (bytes32 merkleRoot) {
811 
812         uint256 leavesLen = leaves.length;
813         uint256 totalHashes = proofFlags.length;
814 
815         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
816 
817 
818         bytes32[] memory hashes = new bytes32[](totalHashes);
819         uint256 leafPos = 0;
820         uint256 hashPos = 0;
821         uint256 proofPos = 0;
822 
823         for (uint256 i = 0; i < totalHashes; i++) {
824             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
825             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
826             hashes[i] = _hashPair(a, b);
827         }
828 
829         if (totalHashes > 0) {
830             return hashes[totalHashes - 1];
831         } else if (leavesLen > 0) {
832             return leaves[0];
833         } else {
834             return proof[0];
835         }
836     }
837 
838 
839     function processMultiProofCalldata(
840         bytes32[] calldata proof,
841         bool[] calldata proofFlags,
842         bytes32[] memory leaves
843     ) internal pure returns (bytes32 merkleRoot) {
844 
845         uint256 leavesLen = leaves.length;
846         uint256 totalHashes = proofFlags.length;
847 
848         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
849 
850         bytes32[] memory hashes = new bytes32[](totalHashes);
851         uint256 leafPos = 0;
852         uint256 hashPos = 0;
853         uint256 proofPos = 0;
854 
855         for (uint256 i = 0; i < totalHashes; i++) {
856             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
857             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
858             hashes[i] = _hashPair(a, b);
859         }
860 
861         if (totalHashes > 0) {
862             return hashes[totalHashes - 1];
863         } else if (leavesLen > 0) {
864             return leaves[0];
865         } else {
866             return proof[0];
867         }
868     }
869 
870     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
871         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
872     }
873 
874     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
875         assembly {
876             mstore(0x00, a)
877             mstore(0x20, b)
878             value := keccak256(0x00, 0x40)
879         }
880     }
881 }
882 
883 // File: contracts/Elf_World.sol
884 
885 
886 
887 pragma solidity >=0.7.0 <0.9.0;
888 
889 contract Elf_World is ERC721, Ownable {
890   using Strings for uint256;
891   using Counters for Counters.Counter;
892 
893   Counters.Counter private supply;
894 
895   string public uriPrefix = "";
896   string public uriSuffix = ".json";
897   string public hiddenMetadataUri;
898   
899   uint256 public cost = 0 ether;
900   uint256 public maxSupply = 5555;
901 
902   uint256 public maxMintAmountPerTx = 3;
903   uint256 public nftPerAddressLimit = 3;
904 
905 
906   bool public paused = false;
907   bool public revealed = false;
908   bool public Presale = true;
909 
910   mapping(address => uint256) public addressMintedBalance;
911 
912     bytes32 public whitelistMerkleRoot;
913 
914 
915   constructor() ERC721("Elf World", "Elf") {
916     setHiddenMetadataUri("ipfs://QmTcQfEYSWK4S9pEx9ZDg5us8LJFXsGQbnLF32c6ce5mRJ/hidden.json");
917   }
918 
919   modifier mintCompliance(uint256 _mintAmount) {
920     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
921     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
922     _;
923   }
924 
925   modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
926         require( MerkleProof.verify( merkleProof, root, keccak256(abi.encodePacked(msg.sender))), "Address does not exist in list"); _;
927     }
928 
929   function totalSupply() public view returns (uint256) {
930     return supply.current();
931   }
932 
933   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
934     require(!paused, "The contract is paused!");
935     require(!Presale, "Public Mint is not open!");
936     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
937 
938     _mintLoop(msg.sender, _mintAmount);
939   }
940   
941   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
942     _mintLoop2(_receiver, _mintAmount);
943   }
944 
945 
946     function mintWhitelist(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount)
947     {
948     require(!paused, "The contract is paused!");
949     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
950     require(MerkleProof.verify(_merkleProof, whitelistMerkleRoot, leaf), "Invalid proof.");
951     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
952     _mintLoop(msg.sender, _mintAmount);
953 
954     }
955 
956     function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
957         whitelistMerkleRoot = merkleRoot;
958     }
959 
960 
961   function walletOfOwner(address _owner)
962     public
963     view
964     returns (uint256[] memory)
965   {
966     uint256 ownerTokenCount = balanceOf(_owner);
967     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
968     uint256 currentTokenId = 1;
969     uint256 ownedTokenIndex = 0;
970 
971     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
972       address currentTokenOwner = ownerOf(currentTokenId);
973 
974       if (currentTokenOwner == _owner) {
975         ownedTokenIds[ownedTokenIndex] = currentTokenId;
976 
977         ownedTokenIndex++;
978       }
979 
980       currentTokenId++;
981     }
982 
983     return ownedTokenIds;
984   }
985 
986   function tokenURI(uint256 _tokenId)
987     public
988     view
989     virtual
990     override
991     returns (string memory)
992   {
993     require(
994       _exists(_tokenId),
995       "ERC721Metadata: URI query for nonexistent token"
996     );
997 
998     if (revealed == false) {
999       return hiddenMetadataUri;
1000     }
1001 
1002     string memory currentBaseURI = _baseURI();
1003     return bytes(currentBaseURI).length > 0
1004         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1005         : "";
1006   }
1007 
1008   function setRevealed(bool _state) public onlyOwner {
1009     revealed = _state;
1010   }
1011 
1012   function setCost(uint256 _cost) public onlyOwner {
1013     cost = _cost;
1014   }
1015 
1016   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1017     maxMintAmountPerTx = _maxMintAmountPerTx;
1018   }
1019 
1020   function setnftPerAddressLimit(uint256 _nftPerAddressLimit) public onlyOwner {
1021     nftPerAddressLimit = _nftPerAddressLimit;
1022   }
1023 
1024   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1025     maxSupply = _maxSupply;
1026   }
1027 
1028   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1029     hiddenMetadataUri = _hiddenMetadataUri;
1030   }
1031 
1032   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1033     uriPrefix = _uriPrefix;
1034   }
1035 
1036   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1037     uriSuffix = _uriSuffix;
1038   }
1039 
1040   function setPaused(bool _state) public onlyOwner {
1041     paused = _state;
1042   }
1043 
1044   function setPresale(bool _statePresale) public onlyOwner {
1045     Presale = _statePresale;
1046   }
1047 
1048   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1049 
1050     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1051     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1052     
1053     for (uint256 i = 0; i < _mintAmount; i++) {
1054       supply.increment();
1055       addressMintedBalance[msg.sender]++;
1056       _safeMint(_receiver, supply.current());
1057     }
1058   }
1059 
1060   function _mintLoop2(address _receiver, uint256 _mintAmount) internal {
1061     for (uint256 i = 0; i < _mintAmount; i++) {
1062       supply.increment();
1063       _safeMint(_receiver, supply.current());
1064     }
1065   }
1066 
1067   function _baseURI() internal view virtual override returns (string memory) {
1068     return uriPrefix;
1069   }
1070 
1071   function withdraw() public onlyOwner {
1072     // =============================================================================
1073     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1074     require(os);
1075     // =============================================================================
1076   }
1077   
1078 }