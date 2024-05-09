1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC165 {
6     
7     function supportsInterface(bytes4 interfaceId) external view returns (bool);
8 }
9 
10 interface IERC721 is IERC165 {
11    
12     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
13     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
14     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
15 
16     function approve(address to, uint256 tokenId) external;
17     function getApproved(uint256 tokenId) external view returns (address operator);
18     function setApprovalForAll(address operator, bool _approved) external;
19     function isApprovedForAll(address owner, address operator) external view returns (bool);
20 }
21 
22 
23 interface IERC721Metadata is IERC721 {
24     
25     function name() external view returns (string memory);
26     function symbol() external view returns (string memory);
27     function tokenURI(uint256 tokenId) external view returns (string memory);
28 }
29 
30 
31 interface IDivineAnarchyToken is IERC721, IERC721Metadata {
32 
33     function getTokenClass(uint256 _id) external view returns(uint256);
34     function getTokenClassSupplyCap(uint256 _classId) external view returns(uint256);
35     function getTokenClassCurrentSupply(uint256 _classId) external view returns(uint256);
36     function getTokenClassVotingPower(uint256 _classId) external view returns(uint256);
37     function getTokensMintedAtPresale(address account) external view returns(uint256);
38     function isTokenClass(uint256 _id) external pure returns(bool);
39     function isTokenClassMintable(uint256 _id) external pure returns(bool);
40     function isAscensionApple(uint256 _id) external pure returns(bool);
41     function isBadApple(uint256 _id) external pure returns(bool);
42     function consumedAscensionApples(address account) external view returns(uint256);
43     function airdropApples(uint256 amount, uint256 appleClass, address[] memory accounts) external;
44 }
45 
46 
47 interface IERC721Enumerable is IERC721 {
48   
49     function totalSupply() external view returns (uint256);
50     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
51     function tokenByIndex(uint256 index) external view returns (uint256);
52 }
53 
54 interface IERC721Receiver {
55     
56     function onERC721Received(
57         address operator,
58         address from,
59         uint256 tokenId,
60         bytes calldata data
61     ) external returns (bytes4);
62 }
63 
64 abstract contract ERC165 is IERC165 {
65   
66     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
67         return interfaceId == type(IERC165).interfaceId;
68     }
69 }
70 
71 abstract contract Context {
72     function _msgSender() internal view virtual returns (address) {
73         return msg.sender;
74     }
75 }
76 
77 abstract contract Pausable is Context {
78     
79     event Paused(address account);
80     event Unpaused(address account);
81     bool private _paused;
82 
83     constructor() {
84         _paused = false;
85     }
86 
87     
88     function paused() public view virtual returns (bool) {
89         return _paused;
90     }
91 
92     modifier whenNotPaused() {
93         require(!paused(), "Pausable: paused");
94         _;
95     }
96 
97     modifier whenPaused() {
98         require(paused(), "Pausable: not paused");
99         _;
100     }
101 
102     function _pause() internal virtual whenNotPaused {
103         _paused = true;
104         emit Paused(_msgSender());
105     }
106 
107     function _unpause() internal virtual whenPaused {
108         _paused = false;
109         emit Unpaused(_msgSender());
110     }
111 }
112 
113 library Strings {
114     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
115 
116     function toString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0";
119         }
120         uint256 temp = value;
121         uint256 digits;
122         while (temp != 0) {
123             digits++;
124             temp /= 10;
125         }
126         bytes memory buffer = new bytes(digits);
127         while (value != 0) {
128             digits -= 1;
129             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
130             value /= 10;
131         }
132         return string(buffer);
133     }
134 
135    
136     function toHexString(uint256 value) internal pure returns (string memory) {
137         if (value == 0) {
138             return "0x00";
139         }
140         uint256 temp = value;
141         uint256 length = 0;
142         while (temp != 0) {
143             length++;
144             temp >>= 8;
145         }
146         return toHexString(value, length);
147     }
148 
149     
150     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
151         bytes memory buffer = new bytes(2 * length + 2);
152         buffer[0] = "0";
153         buffer[1] = "x";
154         for (uint256 i = 2 * length + 1; i > 1; --i) {
155             buffer[i] = _HEX_SYMBOLS[value & 0xf];
156             value >>= 4;
157         }
158         require(value == 0, "Strings: hex length insufficient");
159         return string(buffer);
160     }
161 }
162 
163 library Address {
164     
165     function isContract(address account) internal view returns (bool) {
166         uint256 size;
167         assembly {
168             size := extcodesize(account)
169         }
170         return size > 0;
171     }
172 }
173 
174 
175 abstract contract Ownable is Context {
176     address private _owner;
177 
178     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
179     constructor() {
180         _transferOwnership(_msgSender());
181     }
182     
183     function owner() public view virtual returns (address) {
184         return _owner;
185     }
186 
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191     
192     function renounceOwnership() public virtual onlyOwner {
193         _transferOwnership(address(0));
194     }
195    
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         require(newOwner != address(0), "Ownable: new owner is the zero address");
198         _transferOwnership(newOwner);
199     }
200     
201     function _transferOwnership(address newOwner) internal virtual {
202         address oldOwner = _owner;
203         _owner = newOwner;
204         emit OwnershipTransferred(oldOwner, newOwner);
205     }
206 }
207 
208 
209 abstract contract ReentrancyGuard {
210     uint256 private constant _NOT_ENTERED = 1;
211     uint256 private constant _ENTERED = 2;
212     uint256 private _status;
213     constructor() {
214         _status = _NOT_ENTERED;
215     }
216     modifier nonReentrant() {
217         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
218         _status = _ENTERED;
219         _;
220         _status = _NOT_ENTERED;
221     }
222 }
223 
224 library MerkleProof {
225     
226     function verify(
227         bytes32[] memory proof,
228         bytes32 root,
229         bytes32 leaf
230     ) internal pure returns (bool) {
231         return processProof(proof, leaf) == root;
232     }
233 
234     
235     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
236         bytes32 computedHash = leaf;
237         for (uint256 i = 0; i < proof.length; i++) {
238             bytes32 proofElement = proof[i];
239             if (computedHash <= proofElement) {
240                 // Hash(current computed hash + current element of the proof)
241                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
242             } else {
243                 // Hash(current element of the proof + current computed hash)
244                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
245             }
246         }
247         return computedHash;
248     }
249 }
250 
251 interface IOracle {
252 
253     function getRandomNumbers() external returns(uint256[][] memory);
254     function wait() external pure returns(bool);
255 }
256 
257 interface IAdminWallets {
258 
259     function getOwnerWallet() external pure returns(address);
260     function getDiversityWallet() external pure returns(address);
261     function getAssetBenderWallet() external pure returns(address);
262     function getMarketingWallet() external pure returns(address);
263     function getDivineTreasuryWallet() external pure returns(address);
264 }
265 contract DivineAnarchyToken is IDivineAnarchyToken, ERC165, Ownable, Pausable, ReentrancyGuard {
266 
267     using Address for address;
268     using Strings for string;
269 
270     // Contract variables.
271     IAdminWallets public adminWallets;
272     IOracle public oracle;
273 
274     string private _baseURI;
275     string private _name;
276     string private _symbol;
277 
278     uint256 public constant THE_UNKNOWN = 0;
279     uint256 public constant KING = 1;
280     uint256 public constant ADAM_EVE = 2;
281     uint256 public constant HUMAN_HERO = 3;
282     uint256 public constant HUMAN_NEMESIS = 4; 
283     uint256 public constant ASCENSION_APPLE = 5;
284     uint256 public constant BAD_APPLE = 6;
285 
286     mapping(uint256 => uint256) private _tokenClass;
287     mapping(uint256 => uint256) private _tokenClassSupplyCap;
288     mapping(uint256 => uint256) private _tokenClassSupplyCurrent;
289     mapping(uint256 => uint256) private _tokenClassVotingPower;
290 
291     uint256 private _mintedToTreasury;
292     uint256 public  MAX_MINTED_TO_TREASURY = 270; 
293     bool private _mintedToTreasuryHasFinished = false;
294 
295     uint256 private constant MAX_TOKENS_MINTED_BY_ADDRESS_PRESALE = 3;
296     mapping(address => uint256) private _tokensMintedByAddressAtPresale;
297 
298     uint256 public MAX_TOKENS_MINTED_BY_ADDRESS = 4;
299     mapping(address => uint256) private _tokensMintedByAddress;
300 
301     uint256 private _initAscensionApple = 10011;
302     uint256 private _initBadApple = 13011;
303     mapping(address => uint256) private _consumedAscensionApples;
304 
305     uint256 public  TOKEN_UNIT_PRICE = 0.09 ether;
306     
307     bytes32 public root = 0x71eb2b2e3c82409bb024f8b681245d3eea25dcfd0dc7bbe701ee18cf1e8ecbb1;
308     bool isPresaleActive = true;
309 
310     mapping(uint256 => address) private _owners;
311     mapping(address => uint256) private _balances;
312 
313     mapping(uint256 => address) private _tokenApprovals;
314     mapping(address => mapping(address => bool)) private _operatorApprovals;
315     
316     // Mapping from owner to list of owned token IDs
317     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
318 
319     // Mapping from token ID to index of the owner tokens list
320     mapping(uint256 => uint256) private _ownedTokensIndex;
321 
322     // Array with all token ids, used for enumeration
323     uint256[] private _allTokens;
324 
325     // Mapping from token id to position in the allTokens array
326     mapping(uint256 => uint256) private _allTokensIndex;
327     
328     bool public toRescue;
329     bool public oracleForced;
330     
331     event oracleRescued(uint256[][] _tokens, uint256 timestamp, address receiver);
332     event val(uint256[][] _tokens);
333 
334     // Contract constructor
335     constructor (string memory name_, string memory symbol_, string memory baseURI_, address _adminwallets, address _oracle) {
336         _name = name_;
337         _symbol = symbol_;
338         _baseURI = baseURI_;
339 
340         adminWallets = IAdminWallets(_adminwallets);
341         oracle = IOracle(_oracle);
342 
343         _tokenClassSupplyCap[THE_UNKNOWN] = 1;
344         _tokenClassSupplyCap[KING] = 8;
345         _tokenClassSupplyCap[ADAM_EVE] = 2;
346         _tokenClassSupplyCap[HUMAN_HERO] = 5000;
347         _tokenClassSupplyCap[HUMAN_NEMESIS] = 5000; 
348         _tokenClassSupplyCap[ASCENSION_APPLE] = 3000;
349         _tokenClassSupplyCap[BAD_APPLE] = 1500;
350 
351         _tokenClassVotingPower[KING] = 2000;
352         _tokenClassVotingPower[ADAM_EVE] = 1000;
353         _tokenClassVotingPower[HUMAN_HERO] = 1;
354         _tokenClassVotingPower[HUMAN_NEMESIS] = 1;
355         
356         _beforeTokenTransfer(address(0), adminWallets.getDivineTreasuryWallet(), 0);
357         _balances[adminWallets.getDivineTreasuryWallet()] += 1;
358         _owners[0] = adminWallets.getDivineTreasuryWallet();
359         _tokenClass[0] = THE_UNKNOWN;
360         _tokenClassSupplyCurrent[THE_UNKNOWN] = 1;
361         
362         _beforeTokenTransfer(address(0), adminWallets.getDiversityWallet(), 1);
363         _beforeTokenTransfer(address(0), adminWallets.getAssetBenderWallet(), 2);
364         _beforeTokenTransfer(address(0), adminWallets.getMarketingWallet(), 3);
365 
366         // Minting three kings for Diversity, AssetBender and Marketing.
367         _balances[adminWallets.getDiversityWallet()] += 1;
368         _balances[adminWallets.getAssetBenderWallet()] += 1;
369         _balances[adminWallets.getMarketingWallet()] += 1;
370 
371         _owners[1] = adminWallets.getDiversityWallet();
372         _owners[2] = adminWallets.getAssetBenderWallet();
373         _owners[3] = adminWallets.getMarketingWallet();
374         _owners[4] = adminWallets.getMarketingWallet();
375 
376         for(uint256 i = 1; i <= 5; i++) {
377             _tokenClass[i] = KING;
378         }
379  
380         _tokenClassSupplyCurrent[KING] = 3;
381     }
382 
383 
384     // Contract functions.
385     function name() external view override returns (string memory) {
386         return _name;
387     }
388 
389     function symbol() external view override returns (string memory) {
390         return _symbol;
391     }
392 
393     function setBaseURI(string memory baseURI_) external onlyOwner {
394         _baseURI = baseURI_;
395     }
396 
397     function tokenURI(uint256 tokenId) external view override returns (string memory) {
398         require(exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
399 
400         string memory baseURI = _baseURI;
401         return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
402     }
403 
404     function getAdminWalletsAddress() public view returns(address) {
405         return address(adminWallets);
406     }
407 
408     function getOracleAddress() public view returns(address) {
409         return address(oracle);
410     }
411 
412     function getTokenClass(uint256 _id) external view override returns(uint256) {
413         return _tokenClass[_id];
414     }
415 
416     function setTokenClass(uint _id) public pure returns(uint256) {
417         // This can be erased if not necessary.
418         if (_id == 0) { 
419             return THE_UNKNOWN;
420         } else if (_id >= 1 && _id <= 8) {
421             return KING;
422         } else if (_id == 9 && _id == 10) {
423             return ADAM_EVE;
424         } else if (_id >= 11 && _id <= 5010) {
425             return HUMAN_HERO;
426         } else if (_id >= 5011 && _id <= 10010) {
427             return HUMAN_NEMESIS;
428         } else if (_id >= 10011 && _id <= 13010) {
429             return ASCENSION_APPLE;
430         } else if (_id >= 13011 && _id <= 14510) {
431             return BAD_APPLE;
432         } else {
433             revert('This ID does not belong to a valid token class');
434         }
435     }
436 
437     function getTokenClassSupplyCap(uint256 _classId) external view override returns(uint256) {
438         return _tokenClassSupplyCap[_classId];
439     }
440 
441     function getTokenClassCurrentSupply(uint256 _classId) external view override returns(uint256) {
442         return _tokenClassSupplyCurrent[_classId];
443     }
444 
445     function getTokenClassVotingPower(uint256 _classId) external view override returns(uint256) {
446         return _tokenClassVotingPower[_classId];
447     }
448 
449     function getTokensMintedAtPresale(address account) external view override returns(uint256) {
450         return _tokensMintedByAddressAtPresale[account];
451     }
452 
453     function isTokenClass(uint256 _id) public pure override returns(bool) {
454         return (_id >= 0 && _id <= 14510);
455     }
456 
457     function isTokenClassMintable(uint256 _id) public pure override returns(bool) {
458         return (_id >= 0 && _id <= 10010);
459     }
460 
461     function isAscensionApple(uint256 _id) public pure override returns(bool) {
462         return (_id >= 10011 && _id <= 13010);
463     }
464 
465     function isBadApple(uint256 _id) public pure override returns(bool) {
466         return (_id >= 13011 && _id <= 14510);
467     }
468 
469     function balanceOf(address account) public view returns(uint256) {
470         return _balances[account];
471     }
472 
473     function ownerOf(uint256 _id) public view returns(address) {
474         return _owners[_id];
475     }
476 
477     function consumedAscensionApples(address account) public view override returns(uint256) {
478         return _consumedAscensionApples[account];
479     }
480 
481     // Functions to comply with ERC721.
482     function approve(address to, uint256 tokenId) external override {
483         address owner = ownerOf(tokenId);
484         require(to != owner, "ERC721: approval to current owner");
485 
486         require(
487             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
488             "ERC721: approve caller is not owner nor approved for all"
489         );
490 
491         _tokenApprovals[tokenId] = to;
492         emit Approval(ownerOf(tokenId), to, tokenId);
493     }
494 
495     function getApproved(uint256 tokenId) public view override returns (address operator) {
496         require(exists(tokenId), "ERC721: approved query for nonexistent token");
497 
498         return _tokenApprovals[tokenId];
499     }
500 
501     function setApprovalForAll(address operator, bool approved) external override {
502         require(_msgSender() != operator, "Error: setting approval status for self");
503 
504         _operatorApprovals[_msgSender()][operator] = approved;
505         emit ApprovalForAll(_msgSender(), operator, approved);
506     }
507 
508     function isApprovedForAll(address account, address operator) public view override returns (bool) {
509         return _operatorApprovals[account][operator];
510     }
511 
512     function getMintedToTreasuryFinished() public view returns(bool) {
513         return _mintedToTreasuryHasFinished;
514     }
515     
516     // Minting & airdropping.
517     function airdropToTreasury(uint256[][] memory treasuryRandom) external onlyOwner {
518         address divineTreasuryWallet = adminWallets.getDivineTreasuryWallet();
519         require(!paused(), "Error: token transfer while paused");
520         uint256[] memory tokenIds = treasuryRandom[0];
521         uint256[] memory classIds = treasuryRandom[1];
522         require(classIds.length == tokenIds.length);
523         uint256 amount = tokenIds.length;
524         require(_mintedToTreasury + amount <= MAX_MINTED_TO_TREASURY, 'Error: you are exceeding the max airdrop amount to Treasury');
525         for (uint256 i = 0; i < tokenIds.length; i++) {
526             _beforeTokenTransfer(address(0), divineTreasuryWallet, tokenIds[i]);
527             _balances[divineTreasuryWallet] += 1;
528             _owners[tokenIds[i]] = divineTreasuryWallet;
529             _tokenClass[tokenIds[i]] = classIds[i];
530             _tokenClassSupplyCurrent[classIds[i]] += 1;
531             emit Transfer(address(0), divineTreasuryWallet, tokenIds[i]);
532         }
533 
534         _mintedToTreasury += amount;
535 
536         if(_mintedToTreasury == MAX_MINTED_TO_TREASURY) {
537             _mintedToTreasuryHasFinished = true;
538         }
539     }    
540 
541     function mint(address account, uint256 amount, bytes32[] memory proof) external nonReentrant payable {
542         // Pre minting checks.
543         address operator = _msgSender();
544 
545         require(msg.value >= TOKEN_UNIT_PRICE * amount, 'Make sure you can afford 0.09 eth per token');
546         require(account != address(0), "Error: mint to the zero address");
547         require(!paused(), "Error: token transfer while paused");
548         require(_mintedToTreasuryHasFinished == true, 'Error: Wait until airdropping to Treasury has finished');
549         if (isPresaleActive == true) {
550             require(_tokensMintedByAddressAtPresale[operator] + amount <= MAX_TOKENS_MINTED_BY_ADDRESS_PRESALE, 'Error: you cannot mint more tokens at presale');
551             require(MerkleProof.verify(proof, root, keccak256(abi.encodePacked(operator))), "you are not allowed to mint during presale");
552         } else {
553             require(_tokensMintedByAddress[operator] + amount <= MAX_TOKENS_MINTED_BY_ADDRESS, 'Error: you cannot mint more tokens');
554         }
555 
556         uint256[][] memory randomList = getRand(amount);
557         uint256[] memory tokensIds = randomList[0];
558         uint256[] memory classIds = randomList[1];
559 
560         for (uint256 i = 0; i < amount; i++) {
561             _beforeTokenTransfer(address(0), account, tokensIds[i]);
562 
563             _owners[tokensIds[i]] = account;
564             _balances[account] += 1;
565             _tokenClass[tokensIds[i]] = classIds[i];
566             _tokenClassSupplyCurrent[classIds[i]] += 1;
567 
568             emit Transfer(address(0), account, tokensIds[i]);
569         }
570 
571         // Post minting.
572         if (isPresaleActive == true) {
573             _tokensMintedByAddressAtPresale[operator] += amount;
574         } else {
575             _tokensMintedByAddress[operator] += amount;
576         }
577     }
578 
579     function transferFrom(address from, address to, uint256 id) public {
580         // Pre transfer checks.
581         address operator = _msgSender();
582         require(!paused(), "Error: token transfer while paused");
583 
584         _transfer(from, to, operator, id);
585     }
586 
587     function safeTransferFrom(address from, address to, uint256 id) public  {
588         // Pre transfer checks.
589         address operator = _msgSender();
590         require(!paused(), "Error: token transfer while paused");
591 
592         _transfer(from, to, operator, id);
593         // Post transfer: check IERC721Receiver.
594         require(_checkOnERC721Received(from, to, id, ""), "ERC721: transfer to non ERC721Receiver implementer");
595     }
596 
597     function safeTransferFrom(address from, address to, uint256 id, bytes calldata data) public  {
598         // Pre transfer checks.
599         address operator = _msgSender();
600         require(!paused(), "Error: token transfer while paused");
601 
602         _transfer(from, to, operator, id);
603 
604         // Post transfer: check IERC721Receiver with data input.
605         require(_checkOnERC721Received(from, to, id, data), "ERC721: transfer to non ERC721Receiver implementer");
606 
607     }
608 
609     function _transfer(address from, address to, address operator, uint256 id) internal virtual {
610         require(_owners[id] == from);
611         require(from == operator || getApproved(id) == operator || isApprovedForAll(from, operator), "Error: caller is neither owner nor approved");
612         _beforeTokenTransfer(from, to, id);
613 
614         // Transfer.
615         _balances[from] -= 1;
616         _balances[to] += 1;
617         _owners[id] = to;
618 
619         emit Transfer(from, to, id);
620         _tokenApprovals[id] = address(0);
621     }
622 
623     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids) public {
624         // Pre transfer checks.
625         address operator = _msgSender();
626         require(!paused(), "Error: token transfer while paused");
627 
628         if (from != operator && isApprovedForAll(from, operator) == false) {
629             for (uint256 i = 0; i < ids.length; i++) {
630                 require(getApproved(ids[i]) == operator, 'Error: caller is neither owner nor approved');
631             }
632         }
633 
634         // Transfer.
635         for (uint256 i = 0; i < ids.length; i++) {
636             require(_owners[ids[i]] == from);
637             _beforeTokenTransfer(from, to, ids[i]);
638             _balances[from] -= 1;
639             _balances[to] += 1;
640             _owners[ids[i]] = to;
641 
642             emit Transfer(from, to, ids[i]);
643             _tokenApprovals[ids[i]] = address(0);
644 
645             require(_checkOnERC721Received(from, to, ids[i], ""), "ERC721: transfer to non ERC721Receiver implementer");
646         }
647     }
648     
649     function burn(address account, uint256 id) public {
650         // Pre burning checks.
651         address operator = _msgSender();
652         require(!paused(), "Error: token transfer while paused");
653 
654         require(account == operator || getApproved(id) == operator || isApprovedForAll(account, operator), "Error: caller is neither owner nor approved");
655         require(account != address(0), "Error: burn from the zero address");
656         require(_owners[id] == account, 'Error: account is not owner of token id');
657          _beforeTokenTransfer(account, address(0), id);
658 
659         // Burn process.
660         _owners[id] = address(0);
661         _balances[account] -= 1;
662 
663         emit Transfer(account, address(0), id);
664 
665         // Post burning.
666         _tokenApprovals[id] = address(0);
667     }
668 
669     function burnBatch(address account, uint256[] memory ids) public {
670         // Pre burning checks.
671         address operator = _msgSender();
672         require(!paused(), "Error: token transfer while paused");
673 
674         if (account != operator && isApprovedForAll(account, operator) == false) {
675             for (uint256 i = 0; i < ids.length; i++) {
676                 require(getApproved(ids[i]) == operator, 'Error: caller is neither owner nor approved');
677             }
678         } 
679 
680         for (uint256 i = 0; i < ids.length; i++) {
681             require(_owners[ids[i]] == account, 'Error: account is not owner of token id');
682         }
683 
684         // Burn process.
685         for (uint256 i = 0; i < ids.length; i++) {
686             _beforeTokenTransfer(account, address(0), ids[i]);
687             _owners[ids[i]] = address(0);
688             _balances[account] -= 1;
689             emit Transfer(account, address(0), ids[i]);
690         }
691 
692         // Post burning.
693         for (uint256 i=0; i < ids.length; i++) {
694             _tokenApprovals[ids[i]] = address(0);
695         }
696     }
697 
698     function airdropApples(uint256 amount, uint256 appleClass, address[] memory accounts) external override onlyOwner {        
699         require(accounts.length == amount, "amount not egal to list length");
700         require(appleClass == ASCENSION_APPLE || appleClass == BAD_APPLE, 'Error: The token class is not an apple');
701         require(_tokenClassSupplyCurrent[appleClass] + amount <= _tokenClassSupplyCap[appleClass], 'Error: You exceed the supply cap for this apple class');
702 
703         uint256 appleIdSetter;
704 
705         if (appleClass == ASCENSION_APPLE) {
706             appleIdSetter = _initAscensionApple + _tokenClassSupplyCurrent[ASCENSION_APPLE];
707         } else {
708             appleIdSetter = _initBadApple + _tokenClassSupplyCurrent[BAD_APPLE];
709         }
710 
711         for (uint256 i = 0; i < accounts.length; i++) {
712             uint256 appleId = appleIdSetter + i;
713             _beforeTokenTransfer(address(0), accounts[i], appleId);
714             _owners[appleId] = accounts[i];
715             _balances[accounts[i]] += 1;
716             _tokenClass[appleId] = appleClass;
717         } 
718 
719         _tokenClassSupplyCurrent[appleClass] += amount;
720     }
721 
722     function ascensionAppleConsume(address account, uint256 appleId) external {
723         address operator = _msgSender();
724 
725         require(isAscensionApple(appleId), 'Error: token provided is not ascension apple');
726         require(_owners[appleId] == operator || getApproved(appleId) == operator || isApprovedForAll(account, operator), "Error: caller is neither owner nor approved");
727         burn(account, appleId);
728         _consumedAscensionApples[account] += 1;
729     }
730 
731     function badAppleConsume(address account, uint256 appleId, uint256 tokenId) external {
732         address operator = _msgSender();
733 
734         require(isBadApple(appleId), 'Error: token provided is not bad apple');
735         require(isTokenClassMintable(tokenId), "Error: token provided is an apple");
736 
737         require(_owners[appleId] == operator || getApproved(appleId) == operator || isApprovedForAll(account, operator), "Error: caller is neither owner nor approved");
738 
739         burn(account, appleId);
740         burn(account, tokenId);
741 
742         // Rewarding with 1 ascension apple.
743         require(_tokenClassSupplyCurrent[ASCENSION_APPLE] + 1 <= _tokenClassSupplyCap[ASCENSION_APPLE], 'Error: You exceed the supply cap for this apple class');
744 
745         uint256 ascensionAppleId = _initAscensionApple + _tokenClassSupplyCurrent[ASCENSION_APPLE];
746             
747         _beforeTokenTransfer(address(0), account, ascensionAppleId);
748         _owners[ascensionAppleId] = account;
749         _balances[account] += 1;
750         _tokenClassSupplyCurrent[ASCENSION_APPLE] += 1;
751     }
752 
753     // Auxiliary functions.
754     function exists(uint256 tokenId) public view virtual returns (bool) {
755         return _owners[tokenId] != address(0);
756     }
757 
758     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
759         if (to.isContract()) {
760             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
761                 return retval == IERC721Receiver.onERC721Received.selector;
762             } catch (bytes memory reason) {
763                 if (reason.length == 0) {
764                     revert("ERC721: transfer to non ERC721Receiver implementer");
765                 } else {
766                     assembly {
767                         revert(add(32, reason), mload(reason))
768                     }
769                 }
770             }
771         } else {
772             return true;
773         }
774     }
775 
776     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
777         return
778         interfaceId == type(IERC721Enumerable).interfaceId ||
779             interfaceId == type(IERC721).interfaceId ||
780             interfaceId == type(IERC721Metadata).interfaceId ||
781             super.supportsInterface(interfaceId);
782     }
783     
784     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual  returns (uint256) {
785         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
786         return _ownedTokens[owner][index];
787     }
788 
789     function totalSupply() public view virtual  returns (uint256) {
790         return _allTokens.length;
791     }
792 
793     function tokenByIndex(uint256 index) public view virtual  returns (uint256) {
794         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
795         return _allTokens[index];
796     }
797     
798        function _beforeTokenTransfer(
799         address from,
800         address to,
801         uint256 tokenId
802     ) internal   {
803         if (from == address(0)) {
804             _addTokenToAllTokensEnumeration(tokenId);
805         } else if (from != to) {
806             _removeTokenFromOwnerEnumeration(from, tokenId);
807         }
808         if (to == address(0)) {
809             _removeTokenFromAllTokensEnumeration(tokenId);
810         } else if (to != from) {
811             _addTokenToOwnerEnumeration(to, tokenId);
812         }
813     }
814 
815     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
816         uint256 length = balanceOf(to);
817         _ownedTokens[to][length] = tokenId;
818         _ownedTokensIndex[tokenId] = length;
819     }
820 
821     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
822         _allTokensIndex[tokenId] = _allTokens.length;
823         _allTokens.push(tokenId);
824     }
825 
826     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
827         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
828         // then delete the last slot (swap and pop).
829 
830         uint256 lastTokenIndex = balanceOf(from) - 1;
831         uint256 tokenIndex = _ownedTokensIndex[tokenId];
832 
833         // When the token to delete is the last token, the swap operation is unnecessary
834         if (tokenIndex != lastTokenIndex) {
835             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
836 
837             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
838             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
839         }
840 
841         // This also deletes the contents at the last position of the array
842         delete _ownedTokensIndex[tokenId];
843         delete _ownedTokens[from][lastTokenIndex];
844     }
845 
846     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
847         uint256 lastTokenIndex = _allTokens.length - 1;
848         uint256 tokenIndex = _allTokensIndex[tokenId];
849         uint256 lastTokenId = _allTokens[lastTokenIndex];
850 
851         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
852         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
853 
854         delete _allTokensIndex[tokenId];
855         _allTokens.pop();
856     }
857     
858     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
859         uint256 tokenCount = balanceOf(_owner);
860         uint256[] memory result = new uint256[](tokenCount);
861         for(uint256 i = 0; i < tokenCount; i++) {
862             result[i] = tokenOfOwnerByIndex(_owner, i);
863         }
864         return result;
865     }
866     
867     function getData(address _account)external view returns(uint256[][] memory){
868         uint256[][] memory data = new uint256[][](2);
869         uint256[] memory arrayOfTokens = walletOfOwner(_account);
870         uint256[] memory othersData = new uint256[](2);
871         othersData[0] = totalSupply();
872         othersData[1] = TOKEN_UNIT_PRICE;
873         data[0] = arrayOfTokens;
874         data[1] = othersData;
875         return data;
876     }
877     
878     function withdrawAll() external onlyOwner nonReentrant{
879         uint256 balance = address(this).balance;
880         require(balance > 0, "balance is 0.");
881         (bool success,) = payable(msg.sender).call{value: balance}(new bytes(0));
882         if(!success)revert("withdraw: transfer error");    
883         
884     }
885 
886     function withdraw(uint256 _amount) external onlyOwner nonReentrant{
887         uint256 balance = address(this).balance;
888         require(balance > 0, "balance is 0.");
889         require(balance > _amount, "balance must be superior to amount");
890         (bool success,) = payable(msg.sender).call{value: _amount}(new bytes(0));
891         if(!success)revert("withdraw: transfer error");
892     }
893     
894     function setPresale(bool _bool) external onlyOwner{
895         isPresaleActive = _bool;
896     }
897     
898     function setRoot(bytes32 _root) external onlyOwner {
899         root = _root;
900     }
901     
902     function setMaxMintedTreasury(uint256 _amount) external onlyOwner {
903         MAX_MINTED_TO_TREASURY = _amount;
904                 if(_mintedToTreasury == MAX_MINTED_TO_TREASURY) {
905             _mintedToTreasuryHasFinished = true;
906         }
907     }
908     function setOracle(address _oracle) external onlyOwner{
909         oracle = IOracle(_oracle);
910     }
911     
912     function setAdminWallet(address _adminwallets) external onlyOwner {
913         adminWallets = IAdminWallets(_adminwallets);
914     }
915     
916     function oracleRescue(uint256 _amount) public view returns(uint256[][]memory) {
917         uint256[][] memory array = new uint256[][](2);
918         uint256[] memory tokenIds = new uint256[](_amount);
919         uint256[] memory classIds = new uint256[](_amount);
920         uint256 initRand = 0;
921         uint256 each = 0;
922         bytes32 bHash = blockhash(block.number - 1);
923 
924         while(initRand != _amount){
925             uint256 randomNumber = uint256(
926                 uint256(
927                     keccak256(
928                         abi.encodePacked(
929                             block.timestamp, 
930                             bHash, 
931                             _msgSender(), 
932                             each
933                         )
934                     )
935                 ) % 10011
936             );
937             bool inArray;
938             for(uint256 i = 0; i<initRand; i++){
939                 if(randomNumber == tokenIds[i]){
940                     inArray = true;
941                 }
942             }
943             if(!exists(randomNumber) && !inArray){
944                 tokenIds[initRand] = randomNumber;
945                 classIds[initRand] = setTokenClass(randomNumber);
946                 initRand += 1;
947             }
948             each += 1;
949         }
950         array[0] = tokenIds;
951         array[1] = classIds;
952     return array;
953        
954     }
955     
956     function setRescue(bool _value) external onlyOwner {
957         toRescue = _value;
958     }
959     
960     function forceOracle(bool _value) external onlyOwner {
961         oracleForced = _value;
962     }
963     
964     function getRand(uint256 _amount) internal returns(uint256[][] memory ){
965         if(!toRescue && !oracleForced){
966             try oracle.getRandomNumbers() returns(uint256[][] memory array){
967                 return (array);
968             } catch {
969                 uint256[][] memory arr = oracleRescue(_amount);
970                 emit oracleRescued(arr, block.timestamp, msg.sender);
971                 return arr;
972             }
973         } else if(!toRescue && oracleForced){
974             return oracle.getRandomNumbers();
975         } else {
976             uint256[][] memory arr = oracleRescue(_amount);
977             emit oracleRescued(arr, block.timestamp, msg.sender);
978             return arr;        
979         }
980     }
981     
982     function setMaxTokenMintedByAddress(uint256 _amount) external onlyOwner{
983         MAX_TOKENS_MINTED_BY_ADDRESS = _amount;
984     }
985     
986     function setNewTokenPrice(uint256 _newPrice) external onlyOwner{
987         TOKEN_UNIT_PRICE = _newPrice;
988     }
989     
990     function getPresaleState()external view returns(bool){
991         return isPresaleActive;
992     }
993     
994   
995 }