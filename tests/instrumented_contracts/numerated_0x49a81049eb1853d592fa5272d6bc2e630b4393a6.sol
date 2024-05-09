1 pragma solidity 0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
4 
5 /**
6  * @title ERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface ERC165 {
10 
11   /**
12    * @notice Query if a contract implements an interface
13    * @param _interfaceId The interface identifier, as specified in ERC-165
14    * @dev Interface identification is specified in ERC-165. This function
15    * uses less than 30,000 gas.
16    */
17   function supportsInterface(bytes4 _interfaceId)
18     external
19     view
20     returns (bool);
21 }
22 
23 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
24 
25 /**
26  * @title SupportsInterfaceWithLookup
27  * @author Matt Condon (@shrugs)
28  * @dev Implements ERC165 using a lookup table.
29  */
30 contract SupportsInterfaceWithLookup is ERC165 {
31 
32   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
33   /**
34    * 0x01ffc9a7 ===
35    *   bytes4(keccak256('supportsInterface(bytes4)'))
36    */
37 
38   /**
39    * @dev a mapping of interface id to whether or not it's supported
40    */
41   mapping(bytes4 => bool) internal supportedInterfaces;
42 
43   /**
44    * @dev A contract implementing SupportsInterfaceWithLookup
45    * implement ERC165 itself
46    */
47   constructor()
48     public
49   {
50     _registerInterface(InterfaceId_ERC165);
51   }
52 
53   /**
54    * @dev implement supportsInterface(bytes4) using a lookup table
55    */
56   function supportsInterface(bytes4 _interfaceId)
57     external
58     view
59     returns (bool)
60   {
61     return supportedInterfaces[_interfaceId];
62   }
63 
64   /**
65    * @dev private method for registering an interface
66    */
67   function _registerInterface(bytes4 _interfaceId)
68     internal
69   {
70     require(_interfaceId != 0xffffffff);
71     supportedInterfaces[_interfaceId] = true;
72   }
73 }
74 
75 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
76 
77 /**
78  * @title ERC721 Non-Fungible Token Standard basic interface
79  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
80  */
81 contract ERC721Basic is ERC165 {
82 
83   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
84   /*
85    * 0x80ac58cd ===
86    *   bytes4(keccak256('balanceOf(address)')) ^
87    *   bytes4(keccak256('ownerOf(uint256)')) ^
88    *   bytes4(keccak256('approve(address,uint256)')) ^
89    *   bytes4(keccak256('getApproved(uint256)')) ^
90    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
91    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
92    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
93    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
94    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
95    */
96 
97   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
98   /*
99    * 0x4f558e79 ===
100    *   bytes4(keccak256('exists(uint256)'))
101    */
102 
103   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
104   /**
105    * 0x780e9d63 ===
106    *   bytes4(keccak256('totalSupply()')) ^
107    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
108    *   bytes4(keccak256('tokenByIndex(uint256)'))
109    */
110 
111   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
112   /**
113    * 0x5b5e139f ===
114    *   bytes4(keccak256('name()')) ^
115    *   bytes4(keccak256('symbol()')) ^
116    *   bytes4(keccak256('tokenURI(uint256)'))
117    */
118 
119   event Transfer(
120     address indexed _from,
121     address indexed _to,
122     uint256 indexed _tokenId
123   );
124   event Approval(
125     address indexed _owner,
126     address indexed _approved,
127     uint256 indexed _tokenId
128   );
129   event ApprovalForAll(
130     address indexed _owner,
131     address indexed _operator,
132     bool _approved
133   );
134 
135   function balanceOf(address _owner) public view returns (uint256 _balance);
136   function ownerOf(uint256 _tokenId) public view returns (address _owner);
137   function exists(uint256 _tokenId) public view returns (bool _exists);
138 
139   function approve(address _to, uint256 _tokenId) public;
140   function getApproved(uint256 _tokenId)
141     public view returns (address _operator);
142 
143   function setApprovalForAll(address _operator, bool _approved) public;
144   function isApprovedForAll(address _owner, address _operator)
145     public view returns (bool);
146 
147   function transferFrom(address _from, address _to, uint256 _tokenId) public;
148   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
149     public;
150 
151   function safeTransferFrom(
152     address _from,
153     address _to,
154     uint256 _tokenId,
155     bytes _data
156   )
157     public;
158 }
159 
160 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
161 
162 /**
163  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
164  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
165  */
166 contract ERC721Enumerable is ERC721Basic {
167   function totalSupply() public view returns (uint256);
168   function tokenOfOwnerByIndex(
169     address _owner,
170     uint256 _index
171   )
172     public
173     view
174     returns (uint256 _tokenId);
175 
176   function tokenByIndex(uint256 _index) public view returns (uint256);
177 }
178 
179 
180 /**
181  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
182  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
183  */
184 contract ERC721Metadata is ERC721Basic {
185   function name() external view returns (string _name);
186   function symbol() external view returns (string _symbol);
187   function tokenURI(uint256 _tokenId) public view returns (string);
188 }
189 
190 
191 /**
192  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
193  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
194  */
195 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
196 }
197 
198 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
199 
200 /**
201  * @title ERC721 token receiver interface
202  * @dev Interface for any contract that wants to support safeTransfers
203  * from ERC721 asset contracts.
204  */
205 contract ERC721Receiver {
206   /**
207    * @dev Magic value to be returned upon successful reception of an NFT
208    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
209    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
210    */
211   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
212 
213   /**
214    * @notice Handle the receipt of an NFT
215    * @dev The ERC721 smart contract calls this function on the recipient
216    * after a `safetransfer`. This function MAY throw to revert and reject the
217    * transfer. Return of other than the magic value MUST result in the
218    * transaction being reverted.
219    * Note: the contract address is always the message sender.
220    * @param _operator The address which called `safeTransferFrom` function
221    * @param _from The address which previously owned the token
222    * @param _tokenId The NFT identifier which is being transferred
223    * @param _data Additional data with no specified format
224    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
225    */
226   function onERC721Received(
227     address _operator,
228     address _from,
229     uint256 _tokenId,
230     bytes _data
231   )
232     public
233     returns(bytes4);
234 }
235 
236 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
237 
238 /**
239  * @title SafeMath
240  * @dev Math operations with safety checks that throw on error
241  */
242 library SafeMath {
243 
244   /**
245   * @dev Multiplies two numbers, throws on overflow.
246   */
247   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
248     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
249     // benefit is lost if 'b' is also tested.
250     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
251     if (_a == 0) {
252       return 0;
253     }
254 
255     c = _a * _b;
256     assert(c / _a == _b);
257     return c;
258   }
259 
260   /**
261   * @dev Integer division of two numbers, truncating the quotient.
262   */
263   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
264     // assert(_b > 0); // Solidity automatically throws when dividing by 0
265     // uint256 c = _a / _b;
266     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
267     return _a / _b;
268   }
269 
270   /**
271   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
272   */
273   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
274     assert(_b <= _a);
275     return _a - _b;
276   }
277 
278   /**
279   * @dev Adds two numbers, throws on overflow.
280   */
281   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
282     c = _a + _b;
283     assert(c >= _a);
284     return c;
285   }
286 }
287 
288 // File: openzeppelin-solidity/contracts/AddressUtils.sol
289 
290 /**
291  * Utility library of inline functions on addresses
292  */
293 library AddressUtils {
294 
295   /**
296    * Returns whether the target address is a contract
297    * @dev This function will return false if invoked during the constructor of a contract,
298    * as the code is not actually created until after the constructor finishes.
299    * @param _addr address to check
300    * @return whether the target address is a contract
301    */
302   function isContract(address _addr) internal view returns (bool) {
303     uint256 size;
304     // XXX Currently there is no better way to check if there is a contract in an address
305     // than to check the size of the code at that address.
306     // See https://ethereum.stackexchange.com/a/14016/36603
307     // for more details about how this works.
308     // TODO Check this again before the Serenity release, because all addresses will be
309     // contracts then.
310     // solium-disable-next-line security/no-inline-assembly
311     assembly { size := extcodesize(_addr) }
312     return size > 0;
313   }
314 
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
820 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
821 
822 /**
823  * @title Ownable
824  * @dev The Ownable contract has an owner address, and provides basic authorization control
825  * functions, this simplifies the implementation of "user permissions".
826  */
827 contract Ownable {
828   address public owner;
829 
830 
831   event OwnershipRenounced(address indexed previousOwner);
832   event OwnershipTransferred(
833     address indexed previousOwner,
834     address indexed newOwner
835   );
836 
837 
838   /**
839    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
840    * account.
841    */
842   constructor() public {
843     owner = msg.sender;
844   }
845 
846   /**
847    * @dev Throws if called by any account other than the owner.
848    */
849   modifier onlyOwner() {
850     require(msg.sender == owner);
851     _;
852   }
853 
854   /**
855    * @dev Allows the current owner to relinquish control of the contract.
856    * @notice Renouncing to ownership will leave the contract without an owner.
857    * It will not be possible to call the functions with the `onlyOwner`
858    * modifier anymore.
859    */
860   function renounceOwnership() public onlyOwner {
861     emit OwnershipRenounced(owner);
862     owner = address(0);
863   }
864 
865   /**
866    * @dev Allows the current owner to transfer control of the contract to a newOwner.
867    * @param _newOwner The address to transfer ownership to.
868    */
869   function transferOwnership(address _newOwner) public onlyOwner {
870     _transferOwnership(_newOwner);
871   }
872 
873   /**
874    * @dev Transfers control of the contract to a newOwner.
875    * @param _newOwner The address to transfer ownership to.
876    */
877   function _transferOwnership(address _newOwner) internal {
878     require(_newOwner != address(0));
879     emit OwnershipTransferred(owner, _newOwner);
880     owner = _newOwner;
881   }
882 }
883 
884 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
885 
886 /**
887  * @title Pausable
888  * @dev Base contract which allows children to implement an emergency stop mechanism.
889  */
890 contract Pausable is Ownable {
891   event Pause();
892   event Unpause();
893 
894   bool public paused = false;
895 
896 
897   /**
898    * @dev Modifier to make a function callable only when the contract is not paused.
899    */
900   modifier whenNotPaused() {
901     require(!paused);
902     _;
903   }
904 
905   /**
906    * @dev Modifier to make a function callable only when the contract is paused.
907    */
908   modifier whenPaused() {
909     require(paused);
910     _;
911   }
912 
913   /**
914    * @dev called by the owner to pause, triggers stopped state
915    */
916   function pause() public onlyOwner whenNotPaused {
917     paused = true;
918     emit Pause();
919   }
920 
921   /**
922    * @dev called by the owner to unpause, returns to normal state
923    */
924   function unpause() public onlyOwner whenPaused {
925     paused = false;
926     emit Unpause();
927   }
928 }
929 
930 // File: contracts/common/IDatabase.sol
931 
932 interface IDatabase {
933     
934     function createEntry() external payable returns (uint256);
935     function auth(uint256, address) external;
936     function deleteEntry(uint256) external;
937     function fundEntry(uint256) external payable;
938     function claimEntryFunds(uint256, uint256) external;
939     function updateEntryCreationFee(uint256) external;
940     function updateDatabaseDescription(string) external;
941     function addDatabaseTag(bytes32) external;
942     function updateDatabaseTag(uint8, bytes32) external;
943     function removeDatabaseTag(uint8) external;
944     function readEntryMeta(uint256) external view returns (
945         address,
946         address,
947         uint256,
948         uint256,
949         uint256,
950         uint256
951     );
952     function getChaingearID() external view returns (uint256);
953     function getEntriesIDs() external view returns (uint256[]);
954     function getIndexByID(uint256) external view returns (uint256);
955     function getEntryCreationFee() external view returns (uint256);
956     function getEntriesStorage() external view returns (address);
957     function getSchemaDefinition() external view returns (string);
958     function getDatabaseBalance() external view returns (uint256);
959     function getDatabaseDescription() external view returns (string);
960     function getDatabaseTags() external view returns (bytes32[]);
961     function getDatabaseSafe() external view returns (address);
962     function getSafeBalance() external view returns (uint256);
963     function getDatabaseInitStatus() external view returns (bool);
964     function pause() external;
965     function unpause() external;
966     function transferAdminRights(address) external;
967     function getAdmin() external view returns (address);
968     function getPaused() external view returns (bool);
969     function transferOwnership(address) external;
970     function deletePayees() external;
971 }
972 
973 // File: contracts/common/IDatabaseBuilder.sol
974 
975 interface IDatabaseBuilder {
976     
977     function deployDatabase(
978         address[],
979         uint256[],
980         string,
981         string
982     ) external returns (IDatabase);
983     function setChaingearAddress(address) external;
984     function getChaingearAddress() external view returns (address);
985     function getOwner() external view returns (address);
986 }
987 
988 // File: contracts/common/Safe.sol
989 
990 /**
991 * @title Chaingear - the novel Ethereum database framework
992 * @author cyber•Congress, Valery litvin (@litvintech)
993 * @notice not audited, not recommend to use in mainnet
994 */
995 contract Safe {
996     
997     address private owner;
998 
999     constructor() public
1000     {
1001         owner = msg.sender;
1002     }
1003 
1004     function()
1005         external
1006         payable
1007     {
1008         require(msg.sender == owner);
1009     }
1010 
1011     function claim(address _entryOwner, uint256 _amount)
1012         external
1013     {
1014         require(msg.sender == owner);
1015         require(_amount <= address(this).balance);
1016         require(_entryOwner != address(0));
1017         
1018         _entryOwner.transfer(_amount);
1019     }
1020 
1021     function getOwner()
1022         external
1023         view
1024         returns(address)
1025     {
1026         return owner;
1027     }
1028 }
1029 
1030 // File: contracts/common/IChaingear.sol
1031 
1032 interface IChaingear {
1033     
1034     function addDatabaseBuilderVersion(
1035         string,
1036         IDatabaseBuilder,
1037         string,
1038         string
1039     ) external;
1040     function updateDatabaseBuilderDescription(string, string) external;
1041     function depricateDatabaseBuilder(string) external;
1042     function createDatabase(
1043         string,
1044         address[],
1045         uint256[],
1046         string,
1047         string
1048     ) external payable returns (address, uint256);
1049     function deleteDatabase(uint256) external;
1050     function fundDatabase(uint256) external payable;
1051     function claimDatabaseFunds(uint256, uint256) external;
1052     function updateCreationFee(uint256) external;
1053     function getAmountOfBuilders() external view returns (uint256);
1054     function getBuilderByID(uint256) external view returns(string);
1055     function getDatabaseBuilder(string) external view returns(address, string, string, bool);
1056     function getDatabasesIDs() external view returns (uint256[]);
1057     function getDatabaseIDByAddress(address) external view returns (uint256);
1058     function getDatabaseAddressByName(string) external view returns (address);
1059     function getDatabaseSymbolByID(uint256) external view returns (string);
1060     function getDatabaseIDBySymbol(string) external view returns (uint256);
1061     function getDatabase(uint256) external view returns (
1062         string,
1063         string,
1064         address,
1065         string,
1066         uint256,
1067         address,
1068         uint256
1069     );
1070     function getDatabaseBalance(uint256) external view returns (uint256, uint256);
1071     function getChaingearDescription() external pure returns (string);
1072     function getCreationFeeWei() external view returns (uint256);
1073     function getSafeBalance() external view returns (uint256);
1074     function getSafeAddress() external view returns (address);
1075     function getNameExist(string) external view returns (bool);
1076     function getSymbolExist(string) external view returns (bool);
1077 }
1078 
1079 // File: contracts/common/PaymentSplitter.sol
1080 
1081 /**
1082  * @title PaymentSplitter
1083  * @dev This contract can be used when payments need to be received by a group
1084  * of people and split proportionately to some number of shares they own.
1085  */
1086 contract PaymentSplitter {
1087     
1088     using SafeMath for uint256;
1089 
1090     uint256 internal totalShares;
1091     uint256 internal totalReleased;
1092 
1093     mapping(address => uint256) internal shares;
1094     mapping(address => uint256) internal released;
1095     address[] internal payees;
1096     
1097     event PayeeAdded(address account, uint256 shares);
1098     event PaymentReleased(address to, uint256 amount);
1099     event PaymentReceived(address from, uint256 amount);
1100 
1101     constructor (address[] _payees, uint256[] _shares)
1102         public
1103         payable
1104     {
1105         _initializePayess(_payees, _shares);
1106     }
1107 
1108     function ()
1109         external
1110         payable
1111     {
1112         emit PaymentReceived(msg.sender, msg.value);
1113     }
1114 
1115     function getTotalShares()
1116         external
1117         view
1118         returns (uint256)
1119     {
1120         return totalShares;
1121     }
1122 
1123     function getTotalReleased()
1124         external
1125         view
1126         returns (uint256)
1127     {
1128         return totalReleased;
1129     }
1130 
1131     function getShares(address _account)
1132         external
1133         view
1134         returns (uint256)
1135     {
1136         return shares[_account];
1137     }
1138 
1139     function getReleased(address _account)
1140         external
1141         view
1142         returns (uint256)
1143     {
1144         return released[_account];
1145     }
1146 
1147     function getPayee(uint256 _index)
1148         external
1149         view
1150         returns (address)
1151     {
1152         return payees[_index];
1153     }
1154     
1155     function getPayeesCount() 
1156         external
1157         view
1158         returns (uint256)
1159     {   
1160         return payees.length;
1161     }
1162 
1163     function release(address _account) 
1164         public
1165     {
1166         require(shares[_account] > 0);
1167 
1168         uint256 totalReceived = address(this).balance.add(totalReleased);
1169         uint256 payment = totalReceived.mul(shares[_account]).div(totalShares).sub(released[_account]);
1170 
1171         require(payment != 0);
1172 
1173         released[_account] = released[_account].add(payment);
1174         totalReleased = totalReleased.add(payment);
1175 
1176         _account.transfer(payment);
1177         
1178         emit PaymentReleased(_account, payment);
1179     }
1180     
1181     function _initializePayess(address[] _payees, uint256[] _shares)
1182         internal
1183     {
1184         require(payees.length == 0);
1185         require(_payees.length == _shares.length);
1186         require(_payees.length > 0 && _payees.length <= 8);
1187 
1188         for (uint256 i = 0; i < _payees.length; i++) {
1189             _addPayee(_payees[i], _shares[i]);
1190         }
1191     }
1192 
1193     function _addPayee(
1194         address _account,
1195         uint256 _shares
1196     ) 
1197         internal
1198     {
1199         require(_account != address(0));
1200         require(_shares > 0);
1201         require(shares[_account] == 0);
1202 
1203         payees.push(_account);
1204         shares[_account] = _shares;
1205         totalShares = totalShares.add(_shares);
1206         
1207         emit PayeeAdded(_account, _shares);
1208     }
1209 }
1210 
1211 // File: contracts/chaingear/FeeSplitterChaingear.sol
1212 
1213 contract FeeSplitterChaingear is PaymentSplitter, Ownable {
1214     
1215     event PayeeAddressChanged(
1216         uint8 payeeIndex, 
1217         address oldAddress, 
1218         address newAddress
1219     );
1220 
1221     constructor(address[] _payees, uint256[] _shares)
1222         public
1223         payable
1224         PaymentSplitter(_payees, _shares)
1225     { }
1226     
1227     function changePayeeAddress(uint8 _payeeIndex, address _newAddress)
1228         external
1229         onlyOwner
1230     {
1231         require(_payeeIndex < 12);
1232         require(payees[_payeeIndex] != _newAddress);
1233         
1234         address oldAddress = payees[_payeeIndex];
1235         shares[_newAddress] = shares[oldAddress];
1236         released[_newAddress] = released[oldAddress];
1237         payees[_payeeIndex] = _newAddress;
1238 
1239         delete shares[oldAddress];
1240         delete released[oldAddress];
1241 
1242         emit PayeeAddressChanged(_payeeIndex, oldAddress, _newAddress);
1243     }
1244 
1245 }
1246 
1247 // File: contracts/common/ERC721MetadataValidation.sol
1248 
1249 library ERC721MetadataValidation {
1250 
1251     function validateName(string _base) 
1252         internal
1253         pure
1254     {
1255         bytes memory _baseBytes = bytes(_base);
1256         for (uint i = 0; i < _baseBytes.length; i++) {
1257             require(_baseBytes[i] >= 0x61 && _baseBytes[i] <= 0x7A || _baseBytes[i] >= 0x30 && _baseBytes[i] <= 0x39 || _baseBytes[i] == 0x2D);
1258         }
1259     }
1260 
1261     function validateSymbol(string _base) 
1262         internal
1263         pure
1264     {
1265         bytes memory _baseBytes = bytes(_base);
1266         for (uint i = 0; i < _baseBytes.length; i++) {
1267             require(_baseBytes[i] >= 0x41 && _baseBytes[i] <= 0x5A || _baseBytes[i] >= 0x30 && _baseBytes[i] <= 0x39);
1268         }
1269     }
1270 }
1271 
1272 // File: contracts/chaingear/Chaingear.sol
1273 
1274 /**
1275 * @title Chaingear - the novel Ethereum database framework
1276 * @author cyber•Congress, Valery litvin (@litvintech)
1277 * @notice not audited, not recommend to use in mainnet
1278 */
1279 contract Chaingear is IChaingear, Ownable, SupportsInterfaceWithLookup, Pausable, FeeSplitterChaingear, ERC721Token {
1280 
1281     using SafeMath for uint256;
1282     using ERC721MetadataValidation for string;
1283 
1284     /*
1285     *  Storage
1286     */
1287 
1288     struct DatabaseMeta {
1289         IDatabase databaseContract;
1290         address creatorOfDatabase;
1291         string versionOfDatabase;
1292         string linkABI;
1293         uint256 createdTimestamp;
1294         uint256 currentWei;
1295         uint256 accumulatedWei;
1296     }
1297 
1298     struct DatabaseBuilder {
1299         IDatabaseBuilder builderAddress;
1300         string linkToABI;
1301         string description;
1302         bool operational;
1303     }
1304 
1305     DatabaseMeta[] private databases;
1306     mapping(string => bool) private databasesNamesIndex;
1307     mapping(string => bool) private databasesSymbolsIndex;
1308 
1309     uint256 private headTokenID = 0;
1310     mapping(address => uint256) private databasesIDsByAddressesIndex;
1311     mapping(string => address) private databasesAddressesByNameIndex;
1312     mapping(uint256 => string) private databasesSymbolsByIDIndex;
1313     mapping(string => uint256) private databasesIDsBySymbolIndex;
1314 
1315     uint256 private amountOfBuilders = 0;
1316     mapping(uint256 => string) private buildersVersionIndex;
1317     mapping(string => DatabaseBuilder) private buildersVersion;
1318 
1319     Safe private chaingearSafe;
1320     uint256 private databaseCreationFeeWei = 1 finney;
1321 
1322     string private constant CHAINGEAR_DESCRIPTION = "The novel Ethereum database framework";
1323     bytes4 private constant INTERFACE_CHAINGEAR_EULER_ID = 0xea1db66f; 
1324     bytes4 private constant INTERFACE_DATABASE_V1_EULER_ID = 0xf2c320c4;
1325     bytes4 private constant INTERFACE_DATABASE_BUILDER_EULER_ID = 0xce8bbf93;
1326     
1327     /*
1328     *  Events
1329     */
1330     event DatabaseBuilderAdded(
1331         string version,
1332         IDatabaseBuilder builderAddress,
1333         string linkToABI,
1334         string description
1335     );
1336     event DatabaseDescriptionUpdated(string version, string description);
1337     event DatabaseBuilderDepricated(string version);
1338     event DatabaseCreated(
1339         string name,
1340         address databaseAddress,
1341         address creatorAddress,
1342         uint256 databaseChaingearID
1343     );
1344     event DatabaseDeleted(
1345         string name,
1346         address databaseAddress,
1347         address creatorAddress,
1348         uint256 databaseChaingearID
1349     );
1350     event DatabaseFunded(
1351         uint256 databaseID,
1352         address sender,
1353         uint256 amount
1354     );
1355     event DatabaseFundsClaimed(
1356         uint256 databaseID,
1357         address claimer,
1358         uint256 amount
1359     );    
1360     event CreationFeeUpdated(uint256 newFee);
1361 
1362     /*
1363     *  Constructor
1364     */
1365 
1366     constructor(address[] _beneficiaries, uint256[] _shares)
1367         public
1368         ERC721Token ("CHAINGEAR", "CHG")
1369         FeeSplitterChaingear (_beneficiaries, _shares)
1370     {
1371         chaingearSafe = new Safe();
1372         _registerInterface(INTERFACE_CHAINGEAR_EULER_ID);
1373     }
1374 
1375     /*
1376     *  Modifiers
1377     */
1378 
1379     modifier onlyOwnerOf(uint256 _databaseID){
1380         require(ownerOf(_databaseID) == msg.sender);
1381         _;
1382     }
1383 
1384     /*
1385     *  External functions
1386     */
1387 
1388     function addDatabaseBuilderVersion(
1389         string _version,
1390         IDatabaseBuilder _builderAddress,
1391         string _linkToABI,
1392         string _description
1393     )
1394         external
1395         onlyOwner
1396         whenNotPaused
1397     {
1398         require(buildersVersion[_version].builderAddress == address(0));
1399 
1400         SupportsInterfaceWithLookup support = SupportsInterfaceWithLookup(_builderAddress);
1401         require(support.supportsInterface(INTERFACE_DATABASE_BUILDER_EULER_ID));
1402 
1403         buildersVersion[_version] = (DatabaseBuilder(
1404         {
1405             builderAddress: _builderAddress,
1406             linkToABI: _linkToABI,
1407             description: _description,
1408             operational: true
1409         }));
1410         buildersVersionIndex[amountOfBuilders] = _version;
1411         amountOfBuilders = amountOfBuilders.add(1);
1412         
1413         emit DatabaseBuilderAdded(
1414             _version,
1415             _builderAddress,
1416             _linkToABI,
1417             _description
1418         );
1419     }
1420 
1421     function updateDatabaseBuilderDescription(string _version, string _description)
1422         external
1423         onlyOwner
1424         whenNotPaused
1425     {
1426         require(buildersVersion[_version].builderAddress != address(0));
1427         buildersVersion[_version].description = _description;    
1428         emit DatabaseDescriptionUpdated(_version, _description);
1429     }
1430     
1431     function depricateDatabaseBuilder(string _version)
1432         external
1433         onlyOwner
1434         whenPaused
1435     {
1436         require(buildersVersion[_version].builderAddress != address(0));
1437         require(buildersVersion[_version].operational == true);
1438         buildersVersion[_version].operational = false;
1439         emit DatabaseBuilderDepricated(_version);
1440     }
1441 
1442     function createDatabase(
1443         string    _version,
1444         address[] _beneficiaries,
1445         uint256[] _shares,
1446         string    _name,
1447         string    _symbol
1448     )
1449         external
1450         payable
1451         whenNotPaused
1452         returns (address, uint256)
1453     {
1454         _name.validateName();
1455         _symbol.validateSymbol();
1456         require(buildersVersion[_version].builderAddress != address(0));
1457         require(buildersVersion[_version].operational == true);
1458         require(databaseCreationFeeWei == msg.value);
1459         require(databasesNamesIndex[_name] == false);
1460         require(databasesSymbolsIndex[_symbol] == false);
1461 
1462         return _deployDatabase(
1463             _version,
1464             _beneficiaries,
1465             _shares,
1466             _name,
1467             _symbol
1468         );
1469     }
1470 
1471     function deleteDatabase(uint256 _databaseID)
1472         external
1473         onlyOwnerOf(_databaseID)
1474         whenNotPaused
1475     {
1476         uint256 databaseIndex = allTokensIndex[_databaseID];
1477         IDatabase database = databases[databaseIndex].databaseContract;
1478         require(database.getSafeBalance() == uint256(0));
1479         require(database.getPaused() == true);
1480         
1481         string memory databaseName = ERC721(database).name();
1482         string memory databaseSymbol = ERC721(database).symbol();
1483         
1484         delete databasesNamesIndex[databaseName];
1485         delete databasesSymbolsIndex[databaseSymbol];
1486         delete databasesIDsByAddressesIndex[database];  
1487         delete databasesIDsBySymbolIndex[databaseSymbol];
1488         delete databasesSymbolsByIDIndex[_databaseID];
1489 
1490         uint256 lastDatabaseIndex = databases.length.sub(1);
1491         DatabaseMeta memory lastDatabase = databases[lastDatabaseIndex];
1492         databases[databaseIndex] = lastDatabase;
1493         delete databases[lastDatabaseIndex];
1494         databases.length--;
1495 
1496         super._burn(msg.sender, _databaseID);
1497         database.transferOwnership(msg.sender);
1498         
1499         emit DatabaseDeleted(
1500             databaseName,
1501             database,
1502             msg.sender,
1503             _databaseID
1504         );
1505     }
1506 
1507     function fundDatabase(uint256 _databaseID)
1508         external
1509         whenNotPaused
1510         payable
1511     {
1512         require(exists(_databaseID) == true);
1513         uint256 databaseIndex = allTokensIndex[_databaseID];
1514 
1515         uint256 currentWei = databases[databaseIndex].currentWei.add(msg.value);
1516         databases[databaseIndex].currentWei = currentWei;
1517 
1518         uint256 accumulatedWei = databases[databaseIndex].accumulatedWei.add(msg.value);
1519         databases[databaseIndex].accumulatedWei = accumulatedWei;
1520 
1521         emit DatabaseFunded(_databaseID, msg.sender, msg.value);
1522         address(chaingearSafe).transfer(msg.value);
1523     }
1524 
1525     function claimDatabaseFunds(uint256 _databaseID, uint256 _amount)
1526         external
1527         onlyOwnerOf(_databaseID)
1528         whenNotPaused
1529     {
1530         uint256 databaseIndex = allTokensIndex[_databaseID];
1531 
1532         uint256 currentWei = databases[databaseIndex].currentWei;
1533         require(_amount <= currentWei);
1534 
1535         databases[databaseIndex].currentWei = currentWei.sub(_amount);
1536 
1537         emit DatabaseFundsClaimed(_databaseID, msg.sender, _amount);
1538         chaingearSafe.claim(msg.sender, _amount);
1539     }
1540 
1541     function updateCreationFee(uint256 _newFee)
1542         external
1543         onlyOwner
1544         whenPaused
1545     {
1546         databaseCreationFeeWei = _newFee;
1547         emit CreationFeeUpdated(_newFee);
1548     }
1549 
1550     /*
1551     *  Views
1552     */
1553 
1554     function getAmountOfBuilders()
1555         external
1556         view
1557         returns(uint256)
1558     {
1559         return amountOfBuilders;
1560     }
1561 
1562     function getBuilderByID(uint256 _id)
1563         external
1564         view
1565         returns(string)
1566     {
1567         return buildersVersionIndex[_id];
1568     }
1569 
1570     function getDatabaseBuilder(string _version)
1571         external
1572         view
1573         returns (
1574             address,
1575             string,
1576             string,
1577             bool
1578         )
1579     {
1580         return(
1581             buildersVersion[_version].builderAddress,
1582             buildersVersion[_version].linkToABI,
1583             buildersVersion[_version].description,
1584             buildersVersion[_version].operational
1585         );
1586     }
1587 
1588     function getDatabasesIDs()
1589         external
1590         view
1591         returns(uint256[])
1592     {
1593         return allTokens;
1594     }
1595 
1596     function getDatabaseIDByAddress(address _databaseAddress)
1597         external
1598         view
1599         returns(uint256)
1600     {
1601         uint256 databaseID = databasesIDsByAddressesIndex[_databaseAddress];
1602         return databaseID;
1603     }
1604     
1605     function getDatabaseAddressByName(string _name)
1606         external
1607         view
1608         returns(address)
1609     {
1610         return databasesAddressesByNameIndex[_name];
1611     }
1612 
1613     function getDatabaseSymbolByID(uint256 _databaseID)
1614         external
1615         view
1616         returns(string)
1617     {
1618         return databasesSymbolsByIDIndex[_databaseID];
1619     }
1620 
1621     function getDatabaseIDBySymbol(string _symbol)
1622         external
1623         view
1624         returns(uint256)
1625     {
1626         return databasesIDsBySymbolIndex[_symbol];
1627     }
1628 
1629     function getDatabase(uint256 _databaseID)
1630         external
1631         view
1632         returns (
1633             string,
1634             string,
1635             address,
1636             string,
1637             uint256,
1638             address,
1639             uint256
1640         )
1641     {
1642         uint256 databaseIndex = allTokensIndex[_databaseID];
1643         IDatabase databaseAddress = databases[databaseIndex].databaseContract;
1644 
1645         return (
1646             ERC721(databaseAddress).name(),
1647             ERC721(databaseAddress).symbol(),
1648             databaseAddress,
1649             databases[databaseIndex].versionOfDatabase,
1650             databases[databaseIndex].createdTimestamp,
1651             databaseAddress.getAdmin(),
1652             ERC721(databaseAddress).totalSupply()
1653         );
1654     }
1655 
1656     function getDatabaseBalance(uint256 _databaseID)
1657         external
1658         view
1659         returns (uint256, uint256)
1660     {
1661         uint256 databaseIndex = allTokensIndex[_databaseID];
1662 
1663         return (
1664             databases[databaseIndex].currentWei,
1665             databases[databaseIndex].accumulatedWei
1666         );
1667     }
1668 
1669     function getChaingearDescription()
1670         external
1671         pure
1672         returns (string)
1673     {
1674         return CHAINGEAR_DESCRIPTION;
1675     }
1676 
1677     function getCreationFeeWei()
1678         external
1679         view
1680         returns (uint256)
1681     {
1682         return databaseCreationFeeWei;
1683     }
1684 
1685     function getSafeBalance()
1686         external
1687         view
1688         returns (uint256)
1689     {
1690         return address(chaingearSafe).balance;
1691     }
1692 
1693     function getSafeAddress()
1694         external
1695         view
1696         returns (address)
1697     {
1698         return chaingearSafe;
1699     }
1700 
1701     function getNameExist(string _name)
1702         external
1703         view
1704         returns (bool)
1705     {
1706         return databasesNamesIndex[_name];
1707     }
1708 
1709     function getSymbolExist(string _symbol)
1710         external
1711         view
1712         returns (bool)
1713     {
1714         return databasesSymbolsIndex[_symbol];
1715     }
1716 
1717     /*
1718     *  Public functions
1719     */
1720 
1721     function transferFrom(
1722         address _from,
1723         address _to,
1724         uint256 _tokenId
1725     )
1726         public
1727         whenNotPaused
1728     {
1729         uint256 databaseIndex = allTokensIndex[_tokenId];
1730         IDatabase database = databases[databaseIndex].databaseContract;
1731         require(address(database).balance == 0);
1732         require(database.getPaused() == true);
1733         super.transferFrom(_from, _to, _tokenId);
1734         
1735         IDatabase databaseAddress = databases[databaseIndex].databaseContract;
1736         databaseAddress.deletePayees();
1737         databaseAddress.transferAdminRights(_to);
1738     }
1739 
1740     function safeTransferFrom(
1741         address _from,
1742         address _to,
1743         uint256 _tokenId
1744     )
1745         public
1746         whenNotPaused
1747     {
1748         safeTransferFrom(
1749             _from,
1750             _to,
1751             _tokenId,
1752             ""
1753         );
1754     }
1755 
1756     function safeTransferFrom(
1757         address _from,
1758         address _to,
1759         uint256 _tokenId,
1760         bytes _data
1761     )
1762         public
1763         whenNotPaused
1764     {
1765         transferFrom(_from, _to, _tokenId);
1766 
1767         require(
1768             checkAndCallSafeTransfer(
1769                 _from,
1770                 _to,
1771                 _tokenId,
1772                 _data
1773         ));
1774     }
1775 
1776     /*
1777     *  Private functions
1778     */
1779 
1780     function _deployDatabase(
1781         string    _version,
1782         address[] _beneficiaries,
1783         uint256[] _shares,
1784         string    _name,
1785         string    _symbol
1786     )
1787         private
1788         returns (address, uint256)
1789     {
1790         IDatabaseBuilder builder = buildersVersion[_version].builderAddress;
1791         IDatabase databaseContract = builder.deployDatabase(
1792             _beneficiaries,
1793             _shares,
1794             _name,
1795             _symbol
1796         );
1797 
1798         address databaseAddress = address(databaseContract);
1799 
1800         SupportsInterfaceWithLookup support = SupportsInterfaceWithLookup(databaseAddress);
1801         require(support.supportsInterface(INTERFACE_DATABASE_V1_EULER_ID));
1802         require(support.supportsInterface(InterfaceId_ERC721));
1803         require(support.supportsInterface(InterfaceId_ERC721Metadata));
1804         require(support.supportsInterface(InterfaceId_ERC721Enumerable));
1805 
1806         DatabaseMeta memory database = (DatabaseMeta(
1807         {
1808             databaseContract: databaseContract,
1809             creatorOfDatabase: msg.sender,
1810             versionOfDatabase: _version,
1811             linkABI: buildersVersion[_version].linkToABI,
1812             createdTimestamp: block.timestamp,
1813             currentWei: 0,
1814             accumulatedWei: 0
1815         }));
1816 
1817         databases.push(database);
1818 
1819         databasesNamesIndex[_name] = true;
1820         databasesSymbolsIndex[_symbol] = true;
1821 
1822         uint256 newTokenID = headTokenID;
1823         databasesIDsByAddressesIndex[databaseAddress] = newTokenID;
1824         super._mint(msg.sender, newTokenID);
1825         databasesSymbolsByIDIndex[newTokenID] = _symbol;
1826         databasesIDsBySymbolIndex[_symbol] = newTokenID;
1827         databasesAddressesByNameIndex[_name] = databaseAddress;
1828         headTokenID = headTokenID.add(1);
1829 
1830         emit DatabaseCreated(
1831             _name,
1832             databaseAddress,
1833             msg.sender,
1834             newTokenID
1835         );
1836 
1837         databaseContract.transferAdminRights(msg.sender);
1838         return (databaseAddress, newTokenID);
1839     }
1840 
1841 }