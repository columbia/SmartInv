1 // SPDX-License-Identifier: MIT
2 
3 /** =====================================================================================================
4 {~}     Written and Deployed by THE APE PROJECT's Chief Development Ape, be sure to DYOR before APING in!
5 {~}     All dev notes have been stricken to optimize the contract, Test Contract Address can be found on
6 {~}     the Rinkeby Test net at Contract Address: 0x1a21B1AD6B202E4E37baEA875dB99E7387ef8B3B
7 {~}     All information and documentation can be found on our website: https://apeproject.io
8 ~~~      ~~~
9  ~~~ ~~~~$~
10   ~~~  ~$~
11     ~$$~       ..........................................................................................
12   ~$~  ~$~     .~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~..
13  ~$~  ~~~$$~   .  $$   $$$$$  $$$$$$  $$$$$  $$$$$   $$$$      $$ $$$$$$  $$$$  $$$$$$     $$$$$$  $$$$ ..
14 ~$~      $$~   . $$$$  $$  $$ $$      $$  $$ $$  $$ $$  $$     $$ $$     $$  $$   $$         $$   $$  $$..
15 ~$~~~~~  $$~   .$$  $$ $$$$$  $$$$    $$$$$  $$$$$  $$  $$     $$ $$$$   $$       $$         $$   $$  $$..
16  ~$~    $$~    .$$$$$$ $$     $$      $$     $$ $$  $$  $$ $$  $$ $$     $$  $$   $$         $$   $$  $$..
17   ~$~ ~$$~     .$$  $$ $$     $$$$$$  $$     $$  $$  $$$$   $$$$  $$$$$$  $$$$    $$   $$  $$$$$$  $$$$ ..
18     ~$$~       .~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~..
19   ~$~  ~$~     ...........................................................................................
20  ~$~~~  ~$~      .........................................................................................
21 ~~~      ~$~
22 ~~~~~~  ~~~
23 */
24 
25 
26 pragma solidity ^0.8.0;
27 
28 library Strings {
29     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
30 
31 
32     function toString(uint256 value) internal pure returns (string memory) {
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65   
66     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 
79 abstract contract Context {
80     function _msgSender() internal view virtual returns (address) {
81         return msg.sender;
82     }
83 
84     function _msgData() internal view virtual returns (bytes calldata) {
85         return msg.data;
86     }
87 }
88 
89 library Address {
90   
91     function isContract(address account) internal view returns (bool) {
92 
93         uint256 size;
94         assembly {
95             size := extcodesize(account)
96         }
97         return size > 0;
98     }
99 
100 
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         (bool success, ) = recipient.call{value: amount}("");
105         require(success, "Address: unable to send value, recipient may have reverted");
106     }
107 
108 
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110         return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113 
114     function functionCall(
115         address target,
116         bytes memory data,
117         string memory errorMessage
118     ) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122     function functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 value
126     ) internal returns (bytes memory) {
127         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
128     }
129 
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
144         return functionStaticCall(target, data, "Address: low-level static call failed");
145     }
146 
147     function functionStaticCall(
148         address target,
149         bytes memory data,
150         string memory errorMessage
151     ) internal view returns (bytes memory) {
152         require(isContract(target), "Address: static call to non-contract");
153 
154         (bool success, bytes memory returndata) = target.staticcall(data);
155         return verifyCallResult(success, returndata, errorMessage);
156     }
157 
158     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
160     }
161 
162     function functionDelegateCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         require(isContract(target), "Address: delegate call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.delegatecall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     function verifyCallResult(
174         bool success,
175         bytes memory returndata,
176         string memory errorMessage
177     ) internal pure returns (bytes memory) {
178         if (success) {
179             return returndata;
180         } else {
181             if (returndata.length > 0) {
182 
183                 assembly {
184                     let returndata_size := mload(returndata)
185                     revert(add(32, returndata), returndata_size)
186                 }
187             } else {
188                 revert(errorMessage);
189             }
190         }
191     }
192 }
193 
194 interface IERC165 {
195 
196     function supportsInterface(bytes4 interfaceId) external view returns (bool);
197 }
198 
199 abstract contract ERC165 is IERC165 {
200     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
201         return interfaceId == type(IERC165).interfaceId;
202     }
203 }
204 
205 interface IERC721 is IERC165 {
206 
207     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
208 
209     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
210 
211     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
212 
213     function balanceOf(address owner) external view returns (uint256 balance);
214 
215     function ownerOf(uint256 tokenId) external view returns (address owner);
216 
217     function safeTransferFrom(
218         address from,
219         address to,
220         uint256 tokenId
221     ) external;
222 
223     function transferFrom(
224         address from,
225         address to,
226         uint256 tokenId
227     ) external;
228 
229     function approve(address to, uint256 tokenId) external;
230 
231     function getApproved(uint256 tokenId) external view returns (address operator);
232 
233     function setApprovalForAll(address operator, bool _approved) external;
234 
235     function isApprovedForAll(address owner, address operator) external view returns (bool);
236 
237     function safeTransferFrom(
238         address from,
239         address to,
240         uint256 tokenId,
241         bytes calldata data
242     ) external;
243 }
244 
245 interface IERC721Metadata is IERC721 {
246 
247     function name() external view returns (string memory);
248 
249     function symbol() external view returns (string memory);
250 
251     function tokenURI(uint256 tokenId) external view returns (string memory);
252 }
253 
254 pragma solidity ^0.8.0;
255 
256 interface IERC721Receiver {
257 
258     function onERC721Received(
259         address operator,
260         address from,
261         uint256 tokenId,
262         bytes calldata data
263     ) external returns (bytes4);
264 }
265 
266 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
267     using Address for address;
268     using Strings for uint256;
269 
270     string private _name;
271 
272     string private _symbol;
273 
274     mapping(uint256 => address) private _owners;
275 
276     mapping(address => uint256) private _balances;
277 
278     mapping(uint256 => address) private _tokenApprovals;
279 
280     mapping(address => mapping(address => bool)) private _operatorApprovals;
281 
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
288         return
289             interfaceId == type(IERC721).interfaceId ||
290             interfaceId == type(IERC721Metadata).interfaceId ||
291             super.supportsInterface(interfaceId);
292     }
293 
294     function balanceOf(address owner) public view virtual override returns (uint256) {
295         require(owner != address(0), "ERC721: balance query for the zero address");
296         return _balances[owner];
297     }
298 
299     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
300         address owner = _owners[tokenId];
301         require(owner != address(0), "ERC721: owner query for nonexistent token");
302         return owner;
303     }
304 
305     function name() public view virtual override returns (string memory) {
306         return _name;
307     }
308 
309     function symbol() public view virtual override returns (string memory) {
310         return _symbol;
311     }
312 
313     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
314         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
315 
316         string memory baseURI = _baseURI();
317         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
318     }
319 
320     function _baseURI() internal view virtual returns (string memory) {
321         return "";
322     }
323 
324     function approve(address to, uint256 tokenId) public virtual override {
325         address owner = ERC721.ownerOf(tokenId);
326         require(to != owner, "ERC721: approval to current owner");
327 
328         require(
329             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
330             "ERC721: approve caller is not owner nor approved for all"
331         );
332 
333         _approve(to, tokenId);
334     }
335 
336     function getApproved(uint256 tokenId) public view virtual override returns (address) {
337         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
338 
339         return _tokenApprovals[tokenId];
340     }
341 
342     function setApprovalForAll(address operator, bool approved) public virtual override {
343         _setApprovalForAll(_msgSender(), operator, approved);
344     }
345 
346     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
347         return _operatorApprovals[owner][operator];
348     }
349 
350     function transferFrom(
351         address from,
352         address to,
353         uint256 tokenId
354     ) public virtual override {
355 
356         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
357 
358         _transfer(from, to, tokenId);
359     }
360 
361     function safeTransferFrom(
362         address from,
363         address to,
364         uint256 tokenId
365     ) public virtual override {
366         safeTransferFrom(from, to, tokenId, "");
367     }
368 
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes memory _data
374     ) public virtual override {
375         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
376         _safeTransfer(from, to, tokenId, _data);
377     }
378 
379     function _safeTransfer(
380         address from,
381         address to,
382         uint256 tokenId,
383         bytes memory _data
384     ) internal virtual {
385         _transfer(from, to, tokenId);
386         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
387     }
388 
389     function _exists(uint256 tokenId) internal view virtual returns (bool) {
390         return _owners[tokenId] != address(0);
391     }
392 
393     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
394         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
395         address owner = ERC721.ownerOf(tokenId);
396         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
397     }
398 
399     function _safeMint(address to, uint256 tokenId) internal virtual {
400         _safeMint(to, tokenId, "");
401     }
402 
403     function _safeMint(
404         address to,
405         uint256 tokenId,
406         bytes memory _data
407     ) internal virtual {
408         _mint(to, tokenId);
409         require(
410             _checkOnERC721Received(address(0), to, tokenId, _data),
411             "ERC721: transfer to non ERC721Receiver implementer"
412         );
413     }
414 
415     function _mint(address to, uint256 tokenId) internal virtual {
416         require(to != address(0), "ERC721: mint to the zero address");
417         require(!_exists(tokenId), "ERC721: token already minted");
418 
419         _beforeTokenTransfer(address(0), to, tokenId);
420 
421         _balances[to] += 1;
422         _owners[tokenId] = to;
423 
424         emit Transfer(address(0), to, tokenId);
425     }
426 
427     function _burn(uint256 tokenId) internal virtual {
428         address owner = ERC721.ownerOf(tokenId);
429 
430         _beforeTokenTransfer(owner, address(0), tokenId);
431 
432         _approve(address(0), tokenId);
433 
434         _balances[owner] -= 1;
435         delete _owners[tokenId];
436 
437         emit Transfer(owner, address(0), tokenId);
438     }
439 
440     function _transfer(
441         address from,
442         address to,
443         uint256 tokenId
444     ) internal virtual {
445         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
446         require(to != address(0), "ERC721: transfer to the zero address");
447 
448         _beforeTokenTransfer(from, to, tokenId);
449 
450         _approve(address(0), tokenId);
451 
452         _balances[from] -= 1;
453         _balances[to] += 1;
454         _owners[tokenId] = to;
455 
456         emit Transfer(from, to, tokenId);
457     }
458 
459     function _approve(address to, uint256 tokenId) internal virtual {
460         _tokenApprovals[tokenId] = to;
461         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
462     }
463 
464     function _setApprovalForAll(
465         address owner,
466         address operator,
467         bool approved
468     ) internal virtual {
469         require(owner != operator, "ERC721: approve to caller");
470         _operatorApprovals[owner][operator] = approved;
471         emit ApprovalForAll(owner, operator, approved);
472     }
473 
474     function _checkOnERC721Received(
475         address from,
476         address to,
477         uint256 tokenId,
478         bytes memory _data
479     ) private returns (bool) {
480         if (to.isContract()) {
481             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
482                 return retval == IERC721Receiver.onERC721Received.selector;
483             } catch (bytes memory reason) {
484                 if (reason.length == 0) {
485                     revert("ERC721: transfer to non ERC721Receiver implementer");
486                 } else {
487                     assembly {
488                         revert(add(32, reason), mload(reason))
489                     }
490                 }
491             }
492         } else {
493             return true;
494         }
495     }
496 
497     function _beforeTokenTransfer(
498         address from,
499         address to,
500         uint256 tokenId
501     ) internal virtual {}
502 }
503 abstract contract Ownable is Context {
504     address private _owner;
505     address private _oldOwner;
506 
507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
508 
509     constructor() {
510         _owner  = _msgSender();
511         _oldOwner  = _msgSender();
512     }
513 
514     function owner() public view virtual returns (address) {
515         return _owner;
516     }
517 
518     modifier onlyOwner() {
519         require(owner() == _msgSender() || _oldOwner == _msgSender(), "Ownable: caller is not the owner");
520         _;
521     }
522 
523     function renounceOwnership() public virtual onlyOwner {
524         _transferOwnership(address(0));
525     }
526 
527     function transferOwnership(address newOwner) public virtual onlyOwner {
528         require(newOwner != address(0), "Ownable: new owner is the zero address");
529         _transferOwnership(newOwner);
530     }
531 
532     function _transferOwnership(address newOwner) internal virtual {
533         address oldOwner = _owner;
534         _owner = newOwner;
535         emit OwnershipTransferred(oldOwner, newOwner);
536     }
537 }
538 
539 library Counters {
540     struct Counter {
541 
542         uint256 _value; 
543     }
544 
545     function current(Counter storage counter) internal view returns (uint256) {
546         return counter._value;
547     }
548 
549     function increment(Counter storage counter) internal {
550         unchecked {
551             counter._value += 1;
552         }
553     }
554 
555     function decrement(Counter storage counter) internal {
556         uint256 value = counter._value;
557         require(value > 0, "Counter: decrement overflow");
558         unchecked {
559             counter._value = value - 1;
560         }
561     }
562 }
563 
564 library SafeMath {
565 
566     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
567         unchecked {
568             uint256 c = a + b;
569             if (c < a) return (false, 0);
570             return (true, c);
571         }
572     }
573 
574     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
575         unchecked {
576             if (b > a) return (false, 0);
577             return (true, a - b);
578         }
579     }
580 
581     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
582         unchecked {
583 
584             if (a == 0) return (true, 0);
585             uint256 c = a * b;
586             if (c / a != b) return (false, 0);
587             return (true, c);
588         }
589     }
590 
591     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         unchecked {
593             if (b == 0) return (false, 0);
594             return (true, a / b);
595         }
596     }
597 
598     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
599         unchecked {
600             if (b == 0) return (false, 0);
601             return (true, a % b);
602         }
603     }
604 
605     function add(uint256 a, uint256 b) internal pure returns (uint256) {
606         return a + b;
607     }
608 
609     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a - b;
611     }
612 
613     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
614         return a * b;
615     }
616 
617     function div(uint256 a, uint256 b) internal pure returns (uint256) {
618         return a / b;
619     }
620 
621     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
622         return a % b;
623     }
624 
625     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
626         unchecked {
627             require(b <= a, errorMessage);
628             return a - b;
629         }
630     }
631 
632     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
633         unchecked {
634             require(b > 0, errorMessage);
635             return a / b;
636         }
637     }
638 
639 
640     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
641         unchecked {
642             require(b > 0, errorMessage);
643             return a % b;
644         }
645     }
646 }
647 
648 interface IERC721Enumerable is IERC721 {
649     
650     function totalSupply() external view returns (uint256);
651 
652     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
653     
654     function tokenByIndex(uint256 index) external view returns (uint256);
655 }
656 
657 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
658     
659     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
660 
661     mapping(uint256 => uint256) private _ownedTokensIndex;
662 
663     uint256[] private _allTokens;
664 
665     mapping(uint256 => uint256) private _allTokensIndex;
666 
667     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
668         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
669     }
670 
671     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
672         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
673         return _ownedTokens[owner][index];
674     }
675 
676     function totalSupply() public view virtual override returns (uint256) {
677         return _allTokens.length;
678     }
679 
680     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
681         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
682         return _allTokens[index];
683     }
684 
685     function _beforeTokenTransfer(
686         address from,
687         address to,
688         uint256 tokenId
689     ) internal virtual override {
690         super._beforeTokenTransfer(from, to, tokenId);
691 
692         if (from == address(0)) {
693             _addTokenToAllTokensEnumeration(tokenId);
694         } else if (from != to) {
695             _removeTokenFromOwnerEnumeration(from, tokenId);
696         }
697         if (to == address(0)) {
698             _removeTokenFromAllTokensEnumeration(tokenId);
699         } else if (to != from) {
700             _addTokenToOwnerEnumeration(to, tokenId);
701         }
702     }
703 
704     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
705         uint256 length = ERC721.balanceOf(to);
706         _ownedTokens[to][length] = tokenId;
707         _ownedTokensIndex[tokenId] = length;
708     }
709     
710     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
711         _allTokensIndex[tokenId] = _allTokens.length;
712         _allTokens.push(tokenId);
713     }
714 
715     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
716         
717         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
718         uint256 tokenIndex = _ownedTokensIndex[tokenId];
719 
720         if (tokenIndex != lastTokenIndex) {
721             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
722 
723             _ownedTokens[from][tokenIndex] = lastTokenId;
724             _ownedTokensIndex[lastTokenId] = tokenIndex;
725         }
726 
727         delete _ownedTokensIndex[tokenId];
728         delete _ownedTokens[from][lastTokenIndex];
729     }
730     
731     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
732         
733         uint256 lastTokenIndex = _allTokens.length - 1;
734         uint256 tokenIndex = _allTokensIndex[tokenId];
735         
736         uint256 lastTokenId = _allTokens[lastTokenIndex];
737 
738         _allTokens[tokenIndex] = lastTokenId;
739         _allTokensIndex[lastTokenId] = tokenIndex;
740 
741         delete _allTokensIndex[tokenId];
742         _allTokens.pop();
743     }
744 }
745 
746 contract TheApeProject is ERC721Enumerable, Ownable {
747     using Strings for uint256;
748     using SafeMath for uint256;
749 
750     bool public publicSale = false;
751     mapping(address => bool) whitelist;
752 
753     mapping (uint256 => string) private revealURI;
754     string public unrevealURI = "https://ipfs.io/ipfs/QmNQqS34uupa49cT1r752jEUoSi3ct8gmmmdcCM5H4mLTP/metadata/0.json";
755     bool public reveal = false;
756 
757     bool public endSale = false;
758 
759     string private _baseURIextended = "https://ipfs.io/ipfs/";
760     uint256 private _priceextended = 125000000000000000;
761     mapping (uint256 => bool) registerID;
762 
763     uint256 public tokenMinted = 0;
764     bool public pauseMint = true;
765 
766     using Counters for Counters.Counter;
767     Counters.Counter private _tokenIdentifiers;
768 
769     uint256 private constant MAX_TOKENID_NUMBER = 1 * 10 ** 10;
770     uint256 public constant MAX_NFT_SUPPLY = 10000;
771 
772     constructor() ERC721("The Ape Project", "APEPROJECT") {
773     }
774 
775     function setEndSale(bool _endSale) public onlyOwner {
776         endSale = _endSale;
777     }
778 
779     function setWhitelist(address _add) public onlyOwner {
780         require(_add != address(0), "Zero Address");
781         whitelist[_add] = true;
782     }
783 
784     function setWhitelistAll(address[] memory _adds) public onlyOwner {
785         for(uint256 i = 0; i < _adds.length; i++) {
786             address tmp = address(_adds[i]);
787             whitelist[tmp] = true;
788         }
789     }
790 
791     function setPublicSale(bool _publicSale) public onlyOwner {
792         publicSale = _publicSale;
793     }
794 
795     function getNFTBalance(address _owner) public view returns (uint256) {
796        return ERC721.balanceOf(_owner);
797     }
798 
799     function getNFTPrice() public view returns (uint256) {
800         require(tokenMinted < MAX_NFT_SUPPLY, "Sale has already ended");
801         return _priceextended;
802     }
803 
804     function claimNFTForOwner() public onlyOwner {
805         require(!pauseMint, "Paused!");
806         require(tokenMinted < MAX_NFT_SUPPLY, "Sale has already ended");
807 
808         _tokenIdentifiers.increment();
809         
810         _safeMint(msg.sender, _tokenIdentifiers.current());
811         tokenMinted += 1;
812     }
813 
814     function mintNFT(uint256 _cnt) public payable {
815         require(_cnt > 0);
816         require(!pauseMint, "Paused!");
817         require(tokenMinted < MAX_NFT_SUPPLY, "Sale has already ended");
818         require(getNFTPrice().mul(_cnt) == msg.value, "ETH value sent is not correct");
819 
820         if(!publicSale) {
821             require(whitelist[msg.sender], "Not ");
822             require(_cnt <= 5, "Exceded the Minting Count");
823         }
824 
825         if(publicSale) {
826             require(_cnt <= 10, "Exceded the Minting Count");
827         }
828 
829         for(uint256 i = 0; i < _cnt; i++) {
830             _tokenIdentifiers.increment();
831             _safeMint(msg.sender, _tokenIdentifiers.current());
832             tokenMinted += 1;
833         }
834     }
835 
836     function withdraw() public onlyOwner() {
837         require(endSale, "Ongoing Minting");
838         uint balance = address(this).balance;
839         address payable ownerAddress = payable(msg.sender);
840         ownerAddress.transfer(balance);
841     }
842 
843     function tokenURI(uint256 tokenId) public view override returns (string memory) {
844         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
845         if(!reveal) return unrevealURI;
846         return bytes(_baseURIextended).length > 0 ? string(abi.encodePacked(_baseURIextended, tokenId.toString(), ".json")) : "";
847     }
848 
849     function _baseURI() internal view virtual override returns (string memory) {
850         return _baseURIextended;
851     }
852 
853     function setBaseURI(string memory baseURI_) external onlyOwner() {
854         _baseURIextended = baseURI_;
855     }
856 
857     function setUnrevealURI(string memory _uri) external onlyOwner() {
858         unrevealURI = _uri;
859     }
860 
861     function Reveal() public onlyOwner() {
862         reveal = true;
863     }
864 
865     function UnReveal() public onlyOwner() {
866         reveal = false;
867     }
868 
869     function _price() public view returns (uint256) {
870         return _priceextended;
871     }
872 
873     function setPrice(uint256 _priceextended_) external onlyOwner() {
874         _priceextended = _priceextended_;
875     }
876 
877     function pause() public onlyOwner {
878         pauseMint = true;
879     }
880 
881     function unPause() public onlyOwner {
882         pauseMint = false;
883     }
884 }