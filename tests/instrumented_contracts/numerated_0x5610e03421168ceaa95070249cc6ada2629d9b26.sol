1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.0;
3 library Strings {
4     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
5     function toString(uint256 value) internal pure returns (string memory) {
6         if (value == 0) {
7             return "0";
8         }
9         uint256 temp = value;
10         uint256 digits;
11         while (temp != 0) {
12             digits++;
13             temp /= 10;
14         }
15         bytes memory buffer = new bytes(digits);
16         while (value != 0) {
17             digits -= 1;
18             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
19             value /= 10;
20         }
21         return string(buffer);
22     }
23     function toHexString(uint256 value) internal pure returns (string memory) {
24         if (value == 0) {
25             return "0x00";
26         }
27         uint256 temp = value;
28         uint256 length = 0;
29         while (temp != 0) {
30             length++;
31             temp >>= 8;
32         }
33         return toHexString(value, length);
34     }
35     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
36         bytes memory buffer = new bytes(2 * length + 2);
37         buffer[0] = "0";
38         buffer[1] = "x";
39         for (uint256 i = 2 * length + 1; i > 1; --i) {
40             buffer[i] = _HEX_SYMBOLS[value & 0xf];
41             value >>= 4;
42         }
43         require(value == 0, "Strings: hex length insufficient");
44         return string(buffer);
45     }
46 }
47 pragma solidity ^0.8.0;
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes calldata) {
54         return msg.data;
55     }
56 }
57 pragma solidity ^0.8.0;
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         _transferOwnership(newOwner);
79     }
80     function _transferOwnership(address newOwner) internal virtual {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 pragma solidity ^0.8.1;
88 
89 library Address {
90     function isContract(address account) internal view returns (bool) {
91         return account.code.length > 0;
92     }
93     function sendValue(address payable recipient, uint256 amount) internal {
94         require(address(this).balance >= amount, "Address: insufficient balance");
95 
96         (bool success, ) = recipient.call{value: amount}("");
97         require(success, "Address: unable to send value, recipient may have reverted");
98     }
99     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
100         return functionCall(target, data, "Address: low-level call failed");
101     }
102     function functionCall(
103         address target,
104         bytes memory data,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, errorMessage);
108     }
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value,
120         string memory errorMessage
121     ) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         require(isContract(target), "Address: call to non-contract");
124 
125         (bool success, bytes memory returndata) = target.call{value: value}(data);
126         return verifyCallResult(success, returndata, errorMessage);
127     }
128     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
129         return functionStaticCall(target, data, "Address: low-level static call failed");
130     }
131     function functionStaticCall(
132         address target,
133         bytes memory data,
134         string memory errorMessage
135     ) internal view returns (bytes memory) {
136         require(isContract(target), "Address: static call to non-contract");
137 
138         (bool success, bytes memory returndata) = target.staticcall(data);
139         return verifyCallResult(success, returndata, errorMessage);
140     }
141     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
142         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
143     }
144     function functionDelegateCall(
145         address target,
146         bytes memory data,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(isContract(target), "Address: delegate call to non-contract");
150 
151         (bool success, bytes memory returndata) = target.delegatecall(data);
152         return verifyCallResult(success, returndata, errorMessage);
153     }
154     function verifyCallResult(
155         bool success,
156         bytes memory returndata,
157         string memory errorMessage
158     ) internal pure returns (bytes memory) {
159         if (success) {
160             return returndata;
161         } else {
162             if (returndata.length > 0) {
163                 assembly {
164                     let returndata_size := mload(returndata)
165                     revert(add(32, returndata), returndata_size)
166                 }
167             } else {
168                 revert(errorMessage);
169             }
170         }
171     }
172 }
173 pragma solidity ^0.8.0;
174 
175 interface IERC721Receiver {
176     function onERC721Received(
177         address operator,
178         address from,
179         uint256 tokenId,
180         bytes calldata data
181     ) external returns (bytes4);
182 }
183 
184 pragma solidity ^0.8.0;
185 
186 interface IERC165 {
187     function supportsInterface(bytes4 interfaceId) external view returns (bool);
188 }
189 
190 
191 pragma solidity ^0.8.0;
192 
193 
194 abstract contract ERC165 is IERC165 {
195     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
196         return interfaceId == type(IERC165).interfaceId;
197     }
198 }
199 
200 pragma solidity ^0.8.0;
201 
202 
203 interface IERC721 is IERC165 {
204     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
205 
206     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
207 
208     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
209 
210     function balanceOf(address owner) external view returns (uint256 balance);
211 
212     function ownerOf(uint256 tokenId) external view returns (address owner);
213 
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219 
220     function transferFrom(
221         address from,
222         address to,
223         uint256 tokenId
224     ) external;
225 
226     function approve(address to, uint256 tokenId) external;
227 
228     function getApproved(uint256 tokenId) external view returns (address operator);
229 
230     function setApprovalForAll(address operator, bool _approved) external;
231 
232     function isApprovedForAll(address owner, address operator) external view returns (bool);
233 
234     function safeTransferFrom(
235         address from,
236         address to,
237         uint256 tokenId,
238         bytes calldata data
239     ) external;
240 }
241 
242 
243 pragma solidity ^0.8.0;
244 
245 
246 interface IERC721Enumerable is IERC721 {
247     function totalSupply() external view returns (uint256);
248 
249     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
250 
251     function tokenByIndex(uint256 index) external view returns (uint256);
252 }
253 
254 
255 
256 pragma solidity ^0.8.0;
257 
258 
259 interface IERC721Metadata is IERC721 {
260     function name() external view returns (string memory);
261 
262     function symbol() external view returns (string memory);
263 
264     function tokenURI(uint256 tokenId) external view returns (string memory);
265 }
266 
267 pragma solidity ^0.8.0;
268 
269 
270 
271 
272 
273 
274 
275 
276 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
277     using Address for address;
278     using Strings for uint256;
279 
280     string private _name;
281 
282     string private _symbol;
283 
284     mapping(uint256 => address) private _owners;
285 
286     mapping(address => uint256) private _balances;
287 
288     mapping(uint256 => address) private _tokenApprovals;
289 
290     mapping(address => mapping(address => bool)) private _operatorApprovals;
291 
292     constructor(string memory name_, string memory symbol_) {
293         _name = name_;
294         _symbol = symbol_;
295     }
296 
297     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
298         return
299             interfaceId == type(IERC721).interfaceId ||
300             interfaceId == type(IERC721Metadata).interfaceId ||
301             super.supportsInterface(interfaceId);
302     }
303 
304     function balanceOf(address owner) public view virtual override returns (uint256) {
305         require(owner != address(0), "ERC721: balance query for the zero address");
306         return _balances[owner];
307     }
308 
309     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
310         address owner = _owners[tokenId];
311         require(owner != address(0), "ERC721: owner query for nonexistent token");
312         return owner;
313     }
314 
315     function name() public view virtual override returns (string memory) {
316         return _name;
317     }
318 
319     function symbol() public view virtual override returns (string memory) {
320         return _symbol;
321     }
322 
323     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
324         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
325 
326         string memory baseURI = _baseURI();
327         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
328     }
329 
330     function _baseURI() internal view virtual returns (string memory) {
331         return "";
332     }
333 
334     function approve(address to, uint256 tokenId) public virtual override {
335         address owner = ERC721.ownerOf(tokenId);
336         require(to != owner, "ERC721: approval to current owner");
337 
338         require(
339             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
340             "ERC721: approve caller is not owner nor approved for all"
341         );
342 
343         _approve(to, tokenId);
344     }
345 
346     function getApproved(uint256 tokenId) public view virtual override returns (address) {
347         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
348 
349         return _tokenApprovals[tokenId];
350     }
351 
352     function setApprovalForAll(address operator, bool approved) public virtual override {
353         _setApprovalForAll(_msgSender(), operator, approved);
354     }
355 
356     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
357         return _operatorApprovals[owner][operator];
358     }
359 
360     function transferFrom(
361         address from,
362         address to,
363         uint256 tokenId
364     ) public virtual override {
365         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
366 
367         _transfer(from, to, tokenId);
368     }
369 
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) public virtual override {
375         safeTransferFrom(from, to, tokenId, "");
376     }
377 
378 
379     function safeTransferFrom(
380         address from,
381         address to,
382         uint256 tokenId,
383         bytes memory _data
384     ) public virtual override {
385         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
386         _safeTransfer(from, to, tokenId, _data);
387     }
388 
389     function _safeTransfer(
390         address from,
391         address to,
392         uint256 tokenId,
393         bytes memory _data
394     ) internal virtual {
395         _transfer(from, to, tokenId);
396         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
397     }
398 
399     function _exists(uint256 tokenId) internal view virtual returns (bool) {
400         return _owners[tokenId] != address(0);
401     }
402 
403     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
404         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
405         address owner = ERC721.ownerOf(tokenId);
406         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
407     }
408 
409     function _safeMint(address to, uint256 tokenId) internal virtual {
410         _safeMint(to, tokenId, "");
411     }
412 
413     function _safeMint(
414         address to,
415         uint256 tokenId,
416         bytes memory _data
417     ) internal virtual {
418         _mint(to, tokenId);
419         require(
420             _checkOnERC721Received(address(0), to, tokenId, _data),
421             "ERC721: transfer to non ERC721Receiver implementer"
422         );
423     }
424 
425     function _mint(address to, uint256 tokenId) internal virtual {
426         require(to != address(0), "ERC721: mint to the zero address");
427         require(!_exists(tokenId), "ERC721: token already minted");
428 
429         _beforeTokenTransfer(address(0), to, tokenId);
430 
431         _balances[to] += 1;
432         _owners[tokenId] = to;
433 
434         emit Transfer(address(0), to, tokenId);
435 
436         _afterTokenTransfer(address(0), to, tokenId);
437     }
438 
439     function _burn(uint256 tokenId) internal virtual {
440         address owner = ERC721.ownerOf(tokenId);
441 
442         _beforeTokenTransfer(owner, address(0), tokenId);
443 
444         _approve(address(0), tokenId);
445 
446         _balances[owner] -= 1;
447         delete _owners[tokenId];
448 
449         emit Transfer(owner, address(0), tokenId);
450 
451         _afterTokenTransfer(owner, address(0), tokenId);
452     }
453 
454     function _transfer(
455         address from,
456         address to,
457         uint256 tokenId
458     ) internal virtual {
459         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
460         require(to != address(0), "ERC721: transfer to the zero address");
461 
462         _beforeTokenTransfer(from, to, tokenId);
463 
464         _approve(address(0), tokenId);
465 
466         _balances[from] -= 1;
467         _balances[to] += 1;
468         _owners[tokenId] = to;
469 
470         emit Transfer(from, to, tokenId);
471 
472         _afterTokenTransfer(from, to, tokenId);
473     }
474 
475     function _approve(address to, uint256 tokenId) internal virtual {
476         _tokenApprovals[tokenId] = to;
477         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
478     }
479 
480     function _setApprovalForAll(
481         address owner,
482         address operator,
483         bool approved
484     ) internal virtual {
485         require(owner != operator, "ERC721: approve to caller");
486         _operatorApprovals[owner][operator] = approved;
487         emit ApprovalForAll(owner, operator, approved);
488     }
489 
490     function _checkOnERC721Received(
491         address from,
492         address to,
493         uint256 tokenId,
494         bytes memory _data
495     ) private returns (bool) {
496         if (to.isContract()) {
497             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
498                 return retval == IERC721Receiver.onERC721Received.selector;
499             } catch (bytes memory reason) {
500                 if (reason.length == 0) {
501                     revert("ERC721: transfer to non ERC721Receiver implementer");
502                 } else {
503                     assembly {
504                         revert(add(32, reason), mload(reason))
505                     }
506                 }
507             }
508         } else {
509             return true;
510         }
511     }
512 
513     function _beforeTokenTransfer(
514         address from,
515         address to,
516         uint256 tokenId
517     ) internal virtual {}
518 
519     function _afterTokenTransfer(
520         address from,
521         address to,
522         uint256 tokenId
523     ) internal virtual {}
524 }
525 
526 pragma solidity ^0.8.0;
527 
528 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
529     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
530 
531     mapping(uint256 => uint256) private _ownedTokensIndex;
532 
533     uint256[] private _allTokens;
534 
535     mapping(uint256 => uint256) private _allTokensIndex;
536 
537     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
538         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
539     }
540 
541     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
542         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
543         return _ownedTokens[owner][index];
544     }
545 
546     function totalSupply() public view virtual override returns (uint256) {
547         return _allTokens.length;
548     }
549 
550     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
551         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
552         return _allTokens[index];
553     }
554 
555     function _beforeTokenTransfer(
556         address from,
557         address to,
558         uint256 tokenId
559     ) internal virtual override {
560         super._beforeTokenTransfer(from, to, tokenId);
561 
562         if (from == address(0)) {
563             _addTokenToAllTokensEnumeration(tokenId);
564         } else if (from != to) {
565             _removeTokenFromOwnerEnumeration(from, tokenId);
566         }
567         if (to == address(0)) {
568             _removeTokenFromAllTokensEnumeration(tokenId);
569         } else if (to != from) {
570             _addTokenToOwnerEnumeration(to, tokenId);
571         }
572     }
573 
574     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
575         uint256 length = ERC721.balanceOf(to);
576         _ownedTokens[to][length] = tokenId;
577         _ownedTokensIndex[tokenId] = length;
578     }
579 
580     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
581         _allTokensIndex[tokenId] = _allTokens.length;
582         _allTokens.push(tokenId);
583     }
584 
585     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
586 
587         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
588         uint256 tokenIndex = _ownedTokensIndex[tokenId];
589 
590         if (tokenIndex != lastTokenIndex) {
591             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
592 
593             _ownedTokens[from][tokenIndex] = lastTokenId;
594             _ownedTokensIndex[lastTokenId] = tokenIndex;
595         }
596 
597         delete _ownedTokensIndex[tokenId];
598         delete _ownedTokens[from][lastTokenIndex];
599     }
600 
601     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
602 
603         uint256 lastTokenIndex = _allTokens.length - 1;
604         uint256 tokenIndex = _allTokensIndex[tokenId];
605 
606         uint256 lastTokenId = _allTokens[lastTokenIndex];
607 
608         _allTokens[tokenIndex] = lastTokenId;
609         _allTokensIndex[lastTokenId] = tokenIndex;
610 
611         delete _allTokensIndex[tokenId];
612         _allTokens.pop();
613     }
614 }
615 
616 pragma solidity >=0.7.0 <0.9.0;
617 
618 contract NFT is ERC721Enumerable, Ownable {
619   using Strings for uint256;
620 
621   string public baseURI;
622   string public baseExtension = ".json";
623   uint256 public cost = 0.0042 ether;
624   uint256 public maxSupply = 2222;
625   uint256 public maxMintAmount = 100;
626   bool public paused = false;
627   mapping(address => bool) public whitelisted;
628 
629   constructor() ERC721("PunkToadz", "PT") {
630     setBaseURI("https://bafybeiglrxiswcqbxjzlrqebtc4nfakeetw2iueruvmxverl4u37rzeija.ipfs.w3s.link/");
631   }
632 
633   function _baseURI() internal view virtual override returns (string memory) {
634     return baseURI;
635   }
636 
637   function mint(address _to, uint256 _mintAmount) public payable {
638     uint256 supply = totalSupply();
639     require(!paused);
640     require(_mintAmount > 0);
641     require(_mintAmount <= maxMintAmount);
642     require(supply + _mintAmount <= maxSupply);
643 
644     if (msg.sender != owner()) {
645         if(whitelisted[msg.sender] != true) {
646           require(msg.value >= cost * _mintAmount);
647         }
648     }
649 
650     for (uint256 i = 1; i <= _mintAmount; i++) {
651       _safeMint(_to, supply + i);
652     }
653   }
654 
655   function walletOfOwner(address _owner)
656     public
657     view
658     returns (uint256[] memory)
659   {
660     uint256 ownerTokenCount = balanceOf(_owner);
661     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
662     for (uint256 i; i < ownerTokenCount; i++) {
663       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
664     }
665     return tokenIds;
666   }
667 
668   function tokenURI(uint256 tokenId)
669     public
670     view
671     virtual
672     override
673     returns (string memory)
674   {
675     require(
676       _exists(tokenId),
677       "ERC721Metadata: URI query for nonexistent token"
678     );
679 
680     string memory currentBaseURI = _baseURI();
681     return bytes(currentBaseURI).length > 0
682         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
683         : "";
684   }
685 
686   function setCost(uint256 _newCost) public onlyOwner {
687     cost = _newCost;
688   }
689 
690   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
691     maxMintAmount = _newmaxMintAmount;
692   }
693 
694   function setBaseURI(string memory _newBaseURI) public onlyOwner {
695     baseURI = _newBaseURI;
696   }
697 
698   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
699     baseExtension = _newBaseExtension;
700   }
701 
702   function pause(bool _state) public onlyOwner {
703     paused = _state;
704   }
705  
706   function whitelistUser(address _user) public onlyOwner {
707     whitelisted[_user] = true;
708   }
709  
710   function removeWhitelistUser(address _user) public onlyOwner {
711     whitelisted[_user] = false;
712   }
713 
714   function withdraw() public payable onlyOwner {
715     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
716     require(os);
717   }
718 }