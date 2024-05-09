1 pragma solidity ^0.4.23;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library AddressUtils {
7 
8   /**
9    * Returns whether the target address is a contract
10    * @dev This function will return false if invoked during the constructor of a contract,
11    * as the code is not actually created until after the constructor finishes.
12    * @param addr address to check
13    * @return whether the target address is a contract
14    */
15   function isContract(address addr) internal view returns (bool) {
16     uint256 size;
17     // XXX Currently there is no better way to check if there is a contract in an address
18     // than to check the size of the code at that address.
19     // See https://ethereum.stackexchange.com/a/14016/36603
20     // for more details about how this works.
21     // TODO Check this again before the Serenity release, because all addresses will be
22     // contracts then.
23     // solium-disable-next-line security/no-inline-assembly
24     assembly { size := extcodesize(addr) }
25     return size > 0;
26   }
27 
28 }
29 
30 
31 
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
44     // benefit is lost if 'b' is also tested.
45     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46     if (a == 0) {
47       return 0;
48     }
49 
50     c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     // uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return a / b;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 
84 
85 
86 
87 /**
88  * @title ERC165
89  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
90  */
91 interface ERC165 {
92 
93   /**
94    * @notice Query if a contract implements an interface
95    * @param _interfaceId The interface identifier, as specified in ERC-165
96    * @dev Interface identification is specified in ERC-165. This function
97    * uses less than 30,000 gas.
98    */
99   function supportsInterface(bytes4 _interfaceId)
100     external
101     view
102     returns (bool);
103 }
104 
105 
106 
107 
108 
109 /**
110  * @title ERC721 Non-Fungible Token Standard basic interface
111  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
112  */
113 contract ERC721Basic is ERC165 {
114 
115   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
116   /*
117    * 0x80ac58cd ===
118    *   bytes4(keccak256('balanceOf(address)')) ^
119    *   bytes4(keccak256('ownerOf(uint256)')) ^
120    *   bytes4(keccak256('approve(address,uint256)')) ^
121    *   bytes4(keccak256('getApproved(uint256)')) ^
122    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
123    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
124    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
125    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
126    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
127    */
128 
129   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
130   /*
131    * 0x4f558e79 ===
132    *   bytes4(keccak256('exists(uint256)'))
133    */
134 
135   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
136   /**
137    * 0x780e9d63 ===
138    *   bytes4(keccak256('totalSupply()')) ^
139    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
140    *   bytes4(keccak256('tokenByIndex(uint256)'))
141    */
142 
143   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
144   /**
145    * 0x5b5e139f ===
146    *   bytes4(keccak256('name()')) ^
147    *   bytes4(keccak256('symbol()')) ^
148    *   bytes4(keccak256('tokenURI(uint256)'))
149    */
150 
151   event Transfer(
152     address indexed _from,
153     address indexed _to,
154     uint256 indexed _tokenId
155   );
156   event Approval(
157     address indexed _owner,
158     address indexed _approved,
159     uint256 indexed _tokenId
160   );
161   event ApprovalForAll(
162     address indexed _owner,
163     address indexed _operator,
164     bool _approved
165   );
166 
167   function balanceOf(address _owner) public view returns (uint256 _balance);
168   function ownerOf(uint256 _tokenId) public view returns (address _owner);
169   function exists(uint256 _tokenId) public view returns (bool _exists);
170 
171   function approve(address _to, uint256 _tokenId) public;
172   function getApproved(uint256 _tokenId)
173     public view returns (address _operator);
174 
175   function setApprovalForAll(address _operator, bool _approved) public;
176   function isApprovedForAll(address _owner, address _operator)
177     public view returns (bool);
178 
179   function transferFrom(address _from, address _to, uint256 _tokenId) public;
180   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
181     public;
182 
183   function safeTransferFrom(
184     address _from,
185     address _to,
186     uint256 _tokenId,
187     bytes _data
188   )
189     public;
190 }
191 
192 
193 
194 
195 
196 
197 
198 /**
199  * @title SupportsInterfaceWithLookup
200  * @author Matt Condon (@shrugs)
201  * @dev Implements ERC165 using a lookup table.
202  */
203 contract SupportsInterfaceWithLookup is ERC165 {
204 
205   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
206   /**
207    * 0x01ffc9a7 ===
208    *   bytes4(keccak256('supportsInterface(bytes4)'))
209    */
210 
211   /**
212    * @dev a mapping of interface id to whether or not it's supported
213    */
214   mapping(bytes4 => bool) internal supportedInterfaces;
215 
216   /**
217    * @dev A contract implementing SupportsInterfaceWithLookup
218    * implement ERC165 itself
219    */
220   constructor()
221     public
222   {
223     _registerInterface(InterfaceId_ERC165);
224   }
225 
226   /**
227    * @dev implement supportsInterface(bytes4) using a lookup table
228    */
229   function supportsInterface(bytes4 _interfaceId)
230     external
231     view
232     returns (bool)
233   {
234     return supportedInterfaces[_interfaceId];
235   }
236 
237   /**
238    * @dev private method for registering an interface
239    */
240   function _registerInterface(bytes4 _interfaceId)
241     internal
242   {
243     require(_interfaceId != 0xffffffff);
244     supportedInterfaces[_interfaceId] = true;
245   }
246 }
247 
248 
249 
250 
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 contract ERC721Receiver {
258   /**
259    * @dev Magic value to be returned upon successful reception of an NFT
260    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
261    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
262    */
263   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
264 
265   /**
266    * @notice Handle the receipt of an NFT
267    * @dev The ERC721 smart contract calls this function on the recipient
268    * after a `safetransfer`. This function MAY throw to revert and reject the
269    * transfer. Return of other than the magic value MUST result in the
270    * transaction being reverted.
271    * Note: the contract address is always the message sender.
272    * @param _operator The address which called `safeTransferFrom` function
273    * @param _from The address which previously owned the token
274    * @param _tokenId The NFT identifier which is being transferred
275    * @param _data Additional data with no specified format
276    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
277    */
278   function onERC721Received(
279     address _operator,
280     address _from,
281     uint256 _tokenId,
282     bytes _data
283   )
284     public
285     returns(bytes4);
286 }
287 
288 
289 
290 
291 
292 
293 
294 /**
295  * @title ERC721 Non-Fungible Token Standard basic implementation
296  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
297  */
298 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
299 
300   using SafeMath for uint256;
301   using AddressUtils for address;
302 
303   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
304   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
305   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
306 
307   // Mapping from token ID to owner
308   mapping (uint256 => address) internal tokenOwner;
309 
310   // Mapping from token ID to approved address
311   mapping (uint256 => address) internal tokenApprovals;
312 
313   // Mapping from owner to number of owned token
314   mapping (address => uint256) internal ownedTokensCount;
315 
316   // Mapping from owner to operator approvals
317   mapping (address => mapping (address => bool)) internal operatorApprovals;
318 
319   constructor()
320     public
321   {
322     // register the supported interfaces to conform to ERC721 via ERC165
323     _registerInterface(InterfaceId_ERC721);
324     _registerInterface(InterfaceId_ERC721Exists);
325   }
326 
327   /**
328    * @dev Gets the balance of the specified address
329    * @param _owner address to query the balance of
330    * @return uint256 representing the amount owned by the passed address
331    */
332   function balanceOf(address _owner) public view returns (uint256) {
333     require(_owner != address(0));
334     return ownedTokensCount[_owner];
335   }
336 
337   /**
338    * @dev Gets the owner of the specified token ID
339    * @param _tokenId uint256 ID of the token to query the owner of
340    * @return owner address currently marked as the owner of the given token ID
341    */
342   function ownerOf(uint256 _tokenId) public view returns (address) {
343     address owner = tokenOwner[_tokenId];
344     require(owner != address(0));
345     return owner;
346   }
347 
348   /**
349    * @dev Returns whether the specified token exists
350    * @param _tokenId uint256 ID of the token to query the existence of
351    * @return whether the token exists
352    */
353   function exists(uint256 _tokenId) public view returns (bool) {
354     address owner = tokenOwner[_tokenId];
355     return owner != address(0);
356   }
357 
358   /**
359    * @dev Approves another address to transfer the given token ID
360    * The zero address indicates there is no approved address.
361    * There can only be one approved address per token at a given time.
362    * Can only be called by the token owner or an approved operator.
363    * @param _to address to be approved for the given token ID
364    * @param _tokenId uint256 ID of the token to be approved
365    */
366   function approve(address _to, uint256 _tokenId) public {
367     address owner = ownerOf(_tokenId);
368     require(_to != owner);
369     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
370 
371     tokenApprovals[_tokenId] = _to;
372     emit Approval(owner, _to, _tokenId);
373   }
374 
375   /**
376    * @dev Gets the approved address for a token ID, or zero if no address set
377    * @param _tokenId uint256 ID of the token to query the approval of
378    * @return address currently approved for the given token ID
379    */
380   function getApproved(uint256 _tokenId) public view returns (address) {
381     return tokenApprovals[_tokenId];
382   }
383 
384   /**
385    * @dev Sets or unsets the approval of a given operator
386    * An operator is allowed to transfer all tokens of the sender on their behalf
387    * @param _to operator address to set the approval
388    * @param _approved representing the status of the approval to be set
389    */
390   function setApprovalForAll(address _to, bool _approved) public {
391     require(_to != msg.sender);
392     operatorApprovals[msg.sender][_to] = _approved;
393     emit ApprovalForAll(msg.sender, _to, _approved);
394   }
395 
396   /**
397    * @dev Tells whether an operator is approved by a given owner
398    * @param _owner owner address which you want to query the approval of
399    * @param _operator operator address which you want to query the approval of
400    * @return bool whether the given operator is approved by the given owner
401    */
402   function isApprovedForAll(
403     address _owner,
404     address _operator
405   )
406     public
407     view
408     returns (bool)
409   {
410     return operatorApprovals[_owner][_operator];
411   }
412 
413   /**
414    * @dev Transfers the ownership of a given token ID to another address
415    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
416    * Requires the msg sender to be the owner, approved, or operator
417    * @param _from current owner of the token
418    * @param _to address to receive the ownership of the given token ID
419    * @param _tokenId uint256 ID of the token to be transferred
420   */
421   function transferFrom(
422     address _from,
423     address _to,
424     uint256 _tokenId
425   )
426     public
427   {
428     require(isApprovedOrOwner(msg.sender, _tokenId));
429     require(_from != address(0));
430     require(_to != address(0));
431 
432     clearApproval(_from, _tokenId);
433     removeTokenFrom(_from, _tokenId);
434     addTokenTo(_to, _tokenId);
435 
436     emit Transfer(_from, _to, _tokenId);
437   }
438 
439   /**
440    * @dev Safely transfers the ownership of a given token ID to another address
441    * If the target address is a contract, it must implement `onERC721Received`,
442    * which is called upon a safe transfer, and return the magic value
443    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
444    * the transfer is reverted.
445    *
446    * Requires the msg sender to be the owner, approved, or operator
447    * @param _from current owner of the token
448    * @param _to address to receive the ownership of the given token ID
449    * @param _tokenId uint256 ID of the token to be transferred
450   */
451   function safeTransferFrom(
452     address _from,
453     address _to,
454     uint256 _tokenId
455   )
456     public
457   {
458     // solium-disable-next-line arg-overflow
459     safeTransferFrom(_from, _to, _tokenId, "");
460   }
461 
462   /**
463    * @dev Safely transfers the ownership of a given token ID to another address
464    * If the target address is a contract, it must implement `onERC721Received`,
465    * which is called upon a safe transfer, and return the magic value
466    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
467    * the transfer is reverted.
468    * Requires the msg sender to be the owner, approved, or operator
469    * @param _from current owner of the token
470    * @param _to address to receive the ownership of the given token ID
471    * @param _tokenId uint256 ID of the token to be transferred
472    * @param _data bytes data to send along with a safe transfer check
473    */
474   function safeTransferFrom(
475     address _from,
476     address _to,
477     uint256 _tokenId,
478     bytes _data
479   )
480     public
481   {
482     transferFrom(_from, _to, _tokenId);
483     // solium-disable-next-line arg-overflow
484     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
485   }
486 
487   /**
488    * @dev Returns whether the given spender can transfer a given token ID
489    * @param _spender address of the spender to query
490    * @param _tokenId uint256 ID of the token to be transferred
491    * @return bool whether the msg.sender is approved for the given token ID,
492    *  is an operator of the owner, or is the owner of the token
493    */
494   function isApprovedOrOwner(
495     address _spender,
496     uint256 _tokenId
497   )
498     internal
499     view
500     returns (bool)
501   {
502     address owner = ownerOf(_tokenId);
503     // Disable solium check because of
504     // https://github.com/duaraghav8/Solium/issues/175
505     // solium-disable-next-line operator-whitespace
506     return (
507       _spender == owner ||
508       getApproved(_tokenId) == _spender ||
509       isApprovedForAll(owner, _spender)
510     );
511   }
512 
513   /**
514    * @dev Internal function to mint a new token
515    * Reverts if the given token ID already exists
516    * @param _to The address that will own the minted token
517    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
518    */
519   function _mint(address _to, uint256 _tokenId) internal {
520     require(_to != address(0));
521     addTokenTo(_to, _tokenId);
522     emit Transfer(address(0), _to, _tokenId);
523   }
524 
525   /**
526    * @dev Internal function to burn a specific token
527    * Reverts if the token does not exist
528    * @param _tokenId uint256 ID of the token being burned by the msg.sender
529    */
530   function _burn(address _owner, uint256 _tokenId) internal {
531     clearApproval(_owner, _tokenId);
532     removeTokenFrom(_owner, _tokenId);
533     emit Transfer(_owner, address(0), _tokenId);
534   }
535 
536   /**
537    * @dev Internal function to clear current approval of a given token ID
538    * Reverts if the given address is not indeed the owner of the token
539    * @param _owner owner of the token
540    * @param _tokenId uint256 ID of the token to be transferred
541    */
542   function clearApproval(address _owner, uint256 _tokenId) internal {
543     require(ownerOf(_tokenId) == _owner);
544     if (tokenApprovals[_tokenId] != address(0)) {
545       tokenApprovals[_tokenId] = address(0);
546     }
547   }
548 
549   /**
550    * @dev Internal function to add a token ID to the list of a given address
551    * @param _to address representing the new owner of the given token ID
552    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
553    */
554   function addTokenTo(address _to, uint256 _tokenId) internal {
555     require(tokenOwner[_tokenId] == address(0));
556     tokenOwner[_tokenId] = _to;
557     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
558   }
559 
560   /**
561    * @dev Internal function to remove a token ID from the list of a given address
562    * @param _from address representing the previous owner of the given token ID
563    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
564    */
565   function removeTokenFrom(address _from, uint256 _tokenId) internal {
566     require(ownerOf(_tokenId) == _from);
567     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
568     tokenOwner[_tokenId] = address(0);
569   }
570 
571   /**
572    * @dev Internal function to invoke `onERC721Received` on a target address
573    * The call is not executed if the target address is not a contract
574    * @param _from address representing the previous owner of the given token ID
575    * @param _to target address that will receive the tokens
576    * @param _tokenId uint256 ID of the token to be transferred
577    * @param _data bytes optional data to send along with the call
578    * @return whether the call correctly returned the expected magic value
579    */
580   function checkAndCallSafeTransfer(
581     address _from,
582     address _to,
583     uint256 _tokenId,
584     bytes _data
585   )
586     internal
587     returns (bool)
588   {
589     if (!_to.isContract()) {
590       return true;
591     }
592     bytes4 retval = ERC721Receiver(_to).onERC721Received(
593       msg.sender, _from, _tokenId, _data);
594     return (retval == ERC721_RECEIVED);
595   }
596 }
597 
598 
599 
600 
601 
602 
603 
604 /**
605  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
606  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
607  */
608 contract ERC721Enumerable is ERC721Basic {
609   function totalSupply() public view returns (uint256);
610   function tokenOfOwnerByIndex(
611     address _owner,
612     uint256 _index
613   )
614     public
615     view
616     returns (uint256 _tokenId);
617 
618   function tokenByIndex(uint256 _index) public view returns (uint256);
619 }
620 
621 
622 /**
623  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
624  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
625  */
626 contract ERC721Metadata is ERC721Basic {
627   function name() external view returns (string _name);
628   function symbol() external view returns (string _symbol);
629   function tokenURI(uint256 _tokenId) public view returns (string);
630 }
631 
632 
633 /**
634  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
635  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
636  */
637 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
638 }
639 
640 
641 
642 
643 
644 
645 
646 
647 /**
648  * @title Full ERC721 Token
649  * This implementation includes all the required and some optional functionality of the ERC721 standard
650  * Moreover, it includes approve all functionality using operator terminology
651  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
652  */
653 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
654 
655   // Token name
656   string internal name_;
657 
658   // Token symbol
659   string internal symbol_;
660 
661   // Mapping from owner to list of owned token IDs
662   mapping(address => uint256[]) internal ownedTokens;
663 
664   // Mapping from token ID to index of the owner tokens list
665   mapping(uint256 => uint256) internal ownedTokensIndex;
666 
667   // Array with all token ids, used for enumeration
668   uint256[] internal allTokens;
669 
670   // Mapping from token id to position in the allTokens array
671   mapping(uint256 => uint256) internal allTokensIndex;
672 
673   // Optional mapping for token URIs
674   mapping(uint256 => string) internal tokenURIs;
675 
676   /**
677    * @dev Constructor function
678    */
679   constructor(string _name, string _symbol) public {
680     name_ = _name;
681     symbol_ = _symbol;
682 
683     // register the supported interfaces to conform to ERC721 via ERC165
684     _registerInterface(InterfaceId_ERC721Enumerable);
685     _registerInterface(InterfaceId_ERC721Metadata);
686   }
687 
688   /**
689    * @dev Gets the token name
690    * @return string representing the token name
691    */
692   function name() external view returns (string) {
693     return name_;
694   }
695 
696   /**
697    * @dev Gets the token symbol
698    * @return string representing the token symbol
699    */
700   function symbol() external view returns (string) {
701     return symbol_;
702   }
703 
704   /**
705    * @dev Returns an URI for a given token ID
706    * Throws if the token ID does not exist. May return an empty string.
707    * @param _tokenId uint256 ID of the token to query
708    */
709   function tokenURI(uint256 _tokenId) public view returns (string) {
710     require(exists(_tokenId));
711     return tokenURIs[_tokenId];
712   }
713 
714   /**
715    * @dev Gets the token ID at a given index of the tokens list of the requested owner
716    * @param _owner address owning the tokens list to be accessed
717    * @param _index uint256 representing the index to be accessed of the requested tokens list
718    * @return uint256 token ID at the given index of the tokens list owned by the requested address
719    */
720   function tokenOfOwnerByIndex(
721     address _owner,
722     uint256 _index
723   )
724     public
725     view
726     returns (uint256)
727   {
728     require(_index < balanceOf(_owner));
729     return ownedTokens[_owner][_index];
730   }
731 
732   /**
733    * @dev Gets the total amount of tokens stored by the contract
734    * @return uint256 representing the total amount of tokens
735    */
736   function totalSupply() public view returns (uint256) {
737     return allTokens.length;
738   }
739 
740   /**
741    * @dev Gets the token ID at a given index of all the tokens in this contract
742    * Reverts if the index is greater or equal to the total number of tokens
743    * @param _index uint256 representing the index to be accessed of the tokens list
744    * @return uint256 token ID at the given index of the tokens list
745    */
746   function tokenByIndex(uint256 _index) public view returns (uint256) {
747     require(_index < totalSupply());
748     return allTokens[_index];
749   }
750 
751   /**
752    * @dev Internal function to set the token URI for a given token
753    * Reverts if the token ID does not exist
754    * @param _tokenId uint256 ID of the token to set its URI
755    * @param _uri string URI to assign
756    */
757   function _setTokenURI(uint256 _tokenId, string _uri) internal {
758     require(exists(_tokenId));
759     tokenURIs[_tokenId] = _uri;
760   }
761 
762   /**
763    * @dev Internal function to add a token ID to the list of a given address
764    * @param _to address representing the new owner of the given token ID
765    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
766    */
767   function addTokenTo(address _to, uint256 _tokenId) internal {
768     super.addTokenTo(_to, _tokenId);
769     uint256 length = ownedTokens[_to].length;
770     ownedTokens[_to].push(_tokenId);
771     ownedTokensIndex[_tokenId] = length;
772   }
773 
774   /**
775    * @dev Internal function to remove a token ID from the list of a given address
776    * @param _from address representing the previous owner of the given token ID
777    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
778    */
779   function removeTokenFrom(address _from, uint256 _tokenId) internal {
780     super.removeTokenFrom(_from, _tokenId);
781 
782     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
783     // then delete the last slot.
784     uint256 tokenIndex = ownedTokensIndex[_tokenId];
785     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
786     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
787 
788     ownedTokens[_from][tokenIndex] = lastToken;
789     ownedTokens[_from].length--;
790     // ^ This also deletes the contents at the last position of the array
791 
792     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
793     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
794     // the lastToken to the first position, and then dropping the element placed in the last position of the list
795 
796     ownedTokensIndex[_tokenId] = 0;
797     ownedTokensIndex[lastToken] = tokenIndex;
798   }
799 
800   /**
801    * @dev Internal function to mint a new token
802    * Reverts if the given token ID already exists
803    * @param _to address the beneficiary that will own the minted token
804    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
805    */
806   function _mint(address _to, uint256 _tokenId) internal {
807     super._mint(_to, _tokenId);
808 
809     allTokensIndex[_tokenId] = allTokens.length;
810     allTokens.push(_tokenId);
811   }
812 
813   /**
814    * @dev Internal function to burn a specific token
815    * Reverts if the token does not exist
816    * @param _owner owner of the token to burn
817    * @param _tokenId uint256 ID of the token being burned by the msg.sender
818    */
819   function _burn(address _owner, uint256 _tokenId) internal {
820     super._burn(_owner, _tokenId);
821 
822     // Clear metadata (if any)
823     if (bytes(tokenURIs[_tokenId]).length != 0) {
824       delete tokenURIs[_tokenId];
825     }
826 
827     // Reorg all tokens array
828     uint256 tokenIndex = allTokensIndex[_tokenId];
829     uint256 lastTokenIndex = allTokens.length.sub(1);
830     uint256 lastToken = allTokens[lastTokenIndex];
831 
832     allTokens[tokenIndex] = lastToken;
833     allTokens[lastTokenIndex] = 0;
834 
835     allTokens.length--;
836     allTokensIndex[_tokenId] = 0;
837     allTokensIndex[lastToken] = tokenIndex;
838   }
839 
840 }
841 
842 
843 
844 
845 
846 
847 /**
848  * @title Ownable
849  * @dev The Ownable contract has an owner address, and provides basic authorization control
850  * functions, this simplifies the implementation of "user permissions".
851  */
852 contract Ownable {
853   address public owner;
854 
855 
856   event OwnershipRenounced(address indexed previousOwner);
857   event OwnershipTransferred(
858     address indexed previousOwner,
859     address indexed newOwner
860   );
861 
862 
863   /**
864    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
865    * account.
866    */
867   constructor() public {
868     owner = msg.sender;
869   }
870 
871   /**
872    * @dev Throws if called by any account other than the owner.
873    */
874   modifier onlyOwner() {
875     require(msg.sender == owner);
876     _;
877   }
878 
879   /**
880    * @dev Allows the current owner to relinquish control of the contract.
881    * @notice Renouncing to ownership will leave the contract without an owner.
882    * It will not be possible to call the functions with the `onlyOwner`
883    * modifier anymore.
884    */
885   function renounceOwnership() public onlyOwner {
886     emit OwnershipRenounced(owner);
887     owner = address(0);
888   }
889 
890   /**
891    * @dev Allows the current owner to transfer control of the contract to a newOwner.
892    * @param _newOwner The address to transfer ownership to.
893    */
894   function transferOwnership(address _newOwner) public onlyOwner {
895     _transferOwnership(_newOwner);
896   }
897 
898   /**
899    * @dev Transfers control of the contract to a newOwner.
900    * @param _newOwner The address to transfer ownership to.
901    */
902   function _transferOwnership(address _newOwner) internal {
903     require(_newOwner != address(0));
904     emit OwnershipTransferred(owner, _newOwner);
905     owner = _newOwner;
906   }
907 }
908 
909 
910 
911 
912 contract CKInterface {
913   function totalSupply() public view returns (uint256 total);
914   function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
915   function balanceOf(address _owner) public view returns (uint256 balance);
916   function ownerOf(uint256 _tokenId) external view returns (address owner);
917   function transferFrom(address _from, address _to, uint256 _tokenId) external;
918   function approve(address _to, uint256 _tokenId) external;
919 
920   function createPromoKitty(uint256 _genes, address _owner) external;
921 }
922 
923 
924 
925 
926 /// @title E.T.H. (Extreme Time Heroes) Access Contract for beta and main sale
927 /// @author Nathan Ginnever
928 
929 contract ETHAccess is Ownable, ERC721Token {
930 
931   uint256 public betaQRTLimit = 10000; // 10 for testing, 10000 mainnet
932   uint256 public totalPortalKitties = 0;
933   uint256 public QRTprice = 200 finney;
934 
935   CKInterface public ck;
936 
937   struct Participant {
938     address party;
939     uint256 numPortalKitties;
940   }
941 
942   // we can use this mapping to allow kitty depositers to claim an E.T.H. fighter NFT in the future
943   mapping(address => Participant) public participants;
944 
945   event QRTPurchase(
946     address indexed _from,
947     uint256 indexed _time,
948     uint256 indexed _tokenId
949   );
950 
951   event KittiesPortal(
952     address indexed _from,
953     uint256 indexed _time
954   );
955 
956   constructor(
957     address _ckAddress,
958     address _secureWallet,
959     string name, 
960     string symbol) 
961     public 
962     ERC721Token(name, symbol)
963   {
964     owner = _secureWallet;
965     ck = CKInterface(_ckAddress);
966     super._mint(_secureWallet, 0);
967   }
968 
969   function purchaseQRT() public payable {
970     require(msg.value == QRTprice);
971     require(totalSupply() < betaQRTLimit);
972 
973     uint256 _tokenID = totalSupply().add(1);
974 
975     participants[msg.sender].party = msg.sender;
976 
977     super._mint(msg.sender, _tokenID);
978     emit QRTPurchase(msg.sender, now, _tokenID);
979   }
980 
981   function portalKitty(uint256 id) public {
982     require(ck.ownerOf(id) == msg.sender);
983 
984     // this assumes client calls an approval for each cryptokitty id
985     ck.transferFrom(msg.sender, address(this), id);
986 
987     participants[msg.sender].numPortalKitties = participants[msg.sender].numPortalKitties.add(1);
988     totalPortalKitties = totalPortalKitties.add(1);
989     emit KittiesPortal(msg.sender, now);
990   }
991 
992   function withdraw() onlyOwner public {
993     owner.transfer(address(this).balance);
994   }
995 }