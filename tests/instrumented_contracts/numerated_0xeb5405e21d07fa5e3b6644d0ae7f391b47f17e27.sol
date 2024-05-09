1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title ERC721 Non-Fungible Token Standard basic interface
48  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
49  */
50 contract ERC721Basic {
51   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
52   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
53   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
54 
55   function balanceOf(address _owner) public view returns (uint256 _balance);
56   function ownerOf(uint256 _tokenId) public view returns (address _owner);
57   function exists(uint256 _tokenId) public view returns (bool _exists);
58 
59   function approve(address _to, uint256 _tokenId) public;
60   function getApproved(uint256 _tokenId) public view returns (address _operator);
61 
62   function setApprovalForAll(address _operator, bool _approved) public;
63   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
64 
65   function transferFrom(address _from, address _to, uint256 _tokenId) public;
66   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
67   function safeTransferFrom(
68     address _from,
69     address _to,
70     uint256 _tokenId,
71     bytes _data
72   )
73     public;
74 }
75 
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 
93 
94 
95 
96 /**
97  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
98  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
99  */
100 contract ERC721Enumerable is ERC721Basic {
101   function totalSupply() public view returns (uint256);
102   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
103   function tokenByIndex(uint256 _index) public view returns (uint256);
104 }
105 
106 
107 /**
108  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
109  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
110  */
111 contract ERC721Metadata is ERC721Basic {
112   function name() public view returns (string _name);
113   function symbol() public view returns (string _symbol);
114   function tokenURI(uint256 _tokenId) public view returns (string);
115 }
116 
117 
118 /**
119  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
120  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
121  */
122 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
123 }
124 
125 
126 
127 
128 
129 
130 
131 /**
132  * @title ERC721 token receiver interface
133  * @dev Interface for any contract that wants to support safeTransfers
134  *  from ERC721 asset contracts.
135  */
136 contract ERC721Receiver {
137   /**
138    * @dev Magic value to be returned upon successful reception of an NFT
139    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
140    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
141    */
142   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
143 
144   /**
145    * @notice Handle the receipt of an NFT
146    * @dev The ERC721 smart contract calls this function on the recipient
147    *  after a `safetransfer`. This function MAY throw to revert and reject the
148    *  transfer. This function MUST use 50,000 gas or less. Return of other
149    *  than the magic value MUST result in the transaction being reverted.
150    *  Note: the contract address is always the message sender.
151    * @param _from The sending address
152    * @param _tokenId The NFT identifier which is being transfered
153    * @param _data Additional data with no specified format
154    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
155    */
156   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
157 }
158 
159 
160 
161 
162 /**
163  * @title SafeMath
164  * @dev Math operations with safety checks that throw on error
165  */
166 library SafeMath {
167 
168   /**
169   * @dev Multiplies two numbers, throws on overflow.
170   */
171   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
172     if (a == 0) {
173       return 0;
174     }
175     c = a * b;
176     assert(c / a == b);
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers, truncating the quotient.
182   */
183   function div(uint256 a, uint256 b) internal pure returns (uint256) {
184     // assert(b > 0); // Solidity automatically throws when dividing by 0
185     // uint256 c = a / b;
186     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187     return a / b;
188   }
189 
190   /**
191   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
192   */
193   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194     assert(b <= a);
195     return a - b;
196   }
197 
198   /**
199   * @dev Adds two numbers, throws on overflow.
200   */
201   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
202     c = a + b;
203     assert(c >= a);
204     return c;
205   }
206 }
207 
208 
209 
210 
211 /**
212  * Utility library of inline functions on addresses
213  */
214 library AddressUtils {
215 
216   /**
217    * Returns whether the target address is a contract
218    * @dev This function will return false if invoked during the constructor of a contract,
219    *  as the code is not actually created until after the constructor finishes.
220    * @param addr address to check
221    * @return whether the target address is a contract
222    */
223   function isContract(address addr) internal view returns (bool) {
224     uint256 size;
225     // XXX Currently there is no better way to check if there is a contract in an address
226     // than to check the size of the code at that address.
227     // See https://ethereum.stackexchange.com/a/14016/36603
228     // for more details about how this works.
229     // TODO Check this again before the Serenity release, because all addresses will be
230     // contracts then.
231     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
232     return size > 0;
233   }
234 
235 }
236 
237 
238 
239 /**
240  * @title ERC721 Non-Fungible Token Standard basic implementation
241  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
242  */
243 contract ERC721BasicToken is ERC721Basic {
244   using SafeMath for uint256;
245   using AddressUtils for address;
246 
247   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
248   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
249   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
250 
251   // Mapping from token ID to owner
252   mapping (uint256 => address) internal tokenOwner;
253 
254   // Mapping from token ID to approved address
255   mapping (uint256 => address) internal tokenApprovals;
256 
257   // Mapping from owner to number of owned token
258   mapping (address => uint256) internal ownedTokensCount;
259 
260   // Mapping from owner to operator approvals
261   mapping (address => mapping (address => bool)) internal operatorApprovals;
262 
263   /**
264    * @dev Guarantees msg.sender is owner of the given token
265    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
266    */
267   modifier onlyOwnerOf(uint256 _tokenId) {
268     require(ownerOf(_tokenId) == msg.sender);
269     _;
270   }
271 
272   /**
273    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
274    * @param _tokenId uint256 ID of the token to validate
275    */
276   modifier canTransfer(uint256 _tokenId) {
277     require(isApprovedOrOwner(msg.sender, _tokenId));
278     _;
279   }
280 
281   /**
282    * @dev Gets the balance of the specified address
283    * @param _owner address to query the balance of
284    * @return uint256 representing the amount owned by the passed address
285    */
286   function balanceOf(address _owner) public view returns (uint256) {
287     require(_owner != address(0));
288     return ownedTokensCount[_owner];
289   }
290 
291   /**
292    * @dev Gets the owner of the specified token ID
293    * @param _tokenId uint256 ID of the token to query the owner of
294    * @return owner address currently marked as the owner of the given token ID
295    */
296   function ownerOf(uint256 _tokenId) public view returns (address) {
297     address owner = tokenOwner[_tokenId];
298     require(owner != address(0));
299     return owner;
300   }
301 
302   /**
303    * @dev Returns whether the specified token exists
304    * @param _tokenId uint256 ID of the token to query the existance of
305    * @return whether the token exists
306    */
307   function exists(uint256 _tokenId) public view returns (bool) {
308     address owner = tokenOwner[_tokenId];
309     return owner != address(0);
310   }
311 
312   /**
313    * @dev Approves another address to transfer the given token ID
314    * @dev The zero address indicates there is no approved address.
315    * @dev There can only be one approved address per token at a given time.
316    * @dev Can only be called by the token owner or an approved operator.
317    * @param _to address to be approved for the given token ID
318    * @param _tokenId uint256 ID of the token to be approved
319    */
320   function approve(address _to, uint256 _tokenId) public {
321     address owner = ownerOf(_tokenId);
322     require(_to != owner);
323     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
324 
325     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
326       tokenApprovals[_tokenId] = _to;
327       emit Approval(owner, _to, _tokenId);
328     }
329   }
330 
331   /**
332    * @dev Gets the approved address for a token ID, or zero if no address set
333    * @param _tokenId uint256 ID of the token to query the approval of
334    * @return address currently approved for a the given token ID
335    */
336   function getApproved(uint256 _tokenId) public view returns (address) {
337     return tokenApprovals[_tokenId];
338   }
339 
340   /**
341    * @dev Sets or unsets the approval of a given operator
342    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
343    * @param _to operator address to set the approval
344    * @param _approved representing the status of the approval to be set
345    */
346   function setApprovalForAll(address _to, bool _approved) public {
347     require(_to != msg.sender);
348     operatorApprovals[msg.sender][_to] = _approved;
349     emit ApprovalForAll(msg.sender, _to, _approved);
350   }
351 
352   /**
353    * @dev Tells whether an operator is approved by a given owner
354    * @param _owner owner address which you want to query the approval of
355    * @param _operator operator address which you want to query the approval of
356    * @return bool whether the given operator is approved by the given owner
357    */
358   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
359     return operatorApprovals[_owner][_operator];
360   }
361 
362   /**
363    * @dev Transfers the ownership of a given token ID to another address
364    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
365    * @dev Requires the msg sender to be the owner, approved, or operator
366    * @param _from current owner of the token
367    * @param _to address to receive the ownership of the given token ID
368    * @param _tokenId uint256 ID of the token to be transferred
369   */
370   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
371     require(_from != address(0));
372     require(_to != address(0));
373 
374     clearApproval(_from, _tokenId);
375     removeTokenFrom(_from, _tokenId);
376     addTokenTo(_to, _tokenId);
377 
378     emit Transfer(_from, _to, _tokenId);
379   }
380 
381   /**
382    * @dev Safely transfers the ownership of a given token ID to another address
383    * @dev If the target address is a contract, it must implement `onERC721Received`,
384    *  which is called upon a safe transfer, and return the magic value
385    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
386    *  the transfer is reverted.
387    * @dev Requires the msg sender to be the owner, approved, or operator
388    * @param _from current owner of the token
389    * @param _to address to receive the ownership of the given token ID
390    * @param _tokenId uint256 ID of the token to be transferred
391   */
392   function safeTransferFrom(
393     address _from,
394     address _to,
395     uint256 _tokenId
396   )
397     public
398     canTransfer(_tokenId)
399   {
400     // solium-disable-next-line arg-overflow
401     safeTransferFrom(_from, _to, _tokenId, "");
402   }
403 
404   /**
405    * @dev Safely transfers the ownership of a given token ID to another address
406    * @dev If the target address is a contract, it must implement `onERC721Received`,
407    *  which is called upon a safe transfer, and return the magic value
408    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
409    *  the transfer is reverted.
410    * @dev Requires the msg sender to be the owner, approved, or operator
411    * @param _from current owner of the token
412    * @param _to address to receive the ownership of the given token ID
413    * @param _tokenId uint256 ID of the token to be transferred
414    * @param _data bytes data to send along with a safe transfer check
415    */
416   function safeTransferFrom(
417     address _from,
418     address _to,
419     uint256 _tokenId,
420     bytes _data
421   )
422     public
423     canTransfer(_tokenId)
424   {
425     transferFrom(_from, _to, _tokenId);
426     // solium-disable-next-line arg-overflow
427     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
428   }
429 
430   /**
431    * @dev Returns whether the given spender can transfer a given token ID
432    * @param _spender address of the spender to query
433    * @param _tokenId uint256 ID of the token to be transferred
434    * @return bool whether the msg.sender is approved for the given token ID,
435    *  is an operator of the owner, or is the owner of the token
436    */
437   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
438     address owner = ownerOf(_tokenId);
439     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
440   }
441 
442   /**
443    * @dev Internal function to mint a new token
444    * @dev Reverts if the given token ID already exists
445    * @param _to The address that will own the minted token
446    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
447    */
448   function _mint(address _to, uint256 _tokenId) internal {
449     require(_to != address(0));
450     addTokenTo(_to, _tokenId);
451     emit Transfer(address(0), _to, _tokenId);
452   }
453 
454   /**
455    * @dev Internal function to burn a specific token
456    * @dev Reverts if the token does not exist
457    * @param _tokenId uint256 ID of the token being burned by the msg.sender
458    */
459   function _burn(address _owner, uint256 _tokenId) internal {
460     clearApproval(_owner, _tokenId);
461     removeTokenFrom(_owner, _tokenId);
462     emit Transfer(_owner, address(0), _tokenId);
463   }
464 
465   /**
466    * @dev Internal function to clear current approval of a given token ID
467    * @dev Reverts if the given address is not indeed the owner of the token
468    * @param _owner owner of the token
469    * @param _tokenId uint256 ID of the token to be transferred
470    */
471   function clearApproval(address _owner, uint256 _tokenId) internal {
472     require(ownerOf(_tokenId) == _owner);
473     if (tokenApprovals[_tokenId] != address(0)) {
474       tokenApprovals[_tokenId] = address(0);
475       emit Approval(_owner, address(0), _tokenId);
476     }
477   }
478 
479   /**
480    * @dev Internal function to add a token ID to the list of a given address
481    * @param _to address representing the new owner of the given token ID
482    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
483    */
484   function addTokenTo(address _to, uint256 _tokenId) internal {
485     require(tokenOwner[_tokenId] == address(0));
486     tokenOwner[_tokenId] = _to;
487     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
488   }
489 
490   /**
491    * @dev Internal function to remove a token ID from the list of a given address
492    * @param _from address representing the previous owner of the given token ID
493    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
494    */
495   function removeTokenFrom(address _from, uint256 _tokenId) internal {
496     require(ownerOf(_tokenId) == _from);
497     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
498     tokenOwner[_tokenId] = address(0);
499   }
500 
501   /**
502    * @dev Internal function to invoke `onERC721Received` on a target address
503    * @dev The call is not executed if the target address is not a contract
504    * @param _from address representing the previous owner of the given token ID
505    * @param _to target address that will receive the tokens
506    * @param _tokenId uint256 ID of the token to be transferred
507    * @param _data bytes optional data to send along with the call
508    * @return whether the call correctly returned the expected magic value
509    */
510   function checkAndCallSafeTransfer(
511     address _from,
512     address _to,
513     uint256 _tokenId,
514     bytes _data
515   )
516     internal
517     returns (bool)
518   {
519     if (!_to.isContract()) {
520       return true;
521     }
522     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
523     return (retval == ERC721_RECEIVED);
524   }
525 }
526 
527 
528 
529 /**
530  * @title Full ERC721 Token
531  * This implementation includes all the required and some optional functionality of the ERC721 standard
532  * Moreover, it includes approve all functionality using operator terminology
533  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
534  */
535 contract ERC721Token is ERC721, ERC721BasicToken {
536   // Token name
537   string internal name_;
538 
539   // Token symbol
540   string internal symbol_;
541 
542   // Mapping from owner to list of owned token IDs
543   mapping (address => uint256[]) internal ownedTokens;
544 
545   // Mapping from token ID to index of the owner tokens list
546   mapping(uint256 => uint256) internal ownedTokensIndex;
547 
548   // Array with all token ids, used for enumeration
549   uint256[] internal allTokens;
550 
551   // Mapping from token id to position in the allTokens array
552   mapping(uint256 => uint256) internal allTokensIndex;
553 
554   // Optional mapping for token URIs
555   mapping(uint256 => string) internal tokenURIs;
556 
557   /**
558    * @dev Constructor function
559    */
560   function ERC721Token(string _name, string _symbol) public {
561     name_ = _name;
562     symbol_ = _symbol;
563   }
564 
565   /**
566    * @dev Gets the token name
567    * @return string representing the token name
568    */
569   function name() public view returns (string) {
570     return name_;
571   }
572 
573   /**
574    * @dev Gets the token symbol
575    * @return string representing the token symbol
576    */
577   function symbol() public view returns (string) {
578     return symbol_;
579   }
580 
581   /**
582    * @dev Returns an URI for a given token ID
583    * @dev Throws if the token ID does not exist. May return an empty string.
584    * @param _tokenId uint256 ID of the token to query
585    */
586   function tokenURI(uint256 _tokenId) public view returns (string) {
587     require(exists(_tokenId));
588     return tokenURIs[_tokenId];
589   }
590 
591   /**
592    * @dev Gets the token ID at a given index of the tokens list of the requested owner
593    * @param _owner address owning the tokens list to be accessed
594    * @param _index uint256 representing the index to be accessed of the requested tokens list
595    * @return uint256 token ID at the given index of the tokens list owned by the requested address
596    */
597   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
598     require(_index < balanceOf(_owner));
599     return ownedTokens[_owner][_index];
600   }
601 
602   /**
603    * @dev Gets the total amount of tokens stored by the contract
604    * @return uint256 representing the total amount of tokens
605    */
606   function totalSupply() public view returns (uint256) {
607     return allTokens.length;
608   }
609 
610   /**
611    * @dev Gets the token ID at a given index of all the tokens in this contract
612    * @dev Reverts if the index is greater or equal to the total number of tokens
613    * @param _index uint256 representing the index to be accessed of the tokens list
614    * @return uint256 token ID at the given index of the tokens list
615    */
616   function tokenByIndex(uint256 _index) public view returns (uint256) {
617     require(_index < totalSupply());
618     return allTokens[_index];
619   }
620 
621   /**
622    * @dev Internal function to set the token URI for a given token
623    * @dev Reverts if the token ID does not exist
624    * @param _tokenId uint256 ID of the token to set its URI
625    * @param _uri string URI to assign
626    */
627   function _setTokenURI(uint256 _tokenId, string _uri) internal {
628     require(exists(_tokenId));
629     tokenURIs[_tokenId] = _uri;
630   }
631 
632   /**
633    * @dev Internal function to add a token ID to the list of a given address
634    * @param _to address representing the new owner of the given token ID
635    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
636    */
637   function addTokenTo(address _to, uint256 _tokenId) internal {
638     super.addTokenTo(_to, _tokenId);
639     uint256 length = ownedTokens[_to].length;
640     ownedTokens[_to].push(_tokenId);
641     ownedTokensIndex[_tokenId] = length;
642   }
643 
644   /**
645    * @dev Internal function to remove a token ID from the list of a given address
646    * @param _from address representing the previous owner of the given token ID
647    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
648    */
649   function removeTokenFrom(address _from, uint256 _tokenId) internal {
650     super.removeTokenFrom(_from, _tokenId);
651 
652     uint256 tokenIndex = ownedTokensIndex[_tokenId];
653     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
654     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
655 
656     ownedTokens[_from][tokenIndex] = lastToken;
657     ownedTokens[_from][lastTokenIndex] = 0;
658     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
659     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
660     // the lastToken to the first position, and then dropping the element placed in the last position of the list
661 
662     ownedTokens[_from].length--;
663     ownedTokensIndex[_tokenId] = 0;
664     ownedTokensIndex[lastToken] = tokenIndex;
665   }
666 
667   /**
668    * @dev Internal function to mint a new token
669    * @dev Reverts if the given token ID already exists
670    * @param _to address the beneficiary that will own the minted token
671    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
672    */
673   function _mint(address _to, uint256 _tokenId) internal {
674     super._mint(_to, _tokenId);
675 
676     allTokensIndex[_tokenId] = allTokens.length;
677     allTokens.push(_tokenId);
678   }
679 
680   /**
681    * @dev Internal function to burn a specific token
682    * @dev Reverts if the token does not exist
683    * @param _owner owner of the token to burn
684    * @param _tokenId uint256 ID of the token being burned by the msg.sender
685    */
686   function _burn(address _owner, uint256 _tokenId) internal {
687     super._burn(_owner, _tokenId);
688 
689     // Clear metadata (if any)
690     if (bytes(tokenURIs[_tokenId]).length != 0) {
691       delete tokenURIs[_tokenId];
692     }
693 
694     // Reorg all tokens array
695     uint256 tokenIndex = allTokensIndex[_tokenId];
696     uint256 lastTokenIndex = allTokens.length.sub(1);
697     uint256 lastToken = allTokens[lastTokenIndex];
698 
699     allTokens[tokenIndex] = lastToken;
700     allTokens[lastTokenIndex] = 0;
701 
702     allTokens.length--;
703     allTokensIndex[_tokenId] = 0;
704     allTokensIndex[lastToken] = tokenIndex;
705   }
706 
707 }
708 
709 
710 
711 
712 
713 
714 
715 /// @title The contract that manages all the players that appear in our game.
716 /// @author The CryptoStrikers Team
717 contract StrikersPlayerList is Ownable {
718   // We only use playerIds in StrikersChecklist.sol (to
719   // indicate which player features on instances of a
720   // given ChecklistItem), and nowhere else in the app.
721   // While it's not explictly necessary for any of our
722   // contracts to know that playerId 0 corresponds to
723   // Lionel Messi, we think that it's nice to have
724   // a canonical source of truth for who the playerIds
725   // actually refer to. Storing strings (player names)
726   // is expensive, so we just use Events to prove that,
727   // at some point, we said a playerId represents a given person.
728 
729   /// @dev The event we fire when we add a player.
730   event PlayerAdded(uint8 indexed id, string name);
731 
732   /// @dev How many players we've added so far
733   ///   (max 255, though we don't plan on getting close)
734   uint8 public playerCount;
735 
736   /// @dev Here we add the players we are launching with on Day 1.
737   ///   Players are loosely ranked by things like FIFA ratings,
738   ///   number of Instagram followers, and opinions of CryptoStrikers
739   ///   team members. Feel free to yell at us on Twitter.
740   constructor() public {
741     addPlayer("Lionel Messi"); // 0
742     addPlayer("Cristiano Ronaldo"); // 1
743     addPlayer("Neymar"); // 2
744     addPlayer("Mohamed Salah"); // 3
745     addPlayer("Robert Lewandowski"); // 4
746     addPlayer("Kevin De Bruyne"); // 5
747     addPlayer("Luka Modrić"); // 6
748     addPlayer("Eden Hazard"); // 7
749     addPlayer("Sergio Ramos"); // 8
750     addPlayer("Toni Kroos"); // 9
751     addPlayer("Luis Suárez"); // 10
752     addPlayer("Harry Kane"); // 11
753     addPlayer("Sergio Agüero"); // 12
754     addPlayer("Kylian Mbappé"); // 13
755     addPlayer("Gonzalo Higuaín"); // 14
756     addPlayer("David de Gea"); // 15
757     addPlayer("Antoine Griezmann"); // 16
758     addPlayer("N'Golo Kanté"); // 17
759     addPlayer("Edinson Cavani"); // 18
760     addPlayer("Paul Pogba"); // 19
761     addPlayer("Isco"); // 20
762     addPlayer("Marcelo"); // 21
763     addPlayer("Manuel Neuer"); // 22
764     addPlayer("Dries Mertens"); // 23
765     addPlayer("James Rodríguez"); // 24
766     addPlayer("Paulo Dybala"); // 25
767     addPlayer("Christian Eriksen"); // 26
768     addPlayer("David Silva"); // 27
769     addPlayer("Gabriel Jesus"); // 28
770     addPlayer("Thiago"); // 29
771     addPlayer("Thibaut Courtois"); // 30
772     addPlayer("Philippe Coutinho"); // 31
773     addPlayer("Andrés Iniesta"); // 32
774     addPlayer("Casemiro"); // 33
775     addPlayer("Romelu Lukaku"); // 34
776     addPlayer("Gerard Piqué"); // 35
777     addPlayer("Mats Hummels"); // 36
778     addPlayer("Diego Godín"); // 37
779     addPlayer("Mesut Özil"); // 38
780     addPlayer("Son Heung-min"); // 39
781     addPlayer("Raheem Sterling"); // 40
782     addPlayer("Hugo Lloris"); // 41
783     addPlayer("Radamel Falcao"); // 42
784     addPlayer("Ivan Rakitić"); // 43
785     addPlayer("Leroy Sané"); // 44
786     addPlayer("Roberto Firmino"); // 45
787     addPlayer("Sadio Mané"); // 46
788     addPlayer("Thomas Müller"); // 47
789     addPlayer("Dele Alli"); // 48
790     addPlayer("Keylor Navas"); // 49
791     addPlayer("Thiago Silva"); // 50
792     addPlayer("Raphaël Varane"); // 51
793     addPlayer("Ángel Di María"); // 52
794     addPlayer("Jordi Alba"); // 53
795     addPlayer("Medhi Benatia"); // 54
796     addPlayer("Timo Werner"); // 55
797     addPlayer("Gylfi Sigurðsson"); // 56
798     addPlayer("Nemanja Matić"); // 57
799     addPlayer("Kalidou Koulibaly"); // 58
800     addPlayer("Bernardo Silva"); // 59
801     addPlayer("Vincent Kompany"); // 60
802     addPlayer("João Moutinho"); // 61
803     addPlayer("Toby Alderweireld"); // 62
804     addPlayer("Emil Forsberg"); // 63
805     addPlayer("Mario Mandžukić"); // 64
806     addPlayer("Sergej Milinković-Savić"); // 65
807     addPlayer("Shinji Kagawa"); // 66
808     addPlayer("Granit Xhaka"); // 67
809     addPlayer("Andreas Christensen"); // 68
810     addPlayer("Piotr Zieliński"); // 69
811     addPlayer("Fyodor Smolov"); // 70
812     addPlayer("Xherdan Shaqiri"); // 71
813     addPlayer("Marcus Rashford"); // 72
814     addPlayer("Javier Hernández"); // 73
815     addPlayer("Hirving Lozano"); // 74
816     addPlayer("Hakim Ziyech"); // 75
817     addPlayer("Victor Moses"); // 76
818     addPlayer("Jefferson Farfán"); // 77
819     addPlayer("Mohamed Elneny"); // 78
820     addPlayer("Marcus Berg"); // 79
821     addPlayer("Guillermo Ochoa"); // 80
822     addPlayer("Igor Akinfeev"); // 81
823     addPlayer("Sardar Azmoun"); // 82
824     addPlayer("Christian Cueva"); // 83
825     addPlayer("Wahbi Khazri"); // 84
826     addPlayer("Keisuke Honda"); // 85
827     addPlayer("Tim Cahill"); // 86
828     addPlayer("John Obi Mikel"); // 87
829     addPlayer("Ki Sung-yueng"); // 88
830     addPlayer("Bryan Ruiz"); // 89
831     addPlayer("Maya Yoshida"); // 90
832     addPlayer("Nawaf Al Abed"); // 91
833     addPlayer("Lee Chung-yong"); // 92
834     addPlayer("Gabriel Gómez"); // 93
835     addPlayer("Naïm Sliti"); // 94
836     addPlayer("Reza Ghoochannejhad"); // 95
837     addPlayer("Mile Jedinak"); // 96
838     addPlayer("Mohammad Al-Sahlawi"); // 97
839     addPlayer("Aron Gunnarsson"); // 98
840     addPlayer("Blas Pérez"); // 99
841     addPlayer("Dani Alves"); // 100
842     addPlayer("Zlatan Ibrahimović"); // 101
843   }
844 
845   /// @dev Fires an event, proving that we said a player corresponds to a given ID.
846   /// @param _name The name of the player we are adding.
847   function addPlayer(string _name) public onlyOwner {
848     require(playerCount < 255, "You've already added the maximum amount of players.");
849     emit PlayerAdded(playerCount, _name);
850     playerCount++;
851   }
852 }
853 
854 
855 /// @title The contract that manages checklist items, sets, and rarity tiers.
856 /// @author The CryptoStrikers Team
857 contract StrikersChecklist is StrikersPlayerList {
858   // High level overview of everything going on in this contract:
859   //
860   // ChecklistItem is the parent class to Card and has 3 properties:
861   //  - uint8 checklistId (000 to 255)
862   //  - uint8 playerId (see StrikersPlayerList.sol)
863   //  - RarityTier tier (more info below)
864   //
865   // Two things to note: the checklistId is not explicitly stored
866   // on the checklistItem struct, and it's composed of two parts.
867   // (For the following, assume it is left padded with zeros to reach
868   // three digits, such that checklistId 0 becomes 000)
869   //  - the first digit represents the setId
870   //      * 0 = Originals Set
871   //      * 1 = Iconics Set
872   //      * 2 = Unreleased Set
873   //  - the last two digits represent its index in the appropriate set arary
874   //
875   //  For example, checklist ID 100 would represent fhe first checklist item
876   //  in the iconicChecklistItems array (first digit = 1 = Iconics Set, last two
877   //  digits = 00 = first index of array)
878   //
879   // Because checklistId is represented as a uint8 throughout the app, the highest
880   // value it can take is 255, which means we can't add more than 56 items to our
881   // Unreleased Set's unreleasedChecklistItems array (setId 2). Also, once we've initialized
882   // this contract, it's impossible for us to add more checklist items to the Originals
883   // and Iconics set -- what you see here is what you get.
884   //
885   // Simple enough right?
886 
887   /// @dev We initialize this contract with so much data that we have
888   ///   to stage it in 4 different steps, ~33 checklist items at a time.
889   enum DeployStep {
890     WaitingForStepOne,
891     WaitingForStepTwo,
892     WaitingForStepThree,
893     WaitingForStepFour,
894     DoneInitialDeploy
895   }
896 
897   /// @dev Enum containing all our rarity tiers, just because
898   ///   it's cleaner dealing with these values than with uint8s.
899   enum RarityTier {
900     IconicReferral,
901     IconicInsert,
902     Diamond,
903     Gold,
904     Silver,
905     Bronze
906   }
907 
908   /// @dev A lookup table indicating how limited the cards
909   ///   in each tier are. If this value is 0, it means
910   ///   that cards of this rarity tier are unlimited,
911   ///   which is only the case for the 8 Iconics cards
912   ///   we give away as part of our referral program.
913   uint16[] public tierLimits = [
914     0,    // Iconic - Referral Bonus (uncapped)
915     100,  // Iconic Inserts ("Card of the Day")
916     1000, // Diamond
917     1664, // Gold
918     3328, // Silver
919     4352  // Bronze
920   ];
921 
922   /// @dev ChecklistItem is essentially the parent class to Card.
923   ///   It represents a given superclass of cards (eg Originals Messi),
924   ///   and then each Card is an instance of this ChecklistItem, with
925   ///   its own serial number, mint date, etc.
926   struct ChecklistItem {
927     uint8 playerId;
928     RarityTier tier;
929   }
930 
931   /// @dev The deploy step we're at. Defaults to WaitingForStepOne.
932   DeployStep public deployStep;
933 
934   /// @dev Array containing all the Originals checklist items (000 - 099)
935   ChecklistItem[] public originalChecklistItems;
936 
937   /// @dev Array containing all the Iconics checklist items (100 - 131)
938   ChecklistItem[] public iconicChecklistItems;
939 
940   /// @dev Array containing all the unreleased checklist items (200 - 255 max)
941   ChecklistItem[] public unreleasedChecklistItems;
942 
943   /// @dev Internal function to add a checklist item to the Originals set.
944   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
945   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
946   function _addOriginalChecklistItem(uint8 _playerId, RarityTier _tier) internal {
947     originalChecklistItems.push(ChecklistItem({
948       playerId: _playerId,
949       tier: _tier
950     }));
951   }
952 
953   /// @dev Internal function to add a checklist item to the Iconics set.
954   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
955   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
956   function _addIconicChecklistItem(uint8 _playerId, RarityTier _tier) internal {
957     iconicChecklistItems.push(ChecklistItem({
958       playerId: _playerId,
959       tier: _tier
960     }));
961   }
962 
963   /// @dev External function to add a checklist item to our mystery set.
964   ///   Must have completed initial deploy, and can't add more than 56 items (because checklistId is a uint8).
965   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
966   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
967   function addUnreleasedChecklistItem(uint8 _playerId, RarityTier _tier) external onlyOwner {
968     require(deployStep == DeployStep.DoneInitialDeploy, "Finish deploying the Originals and Iconics sets first.");
969     require(unreleasedCount() < 56, "You can't add any more checklist items.");
970     require(_playerId < playerCount, "This player doesn't exist in our player list.");
971     unreleasedChecklistItems.push(ChecklistItem({
972       playerId: _playerId,
973       tier: _tier
974     }));
975   }
976 
977   /// @dev Returns how many Original checklist items we've added.
978   function originalsCount() external view returns (uint256) {
979     return originalChecklistItems.length;
980   }
981 
982   /// @dev Returns how many Iconic checklist items we've added.
983   function iconicsCount() public view returns (uint256) {
984     return iconicChecklistItems.length;
985   }
986 
987   /// @dev Returns how many Unreleased checklist items we've added.
988   function unreleasedCount() public view returns (uint256) {
989     return unreleasedChecklistItems.length;
990   }
991 
992   // In the next four functions, we initialize this contract with our
993   // 132 initial checklist items (100 Originals, 32 Iconics). Because
994   // of how much data we need to store, it has to be broken up into
995   // four different function calls, which need to be called in sequence.
996   // The ordering of the checklist items we add determines their
997   // checklist ID, which is left-padded in our frontend to be a
998   // 3-digit identifier where the first digit is the setId and the last
999   // 2 digits represents the checklist items index in the appropriate ___ChecklistItems array.
1000   // For example, Originals Messi is the first item for set ID 0, and this
1001   // is displayed as #000 throughout the app. Our Card struct declare its
1002   // checklistId property as uint8, so we have
1003   // to be mindful that we can only have 256 total checklist items.
1004 
1005   /// @dev Deploys Originals #000 through #032.
1006   function deployStepOne() external onlyOwner {
1007     require(deployStep == DeployStep.WaitingForStepOne, "You're not following the steps in order...");
1008 
1009     /* ORIGINALS - DIAMOND */
1010     _addOriginalChecklistItem(0, RarityTier.Diamond); // 000 Messi
1011     _addOriginalChecklistItem(1, RarityTier.Diamond); // 001 Ronaldo
1012     _addOriginalChecklistItem(2, RarityTier.Diamond); // 002 Neymar
1013     _addOriginalChecklistItem(3, RarityTier.Diamond); // 003 Salah
1014 
1015     /* ORIGINALS - GOLD */
1016     _addOriginalChecklistItem(4, RarityTier.Gold); // 004 Lewandowski
1017     _addOriginalChecklistItem(5, RarityTier.Gold); // 005 De Bruyne
1018     _addOriginalChecklistItem(6, RarityTier.Gold); // 006 Modrić
1019     _addOriginalChecklistItem(7, RarityTier.Gold); // 007 Hazard
1020     _addOriginalChecklistItem(8, RarityTier.Gold); // 008 Ramos
1021     _addOriginalChecklistItem(9, RarityTier.Gold); // 009 Kroos
1022     _addOriginalChecklistItem(10, RarityTier.Gold); // 010 Suárez
1023     _addOriginalChecklistItem(11, RarityTier.Gold); // 011 Kane
1024     _addOriginalChecklistItem(12, RarityTier.Gold); // 012 Agüero
1025     _addOriginalChecklistItem(13, RarityTier.Gold); // 013 Mbappé
1026     _addOriginalChecklistItem(14, RarityTier.Gold); // 014 Higuaín
1027     _addOriginalChecklistItem(15, RarityTier.Gold); // 015 de Gea
1028     _addOriginalChecklistItem(16, RarityTier.Gold); // 016 Griezmann
1029     _addOriginalChecklistItem(17, RarityTier.Gold); // 017 Kanté
1030     _addOriginalChecklistItem(18, RarityTier.Gold); // 018 Cavani
1031     _addOriginalChecklistItem(19, RarityTier.Gold); // 019 Pogba
1032 
1033     /* ORIGINALS - SILVER (020 to 032) */
1034     _addOriginalChecklistItem(20, RarityTier.Silver); // 020 Isco
1035     _addOriginalChecklistItem(21, RarityTier.Silver); // 021 Marcelo
1036     _addOriginalChecklistItem(22, RarityTier.Silver); // 022 Neuer
1037     _addOriginalChecklistItem(23, RarityTier.Silver); // 023 Mertens
1038     _addOriginalChecklistItem(24, RarityTier.Silver); // 024 James
1039     _addOriginalChecklistItem(25, RarityTier.Silver); // 025 Dybala
1040     _addOriginalChecklistItem(26, RarityTier.Silver); // 026 Eriksen
1041     _addOriginalChecklistItem(27, RarityTier.Silver); // 027 David Silva
1042     _addOriginalChecklistItem(28, RarityTier.Silver); // 028 Gabriel Jesus
1043     _addOriginalChecklistItem(29, RarityTier.Silver); // 029 Thiago
1044     _addOriginalChecklistItem(30, RarityTier.Silver); // 030 Courtois
1045     _addOriginalChecklistItem(31, RarityTier.Silver); // 031 Coutinho
1046     _addOriginalChecklistItem(32, RarityTier.Silver); // 032 Iniesta
1047 
1048     // Move to the next deploy step.
1049     deployStep = DeployStep.WaitingForStepTwo;
1050   }
1051 
1052   /// @dev Deploys Originals #033 through #065.
1053   function deployStepTwo() external onlyOwner {
1054     require(deployStep == DeployStep.WaitingForStepTwo, "You're not following the steps in order...");
1055 
1056     /* ORIGINALS - SILVER (033 to 049) */
1057     _addOriginalChecklistItem(33, RarityTier.Silver); // 033 Casemiro
1058     _addOriginalChecklistItem(34, RarityTier.Silver); // 034 Lukaku
1059     _addOriginalChecklistItem(35, RarityTier.Silver); // 035 Piqué
1060     _addOriginalChecklistItem(36, RarityTier.Silver); // 036 Hummels
1061     _addOriginalChecklistItem(37, RarityTier.Silver); // 037 Godín
1062     _addOriginalChecklistItem(38, RarityTier.Silver); // 038 Özil
1063     _addOriginalChecklistItem(39, RarityTier.Silver); // 039 Son
1064     _addOriginalChecklistItem(40, RarityTier.Silver); // 040 Sterling
1065     _addOriginalChecklistItem(41, RarityTier.Silver); // 041 Lloris
1066     _addOriginalChecklistItem(42, RarityTier.Silver); // 042 Falcao
1067     _addOriginalChecklistItem(43, RarityTier.Silver); // 043 Rakitić
1068     _addOriginalChecklistItem(44, RarityTier.Silver); // 044 Sané
1069     _addOriginalChecklistItem(45, RarityTier.Silver); // 045 Firmino
1070     _addOriginalChecklistItem(46, RarityTier.Silver); // 046 Mané
1071     _addOriginalChecklistItem(47, RarityTier.Silver); // 047 Müller
1072     _addOriginalChecklistItem(48, RarityTier.Silver); // 048 Alli
1073     _addOriginalChecklistItem(49, RarityTier.Silver); // 049 Navas
1074 
1075     /* ORIGINALS - BRONZE (050 to 065) */
1076     _addOriginalChecklistItem(50, RarityTier.Bronze); // 050 Thiago Silva
1077     _addOriginalChecklistItem(51, RarityTier.Bronze); // 051 Varane
1078     _addOriginalChecklistItem(52, RarityTier.Bronze); // 052 Di María
1079     _addOriginalChecklistItem(53, RarityTier.Bronze); // 053 Alba
1080     _addOriginalChecklistItem(54, RarityTier.Bronze); // 054 Benatia
1081     _addOriginalChecklistItem(55, RarityTier.Bronze); // 055 Werner
1082     _addOriginalChecklistItem(56, RarityTier.Bronze); // 056 Sigurðsson
1083     _addOriginalChecklistItem(57, RarityTier.Bronze); // 057 Matić
1084     _addOriginalChecklistItem(58, RarityTier.Bronze); // 058 Koulibaly
1085     _addOriginalChecklistItem(59, RarityTier.Bronze); // 059 Bernardo Silva
1086     _addOriginalChecklistItem(60, RarityTier.Bronze); // 060 Kompany
1087     _addOriginalChecklistItem(61, RarityTier.Bronze); // 061 Moutinho
1088     _addOriginalChecklistItem(62, RarityTier.Bronze); // 062 Alderweireld
1089     _addOriginalChecklistItem(63, RarityTier.Bronze); // 063 Forsberg
1090     _addOriginalChecklistItem(64, RarityTier.Bronze); // 064 Mandžukić
1091     _addOriginalChecklistItem(65, RarityTier.Bronze); // 065 Milinković-Savić
1092 
1093     // Move to the next deploy step.
1094     deployStep = DeployStep.WaitingForStepThree;
1095   }
1096 
1097   /// @dev Deploys Originals #066 through #099.
1098   function deployStepThree() external onlyOwner {
1099     require(deployStep == DeployStep.WaitingForStepThree, "You're not following the steps in order...");
1100 
1101     /* ORIGINALS - BRONZE (066 to 099) */
1102     _addOriginalChecklistItem(66, RarityTier.Bronze); // 066 Kagawa
1103     _addOriginalChecklistItem(67, RarityTier.Bronze); // 067 Xhaka
1104     _addOriginalChecklistItem(68, RarityTier.Bronze); // 068 Christensen
1105     _addOriginalChecklistItem(69, RarityTier.Bronze); // 069 Zieliński
1106     _addOriginalChecklistItem(70, RarityTier.Bronze); // 070 Smolov
1107     _addOriginalChecklistItem(71, RarityTier.Bronze); // 071 Shaqiri
1108     _addOriginalChecklistItem(72, RarityTier.Bronze); // 072 Rashford
1109     _addOriginalChecklistItem(73, RarityTier.Bronze); // 073 Hernández
1110     _addOriginalChecklistItem(74, RarityTier.Bronze); // 074 Lozano
1111     _addOriginalChecklistItem(75, RarityTier.Bronze); // 075 Ziyech
1112     _addOriginalChecklistItem(76, RarityTier.Bronze); // 076 Moses
1113     _addOriginalChecklistItem(77, RarityTier.Bronze); // 077 Farfán
1114     _addOriginalChecklistItem(78, RarityTier.Bronze); // 078 Elneny
1115     _addOriginalChecklistItem(79, RarityTier.Bronze); // 079 Berg
1116     _addOriginalChecklistItem(80, RarityTier.Bronze); // 080 Ochoa
1117     _addOriginalChecklistItem(81, RarityTier.Bronze); // 081 Akinfeev
1118     _addOriginalChecklistItem(82, RarityTier.Bronze); // 082 Azmoun
1119     _addOriginalChecklistItem(83, RarityTier.Bronze); // 083 Cueva
1120     _addOriginalChecklistItem(84, RarityTier.Bronze); // 084 Khazri
1121     _addOriginalChecklistItem(85, RarityTier.Bronze); // 085 Honda
1122     _addOriginalChecklistItem(86, RarityTier.Bronze); // 086 Cahill
1123     _addOriginalChecklistItem(87, RarityTier.Bronze); // 087 Mikel
1124     _addOriginalChecklistItem(88, RarityTier.Bronze); // 088 Sung-yueng
1125     _addOriginalChecklistItem(89, RarityTier.Bronze); // 089 Ruiz
1126     _addOriginalChecklistItem(90, RarityTier.Bronze); // 090 Yoshida
1127     _addOriginalChecklistItem(91, RarityTier.Bronze); // 091 Al Abed
1128     _addOriginalChecklistItem(92, RarityTier.Bronze); // 092 Chung-yong
1129     _addOriginalChecklistItem(93, RarityTier.Bronze); // 093 Gómez
1130     _addOriginalChecklistItem(94, RarityTier.Bronze); // 094 Sliti
1131     _addOriginalChecklistItem(95, RarityTier.Bronze); // 095 Ghoochannejhad
1132     _addOriginalChecklistItem(96, RarityTier.Bronze); // 096 Jedinak
1133     _addOriginalChecklistItem(97, RarityTier.Bronze); // 097 Al-Sahlawi
1134     _addOriginalChecklistItem(98, RarityTier.Bronze); // 098 Gunnarsson
1135     _addOriginalChecklistItem(99, RarityTier.Bronze); // 099 Pérez
1136 
1137     // Move to the next deploy step.
1138     deployStep = DeployStep.WaitingForStepFour;
1139   }
1140 
1141   /// @dev Deploys all Iconics and marks the deploy as complete!
1142   function deployStepFour() external onlyOwner {
1143     require(deployStep == DeployStep.WaitingForStepFour, "You're not following the steps in order...");
1144 
1145     /* ICONICS */
1146     _addIconicChecklistItem(0, RarityTier.IconicInsert); // 100 Messi
1147     _addIconicChecklistItem(1, RarityTier.IconicInsert); // 101 Ronaldo
1148     _addIconicChecklistItem(2, RarityTier.IconicInsert); // 102 Neymar
1149     _addIconicChecklistItem(3, RarityTier.IconicInsert); // 103 Salah
1150     _addIconicChecklistItem(4, RarityTier.IconicInsert); // 104 Lewandowski
1151     _addIconicChecklistItem(5, RarityTier.IconicInsert); // 105 De Bruyne
1152     _addIconicChecklistItem(6, RarityTier.IconicInsert); // 106 Modrić
1153     _addIconicChecklistItem(7, RarityTier.IconicInsert); // 107 Hazard
1154     _addIconicChecklistItem(8, RarityTier.IconicInsert); // 108 Ramos
1155     _addIconicChecklistItem(9, RarityTier.IconicInsert); // 109 Kroos
1156     _addIconicChecklistItem(10, RarityTier.IconicInsert); // 110 Suárez
1157     _addIconicChecklistItem(11, RarityTier.IconicInsert); // 111 Kane
1158     _addIconicChecklistItem(12, RarityTier.IconicInsert); // 112 Agüero
1159     _addIconicChecklistItem(15, RarityTier.IconicInsert); // 113 de Gea
1160     _addIconicChecklistItem(16, RarityTier.IconicInsert); // 114 Griezmann
1161     _addIconicChecklistItem(17, RarityTier.IconicReferral); // 115 Kanté
1162     _addIconicChecklistItem(18, RarityTier.IconicReferral); // 116 Cavani
1163     _addIconicChecklistItem(19, RarityTier.IconicInsert); // 117 Pogba
1164     _addIconicChecklistItem(21, RarityTier.IconicInsert); // 118 Marcelo
1165     _addIconicChecklistItem(24, RarityTier.IconicInsert); // 119 James
1166     _addIconicChecklistItem(26, RarityTier.IconicInsert); // 120 Eriksen
1167     _addIconicChecklistItem(29, RarityTier.IconicReferral); // 121 Thiago
1168     _addIconicChecklistItem(36, RarityTier.IconicReferral); // 122 Hummels
1169     _addIconicChecklistItem(38, RarityTier.IconicReferral); // 123 Özil
1170     _addIconicChecklistItem(39, RarityTier.IconicInsert); // 124 Son
1171     _addIconicChecklistItem(46, RarityTier.IconicInsert); // 125 Mané
1172     _addIconicChecklistItem(48, RarityTier.IconicInsert); // 126 Alli
1173     _addIconicChecklistItem(49, RarityTier.IconicReferral); // 127 Navas
1174     _addIconicChecklistItem(73, RarityTier.IconicInsert); // 128 Hernández
1175     _addIconicChecklistItem(85, RarityTier.IconicInsert); // 129 Honda
1176     _addIconicChecklistItem(100, RarityTier.IconicReferral); // 130 Alves
1177     _addIconicChecklistItem(101, RarityTier.IconicReferral); // 131 Zlatan
1178 
1179     // Mark the initial deploy as complete.
1180     deployStep = DeployStep.DoneInitialDeploy;
1181   }
1182 
1183   /// @dev Returns the mint limit for a given checklist item, based on its tier.
1184   /// @param _checklistId Which checklist item we need to get the limit for.
1185   /// @return How much of this checklist item we are allowed to mint.
1186   function limitForChecklistId(uint8 _checklistId) external view returns (uint16) {
1187     RarityTier rarityTier;
1188     uint8 index;
1189     if (_checklistId < 100) { // Originals = #000 to #099
1190       rarityTier = originalChecklistItems[_checklistId].tier;
1191     } else if (_checklistId < 200) { // Iconics = #100 to #131
1192       index = _checklistId - 100;
1193       require(index < iconicsCount(), "This Iconics checklist item doesn't exist.");
1194       rarityTier = iconicChecklistItems[index].tier;
1195     } else { // Unreleased = #200 to max #255
1196       index = _checklistId - 200;
1197       require(index < unreleasedCount(), "This Unreleased checklist item doesn't exist.");
1198       rarityTier = unreleasedChecklistItems[index].tier;
1199     }
1200     return tierLimits[uint8(rarityTier)];
1201   }
1202 }
1203 
1204 
1205 /// @title Base contract for CryptoStrikers. Defines what a card is and how to mint one.
1206 /// @author The CryptoStrikers Team
1207 contract StrikersBase is ERC721Token("CryptoStrikers", "STRK") {
1208 
1209   /// @dev Emit this event whenever we mint a new card (see _mintCard below)
1210   event CardMinted(uint256 cardId);
1211 
1212   /// @dev The struct representing the game's main object, a sports trading card.
1213   struct Card {
1214     // The timestamp at which this card was minted.
1215     // With uint32 we are good until 2106, by which point we will have not minted
1216     // a card in like, 88 years.
1217     uint32 mintTime;
1218 
1219     // The checklist item represented by this card. See StrikersChecklist.sol for more info.
1220     uint8 checklistId;
1221 
1222     // Cards for a given player have a serial number, which gets
1223     // incremented in sequence. For example, if we mint 1000 of a card,
1224     // the third one to be minted has serialNumber = 3 (out of 1000).
1225     uint16 serialNumber;
1226   }
1227 
1228   /*** STORAGE ***/
1229 
1230   /// @dev All the cards that have been minted, indexed by cardId.
1231   Card[] public cards;
1232 
1233   /// @dev Keeps track of how many cards we have minted for a given checklist item
1234   ///   to make sure we don't go over the limit for it.
1235   ///   NB: uint16 has a capacity of 65,535, but we are not minting more than
1236   ///   4,352 of any given checklist item.
1237   mapping (uint8 => uint16) public mintedCountForChecklistId;
1238 
1239   /// @dev A reference to our checklist contract, which contains all the minting limits.
1240   StrikersChecklist public strikersChecklist;
1241 
1242   /*** FUNCTIONS ***/
1243 
1244   /// @dev For a given owner, returns two arrays. The first contains the IDs of every card owned
1245   ///   by this address. The second returns the corresponding checklist ID for each of these cards.
1246   ///   There are a few places we need this info in the web app and short of being able to return an
1247   ///   actual array of Cards, this is the best solution we could come up with...
1248   function cardAndChecklistIdsForOwner(address _owner) external view returns (uint256[], uint8[]) {
1249     uint256[] memory cardIds = ownedTokens[_owner];
1250     uint256 cardCount = cardIds.length;
1251     uint8[] memory checklistIds = new uint8[](cardCount);
1252 
1253     for (uint256 i = 0; i < cardCount; i++) {
1254       uint256 cardId = cardIds[i];
1255       checklistIds[i] = cards[cardId].checklistId;
1256     }
1257 
1258     return (cardIds, checklistIds);
1259   }
1260 
1261   /// @dev An internal method that creates a new card and stores it.
1262   ///  Emits both a CardMinted and a Transfer event.
1263   /// @param _checklistId The ID of the checklistItem represented by the card (see Checklist.sol)
1264   /// @param _owner The card's first owner!
1265   function _mintCard(
1266     uint8 _checklistId,
1267     address _owner
1268   )
1269     internal
1270     returns (uint256)
1271   {
1272     uint16 mintLimit = strikersChecklist.limitForChecklistId(_checklistId);
1273     require(mintLimit == 0 || mintedCountForChecklistId[_checklistId] < mintLimit, "Can't mint any more of this card!");
1274     uint16 serialNumber = ++mintedCountForChecklistId[_checklistId];
1275     Card memory newCard = Card({
1276       mintTime: uint32(now),
1277       checklistId: _checklistId,
1278       serialNumber: serialNumber
1279     });
1280     uint256 newCardId = cards.push(newCard) - 1;
1281     emit CardMinted(newCardId);
1282     _mint(_owner, newCardId);
1283     return newCardId;
1284   }
1285 }
1286 
1287 
1288 
1289 
1290 
1291 
1292 
1293 /**
1294  * @title Pausable
1295  * @dev Base contract which allows children to implement an emergency stop mechanism.
1296  */
1297 contract Pausable is Ownable {
1298   event Pause();
1299   event Unpause();
1300 
1301   bool public paused = false;
1302 
1303 
1304   /**
1305    * @dev Modifier to make a function callable only when the contract is not paused.
1306    */
1307   modifier whenNotPaused() {
1308     require(!paused);
1309     _;
1310   }
1311 
1312   /**
1313    * @dev Modifier to make a function callable only when the contract is paused.
1314    */
1315   modifier whenPaused() {
1316     require(paused);
1317     _;
1318   }
1319 
1320   /**
1321    * @dev called by the owner to pause, triggers stopped state
1322    */
1323   function pause() onlyOwner whenNotPaused public {
1324     paused = true;
1325     emit Pause();
1326   }
1327 
1328   /**
1329    * @dev called by the owner to unpause, returns to normal state
1330    */
1331   function unpause() onlyOwner whenPaused public {
1332     paused = false;
1333     emit Unpause();
1334   }
1335 }
1336 
1337 
1338 /// @title The contract that exposes minting functions to the outside world and limits who can call them.
1339 /// @author The CryptoStrikers Team
1340 contract StrikersMinting is StrikersBase, Pausable {
1341 
1342   /// @dev Emit this when we decide to no longer mint a given checklist ID.
1343   event PulledFromCirculation(uint8 checklistId);
1344 
1345   /// @dev If the value for a checklistId is true, we can no longer mint it.
1346   mapping (uint8 => bool) public outOfCirculation;
1347 
1348   /// @dev The address of the contract that manages the pack sale.
1349   address public packSaleAddress;
1350 
1351   /// @dev Only the owner can update the address of the pack sale contract.
1352   /// @param _address The address of the new StrikersPackSale contract.
1353   function setPackSaleAddress(address _address) external onlyOwner {
1354     packSaleAddress = _address;
1355   }
1356 
1357   /// @dev Allows the contract at packSaleAddress to mint cards.
1358   /// @param _checklistId The checklist item represented by this new card.
1359   /// @param _owner The card's first owner!
1360   /// @return The new card's ID.
1361   function mintPackSaleCard(uint8 _checklistId, address _owner) external returns (uint256) {
1362     require(msg.sender == packSaleAddress, "Only the pack sale contract can mint here.");
1363     require(!outOfCirculation[_checklistId], "Can't mint any more of this checklist item...");
1364     return _mintCard(_checklistId, _owner);
1365   }
1366 
1367   /// @dev Allows the owner to mint cards from our Unreleased Set.
1368   /// @param _checklistId The checklist item represented by this new card. Must be >= 200.
1369   /// @param _owner The card's first owner!
1370   function mintUnreleasedCard(uint8 _checklistId, address _owner) external onlyOwner {
1371     require(_checklistId >= 200, "You can only use this to mint unreleased cards.");
1372     require(!outOfCirculation[_checklistId], "Can't mint any more of this checklist item...");
1373     _mintCard(_checklistId, _owner);
1374   }
1375 
1376   /// @dev Allows the owner or the pack sale contract to prevent an Iconic or Unreleased card from ever being minted again.
1377   /// @param _checklistId The Iconic or Unreleased card we want to remove from circulation.
1378   function pullFromCirculation(uint8 _checklistId) external {
1379     bool ownerOrPackSale = (msg.sender == owner) || (msg.sender == packSaleAddress);
1380     require(ownerOrPackSale, "Only the owner or pack sale can take checklist items out of circulation.");
1381     require(_checklistId >= 100, "This function is reserved for Iconics and Unreleased sets.");
1382     outOfCirculation[_checklistId] = true;
1383     emit PulledFromCirculation(_checklistId);
1384   }
1385 }
1386 
1387 
1388 
1389 /// @title Contract where we create Standard and Premium sales and load them with the packs to sell.
1390 /// @author The CryptoStrikersTeam
1391 contract StrikersPackFactory is Pausable {
1392 
1393   /*** IMPORTANT ***/
1394   // Given the imperfect nature of on-chain "randomness", we have found that, for this game, the best tradeoff
1395   // is to generate the PACKS (each containing 4 random CARDS) off-chain and push them to a SALE in the smart
1396   // contract. Users can then buy a pack, which will be drawn pseudorandomly from the packs we have pre-loaded.
1397   // It's obviously not perfect, but we think it's a fair tradeoff and tough enough to game, as the packs array is
1398   // constantly getting re-shuffled as other users buy packs.
1399   //
1400   // To save on storage, we use uint32 to represent a pack, with each of the 4 groups of 8 bits representing a checklistId (see Checklist contract).
1401   // Given that right now we only have 132 checklist items (with the plan to maybe add a few more during the tournament),
1402   // uint8 is fine (max uint8 is 255...)
1403   //
1404   // For example:
1405   // Pack = 00011000000001100000001000010010
1406   // Card 1 = 00011000 = checklistId 24
1407   // Card 2 = 00000110 = checklistId 6
1408   // Card 3 = 00000010 = checklistId 2
1409   // Card 4 = 00010010 = checklistId 18
1410   //
1411   // Then, when a user buys a pack, he actually mints 4 NFTs, each corresponding to one of those checklistIds (see StrikersPackSale contract).
1412   //
1413   // In testing, we were only able to load ~500 packs (recall: each a uint32) per transaction before hititng the block gas limit,
1414   // which may be less than we need for any given sale, so we load packs in batches. The Standard Sale runs all tournament long, and we
1415   // will constantly be adding packs to it, up to the limit defined by MAX_STANDARD_SALE_PACKS. As for Premium Sales, we switch over
1416   // to a new one every day, so while the current one is ongoing, we are able to start prepping the next one using the nextPremiumSale
1417   // property. We can then load the 500 packs required to start this premium sale in as many transactions as we want, before pushing it
1418   // live.
1419 
1420   /*** EVENTS ***/
1421 
1422   /// @dev Emit this event each time we load packs for a given sale.
1423   event PacksLoaded(uint8 indexed saleId, uint32[] packs);
1424 
1425   /// @dev Emit this event when the owner starts a sale.
1426   event SaleStarted(uint8 saleId, uint256 packPrice, uint8 featuredChecklistItem);
1427 
1428   /// @dev Emit this event when the owner changes the standard sale's packPrice.
1429   event StandardPackPriceChanged(uint256 packPrice);
1430 
1431   /*** CONSTANTS ***/
1432 
1433   /// @dev Our Standard sale runs all tournament long but has a hard cap of 75,616 packs.
1434   uint32 public constant MAX_STANDARD_SALE_PACKS = 75616;
1435 
1436   /// @dev Each Premium sale will contain exactly 500 packs.
1437   uint16 public constant PREMIUM_SALE_PACK_COUNT = 500;
1438 
1439   /// @dev We can only run a total of 24 Premium sales.
1440   uint8 public constant MAX_NUMBER_OF_PREMIUM_SALES = 24;
1441 
1442   /*** DATA TYPES ***/
1443 
1444   /// @dev The struct representing a PackSale from which packs are dispensed.
1445   struct PackSale {
1446     // A unique identifier for this sale. Based on saleCount at the time of this sale's creation.
1447     uint8 id;
1448 
1449     // The card of the day, if it's a Premium sale. Once that sale ends, we can never mint this card again.
1450     uint8 featuredChecklistItem;
1451 
1452     // The price, in wei, for 1 pack of cards. The only case where this is 0 is when the struct is null, so
1453     // we use it as a null check.
1454     uint256 packPrice;
1455 
1456     // All the packs we have loaded for this sale. Max 500 for each Premium sale, and 75,616 for the Standard sale.
1457     uint32[] packs;
1458 
1459     // The number of packs loaded so far in this sale. Because people will be buying from the Standard sale as
1460     // we keep loading packs in, we need this counter to make sure we don't go over MAX_STANDARD_SALE_PACKS.
1461     uint32 packsLoaded;
1462 
1463     // The number of packs sold so far in this sale.
1464     uint32 packsSold;
1465   }
1466 
1467   /*** STORAGE ***/
1468 
1469   /// @dev A reference to the core contract, where the cards are actually minted.
1470   StrikersMinting public mintingContract;
1471 
1472   /// @dev Our one and only Standard sale, which runs all tournament long.
1473   PackSale public standardSale;
1474 
1475   /// @dev The Premium sale that users are currently able to buy from.
1476   PackSale public currentPremiumSale;
1477 
1478   /// @dev We stage the next Premium sale here before we push it live with startNextPremiumSale().
1479   PackSale public nextPremiumSale;
1480 
1481   /// @dev How many sales we've ran so far. Max is 25 (1 Standard + 24 Premium).
1482   uint8 public saleCount;
1483 
1484   /*** MODIFIERS  ***/
1485 
1486   modifier nonZeroPackPrice(uint256 _packPrice) {
1487     require(_packPrice > 0, "Free packs are only available through the whitelist.");
1488     _;
1489   }
1490 
1491   /*** CONSTRUCTOR ***/
1492 
1493   constructor(uint256 _packPrice) public {
1494     // Start contract in paused state so we have can go and load some packs in.
1495     paused = true;
1496     // Init Standard sale. (all properties default to 0, except packPrice, which we set here)
1497     setStandardPackPrice(_packPrice);
1498     saleCount++;
1499   }
1500 
1501   /*** SHARED FUNCTIONS (STANDARD & PREMIUM) ***/
1502 
1503   /// @dev Internal function to push a bunch of packs to a PackSale's packs array.
1504   /// @param _newPacks An array of 32 bit integers, each representing a shuffled pack.
1505   /// @param _sale The PackSale we are pushing to.
1506   function _addPacksToSale(uint32[] _newPacks, PackSale storage _sale) internal {
1507     for (uint256 i = 0; i < _newPacks.length; i++) {
1508       _sale.packs.push(_newPacks[i]);
1509     }
1510     _sale.packsLoaded += uint32(_newPacks.length);
1511     emit PacksLoaded(_sale.id, _newPacks);
1512   }
1513 
1514   /*** STANDARD SALE FUNCTIONS ***/
1515 
1516   /// @dev Load some shuffled packs into the Standard sale.
1517   /// @param _newPacks The new packs to load.
1518   function addPacksToStandardSale(uint32[] _newPacks) external onlyOwner {
1519     bool tooManyPacks = standardSale.packsLoaded + _newPacks.length > MAX_STANDARD_SALE_PACKS;
1520     require(!tooManyPacks, "You can't add more than 75,616 packs to the Standard sale.");
1521     _addPacksToSale(_newPacks, standardSale);
1522   }
1523 
1524   /// @dev After seeding the Standard sale with a few loads of packs, kick off the sale here.
1525   function startStandardSale() external onlyOwner {
1526     require(standardSale.packsLoaded > 0, "You must first load some packs into the Standard sale.");
1527     unpause();
1528     emit SaleStarted(standardSale.id, standardSale.packPrice, standardSale.featuredChecklistItem);
1529   }
1530 
1531   /// @dev Allows us to change the Standard sale pack price while the sale is ongoing, to deal with ETH
1532   ///   price fluctuations. Premium sale packPrice is set daily (i.e. every time we create a new Premium sale)
1533   /// @param _packPrice The new Standard pack price, in wei.
1534   function setStandardPackPrice(uint256 _packPrice) public onlyOwner nonZeroPackPrice(_packPrice) {
1535     standardSale.packPrice = _packPrice;
1536     emit StandardPackPriceChanged(_packPrice);
1537   }
1538 
1539   /*** PREMIUM SALE FUNCTIONS ***/
1540 
1541   /// @dev If nextPremiumSale is null, allows us to create and start setting up the next one.
1542   /// @param _featuredChecklistItem The card of the day, which we will take out of circulation once the sale ends.
1543   /// @param _packPrice The price of packs for this sale, in wei. Must be greater than zero.
1544   function createNextPremiumSale(uint8 _featuredChecklistItem, uint256 _packPrice) external onlyOwner nonZeroPackPrice(_packPrice) {
1545     require(nextPremiumSale.packPrice == 0, "Next Premium Sale already exists.");
1546     require(_featuredChecklistItem >= 100, "You can't have an Originals as a featured checklist item.");
1547     require(saleCount <= MAX_NUMBER_OF_PREMIUM_SALES, "You can only run 24 total Premium sales.");
1548     nextPremiumSale.id = saleCount;
1549     nextPremiumSale.featuredChecklistItem = _featuredChecklistItem;
1550     nextPremiumSale.packPrice = _packPrice;
1551     saleCount++;
1552   }
1553 
1554   /// @dev Load some shuffled packs into the next Premium sale that we created.
1555   /// @param _newPacks The new packs to load.
1556   function addPacksToNextPremiumSale(uint32[] _newPacks) external onlyOwner {
1557     require(nextPremiumSale.packPrice > 0, "You must first create a nextPremiumSale.");
1558     require(nextPremiumSale.packsLoaded + _newPacks.length <= PREMIUM_SALE_PACK_COUNT, "You can't add more than 500 packs to a Premium sale.");
1559     _addPacksToSale(_newPacks, nextPremiumSale);
1560   }
1561 
1562   /// @dev Moves the sale we staged in nextPremiumSale over to the currentPremiumSale variable, and clears nextPremiumSale.
1563   ///   Also removes currentPremiumSale's featuredChecklistItem from circulation.
1564   function startNextPremiumSale() external onlyOwner {
1565     require(nextPremiumSale.packsLoaded == PREMIUM_SALE_PACK_COUNT, "You must add exactly 500 packs before starting this Premium sale.");
1566     if (currentPremiumSale.featuredChecklistItem >= 100) {
1567       mintingContract.pullFromCirculation(currentPremiumSale.featuredChecklistItem);
1568     }
1569     currentPremiumSale = nextPremiumSale;
1570     delete nextPremiumSale;
1571   }
1572 
1573   /// @dev Allows the owner to make last second changes to the staged Premium sale before pushing it live.
1574   /// @param _featuredChecklistItem The card of the day, which we will take out of circulation once the sale ends.
1575   /// @param _packPrice The price of packs for this sale, in wei. Must be greater than zero.
1576   function modifyNextPremiumSale(uint8 _featuredChecklistItem, uint256 _packPrice) external onlyOwner nonZeroPackPrice(_packPrice) {
1577     require(nextPremiumSale.packPrice > 0, "You must first create a nextPremiumSale.");
1578     nextPremiumSale.featuredChecklistItem = _featuredChecklistItem;
1579     nextPremiumSale.packPrice = _packPrice;
1580   }
1581 }
1582 
1583 
1584 /// @title All the internal functions that govern the act of turning a uint32 pack into 4 NFTs.
1585 /// @author The CryptoStrikers Team
1586 contract StrikersPackSaleInternal is StrikersPackFactory {
1587 
1588   /// @dev Emit this every time we sell a pack.
1589   event PackBought(address indexed buyer, uint256[] pack);
1590 
1591   /// @dev The number of cards in a pack.
1592   uint8 public constant PACK_SIZE = 4;
1593 
1594   /// @dev We increment this nonce when grabbing a random pack in _removeRandomPack().
1595   uint256 internal randNonce;
1596 
1597   /// @dev Function shared by all 3 ways of buying a pack (ETH, kitty burn, whitelist).
1598   /// @param _sale The sale we are buying from.
1599   function _buyPack(PackSale storage _sale) internal whenNotPaused {
1600     require(msg.sender == tx.origin, "Only EOAs are allowed to buy from the pack sale.");
1601     require(_sale.packs.length > 0, "The sale has no packs available for sale.");
1602     uint32 pack = _removeRandomPack(_sale.packs);
1603     uint256[] memory cards = _mintCards(pack);
1604     _sale.packsSold++;
1605     emit PackBought(msg.sender, cards);
1606   }
1607 
1608   /// @dev Iterates over a uint32 pack 8 bits at a time and turns each group of 8 bits into a token!
1609   /// @param _pack 32 bit integer where each group of 8 bits represents a checklist ID.
1610   /// @return An array of 4 token IDs, representing the cards we minted.
1611   function _mintCards(uint32 _pack) internal returns (uint256[]) {
1612     uint8 mask = 255;
1613     uint256[] memory newCards = new uint256[](PACK_SIZE);
1614 
1615     for (uint8 i = 1; i <= PACK_SIZE; i++) {
1616       // Can't underflow because PACK_SIZE is 4.
1617       uint8 shift = 32 - (i * 8);
1618       uint8 checklistId = uint8((_pack >> shift) & mask);
1619       uint256 cardId = mintingContract.mintPackSaleCard(checklistId, msg.sender);
1620       newCards[i-1] = cardId;
1621     }
1622 
1623     return newCards;
1624   }
1625 
1626   /// @dev Given an array of packs (uint32s), removes one from a random index.
1627   /// @param _packs The array of uint32s we will be mutating.
1628   /// @return The random uint32 we removed.
1629   function _removeRandomPack(uint32[] storage _packs) internal returns (uint32) {
1630     randNonce++;
1631     bytes memory packed = abi.encodePacked(now, msg.sender, randNonce);
1632     uint256 randomIndex = uint256(keccak256(packed)) % _packs.length;
1633     return _removePackAtIndex(randomIndex, _packs);
1634   }
1635 
1636   /// @dev Given an array of uint32s, remove the one at a given index and replace it with the last element of the array.
1637   /// @param _index The index of the pack we want to remove from the array.
1638   /// @param _packs The array of uint32s we will be mutating.
1639   /// @return The uint32 we removed from position _index.
1640   function _removePackAtIndex(uint256 _index, uint32[] storage _packs) internal returns (uint32) {
1641     // Can't underflow because we do require(_sale.packs.length > 0) in _buyPack().
1642     uint256 lastIndex = _packs.length - 1;
1643     require(_index <= lastIndex);
1644     uint32 pack = _packs[_index];
1645     _packs[_index] = _packs[lastIndex];
1646     _packs.length--;
1647     return pack;
1648   }
1649 }
1650 
1651 
1652 /// @title A contract that manages the whitelist we use for free pack giveaways.
1653 /// @author The CryptoStrikers Team
1654 contract StrikersWhitelist is StrikersPackSaleInternal {
1655 
1656   /// @dev Emit this when the contract owner increases a user's whitelist allocation.
1657   event WhitelistAllocationIncreased(address indexed user, uint16 amount, bool premium);
1658 
1659   /// @dev Emit this whenever someone gets a pack using their whitelist allocation.
1660   event WhitelistAllocationUsed(address indexed user, bool premium);
1661 
1662   /// @dev We can only give away a maximum of 1000 Standard packs, and 500 Premium packs.
1663   uint16[2] public whitelistLimits = [
1664     1000, // Standard
1665     500 // Premium
1666   ];
1667 
1668   /// @dev Keep track of the allocation for each whitelist so we don't go over the limit.
1669   uint16[2] public currentWhitelistCounts;
1670 
1671   /// @dev Index 0 is the Standard whitelist, index 1 is the Premium whitelist. Maps addresses to free pack allocation.
1672   mapping (address => uint8)[2] public whitelists;
1673 
1674   /// @dev Allows the owner to allocate free packs (either Standard or Premium) to a given address.
1675   /// @param _premium True for Premium whitelist, false for Standard whitelist.
1676   /// @param _addr Address of the user who is getting the free packs.
1677   /// @param _additionalPacks How many packs we are adding to this user's allocation.
1678   function addToWhitelistAllocation(bool _premium, address _addr, uint8 _additionalPacks) public onlyOwner {
1679     uint8 listIndex = _premium ? 1 : 0;
1680     require(currentWhitelistCounts[listIndex] + _additionalPacks <= whitelistLimits[listIndex]);
1681     currentWhitelistCounts[listIndex] += _additionalPacks;
1682     whitelists[listIndex][_addr] += _additionalPacks;
1683     emit WhitelistAllocationIncreased(_addr, _additionalPacks, _premium);
1684   }
1685 
1686   /// @dev A way to call addToWhitelistAllocation in bulk. Adds 1 pack to each address.
1687   /// @param _premium True for Premium whitelist, false for Standard whitelist.
1688   /// @param _addrs Addresses of the users who are getting the free packs.
1689   function addAddressesToWhitelist(bool _premium, address[] _addrs) external onlyOwner {
1690     for (uint256 i = 0; i < _addrs.length; i++) {
1691       addToWhitelistAllocation(_premium, _addrs[i], 1);
1692     }
1693   }
1694 
1695   /// @dev If msg.sender has whitelist allocation for a given pack type, decrement it and give them a free pack.
1696   /// @param _premium True for the Premium sale, false for the Standard sale.
1697   function claimWhitelistPack(bool _premium) external {
1698     uint8 listIndex = _premium ? 1 : 0;
1699     require(whitelists[listIndex][msg.sender] > 0, "You have no whitelist allocation.");
1700     // Can't underflow because of require() check above.
1701     whitelists[listIndex][msg.sender]--;
1702     PackSale storage sale = _premium ? currentPremiumSale : standardSale;
1703     _buyPack(sale);
1704     emit WhitelistAllocationUsed(msg.sender, _premium);
1705   }
1706 }
1707 
1708 
1709 /// @title The contract that manages our referral program -- invite your friends and get rewarded!
1710 /// @author The CryptoStrikers Team
1711 contract StrikersReferral is StrikersWhitelist {
1712 
1713   /// @dev A cap for how many free referral packs we are giving away.
1714   uint16 public constant MAX_FREE_REFERRAL_PACKS = 5000;
1715 
1716   /// @dev The percentage of each sale that gets paid out to the referrer as commission.
1717   uint256 public constant PERCENT_COMMISSION = 10;
1718 
1719   /// @dev The 8 bonus cards that you get for your first 8 referrals, in order.
1720   uint8[] public bonusCards = [
1721     115, // Kanté
1722     127, // Navas
1723     122, // Hummels
1724     130, // Alves
1725     116, // Cavani
1726     123, // Özil
1727     121, // Thiago
1728     131 // Zlatan
1729   ];
1730 
1731   /// @dev Emit this event when a sale gets attributed, so the referrer can see a log of all his referrals.
1732   event SaleAttributed(address indexed referrer, address buyer, uint256 amount);
1733 
1734   /// @dev How much many of the 8 bonus cards this referrer has claimed.
1735   mapping (address => uint8) public bonusCardsClaimed;
1736 
1737   /// @dev Use this to track whether or not a user has bought at least one pack, to avoid people gaming our referral program.
1738   mapping (address => uint16) public packsBought;
1739 
1740   /// @dev Keep track of this to make sure we don't go over MAX_FREE_REFERRAL_PACKS.
1741   uint16 public freeReferralPacksClaimed;
1742 
1743   /// @dev Tracks whether or not a user has already claimed their free referral pack.
1744   mapping (address => bool) public hasClaimedFreeReferralPack;
1745 
1746   /// @dev How much referral income a given referrer has claimed.
1747   mapping (address => uint256) public referralCommissionClaimed;
1748 
1749   /// @dev How much referral income a given referrer has earned.
1750   mapping (address => uint256) public referralCommissionEarned;
1751 
1752   /// @dev Tracks how many sales have been attributed to a given referrer.
1753   mapping (address => uint16) public referralSaleCount;
1754 
1755   /// @dev A mapping to keep track of who referred a given user.
1756   mapping (address => address) public referrers;
1757 
1758   /// @dev How much ETH is owed to referrers, so we don't touch it when we withdraw our take from the contract.
1759   uint256 public totalCommissionOwed;
1760 
1761   /// @dev After a pack is bought with ETH, we call this to attribute the sale to the buyer's referrer.
1762   /// @param _buyer The user who bought the pack.
1763   /// @param _amount The price of the pack bought, in wei.
1764   function _attributeSale(address _buyer, uint256 _amount) internal {
1765     address referrer = referrers[_buyer];
1766 
1767     // Can only attribute a sale to a valid referrer.
1768     // Referral commissions only accrue if the referrer has bought a pack.
1769     if (referrer == address(0) || packsBought[referrer] == 0) {
1770       return;
1771     }
1772 
1773     referralSaleCount[referrer]++;
1774 
1775     // The first 8 referral sales each unlock a bonus card.
1776     // Any sales past the first 8 generate referral commission.
1777     if (referralSaleCount[referrer] > bonusCards.length) {
1778       uint256 commission = _amount * PERCENT_COMMISSION / 100;
1779       totalCommissionOwed += commission;
1780       referralCommissionEarned[referrer] += commission;
1781     }
1782 
1783     emit SaleAttributed(referrer, _buyer, _amount);
1784   }
1785 
1786   /// @dev A referrer calls this to claim the next of the 8 bonus cards he is owed.
1787   function claimBonusCard() external {
1788     uint16 attributedSales = referralSaleCount[msg.sender];
1789     uint8 cardsClaimed = bonusCardsClaimed[msg.sender];
1790     require(attributedSales > cardsClaimed, "You have no unclaimed bonus cards.");
1791     require(cardsClaimed < bonusCards.length, "You have claimed all the bonus cards.");
1792     bonusCardsClaimed[msg.sender]++;
1793     uint8 bonusCardChecklistId = bonusCards[cardsClaimed];
1794     mintingContract.mintPackSaleCard(bonusCardChecklistId, msg.sender);
1795   }
1796 
1797   /// @dev A user who was referred to CryptoStrikers can call this once to claim their free pack (must have bought a pack first).
1798   function claimFreeReferralPack() external {
1799     require(isOwedFreeReferralPack(msg.sender), "You are not eligible for a free referral pack.");
1800     require(freeReferralPacksClaimed < MAX_FREE_REFERRAL_PACKS, "We've already given away all the free referral packs...");
1801     freeReferralPacksClaimed++;
1802     hasClaimedFreeReferralPack[msg.sender] = true;
1803     _buyPack(standardSale);
1804   }
1805 
1806   /// @dev Checks whether or not a given user is eligible for a free referral pack.
1807   /// @param _addr The address of the user we are inquiring about.
1808   /// @return True if user can call claimFreeReferralPack(), false otherwise.
1809   function isOwedFreeReferralPack(address _addr) public view returns (bool) {
1810     // _addr will only have a referrer if they've already bought a pack (see buyFirstPackFromReferral())
1811     address referrer = referrers[_addr];
1812 
1813     // To prevent abuse, require that the referrer has bought at least one pack.
1814     // Guaranteed to evaluate to false if referrer is address(0), so don't even check for that.
1815     bool referrerHasBoughtPack = packsBought[referrer] > 0;
1816 
1817     // Lastly, check to make sure _addr hasn't already claimed a free pack.
1818     return referrerHasBoughtPack && !hasClaimedFreeReferralPack[_addr];
1819   }
1820 
1821   /// @dev Allows the contract owner to manually set the referrer for a given user, in case this wasn't properly attributed.
1822   /// @param _for The user we want to set the referrer for.
1823   /// @param _referrer The user who will now get credit for _for's future purchases.
1824   function setReferrer(address _for, address _referrer) external onlyOwner {
1825     referrers[_for] = _referrer;
1826   }
1827 
1828   /// @dev Allows a user to withdraw the referral commission they are owed.
1829   function withdrawCommission() external {
1830     uint256 commission = referralCommissionEarned[msg.sender] - referralCommissionClaimed[msg.sender];
1831     require(commission > 0, "You are not owed any referral commission.");
1832     totalCommissionOwed -= commission;
1833     referralCommissionClaimed[msg.sender] += commission;
1834     msg.sender.transfer(commission);
1835   }
1836 }
1837 
1838 
1839 
1840 /// @title The main sale contract, allowing users to purchase packs of CryptoStrikers cards.
1841 /// @author The CryptoStrikers Team
1842 contract StrikersPackSale is StrikersReferral {
1843 
1844   /// @dev The max number of kitties we are allowed to burn.
1845   uint16 public constant KITTY_BURN_LIMIT = 1000;
1846 
1847   /// @dev Emit this whenever someone sacrifices a cat for a free pack of cards.
1848   event KittyBurned(address user, uint256 kittyId);
1849 
1850   /// @dev Users are only allowed to burn 1 cat each, so keep track of that here.
1851   mapping (address => bool) public hasBurnedKitty;
1852 
1853   /// @dev A reference to the CryptoKitties contract so we can transfer cats
1854   ERC721Basic public kittiesContract;
1855 
1856   /// @dev How many kitties we have burned so far. Think of the cats, make sure we don't go over KITTY_BURN_LIMIT!
1857   uint16 public totalKittiesBurned;
1858 
1859   /// @dev Keeps track of our sale volume, in wei.
1860   uint256 public totalWeiRaised;
1861 
1862   /// @dev Constructor. Can't change minting and kitties contracts once they've been initialized.
1863   constructor(
1864     uint256 _standardPackPrice,
1865     address _kittiesContractAddress,
1866     address _mintingContractAddress
1867   )
1868   StrikersPackFactory(_standardPackPrice)
1869   public
1870   {
1871     kittiesContract = ERC721Basic(_kittiesContractAddress);
1872     mintingContract = StrikersMinting(_mintingContractAddress);
1873   }
1874 
1875   /// @dev For a user who was referred, use this function to buy your first back so we can attribute the referral.
1876   /// @param _referrer The user who invited msg.sender to CryptoStrikers.
1877   /// @param _premium True if we're buying from Premium sale, false if we're buying from Standard sale.
1878   function buyFirstPackFromReferral(address _referrer, bool _premium) external payable {
1879     require(packsBought[msg.sender] == 0, "Only assign a referrer on a user's first purchase.");
1880     referrers[msg.sender] = _referrer;
1881     buyPackWithETH(_premium);
1882   }
1883 
1884   /// @dev Allows a user to buy a pack of cards with enough ETH to cover the packPrice.
1885   /// @param _premium True if we're buying from Premium sale, false if we're buying from Standard sale.
1886   function buyPackWithETH(bool _premium) public payable {
1887     PackSale storage sale = _premium ? currentPremiumSale : standardSale;
1888     uint256 packPrice = sale.packPrice;
1889     require(msg.value >= packPrice, "Insufficient ETH sent to buy this pack.");
1890     _buyPack(sale);
1891     packsBought[msg.sender]++;
1892     totalWeiRaised += packPrice;
1893     // Refund excess funds
1894     msg.sender.transfer(msg.value - packPrice);
1895     _attributeSale(msg.sender, packPrice);
1896   }
1897 
1898   /// @notice Magically transform a CryptoKitty into a free pack of cards!
1899   /// @param _kittyId The cat we are giving up.
1900   /// @dev Note that the user must first give this contract approval by
1901   ///   calling approve(address(this), _kittyId) on the CK contract.
1902   ///   Otherwise, buyPackWithKitty() throws on transferFrom().
1903   function buyPackWithKitty(uint256 _kittyId) external {
1904     require(totalKittiesBurned < KITTY_BURN_LIMIT, "Stop! Think of the cats!");
1905     require(!hasBurnedKitty[msg.sender], "You've already burned a kitty.");
1906     totalKittiesBurned++;
1907     hasBurnedKitty[msg.sender] = true;
1908     // Will throw/revert if this contract hasn't been given approval first.
1909     // Also, with no way of retrieving kitties from this contract,
1910     // transferring to "this" burns the cat! (desired behaviour)
1911     kittiesContract.transferFrom(msg.sender, this, _kittyId);
1912     _buyPack(standardSale);
1913     emit KittyBurned(msg.sender, _kittyId);
1914   }
1915 
1916   /// @dev Allows the contract owner to withdraw the ETH raised from selling packs.
1917   function withdrawBalance() external onlyOwner {
1918     uint256 totalBalance = address(this).balance;
1919     require(totalBalance > totalCommissionOwed, "There is no ETH for the owner to claim.");
1920     owner.transfer(totalBalance - totalCommissionOwed);
1921   }
1922 }