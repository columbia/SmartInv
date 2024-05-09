1 pragma solidity ^0.4.21;
2 
3 /// @title ERC-165 Standard Interface Detection
4 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
5 interface ERC165 {
6     function supportsInterface(bytes4 interfaceID) external view returns (bool);
7 }
8 
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 
51 
52 
53 
54 
55 
56 /// @title ERC-721 Non-Fungible Token Standard
57 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
58 contract ERC721 is ERC165 {
59     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
60     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
61     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
62     function balanceOf(address _owner) external view returns (uint256);
63     function ownerOf(uint256 _tokenId) external view returns (address);
64     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public payable;
65     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable;
66     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
67     function approve(address _approved, uint256 _tokenId) external payable;
68     function setApprovalForAll(address _operator, bool _approved) external;
69     function getApproved(uint256 _tokenId) external view returns (address);
70     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
71 }
72 
73 /// @title ERC-721 Non-Fungible Token Standard
74 interface ERC721TokenReceiver {
75 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
76 }
77 
78 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
79 interface ERC721Metadata /* is ERC721 */ {
80     function name() external pure returns (string _name);
81     function symbol() external pure returns (string _symbol);
82     function tokenURI(uint256 _tokenId) external view returns (string);
83 }
84 
85 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
86 interface ERC721Enumerable /* is ERC721 */ {
87     function totalSupply() external view returns (uint256);
88     function tokenByIndex(uint256 _index) external view returns (uint256);
89     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
90 }
91 
92 
93 
94 
95 
96 /// @title A reusable contract to comply with ERC-165
97 /// @author William Entriken (https://phor.net)
98 contract PublishInterfaces is ERC165 {
99     /// @dev Every interface that we support
100     mapping(bytes4 => bool) internal supportedInterfaces;
101 
102     function PublishInterfaces() internal {
103         supportedInterfaces[0x01ffc9a7] = true; // ERC165
104     }
105 
106     /// @notice Query if a contract implements an interface
107     /// @param interfaceID The interface identifier, as specified in ERC-165
108     /// @dev Interface identification is specified in ERC-165. This function
109     ///  uses less than 30,000 gas.
110     /// @return `true` if the contract implements `interfaceID` and
111     ///  `interfaceID` is not 0xffffffff, `false` otherwise
112     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
113         return supportedInterfaces[interfaceID] && (interfaceID != 0xffffffff);
114     }
115 }
116 
117 
118 
119 
120 /// @title The external contract that is responsible for generating metadata for GanTokens,
121 ///  it has one function that will return the data as bytes.
122 contract Metadata {
123 
124     /// @dev Given a token Id, returns a string with metadata
125     function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
126         if (_tokenId == 1) {
127             buffer[0] = "Hello World! :D";
128             count = 15;
129         } else if (_tokenId == 2) {
130             buffer[0] = "I would definitely choose a medi";
131             buffer[1] = "um length string.";
132             count = 49;
133         } else if (_tokenId == 3) {
134             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
135             buffer[1] = "st accumsan dapibus augue lorem,";
136             buffer[2] = " tristique vestibulum id, libero";
137             buffer[3] = " suscipit varius sapien aliquam.";
138             count = 128;
139         }
140     }
141 
142 }
143 
144 
145 contract GanNFT is ERC165, ERC721, ERC721Enumerable, PublishInterfaces, Ownable {
146 
147   function GanNFT() internal {
148       supportedInterfaces[0x80ac58cd] = true; // ERC721
149       supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
150       supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
151       supportedInterfaces[0x8153916a] = true; // ERC721 + 165 (not needed)
152   }
153 
154   bytes4 private constant ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
155 
156   // @dev claim price taken for each new GanToken
157   // generating a new token will be free in the beinging and later changed
158   uint256 public claimPrice = 0;
159 
160   // @dev max supply for token
161   uint256 public maxSupply = 300;
162 
163   // The contract that will return tokens metadata
164   Metadata public erc721Metadata;
165 
166   /// @dev list of all owned token ids
167   uint256[] public tokenIds;
168 
169   /// @dev a mpping for all tokens
170   mapping(uint256 => address) public tokenIdToOwner;
171 
172   /// @dev mapping to keep owner balances
173   mapping(address => uint256) public ownershipCounts;
174 
175   /// @dev mapping to owners to an array of tokens that they own
176   mapping(address => uint256[]) public ownerBank;
177 
178   /// @dev mapping to approved ids
179   mapping(uint256 => address) public tokenApprovals;
180 
181   /// @dev The authorized operators for each address
182   mapping (address => mapping (address => bool)) internal operatorApprovals;
183 
184   /// @notice A descriptive name for a collection of NFTs in this contract
185   function name() external pure returns (string) {
186       return "GanToken";
187   }
188 
189   /// @notice An abbreviated name for NFTs in this contract
190   function symbol() external pure returns (string) {
191       return "GT";
192   }
193 
194   /// @dev Set the address of the sibling contract that tracks metadata.
195   /// Only the contract creater can call this.
196   /// @param _contractAddress The location of the contract with meta data
197   function setMetadataAddress(address _contractAddress) public onlyOwner {
198       erc721Metadata = Metadata(_contractAddress);
199   }
200 
201   modifier canTransfer(uint256 _tokenId, address _from, address _to) {
202     address owner = tokenIdToOwner[_tokenId];
203     require(tokenApprovals[_tokenId] == _to || owner == _from || operatorApprovals[_to][_to]);
204     _;
205   }
206   /// @notice checks to see if a sender owns a _tokenId
207   /// @param _tokenId The identifier for an NFT
208   modifier owns(uint256 _tokenId) {
209     require(tokenIdToOwner[_tokenId] == msg.sender);
210     _;
211   }
212 
213   /// @dev This emits any time the ownership of a GanToken changes.
214   event Transfer(address indexed _from, address indexed _to, uint256 _value);
215 
216   /// @dev This emits when the approved addresses for a GanToken is changed or reaffirmed.
217   /// The zero address indicates there is no owner and it get reset on a transfer
218   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
219 
220   /// @dev This emits when an operator is enabled or disabled for an owner.
221   ///  The operator can manage all NFTs of the owner.
222   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
223 
224   /// @notice allow the owner to set the supply max
225   function setMaxSupply(uint max) external payable onlyOwner {
226     require(max > tokenIds.length);
227 
228     maxSupply = max;
229   }
230 
231   /// @notice allow the owner to set a new fee for creating a GanToken
232   function setClaimPrice(uint256 price) external payable onlyOwner {
233     claimPrice = price;
234   }
235 
236   /// @dev Required for ERC-721 compliance.
237   function balanceOf(address _owner) external view returns (uint256 balance) {
238     balance = ownershipCounts[_owner];
239   }
240 
241   /// @notice Gets the onwner of a an NFT
242   /// @param _tokenId The identifier for an NFT
243   /// @dev Required for ERC-721 compliance.
244   function ownerOf(uint256 _tokenId) external view returns (address owner) {
245     owner = tokenIdToOwner[_tokenId];
246   }
247 
248   /// @notice returns all owners' tokens will return an empty array
249   /// if the address has no tokens
250   /// @param _owner The address of the owner in question
251   function tokensOfOwner(address _owner) external view returns (uint256[]) {
252     uint256 tokenCount = ownershipCounts[_owner];
253 
254     if (tokenCount == 0) {
255       return new uint256[](0);
256     }
257 
258     uint256[] memory result = new uint256[](tokenCount);
259 
260     for (uint256 i = 0; i < tokenCount; i++) {
261       result[i] = ownerBank[_owner][i];
262     }
263 
264     return result;
265   }
266 
267   /// @dev creates a list of all the tokenIds
268   function getAllTokenIds() external view returns (uint256[]) {
269     uint256[] memory result = new uint256[](tokenIds.length);
270     for (uint i = 0; i < result.length; i++) {
271       result[i] = tokenIds[i];
272     }
273 
274     return result;
275   }
276 
277   /// @notice Create a new GanToken with a id and attaches an owner
278   /// @param _noise The id of the token that's being created
279   function newGanToken(uint256 _noise) external payable {
280     require(msg.sender != address(0));
281     require(tokenIdToOwner[_noise] == 0x0);
282     require(tokenIds.length < maxSupply);
283     require(msg.value >= claimPrice);
284 
285     tokenIds.push(_noise);
286     ownerBank[msg.sender].push(_noise);
287     tokenIdToOwner[_noise] = msg.sender;
288     ownershipCounts[msg.sender]++;
289 
290     emit Transfer(address(0), msg.sender, 0);
291   }
292 
293   /// @notice Transfers the ownership of an NFT from one address to another address
294   /// @dev Throws unless `msg.sender` is the current owner, an authorized
295   ///  operator, or the approved address for this NFT. Throws if `_from` is
296   ///  not the current owner. Throws if `_to` is the zero address. Throws if
297   ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
298   ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
299   ///  `onERC721Received` on `_to` and throws if the return value is not
300   ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
301   /// @param _from The current owner of the NFT
302   /// @param _to The new owner
303   /// @param _tokenId The NFT to transfer
304   /// @param data Additional data with no specified format, sent in call to `_to`
305   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public payable
306   {
307       _safeTransferFrom(_from, _to, _tokenId, data);
308   }
309 
310   /// @notice Transfers the ownership of an NFT from one address to another address
311   /// @dev This works identically to the other function with an extra data parameter,
312   ///  except this function just sets data to ""
313   /// @param _from The current owner of the NFT
314   /// @param _to The new owner
315   /// @param _tokenId The NFT to transfer
316   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable
317   {
318       _safeTransferFrom(_from, _to, _tokenId, "");
319   }
320 
321   /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
322   ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
323   ///  THEY MAY BE PERMANENTLY LOST
324   /// @dev Throws unless `msg.sender` is the current owner, an authorized
325   ///  operator, or the approved address for this NFT. Throws if `_from` is
326   ///  not the current owner. Throws if `_to` is the zero address. Throws if
327   ///  `_tokenId` is not a valid NFT.
328   /// @param _from The current owner of the NFT
329   /// @param _to The new owner
330   /// @param _tokenId The NFT to transfer
331   function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
332     require(_to != 0x0);
333     require(_to != address(this));
334     require(tokenApprovals[_tokenId] == msg.sender);
335     require(tokenIdToOwner[_tokenId] == _from);
336 
337     _transfer(_tokenId, _to);
338   }
339 
340   /// @notice Grant another address the right to transfer a specific token via
341   ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
342   /// @dev The zero address indicates there is no approved address.
343   /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
344   ///  operator of the current owner.
345   /// @dev Required for ERC-721 compliance.
346   /// @param _to The address to be granted transfer approval. Pass address(0) to
347   ///  clear all approvals.
348   /// @param _tokenId The ID of the Kitty that can be transferred if this call succeeds.
349   function approve(address _to, uint256 _tokenId) external owns(_tokenId) payable {
350       // Register the approval (replacing any previous approval).
351       tokenApprovals[_tokenId] = _to;
352 
353       emit Approval(msg.sender, _to, _tokenId);
354   }
355 
356   /// @notice Enable or disable approval for a third party ("operator") to manage
357   ///  all your asset.
358   /// @dev Emits the ApprovalForAll event
359   /// @param _operator Address to add to the set of authorized operators.
360   /// @param _approved True if the operators is approved, false to revoke approval
361   function setApprovalForAll(address _operator, bool _approved) external {
362       operatorApprovals[msg.sender][_operator] = _approved;
363       emit ApprovalForAll(msg.sender, _operator, _approved);
364   }
365 
366   /// @notice Get the approved address for a single NFT
367   /// @param _tokenId The NFT to find the approved address for
368   /// @return The approved address for this NFT, or the zero address if there is none
369   function getApproved(uint256 _tokenId) external view returns (address) {
370       return tokenApprovals[_tokenId];
371   }
372 
373   /// @notice Query if an address is an authorized operator for another address
374   /// @param _owner The address that owns the NFTs
375   /// @param _operator The address that acts on behalf of the owner
376   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
377   function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
378       return operatorApprovals[_owner][_operator];
379   }
380 
381   /// @notice Count NFTs tracked by this contract
382   /// @return A count of valid NFTs tracked by this contract, where each one of
383   ///  them has an assigned and queryable owner not equal to the zero address
384   /// @dev Required for ERC-721 compliance.
385   function totalSupply() external view returns (uint256) {
386     return tokenIds.length;
387   }
388 
389   /// @notice Enumerate valid NFTs
390   /// @param _index A counter less than `totalSupply()`
391   /// @return The token identifier for index the `_index`th NFT 0 if it doesn't exist,
392   function tokenByIndex(uint256 _index) external view returns (uint256) {
393       return tokenIds[_index];
394   }
395 
396   /// @notice Enumerate NFTs assigned to an owner
397   /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
398   ///  `_owner` is the zero address, representing invalid NFTs.
399   /// @param _owner An address where we are interested in NFTs owned by them
400   /// @param _index A counter less than `balanceOf(_owner)`
401   /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
402   ///   (sort order not specified)
403   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId) {
404       require(_owner != address(0));
405       require(_index < ownerBank[_owner].length);
406       _tokenId = ownerBank[_owner][_index];
407   }
408 
409   function _transfer(uint256 _tokenId, address _to) internal {
410     require(_to != address(0));
411 
412     address from = tokenIdToOwner[_tokenId];
413     uint256 tokenCount = ownershipCounts[from];
414     // remove from ownerBank and replace the deleted token id
415     for (uint256 i = 0; i < tokenCount; i++) {
416       uint256 ownedId = ownerBank[from][i];
417       if (_tokenId == ownedId) {
418         delete ownerBank[from][i];
419         if (i != tokenCount) {
420           ownerBank[from][i] = ownerBank[from][tokenCount - 1];
421         }
422         break;
423       }
424     }
425 
426     ownershipCounts[from]--;
427     ownershipCounts[_to]++;
428     ownerBank[_to].push(_tokenId);
429 
430     tokenIdToOwner[_tokenId] = _to;
431     tokenApprovals[_tokenId] = address(0);
432     emit Transfer(from, _to, 1);
433   }
434 
435   /// @dev Actually perform the safeTransferFrom
436   function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data)
437       private
438       canTransfer(_tokenId, _from, _to)
439   {
440       address owner = tokenIdToOwner[_tokenId];
441 
442       require(owner == _from);
443       require(_to != address(0));
444       require(_to != address(this));
445       _transfer(_tokenId, _to);
446 
447 
448       // Do the callback after everything is done to avoid reentrancy attack
449       uint256 codeSize;
450       assembly { codeSize := extcodesize(_to) }
451       if (codeSize == 0) {
452           return;
453       }
454       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
455       require(retval == ERC721_RECEIVED);
456   }
457 
458   /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
459   ///  This method is licenced under the Apache License.
460   ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
461   function _memcpy(uint _dest, uint _src, uint _len) private pure {
462       // Copy word-length chunks while possible
463       for(; _len >= 32; _len -= 32) {
464           assembly {
465               mstore(_dest, mload(_src))
466           }
467           _dest += 32;
468           _src += 32;
469       }
470 
471       // Copy remaining bytes
472       uint256 mask = 256 ** (32 - _len) - 1;
473       assembly {
474           let srcpart := and(mload(_src), not(mask))
475           let destpart := and(mload(_dest), mask)
476           mstore(_dest, or(destpart, srcpart))
477       }
478   }
479 
480   /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
481   ///  This method is licenced under the Apache License.
482   ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
483   function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private pure returns (string) {
484       string memory outputString = new string(_stringLength);
485       uint256 outputPtr;
486       uint256 bytesPtr;
487 
488       assembly {
489           outputPtr := add(outputString, 32)
490           bytesPtr := _rawBytes
491       }
492 
493       _memcpy(outputPtr, bytesPtr, _stringLength);
494 
495       return outputString;
496   }
497 
498 
499   /// @notice Returns a URI pointing to a metadata package for this token conforming to
500   ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
501   /// @param _tokenId The ID number of the GanToken whose metadata should be returned.
502   function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
503       require(erc721Metadata != address(0));
504       uint256 count;
505       bytes32[4] memory buffer;
506 
507       (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
508 
509       return _toString(buffer, count);
510   }
511 
512 }
513 
514 
515 contract GanTokenMain is GanNFT {
516 
517   struct Offer {
518     bool isForSale;
519     uint256 tokenId;
520     address seller;
521     uint value;          // in ether
522     address onlySellTo;     // specify to sell only to a specific person
523   }
524 
525   struct Bid {
526     bool hasBid;
527     uint256 tokenId;
528     address bidder;
529     uint value;
530   }
531 
532   /// @dev mapping of balances for address
533   mapping(address => uint256) public pendingWithdrawals;
534 
535   /// @dev mapping of tokenId to to an offer
536   mapping(uint256 => Offer) public ganTokenOfferedForSale;
537 
538   /// @dev mapping bids to tokenIds
539   mapping(uint256 => Bid) public tokenBids;
540 
541   event BidForGanTokenOffered(uint256 tokenId, uint256 value, address sender);
542   event BidWithdrawn(uint256 tokenId, uint256 value, address bidder);
543   event GanTokenOfferedForSale(uint256 tokenId, uint256 minSalePriceInWei, address onlySellTo);
544   event GanTokenNoLongerForSale(uint256 tokenId);
545 
546 
547   /// @notice Allow a token owner to pull sale
548   /// @param tokenId The id of the token that's created
549   function ganTokenNoLongerForSale(uint256 tokenId) public payable owns(tokenId) {
550     ganTokenOfferedForSale[tokenId] = Offer(false, tokenId, msg.sender, 0, 0x0);
551 
552     emit GanTokenNoLongerForSale(tokenId);
553   }
554 
555   /// @notice Put a token up for sale
556   /// @param tokenId The id of the token that's created
557   /// @param minSalePriceInWei desired price of token
558   function offerGanTokenForSale(uint tokenId, uint256 minSalePriceInWei) external payable owns(tokenId) {
559     ganTokenOfferedForSale[tokenId] = Offer(true, tokenId, msg.sender, minSalePriceInWei, 0x0);
560 
561     emit GanTokenOfferedForSale(tokenId, minSalePriceInWei, 0x0);
562   }
563 
564   /// @notice Create a new GanToken with a id and attaches an owner
565   /// @param tokenId The id of the token that's being created
566   function offerGanTokenForSaleToAddress(uint tokenId, address sendTo, uint256 minSalePriceInWei) external payable {
567     require(tokenIdToOwner[tokenId] == msg.sender);
568     ganTokenOfferedForSale[tokenId] = Offer(true, tokenId, msg.sender, minSalePriceInWei, sendTo);
569 
570     emit GanTokenOfferedForSale(tokenId, minSalePriceInWei, sendTo);
571   }
572 
573   /// @notice Allows an account to buy a NFT gan token that is up for offer
574   /// the token owner must set onlySellTo to the sender
575   /// @param id the id of the token
576   function buyGanToken(uint256 id) public payable {
577     Offer memory offer = ganTokenOfferedForSale[id];
578     require(offer.isForSale);
579     require(offer.onlySellTo == msg.sender && offer.onlySellTo != 0x0);
580     require(msg.value == offer.value);
581     require(tokenIdToOwner[id] == offer.seller);
582 
583     safeTransferFrom(offer.seller, offer.onlySellTo, id);
584 
585     ganTokenOfferedForSale[id] = Offer(false, id, offer.seller, 0, 0x0);
586 
587     pendingWithdrawals[offer.seller] += msg.value;
588   }
589 
590   /// @notice Allows an account to enter a higher bid on a toekn
591   /// @param tokenId the id of the token
592   function enterBidForGanToken(uint256 tokenId) external payable {
593     Bid memory existing = tokenBids[tokenId];
594     require(tokenIdToOwner[tokenId] != msg.sender);
595     require(tokenIdToOwner[tokenId] != 0x0);
596     require(msg.value > existing.value);
597     if (existing.value > 0) {
598       // Refund the failing bid
599       pendingWithdrawals[existing.bidder] += existing.value;
600     }
601 
602     tokenBids[tokenId] = Bid(true, tokenId, msg.sender, msg.value);
603     emit BidForGanTokenOffered(tokenId, msg.value, msg.sender);
604   }
605 
606   /// @notice Allows the owner of a token to accept an outstanding bid for that token
607   /// @param tokenId The id of the token that's being created
608   /// @param price The desired price of token in wei
609   function acceptBid(uint256 tokenId, uint256 price) external payable {
610     require(tokenIdToOwner[tokenId] == msg.sender);
611     Bid memory bid = tokenBids[tokenId];
612     require(bid.value != 0);
613     require(bid.value == price);
614 
615     safeTransferFrom(msg.sender, bid.bidder, tokenId);
616 
617     tokenBids[tokenId] = Bid(false, tokenId, address(0), 0);
618     pendingWithdrawals[msg.sender] += bid.value;
619   }
620 
621   /// @notice Check is a given id is on sale
622   /// @param tokenId The id of the token in question
623   /// @return a bool whether of not the token is on sale
624   function isOnSale(uint256 tokenId) external view returns (bool) {
625     return ganTokenOfferedForSale[tokenId].isForSale;
626   }
627 
628   /// @notice Gets all the sale data related to a token
629   /// @param tokenId The id of the token
630   /// @return sale information
631   function getSaleData(uint256 tokenId) public view returns (bool isForSale, address seller, uint value, address onlySellTo) {
632     Offer memory offer = ganTokenOfferedForSale[tokenId];
633     isForSale = offer.isForSale;
634     seller = offer.seller;
635     value = offer.value;
636     onlySellTo = offer.onlySellTo;
637   }
638 
639   /// @notice Gets all the bid data related to a token
640   /// @param tokenId The id of the token
641   /// @return bid information
642   function getBidData(uint256 tokenId) view public returns (bool hasBid, address bidder, uint value) {
643     Bid memory bid = tokenBids[tokenId];
644     hasBid = bid.hasBid;
645     bidder = bid.bidder;
646     value = bid.value;
647   }
648 
649   /// @notice Allows a bidder to withdraw their bid
650   /// @param tokenId The id of the token
651   function withdrawBid(uint256 tokenId) external payable {
652       Bid memory bid = tokenBids[tokenId];
653       require(tokenIdToOwner[tokenId] != msg.sender);
654       require(tokenIdToOwner[tokenId] != 0x0);
655       require(bid.bidder == msg.sender);
656 
657       emit BidWithdrawn(tokenId, bid.value, msg.sender);
658       uint amount = bid.value;
659       tokenBids[tokenId] = Bid(false, tokenId, 0x0, 0);
660       // Refund the bid money
661       msg.sender.transfer(amount);
662   }
663 
664   /// @notice Allows a sender to withdraw any amount in the contrat
665   function withdraw() external {
666     uint256 amount = pendingWithdrawals[msg.sender];
667     // Remember to zero the pending refund before
668     // sending to prevent re-entrancy attacks
669     pendingWithdrawals[msg.sender] = 0;
670     msg.sender.transfer(amount);
671   }
672 
673 }