1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @title ROARS
7  * @author 0xSumo
8  */
9 
10 abstract contract ERC721TokenReceiver {
11     function onERC721Received(address, address, uint256, bytes calldata) external virtual returns (bytes4) { return ERC721TokenReceiver.onERC721Received.selector; }
12 }
13 
14 abstract contract ERC721 {
15     
16     event Transfer(address indexed from_, address indexed to_, uint256 indexed tokenId_);
17     event Approval(address indexed owner_, address indexed spender_, uint256 indexed id_);
18     event ApprovalForAll(address indexed owner_, address indexed operator_, bool approved_);
19 
20     string public name; 
21     string public symbol;
22     string public baseTokenURI;
23     string public baseTokenURI_EXT;
24 
25     uint256 public nextTokenId;
26     uint256 public totalBurned;
27     uint256 public constant maxBatchSize = 100;
28     
29     function startTokenId() public pure virtual returns (uint256) {
30         return 0;
31     }
32 
33     function totalSupply() public view virtual returns (uint256) {
34         return nextTokenId - totalBurned - startTokenId();
35     }
36 
37     constructor(string memory name_, string memory symbol_) {
38         name = name_;
39         symbol = symbol_;
40         nextTokenId = startTokenId();
41     }
42 
43     struct TokenData {
44         address owner;
45         uint40 lastTransfer;
46         bool burned;
47         bool nextInitialized;
48     }
49     struct BalanceData {
50         uint32 balance;
51         uint32 mintedAmount;
52     }
53 
54     mapping(uint256 => TokenData) public _tokenData;
55     mapping(address => BalanceData) public _balanceData;
56 
57     mapping(address => bool) public operatorList;
58     mapping(uint256 => address) public getApproved;
59     mapping(address => mapping(address => bool)) public isApprovedForAll;
60 
61     function _getTokenDataOf(uint256 tokenId_) public view virtual returns (TokenData memory) {
62         uint256 _lookupId = tokenId_;
63         require(_lookupId >= startTokenId(), "_getTokenDataOf _lookupId < startTokenId");
64         TokenData memory _TokenData = _tokenData[_lookupId];
65         if (_TokenData.owner != address(0) && !_TokenData.burned) return _TokenData;
66         require(!_TokenData.burned, "_getTokenDataOf burned token!");
67         require(_lookupId < nextTokenId, "_getTokenDataOf _lookupId > _nextTokenId");
68         unchecked { while(_tokenData[--_lookupId].owner == address(0)) {} }
69         return _tokenData[_lookupId];
70     }
71 
72     function balanceOf(address owner_) public virtual view returns (uint256) {
73         require(owner_ != address(0), "balanceOf to 0x0");
74         return _balanceData[owner_].balance;
75     }
76 
77     function ownerOf(uint256 tokenId_) public view returns (address) {
78         return _getTokenDataOf(tokenId_).owner;
79     }
80 
81     function _mintInternal(address to_, uint256 amount_) internal virtual { unchecked {
82         require(to_ != address(0), "_mint to 0x0");
83         uint256 _startId = nextTokenId;
84         uint256 _endId = _startId + amount_;
85         _tokenData[_startId].owner = to_;
86         _tokenData[_startId].lastTransfer = uint40(block.timestamp);
87         _balanceData[to_].balance += uint32(amount_);
88         _balanceData[to_].mintedAmount += uint32(amount_);
89         do { emit Transfer(address(0), to_, _startId); } while (++_startId < _endId);
90         nextTokenId = _endId;
91     }}
92 
93     function _mint(address to_, uint256 amount_) internal virtual {
94         uint256 _amountToMint = amount_;
95         while (_amountToMint > maxBatchSize) {
96             _amountToMint -= maxBatchSize;
97             _mintInternal(to_, maxBatchSize);
98         }
99         _mintInternal(to_, _amountToMint);
100     }
101 
102     function _burn(uint256 tokenId_, bool checkApproved_) internal virtual { unchecked {
103         TokenData memory _TokenData = _getTokenDataOf(tokenId_);
104         address _owner = _TokenData.owner;
105         if (checkApproved_) require(_isApprovedOrOwner(_owner, msg.sender, tokenId_), "_burn not approved");
106         delete getApproved[tokenId_];
107         _tokenData[tokenId_].owner = _owner;
108         _tokenData[tokenId_].lastTransfer = uint40(block.timestamp);
109         _tokenData[tokenId_].burned = true;
110         _tokenData[tokenId_].nextInitialized = true;
111 
112         if (!_TokenData.nextInitialized) {
113             uint256 _tokenIdIncremented = tokenId_ + 1;
114             if (_tokenData[_tokenIdIncremented].owner == address(0)) {
115                 if (tokenId_ < nextTokenId - 1) {
116                     _tokenData[_tokenIdIncremented] = _TokenData;
117                 }
118             }
119         }
120         
121         _balanceData[_owner].balance--;
122         emit Transfer(_owner, address(0), tokenId_);
123         totalBurned++;
124     }}
125 
126     function _transfer(address from_, address to_, uint256 tokenId_, bool checkApproved_) internal virtual { unchecked {
127         require(to_ != address(0), "_transfer to 0x0");
128         TokenData memory _TokenData = _getTokenDataOf(tokenId_);
129         address _owner = _TokenData.owner;
130         require(from_ == _owner, "_transfer not from owner");
131         if (checkApproved_) require(_isApprovedOrOwner(_owner, msg.sender, tokenId_), "_transfer not approved");
132         delete getApproved[tokenId_];
133         _tokenData[tokenId_].owner = to_;
134         _tokenData[tokenId_].lastTransfer = uint40(block.timestamp);
135         _tokenData[tokenId_].nextInitialized = true;
136         
137         if (!_TokenData.nextInitialized) {
138             uint256 _tokenIdIncremented = tokenId_ + 1;
139             if (_tokenData[_tokenIdIncremented].owner == address(0)) {
140                 if (tokenId_ < nextTokenId - 1) {
141                     _tokenData[_tokenIdIncremented] = _TokenData;
142                 }
143             }
144         }
145 
146         _balanceData[from_].balance--;
147         _balanceData[to_].balance++;
148         emit Transfer(from_, to_, tokenId_);
149     }}
150 
151     function _setOperatorlist(address operator, bool status) internal virtual {
152         operatorList[operator] = status;
153     }
154 
155     function transferFrom(address from_, address to_, uint256 tokenId_) public virtual {
156         _transfer(from_, to_, tokenId_, true);
157     }
158 
159     function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public virtual {
160         transferFrom(from_, to_, tokenId_);
161         require(to_.code.length == 0 || ERC721TokenReceiver(to_).onERC721Received(msg.sender, from_, tokenId_, data_) ==
162         ERC721TokenReceiver.onERC721Received.selector, "safeTransferFrom to unsafe address");
163     }
164 
165     function safeTransferFrom(address from_, address to_, uint256 tokenId_) public virtual {
166         safeTransferFrom(from_, to_, tokenId_, "");
167     }
168 
169     function approve(address spender_, uint256 tokenId_) public virtual {
170         address _owner = ownerOf(tokenId_);
171         require(operatorList[spender_], "operator is not on the list");
172         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender], "approve not authorized!");
173         getApproved[tokenId_] = spender_;
174         emit Approval(_owner, spender_, tokenId_);
175     }
176 
177     function setApprovalForAll(address operator_, bool approved_) public virtual {
178         require(operatorList[operator_], "operator is not on the list");
179         isApprovedForAll[msg.sender][operator_] = approved_;
180         emit ApprovalForAll(msg.sender, operator_, approved_);
181     }
182 
183     function _isApprovedOrOwner(address owner_, address spender_, uint256 tokenId_) internal virtual view returns (bool) {
184         return (owner_ == spender_ || getApproved[tokenId_] == spender_ || isApprovedForAll[owner_][spender_]);
185     }
186 
187     function supportsInterface(bytes4 id_) public virtual view returns (bool) {
188         return  id_ == 0x01ffc9a7 || id_ == 0x80ac58cd || id_ == 0x5b5e139f;
189     }
190 
191     function _setBaseTokenURI(string memory uri_) internal virtual { 
192         baseTokenURI = uri_; 
193     }
194 
195     function _setBaseTokenURIEXT(string memory uri_) internal virtual { 
196         baseTokenURI_EXT = uri_; 
197     }
198 
199     function _toString(uint256 value_) internal pure virtual returns (string memory _str) {
200         assembly {
201             let m := add(mload(0x40), 0xa0)
202             mstore(0x40, m)
203             _str := sub(m, 0x20)
204             mstore(_str, 0)
205             let end := _str
206             for { let temp := value_ } 1 {} {
207                 _str := sub(_str, 1)
208                 mstore8(_str, add(48, mod(temp, 10)))
209                 temp := div(temp, 10)
210                 if iszero(temp) { break }
211             }
212             let length := sub(end, _str)
213             _str := sub(_str, 0x20)
214             mstore(_str, length)
215         }
216     }
217 
218     function _getURI(uint256 tokenId_) internal virtual view returns (string memory) {
219         return string(abi.encodePacked(baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
220     }
221 
222     function tokenURI(uint256 tokenId_) public virtual view returns (string memory);
223 }
224 
225 interface IOperatorFilterRegistry {
226     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
227     function register(address registrant) external;
228     function registerAndSubscribe(address registrant, address subscription) external;
229     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
230     function unregister(address addr) external;
231     function updateOperator(address registrant, address operator, bool filtered) external;
232     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
233     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
234     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
235     function subscribe(address registrant, address registrantToSubscribe) external;
236     function unsubscribe(address registrant, bool copyExistingEntries) external;
237     function subscriptionOf(address addr) external returns (address registrant);
238     function subscribers(address registrant) external returns (address[] memory);
239     function subscriberAt(address registrant, uint256 index) external returns (address);
240     function copyEntriesOf(address registrant, address registrantToCopy) external;
241     function isOperatorFiltered(address registrant, address operator) external returns (bool);
242     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
243     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
244     function filteredOperators(address addr) external returns (address[] memory);
245     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
246     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
247     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
248     function isRegistered(address addr) external returns (bool);
249     function codeHashOf(address addr) external returns (bytes32);
250 }
251 
252 abstract contract OperatorFilterer {
253     error OperatorNotAllowed(address operator);
254     IOperatorFilterRegistry constant operatorFilterRegistry = IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
255     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
256         if (address(operatorFilterRegistry).code.length > 0) {
257             if (subscribe) {
258                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
259             } else {
260                 if (subscriptionOrRegistrantToCopy != address(0)) {
261                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
262                 } else {
263                     operatorFilterRegistry.register(address(this));
264                 }
265             }
266         }
267     }
268     modifier onlyAllowedOperator(address from) virtual {
269         if (address(operatorFilterRegistry).code.length > 0) {
270             if (from == msg.sender) { _; return ; }
271             if (!(operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender) && operatorFilterRegistry.isOperatorAllowed(address(this), from))) {
272                 revert OperatorNotAllowed(msg.sender);
273         }}_;
274     }
275 }
276 
277 abstract contract OwnControll {
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279     event AdminSet(bytes32 indexed controllerType, bytes32 indexed controllerSlot, address indexed controller, bool status);
280     address public owner;
281     mapping(bytes32 => mapping(address => bool)) internal admin;
282     constructor() { owner = msg.sender; }
283     modifier onlyOwner() { require(owner == msg.sender, "only owner");_; }
284     modifier onlyAdmin(string memory type_) { require(isAdmin(type_, msg.sender), "only admin");_; }
285     function transferOwnership(address newOwner) external onlyOwner { emit OwnershipTransferred(owner, newOwner); owner = newOwner; }
286     function setAdmin(string calldata type_, address controller, bool status) external onlyOwner { bytes32 typeHash = keccak256(abi.encodePacked(type_)); admin[typeHash][controller] = status; emit AdminSet(typeHash, typeHash, controller, status); }
287     function isAdmin(string memory type_, address controller) public view returns (bool) { bytes32 typeHash = keccak256(abi.encodePacked(type_)); return admin[typeHash][controller]; }
288 }
289 
290 abstract contract MerkleProof {
291     mapping(uint256 => bytes32) internal _merkleRoot;
292     function _setMerkleRoot(uint256 type_, bytes32 merkleRoot_) internal virtual { _merkleRoot[type_] = merkleRoot_; }
293     function isWhitelisted(uint256 type_, address address_, bytes32[] memory proof_) public view returns (bool) {
294         bytes32 _leaf = keccak256(abi.encodePacked(address_));
295         for (uint256 i = 0; i < proof_.length; i++) { 
296             _leaf = _leaf < proof_[i] ? 
297             keccak256(abi.encodePacked(_leaf, proof_[i])) : 
298             keccak256(abi.encodePacked(proof_[i], _leaf)); 
299         }
300         return _leaf == _merkleRoot[type_];
301     }
302 }
303 
304 interface IMetadata {
305     function tokenURI(uint256 tokenId_) external view returns (string memory);
306 }
307 
308 interface INTP {
309     function ownerOf(uint256 tokenId_) external view returns (address);
310     function balanceOf(address address_) external view returns (uint256);
311 }
312 
313 contract ROARS is ERC721, OwnControll, MerkleProof, OperatorFilterer {
314 
315     address public metadata;
316     bool public useMetadata;
317 
318     mapping(uint256 => uint256) private claim;
319     mapping(address => uint256) private mintedP1;
320     mapping(address => uint256) private mintedP2;
321     modifier onlySender() { require(msg.sender == tx.origin, "No smart contract");_; }
322 
323     uint8 public saleState;
324     uint256 public phase1Price = 0.01 ether;
325     uint256 public phase2Price = 0.02 ether;
326     uint256 public constant maxToken = 12345;
327 
328     INTP public NTP = INTP(0xA65bA71d653f62c64d97099b58D25a955Eb374a0);
329 
330     constructor() ERC721("ROARS", "ROARS") OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), true) {}
331 
332     function ownerMint(address[] calldata addresses_, uint256[] calldata amounts_) external onlyOwner {
333         uint256 l = addresses_.length;
334         uint256 i; unchecked { do { 
335             _mint(addresses_[i], amounts_[i]);
336         } while (++i < l); }
337     }
338 
339     /// Phase1 sale
340     function phase1SaleAL1(uint256[] calldata tokenIds_, uint256 amount_) external payable onlySender {
341         require(saleState == 1, "Sale not active");
342         uint256 l = tokenIds_.length;
343         uint256 i; unchecked { do {
344             require(NTP.ownerOf(tokenIds_[i]) == msg.sender, "Not Owner of token");
345             require(claim[tokenIds_[i]] == 0, "claimed");
346             claim[tokenIds_[i]]++;
347         } while (++i < l); }
348         require(l * 3 >= amount_, "Exceed max claim per NFT");
349         require(amount_ + totalSupply() <= maxToken, "No more NFTs");
350         require(msg.value == phase1Price * amount_, "Value sent is not correct");
351         _mint(msg.sender, amount_);
352     }
353 
354     function phase1SaleAL3(bytes32[] memory proof_) external payable onlySender {
355         require(saleState == 1, "Sale not active");
356         require(1 + totalSupply() <= maxToken, "No more NFTs");
357         require(isWhitelisted(1, msg.sender, proof_), "You are not whitelisted!");
358         require(msg.value == phase2Price, "Value sent is not correct");
359         require(mintedP1[msg.sender] == 0, "1 max per address");
360         mintedP1[msg.sender]++;
361         _mint(msg.sender, 1);
362     }
363 
364     /// Phase2 sale
365     function phase2Sale(uint256 amount_, bytes32[] memory proof_) external payable onlySender {
366         require(saleState == 2, "Sale not active");
367         require(amount_ + totalSupply() <= maxToken, "No more NFTs");
368         require(isWhitelisted(2, msg.sender, proof_), "You are not whitelisted!");
369         require(msg.value == phase2Price * amount_, "Value sent is not correct");
370         require(4 > mintedP2[msg.sender] + amount_, "3 max per address");
371         require(4 > amount_, "3 max per tx");
372         mintedP2[msg.sender] += amount_;
373         _mint(msg.sender, amount_);
374     }
375 
376     /// Phase3 sale
377     function phase3Sale(uint256 amount_, bytes32[] memory proof_) external payable onlySender {
378         require(saleState == 3, "Sale not active");
379         require(isWhitelisted(3, msg.sender, proof_), "You are not whitelisted!");
380         require(msg.value == phase2Price * amount_, "Value sent is not correct");
381         require(amount_ + totalSupply() <= maxToken, "No more NFTs");
382         require(6 > amount_, "5 max per tx");
383         _mint(msg.sender, amount_);
384     }
385 
386     function mint(address address_, uint256 amount_) external onlyAdmin("MINTER") {
387         _mint(address_, amount_);
388     }
389 
390     function burn(uint256 tokenId_, bool checkApproved_) external onlyAdmin("BURNER") {
391         _burn(tokenId_, checkApproved_);
392     }
393 
394     function setMerkleRoot(uint256 type_, bytes32 merkleRoot_) external onlyAdmin("ADMIN") {
395         _setMerkleRoot(type_, merkleRoot_);
396     }
397 
398     function setSaleState(uint8 state_) external onlyAdmin("ADMIN") {
399         saleState = state_;
400     }
401 
402     function setSalePrice1(uint256 price_) external onlyAdmin("ADMIN") {
403         phase1Price = price_;
404     }
405 
406     function setSalePrice2(uint256 price_) external onlyAdmin("ADMIN") {
407         phase2Price = price_;
408     }
409 
410     function setOperatorlist(address address_, bool status) external onlyAdmin("ADMIN") {
411         _setOperatorlist(address_, status);
412     }
413 
414     function setBaseTokenURI(string calldata uri_) external onlyAdmin("ADMIN") {
415         _setBaseTokenURI(uri_);
416     }
417 
418     function setBaseTokenURIEXT(string calldata uri_) external onlyAdmin("ADMIN") {
419         _setBaseTokenURIEXT(uri_);
420     }
421 
422     function setMetadata(address address_) external onlyAdmin("ADMIN") {
423         metadata = address_;
424     }
425 
426     function setUseMetadata(bool bool_) external onlyAdmin("ADMIN") {
427         useMetadata = bool_;
428     }
429 
430     function seeClaim(uint256 tokenId_) public view returns (uint256) {
431         return claim[tokenId_];
432     }
433 
434     function startTokenId() public pure virtual override returns (uint256) {
435         return 1;
436     }
437 
438     function tokenURI(uint256 tokenId_) public view override returns (string memory) {
439         if (!useMetadata) {
440             return _getURI(tokenId_);
441         } else {
442             return IMetadata(metadata).tokenURI(tokenId_);
443         }
444     }
445 
446     function withdraw() public onlyOwner {
447         uint256 balance = address(this).balance;
448         payable(msg.sender).transfer(balance);
449     }
450 
451     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
452         super.transferFrom(from, to, tokenId);
453     }
454 
455     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
456         super.safeTransferFrom(from, to, tokenId);
457     }
458 
459     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
460         super.safeTransferFrom(from, to, tokenId, data);
461     }
462 }