1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title Destructible
67  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
68  */
69 contract Destructible is Ownable {
70   /**
71    * @dev Transfers the current balance to the owner and terminates the contract.
72    */
73   function destroy() public onlyOwner {
74     selfdestruct(owner);
75   }
76 
77   function destroyAndSend(address _recipient) public onlyOwner {
78     selfdestruct(_recipient);
79   }
80 }
81 
82 /**
83  * @title ERC165
84  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
85  */
86 interface ERC165 {
87 
88   /**
89    * @notice Query if a contract implements an interface
90    * @param _interfaceId The interface identifier, as specified in ERC-165
91    * @dev Interface identification is specified in ERC-165. This function
92    * uses less than 30,000 gas.
93    */
94   function supportsInterface(bytes4 _interfaceId)
95     external
96     view
97     returns (bool);
98 }
99 
100 /**
101  * @title ERC721 Non-Fungible Token Standard basic interface
102  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
103  */
104 contract ERC721Basic is ERC165 {
105 
106   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
107   /*
108    * 0x80ac58cd ===
109    *   bytes4(keccak256('balanceOf(address)')) ^
110    *   bytes4(keccak256('ownerOf(uint256)')) ^
111    *   bytes4(keccak256('approve(address,uint256)')) ^
112    *   bytes4(keccak256('getApproved(uint256)')) ^
113    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
114    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
115    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
116    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
117    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
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
154 
155   function approve(address _to, uint256 _tokenId) public;
156   function getApproved(uint256 _tokenId)
157     public view returns (address _operator);
158 
159   function setApprovalForAll(address _operator, bool _approved) public;
160   function isApprovedForAll(address _owner, address _operator)
161     public view returns (bool);
162 
163   function transferFrom(address _from, address _to, uint256 _tokenId) public;
164   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
165     public;
166 
167   function safeTransferFrom(
168     address _from,
169     address _to,
170     uint256 _tokenId,
171     bytes _data
172   )
173     public;
174 }
175 
176 /**
177  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
178  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
179  */
180 contract ERC721Enumerable is ERC721Basic {
181   function totalSupply() public view returns (uint256);
182   function tokenOfOwnerByIndex(
183     address _owner,
184     uint256 _index
185   )
186     public
187     view
188     returns (uint256 _tokenId);
189 
190   function tokenByIndex(uint256 _index) public view returns (uint256);
191 }
192 
193 
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
196  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
197  */
198 contract ERC721Metadata is ERC721Basic {
199   function name() external view returns (string _name);
200   function symbol() external view returns (string _symbol);
201   function tokenURI(uint256 _tokenId) public view returns (string);
202 }
203 
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
207  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
208  */
209 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
210 }
211 
212 /**
213  * @title SupportsInterfaceWithLookup
214  * @author Matt Condon (@shrugs)
215  * @dev Implements ERC165 using a lookup table.
216  */
217 contract SupportsInterfaceWithLookup is ERC165 {
218 
219   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
220   /**
221    * 0x01ffc9a7 ===
222    *   bytes4(keccak256('supportsInterface(bytes4)'))
223    */
224 
225   /**
226    * @dev a mapping of interface id to whether or not it's supported
227    */
228   mapping(bytes4 => bool) internal supportedInterfaces;
229 
230   /**
231    * @dev A contract implementing SupportsInterfaceWithLookup
232    * implement ERC165 itself
233    */
234   constructor()
235     public
236   {
237     _registerInterface(InterfaceId_ERC165);
238   }
239 
240   /**
241    * @dev implement supportsInterface(bytes4) using a lookup table
242    */
243   function supportsInterface(bytes4 _interfaceId)
244     external
245     view
246     returns (bool)
247   {
248     return supportedInterfaces[_interfaceId];
249   }
250 
251   /**
252    * @dev private method for registering an interface
253    */
254   function _registerInterface(bytes4 _interfaceId)
255     internal
256   {
257     require(_interfaceId != 0xffffffff);
258     supportedInterfaces[_interfaceId] = true;
259   }
260 }
261 
262 /**
263  * @title SafeMath
264  * @dev Math operations with safety checks that revert on error
265  */
266 library SafeMath {
267 
268   /**
269   * @dev Multiplies two numbers, reverts on overflow.
270   */
271   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
272     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
273     // benefit is lost if 'b' is also tested.
274     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
275     if (_a == 0) {
276       return 0;
277     }
278 
279     uint256 c = _a * _b;
280     require(c / _a == _b);
281 
282     return c;
283   }
284 
285   /**
286   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
287   */
288   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
289     require(_b > 0); // Solidity only automatically asserts when dividing by 0
290     uint256 c = _a / _b;
291     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
292 
293     return c;
294   }
295 
296   /**
297   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
298   */
299   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
300     require(_b <= _a);
301     uint256 c = _a - _b;
302 
303     return c;
304   }
305 
306   /**
307   * @dev Adds two numbers, reverts on overflow.
308   */
309   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
310     uint256 c = _a + _b;
311     require(c >= _a);
312 
313     return c;
314   }
315 
316   /**
317   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
318   * reverts when dividing by zero.
319   */
320   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
321     require(b != 0);
322     return a % b;
323   }
324 }
325 
326 /**
327  * Utility library of inline functions on addresses
328  */
329 library AddressUtils {
330 
331   /**
332    * Returns whether the target address is a contract
333    * @dev This function will return false if invoked during the constructor of a contract,
334    * as the code is not actually created until after the constructor finishes.
335    * @param _account address of the account to check
336    * @return whether the target address is a contract
337    */
338   function isContract(address _account) internal view returns (bool) {
339     uint256 size;
340     // XXX Currently there is no better way to check if there is a contract in an address
341     // than to check the size of the code at that address.
342     // See https://ethereum.stackexchange.com/a/14016/36603
343     // for more details about how this works.
344     // TODO Check this again before the Serenity release, because all addresses will be
345     // contracts then.
346     // solium-disable-next-line security/no-inline-assembly
347     assembly { size := extcodesize(_account) }
348     return size > 0;
349   }
350 
351 }
352 
353 /**
354  * @title ERC721 token receiver interface
355  * @dev Interface for any contract that wants to support safeTransfers
356  * from ERC721 asset contracts.
357  */
358 contract ERC721Receiver {
359   /**
360    * @dev Magic value to be returned upon successful reception of an NFT
361    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
362    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
363    */
364   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
365 
366   /**
367    * @notice Handle the receipt of an NFT
368    * @dev The ERC721 smart contract calls this function on the recipient
369    * after a `safetransfer`. This function MAY throw to revert and reject the
370    * transfer. Return of other than the magic value MUST result in the
371    * transaction being reverted.
372    * Note: the contract address is always the message sender.
373    * @param _operator The address which called `safeTransferFrom` function
374    * @param _from The address which previously owned the token
375    * @param _tokenId The NFT identifier which is being transferred
376    * @param _data Additional data with no specified format
377    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
378    */
379   function onERC721Received(
380     address _operator,
381     address _from,
382     uint256 _tokenId,
383     bytes _data
384   )
385     public
386     returns(bytes4);
387 }
388 
389 /**
390  * @title ERC721 Non-Fungible Token Standard basic implementation
391  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
392  */
393 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
394 
395   using SafeMath for uint256;
396   using AddressUtils for address;
397 
398   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
399   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
400   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
401 
402   // Mapping from token ID to owner
403   mapping (uint256 => address) internal tokenOwner;
404 
405   // Mapping from token ID to approved address
406   mapping (uint256 => address) internal tokenApprovals;
407 
408   // Mapping from owner to number of owned token
409   mapping (address => uint256) internal ownedTokensCount;
410 
411   // Mapping from owner to operator approvals
412   mapping (address => mapping (address => bool)) internal operatorApprovals;
413 
414   constructor()
415     public
416   {
417     // register the supported interfaces to conform to ERC721 via ERC165
418     _registerInterface(InterfaceId_ERC721);
419   }
420 
421   /**
422    * @dev Gets the balance of the specified address
423    * @param _owner address to query the balance of
424    * @return uint256 representing the amount owned by the passed address
425    */
426   function balanceOf(address _owner) public view returns (uint256) {
427     require(_owner != address(0));
428     return ownedTokensCount[_owner];
429   }
430 
431   /**
432    * @dev Gets the owner of the specified token ID
433    * @param _tokenId uint256 ID of the token to query the owner of
434    * @return owner address currently marked as the owner of the given token ID
435    */
436   function ownerOf(uint256 _tokenId) public view returns (address) {
437     address owner = tokenOwner[_tokenId];
438     require(owner != address(0));
439     return owner;
440   }
441 
442   /**
443    * @dev Approves another address to transfer the given token ID
444    * The zero address indicates there is no approved address.
445    * There can only be one approved address per token at a given time.
446    * Can only be called by the token owner or an approved operator.
447    * @param _to address to be approved for the given token ID
448    * @param _tokenId uint256 ID of the token to be approved
449    */
450   function approve(address _to, uint256 _tokenId) public {
451     address owner = ownerOf(_tokenId);
452     require(_to != owner);
453     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
454 
455     tokenApprovals[_tokenId] = _to;
456     emit Approval(owner, _to, _tokenId);
457   }
458 
459   /**
460    * @dev Gets the approved address for a token ID, or zero if no address set
461    * @param _tokenId uint256 ID of the token to query the approval of
462    * @return address currently approved for the given token ID
463    */
464   function getApproved(uint256 _tokenId) public view returns (address) {
465     return tokenApprovals[_tokenId];
466   }
467 
468   /**
469    * @dev Sets or unsets the approval of a given operator
470    * An operator is allowed to transfer all tokens of the sender on their behalf
471    * @param _to operator address to set the approval
472    * @param _approved representing the status of the approval to be set
473    */
474   function setApprovalForAll(address _to, bool _approved) public {
475     require(_to != msg.sender);
476     operatorApprovals[msg.sender][_to] = _approved;
477     emit ApprovalForAll(msg.sender, _to, _approved);
478   }
479 
480   /**
481    * @dev Tells whether an operator is approved by a given owner
482    * @param _owner owner address which you want to query the approval of
483    * @param _operator operator address which you want to query the approval of
484    * @return bool whether the given operator is approved by the given owner
485    */
486   function isApprovedForAll(
487     address _owner,
488     address _operator
489   )
490     public
491     view
492     returns (bool)
493   {
494     return operatorApprovals[_owner][_operator];
495   }
496 
497   /**
498    * @dev Transfers the ownership of a given token ID to another address
499    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
500    * Requires the msg sender to be the owner, approved, or operator
501    * @param _from current owner of the token
502    * @param _to address to receive the ownership of the given token ID
503    * @param _tokenId uint256 ID of the token to be transferred
504   */
505   function transferFrom(
506     address _from,
507     address _to,
508     uint256 _tokenId
509   )
510     public
511   {
512     require(isApprovedOrOwner(msg.sender, _tokenId));
513     require(_to != address(0));
514 
515     clearApproval(_from, _tokenId);
516     removeTokenFrom(_from, _tokenId);
517     addTokenTo(_to, _tokenId);
518 
519     emit Transfer(_from, _to, _tokenId);
520   }
521 
522   /**
523    * @dev Safely transfers the ownership of a given token ID to another address
524    * If the target address is a contract, it must implement `onERC721Received`,
525    * which is called upon a safe transfer, and return the magic value
526    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
527    * the transfer is reverted.
528    *
529    * Requires the msg sender to be the owner, approved, or operator
530    * @param _from current owner of the token
531    * @param _to address to receive the ownership of the given token ID
532    * @param _tokenId uint256 ID of the token to be transferred
533   */
534   function safeTransferFrom(
535     address _from,
536     address _to,
537     uint256 _tokenId
538   )
539     public
540   {
541     // solium-disable-next-line arg-overflow
542     safeTransferFrom(_from, _to, _tokenId, "");
543   }
544 
545   /**
546    * @dev Safely transfers the ownership of a given token ID to another address
547    * If the target address is a contract, it must implement `onERC721Received`,
548    * which is called upon a safe transfer, and return the magic value
549    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
550    * the transfer is reverted.
551    * Requires the msg sender to be the owner, approved, or operator
552    * @param _from current owner of the token
553    * @param _to address to receive the ownership of the given token ID
554    * @param _tokenId uint256 ID of the token to be transferred
555    * @param _data bytes data to send along with a safe transfer check
556    */
557   function safeTransferFrom(
558     address _from,
559     address _to,
560     uint256 _tokenId,
561     bytes _data
562   )
563     public
564   {
565     transferFrom(_from, _to, _tokenId);
566     // solium-disable-next-line arg-overflow
567     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
568   }
569 
570   /**
571    * @dev Returns whether the specified token exists
572    * @param _tokenId uint256 ID of the token to query the existence of
573    * @return whether the token exists
574    */
575   function _exists(uint256 _tokenId) internal view returns (bool) {
576     address owner = tokenOwner[_tokenId];
577     return owner != address(0);
578   }
579 
580   /**
581    * @dev Returns whether the given spender can transfer a given token ID
582    * @param _spender address of the spender to query
583    * @param _tokenId uint256 ID of the token to be transferred
584    * @return bool whether the msg.sender is approved for the given token ID,
585    *  is an operator of the owner, or is the owner of the token
586    */
587   function isApprovedOrOwner(
588     address _spender,
589     uint256 _tokenId
590   )
591     internal
592     view
593     returns (bool)
594   {
595     address owner = ownerOf(_tokenId);
596     // Disable solium check because of
597     // https://github.com/duaraghav8/Solium/issues/175
598     // solium-disable-next-line operator-whitespace
599     return (
600       _spender == owner ||
601       getApproved(_tokenId) == _spender ||
602       isApprovedForAll(owner, _spender)
603     );
604   }
605 
606   /**
607    * @dev Internal function to mint a new token
608    * Reverts if the given token ID already exists
609    * @param _to The address that will own the minted token
610    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
611    */
612   function _mint(address _to, uint256 _tokenId) internal {
613     require(_to != address(0));
614     addTokenTo(_to, _tokenId);
615     emit Transfer(address(0), _to, _tokenId);
616   }
617 
618   /**
619    * @dev Internal function to burn a specific token
620    * Reverts if the token does not exist
621    * @param _tokenId uint256 ID of the token being burned by the msg.sender
622    */
623   function _burn(address _owner, uint256 _tokenId) internal {
624     clearApproval(_owner, _tokenId);
625     removeTokenFrom(_owner, _tokenId);
626     emit Transfer(_owner, address(0), _tokenId);
627   }
628 
629   /**
630    * @dev Internal function to clear current approval of a given token ID
631    * Reverts if the given address is not indeed the owner of the token
632    * @param _owner owner of the token
633    * @param _tokenId uint256 ID of the token to be transferred
634    */
635   function clearApproval(address _owner, uint256 _tokenId) internal {
636     require(ownerOf(_tokenId) == _owner);
637     if (tokenApprovals[_tokenId] != address(0)) {
638       tokenApprovals[_tokenId] = address(0);
639     }
640   }
641 
642   /**
643    * @dev Internal function to add a token ID to the list of a given address
644    * @param _to address representing the new owner of the given token ID
645    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
646    */
647   function addTokenTo(address _to, uint256 _tokenId) internal {
648     require(tokenOwner[_tokenId] == address(0));
649     tokenOwner[_tokenId] = _to;
650     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
651   }
652 
653   /**
654    * @dev Internal function to remove a token ID from the list of a given address
655    * @param _from address representing the previous owner of the given token ID
656    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
657    */
658   function removeTokenFrom(address _from, uint256 _tokenId) internal {
659     require(ownerOf(_tokenId) == _from);
660     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
661     tokenOwner[_tokenId] = address(0);
662   }
663 
664   /**
665    * @dev Internal function to invoke `onERC721Received` on a target address
666    * The call is not executed if the target address is not a contract
667    * @param _from address representing the previous owner of the given token ID
668    * @param _to target address that will receive the tokens
669    * @param _tokenId uint256 ID of the token to be transferred
670    * @param _data bytes optional data to send along with the call
671    * @return whether the call correctly returned the expected magic value
672    */
673   function checkAndCallSafeTransfer(
674     address _from,
675     address _to,
676     uint256 _tokenId,
677     bytes _data
678   )
679     internal
680     returns (bool)
681   {
682     if (!_to.isContract()) {
683       return true;
684     }
685     bytes4 retval = ERC721Receiver(_to).onERC721Received(
686       msg.sender, _from, _tokenId, _data);
687     return (retval == ERC721_RECEIVED);
688   }
689 }
690 
691 /**
692  * @title Full ERC721 Token
693  * This implementation includes all the required and some optional functionality of the ERC721 standard
694  * Moreover, it includes approve all functionality using operator terminology
695  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
696  */
697 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
698 
699   // Token name
700   string internal name_;
701 
702   // Token symbol
703   string internal symbol_;
704 
705   // Mapping from owner to list of owned token IDs
706   mapping(address => uint256[]) internal ownedTokens;
707 
708   // Mapping from token ID to index of the owner tokens list
709   mapping(uint256 => uint256) internal ownedTokensIndex;
710 
711   // Array with all token ids, used for enumeration
712   uint256[] internal allTokens;
713 
714   // Mapping from token id to position in the allTokens array
715   mapping(uint256 => uint256) internal allTokensIndex;
716 
717   // Optional mapping for token URIs
718   mapping(uint256 => string) internal tokenURIs;
719 
720   /**
721    * @dev Constructor function
722    */
723   constructor(string _name, string _symbol) public {
724     name_ = _name;
725     symbol_ = _symbol;
726 
727     // register the supported interfaces to conform to ERC721 via ERC165
728     _registerInterface(InterfaceId_ERC721Enumerable);
729     _registerInterface(InterfaceId_ERC721Metadata);
730   }
731 
732   /**
733    * @dev Gets the token name
734    * @return string representing the token name
735    */
736   function name() external view returns (string) {
737     return name_;
738   }
739 
740   /**
741    * @dev Gets the token symbol
742    * @return string representing the token symbol
743    */
744   function symbol() external view returns (string) {
745     return symbol_;
746   }
747 
748   /**
749    * @dev Returns an URI for a given token ID
750    * Throws if the token ID does not exist. May return an empty string.
751    * @param _tokenId uint256 ID of the token to query
752    */
753   function tokenURI(uint256 _tokenId) public view returns (string) {
754     require(_exists(_tokenId));
755     return tokenURIs[_tokenId];
756   }
757 
758   /**
759    * @dev Gets the token ID at a given index of the tokens list of the requested owner
760    * @param _owner address owning the tokens list to be accessed
761    * @param _index uint256 representing the index to be accessed of the requested tokens list
762    * @return uint256 token ID at the given index of the tokens list owned by the requested address
763    */
764   function tokenOfOwnerByIndex(
765     address _owner,
766     uint256 _index
767   )
768     public
769     view
770     returns (uint256)
771   {
772     require(_index < balanceOf(_owner));
773     return ownedTokens[_owner][_index];
774   }
775 
776   /**
777    * @dev Gets the total amount of tokens stored by the contract
778    * @return uint256 representing the total amount of tokens
779    */
780   function totalSupply() public view returns (uint256) {
781     return allTokens.length;
782   }
783 
784   /**
785    * @dev Gets the token ID at a given index of all the tokens in this contract
786    * Reverts if the index is greater or equal to the total number of tokens
787    * @param _index uint256 representing the index to be accessed of the tokens list
788    * @return uint256 token ID at the given index of the tokens list
789    */
790   function tokenByIndex(uint256 _index) public view returns (uint256) {
791     require(_index < totalSupply());
792     return allTokens[_index];
793   }
794 
795   /**
796    * @dev Internal function to set the token URI for a given token
797    * Reverts if the token ID does not exist
798    * @param _tokenId uint256 ID of the token to set its URI
799    * @param _uri string URI to assign
800    */
801   function _setTokenURI(uint256 _tokenId, string _uri) internal {
802     require(_exists(_tokenId));
803     tokenURIs[_tokenId] = _uri;
804   }
805 
806   /**
807    * @dev Internal function to add a token ID to the list of a given address
808    * @param _to address representing the new owner of the given token ID
809    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
810    */
811   function addTokenTo(address _to, uint256 _tokenId) internal {
812     super.addTokenTo(_to, _tokenId);
813     uint256 length = ownedTokens[_to].length;
814     ownedTokens[_to].push(_tokenId);
815     ownedTokensIndex[_tokenId] = length;
816   }
817 
818   /**
819    * @dev Internal function to remove a token ID from the list of a given address
820    * @param _from address representing the previous owner of the given token ID
821    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
822    */
823   function removeTokenFrom(address _from, uint256 _tokenId) internal {
824     super.removeTokenFrom(_from, _tokenId);
825 
826     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
827     // then delete the last slot.
828     uint256 tokenIndex = ownedTokensIndex[_tokenId];
829     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
830     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
831 
832     ownedTokens[_from][tokenIndex] = lastToken;
833     // This also deletes the contents at the last position of the array
834     ownedTokens[_from].length--;
835 
836     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
837     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
838     // the lastToken to the first position, and then dropping the element placed in the last position of the list
839 
840     ownedTokensIndex[_tokenId] = 0;
841     ownedTokensIndex[lastToken] = tokenIndex;
842   }
843 
844   /**
845    * @dev Internal function to mint a new token
846    * Reverts if the given token ID already exists
847    * @param _to address the beneficiary that will own the minted token
848    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
849    */
850   function _mint(address _to, uint256 _tokenId) internal {
851     super._mint(_to, _tokenId);
852 
853     allTokensIndex[_tokenId] = allTokens.length;
854     allTokens.push(_tokenId);
855   }
856 
857   /**
858    * @dev Internal function to burn a specific token
859    * Reverts if the token does not exist
860    * @param _owner owner of the token to burn
861    * @param _tokenId uint256 ID of the token being burned by the msg.sender
862    */
863   function _burn(address _owner, uint256 _tokenId) internal {
864     super._burn(_owner, _tokenId);
865 
866     // Clear metadata (if any)
867     if (bytes(tokenURIs[_tokenId]).length != 0) {
868       delete tokenURIs[_tokenId];
869     }
870 
871     // Reorg all tokens array
872     uint256 tokenIndex = allTokensIndex[_tokenId];
873     uint256 lastTokenIndex = allTokens.length.sub(1);
874     uint256 lastToken = allTokens[lastTokenIndex];
875 
876     allTokens[tokenIndex] = lastToken;
877     allTokens[lastTokenIndex] = 0;
878 
879     allTokens.length--;
880     allTokensIndex[_tokenId] = 0;
881     allTokensIndex[lastToken] = tokenIndex;
882   }
883 
884 }
885 
886 
887 
888 /*
889  * @title String & slice utility library for Solidity contracts.
890  * @author Nick Johnson <arachnid@notdot.net>
891  *
892  * @dev Functionality in this library is largely implemented using an
893  *      abstraction called a 'slice'. A slice represents a part of a string -
894  *      anything from the entire string to a single character, or even no
895  *      characters at all (a 0-length slice). Since a slice only has to specify
896  *      an offset and a length, copying and manipulating slices is a lot less
897  *      expensive than copying and manipulating the strings they reference.
898  *
899  *      To further reduce gas costs, most functions on slice that need to return
900  *      a slice modify the original one instead of allocating a new one; for
901  *      instance, `s.split(".")` will return the text up to the first '.',
902  *      modifying s to only contain the remainder of the string after the '.'.
903  *      In situations where you do not want to modify the original slice, you
904  *      can make a copy first with `.copy()`, for example:
905  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
906  *      Solidity has no memory management, it will result in allocating many
907  *      short-lived slices that are later discarded.
908  *
909  *      Functions that return two slices come in two versions: a non-allocating
910  *      version that takes the second slice as an argument, modifying it in
911  *      place, and an allocating version that allocates and returns the second
912  *      slice; see `nextRune` for example.
913  *
914  *      Functions that have to copy string data will return strings rather than
915  *      slices; these can be cast back to slices for further processing if
916  *      required.
917  *
918  *      For convenience, some functions are provided with non-modifying
919  *      variants that create a new slice and return both; for instance,
920  *      `s.splitNew('.')` leaves s unmodified, and returns two values
921  *      corresponding to the left and right parts of the string.
922  */
923 
924 library strings {
925     struct slice {
926         uint _len;
927         uint _ptr;
928     }
929 
930     function memcpy(uint dest, uint src, uint len) private pure {
931         // Copy word-length chunks while possible
932         for(; len >= 32; len -= 32) {
933             assembly {
934                 mstore(dest, mload(src))
935             }
936             dest += 32;
937             src += 32;
938         }
939 
940         // Copy remaining bytes
941         uint mask = 256 ** (32 - len) - 1;
942         assembly {
943             let srcpart := and(mload(src), not(mask))
944             let destpart := and(mload(dest), mask)
945             mstore(dest, or(destpart, srcpart))
946         }
947     }
948 
949     /*
950      * @dev Returns a slice containing the entire string.
951      * @param self The string to make a slice from.
952      * @return A newly allocated slice containing the entire string.
953      */
954     function toSlice(string memory self) internal pure returns (slice memory) {
955         uint ptr;
956         assembly {
957             ptr := add(self, 0x20)
958         }
959         return slice(bytes(self).length, ptr);
960     }
961 
962     /*
963      * @dev Returns the length of a null-terminated bytes32 string.
964      * @param self The value to find the length of.
965      * @return The length of the string, from 0 to 32.
966      */
967     function len(bytes32 self) internal pure returns (uint) {
968         uint ret;
969         if (self == 0)
970             return 0;
971         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
972             ret += 16;
973             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
974         }
975         if (self & 0xffffffffffffffff == 0) {
976             ret += 8;
977             self = bytes32(uint(self) / 0x10000000000000000);
978         }
979         if (self & 0xffffffff == 0) {
980             ret += 4;
981             self = bytes32(uint(self) / 0x100000000);
982         }
983         if (self & 0xffff == 0) {
984             ret += 2;
985             self = bytes32(uint(self) / 0x10000);
986         }
987         if (self & 0xff == 0) {
988             ret += 1;
989         }
990         return 32 - ret;
991     }
992 
993     /*
994      * @dev Returns a slice containing the entire bytes32, interpreted as a
995      *      null-terminated utf-8 string.
996      * @param self The bytes32 value to convert to a slice.
997      * @return A new slice containing the value of the input argument up to the
998      *         first null.
999      */
1000     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1001         // Allocate space for `self` in memory, copy it there, and point ret at it
1002         assembly {
1003             let ptr := mload(0x40)
1004             mstore(0x40, add(ptr, 0x20))
1005             mstore(ptr, self)
1006             mstore(add(ret, 0x20), ptr)
1007         }
1008         ret._len = len(self);
1009     }
1010 
1011     /*
1012      * @dev Returns a new slice containing the same data as the current slice.
1013      * @param self The slice to copy.
1014      * @return A new slice containing the same data as `self`.
1015      */
1016     function copy(slice memory self) internal pure returns (slice memory) {
1017         return slice(self._len, self._ptr);
1018     }
1019 
1020     /*
1021      * @dev Copies a slice to a new string.
1022      * @param self The slice to copy.
1023      * @return A newly allocated string containing the slice's text.
1024      */
1025     function toString(slice memory self) internal pure returns (string memory) {
1026         string memory ret = new string(self._len);
1027         uint retptr;
1028         assembly { retptr := add(ret, 32) }
1029 
1030         memcpy(retptr, self._ptr, self._len);
1031         return ret;
1032     }
1033 
1034     /*
1035      * @dev Returns the length in runes of the slice. Note that this operation
1036      *      takes time proportional to the length of the slice; avoid using it
1037      *      in loops, and call `slice.empty()` if you only need to know whether
1038      *      the slice is empty or not.
1039      * @param self The slice to operate on.
1040      * @return The length of the slice in runes.
1041      */
1042     function len(slice memory self) internal pure returns (uint l) {
1043         // Starting at ptr-31 means the LSB will be the byte we care about
1044         uint ptr = self._ptr - 31;
1045         uint end = ptr + self._len;
1046         for (l = 0; ptr < end; l++) {
1047             uint8 b;
1048             assembly { b := and(mload(ptr), 0xFF) }
1049             if (b < 0x80) {
1050                 ptr += 1;
1051             } else if(b < 0xE0) {
1052                 ptr += 2;
1053             } else if(b < 0xF0) {
1054                 ptr += 3;
1055             } else if(b < 0xF8) {
1056                 ptr += 4;
1057             } else if(b < 0xFC) {
1058                 ptr += 5;
1059             } else {
1060                 ptr += 6;
1061             }
1062         }
1063     }
1064 
1065     /*
1066      * @dev Returns true if the slice is empty (has a length of 0).
1067      * @param self The slice to operate on.
1068      * @return True if the slice is empty, False otherwise.
1069      */
1070     function empty(slice memory self) internal pure returns (bool) {
1071         return self._len == 0;
1072     }
1073 
1074     /*
1075      * @dev Returns a positive number if `other` comes lexicographically after
1076      *      `self`, a negative number if it comes before, or zero if the
1077      *      contents of the two slices are equal. Comparison is done per-rune,
1078      *      on unicode codepoints.
1079      * @param self The first slice to compare.
1080      * @param other The second slice to compare.
1081      * @return The result of the comparison.
1082      */
1083     function compare(slice memory self, slice memory other) internal pure returns (int) {
1084         uint shortest = self._len;
1085         if (other._len < self._len)
1086             shortest = other._len;
1087 
1088         uint selfptr = self._ptr;
1089         uint otherptr = other._ptr;
1090         for (uint idx = 0; idx < shortest; idx += 32) {
1091             uint a;
1092             uint b;
1093             assembly {
1094                 a := mload(selfptr)
1095                 b := mload(otherptr)
1096             }
1097             if (a != b) {
1098                 // Mask out irrelevant bytes and check again
1099                 uint256 mask = uint256(-1); // 0xffff...
1100                 if(shortest < 32) {
1101                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1102                 }
1103                 uint256 diff = (a & mask) - (b & mask);
1104                 if (diff != 0)
1105                     return int(diff);
1106             }
1107             selfptr += 32;
1108             otherptr += 32;
1109         }
1110         return int(self._len) - int(other._len);
1111     }
1112 
1113     /*
1114      * @dev Returns true if the two slices contain the same text.
1115      * @param self The first slice to compare.
1116      * @param self The second slice to compare.
1117      * @return True if the slices are equal, false otherwise.
1118      */
1119     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1120         return compare(self, other) == 0;
1121     }
1122 
1123     /*
1124      * @dev Extracts the first rune in the slice into `rune`, advancing the
1125      *      slice to point to the next rune and returning `self`.
1126      * @param self The slice to operate on.
1127      * @param rune The slice that will contain the first rune.
1128      * @return `rune`.
1129      */
1130     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1131         rune._ptr = self._ptr;
1132 
1133         if (self._len == 0) {
1134             rune._len = 0;
1135             return rune;
1136         }
1137 
1138         uint l;
1139         uint b;
1140         // Load the first byte of the rune into the LSBs of b
1141         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1142         if (b < 0x80) {
1143             l = 1;
1144         } else if(b < 0xE0) {
1145             l = 2;
1146         } else if(b < 0xF0) {
1147             l = 3;
1148         } else {
1149             l = 4;
1150         }
1151 
1152         // Check for truncated codepoints
1153         if (l > self._len) {
1154             rune._len = self._len;
1155             self._ptr += self._len;
1156             self._len = 0;
1157             return rune;
1158         }
1159 
1160         self._ptr += l;
1161         self._len -= l;
1162         rune._len = l;
1163         return rune;
1164     }
1165 
1166     /*
1167      * @dev Returns the first rune in the slice, advancing the slice to point
1168      *      to the next rune.
1169      * @param self The slice to operate on.
1170      * @return A slice containing only the first rune from `self`.
1171      */
1172     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1173         nextRune(self, ret);
1174     }
1175 
1176     /*
1177      * @dev Returns the number of the first codepoint in the slice.
1178      * @param self The slice to operate on.
1179      * @return The number of the first codepoint in the slice.
1180      */
1181     function ord(slice memory self) internal pure returns (uint ret) {
1182         if (self._len == 0) {
1183             return 0;
1184         }
1185 
1186         uint word;
1187         uint length;
1188         uint divisor = 2 ** 248;
1189 
1190         // Load the rune into the MSBs of b
1191         assembly { word:= mload(mload(add(self, 32))) }
1192         uint b = word / divisor;
1193         if (b < 0x80) {
1194             ret = b;
1195             length = 1;
1196         } else if(b < 0xE0) {
1197             ret = b & 0x1F;
1198             length = 2;
1199         } else if(b < 0xF0) {
1200             ret = b & 0x0F;
1201             length = 3;
1202         } else {
1203             ret = b & 0x07;
1204             length = 4;
1205         }
1206 
1207         // Check for truncated codepoints
1208         if (length > self._len) {
1209             return 0;
1210         }
1211 
1212         for (uint i = 1; i < length; i++) {
1213             divisor = divisor / 256;
1214             b = (word / divisor) & 0xFF;
1215             if (b & 0xC0 != 0x80) {
1216                 // Invalid UTF-8 sequence
1217                 return 0;
1218             }
1219             ret = (ret * 64) | (b & 0x3F);
1220         }
1221 
1222         return ret;
1223     }
1224 
1225     /*
1226      * @dev Returns the keccak-256 hash of the slice.
1227      * @param self The slice to hash.
1228      * @return The hash of the slice.
1229      */
1230     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1231         assembly {
1232             ret := keccak256(mload(add(self, 32)), mload(self))
1233         }
1234     }
1235 
1236     /*
1237      * @dev Returns true if `self` starts with `needle`.
1238      * @param self The slice to operate on.
1239      * @param needle The slice to search for.
1240      * @return True if the slice starts with the provided text, false otherwise.
1241      */
1242     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1243         if (self._len < needle._len) {
1244             return false;
1245         }
1246 
1247         if (self._ptr == needle._ptr) {
1248             return true;
1249         }
1250 
1251         bool equal;
1252         assembly {
1253             let length := mload(needle)
1254             let selfptr := mload(add(self, 0x20))
1255             let needleptr := mload(add(needle, 0x20))
1256             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1257         }
1258         return equal;
1259     }
1260 
1261     /*
1262      * @dev If `self` starts with `needle`, `needle` is removed from the
1263      *      beginning of `self`. Otherwise, `self` is unmodified.
1264      * @param self The slice to operate on.
1265      * @param needle The slice to search for.
1266      * @return `self`
1267      */
1268     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1269         if (self._len < needle._len) {
1270             return self;
1271         }
1272 
1273         bool equal = true;
1274         if (self._ptr != needle._ptr) {
1275             assembly {
1276                 let length := mload(needle)
1277                 let selfptr := mload(add(self, 0x20))
1278                 let needleptr := mload(add(needle, 0x20))
1279                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1280             }
1281         }
1282 
1283         if (equal) {
1284             self._len -= needle._len;
1285             self._ptr += needle._len;
1286         }
1287 
1288         return self;
1289     }
1290 
1291     /*
1292      * @dev Returns true if the slice ends with `needle`.
1293      * @param self The slice to operate on.
1294      * @param needle The slice to search for.
1295      * @return True if the slice starts with the provided text, false otherwise.
1296      */
1297     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1298         if (self._len < needle._len) {
1299             return false;
1300         }
1301 
1302         uint selfptr = self._ptr + self._len - needle._len;
1303 
1304         if (selfptr == needle._ptr) {
1305             return true;
1306         }
1307 
1308         bool equal;
1309         assembly {
1310             let length := mload(needle)
1311             let needleptr := mload(add(needle, 0x20))
1312             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1313         }
1314 
1315         return equal;
1316     }
1317 
1318     /*
1319      * @dev If `self` ends with `needle`, `needle` is removed from the
1320      *      end of `self`. Otherwise, `self` is unmodified.
1321      * @param self The slice to operate on.
1322      * @param needle The slice to search for.
1323      * @return `self`
1324      */
1325     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1326         if (self._len < needle._len) {
1327             return self;
1328         }
1329 
1330         uint selfptr = self._ptr + self._len - needle._len;
1331         bool equal = true;
1332         if (selfptr != needle._ptr) {
1333             assembly {
1334                 let length := mload(needle)
1335                 let needleptr := mload(add(needle, 0x20))
1336                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1337             }
1338         }
1339 
1340         if (equal) {
1341             self._len -= needle._len;
1342         }
1343 
1344         return self;
1345     }
1346 
1347     // Returns the memory address of the first byte of the first occurrence of
1348     // `needle` in `self`, or the first byte after `self` if not found.
1349     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1350         uint ptr = selfptr;
1351         uint idx;
1352 
1353         if (needlelen <= selflen) {
1354             if (needlelen <= 32) {
1355                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1356 
1357                 bytes32 needledata;
1358                 assembly { needledata := and(mload(needleptr), mask) }
1359 
1360                 uint end = selfptr + selflen - needlelen;
1361                 bytes32 ptrdata;
1362                 assembly { ptrdata := and(mload(ptr), mask) }
1363 
1364                 while (ptrdata != needledata) {
1365                     if (ptr >= end)
1366                         return selfptr + selflen;
1367                     ptr++;
1368                     assembly { ptrdata := and(mload(ptr), mask) }
1369                 }
1370                 return ptr;
1371             } else {
1372                 // For long needles, use hashing
1373                 bytes32 hash;
1374                 assembly { hash := keccak256(needleptr, needlelen) }
1375 
1376                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1377                     bytes32 testHash;
1378                     assembly { testHash := keccak256(ptr, needlelen) }
1379                     if (hash == testHash)
1380                         return ptr;
1381                     ptr += 1;
1382                 }
1383             }
1384         }
1385         return selfptr + selflen;
1386     }
1387 
1388     // Returns the memory address of the first byte after the last occurrence of
1389     // `needle` in `self`, or the address of `self` if not found.
1390     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1391         uint ptr;
1392 
1393         if (needlelen <= selflen) {
1394             if (needlelen <= 32) {
1395                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1396 
1397                 bytes32 needledata;
1398                 assembly { needledata := and(mload(needleptr), mask) }
1399 
1400                 ptr = selfptr + selflen - needlelen;
1401                 bytes32 ptrdata;
1402                 assembly { ptrdata := and(mload(ptr), mask) }
1403 
1404                 while (ptrdata != needledata) {
1405                     if (ptr <= selfptr)
1406                         return selfptr;
1407                     ptr--;
1408                     assembly { ptrdata := and(mload(ptr), mask) }
1409                 }
1410                 return ptr + needlelen;
1411             } else {
1412                 // For long needles, use hashing
1413                 bytes32 hash;
1414                 assembly { hash := keccak256(needleptr, needlelen) }
1415                 ptr = selfptr + (selflen - needlelen);
1416                 while (ptr >= selfptr) {
1417                     bytes32 testHash;
1418                     assembly { testHash := keccak256(ptr, needlelen) }
1419                     if (hash == testHash)
1420                         return ptr + needlelen;
1421                     ptr -= 1;
1422                 }
1423             }
1424         }
1425         return selfptr;
1426     }
1427 
1428     /*
1429      * @dev Modifies `self` to contain everything from the first occurrence of
1430      *      `needle` to the end of the slice. `self` is set to the empty slice
1431      *      if `needle` is not found.
1432      * @param self The slice to search and modify.
1433      * @param needle The text to search for.
1434      * @return `self`.
1435      */
1436     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
1437         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1438         self._len -= ptr - self._ptr;
1439         self._ptr = ptr;
1440         return self;
1441     }
1442 
1443     /*
1444      * @dev Modifies `self` to contain the part of the string from the start of
1445      *      `self` to the end of the first occurrence of `needle`. If `needle`
1446      *      is not found, `self` is set to the empty slice.
1447      * @param self The slice to search and modify.
1448      * @param needle The text to search for.
1449      * @return `self`.
1450      */
1451     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
1452         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1453         self._len = ptr - self._ptr;
1454         return self;
1455     }
1456 
1457     /*
1458      * @dev Splits the slice, setting `self` to everything after the first
1459      *      occurrence of `needle`, and `token` to everything before it. If
1460      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1461      *      and `token` is set to the entirety of `self`.
1462      * @param self The slice to split.
1463      * @param needle The text to search for in `self`.
1464      * @param token An output parameter to which the first token is written.
1465      * @return `token`.
1466      */
1467     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1468         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1469         token._ptr = self._ptr;
1470         token._len = ptr - self._ptr;
1471         if (ptr == self._ptr + self._len) {
1472             // Not found
1473             self._len = 0;
1474         } else {
1475             self._len -= token._len + needle._len;
1476             self._ptr = ptr + needle._len;
1477         }
1478         return token;
1479     }
1480 
1481     /*
1482      * @dev Splits the slice, setting `self` to everything after the first
1483      *      occurrence of `needle`, and returning everything before it. If
1484      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1485      *      and the entirety of `self` is returned.
1486      * @param self The slice to split.
1487      * @param needle The text to search for in `self`.
1488      * @return The part of `self` up to the first occurrence of `delim`.
1489      */
1490     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1491         split(self, needle, token);
1492     }
1493 
1494     /*
1495      * @dev Splits the slice, setting `self` to everything before the last
1496      *      occurrence of `needle`, and `token` to everything after it. If
1497      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1498      *      and `token` is set to the entirety of `self`.
1499      * @param self The slice to split.
1500      * @param needle The text to search for in `self`.
1501      * @param token An output parameter to which the first token is written.
1502      * @return `token`.
1503      */
1504     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1505         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1506         token._ptr = ptr;
1507         token._len = self._len - (ptr - self._ptr);
1508         if (ptr == self._ptr) {
1509             // Not found
1510             self._len = 0;
1511         } else {
1512             self._len -= token._len + needle._len;
1513         }
1514         return token;
1515     }
1516 
1517     /*
1518      * @dev Splits the slice, setting `self` to everything before the last
1519      *      occurrence of `needle`, and returning everything after it. If
1520      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1521      *      and the entirety of `self` is returned.
1522      * @param self The slice to split.
1523      * @param needle The text to search for in `self`.
1524      * @return The part of `self` after the last occurrence of `delim`.
1525      */
1526     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1527         rsplit(self, needle, token);
1528     }
1529 
1530     /*
1531      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1532      * @param self The slice to search.
1533      * @param needle The text to search for in `self`.
1534      * @return The number of occurrences of `needle` found in `self`.
1535      */
1536     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
1537         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1538         while (ptr <= self._ptr + self._len) {
1539             cnt++;
1540             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1541         }
1542     }
1543 
1544     /*
1545      * @dev Returns True if `self` contains `needle`.
1546      * @param self The slice to search.
1547      * @param needle The text to search for in `self`.
1548      * @return True if `needle` is found in `self`, false otherwise.
1549      */
1550     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
1551         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1552     }
1553 
1554     /*
1555      * @dev Returns a newly allocated string containing the concatenation of
1556      *      `self` and `other`.
1557      * @param self The first slice to concatenate.
1558      * @param other The second slice to concatenate.
1559      * @return The concatenation of the two strings.
1560      */
1561     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1562         string memory ret = new string(self._len + other._len);
1563         uint retptr;
1564         assembly { retptr := add(ret, 32) }
1565         memcpy(retptr, self._ptr, self._len);
1566         memcpy(retptr + self._len, other._ptr, other._len);
1567         return ret;
1568     }
1569 
1570     /*
1571      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1572      *      newly allocated string.
1573      * @param self The delimiter to use.
1574      * @param parts A list of slices to join.
1575      * @return A newly allocated string containing all the slices in `parts`,
1576      *         joined with `self`.
1577      */
1578     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1579         if (parts.length == 0)
1580             return "";
1581 
1582         uint length = self._len * (parts.length - 1);
1583         for(uint i = 0; i < parts.length; i++)
1584             length += parts[i]._len;
1585 
1586         string memory ret = new string(length);
1587         uint retptr;
1588         assembly { retptr := add(ret, 32) }
1589 
1590         for(i = 0; i < parts.length; i++) {
1591             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1592             retptr += parts[i]._len;
1593             if (i < parts.length - 1) {
1594                 memcpy(retptr, self._ptr, self._len);
1595                 retptr += self._len;
1596             }
1597         }
1598 
1599         return ret;
1600     }
1601 }
1602 
1603 contract CarFactory is Ownable {
1604     using strings for *;
1605 
1606     uint256 public constant MAX_CARS = 30000 + 150000 + 1000000;
1607     uint256 public mintedCars = 0;
1608     address preOrderAddress;
1609     CarToken token;
1610 
1611     mapping(uint256 => uint256) public tankSizes;
1612     mapping(uint256 => uint) public savedTypes;
1613     mapping(uint256 => bool) public giveawayCar;
1614     
1615     mapping(uint => uint256[]) public availableIds;
1616     mapping(uint => uint256) public idCursor;
1617 
1618     event CarMinted(uint256 _tokenId, string _metadata, uint cType);
1619     event CarSellingBeings();
1620 
1621 
1622 
1623     modifier onlyPreOrder {
1624         require(msg.sender == preOrderAddress, "Not authorized");
1625         _;
1626     }
1627 
1628     modifier isInitialized {
1629         require(preOrderAddress != address(0), "No linked preorder");
1630         require(address(token) != address(0), "No linked token");
1631         _;
1632     }
1633 
1634     function uintToString(uint v) internal pure returns (string) {
1635         uint maxlength = 100;
1636         bytes memory reversed = new bytes(maxlength);
1637         uint i = 0;
1638         while (v != 0) {
1639             uint remainder = v % 10;
1640             v = v / 10;
1641             reversed[i++] = byte(48 + remainder);
1642         }
1643         bytes memory s = new bytes(i); // i + 1 is inefficient
1644         for (uint j = 0; j < i; j++) {
1645             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
1646         }
1647         string memory str = string(s);  // memory isn't implicitly convertible to storage
1648         return str; // this was missing
1649     }
1650 
1651     function mintFor(uint cType, address newOwner) public onlyPreOrder isInitialized returns (uint256) {
1652         require(mintedCars < MAX_CARS, "Factory has minted the max number of cars");
1653         
1654         uint256 _tokenId = nextAvailableId(cType);
1655         require(!token.exists(_tokenId), "Token already exists");
1656 
1657         string memory id = uintToString(_tokenId).toSlice().concat(".json".toSlice());
1658 
1659         uint256 tankSize = tankSizes[_tokenId];
1660         string memory _metadata = "https://vault.warriders.com/".toSlice().concat(id.toSlice());
1661 
1662         token.mint(_tokenId, _metadata, cType, tankSize, newOwner);
1663         mintedCars++;
1664         
1665         return _tokenId;
1666     }
1667 
1668     function giveaway(uint256 _tokenId, uint256 _tankSize, uint cType, bool markCar, address dst) public onlyOwner isInitialized {
1669         require(dst != address(0), "No destination address given");
1670         require(!token.exists(_tokenId), "Token already exists");
1671         require(dst != owner);
1672         require(dst != address(this));
1673         require(_tankSize <= token.maxTankSizes(cType));
1674             
1675         tankSizes[_tokenId] = _tankSize;
1676         savedTypes[_tokenId] = cType;
1677 
1678         string memory id = uintToString(_tokenId).toSlice().concat(".json".toSlice());
1679         string memory _metadata = "https://vault.warriders.com/".toSlice().concat(id.toSlice());
1680 
1681         token.mint(_tokenId, _metadata, cType, _tankSize, dst);
1682         mintedCars++;
1683 
1684         giveawayCar[_tokenId] = markCar;
1685     }
1686 
1687     function setTokenMeta(uint256[] _tokenIds, uint256[] ts, uint[] cTypes) public onlyOwner isInitialized {
1688         for (uint i = 0; i < _tokenIds.length; i++) {
1689             uint256 _tokenId = _tokenIds[i];
1690             uint cType = cTypes[i];
1691             uint256 _tankSize = ts[i];
1692 
1693             require(_tankSize <= token.maxTankSizes(cType));
1694             
1695             tankSizes[_tokenId] = _tankSize;
1696             savedTypes[_tokenId] = cType;
1697             
1698             
1699             availableIds[cTypes[i]].push(_tokenId);
1700         }
1701     }
1702     
1703     function nextAvailableId(uint cType) private returns (uint256) {
1704         uint256 currentCursor = idCursor[cType];
1705         
1706         require(currentCursor < availableIds[cType].length);
1707         
1708         uint256 nextId = availableIds[cType][currentCursor];
1709         idCursor[cType] = currentCursor + 1;
1710         return nextId;
1711     }
1712 
1713     /**
1714     Attach the preOrder that will be receiving tokens being marked for sale by the
1715     sellCar function
1716     */
1717     function attachPreOrder(address dst) public onlyOwner {
1718         require(preOrderAddress == address(0));
1719         require(dst != address(0));
1720 
1721         //Enforce that address is indeed a preorder
1722         PreOrder preOrder = PreOrder(dst);
1723 
1724         preOrderAddress = address(preOrder);
1725     }
1726 
1727     /**
1728     Attach the token being used for things
1729     */
1730     function attachToken(address dst) public onlyOwner {
1731         require(address(token) == address(0));
1732         require(dst != address(0));
1733 
1734         //Enforce that address is indeed a preorder
1735         CarToken ct = CarToken(dst);
1736 
1737         token = ct;
1738     }
1739 }
1740 
1741 contract CarToken is ERC721Token, Ownable {
1742     using strings for *;
1743     
1744     address factory;
1745 
1746     /*
1747     * Car Types:
1748     * 0 - Unknown
1749     * 1 - SUV
1750     * 2 - Truck
1751     * 3 - Hovercraft
1752     * 4 - Tank
1753     * 5 - Lambo
1754     * 6 - Buggy
1755     * 7 - midgrade type 2
1756     * 8 - midgrade type 3
1757     * 9 - Hatchback
1758     * 10 - regular type 2
1759     * 11 - regular type 3
1760     */
1761     uint public constant UNKNOWN_TYPE = 0;
1762     uint public constant SUV_TYPE = 1;
1763     uint public constant TANKER_TYPE = 2;
1764     uint public constant HOVERCRAFT_TYPE = 3;
1765     uint public constant TANK_TYPE = 4;
1766     uint public constant LAMBO_TYPE = 5;
1767     uint public constant DUNE_BUGGY = 6;
1768     uint public constant MIDGRADE_TYPE2 = 7;
1769     uint public constant MIDGRADE_TYPE3 = 8;
1770     uint public constant HATCHBACK = 9;
1771     uint public constant REGULAR_TYPE2 = 10;
1772     uint public constant REGULAR_TYPE3 = 11;
1773     
1774     string public constant METADATA_URL = "https://vault.warriders.com/";
1775     
1776     //Number of premium type cars
1777     uint public PREMIUM_TYPE_COUNT = 5;
1778     //Number of midgrade type cars
1779     uint public MIDGRADE_TYPE_COUNT = 3;
1780     //Number of regular type cars
1781     uint public REGULAR_TYPE_COUNT = 3;
1782 
1783     mapping(uint256 => uint256) public maxBznTankSizeOfPremiumCarWithIndex;
1784     mapping(uint256 => uint256) public maxBznTankSizeOfMidGradeCarWithIndex;
1785     mapping(uint256 => uint256) public maxBznTankSizeOfRegularCarWithIndex;
1786 
1787     /**
1788      * Whether any given car (tokenId) is special
1789      */
1790     mapping(uint256 => bool) public isSpecial;
1791     /**
1792      * The type of any given car (tokenId)
1793      */
1794     mapping(uint256 => uint) public carType;
1795     /**
1796      * The total supply for any given type (int)
1797      */
1798     mapping(uint => uint256) public carTypeTotalSupply;
1799     /**
1800      * The current supply for any given type (int)
1801      */
1802     mapping(uint => uint256) public carTypeSupply;
1803     /**
1804      * Whether any given type (int) is special
1805      */
1806     mapping(uint => bool) public isTypeSpecial;
1807 
1808     /**
1809     * How much BZN any given car (tokenId) can hold
1810     */
1811     mapping(uint256 => uint256) public tankSizes;
1812     
1813     /**
1814      * Given any car type (uint), get the max tank size for that type (uint256)
1815      */
1816     mapping(uint => uint256) public maxTankSizes;
1817     
1818     mapping (uint => uint[]) public premiumTotalSupplyForCar;
1819     mapping (uint => uint[]) public midGradeTotalSupplyForCar;
1820     mapping (uint => uint[]) public regularTotalSupplyForCar;
1821 
1822     modifier onlyFactory {
1823         require(msg.sender == factory, "Not authorized");
1824         _;
1825     }
1826 
1827     constructor(address factoryAddress) public ERC721Token("WarRiders", "WR") {
1828         factory = factoryAddress;
1829 
1830         carTypeTotalSupply[UNKNOWN_TYPE] = 0; //Unknown
1831         carTypeTotalSupply[SUV_TYPE] = 20000; //SUV
1832         carTypeTotalSupply[TANKER_TYPE] = 9000; //Tanker
1833         carTypeTotalSupply[HOVERCRAFT_TYPE] = 600; //Hovercraft
1834         carTypeTotalSupply[TANK_TYPE] = 300; //Tank
1835         carTypeTotalSupply[LAMBO_TYPE] = 100; //Lambo
1836         carTypeTotalSupply[DUNE_BUGGY] = 40000; //migrade type 1
1837         carTypeTotalSupply[MIDGRADE_TYPE2] = 50000; //midgrade type 2
1838         carTypeTotalSupply[MIDGRADE_TYPE3] = 60000; //midgrade type 3
1839         carTypeTotalSupply[HATCHBACK] = 200000; //regular type 1
1840         carTypeTotalSupply[REGULAR_TYPE2] = 300000; //regular type 2
1841         carTypeTotalSupply[REGULAR_TYPE3] = 500000; //regular type 3
1842         
1843         maxTankSizes[SUV_TYPE] = 200; //SUV tank size
1844         maxTankSizes[TANKER_TYPE] = 450; //Tanker tank size
1845         maxTankSizes[HOVERCRAFT_TYPE] = 300; //Hovercraft tank size
1846         maxTankSizes[TANK_TYPE] = 200; //Tank tank size
1847         maxTankSizes[LAMBO_TYPE] = 250; //Lambo tank size
1848         maxTankSizes[DUNE_BUGGY] = 120; //migrade type 1 tank size
1849         maxTankSizes[MIDGRADE_TYPE2] = 110; //midgrade type 2 tank size
1850         maxTankSizes[MIDGRADE_TYPE3] = 100; //midgrade type 3 tank size
1851         maxTankSizes[HATCHBACK] = 90; //regular type 1 tank size
1852         maxTankSizes[REGULAR_TYPE2] = 70; //regular type 2 tank size
1853         maxTankSizes[REGULAR_TYPE3] = 40; //regular type 3 tank size
1854         
1855         maxBznTankSizeOfPremiumCarWithIndex[1] = 200; //SUV tank size
1856         maxBznTankSizeOfPremiumCarWithIndex[2] = 450; //Tanker tank size
1857         maxBznTankSizeOfPremiumCarWithIndex[3] = 300; //Hovercraft tank size
1858         maxBznTankSizeOfPremiumCarWithIndex[4] = 200; //Tank tank size
1859         maxBznTankSizeOfPremiumCarWithIndex[5] = 250; //Lambo tank size
1860         maxBznTankSizeOfMidGradeCarWithIndex[1] = 100; //migrade type 1 tank size
1861         maxBznTankSizeOfMidGradeCarWithIndex[2] = 110; //midgrade type 2 tank size
1862         maxBznTankSizeOfMidGradeCarWithIndex[3] = 120; //midgrade type 3 tank size
1863         maxBznTankSizeOfRegularCarWithIndex[1] = 40; //regular type 1 tank size
1864         maxBznTankSizeOfRegularCarWithIndex[2] = 70; //regular type 2 tank size
1865         maxBznTankSizeOfRegularCarWithIndex[3] = 90; //regular type 3 tank size
1866 
1867         isTypeSpecial[HOVERCRAFT_TYPE] = true;
1868         isTypeSpecial[TANK_TYPE] = true;
1869         isTypeSpecial[LAMBO_TYPE] = true;
1870     }
1871 
1872     function isCarSpecial(uint256 tokenId) public view returns (bool) {
1873         return isSpecial[tokenId];
1874     }
1875 
1876     function getCarType(uint256 tokenId) public view returns (uint) {
1877         return carType[tokenId];
1878     }
1879 
1880     function mint(uint256 _tokenId, string _metadata, uint cType, uint256 tankSize, address newOwner) public onlyFactory {
1881         //Since any invalid car type would have a total supply of 0 
1882         //This require will also enforce that a valid cType is given
1883         require(carTypeSupply[cType] < carTypeTotalSupply[cType], "This type has reached total supply");
1884         
1885         //This will enforce the tank size is less than the max
1886         require(tankSize <= maxTankSizes[cType], "Tank size provided bigger than max for this type");
1887         
1888         if (isPremium(cType)) {
1889             premiumTotalSupplyForCar[cType].push(_tokenId);
1890         } else if (isMidGrade(cType)) {
1891             midGradeTotalSupplyForCar[cType].push(_tokenId);
1892         } else {
1893             regularTotalSupplyForCar[cType].push(_tokenId);
1894         }
1895 
1896         super._mint(newOwner, _tokenId);
1897         super._setTokenURI(_tokenId, _metadata);
1898 
1899         carType[_tokenId] = cType;
1900         isSpecial[_tokenId] = isTypeSpecial[cType];
1901         carTypeSupply[cType] = carTypeSupply[cType] + 1;
1902         tankSizes[_tokenId] = tankSize;
1903     }
1904     
1905     function isPremium(uint cType) public pure returns (bool) {
1906         return cType == SUV_TYPE || cType == TANKER_TYPE || cType == HOVERCRAFT_TYPE || cType == TANK_TYPE || cType == LAMBO_TYPE;
1907     }
1908     
1909     function isMidGrade(uint cType) public pure returns (bool) {
1910         return cType == DUNE_BUGGY || cType == MIDGRADE_TYPE2 || cType == MIDGRADE_TYPE3;
1911     }
1912     
1913     function isRegular(uint cType) public pure returns (bool) {
1914         return cType == HATCHBACK || cType == REGULAR_TYPE2 || cType == REGULAR_TYPE3;
1915     }
1916     
1917     function getTotalSupplyForType(uint cType) public view returns (uint256) {
1918         return carTypeSupply[cType];
1919     }
1920     
1921     function getPremiumCarsForVariant(uint variant) public view returns (uint[]) {
1922         return premiumTotalSupplyForCar[variant];
1923     }
1924     
1925     function getMidgradeCarsForVariant(uint variant) public view returns (uint[]) {
1926         return midGradeTotalSupplyForCar[variant];
1927     }
1928 
1929     function getRegularCarsForVariant(uint variant) public view returns (uint[]) {
1930         return regularTotalSupplyForCar[variant];
1931     }
1932 
1933     function getPremiumCarSupply(uint variant) public view returns (uint) {
1934         return premiumTotalSupplyForCar[variant].length;
1935     }
1936     
1937     function getMidgradeCarSupply(uint variant) public view returns (uint) {
1938         return midGradeTotalSupplyForCar[variant].length;
1939     }
1940 
1941     function getRegularCarSupply(uint variant) public view returns (uint) {
1942         return regularTotalSupplyForCar[variant].length;
1943     }
1944     
1945     function exists(uint256 _tokenId) public view returns (bool) {
1946         return super._exists(_tokenId);
1947     }
1948 }
1949 
1950 contract PreOrder is Destructible {
1951     /**
1952      * The current price for any given type (int)
1953      */
1954     mapping(uint => uint256) public currentTypePrice;
1955 
1956     // Maps Premium car variants to the tokens minted for their description
1957     // INPUT: variant #
1958     // OUTPUT: list of cars
1959     mapping(uint => uint256[]) public premiumCarsBought;
1960     mapping(uint => uint256[]) public midGradeCarsBought;
1961     mapping(uint => uint256[]) public regularCarsBought;
1962     mapping(uint256 => address) public tokenReserve;
1963 
1964     event consumerBulkBuy(uint256[] variants, address reserver, uint category);
1965     event CarBought(uint256 carId, uint256 value, address purchaser, uint category);
1966     event Withdrawal(uint256 amount);
1967 
1968     uint256 public constant COMMISSION_PERCENT = 5;
1969 
1970     //Max number of premium cars
1971     uint256 public constant MAX_PREMIUM = 30000;
1972     //Max number of midgrade cars
1973     uint256 public constant MAX_MIDGRADE = 150000;
1974     //Max number of regular cars
1975     uint256 public constant MAX_REGULAR = 1000000;
1976 
1977     //Max number of premium type cars
1978     uint public PREMIUM_TYPE_COUNT = 5;
1979     //Max number of midgrade type cars
1980     uint public MIDGRADE_TYPE_COUNT = 3;
1981     //Max number of regular type cars
1982     uint public REGULAR_TYPE_COUNT = 3;
1983 
1984     uint private midgrade_offset = 5;
1985     uint private regular_offset = 6;
1986 
1987     uint256 public constant GAS_REQUIREMENT = 250000;
1988 
1989     //Premium type id
1990     uint public constant PREMIUM_CATEGORY = 1;
1991     //Midgrade type id
1992     uint public constant MID_GRADE_CATEGORY = 2;
1993     //Regular type id
1994     uint public constant REGULAR_CATEGORY = 3;
1995     
1996     mapping(address => uint256) internal commissionRate;
1997     
1998     address internal constant OPENSEA = 0x5b3256965e7C3cF26E11FCAf296DfC8807C01073;
1999 
2000     //The percent increase for any given type
2001     mapping(uint => uint256) internal percentIncrease;
2002     mapping(uint => uint256) internal percentBase;
2003     //uint public constant PERCENT_INCREASE = 101;
2004 
2005     //How many car is in each category currently
2006     uint256 public premiumHold = 30000;
2007     uint256 public midGradeHold = 150000;
2008     uint256 public regularHold = 1000000;
2009 
2010     bool public premiumOpen = false;
2011     bool public midgradeOpen = false;
2012     bool public regularOpen = false;
2013 
2014     //Reference to other contracts
2015     CarToken public token;
2016     //AuctionManager public auctionManager;
2017     CarFactory internal factory;
2018 
2019     address internal escrow;
2020 
2021     modifier premiumIsOpen {
2022         //Ensure we are selling at least 1 car
2023         require(premiumHold > 0, "No more premium cars");
2024         require(premiumOpen, "Premium store not open for sale");
2025         _;
2026     }
2027 
2028     modifier midGradeIsOpen {
2029         //Ensure we are selling at least 1 car
2030         require(midGradeHold > 0, "No more midgrade cars");
2031         require(midgradeOpen, "Midgrade store not open for sale");
2032         _;
2033     }
2034 
2035     modifier regularIsOpen {
2036         //Ensure we are selling at least 1 car
2037         require(regularHold > 0, "No more regular cars");
2038         require(regularOpen, "Regular store not open for sale");
2039         _;
2040     }
2041 
2042     modifier onlyFactory {
2043         //Only factory can use this function
2044         require(msg.sender == address(factory), "Not authorized");
2045         _;
2046     }
2047 
2048     modifier onlyFactoryOrOwner {
2049         //Only factory or owner can use this function
2050         require(msg.sender == address(factory) || msg.sender == owner, "Not authorized");
2051         _;
2052     }
2053 
2054     function() public payable { }
2055 
2056     constructor(
2057         address tokenAddress,
2058         address tokenFactory,
2059         address e
2060     ) public {
2061         token = CarToken(tokenAddress);
2062 
2063         factory = CarFactory(tokenFactory);
2064 
2065         escrow = e;
2066 
2067         //Set percent increases
2068         percentIncrease[1] = 100008;
2069         percentBase[1] = 100000;
2070         percentIncrease[2] = 100015;
2071         percentBase[2] = 100000;
2072         percentIncrease[3] = 1002;
2073         percentBase[3] = 1000;
2074         percentIncrease[4] = 1004;
2075         percentBase[4] = 1000;
2076         percentIncrease[5] = 102;
2077         percentBase[5] = 100;
2078         
2079         commissionRate[OPENSEA] = 10;
2080     }
2081     
2082     function setCommission(address referral, uint256 percent) public onlyOwner {
2083         require(percent > COMMISSION_PERCENT);
2084         require(percent < 95);
2085         percent = percent - COMMISSION_PERCENT;
2086         
2087         commissionRate[referral] = percent;
2088     }
2089     
2090     function setPercentIncrease(uint256 increase, uint256 base, uint cType) public onlyOwner {
2091         require(increase > base);
2092         
2093         percentIncrease[cType] = increase;
2094         percentBase[cType] = base;
2095     }
2096 
2097     function openShop(uint category) public onlyOwner {
2098         require(category == 1 || category == 2 || category == 3, "Invalid category");
2099 
2100         if (category == PREMIUM_CATEGORY) {
2101             premiumOpen = true;
2102         } else if (category == MID_GRADE_CATEGORY) {
2103             midgradeOpen = true;
2104         } else if (category == REGULAR_CATEGORY) {
2105             regularOpen = true;
2106         }
2107     }
2108 
2109     /**
2110      * Set the starting price for any given type. Can only be set once, and value must be greater than 0
2111      */
2112     function setTypePrice(uint cType, uint256 price) public onlyOwner {
2113         if (currentTypePrice[cType] == 0) {
2114             require(price > 0, "Price already set");
2115             currentTypePrice[cType] = price;
2116         }
2117     }
2118 
2119     /**
2120     Withdraw the amount from the contract's balance. Only the contract owner can execute this function
2121     */
2122     function withdraw(uint256 amount) public onlyOwner {
2123         uint256 balance = address(this).balance;
2124 
2125         require(amount <= balance, "Requested to much");
2126         owner.transfer(amount);
2127 
2128         emit Withdrawal(amount);
2129     }
2130 
2131     function reserveManyTokens(uint[] cTypes, uint category) public payable returns (bool) {
2132         if (category == PREMIUM_CATEGORY) {
2133             require(premiumOpen, "Premium is not open for sale");
2134         } else if (category == MID_GRADE_CATEGORY) {
2135             require(midgradeOpen, "Midgrade is not open for sale");
2136         } else if (category == REGULAR_CATEGORY) {
2137             require(regularOpen, "Regular is not open for sale");
2138         } else {
2139             revert();
2140         }
2141 
2142         address reserver = msg.sender;
2143 
2144         uint256 ether_required = 0;
2145         for (uint i = 0; i < cTypes.length; i++) {
2146             uint cType = cTypes[i];
2147 
2148             uint256 price = priceFor(cType);
2149 
2150             ether_required += (price + GAS_REQUIREMENT);
2151 
2152             currentTypePrice[cType] = price;
2153         }
2154 
2155         require(msg.value >= ether_required);
2156 
2157         uint256 refundable = msg.value - ether_required;
2158 
2159         escrow.transfer(ether_required);
2160 
2161         if (refundable > 0) {
2162             reserver.transfer(refundable);
2163         }
2164 
2165         emit consumerBulkBuy(cTypes, reserver, category);
2166     }
2167 
2168      function buyBulkPremiumCar(address referal, uint[] variants, address new_owner) public payable premiumIsOpen returns (bool) {
2169          uint n = variants.length;
2170          require(n <= 10, "Max bulk buy is 10 cars");
2171 
2172          for (uint i = 0; i < n; i++) {
2173              buyCar(referal, variants[i], false, new_owner, PREMIUM_CATEGORY);
2174          }
2175      }
2176 
2177      function buyBulkMidGradeCar(address referal, uint[] variants, address new_owner) public payable midGradeIsOpen returns (bool) {
2178          uint n = variants.length;
2179          require(n <= 10, "Max bulk buy is 10 cars");
2180 
2181          for (uint i = 0; i < n; i++) {
2182              buyCar(referal, variants[i], false, new_owner, MID_GRADE_CATEGORY);
2183          }
2184      }
2185 
2186      function buyBulkRegularCar(address referal, uint[] variants, address new_owner) public payable regularIsOpen returns (bool) {
2187          uint n = variants.length;
2188          require(n <= 10, "Max bulk buy is 10 cars");
2189 
2190          for (uint i = 0; i < n; i++) {
2191              buyCar(referal, variants[i], false, new_owner, REGULAR_CATEGORY);
2192          }
2193      }
2194 
2195     function buyCar(address referal, uint cType, bool give_refund, address new_owner, uint category) public payable returns (bool) {
2196         require(category == PREMIUM_CATEGORY || category == MID_GRADE_CATEGORY || category == REGULAR_CATEGORY);
2197         if (category == PREMIUM_CATEGORY) {
2198             require(cType == 1 || cType == 2 || cType == 3 || cType == 4 || cType == 5, "Invalid car type");
2199             require(premiumHold > 0, "No more premium cars");
2200             require(premiumOpen, "Premium store not open for sale");
2201         } else if (category == MID_GRADE_CATEGORY) {
2202             require(cType == 6 || cType == 7 || cType == 8, "Invalid car type");
2203             require(midGradeHold > 0, "No more midgrade cars");
2204             require(midgradeOpen, "Midgrade store not open for sale");
2205         } else if (category == REGULAR_CATEGORY) {
2206             require(cType == 9 || cType == 10 || cType == 11, "Invalid car type");
2207             require(regularHold > 0, "No more regular cars");
2208             require(regularOpen, "Regular store not open for sale");
2209         }
2210 
2211         uint256 price = priceFor(cType);
2212         require(price > 0, "Price not yet set");
2213         require(msg.value >= price, "Not enough ether sent");
2214         /*if (tokenReserve[_tokenId] != address(0)) {
2215             require(new_owner == tokenReserve[_tokenId], "You don't have the rights to buy this token");
2216         }*/
2217         currentTypePrice[cType] = price; //Set new type price
2218 
2219         uint256 _tokenId = factory.mintFor(cType, new_owner); //Now mint the token
2220         
2221         if (category == PREMIUM_CATEGORY) {
2222             premiumCarsBought[cType].push(_tokenId);
2223             premiumHold--;
2224         } else if (category == MID_GRADE_CATEGORY) {
2225             midGradeCarsBought[cType - 5].push(_tokenId);
2226             midGradeHold--;
2227         } else if (category == REGULAR_CATEGORY) {
2228             regularCarsBought[cType - 8].push(_tokenId);
2229             regularHold--;
2230         }
2231 
2232         if (give_refund && msg.value > price) {
2233             uint256 change = msg.value - price;
2234 
2235             msg.sender.transfer(change);
2236         }
2237 
2238         if (referal != address(0)) {
2239             require(referal != msg.sender, "The referal cannot be the sender");
2240             require(referal != tx.origin, "The referal cannot be the tranaction origin");
2241             require(referal != new_owner, "The referal cannot be the new owner");
2242 
2243             //The commissionRate map adds any partner bonuses, or 0 if a normal user referral
2244             uint256 totalCommision = COMMISSION_PERCENT + commissionRate[referal];
2245 
2246             uint256 commision = (price * totalCommision) / 100;
2247 
2248             referal.transfer(commision);
2249         }
2250 
2251         emit CarBought(_tokenId, price, new_owner, category);
2252     }
2253 
2254     /**
2255     Get the price for any car with the given _tokenId
2256     */
2257     function priceFor(uint cType) public view returns (uint256) {
2258         uint256 percent = percentIncrease[cType];
2259         uint256 base = percentBase[cType];
2260 
2261         uint256 currentPrice = currentTypePrice[cType];
2262         uint256 nextPrice = (currentPrice * percent);
2263 
2264         //Return the next price, as this is the true price
2265         return nextPrice / base;
2266     }
2267 
2268     function sold(uint256 _tokenId) public view returns (bool) {
2269         return token.exists(_tokenId);
2270     }
2271 }