1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC721 Non-Fungible Token Standard basic interface
5  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
6  */
7 contract ERC721Basic {
8   event Transfer(
9     address indexed _from,
10     address indexed _to,
11     uint256 _tokenId
12   );
13   event Approval(
14     address indexed _owner,
15     address indexed _approved,
16     uint256 _tokenId
17   );
18   event ApprovalForAll(
19     address indexed _owner,
20     address indexed _operator,
21     bool _approved
22   );
23 
24   function balanceOf(address _owner) public view returns (uint256 _balance);
25   function ownerOf(uint256 _tokenId) public view returns (address _owner);
26   function exists(uint256 _tokenId) public view returns (bool _exists);
27 
28   function approve(address _to, uint256 _tokenId) public;
29   function getApproved(uint256 _tokenId)
30     public view returns (address _operator);
31 
32   function setApprovalForAll(address _operator, bool _approved) public;
33   function isApprovedForAll(address _owner, address _operator)
34     public view returns (bool);
35 
36   function transferFrom(address _from, address _to, uint256 _tokenId) public;
37   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
38     public;
39 
40   function safeTransferFrom(
41     address _from,
42     address _to,
43     uint256 _tokenId,
44     bytes _data
45   )
46     public;
47 }
48 
49 
50 /**
51  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
52  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
53  */
54 contract ERC721Enumerable is ERC721Basic {
55   function totalSupply() public view returns (uint256);
56   function tokenOfOwnerByIndex(
57     address _owner,
58     uint256 _index
59   )
60     public
61     view
62     returns (uint256 _tokenId);
63 
64   function tokenByIndex(uint256 _index) public view returns (uint256);
65 }
66 
67 
68 /**
69  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
70  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
71  */
72 contract ERC721Metadata is ERC721Basic {
73   function name() public view returns (string _name);
74   function symbol() public view returns (string _symbol);
75   function tokenURI(uint256 _tokenId) public view returns (string);
76 }
77 
78 
79 /**
80  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
81  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
82  */
83 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
84 }
85 
86 
87 /**
88  * @title ERC721 token receiver interface
89  * @dev Interface for any contract that wants to support safeTransfers
90  *  from ERC721 asset contracts.
91  */
92 contract ERC721Receiver {
93   /**
94    * @dev Magic value to be returned upon successful reception of an NFT
95    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
96    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
97    */
98   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
99 
100   /**
101    * @notice Handle the receipt of an NFT
102    * @dev The ERC721 smart contract calls this function on the recipient
103    *  after a `safetransfer`. This function MAY throw to revert and reject the
104    *  transfer. This function MUST use 50,000 gas or less. Return of other
105    *  than the magic value MUST result in the transaction being reverted.
106    *  Note: the contract address is always the message sender.
107    * @param _from The sending address
108    * @param _tokenId The NFT identifier which is being transfered
109    * @param _data Additional data with no specified format
110    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
111    */
112   function onERC721Received(
113     address _from,
114     uint256 _tokenId,
115     bytes _data
116   )
117     public
118     returns(bytes4);
119 }
120 
121 /**
122  * @title SafeMath
123  * @dev Math operations with safety checks that throw on error
124  */
125 library SafeMath {
126 
127   /**
128   * @dev Multiplies two numbers, throws on overflow.
129   */
130   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
131     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
132     // benefit is lost if 'b' is also tested.
133     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
134     if (a == 0) {
135       return 0;
136     }
137 
138     c = a * b;
139     assert(c / a == b);
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers, truncating the quotient.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     // assert(b > 0); // Solidity automatically throws when dividing by 0
148     // uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150     return a / b;
151   }
152 
153   /**
154   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   /**
162   * @dev Adds two numbers, throws on overflow.
163   */
164   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
165     c = a + b;
166     assert(c >= a);
167     return c;
168   }
169 }
170 
171 /**
172  * Utility library of inline functions on addresses
173  */
174 library AddressUtils {
175 
176   /**
177    * Returns whether the target address is a contract
178    * @dev This function will return false if invoked during the constructor of a contract,
179    *  as the code is not actually created until after the constructor finishes.
180    * @param addr address to check
181    * @return whether the target address is a contract
182    */
183   function isContract(address addr) internal view returns (bool) {
184     uint256 size;
185     // XXX Currently there is no better way to check if there is a contract in an address
186     // than to check the size of the code at that address.
187     // See https://ethereum.stackexchange.com/a/14016/36603
188     // for more details about how this works.
189     // TODO Check this again before the Serenity release, because all addresses will be
190     // contracts then.
191     // solium-disable-next-line security/no-inline-assembly
192     assembly { size := extcodesize(addr) }
193     return size > 0;
194   }
195 
196 }
197 
198 
199 
200 /**
201  * @title ERC721 Non-Fungible Token Standard basic implementation
202  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
203  */
204 contract ERC721BasicToken is ERC721Basic {
205   using SafeMath for uint256;
206   using AddressUtils for address;
207 
208   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
209   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
210   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
211 
212   // Mapping from token ID to owner
213   mapping (uint256 => address) internal tokenOwner;
214 
215   // Mapping from token ID to approved address
216   mapping (uint256 => address) internal tokenApprovals;
217 
218   // Mapping from owner to number of owned token
219   mapping (address => uint256) internal ownedTokensCount;
220 
221   // Mapping from owner to operator approvals
222   mapping (address => mapping (address => bool)) internal operatorApprovals;
223 
224   /**
225    * @dev Guarantees msg.sender is owner of the given token
226    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
227    */
228   modifier onlyOwnerOf(uint256 _tokenId) {
229     require(ownerOf(_tokenId) == msg.sender);
230     _;
231   }
232 
233   /**
234    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
235    * @param _tokenId uint256 ID of the token to validate
236    */
237   modifier canTransfer(uint256 _tokenId) {
238     require(isApprovedOrOwner(msg.sender, _tokenId));
239     _;
240   }
241 
242   /**
243    * @dev Gets the balance of the specified address
244    * @param _owner address to query the balance of
245    * @return uint256 representing the amount owned by the passed address
246    */
247   function balanceOf(address _owner) public view returns (uint256) {
248     require(_owner != address(0));
249     return ownedTokensCount[_owner];
250   }
251 
252   /**
253    * @dev Gets the owner of the specified token ID
254    * @param _tokenId uint256 ID of the token to query the owner of
255    * @return owner address currently marked as the owner of the given token ID
256    */
257   function ownerOf(uint256 _tokenId) public view returns (address) {
258     address owner = tokenOwner[_tokenId];
259     require(owner != address(0));
260     return owner;
261   }
262 
263   /**
264    * @dev Returns whether the specified token exists
265    * @param _tokenId uint256 ID of the token to query the existence of
266    * @return whether the token exists
267    */
268   function exists(uint256 _tokenId) public view returns (bool) {
269     address owner = tokenOwner[_tokenId];
270     return owner != address(0);
271   }
272 
273   /**
274    * @dev Approves another address to transfer the given token ID
275    * @dev The zero address indicates there is no approved address.
276    * @dev There can only be one approved address per token at a given time.
277    * @dev Can only be called by the token owner or an approved operator.
278    * @param _to address to be approved for the given token ID
279    * @param _tokenId uint256 ID of the token to be approved
280    */
281   function approve(address _to, uint256 _tokenId) public {
282     address owner = ownerOf(_tokenId);
283     require(_to != owner);
284     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
285 
286     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
287       tokenApprovals[_tokenId] = _to;
288       emit Approval(owner, _to, _tokenId);
289     }
290   }
291 
292   /**
293    * @dev Gets the approved address for a token ID, or zero if no address set
294    * @param _tokenId uint256 ID of the token to query the approval of
295    * @return address currently approved for the given token ID
296    */
297   function getApproved(uint256 _tokenId) public view returns (address) {
298     return tokenApprovals[_tokenId];
299   }
300 
301   /**
302    * @dev Sets or unsets the approval of a given operator
303    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
304    * @param _to operator address to set the approval
305    * @param _approved representing the status of the approval to be set
306    */
307   function setApprovalForAll(address _to, bool _approved) public {
308     require(_to != msg.sender);
309     operatorApprovals[msg.sender][_to] = _approved;
310     emit ApprovalForAll(msg.sender, _to, _approved);
311   }
312 
313   /**
314    * @dev Tells whether an operator is approved by a given owner
315    * @param _owner owner address which you want to query the approval of
316    * @param _operator operator address which you want to query the approval of
317    * @return bool whether the given operator is approved by the given owner
318    */
319   function isApprovedForAll(
320     address _owner,
321     address _operator
322   )
323     public
324     view
325     returns (bool)
326   {
327     return operatorApprovals[_owner][_operator];
328   }
329 
330   /**
331    * @dev Transfers the ownership of a given token ID to another address
332    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
333    * @dev Requires the msg sender to be the owner, approved, or operator
334    * @param _from current owner of the token
335    * @param _to address to receive the ownership of the given token ID
336    * @param _tokenId uint256 ID of the token to be transferred
337   */
338   function transferFrom(
339     address _from,
340     address _to,
341     uint256 _tokenId
342   )
343     public
344     canTransfer(_tokenId)
345   {
346     require(_from != address(0));
347     require(_to != address(0));
348 
349     clearApproval(_from, _tokenId);
350     removeTokenFrom(_from, _tokenId);
351     addTokenTo(_to, _tokenId);
352 
353     emit Transfer(_from, _to, _tokenId);
354   }
355 
356   /**
357    * @dev Safely transfers the ownership of a given token ID to another address
358    * @dev If the target address is a contract, it must implement `onERC721Received`,
359    *  which is called upon a safe transfer, and return the magic value
360    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
361    *  the transfer is reverted.
362    * @dev Requires the msg sender to be the owner, approved, or operator
363    * @param _from current owner of the token
364    * @param _to address to receive the ownership of the given token ID
365    * @param _tokenId uint256 ID of the token to be transferred
366   */
367   function safeTransferFrom(
368     address _from,
369     address _to,
370     uint256 _tokenId
371   )
372     public
373     canTransfer(_tokenId)
374   {
375     // solium-disable-next-line arg-overflow
376     safeTransferFrom(_from, _to, _tokenId, "");
377   }
378 
379   /**
380    * @dev Safely transfers the ownership of a given token ID to another address
381    * @dev If the target address is a contract, it must implement `onERC721Received`,
382    *  which is called upon a safe transfer, and return the magic value
383    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
384    *  the transfer is reverted.
385    * @dev Requires the msg sender to be the owner, approved, or operator
386    * @param _from current owner of the token
387    * @param _to address to receive the ownership of the given token ID
388    * @param _tokenId uint256 ID of the token to be transferred
389    * @param _data bytes data to send along with a safe transfer check
390    */
391   function safeTransferFrom(
392     address _from,
393     address _to,
394     uint256 _tokenId,
395     bytes _data
396   )
397     public
398     canTransfer(_tokenId)
399   {
400     transferFrom(_from, _to, _tokenId);
401     // solium-disable-next-line arg-overflow
402     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
403   }
404 
405   /**
406    * @dev Returns whether the given spender can transfer a given token ID
407    * @param _spender address of the spender to query
408    * @param _tokenId uint256 ID of the token to be transferred
409    * @return bool whether the msg.sender is approved for the given token ID,
410    *  is an operator of the owner, or is the owner of the token
411    */
412   function isApprovedOrOwner(
413     address _spender,
414     uint256 _tokenId
415   )
416     internal
417     view
418     returns (bool)
419   {
420     address owner = ownerOf(_tokenId);
421     // Disable solium check because of
422     // https://github.com/duaraghav8/Solium/issues/175
423     // solium-disable-next-line operator-whitespace
424     return (
425       _spender == owner ||
426       getApproved(_tokenId) == _spender ||
427       isApprovedForAll(owner, _spender)
428     );
429   }
430 
431   /**
432    * @dev Internal function to mint a new token
433    * @dev Reverts if the given token ID already exists
434    * @param _to The address that will own the minted token
435    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
436    */
437   function _mint(address _to, uint256 _tokenId) internal {
438     require(_to != address(0));
439     addTokenTo(_to, _tokenId);
440     emit Transfer(address(0), _to, _tokenId);
441   }
442 
443   /**
444    * @dev Internal function to burn a specific token
445    * @dev Reverts if the token does not exist
446    * @param _tokenId uint256 ID of the token being burned by the msg.sender
447    */
448   function _burn(address _owner, uint256 _tokenId) internal {
449     clearApproval(_owner, _tokenId);
450     removeTokenFrom(_owner, _tokenId);
451     emit Transfer(_owner, address(0), _tokenId);
452   }
453 
454   /**
455    * @dev Internal function to clear current approval of a given token ID
456    * @dev Reverts if the given address is not indeed the owner of the token
457    * @param _owner owner of the token
458    * @param _tokenId uint256 ID of the token to be transferred
459    */
460   function clearApproval(address _owner, uint256 _tokenId) internal {
461     require(ownerOf(_tokenId) == _owner);
462     if (tokenApprovals[_tokenId] != address(0)) {
463       tokenApprovals[_tokenId] = address(0);
464       emit Approval(_owner, address(0), _tokenId);
465     }
466   }
467 
468   /**
469    * @dev Internal function to add a token ID to the list of a given address
470    * @param _to address representing the new owner of the given token ID
471    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
472    */
473   function addTokenTo(address _to, uint256 _tokenId) internal {
474     require(tokenOwner[_tokenId] == address(0));
475     tokenOwner[_tokenId] = _to;
476     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
477   }
478 
479   /**
480    * @dev Internal function to remove a token ID from the list of a given address
481    * @param _from address representing the previous owner of the given token ID
482    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
483    */
484   function removeTokenFrom(address _from, uint256 _tokenId) internal {
485     require(ownerOf(_tokenId) == _from);
486     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
487     tokenOwner[_tokenId] = address(0);
488   }
489 
490   /**
491    * @dev Internal function to invoke `onERC721Received` on a target address
492    * @dev The call is not executed if the target address is not a contract
493    * @param _from address representing the previous owner of the given token ID
494    * @param _to target address that will receive the tokens
495    * @param _tokenId uint256 ID of the token to be transferred
496    * @param _data bytes optional data to send along with the call
497    * @return whether the call correctly returned the expected magic value
498    */
499   function checkAndCallSafeTransfer(
500     address _from,
501     address _to,
502     uint256 _tokenId,
503     bytes _data
504   )
505     internal
506     returns (bool)
507   {
508     if (!_to.isContract()) {
509       return true;
510     }
511     bytes4 retval = ERC721Receiver(_to).onERC721Received(
512       _from, _tokenId, _data);
513     return (retval == ERC721_RECEIVED);
514   }
515 }
516 
517 
518 /**
519  * @title Full ERC721 Token
520  * This implementation includes all the required and some optional functionality of the ERC721 standard
521  * Moreover, it includes approve all functionality using operator terminology
522  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
523  */
524 contract ERC721Token is ERC721, ERC721BasicToken {
525   // Token name
526   string internal name_;
527 
528   // Token symbol
529   string internal symbol_;
530 
531   // Mapping from owner to list of owned token IDs
532   mapping(address => uint256[]) internal ownedTokens;
533 
534   // Mapping from token ID to index of the owner tokens list
535   mapping(uint256 => uint256) internal ownedTokensIndex;
536 
537   // Array with all token ids, used for enumeration
538   uint256[] internal allTokens;
539 
540   // Mapping from token id to position in the allTokens array
541   mapping(uint256 => uint256) internal allTokensIndex;
542 
543   // Optional mapping for token URIs
544   mapping(uint256 => string) internal tokenURIs;
545 
546   /**
547    * @dev Constructor function
548    */
549   constructor(string _name, string _symbol) public {
550     name_ = _name;
551     symbol_ = _symbol;
552   }
553 
554   /**
555    * @dev Gets the token name
556    * @return string representing the token name
557    */
558   function name() public view returns (string) {
559     return name_;
560   }
561 
562   /**
563    * @dev Gets the token symbol
564    * @return string representing the token symbol
565    */
566   function symbol() public view returns (string) {
567     return symbol_;
568   }
569 
570   /**
571    * @dev Returns an URI for a given token ID
572    * @dev Throws if the token ID does not exist. May return an empty string.
573    * @param _tokenId uint256 ID of the token to query
574    */
575   function tokenURI(uint256 _tokenId) public view returns (string) {
576     require(exists(_tokenId));
577     return tokenURIs[_tokenId];
578   }
579 
580   /**
581    * @dev Gets the token ID at a given index of the tokens list of the requested owner
582    * @param _owner address owning the tokens list to be accessed
583    * @param _index uint256 representing the index to be accessed of the requested tokens list
584    * @return uint256 token ID at the given index of the tokens list owned by the requested address
585    */
586   function tokenOfOwnerByIndex(
587     address _owner,
588     uint256 _index
589   )
590     public
591     view
592     returns (uint256)
593   {
594     require(_index < balanceOf(_owner));
595     return ownedTokens[_owner][_index];
596   }
597 
598   /**
599    * @dev Gets the total amount of tokens stored by the contract
600    * @return uint256 representing the total amount of tokens
601    */
602   function totalSupply() public view returns (uint256) {
603     return allTokens.length;
604   }
605 
606   /**
607    * @dev Gets the token ID at a given index of all the tokens in this contract
608    * @dev Reverts if the index is greater or equal to the total number of tokens
609    * @param _index uint256 representing the index to be accessed of the tokens list
610    * @return uint256 token ID at the given index of the tokens list
611    */
612   function tokenByIndex(uint256 _index) public view returns (uint256) {
613     require(_index < totalSupply());
614     return allTokens[_index];
615   }
616 
617   /**
618    * @dev Internal function to set the token URI for a given token
619    * @dev Reverts if the token ID does not exist
620    * @param _tokenId uint256 ID of the token to set its URI
621    * @param _uri string URI to assign
622    */
623   function _setTokenURI(uint256 _tokenId, string _uri) internal {
624     require(exists(_tokenId));
625     tokenURIs[_tokenId] = _uri;
626   }
627 
628   /**
629    * @dev Internal function to add a token ID to the list of a given address
630    * @param _to address representing the new owner of the given token ID
631    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
632    */
633   function addTokenTo(address _to, uint256 _tokenId) internal {
634     super.addTokenTo(_to, _tokenId);
635     uint256 length = ownedTokens[_to].length;
636     ownedTokens[_to].push(_tokenId);
637     ownedTokensIndex[_tokenId] = length;
638   }
639 
640   /**
641    * @dev Internal function to remove a token ID from the list of a given address
642    * @param _from address representing the previous owner of the given token ID
643    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
644    */
645   function removeTokenFrom(address _from, uint256 _tokenId) internal {
646     super.removeTokenFrom(_from, _tokenId);
647 
648     uint256 tokenIndex = ownedTokensIndex[_tokenId];
649     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
650     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
651 
652     ownedTokens[_from][tokenIndex] = lastToken;
653     ownedTokens[_from][lastTokenIndex] = 0;
654     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
655     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
656     // the lastToken to the first position, and then dropping the element placed in the last position of the list
657 
658     ownedTokens[_from].length--;
659     ownedTokensIndex[_tokenId] = 0;
660     ownedTokensIndex[lastToken] = tokenIndex;
661   }
662 
663   /**
664    * @dev Internal function to mint a new token
665    * @dev Reverts if the given token ID already exists
666    * @param _to address the beneficiary that will own the minted token
667    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
668    */
669   function _mint(address _to, uint256 _tokenId) internal {
670     super._mint(_to, _tokenId);
671 
672     allTokensIndex[_tokenId] = allTokens.length;
673     allTokens.push(_tokenId);
674   }
675 
676   /**
677    * @dev Internal function to burn a specific token
678    * @dev Reverts if the token does not exist
679    * @param _owner owner of the token to burn
680    * @param _tokenId uint256 ID of the token being burned by the msg.sender
681    */
682   function _burn(address _owner, uint256 _tokenId) internal {
683     super._burn(_owner, _tokenId);
684 
685     // Clear metadata (if any)
686     if (bytes(tokenURIs[_tokenId]).length != 0) {
687       delete tokenURIs[_tokenId];
688     }
689 
690     // Reorg all tokens array
691     uint256 tokenIndex = allTokensIndex[_tokenId];
692     uint256 lastTokenIndex = allTokens.length.sub(1);
693     uint256 lastToken = allTokens[lastTokenIndex];
694 
695     allTokens[tokenIndex] = lastToken;
696     allTokens[lastTokenIndex] = 0;
697 
698     allTokens.length--;
699     allTokensIndex[_tokenId] = 0;
700     allTokensIndex[lastToken] = tokenIndex;
701   }
702 
703 }
704 
705 /**
706  * @title Ownable
707  * @dev The Ownable contract has an owner address, and provides basic authorization control
708  * functions, this simplifies the implementation of "user permissions".
709  */
710 contract Ownable {
711   address public owner;
712 
713 
714   event OwnershipRenounced(address indexed previousOwner);
715   event OwnershipTransferred(
716     address indexed previousOwner,
717     address indexed newOwner
718   );
719 
720 
721   /**
722    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
723    * account.
724    */
725   constructor() public {
726     owner = msg.sender;
727   }
728 
729   /**
730    * @dev Throws if called by any account other than the owner.
731    */
732   modifier onlyOwner() {
733     require(msg.sender == owner);
734     _;
735   }
736 
737   /**
738    * @dev Allows the current owner to relinquish control of the contract.
739    */
740   function renounceOwnership() public onlyOwner {
741     emit OwnershipRenounced(owner);
742     owner = address(0);
743   }
744 
745   /**
746    * @dev Allows the current owner to transfer control of the contract to a newOwner.
747    * @param _newOwner The address to transfer ownership to.
748    */
749   function transferOwnership(address _newOwner) public onlyOwner {
750     _transferOwnership(_newOwner);
751   }
752 
753   /**
754    * @dev Transfers control of the contract to a newOwner.
755    * @param _newOwner The address to transfer ownership to.
756    */
757   function _transferOwnership(address _newOwner) internal {
758     require(_newOwner != address(0));
759     emit OwnershipTransferred(owner, _newOwner);
760     owner = _newOwner;
761   }
762 }
763 
764 
765 /**
766  * @title CryptoArte
767  * CryptoArte - a non-fungible token smart contract for 
768  * paintings from the www.cryptoarte.io collection
769  */
770 contract CryptoArte is ERC721Token, Ownable {
771 
772     // Token id to painting image file hash mapping
773     mapping (uint256 => uint256) public tokenIdToHash;
774 
775     constructor() ERC721Token("CryptoArte", "CARTE") public { }
776 
777     /**
778     * @dev Mints a token to an address with a tokenURI and tokenHash.
779     * @param _to address of the future owner of the token
780     * @param _tokenId uint256 token ID (painting number)
781     * @param _tokenURI string token metadata URI
782     * @param _tokenHash uint256 token image Hash
783     */
784     function mintTo(address _to, string _tokenURI, uint256 _tokenId, uint256 _tokenHash) public onlyOwner {
785         _mint(_to, _tokenId);
786         _setTokenURI(_tokenId, _tokenURI);
787         tokenIdToHash[_tokenId] = _tokenHash;
788     }    
789 
790     /**
791     * @dev Mints many tokens to an address with their tokenURIs and tokenHashes.
792     * @param _to address of the future owner of the tokens
793     * @param _tokenIds uint256 array of token IDs (painting numbers)
794     * @param _tokenURIPrefix string prefix for token metadata URI
795     * @param _tokenHashes uint256 array of token image Hashes
796     */
797     function mintManyTo(address _to, string _tokenURIPrefix, uint256[] _tokenIds, uint256[] _tokenHashes) public onlyOwner {
798         require(_tokenIds.length >= 1);
799         require(_tokenIds.length == _tokenHashes.length);
800 
801         for (uint i = 0; i < _tokenIds.length; i++) { 
802             _mint(_to, _tokenIds[i]);
803             _setTokenURI(_tokenIds[i], strConcat(_tokenURIPrefix, uint256Tostr(_tokenIds[i])));
804             tokenIdToHash[_tokenIds[i]] = _tokenHashes[i];
805         }
806     }    
807 
808     /**
809     * @dev Updates tokenURI for tokenId - to be used to correct errors
810     * @dev Throws if the tokenId does not exist
811     * @param _tokenId uint256 token ID (painting number)
812     * @param _tokenURI string token metadata URI
813     */
814     function setTokenURI(string _tokenURI, uint256 _tokenId) public onlyOwner {
815         _setTokenURI(_tokenId, _tokenURI);
816     }    
817 
818     /**
819     * @dev Updates tokenHash for tokenId - to be used only to correct errors
820     * @dev Throws if the tokenId does not exist    
821     * @param _tokenId uint256 token ID (painting number)
822     * @param _tokenHash uint256 token image Hash
823     */
824     function setTokenHash(uint256 _tokenHash, uint256 _tokenId) public onlyOwner {
825         require(exists(_tokenId));
826         tokenIdToHash[_tokenId] = _tokenHash;
827     }    
828     
829     /**
830     * @dev Contatenates two strings
831     * @param _a string first (left)
832     * @param _b string second (right)
833     */
834     function strConcat(string _a, string _b) internal pure returns (string) {
835         bytes memory _ba = bytes(_a);
836         bytes memory _bb = bytes(_b);
837         string memory ab = new string(_ba.length + _bb.length);
838         bytes memory bab = bytes(ab);
839         uint k = 0;
840         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
841         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
842         return string(bab);
843     }
844 
845     /**
846     * @dev Converts a uint256 to string
847     * @param _i uint256 the uint to convert
848     */
849     function uint256Tostr(uint256 _i) internal pure returns (string) {
850         if (_i == 0) return "0";
851         uint256 j = _i;
852         uint256 len;
853         while (j != 0) {
854             len++;
855             j /= 10;
856         }
857         bytes memory bstr = new bytes(len);
858         uint256 k = len - 1;
859         while (_i != 0){
860             bstr[k--] = byte(48 + _i % 10);
861             _i /= 10;
862         }
863         return string(bstr);
864     }    
865 
866 }