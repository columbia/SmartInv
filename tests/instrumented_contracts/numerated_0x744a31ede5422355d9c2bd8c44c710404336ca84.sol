1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title -NFTs crowdsale
6  * NFTsCrowdsale provides a marketplace for NFTs
7  *
8  *  ██████╗ ██████╗   ██████╗  ██╗    ██╗ ██████╗  ███████╗  █████╗  ██╗      ███████╗ ██╗
9  * ██╔════╝ ██╔══██╗ ██╔═══██╗ ██║    ██║ ██╔══██╗ ██╔════╝ ██╔══██╗ ██║      ██╔════╝ ██║
10  * ██║      ██████╔╝ ██║   ██║ ██║ █╗ ██║ ██║  ██║ ███████╗ ███████║ ██║      █████╗   ██║
11  * ██║      ██╔══██╗ ██║   ██║ ██║███╗██║ ██║  ██║ ╚════██║ ██╔══██║ ██║      ██╔══╝   ╚═╝
12  * ╚██████╗ ██║  ██║ ╚██████╔╝ ╚███╔███╔╝ ██████╔╝ ███████║ ██║  ██║ ███████╗ ███████╗ ██╗
13  *  ╚═════╝ ╚═╝  ╚═╝  ╚═════╝   ╚══╝╚══╝  ╚═════╝  ╚══════╝ ╚═╝  ╚═╝ ╚══════╝ ╚══════╝ ╚═╝
14  *
15  * ---
16  * POWERED BY
17  * ╦   ╔═╗ ╦═╗ ╔╦╗ ╦   ╔═╗ ╔═╗ ╔═╗      ╔╦╗ ╔═╗ ╔═╗ ╔╦╗
18  * ║   ║ ║ ╠╦╝  ║║ ║   ║╣  ╚═╗ ╚═╗       ║  ║╣  ╠═╣ ║║║
19  * ╩═╝ ╚═╝ ╩╚═ ═╩╝ ╩═╝ ╚═╝ ╚═╝ ╚═╝       ╩  ╚═╝ ╩ ╩ ╩ ╩
20  * game at https://lordless.io
21  * code at https://github.com/lordlessio
22  */
23 
24 // File: node_modules/zeppelin-solidity/contracts/access/rbac/Roles.sol
25 
26 /**
27  * @title Roles
28  * @author Francisco Giordano (@frangio)
29  * @dev Library for managing addresses assigned to a Role.
30  * See RBAC.sol for example usage.
31  */
32 library Roles {
33   struct Role {
34     mapping (address => bool) bearer;
35   }
36 
37   /**
38    * @dev give an address access to this role
39    */
40   function add(Role storage _role, address _addr)
41     internal
42   {
43     _role.bearer[_addr] = true;
44   }
45 
46   /**
47    * @dev remove an address' access to this role
48    */
49   function remove(Role storage _role, address _addr)
50     internal
51   {
52     _role.bearer[_addr] = false;
53   }
54 
55   /**
56    * @dev check if an address has this role
57    * // reverts
58    */
59   function check(Role storage _role, address _addr)
60     internal
61     view
62   {
63     require(has(_role, _addr));
64   }
65 
66   /**
67    * @dev check if an address has this role
68    * @return bool
69    */
70   function has(Role storage _role, address _addr)
71     internal
72     view
73     returns (bool)
74   {
75     return _role.bearer[_addr];
76   }
77 }
78 
79 // File: node_modules/zeppelin-solidity/contracts/access/rbac/RBAC.sol
80 
81 /**
82  * @title RBAC (Role-Based Access Control)
83  * @author Matt Condon (@Shrugs)
84  * @dev Stores and provides setters and getters for roles and addresses.
85  * Supports unlimited numbers of roles and addresses.
86  * See //contracts/mocks/RBACMock.sol for an example of usage.
87  * This RBAC method uses strings to key roles. It may be beneficial
88  * for you to write your own implementation of this interface using Enums or similar.
89  */
90 contract RBAC {
91   using Roles for Roles.Role;
92 
93   mapping (string => Roles.Role) private roles;
94 
95   event RoleAdded(address indexed operator, string role);
96   event RoleRemoved(address indexed operator, string role);
97 
98   /**
99    * @dev reverts if addr does not have role
100    * @param _operator address
101    * @param _role the name of the role
102    * // reverts
103    */
104   function checkRole(address _operator, string _role)
105     public
106     view
107   {
108     roles[_role].check(_operator);
109   }
110 
111   /**
112    * @dev determine if addr has role
113    * @param _operator address
114    * @param _role the name of the role
115    * @return bool
116    */
117   function hasRole(address _operator, string _role)
118     public
119     view
120     returns (bool)
121   {
122     return roles[_role].has(_operator);
123   }
124 
125   /**
126    * @dev add a role to an address
127    * @param _operator address
128    * @param _role the name of the role
129    */
130   function addRole(address _operator, string _role)
131     internal
132   {
133     roles[_role].add(_operator);
134     emit RoleAdded(_operator, _role);
135   }
136 
137   /**
138    * @dev remove a role from an address
139    * @param _operator address
140    * @param _role the name of the role
141    */
142   function removeRole(address _operator, string _role)
143     internal
144   {
145     roles[_role].remove(_operator);
146     emit RoleRemoved(_operator, _role);
147   }
148 
149   /**
150    * @dev modifier to scope access to a single role (uses msg.sender as addr)
151    * @param _role the name of the role
152    * // reverts
153    */
154   modifier onlyRole(string _role)
155   {
156     checkRole(msg.sender, _role);
157     _;
158   }
159 
160   /**
161    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
162    * @param _roles the names of the roles to scope access to
163    * // reverts
164    *
165    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
166    *  see: https://github.com/ethereum/solidity/issues/2467
167    */
168   // modifier onlyRoles(string[] _roles) {
169   //     bool hasAnyRole = false;
170   //     for (uint8 i = 0; i < _roles.length; i++) {
171   //         if (hasRole(msg.sender, _roles[i])) {
172   //             hasAnyRole = true;
173   //             break;
174   //         }
175   //     }
176 
177   //     require(hasAnyRole);
178 
179   //     _;
180   // }
181 }
182 
183 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
184 
185 /**
186  * @title Ownable
187  * @dev The Ownable contract has an owner address, and provides basic authorization control
188  * functions, this simplifies the implementation of "user permissions".
189  */
190 contract Ownable {
191   address public owner;
192 
193 
194   event OwnershipRenounced(address indexed previousOwner);
195   event OwnershipTransferred(
196     address indexed previousOwner,
197     address indexed newOwner
198   );
199 
200 
201   /**
202    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
203    * account.
204    */
205   constructor() public {
206     owner = msg.sender;
207   }
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     require(msg.sender == owner);
214     _;
215   }
216 
217   /**
218    * @dev Allows the current owner to relinquish control of the contract.
219    * @notice Renouncing to ownership will leave the contract without an owner.
220    * It will not be possible to call the functions with the `onlyOwner`
221    * modifier anymore.
222    */
223   function renounceOwnership() public onlyOwner {
224     emit OwnershipRenounced(owner);
225     owner = address(0);
226   }
227 
228   /**
229    * @dev Allows the current owner to transfer control of the contract to a newOwner.
230    * @param _newOwner The address to transfer ownership to.
231    */
232   function transferOwnership(address _newOwner) public onlyOwner {
233     _transferOwnership(_newOwner);
234   }
235 
236   /**
237    * @dev Transfers control of the contract to a newOwner.
238    * @param _newOwner The address to transfer ownership to.
239    */
240   function _transferOwnership(address _newOwner) internal {
241     require(_newOwner != address(0));
242     emit OwnershipTransferred(owner, _newOwner);
243     owner = _newOwner;
244   }
245 }
246 
247 // File: node_modules/zeppelin-solidity/contracts/ownership/Superuser.sol
248 
249 /**
250  * @title Superuser
251  * @dev The Superuser contract defines a single superuser who can transfer the ownership
252  * of a contract to a new address, even if he is not the owner.
253  * A superuser can transfer his role to a new address.
254  */
255 contract Superuser is Ownable, RBAC {
256   string public constant ROLE_SUPERUSER = "superuser";
257 
258   constructor () public {
259     addRole(msg.sender, ROLE_SUPERUSER);
260   }
261 
262   /**
263    * @dev Throws if called by any account that's not a superuser.
264    */
265   modifier onlySuperuser() {
266     checkRole(msg.sender, ROLE_SUPERUSER);
267     _;
268   }
269 
270   modifier onlyOwnerOrSuperuser() {
271     require(msg.sender == owner || isSuperuser(msg.sender));
272     _;
273   }
274 
275   /**
276    * @dev getter to determine if address has superuser role
277    */
278   function isSuperuser(address _addr)
279     public
280     view
281     returns (bool)
282   {
283     return hasRole(_addr, ROLE_SUPERUSER);
284   }
285 
286   /**
287    * @dev Allows the current superuser to transfer his role to a newSuperuser.
288    * @param _newSuperuser The address to transfer ownership to.
289    */
290   function transferSuperuser(address _newSuperuser) public onlySuperuser {
291     require(_newSuperuser != address(0));
292     removeRole(msg.sender, ROLE_SUPERUSER);
293     addRole(_newSuperuser, ROLE_SUPERUSER);
294   }
295 
296   /**
297    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
298    * @param _newOwner The address to transfer ownership to.
299    */
300   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
301     _transferOwnership(_newOwner);
302   }
303 }
304 
305 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
306 
307 /**
308  * @title ERC20Basic
309  * @dev Simpler version of ERC20 interface
310  * See https://github.com/ethereum/EIPs/issues/179
311  */
312 contract ERC20Basic {
313   function totalSupply() public view returns (uint256);
314   function balanceOf(address _who) public view returns (uint256);
315   function transfer(address _to, uint256 _value) public returns (bool);
316   event Transfer(address indexed from, address indexed to, uint256 value);
317 }
318 
319 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
320 
321 /**
322  * @title ERC20 interface
323  * @dev see https://github.com/ethereum/EIPs/issues/20
324  */
325 contract ERC20 is ERC20Basic {
326   function allowance(address _owner, address _spender)
327     public view returns (uint256);
328 
329   function transferFrom(address _from, address _to, uint256 _value)
330     public returns (bool);
331 
332   function approve(address _spender, uint256 _value) public returns (bool);
333   event Approval(
334     address indexed owner,
335     address indexed spender,
336     uint256 value
337   );
338 }
339 
340 // File: node_modules/zeppelin-solidity/contracts/introspection/ERC165.sol
341 
342 /**
343  * @title ERC165
344  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
345  */
346 interface ERC165 {
347 
348   /**
349    * @notice Query if a contract implements an interface
350    * @param _interfaceId The interface identifier, as specified in ERC-165
351    * @dev Interface identification is specified in ERC-165. This function
352    * uses less than 30,000 gas.
353    */
354   function supportsInterface(bytes4 _interfaceId)
355     external
356     view
357     returns (bool);
358 }
359 
360 // File: node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
361 
362 /**
363  * @title ERC721 Non-Fungible Token Standard basic interface
364  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
365  */
366 contract ERC721Basic is ERC165 {
367 
368   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
369   /*
370    * 0x80ac58cd ===
371    *   bytes4(keccak256('balanceOf(address)')) ^
372    *   bytes4(keccak256('ownerOf(uint256)')) ^
373    *   bytes4(keccak256('approve(address,uint256)')) ^
374    *   bytes4(keccak256('getApproved(uint256)')) ^
375    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
376    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
377    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
378    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
379    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
380    */
381 
382   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
383   /*
384    * 0x4f558e79 ===
385    *   bytes4(keccak256('exists(uint256)'))
386    */
387 
388   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
389   /**
390    * 0x780e9d63 ===
391    *   bytes4(keccak256('totalSupply()')) ^
392    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
393    *   bytes4(keccak256('tokenByIndex(uint256)'))
394    */
395 
396   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
397   /**
398    * 0x5b5e139f ===
399    *   bytes4(keccak256('name()')) ^
400    *   bytes4(keccak256('symbol()')) ^
401    *   bytes4(keccak256('tokenURI(uint256)'))
402    */
403 
404   event Transfer(
405     address indexed _from,
406     address indexed _to,
407     uint256 indexed _tokenId
408   );
409   event Approval(
410     address indexed _owner,
411     address indexed _approved,
412     uint256 indexed _tokenId
413   );
414   event ApprovalForAll(
415     address indexed _owner,
416     address indexed _operator,
417     bool _approved
418   );
419 
420   function balanceOf(address _owner) public view returns (uint256 _balance);
421   function ownerOf(uint256 _tokenId) public view returns (address _owner);
422   function exists(uint256 _tokenId) public view returns (bool _exists);
423 
424   function approve(address _to, uint256 _tokenId) public;
425   function getApproved(uint256 _tokenId)
426     public view returns (address _operator);
427 
428   function setApprovalForAll(address _operator, bool _approved) public;
429   function isApprovedForAll(address _owner, address _operator)
430     public view returns (bool);
431 
432   function transferFrom(address _from, address _to, uint256 _tokenId) public;
433   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
434     public;
435 
436   function safeTransferFrom(
437     address _from,
438     address _to,
439     uint256 _tokenId,
440     bytes _data
441   )
442     public;
443 }
444 
445 // File: node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721.sol
446 
447 /**
448  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
449  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
450  */
451 contract ERC721Enumerable is ERC721Basic {
452   function totalSupply() public view returns (uint256);
453   function tokenOfOwnerByIndex(
454     address _owner,
455     uint256 _index
456   )
457     public
458     view
459     returns (uint256 _tokenId);
460 
461   function tokenByIndex(uint256 _index) public view returns (uint256);
462 }
463 
464 
465 /**
466  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
467  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
468  */
469 contract ERC721Metadata is ERC721Basic {
470   function name() external view returns (string _name);
471   function symbol() external view returns (string _symbol);
472   function tokenURI(uint256 _tokenId) public view returns (string);
473 }
474 
475 
476 /**
477  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
478  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
479  */
480 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
481 }
482 
483 // File: contracts/lib/SafeMath.sol
484 
485 /**
486  * @title SafeMath
487  */
488 library SafeMath {
489   /**
490   * @dev Integer division of two numbers, truncating the quotient.
491   */
492   function div(uint256 a, uint256 b) internal pure returns (uint256) {
493     // assert(b > 0); // Solidity automatically throws when dividing by 0
494     // uint256 c = a / b;
495     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
496     return a / b;
497   }
498 
499   /**
500   * @dev Multiplies two numbers, throws on overflow.
501   */
502   function mul(uint256 a, uint256 b) 
503       internal 
504       pure 
505       returns (uint256 c) 
506   {
507     if (a == 0) {
508       return 0;
509     }
510     c = a * b;
511     require(c / a == b, "SafeMath mul failed");
512     return c;
513   }
514 
515   /**
516   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
517   */
518   function sub(uint256 a, uint256 b)
519       internal
520       pure
521       returns (uint256) 
522   {
523     require(b <= a, "SafeMath sub failed");
524     return a - b;
525   }
526 
527   /**
528   * @dev Adds two numbers, throws on overflow.
529   */
530   function add(uint256 a, uint256 b)
531       internal
532       pure
533       returns (uint256 c) 
534   {
535     c = a + b;
536     require(c >= a, "SafeMath add failed");
537     return c;
538   }
539   
540   /**
541     * @dev gives square root of given x.
542     */
543   function sqrt(uint256 x)
544       internal
545       pure
546       returns (uint256 y) 
547   {
548     uint256 z = ((add(x,1)) / 2);
549     y = x;
550     while (z < y) 
551     {
552       y = z;
553       z = ((add((x / z),z)) / 2);
554     }
555   }
556   
557   /**
558     * @dev gives square. batchplies x by x
559     */
560   function sq(uint256 x)
561       internal
562       pure
563       returns (uint256)
564   {
565     return (mul(x,x));
566   }
567   
568   /**
569     * @dev x to the power of y 
570     */
571   function pwr(uint256 x, uint256 y)
572       internal 
573       pure 
574       returns (uint256)
575   {
576     if (x==0)
577         return (0);
578     else if (y==0)
579         return (1);
580     else 
581     {
582       uint256 z = x;
583       for (uint256 i=1; i < y; i++)
584         z = mul(z,x);
585       return (z);
586     }
587   }
588 }
589 
590 // File: contracts/crowdsale/INFTsCrowdsale.sol
591 
592 /**
593  * @title -NFTs crowdsale Interface
594  */
595 
596 interface INFTsCrowdsale {
597 
598   function getAuction(uint256 tokenId) external view
599   returns (
600     bytes32,
601     address,
602     uint256,
603     uint256,
604     uint256,
605     uint256
606   );
607 
608   function isOnAuction(uint256 tokenId) external view returns (bool);
609 
610   function isOnPreAuction(uint256 tokenId) external view returns (bool);
611 
612   function newAuction(uint128 price, uint256 tokenId, uint256 startAt, uint256 endAt) external;
613 
614   function batchNewAuctions(uint128[] prices, uint256[] tokenIds, uint256[] startAts, uint256[] endAts) external;
615 
616   function payByEth (uint256 tokenId) external payable; 
617 
618   function payByErc20 (uint256 tokenId) external;
619 
620   function cancelAuction (uint256 tokenId) external;
621 
622   function batchCancelAuctions (uint256[] tokenIds) external;
623   
624   /* Events */
625 
626   event NewAuction (
627     bytes32 id,
628     address indexed seller,
629     uint256 price,
630     uint256 startAt,
631     uint256 endAt,
632     uint256 indexed tokenId
633   );
634 
635   event PayByEth (
636     bytes32 id,
637     address indexed seller,
638     address indexed buyer,
639     uint256 price,
640     uint256 endAt,
641     uint256 indexed tokenId
642   );
643 
644   event PayByErc20 (
645     bytes32 id,
646     address indexed seller,
647     address indexed buyer, 
648     uint256 price,
649     uint256 endAt,
650     uint256 indexed tokenId
651   );
652 
653   event CancelAuction (
654     bytes32 id,
655     address indexed seller,
656     uint256 indexed tokenId
657   );
658 
659 }
660 
661 // File: contracts/crowdsale/NFTsCrowdsaleBase.sol
662 
663 contract NFTsCrowdsaleBase is Superuser, INFTsCrowdsale {
664 
665   using SafeMath for uint256;
666 
667   ERC20 public erc20Contract;
668   ERC721 public erc721Contract;
669   // eth(price)/erc20(price)
670   uint public eth2erc20;
671   // Represents a auction
672   struct Auction {
673     bytes32 id; // Auction id
674     address seller; // Seller
675     uint256 price; // eth in wei
676     uint256 startAt; //  Auction startAt
677     uint256 endAt; //  Auction endAt
678     uint256 tokenId; // ERC721 tokenId 
679   }
680 
681   mapping (uint256 => Auction) tokenIdToAuction;
682   
683   constructor(address _erc721Address,address _erc20Address, uint _eth2erc20) public {
684     erc721Contract = ERC721(_erc721Address);
685     erc20Contract = ERC20(_erc20Address);
686     eth2erc20 = _eth2erc20;
687   }
688 
689   function getAuction(uint256 _tokenId) external view
690   returns (
691     bytes32,
692     address,
693     uint256,
694     uint256,
695     uint256,
696     uint256
697   ){
698     Auction storage auction = tokenIdToAuction[_tokenId];
699     return (auction.id, auction.seller, auction.price, auction.startAt, auction.endAt, auction.tokenId);
700   }
701 
702   function isOnAuction(uint256 _tokenId) external view returns (bool) {
703     Auction storage _auction = tokenIdToAuction[_tokenId];
704     uint256 time = block.timestamp;
705     return (time < _auction.endAt && time > _auction.startAt);
706   }
707 
708   function isOnPreAuction(uint256 _tokenId) external view returns (bool) {
709     Auction storage _auction = tokenIdToAuction[_tokenId];
710     return (block.timestamp < _auction.startAt);
711   }
712 
713   function _isTokenOwner(address _seller, uint256 _tokenId) internal view returns (bool){
714     return (erc721Contract.ownerOf(_tokenId) == _seller);
715   }
716 
717   function _isOnAuction(uint256 _tokenId) internal view returns (bool) {
718     Auction storage _auction = tokenIdToAuction[_tokenId];
719     uint256 time = block.timestamp;
720     return (time < _auction.endAt && time > _auction.startAt);
721   }
722   function _escrow(address _owner, uint256 _tokenId) internal {
723     erc721Contract.transferFrom(_owner, this, _tokenId);
724   }
725 
726   function _cancelEscrow(address _owner, uint256 _tokenId) internal {
727     erc721Contract.transferFrom(this, _owner, _tokenId);
728   }
729 
730   function _transfer(address _receiver, uint256 _tokenId) internal {
731     erc721Contract.safeTransferFrom(this, _receiver, _tokenId);
732   }
733 
734   function _newAuction(uint256 _price, uint256 _tokenId, uint256 _startAt, uint256 _endAt) internal {
735     require(_price == uint256(_price));
736     address _seller = msg.sender;
737 
738     require(_isTokenOwner(_seller, _tokenId));
739     _escrow(_seller, _tokenId);
740 
741     bytes32 auctionId = keccak256(
742       abi.encodePacked(block.timestamp, _seller, _tokenId, _price)
743     );
744     
745     Auction memory _order = Auction(
746       auctionId,
747       _seller,
748       uint128(_price),
749       _startAt,
750       _endAt,
751       _tokenId
752     );
753 
754     tokenIdToAuction[_tokenId] = _order;
755     emit NewAuction(auctionId, _seller, _price, _startAt, _endAt, _tokenId);
756   }
757 
758   function _cancelAuction(uint256 _tokenId) internal {
759     Auction storage _auction = tokenIdToAuction[_tokenId];
760     require(_auction.seller == msg.sender || msg.sender == owner);
761     emit CancelAuction(_auction.id, _auction.seller, _tokenId);
762     _cancelEscrow(_auction.seller, _tokenId);
763     delete tokenIdToAuction[_tokenId];
764   }
765 
766   function _payByEth(uint256 _tokenId) internal {
767     uint256 _ethAmount = msg.value;
768     Auction storage _auction = tokenIdToAuction[_tokenId];
769     uint256 price = _auction.price;
770     require(_isOnAuction(_auction.tokenId));
771     require(_ethAmount >= price);
772 
773     uint256 payExcess = _ethAmount.sub(price);
774 
775     if (price > 0) {
776       _auction.seller.transfer(price);
777     }
778     address buyer = msg.sender;
779     buyer.transfer(payExcess);
780     _transfer(buyer, _tokenId);
781     emit PayByEth(_auction.id, _auction.seller, msg.sender, _auction.price, _auction.endAt, _auction.tokenId);
782     delete tokenIdToAuction[_tokenId];
783   }
784 
785   function _payByErc20(uint256 _tokenId) internal {
786 
787     Auction storage _auction = tokenIdToAuction[_tokenId];
788     uint256 price = uint256(_auction.price);
789     uint256 computedErc20Price = price.mul(eth2erc20);
790     uint256 balance = erc20Contract.balanceOf(msg.sender);
791     require(balance >= computedErc20Price);
792     require(_isOnAuction(_auction.tokenId));
793 
794     if (price > 0) {
795       erc20Contract.transferFrom(msg.sender, _auction.seller, computedErc20Price);
796     }
797     _transfer(msg.sender, _tokenId);
798     emit PayByErc20(_auction.id, _auction.seller, msg.sender, _auction.price, _auction.endAt, _auction.tokenId);
799     delete tokenIdToAuction[_tokenId];
800   }
801   
802 }
803 
804 // File: contracts/crowdsale/Pausable.sol
805 
806 /**
807  * @title Pausable
808  * @dev Base contract which allows children to implement an emergency stop mechanism.
809  */
810 contract Pausable is Ownable {
811   event Pause();
812   event Unpause();
813 
814   event Pause2();
815   event Unpause2();
816 
817   bool public paused = false;
818   bool public paused2 = false;
819 
820 
821   /**
822    * @dev Modifier to make a function callable only when the contract is not paused.
823    */
824   modifier whenNotPaused() {
825     require(!paused);
826     _;
827   }
828 
829   modifier whenNotPaused2() {
830     require(!paused2);
831     _;
832   }
833 
834   /**
835    * @dev Modifier to make a function callable only when the contract is paused.
836    */
837   modifier whenPaused() {
838     require(paused);
839     _;
840   }
841 
842   modifier whenPaused2() {
843     require(paused2);
844     _;
845   }
846 
847   /**
848    * @dev called by the owner to pause, triggers stopped state
849    */
850   function pause() public onlyOwner whenNotPaused {
851     paused = true;
852     emit Pause();
853   }
854 
855   function pause2() public onlyOwner whenNotPaused2 {
856     paused2 = true;
857     emit Pause2();
858   }
859 
860   /**
861    * @dev called by the owner to unpause, returns to normal state
862    */
863   function unpause() public onlyOwner whenPaused {
864     paused = false;
865     emit Unpause();
866   }
867 
868   function unpause2() public onlyOwner whenPaused2 {
869     paused2 = false;
870     emit Unpause2();
871   }
872 }
873 
874 // File: contracts/crowdsale/NFTsCrowdsale.sol
875 
876 contract NFTsCrowdsale is NFTsCrowdsaleBase, Pausable {
877 
878   constructor(address erc721Address, address erc20Address, uint eth2erc20) public 
879   NFTsCrowdsaleBase(erc721Address, erc20Address, eth2erc20){}
880 
881   /**
882    * @dev new a Auction
883    * @param price price in wei
884    * @param tokenId Tavern's tokenid
885    * @param endAt auction end time
886    */
887   function newAuction(uint128 price, uint256 tokenId, uint256 startAt, uint256 endAt) whenNotPaused external {
888     uint256 _startAt = startAt;
889     if (msg.sender != owner) {
890       _startAt = block.timestamp;
891     }
892     _newAuction(price, tokenId, _startAt, endAt);
893   }
894 
895   /**
896    * @dev batch New Auctions 
897    * @param prices Array price in wei
898    * @param tokenIds Array Tavern's tokenid
899    * @param endAts  Array auction end time
900    */
901   function batchNewAuctions(uint128[] prices, uint256[] tokenIds, uint256[] startAts, uint256[] endAts) whenNotPaused external {
902     uint256 i = 0;
903     while (i < tokenIds.length) {
904       _newAuction(prices[i], tokenIds[i], startAts[i], endAts[i]);
905       i += 1;
906     }
907   }
908 
909   /**
910    * @dev pay a auction by eth
911    * @param tokenId tavern tokenid
912    */
913   function payByEth (uint256 tokenId) whenNotPaused external payable {
914     _payByEth(tokenId); 
915   }
916 
917   /**
918    * @dev pay a auction by erc20 Token
919    * @param tokenId Tavern's tokenid
920    */
921   function payByErc20 (uint256 tokenId) whenNotPaused2 external {
922     _payByErc20(tokenId);
923   }
924 
925   /**
926    * @dev cancel a auction
927    * @param tokenId Tavern's tokenid
928    */
929   function cancelAuction (uint256 tokenId) external {
930     _cancelAuction(tokenId);
931   }
932 
933   /**
934    * @dev batch cancel auctions
935    * @param tokenIds Array Tavern's tokenid
936    */
937   function batchCancelAuctions (uint256[] tokenIds) external {
938     uint256 i = 0;
939     while (i < tokenIds.length) {
940       _cancelAuction(tokenIds[i]);
941       i += 1;
942     }
943   }
944 }