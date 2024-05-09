1 pragma solidity ^0.8.0;
2 
3 abstract contract ReentrancyGuard {
4     uint256 private constant _NOT_ENTERED = 1;
5     uint256 private constant _ENTERED = 2;
6     uint256 private _status;
7 
8     constructor() {
9         _status = _NOT_ENTERED;
10     }
11 
12     modifier nonReentrant() {
13         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
14         _status = _ENTERED;
15         _;
16         _status = _NOT_ENTERED;
17     }
18 }
19 
20 pragma solidity ^0.8.0;
21 
22 interface IERC721Receiver {
23     function onERC721Received(
24         address operator,
25         address from,
26         uint256 tokenId,
27         bytes calldata data
28     ) external returns (bytes4);
29 }
30 
31 
32 pragma solidity ^0.8.0;
33 
34 library Address {
35 
36     function isContract(address account) internal view returns (bool) {
37         uint256 size;
38         assembly {
39             size := extcodesize(account)
40         }
41         return size > 0;
42     }
43 
44     function sendValue(address payable recipient, uint256 amount) internal {
45         require(address(this).balance >= amount, "Address: insufficient balance");
46         (bool success, ) = recipient.call{value: amount}("");
47         require(success, "Address: unable to send value, recipient may have reverted");
48     }
49 
50     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
51         return functionCall(target, data, "Address: low-level call failed");
52     }
53 
54     function functionCall(
55         address target,
56         bytes memory data,
57         string memory errorMessage
58     ) internal returns (bytes memory) {
59         return functionCallWithValue(target, data, 0, errorMessage);
60     }
61 
62     function functionCallWithValue(
63         address target,
64         bytes memory data,
65         uint256 value
66     ) internal returns (bytes memory) {
67         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
68     }
69 
70     function functionCallWithValue(
71         address target,
72         bytes memory data,
73         uint256 value,
74         string memory errorMessage
75     ) internal returns (bytes memory) {
76         require(address(this).balance >= value, "Address: insufficient balance for call");
77         require(isContract(target), "Address: call to non-contract");
78         (bool success, bytes memory returndata) = target.call{value: value}(data);
79         return verifyCallResult(success, returndata, errorMessage);
80     }
81 
82     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
83         return functionStaticCall(target, data, "Address: low-level static call failed");
84     }
85 
86     function functionStaticCall(
87         address target,
88         bytes memory data,
89         string memory errorMessage
90     ) internal view returns (bytes memory) {
91         require(isContract(target), "Address: static call to non-contract");
92         (bool success, bytes memory returndata) = target.staticcall(data);
93         return verifyCallResult(success, returndata, errorMessage);
94     }
95 
96     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
97         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
98     }
99 
100     function functionDelegateCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         require(isContract(target), "Address: delegate call to non-contract");
106         (bool success, bytes memory returndata) = target.delegatecall(data);
107         return verifyCallResult(success, returndata, errorMessage);
108     }
109 
110     function verifyCallResult(
111         bool success,
112         bytes memory returndata,
113         string memory errorMessage
114     ) internal pure returns (bytes memory) {
115         if (success) {
116             return returndata;
117         } else {
118             if (returndata.length > 0) {
119                 assembly {
120                     let returndata_size := mload(returndata)
121                     revert(add(32, returndata), returndata_size)
122                 }
123             } else {
124                 revert(errorMessage);
125             }
126         }
127     }
128 }
129 
130 pragma solidity ^0.8.0;
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 pragma solidity ^0.8.0;
142 
143 library Strings {
144     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
145     function toString(uint256 value) internal pure returns (string memory) {
146         if (value == 0) {
147             return "0";
148         }
149         uint256 temp = value;
150         uint256 digits;
151         while (temp != 0) {
152             digits++;
153             temp /= 10;
154         }
155         bytes memory buffer = new bytes(digits);
156         while (value != 0) {
157             digits -= 1;
158             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
159             value /= 10;
160         }
161         return string(buffer);
162     }
163 
164     function toHexString(uint256 value) internal pure returns (string memory) {
165         if (value == 0) {
166             return "0x00";
167         }
168         uint256 temp = value;
169         uint256 length = 0;
170         while (temp != 0) {
171             length++;
172             temp >>= 8;
173         }
174         return toHexString(value, length);
175     }
176 
177     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
178         bytes memory buffer = new bytes(2 * length + 2);
179         buffer[0] = "0";
180         buffer[1] = "x";
181         for (uint256 i = 2 * length + 1; i > 1; --i) {
182             buffer[i] = _HEX_SYMBOLS[value & 0xf];
183             value >>= 4;
184         }
185         require(value == 0, "Strings: hex length insufficient");
186         return string(buffer);
187     }
188 }
189 
190 pragma solidity ^0.8.0;
191 
192 interface IERC165 {
193     function supportsInterface(bytes4 interfaceId) external view returns (bool);
194 }
195 
196 
197 pragma solidity ^0.8.0;
198 
199 library SafeMath {
200     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         unchecked {
202             uint256 c = a + b;
203             if (c < a) return (false, 0);
204             return (true, c);
205         }
206     }
207 
208     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
209         unchecked {
210             if (b > a) return (false, 0);
211             return (true, a - b);
212         }
213     }
214 
215     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
216         unchecked {
217             if (a == 0) return (true, 0);
218             uint256 c = a * b;
219             if (c / a != b) return (false, 0);
220             return (true, c);
221         }
222     }
223 
224     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             if (b == 0) return (false, 0);
227             return (true, a / b);
228         }
229     }
230 
231     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         unchecked {
233             if (b == 0) return (false, 0);
234             return (true, a % b);
235         }
236     }
237 
238     function add(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a + b;
240     }
241 
242     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a - b;
244     }
245 
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         return a * b;
248     }
249 
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a / b;
252     }
253 
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a % b;
256     }
257 
258     function sub(
259         uint256 a,
260         uint256 b,
261         string memory errorMessage
262     ) internal pure returns (uint256) {
263         unchecked {
264             require(b <= a, errorMessage);
265             return a - b;
266         }
267     }
268 
269     function div(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         unchecked {
275             require(b > 0, errorMessage);
276             return a / b;
277         }
278     }
279 
280     function mod(
281         uint256 a,
282         uint256 b,
283         string memory errorMessage
284     ) internal pure returns (uint256) {
285         unchecked {
286             require(b > 0, errorMessage);
287             return a % b;
288         }
289     }
290 }
291 
292 
293 pragma solidity ^0.8.0;
294 
295 abstract contract ERC165 is IERC165 {
296     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297         return interfaceId == type(IERC165).interfaceId;
298     }
299 }
300 
301 
302 pragma solidity ^0.8.0;
303 
304 interface IERC721 is IERC165 {
305     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
306     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
307     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
308     function balanceOf(address owner) external view returns (uint256 balance);
309     function ownerOf(uint256 tokenId) external view returns (address owner);
310     function safeTransferFrom(
311         address from,
312         address to,
313         uint256 tokenId
314     ) external;
315 
316     function transferFrom(
317         address from,
318         address to,
319         uint256 tokenId
320     ) external;
321 
322     function approve(address to, uint256 tokenId) external;
323     function getApproved(uint256 tokenId) external view returns (address operator);
324     function setApprovalForAll(address operator, bool _approved) external;
325     function isApprovedForAll(address owner, address operator) external view returns (bool);
326     function safeTransferFrom(
327         address from,
328         address to,
329         uint256 tokenId,
330         bytes calldata data
331     ) external;
332 }
333 
334 
335 pragma solidity ^0.8.0;
336 
337 interface IERC721Metadata is IERC721 {
338     function name() external view returns (string memory);
339     function symbol() external view returns (string memory);
340     function tokenURI(uint256 tokenId) external view returns (string memory);
341 }
342 
343 
344 pragma solidity ^0.8.0;
345 interface IERC721Enumerable is IERC721 {
346     function totalSupply() external view returns (uint256);
347     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
348     function tokenByIndex(uint256 index) external view returns (uint256);
349 }
350 
351 pragma solidity ^0.8.0;
352 abstract contract Ownable is Context {
353     address private _owner;
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     constructor() {
357         _setOwner(_msgSender());
358     }
359 
360     function owner() public view virtual returns (address) {
361         return _owner;
362     }
363 
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     function renounceOwnership() public virtual onlyOwner {
370         _setOwner(address(0));
371     }
372 
373     function transferOwnership(address newOwner) public virtual onlyOwner {
374         require(newOwner != address(0), "Ownable: new owner is the zero address");
375         _setOwner(newOwner);
376     }
377 
378     function _setOwner(address newOwner) private {
379         address oldOwner = _owner;
380         _owner = newOwner;
381         emit OwnershipTransferred(oldOwner, newOwner);
382     }
383 }
384 
385 pragma solidity ^0.8.0;
386 
387 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
388     using Address for address;
389     string private _name;
390     string private _symbol;
391     address[] internal _owners;
392     mapping(uint256 => address) private _tokenApprovals;
393     mapping(address => mapping(address => bool)) private _operatorApprovals;     
394     constructor(string memory name_, string memory symbol_) {
395         _name = name_;
396         _symbol = symbol_;
397     }     
398     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
399         return
400             interfaceId == type(IERC721).interfaceId ||
401             interfaceId == type(IERC721Metadata).interfaceId ||
402             super.supportsInterface(interfaceId);
403     }
404     function balanceOf(address owner) public view virtual override returns (uint256) {
405         require(owner != address(0), "ERC721: balance query for the zero address");
406         uint count = 0;
407         uint length = _owners.length;
408         for( uint i = 0; i < length; ++i ){
409           if( owner == _owners[i] ){
410             ++count;
411           }
412         }
413         delete length;
414         return count;
415     }
416     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
417         address owner = _owners[tokenId];
418         require(owner != address(0), "ERC721: owner query for nonexistent token");
419         return owner;
420     }
421     function name() public view virtual override returns (string memory) {
422         return _name;
423     }
424     function symbol() public view virtual override returns (string memory) {
425         return _symbol;
426     }
427     function approve(address to, uint256 tokenId) public virtual override {
428         address owner = ERC721.ownerOf(tokenId);
429         require(to != owner, "ERC721: approval to current owner");
430         require(
431             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
432             "ERC721: approve caller is not owner nor approved for all"
433         );
434         _approve(to, tokenId);
435     }
436     function getApproved(uint256 tokenId) public view virtual override returns (address) {
437         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
438         return _tokenApprovals[tokenId];
439     }
440     function setApprovalForAll(address operator, bool approved) public virtual override {
441         require(operator != _msgSender(), "ERC721: approve to caller");
442         _operatorApprovals[_msgSender()][operator] = approved;
443         emit ApprovalForAll(_msgSender(), operator, approved);
444     }
445     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
446         return _operatorApprovals[owner][operator];
447     }
448     function transferFrom(
449         address from,
450         address to,
451         uint256 tokenId
452     ) public virtual override {
453         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
454         _transfer(from, to, tokenId);
455     }
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId
460     ) public virtual override {
461         safeTransferFrom(from, to, tokenId, "");
462     }
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId,
467         bytes memory _data
468     ) public virtual override {
469         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
470         _safeTransfer(from, to, tokenId, _data);
471     }     
472     function _safeTransfer(
473         address from,
474         address to,
475         uint256 tokenId,
476         bytes memory _data
477     ) internal virtual {
478         _transfer(from, to, tokenId);
479         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
480     }
481 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
482         return tokenId < _owners.length && _owners[tokenId] != address(0);
483     }
484 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
485         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
486         address owner = ERC721.ownerOf(tokenId);
487         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
488     }
489 	function _safeMint(address to, uint256 tokenId) internal virtual {
490         _safeMint(to, tokenId, "");
491     }
492 	function _safeMint(
493         address to,
494         uint256 tokenId,
495         bytes memory _data
496     ) internal virtual {
497         _mint(to, tokenId);
498         require(
499             _checkOnERC721Received(address(0), to, tokenId, _data),
500             "ERC721: transfer to non ERC721Receiver implementer"
501         );
502     }
503 	function _mint(address to, uint256 tokenId) internal virtual {
504         require(to != address(0), "ERC721: mint to the zero address");
505         require(!_exists(tokenId), "ERC721: token already minted");
506         _beforeTokenTransfer(address(0), to, tokenId);
507         _owners.push(to);
508         emit Transfer(address(0), to, tokenId);
509     }
510 	function _burn(uint256 tokenId) internal virtual {
511         address owner = ERC721.ownerOf(tokenId);
512         _beforeTokenTransfer(owner, address(0), tokenId);
513         _approve(address(0), tokenId);
514         _owners[tokenId] = address(0);
515         emit Transfer(owner, address(0), tokenId);
516     }
517 	function _transfer(
518         address from,
519         address to,
520         uint256 tokenId
521     ) internal virtual {
522         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
523         require(to != address(0), "ERC721: transfer to the zero address");
524         _beforeTokenTransfer(from, to, tokenId);
525         _approve(address(0), tokenId);
526         _owners[tokenId] = to;
527         emit Transfer(from, to, tokenId);
528     }
529 	function _approve(address to, uint256 tokenId) internal virtual {
530         _tokenApprovals[tokenId] = to;
531         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
532     }
533 	function _checkOnERC721Received(
534         address from,
535         address to,
536         uint256 tokenId,
537         bytes memory _data
538     ) private returns (bool) {
539         if (to.isContract()) {
540             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
541                 return retval == IERC721Receiver.onERC721Received.selector;
542             } catch (bytes memory reason) {
543                 if (reason.length == 0) {
544                     revert("ERC721: transfer to non ERC721Receiver implementer");
545                 } else {
546                     assembly {
547                         revert(add(32, reason), mload(reason))
548                     }
549                 }
550             }
551         } else {
552             return true;
553         }
554     }
555 	function _beforeTokenTransfer(
556         address from,
557         address to,
558         uint256 tokenId
559     ) internal virtual {}
560 }
561 
562 
563 pragma solidity ^0.8.0;
564 abstract contract ERC721Enum is ERC721, IERC721Enumerable {
565     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
566         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
567     }
568     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
569         require(index < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
570         uint count;
571         for( uint i; i < _owners.length; ++i ){
572             if( owner == _owners[i] ){
573                 if( count == index )
574                     return i;
575                 else
576                     ++count;
577             }
578         }
579         require(false, "ERC721Enum: owner ioob");
580     }
581     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
582         require(0 < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
583         uint256 tokenCount = balanceOf(owner);
584         uint256[] memory tokenIds = new uint256[](tokenCount);
585         for (uint256 i = 0; i < tokenCount; i++) {
586             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
587         }
588         return tokenIds;
589     }
590     function totalSupply() public view virtual override returns (uint256) {
591         return _owners.length;
592     }
593     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
594         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
595         return index;
596     }
597 }
598 
599 
600 pragma solidity ^0.8.0;
601 
602 contract Creemees is ERC721Enum, Ownable, ReentrancyGuard {
603 	using Strings for uint256;
604 	string public baseURI;
605 	//sale settings
606 	uint256 public cost = 0.09 ether;
607 	uint256 public maxSupply = 9998;
608 	uint256 public maxMint = 5;
609 	bool public status = false;
610     address private marketing = 0xb3e7E6B238627F991C205925a9Bc18e23506615B;
611     address private company = 0x142e0C7A098622Ea98E5D67034251C4dFA746B5d;
612 	//presale settings
613 	mapping(address => uint256) public presaleWhitelist;
614 
615 	constructor(
616 	string memory _name,
617 	string memory _symbol,
618 	string memory _initBaseURI
619 	) ERC721(_name, _symbol){
620 	setBaseURI(_initBaseURI);
621 	}
622 	// internal
623 	function _baseURI() internal view virtual returns (string memory) {
624 	return baseURI;
625 	}
626     //presale minting
627 	function mintPresale(uint256 _mintAmount) public payable {
628 	uint256 s = totalSupply();
629 	uint256 reserve = presaleWhitelist[msg.sender];
630 	require(!status, "Off");
631 	require(reserve > 0, "Low");
632 	require(_mintAmount <= reserve, "Try less");
633 	require(s + _mintAmount <= maxSupply, "Max");
634 	require(cost * _mintAmount == msg.value, "Wrong amount");
635 	presaleWhitelist[msg.sender] = reserve - _mintAmount;
636 	delete reserve;
637 	for(uint256 i; i < _mintAmount; i++){
638 	_safeMint(msg.sender, s + i, "");
639 	}
640 	delete s;
641 	}
642 	// public minting
643 	function mint(uint256 _mintAmount) public payable nonReentrant{
644 	uint256 s = totalSupply();
645 	require(status, "Off" );
646 	require(_mintAmount > 0, "0" );
647 	require(_mintAmount <= maxMint, "Too many" );
648 	require(s + _mintAmount <= maxSupply, "Max" );
649 	require(msg.value >= cost * _mintAmount);
650 	for (uint256 i = 0; i < _mintAmount; ++i) {
651 	_safeMint(msg.sender, s + i, "");
652 	}
653 	delete s;
654 	}
655 	// admin minting
656 	function gift(address recipient, uint256 amount) external onlyOwner{
657     uint256 s = totalSupply();
658 	for (uint256 i = 0; i < amount; ++i) {
659 	_safeMint(recipient, s++, "");
660 	}	
661     delete s;	
662     }
663     // admin minting
664 	function adminMint(address recipient, uint256 id) external onlyOwner{
665 	_safeMint(recipient,id, "");
666     }
667 	// admin functionality
668 	function presaleSet(address[] calldata _addresses) public onlyOwner {
669 	for(uint256 i; i < _addresses.length; i++){
670 	presaleWhitelist[_addresses[i]] = maxMint;
671 	}
672 	}
673 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
674 	require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
675 	string memory currentBaseURI = _baseURI();
676 	return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
677 	}
678 	function setCost(uint256 _newCost) public onlyOwner {
679 	cost = _newCost;
680 	}
681 	function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
682 	maxMint = _newMaxMintAmount;
683 	}
684 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
685 	baseURI = _newBaseURI;
686 	}
687 	function setSaleStatus(bool _status) public onlyOwner {
688 	status = _status;
689 	}
690 	function withdraw() public onlyOwner {
691     payable(marketing).call{value: address(this).balance*33/100}("");
692     payable(company).call{value: address(this).balance}("");
693 	}
694 }