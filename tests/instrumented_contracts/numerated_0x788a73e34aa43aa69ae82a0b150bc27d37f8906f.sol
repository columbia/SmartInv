1 //SPDX-License-Identifier: Unlicense
2 pragma solidity ^0.8.0;
3 
4 interface IERC165 {
5 
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 
8 }
9 
10 interface IERC721 is IERC165 {
11 
12     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
13     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
14     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
15 
16     function balanceOf(address owner) external view returns (uint256 balance);
17     function ownerOf(uint256 tokenId) external view returns (address owner);
18 
19     function safeTransferFrom(
20         address from,
21         address to,
22         uint256 tokenId
23     ) external;
24 
25     function transferFrom(
26         address from,
27         address to,
28         uint256 tokenId
29     ) external;
30 
31     function approve(address to, uint256 tokenId) external;
32     function getApproved(uint256 tokenId) external view returns (address operator);
33     function setApprovalForAll(address operator, bool _approved) external;
34     function isApprovedForAll(address owner, address operator) external view returns (bool);
35 
36     function safeTransferFrom(
37         address from,
38         address to,
39         uint256 tokenId,
40         bytes calldata data
41     ) external;
42 }
43 
44 library Strings {
45 
46     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
47 
48     function toString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0";
51         }
52         uint256 temp = value;
53         uint256 digits;
54         while (temp != 0) {
55             digits++;
56             temp /= 10;
57         }
58         bytes memory buffer = new bytes(digits);
59         while (value != 0) {
60             digits -= 1;
61             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
62             value /= 10;
63         }
64         return string(buffer);
65     }
66 
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 
92 }
93 
94 abstract contract Context {
95 
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         return msg.data;
102     }
103 
104 }
105 
106 abstract contract Ownable is Context {
107 
108     address private _owner;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     constructor() {
113         _setOwner(_msgSender());
114     }
115 
116     function owner() public view virtual returns (address) {
117         return _owner;
118     }
119 
120     modifier onlyOwner() {
121         require(owner() == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     function renounceOwnership() public virtual onlyOwner {
126         _setOwner(address(0));
127     }
128 
129     function transferOwnership(address newOwner) public virtual onlyOwner {
130         require(newOwner != address(0), "Ownable: new owner is the zero address");
131         _setOwner(newOwner);
132     }
133 
134     function _setOwner(address newOwner) private {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 abstract contract ReentrancyGuard {
142 
143     uint256 private constant _NOT_ENTERED = 1;
144     uint256 private constant _ENTERED = 2;
145     uint256 private _status;
146 
147     constructor() {
148         _status = _NOT_ENTERED;
149     }
150 
151     modifier nonReentrant() {
152 
153         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
154 
155         _status = _ENTERED; _; _status = _NOT_ENTERED;
156 
157     }
158 
159 }
160 
161 interface IERC721Receiver {
162 
163     function onERC721Received(
164         address operator,
165         address from,
166         uint256 tokenId,
167         bytes calldata data
168     ) external returns (bytes4);
169 
170 }
171 
172 interface IERC721Metadata is IERC721 {
173 
174     function name() external view returns (string memory);
175     function symbol() external view returns (string memory);
176     function tokenURI(uint256 tokenId) external view returns (string memory);
177 
178 }
179 
180 library Address {
181 
182     function isContract(address account) internal view returns (bool) {
183 
184         uint256 size;
185         assembly {
186             size := extcodesize(account)
187         }
188         return size > 0;
189     }
190 
191     function sendValue(address payable recipient, uint256 amount) internal {
192         require(address(this).balance >= amount, "Address: insufficient balance");
193 
194         (bool success, ) = recipient.call{value: amount}("");
195         require(success, "Address: unable to send value, recipient may have reverted");
196     }
197 
198     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionCall(target, data, "Address: low-level call failed");
200     }
201 
202     function functionCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, 0, errorMessage);
208     }
209 
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
216     }
217 
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(address(this).balance >= value, "Address: insufficient balance for call");
225         require(isContract(target), "Address: call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.call{value: value}(data);
228         return _verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
232         return functionStaticCall(target, data, "Address: low-level static call failed");
233     }
234 
235     function functionStaticCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal view returns (bytes memory) {
240         require(isContract(target), "Address: static call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.staticcall(data);
243         return _verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     function functionDelegateCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(isContract(target), "Address: delegate call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.delegatecall(data);
258         return _verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     function _verifyCallResult(
262         bool success,
263         bytes memory returndata,
264         string memory errorMessage
265     ) private pure returns (bytes memory) {
266         if (success) {
267             return returndata;
268         } else {
269             if (returndata.length > 0) {
270                 assembly {
271                     let returndata_size := mload(returndata)
272                     revert(add(32, returndata), returndata_size)
273                 }
274             } else {
275                 revert(errorMessage);
276             }
277         }
278     }
279 }
280 
281 abstract contract ERC165 is IERC165 {
282 
283     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
284         return interfaceId == type(IERC165).interfaceId;
285     }
286 
287 }
288 
289 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
290 
291     using Address for address;
292     using Strings for uint256;
293 
294     string private _name;
295     string private _symbol;
296 
297     mapping(uint256 => address) private _owners;
298     mapping(address => uint256) private _balances;
299     mapping(uint256 => address) private _tokenApprovals;
300     mapping(address => mapping(address => bool)) private _operatorApprovals;
301 
302     constructor(string memory name_, string memory symbol_) {
303         _name = name_;
304         _symbol = symbol_;
305     }
306 
307     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
308         return
309             interfaceId == type(IERC721).interfaceId ||
310             interfaceId == type(IERC721Metadata).interfaceId ||
311             super.supportsInterface(interfaceId);
312     }
313 
314     function balanceOf(address owner) public view virtual override returns (uint256) {
315         require(owner != address(0), "ERC721: balance query for the zero address");
316         return _balances[owner];
317     }
318 
319     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
320         address owner = _owners[tokenId];
321         require(owner != address(0), "ERC721: owner query for nonexistent token");
322         return owner;
323     }
324 
325     function name() public view virtual override returns (string memory) {
326         return _name;
327     }
328 
329     function symbol() public view virtual override returns (string memory) {
330         return _symbol;
331     }
332 
333     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
334         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
335 
336         string memory baseURI = _baseURI();
337         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
338     }
339 
340     function _baseURI() internal view virtual returns (string memory) {
341         return "";
342     }
343 
344     function approve(address to, uint256 tokenId) public virtual override {
345         address owner = ERC721.ownerOf(tokenId);
346         require(to != owner, "ERC721: approval to current owner");
347 
348         require(
349             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
350             "ERC721: approve caller is not owner nor approved for all"
351         );
352 
353         _approve(to, tokenId);
354     }
355 
356     function getApproved(uint256 tokenId) public view virtual override returns (address) {
357         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
358 
359         return _tokenApprovals[tokenId];
360     }
361 
362     function setApprovalForAll(address operator, bool approved) public virtual override {
363         require(operator != _msgSender(), "ERC721: approve to caller");
364 
365         _operatorApprovals[_msgSender()][operator] = approved;
366         emit ApprovalForAll(_msgSender(), operator, approved);
367     }
368 
369     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
370         return _operatorApprovals[owner][operator];
371     }
372 
373     function transferFrom(
374         address from,
375         address to,
376         uint256 tokenId
377     ) public virtual override {
378         //solhint-disable-next-line max-line-length
379         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
380 
381         _transfer(from, to, tokenId);
382     }
383 
384     function safeTransferFrom(
385         address from,
386         address to,
387         uint256 tokenId
388     ) public virtual override {
389         safeTransferFrom(from, to, tokenId, "");
390     }
391 
392     function safeTransferFrom(
393         address from,
394         address to,
395         uint256 tokenId,
396         bytes memory _data
397     ) public virtual override {
398         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
399         _safeTransfer(from, to, tokenId, _data);
400     }
401 
402     function _safeTransfer(
403         address from,
404         address to,
405         uint256 tokenId,
406         bytes memory _data
407     ) internal virtual {
408         _transfer(from, to, tokenId);
409         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
410     }
411 
412     function _exists(uint256 tokenId) internal view virtual returns (bool) {
413         return _owners[tokenId] != address(0);
414     }
415 
416     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
417         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
418         address owner = ERC721.ownerOf(tokenId);
419         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
420     }
421 
422     function _safeMint(address to, uint256 tokenId) internal virtual {
423         _safeMint(to, tokenId, "");
424     }
425 
426     function _safeMint(
427         address to,
428         uint256 tokenId,
429         bytes memory _data
430     ) internal virtual {
431         _mint(to, tokenId);
432         require(
433             _checkOnERC721Received(address(0), to, tokenId, _data),
434             "ERC721: transfer to non ERC721Receiver implementer"
435         );
436     }
437 
438     function _mint(address to, uint256 tokenId) internal virtual {
439         require(to != address(0), "ERC721: mint to the zero address");
440         require(!_exists(tokenId), "ERC721: token already minted");
441 
442         _beforeTokenTransfer(address(0), to, tokenId);
443 
444         _balances[to] += 1;
445         _owners[tokenId] = to;
446 
447         emit Transfer(address(0), to, tokenId);
448     }
449 
450     function _burn(uint256 tokenId) internal virtual {
451         address owner = ERC721.ownerOf(tokenId);
452 
453         _beforeTokenTransfer(owner, address(0), tokenId);
454 
455         // Clear approvals
456         _approve(address(0), tokenId);
457 
458         _balances[owner] -= 1;
459         delete _owners[tokenId];
460 
461         emit Transfer(owner, address(0), tokenId);
462     }
463 
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
482 
483     function _approve(address to, uint256 tokenId) internal virtual {
484         _tokenApprovals[tokenId] = to;
485         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
486     }
487 
488     function _checkOnERC721Received(
489         address from,
490         address to,
491         uint256 tokenId,
492         bytes memory _data
493     ) private returns (bool) {
494         if (to.isContract()) {
495             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
496                 return retval == IERC721Receiver(to).onERC721Received.selector;
497             } catch (bytes memory reason) {
498                 if (reason.length == 0) {
499                     revert("ERC721: transfer to non ERC721Receiver implementer");
500                 } else {
501                     assembly {
502                         revert(add(32, reason), mload(reason))
503                     }
504                 }
505             }
506         } else {
507             return true;
508         }
509     }
510 
511     function _beforeTokenTransfer(
512         address from,
513         address to,
514         uint256 tokenId
515     ) internal virtual {}
516 }
517 
518 interface IERC721Enumerable is IERC721 {
519 
520     function totalSupply() external view returns (uint256);
521     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
522     function tokenByIndex(uint256 index) external view returns (uint256);
523 
524 }
525 
526 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
527 
528     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
529     mapping(uint256 => uint256) private _ownedTokensIndex;
530 
531     uint256[] private _allTokens;
532 
533     mapping(uint256 => uint256) private _allTokensIndex;
534 
535     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
536         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
537     }
538 
539     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
540         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
541         return _ownedTokens[owner][index];
542     }
543 
544     function totalSupply() public view virtual override returns (uint256) {
545         return _allTokens.length;
546     }
547 
548     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
549         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
550         return _allTokens[index];
551     }
552 
553     function _beforeTokenTransfer(
554         address from,
555         address to,
556         uint256 tokenId
557     ) internal virtual override {
558         super._beforeTokenTransfer(from, to, tokenId);
559 
560         if (from == address(0)) {
561             _addTokenToAllTokensEnumeration(tokenId);
562         } else if (from != to) {
563             _removeTokenFromOwnerEnumeration(from, tokenId);
564         }
565         if (to == address(0)) {
566             _removeTokenFromAllTokensEnumeration(tokenId);
567         } else if (to != from) {
568             _addTokenToOwnerEnumeration(to, tokenId);
569         }
570     }
571 
572     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
573         uint256 length = ERC721.balanceOf(to);
574         _ownedTokens[to][length] = tokenId;
575         _ownedTokensIndex[tokenId] = length;
576     }
577 
578     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
579         _allTokensIndex[tokenId] = _allTokens.length;
580         _allTokens.push(tokenId);
581     }
582 
583     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
584 
585         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
586         uint256 tokenIndex = _ownedTokensIndex[tokenId];
587 
588         if (tokenIndex != lastTokenIndex) {
589             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
590 
591             _ownedTokens[from][tokenIndex] = lastTokenId;
592             _ownedTokensIndex[lastTokenId] = tokenIndex;
593         }
594 
595         delete _ownedTokensIndex[tokenId];
596         delete _ownedTokens[from][lastTokenIndex];
597     }
598 
599     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
600 
601         uint256 lastTokenIndex = _allTokens.length - 1;
602         uint256 tokenIndex = _allTokensIndex[tokenId];
603         uint256 lastTokenId = _allTokens[lastTokenIndex];
604 
605         _allTokens[tokenIndex] = lastTokenId;
606         _allTokensIndex[lastTokenId] = tokenIndex;
607 
608         delete _allTokensIndex[tokenId];
609         _allTokens.pop();
610     }
611 }
612 
613 //////////////////////////////////////////////////////////////////////////////////////////////
614 //'████████::'██::::::::::'███::::'████████:'████████:::::::'██::::::::::'███::::'████████:://
615 // ██.... ██: ██:::::::::'██ ██:::..... ██::..... ██:::::::: ██:::::::::'██ ██::: ██.... ██://
616 // ██:::: ██: ██::::::::'██:. ██:::::: ██::::::: ██::::::::: ██::::::::'██:. ██:: ██:::: ██://
617 // ████████:: ██:::::::'██:::. ██:::: ██::::::: ██:::::::::: ██:::::::'██:::. ██: ████████:://
618 // ██.... ██: ██::::::: █████████::: ██::::::: ██::::::::::: ██::::::: █████████: ██.... ██://
619 // ██:::: ██: ██::::::: ██.... ██:: ██::::::: ██:::::::::::: ██::::::: ██.... ██: ██:::: ██://
620 // ████████:: ████████: ██:::: ██: ████████: ████████::::::: ████████: ██:::: ██: ████████:://
621 //..........................................................................................//
622 //.......................................................................by Jr Casas........//
623 //////////////////////////////////////////////////////////////////////////////////////////////
624 
625 
626  
627 
628  contract BlazzLab is ERC721Enumerable, ReentrancyGuard, Ownable {
629 
630     uint256 public maxSupply = 3333;
631     uint256 public price = 0.01 ether;
632     uint256 public maxMint = 8;
633     uint256 public numTokensMinted;
634 
635     string[10] private thirdNames = ['Finger', 'Bitten Finger', 'Zombie Finger', 'Zombie Bitten Finger', 'Eye', 'Denture', 'Denture Gold', 'Nipple', 'Zombie Nipple', 'Satoshi Hair'];
636     string[10] private thirdLayers = [
637         '<path fill="#FFF" d="m20,13h2v1h-1v1h1v1h-2v-1h-1v-1h1z"/><path fill="#E7C2B3" d="m13,12h6v4h-6v-1h-1v-2h1zm1,1h-1v2h2v-2z"/><path fill="#FFEDEB" d="m13,13h2v2h-2z"/>',
638         '<path fill="#E7C2B3" d="m13,12h1v1h-1v2h2v-1h1v-1h1v-1h2v4h-6v-1h-1v-2h1z"/><path fill="#FFEDEB" d="m13,13h1v1h1v1h-2z"/><path fill="#952A00" d="m16,12h1v1h-1v1h-2v-1h2z"/><path fill="#FFF" d="m20,13h2v1h-1v1h1v1h-2v-1h-1v-1h1z"/>',
639         '<path fill="#91A58E" d="m13,13h2v2h-2z"/><path fill="#FFF" d="m20,13h2v1h-1v1h1v1h-2v-1h-1v-1h1z"/><path fill="#416E4A" d="m13,12h6v4h-6v-1h-1v-2h1zm1,1h-1v2h2v-2z"/>',
640         '<path fill="#91A58E" d="m13,13h1v1h1v1h-2z"/><path fill="#416E4A" d="m13,12h1v1h-1v2h2v-1h1v-1h1v-1h2v4h-6v-1h-1v-2h1z"/><path fill="#FFF" d="m20,13h2v1h-1v1h1v1h-2v-1h-1v-1h1z"/><path fill="#952A00" d="m16,12h1v1h-1v1h-2v-1h2z"/>',
641         '<path fill="#E8EBE5" d="m14,12h4v4h-4zm2,1h-1v2h2v-2z"/><path fill="#000" d="m16,13h1v2h-2v-1h1z"/><path fill="#CDCCC7" d="m18,12h1v4h-1v1h-4v-1h4z"/><path fill="#FFF" d="m14,11h4v1h-4v4h-1v-4h1zm1,2h1v1h-1z"/>',
642         '<path fill="#FFF" d="m12,15h1v1h1v1h-1v-1h-1zm8,0h1v1h-1v1h-1v-1h1zm-5,1h1v1h-1zm2,0h1v1h-1z"/><path fill="#D5948B" d="m12,13h2v1h5v-1h2v1h-1v1h-7v-1h-1z"/><path fill="#CD6F6D" d="m12,14h1v1h7v-1h1v1h-1v1h-7v-1h-1z"/>',
643         '<path fill="#FFF" d="m12,15h1v1h-1zm8,0h1v1h-1v1h-1v-1h1zm-5,1h1v1h-1zm2,0h1v1h-1z"/><path fill="#CD6F6D" d="m12,14h1v1h7v-1h1v1h-1v1h-7v-1h-1z"/><path fill="#D5948B" d="m12,13h2v1h5v-1h2v1h-1v1h-7v-1h-1z"/><path fill="#e6d309" d="m13,16h1v1h-1z"/>',
644         '<path fill="#FCC4A6" d="m15,12h3v1h1v3h-1v1h-3v-1h-1v-3h1zm1,1h-1v3h3v-3z"/><path fill="#B14547" d="m16,14h1v1h-1z"/><path fill="#CC7E6A" d="m17,13h1v3h-3v-1h2z"/><path fill="#E7927C" d="m15,13h2v1h-1v1h-1z"/>',
645         '<path fill="#837853" d="m17,13h1v3h-3v-1h2z"/><path fill="#416E4A" d="m15,12h3v1h1v3h-1v1h-3v-1h-1v-3h1zm1,1h-1v3h3v-3z"/><path fill="#94454E" d="m16,14h1v1h-1z"/><path fill="#AE9569" d="m15,13h2v1h-1v1h-1z"/>',
646         '<path fill="#423F3D" d="m16,16h1v1h-1v1h1v1h-1v-1h-1v-1h1z"/><path fill="#272A2D" d="m17,14h1v2h-1z"/><path fill="#000" d="m15,11h1v1h1v2h-1v-2h-1z"/>'];
647     string[12] private fourthNames = ['Blue','Evaporated blue','Green','Evaporated green','Yellow','Evaporated yellow','Purple','Evaporated purple','Radioactive','Evaporated Radioactive','Regular','Evaporated regular'];
648     string[12] private fourthLayers = [
649         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#19546D" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#5FA7BE" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#195467" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#117E9C" d="m12,5h8v1h1v1h1v1h1v15h-14v-15h1v-1h1v-1h1zm0,2h-1v1h1zm-1,2h-1v3h1zm10,2h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
650         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#19546D" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#5FA7BE" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#195467" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#117E9C" d="m9,10h1v2h1v-2h12v13h-14zm12,1h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
651         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#145237" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#6dbf9b" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#275c49" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#22855a" d="m12,5h8v1h1v1h1v1h1v15h-14v-15h1v-1h1v-1h1zm0,2h-1v1h1zm-1,2h-1v3h1zm10,2h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
652         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#145237" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#6dbf9b" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#275c49" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#22855a" d="m9,10h1v2h1v-2h12v13h-14zm12,1h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
653         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#9c9114" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#ede69a" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#aba13a" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#d6c61e" d="m12,5h8v1h1v1h1v1h1v15h-14v-15h1v-1h1v-1h1zm0,2h-1v1h1zm-1,2h-1v3h1zm10,2h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
654         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#9c9114" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#ede69a" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#aba13a" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#d6c61e" d="m9,10h1v2h1v-2h12v13h-14zm12,1h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
655         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#611d46" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#f0c2de" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#613b52" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#db7db6" d="m12,5h8v1h1v1h1v1h1v15h-14v-15h1v-1h1v-1h1zm0,2h-1v1h1zm-1,2h-1v3h1zm10,2h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
656         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#611d46" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#f0c2de" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#613b52" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#db7db6" d="m9,10h1v2h1v-2h12v13h-14zm12,1h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
657         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#2a8a0c" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#87fa64" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#5aa343" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#3cff00" d="m12,5h8v1h1v1h1v1h1v15h-14v-15h1v-1h1v-1h1zm0,2h-1v1h1zm-1,2h-1v3h1zm10,2h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
658         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#2a8a0c" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#87fa64" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#5aa343" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#3cff00" d="m9,10h1v2h1v-2h12v13h-14zm12,1h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
659         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#629ba1" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#c4eef2" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#646d6e" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#a1e0e6" d="m12,5h8v1h1v1h1v1h1v15h-14v-15h1v-1h1v-1h1zm0,2h-1v1h1zm-1,2h-1v3h1zm10,2h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />',
660         '<path fill="#FFF" d="m11,7h1v1h-1zm-1,2h1v3h-1zm0,4h1v6h-1z"/><path fill="#629ba1" d="m21,17h1v1h-1zm-9,1h1v1h-1zm8,2h1v1h-1z" fill-opacity="0.5" /><path fill="#c4eef2" d="m20,11h1v1h-1zm-2,7h1v1h-1zm-5,2h1v1h-1z" fill-opacity="0.5" /><path fill="#646d6e" d="m12,4h8v1h1v1h1v1h1v1h1v15h-1v-15h-1v-1h-1v-1h-1v-1h-8v1h-1v1h-1v1h-1v15h-1v-15h1v-1h1v-1h1v-1h1z"/><path fill="#a1e0e6" d="m9,10h1v2h1v-2h12v13h-14zm12,1h-1v1h1zm-10,2h-1v6h1zm11,4h-1v1h1zm-9,1h-1v1h1zm6,0h-1v1h1zm-5,2h-1v1h1zm7,0h-1v1h1z" fill-opacity="0.3" />']; 
661     string[10] private fifthNames = ['ESP','CRJ','GLL6','PQL','EYJ','TER','NF','JOR','AC','KAI'];
662     string[10] private fifthLayers = [
663         '<path fill="#e3aa1b" d="m7,24h18v1h1v1h-6v-1h-9v1h-5v-1h1zm-1,3h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1z"/><path fill="#565C53" d="m11,25h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1z"/><path fill="#949393" d="m12,25h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1z"/><path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/><path fill="#997314" d="m6,26h20v2h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1z"/>',
664         '<path fill="#315779" d="m7,24h2v1h-2zm3,0h2v1h-2zm3,0h2v1h-2zm3,0h2v1h-2zm3,0h2v1h-2zm3,0h2v1h-2zm-16,2h20v2h-16v-1h-2v1h-2z"/><path fill="#c22715" d="m8,27h1v1h-1z"/><path fill="#439C29" d="m9,27h1v1h-1z"/><path fill="#082B3E" d="m9,24h1v1h2v-1h1v1h2v-1h1v1h2v-1h1v1h2v-1h1v1h2v-1h1v1h1v1h-20v-1h3z"/><path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/>',
665         '<path fill="#6e150b" d="m6,25h20v3h-20v-1h1v-1h-1zm3,1h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1z"/><path fill="#952A00" d="m7,24h4v1h-4zm13,0h5v1h-5zm-14,2h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1z"/><path fill="#3F3E40" d="m12,24h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1z"/><path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/><path fill="#949393" d="m11,24h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1z"/> ',
666         '<path fill="#8a7c11" d="m8,24h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm-17,2h3v2h-1v-1h-1v1h-1zm6,0h6v2h-1v-1h-4v1h-1zm9,0h3v2h-1v-1h-1v1h-1z"/><path fill="#d9c31c" d="m7,24h1v1h1v-1h1v1h1v-1h1v1h1v-1h1v1h1v-1h1v1h1v-1h1v1h1v-1h1v1h1v-1h1v1h1v-1h1v1h2v3h-1v-2h-3v2h-3v-2h-6v2h-3v-2h-3v2h-1v-3h1zm1,3h1v1h-1zm6,0h4v1h-4zm9,0h1v1h-1z"/><path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/>',
667         '<path fill="#929491" d="m7,24h18v1h1v1h-2v-1h-1v1h-2v-1h-1v1h-2v-1h-1v1h-2v-1h-1v1h-2v-1h-1v1h-2v-1h-1v1h-2v-1h1zm-1,3h20v1h-20z"/><path fill="#4A4E4D" d="m8,25h1v1h2v-1h1v1h2v-1h1v1h2v-1h1v1h2v-1h1v1h2v-1h1v1h2v1h-20v-1h2z"/><path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/>',
668         '<path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/><path fill="#5C6F41" d="m7,24h18v1h1v3h-20v-3h1zm1,1h-1v2h1zm2,0h-1v2h1zm2,0h-1v2h1zm2,0h-1v2h1zm2,0h-1v2h2v-2zm3,0h-1v2h1zm2,0h-1v2h1zm2,0h-1v2h1zm2,0h-1v2h1z"/><path fill="#3B4A2C" d="m7,25h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h2v2h-2zm3,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1z"/>',
669         '<path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/><path fill="#775e8a" d="m7,25h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h2v1h-2zm3,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm-18,2h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h8v1h-8zm9,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1z"/><path fill="#4b3859" d="m7,24h18v1h1v2h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-8v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v-2h1zm1,1h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h2v-1zm3,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1zm2,0h-1v1h1z"/>',
670         '<path fill="#9c6f00" d="m8,24h1v2h1v-2h1v2h1v-2h1v2h1v-2h1v2h1v-2h1v2h1v-2h1v2h1v-2h1v2h1v-2h1v2h1v-2h1v2h1v1h-20v-2h1v1h1z"/><path fill="#e6ba4e" d="m11,25h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm-12,2h1v1h-1zm17,0h1v1h-1z"/><path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/><path fill="#cf9400" d="m7,24h1v2h-1zm2,0h1v2h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,1h1v1h-1zm-19,2h1v1h-1zm2,0h16v1h-16zm17,0h1v1h-1z"/>',
671         '<path fill="#2B5D6D" d="m6,26h1v1h-1zm2,0h3v1h-3zm4,0h3v1h-3zm4,0h3v1h-3zm4,0h3v1h-3zm4,0h2v1h-2z"/><path fill="#4a0700" d="m6,25h20v1h-2v1h2v1h-20v-1h1v-1h-1zm3,1h-1v1h3v-1zm4,0h-1v1h3v-1zm4,0h-1v1h3v-1zm4,0h-1v1h3v-1z"/><path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/><path fill="#952A00" d="m7,24h18v1h-18z"/>',
672         '<path fill="#EDEADC" d="m6,25h20v1h-1v2h-1v-2h-1v2h-1v-2h-1v2h-1v-2h-1v2h-1v-2h-1v2h-1v-2h-1v2h-1v-2h-1v2h-1v-2h-1v2h-1v-2h-1v2h-1v-2h-1v2h-1z"/><path fill="#000" d="m7,23h18v1h1v1h1v4h-22v-4h1v-1h1zm1,1h-1v1h-1v3h20v-3h-1v-1z"/><path fill="#C5C7AF" d="m7,24h18v1h-18zm0,2h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1zm2,0h1v2h-1z"/>']; 
673     string[13] private sixthNames = ['Plug','LAN','Hand crank','One Button','Ring','Caution','Wind up','Buttons','Lever','Load indicator','Verified','Handle','Winder'];
674     string[13] private sixthLayers = [
675         '<path fill="#631811" d="m24,12h1v1h1v3h-1v1h-1z"/><path fill="#9c2217" d="m27,25h1v3h-1z"/><path fill="#000" d="m26,14h2v1h1v2h-1v1h-1v1h1v1h1v4h1v2h-1v1h-1v-1h1v-2h-1v-4h-1v-1h-1v-1h1v-1h1v-2h-2z"/> ',
676         '<path fill="#801e14" d="m5,9h1v1h-1z"/><path fill="#647377" d="m5,10h1v8h-1z"/><path fill="#4A4E4D" d="m7,16h1v4h-1v-1h-1v-2h1z"/> ',
677         '<path fill="#6E491E" d="m2,17h2v1h-2z"/><path fill="#000000" d="m7,11h1v5h-1v-1h-1v-3h1z"/><path fill="#647377" d="m5,13h1v5h-2v-1h1z"/>',
678         '<path fill="#e3a617" d="m25,12h1v2h-1z"/><path fill="#052B36" d="m24,11h1v4h-1z"/>',
679         '<path fill="#3A4446" d="m6,20h2v1h-2zm4,0h1v1h-1zm3,0h1v1h-1zm3,0h1v1h-1zm3,0h1v1h-1zm3,0h1v1h-1zm2,0h2v1h-2z"/><path fill="#5D7272" d="m7,19h18v1h-1v1h1v1h-18v-1h1v-1h-1zm4,1h-1v1h1zm3,0h-1v1h1zm3,0h-1v1h1zm3,0h-1v1h1zm3,0h-1v1h1z"/>',
680         '<path fill="#e3c817" d="m7,16h5v4h-1v1h-1v1h-3zm3,1h-1v2h1zm0,3h-1v1h1z"/><path fill="#000" d="m9,17h1v2h-1zm0,3h1v1h-1z"/><path fill="#EFA603" d="m11,20h1v1h-1v1h-1v-1h1z"/>',
681         '<path fill="#a13115" d="m26,13h3v3h-1v1h1v3h-3v-3h-1v-1h1zm2,1h-1v1h1zm0,4h-1v1h1z"/><path fill="#263238" d="m24,14h1v5h-1z"/>',
682         '<path fill="#ba200b" d="m6,14h1v1h-1z"/><path fill="#1f690f" d="m6,16h1v1h-1z"/><path fill="#263238" d="m7,11h1v7h-1z"/><path fill="#d9cf16" d="m6,12h1v1h-1z"/>',
683         '<path fill="#112326" d="m24,14h1v7h-1z"/><path fill="#8a2c19" d="m27,14h2v2h-2z"/><path fill="#3A4D51" d="m26,16h1v1h-1v2h-1v-2h1z"/>',
684         '<path fill="#26323A" d="m11,19h10v3h-10zm2,1h-1v1h8v-1z"/><path fill="#184831" d="m17,20h3v1h-3z"/><path fill="#56a81b" d="m12,20h5v1h-5z"/>',
685         '<path fill="#117E9C" d="m19,17h6v5h-6zm5,1h-1v1h1zm-3,1h-1v1h1zm2,0h-1v1h1zm-1,1h-1v1h1z"/><path fill="#FFF" d="m23,18h1v1h-1v1h-1v1h-1v-1h-1v-1h1v1h1v-1h1z"/>',
686         '<path fill="#3A4446" d="m25,10h2v3h-1v-2h-1zm1,8h1v3h-2v-1h1z"/><path fill="#102f3d" d="m24,9h1v3h-1zm0,10h1v3h-1z"/><path fill="#302919" d="m25,13h3v5h-3z"/>',
687         '<path fill="#3A4446" d="m5,10h2v1h-2zm0,2h2v1h-2zm0,2h2v1h-2zm0,2h2v1h-2zm0,2h2v1h-2z"/><path fill="#5A6C6C" d="m5,11h2v1h-2zm0,2h2v1h-2zm0,2h2v1h-2zm0,2h2v1h-2z"/><path fill="#700909" d="m7,13h1v3h-1z"/>'];       
688     string[11] private seventhNames = ['Button','Charge','Vernon','Broken','Weisz','Bamberg','Carroll','Kaufman','Clifton','Ascanio','None'];
689     string[11] private seventhLayers = [
690         '<path fill="#851515" d="m15,2h2v1h-2z"/><path fill="#51514D" d="m12,4h8v1h-8z"/><path fill="#34352B" d="m14,3h4v1h-4z"/>',
691         '<path fill="#7fbf24" d="m11,4h4v1h-4z"/><path fill="#2A3B42" d="m10,3h12v1h1v1h-1v1h-12v-1h-1v-1h1zm2,1h-1v1h10v-1z"/><path fill="#E23E36" d="m20,4h1v1h-1z"/><path fill="#FFB31A" d="m18,4h2v1h-2z"/><path fill="#d6d12d" d="m15,4h3v1h-3z"/>',
692         '<path fill="#455A60" d="m9,4h1v1h-1zm13,0h1v1h-1z"/><path fill="#364F38" d="m10,3h12v1h-12zm0,2h12v1h-12z"/><path fill="#e8a41c" d="m8,4h1v1h-1zm15,0h1v1h-1z"/><path fill="#1C3331" d="m10,4h12v1h-12z"/>',
693         '<path fill="#FFF" d="m19,5h1v1h-1v2h1v1h1v1h-1v-1h-1v-1h-1v1h-1v1h-1v1h-1v-1h1v-1h1v-1h1v-2h1z"/>',
694         '<path fill="#916c20" d="m12,3h8v1h-8z"/><path fill="#3F3E40" d="m11,5h10v1h-10z"/><path fill="#45595D" d="m10,4h12v1h-12zm0,2h12v1h-12z"/>',
695         '<path fill="#E23E36" d="m11,3h1v1h-1z"/><path fill="#45595D" d="m10,3h1v1h-1zm3,0h9v1h-9zm-5,2h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1zm2,0h1v1h-1z"/><path fill="#439C29" d="m12,3h1v1h-1z"/><path fill="#2B3B41" d="m9,4h14v1h1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1v-1h-1v1h-1z"/>',
696         '<path fill="#2A3B42" d="m15,2h2v1h2v1h1v-1h3v3h-3v-1h-3v1h-2v-1h-3v1h-3v-3h3v1h1v-1h2zm-4,2h-1v1h1zm11,0h-1v1h1z"/>',
697         '<path fill="#313335" d="m12,4h8v1h-8z"/><path fill="#99242D" d="m11,3h10v1h-10z"/><path fill="#000" d="m11,5h10v1h-10z"/>',
698         '<path fill="#FFF" d="m15,3h2v1h-2z"/><path fill="#99242D" d="m12,2h8v1h-8z"/><path fill="#252B20" d="m10,6h12v1h-12z"/><path fill="#4B4C3C" d="m9,4h14v2h-14z"/>',
699         '<path fill="#117E9C" d="m9,6h14v1h-14z"/><path fill="#FFCC01" d="m19,4h1v1h-1z"/><path fill="#2D545A" d="m18,3h3v3h-3zm2,1h-1v1h1z"/><path fill="#082B3E" d="m10,3h8v3h-9v1h-1v-2h1v-1h1zm11,0h1v1h1v1h1v2h-1v-1h-2z"/>',
700         ''];
701 
702   struct BlazzObject {
703         uint256 layerThree;
704         uint256 layerFour;
705         uint256 layerFive;
706         uint256 layerSix;
707         uint256 layerSeven;
708     }
709 
710 function randomBlazzLab(uint256 tokenId) internal pure returns (BlazzObject memory) {
711         
712         BlazzObject memory blazzLab;
713 
714         blazzLab.layerThree = getLayerThree(tokenId);
715         blazzLab.layerFour = getLayerFour(tokenId);
716         blazzLab.layerFive = getLayerFive(tokenId);
717         blazzLab.layerSix = getLayerSix(tokenId);
718         blazzLab.layerSeven = getLayerSeven(tokenId);
719 
720         return blazzLab;
721     }
722 
723 function getTraits(BlazzObject memory blazzLab) internal view returns (string memory) {
724         
725         string[17] memory parts;
726         
727         parts[0] = ', "attributes": [{"trait_type": "Souvenir","value": "';
728         parts[1] = thirdNames[blazzLab.layerThree]; 
729         parts[2] = '"}, {"trait_type": "Jar","value": "';
730         parts[3] = fourthNames[blazzLab.layerFour];
731         parts[4] = '"}, {"trait_type": "Base","value": "';
732         parts[5] = fifthNames[blazzLab.layerFive];
733         parts[6] = '"}, {"trait_type": "Accessory","value": "';
734         parts[7] = sixthNames[blazzLab.layerSix];
735         parts[8] = '"}, {"trait_type": "Top","value": "';
736         parts[9] = seventhNames[blazzLab.layerSeven];
737         parts[10] = '"}], ';
738         
739         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2]));
740                       output = string(abi.encodePacked(output, parts[3], parts[4], parts[5], parts[6], parts[7], parts[8], parts[9], parts[10]));
741         return output;
742     }    
743 
744 function random(string memory input) internal pure returns (uint256) {
745         return uint256(keccak256(abi.encodePacked(input)));
746     }
747 
748 function getLayerThree(uint256 tokenId) internal pure returns (uint256) {
749         uint256 rand = random(string(abi.encodePacked("LAYER THREE", toString(tokenId))));
750 
751         uint256 rn3 = rand % 275;
752         uint256 l3 = 0;
753 
754         if (rn3 >= 40 && rn3 < 75) { l3 = 1; }
755         if (rn3 >= 75 && rn3 < 110) { l3 = 2; }
756         if (rn3 >= 110 && rn3 < 140) { l3 = 3; }
757         if (rn3 >= 140 && rn3 < 180) { l3 = 4; }
758         if (rn3 >= 180 && rn3 < 220) { l3 = 5; }
759         if (rn3 >= 220 && rn3 < 245) { l3 = 6; }
760         if (rn3 >= 245 && rn3 < 260) { l3 = 7; }
761         if (rn3 >= 260 && rn3 < 270) { l3 = 8; }
762         if (rn3 >= 270) { l3 = 9; }
763         
764         return l3;
765     }
766 
767     function getLayerFour(uint256 tokenId) internal pure returns (uint256) {
768         uint256 rand = random(string(abi.encodePacked("LAYER FOUR", toString(tokenId))));
769 
770         uint256 rn4 = rand % 310;
771         uint256 l4 = 0;
772 
773         if (rn4 >= 35 && rn4 < 65) { l4 = 1; }
774         if (rn4 >= 65 && rn4 < 100) { l4 = 2; }
775         if (rn4 >= 100 && rn4 < 130) { l4 = 3; }
776         if (rn4 >= 130 && rn4 < 155) { l4 = 4; }
777         if (rn4 >= 155 && rn4 < 175) { l4 = 5; }
778         if (rn4 >= 175 && rn4 < 200) { l4 = 6; }
779         if (rn4 >= 200 && rn4 < 220) { l4 = 7; }
780         if (rn4 >= 220 && rn4 < 235) { l4 = 8; }
781         if (rn4 >= 235 && rn4 < 245) { l4 = 9; }
782         if (rn4 >= 245 && rn4 < 280) { l4 = 10; }
783         if (rn4 >= 280) { l4 = 11; }
784         
785         return l4;
786     }
787 
788    function getLayerFive(uint256 tokenId) internal pure returns (uint256) {
789         uint256 rand = random(string(abi.encodePacked("LAYER FIVE", toString(tokenId))));
790 
791         uint256 rn5 = rand % 165;
792         uint256 l5 = 0;
793 
794         if (rn5 >= 15 && rn5 < 27) { l5 = 1; }
795         if (rn5 >= 27 && rn5 < 40) { l5 = 2; }
796         if (rn5 >= 40 && rn5 < 60) { l5 = 3; }
797         if (rn5 >= 60 && rn5 < 80) { l5 = 4; }
798         if (rn5 >= 80 && rn5 < 100) { l5 = 5; }
799         if (rn5 >= 100 && rn5 < 120) { l5 = 6; }
800         if (rn5 >= 120 && rn5 < 140) { l5 = 7; }
801         if (rn5 >= 140 && rn5 < 155) { l5 = 8; }
802         if (rn5 >= 155) { l5 = 9; }
803         
804         
805         return l5;
806     }
807 
808    function getLayerSix(uint256 tokenId) internal pure returns (uint256) {
809         uint256 rand = random(string(abi.encodePacked("LAYER SIX", toString(tokenId))));
810 
811         uint256 rn6 = rand % 300;
812         uint256 l6 = 0;
813 
814         if (rn6 >= 25 && rn6 < 55) { l6 = 1; }
815         if (rn6 >= 55 && rn6 < 80) { l6 = 2; }
816         if (rn6 >= 80 && rn6 < 110) { l6 = 3; }
817         if (rn6 >= 110 && rn6 < 130) { l6 = 4; }
818         if (rn6 >= 130 && rn6 < 145) { l6 = 5; }
819         if (rn6 >= 145 && rn6 < 160) { l6 = 6; }
820         if (rn6 >= 160 && rn6 < 190) { l6 = 7; }
821         if (rn6 >= 190 && rn6 < 215) { l6 = 8; }
822         if (rn6 >= 215 && rn6 < 245) { l6 = 9; }
823         if (rn6 >= 245 && rn6 < 255) { l6 = 10; }
824         if (rn6 >= 255 && rn6 < 280) { l6 = 11; }
825         if (rn6 >= 280) { l6 = 12; }
826         
827         return l6;
828     }
829 
830  function getLayerSeven(uint256 tokenId) internal pure returns (uint256) {
831         uint256 rand = random(string(abi.encodePacked("LAYER SEVEN", toString(tokenId))));
832 
833         uint256 rn7 = rand % 220;
834         uint256 l7 = 0;
835 
836         if (rn7 >= 30 && rn7 < 60) { l7 = 1; }
837         if (rn7 >= 60 && rn7 < 90) { l7 = 2; }
838         if (rn7 >= 90 && rn7 < 110) { l7 = 3; }
839         if (rn7 >= 110 && rn7 < 130) { l7 = 4; }
840         if (rn7 >= 130 && rn7 < 150) { l7 = 5; }
841         if (rn7 >= 150 && rn7 < 165) { l7 = 6; }
842          if (rn7 >= 165 && rn7 < 180) { l7 = 7; }
843         if (rn7 >= 180 && rn7 < 195) { l7 = 8; }
844         if (rn7 >= 195 && rn7 < 205) { l7 = 9; }
845         if (rn7 >= 205) { l7 = 10; }
846         
847         return l7;
848     }
849 
850    function getSVG(BlazzObject memory blazzLab) internal view returns (string memory) {
851         string[7] memory parts;
852 
853         parts[0] = '<svg id="x" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 32 32"><path fill="#94b5ae" d="m0,0h32v32h-32z"/>';
854         parts[1] = thirdLayers[blazzLab.layerThree];
855         parts[2] = fourthLayers[blazzLab.layerFour];
856         parts[3] = fifthLayers[blazzLab.layerFive];
857         parts[4] = sixthLayers[blazzLab.layerSix];
858         parts[5] = seventhLayers[blazzLab.layerSeven];
859         parts[6] = '<style>#x{shape-rendering: crispedges;}</style></svg>';
860 
861         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
862 
863         return output;
864     }
865 
866    function tokenURI(uint256 tokenId) override public view returns (string memory) {
867         BlazzObject memory blazzLab = randomBlazzLab(tokenId);
868         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Blazz Lab Exp.No #', toString(tokenId), '", "description": "Blazz Lab is a laboratory full of experiments done by Dr Blazz, an illustrator alter ego. These experiments are completely on-chain and were randomly generated at mint."', getTraits(blazzLab), '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(getSVG(blazzLab))), '"}'))));
869         json = string(abi.encodePacked('data:application/json;base64,', json));
870         return json;
871     }
872 
873     function mint(address destination, uint256 amountOfTokens) private {
874         require(totalSupply() < maxSupply, "All tokens have been minted");
875         require(totalSupply() + amountOfTokens <= maxSupply, "Minting would exceed max supply");
876         require(amountOfTokens <= maxMint, "Cannot purchase this many tokens in a transaction");
877         require(amountOfTokens > 0, "Must mint at least one token");
878         require(price * amountOfTokens == msg.value, "ETH amount is incorrect");
879 
880         for (uint256 i = 0; i < amountOfTokens; i++) {
881             uint256 tokenId = numTokensMinted + 1;
882             _safeMint(destination, tokenId);
883             numTokensMinted += 1;
884         }
885     }
886 
887     function mintForSelf(uint256 amountOfTokens) public payable virtual {
888         mint(_msgSender(),amountOfTokens);
889     }
890 
891     function mintForFriend(address walletAddress, uint256 amountOfTokens) public payable virtual {
892         mint(walletAddress,amountOfTokens);
893     }
894 
895     function setPrice(uint256 newPrice) public onlyOwner {
896         price = newPrice;
897     }
898 
899     function setMaxMint(uint256 newMaxMint) public onlyOwner {
900         maxMint = newMaxMint;
901     }
902 
903     function withdrawAll() public payable onlyOwner {
904         require(payable(_msgSender()).send(address(this).balance));
905     }
906 
907     function toString(uint256 value) internal pure returns (string memory) {
908 
909         if (value == 0) {
910             return "0";
911         }
912         uint256 temp = value;
913         uint256 digits;
914         while (temp != 0) {
915             digits++;
916             temp /= 10;
917         }
918         bytes memory buffer = new bytes(digits);
919         while (value != 0) {
920             digits -= 1;
921             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
922             value /= 10;
923         }
924         return string(buffer);
925     }
926     
927     constructor() ERC721("Blazz Lab", "BLAZZ") Ownable() {}
928 }
929 
930 library Base64 {
931     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
932 
933     function encode(bytes memory data) internal pure returns (string memory) {
934         uint256 len = data.length;
935         if (len == 0) return "";
936 
937         uint256 encodedLen = 4 * ((len + 2) / 3);
938 
939         bytes memory result = new bytes(encodedLen + 32);
940 
941         bytes memory table = TABLE;
942 
943         assembly {
944             let tablePtr := add(table, 1)
945             let resultPtr := add(result, 32)
946 
947             for {
948                 let i := 0
949             } lt(i, len) {
950 
951             } {
952                 i := add(i, 3)
953                 let input := and(mload(add(data, i)), 0xffffff)
954 
955                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
956                 out := shl(8, out)
957                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
958                 out := shl(8, out)
959                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
960                 out := shl(8, out)
961                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
962                 out := shl(224, out)
963 
964                 mstore(resultPtr, out)
965 
966                 resultPtr := add(resultPtr, 4)
967             }
968 
969             switch mod(len, 3)
970             case 1 {
971                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
972             }
973             case 2 {
974                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
975             }
976 
977             mstore(result, encodedLen)
978         }
979 
980         return string(result);
981     }
982 }