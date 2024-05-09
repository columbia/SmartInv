1 pragma solidity ^0.4.21;
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
26 
27   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
28   /*
29    * 0x80ac58cd ===
30    *   bytes4(keccak256('balanceOf(address)')) ^
31    *   bytes4(keccak256('ownerOf(uint256)')) ^
32    *   bytes4(keccak256('approve(address,uint256)')) ^
33    *   bytes4(keccak256('getApproved(uint256)')) ^
34    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
35    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
36    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
37    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
38    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
39    */
40 
41   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
42   /**
43    * 0x780e9d63 ===
44    *   bytes4(keccak256('totalSupply()')) ^
45    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
46    *   bytes4(keccak256('tokenByIndex(uint256)'))
47    */
48 
49   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
50   /**
51    * 0x5b5e139f ===
52    *   bytes4(keccak256('name()')) ^
53    *   bytes4(keccak256('symbol()')) ^
54    *   bytes4(keccak256('tokenURI(uint256)'))
55    */
56 
57   event Transfer(
58     address indexed _from,
59     address indexed _to,
60     uint256 indexed _tokenId
61   );
62   event Approval(
63     address indexed _owner,
64     address indexed _approved,
65     uint256 indexed _tokenId
66   );
67   event ApprovalForAll(
68     address indexed _owner,
69     address indexed _operator,
70     bool _approved
71   );
72 
73   function balanceOf(address _owner) public view returns (uint256 _balance);
74   function ownerOf(uint256 _tokenId) public view returns (address _owner);
75 
76   function approve(address _to, uint256 _tokenId) public;
77   function getApproved(uint256 _tokenId)
78     public view returns (address _operator);
79 
80   function setApprovalForAll(address _operator, bool _approved) public;
81   function isApprovedForAll(address _owner, address _operator)
82     public view returns (bool);
83 
84   function transferFrom(address _from, address _to, uint256 _tokenId) public;
85   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
86     public;
87 
88   function safeTransferFrom(
89     address _from,
90     address _to,
91     uint256 _tokenId,
92     bytes _data
93   )
94     public;
95 }
96 
97 /**
98  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
99  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
100  */
101 contract ERC721Enumerable is ERC721Basic {
102   function totalSupply() public view returns (uint256);
103   function tokenOfOwnerByIndex(
104     address _owner,
105     uint256 _index
106   )
107     public
108     view
109     returns (uint256 _tokenId);
110 
111   function tokenByIndex(uint256 _index) public view returns (uint256);
112 }
113 
114 
115 /**
116  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
117  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
118  */
119 contract ERC721Metadata is ERC721Basic {
120   function name() external view returns (string _name);
121   function symbol() external view returns (string _symbol);
122   function tokenURI(uint256 _tokenId) public view returns (string);
123 }
124 
125 
126 /**
127  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
128  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
129  */
130 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
131 }
132 
133 /**
134  * @title SupportsInterfaceWithLookup
135  * @author Matt Condon (@shrugs)
136  * @dev Implements ERC165 using a lookup table.
137  */
138 contract SupportsInterfaceWithLookup is ERC165 {
139 
140   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
141   /**
142    * 0x01ffc9a7 ===
143    *   bytes4(keccak256('supportsInterface(bytes4)'))
144    */
145 
146   /**
147    * @dev a mapping of interface id to whether or not it's supported
148    */
149   mapping(bytes4 => bool) internal supportedInterfaces;
150 
151   /**
152    * @dev A contract implementing SupportsInterfaceWithLookup
153    * implement ERC165 itself
154    */
155   constructor()
156     public
157   {
158     _registerInterface(InterfaceId_ERC165);
159   }
160 
161   /**
162    * @dev implement supportsInterface(bytes4) using a lookup table
163    */
164   function supportsInterface(bytes4 _interfaceId)
165     external
166     view
167     returns (bool)
168   {
169     return supportedInterfaces[_interfaceId];
170   }
171 
172   /**
173    * @dev private method for registering an interface
174    */
175   function _registerInterface(bytes4 _interfaceId)
176     internal
177   {
178     require(_interfaceId != 0xffffffff);
179     supportedInterfaces[_interfaceId] = true;
180   }
181 }
182 
183 /**
184  * @title SafeMath
185  * @dev Math operations with safety checks that revert on error
186  */
187 library SafeMath {
188 
189   /**
190   * @dev Multiplies two numbers, reverts on overflow.
191   */
192   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
193     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
194     // benefit is lost if 'b' is also tested.
195     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
196     if (_a == 0) {
197       return 0;
198     }
199 
200     uint256 c = _a * _b;
201     require(c / _a == _b);
202 
203     return c;
204   }
205 
206   /**
207   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
208   */
209   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
210     require(_b > 0); // Solidity only automatically asserts when dividing by 0
211     uint256 c = _a / _b;
212     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
213 
214     return c;
215   }
216 
217   /**
218   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
219   */
220   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
221     require(_b <= _a);
222     uint256 c = _a - _b;
223 
224     return c;
225   }
226 
227   /**
228   * @dev Adds two numbers, reverts on overflow.
229   */
230   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
231     uint256 c = _a + _b;
232     require(c >= _a);
233 
234     return c;
235   }
236 
237   /**
238   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
239   * reverts when dividing by zero.
240   */
241   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242     require(b != 0);
243     return a % b;
244   }
245 }
246 
247 /**
248  * Utility library of inline functions on addresses
249  */
250 library AddressUtils {
251 
252   /**
253    * Returns whether the target address is a contract
254    * @dev This function will return false if invoked during the constructor of a contract,
255    * as the code is not actually created until after the constructor finishes.
256    * @param _account address of the account to check
257    * @return whether the target address is a contract
258    */
259   function isContract(address _account) internal view returns (bool) {
260     uint256 size;
261     // XXX Currently there is no better way to check if there is a contract in an address
262     // than to check the size of the code at that address.
263     // See https://ethereum.stackexchange.com/a/14016/36603
264     // for more details about how this works.
265     // TODO Check this again before the Serenity release, because all addresses will be
266     // contracts then.
267     // solium-disable-next-line security/no-inline-assembly
268     assembly { size := extcodesize(_account) }
269     return size > 0;
270   }
271 
272 }
273 
274 /**
275  * @title ERC721 token receiver interface
276  * @dev Interface for any contract that wants to support safeTransfers
277  * from ERC721 asset contracts.
278  */
279 contract ERC721Receiver {
280   /**
281    * @dev Magic value to be returned upon successful reception of an NFT
282    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
283    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
284    */
285   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
286 
287   /**
288    * @notice Handle the receipt of an NFT
289    * @dev The ERC721 smart contract calls this function on the recipient
290    * after a `safetransfer`. This function MAY throw to revert and reject the
291    * transfer. Return of other than the magic value MUST result in the
292    * transaction being reverted.
293    * Note: the contract address is always the message sender.
294    * @param _operator The address which called `safeTransferFrom` function
295    * @param _from The address which previously owned the token
296    * @param _tokenId The NFT identifier which is being transferred
297    * @param _data Additional data with no specified format
298    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
299    */
300   function onERC721Received(
301     address _operator,
302     address _from,
303     uint256 _tokenId,
304     bytes _data
305   )
306     public
307     returns(bytes4);
308 }
309 
310 /**
311  * @title ERC721 Non-Fungible Token Standard basic implementation
312  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
313  */
314 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
315 
316   using SafeMath for uint256;
317   using AddressUtils for address;
318 
319   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
320   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
321   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
322 
323   // Mapping from token ID to owner
324   mapping (uint256 => address) internal tokenOwner;
325 
326   // Mapping from token ID to approved address
327   mapping (uint256 => address) internal tokenApprovals;
328 
329   // Mapping from owner to number of owned token
330   mapping (address => uint256) internal ownedTokensCount;
331 
332   // Mapping from owner to operator approvals
333   mapping (address => mapping (address => bool)) internal operatorApprovals;
334 
335   constructor()
336     public
337   {
338     // register the supported interfaces to conform to ERC721 via ERC165
339     _registerInterface(InterfaceId_ERC721);
340   }
341 
342   /**
343    * @dev Gets the balance of the specified address
344    * @param _owner address to query the balance of
345    * @return uint256 representing the amount owned by the passed address
346    */
347   function balanceOf(address _owner) public view returns (uint256) {
348     require(_owner != address(0));
349     return ownedTokensCount[_owner];
350   }
351 
352   /**
353    * @dev Gets the owner of the specified token ID
354    * @param _tokenId uint256 ID of the token to query the owner of
355    * @return owner address currently marked as the owner of the given token ID
356    */
357   function ownerOf(uint256 _tokenId) public view returns (address) {
358     address owner = tokenOwner[_tokenId];
359     require(owner != address(0));
360     return owner;
361   }
362 
363   /**
364    * @dev Approves another address to transfer the given token ID
365    * The zero address indicates there is no approved address.
366    * There can only be one approved address per token at a given time.
367    * Can only be called by the token owner or an approved operator.
368    * @param _to address to be approved for the given token ID
369    * @param _tokenId uint256 ID of the token to be approved
370    */
371   function approve(address _to, uint256 _tokenId) public {
372     address owner = ownerOf(_tokenId);
373     require(_to != owner);
374     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
375 
376     tokenApprovals[_tokenId] = _to;
377     emit Approval(owner, _to, _tokenId);
378   }
379 
380   /**
381    * @dev Gets the approved address for a token ID, or zero if no address set
382    * @param _tokenId uint256 ID of the token to query the approval of
383    * @return address currently approved for the given token ID
384    */
385   function getApproved(uint256 _tokenId) public view returns (address) {
386     return tokenApprovals[_tokenId];
387   }
388 
389   /**
390    * @dev Sets or unsets the approval of a given operator
391    * An operator is allowed to transfer all tokens of the sender on their behalf
392    * @param _to operator address to set the approval
393    * @param _approved representing the status of the approval to be set
394    */
395   function setApprovalForAll(address _to, bool _approved) public {
396     require(_to != msg.sender);
397     operatorApprovals[msg.sender][_to] = _approved;
398     emit ApprovalForAll(msg.sender, _to, _approved);
399   }
400 
401   /**
402    * @dev Tells whether an operator is approved by a given owner
403    * @param _owner owner address which you want to query the approval of
404    * @param _operator operator address which you want to query the approval of
405    * @return bool whether the given operator is approved by the given owner
406    */
407   function isApprovedForAll(
408     address _owner,
409     address _operator
410   )
411     public
412     view
413     returns (bool)
414   {
415     return operatorApprovals[_owner][_operator];
416   }
417 
418   /**
419    * @dev Transfers the ownership of a given token ID to another address
420    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
421    * Requires the msg sender to be the owner, approved, or operator
422    * @param _from current owner of the token
423    * @param _to address to receive the ownership of the given token ID
424    * @param _tokenId uint256 ID of the token to be transferred
425   */
426   function transferFrom(
427     address _from,
428     address _to,
429     uint256 _tokenId
430   )
431     public
432   {
433     require(isApprovedOrOwner(msg.sender, _tokenId));
434     require(_to != address(0));
435 
436     clearApproval(_from, _tokenId);
437     removeTokenFrom(_from, _tokenId);
438     addTokenTo(_to, _tokenId);
439 
440     emit Transfer(_from, _to, _tokenId);
441   }
442 
443   /**
444    * @dev Safely transfers the ownership of a given token ID to another address
445    * If the target address is a contract, it must implement `onERC721Received`,
446    * which is called upon a safe transfer, and return the magic value
447    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
448    * the transfer is reverted.
449    *
450    * Requires the msg sender to be the owner, approved, or operator
451    * @param _from current owner of the token
452    * @param _to address to receive the ownership of the given token ID
453    * @param _tokenId uint256 ID of the token to be transferred
454   */
455   function safeTransferFrom(
456     address _from,
457     address _to,
458     uint256 _tokenId
459   )
460     public
461   {
462     // solium-disable-next-line arg-overflow
463     safeTransferFrom(_from, _to, _tokenId, "");
464   }
465 
466   /**
467    * @dev Safely transfers the ownership of a given token ID to another address
468    * If the target address is a contract, it must implement `onERC721Received`,
469    * which is called upon a safe transfer, and return the magic value
470    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
471    * the transfer is reverted.
472    * Requires the msg sender to be the owner, approved, or operator
473    * @param _from current owner of the token
474    * @param _to address to receive the ownership of the given token ID
475    * @param _tokenId uint256 ID of the token to be transferred
476    * @param _data bytes data to send along with a safe transfer check
477    */
478   function safeTransferFrom(
479     address _from,
480     address _to,
481     uint256 _tokenId,
482     bytes _data
483   )
484     public
485   {
486     transferFrom(_from, _to, _tokenId);
487     // solium-disable-next-line arg-overflow
488     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
489   }
490 
491   /**
492    * @dev Returns whether the specified token exists
493    * @param _tokenId uint256 ID of the token to query the existence of
494    * @return whether the token exists
495    */
496   function _exists(uint256 _tokenId) internal view returns (bool) {
497     address owner = tokenOwner[_tokenId];
498     return owner != address(0);
499   }
500 
501   /**
502    * @dev Returns whether the given spender can transfer a given token ID
503    * @param _spender address of the spender to query
504    * @param _tokenId uint256 ID of the token to be transferred
505    * @return bool whether the msg.sender is approved for the given token ID,
506    *  is an operator of the owner, or is the owner of the token
507    */
508   function isApprovedOrOwner(
509     address _spender,
510     uint256 _tokenId
511   )
512     internal
513     view
514     returns (bool)
515   {
516     address owner = ownerOf(_tokenId);
517     // Disable solium check because of
518     // https://github.com/duaraghav8/Solium/issues/175
519     // solium-disable-next-line operator-whitespace
520     return (
521       _spender == owner ||
522       getApproved(_tokenId) == _spender ||
523       isApprovedForAll(owner, _spender)
524     );
525   }
526 
527   /**
528    * @dev Internal function to mint a new token
529    * Reverts if the given token ID already exists
530    * @param _to The address that will own the minted token
531    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
532    */
533   function _mint(address _to, uint256 _tokenId) internal {
534     require(_to != address(0));
535     addTokenTo(_to, _tokenId);
536     emit Transfer(address(0), _to, _tokenId);
537   }
538 
539   /**
540    * @dev Internal function to burn a specific token
541    * Reverts if the token does not exist
542    * @param _tokenId uint256 ID of the token being burned by the msg.sender
543    */
544   function _burn(address _owner, uint256 _tokenId) internal {
545     clearApproval(_owner, _tokenId);
546     removeTokenFrom(_owner, _tokenId);
547     emit Transfer(_owner, address(0), _tokenId);
548   }
549 
550   /**
551    * @dev Internal function to clear current approval of a given token ID
552    * Reverts if the given address is not indeed the owner of the token
553    * @param _owner owner of the token
554    * @param _tokenId uint256 ID of the token to be transferred
555    */
556   function clearApproval(address _owner, uint256 _tokenId) internal {
557     require(ownerOf(_tokenId) == _owner);
558     if (tokenApprovals[_tokenId] != address(0)) {
559       tokenApprovals[_tokenId] = address(0);
560     }
561   }
562 
563   /**
564    * @dev Internal function to add a token ID to the list of a given address
565    * @param _to address representing the new owner of the given token ID
566    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
567    */
568   function addTokenTo(address _to, uint256 _tokenId) internal {
569     require(tokenOwner[_tokenId] == address(0));
570     tokenOwner[_tokenId] = _to;
571     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
572   }
573 
574   /**
575    * @dev Internal function to remove a token ID from the list of a given address
576    * @param _from address representing the previous owner of the given token ID
577    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
578    */
579   function removeTokenFrom(address _from, uint256 _tokenId) internal {
580     require(ownerOf(_tokenId) == _from);
581     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
582     tokenOwner[_tokenId] = address(0);
583   }
584 
585   /**
586    * @dev Internal function to invoke `onERC721Received` on a target address
587    * The call is not executed if the target address is not a contract
588    * @param _from address representing the previous owner of the given token ID
589    * @param _to target address that will receive the tokens
590    * @param _tokenId uint256 ID of the token to be transferred
591    * @param _data bytes optional data to send along with the call
592    * @return whether the call correctly returned the expected magic value
593    */
594   function checkAndCallSafeTransfer(
595     address _from,
596     address _to,
597     uint256 _tokenId,
598     bytes _data
599   )
600     internal
601     returns (bool)
602   {
603     if (!_to.isContract()) {
604       return true;
605     }
606     bytes4 retval = ERC721Receiver(_to).onERC721Received(
607       msg.sender, _from, _tokenId, _data);
608     return (retval == ERC721_RECEIVED);
609   }
610 }
611 
612 /**
613  * @title Full ERC721 Token
614  * This implementation includes all the required and some optional functionality of the ERC721 standard
615  * Moreover, it includes approve all functionality using operator terminology
616  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
617  */
618 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
619 
620   // Token name
621   string internal name_;
622 
623   // Token symbol
624   string internal symbol_;
625 
626   // Mapping from owner to list of owned token IDs
627   mapping(address => uint256[]) internal ownedTokens;
628 
629   // Mapping from token ID to index of the owner tokens list
630   mapping(uint256 => uint256) internal ownedTokensIndex;
631 
632   // Array with all token ids, used for enumeration
633   uint256[] internal allTokens;
634 
635   // Mapping from token id to position in the allTokens array
636   mapping(uint256 => uint256) internal allTokensIndex;
637 
638   // Optional mapping for token URIs
639   mapping(uint256 => string) internal tokenURIs;
640 
641   /**
642    * @dev Constructor function
643    */
644   constructor(string _name, string _symbol) public {
645     name_ = _name;
646     symbol_ = _symbol;
647 
648     // register the supported interfaces to conform to ERC721 via ERC165
649     _registerInterface(InterfaceId_ERC721Enumerable);
650     _registerInterface(InterfaceId_ERC721Metadata);
651   }
652 
653   /**
654    * @dev Gets the token name
655    * @return string representing the token name
656    */
657   function name() external view returns (string) {
658     return name_;
659   }
660 
661   /**
662    * @dev Gets the token symbol
663    * @return string representing the token symbol
664    */
665   function symbol() external view returns (string) {
666     return symbol_;
667   }
668 
669   /**
670    * @dev Returns an URI for a given token ID
671    * Throws if the token ID does not exist. May return an empty string.
672    * @param _tokenId uint256 ID of the token to query
673    */
674   function tokenURI(uint256 _tokenId) public view returns (string) {
675     require(_exists(_tokenId));
676     return tokenURIs[_tokenId];
677   }
678 
679   /**
680    * @dev Gets the token ID at a given index of the tokens list of the requested owner
681    * @param _owner address owning the tokens list to be accessed
682    * @param _index uint256 representing the index to be accessed of the requested tokens list
683    * @return uint256 token ID at the given index of the tokens list owned by the requested address
684    */
685   function tokenOfOwnerByIndex(
686     address _owner,
687     uint256 _index
688   )
689     public
690     view
691     returns (uint256)
692   {
693     require(_index < balanceOf(_owner));
694     return ownedTokens[_owner][_index];
695   }
696 
697   /**
698    * @dev Gets the total amount of tokens stored by the contract
699    * @return uint256 representing the total amount of tokens
700    */
701   function totalSupply() public view returns (uint256) {
702     return allTokens.length;
703   }
704 
705   /**
706    * @dev Gets the token ID at a given index of all the tokens in this contract
707    * Reverts if the index is greater or equal to the total number of tokens
708    * @param _index uint256 representing the index to be accessed of the tokens list
709    * @return uint256 token ID at the given index of the tokens list
710    */
711   function tokenByIndex(uint256 _index) public view returns (uint256) {
712     require(_index < totalSupply());
713     return allTokens[_index];
714   }
715 
716   /**
717    * @dev Internal function to set the token URI for a given token
718    * Reverts if the token ID does not exist
719    * @param _tokenId uint256 ID of the token to set its URI
720    * @param _uri string URI to assign
721    */
722   function _setTokenURI(uint256 _tokenId, string _uri) internal {
723     require(_exists(_tokenId));
724     tokenURIs[_tokenId] = _uri;
725   }
726 
727   /**
728    * @dev Internal function to add a token ID to the list of a given address
729    * @param _to address representing the new owner of the given token ID
730    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
731    */
732   function addTokenTo(address _to, uint256 _tokenId) internal {
733     super.addTokenTo(_to, _tokenId);
734     uint256 length = ownedTokens[_to].length;
735     ownedTokens[_to].push(_tokenId);
736     ownedTokensIndex[_tokenId] = length;
737   }
738 
739   /**
740    * @dev Internal function to remove a token ID from the list of a given address
741    * @param _from address representing the previous owner of the given token ID
742    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
743    */
744   function removeTokenFrom(address _from, uint256 _tokenId) internal {
745     super.removeTokenFrom(_from, _tokenId);
746 
747     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
748     // then delete the last slot.
749     uint256 tokenIndex = ownedTokensIndex[_tokenId];
750     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
751     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
752 
753     ownedTokens[_from][tokenIndex] = lastToken;
754     // This also deletes the contents at the last position of the array
755     ownedTokens[_from].length--;
756 
757     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
758     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
759     // the lastToken to the first position, and then dropping the element placed in the last position of the list
760 
761     ownedTokensIndex[_tokenId] = 0;
762     ownedTokensIndex[lastToken] = tokenIndex;
763   }
764 
765   /**
766    * @dev Internal function to mint a new token
767    * Reverts if the given token ID already exists
768    * @param _to address the beneficiary that will own the minted token
769    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
770    */
771   function _mint(address _to, uint256 _tokenId) internal {
772     super._mint(_to, _tokenId);
773 
774     allTokensIndex[_tokenId] = allTokens.length;
775     allTokens.push(_tokenId);
776   }
777 
778   /**
779    * @dev Internal function to burn a specific token
780    * Reverts if the token does not exist
781    * @param _owner owner of the token to burn
782    * @param _tokenId uint256 ID of the token being burned by the msg.sender
783    */
784   function _burn(address _owner, uint256 _tokenId) internal {
785     super._burn(_owner, _tokenId);
786 
787     // Clear metadata (if any)
788     if (bytes(tokenURIs[_tokenId]).length != 0) {
789       delete tokenURIs[_tokenId];
790     }
791 
792     // Reorg all tokens array
793     uint256 tokenIndex = allTokensIndex[_tokenId];
794     uint256 lastTokenIndex = allTokens.length.sub(1);
795     uint256 lastToken = allTokens[lastTokenIndex];
796 
797     allTokens[tokenIndex] = lastToken;
798     allTokens[lastTokenIndex] = 0;
799 
800     allTokens.length--;
801     allTokensIndex[_tokenId] = 0;
802     allTokensIndex[lastToken] = tokenIndex;
803   }
804 
805 }
806 
807 /**
808  * @title Ownable
809  * @dev The Ownable contract has an owner address, and provides basic authorization control
810  * functions, this simplifies the implementation of "user permissions".
811  */
812 contract Ownable {
813   address public owner;
814 
815 
816   event OwnershipRenounced(address indexed previousOwner);
817   event OwnershipTransferred(
818     address indexed previousOwner,
819     address indexed newOwner
820   );
821 
822 
823   /**
824    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
825    * account.
826    */
827   constructor() public {
828     owner = msg.sender;
829   }
830 
831   /**
832    * @dev Throws if called by any account other than the owner.
833    */
834   modifier onlyOwner() {
835     require(msg.sender == owner);
836     _;
837   }
838 
839   /**
840    * @dev Allows the current owner to relinquish control of the contract.
841    * @notice Renouncing to ownership will leave the contract without an owner.
842    * It will not be possible to call the functions with the `onlyOwner`
843    * modifier anymore.
844    */
845   function renounceOwnership() public onlyOwner {
846     emit OwnershipRenounced(owner);
847     owner = address(0);
848   }
849 
850   /**
851    * @dev Allows the current owner to transfer control of the contract to a newOwner.
852    * @param _newOwner The address to transfer ownership to.
853    */
854   function transferOwnership(address _newOwner) public onlyOwner {
855     _transferOwnership(_newOwner);
856   }
857 
858   /**
859    * @dev Transfers control of the contract to a newOwner.
860    * @param _newOwner The address to transfer ownership to.
861    */
862   function _transferOwnership(address _newOwner) internal {
863     require(_newOwner != address(0));
864     emit OwnershipTransferred(owner, _newOwner);
865     owner = _newOwner;
866   }
867 }
868 
869 /*
870  * @title String & slice utility library for Solidity contracts.
871  * @author Nick Johnson <arachnid@notdot.net>
872  *
873  * @dev Functionality in this library is largely implemented using an
874  *      abstraction called a 'slice'. A slice represents a part of a string -
875  *      anything from the entire string to a single character, or even no
876  *      characters at all (a 0-length slice). Since a slice only has to specify
877  *      an offset and a length, copying and manipulating slices is a lot less
878  *      expensive than copying and manipulating the strings they reference.
879  *
880  *      To further reduce gas costs, most functions on slice that need to return
881  *      a slice modify the original one instead of allocating a new one; for
882  *      instance, `s.split(".")` will return the text up to the first '.',
883  *      modifying s to only contain the remainder of the string after the '.'.
884  *      In situations where you do not want to modify the original slice, you
885  *      can make a copy first with `.copy()`, for example:
886  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
887  *      Solidity has no memory management, it will result in allocating many
888  *      short-lived slices that are later discarded.
889  *
890  *      Functions that return two slices come in two versions: a non-allocating
891  *      version that takes the second slice as an argument, modifying it in
892  *      place, and an allocating version that allocates and returns the second
893  *      slice; see `nextRune` for example.
894  *
895  *      Functions that have to copy string data will return strings rather than
896  *      slices; these can be cast back to slices for further processing if
897  *      required.
898  *
899  *      For convenience, some functions are provided with non-modifying
900  *      variants that create a new slice and return both; for instance,
901  *      `s.splitNew('.')` leaves s unmodified, and returns two values
902  *      corresponding to the left and right parts of the string.
903  */
904 
905 library strings {
906     struct slice {
907         uint _len;
908         uint _ptr;
909     }
910 
911     function memcpy(uint dest, uint src, uint len) private pure {
912         // Copy word-length chunks while possible
913         for(; len >= 32; len -= 32) {
914             assembly {
915                 mstore(dest, mload(src))
916             }
917             dest += 32;
918             src += 32;
919         }
920 
921         // Copy remaining bytes
922         uint mask = 256 ** (32 - len) - 1;
923         assembly {
924             let srcpart := and(mload(src), not(mask))
925             let destpart := and(mload(dest), mask)
926             mstore(dest, or(destpart, srcpart))
927         }
928     }
929 
930     /*
931      * @dev Returns a slice containing the entire string.
932      * @param self The string to make a slice from.
933      * @return A newly allocated slice containing the entire string.
934      */
935     function toSlice(string memory self) internal pure returns (slice memory) {
936         uint ptr;
937         assembly {
938             ptr := add(self, 0x20)
939         }
940         return slice(bytes(self).length, ptr);
941     }
942 
943     /*
944      * @dev Returns the length of a null-terminated bytes32 string.
945      * @param self The value to find the length of.
946      * @return The length of the string, from 0 to 32.
947      */
948     function len(bytes32 self) internal pure returns (uint) {
949         uint ret;
950         if (self == 0)
951             return 0;
952         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
953             ret += 16;
954             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
955         }
956         if (self & 0xffffffffffffffff == 0) {
957             ret += 8;
958             self = bytes32(uint(self) / 0x10000000000000000);
959         }
960         if (self & 0xffffffff == 0) {
961             ret += 4;
962             self = bytes32(uint(self) / 0x100000000);
963         }
964         if (self & 0xffff == 0) {
965             ret += 2;
966             self = bytes32(uint(self) / 0x10000);
967         }
968         if (self & 0xff == 0) {
969             ret += 1;
970         }
971         return 32 - ret;
972     }
973 
974     /*
975      * @dev Returns a slice containing the entire bytes32, interpreted as a
976      *      null-terminated utf-8 string.
977      * @param self The bytes32 value to convert to a slice.
978      * @return A new slice containing the value of the input argument up to the
979      *         first null.
980      */
981     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
982         // Allocate space for `self` in memory, copy it there, and point ret at it
983         assembly {
984             let ptr := mload(0x40)
985             mstore(0x40, add(ptr, 0x20))
986             mstore(ptr, self)
987             mstore(add(ret, 0x20), ptr)
988         }
989         ret._len = len(self);
990     }
991 
992     /*
993      * @dev Returns a new slice containing the same data as the current slice.
994      * @param self The slice to copy.
995      * @return A new slice containing the same data as `self`.
996      */
997     function copy(slice memory self) internal pure returns (slice memory) {
998         return slice(self._len, self._ptr);
999     }
1000 
1001     /*
1002      * @dev Copies a slice to a new string.
1003      * @param self The slice to copy.
1004      * @return A newly allocated string containing the slice's text.
1005      */
1006     function toString(slice memory self) internal pure returns (string memory) {
1007         string memory ret = new string(self._len);
1008         uint retptr;
1009         assembly { retptr := add(ret, 32) }
1010 
1011         memcpy(retptr, self._ptr, self._len);
1012         return ret;
1013     }
1014 
1015     /*
1016      * @dev Returns the length in runes of the slice. Note that this operation
1017      *      takes time proportional to the length of the slice; avoid using it
1018      *      in loops, and call `slice.empty()` if you only need to know whether
1019      *      the slice is empty or not.
1020      * @param self The slice to operate on.
1021      * @return The length of the slice in runes.
1022      */
1023     function len(slice memory self) internal pure returns (uint l) {
1024         // Starting at ptr-31 means the LSB will be the byte we care about
1025         uint ptr = self._ptr - 31;
1026         uint end = ptr + self._len;
1027         for (l = 0; ptr < end; l++) {
1028             uint8 b;
1029             assembly { b := and(mload(ptr), 0xFF) }
1030             if (b < 0x80) {
1031                 ptr += 1;
1032             } else if(b < 0xE0) {
1033                 ptr += 2;
1034             } else if(b < 0xF0) {
1035                 ptr += 3;
1036             } else if(b < 0xF8) {
1037                 ptr += 4;
1038             } else if(b < 0xFC) {
1039                 ptr += 5;
1040             } else {
1041                 ptr += 6;
1042             }
1043         }
1044     }
1045 
1046     /*
1047      * @dev Returns true if the slice is empty (has a length of 0).
1048      * @param self The slice to operate on.
1049      * @return True if the slice is empty, False otherwise.
1050      */
1051     function empty(slice memory self) internal pure returns (bool) {
1052         return self._len == 0;
1053     }
1054 
1055     /*
1056      * @dev Returns a positive number if `other` comes lexicographically after
1057      *      `self`, a negative number if it comes before, or zero if the
1058      *      contents of the two slices are equal. Comparison is done per-rune,
1059      *      on unicode codepoints.
1060      * @param self The first slice to compare.
1061      * @param other The second slice to compare.
1062      * @return The result of the comparison.
1063      */
1064     function compare(slice memory self, slice memory other) internal pure returns (int) {
1065         uint shortest = self._len;
1066         if (other._len < self._len)
1067             shortest = other._len;
1068 
1069         uint selfptr = self._ptr;
1070         uint otherptr = other._ptr;
1071         for (uint idx = 0; idx < shortest; idx += 32) {
1072             uint a;
1073             uint b;
1074             assembly {
1075                 a := mload(selfptr)
1076                 b := mload(otherptr)
1077             }
1078             if (a != b) {
1079                 // Mask out irrelevant bytes and check again
1080                 uint256 mask = uint256(-1); // 0xffff...
1081                 if(shortest < 32) {
1082                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1083                 }
1084                 uint256 diff = (a & mask) - (b & mask);
1085                 if (diff != 0)
1086                     return int(diff);
1087             }
1088             selfptr += 32;
1089             otherptr += 32;
1090         }
1091         return int(self._len) - int(other._len);
1092     }
1093 
1094     /*
1095      * @dev Returns true if the two slices contain the same text.
1096      * @param self The first slice to compare.
1097      * @param self The second slice to compare.
1098      * @return True if the slices are equal, false otherwise.
1099      */
1100     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1101         return compare(self, other) == 0;
1102     }
1103 
1104     /*
1105      * @dev Extracts the first rune in the slice into `rune`, advancing the
1106      *      slice to point to the next rune and returning `self`.
1107      * @param self The slice to operate on.
1108      * @param rune The slice that will contain the first rune.
1109      * @return `rune`.
1110      */
1111     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1112         rune._ptr = self._ptr;
1113 
1114         if (self._len == 0) {
1115             rune._len = 0;
1116             return rune;
1117         }
1118 
1119         uint l;
1120         uint b;
1121         // Load the first byte of the rune into the LSBs of b
1122         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1123         if (b < 0x80) {
1124             l = 1;
1125         } else if(b < 0xE0) {
1126             l = 2;
1127         } else if(b < 0xF0) {
1128             l = 3;
1129         } else {
1130             l = 4;
1131         }
1132 
1133         // Check for truncated codepoints
1134         if (l > self._len) {
1135             rune._len = self._len;
1136             self._ptr += self._len;
1137             self._len = 0;
1138             return rune;
1139         }
1140 
1141         self._ptr += l;
1142         self._len -= l;
1143         rune._len = l;
1144         return rune;
1145     }
1146 
1147     /*
1148      * @dev Returns the first rune in the slice, advancing the slice to point
1149      *      to the next rune.
1150      * @param self The slice to operate on.
1151      * @return A slice containing only the first rune from `self`.
1152      */
1153     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1154         nextRune(self, ret);
1155     }
1156 
1157     /*
1158      * @dev Returns the number of the first codepoint in the slice.
1159      * @param self The slice to operate on.
1160      * @return The number of the first codepoint in the slice.
1161      */
1162     function ord(slice memory self) internal pure returns (uint ret) {
1163         if (self._len == 0) {
1164             return 0;
1165         }
1166 
1167         uint word;
1168         uint length;
1169         uint divisor = 2 ** 248;
1170 
1171         // Load the rune into the MSBs of b
1172         assembly { word:= mload(mload(add(self, 32))) }
1173         uint b = word / divisor;
1174         if (b < 0x80) {
1175             ret = b;
1176             length = 1;
1177         } else if(b < 0xE0) {
1178             ret = b & 0x1F;
1179             length = 2;
1180         } else if(b < 0xF0) {
1181             ret = b & 0x0F;
1182             length = 3;
1183         } else {
1184             ret = b & 0x07;
1185             length = 4;
1186         }
1187 
1188         // Check for truncated codepoints
1189         if (length > self._len) {
1190             return 0;
1191         }
1192 
1193         for (uint i = 1; i < length; i++) {
1194             divisor = divisor / 256;
1195             b = (word / divisor) & 0xFF;
1196             if (b & 0xC0 != 0x80) {
1197                 // Invalid UTF-8 sequence
1198                 return 0;
1199             }
1200             ret = (ret * 64) | (b & 0x3F);
1201         }
1202 
1203         return ret;
1204     }
1205 
1206     /*
1207      * @dev Returns the keccak-256 hash of the slice.
1208      * @param self The slice to hash.
1209      * @return The hash of the slice.
1210      */
1211     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1212         assembly {
1213             ret := keccak256(mload(add(self, 32)), mload(self))
1214         }
1215     }
1216 
1217     /*
1218      * @dev Returns true if `self` starts with `needle`.
1219      * @param self The slice to operate on.
1220      * @param needle The slice to search for.
1221      * @return True if the slice starts with the provided text, false otherwise.
1222      */
1223     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1224         if (self._len < needle._len) {
1225             return false;
1226         }
1227 
1228         if (self._ptr == needle._ptr) {
1229             return true;
1230         }
1231 
1232         bool equal;
1233         assembly {
1234             let length := mload(needle)
1235             let selfptr := mload(add(self, 0x20))
1236             let needleptr := mload(add(needle, 0x20))
1237             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1238         }
1239         return equal;
1240     }
1241 
1242     /*
1243      * @dev If `self` starts with `needle`, `needle` is removed from the
1244      *      beginning of `self`. Otherwise, `self` is unmodified.
1245      * @param self The slice to operate on.
1246      * @param needle The slice to search for.
1247      * @return `self`
1248      */
1249     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1250         if (self._len < needle._len) {
1251             return self;
1252         }
1253 
1254         bool equal = true;
1255         if (self._ptr != needle._ptr) {
1256             assembly {
1257                 let length := mload(needle)
1258                 let selfptr := mload(add(self, 0x20))
1259                 let needleptr := mload(add(needle, 0x20))
1260                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1261             }
1262         }
1263 
1264         if (equal) {
1265             self._len -= needle._len;
1266             self._ptr += needle._len;
1267         }
1268 
1269         return self;
1270     }
1271 
1272     /*
1273      * @dev Returns true if the slice ends with `needle`.
1274      * @param self The slice to operate on.
1275      * @param needle The slice to search for.
1276      * @return True if the slice starts with the provided text, false otherwise.
1277      */
1278     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1279         if (self._len < needle._len) {
1280             return false;
1281         }
1282 
1283         uint selfptr = self._ptr + self._len - needle._len;
1284 
1285         if (selfptr == needle._ptr) {
1286             return true;
1287         }
1288 
1289         bool equal;
1290         assembly {
1291             let length := mload(needle)
1292             let needleptr := mload(add(needle, 0x20))
1293             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1294         }
1295 
1296         return equal;
1297     }
1298 
1299     /*
1300      * @dev If `self` ends with `needle`, `needle` is removed from the
1301      *      end of `self`. Otherwise, `self` is unmodified.
1302      * @param self The slice to operate on.
1303      * @param needle The slice to search for.
1304      * @return `self`
1305      */
1306     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1307         if (self._len < needle._len) {
1308             return self;
1309         }
1310 
1311         uint selfptr = self._ptr + self._len - needle._len;
1312         bool equal = true;
1313         if (selfptr != needle._ptr) {
1314             assembly {
1315                 let length := mload(needle)
1316                 let needleptr := mload(add(needle, 0x20))
1317                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1318             }
1319         }
1320 
1321         if (equal) {
1322             self._len -= needle._len;
1323         }
1324 
1325         return self;
1326     }
1327 
1328     // Returns the memory address of the first byte of the first occurrence of
1329     // `needle` in `self`, or the first byte after `self` if not found.
1330     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1331         uint ptr = selfptr;
1332         uint idx;
1333 
1334         if (needlelen <= selflen) {
1335             if (needlelen <= 32) {
1336                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1337 
1338                 bytes32 needledata;
1339                 assembly { needledata := and(mload(needleptr), mask) }
1340 
1341                 uint end = selfptr + selflen - needlelen;
1342                 bytes32 ptrdata;
1343                 assembly { ptrdata := and(mload(ptr), mask) }
1344 
1345                 while (ptrdata != needledata) {
1346                     if (ptr >= end)
1347                         return selfptr + selflen;
1348                     ptr++;
1349                     assembly { ptrdata := and(mload(ptr), mask) }
1350                 }
1351                 return ptr;
1352             } else {
1353                 // For long needles, use hashing
1354                 bytes32 hash;
1355                 assembly { hash := keccak256(needleptr, needlelen) }
1356 
1357                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1358                     bytes32 testHash;
1359                     assembly { testHash := keccak256(ptr, needlelen) }
1360                     if (hash == testHash)
1361                         return ptr;
1362                     ptr += 1;
1363                 }
1364             }
1365         }
1366         return selfptr + selflen;
1367     }
1368 
1369     // Returns the memory address of the first byte after the last occurrence of
1370     // `needle` in `self`, or the address of `self` if not found.
1371     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1372         uint ptr;
1373 
1374         if (needlelen <= selflen) {
1375             if (needlelen <= 32) {
1376                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1377 
1378                 bytes32 needledata;
1379                 assembly { needledata := and(mload(needleptr), mask) }
1380 
1381                 ptr = selfptr + selflen - needlelen;
1382                 bytes32 ptrdata;
1383                 assembly { ptrdata := and(mload(ptr), mask) }
1384 
1385                 while (ptrdata != needledata) {
1386                     if (ptr <= selfptr)
1387                         return selfptr;
1388                     ptr--;
1389                     assembly { ptrdata := and(mload(ptr), mask) }
1390                 }
1391                 return ptr + needlelen;
1392             } else {
1393                 // For long needles, use hashing
1394                 bytes32 hash;
1395                 assembly { hash := keccak256(needleptr, needlelen) }
1396                 ptr = selfptr + (selflen - needlelen);
1397                 while (ptr >= selfptr) {
1398                     bytes32 testHash;
1399                     assembly { testHash := keccak256(ptr, needlelen) }
1400                     if (hash == testHash)
1401                         return ptr + needlelen;
1402                     ptr -= 1;
1403                 }
1404             }
1405         }
1406         return selfptr;
1407     }
1408 
1409     /*
1410      * @dev Modifies `self` to contain everything from the first occurrence of
1411      *      `needle` to the end of the slice. `self` is set to the empty slice
1412      *      if `needle` is not found.
1413      * @param self The slice to search and modify.
1414      * @param needle The text to search for.
1415      * @return `self`.
1416      */
1417     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
1418         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1419         self._len -= ptr - self._ptr;
1420         self._ptr = ptr;
1421         return self;
1422     }
1423 
1424     /*
1425      * @dev Modifies `self` to contain the part of the string from the start of
1426      *      `self` to the end of the first occurrence of `needle`. If `needle`
1427      *      is not found, `self` is set to the empty slice.
1428      * @param self The slice to search and modify.
1429      * @param needle The text to search for.
1430      * @return `self`.
1431      */
1432     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
1433         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1434         self._len = ptr - self._ptr;
1435         return self;
1436     }
1437 
1438     /*
1439      * @dev Splits the slice, setting `self` to everything after the first
1440      *      occurrence of `needle`, and `token` to everything before it. If
1441      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1442      *      and `token` is set to the entirety of `self`.
1443      * @param self The slice to split.
1444      * @param needle The text to search for in `self`.
1445      * @param token An output parameter to which the first token is written.
1446      * @return `token`.
1447      */
1448     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1449         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1450         token._ptr = self._ptr;
1451         token._len = ptr - self._ptr;
1452         if (ptr == self._ptr + self._len) {
1453             // Not found
1454             self._len = 0;
1455         } else {
1456             self._len -= token._len + needle._len;
1457             self._ptr = ptr + needle._len;
1458         }
1459         return token;
1460     }
1461 
1462     /*
1463      * @dev Splits the slice, setting `self` to everything after the first
1464      *      occurrence of `needle`, and returning everything before it. If
1465      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1466      *      and the entirety of `self` is returned.
1467      * @param self The slice to split.
1468      * @param needle The text to search for in `self`.
1469      * @return The part of `self` up to the first occurrence of `delim`.
1470      */
1471     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1472         split(self, needle, token);
1473     }
1474 
1475     /*
1476      * @dev Splits the slice, setting `self` to everything before the last
1477      *      occurrence of `needle`, and `token` to everything after it. If
1478      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1479      *      and `token` is set to the entirety of `self`.
1480      * @param self The slice to split.
1481      * @param needle The text to search for in `self`.
1482      * @param token An output parameter to which the first token is written.
1483      * @return `token`.
1484      */
1485     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1486         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1487         token._ptr = ptr;
1488         token._len = self._len - (ptr - self._ptr);
1489         if (ptr == self._ptr) {
1490             // Not found
1491             self._len = 0;
1492         } else {
1493             self._len -= token._len + needle._len;
1494         }
1495         return token;
1496     }
1497 
1498     /*
1499      * @dev Splits the slice, setting `self` to everything before the last
1500      *      occurrence of `needle`, and returning everything after it. If
1501      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1502      *      and the entirety of `self` is returned.
1503      * @param self The slice to split.
1504      * @param needle The text to search for in `self`.
1505      * @return The part of `self` after the last occurrence of `delim`.
1506      */
1507     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1508         rsplit(self, needle, token);
1509     }
1510 
1511     /*
1512      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1513      * @param self The slice to search.
1514      * @param needle The text to search for in `self`.
1515      * @return The number of occurrences of `needle` found in `self`.
1516      */
1517     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
1518         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1519         while (ptr <= self._ptr + self._len) {
1520             cnt++;
1521             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1522         }
1523     }
1524 
1525     /*
1526      * @dev Returns True if `self` contains `needle`.
1527      * @param self The slice to search.
1528      * @param needle The text to search for in `self`.
1529      * @return True if `needle` is found in `self`, false otherwise.
1530      */
1531     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
1532         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1533     }
1534 
1535     /*
1536      * @dev Returns a newly allocated string containing the concatenation of
1537      *      `self` and `other`.
1538      * @param self The first slice to concatenate.
1539      * @param other The second slice to concatenate.
1540      * @return The concatenation of the two strings.
1541      */
1542     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1543         string memory ret = new string(self._len + other._len);
1544         uint retptr;
1545         assembly { retptr := add(ret, 32) }
1546         memcpy(retptr, self._ptr, self._len);
1547         memcpy(retptr + self._len, other._ptr, other._len);
1548         return ret;
1549     }
1550 
1551     /*
1552      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1553      *      newly allocated string.
1554      * @param self The delimiter to use.
1555      * @param parts A list of slices to join.
1556      * @return A newly allocated string containing all the slices in `parts`,
1557      *         joined with `self`.
1558      */
1559     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1560         if (parts.length == 0)
1561             return "";
1562 
1563         uint length = self._len * (parts.length - 1);
1564         for(uint i = 0; i < parts.length; i++)
1565             length += parts[i]._len;
1566 
1567         string memory ret = new string(length);
1568         uint retptr;
1569         assembly { retptr := add(ret, 32) }
1570 
1571         for(i = 0; i < parts.length; i++) {
1572             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1573             retptr += parts[i]._len;
1574             if (i < parts.length - 1) {
1575                 memcpy(retptr, self._ptr, self._len);
1576                 retptr += self._len;
1577             }
1578         }
1579 
1580         return ret;
1581     }
1582 }
1583 
1584 
1585 contract CarToken is ERC721Token, Ownable {
1586     using strings for *;
1587     
1588     address factory;
1589 
1590     /*
1591     * Car Types:
1592     * 0 - Unknown
1593     * 1 - SUV
1594     * 2 - Truck
1595     * 3 - Hovercraft
1596     * 4 - Tank
1597     * 5 - Lambo
1598     * 6 - Buggy
1599     * 7 - midgrade type 2
1600     * 8 - midgrade type 3
1601     * 9 - Hatchback
1602     * 10 - regular type 2
1603     * 11 - regular type 3
1604     */
1605     uint public constant UNKNOWN_TYPE = 0;
1606     uint public constant SUV_TYPE = 1;
1607     uint public constant TANKER_TYPE = 2;
1608     uint public constant HOVERCRAFT_TYPE = 3;
1609     uint public constant TANK_TYPE = 4;
1610     uint public constant LAMBO_TYPE = 5;
1611     uint public constant DUNE_BUGGY = 6;
1612     uint public constant MIDGRADE_TYPE2 = 7;
1613     uint public constant MIDGRADE_TYPE3 = 8;
1614     uint public constant HATCHBACK = 9;
1615     uint public constant REGULAR_TYPE2 = 10;
1616     uint public constant REGULAR_TYPE3 = 11;
1617     
1618     string public constant METADATA_URL = "https://vault.warriders.com/";
1619     
1620     //Number of premium type cars
1621     uint public PREMIUM_TYPE_COUNT = 5;
1622     //Number of midgrade type cars
1623     uint public MIDGRADE_TYPE_COUNT = 3;
1624     //Number of regular type cars
1625     uint public REGULAR_TYPE_COUNT = 3;
1626 
1627     mapping(uint256 => uint256) public maxBznTankSizeOfPremiumCarWithIndex;
1628     mapping(uint256 => uint256) public maxBznTankSizeOfMidGradeCarWithIndex;
1629     mapping(uint256 => uint256) public maxBznTankSizeOfRegularCarWithIndex;
1630 
1631     /**
1632      * Whether any given car (tokenId) is special
1633      */
1634     mapping(uint256 => bool) public isSpecial;
1635     /**
1636      * The type of any given car (tokenId)
1637      */
1638     mapping(uint256 => uint) public carType;
1639     /**
1640      * The total supply for any given type (int)
1641      */
1642     mapping(uint => uint256) public carTypeTotalSupply;
1643     /**
1644      * The current supply for any given type (int)
1645      */
1646     mapping(uint => uint256) public carTypeSupply;
1647     /**
1648      * Whether any given type (int) is special
1649      */
1650     mapping(uint => bool) public isTypeSpecial;
1651 
1652     /**
1653     * How much BZN any given car (tokenId) can hold
1654     */
1655     mapping(uint256 => uint256) public tankSizes;
1656     
1657     /**
1658      * Given any car type (uint), get the max tank size for that type (uint256)
1659      */
1660     mapping(uint => uint256) public maxTankSizes;
1661     
1662     mapping (uint => uint[]) public premiumTotalSupplyForCar;
1663     mapping (uint => uint[]) public midGradeTotalSupplyForCar;
1664     mapping (uint => uint[]) public regularTotalSupplyForCar;
1665 
1666     modifier onlyFactory {
1667         require(msg.sender == factory, "Not authorized");
1668         _;
1669     }
1670 
1671     constructor(address factoryAddress) public ERC721Token("WarRiders", "WR") {
1672         factory = factoryAddress;
1673 
1674         carTypeTotalSupply[UNKNOWN_TYPE] = 0; //Unknown
1675         carTypeTotalSupply[SUV_TYPE] = 20000; //SUV
1676         carTypeTotalSupply[TANKER_TYPE] = 9000; //Tanker
1677         carTypeTotalSupply[HOVERCRAFT_TYPE] = 600; //Hovercraft
1678         carTypeTotalSupply[TANK_TYPE] = 300; //Tank
1679         carTypeTotalSupply[LAMBO_TYPE] = 100; //Lambo
1680         carTypeTotalSupply[DUNE_BUGGY] = 40000; //migrade type 1
1681         carTypeTotalSupply[MIDGRADE_TYPE2] = 50000; //midgrade type 2
1682         carTypeTotalSupply[MIDGRADE_TYPE3] = 60000; //midgrade type 3
1683         carTypeTotalSupply[HATCHBACK] = 200000; //regular type 1
1684         carTypeTotalSupply[REGULAR_TYPE2] = 300000; //regular type 2
1685         carTypeTotalSupply[REGULAR_TYPE3] = 500000; //regular type 3
1686         
1687         maxTankSizes[SUV_TYPE] = 200; //SUV tank size
1688         maxTankSizes[TANKER_TYPE] = 450; //Tanker tank size
1689         maxTankSizes[HOVERCRAFT_TYPE] = 300; //Hovercraft tank size
1690         maxTankSizes[TANK_TYPE] = 200; //Tank tank size
1691         maxTankSizes[LAMBO_TYPE] = 250; //Lambo tank size
1692         maxTankSizes[DUNE_BUGGY] = 120; //migrade type 1 tank size
1693         maxTankSizes[MIDGRADE_TYPE2] = 110; //midgrade type 2 tank size
1694         maxTankSizes[MIDGRADE_TYPE3] = 100; //midgrade type 3 tank size
1695         maxTankSizes[HATCHBACK] = 90; //regular type 1 tank size
1696         maxTankSizes[REGULAR_TYPE2] = 70; //regular type 2 tank size
1697         maxTankSizes[REGULAR_TYPE3] = 40; //regular type 3 tank size
1698         
1699         maxBznTankSizeOfPremiumCarWithIndex[1] = 200; //SUV tank size
1700         maxBznTankSizeOfPremiumCarWithIndex[2] = 450; //Tanker tank size
1701         maxBznTankSizeOfPremiumCarWithIndex[3] = 300; //Hovercraft tank size
1702         maxBznTankSizeOfPremiumCarWithIndex[4] = 200; //Tank tank size
1703         maxBznTankSizeOfPremiumCarWithIndex[5] = 250; //Lambo tank size
1704         maxBznTankSizeOfMidGradeCarWithIndex[1] = 100; //migrade type 1 tank size
1705         maxBznTankSizeOfMidGradeCarWithIndex[2] = 110; //midgrade type 2 tank size
1706         maxBznTankSizeOfMidGradeCarWithIndex[3] = 120; //midgrade type 3 tank size
1707         maxBznTankSizeOfRegularCarWithIndex[1] = 40; //regular type 1 tank size
1708         maxBznTankSizeOfRegularCarWithIndex[2] = 70; //regular type 2 tank size
1709         maxBznTankSizeOfRegularCarWithIndex[3] = 90; //regular type 3 tank size
1710 
1711         isTypeSpecial[HOVERCRAFT_TYPE] = true;
1712         isTypeSpecial[TANK_TYPE] = true;
1713         isTypeSpecial[LAMBO_TYPE] = true;
1714     }
1715 
1716     function isCarSpecial(uint256 tokenId) public view returns (bool) {
1717         return isSpecial[tokenId];
1718     }
1719 
1720     function getCarType(uint256 tokenId) public view returns (uint) {
1721         return carType[tokenId];
1722     }
1723 
1724     function mint(uint256 _tokenId, string _metadata, uint cType, uint256 tankSize, address newOwner) public onlyFactory {
1725         //Since any invalid car type would have a total supply of 0 
1726         //This require will also enforce that a valid cType is given
1727         require(carTypeSupply[cType] < carTypeTotalSupply[cType], "This type has reached total supply");
1728         
1729         //This will enforce the tank size is less than the max
1730         require(tankSize <= maxTankSizes[cType], "Tank size provided bigger than max for this type");
1731         
1732         if (isPremium(cType)) {
1733             premiumTotalSupplyForCar[cType].push(_tokenId);
1734         } else if (isMidGrade(cType)) {
1735             midGradeTotalSupplyForCar[cType].push(_tokenId);
1736         } else {
1737             regularTotalSupplyForCar[cType].push(_tokenId);
1738         }
1739 
1740         super._mint(newOwner, _tokenId);
1741         super._setTokenURI(_tokenId, _metadata);
1742 
1743         carType[_tokenId] = cType;
1744         isSpecial[_tokenId] = isTypeSpecial[cType];
1745         carTypeSupply[cType] = carTypeSupply[cType] + 1;
1746         tankSizes[_tokenId] = tankSize;
1747     }
1748     
1749     function isPremium(uint cType) public pure returns (bool) {
1750         return cType == SUV_TYPE || cType == TANKER_TYPE || cType == HOVERCRAFT_TYPE || cType == TANK_TYPE || cType == LAMBO_TYPE;
1751     }
1752     
1753     function isMidGrade(uint cType) public pure returns (bool) {
1754         return cType == DUNE_BUGGY || cType == MIDGRADE_TYPE2 || cType == MIDGRADE_TYPE3;
1755     }
1756     
1757     function isRegular(uint cType) public pure returns (bool) {
1758         return cType == HATCHBACK || cType == REGULAR_TYPE2 || cType == REGULAR_TYPE3;
1759     }
1760     
1761     function getTotalSupplyForType(uint cType) public view returns (uint256) {
1762         return carTypeSupply[cType];
1763     }
1764     
1765     function getPremiumCarsForVariant(uint variant) public view returns (uint[]) {
1766         return premiumTotalSupplyForCar[variant];
1767     }
1768     
1769     function getMidgradeCarsForVariant(uint variant) public view returns (uint[]) {
1770         return midGradeTotalSupplyForCar[variant];
1771     }
1772 
1773     function getRegularCarsForVariant(uint variant) public view returns (uint[]) {
1774         return regularTotalSupplyForCar[variant];
1775     }
1776 
1777     function getPremiumCarSupply(uint variant) public view returns (uint) {
1778         return premiumTotalSupplyForCar[variant].length;
1779     }
1780     
1781     function getMidgradeCarSupply(uint variant) public view returns (uint) {
1782         return midGradeTotalSupplyForCar[variant].length;
1783     }
1784 
1785     function getRegularCarSupply(uint variant) public view returns (uint) {
1786         return regularTotalSupplyForCar[variant].length;
1787     }
1788     
1789     function exists(uint256 _tokenId) public view returns (bool) {
1790         return super._exists(_tokenId);
1791     }
1792 }