1 pragma solidity ^0.4.24;
2 
3 /*
4   ERC-721 NIFTY remote hackathon for:
5   https://github.com/austintgriffith/nifties-vs-nfties
6 
7   Austin Thomas Griffith - https://austingriffith.com
8 
9   This Token is for the Nifties (yes eye in Nifties) monsters
10 
11   They have the following metadata:
12   struct Token{
13     uint8 body;
14     uint8 feet;
15     uint8 head;
16     uint8 mouth;
17     uint64 birthBlock;
18   }
19 */
20 
21 
22 
23 /**
24  * @title ERC165
25  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
26  */
27 interface ERC165 {
28 
29   /**
30    * @notice Query if a contract implements an interface
31    * @param _interfaceId The interface identifier, as specified in ERC-165
32    * @dev Interface identification is specified in ERC-165. This function
33    * uses less than 30,000 gas.
34    */
35   function supportsInterface(bytes4 _interfaceId)
36     external
37     view
38     returns (bool);
39 }
40 
41 
42 
43 
44 /**
45  * @title SupportsInterfaceWithLookup
46  * @author Matt Condon (@shrugs)
47  * @dev Implements ERC165 using a lookup table.
48  */
49 contract SupportsInterfaceWithLookup is ERC165 {
50   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
51   /**
52    * 0x01ffc9a7 ===
53    *   bytes4(keccak256('supportsInterface(bytes4)'))
54    */
55 
56   /**
57    * @dev a mapping of interface id to whether or not it's supported
58    */
59   mapping(bytes4 => bool) internal supportedInterfaces;
60 
61   /**
62    * @dev A contract implementing SupportsInterfaceWithLookup
63    * implement ERC165 itself
64    */
65   constructor()
66     public
67   {
68     _registerInterface(InterfaceId_ERC165);
69   }
70 
71   /**
72    * @dev implement supportsInterface(bytes4) using a lookup table
73    */
74   function supportsInterface(bytes4 _interfaceId)
75     external
76     view
77     returns (bool)
78   {
79     return supportedInterfaces[_interfaceId];
80   }
81 
82   /**
83    * @dev private method for registering an interface
84    */
85   function _registerInterface(bytes4 _interfaceId)
86     internal
87   {
88     require(_interfaceId != 0xffffffff);
89     supportedInterfaces[_interfaceId] = true;
90   }
91 }
92 
93 
94 /**
95  * @title ERC721 Non-Fungible Token Standard basic interface
96  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
97  */
98 contract ERC721Basic is ERC165 {
99 
100   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
101   /*
102    * 0x80ac58cd ===
103    *   bytes4(keccak256('balanceOf(address)')) ^
104    *   bytes4(keccak256('ownerOf(uint256)')) ^
105    *   bytes4(keccak256('approve(address,uint256)')) ^
106    *   bytes4(keccak256('getApproved(uint256)')) ^
107    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
108    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
109    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
110    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
111    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
112    */
113 
114   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
115   /*
116    * 0x4f558e79 ===
117    *   bytes4(keccak256('exists(uint256)'))
118    */
119 
120   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
121   /**
122    * 0x780e9d63 ===
123    *   bytes4(keccak256('totalSupply()')) ^
124    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
125    *   bytes4(keccak256('tokenByIndex(uint256)'))
126    */
127 
128   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
129   /**
130    * 0x5b5e139f ===
131    *   bytes4(keccak256('name()')) ^
132    *   bytes4(keccak256('symbol()')) ^
133    *   bytes4(keccak256('tokenURI(uint256)'))
134    */
135 
136   event Transfer(
137     address indexed _from,
138     address indexed _to,
139     uint256 indexed _tokenId
140   );
141   event Approval(
142     address indexed _owner,
143     address indexed _approved,
144     uint256 indexed _tokenId
145   );
146   event ApprovalForAll(
147     address indexed _owner,
148     address indexed _operator,
149     bool _approved
150   );
151 
152   function balanceOf(address _owner) public view returns (uint256 _balance);
153   function ownerOf(uint256 _tokenId) public view returns (address _owner);
154   function exists(uint256 _tokenId) public view returns (bool _exists);
155 
156   function approve(address _to, uint256 _tokenId) public;
157   function getApproved(uint256 _tokenId)
158     public view returns (address _operator);
159 
160   function setApprovalForAll(address _operator, bool _approved) public;
161   function isApprovedForAll(address _owner, address _operator)
162     public view returns (bool);
163 
164   function transferFrom(address _from, address _to, uint256 _tokenId) public;
165   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
166     public;
167 
168   function safeTransferFrom(
169     address _from,
170     address _to,
171     uint256 _tokenId,
172     bytes _data
173   )
174     public;
175 }
176 
177 
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
181  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
182  */
183 contract ERC721Enumerable is ERC721Basic {
184   function totalSupply() public view returns (uint256);
185   function tokenOfOwnerByIndex(
186     address _owner,
187     uint256 _index
188   )
189     public
190     view
191     returns (uint256 _tokenId);
192 
193   function tokenByIndex(uint256 _index) public view returns (uint256);
194 }
195 
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
199  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
200  */
201 contract ERC721Metadata is ERC721Basic {
202   function name() external view returns (string _name);
203   function symbol() external view returns (string _symbol);
204   function tokenURI(uint256 _tokenId) public view returns (string);
205 }
206 
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
210  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
211  */
212 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
213 }
214 
215 
216 
217 
218 /**
219  * @title ERC721 token receiver interface
220  * @dev Interface for any contract that wants to support safeTransfers
221  * from ERC721 asset contracts.
222  */
223 contract ERC721Receiver {
224   /**
225    * @dev Magic value to be returned upon successful reception of an NFT
226    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
227    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
228    */
229   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
230 
231   /**
232    * @notice Handle the receipt of an NFT
233    * @dev The ERC721 smart contract calls this function on the recipient
234    * after a `safetransfer`. This function MAY throw to revert and reject the
235    * transfer. Return of other than the magic value MUST result in the
236    * transaction being reverted.
237    * Note: the contract address is always the message sender.
238    * @param _operator The address which called `safeTransferFrom` function
239    * @param _from The address which previously owned the token
240    * @param _tokenId The NFT identifier which is being transferred
241    * @param _data Additional data with no specified format
242    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
243    */
244   function onERC721Received(
245     address _operator,
246     address _from,
247     uint256 _tokenId,
248     bytes _data
249   )
250     public
251     returns(bytes4);
252 }
253 
254 
255 
256 /**
257  * @title SafeMath
258  * @dev Math operations with safety checks that throw on error
259  */
260 library SafeMath {
261 
262   /**
263   * @dev Multiplies two numbers, throws on overflow.
264   */
265   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
266     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
267     // benefit is lost if 'b' is also tested.
268     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
269     if (a == 0) {
270       return 0;
271     }
272 
273     c = a * b;
274     assert(c / a == b);
275     return c;
276   }
277 
278   /**
279   * @dev Integer division of two numbers, truncating the quotient.
280   */
281   function div(uint256 a, uint256 b) internal pure returns (uint256) {
282     // assert(b > 0); // Solidity automatically throws when dividing by 0
283     // uint256 c = a / b;
284     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
285     return a / b;
286   }
287 
288   /**
289   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
290   */
291   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
292     assert(b <= a);
293     return a - b;
294   }
295 
296   /**
297   * @dev Adds two numbers, throws on overflow.
298   */
299   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
300     c = a + b;
301     assert(c >= a);
302     return c;
303   }
304 }
305 
306 
307 
308 /**
309  * Utility library of inline functions on addresses
310  */
311 library AddressUtils {
312 
313   /**
314    * Returns whether the target address is a contract
315    * @dev This function will return false if invoked during the constructor of a contract,
316    * as the code is not actually created until after the constructor finishes.
317    * @param addr address to check
318    * @return whether the target address is a contract
319    */
320   function isContract(address addr) internal view returns (bool) {
321     uint256 size;
322     // XXX Currently there is no better way to check if there is a contract in an address
323     // than to check the size of the code at that address.
324     // See https://ethereum.stackexchange.com/a/14016/36603
325     // for more details about how this works.
326     // TODO Check this again before the Serenity release, because all addresses will be
327     // contracts then.
328     // solium-disable-next-line security/no-inline-assembly
329     assembly { size := extcodesize(addr) }
330     return size > 0;
331   }
332 
333 }
334 
335 
336 
337 /**
338  * @title ERC721 Non-Fungible Token Standard basic implementation
339  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
340  */
341 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
342 
343   using SafeMath for uint256;
344   using AddressUtils for address;
345 
346   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
347   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
348   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
349 
350   // Mapping from token ID to owner
351   mapping (uint256 => address) internal tokenOwner;
352 
353   // Mapping from token ID to approved address
354   mapping (uint256 => address) internal tokenApprovals;
355 
356   // Mapping from owner to number of owned token
357   mapping (address => uint256) internal ownedTokensCount;
358 
359   // Mapping from owner to operator approvals
360   mapping (address => mapping (address => bool)) internal operatorApprovals;
361 
362   constructor()
363     public
364   {
365     // register the supported interfaces to conform to ERC721 via ERC165
366     _registerInterface(InterfaceId_ERC721);
367     _registerInterface(InterfaceId_ERC721Exists);
368   }
369 
370   /**
371    * @dev Gets the balance of the specified address
372    * @param _owner address to query the balance of
373    * @return uint256 representing the amount owned by the passed address
374    */
375   function balanceOf(address _owner) public view returns (uint256) {
376     require(_owner != address(0));
377     return ownedTokensCount[_owner];
378   }
379 
380   /**
381    * @dev Gets the owner of the specified token ID
382    * @param _tokenId uint256 ID of the token to query the owner of
383    * @return owner address currently marked as the owner of the given token ID
384    */
385   function ownerOf(uint256 _tokenId) public view returns (address) {
386     address owner = tokenOwner[_tokenId];
387     require(owner != address(0));
388     return owner;
389   }
390 
391   /**
392    * @dev Returns whether the specified token exists
393    * @param _tokenId uint256 ID of the token to query the existence of
394    * @return whether the token exists
395    */
396   function exists(uint256 _tokenId) public view returns (bool) {
397     address owner = tokenOwner[_tokenId];
398     return owner != address(0);
399   }
400 
401   /**
402    * @dev Approves another address to transfer the given token ID
403    * The zero address indicates there is no approved address.
404    * There can only be one approved address per token at a given time.
405    * Can only be called by the token owner or an approved operator.
406    * @param _to address to be approved for the given token ID
407    * @param _tokenId uint256 ID of the token to be approved
408    */
409   function approve(address _to, uint256 _tokenId) public {
410     address owner = ownerOf(_tokenId);
411     require(_to != owner);
412     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
413 
414     tokenApprovals[_tokenId] = _to;
415     emit Approval(owner, _to, _tokenId);
416   }
417 
418   /**
419    * @dev Gets the approved address for a token ID, or zero if no address set
420    * @param _tokenId uint256 ID of the token to query the approval of
421    * @return address currently approved for the given token ID
422    */
423   function getApproved(uint256 _tokenId) public view returns (address) {
424     return tokenApprovals[_tokenId];
425   }
426 
427   /**
428    * @dev Sets or unsets the approval of a given operator
429    * An operator is allowed to transfer all tokens of the sender on their behalf
430    * @param _to operator address to set the approval
431    * @param _approved representing the status of the approval to be set
432    */
433   function setApprovalForAll(address _to, bool _approved) public {
434     require(_to != msg.sender);
435     operatorApprovals[msg.sender][_to] = _approved;
436     emit ApprovalForAll(msg.sender, _to, _approved);
437   }
438 
439   /**
440    * @dev Tells whether an operator is approved by a given owner
441    * @param _owner owner address which you want to query the approval of
442    * @param _operator operator address which you want to query the approval of
443    * @return bool whether the given operator is approved by the given owner
444    */
445   function isApprovedForAll(
446     address _owner,
447     address _operator
448   )
449     public
450     view
451     returns (bool)
452   {
453     return operatorApprovals[_owner][_operator];
454   }
455 
456   /**
457    * @dev Transfers the ownership of a given token ID to another address
458    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
459    * Requires the msg sender to be the owner, approved, or operator
460    * @param _from current owner of the token
461    * @param _to address to receive the ownership of the given token ID
462    * @param _tokenId uint256 ID of the token to be transferred
463   */
464   function transferFrom(
465     address _from,
466     address _to,
467     uint256 _tokenId
468   )
469     public
470   {
471     require(isApprovedOrOwner(msg.sender, _tokenId));
472     require(_from != address(0));
473     require(_to != address(0));
474 
475     clearApproval(_from, _tokenId);
476     removeTokenFrom(_from, _tokenId);
477     addTokenTo(_to, _tokenId);
478 
479     emit Transfer(_from, _to, _tokenId);
480   }
481 
482   /**
483    * @dev Safely transfers the ownership of a given token ID to another address
484    * If the target address is a contract, it must implement `onERC721Received`,
485    * which is called upon a safe transfer, and return the magic value
486    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
487    * the transfer is reverted.
488    *
489    * Requires the msg sender to be the owner, approved, or operator
490    * @param _from current owner of the token
491    * @param _to address to receive the ownership of the given token ID
492    * @param _tokenId uint256 ID of the token to be transferred
493   */
494   function safeTransferFrom(
495     address _from,
496     address _to,
497     uint256 _tokenId
498   )
499     public
500   {
501     // solium-disable-next-line arg-overflow
502     safeTransferFrom(_from, _to, _tokenId, "");
503   }
504 
505   /**
506    * @dev Safely transfers the ownership of a given token ID to another address
507    * If the target address is a contract, it must implement `onERC721Received`,
508    * which is called upon a safe transfer, and return the magic value
509    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
510    * the transfer is reverted.
511    * Requires the msg sender to be the owner, approved, or operator
512    * @param _from current owner of the token
513    * @param _to address to receive the ownership of the given token ID
514    * @param _tokenId uint256 ID of the token to be transferred
515    * @param _data bytes data to send along with a safe transfer check
516    */
517   function safeTransferFrom(
518     address _from,
519     address _to,
520     uint256 _tokenId,
521     bytes _data
522   )
523     public
524   {
525     transferFrom(_from, _to, _tokenId);
526     // solium-disable-next-line arg-overflow
527     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
528   }
529 
530   /**
531    * @dev Returns whether the given spender can transfer a given token ID
532    * @param _spender address of the spender to query
533    * @param _tokenId uint256 ID of the token to be transferred
534    * @return bool whether the msg.sender is approved for the given token ID,
535    *  is an operator of the owner, or is the owner of the token
536    */
537   function isApprovedOrOwner(
538     address _spender,
539     uint256 _tokenId
540   )
541     internal
542     view
543     returns (bool)
544   {
545     address owner = ownerOf(_tokenId);
546     // Disable solium check because of
547     // https://github.com/duaraghav8/Solium/issues/175
548     // solium-disable-next-line operator-whitespace
549     return (
550       _spender == owner ||
551       getApproved(_tokenId) == _spender ||
552       isApprovedForAll(owner, _spender)
553     );
554   }
555 
556   /**
557    * @dev Internal function to mint a new token
558    * Reverts if the given token ID already exists
559    * @param _to The address that will own the minted token
560    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
561    */
562   function _mint(address _to, uint256 _tokenId) internal {
563     require(_to != address(0));
564     addTokenTo(_to, _tokenId);
565     emit Transfer(address(0), _to, _tokenId);
566   }
567 
568   /**
569    * @dev Internal function to burn a specific token
570    * Reverts if the token does not exist
571    * @param _tokenId uint256 ID of the token being burned by the msg.sender
572    */
573   function _burn(address _owner, uint256 _tokenId) internal {
574     clearApproval(_owner, _tokenId);
575     removeTokenFrom(_owner, _tokenId);
576     emit Transfer(_owner, address(0), _tokenId);
577   }
578 
579   /**
580    * @dev Internal function to clear current approval of a given token ID
581    * Reverts if the given address is not indeed the owner of the token
582    * @param _owner owner of the token
583    * @param _tokenId uint256 ID of the token to be transferred
584    */
585   function clearApproval(address _owner, uint256 _tokenId) internal {
586     require(ownerOf(_tokenId) == _owner);
587     if (tokenApprovals[_tokenId] != address(0)) {
588       tokenApprovals[_tokenId] = address(0);
589     }
590   }
591 
592   /**
593    * @dev Internal function to add a token ID to the list of a given address
594    * @param _to address representing the new owner of the given token ID
595    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
596    */
597   function addTokenTo(address _to, uint256 _tokenId) internal {
598     require(tokenOwner[_tokenId] == address(0));
599     tokenOwner[_tokenId] = _to;
600     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
601   }
602 
603   /**
604    * @dev Internal function to remove a token ID from the list of a given address
605    * @param _from address representing the previous owner of the given token ID
606    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
607    */
608   function removeTokenFrom(address _from, uint256 _tokenId) internal {
609     require(ownerOf(_tokenId) == _from);
610     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
611     tokenOwner[_tokenId] = address(0);
612   }
613 
614   /**
615    * @dev Internal function to invoke `onERC721Received` on a target address
616    * The call is not executed if the target address is not a contract
617    * @param _from address representing the previous owner of the given token ID
618    * @param _to target address that will receive the tokens
619    * @param _tokenId uint256 ID of the token to be transferred
620    * @param _data bytes optional data to send along with the call
621    * @return whether the call correctly returned the expected magic value
622    */
623   function checkAndCallSafeTransfer(
624     address _from,
625     address _to,
626     uint256 _tokenId,
627     bytes _data
628   )
629     internal
630     returns (bool)
631   {
632     if (!_to.isContract()) {
633       return true;
634     }
635     bytes4 retval = ERC721Receiver(_to).onERC721Received(
636       msg.sender, _from, _tokenId, _data);
637     return (retval == ERC721_RECEIVED);
638   }
639 }
640 
641 
642 
643 
644 
645 
646 
647 
648 /**
649  * @title Full ERC721 Token
650  * This implementation includes all the required and some optional functionality of the ERC721 standard
651  * Moreover, it includes approve all functionality using operator terminology
652  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
653  */
654 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
655 
656   // Token name
657   string internal name_;
658 
659   // Token symbol
660   string internal symbol_;
661 
662   // Mapping from owner to list of owned token IDs
663   mapping(address => uint256[]) internal ownedTokens;
664 
665   // Mapping from token ID to index of the owner tokens list
666   mapping(uint256 => uint256) internal ownedTokensIndex;
667 
668   // Array with all token ids, used for enumeration
669   uint256[] internal allTokens;
670 
671   // Mapping from token id to position in the allTokens array
672   mapping(uint256 => uint256) internal allTokensIndex;
673 
674   // Optional mapping for token URIs
675   mapping(uint256 => string) internal tokenURIs;
676 
677   /**
678    * @dev Constructor function
679    */
680   constructor(string _name, string _symbol) public {
681     name_ = _name;
682     symbol_ = _symbol;
683 
684     // register the supported interfaces to conform to ERC721 via ERC165
685     _registerInterface(InterfaceId_ERC721Enumerable);
686     _registerInterface(InterfaceId_ERC721Metadata);
687   }
688 
689   /**
690    * @dev Gets the token name
691    * @return string representing the token name
692    */
693   function name() external view returns (string) {
694     return name_;
695   }
696 
697   /**
698    * @dev Gets the token symbol
699    * @return string representing the token symbol
700    */
701   function symbol() external view returns (string) {
702     return symbol_;
703   }
704 
705   /**
706    * @dev Returns an URI for a given token ID
707    * Throws if the token ID does not exist. May return an empty string.
708    * @param _tokenId uint256 ID of the token to query
709    */
710   function tokenURI(uint256 _tokenId) public view returns (string) {
711     require(exists(_tokenId));
712     return tokenURIs[_tokenId];
713   }
714 
715   /**
716    * @dev Gets the token ID at a given index of the tokens list of the requested owner
717    * @param _owner address owning the tokens list to be accessed
718    * @param _index uint256 representing the index to be accessed of the requested tokens list
719    * @return uint256 token ID at the given index of the tokens list owned by the requested address
720    */
721   function tokenOfOwnerByIndex(
722     address _owner,
723     uint256 _index
724   )
725     public
726     view
727     returns (uint256)
728   {
729     require(_index < balanceOf(_owner));
730     return ownedTokens[_owner][_index];
731   }
732 
733   /**
734    * @dev Gets the total amount of tokens stored by the contract
735    * @return uint256 representing the total amount of tokens
736    */
737   function totalSupply() public view returns (uint256) {
738     return allTokens.length;
739   }
740 
741   /**
742    * @dev Gets the token ID at a given index of all the tokens in this contract
743    * Reverts if the index is greater or equal to the total number of tokens
744    * @param _index uint256 representing the index to be accessed of the tokens list
745    * @return uint256 token ID at the given index of the tokens list
746    */
747   function tokenByIndex(uint256 _index) public view returns (uint256) {
748     require(_index < totalSupply());
749     return allTokens[_index];
750   }
751 
752   /**
753    * @dev Internal function to set the token URI for a given token
754    * Reverts if the token ID does not exist
755    * @param _tokenId uint256 ID of the token to set its URI
756    * @param _uri string URI to assign
757    */
758   function _setTokenURI(uint256 _tokenId, string _uri) internal {
759     require(exists(_tokenId));
760     tokenURIs[_tokenId] = _uri;
761   }
762 
763   /**
764    * @dev Internal function to add a token ID to the list of a given address
765    * @param _to address representing the new owner of the given token ID
766    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
767    */
768   function addTokenTo(address _to, uint256 _tokenId) internal {
769     super.addTokenTo(_to, _tokenId);
770     uint256 length = ownedTokens[_to].length;
771     ownedTokens[_to].push(_tokenId);
772     ownedTokensIndex[_tokenId] = length;
773   }
774 
775   /**
776    * @dev Internal function to remove a token ID from the list of a given address
777    * @param _from address representing the previous owner of the given token ID
778    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
779    */
780   function removeTokenFrom(address _from, uint256 _tokenId) internal {
781     super.removeTokenFrom(_from, _tokenId);
782 
783     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
784     // then delete the last slot.
785     uint256 tokenIndex = ownedTokensIndex[_tokenId];
786     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
787     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
788 
789     ownedTokens[_from][tokenIndex] = lastToken;
790     ownedTokens[_from].length--; // This also deletes the contents at the last position of the array
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
843 contract Nifties is ERC721Token {
844 
845   constructor() public ERC721Token("Nifties","NIFTIES") { }
846 
847   struct Token{
848     uint8 body;
849     uint8 feet;
850     uint8 head;
851     uint8 mouth;
852     uint64 birthBlock;
853   }
854 
855   Token[] private tokens;
856 
857   //Anyone can pay the gas to create their very own Tester token
858   function create() public returns (uint256 _tokenId) {
859 
860     bytes32 sudoRandomButTotallyPredictable = keccak256(abi.encodePacked(totalSupply(),blockhash(block.number - 1)));
861     uint8 body = (uint8(sudoRandomButTotallyPredictable[0])%5)+1;
862     uint8 feet = (uint8(sudoRandomButTotallyPredictable[1])%7)+1;
863     uint8 head = (uint8(sudoRandomButTotallyPredictable[2])%7)+1;
864     uint8 mouth = (uint8(sudoRandomButTotallyPredictable[3])%8)+1;
865 
866     //this is about half of all the gas it takes because I'm doing some string manipulation
867     //I could skip this, or make it way more efficient but the is just a silly hackathon project
868     string memory tokenUri = createTokenUri(body,feet,head,mouth);
869 
870     Token memory _newToken = Token({
871         body: body,
872         feet: feet,
873         head: head,
874         mouth: mouth,
875         birthBlock: uint64(block.number)
876     });
877     _tokenId = tokens.push(_newToken) - 1;
878     _mint(msg.sender,_tokenId);
879     _setTokenURI(_tokenId, tokenUri);
880     emit Create(_tokenId,msg.sender,body,feet,head,mouth,_newToken.birthBlock,tokenUri);
881     return _tokenId;
882   }
883 
884   event Create(
885     uint _id,
886     address indexed _owner,
887     uint8 _body,
888     uint8 _feet,
889     uint8 _head,
890     uint8 _mouth,
891     uint64 _birthBlock,
892     string _uri
893   );
894 
895   //Get any token metadata by passing in the ID
896   function get(uint256 _id) public view returns (address owner,uint8 body,uint8 feet,uint8 head,uint8 mouth,uint64 birthBlock) {
897     return (
898       tokenOwner[_id],
899       tokens[_id].body,
900       tokens[_id].feet,
901       tokens[_id].head,
902       tokens[_id].mouth,
903       tokens[_id].birthBlock
904     );
905   }
906 
907   function tokensOfOwner(address _owner) public view returns(uint256[]) {
908     return ownedTokens[_owner];
909   }
910 
911   function createTokenUri(uint8 body,uint8 feet,uint8 head,uint8 mouth) internal returns (string){
912     string memory uri = "https://nifties.io/tokens/nifties-";
913     uri = appendUint8ToString(uri,body);
914     uri = strConcat(uri,"-");
915     uri = appendUint8ToString(uri,feet);
916     uri = strConcat(uri,"-");
917     uri = appendUint8ToString(uri,head);
918     uri = strConcat(uri,"-");
919     uri = appendUint8ToString(uri,mouth);
920     uri = strConcat(uri,".png");
921     return uri;
922   }
923 
924   function appendUint8ToString(string inStr, uint8 v) internal constant returns (string str) {
925         uint maxlength = 100;
926         bytes memory reversed = new bytes(maxlength);
927         uint i = 0;
928         while (v != 0) {
929             uint remainder = v % 10;
930             v = v / 10;
931             reversed[i++] = byte(48 + remainder);
932         }
933         bytes memory inStrb = bytes(inStr);
934         bytes memory s = new bytes(inStrb.length + i);
935         uint j;
936         for (j = 0; j < inStrb.length; j++) {
937             s[j] = inStrb[j];
938         }
939         for (j = 0; j < i; j++) {
940             s[j + inStrb.length] = reversed[i - 1 - j];
941         }
942         str = string(s);
943     }
944 
945     function strConcat(string _a, string _b) internal pure returns (string) {
946         bytes memory _ba = bytes(_a);
947         bytes memory _bb = bytes(_b);
948         string memory ab = new string(_ba.length + _bb.length);
949         bytes memory bab = bytes(ab);
950         uint k = 0;
951         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
952         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
953         return string(bab);
954     }
955 
956 }