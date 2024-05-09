1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 library SafeMath {
4     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
5         unchecked {
6             uint256 c = a + b;
7             if (c < a) return (false, 0);
8             return (true, c);
9         }
10     }
11     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
12         unchecked {
13             if (b > a) return (false, 0);
14             return (true, a - b);
15         }
16     }
17     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             if (a == 0) return (true, 0);
20             uint256 c = a * b;
21             if (c / a != b) return (false, 0);
22             return (true, c);
23         }
24     }
25     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             if (b == 0) return (false, 0);
28             return (true, a / b);
29         }
30     }
31     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {
33             if (b == 0) return (false, 0);
34             return (true, a % b);
35         }
36     }
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         return a + b;
39     }
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a - b;
42     }
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a * b;
45     }
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a / b;
48     }
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a % b;
51     }
52     function sub(
53         uint256 a,
54         uint256 b,
55         string memory errorMessage
56     ) internal pure returns (uint256) {
57         unchecked {
58             require(b <= a, errorMessage);
59             return a - b;
60         }
61     }
62     function div(
63         uint256 a,
64         uint256 b,
65         string memory errorMessage
66     ) internal pure returns (uint256) {
67         unchecked {
68             require(b > 0, errorMessage);
69             return a / b;
70         }
71     }
72     function mod(
73         uint256 a,
74         uint256 b,
75         string memory errorMessage
76     ) internal pure returns (uint256) {
77         unchecked {
78             require(b > 0, errorMessage);
79             return a % b;
80         }
81     }
82 }
83 library Strings {
84     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
85     function toString(uint256 value) internal pure returns (string memory) {
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104     function toHexString(uint256 value) internal pure returns (string memory) {
105         if (value == 0) {
106             return "0x00";
107         }
108         uint256 temp = value;
109         uint256 length = 0;
110         while (temp != 0) {
111             length++;
112             temp >>= 8;
113         }
114         return toHexString(value, length);
115     }
116     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
117         bytes memory buffer = new bytes(2 * length + 2);
118         buffer[0] = "0";
119         buffer[1] = "x";
120         for (uint256 i = 2 * length + 1; i > 1; --i) {
121             buffer[i] = _HEX_SYMBOLS[value & 0xf];
122             value >>= 4;
123         }
124         require(value == 0, "Strings: hex length insufficient");
125         return string(buffer);
126     }
127 }
128 library Address {
129     function isContract(address account) internal view returns (bool) {
130 
131         uint256 size;
132         assembly {
133             size := extcodesize(account)
134         }
135         return size > 0;
136     }
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         (bool success, ) = recipient.call{value: amount}("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
144         return functionCall(target, data, "Address: low-level call failed");
145     }
146     function functionCall(
147         address target,
148         bytes memory data,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, 0, errorMessage);
152     }
153     function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value
157     ) internal returns (bytes memory) {
158         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
159     }
160     function functionCallWithValue(
161         address target,
162         bytes memory data,
163         uint256 value,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         require(address(this).balance >= value, "Address: insufficient balance for call");
167         require(isContract(target), "Address: call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.call{value: value}(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
173         return functionStaticCall(target, data, "Address: low-level static call failed");
174     }
175     function functionStaticCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal view returns (bytes memory) {
180         require(isContract(target), "Address: static call to non-contract");
181 
182         (bool success, bytes memory returndata) = target.staticcall(data);
183         return _verifyCallResult(success, returndata, errorMessage);
184     }
185     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
187     }
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return _verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     function _verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) private pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             if (returndata.length > 0) {
208 
209                 assembly {
210                     let returndata_size := mload(returndata)
211                     revert(add(32, returndata), returndata_size)
212                 }
213             } else {
214                 revert(errorMessage);
215             }
216         }
217     }
218 }
219 interface IERC721Receiver {
220     function onERC721Received(
221         address operator,
222         address from,
223         uint256 tokenId,
224         bytes calldata data
225     ) external returns (bytes4);
226 }
227 interface IERC165 {
228     function supportsInterface(bytes4 interfaceId) external view returns (bool);
229 }
230 abstract contract ERC165 is IERC165 {
231     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
232         return interfaceId == type(IERC165).interfaceId;
233     }
234 }
235 interface IERC721 is IERC165 {
236     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
237     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
238     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
239     function balanceOf(address owner) external view returns (uint256 balance);
240     function ownerOf(uint256 tokenId) external view returns (address owner);
241     function safeTransferFrom(
242         address from,
243         address to,
244         uint256 tokenId
245     ) external;
246     function transferFrom(
247         address from,
248         address to,
249         uint256 tokenId
250     ) external;
251     function approve(address to, uint256 tokenId) external;
252     function getApproved(uint256 tokenId) external view returns (address operator);
253     function setApprovalForAll(address operator, bool _approved) external;
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255     function safeTransferFrom(
256         address from,
257         address to,
258         uint256 tokenId,
259         bytes calldata data
260     ) external;
261 }
262 interface IERC721Enumerable is IERC721 {
263     function totalSupply() external view returns (uint256);
264     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
265     function tokenByIndex(uint256 index) external view returns (uint256);
266 }
267 interface IERC721Metadata is IERC721 {
268     function name() external view returns (string memory);
269     function symbol() external view returns (string memory);
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 abstract contract Context {
273     function _msgSender() internal view virtual returns (address) {
274         return msg.sender;
275     }
276 
277     function _msgData() internal view virtual returns (bytes calldata) {
278         return msg.data;
279     }
280 }
281 abstract contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285     constructor () {
286         address msgSender = _msgSender();
287         _owner = msgSender;
288         emit OwnershipTransferred(address(0), msgSender);
289     }
290     function owner() public view virtual returns (address) {
291         return _owner;
292     }
293     modifier onlyOwner() {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297     function transferOwnership(address newOwner) public virtual onlyOwner {
298         require(newOwner != address(0), "Ownable: new owner is the zero address");
299         _setOwner(newOwner);
300     }
301 
302     function _setOwner(address newOwner) private {
303         address oldOwner = _owner;
304         _owner = newOwner;
305         emit OwnershipTransferred(oldOwner, newOwner);
306     }
307 }
308 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
309     using Address for address;
310     using Strings for uint256;
311 
312     string private _name;
313 
314     string private _symbol;
315 
316     mapping(uint256 => address) private _owners;
317 
318     mapping(address => uint256) private _balances;
319 
320     mapping(uint256 => address) private _tokenApprovals;
321 
322     mapping(address => mapping(address => bool)) private _operatorApprovals;
323 
324 
325     string public _baseURI;
326     constructor(string memory name_, string memory symbol_) {
327         _name = name_;
328         _symbol = symbol_;
329     }
330     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
331         return
332             interfaceId == type(IERC721).interfaceId ||
333             interfaceId == type(IERC721Metadata).interfaceId ||
334             super.supportsInterface(interfaceId);
335     }
336     function balanceOf(address owner) public view virtual override returns (uint256) {
337         require(owner != address(0), "ERC721: balance query for the zero address");
338         return _balances[owner];
339     }
340     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
341         address owner = _owners[tokenId];
342         require(owner != address(0), "ERC721: owner query for nonexistent token");
343         return owner;
344     }
345     function name() public view virtual override returns (string memory) {
346         return _name;
347     }
348     function symbol() public view virtual override returns (string memory) {
349         return _symbol;
350     }
351     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
352         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
353 
354         string memory base = baseURI();
355         return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString(), ".json")) : "";
356     }
357     function baseURI() internal view virtual returns (string memory) {
358         return _baseURI;
359     }
360     function approve(address to, uint256 tokenId) public virtual override {
361         address owner = ERC721.ownerOf(tokenId);
362         require(to != owner, "ERC721: approval to current owner");
363 
364         require(
365             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
366             "ERC721: approve caller is not owner nor approved for all"
367         );
368 
369         _approve(to, tokenId);
370     }
371     function getApproved(uint256 tokenId) public view virtual override returns (address) {
372         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
373 
374         return _tokenApprovals[tokenId];
375     }
376     function setApprovalForAll(address operator, bool approved) public virtual override {
377         require(operator != _msgSender(), "ERC721: approve to caller");
378 
379         _operatorApprovals[_msgSender()][operator] = approved;
380         emit ApprovalForAll(_msgSender(), operator, approved);
381     }
382     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
383         return _operatorApprovals[owner][operator];
384     }
385     function transferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) public virtual override {
390         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
391 
392         _transfer(from, to, tokenId);
393     }
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) public virtual override {
399         safeTransferFrom(from, to, tokenId, "");
400     }
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId,
405         bytes memory _data
406     ) public virtual override {
407         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
408         _safeTransfer(from, to, tokenId, _data);
409     }
410     function _safeTransfer(
411         address from,
412         address to,
413         uint256 tokenId,
414         bytes memory _data
415     ) internal virtual {
416         _transfer(from, to, tokenId);
417         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
418     }
419     function _exists(uint256 tokenId) internal view virtual returns (bool) {
420         return _owners[tokenId] != address(0);
421     }
422     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
423         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
424         address owner = ERC721.ownerOf(tokenId);
425         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
426     }
427     function _safeMint(address to, uint256 tokenId) internal virtual {
428         _safeMint(to, tokenId, "");
429     }
430     function _safeMint(
431         address to,
432         uint256 tokenId,
433         bytes memory _data
434     ) internal virtual {
435         _mint(to, tokenId);
436         require(
437             _checkOnERC721Received(address(0), to, tokenId, _data),
438             "ERC721: transfer to non ERC721Receiver implementer"
439         );
440     }
441     function _mint(address to, uint256 tokenId) internal virtual {
442         require(to != address(0), "ERC721: mint to the zero address");
443         require(!_exists(tokenId), "ERC721: token already minted");
444 
445         _beforeTokenTransfer(address(0), to, tokenId);
446 
447         _balances[to] += 1;
448         _owners[tokenId] = to;
449 
450         emit Transfer(address(0), to, tokenId);
451     }
452     function _burn(uint256 tokenId) internal virtual {
453         address owner = ERC721.ownerOf(tokenId);
454 
455         _beforeTokenTransfer(owner, address(0), tokenId);
456 
457         _approve(address(0), tokenId);
458 
459         _balances[owner] -= 1;
460         delete _owners[tokenId];
461 
462         emit Transfer(owner, address(0), tokenId);
463     }
464     function _transfer(
465         address from,
466         address to,
467         uint256 tokenId
468     ) internal virtual {
469         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
470         require(to != address(0), "ERC721: transfer to the zero address");
471 
472         _beforeTokenTransfer(from, to, tokenId);
473 
474         _approve(address(0), tokenId);
475 
476         _balances[from] -= 1;
477         _balances[to] += 1;
478         _owners[tokenId] = to;
479 
480         emit Transfer(from, to, tokenId);
481     }
482     function _approve(address to, uint256 tokenId) internal virtual {
483         _tokenApprovals[tokenId] = to;
484         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
485     }
486     function _checkOnERC721Received(
487         address from,
488         address to,
489         uint256 tokenId,
490         bytes memory _data
491     ) private returns (bool) {
492         if (to.isContract()) {
493             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
494                 return retval == IERC721Receiver(to).onERC721Received.selector;
495             } catch (bytes memory reason) {
496                 if (reason.length == 0) {
497                     revert("ERC721: transfer to non ERC721Receiver implementer");
498                 } else {
499                     assembly {
500                         revert(add(32, reason), mload(reason))
501                     }
502                 }
503             }
504         } else {
505             return true;
506         }
507     }
508     function _beforeTokenTransfer(
509         address from,
510         address to,
511         uint256 tokenId
512     ) internal virtual {}
513 }
514 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
515     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
516 
517     mapping(uint256 => uint256) private _ownedTokensIndex;
518 
519     uint256[] private _allTokens;
520 
521     mapping(uint256 => uint256) private _allTokensIndex;
522     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
523         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
524     }
525     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
526         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
527         return _ownedTokens[owner][index];
528     }
529     function totalSupply() public view virtual override returns (uint256) {
530         return _allTokens.length;
531     }
532     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
533         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
534         return _allTokens[index];
535     }
536     function _beforeTokenTransfer(
537         address from,
538         address to,
539         uint256 tokenId
540     ) internal virtual override {
541         super._beforeTokenTransfer(from, to, tokenId);
542 
543         if (from == address(0)) {
544             _addTokenToAllTokensEnumeration(tokenId);
545         } else if (from != to) {
546             _removeTokenFromOwnerEnumeration(from, tokenId);
547         }
548         if (to == address(0)) {
549             _removeTokenFromAllTokensEnumeration(tokenId);
550         } else if (to != from) {
551             _addTokenToOwnerEnumeration(to, tokenId);
552         }
553     }
554     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
555         uint256 length = ERC721.balanceOf(to);
556         _ownedTokens[to][length] = tokenId;
557         _ownedTokensIndex[tokenId] = length;
558     }
559     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
560         _allTokensIndex[tokenId] = _allTokens.length;
561         _allTokens.push(tokenId);
562     }
563     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
564 
565         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
566         uint256 tokenIndex = _ownedTokensIndex[tokenId];
567 
568         if (tokenIndex != lastTokenIndex) {
569             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
570 
571         }
572 
573         delete _ownedTokensIndex[tokenId];
574         delete _ownedTokens[from][lastTokenIndex];
575     }
576     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
577 
578         uint256 lastTokenIndex = _allTokens.length - 1;
579         uint256 tokenIndex = _allTokensIndex[tokenId];
580 
581         uint256 lastTokenId = _allTokens[lastTokenIndex];
582 
583 
584         delete _allTokensIndex[tokenId];
585         _allTokens.pop();
586     }
587 }
588 contract CryptoBullDogs is ERC721Enumerable, Ownable
589 {
590     using SafeMath for uint256;
591     using Strings for uint256;
592 
593     uint public constant _TOTALSUPPLY = 4444;
594     uint public maxQuantity =5;
595     uint public maxPerUser=20;
596     // OGs : 0.02  // WL 0.03  // Public 0.04
597     uint256 public price = 0.02 ether; 
598     uint256 public status = 0; // 0-pause, 1-whitelist, 2-public
599     bool public reveal = false;
600     mapping(address=>bool) public whiteListedAddress;
601 
602     // uint private tokenId=1;
603 
604     constructor(string memory baseURI) ERC721("CryptoBullDogs", "CBD") {
605         setBaseURI(baseURI);
606        
607     }
608    
609     function setBaseURI(string memory baseURI) public onlyOwner {
610         _baseURI = baseURI;
611     }
612 
613     function setPrice(uint256 _newPrice) public onlyOwner() {
614         price = _newPrice;
615     }
616     function setStatus(uint8 s) public onlyOwner{
617         status = s;
618     }
619     function setMaxxQtPerTx(uint256 _quantity) public onlyOwner {
620         maxQuantity=_quantity;
621     }
622     function setReveal() public onlyOwner{
623         reveal =! reveal;
624     }
625     function setMaxPerUser(uint256 _maxPerUser) public onlyOwner() {
626         maxPerUser = _maxPerUser;
627     }
628     modifier isSaleOpen{
629         require(totalSupply() < _TOTALSUPPLY, "Sale end");
630         _;
631     }
632     function getStatus() public view returns (uint256) {
633         return status;
634 
635     }
636     function getPrice(uint256 _quantity) public view returns (uint256) {
637        
638            return _quantity*price ;
639     }
640     function getMaxPerUser() public view returns (uint256) {
641        
642            return maxPerUser ;
643     }
644 
645     function mint(uint chosenAmount) public payable isSaleOpen {
646         require(totalSupply()+chosenAmount<=_TOTALSUPPLY,"Quantity must be lesser then MaxSupply");
647         require(chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
648         require(chosenAmount <= maxQuantity,"Chosen Amount exceeds MaxQuantity");
649         require(price.mul(chosenAmount) == msg.value, "Sent ether value is incorrect");
650         require(whiteListedAddress[msg.sender] || status == 2, "Sorry you are not white listed, or the sale is not open");
651         require(chosenAmount + balanceOf(msg.sender) <= maxPerUser , "You can not mint more than the maximum allowed per user.");
652 
653         for (uint i = 0; i < chosenAmount; i++) {
654             _safeMint(msg.sender, totalsupply());
655         }
656     }
657  
658     function tokensOfOwner(address _owner) public view returns (uint256[] memory)
659     {
660         uint256 count = balanceOf(_owner);
661         uint256[] memory result = new uint256[](count);
662         for (uint256 index = 0; index < count; index++) {
663             result[index] = tokenOfOwnerByIndex(_owner, index);
664         }
665         return result;
666     }
667 
668     function withdraw() public onlyOwner {
669         uint balance = address(this).balance;
670             // 3% share for the developer's wallet
671             uint mybal=balance.mul(3);
672             mybal=mybal.div(100);
673             payable(0x90EE4b80C3b15b8b83510BE8Fcf2BCeD69a4c9DB).transfer(mybal);
674             balance=balance-mybal;
675             payable(msg.sender).transfer(balance);
676     }
677     function totalsupply() private view returns (uint)
678     {
679         return super.totalSupply()+1;
680     }
681     function tokenURI(uint256 tokenId) public view override returns (string memory) {
682         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
683 
684         string memory base = baseURI();
685         // return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString(), ".json")) : "";
686         if(bytes(base).length > 0){
687         }
688         else             return reveal ? string(abi.encodePacked(base, tokenId.toString(), ".json")) : string(abi.encodePacked("https://gateway.pinata.cloud/ipfs/QmWpHmj1upUYxX9VrFc7s5KUvwtpDQnCroMvu4Xbw3Nezw"));
689 
690         return "";
691     }
692     function addWhiteListAddress(address[] memory _address) public onlyOwner {
693         
694         for(uint i=0; i<_address.length; i++){
695             whiteListedAddress[_address[i]] = true;
696         }
697     }
698     function isWhiteListAddress(address _address) public returns (bool){
699         return whiteListedAddress[_address];
700     }
701     function isWhiteListSender() public returns (bool){
702         return whiteListedAddress[msg.sender];
703     }
704     function contractURI() public view returns (string memory) {
705         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Crypto Bull Dogs", "description": "4,444 French Bulldogs are tired of their owners having to work 10 hour workdays, 6 days a week, for minimal pay. ", "seller_fee_basis_points": 700, "fee_recipient": "0x54d6b6c93180264285b906f42a3d6330fd0da3a1"}'))));
706         json = string(abi.encodePacked('data:application/json;base64,', json));
707         return json;
708     }
709 }
710 library Base64 {
711     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
712 
713     /// @notice Encodes some bytes to the base64 representation
714     function encode(bytes memory data) internal pure returns (string memory) {
715         uint256 len = data.length;
716         if (len == 0) return "";
717 
718         // multiply by 4/3 rounded up
719         uint256 encodedLen = 4 * ((len + 2) / 3);
720 
721         // Add some extra buffer at the end
722         bytes memory result = new bytes(encodedLen + 32);
723 
724         bytes memory table = TABLE;
725 
726         assembly {
727             let tablePtr := add(table, 1)
728             let resultPtr := add(result, 32)
729 
730             for {
731                 let i := 0
732             } lt(i, len) {
733 
734             } {
735                 i := add(i, 3)
736                 let input := and(mload(add(data, i)), 0xffffff)
737 
738                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
739                 out := shl(8, out)
740                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
741                 out := shl(8, out)
742                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
743                 out := shl(8, out)
744                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
745                 out := shl(224, out)
746 
747                 mstore(resultPtr, out)
748 
749                 resultPtr := add(resultPtr, 4)
750             }
751 
752             switch mod(len, 3)
753             case 1 {
754                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
755             }
756             case 2 {
757                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
758             }
759 
760             mstore(result, encodedLen)
761         }
762 
763         return string(result);
764     }
765 }