1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
4 
5 /**
6  * @title Roles
7  * @author Francisco Giordano (@frangio)
8  * @dev Library for managing addresses assigned to a Role.
9  * See RBAC.sol for example usage.
10  */
11 library Roles {
12   struct Role {
13     mapping (address => bool) bearer;
14   }
15 
16   /**
17    * @dev give an address access to this role
18    */
19   function add(Role storage _role, address _addr)
20     internal
21   {
22     _role.bearer[_addr] = true;
23   }
24 
25   /**
26    * @dev remove an address' access to this role
27    */
28   function remove(Role storage _role, address _addr)
29     internal
30   {
31     _role.bearer[_addr] = false;
32   }
33 
34   /**
35    * @dev check if an address has this role
36    * // reverts
37    */
38   function check(Role storage _role, address _addr)
39     internal
40     view
41   {
42     require(has(_role, _addr));
43   }
44 
45   /**
46    * @dev check if an address has this role
47    * @return bool
48    */
49   function has(Role storage _role, address _addr)
50     internal
51     view
52     returns (bool)
53   {
54     return _role.bearer[_addr];
55   }
56 }
57 
58 // File: contracts/v2/AccessControl.sol
59 
60 /**
61  * @title Based on OpenZeppelin Whitelist & RBCA contracts
62  * @dev The AccessControl contract provides different access for addresses, and provides basic authorization control functions.
63  */
64 contract AccessControl {
65 
66   using Roles for Roles.Role;
67 
68   uint8 public constant ROLE_KNOWN_ORIGIN = 1;
69   uint8 public constant ROLE_MINTER = 2;
70   uint8 public constant ROLE_UNDER_MINTER = 3;
71 
72   event RoleAdded(address indexed operator, uint8 role);
73   event RoleRemoved(address indexed operator, uint8 role);
74 
75   address public owner;
76 
77   mapping(uint8 => Roles.Role) private roles;
78 
79   modifier onlyIfKnownOrigin() {
80     require(msg.sender == owner || hasRole(msg.sender, ROLE_KNOWN_ORIGIN));
81     _;
82   }
83 
84   modifier onlyIfMinter() {
85     require(msg.sender == owner || hasRole(msg.sender, ROLE_KNOWN_ORIGIN) || hasRole(msg.sender, ROLE_MINTER));
86     _;
87   }
88 
89   modifier onlyIfUnderMinter() {
90     require(msg.sender == owner || hasRole(msg.sender, ROLE_KNOWN_ORIGIN) || hasRole(msg.sender, ROLE_UNDER_MINTER));
91     _;
92   }
93 
94   constructor() public {
95     owner = msg.sender;
96   }
97 
98   ////////////////////////////////////
99   // Whitelist/RBCA Derived Methods //
100   ////////////////////////////////////
101 
102   function addAddressToAccessControl(address _operator, uint8 _role)
103   public
104   onlyIfKnownOrigin
105   {
106     roles[_role].add(_operator);
107     emit RoleAdded(_operator, _role);
108   }
109 
110   function removeAddressFromAccessControl(address _operator, uint8 _role)
111   public
112   onlyIfKnownOrigin
113   {
114     roles[_role].remove(_operator);
115     emit RoleRemoved(_operator, _role);
116   }
117 
118   function checkRole(address _operator, uint8 _role)
119   public
120   view
121   {
122     roles[_role].check(_operator);
123   }
124 
125   function hasRole(address _operator, uint8 _role)
126   public
127   view
128   returns (bool)
129   {
130     return roles[_role].has(_operator);
131   }
132 
133 }
134 
135 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
136 
137 /**
138  * @title Ownable
139  * @dev The Ownable contract has an owner address, and provides basic authorization control
140  * functions, this simplifies the implementation of "user permissions".
141  */
142 contract Ownable {
143   address public owner;
144 
145 
146   event OwnershipRenounced(address indexed previousOwner);
147   event OwnershipTransferred(
148     address indexed previousOwner,
149     address indexed newOwner
150   );
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   constructor() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to relinquish control of the contract.
171    * @notice Renouncing to ownership will leave the contract without an owner.
172    * It will not be possible to call the functions with the `onlyOwner`
173    * modifier anymore.
174    */
175   function renounceOwnership() public onlyOwner {
176     emit OwnershipRenounced(owner);
177     owner = address(0);
178   }
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param _newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address _newOwner) public onlyOwner {
185     _transferOwnership(_newOwner);
186   }
187 
188   /**
189    * @dev Transfers control of the contract to a newOwner.
190    * @param _newOwner The address to transfer ownership to.
191    */
192   function _transferOwnership(address _newOwner) internal {
193     require(_newOwner != address(0));
194     emit OwnershipTransferred(owner, _newOwner);
195     owner = _newOwner;
196   }
197 }
198 
199 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
200 
201 /**
202  * @title Contracts that should not own Ether
203  * @author Remco Bloemen <remco@2π.com>
204  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
205  * in the contract, it will allow the owner to reclaim this Ether.
206  * @notice Ether can still be sent to this contract by:
207  * calling functions labeled `payable`
208  * `selfdestruct(contract_address)`
209  * mining directly to the contract address
210  */
211 contract HasNoEther is Ownable {
212 
213   /**
214   * @dev Constructor that rejects incoming Ether
215   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
216   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
217   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
218   * we could use assembly to access msg.value.
219   */
220   constructor() public payable {
221     require(msg.value == 0);
222   }
223 
224   /**
225    * @dev Disallows direct send by setting a default function without the `payable` flag.
226    */
227   function() external {
228   }
229 
230   /**
231    * @dev Transfer all Ether held by the contract to the owner.
232    */
233   function reclaimEther() external onlyOwner {
234     owner.transfer(address(this).balance);
235   }
236 }
237 
238 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
239 
240 /**
241  * @title SafeMath
242  * @dev Math operations with safety checks that throw on error
243  */
244 library SafeMath {
245 
246   /**
247   * @dev Multiplies two numbers, throws on overflow.
248   */
249   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
250     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
251     // benefit is lost if 'b' is also tested.
252     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
253     if (_a == 0) {
254       return 0;
255     }
256 
257     c = _a * _b;
258     assert(c / _a == _b);
259     return c;
260   }
261 
262   /**
263   * @dev Integer division of two numbers, truncating the quotient.
264   */
265   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
266     // assert(_b > 0); // Solidity automatically throws when dividing by 0
267     // uint256 c = _a / _b;
268     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
269     return _a / _b;
270   }
271 
272   /**
273   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
274   */
275   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
276     assert(_b <= _a);
277     return _a - _b;
278   }
279 
280   /**
281   * @dev Adds two numbers, throws on overflow.
282   */
283   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
284     c = _a + _b;
285     assert(c >= _a);
286     return c;
287   }
288 }
289 
290 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
291 
292 /**
293  * @title Pausable
294  * @dev Base contract which allows children to implement an emergency stop mechanism.
295  */
296 contract Pausable is Ownable {
297   event Pause();
298   event Unpause();
299 
300   bool public paused = false;
301 
302 
303   /**
304    * @dev Modifier to make a function callable only when the contract is not paused.
305    */
306   modifier whenNotPaused() {
307     require(!paused);
308     _;
309   }
310 
311   /**
312    * @dev Modifier to make a function callable only when the contract is paused.
313    */
314   modifier whenPaused() {
315     require(paused);
316     _;
317   }
318 
319   /**
320    * @dev called by the owner to pause, triggers stopped state
321    */
322   function pause() public onlyOwner whenNotPaused {
323     paused = true;
324     emit Pause();
325   }
326 
327   /**
328    * @dev called by the owner to unpause, returns to normal state
329    */
330   function unpause() public onlyOwner whenPaused {
331     paused = false;
332     emit Unpause();
333   }
334 }
335 
336 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
337 
338 /**
339  * @title ERC165
340  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
341  */
342 interface ERC165 {
343 
344   /**
345    * @notice Query if a contract implements an interface
346    * @param _interfaceId The interface identifier, as specified in ERC-165
347    * @dev Interface identification is specified in ERC-165. This function
348    * uses less than 30,000 gas.
349    */
350   function supportsInterface(bytes4 _interfaceId)
351     external
352     view
353     returns (bool);
354 }
355 
356 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
357 
358 /**
359  * @title ERC721 Non-Fungible Token Standard basic interface
360  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
361  */
362 contract ERC721Basic is ERC165 {
363 
364   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
365   /*
366    * 0x80ac58cd ===
367    *   bytes4(keccak256('balanceOf(address)')) ^
368    *   bytes4(keccak256('ownerOf(uint256)')) ^
369    *   bytes4(keccak256('approve(address,uint256)')) ^
370    *   bytes4(keccak256('getApproved(uint256)')) ^
371    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
372    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
373    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
374    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
375    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
376    */
377 
378   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
379   /*
380    * 0x4f558e79 ===
381    *   bytes4(keccak256('exists(uint256)'))
382    */
383 
384   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
385   /**
386    * 0x780e9d63 ===
387    *   bytes4(keccak256('totalSupply()')) ^
388    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
389    *   bytes4(keccak256('tokenByIndex(uint256)'))
390    */
391 
392   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
393   /**
394    * 0x5b5e139f ===
395    *   bytes4(keccak256('name()')) ^
396    *   bytes4(keccak256('symbol()')) ^
397    *   bytes4(keccak256('tokenURI(uint256)'))
398    */
399 
400   event Transfer(
401     address indexed _from,
402     address indexed _to,
403     uint256 indexed _tokenId
404   );
405   event Approval(
406     address indexed _owner,
407     address indexed _approved,
408     uint256 indexed _tokenId
409   );
410   event ApprovalForAll(
411     address indexed _owner,
412     address indexed _operator,
413     bool _approved
414   );
415 
416   function balanceOf(address _owner) public view returns (uint256 _balance);
417   function ownerOf(uint256 _tokenId) public view returns (address _owner);
418   function exists(uint256 _tokenId) public view returns (bool _exists);
419 
420   function approve(address _to, uint256 _tokenId) public;
421   function getApproved(uint256 _tokenId)
422     public view returns (address _operator);
423 
424   function setApprovalForAll(address _operator, bool _approved) public;
425   function isApprovedForAll(address _owner, address _operator)
426     public view returns (bool);
427 
428   function transferFrom(address _from, address _to, uint256 _tokenId) public;
429   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
430     public;
431 
432   function safeTransferFrom(
433     address _from,
434     address _to,
435     uint256 _tokenId,
436     bytes _data
437   )
438     public;
439 }
440 
441 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
442 
443 /**
444  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
445  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
446  */
447 contract ERC721Enumerable is ERC721Basic {
448   function totalSupply() public view returns (uint256);
449   function tokenOfOwnerByIndex(
450     address _owner,
451     uint256 _index
452   )
453     public
454     view
455     returns (uint256 _tokenId);
456 
457   function tokenByIndex(uint256 _index) public view returns (uint256);
458 }
459 
460 
461 /**
462  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
463  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
464  */
465 contract ERC721Metadata is ERC721Basic {
466   function name() external view returns (string _name);
467   function symbol() external view returns (string _symbol);
468   function tokenURI(uint256 _tokenId) public view returns (string);
469 }
470 
471 
472 /**
473  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
474  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
475  */
476 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
477 }
478 
479 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
480 
481 /**
482  * @title ERC721 token receiver interface
483  * @dev Interface for any contract that wants to support safeTransfers
484  * from ERC721 asset contracts.
485  */
486 contract ERC721Receiver {
487   /**
488    * @dev Magic value to be returned upon successful reception of an NFT
489    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
490    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
491    */
492   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
493 
494   /**
495    * @notice Handle the receipt of an NFT
496    * @dev The ERC721 smart contract calls this function on the recipient
497    * after a `safetransfer`. This function MAY throw to revert and reject the
498    * transfer. Return of other than the magic value MUST result in the
499    * transaction being reverted.
500    * Note: the contract address is always the message sender.
501    * @param _operator The address which called `safeTransferFrom` function
502    * @param _from The address which previously owned the token
503    * @param _tokenId The NFT identifier which is being transferred
504    * @param _data Additional data with no specified format
505    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
506    */
507   function onERC721Received(
508     address _operator,
509     address _from,
510     uint256 _tokenId,
511     bytes _data
512   )
513     public
514     returns(bytes4);
515 }
516 
517 // File: openzeppelin-solidity/contracts/AddressUtils.sol
518 
519 /**
520  * Utility library of inline functions on addresses
521  */
522 library AddressUtils {
523 
524   /**
525    * Returns whether the target address is a contract
526    * @dev This function will return false if invoked during the constructor of a contract,
527    * as the code is not actually created until after the constructor finishes.
528    * @param _addr address to check
529    * @return whether the target address is a contract
530    */
531   function isContract(address _addr) internal view returns (bool) {
532     uint256 size;
533     // XXX Currently there is no better way to check if there is a contract in an address
534     // than to check the size of the code at that address.
535     // See https://ethereum.stackexchange.com/a/14016/36603
536     // for more details about how this works.
537     // TODO Check this again before the Serenity release, because all addresses will be
538     // contracts then.
539     // solium-disable-next-line security/no-inline-assembly
540     assembly { size := extcodesize(_addr) }
541     return size > 0;
542   }
543 
544 }
545 
546 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
547 
548 /**
549  * @title SupportsInterfaceWithLookup
550  * @author Matt Condon (@shrugs)
551  * @dev Implements ERC165 using a lookup table.
552  */
553 contract SupportsInterfaceWithLookup is ERC165 {
554 
555   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
556   /**
557    * 0x01ffc9a7 ===
558    *   bytes4(keccak256('supportsInterface(bytes4)'))
559    */
560 
561   /**
562    * @dev a mapping of interface id to whether or not it's supported
563    */
564   mapping(bytes4 => bool) internal supportedInterfaces;
565 
566   /**
567    * @dev A contract implementing SupportsInterfaceWithLookup
568    * implement ERC165 itself
569    */
570   constructor()
571     public
572   {
573     _registerInterface(InterfaceId_ERC165);
574   }
575 
576   /**
577    * @dev implement supportsInterface(bytes4) using a lookup table
578    */
579   function supportsInterface(bytes4 _interfaceId)
580     external
581     view
582     returns (bool)
583   {
584     return supportedInterfaces[_interfaceId];
585   }
586 
587   /**
588    * @dev private method for registering an interface
589    */
590   function _registerInterface(bytes4 _interfaceId)
591     internal
592   {
593     require(_interfaceId != 0xffffffff);
594     supportedInterfaces[_interfaceId] = true;
595   }
596 }
597 
598 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
599 
600 /**
601  * @title ERC721 Non-Fungible Token Standard basic implementation
602  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
603  */
604 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
605 
606   using SafeMath for uint256;
607   using AddressUtils for address;
608 
609   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
610   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
611   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
612 
613   // Mapping from token ID to owner
614   mapping (uint256 => address) internal tokenOwner;
615 
616   // Mapping from token ID to approved address
617   mapping (uint256 => address) internal tokenApprovals;
618 
619   // Mapping from owner to number of owned token
620   mapping (address => uint256) internal ownedTokensCount;
621 
622   // Mapping from owner to operator approvals
623   mapping (address => mapping (address => bool)) internal operatorApprovals;
624 
625   constructor()
626     public
627   {
628     // register the supported interfaces to conform to ERC721 via ERC165
629     _registerInterface(InterfaceId_ERC721);
630     _registerInterface(InterfaceId_ERC721Exists);
631   }
632 
633   /**
634    * @dev Gets the balance of the specified address
635    * @param _owner address to query the balance of
636    * @return uint256 representing the amount owned by the passed address
637    */
638   function balanceOf(address _owner) public view returns (uint256) {
639     require(_owner != address(0));
640     return ownedTokensCount[_owner];
641   }
642 
643   /**
644    * @dev Gets the owner of the specified token ID
645    * @param _tokenId uint256 ID of the token to query the owner of
646    * @return owner address currently marked as the owner of the given token ID
647    */
648   function ownerOf(uint256 _tokenId) public view returns (address) {
649     address owner = tokenOwner[_tokenId];
650     require(owner != address(0));
651     return owner;
652   }
653 
654   /**
655    * @dev Returns whether the specified token exists
656    * @param _tokenId uint256 ID of the token to query the existence of
657    * @return whether the token exists
658    */
659   function exists(uint256 _tokenId) public view returns (bool) {
660     address owner = tokenOwner[_tokenId];
661     return owner != address(0);
662   }
663 
664   /**
665    * @dev Approves another address to transfer the given token ID
666    * The zero address indicates there is no approved address.
667    * There can only be one approved address per token at a given time.
668    * Can only be called by the token owner or an approved operator.
669    * @param _to address to be approved for the given token ID
670    * @param _tokenId uint256 ID of the token to be approved
671    */
672   function approve(address _to, uint256 _tokenId) public {
673     address owner = ownerOf(_tokenId);
674     require(_to != owner);
675     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
676 
677     tokenApprovals[_tokenId] = _to;
678     emit Approval(owner, _to, _tokenId);
679   }
680 
681   /**
682    * @dev Gets the approved address for a token ID, or zero if no address set
683    * @param _tokenId uint256 ID of the token to query the approval of
684    * @return address currently approved for the given token ID
685    */
686   function getApproved(uint256 _tokenId) public view returns (address) {
687     return tokenApprovals[_tokenId];
688   }
689 
690   /**
691    * @dev Sets or unsets the approval of a given operator
692    * An operator is allowed to transfer all tokens of the sender on their behalf
693    * @param _to operator address to set the approval
694    * @param _approved representing the status of the approval to be set
695    */
696   function setApprovalForAll(address _to, bool _approved) public {
697     require(_to != msg.sender);
698     operatorApprovals[msg.sender][_to] = _approved;
699     emit ApprovalForAll(msg.sender, _to, _approved);
700   }
701 
702   /**
703    * @dev Tells whether an operator is approved by a given owner
704    * @param _owner owner address which you want to query the approval of
705    * @param _operator operator address which you want to query the approval of
706    * @return bool whether the given operator is approved by the given owner
707    */
708   function isApprovedForAll(
709     address _owner,
710     address _operator
711   )
712     public
713     view
714     returns (bool)
715   {
716     return operatorApprovals[_owner][_operator];
717   }
718 
719   /**
720    * @dev Transfers the ownership of a given token ID to another address
721    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
722    * Requires the msg sender to be the owner, approved, or operator
723    * @param _from current owner of the token
724    * @param _to address to receive the ownership of the given token ID
725    * @param _tokenId uint256 ID of the token to be transferred
726   */
727   function transferFrom(
728     address _from,
729     address _to,
730     uint256 _tokenId
731   )
732     public
733   {
734     require(isApprovedOrOwner(msg.sender, _tokenId));
735     require(_from != address(0));
736     require(_to != address(0));
737 
738     clearApproval(_from, _tokenId);
739     removeTokenFrom(_from, _tokenId);
740     addTokenTo(_to, _tokenId);
741 
742     emit Transfer(_from, _to, _tokenId);
743   }
744 
745   /**
746    * @dev Safely transfers the ownership of a given token ID to another address
747    * If the target address is a contract, it must implement `onERC721Received`,
748    * which is called upon a safe transfer, and return the magic value
749    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
750    * the transfer is reverted.
751    *
752    * Requires the msg sender to be the owner, approved, or operator
753    * @param _from current owner of the token
754    * @param _to address to receive the ownership of the given token ID
755    * @param _tokenId uint256 ID of the token to be transferred
756   */
757   function safeTransferFrom(
758     address _from,
759     address _to,
760     uint256 _tokenId
761   )
762     public
763   {
764     // solium-disable-next-line arg-overflow
765     safeTransferFrom(_from, _to, _tokenId, "");
766   }
767 
768   /**
769    * @dev Safely transfers the ownership of a given token ID to another address
770    * If the target address is a contract, it must implement `onERC721Received`,
771    * which is called upon a safe transfer, and return the magic value
772    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
773    * the transfer is reverted.
774    * Requires the msg sender to be the owner, approved, or operator
775    * @param _from current owner of the token
776    * @param _to address to receive the ownership of the given token ID
777    * @param _tokenId uint256 ID of the token to be transferred
778    * @param _data bytes data to send along with a safe transfer check
779    */
780   function safeTransferFrom(
781     address _from,
782     address _to,
783     uint256 _tokenId,
784     bytes _data
785   )
786     public
787   {
788     transferFrom(_from, _to, _tokenId);
789     // solium-disable-next-line arg-overflow
790     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
791   }
792 
793   /**
794    * @dev Returns whether the given spender can transfer a given token ID
795    * @param _spender address of the spender to query
796    * @param _tokenId uint256 ID of the token to be transferred
797    * @return bool whether the msg.sender is approved for the given token ID,
798    *  is an operator of the owner, or is the owner of the token
799    */
800   function isApprovedOrOwner(
801     address _spender,
802     uint256 _tokenId
803   )
804     internal
805     view
806     returns (bool)
807   {
808     address owner = ownerOf(_tokenId);
809     // Disable solium check because of
810     // https://github.com/duaraghav8/Solium/issues/175
811     // solium-disable-next-line operator-whitespace
812     return (
813       _spender == owner ||
814       getApproved(_tokenId) == _spender ||
815       isApprovedForAll(owner, _spender)
816     );
817   }
818 
819   /**
820    * @dev Internal function to mint a new token
821    * Reverts if the given token ID already exists
822    * @param _to The address that will own the minted token
823    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
824    */
825   function _mint(address _to, uint256 _tokenId) internal {
826     require(_to != address(0));
827     addTokenTo(_to, _tokenId);
828     emit Transfer(address(0), _to, _tokenId);
829   }
830 
831   /**
832    * @dev Internal function to burn a specific token
833    * Reverts if the token does not exist
834    * @param _tokenId uint256 ID of the token being burned by the msg.sender
835    */
836   function _burn(address _owner, uint256 _tokenId) internal {
837     clearApproval(_owner, _tokenId);
838     removeTokenFrom(_owner, _tokenId);
839     emit Transfer(_owner, address(0), _tokenId);
840   }
841 
842   /**
843    * @dev Internal function to clear current approval of a given token ID
844    * Reverts if the given address is not indeed the owner of the token
845    * @param _owner owner of the token
846    * @param _tokenId uint256 ID of the token to be transferred
847    */
848   function clearApproval(address _owner, uint256 _tokenId) internal {
849     require(ownerOf(_tokenId) == _owner);
850     if (tokenApprovals[_tokenId] != address(0)) {
851       tokenApprovals[_tokenId] = address(0);
852     }
853   }
854 
855   /**
856    * @dev Internal function to add a token ID to the list of a given address
857    * @param _to address representing the new owner of the given token ID
858    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
859    */
860   function addTokenTo(address _to, uint256 _tokenId) internal {
861     require(tokenOwner[_tokenId] == address(0));
862     tokenOwner[_tokenId] = _to;
863     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
864   }
865 
866   /**
867    * @dev Internal function to remove a token ID from the list of a given address
868    * @param _from address representing the previous owner of the given token ID
869    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
870    */
871   function removeTokenFrom(address _from, uint256 _tokenId) internal {
872     require(ownerOf(_tokenId) == _from);
873     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
874     tokenOwner[_tokenId] = address(0);
875   }
876 
877   /**
878    * @dev Internal function to invoke `onERC721Received` on a target address
879    * The call is not executed if the target address is not a contract
880    * @param _from address representing the previous owner of the given token ID
881    * @param _to target address that will receive the tokens
882    * @param _tokenId uint256 ID of the token to be transferred
883    * @param _data bytes optional data to send along with the call
884    * @return whether the call correctly returned the expected magic value
885    */
886   function checkAndCallSafeTransfer(
887     address _from,
888     address _to,
889     uint256 _tokenId,
890     bytes _data
891   )
892     internal
893     returns (bool)
894   {
895     if (!_to.isContract()) {
896       return true;
897     }
898     bytes4 retval = ERC721Receiver(_to).onERC721Received(
899       msg.sender, _from, _tokenId, _data);
900     return (retval == ERC721_RECEIVED);
901   }
902 }
903 
904 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
905 
906 /**
907  * @title Full ERC721 Token
908  * This implementation includes all the required and some optional functionality of the ERC721 standard
909  * Moreover, it includes approve all functionality using operator terminology
910  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
911  */
912 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
913 
914   // Token name
915   string internal name_;
916 
917   // Token symbol
918   string internal symbol_;
919 
920   // Mapping from owner to list of owned token IDs
921   mapping(address => uint256[]) internal ownedTokens;
922 
923   // Mapping from token ID to index of the owner tokens list
924   mapping(uint256 => uint256) internal ownedTokensIndex;
925 
926   // Array with all token ids, used for enumeration
927   uint256[] internal allTokens;
928 
929   // Mapping from token id to position in the allTokens array
930   mapping(uint256 => uint256) internal allTokensIndex;
931 
932   // Optional mapping for token URIs
933   mapping(uint256 => string) internal tokenURIs;
934 
935   /**
936    * @dev Constructor function
937    */
938   constructor(string _name, string _symbol) public {
939     name_ = _name;
940     symbol_ = _symbol;
941 
942     // register the supported interfaces to conform to ERC721 via ERC165
943     _registerInterface(InterfaceId_ERC721Enumerable);
944     _registerInterface(InterfaceId_ERC721Metadata);
945   }
946 
947   /**
948    * @dev Gets the token name
949    * @return string representing the token name
950    */
951   function name() external view returns (string) {
952     return name_;
953   }
954 
955   /**
956    * @dev Gets the token symbol
957    * @return string representing the token symbol
958    */
959   function symbol() external view returns (string) {
960     return symbol_;
961   }
962 
963   /**
964    * @dev Returns an URI for a given token ID
965    * Throws if the token ID does not exist. May return an empty string.
966    * @param _tokenId uint256 ID of the token to query
967    */
968   function tokenURI(uint256 _tokenId) public view returns (string) {
969     require(exists(_tokenId));
970     return tokenURIs[_tokenId];
971   }
972 
973   /**
974    * @dev Gets the token ID at a given index of the tokens list of the requested owner
975    * @param _owner address owning the tokens list to be accessed
976    * @param _index uint256 representing the index to be accessed of the requested tokens list
977    * @return uint256 token ID at the given index of the tokens list owned by the requested address
978    */
979   function tokenOfOwnerByIndex(
980     address _owner,
981     uint256 _index
982   )
983     public
984     view
985     returns (uint256)
986   {
987     require(_index < balanceOf(_owner));
988     return ownedTokens[_owner][_index];
989   }
990 
991   /**
992    * @dev Gets the total amount of tokens stored by the contract
993    * @return uint256 representing the total amount of tokens
994    */
995   function totalSupply() public view returns (uint256) {
996     return allTokens.length;
997   }
998 
999   /**
1000    * @dev Gets the token ID at a given index of all the tokens in this contract
1001    * Reverts if the index is greater or equal to the total number of tokens
1002    * @param _index uint256 representing the index to be accessed of the tokens list
1003    * @return uint256 token ID at the given index of the tokens list
1004    */
1005   function tokenByIndex(uint256 _index) public view returns (uint256) {
1006     require(_index < totalSupply());
1007     return allTokens[_index];
1008   }
1009 
1010   /**
1011    * @dev Internal function to set the token URI for a given token
1012    * Reverts if the token ID does not exist
1013    * @param _tokenId uint256 ID of the token to set its URI
1014    * @param _uri string URI to assign
1015    */
1016   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1017     require(exists(_tokenId));
1018     tokenURIs[_tokenId] = _uri;
1019   }
1020 
1021   /**
1022    * @dev Internal function to add a token ID to the list of a given address
1023    * @param _to address representing the new owner of the given token ID
1024    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1025    */
1026   function addTokenTo(address _to, uint256 _tokenId) internal {
1027     super.addTokenTo(_to, _tokenId);
1028     uint256 length = ownedTokens[_to].length;
1029     ownedTokens[_to].push(_tokenId);
1030     ownedTokensIndex[_tokenId] = length;
1031   }
1032 
1033   /**
1034    * @dev Internal function to remove a token ID from the list of a given address
1035    * @param _from address representing the previous owner of the given token ID
1036    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1037    */
1038   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1039     super.removeTokenFrom(_from, _tokenId);
1040 
1041     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1042     // then delete the last slot.
1043     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1044     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1045     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1046 
1047     ownedTokens[_from][tokenIndex] = lastToken;
1048     // This also deletes the contents at the last position of the array
1049     ownedTokens[_from].length--;
1050 
1051     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1052     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1053     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1054 
1055     ownedTokensIndex[_tokenId] = 0;
1056     ownedTokensIndex[lastToken] = tokenIndex;
1057   }
1058 
1059   /**
1060    * @dev Internal function to mint a new token
1061    * Reverts if the given token ID already exists
1062    * @param _to address the beneficiary that will own the minted token
1063    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1064    */
1065   function _mint(address _to, uint256 _tokenId) internal {
1066     super._mint(_to, _tokenId);
1067 
1068     allTokensIndex[_tokenId] = allTokens.length;
1069     allTokens.push(_tokenId);
1070   }
1071 
1072   /**
1073    * @dev Internal function to burn a specific token
1074    * Reverts if the token does not exist
1075    * @param _owner owner of the token to burn
1076    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1077    */
1078   function _burn(address _owner, uint256 _tokenId) internal {
1079     super._burn(_owner, _tokenId);
1080 
1081     // Clear metadata (if any)
1082     if (bytes(tokenURIs[_tokenId]).length != 0) {
1083       delete tokenURIs[_tokenId];
1084     }
1085 
1086     // Reorg all tokens array
1087     uint256 tokenIndex = allTokensIndex[_tokenId];
1088     uint256 lastTokenIndex = allTokens.length.sub(1);
1089     uint256 lastToken = allTokens[lastTokenIndex];
1090 
1091     allTokens[tokenIndex] = lastToken;
1092     allTokens[lastTokenIndex] = 0;
1093 
1094     allTokens.length--;
1095     allTokensIndex[_tokenId] = 0;
1096     allTokensIndex[lastToken] = tokenIndex;
1097   }
1098 
1099 }
1100 
1101 // File: contracts/v2/Strings.sol
1102 
1103 library Strings {
1104   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1105   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1106     bytes memory _ba = bytes(_a);
1107     bytes memory _bb = bytes(_b);
1108     bytes memory _bc = bytes(_c);
1109     bytes memory _bd = bytes(_d);
1110     bytes memory _be = bytes(_e);
1111     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1112     bytes memory babcde = bytes(abcde);
1113     uint k = 0;
1114     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1115     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1116     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1117     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1118     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1119     return string(babcde);
1120   }
1121 
1122   function strConcat(string _a, string _b) internal pure returns (string) {
1123     return strConcat(_a, _b, "", "", "");
1124   }
1125 }
1126 
1127 // File: contracts/v2/KnownOriginDigitalAssetV2.sol
1128 
1129 // allows for multi-address access controls to different functions
1130 
1131 
1132 // Prevents stuck ether
1133 
1134 
1135 // For safe maths operations
1136 
1137 
1138 // Pause purchasing only in case of emergency/migration
1139 
1140 
1141 // ERC721
1142 
1143 
1144 // Utils only
1145 
1146 
1147 /**
1148 * @title KnownOriginDigitalAsset - V2
1149 *
1150 * http://www.knownorigin.io/
1151 *
1152 * ERC721 compliant digital assets for real-world artwork.
1153 *
1154 * Base NFT Issuance Contract
1155 *
1156 * BE ORIGINAL. BUY ORIGINAL.
1157 *
1158 */
1159 contract KnownOriginDigitalAssetV2 is
1160 ERC721Token,
1161 AccessControl,
1162 HasNoEther,
1163 Pausable
1164 {
1165   using SafeMath for uint256;
1166 
1167   ////////////
1168   // Events //
1169   ////////////
1170 
1171   // Emitted on purchases from within this contract
1172   event Purchase(
1173     uint256 indexed _tokenId,
1174     uint256 indexed _editionNumber,
1175     address indexed _buyer,
1176     uint256 _priceInWei
1177   );
1178 
1179   // Emitted on every mint
1180   event Minted(
1181     uint256 indexed _tokenId,
1182     uint256 indexed _editionNumber,
1183     address indexed _buyer
1184   );
1185 
1186   // Emitted on every edition created
1187   event EditionCreated(
1188     uint256 indexed _editionNumber,
1189     bytes32 indexed _editionData,
1190     uint256 indexed _editionType
1191   );
1192 
1193   ////////////////
1194   // Properties //
1195   ////////////////
1196 
1197   uint256 constant internal MAX_UINT32 = ~uint32(0);
1198 
1199   string public tokenBaseURI = "https://ipfs.infura.io/ipfs/";
1200 
1201   // simple counter to keep track of the highest edition number used
1202   uint256 public highestEditionNumber;
1203 
1204   // total wei been processed through the contract
1205   uint256 public totalPurchaseValueInWei;
1206 
1207   // number of assets minted of any type
1208   uint256 public totalNumberMinted;
1209 
1210   // number of assets available of any type
1211   uint256 public totalNumberAvailable;
1212 
1213   // the KO account which can receive commission
1214   address public koCommissionAccount;
1215 
1216   // Optional commission split can be defined per edition
1217   mapping(uint256 => CommissionSplit) editionNumberToOptionalCommissionSplit;
1218 
1219   // Simple structure providing an optional commission split per edition purchase
1220   struct CommissionSplit {
1221     uint256 rate;
1222     address recipient;
1223   }
1224 
1225   // Object for edition details
1226   struct EditionDetails {
1227     // Identifiers
1228     uint256 editionNumber;    // the range e.g. 10000
1229     bytes32 editionData;      // some data about the edition
1230     uint256 editionType;      // e.g. 1 = KODA V1, 2 = KOTA, 3 = Bespoke partnership
1231     // Config
1232     uint256 startDate;        // date when the edition goes on sale
1233     uint256 endDate;          // date when the edition is available until
1234     address artistAccount;    // artists account
1235     uint256 artistCommission; // base artists commission, could be overridden by external contracts
1236     uint256 priceInWei;       // base price for edition, could be overridden by external contracts
1237     string tokenURI;          // IPFS hash - see base URI
1238     bool active;              // Root control - on/off for the edition
1239     // Counters
1240     uint256 totalSupply;      // Total purchases or mints
1241     uint256 totalAvailable;   // Total number available to be purchased
1242   }
1243 
1244   // _editionNumber : EditionDetails
1245   mapping(uint256 => EditionDetails) internal editionNumberToEditionDetails;
1246 
1247   // _tokenId : _editionNumber
1248   mapping(uint256 => uint256) internal tokenIdToEditionNumber;
1249 
1250   // _editionNumber : [_tokenId, _tokenId]
1251   mapping(uint256 => uint256[]) internal editionNumberToTokenIds;
1252   mapping(uint256 => uint256) internal editionNumberToTokenIdIndex;
1253 
1254   // _artistAccount : [_editionNumber, _editionNumber]
1255   mapping(address => uint256[]) internal artistToEditionNumbers;
1256   mapping(uint256 => uint256) internal editionNumberToArtistIndex;
1257 
1258   // _editionType : [_editionNumber, _editionNumber]
1259   mapping(uint256 => uint256[]) internal editionTypeToEditionNumber;
1260   mapping(uint256 => uint256) internal editionNumberToTypeIndex;
1261 
1262   ///////////////
1263   // Modifiers //
1264   ///////////////
1265 
1266   modifier onlyAvailableEdition(uint256 _editionNumber) {
1267     require(editionNumberToEditionDetails[_editionNumber].totalSupply < editionNumberToEditionDetails[_editionNumber].totalAvailable, "No more editions left to purchase");
1268     _;
1269   }
1270 
1271   modifier onlyActiveEdition(uint256 _editionNumber) {
1272     require(editionNumberToEditionDetails[_editionNumber].active, "Edition not active");
1273     _;
1274   }
1275 
1276   modifier onlyRealEdition(uint256 _editionNumber) {
1277     require(editionNumberToEditionDetails[_editionNumber].editionNumber > 0, "Edition number invalid");
1278     _;
1279   }
1280 
1281   modifier onlyValidTokenId(uint256 _tokenId) {
1282     require(exists(_tokenId), "Token ID does not exist");
1283     _;
1284   }
1285 
1286   modifier onlyPurchaseDuringWindow(uint256 _editionNumber) {
1287     require(editionNumberToEditionDetails[_editionNumber].startDate <= block.timestamp, "Edition not available yet");
1288     require(editionNumberToEditionDetails[_editionNumber].endDate >= block.timestamp, "Edition no longer available");
1289     _;
1290   }
1291 
1292   /*
1293    * Constructor
1294    */
1295   constructor () public payable ERC721Token("KnownOriginDigitalAsset", "KODA") {
1296     // set commission account to contract creator
1297     koCommissionAccount = msg.sender;
1298   }
1299 
1300   /**
1301    * @dev Creates an active edition from the given configuration
1302    * @dev Only callable from KO staff/addresses
1303    */
1304   function createActiveEdition(
1305     uint256 _editionNumber,
1306     bytes32 _editionData,
1307     uint256 _editionType,
1308     uint256 _startDate,
1309     uint256 _endDate,
1310     address _artistAccount,
1311     uint256 _artistCommission,
1312     uint256 _priceInWei,
1313     string _tokenURI,
1314     uint256 _totalAvailable
1315   )
1316   public
1317   onlyIfKnownOrigin
1318   returns (bool)
1319   {
1320     return _createEdition(_editionNumber, _editionData, _editionType, _startDate, _endDate, _artistAccount, _artistCommission, _priceInWei, _tokenURI, _totalAvailable, true);
1321   }
1322 
1323   /**
1324    * @dev Creates an inactive edition from the given configuration
1325    * @dev Only callable from KO staff/addresses
1326    */
1327   function createInactiveEdition(
1328     uint256 _editionNumber,
1329     bytes32 _editionData,
1330     uint256 _editionType,
1331     uint256 _startDate,
1332     uint256 _endDate,
1333     address _artistAccount,
1334     uint256 _artistCommission,
1335     uint256 _priceInWei,
1336     string _tokenURI,
1337     uint256 _totalAvailable
1338   )
1339   public
1340   onlyIfKnownOrigin
1341   returns (bool)
1342   {
1343     return _createEdition(_editionNumber, _editionData, _editionType, _startDate, _endDate, _artistAccount, _artistCommission, _priceInWei, _tokenURI, _totalAvailable, false);
1344   }
1345 
1346   /**
1347    * @dev Creates an active edition from the given configuration
1348    * @dev The concept of pre0minted editions means we can 'undermint' token IDS, good for holding back editions from public sale
1349    * @dev Only callable from KO staff/addresses
1350    */
1351   function createActivePreMintedEdition(
1352     uint256 _editionNumber,
1353     bytes32 _editionData,
1354     uint256 _editionType,
1355     uint256 _startDate,
1356     uint256 _endDate,
1357     address _artistAccount,
1358     uint256 _artistCommission,
1359     uint256 _priceInWei,
1360     string _tokenURI,
1361     uint256 _totalSupply,
1362     uint256 _totalAvailable
1363   )
1364   public
1365   onlyIfKnownOrigin
1366   returns (bool)
1367   {
1368     _createEdition(_editionNumber, _editionData, _editionType, _startDate, _endDate, _artistAccount, _artistCommission, _priceInWei, _tokenURI, _totalAvailable, true);
1369     updateTotalSupply(_editionNumber, _totalSupply);
1370     return true;
1371   }
1372 
1373   /**
1374    * @dev Creates an inactive edition from the given configuration
1375    * @dev The concept of pre0minted editions means we can 'undermint' token IDS, good for holding back editions from public sale
1376    * @dev Only callable from KO staff/addresses
1377    */
1378   function createInactivePreMintedEdition(
1379     uint256 _editionNumber,
1380     bytes32 _editionData,
1381     uint256 _editionType,
1382     uint256 _startDate,
1383     uint256 _endDate,
1384     address _artistAccount,
1385     uint256 _artistCommission,
1386     uint256 _priceInWei,
1387     string _tokenURI,
1388     uint256 _totalSupply,
1389     uint256 _totalAvailable
1390   )
1391   public
1392   onlyIfKnownOrigin
1393   returns (bool)
1394   {
1395     _createEdition(_editionNumber, _editionData, _editionType, _startDate, _endDate, _artistAccount, _artistCommission, _priceInWei, _tokenURI, _totalAvailable, false);
1396     updateTotalSupply(_editionNumber, _totalSupply);
1397     return true;
1398   }
1399 
1400   /**
1401    * @dev Internal factory method for building editions
1402    */
1403   function _createEdition(
1404     uint256 _editionNumber,
1405     bytes32 _editionData,
1406     uint256 _editionType,
1407     uint256 _startDate,
1408     uint256 _endDate,
1409     address _artistAccount,
1410     uint256 _artistCommission,
1411     uint256 _priceInWei,
1412     string _tokenURI,
1413     uint256 _totalAvailable,
1414     bool _active
1415   )
1416   internal
1417   returns (bool)
1418   {
1419     // Prevent missing edition number
1420     require(_editionNumber != 0, "Edition number not provided");
1421 
1422     // Prevent edition number lower than last one used
1423     require(_editionNumber > highestEditionNumber, "Edition number must be greater than previously used");
1424 
1425     // Check previously edition plus total available is less than new edition number
1426     require(highestEditionNumber.add(editionNumberToEditionDetails[highestEditionNumber].totalAvailable) < _editionNumber, "Edition number must be greater than previously used plus total available");
1427 
1428     // Prevent missing types
1429     require(_editionType != 0, "Edition type not provided");
1430 
1431     // Prevent missing token URI
1432     require(bytes(_tokenURI).length != 0, "Token URI is missing");
1433 
1434     // Prevent empty artists address
1435     require(_artistAccount != address(0), "Artist account not provided");
1436 
1437     // Prevent invalid commissions
1438     require(_artistCommission <= 100 && _artistCommission >= 0, "Artist commission cannot be greater than 100 or less than 0");
1439 
1440     // Prevent duplicate editions
1441     require(editionNumberToEditionDetails[_editionNumber].editionNumber == 0, "Edition already in existence");
1442 
1443     // Default end date to max uint256
1444     uint256 endDate = _endDate;
1445     if (_endDate == 0) {
1446       endDate = MAX_UINT32;
1447     }
1448 
1449     editionNumberToEditionDetails[_editionNumber] = EditionDetails({
1450       editionNumber : _editionNumber,
1451       editionData : _editionData,
1452       editionType : _editionType,
1453       startDate : _startDate,
1454       endDate : endDate,
1455       artistAccount : _artistAccount,
1456       artistCommission : _artistCommission,
1457       priceInWei : _priceInWei,
1458       tokenURI : _tokenURI,
1459       totalSupply : 0, // default to all available
1460       totalAvailable : _totalAvailable,
1461       active : _active
1462       });
1463 
1464     // Add to total available count
1465     totalNumberAvailable = totalNumberAvailable.add(_totalAvailable);
1466 
1467     // Update mappings
1468     _updateArtistLookupData(_artistAccount, _editionNumber);
1469     _updateEditionTypeLookupData(_editionType, _editionNumber);
1470 
1471     emit EditionCreated(_editionNumber, _editionData, _editionType);
1472 
1473     // Update the edition pointer if needs be
1474     highestEditionNumber = _editionNumber;
1475 
1476     return true;
1477   }
1478 
1479   function _updateEditionTypeLookupData(uint256 _editionType, uint256 _editionNumber) internal {
1480     uint256 typeEditionIndex = editionTypeToEditionNumber[_editionType].length;
1481     editionTypeToEditionNumber[_editionType].push(_editionNumber);
1482     editionNumberToTypeIndex[_editionNumber] = typeEditionIndex;
1483   }
1484 
1485   function _updateArtistLookupData(address _artistAccount, uint256 _editionNumber) internal {
1486     uint256 artistEditionIndex = artistToEditionNumbers[_artistAccount].length;
1487     artistToEditionNumbers[_artistAccount].push(_editionNumber);
1488     editionNumberToArtistIndex[_editionNumber] = artistEditionIndex;
1489   }
1490 
1491   /**
1492    * @dev Public entry point for purchasing an edition
1493    * @dev Reverts if edition is invalid
1494    * @dev Reverts if payment not provided in full
1495    * @dev Reverts if edition is sold out
1496    * @dev Reverts if edition is not active or available
1497    */
1498   function purchase(uint256 _editionNumber)
1499   public
1500   payable
1501   returns (uint256) {
1502     return purchaseTo(msg.sender, _editionNumber);
1503   }
1504 
1505   /**
1506    * @dev Public entry point for purchasing an edition on behalf of someone else
1507    * @dev Reverts if edition is invalid
1508    * @dev Reverts if payment not provided in full
1509    * @dev Reverts if edition is sold out
1510    * @dev Reverts if edition is not active or available
1511    */
1512   function purchaseTo(address _to, uint256 _editionNumber)
1513   public
1514   payable
1515   whenNotPaused
1516   onlyRealEdition(_editionNumber)
1517   onlyActiveEdition(_editionNumber)
1518   onlyAvailableEdition(_editionNumber)
1519   onlyPurchaseDuringWindow(_editionNumber)
1520   returns (uint256) {
1521 
1522     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
1523     require(msg.value >= _editionDetails.priceInWei, "Value must be greater than price of edition");
1524 
1525     // Construct next token ID e.g. 100000 + 1 = ID of 100001 (this first in the edition set)
1526     uint256 _tokenId = _nextTokenId(_editionNumber);
1527 
1528     // Create the token
1529     _mintToken(_to, _tokenId, _editionNumber, _editionDetails.tokenURI);
1530 
1531     // Splice funds and handle commissions
1532     _handleFunds(_editionNumber, _editionDetails.priceInWei, _editionDetails.artistAccount, _editionDetails.artistCommission);
1533 
1534     // Broadcast purchase
1535     emit Purchase(_tokenId, _editionNumber, _to, msg.value);
1536 
1537     return _tokenId;
1538   }
1539 
1540   /**
1541    * @dev Private (KO only) method for minting editions
1542    * @dev Payment not needed for this method
1543    */
1544   function mint(address _to, uint256 _editionNumber)
1545   public
1546   onlyIfMinter
1547   onlyRealEdition(_editionNumber)
1548   onlyAvailableEdition(_editionNumber)
1549   returns (uint256) {
1550     // Construct next token ID e.g. 100000 + 1 = ID of 100001 (this first in the edition set)
1551     uint256 _tokenId = _nextTokenId(_editionNumber);
1552 
1553     // Create the token
1554     _mintToken(_to, _tokenId, _editionNumber, editionNumberToEditionDetails[_editionNumber].tokenURI);
1555 
1556     // Create the token
1557     return _tokenId;
1558   }
1559 
1560   /**
1561    * @dev Private (KO only) method for under minting editions
1562    * @dev Under minting allows for token IDs to be back filled if total supply is not set to zero by default
1563    * @dev Payment not needed for this method
1564    */
1565   function underMint(address _to, uint256 _editionNumber)
1566   public
1567   onlyIfUnderMinter
1568   onlyRealEdition(_editionNumber)
1569   returns (uint256) {
1570     // Under mint token, meaning it takes one from the already sold version
1571     uint256 _tokenId = _underMintNextTokenId(_editionNumber);
1572 
1573     // If the next tokenId generate is more than the available number, abort as we have reached maximum under mint
1574     if (_tokenId > _editionNumber.add(editionNumberToEditionDetails[_editionNumber].totalAvailable)) {
1575       revert("Reached max tokenId, cannot under mint anymore");
1576     }
1577 
1578     // Create the token
1579     _mintToken(_to, _tokenId, _editionNumber, editionNumberToEditionDetails[_editionNumber].tokenURI);
1580 
1581     // Create the token
1582     return _tokenId;
1583   }
1584 
1585   function _nextTokenId(uint256 _editionNumber) internal returns (uint256) {
1586     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
1587 
1588     // Bump number totalSupply
1589     _editionDetails.totalSupply = _editionDetails.totalSupply.add(1);
1590 
1591     // Construct next token ID e.g. 100000 + 1 = ID of 100001 (this first in the edition set)
1592     return _editionDetails.editionNumber.add(_editionDetails.totalSupply);
1593   }
1594 
1595   function _underMintNextTokenId(uint256 _editionNumber) internal returns (uint256) {
1596     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
1597 
1598     // For old editions start the counter as edition + 1
1599     uint256 _tokenId = _editionDetails.editionNumber.add(1);
1600 
1601     // Work your way up until you find a free token based on the new _tokenIdd
1602     while (exists(_tokenId)) {
1603       _tokenId = _tokenId.add(1);
1604     }
1605 
1606     // Bump number totalSupply if we are now over minting new tokens
1607     if (_tokenId > _editionDetails.editionNumber.add(_editionDetails.totalSupply)) {
1608       _editionDetails.totalSupply = _editionDetails.totalSupply.add(1);
1609     }
1610 
1611     return _tokenId;
1612   }
1613 
1614   function _mintToken(address _to, uint256 _tokenId, uint256 _editionNumber, string _tokenURI) internal {
1615 
1616     // Mint new base token
1617     super._mint(_to, _tokenId);
1618     super._setTokenURI(_tokenId, _tokenURI);
1619 
1620     // Maintain mapping for tokenId to edition for lookup
1621     tokenIdToEditionNumber[_tokenId] = _editionNumber;
1622 
1623     // Get next insert position for edition to token Id mapping
1624     uint256 currentIndexOfTokenId = editionNumberToTokenIds[_editionNumber].length;
1625 
1626     // Maintain mapping of edition to token array for "edition minted tokens"
1627     editionNumberToTokenIds[_editionNumber].push(_tokenId);
1628 
1629     // Maintain a position index for the tokenId within the edition number mapping array, used for clean up token burn
1630     editionNumberToTokenIdIndex[_tokenId] = currentIndexOfTokenId;
1631 
1632     // Record sale volume
1633     totalNumberMinted = totalNumberMinted.add(1);
1634 
1635     // Emit minted event
1636     emit Minted(_tokenId, _editionNumber, _to);
1637   }
1638 
1639   function _handleFunds(uint256 _editionNumber, uint256 _priceInWei, address _artistAccount, uint256 _artistCommission) internal {
1640 
1641     // Extract the artists commission and send it
1642     uint256 artistPayment = _priceInWei.div(100).mul(_artistCommission);
1643     if (artistPayment > 0) {
1644       _artistAccount.transfer(artistPayment);
1645     }
1646 
1647     // Load any commission overrides
1648     CommissionSplit storage commission = editionNumberToOptionalCommissionSplit[_editionNumber];
1649 
1650     // Apply optional commission structure
1651     if (commission.rate > 0) {
1652       uint256 rateSplit = _priceInWei.div(100).mul(commission.rate);
1653       commission.recipient.transfer(rateSplit);
1654     }
1655 
1656     // Send remaining eth to KO
1657     uint256 remainingCommission = msg.value.sub(artistPayment).sub(rateSplit);
1658     koCommissionAccount.transfer(remainingCommission);
1659 
1660     // Record wei sale value
1661     totalPurchaseValueInWei = totalPurchaseValueInWei.add(msg.value);
1662   }
1663 
1664   /**
1665    * @dev Private (KO only) method for burning tokens which have been created incorrectly
1666    */
1667   function burn(uint256 _tokenId) public onlyIfKnownOrigin {
1668 
1669     // Clear from parents
1670     super._burn(ownerOf(_tokenId), _tokenId);
1671 
1672     // Get hold of the edition for cleanup
1673     uint256 _editionNumber = tokenIdToEditionNumber[_tokenId];
1674 
1675     // Delete token ID mapping
1676     delete tokenIdToEditionNumber[_tokenId];
1677 
1678     // Delete tokens associated to the edition - this will leave a gap in the array of zero
1679     uint256[] storage tokenIdsForEdition = editionNumberToTokenIds[_editionNumber];
1680     uint256 editionTokenIdIndex = editionNumberToTokenIdIndex[_tokenId];
1681     delete tokenIdsForEdition[editionTokenIdIndex];
1682   }
1683 
1684   /**
1685    * @dev An extension to the default ERC721 behaviour, derived from ERC-875.
1686    * @dev Allowing for batch transfers from the sender, will fail if from does not own all the tokens
1687    */
1688   function batchTransfer(address _to, uint256[] _tokenIds) public {
1689     for (uint i = 0; i < _tokenIds.length; i++) {
1690       safeTransferFrom(ownerOf(_tokenIds[i]), _to, _tokenIds[i]);
1691     }
1692   }
1693 
1694   /**
1695    * @dev An extension to the default ERC721 behaviour, derived from ERC-875.
1696    * @dev Allowing for batch transfers from the provided address, will fail if from does not own all the tokens
1697    */
1698   function batchTransferFrom(address _from, address _to, uint256[] _tokenIds) public {
1699     for (uint i = 0; i < _tokenIds.length; i++) {
1700       transferFrom(_from, _to, _tokenIds[i]);
1701     }
1702   }
1703 
1704   //////////////////
1705   // Base Updates //
1706   //////////////////
1707 
1708   function updateTokenBaseURI(string _newBaseURI)
1709   external
1710   onlyIfKnownOrigin {
1711     require(bytes(_newBaseURI).length != 0, "Base URI invalid");
1712     tokenBaseURI = _newBaseURI;
1713   }
1714 
1715   function updateKoCommissionAccount(address _koCommissionAccount)
1716   external
1717   onlyIfKnownOrigin {
1718     require(_koCommissionAccount != address(0), "Invalid address");
1719     koCommissionAccount = _koCommissionAccount;
1720   }
1721 
1722   /////////////////////
1723   // Edition Updates //
1724   /////////////////////
1725 
1726   function updateEditionTokenURI(uint256 _editionNumber, string _uri)
1727   external
1728   onlyIfKnownOrigin
1729   onlyRealEdition(_editionNumber) {
1730     editionNumberToEditionDetails[_editionNumber].tokenURI = _uri;
1731   }
1732 
1733   function updatePriceInWei(uint256 _editionNumber, uint256 _priceInWei)
1734   external
1735   onlyIfKnownOrigin
1736   onlyRealEdition(_editionNumber) {
1737     editionNumberToEditionDetails[_editionNumber].priceInWei = _priceInWei;
1738   }
1739 
1740   function updateArtistCommission(uint256 _editionNumber, uint256 _rate)
1741   external
1742   onlyIfKnownOrigin
1743   onlyRealEdition(_editionNumber) {
1744     editionNumberToEditionDetails[_editionNumber].artistCommission = _rate;
1745   }
1746 
1747   function updateArtistsAccount(uint256 _editionNumber, address _artistAccount)
1748   external
1749   onlyIfKnownOrigin
1750   onlyRealEdition(_editionNumber) {
1751 
1752     EditionDetails storage _originalEditionDetails = editionNumberToEditionDetails[_editionNumber];
1753 
1754     uint256 editionArtistIndex = editionNumberToArtistIndex[_editionNumber];
1755 
1756     // Get list of editions old artist works with
1757     uint256[] storage editionNumbersForArtist = artistToEditionNumbers[_originalEditionDetails.artistAccount];
1758 
1759     // Remove edition from artists lists
1760     delete editionNumbersForArtist[editionArtistIndex];
1761 
1762     // Add new artists to the list
1763     uint256 newArtistsEditionIndex = artistToEditionNumbers[_artistAccount].length;
1764     artistToEditionNumbers[_artistAccount].push(_editionNumber);
1765     editionNumberToArtistIndex[_editionNumber] = newArtistsEditionIndex;
1766 
1767     // Update the edition
1768     _originalEditionDetails.artistAccount = _artistAccount;
1769   }
1770 
1771   function updateEditionType(uint256 _editionNumber, uint256 _editionType)
1772   external
1773   onlyIfKnownOrigin
1774   onlyRealEdition(_editionNumber) {
1775 
1776     EditionDetails storage _originalEditionDetails = editionNumberToEditionDetails[_editionNumber];
1777 
1778     // Get list of editions for old type
1779     uint256[] storage editionNumbersForType = editionTypeToEditionNumber[_originalEditionDetails.editionType];
1780 
1781     // Remove edition from old type list
1782     uint256 editionTypeIndex = editionNumberToTypeIndex[_editionNumber];
1783     delete editionNumbersForType[editionTypeIndex];
1784 
1785     // Add new type to the list
1786     uint256 newTypeEditionIndex = editionTypeToEditionNumber[_editionType].length;
1787     editionTypeToEditionNumber[_editionType].push(_editionNumber);
1788     editionNumberToTypeIndex[_editionNumber] = newTypeEditionIndex;
1789 
1790     // Update the edition
1791     _originalEditionDetails.editionType = _editionType;
1792   }
1793 
1794   function updateActive(uint256 _editionNumber, bool _active)
1795   external
1796   onlyIfKnownOrigin
1797   onlyRealEdition(_editionNumber) {
1798     editionNumberToEditionDetails[_editionNumber].active = _active;
1799   }
1800 
1801   function updateTotalSupply(uint256 _editionNumber, uint256 _totalSupply)
1802   public
1803   onlyIfKnownOrigin
1804   onlyRealEdition(_editionNumber) {
1805     require(tokensOfEdition(_editionNumber).length <= _totalSupply, "Can not lower totalSupply to below the number of tokens already in existence");
1806     editionNumberToEditionDetails[_editionNumber].totalSupply = _totalSupply;
1807   }
1808 
1809   function updateTotalAvailable(uint256 _editionNumber, uint256 _totalAvailable)
1810   external
1811   onlyIfKnownOrigin
1812   onlyRealEdition(_editionNumber) {
1813     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
1814 
1815     require(_editionDetails.totalSupply <= _totalAvailable, "Unable to reduce available amount to the below the number totalSupply");
1816 
1817     uint256 originalAvailability = _editionDetails.totalAvailable;
1818     _editionDetails.totalAvailable = _totalAvailable;
1819     totalNumberAvailable = totalNumberAvailable.sub(originalAvailability).add(_totalAvailable);
1820   }
1821 
1822   function updateStartDate(uint256 _editionNumber, uint256 _startDate)
1823   external
1824   onlyIfKnownOrigin
1825   onlyRealEdition(_editionNumber) {
1826     editionNumberToEditionDetails[_editionNumber].startDate = _startDate;
1827   }
1828 
1829   function updateEndDate(uint256 _editionNumber, uint256 _endDate)
1830   external
1831   onlyIfKnownOrigin
1832   onlyRealEdition(_editionNumber) {
1833     editionNumberToEditionDetails[_editionNumber].endDate = _endDate;
1834   }
1835 
1836   function updateOptionalCommission(uint256 _editionNumber, uint256 _rate, address _recipient)
1837   external
1838   onlyIfKnownOrigin
1839   onlyRealEdition(_editionNumber) {
1840     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
1841     uint256 artistCommission = _editionDetails.artistCommission;
1842 
1843     if (_rate > 0) {
1844       require(_recipient != address(0), "Setting a rate must be accompanied by a valid address");
1845     }
1846     require(artistCommission.add(_rate) <= 100, "Cant set commission greater than 100%");
1847 
1848     editionNumberToOptionalCommissionSplit[_editionNumber] = CommissionSplit({rate : _rate, recipient : _recipient});
1849   }
1850 
1851   ///////////////////
1852   // Token Updates //
1853   ///////////////////
1854 
1855   function setTokenURI(uint256 _tokenId, string _uri)
1856   external
1857   onlyIfKnownOrigin
1858   onlyValidTokenId(_tokenId) {
1859     _setTokenURI(_tokenId, _uri);
1860   }
1861 
1862   ///////////////////
1863   // Query Methods //
1864   ///////////////////
1865 
1866   /**
1867    * @dev Lookup the edition of the provided token ID
1868    * @dev Returns 0 if not valid
1869    */
1870   function editionOfTokenId(uint256 _tokenId) public view returns (uint256 _editionNumber) {
1871     return tokenIdToEditionNumber[_tokenId];
1872   }
1873 
1874   /**
1875    * @dev Lookup all editions added for the given edition type
1876    * @dev Returns array of edition numbers, any zero edition ids can be ignore/stripped
1877    */
1878   function editionsOfType(uint256 _type) public view returns (uint256[] _editionNumbers) {
1879     return editionTypeToEditionNumber[_type];
1880   }
1881 
1882   /**
1883    * @dev Lookup all editions for the given artist account
1884    * @dev Returns empty list if not valid
1885    */
1886   function artistsEditions(address _artistsAccount) public view returns (uint256[] _editionNumbers) {
1887     return artistToEditionNumbers[_artistsAccount];
1888   }
1889 
1890   /**
1891    * @dev Lookup all tokens minted for the given edition number
1892    * @dev Returns array of token IDs, any zero edition ids can be ignore/stripped
1893    */
1894   function tokensOfEdition(uint256 _editionNumber) public view returns (uint256[] _tokenIds) {
1895     return editionNumberToTokenIds[_editionNumber];
1896   }
1897 
1898   /**
1899    * @dev Lookup all owned tokens for the provided address
1900    * @dev Returns array of token IDs
1901    */
1902   function tokensOf(address _owner) public view returns (uint256[] _tokenIds) {
1903     return ownedTokens[_owner];
1904   }
1905 
1906   /**
1907    * @dev Checks to see if the edition exists, assumes edition of zero is invalid
1908    */
1909   function editionExists(uint256 _editionNumber) public view returns (bool) {
1910     if (_editionNumber == 0) {
1911       return false;
1912     }
1913     EditionDetails storage editionNumber = editionNumberToEditionDetails[_editionNumber];
1914     return editionNumber.editionNumber == _editionNumber;
1915   }
1916 
1917   /**
1918    * @dev Lookup any optional commission split set for the edition
1919    * @dev Both values will be zero if not present
1920    */
1921   function editionOptionalCommission(uint256 _editionNumber) public view returns (uint256 _rate, address _recipient) {
1922     CommissionSplit storage commission = editionNumberToOptionalCommissionSplit[_editionNumber];
1923     return (commission.rate, commission.recipient);
1924   }
1925 
1926   /**
1927    * @dev Main entry point for looking up edition config/metadata
1928    * @dev Reverts if invalid edition number provided
1929    */
1930   function detailsOfEdition(uint256 editionNumber)
1931   public view
1932   onlyRealEdition(editionNumber)
1933   returns (
1934     bytes32 _editionData,
1935     uint256 _editionType,
1936     uint256 _startDate,
1937     uint256 _endDate,
1938     address _artistAccount,
1939     uint256 _artistCommission,
1940     uint256 _priceInWei,
1941     string _tokenURI,
1942     uint256 _totalSupply,
1943     uint256 _totalAvailable,
1944     bool _active
1945   ) {
1946     EditionDetails storage _editionDetails = editionNumberToEditionDetails[editionNumber];
1947     return (
1948     _editionDetails.editionData,
1949     _editionDetails.editionType,
1950     _editionDetails.startDate,
1951     _editionDetails.endDate,
1952     _editionDetails.artistAccount,
1953     _editionDetails.artistCommission,
1954     _editionDetails.priceInWei,
1955     Strings.strConcat(tokenBaseURI, _editionDetails.tokenURI),
1956     _editionDetails.totalSupply,
1957     _editionDetails.totalAvailable,
1958     _editionDetails.active
1959     );
1960   }
1961 
1962   /**
1963    * @dev Lookup a tokens common identifying characteristics
1964    * @dev Reverts if invalid token ID provided
1965    */
1966   function tokenData(uint256 _tokenId)
1967   public view
1968   onlyValidTokenId(_tokenId)
1969   returns (
1970     uint256 _editionNumber,
1971     uint256 _editionType,
1972     bytes32 _editionData,
1973     string _tokenURI,
1974     address _owner
1975   ) {
1976     uint256 editionNumber = tokenIdToEditionNumber[_tokenId];
1977     EditionDetails storage editionDetails = editionNumberToEditionDetails[editionNumber];
1978     return (
1979     editionNumber,
1980     editionDetails.editionType,
1981     editionDetails.editionData,
1982     tokenURI(_tokenId),
1983     ownerOf(_tokenId)
1984     );
1985   }
1986 
1987   function tokenURI(uint256 _tokenId) public view onlyValidTokenId(_tokenId) returns (string) {
1988     return Strings.strConcat(tokenBaseURI, tokenURIs[_tokenId]);
1989   }
1990 
1991   function tokenURISafe(uint256 _tokenId) public view returns (string) {
1992     return Strings.strConcat(tokenBaseURI, tokenURIs[_tokenId]);
1993   }
1994 
1995   function purchaseDatesToken(uint256 _tokenId) public view returns (uint256 _startDate, uint256 _endDate) {
1996     uint256 _editionNumber = tokenIdToEditionNumber[_tokenId];
1997     return purchaseDatesEdition(_editionNumber);
1998   }
1999 
2000   function priceInWeiToken(uint256 _tokenId) public view returns (uint256 _priceInWei) {
2001     uint256 _editionNumber = tokenIdToEditionNumber[_tokenId];
2002     return priceInWeiEdition(_editionNumber);
2003   }
2004 
2005   //////////////////////////
2006   // Edition config query //
2007   //////////////////////////
2008 
2009   function editionData(uint256 _editionNumber) public view returns (bytes32) {
2010     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2011     return _editionDetails.editionData;
2012   }
2013 
2014   function editionType(uint256 _editionNumber) public view returns (uint256) {
2015     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2016     return _editionDetails.editionType;
2017   }
2018 
2019   function purchaseDatesEdition(uint256 _editionNumber) public view returns (uint256 _startDate, uint256 _endDate) {
2020     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2021     return (
2022     _editionDetails.startDate,
2023     _editionDetails.endDate
2024     );
2025   }
2026 
2027   function artistCommission(uint256 _editionNumber) public view returns (address _artistAccount, uint256 _artistCommission) {
2028     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2029     return (
2030     _editionDetails.artistAccount,
2031     _editionDetails.artistCommission
2032     );
2033   }
2034 
2035   function priceInWeiEdition(uint256 _editionNumber) public view returns (uint256 _priceInWei) {
2036     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2037     return _editionDetails.priceInWei;
2038   }
2039 
2040   function tokenURIEdition(uint256 _editionNumber) public view returns (string) {
2041     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2042     return Strings.strConcat(tokenBaseURI, _editionDetails.tokenURI);
2043   }
2044 
2045   function editionActive(uint256 _editionNumber) public view returns (bool) {
2046     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2047     return _editionDetails.active;
2048   }
2049 
2050   function totalRemaining(uint256 _editionNumber) public view returns (uint256) {
2051     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2052     return _editionDetails.totalAvailable.sub(_editionDetails.totalSupply);
2053   }
2054 
2055   function totalAvailableEdition(uint256 _editionNumber) public view returns (uint256) {
2056     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2057     return _editionDetails.totalAvailable;
2058   }
2059 
2060   function totalSupplyEdition(uint256 _editionNumber) public view returns (uint256) {
2061     EditionDetails storage _editionDetails = editionNumberToEditionDetails[_editionNumber];
2062     return _editionDetails.totalSupply;
2063   }
2064 
2065 }