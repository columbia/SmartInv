1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.11;
4 
5 abstract contract ReentrancyGuard {
6     uint256 private constant _NOT_ENTERED = 1;
7     uint256 private constant _ENTERED = 2;
8     uint256 private _status;
9 
10     constructor() {
11         _status = _NOT_ENTERED;
12     }
13 
14     modifier nonReentrant() {
15         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
16         _status = _ENTERED;
17         _;
18         _status = _NOT_ENTERED;
19     }
20 }
21 
22 pragma solidity ^0.8.11;
23 
24 interface IERC721Receiver {
25     function onERC721Received(
26         address operator,
27         address from,
28         uint256 tokenId,
29         bytes calldata data
30     ) external returns (bytes4);
31 }
32 
33 
34 pragma solidity ^0.8.11;
35 
36 library Address {
37 
38     function isContract(address account) internal view returns (bool) {
39         uint256 size;
40         assembly {
41             size := extcodesize(account)
42         }
43         return size > 0;
44     }
45 
46     function sendValue(address payable recipient, uint256 amount) internal {
47         require(address(this).balance >= amount, "Address: insufficient balance");
48         (bool success, ) = recipient.call{value: amount}("");
49         require(success, "Address: unable to send value, recipient may have reverted");
50     }
51 
52     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
53         return functionCall(target, data, "Address: low-level call failed");
54     }
55 
56     function functionCall(
57         address target,
58         bytes memory data,
59         string memory errorMessage
60     ) internal returns (bytes memory) {
61         return functionCallWithValue(target, data, 0, errorMessage);
62     }
63 
64     function functionCallWithValue(
65         address target,
66         bytes memory data,
67         uint256 value
68     ) internal returns (bytes memory) {
69         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
70     }
71 
72     function functionCallWithValue(
73         address target,
74         bytes memory data,
75         uint256 value,
76         string memory errorMessage
77     ) internal returns (bytes memory) {
78         require(address(this).balance >= value, "Address: insufficient balance for call");
79         require(isContract(target), "Address: call to non-contract");
80         (bool success, bytes memory returndata) = target.call{value: value}(data);
81         return verifyCallResult(success, returndata, errorMessage);
82     }
83 
84     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
85         return functionStaticCall(target, data, "Address: low-level static call failed");
86     }
87 
88     function functionStaticCall(
89         address target,
90         bytes memory data,
91         string memory errorMessage
92     ) internal view returns (bytes memory) {
93         require(isContract(target), "Address: static call to non-contract");
94         (bool success, bytes memory returndata) = target.staticcall(data);
95         return verifyCallResult(success, returndata, errorMessage);
96     }
97 
98     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
99         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
100     }
101 
102     function functionDelegateCall(
103         address target,
104         bytes memory data,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         require(isContract(target), "Address: delegate call to non-contract");
108         (bool success, bytes memory returndata) = target.delegatecall(data);
109         return verifyCallResult(success, returndata, errorMessage);
110     }
111 
112     function verifyCallResult(
113         bool success,
114         bytes memory returndata,
115         string memory errorMessage
116     ) internal pure returns (bytes memory) {
117         if (success) {
118             return returndata;
119         } else {
120             if (returndata.length > 0) {
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 }
131 
132 pragma solidity ^0.8.11;
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 pragma solidity ^0.8.11;
144 
145 library Strings {
146     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
147     function toString(uint256 value) internal pure returns (string memory) {
148         if (value == 0) {
149             return "0";
150         }
151         uint256 temp = value;
152         uint256 digits;
153         while (temp != 0) {
154             digits++;
155             temp /= 10;
156         }
157         bytes memory buffer = new bytes(digits);
158         while (value != 0) {
159             digits -= 1;
160             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
161             value /= 10;
162         }
163         return string(buffer);
164     }
165 
166     function toHexString(uint256 value) internal pure returns (string memory) {
167         if (value == 0) {
168             return "0x00";
169         }
170         uint256 temp = value;
171         uint256 length = 0;
172         while (temp != 0) {
173             length++;
174             temp >>= 8;
175         }
176         return toHexString(value, length);
177     }
178 
179     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
180         bytes memory buffer = new bytes(2 * length + 2);
181         buffer[0] = "0";
182         buffer[1] = "x";
183         for (uint256 i = 2 * length + 1; i > 1; --i) {
184             buffer[i] = _HEX_SYMBOLS[value & 0xf];
185             value >>= 4;
186         }
187         require(value == 0, "Strings: hex length insufficient");
188         return string(buffer);
189     }
190 }
191 
192 pragma solidity ^0.8.11;
193 
194 interface IERC165 {
195     function supportsInterface(bytes4 interfaceId) external view returns (bool);
196 }
197 
198 
199 pragma solidity ^0.8.11;
200 
201 library SafeMath {
202     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
203         unchecked {
204             uint256 c = a + b;
205             if (c < a) return (false, 0);
206             return (true, c);
207         }
208     }
209 
210     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
211         unchecked {
212             if (b > a) return (false, 0);
213             return (true, a - b);
214         }
215     }
216 
217     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
218         unchecked {
219             if (a == 0) return (true, 0);
220             uint256 c = a * b;
221             if (c / a != b) return (false, 0);
222             return (true, c);
223         }
224     }
225 
226     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             if (b == 0) return (false, 0);
229             return (true, a / b);
230         }
231     }
232 
233     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
234         unchecked {
235             if (b == 0) return (false, 0);
236             return (true, a % b);
237         }
238     }
239 
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a + b;
242     }
243 
244     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
245         return a - b;
246     }
247 
248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249         return a * b;
250     }
251 
252     function div(uint256 a, uint256 b) internal pure returns (uint256) {
253         return a / b;
254     }
255 
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return a % b;
258     }
259 
260     function sub(
261         uint256 a,
262         uint256 b,
263         string memory errorMessage
264     ) internal pure returns (uint256) {
265         unchecked {
266             require(b <= a, errorMessage);
267             return a - b;
268         }
269     }
270 
271     function div(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         unchecked {
277             require(b > 0, errorMessage);
278             return a / b;
279         }
280     }
281 
282     function mod(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         unchecked {
288             require(b > 0, errorMessage);
289             return a % b;
290         }
291     }
292 }
293 
294 
295 pragma solidity ^0.8.11;
296 
297 abstract contract ERC165 is IERC165 {
298     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
299         return interfaceId == type(IERC165).interfaceId;
300     }
301 }
302 
303 
304 pragma solidity ^0.8.11;
305 
306 interface IERC721 is IERC165 {
307     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
308     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
309     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
310     function balanceOf(address owner) external view returns (uint256 balance);
311     function ownerOf(uint256 tokenId) external view returns (address owner);
312     function safeTransferFrom(
313         address from,
314         address to,
315         uint256 tokenId
316     ) external;
317 
318     function transferFrom(
319         address from,
320         address to,
321         uint256 tokenId
322     ) external;
323 
324     function approve(address to, uint256 tokenId) external;
325     function getApproved(uint256 tokenId) external view returns (address operator);
326     function setApprovalForAll(address operator, bool _approved) external;
327     function isApprovedForAll(address owner, address operator) external view returns (bool);
328     function safeTransferFrom(
329         address from,
330         address to,
331         uint256 tokenId,
332         bytes calldata data
333     ) external;
334 }
335 
336 
337 pragma solidity ^0.8.11;
338 
339 interface IERC721Metadata is IERC721 {
340     function name() external view returns (string memory);
341     function symbol() external view returns (string memory);
342     function tokenURI(uint256 tokenId) external view returns (string memory);
343 }
344 
345 
346 pragma solidity ^0.8.11;
347 interface IERC721Enumerable is IERC721 {
348     function totalSupply() external view returns (uint256);
349     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
350     function tokenByIndex(uint256 index) external view returns (uint256);
351 }
352 
353 pragma solidity ^0.8.11;
354 abstract contract Ownable is Context {
355     address private _owner;
356     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
357 
358     constructor() {
359         _setOwner(_msgSender());
360     }
361 
362     function owner() public view virtual returns (address) {
363         return _owner;
364     }
365 
366     modifier onlyOwner() {
367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     function renounceOwnership() public virtual onlyOwner {
372         _setOwner(address(0));
373     }
374 
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         _setOwner(newOwner);
378     }
379 
380     function _setOwner(address newOwner) private {
381         address oldOwner = _owner;
382         _owner = newOwner;
383         emit OwnershipTransferred(oldOwner, newOwner);
384     }
385 }
386 
387 pragma solidity ^0.8.11;
388 
389 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
390     using Address for address;
391     string private _name;
392     string private _symbol;
393     address[] internal _owners;
394     mapping(uint256 => address) private _tokenApprovals;
395     mapping(address => mapping(address => bool)) private _operatorApprovals;     
396     constructor(string memory name_, string memory symbol_) {
397         _name = name_;
398         _symbol = symbol_;
399     }     
400     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
401         return
402             interfaceId == type(IERC721).interfaceId ||
403             interfaceId == type(IERC721Metadata).interfaceId ||
404             super.supportsInterface(interfaceId);
405     }
406     function balanceOf(address owner) public view virtual override returns (uint256) {
407         require(owner != address(0), "ERC721: balance query for the zero address");
408         uint count = 0;
409         uint length = _owners.length;
410         for( uint i = 0; i < length; ++i ){
411           if( owner == _owners[i] ){
412             ++count;
413           }
414         }
415         delete length;
416         return count;
417     }
418     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
419         address owner = _owners[tokenId];
420         require(owner != address(0), "ERC721: owner query for nonexistent token");
421         return owner;
422     }
423     function name() public view virtual override returns (string memory) {
424         return _name;
425     }
426     function symbol() public view virtual override returns (string memory) {
427         return _symbol;
428     }
429     function approve(address to, uint256 tokenId) public virtual override {
430         address owner = ERC721.ownerOf(tokenId);
431         require(to != owner, "ERC721: approval to current owner");
432         require(
433             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
434             "ERC721: approve caller is not owner nor approved for all"
435         );
436         _approve(to, tokenId);
437     }
438     function getApproved(uint256 tokenId) public view virtual override returns (address) {
439         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
440         return _tokenApprovals[tokenId];
441     }
442     function setApprovalForAll(address operator, bool approved) public virtual override {
443         require(operator != _msgSender(), "ERC721: approve to caller");
444         _operatorApprovals[_msgSender()][operator] = approved;
445         emit ApprovalForAll(_msgSender(), operator, approved);
446     }
447     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
448         return _operatorApprovals[owner][operator];
449     }
450     function transferFrom(
451         address from,
452         address to,
453         uint256 tokenId
454     ) public virtual override {
455         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
456         _transfer(from, to, tokenId);
457     }
458     function safeTransferFrom(
459         address from,
460         address to,
461         uint256 tokenId
462     ) public virtual override {
463         safeTransferFrom(from, to, tokenId, "");
464     }
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId,
469         bytes memory _data
470     ) public virtual override {
471         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
472         _safeTransfer(from, to, tokenId, _data);
473     }     
474     function _safeTransfer(
475         address from,
476         address to,
477         uint256 tokenId,
478         bytes memory _data
479     ) internal virtual {
480         _transfer(from, to, tokenId);
481         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
482     }
483 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
484         return tokenId < _owners.length && _owners[tokenId] != address(0);
485     }
486 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
487         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
488         address owner = ERC721.ownerOf(tokenId);
489         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
490     }
491 	function _safeMint(address to, uint256 tokenId) internal virtual {
492         _safeMint(to, tokenId, "");
493     }
494 	function _safeMint(
495         address to,
496         uint256 tokenId,
497         bytes memory _data
498     ) internal virtual {
499         _mint(to, tokenId);
500         require(
501             _checkOnERC721Received(address(0), to, tokenId, _data),
502             "ERC721: transfer to non ERC721Receiver implementer"
503         );
504     }
505 	function _mint(address to, uint256 tokenId) internal virtual {
506         require(to != address(0), "ERC721: mint to the zero address");
507         require(!_exists(tokenId), "ERC721: token already minted");
508         _beforeTokenTransfer(address(0), to, tokenId);
509         _owners.push(to);
510         emit Transfer(address(0), to, tokenId);
511     }
512 	function _burn(uint256 tokenId) internal virtual {
513         address owner = ERC721.ownerOf(tokenId);
514         _beforeTokenTransfer(owner, address(0), tokenId);
515         _approve(address(0), tokenId);
516         _owners[tokenId] = address(0);
517         emit Transfer(owner, address(0), tokenId);
518     }
519 	function _transfer(
520         address from,
521         address to,
522         uint256 tokenId
523     ) internal virtual {
524         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
525         require(to != address(0), "ERC721: transfer to the zero address");
526         _beforeTokenTransfer(from, to, tokenId);
527         _approve(address(0), tokenId);
528         _owners[tokenId] = to;
529         emit Transfer(from, to, tokenId);
530     }
531 	function _approve(address to, uint256 tokenId) internal virtual {
532         _tokenApprovals[tokenId] = to;
533         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
534     }
535 	function _checkOnERC721Received(
536         address from,
537         address to,
538         uint256 tokenId,
539         bytes memory _data
540     ) private returns (bool) {
541         if (to.isContract()) {
542             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
543                 return retval == IERC721Receiver.onERC721Received.selector;
544             } catch (bytes memory reason) {
545                 if (reason.length == 0) {
546                     revert("ERC721: transfer to non ERC721Receiver implementer");
547                 } else {
548                     assembly {
549                         revert(add(32, reason), mload(reason))
550                     }
551                 }
552             }
553         } else {
554             return true;
555         }
556     }
557 	function _beforeTokenTransfer(
558         address from,
559         address to,
560         uint256 tokenId
561     ) internal virtual {}
562 }
563 
564 
565 pragma solidity ^0.8.11;
566 abstract contract ERC721Enum is ERC721, IERC721Enumerable {
567     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
568         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
569     }
570     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
571         require(index < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
572         uint count;
573         for( uint i; i < _owners.length; ++i ){
574             if( owner == _owners[i] ){
575                 if( count == index )
576                     return i;
577                 else
578                     ++count;
579             }
580         }
581         require(false, "ERC721Enum: owner ioob");
582     }
583     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
584         require(0 < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
585         uint256 tokenCount = balanceOf(owner);
586         uint256[] memory tokenIds = new uint256[](tokenCount);
587         for (uint256 i = 0; i < tokenCount; i++) {
588             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
589         }
590         return tokenIds;
591     }
592     function totalSupply() public view virtual override returns (uint256) {
593         return _owners.length;
594     }
595     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
596         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
597         return index;
598     }
599 }
600 
601 
602 pragma solidity ^0.8.11;
603 
604 contract MetaDogs is ERC721Enum, Ownable, ReentrancyGuard {
605 	using Strings for uint256;
606 	string public baseURI;
607 	//sale settings
608 	uint256 public cost = 0.08 ether;
609     uint256 public freeSupply = 1000;
610 	uint256 public maxSupply = 5000;
611 	uint256 public maxMint = 10;
612     address private dev = 0x66C1e48f92a6CD8c5F65C30EF6b9f8951C040D22;
613     address private marketing = 0x0c4C0DA60A3E137b97413B646a419688cc5B1274;
614     address private company = 0x29c58c85f2c5d9f0624c770E332a8C09E12C547E;
615 	bool public status = false;
616 
617 	constructor(
618 	string memory _name,
619 	string memory _symbol,
620 	string memory _initBaseURI
621 	) ERC721(_name, _symbol){
622 	setBaseURI(_initBaseURI);
623 	}
624 	// internal
625 	function _baseURI() internal view virtual returns (string memory) {
626 	return baseURI;
627 	}
628 	function Mint(uint256 _mintAmount) public nonReentrant{
629 	uint256 s = totalSupply();
630 	require(!status, "Off" );
631 	require(_mintAmount > 0, "0" );
632 	require(_mintAmount <= maxMint, "Too many" );
633 	require(s + _mintAmount <= freeSupply, "Max" );
634 	for (uint256 i = 0; i < _mintAmount; ++i) {
635 	_safeMint(msg.sender, s + i, "");
636 	}
637 	delete s;
638 	}
639 	function mint(uint256 _mintAmount) public payable nonReentrant{
640 	uint256 s = totalSupply();
641 	require(status, "Off" );
642 	require(_mintAmount > 0, "0" );
643 	require(_mintAmount <= maxMint, "Too many" );
644 	require(s + _mintAmount <= maxSupply, "Max" );
645 	require(msg.value >= cost * _mintAmount);
646 	for (uint256 i = 0; i < _mintAmount; ++i) {
647 	_safeMint(msg.sender, s + i, "");
648 	}
649 	delete s;
650 	}
651 	function adminMint(address[] calldata recipient) external onlyOwner{
652 	uint256 s = totalSupply();
653 	require(s + recipient.length <= maxSupply, "Too many" );
654 	for(uint i = 0; i < recipient.length; ++i){
655 	_safeMint(recipient[i], s++, "" );
656 	}
657 	delete s;	
658 	}
659 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
660 	require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
661 	string memory currentBaseURI = _baseURI();
662 	return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
663 	}
664 	function setCost(uint256 _newCost) public onlyOwner {
665 	cost = _newCost;
666 	}
667 	function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
668 	maxMint = _newMaxMintAmount;
669 	}
670 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
671 	baseURI = _newBaseURI;
672 	}
673 	function setSaleStatus(bool _status) public onlyOwner {
674 	status = _status;
675 	}
676 	function withdraw() public onlyOwner {
677     (bool _dev, ) = payable(dev).call{value: address(this).balance*20/100}("");
678     require(_dev);
679     (bool _marketing, ) = payable(marketing).call{value: address(this).balance*3125/10000}("");
680     require(_marketing);
681     (bool _company, ) = payable(company).call{value: address(this).balance}("");
682     require(_company);
683 	}
684     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
685 	maxSupply = _newMaxSupply;
686 	}
687     function setFreeSupply(uint256 _newSupply) public onlyOwner {
688 	freeSupply = _newSupply;
689 	}
690 }