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
820 // File: openzeppelin-solidity/contracts/payment/SplitPayment.sol
821 
822 /**
823  * @title SplitPayment
824  * @dev Base contract that supports multiple payees claiming funds sent to this contract
825  * according to the proportion they own.
826  */
827 contract SplitPayment {
828   using SafeMath for uint256;
829 
830   uint256 public totalShares = 0;
831   uint256 public totalReleased = 0;
832 
833   mapping(address => uint256) public shares;
834   mapping(address => uint256) public released;
835   address[] public payees;
836 
837   /**
838    * @dev Constructor
839    */
840   constructor(address[] _payees, uint256[] _shares) public payable {
841     require(_payees.length == _shares.length);
842 
843     for (uint256 i = 0; i < _payees.length; i++) {
844       addPayee(_payees[i], _shares[i]);
845     }
846   }
847 
848   /**
849    * @dev payable fallback
850    */
851   function () external payable {}
852 
853   /**
854    * @dev Claim your share of the balance.
855    */
856   function claim() public {
857     address payee = msg.sender;
858 
859     require(shares[payee] > 0);
860 
861     uint256 totalReceived = address(this).balance.add(totalReleased);
862     uint256 payment = totalReceived.mul(
863       shares[payee]).div(
864         totalShares).sub(
865           released[payee]
866     );
867 
868     require(payment != 0);
869     require(address(this).balance >= payment);
870 
871     released[payee] = released[payee].add(payment);
872     totalReleased = totalReleased.add(payment);
873 
874     payee.transfer(payment);
875   }
876 
877   /**
878    * @dev Add a new payee to the contract.
879    * @param _payee The address of the payee to add.
880    * @param _shares The number of shares owned by the payee.
881    */
882   function addPayee(address _payee, uint256 _shares) internal {
883     require(_payee != address(0));
884     require(_shares > 0);
885     require(shares[_payee] == 0);
886 
887     payees.push(_payee);
888     shares[_payee] = _shares;
889     totalShares = totalShares.add(_shares);
890   }
891 }
892 
893 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
894 
895 /**
896  * @title Ownable
897  * @dev The Ownable contract has an owner address, and provides basic authorization control
898  * functions, this simplifies the implementation of "user permissions".
899  */
900 contract Ownable {
901   address public owner;
902 
903 
904   event OwnershipRenounced(address indexed previousOwner);
905   event OwnershipTransferred(
906     address indexed previousOwner,
907     address indexed newOwner
908   );
909 
910 
911   /**
912    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
913    * account.
914    */
915   constructor() public {
916     owner = msg.sender;
917   }
918 
919   /**
920    * @dev Throws if called by any account other than the owner.
921    */
922   modifier onlyOwner() {
923     require(msg.sender == owner);
924     _;
925   }
926 
927   /**
928    * @dev Allows the current owner to relinquish control of the contract.
929    * @notice Renouncing to ownership will leave the contract without an owner.
930    * It will not be possible to call the functions with the `onlyOwner`
931    * modifier anymore.
932    */
933   function renounceOwnership() public onlyOwner {
934     emit OwnershipRenounced(owner);
935     owner = address(0);
936   }
937 
938   /**
939    * @dev Allows the current owner to transfer control of the contract to a newOwner.
940    * @param _newOwner The address to transfer ownership to.
941    */
942   function transferOwnership(address _newOwner) public onlyOwner {
943     _transferOwnership(_newOwner);
944   }
945 
946   /**
947    * @dev Transfers control of the contract to a newOwner.
948    * @param _newOwner The address to transfer ownership to.
949    */
950   function _transferOwnership(address _newOwner) internal {
951     require(_newOwner != address(0));
952     emit OwnershipTransferred(owner, _newOwner);
953     owner = _newOwner;
954   }
955 }
956 
957 // File: contracts/common/IDatabase.sol
958 
959 interface IDatabase {
960     
961     function createEntry() external payable returns (uint256);
962     function auth(uint256, address) external;
963     function deleteEntry(uint256) external;
964     function fundEntry(uint256) external payable;
965     function claimEntryFunds(uint256, uint256) external;
966     function updateEntryCreationFee(uint256) external;
967     function updateDatabaseDescription(string) external;
968     function addDatabaseTag(bytes32) external;
969     function updateDatabaseTag(uint8, bytes32) external;
970     function removeDatabaseTag(uint8) external;
971     function readEntryMeta(uint256) external view returns (
972         address,
973         address,
974         uint256,
975         uint256,
976         uint256,
977         uint256
978     );
979     function getChaingearID() external view returns (uint256);
980     function getEntriesIDs() external view returns (uint256[]);
981     function getIndexByID(uint256) external view returns (uint256);
982     function getEntryCreationFee() external view returns (uint256);
983     function getEntriesStorage() external view returns (address);
984     function getSchemaDefinition() external view returns (string);
985     function getDatabaseBalance() external view returns (uint256);
986     function getDatabaseDescription() external view returns (string);
987     function getDatabaseTags() external view returns (bytes32[]);
988     function getDatabaseSafe() external view returns (address);
989     function getSafeBalance() external view returns (uint256);
990     function getDatabaseInitStatus() external view returns (bool);
991     function pause() external;
992     function unpause() external;
993     function transferAdminRights(address) external;
994     function getAdmin() external view returns (address);
995     function getPaused() external view returns (bool);
996     function transferOwnership(address) external;
997     function deletePayees() external;
998 }
999 
1000 // File: contracts/common/IDatabaseBuilder.sol
1001 
1002 interface IDatabaseBuilder {
1003     
1004     function deployDatabase(
1005         address[],
1006         uint256[],
1007         string,
1008         string
1009     ) external returns (IDatabase);
1010     function setChaingearAddress(address) external;
1011     function getChaingearAddress() external view returns (address);
1012     function getOwner() external view returns (address);
1013 }
1014 
1015 // File: contracts/common/IChaingear.sol
1016 
1017 interface IChaingear {
1018     
1019     function addDatabaseBuilderVersion(
1020         string,
1021         IDatabaseBuilder,
1022         string,
1023         string
1024     ) external;
1025     function updateDatabaseBuilderDescription(string, string) external;
1026     function depricateDatabaseBuilder(string) external;
1027     function createDatabase(
1028         string,
1029         address[],
1030         uint256[],
1031         string,
1032         string
1033     ) external payable returns (address, uint256);
1034     function deleteDatabase(uint256) external;
1035     function fundDatabase(uint256) external payable;
1036     function claimDatabaseFunds(uint256, uint256) external;
1037     function updateCreationFee(uint256) external;
1038     function getAmountOfBuilders() external view returns (uint256);
1039     function getBuilderByID(uint256) external view returns(string);
1040     function getDatabaseBuilder(string) external view returns(address, string, string, bool);
1041     function getDatabasesIDs() external view returns (uint256[]);
1042     function getDatabaseIDByAddress(address) external view returns (uint256);
1043     function getDatabaseAddressByName(string) external view returns (address);
1044     function getDatabaseSymbolByID(uint256) external view returns (string);
1045     function getDatabaseIDBySymbol(string) external view returns (uint256);
1046     function getDatabase(uint256) external view returns (
1047         string,
1048         string,
1049         address,
1050         string,
1051         uint256,
1052         address,
1053         uint256
1054     );
1055     function getDatabaseBalance(uint256) external view returns (uint256, uint256);
1056     function getChaingearDescription() external pure returns (string);
1057     function getCreationFeeWei() external view returns (uint256);
1058     function getSafeBalance() external view returns (uint256);
1059     function getSafeAddress() external view returns (address);
1060     function getNameExist(string) external view returns (bool);
1061     function getSymbolExist(string) external view returns (bool);
1062 }
1063 
1064 // File: contracts/common/ISchema.sol
1065 
1066 interface ISchema {
1067 
1068     function createEntry() external;
1069     function deleteEntry(uint256) external;
1070 }
1071 
1072 // File: contracts/common/Safe.sol
1073 
1074 /**
1075 * @title Chaingear - the novel Ethereum database framework
1076 * @author cyber•Congress, Valery litvin (@litvintech)
1077 * @notice not audited, not recommend to use in mainnet
1078 */
1079 contract Safe {
1080     
1081     address private owner;
1082 
1083     constructor() public
1084     {
1085         owner = msg.sender;
1086     }
1087 
1088     function()
1089         external
1090         payable
1091     {
1092         require(msg.sender == owner);
1093     }
1094 
1095     function claim(address _entryOwner, uint256 _amount)
1096         external
1097     {
1098         require(msg.sender == owner);
1099         require(_amount <= address(this).balance);
1100         require(_entryOwner != address(0));
1101         
1102         _entryOwner.transfer(_amount);
1103     }
1104 
1105     function getOwner()
1106         external
1107         view
1108         returns(address)
1109     {
1110         return owner;
1111     }
1112 }
1113 
1114 // File: contracts/common/PaymentSplitter.sol
1115 
1116 /**
1117  * @title PaymentSplitter
1118  * @dev This contract can be used when payments need to be received by a group
1119  * of people and split proportionately to some number of shares they own.
1120  */
1121 contract PaymentSplitter {
1122     
1123     using SafeMath for uint256;
1124 
1125     uint256 internal totalShares;
1126     uint256 internal totalReleased;
1127 
1128     mapping(address => uint256) internal shares;
1129     mapping(address => uint256) internal released;
1130     address[] internal payees;
1131     
1132     event PayeeAdded(address account, uint256 shares);
1133     event PaymentReleased(address to, uint256 amount);
1134     event PaymentReceived(address from, uint256 amount);
1135 
1136     constructor (address[] _payees, uint256[] _shares)
1137         public
1138         payable
1139     {
1140         _initializePayess(_payees, _shares);
1141     }
1142 
1143     function ()
1144         external
1145         payable
1146     {
1147         emit PaymentReceived(msg.sender, msg.value);
1148     }
1149 
1150     function getTotalShares()
1151         external
1152         view
1153         returns (uint256)
1154     {
1155         return totalShares;
1156     }
1157 
1158     function getTotalReleased()
1159         external
1160         view
1161         returns (uint256)
1162     {
1163         return totalReleased;
1164     }
1165 
1166     function getShares(address _account)
1167         external
1168         view
1169         returns (uint256)
1170     {
1171         return shares[_account];
1172     }
1173 
1174     function getReleased(address _account)
1175         external
1176         view
1177         returns (uint256)
1178     {
1179         return released[_account];
1180     }
1181 
1182     function getPayee(uint256 _index)
1183         external
1184         view
1185         returns (address)
1186     {
1187         return payees[_index];
1188     }
1189     
1190     function getPayeesCount() 
1191         external
1192         view
1193         returns (uint256)
1194     {   
1195         return payees.length;
1196     }
1197 
1198     function release(address _account) 
1199         public
1200     {
1201         require(shares[_account] > 0);
1202 
1203         uint256 totalReceived = address(this).balance.add(totalReleased);
1204         uint256 payment = totalReceived.mul(shares[_account]).div(totalShares).sub(released[_account]);
1205 
1206         require(payment != 0);
1207 
1208         released[_account] = released[_account].add(payment);
1209         totalReleased = totalReleased.add(payment);
1210 
1211         _account.transfer(payment);
1212         
1213         emit PaymentReleased(_account, payment);
1214     }
1215     
1216     function _initializePayess(address[] _payees, uint256[] _shares)
1217         internal
1218     {
1219         require(payees.length == 0);
1220         require(_payees.length == _shares.length);
1221         require(_payees.length > 0 && _payees.length <= 8);
1222 
1223         for (uint256 i = 0; i < _payees.length; i++) {
1224             _addPayee(_payees[i], _shares[i]);
1225         }
1226     }
1227 
1228     function _addPayee(
1229         address _account,
1230         uint256 _shares
1231     ) 
1232         internal
1233     {
1234         require(_account != address(0));
1235         require(_shares > 0);
1236         require(shares[_account] == 0);
1237 
1238         payees.push(_account);
1239         shares[_account] = _shares;
1240         totalShares = totalShares.add(_shares);
1241         
1242         emit PayeeAdded(_account, _shares);
1243     }
1244 }
1245 
1246 // File: contracts/databases/DatabasePermissionControl.sol
1247 
1248 /**
1249 * @title Chaingear - the novel Ethereum database framework
1250 * @author cyber•Congress, Valery litvin (@litvintech)
1251 * @notice not audited, not recommend to use in mainnet
1252 */
1253 contract DatabasePermissionControl is Ownable {
1254 
1255     /*
1256     *  Storage
1257     */
1258 
1259     enum CreateEntryPermissionGroup {OnlyAdmin, Whitelist, AllUsers}
1260 
1261     address private admin;
1262     bool private paused = true;
1263 
1264     mapping(address => bool) private whitelist;
1265 
1266     CreateEntryPermissionGroup private permissionGroup = CreateEntryPermissionGroup.OnlyAdmin;
1267 
1268     /*
1269     *  Events
1270     */
1271 
1272     event Pause();
1273     event Unpause();
1274     event PermissionGroupChanged(CreateEntryPermissionGroup);
1275     event AddedToWhitelist(address);
1276     event RemovedFromWhitelist(address);
1277     event AdminshipTransferred(address, address);
1278 
1279     /*
1280     *  Constructor
1281     */
1282 
1283     constructor()
1284         public
1285     { }
1286 
1287     /*
1288     *  Modifiers
1289     */
1290 
1291     modifier whenNotPaused() {
1292         require(!paused);
1293         _;
1294     }
1295 
1296     modifier whenPaused() {
1297         require(paused);
1298         _;
1299     }
1300 
1301     modifier onlyAdmin() {
1302         require(msg.sender == admin);
1303         _;
1304     }
1305 
1306     modifier onlyPermissionedToCreateEntries() {
1307         if (permissionGroup == CreateEntryPermissionGroup.OnlyAdmin) {
1308             require(msg.sender == admin);
1309         } else if (permissionGroup == CreateEntryPermissionGroup.Whitelist) {
1310             require(whitelist[msg.sender] == true || msg.sender == admin);
1311         }
1312         _;
1313     }
1314 
1315     /*
1316     *  External functions
1317     */
1318 
1319     function pause()
1320         external
1321         onlyAdmin
1322         whenNotPaused
1323     {
1324         paused = true;
1325         emit Pause();
1326     }
1327 
1328     function unpause()
1329         external
1330         onlyAdmin
1331         whenPaused
1332     {
1333         paused = false;
1334         emit Unpause();
1335     }
1336 
1337     function transferAdminRights(address _newAdmin)
1338         external
1339         onlyOwner
1340         whenPaused
1341     {
1342         require(_newAdmin != address(0));
1343         emit AdminshipTransferred(admin, _newAdmin);
1344         admin = _newAdmin;
1345     }
1346 
1347     function updateCreateEntryPermissionGroup(CreateEntryPermissionGroup _newPermissionGroup)
1348         external
1349         onlyAdmin
1350         whenPaused
1351     {
1352         require(CreateEntryPermissionGroup.AllUsers >= _newPermissionGroup);
1353         
1354         permissionGroup = _newPermissionGroup;
1355         emit PermissionGroupChanged(_newPermissionGroup);
1356     }
1357 
1358     function addToWhitelist(address _address)
1359         external
1360         onlyAdmin
1361         whenPaused
1362     {
1363         whitelist[_address] = true;
1364         emit AddedToWhitelist(_address);
1365     }
1366 
1367     function removeFromWhitelist(address _address)
1368         external
1369         onlyAdmin
1370         whenPaused
1371     {
1372         whitelist[_address] = false;
1373         emit RemovedFromWhitelist(_address);
1374     }
1375 
1376     function getAdmin()
1377         external
1378         view
1379         returns (address)
1380     {
1381         return admin;
1382     }
1383 
1384     function getDatabasePermissions()
1385         external
1386         view
1387         returns (CreateEntryPermissionGroup)
1388     {
1389         return permissionGroup;
1390     }
1391 
1392     function checkWhitelisting(address _address)
1393         external
1394         view
1395         returns (bool)
1396     {
1397         return whitelist[_address];
1398     }
1399     
1400     function getPaused()
1401         external
1402         view
1403         returns (bool)
1404     {
1405         return paused;
1406     }
1407 }
1408 
1409 // File: contracts/databases/FeeSplitterDatabase.sol
1410 
1411 contract FeeSplitterDatabase is PaymentSplitter, DatabasePermissionControl {
1412     
1413     event PayeeAddressChanged(
1414         uint8 payeeIndex, 
1415         address oldAddress, 
1416         address newAddress
1417     );
1418     event PayeesDeleted();
1419     event Log();
1420 
1421     constructor(address[] _payees, uint256[] _shares)
1422         public
1423         payable
1424         PaymentSplitter(_payees, _shares)
1425     { }
1426     
1427     function ()
1428         external
1429         payable
1430         whenNotPaused
1431     {
1432         emit PaymentReceived(msg.sender, msg.value);
1433     }
1434     
1435     function changePayeeAddress(uint8 _payeeIndex, address _newAddress)
1436         external
1437         whenNotPaused
1438     {
1439         require(_payeeIndex < 8);
1440         require(msg.sender == payees[_payeeIndex]);
1441         require(payees[_payeeIndex] != _newAddress);
1442         
1443         address oldAddress = payees[_payeeIndex];
1444 
1445         shares[_newAddress] = shares[oldAddress];
1446         released[_newAddress] = released[oldAddress];
1447         payees[_payeeIndex] = _newAddress;
1448 
1449         delete shares[oldAddress];
1450         delete released[oldAddress];
1451 
1452         emit PayeeAddressChanged(_payeeIndex, oldAddress, _newAddress);
1453     }
1454     
1455     function setPayess(address[] _payees, uint256[] _shares)
1456         external
1457         whenPaused
1458         onlyAdmin
1459     {
1460         _initializePayess(_payees, _shares);
1461     }
1462     
1463     function deletePayees()
1464         external
1465         whenPaused
1466         onlyOwner
1467     {
1468         for (uint8 i = 0; i < payees.length; i++) {
1469             address account = payees[i];
1470             delete shares[account];
1471             delete released[account];
1472             emit Log();
1473         }
1474         payees.length = 0;
1475         totalShares = 0;
1476         totalReleased = 0;
1477         
1478         emit PayeesDeleted();
1479     }
1480 }
1481 
1482 // File: contracts/databases/DatabaseV1.sol
1483 
1484 /**
1485 * @title Chaingear - the novel Ethereum database framework
1486 * @author cyber•Congress, Valery litvin (@litvintech)
1487 * @notice not audited, not recommend to use in mainnet
1488 */
1489 contract DatabaseV1 is IDatabase, Ownable, DatabasePermissionControl, SupportsInterfaceWithLookup, FeeSplitterDatabase, ERC721Token {
1490 
1491     using SafeMath for uint256;
1492 
1493     /*
1494     *  Storage
1495     */
1496     
1497     bytes4 private constant INTERFACE_SCHEMA_EULER_ID = 0x153366ed;
1498     bytes4 private constant INTERFACE_DATABASE_V1_EULER_ID = 0xf2c320c4;
1499 
1500     // @dev Metadata of entry, holds ownership data and funding info
1501     struct EntryMeta {
1502         address creator;
1503         uint256 createdAt;
1504         uint256 lastUpdateTime;
1505         uint256 currentWei;
1506         uint256 accumulatedWei;
1507     }
1508 
1509     EntryMeta[] private entriesMeta;
1510     Safe private databaseSafe;
1511 
1512     uint256 private headTokenID = 0;
1513     uint256 private entryCreationFeeWei = 0;
1514 
1515     bytes32[] private databaseTags;
1516     string private databaseDescription;
1517     
1518     string private schemaDefinition;
1519     ISchema private entriesStorage;
1520     bool private databaseInitStatus = false;
1521 
1522     /*
1523     *  Modifiers
1524     */
1525 
1526     modifier onlyOwnerOf(uint256 _entryID){
1527         require(ownerOf(_entryID) == msg.sender);
1528         _;
1529     }
1530 
1531     modifier databaseInitialized {
1532         require(databaseInitStatus == true);
1533         _;
1534     }
1535 
1536     /**
1537     *  Events
1538     */
1539 
1540     event EntryCreated(uint256 entryID, address creator);
1541     event EntryDeleted(uint256 entryID, address owner);
1542     event EntryFunded(
1543         uint256 entryID,
1544         address funder,
1545         uint256 amount
1546     );
1547     event EntryFundsClaimed(
1548         uint256 entryID,
1549         address claimer,
1550         uint256 amount
1551     );
1552     event EntryCreationFeeUpdated(uint256 newFees);
1553     event DescriptionUpdated(string newDescription);
1554     event DatabaseInitialized();
1555     event TagAdded(bytes32 tag);
1556     event TagUpdated(uint8 index, bytes32 tag);
1557     event TagDeleted(uint8 index);
1558 
1559     /*
1560     *  Constructor
1561     */
1562 
1563     constructor(
1564         address[] _beneficiaries,
1565         uint256[] _shares,
1566         string _name,
1567         string _symbol
1568     )
1569         ERC721Token (_name, _symbol)
1570         FeeSplitterDatabase (_beneficiaries, _shares)
1571         public
1572         payable
1573     {
1574         _registerInterface(INTERFACE_DATABASE_V1_EULER_ID);
1575         databaseSafe = new Safe();
1576     }
1577 
1578     /*
1579     *  External functions
1580     */
1581 
1582     function createEntry()
1583         external
1584         databaseInitialized
1585         onlyPermissionedToCreateEntries
1586         whenNotPaused
1587         payable
1588         returns (uint256)
1589     {
1590         require(msg.value == entryCreationFeeWei);
1591 
1592         EntryMeta memory meta = (EntryMeta(
1593         {
1594             lastUpdateTime: block.timestamp,
1595             createdAt: block.timestamp,
1596             creator: msg.sender,
1597             currentWei: 0,
1598             accumulatedWei: 0
1599         }));
1600         entriesMeta.push(meta);
1601 
1602         uint256 newTokenID = headTokenID;
1603         super._mint(msg.sender, newTokenID);
1604         headTokenID = headTokenID.add(1);
1605 
1606         emit EntryCreated(newTokenID, msg.sender);
1607 
1608         entriesStorage.createEntry();
1609 
1610         return newTokenID;
1611     }
1612 
1613     function auth(uint256 _entryID, address _caller)
1614         external
1615         whenNotPaused
1616     {
1617         require(msg.sender == address(entriesStorage));
1618         require(ownerOf(_entryID) == _caller);
1619         uint256 entryIndex = allTokensIndex[_entryID];
1620         entriesMeta[entryIndex].lastUpdateTime = block.timestamp;
1621     }
1622 
1623     function deleteEntry(uint256 _entryID)
1624         external
1625         databaseInitialized
1626         onlyOwnerOf(_entryID)
1627         whenNotPaused
1628     {
1629         uint256 entryIndex = allTokensIndex[_entryID];
1630         require(entriesMeta[entryIndex].currentWei == 0);
1631 
1632         uint256 lastEntryIndex = entriesMeta.length.sub(1);
1633         EntryMeta memory lastEntry = entriesMeta[lastEntryIndex];
1634 
1635         entriesMeta[entryIndex] = lastEntry;
1636         delete entriesMeta[lastEntryIndex];
1637         entriesMeta.length--;
1638 
1639         super._burn(msg.sender, _entryID);
1640         emit EntryDeleted(_entryID, msg.sender);
1641 
1642         entriesStorage.deleteEntry(entryIndex);
1643     }
1644 
1645     function fundEntry(uint256 _entryID)
1646         external
1647         databaseInitialized
1648         whenNotPaused
1649         payable
1650     {
1651         require(exists(_entryID) == true);
1652 
1653         uint256 entryIndex = allTokensIndex[_entryID];
1654         uint256 currentWei = entriesMeta[entryIndex].currentWei.add(msg.value);
1655         entriesMeta[entryIndex].currentWei = currentWei;
1656 
1657         uint256 accumulatedWei = entriesMeta[entryIndex].accumulatedWei.add(msg.value);
1658         entriesMeta[entryIndex].accumulatedWei = accumulatedWei;
1659 
1660         emit EntryFunded(_entryID, msg.sender, msg.value);
1661         address(databaseSafe).transfer(msg.value);
1662     }
1663 
1664     function claimEntryFunds(uint256 _entryID, uint256 _amount)
1665         external
1666         databaseInitialized
1667         onlyOwnerOf(_entryID)
1668         whenNotPaused
1669     {
1670         uint256 entryIndex = allTokensIndex[_entryID];
1671 
1672         uint256 currentWei = entriesMeta[entryIndex].currentWei;
1673         require(_amount <= currentWei);
1674         entriesMeta[entryIndex].currentWei = currentWei.sub(_amount);
1675 
1676         emit EntryFundsClaimed(_entryID, msg.sender, _amount);
1677         databaseSafe.claim(msg.sender, _amount);
1678     }
1679 
1680     function updateEntryCreationFee(uint256 _newFee)
1681         external
1682         onlyAdmin
1683         whenPaused
1684     {
1685         entryCreationFeeWei = _newFee;
1686         emit EntryCreationFeeUpdated(_newFee);
1687     }
1688 
1689     function updateDatabaseDescription(string _newDescription)
1690         external
1691         onlyAdmin
1692     {
1693         databaseDescription = _newDescription;
1694         emit DescriptionUpdated(_newDescription);
1695     }
1696 
1697     function addDatabaseTag(bytes32 _tag)
1698         external
1699         onlyAdmin
1700     {
1701         require(databaseTags.length < 16);
1702         databaseTags.push(_tag);    
1703         emit TagAdded(_tag);
1704     }
1705 
1706     function updateDatabaseTag(uint8 _index, bytes32 _tag)
1707         external
1708         onlyAdmin
1709     {
1710         require(_index < databaseTags.length);
1711         databaseTags[_index] = _tag;    
1712         emit TagUpdated(_index, _tag);
1713     }
1714 
1715     function removeDatabaseTag(uint8 _index)
1716         external
1717         onlyAdmin
1718     {
1719         require(databaseTags.length > 0);
1720         require(_index < databaseTags.length);
1721 
1722         uint256 lastTagIndex = databaseTags.length.sub(1);
1723         bytes32 lastTag = databaseTags[lastTagIndex];
1724 
1725         databaseTags[_index] = lastTag;
1726         databaseTags[lastTagIndex] = "";
1727         databaseTags.length--;
1728         
1729         emit TagDeleted(_index);
1730     }
1731 
1732     /*
1733     *  View functions
1734     */
1735 
1736     function readEntryMeta(uint256 _entryID)
1737         external
1738         view
1739         returns (
1740             address,
1741             address,
1742             uint256,
1743             uint256,
1744             uint256,
1745             uint256
1746         )
1747     {
1748         require(exists(_entryID) == true);
1749         uint256 entryIndex = allTokensIndex[_entryID];
1750 
1751         EntryMeta memory m = entriesMeta[entryIndex];
1752         return(
1753             ownerOf(_entryID),
1754             m.creator,
1755             m.createdAt,
1756             m.lastUpdateTime,
1757             m.currentWei,
1758             m.accumulatedWei
1759         );
1760     }
1761 
1762     function getChaingearID()
1763         external
1764         view
1765         returns(uint256)
1766     {
1767         return IChaingear(owner).getDatabaseIDByAddress(address(this));
1768     }
1769 
1770     function getEntriesIDs()
1771         external
1772         view
1773         returns (uint256[])
1774     {
1775         return allTokens;
1776     }
1777 
1778     function getIndexByID(uint256 _entryID)
1779         external
1780         view
1781         returns (uint256)
1782     {
1783         require(exists(_entryID) == true);
1784         return allTokensIndex[_entryID];
1785     }
1786 
1787     function getEntryCreationFee()
1788         external
1789         view
1790         returns (uint256)
1791     {
1792         return entryCreationFeeWei;
1793     }
1794 
1795     function getEntriesStorage()
1796         external
1797         view
1798         returns (address)
1799     {
1800         return address(entriesStorage);
1801     }
1802     
1803     function getSchemaDefinition()
1804         external
1805         view
1806         returns (string)
1807     {
1808         return schemaDefinition;
1809     }
1810 
1811     function getDatabaseBalance()
1812         external
1813         view
1814         returns (uint256)
1815     {
1816         return address(this).balance;
1817     }
1818 
1819     function getDatabaseDescription()
1820         external
1821         view
1822         returns (string)
1823     {
1824         return databaseDescription;
1825     }
1826 
1827     function getDatabaseTags()
1828         external
1829         view
1830         returns (bytes32[])
1831     {
1832         return databaseTags;
1833     }
1834 
1835     function getDatabaseSafe()
1836         external
1837         view
1838         returns (address)
1839     {
1840         return databaseSafe;
1841     }
1842 
1843     function getSafeBalance()
1844         external
1845         view
1846         returns (uint256)
1847     {
1848         return address(databaseSafe).balance;
1849     }
1850 
1851     function getDatabaseInitStatus()
1852         external
1853         view
1854         returns (bool)
1855     {
1856         return databaseInitStatus;
1857     }
1858 
1859     /**
1860     *  Public functions
1861     */
1862     
1863     function initializeDatabase(string _schemaDefinition, bytes _schemaBytecode)
1864         public
1865         onlyAdmin
1866         whenPaused
1867         returns (address)
1868     {
1869         require(databaseInitStatus == false);
1870         address deployedAddress;
1871 
1872         assembly {
1873             let s := mload(_schemaBytecode)
1874             let p := add(_schemaBytecode, 0x20)
1875             deployedAddress := create(0, p, s)
1876         }
1877 
1878         require(deployedAddress != address(0));
1879         require(SupportsInterfaceWithLookup(deployedAddress).supportsInterface(INTERFACE_SCHEMA_EULER_ID));
1880         entriesStorage = ISchema(deployedAddress);
1881     
1882         schemaDefinition = _schemaDefinition;
1883         databaseInitStatus = true;
1884 
1885         emit DatabaseInitialized();
1886         return deployedAddress;
1887     }
1888 
1889     function transferFrom(
1890         address _from,
1891         address _to,
1892         uint256 _tokenId
1893     )
1894         public
1895         databaseInitialized
1896         whenNotPaused
1897     {
1898         super.transferFrom(_from, _to, _tokenId);
1899     }
1900 
1901     function safeTransferFrom(
1902         address _from,
1903         address _to,
1904         uint256 _tokenId
1905     )
1906         public
1907         databaseInitialized
1908         whenNotPaused
1909     {
1910         safeTransferFrom(
1911             _from,
1912             _to,
1913             _tokenId,
1914             ""
1915         );
1916     }
1917 
1918     function safeTransferFrom(
1919         address _from,
1920         address _to,
1921         uint256 _tokenId,
1922         bytes _data
1923     )
1924         public
1925         databaseInitialized
1926         whenNotPaused
1927     {
1928         transferFrom(_from, _to, _tokenId);
1929         require(
1930             checkAndCallSafeTransfer(
1931                 _from,
1932                 _to,
1933                 _tokenId,
1934                 _data
1935         ));
1936     }
1937 }
1938 
1939 // File: contracts/builders/DatabaseBuilderV1.sol
1940 
1941 /**
1942 * @title Chaingear - the novel Ethereum database framework
1943 * @author cyber•Congress, Valery litvin (@litvintech)
1944 * @notice not audited, not recommend to use in mainnet
1945 */
1946 contract DatabaseBuilderV1 is IDatabaseBuilder, SupportsInterfaceWithLookup {
1947 
1948 	/*
1949 	*  Storage
1950 	*/
1951 
1952     address private chaingear;    
1953     address private owner;
1954     
1955     bytes4 private constant INTERFACE_CHAINGEAR_EULER_ID = 0xea1db66f; 
1956     bytes4 private constant INTERFACE_DATABASE_BUILDER_EULER_ID = 0xce8bbf93;
1957     
1958     /*
1959     *  Events
1960     */
1961     
1962     event DatabaseDeployed(
1963         string name,
1964         string symbol,
1965         IDatabase database
1966     );
1967 
1968 	/*
1969 	*  Constructor
1970 	*/
1971 
1972     constructor() public {
1973         chaingear = address(0);
1974         owner = msg.sender;    
1975         _registerInterface(INTERFACE_DATABASE_BUILDER_EULER_ID);
1976     }
1977     
1978     /*
1979     *  Fallback
1980     */
1981     
1982     function() external {}
1983 
1984 	/*
1985 	*  External Functions
1986 	*/
1987     
1988     function deployDatabase(
1989         address[] _benefitiaries,
1990         uint256[] _shares,
1991         string _name,
1992         string _symbol
1993     )
1994         external
1995         returns (IDatabase)
1996     {
1997         require(msg.sender == chaingear);
1998         
1999         IDatabase databaseContract = new DatabaseV1(
2000             _benefitiaries,
2001             _shares,
2002             _name,
2003             _symbol
2004         );        
2005         databaseContract.transferOwnership(chaingear);
2006         emit DatabaseDeployed(_name, _symbol, databaseContract);
2007         
2008         return databaseContract;
2009     }
2010     
2011     /*
2012     *  Views
2013     */
2014 
2015     function setChaingearAddress(address _chaingear)
2016         external
2017     {
2018         require(msg.sender == owner);
2019         
2020         SupportsInterfaceWithLookup support = SupportsInterfaceWithLookup(_chaingear);
2021         require(support.supportsInterface(INTERFACE_CHAINGEAR_EULER_ID));
2022         chaingear = _chaingear;
2023     }
2024     
2025     function getChaingearAddress()
2026         external
2027         view
2028         returns (address)
2029     {
2030         return chaingear;
2031     }
2032     
2033     function getOwner()
2034         external
2035         view
2036         returns (address)
2037     {
2038         return owner;
2039     }
2040 }