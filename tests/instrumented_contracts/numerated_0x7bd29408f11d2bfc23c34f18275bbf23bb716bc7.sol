1 pragma solidity 0.7.6;
2 
3 /**
4  *  __  __           _     _ _
5  * |  \/  |         | |   (_) |
6  * | \  / | ___  ___| |__  _| |_ ___
7  * | |\/| |/ _ \/ _ \ '_ \| | __/ __|
8  * | |  | |  __/  __/ |_) | | |_\__ \
9  * |_|  |_|\___|\___|_.__/|_|\__|___/
10  *
11  * An NFT project from Larva Labs.
12  *
13  */
14 interface IERC165 {
15     function supportsInterface(bytes4 interfaceId) external view returns (bool);
16 }
17 
18 interface IERC721 is IERC165 {
19     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
20     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
21     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
22     function balanceOf(address owner) external view returns (uint256 balance);
23     function ownerOf(uint256 tokenId) external view returns (address owner);
24     function safeTransferFrom(address from, address to, uint256 tokenId) external;
25     function transferFrom(address from, address to, uint256 tokenId) external;
26     function approve(address to, uint256 tokenId) external;
27     function getApproved(uint256 tokenId) external view returns (address operator);
28     function setApprovalForAll(address operator, bool _approved) external;
29     function isApprovedForAll(address owner, address operator) external view returns (bool);
30     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
31 }
32 
33 /**
34  * Minimal interface to Cryptopunks for verifying ownership during Community Grant.
35  */
36 interface Cryptopunks {
37     function punkIndexToAddress(uint index) external view returns(address);
38 }
39 
40 interface ERC721TokenReceiver
41 {
42     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
43 }
44 
45 library SafeMath {
46 
47     /**
48     * @dev Multiplies two numbers, throws on overflow.
49     */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         if (a == 0) {
52             return 0;
53         }
54         c = a * b;
55         require(c / a == b);
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two numbers, truncating the quotient.
61     */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // assert(b > 0); // Solidity automatically throws when dividing by 0
64         // uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66         return a / b;
67     }
68 
69     /**
70     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71     */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         require(b <= a);
74         return a - b;
75     }
76 
77     /**
78     * @dev Adds two numbers, throws on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
81         c = a + b;
82         require(c >= a);
83         return c;
84     }
85 }
86 
87 contract Meebits is IERC721 {
88 
89     using SafeMath for uint256;
90 
91     /**
92      * Event emitted when minting a new NFT. "createdVia" is the index of the Cryptopunk/Autoglyph that was used to mint, or 0 if not applicable.
93      */
94     event Mint(uint indexed index, address indexed minter, uint createdVia);
95 
96     /**
97      * Event emitted when a trade is executed.
98      */
99     event Trade(bytes32 indexed hash, address indexed maker, address taker, uint makerWei, uint[] makerIds, uint takerWei, uint[] takerIds);
100 
101     /**
102      * Event emitted when ETH is deposited into the contract.
103      */
104     event Deposit(address indexed account, uint amount);
105 
106     /**
107      * Event emitted when ETH is withdrawn from the contract.
108      */
109     event Withdraw(address indexed account, uint amount);
110 
111     /**
112      * Event emitted when a trade offer is cancelled.
113      */
114     event OfferCancelled(bytes32 hash);
115 
116     /**
117      * Event emitted when the public sale begins.
118      */
119     event SaleBegins();
120 
121     /**
122      * Event emitted when the community grant period ends.
123      */
124     event CommunityGrantEnds();
125 
126     bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
127 
128     // IPFS Hash to the NFT content
129     string public contentHash = "QmfXYgfX1qNfzQ6NRyFnupniZusasFPMeiWn5aaDnx7YXo";
130 
131     uint public constant TOKEN_LIMIT = 20000;
132     uint public constant SALE_LIMIT = 9000;
133 
134     mapping(bytes4 => bool) internal supportedInterfaces;
135 
136     mapping (uint256 => address) internal idToOwner;
137 
138     mapping (uint256 => uint256) public creatorNftMints;
139 
140     mapping (uint256 => address) internal idToApproval;
141 
142     mapping (address => mapping (address => bool)) internal ownerToOperators;
143 
144     mapping(address => uint256[]) internal ownerToIds;
145 
146     mapping(uint256 => uint256) internal idToOwnerIndex;
147 
148     string internal nftName = "Meebits";
149     string internal nftSymbol = unicode"⚇";
150 
151     uint internal numTokens = 0;
152     uint internal numSales = 0;
153 
154     // Cryptopunks contract
155     address internal punks;
156 
157     // Autoglyphs contract
158     address internal glyphs;
159 
160     address payable internal deployer;
161     address payable internal beneficiary;
162     bool public communityGrant = true;
163     bool public publicSale = false;
164     uint private price;
165     uint public saleStartTime;
166     uint public saleDuration;
167 
168     //// Random index assignment
169     uint internal nonce = 0;
170     uint[TOKEN_LIMIT] internal indices;
171 
172     //// Market
173     bool public marketPaused;
174     bool public contractSealed;
175     mapping (address => uint256) public ethBalance;
176     mapping (bytes32 => bool) public cancelledOffers;
177 
178     modifier onlyDeployer() {
179         require(msg.sender == deployer, "Only deployer.");
180         _;
181     }
182 
183     bool private reentrancyLock = false;
184 
185     /* Prevent a contract function from being reentrant-called. */
186     modifier reentrancyGuard {
187         if (reentrancyLock) {
188             revert();
189         }
190         reentrancyLock = true;
191         _;
192         reentrancyLock = false;
193     }
194 
195     modifier canOperate(uint256 _tokenId) {
196         address tokenOwner = idToOwner[_tokenId];
197         require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender], "Cannot operate.");
198         _;
199     }
200 
201     modifier canTransfer(uint256 _tokenId) {
202         address tokenOwner = idToOwner[_tokenId];
203         require(
204             tokenOwner == msg.sender
205             || idToApproval[_tokenId] == msg.sender
206             || ownerToOperators[tokenOwner][msg.sender], "Cannot transfer."
207         );
208         _;
209     }
210 
211     modifier validNFToken(uint256 _tokenId) {
212         require(idToOwner[_tokenId] != address(0), "Invalid token.");
213         _;
214     }
215 
216     constructor(address _punks, address _glyphs, address payable _beneficiary) {
217         supportedInterfaces[0x01ffc9a7] = true; // ERC165
218         supportedInterfaces[0x80ac58cd] = true; // ERC721
219         supportedInterfaces[0x780e9d63] = true; // ERC721 Enumerable
220         supportedInterfaces[0x5b5e139f] = true; // ERC721 Metadata
221         deployer = msg.sender;
222         punks = _punks;
223         glyphs = _glyphs;
224         beneficiary = _beneficiary;
225     }
226 
227     function startSale(uint _price, uint _saleDuration) external onlyDeployer {
228         require(!publicSale);
229         price = _price;
230         saleDuration = _saleDuration;
231         saleStartTime = block.timestamp;
232         publicSale = true;
233         emit SaleBegins();
234     }
235 
236     function endCommunityGrant() external onlyDeployer {
237         require(communityGrant);
238         communityGrant = false;
239         emit CommunityGrantEnds();
240     }
241 
242     function pauseMarket(bool _paused) external onlyDeployer {
243         require(!contractSealed, "Contract sealed.");
244         marketPaused = _paused;
245     }
246 
247     function sealContract() external onlyDeployer {
248         contractSealed = true;
249     }
250 
251     //////////////////////////
252     //// ERC 721 and 165  ////
253     //////////////////////////
254 
255     function isContract(address _addr) internal view returns (bool addressCheck) {
256         uint256 size;
257         assembly { size := extcodesize(_addr) } // solhint-disable-line
258         addressCheck = size > 0;
259     }
260 
261     function supportsInterface(bytes4 _interfaceID) external view override returns (bool) {
262         return supportedInterfaces[_interfaceID];
263     }
264 
265     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external override {
266         _safeTransferFrom(_from, _to, _tokenId, _data);
267     }
268 
269     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external override {
270         _safeTransferFrom(_from, _to, _tokenId, "");
271     }
272 
273     function transferFrom(address _from, address _to, uint256 _tokenId) external override canTransfer(_tokenId) validNFToken(_tokenId) {
274         address tokenOwner = idToOwner[_tokenId];
275         require(tokenOwner == _from, "Wrong from address.");
276         require(_to != address(0), "Cannot send to 0x0.");
277         _transfer(_to, _tokenId);
278     }
279 
280     function approve(address _approved, uint256 _tokenId) external override canOperate(_tokenId) validNFToken(_tokenId) {
281         address tokenOwner = idToOwner[_tokenId];
282         require(_approved != tokenOwner);
283         idToApproval[_tokenId] = _approved;
284         emit Approval(tokenOwner, _approved, _tokenId);
285     }
286 
287     function setApprovalForAll(address _operator, bool _approved) external override {
288         ownerToOperators[msg.sender][_operator] = _approved;
289         emit ApprovalForAll(msg.sender, _operator, _approved);
290     }
291 
292     function balanceOf(address _owner) external view override returns (uint256) {
293         require(_owner != address(0));
294         return _getOwnerNFTCount(_owner);
295     }
296 
297     function ownerOf(uint256 _tokenId) external view override returns (address _owner) {
298         require(idToOwner[_tokenId] != address(0));
299         _owner = idToOwner[_tokenId];
300     }
301 
302     function getApproved(uint256 _tokenId) external view override validNFToken(_tokenId) returns (address) {
303         return idToApproval[_tokenId];
304     }
305 
306     function isApprovedForAll(address _owner, address _operator) external override view returns (bool) {
307         return ownerToOperators[_owner][_operator];
308     }
309 
310     function _transfer(address _to, uint256 _tokenId) internal {
311         address from = idToOwner[_tokenId];
312         _clearApproval(_tokenId);
313 
314         _removeNFToken(from, _tokenId);
315         _addNFToken(_to, _tokenId);
316 
317         emit Transfer(from, _to, _tokenId);
318     }
319 
320     function randomIndex() internal returns (uint) {
321         uint totalSize = TOKEN_LIMIT - numTokens;
322         uint index = uint(keccak256(abi.encodePacked(nonce, msg.sender, block.difficulty, block.timestamp))) % totalSize;
323         uint value = 0;
324         if (indices[index] != 0) {
325             value = indices[index];
326         } else {
327             value = index;
328         }
329 
330         // Move last value to selected position
331         if (indices[totalSize - 1] == 0) {
332             // Array position not initialized, so use position
333             indices[index] = totalSize - 1;
334         } else {
335             // Array position holds a value so use that
336             indices[index] = indices[totalSize - 1];
337         }
338         nonce++;
339         // Don't allow a zero index, start counting at 1
340         return value.add(1);
341     }
342 
343     // Calculate the mint price
344     function getPrice() public view returns (uint) {
345         require(publicSale, "Sale not started.");
346         uint elapsed = block.timestamp.sub(saleStartTime);
347         if (elapsed >= saleDuration) {
348             return 0;
349         } else {
350             return saleDuration.sub(elapsed).mul(price).div(saleDuration);
351         }
352     }
353 
354     // The deployer can mint in bulk without paying
355     function devMint(uint quantity, address recipient) external onlyDeployer {
356         for (uint i = 0; i < quantity; i++) {
357             _mint(recipient, 0);
358         }
359     }
360 
361     function mintsRemaining() external view returns (uint) {
362         return SALE_LIMIT.sub(numSales);
363     }
364 
365     /**
366      * Community grant minting.
367      */
368     function mintWithPunkOrGlyph(uint _createVia) external reentrancyGuard returns (uint) {
369         require(communityGrant);
370         require(!marketPaused);
371         require(_createVia > 0 && _createVia <= 10512, "Invalid punk/glyph index.");
372         require(creatorNftMints[_createVia] == 0, "Already minted with this punk/glyph");
373         if (_createVia > 10000) {
374             // It's a glyph
375             // Compute the glyph ID
376             uint glyphId = _createVia.sub(10000);
377             // Make sure the sender owns the glyph
378             require(IERC721(glyphs).ownerOf(glyphId) == msg.sender, "Not the owner of this glyph.");
379         } else {
380             // It's a punk
381             // Compute the punk ID
382             uint punkId = _createVia.sub(1);
383             // Make sure the sender owns the punk
384             require(Cryptopunks(punks).punkIndexToAddress(punkId) == msg.sender, "Not the owner of this punk.");
385         }
386         creatorNftMints[_createVia]++;
387         return _mint(msg.sender, _createVia);
388     }
389 
390     /**
391      * Public sale minting.
392      */
393     function mint() external payable reentrancyGuard returns (uint) {
394         require(publicSale, "Sale not started.");
395         require(!marketPaused);
396         require(numSales < SALE_LIMIT, "Sale limit reached.");
397         uint salePrice = getPrice();
398         require(msg.value >= salePrice, "Insufficient funds to purchase.");
399         if (msg.value > salePrice) {
400             msg.sender.transfer(msg.value.sub(salePrice));
401         }
402         beneficiary.transfer(salePrice);
403         numSales++;
404         return _mint(msg.sender, 0);
405     }
406 
407     function _mint(address _to, uint createdVia) internal returns (uint) {
408         require(_to != address(0), "Cannot mint to 0x0.");
409         require(numTokens < TOKEN_LIMIT, "Token limit reached.");
410         uint id = randomIndex();
411 
412         numTokens = numTokens + 1;
413         _addNFToken(_to, id);
414 
415         emit Mint(id, _to, createdVia);
416         emit Transfer(address(0), _to, id);
417         return id;
418     }
419 
420     function _addNFToken(address _to, uint256 _tokenId) internal {
421         require(idToOwner[_tokenId] == address(0), "Cannot add, already owned.");
422         idToOwner[_tokenId] = _to;
423 
424         ownerToIds[_to].push(_tokenId);
425         idToOwnerIndex[_tokenId] = ownerToIds[_to].length.sub(1);
426     }
427 
428     function _removeNFToken(address _from, uint256 _tokenId) internal {
429         require(idToOwner[_tokenId] == _from, "Incorrect owner.");
430         delete idToOwner[_tokenId];
431 
432         uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
433         uint256 lastTokenIndex = ownerToIds[_from].length.sub(1);
434 
435         if (lastTokenIndex != tokenToRemoveIndex) {
436             uint256 lastToken = ownerToIds[_from][lastTokenIndex];
437             ownerToIds[_from][tokenToRemoveIndex] = lastToken;
438             idToOwnerIndex[lastToken] = tokenToRemoveIndex;
439         }
440 
441         ownerToIds[_from].pop();
442     }
443 
444     function _getOwnerNFTCount(address _owner) internal view returns (uint256) {
445         return ownerToIds[_owner].length;
446     }
447 
448     function _safeTransferFrom(address _from,  address _to,  uint256 _tokenId,  bytes memory _data) private canTransfer(_tokenId) validNFToken(_tokenId) {
449         address tokenOwner = idToOwner[_tokenId];
450         require(tokenOwner == _from, "Incorrect owner.");
451         require(_to != address(0));
452 
453         _transfer(_to, _tokenId);
454 
455         if (isContract(_to)) {
456             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
457             require(retval == MAGIC_ON_ERC721_RECEIVED);
458         }
459     }
460 
461     function _clearApproval(uint256 _tokenId) private {
462         if (idToApproval[_tokenId] != address(0)) {
463             delete idToApproval[_tokenId];
464         }
465     }
466 
467     //// Enumerable
468 
469     function totalSupply() public view returns (uint256) {
470         return numTokens;
471     }
472 
473     function tokenByIndex(uint256 index) public pure returns (uint256) {
474         require(index >= 0 && index < TOKEN_LIMIT);
475         return index + 1;
476     }
477 
478     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
479         require(_index < ownerToIds[_owner].length);
480         return ownerToIds[_owner][_index];
481     }
482 
483     //// Metadata
484 
485     /**
486       * @dev Converts a `uint256` to its ASCII `string` representation.
487       */
488     function toString(uint256 value) internal pure returns (string memory) {
489         if (value == 0) {
490             return "0";
491         }
492         uint256 temp = value;
493         uint256 digits;
494         while (temp != 0) {
495             digits++;
496             temp /= 10;
497         }
498         bytes memory buffer = new bytes(digits);
499         uint256 index = digits - 1;
500         temp = value;
501         while (temp != 0) {
502             buffer[index--] = bytes1(uint8(48 + temp % 10));
503             temp /= 10;
504         }
505         return string(buffer);
506     }
507 
508     /**
509       * @dev Returns a descriptive name for a collection of NFTokens.
510       * @return _name Representing name.
511       */
512     function name() external view returns (string memory _name) {
513         _name = nftName;
514     }
515 
516     /**
517      * @dev Returns an abbreviated name for NFTokens.
518      * @return _symbol Representing symbol.
519      */
520     function symbol() external view returns (string memory _symbol) {
521         _symbol = nftSymbol;
522     }
523 
524     /**
525      * @dev A distinct URI (RFC 3986) for a given NFT.
526      * @param _tokenId Id for which we want uri.
527      * @return _tokenId URI of _tokenId.
528      */
529     function tokenURI(uint256 _tokenId) external view validNFToken(_tokenId) returns (string memory) {
530         return string(abi.encodePacked("https://meebits.larvalabs.com/meebit/", toString(_tokenId)));
531     }
532 
533     //// MARKET
534 
535     struct Offer {
536         address maker;
537         address taker;
538         uint256 makerWei;
539         uint256[] makerIds;
540         uint256 takerWei;
541         uint256[] takerIds;
542         uint256 expiry;
543         uint256 salt;
544     }
545 
546     function hashOffer(Offer memory offer) private pure returns (bytes32){
547         return keccak256(abi.encode(
548                     offer.maker,
549                     offer.taker,
550                     offer.makerWei,
551                     keccak256(abi.encodePacked(offer.makerIds)),
552                     offer.takerWei,
553                     keccak256(abi.encodePacked(offer.takerIds)),
554                     offer.expiry,
555                     offer.salt
556                 ));
557     }
558 
559     function hashToSign(address maker, address taker, uint256 makerWei, uint256[] memory makerIds, uint256 takerWei, uint256[] memory takerIds, uint256 expiry, uint256 salt) public pure returns (bytes32) {
560         Offer memory offer = Offer(maker, taker, makerWei, makerIds, takerWei, takerIds, expiry, salt);
561         return hashOffer(offer);
562     }
563 
564     function hashToVerify(Offer memory offer) private pure returns (bytes32) {
565         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hashOffer(offer)));
566     }
567 
568     function verify(address signer, bytes32 hash, bytes memory signature) internal pure returns (bool) {
569         require(signer != address(0));
570         require(signature.length == 65);
571 
572         bytes32 r;
573         bytes32 s;
574         uint8 v;
575 
576         assembly {
577             r := mload(add(signature, 32))
578             s := mload(add(signature, 64))
579             v := byte(0, mload(add(signature, 96)))
580         }
581 
582         if (v < 27) {
583             v += 27;
584         }
585 
586         require(v == 27 || v == 28);
587 
588         return signer == ecrecover(hash, v, r, s);
589     }
590 
591     function tradeValid(address maker, address taker, uint256 makerWei, uint256[] memory makerIds, uint256 takerWei, uint256[] memory takerIds, uint256 expiry, uint256 salt, bytes memory signature) view public returns (bool) {
592         Offer memory offer = Offer(maker, taker, makerWei, makerIds, takerWei, takerIds, expiry, salt);
593         // Check for cancellation
594         bytes32 hash = hashOffer(offer);
595         require(cancelledOffers[hash] == false, "Trade offer was cancelled.");
596         // Verify signature
597         bytes32 verifyHash = hashToVerify(offer);
598         require(verify(offer.maker, verifyHash, signature), "Signature not valid.");
599         // Check for expiry
600         require(block.timestamp < offer.expiry, "Trade offer expired.");
601         // Only one side should ever have to pay, not both
602         require(makerWei == 0 || takerWei == 0, "Only one side of trade must pay.");
603         // At least one side should offer tokens
604         require(makerIds.length > 0 || takerIds.length > 0, "One side must offer tokens.");
605         // Make sure the maker has funded the trade
606         require(ethBalance[offer.maker] >= offer.makerWei, "Maker does not have sufficient balance.");
607         // Ensure the maker owns the maker tokens
608         for (uint i = 0; i < offer.makerIds.length; i++) {
609             require(idToOwner[offer.makerIds[i]] == offer.maker, "At least one maker token doesn't belong to maker.");
610         }
611         // If the taker can be anybody, then there can be no taker tokens
612         if (offer.taker == address(0)) {
613             // If taker not specified, then can't specify IDs
614             require(offer.takerIds.length == 0, "If trade is offered to anybody, cannot specify tokens from taker.");
615         } else {
616             // Ensure the taker owns the taker tokens
617             for (uint i = 0; i < offer.takerIds.length; i++) {
618                 require(idToOwner[offer.takerIds[i]] == offer.taker, "At least one taker token doesn't belong to taker.");
619             }
620         }
621         return true;
622     }
623 
624     function cancelOffer(address maker, address taker, uint256 makerWei, uint256[] memory makerIds, uint256 takerWei, uint256[] memory takerIds, uint256 expiry, uint256 salt) external {
625         require(maker == msg.sender, "Only the maker can cancel this offer.");
626         Offer memory offer = Offer(maker, taker, makerWei, makerIds, takerWei, takerIds, expiry, salt);
627         bytes32 hash = hashOffer(offer);
628         cancelledOffers[hash] = true;
629         emit OfferCancelled(hash);
630     }
631 
632     function acceptTrade(address maker, address taker, uint256 makerWei, uint256[] memory makerIds, uint256 takerWei, uint256[] memory takerIds, uint256 expiry, uint256 salt, bytes memory signature) external payable reentrancyGuard {
633         require(!marketPaused, "Market is paused.");
634         require(msg.sender != maker, "Can't accept ones own trade.");
635         Offer memory offer = Offer(maker, taker, makerWei, makerIds, takerWei, takerIds, expiry, salt);
636         if (msg.value > 0) {
637             ethBalance[msg.sender] = ethBalance[msg.sender].add(msg.value);
638             emit Deposit(msg.sender, msg.value);
639         }
640         require(offer.taker == address(0) || offer.taker == msg.sender, "Not the recipient of this offer.");
641         require(tradeValid(maker, taker, makerWei, makerIds, takerWei, takerIds, expiry, salt, signature), "Trade not valid.");
642         require(ethBalance[msg.sender] >= offer.takerWei, "Insufficient funds to execute trade.");
643         // Transfer ETH
644         ethBalance[offer.maker] = ethBalance[offer.maker].sub(offer.makerWei);
645         ethBalance[msg.sender] = ethBalance[msg.sender].add(offer.makerWei);
646         ethBalance[msg.sender] = ethBalance[msg.sender].sub(offer.takerWei);
647         ethBalance[offer.maker] = ethBalance[offer.maker].add(offer.takerWei);
648         // Transfer maker ids to taker (msg.sender)
649         for (uint i = 0; i < makerIds.length; i++) {
650             _transfer(msg.sender, makerIds[i]);
651         }
652         // Transfer taker ids to maker
653         for (uint i = 0; i < takerIds.length; i++) {
654             _transfer(maker, takerIds[i]);
655         }
656         // Prevent a replay attack on this offer
657         bytes32 hash = hashOffer(offer);
658         cancelledOffers[hash] = true;
659         emit Trade(hash, offer.maker, msg.sender, offer.makerWei, offer.makerIds, offer.takerWei, offer.takerIds);
660     }
661 
662     function withdraw(uint amount) external reentrancyGuard {
663         require(amount <= ethBalance[msg.sender]);
664         ethBalance[msg.sender] = ethBalance[msg.sender].sub(amount);
665         (bool success, ) = msg.sender.call{value:amount}("");
666         require(success);
667         emit Withdraw(msg.sender, amount);
668     }
669 
670     function deposit() external payable {
671         ethBalance[msg.sender] = ethBalance[msg.sender].add(msg.value);
672         emit Deposit(msg.sender, msg.value);
673     }
674 
675 }