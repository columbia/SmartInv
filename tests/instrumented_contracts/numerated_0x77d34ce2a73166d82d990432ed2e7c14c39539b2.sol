1 /*
2 SPDX-License-Identifier: GPL-3.0
3 
4 Made by Sliday.com, from 🇳🇿 with love
5 
6 The whole team of Sliday (design and development shop from Auckland, New Zealand, est. 2009) has been tirelessly working to bring this incredibly attractive pfp collection to you. 200+ human hours were spent to remove excessive pixels from the original CrypToadz. Enjoy!
7 
8 Each CrypToad got manually enhanced during a 10-hour long “Toadthon” event. We shared good vibes, salty jokes, good music and could hardly stay awake the next day. Rest assured, every toadhead is a handmade digital asset made by a real warm-blooded human creature.
9 
10 */
11 
12 pragma solidity ^0.8.0;
13 
14 
15 interface IERC165 {
16     
17     function supportsInterface(bytes4 interfaceId) external view returns (bool);
18 }
19 
20 interface IERC721 is IERC165 {
21     
22     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
23 
24     
25     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
26 
27     
28     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
29 
30     
31     function balanceOf(address owner) external view returns (uint256 balance);
32 
33     
34     function ownerOf(uint256 tokenId) external view returns (address owner);
35 
36     
37     function safeTransferFrom(
38         address from,
39         address to,
40         uint256 tokenId
41     ) external;
42 
43     
44     function transferFrom(
45         address from,
46         address to,
47         uint256 tokenId
48     ) external;
49 
50     
51     function approve(address to, uint256 tokenId) external;
52 
53     
54     function getApproved(uint256 tokenId) external view returns (address operator);
55 
56     
57     function setApprovalForAll(address operator, bool _approved) external;
58 
59     
60     function isApprovedForAll(address owner, address operator) external view returns (bool);
61 
62     
63     function safeTransferFrom(
64         address from,
65         address to,
66         uint256 tokenId,
67         bytes calldata data
68     ) external;
69 }
70 
71 interface IERC721Receiver {
72     
73     function onERC721Received(
74         address operator,
75         address from,
76         uint256 tokenId,
77         bytes calldata data
78     ) external returns (bytes4);
79 }
80 
81 interface IERC721Metadata is IERC721 {
82     
83     function name() external view returns (string memory);
84 
85     
86     function symbol() external view returns (string memory);
87 
88     
89     function tokenURI(uint256 tokenId) external view returns (string memory);
90 }
91 
92 library Address {
93     
94     function isContract(address account) internal view returns (bool) {
95         
96         
97         
98 
99         uint256 size;
100         assembly {
101             size := extcodesize(account)
102         }
103         return size > 0;
104     }
105 
106     
107     function sendValue(address payable recipient, uint256 amount) internal {
108         require(address(this).balance >= amount, "Address: insufficient balance");
109 
110         (bool success, ) = recipient.call{value: amount}("");
111         require(success, "Address: unable to send value, recipient may have reverted");
112     }
113 
114     
115     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
116         return functionCall(target, data, "Address: low-level call failed");
117     }
118 
119     
120     function functionCall(
121         address target,
122         bytes memory data,
123         string memory errorMessage
124     ) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, 0, errorMessage);
126     }
127 
128     
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     
138     function functionCallWithValue(
139         address target,
140         bytes memory data,
141         uint256 value,
142         string memory errorMessage
143     ) internal returns (bytes memory) {
144         require(address(this).balance >= value, "Address: insufficient balance for call");
145         require(isContract(target), "Address: call to non-contract");
146 
147         (bool success, bytes memory returndata) = target.call{value: value}(data);
148         return verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         require(isContract(target), "Address: static call to non-contract");
163 
164         (bool success, bytes memory returndata) = target.staticcall(data);
165         return verifyCallResult(success, returndata, errorMessage);
166     }
167 
168     
169     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
171     }
172 
173     
174     function functionDelegateCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         require(isContract(target), "Address: delegate call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.delegatecall(data);
182         return verifyCallResult(success, returndata, errorMessage);
183     }
184 
185     
186     function verifyCallResult(
187         bool success,
188         bytes memory returndata,
189         string memory errorMessage
190     ) internal pure returns (bytes memory) {
191         if (success) {
192             return returndata;
193         } else {
194             
195             if (returndata.length > 0) {
196                 
197 
198                 assembly {
199                     let returndata_size := mload(returndata)
200                     revert(add(32, returndata), returndata_size)
201                 }
202             } else {
203                 revert(errorMessage);
204             }
205         }
206     }
207 }
208 
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 library Strings {
220     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
221 
222     
223     function toString(uint256 value) internal pure returns (string memory) {
224         
225         
226 
227         if (value == 0) {
228             return "0";
229         }
230         uint256 temp = value;
231         uint256 digits;
232         while (temp != 0) {
233             digits++;
234             temp /= 10;
235         }
236         bytes memory buffer = new bytes(digits);
237         while (value != 0) {
238             digits -= 1;
239             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
240             value /= 10;
241         }
242         return string(buffer);
243     }
244 
245     
246     function toHexString(uint256 value) internal pure returns (string memory) {
247         if (value == 0) {
248             return "0x00";
249         }
250         uint256 temp = value;
251         uint256 length = 0;
252         while (temp != 0) {
253             length++;
254             temp >>= 8;
255         }
256         return toHexString(value, length);
257     }
258 
259     
260     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
261         bytes memory buffer = new bytes(2 * length + 2);
262         buffer[0] = "0";
263         buffer[1] = "x";
264         for (uint256 i = 2 * length + 1; i > 1; --i) {
265             buffer[i] = _HEX_SYMBOLS[value & 0xf];
266             value >>= 4;
267         }
268         require(value == 0, "Strings: hex length insufficient");
269         return string(buffer);
270     }
271 }
272 
273 abstract contract ERC165 is IERC165 {
274     
275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
276         return interfaceId == type(IERC165).interfaceId;
277     }
278 }
279 
280 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
281     using Address for address;
282     using Strings for uint256;
283 
284     
285     string private _name;
286 
287     
288     string private _symbol;
289 
290     
291     mapping(uint256 => address) private _owners;
292 
293     
294     mapping(address => uint256) private _balances;
295 
296     
297     mapping(uint256 => address) private _tokenApprovals;
298 
299     
300     mapping(address => mapping(address => bool)) private _operatorApprovals;
301 
302     
303     constructor(string memory name_, string memory symbol_) {
304         _name = name_;
305         _symbol = symbol_;
306     }
307 
308     
309     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
310         return
311             interfaceId == type(IERC721).interfaceId ||
312             interfaceId == type(IERC721Metadata).interfaceId ||
313             super.supportsInterface(interfaceId);
314     }
315 
316     
317     function balanceOf(address owner) public view virtual override returns (uint256) {
318         require(owner != address(0), "ERC721: balance query for the zero address");
319         return _balances[owner];
320     }
321 
322     
323     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
324         address owner = _owners[tokenId];
325         require(owner != address(0), "ERC721: owner query for nonexistent token");
326         return owner;
327     }
328 
329     
330     function name() public view virtual override returns (string memory) {
331         return _name;
332     }
333 
334     
335     function symbol() public view virtual override returns (string memory) {
336         return _symbol;
337     }
338 
339     
340     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
341         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
342 
343         string memory baseURI = _baseURI();
344         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
345     }
346 
347     
348     function _baseURI() internal view virtual returns (string memory) {
349         return "";
350     }
351 
352     
353     function approve(address to, uint256 tokenId) public virtual override {
354         address owner = ERC721.ownerOf(tokenId);
355         require(to != owner, "ERC721: approval to current owner");
356 
357         require(
358             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
359             "ERC721: approve caller is not owner nor approved for all"
360         );
361 
362         _approve(to, tokenId);
363     }
364 
365     
366     function getApproved(uint256 tokenId) public view virtual override returns (address) {
367         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
368 
369         return _tokenApprovals[tokenId];
370     }
371 
372     
373     function setApprovalForAll(address operator, bool approved) public virtual override {
374         require(operator != _msgSender(), "ERC721: approve to caller");
375 
376         _operatorApprovals[_msgSender()][operator] = approved;
377         emit ApprovalForAll(_msgSender(), operator, approved);
378     }
379 
380     
381     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
382         return _operatorApprovals[owner][operator];
383     }
384 
385     
386     function transferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) public virtual override {
391         
392         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
393 
394         _transfer(from, to, tokenId);
395     }
396 
397     
398     function safeTransferFrom(
399         address from,
400         address to,
401         uint256 tokenId
402     ) public virtual override {
403         safeTransferFrom(from, to, tokenId, "");
404     }
405 
406     
407     function safeTransferFrom(
408         address from,
409         address to,
410         uint256 tokenId,
411         bytes memory _data
412     ) public virtual override {
413         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
414         _safeTransfer(from, to, tokenId, _data);
415     }
416 
417     
418     function _safeTransfer(
419         address from,
420         address to,
421         uint256 tokenId,
422         bytes memory _data
423     ) internal virtual {
424         _transfer(from, to, tokenId);
425         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
426     }
427 
428     
429     function _exists(uint256 tokenId) internal view virtual returns (bool) {
430         return _owners[tokenId] != address(0);
431     }
432 
433     
434     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
435         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
436         address owner = ERC721.ownerOf(tokenId);
437         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
438     }
439 
440     
441     function _safeMint(address to, uint256 tokenId) internal virtual {
442         _safeMint(to, tokenId, "");
443     }
444 
445     
446     function _safeMint(
447         address to,
448         uint256 tokenId,
449         bytes memory _data
450     ) internal virtual {
451         _mint(to, tokenId);
452         require(
453             _checkOnERC721Received(address(0), to, tokenId, _data),
454             "ERC721: transfer to non ERC721Receiver implementer"
455         );
456     }
457 
458     
459     function _mint(address to, uint256 tokenId) internal virtual {
460         require(to != address(0), "ERC721: mint to the zero address");
461         require(!_exists(tokenId), "ERC721: token already minted");
462 
463         _beforeTokenTransfer(address(0), to, tokenId);
464 
465         _balances[to] += 1;
466         _owners[tokenId] = to;
467 
468         emit Transfer(address(0), to, tokenId);
469     }
470 
471     
472     function _burn(uint256 tokenId) internal virtual {
473         address owner = ERC721.ownerOf(tokenId);
474 
475         _beforeTokenTransfer(owner, address(0), tokenId);
476 
477         
478         _approve(address(0), tokenId);
479 
480         _balances[owner] -= 1;
481         delete _owners[tokenId];
482 
483         emit Transfer(owner, address(0), tokenId);
484     }
485 
486     
487     function _transfer(
488         address from,
489         address to,
490         uint256 tokenId
491     ) internal virtual {
492         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
493         require(to != address(0), "ERC721: transfer to the zero address");
494 
495         _beforeTokenTransfer(from, to, tokenId);
496 
497         
498         _approve(address(0), tokenId);
499 
500         _balances[from] -= 1;
501         _balances[to] += 1;
502         _owners[tokenId] = to;
503 
504         emit Transfer(from, to, tokenId);
505     }
506 
507     
508     function _approve(address to, uint256 tokenId) internal virtual {
509         _tokenApprovals[tokenId] = to;
510         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
511     }
512 
513     
514     function _checkOnERC721Received(
515         address from,
516         address to,
517         uint256 tokenId,
518         bytes memory _data
519     ) private returns (bool) {
520         if (to.isContract()) {
521             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
522                 return retval == IERC721Receiver.onERC721Received.selector;
523             } catch (bytes memory reason) {
524                 if (reason.length == 0) {
525                     revert("ERC721: transfer to non ERC721Receiver implementer");
526                 } else {
527                     assembly {
528                         revert(add(32, reason), mload(reason))
529                     }
530                 }
531             }
532         } else {
533             return true;
534         }
535     }
536 
537     
538     function _beforeTokenTransfer(
539         address from,
540         address to,
541         uint256 tokenId
542     ) internal virtual {}
543 }
544 
545 abstract contract Ownable is Context {
546     address private _owner;
547 
548     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
549 
550     
551     constructor() {
552         _setOwner(_msgSender());
553     }
554 
555     
556     function owner() public view virtual returns (address) {
557         return _owner;
558     }
559 
560     
561     modifier onlyOwner() {
562         require(owner() == _msgSender(), "Ownable: caller is not the owner");
563         _;
564     }
565 
566     
567     function renounceOwnership() public virtual onlyOwner {
568         _setOwner(address(0));
569     }
570 
571     
572     function transferOwnership(address newOwner) public virtual onlyOwner {
573         require(newOwner != address(0), "Ownable: new owner is the zero address");
574         _setOwner(newOwner);
575     }
576 
577     function _setOwner(address newOwner) private {
578         address oldOwner = _owner;
579         _owner = newOwner;
580         emit OwnershipTransferred(oldOwner, newOwner);
581     }
582 }
583 
584 contract Theadz is ERC721, Ownable {
585     uint256 public constant maxTokens = 6969;
586     uint256 private maxMintsPerTx = 5;
587     uint256 public nextTokenId = 1;
588 
589     constructor()
590     ERC721("Toadheadz", "TOADHEADZ")
591     {}
592 
593     function _baseURI() internal pure override returns (string memory) {
594         return "https://mint.toadheadz.com/data/meta/";
595     }
596 
597     function totalSupply() public view virtual returns (uint256) {
598         return nextTokenId - 1;
599     }
600 
601     function getMaxTokensPerMint() public view virtual returns (uint256) {
602         return maxMintsPerTx;
603     }
604 
605     function setMaxTokensPerMint(uint256 quantity)
606     external
607     onlyOwner
608     {
609         require(quantity < 100, '100 max');
610         maxMintsPerTx = quantity;
611 
612     }
613 
614     function devmint(address newOwner, uint256 quantity)
615     external
616     onlyOwner
617     {
618         require(
619             nextTokenId - 1 + quantity <= maxTokens,
620             "Minting this many would exceed supply!"
621         );
622         for (uint256 i = 0; i < quantity; i++) {
623             _safeMint(newOwner, nextTokenId++);
624         }
625     }
626 
627     function mint(uint256 quantity)
628     external
629     {
630         require(
631             quantity <= maxMintsPerTx,
632             "There is a limit on minting too many at a time!"
633         );
634         require(
635             nextTokenId - 1 + quantity <= maxTokens,
636             "Minting this many would exceed supply!"
637         );
638         require(
639             msg.sender == tx.origin,
640             "No contracts!"
641         );
642         for (uint256 i = 0; i < quantity; i++) {
643             _safeMint(msg.sender, nextTokenId++);
644         }
645     }
646 }