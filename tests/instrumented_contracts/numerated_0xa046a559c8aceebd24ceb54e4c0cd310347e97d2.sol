1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface ERC165 {
8 
9   /**
10    * @notice Query if a contract implements an interface
11    * @param _interfaceId The interface identifier, as specified in ERC-165
12    * @dev Interface identification is specified in ERC-165. This function
13    * uses less than 30,000 gas.
14    */
15   function supportsInterface(bytes4 _interfaceId)
16     external
17     view
18     returns (bool);
19 }
20 
21 /**
22  * @title ERC721 Non-Fungible Token Standard basic interface
23  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
24  */
25 contract ERC721Basic is ERC165 {
26   event Transfer(
27     address indexed _from,
28     address indexed _to,
29     uint256 indexed _tokenId
30   );
31   event Approval(
32     address indexed _owner,
33     address indexed _approved,
34     uint256 indexed _tokenId
35   );
36   event ApprovalForAll(
37     address indexed _owner,
38     address indexed _operator,
39     bool _approved
40   );
41 
42   function balanceOf(address _owner) public view returns (uint256 _balance);
43   function ownerOf(uint256 _tokenId) public view returns (address _owner);
44   function exists(uint256 _tokenId) public view returns (bool _exists);
45 
46   function approve(address _to, uint256 _tokenId) public;
47   function getApproved(uint256 _tokenId)
48     public view returns (address _operator);
49 
50   function setApprovalForAll(address _operator, bool _approved) public;
51   function isApprovedForAll(address _owner, address _operator)
52     public view returns (bool);
53 
54   function transferFrom(address _from, address _to, uint256 _tokenId) public;
55   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
56     public;
57 
58   function safeTransferFrom(
59     address _from,
60     address _to,
61     uint256 _tokenId,
62     bytes _data
63   )
64     public;
65 }
66 
67 /**
68  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
69  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
70  */
71 contract ERC721Enumerable is ERC721Basic {
72   function totalSupply() public view returns (uint256);
73   function tokenOfOwnerByIndex(
74     address _owner,
75     uint256 _index
76   )
77     public
78     view
79     returns (uint256 _tokenId);
80 
81   function tokenByIndex(uint256 _index) public view returns (uint256);
82 }
83 
84 
85 /**
86  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
87  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
88  */
89 contract ERC721Metadata is ERC721Basic {
90   function name() external view returns (string _name);
91   function symbol() external view returns (string _symbol);
92   function tokenURI(uint256 _tokenId) public view returns (string);
93 }
94 
95 
96 /**
97  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
98  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
99  */
100 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
101 }
102 
103 /**
104  * @title ERC721 token receiver interface
105  * @dev Interface for any contract that wants to support safeTransfers
106  * from ERC721 asset contracts.
107  */
108 contract ERC721Receiver {
109   /**
110    * @dev Magic value to be returned upon successful reception of an NFT
111    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
112    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
113    */
114   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
115 
116   /**
117    * @notice Handle the receipt of an NFT
118    * @dev The ERC721 smart contract calls this function on the recipient
119    * after a `safetransfer`. This function MAY throw to revert and reject the
120    * transfer. Return of other than the magic value MUST result in the 
121    * transaction being reverted.
122    * Note: the contract address is always the message sender.
123    * @param _operator The address which called `safeTransferFrom` function
124    * @param _from The address which previously owned the token
125    * @param _tokenId The NFT identifier which is being transfered
126    * @param _data Additional data with no specified format
127    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
128    */
129   function onERC721Received(
130     address _operator,
131     address _from,
132     uint256 _tokenId,
133     bytes _data
134   )
135     public
136     returns(bytes4);
137 }
138 
139 /**
140  * @title SafeMath
141  * @dev Math operations with safety checks that throw on error
142  */
143 library SafeMath {
144 
145   /**
146   * @dev Multiplies two numbers, throws on overflow.
147   */
148   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
150     // benefit is lost if 'b' is also tested.
151     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
152     if (a == 0) {
153       return 0;
154     }
155 
156     c = a * b;
157     assert(c / a == b);
158     return c;
159   }
160 
161   /**
162   * @dev Integer division of two numbers, truncating the quotient.
163   */
164   function div(uint256 a, uint256 b) internal pure returns (uint256) {
165     // assert(b > 0); // Solidity automatically throws when dividing by 0
166     // uint256 c = a / b;
167     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168     return a / b;
169   }
170 
171   /**
172   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
173   */
174   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175     assert(b <= a);
176     return a - b;
177   }
178 
179   /**
180   * @dev Adds two numbers, throws on overflow.
181   */
182   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
183     c = a + b;
184     assert(c >= a);
185     return c;
186   }
187 }
188 
189 /**
190  * Utility library of inline functions on addresses
191  */
192 library AddressUtils {
193 
194   /**
195    * Returns whether the target address is a contract
196    * @dev This function will return false if invoked during the constructor of a contract,
197    * as the code is not actually created until after the constructor finishes.
198    * @param addr address to check
199    * @return whether the target address is a contract
200    */
201   function isContract(address addr) internal view returns (bool) {
202     uint256 size;
203     // XXX Currently there is no better way to check if there is a contract in an address
204     // than to check the size of the code at that address.
205     // See https://ethereum.stackexchange.com/a/14016/36603
206     // for more details about how this works.
207     // TODO Check this again before the Serenity release, because all addresses will be
208     // contracts then.
209     // solium-disable-next-line security/no-inline-assembly
210     assembly { size := extcodesize(addr) }
211     return size > 0;
212   }
213 
214 }
215 
216 /**
217  * @title SupportsInterfaceWithLookup
218  * @author Matt Condon (@shrugs)
219  * @dev Implements ERC165 using a lookup table.
220  */
221 contract SupportsInterfaceWithLookup is ERC165 {
222   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
223   /**
224    * 0x01ffc9a7 ===
225    *   bytes4(keccak256('supportsInterface(bytes4)'))
226    */
227 
228   /**
229    * @dev a mapping of interface id to whether or not it's supported
230    */
231   mapping(bytes4 => bool) internal supportedInterfaces;
232 
233   /**
234    * @dev A contract implementing SupportsInterfaceWithLookup
235    * implement ERC165 itself
236    */
237   constructor()
238     public
239   {
240     _registerInterface(InterfaceId_ERC165);
241   }
242 
243   /**
244    * @dev implement supportsInterface(bytes4) using a lookup table
245    */
246   function supportsInterface(bytes4 _interfaceId)
247     external
248     view
249     returns (bool)
250   {
251     return supportedInterfaces[_interfaceId];
252   }
253 
254   /**
255    * @dev private method for registering an interface
256    */
257   function _registerInterface(bytes4 _interfaceId)
258     internal
259   {
260     require(_interfaceId != 0xffffffff);
261     supportedInterfaces[_interfaceId] = true;
262   }
263 }
264 
265 /**
266  * @title ERC721 Non-Fungible Token Standard basic implementation
267  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
268  */
269 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
270 
271   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
272   /*
273    * 0x80ac58cd ===
274    *   bytes4(keccak256('balanceOf(address)')) ^
275    *   bytes4(keccak256('ownerOf(uint256)')) ^
276    *   bytes4(keccak256('approve(address,uint256)')) ^
277    *   bytes4(keccak256('getApproved(uint256)')) ^
278    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
279    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
280    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
281    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
282    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
283    */
284 
285   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
286   /*
287    * 0x4f558e79 ===
288    *   bytes4(keccak256('exists(uint256)'))
289    */
290 
291   using SafeMath for uint256;
292   using AddressUtils for address;
293 
294   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
295   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
296   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
297 
298   // Mapping from token ID to owner
299   mapping (uint256 => address) internal tokenOwner;
300 
301   // Mapping from token ID to approved address
302   mapping (uint256 => address) internal tokenApprovals;
303 
304   // Mapping from owner to number of owned token
305   mapping (address => uint256) internal ownedTokensCount;
306 
307   // Mapping from owner to operator approvals
308   mapping (address => mapping (address => bool)) internal operatorApprovals;
309 
310   /**
311    * @dev Guarantees msg.sender is owner of the given token
312    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
313    */
314   modifier onlyOwnerOf(uint256 _tokenId) {
315     require(ownerOf(_tokenId) == msg.sender);
316     _;
317   }
318 
319   /**
320    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
321    * @param _tokenId uint256 ID of the token to validate
322    */
323   modifier canTransfer(uint256 _tokenId) {
324     require(isApprovedOrOwner(msg.sender, _tokenId));
325     _;
326   }
327 
328   constructor()
329     public
330   {
331     // register the supported interfaces to conform to ERC721 via ERC165
332     _registerInterface(InterfaceId_ERC721);
333     _registerInterface(InterfaceId_ERC721Exists);
334   }
335 
336   /**
337    * @dev Gets the balance of the specified address
338    * @param _owner address to query the balance of
339    * @return uint256 representing the amount owned by the passed address
340    */
341   function balanceOf(address _owner) public view returns (uint256) {
342     require(_owner != address(0));
343     return ownedTokensCount[_owner];
344   }
345 
346   /**
347    * @dev Gets the owner of the specified token ID
348    * @param _tokenId uint256 ID of the token to query the owner of
349    * @return owner address currently marked as the owner of the given token ID
350    */
351   function ownerOf(uint256 _tokenId) public view returns (address) {
352     address owner = tokenOwner[_tokenId];
353     require(owner != address(0));
354     return owner;
355   }
356 
357   /**
358    * @dev Returns whether the specified token exists
359    * @param _tokenId uint256 ID of the token to query the existence of
360    * @return whether the token exists
361    */
362   function exists(uint256 _tokenId) public view returns (bool) {
363     address owner = tokenOwner[_tokenId];
364     return owner != address(0);
365   }
366 
367   /**
368    * @dev Approves another address to transfer the given token ID
369    * The zero address indicates there is no approved address.
370    * There can only be one approved address per token at a given time.
371    * Can only be called by the token owner or an approved operator.
372    * @param _to address to be approved for the given token ID
373    * @param _tokenId uint256 ID of the token to be approved
374    */
375   function approve(address _to, uint256 _tokenId) public {
376     address owner = ownerOf(_tokenId);
377     require(_to != owner);
378     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
379 
380     tokenApprovals[_tokenId] = _to;
381     emit Approval(owner, _to, _tokenId);
382   }
383 
384   /**
385    * @dev Gets the approved address for a token ID, or zero if no address set
386    * @param _tokenId uint256 ID of the token to query the approval of
387    * @return address currently approved for the given token ID
388    */
389   function getApproved(uint256 _tokenId) public view returns (address) {
390     return tokenApprovals[_tokenId];
391   }
392 
393   /**
394    * @dev Sets or unsets the approval of a given operator
395    * An operator is allowed to transfer all tokens of the sender on their behalf
396    * @param _to operator address to set the approval
397    * @param _approved representing the status of the approval to be set
398    */
399   function setApprovalForAll(address _to, bool _approved) public {
400     require(_to != msg.sender);
401     operatorApprovals[msg.sender][_to] = _approved;
402     emit ApprovalForAll(msg.sender, _to, _approved);
403   }
404 
405   /**
406    * @dev Tells whether an operator is approved by a given owner
407    * @param _owner owner address which you want to query the approval of
408    * @param _operator operator address which you want to query the approval of
409    * @return bool whether the given operator is approved by the given owner
410    */
411   function isApprovedForAll(
412     address _owner,
413     address _operator
414   )
415     public
416     view
417     returns (bool)
418   {
419     return operatorApprovals[_owner][_operator];
420   }
421 
422   /**
423    * @dev Transfers the ownership of a given token ID to another address
424    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
425    * Requires the msg sender to be the owner, approved, or operator
426    * @param _from current owner of the token
427    * @param _to address to receive the ownership of the given token ID
428    * @param _tokenId uint256 ID of the token to be transferred
429   */
430   function transferFrom(
431     address _from,
432     address _to,
433     uint256 _tokenId
434   )
435     public
436     canTransfer(_tokenId)
437   {
438     require(_from != address(0));
439     require(_to != address(0));
440 
441     clearApproval(_from, _tokenId);
442     removeTokenFrom(_from, _tokenId);
443     addTokenTo(_to, _tokenId);
444 
445     emit Transfer(_from, _to, _tokenId);
446   }
447 
448   /**
449    * @dev Safely transfers the ownership of a given token ID to another address
450    * If the target address is a contract, it must implement `onERC721Received`,
451    * which is called upon a safe transfer, and return the magic value
452    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
453    * the transfer is reverted.
454    *
455    * Requires the msg sender to be the owner, approved, or operator
456    * @param _from current owner of the token
457    * @param _to address to receive the ownership of the given token ID
458    * @param _tokenId uint256 ID of the token to be transferred
459   */
460   function safeTransferFrom(
461     address _from,
462     address _to,
463     uint256 _tokenId
464   )
465     public
466     canTransfer(_tokenId)
467   {
468     // solium-disable-next-line arg-overflow
469     safeTransferFrom(_from, _to, _tokenId, "");
470   }
471 
472   /**
473    * @dev Safely transfers the ownership of a given token ID to another address
474    * If the target address is a contract, it must implement `onERC721Received`,
475    * which is called upon a safe transfer, and return the magic value
476    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
477    * the transfer is reverted.
478    * Requires the msg sender to be the owner, approved, or operator
479    * @param _from current owner of the token
480    * @param _to address to receive the ownership of the given token ID
481    * @param _tokenId uint256 ID of the token to be transferred
482    * @param _data bytes data to send along with a safe transfer check
483    */
484   function safeTransferFrom(
485     address _from,
486     address _to,
487     uint256 _tokenId,
488     bytes _data
489   )
490     public
491     canTransfer(_tokenId)
492   {
493     transferFrom(_from, _to, _tokenId);
494     // solium-disable-next-line arg-overflow
495     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
496   }
497 
498   /**
499    * @dev Returns whether the given spender can transfer a given token ID
500    * @param _spender address of the spender to query
501    * @param _tokenId uint256 ID of the token to be transferred
502    * @return bool whether the msg.sender is approved for the given token ID,
503    *  is an operator of the owner, or is the owner of the token
504    */
505   function isApprovedOrOwner(
506     address _spender,
507     uint256 _tokenId
508   )
509     internal
510     view
511     returns (bool)
512   {
513     address owner = ownerOf(_tokenId);
514     // Disable solium check because of
515     // https://github.com/duaraghav8/Solium/issues/175
516     // solium-disable-next-line operator-whitespace
517     return (
518       _spender == owner ||
519       getApproved(_tokenId) == _spender ||
520       isApprovedForAll(owner, _spender)
521     );
522   }
523 
524   /**
525    * @dev Internal function to mint a new token
526    * Reverts if the given token ID already exists
527    * @param _to The address that will own the minted token
528    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
529    */
530   function _mint(address _to, uint256 _tokenId) internal {
531     require(_to != address(0));
532     addTokenTo(_to, _tokenId);
533     emit Transfer(address(0), _to, _tokenId);
534   }
535 
536   /**
537    * @dev Internal function to burn a specific token
538    * Reverts if the token does not exist
539    * @param _tokenId uint256 ID of the token being burned by the msg.sender
540    */
541   function _burn(address _owner, uint256 _tokenId) internal {
542     clearApproval(_owner, _tokenId);
543     removeTokenFrom(_owner, _tokenId);
544     emit Transfer(_owner, address(0), _tokenId);
545   }
546 
547   /**
548    * @dev Internal function to clear current approval of a given token ID
549    * Reverts if the given address is not indeed the owner of the token
550    * @param _owner owner of the token
551    * @param _tokenId uint256 ID of the token to be transferred
552    */
553   function clearApproval(address _owner, uint256 _tokenId) internal {
554     require(ownerOf(_tokenId) == _owner);
555     if (tokenApprovals[_tokenId] != address(0)) {
556       tokenApprovals[_tokenId] = address(0);
557     }
558   }
559 
560   /**
561    * @dev Internal function to add a token ID to the list of a given address
562    * @param _to address representing the new owner of the given token ID
563    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
564    */
565   function addTokenTo(address _to, uint256 _tokenId) internal {
566     require(tokenOwner[_tokenId] == address(0));
567     tokenOwner[_tokenId] = _to;
568     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
569   }
570 
571   /**
572    * @dev Internal function to remove a token ID from the list of a given address
573    * @param _from address representing the previous owner of the given token ID
574    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
575    */
576   function removeTokenFrom(address _from, uint256 _tokenId) internal {
577     require(ownerOf(_tokenId) == _from);
578     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
579     tokenOwner[_tokenId] = address(0);
580   }
581 
582   /**
583    * @dev Internal function to invoke `onERC721Received` on a target address
584    * The call is not executed if the target address is not a contract
585    * @param _from address representing the previous owner of the given token ID
586    * @param _to target address that will receive the tokens
587    * @param _tokenId uint256 ID of the token to be transferred
588    * @param _data bytes optional data to send along with the call
589    * @return whether the call correctly returned the expected magic value
590    */
591   function checkAndCallSafeTransfer(
592     address _from,
593     address _to,
594     uint256 _tokenId,
595     bytes _data
596   )
597     internal
598     returns (bool)
599   {
600     if (!_to.isContract()) {
601       return true;
602     }
603     bytes4 retval = ERC721Receiver(_to).onERC721Received(
604       msg.sender, _from, _tokenId, _data);
605     return (retval == ERC721_RECEIVED);
606   }
607 }
608 
609 /**
610  * @title Full ERC721 Token
611  * This implementation includes all the required and some optional functionality of the ERC721 standard
612  * Moreover, it includes approve all functionality using operator terminology
613  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
614  */
615 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
616 
617   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
618   /**
619    * 0x780e9d63 ===
620    *   bytes4(keccak256('totalSupply()')) ^
621    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
622    *   bytes4(keccak256('tokenByIndex(uint256)'))
623    */
624 
625   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
626   /**
627    * 0x5b5e139f ===
628    *   bytes4(keccak256('name()')) ^
629    *   bytes4(keccak256('symbol()')) ^
630    *   bytes4(keccak256('tokenURI(uint256)'))
631    */
632 
633   // Token name
634   string internal name_;
635 
636   // Token symbol
637   string internal symbol_;
638 
639   // Mapping from owner to list of owned token IDs
640   mapping(address => uint256[]) internal ownedTokens;
641 
642   // Mapping from token ID to index of the owner tokens list
643   mapping(uint256 => uint256) internal ownedTokensIndex;
644 
645   // Array with all token ids, used for enumeration
646   uint256[] internal allTokens;
647 
648   // Mapping from token id to position in the allTokens array
649   mapping(uint256 => uint256) internal allTokensIndex;
650 
651   // Optional mapping for token URIs
652   mapping(uint256 => string) internal tokenURIs;
653 
654   /**
655    * @dev Constructor function
656    */
657   constructor(string _name, string _symbol) public {
658     name_ = _name;
659     symbol_ = _symbol;
660 
661     // register the supported interfaces to conform to ERC721 via ERC165
662     _registerInterface(InterfaceId_ERC721Enumerable);
663     _registerInterface(InterfaceId_ERC721Metadata);
664   }
665 
666   /**
667    * @dev Gets the token name
668    * @return string representing the token name
669    */
670   function name() external view returns (string) {
671     return name_;
672   }
673 
674   /**
675    * @dev Gets the token symbol
676    * @return string representing the token symbol
677    */
678   function symbol() external view returns (string) {
679     return symbol_;
680   }
681 
682   /**
683    * @dev Returns an URI for a given token ID
684    * Throws if the token ID does not exist. May return an empty string.
685    * @param _tokenId uint256 ID of the token to query
686    */
687   function tokenURI(uint256 _tokenId) public view returns (string) {
688     require(exists(_tokenId));
689     return tokenURIs[_tokenId];
690   }
691 
692   /**
693    * @dev Gets the token ID at a given index of the tokens list of the requested owner
694    * @param _owner address owning the tokens list to be accessed
695    * @param _index uint256 representing the index to be accessed of the requested tokens list
696    * @return uint256 token ID at the given index of the tokens list owned by the requested address
697    */
698   function tokenOfOwnerByIndex(
699     address _owner,
700     uint256 _index
701   )
702     public
703     view
704     returns (uint256)
705   {
706     require(_index < balanceOf(_owner));
707     return ownedTokens[_owner][_index];
708   }
709 
710   /**
711    * @dev Gets the total amount of tokens stored by the contract
712    * @return uint256 representing the total amount of tokens
713    */
714   function totalSupply() public view returns (uint256) {
715     return allTokens.length;
716   }
717 
718   /**
719    * @dev Gets the token ID at a given index of all the tokens in this contract
720    * Reverts if the index is greater or equal to the total number of tokens
721    * @param _index uint256 representing the index to be accessed of the tokens list
722    * @return uint256 token ID at the given index of the tokens list
723    */
724   function tokenByIndex(uint256 _index) public view returns (uint256) {
725     require(_index < totalSupply());
726     return allTokens[_index];
727   }
728 
729   /**
730    * @dev Internal function to set the token URI for a given token
731    * Reverts if the token ID does not exist
732    * @param _tokenId uint256 ID of the token to set its URI
733    * @param _uri string URI to assign
734    */
735   function _setTokenURI(uint256 _tokenId, string _uri) internal {
736     require(exists(_tokenId));
737     tokenURIs[_tokenId] = _uri;
738   }
739 
740   /**
741    * @dev Internal function to add a token ID to the list of a given address
742    * @param _to address representing the new owner of the given token ID
743    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
744    */
745   function addTokenTo(address _to, uint256 _tokenId) internal {
746     super.addTokenTo(_to, _tokenId);
747     uint256 length = ownedTokens[_to].length;
748     ownedTokens[_to].push(_tokenId);
749     ownedTokensIndex[_tokenId] = length;
750   }
751 
752   /**
753    * @dev Internal function to remove a token ID from the list of a given address
754    * @param _from address representing the previous owner of the given token ID
755    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
756    */
757   function removeTokenFrom(address _from, uint256 _tokenId) internal {
758     super.removeTokenFrom(_from, _tokenId);
759 
760     uint256 tokenIndex = ownedTokensIndex[_tokenId];
761     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
762     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
763 
764     ownedTokens[_from][tokenIndex] = lastToken;
765     ownedTokens[_from][lastTokenIndex] = 0;
766     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
767     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
768     // the lastToken to the first position, and then dropping the element placed in the last position of the list
769 
770     ownedTokens[_from].length--;
771     ownedTokensIndex[_tokenId] = 0;
772     ownedTokensIndex[lastToken] = tokenIndex;
773   }
774 
775   /**
776    * @dev Internal function to mint a new token
777    * Reverts if the given token ID already exists
778    * @param _to address the beneficiary that will own the minted token
779    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
780    */
781   function _mint(address _to, uint256 _tokenId) internal {
782     super._mint(_to, _tokenId);
783 
784     allTokensIndex[_tokenId] = allTokens.length;
785     allTokens.push(_tokenId);
786   }
787 
788   /**
789    * @dev Internal function to burn a specific token
790    * Reverts if the token does not exist
791    * @param _owner owner of the token to burn
792    * @param _tokenId uint256 ID of the token being burned by the msg.sender
793    */
794   function _burn(address _owner, uint256 _tokenId) internal {
795     super._burn(_owner, _tokenId);
796 
797     // Clear metadata (if any)
798     if (bytes(tokenURIs[_tokenId]).length != 0) {
799       delete tokenURIs[_tokenId];
800     }
801 
802     // Reorg all tokens array
803     uint256 tokenIndex = allTokensIndex[_tokenId];
804     uint256 lastTokenIndex = allTokens.length.sub(1);
805     uint256 lastToken = allTokens[lastTokenIndex];
806 
807     allTokens[tokenIndex] = lastToken;
808     allTokens[lastTokenIndex] = 0;
809 
810     allTokens.length--;
811     allTokensIndex[_tokenId] = 0;
812     allTokensIndex[lastToken] = tokenIndex;
813   }
814 
815 }
816 
817 /**
818  * @title Ownable
819  * @dev The Ownable contract has an owner address, and provides basic authorization control
820  * functions, this simplifies the implementation of "user permissions".
821  */
822 contract Ownable {
823   address public owner;
824 
825 
826   event OwnershipRenounced(address indexed previousOwner);
827   event OwnershipTransferred(
828     address indexed previousOwner,
829     address indexed newOwner
830   );
831 
832 
833   /**
834    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
835    * account.
836    */
837   constructor() public {
838     owner = msg.sender;
839   }
840 
841   /**
842    * @dev Throws if called by any account other than the owner.
843    */
844   modifier onlyOwner() {
845     require(msg.sender == owner);
846     _;
847   }
848 
849   /**
850    * @dev Allows the current owner to relinquish control of the contract.
851    * @notice Renouncing to ownership will leave the contract without an owner.
852    * It will not be possible to call the functions with the `onlyOwner`
853    * modifier anymore.
854    */
855   function renounceOwnership() public onlyOwner {
856     emit OwnershipRenounced(owner);
857     owner = address(0);
858   }
859 
860   /**
861    * @dev Allows the current owner to transfer control of the contract to a newOwner.
862    * @param _newOwner The address to transfer ownership to.
863    */
864   function transferOwnership(address _newOwner) public onlyOwner {
865     _transferOwnership(_newOwner);
866   }
867 
868   /**
869    * @dev Transfers control of the contract to a newOwner.
870    * @param _newOwner The address to transfer ownership to.
871    */
872   function _transferOwnership(address _newOwner) internal {
873     require(_newOwner != address(0));
874     emit OwnershipTransferred(owner, _newOwner);
875     owner = _newOwner;
876   }
877 }
878 
879 contract Operatable is Ownable {
880 
881     address public operator;
882 
883     event LogOperatorChanged(address indexed from, address indexed to);
884 
885     modifier isValidOperator(address _operator) {
886         require(_operator != address(0));
887         _;
888     }
889 
890     modifier onlyOperator() {
891         require(msg.sender == operator);
892         _;
893     }
894 
895     constructor(address _owner, address _operator) public isValidOperator(_operator) {
896         require(_owner != address(0));
897         
898         owner = _owner;
899         operator = _operator;
900     }
901 
902     function setOperator(address _operator) public onlyOwner isValidOperator(_operator) {
903         emit LogOperatorChanged(operator, _operator);
904         operator = _operator;
905     }
906 }
907 
908 contract CryptoTakeoversNFT is ERC721Token("CryptoTakeoversNFT",""), Operatable {
909     
910     event LogGameOperatorChanged(address indexed from, address indexed to);
911 
912     address public gameOperator;
913 
914     modifier onlyGameOperator() {
915         assert(gameOperator != address(0));
916         require(msg.sender == gameOperator);
917         _;
918     }
919 
920     constructor (address _owner, address _operator) Operatable(_owner, _operator) public {
921     }
922 
923     function mint(uint256 _tokenId, string _tokenURI) public onlyGameOperator {
924         super._mint(operator, _tokenId);
925         super._setTokenURI(_tokenId, _tokenURI);
926     }
927 
928     function hostileTakeover(address _to, uint256 _tokenId) public onlyGameOperator {
929         address tokenOwner = super.ownerOf(_tokenId);
930         operatorApprovals[tokenOwner][gameOperator] = true;
931         super.safeTransferFrom(tokenOwner, _to, _tokenId);
932     }
933 
934     function setGameOperator(address _gameOperator) public onlyOperator {
935         emit LogGameOperatorChanged(gameOperator, _gameOperator);
936         gameOperator = _gameOperator;
937     }
938 
939     function burn(uint256 _tokenId) public onlyGameOperator {
940         super._burn(operator, _tokenId);
941     }
942 }