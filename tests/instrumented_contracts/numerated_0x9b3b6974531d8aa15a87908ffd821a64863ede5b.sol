1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-01
3 */
4 
5 /*
6 
7     
8        ▄▄▄▄▀ ▄  █ ▄███▄          ▄▄▄▄▀ █▄▄▄▄ ▄█     ▄   ▄███▄   █▄▄▄▄   ▄▄▄▄▄   ▄███▄   
9     ▀▀▀ █   █   █ █▀   ▀      ▀▀▀ █    █  ▄▀ ██      █  █▀   ▀  █  ▄▀  █     ▀▄ █▀   ▀  
10         █   ██▀▀█ ██▄▄            █    █▀▀▌  ██ █     █ ██▄▄    █▀▀▌ ▄  ▀▀▀▀▄   ██▄▄    
11        █    █   █ █▄   ▄▀        █     █  █  ▐█  █    █ █▄   ▄▀ █  █  ▀▄▄▄▄▀    █▄   ▄▀ 
12       ▀        █  ▀███▀         ▀        █    ▐   █  █  ▀███▀     █             ▀███▀   
13               ▀                         ▀          █▐            ▀                      
14                                                    ▐                                    
15 
16 */
17 
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity ^0.8.0;
22 
23 library MerkleProof {
24 
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
34         bytes32 computedHash = leaf;
35         for (uint256 i = 0; i < proof.length; i++) {
36             bytes32 proofElement = proof[i];
37             if (computedHash <= proofElement) {
38                 // Hash(current computed hash + current element of the proof)
39                 computedHash = _efficientHash(computedHash, proofElement);
40             } else {
41                 // Hash(current element of the proof + current computed hash)
42                 computedHash = _efficientHash(proofElement, computedHash);
43             }
44         }
45         return computedHash;
46     }
47 
48     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
49         assembly {
50             mstore(0x00, a)
51             mstore(0x20, b)
52             value := keccak256(0x00, 0x40)
53         }
54     }
55 }
56 
57 
58 abstract contract ReentrancyGuard {
59 
60     uint256 private constant _NOT_ENTERED = 1;
61     uint256 private constant _ENTERED = 2;
62 
63     uint256 private _status;
64 
65     constructor() {
66         _status = _NOT_ENTERED;
67     }
68 
69     modifier nonReentrant() {
70 
71         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
72   
73         _status = _ENTERED;
74 
75         _;
76 
77         _status = _NOT_ENTERED;
78     }
79 }
80 
81 
82 library Counters {
83     struct Counter {
84         uint256 _value; // default: 0
85     }
86 
87     function current(Counter storage counter) internal view returns (uint256) {
88         return counter._value;
89     }
90 
91     function increment(Counter storage counter) internal {
92         unchecked {
93             counter._value += 1;
94         }
95     }
96 
97     function decrement(Counter storage counter) internal {
98         uint256 value = counter._value;
99         require(value > 0, "Counter: decrement overflow");
100         unchecked {
101             counter._value = value - 1;
102         }
103     }
104 
105     function reset(Counter storage counter) internal {
106         counter._value = 0;
107     }
108 }
109 
110 library Strings {
111     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
112 
113     function toString(uint256 value) internal pure returns (string memory) {
114         
115         if (value == 0) {
116             return "0";
117         }
118         uint256 temp = value;
119         uint256 digits;
120         while (temp != 0) {
121             digits++;
122             temp /= 10;
123         }
124         bytes memory buffer = new bytes(digits);
125         while (value != 0) {
126             digits -= 1;
127             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
128             value /= 10;
129         }
130         return string(buffer);
131     }
132 
133     function toHexString(uint256 value) internal pure returns (string memory) {
134         if (value == 0) {
135             return "0x00";
136         }
137         uint256 temp = value;
138         uint256 length = 0;
139         while (temp != 0) {
140             length++;
141             temp >>= 8;
142         }
143         return toHexString(value, length);
144     }
145 
146     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
147         bytes memory buffer = new bytes(2 * length + 2);
148         buffer[0] = "0";
149         buffer[1] = "x";
150         for (uint256 i = 2 * length + 1; i > 1; --i) {
151             buffer[i] = _HEX_SYMBOLS[value & 0xf];
152             value >>= 4;
153         }
154         require(value == 0, "Strings: hex length insufficient");
155         return string(buffer);
156     }
157 }
158 
159 
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes calldata) {
166         return msg.data;
167     }
168 }
169 
170 abstract contract Ownable is Context {
171     address private _owner;
172 
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     constructor() {
176         _transferOwnership(_msgSender());
177     }
178 
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     modifier onlyOwner() {
184         require(owner() == _msgSender(), "Ownable: caller is not the owner");
185         _;
186     }
187 
188     function renounceOwnership() public virtual onlyOwner {
189         _transferOwnership(address(0));
190     }
191 
192     function transferOwnership(address newOwner) public virtual onlyOwner {
193         require(newOwner != address(0), "Ownable: new owner is the zero address");
194         _transferOwnership(newOwner);
195     }
196 
197     function _transferOwnership(address newOwner) internal virtual {
198         address oldOwner = _owner;
199         _owner = newOwner;
200         emit OwnershipTransferred(oldOwner, newOwner);
201     }
202 }
203 
204 library Address {
205   
206     function isContract(address account) internal view returns (bool) {
207         return account.code.length > 0;
208     }
209 
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         (bool success, ) = recipient.call{value: amount}("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
218         return functionCall(target, data, "Address: low-level call failed");
219     }
220 
221     function functionCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, 0, errorMessage);
227     }
228 
229     function functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 value
233     ) internal returns (bytes memory) {
234         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
235     }
236 
237     function functionCallWithValue(
238         address target,
239         bytes memory data,
240         uint256 value,
241         string memory errorMessage
242     ) internal returns (bytes memory) {
243         require(address(this).balance >= value, "Address: insufficient balance for call");
244         require(isContract(target), "Address: call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.call{value: value}(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
251         return functionStaticCall(target, data, "Address: low-level static call failed");
252     }
253 
254     function functionStaticCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal view returns (bytes memory) {
259         require(isContract(target), "Address: static call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.staticcall(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
266         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
267     }
268 
269     function functionDelegateCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(isContract(target), "Address: delegate call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.delegatecall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     function verifyCallResult(
281         bool success,
282         bytes memory returndata,
283         string memory errorMessage
284     ) internal pure returns (bytes memory) {
285         if (success) {
286             return returndata;
287         } else {
288             // Look for revert reason and bubble it up if present
289             if (returndata.length > 0) {
290                 // The easiest way to bubble the revert reason is using memory via assembly
291 
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 
303 
304 interface IERC721Receiver {
305     function onERC721Received(
306         address operator,
307         address from,
308         uint256 tokenId,
309         bytes calldata data
310     ) external returns (bytes4);
311 }
312 
313 
314 interface IERC165 {
315     function supportsInterface(bytes4 interfaceId) external view returns (bool);
316 }
317 
318 
319 abstract contract ERC165 is IERC165 {
320     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
321         return interfaceId == type(IERC165).interfaceId;
322     }
323 }
324 
325 
326 interface IERC721 is IERC165 {
327    
328     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
329 
330     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
331 
332     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
333 
334     function balanceOf(address owner) external view returns (uint256 balance);
335 
336     function ownerOf(uint256 tokenId) external view returns (address owner);
337 
338     function safeTransferFrom(
339         address from,
340         address to,
341         uint256 tokenId
342     ) external;
343 
344     function transferFrom(
345         address from,
346         address to,
347         uint256 tokenId
348     ) external;
349 
350     function approve(address to, uint256 tokenId) external;
351 
352     function getApproved(uint256 tokenId) external view returns (address operator);
353 
354     function setApprovalForAll(address operator, bool _approved) external;
355 
356     function isApprovedForAll(address owner, address operator) external view returns (bool);
357 
358     function safeTransferFrom(
359         address from,
360         address to,
361         uint256 tokenId,
362         bytes calldata data
363     ) external;
364 }
365 
366 interface IERC721Enumerable is IERC721 {
367   
368     function totalSupply() external view returns (uint256);
369 
370     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
371 
372     function tokenByIndex(uint256 index) external view returns (uint256);
373 }
374 
375 interface IERC721Metadata is IERC721 {
376     
377     function name() external view returns (string memory);
378     function symbol() external view returns (string memory);
379     function tokenURI(uint256 tokenId) external view returns (string memory);
380 }
381 
382 
383 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
384     using Address for address;
385     using Strings for uint256;
386 
387     // Token name
388     string private _name;
389 
390     // Token symbol
391     string private _symbol;
392 
393     // Mapping from token ID to owner address
394     mapping(uint256 => address) private _owners;
395 
396     // Mapping owner address to token count
397     mapping(address => uint256) private _balances;
398 
399     // Mapping from token ID to approved address
400     mapping(uint256 => address) private _tokenApprovals;
401 
402     // Mapping from owner to operator approvals
403     mapping(address => mapping(address => bool)) private _operatorApprovals;
404 
405     constructor(string memory name_, string memory symbol_) {
406         _name = name_;
407         _symbol = symbol_;
408     }
409    
410     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
411         return
412             interfaceId == type(IERC721).interfaceId ||
413             interfaceId == type(IERC721Metadata).interfaceId ||
414             super.supportsInterface(interfaceId);
415     }
416 
417     function balanceOf(address owner) public view virtual override returns (uint256) {
418         require(owner != address(0), "ERC721: balance query for the zero address");
419         return _balances[owner];
420     }
421 
422     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
423         address owner = _owners[tokenId];
424         require(owner != address(0), "ERC721: owner query for nonexistent token");
425         return owner;
426     }
427 
428     function name() public view virtual override returns (string memory) {
429         return _name;
430     }
431 
432     function symbol() public view virtual override returns (string memory) {
433         return _symbol;
434     }
435 
436     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
437         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
438 
439         string memory baseURI = _baseURI();
440         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
441     }
442 
443     function _baseURI() internal view virtual returns (string memory) {
444         return "";
445     }
446 
447     function approve(address to, uint256 tokenId) public virtual override {
448         address owner = ERC721.ownerOf(tokenId);
449         require(to != owner, "ERC721: approval to current owner");
450 
451         require(
452             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
453             "ERC721: approve caller is not owner nor approved for all"
454         );
455 
456         _approve(to, tokenId);
457     }
458 
459     function getApproved(uint256 tokenId) public view virtual override returns (address) {
460         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
461 
462         return _tokenApprovals[tokenId];
463     }
464 
465     function setApprovalForAll(address operator, bool approved) public virtual override {
466         _setApprovalForAll(_msgSender(), operator, approved);
467     }
468 
469     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
470         return _operatorApprovals[owner][operator];
471     }
472 
473     function transferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) public virtual override {
478         //solhint-disable-next-line max-line-length
479         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
480 
481         _transfer(from, to, tokenId);
482     }
483 
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) public virtual override {
489         safeTransferFrom(from, to, tokenId, "");
490     }
491 
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId,
496         bytes memory _data
497     ) public virtual override {
498         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
499         _safeTransfer(from, to, tokenId, _data);
500     }
501 
502     function _safeTransfer(
503         address from,
504         address to,
505         uint256 tokenId,
506         bytes memory _data
507     ) internal virtual {
508         _transfer(from, to, tokenId);
509         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
510     }
511 
512     function _exists(uint256 tokenId) internal view virtual returns (bool) {
513         return _owners[tokenId] != address(0);
514     }
515 
516     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
517         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
518         address owner = ERC721.ownerOf(tokenId);
519         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
520     }
521 
522     function _safeMint(address to, uint256 tokenId) internal virtual {
523         _safeMint(to, tokenId, "");
524     }
525 
526     function _safeMint(
527         address to,
528         uint256 tokenId,
529         bytes memory _data
530     ) internal virtual {
531         _mint(to, tokenId);
532         require(
533             _checkOnERC721Received(address(0), to, tokenId, _data),
534             "ERC721: transfer to non ERC721Receiver implementer"
535         );
536     }
537 
538     function _mint(address to, uint256 tokenId) internal virtual {
539         require(to != address(0), "ERC721: mint to the zero address");
540         require(!_exists(tokenId), "ERC721: token already minted");
541 
542         _beforeTokenTransfer(address(0), to, tokenId);
543 
544         _balances[to] += 1;
545         _owners[tokenId] = to;
546 
547         emit Transfer(address(0), to, tokenId);
548 
549         _afterTokenTransfer(address(0), to, tokenId);
550     }
551 
552     function _burn(uint256 tokenId) internal virtual {
553         address owner = ERC721.ownerOf(tokenId);
554 
555         _beforeTokenTransfer(owner, address(0), tokenId);
556 
557         // Clear approvals
558         _approve(address(0), tokenId);
559 
560         _balances[owner] -= 1;
561         delete _owners[tokenId];
562 
563         emit Transfer(owner, address(0), tokenId);
564 
565         _afterTokenTransfer(owner, address(0), tokenId);
566     }
567 
568     function _transfer(
569         address from,
570         address to,
571         uint256 tokenId
572     ) internal virtual {
573         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
574         require(to != address(0), "ERC721: transfer to the zero address");
575 
576         _beforeTokenTransfer(from, to, tokenId);
577 
578         // Clear approvals from the previous owner
579         _approve(address(0), tokenId);
580 
581         _balances[from] -= 1;
582         _balances[to] += 1;
583         _owners[tokenId] = to;
584 
585         emit Transfer(from, to, tokenId);
586 
587         _afterTokenTransfer(from, to, tokenId);
588     }
589 
590     function _approve(address to, uint256 tokenId) internal virtual {
591         _tokenApprovals[tokenId] = to;
592         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
593     }
594 
595     function _setApprovalForAll(
596         address owner,
597         address operator,
598         bool approved
599     ) internal virtual {
600         require(owner != operator, "ERC721: approve to caller");
601         _operatorApprovals[owner][operator] = approved;
602         emit ApprovalForAll(owner, operator, approved);
603     }
604 
605     function _checkOnERC721Received(
606         address from,
607         address to,
608         uint256 tokenId,
609         bytes memory _data
610     ) private returns (bool) {
611         if (to.isContract()) {
612             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
613                 return retval == IERC721Receiver.onERC721Received.selector;
614             } catch (bytes memory reason) {
615                 if (reason.length == 0) {
616                     revert("ERC721: transfer to non ERC721Receiver implementer");
617                 } else {
618                     assembly {
619                         revert(add(32, reason), mload(reason))
620                     }
621                 }
622             }
623         } else {
624             return true;
625         }
626     }
627 
628     function _beforeTokenTransfer(
629         address from,
630         address to,
631         uint256 tokenId
632     ) internal virtual {}
633 
634     function _afterTokenTransfer(
635         address from,
636         address to,
637         uint256 tokenId
638     ) internal virtual {}
639 }
640 
641 
642 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
643     // Mapping from owner to list of owned token IDs
644     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
645 
646     // Mapping from token ID to index of the owner tokens list
647     mapping(uint256 => uint256) private _ownedTokensIndex;
648 
649     // Array with all token ids, used for enumeration
650     uint256[] private _allTokens;
651 
652     // Mapping from token id to position in the allTokens array
653     mapping(uint256 => uint256) private _allTokensIndex;
654 
655     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
656         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
657     }
658 
659     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
660         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
661         return _ownedTokens[owner][index];
662     }
663 
664     function totalSupply() public view virtual override returns (uint256) {
665         return _allTokens.length;
666     }
667 
668     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
669         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
670         return _allTokens[index];
671     }
672 
673     function _beforeTokenTransfer(
674         address from,
675         address to,
676         uint256 tokenId
677     ) internal virtual override {
678         super._beforeTokenTransfer(from, to, tokenId);
679 
680         if (from == address(0)) {
681             _addTokenToAllTokensEnumeration(tokenId);
682         } else if (from != to) {
683             _removeTokenFromOwnerEnumeration(from, tokenId);
684         }
685         if (to == address(0)) {
686             _removeTokenFromAllTokensEnumeration(tokenId);
687         } else if (to != from) {
688             _addTokenToOwnerEnumeration(to, tokenId);
689         }
690     }
691 
692     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
693         uint256 length = ERC721.balanceOf(to);
694         _ownedTokens[to][length] = tokenId;
695         _ownedTokensIndex[tokenId] = length;
696     }
697 
698     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
699         _allTokensIndex[tokenId] = _allTokens.length;
700         _allTokens.push(tokenId);
701     }
702 
703     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
704       
705         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
706         uint256 tokenIndex = _ownedTokensIndex[tokenId];
707 
708         // When the token to delete is the last token, the swap operation is unnecessary
709         if (tokenIndex != lastTokenIndex) {
710             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
711 
712             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
713             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
714         }
715 
716         // This also deletes the contents at the last position of the array
717         delete _ownedTokensIndex[tokenId];
718         delete _ownedTokens[from][lastTokenIndex];
719     }
720 
721     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
722     
723         uint256 lastTokenIndex = _allTokens.length - 1;
724         uint256 tokenIndex = _allTokensIndex[tokenId];
725 
726         uint256 lastTokenId = _allTokens[lastTokenIndex];
727 
728         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
729         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
730 
731         // This also deletes the contents at the last position of the array
732         delete _allTokensIndex[tokenId];
733         _allTokens.pop();
734     }
735 }
736 
737 error lengthMismatch();
738 error Paused();
739 error PublicMintStopped();
740 error FreeMintNftSold();
741 error AllSold();
742 error PrivateMintStopped();
743 error WrongProof();
744 error InvalidPrice();
745 error MaxWLMintExceeded();
746 error FreeMintStopped();
747 error MaxMinted();
748 error MaxLimitExceeded();
749 
750 contract ThetTestverse is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {
751 
752     using Strings for uint256;
753     using Counters for Counters.Counter;
754 
755     Counters.Counter internal supply;
756 
757     uint32 public MAXIMUM_SUPPLY = 3897; //3897;   //3600 public & private  -- 297 free mint
758     uint32 FREEMINT = 297; //297;
759     uint32 PPMINT = 3600; //3600;
760 
761     uint256 public Max_Public_Limit = 5;
762 
763     bytes32 merkleRoot_oneNft;
764     bytes32 merkleRoot_twoNft;
765     bytes32 merkleRoot_threeNft;
766     bytes32 merkleRoot_FreeNft;
767     bytes32 merkleRoot_FreeLimit;
768 
769     //Price will be 0.05 Eth for all in start 
770     uint128 public PUBLIC_MINT_COST = 0.049 ether; 
771     uint128 public ONE_MINT_COST = 0.039 ether;
772     uint128 public TWO_MINT_COST = 0.039 ether;
773     uint128 public THREE_MINT_COST = 0.039 ether;
774 
775     mapping (address => uint32) public WL_DB;
776 
777     uint8 public paused = 2;
778     uint8 public privateMintpauser = 2;
779     uint8 public freeMintpauser = 2;
780     uint8 public publicMintpauser = 2;
781 
782     bool public isRevealed = false;
783 
784     string public baseURI;
785     string public notRevealedUri = 'ipfs://QmbbDZrimBs5q2xafEvNPmFUKVBPxfTsaXueSrGSK6gYMY/';
786 
787     uint16 public counterFeeMint;
788     uint16 public counterPPMint;
789 
790     string uriPrefix = "";
791     string public uriSuffix = ".json";
792 
793     uint96 royalityFeeInBips;
794     string contractUri = 'https://gateway.pinata.cloud/ipfs/QmVtE213rJGXx4pQa8Ay1rUabpDNnTes3F23V65KXrYvBs/';
795     address RoyalityReciever;
796 
797     constructor() ERC721("The Triverse", "TRV") {
798         royalityFeeInBips = 630;
799         RoyalityReciever = 0x0E75B9BC6018CEd3F04986E80D3689797E39EF8F;
800     }
801 
802     function publicMint(uint _amount) public payable nonReentrant() {
803         
804         pauser();   
805         MaxLimit(_amount);
806         PublicMintChecker();
807         maxlimitchecker(_amount);
808 
809         if(counterPPMint + _amount > PPMINT) {
810             revert AllSold();
811         }
812         
813         uint256 value = msg.value;
814         uint256 subtotal = PUBLIC_MINT_COST * _amount;
815 
816         if(value != subtotal) {
817             revert InvalidPrice();
818         }
819         
820         for(uint i = 0; i < _amount; i++) {
821             supply.increment();
822             _safeMint(msg.sender, supply.current());
823             counterPPMint++;
824         }
825     }
826 
827     function privateMint(bytes32[] calldata _merkleProof) public payable nonReentrant() {
828         
829         pauser();   
830         PrivateMintChecker();
831         maxlimitchecker(1);
832 
833         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
834         
835         if(counterPPMint + 1 > PPMINT) {
836             revert AllSold();
837         }
838 
839         uint256 value = msg.value;
840         
841         if(MerkleProof.verify(_merkleProof, merkleRoot_oneNft, leaf)) {   //1
842             if(value != ONE_MINT_COST) {
843                 revert InvalidPrice();
844             }
845             if(WL_DB[msg.sender] == 1) {
846                 revert MaxWLMintExceeded();
847             }
848             supply.increment();
849             _safeMint(msg.sender, supply.current());
850             WL_DB[msg.sender]++;  
851             counterPPMint++;
852         }
853         else if(MerkleProof.verify(_merkleProof, merkleRoot_twoNft, leaf)) {  //2
854             if(value != TWO_MINT_COST) {
855                 revert InvalidPrice();
856             }
857             if(WL_DB[msg.sender] == 2) {
858                 revert MaxWLMintExceeded();
859             }
860             supply.increment();
861             _safeMint(msg.sender, supply.current());
862             WL_DB[msg.sender]++;
863             counterPPMint++;
864         }
865         else if(MerkleProof.verify(_merkleProof, merkleRoot_threeNft, leaf)) { //3
866             if(value != THREE_MINT_COST) {
867                 revert InvalidPrice();
868             }
869             if(WL_DB[msg.sender] == 3) {
870                 revert MaxWLMintExceeded();
871             }
872             supply.increment();
873             _safeMint(msg.sender, supply.current());
874             WL_DB[msg.sender]++;
875             counterPPMint++;
876         }
877         else {
878             revert WrongProof();
879         }
880         
881     }
882 
883     //ask mint user total
884 
885     function freeMint(bytes32[] calldata _merkleProof) public nonReentrant() {
886         
887         pauser();   
888         FreeMintChecker();
889         maxlimitchecker(1);
890 
891         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
892         if(counterFeeMint + 1 > FREEMINT){
893             revert FreeMintNftSold();
894         }
895         
896         
897         if(MerkleProof.verify(_merkleProof, merkleRoot_FreeNft, leaf)) {  //4
898             if(WL_DB[msg.sender] == 1) {
899                 revert MaxWLMintExceeded();
900             }
901             supply.increment();
902             _safeMint(msg.sender, supply.current());
903             WL_DB[msg.sender]++;
904             counterFeeMint++;
905         }
906         else if (MerkleProof.verify(_merkleProof, merkleRoot_FreeLimit, leaf)) {
907             supply.increment();
908             _safeMint(msg.sender, supply.current());
909             counterFeeMint++;
910         }
911         else {
912             revert WrongProof();
913         }
914         
915     }
916 
917     function gift(address addresses) public onlyOwner {
918         maxlimitchecker(1);
919         supply.increment();
920         _safeMint(addresses, supply.current());
921     }
922 
923     //ERROR HANDLING
924 
925     function FreeMintChecker() internal view {
926         if(freeMintpauser == 1) {
927             revert FreeMintStopped(); 
928         }
929     }
930 
931     function PrivateMintChecker() internal view {
932         if(privateMintpauser == 1) {
933             revert PrivateMintStopped(); 
934         }
935     }
936 
937     function maxlimitchecker(uint256 _amount) internal view {
938         if(totalSupply() + _amount > MAXIMUM_SUPPLY) {
939             revert MaxMinted();
940         }
941     }
942 
943     function pauser() internal view {
944         if(paused == 1) {
945             revert Paused();
946         }
947     }
948 
949     function PublicMintChecker() internal view {
950         if(publicMintpauser == 1) {
951             revert PublicMintStopped();
952         }
953     }
954 
955     function MaxLimit(uint256 _amount) internal view {
956         if(_amount > Max_Public_Limit) {
957             revert MaxLimitExceeded();
958         }
959     }
960 
961     //Setters
962 
963     function setPauser(uint8 _val) public onlyOwner {
964         paused = _val;    //1 -> true , 2 -> false
965     }
966 
967     function enablePrivateMint(uint8 _val) public onlyOwner {
968         privateMintpauser = _val;    //1 -> true , 2 -> false
969     }
970 
971     function enableFreeMint(uint8 _val) public onlyOwner {
972         freeMintpauser = _val;    //1 -> true , 2 -> false
973     }    
974 
975     function enablePublicMint(uint8 _val) public onlyOwner {
976         publicMintpauser = _val;
977     }
978 
979     function setPublicCost(uint128 _value) public onlyOwner {
980         PUBLIC_MINT_COST = _value;
981     }
982 
983     function changePublicLimit(uint256 _val) public onlyOwner {
984         Max_Public_Limit = _val;
985     }
986 
987     function setOneMintCost(uint128 _value) public onlyOwner {
988         ONE_MINT_COST = _value;
989     }
990 
991     function setTwoMintCost(uint128 _value) public onlyOwner {
992         TWO_MINT_COST = _value;
993     }
994     
995     function setThreeMintCost(uint128 _value) public onlyOwner {
996         THREE_MINT_COST = _value;
997     }
998 
999     function hasWhitelist(bytes32[] calldata _merkleProof,address account) public view returns (bool , uint) {
1000         bytes32 leaf = keccak256(abi.encodePacked(account));
1001         if(MerkleProof.verify(_merkleProof, merkleRoot_oneNft, leaf)) {
1002             return (true,1);
1003         }
1004         else if(MerkleProof.verify(_merkleProof, merkleRoot_twoNft, leaf)) {
1005             return (true,2);
1006         }
1007         else if(MerkleProof.verify(_merkleProof, merkleRoot_threeNft, leaf)) {
1008             return (true,3);
1009         }
1010         else if(MerkleProof.verify(_merkleProof, merkleRoot_FreeNft, leaf)) {
1011             return (true,4);
1012         }
1013         else if (MerkleProof.verify(_merkleProof, merkleRoot_FreeLimit, leaf)) {
1014             return (true,5);
1015         }        
1016         else {
1017             return (false,0);
1018         }
1019     }
1020     
1021 
1022     function walletOfOwner(address _owner)
1023         public
1024         view
1025         returns (uint256[] memory)
1026     {
1027         uint256 ownerTokenCount = balanceOf(_owner);
1028         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1029         uint256 currentTokenId = 0;
1030         uint256 ownedTokenIndex = 0;
1031 
1032         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAXIMUM_SUPPLY) {
1033             address currentTokenOwner = ownerOf(currentTokenId);
1034 
1035             if (currentTokenOwner == _owner) {
1036                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1037                 ownedTokenIndex++;
1038             }
1039             currentTokenId++;
1040         }
1041 
1042         return ownedTokenIds;
1043     }
1044 
1045     function setRoots(bytes32[] calldata _roots) public {
1046         if(_roots.length < 4) revert lengthMismatch();
1047         merkleRoot_oneNft = _roots[0];
1048         merkleRoot_twoNft = _roots[1];
1049         merkleRoot_threeNft = _roots[2];
1050         merkleRoot_FreeNft = _roots[3];
1051         merkleRoot_FreeLimit = _roots[4];
1052     }
1053 
1054     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1055         require(
1056         _exists(tokenId),
1057         "ERC721Metadata: URI query for nonexistent token"
1058         );
1059 
1060         if (isRevealed == false) {
1061             return notRevealedUri;
1062         }
1063 
1064         string memory currentBaseURI = _baseURI();
1065         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), uriSuffix)) : "";
1066     }
1067 
1068     function reveal() public onlyOwner {
1069         isRevealed = true;
1070     }
1071 
1072     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1073         notRevealedUri = _notRevealedURI;
1074     }
1075 
1076     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1077         uriPrefix = _newBaseURI;
1078     }
1079 
1080     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1081         uriSuffix = _uriSuffix;
1082     }
1083 
1084     function _baseURI() internal view virtual override returns (string memory) {
1085         return uriPrefix;
1086     }
1087 
1088     function withdraw() public onlyOwner {
1089         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1090         require(os);
1091     }
1092 
1093     function contractURI() public view returns (string memory) {
1094         return contractUri;
1095     }
1096 
1097     function royaltyInfo(
1098         uint256 _tokenId,
1099         uint256 _salePrice
1100     ) external view returns (
1101         address receiver,
1102         uint256 royaltyAmount
1103     ) {
1104         if(_tokenId>=0){}
1105         return (RoyalityReciever , calculateRoyality(_salePrice));
1106     }
1107 
1108     function calculateRoyality(uint256 _salePrice) internal view returns (uint256){
1109         return (_salePrice / 10000) * royalityFeeInBips; 
1110     }
1111 
1112     function setRoyalityInfo(address _Reciever, uint96 _royalityFeeInBips) public onlyOwner {
1113         royalityFeeInBips = _royalityFeeInBips;
1114         RoyalityReciever = _Reciever;
1115     }
1116 
1117     function setContractUri(string calldata _contrctURI) public onlyOwner {
1118         contractUri = _contrctURI;
1119     } 
1120 
1121     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1122         internal
1123         override(ERC721, ERC721Enumerable)
1124     {
1125         super._beforeTokenTransfer(from, to, tokenId);
1126     }
1127 
1128     function supportsInterface(bytes4 interfaceId)
1129         public 
1130         view
1131         override(ERC721, ERC721Enumerable)
1132         returns (bool)
1133     {
1134         return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
1135     } 
1136 
1137     receive() external payable {}
1138 
1139 }