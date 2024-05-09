1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 library Counters {
10     struct Counter {
11         uint256 _value;
12     }
13 
14     function current(Counter storage counter) internal view returns (uint256) {
15         return counter._value;
16     }
17 
18     function increment(Counter storage counter) internal {
19         unchecked {
20             counter._value += 1;
21         }
22     }
23 
24     function decrement(Counter storage counter) internal {
25         uint256 value = counter._value;
26         require(value > 0, "Counter: decrement overflow");
27         unchecked {
28             counter._value = value - 1;
29         }
30     }
31 
32     function reset(Counter storage counter) internal {
33         counter._value = 0;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/utils/Strings.sol
38 
39 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 library Strings {
44     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
45 
46     function toString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     function toHexString(uint256 value, uint256 length)
79         internal
80         pure
81         returns (string memory)
82     {
83         bytes memory buffer = new bytes(2 * length + 2);
84         buffer[0] = "0";
85         buffer[1] = "x";
86         for (uint256 i = 2 * length + 1; i > 1; --i) {
87             buffer[i] = _HEX_SYMBOLS[value & 0xf];
88             value >>= 4;
89         }
90         require(value == 0, "Strings: hex length insufficient");
91         return string(buffer);
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Context.sol
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/access/Ownable.sol
112 
113 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(
121         address indexed previousOwner,
122         address indexed newOwner
123     );
124 
125     constructor() {
126         _transferOwnership(_msgSender());
127     }
128 
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     modifier onlyOwner() {
134         require(owner() == _msgSender(), "Ownable: caller is not the owner");
135         _;
136     }
137 
138     function renounceOwnership() public virtual onlyOwner {
139         _transferOwnership(address(0));
140     }
141 
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(
144             newOwner != address(0),
145             "Ownable: new owner is the zero address"
146         );
147         _transferOwnership(newOwner);
148     }
149 
150     function _transferOwnership(address newOwner) internal virtual {
151         address oldOwner = _owner;
152         _owner = newOwner;
153         emit OwnershipTransferred(oldOwner, newOwner);
154     }
155 }
156 
157 // File: @openzeppelin/contracts/utils/Address.sol
158 
159 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 library Address {
164     function isContract(address account) internal view returns (bool) {
165         uint256 size;
166         assembly {
167             size := extcodesize(account)
168         }
169         return size > 0;
170     }
171 
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(
174             address(this).balance >= amount,
175             "Address: insufficient balance"
176         );
177 
178         (bool success, ) = recipient.call{value: amount}("");
179         require(
180             success,
181             "Address: unable to send value, recipient may have reverted"
182         );
183     }
184 
185     function functionCall(address target, bytes memory data)
186         internal
187         returns (bytes memory)
188     {
189         return functionCall(target, data, "Address: low-level call failed");
190     }
191 
192     function functionCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, 0, errorMessage);
198     }
199 
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value
204     ) internal returns (bytes memory) {
205         return
206             functionCallWithValue(
207                 target,
208                 data,
209                 value,
210                 "Address: low-level call with value failed"
211             );
212     }
213 
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(
221             address(this).balance >= value,
222             "Address: insufficient balance for call"
223         );
224         require(isContract(target), "Address: call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.call{value: value}(
227             data
228         );
229         return verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     function functionStaticCall(address target, bytes memory data)
233         internal
234         view
235         returns (bytes memory)
236     {
237         return
238             functionStaticCall(
239                 target,
240                 data,
241                 "Address: low-level static call failed"
242             );
243     }
244 
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     function functionDelegateCall(address target, bytes memory data)
257         internal
258         returns (bytes memory)
259     {
260         return
261             functionDelegateCall(
262                 target,
263                 data,
264                 "Address: low-level delegate call failed"
265             );
266     }
267 
268     function functionDelegateCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(isContract(target), "Address: delegate call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.delegatecall(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     function verifyCallResult(
280         bool success,
281         bytes memory returndata,
282         string memory errorMessage
283     ) internal pure returns (bytes memory) {
284         if (success) {
285             return returndata;
286         } else {
287             if (returndata.length > 0) {
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
300 
301 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 library MerkleProof {
306     /**
307      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
308      * defined by `root`. For this, a `proof` must be provided, containing
309      * sibling hashes on the branch from the leaf to the root of the tree. Each
310      * pair of leaves and each pair of pre-images are assumed to be sorted.
311      */
312     function verify(
313         bytes32[] memory proof,
314         bytes32 root,
315         bytes32 leaf
316     ) internal pure returns (bool) {
317         return processProof(proof, leaf) == root;
318     }
319 
320     /**
321      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
322      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
323      * hash matches the root of the tree. When processing the proof, the pairs
324      * of leafs & pre-images are assumed to be sorted.
325      *
326      * _Available since v4.4._
327      */
328     function processProof(bytes32[] memory proof, bytes32 leaf)
329         internal
330         pure
331         returns (bytes32)
332     {
333         bytes32 computedHash = leaf;
334         for (uint256 i = 0; i < proof.length; i++) {
335             bytes32 proofElement = proof[i];
336             if (computedHash <= proofElement) {
337                 // Hash(current computed hash + current element of the proof)
338                 computedHash = _efficientHash(computedHash, proofElement);
339             } else {
340                 // Hash(current element of the proof + current computed hash)
341                 computedHash = _efficientHash(proofElement, computedHash);
342             }
343         }
344         return computedHash;
345     }
346 
347     function _efficientHash(bytes32 a, bytes32 b)
348         private
349         pure
350         returns (bytes32 value)
351     {
352         assembly {
353             mstore(0x00, a)
354             mstore(0x20, b)
355             value := keccak256(0x00, 0x40)
356         }
357     }
358 }
359 
360 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
361 
362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 interface IERC721Receiver {
367     function onERC721Received(
368         address operator,
369         address from,
370         uint256 tokenId,
371         bytes calldata data
372     ) external returns (bytes4);
373 }
374 
375 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
376 
377 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 interface IERC165 {
382     function supportsInterface(bytes4 interfaceId) external view returns (bool);
383 }
384 
385 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
386 
387 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 abstract contract ERC165 is IERC165 {
392     function supportsInterface(bytes4 interfaceId)
393         public
394         view
395         virtual
396         override
397         returns (bool)
398     {
399         return interfaceId == type(IERC165).interfaceId;
400     }
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
404 
405 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 interface IERC721 is IERC165 {
410     event Transfer(
411         address indexed from,
412         address indexed to,
413         uint256 indexed tokenId
414     );
415 
416     event Approval(
417         address indexed owner,
418         address indexed approved,
419         uint256 indexed tokenId
420     );
421 
422     event ApprovalForAll(
423         address indexed owner,
424         address indexed operator,
425         bool approved
426     );
427 
428     function balanceOf(address owner) external view returns (uint256 balance);
429 
430     function ownerOf(uint256 tokenId) external view returns (address owner);
431 
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 tokenId
436     ) external;
437 
438     function transferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) external;
443 
444     function approve(address to, uint256 tokenId) external;
445 
446     function getApproved(uint256 tokenId)
447         external
448         view
449         returns (address operator);
450 
451     function setApprovalForAll(address operator, bool _approved) external;
452 
453     function isApprovedForAll(address owner, address operator)
454         external
455         view
456         returns (bool);
457 
458     function safeTransferFrom(
459         address from,
460         address to,
461         uint256 tokenId,
462         bytes calldata data
463     ) external;
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
467 
468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
474  */
475 interface IERC721Metadata is IERC721 {
476     function name() external view returns (string memory);
477 
478     function symbol() external view returns (string memory);
479 
480     function tokenURI(uint256 tokenId) external view returns (string memory);
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
484 
485 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
490     using Address for address;
491     using Strings for uint256;
492 
493     string private _name;
494 
495     string private _symbol;
496 
497     mapping(uint256 => address) private _owners;
498 
499     mapping(address => uint256) private _balances;
500 
501     mapping(uint256 => address) private _tokenApprovals;
502 
503     mapping(address => mapping(address => bool)) private _operatorApprovals;
504 
505     constructor(string memory name_, string memory symbol_) {
506         _name = name_;
507         _symbol = symbol_;
508     }
509 
510     function supportsInterface(bytes4 interfaceId)
511         public
512         view
513         virtual
514         override(ERC165, IERC165)
515         returns (bool)
516     {
517         return
518             interfaceId == type(IERC721).interfaceId ||
519             interfaceId == type(IERC721Metadata).interfaceId ||
520             super.supportsInterface(interfaceId);
521     }
522 
523     function balanceOf(address owner)
524         public
525         view
526         virtual
527         override
528         returns (uint256)
529     {
530         require(
531             owner != address(0),
532             "ERC721: balance query for the zero address"
533         );
534         return _balances[owner];
535     }
536 
537     function ownerOf(uint256 tokenId)
538         public
539         view
540         virtual
541         override
542         returns (address)
543     {
544         address owner = _owners[tokenId];
545         require(
546             owner != address(0),
547             "ERC721: owner query for nonexistent token"
548         );
549         return owner;
550     }
551 
552     function name() public view virtual override returns (string memory) {
553         return _name;
554     }
555 
556     function symbol() public view virtual override returns (string memory) {
557         return _symbol;
558     }
559 
560     function tokenURI(uint256 tokenId)
561         public
562         view
563         virtual
564         override
565         returns (string memory)
566     {
567         require(
568             _exists(tokenId),
569             "ERC721Metadata: URI query for nonexistent token"
570         );
571 
572         string memory baseURI = _baseURI();
573         return
574             bytes(baseURI).length > 0
575                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
576                 : "";
577     }
578 
579     function _baseURI() internal view virtual returns (string memory) {
580         return "";
581     }
582 
583     function approve(address to, uint256 tokenId) public virtual override {
584         address owner = ERC721.ownerOf(tokenId);
585         require(to != owner, "ERC721: approval to current owner");
586 
587         require(
588             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
589             "ERC721: approve caller is not owner nor approved for all"
590         );
591 
592         _approve(to, tokenId);
593     }
594 
595     function getApproved(uint256 tokenId)
596         public
597         view
598         virtual
599         override
600         returns (address)
601     {
602         require(
603             _exists(tokenId),
604             "ERC721: approved query for nonexistent token"
605         );
606 
607         return _tokenApprovals[tokenId];
608     }
609 
610     function setApprovalForAll(address operator, bool approved)
611         public
612         virtual
613         override
614     {
615         _setApprovalForAll(_msgSender(), operator, approved);
616     }
617 
618     function isApprovedForAll(address owner, address operator)
619         public
620         view
621         virtual
622         override
623         returns (bool)
624     {
625         return _operatorApprovals[owner][operator];
626     }
627 
628     function transferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) public virtual override {
633         //solhint-disable-next-line max-line-length
634         require(
635             _isApprovedOrOwner(_msgSender(), tokenId),
636             "ERC721: transfer caller is not owner nor approved"
637         );
638 
639         _transfer(from, to, tokenId);
640     }
641 
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId
646     ) public virtual override {
647         safeTransferFrom(from, to, tokenId, "");
648     }
649 
650     function safeTransferFrom(
651         address from,
652         address to,
653         uint256 tokenId,
654         bytes memory _data
655     ) public virtual override {
656         require(
657             _isApprovedOrOwner(_msgSender(), tokenId),
658             "ERC721: transfer caller is not owner nor approved"
659         );
660         _safeTransfer(from, to, tokenId, _data);
661     }
662 
663     function _safeTransfer(
664         address from,
665         address to,
666         uint256 tokenId,
667         bytes memory _data
668     ) internal virtual {
669         _transfer(from, to, tokenId);
670         require(
671             _checkOnERC721Received(from, to, tokenId, _data),
672             "ERC721: transfer to non ERC721Receiver implementer"
673         );
674     }
675 
676     function _exists(uint256 tokenId) internal view virtual returns (bool) {
677         return _owners[tokenId] != address(0);
678     }
679 
680     function _isApprovedOrOwner(address spender, uint256 tokenId)
681         internal
682         view
683         virtual
684         returns (bool)
685     {
686         require(
687             _exists(tokenId),
688             "ERC721: operator query for nonexistent token"
689         );
690         address owner = ERC721.ownerOf(tokenId);
691         return (spender == owner ||
692             getApproved(tokenId) == spender ||
693             isApprovedForAll(owner, spender));
694     }
695 
696     function _safeMint(address to, uint256 tokenId) internal virtual {
697         _safeMint(to, tokenId, "");
698     }
699 
700     function _safeMint(
701         address to,
702         uint256 tokenId,
703         bytes memory _data
704     ) internal virtual {
705         _mint(to, tokenId);
706         require(
707             _checkOnERC721Received(address(0), to, tokenId, _data),
708             "ERC721: transfer to non ERC721Receiver implementer"
709         );
710     }
711 
712     function _mint(address to, uint256 tokenId) internal virtual {
713         require(to != address(0), "ERC721: mint to the zero address");
714         require(!_exists(tokenId), "ERC721: token already minted");
715 
716         _beforeTokenTransfer(address(0), to, tokenId);
717 
718         _balances[to] += 1;
719         _owners[tokenId] = to;
720 
721         emit Transfer(address(0), to, tokenId);
722     }
723 
724     function _burn(uint256 tokenId) internal virtual {
725         address owner = ERC721.ownerOf(tokenId);
726 
727         _beforeTokenTransfer(owner, address(0), tokenId);
728 
729         _approve(address(0), tokenId);
730 
731         _balances[owner] -= 1;
732         delete _owners[tokenId];
733 
734         emit Transfer(owner, address(0), tokenId);
735     }
736 
737     function _transfer(
738         address from,
739         address to,
740         uint256 tokenId
741     ) internal virtual {
742         require(
743             ERC721.ownerOf(tokenId) == from,
744             "ERC721: transfer of token that is not own"
745         );
746         require(to != address(0), "ERC721: transfer to the zero address");
747 
748         _beforeTokenTransfer(from, to, tokenId);
749 
750         _approve(address(0), tokenId);
751 
752         _balances[from] -= 1;
753         _balances[to] += 1;
754         _owners[tokenId] = to;
755 
756         emit Transfer(from, to, tokenId);
757     }
758 
759     function _approve(address to, uint256 tokenId) internal virtual {
760         _tokenApprovals[tokenId] = to;
761         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
762     }
763 
764     function _setApprovalForAll(
765         address owner,
766         address operator,
767         bool approved
768     ) internal virtual {
769         require(owner != operator, "ERC721: approve to caller");
770         _operatorApprovals[owner][operator] = approved;
771         emit ApprovalForAll(owner, operator, approved);
772     }
773 
774     function _checkOnERC721Received(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) private returns (bool) {
780         if (to.isContract()) {
781             try
782                 IERC721Receiver(to).onERC721Received(
783                     _msgSender(),
784                     from,
785                     tokenId,
786                     _data
787                 )
788             returns (bytes4 retval) {
789                 return retval == IERC721Receiver.onERC721Received.selector;
790             } catch (bytes memory reason) {
791                 if (reason.length == 0) {
792                     revert(
793                         "ERC721: transfer to non ERC721Receiver implementer"
794                     );
795                 } else {
796                     assembly {
797                         revert(add(32, reason), mload(reason))
798                     }
799                 }
800             }
801         } else {
802             return true;
803         }
804     }
805 
806     function _beforeTokenTransfer(
807         address from,
808         address to,
809         uint256 tokenId
810     ) internal virtual {}
811 }
812 
813 pragma solidity >=0.7.0 <0.9.0;
814 
815 contract Project824 is ERC721, Ownable {
816     using Strings for uint256;
817     using Counters for Counters.Counter;
818 
819     Counters.Counter private supply;
820 
821     string public uriPrefix = "";
822     string public uriSuffix = ".json";
823     string public hiddenMetadataUri;
824 
825     uint256 public cost = 0 ether;
826     uint256 public maxSupply = 2480;
827     uint256 public maxMintAmountPerTx = 200;
828     uint256 public nftPerAddressLimit = 200;
829 
830     bool public paused = false;
831     bool public revealed = true;
832     bool public onlyWhitelisted = true;
833 
834     bytes32 public merkleRoot;
835 
836     constructor() ERC721("Project824", "P824") {
837         setUriPrefix("ipfs://QmSH13qwCPhHYhKKcTJh2Ec4xuxUdqG8HEgmVuAmiG16ma/");
838     }
839 
840     modifier mintCompliance(uint256 _mintAmount) {
841         require(
842             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
843             "Invalid mint amount!"
844         );
845         require(
846             supply.current() + _mintAmount <= maxSupply,
847             "Max supply exceeded!"
848         );
849         _;
850     }
851 
852     function totalSupply() public view returns (uint256) {
853         return supply.current();
854     }
855 
856     function mint(uint256 _mintAmount)
857         public
858         payable
859         mintCompliance(_mintAmount)
860     {
861         require(!paused, "The contract is paused!");
862         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
863         require(!onlyWhitelisted, "Whitelisted is on!");
864         uint256 ownerTokenCount = balanceOf(msg.sender);
865         require(ownerTokenCount < nftPerAddressLimit, "Max supply exceeded!");
866         _mintLoop(msg.sender, _mintAmount);
867     }
868 
869      function mintForWhitelisted(uint256 _mintAmount, bytes32[] calldata _merkleProof)
870         public
871         payable
872         mintCompliance(_mintAmount)
873     {
874         require(!paused, "The contract is paused!");
875         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
876         if (onlyWhitelisted == true) {
877             require(isWhitelisted(_merkleProof), "User is not whitelisted");
878         }
879         uint256 ownerTokenCount = balanceOf(msg.sender);
880         require(ownerTokenCount < nftPerAddressLimit, "Max supply exceeded!");
881         _mintLoop(msg.sender, _mintAmount);
882     }
883 
884     function isWhitelisted(bytes32[] calldata _merkleProof)
885         public
886         view
887         returns (bool)
888     {
889         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
890         return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
891     }
892 
893     function checkingWhitelisted(address sender, bytes32[] calldata _merkleProof)
894         public
895         view
896         returns (bool)
897     {
898         bytes32 leaf = keccak256(abi.encodePacked(sender));
899         return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
900     }
901 
902     function mintForAddress(uint256 _mintAmount, address _receiver)
903         public
904         mintCompliance(_mintAmount)
905         onlyOwner
906     {
907         _mintLoop(_receiver, _mintAmount);
908     }
909 
910     function walletOfOwner(address _owner)
911         public
912         view
913         returns (uint256[] memory)
914     {
915         uint256 ownerTokenCount = balanceOf(_owner);
916         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
917         uint256 currentTokenId = 1;
918         uint256 ownedTokenIndex = 0;
919 
920         while (
921             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
922         ) {
923             address currentTokenOwner = ownerOf(currentTokenId);
924 
925             if (currentTokenOwner == _owner) {
926                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
927 
928                 ownedTokenIndex++;
929             }
930 
931             currentTokenId++;
932         }
933 
934         return ownedTokenIds;
935     }
936 
937     function tokenURI(uint256 _tokenId)
938         public
939         view
940         virtual
941         override
942         returns (string memory)
943     {
944         require(
945             _exists(_tokenId),
946             "ERC721Metadata: URI query for nonexistent token"
947         );
948 
949         if (revealed == false) {
950             return hiddenMetadataUri;
951         }
952 
953         string memory currentBaseURI = _baseURI();
954         return
955             bytes(currentBaseURI).length > 0
956                 ? string(
957                     abi.encodePacked(
958                         currentBaseURI,
959                         _tokenId.toString(),
960                         uriSuffix
961                     )
962                 )
963                 : "";
964     }
965 
966     function setRevealed(bool _state) public onlyOwner {
967         revealed = _state;
968     }
969 
970     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
971         nftPerAddressLimit = _limit;
972     }
973 
974     function setCost(uint256 _cost) public onlyOwner {
975         cost = _cost;
976     }
977 
978     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
979         public
980         onlyOwner
981     {
982         maxMintAmountPerTx = _maxMintAmountPerTx;
983     }
984 
985     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
986         public
987         onlyOwner
988     {
989         hiddenMetadataUri = _hiddenMetadataUri;
990     }
991 
992     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
993         uriPrefix = _uriPrefix;
994     }
995 
996     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
997         uriSuffix = _uriSuffix;
998     }
999 
1000     function setPaused(bool _state) public onlyOwner {
1001         paused = _state;
1002     }
1003 
1004     function setOnlyWhitelisted(bool _state) public onlyOwner {
1005         onlyWhitelisted = _state;
1006     }
1007     
1008     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1009         merkleRoot = _merkleRoot;
1010     }
1011 
1012     function withdraw() public onlyOwner {
1013         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1014         require(os);
1015     }
1016 
1017     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1018         for (uint256 i = 0; i < _mintAmount; i++) {
1019             supply.increment();
1020             _safeMint(_receiver, supply.current());
1021         }
1022     }
1023 
1024     function _baseURI() internal view virtual override returns (string memory) {
1025         return uriPrefix;
1026     }
1027 }