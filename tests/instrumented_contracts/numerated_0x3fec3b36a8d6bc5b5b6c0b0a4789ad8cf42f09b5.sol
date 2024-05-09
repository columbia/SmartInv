1 // SPDX-License-Identifier: MIT
2 /**
3  * @title TrollMutant
4  * @author AhmYieTrollMutant
5  * @dev Used for Ethereum projects compatible with OpenSea
6  */
7 pragma solidity ^0.8.0;
8 interface IERC165 {
9     function supportsInterface(bytes4 interfaceId) external view returns (bool);
10 }
11 
12 pragma solidity ^0.8.0;
13 interface IERC721Receiver {
14     function onERC721Received(
15         address operator,
16         address from,
17         uint256 tokenId,
18         bytes calldata data
19     ) external returns (bytes4);
20 }
21 
22 pragma solidity ^0.8.0;
23 interface IERC721 is IERC165 {
24     event Transfer(
25         address indexed from,
26         address indexed to,
27         uint256 indexed tokenId
28     );
29     event Approval(
30         address indexed owner,
31         address indexed approved,
32         uint256 indexed tokenId
33     );
34     event ApprovalForAll(
35         address indexed owner,
36         address indexed operator,
37         bool approved
38     );
39     function balanceOf(address owner) external view returns (uint256 balance);
40     function ownerOf(uint256 tokenId) external view returns (address owner);
41     function safeTransferFrom(
42         address from,
43         address to,
44         uint256 tokenId
45     ) external;
46     function transferFrom(
47         address from,
48         address to,
49         uint256 tokenId
50     ) external;
51     function approve(address to, uint256 tokenId) external;
52     function getApproved(uint256 tokenId)
53         external
54         view
55         returns (address operator);
56     function setApprovalForAll(address operator, bool _approved) external;
57     function isApprovedForAll(address owner, address operator)
58         external
59         view
60         returns (bool);
61     function safeTransferFrom(
62         address from,
63         address to,
64         uint256 tokenId,
65         bytes calldata data
66     ) external;
67 }
68 
69 pragma solidity ^0.8.0;
70 interface IERC721Metadata is IERC721 {
71     function name() external view returns (string memory);
72     function symbol() external view returns (string memory);
73     function tokenURI(uint256 tokenId) external view returns (string memory);
74 }
75 
76 pragma solidity ^0.8.0;
77 interface IERC721Enumerable is IERC721 {
78     function totalSupply() external view returns (uint256);
79     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
80     function tokenByIndex(uint256 index) external view returns (uint256);
81 }
82 
83 pragma solidity ^0.8.0;
84 library Address {
85     function isContract(address account) internal view returns (bool) {
86 
87         return account.code.length > 0;
88     }
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(
91             address(this).balance >= amount,
92             "Address: insufficient balance"
93         );
94 
95         (bool success, ) = recipient.call{value: amount}("");
96         require(
97             success,
98             "Address: unable to send value, recipient may have reverted"
99         );
100     }
101     function functionCall(address target, bytes memory data)
102         internal
103         returns (bytes memory)
104     {
105         return functionCall(target, data, "Address: low-level call failed");
106     }
107     function functionCall(
108         address target,
109         bytes memory data,
110         string memory errorMessage
111     ) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, 0, errorMessage);
113     }
114     function functionCallWithValue(
115         address target,
116         bytes memory data,
117         uint256 value
118     ) internal returns (bytes memory) {
119         return
120             functionCallWithValue(
121                 target,
122                 data,
123                 value,
124                 "Address: low-level call with value failed"
125             );
126     }
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(
134             address(this).balance >= value,
135             "Address: insufficient balance for call"
136         );
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(
140             data
141         );
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144     function functionStaticCall(address target, bytes memory data)
145         internal
146         view
147         returns (bytes memory)
148     {
149         return
150             functionStaticCall(
151                 target,
152                 data,
153                 "Address: low-level static call failed"
154             );
155     }
156     function functionStaticCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166     function functionDelegateCall(address target, bytes memory data)
167         internal
168         returns (bytes memory)
169     {
170         return
171             functionDelegateCall(
172                 target,
173                 data,
174                 "Address: low-level delegate call failed"
175             );
176     }
177     function functionDelegateCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         require(isContract(target), "Address: delegate call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.delegatecall(data);
185         return verifyCallResult(success, returndata, errorMessage);
186     }
187     function verifyCallResult(
188         bool success,
189         bytes memory returndata,
190         string memory errorMessage
191     ) internal pure returns (bytes memory) {
192         if (success) {
193             return returndata;
194         } else {
195             if (returndata.length > 0) {
196 
197                 assembly {
198                     let returndata_size := mload(returndata)
199                     revert(add(32, returndata), returndata_size)
200                 }
201             } else {
202                 revert(errorMessage);
203             }
204         }
205     }
206 }
207 
208 pragma solidity ^0.8.0;
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
219 pragma solidity ^0.8.0;
220 abstract contract Ownable is Context {
221     address private _owner;
222 
223     event OwnershipTransferred(
224         address indexed previousOwner,
225         address indexed newOwner
226     );
227     constructor() {
228         _setOwner(_msgSender());
229     }
230     function owner() public view virtual returns (address) {
231         return _owner;
232     }
233     modifier onlyOwner() {
234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
235         _;
236     }
237     function renounceOwnership() public virtual onlyOwner {
238         _setOwner(address(0));
239     }
240     function transferOwnership(address newOwner) public virtual onlyOwner {
241         require(
242             newOwner != address(0),
243             "Ownable: new owner is the zero address"
244         );
245         _setOwner(newOwner);
246     }
247 
248     function _setOwner(address newOwner) private {
249         address oldOwner = _owner;
250         _owner = newOwner;
251         emit OwnershipTransferred(oldOwner, newOwner);
252     }
253 }
254 
255 pragma solidity ^0.8.0;
256 library Strings {
257     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
258     function toString(uint256 value) internal pure returns (string memory) {
259 
260         if (value == 0) {
261             return "0";
262         }
263         uint256 temp = value;
264         uint256 digits;
265         while (temp != 0) {
266             digits++;
267             temp /= 10;
268         }
269         bytes memory buffer = new bytes(digits);
270         while (value != 0) {
271             digits -= 1;
272             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
273             value /= 10;
274         }
275         return string(buffer);
276     }
277     function toHexString(uint256 value) internal pure returns (string memory) {
278         if (value == 0) {
279             return "0x00";
280         }
281         uint256 temp = value;
282         uint256 length = 0;
283         while (temp != 0) {
284             length++;
285             temp >>= 8;
286         }
287         return toHexString(value, length);
288     }
289     function toHexString(uint256 value, uint256 length)
290         internal
291         pure
292         returns (string memory)
293     {
294         bytes memory buffer = new bytes(2 * length + 2);
295         buffer[0] = "0";
296         buffer[1] = "x";
297         for (uint256 i = 2 * length + 1; i > 1; --i) {
298             buffer[i] = _HEX_SYMBOLS[value & 0xf];
299             value >>= 4;
300         }
301         require(value == 0, "Strings: hex length insufficient");
302         return string(buffer);
303     }
304 }
305 
306 pragma solidity ^0.8.0;
307 abstract contract ERC165 is IERC165 {
308     function supportsInterface(bytes4 interfaceId)
309         public
310         view
311         virtual
312         override
313         returns (bool)
314     {
315         return interfaceId == type(IERC165).interfaceId;
316     }
317 }
318 
319 pragma solidity ^0.8.0;
320 abstract contract ReentrancyGuard {
321     uint256 private constant _NOT_ENTERED = 1;
322     uint256 private constant _ENTERED = 2;
323 
324     uint256 private _status;
325 
326     constructor() {
327         _status = _NOT_ENTERED;
328     }
329     modifier nonReentrant() {
330         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
331         _status = _ENTERED;
332 
333         _;
334         _status = _NOT_ENTERED;
335     }
336 }
337 
338 pragma solidity ^0.8.0;
339 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
340     using Address for address;
341     using Strings for uint256;
342     string private _name;
343     string private _symbol;
344 
345     mapping(uint256 => address) private _owners;
346 
347     mapping(address => uint256) private _balances;
348 
349     mapping(uint256 => address) private _tokenApprovals;
350 
351     mapping(address => mapping(address => bool)) private _operatorApprovals;
352     constructor(string memory name_, string memory symbol_) {
353         _name = name_;
354         _symbol = symbol_;
355     }
356     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
357         return
358             interfaceId == type(IERC721).interfaceId ||
359             interfaceId == type(IERC721Metadata).interfaceId ||
360             super.supportsInterface(interfaceId);
361     }
362     function balanceOf(address owner) public view virtual override returns (uint256) {
363         require(owner != address(0), "ERC721: balance query for the zero address");
364         return _balances[owner];
365     }
366     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
367         address owner = _owners[tokenId];
368         require(owner != address(0), "ERC721: owner query for nonexistent token");
369         return owner;
370     }
371     function name() public view virtual override returns (string memory) {
372         return _name;
373     }
374     function symbol() public view virtual override returns (string memory) {
375         return _symbol;
376     }
377     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
378         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
379 
380         string memory baseURI = _baseURI();
381         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
382     }
383     function _baseURI() internal view virtual returns (string memory) {
384         return "";
385     }
386     function approve(address to, uint256 tokenId) public virtual override {
387         address owner = ERC721.ownerOf(tokenId);
388         require(to != owner, "ERC721: approval to current owner");
389 
390         require(
391             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
392             "ERC721: approve caller is not owner nor approved for all"
393         );
394 
395         _approve(to, tokenId);
396     }
397     function getApproved(uint256 tokenId) public view virtual override returns (address) {
398         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
399 
400         return _tokenApprovals[tokenId];
401     }
402     function setApprovalForAll(address operator, bool approved) public virtual override {
403         require(operator != _msgSender(), "ERC721: approve to caller");
404 
405         _operatorApprovals[_msgSender()][operator] = approved;
406         emit ApprovalForAll(_msgSender(), operator, approved);
407     }
408     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
409         return _operatorApprovals[owner][operator];
410     }
411     function transferFrom(
412         address from,
413         address to,
414         uint256 tokenId
415     ) public virtual override {
416         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
417 
418         _transfer(from, to, tokenId);
419     }
420     function safeTransferFrom(
421         address from,
422         address to,
423         uint256 tokenId
424     ) public virtual override {
425         safeTransferFrom(from, to, tokenId, "");
426     }
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId,
431         bytes memory _data
432     ) public virtual override {
433         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
434         _safeTransfer(from, to, tokenId, _data);
435     }
436     function _safeTransfer(
437         address from,
438         address to,
439         uint256 tokenId,
440         bytes memory _data
441     ) internal virtual {
442         _transfer(from, to, tokenId);
443         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
444     }
445     function _exists(uint256 tokenId) internal view virtual returns (bool) {
446         return _owners[tokenId] != address(0);
447     }
448     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
449         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
450         address owner = ERC721.ownerOf(tokenId);
451         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
452     }
453     function _safeMint(address to, uint256 tokenId) internal virtual {
454         _safeMint(to, tokenId, "");
455     }
456     function _safeMint(
457         address to,
458         uint256 tokenId,
459         bytes memory _data
460     ) internal virtual {
461         _mint(to, tokenId);
462         require(
463             _checkOnERC721Received(address(0), to, tokenId, _data),
464             "ERC721: transfer to non ERC721Receiver implementer"
465         );
466     }
467     function _mint(address to, uint256 tokenId) internal virtual {
468         require(to != address(0), "ERC721: mint to the zero address");
469         require(!_exists(tokenId), "ERC721: token already minted");
470 
471         _beforeTokenTransfer(address(0), to, tokenId);
472 
473         _balances[to] += 1;
474         _owners[tokenId] = to;
475 
476         emit Transfer(address(0), to, tokenId);
477     }
478     function _burn(uint256 tokenId) internal virtual {
479         address owner = ERC721.ownerOf(tokenId);
480 
481         _beforeTokenTransfer(owner, address(0), tokenId);
482 
483         _approve(address(0), tokenId);
484 
485         _balances[owner] -= 1;
486         delete _owners[tokenId];
487 
488         emit Transfer(owner, address(0), tokenId);
489     }
490     function _transfer(
491         address from,
492         address to,
493         uint256 tokenId
494     ) internal virtual {
495         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
496         require(to != address(0), "ERC721: transfer to the zero address");
497 
498         _beforeTokenTransfer(from, to, tokenId);
499 
500         _approve(address(0), tokenId);
501 
502         _balances[from] -= 1;
503         _balances[to] += 1;
504         _owners[tokenId] = to;
505 
506         emit Transfer(from, to, tokenId);
507     }
508     function _approve(address to, uint256 tokenId) internal virtual {
509         _tokenApprovals[tokenId] = to;
510         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
511     }
512     function _checkOnERC721Received(
513         address from,
514         address to,
515         uint256 tokenId,
516         bytes memory _data
517     ) private returns (bool) {
518         if (to.isContract()) {
519             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
520                 return retval == IERC721Receiver(to).onERC721Received.selector;
521             } catch (bytes memory reason) {
522                 if (reason.length == 0) {
523                     revert("ERC721: transfer to non ERC721Receiver implementer");
524                 } else {
525                     assembly {
526                         revert(add(32, reason), mload(reason))
527                     }
528                 }
529             }
530         } else {
531             return true;
532         }
533     }
534     function _beforeTokenTransfer(
535         address from,
536         address to,
537         uint256 tokenId
538     ) internal virtual {}
539 }
540 
541 pragma solidity ^0.8.0;
542 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
543     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
544 
545     mapping(uint256 => uint256) private _ownedTokensIndex;
546 
547     uint256[] private _allTokens;
548 
549     mapping(uint256 => uint256) private _allTokensIndex;
550     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
551         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
552     }
553     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
554         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
555         return _ownedTokens[owner][index];
556     }
557     function totalSupply() public view virtual override returns (uint256) {
558         return _allTokens.length;
559     }
560     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
561         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
562         return _allTokens[index];
563     }
564     function _beforeTokenTransfer(
565         address from,
566         address to,
567         uint256 tokenId
568     ) internal virtual override {
569         super._beforeTokenTransfer(from, to, tokenId);
570 
571         if (from == address(0)) {
572             _addTokenToAllTokensEnumeration(tokenId);
573         } else if (from != to) {
574             _removeTokenFromOwnerEnumeration(from, tokenId);
575         }
576         if (to == address(0)) {
577             _removeTokenFromAllTokensEnumeration(tokenId);
578         } else if (to != from) {
579             _addTokenToOwnerEnumeration(to, tokenId);
580         }
581     }
582     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
583         uint256 length = ERC721.balanceOf(to);
584         _ownedTokens[to][length] = tokenId;
585         _ownedTokensIndex[tokenId] = length;
586     }
587     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
588         _allTokensIndex[tokenId] = _allTokens.length;
589         _allTokens.push(tokenId);
590     }
591     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
592 
593         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
594         uint256 tokenIndex = _ownedTokensIndex[tokenId];
595 
596         if (tokenIndex != lastTokenIndex) {
597             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
598 
599             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
600             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
601         }
602 
603         delete _ownedTokensIndex[tokenId];
604         delete _ownedTokens[from][lastTokenIndex];
605     }
606     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
607 
608         uint256 lastTokenIndex = _allTokens.length - 1;
609         uint256 tokenIndex = _allTokensIndex[tokenId];
610 
611         uint256 lastTokenId = _allTokens[lastTokenIndex];
612 
613         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
614         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
615 
616         delete _allTokensIndex[tokenId];
617         _allTokens.pop();
618     }
619 }
620 
621 pragma solidity ^0.8.0;
622 abstract contract TrollTown {
623     function ownerOf(uint256 tokenId) public view virtual returns (address);
624 }
625 
626 pragma solidity ^0.8.0;
627 abstract contract TrollTownElixir {
628     function balanceOf(address account, uint256 id) public view virtual returns (uint256);
629     function burnElixirForAddress(uint256 typeId, address burnTokenAddress) external virtual;
630 }
631 
632 pragma solidity ^0.8.0;
633 contract TrollTownMutant is ERC721Enumerable, Ownable, ReentrancyGuard {
634 
635     TrollTown public immutable tt;
636     TrollTownElixir public immutable tte;
637 
638     uint256 public currentT2Id = 10000;
639     uint256 public currentT1Id = 0;
640 
641     uint256[40] mutateBitMap;
642 
643     bool public mutationActive;
644 
645     string private _baseTokenURI = "https://troll-town.wtf/ipfs/jsons/";
646 
647     event mutateTroll(address _from, uint256 _type, uint256 _id);
648 
649     constructor(string memory _NAME, string memory _SYMBOL, address ttAddress, address tteAddress) ERC721 (_NAME, _SYMBOL) {
650         tt = TrollTown(ttAddress);
651         tte = TrollTownElixir(tteAddress);
652     }
653 
654     modifier callerIsUser() {
655         require(tx.origin == msg.sender, "The caller is another contract");
656         _;
657     }
658 
659     function _baseURI() internal view virtual override returns (string memory) {
660         return _baseTokenURI;
661     }
662 
663     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
664         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
665         string memory _tokenURI = super.tokenURI(tokenId);
666         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
667     }
668 
669     function isMutated(uint256 tokenId) public view returns (bool) {
670         uint256 mutateWordIndex = tokenId / 256;
671         uint256 mutateBitIndex = tokenId % 256;
672         uint256 mutateWord = mutateBitMap[mutateWordIndex];
673         uint256 mask = (1 << mutateBitIndex);
674         return mutateWord & mask == mask;
675     }
676 
677     function _setMutate(uint256 tokenId) internal {
678         uint256 mutateWordIndex = tokenId / 256;
679         uint256 mutateBitIndex = tokenId % 256;
680         mutateBitMap[mutateWordIndex] = mutateBitMap[mutateWordIndex] | (1 << mutateBitIndex);
681     }
682     
683     function mint(uint256 elixirTypeId, uint256 trollId) external nonReentrant callerIsUser {
684         require(mutationActive, "MUTATION_IS_NOT_ACTIVE");
685         require(tt.ownerOf(trollId) == msg.sender, "MUST_OWN_THE_TROLL_YOU_ARE_ATTEMPTING_TO_MUTATE");
686         require(tte.balanceOf(msg.sender, elixirTypeId) > 0, "MUST_OWN_AT_LEAST_ONE_OF_THIS_ELIXIR_TYPE_TO_MUTATE");
687         require(!isMutated(trollId), "ALREADY_MUTATED");
688         uint256 mutantId;
689         if (elixirTypeId == 1) {
690             mutantId = currentT2Id;
691             currentT2Id++;
692         } else if (elixirTypeId == 0) {
693             mutantId = currentT1Id;
694             currentT1Id++;
695         }
696         _setMutate(trollId);
697         tte.burnElixirForAddress(elixirTypeId, msg.sender);
698         _safeMint(msg.sender, mutantId);
699     }
700 
701     function flipMutate() external onlyOwner {
702         mutationActive = !mutationActive;
703     }
704 
705     function setBaseURI(string calldata baseURI) external onlyOwner {
706         _baseTokenURI = baseURI;
707     }
708 
709     function withdraw() external onlyOwner {
710         payable(msg.sender).transfer(address(this).balance);
711     }
712 }