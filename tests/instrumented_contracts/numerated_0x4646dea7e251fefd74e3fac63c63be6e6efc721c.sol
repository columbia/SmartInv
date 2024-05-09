1 pragma solidity ^0.4.24;
2 
3 /*
4   ERC-721 NIFTY remote hackathon for:
5   https://github.com/austintgriffith/nifties-vs-nfties
6 
7   Austin Thomas Griffith - https://austingriffith.com
8 
9   This Token is for the Nfties (no eye in Nfties) monsters
10 
11   They have the following metadata:
12   struct Token{
13     uint8 body;
14     uint8 feet;
15     uint8 head;
16     uint8 mouth;
17     uint8 extra;
18     uint64 birthBlock;
19   }
20 */
21 
22 
23 
24 
25 
26 
27 /**
28  * @title ERC165
29  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
30  */
31 interface ERC165 {
32 
33   /**
34    * @notice Query if a contract implements an interface
35    * @param _interfaceId The interface identifier, as specified in ERC-165
36    * @dev Interface identification is specified in ERC-165. This function
37    * uses less than 30,000 gas.
38    */
39   function supportsInterface(bytes4 _interfaceId)
40     external
41     view
42     returns (bool);
43 }
44 
45 
46 
47 
48 /**
49  * @title SupportsInterfaceWithLookup
50  * @author Matt Condon (@shrugs)
51  * @dev Implements ERC165 using a lookup table.
52  */
53 contract SupportsInterfaceWithLookup is ERC165 {
54   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
55   /**
56    * 0x01ffc9a7 ===
57    *   bytes4(keccak256('supportsInterface(bytes4)'))
58    */
59 
60   /**
61    * @dev a mapping of interface id to whether or not it's supported
62    */
63   mapping(bytes4 => bool) internal supportedInterfaces;
64 
65   /**
66    * @dev A contract implementing SupportsInterfaceWithLookup
67    * implement ERC165 itself
68    */
69   constructor()
70     public
71   {
72     _registerInterface(InterfaceId_ERC165);
73   }
74 
75   /**
76    * @dev implement supportsInterface(bytes4) using a lookup table
77    */
78   function supportsInterface(bytes4 _interfaceId)
79     external
80     view
81     returns (bool)
82   {
83     return supportedInterfaces[_interfaceId];
84   }
85 
86   /**
87    * @dev private method for registering an interface
88    */
89   function _registerInterface(bytes4 _interfaceId)
90     internal
91   {
92     require(_interfaceId != 0xffffffff);
93     supportedInterfaces[_interfaceId] = true;
94   }
95 }
96 
97 
98 /**
99  * @title ERC721 Non-Fungible Token Standard basic interface
100  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
101  */
102 contract ERC721Basic is ERC165 {
103 
104   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
105   /*
106    * 0x80ac58cd ===
107    *   bytes4(keccak256('balanceOf(address)')) ^
108    *   bytes4(keccak256('ownerOf(uint256)')) ^
109    *   bytes4(keccak256('approve(address,uint256)')) ^
110    *   bytes4(keccak256('getApproved(uint256)')) ^
111    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
112    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
113    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
114    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
115    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
116    */
117 
118   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
119   /*
120    * 0x4f558e79 ===
121    *   bytes4(keccak256('exists(uint256)'))
122    */
123 
124   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
125   /**
126    * 0x780e9d63 ===
127    *   bytes4(keccak256('totalSupply()')) ^
128    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
129    *   bytes4(keccak256('tokenByIndex(uint256)'))
130    */
131 
132   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
133   /**
134    * 0x5b5e139f ===
135    *   bytes4(keccak256('name()')) ^
136    *   bytes4(keccak256('symbol()')) ^
137    *   bytes4(keccak256('tokenURI(uint256)'))
138    */
139 
140   event Transfer(
141     address indexed _from,
142     address indexed _to,
143     uint256 indexed _tokenId
144   );
145   event Approval(
146     address indexed _owner,
147     address indexed _approved,
148     uint256 indexed _tokenId
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
181 
182 
183 /**
184  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
185  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
186  */
187 contract ERC721Enumerable is ERC721Basic {
188   function totalSupply() public view returns (uint256);
189   function tokenOfOwnerByIndex(
190     address _owner,
191     uint256 _index
192   )
193     public
194     view
195     returns (uint256 _tokenId);
196 
197   function tokenByIndex(uint256 _index) public view returns (uint256);
198 }
199 
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
203  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
204  */
205 contract ERC721Metadata is ERC721Basic {
206   function name() external view returns (string _name);
207   function symbol() external view returns (string _symbol);
208   function tokenURI(uint256 _tokenId) public view returns (string);
209 }
210 
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
214  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
215  */
216 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
217 }
218 
219 
220 
221 
222 /**
223  * @title ERC721 token receiver interface
224  * @dev Interface for any contract that wants to support safeTransfers
225  * from ERC721 asset contracts.
226  */
227 contract ERC721Receiver {
228   /**
229    * @dev Magic value to be returned upon successful reception of an NFT
230    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
231    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
232    */
233   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
234 
235   /**
236    * @notice Handle the receipt of an NFT
237    * @dev The ERC721 smart contract calls this function on the recipient
238    * after a `safetransfer`. This function MAY throw to revert and reject the
239    * transfer. Return of other than the magic value MUST result in the
240    * transaction being reverted.
241    * Note: the contract address is always the message sender.
242    * @param _operator The address which called `safeTransferFrom` function
243    * @param _from The address which previously owned the token
244    * @param _tokenId The NFT identifier which is being transferred
245    * @param _data Additional data with no specified format
246    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
247    */
248   function onERC721Received(
249     address _operator,
250     address _from,
251     uint256 _tokenId,
252     bytes _data
253   )
254     public
255     returns(bytes4);
256 }
257 
258 
259 
260 /**
261  * @title SafeMath
262  * @dev Math operations with safety checks that throw on error
263  */
264 library SafeMath {
265 
266   /**
267   * @dev Multiplies two numbers, throws on overflow.
268   */
269   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
270     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
271     // benefit is lost if 'b' is also tested.
272     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
273     if (a == 0) {
274       return 0;
275     }
276 
277     c = a * b;
278     assert(c / a == b);
279     return c;
280   }
281 
282   /**
283   * @dev Integer division of two numbers, truncating the quotient.
284   */
285   function div(uint256 a, uint256 b) internal pure returns (uint256) {
286     // assert(b > 0); // Solidity automatically throws when dividing by 0
287     // uint256 c = a / b;
288     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289     return a / b;
290   }
291 
292   /**
293   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
294   */
295   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296     assert(b <= a);
297     return a - b;
298   }
299 
300   /**
301   * @dev Adds two numbers, throws on overflow.
302   */
303   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
304     c = a + b;
305     assert(c >= a);
306     return c;
307   }
308 }
309 
310 
311 
312 /**
313  * Utility library of inline functions on addresses
314  */
315 library AddressUtils {
316 
317   /**
318    * Returns whether the target address is a contract
319    * @dev This function will return false if invoked during the constructor of a contract,
320    * as the code is not actually created until after the constructor finishes.
321    * @param addr address to check
322    * @return whether the target address is a contract
323    */
324   function isContract(address addr) internal view returns (bool) {
325     uint256 size;
326     // XXX Currently there is no better way to check if there is a contract in an address
327     // than to check the size of the code at that address.
328     // See https://ethereum.stackexchange.com/a/14016/36603
329     // for more details about how this works.
330     // TODO Check this again before the Serenity release, because all addresses will be
331     // contracts then.
332     // solium-disable-next-line security/no-inline-assembly
333     assembly { size := extcodesize(addr) }
334     return size > 0;
335   }
336 
337 }
338 
339 
340 
341 /**
342  * @title ERC721 Non-Fungible Token Standard basic implementation
343  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
344  */
345 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
346 
347   using SafeMath for uint256;
348   using AddressUtils for address;
349 
350   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
351   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
352   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
353 
354   // Mapping from token ID to owner
355   mapping (uint256 => address) internal tokenOwner;
356 
357   // Mapping from token ID to approved address
358   mapping (uint256 => address) internal tokenApprovals;
359 
360   // Mapping from owner to number of owned token
361   mapping (address => uint256) internal ownedTokensCount;
362 
363   // Mapping from owner to operator approvals
364   mapping (address => mapping (address => bool)) internal operatorApprovals;
365 
366   constructor()
367     public
368   {
369     // register the supported interfaces to conform to ERC721 via ERC165
370     _registerInterface(InterfaceId_ERC721);
371     _registerInterface(InterfaceId_ERC721Exists);
372   }
373 
374   /**
375    * @dev Gets the balance of the specified address
376    * @param _owner address to query the balance of
377    * @return uint256 representing the amount owned by the passed address
378    */
379   function balanceOf(address _owner) public view returns (uint256) {
380     require(_owner != address(0));
381     return ownedTokensCount[_owner];
382   }
383 
384   /**
385    * @dev Gets the owner of the specified token ID
386    * @param _tokenId uint256 ID of the token to query the owner of
387    * @return owner address currently marked as the owner of the given token ID
388    */
389   function ownerOf(uint256 _tokenId) public view returns (address) {
390     address owner = tokenOwner[_tokenId];
391     require(owner != address(0));
392     return owner;
393   }
394 
395   /**
396    * @dev Returns whether the specified token exists
397    * @param _tokenId uint256 ID of the token to query the existence of
398    * @return whether the token exists
399    */
400   function exists(uint256 _tokenId) public view returns (bool) {
401     address owner = tokenOwner[_tokenId];
402     return owner != address(0);
403   }
404 
405   /**
406    * @dev Approves another address to transfer the given token ID
407    * The zero address indicates there is no approved address.
408    * There can only be one approved address per token at a given time.
409    * Can only be called by the token owner or an approved operator.
410    * @param _to address to be approved for the given token ID
411    * @param _tokenId uint256 ID of the token to be approved
412    */
413   function approve(address _to, uint256 _tokenId) public {
414     address owner = ownerOf(_tokenId);
415     require(_to != owner);
416     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
417 
418     tokenApprovals[_tokenId] = _to;
419     emit Approval(owner, _to, _tokenId);
420   }
421 
422   /**
423    * @dev Gets the approved address for a token ID, or zero if no address set
424    * @param _tokenId uint256 ID of the token to query the approval of
425    * @return address currently approved for the given token ID
426    */
427   function getApproved(uint256 _tokenId) public view returns (address) {
428     return tokenApprovals[_tokenId];
429   }
430 
431   /**
432    * @dev Sets or unsets the approval of a given operator
433    * An operator is allowed to transfer all tokens of the sender on their behalf
434    * @param _to operator address to set the approval
435    * @param _approved representing the status of the approval to be set
436    */
437   function setApprovalForAll(address _to, bool _approved) public {
438     require(_to != msg.sender);
439     operatorApprovals[msg.sender][_to] = _approved;
440     emit ApprovalForAll(msg.sender, _to, _approved);
441   }
442 
443   /**
444    * @dev Tells whether an operator is approved by a given owner
445    * @param _owner owner address which you want to query the approval of
446    * @param _operator operator address which you want to query the approval of
447    * @return bool whether the given operator is approved by the given owner
448    */
449   function isApprovedForAll(
450     address _owner,
451     address _operator
452   )
453     public
454     view
455     returns (bool)
456   {
457     return operatorApprovals[_owner][_operator];
458   }
459 
460   /**
461    * @dev Transfers the ownership of a given token ID to another address
462    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
463    * Requires the msg sender to be the owner, approved, or operator
464    * @param _from current owner of the token
465    * @param _to address to receive the ownership of the given token ID
466    * @param _tokenId uint256 ID of the token to be transferred
467   */
468   function transferFrom(
469     address _from,
470     address _to,
471     uint256 _tokenId
472   )
473     public
474   {
475     require(isApprovedOrOwner(msg.sender, _tokenId));
476     require(_from != address(0));
477     require(_to != address(0));
478 
479     clearApproval(_from, _tokenId);
480     removeTokenFrom(_from, _tokenId);
481     addTokenTo(_to, _tokenId);
482 
483     emit Transfer(_from, _to, _tokenId);
484   }
485 
486   /**
487    * @dev Safely transfers the ownership of a given token ID to another address
488    * If the target address is a contract, it must implement `onERC721Received`,
489    * which is called upon a safe transfer, and return the magic value
490    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
491    * the transfer is reverted.
492    *
493    * Requires the msg sender to be the owner, approved, or operator
494    * @param _from current owner of the token
495    * @param _to address to receive the ownership of the given token ID
496    * @param _tokenId uint256 ID of the token to be transferred
497   */
498   function safeTransferFrom(
499     address _from,
500     address _to,
501     uint256 _tokenId
502   )
503     public
504   {
505     // solium-disable-next-line arg-overflow
506     safeTransferFrom(_from, _to, _tokenId, "");
507   }
508 
509   /**
510    * @dev Safely transfers the ownership of a given token ID to another address
511    * If the target address is a contract, it must implement `onERC721Received`,
512    * which is called upon a safe transfer, and return the magic value
513    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
514    * the transfer is reverted.
515    * Requires the msg sender to be the owner, approved, or operator
516    * @param _from current owner of the token
517    * @param _to address to receive the ownership of the given token ID
518    * @param _tokenId uint256 ID of the token to be transferred
519    * @param _data bytes data to send along with a safe transfer check
520    */
521   function safeTransferFrom(
522     address _from,
523     address _to,
524     uint256 _tokenId,
525     bytes _data
526   )
527     public
528   {
529     transferFrom(_from, _to, _tokenId);
530     // solium-disable-next-line arg-overflow
531     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
532   }
533 
534   /**
535    * @dev Returns whether the given spender can transfer a given token ID
536    * @param _spender address of the spender to query
537    * @param _tokenId uint256 ID of the token to be transferred
538    * @return bool whether the msg.sender is approved for the given token ID,
539    *  is an operator of the owner, or is the owner of the token
540    */
541   function isApprovedOrOwner(
542     address _spender,
543     uint256 _tokenId
544   )
545     internal
546     view
547     returns (bool)
548   {
549     address owner = ownerOf(_tokenId);
550     // Disable solium check because of
551     // https://github.com/duaraghav8/Solium/issues/175
552     // solium-disable-next-line operator-whitespace
553     return (
554       _spender == owner ||
555       getApproved(_tokenId) == _spender ||
556       isApprovedForAll(owner, _spender)
557     );
558   }
559 
560   /**
561    * @dev Internal function to mint a new token
562    * Reverts if the given token ID already exists
563    * @param _to The address that will own the minted token
564    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
565    */
566   function _mint(address _to, uint256 _tokenId) internal {
567     require(_to != address(0));
568     addTokenTo(_to, _tokenId);
569     emit Transfer(address(0), _to, _tokenId);
570   }
571 
572   /**
573    * @dev Internal function to burn a specific token
574    * Reverts if the token does not exist
575    * @param _tokenId uint256 ID of the token being burned by the msg.sender
576    */
577   function _burn(address _owner, uint256 _tokenId) internal {
578     clearApproval(_owner, _tokenId);
579     removeTokenFrom(_owner, _tokenId);
580     emit Transfer(_owner, address(0), _tokenId);
581   }
582 
583   /**
584    * @dev Internal function to clear current approval of a given token ID
585    * Reverts if the given address is not indeed the owner of the token
586    * @param _owner owner of the token
587    * @param _tokenId uint256 ID of the token to be transferred
588    */
589   function clearApproval(address _owner, uint256 _tokenId) internal {
590     require(ownerOf(_tokenId) == _owner);
591     if (tokenApprovals[_tokenId] != address(0)) {
592       tokenApprovals[_tokenId] = address(0);
593     }
594   }
595 
596   /**
597    * @dev Internal function to add a token ID to the list of a given address
598    * @param _to address representing the new owner of the given token ID
599    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
600    */
601   function addTokenTo(address _to, uint256 _tokenId) internal {
602     require(tokenOwner[_tokenId] == address(0));
603     tokenOwner[_tokenId] = _to;
604     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
605   }
606 
607   /**
608    * @dev Internal function to remove a token ID from the list of a given address
609    * @param _from address representing the previous owner of the given token ID
610    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
611    */
612   function removeTokenFrom(address _from, uint256 _tokenId) internal {
613     require(ownerOf(_tokenId) == _from);
614     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
615     tokenOwner[_tokenId] = address(0);
616   }
617 
618   /**
619    * @dev Internal function to invoke `onERC721Received` on a target address
620    * The call is not executed if the target address is not a contract
621    * @param _from address representing the previous owner of the given token ID
622    * @param _to target address that will receive the tokens
623    * @param _tokenId uint256 ID of the token to be transferred
624    * @param _data bytes optional data to send along with the call
625    * @return whether the call correctly returned the expected magic value
626    */
627   function checkAndCallSafeTransfer(
628     address _from,
629     address _to,
630     uint256 _tokenId,
631     bytes _data
632   )
633     internal
634     returns (bool)
635   {
636     if (!_to.isContract()) {
637       return true;
638     }
639     bytes4 retval = ERC721Receiver(_to).onERC721Received(
640       msg.sender, _from, _tokenId, _data);
641     return (retval == ERC721_RECEIVED);
642   }
643 }
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
843 contract Nfties is ERC721Token {
844 
845   constructor() public ERC721Token("Nfties","NFTIES") { }
846 
847   struct Token{
848     uint8 body;
849     uint8 feet;
850     uint8 head;
851     uint8 mouth;
852     uint8 extra;
853     uint64 birthBlock;
854   }
855 
856   Token[] private tokens;
857 
858   //Anyone can pay the gas to create their very own Tester token
859   function create() public returns (uint256 _tokenId) {
860 
861     bytes32 sudoRandomButTotallyPredictable = keccak256(abi.encodePacked(totalSupply(),blockhash(block.number - 1)));
862     uint8 body = (uint8(sudoRandomButTotallyPredictable[0])%5)+1;
863     uint8 feet = (uint8(sudoRandomButTotallyPredictable[1])%5)+1;
864     uint8 head = (uint8(sudoRandomButTotallyPredictable[2])%5)+1;
865     uint8 mouth = (uint8(sudoRandomButTotallyPredictable[3])%5)+1;
866     uint8 extra = (uint8(sudoRandomButTotallyPredictable[4])%5)+1;
867 
868     //this is about half of all the gas it takes because I'm doing some string manipulation
869     //I could skip this, or make it way more efficient but the is just a silly hackathon project
870     string memory tokenUri = createTokenUri(body,feet,head,mouth,extra);
871 
872     Token memory _newToken = Token({
873         body: body,
874         feet: feet,
875         head: head,
876         mouth: mouth,
877         extra: extra,
878         birthBlock: uint64(block.number)
879     });
880     _tokenId = tokens.push(_newToken) - 1;
881     _mint(msg.sender,_tokenId);
882     _setTokenURI(_tokenId, tokenUri);
883     emit Create(_tokenId,msg.sender,body,feet,head,mouth,extra,_newToken.birthBlock,tokenUri);
884     return _tokenId;
885   }
886 
887   event Create(
888     uint _id,
889     address indexed _owner,
890     uint8 _body,
891     uint8 _feet,
892     uint8 _head,
893     uint8 _mouth,
894     uint8 _extra,
895     uint64 _birthBlock,
896     string _uri
897   );
898 
899   //Get any token metadata by passing in the ID
900   function get(uint256 _id) public view returns (address owner,uint8 body,uint8 feet,uint8 head,uint8 mouth,uint8 extra,uint64 birthBlock) {
901     return (
902       tokenOwner[_id],
903       tokens[_id].body,
904       tokens[_id].feet,
905       tokens[_id].head,
906       tokens[_id].mouth,
907       tokens[_id].extra,
908       tokens[_id].birthBlock
909     );
910   }
911 
912   function tokensOfOwner(address _owner) public view returns(uint256[]) {
913     return ownedTokens[_owner];
914   }
915 
916   function createTokenUri(uint8 body,uint8 feet,uint8 head,uint8 mouth,uint8 extra) internal returns (string){
917     string memory uri = "https://nfties.io/tokens/nfties-";
918     uri = appendUint8ToString(uri,body);
919     uri = strConcat(uri,"-");
920     uri = appendUint8ToString(uri,feet);
921     uri = strConcat(uri,"-");
922     uri = appendUint8ToString(uri,head);
923     uri = strConcat(uri,"-");
924     uri = appendUint8ToString(uri,mouth);
925     uri = strConcat(uri,"-");
926     uri = appendUint8ToString(uri,extra);
927     uri = strConcat(uri,".png");
928     return uri;
929   }
930 
931   function appendUint8ToString(string inStr, uint8 v) internal constant returns (string str) {
932         uint maxlength = 100;
933         bytes memory reversed = new bytes(maxlength);
934         uint i = 0;
935         while (v != 0) {
936             uint remainder = v % 10;
937             v = v / 10;
938             reversed[i++] = byte(48 + remainder);
939         }
940         bytes memory inStrb = bytes(inStr);
941         bytes memory s = new bytes(inStrb.length + i);
942         uint j;
943         for (j = 0; j < inStrb.length; j++) {
944             s[j] = inStrb[j];
945         }
946         for (j = 0; j < i; j++) {
947             s[j + inStrb.length] = reversed[i - 1 - j];
948         }
949         str = string(s);
950     }
951 
952     function strConcat(string _a, string _b) internal pure returns (string) {
953         bytes memory _ba = bytes(_a);
954         bytes memory _bb = bytes(_b);
955         string memory ab = new string(_ba.length + _bb.length);
956         bytes memory bab = bytes(ab);
957         uint k = 0;
958         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
959         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
960         return string(bab);
961     }
962 
963 }