1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 /**
67  * Utility library of inline functions on addresses
68  */
69 library AddressUtils {
70 
71   /**
72    * Returns whether the target address is a contract
73    * @dev This function will return false if invoked during the constructor of a contract,
74    * as the code is not actually created until after the constructor finishes.
75    * @param addr address to check
76    * @return whether the target address is a contract
77    */
78   function isContract(address addr) internal view returns (bool) {
79     uint256 size;
80     // XXX Currently there is no better way to check if there is a contract in an address
81     // than to check the size of the code at that address.
82     // See https://ethereum.stackexchange.com/a/14016/36603
83     // for more details about how this works.
84     // TODO Check this again before the Serenity release, because all addresses will be
85     // contracts then.
86     // solium-disable-next-line security/no-inline-assembly
87     assembly { size := extcodesize(addr) }
88     return size > 0;
89   }
90 
91 }
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (a == 0) {
107       return 0;
108     }
109 
110     c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return a / b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
137     c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 
144 /**
145  * @title ERC165
146  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
147  */
148 interface ERC165 {
149 
150   /**
151    * @notice Query if a contract implements an interface
152    * @param _interfaceId The interface identifier, as specified in ERC-165
153    * @dev Interface identification is specified in ERC-165. This function
154    * uses less than 30,000 gas.
155    */
156   function supportsInterface(bytes4 _interfaceId)
157     external
158     view
159     returns (bool);
160 }
161 
162 /**
163  * @title SupportsInterfaceWithLookup
164  * @author Matt Condon (@shrugs)
165  * @dev Implements ERC165 using a lookup table.
166  */
167 contract SupportsInterfaceWithLookup is ERC165 {
168 
169   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
170   /**
171    * 0x01ffc9a7 ===
172    *   bytes4(keccak256('supportsInterface(bytes4)'))
173    */
174 
175   /**
176    * @dev a mapping of interface id to whether or not it's supported
177    */
178   mapping(bytes4 => bool) internal supportedInterfaces;
179 
180   /**
181    * @dev A contract implementing SupportsInterfaceWithLookup
182    * implement ERC165 itself
183    */
184   constructor()
185     public
186   {
187     _registerInterface(InterfaceId_ERC165);
188   }
189 
190   /**
191    * @dev implement supportsInterface(bytes4) using a lookup table
192    */
193   function supportsInterface(bytes4 _interfaceId)
194     external
195     view
196     returns (bool)
197   {
198     return supportedInterfaces[_interfaceId];
199   }
200 
201   /**
202    * @dev private method for registering an interface
203    */
204   function _registerInterface(bytes4 _interfaceId)
205     internal
206   {
207     require(_interfaceId != 0xffffffff);
208     supportedInterfaces[_interfaceId] = true;
209   }
210 }
211 
212 
213 /**
214  * @title ERC721 Non-Fungible Token Standard basic interface
215  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
216  */
217 contract ERC721Basic is ERC165 {
218 
219   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
220   /*
221    * 0x80ac58cd ===
222    *   bytes4(keccak256('balanceOf(address)')) ^
223    *   bytes4(keccak256('ownerOf(uint256)')) ^
224    *   bytes4(keccak256('approve(address,uint256)')) ^
225    *   bytes4(keccak256('getApproved(uint256)')) ^
226    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
227    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
228    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
229    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
230    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
231    */
232 
233   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
234   /*
235    * 0x4f558e79 ===
236    *   bytes4(keccak256('exists(uint256)'))
237    */
238 
239   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
240   /**
241    * 0x780e9d63 ===
242    *   bytes4(keccak256('totalSupply()')) ^
243    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
244    *   bytes4(keccak256('tokenByIndex(uint256)'))
245    */
246 
247   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
248   /**
249    * 0x5b5e139f ===
250    *   bytes4(keccak256('name()')) ^
251    *   bytes4(keccak256('symbol()')) ^
252    *   bytes4(keccak256('tokenURI(uint256)'))
253    */
254 
255   event Transfer(
256     address indexed _from,
257     address indexed _to,
258     uint256 indexed _tokenId
259   );
260   event Approval(
261     address indexed _owner,
262     address indexed _approved,
263     uint256 indexed _tokenId
264   );
265   event ApprovalForAll(
266     address indexed _owner,
267     address indexed _operator,
268     bool _approved
269   );
270 
271   function balanceOf(address _owner) public view returns (uint256 _balance);
272   function ownerOf(uint256 _tokenId) public view returns (address _owner);
273   function exists(uint256 _tokenId) public view returns (bool _exists);
274 
275   function approve(address _to, uint256 _tokenId) public;
276   function getApproved(uint256 _tokenId)
277     public view returns (address _operator);
278 
279   function setApprovalForAll(address _operator, bool _approved) public;
280   function isApprovedForAll(address _owner, address _operator)
281     public view returns (bool);
282 
283   function transferFrom(address _from, address _to, uint256 _tokenId) public;
284   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
285     public;
286 
287   function safeTransferFrom(
288     address _from,
289     address _to,
290     uint256 _tokenId,
291     bytes _data
292   )
293     public;
294 }
295 
296 
297 /**
298  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
299  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
300  */
301 contract ERC721Enumerable is ERC721Basic {
302   function totalSupply() public view returns (uint256);
303   function tokenOfOwnerByIndex(
304     address _owner,
305     uint256 _index
306   )
307     public
308     view
309     returns (uint256 _tokenId);
310 
311   function tokenByIndex(uint256 _index) public view returns (uint256);
312 }
313 
314 
315 /**
316  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
317  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
318  */
319 contract ERC721Metadata is ERC721Basic {
320   function name() external view returns (string _name);
321   function symbol() external view returns (string _symbol);
322   function tokenURI(uint256 _tokenId) public view returns (string);
323 }
324 
325 
326 /**
327  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
328  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
329  */
330 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
331 }
332 
333 /**
334  * @title ERC721 Non-Fungible Token Standard basic implementation
335  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
336  */
337 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
338 
339   using SafeMath for uint256;
340   using AddressUtils for address;
341 
342   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
343   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
344   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
345 
346   // Mapping from token ID to owner
347   mapping (uint256 => address) internal tokenOwner;
348 
349   // Mapping from token ID to approved address
350   mapping (uint256 => address) internal tokenApprovals;
351 
352   // Mapping from owner to number of owned token
353   mapping (address => uint256) internal ownedTokensCount;
354 
355   // Mapping from owner to operator approvals
356   mapping (address => mapping (address => bool)) internal operatorApprovals;
357 
358   constructor()
359     public
360   {
361     // register the supported interfaces to conform to ERC721 via ERC165
362     _registerInterface(InterfaceId_ERC721);
363     _registerInterface(InterfaceId_ERC721Exists);
364   }
365 
366   /**
367    * @dev Gets the balance of the specified address
368    * @param _owner address to query the balance of
369    * @return uint256 representing the amount owned by the passed address
370    */
371   function balanceOf(address _owner) public view returns (uint256) {
372     require(_owner != address(0));
373     return ownedTokensCount[_owner];
374   }
375 
376   /**
377    * @dev Gets the owner of the specified token ID
378    * @param _tokenId uint256 ID of the token to query the owner of
379    * @return owner address currently marked as the owner of the given token ID
380    */
381   function ownerOf(uint256 _tokenId) public view returns (address) {
382     address owner = tokenOwner[_tokenId];
383     require(owner != address(0));
384     return owner;
385   }
386 
387   /**
388    * @dev Returns whether the specified token exists
389    * @param _tokenId uint256 ID of the token to query the existence of
390    * @return whether the token exists
391    */
392   function exists(uint256 _tokenId) public view returns (bool) {
393     address owner = tokenOwner[_tokenId];
394     return owner != address(0);
395   }
396 
397   /**
398    * @dev Approves another address to transfer the given token ID
399    * The zero address indicates there is no approved address.
400    * There can only be one approved address per token at a given time.
401    * Can only be called by the token owner or an approved operator.
402    * @param _to address to be approved for the given token ID
403    * @param _tokenId uint256 ID of the token to be approved
404    */
405   function approve(address _to, uint256 _tokenId) public {
406     address owner = ownerOf(_tokenId);
407     require(_to != owner);
408     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
409 
410     tokenApprovals[_tokenId] = _to;
411     emit Approval(owner, _to, _tokenId);
412   }
413 
414   /**
415    * @dev Gets the approved address for a token ID, or zero if no address set
416    * @param _tokenId uint256 ID of the token to query the approval of
417    * @return address currently approved for the given token ID
418    */
419   function getApproved(uint256 _tokenId) public view returns (address) {
420     return tokenApprovals[_tokenId];
421   }
422 
423   /**
424    * @dev Sets or unsets the approval of a given operator
425    * An operator is allowed to transfer all tokens of the sender on their behalf
426    * @param _to operator address to set the approval
427    * @param _approved representing the status of the approval to be set
428    */
429   function setApprovalForAll(address _to, bool _approved) public {
430     require(_to != msg.sender);
431     operatorApprovals[msg.sender][_to] = _approved;
432     emit ApprovalForAll(msg.sender, _to, _approved);
433   }
434 
435   /**
436    * @dev Tells whether an operator is approved by a given owner
437    * @param _owner owner address which you want to query the approval of
438    * @param _operator operator address which you want to query the approval of
439    * @return bool whether the given operator is approved by the given owner
440    */
441   function isApprovedForAll(
442     address _owner,
443     address _operator
444   )
445     public
446     view
447     returns (bool)
448   {
449     return operatorApprovals[_owner][_operator];
450   }
451 
452   /**
453    * @dev Transfers the ownership of a given token ID to another address
454    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
455    * Requires the msg sender to be the owner, approved, or operator
456    * @param _from current owner of the token
457    * @param _to address to receive the ownership of the given token ID
458    * @param _tokenId uint256 ID of the token to be transferred
459   */
460   function transferFrom(
461     address _from,
462     address _to,
463     uint256 _tokenId
464   )
465     public
466   {
467     require(isApprovedOrOwner(msg.sender, _tokenId));
468     require(_from != address(0));
469     require(_to != address(0));
470 
471     clearApproval(_from, _tokenId);
472     removeTokenFrom(_from, _tokenId);
473     addTokenTo(_to, _tokenId);
474 
475     emit Transfer(_from, _to, _tokenId);
476   }
477 
478   /**
479    * @dev Safely transfers the ownership of a given token ID to another address
480    * If the target address is a contract, it must implement `onERC721Received`,
481    * which is called upon a safe transfer, and return the magic value
482    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
483    * the transfer is reverted.
484    *
485    * Requires the msg sender to be the owner, approved, or operator
486    * @param _from current owner of the token
487    * @param _to address to receive the ownership of the given token ID
488    * @param _tokenId uint256 ID of the token to be transferred
489   */
490   function safeTransferFrom(
491     address _from,
492     address _to,
493     uint256 _tokenId
494   )
495     public
496   {
497     // solium-disable-next-line arg-overflow
498     safeTransferFrom(_from, _to, _tokenId, "");
499   }
500 
501   /**
502    * @dev Safely transfers the ownership of a given token ID to another address
503    * If the target address is a contract, it must implement `onERC721Received`,
504    * which is called upon a safe transfer, and return the magic value
505    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
506    * the transfer is reverted.
507    * Requires the msg sender to be the owner, approved, or operator
508    * @param _from current owner of the token
509    * @param _to address to receive the ownership of the given token ID
510    * @param _tokenId uint256 ID of the token to be transferred
511    * @param _data bytes data to send along with a safe transfer check
512    */
513   function safeTransferFrom(
514     address _from,
515     address _to,
516     uint256 _tokenId,
517     bytes _data
518   )
519     public
520   {
521     transferFrom(_from, _to, _tokenId);
522     // solium-disable-next-line arg-overflow
523     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
524   }
525 
526   /**
527    * @dev Returns whether the given spender can transfer a given token ID
528    * @param _spender address of the spender to query
529    * @param _tokenId uint256 ID of the token to be transferred
530    * @return bool whether the msg.sender is approved for the given token ID,
531    *  is an operator of the owner, or is the owner of the token
532    */
533   function isApprovedOrOwner(
534     address _spender,
535     uint256 _tokenId
536   )
537     internal
538     view
539     returns (bool)
540   {
541     address owner = ownerOf(_tokenId);
542     // Disable solium check because of
543     // https://github.com/duaraghav8/Solium/issues/175
544     // solium-disable-next-line operator-whitespace
545     return (
546       _spender == owner ||
547       getApproved(_tokenId) == _spender ||
548       isApprovedForAll(owner, _spender)
549     );
550   }
551 
552   /**
553    * @dev Internal function to mint a new token
554    * Reverts if the given token ID already exists
555    * @param _to The address that will own the minted token
556    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
557    */
558   function _mint(address _to, uint256 _tokenId) internal {
559     require(_to != address(0));
560     addTokenTo(_to, _tokenId);
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
628     if (!_to.isContract()) {
629       return true;
630     }
631     bytes4 retval = ERC721Receiver(_to).onERC721Received(
632       msg.sender, _from, _tokenId, _data);
633     return (retval == ERC721_RECEIVED);
634   }
635 }
636 
637 /**
638  * @title ERC721 token receiver interface
639  * @dev Interface for any contract that wants to support safeTransfers
640  * from ERC721 asset contracts.
641  */
642 contract ERC721Receiver {
643   /**
644    * @dev Magic value to be returned upon successful reception of an NFT
645    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
646    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
647    */
648   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
649 
650   /**
651    * @notice Handle the receipt of an NFT
652    * @dev The ERC721 smart contract calls this function on the recipient
653    * after a `safetransfer`. This function MAY throw to revert and reject the
654    * transfer. Return of other than the magic value MUST result in the
655    * transaction being reverted.
656    * Note: the contract address is always the message sender.
657    * @param _operator The address which called `safeTransferFrom` function
658    * @param _from The address which previously owned the token
659    * @param _tokenId The NFT identifier which is being transferred
660    * @param _data Additional data with no specified format
661    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
662    */
663   function onERC721Received(
664     address _operator,
665     address _from,
666     uint256 _tokenId,
667     bytes _data
668   )
669     public
670     returns(bytes4);
671 }
672 
673 
674 /**
675  * @title Full ERC721 Token
676  * This implementation includes all the required and some optional functionality of the ERC721 standard
677  * Moreover, it includes approve all functionality using operator terminology
678  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
679  */
680 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
681 
682   // Token name
683   string internal name_;
684 
685   // Token symbol
686   string internal symbol_;
687 
688   // Mapping from owner to list of owned token IDs
689   mapping(address => uint256[]) internal ownedTokens;
690 
691   // Mapping from token ID to index of the owner tokens list
692   mapping(uint256 => uint256) internal ownedTokensIndex;
693 
694   // Array with all token ids, used for enumeration
695   uint256[] internal allTokens;
696 
697   // Mapping from token id to position in the allTokens array
698   mapping(uint256 => uint256) internal allTokensIndex;
699 
700   // Optional mapping for token URIs
701   mapping(uint256 => string) internal tokenURIs;
702 
703   /**
704    * @dev Constructor function
705    */
706   constructor(string _name, string _symbol) public {
707     name_ = _name;
708     symbol_ = _symbol;
709 
710     // register the supported interfaces to conform to ERC721 via ERC165
711     _registerInterface(InterfaceId_ERC721Enumerable);
712     _registerInterface(InterfaceId_ERC721Metadata);
713   }
714 
715   /**
716    * @dev Gets the token name
717    * @return string representing the token name
718    */
719   function name() external view returns (string) {
720     return name_;
721   }
722 
723   /**
724    * @dev Gets the token symbol
725    * @return string representing the token symbol
726    */
727   function symbol() external view returns (string) {
728     return symbol_;
729   }
730 
731   /**
732    * @dev Returns an URI for a given token ID
733    * Throws if the token ID does not exist. May return an empty string.
734    * @param _tokenId uint256 ID of the token to query
735    */
736   function tokenURI(uint256 _tokenId) public view returns (string) {
737     require(exists(_tokenId));
738     return tokenURIs[_tokenId];
739   }
740 
741   /**
742    * @dev Gets the token ID at a given index of the tokens list of the requested owner
743    * @param _owner address owning the tokens list to be accessed
744    * @param _index uint256 representing the index to be accessed of the requested tokens list
745    * @return uint256 token ID at the given index of the tokens list owned by the requested address
746    */
747   function tokenOfOwnerByIndex(
748     address _owner,
749     uint256 _index
750   )
751     public
752     view
753     returns (uint256)
754   {
755     require(_index < balanceOf(_owner));
756     return ownedTokens[_owner][_index];
757   }
758 
759   /**
760    * @dev Gets the total amount of tokens stored by the contract
761    * @return uint256 representing the total amount of tokens
762    */
763   function totalSupply() public view returns (uint256) {
764     return allTokens.length;
765   }
766 
767   /**
768    * @dev Gets the token ID at a given index of all the tokens in this contract
769    * Reverts if the index is greater or equal to the total number of tokens
770    * @param _index uint256 representing the index to be accessed of the tokens list
771    * @return uint256 token ID at the given index of the tokens list
772    */
773   function tokenByIndex(uint256 _index) public view returns (uint256) {
774     require(_index < totalSupply());
775     return allTokens[_index];
776   }
777 
778   /**
779    * @dev Internal function to set the token URI for a given token
780    * Reverts if the token ID does not exist
781    * @param _tokenId uint256 ID of the token to set its URI
782    * @param _uri string URI to assign
783    */
784   function _setTokenURI(uint256 _tokenId, string _uri) internal {
785     require(exists(_tokenId));
786     tokenURIs[_tokenId] = _uri;
787   }
788 
789   /**
790    * @dev Internal function to add a token ID to the list of a given address
791    * @param _to address representing the new owner of the given token ID
792    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
793    */
794   function addTokenTo(address _to, uint256 _tokenId) internal {
795     super.addTokenTo(_to, _tokenId);
796     uint256 length = ownedTokens[_to].length;
797     ownedTokens[_to].push(_tokenId);
798     ownedTokensIndex[_tokenId] = length;
799   }
800 
801   /**
802    * @dev Internal function to remove a token ID from the list of a given address
803    * @param _from address representing the previous owner of the given token ID
804    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
805    */
806   function removeTokenFrom(address _from, uint256 _tokenId) internal {
807     super.removeTokenFrom(_from, _tokenId);
808 
809     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
810     // then delete the last slot.
811     uint256 tokenIndex = ownedTokensIndex[_tokenId];
812     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
813     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
814 
815     ownedTokens[_from][tokenIndex] = lastToken;
816     ownedTokens[_from].length--;
817     // ^ This also deletes the contents at the last position of the array
818 
819     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
820     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
821     // the lastToken to the first position, and then dropping the element placed in the last position of the list
822 
823     ownedTokensIndex[_tokenId] = 0;
824     ownedTokensIndex[lastToken] = tokenIndex;
825   }
826 
827   /**
828    * @dev Internal function to mint a new token
829    * Reverts if the given token ID already exists
830    * @param _to address the beneficiary that will own the minted token
831    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
832    */
833   function _mint(address _to, uint256 _tokenId) internal {
834     super._mint(_to, _tokenId);
835 
836     allTokensIndex[_tokenId] = allTokens.length;
837     allTokens.push(_tokenId);
838   }
839 
840   /**
841    * @dev Internal function to burn a specific token
842    * Reverts if the token does not exist
843    * @param _owner owner of the token to burn
844    * @param _tokenId uint256 ID of the token being burned by the msg.sender
845    */
846   function _burn(address _owner, uint256 _tokenId) internal {
847     super._burn(_owner, _tokenId);
848 
849     // Clear metadata (if any)
850     if (bytes(tokenURIs[_tokenId]).length != 0) {
851       delete tokenURIs[_tokenId];
852     }
853 
854     // Reorg all tokens array
855     uint256 tokenIndex = allTokensIndex[_tokenId];
856     uint256 lastTokenIndex = allTokens.length.sub(1);
857     uint256 lastToken = allTokens[lastTokenIndex];
858 
859     allTokens[tokenIndex] = lastToken;
860     allTokens[lastTokenIndex] = 0;
861 
862     allTokens.length--;
863     allTokensIndex[_tokenId] = 0;
864     allTokensIndex[lastToken] = tokenIndex;
865   }
866 
867 }
868 
869 
870 contract TTTToken {
871   function transfer(address _to, uint256 _amount) public returns (bool success);
872   function transferFrom(address from, address to, uint tokens) public returns (bool success);
873   function balanceOf(address tokenOwner) public constant returns (uint balance);
874 }
875 
876 
877 // @title The Tip Tokn SAN (Short Address Name)
878 // @author Jonathan Teel (jonathan.teel@thetiptoken.io)
879 // @dev First 500 SANs do no require a slot
880 contract TTTSan is ERC721Token, Ownable {
881 
882   address public wallet = 0x515165A6511734A4eFB5Cfb531955cf420b2725B;
883   address public tttTokenAddress = 0x24358430f5b1f947B04D9d1a22bEb6De01CaBea2;
884   address public marketAddress;
885 
886   uint256 public sanTTTCost;
887   uint256 public sanMaxLength;
888   uint256 public sanMinLength;
889   uint256 public sanMaxAmount;
890   uint256 public sanMaxFree;
891   uint256 public sanCurrentTotal;
892 
893   string public baseUrl = "https://thetiptoken.io/arv/img/";
894 
895   mapping(string=>bool) sanOwnership;
896   mapping(address=>uint256) sanSlots;
897   mapping(address=>uint256) sanOwnerAmount;
898   mapping(string=>uint256) sanNameToId;
899   mapping(string=>address) sanNameToAddress;
900 
901   struct SAN {
902     string sanName;
903     uint256 timeAlive;
904     uint256 timeLastMove;
905     address prevOwner;
906     string sanageLink;
907   }
908 
909   SAN[] public sans;
910 
911   TTTToken ttt;
912 
913   modifier isMarketAddress() {
914 		require(msg.sender == marketAddress);
915 		_;
916 	}
917 
918   event SanMinted(address sanOwner, uint256 sanId, string sanName);
919   event SanSlotPurchase(address sanOwner, uint256 amt);
920   event SanCostUpdated(uint256 cost);
921   event SanLengthReqChange(uint256 sanMinLength, uint256 sanMaxLength);
922   event SanMaxAmountChange(uint256 sanMaxAmount);
923 
924   constructor() public ERC721Token("TTTSAN", "TTTS") {
925     sanTTTCost = 10 ether;
926     sanMaxLength = 16;
927     sanMinLength = 2;
928     sanMaxAmount = 100;
929     sanMaxFree = 500;
930     ttt = TTTToken(tttTokenAddress);
931     // gen0 san
932   /* "NeverGonnaGiveYouUp.NeverGonnaLetYouDown" */
933     string memory gen0 = "NeverGonnaGiveYouUp.NeverGonnaLetYouDown";
934     SAN memory s = SAN({
935         sanName: gen0,
936         timeAlive: block.timestamp,
937         timeLastMove: block.timestamp,
938         prevOwner: msg.sender,
939         sanageLink: "0x"
940     });
941     uint256 sanId = sans.push(s).sub(1);
942     sanOwnership[gen0] = true;
943     _sanMint(sanId, msg.sender, "gen0.jpeg", gen0);
944   }
945 
946   function sanMint(string _sanName, string _sanageUri) external returns (string) {
947     // first 500 SANs do not require a slot
948     if(sanCurrentTotal > sanMaxFree)
949       require(sanSlots[msg.sender] >= 1, "no san slots available");
950     string memory sn = sanitize(_sanName);
951     SAN memory s = SAN({
952         sanName: sn,
953         timeAlive: block.timestamp,
954         timeLastMove: block.timestamp,
955         prevOwner: msg.sender,
956         sanageLink: _sanageUri
957     });
958     uint256 sanId = sans.push(s).sub(1);
959     sanOwnership[sn] = true;
960     if(sanCurrentTotal > sanMaxFree)
961       sanSlots[msg.sender] = sanSlots[msg.sender].sub(1);
962     _sanMint(sanId, msg.sender, _sanageUri, sn);
963     return sn;
964   }
965 
966   function getSANOwner(uint256 _sanId) public view returns (address) {
967     return ownerOf(_sanId);
968   }
969 
970   function getSanIdFromName(string _sanName) public view returns (uint256) {
971     return sanNameToId[_sanName];
972   }
973 
974   function getSanName(uint256 _sanId) public view returns (string) {
975     return sans[_sanId].sanName;
976   }
977 
978   function getSanageLink(uint256 _sanId) public view returns (string) {
979     return sans[_sanId].sanageLink;
980   }
981 
982   function getSanTimeAlive(uint256 _sanId) public view returns (uint256) {
983     return sans[_sanId].timeAlive;
984   }
985 
986   function getSanTimeLastMove(uint256 _sanId) public view returns (uint256) {
987     return sans[_sanId].timeLastMove;
988   }
989 
990   function getSanPrevOwner(uint256 _sanId) public view returns (address) {
991     return sans[_sanId].prevOwner;
992   }
993 
994   function getAddressFromSan(string _sanName) public view returns (address) {
995     return sanNameToAddress[_sanName];
996   }
997 
998   function getSanSlots(address _sanOwner) public view returns(uint256) {
999     return sanSlots[_sanOwner];
1000   }
1001 
1002   // used for initial check to not waste gas
1003   function getSANitized(string _sanName) external view returns (string) {
1004     return sanitize(_sanName);
1005   }
1006 
1007   function buySanSlot(address _sanOwner,  uint256 _tip) external returns(bool) {
1008     require(_tip >= sanTTTCost, "tip less than san cost");
1009     require(sanSlots[_sanOwner] < sanMaxAmount, "max san slots owned");
1010     sanSlots[_sanOwner] = sanSlots[_sanOwner].add(1);
1011     ttt.transferFrom(msg.sender, wallet, _tip);
1012     emit SanSlotPurchase(_sanOwner, 1);
1013     return true;
1014   }
1015 
1016   function marketSale(uint256 _sanId, string _sanName, address _prevOwner, address _newOwner) external isMarketAddress {
1017     SAN storage s = sans[_sanId];
1018     s.prevOwner = _prevOwner;
1019     s.timeLastMove = block.timestamp;
1020     sanNameToAddress[_sanName] = _newOwner;
1021     // no slot movements for first 500 SANs
1022     if(sanCurrentTotal > sanMaxFree) {
1023       sanSlots[_prevOwner] = sanSlots[_prevOwner].sub(1);
1024       sanSlots[_newOwner] = sanSlots[_newOwner].add(1);
1025     }
1026     sanOwnerAmount[_prevOwner] = sanOwnerAmount[_prevOwner].sub(1);
1027     sanOwnerAmount[_newOwner] = sanOwnerAmount[_newOwner].add(1);
1028   }
1029 
1030   function() public payable { revert(); }
1031 
1032   // OWNER FUNCTIONS
1033 
1034   function setSanTTTCost(uint256 _cost) external onlyOwner {
1035     sanTTTCost = _cost;
1036     emit SanCostUpdated(sanTTTCost);
1037   }
1038 
1039   function setSanLength(uint256 _length, uint256 _pos) external onlyOwner {
1040     require(_length > 0);
1041     if(_pos == 0) sanMinLength = _length;
1042     else sanMaxLength = _length;
1043     emit SanLengthReqChange(sanMinLength, sanMaxLength);
1044   }
1045 
1046   function setSanMaxAmount(uint256 _amount) external onlyOwner {
1047     sanMaxAmount = _amount;
1048     emit SanMaxAmountChange(sanMaxAmount);
1049   }
1050 
1051   function setSanMaxFree(uint256 _sanMaxFree) external onlyOwner {
1052     sanMaxFree = _sanMaxFree;
1053   }
1054 
1055   function ownerAddSanSlot(address _sanOwner, uint256 _slotCount) external onlyOwner {
1056     require(_slotCount > 0 && _slotCount <= sanMaxAmount);
1057     require(sanSlots[_sanOwner] < sanMaxAmount);
1058     sanSlots[_sanOwner] = sanSlots[_sanOwner].add(_slotCount);
1059   }
1060 
1061   // owner can add slots in batches, 100 max
1062   function ownerAddSanSlotBatch(address[] _sanOwner, uint256[] _slotCount) external onlyOwner {
1063     require(_sanOwner.length == _slotCount.length);
1064     require(_sanOwner.length <= 100);
1065     for(uint8 i = 0; i < _sanOwner.length; i++) {
1066       require(_slotCount[i] > 0 && _slotCount[i] <= sanMaxAmount, "incorrect slot count");
1067       sanSlots[_sanOwner[i]] = sanSlots[_sanOwner[i]].add(_slotCount[i]);
1068       require(sanSlots[_sanOwner[i]] <= sanMaxAmount, "max san slots owned");
1069     }
1070   }
1071 
1072   function setMarketAddress(address _marketAddress) public onlyOwner {
1073     marketAddress = _marketAddress;
1074   }
1075 
1076   function setBaseUrl(string _baseUrl) public onlyOwner {
1077     baseUrl = _baseUrl;
1078   }
1079 
1080   function setOwnerWallet(address _wallet) public onlyOwner {
1081     wallet = _wallet;
1082   }
1083 
1084   function updateTokenUri(uint256 _sanId, string _newUri) public onlyOwner {
1085     SAN storage s = sans[_sanId];
1086     s.sanageLink = _newUri;
1087     _setTokenURI(_sanId, strConcat(baseUrl, _newUri));
1088   }
1089 
1090   function emptyTTT() external onlyOwner {
1091     ttt.transfer(msg.sender, ttt.balanceOf(address(this)));
1092   }
1093 
1094   function emptyEther() external onlyOwner {
1095     owner.transfer(address(this).balance);
1096   }
1097 
1098   // owner can mint special sans for an address
1099   function specialSanMint(string _sanName, string _sanageUri, address _address) external onlyOwner returns (string) {
1100     SAN memory s = SAN({
1101         sanName: _sanName,
1102         timeAlive: block.timestamp,
1103         timeLastMove: block.timestamp,
1104         prevOwner: _address,
1105         sanageLink: _sanageUri
1106     });
1107     uint256 sanId = sans.push(s).sub(1);
1108     _sanMint(sanId, _address, _sanageUri, _sanName);
1109     return _sanName;
1110   }
1111 
1112   // INTERNAL FUNCTIONS
1113 
1114   function sanitize(string _sanName) internal view returns(string) {
1115     string memory sn = sanToLower(_sanName);
1116     require(isValidSan(sn), "san is not valid");
1117     require(!sanOwnership[sn], "san is not unique");
1118     return sn;
1119   }
1120 
1121   function _sanMint(uint256 _sanId, address _owner, string _sanageUri, string _sanName) internal {
1122     require(sanOwnerAmount[_owner] < sanMaxAmount, "max san owned");
1123     sanNameToId[_sanName] = _sanId;
1124     sanNameToAddress[_sanName] = _owner;
1125     sanOwnerAmount[_owner] = sanOwnerAmount[_owner].add(1);
1126     sanCurrentTotal = sanCurrentTotal.add(1);
1127     _mint(_owner, _sanId);
1128     _setTokenURI(_sanId, strConcat(baseUrl, _sanageUri));
1129     emit SanMinted(_owner, _sanId, _sanName);
1130   }
1131 
1132   function isValidSan(string _sanName) internal view returns(bool) {
1133     bytes memory wb = bytes(_sanName);
1134     uint slen = wb.length;
1135     if (slen > sanMaxLength || slen <= sanMinLength) return false;
1136     bytes1 space = bytes1(0x20);
1137     bytes1 period = bytes1(0x2E);
1138     // san can not end in .eth - added to avoid conflicts with ens
1139     bytes1 e = bytes1(0x65);
1140     bytes1 t = bytes1(0x74);
1141     bytes1 h = bytes1(0x68);
1142     uint256 dCount = 0;
1143     uint256 eCount = 0;
1144     uint256 eth = 0;
1145     for(uint256 i = 0; i < slen; i++) {
1146         if(wb[i] == space) return false;
1147         else if(wb[i] == period) {
1148           dCount = dCount.add(1);
1149           // only 1 '.'
1150           if(dCount > 1) return false;
1151           eCount = 1;
1152         } else if(eCount > 0 && eCount < 5) {
1153           if(eCount == 1) if(wb[i] == e) eth = eth.add(1);
1154           if(eCount == 2) if(wb[i] == t) eth = eth.add(1);
1155           if(eCount == 3) if(wb[i] == h) eth = eth.add(1);
1156           eCount = eCount.add(1);
1157         }
1158     }
1159     if(dCount == 0) return false;
1160     if((eth == 3 && eCount == 4) || eCount == 1) return false;
1161     return true;
1162   }
1163 
1164   function sanToLower(string _sanName) internal pure returns(string) {
1165     bytes memory b = bytes(_sanName);
1166     for(uint256 i = 0; i < b.length; i++) {
1167       b[i] = byteToLower(b[i]);
1168     }
1169     return string(b);
1170   }
1171 
1172   function byteToLower(bytes1 _b) internal pure returns (bytes1) {
1173     if(_b >= bytes1(0x41) && _b <= bytes1(0x5A))
1174       return bytes1(uint8(_b) + 32);
1175     return _b;
1176   }
1177 
1178   function strConcat(string _a, string _b) internal pure returns (string) {
1179     bytes memory _ba = bytes(_a);
1180     bytes memory _bb = bytes(_b);
1181     string memory ab = new string(_ba.length.add(_bb.length));
1182     bytes memory bab = bytes(ab);
1183     uint256 k = 0;
1184     for (uint256 i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1185     for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1186     return string(bab);
1187   }
1188 
1189 }