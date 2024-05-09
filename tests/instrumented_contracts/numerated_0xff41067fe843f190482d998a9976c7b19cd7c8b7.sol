1 pragma solidity ^0.4.11;
2 
3 pragma solidity ^0.4.10;
4 pragma solidity ^0.4.18;
5 
6 pragma solidity ^0.4.18;
7 
8 pragma solidity ^0.4.18;
9 
10 /**
11  * @title ERC721 Non-Fungible Token Standard basic interface
12  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
13  */
14 contract ERC721Basic {
15   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
16   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
17   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
18 
19   function balanceOf(address _owner) public view returns (uint256 _balance);
20   function ownerOf(uint256 _tokenId) public view returns (address _owner);
21   function exists(uint256 _tokenId) public view returns (bool _exists);
22   
23   function approve(address _to, uint256 _tokenId) public;
24   function getApproved(uint256 _tokenId) public view returns (address _operator);
25   
26   function setApprovalForAll(address _operator, bool _approved) public;
27   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
28 
29   function transferFrom(address _from, address _to, uint256 _tokenId) public;
30   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
31   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
32 }
33 
34 
35 /**
36  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
37  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
38  */
39 contract ERC721Enumerable is ERC721Basic {
40   function totalSupply() public view returns (uint256);
41   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
42   function tokenByIndex(uint256 _index) public view returns (uint256);
43 }
44 
45 /**
46  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
47  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
48  */
49 contract ERC721Metadata is ERC721Basic {
50   function name() public view returns (string _name);
51   function symbol() public view returns (string _symbol);
52   function tokenURI(uint256 _tokenId) public view returns (string);
53 }
54 
55 /**
56  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
57  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
58  */
59 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
60 }
61 
62 pragma solidity ^0.4.18;
63 
64 
65 pragma solidity ^0.4.18;
66 
67 /**
68  * @title ERC721 token receiver interface
69  * @dev Interface for any contract that wants to support safeTransfers
70  *  from ERC721 asset contracts.
71  */
72 contract ERC721Receiver {
73   /**
74    * @dev Magic value to be returned upon successful reception of an NFT
75    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
76    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
77    */
78   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
79 
80   /**
81    * @notice Handle the receipt of an NFT
82    * @dev The ERC721 smart contract calls this function on the recipient
83    *  after a `safetransfer`. This function MAY throw to revert and reject the
84    *  transfer. This function MUST use 50,000 gas or less. Return of other
85    *  than the magic value MUST result in the transaction being reverted.
86    *  Note: the contract address is always the message sender.
87    * @param _from The sending address 
88    * @param _tokenId The NFT identifier which is being transfered
89    * @param _data Additional data with no specified format
90    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
91    */
92   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
93 }
94 
95 pragma solidity ^0.4.18;
96 
97 
98 /**
99  * @title SafeMath
100  * @dev Math operations with safety checks that throw on error
101  */
102 library SafeMath {
103 
104   /**
105   * @dev Multiplies two numbers, throws on overflow.
106   */
107   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108     if (a == 0) {
109       return 0;
110     }
111     uint256 c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return c;
124   }
125 
126   /**
127   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint256 a, uint256 b) internal pure returns (uint256) {
138     uint256 c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 }
143 
144 pragma solidity ^0.4.18;
145 
146 /**
147  * Utility library of inline functions on addresses
148  */
149 library AddressUtils {
150 
151   /**
152    * Returns whether there is code in the target address
153    * @dev This function will return false if invoked during the constructor of a contract,
154    *  as the code is not actually created until after the constructor finishes.
155    * @param addr address address to check
156    * @return whether there is code in the target address
157    */
158   function isContract(address addr) internal view returns (bool) {
159     uint256 size;
160     assembly { size := extcodesize(addr) }
161     return size > 0;
162   }
163 
164 }
165 
166 
167 /**
168  * @title ERC721 Non-Fungible Token Standard basic implementation
169  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
170  */
171 contract ERC721BasicToken is ERC721Basic {
172   using SafeMath for uint256;
173   using AddressUtils for address;
174 
175   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
176   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
177   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
178 
179   // Mapping from token ID to owner
180   mapping (uint256 => address) internal tokenOwner;
181 
182   // Mapping from token ID to approved address
183   mapping (uint256 => address) internal tokenApprovals;
184 
185   // Mapping from owner to number of owned token
186   mapping (address => uint256) internal ownedTokensCount;
187 
188   // Mapping from owner to operator approvals
189   mapping (address => mapping (address => bool)) internal operatorApprovals;
190 
191   /**
192   * @dev Guarantees msg.sender is owner of the given token
193   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
194   */
195   modifier onlyOwnerOf(uint256 _tokenId) {
196     require(ownerOf(_tokenId) == msg.sender);
197     _;
198   }
199 
200   /**
201   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
202   * @param _tokenId uint256 ID of the token to validate
203   */
204   modifier canTransfer(uint256 _tokenId) {
205     require(isApprovedOrOwner(msg.sender, _tokenId));
206     _;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address
211   * @param _owner address to query the balance of
212   * @return uint256 representing the amount owned by the passed address
213   */
214   function balanceOf(address _owner) public view returns (uint256) {
215     require(_owner != address(0));
216     return ownedTokensCount[_owner];
217   }
218 
219   /**
220   * @dev Gets the owner of the specified token ID
221   * @param _tokenId uint256 ID of the token to query the owner of
222   * @return owner address currently marked as the owner of the given token ID
223   */
224   function ownerOf(uint256 _tokenId) public view returns (address) {
225     address owner = tokenOwner[_tokenId];
226     require(owner != address(0));
227     return owner;
228   }
229 
230   /**
231   * @dev Returns whether the specified token exists
232   * @param _tokenId uint256 ID of the token to query the existance of
233   * @return whether the token exists
234   */
235   function exists(uint256 _tokenId) public view returns (bool) {
236     address owner = tokenOwner[_tokenId];
237     return owner != address(0);
238   }
239 
240   /**
241   * @dev Approves another address to transfer the given token ID
242   * @dev The zero address indicates there is no approved address.
243   * @dev There can only be one approved address per token at a given time.
244   * @dev Can only be called by the token owner or an approved operator.
245   * @param _to address to be approved for the given token ID
246   * @param _tokenId uint256 ID of the token to be approved
247   */
248   function approve(address _to, uint256 _tokenId) public {
249     address owner = ownerOf(_tokenId);
250     require(_to != owner);
251     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
252 
253     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
254       tokenApprovals[_tokenId] = _to;
255       Approval(owner, _to, _tokenId);
256     }
257   }
258 
259   /**
260    * @dev Gets the approved address for a token ID, or zero if no address set
261    * @param _tokenId uint256 ID of the token to query the approval of
262    * @return address currently approved for a the given token ID
263    */
264   function getApproved(uint256 _tokenId) public view returns (address) {
265     return tokenApprovals[_tokenId];
266   }
267 
268 
269   /**
270   * @dev Sets or unsets the approval of a given operator
271   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
272   * @param _to operator address to set the approval
273   * @param _approved representing the status of the approval to be set
274   */
275   function setApprovalForAll(address _to, bool _approved) public {
276     require(_to != msg.sender);
277     operatorApprovals[msg.sender][_to] = _approved;
278     ApprovalForAll(msg.sender, _to, _approved);
279   }
280 
281   /**
282    * @dev Tells whether an operator is approved by a given owner
283    * @param _owner owner address which you want to query the approval of
284    * @param _operator operator address which you want to query the approval of
285    * @return bool whether the given operator is approved by the given owner
286    */
287   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
288     return operatorApprovals[_owner][_operator];
289   }
290 
291   /**
292   * @dev Transfers the ownership of a given token ID to another address
293   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
294   * @dev Requires the msg sender to be the owner, approved, or operator
295   * @param _from current owner of the token
296   * @param _to address to receive the ownership of the given token ID
297   * @param _tokenId uint256 ID of the token to be transferred
298   */
299   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
300     require(_from != address(0));
301     require(_to != address(0));
302 
303     clearApproval(_from, _tokenId);
304     removeTokenFrom(_from, _tokenId);
305     addTokenTo(_to, _tokenId);
306 
307     Transfer(_from, _to, _tokenId);
308   }
309 
310   /**
311   * @dev Safely transfers the ownership of a given token ID to another address
312   * @dev If the target address is a contract, it must implement `onERC721Received`,
313   *  which is called upon a safe transfer, and return the magic value
314   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
315   *  the transfer is reverted.
316   * @dev Requires the msg sender to be the owner, approved, or operator
317   * @param _from current owner of the token
318   * @param _to address to receive the ownership of the given token ID
319   * @param _tokenId uint256 ID of the token to be transferred
320   */
321   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
322     safeTransferFrom(_from, _to, _tokenId, "");
323   }
324 
325   /**
326   * @dev Safely transfers the ownership of a given token ID to another address
327   * @dev If the target address is a contract, it must implement `onERC721Received`,
328   *  which is called upon a safe transfer, and return the magic value
329   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
330   *  the transfer is reverted.
331   * @dev Requires the msg sender to be the owner, approved, or operator
332   * @param _from current owner of the token
333   * @param _to address to receive the ownership of the given token ID
334   * @param _tokenId uint256 ID of the token to be transferred
335   * @param _data bytes data to send along with a safe transfer check
336   */
337   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
338     transferFrom(_from, _to, _tokenId);
339     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
340   }
341 
342   /**
343    * @dev Returns whether the given spender can transfer a given token ID
344    * @param _spender address of the spender to query
345    * @param _tokenId uint256 ID of the token to be transferred
346    * @return bool whether the msg.sender is approved for the given token ID,
347    *  is an operator of the owner, or is the owner of the token
348    */
349   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
350     address owner = ownerOf(_tokenId);
351     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
352   }
353 
354   /**
355   * @dev Internal function to mint a new token
356   * @dev Reverts if the given token ID already exists
357   * @param _to The address that will own the minted token
358   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
359   */
360   function _mint(address _to, uint256 _tokenId) internal {
361     require(_to != address(0));
362     addTokenTo(_to, _tokenId);
363     Transfer(address(0), _to, _tokenId);
364   }
365 
366   /**
367   * @dev Internal function to burn a specific token
368   * @dev Reverts if the token does not exist
369   * @param _tokenId uint256 ID of the token being burned by the msg.sender
370   */
371   function _burn(address _owner, uint256 _tokenId) internal {
372     clearApproval(_owner, _tokenId);
373     removeTokenFrom(_owner, _tokenId);
374     Transfer(_owner, address(0), _tokenId);
375   }
376 
377   /**
378   * @dev Internal function to clear current approval of a given token ID
379   * @dev Reverts if the given address is not indeed the owner of the token
380   * @param _owner owner of the token
381   * @param _tokenId uint256 ID of the token to be transferred
382   */
383   function clearApproval(address _owner, uint256 _tokenId) internal {
384     require(ownerOf(_tokenId) == _owner);
385     if (tokenApprovals[_tokenId] != address(0)) {
386       tokenApprovals[_tokenId] = address(0);
387       Approval(_owner, address(0), _tokenId);
388     }
389   }
390 
391   /**
392   * @dev Internal function to add a token ID to the list of a given address
393   * @param _to address representing the new owner of the given token ID
394   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
395   */
396   function addTokenTo(address _to, uint256 _tokenId) internal {
397     require(tokenOwner[_tokenId] == address(0));
398     tokenOwner[_tokenId] = _to;
399     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
400   }
401 
402   /**
403   * @dev Internal function to remove a token ID from the list of a given address
404   * @param _from address representing the previous owner of the given token ID
405   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
406   */
407   function removeTokenFrom(address _from, uint256 _tokenId) internal {
408     require(ownerOf(_tokenId) == _from);
409     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
410     tokenOwner[_tokenId] = address(0);
411   }
412 
413   /**
414   * @dev Internal function to invoke `onERC721Received` on a target address
415   * @dev The call is not executed if the target address is not a contract
416   * @param _from address representing the previous owner of the given token ID
417   * @param _to target address that will receive the tokens
418   * @param _tokenId uint256 ID of the token to be transferred
419   * @param _data bytes optional data to send along with the call
420   * @return whether the call correctly returned the expected magic value
421   */
422   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
423     if (!_to.isContract()) {
424       return true;
425     }
426     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
427     return (retval == ERC721_RECEIVED);
428   }
429 }
430 
431 
432 
433 /**
434  * @title Full ERC721 Token
435  * This implementation includes all the required and some optional functionality of the ERC721 standard
436  * Moreover, it includes approve all functionality using operator terminology
437  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
438  */
439 contract ERC721Token is ERC721, ERC721BasicToken {
440   // Token name
441   string internal name_;
442 
443   // Token symbol
444   string internal symbol_;
445 
446   // Mapping from owner to list of owned token IDs
447   mapping (address => uint256[]) internal ownedTokens;
448 
449   // Mapping from token ID to index of the owner tokens list
450   mapping(uint256 => uint256) internal ownedTokensIndex;
451 
452   // Array with all token ids, used for enumeration
453   uint256[] internal allTokens;
454 
455   // Mapping from token id to position in the allTokens array
456   mapping(uint256 => uint256) internal allTokensIndex;
457 
458   // Optional mapping for token URIs
459   mapping(uint256 => string) internal tokenURIs;
460 
461   /**
462   * @dev Constructor function
463   */
464   function ERC721Token(string _name, string _symbol) public {
465     name_ = _name;
466     symbol_ = _symbol;
467   }
468 
469   /**
470   * @dev Gets the token name
471   * @return string representing the token name
472   */
473   function name() public view returns (string) {
474     return name_;
475   }
476 
477   /**
478   * @dev Gets the token symbol
479   * @return string representing the token symbol
480   */
481   function symbol() public view returns (string) {
482     return symbol_;
483   }
484 
485   /**
486   * @dev Returns an URI for a given token ID
487   * @dev Throws if the token ID does not exist. May return an empty string.
488   * @param _tokenId uint256 ID of the token to query
489   */
490   function tokenURI(uint256 _tokenId) public view returns (string) {
491     require(exists(_tokenId));
492     return tokenURIs[_tokenId];
493   }
494 
495   /**
496   * @dev Internal function to set the token URI for a given token
497   * @dev Reverts if the token ID does not exist
498   * @param _tokenId uint256 ID of the token to set its URI
499   * @param _uri string URI to assign
500   */
501   function _setTokenURI(uint256 _tokenId, string _uri) internal {
502     require(exists(_tokenId));
503     tokenURIs[_tokenId] = _uri;
504   }
505 
506   /**
507   * @dev Gets the token ID at a given index of the tokens list of the requested owner
508   * @param _owner address owning the tokens list to be accessed
509   * @param _index uint256 representing the index to be accessed of the requested tokens list
510   * @return uint256 token ID at the given index of the tokens list owned by the requested address
511   */
512   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
513     require(_index < balanceOf(_owner));
514     return ownedTokens[_owner][_index];
515   }
516 
517   /**
518   * @dev Gets the total amount of tokens stored by the contract
519   * @return uint256 representing the total amount of tokens
520   */
521   function totalSupply() public view returns (uint256) {
522     return allTokens.length;
523   }
524 
525   /**
526   * @dev Gets the token ID at a given index of all the tokens in this contract
527   * @dev Reverts if the index is greater or equal to the total number of tokens
528   * @param _index uint256 representing the index to be accessed of the tokens list
529   * @return uint256 token ID at the given index of the tokens list
530   */
531   function tokenByIndex(uint256 _index) public view returns (uint256) {
532     require(_index < totalSupply());
533     return allTokens[_index];
534   }
535 
536   /**
537   * @dev Internal function to add a token ID to the list of a given address
538   * @param _to address representing the new owner of the given token ID
539   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
540   */
541   function addTokenTo(address _to, uint256 _tokenId) internal {
542     super.addTokenTo(_to, _tokenId);
543     uint256 length = ownedTokens[_to].length;
544     ownedTokens[_to].push(_tokenId);
545     ownedTokensIndex[_tokenId] = length;
546   }
547 
548   /**
549   * @dev Internal function to remove a token ID from the list of a given address
550   * @param _from address representing the previous owner of the given token ID
551   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
552   */
553   function removeTokenFrom(address _from, uint256 _tokenId) internal {
554     super.removeTokenFrom(_from, _tokenId);
555 
556     uint256 tokenIndex = ownedTokensIndex[_tokenId];
557     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
558     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
559 
560     ownedTokens[_from][tokenIndex] = lastToken;
561     ownedTokens[_from][lastTokenIndex] = 0;
562     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
563     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
564     // the lastToken to the first position, and then dropping the element placed in the last position of the list
565 
566     ownedTokens[_from].length--;
567     ownedTokensIndex[_tokenId] = 0;
568     ownedTokensIndex[lastToken] = tokenIndex;
569   }
570 
571   /**
572   * @dev Internal function to mint a new token
573   * @dev Reverts if the given token ID already exists
574   * @param _to address the beneficiary that will own the minted token
575   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
576   */
577   function _mint(address _to, uint256 _tokenId) internal {
578     super._mint(_to, _tokenId);
579 
580     allTokensIndex[_tokenId] = allTokens.length;
581     allTokens.push(_tokenId);
582   }
583 
584   /**
585   * @dev Internal function to burn a specific token
586   * @dev Reverts if the token does not exist
587   * @param _owner owner of the token to burn
588   * @param _tokenId uint256 ID of the token being burned by the msg.sender
589   */
590   function _burn(address _owner, uint256 _tokenId) internal {
591     super._burn(_owner, _tokenId);
592 
593     // Clear metadata (if any)
594     if (bytes(tokenURIs[_tokenId]).length != 0) {
595       delete tokenURIs[_tokenId];
596     }
597 
598     // Reorg all tokens array
599     uint256 tokenIndex = allTokensIndex[_tokenId];
600     uint256 lastTokenIndex = allTokens.length.sub(1);
601     uint256 lastToken = allTokens[lastTokenIndex];
602 
603     allTokens[tokenIndex] = lastToken;
604     allTokens[lastTokenIndex] = 0;
605 
606     allTokens.length--;
607     allTokensIndex[_tokenId] = 0;
608     allTokensIndex[lastToken] = tokenIndex;
609   }
610 
611 }
612 
613 
614 contract RareCoin is ERC721Token("RareCoin", "XRC") {
615     bool[100] internal _initialized;
616     address _auctionContract;
617 
618     function RareCoin(address auctionContract) public {
619         _auctionContract = auctionContract;
620     }
621 
622   /**
623    * @notice Creates a RareCoin token.  Only callable by the RareCoin auction contract
624    * @dev This will fail if not called by the auction contract
625    * @param i Coin number
626    */
627     function CreateToken(address owner, uint i) public {
628         require(msg.sender == _auctionContract);
629         require(!_initialized[i - 1]);
630 
631         _initialized[i - 1] = true;
632 
633         _mint(owner, i);
634     }
635 }
636 
637 
638 
639 /**
640  * @title Auction contract for RareCoin
641  */
642 contract RareCoinAuction {
643     using SafeMath for uint256;
644 
645     //  Block number for the end of the auction
646     uint internal _auctionEnd;
647 
648     //  Toggles the auction from allowing bids to allowing withdrawals
649     bool internal _ended;
650 
651     //  Address of auction beneficiary
652     address internal _beneficiary;
653 
654     //  Used to only allow the beneficiary to withdraw once
655     bool internal _beneficiaryWithdrawn;
656 
657     //  Value of bid #100
658     uint internal _lowestBid;
659 
660     //  Used for details of the top 100 bids
661     struct Bidder {
662         uint bid;
663         address bidderAddress;
664     }
665 
666     //  Used for details of every bid
667     struct BidDetails {
668         uint value;
669         uint lastTime;
670     }
671 
672     //  Contains details of every bid
673     mapping(address => BidDetails) internal _bidders;
674 
675     //  Static array recording highest 100 bidders in sorted order
676     Bidder[100] internal _topBids;
677 
678     //  Address of coin contract
679     address internal _rcContract;
680     bool[100] internal _coinWithdrawn;
681 
682     event NewBid(address bidder, uint amount);
683 
684     event TopThreeChanged(
685         address first, uint firstBid,
686         address second, uint secondBid,
687         address third, uint thirdBid
688     );
689 
690     event AuctionEnded(
691         address first, uint firstBid,
692         address second, uint secondBid,
693         address third, uint thirdBid
694     );
695 
696   /**
697    * @notice Constructor
698    * @param biddingTime Number of blocks auction should last for
699    */
700     function RareCoinAuction(uint biddingTime) public {
701         _auctionEnd = block.number + biddingTime;
702         _beneficiary = msg.sender;
703     }
704 
705   /**
706    * @notice Connect the auction contract to the RareCoin contract
707    * @param rcContractAddress Address of RareCoin contract
708    */
709     function setRCContractAddress(address rcContractAddress) public {
710         require(msg.sender == _beneficiary);
711         require(_rcContract == address(0));
712 
713         _rcContract = rcContractAddress;
714     }
715 
716   /**
717    * @notice Bid `(msg.value)` ether for a chance of winning a RareCoin
718    * @dev This will be rejected if the bid will not end up in the top 100
719    */
720     function bid() external payable {
721         require(block.number < _auctionEnd);
722 
723         uint proposedBid = _bidders[msg.sender].value.add(msg.value);
724 
725         //  No point in accepting a bid if it isn't going to result in a chance of a RareCoin
726         require(proposedBid > _lowestBid);
727 
728         //  Check whether the bidder is already in the top 100.  Note, not enough to check currentBid > _lowestBid
729         //  since there can be multiple bids of the same value
730         uint startPos = 99;
731         if (_bidders[msg.sender].value >= _lowestBid) {
732             //  Note: loop condition relies on overflow
733             for (uint i = 99; i < 100; --i) {
734                 if (_topBids[i].bidderAddress == msg.sender) {
735                     startPos = i;
736                     break;
737                 }
738             }
739         }
740 
741         //  Do one pass of an insertion sort to maintain _topBids in order
742         uint endPos;
743         for (uint j = startPos; j < 100; --j) {
744             if (j != 0 && proposedBid > _topBids[j - 1].bid) {
745                 _topBids[j] = _topBids[j - 1];
746             } else {
747                 _topBids[j].bid = proposedBid;
748                 _topBids[j].bidderAddress = msg.sender;
749                 endPos = j;
750                 break;
751             }
752         }
753 
754         //  Update _bidders with new information
755         _bidders[msg.sender].value = proposedBid;
756         _bidders[msg.sender].lastTime = now;
757 
758         //  Record bid of 100th place bidder for next time
759         _lowestBid = _topBids[99].bid;
760 
761         //  If top 3 bidders changes, log event to blockchain
762         if (endPos < 3) {
763             TopThreeChanged(
764                 _topBids[0].bidderAddress, _topBids[0].bid,
765                 _topBids[1].bidderAddress, _topBids[1].bid,
766                 _topBids[2].bidderAddress, _topBids[2].bid
767             );
768         }
769 
770         NewBid(msg.sender, _bidders[msg.sender].value);
771 
772     }
773 
774   /**
775    * @notice Withdraw the total of the top 100 bids into the beneficiary account
776    */
777     function beneficiaryWithdraw() external {
778         require(msg.sender == _beneficiary);
779         require(_ended);
780         require(!_beneficiaryWithdrawn);
781 
782         uint total = 0;
783         for (uint i = 0; i < 100; ++i) {
784             total = total.add(_topBids[i].bid);
785         }
786 
787         _beneficiaryWithdrawn = true;
788 
789         _beneficiary.transfer(total);
790     }
791 
792   /**
793    * @notice Withdraw your deposit at the end of the auction
794    * @return Whether the withdrawal succeeded
795    */
796     function withdraw() external returns (bool) {
797         require(_ended);
798 
799         //  The user should not be able to withdraw if they are in the top 100 bids
800         //  Cannot simply require(proposedBid > _lowestBid) since bid #100 can be
801         //  the same value as bid #101
802         for (uint i = 0; i < 100; ++i) {
803             require(_topBids[i].bidderAddress != msg.sender);
804         }
805 
806         uint amount = _bidders[msg.sender].value;
807         if (amount > 0) {
808             _bidders[msg.sender].value = 0;
809             msg.sender.transfer(amount);
810         }
811         return true;
812     }
813 
814   /**
815    * @notice Withdraw your RareCoin if you are in the top 100 bidders at the end of the auction
816    * @dev This function creates the RareCoin token in the corresponding address.  Can be called
817    * by anyone.  Note that it is the coin number (1 based) not array index that is supplied
818    * @param tokenNumber The number of the RareCoin to withdraw.
819    * @return Whether The auction succeeded
820    */
821     function withdrawToken(uint tokenNumber) external returns (bool) {
822         require(_ended);
823         require(!_coinWithdrawn[tokenNumber - 1]);
824 
825         _coinWithdrawn[tokenNumber - 1] = true;
826 
827         RareCoin(_rcContract).CreateToken(_topBids[tokenNumber - 1].bidderAddress, tokenNumber);
828 
829         return true;
830     }
831 
832   /**
833    * @notice End the auction, allowing the withdrawal of ether and tokens
834    */
835     function endAuction() external {
836         require(block.number >= _auctionEnd);
837         require(!_ended);
838 
839         _ended = true;
840         AuctionEnded(
841             _topBids[0].bidderAddress, _topBids[0].bid,
842             _topBids[1].bidderAddress, _topBids[1].bid,
843             _topBids[2].bidderAddress, _topBids[2].bid
844         );
845     }
846 
847   /**
848    * @notice Returns the value of `(_addr)`'s bid and the time it occurred
849    * @param _addr Address to query for balance
850    * @return Tuple (value, bidTime)
851    */
852     function getBidDetails(address _addr) external view returns (uint, uint) {
853         return (_bidders[_addr].value, _bidders[_addr].lastTime);
854     }
855 
856   /**
857    * @notice Returns a sorted array of the top 100 bidders
858    * @return The top 100 bidders, sorted by bid
859    */
860     function getTopBidders() external view returns (address[100]) {
861         address[100] memory tempArray;
862 
863         for (uint i = 0; i < 100; ++i) {
864             tempArray[i] = _topBids[i].bidderAddress;
865         }
866 
867         return tempArray;
868     }
869 
870   /**
871    * @notice Get the block the auction ends on
872    * @return The block the auction ends on
873    */
874     function getAuctionEnd() external view returns (uint) {
875         return _auctionEnd;
876     }
877 
878   /**
879    * @notice Get whether the auction has ended
880    * @return Whether the auction has ended
881    */
882     function getEnded() external view returns (bool) {
883         return _ended;
884     }
885 
886   /**
887    * @notice Get the address of the RareCoin contract
888    * @return The address of the RareCoin contract
889    */
890     function getRareCoinAddress() external view returns (address) {
891         return _rcContract;
892     }
893 }