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
884 // File: contracts/common/IDatabase.sol
885 
886 interface IDatabase {
887     
888     function createEntry() external payable returns (uint256);
889     function auth(uint256, address) external;
890     function deleteEntry(uint256) external;
891     function fundEntry(uint256) external payable;
892     function claimEntryFunds(uint256, uint256) external;
893     function updateEntryCreationFee(uint256) external;
894     function updateDatabaseDescription(string) external;
895     function addDatabaseTag(bytes32) external;
896     function updateDatabaseTag(uint8, bytes32) external;
897     function removeDatabaseTag(uint8) external;
898     function readEntryMeta(uint256) external view returns (
899         address,
900         address,
901         uint256,
902         uint256,
903         uint256,
904         uint256
905     );
906     function getChaingearID() external view returns (uint256);
907     function getEntriesIDs() external view returns (uint256[]);
908     function getIndexByID(uint256) external view returns (uint256);
909     function getEntryCreationFee() external view returns (uint256);
910     function getEntriesStorage() external view returns (address);
911     function getSchemaDefinition() external view returns (string);
912     function getDatabaseBalance() external view returns (uint256);
913     function getDatabaseDescription() external view returns (string);
914     function getDatabaseTags() external view returns (bytes32[]);
915     function getDatabaseSafe() external view returns (address);
916     function getSafeBalance() external view returns (uint256);
917     function getDatabaseInitStatus() external view returns (bool);
918     function pause() external;
919     function unpause() external;
920     function transferAdminRights(address) external;
921     function getAdmin() external view returns (address);
922     function getPaused() external view returns (bool);
923     function transferOwnership(address) external;
924     function deletePayees() external;
925 }
926 
927 // File: contracts/common/IDatabaseBuilder.sol
928 
929 interface IDatabaseBuilder {
930     
931     function deployDatabase(
932         address[],
933         uint256[],
934         string,
935         string
936     ) external returns (IDatabase);
937     function setChaingearAddress(address) external;
938     function getChaingearAddress() external view returns (address);
939     function getOwner() external view returns (address);
940 }
941 
942 // File: contracts/common/IChaingear.sol
943 
944 interface IChaingear {
945     
946     function addDatabaseBuilderVersion(
947         string,
948         IDatabaseBuilder,
949         string,
950         string
951     ) external;
952     function updateDatabaseBuilderDescription(string, string) external;
953     function depricateDatabaseBuilder(string) external;
954     function createDatabase(
955         string,
956         address[],
957         uint256[],
958         string,
959         string
960     ) external payable returns (address, uint256);
961     function deleteDatabase(uint256) external;
962     function fundDatabase(uint256) external payable;
963     function claimDatabaseFunds(uint256, uint256) external;
964     function updateCreationFee(uint256) external;
965     function getAmountOfBuilders() external view returns (uint256);
966     function getBuilderByID(uint256) external view returns(string);
967     function getDatabaseBuilder(string) external view returns(address, string, string, bool);
968     function getDatabasesIDs() external view returns (uint256[]);
969     function getDatabaseIDByAddress(address) external view returns (uint256);
970     function getDatabaseAddressByName(string) external view returns (address);
971     function getDatabaseSymbolByID(uint256) external view returns (string);
972     function getDatabaseIDBySymbol(string) external view returns (uint256);
973     function getDatabase(uint256) external view returns (
974         string,
975         string,
976         address,
977         string,
978         uint256,
979         address,
980         uint256
981     );
982     function getDatabaseBalance(uint256) external view returns (uint256, uint256);
983     function getChaingearDescription() external pure returns (string);
984     function getCreationFeeWei() external view returns (uint256);
985     function getSafeBalance() external view returns (uint256);
986     function getSafeAddress() external view returns (address);
987     function getNameExist(string) external view returns (bool);
988     function getSymbolExist(string) external view returns (bool);
989 }
990 
991 // File: contracts/common/ISchema.sol
992 
993 interface ISchema {
994 
995     function createEntry() external;
996     function deleteEntry(uint256) external;
997 }
998 
999 // File: contracts/common/Safe.sol
1000 
1001 /**
1002 * @title Chaingear - the novel Ethereum database framework
1003 * @author cyber•Congress, Valery litvin (@litvintech)
1004 * @notice not audited, not recommend to use in mainnet
1005 */
1006 contract Safe {
1007     
1008     address private owner;
1009 
1010     constructor() public
1011     {
1012         owner = msg.sender;
1013     }
1014 
1015     function()
1016         external
1017         payable
1018     {
1019         require(msg.sender == owner);
1020     }
1021 
1022     function claim(address _entryOwner, uint256 _amount)
1023         external
1024     {
1025         require(msg.sender == owner);
1026         require(_amount <= address(this).balance);
1027         require(_entryOwner != address(0));
1028         
1029         _entryOwner.transfer(_amount);
1030     }
1031 
1032     function getOwner()
1033         external
1034         view
1035         returns(address)
1036     {
1037         return owner;
1038     }
1039 }
1040 
1041 // File: contracts/common/PaymentSplitter.sol
1042 
1043 /**
1044  * @title PaymentSplitter
1045  * @dev This contract can be used when payments need to be received by a group
1046  * of people and split proportionately to some number of shares they own.
1047  */
1048 contract PaymentSplitter {
1049     
1050     using SafeMath for uint256;
1051 
1052     uint256 internal totalShares;
1053     uint256 internal totalReleased;
1054 
1055     mapping(address => uint256) internal shares;
1056     mapping(address => uint256) internal released;
1057     address[] internal payees;
1058     
1059     event PayeeAdded(address account, uint256 shares);
1060     event PaymentReleased(address to, uint256 amount);
1061     event PaymentReceived(address from, uint256 amount);
1062 
1063     constructor (address[] _payees, uint256[] _shares)
1064         public
1065         payable
1066     {
1067         _initializePayess(_payees, _shares);
1068     }
1069 
1070     function ()
1071         external
1072         payable
1073     {
1074         emit PaymentReceived(msg.sender, msg.value);
1075     }
1076 
1077     function getTotalShares()
1078         external
1079         view
1080         returns (uint256)
1081     {
1082         return totalShares;
1083     }
1084 
1085     function getTotalReleased()
1086         external
1087         view
1088         returns (uint256)
1089     {
1090         return totalReleased;
1091     }
1092 
1093     function getShares(address _account)
1094         external
1095         view
1096         returns (uint256)
1097     {
1098         return shares[_account];
1099     }
1100 
1101     function getReleased(address _account)
1102         external
1103         view
1104         returns (uint256)
1105     {
1106         return released[_account];
1107     }
1108 
1109     function getPayee(uint256 _index)
1110         external
1111         view
1112         returns (address)
1113     {
1114         return payees[_index];
1115     }
1116     
1117     function getPayeesCount() 
1118         external
1119         view
1120         returns (uint256)
1121     {   
1122         return payees.length;
1123     }
1124 
1125     function release(address _account) 
1126         public
1127     {
1128         require(shares[_account] > 0);
1129 
1130         uint256 totalReceived = address(this).balance.add(totalReleased);
1131         uint256 payment = totalReceived.mul(shares[_account]).div(totalShares).sub(released[_account]);
1132 
1133         require(payment != 0);
1134 
1135         released[_account] = released[_account].add(payment);
1136         totalReleased = totalReleased.add(payment);
1137 
1138         _account.transfer(payment);
1139         
1140         emit PaymentReleased(_account, payment);
1141     }
1142     
1143     function _initializePayess(address[] _payees, uint256[] _shares)
1144         internal
1145     {
1146         require(payees.length == 0);
1147         require(_payees.length == _shares.length);
1148         require(_payees.length > 0 && _payees.length <= 8);
1149 
1150         for (uint256 i = 0; i < _payees.length; i++) {
1151             _addPayee(_payees[i], _shares[i]);
1152         }
1153     }
1154 
1155     function _addPayee(
1156         address _account,
1157         uint256 _shares
1158     ) 
1159         internal
1160     {
1161         require(_account != address(0));
1162         require(_shares > 0);
1163         require(shares[_account] == 0);
1164 
1165         payees.push(_account);
1166         shares[_account] = _shares;
1167         totalShares = totalShares.add(_shares);
1168         
1169         emit PayeeAdded(_account, _shares);
1170     }
1171 }
1172 
1173 // File: contracts/databases/DatabasePermissionControl.sol
1174 
1175 /**
1176 * @title Chaingear - the novel Ethereum database framework
1177 * @author cyber•Congress, Valery litvin (@litvintech)
1178 * @notice not audited, not recommend to use in mainnet
1179 */
1180 contract DatabasePermissionControl is Ownable {
1181 
1182     /*
1183     *  Storage
1184     */
1185 
1186     enum CreateEntryPermissionGroup {OnlyAdmin, Whitelist, AllUsers}
1187 
1188     address private admin;
1189     bool private paused = true;
1190 
1191     mapping(address => bool) private whitelist;
1192 
1193     CreateEntryPermissionGroup private permissionGroup = CreateEntryPermissionGroup.OnlyAdmin;
1194 
1195     /*
1196     *  Events
1197     */
1198 
1199     event Pause();
1200     event Unpause();
1201     event PermissionGroupChanged(CreateEntryPermissionGroup);
1202     event AddedToWhitelist(address);
1203     event RemovedFromWhitelist(address);
1204     event AdminshipTransferred(address, address);
1205 
1206     /*
1207     *  Constructor
1208     */
1209 
1210     constructor()
1211         public
1212     { }
1213 
1214     /*
1215     *  Modifiers
1216     */
1217 
1218     modifier whenNotPaused() {
1219         require(!paused);
1220         _;
1221     }
1222 
1223     modifier whenPaused() {
1224         require(paused);
1225         _;
1226     }
1227 
1228     modifier onlyAdmin() {
1229         require(msg.sender == admin);
1230         _;
1231     }
1232 
1233     modifier onlyPermissionedToCreateEntries() {
1234         if (permissionGroup == CreateEntryPermissionGroup.OnlyAdmin) {
1235             require(msg.sender == admin);
1236         } else if (permissionGroup == CreateEntryPermissionGroup.Whitelist) {
1237             require(whitelist[msg.sender] == true || msg.sender == admin);
1238         }
1239         _;
1240     }
1241 
1242     /*
1243     *  External functions
1244     */
1245 
1246     function pause()
1247         external
1248         onlyAdmin
1249         whenNotPaused
1250     {
1251         paused = true;
1252         emit Pause();
1253     }
1254 
1255     function unpause()
1256         external
1257         onlyAdmin
1258         whenPaused
1259     {
1260         paused = false;
1261         emit Unpause();
1262     }
1263 
1264     function transferAdminRights(address _newAdmin)
1265         external
1266         onlyOwner
1267         whenPaused
1268     {
1269         require(_newAdmin != address(0));
1270         emit AdminshipTransferred(admin, _newAdmin);
1271         admin = _newAdmin;
1272     }
1273 
1274     function updateCreateEntryPermissionGroup(CreateEntryPermissionGroup _newPermissionGroup)
1275         external
1276         onlyAdmin
1277         whenPaused
1278     {
1279         require(CreateEntryPermissionGroup.AllUsers >= _newPermissionGroup);
1280         
1281         permissionGroup = _newPermissionGroup;
1282         emit PermissionGroupChanged(_newPermissionGroup);
1283     }
1284 
1285     function addToWhitelist(address _address)
1286         external
1287         onlyAdmin
1288         whenPaused
1289     {
1290         whitelist[_address] = true;
1291         emit AddedToWhitelist(_address);
1292     }
1293 
1294     function removeFromWhitelist(address _address)
1295         external
1296         onlyAdmin
1297         whenPaused
1298     {
1299         whitelist[_address] = false;
1300         emit RemovedFromWhitelist(_address);
1301     }
1302 
1303     function getAdmin()
1304         external
1305         view
1306         returns (address)
1307     {
1308         return admin;
1309     }
1310 
1311     function getDatabasePermissions()
1312         external
1313         view
1314         returns (CreateEntryPermissionGroup)
1315     {
1316         return permissionGroup;
1317     }
1318 
1319     function checkWhitelisting(address _address)
1320         external
1321         view
1322         returns (bool)
1323     {
1324         return whitelist[_address];
1325     }
1326     
1327     function getPaused()
1328         external
1329         view
1330         returns (bool)
1331     {
1332         return paused;
1333     }
1334 }
1335 
1336 // File: contracts/databases/FeeSplitterDatabase.sol
1337 
1338 contract FeeSplitterDatabase is PaymentSplitter, DatabasePermissionControl {
1339     
1340     event PayeeAddressChanged(
1341         uint8 payeeIndex, 
1342         address oldAddress, 
1343         address newAddress
1344     );
1345     event PayeesDeleted();
1346 
1347     constructor(address[] _payees, uint256[] _shares)
1348         public
1349         payable
1350         PaymentSplitter(_payees, _shares)
1351     { }
1352     
1353     function ()
1354         external
1355         payable
1356         whenNotPaused
1357     {
1358         emit PaymentReceived(msg.sender, msg.value);
1359     }
1360     
1361     function changePayeeAddress(uint8 _payeeIndex, address _newAddress)
1362         external
1363         whenNotPaused
1364     {
1365         require(_payeeIndex < 8);
1366         require(msg.sender == payees[_payeeIndex]);
1367         require(payees[_payeeIndex] != _newAddress);
1368         
1369         address oldAddress = payees[_payeeIndex];
1370 
1371         shares[_newAddress] = shares[oldAddress];
1372         released[_newAddress] = released[oldAddress];
1373         payees[_payeeIndex] = _newAddress;
1374 
1375         delete shares[oldAddress];
1376         delete released[oldAddress];
1377 
1378         emit PayeeAddressChanged(_payeeIndex, oldAddress, _newAddress);
1379     }
1380     
1381     function setPayess(address[] _payees, uint256[] _shares)
1382         external
1383         whenPaused
1384         onlyAdmin
1385     {
1386         _initializePayess(_payees, _shares);
1387     }
1388     
1389     function deletePayees()
1390         external
1391         whenPaused
1392         onlyOwner
1393     {
1394         for (uint8 i = 0; i < payees.length; i++) {
1395             address account = payees[i];
1396             delete shares[account];
1397             delete released[account];
1398         }
1399         payees.length = 0;
1400         totalShares = 0;
1401         totalReleased = 0;
1402         
1403         emit PayeesDeleted();
1404     }
1405 }
1406 
1407 // File: contracts/databases/DatabaseV1.sol
1408 
1409 /**
1410 * @title Chaingear - the novel Ethereum database framework
1411 * @author cyber•Congress, Valery litvin (@litvintech)
1412 * @notice not audited, not recommend to use in mainnet
1413 */
1414 contract DatabaseV1 is IDatabase, Ownable, DatabasePermissionControl, SupportsInterfaceWithLookup, FeeSplitterDatabase, ERC721Token {
1415 
1416     using SafeMath for uint256;
1417 
1418     /*
1419     *  Storage
1420     */
1421     
1422     bytes4 private constant INTERFACE_SCHEMA_EULER_ID = 0x153366ed;
1423     bytes4 private constant INTERFACE_DATABASE_V1_EULER_ID = 0xf2c320c4;
1424 
1425     // @dev Metadata of entry, holds ownership data and funding info
1426     struct EntryMeta {
1427         address creator;
1428         uint256 createdAt;
1429         uint256 lastUpdateTime;
1430         uint256 currentWei;
1431         uint256 accumulatedWei;
1432     }
1433 
1434     EntryMeta[] private entriesMeta;
1435     Safe private databaseSafe;
1436 
1437     uint256 private headTokenID = 0;
1438     uint256 private entryCreationFeeWei = 0;
1439 
1440     bytes32[] private databaseTags;
1441     string private databaseDescription;
1442     
1443     string private schemaDefinition;
1444     ISchema private entriesStorage;
1445     bool private databaseInitStatus = false;
1446 
1447     /*
1448     *  Modifiers
1449     */
1450 
1451     modifier onlyOwnerOf(uint256 _entryID){
1452         require(ownerOf(_entryID) == msg.sender);
1453         _;
1454     }
1455 
1456     modifier databaseInitialized {
1457         require(databaseInitStatus == true);
1458         _;
1459     }
1460 
1461     /**
1462     *  Events
1463     */
1464 
1465     event EntryCreated(uint256 entryID, address creator);
1466     event EntryDeleted(uint256 entryID, address owner);
1467     event EntryFunded(
1468         uint256 entryID,
1469         address funder,
1470         uint256 amount
1471     );
1472     event EntryFundsClaimed(
1473         uint256 entryID,
1474         address claimer,
1475         uint256 amount
1476     );
1477     event EntryCreationFeeUpdated(uint256 newFees);
1478     event DescriptionUpdated(string newDescription);
1479     event DatabaseInitialized();
1480     event TagAdded(bytes32 tag);
1481     event TagUpdated(uint8 index, bytes32 tag);
1482     event TagDeleted(uint8 index);
1483 
1484     /*
1485     *  Constructor
1486     */
1487 
1488     constructor(
1489         address[] _beneficiaries,
1490         uint256[] _shares,
1491         string _name,
1492         string _symbol
1493     )
1494         ERC721Token (_name, _symbol)
1495         FeeSplitterDatabase (_beneficiaries, _shares)
1496         public
1497         payable
1498     {
1499         _registerInterface(INTERFACE_DATABASE_V1_EULER_ID);
1500         databaseSafe = new Safe();
1501     }
1502 
1503     /*
1504     *  External functions
1505     */
1506 
1507     function createEntry()
1508         external
1509         databaseInitialized
1510         onlyPermissionedToCreateEntries
1511         whenNotPaused
1512         payable
1513         returns (uint256)
1514     {
1515         require(msg.value == entryCreationFeeWei);
1516 
1517         EntryMeta memory meta = (EntryMeta(
1518         {
1519             lastUpdateTime: block.timestamp,
1520             createdAt: block.timestamp,
1521             creator: msg.sender,
1522             currentWei: 0,
1523             accumulatedWei: 0
1524         }));
1525         entriesMeta.push(meta);
1526 
1527         uint256 newTokenID = headTokenID;
1528         super._mint(msg.sender, newTokenID);
1529         headTokenID = headTokenID.add(1);
1530 
1531         emit EntryCreated(newTokenID, msg.sender);
1532 
1533         entriesStorage.createEntry();
1534 
1535         return newTokenID;
1536     }
1537 
1538     function auth(uint256 _entryID, address _caller)
1539         external
1540         whenNotPaused
1541     {
1542         require(msg.sender == address(entriesStorage));
1543         require(ownerOf(_entryID) == _caller);
1544         uint256 entryIndex = allTokensIndex[_entryID];
1545         entriesMeta[entryIndex].lastUpdateTime = block.timestamp;
1546     }
1547 
1548     function deleteEntry(uint256 _entryID)
1549         external
1550         databaseInitialized
1551         onlyOwnerOf(_entryID)
1552         whenNotPaused
1553     {
1554         uint256 entryIndex = allTokensIndex[_entryID];
1555         require(entriesMeta[entryIndex].currentWei == 0);
1556 
1557         uint256 lastEntryIndex = entriesMeta.length.sub(1);
1558         EntryMeta memory lastEntry = entriesMeta[lastEntryIndex];
1559 
1560         entriesMeta[entryIndex] = lastEntry;
1561         delete entriesMeta[lastEntryIndex];
1562         entriesMeta.length--;
1563 
1564         super._burn(msg.sender, _entryID);
1565         emit EntryDeleted(_entryID, msg.sender);
1566 
1567         entriesStorage.deleteEntry(entryIndex);
1568     }
1569 
1570     function fundEntry(uint256 _entryID)
1571         external
1572         databaseInitialized
1573         whenNotPaused
1574         payable
1575     {
1576         require(exists(_entryID) == true);
1577 
1578         uint256 entryIndex = allTokensIndex[_entryID];
1579         uint256 currentWei = entriesMeta[entryIndex].currentWei.add(msg.value);
1580         entriesMeta[entryIndex].currentWei = currentWei;
1581 
1582         uint256 accumulatedWei = entriesMeta[entryIndex].accumulatedWei.add(msg.value);
1583         entriesMeta[entryIndex].accumulatedWei = accumulatedWei;
1584 
1585         emit EntryFunded(_entryID, msg.sender, msg.value);
1586         address(databaseSafe).transfer(msg.value);
1587     }
1588 
1589     function claimEntryFunds(uint256 _entryID, uint256 _amount)
1590         external
1591         databaseInitialized
1592         onlyOwnerOf(_entryID)
1593         whenNotPaused
1594     {
1595         uint256 entryIndex = allTokensIndex[_entryID];
1596 
1597         uint256 currentWei = entriesMeta[entryIndex].currentWei;
1598         require(_amount <= currentWei);
1599         entriesMeta[entryIndex].currentWei = currentWei.sub(_amount);
1600 
1601         emit EntryFundsClaimed(_entryID, msg.sender, _amount);
1602         databaseSafe.claim(msg.sender, _amount);
1603     }
1604 
1605     function updateEntryCreationFee(uint256 _newFee)
1606         external
1607         onlyAdmin
1608         whenPaused
1609     {
1610         entryCreationFeeWei = _newFee;
1611         emit EntryCreationFeeUpdated(_newFee);
1612     }
1613 
1614     function updateDatabaseDescription(string _newDescription)
1615         external
1616         onlyAdmin
1617     {
1618         databaseDescription = _newDescription;
1619         emit DescriptionUpdated(_newDescription);
1620     }
1621 
1622     function addDatabaseTag(bytes32 _tag)
1623         external
1624         onlyAdmin
1625     {
1626         require(databaseTags.length < 16);
1627         databaseTags.push(_tag);    
1628         emit TagAdded(_tag);
1629     }
1630 
1631     function updateDatabaseTag(uint8 _index, bytes32 _tag)
1632         external
1633         onlyAdmin
1634     {
1635         require(_index < databaseTags.length);
1636         databaseTags[_index] = _tag;    
1637         emit TagUpdated(_index, _tag);
1638     }
1639 
1640     function removeDatabaseTag(uint8 _index)
1641         external
1642         onlyAdmin
1643     {
1644         require(databaseTags.length > 0);
1645         require(_index < databaseTags.length);
1646 
1647         uint256 lastTagIndex = databaseTags.length.sub(1);
1648         bytes32 lastTag = databaseTags[lastTagIndex];
1649 
1650         databaseTags[_index] = lastTag;
1651         databaseTags[lastTagIndex] = "";
1652         databaseTags.length--;
1653         
1654         emit TagDeleted(_index);
1655     }
1656 
1657     /*
1658     *  View functions
1659     */
1660 
1661     function readEntryMeta(uint256 _entryID)
1662         external
1663         view
1664         returns (
1665             address,
1666             address,
1667             uint256,
1668             uint256,
1669             uint256,
1670             uint256
1671         )
1672     {
1673         require(exists(_entryID) == true);
1674         uint256 entryIndex = allTokensIndex[_entryID];
1675 
1676         EntryMeta memory m = entriesMeta[entryIndex];
1677         return(
1678             ownerOf(_entryID),
1679             m.creator,
1680             m.createdAt,
1681             m.lastUpdateTime,
1682             m.currentWei,
1683             m.accumulatedWei
1684         );
1685     }
1686 
1687     function getChaingearID()
1688         external
1689         view
1690         returns(uint256)
1691     {
1692         return IChaingear(owner).getDatabaseIDByAddress(address(this));
1693     }
1694 
1695     function getEntriesIDs()
1696         external
1697         view
1698         returns (uint256[])
1699     {
1700         return allTokens;
1701     }
1702 
1703     function getIndexByID(uint256 _entryID)
1704         external
1705         view
1706         returns (uint256)
1707     {
1708         require(exists(_entryID) == true);
1709         return allTokensIndex[_entryID];
1710     }
1711 
1712     function getEntryCreationFee()
1713         external
1714         view
1715         returns (uint256)
1716     {
1717         return entryCreationFeeWei;
1718     }
1719 
1720     function getEntriesStorage()
1721         external
1722         view
1723         returns (address)
1724     {
1725         return address(entriesStorage);
1726     }
1727     
1728     function getSchemaDefinition()
1729         external
1730         view
1731         returns (string)
1732     {
1733         return schemaDefinition;
1734     }
1735 
1736     function getDatabaseBalance()
1737         external
1738         view
1739         returns (uint256)
1740     {
1741         return address(this).balance;
1742     }
1743 
1744     function getDatabaseDescription()
1745         external
1746         view
1747         returns (string)
1748     {
1749         return databaseDescription;
1750     }
1751 
1752     function getDatabaseTags()
1753         external
1754         view
1755         returns (bytes32[])
1756     {
1757         return databaseTags;
1758     }
1759 
1760     function getDatabaseSafe()
1761         external
1762         view
1763         returns (address)
1764     {
1765         return databaseSafe;
1766     }
1767 
1768     function getSafeBalance()
1769         external
1770         view
1771         returns (uint256)
1772     {
1773         return address(databaseSafe).balance;
1774     }
1775 
1776     function getDatabaseInitStatus()
1777         external
1778         view
1779         returns (bool)
1780     {
1781         return databaseInitStatus;
1782     }
1783 
1784     /**
1785     *  Public functions
1786     */
1787     
1788     function initializeDatabase(string _schemaDefinition, bytes _schemaBytecode)
1789         public
1790         onlyAdmin
1791         whenPaused
1792         returns (address)
1793     {
1794         require(databaseInitStatus == false);
1795         address deployedAddress;
1796 
1797         assembly {
1798             let s := mload(_schemaBytecode)
1799             let p := add(_schemaBytecode, 0x20)
1800             deployedAddress := create(0, p, s)
1801         }
1802 
1803         require(deployedAddress != address(0));
1804         require(SupportsInterfaceWithLookup(deployedAddress).supportsInterface(INTERFACE_SCHEMA_EULER_ID));
1805         entriesStorage = ISchema(deployedAddress);
1806     
1807         schemaDefinition = _schemaDefinition;
1808         databaseInitStatus = true;
1809 
1810         emit DatabaseInitialized();
1811         return deployedAddress;
1812     }
1813 
1814     function transferFrom(
1815         address _from,
1816         address _to,
1817         uint256 _tokenId
1818     )
1819         public
1820         databaseInitialized
1821         whenNotPaused
1822     {
1823         super.transferFrom(_from, _to, _tokenId);
1824     }
1825 
1826     function safeTransferFrom(
1827         address _from,
1828         address _to,
1829         uint256 _tokenId
1830     )
1831         public
1832         databaseInitialized
1833         whenNotPaused
1834     {
1835         safeTransferFrom(
1836             _from,
1837             _to,
1838             _tokenId,
1839             ""
1840         );
1841     }
1842 
1843     function safeTransferFrom(
1844         address _from,
1845         address _to,
1846         uint256 _tokenId,
1847         bytes _data
1848     )
1849         public
1850         databaseInitialized
1851         whenNotPaused
1852     {
1853         transferFrom(_from, _to, _tokenId);
1854         require(
1855             checkAndCallSafeTransfer(
1856                 _from,
1857                 _to,
1858                 _tokenId,
1859                 _data
1860         ));
1861     }
1862 }
1863 
1864 // File: contracts/builders/DatabaseBuilderV1.sol
1865 
1866 /**
1867 * @title Chaingear - the novel Ethereum database framework
1868 * @author cyber•Congress, Valery litvin (@litvintech)
1869 * @notice not audited, not recommend to use in mainnet
1870 */
1871 contract DatabaseBuilderV1 is IDatabaseBuilder, SupportsInterfaceWithLookup {
1872 
1873 	/*
1874 	*  Storage
1875 	*/
1876 
1877     address private chaingear;    
1878     address private owner;
1879     
1880     bytes4 private constant INTERFACE_CHAINGEAR_EULER_ID = 0xea1db66f; 
1881     bytes4 private constant INTERFACE_DATABASE_BUILDER_EULER_ID = 0xce8bbf93;
1882     
1883     /*
1884     *  Events
1885     */
1886     
1887     event DatabaseDeployed(
1888         string name,
1889         string symbol,
1890         IDatabase database
1891     );
1892 
1893 	/*
1894 	*  Constructor
1895 	*/
1896 
1897     constructor() public {
1898         chaingear = address(0);
1899         owner = msg.sender;    
1900         _registerInterface(INTERFACE_DATABASE_BUILDER_EULER_ID);
1901     }
1902     
1903     /*
1904     *  Fallback
1905     */
1906     
1907     function() external {}
1908 
1909 	/*
1910 	*  External Functions
1911 	*/
1912     
1913     function deployDatabase(
1914         address[] _benefitiaries,
1915         uint256[] _shares,
1916         string _name,
1917         string _symbol
1918     )
1919         external
1920         returns (IDatabase)
1921     {
1922         require(msg.sender == chaingear);
1923         
1924         IDatabase databaseContract = new DatabaseV1(
1925             _benefitiaries,
1926             _shares,
1927             _name,
1928             _symbol
1929         );        
1930         databaseContract.transferOwnership(chaingear);
1931         emit DatabaseDeployed(_name, _symbol, databaseContract);
1932         
1933         return databaseContract;
1934     }
1935     
1936     /*
1937     *  Views
1938     */
1939 
1940     function setChaingearAddress(address _chaingear)
1941         external
1942     {
1943         require(msg.sender == owner);
1944         
1945         SupportsInterfaceWithLookup support = SupportsInterfaceWithLookup(_chaingear);
1946         require(support.supportsInterface(INTERFACE_CHAINGEAR_EULER_ID));
1947         chaingear = _chaingear;
1948     }
1949     
1950     function getChaingearAddress()
1951         external
1952         view
1953         returns (address)
1954     {
1955         return chaingear;
1956     }
1957     
1958     function getOwner()
1959         external
1960         view
1961         returns (address)
1962     {
1963         return owner;
1964     }
1965 }