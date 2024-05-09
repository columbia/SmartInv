1 pragma solidity ^0.4.24;
2 
3 // File: contracts/openzeppelin-solidity/contracts/introspection/ERC165.sol
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
23 // File: contracts/openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
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
75 // File: contracts/openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
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
160 // File: contracts/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
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
198 // File: contracts/openzeppelin-solidity/contracts/AddressUtils.sol
199 
200 /**
201  * Utility library of inline functions on addresses
202  */
203 library AddressUtils {
204 
205   /**
206    * Returns whether the target address is a contract
207    * @dev This function will return false if invoked during the constructor of a contract,
208    * as the code is not actually created until after the constructor finishes.
209    * @param _addr address to check
210    * @return whether the target address is a contract
211    */
212   function isContract(address _addr) internal view returns (bool) {
213     uint256 size;
214     // XXX Currently there is no better way to check if there is a contract in an address
215     // than to check the size of the code at that address.
216     // See https://ethereum.stackexchange.com/a/14016/36603
217     // for more details about how this works.
218     // TODO Check this again before the Serenity release, because all addresses will be
219     // contracts then.
220     // solium-disable-next-line security/no-inline-assembly
221     assembly { size := extcodesize(_addr) }
222     return size > 0;
223   }
224 
225 }
226 
227 // File: contracts/openzeppelin-solidity/contracts/math/SafeMath.sol
228 
229 /**
230  * @title SafeMath
231  * @dev Math operations with safety checks that throw on error
232  */
233 library SafeMath {
234 
235   /**
236   * @dev Multiplies two numbers, throws on overflow.
237   */
238   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
239     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
240     // benefit is lost if 'b' is also tested.
241     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
242     if (_a == 0) {
243       return 0;
244     }
245 
246     c = _a * _b;
247     assert(c / _a == _b);
248     return c;
249   }
250 
251   /**
252   * @dev Integer division of two numbers, truncating the quotient.
253   */
254   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
255     // assert(_b > 0); // Solidity automatically throws when dividing by 0
256     // uint256 c = _a / _b;
257     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
258     return _a / _b;
259   }
260 
261   /**
262   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
263   */
264   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
265     assert(_b <= _a);
266     return _a - _b;
267   }
268 
269   /**
270   * @dev Adds two numbers, throws on overflow.
271   */
272   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
273     c = _a + _b;
274     assert(c >= _a);
275     return c;
276   }
277 }
278 
279 // File: contracts/openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
280 
281 /**
282  * @title ERC721 token receiver interface
283  * @dev Interface for any contract that wants to support safeTransfers
284  * from ERC721 asset contracts.
285  */
286 contract ERC721Receiver {
287   /**
288    * @dev Magic value to be returned upon successful reception of an NFT
289    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
290    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
291    */
292   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
293 
294   /**
295    * @notice Handle the receipt of an NFT
296    * @dev The ERC721 smart contract calls this function on the recipient
297    * after a `safetransfer`. This function MAY throw to revert and reject the
298    * transfer. Return of other than the magic value MUST result in the
299    * transaction being reverted.
300    * Note: the contract address is always the message sender.
301    * @param _operator The address which called `safeTransferFrom` function
302    * @param _from The address which previously owned the token
303    * @param _tokenId The NFT identifier which is being transferred
304    * @param _data Additional data with no specified format
305    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
306    */
307   function onERC721Received(
308     address _operator,
309     address _from,
310     uint256 _tokenId,
311     bytes _data
312   )
313     public
314     returns(bytes4);
315 }
316 
317 // File: contracts/openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
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
623 // File: contracts/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
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
820 // File: contracts/DappsGallery.sol
821 
822 contract DappsGallery is ERC721Token {
823 
824     string[] public dns;
825     mapping (string=>Redirect) redirects;
826 
827     struct Redirect {
828         string uri;
829         bool   registered;
830     }
831 
832     event DappsRegistered(address _owner, string _dns, string _uri);
833     event DappsSet(uint256 _tokenId, string _dns, string _uri);
834     event TokenURISet(uint256 _tokenId, string _uri);
835 
836     constructor () ERC721Token("DappsGallery" ,"DG") {
837         dns.push("");
838     }
839 
840     function registerDapps(string _dns, string _uri) public payable {
841         require(!redirects[_dns].registered);
842         redirects[_dns].registered = true;
843         redirects[_dns].uri = _uri;
844         uint _tokenId = dns.push(_dns) - 1;
845         _mint(msg.sender, _tokenId);   
846         emit DappsRegistered(msg.sender, _dns, _uri);
847     }
848     
849     function setDapps(uint256 _tokenId, string _dns, string _uri) public {
850         require(!redirects[_dns].registered);
851         require(ownerOf(_tokenId) == msg.sender);
852         delete redirects[dns[_tokenId]];
853         dns[_tokenId] = _dns;
854         redirects[_dns].registered = true;
855         redirects[_dns].uri = _uri;
856         emit DappsSet(_tokenId, _dns, _uri);
857     }
858 
859     function setTokenURI(uint256 _tokenId, string _uri) public {
860         require(ownerOf(_tokenId) == msg.sender);
861         _setTokenURI(_tokenId, _uri);
862         emit TokenURISet(_tokenId, _uri);
863     }
864     
865     function getRedirect(string _dns) public view returns (string) {
866         require(redirects[_dns].registered);
867         return redirects[_dns].uri;
868     } 
869 
870 }