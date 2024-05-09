1 //  linear star release
2 //  https://azimuth.network
3 
4 pragma solidity 0.4.24;
5 
6 ////////////////////////////////////////////////////////////////////////////////
7 //  Imports
8 ////////////////////////////////////////////////////////////////////////////////
9 
10 // OpenZeppelin's Ownable.sol
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipRenounced(address indexed previousOwner);
22   event OwnershipTransferred(
23     address indexed previousOwner,
24     address indexed newOwner
25   );
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   constructor() public {
33     owner = msg.sender;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    * @notice Renouncing to ownership will leave the contract without an owner.
47    * It will not be possible to call the functions with the `onlyOwner`
48    * modifier anymore.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address _newOwner) public onlyOwner {
60     _transferOwnership(_newOwner);
61   }
62 
63   /**
64    * @dev Transfers control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function _transferOwnership(address _newOwner) internal {
68     require(_newOwner != address(0));
69     emit OwnershipTransferred(owner, _newOwner);
70     owner = _newOwner;
71   }
72 }
73 
74 // Azimuth's SafeMath8.sol
75 
76 /**
77  * @title SafeMath8
78  * @dev Math operations for uint8 with safety checks that throw on error
79  */
80 library SafeMath8 {
81   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
82     uint8 c = a * b;
83     assert(a == 0 || c / a == b);
84     return c;
85   }
86 
87   function div(uint8 a, uint8 b) internal pure returns (uint8) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint8 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint8 a, uint8 b) internal pure returns (uint8) {
100     uint8 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 // Azimuth's SafeMath16.sol
107 
108 /**
109  * @title SafeMath16
110  * @dev Math operations for uint16 with safety checks that throw on error
111  */
112 library SafeMath16 {
113   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
114     uint16 c = a * b;
115     assert(a == 0 || c / a == b);
116     return c;
117   }
118 
119   function div(uint16 a, uint16 b) internal pure returns (uint16) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     uint16 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return c;
124   }
125 
126   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
127     assert(b <= a);
128     return a - b;
129   }
130 
131   function add(uint16 a, uint16 b) internal pure returns (uint16) {
132     uint16 c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 }
137 
138 // OpenZeppelin's SafeMath.sol
139 
140 /**
141  * @title SafeMath
142  * @dev Math operations with safety checks that throw on error
143  */
144 library SafeMath {
145 
146   /**
147   * @dev Multiplies two numbers, throws on overflow.
148   */
149   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
150     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
151     // benefit is lost if 'b' is also tested.
152     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
153     if (_a == 0) {
154       return 0;
155     }
156 
157     c = _a * _b;
158     assert(c / _a == _b);
159     return c;
160   }
161 
162   /**
163   * @dev Integer division of two numbers, truncating the quotient.
164   */
165   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
166     // assert(_b > 0); // Solidity automatically throws when dividing by 0
167     // uint256 c = _a / _b;
168     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
169     return _a / _b;
170   }
171 
172   /**
173   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
174   */
175   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
176     assert(_b <= _a);
177     return _a - _b;
178   }
179 
180   /**
181   * @dev Adds two numbers, throws on overflow.
182   */
183   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
184     c = _a + _b;
185     assert(c >= _a);
186     return c;
187   }
188 }
189 
190 // OpenZeppelin's ERC165.sol
191 
192 /**
193  * @title ERC165
194  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
195  */
196 interface ERC165 {
197 
198   /**
199    * @notice Query if a contract implements an interface
200    * @param _interfaceId The interface identifier, as specified in ERC-165
201    * @dev Interface identification is specified in ERC-165. This function
202    * uses less than 30,000 gas.
203    */
204   function supportsInterface(bytes4 _interfaceId)
205     external
206     view
207     returns (bool);
208 }
209 
210 // OpenZeppelin's SupportsInterfaceWithLookup.sol
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
262 // OpenZeppelin's ERC721Basic.sol
263 
264 /**
265  * @title ERC721 Non-Fungible Token Standard basic interface
266  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
267  */
268 contract ERC721Basic is ERC165 {
269 
270   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
271   /*
272    * 0x80ac58cd ===
273    *   bytes4(keccak256('balanceOf(address)')) ^
274    *   bytes4(keccak256('ownerOf(uint256)')) ^
275    *   bytes4(keccak256('approve(address,uint256)')) ^
276    *   bytes4(keccak256('getApproved(uint256)')) ^
277    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
278    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
279    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
280    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
281    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
282    */
283 
284   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
285   /*
286    * 0x4f558e79 ===
287    *   bytes4(keccak256('exists(uint256)'))
288    */
289 
290   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
291   /**
292    * 0x780e9d63 ===
293    *   bytes4(keccak256('totalSupply()')) ^
294    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
295    *   bytes4(keccak256('tokenByIndex(uint256)'))
296    */
297 
298   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
299   /**
300    * 0x5b5e139f ===
301    *   bytes4(keccak256('name()')) ^
302    *   bytes4(keccak256('symbol()')) ^
303    *   bytes4(keccak256('tokenURI(uint256)'))
304    */
305 
306   event Transfer(
307     address indexed _from,
308     address indexed _to,
309     uint256 indexed _tokenId
310   );
311   event Approval(
312     address indexed _owner,
313     address indexed _approved,
314     uint256 indexed _tokenId
315   );
316   event ApprovalForAll(
317     address indexed _owner,
318     address indexed _operator,
319     bool _approved
320   );
321 
322   function balanceOf(address _owner) public view returns (uint256 _balance);
323   function ownerOf(uint256 _tokenId) public view returns (address _owner);
324   function exists(uint256 _tokenId) public view returns (bool _exists);
325 
326   function approve(address _to, uint256 _tokenId) public;
327   function getApproved(uint256 _tokenId)
328     public view returns (address _operator);
329 
330   function setApprovalForAll(address _operator, bool _approved) public;
331   function isApprovedForAll(address _owner, address _operator)
332     public view returns (bool);
333 
334   function transferFrom(address _from, address _to, uint256 _tokenId) public;
335   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
336     public;
337 
338   function safeTransferFrom(
339     address _from,
340     address _to,
341     uint256 _tokenId,
342     bytes _data
343   )
344     public;
345 }
346 
347 // OpenZeppelin's ERC721.sol
348 
349 /**
350  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
351  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
352  */
353 contract ERC721Enumerable is ERC721Basic {
354   function totalSupply() public view returns (uint256);
355   function tokenOfOwnerByIndex(
356     address _owner,
357     uint256 _index
358   )
359     public
360     view
361     returns (uint256 _tokenId);
362 
363   function tokenByIndex(uint256 _index) public view returns (uint256);
364 }
365 
366 
367 /**
368  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
369  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
370  */
371 contract ERC721Metadata is ERC721Basic {
372   function name() external view returns (string _name);
373   function symbol() external view returns (string _symbol);
374   function tokenURI(uint256 _tokenId) public view returns (string);
375 }
376 
377 
378 /**
379  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
380  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
381  */
382 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
383 }
384 
385 // OpenZeppelin's ERC721Receiver.sol
386 
387 /**
388  * @title ERC721 token receiver interface
389  * @dev Interface for any contract that wants to support safeTransfers
390  * from ERC721 asset contracts.
391  */
392 contract ERC721Receiver {
393   /**
394    * @dev Magic value to be returned upon successful reception of an NFT
395    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
396    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
397    */
398   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
399 
400   /**
401    * @notice Handle the receipt of an NFT
402    * @dev The ERC721 smart contract calls this function on the recipient
403    * after a `safetransfer`. This function MAY throw to revert and reject the
404    * transfer. Return of other than the magic value MUST result in the
405    * transaction being reverted.
406    * Note: the contract address is always the message sender.
407    * @param _operator The address which called `safeTransferFrom` function
408    * @param _from The address which previously owned the token
409    * @param _tokenId The NFT identifier which is being transferred
410    * @param _data Additional data with no specified format
411    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
412    */
413   function onERC721Received(
414     address _operator,
415     address _from,
416     uint256 _tokenId,
417     bytes _data
418   )
419     public
420     returns(bytes4);
421 }
422 
423 // OpenZeppelin's AddressUtils.sol
424 
425 /**
426  * Utility library of inline functions on addresses
427  */
428 library AddressUtils {
429 
430   /**
431    * Returns whether the target address is a contract
432    * @dev This function will return false if invoked during the constructor of a contract,
433    * as the code is not actually created until after the constructor finishes.
434    * @param _addr address to check
435    * @return whether the target address is a contract
436    */
437   function isContract(address _addr) internal view returns (bool) {
438     uint256 size;
439     // XXX Currently there is no better way to check if there is a contract in an address
440     // than to check the size of the code at that address.
441     // See https://ethereum.stackexchange.com/a/14016/36603
442     // for more details about how this works.
443     // TODO Check this again before the Serenity release, because all addresses will be
444     // contracts then.
445     // solium-disable-next-line security/no-inline-assembly
446     assembly { size := extcodesize(_addr) }
447     return size > 0;
448   }
449 
450 }
451 
452 // Azimuth's Azimuth.sol
453 
454 //  Azimuth: point state data contract
455 //
456 //    This contract is used for storing all data related to Azimuth points
457 //    and their ownership. Consider this contract the Azimuth ledger.
458 //
459 //    It also contains permissions data, which ties in to ERC721
460 //    functionality. Operators of an address are allowed to transfer
461 //    ownership of all points owned by their associated address
462 //    (ERC721's approveAll()). A transfer proxy is allowed to transfer
463 //    ownership of a single point (ERC721's approve()).
464 //    Separate from ERC721 are managers, assigned per point. They are
465 //    allowed to perform "low-impact" operations on the owner's points,
466 //    like configuring public keys and making escape requests.
467 //
468 //    Since data stores are difficult to upgrade, this contract contains
469 //    as little actual business logic as possible. Instead, the data stored
470 //    herein can only be modified by this contract's owner, which can be
471 //    changed and is thus upgradable/replaceable.
472 //
473 //    This contract will be owned by the Ecliptic contract.
474 //
475 contract Azimuth is Ownable
476 {
477 //
478 //  Events
479 //
480 
481   //  OwnerChanged: :point is now owned by :owner
482   //
483   event OwnerChanged(uint32 indexed point, address indexed owner);
484 
485   //  Activated: :point is now active
486   //
487   event Activated(uint32 indexed point);
488 
489   //  Spawned: :prefix has spawned :child
490   //
491   event Spawned(uint32 indexed prefix, uint32 indexed child);
492 
493   //  EscapeRequested: :point has requested a new :sponsor
494   //
495   event EscapeRequested(uint32 indexed point, uint32 indexed sponsor);
496 
497   //  EscapeCanceled: :point's :sponsor request was canceled or rejected
498   //
499   event EscapeCanceled(uint32 indexed point, uint32 indexed sponsor);
500 
501   //  EscapeAccepted: :point confirmed with a new :sponsor
502   //
503   event EscapeAccepted(uint32 indexed point, uint32 indexed sponsor);
504 
505   //  LostSponsor: :point's :sponsor is now refusing it service
506   //
507   event LostSponsor(uint32 indexed point, uint32 indexed sponsor);
508 
509   //  ChangedKeys: :point has new network public keys
510   //
511   event ChangedKeys( uint32 indexed point,
512                      bytes32 encryptionKey,
513                      bytes32 authenticationKey,
514                      uint32 cryptoSuiteVersion,
515                      uint32 keyRevisionNumber );
516 
517   //  BrokeContinuity: :point has a new continuity number, :number
518   //
519   event BrokeContinuity(uint32 indexed point, uint32 number);
520 
521   //  ChangedSpawnProxy: :spawnProxy can now spawn using :point
522   //
523   event ChangedSpawnProxy(uint32 indexed point, address indexed spawnProxy);
524 
525   //  ChangedTransferProxy: :transferProxy can now transfer ownership of :point
526   //
527   event ChangedTransferProxy( uint32 indexed point,
528                               address indexed transferProxy );
529 
530   //  ChangedManagementProxy: :managementProxy can now manage :point
531   //
532   event ChangedManagementProxy( uint32 indexed point,
533                                 address indexed managementProxy );
534 
535   //  ChangedVotingProxy: :votingProxy can now vote using :point
536   //
537   event ChangedVotingProxy(uint32 indexed point, address indexed votingProxy);
538 
539   //  ChangedDns: dnsDomains have been updated
540   //
541   event ChangedDns(string primary, string secondary, string tertiary);
542 
543 //
544 //  Structures
545 //
546 
547   //  Size: kinds of points registered on-chain
548   //
549   //    NOTE: the order matters, because of Solidity enum numbering
550   //
551   enum Size
552   {
553     Galaxy, // = 0
554     Star,   // = 1
555     Planet  // = 2
556   }
557 
558   //  Point: state of a point
559   //
560   //    While the ordering of the struct members is semantically chaotic,
561   //    they are ordered to tightly pack them into Ethereum's 32-byte storage
562   //    slots, which reduces gas costs for some function calls.
563   //    The comment ticks indicate assumed slot boundaries.
564   //
565   struct Point
566   {
567     //  encryptionKey: (curve25519) encryption public key, or 0 for none
568     //
569     bytes32 encryptionKey;
570   //
571     //  authenticationKey: (ed25519) authentication public key, or 0 for none
572     //
573     bytes32 authenticationKey;
574   //
575     //  spawned: for stars and galaxies, all :active children
576     //
577     uint32[] spawned;
578   //
579     //  hasSponsor: true if the sponsor still supports the point
580     //
581     bool hasSponsor;
582 
583     //  active: whether point can be linked
584     //
585     //    false: point belongs to prefix, cannot be configured or linked
586     //    true: point no longer belongs to prefix, can be configured and linked
587     //
588     bool active;
589 
590     //  escapeRequested: true if the point has requested to change sponsors
591     //
592     bool escapeRequested;
593 
594     //  sponsor: the point that supports this one on the network, or,
595     //           if :hasSponsor is false, the last point that supported it.
596     //           (by default, the point's half-width prefix)
597     //
598     uint32 sponsor;
599 
600     //  escapeRequestedTo: if :escapeRequested is true, new sponsor requested
601     //
602     uint32 escapeRequestedTo;
603 
604     //  cryptoSuiteVersion: version of the crypto suite used for the pubkeys
605     //
606     uint32 cryptoSuiteVersion;
607 
608     //  keyRevisionNumber: incremented every time the public keys change
609     //
610     uint32 keyRevisionNumber;
611 
612     //  continuityNumber: incremented to indicate network-side state loss
613     //
614     uint32 continuityNumber;
615   }
616 
617   //  Deed: permissions for a point
618   //
619   struct Deed
620   {
621     //  owner: address that owns this point
622     //
623     address owner;
624 
625     //  managementProxy: 0, or another address with the right to perform
626     //                   low-impact, managerial operations on this point
627     //
628     address managementProxy;
629 
630     //  spawnProxy: 0, or another address with the right to spawn children
631     //              of this point
632     //
633     address spawnProxy;
634 
635     //  votingProxy: 0, or another address with the right to vote as this point
636     //
637     address votingProxy;
638 
639     //  transferProxy: 0, or another address with the right to transfer
640     //                 ownership of this point
641     //
642     address transferProxy;
643   }
644 
645 //
646 //  General state
647 //
648 
649   //  points: per point, general network-relevant point state
650   //
651   mapping(uint32 => Point) public points;
652 
653   //  rights: per point, on-chain ownership and permissions
654   //
655   mapping(uint32 => Deed) public rights;
656 
657   //  operators: per owner, per address, has the right to transfer ownership
658   //             of all the owner's points (ERC721)
659   //
660   mapping(address => mapping(address => bool)) public operators;
661 
662   //  dnsDomains: base domains for contacting galaxies
663   //
664   //    dnsDomains[0] is primary, the others are used as fallbacks
665   //
666   string[3] public dnsDomains;
667 
668 //
669 //  Lookups
670 //
671 
672   //  sponsoring: per point, the points they are sponsoring
673   //
674   mapping(uint32 => uint32[]) public sponsoring;
675 
676   //  sponsoringIndexes: per point, per point, (index + 1) in
677   //                     the sponsoring array
678   //
679   mapping(uint32 => mapping(uint32 => uint256)) public sponsoringIndexes;
680 
681   //  escapeRequests: per point, the points they have open escape requests from
682   //
683   mapping(uint32 => uint32[]) public escapeRequests;
684 
685   //  escapeRequestsIndexes: per point, per point, (index + 1) in
686   //                         the escapeRequests array
687   //
688   mapping(uint32 => mapping(uint32 => uint256)) public escapeRequestsIndexes;
689 
690   //  pointsOwnedBy: per address, the points they own
691   //
692   mapping(address => uint32[]) public pointsOwnedBy;
693 
694   //  pointOwnerIndexes: per owner, per point, (index + 1) in
695   //                     the pointsOwnedBy array
696   //
697   //    We delete owners by moving the last entry in the array to the
698   //    newly emptied slot, which is (n - 1) where n is the value of
699   //    pointOwnerIndexes[owner][point].
700   //
701   mapping(address => mapping(uint32 => uint256)) public pointOwnerIndexes;
702 
703   //  managerFor: per address, the points they are the management proxy for
704   //
705   mapping(address => uint32[]) public managerFor;
706 
707   //  managerForIndexes: per address, per point, (index + 1) in
708   //                     the managerFor array
709   //
710   mapping(address => mapping(uint32 => uint256)) public managerForIndexes;
711 
712   //  spawningFor: per address, the points they can spawn with
713   //
714   mapping(address => uint32[]) public spawningFor;
715 
716   //  spawningForIndexes: per address, per point, (index + 1) in
717   //                      the spawningFor array
718   //
719   mapping(address => mapping(uint32 => uint256)) public spawningForIndexes;
720 
721   //  votingFor: per address, the points they can vote with
722   //
723   mapping(address => uint32[]) public votingFor;
724 
725   //  votingForIndexes: per address, per point, (index + 1) in
726   //                    the votingFor array
727   //
728   mapping(address => mapping(uint32 => uint256)) public votingForIndexes;
729 
730   //  transferringFor: per address, the points they can transfer
731   //
732   mapping(address => uint32[]) public transferringFor;
733 
734   //  transferringForIndexes: per address, per point, (index + 1) in
735   //                          the transferringFor array
736   //
737   mapping(address => mapping(uint32 => uint256)) public transferringForIndexes;
738 
739 //
740 //  Logic
741 //
742 
743   //  constructor(): configure default dns domains
744   //
745   constructor()
746     public
747   {
748     setDnsDomains("example.com", "example.com", "example.com");
749   }
750 
751   //  setDnsDomains(): set the base domains used for contacting galaxies
752   //
753   //    Note: since a string is really just a byte[], and Solidity can't
754   //    work with two-dimensional arrays yet, we pass in the three
755   //    domains as individual strings.
756   //
757   function setDnsDomains(string _primary, string _secondary, string _tertiary)
758     onlyOwner
759     public
760   {
761     dnsDomains[0] = _primary;
762     dnsDomains[1] = _secondary;
763     dnsDomains[2] = _tertiary;
764     emit ChangedDns(_primary, _secondary, _tertiary);
765   }
766 
767   //
768   //  Point reading
769   //
770 
771     //  isActive(): return true if _point is active
772     //
773     function isActive(uint32 _point)
774       view
775       external
776       returns (bool equals)
777     {
778       return points[_point].active;
779     }
780 
781     //  getKeys(): returns the public keys and their details, as currently
782     //             registered for _point
783     //
784     function getKeys(uint32 _point)
785       view
786       external
787       returns (bytes32 crypt, bytes32 auth, uint32 suite, uint32 revision)
788     {
789       Point storage point = points[_point];
790       return (point.encryptionKey,
791               point.authenticationKey,
792               point.cryptoSuiteVersion,
793               point.keyRevisionNumber);
794     }
795 
796     //  getKeyRevisionNumber(): gets the revision number of _point's current
797     //                          public keys
798     //
799     function getKeyRevisionNumber(uint32 _point)
800       view
801       external
802       returns (uint32 revision)
803     {
804       return points[_point].keyRevisionNumber;
805     }
806 
807     //  hasBeenLinked(): returns true if the point has ever been assigned keys
808     //
809     function hasBeenLinked(uint32 _point)
810       view
811       external
812       returns (bool result)
813     {
814       return ( points[_point].keyRevisionNumber > 0 );
815     }
816 
817     //  isLive(): returns true if _point currently has keys properly configured
818     //
819     function isLive(uint32 _point)
820       view
821       external
822       returns (bool result)
823     {
824       Point storage point = points[_point];
825       return ( point.encryptionKey != 0 &&
826                point.authenticationKey != 0 &&
827                point.cryptoSuiteVersion != 0 );
828     }
829 
830     //  getContinuityNumber(): returns _point's current continuity number
831     //
832     function getContinuityNumber(uint32 _point)
833       view
834       external
835       returns (uint32 continuityNumber)
836     {
837       return points[_point].continuityNumber;
838     }
839 
840     //  getSpawnCount(): return the number of children spawned by _point
841     //
842     function getSpawnCount(uint32 _point)
843       view
844       external
845       returns (uint32 spawnCount)
846     {
847       uint256 len = points[_point].spawned.length;
848       assert(len < 2**32);
849       return uint32(len);
850     }
851 
852     //  getSpawned(): return array of points created under _point
853     //
854     //    Note: only useful for clients, as Solidity does not currently
855     //    support returning dynamic arrays.
856     //
857     function getSpawned(uint32 _point)
858       view
859       external
860       returns (uint32[] spawned)
861     {
862       return points[_point].spawned;
863     }
864 
865     //  hasSponsor(): returns true if _point's sponsor is providing it service
866     //
867     function hasSponsor(uint32 _point)
868       view
869       external
870       returns (bool has)
871     {
872       return points[_point].hasSponsor;
873     }
874 
875     //  getSponsor(): returns _point's current (or most recent) sponsor
876     //
877     function getSponsor(uint32 _point)
878       view
879       external
880       returns (uint32 sponsor)
881     {
882       return points[_point].sponsor;
883     }
884 
885     //  isSponsor(): returns true if _sponsor is currently providing service
886     //               to _point
887     //
888     function isSponsor(uint32 _point, uint32 _sponsor)
889       view
890       external
891       returns (bool result)
892     {
893       Point storage point = points[_point];
894       return ( point.hasSponsor &&
895                (point.sponsor == _sponsor) );
896     }
897 
898     //  getSponsoringCount(): returns the number of points _sponsor is
899     //                        providing service to
900     //
901     function getSponsoringCount(uint32 _sponsor)
902       view
903       external
904       returns (uint256 count)
905     {
906       return sponsoring[_sponsor].length;
907     }
908 
909     //  getSponsoring(): returns a list of points _sponsor is providing
910     //                   service to
911     //
912     //    Note: only useful for clients, as Solidity does not currently
913     //    support returning dynamic arrays.
914     //
915     function getSponsoring(uint32 _sponsor)
916       view
917       external
918       returns (uint32[] sponsees)
919     {
920       return sponsoring[_sponsor];
921     }
922 
923     //  escaping
924 
925     //  isEscaping(): returns true if _point has an outstanding escape request
926     //
927     function isEscaping(uint32 _point)
928       view
929       external
930       returns (bool escaping)
931     {
932       return points[_point].escapeRequested;
933     }
934 
935     //  getEscapeRequest(): returns _point's current escape request
936     //
937     //    the returned escape request is only valid as long as isEscaping()
938     //    returns true
939     //
940     function getEscapeRequest(uint32 _point)
941       view
942       external
943       returns (uint32 escape)
944     {
945       return points[_point].escapeRequestedTo;
946     }
947 
948     //  isRequestingEscapeTo(): returns true if _point has an outstanding
949     //                          escape request targetting _sponsor
950     //
951     function isRequestingEscapeTo(uint32 _point, uint32 _sponsor)
952       view
953       public
954       returns (bool equals)
955     {
956       Point storage point = points[_point];
957       return (point.escapeRequested && (point.escapeRequestedTo == _sponsor));
958     }
959 
960     //  getEscapeRequestsCount(): returns the number of points _sponsor
961     //                            is providing service to
962     //
963     function getEscapeRequestsCount(uint32 _sponsor)
964       view
965       external
966       returns (uint256 count)
967     {
968       return escapeRequests[_sponsor].length;
969     }
970 
971     //  getEscapeRequests(): get the points _sponsor has received escape
972     //                       requests from
973     //
974     //    Note: only useful for clients, as Solidity does not currently
975     //    support returning dynamic arrays.
976     //
977     function getEscapeRequests(uint32 _sponsor)
978       view
979       external
980       returns (uint32[] requests)
981     {
982       return escapeRequests[_sponsor];
983     }
984 
985   //
986   //  Point writing
987   //
988 
989     //  activatePoint(): activate a point, register it as spawned by its prefix
990     //
991     function activatePoint(uint32 _point)
992       onlyOwner
993       external
994     {
995       //  make a point active, setting its sponsor to its prefix
996       //
997       Point storage point = points[_point];
998       require(!point.active);
999       point.active = true;
1000       registerSponsor(_point, true, getPrefix(_point));
1001       emit Activated(_point);
1002     }
1003 
1004     //  setKeys(): set network public keys of _point to _encryptionKey and
1005     //            _authenticationKey, with the specified _cryptoSuiteVersion
1006     //
1007     function setKeys(uint32 _point,
1008                      bytes32 _encryptionKey,
1009                      bytes32 _authenticationKey,
1010                      uint32 _cryptoSuiteVersion)
1011       onlyOwner
1012       external
1013     {
1014       Point storage point = points[_point];
1015       if ( point.encryptionKey == _encryptionKey &&
1016            point.authenticationKey == _authenticationKey &&
1017            point.cryptoSuiteVersion == _cryptoSuiteVersion )
1018       {
1019         return;
1020       }
1021 
1022       point.encryptionKey = _encryptionKey;
1023       point.authenticationKey = _authenticationKey;
1024       point.cryptoSuiteVersion = _cryptoSuiteVersion;
1025       point.keyRevisionNumber++;
1026 
1027       emit ChangedKeys(_point,
1028                        _encryptionKey,
1029                        _authenticationKey,
1030                        _cryptoSuiteVersion,
1031                        point.keyRevisionNumber);
1032     }
1033 
1034     //  incrementContinuityNumber(): break continuity for _point
1035     //
1036     function incrementContinuityNumber(uint32 _point)
1037       onlyOwner
1038       external
1039     {
1040       Point storage point = points[_point];
1041       point.continuityNumber++;
1042       emit BrokeContinuity(_point, point.continuityNumber);
1043     }
1044 
1045     //  registerSpawn(): add a point to its prefix's list of spawned points
1046     //
1047     function registerSpawned(uint32 _point)
1048       onlyOwner
1049       external
1050     {
1051       //  if a point is its own prefix (a galaxy) then don't register it
1052       //
1053       uint32 prefix = getPrefix(_point);
1054       if (prefix == _point)
1055       {
1056         return;
1057       }
1058 
1059       //  register a new spawned point for the prefix
1060       //
1061       points[prefix].spawned.push(_point);
1062       emit Spawned(prefix, _point);
1063     }
1064 
1065     //  loseSponsor(): indicates that _point's sponsor is no longer providing
1066     //                 it service
1067     //
1068     function loseSponsor(uint32 _point)
1069       onlyOwner
1070       external
1071     {
1072       Point storage point = points[_point];
1073       if (!point.hasSponsor)
1074       {
1075         return;
1076       }
1077       registerSponsor(_point, false, point.sponsor);
1078       emit LostSponsor(_point, point.sponsor);
1079     }
1080 
1081     //  setEscapeRequest(): for _point, start an escape request to _sponsor
1082     //
1083     function setEscapeRequest(uint32 _point, uint32 _sponsor)
1084       onlyOwner
1085       external
1086     {
1087       if (isRequestingEscapeTo(_point, _sponsor))
1088       {
1089         return;
1090       }
1091       registerEscapeRequest(_point, true, _sponsor);
1092       emit EscapeRequested(_point, _sponsor);
1093     }
1094 
1095     //  cancelEscape(): for _point, stop the current escape request, if any
1096     //
1097     function cancelEscape(uint32 _point)
1098       onlyOwner
1099       external
1100     {
1101       Point storage point = points[_point];
1102       if (!point.escapeRequested)
1103       {
1104         return;
1105       }
1106       uint32 request = point.escapeRequestedTo;
1107       registerEscapeRequest(_point, false, 0);
1108       emit EscapeCanceled(_point, request);
1109     }
1110 
1111     //  doEscape(): perform the requested escape
1112     //
1113     function doEscape(uint32 _point)
1114       onlyOwner
1115       external
1116     {
1117       Point storage point = points[_point];
1118       require(point.escapeRequested);
1119       registerSponsor(_point, true, point.escapeRequestedTo);
1120       registerEscapeRequest(_point, false, 0);
1121       emit EscapeAccepted(_point, point.sponsor);
1122     }
1123 
1124   //
1125   //  Point utils
1126   //
1127 
1128     //  getPrefix(): compute prefix ("parent") of _point
1129     //
1130     function getPrefix(uint32 _point)
1131       pure
1132       public
1133       returns (uint16 prefix)
1134     {
1135       if (_point < 0x10000)
1136       {
1137         return uint16(_point % 0x100);
1138       }
1139       return uint16(_point % 0x10000);
1140     }
1141 
1142     //  getPointSize(): return the size of _point
1143     //
1144     function getPointSize(uint32 _point)
1145       external
1146       pure
1147       returns (Size _size)
1148     {
1149       if (_point < 0x100) return Size.Galaxy;
1150       if (_point < 0x10000) return Size.Star;
1151       return Size.Planet;
1152     }
1153 
1154     //  internal use
1155 
1156     //  registerSponsor(): set the sponsorship state of _point and update the
1157     //                     reverse lookup for sponsors
1158     //
1159     function registerSponsor(uint32 _point, bool _hasSponsor, uint32 _sponsor)
1160       internal
1161     {
1162       Point storage point = points[_point];
1163       bool had = point.hasSponsor;
1164       uint32 prev = point.sponsor;
1165 
1166       //  if we didn't have a sponsor, and won't get one,
1167       //  or if we get the sponsor we already have,
1168       //  nothing will change, so jump out early.
1169       //
1170       if ( (!had && !_hasSponsor) ||
1171            (had && _hasSponsor && prev == _sponsor) )
1172       {
1173         return;
1174       }
1175 
1176       //  if the point used to have a different sponsor, do some gymnastics
1177       //  to keep the reverse lookup gapless.  delete the point from the old
1178       //  sponsor's list, then fill that gap with the list tail.
1179       //
1180       if (had)
1181       {
1182         //  i: current index in previous sponsor's list of sponsored points
1183         //
1184         uint256 i = sponsoringIndexes[prev][_point];
1185 
1186         //  we store index + 1, because 0 is the solidity default value
1187         //
1188         assert(i > 0);
1189         i--;
1190 
1191         //  copy the last item in the list into the now-unused slot,
1192         //  making sure to update its :sponsoringIndexes reference
1193         //
1194         uint32[] storage prevSponsoring = sponsoring[prev];
1195         uint256 last = prevSponsoring.length - 1;
1196         uint32 moved = prevSponsoring[last];
1197         prevSponsoring[i] = moved;
1198         sponsoringIndexes[prev][moved] = i + 1;
1199 
1200         //  delete the last item
1201         //
1202         delete(prevSponsoring[last]);
1203         prevSponsoring.length = last;
1204         sponsoringIndexes[prev][_point] = 0;
1205       }
1206 
1207       if (_hasSponsor)
1208       {
1209         uint32[] storage newSponsoring = sponsoring[_sponsor];
1210         newSponsoring.push(_point);
1211         sponsoringIndexes[_sponsor][_point] = newSponsoring.length;
1212       }
1213 
1214       point.sponsor = _sponsor;
1215       point.hasSponsor = _hasSponsor;
1216     }
1217 
1218     //  registerEscapeRequest(): set the escape state of _point and update the
1219     //                           reverse lookup for sponsors
1220     //
1221     function registerEscapeRequest( uint32 _point,
1222                                     bool _isEscaping, uint32 _sponsor )
1223       internal
1224     {
1225       Point storage point = points[_point];
1226       bool was = point.escapeRequested;
1227       uint32 prev = point.escapeRequestedTo;
1228 
1229       //  if we weren't escaping, and won't be,
1230       //  or if we were escaping, and the new target is the same,
1231       //  nothing will change, so jump out early.
1232       //
1233       if ( (!was && !_isEscaping) ||
1234            (was && _isEscaping && prev == _sponsor) )
1235       {
1236         return;
1237       }
1238 
1239       //  if the point used to have a different request, do some gymnastics
1240       //  to keep the reverse lookup gapless.  delete the point from the old
1241       //  sponsor's list, then fill that gap with the list tail.
1242       //
1243       if (was)
1244       {
1245         //  i: current index in previous sponsor's list of sponsored points
1246         //
1247         uint256 i = escapeRequestsIndexes[prev][_point];
1248 
1249         //  we store index + 1, because 0 is the solidity default value
1250         //
1251         assert(i > 0);
1252         i--;
1253 
1254         //  copy the last item in the list into the now-unused slot,
1255         //  making sure to update its :escapeRequestsIndexes reference
1256         //
1257         uint32[] storage prevRequests = escapeRequests[prev];
1258         uint256 last = prevRequests.length - 1;
1259         uint32 moved = prevRequests[last];
1260         prevRequests[i] = moved;
1261         escapeRequestsIndexes[prev][moved] = i + 1;
1262 
1263         //  delete the last item
1264         //
1265         delete(prevRequests[last]);
1266         prevRequests.length = last;
1267         escapeRequestsIndexes[prev][_point] = 0;
1268       }
1269 
1270       if (_isEscaping)
1271       {
1272         uint32[] storage newRequests = escapeRequests[_sponsor];
1273         newRequests.push(_point);
1274         escapeRequestsIndexes[_sponsor][_point] = newRequests.length;
1275       }
1276 
1277       point.escapeRequestedTo = _sponsor;
1278       point.escapeRequested = _isEscaping;
1279     }
1280 
1281   //
1282   //  Deed reading
1283   //
1284 
1285     //  owner
1286 
1287     //  getOwner(): return owner of _point
1288     //
1289     function getOwner(uint32 _point)
1290       view
1291       external
1292       returns (address owner)
1293     {
1294       return rights[_point].owner;
1295     }
1296 
1297     //  isOwner(): true if _point is owned by _address
1298     //
1299     function isOwner(uint32 _point, address _address)
1300       view
1301       external
1302       returns (bool result)
1303     {
1304       return (rights[_point].owner == _address);
1305     }
1306 
1307     //  getOwnedPointCount(): return length of array of points that _whose owns
1308     //
1309     function getOwnedPointCount(address _whose)
1310       view
1311       external
1312       returns (uint256 count)
1313     {
1314       return pointsOwnedBy[_whose].length;
1315     }
1316 
1317     //  getOwnedPoints(): return array of points that _whose owns
1318     //
1319     //    Note: only useful for clients, as Solidity does not currently
1320     //    support returning dynamic arrays.
1321     //
1322     function getOwnedPoints(address _whose)
1323       view
1324       external
1325       returns (uint32[] ownedPoints)
1326     {
1327       return pointsOwnedBy[_whose];
1328     }
1329 
1330     //  getOwnedPointAtIndex(): get point at _index from array of points that
1331     //                         _whose owns
1332     //
1333     function getOwnedPointAtIndex(address _whose, uint256 _index)
1334       view
1335       external
1336       returns (uint32 point)
1337     {
1338       uint32[] storage owned = pointsOwnedBy[_whose];
1339       require(_index < owned.length);
1340       return owned[_index];
1341     }
1342 
1343     //  management proxy
1344 
1345     //  getManagementProxy(): returns _point's current management proxy
1346     //
1347     function getManagementProxy(uint32 _point)
1348       view
1349       external
1350       returns (address manager)
1351     {
1352       return rights[_point].managementProxy;
1353     }
1354 
1355     //  isManagementProxy(): returns true if _proxy is _point's management proxy
1356     //
1357     function isManagementProxy(uint32 _point, address _proxy)
1358       view
1359       external
1360       returns (bool result)
1361     {
1362       return (rights[_point].managementProxy == _proxy);
1363     }
1364 
1365     //  canManage(): true if _who is the owner or manager of _point
1366     //
1367     function canManage(uint32 _point, address _who)
1368       view
1369       external
1370       returns (bool result)
1371     {
1372       Deed storage deed = rights[_point];
1373       return ( (0x0 != _who) &&
1374                ( (_who == deed.owner) ||
1375                  (_who == deed.managementProxy) ) );
1376     }
1377 
1378     //  getManagerForCount(): returns the amount of points _proxy can manage
1379     //
1380     function getManagerForCount(address _proxy)
1381       view
1382       external
1383       returns (uint256 count)
1384     {
1385       return managerFor[_proxy].length;
1386     }
1387 
1388     //  getManagerFor(): returns the points _proxy can manage
1389     //
1390     //    Note: only useful for clients, as Solidity does not currently
1391     //    support returning dynamic arrays.
1392     //
1393     function getManagerFor(address _proxy)
1394       view
1395       external
1396       returns (uint32[] mfor)
1397     {
1398       return managerFor[_proxy];
1399     }
1400 
1401     //  spawn proxy
1402 
1403     //  getSpawnProxy(): returns _point's current spawn proxy
1404     //
1405     function getSpawnProxy(uint32 _point)
1406       view
1407       external
1408       returns (address spawnProxy)
1409     {
1410       return rights[_point].spawnProxy;
1411     }
1412 
1413     //  isSpawnProxy(): returns true if _proxy is _point's spawn proxy
1414     //
1415     function isSpawnProxy(uint32 _point, address _proxy)
1416       view
1417       external
1418       returns (bool result)
1419     {
1420       return (rights[_point].spawnProxy == _proxy);
1421     }
1422 
1423     //  canSpawnAs(): true if _who is the owner or spawn proxy of _point
1424     //
1425     function canSpawnAs(uint32 _point, address _who)
1426       view
1427       external
1428       returns (bool result)
1429     {
1430       Deed storage deed = rights[_point];
1431       return ( (0x0 != _who) &&
1432                ( (_who == deed.owner) ||
1433                  (_who == deed.spawnProxy) ) );
1434     }
1435 
1436     //  getSpawningForCount(): returns the amount of points _proxy
1437     //                         can spawn with
1438     //
1439     function getSpawningForCount(address _proxy)
1440       view
1441       external
1442       returns (uint256 count)
1443     {
1444       return spawningFor[_proxy].length;
1445     }
1446 
1447     //  getSpawningFor(): get the points _proxy can spawn with
1448     //
1449     //    Note: only useful for clients, as Solidity does not currently
1450     //    support returning dynamic arrays.
1451     //
1452     function getSpawningFor(address _proxy)
1453       view
1454       external
1455       returns (uint32[] sfor)
1456     {
1457       return spawningFor[_proxy];
1458     }
1459 
1460     //  voting proxy
1461 
1462     //  getVotingProxy(): returns _point's current voting proxy
1463     //
1464     function getVotingProxy(uint32 _point)
1465       view
1466       external
1467       returns (address voter)
1468     {
1469       return rights[_point].votingProxy;
1470     }
1471 
1472     //  isVotingProxy(): returns true if _proxy is _point's voting proxy
1473     //
1474     function isVotingProxy(uint32 _point, address _proxy)
1475       view
1476       external
1477       returns (bool result)
1478     {
1479       return (rights[_point].votingProxy == _proxy);
1480     }
1481 
1482     //  canVoteAs(): true if _who is the owner of _point,
1483     //               or the voting proxy of _point's owner
1484     //
1485     function canVoteAs(uint32 _point, address _who)
1486       view
1487       external
1488       returns (bool result)
1489     {
1490       Deed storage deed = rights[_point];
1491       return ( (0x0 != _who) &&
1492                ( (_who == deed.owner) ||
1493                  (_who == deed.votingProxy) ) );
1494     }
1495 
1496     //  getVotingForCount(): returns the amount of points _proxy can vote as
1497     //
1498     function getVotingForCount(address _proxy)
1499       view
1500       external
1501       returns (uint256 count)
1502     {
1503       return votingFor[_proxy].length;
1504     }
1505 
1506     //  getVotingFor(): returns the points _proxy can vote as
1507     //
1508     //    Note: only useful for clients, as Solidity does not currently
1509     //    support returning dynamic arrays.
1510     //
1511     function getVotingFor(address _proxy)
1512       view
1513       external
1514       returns (uint32[] vfor)
1515     {
1516       return votingFor[_proxy];
1517     }
1518 
1519     //  transfer proxy
1520 
1521     //  getTransferProxy(): returns _point's current transfer proxy
1522     //
1523     function getTransferProxy(uint32 _point)
1524       view
1525       external
1526       returns (address transferProxy)
1527     {
1528       return rights[_point].transferProxy;
1529     }
1530 
1531     //  isTransferProxy(): returns true if _proxy is _point's transfer proxy
1532     //
1533     function isTransferProxy(uint32 _point, address _proxy)
1534       view
1535       external
1536       returns (bool result)
1537     {
1538       return (rights[_point].transferProxy == _proxy);
1539     }
1540 
1541     //  canTransfer(): true if _who is the owner or transfer proxy of _point,
1542     //                 or is an operator for _point's current owner
1543     //
1544     function canTransfer(uint32 _point, address _who)
1545       view
1546       external
1547       returns (bool result)
1548     {
1549       Deed storage deed = rights[_point];
1550       return ( (0x0 != _who) &&
1551                ( (_who == deed.owner) ||
1552                  (_who == deed.transferProxy) ||
1553                  operators[deed.owner][_who] ) );
1554     }
1555 
1556     //  getTransferringForCount(): returns the amount of points _proxy
1557     //                             can transfer
1558     //
1559     function getTransferringForCount(address _proxy)
1560       view
1561       external
1562       returns (uint256 count)
1563     {
1564       return transferringFor[_proxy].length;
1565     }
1566 
1567     //  getTransferringFor(): get the points _proxy can transfer
1568     //
1569     //    Note: only useful for clients, as Solidity does not currently
1570     //    support returning dynamic arrays.
1571     //
1572     function getTransferringFor(address _proxy)
1573       view
1574       external
1575       returns (uint32[] tfor)
1576     {
1577       return transferringFor[_proxy];
1578     }
1579 
1580     //  isOperator(): returns true if _operator is allowed to transfer
1581     //                ownership of _owner's points
1582     //
1583     function isOperator(address _owner, address _operator)
1584       view
1585       external
1586       returns (bool result)
1587     {
1588       return operators[_owner][_operator];
1589     }
1590 
1591   //
1592   //  Deed writing
1593   //
1594 
1595     //  setOwner(): set owner of _point to _owner
1596     //
1597     //    Note: setOwner() only implements the minimal data storage
1598     //    logic for a transfer; the full transfer is implemented in
1599     //    Ecliptic.
1600     //
1601     //    Note: _owner must not be the zero address.
1602     //
1603     function setOwner(uint32 _point, address _owner)
1604       onlyOwner
1605       external
1606     {
1607       //  prevent burning of points by making zero the owner
1608       //
1609       require(0x0 != _owner);
1610 
1611       //  prev: previous owner, if any
1612       //
1613       address prev = rights[_point].owner;
1614 
1615       if (prev == _owner)
1616       {
1617         return;
1618       }
1619 
1620       //  if the point used to have a different owner, do some gymnastics to
1621       //  keep the list of owned points gapless.  delete this point from the
1622       //  list, then fill that gap with the list tail.
1623       //
1624       if (0x0 != prev)
1625       {
1626         //  i: current index in previous owner's list of owned points
1627         //
1628         uint256 i = pointOwnerIndexes[prev][_point];
1629 
1630         //  we store index + 1, because 0 is the solidity default value
1631         //
1632         assert(i > 0);
1633         i--;
1634 
1635         //  copy the last item in the list into the now-unused slot,
1636         //  making sure to update its :pointOwnerIndexes reference
1637         //
1638         uint32[] storage owner = pointsOwnedBy[prev];
1639         uint256 last = owner.length - 1;
1640         uint32 moved = owner[last];
1641         owner[i] = moved;
1642         pointOwnerIndexes[prev][moved] = i + 1;
1643 
1644         //  delete the last item
1645         //
1646         delete(owner[last]);
1647         owner.length = last;
1648         pointOwnerIndexes[prev][_point] = 0;
1649       }
1650 
1651       //  update the owner list and the owner's index list
1652       //
1653       rights[_point].owner = _owner;
1654       pointsOwnedBy[_owner].push(_point);
1655       pointOwnerIndexes[_owner][_point] = pointsOwnedBy[_owner].length;
1656       emit OwnerChanged(_point, _owner);
1657     }
1658 
1659     //  setManagementProxy(): makes _proxy _point's management proxy
1660     //
1661     function setManagementProxy(uint32 _point, address _proxy)
1662       onlyOwner
1663       external
1664     {
1665       Deed storage deed = rights[_point];
1666       address prev = deed.managementProxy;
1667       if (prev == _proxy)
1668       {
1669         return;
1670       }
1671 
1672       //  if the point used to have a different manager, do some gymnastics
1673       //  to keep the reverse lookup gapless.  delete the point from the
1674       //  old manager's list, then fill that gap with the list tail.
1675       //
1676       if (0x0 != prev)
1677       {
1678         //  i: current index in previous manager's list of managed points
1679         //
1680         uint256 i = managerForIndexes[prev][_point];
1681 
1682         //  we store index + 1, because 0 is the solidity default value
1683         //
1684         assert(i > 0);
1685         i--;
1686 
1687         //  copy the last item in the list into the now-unused slot,
1688         //  making sure to update its :managerForIndexes reference
1689         //
1690         uint32[] storage prevMfor = managerFor[prev];
1691         uint256 last = prevMfor.length - 1;
1692         uint32 moved = prevMfor[last];
1693         prevMfor[i] = moved;
1694         managerForIndexes[prev][moved] = i + 1;
1695 
1696         //  delete the last item
1697         //
1698         delete(prevMfor[last]);
1699         prevMfor.length = last;
1700         managerForIndexes[prev][_point] = 0;
1701       }
1702 
1703       if (0x0 != _proxy)
1704       {
1705         uint32[] storage mfor = managerFor[_proxy];
1706         mfor.push(_point);
1707         managerForIndexes[_proxy][_point] = mfor.length;
1708       }
1709 
1710       deed.managementProxy = _proxy;
1711       emit ChangedManagementProxy(_point, _proxy);
1712     }
1713 
1714     //  setSpawnProxy(): makes _proxy _point's spawn proxy
1715     //
1716     function setSpawnProxy(uint32 _point, address _proxy)
1717       onlyOwner
1718       external
1719     {
1720       Deed storage deed = rights[_point];
1721       address prev = deed.spawnProxy;
1722       if (prev == _proxy)
1723       {
1724         return;
1725       }
1726 
1727       //  if the point used to have a different spawn proxy, do some
1728       //  gymnastics to keep the reverse lookup gapless.  delete the point
1729       //  from the old proxy's list, then fill that gap with the list tail.
1730       //
1731       if (0x0 != prev)
1732       {
1733         //  i: current index in previous proxy's list of spawning points
1734         //
1735         uint256 i = spawningForIndexes[prev][_point];
1736 
1737         //  we store index + 1, because 0 is the solidity default value
1738         //
1739         assert(i > 0);
1740         i--;
1741 
1742         //  copy the last item in the list into the now-unused slot,
1743         //  making sure to update its :spawningForIndexes reference
1744         //
1745         uint32[] storage prevSfor = spawningFor[prev];
1746         uint256 last = prevSfor.length - 1;
1747         uint32 moved = prevSfor[last];
1748         prevSfor[i] = moved;
1749         spawningForIndexes[prev][moved] = i + 1;
1750 
1751         //  delete the last item
1752         //
1753         delete(prevSfor[last]);
1754         prevSfor.length = last;
1755         spawningForIndexes[prev][_point] = 0;
1756       }
1757 
1758       if (0x0 != _proxy)
1759       {
1760         uint32[] storage sfor = spawningFor[_proxy];
1761         sfor.push(_point);
1762         spawningForIndexes[_proxy][_point] = sfor.length;
1763       }
1764 
1765       deed.spawnProxy = _proxy;
1766       emit ChangedSpawnProxy(_point, _proxy);
1767     }
1768 
1769     //  setVotingProxy(): makes _proxy _point's voting proxy
1770     //
1771     function setVotingProxy(uint32 _point, address _proxy)
1772       onlyOwner
1773       external
1774     {
1775       Deed storage deed = rights[_point];
1776       address prev = deed.votingProxy;
1777       if (prev == _proxy)
1778       {
1779         return;
1780       }
1781 
1782       //  if the point used to have a different voter, do some gymnastics
1783       //  to keep the reverse lookup gapless.  delete the point from the
1784       //  old voter's list, then fill that gap with the list tail.
1785       //
1786       if (0x0 != prev)
1787       {
1788         //  i: current index in previous voter's list of points it was
1789         //     voting for
1790         //
1791         uint256 i = votingForIndexes[prev][_point];
1792 
1793         //  we store index + 1, because 0 is the solidity default value
1794         //
1795         assert(i > 0);
1796         i--;
1797 
1798         //  copy the last item in the list into the now-unused slot,
1799         //  making sure to update its :votingForIndexes reference
1800         //
1801         uint32[] storage prevVfor = votingFor[prev];
1802         uint256 last = prevVfor.length - 1;
1803         uint32 moved = prevVfor[last];
1804         prevVfor[i] = moved;
1805         votingForIndexes[prev][moved] = i + 1;
1806 
1807         //  delete the last item
1808         //
1809         delete(prevVfor[last]);
1810         prevVfor.length = last;
1811         votingForIndexes[prev][_point] = 0;
1812       }
1813 
1814       if (0x0 != _proxy)
1815       {
1816         uint32[] storage vfor = votingFor[_proxy];
1817         vfor.push(_point);
1818         votingForIndexes[_proxy][_point] = vfor.length;
1819       }
1820 
1821       deed.votingProxy = _proxy;
1822       emit ChangedVotingProxy(_point, _proxy);
1823     }
1824 
1825     //  setManagementProxy(): makes _proxy _point's transfer proxy
1826     //
1827     function setTransferProxy(uint32 _point, address _proxy)
1828       onlyOwner
1829       external
1830     {
1831       Deed storage deed = rights[_point];
1832       address prev = deed.transferProxy;
1833       if (prev == _proxy)
1834       {
1835         return;
1836       }
1837 
1838       //  if the point used to have a different transfer proxy, do some
1839       //  gymnastics to keep the reverse lookup gapless.  delete the point
1840       //  from the old proxy's list, then fill that gap with the list tail.
1841       //
1842       if (0x0 != prev)
1843       {
1844         //  i: current index in previous proxy's list of transferable points
1845         //
1846         uint256 i = transferringForIndexes[prev][_point];
1847 
1848         //  we store index + 1, because 0 is the solidity default value
1849         //
1850         assert(i > 0);
1851         i--;
1852 
1853         //  copy the last item in the list into the now-unused slot,
1854         //  making sure to update its :transferringForIndexes reference
1855         //
1856         uint32[] storage prevTfor = transferringFor[prev];
1857         uint256 last = prevTfor.length - 1;
1858         uint32 moved = prevTfor[last];
1859         prevTfor[i] = moved;
1860         transferringForIndexes[prev][moved] = i + 1;
1861 
1862         //  delete the last item
1863         //
1864         delete(prevTfor[last]);
1865         prevTfor.length = last;
1866         transferringForIndexes[prev][_point] = 0;
1867       }
1868 
1869       if (0x0 != _proxy)
1870       {
1871         uint32[] storage tfor = transferringFor[_proxy];
1872         tfor.push(_point);
1873         transferringForIndexes[_proxy][_point] = tfor.length;
1874       }
1875 
1876       deed.transferProxy = _proxy;
1877       emit ChangedTransferProxy(_point, _proxy);
1878     }
1879 
1880     //  setOperator(): dis/allow _operator to transfer ownership of all points
1881     //                 owned by _owner
1882     //
1883     //    operators are part of the ERC721 standard
1884     //
1885     function setOperator(address _owner, address _operator, bool _approved)
1886       onlyOwner
1887       external
1888     {
1889       operators[_owner][_operator] = _approved;
1890     }
1891 }
1892 
1893 // Azimuth's ReadsAzimuth.sol
1894 
1895 //  ReadsAzimuth: referring to and testing against the Azimuth
1896 //                data contract
1897 //
1898 //    To avoid needless repetition, this contract provides common
1899 //    checks and operations using the Azimuth contract.
1900 //
1901 contract ReadsAzimuth
1902 {
1903   //  azimuth: points data storage contract.
1904   //
1905   Azimuth public azimuth;
1906 
1907   //  constructor(): set the Azimuth data contract's address
1908   //
1909   constructor(Azimuth _azimuth)
1910     public
1911   {
1912     azimuth = _azimuth;
1913   }
1914 
1915   //  activePointOwner(): require that :msg.sender is the owner of _point,
1916   //                      and that _point is active
1917   //
1918   modifier activePointOwner(uint32 _point)
1919   {
1920     require( azimuth.isOwner(_point, msg.sender) &&
1921              azimuth.isActive(_point) );
1922     _;
1923   }
1924 
1925   //  activePointManager(): require that :msg.sender can manage _point,
1926   //                        and that _point is active
1927   //
1928   modifier activePointManager(uint32 _point)
1929   {
1930     require( azimuth.canManage(_point, msg.sender) &&
1931              azimuth.isActive(_point) );
1932     _;
1933   }
1934 }
1935 
1936 // Azimuth's Polls.sol
1937 
1938 //  Polls: proposals & votes data contract
1939 //
1940 //    This contract is used for storing all data related to the proposals
1941 //    of the senate (galaxy owners) and their votes on those proposals.
1942 //    It keeps track of votes and uses them to calculate whether a majority
1943 //    is in favor of a proposal.
1944 //
1945 //    Every galaxy can only vote on a proposal exactly once. Votes cannot
1946 //    be changed. If a proposal fails to achieve majority within its
1947 //    duration, it can be restarted after its cooldown period has passed.
1948 //
1949 //    The requirements for a proposal to achieve majority are as follows:
1950 //    - At least 1/4 of the currently active voters (rounded down) must have
1951 //      voted in favor of the proposal,
1952 //    - More than half of the votes cast must be in favor of the proposal,
1953 //      and this can no longer change, either because
1954 //      - the poll duration has passed, or
1955 //      - not enough voters remain to take away the in-favor majority.
1956 //    As soon as these conditions are met, no further interaction with
1957 //    the proposal is possible. Achieving majority is permanent.
1958 //
1959 //    Since data stores are difficult to upgrade, all of the logic unrelated
1960 //    to the voting itself (that is, determining who is eligible to vote)
1961 //    is expected to be implemented by this contract's owner.
1962 //
1963 //    This contract will be owned by the Ecliptic contract.
1964 //
1965 contract Polls is Ownable
1966 {
1967   using SafeMath for uint256;
1968   using SafeMath16 for uint16;
1969   using SafeMath8 for uint8;
1970 
1971   //  UpgradePollStarted: a poll on :proposal has opened
1972   //
1973   event UpgradePollStarted(address proposal);
1974 
1975   //  DocumentPollStarted: a poll on :proposal has opened
1976   //
1977   event DocumentPollStarted(bytes32 proposal);
1978 
1979   //  UpgradeMajority: :proposal has achieved majority
1980   //
1981   event UpgradeMajority(address proposal);
1982 
1983   //  DocumentMajority: :proposal has achieved majority
1984   //
1985   event DocumentMajority(bytes32 proposal);
1986 
1987   //  Poll: full poll state
1988   //
1989   struct Poll
1990   {
1991     //  start: the timestamp at which the poll was started
1992     //
1993     uint256 start;
1994 
1995     //  voted: per galaxy, whether they have voted on this poll
1996     //
1997     bool[256] voted;
1998 
1999     //  yesVotes: amount of votes in favor of the proposal
2000     //
2001     uint16 yesVotes;
2002 
2003     //  noVotes: amount of votes against the proposal
2004     //
2005     uint16 noVotes;
2006 
2007     //  duration: amount of time during which the poll can be voted on
2008     //
2009     uint256 duration;
2010 
2011     //  cooldown: amount of time before the (non-majority) poll can be reopened
2012     //
2013     uint256 cooldown;
2014   }
2015 
2016   //  pollDuration: duration set for new polls. see also Poll.duration above
2017   //
2018   uint256 public pollDuration;
2019 
2020   //  pollCooldown: cooldown set for new polls. see also Poll.cooldown above
2021   //
2022   uint256 public pollCooldown;
2023 
2024   //  totalVoters: amount of active galaxies
2025   //
2026   uint16 public totalVoters;
2027 
2028   //  upgradeProposals: list of all upgrades ever proposed
2029   //
2030   //    this allows clients to discover the existence of polls.
2031   //    from there, they can do liveness checks on the polls themselves.
2032   //
2033   address[] public upgradeProposals;
2034 
2035   //  upgradePolls: per address, poll held to determine if that address
2036   //                will become the new ecliptic
2037   //
2038   mapping(address => Poll) public upgradePolls;
2039 
2040   //  upgradeHasAchievedMajority: per address, whether that address
2041   //                              has ever achieved majority
2042   //
2043   //    If we did not store this, we would have to look at old poll data
2044   //    to see whether or not a proposal has ever achieved majority.
2045   //    Since the outcome of a poll is calculated based on :totalVoters,
2046   //    which may not be consistent across time, we need to store outcomes
2047   //    explicitly instead of re-calculating them. This allows us to always
2048   //    tell with certainty whether or not a majority was achieved,
2049   //    regardless of the current :totalVoters.
2050   //
2051   mapping(address => bool) public upgradeHasAchievedMajority;
2052 
2053   //  documentProposals: list of all documents ever proposed
2054   //
2055   //    this allows clients to discover the existence of polls.
2056   //    from there, they can do liveness checks on the polls themselves.
2057   //
2058   bytes32[] public documentProposals;
2059 
2060   //  documentPolls: per hash, poll held to determine if the corresponding
2061   //                 document is accepted by the galactic senate
2062   //
2063   mapping(bytes32 => Poll) public documentPolls;
2064 
2065   //  documentHasAchievedMajority: per hash, whether that hash has ever
2066   //                               achieved majority
2067   //
2068   //    the note for upgradeHasAchievedMajority above applies here as well
2069   //
2070   mapping(bytes32 => bool) public documentHasAchievedMajority;
2071 
2072   //  documentMajorities: all hashes that have achieved majority
2073   //
2074   bytes32[] public documentMajorities;
2075 
2076   //  constructor(): initial contract configuration
2077   //
2078   constructor(uint256 _pollDuration, uint256 _pollCooldown)
2079     public
2080   {
2081     reconfigure(_pollDuration, _pollCooldown);
2082   }
2083 
2084   //  reconfigure(): change poll duration and cooldown
2085   //
2086   function reconfigure(uint256 _pollDuration, uint256 _pollCooldown)
2087     public
2088     onlyOwner
2089   {
2090     require( (5 days <= _pollDuration) && (_pollDuration <= 90 days) &&
2091              (5 days <= _pollCooldown) && (_pollCooldown <= 90 days) );
2092     pollDuration = _pollDuration;
2093     pollCooldown = _pollCooldown;
2094   }
2095 
2096   //  incrementTotalVoters(): increase the amount of registered voters
2097   //
2098   function incrementTotalVoters()
2099     external
2100     onlyOwner
2101   {
2102     require(totalVoters < 256);
2103     totalVoters = totalVoters.add(1);
2104   }
2105 
2106   //  getAllUpgradeProposals(): return array of all upgrade proposals ever made
2107   //
2108   //    Note: only useful for clients, as Solidity does not currently
2109   //    support returning dynamic arrays.
2110   //
2111   function getUpgradeProposals()
2112     external
2113     view
2114     returns (address[] proposals)
2115   {
2116     return upgradeProposals;
2117   }
2118 
2119   //  getUpgradeProposalCount(): get the number of unique proposed upgrades
2120   //
2121   function getUpgradeProposalCount()
2122     external
2123     view
2124     returns (uint256 count)
2125   {
2126     return upgradeProposals.length;
2127   }
2128 
2129   //  getAllDocumentProposals(): return array of all upgrade proposals ever made
2130   //
2131   //    Note: only useful for clients, as Solidity does not currently
2132   //    support returning dynamic arrays.
2133   //
2134   function getDocumentProposals()
2135     external
2136     view
2137     returns (bytes32[] proposals)
2138   {
2139     return documentProposals;
2140   }
2141 
2142   //  getDocumentProposalCount(): get the number of unique proposed upgrades
2143   //
2144   function getDocumentProposalCount()
2145     external
2146     view
2147     returns (uint256 count)
2148   {
2149     return documentProposals.length;
2150   }
2151 
2152   //  getDocumentMajorities(): return array of all document majorities
2153   //
2154   //    Note: only useful for clients, as Solidity does not currently
2155   //    support returning dynamic arrays.
2156   //
2157   function getDocumentMajorities()
2158     external
2159     view
2160     returns (bytes32[] majorities)
2161   {
2162     return documentMajorities;
2163   }
2164 
2165   //  hasVotedOnUpgradePoll(): returns true if _galaxy has voted
2166   //                           on the _proposal
2167   //
2168   function hasVotedOnUpgradePoll(uint8 _galaxy, address _proposal)
2169     external
2170     view
2171     returns (bool result)
2172   {
2173     return upgradePolls[_proposal].voted[_galaxy];
2174   }
2175 
2176   //  hasVotedOnDocumentPoll(): returns true if _galaxy has voted
2177   //                            on the _proposal
2178   //
2179   function hasVotedOnDocumentPoll(uint8 _galaxy, bytes32 _proposal)
2180     external
2181     view
2182     returns (bool result)
2183   {
2184     return documentPolls[_proposal].voted[_galaxy];
2185   }
2186 
2187   //  startUpgradePoll(): open a poll on making _proposal the new ecliptic
2188   //
2189   function startUpgradePoll(address _proposal)
2190     external
2191     onlyOwner
2192   {
2193     //  _proposal must not have achieved majority before
2194     //
2195     require(!upgradeHasAchievedMajority[_proposal]);
2196 
2197     Poll storage poll = upgradePolls[_proposal];
2198 
2199     //  if the proposal is being made for the first time, register it.
2200     //
2201     if (0 == poll.start)
2202     {
2203       upgradeProposals.push(_proposal);
2204     }
2205 
2206     startPoll(poll);
2207     emit UpgradePollStarted(_proposal);
2208   }
2209 
2210   //  startDocumentPoll(): open a poll on accepting the document
2211   //                       whose hash is _proposal
2212   //
2213   function startDocumentPoll(bytes32 _proposal)
2214     external
2215     onlyOwner
2216   {
2217     //  _proposal must not have achieved majority before
2218     //
2219     require(!documentHasAchievedMajority[_proposal]);
2220 
2221     Poll storage poll = documentPolls[_proposal];
2222 
2223     //  if the proposal is being made for the first time, register it.
2224     //
2225     if (0 == poll.start)
2226     {
2227       documentProposals.push(_proposal);
2228     }
2229 
2230     startPoll(poll);
2231     emit DocumentPollStarted(_proposal);
2232   }
2233 
2234   //  startPoll(): open a new poll, or re-open an old one
2235   //
2236   function startPoll(Poll storage _poll)
2237     internal
2238   {
2239     //  check that the poll has cooled down enough to be started again
2240     //
2241     //    for completely new polls, the values used will be zero
2242     //
2243     require( block.timestamp > ( _poll.start.add(
2244                                  _poll.duration.add(
2245                                  _poll.cooldown )) ) );
2246 
2247     //  set started poll state
2248     //
2249     _poll.start = block.timestamp;
2250     delete _poll.voted;
2251     _poll.yesVotes = 0;
2252     _poll.noVotes = 0;
2253     _poll.duration = pollDuration;
2254     _poll.cooldown = pollCooldown;
2255   }
2256 
2257   //  castUpgradeVote(): as galaxy _as, cast a vote on the _proposal
2258   //
2259   //    _vote is true when in favor of the proposal, false otherwise
2260   //
2261   function castUpgradeVote(uint8 _as, address _proposal, bool _vote)
2262     external
2263     onlyOwner
2264     returns (bool majority)
2265   {
2266     Poll storage poll = upgradePolls[_proposal];
2267     processVote(poll, _as, _vote);
2268     return updateUpgradePoll(_proposal);
2269   }
2270 
2271   //  castDocumentVote(): as galaxy _as, cast a vote on the _proposal
2272   //
2273   //    _vote is true when in favor of the proposal, false otherwise
2274   //
2275   function castDocumentVote(uint8 _as, bytes32 _proposal, bool _vote)
2276     external
2277     onlyOwner
2278     returns (bool majority)
2279   {
2280     Poll storage poll = documentPolls[_proposal];
2281     processVote(poll, _as, _vote);
2282     return updateDocumentPoll(_proposal);
2283   }
2284 
2285   //  processVote(): record a vote from _as on the _poll
2286   //
2287   function processVote(Poll storage _poll, uint8 _as, bool _vote)
2288     internal
2289   {
2290     //  assist symbolic execution tools
2291     //
2292     assert(block.timestamp >= _poll.start);
2293 
2294     require( //  may only vote once
2295              //
2296              !_poll.voted[_as] &&
2297              //
2298              //  may only vote when the poll is open
2299              //
2300              (block.timestamp < _poll.start.add(_poll.duration)) );
2301 
2302     //  update poll state to account for the new vote
2303     //
2304     _poll.voted[_as] = true;
2305     if (_vote)
2306     {
2307       _poll.yesVotes = _poll.yesVotes.add(1);
2308     }
2309     else
2310     {
2311       _poll.noVotes = _poll.noVotes.add(1);
2312     }
2313   }
2314 
2315   //  updateUpgradePoll(): check whether the _proposal has achieved
2316   //                            majority, updating state, sending an event,
2317   //                            and returning true if it has
2318   //
2319   function updateUpgradePoll(address _proposal)
2320     public
2321     onlyOwner
2322     returns (bool majority)
2323   {
2324     //  _proposal must not have achieved majority before
2325     //
2326     require(!upgradeHasAchievedMajority[_proposal]);
2327 
2328     //  check for majority in the poll
2329     //
2330     Poll storage poll = upgradePolls[_proposal];
2331     majority = checkPollMajority(poll);
2332 
2333     //  if majority was achieved, update the state and send an event
2334     //
2335     if (majority)
2336     {
2337       upgradeHasAchievedMajority[_proposal] = true;
2338       emit UpgradeMajority(_proposal);
2339     }
2340     return majority;
2341   }
2342 
2343   //  updateDocumentPoll(): check whether the _proposal has achieved majority,
2344   //                        updating the state and sending an event if it has
2345   //
2346   //    this can be called by anyone, because the ecliptic does not
2347   //    need to be aware of the result
2348   //
2349   function updateDocumentPoll(bytes32 _proposal)
2350     public
2351     returns (bool majority)
2352   {
2353     //  _proposal must not have achieved majority before
2354     //
2355     require(!documentHasAchievedMajority[_proposal]);
2356 
2357     //  check for majority in the poll
2358     //
2359     Poll storage poll = documentPolls[_proposal];
2360     majority = checkPollMajority(poll);
2361 
2362     //  if majority was achieved, update state and send an event
2363     //
2364     if (majority)
2365     {
2366       documentHasAchievedMajority[_proposal] = true;
2367       documentMajorities.push(_proposal);
2368       emit DocumentMajority(_proposal);
2369     }
2370     return majority;
2371   }
2372 
2373   //  checkPollMajority(): returns true if the majority is in favor of
2374   //                       the subject of the poll
2375   //
2376   function checkPollMajority(Poll _poll)
2377     internal
2378     view
2379     returns (bool majority)
2380   {
2381     return ( //  poll must have at least the minimum required yes-votes
2382              //
2383              (_poll.yesVotes >= (totalVoters / 4)) &&
2384              //
2385              //  and have a majority...
2386              //
2387              (_poll.yesVotes > _poll.noVotes) &&
2388              //
2389              //  ...that is indisputable
2390              //
2391              ( //  either because the poll has ended
2392                //
2393                (block.timestamp > _poll.start.add(_poll.duration)) ||
2394                //
2395                //  or there are more yes votes than there can be no votes
2396                //
2397                ( _poll.yesVotes > totalVoters.sub(_poll.yesVotes) ) ) );
2398   }
2399 }
2400 
2401 // Azimuth's Claims.sol
2402 
2403 //  Claims: simple identity management
2404 //
2405 //    This contract allows points to document claims about their owner.
2406 //    Most commonly, these are about identity, with a claim's protocol
2407 //    defining the context or platform of the claim, and its dossier
2408 //    containing proof of its validity.
2409 //    Points are limited to a maximum of 16 claims.
2410 //
2411 //    For existing claims, the dossier can be updated, or the claim can
2412 //    be removed entirely. It is recommended to remove any claims associated
2413 //    with a point when it is about to be transferred to a new owner.
2414 //    For convenience, the owner of the Azimuth contract (the Ecliptic)
2415 //    is allowed to clear claims for any point, allowing it to do this for
2416 //    you on-transfer.
2417 //
2418 contract Claims is ReadsAzimuth
2419 {
2420   //  ClaimAdded: a claim was added by :by
2421   //
2422   event ClaimAdded( uint32 indexed by,
2423                     string _protocol,
2424                     string _claim,
2425                     bytes _dossier );
2426 
2427   //  ClaimRemoved: a claim was removed by :by
2428   //
2429   event ClaimRemoved(uint32 indexed by, string _protocol, string _claim);
2430 
2431   //  maxClaims: the amount of claims that can be registered per point
2432   //
2433   uint8 constant maxClaims = 16;
2434 
2435   //  Claim: claim details
2436   //
2437   struct Claim
2438   {
2439     //  protocol: context of the claim
2440     //
2441     string protocol;
2442 
2443     //  claim: the claim itself
2444     //
2445     string claim;
2446 
2447     //  dossier: data relating to the claim, as proof
2448     //
2449     bytes dossier;
2450   }
2451 
2452   //  per point, list of claims
2453   //
2454   mapping(uint32 => Claim[maxClaims]) public claims;
2455 
2456   //  constructor(): register the azimuth contract.
2457   //
2458   constructor(Azimuth _azimuth)
2459     ReadsAzimuth(_azimuth)
2460     public
2461   {
2462     //
2463   }
2464 
2465   //  addClaim(): register a claim as _point
2466   //
2467   function addClaim(uint32 _point,
2468                     string _protocol,
2469                     string _claim,
2470                     bytes _dossier)
2471     external
2472     activePointManager(_point)
2473   {
2474     //  cur: index + 1 of the claim if it already exists, 0 otherwise
2475     //
2476     uint8 cur = findClaim(_point, _protocol, _claim);
2477 
2478     //  if the claim doesn't yet exist, store it in state
2479     //
2480     if (cur == 0)
2481     {
2482       //  if there are no empty slots left, this throws
2483       //
2484       uint8 empty = findEmptySlot(_point);
2485       claims[_point][empty] = Claim(_protocol, _claim, _dossier);
2486     }
2487     //
2488     //  if the claim has been made before, update the version in state
2489     //
2490     else
2491     {
2492       claims[_point][cur-1] = Claim(_protocol, _claim, _dossier);
2493     }
2494     emit ClaimAdded(_point, _protocol, _claim, _dossier);
2495   }
2496 
2497   //  removeClaim(): unregister a claim as _point
2498   //
2499   function removeClaim(uint32 _point, string _protocol, string _claim)
2500     external
2501     activePointManager(_point)
2502   {
2503     //  i: current index + 1 in _point's list of claims
2504     //
2505     uint256 i = findClaim(_point, _protocol, _claim);
2506 
2507     //  we store index + 1, because 0 is the eth default value
2508     //  can only delete an existing claim
2509     //
2510     require(i > 0);
2511     i--;
2512 
2513     //  clear out the claim
2514     //
2515     delete claims[_point][i];
2516 
2517     emit ClaimRemoved(_point, _protocol, _claim);
2518   }
2519 
2520   //  clearClaims(): unregister all of _point's claims
2521   //
2522   //    can also be called by the ecliptic during point transfer
2523   //
2524   function clearClaims(uint32 _point)
2525     external
2526   {
2527     //  both point owner and ecliptic may do this
2528     //
2529     //    We do not necessarily need to check for _point's active flag here,
2530     //    since inactive points cannot have claims set. Doing the check
2531     //    anyway would make this function slightly harder to think about due
2532     //    to its relation to Ecliptic's transferPoint().
2533     //
2534     require( azimuth.canManage(_point, msg.sender) ||
2535              ( msg.sender == azimuth.owner() ) );
2536 
2537     Claim[maxClaims] storage currClaims = claims[_point];
2538 
2539     //  clear out all claims
2540     //
2541     for (uint8 i = 0; i < maxClaims; i++)
2542     {
2543       delete currClaims[i];
2544     }
2545   }
2546 
2547   //  findClaim(): find the index of the specified claim
2548   //
2549   //    returns 0 if not found, index + 1 otherwise
2550   //
2551   function findClaim(uint32 _whose, string _protocol, string _claim)
2552     public
2553     view
2554     returns (uint8 index)
2555   {
2556     //  we use hashes of the string because solidity can't do string
2557     //  comparison yet
2558     //
2559     bytes32 protocolHash = keccak256(bytes(_protocol));
2560     bytes32 claimHash = keccak256(bytes(_claim));
2561     Claim[maxClaims] storage theirClaims = claims[_whose];
2562     for (uint8 i = 0; i < maxClaims; i++)
2563     {
2564       Claim storage thisClaim = theirClaims[i];
2565       if ( ( protocolHash == keccak256(bytes(thisClaim.protocol)) ) &&
2566            ( claimHash == keccak256(bytes(thisClaim.claim)) ) )
2567       {
2568         return i+1;
2569       }
2570     }
2571     return 0;
2572   }
2573 
2574   //  findEmptySlot(): find the index of the first empty claim slot
2575   //
2576   //    returns the index of the slot, throws if there are no empty slots
2577   //
2578   function findEmptySlot(uint32 _whose)
2579     internal
2580     view
2581     returns (uint8 index)
2582   {
2583     Claim[maxClaims] storage theirClaims = claims[_whose];
2584     for (uint8 i = 0; i < maxClaims; i++)
2585     {
2586       Claim storage thisClaim = theirClaims[i];
2587       if ( (0 == bytes(thisClaim.protocol).length) &&
2588            (0 == bytes(thisClaim.claim).length) )
2589       {
2590         return i;
2591       }
2592     }
2593     revert();
2594   }
2595 }
2596 
2597 // Azimuth's EclipticBase.sol
2598 
2599 //  EclipticBase: upgradable ecliptic
2600 //
2601 //    This contract implements the upgrade logic for the Ecliptic.
2602 //    Newer versions of the Ecliptic are expected to provide at least
2603 //    the onUpgrade() function. If they don't, upgrading to them will
2604 //    fail.
2605 //
2606 //    Note that even though this contract doesn't specify any required
2607 //    interface members aside from upgrade() and onUpgrade(), contracts
2608 //    and clients may still rely on the presence of certain functions
2609 //    provided by the Ecliptic proper. Keep this in mind when writing
2610 //    new versions of it.
2611 //
2612 contract EclipticBase is Ownable, ReadsAzimuth
2613 {
2614   //  Upgraded: _to is the new canonical Ecliptic
2615   //
2616   event Upgraded(address to);
2617 
2618   //  polls: senate voting contract
2619   //
2620   Polls public polls;
2621 
2622   //  previousEcliptic: address of the previous ecliptic this
2623   //                    instance expects to upgrade from, stored and
2624   //                    checked for to prevent unexpected upgrade paths
2625   //
2626   address public previousEcliptic;
2627 
2628   constructor( address _previous,
2629                Azimuth _azimuth,
2630                Polls _polls )
2631     ReadsAzimuth(_azimuth)
2632     internal
2633   {
2634     previousEcliptic = _previous;
2635     polls = _polls;
2636   }
2637 
2638   //  onUpgrade(): called by previous ecliptic when upgrading
2639   //
2640   //    in future ecliptics, this might perform more logic than
2641   //    just simple checks and verifications.
2642   //    when overriding this, make sure to call this original as well.
2643   //
2644   function onUpgrade()
2645     external
2646   {
2647     //  make sure this is the expected upgrade path,
2648     //  and that we have gotten the ownership we require
2649     //
2650     require( msg.sender == previousEcliptic &&
2651              this == azimuth.owner() &&
2652              this == polls.owner() );
2653   }
2654 
2655   //  upgrade(): transfer ownership of the ecliptic data to the new
2656   //             ecliptic contract, notify it, then self-destruct.
2657   //
2658   //    Note: any eth that have somehow ended up in this contract
2659   //          are also sent to the new ecliptic.
2660   //
2661   function upgrade(EclipticBase _new)
2662     internal
2663   {
2664     //  transfer ownership of the data contracts
2665     //
2666     azimuth.transferOwnership(_new);
2667     polls.transferOwnership(_new);
2668 
2669     //  trigger upgrade logic on the target contract
2670     //
2671     _new.onUpgrade();
2672 
2673     //  emit event and destroy this contract
2674     //
2675     emit Upgraded(_new);
2676     selfdestruct(_new);
2677   }
2678 }
2679 
2680 // Azimuth's Ecliptic.sol
2681 
2682 //  Ecliptic: logic for interacting with the Azimuth ledger
2683 //
2684 //    This contract is the point of entry for all operations on the Azimuth
2685 //    ledger as stored in the Azimuth data contract. The functions herein
2686 //    are responsible for performing all necessary business logic.
2687 //    Examples of such logic include verifying permissions of the caller
2688 //    and ensuring a requested change is actually valid.
2689 //    Point owners can always operate on their own points. Ethereum addresses
2690 //    can also perform specific operations if they've been given the
2691 //    appropriate permissions. (For example, managers for general management,
2692 //    spawn proxies for spawning child points, etc.)
2693 //
2694 //    This contract uses external contracts (Azimuth, Polls) for data storage
2695 //    so that it itself can easily be replaced in case its logic needs to
2696 //    be changed. In other words, it can be upgraded. It does this by passing
2697 //    ownership of the data contracts to a new Ecliptic contract.
2698 //
2699 //    Because of this, it is advised for clients to not store this contract's
2700 //    address directly, but rather ask the Azimuth contract for its owner
2701 //    attribute to ensure transactions get sent to the latest Ecliptic.
2702 //    Alternatively, the ENS name ecliptic.eth will resolve to the latest
2703 //    Ecliptic as well.
2704 //
2705 //    Upgrading happens based on polls held by the senate (galaxy owners).
2706 //    Through this contract, the senate can submit proposals, opening polls
2707 //    for the senate to cast votes on. These proposals can be either hashes
2708 //    of documents or addresses of new Ecliptics.
2709 //    If an ecliptic proposal gains majority, this contract will transfer
2710 //    ownership of the data storage contracts to that address, so that it may
2711 //    operate on the data they contain. This contract will selfdestruct at
2712 //    the end of the upgrade process.
2713 //
2714 //    This contract implements the ERC721 interface for non-fungible tokens,
2715 //    allowing points to be managed using generic clients that support the
2716 //    standard. It also implements ERC165 to allow this to be discovered.
2717 //
2718 contract Ecliptic is EclipticBase, SupportsInterfaceWithLookup, ERC721Metadata
2719 {
2720   using SafeMath for uint256;
2721   using AddressUtils for address;
2722 
2723   //  Transfer: This emits when ownership of any NFT changes by any mechanism.
2724   //            This event emits when NFTs are created (`from` == 0) and
2725   //            destroyed (`to` == 0). At the time of any transfer, the
2726   //            approved address for that NFT (if any) is reset to none.
2727   //
2728   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
2729 
2730   //  Approval: This emits when the approved address for an NFT is changed or
2731   //            reaffirmed. The zero address indicates there is no approved
2732   //            address. When a Transfer event emits, this also indicates that
2733   //            the approved address for that NFT (if any) is reset to none.
2734   //
2735   event Approval(address indexed _owner, address indexed _approved,
2736                  uint256 _tokenId);
2737 
2738   //  ApprovalForAll: This emits when an operator is enabled or disabled for an
2739   //                  owner. The operator can manage all NFTs of the owner.
2740   //
2741   event ApprovalForAll(address indexed _owner, address indexed _operator,
2742                        bool _approved);
2743 
2744   // erc721Received: equal to:
2745   //        bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
2746   //                 which can be also obtained as:
2747   //        ERC721Receiver(0).onERC721Received.selector`
2748   bytes4 constant erc721Received = 0x150b7a02;
2749 
2750   //  claims: contract reference, for clearing claims on-transfer
2751   //
2752   Claims public claims;
2753 
2754   //  constructor(): set data contract addresses and signal interface support
2755   //
2756   //    Note: during first deploy, ownership of these data contracts must
2757   //    be manually transferred to this contract.
2758   //
2759   constructor(address _previous,
2760               Azimuth _azimuth,
2761               Polls _polls,
2762               Claims _claims)
2763     EclipticBase(_previous, _azimuth, _polls)
2764     public
2765   {
2766     claims = _claims;
2767 
2768     //  register supported interfaces for ERC165
2769     //
2770     _registerInterface(0x80ac58cd); // ERC721
2771     _registerInterface(0x5b5e139f); // ERC721Metadata
2772     _registerInterface(0x7f5828d0); // ERC173 (ownership)
2773   }
2774 
2775   //
2776   //  ERC721 interface
2777   //
2778 
2779     //  balanceOf(): get the amount of points owned by _owner
2780     //
2781     function balanceOf(address _owner)
2782       public
2783       view
2784       returns (uint256 balance)
2785     {
2786       require(0x0 != _owner);
2787       return azimuth.getOwnedPointCount(_owner);
2788     }
2789 
2790     //  ownerOf(): get the current owner of point _tokenId
2791     //
2792     function ownerOf(uint256 _tokenId)
2793       public
2794       view
2795       validPointId(_tokenId)
2796       returns (address owner)
2797     {
2798       uint32 id = uint32(_tokenId);
2799 
2800       //  this will throw if the owner is the zero address,
2801       //  active points always have a valid owner.
2802       //
2803       require(azimuth.isActive(id));
2804 
2805       return azimuth.getOwner(id);
2806     }
2807 
2808     //  exists(): returns true if point _tokenId is active
2809     //
2810     function exists(uint256 _tokenId)
2811       public
2812       view
2813       returns (bool doesExist)
2814     {
2815       return ( (_tokenId < 0x100000000) &&
2816                azimuth.isActive(uint32(_tokenId)) );
2817     }
2818 
2819     //  safeTransferFrom(): transfer point _tokenId from _from to _to
2820     //
2821     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
2822       public
2823     {
2824       //  transfer with empty data
2825       //
2826       safeTransferFrom(_from, _to, _tokenId, "");
2827     }
2828 
2829     //  safeTransferFrom(): transfer point _tokenId from _from to _to,
2830     //                      and call recipient if it's a contract
2831     //
2832     function safeTransferFrom(address _from, address _to, uint256 _tokenId,
2833                               bytes _data)
2834       public
2835     {
2836       //  perform raw transfer
2837       //
2838       transferFrom(_from, _to, _tokenId);
2839 
2840       //  do the callback last to avoid re-entrancy
2841       //
2842       if (_to.isContract())
2843       {
2844         bytes4 retval = ERC721Receiver(_to)
2845                         .onERC721Received(msg.sender, _from, _tokenId, _data);
2846         //
2847         //  standard return idiom to confirm contract semantics
2848         //
2849         require(retval == erc721Received);
2850       }
2851     }
2852 
2853     //  transferFrom(): transfer point _tokenId from _from to _to,
2854     //                  WITHOUT notifying recipient contract
2855     //
2856     function transferFrom(address _from, address _to, uint256 _tokenId)
2857       public
2858       validPointId(_tokenId)
2859     {
2860       uint32 id = uint32(_tokenId);
2861       require(azimuth.isOwner(id, _from));
2862 
2863       //  the ERC721 operator/approved address (if any) is
2864       //  accounted for in transferPoint()
2865       //
2866       transferPoint(id, _to, true);
2867     }
2868 
2869     //  approve(): allow _approved to transfer ownership of point
2870     //             _tokenId
2871     //
2872     function approve(address _approved, uint256 _tokenId)
2873       public
2874       validPointId(_tokenId)
2875     {
2876       setTransferProxy(uint32(_tokenId), _approved);
2877     }
2878 
2879     //  setApprovalForAll(): allow or disallow _operator to
2880     //                       transfer ownership of ALL points
2881     //                       owned by :msg.sender
2882     //
2883     function setApprovalForAll(address _operator, bool _approved)
2884       public
2885     {
2886       require(0x0 != _operator);
2887       azimuth.setOperator(msg.sender, _operator, _approved);
2888       emit ApprovalForAll(msg.sender, _operator, _approved);
2889     }
2890 
2891     //  getApproved(): get the approved address for point _tokenId
2892     //
2893     function getApproved(uint256 _tokenId)
2894       public
2895       view
2896       validPointId(_tokenId)
2897       returns (address approved)
2898     {
2899       //NOTE  redundant, transfer proxy cannot be set for
2900       //      inactive points
2901       //
2902       require(azimuth.isActive(uint32(_tokenId)));
2903       return azimuth.getTransferProxy(uint32(_tokenId));
2904     }
2905 
2906     //  isApprovedForAll(): returns true if _operator is an
2907     //                      operator for _owner
2908     //
2909     function isApprovedForAll(address _owner, address _operator)
2910       public
2911       view
2912       returns (bool result)
2913     {
2914       return azimuth.isOperator(_owner, _operator);
2915     }
2916 
2917   //
2918   //  ERC721Metadata interface
2919   //
2920 
2921     //  name(): returns the name of a collection of points
2922     //
2923     function name()
2924       external
2925       view
2926       returns (string)
2927     {
2928       return "Azimuth Points";
2929     }
2930 
2931     //  symbol(): returns an abbreviates name for points
2932     //
2933     function symbol()
2934       external
2935       view
2936       returns (string)
2937     {
2938       return "AZP";
2939     }
2940 
2941     //  tokenURI(): returns a URL to an ERC-721 standard JSON file
2942     //
2943     function tokenURI(uint256 _tokenId)
2944       public
2945       view
2946       validPointId(_tokenId)
2947       returns (string _tokenURI)
2948     {
2949       _tokenURI = "https://azimuth.network/erc721/0000000000.json";
2950       bytes memory _tokenURIBytes = bytes(_tokenURI);
2951       _tokenURIBytes[31] = byte(48+(_tokenId / 1000000000) % 10);
2952       _tokenURIBytes[32] = byte(48+(_tokenId / 100000000) % 10);
2953       _tokenURIBytes[33] = byte(48+(_tokenId / 10000000) % 10);
2954       _tokenURIBytes[34] = byte(48+(_tokenId / 1000000) % 10);
2955       _tokenURIBytes[35] = byte(48+(_tokenId / 100000) % 10);
2956       _tokenURIBytes[36] = byte(48+(_tokenId / 10000) % 10);
2957       _tokenURIBytes[37] = byte(48+(_tokenId / 1000) % 10);
2958       _tokenURIBytes[38] = byte(48+(_tokenId / 100) % 10);
2959       _tokenURIBytes[39] = byte(48+(_tokenId / 10) % 10);
2960       _tokenURIBytes[40] = byte(48+(_tokenId / 1) % 10);
2961     }
2962 
2963   //
2964   //  Points interface
2965   //
2966 
2967     //  configureKeys(): configure _point with network public keys
2968     //                   _encryptionKey, _authenticationKey,
2969     //                   and corresponding _cryptoSuiteVersion,
2970     //                   incrementing the point's continuity number if needed
2971     //
2972     function configureKeys(uint32 _point,
2973                            bytes32 _encryptionKey,
2974                            bytes32 _authenticationKey,
2975                            uint32 _cryptoSuiteVersion,
2976                            bool _discontinuous)
2977       external
2978       activePointManager(_point)
2979     {
2980       if (_discontinuous)
2981       {
2982         azimuth.incrementContinuityNumber(_point);
2983       }
2984       azimuth.setKeys(_point,
2985                       _encryptionKey,
2986                       _authenticationKey,
2987                       _cryptoSuiteVersion);
2988     }
2989 
2990     //  spawn(): spawn _point, then either give, or allow _target to take,
2991     //           ownership of _point
2992     //
2993     //    if _target is the :msg.sender, _targets owns the _point right away.
2994     //    otherwise, _target becomes the transfer proxy of _point.
2995     //
2996     //    Requirements:
2997     //    - _point must not be active
2998     //    - _point must not be a planet with a galaxy prefix
2999     //    - _point's prefix must be linked and under its spawn limit
3000     //    - :msg.sender must be either the owner of _point's prefix,
3001     //      or an authorized spawn proxy for it
3002     //
3003     function spawn(uint32 _point, address _target)
3004       external
3005     {
3006       //  only currently unowned (and thus also inactive) points can be spawned
3007       //
3008       require(azimuth.isOwner(_point, 0x0));
3009 
3010       //  prefix: half-width prefix of _point
3011       //
3012       uint16 prefix = azimuth.getPrefix(_point);
3013 
3014       //  only allow spawning of points of the size directly below the prefix
3015       //
3016       //    this is possible because of how the address space works,
3017       //    but supporting it introduces complexity through broken assumptions.
3018       //
3019       //    example:
3020       //    0x0000.0000 - galaxy zero
3021       //    0x0000.0100 - the first star of galaxy zero
3022       //    0x0001.0100 - the first planet of the first star
3023       //    0x0001.0000 - the first planet of galaxy zero
3024       //
3025       require( (uint8(azimuth.getPointSize(prefix)) + 1) ==
3026                uint8(azimuth.getPointSize(_point)) );
3027 
3028       //  prefix point must be linked and able to spawn
3029       //
3030       require( (azimuth.hasBeenLinked(prefix)) &&
3031                ( azimuth.getSpawnCount(prefix) <
3032                  getSpawnLimit(prefix, block.timestamp) ) );
3033 
3034       //  the owner of a prefix can always spawn its children;
3035       //  other addresses need explicit permission (the role
3036       //  of "spawnProxy" in the Azimuth contract)
3037       //
3038       require( azimuth.canSpawnAs(prefix, msg.sender) );
3039 
3040       //  if the caller is spawning the point to themselves,
3041       //  assume it knows what it's doing and resolve right away
3042       //
3043       if (msg.sender == _target)
3044       {
3045         doSpawn(_point, _target, true, 0x0);
3046       }
3047       //
3048       //  when sending to a "foreign" address, enforce a withdraw pattern
3049       //  making the _point prefix's owner the _point owner in the mean time
3050       //
3051       else
3052       {
3053         doSpawn(_point, _target, false, azimuth.getOwner(prefix));
3054       }
3055     }
3056 
3057     //  doSpawn(): actual spawning logic, used in spawn(). creates _point,
3058     //             making the _target its owner if _direct, or making the
3059     //             _holder the owner and the _target the transfer proxy
3060     //             if not _direct.
3061     //
3062     function doSpawn( uint32 _point,
3063                       address _target,
3064                       bool _direct,
3065                       address _holder )
3066       internal
3067     {
3068       //  register the spawn for _point's prefix, incrementing spawn count
3069       //
3070       azimuth.registerSpawned(_point);
3071 
3072       //  if the spawn is _direct, assume _target knows what they're doing
3073       //  and resolve right away
3074       //
3075       if (_direct)
3076       {
3077         //  make the point active and set its new owner
3078         //
3079         azimuth.activatePoint(_point);
3080         azimuth.setOwner(_point, _target);
3081 
3082         emit Transfer(0x0, _target, uint256(_point));
3083       }
3084       //
3085       //  when spawning indirectly, enforce a withdraw pattern by approving
3086       //  the _target for transfer of the _point instead.
3087       //  we make the _holder the owner of this _point in the mean time,
3088       //  so that it may cancel the transfer (un-approve) if _target flakes.
3089       //  we don't make _point active yet, because it still doesn't really
3090       //  belong to anyone.
3091       //
3092       else
3093       {
3094         //  have _holder hold on to the _point while _target gets to transfer
3095         //  ownership of it
3096         //
3097         azimuth.setOwner(_point, _holder);
3098         azimuth.setTransferProxy(_point, _target);
3099 
3100         emit Transfer(0x0, _holder, uint256(_point));
3101         emit Approval(_holder, _target, uint256(_point));
3102       }
3103     }
3104 
3105     //  transferPoint(): transfer _point to _target, clearing all permissions
3106     //                   data and keys if _reset is true
3107     //
3108     //    Note: the _reset flag is useful when transferring the point to
3109     //    a recipient who doesn't trust the previous owner.
3110     //
3111     //    Requirements:
3112     //    - :msg.sender must be either _point's current owner, authorized
3113     //      to transfer _point, or authorized to transfer the current
3114     //      owner's points (as in ERC721's operator)
3115     //    - _target must not be the zero address
3116     //
3117     function transferPoint(uint32 _point, address _target, bool _reset)
3118       public
3119     {
3120       //  transfer is legitimate if the caller is the current owner, or
3121       //  an operator for the current owner, or the _point's transfer proxy
3122       //
3123       require(azimuth.canTransfer(_point, msg.sender));
3124 
3125       //  if the point wasn't active yet, that means transferring it
3126       //  is part of the "spawn" flow, so we need to activate it
3127       //
3128       if ( !azimuth.isActive(_point) )
3129       {
3130         azimuth.activatePoint(_point);
3131       }
3132 
3133       //  if the owner would actually change, change it
3134       //
3135       //    the only time this deliberately wouldn't be the case is when a
3136       //    prefix owner wants to activate a spawned but untransferred child.
3137       //
3138       if ( !azimuth.isOwner(_point, _target) )
3139       {
3140         //  remember the previous owner, to be included in the Transfer event
3141         //
3142         address old = azimuth.getOwner(_point);
3143 
3144         azimuth.setOwner(_point, _target);
3145 
3146         //  according to ERC721, the approved address (here, transfer proxy)
3147         //  gets cleared during every Transfer event
3148         //
3149         azimuth.setTransferProxy(_point, 0);
3150 
3151         emit Transfer(old, _target, uint256(_point));
3152       }
3153 
3154       //  reset sensitive data
3155       //  used when transferring the point to a new owner
3156       //
3157       if ( _reset )
3158       {
3159         //  clear the network public keys and break continuity,
3160         //  but only if the point has already been linked
3161         //
3162         if ( azimuth.hasBeenLinked(_point) )
3163         {
3164           azimuth.incrementContinuityNumber(_point);
3165           azimuth.setKeys(_point, 0, 0, 0);
3166         }
3167 
3168         //  clear management proxy
3169         //
3170         azimuth.setManagementProxy(_point, 0);
3171 
3172         //  clear voting proxy
3173         //
3174         azimuth.setVotingProxy(_point, 0);
3175 
3176         //  clear transfer proxy
3177         //
3178         //    in most cases this is done above, during the ownership transfer,
3179         //    but we might not hit that and still be expected to reset the
3180         //    transfer proxy.
3181         //    doing it a second time is a no-op in Azimuth.
3182         //
3183         azimuth.setTransferProxy(_point, 0);
3184 
3185         //  clear spawning proxy
3186         //
3187         azimuth.setSpawnProxy(_point, 0);
3188 
3189         //  clear claims
3190         //
3191         claims.clearClaims(_point);
3192       }
3193     }
3194 
3195     //  escape(): request escape as _point to _sponsor
3196     //
3197     //    if an escape request is already active, this overwrites
3198     //    the existing request
3199     //
3200     //    Requirements:
3201     //    - :msg.sender must be the owner or manager of _point,
3202     //    - _point must be able to escape to _sponsor as per to canEscapeTo()
3203     //
3204     function escape(uint32 _point, uint32 _sponsor)
3205       external
3206       activePointManager(_point)
3207     {
3208       require(canEscapeTo(_point, _sponsor));
3209       azimuth.setEscapeRequest(_point, _sponsor);
3210     }
3211 
3212     //  cancelEscape(): cancel the currently set escape for _point
3213     //
3214     function cancelEscape(uint32 _point)
3215       external
3216       activePointManager(_point)
3217     {
3218       azimuth.cancelEscape(_point);
3219     }
3220 
3221     //  adopt(): as the relevant sponsor, accept the _point
3222     //
3223     //    Requirements:
3224     //    - :msg.sender must be the owner or management proxy
3225     //      of _point's requested sponsor
3226     //
3227     function adopt(uint32 _point)
3228       external
3229     {
3230       require( azimuth.isEscaping(_point) &&
3231                azimuth.canManage( azimuth.getEscapeRequest(_point),
3232                                   msg.sender ) );
3233 
3234       //  _sponsor becomes _point's sponsor
3235       //  its escape request is reset to "not escaping"
3236       //
3237       azimuth.doEscape(_point);
3238     }
3239 
3240     //  reject(): as the relevant sponsor, deny the _point's request
3241     //
3242     //    Requirements:
3243     //    - :msg.sender must be the owner or management proxy
3244     //      of _point's requested sponsor
3245     //
3246     function reject(uint32 _point)
3247       external
3248     {
3249       require( azimuth.isEscaping(_point) &&
3250                azimuth.canManage( azimuth.getEscapeRequest(_point),
3251                                   msg.sender ) );
3252 
3253       //  reset the _point's escape request to "not escaping"
3254       //
3255       azimuth.cancelEscape(_point);
3256     }
3257 
3258     //  detach(): as the _sponsor, stop sponsoring the _point
3259     //
3260     //    Requirements:
3261     //    - :msg.sender must be the owner or management proxy
3262     //      of _point's current sponsor
3263     //
3264     function detach(uint32 _point)
3265       external
3266     {
3267       require( azimuth.hasSponsor(_point) &&
3268                azimuth.canManage(azimuth.getSponsor(_point), msg.sender) );
3269 
3270       //  signal that its sponsor no longer supports _point
3271       //
3272       azimuth.loseSponsor(_point);
3273     }
3274 
3275   //
3276   //  Point rules
3277   //
3278 
3279     //  getSpawnLimit(): returns the total number of children the _point
3280     //                   is allowed to spawn at _time.
3281     //
3282     function getSpawnLimit(uint32 _point, uint256 _time)
3283       public
3284       view
3285       returns (uint32 limit)
3286     {
3287       Azimuth.Size size = azimuth.getPointSize(_point);
3288 
3289       if ( size == Azimuth.Size.Galaxy )
3290       {
3291         return 255;
3292       }
3293       else if ( size == Azimuth.Size.Star )
3294       {
3295         //  in 2019, stars may spawn at most 1024 planets. this limit doubles
3296         //  for every subsequent year.
3297         //
3298         //    Note: 1546300800 corresponds to 2019-01-01
3299         //
3300         uint256 yearsSince2019 = (_time - 1546300800) / 365 days;
3301         if (yearsSince2019 < 6)
3302         {
3303           limit = uint32( 1024 * (2 ** yearsSince2019) );
3304         }
3305         else
3306         {
3307           limit = 65535;
3308         }
3309         return limit;
3310       }
3311       else  //  size == Azimuth.Size.Planet
3312       {
3313         //  planets can create moons, but moons aren't on the chain
3314         //
3315         return 0;
3316       }
3317     }
3318 
3319     //  canEscapeTo(): true if _point could try to escape to _sponsor
3320     //
3321     function canEscapeTo(uint32 _point, uint32 _sponsor)
3322       public
3323       view
3324       returns (bool canEscape)
3325     {
3326       //  can't escape to a sponsor that hasn't been linked
3327       //
3328       if ( !azimuth.hasBeenLinked(_sponsor) ) return false;
3329 
3330       //  Can only escape to a point one size higher than ourselves,
3331       //  except in the special case where the escaping point hasn't
3332       //  been linked yet -- in that case we may escape to points of
3333       //  the same size, to support lightweight invitation chains.
3334       //
3335       //  The use case for lightweight invitations is that a planet
3336       //  owner should be able to invite their friends onto an
3337       //  Azimuth network in a two-party transaction, without a new
3338       //  star relationship.
3339       //  The lightweight invitation process works by escaping your
3340       //  own active (but never linked) point to one of your own
3341       //  points, then transferring the point to your friend.
3342       //
3343       //  These planets can, in turn, sponsor other unlinked planets,
3344       //  so the "planet sponsorship chain" can grow to arbitrary
3345       //  length. Most users, especially deep down the chain, will
3346       //  want to improve their performance by switching to direct
3347       //  star sponsors eventually.
3348       //
3349       Azimuth.Size pointSize = azimuth.getPointSize(_point);
3350       Azimuth.Size sponsorSize = azimuth.getPointSize(_sponsor);
3351       return ( //  normal hierarchical escape structure
3352                //
3353                ( (uint8(sponsorSize) + 1) == uint8(pointSize) ) ||
3354                //
3355                //  special peer escape
3356                //
3357                ( (sponsorSize == pointSize) &&
3358                  //
3359                  //  peer escape is only for points that haven't been linked
3360                  //  yet, because it's only for lightweight invitation chains
3361                  //
3362                  !azimuth.hasBeenLinked(_point) ) );
3363     }
3364 
3365   //
3366   //  Permission management
3367   //
3368 
3369     //  setManagementProxy(): configure the management proxy for _point
3370     //
3371     //    The management proxy may perform "reversible" operations on
3372     //    behalf of the owner. This includes public key configuration and
3373     //    operations relating to sponsorship.
3374     //
3375     function setManagementProxy(uint32 _point, address _manager)
3376       external
3377       activePointOwner(_point)
3378     {
3379       azimuth.setManagementProxy(_point, _manager);
3380     }
3381 
3382     //  setSpawnProxy(): give _spawnProxy the right to spawn points
3383     //                   with the prefix _prefix
3384     //
3385     function setSpawnProxy(uint16 _prefix, address _spawnProxy)
3386       external
3387       activePointOwner(_prefix)
3388     {
3389       azimuth.setSpawnProxy(_prefix, _spawnProxy);
3390     }
3391 
3392     //  setVotingProxy(): configure the voting proxy for _galaxy
3393     //
3394     //    the voting proxy is allowed to start polls and cast votes
3395     //    on the point's behalf.
3396     //
3397     function setVotingProxy(uint8 _galaxy, address _voter)
3398       external
3399       activePointOwner(_galaxy)
3400     {
3401       azimuth.setVotingProxy(_galaxy, _voter);
3402     }
3403 
3404     //  setTransferProxy(): give _transferProxy the right to transfer _point
3405     //
3406     //    Requirements:
3407     //    - :msg.sender must be either _point's current owner,
3408     //      or be an operator for the current owner
3409     //
3410     function setTransferProxy(uint32 _point, address _transferProxy)
3411       public
3412     {
3413       //  owner: owner of _point
3414       //
3415       address owner = azimuth.getOwner(_point);
3416 
3417       //  caller must be :owner, or an operator designated by the owner.
3418       //
3419       require((owner == msg.sender) || azimuth.isOperator(owner, msg.sender));
3420 
3421       //  set transfer proxy field in Azimuth contract
3422       //
3423       azimuth.setTransferProxy(_point, _transferProxy);
3424 
3425       //  emit Approval event
3426       //
3427       emit Approval(owner, _transferProxy, uint256(_point));
3428     }
3429 
3430   //
3431   //  Poll actions
3432   //
3433 
3434     //  startUpgradePoll(): as _galaxy, start a poll for the ecliptic
3435     //                      upgrade _proposal
3436     //
3437     //    Requirements:
3438     //    - :msg.sender must be the owner or voting proxy of _galaxy,
3439     //    - the _proposal must expect to be upgraded from this specific
3440     //      contract, as indicated by its previousEcliptic attribute
3441     //
3442     function startUpgradePoll(uint8 _galaxy, EclipticBase _proposal)
3443       external
3444       activePointVoter(_galaxy)
3445     {
3446       //  ensure that the upgrade target expects this contract as the source
3447       //
3448       require(_proposal.previousEcliptic() == address(this));
3449       polls.startUpgradePoll(_proposal);
3450     }
3451 
3452     //  startDocumentPoll(): as _galaxy, start a poll for the _proposal
3453     //
3454     //    the _proposal argument is the keccak-256 hash of any arbitrary
3455     //    document or string of text
3456     //
3457     function startDocumentPoll(uint8 _galaxy, bytes32 _proposal)
3458       external
3459       activePointVoter(_galaxy)
3460     {
3461       polls.startDocumentPoll(_proposal);
3462     }
3463 
3464     //  castUpgradeVote(): as _galaxy, cast a _vote on the ecliptic
3465     //                     upgrade _proposal
3466     //
3467     //    _vote is true when in favor of the proposal, false otherwise
3468     //
3469     //    If this vote results in a majority for the _proposal, it will
3470     //    be upgraded to immediately.
3471     //
3472     function castUpgradeVote(uint8 _galaxy,
3473                               EclipticBase _proposal,
3474                               bool _vote)
3475       external
3476       activePointVoter(_galaxy)
3477     {
3478       //  majority: true if the vote resulted in a majority, false otherwise
3479       //
3480       bool majority = polls.castUpgradeVote(_galaxy, _proposal, _vote);
3481 
3482       //  if a majority is in favor of the upgrade, it happens as defined
3483       //  in the ecliptic base contract
3484       //
3485       if (majority)
3486       {
3487         upgrade(_proposal);
3488       }
3489     }
3490 
3491     //  castDocumentVote(): as _galaxy, cast a _vote on the _proposal
3492     //
3493     //    _vote is true when in favor of the proposal, false otherwise
3494     //
3495     function castDocumentVote(uint8 _galaxy, bytes32 _proposal, bool _vote)
3496       external
3497       activePointVoter(_galaxy)
3498     {
3499       polls.castDocumentVote(_galaxy, _proposal, _vote);
3500     }
3501 
3502     //  updateUpgradePoll(): check whether the _proposal has achieved
3503     //                      majority, upgrading to it if it has
3504     //
3505     function updateUpgradePoll(EclipticBase _proposal)
3506       external
3507     {
3508       //  majority: true if the poll ended in a majority, false otherwise
3509       //
3510       bool majority = polls.updateUpgradePoll(_proposal);
3511 
3512       //  if a majority is in favor of the upgrade, it happens as defined
3513       //  in the ecliptic base contract
3514       //
3515       if (majority)
3516       {
3517         upgrade(_proposal);
3518       }
3519     }
3520 
3521     //  updateDocumentPoll(): check whether the _proposal has achieved majority
3522     //
3523     //    Note: the polls contract publicly exposes the function this calls,
3524     //    but we offer it in the ecliptic interface as a convenience
3525     //
3526     function updateDocumentPoll(bytes32 _proposal)
3527       external
3528     {
3529       polls.updateDocumentPoll(_proposal);
3530     }
3531 
3532   //
3533   //  Contract owner operations
3534   //
3535 
3536     //  createGalaxy(): grant _target ownership of the _galaxy and register
3537     //                  it for voting
3538     //
3539     function createGalaxy(uint8 _galaxy, address _target)
3540       external
3541       onlyOwner
3542     {
3543       //  only currently unowned (and thus also inactive) galaxies can be
3544       //  created, and only to non-zero addresses
3545       //
3546       require( azimuth.isOwner(_galaxy, 0x0) &&
3547                0x0 != _target );
3548 
3549       //  new galaxy means a new registered voter
3550       //
3551       polls.incrementTotalVoters();
3552 
3553       //  if the caller is sending the galaxy to themselves,
3554       //  assume it knows what it's doing and resolve right away
3555       //
3556       if (msg.sender == _target)
3557       {
3558         doSpawn(_galaxy, _target, true, 0x0);
3559       }
3560       //
3561       //  when sending to a "foreign" address, enforce a withdraw pattern,
3562       //  making the caller the owner in the mean time
3563       //
3564       else
3565       {
3566         doSpawn(_galaxy, _target, false, msg.sender);
3567       }
3568     }
3569 
3570     function setDnsDomains(string _primary, string _secondary, string _tertiary)
3571       external
3572       onlyOwner
3573     {
3574       azimuth.setDnsDomains(_primary, _secondary, _tertiary);
3575     }
3576 
3577   //
3578   //  Function modifiers for this contract
3579   //
3580 
3581     //  validPointId(): require that _id is a valid point
3582     //
3583     modifier validPointId(uint256 _id)
3584     {
3585       require(_id < 0x100000000);
3586       _;
3587     }
3588 
3589     //  activePointVoter(): require that :msg.sender can vote as _point,
3590     //                      and that _point is active
3591     //
3592     modifier activePointVoter(uint32 _point)
3593     {
3594       require( azimuth.canVoteAs(_point, msg.sender) &&
3595                azimuth.isActive(_point) );
3596       _;
3597     }
3598 }
3599 
3600 // Azimuth's TakesPoints.sol
3601 
3602 contract TakesPoints is ReadsAzimuth
3603 {
3604   constructor(Azimuth _azimuth)
3605     ReadsAzimuth(_azimuth)
3606     public
3607   {
3608     //
3609   }
3610 
3611   //  takePoint(): transfer _point to this contract. if _clean is true, require
3612   //               that the point be unlinked.
3613   //               returns true if this succeeds, false otherwise.
3614   //
3615   function takePoint(uint32 _point, bool _clean)
3616     internal
3617     returns (bool success)
3618   {
3619     Ecliptic ecliptic = Ecliptic(azimuth.owner());
3620 
3621     //  There are two ways for a contract to get a point.
3622     //  One way is for a prefix point to grant the contract permission to
3623     //  spawn its points.
3624     //  The contract will spawn the point directly to itself.
3625     //
3626     uint16 prefix = azimuth.getPrefix(_point);
3627     if ( azimuth.isOwner(_point, 0x0) &&
3628          azimuth.isOwner(prefix, msg.sender) &&
3629          azimuth.isSpawnProxy(prefix, this) &&
3630          (ecliptic.getSpawnLimit(prefix, now) > azimuth.getSpawnCount(prefix)) )
3631     {
3632       //  first model: spawn _point to :this contract
3633       //
3634       ecliptic.spawn(_point, this);
3635       return true;
3636     }
3637 
3638     //  The second way is to accept existing points, optionally
3639     //  requiring they be unlinked.
3640     //  To deposit a point this way, the owner grants the contract
3641     //  permission to transfer ownership of the point.
3642     //  The contract will transfer the point to itself.
3643     //
3644     if ( (!_clean || !azimuth.hasBeenLinked(_point)) &&
3645          azimuth.isOwner(_point, msg.sender) &&
3646          azimuth.canTransfer(_point, this) )
3647     {
3648       //  second model: transfer active, unlinked _point to :this contract
3649       //
3650       ecliptic.transferPoint(_point, this, true);
3651       return true;
3652     }
3653 
3654     //  point is not for us to take
3655     //
3656     return false;
3657   }
3658 
3659   //  givePoint(): transfer a _point we own to _to, optionally resetting.
3660   //               returns true if this succeeds, false otherwise.
3661   //
3662   //    Note that _reset is unnecessary if the point was taken
3663   //    using this contract's takePoint() function, which always
3664   //    resets, and not touched since.
3665   //
3666   function givePoint(uint32 _point, address _to, bool _reset)
3667     internal
3668     returns (bool success)
3669   {
3670     //  only give points we've taken, points we fully own
3671     //
3672     if (azimuth.isOwner(_point, this))
3673     {
3674       Ecliptic(azimuth.owner()).transferPoint(_point, _to, _reset);
3675       return true;
3676     }
3677 
3678     //  point is not for us to give
3679     //
3680     return false;
3681   }
3682 }
3683 
3684 ////////////////////////////////////////////////////////////////////////////////
3685 //  LinearStarRelease
3686 ////////////////////////////////////////////////////////////////////////////////
3687 
3688 //  LinearStarRelease: batch transfer over time
3689 //
3690 //    This contract allows its owner to transfer a batch of stars to a
3691 //    recipient (also "participant") gradually, at a set rate of an
3692 //    amount of stars per a period of time, after an optional waiting
3693 //    period measured from the launch of this contract.
3694 //
3695 //    The owner of this contract can register batches and deposit stars
3696 //    into them. Participants can withdraw stars as they get released
3697 //    and transfer ownership of their batch to another address.
3698 //    If, ten years after the contract launch, any stars remain, the
3699 //    contract owner is able to withdraw them. This saves address space from
3700 //    being lost forever in case of key loss by participants.
3701 //
3702 contract LinearStarRelease is Ownable, TakesPoints
3703 {
3704   using SafeMath for uint256;
3705   using SafeMath16 for uint16;
3706 
3707   //  escapeHatchTime: amount of time after the time of contract launch, after
3708   //                   which the contract owner can withdraw arbitrary stars
3709   //
3710   uint256 constant escapeHatchTime = 10 * 365 days;
3711 
3712   //  start: global release start time
3713   //
3714   uint256 public start;
3715 
3716   //  Batch: stars that unlock for a participant
3717   //
3718   //    While the ordering of the struct members is semantically chaotic,
3719   //    they are ordered to tightly pack them into Ethereum's 32-byte storage
3720   //    slots, which reduces gas costs for some function calls.
3721   //    The comment ticks indicate assumed slot boundaries.
3722   //
3723   struct Batch
3724   {
3725     //  stars: specific stars assigned to this batch that have not yet
3726     //         been withdrawn
3727     //
3728     uint16[] stars;
3729   //
3730     //  windup: amount of time it takes for stars to start becoming
3731     //          available for withdrawal (start unlocking), after the
3732     //          release has started globally (:start)
3733     //
3734     uint256 windup;
3735   //
3736     //  rateUnit: amount of time it takes for the next :rate stars to be
3737     //            released/unlocked
3738     //
3739     uint256 rateUnit;
3740   //
3741     //  withdrawn: number of stars withdrawn from this batch
3742     //
3743     uint16 withdrawn;
3744 
3745     //  rate: number of stars released per :rateUnit
3746     //
3747     uint16 rate;
3748 
3749     //  amount: promised amount of stars
3750     //
3751     uint16 amount;
3752 
3753     //  approvedTransferTo: batch can be transferred to this address
3754     //
3755     address approvedTransferTo;
3756   }
3757 
3758   //  batches: per participant, the registered star release
3759   //
3760   mapping(address => Batch) public batches;
3761 
3762   //  constructor(): register azimuth contract
3763   //
3764   constructor(Azimuth _azimuth)
3765     TakesPoints(_azimuth)
3766     public
3767   {
3768     //
3769   }
3770 
3771   //
3772   //  Functions for the contract owner
3773   //
3774 
3775     //  register(): register a new star batch
3776     //
3777     function register( //  _participant: address of the participant
3778                        //  _windup: time until first release
3779                        //  _amount: the promised amount of stars
3780                        //  _rate: number of stars that unlock per _rateUnit
3781                        //  _rateUnit: amount of time it takes for the next
3782                        //             _rate stars to unlock
3783                        //
3784                        address _participant,
3785                        uint256 _windup,
3786                        uint16 _amount,
3787                        uint16 _rate,
3788                        uint256 _rateUnit )
3789       external
3790       onlyOwner
3791     {
3792       Batch storage batch = batches[_participant];
3793 
3794       //  make sure this participant doesn't already have a batch registered
3795       //
3796       require(0 == batch.amount);
3797 
3798       //  make sure batch details are sane
3799       //
3800       require( (_rate > 0) &&
3801                (_rateUnit > 0) &&
3802                (_amount > 0) );
3803 
3804       batch.windup = _windup;
3805       batch.amount = _amount;
3806       batch.rate = _rate;
3807       batch.rateUnit = _rateUnit;
3808     }
3809 
3810     //  deposit(): deposit a star into this contract for later withdrawal
3811     //
3812     function deposit(address _participant, uint16 _star)
3813       external
3814       onlyOwner
3815     {
3816       Batch storage batch = batches[_participant];
3817 
3818       //  ensure we can only deposit stars, and that we can't deposit
3819       //  more stars than necessary
3820       //
3821       require( (_star > 0xff) &&
3822                (batch.stars.length < batch.amount.sub(batch.withdrawn)) );
3823 
3824       //  have the contract take ownership of the star if possible,
3825       //  reverting if that fails.
3826       //
3827       require( takePoint(_star, true) );
3828 
3829       //  add _star to the participant's star balance
3830       //
3831       batch.stars.push(_star);
3832     }
3833 
3834     //  startReleasing(): start the process of releasing stars
3835     //
3836     function startReleasing()
3837       external
3838       onlyOwner
3839     {
3840       //  make sure we haven't started yet
3841       //
3842       require(0 == start);
3843       start = block.timestamp;
3844     }
3845 
3846     //  withdrawOverdue(): withdraw arbitrary star from the contract
3847     //
3848     //    this functions acts as an escape hatch in the case of key loss,
3849     //    to prevent blocks of address space from being lost permanently.
3850     //
3851     function withdrawOverdue(address _participant, address _to)
3852       external
3853       onlyOwner
3854     {
3855       //  this can only be done :escapeHatchTime after the release start
3856       //
3857       require( (0 < start) &&
3858                (block.timestamp > start.add(escapeHatchTime)) );
3859 
3860       //  withdraw a star from the batch
3861       //
3862       performWithdraw(batches[_participant], _to, false);
3863     }
3864 
3865   //
3866   //  Functions for participants
3867   //
3868 
3869     //  approveBatchTransfer(): transfer the batch to another address
3870     //
3871     function approveBatchTransfer(address _to)
3872       external
3873     {
3874       //  make sure the caller is a participant,
3875       //  and that the target isn't
3876       //
3877       require( 0 != batches[msg.sender].amount &&
3878                0 == batches[_to].amount );
3879       batches[msg.sender].approvedTransferTo = _to;
3880     }
3881 
3882     //  transferBatch(): make an approved transfer of _from's batch
3883     //                        to the caller's address
3884     //
3885     function transferBatch(address _from)
3886       external
3887     {
3888       //  make sure the :msg.sender is authorized to make this transfer
3889       //
3890       require(batches[_from].approvedTransferTo == msg.sender);
3891 
3892       //  make sure the target isn't also a participant
3893       //
3894       require(0 == batches[msg.sender].amount);
3895 
3896       //  copy the batch to the :msg.sender and clear _from's
3897       //
3898       Batch storage com = batches[_from];
3899       batches[msg.sender] = com;
3900       batches[_from] = Batch(new uint16[](0), 0, 0, 0, 0, 0, 0x0);
3901     }
3902 
3903     //  withdraw(): withdraw one star to the sender's address
3904     //
3905     function withdraw()
3906       external
3907     {
3908       withdraw(msg.sender);
3909     }
3910 
3911     //  withdraw(): withdraw one star from the sender's batch to _to
3912     //
3913     function withdraw(address _to)
3914       public
3915     {
3916       Batch storage batch = batches[msg.sender];
3917 
3918       //  to withdraw, the participant must have a star balance
3919       //  and be under their current withdrawal limit
3920       //
3921       require( (batch.stars.length > 0) &&
3922                (batch.withdrawn < withdrawLimit(msg.sender)) );
3923 
3924       //  withdraw a star from the batch
3925       //
3926       performWithdraw(batch, _to, true);
3927     }
3928 
3929   //
3930   //  Internal functions
3931   //
3932 
3933     //  performWithdraw(): withdraw a star from _batch to _to
3934     //
3935     function performWithdraw(Batch storage _batch, address _to, bool _reset)
3936       internal
3937     {
3938       //  star: star being withdrawn
3939       //
3940       uint16 star = _batch.stars[_batch.stars.length.sub(1)];
3941 
3942       //  remove the star from the batch
3943       //
3944       _batch.stars.length = _batch.stars.length.sub(1);
3945       _batch.withdrawn = _batch.withdrawn.add(1);
3946 
3947       //  transfer :star
3948       //
3949       require( givePoint(star, _to, _reset) );
3950     }
3951 
3952   //
3953   //  Public operations and utilities
3954   //
3955 
3956     //  withdrawLimit(): return the number of stars _participant can withdraw
3957     //                   at the current block timestamp
3958     //
3959     function withdrawLimit(address _participant)
3960       public
3961       view
3962       returns (uint16 limit)
3963     {
3964       //  if we haven't started releasing yet, limit is always zero
3965       //
3966       if (0 == start)
3967       {
3968         return 0;
3969       }
3970 
3971       uint256 allowed = 0;
3972       Batch storage batch = batches[_participant];
3973 
3974       //  only do real calculations if the windup time is over
3975       //
3976       uint256 realStart = start.add(batch.windup);
3977       if ( block.timestamp > realStart )
3978       {
3979         //  calculate the amount of stars available from this batch by
3980         //  multiplying the release rate (stars per :rateUnit) by the number
3981         //  of :rateUnits that have passed since the windup period ended
3982         //
3983         allowed = uint256(batch.rate).mul(
3984                   ( block.timestamp.sub(realStart) /
3985                     batch.rateUnit ) );
3986       }
3987 
3988       //  allow at least one star
3989       //
3990       if ( allowed < 1 )
3991       {
3992         return 1;
3993       }
3994       //
3995       //  don't allow more than the promised amount
3996       //
3997       else if (allowed > batch.amount)
3998       {
3999         return batch.amount;
4000       }
4001       return uint16(allowed);
4002     }
4003 
4004     //  verifyBalance: check the balance of _participant
4005     //
4006     //    Note: for use by clients, to verify the contract owner
4007     //    has deposited all the stars they're entitled to.
4008     //
4009     function verifyBalance(address _participant)
4010       external
4011       view
4012       returns (bool correct)
4013     {
4014       Batch storage batch = batches[_participant];
4015 
4016       //  return true if this contract holds as many stars as we'll ever
4017       //  be entitled to withdraw
4018       //
4019       return ( batch.amount.sub(batch.withdrawn) == batch.stars.length );
4020     }
4021 
4022     //  getRemainingStars(): get the stars deposited into the batch
4023     //
4024     //    Note: only useful for clients, as Solidity does not currently
4025     //    support returning dynamic arrays.
4026     //
4027     function getRemainingStars(address _participant)
4028       external
4029       view
4030       returns (uint16[] stars)
4031     {
4032       return batches[_participant].stars;
4033     }
4034 }