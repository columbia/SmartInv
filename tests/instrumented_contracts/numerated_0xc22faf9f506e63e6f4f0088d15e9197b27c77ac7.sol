1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6  */
7 contract ERC721 {
8   event Transfer(
9     address indexed from,
10     address indexed to,
11     uint256 indexed tokenId
12   );
13   event Approval(
14     address indexed owner,
15     address indexed approved,
16     uint256 indexed tokenId
17   );
18 
19   function implementsERC721() public pure returns (bool);
20   function totalSupply() public view returns (uint256 total);
21   function balanceOf(address _owner) public view returns (uint256 balance);
22   function ownerOf(uint256 _tokenId) external view returns (address owner);
23   function approve(address _to, uint256 _tokenId) external;
24   function transfer(address _to, uint256 _tokenId) external;
25   function transferFrom(address _from, address _to, uint256 _tokenId) external;
26 }
27 
28 
29 /**
30  * @title Interface of auction contract
31  */
32 interface CurioAuction {
33   function isCurioAuction() external returns (bool);
34   function withdrawBalance() external;
35   function setAuctionPriceLimit(uint256 _newAuctionPriceLimit) external;
36   function createAuction(
37     uint256 _tokenId,
38     uint256 _startingPrice,
39     uint256 _endingPrice,
40     uint256 _duration,
41     address _seller
42   )
43     external;
44 }
45 
46 
47 /**
48  * @title Curio
49  * @dev Curio core contract implements ERC721 token.
50  */
51 contract Curio is ERC721 {
52   event Create(
53     address indexed owner,
54     uint256 indexed tokenId,
55     string name
56   );
57   event ContractUpgrade(address newContract);
58 
59   struct Token {
60     string name;
61   }
62 
63   // Name and symbol of ERC721 token
64   string public constant NAME = "Curio";
65   string public constant SYMBOL = "CUR";
66 
67   // Array of token's data
68   Token[] tokens;
69 
70   // A mapping from token IDs to the address that owns them
71   mapping (uint256 => address) public tokenIndexToOwner;
72 
73   // A mapping from owner address to count of tokens that address owns
74   mapping (address => uint256) ownershipTokenCount;
75 
76   // A mapping from token IDs to an address that has been approved
77   mapping (uint256 => address) public tokenIndexToApproved;
78 
79   address public ownerAddress;
80   address public adminAddress;
81 
82   bool public paused = false;
83 
84   // The address of new contract when this contract was upgraded
85   address public newContractAddress;
86 
87   // The address of CurioAuction contract that handles sales of tokens
88   CurioAuction public auction;
89 
90   // Restriction on release of tokens
91   uint256 public constant TOTAL_SUPPLY_LIMIT = 900;
92 
93   // Count of released tokens
94   uint256 public releaseCreatedCount;
95 
96   /**
97    * @dev Throws if called by any account other than the owner.
98    */
99   modifier onlyOwner() {
100     require(msg.sender == ownerAddress);
101     _;
102   }
103 
104   /**
105    * @dev Throws if called by any account other than the admin.
106    */
107   modifier onlyAdmin() {
108     require(msg.sender == adminAddress);
109     _;
110   }
111 
112   /**
113    * @dev Throws if called by any account other than the owner or admin.
114    */
115   modifier onlyOwnerOrAdmin() {
116     require(
117       msg.sender == adminAddress ||
118       msg.sender == ownerAddress
119     );
120     _;
121   }
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is not paused.
125    */
126   modifier whenNotPaused() {
127     require(!paused);
128     _;
129   }
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is paused.
133    */
134   modifier whenPaused() {
135     require(paused);
136     _;
137   }
138 
139   /**
140    * @dev Constructor function
141    */
142   constructor() public {
143     // Contract paused after start
144     paused = true;
145 
146     // Set owner and admin addresses
147     ownerAddress = msg.sender;
148     adminAddress = msg.sender;
149   }
150 
151 
152   // -----------------------------------------
153   // External interface
154   // -----------------------------------------
155 
156 
157   /**
158    * @dev Check implementing ERC721 standard (needed in auction contract).
159    */
160   function implementsERC721() public pure returns (bool) {
161     return true;
162   }
163 
164   /**
165    * @dev Default payable function rejects all Ether from being sent here, unless it's from auction contract.
166    */
167   function() external payable {
168     require(msg.sender == address(auction));
169   }
170 
171   /**
172    * @dev Transfer all Ether from this contract to owner.
173    */
174   function withdrawBalance() external onlyOwner {
175     ownerAddress.transfer(address(this).balance);
176   }
177 
178   /**
179    * @dev Returns the total number of tokens currently in existence.
180    */
181   function totalSupply() public view returns (uint) {
182     return tokens.length;
183   }
184 
185   /**
186    * @dev Returns the number of tokens owned by a specific address.
187    * @param _owner The owner address to check
188    */
189   function balanceOf(address _owner) public view returns (uint256 count) {
190     return ownershipTokenCount[_owner];
191   }
192 
193   /**
194    * @dev Returns the address currently assigned ownership of a given token.
195    * @param _tokenId The ID of the token
196    */
197   function ownerOf(uint256 _tokenId) external view returns (address owner) {
198     owner = tokenIndexToOwner[_tokenId];
199 
200     require(owner != address(0));
201   }
202 
203   /**
204    * @dev Returns information about token.
205    * @param _id The ID of the token
206    */
207   function getToken(uint256 _id) external view returns (string name) {
208     Token storage token = tokens[_id];
209 
210     name = token.name;
211   }
212 
213   /**
214    * @dev Set new owner address. Only available to the current owner.
215    * @param _newOwner The address of the new owner
216    */
217   function setOwner(address _newOwner) onlyOwner external {
218     require(_newOwner != address(0));
219 
220     ownerAddress = _newOwner;
221   }
222 
223   /**
224    * @dev Set new admin address. Only available to owner.
225    * @param _newAdmin The address of the new admin
226    */
227   function setAdmin(address _newAdmin) onlyOwner external {
228     require(_newAdmin != address(0));
229 
230     adminAddress = _newAdmin;
231   }
232 
233   /**
234    * @dev Set new auction price limit.
235    * @param _newAuctionPriceLimit Start and end price limit
236    */
237   function setAuctionPriceLimit(uint256 _newAuctionPriceLimit) onlyOwnerOrAdmin external {
238     auction.setAuctionPriceLimit(_newAuctionPriceLimit);
239   }
240 
241   /**
242    * @dev Set the address of upgraded contract.
243    * @param _newContract Address of new contract
244    */
245   function setNewAddress(address _newContract) onlyOwner whenPaused external {
246     newContractAddress = _newContract;
247 
248     emit ContractUpgrade(_newContract);
249   }
250 
251   /**
252    * @dev Pause the contract. Called by owner or admin to pause the contract.
253    */
254   function pause() onlyOwnerOrAdmin whenNotPaused external {
255     paused = true;
256   }
257 
258   /**
259    * @dev Unpause the contract. Can only be called by owner, since
260    *      one reason we may pause the contract is when admin account is
261    *      compromised. Requires auction contract addresses
262    *      to be set before contract can be unpaused. Also, we can't have
263    *      newContractAddress set either, because then the contract was upgraded.
264    */
265   function unpause() onlyOwner whenPaused public {
266     require(auction != address(0));
267     require(newContractAddress == address(0));
268 
269     paused = false;
270   }
271 
272   /**
273    * @dev Transfer a token to another address.
274    * @param _to The address of the recipient, can be a user or contract
275    * @param _tokenId The ID of the token to transfer
276    */
277   function transfer(
278     address _to,
279     uint256 _tokenId
280   )
281     whenNotPaused
282     external
283   {
284     // Safety check to prevent against an unexpected 0x0 default.
285     require(_to != address(0));
286 
287     // Disallow transfers to this contract to prevent accidental misuse.
288     // The contract should never own any tokens (except very briefly
289     // after a release token is created and before it goes on auction).
290     require(_to != address(this));
291 
292     // Disallow transfers to the auction contract to prevent accidental
293     // misuse. Auction contracts should only take ownership of tokens
294     // through the allow + transferFrom flow.
295     require(_to != address(auction));
296 
297     // Check token ownership
298     require(_owns(msg.sender, _tokenId));
299 
300     // Reassign ownership, clear pending approvals, emit Transfer event.
301     _transfer(msg.sender, _to, _tokenId);
302   }
303 
304   /**
305    * @dev Grant another address the right to transfer a specific token via
306    *      transferFrom(). This is the preferred flow for transfering NFTs to contracts.
307    * @param _to The address to be granted transfer approval. Pass address(0) to
308    *            clear all approvals
309    * @param _tokenId The ID of the token that can be transferred if this call succeeds
310    */
311   function approve(
312     address _to,
313     uint256 _tokenId
314   )
315     whenNotPaused
316     external
317   {
318     // Only an owner can grant transfer approval.
319     require(_owns(msg.sender, _tokenId));
320 
321     // Register the approval (replacing any previous approval).
322     _approve(_tokenId, _to);
323 
324     // Emit approval event.
325     emit Approval(msg.sender, _to, _tokenId);
326   }
327 
328   /**
329    * @dev Transfers a token owned by another address, for which the calling address
330    *      has previously been granted transfer approval by the owner.
331    * @param _from The address that owns the token to be transferred
332    * @param _to The address that should take ownership of the token. Can be any address,
333    *            including the caller
334    * @param _tokenId The ID of the token to be transferred
335    */
336   function transferFrom(
337     address _from,
338     address _to,
339     uint256 _tokenId
340   )
341     whenNotPaused
342     external
343   {
344     // Safety check to prevent against an unexpected 0x0 default.
345     require(_to != address(0));
346 
347     // Disallow transfers to this contract to prevent accidental misuse.
348     // The contract should never own any tokens (except very briefly
349     // after a release token is created and before it goes on auction).
350     require(_to != address(this));
351 
352     // Check for approval and valid ownership
353     require(_approvedFor(msg.sender, _tokenId));
354     require(_owns(_from, _tokenId));
355 
356     // Reassign ownership (also clears pending approvals and emits Transfer event).
357     _transfer(_from, _to, _tokenId);
358   }
359 
360   /**
361    * @dev Returns a list of all tokens assigned to an address.
362    * @param _owner The owner whose tokens we are interested in
363    * @notice This method MUST NEVER be called by smart contract code. First, it's fairly
364    *         expensive (it walks the entire token array looking for tokens belonging to owner),
365    *         but it also returns a dynamic array, which is only supported for web3 calls, and
366    *         not contract-to-contract calls.
367    */
368   function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
369     uint256 tokenCount = balanceOf(_owner);
370 
371     if (tokenCount == 0) {
372       // Return an empty array
373       return new uint256[](0);
374     } else {
375       uint256[] memory result = new uint256[](tokenCount);
376       uint256 totalTokens = totalSupply();
377       uint256 resultIndex = 0;
378 
379       uint256 tokenId;
380 
381       for (tokenId = 0; tokenId <= totalTokens; tokenId++) {
382         if (tokenIndexToOwner[tokenId] == _owner) {
383           result[resultIndex] = tokenId;
384           resultIndex++;
385         }
386       }
387 
388       return result;
389     }
390   }
391 
392   /**
393    * @dev Set the reference to the auction contract.
394    * @param _address Address of auction contract
395    */
396   function setAuctionAddress(address _address) onlyOwner external {
397     CurioAuction candidateContract = CurioAuction(_address);
398 
399     require(candidateContract.isCurioAuction());
400 
401     // Set the new contract address
402     auction = candidateContract;
403   }
404 
405   /**
406    * @dev Put a token up for auction.
407    * @param _tokenId ID of token to auction, sender must be owner
408    * @param _startingPrice Price of item (in wei) at beginning of auction
409    * @param _endingPrice Price of item (in wei) at end of auction
410    * @param _duration Length of auction (in seconds)
411    */
412   function createAuction(
413     uint256 _tokenId,
414     uint256 _startingPrice,
415     uint256 _endingPrice,
416     uint256 _duration
417   )
418     whenNotPaused
419     external
420   {
421     // Auction contract checks input sizes
422     // If token is already on any auction, this will throw because it will be owned by the auction contract
423     require(_owns(msg.sender, _tokenId));
424 
425     // Set auction contract as approved for token
426     _approve(_tokenId, auction);
427 
428     // Sale auction throws if inputs are invalid
429     auction.createAuction(
430       _tokenId,
431       _startingPrice,
432       _endingPrice,
433       _duration,
434       msg.sender
435     );
436   }
437 
438   /**
439    * @dev Transfers the balance of the auction contract to this contract by owner or admin.
440    */
441   function withdrawAuctionBalance() onlyOwnerOrAdmin external {
442     auction.withdrawBalance();
443   }
444 
445   /**
446    * @dev Creates a new release token with the given name and creates an auction for it.
447    * @param _name Name ot the token
448    * @param _startingPrice Price of item (in wei) at beginning of auction
449    * @param _endingPrice Price of item (in wei) at end of auction
450    * @param _duration Length of auction (in seconds)
451    */
452   function createReleaseTokenAuction(
453     string _name,
454     uint256 _startingPrice,
455     uint256 _endingPrice,
456     uint256 _duration
457   )
458     onlyAdmin
459     external
460   {
461     // Check release tokens limit
462     require(releaseCreatedCount < TOTAL_SUPPLY_LIMIT);
463 
464     // Create token and tranfer ownership to this contract
465     uint256 tokenId = _createToken(_name, address(this));
466 
467     // Set auction address as approved for release token
468     _approve(tokenId, auction);
469 
470     // Call createAuction in auction contract
471     auction.createAuction(
472       tokenId,
473       _startingPrice,
474       _endingPrice,
475       _duration,
476       address(this)
477     );
478 
479     releaseCreatedCount++;
480   }
481 
482   /**
483    * @dev Creates free token and transfer it to recipient.
484    * @param _name Name of the token
485    * @param _to The address of the recipient, can be a user or contract
486    */
487   function createFreeToken(
488     string _name,
489     address _to
490   )
491     onlyAdmin
492     external
493   {
494     require(_to != address(0));
495     require(_to != address(this));
496     require(_to != address(auction));
497 
498     // Check release tokens limit
499     require(releaseCreatedCount < TOTAL_SUPPLY_LIMIT);
500 
501     // Create token and transfer to owner
502     _createToken(_name, _to);
503 
504     releaseCreatedCount++;
505   }
506 
507 
508   // -----------------------------------------
509   // Internal interface
510   // -----------------------------------------
511 
512 
513   /**
514    * @dev Create a new token and stores it.
515    * @param _name Token name
516    * @param _owner The initial owner of this token, must be non-zero
517    */
518   function _createToken(
519     string _name,
520     address _owner
521   )
522     internal
523     returns (uint)
524   {
525     Token memory _token = Token({
526       name: _name
527     });
528 
529     uint256 newTokenId = tokens.push(_token) - 1;
530 
531     // Check overflow newTokenId
532     require(newTokenId == uint256(uint32(newTokenId)));
533 
534     emit Create(_owner, newTokenId, _name);
535 
536     // This will assign ownership
537     _transfer(0, _owner, newTokenId);
538 
539     return newTokenId;
540   }
541 
542   /**
543    * @dev Check claimant address as token owner.
544    * @param _claimant The address we are validating against
545    * @param _tokenId Token id, only valid when > 0
546    */
547   function _owns(
548     address _claimant,
549     uint256 _tokenId
550   )
551     internal
552     view
553     returns (bool)
554   {
555     return tokenIndexToOwner[_tokenId] == _claimant;
556   }
557 
558   /**
559    * @dev Check if a given address currently has transferApproval for a particular token.
560    * @param _claimant The address we are confirming token is approved for
561    * @param _tokenId Token id, only valid when > 0
562    */
563   function _approvedFor(
564     address _claimant,
565     uint256 _tokenId
566   )
567     internal
568     view
569     returns (bool)
570   {
571     return tokenIndexToApproved[_tokenId] == _claimant;
572   }
573 
574   /**
575    * @dev Marks an address as being approved for transferFrom().
576    *      Setting _approved to address(0) clears all transfer approval.
577    *      NOTE: _approve() does NOT send the Approval event. This is intentional because
578    *      _approve() and transferFrom() are used together for putting tokens on auction, and
579    *      there is no value in spamming the log with Approval events in that case.
580    */
581   function _approve(
582     uint256 _tokenId,
583     address _approved
584   )
585     internal
586   {
587     tokenIndexToApproved[_tokenId] = _approved;
588   }
589 
590   /**
591    * @dev Assigns ownership of a specific token to an address.
592    */
593   function _transfer(
594     address _from,
595     address _to,
596     uint256 _tokenId
597   )
598     internal
599   {
600     ownershipTokenCount[_to]++;
601 
602     // Transfer ownership
603     tokenIndexToOwner[_tokenId] = _to;
604 
605     // When creating new token _from is 0x0, but we can't account that address
606     if (_from != address(0)) {
607       ownershipTokenCount[_from]--;
608 
609       // Clear any previously approved ownership exchange
610       delete tokenIndexToApproved[_tokenId];
611     }
612 
613     emit Transfer(_from, _to, _tokenId);
614   }
615 }