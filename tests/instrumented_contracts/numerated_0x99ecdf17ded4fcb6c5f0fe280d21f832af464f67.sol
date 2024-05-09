1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /* ERC721IM - ERC721IM (ERC721 0xInuarashi Edition), Modifiable - Gas Optimized
5     Open Source: with the efforts of the [0x Collective] <3 */
6 
7 contract ERC721IM {
8 
9     string public name; string public symbol;
10     string internal baseTokenURI; string internal baseTokenURI_EXT;
11     constructor(string memory name_, string memory symbol_) { name = name_; symbol = symbol_; }
12 
13     uint256 public totalSupply; 
14 
15     struct ownerAndStake {
16         address owner; // 20 | 12
17         uint40 timestamp; // 5 | 7
18     }
19 
20     mapping(uint256 => ownerAndStake) public _ownerOf;
21 
22     mapping(address => uint256) public balanceOf; 
23 
24     mapping(uint256 => address) public getApproved; 
25     mapping(address => mapping(address => bool)) public isApprovedForAll; 
26 
27     // Events
28     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
29     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
30     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
31 
32     function ownerOf(uint256 tokenId_) public virtual view returns (address) {
33         return _ownerOf[tokenId_].owner;
34     }
35 
36     function isStaked(uint256 tokenId_) public view returns (bool) {
37         return _ownerOf[tokenId_].timestamp > 0;
38     }
39 
40     function getTimestampOfToken(uint256 tokenId_) public view returns (uint40) {
41         return _ownerOf[tokenId_].timestamp;
42     }
43 
44     function _stake(uint256 tokenId_) internal virtual {
45         require(ownerOf(tokenId_) != address(0),
46             "_stake(): Token doesn't exist!");
47         require(!isStaked(tokenId_),
48             "_stake(): Token is already staked!");
49 
50         _ownerOf[tokenId_].timestamp = uint40(block.timestamp);
51     }
52 
53     function _update(uint256 tokenId_) internal virtual {
54         require(ownerOf(tokenId_) != address(0),
55             "_update(): Token doesn't exist!");
56         require(isStaked(tokenId_),
57             "_update(): Token is not staked!");
58 
59         _ownerOf[tokenId_].timestamp = uint40(block.timestamp);
60     }
61     
62     function _unstake(uint256 tokenId_) internal virtual {
63         require(ownerOf(tokenId_) != address(0),
64             "_unstake(): Token doesn't exist!");
65         require(isStaked(tokenId_),
66             "_unstake(): Token is not staked!");
67         
68         _ownerOf[tokenId_].timestamp = 0;
69     }
70 
71     // // internal write functions
72     // mint
73     function _mint(address to_, uint256 tokenId_) internal virtual {
74         require(to_ != address(0x0), "ERC721I: _mint() Mint to Zero Address");
75         require(ownerOf(tokenId_) == address(0x0), "ERC721I: _mint() Token to Mint Already Exists!");
76 
77         balanceOf[to_]++;
78         _ownerOf[tokenId_].owner = to_;
79 
80         emit Transfer(address(0x0), to_, tokenId_);
81     }
82 
83     // transfer
84     function _transfer(address from_, address to_, uint256 tokenId_) internal virtual {
85         require(from_ == ownerOf(tokenId_), "ERC721I: _transfer() Transfer Not Owner of Token!");
86         require(to_ != address(0x0), "ERC721I: _transfer() Transfer to Zero Address!");
87 
88         if (getApproved[tokenId_] != address(0x0)) { 
89             _approve(address(0x0), tokenId_); 
90         } 
91 
92         _ownerOf[tokenId_].owner = to_; 
93         balanceOf[from_]--;
94         balanceOf[to_]++;
95 
96         emit Transfer(from_, to_, tokenId_);
97     }
98 
99     // approve
100     function _approve(address to_, uint256 tokenId_) internal virtual {
101         if (getApproved[tokenId_] != to_) {
102             getApproved[tokenId_] = to_;
103             emit Approval(ownerOf(tokenId_), to_, tokenId_);
104         }
105     }
106     function _setApprovalForAll(address owner_, address operator_, bool approved_) internal virtual {
107         require(owner_ != operator_, "ERC721I: _setApprovalForAll() Owner must not be the Operator!");
108         isApprovedForAll[owner_][operator_] = approved_;
109         emit ApprovalForAll(owner_, operator_, approved_);
110     }
111 
112     // token uri
113     function _setBaseTokenURI(string memory uri_) internal virtual {
114         baseTokenURI = uri_;
115     }
116     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
117         baseTokenURI_EXT = ext_;
118     }
119 
120     // // Internal View Functions
121     // Embedded Libraries
122     function _toString(uint256 value_) internal pure returns (string memory) {
123         if (value_ == 0) { return "0"; }
124         uint256 _iterate = value_; uint256 _digits;
125         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
126         bytes memory _buffer = new bytes(_digits);
127         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
128         return string(_buffer); // return string converted bytes of value_
129     }
130 
131     // Functional Views
132     function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal view virtual returns (bool) {
133         require(ownerOf(tokenId_) != address(0x0), "ERC721I: _isApprovedOrOwner() Owner is Zero Address!");
134         address _owner = ownerOf(tokenId_);
135         return (spender_ == _owner || spender_ == getApproved[tokenId_] || isApprovedForAll[_owner][spender_]);
136     }
137     function _exists(uint256 tokenId_) internal view virtual returns (bool) {
138         return ownerOf(tokenId_) != address(0x0);
139     }
140 
141     // // public write functions
142     function approve(address to_, uint256 tokenId_) public virtual {
143         address _owner = ownerOf(tokenId_);
144         require(to_ != _owner, "ERC721I: approve() Cannot approve yourself!");
145         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender], "ERC721I: Caller not owner or Approved!");
146         _approve(to_, tokenId_);
147     }
148     function setApprovalForAll(address operator_, bool approved_) public virtual {
149         _setApprovalForAll(msg.sender, operator_, approved_);
150     }
151     function transferFrom(address from_, address to_, uint256 tokenId_) public virtual {
152         require(_isApprovedOrOwner(msg.sender, tokenId_), "ERC721I: transferFrom() _isApprovedOrOwner = false!");
153         require(!isStaked(tokenId_), "ERC721I: transferFrom() Token is staked!");
154         _transfer(from_, to_, tokenId_);
155     }
156     function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public virtual {
157         transferFrom(from_, to_, tokenId_);
158         if (to_.code.length != 0) {
159             (, bytes memory _returned) = to_.staticcall(abi.encodeWithSelector(0x150b7a02, msg.sender, from_, tokenId_, data_));
160             bytes4 _selector = abi.decode(_returned, (bytes4));
161             require(_selector == 0x150b7a02, "ERC721I: safeTransferFrom() to_ not ERC721Receivable!");
162         }
163     }
164     function safeTransferFrom(address from_, address to_, uint256 tokenId_) public virtual {
165         safeTransferFrom(from_, to_, tokenId_, "");
166     }
167 
168     // 0xInuarashi Custom Functions
169     function multiTransferFrom(address from_, address to_, uint256[] memory tokenIds_) public virtual {
170         for (uint256 i = 0; i < tokenIds_.length; i++) {
171             transferFrom(from_, to_, tokenIds_[i]);
172         }
173     }
174     function multiSafeTransferFrom(address from_, address to_, uint256[] memory tokenIds_, bytes memory data_) public virtual {
175         for (uint256 i = 0; i < tokenIds_.length; i++) {
176             safeTransferFrom(from_, to_, tokenIds_[i], data_);
177         }
178     }
179 
180     // OZ Standard Stuff
181     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
182         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
183     }
184 
185     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
186         require(ownerOf(tokenId_) != address(0x0), "ERC721I: tokenURI() Token does not exist!");
187         return string(abi.encodePacked(baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
188     }
189 
190     function tokenIdStartsAt() public virtual view returns (uint256) {
191         uint256 _loopThrough = totalSupply;
192         uint256 _tokenIdStartAt;
193 
194         for (uint256 i = 0; i < _loopThrough; i++) {
195             if (ownerOf(i) != address(0x0)) { _tokenIdStartAt = i; break; }
196         }
197 
198         return _tokenIdStartAt;        
199     }
200 
201     function balanceOfStaked(address address_) public virtual view returns (uint256) {
202         uint256 _balance;
203         uint256 _loopThrough = totalSupply;
204         uint256 _tokenIdStartAt = tokenIdStartsAt();
205 
206         for (uint256 i = _tokenIdStartAt; i <= _loopThrough + _tokenIdStartAt; i++) {
207             if (_ownerOf[i].owner == address_ && isStaked(i)) {
208                 _balance++;
209             }
210         }
211 
212         return _balance;
213     }
214     function balanceOfUnstaked(address address_) public virtual view 
215     returns (uint256) {
216         uint256 _balance;
217         uint256 _loopThrough = totalSupply;
218         uint256 _tokenIdStartAt = tokenIdStartsAt();
219 
220         for (uint256 i = _tokenIdStartAt; i <= _loopThrough + _tokenIdStartAt; i++) {
221             if (_ownerOf[i].owner == address_ && !isStaked(i)) {
222                 _balance++;
223             }
224         }
225 
226         return _balance;
227     }
228 
229     // // public view functions
230     // never use these for functions ever, they are expensive af and for view only (this will be an issue in the future for interfaces)
231     function walletOfOwner(address address_) public virtual view 
232     returns (uint256[] memory) {
233         uint256 _balance = balanceOf[address_];
234         if (_balance == 0) return new uint256[](0);
235 
236         uint256[] memory _tokens = new uint256[] (_balance);
237         uint256 _index;
238         uint256 _loopThrough = totalSupply;
239         for (uint256 i = 0; i < _loopThrough; i++) {
240             if (ownerOf(i) == address(0x0) && _tokens[_balance - 1] == 0) {
241                 _loopThrough++; 
242             }
243             if (_ownerOf[i].owner == address_) { 
244                 _tokens[_index] = i; _index++; 
245             }
246         }
247         return _tokens;
248     }
249 
250     function walletOfOwnerUnstaked(address address_) public virtual view 
251     returns (uint256[] memory) {
252         uint256 _balance = balanceOfUnstaked(address_);
253         if (_balance == 0) return new uint256[](0);
254 
255         uint256[] memory _tokens = new uint256[] (_balance);
256         uint256 _index;
257         uint256 _loopThrough = totalSupply;
258         for (uint256 i = 0; i < _loopThrough; i++) {
259             if (ownerOf(i) == address(0x0) && _tokens[_balance - 1] == 0) {
260                 _loopThrough++; 
261             }
262             if (_ownerOf[i].owner == address_ && !isStaked(i)) { 
263                 _tokens[_index] = i; _index++; 
264             }
265         }
266         return _tokens;
267     }
268 
269     function walletOfOwnerStaked(address address_) public virtual view 
270     returns (uint256[] memory) {
271         uint256 _balance = balanceOfStaked(address_);
272         if (_balance == 0) return new uint256[](0);
273 
274         uint256[] memory _tokens = new uint256[] (_balance);
275         uint256 _index;
276         uint256 _loopThrough = totalSupply;
277         for (uint256 i = 0; i < _loopThrough; i++) {
278             if (ownerOf(i) == address(0x0) && _tokens[_balance - 1] == 0) { 
279                 _loopThrough++; 
280             }
281             // if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
282             if (_ownerOf[i].owner == address_ && isStaked(i)) { 
283                 _tokens[_index] = i; _index++; 
284             }
285         }
286         return _tokens;
287     }
288 
289     // so not sure when this will ever be really needed but it conforms to erc721 enumerable
290     function tokenOfOwnerByIndex(address address_, uint256 index_) public virtual view returns (uint256) {
291         uint256[] memory _wallet = walletOfOwner(address_);
292         return _wallet[index_];
293     }
294 }
295 
296 /*
297     administrative functions marked as internal because you should have
298     owner access in order to use them. so, write them in your contract yourself!
299 */
300 
301 abstract contract MerkleWhitelist {
302     bytes32 internal _merkleRoot = 0xa67a6c6810aaf3dec2d76d522ab50128c8a08e7e5574456aa3c4b0c6f3eb9732;
303     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
304         _merkleRoot = merkleRoot_;
305     }
306     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
307         bytes32 _leaf = keccak256(abi.encodePacked(address_));
308         for (uint256 i = 0; i < proof_.length; i++) {
309             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) 
310                 : keccak256(abi.encodePacked(proof_[i], _leaf));
311         }
312         return _leaf == _merkleRoot;
313     }
314 }
315 
316 // Open0x Ownable (by 0xInuarashi)
317 abstract contract Ownable {
318     address public owner;
319     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
320     constructor() { owner = msg.sender; }
321     modifier onlyOwner {
322         require(owner == msg.sender, "Ownable: caller is not the owner");
323         _;
324     }
325     function _transferOwnership(address newOwner_) internal virtual {
326         address _oldOwner = owner;
327         owner = newOwner_;
328         emit OwnershipTransferred(_oldOwner, newOwner_);    
329     }
330     function transferOwnership(address newOwner_) public virtual onlyOwner {
331         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
332         _transferOwnership(newOwner_);
333     }
334     function renounceOwnership() public virtual onlyOwner {
335         _transferOwnership(address(0x0));
336     }
337 }
338 
339 
340 // Open0x Payable Governance Module by 0xInuarashi
341 // This abstract contract utilizes for loops in order to iterate things in order to be modular
342 // It is not the most gas-effective implementation. 
343 // We sacrified gas-effectiveness for Modularity instead.
344 abstract contract PayableGovernance is Ownable {
345     // Special Access
346     address _payableGovernanceSetter;
347     constructor() payable { _payableGovernanceSetter = msg.sender; }
348     modifier onlyPayableGovernanceSetter {
349         require(msg.sender == _payableGovernanceSetter, "PayableGovernance: Caller is not Setter!"); _; }
350     function reouncePayableGovernancePermissions() public onlyPayableGovernanceSetter {
351         _payableGovernanceSetter = address(0x0); }
352 
353     // Receivable Fallback
354     event Received(address from, uint amount);
355     receive() external payable { emit Received(msg.sender, msg.value); }
356 
357     // Required Variables
358     address payable[] internal _payableGovernanceAddresses;
359     uint256[] internal _payableGovernanceShares;    
360     mapping(address => bool) public addressToEmergencyUnlocked;
361 
362     // Withdraw Functionality
363     function _withdraw(address payable address_, uint256 amount_) internal {
364         (bool success, ) = payable(address_).call{value: amount_}("");
365         require(success, "Transfer failed");
366     }
367 
368     // Governance Functions
369     function setPayableGovernanceShareholders(address payable[] memory addresses_, uint256[] memory shares_) public onlyPayableGovernanceSetter {
370         require(_payableGovernanceAddresses.length == 0 && _payableGovernanceShares.length == 0, "Payable Governance already set! To set again, reset first!");
371         require(addresses_.length == shares_.length, "Address and Shares length mismatch!");
372         uint256 _totalShares;
373         for (uint256 i = 0; i < addresses_.length; i++) {
374             _totalShares += shares_[i];
375             _payableGovernanceAddresses.push(addresses_[i]);
376             _payableGovernanceShares.push(shares_[i]);
377         }
378         require(_totalShares == 1000, "Total Shares is not 1000!");
379     }
380     function resetPayableGovernanceShareholders() public onlyPayableGovernanceSetter {
381         while (_payableGovernanceAddresses.length != 0) {
382             _payableGovernanceAddresses.pop(); }
383         while (_payableGovernanceShares.length != 0) {
384             _payableGovernanceShares.pop(); }
385     }
386 
387     // Governance View Functions
388     function balance() public view returns (uint256) {
389         return address(this).balance;
390     }
391     function payableGovernanceAddresses() public view returns (address payable[] memory) {
392         return _payableGovernanceAddresses;
393     }
394     function payableGovernanceShares() public view returns (uint256[] memory) {
395         return _payableGovernanceShares;
396     }
397 
398     // Withdraw Functions
399     function withdrawEther() public onlyOwner {
400         // require that there has been payable governance set.
401         require(_payableGovernanceAddresses.length > 0 && _payableGovernanceShares.length > 0, "Payable governance not set yet!");
402          // this should never happen
403         require(_payableGovernanceAddresses.length == _payableGovernanceShares.length, "Payable governance length mismatch!");
404         
405         // now, we check that the governance shares equal to 1000.
406         uint256 _totalPayableShares;
407         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
408             _totalPayableShares += _payableGovernanceShares[i]; }
409         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
410         
411         // // now, we start the withdrawal process if all conditionals pass
412         // store current balance in local memory
413         uint256 _totalETH = address(this).balance; 
414 
415         // withdraw loop for payable governance
416         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
417             uint256 _ethToWithdraw = ((_totalETH * _payableGovernanceShares[i]) / 1000);
418             _withdraw(_payableGovernanceAddresses[i], _ethToWithdraw);
419         }
420     }
421 
422     function viewWithdrawAmounts() public view onlyOwner returns (uint256[] memory) {
423         // require that there has been payable governance set.
424         require(_payableGovernanceAddresses.length > 0 && _payableGovernanceShares.length > 0, "Payable governance not set yet!");
425          // this should never happen
426         require(_payableGovernanceAddresses.length == _payableGovernanceShares.length, "Payable governance length mismatch!");
427         
428         // now, we check that the governance shares equal to 1000.
429         uint256 _totalPayableShares;
430         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
431             _totalPayableShares += _payableGovernanceShares[i]; }
432         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
433         
434         // // now, we start the array creation process if all conditionals pass
435         // store current balance in local memory and instantiate array for input
436         uint256 _totalETH = address(this).balance; 
437         uint256[] memory _withdrawals = new uint256[] (_payableGovernanceAddresses.length + 2);
438 
439         // array creation loop for payable governance values 
440         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
441             _withdrawals[i] = ( (_totalETH * _payableGovernanceShares[i]) / 1000 );
442         }
443         
444         // push two last array spots as total eth and added eths of withdrawals
445         _withdrawals[_payableGovernanceAddresses.length] = _totalETH;
446         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
447             _withdrawals[_payableGovernanceAddresses.length + 1] += _withdrawals[i]; }
448 
449         // return the final array data
450         return _withdrawals;
451     }
452 
453     // Shareholder Governance
454     modifier onlyShareholder {
455         bool _isShareholder;
456         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
457             if (msg.sender == _payableGovernanceAddresses[i]) {
458                 _isShareholder = true;
459             }
460         }
461         require(_isShareholder, "You are not a shareholder!");
462         _;
463     }
464     function unlockEmergencyFunctionsAsShareholder() public onlyShareholder {
465         addressToEmergencyUnlocked[msg.sender] = true;
466     }
467 
468     // Emergency Functions
469     modifier onlyEmergency {
470         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
471             require(addressToEmergencyUnlocked[_payableGovernanceAddresses[i]], "Emergency Functions are not unlocked!");
472         }
473         _;
474     }
475     function emergencyWithdrawEther() public onlyOwner onlyEmergency {
476         _withdraw(payable(msg.sender), address(this).balance);
477     }
478 }
479 
480 // Open0x Security by 0xInuarashi
481 abstract contract Security {
482     // Prevent Smart Contracts
483     modifier onlySender {
484         require(msg.sender == tx.origin, "No Smart Contracts!"); _; }
485 }
486 
487 abstract contract WhitelistMint {
488     // Whitelist Minting
489     bool internal _whitelistMintEnabled; uint256 public _whitelistMintTime;
490     function _setWhitelistMint(bool bool_, uint256 time_) internal {
491         _whitelistMintEnabled = bool_; _whitelistMintTime = time_; }
492     modifier whitelistMintEnabled {
493         require(_whitelistMintEnabled && _whitelistMintTime <= block.timestamp, 
494             "Whitelist Mint is not enabled yet!"); _; } 
495     function whitelistMintStatus() external view returns (bool) {
496         return _whitelistMintEnabled && _whitelistMintTime <= block.timestamp; }
497 }
498 
499 abstract contract PublicMint {
500     // Public Minting
501     bool public _publicMintEnabled; uint256 public _publicMintTime;
502     function _setPublicMint(bool bool_, uint256 time_) internal {
503         _publicMintEnabled = bool_; _publicMintTime = time_; }
504     modifier publicMintEnabled { 
505         require(_publicMintEnabled && _publicMintTime <= block.timestamp, 
506             "Public Mint is not enabled yet!"); _; }
507     function publicMintStatus() external view returns (bool) {
508         return _publicMintEnabled && _publicMintTime <= block.timestamp; }
509 }
510 
511 interface isCT {
512     function mintStakedTokenAsCyberTurtles(address to_, uint256 tokenId_) external;
513 }
514 
515 contract CyberTurtles is ERC721IM, MerkleWhitelist, Ownable, PayableGovernance,
516 Security, WhitelistMint, PublicMint {
517     constructor() payable ERC721IM("CyberTurtles", "CYBERT") {}
518 
519     /*
520         CyberTurtles 
521         Staking with Proof-of-Stake-Token Phantom Minting
522         Yield $SHELL
523         Whitelist Mint (MerkleWhitelist)
524         Public Mint
525     */
526 
527     ////// Project Contraints //////
528     uint256 public maxTokens = 5555; 
529     uint256 public mintPrice = 0.07 ether; 
530     uint256 public maxMintsPerTx = 10;
531 
532     uint256 public maxMintsPerWl = 2;
533     mapping(address => uint256) public addressToWlMints;
534 
535     ///// Interfaces /////
536     isCT public sCT;
537     function setsCT(address address_) external onlyOwner {
538         sCT = isCT(address_);
539     }
540     modifier onlyStaker {
541         require(msg.sender == address(sCT), "You are not staker!"); _;
542     }
543 
544     ///// Ownable /////
545     // Constraints
546     function setMaxTokens(uint256 maxTokens_) external onlyOwner {
547         maxTokens = maxTokens_;
548     }
549     function setMintPrice(uint256 mintPrice_) external onlyOwner {
550         mintPrice = mintPrice_;
551     }
552 
553     function setMaxMintsPerTx(uint256 maxMints_) external onlyOwner {
554         maxMintsPerTx = maxMints_;
555     }
556     function setMaxMintsPerWl(uint256 maxMints_) external onlyOwner {
557         maxMintsPerWl = maxMints_;
558     }
559 
560     // Token URI
561     function setBaseTokenURI(string calldata uri_) external onlyOwner { 
562         _setBaseTokenURI(uri_);
563     }
564     function setBaseTokenURI_EXT(string calldata ext_) external onlyOwner {
565         _setBaseTokenURI_EXT(ext_);
566     }
567 
568     // MerkleRoot
569     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
570         _setMerkleRoot(merkleRoot_);
571     }
572 
573     // Public Mint
574     function setPublicMint(bool bool_, uint256 time_) external onlyOwner {
575         _setPublicMint(bool_, time_);
576     }
577     
578     // Whitelist Mint
579     function setWhitelistMint(bool bool_, uint256 time_) external onlyOwner {
580         _setWhitelistMint(bool_, time_);
581     }
582 
583     // (Withdrawals Handled by PayableGovernance)
584 
585     ///// OwnerOf Override /////
586     function ownerOf(uint256 tokenId_) public view override returns (address) {
587         if (_ownerOf[tokenId_].timestamp == 0) {
588             return _ownerOf[tokenId_].owner;
589         } else {
590             return address(sCT);
591         }
592     }
593 
594     // OG Functionality
595     bytes32 internal _merkleRootOG = 0x29480e5ce297f9137e60d028b74252fa6019a4334d601f58b2bb4d07cc5c2b55;
596     function setMerkleRootOG(bytes32 merkleRoot_) external onlyOwner {
597         _merkleRootOG = merkleRoot_;
598     }
599     function isOG(address address_, bytes32[] memory proof_) 
600     public view returns (bool) {
601         bytes32 _leaf = keccak256(abi.encodePacked(address_));
602         for (uint256 i = 0; i < proof_.length; i++) {
603             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) 
604                 : keccak256(abi.encodePacked(proof_[i], _leaf));
605         }
606         return _leaf == _merkleRootOG;
607     }
608     mapping(address => uint256) public addressToOgMinted;
609 
610     ///// Internal Mint /////
611     function _mintMany(address to_, uint256 amount_) internal {
612         require(maxTokens >= totalSupply + amount_,
613             "Not enough tokens remaining!");
614             
615         uint256 _startId = totalSupply + 1; // iterate from 1
616 
617         for (uint256 i = 0; i < amount_; i++) {
618             _mint(to_, _startId + i);
619         }
620         totalSupply += amount_;
621     }
622     function _mintAndStakeMany(address to_, uint256 amount_) internal {
623         require(maxTokens >= totalSupply + amount_,
624             "Not enough tokens remaining!");
625         
626         uint256 _startId = totalSupply + 1; // iterate from 1
627 
628         for (uint256 i = 0; i < amount_; i++) {
629             _mint(to_, _startId + i);
630             _stake(_startId + i);
631             
632             emit Transfer(to_, address(sCT), _startId + i);
633             sCT.mintStakedTokenAsCyberTurtles(to_, _startId + i);
634         }
635         totalSupply += amount_;
636     }
637 
638     ///// Magic Stake Code /////
639     // Turtle Staker / Unstaker -- The validation logic is handled by sCyberTurtles
640     function validateOwnershipOfTokens(address owner_, uint256[] calldata tokenIds_)
641     external view returns (bool) {
642         for (uint256 i = 0; i < tokenIds_.length; i++) {
643             if (owner_ != ownerOf(tokenIds_[i])) return false;
644         }
645         return true;
646     }
647     function validateOwnershipOfStakedTokens(address owner_,
648     uint256[] calldata tokenIds_) external view returns (bool) {
649         for (uint256 i = 0; i < tokenIds_.length; i++) {
650             ownerAndStake memory _ownerAndStake = _ownerOf[tokenIds_[i]];
651             if (owner_ != _ownerAndStake.owner 
652                 || _ownerAndStake.timestamp == 0) return false;
653         }
654         return true;
655     }
656     
657     function stakeTurtles(uint256[] calldata tokenIds_) external onlyStaker {
658         for (uint256 i = 0; i < tokenIds_.length; i++) {
659             _stake(tokenIds_[i]);
660             emit Transfer(ownerOf(tokenIds_[i]), address(sCT), tokenIds_[i]);
661         }
662     }
663     function updateTurtles(uint256[] calldata tokenIds_) external onlyStaker {
664         for (uint256 i = 0; i < tokenIds_.length; i++) {
665             _update(tokenIds_[i]);
666         }
667     }
668     function unstakeTurtles(uint256[] calldata tokenIds_) external onlyStaker {
669         for (uint256 i = 0; i < tokenIds_.length; i++) {
670             _unstake(tokenIds_[i]);
671             emit Transfer(address(sCT), _ownerOf[tokenIds_[i]].owner, tokenIds_[i]);
672         }
673     }
674 
675     ///// Minting Functions /////
676     function ownerMint(address[] calldata tos_, uint256[] calldata amounts_,
677     bool stakeOnMint_) external onlyOwner {
678         require(tos_.length == amounts_.length,
679             "Array lengths mismatch!");
680             
681         if (stakeOnMint_) {
682             for (uint256 i = 0; i < tos_.length; i++) {
683                 _mintAndStakeMany(tos_[i], amounts_[i]);
684             }
685         } else {
686             for (uint256 i = 0; i < tos_.length; i++) {
687                 _mintMany(tos_[i], amounts_[i]);
688             }
689         }
690     }
691 
692     // OG Claim Function (we reused whitelistMint modifier)
693     function ogClaim(bytes32[] calldata proof_, bool stakeOnMint_) 
694     public onlySender whitelistMintEnabled {
695         require(isOG(msg.sender, proof_),
696             "You are not OG!");
697         require(addressToOgMinted[msg.sender] == 0, 
698             "You have already minted!");
699 
700         addressToOgMinted[msg.sender]++;
701 
702         if (stakeOnMint_) {
703             _mintAndStakeMany(msg.sender, 1);
704         } else {
705             _mintMany(msg.sender, 1);
706         }
707     }
708 
709     // Whitelist Mint Functions
710     function whitelistMint(bytes32[] calldata proof_, uint256 amount_,
711     bool stakeOnMint_) public payable onlySender whitelistMintEnabled {
712         require(isWhitelisted(msg.sender, proof_),
713             "You are not whitelisted!");
714         require(maxMintsPerWl >= addressToWlMints[msg.sender] + amount_,
715             "You dont have enough whitelist mints!");
716         require(msg.value == mintPrice * amount_,
717             "Invalid value sent!");
718         
719         // Add address to WL minted
720         addressToWlMints[msg.sender] += amount_;
721 
722         if (stakeOnMint_) {
723             _mintAndStakeMany(msg.sender, amount_);
724         } else {
725             _mintMany(msg.sender, amount_);
726         }
727     }
728 
729     // Public Mint Functions
730     function publicMint(uint256 amount_, bool stakeOnMint_) external payable
731     onlySender publicMintEnabled {
732         require(maxMintsPerTx >= amount_,
733             "Over maximum mints per TX!");
734         require(msg.value == mintPrice * amount_,
735             "Invalid value sent!");
736         
737         if (stakeOnMint_) {
738             _mintAndStakeMany(msg.sender, amount_);
739         } else {
740             _mintMany(msg.sender, amount_);
741         }
742     }
743 }