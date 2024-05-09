1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * Utility library of inline functions on addresses
6  */
7 library AddressUtils {
8 
9   /**
10    * Returns whether the target address is a contract
11    * @dev This function will return false if invoked during the constructor of a contract,
12    * as the code is not actually created until after the constructor finishes.
13    * @param addr address to check
14    * @return whether the target address is a contract
15    */
16   function isContract(address addr) internal view returns (bool) {
17     uint256 size;
18     // XXX Currently there is no better way to check if there is a contract in an address
19     // than to check the size of the code at that address.
20     // See https://ethereum.stackexchange.com/a/14016/36603
21     // for more details about how this works.
22     // TODO Check this again before the Serenity release, because all addresses will be
23     // contracts then.
24     // solium-disable-next-line security/no-inline-assembly
25     assembly { size := extcodesize(addr) }
26     return size > 0;
27   }
28 
29 }
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, throws on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     if (a == 0) {
42       return 0;
43     }
44     uint256 c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   /**
60   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 
78 library UrlStr {
79   
80   // generate url by tokenId
81   // baseUrl must end with 00000000
82   function generateUrl(string url,uint256 _tokenId) internal pure returns (string _url){
83     _url = url;
84     bytes memory _tokenURIBytes = bytes(_url);
85     uint256 base_len = _tokenURIBytes.length - 1;
86     _tokenURIBytes[base_len - 7] = byte(48 + _tokenId / 10000000 % 10);
87     _tokenURIBytes[base_len - 6] = byte(48 + _tokenId / 1000000 % 10);
88     _tokenURIBytes[base_len - 5] = byte(48 + _tokenId / 100000 % 10);
89     _tokenURIBytes[base_len - 4] = byte(48 + _tokenId / 10000 % 10);
90     _tokenURIBytes[base_len - 3] = byte(48 + _tokenId / 1000 % 10);
91     _tokenURIBytes[base_len - 2] = byte(48 + _tokenId / 100 % 10);
92     _tokenURIBytes[base_len - 1] = byte(48 + _tokenId / 10 % 10);
93     _tokenURIBytes[base_len - 0] = byte(48 + _tokenId / 1 % 10);
94   }
95 }
96 
97 interface ERC165 {
98   
99   /**
100    * @notice Query if a contract implements an interface
101    * @param _interfaceId The interface identifier, as specified in ERC-165
102    * @dev Interface identification is specified in ERC-165. This function
103    * uses less than 30,000 gas.
104    */
105   function supportsInterface(bytes4 _interfaceId) external view returns (bool);
106 }
107 
108 interface ERC721 /* is ERC165 */ {
109     /// @dev This emits when ownership of any NFT changes by any mechanism.
110     ///  This event emits when NFTs are created (`from` == 0) and destroyed
111     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
112     ///  may be created and assigned without emitting Transfer. At the time of
113     ///  any transfer, the approved address for that NFT (if any) is reset to none.
114     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
115 
116     /// @dev This emits when the approved address for an NFT is changed or
117     ///  reaffirmed. The zero address indicates there is no approved address.
118     ///  When a Transfer event emits, this also indicates that the approved
119     ///  address for that NFT (if any) is reset to none.
120     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
121 
122     /// @dev This emits when an operator is enabled or disabled for an owner.
123     ///  The operator can manage all NFTs of the owner.
124     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
125 
126     /// @notice Count all NFTs assigned to an owner
127     /// @dev NFTs assigned to the zero address are considered invalid, and this
128     ///  function throws for queries about the zero address.
129     /// @param _owner An address for whom to query the balance
130     /// @return The number of NFTs owned by `_owner`, possibly zero
131     function balanceOf(address _owner) external view returns (uint256);
132 
133     /// @notice Find the owner of an NFT
134     /// @dev NFTs assigned to zero address are considered invalid, and queries
135     ///  about them do throw.
136     /// @param _tokenId The identifier for an NFT
137     /// @return The address of the owner of the NFT
138     function ownerOf(uint256 _tokenId) external view returns (address);
139 
140     /// @notice Transfers the ownership of an NFT from one address to another address
141     /// @dev Throws unless `msg.sender` is the current owner, an authorized
142     ///  operator, or the approved address for this NFT. Throws if `_from` is
143     ///  not the current owner. Throws if `_to` is the zero address. Throws if
144     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
145     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
146     ///  `onERC721Received` on `_to` and throws if the return value is not
147     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
148     /// @param _from The current owner of the NFT
149     /// @param _to The new owner
150     /// @param _tokenId The NFT to transfer
151     /// @param data Additional data with no specified format, sent in call to `_to`
152     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
153 
154     /// @notice Transfers the ownership of an NFT from one address to another address
155     /// @dev This works identically to the other function with an extra data parameter,
156     ///  except this function just sets data to "".
157     /// @param _from The current owner of the NFT
158     /// @param _to The new owner
159     /// @param _tokenId The NFT to transfer
160     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
161 
162     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
163     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
164     ///  THEY MAY BE PERMANENTLY LOST
165     /// @dev Throws unless `msg.sender` is the current owner, an authorized
166     ///  operator, or the approved address for this NFT. Throws if `_from` is
167     ///  not the current owner. Throws if `_to` is the zero address. Throws if
168     ///  `_tokenId` is not a valid NFT.
169     /// @param _from The current owner of the NFT
170     /// @param _to The new owner
171     /// @param _tokenId The NFT to transfer
172     function transferFrom(address _from, address _to, uint256 _tokenId) external;
173 
174     /// @notice Change or reaffirm the approved address for an NFT
175     /// @dev The zero address indicates there is no approved address.
176     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
177     ///  operator of the current owner.
178     /// @param _approved The new approved NFT controller
179     /// @param _tokenId The NFT to approve
180     function approve(address _approved, uint256 _tokenId) external;
181 
182     /// @notice Enable or disable approval for a third party ("operator") to manage
183     ///  all of `msg.sender`'s assets
184     /// @dev Emits the ApprovalForAll event. The contract MUST allow
185     ///  multiple operators per owner.
186     /// @param _operator Address to add to the set of authorized operators
187     /// @param _approved True if the operator is approved, false to revoke approval
188     function setApprovalForAll(address _operator, bool _approved) external;
189 
190     /// @notice Get the approved address for a single NFT
191     /// @dev Throws if `_tokenId` is not a valid NFT.
192     /// @param _tokenId The NFT to find the approved address for
193     /// @return The approved address for this NFT, or the zero address if there is none
194     function getApproved(uint256 _tokenId) external view returns (address);
195 
196     /// @notice Query if an address is an authorized operator for another address
197     /// @param _owner The address that owns the NFTs
198     /// @param _operator The address that acts on behalf of the owner
199     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
200     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
201 }
202 
203 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
204 interface ERC721Enumerable /* is ERC721 */ {
205     /// @notice Count NFTs tracked by this contract
206     /// @return A count of valid NFTs tracked by this contract, where each one of
207     ///  them has an assigned and queryable owner not equal to the zero address
208     function totalSupply() external view returns (uint256);
209 
210     /// @notice Enumerate valid NFTs
211     /// @dev Throws if `_index` >= `totalSupply()`.
212     /// @param _index A counter less than `totalSupply()`
213     /// @return The token identifier for the `_index`th NFT,
214     ///  (sort order not specified)
215     function tokenByIndex(uint256 _index) external view returns (uint256);
216 
217     /// @notice Enumerate NFTs assigned to an owner
218     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
219     ///  `_owner` is the zero address, representing invalid NFTs.
220     /// @param _owner An address where we are interested in NFTs owned by them
221     /// @param _index A counter less than `balanceOf(_owner)`
222     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
223     ///   (sort order not specified)
224     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
225 }
226 
227 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
228 interface ERC721Metadata /* is ERC721 */ {
229   /// @notice A descriptive name for a collection of NFTs in this contract
230   function name() external view returns (string _name);
231 
232   /// @notice An abbreviated name for NFTs in this contract
233   function symbol() external view returns (string _symbol);
234 
235   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
236   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
237   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
238   ///  Metadata JSON Schema".
239   function tokenURI(uint256 _tokenId) external view returns (string);
240 }
241 
242 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
243 interface ERC721TokenReceiver {
244     /// @notice Handle the receipt of an NFT
245     /// @dev The ERC721 smart contract calls this function on the recipient
246     ///  after a `transfer`. This function MAY throw to revert and reject the
247     ///  transfer. Return of other than the magic value MUST result in the
248     ///  transaction being reverted.
249     ///  Note: the contract address is always the message sender.
250     /// @param _operator The address which called `safeTransferFrom` function
251     /// @param _from The address which previously owned the token
252     /// @param _tokenId The NFT identifier which is being transferred
253     /// @param _data Additional data with no specified format
254     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
255     ///  unless throwing
256     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
257 }
258 
259 contract SupportsInterfaceWithLookup is ERC165 {
260   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
261   /**
262    * 0x01ffc9a7 ===
263    *   bytes4(keccak256('supportsInterface(bytes4)'))
264    */
265 
266   /**
267    * @dev a mapping of interface id to whether or not it's supported
268    */
269   mapping(bytes4 => bool) internal supportedInterfaces;
270 
271   /**
272    * @dev A contract implementing SupportsInterfaceWithLookup
273    * implement ERC165 itself
274    */
275   constructor()
276     public
277   {
278     _registerInterface(InterfaceId_ERC165);
279   }
280 
281   /**
282    * @dev implement supportsInterface(bytes4) using a lookup table
283    */
284   function supportsInterface(bytes4 _interfaceId)
285     external
286     view
287     returns (bool)
288   {
289     return supportedInterfaces[_interfaceId];
290   }
291 
292   /**
293    * @dev private method for registering an interface
294    */
295   function _registerInterface(bytes4 _interfaceId)
296     internal
297   {
298     require(_interfaceId != 0xffffffff);
299     supportedInterfaces[_interfaceId] = true;
300   }
301 }
302 /**
303  * @title Ownable
304  * @dev The Ownable contract has an owner address, and provides basic authorization control
305  * functions, this simplifies the implementation of "user permissions".
306  */
307 contract Ownable {
308   address public owner;
309 
310 
311   event OwnershipRenounced(address indexed previousOwner);
312   event OwnershipTransferred(
313     address indexed previousOwner,
314     address indexed newOwner
315   );
316 
317 
318   /**
319    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
320    * account.
321    */
322   constructor() public {
323     owner = msg.sender;
324   }
325 
326   /**
327    * @dev Throws if called by any account other than the owner.
328    */
329   modifier onlyOwner() {
330     require(msg.sender == owner);
331     _;
332   }
333 
334   /**
335    * @dev Allows the current owner to relinquish control of the contract.
336    * @notice Renouncing to ownership will leave the contract without an owner.
337    * It will not be possible to call the functions with the `onlyOwner`
338    * modifier anymore.
339    */
340   function renounceOwnership() public onlyOwner {
341     emit OwnershipRenounced(owner);
342     owner = address(0);
343   }
344 
345   /**
346    * @dev Allows the current owner to transfer control of the contract to a newOwner.
347    * @param _newOwner The address to transfer ownership to.
348    */
349   function transferOwnership(address _newOwner) public onlyOwner {
350     _transferOwnership(_newOwner);
351   }
352 
353   /**
354    * @dev Transfers control of the contract to a newOwner.
355    * @param _newOwner The address to transfer ownership to.
356    */
357   function _transferOwnership(address _newOwner) internal {
358     require(_newOwner != address(0));
359     emit OwnershipTransferred(owner, _newOwner);
360     owner = _newOwner;
361   }
362 }
363 /**
364  * @title Operator
365  * @dev Allow two roles: 'owner' or 'operator'
366  *      - owner: admin/superuser (e.g. with financial rights)
367  *      - operator: can update configurations
368  */
369 contract Operator is Ownable {
370     address[] public operators;
371 
372     uint public MAX_OPS = 20; // Default maximum number of operators allowed
373 
374     mapping(address => bool) public isOperator;
375 
376     event OperatorAdded(address operator);
377     event OperatorRemoved(address operator);
378 
379     // @dev Throws if called by any non-operator account. Owner has all ops rights.
380     modifier onlyOperator() {
381         require(
382             isOperator[msg.sender] || msg.sender == owner,
383             "Permission denied. Must be an operator or the owner."
384         );
385         _;
386     }
387 
388     /**
389      * @dev Allows the current owner or operators to add operators
390      * @param _newOperator New operator address
391      */
392     function addOperator(address _newOperator) public onlyOwner {
393         require(
394             _newOperator != address(0),
395             "Invalid new operator address."
396         );
397 
398         // Make sure no dups
399         require(
400             !isOperator[_newOperator],
401             "New operator exists."
402         );
403 
404         // Only allow so many ops
405         require(
406             operators.length < MAX_OPS,
407             "Overflow."
408         );
409 
410         operators.push(_newOperator);
411         isOperator[_newOperator] = true;
412 
413         emit OperatorAdded(_newOperator);
414     }
415 
416     /**
417      * @dev Allows the current owner or operators to remove operator
418      * @param _operator Address of the operator to be removed
419      */
420     function removeOperator(address _operator) public onlyOwner {
421         // Make sure operators array is not empty
422         require(
423             operators.length > 0,
424             "No operator."
425         );
426 
427         // Make sure the operator exists
428         require(
429             isOperator[_operator],
430             "Not an operator."
431         );
432 
433         // Manual array manipulation:
434         // - replace the _operator with last operator in array
435         // - remove the last item from array
436         address lastOperator = operators[operators.length - 1];
437         for (uint i = 0; i < operators.length; i++) {
438             if (operators[i] == _operator) {
439                 operators[i] = lastOperator;
440             }
441         }
442         operators.length -= 1; // remove the last element
443 
444         isOperator[_operator] = false;
445         emit OperatorRemoved(_operator);
446     }
447 
448     // @dev Remove ALL operators
449     function removeAllOps() public onlyOwner {
450         for (uint i = 0; i < operators.length; i++) {
451             isOperator[operators[i]] = false;
452         }
453         operators.length = 0;
454     }
455 }
456 contract Pausable is Operator {
457 
458   event FrozenFunds(address target, bool frozen);
459 
460   bool public isPaused = false;
461   
462   mapping(address => bool)  frozenAccount;
463 
464   modifier whenNotPaused {
465     require(!isPaused);
466     _;
467   }
468 
469   modifier whenPaused {
470     require(isPaused);
471     _;  
472   }
473 
474   modifier whenNotFreeze(address _target) {
475     require(_target != address(0));
476     require(!frozenAccount[_target]);
477     _;
478   }
479 
480   function isFrozen(address _target) external view returns (bool) {
481     require(_target != address(0));
482     return frozenAccount[_target];
483   }
484 
485   function doPause() external  whenNotPaused onlyOwner {
486     isPaused = true;
487   }
488 
489   function doUnpause() external  whenPaused onlyOwner {
490     isPaused = false;
491   }
492 
493   function freezeAccount(address _target, bool _freeze) public onlyOwner {
494     require(_target != address(0));
495     frozenAccount[_target] = _freeze;
496     emit FrozenFunds(_target, _freeze);
497   }
498 
499 }
500 
501 interface ERC998ERC721TopDown {
502     event ReceivedChild(address indexed _from, uint256 indexed _tokenId, address indexed _childContract, uint256 _childTokenId);
503     event TransferChild(uint256 indexed tokenId, address indexed _to, address indexed _childContract, uint256 _childTokenId);
504 
505     function rootOwnerOf(uint256 _tokenId) external view returns (bytes32 rootOwner);
506     function rootOwnerOfChild(address _childContract, uint256 _childTokenId) external view returns (bytes32 rootOwner);
507     function ownerOfChild(address _childContract, uint256 _childTokenId) external view returns (bytes32 parentTokenOwner, uint256 parentTokenId);
508     function onERC721Received(address _operator, address _from, uint256 _childTokenId, bytes _data) external returns (bytes4);
509     function transferChild(uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId) external;
510     function safeTransferChild(uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId) external;
511     function safeTransferChild(uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId, bytes _data) external;
512     function transferChildToParent(uint256 _fromTokenId, address _toContract, uint256 _toTokenId, address _childContract, uint256 _childTokenId, bytes _data) external;
513     // getChild function enables older contracts like cryptokitties to be transferred into a composable
514     // The _childContract must approve this contract. Then getChild can be called.
515     function getChild(address _from, uint256 _tokenId, address _childContract, uint256 _childTokenId) external;
516 }
517 
518 interface ERC998ERC721TopDownEnumerable {
519     function totalChildContracts(uint256 _tokenId) external view returns (uint256);
520     function childContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address childContract);
521     function totalChildTokens(uint256 _tokenId, address _childContract) external view returns (uint256);
522     function childTokenByIndex(uint256 _tokenId, address _childContract, uint256 _index) external view returns (uint256 childTokenId);
523 }
524 
525 interface ERC998ERC20TopDown {
526     event ReceivedERC20(address indexed _from, uint256 indexed _tokenId, address indexed _erc20Contract, uint256 _value);
527     event TransferERC20(uint256 indexed _tokenId, address indexed _to, address indexed _erc20Contract, uint256 _value);
528 
529     function tokenFallback(address _from, uint256 _value, bytes _data) external;
530     function balanceOfERC20(uint256 _tokenId, address __erc20Contract) external view returns (uint256);
531     function transferERC20(uint256 _tokenId, address _to, address _erc20Contract, uint256 _value) external;
532     function transferERC223(uint256 _tokenId, address _to, address _erc223Contract, uint256 _value, bytes _data) external;
533     function getERC20(address _from, uint256 _tokenId, address _erc20Contract, uint256 _value) external;
534 
535 }
536 
537 interface ERC998ERC20TopDownEnumerable {
538     function totalERC20Contracts(uint256 _tokenId) external view returns (uint256);
539     function erc20ContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address);
540 }
541 
542 interface ERC20AndERC223 {
543     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
544     function transfer(address to, uint value) external returns (bool success);
545     function transfer(address to, uint value, bytes data) external returns (bool success);
546     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
547 }
548 
549 interface ERC998ERC721BottomUp {
550     function transferToParent(address _from, address _toContract, uint256 _toTokenId, uint256 _tokenId, bytes _data) external;
551 }
552 
553 contract ComposableTopDown is Pausable, ERC721, ERC998ERC721TopDown, ERC998ERC721TopDownEnumerable,
554 ERC998ERC20TopDown, ERC998ERC20TopDownEnumerable {
555     // return this.rootOwnerOf.selector ^ this.rootOwnerOfChild.selector ^
556     //   this.tokenOwnerOf.selector ^ this.ownerOfChild.selector;
557     bytes32 constant ERC998_MAGIC_VALUE = 0xcd740db5;
558 
559     // tokenId => token owner
560     mapping(uint256 => address) internal tokenIdToTokenOwner;
561 
562     // root token owner address => (tokenId => approved address)
563     mapping(address => mapping(uint256 => address)) internal rootOwnerAndTokenIdToApprovedAddress;
564 
565     // token owner address => token count
566     mapping(address => uint256) internal tokenOwnerToTokenCount;
567 
568     // token owner => (operator address => bool)
569     mapping(address => mapping(address => bool)) internal tokenOwnerToOperators;
570 
571 
572     //constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {}
573 
574   function _mint(address _to,uint256 _tokenId) internal whenNotPaused {
575     tokenIdToTokenOwner[_tokenId] = _to;
576     tokenOwnerToTokenCount[_to]++;
577     emit Transfer(address(0), _to, _tokenId);
578   }
579 
580     //from zepellin ERC721Receiver.sol
581     //old version
582     bytes4 constant ERC721_RECEIVED_OLD = 0xf0b9e5ba;
583     //new version
584     bytes4 constant ERC721_RECEIVED_NEW = 0x150b7a02;
585 
586     ////////////////////////////////////////////////////////
587     // ERC721 implementation
588     ////////////////////////////////////////////////////////
589 
590     function isContract(address _addr) internal view returns (bool) {
591         uint256 size;
592         assembly {size := extcodesize(_addr)}
593         return size > 0;
594     }
595 
596     function rootOwnerOf(uint256 _tokenId) public view returns (bytes32 rootOwner) {
597         return rootOwnerOfChild(address(0), _tokenId);
598     }
599 
600     // returns the owner at the top of the tree of composables
601     // Use Cases handled:
602     // Case 1: Token owner is this contract and token.
603     // Case 2: Token owner is other top-down composable
604     // Case 3: Token owner is other contract
605     // Case 4: Token owner is user
606     function rootOwnerOfChild(address _childContract, uint256 _childTokenId) public view returns (bytes32 rootOwner) {
607         address rootOwnerAddress;
608         if (_childContract != address(0)) {
609             (rootOwnerAddress, _childTokenId) = _ownerOfChild(_childContract, _childTokenId);
610         }
611         else {
612             rootOwnerAddress = tokenIdToTokenOwner[_childTokenId];
613         }
614         // Case 1: Token owner is this contract and token.
615         while (rootOwnerAddress == address(this)) {
616             (rootOwnerAddress, _childTokenId) = _ownerOfChild(rootOwnerAddress, _childTokenId);
617         }
618 
619         bool callSuccess;
620         bytes memory calldata;
621         // 0xed81cdda == rootOwnerOfChild(address,uint256)
622         calldata = abi.encodeWithSelector(0xed81cdda, address(this), _childTokenId);
623         assembly {
624             callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
625             if callSuccess {
626                 rootOwner := mload(calldata)
627             }
628         }
629         if(callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
630             // Case 2: Token owner is other top-down composable
631             return rootOwner;
632         }
633         else {
634             // Case 3: Token owner is other contract
635             // Or
636             // Case 4: Token owner is user
637             return ERC998_MAGIC_VALUE << 224 | bytes32(rootOwnerAddress);
638         }
639     }
640 
641 
642     // returns the owner at the top of the tree of composables
643 
644     function ownerOf(uint256 _tokenId) public view returns (address tokenOwner) {
645         tokenOwner = tokenIdToTokenOwner[_tokenId];
646         require(tokenOwner != address(0));
647         return tokenOwner;
648     }
649 
650     function balanceOf(address _tokenOwner) external view returns (uint256) {
651         require(_tokenOwner != address(0));
652         return tokenOwnerToTokenCount[_tokenOwner];
653     }
654 
655     function approve(address _approved, uint256 _tokenId) external whenNotPaused {
656         address rootOwner = address(rootOwnerOf(_tokenId));
657         require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender]);
658         rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] = _approved;
659         emit Approval(rootOwner, _approved, _tokenId);
660     }
661 
662     function getApproved(uint256 _tokenId) public view returns (address)  {
663         address rootOwner = address(rootOwnerOf(_tokenId));
664         return rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId];
665     }
666 
667     function setApprovalForAll(address _operator, bool _approved) external whenNotPaused {
668         require(_operator != address(0));
669         tokenOwnerToOperators[msg.sender][_operator] = _approved;
670         emit ApprovalForAll(msg.sender, _operator, _approved);
671     }
672 
673     function isApprovedForAll(address _owner, address _operator) external view returns (bool)  {
674         require(_owner != address(0));
675         require(_operator != address(0));
676         return tokenOwnerToOperators[_owner][_operator];
677     }
678 
679 
680     function _transferFrom(address _from, address _to, uint256 _tokenId) internal whenNotPaused {
681         require(_from != address(0));
682         require(tokenIdToTokenOwner[_tokenId] == _from);
683         require(_to != address(0));
684         require(!frozenAccount[_from]);                  
685         require(!frozenAccount[_to]); 
686         if(msg.sender != _from) {
687             bytes32 rootOwner;
688             bool callSuccess;
689             // 0xed81cdda == rootOwnerOfChild(address,uint256)
690             bytes memory calldata = abi.encodeWithSelector(0xed81cdda, address(this), _tokenId);
691             assembly {
692                 callSuccess := staticcall(gas, _from, add(calldata, 0x20), mload(calldata), calldata, 0x20)
693                 if callSuccess {
694                     rootOwner := mload(calldata)
695                 }
696             }
697             if(callSuccess == true) {
698                 require(rootOwner >> 224 != ERC998_MAGIC_VALUE, "Token is child of other top down composable");
699             }
700             require(tokenOwnerToOperators[_from][msg.sender] ||
701             rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId] == msg.sender);
702         }
703 
704         // clear approval
705         if (rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId] != address(0)) {
706             delete rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId];
707             emit Approval(_from, address(0), _tokenId);
708         }
709 
710         // remove and transfer token
711         if (_from != _to) {
712             assert(tokenOwnerToTokenCount[_from] > 0);
713             tokenOwnerToTokenCount[_from]--;
714             tokenIdToTokenOwner[_tokenId] = _to;
715             tokenOwnerToTokenCount[_to]++;
716         }
717         emit Transfer(_from, _to, _tokenId);
718 
719     }
720 
721     function transferFrom(address _from, address _to, uint256 _tokenId) external {
722         _transferFrom(_from, _to, _tokenId);
723     }
724 
725     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
726         _transferFrom(_from, _to, _tokenId);
727         if (isContract(_to)) {
728             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, "");
729             require(retval == ERC721_RECEIVED_OLD);
730         }
731     }
732 
733     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
734         _transferFrom(_from, _to, _tokenId);
735         if (isContract(_to)) {
736             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
737             require(retval == ERC721_RECEIVED_OLD);
738         }
739     }
740 
741     ////////////////////////////////////////////////////////
742     // ERC998ERC721 and ERC998ERC721Enumerable implementation
743     ////////////////////////////////////////////////////////
744 
745     // tokenId => child contract
746     mapping(uint256 => address[]) internal childContracts;
747 
748     // tokenId => (child address => contract index+1)
749     mapping(uint256 => mapping(address => uint256)) internal childContractIndex;
750 
751     // tokenId => (child address => array of child tokens)
752     mapping(uint256 => mapping(address => uint256[])) internal childTokens;
753 
754     // tokenId => (child address => (child token => child index+1)
755     mapping(uint256 => mapping(address => mapping(uint256 => uint256))) internal childTokenIndex;
756 
757     // child address => childId => tokenId
758     mapping(address => mapping(uint256 => uint256)) internal childTokenOwner;
759 
760 
761     function _removeChild(uint256 _tokenId, address _childContract, uint256 _childTokenId) internal whenNotPaused {
762         uint256 tokenIndex = childTokenIndex[_tokenId][_childContract][_childTokenId];
763         require(tokenIndex != 0, "Child token not owned by token.");
764 
765         // remove child token
766         uint256 lastTokenIndex = childTokens[_tokenId][_childContract].length - 1;
767         uint256 lastToken = childTokens[_tokenId][_childContract][lastTokenIndex];
768         // if (_childTokenId == lastToken) {
769             childTokens[_tokenId][_childContract][tokenIndex - 1] = lastToken;
770             childTokenIndex[_tokenId][_childContract][lastToken] = tokenIndex;
771         // }
772         childTokens[_tokenId][_childContract].length--;
773         delete childTokenIndex[_tokenId][_childContract][_childTokenId];
774         delete childTokenOwner[_childContract][_childTokenId];
775 
776         // remove contract
777         if (lastTokenIndex == 0) {
778             uint256 lastContractIndex = childContracts[_tokenId].length - 1;
779             address lastContract = childContracts[_tokenId][lastContractIndex];
780             if (_childContract != lastContract) {
781                 uint256 contractIndex = childContractIndex[_tokenId][_childContract];
782                 childContracts[_tokenId][contractIndex] = lastContract;
783                 childContractIndex[_tokenId][lastContract] = contractIndex;
784             }
785             childContracts[_tokenId].length--;
786             delete childContractIndex[_tokenId][_childContract];
787         }
788     }
789 
790     function safeTransferChild(uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId) external {
791         _transferChild(_fromTokenId, _to, _childContract, _childTokenId);
792         ERC721(_childContract).safeTransferFrom(this, _to, _childTokenId);
793     }
794 
795     function safeTransferChild(uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId, bytes _data) external {
796         _transferChild(_fromTokenId, _to, _childContract, _childTokenId);
797         ERC721(_childContract).safeTransferFrom(this, _to, _childTokenId, _data); 
798     }
799 
800     function transferChild(uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId) external {
801         _transferChild(_fromTokenId, _to, _childContract, _childTokenId);
802         //this is here to be compatible with cryptokitties and other old contracts that require being owner and approved
803         // before transferring.
804         //does not work with current standard which does not allow approving self, so we must let it fail in that case.
805         //0x095ea7b3 == "approve(address,uint256)"
806         bytes memory calldata = abi.encodeWithSelector(0x095ea7b3, this, _childTokenId);
807         assembly {
808             let success := call(gas, _childContract, 0, add(calldata, 0x20), mload(calldata), calldata, 0)
809         }
810         ERC721(_childContract).transferFrom(this, _to, _childTokenId);
811     }
812 
813     function _transferChild(uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId) internal {
814         uint256 tokenId = childTokenOwner[_childContract][_childTokenId];
815         require(tokenId > 0 || childTokenIndex[tokenId][_childContract][_childTokenId] > 0);
816         require(tokenId == _fromTokenId);
817         require(_to != address(0));
818         address rootOwner = address(rootOwnerOf(tokenId));
819         require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
820         rootOwnerAndTokenIdToApprovedAddress[rootOwner][tokenId] == msg.sender);
821         _removeChild(tokenId, _childContract, _childTokenId);
822         emit TransferChild(_fromTokenId, _to, _childContract, _childTokenId);
823     }
824 
825     function transferChildToParent(uint256 _fromTokenId, address _toContract, uint256 _toTokenId, address _childContract, uint256 _childTokenId, bytes _data) external {
826         uint256 tokenId = childTokenOwner[_childContract][_childTokenId];
827         require(tokenId > 0 || childTokenIndex[tokenId][_childContract][_childTokenId] > 0);
828         require(tokenId == _fromTokenId);
829         require(_toContract != address(0));
830         address rootOwner = address(rootOwnerOf(tokenId));
831         require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
832         rootOwnerAndTokenIdToApprovedAddress[rootOwner][tokenId] == msg.sender);
833         _removeChild(_fromTokenId, _childContract, _childTokenId);
834         ERC998ERC721BottomUp(_childContract).transferToParent(address(this), _toContract, _toTokenId, _childTokenId, _data);
835         emit TransferChild(_fromTokenId, _toContract, _childContract, _childTokenId);
836     }
837 
838 
839     // this contract has to be approved first in _childContract
840     function getChild(address _from, uint256 _tokenId, address _childContract, uint256 _childTokenId) external {
841         _receiveChild(_from, _tokenId, _childContract, _childTokenId);
842         require(_from == msg.sender ||
843         ERC721(_childContract).isApprovedForAll(_from, msg.sender) ||
844         ERC721(_childContract).getApproved(_childTokenId) == msg.sender);
845         ERC721(_childContract).transferFrom(_from, this, _childTokenId);
846     }
847 
848     function onERC721Received(address _from, uint256 _childTokenId, bytes _data) external returns (bytes4) {
849         require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the child token to.");
850         // convert up to 32 bytes of_data to uint256, owner nft tokenId passed as uint in bytes
851         uint256 tokenId;
852         assembly {tokenId := calldataload(132)}
853         if (_data.length < 32) {
854             tokenId = tokenId >> 256 - _data.length * 8;
855         }
856         _receiveChild(_from, tokenId, msg.sender, _childTokenId);
857         require(ERC721(msg.sender).ownerOf(_childTokenId) != address(0), "Child token not owned.");
858         return ERC721_RECEIVED_OLD;
859     }
860 
861     function onERC721Received(address _operator, address _from, uint256 _childTokenId, bytes _data) external returns (bytes4) {
862         require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the child token to.");
863         // convert up to 32 bytes of_data to uint256, owner nft tokenId passed as uint in bytes
864         uint256 tokenId;
865         assembly {tokenId := calldataload(164)}
866         if (_data.length < 32) {
867             tokenId = tokenId >> 256 - _data.length * 8;
868         }
869         _receiveChild(_from, tokenId, msg.sender, _childTokenId);
870         require(ERC721(msg.sender).ownerOf(_childTokenId) != address(0), "Child token not owned.");
871         return ERC721_RECEIVED_NEW;
872     }
873 
874     function _receiveChild(address _from, uint256 _tokenId, address _childContract, uint256 _childTokenId) internal whenNotPaused {
875         require(tokenIdToTokenOwner[_tokenId] != address(0), "_tokenId does not exist.");
876         require(childTokenIndex[_tokenId][_childContract][_childTokenId] == 0, "Cannot receive child token because it has already been received.");
877         uint256 childTokensLength = childTokens[_tokenId][_childContract].length;
878         if (childTokensLength == 0) {
879             childContractIndex[_tokenId][_childContract] = childContracts[_tokenId].length;
880             childContracts[_tokenId].push(_childContract);
881         }
882         childTokens[_tokenId][_childContract].push(_childTokenId);
883         childTokenIndex[_tokenId][_childContract][_childTokenId] = childTokensLength + 1;
884         childTokenOwner[_childContract][_childTokenId] = _tokenId;
885         emit ReceivedChild(_from, _tokenId, _childContract, _childTokenId);
886     }
887 
888     function _ownerOfChild(address _childContract, uint256 _childTokenId) internal view returns (address parentTokenOwner, uint256 parentTokenId) {
889         parentTokenId = childTokenOwner[_childContract][_childTokenId];
890         require(parentTokenId > 0 || childTokenIndex[parentTokenId][_childContract][_childTokenId] > 0);
891         return (tokenIdToTokenOwner[parentTokenId], parentTokenId);
892     }
893 
894     function ownerOfChild(address _childContract, uint256 _childTokenId) external view returns (bytes32 parentTokenOwner, uint256 parentTokenId) {
895         parentTokenId = childTokenOwner[_childContract][_childTokenId];
896         require(parentTokenId > 0 || childTokenIndex[parentTokenId][_childContract][_childTokenId] > 0);
897         return (ERC998_MAGIC_VALUE << 224 | bytes32(tokenIdToTokenOwner[parentTokenId]), parentTokenId);
898     }
899 
900     function childExists(address _childContract, uint256 _childTokenId) external view returns (bool) {
901         uint256 tokenId = childTokenOwner[_childContract][_childTokenId];
902         return childTokenIndex[tokenId][_childContract][_childTokenId] != 0;
903     }
904 
905     function totalChildContracts(uint256 _tokenId) external view returns (uint256) {
906         return childContracts[_tokenId].length;
907     }
908 
909     function childContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address childContract) {
910         require(_index < childContracts[_tokenId].length, "Contract address does not exist for this token and index.");
911         return childContracts[_tokenId][_index];
912     }
913 
914     function totalChildTokens(uint256 _tokenId, address _childContract) external view returns (uint256) {
915         return childTokens[_tokenId][_childContract].length;
916     }
917 
918     function childTokenByIndex(uint256 _tokenId, address _childContract, uint256 _index) external view returns (uint256 childTokenId) {
919         require(_index < childTokens[_tokenId][_childContract].length, "Token does not own a child token at contract address and index.");
920         return childTokens[_tokenId][_childContract][_index];
921     }
922 
923     ////////////////////////////////////////////////////////
924     // ERC998ERC223 and ERC998ERC223Enumerable implementation
925     ////////////////////////////////////////////////////////
926 
927     // tokenId => token contract
928     mapping(uint256 => address[]) erc20Contracts;
929 
930     // tokenId => (token contract => token contract index)
931     mapping(uint256 => mapping(address => uint256)) erc20ContractIndex;
932 
933     // tokenId => (token contract => balance)
934     mapping(uint256 => mapping(address => uint256)) erc20Balances;
935 
936     function balanceOfERC20(uint256 _tokenId, address _erc20Contract) external view returns (uint256) {
937         return erc20Balances[_tokenId][_erc20Contract];
938     }
939 
940     function removeERC20(uint256 _tokenId, address _erc20Contract, uint256 _value) private {
941         if (_value == 0) {
942             return;
943         }
944         uint256 erc20Balance = erc20Balances[_tokenId][_erc20Contract];
945         require(erc20Balance >= _value, "Not enough token available to transfer.");
946         uint256 newERC20Balance = erc20Balance - _value;
947         erc20Balances[_tokenId][_erc20Contract] = newERC20Balance;
948         if (newERC20Balance == 0) {
949             uint256 lastContractIndex = erc20Contracts[_tokenId].length - 1;
950             address lastContract = erc20Contracts[_tokenId][lastContractIndex];
951             if (_erc20Contract != lastContract) {
952                 uint256 contractIndex = erc20ContractIndex[_tokenId][_erc20Contract];
953                 erc20Contracts[_tokenId][contractIndex] = lastContract;
954                 erc20ContractIndex[_tokenId][lastContract] = contractIndex;
955             }
956             erc20Contracts[_tokenId].length--;
957             delete erc20ContractIndex[_tokenId][_erc20Contract];
958         }
959     }
960 
961 
962     function transferERC20(uint256 _tokenId, address _to, address _erc20Contract, uint256 _value) external {
963         require(_to != address(0));
964         address rootOwner = address(rootOwnerOf(_tokenId));
965         require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
966         rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] == msg.sender);
967         removeERC20(_tokenId, _erc20Contract, _value);
968         require(ERC20AndERC223(_erc20Contract).transfer(_to, _value), "ERC20 transfer failed.");
969         emit TransferERC20(_tokenId, _to, _erc20Contract, _value);
970     }
971 
972     // implementation of ERC 223
973     function transferERC223(uint256 _tokenId, address _to, address _erc223Contract, uint256 _value, bytes _data) external {
974         require(_to != address(0));
975         address rootOwner = address(rootOwnerOf(_tokenId));
976         require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] ||
977         rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] == msg.sender);
978         removeERC20(_tokenId, _erc223Contract, _value);
979         require(ERC20AndERC223(_erc223Contract).transfer(_to, _value, _data), "ERC223 transfer failed.");
980         emit TransferERC20(_tokenId, _to, _erc223Contract, _value);
981     }
982 
983     // this contract has to be approved first by _erc20Contract
984     function getERC20(address _from, uint256 _tokenId, address _erc20Contract, uint256 _value) public {
985         bool allowed = _from == msg.sender;
986         if (!allowed) {
987             uint256 remaining;
988             // 0xdd62ed3e == allowance(address,address)
989             bytes memory calldata = abi.encodeWithSelector(0xdd62ed3e, _from, msg.sender);
990             bool callSuccess;
991             assembly {
992                 callSuccess := staticcall(gas, _erc20Contract, add(calldata, 0x20), mload(calldata), calldata, 0x20)
993                 if callSuccess {
994                     remaining := mload(calldata)
995                 }
996             }
997             require(callSuccess, "call to allowance failed");
998             require(remaining >= _value, "Value greater than remaining");
999             allowed = true;
1000         }
1001         require(allowed, "not allowed to getERC20");
1002         erc20Received(_from, _tokenId, _erc20Contract, _value);
1003         require(ERC20AndERC223(_erc20Contract).transferFrom(_from, this, _value), "ERC20 transfer failed.");
1004     }
1005 
1006     function erc20Received(address _from, uint256 _tokenId, address _erc20Contract, uint256 _value) private {
1007         require(tokenIdToTokenOwner[_tokenId] != address(0), "_tokenId does not exist.");
1008         if (_value == 0) {
1009             return;
1010         }
1011         uint256 erc20Balance = erc20Balances[_tokenId][_erc20Contract];
1012         if (erc20Balance == 0) {
1013             erc20ContractIndex[_tokenId][_erc20Contract] = erc20Contracts[_tokenId].length;
1014             erc20Contracts[_tokenId].push(_erc20Contract);
1015         }
1016         erc20Balances[_tokenId][_erc20Contract] += _value;
1017         emit ReceivedERC20(_from, _tokenId, _erc20Contract, _value);
1018     }
1019 
1020     // used by ERC 223
1021     function tokenFallback(address _from, uint256 _value, bytes _data) external {
1022         require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the token to.");
1023         require(isContract(msg.sender), "msg.sender is not a contract");
1024         /**************************************
1025         * TODO move to library
1026         **************************************/
1027         // convert up to 32 bytes of_data to uint256, owner nft tokenId passed as uint in bytes
1028         uint256 tokenId;
1029         assembly {
1030             tokenId := calldataload(132)
1031         }
1032         if (_data.length < 32) {
1033             tokenId = tokenId >> 256 - _data.length * 8;
1034         }
1035         //END TODO
1036         erc20Received(_from, tokenId, msg.sender, _value);
1037     }
1038 
1039 
1040     function erc20ContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address) {
1041         require(_index < erc20Contracts[_tokenId].length, "Contract address does not exist for this token and index.");
1042         return erc20Contracts[_tokenId][_index];
1043     }
1044 
1045     function totalERC20Contracts(uint256 _tokenId) external view returns (uint256) {
1046         return erc20Contracts[_tokenId].length;
1047     }
1048 }
1049 
1050 contract ERC998TopDownToken is SupportsInterfaceWithLookup, ERC721Enumerable, ERC721Metadata, ComposableTopDown {
1051   using UrlStr for string;
1052   using SafeMath for uint256;
1053 
1054   string internal BASE_URL = "https://www.bitguild.com/bitizens/api/avatar/getAvatar/00000000";
1055 
1056   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
1057   /**
1058    * 0x780e9d63 ===
1059    *   bytes4(keccak256('totalSupply()')) ^
1060    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1061    *   bytes4(keccak256('tokenByIndex(uint256)'))
1062    */
1063   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
1064               
1065   // Mapping from owner to list of owned token IDs
1066   mapping(address => uint256[]) internal ownedTokens;
1067 
1068   // Mapping from token ID to index of the owner tokens list
1069   mapping(uint256 => uint256) internal ownedTokensIndex;
1070 
1071   // Array with all token ids, used for enumeration
1072   uint256[] internal allTokens;
1073 
1074   // Mapping from token id to position in the allTokens array
1075   mapping(uint256 => uint256) internal allTokensIndex;
1076 
1077   /**
1078    * @dev Constructor function
1079    */
1080   constructor() public {
1081     // register the supported interfaces to conform to ERC721 via ERC165
1082     _registerInterface(InterfaceId_ERC721Enumerable);
1083     _registerInterface(InterfaceId_ERC721Metadata);
1084     _registerInterface(bytes4(ERC998_MAGIC_VALUE));
1085   }
1086 
1087   modifier existsToken(uint256 _tokenId){
1088     address owner = tokenIdToTokenOwner[_tokenId];
1089     require(owner != address(0), "This tokenId is invalid"); 
1090     _;
1091   }
1092 
1093   function updateBaseURI(string _url) external onlyOwner {
1094     BASE_URL = _url;
1095   }
1096 
1097   /**
1098    * @dev Gets the token name
1099    * @return string representing the token name
1100    */
1101   function name() external view returns (string) {
1102     return "Bitizen";
1103   }
1104 
1105   /**
1106    * @dev Gets the token symbol
1107    * @return string representing the token symbol
1108    */
1109   function symbol() external view returns (string) {
1110     return "BTZN";
1111   }
1112 
1113   /**
1114    * @dev Returns an URI for a given token ID
1115    * Throws if the token ID does not exist. May return an empty string.
1116    * @param _tokenId uint256 ID of the token to query
1117    */
1118   function tokenURI(uint256 _tokenId) external view existsToken(_tokenId) returns (string) {
1119     return BASE_URL.generateUrl(_tokenId);
1120   }
1121 
1122   /**
1123    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1124    * @param _owner address owning the tokens list to be accessed
1125    * @param _index uint256 representing the index to be accessed of the requested tokens list
1126    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1127    */
1128   function tokenOfOwnerByIndex(
1129     address _owner,
1130     uint256 _index
1131   )
1132     public
1133     view
1134     returns (uint256)
1135   {
1136     require(address(0) != _owner);
1137     require(_index < tokenOwnerToTokenCount[_owner]);
1138     return ownedTokens[_owner][_index];
1139   }
1140 
1141   /**
1142    * @dev Gets the total amount of tokens stored by the contract
1143    * @return uint256 representing the total amount of tokens
1144    */
1145   function totalSupply() public view returns (uint256) {
1146     return allTokens.length;
1147   }
1148 
1149   /**
1150    * @dev Gets the token ID at a given index of all the tokens in this contract
1151    * Reverts if the index is greater or equal to the total number of tokens
1152    * @param _index uint256 representing the index to be accessed of the tokens list
1153    * @return uint256 token ID at the given index of the tokens list
1154    */
1155   function tokenByIndex(uint256 _index) public view returns (uint256) {
1156     require(_index < totalSupply());
1157     return allTokens[_index];
1158   }
1159 
1160   /**
1161    * @dev Internal function to add a token ID to the list of a given address
1162    * @param _to address representing the new owner of the given token ID
1163    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1164    */
1165   function _addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
1166     uint256 length = ownedTokens[_to].length;
1167     ownedTokens[_to].push(_tokenId);
1168     ownedTokensIndex[_tokenId] = length;
1169   }
1170 
1171   /**
1172    * @dev Internal function to remove a token ID from the list of a given address
1173    * @param _from address representing the previous owner of the given token ID
1174    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1175    */
1176   function _removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused {
1177     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1178     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1179     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1180 
1181     ownedTokens[_from][tokenIndex] = lastToken;
1182     ownedTokens[_from][lastTokenIndex] = 0;
1183     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1184     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1185     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1186 
1187     ownedTokens[_from].length--;
1188     ownedTokensIndex[_tokenId] = 0;
1189     ownedTokensIndex[lastToken] = tokenIndex;
1190   }
1191 
1192   /**
1193    * @dev Internal function to mint a new token
1194    * Reverts if the given token ID already exists
1195    * @param _to address the beneficiary that will own the minted token
1196    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1197    */
1198   function _mint(address _to, uint256 _tokenId) internal whenNotPaused {
1199     super._mint(_to, _tokenId);
1200     _addTokenTo(_to,_tokenId);
1201     allTokensIndex[_tokenId] = allTokens.length;
1202     allTokens.push(_tokenId);
1203   }
1204 
1205   //override
1206   //add Enumerable info
1207   function _transferFrom(address _from, address _to, uint256 _tokenId) internal whenNotPaused {
1208     // not allown to transfer when  only one  avatar
1209     super._transferFrom(_from, _to, _tokenId);
1210     _addTokenTo(_to,_tokenId);
1211     _removeTokenFrom(_from, _tokenId);
1212   }
1213 }
1214 
1215 interface AvatarChildService {
1216   /**
1217       @dev if you want your contract become a avatar child, please let your contract inherit this interface
1218       @param _tokenId1  first child token id
1219       @param _tokenId2  second child token id
1220       @return  true will unmount first token before mount ,false will directly mount child
1221    */
1222    function compareItemSlots(uint256 _tokenId1, uint256 _tokenId2) external view returns (bool _res);
1223 
1224   /**
1225    @dev if you want your contract become a avatar child, please let your contract inherit this interface
1226    @return return true will be to avatar child
1227    */
1228    function isAvatarChild(uint256 _tokenId) external view returns(bool);
1229 }
1230 
1231 interface AvatarService {
1232   function updateAvatarInfo(address _owner, uint256 _tokenId, string _name, uint256 _dna) external;
1233   function createAvatar(address _owner, string _name, uint256 _dna) external  returns(uint256);
1234   function getMountedChildren(address _owner,uint256 _tokenId, address _childAddress) external view returns(uint256[]); 
1235   function getAvatarInfo(uint256 _tokenId) external view returns (string _name, uint256 _dna);
1236   function getOwnedAvatars(address _owner) external view returns(uint256[] _avatars);
1237   function unmount(address _owner, address _childContract, uint256[] _children, uint256 _avatarId) external;
1238   function mount(address _owner, address _childContract, uint256[] _children, uint256 _avatarId) external;
1239 }
1240 
1241 contract AvatarToken is ERC998TopDownToken, AvatarService {
1242   
1243   using UrlStr for string;
1244 
1245   enum ChildHandleType{NULL, MOUNT, UNMOUNT}
1246 
1247   event ChildHandle(address indexed from, uint256 parent, address indexed childAddr, uint256[] children, ChildHandleType _type);
1248 
1249   event AvatarTransferStateChanged(address indexed _owner, bool _newState);
1250 
1251   struct Avatar {
1252     // avatar name
1253     string name;
1254     // avatar gen,this decide avatar appearance 
1255     uint256 dna;
1256   }
1257   
1258   // avatar id index
1259   uint256 internal avatarIndex = 0;
1260   // avatar id => avatar
1261   mapping(uint256 => Avatar) avatars;
1262   // true avatar can do transfer 
1263   bool public avatarTransferState = false;
1264 
1265   function changeAvatarTransferState(bool _newState) public onlyOwner {
1266 	if(avatarTransferState == _newState) return;
1267     avatarTransferState = _newState;
1268     emit AvatarTransferStateChanged(owner, avatarTransferState);
1269   }
1270 
1271   function createAvatar(address _owner, string _name, uint256 _dna) external onlyOperator returns(uint256) {
1272     return _createAvatar(_owner, _name, _dna);
1273   }
1274 
1275   function getMountedChildren(address _owner, uint256 _avatarId, address _childAddress)
1276   external
1277   view 
1278   onlyOperator
1279   existsToken(_avatarId) 
1280   returns(uint256[]) {
1281     require(_childAddress != address(0));
1282     require(tokenIdToTokenOwner[_avatarId] == _owner);
1283     return childTokens[_avatarId][_childAddress];
1284   }
1285   
1286   function updateAvatarInfo(address _owner, uint256 _avatarId, string _name, uint256 _dna) external onlyOperator existsToken(_avatarId){
1287     require(_owner != address(0), "Invalid address");
1288     require(_owner == tokenIdToTokenOwner[_avatarId] || msg.sender == owner);
1289     Avatar storage avatar = avatars[_avatarId];
1290     avatar.name = _name;
1291     avatar.dna = _dna;
1292   }
1293 
1294   function getOwnedAvatars(address _owner) external view onlyOperator returns(uint256[] _avatars) {
1295     require(_owner != address(0));
1296     _avatars = ownedTokens[_owner];
1297   }
1298 
1299   function getAvatarInfo(uint256 _avatarId) external view existsToken(_avatarId) returns(string _name, uint256 _dna) {
1300     Avatar storage avatar = avatars[_avatarId];
1301     _name = avatar.name;
1302     _dna = avatar.dna;
1303   }
1304 
1305   function unmount(address _owner, address _childContract, uint256[] _children, uint256 _avatarId) external onlyOperator {
1306     if(_children.length == 0) return;
1307     require(ownerOf(_avatarId) == _owner); // check avatar owner
1308     uint256[] memory mountedChildren = childTokens[_avatarId][_childContract]; 
1309     if (mountedChildren.length == 0) return;
1310     uint256[] memory unmountChildren = new uint256[](_children.length); // record unmount children 
1311     for(uint8 i = 0; i < _children.length; i++) {
1312       uint256 child = _children[i];
1313       if(_isMounted(mountedChildren, child)){  
1314         unmountChildren[i] = child;
1315         _removeChild(_avatarId, _childContract, child);
1316         ERC721(_childContract).transferFrom(this, _owner, child);
1317       }
1318     }
1319     if(unmountChildren.length > 0 ) 
1320       emit ChildHandle(_owner, _avatarId, _childContract, unmountChildren, ChildHandleType.UNMOUNT);
1321   }
1322 
1323   function mount(address _owner, address _childContract, uint256[] _children, uint256 _avatarId) external onlyOperator {
1324     if(_children.length == 0) return;
1325     require(ownerOf(_avatarId) == _owner); // check avatar owner
1326     for(uint8 i = 0; i < _children.length; i++) {
1327       uint256 child = _children[i];
1328       require(ERC721(_childContract).ownerOf(child) == _owner); // check child owner  
1329       _receiveChild(_owner, _avatarId, _childContract, child);
1330       ERC721(_childContract).transferFrom(_owner, this, child);
1331     }
1332     emit ChildHandle(_owner, _avatarId, _childContract, _children, ChildHandleType.MOUNT);
1333   }
1334 
1335   // check every have mounted children with the will mount child relationship
1336   function _checkChildRule(address _owner, uint256 _avatarId, address _childContract, uint256 _child) internal {
1337     uint256[] memory tokens = childTokens[_avatarId][_childContract];
1338     if (tokens.length == 0) {
1339       if (!AvatarChildService(_childContract).isAvatarChild(_child)) {
1340         revert("it can't be avatar child");
1341       }
1342     }
1343     for (uint256 i = 0; i < tokens.length; i++) {
1344       if (AvatarChildService(_childContract).compareItemSlots(tokens[i], _child)) {
1345         _removeChild(_avatarId, _childContract, tokens[i]);
1346         ERC721(_childContract).transferFrom(this, _owner, tokens[i]);
1347       }
1348     }
1349   }
1350   /// false will ignore not mounted children on this avatar and not exist children
1351   function _isMounted(uint256[] mountedChildren, uint256 _toMountToken) private pure returns (bool) {
1352     for(uint8 i = 0; i < mountedChildren.length; i++) {
1353       if(mountedChildren[i] == _toMountToken){
1354         return true;
1355       }
1356     }
1357     return false;
1358   }
1359 
1360   // create avatar 
1361   function _createAvatar(address _owner, string _name, uint256 _dna) private returns(uint256 _avatarId) {
1362     require(_owner != address(0));
1363     Avatar memory avatar = Avatar(_name, _dna);
1364     _avatarId = ++avatarIndex;
1365     avatars[_avatarId] = avatar;
1366     _mint(_owner, _avatarId);
1367   }
1368 
1369   // override  
1370   function _transferFrom(address _from, address _to, uint256 _avatarId) internal whenNotPaused {
1371     // add transfer control
1372     require(avatarTransferState == true, "current time not allown transfer avatar");
1373     super._transferFrom(_from, _to, _avatarId);
1374   }
1375 
1376   // override
1377   function _receiveChild(address _from, uint256 _avatarId, address _childContract, uint256 _childTokenId) internal whenNotPaused {
1378     _checkChildRule(_from, _avatarId, _childContract, _childTokenId);
1379     super._receiveChild(_from, _avatarId, _childContract, _childTokenId);
1380   }
1381 
1382   function () public payable {
1383     revert();
1384   }
1385 }