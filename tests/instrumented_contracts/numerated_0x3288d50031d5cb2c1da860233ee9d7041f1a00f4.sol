1 pragma solidity ^0.8.0;
2 
3 
4 interface IERC165 {
5     
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 
10 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
11 
12 pragma solidity ^0.8.0;
13 
14 
15 interface IERC721 is IERC165 {
16     
17     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
18 
19    
20     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
21 
22     
23     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
24 
25     
26     function balanceOf(address owner) external view returns (uint256 balance);
27 
28     
29     function ownerOf(uint256 tokenId) external view returns (address owner);
30 
31     
32     function safeTransferFrom(address from, address to, uint256 tokenId) external;
33 
34     
35     function transferFrom(address from, address to, uint256 tokenId) external;
36 
37     
38     function approve(address to, uint256 tokenId) external;
39 
40     
41     function getApproved(uint256 tokenId) external view returns (address operator);
42 
43     
44     function setApprovalForAll(address operator, bool _approved) external;
45 
46    
47     function isApprovedForAll(address owner, address operator) external view returns (bool);
48 
49     
50     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
51 }
52 
53 
54 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
55 
56 pragma solidity ^0.8.0;
57 
58 
59 interface IERC721Receiver {
60     
61     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
62 }
63 
64 
65 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
66 
67 pragma solidity ^0.8.0;
68 
69 
70 interface IERC721Metadata is IERC721 {
71 
72    
73     function name() external view returns (string memory);
74 
75     
76     function symbol() external view returns (string memory);
77 
78     
79     function tokenURI(uint256 tokenId) external view returns (string memory);
80 }
81 
82 
83 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
84 
85 pragma solidity ^0.8.0;
86 
87 
88 library Address {
89     
90     function isContract(address account) internal view returns (bool) {
91         // This method relies on extcodesize, which returns 0 for contracts in
92         // construction, since the code is only stored at the end of the
93         // constructor execution.
94 
95         uint256 size;
96         // solhint-disable-next-line no-inline-assembly
97         assembly { size := extcodesize(account) }
98         return size > 0;
99     }
100 
101     
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
106         (bool success, ) = recipient.call{ value: amount }("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110    
111     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
112       return functionCall(target, data, "Address: low-level call failed");
113     }
114 
115    
116     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, 0, errorMessage);
118     }
119 
120    
121     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     
126     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
127         require(address(this).balance >= value, "Address: insufficient balance for call");
128         require(isContract(target), "Address: call to non-contract");
129 
130         // solhint-disable-next-line avoid-low-level-calls
131         (bool success, bytes memory returndata) = target.call{ value: value }(data);
132         return _verifyCallResult(success, returndata, errorMessage);
133     }
134 
135     
136     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
137         return functionStaticCall(target, data, "Address: low-level static call failed");
138     }
139 
140    
141     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
142         require(isContract(target), "Address: static call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     
150     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
152     }
153 
154    
155     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
156         require(isContract(target), "Address: delegate call to non-contract");
157 
158         // solhint-disable-next-line avoid-low-level-calls
159         (bool success, bytes memory returndata) = target.delegatecall(data);
160         return _verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
164         if (success) {
165             return returndata;
166         } else {
167             // Look for revert reason and bubble it up if present
168             if (returndata.length > 0) {
169                 // The easiest way to bubble the revert reason is using memory via assembly
170 
171                 // solhint-disable-next-line no-inline-assembly
172                 assembly {
173                     let returndata_size := mload(returndata)
174                     revert(add(32, returndata), returndata_size)
175                 }
176             } else {
177                 revert(errorMessage);
178             }
179         }
180     }
181 }
182 
183 
184 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
185 
186 pragma solidity ^0.8.0;
187 
188 
189 abstract contract Context {
190     function _msgSender() internal view virtual returns (address) {
191         return msg.sender;
192     }
193 
194     function _msgData() internal view virtual returns (bytes calldata) {
195         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
196         return msg.data;
197     }
198 }
199 
200 
201 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
202 
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev String operations.
208  */
209 library Strings {
210     bytes16 private constant alphabet = "0123456789abcdef";
211 
212     
213     function toString(uint256 value) internal pure returns (string memory) {
214         
215         if (value == 0) {
216             return "0";
217         }
218         uint256 temp = value;
219         uint256 digits;
220         while (temp != 0) {
221             digits++;
222             temp /= 10;
223         }
224         bytes memory buffer = new bytes(digits);
225         while (value != 0) {
226             digits -= 1;
227             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
228             value /= 10;
229         }
230         return string(buffer);
231     }
232 
233     
234     function toHexString(uint256 value) internal pure returns (string memory) {
235         if (value == 0) {
236             return "0x00";
237         }
238         uint256 temp = value;
239         uint256 length = 0;
240         while (temp != 0) {
241             length++;
242             temp >>= 8;
243         }
244         return toHexString(value, length);
245     }
246 
247     
248     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
249         bytes memory buffer = new bytes(2 * length + 2);
250         buffer[0] = "0";
251         buffer[1] = "x";
252         for (uint256 i = 2 * length + 1; i > 1; --i) {
253             buffer[i] = alphabet[value & 0xf];
254             value >>= 4;
255         }
256         require(value == 0, "Strings: hex length insufficient");
257         return string(buffer);
258     }
259 
260 }
261 
262 
263 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
264 
265 
266 pragma solidity ^0.8.0;
267 
268 
269 abstract contract ERC165 is IERC165 {
270     
271     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
272         return interfaceId == type(IERC165).interfaceId;
273     }
274 }
275 
276 
277 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
278 
279 
280 pragma solidity ^0.8.0;
281 
282 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
283     using Address for address;
284     using Strings for uint256;
285 
286     // Token name
287     string private _name;
288 
289     // Token symbol
290     string private _symbol;
291 
292     // Mapping from token ID to owner address
293     mapping (uint256 => address) private _owners;
294 
295     // Mapping owner address to token count
296     mapping (address => uint256) private _balances;
297 
298     // Mapping from token ID to approved address
299     mapping (uint256 => address) private _tokenApprovals;
300 
301     // Mapping from owner to operator approvals
302     mapping (address => mapping (address => bool)) private _operatorApprovals;
303 
304     
305     constructor (string memory name_, string memory symbol_) {
306         _name = name_;
307         _symbol = symbol_;
308     }
309 
310     
311     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
312         return interfaceId == type(IERC721).interfaceId
313             || interfaceId == type(IERC721Metadata).interfaceId
314             || super.supportsInterface(interfaceId);
315     }
316 
317     
318     function balanceOf(address owner) public view virtual override returns (uint256) {
319         require(owner != address(0), "ERC721: balance query for the zero address");
320         return _balances[owner];
321     }
322 
323    
324     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
325         address owner = _owners[tokenId];
326         require(owner != address(0), "ERC721: owner query for nonexistent token");
327         return owner;
328     }
329 
330     
331     function name() public view virtual override returns (string memory) {
332         return _name;
333     }
334 
335     
336     function symbol() public view virtual override returns (string memory) {
337         return _symbol;
338     }
339 
340     
341     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
342         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
343 
344         string memory baseURI = _baseURI();
345         return bytes(baseURI).length > 0
346             ? string(abi.encodePacked(baseURI, tokenId.toString()))
347             : '';
348     }
349 
350    
351     function _baseURI() internal view virtual returns (string memory) {
352         return "";
353     }
354 
355     
356     function approve(address to, uint256 tokenId) public virtual override {
357         address owner = ERC721.ownerOf(tokenId);
358         require(to != owner, "ERC721: approval to current owner");
359 
360         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
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
387     
388     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
389         //solhint-disable-next-line max-line-length
390         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
391 
392         _transfer(from, to, tokenId);
393     }
394 
395     
396     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
397         safeTransferFrom(from, to, tokenId, "");
398     }
399 
400     
401     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
402         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
403         _safeTransfer(from, to, tokenId, _data);
404     }
405 
406     
407     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
408         _transfer(from, to, tokenId);
409         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
410     }
411 
412    
413     function _exists(uint256 tokenId) internal view virtual returns (bool) {
414         return _owners[tokenId] != address(0);
415     }
416 
417     
418     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
419         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
420         address owner = ERC721.ownerOf(tokenId);
421         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
422     }
423 
424     
425     function _safeMint(address to, uint256 tokenId) internal virtual {
426         _safeMint(to, tokenId, "");
427     }
428 
429     
430     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
431         _mint(to, tokenId);
432         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
433     }
434 
435     
436     function _mint(address to, uint256 tokenId) internal virtual {
437         require(to != address(0), "ERC721: mint to the zero address");
438         require(!_exists(tokenId), "ERC721: token already minted");
439 
440         _beforeTokenTransfer(address(0), to, tokenId);
441 
442         _balances[to] += 1;
443         _owners[tokenId] = to;
444 
445         emit Transfer(address(0), to, tokenId);
446     }
447 
448    
449     function _burn(uint256 tokenId) internal virtual {
450         address owner = ERC721.ownerOf(tokenId);
451 
452         _beforeTokenTransfer(owner, address(0), tokenId);
453 
454         // Clear approvals
455         _approve(address(0), tokenId);
456 
457         _balances[owner] -= 1;
458         delete _owners[tokenId];
459 
460         emit Transfer(owner, address(0), tokenId);
461     }
462 
463     
464     function _transfer(address from, address to, uint256 tokenId) internal virtual {
465         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
466         require(to != address(0), "ERC721: transfer to the zero address");
467 
468         _beforeTokenTransfer(from, to, tokenId);
469 
470         // Clear approvals from the previous owner
471         _approve(address(0), tokenId);
472 
473         _balances[from] -= 1;
474         _balances[to] += 1;
475         _owners[tokenId] = to;
476 
477         emit Transfer(from, to, tokenId);
478     }
479 
480    
481     function _approve(address to, uint256 tokenId) internal virtual {
482         _tokenApprovals[tokenId] = to;
483         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
484     }
485 
486     
487     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
488         private returns (bool)
489     {
490         if (to.isContract()) {
491             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
492                 return retval == IERC721Receiver(to).onERC721Received.selector;
493             } catch (bytes memory reason) {
494                 if (reason.length == 0) {
495                     revert("ERC721: transfer to non ERC721Receiver implementer");
496                 } else {
497                     // solhint-disable-next-line no-inline-assembly
498                     assembly {
499                         revert(add(32, reason), mload(reason))
500                     }
501                 }
502             }
503         } else {
504             return true;
505         }
506     }
507 
508     
509     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
510 }
511 
512 
513 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.1.0
514 
515 
516 pragma solidity ^0.8.0;
517 
518 
519 interface IERC721Enumerable is IERC721 {
520 
521     
522     function totalSupply() external view returns (uint256);
523 
524     
525     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
526 
527     
528     function tokenByIndex(uint256 index) external view returns (uint256);
529 }
530 
531 
532 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.1.0
533 
534 
535 pragma solidity ^0.8.0;
536 
537 
538 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
539     // Mapping from owner to list of owned token IDs
540     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
541 
542     // Mapping from token ID to index of the owner tokens list
543     mapping(uint256 => uint256) private _ownedTokensIndex;
544 
545     // Array with all token ids, used for enumeration
546     uint256[] private _allTokens;
547 
548     // Mapping from token id to position in the allTokens array
549     mapping(uint256 => uint256) private _allTokensIndex;
550 
551    
552     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
553         return interfaceId == type(IERC721Enumerable).interfaceId
554             || super.supportsInterface(interfaceId);
555     }
556 
557     
558     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
559         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
560         return _ownedTokens[owner][index];
561     }
562 
563     
564     function totalSupply() public view virtual override returns (uint256) {
565         return _allTokens.length;
566     }
567 
568     
569     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
570         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
571         return _allTokens[index];
572     }
573 
574     
575     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
576         super._beforeTokenTransfer(from, to, tokenId);
577 
578         if (from == address(0)) {
579             _addTokenToAllTokensEnumeration(tokenId);
580         } else if (from != to) {
581             _removeTokenFromOwnerEnumeration(from, tokenId);
582         }
583         if (to == address(0)) {
584             _removeTokenFromAllTokensEnumeration(tokenId);
585         } else if (to != from) {
586             _addTokenToOwnerEnumeration(to, tokenId);
587         }
588     }
589 
590     
591     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
592         uint256 length = ERC721.balanceOf(to);
593         _ownedTokens[to][length] = tokenId;
594         _ownedTokensIndex[tokenId] = length;
595     }
596 
597     
598     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
599         _allTokensIndex[tokenId] = _allTokens.length;
600         _allTokens.push(tokenId);
601     }
602 
603     
604     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
605         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
606         // then delete the last slot (swap and pop).
607 
608         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
609         uint256 tokenIndex = _ownedTokensIndex[tokenId];
610 
611         // When the token to delete is the last token, the swap operation is unnecessary
612         if (tokenIndex != lastTokenIndex) {
613             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
614 
615             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
616             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
617         }
618 
619         // This also deletes the contents at the last position of the array
620         delete _ownedTokensIndex[tokenId];
621         delete _ownedTokens[from][lastTokenIndex];
622     }
623 
624     
625     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
626         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
627         // then delete the last slot (swap and pop).
628 
629         uint256 lastTokenIndex = _allTokens.length - 1;
630         uint256 tokenIndex = _allTokensIndex[tokenId];
631 
632         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
633         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
634         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
635         uint256 lastTokenId = _allTokens[lastTokenIndex];
636 
637         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
638         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
639 
640         // This also deletes the contents at the last position of the array
641         delete _allTokensIndex[tokenId];
642         _allTokens.pop();
643     }
644 }
645 
646 
647 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
648 
649 
650 pragma solidity ^0.8.0;
651 
652 
653 abstract contract Ownable is Context {
654     address private _owner;
655 
656     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
657 
658    
659     constructor () {
660         address msgSender = _msgSender();
661         _owner = msgSender;
662         emit OwnershipTransferred(address(0), msgSender);
663     }
664 
665    
666     function owner() public view virtual returns (address) {
667         return _owner;
668     }
669 
670     
671     modifier onlyOwner() {
672         require(owner() == _msgSender(), "Ownable: caller is not the owner");
673         _;
674     }
675 
676     
677     function transferOwnership(address newOwner) public virtual onlyOwner {
678         require(newOwner != address(0), "Ownable: new owner is the zero address");
679         emit OwnershipTransferred(_owner, newOwner);
680         _owner = newOwner;
681     }
682 }
683 
684 
685 // File contracts/SRSC.sol
686 
687 pragma solidity ^0.8.0;
688 contract WTF is ERC721Enumerable, Ownable {
689     uint public constant MAX_WTF = 2000;
690     string _baseTokenURI;
691     bool public paused = true;
692 
693     constructor(string memory baseURI) ERC721("WTF", "WTF")  {
694         setBaseURI(baseURI);
695     }
696 
697     modifier saleIsOpen{
698         require(totalSupply() < MAX_WTF, "Sale end");
699         _;
700     }
701 
702     
703     function reserveWTF() public onlyOwner {
704         uint supply = totalSupply();
705         uint i;
706         for (i = 0; i < 30; i++) {
707             _safeMint(msg.sender, supply + i);
708         }
709     }
710 
711 
712     function mintWTF(address _to, uint _count) public payable saleIsOpen {
713         if(msg.sender != owner()){
714             require(!paused, "Paused");
715         }
716         require(totalSupply() + _count <= MAX_WTF, "Max limit");
717         require(totalSupply() < MAX_WTF, "Sale end");
718         require(_count <= 10, "Exceeds 10");
719         require(msg.value >= price(_count), "Value below price");
720 
721         for(uint i = 0; i < _count; i++){
722             _safeMint(_to, totalSupply());
723         }
724     }
725 
726     function price(uint _count) public view returns (uint256) {
727         return 0 * _count; 
728     }
729 
730     function contractURI() public view returns (string memory) {
731         return "ipfs://Qme6q6FqyG6Hnwzn2gRN2dSz3C8TphchP9aBNhUAo1KwiH";
732     }
733 
734     function _baseURI() internal view virtual override returns (string memory) {
735         return _baseTokenURI;
736     }
737     function setBaseURI(string memory baseURI) public onlyOwner {
738         _baseTokenURI = baseURI;
739     }
740 
741     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
742         uint tokenCount = balanceOf(_owner);
743 
744         uint256[] memory tokensId = new uint256[](tokenCount);
745         for(uint i = 0; i < tokenCount; i++){
746             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
747         }
748 
749         return tokensId;
750     }
751 
752     function pause(bool val) public onlyOwner {
753         paused = val;
754     }
755 
756     function withdrawAll() public payable onlyOwner {
757         require(payable(_msgSender()).send(address(this).balance));
758     }
759 }