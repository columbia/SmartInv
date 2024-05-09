1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol
4 
5 /**
6  * @title Roles
7  * @author Francisco Giordano (@frangio)
8  * @dev Library for managing addresses assigned to a Role.
9  *      See RBAC.sol for example usage.
10  */
11 library Roles {
12   struct Role {
13     mapping (address => bool) bearer;
14   }
15 
16   /**
17    * @dev give an address access to this role
18    */
19   function add(Role storage role, address addr)
20     internal
21   {
22     role.bearer[addr] = true;
23   }
24 
25   /**
26    * @dev remove an address' access to this role
27    */
28   function remove(Role storage role, address addr)
29     internal
30   {
31     role.bearer[addr] = false;
32   }
33 
34   /**
35    * @dev check if an address has this role
36    * // reverts
37    */
38   function check(Role storage role, address addr)
39     view
40     internal
41   {
42     require(has(role, addr));
43   }
44 
45   /**
46    * @dev check if an address has this role
47    * @return bool
48    */
49   function has(Role storage role, address addr)
50     view
51     internal
52     returns (bool)
53   {
54     return role.bearer[addr];
55   }
56 }
57 
58 // File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol
59 
60 /**
61  * @title RBAC (Role-Based Access Control)
62  * @author Matt Condon (@Shrugs)
63  * @dev Stores and provides setters and getters for roles and addresses.
64  *      Supports unlimited numbers of roles and addresses.
65  *      See //contracts/mocks/RBACMock.sol for an example of usage.
66  * This RBAC method uses strings to key roles. It may be beneficial
67  *  for you to write your own implementation of this interface using Enums or similar.
68  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
69  *  to avoid typos.
70  */
71 contract RBAC {
72   using Roles for Roles.Role;
73 
74   mapping (string => Roles.Role) private roles;
75 
76   event RoleAdded(address addr, string roleName);
77   event RoleRemoved(address addr, string roleName);
78 
79   /**
80    * A constant role name for indicating admins.
81    */
82   string public constant ROLE_ADMIN = "admin";
83 
84   /**
85    * @dev constructor. Sets msg.sender as admin by default
86    */
87   function RBAC()
88     public
89   {
90     addRole(msg.sender, ROLE_ADMIN);
91   }
92 
93   /**
94    * @dev reverts if addr does not have role
95    * @param addr address
96    * @param roleName the name of the role
97    * // reverts
98    */
99   function checkRole(address addr, string roleName)
100     view
101     public
102   {
103     roles[roleName].check(addr);
104   }
105 
106   /**
107    * @dev determine if addr has role
108    * @param addr address
109    * @param roleName the name of the role
110    * @return bool
111    */
112   function hasRole(address addr, string roleName)
113     view
114     public
115     returns (bool)
116   {
117     return roles[roleName].has(addr);
118   }
119 
120   /**
121    * @dev add a role to an address
122    * @param addr address
123    * @param roleName the name of the role
124    */
125   function adminAddRole(address addr, string roleName)
126     onlyAdmin
127     public
128   {
129     addRole(addr, roleName);
130   }
131 
132   /**
133    * @dev remove a role from an address
134    * @param addr address
135    * @param roleName the name of the role
136    */
137   function adminRemoveRole(address addr, string roleName)
138     onlyAdmin
139     public
140   {
141     removeRole(addr, roleName);
142   }
143 
144   /**
145    * @dev add a role to an address
146    * @param addr address
147    * @param roleName the name of the role
148    */
149   function addRole(address addr, string roleName)
150     internal
151   {
152     roles[roleName].add(addr);
153     RoleAdded(addr, roleName);
154   }
155 
156   /**
157    * @dev remove a role from an address
158    * @param addr address
159    * @param roleName the name of the role
160    */
161   function removeRole(address addr, string roleName)
162     internal
163   {
164     roles[roleName].remove(addr);
165     RoleRemoved(addr, roleName);
166   }
167 
168   /**
169    * @dev modifier to scope access to a single role (uses msg.sender as addr)
170    * @param roleName the name of the role
171    * // reverts
172    */
173   modifier onlyRole(string roleName)
174   {
175     checkRole(msg.sender, roleName);
176     _;
177   }
178 
179   /**
180    * @dev modifier to scope access to admins
181    * // reverts
182    */
183   modifier onlyAdmin()
184   {
185     checkRole(msg.sender, ROLE_ADMIN);
186     _;
187   }
188 
189   /**
190    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
191    * @param roleNames the names of the roles to scope access to
192    * // reverts
193    *
194    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
195    *  see: https://github.com/ethereum/solidity/issues/2467
196    */
197   // modifier onlyRoles(string[] roleNames) {
198   //     bool hasAnyRole = false;
199   //     for (uint8 i = 0; i < roleNames.length; i++) {
200   //         if (hasRole(msg.sender, roleNames[i])) {
201   //             hasAnyRole = true;
202   //             break;
203   //         }
204   //     }
205 
206   //     require(hasAnyRole);
207 
208   //     _;
209   // }
210 }
211 
212 // File: contracts/ButtonClickRBAC.sol
213 
214 /*
215  * @title Manages administrative roles for specific ethereum addresses
216  */
217 contract ButtonClickRBAC is RBAC {
218 
219     string constant ROLE_FINANCE = "finance";
220 
221     /**
222      * @dev Access modifier, which restricts functions to only the "finance" role
223      */
224     modifier onlyFinance() {
225         checkRole(msg.sender, ROLE_FINANCE);
226         _;
227     }
228 
229 }
230 
231 // File: contracts/ButtonClickGameControls.sol
232 
233 /*
234  * @title Defines specific controls for game administrators
235  */
236 contract ButtonClickGameControls is ButtonClickRBAC {
237 
238     /**
239      * Monitors if the game has been started
240      */
241     bool public started = false;
242 
243     /**
244      * In order to reduce the likelihood of someone spamming the button click continually with
245      * multiple ether addresses, which would effectively prevent the button from ever decrementing, 
246      * we have introduced the concept of a minimum fee required to click the button. 
247      */
248     uint256 public minimumFee;
249 
250     /**
251      * Defines how many blocks must elapse before the game can be "won"
252      *
253      * http://solidity.readthedocs.io/en/develop/contracts.html?#visibility-and-getters
254      */
255     uint256 public requiredBlocksElapsedForVictory;
256 
257     /**
258      * @dev Access modifier, which restricts a call to happen once the game is started
259      */
260     modifier isStarted() {
261         require(started);
262         _;
263     }
264 
265     /**
266      * @dev Changes the required number of blocks for victory. This may ONLY be called by the "admin" role
267      */
268     function setRequiredBlocksElapsedForVictory(uint256 _requiredBlocksElapsedForVictory) external onlyAdmin {
269         requiredBlocksElapsedForVictory = _requiredBlocksElapsedForVictory;
270     }
271     
272     /**
273      * @dev Changes the minimum fee. This may ONLY be called by the "finance" role
274      */
275     function setMinimumFee(uint256 _minimumFee) external onlyFinance {
276         minimumFee = _minimumFee;
277     }
278 
279     /**
280      * @dev Withdraws the available balance. This may ONLY be called by the "finance" role
281      */
282     function withdrawBalance() external onlyFinance {
283         msg.sender.transfer(address(this).balance);
284     }
285     
286 }
287 
288 // File: zeppelin-solidity/contracts/math/Math.sol
289 
290 /**
291  * @title Math
292  * @dev Assorted math operations
293  */
294 library Math {
295   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
296     return a >= b ? a : b;
297   }
298 
299   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
300     return a < b ? a : b;
301   }
302 
303   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
304     return a >= b ? a : b;
305   }
306 
307   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
308     return a < b ? a : b;
309   }
310 }
311 
312 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
313 
314 /**
315  * @title ERC721 Non-Fungible Token Standard basic interface
316  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
317  */
318 contract ERC721Basic {
319   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
320   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
321   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
322 
323   function balanceOf(address _owner) public view returns (uint256 _balance);
324   function ownerOf(uint256 _tokenId) public view returns (address _owner);
325   function exists(uint256 _tokenId) public view returns (bool _exists);
326   
327   function approve(address _to, uint256 _tokenId) public;
328   function getApproved(uint256 _tokenId) public view returns (address _operator);
329   
330   function setApprovalForAll(address _operator, bool _approved) public;
331   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
332 
333   function transferFrom(address _from, address _to, uint256 _tokenId) public;
334   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
335   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
336 }
337 
338 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
339 
340 /**
341  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
342  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
343  */
344 contract ERC721Enumerable is ERC721Basic {
345   function totalSupply() public view returns (uint256);
346   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
347   function tokenByIndex(uint256 _index) public view returns (uint256);
348 }
349 
350 /**
351  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
352  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
353  */
354 contract ERC721Metadata is ERC721Basic {
355   function name() public view returns (string _name);
356   function symbol() public view returns (string _symbol);
357   function tokenURI(uint256 _tokenId) public view returns (string);
358 }
359 
360 /**
361  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
362  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
363  */
364 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
365 }
366 
367 // File: zeppelin-solidity/contracts/token/ERC721/DeprecatedERC721.sol
368 
369 /**
370  * @title ERC-721 methods shipped in OpenZeppelin v1.7.0, removed in the latest version of the standard
371  * @dev Only use this interface for compatibility with previously deployed contracts
372  * @dev Use ERC721 for interacting with new contracts which are standard-compliant
373  */
374 contract DeprecatedERC721 is ERC721 {
375   function takeOwnership(uint256 _tokenId) public;
376   function transfer(address _to, uint256 _tokenId) public;
377   function tokensOf(address _owner) public view returns (uint256[]);
378 }
379 
380 // File: zeppelin-solidity/contracts/AddressUtils.sol
381 
382 /**
383  * Utility library of inline functions on addresses
384  */
385 library AddressUtils {
386 
387   /**
388    * Returns whether there is code in the target address
389    * @dev This function will return false if invoked during the constructor of a contract,
390    *  as the code is not actually created until after the constructor finishes.
391    * @param addr address address to check
392    * @return whether there is code in the target address
393    */
394   function isContract(address addr) internal view returns (bool) {
395     uint256 size;
396     assembly { size := extcodesize(addr) }
397     return size > 0;
398   }
399 
400 }
401 
402 // File: zeppelin-solidity/contracts/math/SafeMath.sol
403 
404 /**
405  * @title SafeMath
406  * @dev Math operations with safety checks that throw on error
407  */
408 library SafeMath {
409 
410   /**
411   * @dev Multiplies two numbers, throws on overflow.
412   */
413   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
414     if (a == 0) {
415       return 0;
416     }
417     uint256 c = a * b;
418     assert(c / a == b);
419     return c;
420   }
421 
422   /**
423   * @dev Integer division of two numbers, truncating the quotient.
424   */
425   function div(uint256 a, uint256 b) internal pure returns (uint256) {
426     // assert(b > 0); // Solidity automatically throws when dividing by 0
427     uint256 c = a / b;
428     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
429     return c;
430   }
431 
432   /**
433   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
434   */
435   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
436     assert(b <= a);
437     return a - b;
438   }
439 
440   /**
441   * @dev Adds two numbers, throws on overflow.
442   */
443   function add(uint256 a, uint256 b) internal pure returns (uint256) {
444     uint256 c = a + b;
445     assert(c >= a);
446     return c;
447   }
448 }
449 
450 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
451 
452 /**
453  * @title ERC721 token receiver interface
454  * @dev Interface for any contract that wants to support safeTransfers
455  *  from ERC721 asset contracts.
456  */
457 contract ERC721Receiver {
458   /**
459    * @dev Magic value to be returned upon successful reception of an NFT
460    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
461    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
462    */
463   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
464 
465   /**
466    * @notice Handle the receipt of an NFT
467    * @dev The ERC721 smart contract calls this function on the recipient
468    *  after a `safetransfer`. This function MAY throw to revert and reject the
469    *  transfer. This function MUST use 50,000 gas or less. Return of other
470    *  than the magic value MUST result in the transaction being reverted.
471    *  Note: the contract address is always the message sender.
472    * @param _from The sending address 
473    * @param _tokenId The NFT identifier which is being transfered
474    * @param _data Additional data with no specified format
475    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
476    */
477   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
478 }
479 
480 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
481 
482 /**
483  * @title ERC721 Non-Fungible Token Standard basic implementation
484  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
485  */
486 contract ERC721BasicToken is ERC721Basic {
487   using SafeMath for uint256;
488   using AddressUtils for address;
489   
490   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
491   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
492   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
493 
494   // Mapping from token ID to owner
495   mapping (uint256 => address) internal tokenOwner;
496 
497   // Mapping from token ID to approved address
498   mapping (uint256 => address) internal tokenApprovals;
499 
500   // Mapping from owner to number of owned token
501   mapping (address => uint256) internal ownedTokensCount;
502 
503   // Mapping from owner to operator approvals
504   mapping (address => mapping (address => bool)) internal operatorApprovals;
505 
506   /**
507   * @dev Guarantees msg.sender is owner of the given token
508   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
509   */
510   modifier onlyOwnerOf(uint256 _tokenId) {
511     require(ownerOf(_tokenId) == msg.sender);
512     _;
513   }
514 
515   /**
516   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
517   * @param _tokenId uint256 ID of the token to validate
518   */
519   modifier canTransfer(uint256 _tokenId) {
520     require(isApprovedOrOwner(msg.sender, _tokenId));
521     _;
522   }
523 
524   /**
525   * @dev Gets the balance of the specified address
526   * @param _owner address to query the balance of
527   * @return uint256 representing the amount owned by the passed address
528   */
529   function balanceOf(address _owner) public view returns (uint256) {
530     require(_owner != address(0));
531     return ownedTokensCount[_owner];
532   }
533 
534   /**
535   * @dev Gets the owner of the specified token ID
536   * @param _tokenId uint256 ID of the token to query the owner of
537   * @return owner address currently marked as the owner of the given token ID
538   */
539   function ownerOf(uint256 _tokenId) public view returns (address) {
540     address owner = tokenOwner[_tokenId];
541     require(owner != address(0));
542     return owner;
543   }
544 
545   /**
546   * @dev Returns whether the specified token exists
547   * @param _tokenId uint256 ID of the token to query the existance of
548   * @return whether the token exists
549   */
550   function exists(uint256 _tokenId) public view returns (bool) {
551     address owner = tokenOwner[_tokenId];
552     return owner != address(0);
553   }
554 
555   /**
556   * @dev Approves another address to transfer the given token ID
557   * @dev The zero address indicates there is no approved address.
558   * @dev There can only be one approved address per token at a given time.
559   * @dev Can only be called by the token owner or an approved operator.
560   * @param _to address to be approved for the given token ID
561   * @param _tokenId uint256 ID of the token to be approved
562   */
563   function approve(address _to, uint256 _tokenId) public {
564     address owner = ownerOf(_tokenId);
565     require(_to != owner);
566     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
567 
568     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
569       tokenApprovals[_tokenId] = _to;
570       Approval(owner, _to, _tokenId);
571     }
572   }
573 
574   /**
575    * @dev Gets the approved address for a token ID, or zero if no address set
576    * @param _tokenId uint256 ID of the token to query the approval of
577    * @return address currently approved for a the given token ID
578    */
579   function getApproved(uint256 _tokenId) public view returns (address) {
580     return tokenApprovals[_tokenId];
581   }
582 
583 
584   /**
585   * @dev Sets or unsets the approval of a given operator
586   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
587   * @param _to operator address to set the approval
588   * @param _approved representing the status of the approval to be set
589   */
590   function setApprovalForAll(address _to, bool _approved) public {
591     require(_to != msg.sender);
592     operatorApprovals[msg.sender][_to] = _approved;
593     ApprovalForAll(msg.sender, _to, _approved);
594   }
595 
596   /**
597    * @dev Tells whether an operator is approved by a given owner
598    * @param _owner owner address which you want to query the approval of
599    * @param _operator operator address which you want to query the approval of
600    * @return bool whether the given operator is approved by the given owner
601    */
602   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
603     return operatorApprovals[_owner][_operator];
604   }
605 
606   /**
607   * @dev Transfers the ownership of a given token ID to another address
608   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
609   * @dev Requires the msg sender to be the owner, approved, or operator
610   * @param _from current owner of the token
611   * @param _to address to receive the ownership of the given token ID
612   * @param _tokenId uint256 ID of the token to be transferred
613   */
614   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
615     require(_from != address(0));
616     require(_to != address(0));
617 
618     clearApproval(_from, _tokenId);
619     removeTokenFrom(_from, _tokenId);
620     addTokenTo(_to, _tokenId);
621     
622     Transfer(_from, _to, _tokenId);
623   }
624 
625   /**
626   * @dev Safely transfers the ownership of a given token ID to another address
627   * @dev If the target address is a contract, it must implement `onERC721Received`,
628   *  which is called upon a safe transfer, and return the magic value
629   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
630   *  the transfer is reverted.
631   * @dev Requires the msg sender to be the owner, approved, or operator
632   * @param _from current owner of the token
633   * @param _to address to receive the ownership of the given token ID
634   * @param _tokenId uint256 ID of the token to be transferred
635   */
636   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
637     safeTransferFrom(_from, _to, _tokenId, "");
638   }
639 
640   /**
641   * @dev Safely transfers the ownership of a given token ID to another address
642   * @dev If the target address is a contract, it must implement `onERC721Received`,
643   *  which is called upon a safe transfer, and return the magic value
644   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
645   *  the transfer is reverted.
646   * @dev Requires the msg sender to be the owner, approved, or operator
647   * @param _from current owner of the token
648   * @param _to address to receive the ownership of the given token ID
649   * @param _tokenId uint256 ID of the token to be transferred
650   * @param _data bytes data to send along with a safe transfer check
651   */
652   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
653     transferFrom(_from, _to, _tokenId);
654     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
655   }
656 
657   /**
658    * @dev Returns whether the given spender can transfer a given token ID
659    * @param _spender address of the spender to query
660    * @param _tokenId uint256 ID of the token to be transferred
661    * @return bool whether the msg.sender is approved for the given token ID,
662    *  is an operator of the owner, or is the owner of the token
663    */
664   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
665     address owner = ownerOf(_tokenId);
666     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
667   }
668 
669   /**
670   * @dev Internal function to mint a new token
671   * @dev Reverts if the given token ID already exists
672   * @param _to The address that will own the minted token
673   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
674   */
675   function _mint(address _to, uint256 _tokenId) internal {
676     require(_to != address(0));
677     addTokenTo(_to, _tokenId);
678     Transfer(address(0), _to, _tokenId);
679   }
680 
681   /**
682   * @dev Internal function to burn a specific token
683   * @dev Reverts if the token does not exist
684   * @param _tokenId uint256 ID of the token being burned by the msg.sender
685   */
686   function _burn(address _owner, uint256 _tokenId) internal {
687     clearApproval(_owner, _tokenId);
688     removeTokenFrom(_owner, _tokenId);
689     Transfer(_owner, address(0), _tokenId);
690   }
691 
692   /**
693   * @dev Internal function to clear current approval of a given token ID
694   * @dev Reverts if the given address is not indeed the owner of the token
695   * @param _owner owner of the token
696   * @param _tokenId uint256 ID of the token to be transferred
697   */
698   function clearApproval(address _owner, uint256 _tokenId) internal {
699     require(ownerOf(_tokenId) == _owner);
700     if (tokenApprovals[_tokenId] != address(0)) {
701       tokenApprovals[_tokenId] = address(0);
702       Approval(_owner, address(0), _tokenId);
703     }
704   }
705 
706   /**
707   * @dev Internal function to add a token ID to the list of a given address
708   * @param _to address representing the new owner of the given token ID
709   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
710   */
711   function addTokenTo(address _to, uint256 _tokenId) internal {
712     require(tokenOwner[_tokenId] == address(0));
713     tokenOwner[_tokenId] = _to;
714     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
715   }
716 
717   /**
718   * @dev Internal function to remove a token ID from the list of a given address
719   * @param _from address representing the previous owner of the given token ID
720   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
721   */
722   function removeTokenFrom(address _from, uint256 _tokenId) internal {
723     require(ownerOf(_tokenId) == _from);
724     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
725     tokenOwner[_tokenId] = address(0);
726   }
727 
728   /**
729   * @dev Internal function to invoke `onERC721Received` on a target address
730   * @dev The call is not executed if the target address is not a contract
731   * @param _from address representing the previous owner of the given token ID
732   * @param _to target address that will receive the tokens
733   * @param _tokenId uint256 ID of the token to be transferred
734   * @param _data bytes optional data to send along with the call
735   * @return whether the call correctly returned the expected magic value
736   */
737   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
738     if (!_to.isContract()) {
739       return true;
740     }
741     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
742     return (retval == ERC721_RECEIVED);
743   }
744 }
745 
746 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
747 
748 /**
749  * @title Full ERC721 Token
750  * This implementation includes all the required and some optional functionality of the ERC721 standard
751  * Moreover, it includes approve all functionality using operator terminology
752  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
753  */
754 contract ERC721Token is ERC721, ERC721BasicToken {
755   // Token name
756   string internal name_;
757 
758   // Token symbol
759   string internal symbol_;
760 
761   // Mapping from owner to list of owned token IDs
762   mapping (address => uint256[]) internal ownedTokens;
763 
764   // Mapping from token ID to index of the owner tokens list
765   mapping(uint256 => uint256) internal ownedTokensIndex;
766 
767   // Array with all token ids, used for enumeration
768   uint256[] internal allTokens;
769 
770   // Mapping from token id to position in the allTokens array
771   mapping(uint256 => uint256) internal allTokensIndex;
772 
773   // Optional mapping for token URIs 
774   mapping(uint256 => string) internal tokenURIs;
775 
776   /**
777   * @dev Constructor function
778   */
779   function ERC721Token(string _name, string _symbol) public {
780     name_ = _name;
781     symbol_ = _symbol;
782   }
783 
784   /**
785   * @dev Gets the token name
786   * @return string representing the token name
787   */
788   function name() public view returns (string) {
789     return name_;
790   }
791 
792   /**
793   * @dev Gets the token symbol
794   * @return string representing the token symbol
795   */
796   function symbol() public view returns (string) {
797     return symbol_;
798   }
799 
800   /**
801   * @dev Returns an URI for a given token ID
802   * @dev Throws if the token ID does not exist. May return an empty string.
803   * @param _tokenId uint256 ID of the token to query
804   */
805   function tokenURI(uint256 _tokenId) public view returns (string) {
806     require(exists(_tokenId));
807     return tokenURIs[_tokenId];
808   }
809 
810   /**
811   * @dev Internal function to set the token URI for a given token
812   * @dev Reverts if the token ID does not exist
813   * @param _tokenId uint256 ID of the token to set its URI
814   * @param _uri string URI to assign
815   */
816   function _setTokenURI(uint256 _tokenId, string _uri) internal {
817     require(exists(_tokenId));
818     tokenURIs[_tokenId] = _uri;
819   }
820 
821   /**
822   * @dev Gets the token ID at a given index of the tokens list of the requested owner
823   * @param _owner address owning the tokens list to be accessed
824   * @param _index uint256 representing the index to be accessed of the requested tokens list
825   * @return uint256 token ID at the given index of the tokens list owned by the requested address
826   */
827   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
828     require(_index < balanceOf(_owner));
829     return ownedTokens[_owner][_index];
830   }
831 
832   /**
833   * @dev Gets the total amount of tokens stored by the contract
834   * @return uint256 representing the total amount of tokens
835   */
836   function totalSupply() public view returns (uint256) {
837     return allTokens.length;
838   }
839 
840   /**
841   * @dev Gets the token ID at a given index of all the tokens in this contract
842   * @dev Reverts if the index is greater or equal to the total number of tokens
843   * @param _index uint256 representing the index to be accessed of the tokens list
844   * @return uint256 token ID at the given index of the tokens list
845   */
846   function tokenByIndex(uint256 _index) public view returns (uint256) {
847     require(_index < totalSupply());
848     return allTokens[_index];
849   }
850 
851   /**
852   * @dev Internal function to add a token ID to the list of a given address
853   * @param _to address representing the new owner of the given token ID
854   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
855   */
856   function addTokenTo(address _to, uint256 _tokenId) internal {
857     super.addTokenTo(_to, _tokenId);
858     uint256 length = ownedTokens[_to].length;
859     ownedTokens[_to].push(_tokenId);
860     ownedTokensIndex[_tokenId] = length;
861   }
862 
863   /**
864   * @dev Internal function to remove a token ID from the list of a given address
865   * @param _from address representing the previous owner of the given token ID
866   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
867   */
868   function removeTokenFrom(address _from, uint256 _tokenId) internal {
869     super.removeTokenFrom(_from, _tokenId);
870 
871     uint256 tokenIndex = ownedTokensIndex[_tokenId];
872     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
873     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
874 
875     ownedTokens[_from][tokenIndex] = lastToken;
876     ownedTokens[_from][lastTokenIndex] = 0;
877     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
878     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
879     // the lastToken to the first position, and then dropping the element placed in the last position of the list
880 
881     ownedTokens[_from].length--;
882     ownedTokensIndex[_tokenId] = 0;
883     ownedTokensIndex[lastToken] = tokenIndex;
884   }
885 
886   /**
887   * @dev Internal function to mint a new token
888   * @dev Reverts if the given token ID already exists
889   * @param _to address the beneficiary that will own the minted token
890   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
891   */
892   function _mint(address _to, uint256 _tokenId) internal {
893     super._mint(_to, _tokenId);
894     
895     allTokensIndex[_tokenId] = allTokens.length;
896     allTokens.push(_tokenId);
897   }
898 
899   /**
900   * @dev Internal function to burn a specific token
901   * @dev Reverts if the token does not exist
902   * @param _owner owner of the token to burn
903   * @param _tokenId uint256 ID of the token being burned by the msg.sender
904   */
905   function _burn(address _owner, uint256 _tokenId) internal {
906     super._burn(_owner, _tokenId);
907 
908     // Clear metadata (if any)
909     if (bytes(tokenURIs[_tokenId]).length != 0) {
910       delete tokenURIs[_tokenId];
911     }
912 
913     // Reorg all tokens array
914     uint256 tokenIndex = allTokensIndex[_tokenId];
915     uint256 lastTokenIndex = allTokens.length.sub(1);
916     uint256 lastToken = allTokens[lastTokenIndex];
917 
918     allTokens[tokenIndex] = lastToken;
919     allTokens[lastTokenIndex] = 0;
920 
921     allTokens.length--;
922     allTokensIndex[_tokenId] = 0;
923     allTokensIndex[lastToken] = tokenIndex;
924   }
925 
926 }
927 
928 // File: contracts/ButtonClickGame.sol
929 
930 contract ButtonClickGame is ERC721Token("The Ether Button", "Butt"), ButtonClickGameControls {
931 
932     /**
933      * @dev This event is fired whenever a user clicks on a button, thereby creating a click
934      * and resetting our block timer
935      */
936     event ButtonClick(address indexed owner, uint256 tokenId);
937 
938     /**
939      * Defines the main struct for button clicks, which contains all relevant metadata about
940      * the click action.
941      *
942      * Please ensure that alterations to this struct respect the byte-packing rules:
943      * http://solidity.readthedocs.io/en/develop/miscellaneous.html
944      */
945     struct ButtonClickMetadata {
946         // Tracks how far the user was away from the desired block (0 is optimal)
947         uint64 blocksAwayFromDesiredBlock;
948 
949         // Defines the "generation" of this game. This gets incremented whenever the button is clicked
950         // at the desired block
951         uint64 clickGeneration;
952 
953         // The timestamp from the block when this click occurred
954         uint64 clickTime;
955     }
956 
957     /**
958      * An array which contains a complete list of of ButtonClickMetadata, each of which
959      * represents a unique time in which the button was clicked. The ID of each click
960      * event is an index into this array
961      */
962     ButtonClickMetadata[] clicks;
963 
964     /**
965      * Defines the current game generation. Users can play again whenever this increments.
966      * Note: This always starts with generation 1
967      *
968      * http://solidity.readthedocs.io/en/develop/contracts.html?#visibility-and-getters
969      */
970     uint256 public gameGeneration = 1;
971 
972     /**
973      * Defines the block number at which a click will "win"
974      *
975      * http://solidity.readthedocs.io/en/develop/contracts.html?#visibility-and-getters
976      */
977     uint256 public blockNumberForVictory;
978 
979     /**
980      * A mapping from a specific address to which generation the user last clicked the button
981      * during. Regardless of whether a user transfers his/her click token, we only allow a 
982      * single button click per game generation
983      */
984     mapping (address => uint256) public addressLastClickedForGeneration;
985 
986     /**
987      * A mapping from the number "remaining blocks" (eg 19 blocks left) to the number of clicks
988      * clicks that occurred at this "remaining blocks" total
989      */
990     mapping (uint8 => uint256) public numberOfClicksAtBlocksRemaining;
991 
992     /**
993      * @dev This method contains the core game logic, tracking a distinct button "click" event and 
994      * saving all relevant metadata associated with it. This method will generate both a ButtonClick 
995      * and Transfer event. Callers can ONLY call this method a single time per game generation.
996      *
997      * @return the id in our array, which is the latest click
998      */
999     function clickButton() external isStarted payable returns (uint256) {
1000         // Avoid spamming the game with a minimum fee
1001         require(msg.value >= minimumFee);
1002 
1003         // Don't allow the game to be played indefinitely
1004         require(gameGeneration <= 65535);
1005 
1006         // Require that the user has never click the button previously this round
1007         require(addressLastClickedForGeneration[msg.sender] < gameGeneration);
1008 
1009         // Immediately bump the user's last button click to this generation
1010         addressLastClickedForGeneration[msg.sender] = gameGeneration;
1011 
1012         // Ensure that 0 is the effective floor for elapsed blocks
1013         // Math.max256 won't work due to integer underflow, which will give a huge number if block.number > blockNumberForVictory
1014         uint256 _blocksAwayFromDesiredBlock;
1015         if (blockNumberForVictory > block.number) {
1016             _blocksAwayFromDesiredBlock = blockNumberForVictory - block.number;
1017         } else {
1018             _blocksAwayFromDesiredBlock = 0;
1019         }
1020 
1021         // Keep the local value before possibly incrementing it in the victory condition
1022         uint256 _generation = gameGeneration;
1023 
1024         // Victory condition!!
1025         if (_blocksAwayFromDesiredBlock == 0) {
1026             gameGeneration++;
1027         }
1028 
1029         // Increment how many clicks have occurred at this number
1030         numberOfClicksAtBlocksRemaining[uint8(_blocksAwayFromDesiredBlock)] += 1;
1031 
1032         // Update the blockNumber that is required for the next victory condition
1033         blockNumberForVictory = block.number + requiredBlocksElapsedForVictory;
1034 
1035         // Create a new click
1036         ButtonClickMetadata memory _click = ButtonClickMetadata({
1037             blocksAwayFromDesiredBlock: uint64(_blocksAwayFromDesiredBlock),
1038             clickGeneration: uint64(_generation),
1039             clickTime: uint64(now)
1040         });
1041         uint256 newClickId = clicks.push(_click) - 1;
1042 
1043         // Emit the click event
1044         emit ButtonClick(msg.sender, newClickId);
1045 
1046         // Formally mint this token and transfer ownership
1047         _mint(msg.sender, newClickId);
1048 
1049         return newClickId;
1050     }
1051 
1052     /**
1053      * Fetches information about a specific click event
1054      * 
1055      * @param _id The ID of a specific button click token
1056      */
1057     function getClickMetadata(uint256 _id) external view returns (
1058         uint256 blocksAwayFromDesiredBlock,
1059         uint256 clickTime,
1060         uint256 clickGeneration,
1061         address owner
1062     ) {
1063         ButtonClickMetadata storage metadata = clicks[_id];
1064 
1065         blocksAwayFromDesiredBlock = uint256(metadata.blocksAwayFromDesiredBlock);
1066         clickTime = uint256(metadata.clickTime);
1067         clickGeneration = uint256(metadata.clickGeneration);
1068         owner = ownerOf(_id);
1069     }
1070 
1071 }
1072 
1073 // File: contracts/ButtonClickGameContract.sol
1074 
1075 contract ButtonClickGameContract is ButtonClickGame {
1076 
1077     /**
1078      * Core constructer, which starts the game contact
1079      */
1080     function ButtonClickGameContract() public {
1081         // The contract creator immediately takes over both Admin and Finance roles
1082         addRole(msg.sender, ROLE_ADMIN);
1083         addRole(msg.sender, ROLE_FINANCE);
1084 
1085         minimumFee = 500000000000000; // 0.0005 ETH (hopefully low enough to not deter users, but high enough to avoid bots)
1086         requiredBlocksElapsedForVictory = 20; // 20 blocks must elapse to win
1087     }    
1088 
1089     /**
1090      * @dev Officially starts the game and configures all initial details
1091      */
1092     function startGame() external onlyAdmin {
1093         require(!started);
1094         started = true;
1095         blockNumberForVictory = block.number + requiredBlocksElapsedForVictory;
1096     }
1097 
1098     /**
1099      * @dev A simple function to allow for deposits into this contract. We use this
1100      * instead of the fallback function to ensure that deposits are intentional 
1101      */
1102     function sendDeposit() external payable {
1103         
1104     }
1105 
1106 }