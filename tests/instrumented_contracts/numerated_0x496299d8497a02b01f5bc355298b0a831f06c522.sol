1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /* ERC721I - ERC721I (ERC721 0xInuarashi Edition) - Gas Optimized
5     Author: 0xInuarashi || https://twitter.com/0xinuarashi 
6     Open Source: with the efforts of the [0x Collective] <3 */
7 
8 contract ERC721I {
9 
10     string public name; string public symbol;
11     string internal baseTokenURI; string internal baseTokenURI_EXT;
12     constructor(string memory name_, string memory symbol_) { name = name_; symbol = symbol_; }
13 
14     uint256 public totalSupply; 
15     mapping(uint256 => address) public ownerOf; 
16     mapping(address => uint256) public balanceOf; 
17 
18     mapping(uint256 => address) public getApproved; 
19     mapping(address => mapping(address => bool)) public isApprovedForAll; 
20 
21     // Events
22     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
23     event Mint(address indexed to, uint256 tokenId);
24     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
25     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
26 
27     // // internal write functions
28     // mint
29     function _mint(address to_, uint256 tokenId_) internal virtual {
30         require(to_ != address(0x0), "ERC721I: _mint() Mint to Zero Address");
31         require(ownerOf[tokenId_] == address(0x0), "ERC721I: _mint() Token to Mint Already Exists!");
32 
33         // ERC721I Starts Here
34         balanceOf[to_]++;
35         ownerOf[tokenId_] = to_;
36 
37         // totalSupply++; // I removed this for a bit better gas management on multi-mints ~ 0xInuarashi
38         
39         // ERC721I Ends Here
40 
41         emit Transfer(address(0x0), to_, tokenId_);
42         
43         // emit Mint(to_, tokenId_); // I removed this for a bit better gas management on multi-mints ~ 0xInuarashi
44     }
45 
46     // transfer
47     function _transfer(address from_, address to_, uint256 tokenId_) internal virtual {
48         require(from_ == ownerOf[tokenId_], "ERC721I: _transfer() Transfer Not Owner of Token!");
49         require(to_ != address(0x0), "ERC721I: _transfer() Transfer to Zero Address!");
50 
51         // ERC721I Starts Here
52         // checks if there is an approved address clears it if there is
53         if (getApproved[tokenId_] != address(0x0)) { 
54             _approve(address(0x0), tokenId_); 
55         } 
56 
57         ownerOf[tokenId_] = to_; 
58         balanceOf[from_]--;
59         balanceOf[to_]++;
60         // ERC721I Ends Here
61 
62         emit Transfer(from_, to_, tokenId_);
63     }
64 
65     // approve
66     function _approve(address to_, uint256 tokenId_) internal virtual {
67         if (getApproved[tokenId_] != to_) {
68             getApproved[tokenId_] = to_;
69             emit Approval(ownerOf[tokenId_], to_, tokenId_);
70         }
71     }
72     function _setApprovalForAll(address owner_, address operator_, bool approved_) internal virtual {
73         require(owner_ != operator_, "ERC721I: _setApprovalForAll() Owner must not be the Operator!");
74         isApprovedForAll[owner_][operator_] = approved_;
75         emit ApprovalForAll(owner_, operator_, approved_);
76     }
77 
78     // token uri
79     function _setBaseTokenURI(string memory uri_) internal virtual {
80         baseTokenURI = uri_;
81     }
82     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
83         baseTokenURI_EXT = ext_;
84     }
85 
86     // // Internal View Functions
87     // Embedded Libraries
88     function _toString(uint256 value_) internal pure returns (string memory) {
89         if (value_ == 0) { return "0"; }
90         uint256 _iterate = value_; uint256 _digits;
91         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
92         bytes memory _buffer = new bytes(_digits);
93         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
94         return string(_buffer); // return string converted bytes of value_
95     }
96 
97     // Functional Views
98     function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal view virtual returns (bool) {
99         require(ownerOf[tokenId_] != address(0x0), "ERC721I: _isApprovedOrOwner() Owner is Zero Address!");
100         address _owner = ownerOf[tokenId_];
101         return (spender_ == _owner || spender_ == getApproved[tokenId_] || isApprovedForAll[_owner][spender_]);
102     }
103     function _exists(uint256 tokenId_) internal view virtual returns (bool) {
104         return ownerOf[tokenId_] != address(0x0);
105     }
106 
107     // // public write functions
108     function approve(address to_, uint256 tokenId_) public virtual {
109         address _owner = ownerOf[tokenId_];
110         require(to_ != _owner, "ERC721I: approve() Cannot approve yourself!");
111         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender], "ERC721I: Caller not owner or Approved!");
112         _approve(to_, tokenId_);
113     }
114     function setApprovalForAll(address operator_, bool approved_) public virtual {
115         _setApprovalForAll(msg.sender, operator_, approved_);
116     }
117     function transferFrom(address from_, address to_, uint256 tokenId_) public virtual {
118         require(_isApprovedOrOwner(msg.sender, tokenId_), "ERC721I: transferFrom() _isApprovedOrOwner = false!");
119         _transfer(from_, to_, tokenId_);
120     }
121     function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public virtual {
122         transferFrom(from_, to_, tokenId_);
123         if (to_.code.length != 0) {
124             (, bytes memory _returned) = to_.staticcall(abi.encodeWithSelector(0x150b7a02, msg.sender, from_, tokenId_, data_));
125             bytes4 _selector = abi.decode(_returned, (bytes4));
126             require(_selector == 0x150b7a02, "ERC721I: safeTransferFrom() to_ not ERC721Receivable!");
127         }
128     }
129     function safeTransferFrom(address from_, address to_, uint256 tokenId_) public virtual {
130         safeTransferFrom(from_, to_, tokenId_, "");
131     }
132 
133     // 0xInuarashi Custom Functions
134     function multiTransferFrom(address from_, address to_, uint256[] memory tokenIds_) public virtual {
135         for (uint256 i = 0; i < tokenIds_.length; i++) {
136             transferFrom(from_, to_, tokenIds_[i]);
137         }
138     }
139     function multiSafeTransferFrom(address from_, address to_, uint256[] memory tokenIds_, bytes memory data_) public virtual {
140         for (uint256 i = 0; i < tokenIds_.length; i++) {
141             safeTransferFrom(from_, to_, tokenIds_[i], data_);
142         }
143     }
144 
145     // OZ Standard Stuff
146     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
147         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
148     }
149 
150     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
151         require(ownerOf[tokenId_] != address(0x0), "ERC721I: tokenURI() Token does not exist!");
152         return string(abi.encodePacked(baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
153     }
154     // // public view functions
155     // never use these for functions ever, they are expensive af and for view only (this will be an issue in the future for interfaces)
156     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
157         uint256 _balance = balanceOf[address_];
158         uint256[] memory _tokens = new uint256[] (_balance);
159         uint256 _index;
160         uint256 _loopThrough = totalSupply;
161         for (uint256 i = 0; i < _loopThrough; i++) {
162             if (ownerOf[i] == address(0x0) && _tokens[_balance - 1] == 0) { _loopThrough++; }
163             if (ownerOf[i] == address_) { _tokens[_index] = i; _index++; }
164         }
165         return _tokens;
166     }
167 
168     // so not sure when this will ever be really needed but it conforms to erc721 enumerable
169     function tokenOfOwnerByIndex(address address_, uint256 index_) public virtual view returns (uint256) {
170         uint256[] memory _wallet = walletOfOwner(address_);
171         return _wallet[index_];
172     }
173 }
174 
175 abstract contract Ownable {
176     address public owner;
177     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
178     constructor() { owner = msg.sender; }
179     modifier onlyOwner {
180         require(owner == msg.sender, "Ownable: caller is not the owner");
181         _;
182     }
183     function _transferOwnership(address newOwner_) internal virtual {
184         address _oldOwner = owner;
185         owner = newOwner_;
186         emit OwnershipTransferred(_oldOwner, newOwner_);    
187     }
188     function transferOwnership(address newOwner_) public virtual onlyOwner {
189         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
190         _transferOwnership(newOwner_);
191     }
192     function renounceOwnership() public virtual onlyOwner {
193         _transferOwnership(address(0x0));
194     }
195 }
196 
197 abstract contract MerkleWhitelist {
198     bytes32 internal _merkleRoot;
199     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
200         _merkleRoot = merkleRoot_;
201     }
202     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
203         bytes32 _leaf = keccak256(abi.encodePacked(address_));
204         for (uint256 i = 0; i < proof_.length; i++) {
205             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
206         }
207         return _leaf == _merkleRoot;
208     }
209 }
210 
211 abstract contract Security {
212     // Prevent Smart Contracts
213     modifier onlySender {
214         require(msg.sender == tx.origin, "No Smart Contracts!"); _; }
215 }
216 
217 abstract contract PublicMint {
218     // Public Minting
219     bool public _publicMintEnabled; uint256 public _publicMintTime;
220     function _setPublicMint(bool bool_, uint256 time_) internal {
221         _publicMintEnabled = bool_; _publicMintTime = time_; }
222     modifier publicMintEnabled { 
223         require(_publicMintEnabled && _publicMintTime <= block.timestamp, 
224             "Public Mint is not enabled yet!"); _; }
225     function publicMintStatus() external view returns (bool) {
226         return _publicMintEnabled && _publicMintTime <= block.timestamp; }
227 }
228 
229 abstract contract WhitelistMint {
230     // Whitelist Minting
231     bool internal _whitelistMintEnabled; uint256 public _whitelistMintTime;
232     function _setWhitelistMint(bool bool_, uint256 time_) internal {
233         _whitelistMintEnabled = bool_; _whitelistMintTime = time_; }
234     modifier whitelistMintEnabled {
235         require(_whitelistMintEnabled && _whitelistMintTime <= block.timestamp, 
236             "Whitelist Mint is not enabled yet!"); _; } 
237     function whitelistMintStatus() external view returns (bool) {
238         return _whitelistMintEnabled && _whitelistMintTime <= block.timestamp; }
239 }
240 
241 
242 // Open0x Presets //
243 // ERC721I_OW (ERC721I 0xInuarashi Edition, Ownable, Whitelist) 
244 
245 abstract contract ERC721I_OW is ERC721I, Ownable, MerkleWhitelist, Security, PublicMint, WhitelistMint {
246 
247     constructor(string memory name_, string memory symbol_) ERC721I(name_, symbol_) {}
248 
249     // Ownable Functions for ERC721I_OW //
250     
251     // Token URI
252     function setBaseTokenURI(string calldata uri_) external onlyOwner { 
253         _setBaseTokenURI(uri_);
254     }
255     function setBaseTokenURI_EXT(string calldata ext_) external onlyOwner {
256         _setBaseTokenURI_EXT(ext_);
257     }
258 
259     // MerkleRoot
260     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
261         _setMerkleRoot(merkleRoot_);
262     }
263 
264     // Public Mint
265     function setPublicMint(bool bool_, uint256 time_) external onlyOwner {
266         _setPublicMint(bool_, time_);
267     }
268     
269     // Whitelist Mint
270     function setWhitelistMint(bool bool_, uint256 time_) external onlyOwner {
271         _setWhitelistMint(bool_, time_);
272     }
273 
274 }
275 
276 abstract contract PayableGovernance is Ownable {
277     // Special Access
278     address _payableGovernanceSetter;
279     constructor() payable { _payableGovernanceSetter = msg.sender; }
280     modifier onlyPayableGovernanceSetter {
281         require(msg.sender == _payableGovernanceSetter, "PayableGovernance: Caller is not Setter!"); _; }
282     function reouncePayableGovernancePermissions() public onlyPayableGovernanceSetter {
283         _payableGovernanceSetter = address(0x0); }
284 
285     // Receivable Fallback
286     event Received(address from, uint amount);
287     receive() external payable { emit Received(msg.sender, msg.value); }
288 
289     // Required Variables
290     address payable[] internal _payableGovernanceAddresses;
291     uint256[] internal _payableGovernanceShares;    
292     mapping(address => bool) public addressToEmergencyUnlocked;
293 
294     // Withdraw Functionality
295     function _withdraw(address payable address_, uint256 amount_) internal {
296         (bool success, ) = payable(address_).call{value: amount_}("");
297         require(success, "Transfer failed");
298     }
299 
300     // Governance Functions
301     function setPayableGovernanceShareholders(address payable[] memory addresses_, uint256[] memory shares_) public onlyPayableGovernanceSetter {
302         require(_payableGovernanceAddresses.length == 0 && _payableGovernanceShares.length == 0, "Payable Governance already set! To set again, reset first!");
303         require(addresses_.length == shares_.length, "Address and Shares length mismatch!");
304         uint256 _totalShares;
305         for (uint256 i = 0; i < addresses_.length; i++) {
306             _totalShares += shares_[i];
307             _payableGovernanceAddresses.push(addresses_[i]);
308             _payableGovernanceShares.push(shares_[i]);
309         }
310         require(_totalShares == 1000, "Total Shares is not 1000!");
311     }
312     function resetPayableGovernanceShareholders() public onlyPayableGovernanceSetter {
313         while (_payableGovernanceAddresses.length != 0) {
314             _payableGovernanceAddresses.pop(); }
315         while (_payableGovernanceShares.length != 0) {
316             _payableGovernanceShares.pop(); }
317     }
318 
319     // Governance View Functions
320     function balance() public view returns (uint256) {
321         return address(this).balance;
322     }
323     function payableGovernanceAddresses() public view returns (address payable[] memory) {
324         return _payableGovernanceAddresses;
325     }
326     function payableGovernanceShares() public view returns (uint256[] memory) {
327         return _payableGovernanceShares;
328     }
329 
330     // Withdraw Functions
331     function withdrawEther() public onlyOwner {
332         // require that there has been payable governance set.
333         require(_payableGovernanceAddresses.length > 0 && _payableGovernanceShares.length > 0, "Payable governance not set yet!");
334          // this should never happen
335         require(_payableGovernanceAddresses.length == _payableGovernanceShares.length, "Payable governance length mismatch!");
336         
337         // now, we check that the governance shares equal to 1000.
338         uint256 _totalPayableShares;
339         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
340             _totalPayableShares += _payableGovernanceShares[i]; }
341         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
342         
343         // // now, we start the withdrawal process if all conditionals pass
344         // store current balance in local memory
345         uint256 _totalETH = address(this).balance; 
346 
347         // withdraw loop for payable governance
348         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
349             uint256 _ethToWithdraw = ((_totalETH * _payableGovernanceShares[i]) / 1000);
350             _withdraw(_payableGovernanceAddresses[i], _ethToWithdraw);
351         }
352     }
353 
354     function viewWithdrawAmounts() public view onlyOwner returns (uint256[] memory) {
355         // require that there has been payable governance set.
356         require(_payableGovernanceAddresses.length > 0 && _payableGovernanceShares.length > 0, "Payable governance not set yet!");
357          // this should never happen
358         require(_payableGovernanceAddresses.length == _payableGovernanceShares.length, "Payable governance length mismatch!");
359         
360         // now, we check that the governance shares equal to 1000.
361         uint256 _totalPayableShares;
362         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
363             _totalPayableShares += _payableGovernanceShares[i]; }
364         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
365         
366         // // now, we start the array creation process if all conditionals pass
367         // store current balance in local memory and instantiate array for input
368         uint256 _totalETH = address(this).balance; 
369         uint256[] memory _withdrawals = new uint256[] (_payableGovernanceAddresses.length + 2);
370 
371         // array creation loop for payable governance values 
372         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
373             _withdrawals[i] = ( (_totalETH * _payableGovernanceShares[i]) / 1000 );
374         }
375         
376         // push two last array spots as total eth and added eths of withdrawals
377         _withdrawals[_payableGovernanceAddresses.length] = _totalETH;
378         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
379             _withdrawals[_payableGovernanceAddresses.length + 1] += _withdrawals[i]; }
380 
381         // return the final array data
382         return _withdrawals;
383     }
384 
385     // Shareholder Governance
386     modifier onlyShareholder {
387         bool _isShareholder;
388         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
389             if (msg.sender == _payableGovernanceAddresses[i]) {
390                 _isShareholder = true;
391             }
392         }
393         require(_isShareholder, "You are not a shareholder!");
394         _;
395     }
396     function unlockEmergencyFunctionsAsShareholder() public onlyShareholder {
397         addressToEmergencyUnlocked[msg.sender] = true;
398     }
399 
400     // Emergency Functions
401     modifier onlyEmergency {
402         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
403             require(addressToEmergencyUnlocked[_payableGovernanceAddresses[i]], "Emergency Functions are not unlocked!");
404         }
405         _;
406     }
407     function emergencyWithdrawEther() public onlyOwner onlyEmergency {
408         _withdraw(payable(msg.sender), address(this).balance);
409     }
410 }
411 
412 interface iYield {
413     function updateRewardOnTransfer(address from_, address to_, uint256 tokenId_) external;
414 }
415 
416 contract AscendedNFT is ERC721I_OW, PayableGovernance {
417     constructor() payable ERC721I_OW("Ascended NFT", "ASCENDED") {}
418 
419     // Project Contraints
420     uint256 public mintPrice = 0.08 ether;
421     uint256 public maxTokens = 8888;
422 
423     uint256 public maxMintsPerWl = 4;
424     mapping(address => uint256) public addressToWlMints;
425 
426     uint256 public maxMintsPerTx = 10;
427 
428     function setMintPrice(uint256 mintPrice_) external onlyOwner {
429         mintPrice = mintPrice_;
430     }
431     function setMaxtokens(uint256 maxTokens_) external onlyOwner {
432         require(totalSupply >= maxTokens_, "Below totalSupply");
433         maxTokens = maxTokens_;
434     }
435 
436     // Setting Future-Proof Token Yield
437     iYield public Yield;
438     function setYieldToken(address address_) external onlyOwner {
439         Yield = iYield(address_);
440     }
441 
442     // Internal Mint
443     function _mintMany(address to_, uint256 amount_) internal {
444         require(maxTokens >= totalSupply + amount_,
445             "Not enough tokens remaining!");
446 
447         uint256 _startId = totalSupply + 1; // iterate from 1
448 
449         for (uint256 i = 0; i < amount_; i++) {
450             _mint(to_, _startId + i);
451         }
452         totalSupply += amount_;
453     }
454 
455     // Owner Mint Functions
456     function ownerMint(address to_, uint256 amount_) external onlyOwner {
457         _mintMany(to_, amount_);
458     }
459     function ownerMintToMany(address[] calldata tos_, uint256[] calldata amounts_) 
460     external onlyOwner {
461         require(tos_.length == amounts_.length, 
462             "Array lengths mismatch!");
463         
464         for (uint256 i = 0; i < tos_.length; i++) {
465             _mintMany(tos_[i], amounts_[i]);
466         }
467     }
468 
469     // Whitelist Mint Functions
470     function whitelistMint(bytes32[] calldata proof_, uint256 amount_) external payable 
471     onlySender whitelistMintEnabled {
472         require(isWhitelisted(msg.sender, proof_), 
473             "You are not Whitelisted!");
474         require(maxMintsPerWl >= addressToWlMints[msg.sender] + amount_,
475             "Over Max Mints per TX or Not enough whitelist mints remaining for you!");
476         require(msg.value == mintPrice * amount_,   
477             "Invalid value sent!");
478         
479         // Add address to WL minted
480         addressToWlMints[msg.sender] += amount_;
481 
482         _mintMany(msg.sender, amount_);
483     }
484 
485     // Public Mint Functions
486     function publicMint(uint256 amount_) external payable onlySender publicMintEnabled {
487         require(maxMintsPerTx >= amount_,
488             "Over maxmimum mints per Tx!");
489         require(msg.value == mintPrice * amount_, 
490             "Invalid value sent!");
491 
492         _mintMany(msg.sender, amount_);
493     }
494 
495     /////////////////////////////////////////////////////
496     // Withdraw Functions handled by PayableGovernance //
497     /////////////////////////////////////////////////////
498 
499     // Future-Proof Transfer Hook Yield Overrides
500     function transferFrom(address from_, address to_, uint256 tokenId_) public 
501     override {
502         if ( Yield != iYield(address(0x0)) ) {
503             Yield.updateRewardOnTransfer(from_, to_, tokenId_);    
504         }
505         ERC721I.transferFrom(from_, to_, tokenId_);
506     }
507     function safeTransferFrom(address from_, address to_, uint256 tokenId_, 
508     bytes memory data_) public override {
509         if ( Yield != iYield(address(0x0)) ) {
510             Yield.updateRewardOnTransfer(from_, to_, tokenId_);    
511         }
512         ERC721I.safeTransferFrom(from_, to_, tokenId_, data_);
513     }
514 }