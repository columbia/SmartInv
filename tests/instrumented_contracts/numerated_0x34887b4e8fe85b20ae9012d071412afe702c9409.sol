1 pragma solidity ^0.4.23;
2 
3 
4 contract Necropolis {
5     function addDragon(address _lastDragonOwner, uint256 _dragonID, uint256 _deathReason) external;
6 }
7 
8 
9 contract GenRNG {
10     function getNewGens(address _from, uint256 _dragonID) external returns (uint256[2] resultGen);
11 }
12 
13 
14 contract DragonSelectFight2Death {
15     function addSelctFight2Death(
16         address _dragonOwner, 
17         uint256 _yourDragonID, 
18         uint256 _oppDragonID, 
19         uint256 _endBlockNumber, 
20         uint256 _priceSelectFight2Death
21     ) 
22         external;
23 }
24 
25 
26 contract DragonsRandomFight2Death {
27     function addRandomFight2Death(address _dragonOwner, uint256 _DragonID) external;
28 }
29 
30 
31 contract FixMarketPlace {
32     function add2MarketPlace(address _dragonOwner, uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external returns (bool);
33 }
34 
35 
36 contract Auction {
37     function add2Auction(
38         address _dragonOwner, 
39         uint256 _dragonID, 
40         uint256 _startPrice, 
41         uint256 _step, 
42         uint256 _endPrice, 
43         uint256 _endBlockNumber
44     ) 
45         external 
46         returns (bool);
47 }
48 
49 
50 contract DragonStats {
51     function setParents(uint256 _dragonID, uint256 _parentOne, uint256 _parentTwo) external;
52     function setBirthBlock(uint256 _dragonID) external;
53     function incChildren(uint256 _dragonID) external;
54     function setDeathBlock(uint256 _dragonID) external;
55     function getDragonFight(uint256 _dragonID) external view returns (uint256);
56 }
57 
58 
59 contract SuperContract {
60     function checkDragon(uint256 _dragonID) external returns (bool);
61 }
62 
63 
64 contract Mutagen2Face {
65     function addDragon(address _dragonOwner, uint256 _dragonID, uint256 mutagenCount) external;
66 }
67 
68 
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75     if (a == 0) {
76       return 0;
77     }
78     uint256 c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers, truncating the quotient.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     // uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return a / b;
91   }
92 
93   /**
94   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95   */
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   /**
102   * @dev Adds two numbers, throws on overflow.
103   */
104   function add(uint256 a, uint256 b) internal pure returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 
112 library AddressUtils {
113 
114   /**
115    * Returns whether the target address is a contract
116    * @dev This function will return false if invoked during the constructor of a contract,
117    *  as the code is not actually created until after the constructor finishes.
118    * @param addr address to check
119    * @return whether the target address is a contract
120    */
121   function isContract(address addr) internal view returns (bool) {
122     uint256 size;
123     // XXX Currently there is no better way to check if there is a contract in an address
124     // than to check the size of the code at that address.
125     // See https://ethereum.stackexchange.com/a/14016/36603
126     // for more details about how this works.
127     // TODO Check this again before the Serenity release, because all addresses will be
128     // contracts then.
129     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
130     return size > 0;
131   }
132 
133 }
134 
135 
136 library Roles {
137   struct Role {
138     mapping (address => bool) bearer;
139   }
140 
141   /**
142    * @dev give an address access to this role
143    */
144   function add(Role storage role, address addr)
145     internal
146   {
147     role.bearer[addr] = true;
148   }
149 
150   /**
151    * @dev remove an address' access to this role
152    */
153   function remove(Role storage role, address addr)
154     internal
155   {
156     role.bearer[addr] = false;
157   }
158 
159   /**
160    * @dev check if an address has this role
161    * // reverts
162    */
163   function check(Role storage role, address addr)
164     view
165     internal
166   {
167     require(has(role, addr));
168   }
169 
170   /**
171    * @dev check if an address has this role
172    * @return bool
173    */
174   function has(Role storage role, address addr)
175     view
176     internal
177     returns (bool)
178   {
179     return role.bearer[addr];
180   }
181 }
182 
183 
184 contract RBAC {
185   using Roles for Roles.Role;
186 
187   mapping (string => Roles.Role) private roles;
188 
189   event RoleAdded(address addr, string roleName);
190   event RoleRemoved(address addr, string roleName);
191 
192   /**
193    * @dev reverts if addr does not have role
194    * @param addr address
195    * @param roleName the name of the role
196    * // reverts
197    */
198   function checkRole(address addr, string roleName)
199     view
200     public
201   {
202     roles[roleName].check(addr);
203   }
204 
205   /**
206    * @dev determine if addr has role
207    * @param addr address
208    * @param roleName the name of the role
209    * @return bool
210    */
211   function hasRole(address addr, string roleName)
212     view
213     public
214     returns (bool)
215   {
216     return roles[roleName].has(addr);
217   }
218 
219   /**
220    * @dev add a role to an address
221    * @param addr address
222    * @param roleName the name of the role
223    */
224   function addRole(address addr, string roleName)
225     internal
226   {
227     roles[roleName].add(addr);
228     emit RoleAdded(addr, roleName);
229   }
230 
231   /**
232    * @dev remove a role from an address
233    * @param addr address
234    * @param roleName the name of the role
235    */
236   function removeRole(address addr, string roleName)
237     internal
238   {
239     roles[roleName].remove(addr);
240     emit RoleRemoved(addr, roleName);
241   }
242 
243   /**
244    * @dev modifier to scope access to a single role (uses msg.sender as addr)
245    * @param roleName the name of the role
246    * // reverts
247    */
248   modifier onlyRole(string roleName)
249   {
250     checkRole(msg.sender, roleName);
251     _;
252   }
253 
254   /**
255    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
256    * @param roleNames the names of the roles to scope access to
257    * // reverts
258    *
259    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
260    *  see: https://github.com/ethereum/solidity/issues/2467
261    */
262   // modifier onlyRoles(string[] roleNames) {
263   //     bool hasAnyRole = false;
264   //     for (uint8 i = 0; i < roleNames.length; i++) {
265   //         if (hasRole(msg.sender, roleNames[i])) {
266   //             hasAnyRole = true;
267   //             break;
268   //         }
269   //     }
270 
271   //     require(hasAnyRole);
272 
273   //     _;
274   // }
275 }
276 
277 
278 contract RBACWithAdmin is RBAC {
279   /**
280    * A constant role name for indicating admins.
281    */
282   string public constant ROLE_ADMIN = "admin";
283   string public constant ROLE_PAUSE_ADMIN = "pauseAdmin";
284 
285   /**
286    * @dev modifier to scope access to admins
287    * // reverts
288    */
289   modifier onlyAdmin()
290   {
291     checkRole(msg.sender, ROLE_ADMIN);
292     _;
293   }
294   modifier onlyPauseAdmin()
295   {
296     checkRole(msg.sender, ROLE_PAUSE_ADMIN);
297     _;
298   }
299   /**
300    * @dev constructor. Sets msg.sender as admin by default
301    */
302   constructor()
303     public
304   {
305     addRole(msg.sender, ROLE_ADMIN);
306     addRole(msg.sender, ROLE_PAUSE_ADMIN);
307   }
308 
309   /**
310    * @dev add a role to an address
311    * @param addr address
312    * @param roleName the name of the role
313    */
314   function adminAddRole(address addr, string roleName)
315     onlyAdmin
316     public
317   {
318     addRole(addr, roleName);
319   }
320 
321   /**
322    * @dev remove a role from an address
323    * @param addr address
324    * @param roleName the name of the role
325    */
326   function adminRemoveRole(address addr, string roleName)
327     onlyAdmin
328     public
329   {
330     removeRole(addr, roleName);
331   }
332 }
333 
334 
335 contract ERC721Basic {
336   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
337   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
338   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
339 
340   function balanceOf(address _owner) public view returns (uint256 _balance);
341   function ownerOf(uint256 _tokenId) public view returns (address _owner);
342   function exists(uint256 _tokenId) public view returns (bool _exists);
343 
344   function approve(address _to, uint256 _tokenId) public payable;
345   function getApproved(uint256 _tokenId) public view returns (address _operator);
346 
347   function setApprovalForAll(address _operator, bool _approved) public;
348   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
349 
350   function transferFrom(address _from, address _to, uint256 _tokenId) public payable;
351   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable;
352   function safeTransferFrom(
353     address _from,
354     address _to,
355     uint256 _tokenId,
356     bytes _data
357   )
358     public payable;
359 }
360 
361 
362 contract ERC721Metadata is ERC721Basic {
363   function name() public view returns (string _name);
364   function symbol() public view returns (string _symbol);
365   function tokenURI(uint256 _tokenId) external view returns (string);
366 }
367 
368 
369 contract ERC721BasicToken is ERC721Basic {
370   using SafeMath for uint256;
371   using AddressUtils for address;
372 
373   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
374   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
375   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
376 
377   // Mapping from token ID to owner
378   mapping (uint256 => address) internal tokenOwner;
379 
380   // Mapping from token ID to approved address
381   mapping (uint256 => address) internal tokenApprovals;
382 
383   // Mapping from owner to number of owned token
384   mapping (address => uint256) internal ownedTokensCount;
385 
386   // Mapping from owner to operator approvals
387   mapping (address => mapping (address => bool)) internal operatorApprovals;
388 
389   /**
390   * @dev Guarantees msg.sender is owner of the given token
391   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
392   */
393   modifier onlyOwnerOf(uint256 _tokenId) {
394     require(ownerOf(_tokenId) == msg.sender);
395     _;
396   }
397 
398   /**
399   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
400   * @param _tokenId uint256 ID of the token to validate
401   */
402   modifier canTransfer(uint256 _tokenId) {
403     require(isApprovedOrOwner(msg.sender, _tokenId));
404     _;
405   }
406 
407   /**
408   * @dev Gets the balance of the specified address
409   * @param _owner address to query the balance of
410   * @return uint256 representing the amount owned by the passed address
411   */
412   function balanceOf(address _owner) public view returns (uint256) {
413     require(_owner != address(0));
414     return ownedTokensCount[_owner];
415   }
416 
417   /**
418   * @dev Gets the owner of the specified token ID
419   * @param _tokenId uint256 ID of the token to query the owner of
420   * @return owner address currently marked as the owner of the given token ID
421   */
422   function ownerOf(uint256 _tokenId) public view returns (address) {
423     address owner = tokenOwner[_tokenId];
424     require(owner != address(0));
425     return owner;
426   }
427 
428   /**
429   * @dev Returns whether the specified token exists
430   * @param _tokenId uint256 ID of the token to query the existance of
431   * @return whether the token exists
432   */
433   function exists(uint256 _tokenId) public view returns (bool) {
434     address owner = tokenOwner[_tokenId];
435     return owner != address(0);
436   }
437 
438   /**
439   * @dev Approves another address to transfer the given token ID
440   * @dev The zero address indicates there is no approved address.
441   * @dev There can only be one approved address per token at a given time.
442   * @dev Can only be called by the token owner or an approved operator.
443   * @param _to address to be approved for the given token ID
444   * @param _tokenId uint256 ID of the token to be approved
445   */
446   function approve(address _to, uint256 _tokenId) public payable{
447     address owner = ownerOf(_tokenId);
448     require(_to != owner);
449     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
450 
451     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
452       tokenApprovals[_tokenId] = _to;
453         if (msg.value > 0 && _to != address(0))  _to.transfer(msg.value);
454         if (msg.value > 0 && _to == address(0))  owner.transfer(msg.value);
455         
456       emit Approval(owner, _to, _tokenId);
457     }
458   }
459 
460   /**
461    * @dev Gets the approved address for a token ID, or zero if no address set
462    * @param _tokenId uint256 ID of the token to query the approval of
463    * @return address currently approved for a the given token ID
464    */
465   function getApproved(uint256 _tokenId) public view returns (address) {
466     return tokenApprovals[_tokenId];
467   }
468 
469   /**
470   * @dev Sets or unsets the approval of a given operator
471   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
472   * @param _to operator address to set the approval
473   * @param _approved representing the status of the approval to be set
474   */
475   function setApprovalForAll(address _to, bool _approved) public {
476     require(_to != msg.sender);
477     operatorApprovals[msg.sender][_to] = _approved;
478     emit ApprovalForAll(msg.sender, _to, _approved);
479   }
480 
481   /**
482    * @dev Tells whether an operator is approved by a given owner
483    * @param _owner owner address which you want to query the approval of
484    * @param _operator operator address which you want to query the approval of
485    * @return bool whether the given operator is approved by the given owner
486    */
487   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
488     return operatorApprovals[_owner][_operator];
489   }
490 
491   /**
492   * @dev Transfers the ownership of a given token ID to another address
493   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
494   * @dev Requires the msg sender to be the owner, approved, or operator
495   * @param _from current owner of the token
496   * @param _to address to receive the ownership of the given token ID
497   * @param _tokenId uint256 ID of the token to be transferred
498   */
499   function transferFrom(address _from, address _to, uint256 _tokenId) public payable canTransfer(_tokenId) {
500     require(_from != address(0));
501     require(_to != address(0));
502 
503     clearApproval(_from, _tokenId);
504     removeTokenFrom(_from, _tokenId);
505     addTokenTo(_to, _tokenId);
506     if (msg.value > 0) _to.transfer(msg.value);
507 
508     emit Transfer(_from, _to, _tokenId);
509   }
510 
511   /**
512   * @dev Safely transfers the ownership of a given token ID to another address
513   * @dev If the target address is a contract, it must implement `onERC721Received`,
514   *  which is called upon a safe transfer, and return the magic value
515   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
516   *  the transfer is reverted.
517   * @dev Requires the msg sender to be the owner, approved, or operator
518   * @param _from current owner of the token
519   * @param _to address to receive the ownership of the given token ID
520   * @param _tokenId uint256 ID of the token to be transferred
521   */
522   function safeTransferFrom(
523     address _from,
524     address _to,
525     uint256 _tokenId
526   )
527     public
528     payable
529     canTransfer(_tokenId)
530   {
531     safeTransferFrom(_from, _to, _tokenId, "");
532   }
533 
534   /**
535   * @dev Safely transfers the ownership of a given token ID to another address
536   * @dev If the target address is a contract, it must implement `onERC721Received`,
537   *  which is called upon a safe transfer, and return the magic value
538   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
539   *  the transfer is reverted.
540   * @dev Requires the msg sender to be the owner, approved, or operator
541   * @param _from current owner of the token
542   * @param _to address to receive the ownership of the given token ID
543   * @param _tokenId uint256 ID of the token to be transferred
544   * @param _data bytes data to send along with a safe transfer check
545   */
546   function safeTransferFrom(
547     address _from,
548     address _to,
549     uint256 _tokenId,
550     bytes _data
551   )
552     public
553     payable
554     canTransfer(_tokenId)
555   {
556     transferFrom(_from, _to, _tokenId);
557     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
558   }
559 
560   /**
561    * @dev Returns whether the given spender can transfer a given token ID
562    * @param _spender address of the spender to query
563    * @param _tokenId uint256 ID of the token to be transferred
564    * @return bool whether the msg.sender is approved for the given token ID,
565    *  is an operator of the owner, or is the owner of the token
566    */
567   function isApprovedOrOwner(address _spender, uint256 _tokenId) public view returns (bool) {
568     address owner = ownerOf(_tokenId);
569     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
570   }
571 
572   /**
573   * @dev Internal function to mint a new token
574   * @dev Reverts if the given token ID already exists
575   * @param _to The address that will own the minted token
576   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
577   */
578   function _mint(address _to, uint256 _tokenId) internal {
579     require(_to != address(0));
580     addTokenTo(_to, _tokenId);
581     emit Transfer(address(0), _to, _tokenId);
582   }
583 
584   /**
585   * @dev Internal function to burn a specific token
586   * @dev Reverts if the token does not exist
587   * @param _tokenId uint256 ID of the token being burned by the msg.sender
588   */
589   function _burn(address _owner, uint256 _tokenId) internal {
590     clearApproval(_owner, _tokenId);
591     removeTokenFrom(_owner, _tokenId);
592     emit Transfer(_owner, address(0), _tokenId);
593   }
594 
595   /**
596   * @dev Internal function to clear current approval of a given token ID
597   * @dev Reverts if the given address is not indeed the owner of the token
598   * @param _owner owner of the token
599   * @param _tokenId uint256 ID of the token to be transferred
600   */
601   function clearApproval(address _owner, uint256 _tokenId) internal {
602     require(ownerOf(_tokenId) == _owner);
603     if (tokenApprovals[_tokenId] != address(0)) {
604       tokenApprovals[_tokenId] = address(0);
605       emit Approval(_owner, address(0), _tokenId);
606     }
607   }
608 
609   /**
610   * @dev Internal function to add a token ID to the list of a given address
611   * @param _to address representing the new owner of the given token ID
612   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
613   */
614   function addTokenTo(address _to, uint256 _tokenId) internal {
615     require(tokenOwner[_tokenId] == address(0));
616     tokenOwner[_tokenId] = _to;
617     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
618   }
619 
620   /**
621   * @dev Internal function to remove a token ID from the list of a given address
622   * @param _from address representing the previous owner of the given token ID
623   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
624   */
625   function removeTokenFrom(address _from, uint256 _tokenId) internal {
626     require(ownerOf(_tokenId) == _from);
627     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
628     tokenOwner[_tokenId] = address(0);
629   }
630 
631   /**
632   * @dev Internal function to invoke `onERC721Received` on a target address
633   * @dev The call is not executed if the target address is not a contract
634   * @param _from address representing the previous owner of the given token ID
635   * @param _to target address that will receive the tokens
636   * @param _tokenId uint256 ID of the token to be transferred
637   * @param _data bytes optional data to send along with the call
638   * @return whether the call correctly returned the expected magic value
639   */
640   function checkAndCallSafeTransfer(
641     address _from,
642     address _to,
643     uint256 _tokenId,
644     bytes _data
645   )
646     internal
647     returns (bool)
648   {
649     if (!_to.isContract()) {
650       return true;
651     }
652     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
653     return (retval == ERC721_RECEIVED);
654   }
655 }
656 
657 
658 contract ERC721Receiver {
659   /**
660    * @dev Magic value to be returned upon successful reception of an NFT
661    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
662    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
663    */
664   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
665 
666   /**
667    * @notice Handle the receipt of an NFT
668    * @dev The ERC721 smart contract calls this function on the recipient
669    *  after a `safetransfer`. This function MAY throw to revert and reject the
670    *  transfer. This function MUST use 50,000 gas or less. Return of other
671    *  than the magic value MUST result in the transaction being reverted.
672    *  Note: the contract address is always the message sender.
673    * @param _from The sending address
674    * @param _tokenId The NFT identifier which is being transfered
675    * @param _data Additional data with no specified format
676    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
677    */
678   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
679 }
680 
681 
682 contract ERC721Enumerable is ERC721Basic {
683   function totalSupply() public view returns (uint256);
684   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
685   function tokenByIndex(uint256 _index) public view returns (uint256);
686 }
687 
688 
689 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
690 }
691 
692 
693 contract ERC721Token is ERC721, ERC721BasicToken {
694   // Token name
695   string internal name_;
696 
697   // Token symbol
698   string internal symbol_;
699 
700   // Mapping from owner to list of owned token IDs
701   mapping (address => uint256[]) internal ownedTokens;
702 
703   // Mapping from token ID to index of the owner tokens list
704   mapping(uint256 => uint256) internal ownedTokensIndex;
705 
706   // Array with all token ids, used for enumeration
707   uint256[] internal allTokens;
708 
709   // Mapping from token id to position in the allTokens array
710   mapping(uint256 => uint256) internal allTokensIndex;
711 
712   // Optional mapping for token URIs
713   // mapping(uint256 => string) internal tokenURIs;
714 
715   /**
716   * @dev Constructor function
717   */
718   constructor(string _name, string _symbol) public {
719     name_ = _name;
720     symbol_ = _symbol;
721   }
722 
723   /**
724   * @dev Gets the token name
725   * @return string representing the token name
726   */
727   function name() public view returns (string) {
728     return name_;
729   }
730 
731   /**
732   * @dev Gets the token symbol
733   * @return string representing the token symbol
734   */
735   function symbol() public view returns (string) {
736     return symbol_;
737   }
738 
739   /**
740   * @dev Returns an URI for a given token ID
741   * @dev Throws if the token ID does not exist. May return an empty string.
742   * @param _tokenId uint256 ID of the token to query
743   */
744    bytes constant firstPartURI = "https://www.dragonseth.com/image/";
745     
746     function tokenURI(uint256  _tokenId) external view returns (string) {
747         require(exists(_tokenId));
748         bytes memory tmpBytes = new bytes(96);
749         uint256 i = 0;
750         uint256 tokenId = _tokenId;
751         // for same use case need "if (tokenId == 0)" 
752         while (tokenId != 0) {
753             uint256 remainderDiv = tokenId % 10;
754             tokenId = tokenId / 10;
755             tmpBytes[i++] = byte(48 + remainderDiv);
756         }
757  
758         bytes memory resaultBytes = new bytes(firstPartURI.length + i);
759         
760         for (uint256 j = 0; j < firstPartURI.length; j++) {
761             resaultBytes[j] = firstPartURI[j];
762         }
763         
764         i--;
765         
766         for (j = 0; j <= i; j++) {
767             resaultBytes[j + firstPartURI.length] = tmpBytes[i - j];
768         }
769         
770         return string(resaultBytes);
771         
772     }
773 /*    
774   function tokenURI(uint256 _tokenId) public view returns (string) {
775     require(exists(_tokenId));
776     return tokenURIs[_tokenId];
777   }
778 */
779   /**
780   * @dev Gets the token ID at a given index of the tokens list of the requested owner
781   * @param _owner address owning the tokens list to be accessed
782   * @param _index uint256 representing the index to be accessed of the requested tokens list
783   * @return uint256 token ID at the given index of the tokens list owned by the requested address
784   */
785   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
786     require(_index < balanceOf(_owner));
787     return ownedTokens[_owner][_index];
788   }
789 
790   /**
791   * @dev Gets the total amount of tokens stored by the contract
792   * @return uint256 representing the total amount of tokens
793   */
794   function totalSupply() public view returns (uint256) {
795     return allTokens.length;
796   }
797 
798   /**
799   * @dev Gets the token ID at a given index of all the tokens in this contract
800   * @dev Reverts if the index is greater or equal to the total number of tokens
801   * @param _index uint256 representing the index to be accessed of the tokens list
802   * @return uint256 token ID at the given index of the tokens list
803   */
804   function tokenByIndex(uint256 _index) public view returns (uint256) {
805     require(_index < totalSupply());
806     return allTokens[_index];
807   }
808 
809   /**
810   * @dev Internal function to set the token URI for a given token
811   * @dev Reverts if the token ID does not exist
812   * @param _tokenId uint256 ID of the token to set its URI
813   * @param _uri string URI to assign
814   */
815 /*
816   function _setTokenURI(uint256 _tokenId, string _uri) internal {
817     require(exists(_tokenId));
818     tokenURIs[_tokenId] = _uri;
819   }
820 */
821   /**
822   * @dev Internal function to add a token ID to the list of a given address
823   * @param _to address representing the new owner of the given token ID
824   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
825   */
826   function addTokenTo(address _to, uint256 _tokenId) internal {
827     super.addTokenTo(_to, _tokenId);
828     uint256 length = ownedTokens[_to].length;
829     ownedTokens[_to].push(_tokenId);
830     ownedTokensIndex[_tokenId] = length;
831   }
832 
833   /**
834   * @dev Internal function to remove a token ID from the list of a given address
835   * @param _from address representing the previous owner of the given token ID
836   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
837   */
838   function removeTokenFrom(address _from, uint256 _tokenId) internal {
839     super.removeTokenFrom(_from, _tokenId);
840 
841     uint256 tokenIndex = ownedTokensIndex[_tokenId];
842     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
843     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
844 
845     ownedTokens[_from][tokenIndex] = lastToken;
846     ownedTokens[_from][lastTokenIndex] = 0;
847     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
848     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
849     // the lastToken to the first position, and then dropping the element placed in the last position of the list
850 
851     ownedTokens[_from].length--;
852     ownedTokensIndex[_tokenId] = 0;
853     ownedTokensIndex[lastToken] = tokenIndex;
854   }
855 
856   /**
857   * @dev Internal function to mint a new token
858   * @dev Reverts if the given token ID already exists
859   * @param _to address the beneficiary that will own the minted token
860   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
861   */
862   function _mint(address _to, uint256 _tokenId) internal {
863     super._mint(_to, _tokenId);
864 
865     allTokensIndex[_tokenId] = allTokens.length;
866     allTokens.push(_tokenId);
867   }
868 
869   /**
870   * @dev Internal function to burn a specific token
871   * @dev Reverts if the token does not exist
872   * @param _owner owner of the token to burn
873   * @param _tokenId uint256 ID of the token being burned by the msg.sender
874   */
875   function _burn(address _owner, uint256 _tokenId) internal {
876     super._burn(_owner, _tokenId);
877 
878     // Clear metadata (if any)
879 /*    
880     if (bytes(tokenURIs[_tokenId]).length != 0) {
881       delete tokenURIs[_tokenId];
882     }
883 */
884     // Reorg all tokens array
885     uint256 tokenIndex = allTokensIndex[_tokenId];
886     uint256 lastTokenIndex = allTokens.length.sub(1);
887     uint256 lastToken = allTokens[lastTokenIndex];
888 
889     allTokens[tokenIndex] = lastToken;
890     allTokens[lastTokenIndex] = 0;
891 
892     allTokens.length--;
893     allTokensIndex[_tokenId] = 0;
894     allTokensIndex[lastToken] = tokenIndex;
895   }
896        /**
897   * @dev Gets the list of tokens owned by a given address
898   * @param _owner address to query the tokens of
899   * @return uint256[] representing the list of tokens owned by the passed address
900   */
901   function tokensOf(address _owner) external view returns (uint256[]) {
902     return ownedTokens[_owner];
903   }
904 
905 
906 }
907 
908 
909 contract DragonsETH_GC is RBACWithAdmin {
910     GenRNG public genRNGContractAddress;
911     FixMarketPlace public fmpContractAddress;
912     DragonStats public dragonsStatsContract;
913     Necropolis public necropolisContract;
914     Auction public auctionContract;
915     SuperContract public superContract;
916     DragonSelectFight2Death public selectFight2DeathContract;
917     DragonsRandomFight2Death public randomFight2DeathContract;
918     Mutagen2Face public mutagen2FaceContract;
919     
920     address wallet;
921     
922     uint8 adultDragonStage = 3;
923     bool stageThirdBegin = false;
924     uint256 constant UINT256_MAX = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
925     uint256 public secondsInBlock = 15;
926     uint256 public priceDecraseTime2Action = 0.000005 ether; //  1 block
927     uint256 public priceRandomFight2Death = 0.02 ether;
928     uint256 public priceSelectFight2Death = 0.03 ether;
929     uint256 public priceChangeName = 0.01 ether;
930     uint256 public needFightToAdult = 100;
931     
932     function changeGenRNGcontractAddress(address _genRNGContractAddress) external onlyAdmin {
933         genRNGContractAddress = GenRNG(_genRNGContractAddress);
934     }
935 
936     function changeFMPcontractAddress(address _fmpContractAddress) external onlyAdmin {
937         fmpContractAddress = FixMarketPlace(_fmpContractAddress);
938     }
939 
940     function changeDragonsStatsContract(address _dragonsStatsContract) external onlyAdmin {
941         dragonsStatsContract = DragonStats(_dragonsStatsContract);
942     }
943 
944     function changeAuctionContract(address _auctionContract) external onlyAdmin {
945         auctionContract = Auction(_auctionContract);
946     }
947 
948     function changeSelectFight2DeathContract(address _selectFight2DeathContract) external onlyAdmin {
949         selectFight2DeathContract = DragonSelectFight2Death(_selectFight2DeathContract);
950     }
951 
952     function changeRandomFight2DeathContract(address _randomFight2DeathContract) external onlyAdmin {
953         randomFight2DeathContract = DragonsRandomFight2Death(_randomFight2DeathContract);
954     }
955 
956     function changeMutagen2FaceContract(address _mutagen2FaceContract) external onlyAdmin {
957         mutagen2FaceContract = Mutagen2Face(_mutagen2FaceContract);
958     }
959 
960     function changeSuperContract(address _superContract) external onlyAdmin {
961         superContract = SuperContract(_superContract);
962     }
963 
964     function changeWallet(address _wallet) external onlyAdmin {
965         wallet = _wallet;
966     }
967 
968     function changePriceDecraseTime2Action(uint256 _priceDecraseTime2Action) external onlyAdmin {
969         priceDecraseTime2Action = _priceDecraseTime2Action;
970     }
971 
972     function changePriceRandomFight2Death(uint256 _priceRandomFight2Death) external onlyAdmin {
973         priceRandomFight2Death = _priceRandomFight2Death;
974     }
975 
976     function changePriceSelectFight2Death(uint256 _priceSelectFight2Death) external onlyAdmin {
977         priceSelectFight2Death = _priceSelectFight2Death;
978     }
979 
980     function changePriceChangeName(uint256 _priceChangeName) external onlyAdmin {
981         priceChangeName = _priceChangeName;
982     }
983 
984     function changeSecondsInBlock(uint256 _secondsInBlock) external onlyAdmin {
985         secondsInBlock = _secondsInBlock;
986     }
987     function changeNeedFightToAdult(uint256 _needFightToAdult) external onlyAdmin {
988         needFightToAdult = _needFightToAdult;
989     }
990 
991     function changeAdultDragonStage(uint8 _adultDragonStage) external onlyAdmin {
992         adultDragonStage = _adultDragonStage;
993     }
994 
995     function setStageThirdBegin() external onlyAdmin {
996         stageThirdBegin = true;
997     }
998 
999     function withdrawAllEther() external onlyAdmin {
1000         require(wallet != 0);
1001         wallet.transfer(address(this).balance);
1002     }
1003     
1004     // EIP-165 and EIP-721
1005     bytes4 constant ERC165_Signature = 0x01ffc9a7;
1006     bytes4 constant ERC721_Signature = 0x80ac58cd;
1007     bytes4 constant ERC721Metadata_Signature = 0x5b5e139f;
1008     bytes4 constant ERC721Enumerable_Signature = 0x780e9d63;
1009     
1010     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
1011         return (
1012             (_interfaceID == ERC165_Signature) || 
1013             (_interfaceID == ERC721_Signature) || 
1014             (_interfaceID == ERC721Metadata_Signature) || 
1015             (_interfaceID == ERC721Enumerable_Signature)
1016         );
1017     }
1018 }
1019 
1020 
1021 contract ReentrancyGuard {
1022 
1023   /**
1024    * @dev We use a single lock for the whole contract.
1025    */
1026   bool private reentrancyLock = false;
1027 
1028   /**
1029    * @dev Prevents a contract from calling itself, directly or indirectly.
1030    * @notice If you mark a function `nonReentrant`, you should also
1031    * mark it `external`. Calling one nonReentrant function from
1032    * another is not supported. Instead, you can implement a
1033    * `private` function doing the actual work, and a `external`
1034    * wrapper marked as `nonReentrant`.
1035    */
1036   modifier nonReentrant() {
1037     require(!reentrancyLock);
1038     reentrancyLock = true;
1039     _;
1040     reentrancyLock = false;
1041   }
1042 
1043 }
1044 
1045 
1046 contract DragonsETH is ERC721Token("DragonsETH.com Dragon", "DragonsETH"), DragonsETH_GC, ReentrancyGuard {
1047     uint256 public totalDragons;
1048     uint256 public liveDragons;
1049     struct Dragon {
1050         uint256 gen1;
1051         uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon ... 
1052         uint8 currentAction;
1053         // 0 - free, 1 - fight place, 2 - random fight, 3 - breed market, 4 - breed auction, 5 - random breed ... 0xFF - Necropolis
1054         uint240 gen2;
1055         uint256 nextBlock2Action;
1056     }
1057 
1058     Dragon[] public dragons;
1059     mapping(uint256 => string) public dragonName;
1060     
1061    
1062     constructor(address _wallet, address _necropolisContract, address _dragonsStatsContract) public {
1063         
1064         _mint(msg.sender, 0);
1065         Dragon memory _dragon = Dragon({
1066             gen1: 0,
1067             stage: 0,
1068             currentAction: 0,
1069             gen2: 0,
1070             nextBlock2Action: UINT256_MAX
1071         });
1072         dragons.push(_dragon);
1073         transferFrom(msg.sender, _necropolisContract, 0);
1074         dragonsStatsContract = DragonStats(_dragonsStatsContract);
1075         necropolisContract = Necropolis(_necropolisContract);
1076         wallet = _wallet;
1077     }
1078    
1079     function add2MarketPlace(uint256 _dragonID, uint256 _dragonPrice, uint256 _endBlockNumber) external canTransfer(_dragonID)  {
1080         require(dragons[_dragonID].stage != 0); // dragon not dead
1081         if (dragons[_dragonID].stage >= 2) {
1082             checkDragonStatus(_dragonID, 2);
1083         }
1084         address dragonOwner = ownerOf(_dragonID);
1085         if (fmpContractAddress.add2MarketPlace(dragonOwner, _dragonID, _dragonPrice, _endBlockNumber)) {
1086             transferFrom(dragonOwner, fmpContractAddress, _dragonID);
1087         }
1088     }
1089 
1090     function add2Auction(
1091         uint256 _dragonID, 
1092         uint256 _startPrice, 
1093         uint256 _step, 
1094         uint256 _endPrice, 
1095         uint256 _endBlockNumber
1096     ) 
1097         external 
1098         canTransfer(_dragonID) 
1099     {
1100         require(dragons[_dragonID].stage != 0); // dragon not dead
1101         if (dragons[_dragonID].stage >= 2) {
1102             checkDragonStatus(_dragonID, 2);
1103         }
1104         address dragonOwner = ownerOf(_dragonID);
1105         if (auctionContract.add2Auction(dragonOwner, _dragonID, _startPrice, _step, _endPrice, _endBlockNumber)) {
1106             transferFrom(dragonOwner, auctionContract, _dragonID);
1107         }
1108     }
1109     
1110     function addRandomFight2Death(uint256 _dragonID) external payable nonReentrant canTransfer(_dragonID)   {
1111         checkDragonStatus(_dragonID, adultDragonStage);
1112         if (priceRandomFight2Death > 0) {
1113             require(msg.value >= priceRandomFight2Death);
1114             wallet.transfer(priceRandomFight2Death);
1115             if (msg.value - priceRandomFight2Death > 0) 
1116                 msg.sender.transfer(msg.value - priceRandomFight2Death);
1117         } else {
1118             if (msg.value > 0) 
1119                 msg.sender.transfer(msg.value);
1120         }
1121         address dragonOwner = ownerOf(_dragonID);
1122         transferFrom(dragonOwner, randomFight2DeathContract, _dragonID);
1123         randomFight2DeathContract.addRandomFight2Death(dragonOwner, _dragonID);
1124     }
1125     
1126     function addSelctFight2Death(uint256 _yourDragonID, uint256 _oppDragonID, uint256 _endBlockNumber) 
1127         external 
1128         payable 
1129         nonReentrant 
1130         canTransfer(_yourDragonID) 
1131     {
1132         checkDragonStatus(_yourDragonID, adultDragonStage);
1133         if (priceSelectFight2Death > 0) {
1134             require(msg.value >= priceSelectFight2Death);
1135             address(selectFight2DeathContract).transfer(priceSelectFight2Death);
1136             if (msg.value - priceSelectFight2Death > 0) msg.sender.transfer(msg.value - priceSelectFight2Death);
1137         } else {
1138             if (msg.value > 0) 
1139                 msg.sender.transfer(msg.value);
1140         }
1141         address dragonOwner = ownerOf(_yourDragonID);
1142         transferFrom(dragonOwner, selectFight2DeathContract, _yourDragonID);
1143         selectFight2DeathContract.addSelctFight2Death(dragonOwner, _yourDragonID, _oppDragonID, _endBlockNumber, priceSelectFight2Death);
1144         
1145     }
1146     
1147     function mutagen2Face(uint256 _dragonID, uint256 _mutagenCount) external canTransfer(_dragonID)   {
1148         checkDragonStatus(_dragonID, 2);
1149         address dragonOwner = ownerOf(_dragonID);
1150         transferFrom(dragonOwner, mutagen2FaceContract, _dragonID);
1151         mutagen2FaceContract.addDragon(dragonOwner, _dragonID, _mutagenCount);
1152     }
1153 
1154     function createDragon(
1155         address _to, 
1156         uint256 _timeToBorn, 
1157         uint256 _parentOne, 
1158         uint256 _parentTwo, 
1159         uint256 _gen1, 
1160         uint240 _gen2
1161     ) 
1162         external 
1163         onlyRole("CreateContract") 
1164     {
1165         totalDragons++;
1166         liveDragons++;
1167         _mint(_to, totalDragons);
1168         uint256[2] memory twoGen;
1169         if (_parentOne == 0 && _parentTwo == 0 && _gen1 == 0 && _gen2 == 0) {
1170             twoGen = genRNGContractAddress.getNewGens(_to, totalDragons);
1171         } else {
1172             twoGen[0] = _gen1;
1173             twoGen[1] = uint256(_gen2);
1174         }
1175         Dragon memory _dragon = Dragon({
1176             gen1: twoGen[0],
1177             stage: 1,
1178             currentAction: 0,
1179             gen2: uint240(twoGen[1]),
1180             nextBlock2Action: _timeToBorn 
1181         });
1182         dragons.push(_dragon);
1183         if (_parentOne != 0) {
1184             dragonsStatsContract.setParents(totalDragons,_parentOne,_parentTwo);
1185             dragonsStatsContract.incChildren(_parentOne);
1186             dragonsStatsContract.incChildren(_parentTwo);
1187         }
1188         dragonsStatsContract.setBirthBlock(totalDragons);
1189     }
1190     
1191     function changeDragonGen(uint256 _dragonID, uint256 _gen, uint8 _which) external onlyRole("ChangeContract") {
1192         require(dragons[_dragonID].stage >= 2); // dragon not dead and not egg
1193         if (_which == 0) {
1194             dragons[_dragonID].gen1 = _gen;
1195         } else {
1196             dragons[_dragonID].gen2 = uint240(_gen);
1197         }
1198     }
1199     
1200     function birthDragon(uint256 _dragonID) external canTransfer(_dragonID) {
1201         require(dragons[_dragonID].stage != 0); // dragon not dead
1202         require(dragons[_dragonID].nextBlock2Action <= block.number);
1203         dragons[_dragonID].stage = 2;
1204     }
1205     
1206     function matureDragon(uint256 _dragonID) external canTransfer(_dragonID) {
1207         require(stageThirdBegin);
1208         checkDragonStatus(_dragonID, 2);
1209         require(dragonsStatsContract.getDragonFight(_dragonID) >= needFightToAdult);
1210         dragons[_dragonID].stage = 3;
1211         
1212     }
1213     
1214     function superDragon(uint256 _dragonID) external canTransfer(_dragonID) {
1215         checkDragonStatus(_dragonID, 3);
1216         require(superContract.checkDragon(_dragonID));
1217         dragons[_dragonID].stage = 4;
1218     }
1219     
1220     function killDragon(uint256 _dragonID) external onlyOwnerOf(_dragonID) {
1221         checkDragonStatus(_dragonID, 2);
1222         dragons[_dragonID].stage = 0;
1223         dragons[_dragonID].currentAction = 0xFF;
1224         dragons[_dragonID].nextBlock2Action = UINT256_MAX;
1225         necropolisContract.addDragon(ownerOf(_dragonID), _dragonID, 1);
1226         transferFrom(ownerOf(_dragonID), necropolisContract, _dragonID);
1227         dragonsStatsContract.setDeathBlock(_dragonID);
1228         liveDragons--;
1229     }
1230     
1231     function killDragonDeathContract(address _lastOwner, uint256 _dragonID, uint256 _deathReason) 
1232         external 
1233         canTransfer(_dragonID) 
1234         onlyRole("DeathContract") 
1235     {
1236         checkDragonStatus(_dragonID, 2);
1237         dragons[_dragonID].stage = 0;
1238         dragons[_dragonID].currentAction = 0xFF;
1239         dragons[_dragonID].nextBlock2Action = UINT256_MAX;
1240         necropolisContract.addDragon(_lastOwner, _dragonID, _deathReason);
1241         transferFrom(ownerOf(_dragonID), necropolisContract, _dragonID);
1242         dragonsStatsContract.setDeathBlock(_dragonID);
1243         liveDragons--;
1244         
1245     }
1246     
1247     function decraseTimeToAction(uint256 _dragonID) external payable nonReentrant canTransfer(_dragonID) {
1248         require(dragons[_dragonID].stage != 0); // dragon not dead
1249         require(msg.value >= priceDecraseTime2Action);
1250         require(dragons[_dragonID].nextBlock2Action > block.number);
1251         uint256 maxBlockCount = dragons[_dragonID].nextBlock2Action - block.number;
1252         if (msg.value > maxBlockCount * priceDecraseTime2Action) {
1253             msg.sender.transfer(msg.value - maxBlockCount * priceDecraseTime2Action);
1254             wallet.transfer(maxBlockCount * priceDecraseTime2Action);
1255             dragons[_dragonID].nextBlock2Action = 0;
1256         } else {
1257             if (priceDecraseTime2Action == 0) {
1258                 dragons[_dragonID].nextBlock2Action = 0;
1259             } else {
1260                 wallet.transfer(msg.value);
1261                 dragons[_dragonID].nextBlock2Action = dragons[_dragonID].nextBlock2Action - msg.value / priceDecraseTime2Action - 1;
1262             }
1263         }
1264         
1265     }
1266     
1267     function addDragonName(uint256 _dragonID,string _newName) external payable nonReentrant canTransfer(_dragonID) {
1268         checkDragonStatus(_dragonID, 2);
1269         if (bytes(dragonName[_dragonID]).length == 0) {
1270             dragonName[_dragonID] = _newName;
1271             if (msg.value > 0) 
1272                 msg.sender.transfer(msg.value);
1273         } else {
1274             if (priceChangeName == 0) {
1275                 dragonName[_dragonID] = _newName;
1276                 if (msg.value > 0) 
1277                     msg.sender.transfer(msg.value);
1278             } else {
1279                 require(msg.value >= priceChangeName);
1280                 wallet.transfer(priceChangeName);
1281                 if (msg.value - priceChangeName > 0) 
1282                     msg.sender.transfer(msg.value - priceChangeName);
1283                 dragonName[_dragonID] = _newName;
1284             }
1285         }
1286     }
1287     
1288     function checkDragonStatus(uint256 _dragonID, uint8 _stage) public view {
1289         require(dragons[_dragonID].stage != 0); // dragon not dead
1290         // dragon not in action and not in rest  and not egg
1291         require(
1292             dragons[_dragonID].nextBlock2Action <= block.number && 
1293             dragons[_dragonID].currentAction == 0 && 
1294             dragons[_dragonID].stage >= _stage
1295         );
1296     }
1297     
1298     function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external onlyRole("ActionContract") {
1299         dragons[_dragonID].currentAction = _currentAction;
1300     }
1301     
1302     function setTime2Rest(uint256 _dragonID, uint256 _addNextBlock2Action) external onlyRole("ActionContract") {
1303         dragons[_dragonID].nextBlock2Action = block.number + _addNextBlock2Action;
1304     }
1305 }