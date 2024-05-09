1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-25
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-14
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.0;
11 library SafeMath {
12     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
13         unchecked {
14             uint256 c = a + b;
15             if (c < a) return (false, 0);
16             return (true, c);
17         }
18     }
19     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {
21             if (b > a) return (false, 0);
22             return (true, a - b);
23         }
24     }
25     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             if (a == 0) return (true, 0);
28             uint256 c = a * b;
29             if (c / a != b) return (false, 0);
30             return (true, c);
31         }
32     }
33     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b == 0) return (false, 0);
36             return (true, a / b);
37         }
38     }
39     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b == 0) return (false, 0);
42             return (true, a % b);
43         }
44     }
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a + b;
47     }
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a - b;
50     }
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a * b;
53     }
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a / b;
56     }
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a % b;
59     }
60     function sub(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         unchecked {
66             require(b <= a, errorMessage);
67             return a - b;
68         }
69     }
70     function div(
71         uint256 a,
72         uint256 b,
73         string memory errorMessage
74     ) internal pure returns (uint256) {
75         unchecked {
76             require(b > 0, errorMessage);
77             return a / b;
78         }
79     }
80     function mod(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         unchecked {
86             require(b > 0, errorMessage);
87             return a % b;
88         }
89     }
90 }
91 library Strings {
92     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
93     function toString(uint256 value) internal pure returns (string memory) {
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 library Address {
137     function isContract(address account) internal view returns (bool) {
138 
139         uint256 size;
140         assembly {
141             size := extcodesize(account)
142         }
143         return size > 0;
144     }
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(address(this).balance >= amount, "Address: insufficient balance");
147 
148         (bool success, ) = recipient.call{value: amount}("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
152         return functionCall(target, data, "Address: low-level call failed");
153     }
154     function functionCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, 0, errorMessage);
160     }
161     function functionCallWithValue(
162         address target,
163         bytes memory data,
164         uint256 value
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
167     }
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
178         return _verifyCallResult(success, returndata, errorMessage);
179     }
180     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
181         return functionStaticCall(target, data, "Address: low-level static call failed");
182     }
183     function functionStaticCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal view returns (bytes memory) {
188         require(isContract(target), "Address: static call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.staticcall(data);
191         return _verifyCallResult(success, returndata, errorMessage);
192     }
193     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
195     }
196     function functionDelegateCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(isContract(target), "Address: delegate call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.delegatecall(data);
204         return _verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     function _verifyCallResult(
208         bool success,
209         bytes memory returndata,
210         string memory errorMessage
211     ) private pure returns (bytes memory) {
212         if (success) {
213             return returndata;
214         } else {
215             if (returndata.length > 0) {
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 interface IERC721Receiver {
228     function onERC721Received(
229         address operator,
230         address from,
231         uint256 tokenId,
232         bytes calldata data
233     ) external returns (bytes4);
234 }
235 interface IERC165 {
236     function supportsInterface(bytes4 interfaceId) external view returns (bool);
237 }
238 abstract contract ERC165 is IERC165 {
239     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
240         return interfaceId == type(IERC165).interfaceId;
241     }
242 }
243 interface IERC721 is IERC165 {
244     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
245     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
246     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
247     function balanceOf(address owner) external view returns (uint256 balance);
248     function ownerOf(uint256 tokenId) external view returns (address owner);
249     function safeTransferFrom(
250         address from,
251         address to,
252         uint256 tokenId
253     ) external;
254     function transferFrom(
255         address from,
256         address to,
257         uint256 tokenId
258     ) external;
259     function approve(address to, uint256 tokenId) external;
260     function getApproved(uint256 tokenId) external view returns (address operator);
261     function setApprovalForAll(address operator, bool _approved) external;
262     function isApprovedForAll(address owner, address operator) external view returns (bool);
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId,
267         bytes calldata data
268     ) external;
269 }
270 interface IERC721Enumerable is IERC721 {
271     function totalSupply() external view returns (uint256);
272     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
273     function tokenByIndex(uint256 index) external view returns (uint256);
274 }
275 interface IERC721Metadata is IERC721 {
276     function name() external view returns (string memory);
277     function symbol() external view returns (string memory);
278     function tokenURI(uint256 tokenId) external view returns (string memory);
279 }
280 abstract contract Context {
281     function _msgSender() internal view virtual returns (address) {
282         return msg.sender;
283     }
284 
285     function _msgData() internal view virtual returns (bytes calldata) {
286         return msg.data;
287     }
288 }
289 abstract contract Ownable is Context {
290     address private _owner;
291 
292     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
293     constructor () {
294         address msgSender = _msgSender();
295         _owner = msgSender;
296         emit OwnershipTransferred(address(0), msgSender);
297     }
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301     modifier onlyOwner() {
302         require(owner() == _msgSender(), "Ownable: caller is not the owner");
303         _;
304     }
305     function transferOwnership(address newOwner) public virtual onlyOwner {
306         require(newOwner != address(0), "Ownable: new owner is the zero address");
307         _setOwner(newOwner);
308     }
309 
310     function _setOwner(address newOwner) private {
311         address oldOwner = _owner;
312         _owner = newOwner;
313         emit OwnershipTransferred(oldOwner, newOwner);
314     }
315 }
316 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
317     using Address for address;
318     using Strings for uint256;
319 
320     string private _name;
321 
322     string private _symbol;
323 
324     mapping(uint256 => address) private _owners;
325 
326     mapping(address => uint256) private _balances;
327 
328     mapping(uint256 => address) private _tokenApprovals;
329 
330     mapping(address => mapping(address => bool)) private _operatorApprovals;
331 
332 
333     string public _baseURI;
334     constructor(string memory name_, string memory symbol_) {
335         _name = name_;
336         _symbol = symbol_;
337     }
338     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
339         return
340             interfaceId == type(IERC721).interfaceId ||
341             interfaceId == type(IERC721Metadata).interfaceId ||
342             super.supportsInterface(interfaceId);
343     }
344     function balanceOf(address owner) public view virtual override returns (uint256) {
345         require(owner != address(0), "ERC721: balance query for the zero address");
346         return _balances[owner];
347     }
348     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
349         address owner = _owners[tokenId];
350         require(owner != address(0), "ERC721: owner query for nonexistent token");
351         return owner;
352     }
353     function name() public view virtual override returns (string memory) {
354         return _name;
355     }
356     function symbol() public view virtual override returns (string memory) {
357         return _symbol;
358     }
359     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
360         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
361 
362         string memory base = baseURI();
363         return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString(), ".json")) : "";
364     }
365     function baseURI() internal view virtual returns (string memory) {
366         return _baseURI;
367     }
368     function approve(address to, uint256 tokenId) public virtual override {
369         address owner = ERC721.ownerOf(tokenId);
370         require(to != owner, "ERC721: approval to current owner");
371 
372         require(
373             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
374             "ERC721: approve caller is not owner nor approved for all"
375         );
376 
377         _approve(to, tokenId);
378     }
379     function getApproved(uint256 tokenId) public view virtual override returns (address) {
380         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
381 
382         return _tokenApprovals[tokenId];
383     }
384     function setApprovalForAll(address operator, bool approved) public virtual override {
385         require(operator != _msgSender(), "ERC721: approve to caller");
386 
387         _operatorApprovals[_msgSender()][operator] = approved;
388         emit ApprovalForAll(_msgSender(), operator, approved);
389     }
390     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
391         return _operatorApprovals[owner][operator];
392     }
393     function transferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) public virtual override {
398         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
399 
400         _transfer(from, to, tokenId);
401     }
402     function safeTransferFrom(
403         address from,
404         address to,
405         uint256 tokenId
406     ) public virtual override {
407         safeTransferFrom(from, to, tokenId, "");
408     }
409     function safeTransferFrom(
410         address from,
411         address to,
412         uint256 tokenId,
413         bytes memory _data
414     ) public virtual override {
415         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
416         _safeTransfer(from, to, tokenId, _data);
417     }
418     function _safeTransfer(
419         address from,
420         address to,
421         uint256 tokenId,
422         bytes memory _data
423     ) internal virtual {
424         _transfer(from, to, tokenId);
425         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
426     }
427     function _exists(uint256 tokenId) internal view virtual returns (bool) {
428         return _owners[tokenId] != address(0);
429     }
430     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
431         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
432         address owner = ERC721.ownerOf(tokenId);
433         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
434     }
435     function _safeMint(address to, uint256 tokenId) internal virtual {
436         _safeMint(to, tokenId, "");
437     }
438     function _safeMint(
439         address to,
440         uint256 tokenId,
441         bytes memory _data
442     ) internal virtual {
443         _mint(to, tokenId);
444         require(
445             _checkOnERC721Received(address(0), to, tokenId, _data),
446             "ERC721: transfer to non ERC721Receiver implementer"
447         );
448     }
449     function _mint(address to, uint256 tokenId) internal virtual {
450         require(to != address(0), "ERC721: mint to the zero address");
451         require(!_exists(tokenId), "ERC721: token already minted");
452 
453         _beforeTokenTransfer(address(0), to, tokenId);
454 
455         _balances[to] += 1;
456         _owners[tokenId] = to;
457 
458         emit Transfer(address(0), to, tokenId);
459     }
460     function _burn(uint256 tokenId) internal virtual {
461         address owner = ERC721.ownerOf(tokenId);
462 
463         _beforeTokenTransfer(owner, address(0), tokenId);
464 
465         _approve(address(0), tokenId);
466 
467         _balances[owner] -= 1;
468         delete _owners[tokenId];
469 
470         emit Transfer(owner, address(0), tokenId);
471     }
472     function _transfer(
473         address from,
474         address to,
475         uint256 tokenId
476     ) internal virtual {
477         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
478         require(to != address(0), "ERC721: transfer to the zero address");
479 
480         _beforeTokenTransfer(from, to, tokenId);
481 
482         _approve(address(0), tokenId);
483 
484         _balances[from] -= 1;
485         _balances[to] += 1;
486         _owners[tokenId] = to;
487 
488         emit Transfer(from, to, tokenId);
489     }
490     function _approve(address to, uint256 tokenId) internal virtual {
491         _tokenApprovals[tokenId] = to;
492         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
493     }
494     function _checkOnERC721Received(
495         address from,
496         address to,
497         uint256 tokenId,
498         bytes memory _data
499     ) private returns (bool) {
500         if (to.isContract()) {
501             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
502                 return retval == IERC721Receiver(to).onERC721Received.selector;
503             } catch (bytes memory reason) {
504                 if (reason.length == 0) {
505                     revert("ERC721: transfer to non ERC721Receiver implementer");
506                 } else {
507                     assembly {
508                         revert(add(32, reason), mload(reason))
509                     }
510                 }
511             }
512         } else {
513             return true;
514         }
515     }
516     function _beforeTokenTransfer(
517         address from,
518         address to,
519         uint256 tokenId
520     ) internal virtual {}
521 }
522 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
523     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
524 
525     mapping(uint256 => uint256) private _ownedTokensIndex;
526 
527     uint256[] private _allTokens;
528 
529     mapping(uint256 => uint256) private _allTokensIndex;
530     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
531         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
532     }
533     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
534         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
535         return _ownedTokens[owner][index];
536     }
537     function totalSupply() public view virtual override returns (uint256) {
538         return _allTokens.length;
539     }
540     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
541         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
542         return _allTokens[index];
543     }
544     function _beforeTokenTransfer(
545         address from,
546         address to,
547         uint256 tokenId
548     ) internal virtual override {
549         super._beforeTokenTransfer(from, to, tokenId);
550 
551         if (from == address(0)) {
552             _addTokenToAllTokensEnumeration(tokenId);
553         } else if (from != to) {
554             _removeTokenFromOwnerEnumeration(from, tokenId);
555         }
556         if (to == address(0)) {
557             _removeTokenFromAllTokensEnumeration(tokenId);
558         } else if (to != from) {
559             _addTokenToOwnerEnumeration(to, tokenId);
560         }
561     }
562     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
563         uint256 length = ERC721.balanceOf(to);
564         _ownedTokens[to][length] = tokenId;
565         _ownedTokensIndex[tokenId] = length;
566     }
567     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
568         _allTokensIndex[tokenId] = _allTokens.length;
569         _allTokens.push(tokenId);
570     }
571     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
572 
573         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
574         uint256 tokenIndex = _ownedTokensIndex[tokenId];
575 
576         if (tokenIndex != lastTokenIndex) {
577             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
578 
579         }
580 
581         delete _ownedTokensIndex[tokenId];
582         delete _ownedTokens[from][lastTokenIndex];
583     }
584     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
585 
586         uint256 lastTokenIndex = _allTokens.length - 1;
587         uint256 tokenIndex = _allTokensIndex[tokenId];
588 
589         uint256 lastTokenId = _allTokens[lastTokenIndex];
590 
591 
592         delete _allTokensIndex[tokenId];
593         _allTokens.pop();
594     }
595 }
596 contract BabyDoodleApes is ERC721Enumerable, Ownable
597 {
598     using SafeMath for uint256;
599     using Strings for uint256;
600 
601     uint public constant _TOTALSUPPLY = 3333;
602     
603     uint public maxPerTxn = 20; // 10 - whitelist , 10 - public
604     // uint public maxPerWallet = 2; // 2 - whitelist , none - public
605     
606     uint256 public price = 0.02 ether; 
607     uint public status = 0; //0 - pause , 1 - public
608     
609     bool public revealed = false;
610     string public unrevealedUri = "https://gateway.pinata.cloud/ipfs/QmXKWdxoizpb6vXAicGG4iCDVBZsR7hcfeY8MXghKFQC72";
611     
612     uint private reserved = 30;
613 
614     mapping(address => bool) public trackFree;
615 
616     constructor() ERC721("BabyDoodleApes", "BDA")  {
617         setBaseURI("");
618     }
619     function gotFree(address a) public returns(bool){
620         return trackFree[a];
621     }
622     function setBaseURI(string memory baseURI) public onlyOwner {
623         _baseURI = baseURI;
624     }
625     function setRevealed() public onlyOwner{
626         revealed = !revealed;
627     }
628     function setunrevealedUri(string memory baseURI) public onlyOwner {
629         unrevealedUri = baseURI;
630     }
631     function setPrice(uint256 _newPrice) public onlyOwner() {
632         price = _newPrice;
633     }
634     function setReserved(uint256 _q) public onlyOwner() {
635         reserved = _q;
636     }
637     function setMaxxQtPerTx(uint256 _quantity) public onlyOwner {
638         maxPerTxn=_quantity;
639     }
640     // function setMaxxQtPerWallet(uint256 _quantity) public onlyOwner {
641     //     maxPerWallet=_quantity;
642     // }
643     function giveaway(address a, uint q) public onlyOwner{
644         for(uint i=0; i<q; i++)
645             _safeMint(a, totalsupply()+1);
646             reserved-=q;
647     }
648     modifier isSaleOpen{
649         require(totalSupply() < _TOTALSUPPLY, "Sale end");
650         _;
651     }
652     function seteStatus(uint s) public onlyOwner {
653         status = s;
654     }
655     function getPrice() public view returns (uint256) {
656            return price ;
657     }
658 
659     function mint(uint chosenAmount) public payable isSaleOpen{
660         require( status == 1 , "Sale is not active at the moment" );
661         require( totalSupply() + chosenAmount <= _TOTALSUPPLY - reserved , "Quantity must be lesser then MaxSupply" );
662         require( chosenAmount > 0 , "Number of tokens can not be less than or equal to 0" );
663         require( chosenAmount <= maxPerTxn , "Chosen Amount exceeds MaxQuantity" );
664         // require( status == 1 && ( chosenAmount + balanceOf( msg.sender ) <= maxPerWallet ) , "Chosen Amount exceeds MaxQuantity" );
665         require( price.mul( trackFree[msg.sender]  ? chosenAmount : chosenAmount-1 ) == msg.value, "Sent ether value is incorrect" );
666         for (uint i = 0; i < chosenAmount; i++) {
667             _safeMint(msg.sender, totalsupply()+1);
668         }
669         trackFree[msg.sender] = true;
670     }
671  
672     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
673         uint256 count = balanceOf(_owner);
674         uint256[] memory result = new uint256[](count);
675         for (uint256 index = 0; index < count; index++) {
676             result[index] = tokenOfOwnerByIndex(_owner, index);
677         }
678         return result;
679     }
680 
681     function withdraw() public onlyOwner {
682         uint balance = address(this).balance;
683         payable(msg.sender).transfer(balance);
684     }
685     function totalsupply() private view returns (uint) {
686         return super.totalSupply();
687     }
688 
689     function tokenURI(uint256 tokenId) public view override returns (string memory) {
690         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
691 
692         string memory base = baseURI();
693 
694         if(revealed)
695             return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString(), ".json")) : "";
696         else
697         return unrevealedUri;
698     }
699     function contractURI() public view returns (string memory) {
700         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Baby Doodle Apes", "description": "Baby Doodle Apes supports artists, musicians, actors and writers to pursue their dreams, by providing a source of passive income.", "seller_fee_basis_points": 1000, "fee_recipient": "0x34465664e2096eACE7F8d62874aE8B26Eb63b5f9"}'))));
701         json = string(abi.encodePacked('data:application/json;base64,', json));
702         return json;
703     }
704 }
705 library Base64 {
706     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
707 
708     /// @notice Encodes some bytes to the base64 representation
709     function encode(bytes memory data) internal pure returns (string memory) {
710         uint256 len = data.length;
711         if (len == 0) return "";
712 
713         // multiply by 4/3 rounded up
714         uint256 encodedLen = 4 * ((len + 2) / 3);
715 
716         // Add some extra buffer at the end
717         bytes memory result = new bytes(encodedLen + 32);
718 
719         bytes memory table = TABLE;
720 
721         assembly {
722             let tablePtr := add(table, 1)
723             let resultPtr := add(result, 32)
724 
725             for {
726                 let i := 0
727             } lt(i, len) {
728 
729             } {
730                 i := add(i, 3)
731                 let input := and(mload(add(data, i)), 0xffffff)
732 
733                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
734                 out := shl(8, out)
735                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
736                 out := shl(8, out)
737                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
738                 out := shl(8, out)
739                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
740                 out := shl(224, out)
741 
742                 mstore(resultPtr, out)
743 
744                 resultPtr := add(resultPtr, 4)
745             }
746 
747             switch mod(len, 3)
748             case 1 {
749                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
750             }
751             case 2 {
752                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
753             }
754 
755             mstore(result, encodedLen)
756         }
757 
758         return string(result);
759     }
760 }