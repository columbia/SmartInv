1 pragma solidity ^0.4.24;
2 
3 /**
4  * @author Part of Freaking Awesome Blockchain Games project. Copyright by FABG Team 2018
5  */
6 
7 
8 
9 /**
10  * Utility library of inline functions on addresses
11  */
12 library AddressUtils {
13 
14   /**
15    * Returns whether the target address is a contract
16    * @dev This function will return false if invoked during the constructor of a contract,
17    * as the code is not actually created until after the constructor finishes.
18    * @param _addr address to check
19    * @return whether the target address is a contract
20    */
21   function isContract(address _addr) internal view returns (bool) {
22     uint256 size;
23     // XXX Currently there is no better way to check if there is a contract in an address
24     // than to check the size of the code at that address.
25     // See https://ethereum.stackexchange.com/a/14016/36603
26     // for more details about how this works.
27     // TODO Check this again before the Serenity release, because all addresses will be
28     // contracts then.
29     // solium-disable-next-line security/no-inline-assembly
30     assembly { size := extcodesize(_addr) }
31     return size > 0;
32   }
33 
34 }
35 
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, throws on overflow.
40   */
41   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
42     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (_a == 0) {
46       return 0;
47     }
48 
49     c = _a * _b;
50     assert(c / _a == _b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     // assert(_b > 0); // Solidity automatically throws when dividing by 0
59     // uint256 c = _a / _b;
60     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
61     return _a / _b;
62   }
63 
64   /**
65   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
68     assert(_b <= _a);
69     return _a - _b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
76     c = _a + _b;
77     assert(c >= _a);
78     return c;
79   }
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88   address public owner;
89 
90 
91   event OwnershipRenounced(address previousOwner);
92   event OwnershipTransferred(
93     address previousOwner,
94     address newOwner
95   );
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   constructor() public {
103     owner = msg.sender;
104   }
105 
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114   /**
115    * @dev Allows the current owner to relinquish control of the contract.
116    * @notice Renouncing to ownership will leave the contract without an owner.
117    * It will not be possible to call the functions with the `onlyOwner`
118    * modifier anymore.
119    */
120   function renounceOwnership() public onlyOwner {
121     emit OwnershipRenounced(owner);
122     owner = address(0);
123   }
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param _newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address _newOwner) public onlyOwner {
130     _transferOwnership(_newOwner);
131   }
132 
133   /**
134    * @dev Transfers control of the contract to a newOwner.
135    * @param _newOwner The address to transfer ownership to.
136    */
137   function _transferOwnership(address _newOwner) internal {
138     require(_newOwner != address(0));
139     emit OwnershipTransferred(owner, _newOwner);
140     owner = _newOwner;
141   }
142 }
143 
144 /**
145  * @title ERC721 token receiver interface
146  * @dev Interface for any contract that wants to support safeTransfers
147  * from ERC721 asset contracts.
148  */
149 contract ERC721Receiver {
150   /**
151    * @dev Magic value to be returned upon successful reception of an NFT
152    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
153    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
154    */
155   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
156 
157   /**
158    * @notice Handle the receipt of an NFT
159    * @dev The ERC721 smart contract calls this function on the recipient
160    * after a `safetransfer`. This function MAY throw to revert and reject the
161    * transfer. Return of other than the magic value MUST result in the
162    * transaction being reverted.
163    * Note: the contract address is always the message sender.
164    * @param _operator The address which called `safeTransferFrom` function
165    * @param _from The address which previously owned the token
166    * @param _tokenId The NFT identifier which is being transferred
167    * @param _data Additional data with no specified format
168    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
169    */
170   function onERC721Received(
171     address _operator,
172     address _from,
173     uint256 _tokenId,
174     bytes _data
175   )
176     public
177     returns(bytes4);
178 }
179 
180 interface ERC165 {
181 
182   /**
183    * @notice Query if a contract implements an interface
184    * @param _interfaceId The interface identifier, as specified in ERC-165
185    * @dev Interface identification is specified in ERC-165. This function
186    * uses less than 30,000 gas.
187    */
188   function supportsInterface(bytes4 _interfaceId)
189     external
190     view
191     returns (bool);
192 }
193 
194 contract ERC721Basic is ERC165 {
195 
196   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
197   /*
198    * 0x80ac58cd ===
199    *   bytes4(keccak256('balanceOf(address)')) ^
200    *   bytes4(keccak256('ownerOf(uint256)')) ^
201    *   bytes4(keccak256('approve(address,uint256)')) ^
202    *   bytes4(keccak256('getApproved(uint256)')) ^
203    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
204    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
205    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
206    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
207    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
208    */
209 
210   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
211   /*
212    * 0x4f558e79 ===
213    *   bytes4(keccak256('exists(uint256)'))
214    */
215 
216   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
217   /**
218    * 0x780e9d63 ===
219    *   bytes4(keccak256('totalSupply()')) ^
220    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
221    *   bytes4(keccak256('tokenByIndex(uint256)'))
222    */
223 
224   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
225   /**
226    * 0x5b5e139f ===
227    *   bytes4(keccak256('name()')) ^
228    *   bytes4(keccak256('symbol()')) ^
229    *   bytes4(keccak256('tokenURI(uint256)'))
230    */
231 
232   event Transfer(
233     address _from,
234     address _to,
235     uint256 _tokenId
236   );
237   event Approval(
238     address _owner,
239     address _approved,
240     uint256 _tokenId
241   );
242   event ApprovalForAll(
243     address _owner,
244     address _operator,
245     bool _approved
246   );
247 
248   function balanceOf(address _owner) public view returns (uint256 _balance);
249   function ownerOf(uint256 _tokenId) public view returns (address _owner);
250   function exists(uint256 _tokenId) public view returns (bool _exists);
251 
252   function approve(address _to, uint256 _tokenId) public;
253   function getApproved(uint256 _tokenId)
254     public view returns (address _operator);
255 
256   function setApprovalForAll(address _operator, bool _approved) public;
257   function isApprovedForAll(address _owner, address _operator)
258     public view returns (bool);
259 
260   function transferFrom(address _from, address _to, uint256 _tokenId) public;
261   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
262     public;
263 
264   function safeTransferFrom(
265     address _from,
266     address _to,
267     uint256 _tokenId,
268     bytes _data
269   )
270     public;
271 }
272 
273 contract ERC721Enumerable is ERC721Basic {
274   function totalSupply() public view returns (uint256);
275   function tokenOfOwnerByIndex(
276     address _owner,
277     uint256 _index
278   )
279     public
280     view
281     returns (uint256 _tokenId);
282 
283   function tokenByIndex(uint256 _index) public view returns (uint256);
284 }
285 
286 contract SupportsInterfaceWithLookup is ERC165 {
287 
288   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
289   /**
290    * 0x01ffc9a7 ===
291    *   bytes4(keccak256('supportsInterface(bytes4)'))
292    */
293 
294   /**
295    * @dev a mapping of interface id to whether or not it's supported
296    */
297   mapping(bytes4 => bool) internal supportedInterfaces;
298 
299   /**
300    * @dev A contract implementing SupportsInterfaceWithLookup
301    * implement ERC165 itself
302    */
303   constructor()
304     public
305   {
306     _registerInterface(InterfaceId_ERC165);
307   }
308 
309   /**
310    * @dev implement supportsInterface(bytes4) using a lookup table
311    */
312   function supportsInterface(bytes4 _interfaceId)
313     external
314     view
315     returns (bool)
316   {
317     return supportedInterfaces[_interfaceId];
318   }
319 
320   /**
321    * @dev private method for registering an interface
322    */
323   function _registerInterface(bytes4 _interfaceId)
324     internal
325   {
326     require(_interfaceId != 0xffffffff);
327     supportedInterfaces[_interfaceId] = true;
328   }
329 }
330 
331 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
332   using SafeMath for uint256;
333   using AddressUtils for address;
334 
335   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
336   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
337   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
338 
339   bool public isPaused = false;
340   // Mapping from token ID to owner
341   mapping (uint256 => address) internal tokenOwner;
342 
343   // Mapping from token ID to approved address
344   mapping (uint256 => address) internal tokenApprovals;
345 
346   // Mapping from owner to number of owned token
347   mapping (address => uint256) internal ownedTokensCount;
348 
349   // Mapping from owner to operator approvals
350   mapping (address => mapping (address => bool)) internal operatorApprovals;
351 
352   address public saleAgent = 0x0;
353 
354   uint256 public numberOfTokens;
355 
356   constructor() public {
357     // register the supported interfaces to conform to ERC721 via ERC165
358     _registerInterface(InterfaceId_ERC721);
359     _registerInterface(InterfaceId_ERC721Exists);
360   }
361 
362   /**
363    * @dev Gets the balance of the specified address
364    * @param _owner address to query the balance of
365    * @return uint256 representing the amount owned by the passed address
366    */
367   function balanceOf(address _owner) public view returns (uint256) {
368     require(_owner != address(0), "owner couldn't be 0x0");
369     return ownedTokensCount[_owner];
370   }
371 
372   /**
373    * @dev Gets the owner of the specified token ID
374    * @param _tokenId uint256 ID of the token to query the owner of
375    * @return owner address currently marked as the owner of the given token ID
376    */
377   function ownerOf(uint256 _tokenId) public view returns (address) {
378     address owner = tokenOwner[_tokenId];
379     require(owner != address(0), "owner couldn't be 0x0");
380     return owner;
381   }
382 
383   /**
384    * @dev Returns whether the specified token exists
385    * @param _tokenId uint256 ID of the token to query the existence of
386    * @return whether the token exists
387    */
388   function exists(uint256 _tokenId) public view returns (bool) {
389     address owner = tokenOwner[_tokenId];
390     return owner != address(0);
391   }
392 
393   /**
394    * @dev Approves another address to transfer the given token ID
395    * The zero address indicates there is no approved address.
396    * There can only be one approved address per token at a given time.
397    * Can only be called by the token owner or an approved operator.
398    * @param _to address to be approved for the given token ID
399    * @param _tokenId uint256 ID of the token to be approved
400    */
401   function approve(address _to, uint256 _tokenId) public {
402     require(isPaused == false, "transactions on pause");    
403     address owner = ownerOf(_tokenId);
404     require(_to != owner, "can't approve to yourself");
405     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
406 
407     tokenApprovals[_tokenId] = _to;
408     emit Approval(owner, _to, _tokenId);
409   }
410 
411   /**
412    * @dev Gets the approved address for a token ID, or zero if no address set
413    * @param _tokenId uint256 ID of the token to query the approval of
414    * @return address currently approved for the given token ID
415    */
416   function getApproved(uint256 _tokenId) public view returns (address) {
417     return tokenApprovals[_tokenId];
418   }
419 
420   /**
421    * @dev Sets or unsets the approval of a given operator
422    * An operator is allowed to transfer all tokens of the sender on their behalf
423    * @param _to operator address to set the approval
424    * @param _approved representing the status of the approval to be set
425    */
426   function setApprovalForAll(address _to, bool _approved) public {
427     require(_to != msg.sender, "can't send to yourself");
428     require(isPaused == false, "transactions on pause");
429     operatorApprovals[msg.sender][_to] = _approved;
430     emit ApprovalForAll(msg.sender, _to, _approved);
431   }
432 
433   /**
434    * @dev Tells whether an operator is approved by a given owner
435    * @param _owner owner address which you want to query the approval of
436    * @param _operator operator address which you want to query the approval of
437    * @return bool whether the given operator is approved by the given owner
438    */
439   function isApprovedForAll(
440     address _owner,
441     address _operator
442   )
443     public
444     view
445     returns (bool)
446   {
447     return operatorApprovals[_owner][_operator];
448   }
449 
450   /**
451    * @dev Transfers the ownership of a given token ID to another address
452    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
453    * Requires the msg sender to be the owner, approved, or operator
454    * @param _from current owner of the token
455    * @param _to address to receive the ownership of the given token ID
456    * @param _tokenId uint256 ID of the token to be transferred
457   */
458   function transferFrom(
459     address _from,
460     address _to,
461     uint256 _tokenId
462   )
463     public
464   {
465     require(isPaused == false, "transactions on pause");
466     require(isApprovedOrOwner(msg.sender, _tokenId) || msg.sender == saleAgent);
467     require(_from != address(0), "sender can't be 0x0");
468     require(_to != address(0), "receiver can't be 0x0");
469 
470     clearApproval(_from, _tokenId);
471     removeTokenFrom(_from, _tokenId);
472     addTokenTo(_to, _tokenId);
473 
474     emit Transfer(_from, _to, _tokenId);
475   }
476 
477   /**
478    * @dev Safely transfers the ownership of a given token ID to another address
479    * If the target address is a contract, it must implement `onERC721Received`,
480    * which is called upon a safe transfer, and return the magic value
481    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
482    * the transfer is reverted.
483    *
484    * Requires the msg sender to be the owner, approved, or operator
485    * @param _from current owner of the token
486    * @param _to address to receive the ownership of the given token ID
487    * @param _tokenId uint256 ID of the token to be transferred
488   */
489   function safeTransferFrom(
490     address _from,
491     address _to,
492     uint256 _tokenId
493   )
494     public
495   {
496     // solium-disable-next-line arg-overflow
497     safeTransferFrom(_from, _to, _tokenId, "");
498   }
499 
500   /**
501    * @dev Safely transfers the ownership of a given token ID to another address
502    * If the target address is a contract, it must implement `onERC721Received`,
503    * which is called upon a safe transfer, and return the magic value
504    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
505    * the transfer is reverted.
506    * Requires the msg sender to be the owner, approved, or operator
507    * @param _from current owner of the token
508    * @param _to address to receive the ownership of the given token ID
509    * @param _tokenId uint256 ID of the token to be transferred
510    * @param _data bytes data to send along with a safe transfer check
511    */
512   function safeTransferFrom(
513     address _from,
514     address _to,
515     uint256 _tokenId,
516     bytes _data
517   )
518     public
519   {
520     transferFrom(_from, _to, _tokenId);
521     // solium-disable-next-line arg-overflow
522     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
523   }
524 
525   /**
526    * @dev Returns whether the given spender can transfer a given token ID
527    * @param _spender address of the spender to query
528    * @param _tokenId uint256 ID of the token to be transferred
529    * @return bool whether the msg.sender is approved for the given token ID,
530    *  is an operator of the owner, or is the owner of the token
531    */
532   function isApprovedOrOwner(
533     address _spender,
534     uint256 _tokenId
535   )
536     internal
537     view
538     returns (bool)
539   {
540     address owner = ownerOf(_tokenId);
541     // Disable solium check because of
542     // https://github.com/duaraghav8/Solium/issues/175
543     // solium-disable-next-line operator-whitespace
544     return (
545       _spender == owner ||
546       getApproved(_tokenId) == _spender ||
547       isApprovedForAll(owner, _spender)
548     );
549   }
550 
551   /**
552    * @dev Internal function to mint a new token
553    * Reverts if the given token ID already exists
554    * @param _to The address that will own the minted token
555    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
556    */
557   function _mint(address _to, uint256 _tokenId) internal {
558     require(_to != address(0));
559     addTokenTo(_to, _tokenId);
560     numberOfTokens++;
561     emit Transfer(address(0), _to, _tokenId);
562   }
563 
564   /**
565    * @dev Internal function to burn a specific token
566    * Reverts if the token does not exist
567    * @param _tokenId uint256 ID of the token being burned by the msg.sender
568    */
569   function _burn(address _owner, uint256 _tokenId) internal {
570     clearApproval(_owner, _tokenId);
571     removeTokenFrom(_owner, _tokenId);
572     emit Transfer(_owner, address(0), _tokenId);
573   }
574 
575   /**
576    * @dev Internal function to clear current approval of a given token ID
577    * Reverts if the given address is not indeed the owner of the token
578    * @param _owner owner of the token
579    * @param _tokenId uint256 ID of the token to be transferred
580    */
581   function clearApproval(address _owner, uint256 _tokenId) internal {
582     require(ownerOf(_tokenId) == _owner);
583     if (tokenApprovals[_tokenId] != address(0)) {
584       tokenApprovals[_tokenId] = address(0);
585     }
586   }
587 
588   /**
589    * @dev Internal function to add a token ID to the list of a given address
590    * @param _to address representing the new owner of the given token ID
591    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
592    */
593   function addTokenTo(address _to, uint256 _tokenId) internal {
594     require(tokenOwner[_tokenId] == address(0));
595     tokenOwner[_tokenId] = _to;
596     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
597   }
598 
599   /**
600    * @dev Internal function to remove a token ID from the list of a given address
601    * @param _from address representing the previous owner of the given token ID
602    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
603    */
604   function removeTokenFrom(address _from, uint256 _tokenId) internal {
605     require(ownerOf(_tokenId) == _from);
606     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
607     tokenOwner[_tokenId] = address(0);
608   }
609 
610   /**
611    * @dev Internal function to invoke `onERC721Received` on a target address
612    * The call is not executed if the target address is not a contract
613    * @param _from address representing the previous owner of the given token ID
614    * @param _to target address that will receive the tokens
615    * @param _tokenId uint256 ID of the token to be transferred
616    * @param _data bytes optional data to send along with the call
617    * @return whether the call correctly returned the expected magic value
618    */
619   function checkAndCallSafeTransfer(
620     address _from,
621     address _to,
622     uint256 _tokenId,
623     bytes _data
624   )
625     internal
626     returns (bool)
627   {
628     if (!_to.isContract() || _to == saleAgent) {
629       return true;
630     }
631     bytes4 retval = ERC721Receiver(_to).onERC721Received(
632       msg.sender, _from, _tokenId, _data);
633     return (retval == ERC721_RECEIVED);
634   }
635 }
636 
637 /**
638  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
639  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
640  */
641 contract ERC721Metadata is ERC721Basic {
642   function name() external view returns (string _name);
643   function symbol() external view returns (string _symbol);
644   function tokenURI(uint256 _tokenId) public view returns (string);
645 }
646 
647 
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
650  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
651  */
652 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
653 }
654 
655 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
656 
657   // Token name
658   string internal name_;
659 
660   // Token symbol
661   string internal symbol_;
662 
663   // Mapping from owner to list of owned token IDs
664   mapping(address => uint256[]) internal ownedTokens;
665 
666   // Mapping from token ID to index of the owner tokens list
667   mapping(uint256 => uint256) internal ownedTokensIndex;
668 
669   // Array with all token ids, used for enumeration
670   uint256[] internal allTokens;
671 
672   // Mapping from token id to position in the allTokens array
673   mapping(uint256 => uint256) internal allTokensIndex;
674 
675   // Optional mapping for token URIs
676   mapping(uint256 => string) internal tokenURIs;
677 
678   /**
679    * @dev Constructor function
680    */
681    constructor(string _name, string _symbol) public {
682     name_ = _name;
683     symbol_ = _symbol;
684 
685     // register the supported interfaces to conform to ERC721 via ERC165
686     _registerInterface(InterfaceId_ERC721Enumerable);
687     _registerInterface(InterfaceId_ERC721Metadata);
688   }
689 
690   /**
691    * @dev Gets the token name
692    * @return string representing the token name
693    */
694   function name() external view returns (string) {
695     return name_;
696   }
697 
698   /**
699    * @dev Gets the token symbol
700    * @return string representing the token symbol
701    */
702   function symbol() external view returns (string) {
703     return symbol_;
704   }
705 
706   /**
707    * @dev Returns an URI for a given token ID
708    * Throws if the token ID does not exist. May return an empty string.
709    * @param _tokenId uint256 ID of the token to query
710    */
711   function tokenURI(uint256 _tokenId) public view returns (string) {
712     require(exists(_tokenId));
713     return tokenURIs[_tokenId];
714   }
715 
716   /**
717    * @dev Gets the token ID at a given index of the tokens list of the requested owner
718    * @param _owner address owning the tokens list to be accessed
719    * @param _index uint256 representing the index to be accessed of the requested tokens list
720    * @return uint256 token ID at the given index of the tokens list owned by the requested address
721    */
722   function tokenOfOwnerByIndex(
723     address _owner,
724     uint256 _index
725   )
726     public
727     view
728     returns (uint256)
729   {
730     require(_index < balanceOf(_owner));
731     return ownedTokens[_owner][_index];
732   }
733 
734   /**
735    * @dev Gets the total amount of tokens stored by the contract
736    * @return uint256 representing the total amount of tokens
737    */
738   function totalSupply() public view returns (uint256) {
739     return allTokens.length;
740   }
741 
742   /**
743    * @dev Gets the token ID at a given index of all the tokens in this contract
744    * Reverts if the index is greater or equal to the total number of tokens
745    * @param _index uint256 representing the index to be accessed of the tokens list
746    * @return uint256 token ID at the given index of the tokens list
747    */
748   function tokenByIndex(uint256 _index) public view returns (uint256) {
749     require(_index < totalSupply());
750     return allTokens[_index];
751   }
752 
753   /**
754    * @dev Internal function to set the token URI for a given token
755    * Reverts if the token ID does not exist
756    * @param _tokenId uint256 ID of the token to set its URI
757    * @param _uri string URI to assign
758    */
759   function _setTokenURI(uint256 _tokenId, string _uri) internal {
760     require(exists(_tokenId));
761     tokenURIs[_tokenId] = _uri;
762   }
763 
764   /**
765    * @dev Internal function to add a token ID to the list of a given address
766    * @param _to address representing the new owner of the given token ID
767    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
768    */
769   function addTokenTo(address _to, uint256 _tokenId) internal {
770     super.addTokenTo(_to, _tokenId);
771     uint256 length = ownedTokens[_to].length;
772     ownedTokens[_to].push(_tokenId);
773     ownedTokensIndex[_tokenId] = length;
774   }
775 
776   /**
777    * @dev Internal function to remove a token ID from the list of a given address
778    * @param _from address representing the previous owner of the given token ID
779    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
780    */
781   function removeTokenFrom(address _from, uint256 _tokenId) internal {
782     super.removeTokenFrom(_from, _tokenId);
783 
784     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
785     // then delete the last slot.
786     uint256 tokenIndex = ownedTokensIndex[_tokenId];
787     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
788     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
789 
790     ownedTokens[_from][tokenIndex] = lastToken;
791     // This also deletes the contents at the last position of the array
792     ownedTokens[_from].length--;
793 
794     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
795     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
796     // the lastToken to the first position, and then dropping the element placed in the last position of the list
797 
798     ownedTokensIndex[_tokenId] = 0;
799     ownedTokensIndex[lastToken] = tokenIndex;
800   }
801 
802   /**
803    * @dev Internal function to mint a new token
804    * Reverts if the given token ID already exists
805    * @param _to address the beneficiary that will own the minted token
806    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
807    */
808   function _mint(address _to, uint256 _tokenId) internal {
809     super._mint(_to, _tokenId);
810 
811     allTokensIndex[_tokenId] = allTokens.length;
812     allTokens.push(_tokenId);
813   }
814 
815   /**
816    * @dev Internal function to burn a specific token
817    * Reverts if the token does not exist
818    * @param _owner owner of the token to burn
819    * @param _tokenId uint256 ID of the token being burned by the msg.sender
820    */
821   function _burn(address _owner, uint256 _tokenId) internal {
822     super._burn(_owner, _tokenId);
823 
824     // Clear metadata (if any)
825     if (bytes(tokenURIs[_tokenId]).length != 0) {
826       delete tokenURIs[_tokenId];
827     }
828 
829     // Reorg all tokens array
830     uint256 tokenIndex = allTokensIndex[_tokenId];
831     uint256 lastTokenIndex = allTokens.length.sub(1);
832     uint256 lastToken = allTokens[lastTokenIndex];
833 
834     allTokens[tokenIndex] = lastToken;
835     allTokens[lastTokenIndex] = 0;
836 
837     allTokens.length--;
838     allTokensIndex[_tokenId] = 0;
839     allTokensIndex[lastToken] = tokenIndex;
840   }
841 
842 }
843 
844 contract FabgToken is ERC721Token, Ownable {
845     struct data {
846         tokenType typeOfToken;
847         bytes32 name;
848         bytes32 url;
849         bool isSnatchable;
850     }
851     
852     mapping(uint256 => data) internal tokens;
853     mapping(uint256 => uint256) internal pricesForIncreasingAuction;
854     
855     address presale;
856 
857     enum tokenType{MASK, LAND}
858     
859     event TokenCreated(
860         address Receiver, 
861         tokenType Type, 
862         bytes32 Name, 
863         bytes32 URL, 
864         uint256 TokenId, 
865         bool IsSnatchable
866     );
867     event TokenChanged(
868         address Receiver, 
869         tokenType Type, 
870         bytes32 Name, 
871         bytes32 URL, 
872         uint256 TokenId, 
873         bool IsSnatchable
874     );
875     event Paused();
876     event Unpaused();
877     
878     modifier onlySaleAgent {
879         require(msg.sender == saleAgent);
880         _;
881     }
882     
883     /**
884      * @dev constructor which calling parent's constructor with params
885      */
886     constructor() ERC721Token("FABGToken", "FABG") public {
887     }
888 
889     /**
890      * @dev fallback function which can't receive ether
891      */
892     function() public payable {
893         revert();
894     }
895 
896     /**
897      * @dev onlyOwner func for stopping all operations with contract
898      */ 
899     function setPauseForAll() public onlyOwner {
900         require(isPaused == false, "transactions on pause");
901         isPaused = true;
902         PreSale(saleAgent).setPauseForAll();
903 
904         emit Paused();
905     }
906 
907     /**
908      * @dev onlyOwner func for unpausing all operations with contract
909      */ 
910     function setUnpauseForAll() public onlyOwner {
911         require(isPaused == true, "transactions isn't on pause");
912         isPaused = false;
913         PreSale(saleAgent).setUnpauseForAll();
914 
915         emit Unpaused();
916     }
917 
918     /**
919      * @dev setting the address of contract which can get tokens from users wallets
920      * @param _saleAgent address of contract of auction
921      */
922     function setSaleAgent(address _saleAgent) public onlyOwner {
923         saleAgent = _saleAgent;
924     }
925     
926     /**
927      * @dev process of creation of card 
928      * @param _receiver address of token receiver
929      * @param _type type of token from enum
930      * @param _name bytes32 name of token
931      * @param _url bytes32 url of token
932      * @param _isSnatchable type of market for trading
933      */
934     function adminsTokenCreation(address _receiver, uint256 _price, tokenType _type, bytes32 _name, bytes32 _url, bool _isSnatchable) public onlyOwner {
935         tokenCreation(_receiver, _price, _type, _name, _url, _isSnatchable);
936     }
937 
938     /**
939      * @dev process of creation of card 
940      * @param _receiver address of token receiver
941      * @param _type type of token from enum
942      * @param _name bytes32 name of token
943      * @param _url bytes32 url of token
944      * @param _isSnatchable type of market for trading
945      */
946     function tokenCreation(address _receiver, uint256 _price, tokenType _type, bytes32 _name, bytes32 _url, bool _isSnatchable) internal {
947         require(isPaused == false, "transactions on pause");
948         uint256 tokenId = totalSupply();
949         
950         data memory info = data(_type, _name, _url, _isSnatchable);
951         tokens[tokenId] = info;
952         
953         if(_isSnatchable == true) {
954             pricesForIncreasingAuction[tokenId] = _price;
955         }
956         
957         _mint(_receiver, tokenId);
958 
959         emit TokenCreated(_receiver, _type, _name, _url, tokenId, _isSnatchable);
960     }
961 
962     /**
963      * @dev convert string to bytes32 and revert it if length was more than 32
964      * @param source current string for convertion
965      * @return bytes32 result of string convertation
966      */
967     function stringToBytes32(string memory source) public pure returns (bytes32 result) {
968         require(bytes(source).length <= 32, "too high length of source");
969         bytes memory tempEmptyStringTest = bytes(source);
970         if (tempEmptyStringTest.length == 0) {
971             return 0x0;
972         }
973 
974         assembly {
975             result := mload(add(source, 32))
976         }
977     }
978 
979     /**
980      * @dev convert bytes32 to string and revert it if length was more than 32
981      * @param x current bytes for convertion
982      * @return string result of bytes32 convertation
983      */
984     function bytes32ToString(bytes32 x) public pure returns (string) {
985         bytes memory bytesString = new bytes(32);
986         uint charCount = 0;
987         for (uint j = 0; j < 32; j++) {
988             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
989             if (char != 0) {
990                 bytesString[charCount] = char;
991                 charCount++;
992             }
993         }
994         bytes memory bytesStringTrimmed = new bytes(charCount);
995         for (j = 0; j < charCount; j++) {
996             bytesStringTrimmed[j] = bytesString[j];
997         }
998         return string(bytesStringTrimmed);
999     }
1000 
1001     /**
1002      * @dev token info by Id
1003      * @param _tokenId Id of token
1004      * @return typeOfToken index of enum
1005      * @return name bytes32 name of token
1006      * @return URL bytes32 URL of token
1007      * @return isSnatchable type of auction
1008      */
1009     function getTokenById(uint256 _tokenId) public view returns (
1010         tokenType typeOfToken, 
1011         bytes32 name, 
1012         bytes32 URL, 
1013         bool isSnatchable
1014     ) {
1015         typeOfToken = tokens[_tokenId].typeOfToken;
1016         name = tokens[_tokenId].name;
1017         URL = tokens[_tokenId].url;
1018         isSnatchable = tokens[_tokenId].isSnatchable;
1019     }
1020         
1021     /**
1022      * @dev token price for increasing auction
1023      * @param _tokenId Id of token for selling
1024      * @return uint256 price in Wei
1025      */
1026     function getTokenPriceForIncreasing(uint256 _tokenId) public view returns (uint256) {
1027         require(tokens[_tokenId].isSnatchable == true);
1028 
1029         return pricesForIncreasingAuction[_tokenId];
1030     }
1031 
1032     /**
1033      * @dev list of tokens of user
1034      * @param _owner address of user
1035      * @return uint256[] array of token's ID which are belomg to user
1036      */
1037     function allTokensOfUsers(address _owner) public view returns(uint256[]) {
1038         return ownedTokens[_owner];
1039     }
1040     
1041     /**
1042      * @dev store information about presale contract
1043      * @param _presale address of presale contract
1044      */ 
1045     function setPresaleAddress(address _presale) public onlyOwner {
1046         presale = _presale;
1047     }
1048 
1049     /**
1050      * @dev process of changing information of card 
1051      * @param _receiver address of token receiver
1052      * @param _type type of token from enum
1053      * @param _name bytes32 name of token
1054      * @param _url bytes32 url of token
1055      * @param _isSnatchable type of market for trading
1056      */    
1057     function rewriteTokenFromPresale(
1058         uint256 _tokenId,
1059         address _receiver, 
1060         uint256 _price, 
1061         tokenType _type, 
1062         bytes32 _name, 
1063         bytes32 _url, 
1064         bool _isSnatchable
1065     ) public onlyOwner {
1066         require(ownerOf(_tokenId) == presale);
1067         data memory info = data(_type, _name, _url, _isSnatchable);
1068         tokens[_tokenId] = info;
1069         
1070         if(_isSnatchable == true) {
1071             pricesForIncreasingAuction[_tokenId] = _price;
1072         }
1073         
1074         emit TokenChanged(_receiver, _type, _name, _url, _tokenId, _isSnatchable);
1075     }
1076 }
1077 contract PreSale is Ownable {
1078     using SafeMath for uint;
1079     
1080     FabgToken token;
1081     /**
1082      * @notice address of wallet for comission payment. can be hardcoded
1083      */
1084     address adminsWallet;
1085     bool public isPaused;
1086     uint256 totalMoney;
1087     
1088     event TokenBought(address Buyer, uint256 tokenID, uint256 price);
1089     event Payment(address payer, uint256 weiAmount);
1090     event Withdrawal(address receiver, uint256 weiAmount);
1091     
1092     modifier onlyToken() {
1093         require(msg.sender == address(token), "called not from token");
1094         _;
1095     }
1096 
1097     /**
1098      * @dev setted address of token contract and wallet where will be eth in withdrawal
1099      * @param _tokenAddress address of token
1100      * @param _walletForEth address for receiving payments
1101      */
1102     constructor(FabgToken _tokenAddress, address _walletForEth) public {
1103         token = _tokenAddress;
1104         adminsWallet = _walletForEth;
1105     }
1106     
1107     /**
1108      * @dev fallback function which can receive ether with no actions
1109      */
1110     function() public payable {
1111        emit Payment(msg.sender, msg.value);
1112     }
1113     
1114     /**
1115      * @dev only token func for stopping all operations with contract
1116      */ 
1117     function setPauseForAll() public onlyToken {
1118         require(isPaused == false, "transactions on pause");
1119         isPaused = true;
1120     }
1121 
1122     /**
1123      * @dev only token func for unpausing all operations with contract
1124      */ 
1125     function setUnpauseForAll() public onlyToken {
1126         require(isPaused == true, "transactions on pause");
1127         isPaused = false;
1128     }   
1129     
1130     /**
1131      * @dev buy token, owner of which is market. contract will send back change
1132      * @param _tokenId id of token for buying
1133      */
1134     function buyToken(uint256 _tokenId) public payable {
1135         require(isPaused == false, "transactions on pause");
1136         require(token.exists(_tokenId), "token doesn't exist");
1137         require(token.ownerOf(_tokenId) == address(this), "contract isn't owner of token");
1138         require(msg.value >= token.getTokenPriceForIncreasing(_tokenId), "was sent not enough ether");
1139         
1140         token.transferFrom(address(this), msg.sender, _tokenId);
1141         (msg.sender).transfer(msg.value.sub(token.getTokenPriceForIncreasing(_tokenId)));
1142         
1143         totalMoney = totalMoney.add(token.getTokenPriceForIncreasing(_tokenId));
1144 
1145         emit TokenBought(msg.sender, _tokenId, token.getTokenPriceForIncreasing(_tokenId));
1146     }
1147 
1148     /**
1149      * @dev set address for wallet for withdrawal
1150      * @param _newMultisig new address for withdrawal
1151      */
1152     function setAddressForPayment(address _newMultisig) public onlyOwner {
1153         adminsWallet = _newMultisig;
1154     }    
1155     
1156     /**
1157      * @dev withdraw all ether from this contract to sender's wallet
1158      */
1159     function withdraw() public onlyOwner {
1160         require(adminsWallet != address(0), "admins wallet couldn't be 0x0");
1161 
1162         uint256 amount = address(this).balance;  
1163         (adminsWallet).transfer(amount);
1164         emit Withdrawal(adminsWallet, amount);
1165     }
1166 }