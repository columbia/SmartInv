1 //  the azimuth logic contract
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
1934 
1935   //  activePointSpawner(): require that :msg.sender can spawn as _point,
1936   //                        and that _point is active
1937   //
1938   modifier activePointSpawner(uint32 _point)
1939   {
1940     require( azimuth.canSpawnAs(_point, msg.sender) &&
1941              azimuth.isActive(_point) );
1942     _;
1943   }
1944 
1945   //  activePointVoter(): require that :msg.sender can vote as _point,
1946   //                        and that _point is active
1947   //
1948   modifier activePointVoter(uint32 _point)
1949   {
1950     require( azimuth.canVoteAs(_point, msg.sender) &&
1951              azimuth.isActive(_point) );
1952     _;
1953   }
1954 }
1955 
1956 // Azimuth's Polls.sol
1957 
1958 //  Polls: proposals & votes data contract
1959 //
1960 //    This contract is used for storing all data related to the proposals
1961 //    of the senate (galaxy owners) and their votes on those proposals.
1962 //    It keeps track of votes and uses them to calculate whether a majority
1963 //    is in favor of a proposal.
1964 //
1965 //    Every galaxy can only vote on a proposal exactly once. Votes cannot
1966 //    be changed. If a proposal fails to achieve majority within its
1967 //    duration, it can be restarted after its cooldown period has passed.
1968 //
1969 //    The requirements for a proposal to achieve majority are as follows:
1970 //    - At least 1/4 of the currently active voters (rounded down) must have
1971 //      voted in favor of the proposal,
1972 //    - More than half of the votes cast must be in favor of the proposal,
1973 //      and this can no longer change, either because
1974 //      - the poll duration has passed, or
1975 //      - not enough voters remain to take away the in-favor majority.
1976 //    As soon as these conditions are met, no further interaction with
1977 //    the proposal is possible. Achieving majority is permanent.
1978 //
1979 //    Since data stores are difficult to upgrade, all of the logic unrelated
1980 //    to the voting itself (that is, determining who is eligible to vote)
1981 //    is expected to be implemented by this contract's owner.
1982 //
1983 //    This contract will be owned by the Ecliptic contract.
1984 //
1985 contract Polls is Ownable
1986 {
1987   using SafeMath for uint256;
1988   using SafeMath16 for uint16;
1989   using SafeMath8 for uint8;
1990 
1991   //  UpgradePollStarted: a poll on :proposal has opened
1992   //
1993   event UpgradePollStarted(address proposal);
1994 
1995   //  DocumentPollStarted: a poll on :proposal has opened
1996   //
1997   event DocumentPollStarted(bytes32 proposal);
1998 
1999   //  UpgradeMajority: :proposal has achieved majority
2000   //
2001   event UpgradeMajority(address proposal);
2002 
2003   //  DocumentMajority: :proposal has achieved majority
2004   //
2005   event DocumentMajority(bytes32 proposal);
2006 
2007   //  Poll: full poll state
2008   //
2009   struct Poll
2010   {
2011     //  start: the timestamp at which the poll was started
2012     //
2013     uint256 start;
2014 
2015     //  voted: per galaxy, whether they have voted on this poll
2016     //
2017     bool[256] voted;
2018 
2019     //  yesVotes: amount of votes in favor of the proposal
2020     //
2021     uint16 yesVotes;
2022 
2023     //  noVotes: amount of votes against the proposal
2024     //
2025     uint16 noVotes;
2026 
2027     //  duration: amount of time during which the poll can be voted on
2028     //
2029     uint256 duration;
2030 
2031     //  cooldown: amount of time before the (non-majority) poll can be reopened
2032     //
2033     uint256 cooldown;
2034   }
2035 
2036   //  pollDuration: duration set for new polls. see also Poll.duration above
2037   //
2038   uint256 public pollDuration;
2039 
2040   //  pollCooldown: cooldown set for new polls. see also Poll.cooldown above
2041   //
2042   uint256 public pollCooldown;
2043 
2044   //  totalVoters: amount of active galaxies
2045   //
2046   uint16 public totalVoters;
2047 
2048   //  upgradeProposals: list of all upgrades ever proposed
2049   //
2050   //    this allows clients to discover the existence of polls.
2051   //    from there, they can do liveness checks on the polls themselves.
2052   //
2053   address[] public upgradeProposals;
2054 
2055   //  upgradePolls: per address, poll held to determine if that address
2056   //                will become the new ecliptic
2057   //
2058   mapping(address => Poll) public upgradePolls;
2059 
2060   //  upgradeHasAchievedMajority: per address, whether that address
2061   //                              has ever achieved majority
2062   //
2063   //    If we did not store this, we would have to look at old poll data
2064   //    to see whether or not a proposal has ever achieved majority.
2065   //    Since the outcome of a poll is calculated based on :totalVoters,
2066   //    which may not be consistent across time, we need to store outcomes
2067   //    explicitly instead of re-calculating them. This allows us to always
2068   //    tell with certainty whether or not a majority was achieved,
2069   //    regardless of the current :totalVoters.
2070   //
2071   mapping(address => bool) public upgradeHasAchievedMajority;
2072 
2073   //  documentProposals: list of all documents ever proposed
2074   //
2075   //    this allows clients to discover the existence of polls.
2076   //    from there, they can do liveness checks on the polls themselves.
2077   //
2078   bytes32[] public documentProposals;
2079 
2080   //  documentPolls: per hash, poll held to determine if the corresponding
2081   //                 document is accepted by the galactic senate
2082   //
2083   mapping(bytes32 => Poll) public documentPolls;
2084 
2085   //  documentHasAchievedMajority: per hash, whether that hash has ever
2086   //                               achieved majority
2087   //
2088   //    the note for upgradeHasAchievedMajority above applies here as well
2089   //
2090   mapping(bytes32 => bool) public documentHasAchievedMajority;
2091 
2092   //  documentMajorities: all hashes that have achieved majority
2093   //
2094   bytes32[] public documentMajorities;
2095 
2096   //  constructor(): initial contract configuration
2097   //
2098   constructor(uint256 _pollDuration, uint256 _pollCooldown)
2099     public
2100   {
2101     reconfigure(_pollDuration, _pollCooldown);
2102   }
2103 
2104   //  reconfigure(): change poll duration and cooldown
2105   //
2106   function reconfigure(uint256 _pollDuration, uint256 _pollCooldown)
2107     public
2108     onlyOwner
2109   {
2110     require( (5 days <= _pollDuration) && (_pollDuration <= 90 days) &&
2111              (5 days <= _pollCooldown) && (_pollCooldown <= 90 days) );
2112     pollDuration = _pollDuration;
2113     pollCooldown = _pollCooldown;
2114   }
2115 
2116   //  incrementTotalVoters(): increase the amount of registered voters
2117   //
2118   function incrementTotalVoters()
2119     external
2120     onlyOwner
2121   {
2122     require(totalVoters < 256);
2123     totalVoters = totalVoters.add(1);
2124   }
2125 
2126   //  getAllUpgradeProposals(): return array of all upgrade proposals ever made
2127   //
2128   //    Note: only useful for clients, as Solidity does not currently
2129   //    support returning dynamic arrays.
2130   //
2131   function getUpgradeProposals()
2132     external
2133     view
2134     returns (address[] proposals)
2135   {
2136     return upgradeProposals;
2137   }
2138 
2139   //  getUpgradeProposalCount(): get the number of unique proposed upgrades
2140   //
2141   function getUpgradeProposalCount()
2142     external
2143     view
2144     returns (uint256 count)
2145   {
2146     return upgradeProposals.length;
2147   }
2148 
2149   //  getAllDocumentProposals(): return array of all upgrade proposals ever made
2150   //
2151   //    Note: only useful for clients, as Solidity does not currently
2152   //    support returning dynamic arrays.
2153   //
2154   function getDocumentProposals()
2155     external
2156     view
2157     returns (bytes32[] proposals)
2158   {
2159     return documentProposals;
2160   }
2161 
2162   //  getDocumentProposalCount(): get the number of unique proposed upgrades
2163   //
2164   function getDocumentProposalCount()
2165     external
2166     view
2167     returns (uint256 count)
2168   {
2169     return documentProposals.length;
2170   }
2171 
2172   //  getDocumentMajorities(): return array of all document majorities
2173   //
2174   //    Note: only useful for clients, as Solidity does not currently
2175   //    support returning dynamic arrays.
2176   //
2177   function getDocumentMajorities()
2178     external
2179     view
2180     returns (bytes32[] majorities)
2181   {
2182     return documentMajorities;
2183   }
2184 
2185   //  hasVotedOnUpgradePoll(): returns true if _galaxy has voted
2186   //                           on the _proposal
2187   //
2188   function hasVotedOnUpgradePoll(uint8 _galaxy, address _proposal)
2189     external
2190     view
2191     returns (bool result)
2192   {
2193     return upgradePolls[_proposal].voted[_galaxy];
2194   }
2195 
2196   //  hasVotedOnDocumentPoll(): returns true if _galaxy has voted
2197   //                            on the _proposal
2198   //
2199   function hasVotedOnDocumentPoll(uint8 _galaxy, bytes32 _proposal)
2200     external
2201     view
2202     returns (bool result)
2203   {
2204     return documentPolls[_proposal].voted[_galaxy];
2205   }
2206 
2207   //  startUpgradePoll(): open a poll on making _proposal the new ecliptic
2208   //
2209   function startUpgradePoll(address _proposal)
2210     external
2211     onlyOwner
2212   {
2213     //  _proposal must not have achieved majority before
2214     //
2215     require(!upgradeHasAchievedMajority[_proposal]);
2216 
2217     Poll storage poll = upgradePolls[_proposal];
2218 
2219     //  if the proposal is being made for the first time, register it.
2220     //
2221     if (0 == poll.start)
2222     {
2223       upgradeProposals.push(_proposal);
2224     }
2225 
2226     startPoll(poll);
2227     emit UpgradePollStarted(_proposal);
2228   }
2229 
2230   //  startDocumentPoll(): open a poll on accepting the document
2231   //                       whose hash is _proposal
2232   //
2233   function startDocumentPoll(bytes32 _proposal)
2234     external
2235     onlyOwner
2236   {
2237     //  _proposal must not have achieved majority before
2238     //
2239     require(!documentHasAchievedMajority[_proposal]);
2240 
2241     Poll storage poll = documentPolls[_proposal];
2242 
2243     //  if the proposal is being made for the first time, register it.
2244     //
2245     if (0 == poll.start)
2246     {
2247       documentProposals.push(_proposal);
2248     }
2249 
2250     startPoll(poll);
2251     emit DocumentPollStarted(_proposal);
2252   }
2253 
2254   //  startPoll(): open a new poll, or re-open an old one
2255   //
2256   function startPoll(Poll storage _poll)
2257     internal
2258   {
2259     //  check that the poll has cooled down enough to be started again
2260     //
2261     //    for completely new polls, the values used will be zero
2262     //
2263     require( block.timestamp > ( _poll.start.add(
2264                                  _poll.duration.add(
2265                                  _poll.cooldown )) ) );
2266 
2267     //  set started poll state
2268     //
2269     _poll.start = block.timestamp;
2270     delete _poll.voted;
2271     _poll.yesVotes = 0;
2272     _poll.noVotes = 0;
2273     _poll.duration = pollDuration;
2274     _poll.cooldown = pollCooldown;
2275   }
2276 
2277   //  castUpgradeVote(): as galaxy _as, cast a vote on the _proposal
2278   //
2279   //    _vote is true when in favor of the proposal, false otherwise
2280   //
2281   function castUpgradeVote(uint8 _as, address _proposal, bool _vote)
2282     external
2283     onlyOwner
2284     returns (bool majority)
2285   {
2286     Poll storage poll = upgradePolls[_proposal];
2287     processVote(poll, _as, _vote);
2288     return updateUpgradePoll(_proposal);
2289   }
2290 
2291   //  castDocumentVote(): as galaxy _as, cast a vote on the _proposal
2292   //
2293   //    _vote is true when in favor of the proposal, false otherwise
2294   //
2295   function castDocumentVote(uint8 _as, bytes32 _proposal, bool _vote)
2296     external
2297     onlyOwner
2298     returns (bool majority)
2299   {
2300     Poll storage poll = documentPolls[_proposal];
2301     processVote(poll, _as, _vote);
2302     return updateDocumentPoll(_proposal);
2303   }
2304 
2305   //  processVote(): record a vote from _as on the _poll
2306   //
2307   function processVote(Poll storage _poll, uint8 _as, bool _vote)
2308     internal
2309   {
2310     //  assist symbolic execution tools
2311     //
2312     assert(block.timestamp >= _poll.start);
2313 
2314     require( //  may only vote once
2315              //
2316              !_poll.voted[_as] &&
2317              //
2318              //  may only vote when the poll is open
2319              //
2320              (block.timestamp < _poll.start.add(_poll.duration)) );
2321 
2322     //  update poll state to account for the new vote
2323     //
2324     _poll.voted[_as] = true;
2325     if (_vote)
2326     {
2327       _poll.yesVotes = _poll.yesVotes.add(1);
2328     }
2329     else
2330     {
2331       _poll.noVotes = _poll.noVotes.add(1);
2332     }
2333   }
2334 
2335   //  updateUpgradePoll(): check whether the _proposal has achieved
2336   //                            majority, updating state, sending an event,
2337   //                            and returning true if it has
2338   //
2339   function updateUpgradePoll(address _proposal)
2340     public
2341     onlyOwner
2342     returns (bool majority)
2343   {
2344     //  _proposal must not have achieved majority before
2345     //
2346     require(!upgradeHasAchievedMajority[_proposal]);
2347 
2348     //  check for majority in the poll
2349     //
2350     Poll storage poll = upgradePolls[_proposal];
2351     majority = checkPollMajority(poll);
2352 
2353     //  if majority was achieved, update the state and send an event
2354     //
2355     if (majority)
2356     {
2357       upgradeHasAchievedMajority[_proposal] = true;
2358       emit UpgradeMajority(_proposal);
2359     }
2360     return majority;
2361   }
2362 
2363   //  updateDocumentPoll(): check whether the _proposal has achieved majority,
2364   //                        updating the state and sending an event if it has
2365   //
2366   //    this can be called by anyone, because the ecliptic does not
2367   //    need to be aware of the result
2368   //
2369   function updateDocumentPoll(bytes32 _proposal)
2370     public
2371     returns (bool majority)
2372   {
2373     //  _proposal must not have achieved majority before
2374     //
2375     require(!documentHasAchievedMajority[_proposal]);
2376 
2377     //  check for majority in the poll
2378     //
2379     Poll storage poll = documentPolls[_proposal];
2380     majority = checkPollMajority(poll);
2381 
2382     //  if majority was achieved, update state and send an event
2383     //
2384     if (majority)
2385     {
2386       documentHasAchievedMajority[_proposal] = true;
2387       documentMajorities.push(_proposal);
2388       emit DocumentMajority(_proposal);
2389     }
2390     return majority;
2391   }
2392 
2393   //  checkPollMajority(): returns true if the majority is in favor of
2394   //                       the subject of the poll
2395   //
2396   function checkPollMajority(Poll _poll)
2397     internal
2398     view
2399     returns (bool majority)
2400   {
2401     return ( //  poll must have at least the minimum required yes-votes
2402              //
2403              (_poll.yesVotes >= (totalVoters / 4)) &&
2404              //
2405              //  and have a majority...
2406              //
2407              (_poll.yesVotes > _poll.noVotes) &&
2408              //
2409              //  ...that is indisputable
2410              //
2411              ( //  either because the poll has ended
2412                //
2413                (block.timestamp > _poll.start.add(_poll.duration)) ||
2414                //
2415                //  or there are more yes votes than there can be no votes
2416                //
2417                ( _poll.yesVotes > totalVoters.sub(_poll.yesVotes) ) ) );
2418   }
2419 }
2420 
2421 // Azimuth's Claims.sol
2422 
2423 //  Claims: simple identity management
2424 //
2425 //    This contract allows points to document claims about their owner.
2426 //    Most commonly, these are about identity, with a claim's protocol
2427 //    defining the context or platform of the claim, and its dossier
2428 //    containing proof of its validity.
2429 //    Points are limited to a maximum of 16 claims.
2430 //
2431 //    For existing claims, the dossier can be updated, or the claim can
2432 //    be removed entirely. It is recommended to remove any claims associated
2433 //    with a point when it is about to be transferred to a new owner.
2434 //    For convenience, the owner of the Azimuth contract (the Ecliptic)
2435 //    is allowed to clear claims for any point, allowing it to do this for
2436 //    you on-transfer.
2437 //
2438 contract Claims is ReadsAzimuth
2439 {
2440   //  ClaimAdded: a claim was added by :by
2441   //
2442   event ClaimAdded( uint32 indexed by,
2443                     string _protocol,
2444                     string _claim,
2445                     bytes _dossier );
2446 
2447   //  ClaimRemoved: a claim was removed by :by
2448   //
2449   event ClaimRemoved(uint32 indexed by, string _protocol, string _claim);
2450 
2451   //  maxClaims: the amount of claims that can be registered per point
2452   //
2453   uint8 constant maxClaims = 16;
2454 
2455   //  Claim: claim details
2456   //
2457   struct Claim
2458   {
2459     //  protocol: context of the claim
2460     //
2461     string protocol;
2462 
2463     //  claim: the claim itself
2464     //
2465     string claim;
2466 
2467     //  dossier: data relating to the claim, as proof
2468     //
2469     bytes dossier;
2470   }
2471 
2472   //  per point, list of claims
2473   //
2474   mapping(uint32 => Claim[maxClaims]) public claims;
2475 
2476   //  constructor(): register the azimuth contract.
2477   //
2478   constructor(Azimuth _azimuth)
2479     ReadsAzimuth(_azimuth)
2480     public
2481   {
2482     //
2483   }
2484 
2485   //  addClaim(): register a claim as _point
2486   //
2487   function addClaim(uint32 _point,
2488                     string _protocol,
2489                     string _claim,
2490                     bytes _dossier)
2491     external
2492     activePointManager(_point)
2493   {
2494     //  require non-empty protocol and claim fields
2495     //
2496     require( ( 0 < bytes(_protocol).length ) &&
2497              ( 0 < bytes(_claim).length ) );
2498 
2499     //  cur: index + 1 of the claim if it already exists, 0 otherwise
2500     //
2501     uint8 cur = findClaim(_point, _protocol, _claim);
2502 
2503     //  if the claim doesn't yet exist, store it in state
2504     //
2505     if (cur == 0)
2506     {
2507       //  if there are no empty slots left, this throws
2508       //
2509       uint8 empty = findEmptySlot(_point);
2510       claims[_point][empty] = Claim(_protocol, _claim, _dossier);
2511     }
2512     //
2513     //  if the claim has been made before, update the version in state
2514     //
2515     else
2516     {
2517       claims[_point][cur-1] = Claim(_protocol, _claim, _dossier);
2518     }
2519     emit ClaimAdded(_point, _protocol, _claim, _dossier);
2520   }
2521 
2522   //  removeClaim(): unregister a claim as _point
2523   //
2524   function removeClaim(uint32 _point, string _protocol, string _claim)
2525     external
2526     activePointManager(_point)
2527   {
2528     //  i: current index + 1 in _point's list of claims
2529     //
2530     uint256 i = findClaim(_point, _protocol, _claim);
2531 
2532     //  we store index + 1, because 0 is the eth default value
2533     //  can only delete an existing claim
2534     //
2535     require(i > 0);
2536     i--;
2537 
2538     //  clear out the claim
2539     //
2540     delete claims[_point][i];
2541 
2542     emit ClaimRemoved(_point, _protocol, _claim);
2543   }
2544 
2545   //  clearClaims(): unregister all of _point's claims
2546   //
2547   //    can also be called by the ecliptic during point transfer
2548   //
2549   function clearClaims(uint32 _point)
2550     external
2551   {
2552     //  both point owner and ecliptic may do this
2553     //
2554     //    We do not necessarily need to check for _point's active flag here,
2555     //    since inactive points cannot have claims set. Doing the check
2556     //    anyway would make this function slightly harder to think about due
2557     //    to its relation to Ecliptic's transferPoint().
2558     //
2559     require( azimuth.canManage(_point, msg.sender) ||
2560              ( msg.sender == azimuth.owner() ) );
2561 
2562     Claim[maxClaims] storage currClaims = claims[_point];
2563 
2564     //  clear out all claims
2565     //
2566     for (uint8 i = 0; i < maxClaims; i++)
2567     {
2568       //  only emit the removed event if there was a claim here
2569       //
2570       if ( 0 < bytes(currClaims[i].claim).length )
2571       {
2572         emit ClaimRemoved(_point, currClaims[i].protocol, currClaims[i].claim);
2573       }
2574 
2575       delete currClaims[i];
2576     }
2577   }
2578 
2579   //  findClaim(): find the index of the specified claim
2580   //
2581   //    returns 0 if not found, index + 1 otherwise
2582   //
2583   function findClaim(uint32 _whose, string _protocol, string _claim)
2584     public
2585     view
2586     returns (uint8 index)
2587   {
2588     //  we use hashes of the string because solidity can't do string
2589     //  comparison yet
2590     //
2591     bytes32 protocolHash = keccak256(bytes(_protocol));
2592     bytes32 claimHash = keccak256(bytes(_claim));
2593     Claim[maxClaims] storage theirClaims = claims[_whose];
2594     for (uint8 i = 0; i < maxClaims; i++)
2595     {
2596       Claim storage thisClaim = theirClaims[i];
2597       if ( ( protocolHash == keccak256(bytes(thisClaim.protocol)) ) &&
2598            ( claimHash == keccak256(bytes(thisClaim.claim)) ) )
2599       {
2600         return i+1;
2601       }
2602     }
2603     return 0;
2604   }
2605 
2606   //  findEmptySlot(): find the index of the first empty claim slot
2607   //
2608   //    returns the index of the slot, throws if there are no empty slots
2609   //
2610   function findEmptySlot(uint32 _whose)
2611     internal
2612     view
2613     returns (uint8 index)
2614   {
2615     Claim[maxClaims] storage theirClaims = claims[_whose];
2616     for (uint8 i = 0; i < maxClaims; i++)
2617     {
2618       Claim storage thisClaim = theirClaims[i];
2619       if ( (0 == bytes(thisClaim.claim).length) )
2620       {
2621         return i;
2622       }
2623     }
2624     revert();
2625   }
2626 }
2627 
2628 // Treasury's ITreasuryProxy
2629 
2630 interface ITreasuryProxy {
2631   function upgradeTo(address _impl) external returns (bool);
2632 
2633   function freeze() external returns (bool);
2634 }
2635 
2636 // Azimuth's EclipticBase.sol
2637 
2638 //  EclipticBase: upgradable ecliptic
2639 //
2640 //    This contract implements the upgrade logic for the Ecliptic.
2641 //    Newer versions of the Ecliptic are expected to provide at least
2642 //    the onUpgrade() function. If they don't, upgrading to them will
2643 //    fail.
2644 //
2645 //    Note that even though this contract doesn't specify any required
2646 //    interface members aside from upgrade() and onUpgrade(), contracts
2647 //    and clients may still rely on the presence of certain functions
2648 //    provided by the Ecliptic proper. Keep this in mind when writing
2649 //    new versions of it.
2650 //
2651 contract EclipticBase is Ownable, ReadsAzimuth
2652 {
2653   //  Upgraded: _to is the new canonical Ecliptic
2654   //
2655   event Upgraded(address to);
2656 
2657   //  polls: senate voting contract
2658   //
2659   Polls public polls;
2660 
2661   //  previousEcliptic: address of the previous ecliptic this
2662   //                    instance expects to upgrade from, stored and
2663   //                    checked for to prevent unexpected upgrade paths
2664   //
2665   address public previousEcliptic;
2666 
2667   constructor( address _previous,
2668                Azimuth _azimuth,
2669                Polls _polls )
2670     ReadsAzimuth(_azimuth)
2671     internal
2672   {
2673     previousEcliptic = _previous;
2674     polls = _polls;
2675   }
2676 
2677   //  onUpgrade(): called by previous ecliptic when upgrading
2678   //
2679   //    in future ecliptics, this might perform more logic than
2680   //    just simple checks and verifications.
2681   //    when overriding this, make sure to call this original as well.
2682   //
2683   function onUpgrade()
2684     external
2685   {
2686     //  make sure this is the expected upgrade path,
2687     //  and that we have gotten the ownership we require
2688     //
2689     require( msg.sender == previousEcliptic &&
2690              this == azimuth.owner() &&
2691              this == polls.owner() );
2692   }
2693 
2694   //  upgrade(): transfer ownership of the ecliptic data to the new
2695   //             ecliptic contract, notify it, then self-destruct.
2696   //
2697   //    Note: any eth that have somehow ended up in this contract
2698   //          are also sent to the new ecliptic.
2699   //
2700   function upgrade(EclipticBase _new)
2701     internal
2702   {
2703     //  transfer ownership of the data contracts
2704     //
2705     azimuth.transferOwnership(_new);
2706     polls.transferOwnership(_new);
2707 
2708     //  trigger upgrade logic on the target contract
2709     //
2710     _new.onUpgrade();
2711 
2712     //  emit event and destroy this contract
2713     //
2714     emit Upgraded(_new);
2715     selfdestruct(_new);
2716   }
2717 }
2718 
2719 ////////////////////////////////////////////////////////////////////////////////
2720 //  Ecliptic
2721 ////////////////////////////////////////////////////////////////////////////////
2722 
2723 //  Ecliptic: logic for interacting with the Azimuth ledger
2724 //
2725 //    This contract is the point of entry for all operations on the Azimuth
2726 //    ledger as stored in the Azimuth data contract. The functions herein
2727 //    are responsible for performing all necessary business logic.
2728 //    Examples of such logic include verifying permissions of the caller
2729 //    and ensuring a requested change is actually valid.
2730 //    Point owners can always operate on their own points. Ethereum addresses
2731 //    can also perform specific operations if they've been given the
2732 //    appropriate permissions. (For example, managers for general management,
2733 //    spawn proxies for spawning child points, etc.)
2734 //
2735 //    This contract uses external contracts (Azimuth, Polls) for data storage
2736 //    so that it itself can easily be replaced in case its logic needs to
2737 //    be changed. In other words, it can be upgraded. It does this by passing
2738 //    ownership of the data contracts to a new Ecliptic contract.
2739 //
2740 //    Because of this, it is advised for clients to not store this contract's
2741 //    address directly, but rather ask the Azimuth contract for its owner
2742 //    attribute to ensure transactions get sent to the latest Ecliptic.
2743 //    Alternatively, the ENS name ecliptic.eth will resolve to the latest
2744 //    Ecliptic as well.
2745 //
2746 //    Upgrading happens based on polls held by the senate (galaxy owners).
2747 //    Through this contract, the senate can submit proposals, opening polls
2748 //    for the senate to cast votes on. These proposals can be either hashes
2749 //    of documents or addresses of new Ecliptics.
2750 //    If an ecliptic proposal gains majority, this contract will transfer
2751 //    ownership of the data storage contracts to that address, so that it may
2752 //    operate on the data they contain. This contract will selfdestruct at
2753 //    the end of the upgrade process.
2754 //
2755 //    This contract implements the ERC721 interface for non-fungible tokens,
2756 //    allowing points to be managed using generic clients that support the
2757 //    standard. It also implements ERC165 to allow this to be discovered.
2758 //
2759 contract Ecliptic is EclipticBase, SupportsInterfaceWithLookup, ERC721Metadata
2760 {
2761   using SafeMath for uint256;
2762   using AddressUtils for address;
2763 
2764   //  Transfer: This emits when ownership of any NFT changes by any mechanism.
2765   //            This event emits when NFTs are created (`from` == 0) and
2766   //            destroyed (`to` == 0). At the time of any transfer, the
2767   //            approved address for that NFT (if any) is reset to none.
2768   //
2769   event Transfer(address indexed _from, address indexed _to,
2770                  uint256 indexed _tokenId);
2771 
2772   //  Approval: This emits when the approved address for an NFT is changed or
2773   //            reaffirmed. The zero address indicates there is no approved
2774   //            address. When a Transfer event emits, this also indicates that
2775   //            the approved address for that NFT (if any) is reset to none.
2776   //
2777   event Approval(address indexed _owner, address indexed _approved,
2778                  uint256 indexed _tokenId);
2779 
2780   //  ApprovalForAll: This emits when an operator is enabled or disabled for an
2781   //                  owner. The operator can manage all NFTs of the owner.
2782   //
2783   event ApprovalForAll(address indexed _owner, address indexed _operator,
2784                        bool _approved);
2785 
2786   // erc721Received: equal to:
2787   //        bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
2788   //                 which can be also obtained as:
2789   //        ERC721Receiver(0).onERC721Received.selector`
2790   bytes4 constant erc721Received = 0x150b7a02;
2791 
2792   // depositAddress: Special address respresenting L2.  Ships sent to
2793   //                 this address are controlled on L2 instead of here.
2794   //
2795   address constant public depositAddress =
2796     0x1111111111111111111111111111111111111111;
2797 
2798   ITreasuryProxy public treasuryProxy;
2799 
2800   // treasuryUpgradeHash
2801   //   hash of the treasury implementation to upgrade to
2802   //   Note: stand-in, just hash of no bytes
2803   //   could be made immutable and passed in as constructor argument
2804   bytes32 constant public treasuryUpgradeHash = hex"26f3eae628fa1a4d23e34b91a4d412526a47620ced37c80928906f9fa07c0774";
2805 
2806   bool public treasuryUpgraded = false;
2807 
2808   //  claims: contract reference, for clearing claims on-transfer
2809   //
2810   Claims public claims;
2811 
2812   //  constructor(): set data contract addresses and signal interface support
2813   //
2814   //    Note: during first deploy, ownership of these data contracts must
2815   //    be manually transferred to this contract.
2816   //
2817   constructor(address _previous,
2818               Azimuth _azimuth,
2819               Polls _polls,
2820               Claims _claims,
2821               ITreasuryProxy _treasuryProxy)
2822     EclipticBase(_previous, _azimuth, _polls)
2823     public
2824   {
2825     claims = _claims;
2826     treasuryProxy = _treasuryProxy;
2827 
2828     //  register supported interfaces for ERC165
2829     //
2830     _registerInterface(0x80ac58cd); // ERC721
2831     _registerInterface(0x5b5e139f); // ERC721Metadata
2832     _registerInterface(0x7f5828d0); // ERC173 (ownership)
2833   }
2834 
2835   //
2836   //  ERC721 interface
2837   //
2838 
2839     //  balanceOf(): get the amount of points owned by _owner
2840     //
2841     function balanceOf(address _owner)
2842       public
2843       view
2844       returns (uint256 balance)
2845     {
2846       require(0x0 != _owner);
2847       return azimuth.getOwnedPointCount(_owner);
2848     }
2849 
2850     //  ownerOf(): get the current owner of point _tokenId
2851     //
2852     function ownerOf(uint256 _tokenId)
2853       public
2854       view
2855       validPointId(_tokenId)
2856       returns (address owner)
2857     {
2858       uint32 id = uint32(_tokenId);
2859 
2860       //  this will throw if the owner is the zero address,
2861       //  active points always have a valid owner.
2862       //
2863       require(azimuth.isActive(id));
2864 
2865       return azimuth.getOwner(id);
2866     }
2867 
2868     //  exists(): returns true if point _tokenId is active
2869     //
2870     function exists(uint256 _tokenId)
2871       public
2872       view
2873       returns (bool doesExist)
2874     {
2875       return ( (_tokenId < 0x100000000) &&
2876                azimuth.isActive(uint32(_tokenId)) );
2877     }
2878 
2879     //  safeTransferFrom(): transfer point _tokenId from _from to _to
2880     //
2881     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
2882       public
2883     {
2884       //  transfer with empty data
2885       //
2886       safeTransferFrom(_from, _to, _tokenId, "");
2887     }
2888 
2889     //  safeTransferFrom(): transfer point _tokenId from _from to _to,
2890     //                      and call recipient if it's a contract
2891     //
2892     function safeTransferFrom(address _from, address _to, uint256 _tokenId,
2893                               bytes _data)
2894       public
2895     {
2896       //  perform raw transfer
2897       //
2898       transferFrom(_from, _to, _tokenId);
2899 
2900       //  do the callback last to avoid re-entrancy
2901       //
2902       if (_to.isContract())
2903       {
2904         bytes4 retval = ERC721Receiver(_to)
2905                         .onERC721Received(msg.sender, _from, _tokenId, _data);
2906         //
2907         //  standard return idiom to confirm contract semantics
2908         //
2909         require(retval == erc721Received);
2910       }
2911     }
2912 
2913     //  transferFrom(): transfer point _tokenId from _from to _to,
2914     //                  WITHOUT notifying recipient contract
2915     //
2916     function transferFrom(address _from, address _to, uint256 _tokenId)
2917       public
2918       validPointId(_tokenId)
2919     {
2920       uint32 id = uint32(_tokenId);
2921       require(azimuth.isOwner(id, _from));
2922 
2923       //  the ERC721 operator/approved address (if any) is
2924       //  accounted for in transferPoint()
2925       //
2926       transferPoint(id, _to, true);
2927     }
2928 
2929     //  approve(): allow _approved to transfer ownership of point
2930     //             _tokenId
2931     //
2932     function approve(address _approved, uint256 _tokenId)
2933       public
2934       validPointId(_tokenId)
2935     {
2936       setTransferProxy(uint32(_tokenId), _approved);
2937     }
2938 
2939     //  setApprovalForAll(): allow or disallow _operator to
2940     //                       transfer ownership of ALL points
2941     //                       owned by :msg.sender
2942     //
2943     function setApprovalForAll(address _operator, bool _approved)
2944       public
2945     {
2946       require(0x0 != _operator);
2947       azimuth.setOperator(msg.sender, _operator, _approved);
2948       emit ApprovalForAll(msg.sender, _operator, _approved);
2949     }
2950 
2951     //  getApproved(): get the approved address for point _tokenId
2952     //
2953     function getApproved(uint256 _tokenId)
2954       public
2955       view
2956       validPointId(_tokenId)
2957       returns (address approved)
2958     {
2959       //NOTE  redundant, transfer proxy cannot be set for
2960       //      inactive points
2961       //
2962       require(azimuth.isActive(uint32(_tokenId)));
2963       return azimuth.getTransferProxy(uint32(_tokenId));
2964     }
2965 
2966     //  isApprovedForAll(): returns true if _operator is an
2967     //                      operator for _owner
2968     //
2969     function isApprovedForAll(address _owner, address _operator)
2970       public
2971       view
2972       returns (bool result)
2973     {
2974       return azimuth.isOperator(_owner, _operator);
2975     }
2976 
2977   //
2978   //  ERC721Metadata interface
2979   //
2980 
2981     //  name(): returns the name of a collection of points
2982     //
2983     function name()
2984       external
2985       view
2986       returns (string)
2987     {
2988       return "Azimuth Points";
2989     }
2990 
2991     //  symbol(): returns an abbreviates name for points
2992     //
2993     function symbol()
2994       external
2995       view
2996       returns (string)
2997     {
2998       return "AZP";
2999     }
3000 
3001     //  tokenURI(): returns a URL to an ERC-721 standard JSON file
3002     //
3003     function tokenURI(uint256 _tokenId)
3004       public
3005       view
3006       validPointId(_tokenId)
3007       returns (string _tokenURI)
3008     {
3009       _tokenURI = "https://azimuth.network/erc721/0000000000.json";
3010       bytes memory _tokenURIBytes = bytes(_tokenURI);
3011       _tokenURIBytes[31] = byte(48+(_tokenId / 1000000000) % 10);
3012       _tokenURIBytes[32] = byte(48+(_tokenId / 100000000) % 10);
3013       _tokenURIBytes[33] = byte(48+(_tokenId / 10000000) % 10);
3014       _tokenURIBytes[34] = byte(48+(_tokenId / 1000000) % 10);
3015       _tokenURIBytes[35] = byte(48+(_tokenId / 100000) % 10);
3016       _tokenURIBytes[36] = byte(48+(_tokenId / 10000) % 10);
3017       _tokenURIBytes[37] = byte(48+(_tokenId / 1000) % 10);
3018       _tokenURIBytes[38] = byte(48+(_tokenId / 100) % 10);
3019       _tokenURIBytes[39] = byte(48+(_tokenId / 10) % 10);
3020       _tokenURIBytes[40] = byte(48+(_tokenId / 1) % 10);
3021     }
3022 
3023   //
3024   //  Points interface
3025   //
3026 
3027     //  configureKeys(): configure _point with network public keys
3028     //                   _encryptionKey, _authenticationKey,
3029     //                   and corresponding _cryptoSuiteVersion,
3030     //                   incrementing the point's continuity number if needed
3031     //
3032     function configureKeys(uint32 _point,
3033                            bytes32 _encryptionKey,
3034                            bytes32 _authenticationKey,
3035                            uint32 _cryptoSuiteVersion,
3036                            bool _discontinuous)
3037       external
3038       activePointManager(_point)
3039       onL1(_point)
3040     {
3041       if (_discontinuous)
3042       {
3043         azimuth.incrementContinuityNumber(_point);
3044       }
3045       azimuth.setKeys(_point,
3046                       _encryptionKey,
3047                       _authenticationKey,
3048                       _cryptoSuiteVersion);
3049     }
3050 
3051     //  spawn(): spawn _point, then either give, or allow _target to take,
3052     //           ownership of _point
3053     //
3054     //    if _target is the :msg.sender, _targets owns the _point right away.
3055     //    otherwise, _target becomes the transfer proxy of _point.
3056     //
3057     //    Requirements:
3058     //    - _point must not be active
3059     //    - _point must not be a planet with a galaxy prefix
3060     //    - _point's prefix must be linked and under its spawn limit
3061     //    - :msg.sender must be either the owner of _point's prefix,
3062     //      or an authorized spawn proxy for it
3063     //
3064     function spawn(uint32 _point, address _target)
3065       external
3066     {
3067       //  only currently unowned (and thus also inactive) points can be spawned
3068       //
3069       require(azimuth.isOwner(_point, 0x0));
3070 
3071       //  prefix: half-width prefix of _point
3072       //
3073       uint16 prefix = azimuth.getPrefix(_point);
3074 
3075       //  can't spawn if we deposited ownership or spawn rights to L2
3076       //
3077       require( depositAddress != azimuth.getOwner(prefix) );
3078       require( depositAddress != azimuth.getSpawnProxy(prefix) );
3079 
3080       //  only allow spawning of points of the size directly below the prefix
3081       //
3082       //    this is possible because of how the address space works,
3083       //    but supporting it introduces complexity through broken assumptions.
3084       //
3085       //    example:
3086       //    0x0000.0000 - galaxy zero
3087       //    0x0000.0100 - the first star of galaxy zero
3088       //    0x0001.0100 - the first planet of the first star
3089       //    0x0001.0000 - the first planet of galaxy zero
3090       //
3091       require( (uint8(azimuth.getPointSize(prefix)) + 1) ==
3092                uint8(azimuth.getPointSize(_point)) );
3093 
3094       //  prefix point must be linked and able to spawn
3095       //
3096       require( (azimuth.hasBeenLinked(prefix)) &&
3097                ( azimuth.getSpawnCount(prefix) <
3098                  getSpawnLimit(prefix, block.timestamp) ) );
3099 
3100       //  the owner of a prefix can always spawn its children;
3101       //  other addresses need explicit permission (the role
3102       //  of "spawnProxy" in the Azimuth contract)
3103       //
3104       require( azimuth.canSpawnAs(prefix, msg.sender) );
3105 
3106       //  if the caller is spawning the point to themselves,
3107       //  assume it knows what it's doing and resolve right away
3108       //
3109       if (msg.sender == _target)
3110       {
3111         doSpawn(_point, _target, true, 0x0);
3112       }
3113       //
3114       //  when sending to a "foreign" address, enforce a withdraw pattern
3115       //  making the _point prefix's owner the _point owner in the mean time
3116       //
3117       else
3118       {
3119         doSpawn(_point, _target, false, azimuth.getOwner(prefix));
3120       }
3121     }
3122 
3123     //  doSpawn(): actual spawning logic, used in spawn(). creates _point,
3124     //             making the _target its owner if _direct, or making the
3125     //             _holder the owner and the _target the transfer proxy
3126     //             if not _direct.
3127     //
3128     function doSpawn( uint32 _point,
3129                       address _target,
3130                       bool _direct,
3131                       address _holder )
3132       internal
3133     {
3134       //  register the spawn for _point's prefix, incrementing spawn count
3135       //
3136       azimuth.registerSpawned(_point);
3137 
3138       //  if the spawn is _direct, assume _target knows what they're doing
3139       //  and resolve right away
3140       //
3141       if (_direct)
3142       {
3143         //  make the point active and set its new owner
3144         //
3145         azimuth.activatePoint(_point);
3146         azimuth.setOwner(_point, _target);
3147 
3148         emit Transfer(0x0, _target, uint256(_point));
3149       }
3150       //
3151       //  when spawning indirectly, enforce a withdraw pattern by approving
3152       //  the _target for transfer of the _point instead.
3153       //  we make the _holder the owner of this _point in the mean time,
3154       //  so that it may cancel the transfer (un-approve) if _target flakes.
3155       //  we don't make _point active yet, because it still doesn't really
3156       //  belong to anyone.
3157       //
3158       else
3159       {
3160         //  have _holder hold on to the _point while _target gets to transfer
3161         //  ownership of it
3162         //
3163         azimuth.setOwner(_point, _holder);
3164         azimuth.setTransferProxy(_point, _target);
3165 
3166         emit Transfer(0x0, _holder, uint256(_point));
3167         emit Approval(_holder, _target, uint256(_point));
3168       }
3169     }
3170 
3171     //  transferPoint(): transfer _point to _target, clearing all permissions
3172     //                   data and keys if _reset is true
3173     //
3174     //    Note: the _reset flag is useful when transferring the point to
3175     //    a recipient who doesn't trust the previous owner.
3176     //
3177     //    We know _point is not on L2, since otherwise its owner would be
3178     //    depositAddress (which has no operator) and its transfer proxy
3179     //    would be zero.
3180     //
3181     //    Requirements:
3182     //    - :msg.sender must be either _point's current owner, authorized
3183     //      to transfer _point, or authorized to transfer the current
3184     //      owner's points (as in ERC721's operator)
3185     //    - _target must not be the zero address
3186     //
3187     function transferPoint(uint32 _point, address _target, bool _reset)
3188       public
3189     {
3190       //  transfer is legitimate if the caller is the current owner, or
3191       //  an operator for the current owner, or the _point's transfer proxy
3192       //
3193       require(azimuth.canTransfer(_point, msg.sender));
3194 
3195       //  can't deposit galaxy to L2
3196       //  can't deposit contract-owned point to L2
3197       //
3198       require( depositAddress != _target ||
3199                ( azimuth.getPointSize(_point) != Azimuth.Size.Galaxy &&
3200                  !azimuth.getOwner(_point).isContract() ) );
3201 
3202       //  if the point wasn't active yet, that means transferring it
3203       //  is part of the "spawn" flow, so we need to activate it
3204       //
3205       if ( !azimuth.isActive(_point) )
3206       {
3207         azimuth.activatePoint(_point);
3208       }
3209 
3210       //  if the owner would actually change, change it
3211       //
3212       //    the only time this deliberately wouldn't be the case is when a
3213       //    prefix owner wants to activate a spawned but untransferred child.
3214       //
3215       if ( !azimuth.isOwner(_point, _target) )
3216       {
3217         //  remember the previous owner, to be included in the Transfer event
3218         //
3219         address old = azimuth.getOwner(_point);
3220 
3221         azimuth.setOwner(_point, _target);
3222 
3223         //  according to ERC721, the approved address (here, transfer proxy)
3224         //  gets cleared during every Transfer event
3225         //
3226         //  we also rely on this so that transfer-related functions don't need
3227         //  to verify the point is on L1
3228         //
3229         azimuth.setTransferProxy(_point, 0);
3230 
3231         emit Transfer(old, _target, uint256(_point));
3232       }
3233 
3234       //  if we're depositing to L2, clear L1 data so that no proxies
3235       //  can be used
3236       //
3237       if ( depositAddress == _target )
3238       {
3239         azimuth.setKeys(_point, 0, 0, 0);
3240         azimuth.setManagementProxy(_point, 0);
3241         azimuth.setVotingProxy(_point, 0);
3242         azimuth.setTransferProxy(_point, 0);
3243         azimuth.setSpawnProxy(_point, 0);
3244         claims.clearClaims(_point);
3245         azimuth.cancelEscape(_point);
3246       }
3247       //  reset sensitive data
3248       //  used when transferring the point to a new owner
3249       //
3250       else if ( _reset )
3251       {
3252         //  clear the network public keys and break continuity,
3253         //  but only if the point has already been linked
3254         //
3255         if ( azimuth.hasBeenLinked(_point) )
3256         {
3257           azimuth.incrementContinuityNumber(_point);
3258           azimuth.setKeys(_point, 0, 0, 0);
3259         }
3260 
3261         //  clear management proxy
3262         //
3263         azimuth.setManagementProxy(_point, 0);
3264 
3265         //  clear voting proxy
3266         //
3267         azimuth.setVotingProxy(_point, 0);
3268 
3269         //  clear transfer proxy
3270         //
3271         //    in most cases this is done above, during the ownership transfer,
3272         //    but we might not hit that and still be expected to reset the
3273         //    transfer proxy.
3274         //    doing it a second time is a no-op in Azimuth.
3275         //
3276         azimuth.setTransferProxy(_point, 0);
3277 
3278         //  clear spawning proxy
3279         //
3280         //    don't clear if the spawn rights have been deposited to L2,
3281         //
3282         if ( depositAddress != azimuth.getSpawnProxy(_point) )
3283         {
3284           azimuth.setSpawnProxy(_point, 0);
3285         }
3286 
3287         //  clear claims
3288         //
3289         claims.clearClaims(_point);
3290       }
3291     }
3292 
3293     //  escape(): request escape as _point to _sponsor
3294     //
3295     //    if an escape request is already active, this overwrites
3296     //    the existing request
3297     //
3298     //    Requirements:
3299     //    - :msg.sender must be the owner or manager of _point,
3300     //    - _point must be able to escape to _sponsor as per to canEscapeTo()
3301     //
3302     function escape(uint32 _point, uint32 _sponsor)
3303       external
3304       activePointManager(_point)
3305       onL1(_point)
3306     {
3307       //  if the sponsor is on L2, we need to escape using L2
3308       //
3309       require( depositAddress != azimuth.getOwner(_sponsor) );
3310 
3311       require(canEscapeTo(_point, _sponsor));
3312       azimuth.setEscapeRequest(_point, _sponsor);
3313     }
3314 
3315     //  cancelEscape(): cancel the currently set escape for _point
3316     //
3317     function cancelEscape(uint32 _point)
3318       external
3319       activePointManager(_point)
3320     {
3321       azimuth.cancelEscape(_point);
3322     }
3323 
3324     //  adopt(): as the relevant sponsor, accept the _point
3325     //
3326     //    Requirements:
3327     //    - :msg.sender must be the owner or management proxy
3328     //      of _point's requested sponsor
3329     //
3330     function adopt(uint32 _point)
3331       external
3332       onL1(_point)
3333     {
3334       uint32 request = azimuth.getEscapeRequest(_point);
3335       require( azimuth.isEscaping(_point) &&
3336                azimuth.canManage( request, msg.sender ) );
3337       require( depositAddress != azimuth.getOwner(request) );
3338 
3339       //  _sponsor becomes _point's sponsor
3340       //  its escape request is reset to "not escaping"
3341       //
3342       azimuth.doEscape(_point);
3343     }
3344 
3345     //  reject(): as the relevant sponsor, deny the _point's request
3346     //
3347     //    Requirements:
3348     //    - :msg.sender must be the owner or management proxy
3349     //      of _point's requested sponsor
3350     //
3351     function reject(uint32 _point)
3352       external
3353     {
3354       uint32 request = azimuth.getEscapeRequest(_point);
3355       require( azimuth.isEscaping(_point) &&
3356                azimuth.canManage( request, msg.sender ) );
3357       require( depositAddress != azimuth.getOwner(request) );
3358 
3359       //  reset the _point's escape request to "not escaping"
3360       //
3361       azimuth.cancelEscape(_point);
3362     }
3363 
3364     //  detach(): as the _sponsor, stop sponsoring the _point
3365     //
3366     //    Requirements:
3367     //    - :msg.sender must be the owner or management proxy
3368     //      of _point's current sponsor
3369     //
3370     //    We allow detachment even of points that are on L2.   This is
3371     //    so that a star controlled by a contract can detach from a
3372     //    planet which was on L1 originally but now is on L2.  L2 will
3373     //    ignore this if this is not the actual sponsor anymore (i.e. if
3374     //    they later changed their sponsor on L2).
3375     //
3376     function detach(uint32 _point)
3377       external
3378     {
3379       uint32 sponsor = azimuth.getSponsor(_point);
3380       require( azimuth.hasSponsor(_point) &&
3381                azimuth.canManage(sponsor, msg.sender) );
3382       require( depositAddress != azimuth.getOwner(sponsor) );
3383 
3384       //  signal that its sponsor no longer supports _point
3385       //
3386       azimuth.loseSponsor(_point);
3387     }
3388 
3389   //
3390   //  Point rules
3391   //
3392 
3393     //  getSpawnLimit(): returns the total number of children the _point
3394     //                   is allowed to spawn at _time.
3395     //
3396     function getSpawnLimit(uint32 _point, uint256 _time)
3397       public
3398       view
3399       returns (uint32 limit)
3400     {
3401       Azimuth.Size size = azimuth.getPointSize(_point);
3402 
3403       if ( size == Azimuth.Size.Galaxy )
3404       {
3405         return 255;
3406       }
3407       else if ( size == Azimuth.Size.Star )
3408       {
3409         //  in 2019, stars may spawn at most 1024 planets. this limit doubles
3410         //  for every subsequent year.
3411         //
3412         //    Note: 1546300800 corresponds to 2019-01-01
3413         //
3414         uint256 yearsSince2019 = (_time - 1546300800) / 365 days;
3415         if (yearsSince2019 < 6)
3416         {
3417           limit = uint32( 1024 * (2 ** yearsSince2019) );
3418         }
3419         else
3420         {
3421           limit = 65535;
3422         }
3423         return limit;
3424       }
3425       else  //  size == Azimuth.Size.Planet
3426       {
3427         //  planets can create moons, but moons aren't on the chain
3428         //
3429         return 0;
3430       }
3431     }
3432 
3433     //  canEscapeTo(): true if _point could try to escape to _sponsor
3434     //
3435     function canEscapeTo(uint32 _point, uint32 _sponsor)
3436       public
3437       view
3438       returns (bool canEscape)
3439     {
3440       //  can't escape to a sponsor that hasn't been linked
3441       //
3442       if ( !azimuth.hasBeenLinked(_sponsor) ) return false;
3443 
3444       //  Can only escape to a point one size higher than ourselves,
3445       //  except in the special case where the escaping point hasn't
3446       //  been linked yet -- in that case we may escape to points of
3447       //  the same size, to support lightweight invitation chains.
3448       //
3449       //  The use case for lightweight invitations is that a planet
3450       //  owner should be able to invite their friends onto an
3451       //  Azimuth network in a two-party transaction, without a new
3452       //  star relationship.
3453       //  The lightweight invitation process works by escaping your
3454       //  own active (but never linked) point to one of your own
3455       //  points, then transferring the point to your friend.
3456       //
3457       //  These planets can, in turn, sponsor other unlinked planets,
3458       //  so the "planet sponsorship chain" can grow to arbitrary
3459       //  length. Most users, especially deep down the chain, will
3460       //  want to improve their performance by switching to direct
3461       //  star sponsors eventually.
3462       //
3463       Azimuth.Size pointSize = azimuth.getPointSize(_point);
3464       Azimuth.Size sponsorSize = azimuth.getPointSize(_sponsor);
3465       return ( //  normal hierarchical escape structure
3466                //
3467                ( (uint8(sponsorSize) + 1) == uint8(pointSize) ) ||
3468                //
3469                //  special peer escape
3470                //
3471                ( (sponsorSize == pointSize) &&
3472                  //
3473                  //  peer escape is only for points that haven't been linked
3474                  //  yet, because it's only for lightweight invitation chains
3475                  //
3476                  !azimuth.hasBeenLinked(_point) ) );
3477     }
3478 
3479   //
3480   //  Permission management
3481   //
3482 
3483     //  setManagementProxy(): configure the management proxy for _point
3484     //
3485     //    The management proxy may perform "reversible" operations on
3486     //    behalf of the owner. This includes public key configuration and
3487     //    operations relating to sponsorship.
3488     //
3489     function setManagementProxy(uint32 _point, address _manager)
3490       external
3491       activePointManager(_point)
3492       onL1(_point)
3493     {
3494       azimuth.setManagementProxy(_point, _manager);
3495     }
3496 
3497     //  setSpawnProxy(): give _spawnProxy the right to spawn points
3498     //                   with the prefix _prefix
3499     //
3500     //    takes a uint16 so that we can't set spawn proxy for a planet
3501     //
3502     //    fails if spawn rights have been deposited to L2
3503     //
3504     function setSpawnProxy(uint16 _prefix, address _spawnProxy)
3505       external
3506       activePointSpawner(_prefix)
3507       onL1(_prefix)
3508     {
3509       require( depositAddress != azimuth.getSpawnProxy(_prefix) );
3510 
3511       azimuth.setSpawnProxy(_prefix, _spawnProxy);
3512     }
3513 
3514     //  setVotingProxy(): configure the voting proxy for _galaxy
3515     //
3516     //    the voting proxy is allowed to start polls and cast votes
3517     //    on the point's behalf.
3518     //
3519     function setVotingProxy(uint8 _galaxy, address _voter)
3520       external
3521       activePointVoter(_galaxy)
3522     {
3523       azimuth.setVotingProxy(_galaxy, _voter);
3524     }
3525 
3526     //  setTransferProxy(): give _transferProxy the right to transfer _point
3527     //
3528     //    Requirements:
3529     //    - :msg.sender must be either _point's current owner,
3530     //      or be an operator for the current owner
3531     //
3532     function setTransferProxy(uint32 _point, address _transferProxy)
3533       public
3534       onL1(_point)
3535     {
3536       //  owner: owner of _point
3537       //
3538       address owner = azimuth.getOwner(_point);
3539 
3540       //  caller must be :owner, or an operator designated by the owner.
3541       //
3542       require((owner == msg.sender) || azimuth.isOperator(owner, msg.sender));
3543 
3544       //  set transfer proxy field in Azimuth contract
3545       //
3546       azimuth.setTransferProxy(_point, _transferProxy);
3547 
3548       //  emit Approval event
3549       //
3550       emit Approval(owner, _transferProxy, uint256(_point));
3551     }
3552 
3553   //
3554   //  Poll actions
3555   //
3556 
3557     //  startUpgradePoll(): as _galaxy, start a poll for the ecliptic
3558     //                      upgrade _proposal
3559     //
3560     //    Requirements:
3561     //    - :msg.sender must be the owner or voting proxy of _galaxy,
3562     //    - the _proposal must expect to be upgraded from this specific
3563     //      contract, as indicated by its previousEcliptic attribute
3564     //
3565     function startUpgradePoll(uint8 _galaxy, EclipticBase _proposal)
3566       external
3567       activePointVoter(_galaxy)
3568     {
3569       //  ensure that the upgrade target expects this contract as the source
3570       //
3571       require(_proposal.previousEcliptic() == address(this));
3572       polls.startUpgradePoll(_proposal);
3573     }
3574 
3575     //  startDocumentPoll(): as _galaxy, start a poll for the _proposal
3576     //
3577     //    the _proposal argument is the keccak-256 hash of any arbitrary
3578     //    document or string of text
3579     //
3580     function startDocumentPoll(uint8 _galaxy, bytes32 _proposal)
3581       external
3582       activePointVoter(_galaxy)
3583     {
3584       polls.startDocumentPoll(_proposal);
3585     }
3586 
3587     //  castUpgradeVote(): as _galaxy, cast a _vote on the ecliptic
3588     //                     upgrade _proposal
3589     //
3590     //    _vote is true when in favor of the proposal, false otherwise
3591     //
3592     //    If this vote results in a majority for the _proposal, it will
3593     //    be upgraded to immediately.
3594     //
3595     function castUpgradeVote(uint8 _galaxy,
3596                               EclipticBase _proposal,
3597                               bool _vote)
3598       external
3599       activePointVoter(_galaxy)
3600     {
3601       //  majority: true if the vote resulted in a majority, false otherwise
3602       //
3603       bool majority = polls.castUpgradeVote(_galaxy, _proposal, _vote);
3604 
3605       //  if a majority is in favor of the upgrade, it happens as defined
3606       //  in the ecliptic base contract
3607       //
3608       if (majority)
3609       {
3610         upgrade(_proposal);
3611       }
3612     }
3613 
3614     //  castDocumentVote(): as _galaxy, cast a _vote on the _proposal
3615     //
3616     //    _vote is true when in favor of the proposal, false otherwise
3617     //
3618     function castDocumentVote(uint8 _galaxy, bytes32 _proposal, bool _vote)
3619       external
3620       activePointVoter(_galaxy)
3621     {
3622       polls.castDocumentVote(_galaxy, _proposal, _vote);
3623     }
3624 
3625     //  updateUpgradePoll(): check whether the _proposal has achieved
3626     //                      majority, upgrading to it if it has
3627     //
3628     function updateUpgradePoll(EclipticBase _proposal)
3629       external
3630     {
3631       //  majority: true if the poll ended in a majority, false otherwise
3632       //
3633       bool majority = polls.updateUpgradePoll(_proposal);
3634 
3635       //  if a majority is in favor of the upgrade, it happens as defined
3636       //  in the ecliptic base contract
3637       //
3638       if (majority)
3639       {
3640         upgrade(_proposal);
3641       }
3642     }
3643 
3644     //  updateDocumentPoll(): check whether the _proposal has achieved majority
3645     //
3646     //    Note: the polls contract publicly exposes the function this calls,
3647     //    but we offer it in the ecliptic interface as a convenience
3648     //
3649     function updateDocumentPoll(bytes32 _proposal)
3650       external
3651     {
3652       polls.updateDocumentPoll(_proposal);
3653     }
3654 
3655     //  upgradeTreasury: upgrade implementation for treasury
3656     //
3657     //    Note: we specify when deploying Ecliptic the keccak hash
3658     //    of the implementation we're upgrading to
3659     //
3660     function upgradeTreasury(address _treasuryImpl) external {
3661       require(!treasuryUpgraded);
3662       require(keccak256(_treasuryImpl) == treasuryUpgradeHash);
3663       treasuryProxy.upgradeTo(_treasuryImpl);
3664       treasuryUpgraded = true;
3665     }
3666 
3667   //
3668   //  Contract owner operations
3669   //
3670 
3671     //  createGalaxy(): grant _target ownership of the _galaxy and register
3672     //                  it for voting
3673     //
3674     function createGalaxy(uint8 _galaxy, address _target)
3675       external
3676       onlyOwner
3677     {
3678       //  only currently unowned (and thus also inactive) galaxies can be
3679       //  created, and only to non-zero addresses
3680       //
3681       require( azimuth.isOwner(_galaxy, 0x0) &&
3682                0x0 != _target );
3683 
3684       //  new galaxy means a new registered voter
3685       //
3686       polls.incrementTotalVoters();
3687 
3688       //  if the caller is sending the galaxy to themselves,
3689       //  assume it knows what it's doing and resolve right away
3690       //
3691       if (msg.sender == _target)
3692       {
3693         doSpawn(_galaxy, _target, true, 0x0);
3694       }
3695       //
3696       //  when sending to a "foreign" address, enforce a withdraw pattern,
3697       //  making the caller the owner in the mean time
3698       //
3699       else
3700       {
3701         doSpawn(_galaxy, _target, false, msg.sender);
3702       }
3703     }
3704 
3705     function setDnsDomains(string _primary, string _secondary, string _tertiary)
3706       external
3707       onlyOwner
3708     {
3709       azimuth.setDnsDomains(_primary, _secondary, _tertiary);
3710     }
3711 
3712   //
3713   //  Function modifiers for this contract
3714   //
3715 
3716     //  validPointId(): require that _id is a valid point
3717     //
3718     modifier validPointId(uint256 _id)
3719     {
3720       require(_id < 0x100000000);
3721       _;
3722     }
3723 
3724     // onL1(): require that ship is not deposited
3725     modifier onL1(uint32 _point)
3726     {
3727       require( depositAddress != azimuth.getOwner(_point) );
3728       _;
3729     }
3730 }