1 // SPDX-License-Identifier: MIT
2 
3 //  https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
4 pragma solidity ^0.8.0;
5 
6 interface IERC165 {
7     function supportsInterface(bytes4 interfaceId) external view returns (bool);
8 }
9 
10 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
11 pragma solidity ^0.8.0;
12 
13 interface IERC721 is IERC165 {
14     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
15 
16     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
17 
18     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
19 
20     function balanceOf(address owner) external view returns (uint256 balance);
21 
22     function ownerOf(uint256 tokenId) external view returns (address owner);
23 
24     function safeTransferFrom(
25         address from,
26         address to,
27         uint256 tokenId
28     ) external;
29 
30     
31     function transferFrom(
32         address from,
33         address to,
34         uint256 tokenId
35     ) external;
36 
37     function approve(address to, uint256 tokenId) external;
38 
39     function getApproved(uint256 tokenId) external view returns (address operator);
40 
41     function setApprovalForAll(address operator, bool _approved) external;
42 
43     function isApprovedForAll(address owner, address operator) external view returns (bool);
44 
45     function safeTransferFrom(
46         address from,
47         address to,
48         uint256 tokenId,
49         bytes calldata data
50     ) external;
51 }
52 
53 
54 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
55 pragma solidity ^0.8.0;
56 
57 abstract contract ERC165 is IERC165 {
58  
59     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
60         return interfaceId == type(IERC165).interfaceId;
61     }
62 }
63 
64 
65 pragma solidity ^0.8.0;
66 // conerts to ASCII
67 library Strings {
68     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
69 
70 
71     function toString(uint256 value) internal pure returns (string memory) {
72         // Inspired by OraclizeAPI's implementation - MIT licence
73         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
74 
75         if (value == 0) {
76             return "0";
77         }
78         uint256 temp = value;
79         uint256 digits;
80         while (temp != 0) {
81             digits++;
82             temp /= 10;
83         }
84         bytes memory buffer = new bytes(digits);
85         while (value != 0) {
86             digits -= 1;
87             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
88             value /= 10;
89         }
90         return string(buffer);
91     }
92 
93   
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107    
108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = _HEX_SYMBOLS[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 
121 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
122 
123 pragma solidity ^0.8.0;
124 //address functions
125 library Address {
126   
127     function isContract(address account) internal view returns (bool) {
128 
129         uint256 size;
130         assembly {
131             size := extcodesize(account)
132         }
133         return size > 0;
134     }
135 
136  
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         (bool success, ) = recipient.call{value: amount}("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144 
145     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
146         return functionCall(target, data, "Address: low-level call failed");
147     }
148 
149   
150     function functionCall(
151         address target,
152         bytes memory data,
153         string memory errorMessage
154     ) internal returns (bytes memory) {
155         return functionCallWithValue(target, data, 0, errorMessage);
156     }
157 
158   
159     function functionCallWithValue(
160         address target,
161         bytes memory data,
162         uint256 value
163     ) internal returns (bytes memory) {
164         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
165     }
166 
167    
168     function functionCallWithValue(
169         address target,
170         bytes memory data,
171         uint256 value,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         require(address(this).balance >= value, "Address: insufficient balance for call");
175         require(isContract(target), "Address: call to non-contract");
176 
177         (bool success, bytes memory returndata) = target.call{value: value}(data);
178         return verifyCallResult(success, returndata, errorMessage);
179     }
180 
181    
182     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
183         return functionStaticCall(target, data, "Address: low-level static call failed");
184     }
185 
186    
187     function functionStaticCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal view returns (bytes memory) {
192         require(isContract(target), "Address: static call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.staticcall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198   
199     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
200         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
201     }
202 
203 
204     function functionDelegateCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(isContract(target), "Address: delegate call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215   
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             
225             if (returndata.length > 0) {
226                 
227 
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 
239 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
240 
241 pragma solidity ^0.8.0;
242 
243 
244 //ERC-721 Token Standard
245  
246 interface IERC721Metadata is IERC721 {
247    
248     function name() external view returns (string memory);
249 
250    
251     function symbol() external view returns (string memory);
252 
253   
254     function tokenURI(uint256 tokenId) external view returns (string memory);
255 }
256 
257 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
258 
259 pragma solidity ^0.8.0;
260 
261 
262 
263 interface IERC721Receiver {
264 
265     function onERC721Received(
266         address operator,
267         address from,
268         uint256 tokenId,
269         bytes calldata data
270     ) external returns (bytes4);
271 }
272 
273 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
274 pragma solidity ^0.8.0;
275 
276 abstract contract Context {
277     function _msgSender() internal view virtual returns (address) {
278         return msg.sender;
279     }
280 
281     function _msgData() internal view virtual returns (bytes calldata) {
282         return msg.data;
283     }
284 }
285 
286 
287 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
288 pragma solidity ^0.8.0;
289 
290 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
291     using Address for address;
292     using Strings for uint256;
293 
294     string private _name;
295 
296     string private _symbol;
297 
298     mapping(uint256 => address) private _owners;
299 
300     mapping(address => uint256) private _balances;
301 
302     mapping(uint256 => address) private _tokenApprovals;
303 
304     mapping(address => mapping(address => bool)) private _operatorApprovals;
305 //coolection constructor
306     constructor(string memory name_, string memory symbol_) {
307         _name = name_;
308         _symbol = symbol_;
309     }
310 
311    
312     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
313         return
314             interfaceId == type(IERC721).interfaceId ||
315             interfaceId == type(IERC721Metadata).interfaceId ||
316             super.supportsInterface(interfaceId);
317     }
318 
319 
320     function balanceOf(address owner) public view virtual override returns (uint256) {
321         require(owner != address(0), "ERC721: balance query for the zero address");
322         return _balances[owner];
323     }
324 
325 
326     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
327         address owner = _owners[tokenId];
328         require(owner != address(0), "ERC721: owner query for nonexistent token");
329         return owner;
330     }
331 
332    
333     function name() public view virtual override returns (string memory) {
334         return _name;
335     }
336 
337  
338     function symbol() public view virtual override returns (string memory) {
339         return _symbol;
340     }
341 
342   
343     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
344         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
345 
346         string memory baseURI = _baseURI();
347         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
348     }
349 
350  
351     function _baseURI() internal view virtual returns (string memory) {
352         return "";
353     }
354 
355     function approve(address to, uint256 tokenId) public virtual override {
356         address owner = ERC721.ownerOf(tokenId);
357         require(to != owner, "ERC721: approval to current owner");
358 
359         require(
360             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
361             "ERC721: approve caller is not owner nor approved for all"
362         );
363 
364         _approve(to, tokenId);
365     }
366 
367    
368     function getApproved(uint256 tokenId) public view virtual override returns (address) {
369         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
370 
371         return _tokenApprovals[tokenId];
372     }
373 
374    
375     function setApprovalForAll(address operator, bool approved) public virtual override {
376         require(operator != _msgSender(), "ERC721: approve to caller");
377 
378         _operatorApprovals[_msgSender()][operator] = approved;
379         emit ApprovalForAll(_msgSender(), operator, approved);
380     }
381 
382   
383     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
384         return _operatorApprovals[owner][operator];
385     }
386 
387     function transferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) public virtual override {
392         
393         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
394 
395         _transfer(from, to, tokenId);
396     }
397  
398     function safeTransferFrom(
399         address from,
400         address to,
401         uint256 tokenId
402     ) public virtual override {
403         safeTransferFrom(from, to, tokenId, "");
404     }
405   
406     function safeTransferFrom(
407         address from,
408         address to,
409         uint256 tokenId,
410         bytes memory _data
411     ) public virtual override {
412         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
413         _safeTransfer(from, to, tokenId, _data);
414     }
415 
416     function _safeTransfer(
417         address from,
418         address to,
419         uint256 tokenId,
420         bytes memory _data
421     ) internal virtual {
422         _transfer(from, to, tokenId);
423         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
424     }
425 
426 
427     function _exists(uint256 tokenId) internal view virtual returns (bool) {
428         return _owners[tokenId] != address(0);
429     }
430   
431     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
432         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
433         address owner = ERC721.ownerOf(tokenId);
434         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
435     }
436    
437     function _safeMint(address to, uint256 tokenId) internal virtual {
438         _safeMint(to, tokenId, "");
439     }
440 
441   
442     function _safeMint(
443         address to,
444         uint256 tokenId,
445         bytes memory _data
446     ) internal virtual {
447         _mint(to, tokenId);
448         require(
449             _checkOnERC721Received(address(0), to, tokenId, _data),
450             "ERC721: transfer to non ERC721Receiver implementer"
451         );
452     }
453 
454  
455     function _mint(address to, uint256 tokenId) internal virtual {
456         require(to != address(0), "ERC721: mint to the zero address");
457         require(!_exists(tokenId), "ERC721: token already minted");
458 
459         _beforeTokenTransfer(address(0), to, tokenId);
460 
461         _balances[to] += 1;
462         _owners[tokenId] = to;
463 
464         emit Transfer(address(0), to, tokenId);
465     }
466 
467    
468     function _burn(uint256 tokenId) internal virtual {
469         address owner = ERC721.ownerOf(tokenId);
470 
471         _beforeTokenTransfer(owner, address(0), tokenId);
472 
473         _approve(address(0), tokenId);
474 
475         _balances[owner] -= 1;
476         delete _owners[tokenId];
477 
478         emit Transfer(owner, address(0), tokenId);
479     }
480 
481     function _transfer(
482         address from,
483         address to,
484         uint256 tokenId
485     ) internal virtual {
486         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
487         require(to != address(0), "ERC721: transfer to the zero address");
488 
489         _beforeTokenTransfer(from, to, tokenId);
490 
491         _approve(address(0), tokenId);
492 
493         _balances[from] -= 1;
494         _balances[to] += 1;
495         _owners[tokenId] = to;
496 
497         emit Transfer(from, to, tokenId);
498     }
499 
500   
501     function _approve(address to, uint256 tokenId) internal virtual {
502         _tokenApprovals[tokenId] = to;
503         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
504     }
505 
506     function _checkOnERC721Received(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes memory _data
511     ) private returns (bool) {
512         if (to.isContract()) {
513             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
514                 return retval == IERC721Receiver.onERC721Received.selector;
515             } catch (bytes memory reason) {
516                 if (reason.length == 0) {
517                     revert("ERC721: transfer to non ERC721Receiver implementer");
518                 } else {
519                     assembly {
520                         revert(add(32, reason), mload(reason))
521                     }
522                 }
523             }
524         } else {
525             return true;
526         }
527     }
528 
529     function _beforeTokenTransfer(
530         address from,
531         address to,
532         uint256 tokenId
533     ) internal virtual {}
534 }
535 
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev Contract module that helps prevent reentrant calls to a function.
541  *
542  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
543  * available, which can be applied to functions to make sure there are no nested
544  * (reentrant) calls to them.
545  *
546  * Note that because there is a single `nonReentrant` guard, functions marked as
547  * `nonReentrant` may not call one another. This can be worked around by making
548  * those functions `private`, and then adding `external` `nonReentrant` entry
549  * points to them.
550  *
551  * TIP: If you would like to learn more about reentrancy and alternative ways
552  * to protect against it, check out our blog post
553  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
554  */
555 abstract contract ReentrancyGuard {
556     // Booleans are more expensive than uint256 or any type that takes up a full
557     // word because each write operation emits an extra SLOAD to first read the
558     // slot's contents, replace the bits taken up by the boolean, and then write
559     // back. This is the compiler's defense against contract upgrades and
560     // pointer aliasing, and it cannot be disabled.
561 
562     // The values being non-zero value makes deployment a bit more expensive,
563     // but in exchange the refund on every call to nonReentrant will be lower in
564     // amount. Since refunds are capped to a percentage of the total
565     // transaction's gas, it is best to keep them low in cases like this one, to
566     // increase the likelihood of the full refund coming into effect.
567     uint256 private constant _NOT_ENTERED = 1;
568     uint256 private constant _ENTERED = 2;
569 
570     uint256 private _status;
571 
572     constructor() {
573         _status = _NOT_ENTERED;
574     }
575 
576     /**
577      * @dev Prevents a contract from calling itself, directly or indirectly.
578      * Calling a `nonReentrant` function from another `nonReentrant`
579      * function is not supported. It is possible to prevent this from happening
580      * by making the `nonReentrant` function external, and make it call a
581      * `private` function that does the actual work.
582      */
583     modifier nonReentrant() {
584         // On the first call to nonReentrant, _notEntered will be true
585         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
586 
587         // Any calls to nonReentrant after this point will fail
588         _status = _ENTERED;
589 
590         _;
591 
592         // By storing the original value once again, a refund is triggered (see
593         // https://eips.ethereum.org/EIPS/eip-2200)
594         _status = _NOT_ENTERED;
595     }
596 }
597 
598 
599 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
600 
601 pragma solidity ^0.8.0;
602 // owner only commands
603 abstract contract Ownable is Context {
604     address private _owner;
605 
606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
607 
608  //owner constructor
609     constructor() {
610         _setOwner(_msgSender());
611     }
612 
613   
614     function owner() public view virtual returns (address) {
615         return _owner;
616     }
617 
618    
619     modifier onlyOwner() {
620         require(owner() == _msgSender(), "Ownable: caller is not the owner");
621         _;
622     }
623 
624 
625     function renounceOwnership() public virtual onlyOwner {
626         _setOwner(address(0));
627     }
628 
629  
630     function transferOwnership(address newOwner) public virtual onlyOwner {
631         require(newOwner != address(0), "Ownable: new owner is the zero address");
632         _setOwner(newOwner);
633     }
634 
635     function _setOwner(address newOwner) private {
636         address oldOwner = _owner;
637         _owner = newOwner;
638         emit OwnershipTransferred(oldOwner, newOwner);
639     }
640 }
641 
642 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 /**
647  * @dev These functions deal with verification of Merkle Tree proofs.
648  *
649  * The proofs can be generated using the JavaScript library
650  * https://github.com/miguelmota/merkletreejs[merkletreejs].
651  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
652  *
653  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
654  *
655  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
656  * hashing, or use a hash function other than keccak256 for hashing leaves.
657  * This is because the concatenation of a sorted pair of internal nodes in
658  * the merkle tree could be reinterpreted as a leaf value.
659  */
660 library MerkleProof {
661     /**
662      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
663      * defined by `root`. For this, a `proof` must be provided, containing
664      * sibling hashes on the branch from the leaf to the root of the tree. Each
665      * pair of leaves and each pair of pre-images are assumed to be sorted.
666      */
667     function verify(
668         bytes32[] memory proof,
669         bytes32 root,
670         bytes32 leaf
671     ) internal pure returns (bool) {
672         return processProof(proof, leaf) == root;
673     }
674 
675     /**
676      * @dev Calldata version of {verify}
677      *
678      * _Available since v4.7._
679      */
680     function verifyCalldata(
681         bytes32[] calldata proof,
682         bytes32 root,
683         bytes32 leaf
684     ) internal pure returns (bool) {
685         return processProofCalldata(proof, leaf) == root;
686     }
687 
688     /**
689      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
690      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
691      * hash matches the root of the tree. When processing the proof, the pairs
692      * of leafs & pre-images are assumed to be sorted.
693      *
694      * _Available since v4.4._
695      */
696     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
697         bytes32 computedHash = leaf;
698         for (uint256 i = 0; i < proof.length; i++) {
699             computedHash = _hashPair(computedHash, proof[i]);
700         }
701         return computedHash;
702     }
703 
704     /**
705      * @dev Calldata version of {processProof}
706      *
707      * _Available since v4.7._
708      */
709     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
710         bytes32 computedHash = leaf;
711         for (uint256 i = 0; i < proof.length; i++) {
712             computedHash = _hashPair(computedHash, proof[i]);
713         }
714         return computedHash;
715     }
716 
717     /**
718      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
719      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
720      *
721      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
722      *
723      * _Available since v4.7._
724      */
725     function multiProofVerify(
726         bytes32[] memory proof,
727         bool[] memory proofFlags,
728         bytes32 root,
729         bytes32[] memory leaves
730     ) internal pure returns (bool) {
731         return processMultiProof(proof, proofFlags, leaves) == root;
732     }
733 
734     /**
735      * @dev Calldata version of {multiProofVerify}
736      *
737      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
738      *
739      * _Available since v4.7._
740      */
741     function multiProofVerifyCalldata(
742         bytes32[] calldata proof,
743         bool[] calldata proofFlags,
744         bytes32 root,
745         bytes32[] memory leaves
746     ) internal pure returns (bool) {
747         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
748     }
749 
750     /**
751      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
752      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
753      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
754      * respectively.
755      *
756      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
757      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
758      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
759      *
760      * _Available since v4.7._
761      */
762     function processMultiProof(
763         bytes32[] memory proof,
764         bool[] memory proofFlags,
765         bytes32[] memory leaves
766     ) internal pure returns (bytes32 merkleRoot) {
767         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
768         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
769         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
770         // the merkle tree.
771         uint256 leavesLen = leaves.length;
772         uint256 totalHashes = proofFlags.length;
773 
774         // Check proof validity.
775         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
776 
777         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
778         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
779         bytes32[] memory hashes = new bytes32[](totalHashes);
780         uint256 leafPos = 0;
781         uint256 hashPos = 0;
782         uint256 proofPos = 0;
783         // At each step, we compute the next hash using two values:
784         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
785         //   get the next hash.
786         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
787         //   `proof` array.
788         for (uint256 i = 0; i < totalHashes; i++) {
789             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
790             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
791             hashes[i] = _hashPair(a, b);
792         }
793 
794         if (totalHashes > 0) {
795             return hashes[totalHashes - 1];
796         } else if (leavesLen > 0) {
797             return leaves[0];
798         } else {
799             return proof[0];
800         }
801     }
802 
803     /**
804      * @dev Calldata version of {processMultiProof}.
805      *
806      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
807      *
808      * _Available since v4.7._
809      */
810     function processMultiProofCalldata(
811         bytes32[] calldata proof,
812         bool[] calldata proofFlags,
813         bytes32[] memory leaves
814     ) internal pure returns (bytes32 merkleRoot) {
815         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
816         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
817         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
818         // the merkle tree.
819         uint256 leavesLen = leaves.length;
820         uint256 totalHashes = proofFlags.length;
821 
822         // Check proof validity.
823         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
824 
825         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
826         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
827         bytes32[] memory hashes = new bytes32[](totalHashes);
828         uint256 leafPos = 0;
829         uint256 hashPos = 0;
830         uint256 proofPos = 0;
831         // At each step, we compute the next hash using two values:
832         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
833         //   get the next hash.
834         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
835         //   `proof` array.
836         for (uint256 i = 0; i < totalHashes; i++) {
837             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
838             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
839             hashes[i] = _hashPair(a, b);
840         }
841 
842         if (totalHashes > 0) {
843             return hashes[totalHashes - 1];
844         } else if (leavesLen > 0) {
845             return leaves[0];
846         } else {
847             return proof[0];
848         }
849     }
850 
851     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
852         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
853     }
854 
855     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
856         /// @solidity memory-safe-assembly
857         assembly {
858             mstore(0x00, a)
859             mstore(0x20, b)
860             value := keccak256(0x00, 0x40)
861         }
862     }
863 }
864 
865 
866 /*  
867 
868                                                                                                
869    @@@@@@   @@@@@@@    @@@@@@    @@@@@@   @@@  @@@  @@@ @@@         @@@@@@   @@@@@@@@  @@@  @@@  
870   @@@@@@@   @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@  @@@  @@@ @@@        @@@@@@@   @@@@@@@@  @@@@ @@@  
871   !@@       @@!  @@@  @@!  @@@  @@!  @@@  @@!  !@@  @@! !@@        !@@            @@!  @@!@!@@@  
872   !@!       !@!  @!@  !@!  @!@  !@!  @!@  !@!  @!!  !@! @!!        !@!           !@!   !@!!@!@!  
873   !!@@!!    @!@@!@!   @!@  !@!  @!@  !@!  @!@@!@!    !@!@!         !!@@!!       @!!    @!@ !!@!  
874    !!@!!!   !!@!!!    !@!  !!!  !@!  !!!  !!@!!!      @!!!          !!@!!!     !!!     !@!  !!!  
875        !:!  !!:       !!:  !!!  !!:  !!!  !!: :!!     !!:               !:!   !!:      !!:  !!!  
876       !:!   :!:       :!:  !:!  :!:  !:!  :!:  !:!    :!:              !:!   :!:       :!:  !:!  
877   :::: ::    ::       ::::: ::  ::::: ::   ::  :::     ::          :::: ::    :: ::::   ::   ::  
878   :: : :     :         : :  :    : :  :    :   :::     :           :: : :    : :: : :  ::    :   
879                                                                                                
880                                                                                                
881 
882 	
883                             Contract provided By B.A.S.S Studios 
884                             (Blockchain and Software Solutions)
885                                     f i r e b u g 5 0 9                     
886 */
887 pragma solidity >=0.7.0 <0.9.0;
888 
889 abstract contract IParent {
890     
891     function ownerOf(uint256 tokenId) external view virtual returns (address);
892     function walletOfOwner(address _owner) external view virtual returns (uint256[] memory);
893     function totalSupply() external view virtual returns (uint256);
894     function balanceOf(address owner) external view virtual returns (uint256);
895 
896 }
897 
898 contract SpookySZN is ERC721, Ownable, ReentrancyGuard {
899   using Strings for uint256;
900 
901   bytes32 public merkleRoot;
902   mapping(address => uint256) public whitelistClaimed;
903   //collection details
904   string public _collectionName= "Spooky SZN";
905   string public _collectionSymbol="SPKYSZN";
906 
907   //metadata details
908   string baseURI="ipfs://CID/";
909   string public baseExtension = ".json";
910 
911   //mint details
912   uint256 public cost = 0 ether;
913   uint256 public whiteListCost = 0 ether;
914   uint256 public maxSupply = 6666;
915   uint256 public maxMintAmountPerTx = 5;
916   uint256 public whiteListMintAmount=3;
917   string public notRevealedUri;
918 
919   //track mints
920   uint256 public amountMinted;
921   uint256 public WLClaimed;
922 
923 
924   //manage states
925   //public sale toggle
926   bool public publicPaused = true;
927   //white list toggle
928   bool public whitelistMintEnabled = false;
929   //reveal toggle
930   bool public revealed = false;
931   //Mint pass claim toggle
932   bool public parentClaimActive=false;
933 
934     //MintPass interface management
935     mapping(address=>uint256) public _parentsClaimedPerAddress;
936     // tracking Used partent claims / used mint passes
937     uint256 public parentClaims;
938     //v2 address change this to nft adress needed to hold for claim
939     address public v2Address =0x3b8e3C1a29C5cA73Dd47Dc57781d3E7551c0A2aB;
940 
941 
942     //initialize v2 as the parent interface
943     IParent public v2;
944 
945   constructor() ERC721(_collectionName, _collectionSymbol)
946    {
947     setNotRevealedURI("ipfs://QmdC8LcRr5Xxzqdx3YCgs5uCEQBCApaCFXGRK7tdTwAp9P/HiddenMetadata.json");
948     //assign v2 a contract address to act as the (parent/mint pass)
949     v2= IParent(v2Address);
950   }
951 
952   function _baseURI() internal view virtual override returns (string memory) {
953     return baseURI;
954   }
955 
956   // public minting fuction + WL check
957   function mint(uint256 _mintAmount) public payable {
958 
959     uint256 mintSupply = totalSupply();
960 
961 //manage public mint
962     require(!publicPaused, "Contract is paused");
963     require(_mintAmount > 0, "mint amount cant be 0");
964     require(_mintAmount <= maxMintAmountPerTx, "Cant mint over the max mint amount");
965     require(mintSupply + _mintAmount <= maxSupply, "Mint amount is too high there may not be enough left to mint that many");
966 
967     if (msg.sender != owner()) {
968       require(msg.value >= cost * _mintAmount);
969     }
970 
971     for (uint256 i = 1; i <= _mintAmount; i++) {
972       _safeMint(msg.sender, mintSupply + i);
973     }
974     amountMinted+=_mintAmount;
975   }
976   
977 function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable{
978 
979       uint256 mintSupply = totalSupply();
980 //manage whitelist request
981 
982     require(whitelistMintEnabled, "whitelist not active");
983     require((whitelistClaimed[msg.sender] +_mintAmount) <= whiteListMintAmount, "Address already claimed! or you have requested more than allowed");
984     require(_mintAmount > 0, "mint amount cant be 0");
985     require(mintSupply + _mintAmount <= maxSupply, "Purchase would exceed max supply");
986     require(msg.value>= whiteListCost*_mintAmount,"Eth value sent is not correct");
987     bytes32 leaf = keccak256(abi.encodePacked(msg.sender)); 
988     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof!");
989 
990     whitelistClaimed[msg.sender] += _mintAmount;
991     amountMinted+=_mintAmount;
992     WLClaimed+=_mintAmount;
993 
994         for (uint256 i = 1; i <= _mintAmount; i++) {
995       
996     _safeMint(msg.sender, mintSupply + i);
997       
998       }
999 
1000 }
1001 
1002   //claimable list mint funtion
1003 //claim from parent (mint pass implementation)
1004 function claimForParentNFT(uint256 numberOfTokens) external payable {
1005 
1006     uint256 balance= v2.balanceOf(msg.sender);
1007     uint256 currentSupplyGlobal = totalSupply();
1008     uint256 currentClaimed =_parentsClaimedPerAddress[msg.sender];
1009     require(parentClaimActive, "Claim is not active");
1010     require(numberOfTokens+currentClaimed <=balance, "Exceeded max available to purchase");
1011     require(currentSupplyGlobal + numberOfTokens <= maxSupply, "Purchase would exceed max supply");
1012 
1013     for (uint256 i = 1; i <= (numberOfTokens); i++) {
1014                 _safeMint(msg.sender, currentSupplyGlobal + i);
1015     }
1016                     parentClaims+=numberOfTokens;
1017                     _parentsClaimedPerAddress[msg.sender]+=numberOfTokens;
1018                     amountMinted+=numberOfTokens;
1019  }
1020 
1021 //return total supply minted
1022  function totalSupply() public view returns (uint256) {
1023     return amountMinted;
1024   }
1025 
1026 //gas efficient function to find token ids owned by address
1027    function walletOfOwner(address _owner)
1028     public
1029     view
1030     returns (uint256[] memory)
1031   {
1032     uint256 ownerTokenCount = balanceOf(_owner);
1033     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1034     uint256 currentTokenId = 1;
1035     uint256 ownedTokenIndex = 0;
1036 
1037     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1038       address currentTokenOwner = ownerOf(currentTokenId);
1039 
1040       if (currentTokenOwner == _owner) {
1041         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1042         ownedTokenIndex++;
1043       }
1044       currentTokenId++;
1045     }
1046     return ownedTokenIds;
1047   }
1048 
1049   function tokenURI(uint256 tokenId)
1050     public
1051     view
1052     virtual
1053     override
1054     returns (string memory)
1055   {
1056     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1057     
1058     if(revealed == false) {
1059         return notRevealedUri;
1060     }
1061     string memory currentBaseURI = _baseURI();
1062     return bytes(currentBaseURI).length > 0
1063         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1064         : "";
1065   }
1066 
1067   //Access Functions
1068   //actions for the owner to interact with contract
1069   function setRevealed(bool _newBool) public onlyOwner() {
1070       revealed = _newBool;
1071   }
1072 // update mint cost
1073   function setCost(uint256 _newCost) public onlyOwner() {
1074     cost = _newCost;
1075   }
1076   // update WL mint cost
1077   function setWhiteListCost(uint256 _newCost) public onlyOwner() {
1078     whiteListCost = _newCost;
1079   }
1080 // max mint amount
1081   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1082     maxMintAmountPerTx = _newmaxMintAmount;
1083   }
1084 // max WL amount
1085   function setMaxWlAmount(uint256 _newMaxWlAmount) public onlyOwner() {
1086     whiteListMintAmount= _newMaxWlAmount;
1087   }
1088 //revealed bool  
1089   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1090     notRevealedUri = _notRevealedURI;
1091   }
1092 //base URI extension
1093   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1094     baseURI = _newBaseURI;
1095   }
1096 //set extension (.json)
1097   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1098     baseExtension = _newBaseExtension;
1099   }
1100 //contract paused state
1101   function setPaused(bool _state) public onlyOwner {
1102     publicPaused = _state;
1103   }
1104 
1105  
1106   //set white list to true or false for active
1107     function setWhitelistMintEnabled(bool _whiteListActive) external onlyOwner {
1108         whitelistMintEnabled = _whiteListActive;
1109     }
1110 
1111 //mint pass access functions
1112 function setV2Contract(address _newV2Contract) external onlyOwner {
1113     v2Address = _newV2Contract;
1114     v2=IParent(v2Address);
1115   }
1116 
1117 
1118 function setParentClaim(bool choice) public onlyOwner{
1119     parentClaimActive=choice;
1120 }
1121 //distrubute
1122   function distribute(address walletAddress, uint256 amount) public onlyOwner{
1123       uint256 mintSupply=totalSupply();
1124           require(mintSupply + amount <= maxSupply, "Mint amount is too high there may not be enough left to mint that many");
1125           for(uint256 i=1; i<= amount;i++){
1126        _safeMint(walletAddress, mintSupply + i);
1127           }
1128           amountMinted+=amount;
1129   }
1130 
1131  function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1132     merkleRoot = _merkleRoot;
1133   }
1134 
1135 //backup witdraw to retrieve all funds to deployment account 
1136   function backupWithdraw() public payable onlyOwner nonReentrant{
1137  
1138     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1139     require(success);
1140   }
1141 }