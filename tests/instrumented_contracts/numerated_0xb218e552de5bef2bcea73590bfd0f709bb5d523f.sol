1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 //////////////////////////////////////////////////////////////////////////////
5 //  _______  __    __  ___    __  ________  __        ________  ________    //
6 // |   ____||  |  |  ||   \  |  |/   _____\|  |      |   _____||   _____|   //
7 // |  |____ |  |  |  ||    \ |  ||  |      |  |      |  |_____ |  |_____    //
8 // |   ____||  |  |  ||     \|  ||  |      |  |      |   _____||_____   |   //
9 // |  |     |  |__|  ||  |\     ||  |______|  |______|  |_____  _____|  |   //
10 // |__|     \________/|__|   \__|\________/\________/\________||________|   //
11 //                                                                          //
12 // Author: 0xInuarashi                                                      //
13 //////////////////////////////////////////////////////////////////////////////
14 
15 /* ERC721I - ERC721I (ERC721 0xInuarashi Edition) - Gas Optimized
16     Open Source: with the efforts of the [0x Collective] <3 */
17 
18 contract ERC721I {
19 
20     string public name; string public symbol;
21     string internal baseTokenURI; string internal baseTokenURI_EXT;
22     constructor(string memory name_, string memory symbol_) {
23         name = name_; symbol = symbol_; 
24     }
25 
26     uint256 public totalSupply; 
27     mapping(uint256 => address) public ownerOf; 
28     mapping(address => uint256) public balanceOf; 
29 
30     mapping(uint256 => address) public getApproved; 
31     mapping(address => mapping(address => bool)) public isApprovedForAll; 
32 
33     // Events
34     event Transfer(address indexed from, address indexed to, 
35     uint256 indexed tokenId);
36     event Approval(address indexed owner, address indexed approved, 
37     uint256 indexed tokenId);
38     event ApprovalForAll(address indexed owner, address indexed operator, 
39     bool approved);
40 
41     // // internal write functions
42     // mint
43     function _mint(address to_, uint256 tokenId_) internal virtual {
44         require(to_ != address(0x0), 
45             "ERC721I: _mint() Mint to Zero Address");
46         require(ownerOf[tokenId_] == address(0x0), 
47             "ERC721I: _mint() Token to Mint Already Exists!");
48 
49         balanceOf[to_]++;
50         ownerOf[tokenId_] = to_;
51 
52         emit Transfer(address(0x0), to_, tokenId_);
53     }
54 
55     // transfer
56     function _transfer(address from_, address to_, uint256 tokenId_) internal virtual {
57         require(from_ == ownerOf[tokenId_], 
58             "ERC721I: _transfer() Transfer Not Owner of Token!");
59         require(to_ != address(0x0), 
60             "ERC721I: _transfer() Transfer to Zero Address!");
61 
62         // checks if there is an approved address clears it if there is
63         if (getApproved[tokenId_] != address(0x0)) { 
64             _approve(address(0x0), tokenId_); 
65         } 
66 
67         ownerOf[tokenId_] = to_; 
68         balanceOf[from_]--;
69         balanceOf[to_]++;
70 
71         emit Transfer(from_, to_, tokenId_);
72     }
73 
74     // approve
75     function _approve(address to_, uint256 tokenId_) internal virtual {
76         if (getApproved[tokenId_] != to_) {
77             getApproved[tokenId_] = to_;
78             emit Approval(ownerOf[tokenId_], to_, tokenId_);
79         }
80     }
81     function _setApprovalForAll(address owner_, address operator_, bool approved_)
82     internal virtual {
83         require(owner_ != operator_, 
84             "ERC721I: _setApprovalForAll() Owner must not be the Operator!");
85         isApprovedForAll[owner_][operator_] = approved_;
86         emit ApprovalForAll(owner_, operator_, approved_);
87     }
88 
89     // token uri
90     function _setBaseTokenURI(string memory uri_) internal virtual {
91         baseTokenURI = uri_;
92     }
93     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
94         baseTokenURI_EXT = ext_;
95     }
96 
97     // // Internal View Functions
98     // Embedded Libraries
99     function _toString(uint256 value_) internal pure returns (string memory) {
100         if (value_ == 0) { return "0"; }
101         uint256 _iterate = value_; uint256 _digits;
102         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
103         bytes memory _buffer = new bytes(_digits);
104         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(
105             48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
106         return string(_buffer); // return string converted bytes of value_
107     }
108 
109     // Functional Views
110     function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal 
111     view virtual returns (bool) {
112         require(ownerOf[tokenId_] != address(0x0), 
113             "ERC721I: _isApprovedOrOwner() Owner is Zero Address!");
114         address _owner = ownerOf[tokenId_];
115         return (spender_ == _owner 
116             || spender_ == getApproved[tokenId_] 
117             || isApprovedForAll[_owner][spender_]);
118     }
119     function _exists(uint256 tokenId_) internal view virtual returns (bool) {
120         return ownerOf[tokenId_] != address(0x0);
121     }
122 
123     // // public write functions
124     function approve(address to_, uint256 tokenId_) public virtual {
125         address _owner = ownerOf[tokenId_];
126         require(to_ != _owner, 
127             "ERC721I: approve() Cannot approve yourself!");
128         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender],
129             "ERC721I: Caller not owner or Approved!");
130         _approve(to_, tokenId_);
131     }
132     function setApprovalForAll(address operator_, bool approved_) public virtual {
133         _setApprovalForAll(msg.sender, operator_, approved_);
134     }
135 
136     function transferFrom(address from_, address to_, uint256 tokenId_) 
137     public virtual {
138         require(_isApprovedOrOwner(msg.sender, tokenId_), 
139             "ERC721I: transferFrom() _isApprovedOrOwner = false!");
140         _transfer(from_, to_, tokenId_);
141     }
142     function safeTransferFrom(address from_, address to_, uint256 tokenId_, 
143     bytes memory data_) public virtual {
144         transferFrom(from_, to_, tokenId_);
145         if (to_.code.length != 0) {
146             (, bytes memory _returned) = to_.staticcall(abi.encodeWithSelector(
147                 0x150b7a02, msg.sender, from_, tokenId_, data_));
148             bytes4 _selector = abi.decode(_returned, (bytes4));
149             require(_selector == 0x150b7a02, 
150                 "ERC721I: safeTransferFrom() to_ not ERC721Receivable!");
151         }
152     }
153     function safeTransferFrom(address from_, address to_, uint256 tokenId_) 
154     public virtual {
155         safeTransferFrom(from_, to_, tokenId_, "");
156     }
157 
158     // 0xInuarashi Custom Functions
159     function multiTransferFrom(address from_, address to_, 
160     uint256[] memory tokenIds_) public virtual {
161         for (uint256 i = 0; i < tokenIds_.length; i++) {
162             transferFrom(from_, to_, tokenIds_[i]);
163         }
164     }
165     function multiSafeTransferFrom(address from_, address to_, 
166     uint256[] memory tokenIds_, bytes memory data_) public virtual {
167         for (uint256 i = 0; i < tokenIds_.length; i++) {
168             safeTransferFrom(from_, to_, tokenIds_[i], data_);
169         }
170     }
171 
172     // OZ Standard Stuff
173     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
174         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
175     }
176 
177     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
178         require(ownerOf[tokenId_] != address(0x0), 
179             "ERC721I: tokenURI() Token does not exist!");
180         return string(abi.encodePacked(
181             baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
182     }
183     // // public view functions
184     // never use these for functions ever, they are expensive af and for view only 
185     function walletOfOwner(address address_) public virtual view 
186     returns (uint256[] memory) {
187         uint256 _balance = balanceOf[address_];
188         uint256[] memory _tokens = new uint256[] (_balance);
189         uint256 _index;
190         uint256 _loopThrough = totalSupply;
191         for (uint256 i = 0; i < _loopThrough; i++) {
192             if (ownerOf[i] == address(0x0) && _tokens[_balance - 1] == 0) {
193                 _loopThrough++; 
194             }
195             if (ownerOf[i] == address_) { 
196                 _tokens[_index] = i; _index++; 
197             }
198         }
199         return _tokens;
200     }
201 
202     // not sure when this will ever be needed but it conforms to erc721 enumerable
203     function tokenOfOwnerByIndex(address address_, uint256 index_) public 
204     virtual view returns (uint256) {
205         uint256[] memory _wallet = walletOfOwner(address_);
206         return _wallet[index_];
207     }
208 }
209 
210 // Open0x Ownable (by 0xInuarashi)
211 abstract contract Ownable {
212     address public owner;
213     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
214     constructor() { owner = msg.sender; }
215     modifier onlyOwner {
216         require(owner == msg.sender, "Ownable: caller is not the owner");
217         _;
218     }
219     function _transferOwnership(address newOwner_) internal virtual {
220         address _oldOwner = owner;
221         owner = newOwner_;
222         emit OwnershipTransferred(_oldOwner, newOwner_);    
223     }
224     function transferOwnership(address newOwner_) public virtual onlyOwner {
225         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
226         _transferOwnership(newOwner_);
227     }
228     function renounceOwnership() public virtual onlyOwner {
229         _transferOwnership(address(0x0));
230     }
231 }
232 
233 // Open0x Payable Governance Module by 0xInuarashi
234 // This abstract contract utilizes for loops in order to iterate things 
235 // in order to be modular.
236 // It is not the most gas-effective implementation. 
237 // We sacrified gas-effectiveness for Modularity instead.
238 abstract contract PayableGovernance is Ownable {
239     // Special Access
240     address public payableGovernanceSetter;
241     constructor() payable { payableGovernanceSetter = msg.sender; }
242     modifier onlyPayableGovernanceSetter {
243         require(msg.sender == payableGovernanceSetter, 
244             "PayableGovernance: Caller is not Setter!"); _; }
245     function reouncePayableGovernancePermissions() public onlyPayableGovernanceSetter {
246         payableGovernanceSetter = address(0x0); }
247 
248     // Receivable Fallback
249     event Received(address from, uint amount);
250     receive() external payable { emit Received(msg.sender, msg.value); }
251 
252     // Required Variables
253     address payable[] internal _payableGovernanceAddresses;
254     uint256[] internal _payableGovernanceShares;    
255     mapping(address => bool) public addressToEmergencyUnlocked;
256 
257     // Withdraw Functionality
258     function _withdraw(address payable address_, uint256 amount_) internal {
259         (bool success, ) = payable(address_).call{value: amount_}("");
260         require(success, "Transfer failed");
261     }
262 
263     // Governance Functions
264     function setPayableGovernanceShareholders(address payable[] memory addresses_,
265     uint256[] memory shares_) public onlyPayableGovernanceSetter {
266         require(_payableGovernanceAddresses.length == 0 
267             && _payableGovernanceShares.length == 0, 
268             "Payable Governance already set! To set again, reset first!");
269         require(addresses_.length == shares_.length, 
270             "Address and Shares length mismatch!");
271 
272         uint256 _totalShares;
273         
274         for (uint256 i = 0; i < addresses_.length; i++) {
275             _totalShares += shares_[i];
276             _payableGovernanceAddresses.push(addresses_[i]);
277             _payableGovernanceShares.push(shares_[i]);
278         }
279         require(_totalShares == 1000, "Total Shares is not 1000!");
280     }
281     function resetPayableGovernanceShareholders() public onlyPayableGovernanceSetter {
282         while (_payableGovernanceAddresses.length != 0) {
283             _payableGovernanceAddresses.pop(); }
284         while (_payableGovernanceShares.length != 0) {
285             _payableGovernanceShares.pop(); }
286     }
287 
288     // Governance View Functions
289     function balance() public view returns (uint256) {
290         return address(this).balance;
291     }
292     function payableGovernanceAddresses() public view 
293     returns (address payable[] memory) {
294         return _payableGovernanceAddresses;
295     }
296     function payableGovernanceShares() public view returns (uint256[] memory) {
297         return _payableGovernanceShares;
298     }
299 
300     // Withdraw Functions
301     function withdrawEther() public onlyOwner {
302         // require that there has been payable governance set.
303         require(_payableGovernanceAddresses.length > 0 
304             && _payableGovernanceShares.length > 0, 
305             "Payable governance not set yet!");
306          // this should never happen
307         require(_payableGovernanceAddresses.length 
308             == _payableGovernanceShares.length, 
309             "Payable governance length mismatch!");
310         
311         // now, we check that the governance shares equal to 1000.
312         uint256 _totalPayableShares;
313         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
314             _totalPayableShares += _payableGovernanceShares[i]; }
315         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
316         
317         // // now, we start the withdrawal process if all conditionals pass
318         // store current balance in local memory
319         uint256 _totalETH = address(this).balance; 
320 
321         // withdraw loop for payable governance
322         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
323             uint256 _ethToWithdraw = ((_totalETH * _payableGovernanceShares[i]) / 1000);
324             _withdraw(_payableGovernanceAddresses[i], _ethToWithdraw);
325         }
326     }
327 
328     function viewWithdrawAmounts() public view onlyOwner returns (uint256[] memory) {
329         // require that there has been payable governance set.
330         require(_payableGovernanceAddresses.length > 0 
331             && _payableGovernanceShares.length > 0, 
332             "Payable governance not set yet!");
333          // this should never happen
334         require(_payableGovernanceAddresses.length 
335             == _payableGovernanceShares.length, 
336             "Payable governance length mismatch!");
337         
338         // now, we check that the governance shares equal to 1000.
339         uint256 _totalPayableShares;
340         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
341             _totalPayableShares += _payableGovernanceShares[i]; }
342         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
343         
344         // // now, we start the array creation process if all conditionals pass
345         // store current balance in local memory and instantiate array for input
346         uint256 _totalETH = address(this).balance; 
347         uint256[] memory _withdrawals = new uint256[] 
348             (_payableGovernanceAddresses.length + 2);
349 
350         // array creation loop for payable governance values 
351         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
352             _withdrawals[i] = ( (_totalETH * _payableGovernanceShares[i]) / 1000 );
353         }
354         
355         // push two last array spots as total eth and added eths of withdrawals
356         _withdrawals[_payableGovernanceAddresses.length] = _totalETH;
357         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
358             _withdrawals[_payableGovernanceAddresses.length + 1] += _withdrawals[i]; }
359 
360         // return the final array data
361         return _withdrawals;
362     }
363 
364     // Shareholder Governance
365     modifier onlyShareholder {
366         bool _isShareholder;
367         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
368             if (msg.sender == _payableGovernanceAddresses[i]) {
369                 _isShareholder = true;
370             }
371         }
372         require(_isShareholder, "You are not a shareholder!");
373         _;
374     }
375     function unlockEmergencyFunctionsAsShareholder() public onlyShareholder {
376         addressToEmergencyUnlocked[msg.sender] = true;
377     }
378 
379     // Emergency Functions
380     modifier onlyEmergency {
381         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
382             require(addressToEmergencyUnlocked[_payableGovernanceAddresses[i]],
383                 "Emergency Functions are not unlocked!");
384         }
385         _;
386     }
387     function emergencyWithdrawEther() public onlyOwner onlyEmergency {
388         _withdraw(payable(msg.sender), address(this).balance);
389     }
390 }
391 
392 abstract contract MerkleWhitelist {
393     bytes32 internal _merkleRoot;
394     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
395         _merkleRoot = merkleRoot_;
396     }
397     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
398         bytes32 _leaf = keccak256(abi.encodePacked(address_));
399         for (uint256 i = 0; i < proof_.length; i++) {
400             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
401         }
402         return _leaf == _merkleRoot;
403     }
404 }
405 
406 abstract contract WhitelistMint {
407     // Whitelist Minting
408     bool internal _whitelistMintEnabled; uint256 public _whitelistMintTime;
409     function _setWhitelistMint(bool bool_, uint256 time_) internal {
410         _whitelistMintEnabled = bool_; _whitelistMintTime = time_; }
411     modifier whitelistMintEnabled {
412         require(_whitelistMintEnabled && _whitelistMintTime <= block.timestamp, 
413             "Whitelist Mint is not enabled yet!"); _; } 
414     function whitelistMintStatus() external view returns (bool) {
415         return _whitelistMintEnabled && _whitelistMintTime <= block.timestamp; }
416 }
417 
418 abstract contract PublicMint {
419     // Public Minting
420     bool public _publicMintEnabled; uint256 public _publicMintTime;
421     function _setPublicMint(bool bool_, uint256 time_) internal {
422         _publicMintEnabled = bool_; _publicMintTime = time_; }
423     modifier publicMintEnabled { 
424         require(_publicMintEnabled && _publicMintTime <= block.timestamp, 
425             "Public Mint is not enabled yet!"); _; }
426     function publicMintStatus() external view returns (bool) {
427         return _publicMintEnabled && _publicMintTime <= block.timestamp; }
428 }
429 
430 abstract contract Security {
431     // Prevent Smart Contracts
432     modifier onlySender {
433         require(msg.sender == tx.origin, "No Smart Contracts!"); _; }
434 }
435 
436 contract Funcles is ERC721I, Ownable, MerkleWhitelist, 
437 WhitelistMint, PublicMint, Security, PayableGovernance {
438 
439     // Constructor
440     constructor() payable ERC721I("Funcles", "FUNCLES") {}
441 
442     // Project Constraints
443     uint256 public mintPrice = 0.085 ether;
444     uint256 public maxSupply = 3333;
445 
446     // Public Limits
447     uint256 public maxMintsPerPublic = 2;
448     mapping(address => uint256) public addressToPublicMints;
449 
450     // Whitelist Limits
451     uint256 public maxMintsPerWl = 2;
452     mapping(address => uint256) public addressToWlMints;
453 
454     // Administrative Functions
455     function setMintPrice(uint256 mintPrice_) external onlyOwner {
456         mintPrice = mintPrice_;
457     }
458     function setMaxSupply(uint256 maxSupply_) external onlyOwner {
459         maxSupply = maxSupply_;
460     }
461     
462     // Public and WL Mint Limits
463     function setMaxMintsPerPublic(uint256 maxMintsPerPublic_) external onlyOwner {
464         maxMintsPerPublic = maxMintsPerPublic_;
465     }
466     function setMaxMintsPerWl(uint256 maxMintsPerWl_) external onlyOwner {
467         maxMintsPerWl = maxMintsPerWl_;
468     }
469 
470     // Token URI
471     function setBaseTokenURI(string calldata uri_) external onlyOwner {
472         _setBaseTokenURI(uri_);
473     }
474     function setBaseTokenURI_EXT(string calldata ext_) external onlyOwner {
475         _setBaseTokenURI_EXT(ext_);
476     }
477 
478     // MerkleRoot
479     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
480         _setMerkleRoot(merkleRoot_);
481     }
482     
483     // Public Mint
484     function setPublicMint(bool bool_, uint256 time_) external onlyOwner {
485         _setPublicMint(bool_, time_);
486     }
487 
488     // Whitelist Mint
489     function setWhitelistMint(bool bool_, uint256 time_) external onlyOwner {
490         _setWhitelistMint(bool_, time_);
491     }
492 
493     // Withdrawals handled by PayableGovernance //
494 
495     // Internal Functions
496     function _mintMany(address to_, uint256 amount_) internal {
497         require(maxSupply >= totalSupply + amount_,
498             "Not enough Funcles remaining!");
499         
500         uint256 _startId = totalSupply + 1; // iterate from 1
501 
502         for (uint256 i = 0; i < amount_; i++) {
503             _mint(to_, _startId + i);
504         }
505 
506         totalSupply += amount_;
507     }
508 
509     // Owner Mint
510     function ownerMint(address[] calldata tos_, uint256[] calldata amounts_) 
511     external onlyOwner {
512         require(tos_.length == amounts_.length,
513             "Array lengths mismatch!");
514         
515         for (uint256 i = 0; i < tos_.length; i++) {
516             _mintMany(tos_[i], amounts_[i]);
517         }
518     }
519 
520     // Whitelist Mint
521     function whitelistMint(bytes32[] calldata proof_, uint256 amount_) external
522     payable onlySender whitelistMintEnabled {
523         require(isWhitelisted(msg.sender, proof_),
524             "You are not whitelisted!");
525         require(maxMintsPerWl >= addressToWlMints[msg.sender] + amount_,
526             "You don't have enough funlist mints!");
527         require(msg.value == mintPrice * amount_,
528             "Invalid value sent!");
529         
530         // Add address to WL minted
531         addressToWlMints[msg.sender] += amount_;
532 
533         // Now, mint to msg.sender
534         _mintMany(msg.sender, amount_);
535     }
536 
537     // Public Mint
538     function publicMint(uint256 amount_) external payable
539     onlySender publicMintEnabled {
540         require(maxMintsPerPublic >= addressToPublicMints[msg.sender] + amount_,
541             "You don't have enough Public Mints!");
542         require(msg.value == mintPrice * amount_,
543             "Invalid value sent!");
544 
545         // Add address to Public Mints
546         addressToPublicMints[msg.sender] += amount_;
547         
548         // Now, mint to msg.sender
549         _mintMany(msg.sender, amount_);
550     }
551 }