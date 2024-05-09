1 pragma solidity ^0.4.23;
2 
3 
4 
5 /**
6  * Utility library of inline functions on addresses
7  */
8 library AddressUtils {
9 
10   /**
11    * Returns whether the target address is a contract
12    * @dev This function will return false if invoked during the constructor of a contract,
13    *  as the code is not actually created until after the constructor finishes.
14    * @param addr address to check
15    * @return whether the target address is a contract
16    */
17   function isContract(address addr) internal view returns (bool) {
18     uint256 size;
19     // XXX Currently there is no better way to check if there is a contract in an address
20     // than to check the size of the code at that address.
21     // See https://ethereum.stackexchange.com/a/14016/36603
22     // for more details about how this works.
23     // TODO Check this again before the Serenity release, because all addresses will be
24     // contracts then.
25     // solium-disable-next-line security/no-inline-assembly
26     assembly { size := extcodesize(addr) }
27     return size > 0;
28   }
29 
30 }
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() public {
76     owner = msg.sender;
77   }
78 
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) onlyOwner public {
94     require(newOwner != address(0));
95     emit OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 
99 }
100 
101 
102 /**
103  * @title ERC721 token receiver interface
104  * @dev Interface for any contract that wants to support safeTransfers
105  *  from ERC721 asset contracts.
106  */
107 contract ERC721Receiver {
108   /**
109    * @dev Magic value to be returned upon successful reception of an NFT
110    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
111    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
112    */
113   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
114 
115   /**
116    * @notice Handle the receipt of an NFT
117    * @dev The ERC721 smart contract calls this function on the recipient
118    *  after a `safetransfer`. This function MAY throw to revert and reject the
119    *  transfer. This function MUST use 50,000 gas or less. Return of other
120    *  than the magic value MUST result in the transaction being reverted.
121    *  Note: the contract address is always the message sender.
122    * @param _from The sending address
123    * @param _tokenId The NFT identifier which is being transfered
124    * @param _data Additional data with no specified format
125    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
126    */
127   function onERC721Received(
128     address _from,
129     uint256 _tokenId,
130     bytes _data
131   )
132     public
133     returns(bytes4);
134 }
135 /**
136  * @title ERC721 Non-Fungible Token Standard basic interface
137  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
138  */
139 contract ERC721Basic {
140   event Transfer(
141     address indexed _from,
142     address indexed _to,
143     uint256 _tokenId
144   );
145   event Approval(
146     address indexed _owner,
147     address indexed _approved,
148     uint256 _tokenId
149   );
150   event ApprovalForAll(
151     address indexed _owner,
152     address indexed _operator,
153     bool _approved
154   );
155 
156   function balanceOf(address _owner) public view returns (uint256 _balance);
157   function ownerOf(uint256 _tokenId) public view returns (address _owner);
158   function exists(uint256 _tokenId) public view returns (bool _exists);
159 
160   function approve(address _to, uint256 _tokenId) public;
161   function getApproved(uint256 _tokenId)
162     public view returns (address _operator);
163 
164   function setApprovalForAll(address _operator, bool _approved) public;
165   function isApprovedForAll(address _owner, address _operator)
166     public view returns (bool);
167 
168   function transferFrom(address _from, address _to, uint256 _tokenId) public;
169   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
170     public;
171 
172   function safeTransferFrom(
173     address _from,
174     address _to,
175     uint256 _tokenId,
176     bytes _data
177   )
178     public;
179 }
180 
181 /**
182  * @title ERC721 Non-Fungible Token Standard basic implementation
183  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
184  */
185 contract ERC721BasicToken is ERC721Basic {
186   using SafeMath for uint256;
187   using AddressUtils for address;
188 
189   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
190   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
191   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
192 
193   // Mapping from token ID to owner
194   mapping (uint256 => address) internal tokenOwner;
195 
196   // Mapping from token ID to approved address
197   mapping (uint256 => address) internal tokenApprovals;
198 
199   // Mapping from owner to number of owned token
200   mapping (address => uint256) internal ownedTokensCount;
201 
202   // Mapping from owner to operator approvals
203   mapping (address => mapping (address => bool)) internal operatorApprovals;
204 
205   /**
206    * @dev Guarantees msg.sender is owner of the given token
207    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
208    */
209   modifier onlyOwnerOf(uint256 _tokenId) {
210     require(ownerOf(_tokenId) == msg.sender);
211     _;
212   }
213 
214   /**
215    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
216    * @param _tokenId uint256 ID of the token to validate
217    */
218   modifier canTransfer(uint256 _tokenId) {
219     require(isApprovedOrOwner(msg.sender, _tokenId));
220     _;
221   }
222 
223   /**
224    * @dev Gets the balance of the specified address
225    * @param _owner address to query the balance of
226    * @return uint256 representing the amount owned by the passed address
227    */
228   function balanceOf(address _owner) public view returns (uint256) {
229     require(_owner != address(0));
230     return ownedTokensCount[_owner];
231   }
232 
233   /**
234    * @dev Gets the owner of the specified token ID
235    * @param _tokenId uint256 ID of the token to query the owner of
236    * @return owner address currently marked as the owner of the given token ID
237    */
238   function ownerOf(uint256 _tokenId) public view returns (address) {
239     address owner = tokenOwner[_tokenId];
240     require(owner != address(0));
241     return owner;
242   }
243 
244   /**
245    * @dev Returns whether the specified token exists
246    * @param _tokenId uint256 ID of the token to query the existence of
247    * @return whether the token exists
248    */
249   function exists(uint256 _tokenId) public view returns (bool) {
250     address owner = tokenOwner[_tokenId];
251     return owner != address(0);
252   }
253 
254   /**
255    * @dev Approves another address to transfer the given token ID
256    * @dev The zero address indicates there is no approved address.
257    * @dev There can only be one approved address per token at a given time.
258    * @dev Can only be called by the token owner or an approved operator.
259    * @param _to address to be approved for the given token ID
260    * @param _tokenId uint256 ID of the token to be approved
261    */
262   function approve(address _to, uint256 _tokenId) public {
263     address owner = ownerOf(_tokenId);
264     require(_to != owner);
265     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
266 
267     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
268       tokenApprovals[_tokenId] = _to;
269       emit Approval(owner, _to, _tokenId);
270     }
271   }
272 
273   /**
274    * @dev Gets the approved address for a token ID, or zero if no address set
275    * @param _tokenId uint256 ID of the token to query the approval of
276    * @return address currently approved for the given token ID
277    */
278   function getApproved(uint256 _tokenId) public view returns (address) {
279     return tokenApprovals[_tokenId];
280   }
281 
282   /**
283    * @dev Sets or unsets the approval of a given operator
284    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
285    * @param _to operator address to set the approval
286    * @param _approved representing the status of the approval to be set
287    */
288   function setApprovalForAll(address _to, bool _approved) public {
289     require(_to != msg.sender);
290     operatorApprovals[msg.sender][_to] = _approved;
291     emit ApprovalForAll(msg.sender, _to, _approved);
292   }
293 
294   /**
295    * @dev Tells whether an operator is approved by a given owner
296    * @param _owner owner address which you want to query the approval of
297    * @param _operator operator address which you want to query the approval of
298    * @return bool whether the given operator is approved by the given owner
299    */
300   function isApprovedForAll(
301     address _owner,
302     address _operator
303   )
304     public
305     view
306     returns (bool)
307   {
308     return operatorApprovals[_owner][_operator];
309   }
310 
311   /**
312    * @dev Transfers the ownership of a given token ID to another address
313    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
314    * @dev Requires the msg sender to be the owner, approved, or operator
315    * @param _from current owner of the token
316    * @param _to address to receive the ownership of the given token ID
317    * @param _tokenId uint256 ID of the token to be transferred
318   */
319   function transferFrom(
320     address _from,
321     address _to,
322     uint256 _tokenId
323   )
324     public
325     canTransfer(_tokenId)
326   {
327     require(_from != address(0));
328     require(_to != address(0));
329 
330     clearApproval(_from, _tokenId);
331     removeTokenFrom(_from, _tokenId);
332     addTokenTo(_to, _tokenId);
333 
334     emit Transfer(_from, _to, _tokenId);
335   }
336 
337   /**
338    * @dev Safely transfers the ownership of a given token ID to another address
339    * @dev If the target address is a contract, it must implement `onERC721Received`,
340    *  which is called upon a safe transfer, and return the magic value
341    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
342    *  the transfer is reverted.
343    * @dev Requires the msg sender to be the owner, approved, or operator
344    * @param _from current owner of the token
345    * @param _to address to receive the ownership of the given token ID
346    * @param _tokenId uint256 ID of the token to be transferred
347   */
348   function safeTransferFrom(
349     address _from,
350     address _to,
351     uint256 _tokenId
352   )
353     public
354     canTransfer(_tokenId)
355   {
356     // solium-disable-next-line arg-overflow
357     safeTransferFrom(_from, _to, _tokenId, "");
358   }
359 
360   /**
361    * @dev Safely transfers the ownership of a given token ID to another address
362    * @dev If the target address is a contract, it must implement `onERC721Received`,
363    *  which is called upon a safe transfer, and return the magic value
364    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
365    *  the transfer is reverted.
366    * @dev Requires the msg sender to be the owner, approved, or operator
367    * @param _from current owner of the token
368    * @param _to address to receive the ownership of the given token ID
369    * @param _tokenId uint256 ID of the token to be transferred
370    * @param _data bytes data to send along with a safe transfer check
371    */
372   function safeTransferFrom(
373     address _from,
374     address _to,
375     uint256 _tokenId,
376     bytes _data
377   )
378     public
379     canTransfer(_tokenId)
380   {
381     transferFrom(_from, _to, _tokenId);
382     // solium-disable-next-line arg-overflow
383     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
384   }
385 
386   /**
387    * @dev Returns whether the given spender can transfer a given token ID
388    * @param _spender address of the spender to query
389    * @param _tokenId uint256 ID of the token to be transferred
390    * @return bool whether the msg.sender is approved for the given token ID,
391    *  is an operator of the owner, or is the owner of the token
392    */
393   function isApprovedOrOwner(
394     address _spender,
395     uint256 _tokenId
396   )
397     internal
398     view
399     returns (bool)
400   {
401     address owner = ownerOf(_tokenId);
402     // Disable solium check because of
403     // https://github.com/duaraghav8/Solium/issues/175
404     // solium-disable-next-line operator-whitespace
405     return (
406       _spender == owner ||
407       getApproved(_tokenId) == _spender ||
408       isApprovedForAll(owner, _spender)
409     );
410   }
411 
412   /**
413    * @dev Internal function to mint a new token
414    * @dev Reverts if the given token ID already exists
415    * @param _to The address that will own the minted token
416    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
417    */
418   function _mint(address _to, uint256 _tokenId) internal {
419     require(_to != address(0));
420     addTokenTo(_to, _tokenId);
421     emit Transfer(address(0), _to, _tokenId);
422   }
423 
424   /**
425    * @dev Internal function to burn a specific token
426    * @dev Reverts if the token does not exist
427    * @param _tokenId uint256 ID of the token being burned by the msg.sender
428    */
429   function _burn(address _owner, uint256 _tokenId) internal {
430     clearApproval(_owner, _tokenId);
431     removeTokenFrom(_owner, _tokenId);
432     emit Transfer(_owner, address(0), _tokenId);
433   }
434 
435   /**
436    * @dev Internal function to clear current approval of a given token ID
437    * @dev Reverts if the given address is not indeed the owner of the token
438    * @param _owner owner of the token
439    * @param _tokenId uint256 ID of the token to be transferred
440    */
441   function clearApproval(address _owner, uint256 _tokenId) internal {
442     require(ownerOf(_tokenId) == _owner);
443     if (tokenApprovals[_tokenId] != address(0)) {
444       tokenApprovals[_tokenId] = address(0);
445       emit Approval(_owner, address(0), _tokenId);
446     }
447   }
448 
449   /**
450    * @dev Internal function to add a token ID to the list of a given address
451    * @param _to address representing the new owner of the given token ID
452    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
453    */
454   function addTokenTo(address _to, uint256 _tokenId) internal {
455     require(tokenOwner[_tokenId] == address(0));
456     tokenOwner[_tokenId] = _to;
457     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
458   }
459 
460   /**
461    * @dev Internal function to remove a token ID from the list of a given address
462    * @param _from address representing the previous owner of the given token ID
463    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
464    */
465   function removeTokenFrom(address _from, uint256 _tokenId) internal {
466     require(ownerOf(_tokenId) == _from);
467     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
468     tokenOwner[_tokenId] = address(0);
469   }
470 
471   /**
472    * @dev Internal function to invoke `onERC721Received` on a target address
473    * @dev The call is not executed if the target address is not a contract
474    * @param _from address representing the previous owner of the given token ID
475    * @param _to target address that will receive the tokens
476    * @param _tokenId uint256 ID of the token to be transferred
477    * @param _data bytes optional data to send along with the call
478    * @return whether the call correctly returned the expected magic value
479    */
480   function checkAndCallSafeTransfer(
481     address _from,
482     address _to,
483     uint256 _tokenId,
484     bytes _data
485   )
486     internal
487     returns (bool)
488   {
489     if (!_to.isContract()) {
490       return true;
491     }
492     bytes4 retval = ERC721Receiver(_to).onERC721Received(
493       _from, _tokenId, _data);
494     return (retval == ERC721_RECEIVED);
495   }
496 }
497 
498 /**
499  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
500  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
501  */
502 contract ERC721Enumerable is ERC721Basic {
503   function totalSupply() public view returns (uint256);
504   function tokenOfOwnerByIndex(
505     address _owner,
506     uint256 _index
507   )
508     public
509     view
510     returns (uint256 _tokenId);
511 
512   function tokenByIndex(uint256 _index) public view returns (uint256);
513 }
514 
515 
516 /**
517  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
518  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
519  */
520 contract ERC721Metadata is ERC721Basic {
521   function name() public view returns (string _name);
522   function symbol() public view returns (string _symbol);
523   function tokenURI(uint256 _tokenId) public view returns (string);
524 }
525 
526 
527 /**
528  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
529  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
530  */
531 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
532 }
533 
534 /**
535  * @title Full ERC721 Token
536  * This implementation includes all the required and some optional functionality of the ERC721 standard
537  * Moreover, it includes approve all functionality using operator terminology
538  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
539  */
540 contract AnimalFactoryERC721Token is ERC721, ERC721BasicToken , Ownable{
541   // Token name
542   string internal name_;
543 
544   // Token symbol
545   string internal symbol_;
546 
547   // Mapping from owner to list of owned token IDs
548   mapping(address => uint256[]) internal ownedTokens;
549 
550   // Mapping from token ID to index of the owner tokens list
551   mapping(uint256 => uint256) internal ownedTokensIndex;
552 
553   // Array with all token ids, used for enumeration
554   uint256[] internal allTokens;
555 
556   // Mapping from token id to position in the allTokens array
557   mapping(uint256 => uint256) internal allTokensIndex;
558 
559   // Optional mapping for token URIs
560   mapping(uint256 => string) internal tokenURIs;
561 
562   /**
563    * @dev Constructor function
564    */
565   constructor(string _name, string _symbol, address tokenOwner) public {
566     name_ = _name;
567     symbol_ = _symbol;
568     owner=tokenOwner;
569   }
570 
571   /**
572    * @dev Gets the token name
573    * @return string representing the token name
574    */
575   function name() public view returns (string) {
576     return name_;
577   }
578 
579   /**
580    * @dev Gets the token symbol
581    * @return string representing the token symbol
582    */
583   function symbol() public view returns (string) {
584     return symbol_;
585   }
586 
587   /**
588    * @dev Returns an URI for a given token ID
589    * @dev Throws if the token ID does not exist. May return an empty string.
590    * @param _tokenId uint256 ID of the token to query
591    */
592   function tokenURI(uint256 _tokenId) public view returns (string) {
593     require(exists(_tokenId));
594     return tokenURIs[_tokenId];
595   }
596 
597   /**
598    * @dev Gets the token ID at a given index of the tokens list of the requested owner
599    * @param _owner address owning the tokens list to be accessed
600    * @param _index uint256 representing the index to be accessed of the requested tokens list
601    * @return uint256 token ID at the given index of the tokens list owned by the requested address
602    */
603   function tokenOfOwnerByIndex(
604     address _owner,
605     uint256 _index
606   )
607     public
608     view
609     returns (uint256)
610   {
611     require(_index < balanceOf(_owner));
612     return ownedTokens[_owner][_index];
613   }
614 
615   /**
616    * @dev Gets the total amount of tokens stored by the contract
617    * @return uint256 representing the total amount of tokens
618    */
619   function totalSupply() public view returns (uint256) {
620     return allTokens.length;
621   }
622 
623   /**
624    * @dev Gets the token ID at a given index of all the tokens in this contract
625    * @dev Reverts if the index is greater or equal to the total number of tokens
626    * @param _index uint256 representing the index to be accessed of the tokens list
627    * @return uint256 token ID at the given index of the tokens list
628    */
629   function tokenByIndex(uint256 _index) public view returns (uint256) {
630     require(_index < totalSupply());
631     return allTokens[_index];
632   }
633 
634   /**
635    * @dev Internal function to set the token URI for a given token
636    * @dev Reverts if the token ID does not exist
637    * @param _tokenId uint256 ID of the token to set its URI
638    * @param _uri string URI to assign
639    */
640   function _setTokenURI(uint256 _tokenId, string _uri) internal {
641     require(exists(_tokenId));
642     tokenURIs[_tokenId] = _uri;
643   }
644 
645   /**
646    * @dev Internal function to add a token ID to the list of a given address
647    * @param _to address representing the new owner of the given token ID
648    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
649    */
650   function addTokenTo(address _to, uint256 _tokenId) internal {
651     super.addTokenTo(_to, _tokenId);
652     uint256 length = ownedTokens[_to].length;
653     ownedTokens[_to].push(_tokenId);
654     ownedTokensIndex[_tokenId] = length;
655   }
656 
657   /**
658    * @dev Internal function to remove a token ID from the list of a given address
659    * @param _from address representing the previous owner of the given token ID
660    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
661    */
662   function removeTokenFrom(address _from, uint256 _tokenId) internal {
663     super.removeTokenFrom(_from, _tokenId);
664 
665     uint256 tokenIndex = ownedTokensIndex[_tokenId];
666     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
667     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
668 
669     ownedTokens[_from][tokenIndex] = lastToken;
670     ownedTokens[_from][lastTokenIndex] = 0;
671     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
672     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
673     // the lastToken to the first position, and then dropping the element placed in the last position of the list
674 
675     ownedTokens[_from].length--;
676     ownedTokensIndex[_tokenId] = 0;
677     ownedTokensIndex[lastToken] = tokenIndex;
678   }
679 
680   /**
681    * @dev Internal function to mint a new token
682    * @dev Reverts if the given token ID already exists
683    * @param _to address the beneficiary that will own the minted token
684    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
685    */
686   function _mint(address _to, uint256 _tokenId) internal {
687     super._mint(_to, _tokenId);
688 
689     allTokensIndex[_tokenId] = allTokens.length;
690     allTokens.push(_tokenId);
691   }
692 
693   /**
694    * @dev Internal function to burn a specific token
695    * @dev Reverts if the token does not exist
696    * @param _owner owner of the token to burn
697    * @param _tokenId uint256 ID of the token being burned by the msg.sender
698    */
699   function _burn(address _owner, uint256 _tokenId) internal {
700     super._burn(_owner, _tokenId);
701 
702     // Clear metadata (if any)
703     if (bytes(tokenURIs[_tokenId]).length != 0) {
704       delete tokenURIs[_tokenId];
705     }
706 
707     // Reorg all tokens array
708     uint256 tokenIndex = allTokensIndex[_tokenId];
709     uint256 lastTokenIndex = allTokens.length.sub(1);
710     uint256 lastToken = allTokens[lastTokenIndex];
711 
712     allTokens[tokenIndex] = lastToken;
713     allTokens[lastTokenIndex] = 0;
714 
715     allTokens.length--;
716     allTokensIndex[_tokenId] = 0;
717     allTokensIndex[lastToken] = tokenIndex;
718   }
719   function getAnimalIdAgainstAddress(address ownerAddress) public constant returns (uint[] listAnimals)
720   {
721       return ownedTokens[ownerAddress];
722   }
723   
724   function getTotalTokensAgainstAddress(address ownerAddress) public constant returns (uint totalAnimals)
725   {
726       return ownedTokensCount[ownerAddress];
727   }
728  
729   function sendToken(address sendTo, uint tid, string tmeta) public onlyOwner
730   {
731       _mint(sendTo,tid);
732       _setTokenURI(tid, tmeta);
733   }
734   
735    function setAnimalMeta(uint tid, string tmeta) public onlyOwner
736   {
737       _setTokenURI(tid, tmeta);
738   }
739   
740   function burnToken(address tokenOwner, uint256 tid) public onlyOwner {
741       _burn(tokenOwner,tid);
742   }
743 
744 }