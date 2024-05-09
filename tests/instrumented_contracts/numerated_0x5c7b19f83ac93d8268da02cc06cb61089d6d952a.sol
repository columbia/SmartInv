1 pragma solidity ^0.4.24; 
2 interface ERC165 {
3   /**
4    * @notice Query if a contract implements an interface
5    * @param _interfaceId The interface identifier, as specified in ERC-165
6    * @dev Interface identification is specified in ERC-165. This function
7    * uses less than 30,000 gas.
8    */
9   function supportsInterface(bytes4 _interfaceId) external view returns (bool);
10 }
11 
12 interface ERC721 /* is ERC165 */ {
13     /// @dev This emits when ownership of any NFT changes by any mechanism.
14     ///  This event emits when NFTs are created (`from` == 0) and destroyed
15     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
16     ///  may be created and assigned without emitting Transfer. At the time of
17     ///  any transfer, the approved address for that NFT (if any) is reset to none.
18     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
19 
20     /// @dev This emits when the approved address for an NFT is changed or
21     ///  reaffirmed. The zero address indicates there is no approved address.
22     ///  When a Transfer event emits, this also indicates that the approved
23     ///  address for that NFT (if any) is reset to none.
24     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
25 
26     /// @dev This emits when an operator is enabled or disabled for an owner.
27     ///  The operator can manage all NFTs of the owner.
28     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
29 
30     /// @notice Count all NFTs assigned to an owner
31     /// @dev NFTs assigned to the zero address are considered invalid, and this
32     ///  function throws for queries about the zero address.
33     /// @param _owner An address for whom to query the balance
34     /// @return The number of NFTs owned by `_owner`, possibly zero
35     function balanceOf(address _owner) external view returns (uint256);
36 
37     /// @notice Find the owner of an NFT
38     /// @dev NFTs assigned to zero address are considered invalid, and queries
39     ///  about them do throw.
40     /// @param _tokenId The identifier for an NFT
41     /// @return The address of the owner of the NFT
42     function ownerOf(uint256 _tokenId) external view returns (address);
43 
44     /// @notice Transfers the ownership of an NFT from one address to another address
45     /// @dev Throws unless `msg.sender` is the current owner, an authorized
46     ///  operator, or the approved address for this NFT. Throws if `_from` is
47     ///  not the current owner. Throws if `_to` is the zero address. Throws if
48     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
49     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
50     ///  `onERC721Received` on `_to` and throws if the return value is not
51     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
52     /// @param _from The current owner of the NFT
53     /// @param _to The new owner
54     /// @param _tokenId The NFT to transfer
55     /// @param data Additional data with no specified format, sent in call to `_to`
56     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
57 
58     /// @notice Transfers the ownership of an NFT from one address to another address
59     /// @dev This works identically to the other function with an extra data parameter,
60     ///  except this function just sets data to "".
61     /// @param _from The current owner of the NFT
62     /// @param _to The new owner
63     /// @param _tokenId The NFT to transfer
64     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
65 
66     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
67     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
68     ///  THEY MAY BE PERMANENTLY LOST
69     /// @dev Throws unless `msg.sender` is the current owner, an authorized
70     ///  operator, or the approved address for this NFT. Throws if `_from` is
71     ///  not the current owner. Throws if `_to` is the zero address. Throws if
72     ///  `_tokenId` is not a valid NFT.
73     /// @param _from The current owner of the NFT
74     /// @param _to The new owner
75     /// @param _tokenId The NFT to transfer
76     function transferFrom(address _from, address _to, uint256 _tokenId) external;
77 
78     /// @notice Change or reaffirm the approved address for an NFT
79     /// @dev The zero address indicates there is no approved address.
80     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
81     ///  operator of the current owner.
82     /// @param _approved The new approved NFT controller
83     /// @param _tokenId The NFT to approve
84     function approve(address _approved, uint256 _tokenId) external;
85 
86     /// @notice Enable or disable approval for a third party ("operator") to manage
87     ///  all of `msg.sender`'s assets
88     /// @dev Emits the ApprovalForAll event. The contract MUST allow
89     ///  multiple operators per owner.
90     /// @param _operator Address to add to the set of authorized operators
91     /// @param _approved True if the operator is approved, false to revoke approval
92     function setApprovalForAll(address _operator, bool _approved) external;
93 
94     /// @notice Get the approved address for a single NFT
95     /// @dev Throws if `_tokenId` is not a valid NFT.
96     /// @param _tokenId The NFT to find the approved address for
97     /// @return The approved address for this NFT, or the zero address if there is none
98     function getApproved(uint256 _tokenId) external view returns (address);
99 
100     /// @notice Query if an address is an authorized operator for another address
101     /// @param _owner The address that owns the NFTs
102     /// @param _operator The address that acts on behalf of the owner
103     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
104     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
105 }
106 
107 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
108 interface ERC721Enumerable /* is ERC721 */ {
109     /// @notice Count NFTs tracked by this contract
110     /// @return A count of valid NFTs tracked by this contract, where each one of
111     ///  them has an assigned and queryable owner not equal to the zero address
112     function totalSupply() external view returns (uint256);
113 
114     /// @notice Enumerate valid NFTs
115     /// @dev Throws if `_index` >= `totalSupply()`.
116     /// @param _index A counter less than `totalSupply()`
117     /// @return The token identifier for the `_index`th NFT,
118     ///  (sort order not specified)
119     function tokenByIndex(uint256 _index) external view returns (uint256);
120 
121     /// @notice Enumerate NFTs assigned to an owner
122     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
123     ///  `_owner` is the zero address, representing invalid NFTs.
124     /// @param _owner An address where we are interested in NFTs owned by them
125     /// @param _index A counter less than `balanceOf(_owner)`
126     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
127     ///   (sort order not specified)
128     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
129 }
130 
131 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
132 interface ERC721Metadata /* is ERC721 */ {
133   /// @notice A descriptive name for a collection of NFTs in this contract
134   function name() external view returns (string _name);
135 
136   /// @notice An abbreviated name for NFTs in this contract
137   function symbol() external view returns (string _symbol);
138 
139   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
140   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
141   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
142   ///  Metadata JSON Schema".
143   function tokenURI(uint256 _tokenId) external view returns (string);
144 }
145 
146 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
147 interface ERC721TokenReceiver {
148     /// @notice Handle the receipt of an NFT
149     /// @dev The ERC721 smart contract calls this function on the recipient
150     ///  after a `transfer`. This function MAY throw to revert and reject the
151     ///  transfer. Return of other than the magic value MUST result in the
152     ///  transaction being reverted.
153     ///  Note: the contract address is always the message sender.
154     /// @param _operator The address which called `safeTransferFrom` function
155     /// @param _from The address which previously owned the token
156     /// @param _tokenId The NFT identifier which is being transferred
157     /// @param _data Additional data with no specified format
158     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
159     ///  unless throwing
160     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
161 }
162 
163 /**
164  * @title SupportsInterfaceWithLookup
165  * @author Matt Condon (@shrugs)
166  * @dev Implements ERC165 using a lookup table.
167  */
168 contract SupportsInterfaceWithLookup is ERC165 {
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
212 /**
213  * Utility library of inline functions on addresses
214  */
215 library AddressUtils {
216 
217   /**
218    * Returns whether the target address is a contract
219    * @dev This function will return false if invoked during the constructor of a contract,
220    * as the code is not actually created until after the constructor finishes.
221    * @param addr address to check
222    * @return whether the target address is a contract
223    */
224   function isContract(address addr) internal view returns (bool) {
225     uint256 size;
226     // XXX Currently there is no better way to check if there is a contract in an address
227     // than to check the size of the code at that address.
228     // See https://ethereum.stackexchange.com/a/14016/36603
229     // for more details about how this works.
230     // TODO Check this again before the Serenity release, because all addresses will be
231     // contracts then.
232     // solium-disable-next-line security/no-inline-assembly
233     assembly { size := extcodesize(addr) }
234     return size > 0;
235   }
236 
237 }
238  
239 library UrlStr {
240   
241   // generate url by tokenId
242   // baseUrl must end with 00000000
243   function generateUrl(string url,uint256 _tokenId) internal pure returns (string _url){
244     _url = url;
245     bytes memory _tokenURIBytes = bytes(_url);
246     uint256 base_len = _tokenURIBytes.length - 1;
247     _tokenURIBytes[base_len - 7] = byte(48 + _tokenId / 10000000 % 10);
248     _tokenURIBytes[base_len - 6] = byte(48 + _tokenId / 1000000 % 10);
249     _tokenURIBytes[base_len - 5] = byte(48 + _tokenId / 100000 % 10);
250     _tokenURIBytes[base_len - 4] = byte(48 + _tokenId / 10000 % 10);
251     _tokenURIBytes[base_len - 3] = byte(48 + _tokenId / 1000 % 10);
252     _tokenURIBytes[base_len - 2] = byte(48 + _tokenId / 100 % 10);
253     _tokenURIBytes[base_len - 1] = byte(48 + _tokenId / 10 % 10);
254     _tokenURIBytes[base_len - 0] = byte(48 + _tokenId / 1 % 10);
255   }
256 }
257 
258 /**
259  * @title SafeMath
260  * @dev Math operations with safety checks that throw on error
261  */
262 library SafeMath {
263 
264   /**
265   * @dev Multiplies two numbers, throws on overflow.
266   */
267   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268     if (a == 0) {
269       return 0;
270     }
271     uint256 c = a * b;
272     assert(c / a == b);
273     return c;
274   }
275 
276   /**
277   * @dev Integer division of two numbers, truncating the quotient.
278   */
279   function div(uint256 a, uint256 b) internal pure returns (uint256) {
280     // assert(b > 0); // Solidity automatically throws when dividing by 0
281     uint256 c = a / b;
282     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283     return c;
284   }
285 
286   /**
287   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
288   */
289   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290     assert(b <= a);
291     return a - b;
292   }
293 
294   /**
295   * @dev Adds two numbers, throws on overflow.
296   */
297   function add(uint256 a, uint256 b) internal pure returns (uint256) {
298     uint256 c = a + b;
299     assert(c >= a);
300     return c;
301   }
302 }
303  
304 /**
305  * @title Ownable
306  * @dev The Ownable contract has an owner address, and provides basic authorization control
307  * functions, this simplifies the implementation of "user permissions".
308  */
309 contract Ownable {
310   address public owner;
311   event OwnershipRenounced(address indexed previousOwner);
312   event OwnershipTransferred(
313     address indexed previousOwner,
314     address indexed newOwner
315   );
316 
317   /**
318    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
319    * account.
320    */
321   constructor() public {
322     owner = msg.sender;
323   }
324 
325   /**
326    * @dev Throws if called by any account other than the owner.
327    */
328   modifier onlyOwner() {
329     require(msg.sender == owner);
330     _;
331   }
332 
333   /**
334    * @dev Allows the current owner to relinquish control of the contract.
335    * @notice Renouncing to ownership will leave the contract without an owner.
336    * It will not be possible to call the functions with the `onlyOwner`
337    * modifier anymore.
338    */
339   function renounceOwnership() public onlyOwner {
340     emit OwnershipRenounced(owner);
341     owner = address(0);
342   }
343 
344   /**
345    * @dev Allows the current owner to transfer control of the contract to a newOwner.
346    * @param _newOwner The address to transfer ownership to.
347    */
348   function transferOwnership(address _newOwner) public onlyOwner {
349     _transferOwnership(_newOwner);
350   }
351 
352   /**
353    * @dev Transfers control of the contract to a newOwner.
354    * @param _newOwner The address to transfer ownership to.
355    */
356   function _transferOwnership(address _newOwner) internal {
357     require(_newOwner != address(0));
358     emit OwnershipTransferred(owner, _newOwner);
359     owner = _newOwner;
360   }
361 }
362 
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
456  
457 contract Pausable is Operator {
458 
459   event FrozenFunds(address target, bool frozen);
460 
461   bool public isPaused = false;
462   
463   mapping(address => bool)  frozenAccount;
464 
465   modifier whenNotPaused {
466     require(!isPaused);
467     _;
468   }
469 
470   modifier whenPaused {
471     require(isPaused);
472     _;  
473   }
474 
475   modifier whenNotFreeze(address _target) {
476     require(_target != address(0));
477     require(!frozenAccount[_target]);
478     _;
479   }
480 
481   function isFrozen(address _target) external view returns (bool) {
482     require(_target != address(0));
483     return frozenAccount[_target];
484   }
485 
486   function doPause() external  whenNotPaused onlyOwner {
487     isPaused = true;
488   }
489 
490   function doUnpause() external  whenPaused onlyOwner {
491     isPaused = false;
492   }
493 
494   function freezeAccount(address _target, bool _freeze) public onlyOwner {
495     require(_target != address(0));
496     frozenAccount[_target] = _freeze;
497     emit FrozenFunds(_target, _freeze);
498   }
499 
500 }
501 
502 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721, Pausable{
503 
504   bytes4 public constant InterfaceId_ERC721 = 0x80ac58cd;
505   /*
506    * 0x80ac58cd ===
507    *   bytes4(keccak256('balanceOf(address)')) ^
508    *   bytes4(keccak256('ownerOf(uint256)')) ^
509    *   bytes4(keccak256('approve(address,uint256)')) ^
510    *   bytes4(keccak256('getApproved(uint256)')) ^
511    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
512    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
513    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
514    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
515    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
516    */
517 
518   bytes4 public constant InterfaceId_ERC721Exists = 0x4f558e79;
519   /*
520    * 0x4f558e79 ===
521    *   bytes4(keccak256('exists(uint256)'))
522    */
523 
524   using SafeMath for uint256;
525   using AddressUtils for address;
526 
527   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
528   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
529   bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
530 
531   // Mapping from token ID to owner
532   mapping (uint256 => address) internal tokenOwner;
533 
534   // Mapping from token ID to approved address
535   mapping (uint256 => address) internal tokenApprovals;
536 
537   // Mapping from owner to number of owned token
538   mapping (address => uint256) internal ownedTokensCount;
539 
540   // Mapping from owner to operator approvals
541   mapping (address => mapping (address => bool)) internal operatorApprovals;
542 
543   /**
544    * @dev Guarantees msg.sender is owner of the given token
545    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
546    */
547   modifier onlyOwnerOf(uint256 _tokenId) {
548     require(_ownerOf(_tokenId) == msg.sender,"This token not owned by this address");
549     _;
550   }
551   
552   function _ownerOf(uint256 _tokenId) internal view returns(address) {
553     address _owner = tokenOwner[_tokenId];
554     require(_owner != address(0),"Token not exist");
555     return _owner;
556   }
557 
558   /**
559    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
560    * @param _tokenId uint256 ID of the token to validate
561    */
562   modifier canTransfer(uint256 _tokenId) {
563     require(isApprovedOrOwner(msg.sender, _tokenId), "This address have no permisstion");
564     _;
565   }
566 
567   constructor()
568     public
569   {
570     // register the supported interfaces to conform to ERC721 via ERC165
571     _registerInterface(InterfaceId_ERC721);
572     _registerInterface(InterfaceId_ERC721Exists);
573     _registerInterface(ERC721_RECEIVED);
574   }
575 
576   /**
577    * @dev Gets the balance of the specified address
578    * @param _owner address to query the balance of
579    * @return uint256 representing the amount owned by the passed address
580    */
581   function balanceOf(address _owner) external view returns (uint256) {
582     require(_owner != address(0));
583     return ownedTokensCount[_owner];
584   }
585 
586   /**
587    * @dev Gets the owner of the specified token ID
588    * @param _tokenId uint256 ID of the token to query the owner of
589    * @return owner address currently marked as the owner of the given token ID
590    */
591   function ownerOf(uint256 _tokenId) external view returns (address) {
592     return _ownerOf(_tokenId);
593   }
594 
595   /**
596    * @dev Returns whether the specified token exists
597    * @param _tokenId uint256 ID of the token to query the existence of
598    * @return whether the token exists
599    */
600   function exists(uint256 _tokenId) internal view returns (bool) {
601     address owner = tokenOwner[_tokenId];
602     return owner != address(0);
603   }
604 
605   /**
606    * @dev Approves another address to transfer the given token ID
607    * The zero address indicates there is no approved address.
608    * There can only be one approved address per token at a given time.
609    * Can only be called by the token owner or an approved operator.
610    * @param _to address to be approved for the given token ID
611    * @param _tokenId uint256 ID of the token to be approved
612    */
613   function approve(address _to, uint256 _tokenId) external whenNotPaused {
614     address _owner = _ownerOf(_tokenId);
615     require(_to != _owner);
616     require(msg.sender == _owner || operatorApprovals[_owner][msg.sender]);
617 
618     tokenApprovals[_tokenId] = _to;
619     emit Approval(_owner, _to, _tokenId);
620   }
621 
622   /**
623    * @dev Gets the approved address for a token ID, or zero if no address set
624    * @param _tokenId uint256 ID of the token to query the approval of
625    * @return address currently approved for the given token ID
626    */
627   function getApproved(uint256 _tokenId) external view returns (address) {
628     return tokenApprovals[_tokenId];
629   }
630 
631   /**
632    * @dev Sets or unsets the approval of a given operator
633    * An operator is allowed to transfer all tokens of the sender on their behalf
634    * @param _to operator address to set the approval
635    * @param _approved representing the status of the approval to be set
636    */
637   function setApprovalForAll(address _to, bool _approved) external whenNotPaused {
638     require(_to != msg.sender);
639     operatorApprovals[msg.sender][_to] = _approved;
640     emit ApprovalForAll(msg.sender, _to, _approved);
641   }
642 
643   /**
644    * @dev Tells whether an operator is approved by a given owner
645    * @param _owner owner address which you want to query the approval of
646    * @param _operator operator address which you want to query the approval of
647    * @return bool whether the given operator is approved by the given owner
648    */
649   function isApprovedForAll(
650     address _owner,
651     address _operator
652   )
653     external
654     view
655     returns (bool)
656   {
657     return operatorApprovals[_owner][_operator];
658   }
659 
660   /**
661    * @dev Transfers the ownership of a given token ID to another address
662    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
663    * Requires the msg sender to be the owner, approved, or operator
664    * @param _from current owner of the token
665    * @param _to address to receive the ownership of the given token ID
666    * @param _tokenId uint256 ID of the token to be transferred
667   */
668   function transferFrom(
669     address _from,
670     address _to,
671     uint256 _tokenId
672   )
673     external
674     canTransfer(_tokenId)
675   {
676     _transfer(_from,_to,_tokenId);
677   }
678 
679 
680   function _transfer(
681     address _from,
682     address _to,
683     uint256 _tokenId) internal {
684     require(_from != address(0));
685     require(_to != address(0));
686 
687     clearApproval(_from, _tokenId);
688     removeTokenFrom(_from, _tokenId);
689     addTokenTo(_to, _tokenId);
690 
691     emit Transfer(_from, _to, _tokenId);
692   }
693 
694   /**
695    * @dev Safely transfers the ownership of a given token ID to another address
696    * If the target address is a contract, it must implement `onERC721Received`,
697    * which is called upon a safe transfer, and return the magic value
698    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
699    * the transfer is reverted.
700    *
701    * Requires the msg sender to be the owner, approved, or operator
702    * @param _from current owner of the token
703    * @param _to address to receive the ownership of the given token ID
704    * @param _tokenId uint256 ID of the token to be transferred
705   */
706   function safeTransferFrom(
707     address _from,
708     address _to,
709     uint256 _tokenId
710   )
711     external
712     canTransfer(_tokenId)
713   {
714     // solium-disable-next-line arg-overflow
715     _safeTransferFrom(_from, _to, _tokenId, "");
716   }
717 
718   /**
719    * @dev Safely transfers the ownership of a given token ID to another address
720    * If the target address is a contract, it must implement `onERC721Received`,
721    * which is called upon a safe transfer, and return the magic value
722    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
723    * the transfer is reverted.
724    * Requires the msg sender to be the owner, approved, or operator
725    * @param _from current owner of the token
726    * @param _to address to receive the ownership of the given token ID
727    * @param _tokenId uint256 ID of the token to be transferred
728    * @param _data bytes data to send along with a safe transfer check
729    */
730   function _safeTransferFrom( 
731     address _from,
732     address _to,
733     uint256 _tokenId,
734     bytes _data) internal {
735     _transfer(_from, _to, _tokenId);
736       // solium-disable-next-line arg-overflow
737     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
738   }
739 
740   function safeTransferFrom(
741     address _from,
742     address _to,
743     uint256 _tokenId,
744     bytes _data
745   )
746     external
747     canTransfer(_tokenId)
748   {
749     _safeTransferFrom(_from, _to, _tokenId, _data);
750    
751   }
752 
753   /**
754    * @dev Returns whether the given spender can transfer a given token ID
755    * @param _spender address of the spender to query
756    * @param _tokenId uint256 ID of the token to be transferred
757    * @return bool whether the msg.sender is approved for the given token ID,
758    *  is an operator of the owner, or is the owner of the token
759    */
760   function isApprovedOrOwner (
761     address _spender,
762     uint256 _tokenId
763   )
764     internal
765     view
766     returns (bool)
767   {
768     address _owner = _ownerOf(_tokenId);
769     // Disable solium check because of
770     // https://github.com/duaraghav8/Solium/issues/175
771     // solium-disable-next-line operator-whitespace
772     return (
773       _spender == _owner ||
774       tokenApprovals[_tokenId] == _spender ||
775       operatorApprovals[_owner][_spender]
776     );
777   }
778 
779   /**
780    * @dev Internal function to mint a new token
781    * Reverts if the given token ID already exists
782    * @param _to The address that will own the minted token
783    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
784    */
785   function _mint(address _to, uint256 _tokenId) internal {
786     require(_to != address(0));
787     addTokenTo(_to, _tokenId);
788     emit Transfer(address(0), _to, _tokenId);
789   }
790 
791   /**
792    * @dev Internal function to burn a specific token
793    * Reverts if the token does not exist
794    * @param _tokenId uint256 ID of the token being burned by the msg.sender
795    */
796   function _burn(address _owner, uint256 _tokenId) internal {
797     clearApproval(_owner, _tokenId);
798     removeTokenFrom(_owner, _tokenId);
799     emit Transfer(_owner, address(0), _tokenId);
800   }
801 
802   /**
803    * @dev Internal function to clear current approval of a given token ID
804    * Reverts if the given address is not indeed the owner of the token
805    * @param _owner owner of the token
806    * @param _tokenId uint256 ID of the token to be transferred
807    */
808   function clearApproval(address _owner, uint256 _tokenId) internal whenNotPaused {
809     require(_ownerOf(_tokenId) == _owner);
810     if (tokenApprovals[_tokenId] != address(0)) {
811       tokenApprovals[_tokenId] = address(0);
812     }
813   }
814 
815   /**
816    * @dev Internal function to add a token ID to the list of a given address
817    * @param _to address representing the new owner of the given token ID
818    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
819    */
820   function addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
821     require(tokenOwner[_tokenId] == address(0));
822     require(!frozenAccount[_to]);  
823     tokenOwner[_tokenId] = _to;
824     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
825   }
826 
827   /**
828    * @dev Internal function to remove a token ID from the list of a given address
829    * @param _from address representing the previous owner of the given token ID
830    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
831    */
832   function removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused {
833     require(_ownerOf(_tokenId) == _from);
834     require(!frozenAccount[_from]);  
835     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
836     tokenOwner[_tokenId] = address(0);
837   }
838 
839   /**
840    * @dev Internal function to invoke `onERC721Received` on a target address
841    * The call is not executed if the target address is not a contract
842    * @param _from address representing the previous owner of the given token ID
843    * @param _to target address that will receive the tokens
844    * @param _tokenId uint256 ID of the token to be transferred
845    * @param _data bytes optional data to send along with the call
846    * @return whether the call correctly returned the expected magic value
847    */
848   function checkAndCallSafeTransfer(
849     address _from,
850     address _to,
851     uint256 _tokenId,
852     bytes _data
853   )
854     internal
855     returns (bool)
856   {
857     if (!_to.isContract()) {
858       return true;
859     }
860     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(
861       msg.sender, _from, _tokenId, _data);
862     return (retval == ERC721_RECEIVED);
863   }
864 }
865  
866 contract ERC721ExtendToken is ERC721BasicToken, ERC721Enumerable, ERC721Metadata {
867 
868   using UrlStr for string;
869 
870   bytes4 public constant InterfaceId_ERC721Enumerable = 0x780e9d63;
871   /**
872    * 0x780e9d63 ===
873    *   bytes4(keccak256('totalSupply()')) ^
874    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
875    *   bytes4(keccak256('tokenByIndex(uint256)'))
876    */
877 
878   bytes4 public constant InterfaceId_ERC721Metadata = 0x5b5e139f;
879   /**
880    * 0x5b5e139f ===
881    *   bytes4(keccak256('name()')) ^
882    *   bytes4(keccak256('symbol()')) ^
883    *   bytes4(keccak256('tokenURI(uint256)'))
884    */
885   string internal BASE_URL = "https://www.bitguild.com/bitizens/api/lambo/getCarInfo/00000000";
886 
887   // Mapping from owner to list of owned token IDs
888   mapping(address => uint256[]) internal ownedTokens;
889 
890   // Mapping from token ID to index of the owner tokens list
891   mapping(uint256 => uint256) internal ownedTokensIndex;
892 
893   // Array with all token ids, used for enumeration
894   uint256[] internal allTokens;
895 
896   // Mapping from token id to position in the allTokens array
897   mapping(uint256 => uint256) internal allTokensIndex;
898 
899   function updateBaseURI(string _url) external onlyOwner {
900     BASE_URL = _url;
901   }
902   
903   /**
904    * @dev Constructor function
905    */
906   constructor() public {
907     // register the supported interfaces to conform to ERC721 via ERC165
908     _registerInterface(InterfaceId_ERC721Enumerable);
909     _registerInterface(InterfaceId_ERC721Metadata);
910   }
911 
912   /**
913    * @dev Gets the token name
914    * @return string representing the token name
915    */
916   function name() external view returns (string) {
917     return "Bitizen Lambo";
918   }
919 
920   /**
921    * @dev Gets the token symbol
922    * @return string representing the token symbol
923    */
924   function symbol() external view returns (string) {
925     return "LAMBO";
926   }
927 
928   /**
929    * @dev Returns an URI for a given token ID
930    * Throws if the token ID does not exist. May return an empty string.
931    * @param _tokenId uint256 ID of the token to query
932    */
933   function tokenURI(uint256 _tokenId) external view returns (string) {
934     require(exists(_tokenId));
935     return BASE_URL.generateUrl(_tokenId);
936   }
937 
938   /**
939    * @dev Gets the token ID at a given index of the tokens list of the requested owner
940    * @param _owner address owning the tokens list to be accessed
941    * @param _index uint256 representing the index to be accessed of the requested tokens list
942    * @return uint256 token ID at the given index of the tokens list owned by the requested address
943    */
944   function tokenOfOwnerByIndex(
945     address _owner,
946     uint256 _index
947   )
948     public
949     view
950     returns (uint256)
951   {
952     require(address(0)!=_owner);
953     require(_index < ownedTokensCount[_owner]);
954     return ownedTokens[_owner][_index];
955   }
956 
957   /**
958    * @dev Gets the total amount of tokens stored by the contract
959    * @return uint256 representing the total amount of tokens
960    */
961   function totalSupply() public view returns (uint256) {
962     return allTokens.length;
963   }
964 
965   /**
966    * @dev Gets the token ID at a given index of all the tokens in this contract
967    * Reverts if the index is greater or equal to the total number of tokens
968    * @param _index uint256 representing the index to be accessed of the tokens list
969    * @return uint256 token ID at the given index of the tokens list
970    */
971   function tokenByIndex(uint256 _index) public view returns (uint256) {
972     require(_index < totalSupply());
973     return allTokens[_index];
974   }
975 
976   /**
977    * @dev Internal function to add a token ID to the list of a given address
978    * @param _to address representing the new owner of the given token ID
979    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
980    */
981   function addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
982     super.addTokenTo(_to, _tokenId);
983     uint256 length = ownedTokens[_to].length;
984     ownedTokens[_to].push(_tokenId);
985     ownedTokensIndex[_tokenId] = length;
986   }
987 
988   /**
989    * @dev Internal function to remove a token ID from the list of a given address
990    * @param _from address representing the previous owner of the given token ID
991    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
992    */
993   function removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused {
994     super.removeTokenFrom(_from, _tokenId);
995 
996     uint256 tokenIndex = ownedTokensIndex[_tokenId];
997     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
998     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
999 
1000     ownedTokens[_from][tokenIndex] = lastToken;
1001     ownedTokens[_from][lastTokenIndex] = 0;
1002     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1003     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1004     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1005 
1006     ownedTokens[_from].length--;
1007     ownedTokensIndex[_tokenId] = 0;
1008     ownedTokensIndex[lastToken] = tokenIndex;
1009   }
1010 
1011   /**
1012    * @dev Internal function to mint a new token
1013    * Reverts if the given token ID already exists
1014    * @param _to address the beneficiary that will own the minted token
1015    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1016    */
1017   function _mint(address _to, uint256 _tokenId) internal {
1018     super._mint(_to, _tokenId);
1019 
1020     allTokensIndex[_tokenId] = allTokens.length;
1021     allTokens.push(_tokenId);
1022   }
1023 
1024   /**
1025    * @dev Internal function to burn a specific token
1026    * Reverts if the token does not exist
1027    * @param _owner owner of the token to burn
1028    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1029    */
1030   function _burn(address _owner, uint256 _tokenId) internal {
1031     super._burn(_owner, _tokenId);
1032     
1033 
1034     // Reorg all tokens array
1035     uint256 tokenIndex = allTokensIndex[_tokenId];
1036     uint256 lastTokenIndex = allTokens.length.sub(1);
1037     uint256 lastToken = allTokens[lastTokenIndex];
1038 
1039     allTokens[tokenIndex] = lastToken;
1040     allTokens[lastTokenIndex] = 0;
1041 
1042     allTokens.length--;
1043     allTokensIndex[_tokenId] = 0;
1044     allTokensIndex[lastToken] = tokenIndex;
1045   }
1046 }
1047 
1048 interface BitizenCarService {
1049   function isBurnedCar(uint256 _carId) external view returns (bool);
1050   function getOwnerCars(address _owner) external view returns(uint256[]);
1051   function getBurnedCarIdByIndex(uint256 _index) external view returns (uint256);
1052   function getCarInfo(uint256 _carId) external view returns(string, uint8, uint8);
1053   function createCar(address _owner, string _foundBy, uint8 _type, uint8 _ext) external returns(uint256);
1054   function updateCar(uint256 _carId, string _newFoundBy, uint8 _newType, uint8 _ext) external;
1055   function burnCar(address _owner, uint256 _carId) external;
1056 }
1057 
1058 contract BitizenCarToken is ERC721ExtendToken {
1059   
1060   enum CarHandleType{CREATE_CAR, UPDATE_CAR, BURN_CAR}
1061 
1062   event TransferStateChanged(address indexed _owner, bool _state);
1063   
1064   event CarHandleEvent(address indexed _owner, uint256 indexed _carId, CarHandleType _type);
1065 
1066   struct BitizenCar{
1067     string foundBy; // founder name
1068     uint8 carType;  // car type
1069     uint8 ext;      // for future
1070   }
1071  
1072   // car id index
1073   uint256 internal carIndex = 0;
1074 
1075   // car id => car 
1076   mapping (uint256 => BitizenCar) carInfos;
1077 
1078   // all the burned car id
1079   uint256[] internal burnedCars;
1080 
1081   // check car id => isBurned
1082   mapping(uint256 => bool) internal isBurned;
1083 
1084   // add a switch to handle transfer
1085   bool public carTransferState = false;
1086 
1087   modifier validCar(uint256 _carId) {
1088     require(_carId > 0 && _carId <= carIndex, "invalid car");
1089     _;
1090   }
1091 
1092   function changeTransferState(bool _newState) public onlyOwner {
1093     if(carTransferState == _newState) return;
1094     carTransferState = _newState;
1095     emit TransferStateChanged(owner, carTransferState);
1096   }
1097 
1098   function isBurnedCar(uint256 _carId) external view validCar(_carId) returns (bool) {
1099     return isBurned[_carId];
1100   }
1101 
1102   function getBurnedCarCount() external view returns (uint256) {
1103     return burnedCars.length;
1104   }
1105 
1106   function getBurnedCarIdByIndex(uint256 _index) external view returns (uint256) {
1107     require(_index < burnedCars.length, "out of boundary");
1108     return burnedCars[_index];
1109   }
1110 
1111   function getCarInfo(uint256 _carId) external view validCar(_carId) returns(string, uint8, uint8)  {
1112     BitizenCar storage car = carInfos[_carId];
1113     return(car.foundBy, car.carType, car.ext);
1114   }
1115 
1116   function getOwnerCars(address _owner) external view onlyOperator returns(uint256[]) {
1117     require(_owner != address(0));
1118     return ownedTokens[_owner];
1119   }
1120 
1121   function createCar(address _owner, string _foundBy, uint8 _type, uint8 _ext) external onlyOperator returns(uint256) {
1122     require(_owner != address(0));
1123     BitizenCar memory car = BitizenCar(_foundBy, _type, _ext);
1124     uint256 carId = ++carIndex;
1125     carInfos[carId] = car;
1126     _mint(_owner, carId);
1127     emit CarHandleEvent(_owner, carId, CarHandleType.CREATE_CAR);
1128     return carId;
1129   }
1130 
1131   function updateCar(uint256 _carId, string _newFoundBy, uint8 _type, uint8 _ext) external onlyOperator {
1132     require(exists(_carId));
1133     BitizenCar storage car = carInfos[_carId];
1134     car.foundBy = _newFoundBy;
1135     car.carType = _type;
1136     car.ext = _ext;
1137     emit CarHandleEvent(_ownerOf(_carId), _carId, CarHandleType.UPDATE_CAR);
1138   }
1139 
1140   function burnCar(address _owner, uint256 _carId) external onlyOperator {
1141     burnedCars.push(_carId);
1142     isBurned[_carId] = true;
1143     _burn(_owner, _carId);
1144     emit CarHandleEvent(_owner, _carId, CarHandleType.BURN_CAR);
1145   }
1146 
1147   // override
1148   // add transfer condition
1149   function _transfer(address _from,address _to,uint256 _tokenId) internal {
1150     require(carTransferState == true, "not allown transfer at current time");
1151     super._transfer(_from, _to, _tokenId);
1152   }
1153   
1154   function () public payable {
1155     revert();
1156   }
1157 }