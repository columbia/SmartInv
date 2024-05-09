1 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Receiver.sol
44 
45 /**
46  * @title ERC721 token receiver interface
47  * @dev Interface for any contract that wants to support safeTransfers
48  *  from ERC721 asset contracts.
49  */
50 contract ERC721Receiver {
51   /**
52    * @dev Magic value to be returned upon successful reception of an NFT
53    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
54    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
55    */
56   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
57 
58   /**
59    * @notice Handle the receipt of an NFT
60    * @dev The ERC721 smart contract calls this function on the recipient
61    *  after a `safetransfer`. This function MAY throw to revert and reject the
62    *  transfer. This function MUST use 50,000 gas or less. Return of other
63    *  than the magic value MUST result in the transaction being reverted.
64    *  Note: the contract address is always the message sender.
65    * @param _from The sending address
66    * @param _tokenId The NFT identifier which is being transfered
67    * @param _data Additional data with no specified format
68    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
69    */
70   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
71 }
72 
73 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Holder.sol
74 
75 contract ERC721Holder is ERC721Receiver {
76   function onERC721Received(address, uint256, bytes) public returns(bytes4) {
77     return ERC721_RECEIVED;
78   }
79 }
80 
81 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Basic.sol
82 
83 /**
84  * @title ERC721 Non-Fungible Token Standard basic interface
85  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
86  */
87 contract ERC721Basic {
88   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
89   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
90   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
91 
92   function balanceOf(address _owner) public view returns (uint256 _balance);
93   function ownerOf(uint256 _tokenId) public view returns (address _owner);
94   function exists(uint256 _tokenId) public view returns (bool _exists);
95 
96   function approve(address _to, uint256 _tokenId) public;
97   function getApproved(uint256 _tokenId) public view returns (address _operator);
98 
99   function setApprovalForAll(address _operator, bool _approved) public;
100   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
101 
102   function transferFrom(address _from, address _to, uint256 _tokenId) public;
103   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
104   function safeTransferFrom(
105     address _from,
106     address _to,
107     uint256 _tokenId,
108     bytes _data
109   )
110     public;
111 }
112 
113 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
114 
115 /**
116  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
117  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
118  */
119 contract ERC721Enumerable is ERC721Basic {
120   function totalSupply() public view returns (uint256);
121   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
122   function tokenByIndex(uint256 _index) public view returns (uint256);
123 }
124 
125 
126 /**
127  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
128  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
129  */
130 contract ERC721Metadata is ERC721Basic {
131   function name() public view returns (string _name);
132   function symbol() public view returns (string _symbol);
133   function tokenURI(uint256 _tokenId) public view returns (string);
134 }
135 
136 
137 /**
138  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
139  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
140  */
141 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
142 }
143 
144 // File: node_modules\openzeppelin-solidity\contracts\AddressUtils.sol
145 
146 /**
147  * Utility library of inline functions on addresses
148  */
149 library AddressUtils {
150 
151   /**
152    * Returns whether the target address is a contract
153    * @dev This function will return false if invoked during the constructor of a contract,
154    *  as the code is not actually created until after the constructor finishes.
155    * @param addr address to check
156    * @return whether the target address is a contract
157    */
158   function isContract(address addr) internal view returns (bool) {
159     uint256 size;
160     // XXX Currently there is no better way to check if there is a contract in an address
161     // than to check the size of the code at that address.
162     // See https://ethereum.stackexchange.com/a/14016/36603
163     // for more details about how this works.
164     // TODO Check this again before the Serenity release, because all addresses will be
165     // contracts then.
166     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
167     return size > 0;
168   }
169 
170 }
171 
172 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
173 
174 /**
175  * @title SafeMath
176  * @dev Math operations with safety checks that throw on error
177  */
178 library SafeMath {
179 
180   /**
181   * @dev Multiplies two numbers, throws on overflow.
182   */
183   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
184     if (a == 0) {
185       return 0;
186     }
187     c = a * b;
188     assert(c / a == b);
189     return c;
190   }
191 
192   /**
193   * @dev Integer division of two numbers, truncating the quotient.
194   */
195   function div(uint256 a, uint256 b) internal pure returns (uint256) {
196     // assert(b > 0); // Solidity automatically throws when dividing by 0
197     // uint256 c = a / b;
198     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199     return a / b;
200   }
201 
202   /**
203   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
204   */
205   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206     assert(b <= a);
207     return a - b;
208   }
209 
210   /**
211   * @dev Adds two numbers, throws on overflow.
212   */
213   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
214     c = a + b;
215     assert(c >= a);
216     return c;
217   }
218 }
219 
220 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721BasicToken.sol
221 
222 /**
223  * @title ERC721 Non-Fungible Token Standard basic implementation
224  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
225  */
226 contract ERC721BasicToken is ERC721Basic {
227   using SafeMath for uint256;
228   using AddressUtils for address;
229 
230   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
231   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
232   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
233 
234   // Mapping from token ID to owner
235   mapping (uint256 => address) internal tokenOwner;
236 
237   // Mapping from token ID to approved address
238   mapping (uint256 => address) internal tokenApprovals;
239 
240   // Mapping from owner to number of owned token
241   mapping (address => uint256) internal ownedTokensCount;
242 
243   // Mapping from owner to operator approvals
244   mapping (address => mapping (address => bool)) internal operatorApprovals;
245 
246   /**
247    * @dev Guarantees msg.sender is owner of the given token
248    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
249    */
250   modifier onlyOwnerOf(uint256 _tokenId) {
251     require(ownerOf(_tokenId) == msg.sender);
252     _;
253   }
254 
255   /**
256    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
257    * @param _tokenId uint256 ID of the token to validate
258    */
259   modifier canTransfer(uint256 _tokenId) {
260     require(isApprovedOrOwner(msg.sender, _tokenId));
261     _;
262   }
263 
264   /**
265    * @dev Gets the balance of the specified address
266    * @param _owner address to query the balance of
267    * @return uint256 representing the amount owned by the passed address
268    */
269   function balanceOf(address _owner) public view returns (uint256) {
270     require(_owner != address(0));
271     return ownedTokensCount[_owner];
272   }
273 
274   /**
275    * @dev Gets the owner of the specified token ID
276    * @param _tokenId uint256 ID of the token to query the owner of
277    * @return owner address currently marked as the owner of the given token ID
278    */
279   function ownerOf(uint256 _tokenId) public view returns (address) {
280     address owner = tokenOwner[_tokenId];
281     require(owner != address(0));
282     return owner;
283   }
284 
285   /**
286    * @dev Returns whether the specified token exists
287    * @param _tokenId uint256 ID of the token to query the existance of
288    * @return whether the token exists
289    */
290   function exists(uint256 _tokenId) public view returns (bool) {
291     address owner = tokenOwner[_tokenId];
292     return owner != address(0);
293   }
294 
295   /**
296    * @dev Approves another address to transfer the given token ID
297    * @dev The zero address indicates there is no approved address.
298    * @dev There can only be one approved address per token at a given time.
299    * @dev Can only be called by the token owner or an approved operator.
300    * @param _to address to be approved for the given token ID
301    * @param _tokenId uint256 ID of the token to be approved
302    */
303   function approve(address _to, uint256 _tokenId) public {
304     address owner = ownerOf(_tokenId);
305     require(_to != owner);
306     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
307 
308     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
309       tokenApprovals[_tokenId] = _to;
310       emit Approval(owner, _to, _tokenId);
311     }
312   }
313 
314   /**
315    * @dev Gets the approved address for a token ID, or zero if no address set
316    * @param _tokenId uint256 ID of the token to query the approval of
317    * @return address currently approved for a the given token ID
318    */
319   function getApproved(uint256 _tokenId) public view returns (address) {
320     return tokenApprovals[_tokenId];
321   }
322 
323   /**
324    * @dev Sets or unsets the approval of a given operator
325    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
326    * @param _to operator address to set the approval
327    * @param _approved representing the status of the approval to be set
328    */
329   function setApprovalForAll(address _to, bool _approved) public {
330     require(_to != msg.sender);
331     operatorApprovals[msg.sender][_to] = _approved;
332     emit ApprovalForAll(msg.sender, _to, _approved);
333   }
334 
335   /**
336    * @dev Tells whether an operator is approved by a given owner
337    * @param _owner owner address which you want to query the approval of
338    * @param _operator operator address which you want to query the approval of
339    * @return bool whether the given operator is approved by the given owner
340    */
341   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
342     return operatorApprovals[_owner][_operator];
343   }
344 
345   /**
346    * @dev Transfers the ownership of a given token ID to another address
347    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
348    * @dev Requires the msg sender to be the owner, approved, or operator
349    * @param _from current owner of the token
350    * @param _to address to receive the ownership of the given token ID
351    * @param _tokenId uint256 ID of the token to be transferred
352   */
353   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
354     require(_from != address(0));
355     require(_to != address(0));
356 
357     clearApproval(_from, _tokenId);
358     removeTokenFrom(_from, _tokenId);
359     addTokenTo(_to, _tokenId);
360 
361     emit Transfer(_from, _to, _tokenId);
362   }
363 
364   /**
365    * @dev Safely transfers the ownership of a given token ID to another address
366    * @dev If the target address is a contract, it must implement `onERC721Received`,
367    *  which is called upon a safe transfer, and return the magic value
368    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
369    *  the transfer is reverted.
370    * @dev Requires the msg sender to be the owner, approved, or operator
371    * @param _from current owner of the token
372    * @param _to address to receive the ownership of the given token ID
373    * @param _tokenId uint256 ID of the token to be transferred
374   */
375   function safeTransferFrom(
376     address _from,
377     address _to,
378     uint256 _tokenId
379   )
380     public
381     canTransfer(_tokenId)
382   {
383     // solium-disable-next-line arg-overflow
384     safeTransferFrom(_from, _to, _tokenId, "");
385   }
386 
387   /**
388    * @dev Safely transfers the ownership of a given token ID to another address
389    * @dev If the target address is a contract, it must implement `onERC721Received`,
390    *  which is called upon a safe transfer, and return the magic value
391    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
392    *  the transfer is reverted.
393    * @dev Requires the msg sender to be the owner, approved, or operator
394    * @param _from current owner of the token
395    * @param _to address to receive the ownership of the given token ID
396    * @param _tokenId uint256 ID of the token to be transferred
397    * @param _data bytes data to send along with a safe transfer check
398    */
399   function safeTransferFrom(
400     address _from,
401     address _to,
402     uint256 _tokenId,
403     bytes _data
404   )
405     public
406     canTransfer(_tokenId)
407   {
408     transferFrom(_from, _to, _tokenId);
409     // solium-disable-next-line arg-overflow
410     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
411   }
412 
413   /**
414    * @dev Returns whether the given spender can transfer a given token ID
415    * @param _spender address of the spender to query
416    * @param _tokenId uint256 ID of the token to be transferred
417    * @return bool whether the msg.sender is approved for the given token ID,
418    *  is an operator of the owner, or is the owner of the token
419    */
420   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
421     address owner = ownerOf(_tokenId);
422     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
423   }
424 
425   /**
426    * @dev Internal function to mint a new token
427    * @dev Reverts if the given token ID already exists
428    * @param _to The address that will own the minted token
429    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
430    */
431   function _mint(address _to, uint256 _tokenId) internal {
432     require(_to != address(0));
433     addTokenTo(_to, _tokenId);
434     emit Transfer(address(0), _to, _tokenId);
435   }
436 
437   /**
438    * @dev Internal function to burn a specific token
439    * @dev Reverts if the token does not exist
440    * @param _tokenId uint256 ID of the token being burned by the msg.sender
441    */
442   function _burn(address _owner, uint256 _tokenId) internal {
443     clearApproval(_owner, _tokenId);
444     removeTokenFrom(_owner, _tokenId);
445     emit Transfer(_owner, address(0), _tokenId);
446   }
447 
448   /**
449    * @dev Internal function to clear current approval of a given token ID
450    * @dev Reverts if the given address is not indeed the owner of the token
451    * @param _owner owner of the token
452    * @param _tokenId uint256 ID of the token to be transferred
453    */
454   function clearApproval(address _owner, uint256 _tokenId) internal {
455     require(ownerOf(_tokenId) == _owner);
456     if (tokenApprovals[_tokenId] != address(0)) {
457       tokenApprovals[_tokenId] = address(0);
458       emit Approval(_owner, address(0), _tokenId);
459     }
460   }
461 
462   /**
463    * @dev Internal function to add a token ID to the list of a given address
464    * @param _to address representing the new owner of the given token ID
465    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
466    */
467   function addTokenTo(address _to, uint256 _tokenId) internal {
468     require(tokenOwner[_tokenId] == address(0));
469     tokenOwner[_tokenId] = _to;
470     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
471   }
472 
473   /**
474    * @dev Internal function to remove a token ID from the list of a given address
475    * @param _from address representing the previous owner of the given token ID
476    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
477    */
478   function removeTokenFrom(address _from, uint256 _tokenId) internal {
479     require(ownerOf(_tokenId) == _from);
480     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
481     tokenOwner[_tokenId] = address(0);
482   }
483 
484   /**
485    * @dev Internal function to invoke `onERC721Received` on a target address
486    * @dev The call is not executed if the target address is not a contract
487    * @param _from address representing the previous owner of the given token ID
488    * @param _to target address that will receive the tokens
489    * @param _tokenId uint256 ID of the token to be transferred
490    * @param _data bytes optional data to send along with the call
491    * @return whether the call correctly returned the expected magic value
492    */
493   function checkAndCallSafeTransfer(
494     address _from,
495     address _to,
496     uint256 _tokenId,
497     bytes _data
498   )
499     internal
500     returns (bool)
501   {
502     if (!_to.isContract()) {
503       return true;
504     }
505     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
506     return (retval == ERC721_RECEIVED);
507   }
508 }
509 
510 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Token.sol
511 
512 /**
513  * @title Full ERC721 Token
514  * This implementation includes all the required and some optional functionality of the ERC721 standard
515  * Moreover, it includes approve all functionality using operator terminology
516  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
517  */
518 contract ERC721Token is ERC721, ERC721BasicToken {
519   // Token name
520   string internal name_;
521 
522   // Token symbol
523   string internal symbol_;
524 
525   // Mapping from owner to list of owned token IDs
526   mapping (address => uint256[]) internal ownedTokens;
527 
528   // Mapping from token ID to index of the owner tokens list
529   mapping(uint256 => uint256) internal ownedTokensIndex;
530 
531   // Array with all token ids, used for enumeration
532   uint256[] internal allTokens;
533 
534   // Mapping from token id to position in the allTokens array
535   mapping(uint256 => uint256) internal allTokensIndex;
536 
537   // Optional mapping for token URIs
538   mapping(uint256 => string) internal tokenURIs;
539 
540   /**
541    * @dev Constructor function
542    */
543   function ERC721Token(string _name, string _symbol) public {
544     name_ = _name;
545     symbol_ = _symbol;
546   }
547 
548   /**
549    * @dev Gets the token name
550    * @return string representing the token name
551    */
552   function name() public view returns (string) {
553     return name_;
554   }
555 
556   /**
557    * @dev Gets the token symbol
558    * @return string representing the token symbol
559    */
560   function symbol() public view returns (string) {
561     return symbol_;
562   }
563 
564   /**
565    * @dev Returns an URI for a given token ID
566    * @dev Throws if the token ID does not exist. May return an empty string.
567    * @param _tokenId uint256 ID of the token to query
568    */
569   function tokenURI(uint256 _tokenId) public view returns (string) {
570     require(exists(_tokenId));
571     return tokenURIs[_tokenId];
572   }
573 
574   /**
575    * @dev Gets the token ID at a given index of the tokens list of the requested owner
576    * @param _owner address owning the tokens list to be accessed
577    * @param _index uint256 representing the index to be accessed of the requested tokens list
578    * @return uint256 token ID at the given index of the tokens list owned by the requested address
579    */
580   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
581     require(_index < balanceOf(_owner));
582     return ownedTokens[_owner][_index];
583   }
584 
585   /**
586    * @dev Gets the total amount of tokens stored by the contract
587    * @return uint256 representing the total amount of tokens
588    */
589   function totalSupply() public view returns (uint256) {
590     return allTokens.length;
591   }
592 
593   /**
594    * @dev Gets the token ID at a given index of all the tokens in this contract
595    * @dev Reverts if the index is greater or equal to the total number of tokens
596    * @param _index uint256 representing the index to be accessed of the tokens list
597    * @return uint256 token ID at the given index of the tokens list
598    */
599   function tokenByIndex(uint256 _index) public view returns (uint256) {
600     require(_index < totalSupply());
601     return allTokens[_index];
602   }
603 
604   /**
605    * @dev Internal function to set the token URI for a given token
606    * @dev Reverts if the token ID does not exist
607    * @param _tokenId uint256 ID of the token to set its URI
608    * @param _uri string URI to assign
609    */
610   function _setTokenURI(uint256 _tokenId, string _uri) internal {
611     require(exists(_tokenId));
612     tokenURIs[_tokenId] = _uri;
613   }
614 
615   /**
616    * @dev Internal function to add a token ID to the list of a given address
617    * @param _to address representing the new owner of the given token ID
618    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
619    */
620   function addTokenTo(address _to, uint256 _tokenId) internal {
621     super.addTokenTo(_to, _tokenId);
622     uint256 length = ownedTokens[_to].length;
623     ownedTokens[_to].push(_tokenId);
624     ownedTokensIndex[_tokenId] = length;
625   }
626 
627   /**
628    * @dev Internal function to remove a token ID from the list of a given address
629    * @param _from address representing the previous owner of the given token ID
630    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
631    */
632   function removeTokenFrom(address _from, uint256 _tokenId) internal {
633     super.removeTokenFrom(_from, _tokenId);
634 
635     uint256 tokenIndex = ownedTokensIndex[_tokenId];
636     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
637     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
638 
639     ownedTokens[_from][tokenIndex] = lastToken;
640     ownedTokens[_from][lastTokenIndex] = 0;
641     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
642     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
643     // the lastToken to the first position, and then dropping the element placed in the last position of the list
644 
645     ownedTokens[_from].length--;
646     ownedTokensIndex[_tokenId] = 0;
647     ownedTokensIndex[lastToken] = tokenIndex;
648   }
649 
650   /**
651    * @dev Internal function to mint a new token
652    * @dev Reverts if the given token ID already exists
653    * @param _to address the beneficiary that will own the minted token
654    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
655    */
656   function _mint(address _to, uint256 _tokenId) internal {
657     super._mint(_to, _tokenId);
658 
659     allTokensIndex[_tokenId] = allTokens.length;
660     allTokens.push(_tokenId);
661   }
662 
663   /**
664    * @dev Internal function to burn a specific token
665    * @dev Reverts if the token does not exist
666    * @param _owner owner of the token to burn
667    * @param _tokenId uint256 ID of the token being burned by the msg.sender
668    */
669   function _burn(address _owner, uint256 _tokenId) internal {
670     super._burn(_owner, _tokenId);
671 
672     // Clear metadata (if any)
673     if (bytes(tokenURIs[_tokenId]).length != 0) {
674       delete tokenURIs[_tokenId];
675     }
676 
677     // Reorg all tokens array
678     uint256 tokenIndex = allTokensIndex[_tokenId];
679     uint256 lastTokenIndex = allTokens.length.sub(1);
680     uint256 lastToken = allTokens[lastTokenIndex];
681 
682     allTokens[tokenIndex] = lastToken;
683     allTokens[lastTokenIndex] = 0;
684 
685     allTokens.length--;
686     allTokensIndex[_tokenId] = 0;
687     allTokensIndex[lastToken] = tokenIndex;
688   }
689 
690 }
691 
692 // File: contracts\Integers.sol
693 
694 /**
695  * Integers Library
696  *
697  * In summary this is a simple library of integer functions which allow a simple
698  * conversion to and from strings
699  *
700  * @author James Lockhart <james@n3tw0rk.co.uk>
701  */
702 library Integers {
703     /**
704      * Parse Int
705      *
706      * Converts an ASCII string value into an uint as long as the string
707      * its self is a valid unsigned integer
708      *
709      * @param _value The ASCII string to be converted to an unsigned integer
710      * @return uint The unsigned value of the ASCII string
711      */
712     function parseInt(string _value)
713         public
714         returns (uint _ret) {
715         bytes memory _bytesValue = bytes(_value);
716         uint j = 1;
717         for(uint i = _bytesValue.length-1; i >= 0 && i < _bytesValue.length; i--) {
718             assert(_bytesValue[i] >= 48 && _bytesValue[i] <= 57);
719             _ret += (uint(_bytesValue[i]) - 48)*j;
720             j*=10;
721         }
722     }
723 
724     /**
725      * To String
726      *
727      * Converts an unsigned integer to the ASCII string equivalent value
728      *
729      * @param _base The unsigned integer to be converted to a string
730      * @return string The resulting ASCII string value
731      */
732     function toString(uint _base)
733         internal
734         returns (string) {
735 
736         if  (_base==0){
737             return "0";
738         }
739 
740         bytes memory _tmp = new bytes(32);
741         uint i;
742         for(i = 0;_base > 0;i++) {
743             _tmp[i] = byte((_base % 10) + 48);
744             _base /= 10;
745         }
746         bytes memory _real = new bytes(i--);
747         for(uint j = 0; j < _real.length; j++) {
748             _real[j] = _tmp[i--];
749         }
750         return string(_real);
751     }
752 
753     /**
754      * To Byte
755      *
756      * Convert an 8 bit unsigned integer to a byte
757      *
758      * @param _base The 8 bit unsigned integer
759      * @return byte The byte equivalent
760      */
761     function toByte(uint8 _base)
762         public
763         returns (byte _ret) {
764         assembly {
765             let m_alloc := add(msize(),0x1)
766             mstore8(m_alloc, _base)
767             _ret := mload(m_alloc)
768         }
769     }
770 
771     /**
772      * To Bytes
773      *
774      * Converts an unsigned integer to bytes
775      *
776      * @param _base The integer to be converted to bytes
777      * @return bytes The bytes equivalent
778      */
779     function toBytes(uint _base)
780         internal
781         returns (bytes _ret) {
782         assembly {
783             let m_alloc := add(msize(),0x1)
784             _ret := mload(m_alloc)
785             mstore(_ret, 0x20)
786             mstore(add(_ret, 0x20), _base)
787         }
788     }
789 }
790 
791 // File: contracts\Strings.sol
792 
793 /**
794  * Strings Library
795  *
796  * In summary this is a simple library of string functions which make simple
797  * string operations less tedious in solidity.
798  *
799  * Please be aware these functions can be quite gas heavy so use them only when
800  * necessary not to clog the blockchain with expensive transactions.
801  *
802  * @author James Lockhart <james@n3tw0rk.co.uk>
803  */
804 library Strings {
805 
806     /**
807      * Concat (High gas cost)
808      *
809      * Appends two strings together and returns a new value
810      *
811      * @param _base When being used for a data type this is the extended object
812      *              otherwise this is the string which will be the concatenated
813      *              prefix
814      * @param _value The value to be the concatenated suffix
815      * @return string The resulting string from combinging the base and value
816      */
817     function concat(string _base, string _value)
818         internal
819         returns (string) {
820         bytes memory _baseBytes = bytes(_base);
821         bytes memory _valueBytes = bytes(_value);
822 
823         assert(_valueBytes.length > 0);
824 
825         string memory _tmpValue = new string(_baseBytes.length +
826             _valueBytes.length);
827         bytes memory _newValue = bytes(_tmpValue);
828 
829         uint i;
830         uint j;
831 
832         for(i = 0; i < _baseBytes.length; i++) {
833             _newValue[j++] = _baseBytes[i];
834         }
835 
836         for(i = 0; i<_valueBytes.length; i++) {
837             _newValue[j++] = _valueBytes[i];
838         }
839 
840         return string(_newValue);
841     }
842 
843     /**
844      * Index Of
845      *
846      * Locates and returns the position of a character within a string
847      *
848      * @param _base When being used for a data type this is the extended object
849      *              otherwise this is the string acting as the haystack to be
850      *              searched
851      * @param _value The needle to search for, at present this is currently
852      *               limited to one character
853      * @return int The position of the needle starting from 0 and returning -1
854      *             in the case of no matches found
855      */
856     function indexOf(string _base, string _value)
857         internal
858         returns (int) {
859         return _indexOf(_base, _value, 0);
860     }
861 
862     /**
863      * Index Of
864      *
865      * Locates and returns the position of a character within a string starting
866      * from a defined offset
867      *
868      * @param _base When being used for a data type this is the extended object
869      *              otherwise this is the string acting as the haystack to be
870      *              searched
871      * @param _value The needle to search for, at present this is currently
872      *               limited to one character
873      * @param _offset The starting point to start searching from which can start
874      *                from 0, but must not exceed the length of the string
875      * @return int The position of the needle starting from 0 and returning -1
876      *             in the case of no matches found
877      */
878     function _indexOf(string _base, string _value, uint _offset)
879         internal
880         returns (int) {
881         bytes memory _baseBytes = bytes(_base);
882         bytes memory _valueBytes = bytes(_value);
883 
884         assert(_valueBytes.length == 1);
885 
886         for(uint i = _offset; i < _baseBytes.length; i++) {
887             if (_baseBytes[i] == _valueBytes[0]) {
888                 return int(i);
889             }
890         }
891 
892         return -1;
893     }
894 
895     /**
896      * Length
897      *
898      * Returns the length of the specified string
899      *
900      * @param _base When being used for a data type this is the extended object
901      *              otherwise this is the string to be measured
902      * @return uint The length of the passed string
903      */
904     function length(string _base)
905         internal
906         returns (uint) {
907         bytes memory _baseBytes = bytes(_base);
908         return _baseBytes.length;
909     }
910 
911     /**
912      * Sub String
913      *
914      * Extracts the beginning part of a string based on the desired length
915      *
916      * @param _base When being used for a data type this is the extended object
917      *              otherwise this is the string that will be used for
918      *              extracting the sub string from
919      * @param _length The length of the sub string to be extracted from the base
920      * @return string The extracted sub string
921      */
922     function substring(string _base, int _length)
923         internal
924         returns (string) {
925         return _substring(_base, _length, 0);
926     }
927 
928     /**
929      * Sub String
930      *
931      * Extracts the part of a string based on the desired length and offset. The
932      * offset and length must not exceed the lenth of the base string.
933      *
934      * @param _base When being used for a data type this is the extended object
935      *              otherwise this is the string that will be used for
936      *              extracting the sub string from
937      * @param _length The length of the sub string to be extracted from the base
938      * @param _offset The starting point to extract the sub string from
939      * @return string The extracted sub string
940      */
941     function _substring(string _base, int _length, int _offset)
942         internal
943         returns (string) {
944         bytes memory _baseBytes = bytes(_base);
945 
946         assert(uint(_offset+_length) <= _baseBytes.length);
947 
948         string memory _tmp = new string(uint(_length));
949         bytes memory _tmpBytes = bytes(_tmp);
950 
951         uint j = 0;
952         for(uint i = uint(_offset); i < uint(_offset+_length); i++) {
953           _tmpBytes[j++] = _baseBytes[i];
954         }
955 
956         return string(_tmpBytes);
957     }
958 
959     /**
960      * String Split (Very high gas cost)
961      *
962      * Splits a string into an array of strings based off the delimiter value.
963      * Please note this can be quite a gas expensive function due to the use of
964      * storage so only use if really required.
965      *
966      * @param _base When being used for a data type this is the extended object
967      *               otherwise this is the string value to be split.
968      * @param _value The delimiter to split the string on which must be a single
969      *               character
970      * @return string[] An array of values split based off the delimiter, but
971      *                  do not container the delimiter.
972      */
973     function split(string _base, string _value)
974         internal
975         returns (string[] storage splitArr) {
976         bytes memory _baseBytes = bytes(_base);
977         uint _offset = 0;
978 
979         while(_offset < _baseBytes.length-1) {
980 
981             int _limit = _indexOf(_base, _value, _offset);
982             if (_limit == -1) {
983                 _limit = int(_baseBytes.length);
984             }
985 
986             string memory _tmp = new string(uint(_limit)-_offset);
987             bytes memory _tmpBytes = bytes(_tmp);
988 
989             uint j = 0;
990             for(uint i = _offset; i < uint(_limit); i++) {
991                 _tmpBytes[j++] = _baseBytes[i];
992             }
993             _offset = uint(_limit) + 1;
994             splitArr.push(string(_tmpBytes));
995         }
996         return splitArr;
997     }
998 
999     /**
1000      * Compare To
1001      *
1002      * Compares the characters of two strings, to ensure that they have an
1003      * identical footprint
1004      *
1005      * @param _base When being used for a data type this is the extended object
1006      *               otherwise this is the string base to compare against
1007      * @param _value The string the base is being compared to
1008      * @return bool Simply notates if the two string have an equivalent
1009      */
1010     function compareTo(string _base, string _value)
1011         internal
1012         returns (bool) {
1013         bytes memory _baseBytes = bytes(_base);
1014         bytes memory _valueBytes = bytes(_value);
1015 
1016         if (_baseBytes.length != _valueBytes.length) {
1017             return false;
1018         }
1019 
1020         for(uint i = 0; i < _baseBytes.length; i++) {
1021             if (_baseBytes[i] != _valueBytes[i]) {
1022                 return false;
1023             }
1024         }
1025 
1026         return true;
1027     }
1028 
1029     /**
1030      * Compare To Ignore Case (High gas cost)
1031      *
1032      * Compares the characters of two strings, converting them to the same case
1033      * where applicable to alphabetic characters to distinguish if the values
1034      * match.
1035      *
1036      * @param _base When being used for a data type this is the extended object
1037      *               otherwise this is the string base to compare against
1038      * @param _value The string the base is being compared to
1039      * @return bool Simply notates if the two string have an equivalent value
1040      *              discarding case
1041      */
1042     function compareToIgnoreCase(string _base, string _value)
1043         internal
1044         returns (bool) {
1045         bytes memory _baseBytes = bytes(_base);
1046         bytes memory _valueBytes = bytes(_value);
1047 
1048         if (_baseBytes.length != _valueBytes.length) {
1049             return false;
1050         }
1051 
1052         for(uint i = 0; i < _baseBytes.length; i++) {
1053             if (_baseBytes[i] != _valueBytes[i] &&
1054                 _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
1055                 return false;
1056             }
1057         }
1058 
1059         return true;
1060     }
1061 
1062     /**
1063      * Upper
1064      *
1065      * Converts all the values of a string to their corresponding upper case
1066      * value.
1067      *
1068      * @param _base When being used for a data type this is the extended object
1069      *              otherwise this is the string base to convert to upper case
1070      * @return string
1071      */
1072     function upper(string _base)
1073         internal
1074         returns (string) {
1075         bytes memory _baseBytes = bytes(_base);
1076         for (uint i = 0; i < _baseBytes.length; i++) {
1077             _baseBytes[i] = _upper(_baseBytes[i]);
1078         }
1079         return string(_baseBytes);
1080     }
1081 
1082     /**
1083      * Lower
1084      *
1085      * Converts all the values of a string to their corresponding lower case
1086      * value.
1087      *
1088      * @param _base When being used for a data type this is the extended object
1089      *              otherwise this is the string base to convert to lower case
1090      * @return string
1091      */
1092     function lower(string _base)
1093         internal
1094         returns (string) {
1095         bytes memory _baseBytes = bytes(_base);
1096         for (uint i = 0; i < _baseBytes.length; i++) {
1097             _baseBytes[i] = _lower(_baseBytes[i]);
1098         }
1099         return string(_baseBytes);
1100     }
1101 
1102     /**
1103      * Upper
1104      *
1105      * Convert an alphabetic character to upper case and return the original
1106      * value when not alphabetic
1107      *
1108      * @param _b1 The byte to be converted to upper case
1109      * @return bytes1 The converted value if the passed value was alphabetic
1110      *                and in a lower case otherwise returns the original value
1111      */
1112     function _upper(bytes1 _b1)
1113         private
1114         constant
1115         returns (bytes1) {
1116 
1117         if (_b1 >= 0x61 && _b1 <= 0x7A) {
1118             return bytes1(uint8(_b1)-32);
1119         }
1120 
1121         return _b1;
1122     }
1123 
1124     /**
1125      * Lower
1126      *
1127      * Convert an alphabetic character to lower case and return the original
1128      * value when not alphabetic
1129      *
1130      * @param _b1 The byte to be converted to lower case
1131      * @return bytes1 The converted value if the passed value was alphabetic
1132      *                and in a upper case otherwise returns the original value
1133      */
1134     function _lower(bytes1 _b1)
1135         private
1136         constant
1137         returns (bytes1) {
1138 
1139         if (_b1 >= 0x41 && _b1 <= 0x5A) {
1140             return bytes1(uint8(_b1)+32);
1141         }
1142 
1143         return _b1;
1144     }
1145 }
1146 
1147 // File: contracts\DigitalArtChain.sol
1148 
1149 contract DigitalArtChain is Ownable, ERC721Token, ERC721Holder {
1150     using Strings for string;
1151     using Integers for uint;
1152 
1153     function DigitalArtChain () ERC721Token("DigitalArtChain" ,"DAC") public {
1154 
1155     }
1156 
1157     struct DigitalArt {
1158         string ipfsHash;
1159         address publisher;
1160     }
1161 
1162     DigitalArt[] public digitalArts;
1163     mapping (string => uint256) ipfsHashToTokenId;
1164 
1165     mapping (address => uint256) internal publishedTokensCount;
1166     mapping (address => uint256[]) internal publishedTokens;
1167 
1168     mapping(address => mapping (uint256 => uint256)) internal publishedTokensIndex;
1169 
1170 
1171     struct SellingItem {
1172         address seller;
1173         uint128 price;
1174     }
1175 
1176     mapping (uint256 => SellingItem) public tokenIdToSellingItem;
1177 
1178     uint128 public createDigitalArtFee = 0.00198 ether;
1179     uint128 public publisherCut = 500;
1180     string preUri1 = "http://api.digitalartchain.com/tokens?tokenId=";
1181     string preUri2 = "&ipfsHash=";
1182 
1183     /*** Modifier ***/
1184     modifier onlyOwner() {
1185         require(msg.sender == owner);
1186         _;
1187     }
1188 
1189     /*** Owner Action ***/
1190     function withdraw() public onlyOwner {
1191         owner.transfer(this.balance);
1192     }
1193 
1194     function setCreateDigitalArtFee(uint128 _fee) public onlyOwner {
1195         createDigitalArtFee = _fee;
1196     }
1197 
1198     function setPublisherCut(uint128 _cut) public onlyOwner {
1199         require(_cut > 0 && _cut < 10000);
1200         publisherCut = _cut;
1201     }
1202 
1203     function setPreUri1(string _preUri) public onlyOwner {
1204         preUri1 = _preUri;
1205     }
1206 
1207     function setPreUri2(string _preUri) public onlyOwner {
1208         preUri2 = _preUri;
1209     }
1210 
1211     function getIpfsHashToTokenId(string _string) public view returns (uint256){
1212         return ipfsHashToTokenId[_string];
1213     }
1214 
1215     function getOwnedTokens(address _owner) public view returns (uint256[]) {
1216         return ownedTokens[_owner];
1217     }
1218 
1219     function getAllTokens() public view returns (uint256[]) {
1220         return allTokens;
1221     }
1222 
1223     function publishedCountOf(address _publisher) public view returns (uint256) {
1224         return publishedTokensCount[_publisher];
1225     }
1226 
1227     function publishedTokenOfOwnerByIndex(address _publisher, uint256 _index) public view returns (uint256) {
1228         require(_index < publishedCountOf(_publisher));
1229         return publishedTokens[_publisher][_index];
1230     }
1231 
1232     function getPublishedTokens(address _publisher) public view returns (uint256[]) {
1233         return publishedTokens[_publisher];
1234     }
1235 
1236     function mintDigitalArt(string _ipfsHash) public payable {
1237         require(msg.value == createDigitalArtFee);
1238         require(ipfsHashToTokenId[_ipfsHash] == 0);
1239 
1240         DigitalArt memory _digitalArt = DigitalArt({ipfsHash: _ipfsHash, publisher: msg.sender});
1241         uint256 newDigitalArtId = digitalArts.push(_digitalArt) - 1;
1242         ipfsHashToTokenId[_ipfsHash] = newDigitalArtId;
1243         _mint(msg.sender, newDigitalArtId);
1244 
1245         publishedTokensCount[msg.sender]++;
1246         uint256 length = publishedTokens[msg.sender].length;
1247         publishedTokens[msg.sender].push(newDigitalArtId);
1248         publishedTokensIndex[msg.sender][newDigitalArtId] = length;
1249     }
1250 
1251     function tokenURI(uint256 _tokenId) public view returns (string) {
1252         require(exists(_tokenId));
1253         return preUri1.concat(_tokenId.toString()).concat(preUri2).concat(digitalArts[_tokenId].ipfsHash);
1254     }
1255 
1256     function addDigitalArtSellingItem(uint256 _tokenId, uint128 _price) public onlyOwnerOf(_tokenId) {
1257         require(tokenIdToSellingItem[_tokenId].seller == address(0));
1258         SellingItem memory _sellingItem = SellingItem(msg.sender, uint128(_price));
1259         tokenIdToSellingItem[_tokenId] = _sellingItem;
1260         approve(address(this), _tokenId);
1261         safeTransferFrom(msg.sender, address(this), _tokenId);
1262     }
1263 
1264     function cancelDigitalArtSellingItem(uint256 _tokenId) public {
1265         require(tokenIdToSellingItem[_tokenId].seller == msg.sender);
1266         this.safeTransferFrom(address(this), tokenIdToSellingItem[_tokenId].seller, _tokenId);
1267         delete tokenIdToSellingItem[_tokenId];
1268     }
1269 
1270     function purchaseDigitalArtSellingItem(uint256 _tokenId) public payable {
1271         require(tokenIdToSellingItem[_tokenId].seller != address(0));
1272         require(tokenIdToSellingItem[_tokenId].seller != msg.sender);
1273         require(tokenIdToSellingItem[_tokenId].price == msg.value);
1274 
1275         SellingItem memory sellingItem = tokenIdToSellingItem[_tokenId];
1276 
1277         if (sellingItem.price > 0) {
1278             uint128 actualPublisherCut = _computePublisherCut(sellingItem.price);
1279             uint128 proceeds = sellingItem.price - actualPublisherCut;
1280             sellingItem.seller.transfer(proceeds);
1281             digitalArts[_tokenId].publisher.transfer(actualPublisherCut);
1282         }
1283 
1284         delete tokenIdToSellingItem[_tokenId];
1285         this.safeTransferFrom(address(this), msg.sender, _tokenId);
1286     }
1287 
1288     /*** Tools ***/
1289     function _computePublisherCut(uint128 _price) internal view returns (uint128) {
1290         return _price * publisherCut / 10000;
1291     }
1292 
1293 }