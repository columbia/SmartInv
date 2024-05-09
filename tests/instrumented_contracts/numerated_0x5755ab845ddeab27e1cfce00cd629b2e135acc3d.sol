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
613 
614 //██///////█████//██████//██////██//█████//////██///////█████//██████//███████//
615 //██//////██///██/██///██/██////██/██///██/////██//////██///██/██///██/██///////
616 //██//////███████/██████//██////██/███████/////██//////███████/██///██/███████//
617 //██//////██///██/██///██//██//██//██///██/////██//////██///██/██///██//////██//
618 //███████/██///██/██///██///████///██///██/////███████/██///██/██████//███████//
619 
620 
621 contract LarvaLads is ERC721Enumerable, ReentrancyGuard, Ownable {
622 
623     uint256 public maxSupply = 5000;
624     uint256 public price = 0.05 ether;
625     uint256 public maxMint = 10;
626     uint256 public numTokensMinted;
627 
628     string[8] private baseColors = ['#AE8B61','#DBB181','#E8AA96','#FFC2C2','#EECFA0','#C9CDAF','#D5C6E1','#EAD9D9'];
629     string[7] private thirdNames = ['Smile', 'Frown', 'Handlebars', 'Zombie', 'Alien', 'Ape', 'Normal'];
630     string[7] private thirdLayers = [
631         '<path fill="#000" d="M16 17h1v1h-1z"/>',
632         '<path fill="#000" d="M16 19h1v1h-1z"/>',
633         '<path stroke="#A66E2C" d="M16.5 20v-2m3.5-.5h-3m3.5.5v2"/><path stroke="#C28946" d="M16 17.5h1m3 0h1"/>',
634         '<path fill="#7DA269" d="M22 10v12h-2v2h-1v1H5v-1h1v-1h1v-1h1v-1h1v-1h2v-1h2v-9h1V9h2V8h-1V7h3v1h1v1h2v1h1z"/><path fill="#000" fill-opacity=".4" d="M17 12h-2v1h2v-1zM20 12v1h2v-1h-2zM22 21h-9v1h1v1h6v-1h2v-1zM12 19h-1v6h2v-1h-1v-5zM10 25v-5H9v5h1zM8 25v-3H7v3h1zM6 24H5v1h1v-1zM16 14h-1v1h1v-1zM21 14h-1v1h1v-1zM18 19h-1v1h1v-1z"/><path fill="red" d="M15 13h1v1h-1v-1zM20 13h1v1h-1v-1z"/><path fill="#000" d="M17 13h-1v1h1v-1zM22 13h-1v1h1v-1zM20 16v-1h-2v1h2zM17 18v1h3v-1h-3z"/>',
635         '<path fill="#C8FBFB" d="M22 10v12h-2v2h-1v1H5v-1h1v-1h1v-1h1v-1h1v-1h2v-1h2v-9h1V9h2V8h-1V7h3v1h1v1h2v1h1z"/><path stroke="#75BDBD" d="M15.5 12v1m5-1v1"/><path fill="#000" d="M21 19v-1h-5v1h5zM15 13h1v-1h1v1h-1v1h-1v-1zM21 12h1v1h-1v1h-1v-1h1v-1z"/><path fill="#9BE0E0" d="M22 21h-9v1h1v1h6v-1h2v-1zM12 19h-1v6h2v-1h-1v-5zM10 25v-5H9v5h1zM8 25v-3H7v3h1zM6 24H5v1h1v-1zM17 13h-1v1h1v-1zM22 13h-1v1h1v-1zM19 14h-1v3h1v-3z"/>',
636         '<path fill="#61503D" d="M22 10v12h-2v2h-1v1H5v-1h1v-1h1v-1h1v-1h1v-1h2v-1h2v-9h1V9h2V8h-1V7h3v1h1v1h2v1h1z"/><path fill="#958A7D" stroke="#958A7D" d="M16.5 19.5v-1h-1v-1h1v-2h-1v-1h-1v-3h2v-1h3v1h2v4h-1v2h1v1h-1v1h-4z"/><path fill="#000" fill-opacity=".4" d="M17 12h-2v1h2v-1zM20 12v1h2v-1h-2zM22 21h-9v1h1v1h6v-1h2v-1zM12 19h-1v6h2v-1h-1v-5zM10 25v-5H9v5h1zM8 25v-3H7v3h1zM6 24H5v1h1v-1z"/><path fill="#000" d="M16 13h-1v1h1v-1zM21 13h-1v1h1v-1zM18 16v-1h-1v1h1zM17 18v1h3v-1h-3zM19.724 16v-1h-1v1h1z"/><path fill="#AAA197" d="M17 14h-1v-1h1v1zM22 14h-1v-1h1v1z"/>',
637         ''];
638     string[8] private fourthNames = ['3D Glasses','VR','Small Shades','Eye Patch','Classic Shades','Regular Shades','Horned Rim Glasses','None'];
639     string[8] private fourthLayers = [
640         '<path fill="#F0F0F0" d="M12 11h11v4h-9v-3h-2v-1z"/><path fill="#FD3232" d="M19 12h3v2h-3z"/><path fill="#328DFD" d="M15 12h3v2h-3z"/>',
641         '<path fill="#B4B4B4" d="M14 11h9v4h-9z"/><path stroke="#000" d="M14 15.5h8m-8-5h8M13.5 14v1m10-4v4m-10-4v1m2 .5v1h6v-1h-6z"/><path stroke="#8D8D8D" d="M13.5 12v2m1 0v1m0-4v1m8-1v1m0 2v1"/>',
642         '<path fill="#000" d="M13 13v-1h9v3h-2v-2h-3v2h-2v-2h-2z"/>',
643         '<path fill="#000" d="M13 11h9v1h-4v2h-1v1h-2v-1h-1v-2h-1v-1z"/>',
644         '<path stroke="#000" d="M13 11.5h9m-7 3h2m.5-.5v-2m2 0v2m.5.5h2m-7.5-.5v-2"/><path stroke="#5C390F" d="M15 12.5h2m3 0h2"/><path stroke="#C77514" d="M15 13.5h2m3 0h2"/>',
645         '<path fill="#000" d="M13 12h11v2h-1v1h-2v-1h-1v-1h-2v1h-1v1h-2v-1h-1v-1h-1v-1z"/>',
646         '<path fill="#fff" fill-opacity=".5" d="M14 12h3v3h-3zM19 12h3v3h-3z"/><path fill="#000" d="M13 11h11v2h-1v-1h-4v1h-2v-1h-3v1h-1v-2z"/>',
647         ''];
648     string[14] private fifthNames = ['Beanie','Cowboy Hat','Fedora','Police Cap','Do-rag','Knitted Cap','Bandana','Peak Spike','Wild Hair','Messy Hair','Cap Forward','Cap','Top Hat','None'];
649     string[14] private fifthLayers = [
650         '<path fill="#3CC300" d="M14 10h7v1h-7z"/><path fill="#0060C3" d="M16 6v4h-4V8h1V7h1V6h2z"/><path fill="#D60404" d="M19 6v4h4V8h-1V7h-1V6h-2z"/><path fill="#E4EB17" d="M14 9h1V8h1V6h3v2h1v1h1v1h-7V9z"/><path fill="#000" d="M17 5h1v1h-1z"/><path fill="#0060C3" d="M15 4h5v1h-5z"/>',
651         '<path fill="#794B11" d="M8 7h1v1h4V4h1V3h2v1h3V3h2v1h1v4h4V7h1v2h-1v1H9V9H8V7z"/><path fill="#502F05" d="M12 7h11v1H12z"/>',
652         '<path fill="#3D2F1E" d="M9 9h1V8h3V6h1V4h1V3h5v1h1v2h1v2h3v1h1v1H9V9z"/><path fill="#000" d="M12 7h11v1H12z"/>',
653         '<path fill="#26314A" d="M12 5h11v5H12z"/><path stroke="#fff" d="M13 8.5h1m1 0h1m1 0h1m1 0h1m1 0h1"/><path stroke="#FFD800" d="M17 6.5h1"/><path fill="#000" fill-rule="evenodd" d="M23 6V5h-4V4h-3v1h-4v1h-1v2h1v2h3v1h9V9h-1V8h1V6h-1zm0 0h-4V5h-3v1h-4v2h1v1h1V8h1v2h8V9h-1V8h1V6zm-7 3h1V8h-1v1zm2 0h1V8h-1v1zm2 0h1V8h-1v1z" clip-rule="evenodd"/>',
654         '<path fill="#4C4C4C" d="M13 7h9v4h-9z"/><path fill="#000" d="M13 10h-1V8h1V7h1V6h7v1h2v2h-1V8h-1V7h-7v1h-1v2z"/><path stroke="#636363" d="M14 9.5h1m0-1h1"/>',
655         '<path fill="#CA4E11" d="M14 7h-1v3h9V7h-1V6h-7v1z"/><path fill="#933709" d="M12 8h11v2h-1V9h-1v1h-1V9h-1v1h-1V9h-1v1h-1V9h-1v1h-1V9h-1v1h-1V8z"/><path stroke="#000" d="M11.5 10V8m1 0V7m1 0V6m.5-.5h7m.5.5v1m1 0v1m1 0v2"/>',
656         '<path fill="#1A43C8" d="M13 7h9v3H10v3H9v-3H8V9h5V7z"/><path stroke="#1637A4" d="M22 9.5h-1m0 1h-3m0-1h-4m8.5-.5V7m-.5-.5h-8m0 1h-1m0 1h-1m0 1h-1m0 1h-1m0-1H9"/><path stroke="#142C7C" d="M11 11.5h-1m2-1h-1m2-1h-1"/>',
657         '<path fill="#000" d="M14 7V5h1V4h1v1h1V4h1v1h1V4h1v1h1v2h1v2h-3v1h-1v1h-1v-1h-1V9h-3V7h1zM12 9v1h1V9h-1z"/>',
658         '<path stroke="#000" d="M12 4.5h2m4 0h5m-14 1h1m2 0h10m2 0h2m-17 1h16m-16 1h17m-16 1h15m-16 1h9m2 0h5m-17 1h7m2 0h2m2 0h3m-14 1h4m9 0h2m-16 1h5m9 0h2m-16 1h1m1 0h3m9.5-.5v2M10 14.5h4m-4 1h2"/>',
659         '<path fill="#000" d="M14 11h1v1h-1zM15 10h1v1h-1zM18 9h1v3h-1zM12 9h6v1h-6zM13 10h1v1h-1zM11 10h1v1h-1zM11 8h3v1h-3zM12 7h2v1h-2zM13 6h2v1h-2zM14 5h6v1h-6zM21 5h1v2h-1zM21 7h3v1h-3zM21 10h3v1h-3zM20 8h3v2h-3zM15 7h4v2h-4z"/><path fill="#000" d="M17 6h4v2h-4z"/><path fill="#000" d="M14 6h4v3h-4z"/><path stroke="#000" d="M14 5.5h6m1 0h1m-9 1h9m-10 1h12m-13 1h8m1 0h3m-11 1h7m1 0h3m-12 1h1m1 0h1m1 0h1m-2 1h1m3.5-1.5v2m2.5-1.5h3"/>',
660         '<path fill="#515151" d="M13 6h9v4h-9V6z"/><path stroke="#000" d="M12 10.5h12.5V9m-.5-.5h-8m0 1h-1m8-2h-1m0-1h-1m0-1h-7m0 1h-1m-.5.5v3"/><path stroke="#353535" d="M24 9.5h-8m-1-3h-1m0 1h-1"/>',
661         '<path fill="#8119B7" d="M12 7h1V6h1V5h7v1h1v2h3v1h1v1H12V7z"/><path stroke="#B261DC" d="M21 7.5h-1m0-1h-1"/>',
662         '<path fill="#000" d="M13 2h9v1h1v5h1v1h1v1H10V9h1V8h1V3h1V2z"/><path fill="#DC1D1D" d="M12 7h11v1H12z"/>',
663         ''];
664     string[5] private sixthNames = ['Earring','Vape','Cigarette','Pipe','None'];
665     string[5] private sixthLayers = [
666         '<path fill="#FFD926" d="M12 14h1v1h-1z"/>',
667         '<path stroke="#000" d="M20 17.5h7m1 1h-1m0 1h-7"/><path stroke="#595959" d="M20 18.5h6"/><path stroke="#0040FF" d="M26 18.5h1"/>',
668         '<path stroke="#000" d="M20 17.5h7m1 1h-1m0 1h-7"/><path stroke="#D7D1D1" d="M20 18.5h6"/><path stroke="#E7A600" d="M26 18.5h1"/><path fill="#fff" fill-opacity=".4" d="M26 11h1v5h-1z"/>',
669         '<path stroke="#000" d="M20 18.5h1m0 1h1m0 1h1m0 1h1.5v-2h4V22m-1 0v1m-.5.5h-4m0-1h-1m0-1h-1m0-1h-1m0-1h-1"/><path stroke="#855114" d="M20 19.5h1m0 1h1m0 1h1m0 1h3m-1-2h3m-2 1h1"/><path stroke="#683C08" d="M25 21.5h1m0 1h1m0-1h1"/><path stroke="#fff" stroke-opacity=".4" d="M26.5 12v1.5m0 0H25m1.5 0H28M26.5 15v1m0 1v1"/>',
670         ''];
671 
672     struct LarvaObject {
673         uint256 baseColor;
674         uint256 layerThree;
675         uint256 layerFour;
676         uint256 layerFive;
677         uint256 layerSix;
678     }
679 
680     function randomLarvaLad(uint256 tokenId) internal view returns (LarvaObject memory) {
681         
682         LarvaObject memory larvaLad;
683 
684         larvaLad.baseColor = getBaseColor(tokenId);
685         larvaLad.layerThree = getLayerThree(tokenId);
686         larvaLad.layerFour = getLayerFour(tokenId);
687         larvaLad.layerFive = getLayerFive(tokenId);
688         larvaLad.layerSix = getLayerSix(tokenId);
689 
690         return larvaLad;
691     }
692     
693     function getTraits(LarvaObject memory larvaLad) internal view returns (string memory) {
694         
695         string[20] memory parts;
696         
697         parts[0] = ', "attributes": [{"trait_type": "Type","value": "';
698         if (larvaLad.layerThree == 3) {
699             parts[1] = 'Zombie"}, {"trait_type": "Mouth","value": "Zombie"},'; 
700         }
701         if (larvaLad.layerThree == 4) {
702             parts[2] = 'Alien"}, {"trait_type": "Mouth","value": "Alien"},'; 
703         }
704         if (larvaLad.layerThree == 5) {
705             parts[3] = 'Ape"}, {"trait_type": "Mouth","value": "Ape"},'; 
706         }
707         if (larvaLad.layerThree < 3 || larvaLad.layerThree > 5) {
708             parts[4] = 'Normal"}, {"trait_type": "Mouth","value": "';
709             parts[5] = thirdNames[larvaLad.layerThree];
710             parts[6] = '"},';
711         }
712         parts[7] = ' {"trait_type": "Eyewear","value": "';
713         parts[8] = fourthNames[larvaLad.layerFour];
714         parts[9] = '"}, {"trait_type": "Headwear","value": "';
715         parts[10] = fifthNames[larvaLad.layerFive];
716         parts[11] = '"}, {"trait_type": "Accessory","value": "';
717         parts[12] = sixthNames[larvaLad.layerSix];
718         parts[13] = '"}], ';
719         
720         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7]));
721                       output = string(abi.encodePacked(output, parts[8], parts[9], parts[10], parts[11], parts[12], parts[13]));
722         return output;
723     }
724 
725     function random(string memory input) internal pure returns (uint256) {
726         return uint256(keccak256(abi.encodePacked(input)));
727     }
728 
729     function getBaseColor(uint256 tokenId) internal pure returns (uint256) {
730         uint256 rand = random(string(abi.encodePacked("BASE COLOR", toString(tokenId))));
731 
732         uint256 rn1 = rand % 79;
733         uint256 bc = 0;
734 
735         if (rn1 >= 10 && rn1 < 20) { bc = 1; }
736         if (rn1 >= 20 && rn1 < 30) { bc = 2; }
737         if (rn1 >= 30 && rn1 < 40) { bc = 3; }
738         if (rn1 >= 40 && rn1 < 50) { bc = 4; }
739         if (rn1 >= 50 && rn1 < 60) { bc = 5; }
740         if (rn1 >= 60 && rn1 < 70) { bc = 6; }
741         if (rn1 >= 70) { bc = 7; }
742 
743         return bc;
744     }
745 
746     function getLayerThree(uint256 tokenId) internal pure returns (uint256) {
747         uint256 rand = random(string(abi.encodePacked("LAYER THREE", toString(tokenId))));
748 
749         uint256 rn3 = rand % 170;
750         uint256 l3 = 0;
751 
752         if (rn3 >= 46 && rn3 < 64) { l3 = 1; }
753         if (rn3 >= 64 && rn3 < 81) { l3 = 2; }
754         if (rn3 >= 81 && rn3 < 85) { l3 = 3; }
755         if (rn3 == 85) { l3 = 4; }
756         if (rn3 >= 86 && rn3 < 88) { l3 = 5; }
757         if (rn3 >= 88) { l3 = 6; }
758         
759         return l3;
760     }
761 
762     function getLayerFour(uint256 tokenId) internal pure returns (uint256) {
763         uint256 rand = random(string(abi.encodePacked("LAYER FOUR", toString(tokenId))));
764 
765         uint256 rn4 = rand % 500;
766         uint256 l4 = 0;
767 
768         if (rn4 >= 41 && rn4 < 81) { l4 = 1; }
769         if (rn4 >= 81 && rn4 < 121) { l4 = 2; }
770         if (rn4 >= 121 && rn4 < 161) { l4 = 3; }
771         if (rn4 >= 161 && rn4 < 201) { l4 = 4; }
772         if (rn4 >= 201 && rn4 < 261) { l4 = 5; }
773         if (rn4 >= 261 && rn4 < 281) { l4 = 6; }
774         if (rn4 >= 281) { l4 = 7; }
775         
776         return l4;
777     }
778 
779     function getLayerFive(uint256 tokenId) internal pure returns (uint256) {
780         uint256 rand = random(string(abi.encodePacked("LAYER FIVE", toString(tokenId))));
781 
782         uint256 rn5 = rand % 240;
783         uint256 l5 = 0;
784 
785         if (rn5 >= 10 && rn5 < 20) { l5 = 1; }
786         if (rn5 >= 20 && rn5 < 30) { l5 = 2; }
787         if (rn5 >= 30 && rn5 < 40) { l5 = 3; }
788         if (rn5 >= 40 && rn5 < 50) { l5 = 4; }
789         if (rn5 >= 50 && rn5 < 60) { l5 = 5; }
790         if (rn5 >= 60 && rn5 < 70) { l5 = 6; }
791         if (rn5 >= 70 && rn5 < 80) { l5 = 7; }
792         if (rn5 >= 80 && rn5 < 90) { l5 = 8; }
793         if (rn5 >= 90 && rn5 < 100) { l5 = 9; }
794         if (rn5 >= 100 && rn5 < 110) { l5 = 10; }
795         if (rn5 >= 110 && rn5 < 120) { l5 = 11; }
796         if (rn5 >= 120 && rn5 < 130) { l5 = 12; }
797         if (rn5 >= 130) { l5 = 13; }
798         
799         return l5;
800     }
801 
802     function getLayerSix(uint256 tokenId) internal pure returns (uint256) {
803         uint256 rand = random(string(abi.encodePacked("LAYER SIX", toString(tokenId))));
804 
805         uint256 rn6 = rand % 120;
806         uint256 l6 = 0;
807 
808         if (rn6 >= 10 && rn6 < 20) { l6 = 1; }
809         if (rn6 >= 20 && rn6 < 30) { l6 = 2; }
810         if (rn6 >= 30 && rn6 < 40) { l6 = 3; }
811         if (rn6 >= 40) { l6 = 4; }
812         
813         return l6;
814     }
815 
816     function getSVG(LarvaObject memory larvaLad) internal view returns (string memory) {
817         string[9] memory parts;
818 
819         parts[0] = '<svg id="x" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 30 30"><path fill="#638596" d="M0 0h30v30H0z"/>';
820         parts[1] = '<path fill="';
821         parts[2] = baseColors[larvaLad.baseColor];
822         parts[3] = '" d="M22 10v12h-2v2h-1v1H5v-1h1v-1h1v-1h1v-1h1v-1h2v-1h2v-9h1V9h2V8h-1V7h3v1h1v1h2v1h1z"/><path fill="#000" d="M4 24v2h16v-2h-1v1H5v-1H4zM6 23H5v1h1v-1zM7 22H6v1h1v-1zM8 21H7v1h1v-1zM9 20H8v1h1v-1zM11 19H9v1h2v-1zM12 10v8h-1v1h2v-9h-1zM14 10V9h-1v1h1zM15 8V7h-1v2h2V8h-1zM18 6h-3v1h3V6zM19 7h-1v1h1V7zM21 8h-2v1h2V8zM23 22V9h-2v1h1v12h1zM21 24v-1h1v-1h-2v2h1zM15 13h1v1h-1v-1zM20 13h1v1h-1v-1zM18 15h2v1h-2v-1zM17 18h3v1h-3v-1z"/><path fill="#000" fill-opacity=".2" d="M17 13h-1v1h1v-1zM22 13h-1v1h1v-1z"/><path fill="#000" fill-opacity=".4" d="M17 12h-2v1h2v-1zM20 12v1h2v-1h-2zM22 21h-9v1h1v1h6v-1h2v-1zM12 19h-1v6h2v-1h-1v-5zM10 25v-5H9v5h1zM8 25v-3H7v3h1zM6 24H5v1h1v-1z"/>';
823         parts[4] = thirdLayers[larvaLad.layerThree];
824         parts[5] = fourthLayers[larvaLad.layerFour];
825         parts[6] = fifthLayers[larvaLad.layerFive];
826         parts[7] = sixthLayers[larvaLad.layerSix];
827         parts[8] = '<style>#x{shape-rendering: crispedges;}</style></svg>';
828 
829         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
830 
831         return output;
832     }
833 
834     function tokenURI(uint256 tokenId) override public view returns (string memory) {
835         LarvaObject memory larvaLad = randomLarvaLad(tokenId);
836         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Larva Lad #', toString(tokenId), '", "description": "Larva Lads are a play on the CryptoPunks and their creators, Larva Labs. The artwork and metadata are fully on-chain and were randomly generated at mint."', getTraits(larvaLad), '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(getSVG(larvaLad))), '"}'))));
837         json = string(abi.encodePacked('data:application/json;base64,', json));
838         return json;
839     }
840 
841     function mint(address destination, uint256 amountOfTokens) private {
842         require(totalSupply() < maxSupply, "All tokens have been minted");
843         require(totalSupply() + amountOfTokens <= maxSupply, "Minting would exceed max supply");
844         require(amountOfTokens <= maxMint, "Cannot purchase this many tokens in a transaction");
845         require(amountOfTokens > 0, "Must mint at least one token");
846         require(price * amountOfTokens == msg.value, "ETH amount is incorrect");
847 
848         for (uint256 i = 0; i < amountOfTokens; i++) {
849             uint256 tokenId = numTokensMinted + 1;
850             _safeMint(destination, tokenId);
851             numTokensMinted += 1;
852         }
853     }
854 
855     function mintForSelf(uint256 amountOfTokens) public payable virtual {
856         mint(_msgSender(),amountOfTokens);
857     }
858 
859     function mintForFriend(address walletAddress, uint256 amountOfTokens) public payable virtual {
860         mint(walletAddress,amountOfTokens);
861     }
862 
863     function setPrice(uint256 newPrice) public onlyOwner {
864         price = newPrice;
865     }
866 
867     function setMaxMint(uint256 newMaxMint) public onlyOwner {
868         maxMint = newMaxMint;
869     }
870 
871     function withdrawAll() public payable onlyOwner {
872         require(payable(_msgSender()).send(address(this).balance));
873     }
874 
875     function toString(uint256 value) internal pure returns (string memory) {
876 
877         if (value == 0) {
878             return "0";
879         }
880         uint256 temp = value;
881         uint256 digits;
882         while (temp != 0) {
883             digits++;
884             temp /= 10;
885         }
886         bytes memory buffer = new bytes(digits);
887         while (value != 0) {
888             digits -= 1;
889             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
890             value /= 10;
891         }
892         return string(buffer);
893     }
894     
895     constructor() ERC721("Larva Lads", "LARVA") Ownable() {}
896 }
897 
898 library Base64 {
899     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
900 
901     function encode(bytes memory data) internal pure returns (string memory) {
902         uint256 len = data.length;
903         if (len == 0) return "";
904 
905         uint256 encodedLen = 4 * ((len + 2) / 3);
906 
907         bytes memory result = new bytes(encodedLen + 32);
908 
909         bytes memory table = TABLE;
910 
911         assembly {
912             let tablePtr := add(table, 1)
913             let resultPtr := add(result, 32)
914 
915             for {
916                 let i := 0
917             } lt(i, len) {
918 
919             } {
920                 i := add(i, 3)
921                 let input := and(mload(add(data, i)), 0xffffff)
922 
923                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
924                 out := shl(8, out)
925                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
926                 out := shl(8, out)
927                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
928                 out := shl(8, out)
929                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
930                 out := shl(224, out)
931 
932                 mstore(resultPtr, out)
933 
934                 resultPtr := add(resultPtr, 4)
935             }
936 
937             switch mod(len, 3)
938             case 1 {
939                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
940             }
941             case 2 {
942                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
943             }
944 
945             mstore(result, encodedLen)
946         }
947 
948         return string(result);
949     }
950 }