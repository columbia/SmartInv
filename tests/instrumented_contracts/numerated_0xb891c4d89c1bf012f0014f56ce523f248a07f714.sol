1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * Utility library of inline functions on addresses
55  */
56 library AddressUtils {
57 
58   /**
59    * Returns whether the target address is a contract
60    * @dev This function will return false if invoked during the constructor of a contract,
61    * as the code is not actually created until after the constructor finishes.
62    * @param addr address to check
63    * @return whether the target address is a contract
64    */
65   function isContract(address addr) internal view returns (bool) {
66     uint256 size;
67     // XXX Currently there is no better way to check if there is a contract in an address
68     // than to check the size of the code at that address.
69     // See https://ethereum.stackexchange.com/a/14016/36603
70     // for more details about how this works.
71     // TODO Check this again before the Serenity release, because all addresses will be
72     // contracts then.
73     // solium-disable-next-line security/no-inline-assembly
74     assembly { size := extcodesize(addr) }
75     return size > 0;
76   }
77 
78 }
79 
80 library UrlStr {
81   
82   // generate url by tokenId
83   // baseUrl must end with 00000000
84   function generateUrl(string url,uint256 _tokenId) internal pure returns (string _url){
85     _url = url;
86     bytes memory _tokenURIBytes = bytes(_url);
87     uint256 base_len = _tokenURIBytes.length - 1;
88     _tokenURIBytes[base_len - 7] = byte(48 + _tokenId / 10000000 % 10);
89     _tokenURIBytes[base_len - 6] = byte(48 + _tokenId / 1000000 % 10);
90     _tokenURIBytes[base_len - 5] = byte(48 + _tokenId / 100000 % 10);
91     _tokenURIBytes[base_len - 4] = byte(48 + _tokenId / 10000 % 10);
92     _tokenURIBytes[base_len - 3] = byte(48 + _tokenId / 1000 % 10);
93     _tokenURIBytes[base_len - 2] = byte(48 + _tokenId / 100 % 10);
94     _tokenURIBytes[base_len - 1] = byte(48 + _tokenId / 10 % 10);
95     _tokenURIBytes[base_len - 0] = byte(48 + _tokenId / 1 % 10);
96   }
97 }
98 
99 
100 /**
101   if a ERC721 item want to mount to avatar, it must to inherit this.
102  */
103 interface AvatarChildService {
104   /**
105       @dev if you want your contract become a avatar child, please let your contract inherit this interface
106       @param _tokenId1  first child token id
107       @param _tokenId2  second child token id
108       @return  true will unmount first token before mount ,false will directly mount child
109    */
110    function compareItemSlots(uint256 _tokenId1, uint256 _tokenId2) external view returns (bool _res);
111 }
112 
113 interface AvatarService {
114   function updateAvatarInfo(address _owner, uint256 _tokenId, string _name, uint256 _dna) external;
115   function createAvatar(address _owner, string _name, uint256 _dna) external  returns(uint256);
116   function getMountTokenIds(address _owner,uint256 _tokenId, address _avatarItemAddress) external view returns(uint256[]); 
117   function getAvatarInfo(uint256 _tokenId) external view returns (string _name, uint256 _dna);
118   function getOwnedTokenIds(address _owner) external view returns(uint256[] _tokenIds);
119 }
120 
121 interface ERC165 {
122   
123   /**
124    * @notice Query if a contract implements an interface
125    * @param _interfaceId The interface identifier, as specified in ERC-165
126    * @dev Interface identification is specified in ERC-165. This function
127    * uses less than 30,000 gas.
128    */
129   function supportsInterface(bytes4 _interfaceId) external view returns (bool);
130 }
131 
132 
133 interface ERC721 /* is ERC165 */ {
134     /// @dev This emits when ownership of any NFT changes by any mechanism.
135     ///  This event emits when NFTs are created (`from` == 0) and destroyed
136     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
137     ///  may be created and assigned without emitting Transfer. At the time of
138     ///  any transfer, the approved address for that NFT (if any) is reset to none.
139     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
140 
141     /// @dev This emits when the approved address for an NFT is changed or
142     ///  reaffirmed. The zero address indicates there is no approved address.
143     ///  When a Transfer event emits, this also indicates that the approved
144     ///  address for that NFT (if any) is reset to none.
145     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
146 
147     /// @dev This emits when an operator is enabled or disabled for an owner.
148     ///  The operator can manage all NFTs of the owner.
149     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
150 
151     /// @notice Count all NFTs assigned to an owner
152     /// @dev NFTs assigned to the zero address are considered invalid, and this
153     ///  function throws for queries about the zero address.
154     /// @param _owner An address for whom to query the balance
155     /// @return The number of NFTs owned by `_owner`, possibly zero
156     function balanceOf(address _owner) external view returns (uint256);
157 
158     /// @notice Find the owner of an NFT
159     /// @dev NFTs assigned to zero address are considered invalid, and queries
160     ///  about them do throw.
161     /// @param _tokenId The identifier for an NFT
162     /// @return The address of the owner of the NFT
163     function ownerOf(uint256 _tokenId) external view returns (address);
164 
165     /// @notice Transfers the ownership of an NFT from one address to another address
166     /// @dev Throws unless `msg.sender` is the current owner, an authorized
167     ///  operator, or the approved address for this NFT. Throws if `_from` is
168     ///  not the current owner. Throws if `_to` is the zero address. Throws if
169     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
170     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
171     ///  `onERC721Received` on `_to` and throws if the return value is not
172     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
173     /// @param _from The current owner of the NFT
174     /// @param _to The new owner
175     /// @param _tokenId The NFT to transfer
176     /// @param data Additional data with no specified format, sent in call to `_to`
177     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
178 
179     /// @notice Transfers the ownership of an NFT from one address to another address
180     /// @dev This works identically to the other function with an extra data parameter,
181     ///  except this function just sets data to "".
182     /// @param _from The current owner of the NFT
183     /// @param _to The new owner
184     /// @param _tokenId The NFT to transfer
185     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
186 
187     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
188     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
189     ///  THEY MAY BE PERMANENTLY LOST
190     /// @dev Throws unless `msg.sender` is the current owner, an authorized
191     ///  operator, or the approved address for this NFT. Throws if `_from` is
192     ///  not the current owner. Throws if `_to` is the zero address. Throws if
193     ///  `_tokenId` is not a valid NFT.
194     /// @param _from The current owner of the NFT
195     /// @param _to The new owner
196     /// @param _tokenId The NFT to transfer
197     function transferFrom(address _from, address _to, uint256 _tokenId) external;
198 
199     /// @notice Change or reaffirm the approved address for an NFT
200     /// @dev The zero address indicates there is no approved address.
201     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
202     ///  operator of the current owner.
203     /// @param _approved The new approved NFT controller
204     /// @param _tokenId The NFT to approve
205     function approve(address _approved, uint256 _tokenId) external;
206 
207     /// @notice Enable or disable approval for a third party ("operator") to manage
208     ///  all of `msg.sender`'s assets
209     /// @dev Emits the ApprovalForAll event. The contract MUST allow
210     ///  multiple operators per owner.
211     /// @param _operator Address to add to the set of authorized operators
212     /// @param _approved True if the operator is approved, false to revoke approval
213     function setApprovalForAll(address _operator, bool _approved) external;
214 
215     /// @notice Get the approved address for a single NFT
216     /// @dev Throws if `_tokenId` is not a valid NFT.
217     /// @param _tokenId The NFT to find the approved address for
218     /// @return The approved address for this NFT, or the zero address if there is none
219     function getApproved(uint256 _tokenId) external view returns (address);
220 
221     /// @notice Query if an address is an authorized operator for another address
222     /// @param _owner The address that owns the NFTs
223     /// @param _operator The address that acts on behalf of the owner
224     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
225     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
226 }
227 
228 
229 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
230 interface ERC721Enumerable /* is ERC721 */ {
231     /// @notice Count NFTs tracked by this contract
232     /// @return A count of valid NFTs tracked by this contract, where each one of
233     ///  them has an assigned and queryable owner not equal to the zero address
234     function totalSupply() external view returns (uint256);
235 
236     /// @notice Enumerate valid NFTs
237     /// @dev Throws if `_index` >= `totalSupply()`.
238     /// @param _index A counter less than `totalSupply()`
239     /// @return The token identifier for the `_index`th NFT,
240     ///  (sort order not specified)
241     function tokenByIndex(uint256 _index) external view returns (uint256);
242 
243     /// @notice Enumerate NFTs assigned to an owner
244     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
245     ///  `_owner` is the zero address, representing invalid NFTs.
246     /// @param _owner An address where we are interested in NFTs owned by them
247     /// @param _index A counter less than `balanceOf(_owner)`
248     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
249     ///   (sort order not specified)
250     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
251 }
252 
253 
254 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
255 interface ERC721Metadata /* is ERC721 */ {
256   /// @notice A descriptive name for a collection of NFTs in this contract
257   function name() external view returns (string _name);
258 
259   /// @notice An abbreviated name for NFTs in this contract
260   function symbol() external view returns (string _symbol);
261 
262   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
263   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
264   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
265   ///  Metadata JSON Schema".
266   function tokenURI(uint256 _tokenId) external view returns (string);
267 }
268 
269 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
270 interface ERC721TokenReceiver {
271     /// @notice Handle the receipt of an NFT
272     /// @dev The ERC721 smart contract calls this function on the recipient
273     ///  after a `transfer`. This function MAY throw to revert and reject the
274     ///  transfer. Return of other than the magic value MUST result in the
275     ///  transaction being reverted.
276     ///  Note: the contract address is always the message sender.
277     /// @param _operator The address which called `safeTransferFrom` function
278     /// @param _from The address which previously owned the token
279     /// @param _tokenId The NFT identifier which is being transferred
280     /// @param _data Additional data with no specified format
281     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
282     ///  unless throwing
283     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
284 }
285 
286 
287 /**
288  * @title SupportsInterfaceWithLookup
289  * @author Matt Condon (@shrugs)
290  * @dev Implements ERC165 using a lookup table.
291  */
292 contract SupportsInterfaceWithLookup is ERC165 {
293   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
294   /**
295    * 0x01ffc9a7 ===
296    *   bytes4(keccak256('supportsInterface(bytes4)'))
297    */
298 
299   /**
300    * @dev a mapping of interface id to whether or not it's supported
301    */
302   mapping(bytes4 => bool) internal supportedInterfaces;
303 
304   /**
305    * @dev A contract implementing SupportsInterfaceWithLookup
306    * implement ERC165 itself
307    */
308   constructor()
309     public
310   {
311     _registerInterface(InterfaceId_ERC165);
312   }
313 
314   /**
315    * @dev implement supportsInterface(bytes4) using a lookup table
316    */
317   function supportsInterface(bytes4 _interfaceId)
318     external
319     view
320     returns (bool)
321   {
322     return supportedInterfaces[_interfaceId];
323   }
324 
325   /**
326    * @dev private method for registering an interface
327    */
328   function _registerInterface(bytes4 _interfaceId)
329     internal
330   {
331     require(_interfaceId != 0xffffffff);
332     supportedInterfaces[_interfaceId] = true;
333   }
334 }
335 
336 
337 /**
338  * @title BitGuildAccessAdmin
339  * @dev Allow two roles: 'owner' or 'operator'
340  *      - owner: admin/superuser (e.g. with financial rights)
341  *      - operator: can update configurations
342  */
343 contract BitGuildAccessAdmin {
344   address public owner;
345   address[] public operators;
346 
347   uint public MAX_OPS = 20; // Default maximum number of operators allowed
348 
349   mapping(address => bool) public isOperator;
350 
351   event OwnershipTransferred(
352       address indexed previousOwner,
353       address indexed newOwner
354   );
355   event OperatorAdded(address operator);
356   event OperatorRemoved(address operator);
357 
358   // @dev The BitGuildAccessAdmin constructor: sets owner to the sender account
359   constructor() public {
360     owner = msg.sender;
361   }
362 
363   // @dev Throws if called by any account other than the owner.
364   modifier onlyOwner() {
365     require(msg.sender == owner);
366     _;
367   }
368 
369   // @dev Throws if called by any non-operator account. Owner has all ops rights.
370   modifier onlyOperator {
371     require(
372       isOperator[msg.sender] || msg.sender == owner,
373       "Permission denied. Must be an operator or the owner.");
374     _;
375   }
376 
377   /**
378     * @dev Allows the current owner to transfer control of the contract to a newOwner.
379     * @param _newOwner The address to transfer ownership to.
380     */
381   function transferOwnership(address _newOwner) public onlyOwner {
382     require(
383       _newOwner != address(0),
384       "Invalid new owner address."
385     );
386     emit OwnershipTransferred(owner, _newOwner);
387     owner = _newOwner;
388   }
389 
390   /**
391     * @dev Allows the current owner or operators to add operators
392     * @param _newOperator New operator address
393     */
394   function addOperator(address _newOperator) public onlyOwner {
395     require(
396       _newOperator != address(0),
397       "Invalid new operator address."
398     );
399 
400     // Make sure no dups
401     require(
402       !isOperator[_newOperator],
403       "New operator exists."
404     );
405 
406     // Only allow so many ops
407     require(
408       operators.length < MAX_OPS,
409       "Overflow."
410     );
411 
412     operators.push(_newOperator);
413     isOperator[_newOperator] = true;
414 
415     emit OperatorAdded(_newOperator);
416   }
417 
418   /**
419     * @dev Allows the current owner or operators to remove operator
420     * @param _operator Address of the operator to be removed
421     */
422   function removeOperator(address _operator) public onlyOwner {
423     // Make sure operators array is not empty
424     require(
425       operators.length > 0,
426       "No operator."
427     );
428 
429     // Make sure the operator exists
430     require(
431       isOperator[_operator],
432       "Not an operator."
433     );
434 
435     // Manual array manipulation:
436     // - replace the _operator with last operator in array
437     // - remove the last item from array
438     address lastOperator = operators[operators.length - 1];
439     for (uint i = 0; i < operators.length; i++) {
440       if (operators[i] == _operator) {
441         operators[i] = lastOperator;
442       }
443     }
444     operators.length -= 1; // remove the last element
445 
446     isOperator[_operator] = false;
447     emit OperatorRemoved(_operator);
448   }
449 
450   // @dev Remove ALL operators
451   function removeAllOps() public onlyOwner {
452     for (uint i = 0; i < operators.length; i++) {
453       isOperator[operators[i]] = false;
454     }
455     operators.length = 0;
456   } 
457 
458 }
459 
460 
461 contract BitGuildAccessAdminExtend is BitGuildAccessAdmin {
462 
463   event FrozenFunds(address target, bool frozen);
464 
465   bool public isPaused = false;
466   
467   mapping(address => bool)  frozenAccount;
468 
469   modifier whenNotPaused {
470     require(!isPaused);
471     _;
472   }
473 
474   modifier whenPaused {
475     require(isPaused);
476     _;  
477   }
478 
479   function doPause() external  whenNotPaused onlyOwner {
480     isPaused = true;
481   }
482 
483   function doUnpause() external  whenPaused onlyOwner {
484     isPaused = false;
485   }
486 
487   function freezeAccount(address target, bool freeze) public onlyOwner {
488     frozenAccount[target] = freeze;
489     emit FrozenFunds(target, freeze);
490   }
491 
492 }
493 
494 
495 interface ERC998ERC721TopDown {
496   event ReceivedChild(address indexed _from, uint256 indexed _tokenId, address indexed _childContract, uint256 _childTokenId);
497   event TransferChild(uint256 indexed tokenId, address indexed _to, address indexed _childContract, uint256 _childTokenId);
498   // gets the address and token that owns the supplied tokenId. isParent says if parentTokenId is a parent token or not.
499   function tokenOwnerOf(uint256 _tokenId) external view returns (address tokenOwner, uint256 parentTokenId, uint256 isParent);
500   function ownerOfChild(address _childContract, uint256 _childTokenId) external view returns (uint256 parentTokenId, uint256 isParent);
501   function onERC721Received(address _operator, address _from, uint256 _childTokenId, bytes _data) external returns(bytes4);
502   function onERC998Removed(address _operator, address _toContract, uint256 _childTokenId, bytes _data) external;
503   function transferChild(address _to, address _childContract, uint256 _childTokenId) external;
504   function safeTransferChild(address _to, address _childContract, uint256 _childTokenId) external;
505   function safeTransferChild(address _to, address _childContract, uint256 _childTokenId, bytes _data) external;
506   // getChild function enables older contracts like cryptokitties to be transferred into a composable
507   // The _childContract must approve this contract. Then getChild can be called.
508   function getChild(address _from, uint256 _tokenId, address _childContract, uint256 _childTokenId) external;
509 }
510 
511 interface ERC998ERC721TopDownEnumerable {
512   function totalChildContracts(uint256 _tokenId) external view returns(uint256);
513   function childContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address childContract);
514   function totalChildTokens(uint256 _tokenId, address _childContract) external view returns(uint256);
515   function childTokenByIndex(uint256 _tokenId, address _childContract, uint256 _index) external view returns (uint256 childTokenId);
516 }
517 
518 interface ERC998ERC20TopDown {
519   event ReceivedERC20(address indexed _from, uint256 indexed _tokenId, address indexed _erc223Contract, uint256 _value);
520   event TransferERC20(uint256 indexed _tokenId, address indexed _to, address indexed _erc223Contract, uint256 _value);
521 
522   function tokenOwnerOf(uint256 _tokenId) external view returns (address tokenOwner, uint256 parentTokenId, uint256 isParent);
523   function tokenFallback(address _from, uint256 _value, bytes _data) external;
524   function balanceOfERC20(uint256 _tokenId, address __erc223Contract) external view returns(uint256);
525   function transferERC20(uint256 _tokenId, address _to, address _erc223Contract, uint256 _value) external;
526   function transferERC223(uint256 _tokenId, address _to, address _erc223Contract, uint256 _value, bytes _data) external;
527   function getERC20(address _from, uint256 _tokenId, address _erc223Contract, uint256 _value) external;
528 
529 }
530 
531 interface ERC998ERC20TopDownEnumerable {
532   function totalERC20Contracts(uint256 _tokenId) external view returns(uint256);
533   function erc20ContractByIndex(uint256 _tokenId, uint256 _index) external view returns(address);
534 }
535 
536 interface ERC20AndERC223 {
537   function transferFrom(address _from, address _to, uint _value) external returns (bool success);
538   function transfer(address to, uint value) external returns (bool success);
539   function transfer(address to, uint value, bytes data) external returns (bool success);
540   function allowance(address _owner, address _spender) external view returns (uint256 remaining);
541 }
542 
543 contract ComposableTopDown is ERC721, ERC998ERC721TopDown, ERC998ERC721TopDownEnumerable,
544                                      ERC998ERC20TopDown, ERC998ERC20TopDownEnumerable, BitGuildAccessAdminExtend{
545                             
546   // tokenOwnerOf.selector;
547   uint256 constant TOKEN_OWNER_OF = 0x89885a59;
548   uint256 constant OWNER_OF_CHILD = 0xeadb80b8;
549 
550   // tokenId => token owner
551   mapping (uint256 => address) internal tokenIdToTokenOwner;
552 
553   // root token owner address => (tokenId => approved address)
554   mapping (address => mapping (uint256 => address)) internal rootOwnerAndTokenIdToApprovedAddress;
555 
556   // token owner address => token count
557   mapping (address => uint256) internal tokenOwnerToTokenCount;
558 
559   // token owner => (operator address => bool)
560   mapping (address => mapping (address => bool)) internal tokenOwnerToOperators;
561 
562 
563   //from zepellin ERC721Receiver.sol
564   //old version
565   bytes4 constant ERC721_RECEIVED_OLD = 0xf0b9e5ba;
566   //new version
567   bytes4 constant ERC721_RECEIVED_NEW = 0x150b7a02;
568     /**
569    * 0x5b5e139f ===
570    *   bytes4(keccak256('name()')) ^
571    *   bytes4(keccak256('symbol()')) ^
572    *   bytes4(keccak256('tokenURI(uint256)'))
573    */
574   bytes4  constant InterfaceId_ERC998 = 0x520bdcbe;
575               //InterfaceId_ERC998 = bytes4(keccak256('tokenOwnerOf(uint256)')) ^
576               // bytes4(keccak256('ownerOfChild(address,uint256)')) ^
577               // bytes4(keccak256('onERC721Received(address,address,uint256,bytes)')) ^
578               // bytes4(keccak256('onERC998RemovedChild(address,address,uint256,bytes)')) ^
579               // bytes4(keccak256('transferChild(address,address,uint256)')) ^
580               // bytes4(keccak256('safeTransferChild(address,address,uint256)')) ^
581               // bytes4(keccak256('safeTransferChild(address,address,uint256,bytes)')) ^
582               // bytes4(keccak256('getChild(address,address,uint256,uint256)'));
583 
584 
585 
586 
587   ////////////////////////////////////////////////////////
588   // ERC721 implementation
589   ////////////////////////////////////////////////////////
590   
591   function _mint(address _to,uint256 _tokenId) internal whenNotPaused {
592     tokenIdToTokenOwner[_tokenId] = _to;
593     tokenOwnerToTokenCount[_to]++;
594     emit Transfer(address(0), _to, _tokenId);
595   }
596 
597   function isContract(address _addr) internal view returns (bool) {
598     uint256 size;
599     assembly { size := extcodesize(_addr) }
600     return size > 0;
601   }
602 
603   function tokenOwnerOf(uint256 _tokenId) external view returns (address tokenOwner, uint256 parentTokenId, uint256 isParent) {
604     tokenOwner = tokenIdToTokenOwner[_tokenId];
605     require(tokenOwner != address(0));
606     if(tokenOwner == address(this)) {
607       (parentTokenId, isParent) = ownerOfChild(address(this), _tokenId);
608     }
609     else {
610       bool callSuccess;
611       // 0xeadb80b8 == ownerOfChild(address,uint256)
612       bytes memory calldata = abi.encodeWithSelector(0xeadb80b8, address(this), _tokenId);
613       assembly {
614         callSuccess := staticcall(gas, tokenOwner, add(calldata, 0x20), mload(calldata), calldata, 0x40)
615         if callSuccess {
616           parentTokenId := mload(calldata)
617           isParent := mload(add(calldata,0x20))
618         }
619       }
620       if(callSuccess && isParent >> 8 == OWNER_OF_CHILD) {
621         isParent = TOKEN_OWNER_OF << 8 | uint8(isParent);
622       }
623       else {
624         isParent = TOKEN_OWNER_OF << 8;
625         parentTokenId = 0;
626       }
627     }
628     return (tokenOwner, parentTokenId, isParent);
629   }
630 
631   function ownerOf(uint256 _tokenId) external view returns (address rootOwner) {
632     return _ownerOf(_tokenId);
633   }
634   
635   // returns the owner at the top of the tree of composables
636   function _ownerOf(uint256 _tokenId) internal view returns (address rootOwner) {
637     rootOwner = tokenIdToTokenOwner[_tokenId];
638     require(rootOwner != address(0));
639     uint256 isParent = 1;
640     bool callSuccess;
641     bytes memory calldata;
642     while(uint8(isParent) > 0) {
643       if(rootOwner == address(this)) {
644         (_tokenId, isParent) = ownerOfChild(address(this), _tokenId);
645         if(uint8(isParent) > 0) {
646           rootOwner = tokenIdToTokenOwner[_tokenId];
647         }
648       }
649       else {
650         if(isContract(rootOwner)) {
651           //0x89885a59 == "tokenOwnerOf(uint256)"
652           calldata = abi.encodeWithSelector(0x89885a59, _tokenId);
653           assembly {
654             callSuccess := staticcall(gas, rootOwner, add(calldata, 0x20), mload(calldata), calldata, 0x60)
655             if callSuccess {
656               rootOwner := mload(calldata)
657               _tokenId := mload(add(calldata,0x20))
658               isParent := mload(add(calldata,0x40))
659             }
660           }
661           
662           if(callSuccess == false || isParent >> 8 != TOKEN_OWNER_OF) {
663             //0x6352211e == "_ownerOf(uint256)"
664             calldata = abi.encodeWithSelector(0x6352211e, _tokenId);
665             assembly {
666               callSuccess := staticcall(gas, rootOwner, add(calldata, 0x20), mload(calldata), calldata, 0x20)
667               if callSuccess {
668                 rootOwner := mload(calldata)
669               }
670             }
671             require(callSuccess, "rootOwnerOf failed");
672             isParent = 0;
673           }
674         }
675         else {
676           isParent = 0;
677         }
678       }
679     }
680     return rootOwner;
681   }
682 
683   function balanceOf(address _tokenOwner)  external view returns (uint256) {
684     require(_tokenOwner != address(0));
685     return tokenOwnerToTokenCount[_tokenOwner];
686   }
687 
688 
689   function approve(address _approved, uint256 _tokenId) external whenNotPaused {
690     address tokenOwner = tokenIdToTokenOwner[_tokenId];
691     address rootOwner = _ownerOf(_tokenId);
692     require(tokenOwner != address(0));
693     require(
694       rootOwner == msg.sender || 
695       tokenOwnerToOperators[rootOwner][msg.sender] || 
696       tokenOwner == msg.sender || 
697       tokenOwnerToOperators[tokenOwner][msg.sender]);
698 
699     rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] = _approved;
700     emit Approval(rootOwner, _approved, _tokenId);
701   }
702 
703   function getApproved(uint256 _tokenId) external view returns (address)  {
704     address rootOwner = _ownerOf(_tokenId);
705     return rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId];
706   }
707 
708   function setApprovalForAll(address _operator, bool _approved) external whenNotPaused {
709     require(_operator != address(0));
710     tokenOwnerToOperators[msg.sender][_operator] = _approved;
711     emit ApprovalForAll(msg.sender, _operator, _approved);
712   }
713 
714   function isApprovedForAll(address _owner, address _operator ) external  view returns (bool)  {
715     require(_owner != address(0));
716     require(_operator != address(0));
717     return tokenOwnerToOperators[_owner][_operator];
718   }
719 
720   function _transfer(address _from, address _to, uint256 _tokenId) internal whenNotPaused {
721     require(!frozenAccount[_from]);                  
722     require(!frozenAccount[_to]); 
723     // tokenIdToTokenOwner[_tokenId] = _to;
724     // tokenOwnerToTokenCount[_to]++;
725     address tokenOwner = tokenIdToTokenOwner[_tokenId];
726     require(tokenOwner == _from);
727     require(_to != address(0));
728     address rootOwner = _ownerOf(_tokenId);
729     require(
730       rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
731       rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] == msg.sender ||
732       tokenOwner == msg.sender || tokenOwnerToOperators[tokenOwner][msg.sender]);
733 
734     // clear approval
735     if(rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] != address(0)) {
736       delete rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId];
737     }
738 
739     // remove and transfer token
740     if(_from != _to) {
741       assert(tokenOwnerToTokenCount[_from] > 0);
742       tokenOwnerToTokenCount[_from]--;
743       tokenIdToTokenOwner[_tokenId] = _to;
744       tokenOwnerToTokenCount[_to]++;
745     }
746     emit Transfer(_from, _to, _tokenId);
747 
748     if(isContract(_from)) {
749       //0x0da719ec == "onERC998Removed(address,address,uint256,bytes)"
750       bytes memory calldata = abi.encodeWithSelector(0x0da719ec, msg.sender, _to, _tokenId,"");
751       assembly {
752         let success := call(gas, _from, 0, add(calldata, 0x20), mload(calldata), calldata, 0)
753       }
754     }
755 
756   }
757 
758   function transferFrom(address _from, address _to, uint256 _tokenId) external {
759     _transfer(_from, _to, _tokenId);
760   }
761 
762   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
763     _transfer(_from, _to, _tokenId);
764     if(isContract(_to)) {
765       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, "");
766       require(retval == ERC721_RECEIVED_OLD);
767     }
768   }
769 
770   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
771     _transfer(_from, _to, _tokenId);
772     if(isContract(_to)) {
773       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
774       require(retval == ERC721_RECEIVED_OLD);
775     }
776   }
777 
778   ////////////////////////////////////////////////////////
779   // ERC998ERC721 and ERC998ERC721Enumerable implementation
780   ////////////////////////////////////////////////////////
781 
782   // tokenId => child contract
783   mapping(uint256 => address[]) internal childContracts;
784 
785   // tokenId => (child address => contract index+1)
786   mapping(uint256 => mapping(address => uint256)) internal childContractIndex;
787 
788   // tokenId => (child address => array of child tokens)
789   mapping(uint256 => mapping(address => uint256[])) internal childTokens;
790 
791   // tokenId => (child address => (child token => child index+1)
792   mapping(uint256 => mapping(address => mapping(uint256 => uint256))) internal childTokenIndex;
793 
794   // child address => childId => tokenId
795   mapping(address => mapping(uint256 => uint256)) internal childTokenOwner;
796 
797   function onERC998Removed(address _operator, address _toContract, uint256 _childTokenId, bytes _data) external {
798     uint256 tokenId = childTokenOwner[msg.sender][_childTokenId];
799     _removeChild(tokenId, msg.sender, _childTokenId);
800   }
801 
802 
803   function safeTransferChild(address _to, address _childContract, uint256 _childTokenId) external {
804     (uint256 tokenId, uint256 isParent) = ownerOfChild(_childContract, _childTokenId);
805     require(uint8(isParent) > 0);
806     address tokenOwner = tokenIdToTokenOwner[tokenId];
807     require(_to != address(0));
808     address rootOwner = _ownerOf(tokenId);
809     require(
810       rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
811       rootOwnerAndTokenIdToApprovedAddress[rootOwner][tokenId] == msg.sender ||
812       tokenOwner == msg.sender || tokenOwnerToOperators[tokenOwner][msg.sender]);
813     _removeChild(tokenId, _childContract, _childTokenId);
814     ERC721(_childContract).safeTransferFrom(this, _to, _childTokenId);
815     emit TransferChild(tokenId, _to, _childContract, _childTokenId);
816   }
817 
818   function safeTransferChild(address _to, address _childContract, uint256 _childTokenId, bytes _data) external {
819     (uint256 tokenId, uint256 isParent) = ownerOfChild(_childContract, _childTokenId);
820     require(uint8(isParent) > 0);
821     address tokenOwner = tokenIdToTokenOwner[tokenId];
822     require(_to != address(0));
823     address rootOwner = _ownerOf(tokenId);
824     require(
825       rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
826       rootOwnerAndTokenIdToApprovedAddress[rootOwner][tokenId] == msg.sender ||
827       tokenOwner == msg.sender || tokenOwnerToOperators[tokenOwner][msg.sender]);
828     _removeChild(tokenId, _childContract, _childTokenId);
829     ERC721(_childContract).safeTransferFrom(this, _to, _childTokenId, _data);
830     emit TransferChild(tokenId, _to, _childContract, _childTokenId);
831   }
832 
833   function transferChild(address _to, address _childContract, uint256 _childTokenId) external {
834     _transferChild(_to, _childContract,_childTokenId);
835   }
836  
837   function getChild(address _from, uint256 _tokenId, address _childContract, uint256 _childTokenId) external {
838     _getChild(_from, _tokenId, _childContract,_childTokenId);
839   }
840 
841   function onERC721Received(address _from, uint256 _childTokenId, bytes _data) external returns(bytes4) {
842     require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the child token to.");
843     require(isContract(msg.sender), "msg.sender is not a contract.");
844     /**************************************
845     * TODO move to library
846     **************************************/
847     // convert up to 32 bytes of_data to uint256, owner nft tokenId passed as uint in bytes
848     uint256 tokenId;
849     assembly {
850       // new onERC721Received
851       //tokenId := calldataload(164)
852       tokenId := calldataload(132)
853     }
854     if(_data.length < 32) {
855       tokenId = tokenId >> 256 - _data.length * 8;
856     }
857     //END TODO
858 
859     //require(this == ERC721Basic(msg.sender)._ownerOf(_childTokenId), "This contract does not own the child token.");
860 
861     _receiveChild(_from, tokenId, msg.sender, _childTokenId);
862     //cause out of gas error if circular ownership
863     _ownerOf(tokenId);
864     return ERC721_RECEIVED_OLD;
865   }
866 
867 
868   function onERC721Received(address _operator, address _from, uint256 _childTokenId, bytes _data) external returns(bytes4) {
869     require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the child token to.");
870     require(isContract(msg.sender), "msg.sender is not a contract.");
871     /**************************************
872     * TODO move to library
873     **************************************/
874     // convert up to 32 bytes of_data to uint256, owner nft tokenId passed as uint in bytes
875     uint256 tokenId;
876     assembly {
877       // new onERC721Received
878       tokenId := calldataload(164)
879       //tokenId := calldataload(132)
880     }
881     if(_data.length < 32) {
882       tokenId = tokenId >> 256 - _data.length * 8;
883     }
884     //END TODO
885 
886     //require(this == ERC721Basic(msg.sender)._ownerOf(_childTokenId), "This contract does not own the child token.");
887 
888     _receiveChild(_from, tokenId, msg.sender, _childTokenId);
889     //cause out of gas error if circular ownership
890     _ownerOf(tokenId);
891     return ERC721_RECEIVED_NEW;
892   }
893 
894   function _transferChild(address _to, address _childContract, uint256 _childTokenId) internal {
895     (uint256 tokenId, uint256 isParent) = ownerOfChild(_childContract, _childTokenId);
896     require(uint8(isParent) > 0);
897     address tokenOwner = tokenIdToTokenOwner[tokenId];
898     require(_to != address(0));
899     address rootOwner = _ownerOf(tokenId);
900     require(
901       rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
902       rootOwnerAndTokenIdToApprovedAddress[rootOwner][tokenId] == msg.sender ||
903       tokenOwner == msg.sender || tokenOwnerToOperators[tokenOwner][msg.sender]);
904     _removeChild(tokenId, _childContract, _childTokenId);
905     //this is here to be compatible with cryptokitties and other old contracts that require being owner and approved
906     // before transferring.
907     //does not work with current standard which does not allow approving self, so we must let it fail in that case.
908     //0x095ea7b3 == "approve(address,uint256)"
909     bytes memory calldata = abi.encodeWithSelector(0x095ea7b3, this, _childTokenId);
910     assembly {
911       let success := call(gas, _childContract, 0, add(calldata, 0x20), mload(calldata), calldata, 0)
912     }
913     ERC721(_childContract).transferFrom(this, _to, _childTokenId);
914     emit TransferChild(tokenId, _to, _childContract, _childTokenId);
915   }
916 
917   // this contract has to be approved first in _childContract
918   function _getChild(address _from, uint256 _tokenId, address _childContract, uint256 _childTokenId) internal {
919     _receiveChild(_from, _tokenId, _childContract, _childTokenId);
920     require(
921       _from == msg.sender || ERC721(_childContract).isApprovedForAll(_from, msg.sender) ||
922     ERC721(_childContract).getApproved(_childTokenId) == msg.sender);
923     ERC721(_childContract).transferFrom(_from, this, _childTokenId);
924     //cause out of gas error if circular ownership
925     _ownerOf(_tokenId);
926   }
927 
928   function _receiveChild(address _from,  uint256 _tokenId, address _childContract, uint256 _childTokenId) private whenNotPaused {  
929     require(tokenIdToTokenOwner[_tokenId] != address(0), "_tokenId does not exist.");
930     require(childTokenIndex[_tokenId][_childContract][_childTokenId] == 0, "Cannot receive child token because it has already been received.");
931     uint256 childTokensLength = childTokens[_tokenId][_childContract].length;
932     if(childTokensLength == 0) {
933       childContractIndex[_tokenId][_childContract] = childContracts[_tokenId].length;
934       childContracts[_tokenId].push(_childContract);
935     }
936     childTokens[_tokenId][_childContract].push(_childTokenId);
937     childTokenIndex[_tokenId][_childContract][_childTokenId] = childTokensLength + 1;
938     childTokenOwner[_childContract][_childTokenId] = _tokenId;
939     emit ReceivedChild(_from, _tokenId, _childContract, _childTokenId);
940   }
941   
942   function _removeChild(uint256 _tokenId, address _childContract, uint256 _childTokenId) private whenNotPaused {
943     uint256 tokenIndex = childTokenIndex[_tokenId][_childContract][_childTokenId];
944     require(tokenIndex != 0, "Child token not owned by token.");
945 
946     // remove child token
947     uint256 lastTokenIndex = childTokens[_tokenId][_childContract].length-1;
948 
949     uint256 lastToken = childTokens[_tokenId][_childContract][lastTokenIndex];
950 
951     //if(_childTokenId == lastToken) {
952     
953     childTokens[_tokenId][_childContract][tokenIndex-1] = lastToken;
954     childTokenIndex[_tokenId][_childContract][lastToken] = tokenIndex;
955     //}
956   
957     childTokens[_tokenId][_childContract].length--;
958 
959     delete childTokenIndex[_tokenId][_childContract][_childTokenId];
960     delete childTokenOwner[_childContract][_childTokenId];
961 
962     // remove contract
963     if(lastTokenIndex == 0) {
964       uint256 lastContractIndex = childContracts[_tokenId].length - 1;
965       address lastContract = childContracts[_tokenId][lastContractIndex];
966       if(_childContract != lastContract) {
967         uint256 contractIndex = childContractIndex[_tokenId][_childContract];
968         childContracts[_tokenId][contractIndex] = lastContract;
969         childContractIndex[_tokenId][lastContract] = contractIndex;
970       }
971       childContracts[_tokenId].length--;
972       delete childContractIndex[_tokenId][_childContract];
973     }
974   }
975 
976   function ownerOfChild(address _childContract, uint256 _childTokenId) public view returns (uint256 parentTokenId, uint256 isParent) {
977     parentTokenId = childTokenOwner[_childContract][_childTokenId];
978     if(parentTokenId == 0 && childTokenIndex[parentTokenId][_childContract][_childTokenId] == 0) {
979       return (0, OWNER_OF_CHILD << 8);
980     }
981     return (parentTokenId, OWNER_OF_CHILD << 8 | 1);
982   }
983 
984   function childExists(address _childContract, uint256 _childTokenId) external view returns (bool) {
985     uint256 tokenId = childTokenOwner[_childContract][_childTokenId];
986     return childTokenIndex[tokenId][_childContract][_childTokenId] != 0;
987   }
988 
989   function totalChildContracts(uint256 _tokenId) external view returns(uint256) {
990     return childContracts[_tokenId].length;
991   }
992 
993   function childContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address childContract) {
994     require(_index < childContracts[_tokenId].length, "Contract address does not exist for this token and index.");
995     return childContracts[_tokenId][_index];
996   }
997 
998   function totalChildTokens(uint256 _tokenId, address _childContract) external view returns(uint256) {
999     return childTokens[_tokenId][_childContract].length;
1000   }
1001 
1002   function childTokenByIndex(uint256 _tokenId, address _childContract, uint256 _index) external view returns (uint256 childTokenId) {
1003     require(_index < childTokens[_tokenId][_childContract].length, "Token does not own a child token at contract address and index.");
1004     return childTokens[_tokenId][_childContract][_index];
1005   }
1006 
1007   ////////////////////////////////////////////////////////
1008   // ERC998ERC223 and ERC998ERC223Enumerable implementation
1009   ////////////////////////////////////////////////////////
1010 
1011   // tokenId => token contract
1012   mapping(uint256 => address[]) erc223Contracts;
1013 
1014   // tokenId => (token contract => token contract index)
1015   mapping(uint256 => mapping(address => uint256)) erc223ContractIndex;
1016   
1017   // tokenId => (token contract => balance)
1018   mapping(uint256 => mapping(address => uint256)) erc223Balances;
1019   
1020   function balanceOfERC20(uint256 _tokenId, address _erc223Contract) external view returns(uint256) {
1021     return erc223Balances[_tokenId][_erc223Contract];
1022   }
1023 
1024   function removeERC223(uint256 _tokenId, address _erc223Contract, uint256 _value) private whenNotPaused {
1025     if(_value == 0) {
1026       return;
1027     }
1028     uint256 erc223Balance = erc223Balances[_tokenId][_erc223Contract];
1029     require(erc223Balance >= _value, "Not enough token available to transfer.");
1030     uint256 newERC223Balance = erc223Balance - _value;
1031     erc223Balances[_tokenId][_erc223Contract] = newERC223Balance;
1032     if(newERC223Balance == 0) {
1033       uint256 lastContractIndex = erc223Contracts[_tokenId].length - 1;
1034       address lastContract = erc223Contracts[_tokenId][lastContractIndex];
1035       if(_erc223Contract != lastContract) {
1036         uint256 contractIndex = erc223ContractIndex[_tokenId][_erc223Contract];
1037         erc223Contracts[_tokenId][contractIndex] = lastContract;
1038         erc223ContractIndex[_tokenId][lastContract] = contractIndex;
1039       }
1040       erc223Contracts[_tokenId].length--;
1041       delete erc223ContractIndex[_tokenId][_erc223Contract];
1042     }
1043   }
1044   
1045   
1046   function transferERC20(uint256 _tokenId, address _to, address _erc223Contract, uint256 _value) external {
1047     address tokenOwner = tokenIdToTokenOwner[_tokenId];
1048     require(_to != address(0));
1049     address rootOwner = _ownerOf(_tokenId);
1050     require(
1051       rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
1052       rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] == msg.sender ||
1053       tokenOwner == msg.sender || tokenOwnerToOperators[tokenOwner][msg.sender]);
1054     removeERC223(_tokenId, _erc223Contract, _value);
1055     require(ERC20AndERC223(_erc223Contract).transfer(_to, _value), "ERC20 transfer failed.");
1056     emit TransferERC20(_tokenId, _to, _erc223Contract, _value);
1057   }
1058   
1059   // implementation of ERC 223
1060   function transferERC223(uint256 _tokenId, address _to, address _erc223Contract, uint256 _value, bytes _data) external {
1061     address tokenOwner = tokenIdToTokenOwner[_tokenId];
1062     require(_to != address(0));
1063     address rootOwner = _ownerOf(_tokenId);
1064     require(
1065       rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
1066       rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] == msg.sender ||
1067       tokenOwner == msg.sender || tokenOwnerToOperators[tokenOwner][msg.sender]);
1068     removeERC223(_tokenId, _erc223Contract, _value);
1069     require(ERC20AndERC223(_erc223Contract).transfer(_to, _value, _data), "ERC223 transfer failed.");
1070     emit TransferERC20(_tokenId, _to, _erc223Contract, _value);
1071   }
1072 
1073   // this contract has to be approved first by _erc223Contract
1074   function getERC20(address _from, uint256 _tokenId, address _erc223Contract, uint256 _value) public {
1075     bool allowed = _from == msg.sender;
1076     if(!allowed) {
1077       uint256 remaining;
1078       // 0xdd62ed3e == allowance(address,address)
1079       bytes memory calldata = abi.encodeWithSelector(0xdd62ed3e,_from,msg.sender);
1080       bool callSuccess;
1081       assembly {
1082         callSuccess := staticcall(gas, _erc223Contract, add(calldata, 0x20), mload(calldata), calldata, 0x20)
1083         if callSuccess {
1084           remaining := mload(calldata)
1085         }
1086       }
1087       require(callSuccess, "call to allowance failed");
1088       require(remaining >= _value, "Value greater than remaining");
1089       allowed = true;
1090     }
1091     require(allowed, "not allowed to getERC20");
1092     erc223Received(_from, _tokenId, _erc223Contract, _value);
1093     require(ERC20AndERC223(_erc223Contract).transferFrom(_from, this, _value), "ERC20 transfer failed.");
1094   }
1095 
1096   function erc223Received(address _from, uint256 _tokenId, address _erc223Contract, uint256 _value) private {
1097     require(tokenIdToTokenOwner[_tokenId] != address(0), "_tokenId does not exist.");
1098     if(_value == 0) {
1099       return;
1100     }
1101     uint256 erc223Balance = erc223Balances[_tokenId][_erc223Contract];
1102     if(erc223Balance == 0) {
1103       erc223ContractIndex[_tokenId][_erc223Contract] = erc223Contracts[_tokenId].length;
1104       erc223Contracts[_tokenId].push(_erc223Contract);
1105     }
1106     erc223Balances[_tokenId][_erc223Contract] += _value;
1107     emit ReceivedERC20(_from, _tokenId, _erc223Contract, _value);
1108   }
1109   
1110   // used by ERC 223
1111   function tokenFallback(address _from, uint256 _value, bytes _data) external {
1112     require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the token to.");
1113     require(isContract(msg.sender), "msg.sender is not a contract");
1114     /**************************************
1115     * TODO move to library
1116     **************************************/
1117     // convert up to 32 bytes of_data to uint256, owner nft tokenId passed as uint in bytes
1118     uint256 tokenId;
1119     assembly {
1120       tokenId := calldataload(132)
1121     }
1122     if(_data.length < 32) {
1123       tokenId = tokenId >> 256 - _data.length * 8;
1124     }
1125     //END TODO
1126     erc223Received(_from, tokenId, msg.sender, _value);
1127   }
1128   
1129   function erc20ContractByIndex(uint256 _tokenId, uint256 _index) external view returns(address) {
1130     require(_index < erc223Contracts[_tokenId].length, "Contract address does not exist for this token and index.");
1131     return erc223Contracts[_tokenId][_index];
1132   }
1133   
1134   function totalERC20Contracts(uint256 _tokenId) external view returns(uint256) {
1135     return erc223Contracts[_tokenId].length;
1136   }
1137   
1138 }
1139 
1140 contract ERC998TopDownToken is SupportsInterfaceWithLookup, ERC721Enumerable, ERC721Metadata, ComposableTopDown {
1141 
1142   using SafeMath for uint256;
1143 
1144   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
1145   /**
1146    * 0x780e9d63 ===
1147    *   bytes4(keccak256('totalSupply()')) ^
1148    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1149    *   bytes4(keccak256('tokenByIndex(uint256)'))
1150    */
1151   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
1152               
1153   // Mapping from owner to list of owned token IDs
1154   mapping(address => uint256[]) internal ownedTokens;
1155 
1156   // Mapping from token ID to index of the owner tokens list
1157   mapping(uint256 => uint256) internal ownedTokensIndex;
1158 
1159   // Array with all token ids, used for enumeration
1160   uint256[] internal allTokens;
1161 
1162   // Mapping from token id to position in the allTokens array
1163   mapping(uint256 => uint256) internal allTokensIndex;
1164 
1165   // Optional mapping for token URIs
1166   mapping(uint256 => string) internal tokenURIs;
1167 
1168   /**
1169    * @dev Constructor function
1170    */
1171   constructor() public {
1172     // register the supported interfaces to conform to ERC721 via ERC165
1173     _registerInterface(InterfaceId_ERC721Enumerable);
1174     _registerInterface(InterfaceId_ERC721Metadata);
1175     _registerInterface(InterfaceId_ERC998);
1176   }
1177 
1178   modifier existsToken(uint256 _tokenId){
1179     address owner = tokenIdToTokenOwner[_tokenId];
1180     require(owner != address(0), "This tokenId is invalid"); 
1181     _;
1182   }
1183 
1184   /**
1185    * @dev Gets the token name
1186    * @return string representing the token name
1187    */
1188   function name() external view returns (string) {
1189     return "Bitizen";
1190   }
1191 
1192   /**
1193    * @dev Gets the token symbol
1194    * @return string representing the token symbol
1195    */
1196   function symbol() external view returns (string) {
1197     return "BTZN";
1198   }
1199 
1200   /**
1201    * @dev Returns an URI for a given token ID
1202    * Throws if the token ID does not exist. May return an empty string.
1203    * @param _tokenId uint256 ID of the token to query
1204    */
1205   function tokenURI(uint256 _tokenId) external view existsToken(_tokenId) returns (string) {
1206     return "";
1207   }
1208 
1209   /**
1210    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1211    * @param _owner address owning the tokens list to be accessed
1212    * @param _index uint256 representing the index to be accessed of the requested tokens list
1213    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1214    */
1215   function tokenOfOwnerByIndex(
1216     address _owner,
1217     uint256 _index
1218   )
1219     public
1220     view
1221     returns (uint256)
1222   {
1223     require(address(0) != _owner);
1224     require(_index < tokenOwnerToTokenCount[_owner]);
1225     return ownedTokens[_owner][_index];
1226   }
1227 
1228   /**
1229    * @dev Gets the total amount of tokens stored by the contract
1230    * @return uint256 representing the total amount of tokens
1231    */
1232   function totalSupply() public view returns (uint256) {
1233     return allTokens.length;
1234   }
1235 
1236   /**
1237    * @dev Gets the token ID at a given index of all the tokens in this contract
1238    * Reverts if the index is greater or equal to the total number of tokens
1239    * @param _index uint256 representing the index to be accessed of the tokens list
1240    * @return uint256 token ID at the given index of the tokens list
1241    */
1242   function tokenByIndex(uint256 _index) public view returns (uint256) {
1243     require(_index < totalSupply());
1244     return allTokens[_index];
1245   }
1246 
1247   /**
1248    * @dev Internal function to set the token URI for a given token
1249    * Reverts if the token ID does not exist
1250    * @param _tokenId uint256 ID of the token to set its URI
1251    * @param _uri string URI to assign
1252    */
1253   function _setTokenURI(uint256 _tokenId, string _uri) existsToken(_tokenId) internal {
1254     tokenURIs[_tokenId] = _uri;
1255   }
1256 
1257   /**
1258    * @dev Internal function to add a token ID to the list of a given address
1259    * @param _to address representing the new owner of the given token ID
1260    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1261    */
1262   function _addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
1263     uint256 length = ownedTokens[_to].length;
1264     ownedTokens[_to].push(_tokenId);
1265     ownedTokensIndex[_tokenId] = length;
1266   }
1267 
1268   /**
1269    * @dev Internal function to remove a token ID from the list of a given address
1270    * @param _from address representing the previous owner of the given token ID
1271    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1272    */
1273   function _removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused {
1274     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1275     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1276     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1277 
1278     ownedTokens[_from][tokenIndex] = lastToken;
1279     ownedTokens[_from][lastTokenIndex] = 0;
1280     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1281     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1282     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1283 
1284     ownedTokens[_from].length--;
1285     ownedTokensIndex[_tokenId] = 0;
1286     ownedTokensIndex[lastToken] = tokenIndex;
1287   }
1288 
1289   /**
1290    * @dev Internal function to mint a new token
1291    * Reverts if the given token ID already exists
1292    * @param _to address the beneficiary that will own the minted token
1293    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1294    */
1295   function _mint(address _to, uint256 _tokenId) internal whenNotPaused {
1296     super._mint(_to, _tokenId);
1297     _addTokenTo(_to,_tokenId);
1298     allTokensIndex[_tokenId] = allTokens.length;
1299     allTokens.push(_tokenId);
1300   }
1301 
1302   //override
1303   //add Enumerable info
1304   function _transfer(address _from, address _to, uint256 _tokenId) internal whenNotPaused {
1305     super._transfer(_from, _to, _tokenId);
1306     _addTokenTo(_to,_tokenId);
1307     _removeTokenFrom(_from, _tokenId);
1308   }
1309 }
1310 
1311 
1312 contract AvatarToken is ERC998TopDownToken, AvatarService {
1313   
1314   using UrlStr for string;
1315 
1316   event BatchMount(address indexed from, uint256 parent, address indexed childAddr, uint256[] children);
1317   event BatchUnmount(address indexed from, uint256 parent, address indexed childAddr, uint256[] children);
1318  
1319   struct Avatar {
1320     // avatar name
1321     string name;
1322     // avatar gen,this decide the avatar appearance 
1323     uint256 dna;
1324   }
1325 
1326   // For erc721 metadata
1327   string internal BASE_URL = "https://www.bitguild.com/bitizens/api/avatar/getAvatar/00000000";
1328 
1329   Avatar[] avatars;
1330 
1331   function createAvatar(address _owner, string _name, uint256 _dna) external onlyOperator returns(uint256) {
1332     return _createAvatar(_owner, _name, _dna);
1333   }
1334 
1335   function getMountTokenIds(address _owner, uint256 _tokenId, address _avatarItemAddress)
1336   external
1337   view 
1338   onlyOperator
1339   existsToken(_tokenId) 
1340   returns(uint256[]) {
1341     require(tokenIdToTokenOwner[_tokenId] == _owner);
1342     return childTokens[_tokenId][_avatarItemAddress];
1343   }
1344   
1345   function updateAvatarInfo(address _owner, uint256 _tokenId, string _name, uint256 _dna) external onlyOperator existsToken(_tokenId){
1346     require(_owner != address(0), "Invalid address");
1347     require(_owner == tokenIdToTokenOwner[_tokenId] || msg.sender == owner);
1348     Avatar storage avatar = avatars[allTokensIndex[_tokenId]];
1349     avatar.name = _name;
1350     avatar.dna = _dna;
1351   }
1352 
1353   function updateBaseURI(string _url) external onlyOperator {
1354     BASE_URL = _url;
1355   }
1356 
1357   function tokenURI(uint256 _tokenId) external view existsToken(_tokenId) returns (string) {
1358     return BASE_URL.generateUrl(_tokenId);
1359   }
1360 
1361   function getOwnedTokenIds(address _owner) external view returns(uint256[] _tokenIds) {
1362     _tokenIds = ownedTokens[_owner];
1363   }
1364 
1365   function getAvatarInfo(uint256 _tokenId) external view existsToken(_tokenId) returns(string _name, uint256 _dna) {
1366     Avatar storage avatar = avatars[allTokensIndex[_tokenId]];
1367     _name = avatar.name;
1368     _dna = avatar.dna;
1369   }
1370 
1371   function batchMount(address _childContract, uint256[] _childTokenIds, uint256 _tokenId) external {
1372     uint256 _len = _childTokenIds.length;
1373     require(_len > 0, "No token need to mount");
1374     address tokenOwner = _ownerOf(_tokenId);
1375     require(tokenOwner == msg.sender);
1376     for(uint8 i = 0; i < _len; ++i) {
1377       uint256 childTokenId = _childTokenIds[i];
1378       require(ERC721(_childContract).ownerOf(childTokenId) == tokenOwner);
1379       _getChild(msg.sender, _tokenId, _childContract, childTokenId);
1380     }
1381     emit BatchMount(msg.sender, _tokenId, _childContract, _childTokenIds);
1382   }
1383  
1384   function batchUnmount(address _childContract, uint256[] _childTokenIds, uint256 _tokenId) external {
1385     uint256 len = _childTokenIds.length;
1386     require(len > 0, "No token need to unmount");
1387     address tokenOwner = _ownerOf(_tokenId);
1388     require(tokenOwner == msg.sender);
1389     for(uint8 i = 0; i < len; ++i) {
1390       uint256 childTokenId = _childTokenIds[i];
1391       _transferChild(msg.sender, _childContract, childTokenId);
1392     }
1393     emit BatchUnmount(msg.sender,_tokenId,_childContract,_childTokenIds);
1394   }
1395 
1396   // create avatar 
1397   function _createAvatar(address _owner, string _name, uint256 _dna) private returns(uint256 _tokenId) {
1398     require(_owner != address(0));
1399     Avatar memory avatar = Avatar(_name, _dna);
1400     _tokenId = avatars.push(avatar);
1401     _mint(_owner, _tokenId);
1402   }
1403 
1404   function _unmountSameSocketItem(address _owner, uint256 _tokenId, address _childContract, uint256 _childTokenId) internal {
1405     uint256[] storage tokens = childTokens[_tokenId][_childContract];
1406     for(uint256 i = 0; i < tokens.length; ++i) {
1407       // if the child no compareItemSlots(uint256,uint256) ,this will lead to a error and stop this operate
1408       if(AvatarChildService(_childContract).compareItemSlots(tokens[i], _childTokenId)) {
1409         // unmount the old avatar item
1410         _transferChild(_owner, _childContract, tokens[i]);
1411       }
1412     }
1413   }
1414 
1415   // override  
1416   function _transfer(address _from, address _to, uint256 _tokenId) internal whenNotPaused {
1417     // not allown to transfer when  only one  avatar 
1418     require(tokenOwnerToTokenCount[_from] > 1);
1419     super._transfer(_from, _to, _tokenId);
1420   }
1421 
1422   // override
1423   function _getChild(address _from, uint256 _tokenId, address _childContract, uint256 _childTokenId) internal {
1424     _unmountSameSocketItem(_from, _tokenId, _childContract, _childTokenId);
1425     super._getChild(_from, _tokenId, _childContract, _childTokenId);
1426   }
1427 
1428   function () external payable {
1429     revert();
1430   }
1431 
1432 }