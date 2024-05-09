1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/AddressUtils.sol
4 
5 /**
6  * Utility library of inline functions on addresses
7  */
8 library AddressUtils {
9 
10   /**
11    * Returns whether the target address is a contract
12    * @dev This function will return false if invoked during the constructor of a contract,
13    * as the code is not actually created until after the constructor finishes.
14    * @param _addr address to check
15    * @return whether the target address is a contract
16    */
17   function isContract(address _addr) internal view returns (bool) {
18     uint256 size;
19     // XXX Currently there is no better way to check if there is a contract in an address
20     // than to check the size of the code at that address.
21     // See https://ethereum.stackexchange.com/a/14016/36603
22     // for more details about how this works.
23     // TODO Check this again before the Serenity release, because all addresses will be
24     // contracts then.
25     // solium-disable-next-line security/no-inline-assembly
26     assembly { size := extcodesize(_addr) }
27     return size > 0;
28   }
29 
30 }
31 
32 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
33 
34 /**
35  * @title ERC165
36  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
37  */
38 interface ERC165 {
39 
40   /**
41    * @notice Query if a contract implements an interface
42    * @param _interfaceId The interface identifier, as specified in ERC-165
43    * @dev Interface identification is specified in ERC-165. This function
44    * uses less than 30,000 gas.
45    */
46   function supportsInterface(bytes4 _interfaceId)
47     external
48     view
49     returns (bool);
50 }
51 
52 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
53 
54 /**
55  * @title ERC721 Non-Fungible Token Standard basic interface
56  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
57  */
58 contract ERC721Basic is ERC165 {
59 
60   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
61   /*
62    * 0x80ac58cd ===
63    *   bytes4(keccak256('balanceOf(address)')) ^
64    *   bytes4(keccak256('ownerOf(uint256)')) ^
65    *   bytes4(keccak256('approve(address,uint256)')) ^
66    *   bytes4(keccak256('getApproved(uint256)')) ^
67    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
68    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
69    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
70    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
71    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
72    */
73 
74   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
75   /*
76    * 0x4f558e79 ===
77    *   bytes4(keccak256('exists(uint256)'))
78    */
79 
80   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
81   /**
82    * 0x780e9d63 ===
83    *   bytes4(keccak256('totalSupply()')) ^
84    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
85    *   bytes4(keccak256('tokenByIndex(uint256)'))
86    */
87 
88   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
89   /**
90    * 0x5b5e139f ===
91    *   bytes4(keccak256('name()')) ^
92    *   bytes4(keccak256('symbol()')) ^
93    *   bytes4(keccak256('tokenURI(uint256)'))
94    */
95 
96   event Transfer(
97     address indexed _from,
98     address indexed _to,
99     uint256 indexed _tokenId
100   );
101   event Approval(
102     address indexed _owner,
103     address indexed _approved,
104     uint256 indexed _tokenId
105   );
106   event ApprovalForAll(
107     address indexed _owner,
108     address indexed _operator,
109     bool _approved
110   );
111 
112   function balanceOf(address _owner) public view returns (uint256 _balance);
113   function ownerOf(uint256 _tokenId) public view returns (address _owner);
114   function exists(uint256 _tokenId) public view returns (bool _exists);
115 
116   function approve(address _to, uint256 _tokenId) public;
117   function getApproved(uint256 _tokenId)
118     public view returns (address _operator);
119 
120   function setApprovalForAll(address _operator, bool _approved) public;
121   function isApprovedForAll(address _owner, address _operator)
122     public view returns (bool);
123 
124   function transferFrom(address _from, address _to, uint256 _tokenId) public;
125   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
126     public;
127 
128   function safeTransferFrom(
129     address _from,
130     address _to,
131     uint256 _tokenId,
132     bytes _data
133   )
134     public;
135 }
136 
137 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
138 
139 /**
140  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
141  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
142  */
143 contract ERC721Enumerable is ERC721Basic {
144   function totalSupply() public view returns (uint256);
145   function tokenOfOwnerByIndex(
146     address _owner,
147     uint256 _index
148   )
149     public
150     view
151     returns (uint256 _tokenId);
152 
153   function tokenByIndex(uint256 _index) public view returns (uint256);
154 }
155 
156 
157 /**
158  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
159  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
160  */
161 contract ERC721Metadata is ERC721Basic {
162   function name() external view returns (string _name);
163   function symbol() external view returns (string _symbol);
164   function tokenURI(uint256 _tokenId) public view returns (string);
165 }
166 
167 
168 /**
169  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
170  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
171  */
172 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
173 }
174 
175 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
176 
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 contract ERC721Receiver {
183   /**
184    * @dev Magic value to be returned upon successful reception of an NFT
185    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
186    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
187    */
188   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
189 
190   /**
191    * @notice Handle the receipt of an NFT
192    * @dev The ERC721 smart contract calls this function on the recipient
193    * after a `safetransfer`. This function MAY throw to revert and reject the
194    * transfer. Return of other than the magic value MUST result in the
195    * transaction being reverted.
196    * Note: the contract address is always the message sender.
197    * @param _operator The address which called `safeTransferFrom` function
198    * @param _from The address which previously owned the token
199    * @param _tokenId The NFT identifier which is being transferred
200    * @param _data Additional data with no specified format
201    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
202    */
203   function onERC721Received(
204     address _operator,
205     address _from,
206     uint256 _tokenId,
207     bytes _data
208   )
209     public
210     returns(bytes4);
211 }
212 
213 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
214 
215 /**
216  * @title SafeMath
217  * @dev Math operations with safety checks that throw on error
218  */
219 library SafeMath {
220 
221   /**
222   * @dev Multiplies two numbers, throws on overflow.
223   */
224   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
225     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
226     // benefit is lost if 'b' is also tested.
227     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
228     if (_a == 0) {
229       return 0;
230     }
231 
232     c = _a * _b;
233     assert(c / _a == _b);
234     return c;
235   }
236 
237   /**
238   * @dev Integer division of two numbers, truncating the quotient.
239   */
240   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
241     // assert(_b > 0); // Solidity automatically throws when dividing by 0
242     // uint256 c = _a / _b;
243     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
244     return _a / _b;
245   }
246 
247   /**
248   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
249   */
250   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
251     assert(_b <= _a);
252     return _a - _b;
253   }
254 
255   /**
256   * @dev Adds two numbers, throws on overflow.
257   */
258   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
259     c = _a + _b;
260     assert(c >= _a);
261     return c;
262   }
263 }
264 
265 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
266 
267 /**
268  * @title SupportsInterfaceWithLookup
269  * @author Matt Condon (@shrugs)
270  * @dev Implements ERC165 using a lookup table.
271  */
272 contract SupportsInterfaceWithLookup is ERC165 {
273 
274   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
275   /**
276    * 0x01ffc9a7 ===
277    *   bytes4(keccak256('supportsInterface(bytes4)'))
278    */
279 
280   /**
281    * @dev a mapping of interface id to whether or not it's supported
282    */
283   mapping(bytes4 => bool) internal supportedInterfaces;
284 
285   /**
286    * @dev A contract implementing SupportsInterfaceWithLookup
287    * implement ERC165 itself
288    */
289   constructor()
290     public
291   {
292     _registerInterface(InterfaceId_ERC165);
293   }
294 
295   /**
296    * @dev implement supportsInterface(bytes4) using a lookup table
297    */
298   function supportsInterface(bytes4 _interfaceId)
299     external
300     view
301     returns (bool)
302   {
303     return supportedInterfaces[_interfaceId];
304   }
305 
306   /**
307    * @dev private method for registering an interface
308    */
309   function _registerInterface(bytes4 _interfaceId)
310     internal
311   {
312     require(_interfaceId != 0xffffffff);
313     supportedInterfaces[_interfaceId] = true;
314   }
315 }
316 
317 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
318 
319 /**
320  * @title ERC721 Non-Fungible Token Standard basic implementation
321  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
322  */
323 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
324 
325   using SafeMath for uint256;
326   using AddressUtils for address;
327 
328   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
329   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
330   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
331 
332   // Mapping from token ID to owner
333   mapping (uint256 => address) internal tokenOwner;
334 
335   // Mapping from token ID to approved address
336   mapping (uint256 => address) internal tokenApprovals;
337 
338   // Mapping from owner to number of owned token
339   mapping (address => uint256) internal ownedTokensCount;
340 
341   // Mapping from owner to operator approvals
342   mapping (address => mapping (address => bool)) internal operatorApprovals;
343 
344   constructor()
345     public
346   {
347     // register the supported interfaces to conform to ERC721 via ERC165
348     _registerInterface(InterfaceId_ERC721);
349     _registerInterface(InterfaceId_ERC721Exists);
350   }
351 
352   /**
353    * @dev Gets the balance of the specified address
354    * @param _owner address to query the balance of
355    * @return uint256 representing the amount owned by the passed address
356    */
357   function balanceOf(address _owner) public view returns (uint256) {
358     require(_owner != address(0));
359     return ownedTokensCount[_owner];
360   }
361 
362   /**
363    * @dev Gets the owner of the specified token ID
364    * @param _tokenId uint256 ID of the token to query the owner of
365    * @return owner address currently marked as the owner of the given token ID
366    */
367   function ownerOf(uint256 _tokenId) public view returns (address) {
368     address owner = tokenOwner[_tokenId];
369     require(owner != address(0));
370     return owner;
371   }
372 
373   /**
374    * @dev Returns whether the specified token exists
375    * @param _tokenId uint256 ID of the token to query the existence of
376    * @return whether the token exists
377    */
378   function exists(uint256 _tokenId) public view returns (bool) {
379     address owner = tokenOwner[_tokenId];
380     return owner != address(0);
381   }
382 
383   /**
384    * @dev Approves another address to transfer the given token ID
385    * The zero address indicates there is no approved address.
386    * There can only be one approved address per token at a given time.
387    * Can only be called by the token owner or an approved operator.
388    * @param _to address to be approved for the given token ID
389    * @param _tokenId uint256 ID of the token to be approved
390    */
391   function approve(address _to, uint256 _tokenId) public {
392     address owner = ownerOf(_tokenId);
393     require(_to != owner);
394     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
395 
396     tokenApprovals[_tokenId] = _to;
397     emit Approval(owner, _to, _tokenId);
398   }
399 
400   /**
401    * @dev Gets the approved address for a token ID, or zero if no address set
402    * @param _tokenId uint256 ID of the token to query the approval of
403    * @return address currently approved for the given token ID
404    */
405   function getApproved(uint256 _tokenId) public view returns (address) {
406     return tokenApprovals[_tokenId];
407   }
408 
409   /**
410    * @dev Sets or unsets the approval of a given operator
411    * An operator is allowed to transfer all tokens of the sender on their behalf
412    * @param _to operator address to set the approval
413    * @param _approved representing the status of the approval to be set
414    */
415   function setApprovalForAll(address _to, bool _approved) public {
416     require(_to != msg.sender);
417     operatorApprovals[msg.sender][_to] = _approved;
418     emit ApprovalForAll(msg.sender, _to, _approved);
419   }
420 
421   /**
422    * @dev Tells whether an operator is approved by a given owner
423    * @param _owner owner address which you want to query the approval of
424    * @param _operator operator address which you want to query the approval of
425    * @return bool whether the given operator is approved by the given owner
426    */
427   function isApprovedForAll(
428     address _owner,
429     address _operator
430   )
431     public
432     view
433     returns (bool)
434   {
435     return operatorApprovals[_owner][_operator];
436   }
437 
438   /**
439    * @dev Transfers the ownership of a given token ID to another address
440    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
441    * Requires the msg sender to be the owner, approved, or operator
442    * @param _from current owner of the token
443    * @param _to address to receive the ownership of the given token ID
444    * @param _tokenId uint256 ID of the token to be transferred
445   */
446   function transferFrom(
447     address _from,
448     address _to,
449     uint256 _tokenId
450   )
451     public
452   {
453     require(isApprovedOrOwner(msg.sender, _tokenId));
454     require(_from != address(0));
455     require(_to != address(0));
456 
457     clearApproval(_from, _tokenId);
458     removeTokenFrom(_from, _tokenId);
459     addTokenTo(_to, _tokenId);
460 
461     emit Transfer(_from, _to, _tokenId);
462   }
463 
464   /**
465    * @dev Safely transfers the ownership of a given token ID to another address
466    * If the target address is a contract, it must implement `onERC721Received`,
467    * which is called upon a safe transfer, and return the magic value
468    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
469    * the transfer is reverted.
470    *
471    * Requires the msg sender to be the owner, approved, or operator
472    * @param _from current owner of the token
473    * @param _to address to receive the ownership of the given token ID
474    * @param _tokenId uint256 ID of the token to be transferred
475   */
476   function safeTransferFrom(
477     address _from,
478     address _to,
479     uint256 _tokenId
480   )
481     public
482   {
483     // solium-disable-next-line arg-overflow
484     safeTransferFrom(_from, _to, _tokenId, "");
485   }
486 
487   /**
488    * @dev Safely transfers the ownership of a given token ID to another address
489    * If the target address is a contract, it must implement `onERC721Received`,
490    * which is called upon a safe transfer, and return the magic value
491    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
492    * the transfer is reverted.
493    * Requires the msg sender to be the owner, approved, or operator
494    * @param _from current owner of the token
495    * @param _to address to receive the ownership of the given token ID
496    * @param _tokenId uint256 ID of the token to be transferred
497    * @param _data bytes data to send along with a safe transfer check
498    */
499   function safeTransferFrom(
500     address _from,
501     address _to,
502     uint256 _tokenId,
503     bytes _data
504   )
505     public
506   {
507     transferFrom(_from, _to, _tokenId);
508     // solium-disable-next-line arg-overflow
509     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
510   }
511 
512   /**
513    * @dev Returns whether the given spender can transfer a given token ID
514    * @param _spender address of the spender to query
515    * @param _tokenId uint256 ID of the token to be transferred
516    * @return bool whether the msg.sender is approved for the given token ID,
517    *  is an operator of the owner, or is the owner of the token
518    */
519   function isApprovedOrOwner(
520     address _spender,
521     uint256 _tokenId
522   )
523     internal
524     view
525     returns (bool)
526   {
527     address owner = ownerOf(_tokenId);
528     // Disable solium check because of
529     // https://github.com/duaraghav8/Solium/issues/175
530     // solium-disable-next-line operator-whitespace
531     return (
532       _spender == owner ||
533       getApproved(_tokenId) == _spender ||
534       isApprovedForAll(owner, _spender)
535     );
536   }
537 
538   /**
539    * @dev Internal function to mint a new token
540    * Reverts if the given token ID already exists
541    * @param _to The address that will own the minted token
542    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
543    */
544   function _mint(address _to, uint256 _tokenId) internal {
545     require(_to != address(0));
546     addTokenTo(_to, _tokenId);
547     emit Transfer(address(0), _to, _tokenId);
548   }
549 
550   /**
551    * @dev Internal function to burn a specific token
552    * Reverts if the token does not exist
553    * @param _tokenId uint256 ID of the token being burned by the msg.sender
554    */
555   function _burn(address _owner, uint256 _tokenId) internal {
556     clearApproval(_owner, _tokenId);
557     removeTokenFrom(_owner, _tokenId);
558     emit Transfer(_owner, address(0), _tokenId);
559   }
560 
561   /**
562    * @dev Internal function to clear current approval of a given token ID
563    * Reverts if the given address is not indeed the owner of the token
564    * @param _owner owner of the token
565    * @param _tokenId uint256 ID of the token to be transferred
566    */
567   function clearApproval(address _owner, uint256 _tokenId) internal {
568     require(ownerOf(_tokenId) == _owner);
569     if (tokenApprovals[_tokenId] != address(0)) {
570       tokenApprovals[_tokenId] = address(0);
571     }
572   }
573 
574   /**
575    * @dev Internal function to add a token ID to the list of a given address
576    * @param _to address representing the new owner of the given token ID
577    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
578    */
579   function addTokenTo(address _to, uint256 _tokenId) internal {
580     require(tokenOwner[_tokenId] == address(0));
581     tokenOwner[_tokenId] = _to;
582     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
583   }
584 
585   /**
586    * @dev Internal function to remove a token ID from the list of a given address
587    * @param _from address representing the previous owner of the given token ID
588    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
589    */
590   function removeTokenFrom(address _from, uint256 _tokenId) internal {
591     require(ownerOf(_tokenId) == _from);
592     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
593     tokenOwner[_tokenId] = address(0);
594   }
595 
596   /**
597    * @dev Internal function to invoke `onERC721Received` on a target address
598    * The call is not executed if the target address is not a contract
599    * @param _from address representing the previous owner of the given token ID
600    * @param _to target address that will receive the tokens
601    * @param _tokenId uint256 ID of the token to be transferred
602    * @param _data bytes optional data to send along with the call
603    * @return whether the call correctly returned the expected magic value
604    */
605   function checkAndCallSafeTransfer(
606     address _from,
607     address _to,
608     uint256 _tokenId,
609     bytes _data
610   )
611     internal
612     returns (bool)
613   {
614     if (!_to.isContract()) {
615       return true;
616     }
617     bytes4 retval = ERC721Receiver(_to).onERC721Received(
618       msg.sender, _from, _tokenId, _data);
619     return (retval == ERC721_RECEIVED);
620   }
621 }
622 
623 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
624 
625 /**
626  * @title Full ERC721 Token
627  * This implementation includes all the required and some optional functionality of the ERC721 standard
628  * Moreover, it includes approve all functionality using operator terminology
629  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
630  */
631 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
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
760     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
761     // then delete the last slot.
762     uint256 tokenIndex = ownedTokensIndex[_tokenId];
763     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
764     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
765 
766     ownedTokens[_from][tokenIndex] = lastToken;
767     // This also deletes the contents at the last position of the array
768     ownedTokens[_from].length--;
769 
770     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
771     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
772     // the lastToken to the first position, and then dropping the element placed in the last position of the list
773 
774     ownedTokensIndex[_tokenId] = 0;
775     ownedTokensIndex[lastToken] = tokenIndex;
776   }
777 
778   /**
779    * @dev Internal function to mint a new token
780    * Reverts if the given token ID already exists
781    * @param _to address the beneficiary that will own the minted token
782    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
783    */
784   function _mint(address _to, uint256 _tokenId) internal {
785     super._mint(_to, _tokenId);
786 
787     allTokensIndex[_tokenId] = allTokens.length;
788     allTokens.push(_tokenId);
789   }
790 
791   /**
792    * @dev Internal function to burn a specific token
793    * Reverts if the token does not exist
794    * @param _owner owner of the token to burn
795    * @param _tokenId uint256 ID of the token being burned by the msg.sender
796    */
797   function _burn(address _owner, uint256 _tokenId) internal {
798     super._burn(_owner, _tokenId);
799 
800     // Clear metadata (if any)
801     if (bytes(tokenURIs[_tokenId]).length != 0) {
802       delete tokenURIs[_tokenId];
803     }
804 
805     // Reorg all tokens array
806     uint256 tokenIndex = allTokensIndex[_tokenId];
807     uint256 lastTokenIndex = allTokens.length.sub(1);
808     uint256 lastToken = allTokens[lastTokenIndex];
809 
810     allTokens[tokenIndex] = lastToken;
811     allTokens[lastTokenIndex] = 0;
812 
813     allTokens.length--;
814     allTokensIndex[_tokenId] = 0;
815     allTokensIndex[lastToken] = tokenIndex;
816   }
817 
818 }
819 
820 // File: contracts/IMarketplace.sol
821 
822 contract IMarketplace {
823     function createAuction(
824         uint256 _tokenId,
825         uint128 startPrice,
826         uint128 endPrice,
827         uint128 duration
828     )
829         external;
830 }
831 
832 // File: contracts/GameData.sol
833 
834 contract GameData {
835     struct Country {       
836         bytes2 isoCode;
837         uint8 animalsCount;
838         uint256[3] animalIds;
839     }
840 
841     struct Animal {
842         bool isSold;
843         uint256 currentValue;
844         uint8 rarity; // 0-4, rarity = stat range, higher rarity = better stats
845 
846         bytes32 name;         
847         uint256 countryId; // country of origin
848 
849     }
850 
851     struct Dna {
852         uint256 animalId; 
853         uint8 effectiveness; //  1 - 100, 100 = same stats as a wild card
854     }    
855 }
856 
857 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
858 
859 /**
860  * @title Ownable
861  * @dev The Ownable contract has an owner address, and provides basic authorization control
862  * functions, this simplifies the implementation of "user permissions".
863  */
864 contract Ownable {
865   address public owner;
866 
867 
868   event OwnershipRenounced(address indexed previousOwner);
869   event OwnershipTransferred(
870     address indexed previousOwner,
871     address indexed newOwner
872   );
873 
874 
875   /**
876    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
877    * account.
878    */
879   constructor() public {
880     owner = msg.sender;
881   }
882 
883   /**
884    * @dev Throws if called by any account other than the owner.
885    */
886   modifier onlyOwner() {
887     require(msg.sender == owner);
888     _;
889   }
890 
891   /**
892    * @dev Allows the current owner to relinquish control of the contract.
893    * @notice Renouncing to ownership will leave the contract without an owner.
894    * It will not be possible to call the functions with the `onlyOwner`
895    * modifier anymore.
896    */
897   function renounceOwnership() public onlyOwner {
898     emit OwnershipRenounced(owner);
899     owner = address(0);
900   }
901 
902   /**
903    * @dev Allows the current owner to transfer control of the contract to a newOwner.
904    * @param _newOwner The address to transfer ownership to.
905    */
906   function transferOwnership(address _newOwner) public onlyOwner {
907     _transferOwnership(_newOwner);
908   }
909 
910   /**
911    * @dev Transfers control of the contract to a newOwner.
912    * @param _newOwner The address to transfer ownership to.
913    */
914   function _transferOwnership(address _newOwner) internal {
915     require(_newOwner != address(0));
916     emit OwnershipTransferred(owner, _newOwner);
917     owner = _newOwner;
918   }
919 }
920 
921 // File: contracts/Restricted.sol
922 
923 contract Restricted is Ownable {
924     mapping(address => bool) private addressIsAdmin;
925     bool private isActive = true;
926 
927     modifier onlyAdmin() {
928         require(addressIsAdmin[msg.sender] || msg.sender == owner);
929         _;
930     }
931 
932     modifier contractIsActive() {
933         require(isActive);
934         _;
935     }
936 
937     function addAdmin(address adminAddress) public onlyOwner {
938         addressIsAdmin[adminAddress] = true;
939     }
940 
941     function removeAdmin(address adminAddress) public onlyOwner {
942         addressIsAdmin[adminAddress] = false;
943     }
944 
945     function pauseContract() public onlyOwner {
946         isActive = false;
947     }
948 
949     function activateContract() public onlyOwner {
950         isActive = true;
951     }
952 }
953 
954 // File: contracts/CryptoServal.sol
955 
956 contract CryptoServal is ERC721Token("CryptoServal", "CS"), GameData, Restricted {
957 
958     using AddressUtils for address;
959 
960     uint8 internal developersFee = 5;
961     uint256[3] internal rarityTargetValue = [0.5 ether, 1 ether, 2 ether];
962 
963     Country[] internal countries;
964     Animal[] internal animals;
965     Dna[] internal dnas;
966 
967     using SafeMath for uint256;
968 
969     event AnimalBoughtEvent(
970         uint256 animalId,
971         address previousOwner,
972         address newOwner,
973         uint256 pricePaid,
974         bool isSold
975     );
976 
977     mapping (address => uint256) private addressToDnaCount;
978 
979     mapping (uint => address) private dnaIdToOwnerAddress;
980 
981     uint256 private startingAnimalPrice = 0.001 ether;
982 
983     IMarketplace private marketplaceContract;
984 
985     bool private shouldGenerateDna = true;
986 
987     modifier validTokenId(uint256 _tokenId) {
988         require(_tokenId < animals.length);
989         _;
990     }
991 
992     modifier soldOnly(uint256 _tokenId) {
993         require(animals[_tokenId].isSold);
994         _;
995     }
996 
997     modifier isNotFromContract() {
998         require(!msg.sender.isContract());
999         _;
1000     }
1001 
1002     function () public payable {
1003     }
1004 
1005     function createAuction(
1006         uint256 _tokenId,
1007         uint128 startPrice,
1008         uint128 endPrice,
1009         uint128 duration
1010     )
1011         external
1012         isNotFromContract
1013     {
1014         // approve, not a transfer, let marketplace confirm the original owner and take ownership
1015         approve(address(marketplaceContract), _tokenId);
1016         marketplaceContract.createAuction(_tokenId, startPrice, endPrice, duration);
1017     }
1018 
1019     function setMarketplaceContract(address marketplaceAddress) external onlyOwner {
1020         marketplaceContract = IMarketplace(marketplaceAddress);
1021     }
1022 
1023     function getPlayerAnimals(address playerAddress)
1024         external
1025         view
1026         returns(uint256[])
1027     {
1028         uint256 animalsOwned = ownedTokensCount[playerAddress];
1029         uint256[] memory playersAnimals = new uint256[](animalsOwned);
1030 
1031         if (animalsOwned == 0) {
1032             return playersAnimals;
1033         }
1034 
1035         uint256 animalsLength = animals.length;
1036         uint256 playersAnimalsIndex = 0;
1037         uint256 animalId = 0;
1038         while (playersAnimalsIndex < animalsOwned && animalId < animalsLength) {
1039             if (tokenOwner[animalId] == playerAddress) {
1040                 playersAnimals[playersAnimalsIndex] = animalId;
1041                 playersAnimalsIndex++;
1042             }
1043             animalId++;
1044         }
1045 
1046         return playersAnimals;
1047     }
1048 
1049     function getPlayerDnas(address playerAddress) external view returns(uint256[]) {
1050         uint256 dnasOwned = addressToDnaCount[playerAddress];
1051         uint256[] memory playersDnas = new uint256[](dnasOwned);
1052 
1053         if (dnasOwned == 0) {
1054             return playersDnas;
1055         }
1056 
1057         uint256 dnasLength = dnas.length;
1058         uint256 playersDnasIndex = 0;
1059         uint256 dnaId = 0;
1060         while (playersDnasIndex < dnasOwned && dnaId < dnasLength) {
1061             if (dnaIdToOwnerAddress[dnaId] == playerAddress) {
1062                 playersDnas[playersDnasIndex] = dnaId;
1063                 playersDnasIndex++;
1064             }
1065             dnaId++;
1066         }
1067 
1068         return playersDnas;
1069     }
1070 
1071     function transferFrom(address _from, address _to, uint256 _tokenId)
1072         public
1073         validTokenId(_tokenId)
1074         soldOnly(_tokenId)
1075     {
1076         super.transferFrom(_from, _to, _tokenId);
1077     }
1078 
1079     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
1080         public
1081         validTokenId(_tokenId)
1082         soldOnly(_tokenId)
1083     {
1084         super.safeTransferFrom(_from, _to, _tokenId);
1085     }
1086 
1087     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data)
1088         public
1089         validTokenId(_tokenId)
1090         soldOnly(_tokenId)
1091     {
1092         super.safeTransferFrom(_from, _to, _tokenId, _data);
1093     }
1094 
1095     function buyAnimal(uint256 id) public payable isNotFromContract contractIsActive {
1096         uint256 etherSent = msg.value;
1097         address sender = msg.sender;
1098 
1099         Animal storage animalToBuy = animals[id];
1100 
1101         require(etherSent >= animalToBuy.currentValue);
1102         require(tokenOwner[id] != sender);
1103         require(!animalToBuy.isSold);
1104         uint256 etherToPay = animalToBuy.currentValue;
1105         uint256 etherToRefund = etherSent.sub(etherToPay);
1106         address previousOwner = tokenOwner[id];
1107 
1108         // Inlined transferFrom
1109         clearApproval(previousOwner, id);
1110         removeTokenFrom(previousOwner, id);
1111         addTokenTo(sender, id);
1112 
1113         emit Transfer(previousOwner, sender, id);
1114         //
1115 
1116         // subtract developers fee
1117         uint256 ownersShare = etherToPay.sub(etherToPay * developersFee / 100);
1118         // pay previous owner
1119         previousOwner.transfer(ownersShare);
1120         // refund overpaid ether
1121         refundSender(sender, etherToRefund);
1122 
1123         // If the bid is above the target price, lock the buying via this contract and enable ERC721
1124         if (etherToPay >= rarityTargetValue[animalToBuy.rarity]) {
1125             animalToBuy.isSold = true;
1126             animalToBuy.currentValue = 0;
1127         } else {
1128             // calculate new value, multiplier depends on current amount of ether
1129             animalToBuy.currentValue = calculateNextEtherValue(animalToBuy.currentValue);
1130         }
1131 
1132         if (shouldGenerateDna) {
1133             generateDna(sender, id, etherToPay, animalToBuy);
1134         }
1135         emit AnimalBoughtEvent(id, previousOwner, sender, etherToPay, animalToBuy.isSold);
1136     }
1137 
1138     function getAnimal(uint256 _animalId)
1139         public
1140         view
1141         returns(
1142             uint256 countryId,
1143             bytes32 name,
1144             uint8 rarity,
1145             uint256 currentValue,
1146             uint256 targetValue,
1147             address owner,
1148             uint256 id
1149         )
1150     {
1151         Animal storage animal = animals[_animalId];
1152         return (
1153             animal.countryId,
1154             animal.name,
1155             animal.rarity,
1156             animal.currentValue,
1157             rarityTargetValue[animal.rarity],
1158             tokenOwner[_animalId],
1159             _animalId
1160         );
1161     }
1162 
1163     function getAnimalsCount() public view returns(uint256 animalsCount) {
1164         return animals.length;
1165     }
1166 
1167     function getDna(uint256 _dnaId)
1168         public
1169         view
1170         returns(
1171             uint animalId,
1172             address owner,
1173             uint16 effectiveness,
1174             uint256 id
1175         )
1176     {
1177         Dna storage dna = dnas[_dnaId];
1178         return (dna.animalId, dnaIdToOwnerAddress[_dnaId], dna.effectiveness, _dnaId);
1179     }
1180 
1181     function getDnasCount() public view returns(uint256) {
1182         return dnas.length;
1183     }
1184 
1185     function getCountry(uint256 _countryId)
1186         public
1187         view
1188         returns(
1189             bytes2 isoCode,
1190             uint8 animalsCount,
1191             uint256[3] animalIds,
1192             uint256 id
1193         )
1194     {
1195         Country storage country = countries[_countryId];
1196         return(country.isoCode, country.animalsCount, country.animalIds, _countryId);
1197     }
1198 
1199     function getCountriesCount() public view returns(uint256 countriesCount) {
1200         return countries.length;
1201     }
1202 
1203     function getDevelopersFee() public view returns(uint8) {
1204         return developersFee;
1205     }
1206 
1207     function getMarketplaceContract() public view returns(address) {
1208         return marketplaceContract;
1209     }
1210 
1211     function getShouldGenerateDna() public view returns(bool) {
1212         return shouldGenerateDna;
1213     }
1214 
1215     function withdrawContract() public onlyOwner {
1216         msg.sender.transfer(address(this).balance);
1217     }
1218 
1219     function setDevelopersFee(uint8 _developersFee) public onlyOwner {
1220         require((_developersFee >= 0) && (_developersFee <= 8));
1221         developersFee = _developersFee;
1222     }
1223 
1224     function setShouldGenerateDna(bool _shouldGenerateDna) public onlyAdmin {
1225         shouldGenerateDna = _shouldGenerateDna;
1226     }
1227 
1228     function addCountry(bytes2 isoCode) public onlyAdmin {
1229         Country memory country;
1230         country.isoCode = isoCode;
1231         countries.push(country);
1232     }
1233 
1234     function addAnimal(uint256 countryId, bytes32 animalName, uint8 rarity) public onlyAdmin {
1235         require((rarity >= 0) && (rarity < 3));
1236         Country storage country = countries[countryId];
1237 
1238         uint256 id = animals.length; // id is assigned before push
1239 
1240         Animal memory animal = Animal(
1241             false, // new animal is not sold yet
1242             startingAnimalPrice,
1243             rarity,
1244             animalName,
1245             countryId
1246         );
1247 
1248         animals.push(animal);
1249         addAnimalIdToCountry(id, country);
1250         _mint(address(this), id);
1251     }
1252 
1253     function changeCountry(uint256 id, bytes2 isoCode) public onlyAdmin {
1254         Country storage country = countries[id];
1255         country.isoCode = isoCode;
1256     }
1257 
1258     function changeAnimal(uint256 animalId, uint256 countryId, bytes32 name, uint8 rarity)
1259         public
1260         onlyAdmin
1261     {
1262         require(countryId < countries.length);
1263         Animal storage animal = animals[animalId];
1264         if (animal.name != name) {
1265             animal.name = name;
1266         }
1267         if (animal.rarity != rarity) {
1268             require((rarity >= 0) && (rarity < 3));
1269             animal.rarity = rarity;
1270         }
1271         if (animal.countryId != countryId) {
1272             Country storage country = countries[countryId];
1273 
1274             uint256 oldCountryId = animal.countryId;
1275 
1276             addAnimalIdToCountry(animalId, country);
1277             removeAnimalIdFromCountry(animalId, oldCountryId);
1278 
1279             animal.countryId = countryId;
1280         }
1281     }
1282 
1283     function setRarityTargetValue(uint8 index, uint256 targetValue) public onlyAdmin {
1284         rarityTargetValue[index] = targetValue;
1285     }
1286 
1287     function calculateNextEtherValue(uint256 currentEtherValue) public pure returns(uint256) {
1288         if (currentEtherValue < 0.1 ether) {
1289             return currentEtherValue.mul(2);
1290         } else if (currentEtherValue < 0.5 ether) {
1291             return currentEtherValue.mul(3).div(2); // x1.5
1292         } else if (currentEtherValue < 1 ether) {
1293             return currentEtherValue.mul(4).div(3); // x1.33
1294         } else if (currentEtherValue < 5 ether) {
1295             return currentEtherValue.mul(5).div(4); // x1.25
1296         } else if (currentEtherValue < 10 ether) {
1297             return currentEtherValue.mul(6).div(5); // x1.2
1298         } else {
1299             return currentEtherValue.mul(7).div(6); // 1.16
1300         }
1301     }
1302 
1303     function refundSender(address sender, uint256 etherToRefund) private {
1304         if (etherToRefund > 0) {
1305             sender.transfer(etherToRefund);
1306         }
1307     }
1308 
1309     function generateDna(
1310         address sender,
1311         uint256 animalId,
1312         uint256 pricePaid,
1313         Animal animal
1314     )
1315         private
1316     {
1317         uint256 id = dnas.length; // id is assigned before push
1318         Dna memory dna = Dna(
1319             animalId,
1320             calculateAnimalEffectiveness(pricePaid, animal)
1321         );
1322 
1323         dnas.push(dna);
1324 
1325         dnaIdToOwnerAddress[id] = sender;
1326         addressToDnaCount[sender] = addressToDnaCount[sender].add(1);
1327     }
1328 
1329     function calculateAnimalEffectiveness(
1330         uint256 pricePaid,
1331         Animal animal
1332     )
1333         private
1334         view
1335         returns(uint8)
1336     {
1337         if (animal.isSold) {
1338             return 100;
1339         }
1340 
1341         uint256 effectiveness = 10; // 10-90;
1342         // more common the animal = cheaper effectiveness
1343         uint256 effectivenessPerEther = 10**18 * 80 / rarityTargetValue[animal.rarity];
1344         effectiveness = effectiveness.add(pricePaid * effectivenessPerEther / 10**18);
1345 
1346         if (effectiveness > 90) {
1347             effectiveness = 90;
1348         }
1349 
1350         return uint8(effectiveness);
1351     }
1352 
1353     function addAnimalIdToCountry(
1354         uint256 animalId,
1355         Country storage country
1356     )
1357         private
1358     {
1359         uint8 animalSlotIndex = country.animalsCount;
1360         require(animalSlotIndex < 3);
1361         country.animalIds[animalSlotIndex] = animalId;
1362         country.animalsCount += 1;
1363     }
1364 
1365     function removeAnimalIdFromCountry(uint256 animalId, uint256 countryId) private {
1366         Country storage country = countries[countryId];
1367         for (uint8 i = 0; i < country.animalsCount; i++) {
1368             if (country.animalIds[i] == animalId) {
1369                 if (i != country.animalsCount - 1) {
1370                     country.animalIds[i] = country.animalIds[country.animalsCount - 1];
1371                 }
1372                 country.animalsCount -= 1;
1373                 return;
1374             }
1375         }
1376     }
1377 }