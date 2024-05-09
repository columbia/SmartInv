1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.15;
3 
4 abstract contract ReentrancyGuard {
5     uint256 private constant _NOT_ENTERED = 1;
6     uint256 private constant _ENTERED = 2;
7     uint256 private _status;
8 
9     constructor() {
10         _status = _NOT_ENTERED;
11     }
12 
13     modifier nonReentrant() {
14         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
15         _status = _ENTERED;
16         _;
17         _status = _NOT_ENTERED;
18     }
19 }
20 
21 pragma solidity ^0.8.15;
22 
23 interface IERC721Receiver {
24     function onERC721Received(
25         address operator,
26         address from,
27         uint256 tokenId,
28         bytes calldata data
29     ) external returns (bytes4);
30 }
31 
32 
33 pragma solidity ^0.8.15;
34 
35 library Address {
36 
37     function isContract(address account) internal view returns (bool) {
38         uint256 size;
39         assembly {
40             size := extcodesize(account)
41         }
42         return size > 0;
43     }
44 
45     function sendValue(address payable recipient, uint256 amount) internal {
46         require(address(this).balance >= amount, "Address: insufficient balance");
47         (bool success, ) = recipient.call{value: amount}("");
48         require(success, "Address: unable to send value, recipient may have reverted");
49     }
50 
51     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
52         return functionCall(target, data, "Address: low-level call failed");
53     }
54 
55     function functionCall(
56         address target,
57         bytes memory data,
58         string memory errorMessage
59     ) internal returns (bytes memory) {
60         return functionCallWithValue(target, data, 0, errorMessage);
61     }
62 
63     function functionCallWithValue(
64         address target,
65         bytes memory data,
66         uint256 value
67     ) internal returns (bytes memory) {
68         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
69     }
70 
71     function functionCallWithValue(
72         address target,
73         bytes memory data,
74         uint256 value,
75         string memory errorMessage
76     ) internal returns (bytes memory) {
77         require(address(this).balance >= value, "Address: insufficient balance for call");
78         require(isContract(target), "Address: call to non-contract");
79         (bool success, bytes memory returndata) = target.call{value: value}(data);
80         return verifyCallResult(success, returndata, errorMessage);
81     }
82 
83     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
84         return functionStaticCall(target, data, "Address: low-level static call failed");
85     }
86 
87     function functionStaticCall(
88         address target,
89         bytes memory data,
90         string memory errorMessage
91     ) internal view returns (bytes memory) {
92         require(isContract(target), "Address: static call to non-contract");
93         (bool success, bytes memory returndata) = target.staticcall(data);
94         return verifyCallResult(success, returndata, errorMessage);
95     }
96 
97     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
98         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
99     }
100 
101     function functionDelegateCall(
102         address target,
103         bytes memory data,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         require(isContract(target), "Address: delegate call to non-contract");
107         (bool success, bytes memory returndata) = target.delegatecall(data);
108         return verifyCallResult(success, returndata, errorMessage);
109     }
110 
111     function verifyCallResult(
112         bool success,
113         bytes memory returndata,
114         string memory errorMessage
115     ) internal pure returns (bytes memory) {
116         if (success) {
117             return returndata;
118         } else {
119             if (returndata.length > 0) {
120                 assembly {
121                     let returndata_size := mload(returndata)
122                     revert(add(32, returndata), returndata_size)
123                 }
124             } else {
125                 revert(errorMessage);
126             }
127         }
128     }
129 }
130 
131 pragma solidity ^0.8.15;
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 pragma solidity ^0.8.15;
143 
144 library Strings {
145     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
146     function toString(uint256 value) internal pure returns (string memory) {
147         if (value == 0) {
148             return "0";
149         }
150         uint256 temp = value;
151         uint256 digits;
152         while (temp != 0) {
153             digits++;
154             temp /= 10;
155         }
156         bytes memory buffer = new bytes(digits);
157         while (value != 0) {
158             digits -= 1;
159             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
160             value /= 10;
161         }
162         return string(buffer);
163     }
164 
165     function toHexString(uint256 value) internal pure returns (string memory) {
166         if (value == 0) {
167             return "0x00";
168         }
169         uint256 temp = value;
170         uint256 length = 0;
171         while (temp != 0) {
172             length++;
173             temp >>= 8;
174         }
175         return toHexString(value, length);
176     }
177 
178     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
179         bytes memory buffer = new bytes(2 * length + 2);
180         buffer[0] = "0";
181         buffer[1] = "x";
182         for (uint256 i = 2 * length + 1; i > 1; --i) {
183             buffer[i] = _HEX_SYMBOLS[value & 0xf];
184             value >>= 4;
185         }
186         require(value == 0, "Strings: hex length insufficient");
187         return string(buffer);
188     }
189 }
190 
191 pragma solidity ^0.8.15;
192 
193 interface IERC165 {
194     function supportsInterface(bytes4 interfaceId) external view returns (bool);
195 }
196 
197 
198 pragma solidity ^0.8.15;
199 
200 library SafeMath {
201     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
202         unchecked {
203             uint256 c = a + b;
204             if (c < a) return (false, 0);
205             return (true, c);
206         }
207     }
208 
209     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         unchecked {
211             if (b > a) return (false, 0);
212             return (true, a - b);
213         }
214     }
215 
216     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
217         unchecked {
218             if (a == 0) return (true, 0);
219             uint256 c = a * b;
220             if (c / a != b) return (false, 0);
221             return (true, c);
222         }
223     }
224 
225     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
226         unchecked {
227             if (b == 0) return (false, 0);
228             return (true, a / b);
229         }
230     }
231 
232     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
233         unchecked {
234             if (b == 0) return (false, 0);
235             return (true, a % b);
236         }
237     }
238 
239     function add(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a + b;
241     }
242 
243     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a - b;
245     }
246 
247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
248         return a * b;
249     }
250 
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a / b;
253     }
254 
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a % b;
257     }
258 
259     function sub(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         unchecked {
265             require(b <= a, errorMessage);
266             return a - b;
267         }
268     }
269 
270     function div(
271         uint256 a,
272         uint256 b,
273         string memory errorMessage
274     ) internal pure returns (uint256) {
275         unchecked {
276             require(b > 0, errorMessage);
277             return a / b;
278         }
279     }
280 
281     function mod(
282         uint256 a,
283         uint256 b,
284         string memory errorMessage
285     ) internal pure returns (uint256) {
286         unchecked {
287             require(b > 0, errorMessage);
288             return a % b;
289         }
290     }
291 }
292 
293 
294 pragma solidity ^0.8.15;
295 
296 abstract contract ERC165 is IERC165 {
297     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
298         return interfaceId == type(IERC165).interfaceId;
299     }
300 }
301 
302 
303 pragma solidity ^0.8.15;
304 
305 interface IERC721 is IERC165 {
306     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
307     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
308     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
309     function balanceOf(address owner) external view returns (uint256 balance);
310     function ownerOf(uint256 tokenId) external view returns (address owner);
311     function safeTransferFrom(
312         address from,
313         address to,
314         uint256 tokenId
315     ) external;
316 
317     function transferFrom(
318         address from,
319         address to,
320         uint256 tokenId
321     ) external;
322 
323     function approve(address to, uint256 tokenId) external;
324     function getApproved(uint256 tokenId) external view returns (address operator);
325     function setApprovalForAll(address operator, bool _approved) external;
326     function isApprovedForAll(address owner, address operator) external view returns (bool);
327     function safeTransferFrom(
328         address from,
329         address to,
330         uint256 tokenId,
331         bytes calldata data
332     ) external;
333 }
334 
335 
336 pragma solidity ^0.8.15;
337 
338 interface IERC721Metadata is IERC721 {
339     function name() external view returns (string memory);
340     function symbol() external view returns (string memory);
341     function tokenURI(uint256 tokenId) external view returns (string memory);
342 }
343 
344 
345 pragma solidity ^0.8.15;
346 interface IERC721Enumerable is IERC721 {
347     function totalSupply() external view returns (uint256);
348     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
349     function tokenByIndex(uint256 index) external view returns (uint256);
350 }
351 
352 pragma solidity ^0.8.15;
353 abstract contract Ownable is Context {
354     address private _owner;
355     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
356 
357     constructor() {
358         _setOwner(_msgSender());
359     }
360 
361     function owner() public view virtual returns (address) {
362         return _owner;
363     }
364 
365     modifier onlyOwner() {
366         require(owner() == _msgSender(), "Ownable: caller is not the owner");
367         _;
368     }
369 
370     function renounceOwnership() public virtual onlyOwner {
371         _setOwner(address(0));
372     }
373 
374     function transferOwnership(address newOwner) public virtual onlyOwner {
375         require(newOwner != address(0), "Ownable: new owner is the zero address");
376         _setOwner(newOwner);
377     }
378 
379     function _setOwner(address newOwner) private {
380         address oldOwner = _owner;
381         _owner = newOwner;
382         emit OwnershipTransferred(oldOwner, newOwner);
383     }
384 }
385 
386 pragma solidity ^0.8.15;
387 
388 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
389     using Address for address;
390     string private _name;
391     string private _symbol;
392     address[] internal _owners;
393     mapping(uint256 => address) private _tokenApprovals;
394     mapping(address => mapping(address => bool)) private _operatorApprovals;     
395     constructor(string memory name_, string memory symbol_) {
396         _name = name_;
397         _symbol = symbol_;
398     }     
399     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
400         return
401             interfaceId == type(IERC721).interfaceId ||
402             interfaceId == type(IERC721Metadata).interfaceId ||
403             super.supportsInterface(interfaceId);
404     }
405     function balanceOf(address owner) public view virtual override returns (uint256) {
406         require(owner != address(0), "ERC721: balance query for the zero address");
407         uint count = 0;
408         uint length = _owners.length;
409         for( uint i = 0; i < length; ++i ){
410           if( owner == _owners[i] ){
411             ++count;
412           }
413         }
414         delete length;
415         return count;
416     }
417     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
418         address owner = _owners[tokenId];
419         require(owner != address(0), "ERC721: owner query for nonexistent token");
420         return owner;
421     }
422     function name() public view virtual override returns (string memory) {
423         return _name;
424     }
425     function symbol() public view virtual override returns (string memory) {
426         return _symbol;
427     }
428     function approve(address to, uint256 tokenId) public virtual override {
429         address owner = ERC721.ownerOf(tokenId);
430         require(to != owner, "ERC721: approval to current owner");
431         require(
432             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
433             "ERC721: approve caller is not owner nor approved for all"
434         );
435         _approve(to, tokenId);
436     }
437     function getApproved(uint256 tokenId) public view virtual override returns (address) {
438         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
439         return _tokenApprovals[tokenId];
440     }
441     function setApprovalForAll(address operator, bool approved) public virtual override {
442         require(operator != _msgSender(), "ERC721: approve to caller");
443         _operatorApprovals[_msgSender()][operator] = approved;
444         emit ApprovalForAll(_msgSender(), operator, approved);
445     }
446     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
447         return _operatorApprovals[owner][operator];
448     }
449     function transferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) public virtual override {
454         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
455         _transfer(from, to, tokenId);
456     }
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) public virtual override {
462         safeTransferFrom(from, to, tokenId, "");
463     }
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId,
468         bytes memory _data
469     ) public virtual override {
470         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
471         _safeTransfer(from, to, tokenId, _data);
472     }     
473     function _safeTransfer(
474         address from,
475         address to,
476         uint256 tokenId,
477         bytes memory _data
478     ) internal virtual {
479         _transfer(from, to, tokenId);
480         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
481     }
482 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
483         return tokenId < _owners.length && _owners[tokenId] != address(0);
484     }
485 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
486         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
487         address owner = ERC721.ownerOf(tokenId);
488         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
489     }
490 	function _safeMint(address to, uint256 tokenId) internal virtual {
491         _safeMint(to, tokenId, "");
492     }
493 	function _safeMint(
494         address to,
495         uint256 tokenId,
496         bytes memory _data
497     ) internal virtual {
498         _mint(to, tokenId);
499         require(
500             _checkOnERC721Received(address(0), to, tokenId, _data),
501             "ERC721: transfer to non ERC721Receiver implementer"
502         );
503     }
504 	function _mint(address to, uint256 tokenId) internal virtual {
505         require(to != address(0), "ERC721: mint to the zero address");
506         require(!_exists(tokenId), "ERC721: token already minted");
507         _beforeTokenTransfer(address(0), to, tokenId);
508         _owners.push(to);
509         emit Transfer(address(0), to, tokenId);
510     }
511 	function _burn(uint256 tokenId) internal virtual {
512         address owner = ERC721.ownerOf(tokenId);
513         _beforeTokenTransfer(owner, address(0), tokenId);
514         _approve(address(0), tokenId);
515         _owners[tokenId] = address(0);
516         emit Transfer(owner, address(0), tokenId);
517     }
518 	function _transfer(
519         address from,
520         address to,
521         uint256 tokenId
522     ) internal virtual {
523         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
524         require(to != address(0), "ERC721: transfer to the zero address");
525         _beforeTokenTransfer(from, to, tokenId);
526         _approve(address(0), tokenId);
527         _owners[tokenId] = to;
528         emit Transfer(from, to, tokenId);
529     }
530 	function _approve(address to, uint256 tokenId) internal virtual {
531         _tokenApprovals[tokenId] = to;
532         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
533     }
534 	function _checkOnERC721Received(
535         address from,
536         address to,
537         uint256 tokenId,
538         bytes memory _data
539     ) private returns (bool) {
540         if (to.isContract()) {
541             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
542                 return retval == IERC721Receiver.onERC721Received.selector;
543             } catch (bytes memory reason) {
544                 if (reason.length == 0) {
545                     revert("ERC721: transfer to non ERC721Receiver implementer");
546                 } else {
547                     assembly {
548                         revert(add(32, reason), mload(reason))
549                     }
550                 }
551             }
552         } else {
553             return true;
554         }
555     }
556 	function _beforeTokenTransfer(
557         address from,
558         address to,
559         uint256 tokenId
560     ) internal virtual {}
561 }
562 
563 
564 pragma solidity ^0.8.15;
565 abstract contract ERC721Enum is ERC721, IERC721Enumerable {
566     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
567         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
568     }
569     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
570         require(index < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
571         uint count;
572         for( uint i; i < _owners.length; ++i ){
573             if( owner == _owners[i] ){
574                 if( count == index )
575                     return i;
576                 else
577                     ++count;
578             }
579         }
580         require(false, "ERC721Enum: owner ioob");
581     }
582     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
583         require(0 < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
584         uint256 tokenCount = balanceOf(owner);
585         uint256[] memory tokenIds = new uint256[](tokenCount);
586         for (uint256 i = 0; i < tokenCount; i++) {
587             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
588         }
589         return tokenIds;
590     }
591     function totalSupply() public view virtual override returns (uint256) {
592         return _owners.length;
593     }
594     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
595         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
596         return index;
597     }
598 }
599 
600 
601 pragma solidity ^0.8.15;
602 
603 contract AlphaSpy is ERC721Enum, Ownable, ReentrancyGuard {
604 	using Strings for uint256;
605 	string public baseURI;
606 	//sale settings
607 	uint256 public cost = 0.03 ether;
608 	uint256 public maxSupply = 2000;
609 	uint256 public maxMint = 5;
610     address private company = 0x32C0A78CD060115Cce5E851e48913e368119F879;
611 	bool public status = false;
612 
613 	constructor(
614 	string memory _name,
615 	string memory _symbol,
616 	string memory _initBaseURI
617 	) ERC721(_name, _symbol){
618 	setBaseURI(_initBaseURI);
619 	}
620 	// internal
621 	function _baseURI() internal view virtual returns (string memory) {
622 	return baseURI;
623 	}
624 	function mint(uint256 _mintAmount) public payable nonReentrant{
625 	uint256 s = totalSupply();
626 	require(status, "Off" );
627 	require(_mintAmount > 0, "0" );
628 	require(_mintAmount <= maxMint, "Too many" );
629 	require(s + _mintAmount <= maxSupply, "Max" );
630 	require(msg.value >= cost * _mintAmount);
631 	for (uint256 i = 0; i < _mintAmount; ++i) {
632 	_safeMint(msg.sender, s + i, "");
633 	}
634 	delete s;
635 	}
636 	function adminMint(address[] calldata recipient) external onlyOwner{
637 	uint256 s = totalSupply();
638 	require(s + recipient.length <= maxSupply, "Too many" );
639 	for(uint i = 0; i < recipient.length; ++i){
640 	_safeMint(recipient[i], s++, "" );
641 	}
642 	delete s;	
643 	}
644 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
645 	require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
646 	string memory currentBaseURI = _baseURI();
647 	return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
648 	}
649 	function setCost(uint256 _newCost) public onlyOwner {
650 	cost = _newCost;
651 	}
652 	function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
653 	maxMint = _newMaxMintAmount;
654 	}
655 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
656 	baseURI = _newBaseURI;
657 	}
658 	function setSaleStatus(bool _status) public onlyOwner {
659 	status = _status;
660 	}
661 	function withdraw() public onlyOwner {
662     (bool _company, ) = payable(company).call{value: address(this).balance}("");
663     require(_company);
664 	}
665     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
666 	maxSupply = _newMaxSupply;
667 	}
668 }