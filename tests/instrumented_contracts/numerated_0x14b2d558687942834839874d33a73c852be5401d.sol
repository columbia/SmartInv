1 pragma solidity 0.4.24;
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
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title ERC721 Non-Fungible Token Standard basic interface
64  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
65  */
66 contract ERC721Basic {
67   event Transfer(
68     address indexed _from,
69     address indexed _to,
70     uint256 _tokenId
71   );
72   event Approval(
73     address indexed _owner,
74     address indexed _approved,
75     uint256 _tokenId
76   );
77   event ApprovalForAll(
78     address indexed _owner,
79     address indexed _operator,
80     bool _approved
81   );
82 
83   function balanceOf(address _owner) public view returns (uint256 _balance);
84   function ownerOf(uint256 _tokenId) public view returns (address _owner);
85   function exists(uint256 _tokenId) public view returns (bool _exists);
86 
87   function approve(address _to, uint256 _tokenId) public;
88   function getApproved(uint256 _tokenId)
89     public view returns (address _operator);
90 
91   function setApprovalForAll(address _operator, bool _approved) public;
92   function isApprovedForAll(address _owner, address _operator)
93     public view returns (bool);
94 
95   function transferFrom(address _from, address _to, uint256 _tokenId) public;
96   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
97     public;
98 
99   function safeTransferFrom(
100     address _from,
101     address _to,
102     uint256 _tokenId,
103     bytes _data
104   )
105     public;
106 }
107 
108 /**
109  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
110  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
111  */
112 contract ERC721Enumerable is ERC721Basic {
113   function totalSupply() public view returns (uint256);
114   function tokenOfOwnerByIndex(
115     address _owner,
116     uint256 _index
117   )
118     public
119     view
120     returns (uint256 _tokenId);
121 
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
144 /**
145  * Utility library of inline functions on addresses
146  */
147 library AddressUtils {
148 
149   /**
150    * Returns whether the target address is a contract
151    * @dev This function will return false if invoked during the constructor of a contract,
152    *  as the code is not actually created until after the constructor finishes.
153    * @param addr address to check
154    * @return whether the target address is a contract
155    */
156   function isContract(address addr) internal view returns (bool) {
157     uint256 size;
158     // XXX Currently there is no better way to check if there is a contract in an address
159     // than to check the size of the code at that address.
160     // See https://ethereum.stackexchange.com/a/14016/36603
161     // for more details about how this works.
162     // TODO Check this again before the Serenity release, because all addresses will be
163     // contracts then.
164     // solium-disable-next-line security/no-inline-assembly
165     assembly { size := extcodesize(addr) }
166     return size > 0;
167   }
168 
169 }
170 
171 /**
172  * @title SafeMath
173  * @dev Math operations with safety checks that throw on error
174  */
175 library SafeMath {
176 
177   /**
178   * @dev Multiplies two numbers, throws on overflow.
179   */
180   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
181     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
182     // benefit is lost if 'b' is also tested.
183     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
184     if (a == 0) {
185       return 0;
186     }
187 
188     c = a * b;
189     assert(c / a == b);
190     return c;
191   }
192 
193   /**
194   * @dev Integer division of two numbers, truncating the quotient.
195   */
196   function div(uint256 a, uint256 b) internal pure returns (uint256) {
197     // assert(b > 0); // Solidity automatically throws when dividing by 0
198     // uint256 c = a / b;
199     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200     return a / b;
201   }
202 
203   /**
204   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
205   */
206   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207     assert(b <= a);
208     return a - b;
209   }
210 
211   /**
212   * @dev Adds two numbers, throws on overflow.
213   */
214   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
215     c = a + b;
216     assert(c >= a);
217     return c;
218   }
219 }
220 
221 /**
222  * @title ERC721 token receiver interface
223  * @dev Interface for any contract that wants to support safeTransfers
224  *  from ERC721 asset contracts.
225  */
226 contract ERC721Receiver {
227   /**
228    * @dev Magic value to be returned upon successful reception of an NFT
229    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
230    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
231    */
232   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
233 
234   /**
235    * @notice Handle the receipt of an NFT
236    * @dev The ERC721 smart contract calls this function on the recipient
237    *  after a `safetransfer`. This function MAY throw to revert and reject the
238    *  transfer. This function MUST use 50,000 gas or less. Return of other
239    *  than the magic value MUST result in the transaction being reverted.
240    *  Note: the contract address is always the message sender.
241    * @param _from The sending address
242    * @param _tokenId The NFT identifier which is being transfered
243    * @param _data Additional data with no specified format
244    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
245    */
246   function onERC721Received(
247     address _from,
248     uint256 _tokenId,
249     bytes _data
250   )
251     public
252     returns(bytes4);
253 }
254 
255 /**
256  * @title ERC721 Non-Fungible Token Standard basic implementation
257  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
258  */
259 contract ERC721BasicToken is ERC721Basic {
260   using SafeMath for uint256;
261   using AddressUtils for address;
262 
263   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
264   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
265   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
266 
267   // Mapping from token ID to owner
268   mapping (uint256 => address) internal tokenOwner;
269 
270   // Mapping from token ID to approved address
271   mapping (uint256 => address) internal tokenApprovals;
272 
273   // Mapping from owner to number of owned token
274   mapping (address => uint256) internal ownedTokensCount;
275 
276   // Mapping from owner to operator approvals
277   mapping (address => mapping (address => bool)) internal operatorApprovals;
278 
279   /**
280    * @dev Guarantees msg.sender is owner of the given token
281    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
282    */
283   modifier onlyOwnerOf(uint256 _tokenId) {
284     require(ownerOf(_tokenId) == msg.sender);
285     _;
286   }
287 
288   /**
289    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
290    * @param _tokenId uint256 ID of the token to validate
291    */
292   modifier canTransfer(uint256 _tokenId) {
293     require(isApprovedOrOwner(msg.sender, _tokenId));
294     _;
295   }
296 
297   /**
298    * @dev Gets the balance of the specified address
299    * @param _owner address to query the balance of
300    * @return uint256 representing the amount owned by the passed address
301    */
302   function balanceOf(address _owner) public view returns (uint256) {
303     require(_owner != address(0));
304     return ownedTokensCount[_owner];
305   }
306 
307   /**
308    * @dev Gets the owner of the specified token ID
309    * @param _tokenId uint256 ID of the token to query the owner of
310    * @return owner address currently marked as the owner of the given token ID
311    */
312   function ownerOf(uint256 _tokenId) public view returns (address) {
313     address owner = tokenOwner[_tokenId];
314     require(owner != address(0));
315     return owner;
316   }
317 
318   /**
319    * @dev Returns whether the specified token exists
320    * @param _tokenId uint256 ID of the token to query the existence of
321    * @return whether the token exists
322    */
323   function exists(uint256 _tokenId) public view returns (bool) {
324     address owner = tokenOwner[_tokenId];
325     return owner != address(0);
326   }
327 
328   /**
329    * @dev Approves another address to transfer the given token ID
330    * @dev The zero address indicates there is no approved address.
331    * @dev There can only be one approved address per token at a given time.
332    * @dev Can only be called by the token owner or an approved operator.
333    * @param _to address to be approved for the given token ID
334    * @param _tokenId uint256 ID of the token to be approved
335    */
336   function approve(address _to, uint256 _tokenId) public {
337     address owner = ownerOf(_tokenId);
338     require(_to != owner);
339     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
340 
341     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
342       tokenApprovals[_tokenId] = _to;
343       emit Approval(owner, _to, _tokenId);
344     }
345   }
346 
347   /**
348    * @dev Gets the approved address for a token ID, or zero if no address set
349    * @param _tokenId uint256 ID of the token to query the approval of
350    * @return address currently approved for the given token ID
351    */
352   function getApproved(uint256 _tokenId) public view returns (address) {
353     return tokenApprovals[_tokenId];
354   }
355 
356   /**
357    * @dev Sets or unsets the approval of a given operator
358    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
359    * @param _to operator address to set the approval
360    * @param _approved representing the status of the approval to be set
361    */
362   function setApprovalForAll(address _to, bool _approved) public {
363     require(_to != msg.sender);
364     operatorApprovals[msg.sender][_to] = _approved;
365     emit ApprovalForAll(msg.sender, _to, _approved);
366   }
367 
368   /**
369    * @dev Tells whether an operator is approved by a given owner
370    * @param _owner owner address which you want to query the approval of
371    * @param _operator operator address which you want to query the approval of
372    * @return bool whether the given operator is approved by the given owner
373    */
374   function isApprovedForAll(
375     address _owner,
376     address _operator
377   )
378     public
379     view
380     returns (bool)
381   {
382     return operatorApprovals[_owner][_operator];
383   }
384 
385   /**
386    * @dev Transfers the ownership of a given token ID to another address
387    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
388    * @dev Requires the msg sender to be the owner, approved, or operator
389    * @param _from current owner of the token
390    * @param _to address to receive the ownership of the given token ID
391    * @param _tokenId uint256 ID of the token to be transferred
392   */
393   function transferFrom(
394     address _from,
395     address _to,
396     uint256 _tokenId
397   )
398     public
399     canTransfer(_tokenId)
400   {
401     require(_from != address(0));
402     require(_to != address(0));
403 
404     clearApproval(_from, _tokenId);
405     removeTokenFrom(_from, _tokenId);
406     addTokenTo(_to, _tokenId);
407 
408     emit Transfer(_from, _to, _tokenId);
409   }
410 
411   /**
412    * @dev Safely transfers the ownership of a given token ID to another address
413    * @dev If the target address is a contract, it must implement `onERC721Received`,
414    *  which is called upon a safe transfer, and return the magic value
415    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
416    *  the transfer is reverted.
417    * @dev Requires the msg sender to be the owner, approved, or operator
418    * @param _from current owner of the token
419    * @param _to address to receive the ownership of the given token ID
420    * @param _tokenId uint256 ID of the token to be transferred
421   */
422   function safeTransferFrom(
423     address _from,
424     address _to,
425     uint256 _tokenId
426   )
427     public
428     canTransfer(_tokenId)
429   {
430     // solium-disable-next-line arg-overflow
431     safeTransferFrom(_from, _to, _tokenId, "");
432   }
433 
434   /**
435    * @dev Safely transfers the ownership of a given token ID to another address
436    * @dev If the target address is a contract, it must implement `onERC721Received`,
437    *  which is called upon a safe transfer, and return the magic value
438    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
439    *  the transfer is reverted.
440    * @dev Requires the msg sender to be the owner, approved, or operator
441    * @param _from current owner of the token
442    * @param _to address to receive the ownership of the given token ID
443    * @param _tokenId uint256 ID of the token to be transferred
444    * @param _data bytes data to send along with a safe transfer check
445    */
446   function safeTransferFrom(
447     address _from,
448     address _to,
449     uint256 _tokenId,
450     bytes _data
451   )
452     public
453     canTransfer(_tokenId)
454   {
455     transferFrom(_from, _to, _tokenId);
456     // solium-disable-next-line arg-overflow
457     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
458   }
459 
460   /**
461    * @dev Returns whether the given spender can transfer a given token ID
462    * @param _spender address of the spender to query
463    * @param _tokenId uint256 ID of the token to be transferred
464    * @return bool whether the msg.sender is approved for the given token ID,
465    *  is an operator of the owner, or is the owner of the token
466    */
467   function isApprovedOrOwner(
468     address _spender,
469     uint256 _tokenId
470   )
471     internal
472     view
473     returns (bool)
474   {
475     address owner = ownerOf(_tokenId);
476     // Disable solium check because of
477     // https://github.com/duaraghav8/Solium/issues/175
478     // solium-disable-next-line operator-whitespace
479     return (
480       _spender == owner ||
481       getApproved(_tokenId) == _spender ||
482       isApprovedForAll(owner, _spender)
483     );
484   }
485 
486   /**
487    * @dev Internal function to mint a new token
488    * @dev Reverts if the given token ID already exists
489    * @param _to The address that will own the minted token
490    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
491    */
492   function _mint(address _to, uint256 _tokenId) internal {
493     require(_to != address(0));
494     addTokenTo(_to, _tokenId);
495     emit Transfer(address(0), _to, _tokenId);
496   }
497 
498   /**
499    * @dev Internal function to burn a specific token
500    * @dev Reverts if the token does not exist
501    * @param _tokenId uint256 ID of the token being burned by the msg.sender
502    */
503   function _burn(address _owner, uint256 _tokenId) internal {
504     clearApproval(_owner, _tokenId);
505     removeTokenFrom(_owner, _tokenId);
506     emit Transfer(_owner, address(0), _tokenId);
507   }
508 
509   /**
510    * @dev Internal function to clear current approval of a given token ID
511    * @dev Reverts if the given address is not indeed the owner of the token
512    * @param _owner owner of the token
513    * @param _tokenId uint256 ID of the token to be transferred
514    */
515   function clearApproval(address _owner, uint256 _tokenId) internal {
516     require(ownerOf(_tokenId) == _owner);
517     if (tokenApprovals[_tokenId] != address(0)) {
518       tokenApprovals[_tokenId] = address(0);
519       emit Approval(_owner, address(0), _tokenId);
520     }
521   }
522 
523   /**
524    * @dev Internal function to add a token ID to the list of a given address
525    * @param _to address representing the new owner of the given token ID
526    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
527    */
528   function addTokenTo(address _to, uint256 _tokenId) internal {
529     require(tokenOwner[_tokenId] == address(0));
530     tokenOwner[_tokenId] = _to;
531     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
532   }
533 
534   /**
535    * @dev Internal function to remove a token ID from the list of a given address
536    * @param _from address representing the previous owner of the given token ID
537    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
538    */
539   function removeTokenFrom(address _from, uint256 _tokenId) internal {
540     require(ownerOf(_tokenId) == _from);
541     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
542     tokenOwner[_tokenId] = address(0);
543   }
544 
545   /**
546    * @dev Internal function to invoke `onERC721Received` on a target address
547    * @dev The call is not executed if the target address is not a contract
548    * @param _from address representing the previous owner of the given token ID
549    * @param _to target address that will receive the tokens
550    * @param _tokenId uint256 ID of the token to be transferred
551    * @param _data bytes optional data to send along with the call
552    * @return whether the call correctly returned the expected magic value
553    */
554   function checkAndCallSafeTransfer(
555     address _from,
556     address _to,
557     uint256 _tokenId,
558     bytes _data
559   )
560     internal
561     returns (bool)
562   {
563     if (!_to.isContract()) {
564       return true;
565     }
566     bytes4 retval = ERC721Receiver(_to).onERC721Received(
567       _from, _tokenId, _data);
568     return (retval == ERC721_RECEIVED);
569   }
570 }
571 
572 /**
573  * @title Full ERC721 Token
574  * This implementation includes all the required and some optional functionality of the ERC721 standard
575  * Moreover, it includes approve all functionality using operator terminology
576  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
577  */
578 contract ERC721Token is ERC721, ERC721BasicToken {
579   // Token name
580   string internal name_;
581 
582   // Token symbol
583   string internal symbol_;
584 
585   // Mapping from owner to list of owned token IDs
586   mapping(address => uint256[]) internal ownedTokens;
587 
588   // Mapping from token ID to index of the owner tokens list
589   mapping(uint256 => uint256) internal ownedTokensIndex;
590 
591   // Array with all token ids, used for enumeration
592   uint256[] internal allTokens;
593 
594   // Mapping from token id to position in the allTokens array
595   mapping(uint256 => uint256) internal allTokensIndex;
596 
597   // Optional mapping for token URIs
598   mapping(uint256 => string) internal tokenURIs;
599 
600   /**
601    * @dev Constructor function
602    */
603   constructor(string _name, string _symbol) public {
604     name_ = _name;
605     symbol_ = _symbol;
606   }
607 
608   /**
609    * @dev Gets the token name
610    * @return string representing the token name
611    */
612   function name() public view returns (string) {
613     return name_;
614   }
615 
616   /**
617    * @dev Gets the token symbol
618    * @return string representing the token symbol
619    */
620   function symbol() public view returns (string) {
621     return symbol_;
622   }
623 
624   /**
625    * @dev Returns an URI for a given token ID
626    * @dev Throws if the token ID does not exist. May return an empty string.
627    * @param _tokenId uint256 ID of the token to query
628    */
629   function tokenURI(uint256 _tokenId) public view returns (string) {
630     require(exists(_tokenId));
631     return tokenURIs[_tokenId];
632   }
633 
634   /**
635    * @dev Gets the token ID at a given index of the tokens list of the requested owner
636    * @param _owner address owning the tokens list to be accessed
637    * @param _index uint256 representing the index to be accessed of the requested tokens list
638    * @return uint256 token ID at the given index of the tokens list owned by the requested address
639    */
640   function tokenOfOwnerByIndex(
641     address _owner,
642     uint256 _index
643   )
644     public
645     view
646     returns (uint256)
647   {
648     require(_index < balanceOf(_owner));
649     return ownedTokens[_owner][_index];
650   }
651 
652   /**
653    * @dev Gets the total amount of tokens stored by the contract
654    * @return uint256 representing the total amount of tokens
655    */
656   function totalSupply() public view returns (uint256) {
657     return allTokens.length;
658   }
659 
660   /**
661    * @dev Gets the token ID at a given index of all the tokens in this contract
662    * @dev Reverts if the index is greater or equal to the total number of tokens
663    * @param _index uint256 representing the index to be accessed of the tokens list
664    * @return uint256 token ID at the given index of the tokens list
665    */
666   function tokenByIndex(uint256 _index) public view returns (uint256) {
667     require(_index < totalSupply());
668     return allTokens[_index];
669   }
670 
671   /**
672    * @dev Internal function to set the token URI for a given token
673    * @dev Reverts if the token ID does not exist
674    * @param _tokenId uint256 ID of the token to set its URI
675    * @param _uri string URI to assign
676    */
677   function _setTokenURI(uint256 _tokenId, string _uri) internal {
678     require(exists(_tokenId));
679     tokenURIs[_tokenId] = _uri;
680   }
681 
682   /**
683    * @dev Internal function to add a token ID to the list of a given address
684    * @param _to address representing the new owner of the given token ID
685    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
686    */
687   function addTokenTo(address _to, uint256 _tokenId) internal {
688     super.addTokenTo(_to, _tokenId);
689     uint256 length = ownedTokens[_to].length;
690     ownedTokens[_to].push(_tokenId);
691     ownedTokensIndex[_tokenId] = length;
692   }
693 
694   /**
695    * @dev Internal function to remove a token ID from the list of a given address
696    * @param _from address representing the previous owner of the given token ID
697    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
698    */
699   function removeTokenFrom(address _from, uint256 _tokenId) internal {
700     super.removeTokenFrom(_from, _tokenId);
701 
702     uint256 tokenIndex = ownedTokensIndex[_tokenId];
703     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
704     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
705 
706     ownedTokens[_from][tokenIndex] = lastToken;
707     ownedTokens[_from][lastTokenIndex] = 0;
708     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
709     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
710     // the lastToken to the first position, and then dropping the element placed in the last position of the list
711 
712     ownedTokens[_from].length--;
713     ownedTokensIndex[_tokenId] = 0;
714     ownedTokensIndex[lastToken] = tokenIndex;
715   }
716 
717   /**
718    * @dev Internal function to mint a new token
719    * @dev Reverts if the given token ID already exists
720    * @param _to address the beneficiary that will own the minted token
721    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
722    */
723   function _mint(address _to, uint256 _tokenId) internal {
724     super._mint(_to, _tokenId);
725 
726     allTokensIndex[_tokenId] = allTokens.length;
727     allTokens.push(_tokenId);
728   }
729 
730   /**
731    * @dev Internal function to burn a specific token
732    * @dev Reverts if the token does not exist
733    * @param _owner owner of the token to burn
734    * @param _tokenId uint256 ID of the token being burned by the msg.sender
735    */
736   function _burn(address _owner, uint256 _tokenId) internal {
737     super._burn(_owner, _tokenId);
738 
739     // Clear metadata (if any)
740     if (bytes(tokenURIs[_tokenId]).length != 0) {
741       delete tokenURIs[_tokenId];
742     }
743 
744     // Reorg all tokens array
745     uint256 tokenIndex = allTokensIndex[_tokenId];
746     uint256 lastTokenIndex = allTokens.length.sub(1);
747     uint256 lastToken = allTokens[lastTokenIndex];
748 
749     allTokens[tokenIndex] = lastToken;
750     allTokens[lastTokenIndex] = 0;
751 
752     allTokens.length--;
753     allTokensIndex[_tokenId] = 0;
754     allTokensIndex[lastToken] = tokenIndex;
755   }
756 
757 }
758 
759 // File: contracts/WorldCupPlayerToken.sol
760 
761 contract WorldCupPlayerToken is ERC721Token("WWWorld Cup", "WWWC"), Ownable {
762 
763   string constant public PLAYER_METADATA = "ipfs://ipfs/QmNgMeQT62pnUkkFcz4y59cQTmTZHBVFKmQ7Y7HQjh7tRw";
764   uint256 constant DISTINCT_LEGENDARY_LIMIT = 1;
765   uint256 constant DISTINCT_RARE_LIMIT = 2;
766   uint256 constant DISTINCT_COMMON_LIMIT = 3;
767   uint256 constant LEGENDARY_MAX_ID = 32;
768   uint256 constant RARE_MAX_ID = 96;
769   uint256 constant COMMON_MAX_ID = 736;
770   mapping (uint256 => uint256) public playerCount;
771   mapping (uint256 => uint256) internal tokenPlayerIds;
772 
773   /** @dev Enforces a scaricity of unique player cards by limiting.
774     * @param playerId Player Id to enforce limit on.
775     * @param limit Maximum number of tokens for that player id that can exist.
776     */
777   modifier enforcePlayerScarcity(uint256 playerId, uint256 limit) {
778     require(playerCount[playerId] < limit, "Player limit reached.");
779     _;
780   }
781 
782   /** @dev Validates that the playerId is in the correct rarity range.
783     * @param playerId Player Id to validate.
784     * @param min Minimum playerId of range.
785     * @param max Maximum playerId of range.
786     */
787   modifier validatePlayerIdRange(uint256 playerId, uint256 min, uint256 max) {
788     require(playerId > min, "Player ID must be greater than the rarity minimum.");
789     require(playerId <= max, "Player ID must be less than or equal to rarity maximum.");
790     _;
791   }
792 
793   /** @dev Creates a new token.
794     * @param playerId Player Id to be created.
795     */
796   function _mintToken(uint256 playerId, string tokenURI, address owner) internal {
797     
798     // Mint new token:
799     uint256 tokenId = allTokens.length + 1;
800     super._mint(owner, tokenId);
801 
802     // Set metadata
803     _setTokenURI(tokenId, tokenURI);
804     _setPlayerId(tokenId, playerId);
805   }
806 
807   /** @dev Internal function to set player Id for a given token.
808     * @param tokenId Id of the token to set its playerId.
809     * @param playerId Player Id to assign.
810     */
811   function _setPlayerId(uint256 tokenId, uint256 playerId) internal {
812     require(exists(tokenId), "Token does not exist.");
813     tokenPlayerIds[tokenId] = playerId;
814   }
815 
816   /** @dev Returns player Id for a given token.
817     * @param tokenId Id of the token to query player Id.
818     * @return playerId for given token.
819     */
820   function playerId(uint256 tokenId) public view returns (uint256) {
821     require(exists(tokenId), "Token does not exist.");
822     return tokenPlayerIds[tokenId];
823   }
824 
825 }
826 
827 // File: contracts/AuctionableWorldCupPlayerToken.sol
828 
829 contract AuctionableWorldCupPlayerToken is WorldCupPlayerToken {
830 
831   Auction[] public auctions;
832   struct Auction {
833     address highestBidder;
834     uint256 highestBidAmount;
835     uint256 endsAtBlock;
836     uint256 playerId;
837     bool finalized;
838     string tokenURI;
839   }
840   uint256 constant MIN_BID_INCREMENT = 0.01 ether;
841   uint256 constant AUCTION_BLOCK_LENGTH = 257;
842   uint256 public totalUnclaimedBidsAmount = 0;
843   mapping (uint256 => mapping(address => uint256)) public unclaimedBidsByAuctionIndexByBidder;
844 
845   event AuctionCreated(uint256 playerId);
846   event AuctionFinalized(uint256 auctionIndex, address highestBidder);
847   event BidIncremented(uint256 auctionIndex, address bidder);
848   event BidReturned(uint256 auctionIndex, address bidder);
849 
850   /** @dev Returns the total number of Auctions.
851     * @return total number of Auctions.
852     */
853   function totalAuctionsCount() public view returns (uint256) {
854     return auctions.length;
855   }
856 
857   /** @dev Starts an Auction by setting endsAtBlock past current block.
858     * @param auctionIndex Index of Auction in auctions array.
859     */
860   function _startAuction(uint256 auctionIndex) internal {
861     auctions[auctionIndex].endsAtBlock = block.number + AUCTION_BLOCK_LENGTH;
862   }
863 
864   /** @dev Creates a new Token Auction.
865     * @param playerId playerId to be auctioned.
866     * @param tokenURI IPFS hash of player metadata.
867     */
868   function _createAuction(uint256 playerId, string tokenURI) internal {
869     playerCount[playerId] += 1;
870     Auction memory auction = Auction(address(0), 0, 0, playerId, false, tokenURI);
871     auctions.push(auction);
872     emit AuctionCreated(playerId);
873   }
874 
875   /** @dev Creates a new Legendary Token Auction.
876     * @param playerId playerId to be auctioned.
877     * @param tokenURI IPFS hash of player metadata.
878     */
879   function createLegendaryAuction(uint256 playerId, string tokenURI)
880     public
881     onlyOwner
882     enforcePlayerScarcity(playerId, DISTINCT_LEGENDARY_LIMIT)
883     validatePlayerIdRange(playerId, 0, LEGENDARY_MAX_ID)
884   {
885     _createAuction(playerId, tokenURI);
886   }
887 
888   /** @dev Creates a new Rare Token Auction.
889     * @param playerId playerId to be auctioned.
890     * @param tokenURI IPFS hash of player metadata.
891     */
892   function createRareAuction(uint256 playerId, string tokenURI)
893     public
894     onlyOwner
895     enforcePlayerScarcity(playerId, DISTINCT_RARE_LIMIT)
896     validatePlayerIdRange(playerId, LEGENDARY_MAX_ID, RARE_MAX_ID)
897   {
898     _createAuction(playerId, tokenURI);
899   }
900 
901   /** @dev Creates a new Common Token Auction.
902     * @param playerId playerId to be auctioned.
903     * @param tokenURI IPFS hash of player metadata.
904     */
905   function createCommonAuction(uint256 playerId, string tokenURI)
906     public
907     onlyOwner
908     enforcePlayerScarcity(playerId, DISTINCT_COMMON_LIMIT)
909     validatePlayerIdRange(playerId, RARE_MAX_ID, COMMON_MAX_ID)
910   {
911     _createAuction(playerId, tokenURI);
912   }
913 
914   /** @dev Increments a sender's bid for a given Auction.
915     * @param auctionIndex Index in auctions of Auction to increment bid on.
916     */
917   function incrementBid(uint256 auctionIndex) public payable {
918 
919     // Require auction to exist:
920     require(auctionIndex + 1 <= auctions.length, "Auction does not exist.");
921 
922     // Require auction to not be ended:
923     uint256 auctionEndsAtBlock = auctions[auctionIndex].endsAtBlock;
924     require(auctionEndsAtBlock == 0 || block.number < auctionEndsAtBlock, "Auction has ended.");
925 
926     // Calculate new total bid from sender:
927     uint256 newTotalBid = unclaimedBidsByAuctionIndexByBidder[auctionIndex][msg.sender] + msg.value;
928 
929     // Require new highest bid to be increased by minimum bid increment:
930     require(newTotalBid >= auctions[auctionIndex].highestBidAmount + MIN_BID_INCREMENT, "Must increment bid by MIN_BID_INCREMENT.");
931 
932     // Start auction if this is the first bid:
933     if (auctions[auctionIndex].endsAtBlock == 0) {
934       _startAuction(auctionIndex);
935     }
936 
937     // Set bidder to highest bidder:
938     auctions[auctionIndex].highestBidder = msg.sender;
939 
940     // Set new highest bid amount:
941     auctions[auctionIndex].highestBidAmount = newTotalBid;
942 
943     // Update how much ether the contract is holding for bidder:
944     unclaimedBidsByAuctionIndexByBidder[auctionIndex][msg.sender] += msg.value;
945 
946     // Update total amount of ether the contract is holding for bidders:
947     totalUnclaimedBidsAmount += msg.value;
948 
949     emit BidIncremented(auctionIndex, msg.sender);
950   }
951 
952   /** @dev Finalizes an Auction, transfering token to the highest bidder.
953     * @param auctionIndex Index in auctions of Auction to finalize.
954     */
955   function finalizeAuction(uint256 auctionIndex) public {
956 
957     // Require auction to exist:
958     require(auctionIndex + 1 <= auctions.length, "Auction does not exist.");
959 
960     // Require auction to not already be finalized:
961     require(auctions[auctionIndex].finalized == false, "Auction has already been finalized.");
962 
963     // Require auction to be ended:
964     require(block.number > auctions[auctionIndex].endsAtBlock, "Auction has not ended yet.");
965 
966     // Finalize auction:
967     auctions[auctionIndex].finalized = true;
968 
969     Auction memory auction = auctions[auctionIndex];
970 
971     // Decrement winning bid from total unclaimed bids amount (that can be withdrawn):
972     totalUnclaimedBidsAmount = totalUnclaimedBidsAmount - auction.highestBidAmount;
973 
974     // Remove unclaimedBids from winning bidder:
975     unclaimedBidsByAuctionIndexByBidder[auctionIndex][auction.highestBidder] = 0;
976 
977     // Mint token:
978     _mintToken(auction.playerId, auction.tokenURI, auction.highestBidder);
979 
980     emit AuctionFinalized(auctionIndex, auction.highestBidder);
981   }
982 
983   /** @dev Withdraws broker funds.
984     */
985   function withdraw() public onlyOwner {
986     uint256 amount = address(this).balance - totalUnclaimedBidsAmount;
987     owner.transfer(amount);
988   }
989 
990   /** @dev Returns bids for a given Auction to bidder.
991     * @param auctionIndex Index in auctions of Auction to return bids for.
992     * @param bidder Address of bidder.
993     */
994   function returnBids(uint256 auctionIndex, address bidder) public {
995 
996     // Require auction to exist:
997     require(auctionIndex + 1 <= auctions.length, "Auction does not exist.");
998 
999     // Require auction to be ended:
1000     require(block.number > auctions[auctionIndex].endsAtBlock, "Auction has not ended yet.");
1001 
1002     // Require bidder not the winning address:
1003     require(bidder != auctions[auctionIndex].highestBidder, "Bidder who won auction cannot return bids.");
1004 
1005     // Cache refund amount:
1006     uint256 refund = unclaimedBidsByAuctionIndexByBidder[auctionIndex][bidder];
1007 
1008     // Reset unclaimed bids amount:
1009     unclaimedBidsByAuctionIndexByBidder[auctionIndex][bidder] = 0;
1010 
1011     // Refund unclaimed bids to bidder:
1012     bidder.transfer(refund);
1013 
1014     emit BidReturned(auctionIndex, bidder);
1015   }
1016 
1017 }