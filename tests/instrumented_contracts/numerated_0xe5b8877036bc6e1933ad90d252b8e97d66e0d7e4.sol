1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.0;
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7         uint256 size;
8         assembly {
9             size := extcodesize(account)
10         }
11         return size > 0;
12     }
13 }
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 interface IERC165 {
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 abstract contract ERC165 is IERC165 {
30     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
31         return interfaceId == type(IERC165).interfaceId;
32     }
33 }
34 
35 interface IERC721 is IERC165 {
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
39 
40     function balanceOf(address owner) external view returns (uint256 balance);
41     function ownerOf(uint256 tokenId) external view returns (address owner);
42     function safeTransferFrom(
43         address from,
44         address to,
45         uint256 tokenId
46     ) external;
47     function transferFrom(
48         address from,
49         address to,
50         uint256 tokenId
51     ) external;
52     function approve(address to, uint256 tokenId) external;
53     function getApproved(uint256 tokenId) external view returns (address operator);
54     function setApprovalForAll(address operator, bool _approved) external;
55     function isApprovedForAll(address owner, address operator) external view returns (bool);
56     function safeTransferFrom(
57         address from,
58         address to,
59         uint256 tokenId,
60         bytes calldata data
61     ) external;
62 }
63 
64 interface IERC721Receiver {
65     function onERC721Received(
66         address operator,
67         address from,
68         uint256 tokenId,
69         bytes calldata data
70     ) external returns (bytes4);
71 }
72 
73 interface IERC721Metadata is IERC721 {
74     function name() external view returns (string memory);
75     function symbol() external view returns (string memory);
76     function tokenURI(uint256 tokenId) external view returns (string memory);
77 }
78 
79 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
80     using Address for address;
81 
82     string private _name;
83     string private _symbol;
84     mapping(uint256 => address) private _owners;
85     mapping(address => uint256) private _balances;
86     mapping(uint256 => address) private _tokenApprovals;
87     mapping(address => mapping(address => bool)) private _operatorApprovals;
88 
89     constructor(string memory name_, string memory symbol_) {
90         _name = name_;
91         _symbol = symbol_;
92     }
93 
94     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
95         return
96             interfaceId == type(IERC721).interfaceId ||
97             interfaceId == type(IERC721Metadata).interfaceId ||
98             super.supportsInterface(interfaceId);
99     }
100 
101     function balanceOf(address owner) public view virtual override returns (uint256) {
102         require(owner != address(0), "ERC721: balance query for the zero address");
103         return _balances[owner];
104     }
105 
106     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
107         address owner = _owners[tokenId];
108         require(owner != address(0), "ERC721: owner query for nonexistent token");
109         return owner;
110     }
111 
112     function name() public view virtual override returns (string memory) {
113         return _name;
114     }
115 
116     function symbol() public view virtual override returns (string memory) {
117         return _symbol;
118     }
119 
120     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
121         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
122 
123         return "";
124     }
125 
126     function approve(address to, uint256 tokenId) public virtual override {
127         address owner = ERC721.ownerOf(tokenId);
128         require(to != owner, "ERC721: approval to current owner");
129 
130         require(
131             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
132             "ERC721: approve caller is not owner nor approved for all"
133         );
134 
135         _approve(to, tokenId);
136     }
137 
138     function getApproved(uint256 tokenId) public view virtual override returns (address) {
139         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
140 
141         return _tokenApprovals[tokenId];
142     }
143 
144     function setApprovalForAll(address operator, bool approved) public virtual override {
145         require(operator != _msgSender(), "ERC721: approve to caller");
146 
147         _operatorApprovals[_msgSender()][operator] = approved;
148         emit ApprovalForAll(_msgSender(), operator, approved);
149     }
150 
151     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
152         return _operatorApprovals[owner][operator];
153     }
154 
155     function transferFrom(
156         address from,
157         address to,
158         uint256 tokenId
159     ) public virtual override {
160         //solhint-disable-next-line max-line-length
161         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
162 
163         _transfer(from, to, tokenId);
164     }
165 
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) public virtual override {
171         safeTransferFrom(from, to, tokenId, "");
172     }
173 
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes memory _data
179     ) public virtual override {
180         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
181         _safeTransfer(from, to, tokenId, _data);
182     }
183 
184     function _safeTransfer(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes memory _data
189     ) internal virtual {
190         _transfer(from, to, tokenId);
191         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
192     }
193 
194     function _exists(uint256 tokenId) internal view virtual returns (bool) {
195         return _owners[tokenId] != address(0);
196     }
197 
198     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
199         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
200         address owner = ERC721.ownerOf(tokenId);
201         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
202     }
203 
204     function _safeMint(address to, uint256 tokenId) internal virtual {
205         _safeMint(to, tokenId, "");
206     }
207 
208     function _safeMint(
209         address to,
210         uint256 tokenId,
211         bytes memory _data
212     ) internal virtual {
213         _mint(to, tokenId);
214         require(
215             _checkOnERC721Received(address(0), to, tokenId, _data),
216             "ERC721: transfer to non ERC721Receiver implementer"
217         );
218     }
219 
220     function _mint(address to, uint256 tokenId) internal virtual {
221         require(to != address(0), "ERC721: mint to the zero address");
222         require(!_exists(tokenId), "ERC721: token already minted");
223 
224         _beforeTokenTransfer(address(0), to, tokenId);
225 
226         _balances[to] += 1;
227         _owners[tokenId] = to;
228 
229         emit Transfer(address(0), to, tokenId);
230     }
231 
232     function _transfer(
233         address from,
234         address to,
235         uint256 tokenId
236     ) internal virtual {
237         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
238         require(to != address(0), "ERC721: transfer to the zero address");
239 
240         _beforeTokenTransfer(from, to, tokenId);
241 
242         // Clear approvals from the previous owner
243         _approve(address(0), tokenId);
244 
245         _balances[from] -= 1;
246         _balances[to] += 1;
247         _owners[tokenId] = to;
248 
249         emit Transfer(from, to, tokenId);
250     }
251 
252     function _approve(address to, uint256 tokenId) internal virtual {
253         _tokenApprovals[tokenId] = to;
254         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
255     }
256 
257     function _checkOnERC721Received(
258         address from,
259         address to,
260         uint256 tokenId,
261         bytes memory _data
262     ) private returns (bool) {
263         if (to.isContract()) {
264             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
265                 return retval == IERC721Receiver.onERC721Received.selector;
266             } catch (bytes memory reason) {
267                 if (reason.length == 0) {
268                     revert("ERC721: transfer to non ERC721Receiver implementer");
269                 } else {
270                     assembly {
271                         revert(add(32, reason), mload(reason))
272                     }
273                 }
274             }
275         } else {
276             return true;
277         }
278     }
279 
280     function _beforeTokenTransfer(
281         address from,
282         address to,
283         uint256 tokenId
284     ) internal virtual {}
285 }
286 
287 interface IERC721Enumerable is IERC721 {
288     function totalSupply() external view returns (uint256);
289     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
290     function tokenByIndex(uint256 index) external view returns (uint256);
291 }
292 
293 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
294     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
295     mapping(uint256 => uint256) private _ownedTokensIndex;
296     uint256[] private _allTokens;
297     mapping(uint256 => uint256) private _allTokensIndex;
298 
299     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
300         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
301     }
302 
303     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
304         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
305         return _ownedTokens[owner][index];
306     }
307 
308     function totalSupply() public view virtual override returns (uint256) {
309         return _allTokens.length;
310     }
311 
312     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
313         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
314         return _allTokens[index];
315     }
316 
317     function _beforeTokenTransfer(
318         address from,
319         address to,
320         uint256 tokenId
321     ) internal virtual override {
322         super._beforeTokenTransfer(from, to, tokenId);
323 
324         if (from == address(0)) {
325             _addTokenToAllTokensEnumeration(tokenId);
326         } else if (from != to) {
327             _removeTokenFromOwnerEnumeration(from, tokenId);
328         }
329         if (to == address(0)) {
330             _removeTokenFromAllTokensEnumeration(tokenId);
331         } else if (to != from) {
332             _addTokenToOwnerEnumeration(to, tokenId);
333         }
334     }
335 
336     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
337         uint256 length = ERC721.balanceOf(to);
338         _ownedTokens[to][length] = tokenId;
339         _ownedTokensIndex[tokenId] = length;
340     }
341 
342     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
343         _allTokensIndex[tokenId] = _allTokens.length;
344         _allTokens.push(tokenId);
345     }
346 
347     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
348         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
349         uint256 tokenIndex = _ownedTokensIndex[tokenId];
350 
351         // When the token to delete is the last token, the swap operation is unnecessary
352         if (tokenIndex != lastTokenIndex) {
353             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
354 
355             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
356             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
357         }
358         // This also deletes the contents at the last position of the array
359         delete _ownedTokensIndex[tokenId];
360         delete _ownedTokens[from][lastTokenIndex];
361     }
362 
363     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
364         uint256 lastTokenIndex = _allTokens.length - 1;
365         uint256 tokenIndex = _allTokensIndex[tokenId];
366 
367         uint256 lastTokenId = _allTokens[lastTokenIndex];
368 
369         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
370         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
371 
372         // This also deletes the contents at the last position of the array
373         delete _allTokensIndex[tokenId];
374         _allTokens.pop();
375     }
376 }
377 
378 abstract contract ReentrancyGuard {
379     uint256 private constant _NOT_ENTERED = 1;
380     uint256 private constant _ENTERED = 2;
381 
382     uint256 private _status;
383 
384     constructor() {
385         _status = _NOT_ENTERED;
386     }
387 
388     modifier nonReentrant() {
389         // On the first call to nonReentrant, _notEntered will be true
390         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
391 
392         // Any calls to nonReentrant after this point will fail
393         _status = _ENTERED;
394 
395         _;
396 
397         // By storing the original value once again, a refund is triggered (see
398         // https://eips.ethereum.org/EIPS/eip-2200)
399         _status = _NOT_ENTERED;
400     }
401 }
402 
403 library Math {
404     function max(uint256 a, uint256 b) internal pure returns (uint256) {
405         return a >= b ? a : b;
406     }
407 
408     function min(uint256 a, uint256 b) internal pure returns (uint256) {
409         return a < b ? a : b;
410     }
411 }
412 
413 interface InterfaceN  {
414     function ownerOf(uint256 tokenId) external view returns (address owner);
415 
416     function getFirst(uint256 tokenId) external view returns (uint256);
417     function getSecond(uint256 tokenId) external view returns (uint256);
418     function getThird(uint256 tokenId) external view returns (uint256);
419     function getFourth(uint256 tokenId) external view returns (uint256); 
420     function getFifth(uint256 tokenId) external view returns (uint256); 
421     function getSixth(uint256 tokenId) external view returns (uint256); 
422     function getSeventh(uint256 tokenId) external view returns (uint256);
423     function getEight(uint256 tokenId) external view returns (uint256);
424 }
425 
426 contract FriendlyFractalsN is ERC721("Friendly Fractals N", "FRFRACN"), ERC721Enumerable, ReentrancyGuard {
427     address public addressN;
428 
429 	bytes private uriHead1 = "data:application/json;charset=utf-8,%7B%22name%22%3A%20%22Friendly%20Fractals%20N%20";
430 	bytes private uriHead2 = "%22%2C%22description%22%3A%20%22Fully%20on-chain%20generative%20fractal%20patterns%20based%20on%20the%20your%20n.%22%2C%22image%22%3A%20%22data%3Aimage%2Fsvg%2Bxml%3Bcharset%3Dutf-8%2C%3Csvg%20width%3D'100%25'%20height%3D'100%25'%20viewBox%3D'0%200%20100000%20100000'%20style%3D'stroke-width%3A";
431     bytes private uriHead3 = "%20background-color%3Argb(0%2C0%2C0)'%20xmlns%3D'http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg'%3E";
432 	bytes private uriTail = "%3C%2Fsvg%3E%22%7D";
433 
434     constructor(address addressOfN) {
435         addressN = addressOfN;
436     }
437 
438     function _beforeTokenTransfer(
439         address from,
440         address to,
441         uint256 tokenId
442     ) internal override(ERC721, ERC721Enumerable) {
443         super._beforeTokenTransfer(from, to, tokenId);
444     }
445 
446     function supportsInterface(bytes4 interfaceId)
447         public
448         view
449         override(ERC721, ERC721Enumerable)
450         returns (bool)
451     {
452         return super.supportsInterface(interfaceId);
453     }
454 
455     function mint(uint256 tokenId) public nonReentrant {
456         require(tokenId > 0 && tokenId < 8889, "FriendlyFractalsN: Token ID invalid");
457     	require(InterfaceN(addressN).ownerOf(tokenId) == _msgSender(), "FriendlyFractalsN: Must own respective N");
458 
459     	_safeMint(_msgSender(), tokenId);
460     }
461 
462     function tokenURI(uint256 tokenId) public view override returns (string memory) {
463         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
464         return tokenSVGFromSeed(tokenId);
465     }
466 
467     function tokenSVGFromSeed(uint256 tokenId) internal view returns (string memory) {
468         uint256 numIterations = 6;
469 
470         // space to store the string format of x1, y1, x2, y2
471         string[4] memory vars = ["1000000", "1000000", "1000000", "1000000"];
472 
473         // Sixth N: Iterations 1 to 2 (typea)
474         // Seventh N: Iterations 3 to 4 (typeb)
475         // Eight N: Iterations 5 to 6 (typec)
476         uint256 typea = InterfaceN(addressN).getSixth(tokenId) % 9;
477         uint256 typeb = InterfaceN(addressN).getSeventh(tokenId) % 9;
478         uint256 typec = InterfaceN(addressN).getEight(tokenId) % 9;
479 
480         // space for all the data to compute the fractal
481         uint256[] memory data = new uint256[](2**(numIterations+1)-1);
482 
483         data[0]= compact(35000, 35000, 30000, 30000);
484         for (uint256 i=0; i<2**numIterations-1; i++) {
485             //generate both children
486             if (i < 3) {
487                 data[2*i+1] = getChildData(data[i], true, typea);
488                 data[2*i+2] = getChildData(data[i], false, typea);
489             } else if (i < 15) {
490                 data[2*i+1] = getChildData(data[i], true, typeb);
491                 data[2*i+2] = getChildData(data[i], false, typeb);
492             } else {
493                 data[2*i+1] = getChildData(data[i], true, typec);
494                 data[2*i+2] = getChildData(data[i], false, typec);
495             }
496         }
497 
498         // generate result string
499         // each line takes up to 84 characters.
500         bytes memory result = new bytes(84*(2**numIterations)+580);
501         bytes memory cur;
502         assembly {
503         	cur := add(result, 32) //offset length header
504         } 
505         uint256 totallen = 0;
506     	uint256 linelen;
507 
508 
509         // add head
510         bytes memory head = getHeadString(tokenId);
511         (linelen, cur) = copyString(cur, head);
512         totallen += linelen;
513 
514     	// add body
515         for (uint256 i=2**numIterations-1; i<data.length; i++) {
516         	bytes memory curLine = getCurLine(data, i, vars);
517         	(linelen, cur) = copyString(cur, curLine);
518         	totallen += linelen;
519         }
520 
521         // add tail
522     	(linelen, cur) = copyString(cur, uriTail);
523     	totallen += linelen;
524 
525         // reassign total length
526         assembly {
527         	mstore(result, totallen)
528         }
529 
530         return string(result);
531     }
532 
533     function getChildData(uint256 data, bool leftChild, uint256 curtype) internal view returns (uint256) {
534     	int256 x;
535         int256 y;
536         int256 dx;
537         int256 dy;
538 
539         (x, y, dx, dy) = expand(data);
540 
541 		int256 sqrt2a = 14142;
542 		int256 sqrt2b = 10000;
543 
544 		// rotate 45 degrees and scale by 1/sqrt(2). dx1,dy1 is for one direction of rotation, dx2,dy2 for the other
545         // int256 dx1 = (dx * sqrt2b / sqrt2a - dy * sqrt2b / sqrt2a ) * sqrt2b / sqrt2a;
546         // int256 dy1 = (dx * sqrt2b / sqrt2a + dy * sqrt2b / sqrt2a ) * sqrt2b / sqrt2a;
547         // int256 dx2 = (dx * sqrt2b / sqrt2a + dy * sqrt2b / sqrt2a ) * sqrt2b / sqrt2a;
548         // int256 dy2 =  (-dx * sqrt2b / sqrt2a + dy * sqrt2b / sqrt2a) * sqrt2b / sqrt2a;
549         int256 dx1;
550         int256 dy1;
551         int256 dx2;
552         int256 dy2;
553 
554         assembly {
555         	dx1 := sdiv(mul(sub(sdiv(mul(dx, sqrt2b), sqrt2a),sdiv(mul(dy, sqrt2b),sqrt2a)),sqrt2b),sqrt2a)
556         	dy1 := sdiv(mul(add(sdiv(mul(dx, sqrt2b), sqrt2a),sdiv(mul(dy, sqrt2b),sqrt2a)),sqrt2b),sqrt2a)
557         	dx2 := sdiv(mul(add(sdiv(mul(dx, sqrt2b), sqrt2a),sdiv(mul(dy, sqrt2b),sqrt2a)),sqrt2b),sqrt2a)
558         	dy2 := sdiv(mul(add(sdiv(mul(add(1,not(dx)), sqrt2b), sqrt2a),sdiv(mul(dy, sqrt2b),sqrt2a)),sqrt2b),sqrt2a)
559         }
560 
561 
562         // reuse x,y,dx,dy for return. Not enough local variables
563         if (leftChild && (curtype == 3) || 
564             !leftChild && (curtype == 0 || curtype == 4 || curtype == 8)) {
565         	assembly {
566         		x := add(x, dx)
567         		y := add(y, dy)
568         	}
569         } else if (curtype == 6 || 
570         		  !leftChild && (curtype == 1 || curtype == 3)) {
571         	assembly {
572         		x := add(x, dx1)
573         		y := add(y, dy1)
574         	}
575         } else if (!leftChild && (curtype == 2 || curtype == 5 || curtype == 7)) {
576         	assembly {
577         		x := add(x, dx2)
578         		y := add(y, dy2)
579         	}
580         }
581 
582         if (leftChild && (curtype == 0 || curtype == 1 || curtype == 4 || curtype == 5 || curtype == 7) ||
583         	!leftChild && (curtype == 2 || curtype == 5)) {
584         	dx = dx1;
585         	dy = dy1;
586 
587         }  else if (leftChild && (curtype == 6) ||
588         			!leftChild && (curtype == 3 || curtype == 4)) {
589         	assembly {
590         		dx := add(1, not(dx1))
591         		dy := add(1, not(dy1))
592         	}
593 
594         } else if (leftChild && (curtype == 2 || curtype == 8) || 
595         		  !leftChild && (curtype == 1 || curtype == 6)) {
596     		dx = dx2;
597     		dy = dy2;
598 
599         } else if (leftChild && (curtype == 3) || 
600         			!leftChild && (curtype == 0 || curtype == 7 || curtype == 8)) {
601         	assembly {
602         		dx := add(1, not(dx2))
603         		dy := add(1, not(dy2))
604         	}
605         } 
606 
607     	return compact(x, y, dx, dy);
608     }
609 
610     // compact variables into uint256
611     function compact(int256 x, int256 y, int256 dx, int256 dy) internal pure returns (uint256) {
612     	uint256 result = 0;
613     	result |= uint256(dy & 0xffffffff);
614     	result = result << 32;
615     	result |= uint256(dx & 0xffffffff);
616     	result = result << 32;
617     	result |= uint256(y & 0xffffffff);
618     	result = result << 32;
619     	result |= uint256(x & 0xffffffff);
620 
621     	return result;
622     }
623 
624     // expand variables from uint256
625     function expand(uint256 vars) internal pure returns (int256 x, int256 y, int256 dx, int256 dy) {
626     	x = int256(int32(uint32(vars)));
627     	vars = vars >> 32;
628     	y = int256(int32(uint32(vars)));
629     	vars = vars >> 32;
630     	dx = int256(int32(uint32(vars)));
631     	vars = vars >> 32;
632     	dy = int256(int32(uint32(vars)));
633     }
634 
635     function uintToString(uint v) public pure returns (string memory) {
636         uint maxlength = 8;
637         bytes memory reversed = new bytes(maxlength);
638         uint i = 0;
639         while (v != 0) {
640             uint remainder = v % 10;
641             v = v / 10;
642             reversed[i++] = bytes1(uint8(48 + remainder));
643         }
644         bytes memory s = new bytes(i); // i + 1 is inefficient
645         for (uint j = 0; j < i; j++) {
646             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
647         }
648         string memory str = string(s);  // memory isn't implicitly convertible to storage
649         return str;
650     }
651 
652     function getHeadString(uint256 tokenId) internal view returns (bytes memory) {
653         uint256 strokeWidth = 100 + 100 * InterfaceN(addressN).getFifth(tokenId);
654 
655         return abi.encodePacked(uriHead1, "%23", uintToString(tokenId), uriHead2, uintToString(strokeWidth), "%3B%20", getColorString(tokenId), uriHead3);
656     }
657 
658     function getColorString(uint256 tokenId) internal view returns (bytes memory) {
659     	
660         uint256 color_h = Math.min(InterfaceN(addressN).getFirst(tokenId), 10) * 33 + Math.min(Math.max(InterfaceN(addressN).getSecond(tokenId), 1), 10) * 3;
661         uint256 color_s = 30 + Math.min(InterfaceN(addressN).getThird(tokenId), 10) * 7;
662         uint256 color_l = 20 + Math.min(InterfaceN(addressN).getFourth(tokenId), 10) * 6;
663 
664         return abi.encodePacked("stroke%3Ahsl(", uintToString(color_h), "%2C", uintToString(color_s), "%25%2C", uintToString(color_l), "%25)%3B");
665     }
666 
667     // returns length of string copied and current position of pointer
668     function copyString(bytes memory curPosition, bytes memory strToCopy) internal view returns (uint256 linelen, bytes memory resPosition) {
669     	uint256 numloops = (strToCopy.length + 31) / 32;
670     	linelen = strToCopy.length;
671     	resPosition = curPosition;
672 
673     	// copy curLine into result
674     	assembly {
675 	        for {  let j := 0 } lt(j, numloops) { j := add(1, j) } { mstore(add(resPosition, mul(32, j)), mload(add(strToCopy, mul(32, add(1, j))))) }
676 	        resPosition := add(resPosition, linelen)
677 	    }
678     }
679 
680     // get svg line output from data
681     function getCurLine(uint256[] memory data, uint256 index, string[4] memory vars) internal view returns (bytes memory) {      
682       	uint256 remainder;
683         int256 x;
684         int256 y;
685         int256 dx;
686         int256 dy;
687         (x, y, dx, dy) = expand(data[index]);
688 
689     	uint256 curdigit;
690     	uint256 numdigits;
691     	string memory stringStart;
692 
693     	for (uint256 i=0; i<4; i++) {
694     		curdigit = 0;
695     		numdigits = 0;
696 	    	uint256 num;
697 	    	if (i == 0) {
698 	    		num = uint256(x);
699 	    	} else if (i == 1) {
700 	    		num = uint256(y);
701 	    	}  else if (i == 2) {
702 	    		num = uint256(x+dx);
703 	    	} else {
704 	    		num = uint256(y+dy);
705 	    	}
706 
707 	    	assembly {
708 	    		stringStart := mload(add(vars, mul(32, i)))
709 	    	}
710 
711 	    	uint256 numcopy = num;
712 
713 	    	// count number of digits
714 	    	
715 	    	// while (numcopy > 0) {
716 	    	// 	numdigits += 1;
717 	    	// 	numcopy /= 10;
718 	    	// }
719 	    	assembly {
720 	    		for { } gt(numcopy, 0) { numcopy := div(numcopy, 10) } { numdigits := add(numdigits, 1) }
721 			}
722 
723 			// convert integer into string format
724 
725 			// assume number won't be 0, so only handle above 0 case
726 	        // while (num > 0) {
727 	        // 	remainder = ((num % 10) + 48);
728 	        // 	assembly {
729 	        // 		mstore8(add(stringStart, add(31, sub(numdigits,curdigit))), remainder)
730 	        // 	}
731 	        // 	num /= 10;
732 	        // 	curdigit += 1;
733 	        // }
734 	        assembly {
735 	        	for {} gt(num, 0) {num := div(num, 10)} {
736 	        		remainder := add(mod(num, 10),  48)
737 	        		mstore8(add(stringStart, add(31, sub(numdigits,curdigit))), remainder)
738 	        		curdigit := add(curdigit, 1)
739 	        	}
740 	        }
741 
742 	        assembly {
743 	    		mstore(stringStart, curdigit)
744 	    	}
745     	}
746 
747         return abi.encodePacked("%3Cline%20x1%3D'", vars[0] ,"'%20y1%3D'", vars[1], "'%20x2%3D'", vars[2], "'%20y2%3D'", vars[3], "'%20%2F%3E");
748 
749     }
750 }