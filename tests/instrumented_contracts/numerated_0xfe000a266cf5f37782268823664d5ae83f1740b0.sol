1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.17;
3 
4 contract ReentrancyGuard {
5   bool private rentrancy_lock = false;
6 
7   modifier nonReentrant() {
8     require(!rentrancy_lock);
9     rentrancy_lock = true;
10     _;
11     rentrancy_lock = false;
12   }
13 }
14 
15 library Base64 {
16     bytes internal constant TABLE =
17         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
18 
19     /// @notice Encodes some bytes to the base64 representation
20     function encode(bytes memory data) internal pure returns (string memory) {
21         uint256 len = data.length;
22         if (len == 0) return "";
23 
24         // multiply by 4/3 rounded up
25         uint256 encodedLen = 4 * ((len + 2) / 3);
26 
27         // Add some extra buffer at the end
28         bytes memory result = new bytes(encodedLen + 32);
29 
30         bytes memory table = TABLE;
31 
32         assembly {
33             let tablePtr := add(table, 1)
34             let resultPtr := add(result, 32)
35 
36             for {
37                 let i := 0
38             } lt(i, len) {
39 
40             } {
41                 i := add(i, 3)
42                 let input := and(mload(add(data, i)), 0xffffff)
43 
44                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
45                 out := shl(8, out)
46                 out := add(
47                     out,
48                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
49                 )
50                 out := shl(8, out)
51                 out := add(
52                     out,
53                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
54                 )
55                 out := shl(8, out)
56                 out := add(
57                     out,
58                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
59                 )
60                 out := shl(224, out)
61 
62                 mstore(resultPtr, out)
63 
64                 resultPtr := add(resultPtr, 4)
65             }
66 
67             switch mod(len, 3)
68             case 1 {
69                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
70             }
71             case 2 {
72                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
73             }
74 
75             mstore(result, encodedLen)
76         }
77 
78         return string(result);
79     }
80 }
81 
82 interface IERC165 {
83     function supportsInterface(bytes4 interfaceId) external view returns (bool);
84 }
85 
86 interface IERC721Receiver {
87     function onERC721Received(
88         address operator,
89         address from,
90         uint256 tokenId,
91         bytes calldata data
92     ) external returns (bytes4);
93 }
94 
95 interface IERC721 is IERC165 {
96     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
97     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
98     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
99     function balanceOf(address owner) external view returns (uint256 balance);
100     function ownerOf(uint256 tokenId) external view returns (address owner);
101 
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId,
106         bytes calldata data
107     ) external;
108 
109     function safeTransferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     function transferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     function approve(address to, uint256 tokenId) external;
122     function setApprovalForAll(address operator, bool _approved) external;
123     function getApproved(uint256 tokenId) external view returns (address operator);
124     function isApprovedForAll(address owner, address operator) external view returns (bool);
125 }
126 
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 }
132 
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     constructor() {
139         _transferOwnership(_msgSender());
140     }
141 
142     modifier onlyOwner() {
143         _checkOwner();
144         _;
145     }
146 
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     function _checkOwner() internal view virtual {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153     }
154 
155     function renounceOwnership() external virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     function transferOwnership(address newOwner) external virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _transferOwnership(newOwner);
162     }
163 
164     function _transferOwnership(address newOwner) internal virtual {
165         address oldOwner = _owner;
166         _owner = newOwner;
167         emit OwnershipTransferred(oldOwner, newOwner);
168     }
169 }
170 
171 interface IERC721Metadata is IERC721 {
172     function name() external view returns (string memory);
173     function symbol() external view returns (string memory);
174     function tokenURI(uint256 tokenId) external view returns (string memory);
175 }
176 
177 abstract contract ERC165 is IERC165 {
178     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
179         return interfaceId == type(IERC165).interfaceId;
180     }
181 }
182 library Address {
183     function isContract(address account) internal view returns (bool) {
184         return account.code.length > 0;
185     }
186 }
187 
188 library Math {
189     enum Rounding {
190         Down, // Toward negative infinity
191         Up, // Toward infinity
192         Zero // Toward zero
193     }
194  
195     function log10(uint256 value) internal pure returns (uint256) {
196         uint256 result = 0;
197         unchecked {
198             if (value >= 10**64) {
199                 value /= 10**64;
200                 result += 64;
201             }
202             if (value >= 10**32) {
203                 value /= 10**32;
204                 result += 32;
205             }
206             if (value >= 10**16) {
207                 value /= 10**16;
208                 result += 16;
209             }
210             if (value >= 10**8) {
211                 value /= 10**8;
212                 result += 8;
213             }
214             if (value >= 10**4) {
215                 value /= 10**4;
216                 result += 4;
217             }
218             if (value >= 10**2) {
219                 value /= 10**2;
220                 result += 2;
221             }
222             if (value >= 10**1) {
223                 result += 1;
224             }
225         }
226         return result;
227     }
228 
229     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
230         unchecked {
231             uint256 result = log10(value);
232             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
233         }
234     }
235 
236     function log256(uint256 value) internal pure returns (uint256) {
237         uint256 result = 0;
238         unchecked {
239             if (value >> 128 > 0) {
240                 value >>= 128;
241                 result += 16;
242             }
243             if (value >> 64 > 0) {
244                 value >>= 64;
245                 result += 8;
246             }
247             if (value >> 32 > 0) {
248                 value >>= 32;
249                 result += 4;
250             }
251             if (value >> 16 > 0) {
252                 value >>= 16;
253                 result += 2;
254             }
255             if (value >> 8 > 0) {
256                 result += 1;
257             }
258         }
259         return result;
260     }
261 
262     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
263         unchecked {
264             uint256 result = log256(value);
265             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
266         }
267     }
268 }
269 
270 library Strings {
271     bytes16 private constant _SYMBOLS = "0123456789abcdef";
272     uint8 private constant _ADDRESS_LENGTH = 20;
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
276      */
277     function toString(uint256 value) internal pure returns (string memory) {
278         unchecked {
279             uint256 length = Math.log10(value) + 1;
280             string memory buffer = new string(length);
281             uint256 ptr;
282             /// @solidity memory-safe-assembly
283             assembly {
284                 ptr := add(buffer, add(32, length))
285             }
286             while (true) {
287                 ptr--;
288                 /// @solidity memory-safe-assembly
289                 assembly {
290                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
291                 }
292                 value /= 10;
293                 if (value == 0) break;
294             }
295             return buffer;
296         }
297     }
298 }
299 
300 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
301     using Address for address;
302     using Strings for uint256;
303 
304     string private _name;
305     string private _symbol;
306 
307     // Mapping from token ID to owner address
308     mapping(uint256 => address) private _owners;
309     mapping(address => uint256) private _balances;
310     mapping(uint256 => address) private _tokenApprovals;
311     mapping(address => mapping(address => bool)) private _operatorApprovals;
312 
313     constructor(string memory name_, string memory symbol_) {
314         _name = name_;
315         _symbol = symbol_;
316     }
317 
318     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
319         return
320             interfaceId == type(IERC721).interfaceId ||
321             interfaceId == type(IERC721Metadata).interfaceId ||
322             super.supportsInterface(interfaceId);
323     }
324 
325     function balanceOf(address owner) external view virtual override returns (uint256) {
326         require(owner != address(0), "ERC721: address zero is not a valid owner");
327         return _balances[owner];
328     }
329 
330     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
331         address owner = _ownerOf(tokenId);
332         require(owner != address(0), "ERC721: invalid token ID");
333         return owner;
334     }
335 
336     function name() external view virtual override returns (string memory) {
337         return _name;
338     }
339 
340     function symbol() external view virtual override returns (string memory) {
341         return _symbol;
342     }
343 
344     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
345         _requireMinted(tokenId);
346         string memory baseURI = _baseURI();
347         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
348     }
349 
350     function _baseURI() internal view virtual returns (string memory) {
351         return "";
352     }
353 
354     function approve(address to, uint256 tokenId) external virtual override {
355         address owner = ERC721.ownerOf(tokenId);
356         require(to != owner, "ERC721: approval to current owner");
357 
358         require(
359             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
360             "ERC721: approve caller is not token owner or approved for all"
361         );
362 
363         _approve(to, tokenId);
364     }
365 
366     function getApproved(uint256 tokenId) public view virtual override returns (address) {
367         _requireMinted(tokenId);
368 
369         return _tokenApprovals[tokenId];
370     }
371 
372     function setApprovalForAll(address operator, bool approved) external virtual override {
373         _setApprovalForAll(_msgSender(), operator, approved);
374     }
375 
376     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
377         return _operatorApprovals[owner][operator];
378     }
379 
380     function transferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) external virtual override {
385         //solhint-disable-next-line max-line-length
386         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
387 
388         _transfer(from, to, tokenId);
389     }
390 
391     function safeTransferFrom(
392         address from,
393         address to,
394         uint256 tokenId
395     ) external virtual override {
396         safeTransferFrom(from, to, tokenId, "");
397     }
398 
399     function safeTransferFrom(
400         address from,
401         address to,
402         uint256 tokenId,
403         bytes memory data
404     ) public virtual override {
405         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
406         _safeTransfer(from, to, tokenId, data);
407     }
408 
409     function _safeTransfer(
410         address from,
411         address to,
412         uint256 tokenId,
413         bytes memory data
414     ) internal virtual {
415         _transfer(from, to, tokenId);
416         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
417     }
418 
419     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
420         return _owners[tokenId];
421     }
422 
423     function _exists(uint256 tokenId) internal view virtual returns (bool) {
424         return _ownerOf(tokenId) != address(0);
425     }
426 
427     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
428         address owner = ERC721.ownerOf(tokenId);
429         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
430     }
431 
432     function _safeMint(address to, uint256 tokenId) internal virtual {
433         _safeMint(to, tokenId, "");
434     }
435 
436     function _safeMint(
437         address to,
438         uint256 tokenId,
439         bytes memory data
440     ) internal virtual {
441         _mint(to, tokenId);
442         require(
443             _checkOnERC721Received(address(0), to, tokenId, data),
444             "ERC721: transfer to non ERC721Receiver implementer"
445         );
446     }
447 
448     function _mint(address to, uint256 tokenId) internal virtual {
449         require(to != address(0), "ERC721: mint to the zero address");
450         require(!_exists(tokenId), "ERC721: token already minted");
451 
452         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
453         require(!_exists(tokenId), "ERC721: token already minted");
454 
455         unchecked {
456             // Will not overflow unless all 2**256 token ids are minted to the same owner.
457             // Given that tokens are minted one by one, it is impossible in practice that
458             // this ever happens. Might change if we allow batch minting.
459             // The ERC fails to describe this case.
460             _balances[to] += 1;
461         }
462 
463         _owners[tokenId] = to;
464 
465         emit Transfer(address(0), to, tokenId);
466     }
467 
468     function _transfer(
469         address from,
470         address to,
471         uint256 tokenId
472     ) internal virtual {
473         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
474         require(to != address(0), "ERC721: transfer to the zero address");
475 
476         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
477         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
478 
479         // Clear approvals from the previous owner
480         delete _tokenApprovals[tokenId];
481 
482         unchecked {
483             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
484             // `from`'s balance is the number of token held, which is at least one before the current
485             // transfer.
486             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
487             // all 2**256 token ids to be minted, which in practice is impossible.
488             _balances[from] -= 1;
489             _balances[to] += 1;
490         }
491         _owners[tokenId] = to;
492 
493         emit Transfer(from, to, tokenId);
494     }
495 
496     function _approve(address to, uint256 tokenId) internal virtual {
497         _tokenApprovals[tokenId] = to;
498         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
499     }
500 
501     function _setApprovalForAll(
502         address owner,
503         address operator,
504         bool approved
505     ) internal virtual {
506         require(owner != operator, "ERC721: approve to caller");
507         _operatorApprovals[owner][operator] = approved;
508         emit ApprovalForAll(owner, operator, approved);
509     }
510 
511     function _requireMinted(uint256 tokenId) internal view virtual {
512         require(_exists(tokenId), "ERC721: invalid token ID");
513     }
514 
515     /**
516      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
517      * The call is not executed if the target address is not a contract.
518      *
519      * @param from address representing the previous owner of the given token ID
520      * @param to target address that will receive the tokens
521      * @param tokenId uint256 ID of the token to be transferred
522      * @param data bytes optional data to send along with the call
523      * @return bool whether the call correctly returned the expected magic value
524      */
525     function _checkOnERC721Received(
526         address from,
527         address to,
528         uint256 tokenId,
529         bytes memory data
530     ) private returns (bool) {
531         if (to.isContract()) {
532             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
533                 return retval == IERC721Receiver.onERC721Received.selector;
534             } catch (bytes memory reason) {
535                 if (reason.length == 0) {
536                     revert("ERC721: transfer to non ERC721Receiver implementer");
537                 } else {
538                     /// @solidity memory-safe-assembly
539                     assembly {
540                         revert(add(32, reason), mload(reason))
541                     }
542                 }
543             }
544         } else {
545             return true;
546         }
547     }
548 }
549 
550  contract WizScoreNFT is ERC721, Ownable, ReentrancyGuard {
551     event WizScoreLocked(uint indexed tokenId, uint indexed lockedInScore);
552 
553     bool internal publicMintOpen = false;
554     uint internal constant totalPossible = 1000;
555     uint internal constant wizScorePrice = 10000000000000000; // 0.01 ETH
556     uint internal totalMinted = 0;
557     string internal htmlPageURI = ""; 
558     string internal loadingGifURI = "ipfs://QmSeGiTaQrhiazvhmnEv3Tdamg3fRuKK4sHPRayKfc464x";
559     string internal description = "To play the Cootie Catcher, select a color and number to reveal your fortune. If you want to go on the wizard adventure, go to the smart contract, connect wallet and use claimWizScore with 0.01 eth. This will lock you a WizScore. Complete this task and you will be rewarded with some wizard magic. Each Cootie Catcher can only be locked once. Safe travels my friend.";
560 
561     string internal metaName = "Paper Handed Cootie Catchers";
562 
563     mapping(uint => uint) internal tokenIdToWizScore;
564 
565     constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
566     }
567 
568     receive() external payable {
569         require(publicMintOpen, "Public is not open yet.");
570         unchecked {
571             uint newTotal = totalMinted + 1;
572             require(newTotal <= totalPossible, "SOLD OUT");
573             totalMinted = newTotal;
574             _mint(msg.sender, newTotal);
575         }
576     }
577 
578     function airdrop(address[] calldata users) external onlyOwner {
579         unchecked {
580             uint count = users.length;
581             for(uint i = 0; i < count; i++) {
582                 uint newTotal = totalMinted + 1;
583                 require(newTotal <= totalPossible, "SOLD OUT");
584                 totalMinted = newTotal;
585                 _mint(users[i], newTotal);
586             }
587         }
588     }
589 
590     function claimWizScore(uint tokenId) payable external nonReentrant {
591        require(msg.value >= wizScorePrice, "It costs at least 0.01 to lock in a wizscore"); // allow for tips
592        require(tokenIdToWizScore[tokenId] == 0, "This already has a wizscore");
593        uint randomHash = uint(keccak256(abi.encodePacked(block.number, block.difficulty, block.timestamp, tokenId)));
594        tokenIdToWizScore[tokenId] = (randomHash % totalPossible) + 1;
595 
596        emit WizScoreLocked(tokenId, tokenIdToWizScore[tokenId]);
597     }
598 
599     function zCollectETH() external onlyOwner {
600         (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
601         require(sent, "Failed to send Ether");
602     }
603 
604     function totalSupply() external view virtual returns (uint256) {
605         return totalMinted;
606     }
607 
608     function setHTMLURI(string calldata _htmlPageURI) external onlyOwner {
609         htmlPageURI = _htmlPageURI;
610     }
611 
612     function setGIFURI(string calldata _loadingGifURI) external onlyOwner {
613         loadingGifURI = _loadingGifURI;
614     }
615 
616     function setMetaName(string calldata _name) external onlyOwner {
617         metaName = _name;
618     }
619 
620     function togglePublic() external onlyOwner {
621         publicMintOpen = !publicMintOpen;
622     }
623 
624     function setDesc(string calldata _description) external onlyOwner {
625         description = _description;
626     }
627 
628     function _toString(uint256 value) internal pure returns (string memory) {
629         // Inspired by OraclizeAPI's implementation - MIT licence
630         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
631         if (value == 0) {
632             return "0";
633         }
634         uint256 temp = value;
635         uint256 digits;
636         while (temp != 0) {
637             digits++;
638             temp /= 10;
639         }
640         bytes memory buffer = new bytes(digits);
641         while (value != 0) {
642             digits -= 1;
643             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
644             value /= 10;
645         }
646         return string(buffer);
647     }
648 
649     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
650         _requireMinted(tokenId);
651         uint foundScore = tokenIdToWizScore[tokenId];
652         string memory json = Base64.encode(
653             bytes(
654                 string(
655                     abi.encodePacked(
656                         '{"name": "',
657                         metaName,
658                         " #",
659                         _toString(tokenId),
660                         '", "description": "',
661                         string(description),
662                         '", "animation_url": "',
663                         string(htmlPageURI),
664                         _toString(tokenId),
665                         '", "image": "',
666                         string(loadingGifURI),
667                         '", "attributes":[{ "trait_type": "WizScore", "value": ',
668                         foundScore == 0 ? '"UNCLAIMED"' : _toString(foundScore),
669                         " }] }"
670                     )
671                 )
672             )
673         );
674         return string(abi.encodePacked("data:application/json;base64,", json));
675     }
676 
677     function wizScoreForID(uint tokenId) external view returns(uint) {
678         return tokenIdToWizScore[tokenId];
679     }
680  }