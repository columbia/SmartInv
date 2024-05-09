1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*  ERC721I - ERC721I (ERC721 0xInuarashi Edition) - Gas Optimized
5     Contributors: 0xInuarashi (Message to Martians, Anonymice), 0xBasset (Ether Orcs) */
6 
7 contract ERC721I {
8 
9     string public name; string public symbol;
10     string internal baseTokenURI; string internal baseTokenURI_EXT;
11     constructor(string memory name_, string memory symbol_) { name = name_; symbol = symbol_; }
12 
13     uint256 public totalSupply; 
14     mapping(uint256 => address) public ownerOf; 
15     mapping(address => uint256) public balanceOf; 
16 
17     mapping(uint256 => address) public getApproved; 
18     mapping(address => mapping(address => bool)) public isApprovedForAll; 
19 
20     // Events
21     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
22     event Mint(address indexed to, uint256 tokenId);
23     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
24     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
25 
26     // // internal write functions
27     // mint
28     function _mint(address to_, uint256 tokenId_) internal virtual {
29         require(to_ != address(0x0), "ERC721I: _mint() Mint to Zero Address");
30         require(ownerOf[tokenId_] == address(0x0), "ERC721I: _mint() Token to Mint Already Exists!");
31 
32         // ERC721I Starts Here
33         ownerOf[tokenId_] = to_;
34         balanceOf[to_]++;
35         totalSupply++; 
36         // ERC721I Ends Here
37 
38         emit Transfer(address(0x0), to_, tokenId_);
39         emit Mint(to_, tokenId_);
40     }
41 
42     // transfer
43     function _transfer(address from_, address to_, uint256 tokenId_) internal virtual {
44         require(from_ == ownerOf[tokenId_], "ERC721I: _transfer() Transfer Not Owner of Token!");
45         require(to_ != address(0x0), "ERC721I: _transfer() Transfer to Zero Address!");
46 
47         // ERC721I Starts Here
48         // checks if there is an approved address clears it if there is
49         if (getApproved[tokenId_] != address(0x0)) { 
50             _approve(address(0x0), tokenId_); 
51         } 
52 
53         ownerOf[tokenId_] = to_; 
54         balanceOf[from_]--;
55         balanceOf[to_]++;
56         // ERC721I Ends Here
57 
58         emit Transfer(from_, to_, tokenId_);
59     }
60 
61     // approve
62     function _approve(address to_, uint256 tokenId_) internal virtual {
63         if (getApproved[tokenId_] != to_) {
64             getApproved[tokenId_] = to_;
65             emit Approval(ownerOf[tokenId_], to_, tokenId_);
66         }
67     }
68     function _setApprovalForAll(address owner_, address operator_, bool approved_) internal virtual {
69         require(owner_ != operator_, "ERC721I: _setApprovalForAll() Owner must not be the Operator!");
70         isApprovedForAll[owner_][operator_] = approved_;
71         emit ApprovalForAll(owner_, operator_, approved_);
72     }
73 
74     // token uri
75     function _setBaseTokenURI(string memory uri_) internal virtual {
76         baseTokenURI = uri_;
77     }
78     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
79         baseTokenURI_EXT = ext_;
80     }
81 
82     // // Internal View Functions
83     // Embedded Libraries
84     function _toString(uint256 value_) internal pure returns (string memory) {
85         if (value_ == 0) { return "0"; }
86         uint256 _iterate = value_; uint256 _digits;
87         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
88         bytes memory _buffer = new bytes(_digits);
89         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
90         return string(_buffer); // return string converted bytes of value_
91     }
92 
93     // Functional Views
94     function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal view virtual returns (bool) {
95         require(ownerOf[tokenId_] != address(0x0), "ERC721I: _isApprovedOrOwner() Owner is Zero Address!");
96         address _owner = ownerOf[tokenId_];
97         return (spender_ == _owner || spender_ == getApproved[tokenId_] || isApprovedForAll[_owner][spender_]);
98     }
99     function _exists(uint256 tokenId_) internal view virtual returns (bool) {
100         return ownerOf[tokenId_] != address(0x0);
101     }
102 
103     // // public write functions
104     function approve(address to_, uint256 tokenId_) public virtual {
105         address _owner = ownerOf[tokenId_];
106         require(to_ != _owner, "ERC721I: approve() Cannot approve yourself!");
107         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender], "ERC721I: Caller not owner or Approved!");
108         _approve(to_, tokenId_);
109     }
110     function setApprovalForAll(address operator_, bool approved_) public virtual {
111         _setApprovalForAll(msg.sender, operator_, approved_);
112     }
113     function transferFrom(address from_, address to_, uint256 tokenId_) public virtual {
114         require(_isApprovedOrOwner(msg.sender, tokenId_), "ERC721I: transferFrom() _isApprovedOrOwner = false!");
115         _transfer(from_, to_, tokenId_);
116     }
117     function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public virtual {
118         _transfer(from_, to_, tokenId_);
119         if (to_.code.length != 0) {
120             (, bytes memory _returned) = to_.staticcall(abi.encodeWithSelector(0x150b7a02, msg.sender, from_, tokenId_, data_));
121             bytes4 _selector = abi.decode(_returned, (bytes4));
122             require(_selector == 0x150b7a02, "ERC721I: safeTransferFrom() to_ not ERC721Receivable!");
123         }
124     }
125     function safeTransferFrom(address from_, address to_, uint256 tokenId_) public virtual {
126         safeTransferFrom(from_, to_, tokenId_, "");
127     }
128 
129     // 0xInuarashi Custom Functions
130     function multiTransferFrom(address from_, address to_, uint256[] memory tokenIds_) public virtual {
131         for (uint256 i = 0; i < tokenIds_.length; i++) {
132             transferFrom(from_, to_, tokenIds_[i]);
133         }
134     }
135     function multiSafeTransferFrom(address from_, address to_, uint256[] memory tokenIds_, bytes memory data_) public virtual {
136         for (uint256 i = 0; i < tokenIds_.length; i++) {
137             safeTransferFrom(from_, to_, tokenIds_[i], data_);
138         }
139     }
140 
141     // OZ Standard Stuff
142     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
143         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
144     }
145 
146     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
147         require(ownerOf[tokenId_] != address(0x0), "ERC721I: tokenURI() Token does not exist!");
148         return string(abi.encodePacked(baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
149     }
150     // // public view functions
151     // never use these for functions ever, they are expensive af and for view only (this will be an issue in the future for interfaces)
152     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
153         uint256 _balance = balanceOf[address_];
154         uint256[] memory _tokens = new uint256[] (_balance);
155         uint256 _index;
156         uint256 _loopThrough = totalSupply;
157         for (uint256 i = 0; i < _loopThrough; i++) {
158             if (ownerOf[i] == address(0x0) && _tokens[_balance - 1] == 0) { _loopThrough++; }
159             if (ownerOf[i] == address_) { _tokens[_index] = i; _index++; }
160         }
161         return _tokens;
162     }
163 }
164 
165 abstract contract MerkleWhitelist {
166     bytes32 internal _merkleRoot;
167     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
168         _merkleRoot = merkleRoot_;
169     }
170     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
171         bytes32 _leaf = keccak256(abi.encodePacked(address_));
172         for (uint256 i = 0; i < proof_.length; i++) {
173             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
174         }
175         return _leaf == _merkleRoot;
176     }
177 }
178 
179 abstract contract Security {
180     // Prevent Smart Contracts
181     modifier onlySender {
182         require(msg.sender == tx.origin, "No Smart Contracts!"); _; }
183 }
184 
185 abstract contract Ownable {
186     address public owner;
187     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
188     constructor() { owner = msg.sender; }
189     modifier onlyOwner {
190         require(owner == msg.sender, "Ownable: caller is not the owner");
191         _;
192     }
193     function _transferOwnership(address newOwner_) internal virtual {
194         address _oldOwner = owner;
195         owner = newOwner_;
196         emit OwnershipTransferred(_oldOwner, newOwner_);    
197     }
198     function transferOwnership(address newOwner_) public virtual onlyOwner {
199         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
200         _transferOwnership(newOwner_);
201     }
202     function renounceOwnership() public virtual onlyOwner {
203         _transferOwnership(address(0x0));
204     }
205 }
206 
207 // Open0x Payable Governance Module by 0xInuarashi
208 // This abstract contract utilizes for loops in order to iterate things in order to be modular
209 // It is not the most gas-effective implementation. 
210 // We sacrified gas-effectiveness for Modularity instead.
211 abstract contract PayableGovernance is Ownable {
212     // Special Access
213     address _payableGovernanceSetter;
214     constructor() payable { _payableGovernanceSetter = msg.sender; }
215     modifier onlyPayableGovernanceSetter {
216         require(msg.sender == _payableGovernanceSetter, "PayableGovernance: Caller is not Setter!"); _; }
217     function reouncePayableGovernancePermissions() public onlyPayableGovernanceSetter {
218         _payableGovernanceSetter = address(0x0); }
219 
220     // Receivable Fallback
221     event Received(address from, uint amount);
222     receive() external payable { emit Received(msg.sender, msg.value); }
223 
224     // Required Variables
225     address payable[] internal _payableGovernanceAddresses;
226     uint256[] internal _payableGovernanceShares;    
227     mapping(address => bool) public addressToEmergencyUnlocked;
228 
229     // Withdraw Functionality
230     function _withdraw(address payable address_, uint256 amount_) internal {
231         (bool success, ) = payable(address_).call{value: amount_}("");
232         require(success, "Transfer failed");
233     }
234 
235     // Governance Functions
236     function setPayableGovernanceShareholders(address payable[] memory addresses_, uint256[] memory shares_) public onlyPayableGovernanceSetter {
237         require(_payableGovernanceAddresses.length == 0 && _payableGovernanceShares.length == 0, "Payable Governance already set! To set again, reset first!");
238         require(addresses_.length == shares_.length, "Address and Shares length mismatch!");
239         uint256 _totalShares;
240         for (uint256 i = 0; i < addresses_.length; i++) {
241             _totalShares += shares_[i];
242             _payableGovernanceAddresses.push(addresses_[i]);
243             _payableGovernanceShares.push(shares_[i]);
244         }
245         require(_totalShares == 1000, "Total Shares is not 1000!");
246     }
247     function resetPayableGovernanceShareholders() public onlyPayableGovernanceSetter {
248         while (_payableGovernanceAddresses.length != 0) {
249             _payableGovernanceAddresses.pop(); }
250         while (_payableGovernanceShares.length != 0) {
251             _payableGovernanceShares.pop(); }
252     }
253 
254     // Governance View Functions
255     function balance() public view returns (uint256) {
256         return address(this).balance;
257     }
258     function payableGovernanceAddresses() public view returns (address payable[] memory) {
259         return _payableGovernanceAddresses;
260     }
261     function payableGovernanceShares() public view returns (uint256[] memory) {
262         return _payableGovernanceShares;
263     }
264 
265     // Withdraw Functions
266     function withdrawEther() public onlyOwner {
267         // require that there has been payable governance set.
268         require(_payableGovernanceAddresses.length > 0 && _payableGovernanceShares.length > 0, "Payable governance not set yet!");
269          // this should never happen
270         require(_payableGovernanceAddresses.length == _payableGovernanceShares.length, "Payable governance length mismatch!");
271         
272         // now, we check that the governance shares equal to 1000.
273         uint256 _totalPayableShares;
274         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
275             _totalPayableShares += _payableGovernanceShares[i]; }
276         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
277         
278         // // now, we start the withdrawal process if all conditionals pass
279         // store current balance in local memory
280         uint256 _totalETH = address(this).balance; 
281 
282         // withdraw loop for payable governance
283         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
284             uint256 _ethToWithdraw = ((_totalETH * _payableGovernanceShares[i]) / 1000);
285             _withdraw(_payableGovernanceAddresses[i], _ethToWithdraw);
286         }
287     }
288 
289     function viewWithdrawAmounts() public view onlyOwner returns (uint256[] memory) {
290         // require that there has been payable governance set.
291         require(_payableGovernanceAddresses.length > 0 && _payableGovernanceShares.length > 0, "Payable governance not set yet!");
292          // this should never happen
293         require(_payableGovernanceAddresses.length == _payableGovernanceShares.length, "Payable governance length mismatch!");
294         
295         // now, we check that the governance shares equal to 1000.
296         uint256 _totalPayableShares;
297         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
298             _totalPayableShares += _payableGovernanceShares[i]; }
299         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
300         
301         // // now, we start the array creation process if all conditionals pass
302         // store current balance in local memory and instantiate array for input
303         uint256 _totalETH = address(this).balance; 
304         uint256[] memory _withdrawals = new uint256[] (_payableGovernanceAddresses.length + 2);
305 
306         // array creation loop for payable governance values 
307         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
308             _withdrawals[i] = ( (_totalETH * _payableGovernanceShares[i]) / 1000 );
309         }
310         
311         // push two last array spots as total eth and added eths of withdrawals
312         _withdrawals[_payableGovernanceAddresses.length] = _totalETH;
313         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
314             _withdrawals[_payableGovernanceAddresses.length + 1] += _withdrawals[i]; }
315 
316         // return the final array data
317         return _withdrawals;
318     }
319 
320     // Shareholder Governance
321     modifier onlyShareholder {
322         bool _isShareholder;
323         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
324             if (msg.sender == _payableGovernanceAddresses[i]) {
325                 _isShareholder = true;
326             }
327         }
328         require(_isShareholder, "You are not a shareholder!");
329         _;
330     }
331     function unlockEmergencyFunctionsAsShareholder() public onlyShareholder {
332         addressToEmergencyUnlocked[msg.sender] = true;
333     }
334 
335     // Emergency Functions
336     modifier onlyEmergency {
337         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
338             require(addressToEmergencyUnlocked[_payableGovernanceAddresses[i]], "Emergency Functions are not unlocked!");
339         }
340         _;
341     }
342     function emergencyWithdrawEther() public onlyOwner onlyEmergency {
343         _withdraw(payable(msg.sender), address(this).balance);
344     }
345 }
346 
347 abstract contract PublicMint {
348     // Public Minting
349     bool public _publicMint; uint256 public _publicMintTime;
350     function _setPublicMint(bool bool_, uint256 time_) internal {
351         _publicMint = bool_; _publicMintTime = time_; }
352     modifier publicMintEnabled { 
353         require(_publicMint && _publicMintTime <= block.timestamp, 
354             "Public Mint is not enabled yet!"); _; }
355     function publicMintStatus() external view returns (bool) {
356         return _publicMint && _publicMintTime <= block.timestamp; }
357 }
358 
359 abstract contract WhitelistMint {
360     // Whitelist Minting
361     bool internal _whitelistMint; uint256 public _whitelistMintTime;
362     function _setWhitelistMint(bool bool_, uint256 time_) internal {
363         _whitelistMint = bool_; _whitelistMintTime = time_; }
364     modifier whitelistMintEnabled {
365         require(_whitelistMint && _whitelistMintTime <= block.timestamp, 
366             "Whitelist Mint is not enabled yet!"); _; } 
367     function whitelistMintStatus() external view returns (bool) {
368         return _whitelistMint && _whitelistMintTime <= block.timestamp; }
369 }
370 
371 abstract contract SatelliteMint {
372     // Satellite Minting
373     bool internal _satelliteMintEnabled; uint256 public _satelliteMintTime;
374     function _setSatelliteMint(bool bool_, uint256 time_) internal {
375         _satelliteMintEnabled = bool_; _satelliteMintTime = time_; }
376     modifier satelliteMintEnabled {
377         require(_satelliteMintEnabled && _satelliteMintTime <= block.timestamp, 
378             "Satellite Mint is not enabled yet!"); _; } 
379     function satelliteMintStatus() external view returns (bool) {
380         return _satelliteMintEnabled && _satelliteMintTime <= block.timestamp; }
381 }
382 
383 abstract contract SatelliteReceiver {
384     // DO NOT CHANGE THIS
385     address public satelliteStationAddress = 0x69F7f7053024cd5923A11718F3A28cC62F2AF3a7;
386     uint256 public SSTokensMinted = 0;
387 
388     // YOU CAN CONFIGURE THIS YOURSELF
389     address public SSTokenReceiver = 0x05b19Db67f83850fd79FDd308eaEDAA8fd9d8381;
390     address public SSTokenAddress = 0x984b6968132DA160122ddfddcc4461C995741513;
391     uint256 public SSTokensPerMint = 20 ether;
392     uint256 public SSTokensAvailable = 25;
393     uint256 public SSMintsPerAddress = 1;
394     
395     mapping(address => uint256) public SSAddressToMints;
396 
397     function _satelliteMint(uint256 amount_) internal {
398         require(msg.sender == satelliteStationAddress, "_satelliteMint: msg.sender is not Satellite Station!");
399         require(SSTokensAvailable >= SSTokensMinted + amount_, "_satelliteMint: amount_ requested over maximum avaialble tokens!");
400         require(SSMintsPerAddress >= SSAddressToMints[tx.origin] + amount_, "_satelliteMint: amount exceeds mints available per address!");
401 
402         SSAddressToMints[tx.origin] += amount_;
403         SSTokensMinted += amount_;
404     }
405 }
406 
407 interface iPlasma {
408     function updateReward(address address_) external;
409 }
410 
411 contract SpaceYetis is ERC721I, MerkleWhitelist, Security, Ownable, SatelliteReceiver, SatelliteMint, PayableGovernance, PublicMint, WhitelistMint {
412     constructor() ERC721I("Space Yetis", "YETI") {}
413 
414     // General NFT Variables
415     uint256 public maxSupply = 4444;
416     uint256 public mintPrice = 0.08 ether;
417     uint256 public publicMaxMintsPerTx = 5;
418 
419     // Token Yield Variables
420     address public plasmaAddress;
421     iPlasma public Plasma;
422     function setPlasma(address address_) external onlyOwner { plasmaAddress = address_; Plasma = iPlasma(address_); }
423 
424     // Contract Administration
425     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner { _setMerkleRoot(merkleRoot_); }
426     function setMintPrice(uint256 mintPrice_) external onlyOwner { mintPrice = mintPrice_; }
427 
428     function setSatelliteMint(bool bool_, uint256 time_) external onlyOwner { _setSatelliteMint(bool_, time_); }
429     function setWhitelisMint(bool bool_, uint256 time_) external onlyOwner { _setWhitelistMint(bool_, time_); }
430     function setPublicMint(bool bool_, uint256 time_) external onlyOwner { _setPublicMint(bool_, time_); }
431     
432     // Internal Functions
433     function _mintMany(address to_, uint256 amount_) internal {
434         require(maxSupply >= totalSupply + amount_, "_mintMany: amount exceeds maxSupply");
435         for (uint256 i = 0; i < amount_; i++) {
436             _mint(to_, (totalSupply + 1)); // iterate from 1
437         }
438         Plasma.updateReward(to_);
439     }
440 
441     // Onwer Mint
442     function ownerMintMany(address[] memory tos_, uint256[] memory amounts_) external onlyOwner {
443         require(tos_.length == amounts_.length, "ownerMintMany: array length mismatch!");
444         for (uint256 i = 0; i < tos_.length; i++) { 
445             _mintMany(tos_[i], amounts_[i]); 
446         }
447     }
448 
449     // Satellite Mint
450     function satelliteMint(uint256 amount_) external satelliteMintEnabled {
451         require(SSMintsPerAddress >= amount_, "Over maximum mints per address for Satellite Mints!");
452         _satelliteMint(amount_);
453         _mintMany(tx.origin, amount_);
454     }
455 
456     // Whitelist Mint
457     uint256 public maxMintsPerWL = 3;
458     mapping(address => uint256) public addressToWLMinted; 
459     
460     function whitelistMint(uint256 amount_, bytes32[] memory proof_) external payable onlySender whitelistMintEnabled {
461         require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
462         require(maxMintsPerWL >= amount_, "Maximum 3 mints per tx for whitelist!");
463         require(maxMintsPerWL >= addressToWLMinted[msg.sender] + amount_, "Amount exceeds available for whitelist!");
464         require(msg.value == mintPrice * amount_, "Invalid value sent!");
465 
466         addressToWLMinted[msg.sender] += amount_;
467 
468         _mintMany(msg.sender, amount_);
469     }
470 
471     // Public Mint
472     function mint(uint256 amount_) external payable onlySender publicMintEnabled {
473         require(publicMaxMintsPerTx >= amount_, "Maximum 5 mints per tx!");
474         require(msg.value == mintPrice * amount_, "Invalid value sent!");
475         _mintMany(msg.sender, amount_);
476     }
477 
478     // Token Overrides for Transfer-Hook token yield
479     function __yieldTransferHook(address from_, address to_) internal {
480         Plasma.updateReward(from_); 
481         Plasma.updateReward(to_); 
482     }
483     function transferFrom(address from_, address to_, uint256 tokenId_) public override {
484         __yieldTransferHook(from_, to_);
485         ERC721I.transferFrom(from_, to_, tokenId_);
486     }
487     function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public override {
488         __yieldTransferHook(from_, to_);
489         ERC721I.safeTransferFrom(from_, to_, tokenId_, data_);
490     }
491 
492     // TokenURI Stuffs
493     function setBaseTokenURI(string memory uri_) external onlyOwner {
494         _setBaseTokenURI(uri_);
495     }
496     function setBaseTokenURI_EXT(string memory ext_) external onlyOwner {
497         _setBaseTokenURI_EXT(ext_);
498     }
499 }