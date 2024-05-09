1 pragma solidity ^0.4.24; 
2 
3 interface ERC165 {
4   /**
5    * @notice Query if a contract implements an interface
6    * @param _interfaceId The interface identifier, as specified in ERC-165
7    * @dev Interface identification is specified in ERC-165. This function
8    * uses less than 30,000 gas.
9    */
10   function supportsInterface(bytes4 _interfaceId) external view returns (bool);
11 }
12 
13 interface ERC721 /* is ERC165 */ {
14     /// @dev This emits when ownership of any NFT changes by any mechanism.
15     ///  This event emits when NFTs are created (`from` == 0) and destroyed
16     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
17     ///  may be created and assigned without emitting Transfer. At the time of
18     ///  any transfer, the approved address for that NFT (if any) is reset to none.
19     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
20 
21     /// @dev This emits when the approved address for an NFT is changed or
22     ///  reaffirmed. The zero address indicates there is no approved address.
23     ///  When a Transfer event emits, this also indicates that the approved
24     ///  address for that NFT (if any) is reset to none.
25     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
26 
27     /// @dev This emits when an operator is enabled or disabled for an owner.
28     ///  The operator can manage all NFTs of the owner.
29     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
30 
31     /// @notice Count all NFTs assigned to an owner
32     /// @dev NFTs assigned to the zero address are considered invalid, and this
33     ///  function throws for queries about the zero address.
34     /// @param _owner An address for whom to query the balance
35     /// @return The number of NFTs owned by `_owner`, possibly zero
36     function balanceOf(address _owner) external view returns (uint256);
37 
38     /// @notice Find the owner of an NFT
39     /// @dev NFTs assigned to zero address are considered invalid, and queries
40     ///  about them do throw.
41     /// @param _tokenId The identifier for an NFT
42     /// @return The address of the owner of the NFT
43     function ownerOf(uint256 _tokenId) external view returns (address);
44 
45     /// @notice Transfers the ownership of an NFT from one address to another address
46     /// @dev Throws unless `msg.sender` is the current owner, an authorized
47     ///  operator, or the approved address for this NFT. Throws if `_from` is
48     ///  not the current owner. Throws if `_to` is the zero address. Throws if
49     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
50     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
51     ///  `onERC721Received` on `_to` and throws if the return value is not
52     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
53     /// @param _from The current owner of the NFT
54     /// @param _to The new owner
55     /// @param _tokenId The NFT to transfer
56     /// @param data Additional data with no specified format, sent in call to `_to`
57     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
58 
59     /// @notice Transfers the ownership of an NFT from one address to another address
60     /// @dev This works identically to the other function with an extra data parameter,
61     ///  except this function just sets data to "".
62     /// @param _from The current owner of the NFT
63     /// @param _to The new owner
64     /// @param _tokenId The NFT to transfer
65     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
66 
67     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
68     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
69     ///  THEY MAY BE PERMANENTLY LOST
70     /// @dev Throws unless `msg.sender` is the current owner, an authorized
71     ///  operator, or the approved address for this NFT. Throws if `_from` is
72     ///  not the current owner. Throws if `_to` is the zero address. Throws if
73     ///  `_tokenId` is not a valid NFT.
74     /// @param _from The current owner of the NFT
75     /// @param _to The new owner
76     /// @param _tokenId The NFT to transfer
77     function transferFrom(address _from, address _to, uint256 _tokenId) external;
78 
79     /// @notice Change or reaffirm the approved address for an NFT
80     /// @dev The zero address indicates there is no approved address.
81     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
82     ///  operator of the current owner.
83     /// @param _approved The new approved NFT controller
84     /// @param _tokenId The NFT to approve
85     function approve(address _approved, uint256 _tokenId) external;
86 
87     /// @notice Enable or disable approval for a third party ("operator") to manage
88     ///  all of `msg.sender`'s assets
89     /// @dev Emits the ApprovalForAll event. The contract MUST allow
90     ///  multiple operators per owner.
91     /// @param _operator Address to add to the set of authorized operators
92     /// @param _approved True if the operator is approved, false to revoke approval
93     function setApprovalForAll(address _operator, bool _approved) external;
94 
95     /// @notice Get the approved address for a single NFT
96     /// @dev Throws if `_tokenId` is not a valid NFT.
97     /// @param _tokenId The NFT to find the approved address for
98     /// @return The approved address for this NFT, or the zero address if there is none
99     function getApproved(uint256 _tokenId) external view returns (address);
100 
101     /// @notice Query if an address is an authorized operator for another address
102     /// @param _owner The address that owns the NFTs
103     /// @param _operator The address that acts on behalf of the owner
104     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
105     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
106 }
107 
108 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
109 interface ERC721Enumerable /* is ERC721 */ {
110     /// @notice Count NFTs tracked by this contract
111     /// @return A count of valid NFTs tracked by this contract, where each one of
112     ///  them has an assigned and queryable owner not equal to the zero address
113     function totalSupply() external view returns (uint256);
114 
115     /// @notice Enumerate valid NFTs
116     /// @dev Throws if `_index` >= `totalSupply()`.
117     /// @param _index A counter less than `totalSupply()`
118     /// @return The token identifier for the `_index`th NFT,
119     ///  (sort order not specified)
120     function tokenByIndex(uint256 _index) external view returns (uint256);
121 
122     /// @notice Enumerate NFTs assigned to an owner
123     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
124     ///  `_owner` is the zero address, representing invalid NFTs.
125     /// @param _owner An address where we are interested in NFTs owned by them
126     /// @param _index A counter less than `balanceOf(_owner)`
127     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
128     ///   (sort order not specified)
129     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
130 }
131 
132 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
133 interface ERC721Metadata /* is ERC721 */ {
134   /// @notice A descriptive name for a collection of NFTs in this contract
135   function name() external view returns (string _name);
136 
137   /// @notice An abbreviated name for NFTs in this contract
138   function symbol() external view returns (string _symbol);
139 
140   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
141   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
142   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
143   ///  Metadata JSON Schema".
144   function tokenURI(uint256 _tokenId) external view returns (string);
145 }
146 
147 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
148 interface ERC721TokenReceiver {
149     /// @notice Handle the receipt of an NFT
150     /// @dev The ERC721 smart contract calls this function on the recipient
151     ///  after a `transfer`. This function MAY throw to revert and reject the
152     ///  transfer. Return of other than the magic value MUST result in the
153     ///  transaction being reverted.
154     ///  Note: the contract address is always the message sender.
155     /// @param _operator The address which called `safeTransferFrom` function
156     /// @param _from The address which previously owned the token
157     /// @param _tokenId The NFT identifier which is being transferred
158     /// @param _data Additional data with no specified format
159     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
160     ///  unless throwing
161     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
162 }
163 
164 /**
165  * @title SupportsInterfaceWithLookup
166  * @author Matt Condon (@shrugs)
167  * @dev Implements ERC165 using a lookup table.
168  */
169 contract SupportsInterfaceWithLookup is ERC165 {
170   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
171   /**
172    * 0x01ffc9a7 ===
173    *   bytes4(keccak256('supportsInterface(bytes4)'))
174    */
175 
176   /**
177    * @dev a mapping of interface id to whether or not it's supported
178    */
179   mapping(bytes4 => bool) internal supportedInterfaces;
180 
181   /**
182    * @dev A contract implementing SupportsInterfaceWithLookup
183    * implement ERC165 itself
184    */
185   constructor()
186     public
187   {
188     _registerInterface(InterfaceId_ERC165);
189   }
190 
191   /**
192    * @dev implement supportsInterface(bytes4) using a lookup table
193    */
194   function supportsInterface(bytes4 _interfaceId)
195     external
196     view
197     returns (bool)
198   {
199     return supportedInterfaces[_interfaceId];
200   }
201 
202   /**
203    * @dev private method for registering an interface
204    */
205   function _registerInterface(bytes4 _interfaceId)
206     internal
207   {
208     require(_interfaceId != 0xffffffff);
209     supportedInterfaces[_interfaceId] = true;
210   }
211 }
212 
213 /**
214  * Utility library of inline functions on addresses
215  */
216 library AddressUtils {
217 
218   /**
219    * Returns whether the target address is a contract
220    * @dev This function will return false if invoked during the constructor of a contract,
221    * as the code is not actually created until after the constructor finishes.
222    * @param addr address to check
223    * @return whether the target address is a contract
224    */
225   function isContract(address addr) internal view returns (bool) {
226     uint256 size;
227     // XXX Currently there is no better way to check if there is a contract in an address
228     // than to check the size of the code at that address.
229     // See https://ethereum.stackexchange.com/a/14016/36603
230     // for more details about how this works.
231     // TODO Check this again before the Serenity release, because all addresses will be
232     // contracts then.
233     // solium-disable-next-line security/no-inline-assembly
234     assembly { size := extcodesize(addr) }
235     return size > 0;
236   }
237 
238 }
239  
240 library UrlStr {
241   
242   // generate url by tokenId
243   // baseUrl must end with 00000000
244   function generateUrl(string url,uint256 _tokenId) internal pure returns (string _url){
245     _url = url;
246     bytes memory _tokenURIBytes = bytes(_url);
247     uint256 base_len = _tokenURIBytes.length - 1;
248     _tokenURIBytes[base_len - 7] = byte(48 + _tokenId / 10000000 % 10);
249     _tokenURIBytes[base_len - 6] = byte(48 + _tokenId / 1000000 % 10);
250     _tokenURIBytes[base_len - 5] = byte(48 + _tokenId / 100000 % 10);
251     _tokenURIBytes[base_len - 4] = byte(48 + _tokenId / 10000 % 10);
252     _tokenURIBytes[base_len - 3] = byte(48 + _tokenId / 1000 % 10);
253     _tokenURIBytes[base_len - 2] = byte(48 + _tokenId / 100 % 10);
254     _tokenURIBytes[base_len - 1] = byte(48 + _tokenId / 10 % 10);
255     _tokenURIBytes[base_len - 0] = byte(48 + _tokenId / 1 % 10);
256   }
257 }
258 
259 /**
260  * @title SafeMath
261  * @dev Math operations with safety checks that throw on error
262  */
263 library SafeMath {
264 
265   /**
266   * @dev Multiplies two numbers, throws on overflow.
267   */
268   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269     if (a == 0) {
270       return 0;
271     }
272     uint256 c = a * b;
273     assert(c / a == b);
274     return c;
275   }
276 
277   /**
278   * @dev Integer division of two numbers, truncating the quotient.
279   */
280   function div(uint256 a, uint256 b) internal pure returns (uint256) {
281     // assert(b > 0); // Solidity automatically throws when dividing by 0
282     uint256 c = a / b;
283     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284     return c;
285   }
286 
287   /**
288   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
289   */
290   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291     assert(b <= a);
292     return a - b;
293   }
294 
295   /**
296   * @dev Adds two numbers, throws on overflow.
297   */
298   function add(uint256 a, uint256 b) internal pure returns (uint256) {
299     uint256 c = a + b;
300     assert(c >= a);
301     return c;
302   }
303 }
304  
305 /**
306  * @title Ownable
307  * @dev The Ownable contract has an owner address, and provides basic authorization control
308  * functions, this simplifies the implementation of "user permissions".
309  */
310 contract Ownable {
311   address public owner;
312   event OwnershipRenounced(address indexed previousOwner);
313   event OwnershipTransferred(
314     address indexed previousOwner,
315     address indexed newOwner
316   );
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
363 
364 /**
365  * @title Operator
366  * @dev Allow two roles: 'owner' or 'operator'
367  *      - owner: admin/superuser (e.g. with financial rights)
368  *      - operator: can update configurations
369  */
370 contract Operator is Ownable {
371 
372     address[] public operators;
373 
374     uint public MAX_OPS = 20; // Default maximum number of operators allowed
375 
376     mapping(address => bool) public isOperator;
377 
378     event OperatorAdded(address operator);
379     event OperatorRemoved(address operator);
380 
381     // @dev Throws if called by any non-operator account. Owner has all ops rights.
382     modifier onlyOperator() {
383         require(
384             isOperator[msg.sender] || msg.sender == owner,
385             "Permission denied. Must be an operator or the owner."
386         );
387         _;
388     }
389 
390     /**
391      * @dev Allows the current owner or operators to add operators
392      * @param _newOperator New operator address
393      */
394     function addOperator(address _newOperator) public onlyOwner {
395         require(
396             _newOperator != address(0),
397             "Invalid new operator address."
398         );
399 
400         // Make sure no dups
401         require(
402             !isOperator[_newOperator],
403             "New operator exists."
404         );
405 
406         // Only allow so many ops
407         require(
408             operators.length < MAX_OPS,
409             "Overflow."
410         );
411 
412         operators.push(_newOperator);
413         isOperator[_newOperator] = true;
414 
415         emit OperatorAdded(_newOperator);
416     }
417 
418     /**
419      * @dev Allows the current owner or operators to remove operator
420      * @param _operator Address of the operator to be removed
421      */
422     function removeOperator(address _operator) public onlyOwner {
423         // Make sure operators array is not empty
424         require(
425             operators.length > 0,
426             "No operator."
427         );
428 
429         // Make sure the operator exists
430         require(
431             isOperator[_operator],
432             "Not an operator."
433         );
434 
435         // Manual array manipulation:
436         // - replace the _operator with last operator in array
437         // - remove the last item from array
438         address lastOperator = operators[operators.length - 1];
439         for (uint i = 0; i < operators.length; i++) {
440             if (operators[i] == _operator) {
441                 operators[i] = lastOperator;
442             }
443         }
444         operators.length -= 1; // remove the last element
445 
446         isOperator[_operator] = false;
447         emit OperatorRemoved(_operator);
448     }
449 
450     // @dev Remove ALL operators
451     function removeAllOps() public onlyOwner {
452         for (uint i = 0; i < operators.length; i++) {
453             isOperator[operators[i]] = false;
454         }
455         operators.length = 0;
456     }
457 }
458  
459 contract Pausable is Operator {
460 
461   event FrozenFunds(address target, bool frozen);
462 
463   bool public isPaused = false;
464   
465   mapping(address => bool)  frozenAccount;
466 
467   modifier whenNotPaused {
468     require(!isPaused);
469     _;
470   }
471 
472   modifier whenPaused {
473     require(isPaused);
474     _;  
475   }
476 
477   modifier whenNotFreeze(address _target) {
478     require(_target != address(0));
479     require(!frozenAccount[_target]);
480     _;
481   }
482 
483   function isFrozen(address _target) external view returns (bool) {
484     require(_target != address(0));
485     return frozenAccount[_target];
486   }
487 
488   function doPause() external  whenNotPaused onlyOwner {
489     isPaused = true;
490   }
491 
492   function doUnpause() external  whenPaused onlyOwner {
493     isPaused = false;
494   }
495 
496   function freezeAccount(address _target, bool _freeze) public onlyOwner {
497     require(_target != address(0));
498     frozenAccount[_target] = _freeze;
499     emit FrozenFunds(_target, _freeze);
500   }
501 
502 }
503 
504 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721, Pausable{
505 
506   bytes4 public constant InterfaceId_ERC721 = 0x80ac58cd;
507   /*
508    * 0x80ac58cd ===
509    *   bytes4(keccak256('balanceOf(address)')) ^
510    *   bytes4(keccak256('ownerOf(uint256)')) ^
511    *   bytes4(keccak256('approve(address,uint256)')) ^
512    *   bytes4(keccak256('getApproved(uint256)')) ^
513    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
514    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
515    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
516    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
517    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
518    */
519 
520   bytes4 public constant InterfaceId_ERC721Exists = 0x4f558e79;
521   /*
522    * 0x4f558e79 ===
523    *   bytes4(keccak256('exists(uint256)'))
524    */
525 
526   using SafeMath for uint256;
527   using AddressUtils for address;
528 
529   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
530   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
531   bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
532 
533   // Mapping from token ID to owner
534   mapping (uint256 => address) internal tokenOwner;
535 
536   // Mapping from token ID to approved address
537   mapping (uint256 => address) internal tokenApprovals;
538 
539   // Mapping from owner to number of owned token
540   mapping (address => uint256) internal ownedTokensCount;
541 
542   // Mapping from owner to operator approvals
543   mapping (address => mapping (address => bool)) internal operatorApprovals;
544 
545   /**
546    * @dev Guarantees msg.sender is owner of the given token
547    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
548    */
549   modifier onlyOwnerOf(uint256 _tokenId) {
550     require(_ownerOf(_tokenId) == msg.sender,"This token not owned by this address");
551     _;
552   }
553   
554   function _ownerOf(uint256 _tokenId) internal view returns(address) {
555     address _owner = tokenOwner[_tokenId];
556     require(_owner != address(0),"Token not exist");
557     return _owner;
558   }
559 
560   /**
561    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
562    * @param _tokenId uint256 ID of the token to validate
563    */
564   modifier canTransfer(uint256 _tokenId) {
565     require(isApprovedOrOwner(msg.sender, _tokenId), "This address have no permisstion");
566     _;
567   }
568 
569   constructor()
570     public
571   {
572     // register the supported interfaces to conform to ERC721 via ERC165
573     _registerInterface(InterfaceId_ERC721);
574     _registerInterface(InterfaceId_ERC721Exists);
575     _registerInterface(ERC721_RECEIVED);
576   }
577 
578   /**
579    * @dev Gets the balance of the specified address
580    * @param _owner address to query the balance of
581    * @return uint256 representing the amount owned by the passed address
582    */
583   function balanceOf(address _owner) external view returns (uint256) {
584     require(_owner != address(0));
585     return ownedTokensCount[_owner];
586   }
587 
588   /**
589    * @dev Gets the owner of the specified token ID
590    * @param _tokenId uint256 ID of the token to query the owner of
591    * @return owner address currently marked as the owner of the given token ID
592    */
593   function ownerOf(uint256 _tokenId) external view returns (address) {
594     return _ownerOf(_tokenId);
595   }
596 
597   /**
598    * @dev Returns whether the specified token exists
599    * @param _tokenId uint256 ID of the token to query the existence of
600    * @return whether the token exists
601    */
602   function exists(uint256 _tokenId) internal view returns (bool) {
603     address owner = tokenOwner[_tokenId];
604     return owner != address(0);
605   }
606 
607   /**
608    * @dev Approves another address to transfer the given token ID
609    * The zero address indicates there is no approved address.
610    * There can only be one approved address per token at a given time.
611    * Can only be called by the token owner or an approved operator.
612    * @param _to address to be approved for the given token ID
613    * @param _tokenId uint256 ID of the token to be approved
614    */
615   function approve(address _to, uint256 _tokenId) external whenNotPaused {
616     address _owner = _ownerOf(_tokenId);
617     require(_to != _owner);
618     require(msg.sender == _owner || operatorApprovals[_owner][msg.sender]);
619 
620     tokenApprovals[_tokenId] = _to;
621     emit Approval(_owner, _to, _tokenId);
622   }
623 
624   /**
625    * @dev Gets the approved address for a token ID, or zero if no address set
626    * @param _tokenId uint256 ID of the token to query the approval of
627    * @return address currently approved for the given token ID
628    */
629   function getApproved(uint256 _tokenId) external view returns (address) {
630     return tokenApprovals[_tokenId];
631   }
632 
633   /**
634    * @dev Sets or unsets the approval of a given operator
635    * An operator is allowed to transfer all tokens of the sender on their behalf
636    * @param _to operator address to set the approval
637    * @param _approved representing the status of the approval to be set
638    */
639   function setApprovalForAll(address _to, bool _approved) external whenNotPaused {
640     require(_to != msg.sender);
641     operatorApprovals[msg.sender][_to] = _approved;
642     emit ApprovalForAll(msg.sender, _to, _approved);
643   }
644 
645   /**
646    * @dev Tells whether an operator is approved by a given owner
647    * @param _owner owner address which you want to query the approval of
648    * @param _operator operator address which you want to query the approval of
649    * @return bool whether the given operator is approved by the given owner
650    */
651   function isApprovedForAll(
652     address _owner,
653     address _operator
654   )
655     external
656     view
657     returns (bool)
658   {
659     return operatorApprovals[_owner][_operator];
660   }
661 
662   /**
663    * @dev Transfers the ownership of a given token ID to another address
664    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
665    * Requires the msg sender to be the owner, approved, or operator
666    * @param _from current owner of the token
667    * @param _to address to receive the ownership of the given token ID
668    * @param _tokenId uint256 ID of the token to be transferred
669   */
670   function transferFrom(
671     address _from,
672     address _to,
673     uint256 _tokenId
674   )
675     external
676     canTransfer(_tokenId)
677   {
678     _transfer(_from,_to,_tokenId);
679   }
680 
681 
682   function _transfer(
683     address _from,
684     address _to,
685     uint256 _tokenId) internal {
686     require(_from != address(0));
687     require(_to != address(0));
688 
689     clearApproval(_from, _tokenId);
690     removeTokenFrom(_from, _tokenId);
691     addTokenTo(_to, _tokenId);
692 
693     emit Transfer(_from, _to, _tokenId);
694   }
695 
696   /**
697    * @dev Safely transfers the ownership of a given token ID to another address
698    * If the target address is a contract, it must implement `onERC721Received`,
699    * which is called upon a safe transfer, and return the magic value
700    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
701    * the transfer is reverted.
702    *
703    * Requires the msg sender to be the owner, approved, or operator
704    * @param _from current owner of the token
705    * @param _to address to receive the ownership of the given token ID
706    * @param _tokenId uint256 ID of the token to be transferred
707   */
708   function safeTransferFrom(
709     address _from,
710     address _to,
711     uint256 _tokenId
712   )
713     external
714     canTransfer(_tokenId)
715   {
716     // solium-disable-next-line arg-overflow
717     _safeTransferFrom(_from, _to, _tokenId, "");
718   }
719 
720   /**
721    * @dev Safely transfers the ownership of a given token ID to another address
722    * If the target address is a contract, it must implement `onERC721Received`,
723    * which is called upon a safe transfer, and return the magic value
724    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
725    * the transfer is reverted.
726    * Requires the msg sender to be the owner, approved, or operator
727    * @param _from current owner of the token
728    * @param _to address to receive the ownership of the given token ID
729    * @param _tokenId uint256 ID of the token to be transferred
730    * @param _data bytes data to send along with a safe transfer check
731    */
732   function _safeTransferFrom( 
733     address _from,
734     address _to,
735     uint256 _tokenId,
736     bytes _data) internal {
737     _transfer(_from, _to, _tokenId);
738       // solium-disable-next-line arg-overflow
739     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
740   }
741 
742   function safeTransferFrom(
743     address _from,
744     address _to,
745     uint256 _tokenId,
746     bytes _data
747   )
748     external
749     canTransfer(_tokenId)
750   {
751     _safeTransferFrom(_from, _to, _tokenId, _data);
752    
753   }
754 
755   /**
756    * @dev Returns whether the given spender can transfer a given token ID
757    * @param _spender address of the spender to query
758    * @param _tokenId uint256 ID of the token to be transferred
759    * @return bool whether the msg.sender is approved for the given token ID,
760    *  is an operator of the owner, or is the owner of the token
761    */
762   function isApprovedOrOwner (
763     address _spender,
764     uint256 _tokenId
765   )
766     internal
767     view
768     returns (bool)
769   {
770     address _owner = _ownerOf(_tokenId);
771     // Disable solium check because of
772     // https://github.com/duaraghav8/Solium/issues/175
773     // solium-disable-next-line operator-whitespace
774     return (
775       _spender == _owner ||
776       tokenApprovals[_tokenId] == _spender ||
777       operatorApprovals[_owner][_spender]
778     );
779   }
780 
781   /**
782    * @dev Internal function to mint a new token
783    * Reverts if the given token ID already exists
784    * @param _to The address that will own the minted token
785    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
786    */
787   function _mint(address _to, uint256 _tokenId) internal {
788     require(_to != address(0));
789     addTokenTo(_to, _tokenId);
790     emit Transfer(address(0), _to, _tokenId);
791   }
792 
793   /**
794    * @dev Internal function to burn a specific token
795    * Reverts if the token does not exist
796    * @param _tokenId uint256 ID of the token being burned by the msg.sender
797    */
798   function _burn(address _owner, uint256 _tokenId) internal {
799     clearApproval(_owner, _tokenId);
800     removeTokenFrom(_owner, _tokenId);
801     emit Transfer(_owner, address(0), _tokenId);
802   }
803 
804   /**
805    * @dev Internal function to clear current approval of a given token ID
806    * Reverts if the given address is not indeed the owner of the token
807    * @param _owner owner of the token
808    * @param _tokenId uint256 ID of the token to be transferred
809    */
810   function clearApproval(address _owner, uint256 _tokenId) internal whenNotPaused {
811     require(_ownerOf(_tokenId) == _owner);
812     if (tokenApprovals[_tokenId] != address(0)) {
813       tokenApprovals[_tokenId] = address(0);
814     }
815   }
816 
817   /**
818    * @dev Internal function to add a token ID to the list of a given address
819    * @param _to address representing the new owner of the given token ID
820    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
821    */
822   function addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
823     require(tokenOwner[_tokenId] == address(0));
824     require(!frozenAccount[_to]);  
825     tokenOwner[_tokenId] = _to;
826     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
827   }
828 
829   /**
830    * @dev Internal function to remove a token ID from the list of a given address
831    * @param _from address representing the previous owner of the given token ID
832    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
833    */
834   function removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused {
835     require(_ownerOf(_tokenId) == _from);
836     require(!frozenAccount[_from]);  
837     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
838     tokenOwner[_tokenId] = address(0);
839   }
840 
841   /**
842    * @dev Internal function to invoke `onERC721Received` on a target address
843    * The call is not executed if the target address is not a contract
844    * @param _from address representing the previous owner of the given token ID
845    * @param _to target address that will receive the tokens
846    * @param _tokenId uint256 ID of the token to be transferred
847    * @param _data bytes optional data to send along with the call
848    * @return whether the call correctly returned the expected magic value
849    */
850   function checkAndCallSafeTransfer(
851     address _from,
852     address _to,
853     uint256 _tokenId,
854     bytes _data
855   )
856     internal
857     returns (bool)
858   {
859     if (!_to.isContract()) {
860       return true;
861     }
862     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(
863       msg.sender, _from, _tokenId, _data);
864     return (retval == ERC721_RECEIVED);
865   }
866 }
867  
868 contract ERC721ExtendToken is ERC721BasicToken, ERC721Enumerable, ERC721Metadata {
869 
870   using UrlStr for string;
871 
872   bytes4 public constant InterfaceId_ERC721Enumerable = 0x780e9d63;
873   /**
874    * 0x780e9d63 ===
875    *   bytes4(keccak256('totalSupply()')) ^
876    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
877    *   bytes4(keccak256('tokenByIndex(uint256)'))
878    */
879 
880   bytes4 public constant InterfaceId_ERC721Metadata = 0x5b5e139f;
881   /**
882    * 0x5b5e139f ===
883    *   bytes4(keccak256('name()')) ^
884    *   bytes4(keccak256('symbol()')) ^
885    *   bytes4(keccak256('tokenURI(uint256)'))
886    */
887   string internal BASE_URL = "https://www.bitguild.com/bitizens/api/item/getItemInfo/00000000";
888 
889   // Mapping from owner to list of owned token IDs
890   mapping(address => uint256[]) internal ownedTokens;
891 
892   // Mapping from token ID to index of the owner tokens list
893   mapping(uint256 => uint256) internal ownedTokensIndex;
894 
895   // Array with all token ids, used for enumeration
896   uint256[] internal allTokens;
897 
898   // Mapping from token id to position in the allTokens array
899   mapping(uint256 => uint256) internal allTokensIndex;
900 
901   function updateBaseURI(string _url) external onlyOwner {
902     BASE_URL = _url;
903   }
904   
905   /**
906    * @dev Constructor function
907    */
908   constructor() public {
909     // register the supported interfaces to conform to ERC721 via ERC165
910     _registerInterface(InterfaceId_ERC721Enumerable);
911     _registerInterface(InterfaceId_ERC721Metadata);
912   }
913 
914   /**
915    * @dev Gets the token name
916    * @return string representing the token name
917    */
918   function name() external view returns (string) {
919     return "Bitizen item";
920   }
921 
922   /**
923    * @dev Gets the token symbol
924    * @return string representing the token symbol
925    */
926   function symbol() external view returns (string) {
927     return "ITMT";
928   }
929 
930   /**
931    * @dev Returns an URI for a given token ID
932    * Throws if the token ID does not exist. May return an empty string.
933    * @param _tokenId uint256 ID of the token to query
934    */
935   function tokenURI(uint256 _tokenId) external view returns (string) {
936     require(exists(_tokenId));
937     return BASE_URL.generateUrl(_tokenId);
938   }
939 
940   /**
941    * @dev Gets the token ID at a given index of the tokens list of the requested owner
942    * @param _owner address owning the tokens list to be accessed
943    * @param _index uint256 representing the index to be accessed of the requested tokens list
944    * @return uint256 token ID at the given index of the tokens list owned by the requested address
945    */
946   function tokenOfOwnerByIndex(
947     address _owner,
948     uint256 _index
949   )
950     public
951     view
952     returns (uint256)
953   {
954     require(address(0)!=_owner);
955     require(_index < ownedTokensCount[_owner]);
956     return ownedTokens[_owner][_index];
957   }
958 
959   /**
960    * @dev Gets the total amount of tokens stored by the contract
961    * @return uint256 representing the total amount of tokens
962    */
963   function totalSupply() public view returns (uint256) {
964     return allTokens.length;
965   }
966 
967   /**
968    * @dev Gets the token ID at a given index of all the tokens in this contract
969    * Reverts if the index is greater or equal to the total number of tokens
970    * @param _index uint256 representing the index to be accessed of the tokens list
971    * @return uint256 token ID at the given index of the tokens list
972    */
973   function tokenByIndex(uint256 _index) public view returns (uint256) {
974     require(_index < totalSupply());
975     return allTokens[_index];
976   }
977 
978   /**
979    * @dev Internal function to add a token ID to the list of a given address
980    * @param _to address representing the new owner of the given token ID
981    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
982    */
983   function addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
984     super.addTokenTo(_to, _tokenId);
985     uint256 length = ownedTokens[_to].length;
986     ownedTokens[_to].push(_tokenId);
987     ownedTokensIndex[_tokenId] = length;
988   }
989 
990   /**
991    * @dev Internal function to remove a token ID from the list of a given address
992    * @param _from address representing the previous owner of the given token ID
993    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
994    */
995   function removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused {
996     super.removeTokenFrom(_from, _tokenId);
997 
998     uint256 tokenIndex = ownedTokensIndex[_tokenId];
999     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1000     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1001 
1002     ownedTokens[_from][tokenIndex] = lastToken;
1003     ownedTokens[_from][lastTokenIndex] = 0;
1004     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1005     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1006     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1007 
1008     ownedTokens[_from].length--;
1009     ownedTokensIndex[_tokenId] = 0;
1010     ownedTokensIndex[lastToken] = tokenIndex;
1011   }
1012 
1013   /**
1014    * @dev Internal function to mint a new token
1015    * Reverts if the given token ID already exists
1016    * @param _to address the beneficiary that will own the minted token
1017    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1018    */
1019   function _mint(address _to, uint256 _tokenId) internal {
1020     super._mint(_to, _tokenId);
1021 
1022     allTokensIndex[_tokenId] = allTokens.length;
1023     allTokens.push(_tokenId);
1024   }
1025 
1026   /**
1027    * @dev Internal function to burn a specific token
1028    * Reverts if the token does not exist
1029    * @param _owner owner of the token to burn
1030    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1031    */
1032   function _burn(address _owner, uint256 _tokenId) internal {
1033     super._burn(_owner, _tokenId);
1034     
1035 
1036     // Reorg all tokens array
1037     uint256 tokenIndex = allTokensIndex[_tokenId];
1038     uint256 lastTokenIndex = allTokens.length.sub(1);
1039     uint256 lastToken = allTokens[lastTokenIndex];
1040 
1041     allTokens[tokenIndex] = lastToken;
1042     allTokens[lastTokenIndex] = 0;
1043 
1044     allTokens.length--;
1045     allTokensIndex[_tokenId] = 0;
1046     allTokensIndex[lastToken] = tokenIndex;
1047   }
1048 }
1049 
1050 /**
1051   if a ERC721 item want to mount to avatar, it must to inherit this.
1052  */
1053 interface AvatarChildService {
1054   /**
1055       @dev if you want your contract become a avatar child, please let your contract inherit this interface
1056       @param _tokenId1  first child token id
1057       @param _tokenId2  second child token id
1058       @return  true will unmount first token before mount ,false will directly mount child
1059    */
1060    function compareItemSlots(uint256 _tokenId1, uint256 _tokenId2) external view returns (bool _res);
1061 
1062   /**
1063    @dev if you want your contract become a avatar child, please let your contract inherit this interface
1064    @return return true will be to avatar child
1065    */
1066    function isAvatarChild(uint256 _tokenId) external view returns(bool);
1067 }
1068 
1069 interface AvatarItemService {
1070 
1071   function getTransferTimes(uint256 _tokenId) external view returns(uint256);
1072   function getOwnedItems(address _owner) external view returns(uint256[] _tokenIds);
1073   
1074   function getItemInfo(uint256 _tokenId)
1075     external 
1076     view 
1077     returns(string, string, bool, uint256[4] _attr1, uint8[5] _attr2, uint16[2] _attr3);
1078 
1079   function isBurned(uint256 _tokenId) external view returns (bool); 
1080   function isSameItem(uint256 _tokenId1, uint256 _tokenId2) external view returns (bool _isSame);
1081   function getBurnedItemCount() external view returns (uint256);
1082   function getBurnedItemByIndex(uint256 _index) external view returns (uint256);
1083   function getSameItemCount(uint256 _tokenId) external view returns(uint256);
1084   function getSameItemIdByIndex(uint256 _tokenId, uint256 _index) external view returns(uint256);
1085   function getItemHash(uint256 _tokenId) external view returns (bytes8); 
1086 
1087   function burnItem(address _owner, uint256 _tokenId) external;
1088   /**
1089     @param _owner         owner of the token
1090     @param _founder       founder type of the token 
1091     @param _creator       creator type of the token
1092     @param _isBitizenItem true is for bitizen or false
1093     @param _attr1         _atrr1[0] => node   _atrr1[1] => listNumber _atrr1[2] => setNumber  _atrr1[3] => quality
1094     @param _attr2         _atrr2[0] => rarity _atrr2[1] => socket     _atrr2[2] => gender     _atrr2[3] => energy  _atrr2[4] => ext 
1095     @param _attr3         _atrr3[0] => miningTime  _atrr3[1] => magicFind     
1096     @return               token id
1097    */
1098   function createItem( 
1099     address _owner,
1100     string _founder,
1101     string _creator, 
1102     bool _isBitizenItem, 
1103     uint256[4] _attr1,
1104     uint8[5] _attr2,
1105     uint16[2] _attr3)
1106     external  
1107     returns(uint256 _tokenId);
1108 
1109   function updateItem(
1110     uint256 _tokenId,
1111     bool  _isBitizenItem,
1112     uint16 _miningTime,
1113     uint16 _magicFind,
1114     uint256 _node,
1115     uint256 _listNumber,
1116     uint256 _setNumber,
1117     uint256 _quality,
1118     uint8 _rarity,
1119     uint8 _socket,
1120     uint8 _gender,
1121     uint8 _energy,
1122     uint8 _ext
1123   ) 
1124   external;
1125 }
1126 
1127 contract AvatarItemToken is ERC721ExtendToken, AvatarItemService, AvatarChildService {
1128 
1129   enum ItemHandleType{NULL, CREATE_ITEM, UPDATE_ITEM, BURN_ITEM}
1130   
1131   event ItemHandleEvent(address indexed _owner, uint256 indexed _itemId,ItemHandleType _type);
1132 
1133   struct AvatarItem {
1134     string foundedBy;     // item founder
1135     string createdBy;     // item creator
1136     bool isBitizenItem;   // true for bitizen false for other
1137     uint16 miningTime;    // decrease the mine time, range to 0 ~ 10000/0.00% ~ 100.00%
1138     uint16 magicFind;     // increase get rare item, range to 0 ~ 10000/0.00% ~ 100.00%
1139     uint256 node;         // node token id 
1140     uint256 listNumber;   // list number
1141     uint256 setNumber;    // set number
1142     uint256 quality;      // quality of item 
1143     uint8 rarity;         // 01 => Common 02 => Uncommon  03 => Rare  04 => Epic 05 => Legendary 06 => Godlike 10 => Limited
1144     uint8 socket;         // 01 => Head   02 => Top  03 => Bottom  04 => Feet  05 => Trinket  06 => Acc  07 => Props 
1145     uint8 gender;         // 00 => Male   01 => Female 10 => Male-only 11 => Female-only  Unisex => 99
1146     uint8 energy;         // increases extra mining times
1147     uint8 ext;            // extra attribute for future
1148   }
1149   
1150   // item id index
1151   uint256 internal itemIndex = 0;
1152   // tokenId => item
1153   mapping(uint256 => AvatarItem) internal avatarItems;
1154   // all the burned token ids
1155   uint256[] internal burnedItemIds;
1156   // check token id => isBurned
1157   mapping(uint256 => bool) internal isBurnedItem;
1158   // hash(item) => tokenIds
1159   mapping(bytes8 => uint256[]) internal sameItemIds;
1160   // token id => index in the same item token ids array
1161   mapping(uint256 => uint256) internal sameItemIdIndex;
1162   // token id => hash(item)
1163   mapping(uint256 => bytes8) internal itemIdToHash;
1164   // item token id => transfer count
1165   mapping(uint256 => uint256) internal itemTransferCount;
1166 
1167   // avatar address, add default permission to handle item
1168   address internal avatarAccount = this;
1169 
1170   // contain burned token and exist token 
1171   modifier validItem(uint256 _itemId) {
1172     require(_itemId > 0 && _itemId <= itemIndex, "token not vaild");
1173     _;
1174   }
1175 
1176   modifier itemExists(uint256 _itemId){
1177     require(exists(_itemId), "token error");
1178     _;
1179   }
1180 
1181   function setDefaultApprovalAccount(address _account) public onlyOwner {
1182     avatarAccount = _account;
1183   }
1184 
1185   function compareItemSlots(uint256 _itemId1, uint256 _itemId2)
1186     external
1187     view
1188     itemExists(_itemId1)
1189     itemExists(_itemId2)
1190     returns (bool) {
1191     require(_itemId1 != _itemId2, "compared token shouldn't be the same");
1192     return avatarItems[_itemId1].socket == avatarItems[_itemId2].socket;
1193   }
1194 
1195   function isAvatarChild(uint256 _itemId) external view returns(bool){
1196     return true;
1197   }
1198 
1199   function getTransferTimes(uint256 _itemId) external view validItem(_itemId) returns(uint256) {
1200     return itemTransferCount[_itemId];
1201   }
1202 
1203   function getOwnedItems(address _owner) external view onlyOperator returns(uint256[] _items) {
1204     require(_owner != address(0), "address invalid");
1205     return ownedTokens[_owner];
1206   }
1207 
1208   function getItemInfo(uint256 _itemId)
1209     external 
1210     view 
1211     validItem(_itemId)
1212     returns(string, string, bool, uint256[4] _attr1, uint8[5] _attr2, uint16[2] _attr3) {
1213     AvatarItem storage item = avatarItems[_itemId];
1214     _attr1[0] = item.node;
1215     _attr1[1] = item.listNumber;
1216     _attr1[2] = item.setNumber;
1217     _attr1[3] = item.quality;  
1218     _attr2[0] = item.rarity;
1219     _attr2[1] = item.socket;
1220     _attr2[2] = item.gender;
1221     _attr2[3] = item.energy;
1222     _attr2[4] = item.ext;
1223     _attr3[0] = item.miningTime;
1224     _attr3[1] = item.magicFind;
1225     return (item.foundedBy, item.createdBy, item.isBitizenItem, _attr1, _attr2, _attr3);
1226   }
1227 
1228   function isBurned(uint256 _itemId) external view validItem(_itemId) returns (bool) {
1229     return isBurnedItem[_itemId];
1230   }
1231 
1232   function getBurnedItemCount() external view returns (uint256) {
1233     return burnedItemIds.length;
1234   }
1235 
1236   function getBurnedItemByIndex(uint256 _index) external view returns (uint256) {
1237     require(_index < burnedItemIds.length, "out of boundary");
1238     return burnedItemIds[_index];
1239   }
1240 
1241   function getSameItemCount(uint256 _itemId) external view validItem(_itemId) returns(uint256) {
1242     return sameItemIds[itemIdToHash[_itemId]].length;
1243   }
1244   
1245   function getSameItemIdByIndex(uint256 _itemId, uint256 _index) external view validItem(_itemId) returns(uint256) {
1246     bytes8 itemHash = itemIdToHash[_itemId];
1247     uint256[] storage items = sameItemIds[itemHash];
1248     require(_index < items.length, "out of boundray");
1249     return items[_index];
1250   }
1251 
1252   function getItemHash(uint256 _itemId) external view validItem(_itemId) returns (bytes8) {
1253     return itemIdToHash[_itemId];
1254   }
1255 
1256   function isSameItem(uint256 _itemId1, uint256 _itemId2)
1257     external
1258     view
1259     validItem(_itemId1)
1260     validItem(_itemId2)
1261     returns (bool _isSame) {
1262     if(_itemId1 == _itemId2) {
1263       _isSame = true;
1264     } else {
1265       _isSame = _calcuItemHash(_itemId1) == _calcuItemHash(_itemId2);
1266     }
1267   }
1268 
1269   function burnItem(address _owner, uint256 _itemId) external onlyOperator itemExists(_itemId) {
1270     _burnItem(_owner, _itemId);
1271   }
1272 
1273   function createItem( 
1274     address _owner,
1275     string _founder,
1276     string _creator, 
1277     bool _isBitizenItem, 
1278     uint256[4] _attr1,
1279     uint8[5] _attr2,
1280     uint16[2] _attr3)
1281     external  
1282     onlyOperator
1283     returns(uint256 _itemId) {
1284     require(_owner != address(0), "address invalid");
1285     AvatarItem memory item = _mintItem(_founder, _creator, _isBitizenItem, _attr1, _attr2, _attr3);
1286     _itemId = ++itemIndex;
1287     avatarItems[_itemId] = item;
1288     _mint(_owner, _itemId);
1289     _saveItemHash(_itemId);
1290     emit ItemHandleEvent(_owner, _itemId, ItemHandleType.CREATE_ITEM);
1291   }
1292 
1293   function updateItem(
1294     uint256 _itemId,
1295     bool  _isBitizenItem,
1296     uint16 _miningTime,
1297     uint16 _magicFind,
1298     uint256 _node,
1299     uint256 _listNumber,
1300     uint256 _setNumber,
1301     uint256 _quality,
1302     uint8 _rarity,
1303     uint8 _socket,
1304     uint8 _gender,
1305     uint8 _energy,
1306     uint8 _ext
1307   ) 
1308   external 
1309   onlyOperator
1310   itemExists(_itemId){
1311     _deleteOldValue(_itemId); 
1312     _updateItem(_itemId,_isBitizenItem,_miningTime,_magicFind,_node,_listNumber,_setNumber,_quality,_rarity,_socket,_gender,_energy,_ext);
1313     _saveItemHash(_itemId);
1314   }
1315 
1316   function _deleteOldValue(uint256 _itemId) private {
1317     uint256[] storage tokenIds = sameItemIds[itemIdToHash[_itemId]];
1318     require(tokenIds.length > 0);
1319     uint256 lastTokenId = tokenIds[tokenIds.length - 1];
1320     tokenIds[sameItemIdIndex[_itemId]] = lastTokenId;
1321     sameItemIdIndex[lastTokenId] = sameItemIdIndex[_itemId];
1322     tokenIds.length--;
1323   }
1324 
1325   function _saveItemHash(uint256 _itemId) private {
1326     bytes8 itemHash = _calcuItemHash(_itemId);
1327     uint256 index = sameItemIds[itemHash].push(_itemId);
1328     sameItemIdIndex[_itemId] = index - 1;
1329     itemIdToHash[_itemId] = itemHash;
1330   }
1331     
1332   function _calcuItemHash(uint256 _itemId) private view returns (bytes8) {
1333     AvatarItem storage item = avatarItems[_itemId];
1334     bytes memory itemBytes = abi.encodePacked(
1335       item.isBitizenItem,
1336       item.miningTime,
1337       item.magicFind,
1338       item.node,
1339       item.listNumber,
1340       item.setNumber,
1341       item.quality,
1342       item.rarity,
1343       item.socket,
1344       item.gender,
1345       item.energy,
1346       item.ext
1347       );
1348     return bytes8(keccak256(itemBytes));
1349   }
1350 
1351   function _mintItem(  
1352     string _foundedBy,
1353     string _createdBy, 
1354     bool _isBitizenItem, 
1355     uint256[4] _attr1, 
1356     uint8[5] _attr2,
1357     uint16[2] _attr3) 
1358     private
1359     pure
1360     returns(AvatarItem _item) {
1361     _item = AvatarItem(
1362       _foundedBy,
1363       _createdBy,
1364       _isBitizenItem, 
1365       _attr3[0], 
1366       _attr3[1], 
1367       _attr1[0],
1368       _attr1[1], 
1369       _attr1[2], 
1370       _attr1[3],
1371       _attr2[0], 
1372       _attr2[1], 
1373       _attr2[2], 
1374       _attr2[3],
1375       _attr2[4]
1376     );
1377   }
1378 
1379   function _updateItem(
1380     uint256 _itemId,
1381     bool  _isBitizenItem,
1382     uint16 _miningTime,
1383     uint16 _magicFind,
1384     uint256 _node,
1385     uint256 _listNumber,
1386     uint256 _setNumber,
1387     uint256 _quality,
1388     uint8 _rarity,
1389     uint8 _socket,
1390     uint8 _gender,
1391     uint8 _energy,
1392     uint8 _ext
1393   ) private {
1394     AvatarItem storage item = avatarItems[_itemId];
1395     item.isBitizenItem = _isBitizenItem;
1396     item.miningTime = _miningTime;
1397     item.magicFind = _magicFind;
1398     item.node = _node;
1399     item.listNumber = _listNumber;
1400     item.setNumber = _setNumber;
1401     item.quality = _quality;
1402     item.rarity = _rarity;
1403     item.socket = _socket;
1404     item.gender = _gender;  
1405     item.energy = _energy; 
1406     item.ext = _ext; 
1407     emit ItemHandleEvent(_ownerOf(_itemId), _itemId, ItemHandleType.UPDATE_ITEM);
1408   }
1409 
1410   function _burnItem(address _owner, uint256 _itemId) private {
1411     burnedItemIds.push(_itemId);
1412     isBurnedItem[_itemId] = true;
1413     _burn(_owner, _itemId);
1414     emit ItemHandleEvent(_owner, _itemId, ItemHandleType.BURN_ITEM);
1415   }
1416 
1417   // override 
1418   //Add default permission to avatar, user can change this permission by call setApprovalForAll
1419   function _mint(address _to, uint256 _itemId) internal {
1420     super._mint(_to, _itemId);
1421     operatorApprovals[_to][avatarAccount] = true;
1422   }
1423 
1424   // override
1425   // record every token transfer count
1426   function _transfer(address _from, address _to, uint256 _itemId) internal {
1427     super._transfer(_from, _to, _itemId);
1428     itemTransferCount[_itemId]++;
1429   }
1430 
1431   function () public payable {
1432     revert();
1433   }
1434 }